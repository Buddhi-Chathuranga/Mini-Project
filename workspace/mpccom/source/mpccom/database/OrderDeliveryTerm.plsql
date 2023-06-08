-----------------------------------------------------------------------------
--
--  Logical unit: OrderDeliveryTerm
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160701  NiAslk  STRCS-1974, Removing blocked_for_use column.
--  120410  AyAmlk  Bug 100608, Increased the column length of delivery_terms to 5 in views ORDER_DELIVERY_TERM, ORDER_DELIVERY_TERM_LOV.
--  110907  NaLrlk  Added method Get_Collect_Freight_Charge_Db. 
--  110705  PraWlk  Bug 94441, Added column delivery term description to the ORDER_DELIVERY_TERM_LOV view.
--  110705          Also added column blocked_for_use to ORDER_DELIVERY_TERM view. Added new functions 
--  110705          Get_Blocked_For_Use() and Get_Blocked_For_Use_Db(). Modified Exist() to validate the delivery term.
--  100429  Ajpelk  Merge rose method documentation
--  ------------------------------Eagle------------------------------------------
--  080723  AmPalk  Added Collect_Freight_Charge as public attribute.
--  080721  AmPalk  Made CALCULATE_FREIGHT_CHARGE a FND_BOOLEAN field.
--  071126  RiLase  Added CALCULATE_FREIGHT_CHARGE to VIEW. Added CALCULATE_FREIGHT_CHARGE to
--                  Unpack_Check_Insert___, Insert___, Unpack_Check_Update___ and Update___.
--                  Added function Get_Calculate_Freight_Charge.
--  *************** NicePrice ****************
--  070426  ChBalk  Made SUBSTR the variable which holds the value from Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060816  MaMalk  Replaced the method call Basic_Data_Translation_API.Insert_Prog_Translation with
--  060816          Basic_Data_Translation_API.Insert_Basic_Data_Translation.
--  060728  ChJalk  Added Function Get_Description_Per_Language and removed calls to Order_Delivery_Term_Desc_API.
--  060724  ChBalk  Added attribute Description and  public method GetDescription to the class,
--                  and moved order_delivery_term_lov, order_delivery_term_pub views from Order_Delivery_Term_Desc_API
--                  during the process of making ship via code language independent.
--  -------------------------------13.4.0--------------------------------------
--  060111  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___
--  060111          and added UNDEFINE according to the new template.
--  ------------------------------- 13.3.0 ----------------------------------
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  990422  JOHW    General performance improvements.
--  990413  JOHW    Upgraded to performance optimized template.
--  971121  TOOS    Upgrade to F1 2.0
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970313  CHAN    Changed table name: delivery_terms is replaced by
--                  order_delivery_term_tab
--  970226  PELA    Uses column rowversion as objversion (timestamp).
--  961214  JOKE    Modified with new workbench default templates.
--  961129  JOBE    Modified for compatibility with workbench.
--  960813  MAOS    Removed Get_Description_Vendor.
--  960607  JOKE    Changed Ref-flag on language_code to MpccomLanguage.
--  960530  JOBE    Added validate and ref to Language_Code.
--  960517  AnAr    Added purpose comment to file.
--  960429  JOED    Added view ORDER_DELIVERY_TERM_LOV
--  960308  SHVE    Changed LU Name PurDeliveryTerms.
--  951018  JICE    Base Table to Logical Unit Generator 1.
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
   Client_SYS.Add_To_Attr('CALCULATE_FREIGHT_CHARGE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('COLLECT_FREIGHT_CHARGE_DB', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT order_delivery_term_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN    
   IF newrec_.calculate_freight_charge IS NULL THEN
      newrec_.calculate_freight_charge := 'FALSE';
   END IF;
   IF newrec_.collect_freight_charge IS NULL THEN
      newrec_.collect_freight_charge := 'FALSE';
   END IF;
   IF newrec_.collect_freight_charge = 'TRUE' AND newrec_.calculate_freight_charge = 'FALSE' THEN
      Error_SYS.Record_General(lu_name_, 'COLCTWITHOUTFRET: With out activating the Calculate Freight Charge attribute, can not activate the Collect Freight Charge attribute. Please check the Calculate Freight Charge check box of term :P1.', newrec_.delivery_terms);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     order_delivery_term_tab%ROWTYPE,
   newrec_ IN OUT order_delivery_term_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF newrec_.collect_freight_charge = 'TRUE' AND newrec_.calculate_freight_charge = 'FALSE' THEN
      Error_SYS.Record_General(lu_name_, 'COLCTWITHOUTFRET: With out activating the Calculate Freight Charge attribute, can not activate the Collect Freight Charge attribute. Please check the Calculate Freight Charge check box of term :P1.', newrec_.delivery_terms);
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Get_Calculate_Freight_Charge (
   delivery_terms_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   --Add pre-processing code here
   RETURN Fnd_Boolean_API.Encode(super(delivery_terms_));
END Get_Calculate_Freight_Charge;




-- Get_Control_Type_Value_Desc
--   Gets the description for a certain value.
--   Exclusively used in Accounting Rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


@UncheckedAccess
FUNCTION Get_Description (
   delivery_terms_ IN VARCHAR2,
   language_code_  IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   CURSOR get_description IS
      SELECT description
        FROM ORDER_DELIVERY_TERM_TAB
       WHERE delivery_terms = delivery_terms_;

   description_ ORDER_DELIVERY_TERM_TAB.description%TYPE;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('MPCCOM',
                                                                                'OrderDeliveryTerm',
                                                                                delivery_terms_,
                                                                                language_code_), 1, 35);

   IF (description_ IS NULL) THEN
      OPEN get_description;
      FETCH get_description INTO description_;
      CLOSE get_description;
   END IF;
   RETURN description_;
END Get_Description;


@UncheckedAccess
FUNCTION Get_Description_Per_Language (
   delivery_terms_ IN VARCHAR2,
   language_code_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   description_ ORDER_DELIVERY_TERM_TAB.description%TYPE;
BEGIN
   description_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation('MPCCOM',
                                                                                'OrderDeliveryTerm',
                                                                                delivery_terms_,
                                                                                language_code_), 1, 35);
   RETURN description_;
END Get_Description_Per_Language;



