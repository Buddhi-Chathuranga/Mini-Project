-----------------------------------------------------------------------------
--  Module : FNDBAS
--
--  File   : POST_FNDBAS_UpdatePrintJobsStatus.sql
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  181002   CHAALK  Bug 144454, Handling of unprocessed print jobs during upgrade
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------
SET SERVEROUTPUT ON
   
EXEC Database_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_UpdatePrintJobsStatus.sql','Timestamp_1');
PROMPT Updating print jobs with status WAITING, WORKING, REMOTE_WAITING, REMOTE_WORKING to ERROR state
DECLARE

CURSOR get_print_jobs IS
SELECT print_job_id FROM print_job_tab WHERE status = 'WAITING' OR status = 'WORKING' OR status =  'REMOTE WAITING' OR status = 'REMOTE WORKING';

CURSOR get_queue_jobs IS
SELECT print_job_id FROM print_queue_tab WHERE status = 'WAITING' OR status = 'WORKING' OR status =  'REMOTE WAITING' OR status = 'REMOTE WORKING';

BEGIN
   FOR rec_ IN get_print_jobs LOOP
      Print_Job_API.Set_Error(rec_.print_job_id,'Old Print Job.Set to ERROR state by upgrade script.');
   END LOOP;
   FOR rec_ IN get_queue_jobs LOOP
      Print_Job_API.Set_Error(rec_.print_job_id,'Old Print Job.Set to ERROR state by upgrade script.');
   END LOOP;
   COMMIT;
END;
/

PROMPT Finished with POST_FNDBAS_UpdatePrintJobsStatus.sql
EXEC Database_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_UpdatePrintJobsStatus.sql','Done');


