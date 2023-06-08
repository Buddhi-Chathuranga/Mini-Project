-----------------------------------------------------------------------------
--
--  Logical unit: IsoCurrency
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210308  DEEKLK  AM2020R1-7438, Modified Insert_Lu_Data_Rec__().
--  160323  SEROLK  STRSA-10072, Modified methods Insert() and Update()
--  141205  PRIKLK  PRSA-5814, Override methods Insert and Update and added RCMINT method calls.
--  141128  TAORSE  Added Enumerate_Db
--  131126  jagrno  Hooks: Refactored and split code. Removed obsolete method Get_Record___.
--                  Removed commented code. Made public attributes description, used_in_appl, system_added
--                  private because the corresponding Get...-methods were commented from the API-file.
--                  Removed unused obsolete global no_description_. Modified Check_Unique_Description___
--                  to work with new template.
--  130910  chanlk   Model errors corrected.
--  130618  heralk   Scalability Changes - removed global variables.
--  100422  Ajpelk   Merge rose method documentation
--  --------------------------Eagle---------------------------------------------
--  070404  UtGulk   Added column default_country.(F1PR458 Improved locale handling for printouts)
--  070104  DUWILK   Add function Get_Currency_Info (Bug# 61961)
--  060118  UTGULK   Bug 55565, Modified Enumerate to order by description.
--  040220  DHSELK   Removed substrb and changed to substr where needed for Unicode Support
--  030217  pranlk   Call 94113 Error when saving modified description.
--  030217           modified  update___
--  030211  KESMUS   TSO Merge - Merged comments from TakeOff.
--  030206  pranlk   Call 93790 Get_Description modified to get the language code
--  030206           if the description is passed in.
--  030206  pranlk   Call 93731 Encode___ and Exist() modified
--  030206           to use uppercase in comparisons.
--  030205  pranlk   Call 93723 Check_Unique_Description___ modified
--  030205           converts to uppercase for comparison.
--  030116  pranlk   Insert_Lu_Data_Rec__ method was added to insert data
--  030116           into the LU table according to the new Basic Data Translation
--  030116           guidelines. This method is used in IsoCurrency.ins
--  030116           almost all methods were changed to follow the same guidelines.
--  020627  Shth     Bug Id 31048, modified Check_Unique_Description___().
--  020314 Dobese    Bug 28627, Added where statement in Exist for db values.
--  990420  JoEd     Added method Exist_Db.
--  990416  JoEd     Bug# 9905: Removed function calls from cursors to improve performance.
--  990416           Replaced trace messages with Init_Method calls.
--  981021  JoEd     Removed << and >> in Trace calls for non 8-bit character set error.
--  980327  JaPa     USED_IN_APPL attribute changed to not null.
--  971120  JaPa     Distinction of description within first 19 characters.
--  971120           Possibility to use descriptions of length 50 in Enumerate()
--  971120           by using object property LONG_ENUM.
--  971028  JaPa     Fixed bug 97-0002. Not possible to use client values
--  971028           longer then 20 characters.
--  970930  JaPa     Better check for client values. Encode can return NULL
--  970401  JaPa     New procedure Set_Description__()
--  961213  JaPa     New public procedure Activate_Code()
--  960902  JaPa     Changed to fit functionality in FND ver 1.2
--  960508  JaPa     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_       CONSTANT VARCHAR2(1)  := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('USED_IN_APPL', Fnd_Boolean_API.DB_FALSE, attr_);
   Client_SYS.Add_To_Attr('SYSTEM_ADDED', 'N', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT ISO_CURRENCY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   -- Server defaults
   IF (newrec_.system_added IS NOT NULL) THEN
      newrec_.system_added := 'N';
   END IF;
   --
   super(objid_, objversion_, newrec_, attr_);
END Insert___;
   
@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     ISO_CURRENCY_TAB%ROWTYPE,
   newrec_     IN OUT ISO_CURRENCY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   curr_user_lang_ VARCHAR2(10) := Fnd_Session_API.Get_Language;
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoCurrency',
      newrec_.currency_code,
      curr_user_lang_, newrec_.description, oldrec_.description);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     iso_currency_tab%ROWTYPE,
   newrec_ IN OUT iso_currency_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   other_cur_code_ iso_currency_tab.currency_code%TYPE;
   
   CURSOR cur_code_exists IS
      SELECT currency_code
      FROM iso_currency_tab
      WHERE currency_number = newrec_.currency_number
      AND currency_code <> newrec_.currency_code;
BEGIN
   IF indrec_.currency_number THEN
      OPEN cur_code_exists;
      FETCH cur_code_exists INTO other_cur_code_;
      CLOSE cur_code_exists;
      
      IF other_cur_code_ IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'CURNUMEXISTS: Currency number :P1 is already connected to currency code :P2.', newrec_.currency_number, other_cur_code_);
      END IF;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Common___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     iso_currency_tab%ROWTYPE,
   newrec_ IN OUT iso_currency_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   lang_  VARCHAR2(10);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (indrec_.used_in_appl AND newrec_.used_in_appl = 'TRUE' AND newrec_.default_country IS NOT NULL ) THEN
      Iso_Country_API.Exist_Code(newrec_.default_country); 
   END IF;
   
   -- Ensure unique descriptions
   IF (indrec_.description) THEN
      lang_ := Language_SYS.Get_Language;
      IF (lang_ = 'PROG') THEN
         lang_ := 'en';
      ELSE
         Iso_Language_API.Exist(lang_);
      END IF;
      Check_Unique_Description___(newrec_.currency_code, newrec_.description);
   END IF;
END Check_Update___;


FUNCTION Check_Db_Exist___ (
   currency_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR db_exist IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM   ISO_CURRENCY_TAB
      WHERE  currency_code = currency_code_
      AND    used_in_appl = 'TRUE';
   --
   dummy_ NUMBER;
   exist_ BOOLEAN := FALSE;
BEGIN
   OPEN db_exist;
   FETCH db_exist INTO dummy_;
   exist_ := (db_exist%FOUND);
   CLOSE db_exist;
   RETURN exist_;
END Check_Db_Exist___;


PROCEDURE Check_Unique_Description___ (
   currency_code_ IN VARCHAR2,
   description_   IN VARCHAR2 )
IS
   cnt_   NUMBER;
   CURSOR get_count IS
      SELECT /*+  FIRST_ROWS */ 1
      FROM   ISO_CURRENCY_DEF
      WHERE  UPPER(description) = UPPER(description_)
      AND    currency_code <> currency_code_;
BEGIN

   OPEN get_count;
   FETCH get_count INTO cnt_;
   CLOSE get_count;

   IF (cnt_ > 0) THEN
      Error_SYS.Record_General(lu_name_,'ISOCURRUNIQDESC: Iso Currency :P1 already exists.', description_);
   END IF;
END Check_Unique_Description___;

-- Check_Default_Country_Ref___
--   Perform validation on the DefaultCountryRef reference.
PROCEDURE Check_Default_Country_Ref___ (
   newrec_ IN OUT iso_currency_tab%ROWTYPE )
IS
BEGIN
   Iso_Country_API.Exist_Code(newrec_.default_country);
END Check_Default_Country_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Inserts data into it's LU and to the Language_Sys_Tab.
--   Basically used in IsoCurrency.ins.
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN ISO_CURRENCY_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM ISO_CURRENCY_TAB
      WHERE currency_code = newrec_.currency_code;
BEGIN
   --
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      CLOSE Exist;
      INSERT
         INTO ISO_CURRENCY_TAB(
            currency_code,
            description,
            used_in_appl,
            default_country,
            system_added,
            currency_number,
            rowversion)
         VALUES(
            newrec_.currency_code,
            newrec_.description,
            'FALSE',
            newrec_.default_country,
            'Y',
            newrec_.currency_number,
            sysdate);
      Basic_Data_Translation_API.Insert_Prog_Translation(
         'APPSRV', 'IsoCurrency',
         newrec_.currency_code, newrec_.description);
   ELSE
      CLOSE Exist;
      Basic_Data_Translation_API.Insert_Prog_Translation(
         'APPSRV', 'IsoCurrency',
         newrec_.currency_code, newrec_.description);
      UPDATE ISO_CURRENCY_TAB
         SET description = newrec_.description,
             default_country = newrec_.default_country,
             currency_number = newrec_.currency_number
         WHERE currency_code = newrec_.currency_code;
   END IF;
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Overtaken because we need to check against a subset of ISO currencies
-- Only currencies used by the application should be considered.
@Overtake Base
@UncheckedAccess
PROCEDURE Exist (
   currency_code_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Db_Exist___(currency_code_)) THEN
      Error_SYS.Record_Not_Exist(lu_name_, p1_ => currency_code_);
   END IF;
END Exist;


-- Enumerate
--   Used by client if IsoCurrency acts as IID-LU.
@UncheckedAccess
PROCEDURE Enumerate (
   desc_list_ OUT VARCHAR2)
IS
   enum_len_     INTEGER := NULL;
   descriptions_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT description
      FROM ISO_CURRENCY
      ORDER BY description;
BEGIN
   --
   IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
      enum_len_ := 50;
   ELSE
      enum_len_ := 20;
   END IF;
   --
   FOR rec_ IN get_value LOOP
      descriptions_ := descriptions_ || SUBSTR(rec_.description,1,enum_len_) || separator_;
   END LOOP;
   desc_list_ := descriptions_;
END Enumerate;

@UncheckedAccess
PROCEDURE Enumerate_Db(
   currency_list_ OUT VARCHAR2)
IS
   enum_len_     INTEGER := NULL;
   currencies_ VARCHAR2(32000);
   CURSOR get_value IS
      SELECT currency_code
      FROM ISO_CURRENCY
      ORDER BY description;
BEGIN
   IF (NVL(Object_Property_API.Get_Value(lu_name_, '*', 'LONG_ENUM'), 'FALSE') = 'TRUE') THEN
      enum_len_ := 50;
   ELSE
      enum_len_ := 20;
   END IF;
   FOR rec_ IN get_value LOOP
      currencies_ := currencies_ || SUBSTR(rec_.currency_code,1,enum_len_) || separator_;
   END LOOP;
   currency_list_ := currencies_;
END Enumerate_Db;


-- Get_Description
--   Get description for the currency in given language.
--   If LanguageCode is NULL the actual language from server is taken (Language_SYS.Get_Language).
--   The LanguageCode parameter is the client value for the language.
@UncheckedAccess
FUNCTION Get_Description (
   curr_code_     IN VARCHAR2,
   language_code_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   desc_ VARCHAR2(2000);
   lang_ VARCHAR2(2);

   CURSOR get_desc IS
      SELECT description
      FROM   ISO_CURRENCY_TAB
      WHERE  currency_code = curr_code_
      AND    used_in_appl = 'TRUE';

BEGIN
   IF nvl(length(language_code_),0) = 2 THEN
      lang_ := language_code_;
   ELSE
      lang_ := Iso_Language_API.Encode(language_code_);
   END IF;
   --
   desc_ := Basic_Data_Translation_API.Get_Basic_Data_Translation(
               'APPSRV', 'IsoCurrency',
               curr_code_, lang_ );
   IF (desc_ IS NOT NULL) THEN
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
FUNCTION Country_Code_Is_Used (
   country_code_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_      NUMBER;
   CURSOR is_used IS
      SELECT 1
      FROM ISO_CURRENCY_TAB
      WHERE default_country = country_code_;
BEGIN
   OPEN is_used;
   FETCH is_used INTO dummy_;
   IF (is_used%FOUND) THEN
      CLOSE is_used;
      RETURN TRUE;
   ELSE
      CLOSE is_used;
      RETURN FALSE;
   END IF;
   RETURN FALSE;
END Country_Code_Is_Used;

-- Encode
--   Returns database value (=currency code) for the currency.
--   Used by client if IsoCurrency acts as IID-LU.
@UncheckedAccess
FUNCTION Encode (
   description_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_   VARCHAR2(10);
   desc_    VARCHAR2(20);
   CURSOR get_value IS
      SELECT currency_code
      FROM   ISO_CURRENCY_TAB
      WHERE  upper(description) LIKE upper(desc_)
      AND    used_in_appl = 'TRUE';
BEGIN
   IF (NVL(LENGTH(description_), 0) >= 19) THEN
      desc_ := SUBSTR(description_, 1, 19) || '%';
   ELSE
      desc_ := description_;
   END IF;
   OPEN get_value;
   FETCH get_value INTO value_;
   IF (get_value%NOTFOUND) THEN
      value_ := NULL;
   END IF;
   CLOSE get_value;
   RETURN value_;
END Encode;


-- Decode
--   Returns client value (=description) for the currency code.
--   Used by client if IsoCurrency acts as IID-LU.
@UncheckedAccess
FUNCTION Decode (
   curr_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   value_   VARCHAR2(2000);
   CURSOR get_value IS
      SELECT description
      FROM   ISO_CURRENCY_TAB
      WHERE  currency_code = curr_code_
      AND    used_in_appl = 'TRUE';
BEGIN
   value_ := Basic_Data_Translation_API.Get_Basic_Data_Translation(
                        'APPSRV', 'IsoCurrency', curr_code_ );
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
      RETURN value_;
   END IF;
END Decode;


-- Activate_Code
--   Activate the code to use it in the current installation of IFS APPLICATIONS.
--   The only input parameter is just the code.
PROCEDURE Activate_Code (
   curr_code_ IN VARCHAR2 )
IS
BEGIN
   --
   UPDATE ISO_CURRENCY_TAB
      SET used_in_appl = 'TRUE'
      WHERE currency_code = curr_code_
      AND NVL(used_in_appl, 'FALSE') <> 'TRUE';
END Activate_Code;


-- Exist_Db
--   An Exist method for IID db values.
@UncheckedAccess
PROCEDURE Exist_Db (
   curr_code_ IN VARCHAR2 )
IS
BEGIN
   Exist(curr_code_);
END Exist_Db;



