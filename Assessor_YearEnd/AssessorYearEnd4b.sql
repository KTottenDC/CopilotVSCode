-- Step 4b
-- Server: sql-dw-xx-westus3.database.windows.net
-- DB: ods_rw_staging
-- Credentials: t1-[UserName] or DCAdmin

-- Set to SQLCMD Mode (Step 4b - Update ETL PARAMETERS in PRRW2-SQL01 (ODS1 ) 
-- Azure Trigger: Daily 0430 ODS1

DECLARE @debug bit = 0 -- Default 0=False  Anything else is True

 --  Environments DV,UA,PR
 

-- ************ ODS1 ************
-- DV
--:CONNECT sql-dw-dv-westus3.database.windows.net
--USE [ods_rw_staging]
--SQLLogin: dcadmin
--password: x0h3^hDtuhpZ0VrhaFnk2!86c8mm9

-- UA
--:CONNECT sql-dw-ua-westus3.database.windows.net
--USE [ods_rw_staging]

--PR
--:CONNECT sql-dw-pr-westus3.database.windows.net
--USE [ods_rw_staging]
--SQLLogin: dcadmin
--password: cDdk%c979WPf72dMT7&


DECLARE @Backup varchar(250), @ParamValue varchar(100), @FreezeFlag varchar(100) = 'Y', @CurrentYear int, @AssementYear int, @EndTime varchar(100) = '1231999'
IF (MONTH(GETDATE()) = 12)
    SET @CurrentYear = YEAR(GETDATE())
ELSE
	SET @CurrentYear = YEAR(GETDATE()) - 1
	-- Reset
	-- SET @CurrentYear = 2022

SET @AssementYear = @CurrentYear + 1
SET @ParamValue = (cast(@CurrentYear as varchar(4)) + @EndTime)
-- Log @CurrentYear, @NewYear, @ParamValue, @FreezeFlag

-- Backup before making changes
IF (@debug = 0)
BEGIN
	SET @Backup = 'IF NOT EXISTS (SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = ''ETL_PARAMETER_12_31_' + cast(@CurrentYear as varchar(4)) + ''')'
		+ ' SELECT * INTO [ods_rw_staging].[dbo].[ETL_PARAMETER_12_31_' + cast(@CurrentYear as varchar(4)) + '] FROM [ods_rw_staging].[dbo].[ETL_PARAMETER]'
	select @Backup
	EXEC (@Backup)
END
ELSE
	SELECT 'debug', * FROM [ods_rw_staging].[dbo].[ETL_PARAMETER]

-- Log before and After Update
-- Parameter Value Update
EXEC [dbo].[usp_etl_parameter_update] 'ASSESSMENT_TAX_YEAR',@AssementYear,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_VALUE_FREEZE_FLAG',@FreezeFlag,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_PERS_VALUE_FREEZE_FLAG',@FreezeFlag,@debug

-- Tests: Run against [ods_rw_staging]
/*
SELECT [PARAMETER_NAME]
      ,[PARAMETER_VALUE]
      ,[PARAMETER_DESCR]
      ,[CREATE_DTM]
      ,[CREATE_USER_ID]
      ,[UPDATE_DTM]
      ,[UPDATE_USER_ID]
  FROM [dbo].[etl_parameter]
  WHERE [PARAMETER_NAME] IN
('ASSESSMENT_TAX_YEAR',
 'ASR_VALUE_FREEZE_FLAG',
 'ASR_PERS_VALUE_FREEZE_FLAG',
 'ASSESSMENT_TAX_YEAR'
)
*/
