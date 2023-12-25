# Step 5 & 7
# Server: xxrw2-app01

#Variables
$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"


#$sourceFolder = "\\uarealware-app\Photos\DATA" #UA
$sourceFolder = "\\${environment}rw2-app01\Photos\DATA" #
$destinationFolder = "\\${environment}rw2-app01\Photos\DATA" #
$currentYear = (get-date).Year
$newYear = (get-date).AddYears(1).Year
$subFolderDetail = "detail"
$subFolderNov = "nov"
$subFolderNod = "nod"

$callingScript = "AssessorYearEnd5.ps1"
$destinationServer = "${environment}dcetl-sql01"
$destinationDatabase = "ssislogging" #Audit Log
$destinationTable = "EndOfYear_Parameters"
<# Reset
	Get-ChildItem -Path $destinationFolder/$newYear -Recurse | Remove-Item
#>

#Step 5 - create the directory structure
if (!(Test-Path "$destinationFolder\$newYear\$subFolderDetail"))
{ mkdir -Path $destinationFolder -Name $newYear\$subFolderDetail }

if (!(Test-Path "$destinationFolder\$newYear\$subFolderNov"))
{ mkdir -Path $destinationFolder -Name $newYear\$subFolderNov }

if (!(Test-Path "$destinationFolder\$newYear\$subFolderNod"))
{ mkdir -Path $destinationFolder -Name $newYear\$subFolderNod }


#Step 7 - copy all JSON files from Current year to new year
#Copy-Item -Path "$sourceFolder\$currentYear\$subFolderDetail\*.*" -Destination "$destinationFolder\$newYear\$subFolderDetail"
robocopy "$sourceFolder\$currentYear\$subFolderDetail" "$destinationFolder\$newYear\$subFolderDetail" "*.json" "/njh"

#Copy-Item -Path "$sourceFolder\$currentYear\$subFolderNov\*.*" -Destination "$destinationFolder\$newYear\$subFolderNov"
RoboCopy "$sourceFolder\$currentYear\$subFolderNov" "$destinationFolder\$newYear\$subFolderNov" "*.json" "/njh"

#Copy-Item -Path "$sourceFolder\$currentYear\$subFolderNod\*.*" -Destination "$destinationFolder\$newYear\$subFolderNod"
robocopy "$sourceFolder\$currentYear\$subFolderNod" "$destinationFolder\$newYear\$subFolderNod" "*.json" "/njh"


# $directoryext = @("\detail", "\nod", "\nov")
$directory1 = "$sourceFolder\$currentYear"
$directory2 = "$destinationFolder\$newYear"

$jsonCount1 = (Get-ChildItem -Path $directory1 -Filter "*.json" -File -Recurse).Count
$jsonCount2 = (Get-ChildItem -Path $directory2 -Filter "*.json" -File -Recurse).Count

"JSON count for directory1: $jsonCount1"
"JSON count for directory2: $jsonCount2"

if ($jsonCount1 -gt $jsonCount2) {
    "Previous Year, ${directory1}  has more JSON files than New Year ${directory2}"
} elseif ($jsonCount1 -lt $jsonCount2) {
    "New Year ${directory2} has more JSON files than Previous Year, ${directory1}."
} else {
    "Both directories have the same number of JSON files."
}

$insertQuery = "INSERT INTO [$destinationDatabase].[dbo].[$destinationTable] (ParameterName, ParameterValue, After, Source) VALUES 
('${directory1}', '${jsonCount1}', Cast(0 as bit), '${callingScript}')
,('${directory2}', '${jsonCount2}', Cast(1 as bit), '${callingScript}')"

# Insert into Audit Log using the destination connection string
$destconnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
   Invoke-Sqlcmd -ConnectionString $destconnectionString -Query $insertQuery
