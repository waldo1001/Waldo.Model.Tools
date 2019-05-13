$File = "c:\temp\ReducedVariableLengths.txt"

$ModuleToolAPIPath = Join-Path $PSScriptRoot "..\The Magic\NavModelToolsAPI.dll"
import-module $ModuleToolAPIPath -WarningAction SilentlyContinue -Verbose

if (!$Model) {$Model = Get-NAVObjectModel -NavObjectsTextFile $File -TimeExecution}

#All Text-fields
$modelBC13.ObjectElements | Where {($_.ElementType -eq 'Field' -and $_.Datatype -like 'Text100')} | measure
$modelBC14.ObjectElements | Where {($_.ElementType -eq 'Field' -and $_.Datatype -like 'Text100')} | measure

$Model.ObjectElements | Where {($_.ElementType -eq 'Field' -and $_.Datatype -like 'Text100')} | measure


#All Text-Variables
$Model.ObjectElements | Where {($_.ElementType -eq 'Variable' -and $_.Datatype -like 'Text*' -and -not ($_.Datatype -eq 'TextConst'))} | select fullname, Length, datatype
#All variables of type code
$Model.ObjectElements | Where {($_.ElementType -eq 'Variable' -and $_.Datatype -like 'Code*' -and -not ($_.Datatype -eq 'Codeunit'))} | select fullname, Length, datatype
#All variables with "*Item*Description*" and their lengths
$Model.ObjectElements | Where {($_.ElementType -eq 'Variable' -and $_.Datatype -eq 'Text' -and $_.Name -like '*Item*Description*')} | select fullname, Length, datatype | ft -AutoSize

