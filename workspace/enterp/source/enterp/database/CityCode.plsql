-----------------------------------------------------------------------------
--
--  Logical unit: CityCode
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100429  SaFalk  Modified REF of county_code and country_code in CITY_CODE.
--  050903  Gepelk  IIDARDI124N. Argentinean Sales Tax
--  111202  Chgulk  SFI-700. Merged bug 9956
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
  
-------------------- PRIVATE DECLARATIONS -----------------------------------
  
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   country_code_           VARCHAR2(2);
   city_presentation_      VARCHAR2(20);
   attr_tmp_               VARCHAR2(32000);
BEGIN
   attr_tmp_ := attr_;
   super(attr_);
   attr_ := attr_tmp_;
   country_code_ := Client_SYS.Get_Item_Value('COUNTRY_CODE',attr_);
   city_presentation_ := Enterp_Address_Country_API.Get_City_Presentation_Db(country_code_);
   IF (city_presentation_ = 'NOTUSED') THEN
      Client_SYS.Add_To_Attr('CITY_CODE', '*', attr_);
      Client_SYS.Add_To_Attr('CITY_NAME', '*', attr_);
   ELSE
       Client_SYS.Clear_Attr(attr_);
   END IF;   
END Prepare_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     city_code_tab%ROWTYPE,
   newrec_ IN OUT city_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
    city_presentation_ VARCHAR2(20);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);   
   city_presentation_ := Enterp_Address_Country_API.Get_City_Presentation_Db( newrec_.country_code);
   IF (city_presentation_ = 'NOTUSED' AND (newrec_.city_code != '*' OR newrec_.city_name != '*')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_VAL1: The only valid value for City Code and City Name is * if city presentation is not used by the current country.');
   END IF;
   IF (city_presentation_ != 'NOTUSED' AND (newrec_.city_code = '*' OR newrec_.city_name = '*')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_VAL2: The value * is not allowed for City Code and City Name if city presentation is used by the current country.');
   END IF;  
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_City_Code (
   country_code_ IN VARCHAR2,
   state_code_   IN VARCHAR2,
   county_code_  IN VARCHAR2,
   city_name_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ city_code_tab.city_code%TYPE;
   CURSOR get_attr IS
      SELECT city_code
      FROM   city_code_tab
      WHERE  country_code = country_code_
      AND    state_code = state_code_
      AND    county_code = county_code_
      AND    city_name = city_name_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_City_Code;



