clear-host

# DV
#:CONNECT sql-dw-dv-westus3.database.windows.net
#USE [ods_rw_staging]
$username = "dcadmin"
$password = 'x0h3^hDtuhpZ0VrhaFnk2!86c8mm9'

# PR
#:CONNECT sql-dw-dv-westus3.database.windows.net
#USE [ods_rw_staging]
$username = "dcadmin"
$password = 'cDdk%c979WPf72dMT7&'

#local script path
#$dir = "C:\Users\ktotten\source\repos\Assessor_End_of_Year_Action_Plan\Scripts"

#Updated for Job Steps
Import-Module ".\AssessorYearEndFunctions.psm1"
#Setup the connection string to correct env

Import-Module -Name SqlServer

$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

$sourceServer = "sql-dw-$($environment)-westus3.database.windows.net"
$sourceDatabase = "ods_rw_staging"
#$sourceTable = [ODS_EXTRACT_ASR].[ETL_PARAMETER] -- reference only
$callingScript = "AssessorYearEnd4bExecution"
$scriptName = "AssessorYearEnd4b.sql"

# Path on server will be E:\Scripts\Assessor_End_of_Year_Action_Plan?
$inputFile = "E:\scripts\AssessorYearEnd\AssessorYearEnd4b.sql"
#$inputFile = "\\dvdcetl-mst01\e$\scripts\AssessorYearEnd\AssessorYearEnd4b.sql"
#$inputFile = "C:\PowerShell\AssessorYearEnd\AssessorYearEnd4b.sql"

$connectionString = "Server=$sourceServer;Database=$sourceDatabase;User ID=$username;Password=$password;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
    #Write-Host "Connection test successful. Able to retrieve data."
    Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $inputFile

if ($error)
{
    #Write-Host $error.ToString()

    #log error, "Execption Handling" & throw exeception
    LogException -Caller $callingScript -ScriptName $scriptName -ExceptionText $error
}



