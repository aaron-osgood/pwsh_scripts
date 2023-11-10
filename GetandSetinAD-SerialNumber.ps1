####################################
# Grabs SN and enters it into AD
####################################

## get a single computer
#$Computers = Get-ADComputer -Filter 'name -eq "INSERT_COMPUTERNAME_HERE"' | Select-Object Name
## get an ou of computers
#$Computers = Get-ADComputer -Filter * -SearchBase 'INSERT_SEARCHBASE_HERE' | Select-Object Name

ForEach ($Computer in $Computers){
    if (Test-Connection $Computer.Name -Count 1 -Quiet){
        $Serial = (Get-WmiObject -Class Win32_BIOS -ComputerName $Computer.Name).SerialNumber
        $Result = New-Object PSObject -Property @{
    Name = $Computer.Name
    Serial = $Serial
    }
    $Result
Set-ADComputer -Identity $Computer.Name -Replace @{serialNumber = "$Serial"}
}
}