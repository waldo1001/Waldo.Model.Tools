$DataMigrationModulePath = Join-Path $PSScriptRoot "DataMigrationModule.psm1"
Import-Module $DataMigrationModulePath -WarningAction SilentlyContinue -Verbose -Force

if ($Model.NAVObjects.Count -eq 0) {
  Write-Host -ForegroundColor Red "No objects were found. Load objects first using _LoadObjects.ps1 script"
  return
}

$csvFilePath = 'C:\Temp\ObjectsAnalysis.csv'
Measure-Command {
  CreateCALFieldsCSV $csvFilePath `
                     -fieldFilter '50000..90000|31000000..31099999'
}

$CALTempTablesPath = 'C:\Temp\CALTempTables.txt'
Measure-Command {
  CreateCALTempTables $CALTempTablesPath `
                      -fieldFilter '31000000..31099999'
}

$TempDataMigrationCodeunitPath = 'C:\Temp\TempDataMigrationCodeunit.txt'
Measure-Command {
  CreateCALTempDataUpgradeCodeunit $TempDataMigrationCodeunitPath `
                                   -fieldFilter '31000000..31099999'
}

$alFilePath = 'C:\Temp\ALDataUpgradeCodeunit.al'
Measure-Command {
  CreateALDataUpgradeCodeunit $alFilePath `
                              -fieldFilter '50000..90000|31000000..31099999'
}
