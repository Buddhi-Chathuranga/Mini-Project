-----------------------------------------------------------------------------
--
--  Logical unit: IsoCountry
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200831  SWiclk  LMM2020R1-1000, Added Get_Country_Code_By_Code3() in order to get the Alpha-2 code from Alpha-3 code.
--  180108  MAJOSE  STRMF-16828, MRP Performance got really bad because of improved tax handling when generating Purchase Requsition Lines.
--  180108          During the generation of Pur Req Lines (within the tax handling) there are lot of calls to Iso_Country_API.Encode.
--  180108          This function has now been rewritten when it comes to the case when Basic Data Translation is used.
--  150216  LiAmlk  PRSA-7498, merged LCS patch 120932.
--  141128  TAORSE  Added Enumerate_Db
--  141120  SamGLK  PRSA-5470, Fine tuen the performance of Exist().
--  131209  jagrno  Corrected problem related to basic data translation. Disabled basic data translation
--                  in model file, and added manual handling instead.
--  131127  jagrno  Hooks: Refactored and split code. Removed commented methods Get_Country_Id, 
--                  Get_Description and Get_Used_In_Appl. Modified Check_Unique_Description___
--                  to work with new template.
--  130910  chanlk  Model errors corrected.
--  130618  heralk  Scalability Changes - removed global variables.
--  --------------------------- APPS 9 --------------------------------------
--  110803  INMALK  Bug 98268, Added a cursor to Encode method to enable querying from the table when "use translation" is not checked.
--  100422  Ajpelk  Merge rose method documentation
--  --------------------------Eagle--------------------------------------------
--  110131  Anwese  Added column BlockedForUse and modified Views, Encode/Decode and Get methods.
--  070404  UtGulk  Added column default_locale.(F1PR458 Improved locale handling for printouts)
--  060208  JoEd    Added columns COUNTRY_CODE3 and COUNTRY_ID.
--                  Added functions Get_Country_Code, Get_Country_Code3 and Get_Country_Id.
--                  Rearranged LU according to the latest template.
--  060117  reanpl  Changed order in Enumerate
--  040604  MAKULK  Merged LCS patch 37877.
--                  040513  HIPELK  Bug Id 37877, Modified the Exist method.
--  040220  DHSELK  Removed substrb and changed to substr where needed for Unicode Support
--  031024  LaRelk  LCS merge Bug 38723.
--  030929  KeFelk  Bug fix 103797, Added Check_Activate_Code.
--  030211  KESMUS  TSO Merge - Merged comments from TakeOff.
--  030206  KrSilk  Call 93790: Add a length check for the methods Get_Description
--  030206          and Get_Full_Name to overcome the language_code - description
--  030206          transformation problem.
--  030206  pranlk  Call 93731 Encode___ and Exist() modified
--  030206          to use uppercase for comparisons.
--  030205  KrSilk  Made the Get_Full_Name and Decode methods to have only one Return
--  030205          statement complying with IFS Standards.
--  030205  KrSilk  Call ID 93723: Put UPPER in the where clause for the two comparison
--  030205          parameters in Check_Unique_Description___.
--  030127  KrSilk  Changed almost all the methods and every view so that they will be compatible with
--  030127          the new Basic data translation guide lines. Added the method Insert_Lu_Data_Rec__.
--  021212  ZAHALK  Did the SP3 - Merge for Take-off. And did the decommenting.
--  020218  FRWA    Bug# 28033 Changed desc_ length from 100 to 740 for multi lang support.
--  010612  Larelk  Remove last parameter(TRUE) from  General_SYS.Init_Method in Method Set_Description__ ,
--  010612          Remove_Description__,Set_Full_Name__,Remove_Full_Name__,Set_Eu_Member__ ,Activate_Code
--  990713  MATA    Changed substr to substrb in VIEW definitions
--  990420  JoEd    Added method Exist_Db.
--  990406  JoEd    Bug# 9905: Removed function calls from cursors to improve performance.
--  981218  JoEd    Changed EC member to EU member.
--  981119  ToBa    Bug# 7849 "UPDATING COUNTRY NAME NOT POSSIBLE" fixed.
--  981117  JoEd    SID 7025: Added new LOV view ISO_COUNTRY_EC. Later renamed to ISO_COUNTRY_EU
--  981021  JoEd    Removed << and >> in Trace calls for non 8-bit character set error.
--  9810xx  JoEd    Run through IFS/Design.
--                  Added column ec_member.
--  980327  JaPa    USED_IN_APPL attribute changed to not null. FULL_NAME added
--                  to objversion.
--  971120  JaPa    Distinction of description within first 19 characters.
--                  Possibility to use descriptions of length 50 in Enumerate()
--                  by using object property LONG_ENUM.
--  971028  JaPa    Fixed bug 97-0002. Not possible to use client values
--                  longer then 20 characters.
--  970930  JaPa    Better check for client values. Encode can return NULL
--  970408  JaPa    New procedures Set_Description__() and Set_Full_Name__()
--  961213  JaPa    New public procedure Activate_Code()
--  960823  JaPa    Changed to fit functionality in FND ver 1.2
--  960508  JaPa    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_       CONSTANT VARCHAR2(1)        := Client_SYS.field_separator_;
no_description_  CONSTANT VARCHAR2(50)       := 'NO DESCRIPTION';


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('USED_IN_APPL', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('EU_MEMBER_DB', 'Y', attr_);
   Client_SYS.Add_To_Attr('BLOCKED_FOR_USE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('FETCH_JURISDICTION_CODE_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('SYSTEM_ADDED', 'N', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN iso_country_tab%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   --
   Basic_Data_Translation_API.Remove_Basic_Data_Translation(module_, lu_name_, remrec_.country_code || '^DESCRIPTION');
   Basic_Data_Translation_API.Remove_Basic_Data_Translation(module_, lu_name_, remrec_.country_code || '^FULL_NAME');
END Delete___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ISO_COUNTRY_TAB%ROWTYPE,
   newrec_     IN OUT ISO_COUNTRY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   user_language_code_    VARCHAR2(5);
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF newrec_.blocked_for_use = 'FALSE' THEN
      user_language_code_ := Fnd_Session_API.Get_Language;
      Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_, lu_name_, newrec_.country_code || '^DESCRIPTION', user_language_code_, newrec_.description, oldrec_.description);
      Basic_Data_Translation_API.Insert_Basic_Data_Translation(module_, lu_name_, newrec_.country_code || '^FULL_NAME', user_language_code_, newrec_.full_name, oldrec_.full_name);
   END IF;
END Update___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     iso_country_tab%ROWTYPE,
   newrec_ IN OUT iso_country_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   -- Do additional validations
   IF (indrec_.used_in_appl AND newrec_.used_in_appl = 'FALSE') THEN
      IF (Iso_Currency_API.Country_Code_Is_Used(newrec_.country_code)) THEN
         Client_SYS.Add_Info(lu_name_, 'CODEISUSED: The ISO country code is used as a Default Country of one or more ISO currencies.', NULL, NULL, NULL);
      END IF;
   END IF;
   IF (indrec_.description) THEN
      Check_Unique_Description___(newrec_.country_code, newrec_.description);
   END IF;
   IF (indrec_.used_in_appl) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.used_in_appl);
   END IF;
   IF (indrec_.fetch_jurisdiction_code) THEN
      IF (newrec_.fetch_jurisdiction_code NOT IN ('TRUE', 'FALSE')) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDSTAXCODE: Invalid value :P1 for FETCH JURISDICTION CODE.', newrec_.fetch_jurisdiction_code);
      END IF;
   END IF;
END Check_Update___;


-- Check_Unique_Description___
--   Gives an error if the given country description already exists.
PROCEDURE Check_Unique_Description___ (
   country_code_ IN VARCHAR2,
   description_  IN VARCHAR2 )
IS
   cnt_        NUMBER;
   found_      BOOLEAN;
   desc_       VARCHAR2(20);
   CURSOR count_country_code IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM   ISO_COUNTRY_DEF
      WHERE  UPPER(description) LIKE UPPER(desc_)
      AND    country_code <> country_code_;
BEGIN
   IF (NVL(LENGTH(description_), 0) >= 20 - 1) THEN
      desc_ := SUBSTR(description_, 1, 20 - 1) || '%';
   ELSE
      desc_ := description_;
   END IF;

   OPEN count_country_code;
   FETCH count_country_code INTO cnt_;
   found_ := count_country_code%FOUND;
   CLOSE count_country_code;
   IF found_ THEN
      Error_SYS.Record_Exist(lu_name_, p1_ => description_);
   END IF;
END Check_Unique_Description___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   inserts data into the Iso_Country_Tab and Language_Sys_Tab. This is used primarily
--   in IsoCountry.ins
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN ISO_COUNTRY_TAB%ROWTYPE )
IS
BEGIN
   IF NOT Check_Exist___(newrec_.country_code) THEN
      INSERT
         INTO ISO_COUNTRY_TAB(
            country_code,
            country_code3,
            country_id,
            description,
            used_in_appl,
            full_name,
            eu_member,
            fetch_jurisdiction_code,
            default_locale,
            blocked_for_use,
            system_added,
            rowversion
            )
         VALUES(
            newrec_.country_code,
            newrec_.country_code3,
            newrec_.country_id,
            newrec_.description,
            newrec_.used_in_appl,
            newrec_.full_name,
            newrec_.eu_member,
            newrec_.fetch_jurisdiction_code,
            newrec_.default_locale,
            newrec_.blocked_for_use,
            'Y',sysdate);
   ELSE
      UPDATE ISO_COUNTRY_TAB
         SET country_code3 = newrec_.country_code3,
             country_id = newrec_.country_id,
             description = newrec_.description,
             full_name = newrec_.full_name,
             fetch_jurisdiction_code = newrec_.fetch_jurisdiction_code,
             default_locale = newrec_.default_locale,
             blocked_for_use = newrec_.blocked_for_use
       WHERE country_code = newrec_.country_code;
   END IF;

   IF newrec_.blocked_for_use = 'FALSE' THEN
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, lu_name_, newrec_.country_code || '^DESCRIPTION', newrec_.description);
      Basic_Data_Translation_API.Insert_Prog_Translation(module_, lu_name_, newrec_.country_code || '^FULL_NAME', newrec_.full_name);
   END IF;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Overtaken because we need to check against a subset of ISO countries
-- Only countries used by the application should be considered.
@Overtake Base
@UncheckedAccess
PROCEDURE Exist (
   country_code_ IN VARCHAR2 )
IS
   dummy_   NUMBER;
   desc_    VARCHAR2(20);
   exist_   BOOLEAN := FALSE;
   CURSOR client_exist IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM   ISO_COUNTRY
      WHERE  UPPER(description) LIKE UPPER(desc_);

   CURSOR db_exist IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM   ISO_COUNTRY
      WHERE  country_code = country_code_;

BEGIN
   IF (NVL(LENGTH(country_code_), 0) = 2) THEN
      OPEN db_exist;
      FETCH db_exist INTO dummy_;
      IF db_exist%FOUND THEN
         exist_ := TRUE;
      END IF;
      CLOSE db_exist;
   END IF;

   IF (NOT exist_) THEN
      IF (NVL(LENGTH(country_code_), 0) >= 20 - 1) THEN
         desc_ := SUBSTR(country_code_, 1, 20 - 1) || '%';
      ELSE
         desc_ := country_code_;
      END IF;
      OPEN client_exist;
      FETCH client_exist INTO dummy_;   
      IF client_exist%FOUND THEN
         exist_ := TRUE;
      END IF;
      CLOSE client_exist;
   END IF;

   IF (NOT exist_) THEN
      Error_SYS.Record_Not_Exist(lu_name_, p1_ => country_code_);
   END IF;
END Exist;

@UncheckedAccess
PROCEDURE Exist_Code (
   country_code_  IN VARCHAR2)
IS
BEGIN
   IF (NOT Check_Exist___(country_code_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_, p1_ => country_code_);
   ELSE
      IF (NOT Check_Activate_Code(country_code_)) THEN
         Error_SYS.Record_General(lu_name_, 'NONVALIDCODE: ISO country code for Default Country is NOT in Used');
      END IF;
   END IF;
END Exist_Code;

@UncheckedAccess
PROCEDURE Exist_Db_All (
   country_code_  IN VARCHAR2)
IS 
BEGIN 
   --This method does not check if the Country code is Activated. Only checks if it Exists in the DB.
   IF (NOT Check_Exist___(country_code_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_, p1_ => country_code_);
   END IF;
END Exist_Db_All;

@UncheckedAccess
FUNCTION Get_Description (
   country_code_  IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   desc_       ISO_COUNTRY_TAB.description%TYPE;
   lang_code_  VARCHAR2(5);
   CURSOR get_desc IS
      SELECT description
      FROM   ISO_COUNTRY_TAB
      WHERE  country_code = country_code_
      AND    (used_in_appl = 'TRUE' OR blocked_for_use = 'TRUE');
BEGIN
   IF (NVL(LENGTH(language_code_), 0) = 2) THEN
      -- Note: Assuming the incoming parameter is the real language_code.
      lang_code_ := language_code_;
   ELSE
      -- Note: Assuming the incoming parameter is the description of the real language_code
      lang_code_ := Iso_Language_API.Encode(language_code_);
   END IF;

   desc_  := Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_, country_code_ || '^DESCRIPTION', lang_code_);
   IF (desc_ IS NOT NULL) THEN
      NULL;
   ELSE
      OPEN get_desc;
      FETCH get_desc INTO desc_;
      IF get_desc%NOTFOUND THEN
         CLOSE get_desc;
         desc_ := NULL;
      ELSE
         CLOSE get_desc;
      END IF;
   END IF;
   RETURN desc_;
END Get_Description;


@UncheckedAccess
FUNCTION Get_Full_Name (
   country_code_  IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   desc_       ISO_COUNTRY_TAB.description%TYPE;
   return_     VARCHAR2(100);
   name_       ISO_COUNTRY_TAB.full_name%TYPE;
   lang_code_  VARCHAR2(5);

   CURSOR get_desc IS
      SELECT full_name, description
      FROM   ISO_COUNTRY_TAB
      WHERE  country_code = country_code_;

BEGIN
   IF (NVL(LENGTH(language_code_), 0) = 2) THEN
      -- Note: Assuming the incoming parameter is the real language_code.
      lang_code_ := language_code_;
   ELSE
      -- Note: Assuming the incoming parameter is the description of the real language_code
      lang_code_ := Iso_Language_API.Encode(language_code_);
   END IF;

   name_ := Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_, country_code_ || '^FULL_NAME', lang_code_);
   IF (name_ IS NULL) THEN
      OPEN get_desc;
      FETCH get_desc INTO name_, desc_;
      IF get_desc%NOTFOUND THEN
         CLOSE get_desc;
         return_ := NULL;
      ELSE
         CLOSE get_desc;
         IF (name_ IS NULL) THEN
            desc_ := NVL(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_, country_code_ || '^DESCRIPTION', lang_code_), desc_);
            IF (desc_ IS NULL) THEN
               return_ := NULL;
            ELSE
               return_ := desc_;
            END IF;
         ELSE
            return_ := name_;
         END IF;
      END IF;
   ELSE
      return_ := name_;
   END IF;
   RETURN return_;
END Get_Full_Name;


-- Activate_Code
--   Activate the code to use it in the current installation of IFS APPLICATIONS.
--   The only input parameter is just the code.
PROCEDURE Activate_Code (
   country_code_ IN VARCHAR2 )
IS
BEGIN
   UPDATE ISO_COUNTRY_TAB
      SET   used_in_appl = 'TRUE'
      WHERE country_code = country_code_
      AND   NVL(used_in_appl, 'FALSE') <> 'TRUE'
      AND   blocked_for_use = 'FALSE';
END Activate_Code;


-- Decode
--   Gives the description taking the user's language code into consideration.
@UncheckedAccess
FUNCTION Decode (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_             VARCHAR2(2000);
   curr_user_lang_    VARCHAR2(10);
   CURSOR get_value IS
      SELECT description
      FROM   ISO_COUNTRY_TAB
      WHERE  country_code = country_code_
      AND    (used_in_appl = 'TRUE' OR blocked_for_use = 'TRUE');

BEGIN
   curr_user_lang_ := Fnd_Session_Api.Get_Language;
   value_ := Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_, country_code_ || '^DESCRIPTION', curr_user_lang_);
   IF (value_ IS NOT NULL) THEN
      NULL;
   ELSE
      OPEN get_value;
      FETCH get_value INTO value_;
      IF (get_value%NOTFOUND) THEN
         CLOSE get_value;
      ELSE
         CLOSE get_value;
      END IF;
   END IF;
   RETURN value_;
END Decode; 


-- Encode
--   Gives the country code taking the description as input.
@UncheckedAccess
FUNCTION Encode (
   description_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   language_code_    VARCHAR2(5);
   desc_             VARCHAR2(20);
   int_country_code_ VARCHAR2(2);
   country_code_     VARCHAR2(2);
   
   -- The country_code is within the path column, just after the ".", two character long
   CURSOR get_int_country_code(lang_code_ VARCHAR2) IS
      SELECT Substr(Substr(path, instr(path, '.')+1),1, 2)
      FROM language_sys_tab ls
      WHERE ls.main_type = 'LU'
      AND   ls.type      = 'Basic Data'
      AND   ls.path      LIKE lu_name_||'_'||module_||'.'||'%'||'~DESCRIPTION'
      AND   ls.attribute = 'Text'
      AND   ls.lang_code = lang_code_
      AND   UPPER(ls.text) LIKE UPPER(desc_);
      
   CURSOR get_prog_int_country_code(lang_code_ VARCHAR2) IS
      SELECT Substr(Substr(path, instr(path, '.')+1),1, 2)
      FROM language_sys_tab ls
      WHERE ls.main_type = 'LU'
      AND   ls.type      = 'Basic Data'
      AND   ls.path      LIKE lu_name_||'_'||module_||'.'||'%'
      AND   ls.attribute = 'Text'
      AND   ls.lang_code = lang_code_
      AND   UPPER(ls.text) LIKE UPPER(desc_);
   
   -- Make sure country_code found in above cursor exist in the IsoCountry table
   CURSOR get_country_code IS
      SELECT country_code
      FROM iso_country_tab
      WHERE country_code = int_country_code_
      AND  (used_in_appl = 'TRUE' OR blocked_for_use = 'TRUE');
      
   CURSOR get_value_no_language IS
      SELECT country_code
      FROM   iso_country_tab
      WHERE  UPPER (description) LIKE UPPER (desc_);
BEGIN
   IF (NVL(LENGTH(description_), 0) >= 20 - 1) THEN
      desc_ := SUBSTR(description_, 1, 20 - 1) || '%';
   ELSE
      desc_ := description_;
   END IF;

   IF Language_Sys_Imp_API.Get_Use_Translation_Db('APPSRV', 'IsoCountry') = 'FALSE' THEN --Don't use basic language
      OPEN get_value_no_language;
      FETCH get_value_no_language INTO country_code_;
      IF (get_value_no_language%NOTFOUND) THEN
         CLOSE get_value_no_language;
         RETURN NULL;
      END IF;
      CLOSE get_value_no_language;
   ELSE
      language_code_ := NVL(Fnd_Session_API.Get_Language,'en');
      
      OPEN get_int_country_code(language_code_);
      FETCH get_int_country_code INTO int_country_code_;
      IF (get_int_country_code%NOTFOUND) THEN
         CLOSE get_int_country_code;
         OPEN get_int_country_code('PROG');
         FETCH get_int_country_code INTO int_country_code_;
         IF (get_int_country_code%NOTFOUND) THEN
            CLOSE get_int_country_code;
            OPEN get_prog_int_country_code('PROG');
            FETCH get_prog_int_country_code INTO int_country_code_;
            CLOSE get_prog_int_country_code;
         ELSE
            CLOSE get_int_country_code;
         END IF;
      ELSE
         CLOSE get_int_country_code;
      END IF;
      
      IF int_country_code_ IS NOT NULL THEN
         -- Make sure country_code found in "Basic Data Translation" also exist in the IsoCountry table itself
         OPEN get_country_code;
         FETCH get_country_code INTO country_code_;
         CLOSE get_country_code;
      END IF;
      
   END IF;
   RETURN country_code_;  
END Encode;

@UncheckedAccess
PROCEDURE Enumerate_Db (
   db_list_ OUT VARCHAR2 )
IS
   enum_len_     INTEGER := NULL;
   codes_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT country_code
      FROM ISO_COUNTRY
      ORDER BY description;
BEGIN
   IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
      enum_len_ := 50;
   ELSE
      enum_len_ := 20;
   END IF;
   FOR v IN get_value LOOP
      codes_ := codes_ || v.country_code || separator_;
   END LOOP;
   db_list_ := codes_;
END Enumerate_Db;
   
@UncheckedAccess
PROCEDURE Enumerate (
   desc_list_ OUT VARCHAR2 )
IS
   enum_len_     INTEGER := NULL;
   descriptions_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT SUBSTR(NVL(description, no_description_), 1, enum_len_) description
      FROM ISO_COUNTRY
      ORDER BY description;
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


-- Exist_Db
--   An Exist method for IID db values.
@UncheckedAccess
PROCEDURE Exist_Db (
   country_code_ IN VARCHAR2 )
IS
BEGIN
   Exist(country_code_);
END Exist_Db;


-- Check_Activate_Code
--   Checks if the country is used in the application.
@UncheckedAccess
FUNCTION Check_Activate_Code (
   country_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR check_active IS
      SELECT 1
      FROM   ISO_COUNTRY_TAB
      WHERE  country_code = country_code_
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
FUNCTION Get_Country_Code (
   country_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ ISO_COUNTRY_TAB.country_code%TYPE;
   CURSOR get_attr IS
      SELECT country_code
      FROM ISO_COUNTRY_TAB
      WHERE country_id = country_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Country_Code;


@UncheckedAccess
FUNCTION Get_Country_Code3 (
   country_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ ISO_COUNTRY_TAB.country_code3%TYPE;
   CURSOR get_attr IS
      SELECT country_code3
      FROM ISO_COUNTRY_TAB
      WHERE country_id = country_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Country_Code3;


@UncheckedAccess
FUNCTION Get_Country_Id (
   country_code_2or3_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_  ISO_COUNTRY_TAB.country_id%TYPE := NULL;
   chars_ NUMBER;
   CURSOR get_attr IS
      SELECT country_id
      FROM ISO_COUNTRY_TAB
      WHERE (chars_ = 2 AND country_code = country_code_2or3_)
      OR (chars_ = 3 AND country_code3 = country_code_2or3_);
BEGIN
   chars_ := NVL(LENGTH(country_code_2or3_), 0);
   IF (chars_ IN (2, 3)) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Country_Id;

@UncheckedAccess
FUNCTION Get_Country_Code_By_Code3 (
   country_code3_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   country_code_  ISO_COUNTRY_TAB.country_code%TYPE;   
   CURSOR get_country_code IS
      SELECT country_code
      FROM ISO_COUNTRY_TAB
      WHERE country_code3 = country_code3_;
BEGIN   
   OPEN get_country_code;
   FETCH get_country_code INTO country_code_;
   CLOSE get_country_code;
   
   RETURN country_code_;
END Get_Country_Code_By_Code3;
