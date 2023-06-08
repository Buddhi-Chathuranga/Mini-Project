-----------------------------------------------------------------------------
--
--  Logical unit: LanguageCode
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  961105  DAJO    Updated to new server templates
--  020705  ROOD    Updated to new server templates (ToDo#4117).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  040218  ROOD    Improved error message in Exist (Bug#39376).
--  040408  HAAR    Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  041119  HAAR    Changed language handling (F1PR413E).
--  050601  HAAR    Added installed, nls_date_format and nls_time_format (F1PR413).
--  060517  HAAR    Modified so it is possible to choose if NLS_data is validated (Bug#57096).
--  060619  HAAR    Added support for Persian calendar (Bug#58601).
--                  Added column nls_calendar.
--  060928  STDA    Translation Simplification (BUG#58618).
--  070329  UtGulk  Added method Enum_Lang_Code_Rfc3066 and view1.(F1PR458 Improved locale handling for printouts).
--  071116  UTGULK  Added attributes short_date,medium_date,Long_date and full_date. (BUG#68989)
--  141125  TAORSE  Added Enum_Lang_Code_Rfc3066_Db
--  141217  TAORSE  Added Enumerate_Db
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
global_context_       CONSTANT VARCHAR2(30) := 'LANGUAGECODE_CTX';


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Nls_Settings___ (
   lang_code_ IN VARCHAR2 )
IS
   invalid_nls EXCEPTION;
   PRAGMA      EXCEPTION_INIT(invalid_nls, -12705);
   stmt_       VARCHAR2(1000);
   lang_rec_   Language_Code_API.Public_rec;
BEGIN
   stmt_ := 'ALTER SESSION SET ';
   -- Do not set language if already set, if NULL then nothing
   lang_rec_  := Language_Code_API.Get(lang_code_);
   stmt_     := stmt_       ||' NLS_LANGUAGE  = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_language)||''''||
                              ' NLS_TERRITORY = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_territory)||'''';
   IF lang_rec_.nls_date_format IS NOT NULL THEN
      stmt_  := stmt_       ||' NLS_DATE_FORMAT = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_date_format)||'''';
   END IF;
   IF lang_rec_.nls_time_format IS NOT NULL THEN
      stmt_  := stmt_       ||' NLS_TIME_FORMAT = '''||Assert_SYS.Encode_Single_Quote_String(lang_rec_.nls_time_format)||'''';
   END IF;
   @ApproveDynamicStatement(2006-05-15,haarse)
   EXECUTE IMMEDIATE stmt_;
EXCEPTION
   WHEN invalid_nls THEN
      Error_SYS.Appl_General(lu_name_,
                             'INVALID_NLS: Language ":P1" has incorrect values in NLS parameters. Language [:P2] and Territory [:P3].',
                             lang_code_, lang_rec_.nls_language, lang_rec_.nls_territory);
END Validate_Nls_Settings___;


PROCEDURE Validate_Nls___ (
   lang_code_ IN VARCHAR2 )
IS
   user_lang_code_ VARCHAR2(5) := Fnd_Session_API.Get_Language;
BEGIN
   -- Try to set language, this sets NLS_parameters
   Validate_Nls_Settings___(lang_code_);
   -- Set language to users initial language
   Validate_Nls_Settings___(user_lang_code_);
EXCEPTION
   WHEN OTHERS THEN
      -- Set language to users initial language
      Validate_Nls_Settings___(user_lang_code_);
      RAISE;
END Validate_Nls___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('STATUS_DB', 'P', attr_);
   Client_SYS.Add_To_Attr('STATUS', Language_Code_Status_API.Decode('P'), attr_);
   Client_SYS.Add_To_Attr('INSTALLED_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('INSTALLED', FND_Boolean_API.Decode('FALSE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT LANGUAGE_CODE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.dictionary_update := sysdate;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   super(objid_, objversion_, newrec_, attr_);
   IF (NVL(Client_SYS.Get_Item_Value('VALIDATE_NLS', attr_), 'TRUE') = 'TRUE') THEN
      Validate_Nls___(newrec_.lang_code);
   END IF;
   Dbms_Session.Set_Context(global_context_, newrec_.lang_code_rfc3066||'_LANG_CODE', newrec_.lang_code);
   Dbms_Session.Set_Context(global_context_, newrec_.lang_code_rfc3066||'_LANG_INSTALLED', newrec_.installed);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     LANGUAGE_CODE_TAB%ROWTYPE,
   newrec_     IN OUT LANGUAGE_CODE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (NVL(Client_SYS.Get_Item_Value('VALIDATE_NLS', attr_), 'TRUE') = 'TRUE') THEN
      Validate_Nls___(newrec_.lang_code);
   END IF;
   IF (nvl(oldrec_.installed,'TRUE') = 'TRUE' AND newrec_.installed = 'FALSE') THEN
      DELETE
         FROM LANGUAGE_SYS_TAB
         WHERE lang_code=newrec_.lang_code
         AND TYPE NOT IN ('Basic Data');
   END IF;
   Dbms_Session.Set_Context(global_context_, newrec_.lang_code_rfc3066||'_LANG_CODE', newrec_.lang_code);
   Dbms_Session.Set_Context(global_context_, newrec_.lang_code_rfc3066||'_LANG_INSTALLED', newrec_.installed);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN language_code_tab%ROWTYPE )
IS
BEGIN
   IF (nvl(remrec_.installed,'TRUE') = 'TRUE') THEN
      DELETE
        FROM LANGUAGE_SYS_TAB
       WHERE lang_code = remrec_.lang_code
         AND TYPE NOT IN ('Basic Data');
   END IF;
   Dbms_Session.Set_Context(global_context_, remrec_.lang_code_rfc3066||'_LANG_CODE', '');
   Dbms_Session.Set_Context(global_context_, remrec_.lang_code_rfc3066||'_LANG_INSTALLED', '');
   super(objid_, remrec_);
END Delete___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN LANGUAGE_CODE_TAB%ROWTYPE )
IS
BEGIN
   IF (remrec_.lang_code='en') THEN
      Error_SYS.Appl_General(lu_name_, 'INSTLANGRD: You may not delete the English translations');
   END IF;
   super(remrec_);
   IF (nvl(remrec_.installed,'TRUE') = 'TRUE') THEN
      Client_SYS.Add_Warning(lu_name_, 'INSTLANGUD: By removing this record, you will remove runtime translations for  ":P1". This procedure will take a while.', remrec_.lang_code);
   END IF;
END Check_Delete___;



@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     language_code_tab%ROWTYPE,
   newrec_ IN OUT language_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (nvl(newrec_.installed,'TRUE') = 'TRUE' AND Fnd_Boolean_API.Encode(newrec_.installed) = 'FALSE') THEN
      IF (newrec_.lang_code = 'en') THEN
         Error_SYS.Appl_General(lu_name_, 'INSTLANGR: You may not unselect the English translations');
      ELSE
          Client_SYS.Add_Warning(lu_name_, 'INSTLANGU: Unselecting installed translation will remove runtime translations for  ":P1". This procedure will take a while.', newrec_.lang_code);
      END IF;
    END IF;  
    IF (nvl(newrec_.installed,'TRUE') = 'TRUE' AND newrec_.installed = 'FALSE') THEN
       IF (newrec_.lang_code = 'en') THEN
          Error_SYS.Appl_General(lu_name_, 'INSTLANGR: You may not unselect the English translations');
       ELSE
          Client_SYS.Add_Warning(lu_name_, 'INSTLANGU: Unselecting installed translation will remove runtime translations for  ":P1". This procedure will take a while.', newrec_.lang_code);
       END IF;
     END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
PROCEDURE Get_Description__ (
   description_ OUT VARCHAR2,
   lang_code_   IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description ( lang_code_ );
END Get_Description__;


@UncheckedAccess
PROCEDURE Get_Dictionary_Info__ (
   dictionary_update_ OUT DATE,
   description_      OUT VARCHAR2,
   lang_code_        IN  VARCHAR2 )
IS
BEGIN
   dictionary_update_ := Get_Dictionary_Update ( lang_code_);
   description_ := Get_Description ( lang_code_ );
END Get_Dictionary_Info__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Get_Nls_Date_Format (
   lang_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ LANGUAGE_CODE_TAB.nls_date_format%TYPE;
   CURSOR get_attr IS
      SELECT nvl(l.nls_date_format, n.value)
      FROM LANGUAGE_CODE_TAB l, nls_session_parameters n
      WHERE l.lang_code = lang_code_
      AND   n.parameter = 'NLS_DATE_FORMAT';
BEGIN
   temp_ := super(lang_code_);
   IF temp_ IS NULL THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Nls_Date_Format;


@Override
@UncheckedAccess
FUNCTION Get_Nls_Time_Format (
   lang_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ LANGUAGE_CODE_TAB.nls_time_format%TYPE;
   CURSOR get_attr IS
      SELECT nvl(l.nls_time_format, n.value)
      FROM LANGUAGE_CODE_TAB l, nls_session_parameters n
      WHERE l.lang_code = lang_code_
      AND   n.parameter = 'NLS_TIME_FORMAT';
BEGIN
   temp_ := super(lang_code_);
   IF temp_ IS NULL THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Nls_Time_Format;


@UncheckedAccess
PROCEDURE Enumerate (
   lang_code_list_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR langs IS
      SELECT lang_code
      FROM   language_code_tab
      WHERE  status = 'A';
BEGIN
   FOR lang IN langs LOOP
      temp_ := temp_ || lang.lang_code || Client_SYS.field_separator_;
   END LOOP;
   lang_code_list_ := temp_;
END Enumerate;

@UncheckedAccess
PROCEDURE Enumerate_Db (
   lang_code_list_ OUT VARCHAR2)
IS
   temp_ VARCHAR2(32000);
   CURSOR langs IS
      SELECT lang_code
      FROM language_code_tab
      WHERE status = 'A';
BEGIN
   FOR lang IN langs LOOP
      temp_ := temp_ || lang.lang_code || Client_SYS.field_separator_;
   END LOOP;
   lang_code_list_ := temp_;
END Enumerate_Db;

@UncheckedAccess
FUNCTION Get_Lang_Code_From_Rfc3066 (
   lang_code_rfc3066_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ LANGUAGE_CODE_TAB.lang_code%TYPE;
BEGIN
   temp_ := Sys_Context(global_context_, lang_code_rfc3066_||'_LANG_CODE');
   IF temp_ IS NULL THEN
      SELECT lang_code
      INTO temp_
      FROM LANGUAGE_CODE_TAB
      WHERE lang_code_rfc3066 = lang_code_rfc3066_;
      
      Dbms_Session.Set_Context(global_context_, lang_code_rfc3066_||'_LANG_CODE', temp_);
   END IF;
   
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Lang_Code_From_Rfc3066;

@UncheckedAccess
FUNCTION Get_Installed_Db_From_Rfs3066(
   lang_code_rfc3066_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   installed_ LANGUAGE_CODE_TAB.installed%TYPE;
BEGIN
   installed_ := Sys_Context(global_context_, lang_code_rfc3066_||'_LANG_INSTALLED');
   
   IF installed_  IS NULL THEN
      SELECT installed
      INTO installed_
      FROM LANGUAGE_CODE_TAB
      WHERE lang_code_rfc3066 = lang_code_rfc3066_;
      
      Dbms_Session.Set_Context(global_context_, lang_code_rfc3066_||'_LANG_INSTALLED', installed_);
   END IF;
   
   RETURN installed_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Installed_Db_From_Rfs3066;

@UncheckedAccess
FUNCTION Is_Prog (
   lang_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
  RETURN (upper(lang_code_) = 'PROG');
END Is_Prog;


@UncheckedAccess
PROCEDURE Enum_Lang_Code_Rfc3066 (
   rfc_code_list_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR get_rfc3066 IS
      SELECT lang_code_rfc3066
      FROM   language_code_tab
      WHERE  status = 'A';
BEGIN
   FOR rfc_ IN get_rfc3066 LOOP
      temp_ := temp_ || rfc_.lang_code_rfc3066 || Client_SYS.field_separator_;
   END LOOP;
   rfc_code_list_ := temp_;
END Enum_Lang_Code_Rfc3066;

PROCEDURE Enum_Lang_Code_Rfc3066_Db (
   db_rfc_code_list_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR get_rfc3066 IS
      SELECT lang_code_rfc3066
      FROM   language_code_tab
      WHERE  status = 'A';
BEGIN
   FOR rfc_ IN get_rfc3066 LOOP
      temp_ := temp_ || rfc_.lang_code_rfc3066 || Client_SYS.field_separator_;
   END LOOP;
   db_rfc_code_list_ := temp_;
END Enum_Lang_Code_Rfc3066_Db;

@UncheckedAccess
PROCEDURE Active_Language_List (
   active_language_list_ OUT VARCHAR2)
IS
   temp_ VARCHAR2(32000);
   CURSOR get_active_list IS
   SELECT lang_code, description 
   FROM   language_code_tab
   WHERE  status = 'A'
   ORDER BY lang_code;
   
   lang_code_       VARCHAR2(100);
   description_     VARCHAR2(100);
BEGIN
      OPEN get_active_list;
      LOOP
         FETCH get_active_list INTO lang_code_, description_;
         EXIT WHEN get_active_list%NOTFOUND;         
         temp_ := temp_||lang_code_||Client_SYS.field_separator_||description_||Client_SYS.record_separator_;
      END LOOP;
      CLOSE get_active_list;
      active_language_list_ := temp_;
END Active_Language_List;

@UncheckedAccess
FUNCTION Get_Objversion_By_Key(
   lang_code_   IN VARCHAR2) RETURN VARCHAR2
IS
   objid_      VARCHAR2(10);
   objversion_ VARCHAR2(20);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, lang_code_);
   RETURN objversion_;
END Get_Objversion_By_Key;