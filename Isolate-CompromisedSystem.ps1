$ComputerName = "COMPUTERNAME"
msg * /server $ComputerName "Security issues were found on your computer.  You are now disconnected from the internet.  Please contact your local helpdesk at: 289-330-8004"
$session = Invoke-Command -ComputerName $ComputerName -InDisconnectedSession -ScriptBlock {
    New-NetFirewallRule -DisplayName "Isolate from outbound traffic" -Direction Outbound -Action Block | Out-Null;
    New-NetFirewallRule -DisplayName "Isolate from inbound traffic" -Direction Inbound -Action Block | Out-Null;
    Get-NetAdapter|foreach { Disable-NetAdapter -Name $_.Name -Confirm:$false }
}
Remove-PSSession -Id $session.Id -ErrorAction SilentlyContinue