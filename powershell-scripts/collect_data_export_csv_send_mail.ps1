# Define SQL Server connection parameters
$server = "1.2.3.4"
$database = "db_name"
$username = "user_name"
$password = "pwd"

# Define SQL query
$query = @"
DECLARE @ResourceNamePattern NVARCHAR(100)
DECLARE @QueryDate DATE

SET @QueryDate = CAST(GETDATE() AS DATE)  -- Use the current date

SELECT 
    rs.ResourceName AS ResourceName,
    @QueryDate AS QueryDate,
    SUM(DATEDIFF(SECOND, pr.FromTime, pr.ToTime)) AS timeLogs_seconds,
    CONVERT(VARCHAR(2), SUM(DATEDIFF(SECOND, pr.FromTime, pr.ToTime)) / 3600) + ':' +
    RIGHT('0' + CONVERT(VARCHAR(2), (SUM(DATEDIFF(SECOND, pr.FromTime, pr.ToTime)) % 3600) / 60), 2) + ':' +
    RIGHT('0' + CONVERT(VARCHAR(2), SUM(DATEDIFF(SECOND, pr.FromTime, pr.ToTime)) % 60), 2) AS formatted_time
FROM 
    productivitySummary pr
INNER JOIN 
    Resources rs ON rs.ID = pr.ResourceId
WHERE  
    CAST(pr.FromTime AS DATE) = @QueryDate
GROUP BY 
    rs.ResourceName
HAVING
    SUM(DATEDIFF(SECOND, pr.FromTime, pr.ToTime)) < 25200  -- 7 hours * 60 minutes * 60 seconds
ORDER BY 
    timeLogs_seconds DESC;

"@

# Define output file path with timestamp
$timestamp = Get-Date -Format "yyyyMMdd"
$csvFilePath = "C:\automation\${timestamp}_daily_logs.csv"

# Execute SQL query and save result to CSV file
sqlcmd -S $server -d $database -U $username -P $password -Q $query -s "," -o $csvFilePath

echo "Data collected from the database."

# Zoho SMTP Configuration
$smtpServer = "smtp.zoho.com"
$smtpPort = 587
$username = "user1@example.com"
$password = "tech123"
$fromAddress = "user1@example.com"
$toAddress = "user2@example.com"
$ccAddress = "user1@example.com"
$subject = "Daily Report Less than Logged Hours in Workflow Pulse Application"
$body = "Please find attached who have logged less than 7 hours in Workflow Pulse Application."

# Attach the file
$attachment = New-Object System.Net.Mail.Attachment($csvFilePath)

# Create a secure string for the password
$securePassword = ConvertTo-SecureString $password -AsPlainText -Force

# Create PSCredential object
$credential = New-Object Management.Automation.PSCredential ($username, $securePassword)

# Create email message
$mailMessage = New-Object System.Net.Mail.MailMessage
$mailMessage.From = $fromAddress
$mailMessage.To.Add($toAddress)
$mailMessage.CC.Add($ccAddress) 
$mailMessage.Subject = $subject
$mailMessage.Body = $body

# Attach the file
$mailMessage.Attachments.Add($attachment)

# Set up SMTP client
$smtpClient = New-Object Net.Mail.SmtpClient($smtpServer, $smtpPort)
$smtpClient.EnableSsl = $true
$smtpClient.Credentials = $credential

# Send the email
$smtpClient.Send($mailMessage)

# Dispose of the attachment
$attachment.Dispose()

echo "Mail with attachment sent successfully!"
