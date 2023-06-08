-----------------------------------------------------------------------------
--
--  Logical unit: MediaLibrary
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210813  puvelk  AM21R2-2516, Modified Copy_Library_By_Id() Method and added Copy_ML_Item_If_Not_Exist___() , Set_Default_If_Default_Was_Copied___() , Item_Exist_In_Library___() Methods
--  210725  puvelk  AM21R2-591, Modified Copy_Library_By_Id() Method.
--  210205  SHAGLK  AM2020R1-7260, Modified Insert___ to pass the service_ parameter to Transform_Object_Connection
--  201029  DEEKLK  AM2020R1-6341, Modified Dictionary_Sys methods for Solution Set support. 
--  180912  MDAHSE  SAUXXW4-9905, Add code to Insert___ to transform LU name and key ref by OCT rules, if needed.
--  180831  MDAHSE  SAUXXW4-9787, Change ROWID to objid in Get_Rowid_From_Keyref_And_View___ since some baseviews are overridden and has no ROWID.
--  ------------------------------Core 10.0----------------------------------
--  180504  SAMGLK  Bug 141301, Increased the size of key_refs.Modified Set_Obj_Keys_From_Ref___(),Check_And_Create_Connection(),Get_Library_Id_From_Obj_Id()
--                         Get_Ref_Translations(), Get_Key_List(),Get_Key_Ref(),Is_Line_Connected(),Get_Library_Conn_Description(),Get_Transformed_Item_Objid(),Get_Obj_Conn_Client_Hit_Count()
--  -------------------------------------------------------------------------
--  180425  MDAHSE  NGMWO-985, Added Get_Rowid_From_Keyref_Baseview and helper method to support MediaPanel in Aurena.
--  170914  ChAhLK  STRMF-14387, Modified Get_Default_Media() to support media archiving.
--  170629  SWiclk  STRSC-9391, Modified Check_And_Create_Connection() in order to get library_id from Get_Library_Id_From_Obj_Id().
--  170220  Hasplk  STRMF-8386, Merged LCS patch 132496.
--  170220          161116  Hasplk  Bug 132496, Modified method Copy_Library_By_Ref by adding cursor to handle enumeration type keys.
--  161121  JICE    Added public method Get_Default_Media.
--  160714  NISMLK  STRMF-6065, Added Set_Locked().
--  141115  ChDelk  PRMF-3319, Merged LCS Patch 113750.
--  141115          140312 ManWlk Bug 113750, Modified Get_Library_Id_From_Ref() to use key_ref in where clasue of get_library_id cusrsor instead of individual
--  141115          connected_obj_ref values so that MEDIA_LIBRARY_IX1 index is used.
--  140819  SamGLK  PRSA-249, Added method Copy_Media() to copy values between two libraries in a same LU.
--  140519  Chahlk  PBMF-7215, Modified Copy_Library_By_Ref() to pass exit_on_null_ param into Copy_Library_By_Id().
--  131217  RaKalk  Added function Get_Transformed_Item_Objid.
--  ---------------------------- MV -----------------------------------------
--  131203  NuKuLK  PBSA-2933, Modified Check_Insert___()
--  131129  NuKuLK  Hooks: Refactored and splitted code.
--  --------------------------- APPS 9 --------------------------------------
--  130910  chanlk  Model errors corrected.
--  130322  ErSrLK  Bug 109104, Modified Insert___() to fetch the next Library ID from sequence Appsrv_Media_Library_SEQ instead of calculating it.
--  130322          Also removed unused function Get_Next_Library_Id_().
--  110908  Hasplk  Added method Get_Library_Conn_Description.
--  110719  SuJalk  Bug 98117, Modified the select statement to convert the Library_Id to number before checking for the max value to treat the Library_Id as a number instead of VARCHAR2.
--  100422  Ajpelk  Merge rose method documentation
--  110316  SuJalk  Added exit_on_null_ parameter to Copy_Library_By_Ref and Copy_Library_By_Id.
--  100816  Bjsase  Added method Get_Key_Ref.
--  100324  Hasplk  Added method Get_Source_Name.
--  100222  Hasplk  Modified Get_Library_Id_From_Obj_Id method by simplifying its content.
--  100113  Hasplk  Added method Remove_Library.
--  --------------------------Eagle----------------------------------------------
--  091207  JICE    Added checks if no record found in Get_Default-methods.
--  091202  SuJalk  Added methods Get_Obj_Ref1, Get_Obj_Ref2, Get_Obj_Ref3, Get_Obj_Ref4, Get_Obj_Ref5.
--  091120  Bjsase  Added Set_Obj_Keys_From_Ref___
--  091113  Hasplk  Modified method Is_Line_Connected to return correct value.
--  091112  SuJalk  Modified the Copy_Library_By_Id to exclude obsolete media items.
--  091110  Bjsase  Commented not null check on library id in Unpack_Check_Insert___
--  091106  Hasplk  Corrected Get_Content_Restriction method.
--  091105  Hasplk  Added method Is_Line_Connected.
--  091104  Hasplk  Corrected view comments.Create reference to MediaItemType.
--  091029  PAWELK  Renamed LU InfoObjectCollection to MediaLibrary. Changed the code accordingly.
--  091029          Modified the module by setting module name from partca to appsrv.
--  091026  Hasplk  Added method Get_Next_Ref___.
--  091019  Hasplk  Modified method Check_And_Create_Connection to order keys in column order.
--  091019  Hasplk  Added columns collection_name, content_restriction. And changed column attributes.
--  091009  Hasplk  Removed method Get_Info_Object_Settings.
--  091007  Hasplk  Modified method Get_Ref_Translations to order keys on column index order.
--  090929  Hasplk  Added method Get_Info_Object_Settings.
--  090915  Hasplk  Added method Copy_Collection_By_Id, Copy_Collection_By_Ref.
--  090914  Hasplk  Added method Get_Ref_Translations.
--  090909  Hasplk  Modified true false predefine variable assignment.
--  090907  Hasplk  Added method Get_Collection_Id_From_Obj_Id.
--  090907  Hasplk  Changed Check_And_Create_Connection method parameters.
--  090903  Hasplk  Added methods Get_Collection_Id_From_Ref, Check_And_Create_Connection and Get_Next_Collection_Id_
--  090827  Hasplk  Generated code using Design tool.
--  090728  SuJalk  Removed collection id and added connnection object and connection object source.
--  090611  SuJalk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Ref___ ( ref_ VARCHAR2,
                           ptr_ IN OUT NUMBER,
                           val_ IN OUT VARCHAR2) RETURN BOOLEAN
IS
   from_  NUMBER;
   to_    NUMBER;
   text_separator_   VARCHAR2(1) := Client_SYS.text_separator_;
BEGIN
   from_ := nvl(ptr_, 1);
   to_   := instr(ref_, text_separator_, from_);
   IF (to_ > 0) THEN
      val_  := substr(ref_, from_, (to_-from_));
      ptr_   := to_+1;
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Get_Next_Ref___;


PROCEDURE Set_Obj_Keys_From_Ref___ (newrec_  IN OUT MEDIA_LIBRARY_TAB%ROWTYPE)
IS
  val_ref_         VARCHAR2(32000);
  val_ptr_         NUMBER := NULL;
  key_value_       VARCHAR2(2000);
  counter_         NUMBER := 0;

BEGIN
   val_ref_ := Object_Connection_Sys.Convert_To_Key_Value(newrec_.lu_name, newrec_.key_ref);

   WHILE Get_Next_Ref___(val_ref_, val_ptr_, key_value_) LOOP
      counter_ := counter_ + 1;
      CASE(counter_)
         WHEN 1 THEN newrec_.connected_obj_ref1 := key_value_;
         WHEN 2 THEN newrec_.connected_obj_ref2 := key_value_;
         WHEN 3 THEN newrec_.connected_obj_ref3 := key_value_;
         WHEN 4 THEN newrec_.connected_obj_ref4 := key_value_;
         WHEN 5 THEN newrec_.connected_obj_ref5 := key_value_;
      ELSE NULL;
      END CASE;
   END LOOP;

END Set_Obj_Keys_From_Ref___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MEDIA_LIBRARY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Check if the object should really be connected someplace else
   -- according to rules set up in Object Connection Transformation.
   Obj_Connect_LU_Transform_API.Transform_Object_Connection (newrec_.lu_name, newrec_.key_ref, 'MediaLibrary');

   newrec_.library_id := Appsrv_Media_Library_SEQ.NEXTVAL;
   newrec_.locked := 'FALSE';
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('LIBRARY_ID', newrec_.library_id, attr_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT media_library_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.locked := 'FALSE';
   super(newrec_, indrec_, attr_);
   IF newrec_.connected_obj_ref1 IS NULL THEN
      Set_Obj_Keys_From_Ref___(newrec_);
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Default_Media_Id (
   library_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_default_media_record IS
      SELECT   library_item_id
      FROM     MEDIA_LIBRARY_ITEM_TAB
      WHERE    library_id = library_id_
      AND      default_media = 'TRUE';

   library_item_id_ NUMBER;
BEGIN
   OPEN get_default_media_record;
   FETCH get_default_media_record INTO library_item_id_;
   IF get_default_media_record%NOTFOUND THEN
      library_item_id_ := NULL;
   END IF;
   CLOSE get_default_media_record;

   RETURN library_item_id_;
END Get_Default_Media_Id;


@UncheckedAccess
FUNCTION Get_Default_Media_Obj_Id (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_default_media_objid IS
      SELECT   item_id
      FROM     MEDIA_LIBRARY_ITEM_TAB
      WHERE    library_id = library_id_
      AND      default_media = 'TRUE';

   item_id_    MEDIA_LIBRARY_ITEM_TAB.item_id%TYPE;
BEGIN
   OPEN get_default_media_objid;
   FETCH get_default_media_objid INTO item_id_;
   IF get_default_media_objid%NOTFOUND THEN
      item_id_ := NULL;
   END IF;
   CLOSE get_default_media_objid;

   RETURN item_id_;
END Get_Default_Media_Obj_Id;

@UncheckedAccess
FUNCTION Get_Default_Media (
   library_id_ IN VARCHAR2 ) RETURN BLOB
IS
   item_id_ NUMBER;
   image_   BLOB := NULL;
BEGIN
   item_id_ := Media_Library_Item_API.Get_Item_Id(library_id_, Media_Library_Item_API.Get_Def_Media_Library_Item_Id(library_id_));

   IF item_id_ IS NOT NULL THEN
      Media_Item_API.Get_Media_Item(image_, item_id_);
   END IF;

   RETURN image_;
END Get_Default_Media;

-- Get_Library_Id_From_Ref
--   Returns library id for given data records' keys of particular lu name.(LU)
@UncheckedAccess
FUNCTION Get_Library_Id_From_Ref (
   connected_obj_source_   IN VARCHAR2,
   connected_obj_ref1_     IN VARCHAR2,
   connected_obj_ref2_     IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref3_     IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref4_     IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref5_     IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   library_id_ MEDIA_LIBRARY_TAB.library_id%TYPE;
   key_ref_    VARCHAR2(32000);
   value_list_ VARCHAR2(32000);
   ts_         VARCHAR2(1) := Client_SYS.text_separator_;

   CURSOR get_library_id IS
   SELECT library_id
      FROM MEDIA_LIBRARY_TAB
      WHERE lu_name = connected_obj_source_
      AND key_ref = key_ref_;
BEGIN
   value_list_ := connected_obj_ref1_||ts_||connected_obj_ref2_||ts_||connected_obj_ref3_||ts_||connected_obj_ref4_||ts_||connected_obj_ref5_||ts_;
   key_ref_ := Object_Connection_SYS.Convert_To_Key_Reference(connected_obj_source_, value_list_);

   OPEN get_library_id;
   FETCH get_library_id INTO library_id_;
   CLOSE get_library_id;

   RETURN library_id_;
END Get_Library_Id_From_Ref;


-- Check_And_Create_Connection
--   Returns library id as out param, for ObjId of given object source (LU)
--   If there is no library, create new library and returns new library id.
PROCEDURE Check_And_Create_Connection (
   library_id_             OUT VARCHAR2,
   connected_obj_source_   IN VARCHAR2,
   obj_id_                 IN VARCHAR2 )
IS
   newrec_     MEDIA_LIBRARY_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);

   connected_obj_ref1_  VARCHAR2(2000);
   connected_obj_ref2_  VARCHAR2(2000):= NULL;
   connected_obj_ref3_  VARCHAR2(2000):= NULL;
   connected_obj_ref4_  VARCHAR2(2000):= NULL;
   connected_obj_ref5_  VARCHAR2(2000):= NULL;

   key_ref_       VARCHAR2(32000);
   val_ref_       VARCHAR2(32000);
   key_ptr_       NUMBER := NULL;
   val_ptr_       NUMBER := NULL;
   key_name_      VARCHAR2(2000);
   key_val_       VARCHAR2(2000);
   counter_       NUMBER := 0;
   temp_          BOOLEAN;

BEGIN

   Dictionary_SYS.Get_Logical_Unit_Keys_(key_ref_, val_ref_, connected_obj_source_, obj_id_);

   WHILE Get_Next_Ref___(key_ref_, key_ptr_, key_name_) LOOP
      temp_ := Get_Next_Ref___(val_ref_, val_ptr_, key_val_);
      counter_ := counter_ + 1;
      CASE(counter_)
         WHEN 1 THEN connected_obj_ref1_ := key_val_;
         WHEN 2 THEN connected_obj_ref2_ := key_val_;
         WHEN 3 THEN connected_obj_ref3_ := key_val_;
         WHEN 4 THEN connected_obj_ref4_ := key_val_;
         WHEN 5 THEN connected_obj_ref5_ := key_val_;
      ELSE NULL;
      END CASE;
   END LOOP;

   IF (obj_id_ IS NOT NULL) THEN
      library_id_ := Get_Library_Id_From_Obj_Id(connected_obj_source_, obj_id_);
   ELSE
      library_id_ := Get_Library_Id_From_Ref(connected_obj_source_,
                                             connected_obj_ref1_,
                                             connected_obj_ref2_,
                                             connected_obj_ref3_,
                                             connected_obj_ref4_,
                                             connected_obj_ref5_ );
   END IF;

   IF library_id_ IS NULL THEN
      newrec_.lu_name := connected_obj_source_;
      newrec_.connected_obj_ref1 := connected_obj_ref1_;
      newrec_.connected_obj_ref2 := connected_obj_ref2_;
      newrec_.connected_obj_ref3 := connected_obj_ref3_;
      newrec_.connected_obj_ref4 := connected_obj_ref4_;
      newrec_.connected_obj_ref5 := connected_obj_ref5_;

      Client_SYS.Get_Key_Reference(newrec_.key_ref, connected_obj_source_, obj_id_);

      Insert___(objid_, objversion_, newrec_, attr_);
      library_id_ := Client_SYS.Get_Item_Value('LIBRARY_ID', attr_);
   END IF;
END Check_And_Create_Connection;


-- Get_Library_Id_From_Obj_Id
--   Returns library id for particular objid in particular LU.
FUNCTION Get_Library_Id_From_Obj_Id (
   connected_obj_source_   IN VARCHAR2,
   obj_id_                 IN VARCHAR2 ) RETURN VARCHAR2
IS
   key_ref_       VARCHAR2(32000);
   library_id_    NUMBER;
   CURSOR get_library IS
      SELECT library_id
      FROM MEDIA_LIBRARY_TAB
      WHERE lu_name = connected_obj_source_
      AND key_ref = key_ref_;
BEGIN

   Client_SYS.Get_Key_Reference(key_ref_, connected_obj_source_, obj_id_);
   IF key_ref_ IS NOT NULL THEN
      OPEN get_library;
      FETCH get_library INTO library_id_;
      CLOSE get_library;

      RETURN library_id_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Library_Id_From_Obj_Id;


FUNCTION Get_Ref_Translations (
   connected_obj_source_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   prompt_text_   VARCHAR2(32000);
   key_ref_       VARCHAR2(32000);
   ptr_           NUMBER := NULL;
   key_name_      VARCHAR2(2000);
   key_val_       VARCHAR2(2000);
   delim_         VARCHAR2(1);
BEGIN
   Dictionary_SYS.Get_Logical_Unit_Keys_(key_ref_, key_val_, connected_obj_source_);
   WHILE Get_Next_Ref___(key_ref_, ptr_, key_name_) LOOP
      prompt_text_ := prompt_text_ || delim_ || Language_SYS.Translate_Item_Prompt_(connected_obj_source_, key_name_);
      delim_ := '^';
   END LOOP;

   RETURN prompt_text_;
END Get_Ref_Translations;

@UncheckedAccess
FUNCTION Get_Key_List (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   key_ref_  VARCHAR2(32000);
   key_list_ VARCHAR2(32000);
   ptr_      NUMBER := NULL;
   key_name_ VARCHAR2(2000);
   delim_         VARCHAR2(1);
BEGIN
   key_ref_ := Get_Key_Ref(library_id_);
   WHILE Get_Next_Ref___(key_ref_, ptr_, key_name_) LOOP
      key_list_ := key_list_ || delim_ || SUBSTR(key_name_, 1, INSTR(key_name_, '=')-1);
      delim_ := '^';
   END LOOP;

   RETURN key_list_;
END Get_Key_List;

@UncheckedAccess
FUNCTION Get_Source_Name (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_lu_name IS
      SELECT   lu_name
      FROM     MEDIA_LIBRARY_TAB
      WHERE    library_id = library_id_;

   lu_name_ MEDIA_LIBRARY_TAB.lu_name%TYPE;
BEGIN
   OPEN get_lu_name;
   FETCH get_lu_name INTO lu_name_;
   CLOSE get_lu_name;

   RETURN lu_name_;
END Get_Source_Name;


@UncheckedAccess
FUNCTION Get_Key_Ref (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_key_ref IS
      SELECT   key_ref
      FROM     MEDIA_LIBRARY_TAB
      WHERE    library_id = library_id_;

   key_ref_ VARCHAR2(32000);
BEGIN
   OPEN get_key_ref;
   FETCH get_key_ref INTO key_ref_;
   CLOSE get_key_ref;

   RETURN key_ref_;
END Get_Key_Ref;


@UncheckedAccess
FUNCTION Get_Obj_Ref1 (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_connected_obj_ref1 IS
      SELECT   connected_obj_ref1
      FROM     MEDIA_LIBRARY_TAB
      WHERE    library_id = library_id_;

   connected_obj_ref1_ MEDIA_LIBRARY_TAB.connected_obj_ref1%TYPE;
BEGIN
   OPEN get_connected_obj_ref1;
   FETCH get_connected_obj_ref1 INTO connected_obj_ref1_;
   CLOSE get_connected_obj_ref1;

   RETURN connected_obj_ref1_;
END Get_Obj_Ref1;


@UncheckedAccess
FUNCTION Get_Obj_Ref2 (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_connected_obj_ref2 IS
      SELECT   connected_obj_ref2
      FROM     MEDIA_LIBRARY_TAB
      WHERE    library_id = library_id_;

   connected_obj_ref2_ MEDIA_LIBRARY_TAB.connected_obj_ref2%TYPE;
BEGIN
   OPEN get_connected_obj_ref2;
   FETCH get_connected_obj_ref2 INTO connected_obj_ref2_;
   CLOSE get_connected_obj_ref2;

   RETURN connected_obj_ref2_;
END Get_Obj_Ref2;


@UncheckedAccess
FUNCTION Get_Obj_Ref3 (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_connected_obj_ref3 IS
      SELECT   connected_obj_ref3
      FROM     MEDIA_LIBRARY_TAB
      WHERE    library_id = library_id_;

   connected_obj_ref3_ MEDIA_LIBRARY_TAB.connected_obj_ref3%TYPE;
BEGIN
   OPEN get_connected_obj_ref3;
   FETCH get_connected_obj_ref3 INTO connected_obj_ref3_;
   CLOSE get_connected_obj_ref3;

   RETURN connected_obj_ref3_;
END Get_Obj_Ref3;


@UncheckedAccess
FUNCTION Get_Obj_Ref4 (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_connected_obj_ref4 IS
      SELECT   connected_obj_ref4
      FROM     MEDIA_LIBRARY_TAB
      WHERE    library_id = library_id_;

   connected_obj_ref4_ MEDIA_LIBRARY_TAB.connected_obj_ref4%TYPE;
BEGIN
   OPEN get_connected_obj_ref4;
   FETCH get_connected_obj_ref4 INTO connected_obj_ref4_;
   CLOSE get_connected_obj_ref4;

   RETURN connected_obj_ref4_;
END Get_Obj_Ref4;


@UncheckedAccess
FUNCTION Get_Obj_Ref5 (
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_connected_obj_ref5 IS
      SELECT   connected_obj_ref5
      FROM     MEDIA_LIBRARY_TAB
      WHERE    library_id = library_id_;

   connected_obj_ref5_ MEDIA_LIBRARY_TAB.connected_obj_ref5%TYPE;
BEGIN
   OPEN get_connected_obj_ref5;
   FETCH get_connected_obj_ref5 INTO connected_obj_ref5_;
   CLOSE get_connected_obj_ref5;

   RETURN connected_obj_ref5_;
END Get_Obj_Ref5;


PROCEDURE Copy_Library_By_Id (
   library_id_    IN VARCHAR2,
   to_library_id_ IN VARCHAR2,
   ignore_errors_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   default_item_id_ NUMBER;

   -- Order by to ensure setting of correct default media on copy
   CURSOR get_ml_item_lines IS
      SELECT   lt.library_item_id, lt.default_media, lt.item_id
      FROM     MEDIA_LIBRARY_ITEM_TAB lt, media_item_tab mit
      WHERE    lt.library_id = library_id_
      AND      lt.item_id = mit.item_id
      AND      mit.obsolete = 'FALSE'
      ORDER BY library_item_id;

   items_were_copied_ BOOLEAN := FALSE;
   items_found_       BOOLEAN := FALSE;
BEGIN

   FOR ml_item IN get_ml_item_lines LOOP
      items_found_ := TRUE;
      Copy_ML_Item_If_Not_Exist___(to_library_id_, ml_item.item_id, library_id_, ml_item.library_item_id, ml_item.default_media, default_item_id_, items_were_copied_);
   END LOOP;

   IF items_were_copied_ THEN
      Set_Default_If_Default_Was_Copied___(default_item_id_, to_library_id_);

   ELSIF items_found_ AND (ignore_errors_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'MEDIAEXISTING: Copied Media item(s) is/are already existing in this Media Library');

   ELSIF NOT items_found_ AND ignore_errors_ = 'FALSE' THEN
      Error_SYS.Record_General(lu_name_, 'NOMEDIALIBRARYITEMS: No Media library items found for library [:P1]', library_id_);
   END IF;

END Copy_Library_By_Id;

PROCEDURE Copy_ML_Item_If_Not_Exist___ (
   to_library_id_                   IN VARCHAR2,
   item_id_                         IN media_library_item_tab.item_id%TYPE,
   library_id_                      IN VARCHAR2,
   library_item_id_                 IN media_library_item_tab.library_item_id%TYPE,
   default_media_                   IN media_library_item_tab.default_media%TYPE,
   default_item_id_                 IN OUT NUMBER,
   items_were_copied_               IN OUT BOOLEAN)
IS
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);

BEGIN
   IF NOT Item_Exist_In_Library___(to_library_id_,  item_id_) THEN
      Media_Library_Item_API.Copy_Library_Item(objid_, objversion_, library_id_, library_item_id_, to_library_id_);
      IF default_media_ = 'TRUE' THEN
         default_item_id_ := item_id_;
      END IF;
      items_were_copied_ := TRUE;
   END IF;
END Copy_ML_Item_If_Not_Exist___;

PROCEDURE Set_Default_If_Default_Was_Copied___ (
   default_item_id_ IN NUMBER,
   to_library_id_   IN VARCHAR2)
IS
   default_lib_item_id_ NUMBER;

   CURSOR get_copied_default IS
      SELECT library_item_id
      FROM MEDIA_LIBRARY_ITEM_TAB
      WHERE library_id = to_library_id_
      AND item_id = default_item_id_;

BEGIN
   OPEN get_copied_default;
   FETCH get_copied_default INTO default_lib_item_id_;
   IF get_copied_default%FOUND THEN
      Media_Library_Item_API.Set_Default_Library_Media(to_library_id_, default_lib_item_id_);
   END IF;
   CLOSE get_copied_default;
END Set_Default_If_Default_Was_Copied___;

FUNCTION Item_Exist_In_Library___ (
   to_library_id_  IN VARCHAR2,
   item_id_        IN VARCHAR2) RETURN BOOLEAN
IS
   CURSOR check_exist(temp_library_id_ IN VARCHAR2, temp_item_id_ NUMBER) IS
      SELECT 1 FROM MEDIA_LIBRARY_ITEM_TAB
      WHERE library_id = temp_library_id_
      AND item_id = temp_item_id_;
   exist_ NUMBER;
BEGIN
   OPEN check_exist(to_library_id_, item_id_);
   FETCH check_exist INTO exist_;
   IF check_exist%FOUND THEN
      CLOSE check_exist;
      RETURN TRUE;
   ELSE
      CLOSE check_exist;
      RETURN FALSE;
   END IF;
END Item_Exist_In_Library___;

PROCEDURE Copy_Library_By_Ref (
   connected_obj_source_   IN VARCHAR2,
   connected_obj_ref1_     IN VARCHAR2,
   connected_obj_ref2_     IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref3_     IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref4_     IN VARCHAR2 DEFAULT NULL,
   connected_obj_ref5_     IN VARCHAR2 DEFAULT NULL,
   to_library_id_          IN VARCHAR2,
   exit_on_null_           IN VARCHAR2 DEFAULT 'FALSE' )
IS
   library_id_    VARCHAR2(200);
   value_         VARCHAR2(2000);
   lu_            VARCHAR2(2000);

   CURSOR get_library_id IS
   SELECT library_id
     FROM MEDIA_LIBRARY_TAB
    WHERE lu_name = connected_obj_source_
      AND connected_obj_ref1 = connected_obj_ref1_
      AND NVL(connected_obj_ref2, 'DuMmy') = NVL(connected_obj_ref2_, 'DuMmy')
      AND NVL(connected_obj_ref3, 'DuMmy') = NVL(connected_obj_ref3_, 'DuMmy')
      AND NVL(connected_obj_ref4, 'DuMmy') = NVL(connected_obj_ref4_, 'DuMmy')
      AND NVL(connected_obj_ref5, 'DuMmy') = NVL(connected_obj_ref5_, 'DuMmy');
BEGIN

   OPEN get_library_id;
   FETCH get_library_id INTO library_id_;
   CLOSE get_library_id;

   IF library_id_ IS NULL THEN
      IF connected_obj_ref1_ IS NOT NULL THEN
         value_ := connected_obj_ref1_;
      END IF;
      IF connected_obj_ref2_ IS NOT NULL THEN
         value_ := value_ || '-' || connected_obj_ref2_;
      END IF;
      IF connected_obj_ref3_ IS NOT NULL THEN
         value_ := value_ || '-' || connected_obj_ref3_;
      END IF;
      IF connected_obj_ref4_ IS NOT NULL THEN
         value_ := value_ || '-' || connected_obj_ref4_;
      END IF;
      IF connected_obj_ref5_ IS NOT NULL THEN
         value_ := value_ || '-' || connected_obj_ref5_;
      END IF;
      -- Error should not be used when copying multiple items when copying config spec rev. In that case exit_on_null_ is TRUE.
      IF (exit_on_null_ != 'TRUE') THEN
         lu_ := Language_SYS.Translate_Lu_Prompt_(connected_obj_source_);
         Error_SYS.Record_General(lu_name_, 'NOMEDIAOBJECT: No Media Library found for source [:P1] values [:P2]', lu_, value_);
      END IF;
   END IF;

   IF (exit_on_null_ = 'TRUE' AND library_id_ IS NOT NULL) OR (exit_on_null_ != 'TRUE') THEN
      Copy_Library_By_Id(library_id_, to_library_id_, exit_on_null_);
   END IF;
END Copy_Library_By_Ref;

-- Copy_Media() method is only written to copy values within same LUs - SAMGLK.
PROCEDURE Copy_Media(
      key_ref_from_ IN VARCHAR2,
      lu_name_ IN VARCHAR2,
      obj_id_to_ IN VARCHAR2)
IS
   CURSOR get_from_rec IS
    SELECT library_id
    FROM MEDIA_LIBRARY_TAB
    WHERE lu_name = lu_name_
    AND key_ref = key_ref_from_;

   library_id_from_ media_library_tab.library_id%TYPE;
   library_id_to_ media_library_tab.library_id%TYPE;

BEGIN
   -- Create a new connection
   library_id_to_ := NULL;
   Check_And_Create_Connection(library_id_to_,lu_name_,obj_id_to_);

   OPEN get_from_rec;
   FETCH get_from_rec INTO library_id_from_;
   CLOSE get_from_rec;
   Copy_Library_By_Id(library_id_from_,library_id_to_, 'TRUE');
END Copy_Media;


@UncheckedAccess
FUNCTION Is_Line_Connected (
   obj_source_ IN VARCHAR2,
   obj_id_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   key_ref_ VARCHAR2(32000);
   temp_    VARCHAR2(5);

   CURSOR get_lines IS
   SELECT DECODE(count(*),0,'FALSE','TRUE') state
      FROM MEDIA_LIBRARY_TAB lib, MEDIA_LIBRARY_ITEM_TAB line
      WHERE lib.lu_name = obj_source_
      AND lib.key_ref = key_ref_
      AND lib.library_id = line.library_id;

BEGIN
   Client_SYS.Get_Key_Reference(key_ref_, obj_source_, obj_id_);
   OPEN get_lines;
   FETCH get_lines INTO temp_;
   CLOSE get_lines;

   RETURN temp_;
END Is_Line_Connected;


PROCEDURE Remove_Library (
   library_id_ IN VARCHAR2,
   action_ IN VARCHAR2 )
IS
   remrec_     MEDIA_LIBRARY_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN

   Get_Id_Version_By_Keys___ (objid_, objversion_, library_id_);
   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Check_Delete___(remrec_);
   ELSIF (action_ = 'DO') THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
END Remove_Library;


FUNCTION Get_Library_Conn_Description(
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   desc_       VARCHAR2(2000);
   obj_source_ VARCHAR2(2000);
   key_ref_    VARCHAR2(32000);

   CURSOR get_lib IS
      SELECT lu_name, key_ref
      FROM MEDIA_LIBRARY_TAB
      WHERE library_id = library_id_;
BEGIN

   OPEN get_lib;
   FETCH get_lib INTO obj_source_, key_ref_;
   CLOSE get_lib;

   Object_Connection_SYS.Get_Connection_Description(desc_, obj_source_, key_ref_);
   RETURN desc_;
END Get_Library_Conn_Description;

@UncheckedAccess
FUNCTION Get_Transformed_Item_Objid (
   target_lu_           IN VARCHAR2,
   key_ref_             IN VARCHAR2,
   media_item_type_db_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   source_ref_list_ CLOB;
   source_ref_      VARCHAR2(32000) := key_ref_;

   ptr_                  NUMBER;
   source_lu_            VARCHAR2(2000) := target_lu_;
   read_only_            VARCHAR2(30);
   counter_              INTEGER := 0;
   trans_source_lu_name_ VARCHAR2(2000);

   first_item_objid_     VARCHAR2(100);
   item_objid_           VARCHAR2(100);

   CURSOR get_media_item_id IS
   SELECT i.ROWID
     FROM Media_Library_TAB l,
          Media_Library_Item_TAB li,
          Media_Item_TAB i
    WHERE l.library_id           = li.library_id
      AND li.default_media       = 'TRUE'
      AND li.item_id             = i.item_id
      AND l.lu_name              = source_lu_
      AND l.key_ref              = source_ref_
      AND i.media_item_type   = media_item_type_db_;
BEGIN
   OPEN get_media_item_id;
   FETCH get_media_item_id INTO first_item_objid_;
   CLOSE get_media_item_id;

   IF first_item_objid_ IS NOT NULL THEN
      RETURN first_item_objid_;
   END IF;

   source_ref_list_ := Obj_Connect_LU_Transform_API.Get_Transformed_Lu_Key_List(target_lu_, key_ref_, 'MediaLibrary');

   counter_ := NULL;
   WHILE Obj_Connect_Lu_Transform_API.Get_Next_From_Key_List(source_lu_, trans_source_lu_name_, source_ref_, read_only_, ptr_, source_ref_list_) = 'TRUE' LOOP

      -- Perform only if this is master or no other image is found
      IF (first_item_objid_ IS NULL) OR (read_only_ = 'FALSE') THEN
         item_objid_ := NULL;

         OPEN get_media_item_id;
         FETCH get_media_item_id INTO item_objid_;
         CLOSE get_media_item_id;

         -- This is the master item
         IF (item_objid_ IS NOT NULL) AND (read_only_ = 'FALSE') THEN
            RETURN item_objid_;
         END IF;

         -- Find the first image
         IF (first_item_objid_ IS NULL) AND (item_objid_ IS NOT NULL) THEN
            first_item_objid_ := item_objid_;
         END IF;
      END IF;
   END LOOP;

   RETURN first_item_objid_;
END Get_Transformed_Item_Objid;

FUNCTION Get_Obj_Conn_Client_Hit_Count (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2) RETURN NUMBER
IS
   service_name_     VARCHAR2(50) := 'MediaLibrary';
BEGIN
   RETURN Get_Obj_Conn_Client_Hit_Count(service_name_, lu_name_, key_ref_);
END Get_Obj_Conn_Client_Hit_Count;


FUNCTION Get_Obj_Conn_Client_Hit_Count (
   service_name_      IN VARCHAR2,
   lu_name_           IN VARCHAR2,
   key_ref_           IN VARCHAR2,
   service_view_name_ IN VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   count_       NUMBER := 0;
   total_count_ NUMBER := 0;

   source_ref_list_      CLOB;
   source_ref_           VARCHAR2(2000) := key_ref_;
   ptr_                  NUMBER;
   source_lu_            VARCHAR2(2000) := lu_name_;
   read_only_            VARCHAR2(30);
   trans_source_lu_name_ VARCHAR2(2000);

   CURSOR get_ocult_record_count(luname_ IN VARCHAR2, keyref_ IN VARCHAR2) IS
      SELECT COUNT(t.library_id) FROM MEDIA_LIBRARY_ITEM t, MEDIA_LIBRARY l WHERE
      t.library_id = l.library_id AND l.key_ref = keyref_ AND l.lu_name = luname_;
BEGIN

        OPEN get_ocult_record_count(lu_name_, key_ref_);
   FETCH get_ocult_record_count INTO total_count_;
   CLOSE get_ocult_record_count;

   source_ref_list_ := Obj_Connect_LU_Transform_API.Get_Transformed_Lu_Key_List(lu_name_, key_ref_, 'MediaLibrary');
   WHILE Obj_Connect_Lu_Transform_API.Get_Next_From_Key_List(source_lu_, trans_source_lu_name_, source_ref_, read_only_, ptr_, source_ref_list_) = 'TRUE' LOOP
      OPEN get_ocult_record_count(source_lu_, source_ref_);
      FETCH get_ocult_record_count INTO count_;
      CLOSE get_ocult_record_count;
      total_count_ := total_count_ + count_;
   END LOOP;

   RETURN total_count_;
END Get_Obj_Conn_Client_Hit_Count;


PROCEDURE Copy (
   source_lu_name_      IN VARCHAR2,
   source_key_ref_      IN VARCHAR2,
   destination_lu_name_ IN VARCHAR2,
   destination_key_ref_ IN VARCHAR2 )
IS
   newrec_              MEDIA_LIBRARY_TAB%ROWTYPE;
   --
   CURSOR copy_object (
      lu_name_ VARCHAR2,
      key_ref_ VARCHAR2) IS
      SELECT *
      FROM  MEDIA_LIBRARY_TAB
      WHERE lu_name = lu_name_
      AND   key_ref = key_ref_;
BEGIN
   FOR rec_ IN copy_object(source_lu_name_, source_key_ref_) LOOP
      newrec_ := rec_;
      newrec_.library_id := Appsrv_Media_Library_SEQ.NEXTVAL;
      newrec_.lu_name := destination_lu_name_;
      newrec_.key_ref := destination_key_ref_;
      newrec_.rowkey := NULL;
      -- Triggers setting on new ref-fields
      newrec_.connected_obj_ref1 := NULL;
      --
      New___(newrec_);
      Copy_Library_By_Id(rec_.library_id, newrec_.library_id, 'TRUE');
      --
   END LOOP;
END Copy;

-- Set_Locked
--   Updates the value of locked of the media library.
PROCEDURE Set_Locked (
   library_id_ IN VARCHAR2,
   locked_     IN VARCHAR2)
IS
   rec_     MEDIA_LIBRARY_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(library_id_);
   rec_.locked := locked_;
   Modify___(rec_);
END Set_Locked;


-- MDAHSE, Wed Apr 25 22:08:45 2018
-- TODO: If Technology adds this method to Object_Connection_SYS, we should change to using that.

FUNCTION Get_Rowid_From_Keyref_Baseview (
   lu_                IN VARCHAR2,
   key_ref_           IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(lu_name_, 'MEDIA_LIBRARY', 'Get_Rowid_From_Keyref_Baseview');
   RETURN Get_Rowid_From_Keyref_And_View___(Dictionary_SYS.Get_Base_View_Active(lu_), key_ref_);
END Get_Rowid_From_Keyref_Baseview;


FUNCTION Get_Rowid_From_Keyref_And_View___ (
   view_              IN VARCHAR2,
   key_ref_           IN VARCHAR2) RETURN VARCHAR2
IS
   stmt_                VARCHAR2(2048);
   rowid_               VARCHAR2(128);
   data_cursor_         NUMBER;
   num_keys_            NUMBER;
   dummy_               NUMBER;
   key_toks_            Object_Connection_Sys.KEY_REF;
BEGIN

   stmt_ := 'SELECT objid FROM ' || view_ || ' WHERE ';

   Object_Connection_Sys.Tokenize_Key_Ref__(key_ref_, key_toks_, num_keys_);

   FOR key_counter_ IN 1..num_keys_ LOOP
      Assert_SYS.Assert_Is_Table_Column( view_ , key_toks_( key_counter_ ).NAME );
      stmt_ := stmt_ || key_toks_( key_counter_ ).NAME || ' = :bindvar' || key_counter_; -- NAME = :bindvarX

      IF key_counter_ < num_keys_ THEN
         stmt_ := stmt_ || ' AND ';
      END IF;
   END LOOP;

   -- Cursor pelimineries
   data_cursor_ := dbms_sql.open_cursor;
   --safe due to Assert_SYS.Assert_Is_Table_Column check
   @ApproveDynamicStatement(2018-04-25,mdahse)
   dbms_sql.parse (data_cursor_, stmt_, dbms_sql.native);

   -- Bind variables
   FOR key_counter_ IN 1..num_keys_ LOOP
      dbms_sql.bind_variable(data_cursor_, 'bindvar' || key_counter_, key_toks_( key_counter_ ).VALUE);
   END LOOP;

   -- Define return column
   dbms_sql.define_column(data_cursor_, 1, rowid_, 128);

   -- Execute
   dummy_ := dbms_sql.execute ( data_cursor_ );
   dummy_ := dbms_sql.fetch_rows ( data_cursor_ );

   -- Get the column values
   dbms_sql.column_value(data_cursor_, 1, rowid_);

   -- Close the cursor
   dbms_sql.close_cursor(data_cursor_);

   return rowid_;
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(data_cursor_)) THEN
         dbms_sql.close_cursor(data_cursor_);
      END IF;
      RAISE;
END Get_Rowid_From_Keyref_And_View___;
   

FUNCTION Get_Connected_Obj_Ref1_Title(
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_ref_titles_   VARCHAR2(32000);
   obj_ref_values_   VARCHAR2(32000);
   title_tokens_         Object_Connection_Sys.KEY_REF;
   no_of_tokens_     NUMBER;
   BEGIN
      obj_ref_titles_ := Get_Ref_Translations(Get_Lu_Name(library_id_));
      obj_ref_values_ := Get_Key_List(library_id_);
      Object_Connection_Sys.Tokenize_Key_Ref__(obj_ref_titles_, title_tokens_, no_of_tokens_);
      IF no_of_tokens_ > 0 THEN
         RETURN title_tokens_(1).name;
      ELSE
         RETURN NULL;
      END IF;      
END Get_Connected_Obj_Ref1_Title;   
   
FUNCTION Get_Connected_Obj_Ref2_Title(
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_ref_titles_   VARCHAR2(32000);
   obj_ref_values_   VARCHAR2(32000);
   title_tokens_         Object_Connection_Sys.KEY_REF;
   no_of_tokens_     NUMBER;
   BEGIN
      obj_ref_titles_ := Get_Ref_Translations(Get_Lu_Name(library_id_));
      obj_ref_values_ := Get_Key_List(library_id_);
      Object_Connection_Sys.Tokenize_Key_Ref__(obj_ref_titles_, title_tokens_, no_of_tokens_);
      IF no_of_tokens_ > 1 THEN
         RETURN title_tokens_(2).name;
      ELSE
         RETURN NULL;
      END IF;      
   END Get_Connected_Obj_Ref2_Title;     

   
FUNCTION Get_Connected_Obj_Ref3_Title(
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_ref_titles_   VARCHAR2(32000);
   obj_ref_values_   VARCHAR2(32000);
   title_tokens_         Object_Connection_Sys.KEY_REF;
   no_of_tokens_     NUMBER;
   BEGIN
      obj_ref_titles_ := Get_Ref_Translations(Get_Lu_Name(library_id_));
      obj_ref_values_ := Get_Key_List(library_id_);
      Object_Connection_Sys.Tokenize_Key_Ref__(obj_ref_titles_, title_tokens_, no_of_tokens_);
      IF no_of_tokens_ > 2 THEN
         RETURN title_tokens_(3).name;
      ELSE
         RETURN NULL;
      END IF;      
END Get_Connected_Obj_Ref3_Title;    
   

FUNCTION Get_Connected_Obj_Ref4_Title(
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_ref_titles_   VARCHAR2(32000);
   obj_ref_values_   VARCHAR2(32000);
   title_tokens_         Object_Connection_Sys.KEY_REF;
   no_of_tokens_     NUMBER;
   BEGIN
      obj_ref_titles_ := Get_Ref_Translations(Get_Lu_Name(library_id_));
      obj_ref_values_ := Get_Key_List(library_id_);
      Object_Connection_Sys.Tokenize_Key_Ref__(obj_ref_titles_, title_tokens_, no_of_tokens_);
      IF no_of_tokens_ > 3 THEN
         RETURN title_tokens_(4).name;
      ELSE
         RETURN NULL;
      END IF;      
END Get_Connected_Obj_Ref4_Title;    
   

FUNCTION Get_Connected_Obj_Ref5_Title(
   library_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   obj_ref_titles_   VARCHAR2(32000);
   obj_ref_values_   VARCHAR2(32000);
   title_tokens_         Object_Connection_Sys.KEY_REF;
   no_of_tokens_     NUMBER;
   BEGIN
      obj_ref_titles_ := Get_Ref_Translations(Get_Lu_Name(library_id_));
      obj_ref_values_ := Get_Key_List(library_id_);
      Object_Connection_Sys.Tokenize_Key_Ref__(obj_ref_titles_, title_tokens_, no_of_tokens_);
      IF no_of_tokens_ > 4 THEN
         RETURN title_tokens_(5).name;
      ELSE
         RETURN NULL;
      END IF;      
END Get_Connected_Obj_Ref5_Title;    
   
   