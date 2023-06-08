-----------------------------------------------------------------------------
--
--  Logical unit: CommissionAgreeLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  101015  KiSalk  Added Check_Sales_Part_Usage__ and used it in View REF to SalesPart.
--  100624  MoNilk  Reverted the correction with derived columns.
--  100622  MoNilk  Added derived columns contract,company and party_type to the view COMMISSION_AGREE_LINE and
--  100622          Updated the refs SalesPart and InvoicePartyTypeGroup with correct keys.
--  100512  Ajpelk  Merge rose method documentation.
--  091022  MaRalk  Added identity_type_db column to the view COMMISSION_AGREE_LINE.
--  091921  MaRalk  Added length to the view column identity_type.
--  080609  SuJalk  Bug 74799, Changed the data type to customer no type in COMMISSION_AGREE_LINE_TAB from VARCHAR2 in method Calc_Com_Data_From_Agree.
--  071022  NaLrlk  Added parameters to REF value with NOCHECK in Group_Id view comment.
--  070519  WaJalk  Made the columns commodity_code,part_product_code,part_product_family uppercase.
--  060417  SaRalk  Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 --------------------------------
--  060216  IsWilk  Modified the PROCEDURE Unpack_Check_Insert___, Unpack_Check_Update___
--  060216          to check the customer expiration date.
--  060112  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050926  NuFilk  Modified method Calc_Com_Data_From_Agree to include the new parameter to call
--                  Commission_Calculation_API.Get_Amount_In_Currency.
--  040219  IsWilk  Removed the SUBSTRB from the views for Unicode Changes.
--  -------------------------------- 13.3.0 ----------------------------------
--  031021  JaBalk  Call ID 107342, Modified the cursor parse_rules and added new cursor get_min_value in Calc_Com_Data_From_Agree.
--  021211  Asawlk  Merged bug fixes in 2002-3 SP3
--  021123  NuFilk  Bug 34278, Moved Function Get_Catalog_Desc to Sales Part LU with different name.
--  020520  NuFilk  Bug 25675, Added Function Get_Catalog_Desc
--  010528  JSAnse  Bug 21463, Added call to General_SYS.Init_Method in Procedure New.
--  001124  JoAn    CID 54323 Added NVL when adding upp commission percentage in
--                  Calc_Com_Data_From_Agree
--  000711  JakH    Merged from Chameleon
--  000519  BjSa    Added Checks on Catalog No
--  000517  DEHA    Added public new method.
--  000515  BRO     Added argument Agree_Calc_Info to the proc. Calc_Com_Data_From_Agree
--  000511  ThIs    Percentage > 100 not allowed
--  000510  DEHA    Removed field note_id.
--  000509  DEHA    Added fields note_id, note_text;
--                  added checks for range types.
--  000508  ThIs    Added validation of customer group, sequence order and percentage
--  000508  BRO     Corrected currency used in Calc_Com_Data_From_Agree
--  000504  ThIs    Added function Check_Range_Exist
--  000427  DEHA    Changed Field name order_amount to amount from LU
--                  OrderLineCommission
--  000420  BRO     Added function Check_Exist_Range_Lines___
--  000417  BRO     Implemented Calc_Com_Data_From_Agree
--  000412  DEHA    Added function Calc_Com_Data_From_Agree, removed field
--                  amount.
--  000410  DEHA    Changed field name agreement_version to revision_no.
--  000410  BRO     Added Get_Next_Line_No___
--  000407  DEHA    Changed attribute name sequence_no to line_no.
--  000406  BRO     Created
--  000406  DEHA    Created.
--                  The check for the SalesPart, InvoicePartyTypeGroup
--                  if value_ <> NULL must be extended
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_Line_No___
--   Implementation Method which returns the next free
--   line no for a specified version of an agreement.
FUNCTION Get_Next_Line_No___ (
   agreement_id_        IN VARCHAR2,
   revision_no_   IN NUMBER ) RETURN NUMBER
IS
   last_line_no_ NUMBER;

   CURSOR get_last_line_no IS
      SELECT NVL(MAX(line_no), 0)
      FROM   COMMISSION_AGREE_LINE_TAB
      WHERE  agreement_id = agreement_id_
        AND  revision_no = revision_no_;
BEGIN
   OPEN get_last_line_no;
   FETCH get_last_line_no INTO last_line_no_;
   CLOSE get_last_line_no;
   RETURN last_line_no_ + 1;
END Get_Next_Line_No___;


-- Check_Exist_Range_Lines___
--   Implementation method for checking if a range type change is valid
--   (only for those agreement lines which are not connected to a
--   range/ range type).
FUNCTION Check_Exist_Range_Lines___ (
   objid_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   COMMISSION_AGREE_LINE_TAB cal, COMMISSION_RANGE_TAB cr
      WHERE  cal.agreement_id = cr.agreement_id
      AND    cal.revision_no = cr.revision_no
      AND    cal.line_no = cr.line_no
      AND    cal.rowid = objid_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Check_Exist_Range_Lines___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('COMMISSION_CALC_METH', Commission_Calc_Meth_API.Decode('ADDITIVE'), attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     commission_agree_line_tab%ROWTYPE,
   newrec_ IN OUT commission_agree_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   dummy_ NUMBER;
   CURSOR check_sequence_order IS
     SELECT 1
     FROM COMMISSION_AGREE_LINE_TAB
     WHERE agreement_id = newrec_.agreement_id
       AND revision_no = newrec_.revision_no
       AND sequence_order = newrec_.sequence_order;
BEGIN
   IF (indrec_.catalog_no) THEN
      Sales_Part_API.Catalog_No_Exist(newrec_.catalog_no);
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_); 
   IF (indrec_.sequence_order AND Validate_SYS.Is_Changed(oldrec_.sequence_order, newrec_.sequence_order)) THEN
      IF (newrec_.sequence_order IS NOT NULL) THEN
         OPEN check_sequence_order;
         FETCH check_sequence_order INTO dummy_;
         IF check_sequence_order%FOUND THEN
            CLOSE check_sequence_order;
            Error_SYS.Record_General(lu_name_, 'UNIQUE_SEQU_ORDER: Sequence order :P1 already exists', TO_CHAR(newrec_.sequence_order));
         END IF;
         CLOSE check_sequence_order;
      END IF;   
   END IF;
   IF (TRUNC(Cust_Ord_Customer_API.Get_Date_Del(newrec_.customer_no)) <= TRUNC(Site_API.Get_Site_Date(User_Default_API.Get_Contract))) THEN
      Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR: Customer has expired. Check expire date.');
   END IF;
   
   IF (indrec_.group_id) THEN
      Invoice_Party_Type_Group_API.Exist(site_api.get_company(user_default_api.get_contract()),
                                         Party_Type_API.Decode('CUSTOMER'),
                                         newrec_.group_id);
   END IF;

   -- check percentage
   IF  newrec_.percentage < 0 THEN
       Error_SYS.Record_General(lu_name_, 'PERCENTAGE_NEGATIVE: Percentage cannot be negative');
   END IF;
   IF newrec_.commission_range_type IS NOT NULL THEN
      IF  newrec_.percentage > 100 AND newrec_.commission_range_type = 'DISCOUNT' THEN
          Error_SYS.Record_General(lu_name_, 'PERCENTAGE_TOOBIG: Percentage cannot be greater than 100');
      END IF;
   END IF;
   
   -- check range types
   Commission_Range_API.Change_Allowed(
      newrec_.agreement_id,
      newrec_.revision_no,
      newrec_.line_no,
      newrec_.commission_range_type);
   IF newrec_.commission_range_type = 'QUANTITY' AND newrec_.catalog_no IS NULL THEN
      Error_Sys.Record_General (lu_name_, 'RANGE_NOTALLOWED: Commission range :P1 is only allowed when a sales part has been defined.',
                                Commission_Range_Type_API.Decode('QUANTITY'));
   END IF;
END Check_Common___;



@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT commission_agree_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.line_no := Get_Next_Line_No___(newrec_.agreement_id, newrec_.revision_no);
   Client_SYS.Add_To_Attr('LINE_NO', newrec_.line_no, attr_);

   super(newrec_, indrec_, attr_);
   IF  newrec_.sequence_order <= 0 THEN
       Error_SYS.Record_General(lu_name_, 'SEQUENCE_ORDER_ZERO: Sequence order must be greater than zero');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     commission_agree_line_tab%ROWTYPE,
   newrec_ IN OUT commission_agree_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF newrec_.sequence_order = 0 THEN
      Error_SYS.Record_General(lu_name_, 'SEQUENCE_ORDER_ZERO: Sequence order must be greater than zero');
   END IF;
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_ COMMISSION_AGREE_LINE_TAB%ROWTYPE;
   newrec_ COMMISSION_AGREE_LINE_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN
      oldrec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      -- inform the user that some range lines are existing for this agreement line when the range type is changed
      IF ( newrec_.commission_range_type <> oldrec_.commission_range_type AND Check_Exist_Range_Lines___(objid_) ) THEN
         Client_Sys.Add_Info(Lu_Name_, 'RANGE_LINES_EXIST: The range type has been changed and some lines were already existing.');
         info_ := Client_SYS.Append_Info(info_);
      END IF;
   END IF;  
END Modify__;


-- Check_Sales_Part_Usage
--   Since there is no contract in CommissionAgreeLine, it is not possible to give direct reference
--   SalesPart. So, this method has been written to check the references manually.
--   This procedure raise an error message if the given sales part is connected
--   to one or more Commission Agree Lines. This method is called by Reference_Sys.
PROCEDURE Check_Sales_Part_Usage (
   catalog_no_ IN VARCHAR2)
IS
   count_      NUMBER;
   CURSOR record_exist IS
      SELECT count(*)
        FROM COMMISSION_AGREE_LINE_TAB
       WHERE catalog_no = catalog_no_;

BEGIN
    OPEN record_exist;
    FETCH record_exist INTO count_;
    CLOSE record_exist;

    IF (count_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'NODELCATNO: The Sales Part :P1 is used '||
                             ' by :P2 rows in another object (Commission Agree Line)', catalog_no_, count_ );
    END IF;

END Check_Sales_Part_Usage;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Calc_Com_Data_From_Agree
--   Public Method for getting a percentage or an amount from  matching
--   calculation rules. The used rules are described.
PROCEDURE Calc_Com_Data_From_Agree (
   com_percentage_   OUT NUMBER,
   com_amount_       OUT NUMBER,
   agree_calc_info_  OUT VARCHAR2,
   olc_rec_          IN ORDER_LINE_COMMISSION_TAB%ROWTYPE )
IS
   order_curr_amount_   NUMBER; -- "order amount" in agreement currency
   com_curr_code_       CURRENCY_CODE_TAB.currency_code%TYPE;
   currency_rate_       NUMBER;
   curr_date_           DATE;

   row_no_              NUMBER;
   attr_                VARCHAR2(2000);
   amount_              NUMBER;
   default_percentage_  NUMBER;
   min_value_           NUMBER;
   customer_no_pay_      COMMISSION_AGREE_LINE_TAB.customer_no%TYPE;

   CURSOR parse_rules IS
--      SELECT cal.line_no, cal.commission_calc_meth, cal.commission_range_type, cal.sequence_order, cal.percentage, cr.min_value, cr.amount, cr.percentage
      SELECT cal.line_no,
             cal.commission_calc_meth,
             cal.percentage,
             cal.commission_range_type
      FROM commission_agree_line_tab cal
      WHERE cal.agreement_id = olc_rec_.agreement_id
      AND cal.revision_no = olc_rec_.revision_no
      AND (stat_cust_grp IS NULL OR stat_cust_grp = olc_rec_.stat_cust_grp)
      AND (sales_price_group_id IS NULL OR sales_price_group_id = olc_rec_.sales_price_group_id)
      AND (catalog_group IS NULL OR catalog_group = olc_rec_.catalog_group)
      AND (catalog_no IS NULL OR catalog_no = olc_rec_.catalog_no)
      AND (country_code IS NULL OR country_code = olc_rec_.country_code)
      AND (market_code IS NULL OR market_code = olc_rec_.market_code)
      AND (region_code IS NULL OR region_code = olc_rec_.region_code)
      AND (customer_no IS NULL OR customer_no = olc_rec_.customer_no)
      AND (identity_type IS NULL OR identity_type = olc_rec_.identity_type)
      AND (part_product_code IS NULL OR part_product_code = olc_rec_.part_product_code)
      AND (commodity_code IS NULL OR commodity_code = olc_rec_.commodity_code)
      AND (part_product_family IS NULL OR part_product_family = olc_rec_.part_product_family)
      AND (group_id IS NULL OR group_id = olc_rec_.group_id)

      -- Exclusive values should be seen before Additive values
      ORDER BY cal.commission_calc_meth DESC, cal.sequence_order;

   CURSOR get_min_value (line_no_ NUMBER, commission_range_type_ VARCHAR2) IS
      SELECT min_value,
             amount,
             percentage
      FROM commission_range_tab
      WHERE agreement_id = olc_rec_.agreement_id
      AND   revision_no = olc_rec_.revision_no
      AND   line_no = line_no_
      AND   min_value IN
            ( SELECT MAX(min_value)
              FROM commission_range_tab
              WHERE agreement_id = olc_rec_.agreement_id
              AND   revision_no = olc_rec_.revision_no
              AND   line_no = line_no_
              AND   min_value <= DECODE(commission_range_type_, 'QUANTITY', olc_rec_.Qty, 'AMOUNT', order_curr_amount_, 'DISCOUNT', olc_rec_.Discount));

BEGIN
   com_percentage_   := 0;
   com_amount_       := 0;
   agree_calc_info_  := Message_SYS.Construct('AgreeCalcInfo');
   row_no_           := 0;

   -- convert "order amount" to base currency
   com_curr_code_ := Commission_Agree_API.Get_Currency_Code(olc_rec_.agreement_id, olc_rec_.revision_no);
   curr_date_ := Customer_Order_Line_API.Get_Date_Entered(olc_rec_.order_no, olc_rec_.line_no, olc_rec_.rel_no, olc_rec_.line_item_no);
   customer_no_pay_ := Customer_Order_API.Get_Customer_No_Pay(olc_rec_.order_no);
   order_curr_amount_ := Commission_Calculation_API.Get_Amount_In_Currency(
                                      currency_rate_,
                                      nvl(customer_no_pay_,olc_rec_.customer_no),
                                      olc_rec_.contract,
                                      com_curr_code_,
                                      curr_date_,
                                      olc_rec_.Amount);

   FOR parsed_rules IN parse_rules LOOP
      default_percentage_ := 0;
      OPEN get_min_value(parsed_rules.line_no,parsed_rules.commission_range_type);
      FETCH get_min_value INTO min_value_,amount_,default_percentage_;
      IF (get_min_value%NOTFOUND) THEN
         default_percentage_ := parsed_rules.percentage;
         amount_ := NULL;
      END IF;
      CLOSE get_min_value;
      IF (amount_ IS NULL) THEN
          com_percentage_ := com_percentage_ + NVL(default_percentage_,0);
      ELSE
          com_amount_ := com_amount_ + amount_;
      END IF;

      row_no_ := row_no_ + 1;

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LINE_NO', parsed_rules.line_no, attr_);
      Client_SYS.Add_To_Attr('PERCENT', NVL(default_percentage_,0), attr_);
      Client_SYS.Add_To_Attr('AMOUNT', NVL(amount_, 0), attr_);
      Client_SYS.Add_To_Attr('CURR_CODE', com_curr_code_, attr_);
      Client_SYS.Add_To_Attr('RANGE_TYPE', Commission_Range_Type_API.Decode(parsed_rules.commission_range_type), attr_);
      Client_SYS.Add_To_Attr('MIN_VALUE', NVL(min_value_,0), attr_);

      Message_SYS.Add_Attribute(agree_calc_info_, TO_CHAR(row_no_), attr_);

      IF parsed_rules.commission_calc_meth = 'EXCLUSIVE' THEN
         EXIT;
      END IF;
   END LOOP;

END Calc_Com_Data_From_Agree;


-- Check_Range_Exist
--   Public method for checking if a range item exists for an
--   agreement line.
@UncheckedAccess
FUNCTION Check_Range_Exist (
   agreement_id_ IN VARCHAR2,
   revision_no_  IN NUMBER,
   line_no_      IN NUMBER ) RETURN NUMBER
IS
   temp_     NUMBER;
   CURSOR get_range IS
     SELECT 1
       FROM COMMISSION_RANGE_TAB
     WHERE agreement_id = agreement_id_
       AND revision_no = revision_no_
       AND line_no = line_no_;
BEGIN
   OPEN get_range;
   FETCH get_range INTO temp_;
   IF get_range%FOUND THEN
      CLOSE get_range;
      RETURN 1;
   ELSE
      CLOSE get_range;
      RETURN 0;
   END IF;
END Check_Range_Exist;


-- New
--   Public new method, to insert a record by key.
PROCEDURE New (
   newrec_ IN OUT COMMISSION_AGREE_LINE_TAB%ROWTYPE )
IS
   attr_                   VARCHAR2(2000);
   objid_                  VARCHAR2(200);
   objversion_             VARCHAR2(200);
BEGIN
   Insert___(objid_, objversion_, newrec_, attr_);
END New;



