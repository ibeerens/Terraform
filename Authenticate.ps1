# Set Terraform Path
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value  (((Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path) + ";c:\code\terraform" )
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value  (((Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path) + ";c:\code\terraform\aztfy" )
rundll32.exe sysdm.cpl,EditEnvironmentVariables
# $env:Path += ";c:\code\terraform" 

$Env:ARM_CLIENT_ID = ""
$Env:ARM_CLIENT_SECRET = ""
$Env:ARM_SUBSCRIPTION_ID = ""
$Env:ARM_TENANT_ID = ""