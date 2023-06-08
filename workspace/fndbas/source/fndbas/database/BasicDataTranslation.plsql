-----------------------------------------------------------------------------
--
--  Logical unit: BasicDataTranslation
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021008  OVJOSE   Created.
--  030212  ROOD     Changed module to FNDBAS (ToDo#4149).
--  060214  ovjose   Added Cleanup_Basic_Data_Imp__ and also imp-method.
--  060919  ovjose   Bug 60440 Corrected.
--  060928  STDA     Translation Simplification (BUG#58618).
--  060108  UTGULK   Moved BASIC_DATA_TRANSLATION_HEAD to lu language_sys_imp. Modified methods Insert___,Delete___,Unpack_Check_Update___,Cleanup_Basic_Data_Imp__,
--                   Insert_Basic_Data_Translation,Get_Basic_Data_Translation___,Set_System_Translation,Remove_Basic_Data_Translation. Added Insert_Lang_Translation__(#Bug623355).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
--  101108  UsRaLK   Fixed an issue in [Insert_Basic_Data_Translation] that prevented inserting language translations on upgraded databases (Bug#94089)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Consistency___ (
   newrec_ IN LANGUAGE_SYS_TAB%ROWTYPE )
IS
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'MAIN_TYPE', newrec_.main_type);
   Error_SYS.Check_Not_Null(lu_name_, 'TYPE', newrec_.type);
   Error_SYS.Check_Not_Null(lu_name_, 'PATH', newrec_.path);
   Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE', newrec_.attribute);
   Error_SYS.Check_Not_Null(lu_name_, 'LANG_CODE', newrec_.lang_code);
   Error_SYS.Check_Not_Null(lu_name_, 'MODULE', newrec_.module);
   Error_SYS.Check_Not_Null(lu_name_, 'SYSTEM_DEFINED', newrec_.system_defined);
END Check_Consistency___;


FUNCTION Check_Exist_Prog___ (
   rec_ IN LANGUAGE_SYS_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_prog IS
      SELECT 1
      FROM LANGUAGE_SYS_TAB
      WHERE main_type = rec_.main_type
      AND type = rec_.type
      AND path = rec_.path
      AND attribute = rec_.attribute
      AND lang_code = 'PROG';
BEGIN
   OPEN exist_prog;
   FETCH exist_prog INTO dummy_;
   IF exist_prog%FOUND THEN
      CLOSE exist_prog;
      RETURN TRUE;
   ELSE
      CLOSE exist_prog;
      RETURN FALSE;
   END IF;
END Check_Exist_Prog___;


FUNCTION Get_Basic_Data_Translation___ (
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   main_type_     IN VARCHAR2,
   type_          IN VARCHAR2,
   path_          IN VARCHAR2,
   attribute_     IN VARCHAR2,
   lang_code_     IN VARCHAR2 DEFAULT NULL,
   only_chosen_lang_    IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   language_code_    VARCHAR2(5);
   text_             VARCHAR2(2000);
   CURSOR get_text IS
      SELECT text
      FROM LANGUAGE_SYS_TAB
      WHERE main_type = main_type_
      AND TYPE = type_
      AND path = path_
      AND attribute = attribute_
      AND lang_code = language_code_;

   CURSOR get_prog_text IS
    SELECT text
    FROM LANGUAGE_SYS_TAB
    WHERE main_type = main_type_
    AND TYPE = type_
    AND path = path_
    AND attribute = attribute_
    AND lang_code = 'PROG';

BEGIN
   IF Language_Sys_Imp_API.Get_Use_Translation_Db(module_,lu_)='TRUE' THEN
      Set_Language_Code___(language_code_, lang_code_);
      OPEN get_text;
      FETCH get_text INTO text_;
      CLOSE get_text;

      IF (text_ IS NOT NULL OR only_chosen_lang_ = Fnd_Boolean_API.DB_TRUE) THEN
         RETURN text_;
      ELSE
         OPEN get_prog_text;
         FETCH get_prog_text INTO text_;
         CLOSE get_prog_text;
         RETURN text_;
      END IF;
   ELSE
      RETURN NULL;
   END IF;
   RETURN text_;
END Get_Basic_Data_Translation___;


PROCEDURE Insert_Prog_Translation___ (
   record_ IN LANGUAGE_SYS_TAB%ROWTYPE )
IS
   rec_              LANGUAGE_SYS_TAB%ROWTYPE := record_;
   newrec_           LANGUAGE_SYS_TAB%ROWTYPE;
   oldrec_           LANGUAGE_SYS_TAB%ROWTYPE;
   attr_             VARCHAR2(2000);
   objid_            VARCHAR2(30);
   objversion_       VARCHAR2(2000);
BEGIN
   IF rec_.installation_text IS NULL THEN
      rec_.installation_text := rec_.text;
   END IF;
   rec_.lang_code := 'PROG';
   IF NOT Check_Exist___(rec_.main_type,
                         rec_.type,
                         rec_.path,
                         rec_.attribute,
                         rec_.lang_code) THEN
      Record_Assign___(newrec_, oldrec_, rec_);
      Check_Consistency___(newrec_);
      Insert___(objid_, objversion_, newrec_, attr_);
    ELSE
      oldrec_ := Lock_By_Keys___(rec_.main_type,
                                 rec_.type,
                                 rec_.path,
                                 rec_.attribute,
                                 rec_.lang_code);
      Record_Assign___(newrec_, oldrec_, rec_);
      Check_Consistency___(newrec_);
      IF (oldrec_.text = oldrec_.installation_text ) THEN
         newrec_.text  := oldrec_.text;
      END IF;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;

END Insert_Prog_Translation___;


PROCEDURE Record_Assign___ (
   outrec_ OUT LANGUAGE_SYS_TAB%ROWTYPE,
   oldrec_ IN  LANGUAGE_SYS_TAB%ROWTYPE,
   inrec_  IN  LANGUAGE_SYS_TAB%ROWTYPE )
IS
BEGIN
   outrec_ := oldrec_;
   outrec_.main_type := inrec_.main_type;
   outrec_.type := inrec_.type;
   outrec_.path := inrec_.path;
   outrec_.attribute := inrec_.attribute;
   outrec_.lang_code := inrec_.lang_code;
   outrec_.module := inrec_.module;
   outrec_.text := inrec_.text;
   outrec_.installation_text := inrec_.installation_text;
   outrec_.system_defined := inrec_.system_defined;
   outrec_.rowversion := inrec_.rowversion;
END Record_Assign___;


PROCEDURE Set_Language_Code___ (
   language_code_out_ OUT VARCHAR2,
   language_code_in_ IN VARCHAR2 )
IS
BEGIN
   language_code_out_ := language_code_in_;
   IF ( language_code_in_ IS NULL ) THEN
      language_code_out_ := nvl(fnd_session_api.get_language,'en');
   END IF;
END Set_Language_Code___;


PROCEDURE Update_Basic_Data_Trans___ (
   rec_ IN LANGUAGE_SYS_TAB%ROWTYPE )
IS
   newrec_           LANGUAGE_SYS_TAB%ROWTYPE;
   oldrec_           LANGUAGE_SYS_TAB%ROWTYPE;
   attr_             VARCHAR2(2000);
   objid_            VARCHAR2(30);
   objversion_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(rec_.main_type,
                              rec_.type,
                              rec_.path,
                              rec_.attribute,
                              rec_.lang_code);
   Record_Assign___(newrec_, oldrec_, rec_);
   Check_Consistency___(newrec_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Update_Basic_Data_Trans___;


PROCEDURE Insert_Lang_Translation___ (
   rec_ IN LANGUAGE_SYS_TAB%ROWTYPE )
IS
   newrec_           LANGUAGE_SYS_TAB%ROWTYPE;
   oldrec_           LANGUAGE_SYS_TAB%ROWTYPE;
   attr_             VARCHAR2(2000);
   objid_            VARCHAR2(30);
   objversion_       VARCHAR2(2000);
BEGIN
   Record_Assign___(newrec_, oldrec_, rec_);
   IF newrec_.installation_text IS NULL THEN
      newrec_.installation_text := newrec_.text;
   END IF;
   Check_Consistency___(rec_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Insert_Lang_Translation___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT LANGUAGE_SYS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.bulk := 0;
   -- Remove trailing '~' from path if it exists
   IF (newrec_.path LIKE '%~') THEN
      newrec_.path := Substr(newrec_.path, 1, length(newrec_.path)-1);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   Language_Sys_Imp_API.Insert_Into_Imp_Tab_(newrec_.module, Substr(Substr(newrec_.path, 1, instr(newrec_.path, '_')-1),1,30));
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN LANGUAGE_SYS_TAB%ROWTYPE )
IS
BEGIN
   IF remrec_.lang_code = 'PROG' THEN
      Error_SYS.Record_General(lu_name_, 'REMOVEPROGNOTALLOWED: Rows with language code :P1 is not allowed to delete', remrec_.lang_code);
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN LANGUAGE_SYS_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);

   Language_Sys_Imp_API.Remove_From_Imp_Tab_(remrec_.module, Substr(Substr(remrec_.path, 1, instr(remrec_.path, '_')-1),1,30));
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT language_sys_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);

   lu_               VARCHAR2(30);
   attribute_key_    VARCHAR2(120);
BEGIN
   lu_ := Client_SYS.Get_Item_Value('LU', attr_);
   attribute_key_ := Client_SYS.Get_Item_Value('ATTRIBUTE_KEY', attr_);
   newrec_.main_type := 'LU';
   newrec_.type := 'Basic Data';
   newrec_.path := lu_||'_'||newrec_.module||'.'||attribute_key_;
   newrec_.attribute := 'Text';
   newrec_.system_defined := 'FALSE';
   super(newrec_, indrec_, attr_);

   -- if Iso_Language_API in APPSRV is installed validate the language code
$IF ( Component_Appsrv_SYS.INSTALLED ) $THEN
   IF ( newrec_.lang_code <> 'PROG') THEN
      Iso_Language_API.Exist_Db(newrec_.lang_code);
   END IF;
$END
   IF (NOT Check_Exist_Prog___(newrec_) AND newrec_.lang_code <> 'PROG' ) THEN
      Error_SYS.Record_General(lu_name_, 'PROGNOTEXIST: Corresponding basic data does not exist for attribute key :P1', attribute_key_);
   END IF;
   -- Validate that lu and attribute key is not null because they are used to make the path.
   Error_SYS.Check_Not_Null(lu_name_, 'LU', lu_);
   Error_SYS.Check_Not_Null(lu_name_, 'ATTRIBUTE_KEY', attribute_key_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     language_sys_tab%ROWTYPE,
   newrec_ IN OUT language_sys_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (NOT Check_Exist_Prog___(newrec_)) THEN
      Error_SYS.Record_General(lu_name_, 'PROGNOTEXIST: Corresponding basic data does not exist for attribute key :P1', Client_SYS.Get_Item_Value('ATTRIBUTE_KEY', attr_));
   END IF;
END Check_Update___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     language_sys_tab%ROWTYPE,
   newrec_     IN OUT language_sys_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   -- Remove trailing '~' from path if it exists
   IF (newrec_.path LIKE '%~') THEN
      newrec_.path := Substr(newrec_.path, 1, length(newrec_.path)-1);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   --Add post-processing code here
END Update___;




-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy_Installation_Text__ (
   module_         IN VARCHAR2,
   lu_             IN VARCHAR2,
   lang_code_      IN VARCHAR2,
   attribute_key_  IN VARCHAR2 )
IS
   rec_              LANGUAGE_SYS_TAB%ROWTYPE;
   wildcard_path_    VARCHAR2(500);
BEGIN
   rec_.main_type := 'LU';
   rec_.type := 'Basic Data';
   rec_.path := lu_||'_'||module_||'.'||attribute_key_;
   rec_.attribute := 'Text';
   rec_.lang_code := lang_code_;
   rec_.module := module_;
   wildcard_path_ := lu_||'_'||module_||'.%';

   IF (module_ IS NOT NULL AND lu_ IS NOT NULL) THEN
      IF (attribute_key_ IS NULL) THEN
         UPDATE LANGUAGE_SYS_TAB
            SET text = installation_text
            WHERE main_type = rec_.main_type
            AND type = rec_.type
            AND path LIKE wildcard_path_
            AND attribute = rec_.attribute
            AND lang_code != 'PROG'
            AND module = rec_.module
            AND nvl(text,'') != nvl(installation_text,'')
            AND installation_text IS NOT NULL;
      ELSE
         UPDATE LANGUAGE_SYS_TAB
            SET text = installation_text
            WHERE main_type = rec_.main_type
            AND type = rec_.type
            AND path = rec_.path
            AND attribute = rec_.attribute
            AND lang_code = rec_.lang_code
            AND lang_code != 'PROG';
      END IF;
   END IF;
END Copy_Installation_Text__;


PROCEDURE Cleanup_Basic_Data_Imp__ (
   module_        IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
BEGIN
   Language_Sys_Imp_API.Cleanup_Basic_Data_(module_, language_code_);
END Cleanup_Basic_Data_Imp__;


@UncheckedAccess
FUNCTION Get_Prog_Text__ (
   module_ 	  IN VARCHAR2,
   lu_ 		  IN VARCHAR2,
   attribute_key_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ LANGUAGE_SYS_TAB.text%TYPE;
   path_ LANGUAGE_SYS_TAB.path%TYPE;

   CURSOR get_attr IS
      SELECT text
      FROM  LANGUAGE_SYS_TAB
      WHERE main_type = 'LU'
      AND   type = 'Basic Data'
      AND   path = path_
      AND   attribute = 'Text'
      AND   lang_code = 'PROG';
BEGIN
   path_ := lu_||'_'||module_||'.'||attribute_key_;
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Prog_Text__;


PROCEDURE Refresh_Imp_Table__
IS
   CURSOR get_info IS
   SELECT module,lu
   FROM basic_data_translation
   GROUP BY module, lu;
BEGIN
   DELETE FROM language_sys_imp_tab
   WHERE show_prog_language = 'TRUE'          -- default value unchanged
   AND use_translation_edited = 'FALSE'   ;   -- default value unchanged

   FOR rec_ IN get_info LOOP
      BEGIN
         INSERT INTO language_sys_imp_tab(
            module,
            lu,
            type,
            rowversion)
         VALUES(
            rec_.module,
            rec_.lu,
            'Basic Data',
            SYSDATE);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END Refresh_Imp_Table__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
-- Enum_Basic_Data_Module_Lu_
--   Returns a list of installed logical units in a specific module which
--   has basic data.
--   List is separated with field_separator_
@UncheckedAccess
PROCEDURE Enum_Basic_Data_Module_Lu_ (
   module_  IN  VARCHAR2,
   lu_list_ OUT VARCHAR2)
IS
   
   TYPE object_array IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
   field_separator_  CONSTANT VARCHAR2(1)    := Client_SYS.field_separator_;
   
   lu_array_  object_array;

   CURSOR units IS
      SELECT distinct(lu)
      FROM   basic_data_translation
      WHERE  type = 'Basic Data'
      AND    lang_code = 'PROG'
      AND    module = module_;

BEGIN
   OPEN  units;
   FETCH units BULK COLLECT INTO lu_array_;
   CLOSE units;
   IF lu_array_.count > 0 THEN
      FOR i IN Nvl(lu_array_.first, 0)..Nvl(lu_array_.last, -1) LOOP
         lu_list_ := lu_list_||lu_array_(i)||field_separator_;
      END LOOP;
   END IF;
END Enum_Basic_Data_Module_Lu_;



-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Cleanup (
   module_    IN VARCHAR2,
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   DELETE
      FROM  LANGUAGE_SYS_TAB
      WHERE module = module_
      AND   lang_code = lang_code_
      AND   main_type = 'LU'
      AND   type = 'Basic Data'
      AND   system_defined = 'TRUE'
      AND   nvl(text,'') = nvl(installation_text,'');
END Cleanup;


@UncheckedAccess
FUNCTION Get_Basic_Data_Translation (
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   lang_code_     IN VARCHAR2 DEFAULT NULL,
   only_chosen_lang_ IN VARCHAR2 DEFAULT 'FALSE' ) RETURN VARCHAR2
IS
   path_                VARCHAR2(500);
   new_attribute_key_   VARCHAR2(120);
BEGIN
   new_attribute_key_ := Replace (attribute_key_, '^','~');
   path_ := lu_||'_'||module_||'.'||new_attribute_key_;
   RETURN Get_Basic_Data_Translation___(module_,lu_,'LU', 'Basic Data', path_, 'Text', lang_code_, only_chosen_lang_);
END Get_Basic_Data_Translation;


PROCEDURE Insert_Basic_Data_Translation (
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   language_code_ IN VARCHAR2,
   text_          IN VARCHAR2,
   old_text_      IN VARCHAR2 DEFAULT NULL )
IS
   path_                VARCHAR2(500);
   lang_code_           VARCHAR2(5);

   CURSOR get_rows IS
      SELECT lang_code
        FROM LANGUAGE_SYS_TAB
       WHERE main_type  = 'LU'
         AND TYPE       = 'Basic Data'
         AND path       = path_
         AND attribute  = 'Text'
         AND (lang_code = lang_code_ OR lang_code = 'PROG');

   newrec_              LANGUAGE_SYS_TAB%ROWTYPE;
   tmp_attribute_key_   VARCHAR2(120);
   difference_          BOOLEAN := FALSE;
   lang_trans_exist_    BOOLEAN := FALSE;
   prog_exist_          BOOLEAN := FALSE;
BEGIN
   -- Handle the possibility that either of the translation might be NULL.
   IF text_ IS NULL THEN
      IF old_text_ IS NOT NULL THEN
         difference_ := TRUE;
      END IF;
   ELSIF old_text_ IS NULL THEN
      difference_ := TRUE;
   ELSIF old_text_ != text_ THEN
      difference_ := TRUE;
   END IF;
   -- Update if a difference is found
   IF difference_ THEN
      tmp_attribute_key_ := Replace (attribute_key_, '^','~');
      newrec_.main_type := 'LU';
      newrec_.type := 'Basic Data';
      newrec_.path := lu_||'_'||module_||'.'||tmp_attribute_key_;
      path_ := newrec_.path;
      newrec_.attribute := 'Text';

      Set_Language_Code___(lang_code_, language_code_);
      newrec_.lang_code := lang_code_;
      newrec_.module := module_;
      newrec_.text :=text_;
      newrec_.system_defined := 'FALSE';

      FOR rec_ IN get_rows LOOP
         IF rec_.lang_code = 'PROG' THEN
            prog_exist_ := TRUE;
         ELSE
            lang_trans_exist_ := TRUE;
         END IF;
      END LOOP;

      IF NOT prog_exist_ THEN
         Insert_Prog_Translation___(newrec_);
      END IF;
      -- If this call is to create the PROG line then no need to do it here
      -- We've already handled PROG insert logic above
      IF prog_exist_ OR newrec_.lang_code != 'PROG' THEN
         IF newrec_.lang_code = 'PROG' OR lang_trans_exist_ THEN
            Update_Basic_Data_Trans___(newrec_);
         ELSE
            Insert_Lang_Translation___(newrec_);
         END IF;
      END IF;
   END IF;
END Insert_Basic_Data_Translation;


PROCEDURE Insert_Prog_Translation (
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
   newrec_              LANGUAGE_SYS_TAB%ROWTYPE;
   tmp_attribute_key_   VARCHAR2(120);
BEGIN
   tmp_attribute_key_ := Replace (attribute_key_, '^','~');
   newrec_.main_type := 'LU';
   newrec_.type := 'Basic Data';
   newrec_.path := lu_||'_'||module_||'.'||tmp_attribute_key_;
   newrec_.attribute := 'Text';
   newrec_.lang_code := 'PROG';
   newrec_.module := module_;
   newrec_.text := text_;
   newrec_.installation_text := newrec_.text;
   newrec_.system_defined := 'TRUE';
   Insert_Prog_Translation___(newrec_);
END Insert_Prog_Translation;


PROCEDURE Remove_Basic_Data_Translation (
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2 )
IS
   path_                Language_Sys_TAB.path%TYPE;
   tmp_attribute_key_   VARCHAR2(120);
BEGIN
  tmp_attribute_key_ := Replace (attribute_key_, '^','~');
  path_ := lu_||'_'||module_||'.'||tmp_attribute_key_;

  DELETE FROM LANGUAGE_SYS_TAB
     WHERE main_type = 'LU'
     AND   type      = 'Basic Data'
     AND   path      = path_
     AND   attribute = 'Text';

  Language_Sys_Imp_API.Remove_From_Imp_Tab_(module_, lu_);

END Remove_Basic_Data_Translation;


PROCEDURE Set_System_Translation (
   module_        IN VARCHAR2,
   path_          IN VARCHAR2,
   lang_code_     IN VARCHAR2,
   text_          IN VARCHAR2 )
IS
   oldrec_        LANGUAGE_SYS_TAB%ROWTYPE;
   newrec_        LANGUAGE_SYS_TAB%ROWTYPE;
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(30);
   objversion_    VARCHAR2(2000);

BEGIN
   -- Remove trailing '~' from path if it exists
   IF (path_ LIKE '%~') THEN
      oldrec_:= Get_Object_By_Keys___( 'LU', 'Basic Data', SUBSTR(path_, 1, LENGTH(path_)-1), 'Text', lang_code_ );
   ELSE
      oldrec_:= Get_Object_By_Keys___( 'LU', 'Basic Data', path_, 'Text', lang_code_ );
   END IF;

   IF (oldrec_.type IS NULL) THEN
      newrec_.main_type := 'LU';
      newrec_.type := 'Basic Data';
      newrec_.path := path_;
      newrec_.attribute := 'Text';
      newrec_.lang_code := lang_code_;
      newrec_.module := module_;
      newrec_.text :=text_;
      newrec_.installation_text :=text_;
      newrec_.system_defined := 'TRUE';
      Insert_Lang_Translation___(newrec_);
   ELSE
      newrec_ := oldrec_;
      IF (oldrec_.text = oldrec_.installation_text ) THEN
         newrec_.text  := text_;
      END IF;
      newrec_.installation_text := text_;
      newrec_.system_defined := 'TRUE';
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Set_System_Translation;


-- Exist_Translation
--   The purpose of this method is to return true/false depending on if the
--   translation exist or not. Using standard Exist would generate error if it
--   does not exist. This to support the possibility that different languages
--   can have translations or not for different terms and in such case the
--   applications have the option to take the default value in there LU or not.
@UncheckedAccess
FUNCTION Exist_Translation (
   module_        IN VARCHAR2,
   lu_            IN VARCHAR2,
   attribute_key_ IN VARCHAR2,
   lang_code_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   path_                VARCHAR2(500);
   new_attribute_key_   VARCHAR2(120);
BEGIN
   new_attribute_key_ := Replace (attribute_key_, '^','~');
   path_ := lu_||'_'||module_||'.'||new_attribute_key_;
   RETURN Check_Exist___('LU', 'Basic Data', path_, 'Text', lang_code_);
END Exist_Translation;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   type_ IN VARCHAR2,
   path_ IN VARCHAR2,
   attribute_ IN VARCHAR2,
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___('LU', type_, path_, attribute_, lang_code_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
END Exist;

-- Is_Basic_Data_Module_Lu_
--   Check if an Lu has basic data translation
@UncheckedAccess
FUNCTION Is_Basic_Data_Module_Lu_ (
   module_  IN  VARCHAR2,
   lu_      IN VARCHAR2) RETURN BOOLEAN
IS 
   dummy_ VARCHAR2(100);
BEGIN
      SELECT distinct(lu)
      INTO  dummy_
      FROM   basic_data_translation
      WHERE  type = 'Basic Data'
      AND    lang_code = 'PROG'
      AND    module = module_
      AND    lu = lu_;
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
END Is_Basic_Data_Module_Lu_;
