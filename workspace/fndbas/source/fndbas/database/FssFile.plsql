-----------------------------------------------------------------------------
--
--  Logical unit: FssFile
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

@Override
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT NOCOPY fss_file_tab%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT NOCOPY VARCHAR2 )
IS
   file_scan_enabled_   VARCHAR2(50);
   state_event_         VARCHAR2(50); 
BEGIN
   state_event_ := event_;
   IF (rec_.rowstate IS NULL AND event_ IS NULL) THEN
      file_scan_enabled_ := Fnd_Setting_API.Get_Value('FILE_SCAN');
      IF (file_scan_enabled_ = 'DISABLED') THEN
         state_event_ := 'SetScanDisabled';
      ELSE
         state_event_ := 'SetQueuedForScanning';
      END IF;
   END IF;
   super(rec_, state_event_, attr_);
END Finite_State_Machine___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_File_Ref_Rec (
   file_scan_enabled_   OUT VARCHAR2,
   file_id_             IN VARCHAR2,
   lu_name_             IN VARCHAR2,
   file_name_           IN VARCHAR2,
   file_extension_      IN VARCHAR2,
   file_type_           IN VARCHAR2,
   file_length_         IN NUMBER,
   directory_id_        IN VARCHAR2)
IS
   newrec_  fss_file_tab%ROWTYPE;
   identity_   fnd_user.identity%TYPE := Fnd_User_API.Get_Web_User_Identity_(UPPER(directory_id_));
BEGIN
   newrec_.file_id := file_id_;
   newrec_.lu_name := lu_name_;
   newrec_.file_name := file_name_;
   newrec_.file_extension := file_extension_;
   newrec_.file_type := file_type_;
   newrec_.file_length := file_length_;
   newrec_.created_date := sysdate;
   newrec_.created_by := identity_;
   New___(newrec_);
   IF (newrec_.rowstate = 'ScanDisabled') THEN
      file_scan_enabled_ := 'DISABLED';
   ELSE
      file_scan_enabled_ := 'ENABLED';
   END IF;
END Create_File_Ref_Rec;


--DEPRECATED
PROCEDURE Create_File_Ref_Rec (
   file_id_          IN VARCHAR2,
   lu_name_          IN VARCHAR2,
   file_name_        IN VARCHAR2,
   file_extension_   IN VARCHAR2,
   file_type_        IN VARCHAR2,
   file_length_      IN NUMBER)
IS
   newrec_  fss_file_tab%ROWTYPE;
BEGIN
   newrec_.file_id := file_id_;
   newrec_.lu_name := lu_name_;
   newrec_.file_name := file_name_;
   newrec_.file_extension := file_extension_;
   newrec_.file_type := file_type_;
   newrec_.file_length := file_length_;
   newrec_.created_date := sysdate;
   New___(newrec_);
END Create_File_Ref_Rec;


PROCEDURE Remove_File_Ref_Rec (
   file_id_          IN VARCHAR2,
   lu_name_          IN VARCHAR2)
IS
   rec_ fss_file_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(file_id_, lu_name_);
   Remove___(rec_);
END Remove_File_Ref_Rec;


--DEPRECATED
PROCEDURE Modify_File_Ref_Rec (
   file_id_          IN VARCHAR2,
   lu_name_          IN VARCHAR2,
   file_name_        IN VARCHAR2,
   file_extension_   IN VARCHAR2,
   file_type_        IN VARCHAR2,
   file_length_      IN NUMBER)
IS
   rec_ fss_file_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(file_id_, lu_name_);
   rec_.file_name := file_name_;
   rec_.file_extension := file_extension_;
   rec_.file_type := file_type_;
   rec_.file_length := file_length_;
   rec_.modified_date := sysdate;
   Modify___(rec_);
END Modify_File_Ref_Rec;


PROCEDURE Modify_File_Ref_Rec (
   file_scan_enabled_   OUT VARCHAR2,
   file_id_             IN VARCHAR2,
   lu_name_             IN VARCHAR2,
   file_name_           IN VARCHAR2,
   file_extension_      IN VARCHAR2,
   file_type_           IN VARCHAR2,
   file_length_         IN NUMBER,
   directory_id_        IN VARCHAR2)
IS
   rec_        fss_file_tab%ROWTYPE;
   identity_   fnd_user.identity%TYPE := Fnd_User_API.Get_Web_User_Identity_(UPPER(directory_id_));
BEGIN
   rec_ := Get_Object_By_Keys___(file_id_, lu_name_);
   rec_.file_name := file_name_;
   rec_.file_extension := file_extension_;
   rec_.file_type := file_type_;
   rec_.file_length := file_length_;
   rec_.modified_by := identity_;
   rec_.modified_date := sysdate;
   file_scan_enabled_ := Fnd_Setting_API.Get_Value('FILE_SCAN');
   IF (file_scan_enabled_ = 'DISABLED') THEN
      rec_.rowstate := 'ScanDisabled';
   ELSE
      rec_.rowstate := 'QueuedForScanning';
   END IF;   
   Modify___(rec_);
END Modify_File_Ref_Rec;


PROCEDURE Set_Queued_For_Scanning (
   file_id_    IN VARCHAR2,
   lu_name_    IN VARCHAR2)
IS
   rec_ fss_file_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(file_id_, lu_name_);
   Finite_State_Set___(rec_, 'QueuedForScanning');
END Set_Queued_For_Scanning;


PROCEDURE Set_Scanning_Result (
   file_id_             IN VARCHAR2,
   lu_name_             IN VARCHAR2,
   scan_event_          IN VARCHAR2,
   av_database_version_ IN VARCHAR2,
   directory_id_        IN VARCHAR2 DEFAULT NULL,
   info_                IN VARCHAR2 DEFAULT NULL )
IS
   rec_        FSS_FILE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   info_value_ VARCHAR2(1000);
   identity_   fnd_user.identity%TYPE := Fnd_User_API.Get_Web_User_Identity_(UPPER(directory_id_));
   threat_skipped_info_ VARCHAR2(1000); 
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, file_id_, lu_name_);
   rec_ := Lock_By_Id___(objid_, objversion_);
   
   IF info_ IS NULL THEN
      info_value_ := 'State Transition';
   ELSE
      info_value_ := info_;
   END IF;

   IF scan_event_ = 'SetIncomplete' THEN
      Fnd_Blob_Scan_Info_API.Set_Scan_Info('FSS_FILE_TAB', Get_Objkey(file_id_, lu_name_), 'FSS', 'ErrorWhileScanning', identity_, av_database_version_, info_value_);
   ELSIF (scan_event_ = 'SetThreatFound' ) THEN
      threat_skipped_info_ := Fnd_Av_Scanning_Log_API.Get_Latest_Threat_Skipped_Info('FSS', rec_.rowkey);
      IF ((threat_skipped_info_ IS NOT NULL) AND (threat_skipped_info_ = info_value_)) THEN
         Finite_State_Machine___(rec_, 'SetThreatSkipped', attr_);
         Fnd_Blob_Scan_Info_API.Update_Av_Database_Version('FSS', rec_.rowkey, av_database_version_);
      ELSE
         Finite_State_Machine___(rec_, scan_event_, attr_);
         Fnd_Blob_Scan_Info_API.Set_Scan_Info('FSS_FILE_TAB', Get_Objkey(file_id_, lu_name_), 'FSS', scan_event_, identity_, av_database_version_, info_value_);
      END IF;
   ELSE
      Finite_State_Machine___(rec_, scan_event_, attr_);
      Fnd_Blob_Scan_Info_API.Set_Scan_Info('FSS_FILE_TAB', Get_Objkey(file_id_, lu_name_), 'FSS', scan_event_, identity_, av_database_version_, info_value_);
   END IF;
END Set_Scanning_Result;


PROCEDURE Set_Threat_Skipped (
   file_id_       IN VARCHAR2,
   lu_name_       IN VARCHAR2,
   threat_info_   IN VARCHAR2 )
IS
   rec_ fss_file_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(file_id_, lu_name_);
   Finite_State_Set___(rec_, 'ThreatSkipped');
   Fnd_Av_Scanning_Log_API.Log_Scanner_Event('FSS_FILE_TAB', Get_Objkey(file_id_, lu_name_), 'SetThreatSkipped', 'FSS', threat_info_, Fnd_Session_API.Get_Fnd_User);
END Set_Threat_Skipped;


PROCEDURE Log_Scanner_Event(
   file_id_       IN VARCHAR2,
   lu_name_       IN VARCHAR2,
   event_         IN VARCHAR2,
   info_          IN VARCHAR2 DEFAULT '',
   directory_id_  IN VARCHAR2 DEFAULT '' )
IS
   ref_rowkey_ fss_file_tab.rowkey%TYPE;
   identity_   fnd_user.identity%TYPE := Fnd_User_API.Get_Web_User_Identity_(UPPER(directory_id_));
BEGIN
   ref_rowkey_ := Get_Objkey(file_id_, lu_name_);
   IF ref_rowkey_ IS NOT NULL THEN
      Fnd_Av_Scanning_Log_API.Log_Scanner_Event('FSS_FILE_TAB', ref_rowkey_, event_, 'FSS', info_, identity_);
   ELSE
      Error_SYS.Fnd_Record_Not_Exist(Fss_File_API.lu_name_);
   END IF;
END Log_Scanner_Event;

