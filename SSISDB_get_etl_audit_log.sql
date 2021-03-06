/*
-- ================================================================================================
SSISDB_get_etl_audit_log.sql

Purpose:
    returns all ETL audit logs

History:
  
-- ================================================================================================
*/
USE ssisdb;
SET NOCOUNT ON;


SELECT      etl_audit_id
,           etl_start_datetime
,           etl_end_datetime
,           business_date
,           invoice_date
FROM        dbo.etl_audit_log
ORDER BY    business_date DESC
;
