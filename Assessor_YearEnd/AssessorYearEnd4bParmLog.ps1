clear-host
<#param (
    # after 0=Before, 1=After
    [Parameter(Mandatory=$true)]
    [int]$after
)#>
$after = $args[0]
$username = "dcadmin"
$password = "x0h3^hDtuhpZ0VrhaFnk2!86c8mm9"

$environment = $env:COMPUTERNAME.Substring(0,2)
# Override
#$environment = "DV"

$sourceServer = "sql-dw-$($environment)-westus3.database.windows.net"
$sourceDatabase = "ods_rw_staging"
#$sourceTable = "[ods_rw_staging].[dbo].[ETL_PARAMETER]"

$destinationServer = "${environment}dcetl-sql01"
$destinationDatabase = "ssislogging" #Audit Log
$destinationTable = "EndOfYear_Parameters"

$query = "select [PARAMETER_NAME], [PARAMETER_VALUE], cast (${after} as bit) [After], '${sourceServer}.${sourceDatabase}.dbo.ETL_PARAMETER' [Source]
FROM [dbo].[etl_parameter]
where [PARAMETER_NAME] in 
('ASSESSMENT_TAX_YEAR',
 'ASR_VALUE_FREEZE_FLAG',
 'ASR_PERS_VALUE_FREEZE_FLAG'
)"

$srcconnectionString = "Server=$sourceServer;Database=$sourceDatabase;User ID=$username;Password=$password;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
$data = Invoke-Sqlcmd -ConnectionString $srcconnectionString -Query $query

# Insert into Audit Log using the destination connection string
$destconnectionString = "Data Source=${destinationServer};Initial Catalog=${destinationDatabase};Integrated Security = SSPI; TrustServerCertificate=True;"

foreach ($row in $data) {
    $insertQuery = "INSERT INTO [$destinationDatabase].[dbo].[$destinationTable] (ParameterName, ParameterValue, After, Source) VALUES ("
    $insertQuery += "'" + $row.Parameter_Name + "', "
    $insertQuery += "'" + $row.PARAMETER_VALUE + "', "

    if (!($row.After))
    { $insertQuery += "0, " }
    else
    { $insertQuery += "1, " }

    $insertQuery += "'" + $row.Source + "')"

   Invoke-Sqlcmd -ConnectionString $destconnectionString -Query $insertQuery
}

