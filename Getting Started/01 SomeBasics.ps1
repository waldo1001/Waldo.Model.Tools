#Number of objects
$Model.NAVObjects.Count

#Codeunit 80
$CU80 = $Model.NAVObjects | where {($_.ParentObjectType -eq 'Codeunit' ) -and ($_.ParentObjectID -eq 80)}

#FullName
$CU80.FullName
$CU80.Procedures[20].FullName

#Number of procedures in Codeunit 80
$CU80.Procedures.Count
$CU80.Variables.Count

#Stats on CyclomaticComplexity in CU80
$CU80.Procedures.CyclomaticComplexity | measure -Average -Maximum -Minimum

#Lines of code in Codeunit 80
$CU80.Procedures.Codelines.Count

#Where Codeunit 80 is used
$CU80.UsedBy

#All Obsolete Fields in the base app
$Model.NAVObjects.ChildElements | where ObsoleteState -eq 'Removed' | select FullName

#Codelines
$CU80.Procedures[0].CodeLines
$CU80.Procedures[0].CodeLines.Count
$CU80.Procedures[0].ElementMappings
$CU80.Procedures[0].Using
$CU80.Procedures[0].CodeModel
$CU80.Procedures[0].CodeModel.CodeTokens | ft
$CU80.Procedures[0].CodeModel.CodeTokens | Where {($_.Token -like '*if') -or ($_.Token -like '*repeat')} | Measure
$CU80.Procedures[0].CyclomaticComplexity

#Publishers
$model.EventPublishers | measure
$Model.EventPublishers.FullName
$Model.EventPublishers.UsedBy
