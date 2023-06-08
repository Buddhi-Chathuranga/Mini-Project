-----------------------------------------------------------------------------
--
--  Logical unit: Archive
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960403  MANY  Recreated for Info Services 1.2, almost complete new.
--  960426  MANY  Joined file with second file (arc2.api)
--  960520  MANY  Added missing column rowversion in some INSERT-statements.
--  960626  MANY  Added method Get_Report_Identity().
--  960808  MANY  Fixed bug with cleanup of archive in method
--                Archive2_API.Remove_User_Instance___() and added method
--                Cleanup__()
--  960919  MANY  Added method Attach_Report() to allow for log-file reports.
--  960930  MANY  Added columns LANG_CODE and PRINTED.
--                Added method Set_Language(), used from within report methods
--                when setting default printing language
--                Added method Get_Info(), cleaner interface than
--                Get_Report_Info().
--  961022  MANY  Added column NOTES
--                Added method Set_Notes() and Get_Notes__()
--  961030  MANY  Added method Create_Print_Job()
--  961111  MANY  Added method New_Instance(), create one instance of a report
--                and distribute to current user.
--  961212  MANY  Added method Connect_Instance()
--  970806  MANY  Chenges concerning new user concept FndUser
--  970815  MANY  Chenges in view, now uses method
--                Report_Definition_API.Get_Translated_Report_Title to get report_title
--                changes due to changed functionality in package Report_Definition_API.
--  970820  MANY  Implemented restricted delete on archive.
--  970930  MANY  Fixed Oracle compatability problem with method Cleanup__(),
--                induced by referencing records in FOR cursors
--  971001  MANY  Fixed problem with missing field job_name (comment). Bug #1681
--  971212  MANY  Implemented LU ArchiveVariable and get-method Get_Instance_Info().
--  980121  MANY  Fixed bug #2024, Archive Cleaned even when Expire Date has not expired.
--  980206  MANY  Fixed problem with Oracle 8, illegal semantics. Bug #2096
--  980727  MANY  Optimized SQL-statement in view (Bug #2578)
--  980827  MANY  Added cleanup for ArchiveParameter.
--  980907  MANY  Fixed bug in Cleanup__ (Bug #2679)
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  981108  MANY  Added configuration check for pdf-web solution in method Get_Pdf_Info (ToDo #2798)
--  990118  MANY  Optimized SQL-statement in view caused by avery bad previous fix (Bug #3082)
--  990222  ERFO  Yoshimura: Changes in Get_Report_Identity, Get_Report_Info
--                           and method Check_Exist___ (ToDo #3160).
--  990320  ERFO  Changes in Get_Report_Title (Bug #3236).
--  990322  DOZE  Rewritten to new templates (ToDo #3198).
--  990324  ERFO  Changed view definition according to performance (Bug #3236).
--  990922  ERFO  Solved problems in Get- (Exec_Time/Arrival_Time/Printed) (Bug #3589).
--  000818  ROOD  Added call to Archive_Variable_API.Clear in Remove_User_Instance___ (Bug#16130).
--  020217  ROOD  Modifications to choose the default layout if none is selected (ToDo#4056).
--  020217  ROOD  Removed PKG2, merged everything into one package (ToDo#4056).
--  020308  ROOD  Modified method Create_New_Report__ to always set layout and language code
--                to default values if not stated in attribute string (Bug#27507).
--  020314  ROOD  Modified behavior in Cleanup__ depending on fnd setting (Bug#22732).
--  020314  ROOD  Increased length of layout name to 50 characters (Bug#28561).
--  020321  ROOD  Removed dependency upon fnd setting in Cleanup__.
--                Choose to always clear archive_file_name instead (Bug#22732).
--  020522  ROOD  Rebuilt New_Instance to include clearing of notes, this includes
--                setting of language and default layout aswell (Bug#30202).
--  020702  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021014  ROOD  Modified Create_New_Report__ to perform an override for
--                alternative reports (GLOB12).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030805  ASWI  Only sent value 'DIALOG' for the PRINT_ATTR in Redirect_Report (Bug#38675)
--  031029  ROOD  Added call to Archive_File_Name_API.Clear in Remove_User_Instance___ (Bug#38187).
--  040205  RAKU  Added clear of XmlReportData and PdfArchive in Remove_User_Instance___  (Bug#41529).
--  040219  ROOD  Removal of unused code in New_Entry__ (Bug#39376).
--  040303  ROOD  Replaced job_xx attributes with schedule_xx attributes (Bug#39376).
--  040305  ROOD  Modified view to properly handle when appowner is selecting from it.
--                Added parameter user_name_ in Remove_User_Instance.
--                Modified some get-methods to use Archive_Distribution_API (Bug#33057).
--  040317  ROOD  Minor improvements and added some comments (Bug#39376).
--  040713  ROOD  Added default parameter in Set_Expire_Date and Set_Printed (Bug#44945).
--  041011  ROOD  Added method Create_And_Print_Report__ for scheduled reports (F1PR419).
--  041029  MAOL  Added clear of XmlReportData and PdfArchive in Cleanup__  (Bug#46731).
--  050408  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  051108  ASWI  Changed PRINTJOB to FNDINF.PRINTJOB in method Run__(Bug#52484).
--  051109  BAMA  Added ORDER_TIME to instance_attr_. (Bug#49365).
--  051129  DOZE  Check layout for case before setting it in Set_Layout.
--  051209  HAAR  Removed refrences to Scheduled_Report_Tab (F1PR419).
--  060105  UTGULK Annotated Sql injection.
--  060214  UTGULK Moved Check_Layout___ method to Report_Layout_Definition.
--  060426  NiWi  Modified Attach_Report__. Increased the variable length schedule_name(Bug#56814).
--  060807  UTGULK Modified Create_And_Print_Report__() to call docman method for excel reports. 
--                 Added call to Check_Removal_Allowed___() in check_Delete___(Bug #59182).
--  070208  ASWILK Handling for Context Substitution Variables (Bug#63423).
--  071031  UTGULK Added excel report data cleanup to Cleanup__(Bug#69111). 
--  071231  UTGULK Modified Create_And_Print_Report__ to handle null parameter_attr_ (Bug#70279).
--  081201  HASPLK Modified method Create_New_Report__ to check is time portion required for 'DATE' type parameter value.(Bug #77866)
--  090303  HASPLK Modified method Create_New_Report__ to validate SYSDATE expressions. Added method Sysdate_Exp_Check___ (Bug#80845).
--  090319  SJayLK Bug 76605, Implemented "Email excel files" functionality
--  090324  SJayLK Bug 79001, BARS Error Messages
--  090430  HASPLK Modified method Create_New_Report__ to validate 'DATE' type parameters (Bug#81694).
--  090518  HASPLK Modified method Create_New_Report__ to validate 'DATE' type parameters in only 'YYYY-MM-DD' format (Bug#82844).
--  091023  LAKRLK Bug 86339 IEE - email notification for scheduled reports devlog 152043
--  100215  ChMuLK Bug 88742, Changed parameter_attr_ in Create_And_Print_Report__ and value_ in Create_new_report to VARCHAR2(4000)
--  100304  SubSlk Bug 88788, Added 5 more PDF_EVENT_PARAMERETSs. changed parameter value Create_And_Print_Report__.pdf_archive_attr_ ,
--                 Create_And_Print_Report__.send_pdf_info_ , Create_Print_Job.prt_job_attr_, Unpack_Check_Insert___.value_ to VARCHAR(4000)  
--  100511   KUWILK Modified method Create_New_Report__ to encode the notification url (LCS#89669).
--  100901  DUWI   Removed Socket_Message calling from Create_And_Print_Report__ (EACS-986)
--  121025  NaBaLK Increased buffer sizes in Create_New_Report to facilitate 4000 characters in a parameter value (Bug#105836)
--  130930  DASVSE Archive item now created before the RDF call and instead updated in Attach_Report
--  140123  ASIWLK Merged LCS-109673
--  140207  NaBaLK Added method Init_Archive_Item (PBTE-1278)
--  140428  AsiWLK  Bug 116584,Date context substitute variables in report parameters does not support arithmetic operations
--  140525  NaBaLK  Support for new pdf report event parameter defining functionality (TEREPORT-1150)
--  140221  AsiWLK  Bug 117001 Invalid format in date context substitution After applying patch 116584
--  140221  NaBaLK  XmlReportArchive and XmlReportAccess cleanup (TEREPORT-1480)
--  160712  NaBaLK  Server Side Excel Quick Reports merged from Apps9 (Bug#129251)
--  170309  CHAALK  Character string buffer too small error when ordering a report (BugID#134696)
--  180220  HADOLK  Changed Command_SYS.Mail argument list (BugID#2808)
--  180214  MABALK  Wrong report layout usging then report rules is using (BugID#140048)
--  180215  MABALK  Improve performance Heavy Cleanup Archive_api(Bug# 125095)
--  181203  CHAALK  Add 5 more event parameters to the PDF_REPORT_CREATED event (BugID#145665)
--  200306  CHAALK  Remove entry from Report Archive does not remove all connected archive records (Bug# 152765)
--  210606  MABALK  PDF Event Parameters can be passed when ordering a report (Bug# 159703)
--  210720  MABALK  Handle other report parameters combined with PDF Event Parameters for Aurena client. (Bug# 160238)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Remove_User_Instance___ (
   result_key_ IN NUMBER,
   user_name_  IN VARCHAR2 )
IS
   rec_        ARCHIVE_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(result_key_);
   Archive_Distribution_API.Remove_User(result_key_, user_name_);
   IF (Archive_Distribution_API.Is_Distributed(result_key_)) THEN
      RETURN;
   END IF;
   Report_SYS.Remove_Instance(rec_.report_id, result_key_);
   Archive_Parameter_API.Clear(result_key_);
   Archive_Variable_API.Clear(result_key_);
   Archive_File_Name_API.Clear(result_key_);
   Xml_Report_Data_API.Clear(result_key_);
   Pdf_Archive_API.Clear(result_key_);
   Xml_Report_Archive_API.Clear(result_key_);
   Xml_Report_Access_API.Clear(result_key_);
   $IF Component_Biserv_SYS.INSTALLED $THEN 
      Excel_Report_Archive_API.Remove_Instance(rec_.report_id, result_key_);
   $END 
   Check_Delete___(rec_);
   DELETE FROM archive_tab
      WHERE result_key = result_key_;
END Remove_User_Instance___;


PROCEDURE Check_Removal_Allowed___ (
   result_key_  IN NUMBER,
   schedule_id_ IN NUMBER,
   report_id_   IN VARCHAR2 ) 
IS
   message_               VARCHAR2(32000);
   external_archive_attr_ VARCHAR2(2000);
   report_mode_           VARCHAR2(30);
   doc_number_            VARCHAR2(2000);
   stmt_                  VARCHAR2(2000);
   document_exists_       VARCHAR2(5);
BEGIN
   IF (schedule_id_ IS NOT NULL AND  (substr(report_id_,-4) = '_REP') ) THEN 
      report_mode_ := Report_Definition_API.Get_Report_Mode(report_id_);
      IF report_mode_ = 'EXCEL1.0' THEN 
        IF Installation_SYS.Method_Exist('DOCUMENT_REPORT_ARCHIVE_API','Document_Exists') THEN
           message_ := Batch_Schedule_API.Get_Parameters__(schedule_id_,'MESSAGE');

           IF Message_SYS.Find_Attribute(message_, 'EXTERNAL_ARCHIVE_ATTR','') IS NOT NULL THEN
              Message_SYS.Get_Attribute(message_, 'EXTERNAL_ARCHIVE_ATTR', external_archive_attr_);
              doc_number_ := Client_SYS.Get_Item_Value('DOC_NO', external_archive_attr_);
              IF doc_number_ IS NOT NULL THEN
                 stmt_ := 'BEGIN ' ||
                          '   :document_exists_ := Document_Report_Archive_API.Document_Exists(:report_type,:document_id,:result_key); '||
                          'END;';
                 @ApproveDynamicStatement(2006-08-08,utgulk)
                 execute IMMEDIATE stmt_ using OUT document_exists_, IN report_mode_,IN doc_number_, IN result_key_ ;
                 IF document_exists_ = 'TRUE' THEN
                    Error_SYS.Record_General(lu_name_, 'DOCEXISTS: Cannot delete this report from archive since there is a new document revision in DOCMAN.'); 
                 END IF;
              END IF;
           END IF;
        END IF;
      END IF;
   END IF;
END Check_Removal_Allowed___;


PROCEDURE Sysdate_Exp_Check___ (
   value_ IN VARCHAR2 )
IS
   date_ DATE;
   stmt_ VARCHAR2(2000);
BEGIN
   Assert_SYS.Assert_Is_Sysdate_Expression(value_);
   stmt_ := 'BEGIN :date := '||value_||'; END;';
   @ApproveDynamicStatement(2011-05-30,haarse)
   EXECUTE IMMEDIATE stmt_ USING OUT date_;
EXCEPTION
   WHEN OTHERS THEN
      Error_SYS.Appl_General(lu_name_, 'INVALID_SYSDATE_EXP: ":P1" is not a valid date expression.', value_ );
END Sysdate_Exp_Check___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN ARCHIVE_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   Check_Removal_Allowed___(remrec_.result_key,remrec_.schedule_id,remrec_.report_id);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Layout_Name__ RETURN VARCHAR2
IS
BEGIN
   RETURN (FND_CONTEXT_SYS.Find_Value('ARCHIVE_API.layout_name_'));
END Get_Layout_Name__;


PROCEDURE Attach_Report__ (
   result_key_        IN  NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2,
   print_attr_        IN  VARCHAR2,
   notify_self_       IN  BOOLEAN )
IS
   tmp_key_       NUMBER;
   expire_date_   DATE;
   report_id_     VARCHAR2(30);
   report_title_  VARCHAR2(50);
   layout_name_   VARCHAR2(50);
   message_       VARCHAR2(2000);
   lang_code_     VARCHAR2(5);
   notes_         VARCHAR2(250);
   schedule_id_   NUMBER;
   schedule_name_ VARCHAR2(200);
   executions_    NUMBER;
   event_params_  VARCHAR2(4000);
   param_attr_    VARCHAR2(32000) := parameter_attr_;
BEGIN
   report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', report_attr_);
   Report_Definition_API.Exist(report_id_);
   report_title_ := Report_Definition_API.Get_Report_Title(report_id_);
   IF (print_attr_ IS NOT NULL) THEN
      message_ := Message_SYS.Construct('FNDINF.PRINTREPORT');
      Message_SYS.Add_Attribute(message_, 'RESULT_KEY', tmp_key_);
      Message_SYS.Add_Attribute(message_, 'PRINT_ATTR', print_attr_);
      Message_SYS.Add_Attribute(message_, 'REPORT_TITLE', report_title_);
   END IF;
   expire_date_   := sysdate + Report_Definition_API.Get_Life(report_id_);
   layout_name_   := Get_Layout_Name__;
   notes_         := Get_Notes__;
   lang_code_     := Get_Language__;
   event_params_  := Client_SYS.Cut_Item_Value('SETTINGS', param_attr_);
   IF (event_params_ IS NULL) THEN
      -- if PDF Event Parameters did not pass with report ordering & archiving process, get the default values from Pdf_Report_Event_Param_tab
      event_params_  := Get_Event_Params__(report_id_);
   END IF;
   -- Only used when report has been scheduled (to create reference between the scheduled report and this record)
   schedule_id_   := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SCHEDULE_ID', report_attr_));
   schedule_name_ := Client_SYS.Get_Item_Value('SCHEDULE_NAME', report_attr_);
   executions_    := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SCHEDULE_EXECUTIONS', report_attr_));
   UPDATE archive_tab
   SET 
     layout_name = layout_name_,
     schedule_id = schedule_id_,
     schedule_executions = executions_,
     schedule_name = schedule_name_,
     lang_code = lang_code_,
     notes = notes_,
     event_params = event_params_,
     rowversion = sysdate
   WHERE result_key = result_key_;
   Archive_Parameter_API.New_Entry_Parameter__(result_key_, param_attr_);
   Archive_Distribution_API.New_Entry_Distribution__(result_key_, distribution_list_, expire_date_, message_, notify_self_);

   --Rule Engine invoke
   DECLARE
    ecode_ NUMBER;
    emesg_ VARCHAR2(200);
   BEGIN
    Report_Rule_Engine_API.Executerules(result_key_);
   EXCEPTION  
      WHEN OTHERS THEN
      ecode_ := SQLCODE;
      emesg_ := SUBSTR(SQLERRM, 1, 200);
      report_rule_log_api.Log('ERROR Executerules DB'||TO_CHAR(ecode_)||'-'||emesg_,'ERROR',NULL);
   END;   


END Attach_Report__;


PROCEDURE Cleanup__
IS
   CURSOR get_old_reports IS
      SELECT rowid objid, TO_CHAR(rowversion,'YYYYMMDDHH24MISS') OBJVERSION, result_key, report_id, schedule_id
      FROM   archive_tab
      WHERE result_key NOT IN (SELECT result_key FROM  archive_distribution_tab);

   rec_  get_old_reports%ROWTYPE;
   vrec_ ARCHIVE_TAB%ROWTYPE;      
   err_text_ VARCHAR2(2000);
BEGIN
   BEGIN
      -- Will perform the hiding of archived reports with connected print jobs.
      Archive_Distribution_API.Remove_Old_Users;
@ApproveTransactionStatement(2013-11-11,mabose)
      COMMIT;
      OPEN get_old_reports;
      FETCH get_old_reports INTO rec_;
      vrec_.report_id := rec_.report_id;
      vrec_.result_key := rec_.result_key;
      vrec_.schedule_id := rec_.schedule_id;
      WHILE (get_old_reports%FOUND) LOOP
         BEGIN
            Report_SYS.Remove_Instance(vrec_.report_id, vrec_.result_key);
            Archive_Parameter_API.Clear(vrec_.result_key);
            Archive_Variable_API.Clear(vrec_.result_key);
            Archive_File_Name_API.Clear(vrec_.result_key);
            Xml_Report_Data_API.Clear(vrec_.result_key);
            Pdf_Archive_API.Clear(vrec_.result_key);
            Xml_Report_Archive_API.Clear(vrec_.result_key);
            Xml_Report_Access_API.Clear(vrec_.result_key);
            $IF Component_Biserv_SYS.INSTALLED $THEN 
               Excel_Report_Archive_API.Remove_Instance(vrec_.report_id, vrec_.result_key);
            $END 
            Check_Delete___(vrec_);
            DELETE FROM archive_tab
               WHERE result_key = vrec_.result_key;
@ApproveTransactionStatement(2013-11-11,mabose)
            COMMIT;
         EXCEPTION
            WHEN OTHERS THEN
@ApproveTransactionStatement(2013-11-11,mabose)
               ROLLBACK; -- Rollback if unsuccsessfull to guarantee correctness of database..               
               err_text_ := 'Archive_API.Cleanup__ removing result_key'||rec_.result_key||' faild'||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
               Transaction_SYS.Set_Status_Info(err_text_);
               RAISE;
         END;
         FETCH get_old_reports INTO rec_;
         vrec_.report_id := rec_.report_id;
         vrec_.result_key := rec_.result_key;
         vrec_.schedule_id := rec_.schedule_id;
      END LOOP;      
      CLOSE get_old_reports;
   EXCEPTION
      WHEN OTHERS THEN
@ApproveTransactionStatement(2013-11-11,mabose)
         ROLLBACK; -- Rollback if unsuccsessfull to guarantee correctness of database.. 
         err_text_ := 'Archive_API.Cleanup__ failed '||sqlerrm||' at '||to_char(sysdate,'YYYY-MM-DD HH24:MI:SS');
         Transaction_SYS.Set_Status_Info(err_text_);
         RAISE;
   END;
END Cleanup__;

FUNCTION Evaluate_Context_Variable___ (
   value_ IN VARCHAR2,
   column_format_ IN VARCHAR2) RETURN VARCHAR2
IS  
   context_value_    VARCHAR2(4000);
   context_variable_ VARCHAR2(50);
   date_    DATE;
BEGIN
      IF value_ IS NOT NULL AND INSTR(value_,'#')>0 THEN
         context_value_ := Context_Substitution_Var_API.Replace_Variable(value_,'TRUE');
         IF context_value_!= value_ AND column_format_ LIKE 'DATE%' THEN
           context_value_ := 'SELECT (' || context_value_ || ') FROM dual';
           -- Safe due to the fact that Context_Substitution variables are protected by system privilege DEFINE_SQL
           @ApproveDynamicStatement(2014-08-29,haarse)
           EXECUTE IMMEDIATE context_value_ INTO date_;
           context_variable_:= Regexp_Substr(value_, '#[^# '||CHR(10)||']+#',1);
           context_variable_:= Substr(context_variable_, 2, Length(context_variable_)-2);
           context_value_:= Context_Substitution_Var_API.Get_Date_Format_String(date_,context_variable_);
         END IF;
         RETURN context_value_;    
      END IF;
      
      RETURN value_;
EXCEPTION
   WHEN OTHERS THEN
      RETURN value_;     
END Evaluate_Context_Variable___;

PROCEDURE Create_New_Report__ (
   result_key_        OUT NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2,
   print_attr_        IN  VARCHAR2,
   notify_self_       IN  BOOLEAN )
IS
   tmp_key_              NUMBER;
   report_id_            VARCHAR2(30);
   new_report_id_        VARCHAR2(30);
   override_method_      VARCHAR2(61);
   extended_report_attr_ VARCHAR2(2000) := report_attr_;
   stmt_                 VARCHAR2(200);
   temp_param_attr_      VARCHAR2(32000);
   ptr_                  NUMBER;
   name_                 VARCHAR2(30);
   value_                VARCHAR2(32000);
   column_format_        VARCHAR2(30);
   from_date_            VARCHAR2(30);
   to_date_              VARCHAR2(30);

   FUNCTION Format_Column_Value(
         type_ VARCHAR2, 
         value_ VARCHAR2) RETURN VARCHAR2
      IS
      illegal_date_conversion_ exception;
      pragma exception_init(illegal_date_conversion_, -1830);
      pragma exception_init(illegal_date_conversion_, -1858);
      pragma exception_init(illegal_date_conversion_, -1861);
   BEGIN
      IF UPPER(value_) LIKE '%SYSDATE%' THEN
         Sysdate_Exp_Check___(value_);
         RETURN value_;
      ELSIF type_ NOT IN ('DATE/DATETIME', 'DATE/TIME') THEN
         -- handle values only in YYYY-MM-DD format
         IF REGEXP_LIKE(value_,'(([[:digit:]]){4})-(([[:digit:]]){1,2})-(([[:digit:]]){1,2})') THEN
            RETURN TO_CHAR(TO_DATE(value_, Client_SYS.Date_Format_), 'YYYY-MM-DD');
         ELSE
            RETURN value_;
         END IF;
      END IF;
      RETURN value_;

   EXCEPTION
      WHEN illegal_date_conversion_ THEN
         RETURN value_;
   END Format_Column_Value;

BEGIN
   report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', extended_report_attr_);
   Report_Definition_API.Check_Report_Def_User__(report_id_);

   temp_param_attr_  := parameter_attr_;   
      
   -- Check parameter list for any 'DATE' type parameters.
   -- IF any, check it's date format from report columns.
   -- IF no time portion required, time portion will be removed.(Format_Column_Value)

   ptr_ := NULL;
   WHILE Client_SYS.Get_Next_From_Attr(parameter_attr_, ptr_, name_, value_) LOOP
      column_format_ := UPPER(Report_Column_Definition_API.Get_Column_Dataformat(report_id_, name_));
      IF value_ IS NOT NULL AND column_format_ LIKE 'DATE%' THEN
         IF INSTR(value_,'%')>0 OR INSTR(value_,';')>0 THEN
            NULL;
         ELSIF SUBSTR(value_,1,2) IN ('<=','>=','!=') THEN
            Client_SYS.Set_Item_Value(name_, SUBSTR(value_,1,2)||Format_Column_Value(column_format_, SUBSTR(Evaluate_context_variable___(value_,column_format_),3)), temp_param_attr_);   
         ELSIF SUBSTR(value_,1,1) IN ('<','>') THEN
            Client_SYS.Set_Item_Value(name_, SUBSTR(value_,1,1)||Format_Column_Value(column_format_, SUBSTR(Evaluate_context_variable___(value_,column_format_),2)), temp_param_attr_);
         ELSIF INSTR(value_, '..')>0 THEN
            from_date_ := substr(value_,1,instr(value_,'..')-1);
            from_date_ := Evaluate_context_variable___(from_date_,column_format_);
            from_date_ := Format_Column_Value(column_format_, from_date_);

            to_date_   := substr(value_,instr(value_,'..')+2);
            to_date_   := Evaluate_context_variable___(to_date_,column_format_);
            to_date_   := Format_Column_Value(column_format_, to_date_);

            Client_SYS.Set_Item_Value(name_, from_date_||'..'||to_date_, temp_param_attr_);         
         ELSE
            Client_SYS.Set_Item_Value(name_, Format_Column_Value(column_format_, Evaluate_context_variable___(value_,column_format_)), temp_param_attr_);
         END IF;
      END IF;
   END LOOP;
    -- Replace other Context Substitution Variables
   temp_param_attr_  := Context_Substitution_Var_API.Replace_Variables__(temp_param_attr_);
   --
   -- The report_id received here is for the master report.
   -- Investigate if alternative report should be used instead.
   --
   override_method_ := Report_Definition_API.Get_Override_Method(report_id_);
   IF override_method_ IS NOT NULL THEN
      Trace_SYS.Message('Investigating if alternative report should be used for master report '|| report_id_ || '.');
      Assert_SYS.Assert_Is_Package_Method(override_method_);
      stmt_ := 'begin :new_report_id_ := '||override_method_||'(:report_id_,:temp_param_attr_); end;';

      -- Execute the override method. No exception handling is wanted, since it would "hide"
      -- possible problems in override method from developers.
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE stmt_ USING OUT new_report_id_, report_id_, temp_param_attr_;

      IF new_report_id_ != report_id_ THEN
         Trace_SYS.Message('Alternative report ' || new_report_id_ || ' will be used!');

         -- Change the report_id to the alternative one
         report_id_ := new_report_id_;

         -- Verify the existance of this report_id as well.
         Report_Definition_API.Exist(report_id_);

         -- Make sure that the correct report_id is in the report attribute string
         Client_SYS.Set_Item_Value('REPORT_ID', report_id_, extended_report_attr_);
      END IF;
   END IF;

   --
   -- Set globals for this report
   -- These could be overridden in applications by calling
   -- Archive_API.Set_xxx-methods from the report method
   --
   -- Use the default layout if no layout has been sent in through the attribute string
   Set_Layout_Name(nvl(Client_SYS.Get_Item_Value('LAYOUT_NAME', extended_report_attr_), Report_Layout_Definition_API.Get_Default_Layout(report_id_)));
   
   -- Clear old notes
   Set_Notes(NULL);
   
      -- Use this sessions language if no language has been sent in through the attribute string
   Set_Language(nvl(Client_SYS.Get_Item_Value('LANG_CODE', extended_report_attr_), Fnd_Session_API.Get_Language));
   
   --
   -- Create the report
   --
   Report_SYS.Run_Report(tmp_key_, extended_report_attr_, temp_param_attr_);
   Attach_Report__(tmp_key_, extended_report_attr_, temp_param_attr_, distribution_list_, print_attr_, notify_self_);
   result_key_ := tmp_key_;
END Create_New_Report__;


PROCEDURE Create_And_Print_Report__ (
   in_msg_ IN VARCHAR2 )
IS
   -- the message contains 6 attribute strings
   report_attr_          VARCHAR2(2000);
   parameter_attr_       VARCHAR2(4000);
   message_attr_         VARCHAR2(2000);
   archiving_attr_       VARCHAR2(4000);
   distribution_list_    VARCHAR2(2000);

   result_key_           NUMBER;
   instance_attr_        VARCHAR2(32000);
   print_job_attr_       VARCHAR2(2000);
   print_job_id_         NUMBER;
   pdf_archiving_        BOOLEAN;
   create_print_job_     BOOLEAN;
   message_type_         VARCHAR2(250);
   send_email_to_        VARCHAR2(2000);
   message_              VARCHAR2(2000);
   subject_              VARCHAR2(2000);
   send_pdf_info_        VARCHAR2(4000);
   current_user_         VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   schedule_id_          NUMBER;
   report_id_            VARCHAR2(30);
   report_mode_          VARCHAR2(30);
   post_render_helper_attr_  VARCHAR2(2000);
   schedule_job_id_      NUMBER;
   is_schedule_job_      BOOLEAN := FALSE;
   excel_report_         VARCHAR2(10):= 'EXCEL1.0';
   get_ext_server_       FND_SETTING_TAB.Value%TYPE ;
   iee_email_ext_        VARCHAR2(2000):=NULL;
   ordinary_printer_    VARCHAR2(1000);
   baes_used_            BOOLEAN := FALSE;
   
BEGIN
   
   Transaction_SYS.Modify_Stream_Error_Message(lu_name_,'REPERROR: Error Creating Report');
   -- Get the original attribute strings from the inmessage.
   Message_SYS.Get_Attribute(in_msg_, 'REPORT_ATTR', report_attr_);
   parameter_attr_ := Message_SYS.Find_Attribute(in_msg_, 'PARAMETER_ATTR','');
   Message_SYS.Get_Attribute(in_msg_, 'MESSAGE_ATTR', message_attr_);
   Message_SYS.Get_Attribute(in_msg_, 'ARCHIVING_ATTR', archiving_attr_);
   Message_SYS.Get_Attribute(in_msg_, 'DISTRIBUTION_LIST', distribution_list_);

   schedule_id_ := Client_SYS.Get_Item_Value('SCHEDULE_ID', report_attr_);
   report_id_   := Client_SYS.Get_Item_Value('REPORT_ID', report_attr_);
   report_mode_ := Report_Definition_API.Get_Report_Mode(report_id_);
   
   Transaction_SYS.Modify_Stream_Reference(utl_url.escape('ifswin:Ifs.Application.InfoServices.ScheduleReport?external_search=schedule_id='|| schedule_id_));
  
   --
   -- Create print jobs
   --
   message_type_ := nvl(Client_SYS.Get_Item_Value('MESSAGE_TYPE', message_attr_), 'NONE'); -- Different message types
   IF report_mode_ = excel_report_ THEN
      create_print_job_ := FALSE;
   ELSE
      IF ((message_type_ = 'NONE') OR (message_type_ = 'EMAIL')) THEN
         create_print_job_ := FALSE;
      ELSE
         create_print_job_ := TRUE;   
      END IF;
   END IF;
   
   pdf_archiving_ := nvl(Client_SYS.Get_Item_Value('PDF_ARCHIVING', archiving_attr_), 'FALSE') = 'TRUE';
   IF ( pdf_archiving_) THEN
    ordinary_printer_ := nvl(Client_SYS.Get_Item_Value('PRINTER_ID', message_attr_), logical_printer_api.Get_Pdf_Printer);
   ELSE
    ordinary_printer_ := Client_SYS.Get_Item_Value('PRINTER_ID', message_attr_);
   END IF;
   
   IF ( create_print_job_ OR pdf_archiving_ ) THEN
      -- Add general information used by both possible print jobs to the print job attribute string
      IF schedule_id_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('SCHEDULE_ID', schedule_id_, print_job_attr_);
         Client_SYS.Add_To_Attr('SCHEDULE_NAME', Batch_Schedule_API.Get_Schedule_Name(schedule_id_), print_job_attr_);
         Client_SYS.Add_To_Attr('SCHEDULE_EXECUTIONS', Batch_Schedule_API.Get_Executions(schedule_id_), print_job_attr_);
      END IF;
      Client_SYS.Add_To_Attr('USER_NAME', current_user_, print_job_attr_);
      -- Set printer to the one choosen for print out.
      Client_SYS.Set_Item_Value('PRINTER_ID',ordinary_printer_, print_job_attr_);
	  -- app8:ordinary print jobs are archived,SEND_PDF functionality is enabled
	  send_pdf_info_ := Message_SYS.Construct('PDF');
      Message_SYS.Add_Attribute(send_pdf_info_, 'SEND_PDF', Client_SYS.Get_Item_Value('SEND_PDF', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'SEND_PDF_TO', Client_SYS.Get_Item_Value('SEND_PDF_TO', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'REPLY_TO_USER', Client_SYS.Get_Item_Value('REPLY_TO_USER', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_1', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_1', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_2', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_2', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_3', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_3', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_4', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_4', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_5', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_5', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_6', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_6', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_7', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_7', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_8', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_8', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_9', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_9', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_10', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_10', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_11', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_11', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_12', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_12', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_13', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_13', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_14', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_14', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_EVENT_PARAM_15', Client_SYS.Get_Item_Value('PDF_EVENT_PARAM_15', archiving_attr_));
      Message_SYS.Add_Attribute(send_pdf_info_, 'PDF_FILE_NAME', Client_SYS.Get_Item_Value('PDF_FILE_NAME', archiving_attr_));
      
      Client_SYS.Add_To_Attr('SETTINGS', send_pdf_info_, print_job_attr_);
      Print_Job_API.New(print_job_id_, print_job_attr_);
   END IF;
   --
   -- Create the report and handle its connected print jobs
   --
   --
   -- Add information about this schedule to the report attribute string (to make the connection visible in the Archive)
   --
   IF schedule_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('SCHEDULE_NAME', Batch_Schedule_API.Get_Schedule_Name(schedule_id_), report_attr_);
      Client_SYS.Add_To_Attr('SCHEDULE_EXECUTIONS', Batch_Schedule_API.Get_Executions(schedule_id_), report_attr_);
   END IF;

   IF (substr(report_id_,-4) = '_REP') THEN
      -- Create the report
      Create_New_Report__(result_key_, report_attr_, parameter_attr_, distribution_list_, NULL, FALSE);

      IF ( create_print_job_ OR pdf_archiving_ ) THEN
         -- Add general information used by both possible print jobs to an attribute string
         Client_SYS.Clear_Attr(instance_attr_);
         Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, instance_attr_);
         Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, instance_attr_);
         Client_SYS.Add_To_Attr('LAYOUT_NAME', Get_Layout_Name__, instance_attr_);
         Client_SYS.Add_To_Attr('LANG_CODE', Get_Language__, instance_attr_);
      END IF;

      IF create_print_job_ OR pdf_archiving_ THEN
         Print_Job_Contents_API.New_Instance(instance_attr_);
      END IF;
   ELSIF (substr(report_id_,-4) = '_GRP') THEN
      -- Add information about the print job to the report attribute string (to make the connection visible).
      Client_SYS.Add_To_Attr('PRINT_JOB_ID', print_job_id_, report_attr_);
      Report_SYS.Run_Group(report_attr_, parameter_attr_);
   END IF;
   --
   -- Handle the different possible actions after the report has been created, EXCEL1.0 reports should be handled by Excel_Report_Archive_API
   --
   IF report_mode_ != excel_report_ THEN
      IF (message_type_ = 'NONE') THEN
        IF ( pdf_archiving_ )THEN
           Print_Job_API.Print(print_job_id_);
          END IF;
      ELSIF (message_type_ = 'PRINTER') THEN
         Print_Job_API.Print(print_job_id_);
      ELSIF (message_type_ = 'EMAIL') THEN
         IF ( pdf_archiving_ )THEN
            Print_Job_API.Print(print_job_id_);
         END IF;
         send_email_to_ := Client_SYS.Get_Item_Value('SEND_EMAIL_TO', message_attr_);
         IF send_email_to_ IS NULL THEN
            send_email_to_ := current_user_;
         ELSE
            -- Modify the interface to suit Command_SYS...
            send_email_to_ := REPLACE(send_email_to_, ';', ',');
         END IF;
         subject_ := Language_SYS.Translate_Constant(lu_name_, 'PRTJOBRDYSUBJ: Report order is ready', NULL);
		
         --Modify email body add IEE URL
         get_ext_server_ := fnd_setting_api.Get_Value('SYSTEM_URL');
   
         IF (get_ext_server_ IS NOT NULL) AND NOT (get_ext_server_='http://<host>:<port>') THEN
            iee_email_ext_:= Language_SYS.Translate_Constant(lu_name_,'PRTJOBIEEURL: IF you are using IFS Enterprise Explorer, click on the following link to print the report: ' ,NULL);
            iee_email_ext_:=iee_email_ext_||CHR(13)||CHR(10)||get_ext_server_|| '/client/runtime/Ifs.Fnd.Explorer.application?url=' || utl_url.escape('ifswin:Ifs.Application.InfoServices.ReportArchive?action=get'||'&'||'key1='|| result_key_, TRUE, NULL)||CHR(13)||CHR(10);
         END IF;      
         message_ := Language_SYS.Translate_Constant(lu_name_, 'SCHPRTJOBRDY: Report order :P1 is ready. ' ||CHR(13)||CHR(10)||
         ':P2 Alternatively,open the Report Archive window, highlight the row with result key :P1 and select "Print..."from the context menu', NULL, result_key_,iee_email_ext_);

         --Command_SYS.Mail(current_user_, send_email_to_, message_, subject_ => subject_, from_alias_ => 'IFS Applications');
         --Command_SYS.Mail('IFS Applications', current_user_, send_email_to_, NULL, NULL, subject_, message_, NULL);
         Command_SYS.Mail(current_user_, send_email_to_, message_, NULL, NULL, NULL, subject_, NULL, NULL, 'IFS Applications', NULL);
        END IF;
   END IF;


   schedule_job_id_ := Transaction_SYS.Get_Current_Job_Id;
   IF  (schedule_job_id_ != 0 ) THEN
      is_schedule_job_ := TRUE;
   END IF;
   
$IF Component_Biserv_SYS.INSTALLED $THEN
   IF report_mode_ = excel_report_ THEN
      IF (   ( is_schedule_job_ = FALSE ) 
          OR ( NVL(XLR_SYSTEM_PARAMETER_UTIL_API.Get_System_Parameter('BA_EXECUTION_SERVER_AVAILABLE'), 'NO') IN ('NO')) 
          OR ( NVL(XLR_SYSTEM_PARAMETER_UTIL_API.Get_System_Parameter_Boolean('ACTIVATE_BR_CONTAINER'), FALSE))) THEN
         Client_SYS.Add_To_Attr('SCHEDULE_ID'         , schedule_id_       , post_render_helper_attr_);
         Client_SYS.Add_To_Attr('SCHEDULE_JOB_ID'     , schedule_job_id_   , post_render_helper_attr_);
         Excel_Report_Archive_API.Run_Post_Render_Tasks(report_id_, result_key_, post_render_helper_attr_);
      ELSE
         baes_used_ := TRUE;
      END IF;
   END IF;
$END  

   --The report is being executed externally by the BAES server. So the stream below is irrelevant in this case.
   IF NOT baes_used_ THEN 
      Transaction_SYS.Modify_Stream_Url('ifswin:Ifs.Application.InfoServices.ReportArchive?action=get'||'&'||'key1='|| result_key_);
      Transaction_SYS.Modify_Stream_Message(lu_name_,
         'STREAMHEADER: Your Report Is Ready' , 
         'STREAMMSG: Report -  :P1 Is Now Ready ',
         Report_Definition_API.Get_Report_Title(report_id_));
   END IF;
   

   
END Create_And_Print_Report__;


@UncheckedAccess
FUNCTION Get_Language__ RETURN VARCHAR2
IS
BEGIN
   RETURN (FND_CONTEXT_SYS.Find_Value('ARCHIVE_API.lang_code_'));
END Get_Language__;


@UncheckedAccess
FUNCTION Get_Notes__ RETURN VARCHAR2
IS
BEGIN
   RETURN (FND_CONTEXT_SYS.Find_Value('ARCHIVE_API.notes_'));
END Get_Notes__;

@UncheckedAccess
FUNCTION Get_Event_Params__ (
   report_id_   IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Pdf_Report_Event_Param_API.Get_Parameters(report_id_);
END Get_Event_Params__;

PROCEDURE New_Entry__ (
   report_attr_list_     IN  Agenda_API.REP_ARRAY_TYPE,
   parameter_attr_list_  IN  Agenda_API.REP_ARRAY_TYPE,
   job_attr_             IN  VARCHAR2,
   distribution_list_    IN  VARCHAR2 )
IS
   attr_             VARCHAR2(2000);
   report_id_        VARCHAR2(30);
   report_title_     VARCHAR2(100);
   layout_name_      VARCHAR2(30);
   print_attr_       VARCHAR2(300);
   message_          VARCHAR2(2000);
   index_            NUMBER := 1;
   result_key_       NUMBER;
   expire_date_      DATE;
BEGIN
   LOOP
      BEGIN
         attr_ := report_attr_list_(index_);
      EXCEPTION
         WHEN no_data_found THEN
            RETURN; -- normal termination
         WHEN OTHERS THEN
            Error_SYS.Appl_General(lu_name_, 'ARCUNEXPERR: Unexpected error [:P1].', SQLERRM);
      END;
      -- packup report, layout, parameter_values
      report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', attr_);
      Report_Definition_API.Exist(report_id_);
      -- execute report and get result_key
      Set_Language(Client_SYS.Get_Item_Value('LANG_CODE', attr_));
      report_id_ := Client_SYS.Get_Item_Value('REPORT_ID', attr_);
      -- calculate expire_date
      expire_date_ := sysdate + Report_Definition_API.Get_Life(report_id_);
      layout_name_ := Client_SYS.Get_Item_Value('LAYOUT_NAME', attr_);
      message_ := Message_SYS.Construct('FNDINF.PRINTREPORT');
      report_title_ := Report_Definition_API.Get_Report_Title(report_id_);
      Client_SYS.Add_To_Attr('OUTPUT', 'DIALOG', print_attr_);
      Message_SYS.Add_Attribute( message_, 'RESULT_KEY', result_key_);
      Message_SYS.Add_Attribute( message_, 'PRINT_ATTR', print_attr_);
      Message_SYS.Add_Attribute( message_, 'REPORT_TITLE', report_title_);
      Set_Notes(NULL);
      Set_Language(Client_SYS.Get_Item_Value('LANG_CODE', attr_));
      Report_SYS.Run_Report(result_key_, attr_, parameter_attr_list_(index_));
      Attach_Report__(result_key_, attr_, parameter_attr_list_(index_), distribution_list_, message_, TRUE);
      index_ := index_ + 1;
   END LOOP;
END New_Entry__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
PROCEDURE Check_Authorized(
   result_key_  IN NUMBER)
IS   
BEGIN
   IF(NOT Is_Authorized(result_key_)) THEN
      Error_SYS.Data_Access_Security(lu_name_, 'ACCDENIED: User does not have access to the record :P1 or the record does not exist.', result_key_);
   END IF;
END Check_Authorized;

@UncheckedAccess
FUNCTION Is_Authorized(
   result_key_  IN NUMBER) RETURN BOOLEAN
IS
   authorized_ NUMBER;
   
   CURSOR check_authorized IS
      SELECT 1 
      FROM   archive
      WHERE  result_key = result_key_;
BEGIN
   OPEN check_authorized;
   FETCH check_authorized INTO authorized_;
   CLOSE check_authorized;
   RETURN authorized_ IS NOT NULL;
END Is_Authorized;

@UncheckedAccess
FUNCTION Get_Report_Title (
   result_key_ IN NUMBER,
   lang_code_  IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   temp_ ARCHIVE_TAB.report_id%TYPE;
   CURSOR get_attr IS
      SELECT report_id
      FROM ARCHIVE_TAB
      WHERE result_key = result_key_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN substr(Report_Definition_API.Get_Translated_Report_Title(temp_,lang_code_),1,50);
END Get_Report_Title;


@UncheckedAccess
FUNCTION Get_Expire_Date (
   result_key_ IN NUMBER ) RETURN DATE
IS
   fnduser_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   RETURN Archive_Distribution_API.Get_Expire_Date(result_key_, fnduser_);
END Get_Expire_Date;


@UncheckedAccess
FUNCTION Get_Printed (
   result_key_ IN NUMBER ) RETURN NUMBER
IS
   fnduser_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   RETURN Archive_Distribution_API.Get_Printed(result_key_, fnduser_);
END Get_Printed;


@UncheckedAccess
FUNCTION Get_Arrival_Time (
   result_key_ IN NUMBER ) RETURN DATE
IS
   fnduser_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   RETURN Archive_Distribution_API.Get_Arrival_Time(result_key_, fnduser_);
END Get_Arrival_Time;


@UncheckedAccess
FUNCTION Get_Job_Id (
   result_key_ IN NUMBER ) RETURN NUMBER
IS
   temp_ ARCHIVE_TAB.schedule_id%TYPE;
   CURSOR get_attr IS
      SELECT schedule_id
      FROM ARCHIVE_TAB
      WHERE result_key = result_key_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Job_Id;


@UncheckedAccess
FUNCTION Get_Job_Seq (
   result_key_ IN NUMBER ) RETURN NUMBER
IS
   temp_ ARCHIVE_TAB.schedule_executions%TYPE;
   CURSOR get_attr IS
      SELECT schedule_executions
      FROM ARCHIVE_TAB
      WHERE result_key = result_key_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Job_Seq;


@UncheckedAccess
FUNCTION Get_Job_Name (
   result_key_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ ARCHIVE_TAB.schedule_name%TYPE;
   CURSOR get_attr IS
      SELECT schedule_name
      FROM ARCHIVE_TAB
      WHERE result_key = result_key_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Job_Name;


PROCEDURE Attach_Report (
   result_key_        IN  NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2 )
IS
BEGIN
   Set_Layout_Name(Client_SYS.Get_Item_Value('LAYOUT_NAME', report_attr_));
   Set_Notes(NULL);
   Set_Language(Client_SYS.Get_Item_Value('LANG_CODE', report_attr_));
   Attach_Report__(result_key_, report_attr_, parameter_attr_, distribution_list_, NULL, FALSE);
END Attach_Report;


PROCEDURE Connect_Instance (
   result_key_ IN NUMBER,
   user_name_  IN VARCHAR2 )
IS
BEGIN
   Archive_Distribution_API.Connect_Instance(result_key_, user_name_, sysdate);
END Connect_Instance;


@UncheckedAccess
PROCEDURE Get_Info (
   instance_attr_  OUT VARCHAR2,
   parameter_attr_ OUT VARCHAR2,
   result_key_     IN  NUMBER )
IS
   CURSOR get_schedule_initialted_time(v_schedule_id_ NUMBER) IS
     SELECT rowversion
     FROM batch_schedule_tab
     WHERE schedule_id = v_schedule_id_;

   rec_    archive_tab%ROWTYPE;
   attr_   VARCHAR2(32000);
   schedule_initialted_time_ DATE;
BEGIN
   rec_ := Get_Object_By_Keys___(result_key_);
   Client_SYS.Add_To_Attr('REPORT_ID', rec_.report_id, attr_);
   Client_SYS.Add_To_Attr('REPORT_TITLE', substr(Report_Definition_API.Get_Translated_Report_Title(rec_.report_id), 1, 50), attr_);
   Client_SYS.Add_To_Attr('SCHEDULE_ID', rec_.schedule_id, attr_);
   Client_SYS.Add_To_Attr('SCHEDULE_NAME', rec_.schedule_name, attr_);
   Client_SYS.Add_To_Attr('SENDER', rec_.sender, attr_);
   Client_SYS.Add_To_Attr('EXEC_TIME', rec_.exec_time, attr_);
   Client_SYS.Add_To_Attr('LAYOUT_NAME', rec_.layout_name, attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', rec_.lang_code, attr_);
   Client_SYS.Add_To_Attr('NOTES', rec_.notes, attr_);
   --Client_SYS.Add_To_Attr('LAST_DDL_TIME', Report_SYS.Get_Last_DDl_Time(rec_.report_id), attr_);    -- Removed for performance reasons. It does not seem to be used in this context. (DASVSE)

   IF rec_.schedule_id IS NULL THEN
      Client_SYS.Add_To_Attr('ORDER_TIME', rec_.exec_time, attr_);
   ELSE
      -- Order time must be fetch from scheduled report tab
      OPEN  get_schedule_initialted_time(rec_.schedule_id);
      FETCH get_schedule_initialted_time INTO  schedule_initialted_time_;
      IF get_schedule_initialted_time%FOUND THEN
         Client_SYS.Add_To_Attr('ORDER_TIME', schedule_initialted_time_, attr_);
      ELSE
         Client_SYS.Add_To_Attr('ORDER_TIME', rec_.exec_time, attr_);
      END IF;
      CLOSE  get_schedule_initialted_time;
   END IF;

   instance_attr_ := attr_;
   Archive_Parameter_API.Get_Parameter_Attr(parameter_attr_, result_key_);
END Get_Info;




PROCEDURE Get_Report_Identity (
   report_id_  OUT VARCHAR2,
   result_key_ IN  NUMBER )
IS
BEGIN
   SELECT report_id
      INTO report_id_
      FROM archive_tab
      WHERE result_key = result_key_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Appl_General(lu_name_, 'KEYERR: Report with key [:P1] does not exist.', result_key_);
END Get_Report_Identity;


@UncheckedAccess
PROCEDURE Get_Report_Info (
   report_id_            OUT VARCHAR2,
   job_id_               OUT NUMBER,
   exec_time_            OUT DATE,
   job_name_             OUT VARCHAR2,
   sender_               OUT VARCHAR2,
   layout_name_          OUT VARCHAR2,
   parameter_query_attr_ OUT VARCHAR2,
   parameter_value_attr_ OUT VARCHAR2,
   result_key_           IN  NUMBER )
IS
   CURSOR get_info IS
      SELECT report_id, schedule_id, schedule_name, sender, exec_time, layout_name
      FROM   archive
      WHERE  result_key = result_key_;
BEGIN
   OPEN get_info;
   FETCH get_info INTO report_id_, job_id_, job_name_, sender_, exec_time_, layout_name_;
   CLOSE get_info;
   Archive_Parameter_API.Get_Parameter_Query_List(parameter_query_attr_, parameter_value_attr_, report_id_, result_key_);
END Get_Report_Info;




PROCEDURE Init_Archive_Item (
   result_key_           IN NUMBER,
   report_id_            IN VARCHAR2,
   exec_time_            IN DATE DEFAULT NULL,
   sender_               IN VARCHAR2 DEFAULT NULL)
IS
   objid_       VARCHAR2(100);
   objversion_  VARCHAR2(100);
   newrec_      ARCHIVE_TAB%ROWTYPE;
   attr_        VARCHAR2(100); 
BEGIN
   newrec_.result_key := result_key_;
   newrec_.report_id  := report_id_;
   newrec_.exec_time  := NVL(exec_time_, SYSDATE);
   newrec_.sender     := NVL(sender_, Fnd_Session_API.Get_Fnd_User);
   newrec_.rowversion := SYSDATE;
   Insert___ (objid_, objversion_, newrec_, attr_);
END Init_Archive_Item;


PROCEDURE New_Client_Report (
   result_key_        OUT NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2,
   print_attr_        IN  VARCHAR2 )
IS
BEGIN
   Create_New_Report__(result_key_, report_attr_, parameter_attr_, distribution_list_, print_attr_, FALSE);
END New_Client_Report;


PROCEDURE New_Instance (
   result_key_        OUT NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2 )
IS
BEGIN
   Create_New_Report__(result_key_, report_attr_, parameter_attr_, NULL, NULL, FALSE);
END New_Instance;


PROCEDURE New_Report (
   result_key_        OUT NUMBER,
   report_attr_       IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2 )
IS
   print_attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('OUTPUT', 'PRINT', print_attr_);
   Create_New_Report__(result_key_, report_attr_, parameter_attr_, distribution_list_, print_attr_, TRUE);
END New_Report;


PROCEDURE Redirect_Report (
   result_key_        IN NUMBER,
   distribution_list_ IN VARCHAR2 )
IS
   report_id_   VARCHAR2(30);
   expire_date_ DATE;
   message_     VARCHAR2(2000);
   report_title_ VARCHAR2(50);
BEGIN
   Archive_API.Check_Authorized(result_key_);
   Get_Report_Identity(report_id_, result_key_);
   expire_date_ := sysdate + Report_Definition_API.Get_Life(report_id_);
   message_ := Message_SYS.Construct('FNDINF.PRINTREPORT');
   report_title_ := Report_Definition_API.Get_Report_Title(report_id_);
   Message_SYS.Add_Attribute( message_, 'RESULT_KEY', result_key_);
   Message_SYS.Add_Attribute( message_, 'PRINT_ATTR', 'DIALOG');
   Message_SYS.Add_Attribute( message_, 'REPORT_TITLE', report_title_);
   Archive_Distribution_API.New_Entry_Distribution__(result_key_, distribution_list_, expire_date_, message_, FALSE);
END Redirect_Report;


PROCEDURE Remove_User_Instance (
   result_key_ IN NUMBER,
   user_name_  IN VARCHAR2 DEFAULT NULL )
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   temp_     VARCHAR2(30);
BEGIN
   -- Backward compatibility against older clients that calls interface without user_name...
   IF user_name_ IS NULL THEN
      temp_ := fnd_user_;
   ELSE
      -- Only allowed to delete your own reports or appowner can delete everyones
--      IF fnd_user_ = Fnd_Session_API.Get_App_Owner OR fnd_user_ = user_name_ THEN
      IF Security_SYS.Has_System_Privilege('ADMINISTRATOR', fnd_user_) OR fnd_user_ = user_name_ THEN
         temp_ := user_name_;
      ELSE
         Error_SYS.Record_General(lu_name_, 'NOPRIVDELETE: Only user [:P1] and Application Owner can remove the report [:P2].', user_name_, result_key_);
      END IF;
   END IF;
   -- Only perform the deletion if check is passed
   Remove_User_Instance___(result_key_, temp_);
END Remove_User_Instance;


PROCEDURE Set_Expire_Date (
   result_key_  IN NUMBER,
   expire_date_ IN DATE,
   user_name_   IN VARCHAR2 DEFAULT NULL )
IS
   report_owner_ VARCHAR2(30);
BEGIN
   IF user_name_ IS NULL THEN
      report_owner_ := Fnd_Session_API.Get_Fnd_User;
   ELSE
      report_owner_ := user_name_;
   END IF;
   Archive_Distribution_API.Set_Expire_Date( result_key_, report_owner_, expire_date_);
END Set_Expire_Date;


PROCEDURE Set_Language (
   in_lang_code_ IN VARCHAR2 )
IS
   notes_         VARCHAR2(1000);
BEGIN
   IF 'A' = language_code_api.get_status_db(in_lang_code_) THEN
      FND_CONTEXT_SYS.Set_Value('ARCHIVE_API.lang_code_', substr(in_lang_code_,1,5));
   ELSE
      FND_CONTEXT_SYS.Set_Value('ARCHIVE_API.lang_code_', Fnd_Session_API.Get_Language);
      notes_ := Language_SYS.Translate_Constant(lu_name_, 'LNGNOTACTIVE: Language code '':P1'' is not active, default to session language '':P2''', NULL, in_lang_code_,Fnd_Session_API.Get_Language);
      IF Get_Notes__ IS NOT NULL THEN
           notes_         := Get_Notes__ ||':'||notes_;
      END IF;
      Set_Notes(notes_);
   END IF;
END Set_Language;


PROCEDURE Set_Layout_Name (
   in_layout_name_ IN VARCHAR2 )
IS
   new_layout_ VARCHAR2(100);
BEGIN
   new_layout_ := substr(in_layout_name_,1,100);
   REPORT_LAYOUT_DEFINITION_API.Check_Layout(new_layout_);
   FND_CONTEXT_SYS.Set_Value('ARCHIVE_API.layout_name_', new_layout_);
END Set_Layout_Name;


PROCEDURE Set_Archive_Property (
   result_key_        IN  NUMBER,
   report_attr_       IN  VARCHAR2 )
IS
      newrec_ ARCHIVE_TAB%ROWTYPE;
      oldrec_ ARCHIVE_TAB%ROWTYPE;
      tmp_    VARCHAR2(2000);   
BEGIN
      newrec_ := Lock_By_Keys___(result_key_);
      oldrec_ := newrec_;
      newrec_.lang_code := Client_SYS.Get_Item_Value('LANG_CODE', report_attr_);
      newrec_.layout_name := Client_SYS.Get_Item_Value('LAYOUT_NAME', report_attr_);      
      Update___(NULL, oldrec_, newrec_, tmp_, tmp_, TRUE);
END Set_Archive_Property;


PROCEDURE Set_Notes (
   in_notes_ IN VARCHAR2 )
IS
BEGIN
   FND_CONTEXT_SYS.Set_Value('ARCHIVE_API.notes_', substr(in_notes_,1,250));
END Set_Notes;


PROCEDURE Set_Printed (
   result_key_ IN NUMBER,
   user_name_  IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   IF user_name_ IS NULL THEN
      Archive_Distribution_API.Set_Printed(result_key_);
   ELSE
      Archive_Distribution_API.Set_Printed(result_key_, user_name_);
   END IF;
END Set_Printed;


PROCEDURE Create_Print_Job (
   print_job_id_      OUT NUMBER,
   group_attr_        IN  VARCHAR2,
   parameter_attr_    IN  VARCHAR2,
   distribution_list_ IN  VARCHAR2 )
IS
   prt_job_id_     NUMBER;
   prt_job_attr_   VARCHAR2(4000);
   grp_attr_       VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('PRINTER_ID', Client_SYS.Get_Item_Value('PRINTER_ID', group_attr_), prt_job_attr_);
   Client_SYS.Add_To_Attr('SETTINGS', Client_SYS.Get_Item_Value('SETTINGS', group_attr_), prt_job_attr_);
   Print_Job_API.New(prt_job_id_, prt_job_attr_);
   grp_attr_ := group_attr_;
   Client_SYS.Add_To_Attr('PRINT_JOB_ID', prt_job_id_, grp_attr_);
   Report_SYS.Run_Group(grp_attr_, parameter_attr_);
   print_job_id_ := prt_job_id_;
END Create_Print_Job;


@UncheckedAccess
PROCEDURE Get_Instance_Info (
   instance_attr_  OUT VARCHAR2,
   parameter_attr_ OUT VARCHAR2,
   variable_attr_  OUT VARCHAR2,
   result_key_     IN  NUMBER )
IS
   var_attr_ VARCHAR2(32000);
   tmp_attr_ VARCHAR2(32000);
BEGIN
   Get_Info(instance_attr_, parameter_attr_, result_key_);
   Archive_Variable_API.Enumerate_String(tmp_attr_, result_key_);
   var_attr_ := var_attr_ || tmp_attr_ || Client_SYS.group_separator_;
   Archive_Variable_API.Enumerate_Number(tmp_attr_, result_key_);
   var_attr_ := var_attr_ || tmp_attr_ || Client_SYS.group_separator_;
   Archive_Variable_API.Enumerate_Date(tmp_attr_, result_key_);
   var_attr_ := var_attr_ || tmp_attr_ || Client_SYS.group_separator_;
   Archive_Variable_API.Enumerate_Object(tmp_attr_, result_key_);
   var_attr_ := var_attr_ || tmp_attr_ || Client_SYS.group_separator_;
   variable_attr_ := var_attr_;
END Get_Instance_Info;




PROCEDURE Set_Pdf_File_Name (
   result_key_    IN NUMBER,
   lang_code_     IN VARCHAR2,
   pdf_file_name_ IN VARCHAR2 )
IS
   tmp_lang_code_ VARCHAR2(5);
BEGIN
   IF (lang_code_ IS NULL) THEN
      tmp_lang_code_ := upper(Fnd_Session_API.Get_Language);
   ELSE
      tmp_lang_code_ := upper(lang_code_);
   END IF;
   Archive_File_Name_API.Set_Pdf_File_Name(result_key_, tmp_lang_code_, pdf_file_name_);
END Set_Pdf_File_Name;


@UncheckedAccess
FUNCTION Get_Pdf_File_Name (
   result_key_ IN NUMBER ) RETURN VARCHAR2
IS
   tmp_lang_code_ ARCHIVE_TAB.lang_code%TYPE;
   CURSOR get_attr IS
      SELECT upper(lang_code)
      FROM ARCHIVE_TAB
      WHERE result_key = result_key_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO tmp_lang_code_;
   CLOSE get_attr;
   IF (tmp_lang_code_ IS NULL) THEN
      tmp_lang_code_:= upper(Fnd_Session_API.Get_Property('LANGUAGE'));
   END IF;
   RETURN (Archive_File_Name_API.Get_Pdf_File_Name(result_key_, tmp_lang_code_));
END Get_Pdf_File_Name;

@UncheckedAccess
FUNCTION Is_Br_Report_Rendering_Done (
   report_id_  IN VARCHAR2,
   result_key_ IN NUMBER) RETURN VARCHAR2
IS
BEGIN
$IF Component_Biserv_SYS.INSTALLED $THEN   
   RETURN Excel_Report_Archive_API.Is_Rendering_Over(report_id_, result_key_);
$ELSE
   RETURN 'TRUE';
$END
END Is_Br_Report_Rendering_Done;

@UncheckedAccess
FUNCTION Get_Excel_Report_File (
   report_id_  IN VARCHAR2,
   result_key_ IN NUMBER) RETURN BLOB
IS
BEGIN
$IF Component_Biserv_SYS.INSTALLED $THEN   
   RETURN Excel_Report_Archive_API.Get_Report_File(report_id_, result_key_);
$ELSE
   RETURN empty_blob();
$END
END Get_Excel_Report_File;

PROCEDURE New_Quick_Report_Instance(
    result_key_ OUT NUMBER)
IS
BEGIN
  Report_SYS.Get_Result_Key__(result_key_);
  Init_Archive_Item(result_key_,'ARCHIVED_QUICK_REPORT',null,null);
  Archive_Distribution_API.New_Entry_Distribution__(result_key_,'',sysdate, '', false);   
END New_Quick_Report_Instance;

PROCEDURE Send_Report_To_Docman(
   result_key_     IN NUMBER,
   pdf_archive_id_ IN VARCHAR2,
   in_doc_no_      IN VARCHAR2,   
   in_doc_class_   IN VARCHAR2,
   doc_title_      IN VARCHAR2,
   doc_lu_         IN VARCHAR2,
   doc_key_ref_    IN VARCHAR2,
   send_stream_    IN VARCHAR2)
IS 
   stream_         fnd_stream_tab%ROWTYPE;
   doc_no_         VARCHAR2(120) := in_doc_no_;
   doc_class_      VARCHAR2(12) := in_doc_class_;
   doc_sheet_      VARCHAR2(12);
   doc_rev_        VARCHAR2(12);
   stmt_           VARCHAR2(200);
   null_           VARCHAR2(1) := NULL;
   
BEGIN
   IF Installation_SYS.Method_Exist('DOCUMENT_REPORT_ARCHIVE_API','Check_In_Report') THEN
      stmt_ := 'BEGIN ' ||
               '   Document_Report_Archive_API.Check_In_Report(:P1,:P2,:P3,:P4,:P5,:P6,:P7,:P8,:P9,:P10); '||
               'END;';
      @ApproveDynamicStatement(2016-05-04,DASVSE)
      EXECUTE IMMEDIATE stmt_ using IN OUT doc_no_,IN OUT doc_class_, doc_title_, null_, result_key_, pdf_archive_id_, doc_lu_, doc_key_ref_ , OUT doc_sheet_, OUT doc_rev_ ;   
      IF(send_stream_= 'TRUE') THEN
         stream_.message_id := NULL;
         IF Archive_API.Get_Report_Id(result_key_)='ARCHIVED_QUICK_REPORT'  THEN
            stream_.message := Language_SYS.Translate_Constant(lu_name_,'XLQRREADY: Excel Quick Report is ready!', NULL);
         ELSE
            stream_.message := Language_SYS.Translate_Constant(lu_name_,'PRTJOBRDYSUBJ: Report order is ready', NULL);
         END IF;
         stream_.header := 'Document ' || doc_no_;
         stream_.stream_type := Fnd_Stream_Type_API.DB_GENERAL;
         stream_.to_user := Fnd_Session_API.Get_Fnd_User();
         stream_.url := 'ifsapf:frmDocumentContainer?DOC_CLASS='||doc_class_||'&'||'DOC_NO='||doc_no_||'&'||'DOC_SHEET='||doc_sheet_||'&'||'DOC_REV='||doc_rev_||'&'||'ACTION=VIEW';

         IF Archive_API.Get_Report_Id(result_key_)='ARCHIVED_QUICK_REPORT'  THEN      
            stream_.notes := Language_SYS.Translate_Constant(lu_name_,'XLQRNOTE: A quick report has finished executing and the result is available as a new document revision.',NULL);
         ELSE
            stream_.notes := Language_SYS.Translate_Constant(lu_name_,'PRTJOBRDYFILE: Report Order :P1', NULL, result_key_);
         END IF;
         --stream_.reference := 'reference test';
         stream_.lu_name := 'Archive';
         Fnd_Stream_API.New_Stream_Item(stream_);
      END IF;
   END IF;
END Send_Report_To_Docman;

