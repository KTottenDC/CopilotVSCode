-- Step 3
-- Server: PRDCETL-MST01
-- DB: SSISDB
-- Needed Credentials: T1

USE [SSISDB]
GO


DECLARE @CurrentYear int, @AssessorYear nvarchar(50)
IF (MONTH(GETDATE()) = 12)
    SET @CurrentYear = YEAR(GETDATE())
ELSE
	SET @CurrentYear = YEAR(GETDATE()) - 1

SET @AssessorYear = @CurrentYear + 1
-- Log @CurrentYear, @NewYear, @ParamValue

/* Reset
	SET @AssessorYear = cast(@CurrentYear as nvarchar(50))
*/

-- Log before and After Update
-- Environment Variable update
EXEC ssisdb.catalog.set_environment_variable_value @folder_name = 'assessor_ods2'  
    , @environment_name = 'assessor_ods2' 
    , @variable_name = 'AssessorDetailYears'  
    , @value = @AssessorYear 

EXEC ssisdb.catalog.set_environment_variable_value @folder_name = 'assessor_ods2'  
    , @environment_name = 'assessor_ods2' 
    , @variable_name = 'AssessorNOVYears'  
    , @value = @AssessorYear 
