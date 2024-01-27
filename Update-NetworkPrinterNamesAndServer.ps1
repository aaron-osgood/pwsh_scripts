# Import CSV file to be used for this script
$printerImport = "CSV\PATH\HERE.CSV"
$csvImport = Import-CSV -Path $printerImport

# Specify old and new print server details
$oldPrintServer = "oldprintserver"
$newPrintServer = "newprintserver"

# Run through and check old printers and update
Import-Csv -Path $printerImport | ForEach-Object {

# Define registry paths
    $oldPrinterKey = "HKCU:\Printers\Connections\,,$oldPrintServer,$($_.oldPrinterName)"
    $newPrinterKey = "HKCU:\Printers\Connections\,,$newPrintServer,$($_.newPrinterName)"

    if (Test-Path -Path $oldPrinterKey) {
        # Copies the old reg key to the new reg key destination with correct info
        Copy-Item -Path $oldPrinterKey -Destination $newPrinterKey -Recurse -Force
        
        # Updates the server key value to point to the new print server
        Set-ItemProperty -Path $newPrinterKey -Name "Server" -Value "\\$newPrintServer"

        # Remove old registry path
        Remove-Item -Path $oldPrinterKey -Recurse -Force
        
        # Deliver some output
        Write-Output "Registry keys updated successfully."
    } else {
        Write-Output "Old registry key not found. No changes made."
    }
}
