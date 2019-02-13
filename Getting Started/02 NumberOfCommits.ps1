$CodelinesWithCommit = $model.NAVObjects.ChildElements | where {$_.Codelines -like '*COMMIT*'} 

$CommitData = @()
$i = 0
foreach ($CodelineWithCommit in $CodelinesWithCommit){
    $i++
    $CommitDataObject = New-Object PSObject
    $CommitDataObject | Add-Member -Name 'EntryNo' -Value $i -MemberType NoteProperty
    $CommitDataObject | Add-Member -Name 'ObjectType' -Value $CodelineWithCommit.ParentObjectType -MemberType NoteProperty    
    $CommitDataObject | Add-Member -Name 'FullNameWithId' -Value $CodelineWithCommit.FullNameWithId -MemberType NoteProperty    
    $CommitDataObject | Add-Member -Name 'Type' -Value $CodelineWithCommit.WrapperType -MemberType NoteProperty
    if ([string]::IsNullOrEmpty($CodelineWithCommit.Name)){
        $CommitDataObject | Add-Member -Name 'Name' -Value 'OnTrigger' -MemberType NoteProperty
    } else {
        $CommitDataObject | Add-Member -Name 'Name' -Value $CodelineWithCommit.Name -MemberType NoteProperty
    }
    $NumberOfLinesWithCommit = ($CodelineWithCommit.CodeLines | Where {$_ -like '*COMMIT*'}).Count
    $CommitDataObject | Add-Member -Name 'NumberOfLinesWithCommit' -Value  $NumberOfLinesWithCommit -MemberType NoteProperty
     
    $NumberOfLinesWithCommitInComment = ($CodelineWithCommit.CodeLines | Where {$_ -like '*//*COMMIT*'}).Count
    $CommitDataObject | Add-Member -Name 'NumberOfLinesWithCommitInComment' -Value  $NumberOfLinesWithCommitInComment -MemberType NoteProperty

    $CommitData += $CommitDataObject   
}


#$CommitData | ft

Write-Host -ForegroundColor Green 'Number of triggers/functions that contain commits:'
$CommitData.Count

Write-host -ForegroundColor Green 'Overall number of commits:'
($CommitData | measure -Sum -Property NumberOfLinesWithCommit).Sum

Write-host -ForegroundColor Green 'Number of Commits in comment:'
($CommitData | measure -Sum -Property NumberOfLinesWithCommitInComment).Sum

Write-host -ForegroundColor Green 'Number of Commits followed by a comment on the same line:'
($CodelinesWithCommit | Where {$_.CodeLines -like '*COMMIT*//*'} | measure).Count
#$CodelinesWithCommit | Where {$_.CodeLines -like '*COMMIT*//*'} | select FullNameWIthID

Write-host -ForegroundColor Green 'Commits per object type'
$CommitData | group ObjectType | foreach {
    $Sum = ($CommitData | where ObjectType -eq $_.Name | measure -Property NumberOfLinesWithCommit -Sum).Sum
    
    "$($_.Name) : $Sum"
}

