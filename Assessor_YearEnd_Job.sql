-- Run on xxDCETL-MST01
USE [msdb]
/*
	FILEPATH: /c:/Users/ktotten/source/repos/Copilot/CopilotVSCode/Assessor_YearEnd_Job.sql
	Description: This script is used for the Assessor Year-End job.
*/
GO

/****** Object:  Job [Assessor_YearEnd]    Script Date: 12/21/2023 3:40:47 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 12/21/2023 3:40:47 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Assessor_YearEnd', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Year end parameters for Realware ETLs (ODS1 and ODS2 versions)', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'DCGOV\ktotten', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Begin]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Begin', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- empty step', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_Before_2_ODS2_Web ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_Before_2_ODS2_Web ETL Parameters', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd2ParmLog.ps1 0', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution_2_ODS2_Web ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution_2_ODS2_Web ETL Parameters', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd2Execution.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_After_2_ODS2_Web ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_After_2_ODS2_Web ETL Parameters', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd2ParmLog.ps1 1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_Before_3_ODS2 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_Before_3_ODS2 ETL Parameters', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd3ParmLog.ps1 0', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution_3_ODS2 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution_3_ODS2 ETL Parameters', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd3Execution.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_After_3_ODS2 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_After_3_ODS2 ETL Parameters', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd3ParmLog.ps1 1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_Before_4a_ODS1 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_Before_4a_ODS1 ETL Parameters', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd4aParmLog.ps1 0', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution 4a ODS1 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution 4a ODS1 ETL Parameters', 
		@step_id=9, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd4aExecution.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_After_4a_ODS1 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_After_4a_ODS1 ETL Parameters', 
		@step_id=10, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd4aParmLog.ps1 1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_Before_4b_ODS1 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_Before_4b_ODS1 ETL Parameters', 
		@step_id=11, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd4bParmLog.ps1 0', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution 4b ODS1 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution 4b ODS1 ETL Parameters', 
		@step_id=12, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd4bExecution.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmLog_After_4b_ODS1 ETL Parameters]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmLog_After_4b_ODS1 ETL Parameters', 
		@step_id=13, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd4bParmLog.ps1 1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution_5_ODS2 ETL JsonFiles]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution_5_ODS2 ETL JsonFiles', 
		@step_id=14, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd5.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution_6_ODS2 ETL DatabaseBak]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution_6_ODS2 ETL DatabaseBak', 
		@step_id=15, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd6Execution.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution_8_ODS2 ETL MetaJsonBackup]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution_8_ODS2 ETL MetaJsonBackup', 
		@step_id=16, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd8.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [ParmExecution_9_ODS2 ETL MetaJsonYears]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'ParmExecution_9_ODS2 ETL MetaJsonYears', 
		@step_id=17, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"C:\Program Files\PowerShell\7\pwsh.exe" -File E:\scripts\AssessorYearEnd\AssessorYearEnd9.ps1', 
		@flags=0, 
		@proxy_name=N'Proxy_SA_DV_ASSRETL'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [End]    Script Date: 12/21/2023 3:40:48 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'End', 
		@step_id=18, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'-- Empty step', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Assessor End of Year - Runs Annually', 
		@enabled=1, 
		@freq_type=32, 
		@freq_interval=8, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=1, 
		@freq_recurrence_factor=12, 
		@active_start_date=20231221, 
		@active_end_date=99991231, 
		@active_start_time=120000, 
		@active_end_time=235959, 
		@schedule_uid=N'9ade276b-fd40-46b0-82e3-86803695c0be'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO