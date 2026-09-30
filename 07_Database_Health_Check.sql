/*
===============================================================================
Script Name : 07_Database_Health_Check.sql
Author      : Bamidele Akinola
Purpose     : Review the health and configuration of the DBA_Lab database
===============================================================================
*/

USE master;
GO


/* Database status and configuration */

SELECT
    name AS DatabaseName,
    database_id,
    create_date,
    state_desc AS DatabaseStatus,
    recovery_model_desc AS RecoveryModel,
    compatibility_level AS CompatibilityLevel,
    user_access_desc AS UserAccess,
    is_read_only AS IsReadOnly,
    is_auto_close_on AS AutoCloseEnabled,
    is_auto_shrink_on AS AutoShrinkEnabled
FROM sys.databases
WHERE name = N'DBA_Lab';
GO


/* Database file information */

SELECT
    DB_NAME(database_id) AS DatabaseName,
    name AS LogicalFileName,
    physical_name AS PhysicalFileName,
    type_desc AS FileType,

    CAST(size * 8.0 / 1024 AS DECIMAL(12,2)) AS FileSizeMB,

    CASE
        WHEN is_percent_growth = 1
            THEN CAST(growth AS VARCHAR(20)) + '%'
        ELSE
            CAST(growth * 8 / 1024 AS VARCHAR(20)) + ' MB'
    END AS FileGrowth

FROM sys.master_files
WHERE database_id = DB_ID(N'DBA_Lab');
GO


/* Database space usage */

USE DBA_Lab;
GO

SELECT
    DB_NAME() AS DatabaseName,

    CAST(
        SUM(size) * 8.0 / 1024
        AS DECIMAL(12,2)
    ) AS TotalDatabaseSizeMB

FROM sys.database_files;
GO


/* Table sizes */

SELECT
    t.name AS TableName,
    SUM(p.rows) AS RowCount,

    CAST(
        SUM(a.total_pages) * 8.0 / 1024
        AS DECIMAL(12,2)
    ) AS TotalSpaceMB,

    CAST(
        SUM(a.used_pages) * 8.0 / 1024
        AS DECIMAL(12,2)
    ) AS UsedSpaceMB

FROM sys.tables AS t

INNER JOIN sys.indexes AS i
    ON t.object_id = i.object_id

INNER JOIN sys.partitions AS p
    ON i.object_id = p.object_id
    AND i.index_id = p.index_id

INNER JOIN sys.allocation_units AS a
    ON p.partition_id = a.container_id

WHERE i.index_id IN (0,1)

GROUP BY
    t.name

ORDER BY
    TotalSpaceMB DESC;
GO


/* Check database integrity */

DBCC CHECKDB (N'DBA_Lab')
WITH NO_INFOMSGS;
GO
