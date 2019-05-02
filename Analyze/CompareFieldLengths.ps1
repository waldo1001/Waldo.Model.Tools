if (!$modelBC13) {$modelBC13 = Get-NAVObjectModel -NavObjectsTextFile "I:\Hatch\waldo\2019\BC135.txt"}
if (!$modelBC14) {$modelBC14 = Get-NAVObjectModel -NavObjectsTextFile "I:\Hatch\waldo\2019\BC140.txt"}

if (!$FieldsBC13) {$FieldsBC13 = $modelBC13.ObjectElements | Where {($_.ElementType -eq 'Field')}}
if (!$FieldsBC14) {$FieldsBC14 = $modelBC14.ObjectElements | Where {($_.ElementType -eq 'Field')}}

$ChangedFields = @()
$Count = $FieldsBC13.Count
$i = 0
foreach($Field13 in $FieldsBC13){
    $i++
    Write-Progress -Activity Progress -Status "$i / $count"
     
    $ChangedField = New-Object PSObject
    $ChangedField | Add-Member -MemberType NoteProperty -Name FullName -Value $Field13.FullName
    
    $Field14 = $modelBC14.GetElement($Field13.FullName)
    if ($Field14){
        if ($Field13.Datatype -ne $Field14.Datatype) {
            $ChangedField | Add-Member -MemberType NoteProperty -Name Action -Value ChangedDatatype
            $ChangedField | Add-Member -MemberType NoteProperty -Name From -Value $Field13.Datatype
            $ChangedField | Add-Member -MemberType NoteProperty -Name To -Value $Field14.Datatype
        } else {
            $ChangedField | Add-Member -MemberType NoteProperty -Name Action -Value SameDatatype
        }   
    } else {       
        $ChangedField | Add-Member -MemberType NoteProperty -Name Action -Value Deleted
    }
    
    $ChangedFields += $ChangedField

}

$ChangedFields | where Action -eq ChangedDatatype | measure
$ChangedFields | where Action -eq ChangedDatatype | Export-Csv "\\ifacto.be\Profiles\UserProfiles\WAUTERI\Desktop\New folder\BC135-BC140.csv"
