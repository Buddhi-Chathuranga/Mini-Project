-----------------------------------------------------------------------------
--
--  Logical unit: IsoLanguage
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170518  MDAHSE  Add micro cache to Encode, since that method is used much in IFS Applications.
--  170512  MDAHSE  Removed check for language_code <> 'PROG' since it is meaningless (LanguageCode is two characters long...) Also some code cleanup.
--  141128  TAORSE  Added Enumerate_Db
--  131129  jagrno  Added method Check_Used_In_Appl.
--  131127  jagrno  Hooks: Refactored and split code. Re-introduced method New__.
--                  Removed global variable no_description_. Removed obsolete template
--                  method Get_Record___. Added USED_IN_APPL as attribute since
--                  this is also in the table and used in the business logic.
--  130910  chanlk  Model errors corrected.
--  130618  heralk   Scalability Changes - removed global variables.
--  --------------------------- APPS 9 --------------------------------------
--  110803  INMALK   Bug 98268, Added a cursor to Encode method to enable querying from the table when "use translation" is not checked.
--  100422  Ajpelk   Merge rose method documentation
--  --------------------------Eagle------------------------------------------
--  060118  UTGULK   Bug 55565 Modified Enumerate to order by description.
--  040220  DHSELK   Removed substrb and changed to substr where needed for Unicode Support
--  030213  pranlk   Call 94113 Error when saving modified description.
--  030213           modified  update___
--  030206  pranlk   Call 93790 Get_Description modified to get the language code
--  030206           if the description is passed in.
--  030206  pranlk   Call 93731 Encode___ and Exist() modified
--  030206           to use uppercase in comparisons.
--  030205  pranlk   Call 93723 Check_Unique_Description___ modified
--  030205           converts to uppercase for comparison.
--  030116  pranlk   Insert_Lu_Data_Rec__ method was added to insert data
--  030116           into the LU table according to the new Basic Data Translation
--  030116           guidelines. This method is used in IsoLanguage.ins
--  030116           almost all methods were changed to follow the same guidelines.--
--  990422  JoEd     Bug# 9905: Added same where clause as the main view's in some methods.
--  990422           Changed back to using the view instead of the table in other methods
--  990422           due to too many values was returned.
--  990420  JoEd     Added method Exist_Db.
--  990416  JoEd     Bug# 9905: Removed function calls from cursors to improve performance.
--  981021  JoEd     Removed << and >> in Trace calls for non 8-bit character set error.
--  980327  JaPa     USED_IN_APPL attribute changed to not null.
--  971121  JaPa     Distinction of description within first 19 characters.
--  971121           Possibility to use descriptions of length 50 in Enumerate()
--  971121           by using object property LONG_ENUM.
--  971028  JaPa     Fixed bug 97-0002. Not possible to use client values
--  971028           longer then 20 characters.
--  970930  JaPa     Better check for client values. Encode can return NULL
--  970408  JaPa     New procedure Set_Description__()
--  961213  JaPa     New public procedure Activate_Code()
--  960828  JaPa     Changed to fit functionality in FND ver 1.2
--  960508  JaPa     Created.
--  010612  Larelk   bug 22173, Remove last parameter from General_SYS.Init_Method in
--  010612           method Set_Description__,Remove_Description__,Activate_Cod
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_       CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;

micro_cache_id_                    VARCHAR2(4000);

micro_cache_value_                 iso_language_tab.description%TYPE;

micro_cache_time_                  NUMBER := 0;

micro_cache_user_                  VARCHAR2(30);

max_cached_element_life_           CONSTANT NUMBER := 100;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Encode___ (
   description_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_   VARCHAR2(10);
   desc_    VARCHAR2(20);
   CURSOR get_value IS
      SELECT language_code
      FROM   iso_language
      WHERE  UPPER (description) LIKE UPPER (desc_);
   CURSOR get_value_no_language IS
      SELECT language_code
      FROM   iso_language_tab
      WHERE  UPPER(description) LIKE UPPER (desc_);
BEGIN

   IF (NVL(LENGTH(description_), 0) >= 19) THEN
      desc_ := SUBSTR(description_, 1, 19) || '%';
   ELSE
      desc_ := description_;
   END IF;

   IF Language_Sys_Imp_API.Get_Use_Translation_Db('APPSRV', 'IsoLanguage')='FALSE' THEN -- Don't use basic language
      OPEN get_value_no_language;
      FETCH get_value_no_language INTO value_;
      IF (get_value_no_language%NOTFOUND) THEN
         value_ := NULL;
      END IF;
      CLOSE get_value_no_language;
   ELSE
      OPEN get_value;
      FETCH get_value INTO value_;
      IF (get_value%NOTFOUND) THEN
         value_ := NULL;
      END IF;
      CLOSE get_value;
   END IF;
   RETURN value_;
END Encode___;

PROCEDURE Invalidate_Cache___
IS
BEGIN
   micro_cache_id_ := NULL;
   micro_cache_value_ := NULL;
   micro_cache_time_  := 0;
END Invalidate_Cache___;


PROCEDURE Update_Cache___ (
   description_ IN VARCHAR2 )
IS
   req_id_     VARCHAR2(1000) := description_;
   time_       NUMBER;
   expired_    BOOLEAN;
BEGIN
   time_    := Database_SYS.Get_Time_Offset;
   expired_ := ((time_ - micro_cache_time_) > max_cached_element_life_);
   IF (expired_ OR (micro_cache_user_ IS NULL) OR (micro_cache_user_ != Fnd_Session_API.Get_Fnd_User)) THEN
      Invalidate_Cache___;
      micro_cache_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   IF (expired_ OR (micro_cache_id_ IS NULL) OR (micro_cache_id_ != req_id_)) THEN
      micro_cache_value_ := Encode___ (description_);
      micro_cache_id_ := req_id_;
      micro_cache_time_ := time_;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
     micro_cache_value_ := NULL;
     micro_cache_id_    := NULL;
     micro_cache_time_  := time_;
   WHEN too_many_rows THEN
     Raise_Too_Many_Rows___(description_, 'Update_Cache___');
END Update_Cache___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ISO_LANGUAGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.used_in_appl := NVL(newrec_.used_in_appl, 'FALSE');
   super(objid_, objversion_, newrec_, attr_);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoLanguage', newrec_.language_code, NULL, newrec_.description);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     iso_language_tab%ROWTYPE,
   newrec_     IN OUT iso_language_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   curr_user_lang_ VARCHAR2(10);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   curr_user_lang_ := Fnd_Session_API.Get_Language;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoLanguage',
      newrec_.language_code,
      curr_user_lang_, newrec_.description, oldrec_.description);
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     iso_language_tab%ROWTYPE,
   newrec_ IN OUT iso_language_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   lang_  VARCHAR2(10);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Ensure unique descriptions
   IF (indrec_.description) THEN
      lang_ := Language_SYS.Get_Language;
      IF (lang_ = 'PROG') THEN
         lang_ := 'en';
      ELSE
         Exist(lang_);
      END IF;
      Check_Unique_Description___(newrec_.language_code, newrec_.description);
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     iso_language_tab%ROWTYPE,
   newrec_ IN OUT iso_language_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.language_code = 'en'
   AND newrec_.used_in_appl = 'FALSE' THEN
      newrec_.used_in_appl := 'TRUE';
      Client_SYS.Add_To_Attr('USED_IN_APPL', newrec_.used_in_appl, attr_);
      indrec_.used_in_appl := TRUE;
      Client_SYS.Add_Info(lu_name_, 'ENALWAYSTRUE: English (en) must always be used in application');
   END IF;
END Check_Common___;

-- Check_Unique_Description___
--   Checks for uniqueness in the description only the first 19 characters
--   are matched for comparison.
PROCEDURE Check_Unique_Description___ (
   language_code_ IN VARCHAR2,
   description_   IN VARCHAR2 )
IS
   cnt_  NUMBER;
   desc_  VARCHAR2(20);
   CURSOR get_count IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM iso_language_def
      WHERE upper(description) LIKE upper(desc_)
      AND language_code <> language_code_;
BEGIN
   IF (LENGTH(description_) >= 19) THEN
      desc_ := substr(description_, 1, 19) || '%';
   ELSE
      desc_ := description_;
   END IF;

   OPEN get_count;
   FETCH get_count INTO cnt_;
   CLOSE get_count;

   IF (cnt_ > 0) THEN
      Error_SYS.Record_General(lu_name_,'ISOLANGUNIQDESC: Iso Language :P1 already exists.', description_);
   END IF;
END Check_Unique_Description___;


FUNCTION Check_Db_Exist___ (
   language_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   exist_ BOOLEAN := FALSE;
   dummy_ NUMBER;

   CURSOR db_exist IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM   iso_language_tab
      WHERE  language_code = language_code_;
BEGIN
   OPEN db_exist;
   FETCH db_exist INTO dummy_;
   exist_ := (db_exist%FOUND);
   CLOSE db_exist;
   RETURN exist_;
END Check_Db_Exist___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NONEW: Method New__ is not available for LU IsoLanguage.');
   super(info_, objid_, objversion_, attr_, action_);
END New__;


PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_        IN iso_language_tab%ROWTYPE)
IS
BEGIN
   IF (NOT Check_Db_Exist___ (newrec_.language_code)) THEN

      INSERT INTO iso_language_tab
        (language_code,
         description,
         used_in_appl)
        VALUES
        (newrec_.language_code,
         newrec_.description,
         'FALSE');

      Basic_Data_Translation_API.Insert_Prog_Translation( 'APPSRV', 'IsoLanguage',newrec_.language_code, newrec_.description);

   ELSE
      Basic_Data_Translation_API.Insert_Prog_Translation( 'APPSRV', 'IsoLanguage',newrec_.language_code, newrec_.description);

      UPDATE iso_language_tab
         SET description = newrec_.description
         WHERE language_code = newrec_.language_code;
   END IF;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Overtaken because we need to check against a subset of ISO languages
-- Only languages used by the application should be considered.
-- Note: Checks against the description, not the language code itself.
@Overtake Base
@UncheckedAccess
PROCEDURE Exist (
   lang_code_desc_ IN VARCHAR2 )
IS
   dummy_ NUMBER;
   desc_    VARCHAR2(20);

   CURSOR client_exist IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM   iso_language
      WHERE  UPPER(description) LIKE UPPER(desc_);
BEGIN
   IF (LENGTH(lang_code_desc_) >= 19) THEN
      desc_ := SUBSTR(lang_code_desc_, 1, 19) || '%';
   ELSE
      desc_ := lang_code_desc_;
   END IF;

   IF (NOT Check_Db_Exist___(lang_code_desc_)) THEN
      OPEN client_exist;
      FETCH client_exist INTO dummy_;
      IF (client_exist%NOTFOUND) THEN
         CLOSE client_exist;
         Error_SYS.Record_Not_Exist(lu_name_, p1_ => lang_code_desc_);
      ELSE
         CLOSE client_exist;
      END IF;
   END IF;
END Exist;

@UncheckedAccess
PROCEDURE Enumerate (
   desc_list_ OUT VARCHAR2)
IS
   enum_len_     INTEGER  := NULL;
   descriptions_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT description
      FROM iso_language
      ORDER BY description;

BEGIN
      IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
         enum_len_ := 50;
      ELSE
         enum_len_ := 20;
      END IF;

   FOR rec_ IN get_value LOOP
      descriptions_ := descriptions_ || SUBSTR(rec_.description,1,enum_len_) || separator_;
   END LOOP;
   desc_list_ := descriptions_;
END Enumerate;

@UncheckedAccess
PROCEDURE Enumerate_Db (
   language_code_list_ OUT VARCHAR2)
IS
   enum_len_     INTEGER  := NULL;
   language_codes_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT language_code
      FROM iso_language
      ORDER BY description;
BEGIN
   IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
      enum_len_ := 50;
   ELSE
      enum_len_ := 20;
   END IF;

   FOR rec_ IN get_value LOOP
      language_codes_ := language_codes_ || SUBSTR(rec_.language_code, 1, enum_len_) || separator_;
   END LOOP;

   language_code_list_ := language_codes_;
END Enumerate_Db;

@UncheckedAccess
FUNCTION Get_Description (
   lang_code_     IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   desc_ VARCHAR2(2000);
   lang_ VARCHAR2(2);
   CURSOR get_desc IS
      SELECT description
      FROM   iso_language_tab
      WHERE  language_code = lang_code_
      AND    used_in_appl = 'TRUE';
BEGIN

   IF NVL(LENGTH(language_code_),0) = 2 THEN
      lang_ := language_code_;
   ELSE
      lang_ := Iso_Language_API.Encode(language_code_);
   END IF;

   desc_ := Basic_Data_Translation_API.Get_Basic_Data_Translation('APPSRV', 'IsoLanguage', lang_code_, lang_ );

   IF desc_ IS NOT NULL THEN
      RETURN desc_;
   ELSE
      OPEN get_desc;
      FETCH get_desc INTO desc_;
      IF (get_desc%NOTFOUND) THEN
         CLOSE get_desc;
         RETURN NULL;
      ELSE
         CLOSE get_desc;
         RETURN desc_;
      END IF;
   END IF;
END Get_Description;


@UncheckedAccess
FUNCTION Encode (
   description_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Update_Cache___ (UPPER(description_));
   RETURN micro_cache_value_;
END Encode;


@UncheckedAccess
FUNCTION Decode (
   lang_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_   VARCHAR2(2000);
   CURSOR get_value IS
      SELECT description
      FROM   iso_language_tab
      WHERE  language_code = lang_code_
      AND    used_in_appl = 'TRUE';
BEGIN
   value_ := Basic_Data_Translation_API.Get_Basic_Data_Translation('APPSRV', 'IsoLanguage', lang_code_ );
   IF (value_ IS NULL) THEN
      OPEN get_value;
      FETCH get_value INTO value_;
      IF (get_value%NOTFOUND) THEN
         CLOSE get_value;
         RETURN NULL;
      ELSE
         CLOSE get_value;
         RETURN value_;
      END IF;
   ELSE
      return value_;
   END IF;
END Decode;


PROCEDURE Activate_Code (
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   UPDATE iso_language_tab
      SET used_in_appl = 'TRUE'
      WHERE language_code = lang_code_
      AND NVL(used_in_appl, 'FALSE') <> 'TRUE';
END Activate_Code;


@UncheckedAccess
PROCEDURE Exist_Db (
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   Exist(lang_code_);
END Exist_Db;

@UncheckedAccess
PROCEDURE Exist_Db_All (
   lang_code_  IN VARCHAR2)
IS
BEGIN
   --This method does not check if the Language code is Activated. Only checks if it Exists in the DB.
   IF (NOT Check_Exist___(lang_code_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_, p1_ => lang_code_);
   END IF;
END Exist_Db_All;


@UncheckedAccess
FUNCTION Check_Used_In_Appl (
   language_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  iso_language_tab
      WHERE language_code = language_code_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
END Check_Used_In_Appl;
