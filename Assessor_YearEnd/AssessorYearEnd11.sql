-- Step 11 - Disable ADF Trigger 'Daily 0430 ODS1' on adf-dw-pr-westus3
-- This server has been moved to the Azure Cloud, need to convert to Azure API that will disable the ProcFwk

-- Server: UAETLASR
-- Set to SQLCMD Mode 

DECLARE @debug bit = 0 -- 0=False anything else is true
DECLARE @enable bit = 0 -- 0=False anything else is true
 --  Environments DV,UA,PR
 

-- ************ ODS1 ************
-- DV
-- :CONNECT DVETLASR -- Server does not exist in DV

-- UA
 -- :CONNECT UAETLASR

--PR
-- :CONNECT PRETLASR



IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs where name = 'assessor_ETL_master_run')
BEGIN
	IF (@debug = 0)
		EXEC msdb.dbo.sp_update_job @job_name='assessor_ETL_master_run',@enabled = @enable
	ELSE
		SELECT 'DEBUG', * FROM msdb.dbo.sysjobs where name = 'assessor_ETL_master_run'
END