   
$AllElementsWithCode = $Model.NAVObjects.ChildElements | where CodeLines -ne $null | select -First 1000


$CodeLines = @()
$i = 0
$Count = $AllElementsWithCode.Count
foreach ($ObjectWithCode in $AllElementsWithCode) {
    $i++
    Write-Progress -Activity $ObjectWithCode.FullName -PercentComplete (($i / $Count) * 100)

    $CodeLineObject = New-Object PSObject
    $CodeLineObject | Add-Member -Name 'EntryNo' -Value $i -MemberType NoteProperty
    $CodeLineObject | Add-Member -Name 'ObjectType' -Value $ObjectWithCode.ParentObjectType -MemberType NoteProperty    
    $CodeLineObject | Add-Member -Name 'FullNameWithId' -Value $ObjectWithCode.FullNameWithId -MemberType NoteProperty    
    $CodeLineObject | Add-Member -Name 'Type' -Value $ObjectWithCode.WrapperType -MemberType NoteProperty
    if ([string]::IsNullOrEmpty($ObjectWithCode.Name)) {
        $CodeLineObject | Add-Member -Name 'Name' -Value 'OnTrigger' -MemberType NoteProperty
    }
    else {
        $CodeLineObject | Add-Member -Name 'Name' -Value $ObjectWithCode.Name -MemberType NoteProperty
    }
    $CodeLineObject | Add-Member -Name 'LineCount' -Value $ObjectWithCode.CodeLines.count -MemberType NoteProperty
    $CodeLineObject | Add-Member -Name 'CyclomaticComplexity' -Value $ObjectWithCode.CyclomaticComplexity -MemberType NoteProperty
    

    $CodeLines += $CodeLineObject   
    
}
#$CodeLines | ft
#$CodeLines | Export-Csv -Path (Join-Path $SaveCSV "$([io.path]::GetFileNameWithoutExtension($objectfile)).csv")

write-host 'Cyclomatic Complexity: ' -ForegroundColor Green
$CodeLines | Measure-Object -Property CyclomaticComplexity -Average -Maximum -Minimum

Write-Host 'Top 5 Functions with highest Cyclomatic Complexity' -ForegroundColor Green
$CodeLines | sort CyclomaticComplexity -Descending | select FullNameWithId, CyclomaticComplexity -First 5 | ft

break

Write-Host "Worst function: $(($CodeLines | sort CyclomaticComplexity -Descending | select -First 1).FullNameWithId)" -ForegroundColor Green
(Find-Element -ElementFullNameKey ($CodeLines | sort CyclomaticComplexity -Descending | select -First 1).FullNameWithId -ObjectModel $Model).codelines