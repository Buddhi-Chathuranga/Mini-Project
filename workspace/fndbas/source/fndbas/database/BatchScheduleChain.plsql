-----------------------------------------------------------------------------
--
--  Logical unit: BatchScheduleChain
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  080630  HAAR  Created
--  081216  HAAR  Changed to use Autonomous transaction for logging in background jobs (IID#80009).
--  090116  JOWISE  Changed to Register_Schedule_Chain_Step in Export__
--  130101  WAWILK  Changed Run_Batch_Schedule_Chain__ to log progress info truncated (Bug#107305)
--  140309  USRA    Modified [Export__] to include a COMMIT (TEBASE-70).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
DB_TASK_CHAIN_SCHED_BASEURL CONSTANT VARCHAR2(100) := 'ifswin:Ifs.Application.TaskChainScheduling.TaskChainSchedule';
BACKGROUND_JOBS_BASEURL CONSTANT VARCHAR2(100):='ifsapf:Ifs.Application.Fndadm.BackgroundProcessing.tbwBackgroundJobs';


-------------------- PRIVATE DECLARATIONS -----------------------------------

-----------------------------------------------------------------------------
-------------------- IMPLEMENTATION BASE METHODS ----------------------------
-----------------------------------------------------------------------------

@Override
FUNCTION Check_Exist___ (
   schedule_method_id_ IN     NUMBER ) RETURN BOOLEAN
IS
BEGIN
   --Add pre-processing code here
   RETURN super(schedule_method_id_) OR Batch_Schedule_Method_API.Get_Module(schedule_method_id_, Installation_SYS.Get_Installation_Mode) IS NOT NULL;
   -- Get_Module is used to avoid circular references
END Check_Exist___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     batch_schedule_chain_tab%ROWTYPE,
   newrec_ IN OUT batch_schedule_chain_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   
   IF (NOT Installation_SYS.Get_Installation_Mode) THEN
      Module_API.Check_Active(newrec_.module);
   END IF;
END Check_Common___;

   
-----------------------------------------------------------------------------
-------------------- IMPLEMENTATION BASE METHODS FOR INSERT -----------------
-----------------------------------------------------------------------------
-- Insert___
--    Insert a new LU-instance into the database and return the values
--    for OBJID and OBJVERSION.
-----------------------------------------------------------------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT BATCH_SCHEDULE_CHAIN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.schedule_method_id IS NULL THEN
      SELECT schedule_method_id_seq.NEXTVAL
      INTO   newrec_.schedule_method_id
      FROM   dual;
   END IF;
   -- Add Presentation Object
   newrec_.po_id := Create_Presentation_Object___ (newrec_.schedule_method_id,
                                                   newrec_.description,
                                                   newrec_.module);
   --
   super(objid_, objversion_, newrec_, attr_);
   -- Return Schedule_Method_Id
   Client_SYS.Add_To_Attr('SCHEDULE_METHOD_ID', newrec_.schedule_method_id, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-----------------------------------------------------------------------------
-------------------- IMPLEMENTATION BASE METHODS FOR UPDATE -----------------
-----------------------------------------------------------------------------
-- Update___
--    Update an existing LU-instance in the database and return the
--    the new OBJVERSION.
-----------------------------------------------------------------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     BATCH_SCHEDULE_CHAIN_TAB%ROWTYPE,
   newrec_     IN OUT BATCH_SCHEDULE_CHAIN_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- Add Presentation Object
   newrec_.po_id := Create_Presentation_Object___ (newrec_.schedule_method_id,
                                                   newrec_.description,
                                                   newrec_.module);
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   -- Return Schedule_Method_Id
   Client_SYS.Add_To_Attr('SCHEDULE_METHOD_ID', newrec_.schedule_method_id, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-----------------------------------------------------------------------------
-------------------- IMPLEMENTATION BASE METHODS FOR DELETE -----------------
-----------------------------------------------------------------------------
-- Delete___
--    Deletion of the specific LU-object from the database.
-----------------------------------------------------------------------------

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN BATCH_SCHEDULE_CHAIN_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   -- Remove if already there
   Pres_Object_Util_API.Remove_Pres_Object(remrec_.po_id, 'Manual');
END Delete___;

-----------------------------------------------------------------------------
-------------------- PRIVATE BASE METHODS -----------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-------------------- PUBLIC BASE METHODS ------------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
-----------------------------------------------------------------------------

FUNCTION Create_Presentation_Object___ (
   schedule_method_id_   IN NUMBER,
   description_          IN VARCHAR2,
   module_               IN VARCHAR2 ) RETURN VARCHAR2
IS
   po_id_          VARCHAR2(200)   := 'taskchain'||replace(initcap(description_), ' ', '');
   po_description_ VARCHAR2(250)   := 'Task Chain - '||Substr(description_, 1, 220);

   CURSOR get_step IS
      SELECT m.method_name, m.validation_method, m.po_id
      FROM batch_schedule_chain_step_tab s, batch_schedule_method_tab m
      WHERE s.schedule_method_id = schedule_method_id_
      AND   s.chain_schedule_method_id = m.schedule_method_id
      ORDER BY s.step_no;
BEGIN
   -- Remove if already there
   Pres_Object_Util_API.Remove_Pres_Object(po_id_, 'Manual');
   -- Create presentation object
   Pres_Object_Util_API.New_Pres_Object(po_id_, module_, 'OTHER', po_description_, 'Manual');
   FOR rec IN get_step LOOP
      Pres_Object_Util_API.New_Pres_Object_Dependency (po_id_, rec.po_id, '4', 'Manual');
   END LOOP;
   RETURN(po_id_);
END Create_Presentation_Object___;

PROCEDURE Remove_Steps___ (
   schedule_method_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM batch_schedule_chain_step_tab
   WHERE  schedule_method_id = schedule_method_id_;
END Remove_Steps___;


-----------------------------------------------------------------------------
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-----------------------------------------------------------------------------
FUNCTION Export_Xml__ (
   schedule_method_id_ IN  NUMBER ) RETURN BLOB 
IS
   string_ VARCHAR2(32000);
   rec_    BATCH_SCHEDULE_CHAIN_TAB%ROWTYPE;

BEGIN
   rec_     := Get_Object_By_Keys___(schedule_method_id_);

   SELECT XMLELEMENT("DATABASE_TASK_CHAIN",
            XMLELEMENT("DESCRIPTION", rec_.DESCRIPTION),
            XMLELEMENT("MODULE", rec_.MODULE),
            XMLELEMENT("CHECK_EXECUTING", rec_.CHECK_EXECUTING),
       (SELECT XMLELEMENT("CHAIN_STEPS", XMLAGG(XMLELEMENT("CHAIN_STEP", 
                  XMLFOREST(STEP_NO, BREAK_ON_ERROR, METHOD_NAME)))) 
          FROM Batch_Schedule_Chain_Step_Tab s , Batch_Schedule_Method_Tab m
         WHERE s.schedule_method_id = schedule_method_id_ 
           AND s.chain_schedule_method_id = m.schedule_method_id)).getStringVal() 
          INTO string_
          FROM dual;
    RETURN utl_raw.Cast_To_Raw(string_);  
END Export_Xml__;

PROCEDURE Export__ (
   string_             OUT VARCHAR2,
   schedule_method_id_ IN  NUMBER )
IS
   newline_    CONSTANT VARCHAR2(2) := chr(13)||chr(10);
   rec_                 BATCH_SCHEDULE_CHAIN_TAB%ROWTYPE;
   CURSOR get_step IS
      SELECT s.step_no, s.break_on_error, s.chain_schedule_method_id, m.method_name
      FROM   Batch_Schedule_Chain_Step_Tab s, Batch_Schedule_Method_Tab m
      WHERE  s.schedule_method_id = schedule_method_id_
      AND    s.chain_schedule_method_id = m.schedule_method_id;
BEGIN
   rec_     := Get_Object_By_Keys___(schedule_method_id_);
   --
   -- Create Export file
   --
   string_ :=            '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || '-- Export file for Task Chain' || rec_.description || '.' || newline_;
   string_ := string_ || '-- ' || newline_;
   string_ := string_ || '--  Date    Sign    History' || newline_;
   string_ := string_ || '--  ------  ------  -----------------------------------------------------------' || newline_;
   string_ := string_ || '--  ' || to_char(sysdate, 'YYMMDD') || '  ' || rpad(Fnd_Session_API.Get_Fnd_User, 6, ' ') || '  ' ||
                         'Export file for task Chain' || rec_.description || '.' || newline_;
   string_ := string_ || '-------------------------------------------------------------------------------------------- ' || newline_;
   string_ := string_ || newline_;
   string_ := string_ || 'PROMPT Register Batch Schedule Chain "' || rec_.description || '"' || newline_;
   string_ := string_ || 'DECLARE' || newline_;
   string_ := string_ || '   schedule_method_id_ NUMBER          := NULL;' || newline_;
   string_ := string_ || '   step_no_            NUMBER          := NULL;' || newline_;
   string_ := string_ || '   info_msg_           VARCHAR2(32000) := NULL;' || newline_;
   string_ := string_ || 'BEGIN' || newline_;
   --
   -- Create Main Message
   --
   string_ := string_ || '   -- Construct Main Message' || newline_;
   string_ := string_ || '   info_msg_ := Message_SYS.Construct('''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''DESCRIPTION'', ''' || rec_.description || ''');' || newline_;
   string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''MODULE'', ''' || rec_.module || ''');' || newline_;
   string_ := string_ || '   -- Register Batch Schedule Chain' || newline_;
   string_ := string_ || '   Batch_SYS.Register_Batch_Schedule_Chain(schedule_method_id_, info_msg_);' || newline_;
   --
   -- Add Task Steps
   --
   string_ := string_ || '   -- Adding Steps' || newline_;
   FOR rec2 IN get_step LOOP
      string_ := string_ || '   -- Construct Main Message' || newline_;
      string_ := string_ || '   info_msg_ := Message_SYS.Construct('''');' || newline_;
      string_ := string_ || '   step_no_  := ' || rec2.step_no || ';' || newline_;
      string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''BREAK_ON_ERROR_DB'', ''' || rec2.break_on_error || ''');' || newline_;
      string_ := string_ || '   Message_SYS.Add_Attribute(info_msg_, ''METHOD_NAME'', ''' || rec2.method_name || ''');' || newline_;
      string_ := string_ || '   -- Register Batch Schedule Chain Step' || newline_;
      string_ := string_ || '   Batch_SYS.Register_Schedule_Chain_Step(schedule_method_id_, step_no_, info_msg_);' || newline_;
   END LOOP;
   string_ := string_ || 'END;' || newline_;
   string_ := string_ || '/' || newline_;
   string_ := string_ || 'COMMIT' || newline_;
   string_ := string_ || '/' || newline_;
END Export__;

@UncheckedAccess
FUNCTION Is_Pres_Object_Available__ (
   po_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF    Pres_Object_API.Get_Pres_Object_Type(po_id_) IS NULL THEN -- Check if Pres Object exists, if not return FALSE
      RETURN('FALSE');
   ELSIF Security_SYS.Has_System_Privilege('ADMINISTRATOR', Fnd_Session_API.Get_Fnd_User) THEN
      RETURN('TRUE');
   ELSIF Security_SYS.Is_Pres_Object_Available(po_id_) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Is_Pres_Object_Available__;

PROCEDURE Register__ (
   schedule_method_id_ IN OUT NUMBER,
   info_msg_           IN     VARCHAR2 )
IS
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     BATCH_SCHEDULE_CHAIN_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.schedule_method_id := schedule_method_id_;
   objrec_.description := Message_SYS.Find_Attribute(info_msg_, 'DESCRIPTION', '');   
   Client_SYS.Add_To_Attr('DESCRIPTION', objrec_.description, attr_);   
   Client_SYS.Add_To_Attr('CHECK_EXECUTING_DB', Message_SYS.Find_Attribute(info_msg_, 'CHECK_EXECUTING_DB', ''), attr_);
   --
   -- Check if method already exists in table
   --
   IF schedule_method_id_ IS NULL THEN
      objrec_.schedule_method_id := Get_Schedule_Method_Id(objrec_.description);
   ELSE
      IF Check_Exist___ (schedule_method_id_) THEN
         Error_SYS.Appl_General(lu_name_, 'DUPLICATE: The Batch Schedule Method [:P1] already exists.', Message_SYS.Find_Attribute(info_msg_, 'METHOD_NAME', ''));
      ELSE
         objrec_.schedule_method_id := schedule_method_id_;
      END IF;
   END IF;
   -- Remove steps if they exists
   Remove_Steps___(objrec_.schedule_method_id);
   --
   IF objrec_.schedule_method_id IS NULL THEN
      Client_SYS.Add_To_Attr('MODULE', Message_SYS.Find_Attribute(info_msg_, 'MODULE', ''), attr_);
      New__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      Get_Id_Version_By_Keys___ (objid_, objversion_, objrec_.schedule_method_id);
      Modify__ (info_, objid_, objversion_, attr_, 'DO');
   END IF;
   -- Return Schedule_Method_Id
   schedule_method_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SCHEDULE_METHOD_ID', attr_));
END Register__;

PROCEDURE Run_Batch_Schedule_Chain__ (
   schedule_id_ IN NUMBER )
IS
   parameters_ VARCHAR2(32000);
   info_       VARCHAR2(1000);
   status_     VARCHAR2(1000);
   has_error_ BOOLEAN;  
   chain_name_ batch_schedule_tab.schedule_name %TYPE;
   
   CURSOR get_chain_step IS
   SELECT s.schedule_method_id, s.chain_schedule_method_id, s.step_no, s.break_on_error, m.method_name, m.argument_type
     FROM batch_schedule_tab b, batch_schedule_chain_tab c,
          batch_schedule_chain_step_tab s, batch_schedule_method_tab m
    WHERE b.schedule_id = schedule_id_
      AND b.schedule_method_id = c.schedule_method_id
      AND c.schedule_method_id = s.schedule_method_id
      AND s.chain_schedule_method_id = m.schedule_method_id
   ORDER BY s.step_no;
   
BEGIN
   Transaction_SYS.Modify_Stream_Reference(DB_TASK_CHAIN_SCHED_BASEURL|| '?external_search=schedule_id='||schedule_id_);   
   
   SELECT schedule_name INTO chain_name_ FROM batch_schedule_tab WHERE schedule_id = schedule_id_;
   FOR rec IN get_chain_step LOOP
      info_ := Language_SYS.Translate_Constant(lu_name_, 'CHAIN_STARTED: [:P1] Step :P2 running method :P3 has been started in the scheduled chain.', Fnd_Session_API.Get_Language, Database_SYS.Get_Formatted_Datetime, rec.step_no, rec.method_name);
      Transaction_SYS.Log_Progress_Info(info_);
      status_ := info_;         
      Transaction_SYS.Log_Status_Info(status_, 'INFO');
      -- Get the parameters
      parameters_ := Batch_Schedule_Chain_Par_API.Get_Parameters__(schedule_id_, rec.chain_schedule_method_id, rec.step_no, rec.argument_type);
      BEGIN
         -- Schedule run online
         Transaction_SYS.Dynamic_Call(rec.method_name,
                                      rec.argument_type,
                                      parameters_);
      EXCEPTION
         WHEN OTHERS THEN
            IF rec.break_on_error = 'TRUE' THEN
               info_ := Language_SYS.Translate_Constant(lu_name_, 'CHAIN_ERROR_CONT: -    Step :P1 running method :P2 has raised an error and the scheduled chain has been stopped.', Fnd_Session_API.Get_Language, rec.step_no, rec.method_name);
               Transaction_SYS.Log_Progress_Info(info_);
               Transaction_SYS.Log_Status_Info(info_, 'WARNING');
               Transaction_SYS.Modify_Stream_Error_Message(lu_name_ ,'CHAIN_ERR_STRM_H: Task Chain Error','CHAIN_ERR_STRM_M: Task Chain Failed at Step :P1',rec.step_no);
               Transaction_SYS.Modify_Stream_URL(BACKGROUND_JOBS_BASEURL|| '?external_search=job_id='||Transaction_SYS.Get_Current_Job_Id);    
               RAISE;
            ELSE
               info_ := Language_SYS.Translate_Constant(lu_name_, 'CHAIN_ERROR: -    Step :P1 running method :P2 has raised error: :P3.', Fnd_Session_API.Get_Language, rec.step_no, rec.method_name, sqlerrm);
               --truncate the info text if the concatanated error message is too lengthy
               IF (length(info_)>200) THEN
                  Transaction_SYS.Log_Progress_Info(substr(info_,1,197)||'...');
                  status_ := substr(info_,1,197)||'...';
                  Transaction_SYS.Log_Status_Info(status_, 'WARNING');
               ELSE
                  Transaction_SYS.Log_Progress_Info(info_);
                  status_ := info_;         
                  Transaction_SYS.Log_Status_Info(status_, 'WARNING');
               END IF;
               --
               info_ := Language_SYS.Translate_Constant(lu_name_, 'CHAIN_ERROR_STOP: -    Step :P1 running method :P2 has raised an error but the scheduled chain has not been stopped.', Fnd_Session_API.Get_Language, rec.step_no, rec.method_name);
               Transaction_SYS.Log_Progress_Info(info_);
               has_error_:= TRUE;
            END IF;
      END;
      info_ := Language_SYS.Translate_Constant(lu_name_, 'CHAIN_FINISHED: [:P1] Step :P2 running method :P3 has been finished in the scheduled chain.', Fnd_Session_API.Get_Language, Database_SYS.Get_Formatted_Datetime, rec.step_no, rec.method_name);
      Transaction_SYS.Log_Progress_Info(info_);
      status_ := info_;         
      Transaction_SYS.Log_Status_Info(status_, 'INFO');
      
      IF has_error_ THEN
        --If any steps fail
        Transaction_SYS.Modify_Stream_Message(lu_name_ ,'CHAIN_OK_STRM_H: Task Chain Completed','CHAIN_OKERR_STRM_M: Task Chain :P1 Completed With Errors',chain_name_);         
        Transaction_SYS.Modify_Stream_URL(BACKGROUND_JOBS_BASEURL|| '?external_search=job_id='||Transaction_SYS.Get_Current_Job_Id);
      ELSE
        --If all steps succeeded
        Transaction_SYS.Modify_Stream_Message(lu_name_ ,'CHAIN_OK_STRM_H: Task Chain Completed','CHAIN_OK_STRM_M: Task Chain :P1 Completed Sucessfully',chain_name_);
      END IF;
      
         
            
   END LOOP;
   Transaction_SYS.Log_Progress_Info('');
   @ApproveTransactionStatement(2013-10-30,haarse)
   COMMIT;
END Run_Batch_Schedule_Chain__;

-----------------------------------------------------------------------------
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
-----------------------------------------------------------------------------

FUNCTION Get_ (
   schedule_method_id_ IN NUMBER,
   skip_module_active_check_  IN BOOLEAN ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (schedule_method_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   IF NOT skip_module_active_check_ THEN
      RETURN Get(schedule_method_id_);
   ELSE
      SELECT schedule_method_id, rowid, rowversion, rowkey,
             description, 
             module, 
             po_id, 
             check_executing
      INTO  temp_
      FROM  batch_schedule_chain_tab
      WHERE schedule_method_id = schedule_method_id_;
   END IF;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(schedule_method_id_, 'Get_');
END Get_;

-----------------------------------------------------------------------------
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-----------------------------------------------------------------------------

@UncheckedAccess
FUNCTION Get_Schedule_Method_Id (
   description_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ BATCH_SCHEDULE_CHAIN_TAB.schedule_method_id%TYPE;
   CURSOR get_attr IS
      SELECT schedule_method_id
      FROM   BATCH_SCHEDULE_CHAIN_TAB
      WHERE  description = description_;
BEGIN
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Schedule_Method_Id;


