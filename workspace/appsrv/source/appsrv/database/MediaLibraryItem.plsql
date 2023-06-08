-----------------------------------------------------------------------------
--
--  Logical unit: MediaLibraryItem
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210517  DEEKLK  AM2020R1-7785, Modified Copy_Library_Item().
--  180117  CHAHLK  STRMF-16953, Modified Handle_Update() to fetch objversion when there is a mismatch.
--  160722  NISMLK  STRMF-6067, Added Connected_To_Locked_Media_Lib().
--  140808  THIMLK  PRMF-63, Merged LCS Patch 112393.
--  140808          130926  ThImLK   Bug 112393, Done some modifcations to handle private_media_item related functionality.
--  131203  NuKuLK  PBSA-2932, cleanup.
--  131201  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  130910  chanlk  Model errors corrected.
--  130322  ErSrLK  Bug 109104, Removed LibraryItemId assignments from Handle_Save(), Copy_Library_Item() and UnpackCheckInsert___()
--  130322          since correct value is assigned in Insert___().
--  121122  ErSrLK  Bug 106916, Modified Handle_Multi_Conn_Changes() to fetch the next Item ID from sequence Appsrv_Media_Item_SEQ instead of calculating it.
--  121015  SuJalk  Bug 105893, Added new view MEDIA_ITEM_JOIN2 and used the new view in function Media_Lib_Items_Obsolete.
--  121015  SuJalk  Bug 96685, Added media_file to the MEDIA_ITEM_JOIN view and modified Handle_Save to pass back media_file and media_item_type_db.
--  120824  Hasplk  Modified method Do_Remove to handle if there are no media item connected.
--  120629  Hasplk  Added new method Check_Remove and Do_Remove to use in media library cascade delete
--  120329  Hasplk  Added new view MEDIA_LIBRARY_ITEM_COUNT to use in Media pane Object count.
--  120301  RaKAlk  Modified Copy_Library_Item to copy custom fields.
--  111215  JENASE  Merged LCS patch 99603, Added method Get_Img_Item_Count_Per_Lib and modified Check_Delete___ to raise an error when deleting default media
--  111215          if there are other image items connected to the library.
--  110707  LoPrlk  Issue: SADEAGLE-1286, Altered the method Insert___.
--  100422  Ajpelk  Merge rose method documentation
--  --------------------------Eagle---------------------------------------------
--  100324  Pawelk  Bug 88701, Modified Unpack_Check_Insert___ by setting NULL value of attribute Obsolete to FALSE.
--  100222  Hasplk  Added method Get_Def_Media_Obj_Id.
--  091210  JICE    Modified Handle_Delete to not remove the media item.
--  091209  Hasplk  Added NOCHECK option for join type views' references. Did code quality cleanup.
--  091208  Hasplk  Modified message MEDIAINUSE.
--  091207  JICE    Return default_item in attribute string on insert.
--  091208  PaWelk  Modified Media_Lib_Items_Obsolete() to return TRUE even when there are no media item rows.
--  091207  JICE    Set default_item = TRUE when saving first image item.
--  091207  PaWelk  Added new parameter item_type_ to Media_Lib_Items_Obsolete().
--  091125  PaWelk  Added Media_Lib_Items_Obsolete().
--  091116  Pawelk  Modified Print_Media_Item() by adding a condition to check whether media is empty.
--  091112  BjSase  Added default check for media print check.
--  091112  SuJalk  Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to raise an error when entering obsolete media items.
--  091111  BjSase  Added check in Unpack_Check_Insert___ to handle null values for library_item_id
--  091109  Hasplk  Modified Copy_Library_Item method to use default print option.
--  091109  Pawelk  Increased the length of media_print_option_ in Print_Media_Item().
--  091105  Hasplk  Modified Prepare_Insert___ method to use correct API to decode value.
--  091104  Hasplk  Added method Handle_Multi_Conn_Changes.
--  091104  PaWelk  Added Media_Library_Item_Exist(). Replaced parameter as_attachemtn_ with print_option_ in
--  091104  PaWelk  Print_Media_Item().
--  091029  SuJalk  Moved code to APPSRV and renamed info object based names to media library based naming.
--  091028  Hasplk  Modified Remove_Lines_Connected method to check any connected InfoObject to Lines.
--  091020  PaWelk  Removed Get_Info_Object_Class().
--  091019  PaWelk  Added new column print to info_object_line and info_object_join views.
--  091019  Hasplk  Modified INFO_OBJECT_JOIN view. Removed InfoObjectClass from join view.
--  091015  Hasplk  Corrected missing columns in INFO_OBJECT_JOIN view.
--  091012  Hasplk  Modified Method Handle_Delete to InfoObject and InfoObjectLine Correctly.
--  091006  Hasplk  Added method Remove_Lines_Connected to remove InfoObjectLines
--  091005  PaWelk  Added media_item_type_db to the view info_object_join. Added Get_Text_Line_Id().
--  091002  Hasplk  Added missing column comments.
--  091001  Hasplk  Corrected issue on creating new info object when connect existing one.
--  090915  Hasplk  Added method Copy_Line.
--  090915  Hasplk  Modified method Handle_Save, and Insert___.
--  090911  Hasplk  Added new columns created_by and created_time. Modified INFO_OBJECT_JOIN with new columns.
--  090910  PaWelk  Added Conf_Char_Info_Obj_Exist(), Get_Def_Image_Line_Id(), Conf_Val_Info_Obj_Exist().
--  090910  PaWelk  Added Base_Part_Info_Obj_Exist(), Part_Cat_Info_Obj_Exist().
--  090910  PaWelk  Added the function Print_Info_Object() which can be used in report printing.
--  090908  Hasplk  Modified method Handle_Update to use correct Objid, Objversion
--  090908  PaWelk  Modified method Validate_Update__.
--  090908  Hasplk  Modified method Validate_Update__.
--  090907  Hasplk  Added method Get_Def_Image_Obj_Id.
--  090903  PaWelk  Added Get_Info_Object_Class(). Added info_object_class_db to view info_object_join.
--  090903  PaWelk  Modified Handle_Delete(), Handle_Update(), Validate_Update__().
--  090831  Hasplk  Changed Handle_Save() method to not pass Info_object_id.
--  090827  Hasplk  Regenarated using design tool. Corrected User defined methods' keys.
--  090819  HaSplk  Added method Is_Set_To_Line_Def_Image().
--  090814  SuJalk  Modified Validate_Update__ method to add more validations and added method description.
--  090731  SuJalk  Modified the code to re-order parameters.
--  090728  SuJalk  Removed collection id and added connnection object and connection object source.
--  090716  SuJalk  Made changes related to making info_object_class an IID.
--  090611  SuJalk  Created
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
   Client_SYS.Add_To_Attr('MEDIA_PRINT_OPTION', Media_Print_Option_API.Decode('DO_NOT_PRINT'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MEDIA_LIBRARY_ITEM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   item_rec_          Media_Item_API.Public_Rec;
   media_item_type_   VARCHAR2(200);
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := SYSDATE;
   item_rec_            := Media_Item_API.Get(newrec_.item_id);
   
   IF (item_rec_.media_item_type = 'IMAGE') AND (Media_LIbrary_API.Get_Default_Media_Id(newrec_.library_id) IS NULL) THEN
      newrec_.default_media := 'TRUE';
   END IF;
   newrec_.library_item_id := Get_Next_Library_Item_Id__(newrec_.library_id);
   super(objid_, objversion_, newrec_, attr_);
   
   media_item_type_ := Media_Item_Type_API.Decode(item_rec_.media_item_type);
   Client_SYS.Add_To_Attr('LIBRARY_ITEM_ID',    newrec_.library_item_id,   attr_);
   Client_SYS.Add_To_Attr('DEFAULT_MEDIA',      newrec_.default_media,     attr_);
   Client_SYS.Add_To_Attr('CREATED_BY',         newrec_.created_by,        attr_);
   Client_SYS.Add_To_Attr('CREATED_DATE',       newrec_.created_date,      attr_);
   Client_SYS.Add_To_Attr('NAME',               item_rec_.name,            attr_);   
   Client_SYS.Add_To_Attr('DESCRIPTION',        item_rec_.description,     attr_);   
   Client_SYS.Add_To_Attr('OBSOLETE',           item_rec_.obsolete,        attr_);   
   Client_SYS.Add_To_Attr('MEDIA_ITEM_TYPE_DB', item_rec_.media_item_type, attr_);
   Client_SYS.Add_To_Attr('MEDIA_ITEM_TYPE',    media_item_type_,          attr_);
   Validate_New_Media___(newrec_);
END Insert___;

@Override 
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     media_library_item_tab%ROWTYPE,
   newrec_     IN OUT media_library_item_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Validate_Modify_Media___(oldrec_, newrec_);
END Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN MEDIA_LIBRARY_ITEM_TAB%ROWTYPE )
IS
BEGIN
   super(remrec_);
   -- Default media items should not be deleted when there are other images connected to the library.
   IF (Get_Default_Media(remrec_.library_id, remrec_.library_item_id) = 'TRUE') AND (Get_Img_Item_Count_Per_Lib(remrec_.library_id) > 1) THEN
      Error_SYS.Record_General(lu_name_, 'CANTDELDEFMEDIA: It is not possible to remove the default image when other images exist.');
   END IF;
   IF (Media_Library_API.Get_Locked_Db(remrec_.library_id) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CANTDELETELOCKED: Media Library is locked. Cannot delete media items.');
   END IF;
END Check_Delete___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN MEDIA_LIBRARY_ITEM_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Validate_Remove_Media___(remrec_);
   IF (Media_Item_API.Get_Private_Media_Item(remrec_.item_id) = 'TRUE') THEN
      Media_Item_Api.Remove_Media_Item(remrec_.item_id);
   END IF;
END Delete___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT media_library_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   item_rec_  Media_Item_API.Public_Rec;
BEGIN
   super(newrec_, indrec_, attr_);
   IF newrec_.media_print_option IS NULL THEN
      newrec_.media_print_option := 'DO_NOT_PRINT';
   END IF;
   IF (newrec_.default_media IS NULL) THEN
      newrec_.default_media := 'FALSE';
   END IF;
   
   item_rec_ := Media_Item_API.Get(newrec_.item_id);
   IF (item_rec_.obsolete = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CANTADDOSBOLETE: This media item is obsolete and cannot be added.');
   END IF;
   IF (item_rec_.private_media_item = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CANTADDPRIVATE: This media item is private and cannot be added.');
   END IF;
   IF (Media_Library_API.Get_Locked_Db(newrec_.library_id) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CANTADDLOCKED: Media Library is locked. Cannot add media items.');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     media_library_item_tab%ROWTYPE,
   newrec_ IN OUT media_library_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'CREATED_BY', newrec_.created_by);
   Error_SYS.Check_Not_Null(lu_name_, 'CREATED_DATE', newrec_.created_date);
   IF (Media_Item_API.Get_Obsolete(newrec_.item_id) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CANTADDOSBOLETE: This media item is obsolete and cannot be added.');
   END IF;
   IF (Media_Library_API.Get_Locked_Db(newrec_.library_id) = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CANTADDLOCKED: Media Library is locked. Cannot add media items.');
   END IF;
END Check_Update___;

--Validate_New_Media___ provides an interface for the objects that use 
--media to validate when a new media is inserted. Such objects
--should implement this method to include its business logic.
PROCEDURE Validate_New_Media___(
   rec_       IN  MEDIA_LIBRARY_ITEM_TAB%ROWTYPE)
IS
   package_name_    VARCHAR2(30);
   stmt_            VARCHAR2(2000);
   attr_            VARCHAR2(32000);
   lu_name_         media_library_tab.lu_name%TYPE;
   key_ref_         media_library_tab.key_ref%TYPE;
BEGIN
   
   lu_name_      := Media_Library_Api.Get_Lu_Name(rec_.library_id);
   key_ref_      := Media_Library_Api.Get_Key_Ref(rec_.library_id);
   package_name_ := Object_Connection_SYS.Get_Package_Name(lu_name_);
   attr_  := Pack___(rec_);
   Client_SYS.Set_Item_Value('ROWKEY', rec_.rowkey, attr_);
   IF (Dictionary_SYS.Method_Is_Installed(package_name_, 'Validate_New_Media')) THEN
      stmt_ := 'BEGIN  ' ||
                   package_name_ || '.Validate_New_Media(:key_ref_, :attr_);
                END;';
      @ApproveDynamicStatement(2017-12-14,MAWILK)
      EXECUTE IMMEDIATE stmt_ USING IN  key_ref_, IN attr_;
   END IF;
END Validate_New_Media___;

--Validate_Modify_Media___ provides an interface for the objects that use 
--media to validate when a media is modified. Such objects
--should implement this method to include its business logic.
PROCEDURE Validate_Modify_Media___(
   oldrec_    IN  MEDIA_LIBRARY_ITEM_TAB%ROWTYPE,
   newrec_    IN  MEDIA_LIBRARY_ITEM_TAB%ROWTYPE)
IS
   package_name_    VARCHAR2(30);
   stmt_            VARCHAR2(2000);
   old_attr_        VARCHAR2(32000);
   new_attr_        VARCHAR2(32000);
   lu_name_         media_library_tab.lu_name%TYPE;
   key_ref_         media_library_tab.key_ref%TYPE;
BEGIN
   lu_name_      := Media_Library_Api.Get_Lu_Name(newrec_.library_id);
   key_ref_      := Media_Library_Api.Get_Key_Ref(newrec_.library_id);   
   package_name_ := Object_Connection_SYS.Get_Package_Name(lu_name_);
   old_attr_ := Pack___(oldrec_);
   Client_SYS.Set_Item_Value('ROWKEY', oldrec_.rowkey, old_attr_);
   new_attr_ := Pack___(newrec_);
   Client_SYS.Set_Item_Value('ROWKEY', newrec_.rowkey, new_attr_);

   IF (Dictionary_SYS.Method_Is_Installed(package_name_, 'Validate_Modify_Media')) THEN
      stmt_ := 'BEGIN  ' ||
                   package_name_ || '.Validate_Modify_Media(:key_ref_, :old_attr_, :new_attr_);
                END;';
      @ApproveDynamicStatement(2017-12-18,MAWILK)
      EXECUTE IMMEDIATE stmt_ USING IN  key_ref_, IN old_attr_, IN new_attr_;
   END IF;
END Validate_Modify_Media___;

--Validate_Remove_Media___ provides an interface for the objects that use 
--media to validate when a record is removed. Such objects
--should implement this method to include its business logic.
PROCEDURE Validate_Remove_Media___(
   rec_       IN  MEDIA_LIBRARY_ITEM_TAB%ROWTYPE)
IS
   package_name_    VARCHAR2(30);
   stmt_            VARCHAR2(2000);
   attr_            VARCHAR2(32000);
   lu_name_         media_library_tab.lu_name%TYPE;
   key_ref_         media_library_tab.key_ref%TYPE;
BEGIN
   lu_name_      := Media_Library_Api.Get_Lu_Name(rec_.library_id);
   key_ref_      := Media_Library_Api.Get_Key_Ref(rec_.library_id);   
   package_name_ := Object_Connection_SYS.Get_Package_Name(lu_name_);
   attr_  := Pack___(rec_);
   Client_SYS.Set_Item_Value('ROWKEY', rec_.rowkey, attr_);

   IF (Dictionary_SYS.Method_Is_Installed(package_name_, 'Validate_Remove_Media')) THEN
      stmt_ := 'BEGIN  ' ||
                   package_name_ || '.Validate_Remove_Media(:key_ref_, :attr_);
                END;';
      @ApproveDynamicStatement(2017-12-18,MAWILK)
      EXECUTE IMMEDIATE stmt_ USING IN key_ref_, IN attr_;
   END IF;
END Validate_Remove_Media___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Next_Library_Item_Id__ (
   library_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_next_line IS
   SELECT NVL(MAX(library_item_id), 0)
   FROM  MEDIA_LIBRARY_ITEM_TAB
   WHERE library_id  = library_id_;
   next_library_item_id_ NUMBER;
BEGIN
   OPEN get_next_line;
   FETCH get_next_line INTO next_library_item_id_;
   CLOSE get_next_line;

   RETURN next_library_item_id_ + 1;
END Get_Next_Library_Item_Id__;


-- Validate_Update__
--   This method will validate the data in Info object
--   and Info Object line when updating.
PROCEDURE Validate_Update__ (
   item_attr_           IN OUT VARCHAR2,
   library_item_attr_   IN OUT VARCHAR2,
   library_id_          IN VARCHAR2,
   library_item_id_     IN NUMBER,
   item_id_             IN NUMBER )
IS
   old_media_item_rec_ Media_Item_API.Public_Rec;
BEGIN
   Media_Item_API.Exist(item_id_);
   old_media_item_rec_ := Media_Item_API.Get(item_id_);
   IF ((old_media_item_rec_.obsolete = 'TRUE') AND (Client_SYS.Get_Item_Value('OBSOLETE', item_attr_)  != 'FALSE'))  THEN
      Error_SYS.Record_General(lu_name_, 'NOUPDOBSOLETE: Obsolete records may not be updated. ');
   END IF;
   IF ((Client_SYS.Get_Item_Value('DEFAULT_MEDIA', library_item_attr_) = 'TRUE') AND (Client_SYS.Get_Item_Value('OBSOLETE', item_attr_)  = 'TRUE')) THEN
      Error_SYS.Record_General(lu_name_, 'NODEFMEDFOROBSOL: Records set as default media may not be made obsolete. ');
   END IF;
END Validate_Update__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Save_Media_Item (
   info_       OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
BEGIN
   Media_Item_API.New__(info_, objid_, objversion_, attr_, 'DO');
END Save_Media_Item;


-- Handle_Save
--   Handles the save of both Info Object Line and Info Object objects.
PROCEDURE Handle_Save (
   info_               OUT    VARCHAR2,
   objid_              IN OUT VARCHAR2,
   objversion_         IN OUT VARCHAR2,
   item_attr_          IN OUT VARCHAR2,
   library_item_attr_  IN OUT VARCHAR2,
   library_id_         IN VARCHAR2 )
IS
   media_item_info_           VARCHAR2(32000);
   media_library_item_info_   VARCHAR2(32000);
   info_line_objid_           VARCHAR2(2000);
   info_line_objversion_      VARCHAR2(2000);
   item_id_                   VARCHAR2(200);
BEGIN

   item_id_ := Client_SYS.Get_Item_Value('ITEM_ID', library_item_attr_);
   -- Save Media Item first
   IF item_id_ IS NULL THEN
      Media_Item_API.New__(media_item_info_, objid_, objversion_, item_attr_, 'DO');
      item_id_ := Client_SYS.Get_Item_Value('ITEM_ID',item_attr_);
   ELSE
      Media_Item_API.Get_Id_Ver_By_Keys_Pub(objid_, objversion_, item_id_);
   END IF;
   -- Save Media Libarary Item Second
   Client_SYS.Add_To_Attr('LIBRARY_ID', library_id_, library_item_attr_);
   Client_SYS.Add_To_Attr('ITEM_ID', item_id_, library_item_attr_);
   New__(media_library_item_info_, info_line_objid_, info_line_objversion_, library_item_attr_, 'DO');
   Client_SYS.Add_To_Attr('MEDIA_FILE', Media_Item_API.Get_Media_File(item_id_), item_attr_);
   Client_SYS.Add_To_Attr('MEDIA_ITEM_TYPE_DB', Media_Item_API.Get_Media_Item_Type_Db(item_id_), item_attr_);
   info_ := media_item_info_ || ' ' || media_library_item_info_;
END Handle_Save;


PROCEDURE Handle_Update (
   info_                OUT    VARCHAR2,
   library_item_attr_   IN OUT VARCHAR2,
   item_attr_           IN OUT VARCHAR2,
   objid_               IN OUT VARCHAR2,
   objversion_          IN OUT VARCHAR2,
   library_id_          IN VARCHAR2,
   library_item_id_     IN NUMBER,
   media_item_id_       IN NUMBER )
IS
   media_item_info_           VARCHAR2(32000);
   media_library_item_info_   VARCHAR2(32000);
   media_item_objid_          VARCHAR2(2000);
   media_item_objver_         media_item.objversion%TYPE;
   media_library_item_objid_  VARCHAR2(2000);
   media_library_item_objver_ MEDIA_LIBRARY_ITEM.objversion%TYPE;
BEGIN

   Validate_Update__(item_attr_, library_item_attr_, library_id_, library_item_id_, media_item_id_);
   Media_Item_API.Get_Id_Ver_By_Keys_Pub(media_item_objid_, media_item_objver_, media_item_id_);
   IF media_item_objid_ != objid_ OR media_item_objver_ != objversion_ THEN
      objid_ := media_item_objid_;
      objversion_ := media_item_objver_;
   END IF;
   Modify_Media_Item(media_item_info_, item_attr_, objid_, objversion_);
   Get_Id_Version_By_Keys___(media_library_item_objid_, media_library_item_objver_, library_id_, library_item_id_ );
   Modify__(media_library_item_info_, media_library_item_objid_, media_library_item_objver_, library_item_attr_, 'DO');
   info_ := media_item_info_ || ' ' || media_library_item_info_;
END Handle_Update;


PROCEDURE Modify_Media_Item (
   info_       OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
BEGIN
   Media_Item_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
END Modify_Media_Item;


PROCEDURE Handle_Delete (
   info_             OUT VARCHAR2,
   library_id_       IN VARCHAR2,
   library_item_id_  IN NUMBER,
   item_id_          IN NUMBER,
   action_           IN VARCHAR2 )
IS
   media_library_item_objid_  VARCHAR2(2000);
   media_library_item_objver_ MEDIA_LIBRARY_ITEM.objversion%TYPE;
BEGIN

   Get_Id_Version_By_Keys___(media_library_item_objid_, media_library_item_objver_, library_id_, library_item_id_);
   IF (action_ = 'DO')  THEN
      Media_Library_Report_API.Remove_Data(library_id_, library_item_id_);
   END IF;
   
   IF (Media_Item_API.Get_Private_Media_Item(item_id_) = 'TRUE') THEN
      Client_SYS.Add_Warning(lu_name_, 'CANTRECONPRIVATE: Private media item will be deleted from the media library.');
   END IF;

   Remove__(info_, media_library_item_objid_, media_library_item_objver_, action_);
END Handle_Delete;


PROCEDURE Remove_Media_Item (
   info_       OUT VARCHAR2,
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2,
   action_     IN VARCHAR2 )
IS
BEGIN
   Media_Item_API.Remove__(info_, objid_, objversion_, action_);
END Remove_Media_Item;


-- Set_Default_Library_Media
--   Sets the default image flag for a given record.
PROCEDURE Set_Default_Library_Media (
   library_id_       IN VARCHAR2,
   library_item_id_  IN NUMBER )
IS
BEGIN

   UPDATE   MEDIA_LIBRARY_ITEM_TAB
      SET   default_media = 'FALSE'
      WHERE default_media = 'TRUE'
      AND   library_id  = library_id_;

   UPDATE   MEDIA_LIBRARY_ITEM_TAB
      SET   default_media = 'TRUE'
      WHERE library_id  = library_id_
      AND   library_item_id = library_item_id_;
END Set_Default_Library_Media;


@UncheckedAccess
FUNCTION Is_Set_To_Library_Def_Media (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   count_ NUMBER;
   CURSOR get_def_count IS
      SELECT count(*)
      FROM MEDIA_LIBRARY_ITEM_TAB
      WHERE item_id = item_id_
      AND default_media = 'TRUE';
BEGIN
   OPEN get_def_count;
   FETCH get_def_count INTO count_;
   CLOSE get_def_count;

   IF count_ > 0 THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Set_To_Library_Def_Media;


@UncheckedAccess
FUNCTION Get_Def_Media_Obj_Id (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_def_img IS
      SELECT objid
      FROM MEDIA_ITEM_JOIN
      WHERE library_id  = library_id_;

   objid_   MEDIA_ITEM_JOIN.objid%TYPE;
BEGIN
   OPEN get_def_img;
   FETCH get_def_img INTO objid_;
   CLOSE get_def_img;

   RETURN objid_;
END Get_Def_Media_Obj_Id;


FUNCTION Get_Def_Media_Obj_Id (
   connected_obj_src_ IN VARCHAR2,
   obj_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   library_id_ NUMBER := Media_Library_API.Get_Library_Id_From_Obj_Id(connected_obj_src_, obj_id_);
BEGIN

   IF library_id_ IS NOT NULL THEN
      RETURN Get_Def_Media_Obj_Id(library_id_);
   END IF;
   RETURN NULL;
END Get_Def_Media_Obj_Id;


@UncheckedAccess
FUNCTION Print_Media_Item (
   library_id_       IN VARCHAR2,
   library_item_id_  IN NUMBER,
   report_id_        IN VARCHAR2,
   print_option_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   media_print_option_     VARCHAR2(20);
   print_                  VARCHAR2(5) := 'FALSE';
   media_empty_            VARCHAR2(5) := 'TRUE';
BEGIN
   IF (Media_Item_Type_API.Encode(Media_Item_API.Get_Media_Item_Type(Get_Item_Id(library_id_, library_item_id_)))) = 'TEXT' THEN
      media_empty_ := Media_Item_API.Media_Text_Empty(Get_Item_Id(library_id_, library_item_id_));
   ELSIF (Media_Item_Type_API.Encode(Media_Item_API.Get_Media_Item_Type(Get_Item_Id(library_id_, library_item_id_)))) = 'IMAGE' THEN
      media_empty_ := Media_Item_API.Media_Object_Empty(Get_Item_Id(library_id_, library_item_id_));
   END IF;

   IF (media_empty_ = 'FALSE') THEN
      IF (Media_Library_Report_API.Check_Exist(library_id_, library_item_id_, report_id_) = 'TRUE') THEN
         media_print_option_ := Media_Print_Option_API.Encode( Media_Library_Report_API.Get_Media_Print_Option(library_id_, library_item_id_, report_id_));
         IF (media_print_option_ = print_option_) THEN
            print_ := 'TRUE';
         ELSE
            print_ := 'FALSE';
         END IF;
      ELSE
         media_print_option_ := Media_Print_Option_API.Encode( Media_Library_Item_API.Get_Media_Print_Option(library_id_, library_item_id_));
         IF (media_print_option_ = print_option_) THEN
            print_ := 'TRUE';
         ELSE
            print_ := 'FALSE';
         END IF;
      END IF;
   END IF;
   RETURN print_;
END Print_Media_Item;


@UncheckedAccess
FUNCTION Get_Text_Library_Item_Id (
   library_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   library_item_id_    NUMBER;

   CURSOR get_default_rec IS
      SELECT library_item_id
      FROM MEDIA_ITEM_JOIN
      WHERE library_id  = library_id_
      AND media_item_type_db = 'TEXT';
BEGIN
   OPEN get_default_rec;
   FETCH get_default_rec INTO library_item_id_;
   IF get_default_rec%NOTFOUND THEN
      library_item_id_ := NULL;
   END IF;
   CLOSE get_default_rec;
   RETURN library_item_id_;
END Get_Text_Library_Item_Id;


@UncheckedAccess
FUNCTION Get_Def_Media_Library_Item_Id (
   library_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   library_item_id_   NUMBER;

   CURSOR get_default_rec IS
      SELECT library_item_id
      FROM MEDIA_LIBRARY_ITEM_TAB
      WHERE library_id  = library_id_
      AND default_media = 'TRUE';
BEGIN
   OPEN get_default_rec;
   FETCH get_default_rec INTO library_item_id_;
   IF get_default_rec%NOTFOUND THEN
      library_item_id_ := NULL;
   END IF;
   CLOSE get_default_rec;
   RETURN library_item_id_;

END Get_Def_Media_Library_Item_Id;


PROCEDURE Copy_Library_Item (
   objid_            OUT VARCHAR2,
   objversion_       OUT VARCHAR2,
   from_library_id_  IN VARCHAR2,
   from_library_item_id_ IN NUMBER,
   to_library_id_    IN VARCHAR2 )
IS
   oldrec_     MEDIA_LIBRARY_ITEM_TAB%ROWTYPE := Get_Object_By_Keys___(from_library_id_, from_library_item_id_);
   attr_       VARCHAR2(32000);
   newrec_     MEDIA_LIBRARY_ITEM_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   Client_SYS.Add_To_Attr('LIBRARY_ID', to_library_id_, attr_);
   Client_SYS.Add_To_Attr('ITEM_ID', oldrec_.item_id, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_MEDIA', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', oldrec_.note_text, attr_);
   Client_SYS.Add_To_Attr('MEDIA_PRINT_OPTION_DB', 'DO_NOT_PRINT', attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   -- Copy custom fields
   newrec_ := Get_Object_By_Id___(objid_);
   Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, oldrec_.rowkey, newrec_.rowkey);

END Copy_Library_Item;


PROCEDURE Remove_Lib_Item_Connected (
   item_id_ IN VARCHAR2,
   action_  IN VARCHAR2 )
IS
   CURSOR get_obj_lines IS
      SELECT objid, objversion
      FROM MEDIA_LIBRARY_ITEM
      WHERE item_id = item_id_;

   remrec_ MEDIA_LIBRARY_ITEM_TAB%ROWTYPE;
BEGIN

   IF action_ = 'CHECK' THEN
      FOR rec_ IN get_obj_lines LOOP
         Client_SYS.Add_Warning(lu_name_, 'MEDIAINUSE: Media Item is connected to media library item(s). Do you want to continue ?');
         EXIT;
      END LOOP;
   ELSIF action_ = 'DO' THEN
      FOR rec_ IN get_obj_lines LOOP
         remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
         Check_Delete___(remrec_);
         Delete___(rec_.objid, remrec_);
      END LOOP;
   END IF;
END Remove_Lib_Item_Connected;


@UncheckedAccess
FUNCTION Has_Multiple_Connections (
   item_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR has_multiple_conn IS
      SELECT count(*)
      FROM MEDIA_LIBRARY_ITEM_TAB
      WHERE item_id = item_id_;

   count_ NUMBER := 0;
BEGIN
   OPEN has_multiple_conn;
   FETCH has_multiple_conn INTO count_;
   CLOSE has_multiple_conn;

   IF count_ > 1 THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Has_Multiple_Connections;


@UncheckedAccess
FUNCTION Media_Library_Item_Exist (
   connected_obj_source_ IN VARCHAR2,
   connected_obj_ref1_   IN VARCHAR2,
   connected_obj_ref2_   IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref3_   IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref4_   IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref5_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   media_object_exist_   VARCHAR2(1);
   library_id_           VARCHAR2(200) := NULL;

   CURSOR get_media_item IS
      SELECT 1
      FROM MEDIA_LIBRARY_ITEM_TAB
      WHERE library_id = library_id_;
BEGIN
   library_id_ := Media_Library_API.Get_Library_Id_From_Ref(connected_obj_source_, connected_obj_ref1_, connected_obj_ref2_, connected_obj_ref3_, connected_obj_ref4_, connected_obj_ref5_);

   IF (library_id_ IS NULL) THEN
      RETURN library_id_;
   ELSE
      OPEN get_media_item;
      FETCH get_media_item INTO media_object_exist_;
      IF get_media_item%NOTFOUND THEN
         library_id_ := NULL;
      END IF;
      CLOSE get_media_item;
   END IF;
   RETURN library_id_;
END Media_Library_Item_Exist;




PROCEDURE Handle_Multi_Conn_Changes (
   info_             OUT VARCHAR2,
   media_item_id_    IN OUT NUMBER,
   library_id_       IN VARCHAR2,
   library_item_id_  IN NUMBER )
IS
   obj_rec_          Media_Item_API.Public_Rec;
   item_attr_        VARCHAR2(32000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
BEGIN

   obj_rec_ := Media_Item_API.Get(media_item_id_);
   IF (Has_Multiple_Connections(media_item_id_) = 'TRUE') THEN      
      media_item_id_ := Appsrv_Media_Item_SEQ.NEXTVAL;
      Client_SYS.Add_To_Attr('ITEM_ID', media_item_id_, item_attr_);
      Client_SYS.Add_To_Attr('NAME', obj_rec_.name, item_attr_);
      Client_SYS.Add_To_Attr('DESCRIPTION', obj_rec_.description, item_attr_);
      Client_SYS.Add_To_Attr('MEDIA_ITEM_TYPE', Media_Item_Type_API.Decode(obj_rec_.media_item_type), item_attr_);

      Save_Media_Item(info_, item_attr_, objid_, objversion_);

      UPDATE media_library_item_tab
         SET item_id = media_item_id_
         WHERE library_id = library_id_
         AND library_item_id = library_item_id_;

   END IF;
END Handle_Multi_Conn_Changes;


@UncheckedAccess
FUNCTION Media_Lib_Items_Obsolete (
   library_id_ IN VARCHAR2,
   item_type_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   lib_item_obsolete_   NUMBER;
   CURSOR get_media_lib_item IS
      SELECT 1
      FROM MEDIA_ITEM_JOIN2
      WHERE library_id = library_id_
      AND media_item_type_db = item_type_
      AND obsolete = 'FALSE' OR obsolete IS NULL;
BEGIN
   OPEN get_media_lib_item;
   FETCH get_media_lib_item INTO lib_item_obsolete_;
   IF get_media_lib_item%NOTFOUND THEN
      CLOSE get_media_lib_item;
      RETURN 'TRUE';
   ELSE
      CLOSE get_media_lib_item;
      RETURN 'FALSE';
   END IF;
END Media_Lib_Items_Obsolete;


-- Get_Img_Item_Count_Per_Lib
--   Returns the number of image type library items for a given library id.
@UncheckedAccess
FUNCTION Get_Img_Item_Count_Per_Lib (
   library_id_ IN VARCHAR2) RETURN NUMBER
IS
   count_ NUMBER := 0;

   CURSOR get_img_count IS
      SELECT count(*)
      FROM MEDIA_ITEM_JOIN
      WHERE library_id = library_id_
      AND media_item_type_db = 'IMAGE';
BEGIN
   OPEN get_img_count;
   FETCH get_img_count INTO count_;
   CLOSE get_img_count;

   RETURN count_;
END Get_Img_Item_Count_Per_Lib;


-- Check_Remove
--   Uses as the check procedure for when removing Media Library
PROCEDURE Check_Remove(
   library_id_ IN VARCHAR2)
IS
BEGIN
   NULL;
END Check_Remove;


-- Do_Remove
--   Uses to remove Library Items when remove Media Library
PROCEDURE Do_Remove(
   library_id_ IN VARCHAR2)
IS
   CURSOR get_obj_lines IS
      SELECT objid, objversion, default_media
      FROM MEDIA_LIBRARY_ITEM
      WHERE library_id = library_id_;

   remrec_           MEDIA_LIBRARY_ITEM_TAB%ROWTYPE;
   def_obj_id_       MEDIA_LIBRARY_ITEM.objid%TYPE;
   def_obj_version_  MEDIA_LIBRARY_ITEM.objversion%TYPE;
BEGIN
   
   -- First Remove non-default media items
   FOR rec_ IN get_obj_lines LOOP
      IF rec_.default_media = 'FALSE' THEN
         remrec_ := Lock_By_Id___(rec_.objid, rec_.objversion);
         Check_Delete___(remrec_);
         Delete___(rec_.objid, remrec_);
      ELSE
         def_obj_id_       := rec_.objid;
         def_obj_version_  := rec_.objversion;
      END IF;
   END LOOP;
   
   IF def_obj_id_ IS NOT NULL AND def_obj_version_ IS NOT NULL THEN
      -- Remove default media items
      remrec_ := Lock_By_Id___(def_obj_id_, def_obj_version_);
      Check_Delete___(remrec_);
      Delete___(def_obj_id_, remrec_);
   END IF;   
END Do_Remove;

@UncheckedAccess
FUNCTION Has_Single_Connection(
   item_id_ IN NUMBER ) RETURN VARCHAR2
IS
   CURSOR has_single_conn IS
      SELECT count(*)
      FROM MEDIA_LIBRARY_ITEM_TAB
      WHERE item_id = item_id_;

   count_ NUMBER := 0;
BEGIN
   OPEN has_single_conn;
   FETCH has_single_conn INTO count_;
   CLOSE has_single_conn;

   IF count_ = 1 THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Has_Single_Connection;

@UncheckedAccess
FUNCTION Connected_To_Locked_Media_Lib (
   item_id_ IN NUMBER ) RETURN NUMBER
IS   
   found_ NUMBER;   
   CURSOR get_media_library IS     
      SELECT 1
        FROM media_library_tab lib, media_library_item_tab mli
       WHERE lib.library_id = mli.library_id         
         AND lib.locked = 'TRUE'
         AND mli.item_id = item_id_;
BEGIN   
   OPEN get_media_library;
   FETCH get_media_library INTO found_;
   IF get_media_library%FOUND THEN
      found_ := 1;
   END IF;
   CLOSE get_media_library;
   RETURN nvl(found_, 0);
END Connected_To_Locked_Media_Lib;

PROCEDURE Validate_Modify_Media(
   oldrec_    IN  MEDIA_LIBRARY_ITEM_TAB%ROWTYPE,
   newrec_    IN  MEDIA_LIBRARY_ITEM_TAB%ROWTYPE)
IS
BEGIN
   Validate_Modify_Media___(oldrec_,newrec_);
END Validate_Modify_Media;

