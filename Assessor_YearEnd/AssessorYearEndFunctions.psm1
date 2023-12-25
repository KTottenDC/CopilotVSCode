function LogException
{
    param([string] $Caller          = $(throw "The ""Caller"" parameter is required")
        , [string] $ScriptName      = $(throw "The ""ScriptName"" parameter is required")
        , [string] $ExceptionText   = $(throw "The ""ExceptionText"" parameter is required")
        )

    $environment = $env:COMPUTERNAME.Substring(0,2)
    # Override
    #$environment = "DV"

    # Replace single quotes with two single quotes
    $cleanExceptionText = $ExceptionText -replace '''', '''''' #-replace '[^\x20-\x7E]', '' 

    $destinationServer = "$($environment)dcetl-sql01"
    $destinationDatabase = "SSISLOGGING"
    $destinationTable = "EndOfYear_Exception"

    $insertQuery = "INSERT INTO ${destinationTable} 
    (Caller, ScriptName, Exception, ErrorTs)
    VALUES (
       '${Caller}'
      ,'${ScriptName}'
      ,'${cleanExceptionText}'
      ,GETDATE())"

    Invoke-Sqlcmd -ServerInstance $destinationServer -Database $destinationDatabase -Query $insertQuery
}