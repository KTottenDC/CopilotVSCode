-- Run on xxDCETL-SQL01
USE [SSISLOGGING]
GO

CREATE TABLE [dbo].[EndOfYear_Exception](
	[Caller] [varchar](200) NOT NULL,
	[ScriptName] [varchar](100) NOT NULL,
	[Exception] [varchar](1000) NULL,
	[ErrorTS] [datetime] NULL
) ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'JobName + StepName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EndOfYear_Exception', @level2type=N'COLUMN',@level2name=N'Caller'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'pwsh Name or SQL Statement Script' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EndOfYear_Exception', @level2type=N'COLUMN',@level2name=N'ScriptName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Script Error' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EndOfYear_Exception', @level2type=N'COLUMN',@level2name=N'Exception'
GO


