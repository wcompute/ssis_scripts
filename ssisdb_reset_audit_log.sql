/*
-- ================================================================================================
ssisdb_reset_audit_log.sql

Purpose:
    removes all audit log data and resets to initial date of 2008-01-01

History:
    
-- ================================================================================================
*/
USE ssisdb;
SET NOCOUNT ON;


-- clear tables
DELETE
FROM    dbo.etl_audit_execution_map
;

DELETE
FROM    dbo.etl_audit_log
;
GO


-- reset idenity field
DBCC CHECKIDENT (etl_audit_log, RESEED, 0);
GO


-- load initial value
INSERT INTO dbo.etl_audit_log (
            etl_start_datetime
,           business_date
,           invoice_date
            )
SELECT      getdate()
,           '20080101'
,           '20080101'
;


-- return results to validate table has been reset
SELECT  *
FROM    dbo.etl_audit_log
;

