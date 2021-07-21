
$ObjectsFile = "C:\Temp\13.1.25341.0-W1.txt" #point to a file that exists for you (advised to create a complete text-export of an BC/NAV Database)
$ModuleToolAPIPath = Join-Path $PSScriptRoot "..\The Magic\NavModelToolsAPI.dll"

import-module $ModuleToolAPIPath -WarningAction SilentlyContinue -Verbose

$global:Model = Get-NAVObjectModel -NavObjectsTextFile $ObjectsFile -TimeExecution 
Write-Host $global:Model.NAVObjects.Count