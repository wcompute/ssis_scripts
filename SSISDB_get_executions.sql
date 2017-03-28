/*
-- ================================================================================================
SSISDB_get_executions.sql

Purpose:
    returns all package executions run on given server

History:
   
-- ================================================================================================
*/
USE ssisdb;
SET NOCOUNT ON;


-- return results
WITH cte_executions
AS
(
SELECT      execution_id
,           folder_name
,           project_name
,           replace(package_name, '.dtsx', '')  AS package_name
,           CASE
                WHEN [status] = 1
                    THEN 'created'
                WHEN [status] = 2
                    THEN 'running'
                WHEN [status] = 3
                    THEN 'canceled'
                WHEN [status] = 4
                    THEN 'failed'
                WHEN [status] = 5
                    THEN 'pending'
                WHEN [status] = 6
                    THEN 'ended unexpectedly'
                WHEN [status] = 7
                    THEN 'succeeded'
               WHEN [status] = 8
                    THEN 'stopping'
               WHEN [status] = 9
                    THEN 'completed'
            END     AS execution_status
,           start_time
,           end_time
,           datediff(ss, start_time, end_time)  AS duration_in_sec
,           server_name
,           executed_as_name
,           use32bitruntime     AS used_32_bit_runtime
FROM        [catalog].executions
)
SELECT      *
FROM        cte_executions
            -- -------------------------------------------------------------------------------------------------
            --  put in whatever WHERE predicates you might like
            -- -------------------------------------------------------------------------------------------------
--WHERE       folder_name = 'LJ_data_warehouse'
--WHERE       project_name = 'ETL_MIT_Validation'
--WHERE       package_name = 'ETL_MIT_Load_ETL_For_JB.dtsx'
--WHERE       execution_status IN ('failed', 'ended unexpectedly')
ORDER BY    start_time DESC
;
