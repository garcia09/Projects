
#-----Variables-----

$computer = Read-Host "Enter Computer name (See inventory sheet for next number. Ex: Kranz-LT-xxx)"

$oldname = $env:computername

Write-Host "=========== Renaming Computer =========="
Rename-Computer -ComputerName $oldname -NewName $computer
write-host "Name has been changed to: $computer"
write-host
write-host "=========== Checking for updates=========="


Install-Module PSWindowsUpdate #imports the Windows Update module in PowerShell.
$updates = "Critical Updates" , "Security Updates"
Get-WUInstall -AcceptAll -Verbose -IgnoreReboot -Category $updates

Get-WindowsUpdate #Checks for updates
Install-WindowsUpdate #installs the available updates.
Write-Host "-----------------Restart in 30 seconds -------------"
