/*
-- ================================================================================================
SSISDB_get_event_messages.sql

Purpose:
    returns all messages associated with a given execution
    *** update variable

History:
    2015-02-27  Tom Hogan       created, based on work done by Jamie Thomson
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
WITH cte_events
AS
(
SELECT      em.event_message_id
,           em.message_time
,           em.[message]
,           replace(em.package_name, '.dtsx', '')   AS package_name
,           em.event_name
,           em.message_source_name
,           em.package_path
,           em.execution_path
--,           cast
--            (   (
--                SELECT      context.property_name
--                ,           context.property_value
--                ,           context.context_depth
--                ,           context.package_path
            --    ,           CASE
            --                    WHEN context.context_type = 10		
            --                        THEN 'Task'
            --                    WHEN context.context_type = 20
            --                        THEN 'Pipeline'
            --                    WHEN context.context_type = 30
            --                        THEN 'Sequence'
            --                    WHEN context.context_type = 40
            --                        THEN 'For Loop'
            --                    WHEN context.context_type = 50
            --                        THEN 'Foreach Loop'
            --                    WHEN context.context_type = 60
            --                        THEN 'Package'
            --                    WHEN context.context_type = 70
            --                        THEN 'Variable'
            --                    WHEN context.context_type = 80
            --                        THEN 'Connection manager'
            --                    ELSE NULL
            --                END     AS context_type_desc
            --    ,           context.context_source_name
            --    FROM        [catalog].event_message_context     AS context
            --    WHERE       em.event_message_id = context.event_message_id
            --    FOR XML AUTO
            --    )   AS XML
            --)   AS message_context
FROM        [catalog].event_messages    AS em
WHERE       em.operation_id = @execution_id
AND         em.event_name NOT LIKE '%Validate%'
)
SELECT      *
FROM        cte_events
            -- -------------------------------------------------------------------------------------------------
            --  put in whatever WHERE predicates you might like
            -- -------------------------------------------------------------------------------------------------
--WHERE       event_name IN ('OnError', 'OnTaskFailed')
--WHERE       event_name IN ('OnPostExecute', 'OnPreExecute')
--WHERE       package_name = 'Package'
--WHERE       execution_path LIKE '%<some executable>%'
ORDER BY    message_time DESC
,           event_message_id DESC
;
