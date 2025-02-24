# Set Pagefile
$pagefile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$pagefile.AutomaticManagedPagefile = $false
$pagefile.put() | Out-Null

$pagefileset = Get-WmiObject Win32_pagefilesetting
$pagefileset.InitialSize = 16394
$pagefileset.MaximumSize = 32768
$pagefileset.Put() | Out-Null

Gwmi win32_Pagefilesetting | Select Name, InitialSize, MaximumSize

# # Uninstall and install Windows Photos
# winget uninstall --id 9WZDNCRFJBH4
# winget install --id 9WZDNCRFJBH4
