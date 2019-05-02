$File = "C:\temp\14.0.26532.0-W1.txt"

$ModuleToolAPIPath = Join-Path $PSScriptRoot "..\The Magic\NavModelToolsAPI.dll"
import-module $ModuleToolAPIPath -WarningAction SilentlyContinue -Verbose

if (!$Model) {$Model = Get-NAVObjectModel -NavObjectsTextFile $File -TimeExecution}

#All Text-Variables
$Model.ObjectElements | Where {($_.ElementType -eq 'Variable' -and $_.Datatype -like 'Text*' -and -not ($_.Datatype -eq 'TextConst'))} | select fullname, Length, datatype
#All variables of type code
$Model.ObjectElements | Where {($_.ElementType -eq 'Variable' -and $_.Datatype -like 'Code*' -and -not ($_.Datatype -eq 'Codeunit'))} | select fullname, Length, datatype
#All variables with "*Item*Description*" and their lengths
$Model.ObjectElements | Where {($_.ElementType -eq 'Variable' -and $_.Datatype -eq 'Text' -and $_.Name -like '*Item*Description*')} | select fullname, Length, datatype | ft -AutoSize

