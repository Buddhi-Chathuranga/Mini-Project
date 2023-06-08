-----------------------------------------------------------------------------
--
--  Logical unit: MediaArchiveFileUtil
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170703  PRDALK  Bug 136626, Created.
--  200128  chanlk  SAZDOC-365, Modified to popup error msgs instrad of raising oracle errors.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Save_Media_Item(
   archive_no_ IN NUMBER,
   media_id_   IN NUMBER,
   media_body_ IN BLOB,
   lang_code_  IN VARCHAR2 DEFAULT NULL)
IS
   file_                UTL_FILE.FILE_TYPE;
   buffer_              RAW(32767);
   amount_              BINARY_INTEGER := 32767;
   pos_                 INTEGER := 1;
   
   directory_name_      VARCHAR2(100);
   file_name_           VARCHAR2(100);
   
   blob_length_         NUMBER;
   err_msg_             VARCHAR2(1000);
BEGIN
   directory_name_ := Get_Directory_Name(archive_no_);
   blob_length_ := DBMS_LOB.getlength(media_body_);
   file_name_ := Get_File_Name(media_id_, lang_code_);
   
   -- Open the destination file.
   file_ := UTL_FILE.fopen(directory_name_, file_name_,'wb', 32767);
   
   -- Read chunks of the BLOB and write them to the file until complete.
   WHILE pos_ < blob_length_ LOOP
      DBMS_LOB.read(media_body_, amount_, pos_, buffer_);
      UTL_FILE.put_raw(file_, buffer_, TRUE);
      pos_ := pos_ + amount_;
   END LOOP;
   
   -- Close the file.
   UTL_FILE.fclose(file_);
EXCEPTION
   WHEN OTHERS THEN
      -- Close the file if something goes wrong.
      err_msg_ := SUBSTR(SQLERRM, 1, 200);
      IF UTL_FILE.is_open(file_) THEN
         UTL_FILE.fclose(file_);
      END IF;
      Error_SYS.record_General(lu_name_, 'RESPERROR: Oracle file storage returned following error: :P1. This can be due to an invalid file path or missing access rights to the directory. Check the path and make sure Oracle can access it.', err_msg_);
END Save_Media_Item;


FUNCTION Get_Media_Item(
   archive_no_ IN NUMBER,
   media_id_   IN NUMBER,
   lang_code_  IN VARCHAR2 DEFAULT NULL) RETURN BLOB
IS
   media_item_blob_     BLOB;
   dest_offset_         NUMBER := 1;
   src_offset_          NUMBER := 1;
   
   directory_name_      VARCHAR2(100);
   file_name_           VARCHAR2(1000);
   bfile_               BFILE;
   err_msg_             VARCHAR2(1000);
BEGIN
   directory_name_ := Get_Directory_Name(archive_no_);
   file_name_ := Get_File_Name(media_id_, lang_code_);
   bfile_ := BFILENAME(directory_name_, file_name_);
   
   DBMS_LOB.createtemporary(lob_loc => media_item_blob_, cache => TRUE, dur => dbms_lob.call);
   DBMS_LOB.open(bfile_, DBMS_LOB.lob_readonly);
   
   DBMS_LOB.loadblobfromfile(dest_lob    => media_item_blob_,
                             src_bfile   => bfile_,
                             amount      => DBMS_LOB.lobmaxsize,
                             dest_offset => dest_offset_,
                             src_offset  => src_offset_);
   
   -- Close the file
   DBMS_LOB.close(bfile_);
   
   RETURN media_item_blob_;
EXCEPTION
   WHEN OTHERS THEN
      -- Close the file
      err_msg_ := SUBSTR(SQLERRM, 1, 200);
      DBMS_LOB.close(bfile_);
      Error_SYS.record_General(lu_name_, 'RESPERROR: Oracle file storage returned following error: :P1. This can be due to an invalid file path or missing access rights to the directory. Check the path and make sure Oracle can access it.', err_msg_);
END;


PROCEDURE Delete_Media_Item(
   success_    OUT VARCHAR2,
   archive_no_ IN  NUMBER,
   media_id_   IN  NUMBER,
   lang_code_  IN  VARCHAR2 DEFAULT NULL)
IS
   directory_name_      VARCHAR2(100);
   file_name_           VARCHAR2(100);   
   err_msg_             VARCHAR2(1000);
BEGIN
   directory_name_ := Get_Directory_Name(archive_no_);
   file_name_ := Get_File_Name(media_id_, lang_code_);
   UTL_FILE.fremove(directory_name_, file_name_);
   success_ := 'TRUE';
EXCEPTION
   WHEN OTHERS THEN
      success_ := 'FALSE';
      err_msg_ := SUBSTR(SQLERRM, 1, 200);
      IF (Transaction_SYS.Is_Session_Deferred()) THEN
         Transaction_SYS.Log_Status_Info('RESPERRORBG: Oracle file storage returned following error: '|| err_msg_||'.', 'WARNING');
      ELSE 
         Error_SYS.record_General(lu_name_, 'RESPERROR: Oracle file storage returned following error: :P1.', err_msg_);
      END IF;
END;


PROCEDURE Create_Directory(
   archive_no_ IN NUMBER,
   path_       IN VARCHAR2)
IS
   exec_string_      VARCHAR2(1024) := 'CREATE OR REPLACE DIRECTORY ';
   directory_name_   VARCHAR2(100);
BEGIN
   directory_name_ := Get_Directory_Name(archive_no_);
   exec_string_ := exec_string_ || directory_name_ || ' AS ' || '''' || path_ || '''' ;
   
   @ApproveDynamicStatement(2017-06-26,prdalk)
   EXECUTE IMMEDIATE(exec_string_);
END Create_Directory;


PROCEDURE Remove_Directory(
   archive_no_ IN NUMBER,
   path_       IN VARCHAR2)
IS
   CURSOR check_directory_exists_(dir_name_ VARCHAR2) IS
      SELECT 1
      FROM all_directories
      WHERE directory_name = dir_name_;
   
   exec_string_      VARCHAR2(1024) := 'DROP DIRECTORY ';
   directory_name_   VARCHAR2(100);
   exists_           NUMBER;
BEGIN
   directory_name_ := Get_Directory_Name(archive_no_);
   
   OPEN check_directory_exists_(directory_name_);
   FETCH check_directory_exists_ INTO exists_;
   IF check_directory_exists_%FOUND THEN
      exec_string_ := exec_string_ || directory_name_;
      @ApproveDynamicStatement(2017-06-26,prdalk)
      EXECUTE IMMEDIATE(exec_string_);
   END IF;
   CLOSE check_directory_exists_;
   
END Remove_Directory;


FUNCTION Get_File_Name(
   media_id_  IN NUMBER,
   lang_code_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   file_name_     VARCHAR2(100);
   extension_     VARCHAR2(5) := '.file';
BEGIN
   file_name_ := 'ifs_media_item_' || media_id_;
   IF lang_code_ IS NULL THEN
      file_name_ := file_name_ || extension_;
   ELSE
      file_name_ := file_name_ || '_' || lang_code_ || extension_;
   END IF;
   RETURN file_name_;
END Get_File_Name;


FUNCTION Get_Directory_Name(
   archive_no_ IN NUMBER) RETURN VARCHAR2
IS
   directory_name_   VARCHAR2(100) := 'IFS_MEDIA_ARCHIVE_DIR_';
BEGIN
   directory_name_ := directory_name_ || archive_no_;
   RETURN directory_name_;
END;

-------------------- LU  NEW METHODS -------------------------------------
