#in BC19S, 860 field lengths were changed.  This script restores them.

if (!$modelBC13) {$modelBC13 = Get-NAVObjectModel -NavObjectsTextFile "I:\Hatch\waldo\2019\BC135.txt"}
if (!$modelDistri) {$modelDistri = Get-NAVObjectModel -NavObjectsTextFile "I:\Hatch\waldo\2019\Distri\DistriUPG.txt"}

if (!$FieldsBC13) {$FieldsBC13 = $modelBC13.ObjectElements | Where {($_.ElementType -eq 'Field')}}
#if (!$FieldsDistri) {$FieldsDistri = $modelDistri.ObjectElements | Where {($_.ElementType -eq 'Field')}}

$ChangedFields = @()
$Count = $FieldsBC13.Count
$i = 0
$ii = 0
foreach($Field13 in $FieldsBC13){
    $i++
    Write-Progress -Activity Progress -Status "$i / $count - $ii"
       
    $FieldDistri = $modelDistri.GetElement($Field13.FulalName)
    if ($FieldDistri){
        if ($Field13.Datatype -ne $FieldDistri.Datatype) {
            $ii++

            #$ChangedField = New-Object PSObject
            #$ChangedField | Add-Member -MemberType NoteProperty -Name FullName -Value $Field13.FullName
            #
            #$ChangedField | Add-Member -MemberType NoteProperty -Name Action -Value ChangedDatatype
            #$ChangedField | Add-Member -MemberType NoteProperty -Name From -Value $Field13.Datatype
            #$ChangedField | Add-Member -MemberType NoteProperty -Name To -Value $FieldDistri.Datatype
            #
            #$ChangedFields += $ChangedField

            $modelDistri.GetElement($Field13.FullName).DataType = $Field13.Datatype        
        }   
    } 

}

break
#export-navobj

Export-NAVObjectModel -ObjectModel $modelDistri -TargetFileName "c:\temp\ReducedVariableLengths.txt"