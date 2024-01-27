# Show TCP Connections & their initiating processes
Get-NetTCPConnection | Select-Object LocalAddress,LocalPort,RemoteAddress,RemotePort,State,@{Label = 'ProcessName';Expression={(Get-Process -Id $_.OwningProcess).Name}}, @{Label="CommandLine";Expression={(Get-WmiObject Win32_Process -filter "ProcessId = $($_.OwningProcess)").CommandLine}} | ft -Wrap -AutoSize

# Show UDP Connections & their initiating processes
et-NetUDPEndpoint | Select-Object LocalAddress,LocalPort,RemoteAddress,RemotePort,State,@{Label = 'ProcessName';Expression={(Get-Process -Id $_.OwningProcess).Name}}, @{Label="CommandLine";Expression={(Get-WmiObject Win32_Process -filter "ProcessId = $($_.OwningProcess)").CommandLine}} | ft -Wrap -AutoSize

# Search for PowerShell downgrade attacks in the event log
## https://kurtroggen.wordpress.com/2017/05/17/powershell-security-powershell-downgrade-attacks/
Get-WinEvent -LogName "Windows PowerShell" |
    Where-Object Id -eq 400 |
    Foreach-Object {
        $version = [Version] (
            $_.Message -replace '(?s).*EngineVersion=([\d\.]+)*.*','$1')
        if($version -lt ([Version] "5.0")) { $_ }
}