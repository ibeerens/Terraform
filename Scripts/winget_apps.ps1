# https://github.com/microsoft/winget-cli/releases

Set-ExecutionPolicy Bypass -Scope Process -Force 
$ProgressPreference='Silent'

# Install Winget
cd C:\install
Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/download/v1.4.10173/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle -OutFile .\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

# Install Packages
$a = @(
    'Microsoft.PowerShell'
    'Microsoft.AzureCLI'
    'Microsoft.Bicep'
    'Microsoft.VisualStudioCode'
    'Microsoft.Azure.StorageExplorer'
    'Microsoft.Sysinternals.RDCMan'
    'Microsoft.Azure.Aztfy'
    'Hashicorp.Terraform'
    'git.git'
)

$winget_add = '--silent --accept-package-agreements --accept-source-agreements'

foreach ($item in $a) {
    winget install --id $item --silent --accept-package-agreements --accept-source-agreements
}
