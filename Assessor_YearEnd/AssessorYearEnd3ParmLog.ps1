<#param (
    # after 0=Before, 1=After
    [Parameter(Mandatory=$true)]
    [int]$after
)#>
$after = $args[0]
# Override
#$after = 0
clear-host

$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

$sourceServer = "$($environment)dcetl-mst01"
$sourceDatabase = "ssisdb"
#$sourceTable = "catalog.environment_variables"
$sourceConnectionString = "Data Source=${sourceServer};Initial Catalog=${sourceDatabase};Integrated Security=SSPI;TrustServerCertificate=True;"

$destinationServer = "${environment}dcetl-sql01"
$destinationDatabase = "ssislogging"
$destinationTable = "EndOfYear_Parameters"
$destinationConnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security=SSPI;TrustServerCertificate=True;"

$query = "SELECT c.name [ParameterName], c.value [ParameterValue], cast (${after} as bit) [After], '${environment}DCETL-MST01.SSISDB.catalog.environment_variables' [Source]
FROM [catalog].[environments] env 
JOIN [catalog].[folders] fld
    ON env.[folder_id] = fld.[folder_id]
        AND env.[name] = 'assessor_ods2'
        AND fld.name = 'assessor_ods2'
JOIN [catalog].[environment_variables] c
    ON c.environment_id = env.environment_id
WHERE c.name in (
    'AssessorDetailYears', 
	'AssessorNOVYears')"

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