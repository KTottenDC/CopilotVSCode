# Step 8
# Server:  \\prrealware-app\Photos\DATA
# Backup meta.json file
Import-Module .\AssessorYearEndFunctions.psm1

#Variables
$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

#Variables
$metaFileFolder = "\\${environment}rw2-app01\Photos\DATA" # This is the folder where the meta.json file is located
$metaFileName = "meta.json"
$currentYear = (get-date).Year
$metaFileBackupName = "$metaFileName.$currentYear"

$callingScript = "AssessorYearEnd8.ps1"
$scriptName = "AssessorYearEnd8.ps1"

<# Reset
	Get-ChildItem -Path "$metaFileFolder\$metaFileBackupName" | Remove-Item
#>

# copy current meta.json to backup file
Copy-Item -Path "$metaFileFolder\$metaFileName" -Destination "$metaFileFolder\$metaFileBackupName"



if(Get-ChildItem -Path "$metaFileFolder\$metaFileBackupName" -File | Select-Object -First 1)
{
    $BackupFound = "${metaFileBackupName} Found!"
}   
else
{
    $BackupFound = "${metaFileBackupName} Not Found!"
}

$insertQuery = "INSERT INTO [$destinationDatabase].[dbo].[$destinationTable] (ParameterName, ParameterValue, After, Source) VALUES 
('$metaFileFolder\$metaFileBackupName', '$BackupFound', Cast(1 as bit), '${callingScript}')"

# Insert into Audit Log if the back can be found
$destconnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
Invoke-Sqlcmd -ConnectionString $destconnectionString -Query $insertQuery


if ($error)
{
    #Write-Host $error.ToString()

    #log error, "Execption Handling" & throw exeception
    LogException -Caller $callingScript -ScriptName $scriptName -ExceptionText $error
}

