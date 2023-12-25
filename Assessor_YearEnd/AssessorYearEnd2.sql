-- Set to SQLCMD Mode (Step 2 - Update ETL parameter data (ODS2) for the new year) - Mark
-- Needed Credentials: T0

DECLARE @debug bit = 0 -- Default 0=False  Anything else is True

 --  Environments DV,UA,PR


-- ************ ODS1 ************
--DV
--:CONNECT DVRW2-SQL01

--UA
--:CONNECT UARW2-SQL01

--PR
--:CONNECT PRRW2-SQL01

-- Database Name is same for all Environments
-- USE [assessor_extract]

DECLARE @ParamValue varchar(100), @FreezeFlag varchar(100) = 'Y', @CurrentYear int, @NewYear int, @EndTime varchar(100) = '1231999'
 
IF (MONTH(GETDATE()) = 12)
    SET @CurrentYear = YEAR(GETDATE())
ELSE
	SET @CurrentYear = YEAR(GETDATE()) - 1

SET @NewYear = @CurrentYear + 1
SET @ParamValue = (cast(@CurrentYear as varchar(4)) + @EndTime)
-- Log @CurrentYear, @NewYear, @ParamValue

/* RESET
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_FLAG','Y',@debug
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_TAX_YEAR','2021',@debug
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_VERSION_END_DATE','20211231999',@debug
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_VERSION_START_DATE','20211231999',@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_FLAG','Y',@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_TAX_YEAR','2021',@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_VERSION_END_DATE','20211231999',@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_VERSION_START_DATE','20211231999',@debug
EXEC [dbo].[usp_webetl_update] 'ASSESSMENT_TAX_YEAR','2022',@debug

--EXEC [dbo].[usp_webetl_update] 'ASR_SALE_STUDY_END_DATE','20210630000',@debut– Is this still needed? 
--EXEC [dbo].[usp_webetl_update] 'ASR_SALE_STUDY_START_DATE','20200101000',@debut– Is this still needed? 
*/

-- Log before and After Update
-- Parameter Value Update
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_FLAG',@FreezeFlag,@debug
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_TAX_YEAR',@CurrentYear,@debug
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_VERSION_END_DATE',@ParamValue,@debug
EXEC [dbo].[usp_webetl_update] 'ASR_PERS_VALUE_FREEZE_VERSION_START_DATE',@ParamValue,@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_FLAG',@FreezeFlag,@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_TAX_YEAR',@CurrentYear,@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_VERSION_END_DATE',@ParamValue,@debug
EXEC [dbo].[usp_webetl_update] 'ASR_VALUE_FREEZE_VERSION_START_DATE',@ParamValue,@debug
EXEC [dbo].[usp_webetl_update] 'ASSESSMENT_TAX_YEAR',@NewYear,@debug

--EXEC [dbo].[usp_webetl_update] 'ASR_SALE_STUDY_END_DATE','20210630000',@debut– Is this still needed? 
--EXEC [dbo].[usp_webetl_update] 'ASR_SALE_STUDY_START_DATE','20200101000',@debut– Is this still needed? 