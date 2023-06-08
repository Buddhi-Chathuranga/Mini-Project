-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalAttribNumeric
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  960617  JoRo    Created
--  961205  JoRo    Removed commit in method Copy_Technical_Attributes_ and
--                  Copy_Attrib_To_Criteria_. Added DbTransaction... in client instead
--  970219  frtv    Upgraded.
--  970306  frtv    Added call to TECHNICAL_SPEC_NUMERIC_API.Refresh_Order
--  001216  MDAHSE  Moved view definition from this file to tattnum.api
--  010612 Larelk   Bug 22173, Added General_SYS.Init_Method in Search_Numeric__ 
--
--  020517 LeSvse   Bug 27675, Added attrib_number to cursor Get_Attrib in method Copy_Attrib_To_Criteria_
--  020917 ChBalk   Merged the IceAge code with TakeOff code.
--  030425 NaSalk   Added public function Get_Technical_Unit to be used from
--                  PDMCON component.
--  061030  RaRulk  Modified the Unpack_Check_Insert___ and Unpack_Check_Update__ Bug ID 61417
--  070115  NiWiLK  Modified Get_Record___(Bug#62569).
--  --------------------------Eagle--------------------------------------------
--  100422  Ajpelk  Merge rose method documentatio
--  -------------------------- APPS 9 ---------------------------------------
--  131127  paskno  Hooks: refactoring and splitting.
--  131202  paskno  PBSA-2930.
------------------------------ Strike ---------------------------------------
--  291123  sadelk  STRSA-15763, Edited Copy_Technical_Attributes_ to copy values, info and prefixs
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
   Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', 1, attr_ );
   Client_SYS.Add_To_Attr( 'SUMMARY', Technical_Attrib_Summary_API.DECODE('1'), attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     TECHNICAL_ATTRIB_TAB%ROWTYPE,
   newrec_     IN OUT TECHNICAL_ATTRIB_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (oldrec_.attrib_number != newrec_.attrib_number) THEN
      TECHNICAL_SPEC_NUMERIC_API.Refresh_Order(
         newrec_.technical_class,
         newrec_.attribute,
         newrec_.attrib_number);
   END IF;
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT technical_attrib_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'UNIT', newrec_.unit);
   -- check if the registered attribute is of right type (numeric/alphanumeric)
   Technical_Attrib_Std_API.Exist_Attribute_(newrec_.attribute, 'TechnicalAttribNumeric');
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     technical_attrib_tab%ROWTYPE,
   newrec_ IN OUT technical_attrib_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Error_SYS.Check_Not_Null(lu_name_, 'UNIT', newrec_.unit);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Search_Numeric__ (
   technical_class_ IN VARCHAR2,
   attribute_       IN VARCHAR2 )
IS
BEGIN
   NULL;
END Search_Numeric__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Copy_Technical_Attributes_ (
   from_technical_class_ IN VARCHAR2,
   to_technical_class_   IN VARCHAR2 )
IS
   CURSOR Get_Non_Existing_Attrib IS
      SELECT t1.attribute, t1.attrib_number, t1.unit,t1.info, t1.summary_prefix
      FROM TECHNICAL_ATTRIB_NUMERIC t1
      WHERE t1.technical_class = from_technical_class_
      AND NOT EXISTS (
         SELECT 'x'
         FROM technical_attrib_tab t2
         WHERE t2.attribute = t1.attribute
         AND   t2.technical_class = to_technical_class_);
   
   CURSOR Get_Existing_Attrib IS
      SELECT t3.attribute, t3.info from_info, t3.summary_prefix from_prefix, t4.info to_info, t4.summary_prefix to_prefix
      FROM TECHNICAL_ATTRIB_NUMERIC t3
      INNER JOIN TECHNICAL_ATTRIB_NUMERIC t4
         ON t4.attribute = t3.attribute
         AND  t4.technical_class = to_technical_class_
         AND t3.technical_class = from_technical_class_;

   info_          VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   objversion_    VARCHAR2(26000);
   objid_         VARCHAR2(50);
BEGIN
   FOR attributes IN Get_Non_Existing_Attrib LOOP
      -- Insert into Technical_Spec_Numeric and update values
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', to_technical_class_, attr_ );
      Client_SYS.Add_To_Attr( 'ATTRIBUTE', attributes.attribute, attr_ );
      Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', attributes.attrib_number, attr_ );
      Client_SYS.Add_To_Attr( 'UNIT', attributes.unit, attr_ );
      Client_SYS.Add_To_Attr( 'INFO', attributes.info, attr_ );
      Client_SYS.Add_To_Attr( 'SUMMARY_PREFIX', attributes.summary_prefix, attr_ );
      New__ (info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
   FOR existing_attributes IN Get_Existing_Attrib LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, to_technical_class_, existing_attributes.attribute);
      Modify__ (info_, objid_, objversion_, attr_, 'CHECK');
      IF (existing_attributes.to_info IS NULL) THEN
         Client_SYS.Add_To_Attr( 'INFO', existing_attributes.from_info, attr_ );
      END IF;
      IF (existing_attributes.to_prefix IS NULL) THEN
         Client_SYS.Add_To_Attr( 'SUMMARY_PREFIX', existing_attributes.from_prefix, attr_ );
      END IF;
      Modify__ (info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Copy_Technical_Attributes_;


PROCEDURE Copy_Attrib_To_Criteria_ (
   technical_class_     IN VARCHAR2,
   technical_search_no_ IN NUMBER )
IS
   CURSOR Get_Attrib IS
      SELECT attribute, attrib_number  
      FROM TECHNICAL_ATTRIB_NUMERIC
      WHERE technical_class = technical_class_;
   info_          VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   objversion_    VARCHAR2(26000);
   objid_         VARCHAR2(50);
BEGIN
   FOR attributes IN Get_Attrib LOOP
      -- Insert into Technical_Search_Criteria
      Technical_Search_Criteria_API.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      Client_SYS.Add_To_Attr( 'TECHNICAL_SEARCH_NO', technical_search_no_, attr_ );
      Client_SYS.Add_To_Attr( 'SEARCH_TYPE', '2', attr_ );
      Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', technical_class_, attr_ );
      Client_SYS.Add_To_Attr( 'ATTRIBUTE', attributes.attribute, attr_ );
      Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', attributes.attrib_number, attr_ );
      Technical_Search_Criteria_API.New__ (info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Copy_Attrib_To_Criteria_;


-- Get_Technical_Unit_
--   Returns the unit for a given technical class and attribute
@UncheckedAccess
FUNCTION Get_Technical_Unit_ (
   technical_class_ IN VARCHAR2,
   attribute_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_unit IS
      SELECT unit
      FROM TECHNICAL_ATTRIB_TAB
      WHERE technical_class = technical_class_
      AND   attribute       = attribute_;
   unit_ VARCHAR2(10);
BEGIN
   OPEN get_unit;
   FETCH get_unit INTO unit_;
   CLOSE get_unit;
   RETURN unit_;
END Get_Technical_Unit_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Technical_Unit
--   This public method Returns the unit for a given technical class
--   and attribute.
@UncheckedAccess
FUNCTION Get_Technical_Unit (
   technical_class_ IN VARCHAR2,
   attribute_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Technical_Unit_( technical_class_,attribute_ );     
END Get_Technical_Unit;



