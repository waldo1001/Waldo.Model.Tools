$DataMigrationModulePath = Join-Path $PSScriptRoot "DataMigrationModule.psm1"
Import-Module $DataMigrationModulePath -WarningAction SilentlyContinue -Verbose -Force

if ($Model.NAVObjects.Count -eq 0) {
  Write-Host -ForegroundColor Red "No objects were found. Load objects first using _LoadObjects.ps1 script"
  return
}

# CreateCALFieldsCSV

$csvFilePath = 'C:\Temp\ObjectsAnalysis.csv'
CreateCALFieldsCSV $csvFilePath `
                   -fieldFilter '50000..90000|31000000..31099999'
CreateCALFieldsCSV $csvFilePath `
                   -tableFilter 37 `
                   -fieldFilter '50000..90000|31000000..31099999'

# CALTempTablesPath

$CALTempTablesPath = 'C:\Temp\CALTempTables.txt'
CreateCALTempTables $CALTempTablesPath `
                    -fieldFilter '31000000..31099999'
CreateCALTempTables $CALTempTablesPath `
                    -fieldFilter '31000000..31099999' `
                    -outputStartId 50100


# CreateCALTempDataUpgradeCodeunit

$TempDataMigrationCodeunitPath = 'C:\Temp\TempDataMigrationCodeunit.txt'
CreateCALTempDataUpgradeCodeunit $TempDataMigrationCodeunitPath `
                                 -fieldFilter '31000000..31099999'
CreateCALTempDataUpgradeCodeunit $TempDataMigrationCodeunitPath `
                                 -fieldFilter '31000000..31099999' `
                                 -outputObjectId 50100

# CreateALDataUpgradeCodeunit

$alFilePath = 'C:\Temp\ALDataUpgradeCodeunit.al'
CreateALDataUpgradeCodeunit $alFilePath `
                            -fieldFilter '50000..90000|31000000..31099999'
CreateALDataUpgradeCodeunit $alFilePath `
                            -fieldFilter '50000..90000|31000000..31099999' `
                            -outputObjectId 50100
