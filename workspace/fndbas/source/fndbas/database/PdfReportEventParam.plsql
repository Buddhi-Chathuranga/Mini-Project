-----------------------------------------------------------------------------
--
--  Logical unit: PdfReportEventParam
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date     Sign    History
--  ------   ------  ---------------------------------------------------------
--  20140525 NaBaLK  Support for new pdf report event parameter defining functionality (TEREPORT-1150)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Parameters (
   report_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_params IS
      SELECT param_name, param_value
        FROM pdf_report_event_param_tab
       WHERE report_id = report_id_;
   pdf_info_ VARCHAR2(4000);
BEGIN
   pdf_info_ := Message_SYS.Construct('PDF_PARAM');
   FOR rec_ IN get_params LOOP
      Message_SYS.Add_Attribute(pdf_info_, rec_.param_name, rec_.param_value);
   END LOOP;
   RETURN pdf_info_;
END Get_Parameters;

PROCEDURE New_Parameter (
   report_id_ IN VARCHAR2,
   param_name_ IN VARCHAR2,
   param_type_ IN VARCHAR2,
   param_value_ IN VARCHAR2 )
IS
   newrec_     pdf_report_event_param_tab%ROWTYPE;
   new_attr_   VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   newrec_.report_id := report_id_;
   newrec_.param_name := param_name_;
   newrec_.param_type := param_type_;
   newrec_.param_value := param_value_;
   Insert___(objid_, objversion_, newrec_, new_attr_);
END New_Parameter;
