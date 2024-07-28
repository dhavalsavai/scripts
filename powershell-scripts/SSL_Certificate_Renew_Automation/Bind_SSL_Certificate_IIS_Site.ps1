# Variables
$SiteName = "test"
$PfxFilePath = "C:\GitLab-Runner\SSL\certificate.pfx"
$subject = "*.example.com"
$hostName = "test.example.com"


$storeLocation = "Cert:\LocalMachine\My"
$bindingInformation = "*:443:" + $hostName

# step 1
# Removing existing SSL Certificate on IIS - Server Certificates -Scripts

# Get certificates matching the subject
$certs = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like $subject }

# Check if certificates found and remove them
if ($certs) {
    foreach ($cert in $certs) {
        Remove-Item -Path "Cert:\LocalMachine\My\$($cert.Thumbprint)" -Force
        Write-Host "Certificate with subject '$($cert.Subject)' and thumbprint '$($cert.Thumbprint)' removed successfully."
    }
} else {
    Write-Host "Certificate with subject '$subject' not found."
}

# step 2

# Import new Issued SSL certificate on IIS Server SSL cerfificate 



# Import the new PFX certificate (without password)
$cert = Import-PfxCertificate -CertStoreLocation Cert:\LocalMachine\My -FilePath $PfxFilePath

if ($cert) {
    Write-Host "New PFX certificate imported successfully."
} else {
    Write-Host "Failed to import the new PFX certificate."
    return
}

# step 3

# Get Latest Issued SSL Certificate  thumbprint 

# Define the subject of the certificate to find
$subject = "*.example.com"

# Get certificates matching the subject
Write-Host "All CertiThubs"
Get-ChildItem -Path Cert:\LocalMachine\My

$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like $subject }

Write-Host "Selected Certi"
Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -like $subject }
Write-Host $cert.Thumbprint

# Check if certificate found
if ($cert) {
    $thumbprint = $cert.Thumbprint
    Write-Host "Thumbprint of certificate with subject '$subject' is: $thumbprint"
} else {
    Write-Host "Certificate with subject '$subject' not found."
}

# Remove existing SSL binding (if any)
#netsh http delete sslcert ipport=0.0.0.0:443
Remove-IISSiteBinding -Name "test" -BindingInformation $bindingInformation -Protocol https -RemoveConfigOnly -Confirm:$false

# Add new SSL binding
$certificatePath = ("cert:\localmachine\my\" + $certificate.Thumbprint)

New-IISSiteBinding -Name "dktest" -BindingInformation $bindingInformation -CertificateThumbPrint $thumbPrint -CertStoreLocation $storeLocation -Protocol https -Force
