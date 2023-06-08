-----------------------------------------------------------------------------
--
--  Logical unit: DeferredJob
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960913  ERFO  Created for IFS Foundation 1.2.2 with a simple
--  961031  ERFO  Changed the view to include access logic (Idea #853).
--  961117  ERFO  Changed imlementation of OBJID and OBJVERSION.
--  961118  ERFO  Added methods to be used from the client (Idea #795).
--  961119  ERFO  Added database column for the state attribute.
--  961126  ERFO  Improved error handle for client use and Oracle 7.3.
--  961127  ERFO  Changed attribute names in view definition.
--  970414  ERFO  Generated from IFS/Design for release 2.0.0.
--  970725  TOWR  Added functionality in modify__ and Unpack_Check_Update___
--                changed according columns PROCEDURE_NAME and ARGUMENTS
--  970725  ERFO  Replaced usage of obsolete method Utility_SYS.Get_User
--                with the new Fnd_Session_API.Get_Fnd_User (ToDo #1172).
--  970729  ERFO  Changed call to method Transaction_SYS.Execute_Type1__.
--  971205  ERFO  Added new attributes queue_id and queue_name (ToDo #1712).
--  971208  ERFO  Corrections when updating jobs in state 'Error'.
--  971210  ERFO  Changes for update of batch queue for "posted" jobs.
--  971212  ERFO  Corrected handle of language in Execute_Job (Bug #1880).
--  980116  ERFO  Reorganization concerning new progress and status
--                info and added method Get_Queue_Id (ToDo #2009).
--  980129  ERFO  The attribute executed time is not set when manually
--                executing a background job (Bug #2068).
--  980301  ERFO  Minor corrections concerning manually started jobs.
--  980301  ERFO  Added call to Transaction_SYS.Update_Current_Job_Id__
--                to correct missing warning/progress info (Bug #2175).
--  980310  ERFO  Change attr_ when modifying background jobs (Bug #2218).
--  980319  ERFO  Correction in Update___ concerning 'STATE' (Bug #2218).
--  980325  ERFO  Reset FND_USER setting when job has been executed (Bug #2280).
--  980415  ERFO  Solve problem in Unpack_Check_Update when modifying the
--                parameter consisting of an attribute string (Bug #2217).
--  980728  ERFO  Review of English text by US (ToDo #2497).
--  981210  ERFO  Changed WHERE-clause of view definition (Bug #3008).
--  981214  ERFO  Added new attribute ProcessID (ToDo #3017).
--  990103  ERFO  Added new attribute LangIndep and changed translation
--                logic in method Execute_Job (ToDo #3017).
--  990104  ERFO  Solved performance problem in WHERE-clause (Bug #3008).
--  990324  ERFO  Changed view definition according to performance (Bug #3236).
--  990804  ERFO  Added column STARTED in several methods (ToDo #3480).
--  990920  ERFO  Rewrite of view definition for improved performance (ToDo #3580).
--  010824  ROOD  Added arguments_string in view. Updated template (Bug#14575).
--  010904  ROOD  Modified state behaviour in Execute_Job (ToDo#4038).
--  010918  ROOD  Added setting of state 'Executing' in Execute_Job (Bug#22112).
--  021219  HAAR  Added functionality for Argument_Type (ToDo#4146).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030931  HAAR  Removed obsolete method Language_SYS.Change_Language (ToDo#4305).
--  040408  HAAR   Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  070214  DUWILK Changed Execute_Job in order to get the current user of the application session (Bug#63420)
--  070426  UTGULK Corrected spelling mistake 'can not' (Bug#65011).
--  070509  HAAR   Added support for state Keep (Bug#65267).
--  080312  HAAR  Implement Fnd_Session properties as a context (Bug#68143).
--  080421  HAARSE Added support for removing state Executing without any process. (Bug#73208).
--  090121  HAAR  Try to avoid Impersonate User in method called from interactive client (Bug#79937).
--  090324  SJayLK Bug 79001, Added support for BA Rendering Server Jobs. (Bug#78505)
--  110722  UsRa  Modified Execute_Job to support RAC environments properly (Bug#94618).
--  110722  UsRa  Modified Execute_Job to locate INST_ID and SERIAL# in a better way (Bug#95489).
-----------------------------------------------------------------------------

layer Core;


@AllowTableOrViewAccess TRANSACTION_SYS_LOCAL_TAB
-------------------- PUBLIC DECLARATIONS ------------------------------------

execute_job_action_ CONSTANT VARCHAR2(25) := 'executeDeferredJob';

-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('EXCLUDE_CLEANUP_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('STREAM_MSG_ON_COMPLETION_DB', Fnd_Boolean_API.DB_FALSE,attr_);
END Prepare_Insert___;




@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT TRANSACTION_SYS_LOCAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   SELECT transaction_sys_seq.nextval
   INTO newrec_.id
   FROM dual;
   newrec_.posted := SYSDATE;
   newrec_.created := SYSDATE;
   
    -- Set STREAM_MSG_ON_COMPLETION to DB_FALSE if NULL
   IF newrec_.stream_msg_on_completion IS NULL THEN
      newrec_.stream_msg_on_completion := Fnd_Boolean_API.DB_FALSE;
      Client_SYS.Add_To_Attr ( 'STREAM_MSG_ON_COMPLETION_DB', newrec_.stream_msg_on_completion, attr_ );
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     TRANSACTION_SYS_LOCAL_TAB%ROWTYPE,
   newrec_     IN OUT TRANSACTION_SYS_LOCAL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   CURSOR get_rec IS
      SELECT 1
        FROM transaction_sys_local_tab t
       WHERE id = newrec_.id
         AND (EXISTS (SELECT 1 FROM user_scheduler_running_jobs j WHERE t.process_id = Batch_SYS.Get_Job_Id_(job_name)) OR
              EXISTS (SELECT 1 FROM v$session s WHERE t.sid = s.sid AND t.serial# = s.serial#));
BEGIN
    -- Set STREAM_MSG_ON_COMPLETION to DB_FALSE if NULL
   IF newrec_.stream_msg_on_completion IS NULL THEN
      newrec_.stream_msg_on_completion := Fnd_Boolean_API.DB_FALSE;
      Client_SYS.Add_To_Attr ( 'STREAM_MSG_ON_COMPLETION_DB', newrec_.stream_msg_on_completion, attr_ );
   END IF;
   IF (newrec_.state = 'Error') THEN
      newrec_.state := 'Posted';
      newrec_.error_text := NULL;
      Client_SYS.Add_To_Attr('STATE_DB', newrec_.state, attr_);
      Client_SYS.Add_To_Attr('STATE', Deferred_Job_State_API.Decode(newrec_.state), attr_);
      Client_SYS.Add_To_Attr('ERROR_TEXT', newrec_.error_text, attr_);
   END IF;
   IF oldrec_.state = 'Executing' THEN
      FOR rec IN get_rec LOOP
         Error_SYS.Appl_General(lu_name_, 'MODERR2: The job has status ":P1" and existing processes running it, therefore the job cannot be modified.',  Deferred_Job_State_API.Decode(oldrec_.state));
      END LOOP;
   ELSIF (oldrec_.state = 'Posted') THEN
      Error_SYS.Appl_General(lu_name_, 'MODERR1: The job has status ":P1" and cannot be modified.',  Deferred_Job_State_API.Decode(oldrec_.state));
   ELSIF (oldrec_.state <> 'Error' AND oldrec_.state <> 'Posted') THEN
      Error_SYS.Appl_General(lu_name_, 'MODERR1: The job has status ":P1" and cannot be modified.', Deferred_Job_State_API.Decode(oldrec_.state));
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN TRANSACTION_SYS_LOCAL_TAB%ROWTYPE )
IS
   CURSOR get_rec IS
      SELECT 1
        FROM transaction_sys_local_tab t
       WHERE id = remrec_.id
         AND ( EXISTS (SELECT 1 FROM user_scheduler_running_jobs j WHERE t.process_id = Batch_SYS.Get_Job_Id_(job_name)) OR
               EXISTS (SELECT 1 FROM v$session s WHERE t.sid = s.sid AND t.serial# = s.serial# ));
BEGIN
   IF remrec_.state = 'Executing' THEN
      FOR rec IN get_rec LOOP
         Error_SYS.Appl_General(lu_name_, 'DELERR: The job has status ":P1" and existing processes running it, therefore the job cannot be removed.',  Deferred_Job_State_API.Decode(remrec_.state));
      END LOOP;
   END IF;
   super(remrec_);
END Check_Delete___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Remove_Status_Messages___(
   job_id_ IN NUMBER)
IS
BEGIN
   DELETE
   FROM  transaction_sys_status_tab
   WHERE id = job_id_;
END Remove_Status_Messages___;

PROCEDURE Clear_Progress_Info___(
   job_id_ IN NUMBER)
IS
BEGIN
   UPDATE transaction_sys_local_tab 
   SET progress_info = NULL
   WHERE id = job_id_;
END Clear_Progress_Info___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-----------------------------------------------------------------------------
-- Set_Exclude_Cleanup__
--    Mark /Clear the EXCLUDE_CLEANUP flag on the given job
-----------------------------------------------------------------------------
PROCEDURE Set_Exclude_Cleanup__ (
   objid_           IN     VARCHAR2,
   objversion_      IN OUT VARCHAR2,
   attr_            IN OUT VARCHAR2,
   exclude_cleanup_ IN     VARCHAR2 )
IS
   oldrec_ TRANSACTION_SYS_LOCAL_TAB%ROWTYPE;
   newrec_ TRANSACTION_SYS_LOCAL_TAB%ROWTYPE;
BEGIN

   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;

   newrec_.exclude_cleanup := exclude_cleanup_;

   -- Note: Need to do a direct table update to bypass the restrictions in procedure Update___
   UPDATE TRANSACTION_SYS_LOCAL_TAB
      SET exclude_cleanup = newrec_.exclude_cleanup
    WHERE rowid = objid_;

   -- Return the modified attribute to client.
   Client_SYS.Add_To_Attr('EXCLUDE_CLEANUP_DB', newrec_.exclude_cleanup, attr_);
END Set_Exclude_Cleanup__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
FUNCTION Procedure_Already_Posted_ (
   procedure_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   result_     NUMBER:=0;
   CURSOR get_posted IS
      SELECT 1
        FROM transaction_sys_local_tab
       WHERE procedure_name = procedure_name_
         AND state = 'Posted';
BEGIN
   OPEN get_posted;
   FETCH get_posted INTO result_;
   CLOSE get_posted;
   
   RETURN (result_ = 1);
   
END Procedure_Already_Posted_;
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Job (
   job_id_ IN NUMBER )
IS
   remrec_     TRANSACTION_SYS_LOCAL_TAB%ROWTYPE;
   objid_      DEFERRED_JOB.objid%TYPE;
   objversion_ DEFERRED_JOB.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, job_id_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Job;


PROCEDURE Execute_Job (
   job_id_ IN NUMBER )
IS
   newrec_           TRANSACTION_SYS_LOCAL_TAB%ROWTYPE;
   oldrec_           TRANSACTION_SYS_LOCAL_TAB%ROWTYPE;
   objid_            DEFERRED_JOB.objid%TYPE;
   objversion_       DEFERRED_JOB.objversion%TYPE;
   error_            VARCHAR2(2000);
   attr_             VARCHAR2(2000);
   fnd_user_         VARCHAR2(30);
   new_state_        VARCHAR2(10);
   dummy_            NUMBER;
   report_id_        VARCHAR2(30);
   report_mode_      VARCHAR2(30);
   -- When Business Analytics Execution Server is used, the background job is continued in a nother machine asynchronously.
   is_bars_report_   BOOLEAN := FALSE;
   clob_holder_      VARCHAR2(32000);
   clob_length_      NUMBER;
   user_env_sid_     NUMBER;
   current_inst_id_  NUMBER;
   current_serial_   NUMBER;
   module_name_ gv$session.MODULE%TYPE;
   action_name_ gv$session.ACTION%TYPE;

   CURSOR find_warnings(job_id_ IN NUMBER) IS
      SELECT 1
      FROM transaction_sys_status_tab
      WHERE id = job_id_
      AND   status_type = 'WARNING';
BEGIN
   --
   -- Validate the job to be executed
   --
   oldrec_ := Lock_By_Keys___(job_id_);
   newrec_ := oldrec_;
   IF oldrec_.state NOT IN ('Posted', 'Error') THEN
      Error_SYS.Appl_General(lu_name_, 'EXEERR: The job :P1 cannot be executed.', to_char(job_id_));
   END IF;
   --
   IF (oldrec_.lang_indep = 'FALSE' AND oldrec_.lang_code != Fnd_Session_API.Get_Language) THEN
      Error_SYS.Appl_General(lu_name_, 'LANGERR: The job :P1 cannot be executed, because it uses language :P2. Please log on again with language :P2 set.', to_char(job_id_), oldrec_.lang_code);
   END IF;
   -- Execute the job and handle the transaction correctly
   --
   BEGIN
      --
      -- Run through the update process to reset the status to 'Posted' and validate if error
      --
      fnd_user_ := Fnd_Session_Api.Get_Fnd_User;
      IF (oldrec_.state = 'Error') THEN
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
         oldrec_ := Lock_By_Keys___(job_id_);
         IF oldrec_.state NOT IN ('Posted', 'Error') THEN
            Error_SYS.Appl_General(lu_name_, 'EXEERR: The job :P1 cannot be executed.', to_char(job_id_));
         END IF;
      END IF;
      --
      -- Set runtime properties for the job
      --
      IF (Transaction_SYS.Is_Session_Deferred) THEN
         Fnd_Session_API.Impersonate_Fnd_User(oldrec_.username);
      END IF;
      --
      -- Remove status messages from previous executions
      --
      Remove_Status_Messages___(job_id_);
      --
      -- Update the status and execute the job
      --
      Transaction_SYS.Update_Current_Job_Id__(job_id_);
      user_env_sid_    := userenv('SID');
      current_inst_id_ := sys_context('USERENV', 'INSTANCE');
      current_serial_  := dbms_debug_jdwp.current_session_serial;
      UPDATE TRANSACTION_SYS_LOCAL_TAB
         SET state      = 'Executing',
             process_id = NULL,
             started    = sysdate,
             inst_id    = current_inst_id_,
             sid        = user_env_sid_,
             serial#    = current_serial_
       WHERE id = job_id_;
      @ApproveTransactionStatement(2013-10-30,haarse)
      COMMIT;
      --set the session action into 'executeDeferredJob' explicitly so the cleanup logic in Transaction_SYS.Cleanup works correctly
      Dbms_Application_Info.read_module(module_name => module_name_,action_name => action_name_);
      Dbms_Application_Info.set_action(action_name => execute_job_action_);
      --
      Transaction_SYS.Execute_Type__(oldrec_.procedure_name, oldrec_.arguments, oldrec_.argument_type);
      --
      -- Reset session parameters
      --
      Transaction_SYS.Update_Current_Job_Id__(0);
      IF (Transaction_SYS.Is_Session_Deferred) THEN
         Fnd_Session_API.Reset_Fnd_User;
      END IF;
      $IF Component_Biserv_SYS.INSTALLED $THEN
         IF (     ( UPPER('Archive_API.Create_And_Print_Report__') = UPPER(oldrec_.procedure_name) )
              AND (   ( NVL(Xlr_System_Parameter_Util_API.Get_System_Parameter('BA_EXECUTION_SERVER_AVAILABLE'), 'NO') IN ('FOR_ALL_INFO_SERVICES_REPORTS', 'ONLY_FOR_SCHEDULED_REPORTS')))
              AND (NOT( NVL(Xlr_System_Parameter_Util_API.Get_System_Parameter_Boolean('ACTIVATE_BR_CONTAINER'), FALSE)))) THEN
            IF ( oldrec_.argument_type = 'MESSAGE') THEN
               clob_length_ := Dbms_Lob.getlength(oldrec_.arguments);
               clob_holder_ := Dbms_Lob.substr(oldrec_.arguments, clob_length_, 1);
               IF (Message_SYS.Is_Message(clob_holder_)) THEN
                  attr_ := NULL;
                  Message_SYS.Get_Attribute(clob_holder_, 'REPORT_ATTR', attr_);
                  IF (attr_ IS NOT NULL) THEN
                     report_id_   := Client_SYS.Get_Item_Value('REPORT_ID', attr_);
                     report_mode_ := Report_Definition_API.Get_Report_Mode(report_id_);
                     IF (report_mode_ = 'EXCEL1.0') THEN
                        is_bars_report_ := TRUE;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      $END 
      --
      -- Set correct status and time
      --
      OPEN find_warnings(job_id_);
      FETCH find_warnings INTO dummy_;
      IF find_warnings%FOUND THEN
         new_state_ := 'Warning';
      ELSE
         new_state_ := 'Ready';
      END IF;
      CLOSE find_warnings;

      -- Only update the status if BA Rendering Server is not used
      IF ( (NOT is_bars_report_) OR (new_state_ != 'Ready')) THEN
         UPDATE TRANSACTION_SYS_LOCAL_TAB
            SET state = new_state_,
                executed = sysdate
            WHERE id = job_id_;
      END IF;
      --reset the session action back to original
      Dbms_Application_Info.set_action(action_name => action_name_);
      EXCEPTION
         WHEN OTHERS THEN
            IF (Error_SYS.Is_Foundation_Error(sqlcode)) THEN
            -- Return the Foundation1 error message
               error_ := ltrim(substr(sqlerrm, instr(sqlerrm, ':', 1, 2) + 1))||
                      rpad(' ', 20)||substr(sqlerrm, 1, instr(sqlerrm, ':', 1, 2) - 1);
            ELSE
            -- Return complete error structure
               error_ := Substr(Dbms_Utility.Format_Error_Stack || ' '|| Dbms_Utility.Format_Error_Backtrace, 1, 2000);
            END IF;
            -- ROLLBACK
            new_state_ := 'Error';
            UPDATE TRANSACTION_SYS_LOCAL_TAB
               SET state = new_state_,
                   executed = sysdate,
                   error_text = error_,
                   error_key_value = Substr(Fnd_Context_SYS.Find_Value('ERROR_FORMATTED_KEY'), 1, 2000)
            WHERE id = job_id_;
            -- Reset
            Transaction_SYS.Update_Current_Job_Id__(0);
            IF (Transaction_SYS.Is_Session_Deferred) THEN
               Fnd_Session_API.Reset_Fnd_User;
            END IF;
            --reset the session action back to original
            Dbms_Application_Info.set_action(action_name => action_name_);
   END;
END Execute_Job;

PROCEDURE Repost_Job (
   job_id_ IN NUMBER )
IS
   oldrec_           TRANSACTION_SYS_LOCAL_TAB%ROWTYPE;
   user_env_sid_     NUMBER;
   current_inst_id_  NUMBER;
   current_serial_   NUMBER;
   job_queue_id_     NUMBER;
BEGIN
   oldrec_ := Lock_By_Keys___(job_id_);

   IF oldrec_.state <> 'Error' THEN
      Error_SYS.Appl_General(lu_name_, 'EXEERR: The job :P1 cannot be executed.', to_char(job_id_));
   END IF;
    
   job_queue_id_ := Batch_Queue_Method_API.Get_Default_Queue(oldrec_.procedure_name, oldrec_.lang_code);
      
   IF oldrec_.queue_id <> job_queue_id_ THEN
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Batch Queue changed from ' ||Batch_Queue_API.Get_Description(oldrec_.queue_id)|| ' to ' || Batch_Queue_API.Get_Description(job_queue_id_));
   END IF;
   
   -- Remove status messages of previous executions
   Remove_Status_Messages___(job_id_);
   
   -- Clear the 'Progress Info' field of the current job
   Clear_Progress_Info___(job_id_);

   user_env_sid_    := userenv('SID');
   current_inst_id_ := sys_context('USERENV', 'INSTANCE');
   current_serial_  := dbms_debug_jdwp.current_session_serial;
   
   UPDATE TRANSACTION_SYS_LOCAL_TAB
      SET state      = 'Posted',
          posted     = SYSDATE,
          queue_id   = job_queue_id_,
          started    = NULL,
          executed   = NULL,
          inst_id    = current_inst_id_,
          sid        = user_env_sid_,
          serial#    = current_serial_,
          error_text = NULL
    WHERE id = job_id_;
END Repost_Job;