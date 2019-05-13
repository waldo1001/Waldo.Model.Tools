#in BC19S, 860 field lengths were changed.  This script restores them.
if ($null -eq $Target) {
    $Target = Get-NAVObjectModel -NavObjectsTextFile "c:\Temp\Target.txt" -SkipWhereUsed
}
if ($null -eq $BC2018) {
    $BC2018 = Get-NAVObjectModel -NavObjectsTextFile "c:\Temp\BC2018.txt" -SkipWhereUsed
}
if ($null -eq $BCS19) {
    $BCS19 = Get-NAVObjectModel -NavObjectsTextFile "c:\Temp\BCS19.txt" -SkipWhereUsed
}
 
$Target = ""
 
foreach ($Table in $BC2018.NAVObjects) {
    $S19Table = $BCS19.GetNavObject($Table.ElementType,$Table.Id)
    $DTable = $Target.GetNavObject($Table.ElementType,$Table.Id)
 
    if ($null -eq $S19Table) {
        Write-Host "$($Table.id) not found"
        continue
    }
    
    foreach ($Field in $Table.Fields) { 
        $S19field = $S19Table.GetField($field.FieldNo)
        $DField = $DTable.GetField($field.FieldNo)
 
        if ($null -eq $S19field) {
            Write-Host "$($Table.id)-$($Field.FieldNo) not found"
            continue
        }
 
        if ($Field.Datatype -ne $S19Field.Datatype)
        {
            $DField.Datatype = $Field.Datatype
        }
    }
}
  
Export-NAVObjectModel -ObjectModel $Target -TargetFileName "c:\Temp\Target_result.txt"
 
