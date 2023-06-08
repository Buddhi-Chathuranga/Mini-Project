-----------------------------------------------------------------------------
--
--  Logical unit: PrintQueue
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961021  MaDr  Created
--  961024  MANY  Renamed file to PrtQue.APY
--  961120  MaDr  Procedure Print_Job did not insert PERFORM_PRINTER_ID column
--  961211  MaNy  Added new printer logic to method Print_Job(), handling both
--                printer_id's and logical_printers.
--  970729  MaDr  Corrected names of protected methods in Print_Server_SYS
--  980802  MANY  Fixed so that IFS PrintServer now only operates on logical printers
--                (ToDo #1806)
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  990125  MANY  Applied ORDER BY on select in method Get_Job() (Bug #3095)
--  010608  ROOD  Changed the method used to get printer in method Print_Job to be
--                able to remove the unnecessary method in Print_Job_API.
--                Updated to new template.
--  020624  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030704  RAKU  Added default param print_job_owner_ on Get_Job (ToDo#4276).
--  041209  DOZE  Added Get_Remote_Job and Is_Remote (F1PR463)
--  050420  DOZE  Added REMOTE-column and new printer_list_ parameter to Get_Job (49845)
--                Added Get_Job_Count (49845)
--  050511  MAOL  Modified Get_Job_Count and Get_Job to pick always include/pick
--                jobs bound for Connect, printers named SEND_..._TO_CONNECT (49845)
--  050512  MAOL  Fixed problem with 49845 mod disabeling Print Server (51222)
--  050819  MAOL  Modification of Get_Job_Count (52896)
--  051208  DOZE  Modified Get_Job and Get_Job_Count to use joins instead of
--                function calls in where statements.
--  051212  MAOL  Changed to use print_job_tab instead of print_job view in
--                Get_Job. Correction on above fix.
--  060104  MAOL  Fixed issue with Print Agent picking all jobbs after 5122 fix. (55480)
--  060123  NiWi  Modified Get_Job. Added print_job_id for the order by clause.
--  090228  MAOL  Jobs bound for remote printers (printed by Print Agent), still need
--                it's logical printer mapped in the Report Formatter configuration.
--                Without this dates and numbers can be formatted using teh correct locale.
--  060313  CHAA  Emailing Report Designer type reports
--  070622  UTGU  Modified Get_Job to improve performance.(Bug#66046)
--  080109  UTGU  Modified length of attr_ to 32000 in Get_Remote_Job.(Bug#70411)
--  080514  SUBS  Modified Get_Remote_Job to remove Print_Job_Contents_API.Get_Instance_Attr() call  (Bug#73722)
--  080811  SUBS  Modified Get_Remote_Job to pick the print jobs in order of created time and print job id. <bug#74491>
--  080825  DASVSE  Threading problem (76598)
--  090722  LAKRLK  When printing Print Agent doesn't print Number of copies from print dialog (83032)
--  101019  MADILK  When printing Print Agent doesn't print the pages as the print dialog gives (93483)
--  130424  CHAALK  Random locale in PDF when the Logical Printer name contains PDF_PRINTER as part of the name in different Report Formatters (109682
--  140129  AsiWLK  Merged LCS-111925
--  140909  MADRSE  Added function Is_Internal_Printer (TEJSE-201)
--  118337  SKUMLK  MERGED LCS-118337
--  151202  MABALK  Add PDF_PRINTER as a Internal Printer
--  161019  ASIWLK  LCS- 131892 Improvements for better exception handling PrintQueue
--  161214  MADILK  TEREPORT-2326 - Merging 132493 Invalid values for copies, printFrom and printTo options hang the Print Agent
--  170227  CHAALK  Patch Merge Bug ID 134113 Report Stream Notifications through events
--  181204  CHAALK  Add 5 more event parameters to the PDF_REPORT_CREATED event (BugID#145665)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Error (
   print_job_id_  IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   error_message_1_ VARCHAR2(2000);
BEGIN
   --
   --  Note! All columns from PRINT_QUEUE_PERFORM_IX are cleared to
   --        cause a deletion of the index entry.
   --
   UPDATE print_queue_tab SET
      status             = 'ERROR',
      perform_time       = null,
      perform_category   = null,
      perform_printer_id = null,
      error_message      = substr(error_message_,1,2000),
      rowversion         = rowversion + 1
   WHERE
      print_job_id = print_job_id_;
      
   error_message_1_ := print_job_error_event___(print_job_id_);   
END Set_Error;


PROCEDURE Abort_Job (
   print_job_id_  IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
BEGIN
   Set_Error(print_job_id_, error_message_);
   Print_Job_API.Set_Error(print_job_id_, error_message_);
END Abort_Job;


PROCEDURE Complete_Job (
   print_job_id_ IN NUMBER )
IS
BEGIN
   Remove_Job(print_job_id_);
   Print_Job_API.Set_Complete(print_job_id_);
END Complete_Job;


PROCEDURE Get_Job (
   print_job_id_    OUT NUMBER,
   min_category_    IN  NUMBER   DEFAULT NULL,
   max_category_    IN  NUMBER   DEFAULT NULL,
   print_job_owner_ IN  VARCHAR2 DEFAULT 'PRINTSRV',
   printer_list_    IN  VARCHAR2 DEFAULT NULL)
IS
   row_locked EXCEPTION;
   PRAGMA exception_init(row_locked, -0054);
   dummy_            INTEGER;
   formatted_printer_list_ VARCHAR2(32000);
BEGIN

   -- The "print_job_owner", by default PRINTSRV, should be used to distinguish the print
   -- jobs so different "servers" should find only its own jobs to execute.

   -- printer_list_ is build by the PrintAgent and sent in. The format is
   -- A;B;C and we change it into 'A';'B';'C' here
   -- if a printer list is sent in, we regard only jobs for those printers
   -- (or without any printer, or remote)

   IF printer_list_ IS NOT NULL THEN
      formatted_printer_list_ := '''' || replace(printer_list_, ';', ''';''') || '''';
   END IF;

   FOR job_ IN
     (SELECT p.rowid, p.print_job_id, p.perform_printer_id
      FROM   print_queue_tab P
      WHERE  p.perform_time <= sysdate
      AND    nvl(p.perform_category,0) BETWEEN nvl(min_category_,0)
                                         AND nvl(max_category_,999999)
      AND    p.status = 'WAITING'
      ORDER BY p.create_time ASC, print_job_id ASC)
   LOOP
      IF (Is_Internal_Printer(job_.perform_printer_id)) OR
         (instr(formatted_printer_list_, ''''||substr(job_.perform_printer_id, instr(job_.perform_printer_id, ',', 1, 2)+1)||'''')>0) THEN
      BEGIN
         SELECT 0
         INTO   dummy_
         FROM   print_queue_tab
         WHERE  rowid = job_.rowid
         AND    status = 'WAITING'
         FOR UPDATE OF status NOWAIT;

         UPDATE print_queue_tab SET
            status = 'WORKING',
            server_session_id = userenv('SESSIONID')
         WHERE  rowid = job_.rowid;

         print_job_id_ := job_.print_job_id;
         Print_Job_API.Set_Working(job_.print_job_id);
         RETURN;
      EXCEPTION
         WHEN row_locked THEN NULL;
         WHEN no_data_found THEN NULL;
      END;
   END IF;
   END LOOP;
   print_job_id_ := NULL;
END Get_Job;

PROCEDURE Start_Job (print_job_id_    IN NUMBER)
IS
   row_locked EXCEPTION;
   PRAGMA exception_init(row_locked, -0054);
   dummy_            INTEGER;
BEGIN
      SELECT 0
      INTO   dummy_
      FROM   print_queue_tab
      WHERE  print_job_id = print_job_id_
      AND    status = 'WAITING'
      FOR UPDATE OF status NOWAIT;

      UPDATE print_queue_tab SET
         status = 'WORKING',
         server_session_id = userenv('SESSIONID')
      WHERE  print_job_id = print_job_id_;
      Print_Job_API.Set_Working(print_job_id_);
      RETURN;
   EXCEPTION
      WHEN row_locked THEN
         Error_Sys.Appl_General('PrintQueue', 'ROW_LOCKED: Print Job :P1 was locked and could not be processed.',print_job_id_);
      WHEN no_data_found THEN
         Error_Sys.Appl_General('PrintQueue', 'NO_DATA_FOUND: Print Job :P1 was not found or was not in WAITING state.',print_job_id_);

END Start_Job;


PROCEDURE Print_Job (
   print_job_id_ IN NUMBER,
   category_     IN NUMBER DEFAULT NULL )
IS
   printer_name_ VARCHAR2(300);
   printer_id_   VARCHAR2(300);
   remote_ VARCHAR2(5) := NULL;
BEGIN
   -- Verify that the job really exist.
   Print_Job_API.Exist(print_job_id_);
   -- Investigate the printer
   printer_name_ := Print_Job_API.Get_Printer_Id(print_job_id_);
   LOGICAL_PRINTER_API.Convert_Logical_Printer(printer_id_, printer_name_);
   Trace_SYS.Field('printer_id_',printer_id_);
   IF Is_Remote(print_job_id_) = 'TRUE' THEN
      remote_ := 'TRUE';
   END IF;
   -- Insert the print job into the queue or update an existing job.
   BEGIN
      INSERT INTO print_queue_tab (
         print_job_id,
         status,
         create_time,
         perform_time,
         perform_category,
         perform_printer_id,
         error_message,
         rowversion,
         remote)
      VALUES (
         print_job_id_,
         'WAITING',
         sysdate,
         sysdate,
         category_,
         printer_id_,
         NULL,
         1,
         remote_);
   EXCEPTION
      WHEN dup_val_on_index THEN
         UPDATE print_queue_tab SET
            status             = 'WAITING',
            perform_time       = sysdate,
            perform_category   = category_,
            perform_printer_id = printer_id_,
            error_message      = NULL,
            rowversion         = rowversion + 1,
            remote             = remote_
         WHERE
            print_job_id = print_job_id_;
   END;
   -- Update status of the print job
   Print_Job_API.Set_Waiting(print_job_id_);
END Print_Job;


PROCEDURE Remove_Job (
   print_job_id_ IN NUMBER )
IS
BEGIN
   DELETE print_queue_tab WHERE print_job_id = print_job_id_;
END Remove_Job;

FUNCTION Get_Int_Value (
   print_prop_val_ IN VARCHAR2) RETURN NUMBER
IS
   temp_ VARCHAR2(1000);
BEGIN
   temp_ := print_prop_val_;
   -- This returns 1 if print_prop_val_ isn't a valid integer
   RETURN COALESCE(TO_NUMBER(REGEXP_SUBSTR(temp_, '^\-?\d*\.?\d*$')), 1);
END Get_Int_Value;

PROCEDURE Get_Remote_Job (
   job_id_ OUT NUMBER,
   printer_id_ OUT VARCHAR2,
   copies_ OUT NUMBER,
   print_from_page_ OUT NUMBER,
   print_to_page_   OUT NUMBER,
   remote_printing_node_ IN VARCHAR2 )
IS
   row_locked EXCEPTION;
   PRAGMA exception_init(row_locked, -0054);
   dummy_            INTEGER;
   print_job_id_     NUMBER;
   row_total_        NUMBER;
   row_              NUMBER;
   pos_ NUMBER;
   end_pos_ NUMBER;
   str_copies_ VARCHAR2(300);
   attr_ VARCHAR2(32000);
   frompage_start_ NUMBER;
   frompage_end_   NUMBER;
   topage_start_   NUMBER;
   topage_end_     NUMBER;
   prints_         NUMBER;
BEGIN
   Remote_Printing_Node_API.Touch(remote_printing_node_);
   -- optimization
   SELECT count(*) INTO prints_ FROM print_job_tab j WHERE j.status = 'REMOTE WAITING';
   IF(prints_=0) THEN 
      RETURN;
   END IF;
   ---------------
   FOR job_ IN
     (SELECT p.rowid, p.print_job_id, create_time, p.perform_printer_id
      FROM   print_queue_tab P, print_job_tab j
      WHERE  j.status = 'REMOTE WAITING' and p.status = 'WORKING'
      AND    p.print_job_id = j.print_job_id
      AND    perform_printer_id in
     (SELECT lp.description||',SERVER,'||rpm.logical_printer FROM
      logical_printer lp, remote_printer_mapping rpm
      WHERE rpm.remote_printing_node = remote_printing_node_
      AND lp.printer_id = rpm.logical_printer)
      ORDER BY create_time, p.print_job_id ASC)
   LOOP
      BEGIN
         SELECT 0
         INTO   dummy_
         FROM   print_queue_tab
         WHERE  rowid = job_.rowid
         AND    status = 'WORKING'
         FOR UPDATE OF status NOWAIT;

         UPDATE print_queue_tab SET
            status = 'REMOTE WORKING',
            server_session_id = userenv('SESSIONID')
         WHERE  rowid = job_.rowid;

         job_id_ := job_.print_job_id;
         pos_ := instr(job_.perform_printer_id, ',SERVER,', 1);
         IF (pos_ > 0) THEN
             printer_id_ := substr(job_.perform_printer_id, pos_ + 8);
         ELSE
             printer_id_ := job_.perform_printer_id;
         END IF;

		 print_from_page_ :=1;
		 print_to_page_  :=-1;
		 copies_ :=1;
		 
         row_ :=1;
         Print_Job_Contents_Api.Get_Instance_Attr(attr_,job_.print_job_id,row_total_,row_);
         pos_:= instr(attr_,'COPIES(');
         end_pos_:= instr(attr_,')',pos_);
         IF pos_ > 0 THEN
            str_copies_ := substr(attr_,pos_+7,end_pos_+1);
            str_copies_ := substr(str_copies_, 0,instr(str_copies_,')')-1);
			copies_ := Get_Int_Value(str_copies_);
         END IF;

         pos_       := instr(attr_,'PAGES(');
         IF pos_ > 0 THEN
            frompage_start_:= instr(attr_,'(',pos_,1) + 1;
            frompage_end_  := instr(attr_,',',pos_,1) -1;
            topage_start_  := frompage_end_ +2;
            topage_end_    := instr(attr_,')',pos_,1) - 1;
            IF frompage_start_ = frompage_end_ +1 THEN
               print_from_page_ := 1;
               print_to_page_   := Get_Int_Value(substr(attr_,topage_start_  , topage_end_ - topage_start_ +1)) -1;
            ELSIF topage_start_ = topage_end_ THEN
               print_from_page_ := Get_Int_Value(substr(attr_,frompage_start_  , frompage_end_ - frompage_start_ +1)) -1;
               print_to_page_   := -1;
            ELSE
               print_from_page_ := Get_Int_Value(substr(attr_,frompage_start_  , frompage_end_ - frompage_start_ +1)) -1;
               print_to_page_   := Get_Int_Value(substr(attr_,topage_start_  , topage_end_ - topage_start_ +1)) -1;
            END IF;
         END IF;

         IF copies_ < 1 THEN copies_ := 1; END IF;
         IF print_from_page_ < 1 THEN print_from_page_ := 1; END IF;         
         IF print_to_page_ < 1 THEN print_to_page_ := -1; END IF;


         Print_Job_API.Set_Remote_Working(job_.print_job_id);
         RETURN;
      EXCEPTION
         WHEN row_locked THEN NULL;
         WHEN no_data_found THEN NULL;
		 WHEN OTHERS THEN  Error_SYS.Record_General(lu_name_, 'REMOTEERROR: Error during printing job: :P1 (attr: :P2). :P3', job_.print_job_id, attr_, SQLERRM);
      END;
   END LOOP;
   print_job_id_ := 0;
   copies_ := 0;
END Get_Remote_Job;


@UncheckedAccess
FUNCTION Is_Remote (
   print_job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   printer_name_ VARCHAR2(300);
   node_name_ VARCHAR2(300);
--   printer_id_   VARCHAR2(300);
   bare_printer_id_ VARCHAR2(300);
   pos_ NUMBER;
   status_ VARCHAR2(5) := 'FALSE';
   CURSOR get_printing_node IS
     SELECT remote_printing_node
       FROM remote_printer_mapping
       WHERE logical_printer = bare_printer_id_;

BEGIN
   IF Print_Job_API.Get_Print_Job_Owner_Db(print_job_id_) = 'AGENT' THEN
      printer_name_ := Print_Job_API.Get_Printer_Id(print_job_id_);
--      Print_Server_SYS.Convert_Logical_Printer(printer_id_, printer_name_);
      pos_ := instr(printer_name_, ',SERVER,', 1);
      IF (pos_ > 0) THEN
         bare_printer_id_ := substr(printer_name_, pos_ + 8);
         OPEN get_printing_node;
         FETCH get_printing_node INTO node_name_;
         IF get_printing_node%found THEN

               status_ := 'TRUE';

         END IF;
         CLOSE get_printing_node;
      END IF;
   END IF;
   RETURN status_;
END Is_Remote;


@UncheckedAccess
FUNCTION Is_Internal_Printer (
   perform_printer_id_ IN VARCHAR2) RETURN BOOLEAN
IS
   printer_id_ VARCHAR2(250) := substr(perform_printer_id_, instr(perform_printer_id_, ',', 1, 2) + 1);
BEGIN
   RETURN printer_id_ IS NULL OR printer_id_ IN ('SEND_XML_TO_CONNECT', 'SEND_FULL_XML_TO_CONNECT', 'SEND_PDF_TO_CONNECT','SEND_TO_CONNECT', 'PDF_PRINTER', 'NO_PRINTOUT');
END Is_Internal_Printer;


@UncheckedAccess
FUNCTION Check_Exist (
   print_job_id_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   IF (NOT Check_Exist___(print_job_id_)) THEN
      RETURN FALSE;
   ELSE
      RETURN TRUE;
   END IF;
END Check_Exist;

FUNCTION print_job_error_event___ (
   print_job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   
   FUNCTION Core (
      print_job_id_ IN NUMBER ) RETURN VARCHAR2
   IS
      
      event_enabled_           BOOLEAN := Event_SYS.Event_Enabled(lu_name_ ,'PDF_REPORT_ERROR');
      fnd_user_                VARCHAR2(30);
      no_of_report_keys_       NUMBER := 0;
      report_key_              NUMBER := 0;
      result_key_              NUMBER;
      language_code_           VARCHAR2(5);
      report_title_trans_      VARCHAR2(200);
      
      archive_instance_attr_   VARCHAR2(32000);
      archive_param_attr_      VARCHAR2(32000);
      archive_variable_attr_   VARCHAR2(32000);
      archive_event_params_     VARCHAR2(4000);
      
      event_msg_               VARCHAR2(32000);
      subject_                 VARCHAR2(200);
      mail_text_               VARCHAR2(500);
      
      error_message_           VARCHAR2(2000);
      attr_                   VARCHAR2(32000);
      settings_                VARCHAR2(32000);
   
   BEGIN
      -- Abort as soon as possible if no more processing is needed.
      IF NOT event_enabled_ THEN
         RETURN NULL;
      END IF;
   
      --fnd_user_      :=  fnd_session_api.Get_Fnd_User();
      Client_SYS.Clear_Attr(attr_);
      Print_Job_API.Get_Job_Attr(attr_, print_job_id_);
      fnd_user_ := Client_SYS.Get_Item_Value('USER_NAME', attr_);
      no_of_report_keys_ := Print_Job_Contents_API.Get_No_Of_Result_Keys(print_job_id_);
   
      WHILE report_key_ < no_of_report_keys_ LOOP
         result_key_    := Print_Job_Contents_API.Get_Result_Key(print_job_id_,report_key_);
         report_key_  := report_key_ +1;
         -- Execute the event
         IF event_enabled_ THEN
            event_msg_ := Message_SYS.Construct('PDF_REPORT_ERROR');
            --
            -- Standard event parameters
            --
            Message_SYS.Add_Attribute( event_msg_, 'EVENT_DATETIME', sysdate );
            Message_SYS.Add_Attribute( event_msg_, 'USER_IDENTITY', fnd_user_ );
            Message_SYS.Add_Attribute( event_msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_) );
            Message_SYS.Add_Attribute( event_msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS') );
            Message_SYS.Add_Attribute( event_msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE') );
            --
            -- Primary key for object
            --
            Message_SYS.Add_Attribute( event_msg_, 'RESULT_KEY', result_key_ );
            --
            -- PDF Report Created event parameter values from Archive (only to be used when these parameters are absent in PrintJob)
            --
            archive_event_params_ := Archive_API.Get_Event_Params( result_key_ );
            --
            -- Other information
            --
            Archive_API.Get_Instance_Info(archive_instance_attr_, archive_param_attr_, archive_variable_attr_, result_key_);
            language_code_ := Client_SYS.Get_Item_Value('LANG_CODE', archive_instance_attr_);
            report_title_trans_:= Client_SYS.Get_Item_Value('REPORT_TITLE', archive_instance_attr_);
            
            Message_SYS.Add_Attribute(event_msg_, 'REPORT_TITLE', Archive_API.Get_Report_Title(result_key_));
            Message_SYS.Add_Attribute(event_msg_, 'REPORT_TITLE_TRANS', report_title_trans_);
            Message_SYS.Add_Attribute(event_msg_, 'PRINT_JOB_ID', print_job_id_);
            Message_SYS.Add_Attribute(event_msg_, 'STATUS', 'ERROR');
            Message_SYS.Add_Attribute(event_msg_, 'REPLY_TO_USER', fnd_user_);
            Message_SYS.Add_Attribute(event_msg_, 'PRINTER_ID',substr(Client_SYS.Get_Item_Value('PRINTER_ID', attr_), instr(Client_SYS.Get_Item_Value('PRINTER_ID', attr_), ',',1,2)+1));
            Message_SYS.Add_Attribute(event_msg_, 'REPORT_ID', Client_SYS.Get_Item_Value('REPORT_ID', archive_instance_attr_));
            Message_SYS.Add_Attribute(event_msg_, 'LAYOUT_NAME', Client_SYS.Get_Item_Value('LAYOUT_NAME', archive_instance_attr_));
            Message_SYS.Add_Attribute(event_msg_, 'LANGUAGE_CODE', language_code_);
            Message_SYS.Add_Attribute(event_msg_, 'REPORT_PARAMETERS', archive_param_attr_);
            Message_SYS.Add_Attribute(event_msg_, 'REPORT_VARIABLES', archive_variable_attr_);
            -- These parameters should always be available in the event even though no automatic mail has been sent yet.
            settings_ := Client_SYS.Get_Item_Value('SETTINGS', attr_);
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_1', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_1', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_1', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_2', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_2', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_2', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_3', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_3', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_3', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_4', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_4', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_4', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_5', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_5', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_5', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_6', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_6', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_6', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_7', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_7', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_7', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_8', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_8', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_8', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_9', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_9', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_9', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_10', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_10', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_10', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_11', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_11', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_11', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_12', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_12', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_12', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_13', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_13', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_13', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_14', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_14', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_14', '')));
            Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_15', NVL(Message_SYS.Find_Attribute(settings_, 'PDF_EVENT_PARAM_15', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_15', '')));
            -- These parameters will only be available in the event if an automatic email has been sent
            subject_   := Language_SYS.Translate_Constant(lu_name_, 'PDF_ERROR_SUBJECT: PDF-file report ended in error', language_code_);
            mail_text_ := Language_SYS.Translate_Constant(lu_name_, 'PDF_ERROR_MAIL_TEXT: There was an error when printing the report :P1 . ', language_code_, report_title_trans_);
            Message_SYS.Add_Attribute(event_msg_, 'MAIL_SUBJECT', subject_);
            Message_SYS.Add_Attribute(event_msg_, 'MAIL_TEXT', mail_text_);
            Event_SYS.Event_Execute(lu_name_, 'PDF_REPORT_ERROR', event_msg_ );
         END IF;
      END LOOP;

      RETURN NULL;

      EXCEPTION
      WHEN OTHERS THEN
         error_message_ := SQLERRM;
         RETURN error_message_ ;
   END Core;

BEGIN
   RETURN Core(print_job_id_);
END print_job_error_event___;
