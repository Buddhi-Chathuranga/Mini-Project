-----------------------------------------------------------------------------
--
--  Logical unit: ApplicationCountry
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981221  JoEd  Changed EC member to EU member
--  981009  JoEd  Added column ec_member.
--  970507  JaPa  New procedure Get_Control_Type_Value_Desc()
--  970506  JaPa  Created
--  010531  Larelk  added General_SYS.Init_Method IN PROCEEDURE Get_Control_Type_Value_Desc
--  031003  Pranlk Country description taken from Basic_Data_Translation_API.
--  040220  DHSELK Removed substrb and changed to substr where needed for Unicode Support
--  --------------------------Eagle------------------------------------------
--  100421  Ajpelk Merge rose method documentatio
--  --------------------------- APPS 9 --------------------------------------
--  131123  NuKuLK  Hooks: Refactored and splitted code.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   country_code_ IN VARCHAR2 )
IS
BEGIN
   Iso_Country_API.Exist(country_code_);
END Exist;


@UncheckedAccess
FUNCTION Get_Description (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Iso_Country_API.Get_Description(country_code_);
END Get_Description;



@UncheckedAccess
FUNCTION Get_Eu_Member (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Iso_Country_API.Get_Eu_Member(country_code_);
END Get_Eu_Member;



-- Get_Control_Type_Value_Desc
--   A public method needed by Accounting Rules module.
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;



