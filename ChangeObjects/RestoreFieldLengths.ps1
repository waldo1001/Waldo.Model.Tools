#in BC19S, 860 field lengths were changed.  This script restores them.
$ModuleToolAPIPath = Join-Path $PSScriptRoot "..\The Magic\NavModelToolsAPI.dll"
import-module $ModuleToolAPIPath -WarningAction SilentlyContinue -Verbose

if (!$modelBC13) {$modelBC13 = Get-NAVObjectModel -NavObjectsTextFile "C:\temp\13.3.27233.0-W1.txt" -SkipWhereUsed}
if (!$modelBC14) {$modelBC14 = Get-NAVObjectModel -NavObjectsTextFile "C:\temp\14.0.29537.31961-W1.txt" -SkipWhereUsed}
if (!$modelResult) {$modelResult = Get-NAVObjectModel -NavObjectsTextFile "C:\temp\14.0.29537.31961-W1.txt" -SkipWhereUsed}

if (!$FieldsBC13) {$FieldsBC13 = $modelBC13.ObjectElements | Where {($_.ElementType -eq 'Field' -and ($_.Datatype -like 'Text*' -or $_.Datatype -like 'Code*'))}}

$ChangedFields = @()
$Count = $FieldsBC13.Count
$i = 0
$ii = 0
foreach($Field13 in $FieldsBC13){
    $i++
    Write-Progress -Activity Progress -Status "$i / $count - $ii"
       
    $Field14 = $modelBC14.GetElement($Field13.FullName)
    if ($Field14){
        if ($Field13.Datatype -ne $Field14.Datatype) {
            $ii++

            $modelResult.GetElement($Field13.FullName).DataType = $Field13.Datatype        
        }   
    } 

}

break
#export-navobj

Export-NAVObjectModel -ObjectModel $modelResult -TargetFileName "c:\temp\ReducedVariableLengths.txt"