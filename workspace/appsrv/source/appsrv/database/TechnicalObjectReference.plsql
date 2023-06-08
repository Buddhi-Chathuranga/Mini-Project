-----------------------------------------------------------------------------
--
--  Logical unit: TechnicalObjectReference
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  9606xx  JoRo  Created
--  960629  JoRo  Inserted and updated methods
--  960825  JoRo  Added methods Get_Logical_Unit_Description,
--                Get_Instance_Description, Separate_Key_Value__
--  960828  JoRo  Added 3 new columns (ok_yes_no, ok_sign, ok_dt) in view and
--                their default values in Prepare_Insert__
--  960908  JoRo  Removed parameter value_calc_ and added unit conversion in
--                method Get_Tech_Attribute_
--  960910  JoRo  Corrected error in Get_Tech_Attribute
--  960911  JoRo  Modified Approved_, returns 'TRUE' if reference doesn't exist
--                Added column unit in Copy_Attributes_. Added method Copy.
--                Added Exist_Reference_ in method Copy
--  960918  JoRo  Added method Change_Reference_Status
--  960920  JoRo  Added missing %FOUND check in Delete_Reference
--  960924  JoRo  Added commit in Delete_Reference
--  961205  JoRo  Removed commit in method Create_Reference_, Copy_Attributes_ and
--                Delete_Reference. Added DbTransaction... in client instead
--  970219  frtv  Upgraded.
--  970225  JoRo  Added code for copying and deleting technical specifications
--                when changing technical class ( in Unpack_Check_Insert/Update).
--                Added test for stopping user from changing tech_class if approved.
--  970311  frtv  Removed Get_keys...
--  970311  JoRo  Removed increment of spec_no in Create_Reference_. Added
--                Get_Technical_Spec_No instead. Added dummy number for 'TECHNICAL_SPEC_NO'
--                in Unpack_Check_Insert___ to avoid invalid value format exception.
--  970314  PeSe  Removed "double" copying of technical specifications
--  970314  frtv  Added Check_Approved...
--  970524  frtv  Debugged and improved Get_Instance_Description +
--                cache lu_name in object_connection_sys_tab in insert___...
--  980115  JaPa  Changed type of the first parameter to Get_Defined_Count()
--                to NUMBER.
--  980320  JaPa  Added support for both key_ref and key_value. New functions
--                Is_Key_Ref___(), Retrive_Both_Keys___() and Get_Key_Ref().
--
--  010612  Larelk Bug 22173,Added General_SYS.Init_Method in  Get_Tech_Attribute_,
--                 Remove last parameter(true) from  General_SYS.Init_Method in Exist_Spec_No__
--  030425  Larelk Bug 35634  corrected in CREATE_REFERENCE
--  030916  Larelk Bug 37176  Removed Client_SYS.Add_To_Attr( 'KEY_VALUE', kval_, attr_ ); from
--                 PROCEDURE Create_Reference_  due to key_value is an old format and unpack_check_insert___
--                 the key_ref will be converted to key_value .corrected PROCEDURE Copy_Values.--
--  031016  NaSalk Merged bug 37176.
--  040301  ThAblk Removed substr from views.
--  040513  MAKULK Changed 'OK_SIGN' assigned value from user to Fnd_Session_API.Get_Fnd_User()
--                 in Change_Reference_Status_ procedure.
--  050120  IsWilk Added the parameters ands modified the PROCEDURE Copy.
--  050121  IsWilk Modified the added parameters in PROCEDURE Copy.
--  050207  IsWilk Modified the PROCEDURE Copy to change the condition.
--  070716  AsWiLk Added OK_YES_NO_DB to Unpack_Check_Insert__ and Unpack_Check_Update__ (Bug#66698).
--  070906  AsWiLk This file need to be regenerated with the new template. Till then added a encode in Modufy__ (Bug#67656).
--  080125  AsWiLk Changed Copy method to consider error_when_no_source_ and error_when_existing_copy_ correctly (Bug#67170).
--  080724  UsRaLK Changed method Get_Instance_Description to use Object_Connection_SYS.Get_Connection_Description (Bug#65869).
--  081208  ChAlLK Added method Copy_Attributes_To_All_Specs_ (Bug#75106).
--  120326  SHAFLK Bug 101845, Modified Copy().
--  --------------------------Eagle------------------------------------------
--  100813  ChAlLK Changed data type of technical_spec_no_ to NUMBER from VARCHAR2(10) inside  Get_Technical_Spec_No (Bug#92422).
--  100422  Ajpelk Merge rose method documentation
--  110517  Nifrse Added a new view TECHNICAL_OBJ_REF_EXT_DETAILS for Middle_tier (lu-wrapper)
--  110607  INMALK Bug Id 97415, Included the copying of value in INFO column when technical specs are created within Copy_Attributes_
--  120130  THTHLK SPJ-1494: added new PROCEDURE Create_Reference, PROCEDURE Change_Reference_Status, FUNCTION Get_Status
--  120621  INMALK Bug 103581, Modified Copy_Values method 
--  120706  INMALK Bug 103830, Added a new procedure Copy_Values to handle copying values within the same LU and called this in Copy metho
--  -------------------------- APPS 9 ---------------------------------------
--  131128  paskno  Hooks: refactoring and splitting.
--  150715  INMALK Bug 123623, Modified Check_Update___() to consider correct values for validations
--  -------------------------- APPS 10 --------------------------------------
--  160330  NuKuLK Added new methods Copy() and Move().
--  170912  chanlk Bug 137734, Modified Get_Instance_Description.
--  190617  SSILLK Bug ID 144019, Added Get_Object_Description() and Get_Object_Keys().
--  191001  Tajalk SAXTEND-208, Added method Get_Object_Connection_Count (Uxx atachment panel)
--  191104  Rakuse Removed method Get_Object_Connection_Count. (TEAURENAFW-960)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

text_separator_  CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;

field_separator_ CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Is_Key_Ref___ (
   key_value_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF nvl(instr(key_value_,'='),0) > 0 THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Key_Ref___;


PROCEDURE Retrive_Both_Keys___ (
   key_value_ OUT VARCHAR2,
   key_ref_   OUT VARCHAR2,
   lu_name_   IN  VARCHAR2,
   keys_      IN  VARCHAR2 )
IS
BEGIN
   Trace_SYS.message('TECHNICAL_OBJECT_REFERENCE_API.Retrive_Both_Keys___('||lu_name_||','||keys_||')');
   IF Is_Key_Ref___(keys_) THEN
      key_ref_   := keys_;
      key_value_ := Object_Connection_SYS.Convert_To_Key_Value(lu_name_, keys_);
   ELSE
      key_value_ := keys_;
      key_ref_   := Object_Connection_SYS.Convert_To_Key_Reference(lu_name_, keys_);
   END IF;
END Retrive_Both_Keys___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('OK_YES_NO',Technical_Obj_Ref_Approved_API.DECODE('1'), attr_ );
   Client_SYS.Add_To_Attr('OK_SIGN', Fnd_Session_API.Get_Fnd_User(), attr_ );
   Client_SYS.Add_To_Attr('DT_OK', sysdate, attr_ );
         -- Dummy number to avoid invalid value format in Unpack_Check_Insert___
   Client_SYS.Add_To_Attr('TECHNICAL_SPEC_NO', 0, attr_ );
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR spec_no IS
      SELECT Technical_Spec_No_Seq.NEXTVAL
      FROM DUAL;
BEGIN
   Trace_SYS.message('TECHNICAL_OBJECT_REFERENCE_API.Insert___('||attr_||')');
   -- added key_ref
   -- Fetch new sequence value into newrec_.technical_spec_no
   OPEN spec_no;
   FETCH spec_no INTO newrec_.technical_spec_no;
   CLOSE spec_no;
   -- Add to attr_ to be able to automatically display it in the client
   Trace_SYS.field('. newrec_.technical_spec_no', newrec_.technical_spec_no);
   Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', newrec_.technical_spec_no, attr_ );
   super(objid_, objversion_, newrec_, attr_);
   -- Must copy attributes from technical_attrib to technical_specification
   -- in order to be able to register attribute values in specification
   Trace_SYS.message('. record created.');
   Copy_Attributes_( newrec_.technical_spec_no, newrec_.technical_class );
   Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.technical_spec_no);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE,
   newrec_     IN OUT TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF ( oldrec_.technical_class != newrec_.technical_class ) THEN
      -- Must delete the old specifications in order to insert the new ones
      Technical_Specification_API.Delete_Specifications( newrec_.technical_spec_no );
      -- Must copy attributes from technical_attrib to technical_specification
      -- in order to be able to register attribute values in specification
      Copy_Attributes_( newrec_.technical_spec_no, newrec_.technical_class );
   END IF;
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE )
IS
   total_count_ NUMBER;
BEGIN
   -- Not allowed to delete if the specification is approved.
   IF (remrec_.ok_yes_no = Technical_Obj_Ref_Approved_API.Get_Db_Value(0)) THEN
      Error_SYS.Record_General( 'TechnicalObjectReference', 'NOREMOVEWHENAPPROVED: Not allowed to remove technical class when the specification is approved');
   END IF;
   -- check if any attributes have a value assigned...
   total_count_ := Get_Defined_Count(remrec_.technical_spec_no,
      remrec_.technical_class);
   IF (total_count_ > 0) THEN
      Error_SYS.Record_General( 'TechnicalObjectReference', 'NOREMOVEWHENDEF: Not allowed to remove technical class when attributes have values.');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT technical_object_reference_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   key_ref_   technical_object_reference_tab.key_ref%TYPE;
   key_value_ technical_object_reference_tab.key_value%TYPE;
BEGIN
   IF (indrec_.key_ref = TRUE) THEN
      Retrive_Both_Keys___(key_value_, key_ref_, newrec_.lu_name, newrec_.key_ref);
      newrec_.key_value := key_value_;
      newrec_.key_ref := key_ref_;     
   END IF;
   IF (indrec_.key_value = TRUE) THEN
      Retrive_Both_Keys___(key_value_, key_ref_, newrec_.lu_name, newrec_.key_value);
      newrec_.key_value := key_value_;
      newrec_.key_ref := key_ref_;           
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     technical_object_reference_tab%ROWTYPE,
   newrec_ IN OUT technical_object_reference_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   total_count_ NUMBER;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (indrec_.technical_class) THEN
      -- The technical class was modified, must check that the specification wasn't approved.
      IF newrec_.ok_yes_no = Technical_Obj_Ref_Approved_API.Get_Db_Value( 0 ) THEN
         Error_SYS.Record_General( 'TechnicalObjectReference', 'NOUPDATEWHENAPPROVED: Not allowed to update technical class when the specification is approved');
      END IF;
      -- check if any attributes have a value assigned...
      total_count_ := Get_Defined_Count(oldrec_.technical_spec_no, oldrec_.technical_class);
      IF (total_count_ > 0) THEN
         Error_SYS.Record_General( 'TechnicalObjectReference', 'NOUPDATEWHENDEF: Not allowed to update technical class when attributes have values.');
      END IF;
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Exist_Spec_No__
--   Check if there exists an entry in the view
--   for the given technical specification number.
--   Creates error message if it doesn't exist.
PROCEDURE Exist_Spec_No__ (
   technical_spec_no_ IN NUMBER )
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  technical_spec_no = technical_spec_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF NOT (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_Not_Exist(lu_name_);
   END IF;
   CLOSE exist_control;
END Exist_Spec_No__;

-- Purpose: When the technical object reference is changed, do something for the calling LU
-- 1. Plant Object: Add a history record when the Technical Class is Approved.
PROCEDURE Acknowledge_Object___ (
   technical_spec_no_   IN NUMBER,
   old_value_           IN VARCHAR2,
   new_value_           IN VARCHAR2 )
IS
   tech_obj_ref_rec_    Technical_Object_Reference_API.Public_Rec;
BEGIN
   tech_obj_ref_rec_ := Technical_Object_Reference_API.Get(technical_spec_no_);

   $IF Component_Plades_SYS.INSTALLED $THEN
      IF (tech_obj_ref_rec_.lu_name = 'PlantObject') THEN
         Plant_Object_API.Create_Object_History(Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'PLT_SQ'),
                                                Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'OBJECT_SQ'),
                                                Client_SYS.Get_Key_Reference_Value(tech_obj_ref_rec_.key_ref, 'OBJECT_REVISION'),
                                                old_value_, new_value_ );
      END IF;
   $END
END Acknowledge_Object___;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Exist_Reference_
--   Check if there exists a reference for the given logical unit and key.
--   If there exists you'll get the technical specification number in return,
--   if not -1 is returned
@UncheckedAccess
FUNCTION Exist_Reference_ (
   lu_name_   IN VARCHAR2,
   key_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- accepts both key_value and key_ref
   technical_spec_no_ NUMBER;
   CURSOR exist_keyval IS
      SELECT technical_spec_no
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name = lu_name_
      AND    key_value = key_value_;
   CURSOR exist_keyref IS
      SELECT technical_spec_no
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name = lu_name_
      AND    key_ref = key_value_;
BEGIN
   IF Is_Key_Ref___(key_value_) THEN
      OPEN exist_keyref;
      FETCH exist_keyref INTO technical_spec_no_;
      IF (exist_keyref%FOUND) THEN
         CLOSE exist_keyref;
         RETURN to_char(technical_spec_no_);
      END IF;
      CLOSE exist_keyref;
   ELSE
      OPEN exist_keyval;
      FETCH exist_keyval INTO technical_spec_no_;
      IF (exist_keyval%FOUND) THEN
         CLOSE exist_keyval;
         RETURN to_char(technical_spec_no_);
      END IF;
      CLOSE exist_keyval;
   END IF;
   RETURN('-1');
END Exist_Reference_;


-- Create_Reference_
--   Creates a technical reference in TECHNICAL_OBJECT_REFERENCE for
--   the given logical unit, key and technical class.
--   The technical specification number is returned as the 1'st parameter.
PROCEDURE Create_Reference_ (
   technical_spec_no_ IN OUT NUMBER,
   lu_name_           IN     VARCHAR2,
   key_value_         IN     VARCHAR2,
   technical_class_   IN     VARCHAR2 )
IS
   info_              VARCHAR2(2000);
   attr_              VARCHAR2(32000);
   objversion_        VARCHAR2(26000);
   objid_             VARCHAR2(50);
   kval_              VARCHAR2(2000);
   kref_              VARCHAR2(2000);
BEGIN
   -- accepts both key_value and key_ref
   Trace_SYS.message('TECHNICAL_OBJECT_REFERENCE_API.Create_Reference_('||lu_name_||','||key_value_||','||technical_class_||')');

   New__ (info_, objid_, objversion_, attr_, 'PREPARE');
   Client_SYS.Add_To_Attr( 'LU_NAME', lu_name_, attr_ );

   Retrive_Both_Keys___(kval_, kref_, lu_name_, key_value_);
   Client_SYS.Add_To_Attr( 'KEY_REF', kref_, attr_ );
   Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', technical_class_, attr_ );
   Trace_SYS.field('. attr_[1]', attr_);
   New__ (info_, objid_, objversion_, attr_, 'DO');
   Trace_SYS.field('. attr_[2]', attr_);
   -- Must retrieve the spec_no since it's value is set in Insert___
   technical_spec_no_ := Client_SYS.Get_Item_Value('TECHNICAL_SPEC_NO', attr_);
--   technical_spec_no_ := Get_Technical_Spec_No( lu_name_, key_value_ );
   Trace_SYS.field('. technical_spec_no_', technical_spec_no_);
END Create_Reference_;


-- Copy_Attributes_
--   Copy attributes from TechnicalAttribValue to TechnicalSpecification
PROCEDURE Copy_Attributes_ (
   technical_spec_no_ IN NUMBER,
   technical_class_   IN VARCHAR2 )
IS
   CURSOR Get_Attrib IS
      SELECT t1.attribute, t1.attrib_number, t1.info, t1.rowtype
      FROM technical_attrib_tab t1
      WHERE t1.technical_class = technical_class_
      AND NOT EXISTS (
         SELECT 'x'
         FROM technical_specification_tab t2
         WHERE t2.attribute = t1.attribute
         AND   t2.technical_class = t1.technical_class
         AND   t2.technical_spec_no = technical_spec_no_);
   info_          VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   objversion_    VARCHAR2(26000);
   objid_         VARCHAR2(50);
BEGIN
   Trace_SYS.message('TECHNICAL_OBJECT_REFERENCE_API.Copy_Attributes_('||technical_spec_no_||','||technical_class_||')');
   FOR attributes IN Get_Attrib LOOP
      Trace_SYS.field('. attributes.attribute',     attributes.attribute);
      Trace_SYS.field('. attributes.attrib_number', attributes.attrib_number);
      IF attributes.rowtype = 'TechnicalAttribAlphanum' THEN
       -- Insert into technical_spec_alphanum
         Technical_Spec_Alphanum_API.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
         Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', technical_spec_no_, attr_ );
         Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', technical_class_, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIBUTE', attributes.attribute, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', attributes.attrib_number, attr_ );
         Client_SYS.Add_To_Attr( 'INFO', attributes.info, attr_ );
         Technical_Spec_Alphanum_API.New__ (info_, objid_, objversion_, attr_, 'DO');
      ELSIF attributes.rowtype = 'TechnicalAttribNumeric' THEN
         -- Insert into technical_spec_numeric
         Technical_Spec_Numeric_API.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
         Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', technical_spec_no_, attr_ );
         Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', technical_class_, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIBUTE', attributes.attribute, attr_ );
         Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', attributes.attrib_number, attr_ );
         Client_SYS.Add_To_Attr( 'INFO', attributes.info, attr_ );
         Technical_Spec_Numeric_API.New__ (info_, objid_, objversion_, attr_, 'DO');
      END IF;
   END LOOP;
END Copy_Attributes_;


PROCEDURE Copy_Attributes_To_All_Specs_(
   technical_class_ IN VARCHAR2)

IS

   CURSOR GetSpecNo IS
      SELECT DISTINCT t.technical_spec_no
      from technical_specification_tab t
      where t.technical_class = technical_class_ ;

   CURSOR Get_Attrib (technical_spec_no_ NUMBER) IS
      SELECT t1.attribute, t1.attrib_number, t1.rowtype
      FROM technical_attrib_tab t1
      WHERE t1.technical_class = technical_class_
      AND NOT EXISTS (
         SELECT 'x'
         FROM technical_specification_tab t2
         WHERE t2.attribute = t1.attribute
         AND   t2.technical_class = t1.technical_class
         AND   t2.technical_spec_no = technical_spec_no_);

   info_          VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   objversion_    VARCHAR2(26000);
   objid_         VARCHAR2(50);
    
BEGIN
   FOR rec_ IN GetSpecNo LOOP
      FOR attrib_ IN Get_Attrib(rec_.technical_spec_no) LOOP
         IF attrib_.rowtype = 'TechnicalAttribAlphanum' THEN
            -- Insert into technical_spec_alphanum
            Technical_Spec_Alphanum_API.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
            Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', rec_.technical_spec_no, attr_ );
            Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', technical_class_, attr_ );
            Client_SYS.Add_To_Attr( 'ATTRIBUTE', attrib_.attribute, attr_ );
            Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', attrib_.attrib_number, attr_ );
            Technical_Spec_Alphanum_API.New__ (info_, objid_, objversion_, attr_, 'DO');
         ELSIF attrib_.rowtype = 'TechnicalAttribNumeric' THEN
            -- Insert into technical_spec_numeric
            Technical_Spec_Numeric_API.New__ (info_, objid_, objversion_, attr_, 'PREPARE');
            Client_SYS.Add_To_Attr( 'TECHNICAL_SPEC_NO', rec_.technical_spec_no, attr_ );
            Client_SYS.Add_To_Attr( 'TECHNICAL_CLASS', technical_class_, attr_ );
            Client_SYS.Add_To_Attr( 'ATTRIBUTE', attrib_.attribute, attr_ );
            Client_SYS.Add_To_Attr( 'ATTRIB_NUMBER', attrib_.attrib_number, attr_ );
            Technical_Spec_Numeric_API.New__ (info_, objid_, objversion_, attr_, 'DO');
         END IF;
      END LOOP;
   END LOOP;
END Copy_Attributes_To_All_Specs_;


-- Approved_
--   Returns 'TRUE' if that specific technical object reference is approved,
--   'FALSE' otherwise
@UncheckedAccess
FUNCTION Approved_ (
   lu_name_   IN VARCHAR2,
   key_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- accepts both key_value and key_ref
   CURSOR approved_val IS
      SELECT ok_yes_no
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name   = lu_name_
      AND    key_value = key_value_;

   rec_ approved_val%ROWTYPE;

   CURSOR approved_ref RETURN approved_val%ROWTYPE IS
      SELECT ok_yes_no
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name = lu_name_
      AND    key_ref = key_value_;
BEGIN
   IF Is_Key_Ref___(key_value_) THEN
      OPEN approved_ref;
      FETCH approved_ref INTO rec_;
      IF (approved_ref%NOTFOUND) THEN
         CLOSE approved_ref;
         RETURN 'TRUE';
      END IF;
      CLOSE approved_ref;
   ELSE
      OPEN approved_val;
      FETCH approved_val INTO rec_;
      IF (approved_val%NOTFOUND) THEN
         CLOSE approved_val;
         RETURN 'TRUE';
      END IF;
      CLOSE approved_val;
   END IF;
   IF rec_.ok_yes_no = Technical_Obj_Ref_Approved_API.Decode('2') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Approved_;


-- Set_Tech_Attribute_
--   Get a technical attribute's calculated value
PROCEDURE Set_Tech_Attribute_ (
   objid_          IN VARCHAR2,
   objversion_     IN OUT VARCHAR2,
   new_value_calc_ IN NUMBER )
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
BEGIN
   Technical_Spec_Numeric_API.Modify__ (info_, objid_, objversion_, attr_, 'PREPARE');
   Client_SYS.Add_To_Attr( 'VALUE_CALC', new_value_calc_, attr_ );
   Technical_Spec_Numeric_API.Modify__ (info_, objid_, objversion_, attr_, 'DO');
END Set_Tech_Attribute_;


-- Get_Tech_Attribute_
--   Set the new calculated value for a given objid,
PROCEDURE Get_Tech_Attribute_ (
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   value_no_   OUT NUMBER,
   lu_name_    IN  VARCHAR2,
   key_value_  IN  VARCHAR2,
   attribute_  IN  VARCHAR2,
   calc_unit_  IN  VARCHAR2 )
IS
   -- accepts both key_value and key_ref
   unit_ VARCHAR2(10);
   conv_factor_ NUMBER;
   value_ NUMBER;
   technical_class_ VARCHAR2(10);

   CURSOR get_object_attr_val IS
      SELECT s.objid, s.objversion, s.value_no, o.technical_class
      FROM technical_spec_numeric s, TECHNICAL_OBJECT_REFERENCE o
      WHERE s.technical_spec_no = o.technical_spec_no
      AND   o.lu_name           = lu_name_
      AND   o.key_value         = key_value_
      AND   s.attribute         = attribute_;
   CURSOR get_object_attr_ref IS
      SELECT s.objid, s.objversion, s.value_no, o.technical_class
      FROM technical_spec_numeric s, TECHNICAL_OBJECT_REFERENCE o
      WHERE s.technical_spec_no = o.technical_spec_no
      AND   o.lu_name           = lu_name_
      AND   o.key_ref           = key_value_
      AND   s.attribute         = attribute_;
BEGIN
   IF Is_Key_Ref___(key_value_) THEN
      OPEN get_object_attr_ref;
      FETCH get_object_attr_ref INTO objid_, objversion_, value_, technical_class_;
      CLOSE get_object_attr_ref;
   ELSE
      OPEN get_object_attr_val;
      FETCH get_object_attr_val INTO objid_, objversion_, value_, technical_class_;
      CLOSE get_object_attr_val;
   END IF;
-- Check if value has to be converted
   unit_ := Technical_Attrib_Numeric_API.Get_Technical_Unit_( technical_class_, attribute_ );
   IF (unit_ != calc_unit_) THEN
--    Check if unit conversion exists ( provides error message if not )
      Technical_Unit_Conv_API.Exist( unit_, calc_unit_ );
--    Get the conversion factor and convert value_no to the right unit
      conv_factor_ := Technical_Unit_Conv_API.Get_Conv_Factor(unit_, calc_unit_ );
      value_no_    := value_ * nvl(conv_factor_,1);
   ELSE
      value_no_ := value_;
   END IF;
END Get_Tech_Attribute_;


-- Change_Reference_Status_
--   Approve/Not approve the technical specification for a given
--   technical spec no. A technical specification must be approved to be used.
PROCEDURE Change_Reference_Status_ (
   technical_spec_no_ IN NUMBER )
IS
   rec_  TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE;
   info_ VARCHAR2(2000);
   attr_ VARCHAR2(32000);
   objversion_    VARCHAR2(26000);
   objid_         VARCHAR2(50);
   changed_val_   VARCHAR2(2);
BEGIN
   rec_ := Get_Object_By_Keys___( technical_spec_no_ );
   Get_Id_Version_By_Keys___(objid_, objversion_, rec_.technical_spec_no);
   Modify__ (info_, objid_, objversion_, attr_, 'PREPARE');
   changed_val_ := rec_.ok_yes_no;
   IF rec_.ok_yes_no = '1' THEN
      Client_SYS.Add_To_Attr('OK_YES_NO', Technical_Obj_Ref_Approved_API.Decode('2'), attr_ );
   ELSE
      Client_SYS.Add_To_Attr('OK_YES_NO', Technical_Obj_Ref_Approved_API.Decode('1'), attr_ );
   END IF;
   Client_SYS.Add_To_Attr('OK_SIGN', Fnd_Session_API.Get_Fnd_User(), attr_ );
   Client_SYS.Add_To_Attr('DT_OK', sysdate, attr_ );
   Modify__ (info_, objid_, objversion_, attr_, 'DO');

   IF (changed_val_ = '1') THEN
      Acknowledge_Object___(technical_spec_no_, '1', '2');
   ELSE
      Acknowledge_Object___(technical_spec_no_, '2', '1');
   END IF;
END Change_Reference_Status_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Reference (
   technical_spec_no_ IN OUT NUMBER,
   lu_name_           IN     VARCHAR2,
   key_value_         IN     VARCHAR2,
   technical_class_   IN     VARCHAR2 )
IS
BEGIN

   Create_Reference_(technical_spec_no_, lu_name_, key_value_, technical_class_);
END Create_Reference;


PROCEDURE Change_Reference_Status (
   technical_spec_no_ IN NUMBER )
IS
BEGIN

   Change_Reference_Status_(technical_spec_no_);
END Change_Reference_Status;


-- Delete_Reference
--   Deletes all information stored about the technical object reference.
--   The CASCADE option in TECHNICAL_SPECIFICATION_API makes sure that
--   related records in it's table is deleted as well.
PROCEDURE Delete_Reference (
   lu_name_   IN VARCHAR2,
   key_value_ IN VARCHAR2 )
IS
   -- accepts both key_value and key_ref
   objversion_ VARCHAR2(26000);
   objid_      VARCHAR2(50);
   found_      BOOLEAN;
   remrec_     TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE;
   CURSOR get_object_val IS
      SELECT *
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name   = lu_name_
      AND   key_value = key_value_;
   CURSOR get_object_ref IS
      SELECT *
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_
      AND   key_ref = key_value_;
BEGIN
   IF Is_Key_Ref___(key_value_) THEN
      OPEN get_object_ref;
      FETCH get_object_ref INTO remrec_;
      found_ := get_object_ref%FOUND;
      CLOSE get_object_ref;
   ELSE
      OPEN get_object_val;
      FETCH get_object_val INTO remrec_;
      found_ := get_object_val%FOUND;
      CLOSE get_object_val;
   END IF;
   IF found_ THEN
      TECHNICAL_SPEC_NUMERIC_API.Delete_Specifications (remrec_.technical_spec_no);
      TECHNICAL_SPEC_ALPHANUM_API.Delete_Specifications (remrec_.technical_spec_no);
      Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.technical_spec_no);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Delete___(objid_, remrec_);
   END IF;
END Delete_Reference;


@UncheckedAccess
FUNCTION Get_Defined_Count (
   technical_spec_no_ IN NUMBER,
   technical_class_   IN VARCHAR2 ) RETURN NUMBER
IS
   alpha_count_ NUMBER;
   numer_count_ NUMBER;
   total_count_ NUMBER;
BEGIN
   alpha_count_ := Technical_Spec_Alphanum_API.Get_Defined_Count(technical_spec_no_, technical_class_);
   numer_count_ := Technical_Spec_Numeric_API.Get_Defined_Count(technical_spec_no_, technical_class_);
   total_count_ := alpha_count_ + numer_count_;
   RETURN total_count_ ;
END Get_Defined_Count;


-- Get_Object_Count
--   Return the number of objects for a given technical class
@UncheckedAccess
FUNCTION Get_Object_Count (
   technical_class_ IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_records_ NUMBER;
   CURSOR get_count IS
   SELECT COUNT(*)
   FROM TECHNICAL_OBJECT_REFERENCE
   WHERE technical_class = technical_class_;
BEGIN
   OPEN get_count;
   FETCH get_count INTO no_of_records_;
   CLOSE get_count;
   RETURN no_of_records_;
END Get_Object_Count;


-- Get_Technical_Class_With_Key
--   Returns the technical class for a given KeyValue and LuName
@UncheckedAccess
FUNCTION Get_Technical_Class_With_Key (
   lu_name_   IN VARCHAR2,
   key_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- accepts both key_value and key_ref
   technical_class_ VARCHAR2(10);
   CURSOR get_class_val IS
      SELECT technical_class
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name = lu_name_
      AND    key_value = key_value_;
   CURSOR get_class_ref IS
      SELECT technical_class
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name = lu_name_
      AND    key_ref = key_value_;
BEGIN
   IF Is_Key_Ref___(key_value_) THEN
      OPEN get_class_ref;
      FETCH get_class_ref INTO technical_class_;
      IF (get_class_ref%FOUND) THEN
         CLOSE get_class_ref;
         RETURN technical_class_;
      END IF;
      CLOSE get_class_ref;
   ELSE
      OPEN get_class_val;
      FETCH get_class_val INTO technical_class_;
      IF (get_class_val%FOUND) THEN
         CLOSE get_class_val;
         RETURN technical_class_;
      END IF;
      CLOSE get_class_val;
   END IF;
   RETURN('');
END Get_Technical_Class_With_Key;


-- Get_Technical_Spec_No
--   Get the technical spec no for a given lu_name and key_value
@UncheckedAccess
FUNCTION Get_Technical_Spec_No (
   lu_name_   IN VARCHAR2,
   key_value_ IN VARCHAR2 ) RETURN NUMBER
IS
   -- accepts both key_value and key_ref
   technical_spec_no_ NUMBER;
   CURSOR get_spec_no_val IS
      SELECT technical_spec_no
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name = lu_name_
      AND    key_value = key_value_;
   CURSOR get_spec_no_ref IS
      SELECT technical_spec_no
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  lu_name = lu_name_
      AND    key_ref = key_value_;
BEGIN
   IF Is_Key_Ref___(key_value_) THEN
      OPEN get_spec_no_ref;
      FETCH get_spec_no_ref INTO technical_spec_no_;
      IF (get_spec_no_ref%FOUND) THEN
         CLOSE get_spec_no_ref;
         RETURN technical_spec_no_;
      END IF;
      CLOSE get_spec_no_ref;
   ELSE
      OPEN get_spec_no_val;
      FETCH get_spec_no_val INTO technical_spec_no_;
      IF (get_spec_no_val%FOUND) THEN
         CLOSE get_spec_no_val;
         RETURN technical_spec_no_;
      END IF;
      CLOSE get_spec_no_val;
   END IF;
   RETURN(-1);
END Get_Technical_Spec_No;



-- This method will be obsoleted
-- So please use Get_Object_Description() to fetch Object Description
-- and Get_Object_Keys() to fetch keys with values
FUNCTION Get_Instance_Description (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   lu_name_       VARCHAR2(30);
   key_ref_       VARCHAR2(2000);
   description_   VARCHAR2(2000);
   new_           VARCHAR2 (4000);
   pair_          VARCHAR2 (4000);
      
   CURSOR get_obj_ref IS
      SELECT lu_name, key_ref
      FROM TECHNICAL_OBJECT_REFERENCE
      WHERE technical_spec_no = technical_spec_no_;
BEGIN
   OPEN  get_obj_ref;
   FETCH get_obj_ref INTO lu_name_, key_ref_;
   CLOSE get_obj_ref;

   -- Code added to change the description returned for Plant Design Objects
   -- as the current description returns a  key value which is not usable for end user.
   IF lu_name_ IN ('PlantObject',
                   'PlantCable',
                   'PlantConnectionPoint',
                   'PlantSignal',
                   'PlantCircuit',
                   'PlantArticle',
                   'PlantIoCard',
                   'PlantChannel') THEN
      Object_Connection_SYS.Get_Connection_Description(description_ ,lu_name_ ,key_ref_);
      RETURN (substr(description_, 1, 100));
   ELSE
      FOR i IN 1..20 LOOP
         pair_ := REGEXP_REPLACE (
            REGEXP_SUBSTR (key_ref_, '[^^]+', 1, i),           -- Substring one group with all the chars up to "^"
            '=', ':', 1, 1);                                   -- In the resulting group of chars, replace the first occurence of "=" with "; "
         EXIT WHEN pair_ IS NULL;                              -- No more pairs
         new_ := new_ || pair_ || '; ';                        -- Construct the instance description
      END LOOP;
      new_ := trim (new_);
      RETURN (substr(new_, 1, 100));
   END IF;
END Get_Instance_Description;

-- Return the Description for a given Technical Spec No.
@UncheckedAccess
FUNCTION Get_Object_Description(
   technical_spec_no_ IN NUMBER) RETURN VARCHAR2
IS
   lu_name_     VARCHAR2(30);
   key_ref_     VARCHAR2(2000);
   description_ VARCHAR2(2000);

   CURSOR get_obj_ref IS
      SELECT lu_name, key_ref
        FROM technical_object_reference
       WHERE technical_spec_no = technical_spec_no_;
BEGIN
   OPEN get_obj_ref;
   FETCH get_obj_ref INTO lu_name_, key_ref_;
   IF (get_obj_ref%FOUND) THEN
      Object_Connection_SYS.Get_Connection_Description(description_, lu_name_, key_ref_);
      CLOSE get_obj_ref;
      RETURN(substr(description_, 1, 100));
   END IF;
   CLOSE get_obj_ref;
   RETURN NULL;
END Get_Object_Description;

-- Return the Object Keys that shows the keys and values.
@UncheckedAccess
FUNCTION Get_Object_Keys(
   technical_spec_no_ IN NUMBER) RETURN VARCHAR2
IS
   lu_name_     VARCHAR2(30);
   key_ref_     VARCHAR2(2000);
   keys_         VARCHAR2(4000);
   pair_        VARCHAR2(4000);

   CURSOR get_obj_ref IS
      SELECT lu_name, key_ref
        FROM technical_object_reference
       WHERE technical_spec_no = technical_spec_no_;
BEGIN
   OPEN get_obj_ref;
   FETCH get_obj_ref INTO lu_name_, key_ref_;
   IF (get_obj_ref%FOUND) THEN
      FOR i IN 1..20 LOOP
         pair_ := REGEXP_REPLACE (
            REGEXP_SUBSTR (key_ref_, '[^^]+', 1, i),           -- Substring one group with all the chars up to "^"
            '=', ':', 1, 1);                                   -- In the resulting group of chars, replace the first occurence of "=" with "; "
         EXIT WHEN pair_ IS NULL;                              -- No more pairs
         keys_ := keys_ || pair_ || '; ';                        -- Construct the instance description
      END LOOP;
      keys_ := trim (keys_);
      RETURN (substr(keys_, 1, 100));
   END IF;
   CLOSE get_obj_ref;
   RETURN NULL;
END Get_Object_Keys;

-- Get_Logical_Unit_Description
--   Return the logical unit description for a given technical spec no
@UncheckedAccess
FUNCTION Get_Logical_Unit_Description (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   lu_name_ VARCHAR2(30);
   CURSOR get_lu_name IS
      SELECT lu_name
      FROM TECHNICAL_OBJECT_REFERENCE
      WHERE technical_spec_no = technical_spec_no_;
BEGIN
   OPEN get_lu_name;
   FETCH get_lu_name INTO lu_name_;
   CLOSE get_lu_name;
   RETURN(Language_SYS.Translate_Lu_Prompt_(lu_name_));
END Get_Logical_Unit_Description;


@UncheckedAccess
FUNCTION Check_Approved (
   technical_spec_no_ IN NUMBER ) RETURN BOOLEAN
IS
   ok_yes_no_ VARCHAR2(20);
   CURSOR approved_control IS
      SELECT ok_yes_no
      FROM   TECHNICAL_OBJECT_REFERENCE
      WHERE  technical_spec_no = technical_spec_no_;
BEGIN
   OPEN approved_control;
   FETCH approved_control INTO ok_yes_no_;
   IF (approved_control%FOUND) THEN
      IF (Technical_Obj_Ref_Approved_API.Encode(ok_yes_no_) = Technical_Obj_Ref_Approved_API.Get_Db_Value( 0 )) THEN
         CLOSE approved_control;
         RETURN(TRUE);
      END IF;
   END IF;
   CLOSE approved_control;
   RETURN(FALSE);
END Check_Approved;


-- Copy
--   Copy technical data from one object to another.
--   Only allowed to copy within the same LU and the destination
--   cannot have a technical class before copying.
PROCEDURE Copy (
   lu_name_                   IN VARCHAR2,
   key_value_from_            IN VARCHAR2,
   key_value_to_              IN VARCHAR2,
   error_when_no_source_      IN VARCHAR2 DEFAULT 'TRUE',
   error_when_existing_copy_  IN VARCHAR2 DEFAULT 'FALSE' )
IS

   -- accepts both key_value and key_ref
   CURSOR get_object_val(key_value_ VARCHAR2) IS
      SELECT technical_spec_no, technical_class
      FROM TECHNICAL_OBJECT_REFERENCE
      WHERE key_value = key_value_
      AND lu_name = lu_name_;
   CURSOR get_object_ref(key_value_ VARCHAR2) IS
      SELECT technical_spec_no, technical_class
      FROM TECHNICAL_OBJECT_REFERENCE
      WHERE key_ref = key_value_
      AND lu_name = lu_name_;

   technical_spec_no_old_  NUMBER;
   technical_spec_no_new_  NUMBER;
   technical_class_        VARCHAR2(10);
   from_found_             BOOLEAN;
   to_found_               BOOLEAN;

BEGIN
   Trace_SYS.message('TECHNICAL_OBJECT_REFERENCE_API.Copy('||lu_name_||','||key_value_from_||','||key_value_to_||')');

   IF Is_Key_Ref___(key_value_from_) THEN
      OPEN get_object_ref(key_value_from_);
      FETCH get_object_ref INTO technical_spec_no_old_, technical_class_;
      from_found_ := get_object_ref%FOUND;
      CLOSE get_object_ref;
   ELSE
      OPEN get_object_val(key_value_from_);
      FETCH get_object_val INTO technical_spec_no_old_, technical_class_;
      from_found_ := get_object_val%FOUND;
      CLOSE get_object_val;
   END IF;


   IF Is_Key_Ref___(key_value_to_) THEN
      OPEN get_object_ref(key_value_to_);
      FETCH get_object_ref INTO technical_spec_no_old_, technical_class_;
      to_found_ := get_object_ref%FOUND;
      CLOSE get_object_ref;
   ELSE
      OPEN get_object_val(key_value_to_);
      FETCH get_object_val INTO technical_spec_no_old_, technical_class_;
      to_found_ := get_object_val%FOUND;
      CLOSE get_object_val;
   END IF;

   IF (NOT from_found_) THEN
      IF (error_when_no_source_ = 'TRUE') THEN
         Error_SYS.Appl_General('TechnicalObjectReference', 'ERRORCREATINGREF: An error occured while creating new reference');
      END IF;
   ELSIF (to_found_) THEN
      IF (error_when_existing_copy_ = 'TRUE') THEN
         Error_SYS.Appl_General('TechnicalObjectReference', 'ALREADYGOTREF: The object has already got a technical class, unable to copy');
      END IF;
   ELSE
      -- Create new reference based on the technical_class and key_value_to_
      Create_Reference_( technical_spec_no_new_, lu_name_, key_value_to_, technical_class_ );
      
      --Technical_Specification_API.Copy_Values_( technical_spec_no_old_, technical_spec_no_new_ );
      -- Copy attribute... 
      Copy_Values(lu_name_, key_value_from_, key_value_to_, 0, NULL);
   END IF;

END Copy;

PROCEDURE Copy (
   source_lu_name_      IN VARCHAR2,
   source_key_ref_      IN VARCHAR2,
   destination_lu_name_ IN VARCHAR2,
   destination_key_ref_ IN VARCHAR2 )
IS
   key_value_           VARCHAR2(500);
   newrec_              TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE;
   --
   CURSOR copy_object (
      lu_name_ VARCHAR2,
      key_ref_ VARCHAR2) IS
      SELECT *
      FROM  TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_
      AND   key_ref = key_ref_;
BEGIN
   FOR rec_ IN copy_object(source_lu_name_, source_key_ref_) LOOP
      newrec_ := NULL;
      key_value_ := OBJECT_CONNECTION_SYS.Convert_To_Key_Value(destination_lu_name_, destination_key_ref_);
      newrec_.technical_spec_no := 0;
      newrec_.lu_name := destination_lu_name_;
      newrec_.key_ref := destination_key_ref_;
      newrec_.key_value := key_value_;
      newrec_.technical_class := rec_.technical_class;
      newrec_.ok_yes_no := rec_.ok_yes_no;
      newrec_.ok_sign := rec_.ok_sign;
      newrec_.dt_ok := rec_.dt_ok;
      --
      New___(newrec_);
      Technical_Specification_API.copy_values_(rec_.technical_spec_no, newrec_.technical_spec_no);
      --
   END LOOP;
END Copy;

PROCEDURE Move (
   source_lu_name_      IN VARCHAR2,
   source_key_ref_      IN VARCHAR2,
   destination_lu_name_ IN VARCHAR2,
   destination_key_ref_ IN VARCHAR2 )
IS
   key_value_           VARCHAR2(500);
   newrec_              TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE;
   remrec_              TECHNICAL_OBJECT_REFERENCE_TAB%ROWTYPE;
   --
   CURSOR copy_object (
      lu_name_ VARCHAR2,
      key_ref_ VARCHAR2) IS
      SELECT *
      FROM  TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_
      AND   key_ref = key_ref_;
BEGIN
   FOR rec_ IN copy_object(source_lu_name_, source_key_ref_) LOOP
      remrec_ := rec_;
      newrec_ := NULL;
      key_value_ := OBJECT_CONNECTION_SYS.Convert_To_Key_Value(destination_lu_name_, destination_key_ref_);
      newrec_.technical_spec_no := 0;
      newrec_.lu_name := destination_lu_name_;
      newrec_.key_ref := destination_key_ref_;
      newrec_.key_value := key_value_;
      newrec_.technical_class := rec_.technical_class;
      newrec_.ok_yes_no := rec_.ok_yes_no;
      newrec_.ok_sign := rec_.ok_sign;
      newrec_.dt_ok := rec_.dt_ok;
      --
      New___(newrec_);
      Technical_Specification_API.copy_values_(rec_.technical_spec_no, newrec_.technical_spec_no);
      Remove___(remrec_);
      --
   END LOOP;
END Move;

PROCEDURE Copy_Values (
   key_value_from_ IN VARCHAR2,
   key_value_to_ IN VARCHAR2,
   option_key_ IN NUMBER,
   technical_group_ IN VARCHAR2,
   lu_name_from_ IN VARCHAR2,
   lu_name_to_ IN VARCHAR2 )
IS

   CURSOR get_spec_no_from IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_from_
      AND KEY_VALUE = key_value_from_;

   CURSOR get_spec_no_from_ref IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_from_
      AND key_ref = key_value_from_;
      --
   CURSOR get_spec_no_to IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_to_
      AND KEY_VALUE = key_value_to_;

   CURSOR  get_spec_no_to_ref IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_to_
      AND key_ref = key_value_to_;

   technical_spec_no_from_    NUMBER;
   technical_spec_no_to_      NUMBER;
   found1_                    BOOLEAN;
   found2_                    BOOLEAN;
BEGIN


   IF Is_Key_Ref___(key_value_from_) THEN
      OPEN get_spec_no_from_ref;
      FETCH get_spec_no_from_ref INTO technical_spec_no_from_;
      found1_ := get_spec_no_from_ref%FOUND;
      CLOSE get_spec_no_from_ref;
   ELSE
      OPEN get_spec_no_from;
      FETCH get_spec_no_from INTO technical_spec_no_from_;
      found1_ := get_spec_no_from%FOUND;
      CLOSE get_spec_no_from;
   END IF;

   IF Is_Key_Ref___(key_value_to_) THEN
      OPEN get_spec_no_to_ref;
      FETCH get_spec_no_to_ref INTO technical_spec_no_to_;
      found2_ := get_spec_no_to_ref%FOUND;
      CLOSE get_spec_no_to_ref;
   ELSE
      OPEN get_spec_no_to;
      FETCH get_spec_no_to INTO technical_spec_no_to_;
      found2_ := get_spec_no_to%FOUND;
      CLOSE get_spec_no_to;
   END IF;

   IF found1_ AND found2_ THEN
      Technical_Spec_Alphanum_API.Replace_Values_(technical_spec_no_from_, technical_spec_no_to_, option_key_,technical_group_);
      Technical_Spec_Numeric_API.Replace_Values_(technical_spec_no_from_, technical_spec_no_to_, option_key_,technical_group_);
   END IF;

END Copy_Values;


PROCEDURE Copy_Values (
   lu_name_ IN VARCHAR2,
   key_value_from_ IN VARCHAR2,
   key_value_to_ IN VARCHAR2,
   option_key_ IN NUMBER,
   technical_group_ IN VARCHAR2 )
IS

   CURSOR get_spec_no_from IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_
      AND KEY_VALUE = key_value_from_;

   CURSOR get_spec_no_from_ref IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_
      AND key_ref = key_value_from_;
      
   CURSOR get_spec_no_to IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_
      AND KEY_VALUE = key_value_to_;

   CURSOR  get_spec_no_to_ref IS
      SELECT TECHNICAL_SPEC_NO
      FROM TECHNICAL_OBJECT_REFERENCE_TAB
      WHERE lu_name = lu_name_
      AND key_ref = key_value_to_;

   technical_spec_no_from_    NUMBER;
   technical_spec_no_to_      NUMBER;
   found1_                    BOOLEAN;
   found2_                    BOOLEAN;
BEGIN

   IF Is_Key_Ref___(key_value_from_) THEN
      OPEN get_spec_no_from_ref;
      FETCH get_spec_no_from_ref INTO technical_spec_no_from_;
      found1_ := get_spec_no_from_ref%FOUND;
      CLOSE get_spec_no_from_ref;
   ELSE
      OPEN get_spec_no_from;
      FETCH get_spec_no_from INTO technical_spec_no_from_;
      found1_ := get_spec_no_from%FOUND;
      CLOSE get_spec_no_from;
   END IF;

   IF Is_Key_Ref___(key_value_to_) THEN
      OPEN get_spec_no_to_ref;
      FETCH get_spec_no_to_ref INTO technical_spec_no_to_;
      found2_ := get_spec_no_to_ref%FOUND;
      CLOSE get_spec_no_to_ref;
   ELSE
      OPEN get_spec_no_to;
      FETCH get_spec_no_to INTO technical_spec_no_to_;
      found2_ := get_spec_no_to%FOUND;
      CLOSE get_spec_no_to;
   END IF;

   IF found1_ AND found2_ THEN
      Technical_Spec_Alphanum_API.Replace_Values_(technical_spec_no_from_, technical_spec_no_to_, option_key_,technical_group_);
      Technical_Spec_Numeric_API.Replace_Values_(technical_spec_no_from_, technical_spec_no_to_, option_key_,technical_group_);
   END IF;

END Copy_Values;


@UncheckedAccess
FUNCTION Get_Status (
   technical_spec_no_ IN NUMBER ) RETURN VARCHAR2
IS
   status_ VARCHAR2(32000);
BEGIN

   IF (Check_Approved(technical_spec_no_)) THEN
      status_ := Technical_Obj_Ref_Approved_API.Decode(2);
   ELSE
      status_ := Technical_Obj_Ref_Approved_API.Decode(1);
   END IF;

   RETURN status_;
END Get_Status;
