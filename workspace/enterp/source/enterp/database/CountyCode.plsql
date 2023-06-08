-----------------------------------------------------------------------------
--
--  Logical unit: CountyCode
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050903  Gepelk  IIDARDI124N. Argentinean Sales Tax
--  111202  Chgulk  SFI-700, Merged bug 99562
--  130829  Hecolk  Bug 111220, Corrected END Statement in FUNCTION Get_County_Code
--  131015  Isuklk  CAHOOK-2728 Refactoring in CountyCode.entity
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
 
-------------------- PRIVATE DECLARATIONS -----------------------------------
 
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     county_code_tab%ROWTYPE,
   newrec_ IN OUT county_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   county_presentation_ VARCHAR2(20);
BEGIN
   county_presentation_ := Enterp_Address_Country_API.Get_County_Presentation_Db( newrec_.country_code);
   IF (county_presentation_ = 'NOTUSED' AND (newrec_.county_code != '*' OR newrec_.county_name != '*')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_VAL1: The only valid value for County Code and County Name is * if county presentation is not used by the current country.');
   END IF;
   IF (county_presentation_ != 'NOTUSED' AND (newrec_.county_code = '*' OR newrec_.county_name = '*')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_VAL2: The value * is not allowed for County Code and County Name if county presentation is used by the current country.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Common___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   country_code_            VARCHAR2(2);
   county_presentation_     VARCHAR2(20);
   temp_attr_               VARCHAR2(32000);
BEGIN
   temp_attr_ := attr_;   
   super(attr_);
   attr_ := temp_attr_;
   country_code_ := Client_SYS.Get_Item_Value('COUNTRY_CODE',attr_);
   county_presentation_ := Presentation_Type_API.Encode(Enterp_Address_Country_API.Get_County_Presentation(country_code_));
   IF (county_presentation_ = 'NOTUSED') THEN
      Client_SYS.Add_To_Attr('COUNTY_CODE', '*', attr_);
      Client_SYS.Add_To_Attr('COUNTY_NAME', '*', attr_);
   ELSE
       Client_SYS.Clear_Attr(attr_);
   END IF;   
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_County_Code (
   country_code_ IN VARCHAR2,
   state_code_   IN VARCHAR2,
   county_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ county_code_tab.county_code%TYPE;
   CURSOR get_attr IS
      SELECT county_code
      FROM   county_code_tab
      WHERE  country_code = country_code_
      AND    state_code = state_code_
      AND    county_name = county_name_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_County_Code;



