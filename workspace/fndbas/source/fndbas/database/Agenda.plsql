-----------------------------------------------------------------------------
--
--  Logical unit: Agenda
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960409  MANY    Base Table to Logical Unit Generator 1.0A, recreated
--                  basefunctionality for 1.2 and most of the other.
--  970806  MANY    Chenges concerning new user concept FndUser
--  971028  MANY    Fixed problem with running report in batch under new FndUser
--                  concept.
--  981019  MANY    Fixed some translations to better conform with US English (ToDo #2746)
--  990920  ERFO    Rewrite of view definition for improved performance (ToDo #3580).
--  001019  ROOD    Removed erroneous deletion of batch jobs in Remove_Job__ (Bug #17410).
--  010608  ROOD    Added functionality in New_Job__ and Run_Job__ to support sending pdf files
--                  with mail (ToDo#4015). Updated to new template and removed PKG2 and PKG3.
--  010613  ROOD    Opened for "free" parameters when sending pdf files.
--                  Added modifications to method Modify_Job too (ToDo#4015).
--  010618  ROOD    Extended attribute string length in New_Job and Modify_Job (ToDo#4015).
--  020217  ROOD    Modifications to choose the default layout if none is selected (ToDo#4056).
--  020308  ROOD    Made the layout and language code always be set for the print jobs (Bug#27507).
--                  If no messaging is choosen, avoided creation of print job in Run_Job__.
--  020624  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030214  ROOD    Replaced usage of tables from other LU's with their views (ToDo#4149).
--  030218  ROOD    Removed hardcoded subcomponent names in messages (ToDo#4149).
--  030613  HAAR    Added new interface due to router changes (ToDo#4062).
--  030914  ROOD    Changed order in exception in Run_Job__ (ToDo#4161).
--  030930  HAAR    Added new parameter REPORT_BATCH in New_Job to determine 
--                  if the job is executed in the background (ToDo#4279).
--  031027  ROOD    Made sure that batch job is removed when deleting an agenda (Bug#38187).
--  040303  ROOD    Made this LU depreciated. It is replaced by LU ScheduledReport (Bug#39376).
--  040317  ROOD    Corrected handling of execution plan (Bug#39376).
--  040330  ROOD    Removed old unused implementation (Bug#39376).
--  040331  ROOD    Removed obsolete view and references to it (Bug39376).
--  041011  ROOD    Rerouted calls directly to BatchSchedule instead of ScheduledReport (F1PR419).
--  091023  UsRaLK  Increased the size support for BATCH_SCHEDULE_PAR_TAB.VALUE from 2000 to 4000 (Bug#86689).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Rep_Array_Type IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
TYPE Agenda_Rec IS RECORD
   (job_seq BATCH_SCHEDULE_TAB.executions%TYPE,
    user_name BATCH_SCHEDULE_TAB.username%TYPE,
    job_name BATCH_SCHEDULE_TAB.schedule_name%TYPE);

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Repack_Attribute_Strings___
--   To handle repacking of information when calling implementation in
--   ScheduledReport from this obsolete interface.
PROCEDURE Repack_Attribute_Strings___ (
   schedule_name_        OUT VARCHAR2,
   execution_plan_       OUT VARCHAR2,
   message_attr_         OUT VARCHAR2,
   archiving_attr_       OUT VARCHAR2,
   report_attr_       IN OUT VARCHAR2,
   job_attr_          IN     VARCHAR2,
   distribution_list_ IN     VARCHAR2 )
IS
   report_id_      VARCHAR2(30) := Client_SYS.Get_Item_Value('REPORT_ID', report_attr_);
   message_type_   VARCHAR2(30) := Client_SYS.Get_Item_Value('MESSAGE_TYPE', job_attr_);
   -- Attribute ARCHIVATE has been renamed to PDF_ARCHIVING
   pdf_archiving_  VARCHAR2(5)  := Client_SYS.Get_Item_Value('ARCHIVATE', job_attr_);
BEGIN
   -- Repack messaging information in the job attribute string to the message attribute string
   Client_SYS.Add_To_Attr('MESSAGE_TYPE', message_type_, message_attr_);
   IF message_type_ = 'EMAIL' THEN
      Client_SYS.Add_To_Attr('SEND_EMAIL_TO', Client_SYS.Get_Item_Value('SEND_EMAIL_TO', job_attr_), message_attr_);
   ELSIF message_type_ = 'PRINTER' THEN
      Client_SYS.Add_To_Attr('PRINTER_ID', Client_SYS.Get_Item_Value('PRINTER_ID', job_attr_), message_attr_);
   END IF;
   
   -- Repack pdf-archiving information in the job attribute string to the archiving attribute string
   -- Attribute ARCHIVATE has been renamed to PDF_ARCHIVING
   Client_SYS.Add_To_Attr('PDF_ARCHIVING', pdf_archiving_, archiving_attr_);
   IF pdf_archiving_ IS NOT NULL AND pdf_archiving_ = 'TRUE' THEN
      Client_SYS.Add_To_Attr('SEND_PDF', Client_SYS.Get_Item_Value('SEND_PDF', job_attr_), archiving_attr_);
      Client_SYS.Add_To_Attr('SEND_PDF_TO', Client_SYS.Get_Item_Value('SEND_PDF_TO', job_attr_), archiving_attr_);
      Client_SYS.Add_To_Attr('REPLY_TO_USER', Client_SYS.Get_Item_Value('REPLY_TO_USER', job_attr_), archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_1', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_1', job_attr_), archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_2', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_2', job_attr_), archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_3', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_3', job_attr_), archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_4', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_4', job_attr_), archiving_attr_);
      Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_5', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_5', job_attr_), archiving_attr_);
   END IF;
   
   -- Extract scheduling information from the job attribute string
   -- Attribute JOB_NAME is now instead the SCHEDULE_NAME
   schedule_name_ := Client_SYS.Get_Item_Value('JOB_NAME', job_attr_);
   IF schedule_name_ IS NULL THEN
      schedule_name_ := Report_Definition_API.Get_Translated_Report_Title(report_id_);
   END IF;
   -- Attribute EXEC_PLAN has been renamed to EXECUTION_PLAN
   execution_plan_ := Client_SYS.Get_Item_Value('EXEC_PLAN', job_attr_);

   -- Verify the contents of the distribution list
   Distribution_Group_API.Validate_Distribution_List(distribution_list_);

   -- Add the default layout to the report attribute string if no layout has been choosen
   IF Client_SYS.Get_Item_Value('LAYOUT_NAME', report_attr_) IS NULL THEN
      report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', report_attr_);
      Client_SYS.Set_Item_Value('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout(report_id_), report_attr_);
   END IF;
   -- Add the language code for this session to the report attribute string if no language has been choosen
   IF Client_SYS.Get_Item_Value('LANG_CODE', report_attr_) IS NULL THEN
      Client_SYS.Set_Item_Value('LANG_CODE', Fnd_Session_API.Get_Language, report_attr_);
   END IF; 
END Repack_Attribute_Strings___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Run_Job__ (
   dbms_job_key_   IN NUMBER )
IS
BEGIN
   Error_SYS.Appl_General(lu_name_, 'OBSOLETERUNJOB__: Calling obsolete interface Agenda_API.Run_Job__! The concept of Scheduled Reports is to be used instead');
END Run_Job__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist
--   Redirected to Batch_Schedule_API.Exist
@UncheckedAccess
PROCEDURE Exist (
   job_id_ IN NUMBER )
IS
BEGIN
   Trace_SYS.Message('Calling obsolete interface Agenda_API.Exist!');
   Trace_SYS.Message('Redirecting to Batch_Schedule_API.Exist!');
   Batch_Schedule_API.Exist(job_id_);
END Exist;


@UncheckedAccess
FUNCTION Get_Job_Seq (
   job_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Batch_Schedule_API.Get_Executions(job_id_);
END Get_Job_Seq;



@UncheckedAccess
FUNCTION Get_User_Name (
   job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ batch_schedule_tab.username%TYPE;
   CURSOR get_attr IS
      SELECT username
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_User_Name;



@UncheckedAccess
FUNCTION Get_Job_Name (
   job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ batch_schedule_tab.schedule_name%TYPE;
   CURSOR get_attr IS
      SELECT schedule_name
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Job_Name;



@UncheckedAccess
FUNCTION Get_Exec_Time (
   job_id_ IN NUMBER ) RETURN DATE
IS
   temp_ batch_schedule_tab.next_execution_date%TYPE;
   CURSOR get_attr IS
      SELECT next_execution_date
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Exec_Time;



@UncheckedAccess
FUNCTION Get_Exec_Plan (
   job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ batch_schedule_tab.execution_plan%TYPE;
   CURSOR get_attr IS
      SELECT execution_plan
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Exec_Plan;



@UncheckedAccess
FUNCTION Get_Report_Title (
   job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ batch_schedule_tab.external_id%TYPE;
   CURSOR get_attr IS
      SELECT external_id
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Report_Definition_API.Get_Translated_Report_Title(temp_);
END Get_Report_Title;



@UncheckedAccess
FUNCTION Get_Status (
   job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ batch_schedule_tab.active%TYPE;
   CURSOR get_attr IS
      SELECT active
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN Fnd_Boolean_API.Decode(temp_);
END Get_Status;



PROCEDURE New_Job (
   job_id_            OUT NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   job_attr_          IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2 )
IS
   schedule_id_         NUMBER;
   schedule_name_       VARCHAR2(200);
   execution_plan_      VARCHAR2(200);
   message_attr_        VARCHAR2(4000);
   archiving_attr_      VARCHAR2(4000);
   report_attr_local_   VARCHAR2(4000) := report_attr_;
   next_execution_date_ DATE;
   start_date_          DATE := SYSDATE;
   seq_no_              NUMBER;

BEGIN
   Trace_SYS.Message('Calling obsolete interface Agenda_API.New_Job!');
   Trace_SYS.Message('Redirecting to new interface Batch_SYS.New_Batch_Schedule');

   -- Common functionality for both New and Modify...
   Repack_Attribute_Strings___(schedule_name_,
                               execution_plan_,
                               message_attr_,
                               archiving_attr_,
                               report_attr_local_,
                               job_attr_,
                               distribution_list_);

   -- Find the next execution date from the execution plan (if this is not done, the schedule will execute immediately)
   next_execution_date_ := Batch_SYS.Get_Next_Exec_Time__(execution_plan_, start_date_);
   start_date_ := next_execution_date_;
   -- Create the new scheduled report.
   -- The LANG_CODE sent to the Schedule (here NULL) is the language the background job should use during execution.
   -- The LANG_CODE located in the report_attr is the preferred language for the printing of the report (e.g. with the Print Server)
   Batch_SYS.New_Batch_Schedule(schedule_id_,
                                next_execution_date_,
                                start_date_,
                                NULL,
                                schedule_name_,
                                'Archive_API.Create_And_Print_Report__',
                                'TRUE',
                                execution_plan_);
   
   -- Add the id of the created scheduled task to report attribute string.
   Client_SYS.Set_Item_Value('SCHEDULE_ID', schedule_id_, report_attr_local_);
   
   -- Add the parameters
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'REPORT_ATTR', report_attr_local_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'PARAMETER_ATTR', parameter_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'MESSAGE_ATTR', message_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'ARCHIVING_ATTR', archiving_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'DISTRIBUTION_LIST', distribution_list_);
   
   -- job_id_ is actually now the schedule_id_, so return it...
   job_id_ := schedule_id_;
      
END New_Job;


PROCEDURE Modify_Job (
   job_id_            IN  NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   job_attr_          IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2 )
IS
   schedule_attr_       VARCHAR2(4000);
   schedule_name_       VARCHAR2(200);
   execution_plan_      VARCHAR2(200);
   message_attr_        VARCHAR2(4000);
   archiving_attr_      VARCHAR2(4000);
   report_attr_local_   VARCHAR2(4000) := report_attr_;

   schedule_id_         NUMBER := job_id_;
   next_execution_date_ DATE;
   start_date_          DATE;
   stop_date_           DATE;
   active_              VARCHAR2(5);
   lang_code_           VARCHAR2(5);

BEGIN
   Trace_SYS.Message('Calling obsolete interface Agenda_API.Modify_Job!');
   
   -- Common functionality for both New and Modify...
   Repack_Attribute_Strings___(schedule_name_,
                               execution_plan_,
                               message_attr_,
                               archiving_attr_,
                               report_attr_local_,
                               job_attr_,
                               distribution_list_);
   
   -- Modify the scheduled report.
   Trace_SYS.Message('Redirecting to new interface Batch_SYS.Modify_Batch_Schedule');

   -- We are assuming that the attribute strings sent in are complete. 
   -- This means that almost no considerations are made for the old values...
   
   -- Find the name of this scheduled task, execution plan, etc.
   start_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('START_DATE', schedule_attr_));
   stop_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('STOP_DATE', schedule_attr_));
   next_execution_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value( 'NEXT_EXECUTION_DATE', schedule_attr_));
   active_ := Client_SYS.Get_Item_Value('ACTIVE_DB', schedule_attr_);
   -- The LANG_CODE located in the schedule attr is the language the background job should use during execution.
   -- The LANG_CODE in the report_attr is the preferred language for the printing of the report (e.g. with the Print Server)
   lang_code_ := Client_SYS.Get_Item_Value('LANG_CODE', schedule_attr_);

   -- report id is not to be modified...

   -- Find the next execution date (if this is not done, the schedule will execute immediately)
   IF next_execution_date_ IS NULL THEN
      next_execution_date_ := Batch_SYS.Get_Next_Exec_Time__(execution_plan_, start_date_);
   END IF;
   
   -- Update the Batch_Schedule
   Batch_SYS.Modify_Batch_Schedule(next_execution_date_,
                                   start_date_,
                                   stop_date_,
                                   schedule_id_,
                                   schedule_name_,
                                   active_,
                                   execution_plan_,
                                   lang_code_);
   
   -- Add/Modify the parameters
   Batch_SYS.Modify_Batch_Schedule_Param(1, schedule_id_, 'REPORT_ATTR', report_attr_local_);
   Batch_SYS.Modify_Batch_Schedule_Param(2, schedule_id_, 'PARAMETER_ATTR', parameter_attr_);
   Batch_SYS.Modify_Batch_Schedule_Param(3, schedule_id_, 'MESSAGE_ATTR', message_attr_);
   Batch_SYS.Modify_Batch_Schedule_Param(4, schedule_id_, 'ARCHIVING_ATTR', archiving_attr_);
   Batch_SYS.Modify_Batch_Schedule_Param(5, schedule_id_, 'DISTRIBUTION_LIST', distribution_list_);
   
END Modify_Job;


PROCEDURE Remove_Job (
   job_id_ IN NUMBER )
IS
BEGIN
   Trace_SYS.Message('Calling obsolete interface Agenda_API.Remove_Job!');
   Trace_SYS.Message('Redirecting to Batch_SYS.Remove_Batch_Schedule');
   Batch_SYS.Remove_Batch_Schedule(job_id_);
END Remove_Job;


PROCEDURE Get_Report_Details (
   report_attr_list_    OUT Rep_Array_Type,
   parameter_attr_list_ OUT Rep_Array_Type,
   job_attr_            OUT VARCHAR2,
   distribution_list_   OUT VARCHAR2,
   job_id_              IN  NUMBER )
IS
   message_attr_      VARCHAR2(4000);
   archiving_attr_    VARCHAR2(4000);
   schedule_name_     VARCHAR2(200);
   execution_plan_    VARCHAR2(255);
   
   CURSOR get_report_info IS
      SELECT seq_no, name, value
      FROM batch_schedule_par_tab
      WHERE schedule_id = job_id_
      ORDER BY seq_no;

   CURSOR get_schedule_info IS
      SELECT schedule_name, execution_plan
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;

BEGIN
   Trace_SYS.Message('Calling obsolete interface Agenda_API.Get_Report_Details!');
   FOR params IN get_report_info LOOP
      IF params.name = 'REPORT_ATTR' THEN
         report_attr_list_(1) := params.value;
      ELSIF params.name = 'PARAMETER_ATTR' THEN
         parameter_attr_list_(1) := params.value;
      ELSIF params.name = 'MESSAGE_ATTR' THEN
         message_attr_ := params.value;
      ELSIF params.name = 'ARCHIVING_ATTR' THEN
         archiving_attr_ := params.value;
      ELSIF params.name = 'DISTRIBUTION_LIST' THEN
         distribution_list_ := params.value;
      END IF;
   END LOOP;
   
   OPEN get_schedule_info;
   FETCH get_schedule_info INTO schedule_name_, execution_plan_;
   CLOSE get_schedule_info;

   Client_SYS.Add_To_Attr('JOB_NAME', schedule_name_, job_attr_);
   Client_SYS.Add_To_Attr('JOB_ID', job_id_, job_attr_);
   Client_SYS.Add_To_Attr('JOB_SEQ', 1, job_attr_);
   Client_SYS.Add_To_Attr('EXEC_PLAN', execution_plan_, job_attr_);
   job_attr_ := job_attr_ || message_attr_ || archiving_attr_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Record_Removed(lu_name_, NULL, job_id_);
END Get_Report_Details;


PROCEDURE Run_Job_Now (
   job_id_ IN NUMBER )
IS
   owner_ VARCHAR2(30);

BEGIN
   Trace_SYS.Message('Calling obsolete interface Agenda_API.Run_Job_Now!');
   
   owner_ := Get_User_Name(job_id_);
   IF (owner_ != Fnd_Session_API.Get_Fnd_User) THEN
      Error_SYS.Appl_General(lu_name_, 'RUNJOB: Only user [:P1] can run order no [:P2] in Agenda.', owner_, job_id_);
   END IF;

   Trace_SYS.Message('Redirecting to new interface Batch_Schedule_API.Run_Batch_Schedule__');
   Batch_Schedule_API.Run_Batch_Schedule__(job_id_, 'FALSE'); -- Run this in batch, not online...
END Run_Job_Now;


@UncheckedAccess
FUNCTION Get (
   job_id_ IN NUMBER ) RETURN Agenda_Rec
IS
   temp_ Agenda_Rec;
   CURSOR get_attr IS
      SELECT executions, username, schedule_name
      FROM batch_schedule_tab
      WHERE schedule_id = job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get;




