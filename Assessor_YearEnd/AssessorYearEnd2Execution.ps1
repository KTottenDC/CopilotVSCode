clear-host

Import-Module .\AssessorYearEndFunctions.psm1


$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

$sourceServer = "${environment}rw2-sql01"
$sourceDatabase = "assessor_extract"
$callingScript = "AssessorYearEnd2Execution"
$scriptName = "AssessorYearEnd2.sql"

# Path on server will be E:\Scripts\Assessor_End_of_Year_Action_Plan?
$inputFile = "E:\scripts\AssessorYearEnd\AssessorYearEnd2.sql"


$connectionString = "Data Source=${sourceServer};Initial Catalog=${sourceDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $inputFile

if ($error)
{
    #Write-Host $error.ToString()

    #log error, "Execption Handling" & throw exeception
    LogException -Caller $callingScript -ScriptName $scriptName -ExceptionText $error
}