-- Step 6
-- Server: XXRealWare-sql
-- DB: PRRW (PR)
-- DB: PRRW_UPGRADE (UA) NOTE: there is no equivalant storeage locations in UA as PR
-- Needed Credentials: T1



DECLARE @FileName varchar(100),
@databasename nvarchar(250) = N'prrw',
@environment nvarchar(2) = N'DV',
@backuppath nvarchar(250) = '',
@backupname nvarchar(50) = ''

SELECT @environment=left(host_name(),2)
SELECT @databasename = CASE @environment when 'DV' then 'PRRW_TEST' when 'UA' then 'PRRW_UPGRADE' else 'PRRW' end
SELECT @backuppath = CASE @environment when 'PR' then '\\prfsdept\common\assor\v5db\' else 'E:\backups' end
SELECT @backupname = @databasename + '-Full Database Backup'

SET @FileName = (SELECT @backuppath + '\' + @databasename + '_' + convert(varchar(30), getdate(),112) + replace(convert(varchar(30), getdate(),108),':','')+'.bak') 
BACKUP DATABASE @databasename -- PR
TO  DISK = @FileName
WITH  COPY_ONLY, NOFORMAT, NOINIT,  NAME = @backupname, SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10

GO