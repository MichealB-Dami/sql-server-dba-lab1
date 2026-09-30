/*
===============================================================================
Script Name : 09_Index_Fragmentation.sql
Author      : Bamidele Akinola
Purpose     : Check index fragmentation in the DBA_Lab database
===============================================================================
*/

USE DBA_Lab;
GO


/* Check index fragmentation */

SELECT
    OBJECT_SCHEMA_NAME(ips.object_id) AS SchemaName,
    OBJECT_NAME(ips.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    ips.page_count AS PageCount,
    CAST(
        ips.avg_fragmentation_in_percent
        AS DECIMAL(10,2)
    ) AS FragmentationPercent,

    CASE
        WHEN ips.avg_fragmentation_in_percent >= 30
            THEN 'REBUILD'

        WHEN ips.avg_fragmentation_in_percent >= 10
             AND ips.avg_fragmentation_in_percent < 30
            THEN 'REORGANIZE'

        ELSE 'NO ACTION'
    END AS RecommendedAction

FROM sys.dm_db_index_physical_stats
(
    DB_ID(N'DBA_Lab'),
    NULL,
    NULL,
    NULL,
    'LIMITED'
) AS ips

INNER JOIN sys.indexes AS i
    ON ips.object_id = i.object_id
    AND ips.index_id = i.index_id

WHERE
    ips.index_id > 0
    AND ips.page_count >= 1000

ORDER BY
    ips.avg_fragmentation_in_percent DESC;
GO


/* Display all indexes in DBA_Lab */

SELECT
    OBJECT_SCHEMA_NAME(i.object_id) AS SchemaName,
    OBJECT_NAME(i.object_id) AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType,
    i.is_unique AS IsUnique,
    i.is_primary_key AS IsPrimaryKey
FROM sys.indexes AS i
WHERE
    i.object_id > 100
    AND i.name IS NOT NULL
ORDER BY
    TableName,
    IndexName;
GO
