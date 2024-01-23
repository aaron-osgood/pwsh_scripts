# Connect to vCenter server
Connect-VIServer -Server <vCenterServer>

# Specify the VM name
$vmName = "YourWindowsVM"

# Run commands on the Windows VM
$script = {
    # Clear event logs
    Get-WinEvent -LogName * | ForEach-Object { Clear-EventLog $_.LogName }

    # Delete registry key
    Remove-Item -Path "HKLM:\SOFTWARE\Wow6432Node\Network Associates\Agent" -Recurse -Force
}

# Invoke the script on the VM
Invoke-VMScript -VM $vmName -ScriptText $script -GuestCredential (Get-Credential) -ScriptType Powershell

# Disconnect from vCenter server
Disconnect-VIServer -Server <vCenterServer> -Force -Confirm:$false
