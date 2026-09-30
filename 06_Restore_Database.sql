/*
===============================================================================
Script Name : 06_Restore_Database.sql
Author      : Bamidele Akinola
Purpose     : Restore the DBA_Lab database from a full backup
===============================================================================
*/

USE master;
GO


/* Check the backup file */

RESTORE FILELISTONLY
FROM DISK =
N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\DBA_Lab_FULL.bak';
GO


/* Remove previous restore-test database if it already exists */

IF DB_ID(N'DBA_Lab_Restore_Test') IS NOT NULL
BEGIN
    ALTER DATABASE DBA_Lab_Restore_Test
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;

    DROP DATABASE DBA_Lab_Restore_Test;
END;
GO


/* Restore database */

RESTORE DATABASE DBA_Lab_Restore_Test
FROM DISK =
N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\DBA_Lab_FULL.bak'

WITH
    MOVE N'DBA_Lab_Data'
        TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DBA_Lab_Restore_Test.mdf',

    MOVE N'DBA_Lab_Log'
        TO N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DBA_Lab_Restore_Test_log.ldf',

    RECOVERY,
    STATS = 10;
GO


/* Verify restored database */

SELECT
    name AS DatabaseName,
    database_id,
    create_date,
    state_desc AS DatabaseStatus,
    recovery_model_desc AS RecoveryModel
FROM sys.databases
WHERE name = N'DBA_Lab_Restore_Test';
GO
