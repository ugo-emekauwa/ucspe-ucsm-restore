param (
  [Parameter(Mandatory=$true, Position=0)] [String] $IP,
  [Parameter(Mandatory=$true, Position=1)] [String] $User,
  [Parameter(Mandatory=$true, Position=2)] [String] $Password,
  [Parameter(Mandatory=$true, Position=3)] [String] $BackupPath,
  [Parameter(Mandatory=$false, Position=4)] [Int] $MinutesToWait = 4
)

# Cisco UCSPE Restart and Restore Script, written by Ugo Emekauwa (uemekauw@cisco.com or uemekauwa@gmail.com)

# Start Script
Write-Host "`r`n`r`n`r`n`r`n`r`n$(Get-Date) - Starting the Cisco UCSPE Restart and Restore script"

# Checking for Cisco.UCSManager Module Installation and Import
Write-Host "$(Get-Date) - Verifying Cisco.UCSManager module installation..."
If ((Get-Module -ListAvailable -Name "Cisco.UCSManager").Name -ne "Cisco.UCSManager"){
    Write-Host "$(Get-Date) - The Cisco.UCSManager module is not installed. Installing the Cisco.UCSManager module..."
    Install-Module -Name "Cisco.UCSManager" -Force
} Else {
    Write-Host "$(Get-Date) - Cisco.UCSManager module is already installed"
}
Write-Host "$(Get-Date) - Importing the Cisco.UCSManager module"
Import-Module Cisco.UCSManager

# Restart UCSPE VM
Write-Host "$(Get-Date) - Restarting UCSPE VM"
$body = "Submit=Reboot Virtual Machine&confirm=yes"
$uri = "http://$($IP)/settings/restart/vmreboot"
Invoke-WebRequest -Uri $uri -Method Post -Body $body

# Wait for UCSPE VM Availability...
Write-Host "$(Get-Date) - Waiting $($MinutesToWait) minutes for UCSPE VM to fully start up..."
$SecondsToWait = $MinutesToWait * 60
For ($i = $SecondsToWait; $i -gt 0; $i--) {
  Write-Progress -Activity "UCSPE Start Up in Progress..." -Status "Current Status:" -SecondsRemaining $i;
  Sleep 1
}
Write-Progress -Activity "UCSPE Start Up Completed" -Completed

# Establish Ping Variable
Write-Host "$(Get-Date) - Establishing ping variable"
$ping = New-Object System.Net.NetworkInformation.Ping

# Verify UCSPE Network Availability
Write-Host "$(Get-Date) - Verifying UCSPE network availability..."
Write-Host "$(Get-Date) - Pinging $($IP)..." -NoNewLine
Do {
    $result = $ping.Send($IP)
    Write-Host "." -NoNewline
} Until ($result.Status -eq "Success")

# Set UCS Manager Credentials
Write-Host "`r`n$(Get-Date) - Setting UCSM credentials"
$SecureStringPassword = $Password | ConvertTo-SecureString -AsPlainText -Force
$UCSMCredential = New-Object System.Management.Automation.PSCredential($User,$SecureStringPassword)

# Log into UCS Manager
Write-Host "$(Get-Date) - Logging into UCS Manager"
Connect-Ucs $IP -Credential $UCSMCredential

# Import UCS Manager Configuration Backup
Write-Host "$(Get-Date) - Importing UCS Manager configuration backup"
Import-UcsBackup -LiteralPath $BackupPath

# Clean Up Internal System Backups in UCS Manager
Write-Host "$(Get-Date) - Cleaning up internal system backups in UCS Manager"
Get-UcsMgmtBackup | Remove-UcsMgmtBackup -Force
Sleep 5

# Disconnect from UCS Manager
Write-Host "$(Get-Date) - Disconnecting from UCS Manager"
Disconnect-Ucs

# Exit Script
Write-Host "$(Get-Date) - Exiting script"
Exit
