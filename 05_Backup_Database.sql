/*
===============================================================================
Script Name : 05_Backup_Database.sql
Author      : Bamidele Akinola
Purpose     : Perform and verify a full backup of the DBA_Lab database
===============================================================================
*/

USE master;
GO


/* Perform full database backup */

BACKUP DATABASE DBA_Lab
TO DISK =
N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\DBA_Lab_FULL.bak'
WITH
    INIT,
    COMPRESSION,
    CHECKSUM,
    STATS = 10;
GO


/* Verify that the backup file is readable */

RESTORE VERIFYONLY
FROM DISK =
N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\DBA_Lab_FULL.bak'
WITH CHECKSUM;
GO


/* Display backup history */

SELECT TOP 10
    bs.database_name AS DatabaseName,
    bs.backup_start_date AS BackupStartDate,
    bs.backup_finish_date AS BackupFinishDate,

    CASE bs.type
        WHEN 'D' THEN 'Full Database Backup'
        WHEN 'I' THEN 'Differential Backup'
        WHEN 'L' THEN 'Transaction Log Backup'
        ELSE bs.type
    END AS BackupType,

    CAST
    (
        bs.backup_size / 1024.0 / 1024.0
        AS DECIMAL(12,2)
    ) AS BackupSizeMB,

    bmf.physical_device_name AS BackupLocation

FROM msdb.dbo.backupset AS bs

INNER JOIN msdb.dbo.backupmediafamily AS bmf
    ON bs.media_set_id = bmf.media_set_id

WHERE bs.database_name = N'DBA_Lab'

ORDER BY bs.backup_finish_date DESC;
GO
