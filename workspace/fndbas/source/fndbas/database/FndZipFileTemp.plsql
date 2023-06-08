-----------------------------------------------------------------------------
--
--  Logical unit: FndZipFileTemp
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

FUNCTION Get_Id___ RETURN VARCHAR2
IS
   id_ VARCHAR2(1000);
BEGIN
   id_ := sys_guid();
   RETURN id_;
END Get_Id___;

FUNCTION Get_User___ RETURN VARCHAR2
IS
   user_ VARCHAR2(1000);
BEGIN
   user_ := fnd_session_api.Get_Fnd_User;
   RETURN user_;
END Get_User___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Initialize_Unzip_ RETURN VARCHAR2
IS
   unzip_id_   VARCHAR2(50):= sys_guid();
   attr_       VARCHAR2(2000);
   info_       VARCHAR2(1000);
   objid_      VARCHAR2(1000);
   objversion_ VARCHAR2(1000);
   action_     VARCHAR2(50);
BEGIN
   action_ := 'DO';
   Client_SYS.Add_To_Attr('ZIP_FILE_ID', unzip_id_, attr_); 
   Client_SYS.Add_To_Attr('FND_USER', Fnd_Session_API.Get_Fnd_User, attr_); 
   Client_SYS.Add_To_Attr('CREATED_DATE', SYSDATE, attr_);  
   Fnd_Zip_File_Temp_API.New__(info_,objid_,objversion_,attr_,action_);
   RETURN unzip_id_;
END Initialize_Unzip_;

FUNCTION Get_Id RETURN VARCHAR2
IS
BEGIN   
   RETURN Get_Id___();
END Get_Id;

FUNCTION Get_User RETURN VARCHAR2
IS
BEGIN   
   RETURN Get_User___();
END Get_User;

PROCEDURE Update_Zip_File_(
   zip_file_id_ VARCHAR2,
   file_        BLOB)
IS
   zip_id_   VARCHAR2(1000);
   zip_file_ BLOB;
BEGIN
   zip_id_ := zip_file_id_;
   zip_file_ := file_;
   
   UPDATE FND_ZIP_FILE_TEMP_TAB 
   SET ZIP_FILE=zip_file_
   WHERE zip_file_id=zip_id_;
END Update_Zip_File_;

PROCEDURE Add_Unzip_File_ (
   zip_file_id_        IN VARCHAR2,
   unzip_file_path_    IN VARCHAR2,
   unzip_file_content_ IN CLOB) 
IS
   file_path_     VARCHAR2(1000);
   file_content_  CLOB := NULL;
   zip_id_        VARCHAR2(1000);
   fnd_user_      VARCHAR2(50);
   date_ DATE;
BEGIN
   file_path_:= unzip_file_path_;
   file_content_:= unzip_file_content_;
   zip_id_ := zip_file_id_;
   fnd_user_ := Get_User();
   date_:= sysdate;
   
   INSERT INTO FND_UNZIPPED_FILE_TEMP_TAB (FILE_ID, FND_USER, FILE_PATH, FILE_CONTENT, CREATED_DATE) 
   VALUES (zip_id_, fnd_user_, file_path_, file_content_, date_ );
END Add_Unzip_File_;

PROCEDURE Delete_Zip_File___(
   zip_id_ IN VARCHAR2) 
IS
BEGIN
   DELETE 
   FROM FND_ZIP_FILE_TEMP_TAB 
   WHERE zip_file_id = zip_id_;
END Delete_Zip_File___;

PROCEDURE Delete_Unzipped_File___(
   zip_id_ IN VARCHAR2) 
IS
BEGIN
   DELETE 
   FROM FND_UNZIPPED_FILE_TEMP_TAB 
   WHERE file_id = zip_id_;
END Delete_Unzipped_File___;

PROCEDURE Delete_Zip_Files_(
   zip_id_ IN VARCHAR2) 
IS  
BEGIN  
   Delete_Zip_File___(zip_id_);
   Delete_Unzipped_File___(zip_id_);
END Delete_Zip_Files_;

PROCEDURE Cleanup_ 
IS
BEGIN
   DELETE 
   FROM FND_UNZIPPED_FILE_TEMP_TAB 
   WHERE created_date< sysdate-3;
   
   DELETE 
   FROM FND_ZIP_FILE_TEMP_TAB 
   WHERE created_date< sysdate-3;
END Cleanup_;

FUNCTION Get_Unzipped_Files(
   id_           VARCHAR2,
   user_         VARCHAR2,
   keep_records_ VARCHAR2 DEFAULT 'FALSE') RETURN FND_ZIP_OBJECT_TAB
IS
   file_list_ FND_ZIP_OBJECT_TAB := FND_ZIP_OBJECT_TAB();
   
   CURSOR unzip_cursor IS
   SELECT file_path, file_content
   FROM FND_UNZIPPED_FILE_TEMP_TAB;
   
BEGIN
   FOR rec IN unzip_cursor LOOP
      BEGIN
         file_list_.extend(1);
         file_list_(file_list_.last) := FND_ZIP_OBJECT_REC(rec.file_path,Utility_SYS.Clob_To_Blob(rec.file_content));
      END;      
   END LOOP;
   
   IF(keep_records_ = 'FALSE') THEN
      Delete_Zip_Files_(id_);
   END IF;
   
   RETURN file_list_;        
END Get_Unzipped_Files;
