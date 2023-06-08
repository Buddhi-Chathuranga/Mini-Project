-----------------------------------------------------------------------------
--
--  Logical unit: MediaArchive
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201203  MDAHSE  Add method to set archive to inactive
--  180725  ChWkLk  Bug 143218, Modified Archive_Media_Items__() to change the duplicated message constant from ARCHIVEERROR to ARCHIVEERRORGEN.
--  180301  Hasplk  STRMF-17945, Fixed key generation logic.
--  180227  Hasplk  STRMF-17759, Merged LCS patch 140228.
--  180227          180214  Hasplk  Bug 140228, Added error handling and progress information logging for archiving background job
--  171220  Chahlk  STRMF-16113,Modified Prepare_Insert__ to set Azure Storage as Default Archive method.
--  171219  Chahlk  STRMF-16114,Modified Archive_Media_Items___ to show only the No of images archived. Showing the archive no not practicle when there are many.
--  170629  Chahlk  Bug 136626, Added Archiving Support for Media Item Language.
--  170607  PRDALK  Bug 136626, Modified methods Check_Insert___() & Check_Delete___(), to create and drop the directory when
--                  inserting or deleting a Oracle File Storage archive record.
--  170530  CHAHLK  Bug 136092, Modified Archive_Media_Items__ to include already archived items in the count.
--  170529  CHAHLK  Bug 135941, Modified Archive_Media_Items__ to exclude Audio/Text media_objects from archiving.
--  170526  CHAHLK  Bug 135941, Modified Archive_Media_Items__ to exclude empty/null media_objects from archiving.
--  170412  PRDALK  Bug 135941, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(attr_);

   -- Active value will initially be set to FALSE
   Client_SYS.Add_To_Attr('ACTIVE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   -- Generate the archive no. from the media_archive_seq
   Client_SYS.Add_To_Attr('ARCHIVE_NO', media_archive_SEQ.NEXTVAL, attr_);
   Client_SYS.Add_To_Attr('ARCHIVE_METHOD', Media_Archive_Option_API.Decode('AZURE'), attr_);

END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT media_archive_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_row_count IS
      SELECT COUNT(*)
      FROM   media_archive;

   row_count_ NUMBER;
BEGIN
   OPEN get_row_count;
   FETCH get_row_count INTO row_count_;
   CLOSE get_row_count;

   IF (row_count_ > 0) THEN
      -- if there are multiple archives already available in the table,
      -- the new archive record will be set as inactive automatically when inserting
      newrec_.active := Fnd_Boolean_API.DB_FALSE;
   ELSE
      -- if the current record is the first media archive record in the table,
      -- it will be set as the Active Archive automatically when inserting.
      newrec_.active := Fnd_Boolean_API.DB_TRUE;
   END IF;
   IF newrec_.archive_ref4 IS NOT NULL THEN
      newrec_.archive_ref4 := Get_Encoded_Value(newrec_.archive_ref4);
   END IF;
   IF newrec_.wallet_password IS NOT NULL THEN
      newrec_.wallet_password := Get_Encoded_Value(newrec_.wallet_password);
   END IF;

   IF newrec_.archive_method = 'BFILE' THEN
      Media_Archive_File_Util_API.Create_Directory(newrec_.archive_no,
                                                   newrec_.archive_ref1);
   END IF;

   --Add pre-processing code here
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     MEDIA_ARCHIVE_TAB%ROWTYPE,
   newrec_     IN OUT MEDIA_ARCHIVE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF newrec_.archive_method = 'BFILE' THEN
      Media_Archive_File_Util_API.Create_Directory(newrec_.archive_no,
                                                   newrec_.archive_ref1);
   END IF; 
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN MEDIA_ARCHIVE_TAB%ROWTYPE )
IS
   archived_count_ NUMBER := 0;
BEGIN
   archived_count_ := Get_Archived_Blob_Count(remrec_.archive_no);
   IF remrec_.active = 'FALSE' THEN
      IF archived_count_> 0 THEN
         Error_SYS.Record_General(lu_name_, 'ARCHIVEDEXIST: Archive :P1 contains :P2 archived media items - delete is not allowed.',remrec_.archive_no,archived_count_);
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'ACTIVEARCHIVE: Deleting the currently active archive is not allowed.',remrec_.archive_no,archived_count_);
   END IF;

   IF remrec_.archive_method = 'BFILE' THEN
      Media_Archive_File_Util_API.Remove_Directory(remrec_.archive_no,
                                                   remrec_.archive_ref1);
   END IF;
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     media_archive_tab%ROWTYPE,
   newrec_ IN OUT media_archive_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   archived_count_   NUMBER;
BEGIN
   IF indrec_.archive_ref4 = TRUE THEN
      newrec_.archive_ref4 := Get_Encoded_Value(newrec_.archive_ref4);
   END IF;

   IF indrec_.wallet_password = TRUE THEN
      newrec_.wallet_password := Get_Encoded_Value(newrec_.wallet_password);
   END IF;

   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);

   archived_count_ := Get_Archived_Blob_Count(oldrec_.archive_no);
   IF (archived_count_ > 0) THEN
      Client_SYS.Add_Warning(lu_name_, 'MEDIAARCHIVEWARNING: There are :P1 image(s) already stored in this archive.', archived_count_);
   END IF;
END Check_Update___;


PROCEDURE Update_Arch_Active_Status___(
               archive_no_    IN NUMBER,
               active_        IN VARCHAR2)
IS
   objid_         ROWID;
   objversion_    MEDIA_ARCHIVE.objversion%TYPE;
   oldrec_        MEDIA_ARCHIVE_TAB%ROWTYPE;
   newrec_        MEDIA_ARCHIVE_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   attr_          VARCHAR2(3200);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, archive_no_);
   oldrec_ := Lock_By_Keys___(archive_no_);
   newrec_ := oldrec_;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ACTIVE_DB', active_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Update_Arch_Active_Status___;


FUNCTION Get_Key___ RETURN RAW
IS
   -- length should be 16 for the key
   dbid_ NUMBER;
   
   CURSOR get_db_id IS
      SELECT dbid 
      FROM v$database; 
   
   key_    VARCHAR2(16) := NULL;
BEGIN
   OPEN get_db_id;
   FETCH get_db_id INTO dbid_;
   CLOSE get_db_id;
   key_  := RPAD(NVL(dbid_,'1'),16,'*');
   RETURN UTL_I18N.string_to_raw(key_, 'AL32UTF8');
END Get_Key___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- this method gets all the media items that are not accessed for the last <time_limit_> days
-- and save them in the currently active archive storage
PROCEDURE Archive_Media_Items__(
      attr_             IN VARCHAR2)
IS
   CURSOR get_media_objects(time_limit_ NUMBER) IS
      SELECT   t.item_id, NULL language_code, t.media_object, t.archive_no
      FROM     MEDIA_ITEM_TAB t
      WHERE    t.latest_access_date < (SYSDATE - time_limit_)
      AND      NVL(Dbms_Lob.GetLength(t.media_object),0) > 0
      AND      t.archived = 'FALSE'
      UNION ALL
      SELECT   l.item_id, l.language_code, l.media_object, l.archive_no
      FROM     MEDIA_ITEM_LANGUAGE_TAB l
      WHERE    l.latest_access_date < (SYSDATE - time_limit_)
      AND      NVL(Dbms_Lob.GetLength(l.media_object),0) > 0
      AND      l.archived = 'FALSE';

   CURSOR get_deleted_items IS
      SELECT   *
      FROM     Media_Archive_Delete_Item_Tab;

   archive_rec_          Media_Archive_API.Public_Rec;
   ptr_                  NUMBER;
   name_                 VARCHAR2(30);
   value_                VARCHAR2(2000);
   status_msg_           VARCHAR2(2000);
   progress_msg_         VARCHAR2(2000);

   archive_time_limit_   NUMBER ;
   execution_period_     NUMBER := 3600;
   started_time_         NUMBER;
   elapsed_time_         NUMBER;

   err_msg_              VARCHAR2(1000);
   new_media_items_ctr_  NUMBER := 0;
   old_media_items_ctr_  NUMBER := 0;
   temp_lang_code_       VARCHAR2(10);
   success_              VARCHAR2(10);
BEGIN
   ptr_ := NULL;

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'LAST_ACCESS_LIMIT_DAYS') THEN
         archive_time_limit_ := value_;
      ELSIF (name_ = 'EXECUTION_PERIOD_MAX_HOURS') THEN
         execution_period_ := value_ * 3600; -- convert hours to seconds
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;


   started_time_ := Dbms_Utility.Get_Time;

   status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'STARTTIME: Media archiving started at: :P1', Fnd_Session_API.Get_Language, TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');

   status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'EXECUTIONTIME: Execution Maximum Time Limit: :P1 hours.', Fnd_Session_API.Get_Language, TO_CHAR(ROUND(execution_period_/3600,3), 99.999));
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');

   status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'REMOVEOBSOLETE: Start removing deleted media items at :P1', Fnd_Session_API.Get_Language, TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');

   -- Cleanup Deleted/Replaced items from the archive.
   FOR rec_ IN get_deleted_items LOOP
      archive_rec_ := Media_Archive_API.Get(rec_.archive_no);
      IF rec_.language_code = 'gg' THEN
         temp_lang_code_:= NULL;
      ELSE
         temp_lang_code_ := rec_.language_code;
      END IF;
      progress_msg_ := Language_SYS.Translate_Constant(lu_name_, 'REMOVEOBSOLETEITEM: Removing deleted media item no :P1 from archive.', Fnd_Session_API.Get_Language, rec_.item_id);
      Transaction_SYS.Log_Progress_Info(progress_msg_);

      BEGIN
         IF (archive_rec_.archive_method = 'AZURE') THEN
            Media_Archive_Azure_Util_API.Delete_Media_Item(success_,
                                                   archive_rec_.archive_ref1,
                                                   archive_rec_.archive_ref2,
                                                   archive_rec_.archive_ref3,
                                                   Get_Decoded_Value(archive_rec_.archive_ref4),
                                                   rec_.item_id,
                                                   archive_rec_.wallet_path,
                                                   Get_Decoded_Value(archive_rec_.wallet_password),
                                                   temp_lang_code_);
         ELSIF (archive_rec_.archive_method = 'BFILE') THEN
            Media_Archive_File_Util_API.Delete_Media_Item(success_,
                                                   rec_.archive_no,
                                                   rec_.item_id,
                                                   temp_lang_code_);
         END IF;

         IF success_ = 'TRUE' THEN
            Media_Archive_Delete_Item_API.Remove(rec_.item_id,
                                              rec_.language_code);
         END IF;

         @ApproveTransactionStatement(2018-02-13, hasplk)
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            err_msg_ := SUBSTR(SQLERRM, 1, 1000);
            status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'REMOVEERROR: Error when removing Media Item :P1. Error : ' || err_msg_ , Fnd_Session_API.Get_Language, rec_.item_id);
            Transaction_SYS.Log_Status_Info(status_msg_);
            Transaction_SYS.Log_Progress_Info('');
      END;
   END LOOP;

   -- Currently active archive no. should be taken when archiving the media items
   archive_rec_ := Media_Archive_API.Get(Get_Active_Archive_No);

   status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'ARCHIVEMEDIA: Starts archiving media items at :P1', Fnd_Session_API.Get_Language, TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS'));
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');

   FOR rec_ IN get_media_objects(archive_time_limit_) LOOP
      BEGIN
         -- If the record's archive_no is NULL, it means this is a newly archiving media item
         IF (rec_.archive_no IS NULL) THEN

            progress_msg_ := Language_SYS.Translate_Constant(lu_name_, 'ARCHIVEMEDIAITEM: Archiving media item no :P1', Fnd_Session_API.Get_Language, rec_.item_id);
            Transaction_SYS.Log_Progress_Info(progress_msg_);

            IF (archive_rec_.archive_method = 'AZURE') THEN
               Media_Archive_Azure_Util_API.Save_Media_Item(archive_rec_.archive_no,
                                                            archive_rec_.archive_ref1,
                                                            archive_rec_.archive_ref2,
                                                            archive_rec_.archive_ref3,
                                                            Get_Decoded_Value(archive_rec_.archive_ref4),
                                                            rec_.item_id,
                                                            rec_.media_object,
                                                            archive_rec_.wallet_path,
                                                            Get_Decoded_Value(archive_rec_.wallet_password),
                                                            rec_.language_code);
            ELSIF (archive_rec_.archive_method = 'BFILE') THEN
               Media_Archive_File_Util_API.Save_Media_Item(archive_rec_.archive_no,
                                                           rec_.item_id,
                                                           rec_.media_object,
                                                           rec_.language_code);
            END IF;

            IF rec_.language_code IS NULL THEN
               -- update the archive status using the NEW archive no.
               Media_Item_API.Update_Archive_Status(rec_.item_id, Fnd_Boolean_API.DB_TRUE, archive_rec_.archive_no);
            ELSE
               Media_Item_Language_API.Update_Archive_Status(rec_.item_id, rec_.language_code, Fnd_Boolean_API.DB_TRUE, archive_rec_.archive_no);
            END IF;
            new_media_items_ctr_  := new_media_items_ctr_ + 1;
         -- If the archive_no is NOT NULL, that means it has been previously archived and already exists in the archive storage
         -- So Just update the Archive Status to TRUE with the existing Archive No.
         ELSE
            IF rec_.language_code IS NULL THEN
               -- update the archive status using the EXISTING archive no.
               Media_Item_API.Update_Archive_Status(rec_.item_id, Fnd_Boolean_API.DB_TRUE, rec_.archive_no);
            ELSE
               Media_Item_Language_API.Update_Archive_Status(rec_.item_id, rec_.language_code, Fnd_Boolean_API.DB_TRUE, rec_.archive_no);
            END IF;
            old_media_items_ctr_  := old_media_items_ctr_ + 1;
         END IF;

         -- Commit each of the record
         @ApproveTransactionStatement(2017-04-19, prdalk)
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            err_msg_ := SUBSTR(SQLERRM, 1, 1000);
            status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'ARCHIVEERROR: Error when archiving Media Item :P1. Error : ' || err_msg_ , Fnd_Session_API.Get_Language, rec_.item_id);
            Transaction_SYS.Log_Status_Info(status_msg_);
            Transaction_SYS.Log_Progress_Info('');
      END;

      elapsed_time_ := (Dbms_Utility.Get_Time - started_time_) / 100;
      IF(elapsed_time_ > execution_period_) THEN
         EXIT;
      END IF;
   END LOOP;

   status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'ENDARCHIVINGMEDIA: Successfully archived :P1 new media item(s) to the archive no :P2.', Fnd_Session_API.Get_Language, new_media_items_ctr_, archive_rec_.archive_no);                                   
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');
   
   status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'OLDARCHIVINGMEDIA: Successfully archived :P1 existing media item(s) to their current archive location.', Fnd_Session_API.Get_Language, old_media_items_ctr_);                                   
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');
   
   status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'ELAPSEDTIME: Elapsed time: :P1 hours', Fnd_Session_API.Get_Language, TO_CHAR(ROUND(elapsed_time_/3600, 3), 99.999));                                   
   Transaction_SYS.Log_Status_Info(status_msg_, 'INFO');

EXCEPTION
   WHEN OTHERS THEN
      @ApproveTransactionStatement(2017-04-19, prdalk)
      ROLLBACK;

      err_msg_ := SUBSTR(SQLERRM, 1, 1000);
      status_msg_ := Language_SYS.Translate_Constant(lu_name_, 'ARCHIVEERRORGEN: Error occurred when Archiving Media Item. Error Message: ' || err_msg_ , Fnd_Session_API.Get_Language);
      Transaction_SYS.Log_Status_Info(status_msg_);

END Archive_Media_Items__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Archive_Media_Items (
   attr_             IN VARCHAR2)
IS
   batch_desc_         VARCHAR2(2000);
BEGIN
   IF (Transaction_SYS.Is_Session_Deferred()) THEN
      Archive_Media_Items__(attr_);
   ELSE
      batch_desc_ := Language_SYS.Translate_Constant(lu_name_,'ARCHIVINGMEDIA: Archiving media items');
      Transaction_SYS.Deferred_Call('Media_Archive_API.Archive_Media_Items__', attr_, batch_desc_);
   END IF;
END Archive_Media_Items;



-- this method will retrieve the blob object from its existing archive storage
FUNCTION Get_Media_Item(
               item_id_       IN NUMBER,
               archive_no_    IN NUMBER,
               lang_code_     IN VARCHAR2 DEFAULT NULL) RETURN BLOB
IS
   media_obj_     BLOB;
   archive_rec_   Media_Archive_API.Public_Rec;
BEGIN

   archive_rec_ := Media_Archive_API.Get(archive_no_);
   IF (archive_rec_.archive_method = 'AZURE') THEN
      media_obj_ := Media_Archive_Azure_Util_API.Get_Media_Item(archive_rec_.archive_ref1,
                                                                archive_rec_.archive_ref2,
                                                                archive_rec_.archive_ref3,
                                                                Get_Decoded_Value(archive_rec_.archive_ref4),
                                                                item_id_,
                                                                archive_rec_.wallet_path,
                                                                Get_Decoded_Value(archive_rec_.wallet_password),
                                                                lang_code_);
   ELSIF (archive_rec_.archive_method = 'BFILE') THEN
      media_obj_ := Media_Archive_File_Util_API.Get_Media_Item(archive_rec_.archive_no,
                                                               item_id_,
                                                               lang_code_);
   END IF;

   RETURN media_obj_;
END Get_Media_Item;

-- Get the currently active archive no
FUNCTION Get_Active_Archive_No RETURN NUMBER
IS
   CURSOR get_active_archive IS
      SELECT t.archive_no
      FROM media_archive_tab t
      WHERE t.active = 'TRUE';

   archive_no_    NUMBER;
BEGIN
   OPEN get_active_archive;
   FETCH get_active_archive INTO archive_no_;
   CLOSE get_active_archive;

   RETURN archive_no_;
END Get_Active_Archive_No;


PROCEDURE Set_Active_Archive_No(
   new_act_archive_no_ IN NUMBER)
IS
  current_archive_no_  NUMBER;
BEGIN
   current_archive_no_ := Get_Active_Archive_No;
   IF current_archive_no_ IS NOT NULL THEN
      -- Set existing active archive number to FALSE
      Update_Arch_Active_Status___(Get_Active_Archive_No, Fnd_Boolean_API.DB_FALSE);
   END IF;
   -- Set the new archive no. to be active
   Update_Arch_Active_Status___(new_act_archive_no_, Fnd_Boolean_API.DB_TRUE);
END;

PROCEDURE Set_Archive_Inactive(
   archive_no_ IN NUMBER)
IS
BEGIN
   Update_Arch_Active_Status___(archive_no_, Fnd_Boolean_API.DB_FALSE);
END Set_Archive_Inactive;

-- This method is used to test a specific archive storage
-- by saving a test blob and removing it afterwards.
PROCEDURE Test_Archive(
   info_          OUT NOCOPY VARCHAR2,
   archive_no_    IN         NUMBER)
IS
   test_blob_        BLOB;
   archive_rec_      Media_Archive_API.Public_Rec;
   success_          VARCHAR2(10);
BEGIN
   test_blob_ := UTL_RAW.cast_to_raw('Hello World!');
   archive_rec_ := Media_Archive_API.Get(archive_no_);

   IF (archive_rec_.archive_method = 'AZURE') THEN
      Media_Archive_Azure_Util_API.Save_Media_Item(archive_rec_.archive_no,
                                                   archive_rec_.archive_ref1,
                                                   archive_rec_.archive_ref2,
                                                   archive_rec_.archive_ref3,
                                                   Get_Decoded_Value(archive_rec_.archive_ref4),
                                                   0000,
                                                   test_blob_,
                                                   archive_rec_.wallet_path,
                                                   Get_Decoded_Value(archive_rec_.wallet_password));

      Media_Archive_Azure_Util_API.Delete_Media_Item(success_,
                                                     archive_rec_.archive_ref1,
                                                     archive_rec_.archive_ref2,
                                                     archive_rec_.archive_ref3,
                                                     Get_Decoded_Value(archive_rec_.archive_ref4),
                                                     0000,
                                                     archive_rec_.wallet_path,
                                                     Get_Decoded_Value(archive_rec_.wallet_password));
   ELSIF (archive_rec_.archive_method = 'BFILE') THEN
      Media_Archive_File_Util_API.Save_Media_Item(archive_rec_.archive_no,
                                                  0000,
                                                  test_blob_);

      Media_Archive_File_Util_API.Delete_Media_Item(success_,
                                                    archive_rec_.archive_no,
                                                    0000);
   ELSE
      Error_SYS.Record_General(lu_name_, 'ARCHIVETYPEERROR: This Archive has not been configured yet!');
   END IF;
   Client_SYS.Add_Info(lu_name_, 'ARCHIVETESTSUCCESS: Archive has been accessed successfully!');

   info_ := Client_SYS.Get_All_Info;
END Test_Archive;


-- This function will return the number of archived images of a given archive
FUNCTION Get_Archived_Blob_Count(
   archive_no_    IN NUMBER) RETURN NUMBER
IS
   CURSOR get_archived_count IS
      SELECT ((SELECT COUNT(*)
               FROM media_item_tab t
               WHERE t.archive_no = archive_no_)
      + (SELECT count(*)
         FROM media_item_language_tab l
         WHERE l.archive_no = archive_no_))
      FROM dual;

   blob_count_    NUMBER;
BEGIN
   OPEN get_archived_count;
   FETCH get_archived_count INTO blob_count_;
   CLOSE get_archived_count;

   RETURN NVL(blob_count_,0);
END Get_Archived_Blob_Count;


FUNCTION Get_Encoded_Value(
            value_    IN VARCHAR2) RETURN VARCHAR2
IS
   encrypted_raw_          RAW(10000);
   encrypted_value_        VARCHAR2(32000);
   access_key_             RAW(1000);
   -- using 128-bit AES algorithm with Cipher Block Chaining and PKCS#5 compliant padding
   encryption_type_        PLS_INTEGER :=  DBMS_CRYPTO.ENCRYPT_AES128 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5;
BEGIN
   IF value_ IS NOT NULL THEN
      access_key_    := Get_Key___;
      encrypted_raw_ := DBMS_CRYPTO.ENCRYPT(
                                             src => UTL_I18N.STRING_TO_RAW (value_,  'AL32UTF8'),
                                             typ => encryption_type_,
                                             key => access_key_
                                           );
      encrypted_value_ := UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(encrypted_raw_));
   END IF;
   RETURN encrypted_value_;
END Get_Encoded_Value;


FUNCTION Get_Decoded_Value(
            value_    IN VARCHAR2) RETURN VARCHAR2
IS
   encrypted_raw_          RAW(10000);
   access_key_             RAW(1000);
   -- using 128-bit AES algorithm with Cipher Block Chaining and PKCS#5 compliant padding
   encryption_type_        PLS_INTEGER :=  DBMS_CRYPTO.ENCRYPT_AES128 + DBMS_CRYPTO.CHAIN_CBC + DBMS_CRYPTO.PAD_PKCS5;
   decrypted_raw_          RAW(10000);
   decrypted_value_        VARCHAR2(1000);
BEGIN
   IF value_ IS NOT NULL THEN
      access_key_    := Get_Key___;
      encrypted_raw_ := UTL_ENCODE.Base64_Decode(UTL_RAW.Cast_To_Raw(value_));
      decrypted_raw_ := DBMS_CRYPTO.decrypt(
                                             src => encrypted_raw_,
                                             typ => encryption_type_,
                                             key => access_key_
                                           );
      decrypted_value_ := UTL_I18N.raw_to_char(decrypted_raw_, 'AL32UTF8');
   END IF;
   RETURN decrypted_value_;
EXCEPTION
   WHEN OTHERS THEN
      RETURN value_;   
END Get_Decoded_Value;