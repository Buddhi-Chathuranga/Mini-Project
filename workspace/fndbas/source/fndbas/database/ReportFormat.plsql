-----------------------------------------------------------------------------
--
--  Logical unit: ReportFormat
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

FUNCTION Create_New_Report (
   report_attr_      IN VARCHAR2,
   parameter_values_ IN VARCHAR2,
   distrib_list_     IN VARCHAR2 ) RETURN NUMBER
IS
   result_key_  NUMBER;
   dist_list_   VARCHAR2(4000);  
   report_id_   VARCHAR2(2000);   
   BEGIN       
      dist_list_ := distrib_list_ || client_sys.field_separator_;
      report_id_ :=Client_SYS.Get_Item_Value('REPORT_ID', report_attr_);
      IF security_sys.Is_Projection_Available_(Aurena_Report_Metadata_SYS.Get_Projection_Name__(report_id_)) ='TRUE' THEN
         Archive_API.New_Client_Report(result_key_, report_attr_,  parameter_values_,dist_list_, null);
         IF(result_key_ IS NOT NULL) THEN
            -- Result Key could be NULL when timeouts occur.
            Update_Report_Format(result_key_);         
         END IF;
      ELSE
         result_key_ := NULL;
         Error_SYS.System_General('REP_NOT_ALLOWED: You are not allowed to execute the Report');         
      END IF;
      RETURN  result_key_ ;   
   END Create_New_Report;

--framework only method  
FUNCTION Create_New_Report__ (
   report_attr_     IN VARCHAR2,
   parameter_values_ IN VARCHAR2,
   distrib_list_    IN VARCHAR2 ) RETURN NUMBER
IS
   result_key_  NUMBER;
   dist_list_ VARCHAR2(4000);
   report_id_ VARCHAR2(2000);   
      
BEGIN       
   dist_list_ := distrib_list_ || client_sys.field_separator_;
   report_id_ :=Client_SYS.Get_Item_Value('REPORT_ID', report_attr_);
   IF security_sys.Is_Projection_Available_(Aurena_Report_Metadata_SYS.Get_Projection_Name__(report_id_)) ='TRUE' THEN   
      Archive_API.New_Client_Report(result_key_, report_attr_,  parameter_values_,dist_list_, null);
      IF(result_key_ IS NOT NULL) THEN
         -- Result Key could be NULL when timeouts occur.
         Update_Report_Format(result_key_);
      END IF;
   ELSE
         result_key_ := NULL;
         Error_SYS.System_General('REP_NOT_ALLOWED: You are not allowed to execute the Report');
   END IF;
   RETURN  result_key_ ;   
END Create_New_Report__;

   -- frame work use fix parameters 
FUNCTION Create_New_Report_Navigate__(
   report_attr_     IN VARCHAR2,
   parameter_values_ IN VARCHAR2,
   distrib_list_    IN VARCHAR2,
   url_  IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   RETURN Create_New_Report_Navigate(report_attr_ , parameter_values_, distrib_list_,url_ );
END Create_New_Report_Navigate__;

FUNCTION Create_New_Report_Navigate(
   report_attr_     IN VARCHAR2,
   parameter_values_ IN VARCHAR2,
   distrib_list_    IN VARCHAR2,
   url_  IN VARCHAR2) RETURN NUMBER
IS
   result_key_  NUMBER;
   dist_list_ VARCHAR2(4000);  
      
   BEGIN       
      dist_list_ := distrib_list_ || client_sys.field_separator_;   
      Archive_API.New_Client_Report(result_key_, report_attr_,  parameter_values_,dist_list_, null);
      Update_Report_Format_Navigate(result_key_,url_);
   RETURN  result_key_ ;   
END Create_New_Report_Navigate;


PROCEDURE Update_Report_Format(
   result_key_  IN NUMBER)
IS
   
BEGIN
   Update_Report_Format_Navigate(result_key_ ,NULL);
END Update_Report_Format;

--framework only 
PROCEDURE Update_Report_Format__(
   result_key_  IN NUMBER)
IS
   
BEGIN
   Update_Report_Format_Navigate(result_key_ ,NULL);
END Update_Report_Format__;

--framework only
PROCEDURE Update_Report_Format__(
   result_key_ IN NUMBER,
   report_format_rec_ IN OUT VARCHAR2,
   notes_ OUT VARCHAR2)
IS
   
BEGIN
   Update_Report_Format_Nav__(result_key_,NULL,report_format_rec_,notes_);
END Update_Report_Format__;


PROCEDURE Update_Report_Format_Navigate(
   result_key_ IN NUMBER,
   url_ IN VARCHAR2)
IS
  report_format_rec_ VARCHAR2(1000);
  notes_ VARCHAR2(1000);
BEGIN
   Update_Report_Format_Nav__(result_key_,url_,report_format_rec_,notes_);
END;

PROCEDURE Update_Report_Format_Nav__(
   result_key_          IN NUMBER,
   url_                 IN VARCHAR2,
   format_field_info_  OUT VARCHAR2,
   notes_              OUT VARCHAR2 )
IS
   format_rec_  report_format_tab%ROWTYPE;
   format_rec_new_ report_format_tab%ROWTYPE;
   print_attr_  VARCHAR2(2000);
   info_        VARCHAR2(500);
   objid_       VARCHAR2(500);
   objversion_  VARCHAR2(500);
   field_info_  VARCHAR2(1000);
   
   CURSOR archive_cur(rstl_key_ NUMBER) IS
      SELECT a.*,
             substr(Report_Definition_API.Get_Translated_Report_Title(report_id),1,50)
                                                                   report_title       
      FROM   archive_tab a, archive_distribution d
      WHERE  a.result_key = d.result_key
        AND  a.result_key = rstl_key_;
   
   archive_rec_ archive_cur%ROWTYPE;
   
   CURSOR rep_format_cur(rstl_key_ NUMBER)IS
      SELECT * 
      FROM report_format_tab
      WHERE result_key = rstl_key_;
BEGIN
   
   OPEN rep_format_cur(result_key_);
   FETCH rep_format_cur INTO format_rec_;   
   IF rep_format_cur%NOTFOUND THEN
      OPEN archive_cur(result_key_);   
      FETCH archive_cur INTO archive_rec_; 
      format_rec_.result_key := archive_rec_.result_key;
      format_rec_.report_id := archive_rec_.report_id;
      format_rec_.report_title := archive_rec_.report_title;
      format_rec_.layout_name := archive_rec_.layout_name;
      format_rec_.lang_code := archive_rec_.lang_code;
      format_rec_.lang_code_rfc3066 := Language_Code_Api.Get_Lang_Code_Rfc3066(format_rec_.lang_code);
      format_rec_.address := fnd_user_api.get_property( Fnd_Session_API.Get_Fnd_User(),'SMTP_MAIL_ADDRESS');
      Report_Rule_Engine_API.ExecuteRulesPrintDialog(result_key_ ,format_rec_,field_info_);
      format_field_info_ := field_info_;

      Client_SYS.Add_To_Attr('RESULT_KEY', format_rec_.result_key, print_attr_);
      Client_SYS.Add_To_Attr('REPORT_ID', format_rec_.report_id, print_attr_);
      Client_SYS.Add_To_Attr('REPORT_TITLE', format_rec_.report_title,print_attr_);
      Client_SYS.Add_To_Attr('LAYOUT_NAME', format_rec_.layout_name, print_attr_);
      Client_SYS.Add_To_Attr('LANG_CODE', format_rec_.lang_code, print_attr_);
      Client_SYS.Add_To_Attr('LANG_CODE_RFC3066',format_rec_.lang_code_rfc3066, print_attr_);
      Client_SYS.Add_To_Attr('PRINTER_ID',format_rec_.printer_id, print_attr_);

      Client_SYS.Add_To_Attr('DESCRIPTION',Logical_Printer_API.Get_Description(format_rec_.printer_id), print_attr_);
      Client_SYS.Add_To_Attr('COPIES',format_rec_.copies, print_attr_);

      IF format_rec_.from_page IS NOT NULL THEN
         IF format_rec_.to_page IS NOT NULL THEN
            format_rec_.pages := format_rec_.from_page||'-'|| format_rec_.to_page;
         ELSE
            format_rec_.pages := format_rec_.from_page|| '-'|| format_rec_.to_page;
         END IF;
      END IF;
      Client_SYS.Add_To_Attr('PAGES', format_rec_.pages, print_attr_);
      Client_SYS.Add_To_Attr('ADDRESS',format_rec_.address, print_attr_);

      IF url_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr('NAVIGATE_TO', url_, print_attr_);
      END IF;  
      New__(info_,objid_,objversion_, print_attr_,'DO');
      CLOSE archive_cur;
   ELSE
      format_rec_.address := fnd_user_api.get_property( Fnd_Session_API.Get_Fnd_User(),'SMTP_MAIL_ADDRESS');
      Report_Rule_Engine_API.ExecuteRulesPrintDialog(result_key_ ,format_rec_,field_info_);
      format_field_info_ := field_info_;
      format_rec_new_ := format_rec_;
      format_rec_new_.navigate_to := url_;

      OPEN archive_cur(result_key_);   
      FETCH archive_cur INTO archive_rec_; 
      notes_ := archive_rec_.notes;
      CLOSE archive_cur;

      Modify___(format_rec_new_);
   END IF;
   CLOSE rep_format_cur;  

END Update_Report_Format_Nav__;



-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

