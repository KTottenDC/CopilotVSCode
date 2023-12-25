-- Step 12 - Enable Job '** Run ALL JOBS ETL for ODS2'
-- Note: this job is to be executed the first day beginnning of the new year, the 2nd or the 3rd

-- Server: UAASSRETL
-- Set to SQLCMD Mode 

DECLARE @debug bit = 0 -- 0=False anything else is true
DECLARE @enable bit = -1 -- 0=False anything else is true

 --  Environments DV,UA,PR

-- ************ ODS2 ************
-- DV
-- :CONNECT DVASSRETL

-- UA
-- :CONNECT UAASSRETL

--PR
-- :CONNECT PRASSRETL


-- Step 10 - Disable Job '** Run ALL JOBS ETL for ODS2'
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs where name = '** Run ALL JOBS ETL for ODS2')
BEGIN
	IF (@debug = 0)
		EXEC msdb.dbo.sp_update_job @job_name='** Run ALL JOBS ETL for ODS2',@enabled = @enable
	ELSE
		SELECT 'DEBUG', * FROM msdb.dbo.sysjobs where name = '** Run ALL JOBS ETL for ODS2'
END
