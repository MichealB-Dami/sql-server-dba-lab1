/*
===============================================================================
Script Name : 08_Blocking_Sessions.sql
Author      : Bamidele Akinola
Purpose     : Identify blocking and blocked sessions in SQL Server
===============================================================================
*/

USE DBA_Lab;
GO


/* Display currently blocked sessions */

SELECT
    r.session_id AS BlockedSessionID,
    r.blocking_session_id AS BlockingSessionID,
    DB_NAME(r.database_id) AS DatabaseName,
    s.login_name AS LoginName,
    s.host_name AS HostName,
    s.program_name AS ProgramName,
    r.status AS RequestStatus,
    r.command AS Command,
    r.wait_type AS WaitType,
    r.wait_time AS WaitTimeMS,
    r.wait_resource AS WaitResource,
    r.cpu_time AS CPUTimeMS,
    r.total_elapsed_time AS ElapsedTimeMS,
    txt.text AS RunningSQL
FROM sys.dm_exec_requests AS r
INNER JOIN sys.dm_exec_sessions AS s
    ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS txt
WHERE r.blocking_session_id <> 0
ORDER BY
    r.total_elapsed_time DESC;
GO


/* Display sessions that are currently blocking other sessions */

SELECT DISTINCT
    s.session_id AS BlockingSessionID,
    s.login_name AS LoginName,
    s.host_name AS HostName,
    s.program_name AS ProgramName,
    s.status AS SessionStatus,
    s.open_transaction_count AS OpenTransactions,
    txt.text AS LastSQLStatement
FROM sys.dm_exec_sessions AS s
INNER JOIN sys.dm_exec_connections AS c
    ON s.session_id = c.session_id
CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS txt
WHERE s.session_id IN
(
    SELECT DISTINCT blocking_session_id
    FROM sys.dm_exec_requests
    WHERE blocking_session_id <> 0
)
ORDER BY
    s.session_id;
GO


/* Display open transactions */

DBCC OPENTRAN (N'DBA_Lab');
GO
