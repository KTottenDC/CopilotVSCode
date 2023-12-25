-- Step 4a
-- Server: XXRW2-SQL01
-- DB: XXWODS
-- Needed Credentials: T0

-- Set to SQLCMD Mode (Step 4a - Update ETL PARAMETERS in PRRW2-SQL01 (ODS1 )

DECLARE @debug bit = 0 -- Default 0=False  Anything else is True

 --  Environments DV,UA,PR
 

-- ************ ODS1 ************
-- DV
-- :CONNECT DVRW2-SQL01
-- USE [PRRWODS]

-- UA
-- :CONNECT UARW2-SQL01
-- USE [UARWODS]

--PR
-- :CONNECT PRRW2-SQL01
-- USE [PRRWODS]

DECLARE @Backup varchar(250), @ParamValue varchar(100), @FreezeFlag varchar(1) = 'Y', @CurrentYear int, @AssementYear int, @EndTime varchar(100) = '1231999'
IF (MONTH(GETDATE()) = 12)
    SET @CurrentYear = YEAR(GETDATE())
ELSE
	SET @CurrentYear = YEAR(GETDATE()) - 1
--SET @CurrentYear = 2022

SET @AssementYear = @CurrentYear + 1
SET @ParamValue = (cast(@CurrentYear as varchar(4)) + @EndTime)
--select @CurrentYear, @AssementYear, @ParamValue

-- Backup before making changes
IF (@debug = 0)
BEGIN
	SET @Backup = 'IF NOT EXISTS (SELECT 1 from INFORMATION_SCHEMA.TABLES where TABLE_NAME = ''ETL_PARAMETER_12_31_' + cast(@CurrentYear as varchar(4)) + ''')'
		+ ' SELECT * INTO [ODS_EXTRACT_ASR].[ETL_PARAMETER_12_31_' + cast(@CurrentYear as varchar(4)) + '] FROM [ODS_EXTRACT_ASR].[ETL_PARAMETER]'
	--select @Backup
	EXEC (@Backup)
END
ELSE
	SELECT 'debug', * FROM [ODS_EXTRACT_ASR].[ETL_PARAMETER]


-- Log before and After Update
-- Parameter Value Update
EXEC [dbo].[usp_etl_parameter_update] 'ASSESSMENT_TAX_YEAR',@AssementYear,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_VALUE_FREEZE_FLAG',@FreezeFlag,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_PERS_VALUE_FREEZE_FLAG',@FreezeFlag,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_PERS_VALUE_FREEZE_TAX_YEAR',@CurrentYear,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_PERS_VALUE_FREEZE_VERSION_END_DATE',@ParamValue,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_PERS_VALUE_FREEZE_VERSION_START_DATE',@ParamValue,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_VALUE_FREEZE_TAX_YEAR',@CurrentYear,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_VALUE_FREEZE_VERSION_END_DATE',@ParamValue,@debug
EXEC [dbo].[usp_etl_parameter_update] 'ASR_VALUE_FREEZE_VERSION_START_DATE',@ParamValue,@debug


--EXEC [dbo].[usp_etl_parameter_update] 'ASR_SALE_STUDY_END_DATE','20210630000',@debug
--EXEC [dbo].[usp_etl_parameter_update] 'ASR_SALE_STUDY_START_DATE','20200101000',@debug
