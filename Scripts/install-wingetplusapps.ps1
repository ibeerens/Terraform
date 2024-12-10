<#
    .TITLE
        Install packages
    .AUTHOR
        Ivo Beerens
        www.ivobeerens.nl
    .DESCRIPTION
        PowerShell script that enables
    .NOTES
        Run as Administrator
        Find WinGet packages: https://winget.run/
    .VERSIONS
        1.0 19-04-2024 Creation
#>

# Variables
$downloadfolder = "c:\apps\winget"

$ProgressPreference = 'SilentlyContinue'
# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Create Folder
Write-Output "Create Temp folder: $downloadfolder"
$checkdir = Test-Path -Path $downloadfolder
if ($checkdir -eq $true){
    Remove-Item $downloadfolder -Recurse -Force
    Write-Output "Creating '$downloadfolder' folder"
    New-Item -Path $downloadfolder -ItemType Directory | Out-Null
}
if ($checkdir -eq $false){
    Write-Output "Creating '$downloadfolder' folder"
    New-Item -Path $downloadfolder -ItemType Directory | Out-Null
}

Write-Output "Downloading WinGet dependencies"
Invoke-WebRequest -Uri https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip -OutFile $downloadfolder\DesktopAppInstaller_Dependencies.zip
Expand-Archive $downloadfolder\DesktopAppInstaller_Dependencies.zip -DestinationPath $downloadfolder
Write-Output "Install VCLibs 64-bits"
Add-AppPackage $downloadfolder\x64\Microsoft.VCLibs.140.00.UWPDesktop_14.0.33728.0_x64.appx
Write-Output "Install Xaml 64-bits"
Add-AppxPackage $downloadfolder\x64\Microsoft.UI.Xaml.2.8_8.2310.30001.0_x64.appx

Write-Output "Downloading WinGet"
Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile $downloadfolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
Write-Output "Install Winget"
Add-AppPackage $downloadfolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle

Write-Output "Winget Installed"
winget -v

$processlist = @(
    "VideoLAN.VLC",
    "Google.Chrome"
)

foreach ($item in $processlist) {
    Write-Output "Install $item"
    Winget install -e --id $item --accept-source-agreements --accept-package-agreements --scope machine
}



 # Post install configuration
 $prefs = @{
    "homepage"               = "https://www.microsoft365.com"
    "homepage_is_newtabpage" = $false
    "browser"                = @{
        "show_home_button" = $true
    }
    "session"                = @{
        "restore_on_startup" = 4
    }
    "bookmark_bar"           = @{
        "show_on_all_tabs" = $false
    }
    "sync_promo"             = @{
        "show_on_first_run_allowed" = $false
    }
    "distribution"           = @{
        "ping_delay"                                = 60
        "suppress_first_run_bubble"                 = $true
        "create_all_shortcuts"                      = $false
        "do_not_create_desktop_shortcut"            = $true
        "do_not_create_quick_launch_shortcut"       = $true
        "do_not_launch_chrome"                      = $true
        "do_not_register_for_update_launch"         = $true
        "make_chrome_default"                       = $false
        "make_chrome_default_for_user"              = $false
        "suppress_first_run_default_browser_prompt" = $true
        "system_level"                              = $true
        "verbose_logging"                           = $true
    }
}

Write-Output "Optimize Google Chrome"
$prefs | ConvertTo-Json | Set-Content -Path "$Env:ProgramFiles\Google\Chrome\Application\master_preferences" -Force -Encoding "utf8"

Write-Output "Remove Shortcut"
$Shortcuts = @("$Env:Public\Desktop\Google Chrome.lnk")
Remove-Item -Path $Shortcuts -Force -ErrorAction "Ignore"
