-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalClass
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970219  frtv  Upgraded.
--  001026  LEIV  Added new public method New
--  001029  LEIV  Added new public method Check_Exist
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in New ,Check_Exist.
--  040309  CHRALK Description_Long attribute set as public and added get method.
--  060912  RaRulk Bug 60416,Added Check_Not_Null() for field description in Prepare_Insert__
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentatio
--  --------------------------- APPS 9 --------------------------------------
--  131126  NuKuLK  Hooks: Refactored and splitted code.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Public method that wraps std New method
PROCEDURE New (
   technical_class_ IN VARCHAR2,
   attr_ IN VARCHAR2 )
IS
  info_ VARCHAR2(2000);
  objid_ VARCHAR2(260);
  objversion_ VARCHAR2(260);
  attr_new_ VARCHAR2(2000);
BEGIN
  New__(info_,objid_,objversion_,attr_new_,'PREPARE');
  CLIENT_SYS.Add_To_Attr('TECHNICAL_CLASS',technical_class_,attr_new_);
  attr_new_ := attr_new_ || attr_;
  New__(info_,objid_,objversion_,attr_new_,'DO');
END New;


-- Check_Exist
--   Public function that returns 'TRUE' or 'FALSE'
--   depending on the class given exists or not
FUNCTION Check_Exist (
   technical_class_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(technical_class_) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Check_Exist;



