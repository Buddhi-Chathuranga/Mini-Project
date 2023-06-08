-----------------------------------------------------------------------------
--
--  Logical unit: CreateCompanyTemLog
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010517  LaLi    Created
--  010627  Gawilk  Fixed bug # 15677. Checked General_SYS.Init_Method.
--  121023  Chwilk  Bug 106070, Added Transaction Statement Approved Annotation.
--  130708  Shhelk  TIBE-762, Remove global variables.
--  130911  DipeLK  TIBE-3130, Corrected ERROR from TIBE-762 in the Get_Log_Id___  method
--  131016  Isuklk  CAHOOK-2739 Refactoring in CreateCompanyTemLog.entity
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Log_Id___ RETURN NUMBER
IS
BEGIN
  RETURN App_Context_SYS.Find_Number_Value('CREATE_COMPANY_TEM_LOG_API.template_log_id_', -1);
END Get_Log_Id___;


PROCEDURE Insert_Autonomous___ (
   rec_     IN create_company_tem_log_tab%ROWTYPE)
IS
   newrec_     create_company_tem_log_tab%ROWTYPE;
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   newrec_ := rec_;
   newrec_.rowversion := SYSDATE;
   INSERT
      INTO create_company_tem_log_tab (
         log_id,
         row_no,
         user_id,
         log_date,
         template_id,
         component,
         lu,
         log_text,
         rowversion)
      VALUES (
         newrec_.log_id,
         newrec_.row_no,
         newrec_.user_id,
         newrec_.log_date,
         newrec_.template_id,
         newrec_.component,
         newrec_.lu,
         newrec_.log_text,
         newrec_.rowversion);
   @ApproveTransactionStatement(2012-10-23,chwilk)
   COMMIT;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert_Autonomous___;


PROCEDURE Reset_Log___(
   server_output_ BOOLEAN DEFAULT FALSE)
IS
   error_exist_         VARCHAR2(5) := 'FALSE';
   error_text_          VARCHAR2(2000);
   text_                VARCHAR2(256);
   template_log_id_     NUMBER;
   initiated_by_client_ BOOLEAN; 
BEGIN
   initiated_by_client_ := App_Context_SYS.Find_Boolean_Value('CREATE_COMPANY_TEM_LOG_API.Initiated_By_Client_', FALSE);
   IF (NOT initiated_by_client_) THEN
      -- Typically if the template is installed through SqlPlus to write
      -- output if any error occured (and showing first error found) during installation.
      IF (server_output_) THEN
         template_log_id_   := App_Context_SYS.Find_Number_Value('CREATE_COMPANY_TEM_LOG_API.template_log_id_', -1);
         Get_First_Error___(error_exist_, error_text_, template_log_id_);
         IF (error_exist_ = 'TRUE') THEN
            text_  := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'INSTTEMPLERR: The Company Template is imported with errors.'),1,256); 
            Dbms_Output.Put_Line(text_);
            text_  := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'INSTTEMPLERR2: First error found [:P1] ', NULL, error_text_),1,256); 
            Dbms_Output.Put_Line(text_);
            text_  := SUBSTR(Language_SYS.Translate_Constant(lu_name_, 'INSTTEMPLER3: Check Company Template Log Id: :P1 for complete log', NULL, template_log_id_),1,256); 
            Dbms_Output.Put_Line(text_);
         END IF;
      END IF;
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.template_log_id_',-1); 
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.template_log_date_',TO_DATE(NULL));
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.Initiated_By_Client_',FALSE);
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.previous_row_no_',0);       
   END IF;
END Reset_Log___;


PROCEDURE Get_First_Error___(
   error_exist_ OUT VARCHAR2,
   first_error_ OUT VARCHAR2,
   log_id_      IN  NUMBER )
IS
   log_text_  create_company_tem_log_tab.log_text%TYPE;
   CURSOR rows_exist IS
      SELECT log_text
      FROM create_company_tem_log_tab
      WHERE log_id = log_id_
      ORDER BY row_no ASC;
BEGIN
   error_exist_ := 'FALSE';
   OPEN rows_exist;
   FETCH rows_exist INTO log_text_;
   IF (rows_exist%FOUND) THEN
      error_exist_ := 'TRUE';
   END IF;
   first_error_ := log_text_;
   CLOSE rows_exist;
END Get_First_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Initiate_Log__
IS
   log_id_              create_company_tem_log_tab.log_id%TYPE;
   initiated_by_client_ BOOLEAN;
   CURSOR Get_New_Id IS
      SELECT create_company_tem_log_seq.NEXTVAL
      FROM dual;
BEGIN
   initiated_by_client_ := App_Context_SYS.Find_Boolean_Value('CREATE_COMPANY_TEM_LOG_API.Initiated_By_Client_', FALSE);
   IF (NOT initiated_by_client_) THEN
      Reset_Log__;
      OPEN Get_New_Id;
      FETCH Get_New_Id INTO log_id_;
      CLOSE Get_New_Id;
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.template_log_id_', log_id_);
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.template_log_date_', SYSDATE);
   END IF;
END Initiate_Log__;


PROCEDURE Initiate_Log_Client__ (
   log_id_ OUT VARCHAR2 )
IS
BEGIN
   App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.Initiated_By_Client_', FALSE);
   Initiate_Log__;
   log_id_ := Get_Log_Id___;
   App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.Initiated_By_Client_', TRUE);
END Initiate_Log_Client__;


PROCEDURE Reset_Log__
IS
BEGIN
   Reset_Log___(TRUE);
END Reset_Log__;


PROCEDURE Reset_Log_Client__
IS
BEGIN
   App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.Initiated_By_Client_', FALSE);
   Reset_Log___(FALSE);
END Reset_Log_Client__;


PROCEDURE Error_Exist__ (
   exist_  OUT VARCHAR2,
   log_id_ IN  NUMBER )
IS
   idum_  NUMBER;
   CURSOR rows_exist IS
      SELECT 1
      FROM   create_company_tem_log_tab
      WHERE  log_id = log_id_;
BEGIN
   exist_ := 'FALSE';
   OPEN rows_exist;
   FETCH rows_exist INTO idum_;
   IF (rows_exist%FOUND) THEN
      exist_ := 'TRUE';
   END IF;
   CLOSE rows_exist;
END Error_Exist__;


PROCEDURE Log_Error__ (
   error_text_  IN VARCHAR2,
   template_id_ IN VARCHAR2,
   component_   IN VARCHAR2,
   lu_          IN VARCHAR2 DEFAULT NULL )
IS
   newrec_            create_company_tem_log_tab%ROWTYPE;
   current_user_id_   VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   previous_row_no_   NUMBER;
   template_log_id_   NUMBER;
   template_log_date_ DATE;
BEGIN
   template_log_id_   := App_Context_SYS.Find_Number_Value('CREATE_COMPANY_TEM_LOG_API.template_log_id_', -1);
   previous_row_no_   := App_Context_SYS.Find_Number_Value('CREATE_COMPANY_TEM_LOG_API.previous_row_no_', 0);
   template_log_date_ := App_Context_SYS.Find_Date_Value('CREATE_COMPANY_TEM_LOG_API.template_log_date_', SYSDATE);
   IF (template_log_id_ != -1) THEN
      newrec_.log_id       := template_log_id_;
      newrec_.row_no       := previous_row_no_ + 1;   
      newrec_.user_id      := current_user_id_;
      newrec_.log_date     := template_log_date_;   
      IF (template_id_ IS NULL) THEN
         newrec_.template_id  := 'NULL';
      ELSE
         newrec_.template_id  := template_id_;
      END IF;
      IF (component_ IS NULL) THEN
         newrec_.component    := 'NULL';
      ELSE
         newrec_.component    := component_;
      END IF;
      IF (lu_ IS NULL) THEN
         newrec_.lu           := 'NULL';
      ELSE
         newrec_.lu           := lu_;
      END IF;
      newrec_.log_text     := SUBSTR(error_text_,1,2000);          
      Error_SYS.Check_Not_Null(lu_name_, 'LOG_ID', newrec_.log_id);
      Error_SYS.Check_Not_Null(lu_name_, 'ROW_NO', newrec_.row_no);
      Error_SYS.Check_Not_Null(lu_name_, 'USER_ID', newrec_.user_id);
      Error_SYS.Check_Not_Null(lu_name_, 'LOG_DATE', newrec_.log_date);
      Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', newrec_.template_id);
      Error_SYS.Check_Not_Null(lu_name_, 'COMPONENT', newrec_.component);
      Error_SYS.Check_Not_Null(lu_name_, 'LOG_TEXT', newrec_.log_text);
      Insert_Autonomous___(newrec_);
      App_Context_SYS.Set_Value('CREATE_COMPANY_TEM_LOG_API.previous_row_no_', newrec_.row_no);   
   END IF;      
END Log_Error__;
                                                                               
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

