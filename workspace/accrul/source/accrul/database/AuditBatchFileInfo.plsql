-----------------------------------------------------------------------------
--
--  Logical unit: AuditBatchFileInfo
--  Component:    ACCRUL
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

FUNCTION Get_Next_Seq_No___(
   company_   IN VARCHAR2) RETURN NUMBER
IS
   seq_no_  NUMBER := 1;
   CURSOR get_max_seq_no IS
      SELECT MAX(id)+1
      FROM Audit_Batch_File_Info_Tab
      WHERE company = company_;
BEGIN
   OPEN get_max_seq_no;
   FETCH get_max_seq_no INTO seq_no_;
   CLOSE get_max_seq_no;
   RETURN NVL(seq_no_,1);
END Get_Next_Seq_No___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT audit_batch_file_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.id := Get_Next_Seq_No___(newrec_.company);
   newrec_.batch_job_id := Transaction_SYS.Get_Current_Job_Id;
   newrec_.error_exist := NVL(newrec_.error_exist, 'FALSE');
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Insert_Record(
   newrec_  IN Audit_Batch_File_Info_Tab%ROWTYPE )
IS
   newrecx_       Audit_Batch_File_Info_Tab%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(4000);
BEGIN
   newrecx_                := newrec_;
   newrecx_.id             := Get_Next_Seq_No___(newrec_.company);
   newrecx_.rowkey         := NULL;
   newrecx_.creation_date  := SYSDATE;
   newrecx_.created_by     := Fnd_Session_API.Get_Fnd_User;
   newrecx_.error_exist    := NVL(newrecx_.error_exist, 'FALSE');
   newrecx_.batch_job_id   := Transaction_SYS.Get_Current_Job_Id;
   Insert___ ( objid_,
               objversion_,
               newrecx_,
               attr_ );
END Insert_Record;

PROCEDURE Cleanup(
   before_date_ IN DATE)
IS
BEGIN
   IF before_date_ IS NOT NULL THEN
      DELETE
      FROM  Audit_Batch_File_Info_Tab
      WHERE creation_date < before_date_;
   END IF;
END Cleanup;