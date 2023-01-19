<#  description: Post install actions
    by: Ivo Beerens
    version: 1.0 creation
#>

Set-ExecutionPolicy Bypass -Scope Process -Force 

# Variables
$powerManagement = "8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
$tempFolder = "C:\Temp" 
$osdisklabel = "OperatingSystem"

#Enable ICMP ping IPv4 in the firewall
New-NetFirewallRule -Name "Allow_Ping_ICMPv4" -DisplayName "Allow Ping ICMPv4" -Description "Allow ICMP IPv4" -Protocol ICMPv4 -IcmpType 8 -Enabled True -Profile Any -Action Allow

#Create a c:\Temp folder
if (!(test-path $tempFolder))
{
New-Item -ItemType Directory -Path $tempFolder -Force | Out-Null
}

#Download script
# Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ibeerens/Terraform/main/Scripts/post_install.ps1" -OutFile $tempfolder

# Install Choco
# iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
# choco install notepadplusplus -y

#Set power management to High
powercfg.exe -SETACTIVE $powerManagement

#set OS drive label
$drive = Get-WmiObject win32_volume -Filter "DriveLetter = 'C:'"
$drive.Label = $osdisklabel
$drive.put() | Out-Null
