<#
    .SYNOPSIS
    Creates csv file with the tables and fields.

    .DESCRIPTION
    The CreateCALFieldsCSV function creates a csv file with the processed objects and fields. A filter can be specified to select the fields range that should be considered.

    .EXAMPLE
    CreateCALFieldsCSV 'C:\Output\ObjectsAnalysis.csv'
    Create csv file named ObjectsAnalysis.csv and exports to C:\Output folder.

    .EXAMPLE
    CreateCALFieldsCSV 'C:\Output\ObjectsAnalysis.csv' -fieldFilter '50000..50999'
    Create csv file named ObjectsAnalysis.csv and exports to C:\Output folder, considering tables with fields in range 50000..50999.
#>

function CreateCALFieldsCSV {
    Param (
            [Parameter(Mandatory=$true,Position=0)]
            [string] $csvFilePath,
            [Parameter(Mandatory=$false)]
            [string] $fieldFilter,
            [Parameter(Mandatory=$false)]
            [string] $ignoreFlowFields = $true
        )

    $tables = $Model.NAVObjects | where {($_.ParentObjectType -eq 'Table')}
    #Write-Host $tables.Count
    if ($tables.Count -eq 0) {
        Write-Host "No tables to process."
        return
    }

    $totalTables = $tables.Count
    $i = 0
    
    $fileMode = [System.IO.FileMode]::Create
    $fileAccess = [System.IO.FileAccess]::Write
    $fileShare = [System.IO.FileShare]::None
    try { 
        $fileStream = New-Object -TypeName System.IO.FileStream $csvFilePath, $fileMode, $fileAccess, $fileShare
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }

    $encoding = [System.Text.Encoding]::UTF8                
    try { 
        $writer = New-Object System.IO.StreamWriter $fileStream, $encoding
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }    

    $output = 'Object Type,Object Id,Object Name,Field Id,Field Name,Field Type'
    $writer.WriteLine($output);

    $script:hasSetupFilters = $false
    $script:filters = @()
    SetupFilters -fieldFilter $fieldFilter

    foreach ($table in $tables) {
        #Write-Host $table.Name

        $i++
        Write-Progress -Activity Progress -Status "$i of $totalTables tables processed"

        $hasFields = $false
        $fields = @()
        foreach ($field in $table.Fields) {
            #Write-Host $field.Name
            
            if (ShouldIgnoreField -field $field -ignoreFlowFields $ignoreFlowFields) {
                continue
            }

            $fields += $field
            $hasFields = $true
        }

        if (!$hasFields) {
            continue
        }

        foreach ($field in $fields) {
            $output = $table.ParentObjectType + "," + $table.Id + "," + $table.Name + "," + $field.FieldNo + "," + $field.Name + "," + $field.Datatype;
            $writer.WriteLine($output);
        }
    }
    $writer.Close();  
}

<#
    .SYNOPSIS
    Creates text file with the temporary tables that will support the data migration in C/AL.

    .DESCRIPTION
    The CreateCALTempTables function creates a text file with the temporary tables that will support the data migration in C/AL. A filter can be specified to select the fields range that should be considered.

    .EXAMPLE
    CreateCALTempTables 'C:\Output\CALTempTables.txt'
    Create text file and exports to C:\Output\CALTempTables.txt file.

    .EXAMPLE
    CreateCALTempTables 'C:\Output\CALTempTables.txt' -fieldFilter '50000..50999'
    Create text file and exports to \CALTempTables.txt file, considering tables with fields in range 50000..50999.
#>

function CreateCALTempTables {
    Param (
            [Parameter(Mandatory=$true,Position=0)]
            [string] $CALTempTablesPath,
            [Parameter(Mandatory=$false)]
            [string] $fieldFilter,
            [Parameter(Mandatory=$false)]
            [string] $ignoreFlowFields = $true
        )

    $tables = $Model.NAVObjects | where {($_.ParentObjectType -eq 'Table')}
    #Write-Host $tables.Count
    if ($tables.Count -eq 0) {
        Write-Host "No tables to process."
        return
    }

    $totalTables = $tables.Count
    $i = 0

    $fileMode = [System.IO.FileMode]::Create
    $fileAccess = [System.IO.FileAccess]::Write
    $fileShare = [System.IO.FileShare]::None
    try { 
        $fileStream = New-Object -TypeName System.IO.FileStream $CALTempTablesPath, $fileMode, $fileAccess, $fileShare
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }

    $encoding = [System.Text.Encoding]::UTF8                
    try { 
        $writer = New-Object System.IO.StreamWriter $fileStream, $encoding
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }    

    $script:hasSetupFilters = $false
    $script:filters = @()
    SetupFilters -fieldFilter $fieldFilter

    $startId = 50000
    foreach ($table in $tables) {
        #Write-Host $table.Name

        $i++
        Write-Progress -Activity Progress -Status "$i of $totalTables tables processed"

        $hasFields = $false
        $fields = @()
        foreach ($field in $table.Fields) {
            #Write-Host $field.Name
            
            if (ShouldIgnoreField -field $field -ignoreFlowFields $ignoreFlowFields) {
                continue
            }

            $fields += $field
            $hasFields = $true
        }

        if (!$hasFields) {
            continue
        }
        
        $output = 'OBJECT ' + $table.ParentObjectType + ' ' + $startId + ' Temp ' + $table.Name
        $writer.WriteLine($output);
        $writer.WriteLine('{');
        $writer.WriteLine('  FIELDS');
        $writer.WriteLine('  {');

        $key = $table.Keys[0].Key
        $keyFields = $key.Split(",")
        foreach($keyFieldName in $keyFields) {
            $f = $table.Fields | where {($_.Name -eq $keyFieldName )}
            $line = '    { ' + $f.FieldNo + ';;' + $f.Name + ';' + $f.Datatype
            if ($f.OptionString) {
                $line += '; OptionString=' + $f.OptionString
            }
            $line += ' }'
            $writer.WriteLine($line);
        }

        foreach ($field in $fields) {
            #Write-Host $field.Name
            $line = '    { ' + $field.FieldNo + ';;' + $field.Name + ';' + $field.Datatype
            if ($field.OptionString) {
                $line += '; OptionString=' + $field.OptionString
            }
            $line += ' }'
            $writer.WriteLine($line);
        }
        $writer.WriteLine('  }');
        $writer.WriteLine('  KEYS');
        $writer.WriteLine('  {');
        $key = $table.Keys[0]
        $writer.WriteLine('    {    ;' + $key.Key + '; }');
        $writer.WriteLine('  }');
        $writer.WriteLine('}');
        $writer.WriteLine('');

        $startId += 1
    }
    $writer.Close();  
}

<#
    .SYNOPSIS
    Creates text file with the data upgrade codeunit that will support the data migration to C/AL temp tables.

    .DESCRIPTION
    The CreateCALTempDataUpgradeCodeunit function creates text file with the codeunit that will support the data migration to C/AL temp tables. A filter can be specified to select the fields range that should be considered.

    .EXAMPLE
    CreateCALTempDataUpgradeCodeunit 'C:\Output\TempDataMigrationCodeunit.txt'
    Create text file and export to C:\Output\TempDataMigrationCodeunit.txt.

    .EXAMPLE
    CreateCALTempDataUpgradeCodeunit 'C:\Output\TempDataMigrationCodeunit.txt' -fieldFilter '50000..50999'
    Create text file and export to C:\Output\TempDataMigrationCodeunit.txt, considering tables with fields in range 50000..50999.
#>

function CreateCALTempDataUpgradeCodeunit {
    Param (
            [Parameter(Mandatory=$true,Position=0)]
            [string] $TempDataMigrationCodeunitPath,
            [Parameter(Mandatory=$false)]
            [string] $fieldFilter,
            [Parameter(Mandatory=$false)]
            [string] $ignoreFlowFields = $true
        )

    $tables = $Model.NAVObjects | where {($_.ParentObjectType -eq 'Table')}
    #Write-Host $tables.Count
    if ($tables.Count -eq 0) {
        Write-Host "No tables to process."
        return
    }

    $totalTables = $tables.Count
    $i = 0

    $script:hasSetupFilters = $false
    $script:filters = @()
    SetupFilters -fieldFilter $fieldFilter

    $fileMode = [System.IO.FileMode]::Create
    $fileAccess = [System.IO.FileAccess]::Write
    $fileShare = [System.IO.FileShare]::None
    try { 
        $fileStream = New-Object -TypeName System.IO.FileStream $TempDataMigrationCodeunitPath, $fileMode, $fileAccess, $fileShare
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }

    $encoding = [System.Text.Encoding]::UTF8                
    try { 
        $writer = New-Object System.IO.StreamWriter $fileStream, $encoding
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }    

    $output = 'OBJECT Codeunit 50000 To Temp Tables Data Upgrade'
    $writer.WriteLine($output);
    $writer.WriteLine('{');
    $writer.WriteLine('  PROPERTIES');
    $writer.WriteLine('  {');
    $writer.WriteLine('    Subtype=Upgrade;');
    $writer.WriteLine('  }');
    $writer.WriteLine('  CODE');
    $writer.WriteLine('  {');
    $writer.WriteLine('    VAR');
    $writer.WriteLine('      DataUpgradeMgt@1000 : Codeunit 9900;');
    $writer.WriteLine('');
    $writer.WriteLine('    [TableSyncSetup]');
    $writer.WriteLine('    PROCEDURE GetTableSyncSetupCustom@50000(VAR TableSynchSetup@1000 : Record 2000000135);');
    $writer.WriteLine('    BEGIN');

    foreach ($table in $tables) {
        #Write-Host $table.Name

        $i++
        Write-Progress -Activity Progress -Status "$i of $totalTables tables processed"

        $hasFields = $false
        $fields = @()
        foreach ($field in $table.Fields) {
            #Write-Host $field.Name
            
            if (ShouldIgnoreField -field $field -ignoreFlowFields $ignoreFlowFields) {
                continue
            }

            $fields += $field
            $hasFields = $true
        }

        if (!$hasFields) {
            continue
        }
        
        $destinationTableName = 'Temp ' + $table.Name
        $output = '      DataUpgradeMgt.SetTableSyncSetup(DATABASE::"' + $table.Name + '",DATABASE::"' + $destinationTableName + '",TableSynchSetup.Mode::Copy);';
        $writer.WriteLine($output);
    }

    $writer.WriteLine('    END;');
    $writer.WriteLine('');
    $writer.WriteLine('    BEGIN');
    $writer.WriteLine('    END.');
    $writer.WriteLine('  }');
    $writer.WriteLine('}');

    $writer.Close()
}
<#
    .SYNOPSIS
    Creates text file with the data upgrade codeunit that will support the data migration to AL.

    .DESCRIPTION
    The CreateALDataUpgradeCodeunit function creates text file with the codeunit that will support the data migration to AL. A filter can be specified to select the fields range that should be considered.

    .EXAMPLE
    CreateALDataUpgradeCodeunit 'C:\Output\ALDataUpgradeCodeunit.al'
    Create text file and export to C:\Output\ALDataUpgradeCodeunit.al file.

    .EXAMPLE
    CreateALDataUpgradeCodeunit 'C:\Output\ALDataUpgradeCodeunit.al' -fieldFilter '50000..50999'
    Create text file and export to C:\Output\ALDataUpgradeCodeunit.al file, considering tables with fields in range 50000..50999.
#>

function CreateALDataUpgradeCodeunit {
    Param (
            [Parameter(Mandatory=$true,Position=0)]
            [string] $alFilePath,
            [Parameter(Mandatory=$false)]
            [string] $fieldFilter,
            [Parameter(Mandatory=$false)]
            [string] $ignoreFlowFields = $true
        )

    $tables = $Model.NAVObjects | where {($_.ParentObjectType -eq 'Table')}
    #Write-Host $tables.Count
    if ($tables.Count -eq 0) {
        Write-Host "No tables to process."
        return
    }

    $totalTables = $tables.Count
    $i = 0

    $script:hasSetupFilters = $false
    $script:filters = @()
    SetupFilters -fieldFilter $fieldFilter

    $fileMode = [System.IO.FileMode]::Create
    $fileAccess = [System.IO.FileAccess]::Write
    $fileShare = [System.IO.FileShare]::None
    try { 
        $fileStream = New-Object -TypeName System.IO.FileStream $alFilePath, $fileMode, $fileAccess, $fileShare
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }

    $encoding = [System.Text.Encoding]::UTF8                
    try { 
        $writer = New-Object System.IO.StreamWriter $fileStream, $encoding
    } catch {
        Write-Host "An error occurred:"
        Write-Host $_
        return
    }    

    $writer.WriteLine('codeunit 50100 "Data Upgrade Codeunit"');
    $writer.WriteLine('{');
    $writer.WriteLine('  Subtype = Upgrade;');
    $writer.WriteLine('');
    $writer.WriteLine('  trigger OnRun()');
    $writer.WriteLine('  begin');
    $writer.WriteLine('  end;');
    $writer.WriteLine('');

    $toMigrateTablesArray = @()
    foreach ($table in $tables) {
        #Write-Host $table.Name

        $i++
        Write-Progress -Activity Progress -Status "$i of $totalTables tables processed"

        $hasFields = $false
        $fields = @()
        foreach ($field in $table.Fields) {
            #Write-Host $field.Name
            
            if (ShouldIgnoreField -field $field -ignoreFlowFields $ignoreFlowFields) {
                continue
            }

            $fields += $field
            $hasFields = $true
        }

        if (!$hasFields) {
            continue
        }
        
        $escapedTableName = $table.Name.Replace(' ', '_')

        $writer.WriteLine('  local procedure ' + $escapedTableName + '()');
        $writer.WriteLine('  var');
        $writer.WriteLine('    DestinyTable: Record "' + $table.Name + '";');
        $writer.WriteLine('    OriginTable: Record "Temp ' + $table.Name + '";');
        $writer.WriteLine('  begin');
        $writer.WriteLine('    With OriginTable do begin');
        $writer.WriteLine('      if FindSet() then');
        $writer.WriteLine('      repeat');
        $writer.WriteLine('        DestinyTable.Init();');

        foreach ($field in $fields) {
            #Write-Host $field.Name
            $writer.WriteLine('        DestinyTable."' + $field.Name + '" := OriginTable."' + $field.Name + '";');
        }
        
        $writer.WriteLine('        DestinyTable.Insert;');
        $writer.WriteLine('      until next = 0;');
        $writer.WriteLine('      //DeleteAll();');
        $writer.WriteLine('    end;');
        $writer.WriteLine('  end;');
        $writer.WriteLine('');
    
        $toMigrateTablesArray += $escapedTableName
    }

    $writer.WriteLine('  trigger OnUpgradePerCompany()');
    $writer.WriteLine('  begin');
    foreach ($p in $toMigrateTablesArray) {
        $writer.WriteLine('    ' + $p + ';');
    }
    $writer.WriteLine('  end;');
    $writer.WriteLine('}');            

    $writer.Close();    
}

function ShouldIgnoreField {
    Param (
            [Parameter(Mandatory=$true)]
            [System.Object] $field,
            [Parameter(Mandatory=$false)]
            [string] $ignoreFlowFields = $true
        )

    if ($ignoreFlowFields) {
        if (($field.FieldClass -eq "FlowField") -or ($field.FieldClass -eq "FlowFilter")) {
            return $true
        }
    }
    
    $inRange = $field.FieldNo -in $script:filters
    return !$inRange
}

function SetupFilters {
    Param (
        [Parameter(Mandatory=$false)]
        [ValidateScript({
            if ($_ -match "^[0-9\|\.]*$") {
              $True
            }
            else {
              Throw "$_ is not a valid field filter. Use .. or | to filter."
            }
          })]
        [string] $fieldFilter
    )

    if ($script:hasSetupFilters) {
        return
    }

    if ($fieldFilter -match '[|]+') {
        $filtersArray = $fieldFilter.Split('|');
        foreach ($filter in $filtersArray) {
            $f = invoke-expression $filter
            $script:filters += $f
        }
    } else {
        $f = invoke-expression $fieldFilter
        $script:filters += $f
    }
    $script:hasSetupFilters = $true;
}

Export-ModuleMember -Function CreateCALFieldsCSV
Export-ModuleMember -Function CreateCALTempTables
Export-ModuleMember -Function CreateCALTempDataUpgradeCodeunit
Export-ModuleMember -Function CreateALDataUpgradeCodeunit