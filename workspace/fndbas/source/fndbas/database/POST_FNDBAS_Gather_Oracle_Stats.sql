---------------------------------------------------------------------------------------------------
--  Filename      : POST_FNDBAS_Gather_Oracle_Stats.sql
-- 
--  Module        : FNDBAS 
--
--  Purpose       : Initial gathering of Oracle statistics used by the cost based optimizer
-- 
--  Date      Sign      History
--  ------   ------    ----------------------------------------------------------------------------
--  181109   Mabose    Created
---------------------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_Gather_Oracle_Stats.sql','Timestamp_1');
PROMPT Starting POST_FNDBAS_Gather_Oracle_Stats.sql


DECLARE
   job_name_ VARCHAR2(30) := 'Gather_Initial_Statistics';
BEGIN
   BEGIN
      DBMS_Scheduler.Drop_Job(job_name_, TRUE);
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
   DBMS_Scheduler.Create_Job (
                     job_name           =>  job_name_,
                     job_type           => 'STORED_PROCEDURE',
                     job_action         => 'INSTALL_TEM_SYS.GATHER_INITIAL_STATISTICS',
                     auto_drop          =>  TRUE,
                     comments           => 'Gather Initial Oracle Statistics');
   DBMS_Scheduler.Set_Attribute(
                     name               =>  job_name_,
                     attribute          => 'job_priority',
                     value              =>  2);
   DBMS_Scheduler.Enable(job_name_);
   COMMIT;
END;
/

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_Gather_Oracle_Stats.sql','Done');
PROMPT Finished with POST_FNDBAS_Gather_Oracle_Stats.sql
