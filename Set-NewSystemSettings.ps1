#############################
## Sets system theme to dark mode.
#############################

# Check if running with elevated permissions
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Please run this script as an administrator."
    Exit
}

# Set the registry key for dark mode
$darkModeRegistryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"
$darkModeRegistryName = "AppsUseLightTheme"

# 1 means light mode, 0 means dark mode
$darkModeValue = 0

# Set the registry key value
Set-ItemProperty -Path $darkModeRegistryPath -Name $darkModeRegistryName -Value $darkModeValue

# Notify user about the change
Write-Host "System theme set to dark mode."

# Force a refresh of the desktop to apply the changes
Stop-Process -Name explorer -Force
Start-Process explorer

#############################
## Installs NuGet and sets trust to yes for PowerShell Gallery
#############################

# Install NuGet
Install-PackageProvider -Name NuGet -Force -Scope CurrentUser

# Set NuGet as the default package provider
Set-PackageSource -Name PSGallery -Trusted -Force -ErrorAction SilentlyContinue

# Trust the PowerShell Gallery
$gallerySource = "https://www.powershellgallery.com/api/v2/"
$galleryProvider = "PowerShellGet"

# Trust the repository
Register-PSRepository -Name PSGallery -SourceLocation $gallerySource -InstallationPolicy Trusted -PackageManagementProvider $galleryProvider -Force

Write-Host "NuGet installed and PowerShell Gallery trusted."

#############################
## Install winget and Windows Terminal
#############################

# Check if winget is available
$wingetCommand = Get-Command winget -ErrorAction SilentlyContinue

if ($wingetCommand -eq $null) {
    # Download and install the Windows Package Manager
    Write-Host "Winget is not installed. Installing it now..."

    Invoke-WebRequest -Uri https://aka.ms/winget-cli -OutFile winget-cli.msixbundle
    Add-AppxPackage -Path .\winget-cli.msixbundle -ForceInstall

    Write-Host "Winget has been installed."
} else {
    Write-Host "Winget is already installed."
}

# Install Windows Terminal from the Microsoft Store
Invoke-Expression -Command "ms-windows-store://pdp/?ProductId=9n0dx20hk701"

# Alternative method using winget (Windows Package Manager)
# Make sure you have the Windows Package Manager installed
# You can install it from: https://aka.ms/winget

winget install Microsoft.WindowsTerminal

