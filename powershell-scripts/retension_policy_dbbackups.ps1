 Get-ChildItem -Path "E:\DatabaseBackups" -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-15) } | Remove-Item -Force