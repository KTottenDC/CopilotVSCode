-- Step 10 - Disable Job '** Run ALL JOBS ETL for ODS2'

-- Server: UAASSRETL
-- Set to SQLCMD Mode 

DECLARE @debug bit = 0 -- 0=False anything else is true
DECLARE @enable bit = 0 -- 0=False anything else is true

 --  Environments DV,UA,PR

-- ************ ODS2 ************
-- DV
-- :CONNECT DVASSRETL

-- UA
-- :CONNECT UAASSRETL

--PR
-- :CONNECT PRASSRETL


-- 
SELECT * FROM msdb.dbo.sysjobs where name = '** Run ALL ETL for ODS2'
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs where name = '** Run ALL ETL for ODS2')
BEGIN
	IF (@debug = 0)
		EXEC msdb.dbo.sp_update_job @job_name='** Run ALL ETL for ODS2',@enabled = @enable
	ELSE
		SELECT 'DEBUG', * FROM msdb.dbo.sysjobs where name = '** Run ALL ETL for ODS2'
END
