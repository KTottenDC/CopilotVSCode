-- Step 13 - Enable Job 'assessor_ETL_master_run' on PRETLASR
-- This server has been moved to the Azure Cloud, need to convert to Azure API that will disable the ProcFwk
-- Note: this job is to be executed the first day beginnning of the new year, the 2nd or the 3rd

-- Server: UAETLASR
-- Set to SQLCMD Mode

DECLARE @debug bit = 0 -- 0=False anything else is true
DECLARE @enable bit = 0 -- 0=False anything else is true
 --  Environments DV,UA,PR
 

-- ************ ODS2 ************
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