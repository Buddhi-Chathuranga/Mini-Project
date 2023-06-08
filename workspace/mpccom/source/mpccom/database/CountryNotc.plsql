-----------------------------------------------------------------------------
--
--  Logical unit: CountryNotc
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220128  ErFelk  Bug 162143(SC21R2-7321), Removed the correction added from Bug 158692.
--  210608  ErFelk  Bug 158692(SCZ-14501), Modified Get_Country_Notc() and Get_Country_Notc___() by passing intrastat_direction_. 
--  201224  DiJwlk  SC2020R1-11841, Modified New_Description___(), New() and Added Check_Common___()
--  201224          Removed attr_ functionality to optimiize performance
--  160420  JeLise  STRSC-1373, Added Check_Country_Code_Ref___.
--  160208  PrYaLK  Bug 121011, Modified New_Description___(), Check_Insert___(), Check_Update___() and New()
--  160208          methods to get the language code for a given country.
--  150622  DaZase  COB-509, Added UncheckedAccess-annotation to Get_Notc().
--  150522  ChJalk  Bug 122634, Added annotation @UncheckedAccess to the method Get_Country_Notc.
--  100426  Ajpelk  Merge rose method documentation
--  091008  ChFolk  Removed view COUNTRY_NOTC_DEF.
--  ---------------------------------- 14.0.0 -------------------------------
--  080402  HaPulk  Bug 68143, Replaced Set_Property with method Set_Language in Fnd_Session_API.
--  060112  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___.
--  --------------------------------- 13.3.0 --------------------------------
--  041217  JaBalk  Modified Get_Description___ to avoid the ora error by removing
--  041217          Fnd_Session_API.Set_Property and removed General_SYS.Init.
--  030801  KeFelk  Performed SP4 Merge. (SP4Only)
--  030311  ThJalk  Bug 36036, Added view COUNTRY_NOTC_LOV.
--  010403  ErFi    Modified New to not raise errors when inserting
--                  duplicate records.
--  010525  JSAnse  Bug 21463, Changed name in the call to General_SYS.Init_Method in New_Description.
--  010302  ErFi    Modified Get_Country_Notc___.
--  010301  ErFi    Added view COUNTRY_NOTC_DEF, method Get_Notc
--  010228  ErFi    Added methods Get_Country_Notc, Get_Description, New
--                  Get_Country_Notc___, Get_Description___, New_Description,
--                  New_Description___
--  010209  ANLASE  Created, added undefines
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Country_Notc___
--   Returns the country specific Nature of Transaction Code (NOTC)
--   for the given NOTC and country code.
FUNCTION Get_Country_Notc___ (
   country_code_        IN VARCHAR2,
   notc_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ COUNTRY_NOTC_TAB.country_notc%TYPE;
   CURSOR get_attr IS
      SELECT country_notc
      FROM COUNTRY_NOTC_TAB
      WHERE country_code = country_code_
      AND   notc = notc_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
      
   RETURN temp_;
END Get_Country_Notc___;


-- Get_Description___
--   Returns the translated description of the Nature of Transaction Code
--   for the given country. If no language is given,
--   the language for the current user will be used.
FUNCTION Get_Description___ (
   country_code_ IN VARCHAR2,
   notc_         IN VARCHAR2,
   country_notc_ IN VARCHAR2,
   language_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ VARCHAR2(2000);
   lang_desc_   VARCHAR2(2000);

   temp_ COUNTRY_NOTC_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM COUNTRY_NOTC_TAB
      WHERE country_code = country_code_
      AND   notc = notc_
      AND   country_notc = country_notc_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   lang_desc_   := Iso_Language_API.Decode(language_);
   description_ := Language_Text_API.Decode(temp_, lang_desc_);
   RETURN description_;
END Get_Description___;


-- New_Description___
--   Creates a new description for the given country NOTC.
--   If language is not given, the user's language will be used.
PROCEDURE New_Description___ (
   country_code_ IN VARCHAR2,
   notc_         IN VARCHAR2,
   country_notc_ IN VARCHAR2,
   description_  IN VARCHAR2,
   language_     IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   oldrec_     country_notc_tab%ROWTYPE;
   newrec_     country_notc_tab%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(country_code_, notc_, country_notc_);
   newrec_ := oldrec_;
   newrec_.description := description_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Client_SYS.Add_To_Attr('LANG_CODE', language_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_ => TRUE);
END New_Description___;


@Override
PROCEDURE Check_Common___ (
   oldrec_    IN     country_notc_tab%ROWTYPE,
   newrec_    IN OUT country_notc_tab%ROWTYPE,
   indrec_    IN OUT Indicator_Rec,
   attr_      IN OUT VARCHAR2)
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF Validate_SYS.Is_Changed(oldrec_.description, newrec_.description, indrec_.description) THEN
      newrec_.description := Language_Text_API.Encode(newrec_.description, oldrec_.description, Iso_Language_API.Decode(Client_SYS.Get_Item_Value('LANG_CODE', attr_)));
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;


PROCEDURE Check_Country_Code_Ref___ (
   newrec_ IN OUT NOCOPY country_notc_tab%ROWTYPE )
IS
BEGIN
   Iso_Country_API.Exist_Db_All(newrec_.country_code);
END Check_Country_Code_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new country specific Nature of Transaction Code
--   with a language specific description. If language is not given,
--   language for the calling user will be used.
PROCEDURE New (
   country_code_ IN VARCHAR2,
   notc_         IN VARCHAR2,
   country_notc_ IN VARCHAR2,
   description_  IN VARCHAR2,
   language_     IN VARCHAR2 DEFAULT NULL )
IS
   attr_           VARCHAR2(2000);
   objid_          VARCHAR2(2000);
   objversion_     VARCHAR2(2000);
   duplicate_error EXCEPTION;
   PRAGMA          EXCEPTION_INIT(duplicate_error, -20112);
   newrec_         country_notc_tab%ROWTYPE;
   indrec_         Indicator_Rec;
BEGIN
   newrec_.country_code := country_code_;
   newrec_.notc         := notc_;
   newrec_.country_notc := country_notc_;
   newrec_.description  := description_;
   indrec_ := Get_Indicator_Rec___(newrec_);
   
   IF language_ IS NOT NULL THEN
      Iso_Language_API.Exist_Db_All(language_);
   END IF;
   BEGIN
      Client_SYS.Add_To_Attr('LANG_CODE', language_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   EXCEPTION
      -- Do not raise errors when inserting an already existing record
      -- This can happen e.g. when upgrading
      WHEN duplicate_error THEN
         NULL;
      WHEN OTHERS THEN
         RAISE;
   END;
END New;


-- Get_Country_Notc
--   Returns the country specific Nature of Transaction Code (NOTC)
--   for the given Notc and country code.
@UncheckedAccess
FUNCTION Get_Country_Notc (
   country_code_        IN VARCHAR2,
   notc_                IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Country_Notc___(country_code_, notc_);
END Get_Country_Notc;


-- Get_Description
--   Returns the translated description of the Nature of Transaction
--   Code for the given country. If no language is given,
--   the language for the current user will be used.
@UncheckedAccess
FUNCTION Get_Description (
   country_code_ IN VARCHAR2,
   notc_         IN VARCHAR2,
   country_notc_ IN VARCHAR2,
   language_     IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Description___(country_code_, notc_, country_notc_,
                             NVL(language_, Fnd_Session_API.Get_Language));
END Get_Description;


-- New_Description
--   Creates a new description for the given country NOTC.
--   If language is not given, the user's language will be used.
PROCEDURE New_Description (
   country_code_ IN VARCHAR2,
   notc_         IN VARCHAR2,
   country_notc_ IN VARCHAR2,
   description_  IN VARCHAR2,
   language_     IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_Description___(country_code_, notc_, country_notc_, description_,
                      NVL(language_, Fnd_Session_API.Get_Language));
END New_Description;


-- Get_Notc
--   Returns the detailed Nature of Transaction Code (NOTC)
--   for a given country specific NOTC.
@UncheckedAccess
FUNCTION Get_Notc (
   country_code_ IN VARCHAR2,
   country_notc_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ COUNTRY_NOTC_TAB.notc%TYPE;
   CURSOR get_attr IS
      SELECT notc
      FROM COUNTRY_NOTC_TAB
      WHERE country_code = country_code_
      AND   country_notc = country_notc_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Notc;



