-- Run on xxDCETL-SQL01
USE [SSISLOGGING]
GO

CREATE TABLE [dbo].[EndOfYear_Parameters](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[ModifiedTS] [datetime] NOT NULL,
	[ParameterName] [varchar](50) NULL,
	[ParameterValue] [varchar](50) NULL,
	[After] [bit] NOT NULL,
	[Source] [varchar](100) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EndOfYear_Parameters] ADD  DEFAULT (getdate()) FOR [ModifiedTS]
GO