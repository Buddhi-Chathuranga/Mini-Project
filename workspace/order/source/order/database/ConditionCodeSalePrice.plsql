-----------------------------------------------------------------------------
--
--  Logical unit: ConditionCodeSalePrice
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  121010  HimRlk  Added new parameter pur_price_incl_tax_ to Copy_Pur_Price_To_Sale_Price().
--  120528  SURBLK  Added column PRICE_INCL_TAX.
--  110712  MaMalk  Added the user allowed site filter to the base view.
--  100512  Ajpelk  Merge rose method documentation
--  060112  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  040817  DhWilk  Modified the last parameter of General_SYS.Init_Method in Copy_Pur_Price_To_Sale_Price  
--  ------------------------------13.3.0---------------------------------------
--  ------------------------TouchDown Merge End------------------------------------------
--  031212  HeWelk  Added Copy_Pur_Price_To_Sale_Price to copy the cc purchase prices
--                  to cc sales prices.  
--  031205  HeWelk  Modified Prepare_Insert___ to get default value for CURRENCY_CODE.
--  031204  HeWelk  Added attribute CURRENCY_CODE
--  ------------------------TouchDown Merge Begin------------------------------------------
--  040209  GaJalk  Bug 42489, Merged Touch Down code.   
--  030807  ChIwlk  Call 100451, Modified method Unpack_Check_Insert___ to use the correct
--  030807          part no in checking for condition code usage.
--  030610  ChIwlk  Changed Unpack_Check_Insert___ and Unpack_Check_Update___ to raise error
--  030610          messages when price is negative or part is not condition code enabled
--  030610  ChIwlk  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   currency_code_ CONDITION_CODE_SALE_PRICE_TAB.CURRENCY_CODE%TYPE;
   contract_      CONDITION_CODE_SALE_PRICE_TAB.CONTRACT%TYPE;
BEGIN
   contract_ := Client_SYS.Get_Item_Value('CONTRACT',attr_);
   currency_code_ := Company_Finance_API.Get_Currency_Code(Site_API.Get_Company(contract_));
   super(attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE',currency_code_ ,attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT condition_code_sale_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
   part_exists_               BOOLEAN;
   condtion_code_usage_       VARCHAR2(20);
   part_no_                   VARCHAR2(25);
BEGIN
   super(newrec_, indrec_, attr_);
   Sales_Part_API.Exist(newrec_.contract, newrec_.catalog_no, Sales_Type_API.DB_SALES_AND_RENTAL);   
   -- Note : This error message should not be raised since condition code pricing is disabled in
   --        the client side for sales parts for which condition code usage is not allowed in
   --        the part catalog.
   part_no_     := Sales_Part_API.Get_Part_No(newrec_.contract, newrec_.catalog_no);
   part_exists_ := Part_Catalog_API.Check_Part_Exists(part_no_);
   IF (part_exists_) THEN
      condtion_code_usage_ := Part_Catalog_API.Get_Condition_Code_Usage_Db(part_no_);
      IF (condtion_code_usage_ = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_, 'NOTCONDCODEENABLED: This part is not condition code enabled');
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOTCONDCODEENABLED: This part is not condition code enabled');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     condition_code_sale_price_tab%ROWTYPE,
   newrec_ IN OUT condition_code_sale_price_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   --Add post-processing code here
   IF (newrec_.price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGCONDPRICE: Price must not be negative.');
   END IF;  
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy_Pur_Price_To_Sale_Price
--   Copy the condition code , price and currency from purchase part to
--   sales part.
PROCEDURE Copy_Pur_Price_To_Sale_Price (
   condition_code_      IN VARCHAR2,
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   pur_price_           IN NUMBER,
   pur_price_incl_tax_  IN NUMBER,
   currency_code_       IN VARCHAR2 )
IS
   oldrec_           CONDITION_CODE_SALE_PRICE_TAB%ROWTYPE;
   newrec_           CONDITION_CODE_SALE_PRICE_TAB%ROWTYPE;
   attr_             VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   salespart_rec_    SALES_PART_API.Public_Rec;
   tax_percentage_   NUMBER;
   price_            NUMBER;
   price_incl_tax_   NUMBER;
   indrec_           Indicator_Rec;
BEGIN
   Client_Sys.Clear_Attr(attr_);
   salespart_rec_ := Sales_part_API.Get(contract_ ,catalog_no_);
   tax_percentage_ := NVL(Statutory_Fee_API.Get_Fee_Rate(Site_API.Get_Company(contract_), salespart_rec_.tax_code), 0);
   IF (salespart_rec_.use_price_incl_tax = 'TRUE') THEN
      price_incl_tax_ := pur_price_incl_tax_;
      price_ := pur_price_incl_tax_ / ((tax_percentage_ /100) + 1);
   ELSE
      price_ := pur_price_;
      price_incl_tax_ := pur_price_ * ((tax_percentage_ /100) + 1);
   END IF;   
   IF Check_Exist___(condition_code_ ,contract_ ,catalog_no_) THEN
      oldrec_ := Lock_By_Keys___(condition_code_, contract_, catalog_no_);
      newrec_ := oldrec_;
      Get_Id_Version_By_Keys___(objid_, objversion_, condition_code_, contract_, catalog_no_);     
      Client_Sys.Add_To_Attr('PRICE',  price_  ,attr_);
      Client_Sys.Add_To_Attr('PRICE_INCL_TAX',  price_incl_tax_  ,attr_);
      Client_Sys.Add_To_Attr('CURRENCY_CODE',  currency_code_  ,attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   ELSE
      Client_Sys.Add_To_Attr('CONDITION_CODE',  condition_code_  ,attr_);
      Client_Sys.Add_To_Attr('CONTRACT',  contract_  ,attr_);
      Client_Sys.Add_To_Attr('CATALOG_NO',  catalog_no_  ,attr_);
      Client_Sys.Add_To_Attr('PRICE',  price_  ,attr_);
      Client_Sys.Add_To_Attr('PRICE_INCL_TAX',  price_incl_tax_  ,attr_);
      Client_Sys.Add_To_Attr('CURRENCY_CODE',  currency_code_  ,attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Copy_Pur_Price_To_Sale_Price;



