clear-host

Import-Module .\AssessorYearEndFunctions.psm1
#Setup the connection string to correct env

$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
$environment = "UA"

$sourceServer = "$($environment)rw2-sql01"
if ($environment -eq "UA") #UA will be UARWWODS
{$sourceDatabase = "UARWODS"}
else {$sourceDatabase = "PRRWODS"}

#$sourceTable = [ODS_EXTRACT_ASR].[ETL_PARAMETER] -- reference only
$callingScript = "AssessorYearEnd4aExecution"
$scriptName = "AssessorYearEnd4a.sql"

# Path on server will be E:\Scripts\Assessor_End_of_Year_Action_Plan?
$inputFile = "E:\scripts\AssessorYearEnd\AssessorYearEnd4a.sql"
#$inputFile = "\\dvdcetl-mst01\e$\scripts\AssessorYearEnd\AssessorYearEnd4a.sql"
#$inputFile = "C:\PowerShell\AssessorYearEnd\AssessorYearEnd4a.sql"

$connectionString = "Data Source=${sourceServer};Initial Catalog=${sourceDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $inputFile 

if ($error)
{
    #Write-Host $error.ToString()

    #log error, "Execption Handling" & throw exeception
    LogException -Caller $callingScript -ScriptName $scriptName -ExceptionText $error
}