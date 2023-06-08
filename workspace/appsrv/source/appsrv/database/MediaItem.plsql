-----------------------------------------------------------------------------
--
--  Logical unit: MediaItem
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210811  DEEKLK  AM21R2-2547, Modified Write_Media_Object().
--  210207  DEEKLK  AM2020R1-7316, Added Is_Update_Allowed().
--  200416  MDAHSE  SAXTEND-3383, Add supporting methods for media handling from Java (Aurena projection).
--  -------------------------- APPS 9 ---------------------------------------
--  170616  PRDALK  Bug 136626, Added new method Get_Media_Item_Objid()/Get_Media_Item().
--  170523  CHAHLK  Bug 135941, Added archiving functionality to Media Item.
--  150222  BAMAUK  Bug 127458, Modified Write_Media_Thumb() to support Mobile Work Orders.
--  150212  RILASE  Added Set_Media_Item_To_Private.
--  140806  THIMLK  PRMF-63, Merged LCS Patch 112393.
--  140806          130926  ThImLK  Bug 112393, Done some modifcations to add the public attribute, private_media_item.
--  131112  paskno  Hooks: refactoring and splitting.
--  130910  chanlk  Model errors corrected.
--  121122  ErSrLK  Bug 106916, Modified Insert___() to fetch the next Item ID from sequence Appsrv_Media_Item_SEQ instead of calculating it.
--  121122          Also removed unused function Get_Next_Media_Item_Id__().
--  121015  SuJalk  Bug 96685, Added Get_Media_Item_Type_Db, Get_Media_File, and Set_Media_File functions. Added media_file attribute to the LU.
--  100324  Pawelk  Bug 88701, Modified Unpack_Check_Insert___ by setting NULL value of attribute Obsolete to FALSE.
--  100422  Ajpelk  Merge rose method documentation
--  --------------------------Eagle---------------------------------------------
--  091209  Hasplk  Removed Commit command from following methods.Remove_Media_Object, Remove_Media_Object_Thumb, Remove_Media_Text
--  091209  SuJalk  Modified CANNOTOBSOLETE message.
--  091124  Hasplk  Modified MEDIA_ITEM_LANG_IMAGE view comments. Added NOCHECK for Item Id Reference.
--  091119  SuJalk  Added a code to assign a 'FALSE' value for obsolete the if the newrec_ value for obsolete is null in Unpack_Check_Insert___.
--  091116  PaWelk  Added view MEDIA_ITEM_LANG_IMAGE and Media_Text_Empty().
--  091109  SuJalk  Removed the commit statements from Write_Media_Object, Write_Media_Text and Write_Media_Thumb methods.
--  091103  Hasplk  Corrected method parameter names.
--  090929  SuJalk  Renamed the Info Object based attributes and objects to Media.
--  091028  Hasplk  Modified Check_Delete___ method.
--  091019  Hasplk  Removed InfoObject Class from InfoObject. Added column Resolution.
--  091009  Hasplk  Modified Insert method to add INFO_OBJECT_TYPE_DB to attr_.
--  091006  PaWelk  Added Get_Info_Text().
--  091006  Hasplk  Modified method Delete___ to remove connected InfoObjectLines.
--  090903  PaWelk  Modified Insert___() and Update___() by adding INFO_OBJECT_CLASS_DB to attr_.
--  090831  Hasplk  Modified Insert__() method to add if Info_Object_Id is missing.
--  090826  SuJalk  Modified Remove_Info_Object, Remove_Info_Object_Text and Remove_Info_Object_Thumb methods to assign null instead of
--  090826          empty_clob() or empty_blob to avoid error in IEE client.
--  090819  Hasplk  Added check to restrict obsoleting an object where set to default image.
--  090728  SuJalk  Added info object id to attr in Insert___ method.
--  090721  PaWelk  Modified Write_Info_Object(), Write_Info_Object_Text(), Write_Info_Object_Thumb(),
--  090721          Remove_Info_Object(), Remove_Info_Object_Text(), Remove_Info_Object_Thumb() by adding COMMIT.
--  090716  SuJalk  Made changes related to making info_object_class an IID.
--  090713  PaWelk  Added 3 new procedures to remove blob and clob. The procedures are
--  090713          Remove_Info_Object(), Remove_Info_Object_Text(), Remove_Info_Object_Thumb().
--  090611  SuJalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     media_item_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY media_item_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 ) IS
BEGIN
   super(oldrec_,newrec_,indrec_,attr_);

   IF (newrec_.private_media_item = 'TRUE') THEN
      IF (Media_Library_Item_API.Has_Multiple_Connections(newrec_.item_id) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'CANTSETPRIVATE: This media item is connected to more than one object. Therefore it cannot be set as private.');
      ELSIF (Media_Library_Item_API.Has_Single_Connection(newrec_.item_id) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'CANTSETPRIVATEMEDIA: This media item is not connected to any object. Therefore it cannot be set as private.');
      END IF;
   END IF;

END Check_Common___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('LATEST_ACCESS_DATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('ARCHIVED', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('PRIVATE_MEDIA_ITEM', 'FALSE', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MEDIA_ITEM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.item_id IS NULL) THEN
      newrec_.item_id := Appsrv_Media_Item_SEQ.NEXTVAL;
   END IF;
   
   IF (newrec_.media_item_type = Media_Item_Type_API.DB_TEXT) THEN
      newrec_.repository := Media_Item_Repository_Type_API.DB_DATABASE;
   ELSE
      newrec_.repository := Get_Default_Repository___ ();
   END IF;
   
   Client_SYS.Add_To_Attr('REPOSITORY', newrec_.repository, attr_);
   
   super(objid_, objversion_, newrec_, attr_);
   
   Client_SYS.Add_To_Attr('ITEM_ID', newrec_.item_id, attr_);
   Client_SYS.Add_To_Attr('MEDIA_ITEM_TYPE_DB', newrec_.media_item_type, attr_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN MEDIA_ITEM_TAB%ROWTYPE )
IS
BEGIN
   IF (Media_Library_Item_API.Connected_To_Locked_Media_Lib(remrec_.item_id) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'CANTDELETELOCKED: Media has been attached to a locked library. Cannot remove the item.');
   END IF;
   super(remrec_);
   Media_Library_Item_API.Remove_Lib_Item_Connected(remrec_.item_id, 'CHECK');
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN MEDIA_ITEM_TAB%ROWTYPE )
IS
BEGIN
   Media_Library_Item_API.Remove_Lib_Item_Connected(remrec_.item_id, 'DO');
   IF remrec_.archive_no IS NOT NULL THEN
      Media_Archive_Delete_Item_API.New(remrec_.item_id,NULL,remrec_.archive_no);
   END IF;
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT media_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.private_media_item := NVL(newrec_.private_media_item, 'FALSE');
   newrec_.latest_access_date := NVL(newrec_.latest_access_date, SYSDATE);
   newrec_.archived := NVL(newrec_.archived, 'FALSE');
   newrec_.obsolete := NVL(newrec_.obsolete, 'FALSE');
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     media_item_tab%ROWTYPE,
   newrec_ IN OUT media_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   -- If the media item is newly archiving, remove the existing media object blob
   IF (oldrec_.archived != newrec_.archived) AND newrec_.archived = 'TRUE' THEN
     newrec_.media_object := NULL;
   END IF;
   IF(oldrec_.private_media_item = 'TRUE') THEN
      newrec_.private_media_item := 'TRUE';
   END IF;
   -- If the media item is taken from the archive, set the system date as the latest access date
   IF (oldrec_.archived != newrec_.archived) AND newrec_.archived = 'FALSE' THEN
     newrec_.latest_access_date := SYSDATE;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.obsolete = 'TRUE' THEN
      IF Media_Library_Item_API.Is_Set_To_Library_Def_Media(newrec_.item_id) = 'TRUE' THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTOBSOLETE: Set image to obsolete not allowed when item is set as default in a connected library.');
      END IF;
   END IF;
END Check_Update___;

-- Check if the media item is archived and if so, will return true
FUNCTION Check_Archived___(
   item_id_    IN    NUMBER) RETURN BOOLEAN
IS
   CURSOR check_archived IS
      SELECT archived
      FROM MEDIA_ITEM_TAB
      WHERE item_id = item_id_;

   archived_         VARCHAR2(5);
BEGIN
   OPEN check_archived;
   FETCH check_archived INTO archived_;
   CLOSE check_archived;

   RETURN (archived_ = 'TRUE');
END Check_Archived___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     media_item_tab%ROWTYPE,
   newrec_     IN OUT media_item_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Notify_Modify_Media___(newrec_.item_id);
END Update___;

PROCEDURE Notify_Modify_Media___(item_id_ IN NUMBER)
IS
   CURSOR get_media_library_item IS
      SELECT item.*
      FROM   media_library_tab library, media_library_item_tab item
      WHERE  library.library_id = item.library_id
      AND    item.item_id = item_id_;
BEGIN
   FOR rec_ IN get_media_library_item LOOP
      Media_Library_Item_API.Validate_Modify_Media(rec_,rec_);
   END LOOP;
END Notify_Modify_Media___;

FUNCTION Get_Default_Repository___ RETURN VARCHAR2
IS
BEGIN
   IF Object_Property_API.Get_Value(lu_name_, 'ITEM_ID', 'REPOSITORY') = 'FILE_STORAGE' THEN
      RETURN Media_Item_Repository_Type_API.DB_FILE_STORAGE;
   ELSE
      RETURN Media_Item_Repository_Type_API.DB_DATABASE;
   END IF;
END Get_Default_Repository___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
@Override
PROCEDURE Write_Media_Object__ (
   objversion_ IN OUT NOCOPY VARCHAR2,
   rowid_      IN            ROWID,
   lob_loc_    IN            BLOB )
IS
BEGIN
   super(objversion_, rowid_, lob_loc_);
   UPDATE media_item_tab
      SET archived = 'FALSE', -- archived, archived_no and latest_access_date should be set to default values when writing a new media object
          archive_no = NULL,
          latest_access_date = SYSDATE,
          repository = 'DATABASE', -- when this method is called via plsql, we set the repository to DATABASE in case if it is set to FILE_STORAGE when the media item was created.
          rowversion = SYSDATE
      WHERE rowid = rowid_
          RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Write_Media_Object__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Media_File (
   info_           OUT     VARCHAR2,
   objversion_     IN OUT  VARCHAR2,
   objid_          IN      VARCHAR2,
   media_file_     IN      VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Add_To_Attr('MEDIA_FILE', media_file_, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Set_Media_File;


@UncheckedAccess
FUNCTION Get_Media_Text (
   item_id_ IN NUMBER ) RETURN CLOB
IS
   temp_ MEDIA_ITEM_TAB.media_text%TYPE;
   CURSOR get_attr IS
      SELECT media_text
      FROM MEDIA_ITEM_TAB
      WHERE item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Media_Text;

@UncheckedAccess
FUNCTION Get_Media_Thumb (
   item_id_ IN NUMBER ) RETURN BLOB
IS
   temp_ MEDIA_ITEM_TAB.media_thumb%TYPE;

   CURSOR get_attr IS
      SELECT media_thumb
      FROM MEDIA_ITEM
      WHERE item_id = item_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Media_Thumb;

-- Write_Media_Object
--   Writes the Media Item object to the database.
PROCEDURE Write_Media_Object (
   objversion_   IN OUT VARCHAR2,
   rowid_        IN     VARCHAR2,
   media_object_ IN     BLOB )
IS
   rec_ MEDIA_ITEM_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   
   -- Check if media item is already archived in a specific archive and if so, remove it from that archive
   -- as we are writing a new media object to the media item record
   -- We cannot check if Archived is TRUE here, before updating the media item from client it may take the image
   -- from the archive and set Archived as FALSE.
   IF rec_.archive_no IS NOT NULL THEN
      Media_Archive_Delete_Item_API.New(rec_.item_id,NULL,rec_.archive_no);
   END IF;
   
   Write_Media_Object__(objversion_, rowid_, media_object_);
END Write_Media_Object;

PROCEDURE Write_Media_Object (
   item_id_      IN     VARCHAR2,
   media_object_ IN     BLOB)
IS
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Write_Media_Object (objversion_, objid_, media_object_);
END Write_Media_Object;


-- Write_Media_Text
--   Writes the media item text to the database.
PROCEDURE Write_Media_Text (
   objversion_        IN OUT VARCHAR2,
   rowid_             IN     VARCHAR2,
   media_text_        IN     CLOB)
IS
   rec_ MEDIA_ITEM_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_tab
      SET media_text = media_text_,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Write_Media_Text;

PROCEDURE Write_Media_Text (
   item_id_    IN     VARCHAR2,
   media_text_ IN     CLOB )
IS
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Write_Media_Text (objversion_, objid_, media_text_);
END Write_Media_Text;

-- Write_Media_Thumb
--   Writes the media object thumnail to the database.
PROCEDURE Write_Media_Thumb (
   objversion_   IN OUT VARCHAR2,
   rowid_        IN     VARCHAR2,
   media_object_ IN     BLOB )
IS
   rec_ MEDIA_ITEM_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_tab
      SET media_thumb = media_object_,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Write_Media_Thumb;

PROCEDURE Write_Media_Thumb (
   item_id_      IN     VARCHAR2,
   media_thumb_ IN     BLOB )
IS
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Write_Media_Thumb (objversion_, objid_, media_thumb_);
END Write_Media_Thumb;

PROCEDURE Get_Id_Ver_By_Keys_Pub (
   objid_          OUT VARCHAR2,
   objversion_     OUT VARCHAR2,
   item_id_ IN  NUMBER )
IS
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
END Get_Id_Ver_By_Keys_Pub;


PROCEDURE Remove_Media_Object (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN     VARCHAR2 )
IS
   rec_ MEDIA_ITEM_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_tab
      SET media_object = NULL,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
   IF rec_.archive_no IS NOT NULL THEN
      Media_Archive_Delete_Item_API.New(rec_.item_id,NULL,rec_.archive_no);
   END IF;
END Remove_Media_Object;

PROCEDURE Remove_Media_Object (
   item_id_ IN NUMBER)
IS
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Remove_Media_Object(objversion_, objid_);
END Remove_Media_Object;

PROCEDURE Remove_Media_Text (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN     VARCHAR2 )
IS
   rec_ MEDIA_ITEM_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_tab
      SET media_text = NULL,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Remove_Media_Text;


PROCEDURE Remove_Media_Thumb (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN     VARCHAR2 )
IS
   rec_ MEDIA_ITEM_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Id___(rowid_, objversion_);
   UPDATE media_item_tab
      SET media_thumb = NULL,
          rowversion = SYSDATE
      WHERE rowid = rowid_
            RETURNING to_char(rowversion, 'YYYYMMDDHH24MISS') INTO objversion_;
END Remove_Media_Thumb;


@UncheckedAccess
FUNCTION Media_Text_Empty (
   item_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_    NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
      FROM MEDIA_ITEM_TAB
      WHERE DBMS_LOB.COMPARE(media_text, EMPTY_CLOB()) = 0
      OR media_text IS NULL
      AND media_item_type = 'TEXT'
      AND item_id = item_id_;
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


@UncheckedAccess
FUNCTION Media_Object_Empty (
   item_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_    NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
      FROM MEDIA_ITEM_TAB
      WHERE DBMS_LOB.COMPARE(media_object, EMPTY_BLOB()) = 0
      OR media_object IS NULL
      AND archive_no IS NULL
      AND media_item_type = 'IMAGE'
      AND item_id = item_id_;
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


PROCEDURE Remove_Media_Item (
   item_id_ IN NUMBER )
IS
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
   remrec_     MEDIA_ITEM_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, item_id_ );
   remrec_ := Lock_By_Keys___(item_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Media_Item;

PROCEDURE Set_Media_Item_To_Private (
   item_id_ IN NUMBER )
IS
   attr_       VARCHAR2(2000);
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
   info_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Client_SYS.Add_To_Attr('PRIVATE_MEDIA_ITEM', 'TRUE', attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Set_Media_Item_To_Private;

PROCEDURE Update_Archive_Status(
   item_id_       IN NUMBER,
   archived_db_   IN VARCHAR2,
   archive_no_    IN NUMBER)
IS
   objid_         ROWID;
   objversion_    MEDIA_ITEM.objversion%TYPE;
   oldrec_        MEDIA_ITEM_TAB%ROWTYPE;
   newrec_        MEDIA_ITEM_TAB%ROWTYPE;
   indrec_        Indicator_Rec;
   attr_          VARCHAR2(3200);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, item_id_ );
   oldrec_ := Lock_By_Keys___(item_id_);
   newrec_ := oldrec_;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ARCHIVED_DB', archived_db_, attr_);
   Client_SYS.Add_To_Attr('ARCHIVE_NO', archive_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Update_Archive_Status;

-- This method will fetch default media item to database from the archive.
PROCEDURE Prepare_Default_Item(
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2)
IS
   item_    NUMBER;

   CURSOR get_default IS
   SELECT t.item_id FROM media_library_item_tab t
   WHERE t.default_media ='TRUE'
   AND  t.library_id = (SELECT s.library_id
                        FROM   media_library_tab s
                        WHERE  s.lu_name=lu_name_
                        AND    s.key_ref=key_ref_);

BEGIN
   OPEN  get_default;
   FETCH get_default into item_;
   CLOSE get_default;

   IF item_ IS NOT NULL THEN
      Prepare_Media_Item(item_);
   END IF;
END Prepare_Default_Item;

-- This method will check if the media item is archived and if so retrieve and store it
-- in the media_item_tab
PROCEDURE Prepare_Media_Item(
   item_id_ IN NUMBER)
IS
   objid_         ROWID;
   objversion_    MEDIA_ITEM.objversion%TYPE;
   media_obj_     BLOB;
   rec_           MEDIA_ITEM_TAB%ROWTYPE;
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   -- Check if media item is archived
   IF Check_Archived___(item_id_) THEN

      Get_Id_Version_By_Keys___ (objid_, objversion_, item_id_);
      rec_ := Lock_By_Keys___(item_id_);
      -- If archived, get the Media Item through the respective Archive
      media_obj_ := Media_Archive_API.Get_Media_Item(item_id_, rec_.archive_no);

      UPDATE media_item_tab
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

PROCEDURE Prepare_Media_Item(
   objid_         IN    VARCHAR2)
IS
   lu_rec_ media_item_tab%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Id___(objid_);
   Prepare_Media_Item(lu_rec_.item_id);
END Prepare_Media_Item;

PROCEDURE Get_Media_Item(
   media_obj_     OUT   BLOB,
   item_id_       IN    NUMBER)
IS
   CURSOR get_media_object IS
      SELECT t.media_object
      FROM media_item_tab t
      WHERE t.item_id = item_id_;

BEGIN
   -- will check if the media object is archived and if so reinstate it to the local db
   Prepare_Media_Item(item_id_);

   OPEN get_media_object;
   FETCH get_media_object INTO media_obj_;
   CLOSE get_media_object;

END Get_Media_Item;
-- This Procedure returns media object when the obj id is provided.
-- Some clients in CFGCHR/CFGRUL use this.
PROCEDURE Get_Media_Item(
   media_obj_     OUT   BLOB,
   objid_         IN    VARCHAR2)
IS
   lu_rec_ media_item_tab%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Id___(objid_);
   Get_Media_Item(media_obj_,lu_rec_.item_id);
END Get_Media_Item;

PROCEDURE Get_Default_Media_Item(
   media_obj_     OUT   BLOB,
   library_id_    IN    VARCHAR2)
IS
   objid_   MEDIA_ITEM_JOIN.objid%TYPE;
BEGIN
   objid_ := Media_Library_Item_API.Get_Def_Media_Obj_Id(library_id_);
   Get_Media_Item(media_obj_,objid_);
END Get_Default_Media_Item;

PROCEDURE Set_Media_Item_Type (
   item_id_         IN NUMBER,
   media_item_type_ IN VARCHAR2)
IS
   attr_       VARCHAR2(2000);
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
   info_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Client_SYS.Add_To_Attr('MEDIA_ITEM_TYPE_DB', media_item_type_, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Set_Media_Item_Type;

PROCEDURE Set_Media_File (
   item_id_    IN NUMBER,
   media_file_ IN VARCHAR2)
IS
   attr_       VARCHAR2(2000);
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
   info_       VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Client_SYS.Add_To_Attr('MEDIA_FILE', media_file_, attr_);
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Set_Media_File;

FUNCTION Make_Nice_Name_From_File_Name(
   file_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS

BEGIN
   RETURN INITCAP(SUBSTR(file_name_, 0 , INSTR(file_name_, '.', -1) - 1));
END Make_Nice_Name_From_File_Name;

PROCEDURE Set_Media_Attributes (
   item_id_         IN NUMBER,
   media_item_type_ IN VARCHAR2,
   media_file_      IN VARCHAR2)
IS
   attr_       VARCHAR2(2000);
   objid_      ROWID;
   objversion_ MEDIA_ITEM.objversion%TYPE;
   info_       VARCHAR2(2000);
   rec_        Public_Rec;
BEGIN
   rec_ := Get(item_id_);
   Get_Id_Version_By_Keys___(objid_, objversion_, item_id_);
   Client_SYS.Add_To_Attr('MEDIA_ITEM_TYPE_DB', media_item_type_, attr_);
   Client_SYS.Add_To_Attr('MEDIA_FILE', media_file_, attr_);
   
   IF (media_item_type_ = Media_Item_Type_API.DB_TEXT) THEN
      Client_SYS.Add_To_Attr('REPOSITORY_DB', Media_Item_Repository_Type_API.DB_DATABASE , attr_);
   END IF;
   
   -- The value <NULL> is set in MediaPanel.plsvc, and means the user
   -- did not enter a value for name.
   IF rec_.name = '<NULL>' THEN
      Client_SYS.Add_To_Attr('NAME', Make_Nice_Name_From_File_Name(media_file_), attr_);
   END IF;
   IF rec_.description = '<NULL>' THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', Make_Nice_Name_From_File_Name(media_file_), attr_);
   END IF;
   Modify__(info_, objid_, objversion_, attr_, 'DO');
END Set_Media_Attributes;

@UncheckedAccess
PROCEDURE Is_Update_Allowed(
   allowed_ OUT VARCHAR2,
   item_id_ IN  NUMBER)
IS
   media_obj_           NUMBER;
   media_txt_           NUMBER;
   
   CURSOR check_media_object IS
        SELECT dbms_lob.getlength(t.media_object), dbms_lob.getlength(t.media_text)
        FROM media_item_tab t
        WHERE t.item_id = item_id_;
BEGIN
   OPEN check_media_object;
   FETCH check_media_object INTO media_obj_,media_txt_;
   CLOSE check_media_object;
   
   IF NVL(media_obj_,0) > 0 OR  NVL(media_txt_,0) > 0  THEN
      allowed_ := 'FALSE';
   ELSE
      allowed_ := 'TRUE';
   END IF;
END Is_Update_Allowed;

@UncheckedAccess
PROCEDURE Set_Media_Item_Repository(
   item_id_   IN NUMBER,
   repo_type_ IN VARCHAR2)
IS
   rec_        MEDIA_ITEM_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(item_id_);
   rec_.repository := repo_type_;
   Modify___(rec_);
END Set_Media_Item_Repository;
