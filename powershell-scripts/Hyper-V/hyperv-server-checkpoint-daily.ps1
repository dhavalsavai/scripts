# Hyper-V Snapshot PowerShell Script
$VMName = "VM_Name"
$Timestamp = Get-Date -Format "yyyyMMddHHmmss"

$SnapshotName = "DailySnapshot_$Timestamp"

Checkpoint-VM -Name $VMName -SnapshotName $SnapshotName

echo "Daily Snapshot Created Successfully"
