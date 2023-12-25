clear-host
<#param (
    # after 0=Before, 1=After
    [Parameter(Mandatory=$true)]
    [int]$after
)#>
$after = $args[0]

$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

$sourceServer = "$($environment)rw2-sql01"
if ($environment -eq "UA") #UA will be UARWWODS
{$sourceDatabase = "UARWWODS"}
else {$sourceDatabase = "PRRWODS"}
$sourceTable = "[ODS_EXTRACT_ASR].[ETL_PARAMETER]"

$destinationServer = "${environment}dcetl-sql01"
$destinationDatabase = "ssislogging"
$destinationTable = "EndOfYear_Parameters"


$query = "select [PARAMETER_NAME], [PARAMETER_VALUE], cast (${after} as bit) [After], '${sourceServer}.${sourceDatabase}.ODS_EXTRACT_ASR.ETL_PARAMETER' [Source]
from [ODS_EXTRACT_ASR].[ETL_PARAMETER]
where [Parameter_Name] in 
(
'ASR_VALUE_FREEZE_FLAG',
'ASR_PERS_VALUE_FREEZE_FLAG',
'ASR_PERS_VALUE_FREEZE_TAX_YEAR',
'ASR_PERS_VALUE_FREEZE_VERSION_END_DATE',
'ASR_PERS_VALUE_FREEZE_VERSION_START_DATE',
'ASR_VALUE_FREEZE_TAX_YEAR',
'ASR_VALUE_FREEZE_VERSION_END_DATE',
'ASR_VALUE_FREEZE_VERSION_START_DATE',
'ASSESSMENT_TAX_YEAR'
)"

$srcconnectionString = "Data Source=${sourceServer};Initial Catalog=${sourceDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
$data = Invoke-Sqlcmd -ConnectionString $srcconnectionString -Query $query

#-ServerInstance $sourceServer -Database $sourceDatabase -Query $query -TrustServerCertificate "True" -IntegratedSecurity "SSPI"

foreach ($row in $data) {
    $insertQuery = "INSERT INTO [$destinationDatabase].[dbo].[$destinationTable] (ParameterName, ParameterValue, After, Source) VALUES ("
    $insertQuery += "'" + $row.Parameter_Name + "', "
    $insertQuery += "'" + $row.PARAMETER_VALUE + "', "

    if (!($row.After))
    { $insertQuery += "0, " }
    else
    { $insertQuery += "1, " }

    $insertQuery += "'" + $row.Source + "')"
    $destconnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"
    Invoke-Sqlcmd -ConnectionString $destconnectionString -Query $insertQuery
}