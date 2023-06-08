-----------------------------------------------------------------------------
--
--  Logical unit: FndLicenseMetricResult
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Log_Result(metric_ IN VARCHAR2)
IS 
   newrec_ fnd_license_metric_result_tab%ROWTYPE;
BEGIN
   newrec_.metric := metric_;
   newrec_.id := fnd_license_metric_result_seq.NEXTVAL;
   newrec_.taken_at := sysdate;
   newrec_.value := Fnd_License_Metric_API.Calculate_Metric(metric_);
   IF newrec_.value IS NULL  THEN 
      newrec_.value := ' ';
   END IF;
   New___(newrec_);
END Log_Result;

PROCEDURE Log_All_Results 
IS
   CURSOR all_license_metrics IS
   SELECT metric FROM fnd_license_metric;
BEGIN
   FOR metric_ IN all_license_metrics
   LOOP
      Log_Result(metric_.metric);
   END LOOP;
END Log_All_Results;

FUNCTION Key_Value_Formatting(value_ VARCHAR2) RETURN VARCHAR2
IS 
   temp_ VARCHAR2(32000):= value_;
BEGIN
   temp_:= REGEXP_REPLACE(value_,',',','|| chr(10));
   temp_:= REGEXP_REPLACE(temp_, chr(31),'=');
   temp_:= REGEXP_REPLACE(temp_, chr(30), ',' || chr(10));
   temp_:= REGEXP_REPLACE(temp_, ','||chr(10)||'$' , '');
   RETURN temp_;
END Key_Value_Formatting;

FUNCTION Print_Job_Exists___ (
   print_job_id_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   Print_Job_API.Exist(print_job_id_);
   RETURN TRUE;
EXCEPTION
   WHEN OTHERS THEN
      RETURN FALSE;
END Print_Job_Exists___;

PROCEDURE License_Metrics_Report
IS
   result_key_      NUMBER;
   report_attr_     VARCHAR2(2000);
   param_attr_      VARCHAR2(2000);
   print_job_id_    NUMBER := NULL;
   parameter_attr_    VARCHAR2(2000);
   instance_attr_     VARCHAR2(32000);
   lang_code_         VARCHAR2(2);
   job_attr_          VARCHAR2(2000);
   job_contents_attr_ VARCHAR2(2000);
   
BEGIN
   
   -- generate report 
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', 'LICENSE_METRIC_REP', report_attr_);
   Archive_API.New_Instance(result_key_,report_attr_,param_attr_);
     
   --Note: Get the language code from archive instance
   Client_SYS.Clear_Attr(instance_attr_);
   Client_SYS.Clear_Attr(parameter_attr_);
   Archive_API.Get_Info(instance_attr_, parameter_attr_, result_key_);   
   lang_code_ := Client_SYS.Get_Item_Value('LANG_CODE', instance_attr_);
   
   Client_SYS.Clear_Attr(job_attr_);
   Client_SYS.Clear_Attr(job_contents_attr_);
   Client_SYS.Add_To_Attr('PRINTER_ID','NO_PRINTOUT', job_attr_);   
   Client_SYS.Add_To_Attr('RESULT_KEY', result_key_, job_contents_attr_);
   Client_SYS.Add_To_Attr('LANG_CODE', lang_code_, job_contents_attr_);
   Client_SYS.Add_To_Attr('LAYOUT_NAME','LicenseMetric.rdl',job_contents_attr_); 

   -- Generate a new print job ids and Connect the created report  
   Print_Job_API.New_Print_Job(print_job_id_, job_attr_, job_contents_attr_);
    
    -- print the report
   IF (Print_Job_Exists___(print_job_id_)) THEN
      Print_Job_API.Print(print_job_id_);
   END IF;
    
END License_Metrics_Report;

PROCEDURE Collect_License_Metric_Results 
IS
BEGIN
   Log_All_Results;
   License_Metrics_Report;
END Collect_License_Metric_Results;