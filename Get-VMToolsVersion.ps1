###################################################################
# Get the VMware Tools version for VMs within your infrastructure #
###################################################################

function Get-VMToolsVersion {
    param (
        [string]$ExportPath
    )

    # Connect to vCenter Server or ESXi host
    Connect-VIServer -Server "ServerName"

    # Get the current time
    $timeStamp = Get-Date -Format "yyyyMMdd_HHmmss"

    # Time stamp the results
    $exportPath = Join-Path -Path $exportPath -ChildPath "VMTools_Version_$timestamp.xlsx"

    # Get VMware Tools Version for a single or all VMs within the environment
    # If you want to add additional objects to the Select-Object parameter, run:
    # Get-VMGuest -VM "VMName" | Select-Object -Property *
    $vmTools = Get-VMGuest -VM * | Select-Object -Property VMName,ToolsVersion

    # Export to Excel (change to Export-CSV if you don't have the ImportExcel module)
    $vmTools | Export-Excel -Path $exportPath -AutoSize -FreezeTopRow -Title "VMware Tools Version" -BoldTopRow -AutoFilter

    # Disconnect session from vCenter or ESXi Host
    Disconnect-VIServer
}

# Run the function!
Get-VMToolsVersion -ExportPath "E:\xport\Path\"
