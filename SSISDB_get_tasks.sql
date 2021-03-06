/*
-- ================================================================================================
SSISDB_get_tasks.sql

Purpose:
    returns all tasks executed that are associated with a given execution
    *** update variable

History:
   
-- ================================================================================================
*/
USE ssisdb;
SET NOCOUNT ON;


-- declare variables
DECLARE @execution_id INT;


-- ------------------------------------------------------------------------------------------------
-- *** update variable with execution ID you want to see messages for
-- ------------------------------------------------------------------------------------------------
SET @execution_id = 0;


-- return results
WITH cte_tasks
AS
(
SELECT      es.execution_path
,           e.executable_name                       AS task_name
,           replace(e.package_name, '.dtsx', '')    AS package_name
,           es.start_time
,           isnull(es.end_time, sysutcdatetime())   AS end_time
,           es.execution_duration                   AS execution_duration_ms
,           CASE
                WHEN es.execution_result = 0 
                    THEN 'Success' 
                WHEN es.execution_result = 1 
                    THEN 'Failure' 
                WHEN es.execution_result = 2 
                    THEN 'Completion' 
                WHEN es.execution_result = 3 
                    THEN 'Cancelled' 
            END     AS execution_result
,           substring(es.execution_path, 1, len(es.execution_path) - charindex('\', reverse(es.execution_path), 1)) AS parent_execution_path
FROM        [catalog].executables               AS e 
JOIN        [catalog].executable_statistics     AS es   ON  e.executable_id = es.executable_id
                                                        AND e.execution_id = es.execution_id
WHERE       e.execution_id = @execution_id
)
SELECT      execution_path
,           start_time
,           end_time
,           execution_duration_ms
,           execution_result
FROM        cte_tasks
            -- -------------------------------------------------------------------------------------------------
            --  put in whatever WHERE predicates you might like
            -- -------------------------------------------------------------------------------------------------
--WHERE       e.executable_name = 'Extract_dim_dealer_from_NetSuite'
ORDER BY    parent_execution_path
,           start_time DESC
;


