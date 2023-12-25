clear-host

#Updated for Job Steps
Import-Module .\AssessorYearEndFunctions.psm1
#Setup the connection string to correct env

$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

$sourceServer = "$($environment)rw2-sql01"
$sourceDatabase = "master"

$destinationServer = "${environment}dcetl-sql01"
$destinationDatabase = "ssislogging" #Audit Log
$destinationTable = "EndOfYear_Parameters"

$callingScript = "AssessorYearEnd6Execution"
$scriptName = "AssessorYearEnd6.sql"

$inputFile = "E:\scripts\AssessorYearEnd\AssessorYearEnd6.sql"

$connectionString = "Data Source=${sourceServer};Initial Catalog=${sourceDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $inputFile 

switch ($environment) {
    "DV" {
        $databasename = "PRRW_TEST"
        $backuppath = "\\DVRW2-SQL01\E$\backups"
    }
    "UA" {
        $databasename = "PRRW_UPGRADE"
        $backuppath = "\\UARW2-SQL01\E$\backups"
    }
    "PR" {
        $databasename = "PRRW"
        $backuppath = "\\prfsdept\common\assor\v5db\"
    }
}

$date = Get-Date -format "yyyyMMdd"
$fileName = "${backuppath}\${databasename}_${date}*.bak"
if(Get-ChildItem -Path $fileName -File | Select-Object -First 1)
{
    $BackupFound = "Backup Found!"
}   
else
{
    $BackupFound = "Backup Not Found!"
}

$insertQuery = "INSERT INTO [$destinationDatabase].[dbo].[$destinationTable] (ParameterName, ParameterValue, After, Source) VALUES 
('$fileName', '$BackupFound', Cast(1 as bit), '${callingScript}')"

# Insert into Audit Log if the back can be found
$destconnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
Invoke-Sqlcmd -ConnectionString $destconnectionString -Query $insertQuery


if ($error)
{
    #Write-Host $error.ToString()

    #log error, "Execption Handling" & throw exeception
    LogException -Caller $callingScript -ScriptName $scriptName -ExceptionText $error
}

