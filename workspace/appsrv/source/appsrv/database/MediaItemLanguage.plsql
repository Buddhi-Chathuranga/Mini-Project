-----------------------------------------------------------------------------
--
--  Logical unit: MediaItemLanguage
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  -------------------------- APPS 9 ---------------------------------------
--  170629  chahlk  Bug 136626, Added archiving support for Media Item Language.
--  131122  paskno  Hooks: refactoring and splitting.
--  130910  chanlk  Model errors corrected.
--  100422  Ajpelk   Merge rose method documentation
--  --------------------------Eagle---------------------------------------------
--  091116  Pawelk   Added Media_Item_Exist(), Media_Object_Empty(), Media_Text_Empty, Get_Media_Text().
--  091112  SUJALK   Added view MEDIA_ITEM_LANGUAGE_DISPLAY. Modified the Unpack_Check_Insert___ method to consider LANGUAGE_CODE_DISP.
--  091112           Also changed the media_object, media_text and media thumb parameter type blob and clob in media object methods.
--  091029  PAWELK   Renamed LU InfoObjectLang to MediaItemLanguage. Changed the code accordingly.
--  091029           Modified the module by setting module name from partca to appsrv.
--  090713  PaWelk   Added 3 new procedures to remove blob and clob. The procedures are
--  090713           Remove_Info_Object(), Remove_Info_Object_Text(), Remove_Info_Object_Thumb().
--  090611  SuJalk   Created
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
   super(attr_);
   Client_SYS.Add_To_Attr('LATEST_ACCESS_DATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('ARCHIVED_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('PRIVATE_MEDIA_ITEM', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT media_item_language_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   newrec_.latest_access_date := NVL(newrec_.latest_access_date, SYSDATE);
   newrec_.archived := NVL(newrec_.archived, Fnd_Boolean_API.DB_FALSE);
   IF (Client_SYS.Item_Exist('LANGUAGE_CODE_DISP', attr_)) THEN
      newrec_.language_code := Iso_Language_API.Encode(Client_SYS.Get_Item_Value('LANGUAGE_CODE_DISP', attr_));
      Iso_Language_API.Exist(newrec_.language_code);
   END IF;
   newrec_.archived := NVL(newrec_.archived, 'FALSE');
   super(newrec_, indrec_, attr_);
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     media_item_language_tab%ROWTYPE,
   newrec_ IN OUT media_item_language_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN

   -- If the media item is newly archiving, remove the existing media object blob
   IF (oldrec_.archived != newrec_.archived) AND newrec_.archived = 'TRUE' THEN
     newrec_.media_object := NULL;
   END IF;  
     
   -- If the media item is taken from the archive, set the system date as the latest access date
   IF (oldrec_.archived != newrec_.archived) AND newrec_.archived = 'FALSE' THEN
     newrec_.latest_access_date := SYSDATE;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE )
IS
BEGIN
   Media_Library_Item_API.Remove_Lib_Item_Connected(remrec_.item_id, 'DO');
   IF remrec_.archive_no IS NOT NULL THEN
      Media_Archive_Delete_Item_API.New(remrec_.item_id,remrec_.language_code,remrec_.archive_no);
   END IF;
   super(objid_, remrec_);
END Delete___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
FUNCTION Check_Archived___(
   item_id_    IN    NUMBER,
   lang_code_  IN    VARCHAR2) RETURN BOOLEAN
IS
   CURSOR check_archived IS
      SELECT archived
      FROM MEDIA_ITEM_LANGUAGE_TAB
      WHERE item_id = item_id_
      AND   language_code=lang_code_;
      
   archived_         VARCHAR2(5);
BEGIN
   OPEN check_archived;
   FETCH check_archived INTO archived_;
   CLOSE check_archived;
   
   RETURN (archived_ = 'TRUE');
END Check_Archived___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Write_Media_Object
--   Writes the media item object to the database.
PROCEDURE Write_Media_Object (
   objversion_    IN OUT VARCHAR2,
   rowid_         IN VARCHAR2,
   media_object_  IN BLOB )
IS
   rec_ MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
BEGIN
   Get_Version_By_Id___(rowid_,objversion_);
   rec_ := Lock_By_Id___(rowid_, objversion_);

   IF rec_.archive_no IS NOT NULL THEN
      Media_Archive_Delete_Item_API.New(rec_.item_id, rec_.language_code, rec_.archive_no);
   END IF;

   UPDATE media_item_language_tab
      SET media_object = media_object_,
          archive_no = NULL,
          latest_access_date = SYSDATE,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
      -- Commit the transaction because there can be error when deleting the media item from archive.
      -- In that case current image will be replaced during next run of the archiving job.
      @ApproveTransactionStatement(2017-08-02,chahlk)
      COMMIT;
      
END Write_Media_Object;


-- Write_Media_Text
--   Writes the media item object text to the database.
PROCEDURE Write_Media_Text (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN VARCHAR2,
   media_text_ IN CLOB )
IS
   rec_ MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_language_tab
      SET media_text = media_text_,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Write_Media_Text;


-- Write_Media_Thumb
--   Writes the media item object thumbnail to the database.
PROCEDURE Write_Media_Thumb (
   objversion_ IN OUT VARCHAR2,
   rowid_ IN VARCHAR2,
   media_object_ IN BLOB )
IS
   rec_ MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_language_tab
      SET media_thumb = media_object_,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Write_Media_Thumb;


PROCEDURE Remove_Media_Object (
   objversion_ IN OUT VARCHAR2,
   rowid_ IN VARCHAR2 )
IS
   rec_ MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   IF rec_.archive_no IS NOT NULL THEN
      Media_Archive_Delete_Item_API.New(rec_.item_id, rec_.language_code, rec_.archive_no);
   END IF;
   UPDATE media_item_language_tab
      SET media_object = empty_blob(),
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Remove_Media_Object;


PROCEDURE Remove_Media_Text (
   objversion_ IN OUT VARCHAR2,
   rowid_ IN VARCHAR2 )
IS
   rec_ MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_language_tab
      SET media_text = empty_clob(),
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Remove_Media_Text;


PROCEDURE Remove_Media_Thumb (
   objversion_ IN OUT VARCHAR2,
   rowid_ IN VARCHAR2 )
IS
   rec_ MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_language_tab
      SET media_thumb = empty_blob(),
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Remove_Media_Thumb;


@UncheckedAccess
FUNCTION Media_Item_Exist (
   item_id_       IN NUMBER,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(item_id_, language_code_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Media_Item_Exist;


@UncheckedAccess
FUNCTION Media_Object_Empty (
   item_id_       IN NUMBER,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_    NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
      FROM MEDIA_ITEM_LANGUAGE_TAB
      WHERE DBMS_LOB.COMPARE(media_object, EMPTY_BLOB()) = 0
      OR media_object IS NULL
      AND item_id = item_id_
      AND language_code = language_code_
      AND archive_no IS NULL;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Media_Object_Empty;


@UncheckedAccess
FUNCTION Media_Text_Empty (
   item_id_       IN NUMBER,
   language_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_    NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
      FROM MEDIA_ITEM_LANGUAGE_TAB
      WHERE DBMS_LOB.COMPARE(media_text, EMPTY_CLOB()) = 0
      OR media_text IS NULL
      AND item_id = item_id_
      AND language_code = language_code_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;

   IF (temp_ = 1) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Media_Text_Empty;

PROCEDURE Update_Archive_Status(
   item_id_       IN NUMBER,
   lang_code_     IN VARCHAR2,
   archived_db_   IN VARCHAR2,
   archive_no_    IN NUMBER)
IS
   objid_         ROWID;
   objversion_    MEDIA_ITEM_LANGUAGE.objversion%TYPE;
   oldrec_        MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
   newrec_        MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   attr_          VARCHAR2(3200);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, item_id_ ,lang_code_);
   oldrec_ := Lock_By_Keys___(item_id_, lang_code_);
   newrec_ := oldrec_;
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ARCHIVED_DB', archived_db_, attr_);
   Client_SYS.Add_To_Attr('ARCHIVE_NO', archive_no_, attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Update_Archive_Status;

PROCEDURE Prepare_Media_Item(
   item_id_       IN NUMBER,
   lang_code_     IN VARCHAR2)
IS
   objid_         ROWID;
   objversion_    MEDIA_ITEM_LANGUAGE.objversion%TYPE;
   media_obj_     BLOB;
   rec_           MEDIA_ITEM_LANGUAGE_TAB%ROWTYPE;
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   -- Check if media item is archived 
   IF Check_Archived___(item_id_,lang_code_) THEN
      
      Get_Id_Version_By_Keys___ (objid_, objversion_, item_id_,lang_code_);
      rec_ := Lock_By_Keys___(item_id_,lang_code_);
      -- If archived, get the Media Item through the respective Archive
      media_obj_ := Media_Archive_API.Get_Media_Item(item_id_, rec_.archive_no,lang_code_);
      
      UPDATE media_item_language_tab
      SET media_object = media_obj_,
          archived = 'FALSE', -- archived, archived_no and latest_access_date should be set to default values when writing a new media object
          latest_access_date = SYSDATE,
          rowversion = SYSDATE
      WHERE rowid = objid_
            RETURNING TO_CHAR(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_; 
      
      -- Commit the transaction because this method can be invoked indirectly 
      -- from both Get_Media_Item and Prepare_Default_Item
      @ApproveTransactionStatement(2017-05-03,prdalk)
      COMMIT;
   
   END IF;
END Prepare_Media_Item;

PROCEDURE Get_Media_Item(
   media_obj_     OUT   BLOB,
   item_id_       IN    NUMBER,
   lang_code_     IN    VARCHAR2) 
IS
   CURSOR get_media_object IS
      SELECT t.media_object
      FROM media_item_language_tab t
      WHERE t.item_id = item_id_
      AND   t.language_code = lang_code_;
   
BEGIN
   -- will check if the media object is archived and if so reinstate it to the local db
   Prepare_Media_Item(item_id_,lang_code_);
   
   OPEN get_media_object;
   FETCH get_media_object INTO media_obj_;--,objversion_;
   CLOSE get_media_object;
   
END Get_Media_Item;



