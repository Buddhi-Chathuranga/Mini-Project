-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalAttribStd
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960617  JoRo  Created
--  960911  PeSe  Replaced missing views, added .. after &VIEWNUMERIC
--  970219  frtv  Upgraded.
--  001026  LEIV  Added new public method New
--  001029  LEIV  Added new public method Check_Exist
--  010104  INRO  Removed UpperCase for Attrib.Description.
--  010612  Larelk Added General_SYS.Init_Method in  New ,Check_Exist. Remove
--                 last parameter(true) from General_SYS.Init_Method in Exist_Attribute_. 
--  040301  ThAblk Removed substr from views.
--  061030  RaRulk Modified the Unpack_Check_Insert___ and Unpack_Check_Update__ Bug ID 61417
--  070116  NiWiLK Modified Get_Record__(Bug #62569).
--  --------------------------Eagle------------------------------------------
--  100422  Ajpelk Merge rose method documentation
--  120711  INMALK Bug 104012, Added a new get public method for retrieving Attribute Type
--  130918  chanlk Corrected model errors
--  --------------------------- APPS 9 --------------------------------------
--  131127  NuKuLK  Hooks: Refactored and splitted code.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr( 'ATTRIB_TYPE', TECHNICAL_ATTRIB_TYPE_API.DECODE('1'), attr_ );
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Exist_Attribute_
--   Check if the attribute registered exists
--   and is of the right attribute type.
PROCEDURE Exist_Attribute_ (
   attribute_ IN VARCHAR2,
   from_lu_   IN VARCHAR2 )
IS
   dummy_       NUMBER;
   attrib_type_ VARCHAR2(20);
   CURSOR check_type IS
      SELECT 1
      FROM TECHNICAL_ATTRIB_STD
      WHERE attrib_type = attrib_type_
      AND   attribute   = attribute_;
BEGIN
   IF from_lu_ = 'TechnicalAttribNumeric' THEN
      attrib_type_ := Technical_Attrib_Type_API.Decode('1');
   ELSE
      attrib_type_ := Technical_Attrib_Type_API.Decode('2');
   END IF;
   OPEN check_type;
   FETCH check_type INTO dummy_;
   IF NOT (check_type%FOUND) THEN
      CLOSE check_type;
      Error_SYS.Record_Not_Exist(from_lu_);
   END IF;
   CLOSE check_type;
END Exist_Attribute_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Attrib_Type (
   attribute_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ TECHNICAL_ATTRIB_STD.attrib_type_db%TYPE;
   CURSOR get_attr IS
      SELECT attrib_type_db
      FROM TECHNICAL_ATTRIB_STD
      WHERE attribute = attribute_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Attrib_Type;


-- New
--   Public method that wraps around std New__-method
PROCEDURE New (
   attribute_ IN VARCHAR2,
   attr_ IN VARCHAR2 )
IS
  info_ VARCHAR2(2000);
  objid_ VARCHAR2(260);
  objversion_ VARCHAR2(260);
  attr_new_ VARCHAR2(2000);
BEGIN
  New__(info_,objid_,objversion_,attr_new_,'PREPARE');
  CLIENT_SYS.Add_To_Attr('ATTRIBUTE',attribute_,attr_new_);
  attr_new_ := attr_new_ || attr_;
  New__(info_,objid_,objversion_,attr_new_,'DO');
END New;


-- Check_Exist
--   Public std exist-check that returns 'TRUE' or 'FALSE'
FUNCTION Check_Exist (
   attribute_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Check_Exist___(attribute_) THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Check_Exist;



