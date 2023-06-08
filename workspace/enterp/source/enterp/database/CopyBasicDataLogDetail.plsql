-----------------------------------------------------------------------------
--
--  Logical unit: CopyBasicDataLogDetail
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
   log_id_          IN  NUMBER,
   company_         IN  VARCHAR2,
   value_           IN  VARCHAR2,
   status_          IN  VARCHAR2,
   message_text_    IN  VARCHAR2 DEFAULT NULL)
IS
   newrec_          copy_basic_data_log_detail_tab%ROWTYPE;
BEGIN
   newrec_.log_id                  := log_id_;
   newrec_.target_company          := company_;
   newrec_.value                   := value_;
   newrec_.status                  := status_;
   newrec_.message_text            := message_text_;
   newrec_.timestamp               := SYSDATE;
   New___(newrec_);
END Create_New_Record;


FUNCTION Check_Status (
   log_id_       IN NUMBER) RETURN VARCHAR2
IS
   error_           VARCHAR2(5) := 'FALSE';
   non_error_       VARCHAR2(5) := 'FALSE';
   log_status_      VARCHAR2(100);
   CURSOR check_detail_status IS
      SELECT DISTINCT status
      FROM   copy_basic_data_log_detail_tab
      WHERE  log_id = log_id_;   
BEGIN
   FOR i IN check_detail_status LOOP
      IF (i.status = 'ERROR') THEN
         error_ := 'TRUE';
      ELSIF (i.status <> 'ERROR') THEN
         non_error_ := 'TRUE';
      END IF;   
   END LOOP;
   IF (error_ = 'TRUE' AND non_error_ = 'TRUE') THEN
      log_status_ := 'PARTIALLY_SUCCESSFUL';
   ELSIF (error_ = 'TRUE' AND non_error_ = 'FALSE') THEN
      log_status_ := 'ERROR';
   ELSIF (error_ = 'FALSE' AND non_error_ = 'TRUE') THEN
      log_status_ := 'SUCCESSFUL';
   END IF;
   RETURN log_status_;
END Check_Status;