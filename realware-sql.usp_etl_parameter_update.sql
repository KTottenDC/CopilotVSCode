USE [DVRWODSETL]
GO


IF EXISTS (SELECT 1 FROM sys.objects WHERE name = 'usp_etl_parameter_update' and type = 'P')
DROP PROCEDURE [dbo].[usp_etl_parameter_update]
GO

CREATE proc [dbo].[usp_etl_parameter_update]
(
	@PARAMETER_NAME		varchar(50),
	@PARAMETER_VALUE	varchar(100),
	@DEBUG				bit = 0 -- 0=False anything else is true
)
AS
BEGIN
/**************************************************************************************************
Description:	Updates the ETL Paramter table based on the passed in parameters
Usage:			exec dbo.usp_etl_parameter_update 'ASSESSMENT_TAX_YEAR', '2021', -1
--------------------------------------------------------------------------------------------------
Date:		Name:		Comments:
20210526	MBeacom		Initial Creation
20211223    	RGreenfield 	Added conditioning for debug and only update if the value has changed

NOTES: SP is same in UARealWare-SQL    	  
**************************************************************************************************/
	SET nocount ON;

	DECLARE @CurrentValue varchar(100)

	-- values before the change
	SELECT @CurrentValue = [PARAMETER_VALUE] FROM ODS_EXTRACT_ASR.ETL_PARAMETER WHERE PARAMETER_NAME = @PARAMETER_NAME
	
	IF (@DEBUG = 0)
	BEGIN
		IF (@CurrentValue <> @PARAMETER_VALUE)
		BEGIN
			UPDATE	ODS_EXTRACT_ASR.ETL_PARAMETER
			SET		PARAMETER_VALUE	=	@PARAMETER_VALUE,
					UPDATE_USER_ID	=	SUSER_NAME(),
					UPDATE_DTM		=	CONVERT(varchar(22), GETDATE(), 121) 
			WHERE	PARAMETER_NAME	=	@PARAMETER_NAME
			AND		PARAMETER_VALUE	<>	@PARAMETER_VALUE

			-- values after the change
			SELECT * FROM ODS_EXTRACT_ASR.ETL_PARAMETER WHERE PARAMETER_NAME = @PARAMETER_NAME
		END
	END
	ELSE
	BEGIN
		-- DEBUG
		IF (@CurrentValue <> @PARAMETER_VALUE)
		BEGIN
			SELECT 'DEBUG  Parm Name: ', PARAMETER_NAME, PARAMETER_VALUE [OriginalValue], @PARAMETER_VALUE [NewValue] FROM ODS_EXTRACT_ASR.ETL_PARAMETER WHERE PARAMETER_NAME = @PARAMETER_NAME
		END
		ELSE
			SELECT CONCAT('DEBUG  Parm Name: ', @PARAMETER_NAME, '  Parm Value: ', @PARAMETER_VALUE, '  (No Change)')
	END
END