# Specify the old and new printer details
$oldPrintServer = "oldprintserver
$oldPrinterName = "oldprintername"
$newPrintServer = "newprintserver"
$newPrinterName = "newprintername"

# Define registry paths
$oldPrinterKey = "HKCU:\Printers\Connections\,,$oldPrintServer,$oldPrinterName"
$newPrinterKey = "HKCU:\Printers\Connections\,,$newPrintServer,$newPrinterName"

# Check if the old registry key exists
if (Test-Path -Path $oldRegistryPath) {
    # Copy registry values to the new path
    Copy-Item -Path $oldRegistryPath -Destination $newRegistryPath -Recurse -Force

    # Set the new server value
    Set-ItemProperty -Path $newPrinterKey -Name "Server" -Value "\\$newPrintServer"

    # Remove the old registry key
    Remove-Item -Path $oldRegistryPath -Recurse -Force

    Write-Output "Registry keys updated successfully."
} else {
    Write-Output "Old registry key not found. No changes made."
}
