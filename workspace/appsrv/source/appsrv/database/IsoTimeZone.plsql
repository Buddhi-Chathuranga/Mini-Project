-----------------------------------------------------------------------------
--
--  Logical unit: IsoTimeZone
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  131127  jagrno  Hooks: Refactored and split code. Re-introduced methods New__
--                  and Remove__. Added basic data translation for attribute DESCRIPTION
--                  since this was only partially handled.
--  130618  heralk  Scalability Changes - removed global variables.
--  --------------------------- APPS 9 --------------------------------------
--  040308  NiSilk Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_       CONSTANT VARCHAR2(1)        := Client_SYS.field_separator_;
no_description_  CONSTANT VARCHAR2(50)       := 'NO DESCRIPTION';


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ISO_TIME_ZONE_TAB%ROWTYPE,
   newrec_     IN OUT ISO_TIME_ZONE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
   user_language_code_    VARCHAR2(5);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   user_language_code_ := Fnd_Session_Api.Get_Language;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoTimeZone',
      newrec_.time_zone_code,
      user_language_code_, newrec_.description, oldrec_.description);
END Update___;


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
   Error_SYS.Record_General(lu_name_, 'NONEW: Method New__ is not available for LU IsoTimeZone.');
   super(info_, objid_, objversion_, attr_, action_);
END New__;


@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOREMOVE: Method Remove__ is not available for LU IsoTimeZone.');
   super(info_, objid_, objversion_, action_);
END Remove__;


PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN ISO_TIME_ZONE_TAB%ROWTYPE )
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM ISO_TIME_ZONE_TAB
      WHERE time_zone_code = newrec_.time_zone_code;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      CLOSE Exist;
      INSERT
         INTO ISO_TIME_ZONE_TAB(
            time_zone_code,
            description,
            offset_factor,
            used_in_appl,
            rowversion)
         VALUES(
            newrec_.time_zone_code,
            newrec_.description,
            newrec_.offset_factor,
            newrec_.used_in_appl,
            newrec_.rowversion);
   ELSE
      CLOSE Exist;
      UPDATE ISO_TIME_ZONE_TAB
         SET description = newrec_.description,
             used_in_appl = newrec_.used_in_appl,
             offset_factor = newrec_.offset_factor,
             rowversion = newrec_.rowversion

         WHERE time_zone_code = newrec_.time_zone_code;
   END IF;
   Basic_Data_Translation_API.Insert_Prog_Translation( 'APPSRV',
                                                       lu_name_,
                                                       newrec_.time_zone_code||'^'||'DESCRIPTION',
                                                       newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Local_Date_Time (
   local_time_zone_code_  IN VARCHAR2,
   server_time_zone_code_ IN VARCHAR2,
   server_date_time_      IN DATE ) RETURN DATE
IS
   local_offset_  NUMBER;
   server_offset_ NUMBER;
BEGIN
   local_offset_  := nvl(Get_Offset_Factor(local_time_zone_code_),0);
   server_offset_ := nvl(Get_Offset_Factor(server_time_zone_code_),0);
   RETURN server_date_time_ - server_offset_/24 + local_offset_/24 ;
END Get_Local_Date_Time;


@UncheckedAccess
FUNCTION Get_Server_Date_Time (
   local_time_zone_code_  IN VARCHAR2,
   server_time_zone_code_ IN VARCHAR2,
   local_date_time_       IN DATE ) RETURN DATE
IS
   local_offset_  NUMBER;
   server_offset_ NUMBER;
BEGIN
   local_offset_  := nvl(Get_Offset_Factor(local_time_zone_code_),0);
   server_offset_ := nvl(Get_Offset_Factor(server_time_zone_code_),0);
   RETURN local_date_time_ - local_offset_/24 + server_offset_/24 ;
END Get_Server_Date_Time;


PROCEDURE Activate_Code (
   time_zone_code_ IN VARCHAR2 )
IS
BEGIN
   UPDATE ISO_TIME_ZONE_TAB
      SET   used_in_appl = 'TRUE'
      WHERE time_zone_code = time_zone_code_
      AND   NVL(used_in_appl, 'FALSE') <> 'TRUE';
END Activate_Code;


@UncheckedAccess
FUNCTION Check_Activate_Code (
   time_zone_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR check_active IS
      SELECT 1
      FROM   ISO_TIME_ZONE_TAB
      WHERE  time_zone_code = time_zone_code_
      AND    used_in_appl = 'TRUE';
BEGIN
   OPEN check_active;
   FETCH check_active INTO dummy_;
   IF (check_active%FOUND) THEN
      CLOSE check_active;
      RETURN(TRUE);
   END IF;
   CLOSE check_active;
   RETURN(FALSE);
END Check_Activate_Code;


@UncheckedAccess
FUNCTION Get_Description (
   time_zone_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_             VARCHAR2(2000);
   curr_user_lang_    VARCHAR2(10);
   CURSOR get_value IS
      SELECT description
      FROM   ISO_TIME_ZONE_TAB
      WHERE  time_zone_code = time_zone_code_
      AND    used_in_appl = 'TRUE';
BEGIN
   curr_user_lang_ := Fnd_Session_Api.Get_Language;
   value_ := Basic_Data_Translation_API.Get_Basic_Data_Translation('APPSRV', 'IsoTimeZone', time_zone_code_||'^'||'DESCRIPTION', curr_user_lang_);
   IF (value_ IS NOT NULL) THEN
      NULL;
   ELSE
      OPEN get_value;
      FETCH get_value INTO value_;
      IF (get_value%NOTFOUND) THEN
         CLOSE get_value;
         value_ := NULL;
      ELSE
         CLOSE get_value;
      END IF;
   END IF;
   RETURN value_;
END Get_Description;


@UncheckedAccess
PROCEDURE Enumerate (
   desc_list_ OUT VARCHAR2 )
IS
   enum_len_     INTEGER := NULL;
   descriptions_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT SUBSTR(NVL(description, no_description_), 1, enum_len_) description
      FROM ISO_TIME_ZONE
      ORDER BY time_zone_code;
BEGIN
   IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
      enum_len_ := 50;
   ELSE
      enum_len_ := 20;
   END IF;
   FOR v IN get_value LOOP
      descriptions_ := descriptions_ || v.description || separator_;
   END LOOP;
   desc_list_ := descriptions_;
END Enumerate;

@UncheckedAccess
PROCEDURE Enumerate_Db (
   db_list_ OUT VARCHAR2)
IS
   enum_len_     INTEGER := NULL;
   descriptions_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT SUBSTR(NVL(description, no_description_), 1, enum_len_) description
      FROM ISO_TIME_ZONE
      ORDER BY time_zone_code;
BEGIN
   IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
      enum_len_ := 50;
   ELSE
      enum_len_ := 20;
   END IF;
   FOR v IN get_value LOOP
      descriptions_ := descriptions_ || v.description || separator_;
   END LOOP;
   db_list_ := descriptions_;
END Enumerate_Db;

@UncheckedAccess
PROCEDURE Exist_Db (
   time_zone_code_ IN VARCHAR2 )
IS
BEGIN
   Exist(time_zone_code_);
END Exist_Db;
