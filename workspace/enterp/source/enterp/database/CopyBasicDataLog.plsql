-----------------------------------------------------------------------------
--
--  Logical unit: CopyBasicDataLog
--  Component:    ENTERP
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

PROCEDURE Create_New_Record (
   log_id_         OUT NUMBER,
   company_        IN  VARCHAR2,
   copy_type_      IN  VARCHAR2,
   window_         IN  VARCHAR2 )
IS
   newrec_      copy_basic_data_log_tab%ROWTYPE;
   seq_number_  NUMBER;
   CURSOR get_seq_no IS
      SELECT copy_basic_data_log_seq.NEXTVAL
      FROM DUAL;
BEGIN
   OPEN  get_seq_no;
   FETCH get_seq_no INTO seq_number_;
   CLOSE get_seq_no;
   newrec_.log_id         := seq_number_;
   newrec_.copy_type      := copy_type_;
   newrec_.source_company := company_;
   newrec_.window         := window_;
   newrec_.status         := 'CREATED';
   newrec_.user_id        := Fnd_Session_API.Get_Fnd_User();
   newrec_.timestamp      := SYSDATE;
   New___(newrec_);
   log_id_ := newrec_.log_id;
END Create_New_Record;


PROCEDURE Update_Status (
   log_id_       IN NUMBER )
IS
   status_   VARCHAR2(100);
   newrec_   copy_basic_data_log_tab%ROWTYPE;
BEGIN
   status_ := Copy_Basic_Data_Log_Detail_API.Check_Status(log_id_);
   newrec_ := Get_Object_By_Keys___(log_id_);
   newrec_.status  := status_;
   Modify___(newrec_);
END Update_Status;