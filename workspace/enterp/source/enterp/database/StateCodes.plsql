-----------------------------------------------------------------------------
--
--  Logical unit: StateCodes
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020103  kagalk  Created
--  050903  Gepelk  IIDARDI124. Argentinean Sales Tax
--  030929  prdilk  Changed the state_Name view comment in State_codes View
--  050304  Hecolk  LCS Merge - Bug 48740, added function Get_State_Cod
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     state_codes_tab%ROWTYPE,
   newrec_ IN OUT state_codes_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   state_presentation_     VARCHAR2(20);
BEGIN
   state_presentation_ := Enterp_Address_Country_API.Get_State_Presentation_Db(newrec_.country_code);
   IF (state_presentation_ = 'NOTUSED' AND (newrec_.state_code != '*' OR newrec_.state_name != '*')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_VAL1: The only valid value for State Code and State Name is * if state presentation is not used by the current country.');
   END IF;
   IF (state_presentation_ <> 'NOTUSED' AND (newrec_.state_code = '*' OR newrec_.state_name = '*')) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_VAL2: The value * is not allowed for State Code and State Name if state presentation is used by the current country.');
   END IF;                          
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;
 

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   country_code_           VARCHAR2(2);
   state_presentation_     VARCHAR2(20);
   tmp_attr_               VARCHAR2(32000);
BEGIN
   tmp_attr_ := attr_;
   super(attr_);
   attr_ := tmp_attr_;
   country_code_ := Client_SYS.Get_Item_Value('COUNTRY_CODE',attr_);
   state_presentation_ := Enterp_Address_Country_API.Get_State_Presentation_Db(country_code_);
   IF (state_presentation_ = 'NOTUSED') THEN
      Client_SYS.Add_To_Attr('STATE_CODE', '*', attr_);
      Client_SYS.Add_To_Attr('STATE_NAME', '*', attr_);
   ELSE
       Client_SYS.Clear_Attr(attr_);
   END IF;   
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_State_Code (
   country_code_ IN VARCHAR2,
   state_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ state_codes_tab.state_code%TYPE;
   CURSOR get_attr IS
      SELECT state_code
      FROM   state_codes_tab
      WHERE  country_code = country_code_
      AND    state_name = state_name_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_State_Code;



