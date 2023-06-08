-----------------------------------------------------------------------------
--
--  Logical unit: SalesDiscountType
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160509  SudJlk   STRSC-2266, Modified Insert_Lu_Data_Rec__ to insert data for rowstate.
--  131028  MaMalk   Made discount not mandatory to support the insertion of data from the ins file.
--  120525  JeLise   Made description private.
--  120508  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120508           in Insert___, Update___, Delete___, Insert_Lu_Data_Rec__, Get_Description, Get and in the view.
--  100514  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060606  MaJalk Bug 58362, Added new function Check_Exist.
--  060118  JaJalk Added the returning clause in Insert___ according to the new F1 template.
--  050920  MaEelk Removed unused variables from the code.
--  040225  IsWilk Modified the SUBSTRB to SUBSTR for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes---------------------
--  030926  ThGu   Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  StDa  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  020109  CaSt  Bug fix 26922, Changed discount limits in Unpack_Check_Insert___ and Unpack_Check_Update___
--                to allow negative discount.
--  010730  Samnlk Change the view comment of the discount . 
--  000301  JoEd  Changed validation of discount column.
--  000210  JoAn  Changed Get_Control_Type_Value_Desc, description returned 
--                instead of discount.
--  ----------------- 12.0 --------------------------------------------------
--  991011  JOHW  CID 22622 - Sales Discount Type.
--  990830  JOHW  Created
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
   Client_SYS.Add_To_Attr('DISCOUNT', 0, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     sales_discount_type_tab%ROWTYPE,
   newrec_ IN OUT sales_discount_type_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.discount < -100) OR (newrec_.discount > 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN SALES_DISCOUNT_TYPE_TAB%ROWTYPE)
IS
   dummy_      VARCHAR2(1);
   CURSOR Exist IS
      SELECT 'X'
      FROM SALES_DISCOUNT_TYPE_TAB
      WHERE discount_type = newrec_.discount_type;
BEGIN
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      INSERT
         INTO SALES_DISCOUNT_TYPE_TAB(
            discount_type,
            description,
            discount,
            rowstate,
            rowversion)
         VALUES(
            newrec_.discount_type,
            newrec_.description,
            newrec_.discount,
            newrec_.rowstate,
            newrec_.rowversion);
   ELSE
      UPDATE SALES_DISCOUNT_TYPE_TAB
         SET description = newrec_.description
       WHERE discount_type = newrec_.discount_type;
   END IF;
   CLOSE Exist;
   Basic_Data_Translation_API.Insert_Prog_Translation('ORDER',
                                                      'SalesDiscountType',
                                                      newrec_.discount_type,
                                                      newrec_.description);
END Insert_Lu_Data_Rec__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   discount_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sales_discount_type_tab.description%TYPE;
BEGIN
   IF (discount_type_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'SalesDiscountType',
      discount_type_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  sales_discount_type_tab
      WHERE discount_type = discount_type_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(discount_type_, 'Get_Description');
END Get_Description;


-- Get_Control_Type_Value_Desc
--   Retreive the control type description used in accounting
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


-- Check_Exist
--   Checks whether the discount_type_ exists. If found return TRUE else return FALSE.
@UncheckedAccess
FUNCTION Check_Exist (
   discount_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN (Check_Exist___(discount_type_));
END Check_Exist;



