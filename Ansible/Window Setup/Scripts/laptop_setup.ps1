#-----Variables-----
param($step)
$number = $step
$computer = Read-Host "Enter Computer name (See inventory sheet for next number. Ex: Comptuer-xxx)"
$domain = "ms"
$oldname = $env:computername
$user = "Administrator"
Write-Host $domain"\"$user


#this functions renames computer and checks for updates before restarting
function initial-config{


Write-Host "=========== Renaming Computer =========="
Rename-Computer -ComputerName $oldname -NewName $computer
write-host "Name has been changed to: $computer"
write-host



#$Trigger= New-ScheduledTaskTrigger -At 10:00am –Daily # Specify the trigger settings
#$User= "NT AUTHORITY\SYSTEM" # Specify the account to run the script
#$Action= New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\PS\StartupScript.ps1" # Specify what program to run and with its parameters
#Register-ScheduledTask -TaskName "MonitorGroupMembership" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force # Specify the name of the task


$users = $domain+"\"+$user
$tempuser= "NT AUTHORITY\SYSTEM"
#$option = New-ScheduledJobOption -RunElevated # -IdleTimeout 0:0:20
$path = "C:\Users\Administrator\Desktop\scripts\Rain.ps1 -step 2"
Write-Host $domain"\"$user

$trigger = New-ScheduledTaskTrigger -AtLogOn  #- -User $domain"\"$user

$action = New-ScheduledTaskAction -Execute "PowerShell.exe"  -Argument $path #+ "-step 2"

#Register-Scheduledtask -Name "ComputerSetup1" -FilePath $path -Trigger $trigger -ArgumentList "-step 2" -ScheduledJobOption $option


Register-ScheduledTask -TaskName "ComputerSetup1" -Trigger $trigger -Action $action -RunLevel Highest -User $tempuser


Write-Host $domain"\"$user

write-host "=========== Checking for updates=========="


Install-Module PSWindowsUpdate #imports the Windows Update module in PowerShell.
$updates = "Critical Updates" , "Security Updates"
Get-WUInstall -AcceptAll -Verbose -IgnoreReboot -Category $updates

Get-WindowsUpdate #Checks for updates
Install-WindowsUpdate #installs the available updates.
Write-Host "-----------------Restart in 30 seconds -------------"

timeout /t 30

Restart-Computer
}

#function join-Domain{
#Write-host "-----------Joining  Domain-------------"
#Add-Computer -ComputerName $env:computername  -DomainName $domain -Credential ""
#Write-Host "-----------------Done restart is required-------------"}

function app-installer{

$trigger = New-JobTrigger -AtLogOn -User $domain"\"$user
Register-ScheduledJob -Name "ComputerSetup2" -FilePath $path+"Rain.ps1"  -Trigger $trigger -ArgumentList "-step 3"

$chromepath = "C:\Users\Administrator\Desktop\Installers\GoogleChromeStandaloneEnterprise64.msi"
$firefoxpath = "C:\Users\Administrator\Desktop\Installers\Firefox Setup 88.0.1.msi"
$app1= Get-WmiObject -class win32_product -filter "Name = 'Google Chrome'"
$app2= Get-WmiObject -class win32_product -filter "Name = 'Firefox'"


Write-Host "------------Installing Chrome and Firefox---------"
try{
msiexec /i $chromepath  /qn
timeout /t 60
msiexec /i $firefoxpath  /qn
}
catch
{
write-host "something went wrong"

}

timeout /t 60
Write-Host "----Uninstalling-------"
try{
$app1.Uninstall()

timeout /t 20
$app2.Uninstall()
}
catch{
Write-Host "something went wrong"
}


write-host "Done with Installations"

Write-Host "-----------------Restart in 30 seconds -------------"

timeout /t 30

Restart-Computer

}




#------main-----------
function main($number){


if ($number -eq 1)  { initial-config }

elseif ($number -eq 2)  {app-installer}


elseif ($number -eq 3) {Write-Host "DONE WITH EVERYthing"}

else{Write-Host "Enter step 1 to start. Ex: ./Rain.ps1 -step 1"}

#join-Domain

#Restart-Computer

#adds domain users to Local Admin group

#Add-LocalGroupMember -Group "Administrators" -Member "Domain Users"
}


main $number
