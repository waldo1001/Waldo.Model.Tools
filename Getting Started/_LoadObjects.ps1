
$ObjectsFile = "C:\Temp\13.1.25341.0-W1.txt"
$ModuleToolAPIPath = Join-Path $PSScriptRoot "..\The Magic\NavModelToolsAPI.dll"

import-module $ModuleToolAPIPath -WarningAction SilentlyContinue

$Model = Get-NAVObjectModel -NavObjectsTextFile $ObjectsFile -TimeExecution 
