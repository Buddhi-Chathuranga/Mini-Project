-----------------------------------------------------------------------------
--
--  Logical unit: FndBlobScanInfo
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

PROCEDURE Set_Scan_Info(
   table_name_          VARCHAR2,
   ref_rowkey_          VARCHAR2,
   agent_               VARCHAR2,
   event_               VARCHAR2,
   identity_            VARCHAR2,
   av_database_version_ VARCHAR2,
   info_                VARCHAR2 DEFAULT '' )
IS
   newrec_ fnd_blob_scan_info_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(table_name_, ref_rowkey_) THEN
      newrec_ := Get_Object_By_Keys___(table_name_, ref_rowkey_);
      newrec_.av_database_version := av_database_version_;
      Modify___(newrec_);
   ELSE
      newrec_.table_name            := table_name_;
      newrec_.ref_rowkey            := ref_rowkey_;
      newrec_.agent                 := agent_;
      newrec_.av_database_version   := av_database_version_;

      New___(newrec_);
   END IF;
   Fnd_Av_Scanning_Log_API.Log_Scanner_Event(table_name_, ref_rowkey_, event_, agent_, info_, identity_);
END Set_Scan_Info;


PROCEDURE Update_Av_Database_Version(
   table_name_          VARCHAR2,
   ref_rowkey_          VARCHAR2,
   av_database_version_ VARCHAR2)
IS
   newrec_ fnd_blob_scan_info_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(table_name_, ref_rowkey_) THEN
      newrec_ := Get_Object_By_Keys___(table_name_, ref_rowkey_);
      newrec_.av_database_version := av_database_version_;
      Modify___(newrec_);
   END IF;
END Update_Av_Database_Version;
