-----------------------------------------------------------------------------
--
--  Logical unit: PrintJob
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961022  MANY  Created
--  961119  MADR  Update_Instance___ did not set MESSAGE column
--  961120  MANY  Update_Instance___() did not work for AppOwner, added
--                Utility_SYS.Get_Owner.
--  970806  MANY  Chenges concerning the new USER concept, FndUser
--  971009  MANY  Implemented method Cleanup__(), ToDo #1694.
--  980121  MANY  Fixed bug #2023, Print Jobs end up in status Working.
--  980817  MANY  Chenges to method Print(), checking for  empty printjobs and
--                and raising error (ToDo #2633)
--  980831  MANY  Improved where statement in view for performance reasons.
--  980923  MANY  Changes in Set_Complete(), removes job  if it was for
--                PDF-archiveing after job is completed (part of Todo #2442)
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  981026  MANY  Added method Archivate() (ToDo #2797)
--  990119  MANY  Added newly created method for row-level security on view.
--  990322  ERFO  Cleanup problems regarding performance and logic (Bug #3238).
--  990427  ERFO  Performance fix in view definition (Bug #3329).
--  990527  MANY  Fixed method Get_Attr to also return USER_NAME for Project Orion (ToDo #3375)
--  990920  ERFO  Rewrite of view definition for improved performance (ToDo #3580).
--  010608  ROOD  Added event handling for creation of PDF files (ToDo#4015).
--  010613  ROOD  Added more information into the new event (ToDo#4015).
--  011001  ROOD  Modified handling of Reply_To_User in Handle_Pdf_File (ToDo#4015).
--  011023  ROOD  Extended error handling in Handle_Pdf_File (ToDo#4015).
--  020308  ROOD  Find information about language code and layout from print job
--                instead of from archive in method Handle_Pdf_File___ (Bug#27507).
--  020312  ROOD  Replaced the raising of exception in Handle_Pdf_File___ with
--                writing error message to print job (Bug#27507).
--  020703  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030217  ROOD  Moved registration of events to a separate file (ToDo#4205).
--  030704  RAKU  Added print_job_owner attribute (ToDo#4276).
--  040227  ROOD  Replaced job_xx attributes with schedule_xx attributes (Bug#39376).
--  040304  DOZE  Added possibility to add printjob without a printer for print agent
--  040317  ROOD  Modified New and Unpack_Check_Update___ to handle both new and
--                old attribute names when renamed job_xx to schedule_xx (Bug#39376).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040513  MAOL  Merged fixes made by DOZE 040428 in 2004 track (Bug#44010)
--  041209  DOZE  Added functions for new remote states (F1PR463)
--  041216  DOZE  Job is set to printed when it's set to completed (Bug#48203)
--  050516  UTGULK  Extended archive,pdf,print job and event variables' length to 32000 
--                  in Handle_Pdf_File___.Added exception.(Bug#51164).
--  050516  UTGULK  Modified Handle_Pdf_File___ to loop for multiple reports(Bug#48789)
--  050623  NiWi  Modified Print(). Print queue has to be updated when reprinting waiting print jobs on a new printer(Bug#50892).
--  060208  UTGULK Modified Set_Complete to set the print flag for multiple reports.
--  060313  CHAA  Emailing Report Designer type reports
--  060506  UTGULK  Added methods Route_Print_Job,Get_Routing_Info. Modified Insert___,Set_Waiting (Bug#57822).
--  070510  UTGULK  Added method New_Print_Job (Bug#64894).
--  070705  SUMALK  Changed the Cleanup_ method for performance reasons.(Bug#65157).
--  080229  SUBSLK  Added new field to routing_information in Route_Print_Job <Bug#71003>
--  080514  SUBSLK  modified Handle_Pdf_File___() and Print() <Bug#73722>
--  080730  SUBSLK  Modified Handle_Pdf_File___() to send the attachment name in <report_title>_<resultKey>.pdf format(Bug#74489>
--  090319  SJayLK  Bug 76605, Implemented the "Email excel files" functionality.
--  090917  NABALK  Changed method Handle_Pdf_File___ to set the correct version for the excel file to be sent (Bug#85482) 
--  090923  ASIWLK  Modified Print(),Set_Waiting(),New_Print_Job() Changed the way routing info are handled.(Bug#80413)
--  100304  SUBSLK  Modified Handle_Pdf_File___() to add more PDF_PARAMETERS.
--                  Changed parameter value Unpack_Check_Update___.value_ and New.value_ to VARCHAR(4000) (BugID#88788)
--  100405  ASIWLK  Changed Handle_Pdf_File___(), updated to check the pdf_dir_ wildcard at last.
--  100907  HAMALK  Changed Handle_Pdf_File___(), Increased/Changed the length of the notes_ to 'ARCHIVE_TAB.notes%TYPE' to avoid buffer to small exception.
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation.
--  120417  VOHELK  EASTRTM-8617 - Changed email message for excel files
--  120720  CHAALK  Printed flag is not set when printing to logical printers (Bug#104031)
--  130809  NaBaLK  Issues in Fndbas language file releated to Reporting (Bug#111553)
--  140121  NaBaLK  Made changes to Set_Printer_Id to use PRINT_JOB_TAB (TEREPORT-1087)
--  140123  ASIWLK  Merged LCS-109673
--  140525  NaBaLK  Support for new pdf report event parameter defining functionality (TEREPORT-1150)
--  140525  CHAALK  Ability to change the attachment file name when emailing a report through PDF_REPORT_CREATED event (LCS Merge Bug# 116342)
--  150107  CHAALK  Restart option only enabled for WAITING print job (TEREPORT-1525)
--  150226  CHAALK  LCS Patch merge 121020
--  150617  CHAALK  Ability to query print jobs for print job status and created time through the Admin Lobby (BugID#123141)
--  160511  ASIWLK  Receive duplicate emails when emaling SSRSPlugin report (LCS-129134)
--  160617  NaBaLK  Merged from Apps9 (TEREPORT-2144)
--  170227  CHAALK  Patch Merge Bug ID 134113 Report Stream Notifications through events
--  181001  CHAALK  Making reply to user the print job user (BugID#144473)
--  181203  CHAALK  Add 5 more event parameters to the PDF_REPORT_CREATED event (BugID#145665)
--  011220  MABALK  Update Print Job record with Physical Printer Id
--  210109  MABALK  Reports are emailed when clicking "Preview" in Aurena (OR20R1-190)
--  210720  MABALK  Handle other report parameters combined with PDF Event Parameters for Aurena client. (Bug# 160238)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Print_Job_Id___ (
   print_job_id_ OUT NUMBER )
IS
BEGIN
   SELECT print_job_seq.nextval
      INTO print_job_id_
      FROM dual;
END Get_Print_Job_Id___;


PROCEDURE Set_Status___ (
   print_job_id_ IN NUMBER,
   status_       IN VARCHAR2,
   message_      IN VARCHAR2 DEFAULT NULL )
IS
   rec_ PRINT_JOB_TAB%ROWTYPE;
   tmp_ VARCHAR2(2000);
BEGIN
   rec_ := Lock_By_Keys___(print_job_id_);
   Print_Job_Status_API.Exist_Db( status_ );
   rec_.status := status_;
   IF message_ IS NOT NULL THEN
      rec_.message := substr(message_,1,2000);
   END IF;
   Update___(NULL, rec_, rec_, tmp_, tmp_, TRUE);
END Set_Status___;

PROCEDURE Set_Message___ (
   print_job_id_ IN NUMBER,
   message_      IN VARCHAR2 DEFAULT NULL )
IS
   rec_ PRINT_JOB_TAB%ROWTYPE;
   tmp_ VARCHAR2(2000);
BEGIN
   rec_ := Lock_By_Keys___(print_job_id_);
   IF rec_.message IS NOT NULL THEN
      rec_.message := substr(rec_.message || ' ' || message_,1,2000);
   ELSE
      rec_.message := substr( message_,1,2000);
   END IF;
   Update___(NULL, rec_, rec_, tmp_, tmp_, TRUE);
END Set_Message___;

-- Handle_Pdf_File___
--   Implementation method to take care of operations to be performed after a
--   pdf-file has been created by the archiving mechanisms, such as initiating
--   an event and sending the pdf-file attached in a mail if requested.
--   Returns errormessage if any error occured in the process.
FUNCTION Handle_Pdf_File___ (
   print_job_id_ IN NUMBER ) RETURN VARCHAR2
IS
   file_name_               VARCHAR2(200);
   attach_                  CLOB;
   report_title_            VARCHAR2(200);
   report_title_trans_      VARCHAR2(200);
   notes_                   ARCHIVE_TAB.notes%TYPE;
   language_code_           VARCHAR2(5);
   layout_name_             VARCHAR2(200);
   print_job_instance_attr_ VARCHAR2(32000);
   archive_instance_attr_   VARCHAR2(32000);
   archive_param_attr_      VARCHAR2(32000);
   archive_variable_attr_   VARCHAR2(32000);
   fnd_user_                VARCHAR2(30);
   event_msg_               VARCHAR2(32000);
   reply_to_user_           VARCHAR2(30);
   send_pdf_                BOOLEAN;
   send_pdf_to_             VARCHAR2(2000);
   subject_                 VARCHAR2(200);
   mail_text_               CLOB;
   rec_                     PRINT_JOB_TAB%ROWTYPE;
   result_key_              NUMBER;
   success_                 BOOLEAN := TRUE;
   event_enabled_           BOOLEAN := Event_SYS.Event_Enabled(lu_name_ ,'PDF_REPORT_CREATED');
   error_message_           VARCHAR2(2000);
   no_of_report_keys_       NUMBER := 0;
   report_key_              NUMBER := 0;
   owner_                   VARCHAR2(10);
   id_                      VARCHAR2(50);
   attachment_name_         VARCHAR2(250);
   ba_ext_                  VARCHAR2(10);
   archive_event_params_    VARCHAR2(4000);
   pdf_file_name_           VARCHAR2(250);
   preview_                 BOOLEAN:= FALSE;

BEGIN
   rec_ := Get_Object_By_Keys___(print_job_id_);

   preview_       := Message_SYS.Find_Attribute(rec_.settings, 'PREVIEW', 'FALSE') = 'TRUE';
   send_pdf_      := Message_SYS.Find_Attribute(rec_.settings, 'SEND_PDF', 'FALSE') = 'TRUE';

   -- Abort as soon as possible if no more processing is needed.
   IF preview_ OR (NOT event_enabled_ AND NOT send_pdf_) THEN
      RETURN NULL;
   END IF;

   fnd_user_      := rec_.user_name;
   no_of_report_keys_ := Print_Job_Contents_API.Get_No_Of_Result_Keys(print_job_id_);

   WHILE report_key_ < no_of_report_keys_ LOOP
      result_key_    := Print_Job_Contents_API.Get_Result_Key(print_job_id_,report_key_);
      Print_Job_Contents_API.Get_Instance_Attr(print_job_instance_attr_, print_job_id_, report_key_);
      report_key_  := report_key_ +1;
      layout_name_   := Client_SYS.Get_Item_Value('LAYOUT_NAME', print_job_instance_attr_);
      language_code_ := Client_SYS.Get_Item_Value('LANG_CODE', print_job_instance_attr_);
      report_title_  := Archive_API.Get_Report_Title(result_key_);
      report_title_trans_  := Archive_API.Get_Report_Title(result_key_,language_code_);
      notes_         := Archive_API.Get_Notes(result_key_);
      owner_ := Get_Print_Job_Owner_Db(print_job_id_);   
      IF (owner_ = 'AGENT') THEN
         IF report_title_trans_ IS NOT NULL THEN
              attachment_name_ := report_title_trans_||'_'||result_key_||'.pdf';
         END IF;
         id_ := Pdf_Archive_Api.Get_Id(result_key_,print_job_id_);
         IF id_ IS NOT NULL THEN
            file_name_ := '###'||id_||'###'||print_job_id_||'###'||result_key_||'###'||attachment_name_;
            attach_ := file_name_;
         ELSE
            success_ := FALSE; -- A pdf was not created. No pdf should be sent. Maybe "other" layout type was used.
         END IF;
      $IF Component_Biserv_SYS.INSTALLED $THEN   
      ELSIF (owner_ = 'EXCEL1.0') THEN
         event_enabled_ := FALSE;
         Archive_Api.Get_Report_Identity(id_, result_key_);
         IF report_title_ IS NOT NULL THEN
            IF(Excel_Report_Archive_API.Get_Stored_As_Pdf(id_, result_key_) = 1) THEN
               id_              := Pdf_Archive_Api.Get_Id(result_key_, NULL);
               ba_ext_          := '.pdf';
               attachment_name_ := report_title_||'_'||result_key_||ba_ext_;
               file_name_       := '$$$'||id_||'$$$'||' '||'$$$'||result_key_||'$$$'||attachment_name_;         
            ELSE
               ba_ext_          := NVL(Xlr_Template_Util_API.Get_Excel_File_Extension(id_),'.xls');               
               attachment_name_ := report_title_||'_'||result_key_||ba_ext_;
               file_name_       := '$$$'||id_||'$$$'||print_job_id_||'$$$'||result_key_||'$$$'||attachment_name_;         
            END IF;
         END IF;
         attach_ := file_name_;
      $END
      ELSIF file_name_ IS NULL THEN
         error_message_ := Language_SYS.Translate_Constant(lu_name_, 'PDF_FILE_NOT_FOUND: The pdf-file for result key :P1 and language :P2 could not be found. Check for possible language mismatch!', NULL, result_key_, language_code_);
         success_ := FALSE;
      END IF;
      -- Send the pdf-file in a mail directly if requested
      IF success_ AND send_pdf_  AND attach_ IS NOT NULL THEN
         Message_SYS.Get_Attribute(rec_.settings, 'SEND_PDF_TO', send_pdf_to_);
         IF send_pdf_to_ IS NULL THEN
            send_pdf_to_ := fnd_user_;
         ELSE
            -- Modify the interface to suit Command_SYS...
            send_pdf_to_ := REPLACE(send_pdf_to_, ';', ',');
         END IF;
         reply_to_user_ := fnd_user_;
         IF (owner_ = 'EXCEL1.0') THEN
            IF(ba_ext_ = '.pdf') THEN
               subject_   := Language_SYS.Translate_Constant(lu_name_, 'PDF_MAIL_SUBJECT: PDF-file for report is ready', language_code_);
               mail_text_ := Language_SYS.Translate_Constant(lu_name_, 'PDF_MAIL_TEXT: The archived PDF-file for report :P1 is ready and is attached in this mail. ', language_code_, report_title_);            
            ELSE              
               subject_   := Language_SYS.Translate_Constant(lu_name_, 'EXCEL_MAIL_SUBJECT: Excel-file for report is ready', language_code_);
               mail_text_ := Language_SYS.Translate_Constant(lu_name_, 'EXCEL_MAIL_TEXT: The Excel-file for report :P1 is ready and is attached in this mail. Save the attached file in a trusted location before opening it.', language_code_, report_title_);
            END IF;
            Command_SYS.Mail('IFS Applications', reply_to_user_, send_pdf_to_, NULL, NULL, subject_, mail_text_, attach_);
         END IF;
      END IF;
      -- Execute the event
      IF success_ AND event_enabled_ THEN
         event_msg_ := Message_SYS.Construct('PDF_REPORT_CREATED');
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
         pdf_file_name_ := NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_FILE_NAME',''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_FILE_NAME', ''));
         IF pdf_file_name_ IS NOT NULL THEN
            attach_ := REPLACE(attach_,attachment_name_,pdf_file_name_||'.pdf');
            Message_SYS.Add_Attribute(event_msg_, 'PDF_FILE_NAME', pdf_file_name_||'.pdf');
         ELSE
            Message_SYS.Add_Attribute(event_msg_, 'PDF_FILE_NAME', attachment_name_);
         END IF;
         Message_SYS.Add_Clob_Attribute(event_msg_, 'PDF_FILE', attach_);
         Message_SYS.Add_Attribute(event_msg_, 'REPORT_TITLE', report_title_);
         Message_SYS.Add_Attribute(event_msg_, 'REPORT_TITLE_TRANS', report_title_trans_);
         Message_SYS.Add_Attribute(event_msg_, 'PRINT_JOB_ID', print_job_id_);
         Message_SYS.Add_Attribute(event_msg_, 'STATUS', Get_Status_Db(print_job_id_));
         Message_SYS.Add_Attribute(event_msg_, 'PRINTER_ID',substr(Get_Printer_Id(print_job_id_), instr(Get_Printer_Id(print_job_id_), ',',1,2)+1));
         Message_SYS.Add_Attribute(event_msg_, 'REPORT_ID', Client_SYS.Get_Item_Value('REPORT_ID', archive_instance_attr_));
         Message_SYS.Add_Attribute(event_msg_, 'LAYOUT_NAME', layout_name_);
         Message_SYS.Add_Attribute(event_msg_, 'LANGUAGE_CODE', language_code_);
         Message_SYS.Add_Attribute(event_msg_, 'NOTES', notes_);
         Message_SYS.Add_Attribute(event_msg_, 'REPORT_PARAMETERS', archive_param_attr_);
         Message_SYS.Add_Attribute(event_msg_, 'REPORT_VARIABLES', archive_variable_attr_);
         -- These parameters should always be available in the event even though no automatic mail has been sent yet.
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_1', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_1', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_1', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_2', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_2', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_2', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_3', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_3', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_3', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_4', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_4', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_4', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_5', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_5', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_5', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_6', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_6', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_6', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_7', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_7', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_7', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_8', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_8', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_8', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_9', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_9', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_9', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_10', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_10', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_10', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_11', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_11', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_11', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_12', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_12', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_12', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_13', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_13', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_13', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_14', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_14', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_14', '')));
         Message_SYS.Add_Attribute(event_msg_, 'PDF_PARAMETER_15', NVL(Message_SYS.Find_Attribute(rec_.settings, 'PDF_EVENT_PARAM_15', ''), Message_SYS.Find_Attribute(archive_event_params_, 'PDF_EVENT_PARAM_15', '')));
         Message_SYS.Add_Attribute(event_msg_, 'REPLY_TO_USER', NVL(Message_SYS.Find_Attribute(rec_.settings, 'REPLY_TO_USER', ''), Message_SYS.Find_Attribute(archive_event_params_, 'REPLY_TO_USER', '')));         
         -- These parameters will only be available in the event if an automatic email has been sent
         Message_SYS.Add_Attribute(event_msg_, 'PDF_FILE_SENT_TO', send_pdf_to_);
         Message_SYS.Add_Attribute(event_msg_, 'MAIL_SUBJECT', subject_);
         Message_SYS.Add_Clob_Attribute(event_msg_, 'MAIL_TEXT', mail_text_);

         Event_SYS.Event_Execute(lu_name_, 'PDF_REPORT_CREATED', event_msg_ );
      END IF;
   END LOOP;
   IF success_ THEN
      RETURN NULL;
   ELSE
      RETURN error_message_;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      error_message_ := SQLERRM;
      RETURN error_message_ ;
END Handle_Pdf_File___;

PROCEDURE Set_Printed___ (
   print_job_id_ IN NUMBER)
IS
   printer_           VARCHAR2(250);
   result_key_        NUMBER;
   report_key_        NUMBER := 0;
   no_of_report_keys_ NUMBER := 0;
BEGIN
   printer_ := Get_Printer_Id(print_job_id_);
   IF (printer_ IS NOT NULL) THEN
      no_of_report_keys_ := Print_Job_Contents_API.Get_No_Of_Result_Keys(print_job_id_);
      WHILE report_key_ < no_of_report_keys_ LOOP
         result_key_    := Print_Job_Contents_API.Get_Result_Key(print_job_id_,report_key_);
         report_key_  := report_key_ +1;
         Print_Job_Contents_API.Set_Printed(print_job_id_, result_key_);
      END LOOP;
   END IF;
END Set_Printed___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT print_job_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Get_Print_Job_Id___(newrec_.print_job_id);
   newrec_.created_time := SYSDATE;   
   newrec_.expire_date := SYSDATE;
   newrec_.user_name := Fnd_Session_API.Get_Fnd_User;
   newrec_.status := 'INACTIVE';
   newrec_.print_job_owner := 'UNDEFINED';
   super(newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', newrec_.print_job_id, attr_);
   Client_SYS.Add_To_Attr('CREATED_TIME', sysdate, attr_);   
   Client_SYS.Add_To_Attr('EXPIRE_DATE', sysdate, attr_);
   Client_SYS.Add_To_Attr('USER_NAME', newrec_.user_name, attr_);
   Client_SYS.Add_To_Attr('STATUS', newrec_.status, attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_OWNER', newrec_.print_job_owner, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     print_job_tab%ROWTYPE,
   newrec_ IN OUT print_job_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF Client_SYS.Item_Exist('JOB_ID', attr_) THEN
      Error_SYS.Item_Update(lu_name_, 'JOB_ID');
   END IF;
   IF Client_SYS.Item_Exist('JOB_NAME', attr_) THEN
      Error_SYS.Item_Update(lu_name_, 'JOB_NAME');
   END IF;
   IF Client_SYS.Item_Exist('JOB_SEQ', attr_) THEN
      Error_SYS.Item_Update(lu_name_, 'JOB_SEQ');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
   life_         NUMBER;

   CURSOR get_all_old IS
      SELECT print_job_id
      FROM   print_job_tab
      WHERE  expire_date < sysdate - life_
      AND    status IN ('COMPLETE','INACTIVE');
  
  TYPE print_job_type IS TABLE OF print_job_tab.print_job_id%TYPE;
  print_job_id_  print_job_type;

BEGIN
   life_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('KEEP_PRINTJOBS'));
   OPEN get_all_old;
   LOOP
   FETCH get_all_old BULK COLLECT INTO print_job_id_ LIMIT 1000;
      FORALL i_ IN 1..print_job_id_.count
         DELETE FROM print_job_tab
            WHERE print_job_id = print_job_id_(i_);
      FORALL i_ IN 1..print_job_id_.count
         DELETE print_queue_tab 
            WHERE print_job_id = print_job_id_(i_);
      FORALL i_ IN 1..print_job_id_.count
         DELETE FROM print_job_contents_tab
            WHERE print_job_id = print_job_id_(i_);
@ApproveTransactionStatement(2013-11-14,mabose)
      COMMIT;
      EXIT WHEN get_all_old%NOTFOUND;
   END LOOP;     
   CLOSE get_all_old;
   Report_Message_Processing_API.Cleanup__;
END Cleanup__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Routing_Info (
   print_job_id_ IN NUMBER ) RETURN CLOB
IS
   temp_ PRINT_JOB_TAB.routing_info%TYPE;
   CURSOR get_attr IS
      SELECT routing_info
      FROM   PRINT_JOB_TAB
      WHERE  print_job_id = print_job_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Routing_Info;


@UncheckedAccess
FUNCTION Get_Job_Name (
   print_job_id_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Schedule_Name(print_job_id_);
END Get_Job_Name;


@UncheckedAccess
FUNCTION Get_Job_Id (
   print_job_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Schedule_Id(print_job_id_);
END Get_Job_Id;


@UncheckedAccess
FUNCTION Get_Job_Seq (
   print_job_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Schedule_Executions(print_job_id_);
END Get_Job_Seq;


PROCEDURE Set_Printer_Id(
   print_job_id_ IN NUMBER,
   printer_id_ IN VARCHAR2)
IS
   inside_         BOOLEAN := FALSE;
   newrec_         PRINT_JOB_TAB%ROWTYPE;
   oldrec_         PRINT_JOB_TAB%ROWTYPE;
   tmp_            VARCHAR2(2000);
   desc_           VARCHAR2(50);
   new_printer_id_ VARCHAR2(250);
   objid_          PRINT_JOB.objid%TYPE;
   objversion_     PRINT_JOB.objversion%TYPE;

   CURSOR get_printer IS
      SELECT printer_id
      FROM PRINT_JOB_TAB
      WHERE print_job_id = print_job_id_;
BEGIN
   FOR rec_ IN get_printer LOOP
      inside_ := TRUE;
      Get_Id_Version_By_Keys___(objid_, objversion_, print_job_id_);
      newrec_ := Lock_By_Id___(objid_, objversion_);
      oldrec_ := newrec_;
      IF (Logical_Printer_API.Exists(printer_id_)) THEN      
         desc_ := Logical_Printer_API.Get_Description(printer_id_);
         new_printer_id_ := desc_ || ',SERVER,' || printer_id_;
      ELSIF (printer_id_ IS NOT NULL) THEN
         new_printer_id_ := printer_id_;
      ELSE
         new_printer_id_ := '';         
      END IF;
      newrec_.printer_id := new_printer_id_;
      Update___(NULL, oldrec_, newrec_, tmp_, tmp_, TRUE);
      IF (Print_Queue_API.Check_Exist(print_job_id_)) THEN
         UPDATE print_queue_tab
            SET perform_printer_id = new_printer_id_,
                rowversion = 1
            WHERE print_job_id = print_job_id_;
      END IF;
   END LOOP;
   IF (NOT inside_) THEN
      Error_SYS.Appl_General(lu_name_, 'COULD_NOT_UPDATE_PRINTJOB: Printjob #:P1', print_job_id_);
   END IF;
END Set_Printer_Id;


PROCEDURE Set_Settings(
   print_job_id_ IN NUMBER,
   settings_ IN VARCHAR2)
IS
   newrec_ PRINT_JOB_TAB%ROWTYPE;
   oldrec_ PRINT_JOB_TAB%ROWTYPE;
   tmp_    VARCHAR2(2000);
   CURSOR get_settings IS
      SELECT objid, objversion
        FROM PRINT_JOB
       WHERE print_job_id = print_job_id_;
BEGIN
   FOR rec_ IN get_settings LOOP
      newrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
      oldrec_ := newrec_;
      newrec_.settings := settings_;
      Update___(NULL, oldrec_, newrec_, tmp_, tmp_, TRUE);
   END LOOP;
END Set_Settings;


PROCEDURE New (
   print_job_id_ OUT NUMBER,
   attr_         IN  VARCHAR2 )
IS
   rec_        PRINT_JOB_TAB%ROWTYPE;
   new_attr_   VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   -- for repacking attribute string
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(4000);
   indrec_     Indicator_Rec;
BEGIN
   -- Some attributes have been renamed, so the old names should also be handled
   -- to guarantee backward compatibility...
   -- JOB_ID   -> SCHEDULE_ID
   -- JOB_NAME -> SCHEDULE_NAME
   -- JOB_SEQ  -> SCHEDULE_EXECUTIONS
   -- Repack the attribute string if necessary
   IF Client_SYS.Item_Exist('JOB_ID', attr_) OR
      Client_SYS.Item_Exist('JOB_NAME', attr_) OR
      Client_SYS.Item_Exist('JOB_SEQ', attr_) THEN
      WHILE Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) LOOP
         IF name_ = 'JOB_ID' THEN
            name_ := 'SCHEDULE_ID';
         ELSIF name_ = 'JOB_NAME' THEN
            name_ := 'SCHEDULE_NAME';
         ELSIF name_ = 'JOB_SEQ' THEN
            name_ := 'SCHEDULE_EXECUTIONS';
         END IF;
         -- Create the new attribute string
         Client_SYS.Add_To_Attr(name_, value_, new_attr_);
      END LOOP;
   ELSE
      -- IF only new attributes exist, simple copy the attribute string.
      new_attr_ := attr_;
   END IF;   
   Unpack___(rec_, indrec_, new_attr_);
   Check_Insert___(rec_, indrec_, new_attr_);   
   Insert___(objid_, objversion_, rec_, new_attr_);
   print_job_id_ := rec_.print_job_id;
END New;


PROCEDURE New_Print_Job (
   print_job_ids_     OUT VARCHAR2,
   job_attr_          IN  VARCHAR2,
   job_contents_attr_ IN  VARCHAR2,
   archive_           IN  VARCHAR2 DEFAULT 'TRUE' )
IS
   new_contents_attr_ VARCHAR2(2000);
   print_job_id_      NUMBER;  
   temp_pjattr_       VARCHAR2(2000);
BEGIN
   New(print_job_id_, job_attr_);
   IF print_job_id_ IS NOT NULL THEN
     print_job_ids_ := print_job_id_; 
     new_contents_attr_ := job_contents_attr_;
     Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, temp_pjattr_);
     new_contents_attr_:=temp_pjattr_||new_contents_attr_;
     Print_Job_Contents_API.New_Instance(new_contents_attr_);
   END IF;
END New_Print_Job;


PROCEDURE Modify_Job (
   print_job_id_ IN  NUMBER,
   attr_         IN  VARCHAR2 )
IS
   oldrec_     PRINT_JOB_TAB%ROWTYPE;
   newrec_     PRINT_JOB_TAB%ROWTYPE;
   new_attr_   VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(print_job_id_);
   newrec_ := oldrec_;
   new_attr_ := attr_;   
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, new_attr_);
   Update___(NULL, oldrec_, newrec_, new_attr_, objversion_, TRUE);
END Modify_Job;


PROCEDURE Remove (
   print_job_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM print_job_tab
      WHERE print_job_id = print_job_id_;
   Print_Queue_API.Remove_Job(print_job_id_);
   Print_Job_Contents_API.Remove_Print_Job_Instances(print_job_id_);
END Remove;


PROCEDURE Set_Inactive (
   print_job_id_ IN NUMBER )
IS
BEGIN
   Set_Status___(print_job_id_, 'INACTIVE');
END Set_Inactive;


PROCEDURE Set_Waiting (
   print_job_id_ IN NUMBER )
IS
BEGIN
   IF (Get_Status(print_job_id_) = Print_Job_Status_API.Decode('ERROR')) THEN
      Set_Message(print_job_id_);
   END IF;
   Set_Status___(print_job_id_, 'WAITING');
END Set_Waiting;


PROCEDURE Set_Error (
   print_job_id_ IN NUMBER,
   error_msg_    IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Set_Status___(print_job_id_, 'ERROR', error_msg_);
END Set_Error;


PROCEDURE Set_Working (
   print_job_id_ IN NUMBER )
IS
BEGIN
   Set_Status___(print_job_id_, 'WORKING');
END Set_Working;


PROCEDURE Set_Remote_Working (
   print_job_id_ IN NUMBER )
IS
BEGIN
   Set_Status___(print_job_id_, 'REMOTE WORKING');
END Set_Remote_Working;


PROCEDURE Set_Remote_Waiting (
   print_job_id_ IN NUMBER )
IS
BEGIN
   Set_Status___(print_job_id_, 'REMOTE WAITING');
   DBMS_Alert.Signal('PRINT_AGENT_ALERT',TO_CHAR(print_job_id_));
END Set_Remote_Waiting;


PROCEDURE Set_Abort (
   print_job_id_ IN NUMBER )
IS
BEGIN
   Set_Status___(print_job_id_, 'ABORT');
END Set_Abort;


PROCEDURE Print (
   print_job_id_ IN NUMBER )
IS
   rec_ Public_Rec;
   attr_ VARCHAR2(32000);
   owner_ VARCHAR2(50);
   layout_name_ VARCHAR2(2000);
   archive_instance_attr_  VARCHAR2(32000);
   archive_parameter_attr_ VARCHAR2(32000);
   report_id_              VARCHAR2(30);
   result_key_             NUMBER;
   report_mode_            REPORT_SYS_TAB.report_mode%TYPE;

   routing_info_      PRINT_JOB_TAB.Routing_Info%TYPE;
   logical_printer_     VARCHAR2(200) :=NULL;
   i_                 NUMBER;
   tmp_print_job_      PRINT_JOB_TAB.print_job_id%type;
   newjob_instance_attr_   VARCHAR2(32000);
   newjob_attr_            VARCHAR2(32000);
   archive_           VARCHAR2(5) DEFAULT 'TRUE';
   omit_print_job_    BOOLEAN DEFAULT FALSE;
   
   rec_copy_           PRINT_JOB_TAB%ROWTYPE;
   temp_npjattr_       VARCHAR2(2000);
   xml_data_str_       VARCHAR2(3000);
   xml_object_          SYS.Xmltype;
BEGIN
   Exist(print_job_id_);
   Print_Job_Contents_API.Check_Empty(print_job_id_);
   rec_ := Get(print_job_id_);
   Print_Job_Contents_API.Get_Instance_Attr(attr_, print_job_id_, 0);
   rec_copy_ := Get_Object_By_Keys___(print_job_id_);
   Client_SYS.Add_To_Attr('PRINTER_ID', rec_copy_.printer_id, newjob_attr_);
   Client_SYS.Add_To_Attr('SETTINGS', rec_copy_.settings, newjob_attr_);
   Client_SYS.Add_To_Attr('USER_NAME', rec_copy_.user_name, newjob_attr_);
   newjob_instance_attr_ := attr_;
   layout_name_ := Client_SYS.Get_Item_Value('LAYOUT_NAME', attr_);
   IF (layout_name_ IS NOT NULL) THEN
      result_key_    := Print_Job_Contents_API.Get_Result_Key(print_job_id_,0);
      Archive_API.Get_Info(archive_instance_attr_, archive_parameter_attr_, result_key_);
      report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', archive_instance_attr_);
      report_mode_ := Report_Definition_API.Get_Report_Mode(report_id_);
      IF report_mode_ = 'EXCEL1.0' THEN
         owner_ := 'EXCEL1.0';
      ELSE
         owner_ := Report_Layout_Type_Config_API.Get_Layout_Type_Owner_Db(Report_Layout_Definition_API.Get_Layout_Type(report_id_, layout_name_));
      END IF;
      IF (rec_.print_job_owner != owner_) THEN
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('PRINT_JOB_OWNER_DB', owner_, attr_);
         Modify_Job(print_job_id_, attr_);
         rec_.print_job_owner:=owner_;
      END IF;
   END IF;
   IF (rec_.printer_id IS NOT NULL OR rec_.print_job_owner='AGENT') THEN
      IF (rec_.status IN ('INACTIVE', 'ERROR', 'COMPLETE', 'ABORT', 'WAITING')) THEN
         Route_Print_Job(print_job_id_);
         routing_info_ := Get_Routing_Info(print_job_id_);   -- Get routing info from print_job_tab
         IF (  dbms_lob.getlength(routing_info_)  > 0 ) THEN
            BEGIN
               xml_object_:=sys.xmltype.createXML(routing_info_);
               IF ( xml_object_.existsNode('/REPORT_ROUTING/OMIT_PRINTOUT_TO_JOB_PRINTER') = 1 ) THEN 
                  IF( xml_object_.extract('/REPORT_ROUTING/OMIT_PRINTOUT_TO_JOB_PRINTER/text()') IS NOT NULL ) THEN
                     xml_data_str_ := xml_object_.extract('/REPORT_ROUTING/OMIT_PRINTOUT_TO_JOB_PRINTER/text()').getStringval() ;
                     IF (xml_data_str_ = 'TRUE') THEN
                        omit_print_job_ := TRUE;
                     END IF;
                  END IF;   
               END IF;
               IF ( xml_object_.existsNode('/REPORT_ROUTING/DESTINATION[CHANNEL="PRINTER"]') = 1 ) THEN
                  i_ :=0;
                  LOOP
                     i_ :=i_+1;
                     xml_data_str_ := xml_object_.extract('/REPORT_ROUTING/DESTINATION['||i_||']/CHANNEL/text()').getStringval() ;
                     IF ( xml_data_str_ = 'PRINTER') THEN
                        IF( xml_object_.extract('/REPORT_ROUTING/DESTINATION['||i_||']/ADDRESS/text()') IS NOT NULL ) THEN
                           xml_data_str_ := xml_object_.extract('/REPORT_ROUTING/DESTINATION['||i_||']/ADDRESS/text()').getStringval() ;
                           logical_printer_ := xml_data_str_||',SERVER,'||xml_data_str_;
                           EXIT;
                        ELSE
                           EXIT; 
                        END IF;
                     END IF;
                  END LOOP;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
               NULL;
            END;
            IF ( logical_printer_ IS NOT NULL ) THEN
               IF  rec_copy_.printer_id != logical_printer_ THEN
                  Client_SYS.Clear_Attr(attr_);                                              
                  Client_SYS.Add_To_Attr('PRINTER_ID', logical_printer_,attr_); 
                  Modify_Job(print_job_id_,attr_);                          -- Modify old print job according to routing xml LP    
               END IF;
               IF omit_print_job_ != TRUE THEN 
                  Client_SYS.Add_To_Attr('RESULT_KEY', result_key_,temp_npjattr_);
                  newjob_instance_attr_:=temp_npjattr_||newjob_instance_attr_;  
                  New_Print_Job(  tmp_print_job_ , newjob_attr_ ,newjob_instance_attr_  , archive_  ); -- put the old  print job as new job 
                  Exist(tmp_print_job_); 
                  Print_Job_Contents_API.Check_Empty(tmp_print_job_);
                  Set_Waiting(tmp_print_job_);                      -- the the new job to waiting   
                  Print_Queue_API.Print_Job(tmp_print_job_);
              END IF ;
            END IF;
         END IF;
         Set_Waiting(print_job_id_);
         Print_Queue_API.Print_Job(print_job_id_);
      END IF;
   END IF;
   -- Note: For Excel Reports, the report has been printed already.
   IF ( report_mode_ = 'EXCEL1.0' ) THEN
      Set_Complete(print_job_id_);
   END IF;
END Print;


@UncheckedAccess
PROCEDURE Get_Job_Attr (
   attr_         OUT VARCHAR2,
   print_job_id_ IN  NUMBER )
IS
   rec_      PRINT_JOB_TAB%ROWTYPE;
   new_attr_ VARCHAR2(32000);
BEGIN
   rec_ := Get_Object_By_Keys___(print_job_id_);
   Client_SYS.Add_To_Attr('PRINTER_ID', rec_.printer_id, new_attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', rec_.print_job_id, new_attr_);
   Client_SYS.Add_To_Attr('SETTINGS', rec_.settings, new_attr_);
   Client_SYS.Add_To_Attr('USER_NAME', rec_.user_name, new_attr_);
   attr_ := new_attr_;
END Get_Job_Attr;


PROCEDURE Set_Complete (
   print_job_id_ IN NUMBER )
IS
   error_message_ VARCHAR2(2000);
   stream_         fnd_stream_tab%ROWTYPE;
BEGIN
   IF (Logical_Printer_API.Is_Pdf_Printer_(Get_Printer_Id(print_job_id_)) = 'TRUE') THEN
      -- Handle the creation of an event and the sending of the pdf file to mail recipient(s).
      error_message_ := Handle_Pdf_File___(print_job_id_);
      IF error_message_ IS NULL THEN
        -- Remove this print job after the file is created if no errors
         Remove(print_job_id_);
      ELSE
         -- Set the print job to error if something is wrong with the handling of the pdf-file.
         Set_Error(print_job_id_, error_message_);
         stream_.message := Language_SYS.Translate_Constant(lu_name_,'PRINTJOBERR: Print Job :P1 has errors. Reported error is :P2', NULL,print_job_id_,error_message_);
      END IF;
   ELSIF ((Get_Print_Job_Owner_Db(print_job_id_) = 'AGENT')) THEN --AND (Message_SYS.Find_Attribute(Get_Object_By_Keys___(print_job_id_).settings, 'SEND_PDF', 'FALSE')= 'TRUE')) THEN  
      -- Handle the creation of an event and the sending of the pdf file to mail recipient(s).
      error_message_ := Handle_Pdf_File___(print_job_id_);
      IF error_message_ IS NULL THEN
         Set_Status___(print_job_id_, 'COMPLETE');
         Set_Printed___(print_job_id_);
         stream_.message := Language_SYS.Translate_Constant(lu_name_,'PRINTREADY: Print Job :P1 is ready.', NULL, print_job_id_);
      ELSE
         -- Set the print job to error if something is wrong with the handling of the pdf-file.
         Set_Error(print_job_id_, error_message_);
         stream_.message := Language_SYS.Translate_Constant(lu_name_,'PRINTJOBERR: Print Job :P1 has errors. Reported error is :P2', NULL,print_job_id_,error_message_);
      END IF;
   ELSIF ((Get_Print_Job_Owner_Db(print_job_id_) = 'EXCEL1.0') AND (Message_SYS.Find_Attribute(Get_Object_By_Keys___(print_job_id_).settings, 'SEND_PDF', 'FALSE')= 'TRUE')) THEN
      -- Handle the creation of an event and the sending of the excel file to mail recipient(s).
      error_message_ := Handle_Pdf_File___(print_job_id_);
      IF error_message_ IS NULL THEN
         Set_Status___(print_job_id_, 'COMPLETE');
         stream_.message := Language_SYS.Translate_Constant(lu_name_,'PRINTREADY: Print Job :P1 is ready.', NULL, print_job_id_);
      ELSE
         -- Set the print job to error if something is wrong with the handling of the excel-file.
         Set_Error(print_job_id_, error_message_);
         stream_.message := Language_SYS.Translate_Constant(lu_name_,'PRINTJOBERR: Print Job :P1 has errors. Reported error is :P2', NULL,print_job_id_,error_message_);
      END IF;
   ELSE
      Set_Status___(print_job_id_, 'COMPLETE');
      Set_Printed___(print_job_id_);
      stream_.message := Language_SYS.Translate_Constant(lu_name_,'PRINTREADY: Print Job :P1 is ready.', NULL, print_job_id_);
   END IF;
   
   BEGIN
      IF (stream_.message IS NOT NULL) THEN
         stream_.message_id := NULL;
         stream_.header := 'Print Job: ' || print_job_id_;
         stream_.stream_type := Fnd_Stream_Type_API.DB_NOTIFICATION;
         stream_.to_user := Fnd_Session_API.Get_Fnd_User();
         stream_.lu_name := lu_name_;
         stream_.from_user := Fnd_Session_API.Get_Fnd_User();
         stream_.visible := 'TRUE';
         stream_.read := 'FALSE';
         Fnd_Stream_API.New_Stream_Item(stream_);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
      Set_Message___(print_job_id_ , SQLERRM );
   END;
    
END Set_Complete;


PROCEDURE Archivate (
   print_job_id_ OUT NUMBER,
   result_key_   IN  NUMBER )
IS
   new_attr_     VARCHAR2(2000);
   content_attr_ VARCHAR2(2000);
   tmp_job_id_   NUMBER;
BEGIN
   Archive_API.Exist(result_key_);
   Client_SYS.Add_To_Attr('PRINTER_ID', LOGICAL_PRINTER_API.Get_Pdf_Printer, new_attr_);
   New(tmp_job_id_, new_attr_);
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', tmp_job_id_, content_attr_);
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, content_attr_);
   Print_Job_Contents_API.New_Instance(content_attr_);
   Print(tmp_job_id_);
   print_job_id_ := tmp_job_id_;
END Archivate;


PROCEDURE Route_Print_Job (
   print_job_id_ IN NUMBER )
IS
--   objid_        VARCHAR2(2000);
--   objversion_   VARCHAR2(2000);
--   route_info_ clob;
BEGIN

   --Create the routing information in the format given below.
/*
   route_info_ := '<REPORT_ROUTING>
  <DESTINATION>
    <CHANNEL>PRINTER</CHANNEL>
    <ADDRESS>Logical Printer Name</ADDRESS>
    <OPTIONS>
      <TRAY_FIRST>1</TRAY_FIRST>
      <TRAY_LAST>2</TRAY_LAST>
      <TRAY_REST>3</TRAY_REST>
    </OPTIONS>
  </DESTINATION>
  <DESTINATION>
    <CHANNEL>EMAIL</CHANNEL>
    <ADDRESS>martin.olsson@ifsworld.com</ADDRESS>
    <OPTIONS>
      <MAIL_SUBJECT>Order Confirmation from Bertel O.
                    Steen</MAIL_SUBJECT>
      <MAIL_BODY>Dear Mr Olsson,

                 Attached you''ll find the order confirmation of that
                 Ferrari of yours. Don''t hesitate to contact us if you
                 have any questions or inquiries.
                   
                 Thank you and we hope to see you soon</MAIL_BODY>
      <ATTACHMENT_NAME>OrderConfirmation_64378.pdf</ATTACHMENT_NAME>
      <SEND_FROM>methika.sapukotana@ifs.lk</SEND_FROM>
      <SEND_CC_TO>muhammed.naseer@ifs.lk;
                  chanaka.amarasekara@ifs.lk</SEND_CC_TO>
      <SEND_BCC_TO>methika.sapukotana@ifs.lk</SEND_BCC_TO>
    </OPTIONS>
  </DESTINATION>
  <DESTINATION>
    <CHANNEL>OTHER</CHANNEL>
    <ADDRESS>SMS</ADDRESS>
    <CONNECTOR_INSTANCE>SMS_SENDER1</CONNECTOR_INSTANCE>
    <OPTIONS>
      <PHONE_NUMBER>Order Confirmation from Bertel O.
                    Steen</PHONE_NUMBER>
      <MESSAGE>Dear Mr Olsson,

               This is and order confirmation of that Ferrari of yours.
               Don''t hesitate to contact us if you have any questions or
               inquiries.

               Thank you and we hope to see you soon</MESSAGE>
    </OPTIONS>
  </DESTINATION>
</REPORT_ROUTING> ' ;  

   Get_Id_Version_By_Keys___(objid_, objversion_, print_job_id_);
   Write_Routing_Info__(objversion_, objid_, route_info_);
*/ 

   NULL;
END Route_Print_Job;


PROCEDURE Set_Message (
   print_job_id_ IN NUMBER,
   message_      IN VARCHAR2 DEFAULT NULL )
IS
   newrec_ PRINT_JOB_TAB%ROWTYPE;
   oldrec_ PRINT_JOB_TAB%ROWTYPE;
   tmp_    VARCHAR2(2000);
BEGIN
   newrec_ := Lock_By_Keys___(print_job_id_);
   oldrec_ := newrec_;
   newrec_.message := substr(message_,1,2000);
   Update___(NULL, oldrec_, newrec_, tmp_, tmp_, TRUE);
END Set_Message;


PROCEDURE Set_Routing_Info (
   print_job_id_ IN NUMBER,
   routing_info_    IN VARCHAR2 )
IS
   newrec_ PRINT_JOB_TAB%ROWTYPE;
   route_info_ PRINT_JOB_TAB.routing_info%TYPE;
BEGIN
   newrec_ := Lock_By_Keys___(print_job_id_);
   route_info_ := routing_info_;
   UPDATE  print_job_tab
   SET routing_info = route_info_
   WHERE print_job_id = print_job_id_;
END Set_Routing_Info;

PROCEDURE Update_Printjob_Setting (
   print_job_id_ IN NUMBER,
   name_ IN VARCHAR2,
   value_ IN VARCHAR2)
IS
   rec_  PRINT_JOB_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(print_job_id_);
   Message_SYS.Set_Attribute(rec_.settings, name_, value_);
   Set_Settings(print_job_id_,rec_.settings);
END Update_Printjob_Setting;

PROCEDURE Restart (
   print_job_id_ IN NUMBER )
IS
   result_key_    NUMBER;
BEGIN
   result_key_    := Print_Job_Contents_API.Get_Result_Key(print_job_id_,0);
   
   IF(Pdf_Archive_API.Get_Id(result_key_, print_job_id_)IS NOT NULL) THEN
      IF(Print_Queue_API.Is_Remote(print_job_id_) = 'TRUE' )THEN
         Set_Remote_Waiting(print_job_id_);
      END IF;
   END IF;
   
   Print(print_job_id_);
   
END Restart;
