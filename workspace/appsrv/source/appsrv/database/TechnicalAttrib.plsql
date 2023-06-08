-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalAttrib
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960617  JoRo  Created
--  970219  frtv  Upgraded.
--  970530  JaPa  Added view TECHNICAL_ATTRIB_BOTH due to error in
--                TechnicalSpecification LU (direct table access).
--  040301  ThAblk Removed substr from views.
--  061030  RaRulk Modified the Unpack_Check_Insert___ and Unpack_Check_Update__ Bug ID 61417
--  070115  NiWiLK  Modified Get_Record___(Bug#62569).
--  ----------------------------Eagle----------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  130911  chanlk   Model errors corrected
--  -------------------------- APPS 9 ---------------------------------------
--  131126  paskno  Hooks: refactoring and splitting.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Copy_Technical_Attributes_
--   Copy technical attributes from one technical class to another.
PROCEDURE Copy_Technical_Attributes_ (
   from_technical_class_ IN VARCHAR2,
   to_technical_class_   IN VARCHAR2 )
IS
BEGIN
   Technical_Attrib_Numeric_API.Copy_Technical_Attributes_(from_technical_class_, to_technical_class_);
   Technical_Attrib_Alphanum_API.Copy_Technical_Attributes_(from_technical_class_, to_technical_class_);
END Copy_Technical_Attributes_;


-- Copy_Attrib_To_Criteria_
--   Copy attributes with a given class to the criteria table
PROCEDURE Copy_Attrib_To_Criteria_ (
   technical_class_     IN     VARCHAR2,
   technical_search_no_ IN OUT NUMBER )
IS
BEGIN
   technical_search_no_ := Technical_Search_Criteria_API.New_Search_No('');
   Technical_Attrib_Numeric_API.Copy_Attrib_To_Criteria_(technical_class_, technical_search_no_);
   Technical_Attrib_Alphanum_API.Copy_Attrib_To_Criteria_(technical_class_, technical_search_no_);
END Copy_Attrib_To_Criteria_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


