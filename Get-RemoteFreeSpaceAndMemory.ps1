$session = New-PSSession -ComputerName SRV1


function Get-WmiObjectValue {
    [CmdLetBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$PropertyName,

        [Parameter(Mandatory)]
        [string]$WmiClassName

        [Parameter(Mandatory)]
        [System.Management.Automation.Runspaces.PSSession]$session
    )
    $ScriptBlock = {
        $number = (Get-CimInstance -ClassName Win32_LogicalDisk | Measure-Object -Property 'FreeSpace' -Sum).Sum
        $numberGb = $totalFreeSpaceInBytes / 1GB
        [math]::Round($numberGb,2)
    }
    Invoke-Command -Session $session -ScriptBlock $ScriptBlock
}

Get-WmiObjectValue -PropertyName Capacity -WmiClassName Win32_PhysicalMemory -Session $session

# Find total memory and free storage space on remote computer
$totalMemoryGb = Get-WmiObjectValue -WmiClassName Win32_PhysicalMemory -PropertyName Capacity -Session $session
$totalFreeSpaceGb = Get-WmiObjectValue -WmiClassName Win32_LogicalDisk -PropertyName FreeSpace -Session $session

Write-Host "The computer $($session.ComputerName) has $totalMemoryGb of memory and $totalStorageGb GB of free space across all volumes."

# Remove the shared session
Remove-PSSession -Session $session