$module = "C:\Program Files\WindowsPowerShell\Modules\Pester\3.4.0"
takeown /F $module /A /R
icacls $module /Register
icacls $module /grant "*S-1-5-32-544:F" /inheritance:d /t
Remove-Item -Path $module -Recurse -Force -Confirm:$false