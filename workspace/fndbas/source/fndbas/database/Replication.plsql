-----------------------------------------------------------------------------
--
--  Logical unit: Replication
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020701  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030902  ROOD  Added check for appowner when using dbms_job (ToDo#4196).
--  050615  HAAR  Changed Init_All_Processes__ to use System privileges (F1PR483).
--  061027  NiWiLK Cleanup is moved to F1 light cleanup process(Bug#61210).
--  061227  HAAR  Init_All_Processes_ uses Batch_SYS.New_Job_App_Owner__ (Bug#62360)
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Init_All_Processes__ (
   dummy_ IN NUMBER )
IS
   default_time_ NUMBER;
   time_         NUMBER;
   job_key_      NUMBER;
   process_      VARCHAR2(30);
   interval_     VARCHAR2(100);
BEGIN
   General_SYS.Check_Security(service_, 'REPLICATION_SYS', 'Init_All_Processes__');
   -- Check for system privilege
   Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User);
   --
   --  Remove all old processing
   --
   Batch_SYS.Remove_Job_On_Method_('REPLICATION_SYS.PROCESS');
   --
   -- Set default interval in seconds
   --
   BEGIN
      default_time_ :=
        Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('DEFJOB_INTERVAL'));
      IF (default_time_ < 5 OR default_time_ > 120 OR default_time_ IS NULL) THEN
         default_time_ := 30;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         default_time_ := 30;
   END;
   --
   --  Check if replication process should be started
   --
   BEGIN
      process_ := NVL(Fnd_Setting_API.Get_Value('REPLICATE'),'OFF');
   EXCEPTION
      WHEN OTHERS THEN
         process_ := 'OFF';
   END;
   IF (process_ = 'ON') THEN
      --
      -- Set interval in seconds
      --
      BEGIN
         time_ :=
          Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('REPL_INTERVAL'));
         IF (time_ < 5 OR time_ > 120 OR time_ IS NULL) THEN
            time_ := default_time_;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            time_ := default_time_;
      END;
      interval_ := 'sysdate + '||to_char(time_)||'/86400';
      --
      -- Start new processes for replication service
      --
      Batch_SYS.New_Job_App_Owner__(job_key_, 'Replication_SYS.Process_Replicate__(0)', interval_);
   END IF;
END Init_All_Processes__;


PROCEDURE Process_Replicate__ (
   dummy_ IN NUMBER )
IS
   full_method_name_  VARCHAR2(2000) := 'Replication_Util_API.Replicate__';
   rowid_             VARCHAR2(100);
   posted_jobs_       NUMBER;
   processes_         NUMBER;
   queue_id_          NUMBER;
   n_                 NUMBER;
   CURSOR c1 IS
      SELECT rowid
      FROM   replication_queue_tab
      WHERE  rowstate = 'Posted'
      ORDER BY seq_no;
   CURSOR posted_jobs IS
      SELECT count(*)
      FROM   transaction_sys_local_tab
      WHERE  state = 'Posted'
      AND    procedure_name = full_method_name_;
   CURSOR processes IS
      SELECT process_number
      FROM   batch_queue
      WHERE  queue_id = queue_id_;
BEGIN
   General_SYS.Check_Security(service_, 'REPLICATION_SYS', 'Process_Replicate__');
   queue_id_ := Batch_Queue_Method_API.Get_Default_Queue(full_method_name_, Language_SYS.Get_Language);
   FOR c1_rec IN c1 LOOP
      OPEN posted_jobs;
      FETCH posted_jobs INTO posted_jobs_;
      IF ( posted_jobs%NOTFOUND ) THEN
         posted_jobs_ := 0;
      END IF;
      CLOSE posted_jobs;
      IF ( posted_jobs_ > 0 ) THEN
         OPEN processes;
         FETCH processes INTO processes_;
         IF ( processes%NOTFOUND ) THEN
            processes_ := 3 * posted_jobs_ - 1;
         END IF;
         CLOSE processes;
         IF ( posted_jobs_ > 3 * processes_ ) THEN
            RETURN;
         END IF;
      END IF;
      rowid_ := c1_rec.rowid;
      BEGIN
         SELECT 1
         INTO   n_
         FROM   replication_queue_tab
         WHERE  rowstate = 'Posted'
         AND    rowid = c1_rec.rowid
         FOR UPDATE NOWAIT;
      EXCEPTION
         WHEN OTHERS THEN
            GOTO end_loop;                   -- Skip job if already removed or locked...
      END;
      -- If records has not already been processed
      -- change state and publish new state
      --
      UPDATE replication_queue_tab
      SET    rowstate   = 'Processing',
             rowversion = sysdate
      WHERE  rowid = c1_rec.rowid;
      --
      -- Commit to publish new status
      --
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT;
      --
      -- Create background process entry in Transaction_SYS
      --
      IF (full_method_name_ IS NOT NULL) THEN
         Transaction_SYS.Deferred_Call(full_method_name_, rowid_);
         --
         -- Update status for initiated messages
         --
         UPDATE replication_queue_tab
            SET   rowstate   = 'Transferred',
                  rowversion = sysdate
            WHERE rowid = c1_rec.rowid;
      ELSE
         --
         -- Update status for unhandled messages
         --
         UPDATE replication_queue_tab
            SET   rowstate   = 'Incomplete',
                  rowversion = sysdate
            WHERE rowid = c1_rec.rowid;
      END IF;
      --
      -- Commit each message separately
      --
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT;
      <<end_loop>>
      NULL;
   END LOOP;
@ApproveTransactionStatement(2014-04-02,mabose)
   COMMIT;
EXCEPTION
   WHEN OTHERS THEN
@ApproveTransactionStatement(2014-04-02,mabose)
      ROLLBACK;
      NULL; -- Severe problems
END Process_Replicate__;


PROCEDURE Cleanup__
IS
BEGIN
   General_SYS.Check_Security(service_, 'REPLICATION_SYS', 'Cleanup__');
   Replication_Util_API.Cleanup__;
END Cleanup__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


