# Step 9
# Server:  \\prrealware-app\Photos\DATA
# Change Tax Year for new year for the drop down values
Import-Module .\AssessorYearEndFunctions.psm1

#Variables
$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

#Variables
$metaFileFolder = "\\${environment}rw2-app01\Photos\DATA" 
$metaFileName = "meta.json"
$metaFileContent = Get-Content -Raw -Path "$metaFileFolder\$metaFileName" | ConvertFrom-Json
#$currentYear = (get-date).Year
$newYear = (get-date).AddYears(1).Year
$callingScript = "AssessorYearEnd9.ps1"
$scriptName = "AssessorYearEnd9.ps1"

if ($metaFileContent.taxYears[$metaFileContent.taxYears.count-1] -ne $newYear)
{ # if the new tax year is not in the list then add it and save.
    $metaFileContent.taxYears += $newYear.ToString()
    $metaFileContent | ConvertTo-Json | Out-File "$metaFileFolder\$metaFileName"
}


$metajson = "$($newYear.ToString()) added to tax year list."

$insertQuery = "INSERT INTO [$destinationDatabase].[dbo].[$destinationTable] (ParameterName, ParameterValue, After, Source) VALUES 
('$metaFileFolder\$metaFileName', '$metajson', Cast(1 as bit), '${callingScript}')"

# Insert into Audit Log if the back can be found
$destconnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
Invoke-Sqlcmd -ConnectionString $destconnectionString -Query $insertQuery


if ($error)
{
    #Write-Host $error.ToString()

    #log error, "Execption Handling" & throw exeception
    LogException -Caller $callingScript -ScriptName $scriptName -ExceptionText $error
}

