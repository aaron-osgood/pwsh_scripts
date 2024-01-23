Enter-PSSession -ComputerName SRV3
# then...
(Get-ChildItem -Path \\SRV2\c$ -Directory).Count ## doesn't work

# configure ps session name (stateful)
Invoke-Command -ComputerName SRV3 -ScriptBlock { Register-PSSessionConfiguration -Name Admin -RunAsCredential 'domainname\username' -Force }
# this should then work from a ps session
Invoke-Command -ComputerName SRV3 -ScriptBlock { (Get-ChildItem -Path \\SRV2\c$ -Directory).Count } -ConfigurationName Admin