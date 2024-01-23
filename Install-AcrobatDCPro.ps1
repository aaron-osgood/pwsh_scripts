### Set hostname variables
Set-Variable -Name "remoteHost" -Value "__REMOTEHOST__"
Set-Variable -Name "sccmServer" -Value "__REMOTESERVER__"

### Set the executable name variables
Set-Variable -Name "appInstallPath" -Value "C:\temp\remote_install\"
Set-Variable -Name "arg1" -Value "-DeploymentType Install"
Set-Variable -Name "arg2" -Value "-DeployMode Silent"

### Set the application check variables
Set-Variable -Name "acrobatRegKey" -Value "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{AC76BA86-1033-FFFF-7760-0C0F074E4100}"

### Copies the appropriate files and runs the install
$parameters = @{
        ScriptBlock  = { (New-Item -Path "\\$remoteHost\c$\temp\remote_install" -ItemType Directory)
                        (Get-ChildItem -Path "\\$sccmServer\__APPS_PATH__*" | Copy-Item -Destination "\\$remoteHost\c$\temp\remote_install" -Recurse) }
}
Invoke-Command @parameters

### Performs the upgrade
Invoke-Command -ComputerName $remoteHost -ScriptBlock { Start-Process -FilePath "C:\temp\remote_install\Deploy-Application.exe" -ArgumentList "$using:arg1", "$using:arg2" -PassThru -Wait }

### Perform the checks
$s = New-PSSession -ComputerName $remoteHost
Enter-PSSession -Session $s
$check = @{
  ComputerName = $remoteHost
  ScriptBlock = { Get-ItemProperty -Path $using:acrobatRegKey | Select-Object -ExpandProperty DisplayVersion }
}
Invoke-Command @check
Exit-PSSession
