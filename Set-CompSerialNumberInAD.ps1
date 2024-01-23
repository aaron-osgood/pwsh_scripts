####################################
# Grabs SN and enters it into AD
####################################

# get a single computer
#$Computers = Get-ADComputer -Filter 'name -eq "_HOSTNAME_"' | Select-Object Name
# get an ou of computers
#$dc1 = "_DOMAIN_CONTROLLER_"
#$Computers = Get-ADComputer -Filter * -SearchBase '_OU_HERE_' | Select-Object Name

ForEach ($Computer in $Computers){
    if (Test-Connection $Computer.Name -Count 1 -Quiet){
            Write-Host "The remote computer $Computer appears to be online, gathering and writing the Serial Number to the AD Object..." -f Green
                $Serial = (Get-CimInstance -Class Win32_BIOS -ComputerName $Computer.Name).SerialNumber
                $Result = New-Object PSObject -Property @{
            Name = $Computer.Name
            Serial = $Serial
    }
    $Result
Set-ADComputer -Server $dc1 -Identity $Computer.Name -Replace @{serialNumber = "$Serial"}
    Write-Host "Completed writing Serial Number attribute!" -f Green
        Function Sleep-Progress($seconds) {
         $s = 0;
         Do {
                $p = [math]::Round(100 - (($seconds - $s) / $seconds * 100));
                Write-Progress -Activity "Waiting..." -Status "$p% Complete:" -SecondsRemaining ($seconds - $s) -PercentComplete $p;
                [System.Threading.Thread]::Sleep(1000)
                $s++;
            }
            While($s -lt $seconds);
        
        }
    Sleep-Progress 3
    } else {
        Write-Host "$Computer is offline, on to the next!" -f Red
        Sleep-Progress 3
    }

}


###################
### LIST OF OUs ###
###################
