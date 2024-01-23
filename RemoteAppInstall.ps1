#########################################################################################################################################
### Registry key checks (make sure to use single quotes around the whole reg key string)                                              ###
### Acrobat Pro DC: HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall{AC76BA86-1033-FFFF-7760-0C0F074E4100}       ###
#########################################################################################################################################

### Set the computerName variable
$computerName = "computer name here"

### Enters PowerShell Remote Session
Enter-PSSession $computerName 

### Sets variables
$programFolderName = "program folder name here"
$regKey = "set reg key here"
$exeName = "executable name here"

### Checks to see if C:\temp exists, if it does not exist, create it.
$tempFolder = "C:\temp"
If (-not (Test-Path $tempFolder)) {
    # Folder does not exist, create it
    New-Item -Path $tempFolder -ItemType Directory
    Write-Host "New Folder Created at '$tempFolder', carrying on..." -f Green
}
Else {
    Write-Host "Folder '$tempFolder' already exists, carrying on..." -f Orange
}

### Copies the program from a remote or local share
### Use a \* and -Recurse for a full directory
Copy-Item -Path "\\path\here\my\boy\$programFolderName\*" -Destination "$tempFolder" -Recurse

### Starts the installation and waits for it to finish
Start-Process -FilePath "$tempFolder\$programFolderName\$exeName.exe" -Wait

### Checks registry key for correct version
Get-ItemProperty -Path '$regKey' | Select-Object -ExpandProperty DisplayVersion

### Checks folder for correct version.. coming soon?