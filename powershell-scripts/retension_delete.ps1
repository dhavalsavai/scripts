$directoryPath = "C:\inetpub\tab_recordinfo\AppData\PMS\Attachments\Files"
$maxSizeInMB = 2

# Get files larger than 2 MB in the specified directory
$filesToDelete = Get-ChildItem -Path $directoryPath | Where-Object { $_.Length -gt ($maxSizeInMB * 1MB) }

# Delete each file
foreach ($file in $filesToDelete) {
    Remove-Item $file.FullName -Force
    Write-Host "Deleted: $($file.FullName)"
}
