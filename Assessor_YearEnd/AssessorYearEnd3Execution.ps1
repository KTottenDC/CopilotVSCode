clear-host
#[Environment]::CurrentDirectory=(Get-Location -PSProvider FileSystem).ProviderPath
Import-Module .\AssessorYearEndFunctions.psm1
#Still need check before and after values and record for auditing

$environment = $env:COMPUTERNAME.Substring(0,2)

# Override
#$environment = "DV"

$sourceServer = "$($environment)DCETL-MST01"
$sourceDatabase = "ssisdb"
#$sourceTable = #Proc Calls
$callingScript = "AssessorYearEnd3Execution"
$scriptName = "AssessorYearEnd3.sql"

# Path on server will be E:\Scripts\Assessor_End_of_Year_Action_Plan?
$inputFile = "E:\scripts\AssessorYearEnd\AssessorYearEnd3.sql"
#$inputFile = "C:\PowerShell\AssessorYearEnd\AssessorYearEnd3.sql"


$connectionString = "Data Source=${sourceServer};Initial Catalog=${sourceDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
$data = Invoke-Sqlcmd -ConnectionString $connectionString -InputFile $inputFile 

#-ServerInstance $sourceServer -Database $sourceDatabase -InputFile $inputFile 

if ($error)
{
    #Write-Host $error.ToString()

    #log error, "Execption Handling" & throw exeception
    LogException -Caller $callingScript -ScriptName $scriptName -ExceptionText $error
}