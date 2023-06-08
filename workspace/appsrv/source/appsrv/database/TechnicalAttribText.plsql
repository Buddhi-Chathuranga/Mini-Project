-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalAttribText
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960924  PeSe  Created
--  970219  frtv  Upgraded.
--  001029  LEIV  Added new public method New
--  001030  LEIV  Added new public method Check_Exist
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in New,Check_Exist.
--  110506  INMALK Bug 96782, Removed the UPPERCASE condition set for Value_Text
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentatio
--  --------------------------- APPS 9 --------------------------------------
--  131127  NuKuLK  Hooks: Refactored and splitted code.
------------------------------- Strike --------------------------------------
--  291123  SADELK  STRSA-15763, Added Copy_Tech_Attribute_Values().
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Get_Lov (
   technical_class_ IN  VARCHAR2,
   attribute_       IN  VARCHAR2,
   result_          OUT VARCHAR2 )
IS
   attr_temp_  VARCHAR2(32000);
   attr_  VARCHAR2(32000);
   text_separator_  CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;
   CURSOR get_valid_values (
   technical_class2_ VARCHAR2,
   attribute2_ VARCHAR2) IS
      SELECT value_text
      FROM TECHNICAL_ATTRIB_TEXT
      WHERE technical_class = technical_class2_
      AND attribute = attribute2_
      AND value_text IS NOT NULL
      ORDER BY value_text;
BEGIN
   attr_temp_ := NULL;
   attr_ := NULL;
   FOR value IN get_valid_values (technical_class_,
      attribute_) LOOP
      attr_temp_ := attr_temp_ || value.value_text || text_separator_;
      IF (LENGTH(attr_temp_) <= 2000) THEN
         attr_ := attr_temp_;
      END IF;
   END LOOP;
   result_ := attr_;
END Get_Lov;


@UncheckedAccess
FUNCTION Get_Lov2 (
   technical_class_ IN VARCHAR2,
   attribute_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   attr_temp_  VARCHAR2(32000);
   attr_  VARCHAR2(32000);
   text_separator_  CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;
   CURSOR get_valid_values (
   technical_class2_ VARCHAR2,
   attribute2_ VARCHAR2) IS
      SELECT value_text
      FROM TECHNICAL_ATTRIB_TEXT
      WHERE technical_class = technical_class2_
      AND attribute = attribute2_
      AND value_text IS NOT NULL
      ORDER BY value_text;
BEGIN
   attr_temp_ := NULL;
   attr_ := NULL;
   FOR value IN get_valid_values (technical_class_,
      attribute_) LOOP
      attr_temp_ := attr_temp_ || value.value_text || text_separator_;
      IF (LENGTH(attr_temp_) <= 2000) THEN
         attr_ := attr_temp_;
      END IF;
   END LOOP;
   RETURN attr_;
END Get_Lov2;

PROCEDURE Copy_Tech_Attribute_Values (
   from_technical_class_ IN VARCHAR2,
   to_technical_class_   IN VARCHAR2,
   attribute_       IN VARCHAR2 )
IS
   CURSOR getrec IS
      SELECT t1.value_text
      FROM   TECHNICAL_ATTRIB_TEXT t1
      WHERE  technical_class = from_technical_class_
      AND    attribute = attribute_      
      AND NOT EXISTS (
         SELECT 'x'
         FROM TECHNICAL_ATTRIB_TEXT t2
         WHERE t2.value_text = t1.value_text
         AND t2.attribute = attribute_
         AND   t2.technical_class = to_technical_class_);
BEGIN
   FOR rec IN getrec LOOP
       New(to_technical_class_, attribute_, rec.value_text);
   END LOOP;
END Copy_Tech_Attribute_Values;


-- New
--   Public method to add LOV-value for alphanumeric attribute
PROCEDURE New (
   technical_class_ IN VARCHAR2,
   attribute_ IN VARCHAR2,
   value_text_ IN VARCHAR2 )
IS
  info_ VARCHAR2(2000);
  objid_ VARCHAR2(260);
  objversion_ VARCHAR2(260);
  attr_ VARCHAR2(2000);
BEGIN

  New__(info_,objid_,objversion_,attr_,'PREPARE');
  CLIENT_SYS.Add_To_Attr('TECHNICAL_CLASS',technical_class_,attr_);
  CLIENT_SYS.Add_To_Attr('ATTRIBUTE',attribute_,attr_);
  CLIENT_SYS.Add_To_Attr('VALUE_TEXT',value_text_,attr_);
  New__(info_,objid_,objversion_,attr_,'DO');
END New;


-- Check_Exist
--   Public Check_exist-method that returns either 'TRUE' or 'FALSE'
FUNCTION Check_Exist (
   technical_class_ IN VARCHAR2,
   attribute_ IN VARCHAR2,
   value_text_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(technical_class_, attribute_, value_text_) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Check_Exist;

@UncheckedAccess
PROCEDURE Validate_Text(
   technical_class_ IN VARCHAR2,
   attribute_       IN VARCHAR2,
   value_text_      IN VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT DISTINCT 1
      FROM   technical_attrib_text_tab
      WHERE  technical_class = technical_class_
     AND    attribute = attribute_;
BEGIN
   Log_SYS.Stack_Trace_(Log_SYS.info_, 'Technical_Attrib_Text_API.Validate_Text');
   IF (NOT Check_Exist___(technical_class_, attribute_, value_text_)) THEN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%FOUND) THEN
         CLOSE exist_control;
         Error_SYS.Record_Not_Exist(lu_name_, 'NOTECHNICALATTRBTEXT: Text :P1 for :P2 does not exist', value_text_, attribute_);
      END IF;
      CLOSE exist_control;
   END IF;
END Validate_Text;
   

