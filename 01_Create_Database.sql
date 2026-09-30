/*
===============================================================================
Script Name : 01_Create_Database.sql
Author      : Bamidele Akinola
Purpose     : Create a SQL Server database with dedicated data and log files
===============================================================================
*/

USE master;
GO

IF DB_ID(N'DBA_Lab') IS NULL
BEGIN
    CREATE DATABASE DBA_Lab
    ON PRIMARY
    (
        NAME = N'DBA_Lab_Data',
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DBA_Lab.mdf',
        SIZE = 102400KB,
        FILEGROWTH = 51200KB
    )
    LOG ON
    (
        NAME = N'DBA_Lab_Log',
        FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\DBA_Lab_log.ldf',
        SIZE = 51200KB,
        FILEGROWTH = 25600KB
    );
END
ELSE
BEGIN
    PRINT 'Database DBA_Lab already exists.';
END;
GO

/* Verify database creation */

SELECT
    name AS DatabaseName,
    database_id,
    create_date,
    state_desc AS DatabaseStatus,
    recovery_model_desc AS RecoveryModel
FROM sys.databases
WHERE name = N'DBA_Lab';
GO
