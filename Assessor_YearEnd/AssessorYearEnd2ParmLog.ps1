<#param (
    # after 0=Before, 1=After
    [Parameter(Mandatory=$true)]
    [int]$after
)#>
$after = $args[0]
clear-host

$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "UA"

$sourceServer = "${environment}rw2-sql01"
$sourceDatabase = "assessor_extract"
$sourceConnectionString = "Data Source=${sourceServer};Initial Catalog=${sourceDatabase};Integrated Security = SSPI;TrustServerCertificate=True;"

$destinationServer = "${environment}dcetl-sql01"
$destinationDatabase = "ssislogging"
$destinationTable = "EndOfYear_Parameters"
$destinationConnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security = SSPI;TrustServerCertificate=True;"

$query = "select [ETL_NAME] [ParameterName], [PARAMETER_VALUE] [ParameterValue], cast (${after} as bit) [After], '${envionment}RW2-SQL01.assessor_extract.dbo.WebETL' [Source]
from [dbo].[WebETL]
where [ETL_NAME] in 
('ASR_PERS_VALUE_FREEZE_FLAG',
'ASR_PERS_VALUE_FREEZE_TAX_YEAR',
'ASR_PERS_VALUE_FREEZE_VERSION_END_DATE',
'ASR_PERS_VALUE_FREEZE_VERSION_START_DATE',
'ASR_VALUE_FREEZE_FLAG',
'ASR_VALUE_FREEZE_TAX_YEAR',
'ASR_VALUE_FREEZE_VERSION_END_DATE',
'ASR_VALUE_FREEZE_VERSION_START_DATE',
'ASSESSMENT_TAX_YEAR')"
$data = Invoke-Sqlcmd -ConnectionString $sourceConnectionString -Query $query

foreach ($row in $data) {
    $insertQuery = "INSERT INTO [$destinationDatabase].[dbo].[$destinationTable] (ParameterName, ParameterValue, After, Source) VALUES ("
    $insertQuery += "'" + $row.ParameterName + "', "
    $insertQuery += "'" + $row.ParameterValue + "', "

    if (!($row.After))
    { $insertQuery += "0, " }
    else
    { $insertQuery += "1, " }

    $insertQuery += "'" + $row.Source + "')"
    Invoke-Sqlcmd -ConnectionString $destinationConnectionString -Query $insertQuery
}