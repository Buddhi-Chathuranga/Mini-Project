-----------------------------------------------------------------------------
--
--  Logical unit: SelfBillingItem
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181214  KHVESE SCUXXW4-9475, Added method Get_Line_Amounts__ and modified method Unmatch_Line___ to call to Get_Line_Amounts__ and overide the method Update___ 
--  181214         to calculate total amount when moifying line from Aurena
--  170926  RaVdlk STRSC-11152,Removed Get_Objstate function, since it is generated from the foundation
--  160427  JanWse STRSC-1778, Added TRUE to also check for blocked in a call to Self_Billing_Dev_Reason_API.Exist
--  150826  KiSalk Bug 124068, Set Qty_Confirmeddiff of Customer order line in Unmatch_Line___.
--  150710  Hecolk KES-1027, Cancelling Preliminary Self-Billing CO invoice 
--  150526  IsSalk KES-510, Modified cursors with Customer_Order_Delivery_TAB to filter out cancelled CO deliver lines.
--  150826  KiSalk Bug 124068, Set Qty_Confirmeddiff of Customer order line in Unmatch_Line___.
--  150819  PrYaLK Bug 121587, Modified Check_Insert___() and Check_Update___() to fetch both customer_part_conv_factor and cust_part_invert_conv_fact
--  150819         by calling Customer_Order_Line_API.Get().
--  150714  HimRlk Bug 119098, Modified Unmatch_Line_From_Sbi_Message to unmatch all the connected lines using a loop. Modified Do_Unmatch___
--  150714         to handling unmatching of several connected self-billing lines.
--  130220  NipKlk Bug 108331, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to retrieve customer_price_conv_fac_ and used it in calculating cust_part_price.
--  111215  MaMalk Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111118  ChJalk Added user allowed company filter to the view SELF_BILLING_ITEM.
--  111108  ChJalk Removed user_allowed_site filter from the view SELF_BILLING_ITEM.
--  111104  ChJalk Added user_allowed_site filter to the view SELF_BILLING_ITEM.
--  100903  Swralk SAP-SUCKER DF-77, Modified in functions Price_Deviation_Exist and Get_Total_Invoiced_Curr to use correct rounding.
--  100820  Swralk SAP-SUCKER DF-77, Modified in procedure Unmatch_Line___ to use correct rounding.
--  100514  KRPELK Merge Rose Method Documentation.
--  100104  MaRalk Modified Get_Client_Values___/InvoiceCreated as Invoice Created in order to match with the old client value. 
--  091222  MaRalk Modified the state machine according to the new template.
--  090924  MaMalk Removed constant state_separator_. Removed unused code in Finite_State_Init___.
--  ------------------------- 14.0.0 -----------------------------------------
--  091218  JuMalk Bug 87680, Modified Create_Invoice_Item__ to call Cust_Delivery_Inv_Ref_Api.Create_Reference.
--  090122  DaZase Resizing price_source_db in view comment.
--  080102  MaMalk Bug 65955, Modified the code to add attribue cust_unit_part_price and made the necessary modifications
--  080102         to handle the newly added attribute. Added function Price_Deviation_Exist. Moved the setting of price_deviation to
--  080102         Unpack_Check_Insert___ and Unpack_Check_Update___. Made price_deviation mandatory and did the necessary modifications
--  080102         to handle it.
--  060412  RoJalk Enlarge Identity - Changed view comments.
--  -------------------- 13.4.0 ----------------------------------------------
--  060118  CsAmlk Added columns price_source and price_source_db to SELF_BILLING_ITEM view.
--  050927  NuFilk Added method Get_Total_Qty_To_Invoice and modified method Get_Total_Invoiced_Curr.
--  050905  JaBalk Added methods Get_Objstate, Unmatch_Line_From_Sbi_Message.
--  050816  IsAnlk Modified Unmatch_Line___ and Create_invoice_Item__ to calculate amounts correctly.
--  050803  IsAnlk Modified matched_gross_amount,matched_tax_amount as gross_amount,tax_amount.
--  050729  IsAnlk Changed vat_curr_amount as tax_curr_amount.
--  050727  JaBalk Called Ext_Inc_Sbi_Item_API.Set_Line_Unmatch if sbi line is created from message.
--  050727  JaBalk Called Ext_Inc_Sbi_Item_API.Set_Line_Unmatch in Unmatch_Line___.
--  050727  NuFilk Modified method Unmatch_Line___ set the fetch for the get_sb_item_info cursor variables correctly.
--  050720  UsRalk Implemented match_type as an IID.
--  050712  RaKalk Added columns invoice_id, invoice_no, series_id.
--  050712         Modified Insert___ to update the company field in header when the first line is being entered.
--  050712         Modified Create_Invoice_Item__ to save the invoice information once the invoice item is created.
--  050711  UsRalk Moved Get_Next_Sbi_Line_No___ to OrderSelfBillingManager.
--  050708  UsRalk Moved Connect_Matched_Line_To_Sbi___ and Save_Matched_Lines to OrderSelfBillingManager.
--  050708  IsAnlk Added close_type_db_ as a parameter to Connect_Matched_Line_To_Sbi___.
--  050707  NuFilk Removed function Calculate_Tax_Lines and renamed Make_self_Billing_Invoice to Create_Invoice_Item__.
--  050707  RaKalk Removed columns CUST_VAT_CURR_AMOUNT, CUST_GROSS_CURR_AMOUNT, CUST_FEE_CODE from Self_Billing_Item_Tab
--  050707         Removed CUST_VAT_CURR_AMOUNT, CUST_GROSS_CURR_AMOUNT, CUST_FEE_CODE parameters from  Connect_Matched_Line_To_Sbi___
--  050707         Passes vat_curr_amount, new_curr_amount, gross_curr_amout to headers update totals method.
--  050706  IsAnlk Modified confirmed_sbi_qty_ calculation to sales unit of measure.
--  050706  IsAnlk Modified Make_Self_Billing_Item__ to update sale_unit_price when invoice line is created.
--  050705  IsAnlk Modified Make_Self_Billing_Item__ to update provisional_price when invoice line is created.
--  050705  JaBalk Removed uncommented code for close_type_ in Connect_Matched_Line_To_Sbi___.
--  050705  JaBalk Added New_Item__ method.
--  050705  JaBalk Added reason column.
--  050705  JaBalk rec_.discount and line_rec_.order_discount replaced with zero
--  050705         in call to Customer_Order_Inv_Item_API.Create_Invoice_Item
--  050704  JaBalk Added Check_Before_Insert___.
--  050701  NaWalk Removed the attribute close_type.
--  050630  MaEelk Added public method Order_Line_Exist.
--  050630  JaBalk Changed the Discount to included_discount and order_discount
--  050630         to included_total_order_discount in Connect_Matched_Line_To_Sbi___
--  050628  JaBalk Removed the Customer_Order_Delivery_API.Modify_Qty_To_Invoice from Make_Self_Billing_Item__.
--  050519  JoEd   Changed Make_Self_Billing_Item__ to handle update of outstanding sales.
--  050302  GeKalk Modified to add Customer_No, Customer_Part_No and Contract as attributes to Self_Billing_Item LU.
--  050117  GeKalk Modified the type of a parameter in method Connect_Matched_Line_To_Sbi___.
--  041220  IsAnlk Changed references to CREATE_SELF_BILLING as UNMATCHED_SBI_DELIVERIES.
--  041215  GeKalk Connected price_deviation to Fnd_Boolean.
--  041214  GeKalk Removed public method Price_Deviation_Exist and replaced it in OrderSelfBillingManager LU
--  041214         and added a new column price_deviation to self_billing_item_tab.
--  041214  RaKalk Code CleanUp. Modified method Make_Self_Billing_Item__.
--  011213  IsAnlk Made Unmatch_Lines as Unmatch_Line__.
--  041213  GeKalk Modified Connect_Matched_Line_To_Sbi__ to update correct line totals and Price_Deviation_Exist to match the customer prices.
--  041209  GeKalk Changed the parameters of Connect_Matched_Line_To_Sbi___ and removed the method Modify.
--  041208  RaKalk Added Functions Get_Next_Sbi_Line_No___, Connect_Matched_Line_To_Sbi___,Do_Unmatch___,Unmatch_Line___.
--  041208         Restructured code in Save_Matched_Lines.
--  041208         Modified to calls to Self_Billing_Header_API.Update_Totals methods to call the parameter based method.
--  041207  GeKalk Added new public method Close_Delivery_Exist.
--  041201  GeKalk Added new public methods Price_Deviation_Exist,Get_Total_Invoiced_Curr and a new view SBI_CO_LINES_DEVIATIONS.
--  040817  DhWilk Modified the last parameter of General_SYS.Init_Method in Unmatch_All & Unmatch_Lines
--  040226  IsWilk Removed the SUBSTRB for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  021203  GeKaLk   Add new public method Calculate_Tax_Lines and modified Make_Self_Billing_Item.
--  021113  GeKalk   Modified Save_Matched_Lines and Unmatch_All to clear the attr_ for totals.
--  021024  GeKalk   Moved SBI_DELIVERY_NOT_INVOICED and SBI_QUANTITY_DEVIATIONS to DeliverCustomerOrder
--                   and SBI_PRICE_DEVIATIONS InvoiceCustomerOrder LU.
--  021004  GEKA  Call Id 89151, Removed the division by the conv_factor of cust_part_price in Make_Self_Billing_Item__.
--  021002  GEKA  Call Id 87328, Modified Unpack_Check_Insert___ and Save_MAtched_Lines
--                to calculate the vat_amounts when there is no vat_code specified.
--  020925  GEKA  Call Id 85592, Changed the state 'SbiCreated' to 'InvoiceCreated'.
--  020925  GEKA  Call Id 88078, Modified the length of the delnote_no field from 3 to 15.
--  020613  GEKA  Modified Save_Matched_Lines to calculate cust_part_price in Sales U/M.
--  020611  GEKA  Modified Save_Matched_Lines to calculate qty_to_match using qty_to_invoice.
--  020610  GEKA  Add new views for the Self Billing Queries.
--  020604  GEKA  Add new attribute cust_unit_sales_qty.
--  020603  GEKA  Remove customer discount values from the item table and view.
--  020524  GEKA  Modified Save_Matched_Lines to get and save all the matched lines
--                from the client at once.
--  020520  GEKA  Changed Save_Matched_Lines to get the delnote_no from the client.
--  020516  GEKA  Changed Save_Matched_Lines to add match type and match date.
--  020515  GEKA  Changed SELF_BILLING_ITEM view.
--  020514  GEKA  Changed Make_Self_Billing_Item__ to update the Invoiced Qty in
--                Customer Order Delivery and Customer Order Line.
--  020507  GEKA  Added  new attribute price_conv_factor,conv_factor to SELF_BILLING_ITEM_TAB.
--  020429  GEKA  Added a new attribute Matched_Date and match_type to SELF_BILLING_ITEM_TAB.
--  020423  GEKA  Added a new attribute Matched_Qty to SELF_BILLING_ITEM_TAB.
--  020418  GEKA  Modified function Save_Matched_Lines.
--  020417  GEKA  Modified new method Unmatch_All and Unmatch_Lines.
--  020409  GEKA  Modified new method Unmatch_All and Unmatch_Lines.
--  020411  GEKA  Added new attribute close_type.
--  020409  GEKA  Added new method Unmatch_All and Unmatch_Lines.
--  020409  ARAM  Modify Make_Self_Billing_Item__.
--  020407  ARAM  Added new public method Moify.
--  030402  ARAM  Modified Make_Self_Billing_Item__.
--  020402  ARAM  Added Make_Self_Billing_Item__.
--  020402  GeKa  Removed Make_self_Billing_Invoice and added a new function Save_Matched_Lines.
--  020325  ARAM  Modified Make_self_Billing_Invoice
--  020325  GeKa  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Do_Unmatch___ (
   sbi_no_      IN VARCHAR2,
   sbi_line_no_ IN NUMBER DEFAULT NULL )
IS
   sbi_linerec_ SELF_BILLING_ITEM_TAB%ROWTYPE;

   CURSOR get_sb_item_info IS
      SELECT sbi_line_no, message_id, message_row
        FROM SELF_BILLING_ITEM_TAB
       WHERE sbi_no = sbi_no_;
       
   matched_msg_id_  NUMBER := -1;
   matched_msg_row_ NUMBER := -1;
   
   CURSOR get_sbi_line_records(sbi_no_ VARCHAR2, message_id_ NUMBER, message_row_ NUMBER) IS
      SELECT sbi_line_no
        FROM SELF_BILLING_ITEM_TAB
        WHERE sbi_no = sbi_no_
        AND message_id  = message_id_
        AND message_row = message_row_;
BEGIN

   IF (sbi_line_no_ IS NULL) THEN  -- Unmatching all lines
      FOR linerec_ IN get_sb_item_info LOOP
         Unmatch_Line___(sbi_no_, linerec_.sbi_line_no);
         -- remove corresponding incoming message line if exist
         IF ((linerec_.message_id IS NOT NULL) AND ((matched_msg_id_ != linerec_.message_id) OR (matched_msg_row_ != linerec_.message_row))) THEN
            Ext_Inc_Sbi_Item_API.Set_Line_Unmatch(linerec_.message_id, linerec_.message_row);
            matched_msg_id_  := linerec_.message_id;
            matched_msg_row_ := linerec_.message_row;
         END IF;
      END LOOP;
   ELSE
      sbi_linerec_ := Get_Object_By_Keys___(sbi_no_, sbi_line_no_);
      IF (sbi_linerec_.message_id IS NOT NULL) THEN
         -- Unmatch all the invoice lines connected to the same incoming self-billing invoice line  
         FOR linerec_ IN get_sbi_line_records(sbi_no_, sbi_linerec_.message_id, sbi_linerec_.message_row) LOOP
            Unmatch_Line___(sbi_no_, linerec_.sbi_line_no); -- Unmatching a single line
         END LOOP;
      ELSE
         Unmatch_Line___(sbi_no_, sbi_line_no_); -- Unmatching a single line - Manual Addition
      END IF;
      -- remove corresponding incoming message line if exist
      IF (sbi_linerec_.message_id IS NOT NULL) THEN
         Ext_Inc_Sbi_Item_API.Set_Line_Unmatch(sbi_linerec_.message_id, sbi_linerec_.message_row);
      END IF;
   END IF;
END Do_Unmatch___;


PROCEDURE Get_Line_Amounts__ (
   line_tax_dom_amount_       OUT NUMBER,
   line_net_dom_amount_       OUT NUMBER,
   line_gross_dom_amount_     OUT NUMBER,
   line_tax_curr_amount_      OUT NUMBER,
   line_net_curr_amount_      OUT NUMBER,
   line_gross_curr_amount_    OUT NUMBER,
   cust_unit_part_price_      IN  NUMBER,
   cust_unit_sales_qty_       IN  NUMBER,
   cust_price_conv_factor_    IN  NUMBER,
   company_                   IN  VARCHAR2,
   source_ref1_               IN  VARCHAR2,
   source_ref2_               IN  VARCHAR2,
   source_ref3_               IN  VARCHAR2,
   source_ref4_               IN  VARCHAR2,
   currency_code_             IN  VARCHAR2 )
IS 
   use_price_incl_tax_            VARCHAR2(5);
   currency_rounding_             NUMBER;
   cust_sales_price_              NUMBER;
BEGIN
   currency_rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   cust_sales_price_   := ROUND((cust_unit_sales_qty_ / cust_price_conv_factor_) * cust_unit_part_price_, currency_rounding_);
   use_price_incl_tax_  := Customer_Order_API.Get_Use_Price_Incl_Tax_Db(source_ref1_);   

   IF (use_price_incl_tax_ = 'TRUE') THEN
      line_gross_curr_amount_ := cust_sales_price_;
   ELSE
      line_net_curr_amount_   := cust_sales_price_;
   END IF;
   
   Tax_Handling_Order_Util_API.Get_Amounts(line_tax_dom_amount_, 
                                           line_net_dom_amount_, 
                                           line_gross_dom_amount_, 
                                           line_tax_curr_amount_, 
                                           line_net_curr_amount_, 
                                           line_gross_curr_amount_, 
                                           company_, 
                                           Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                           source_ref1_,
                                           source_ref2_,
                                           source_ref3_,
                                           source_ref4_, 
                                           '*'); 
END Get_Line_Amounts__;


PROCEDURE Unmatch_Line___ (
   sbi_no_      IN VARCHAR2,
   sbi_line_no_ IN NUMBER )
IS
   sbi_header_rec_           Self_Billing_Header_API.Public_Rec;
   remrec_                   SELF_BILLING_ITEM_TAB%ROWTYPE;
   objid_                    VARCHAR2(2000);
   objversion_               VARCHAR2(2000);
   confirmed_sbi_qty_        NUMBER;
   cust_price_conv_factor_   NUMBER;
   line_total_net_amount_    NUMBER := 0;
   line_total_tax_amount_    NUMBER := 0;
   line_total_gross_amount_  NUMBER := 0;
   line_tax_dom_amount_      NUMBER; 
   line_net_dom_amount_      NUMBER; 
   line_gross_dom_amount_    NUMBER;
   head_total_net_amount_    NUMBER := 0;
   head_total_tax_amount_    NUMBER := 0;
   head_total_gross_amount_  NUMBER := 0;
BEGIN

   remrec_              := Lock_By_Keys___(sbi_no_, sbi_line_no_);
   Get_Id_Version_By_Keys___(objid_,objversion_, sbi_no_, sbi_line_no_);

   confirmed_sbi_qty_   := Customer_Order_Delivery_API.Get_Confirmed_Sbi_Qty(remrec_.deliv_no);
   confirmed_sbi_qty_   := confirmed_sbi_qty_ - remrec_.matched_qty;

   --modify the confirmed_sbi_qty in Customer_Order_Delivery_tab
   Customer_Order_Delivery_API.Modify_Confirmed_Sbi_Qty(remrec_.deliv_no,
                                                        confirmed_sbi_qty_);
                                                        
   
   Customer_Order_API.Set_Line_Qty_Confirmeddiff(remrec_.order_no, 
                                                 remrec_.line_no, 
                                                 remrec_.rel_no, 
                                                 remrec_.line_item_no, 
                                                 (Customer_Order_Line_API.Get_Qty_Confirmeddiff(remrec_.order_no, remrec_.line_no, remrec_.rel_no, remrec_.line_item_no) + remrec_.matched_qty - remrec_.customer_qty));

   sbi_header_rec_            := Self_Billing_Header_API.Get(sbi_no_);
   cust_price_conv_factor_    := NVL(Ext_Inc_Sbi_Item_API.Get_Price_Conv_Factor(remrec_.message_id, remrec_.message_row), 1);

   Get_Line_Amounts__(line_tax_dom_amount_, 
                       line_net_dom_amount_, 
                       line_gross_dom_amount_, 
                       line_total_tax_amount_, 
                       line_total_net_amount_, 
                       line_total_gross_amount_, 
                       remrec_.cust_unit_part_price,
                       remrec_.cust_unit_sales_qty,
                       cust_price_conv_factor_, 
                       sbi_header_rec_.company, 
                       remrec_.order_no,
                       remrec_.line_no,
                       remrec_.rel_no,
                       remrec_.line_item_no,
                       sbi_header_rec_.currency_code);

   head_total_net_amount_     := NVL(sbi_header_rec_.matched_net_amount, 0)   - line_total_net_amount_;
   head_total_tax_amount_     := NVL(sbi_header_rec_.tax_amount, 0)   - line_total_tax_amount_;
   head_total_gross_amount_   := NVL(sbi_header_rec_.gross_amount, 0) - line_total_gross_amount_ ;

   Self_Billing_Header_API.Update_Totals(sbi_no_,
                                         head_total_gross_amount_,
                                         head_total_net_amount_,
                                         head_total_tax_amount_);

   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Unmatch_Line___;


-- Check_Before_Insert___
--   Perform checks needed before inserting a new record.
PROCEDURE Check_Before_Insert___ (
   newrec_ IN SELF_BILLING_ITEM_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.sbi_no IS NOT NULL) THEN
      Self_Billing_Header_API.Exist(newrec_.sbi_no);
   END IF;
   IF (newrec_.line_item_no IS NOT NULL) THEN
      Customer_Order_Line_API.Exist(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   END IF;
   IF (newrec_.deliv_no IS NOT NULL) THEN
       Customer_Order_Delivery_API.Exist(newrec_.deliv_no);
   END IF;
   IF (newrec_.price_deviation IS NOT NULL) THEN
       Fnd_Boolean_API.Exist_Db(newrec_.price_deviation);
   END IF;
   IF (newrec_.reason IS NOT NULL) THEN
       Self_Billing_Dev_Reason_API.Exist(newrec_.reason, TRUE);
   END IF;
END Check_Before_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     self_billing_item_tab%ROWTYPE,
   newrec_     IN OUT NOCOPY self_billing_item_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF Fnd_Session_API.Is_Odp_Session THEN 
      Self_Billing_Header_API.Update_Totals(newrec_.sbi_no);
   END IF;
END Update___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SELF_BILLING_ITEM_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   header_company_    VARCHAR2(20);
   head_attr_         VARCHAR2(2000);
   info_              VARCHAR2(2000);
BEGIN
   header_company_ := Self_Billing_Header_API.Get_Company(newrec_.sbi_no);
   IF (header_company_ IS NULL) THEN
      header_company_ := Site_API.Get_Company(newrec_.contract);
      Client_SYS.Clear_Attr(head_attr_);
      Client_SYS.Add_To_Attr('COMPANY', header_company_, head_attr_);
      Self_Billing_Header_API.MODIFY(newrec_.sbi_no,info_,head_attr_);
   ELSE
      IF (header_company_ != Site_API.Get_Company(newrec_.contract)) THEN
         Error_SYS.Record_General('SelfBillingItem','COMPANYMISMATCH: Site :P1 does not belong to company :P2',newrec_.contract, header_company_);
      END IF;
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT self_billing_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   customer_price_conv_fac_ NUMBER;
   customer_rec_            Customer_Order_Line_API.Public_Rec;
BEGIN
   customer_rec_            := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   customer_price_conv_fac_ := NVL(Ext_Inc_Sbi_Item_API.Get_Price_Conv_Factor(newrec_.message_id ,newrec_.message_row), 1);
   newrec_.cust_part_price  := newrec_.cust_unit_part_price/((newrec_.price_conv_factor * customer_price_conv_fac_ *
                               NVL(customer_rec_.customer_part_conv_factor, 1))/NVL(customer_rec_.cust_part_invert_conv_fact, 1));
   newrec_.price_deviation  := Price_Deviation_Exist(newrec_);
   newrec_.tax_curr_amount  := NVL(newrec_.tax_curr_amount, 0);
   Check_Before_Insert___(newrec_);
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     self_billing_item_tab%ROWTYPE,
   newrec_ IN OUT self_billing_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   customer_price_conv_fac_ NUMBER;
   customer_rec_            Customer_Order_Line_API.Public_Rec;
BEGIN
   customer_rec_            := Customer_Order_Line_API.Get(newrec_.order_no, newrec_.line_no, newrec_.rel_no, newrec_.line_item_no);
   customer_price_conv_fac_ := NVL(Ext_Inc_Sbi_Item_API.Get_Price_Conv_Factor(newrec_.message_id ,newrec_.message_row), 1);
   newrec_.cust_part_price  := newrec_.cust_unit_part_price/((newrec_.price_conv_factor * customer_price_conv_fac_ * 
                               NVL(customer_rec_.customer_part_conv_factor, 1))/NVL(customer_rec_.cust_part_invert_conv_fact, 1));

   IF (newrec_.cust_unit_part_price != oldrec_.cust_unit_part_price) THEN
      newrec_.price_deviation := Price_Deviation_Exist(newrec_);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Create_Invoice_Item__
--   Creates self billing item.
PROCEDURE Create_Invoice_Item__ (
   sbi_no_      IN VARCHAR2,
   sbi_line_no_ IN NUMBER,
   invoice_id_  IN NUMBER )
IS
   item_id_                NUMBER;
   qty_invoiced_           NUMBER := 0;
   qty_to_invoice_         NUMBER := 0;
   info_                   VARCHAR2(32000);
   attr_                   VARCHAR2(2000);
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   co_rec_                 Customer_Order_API.Public_Rec;
   line_rec_               Customer_Order_Line_API.Public_Rec;
   customer_rec_           Cust_Ord_Customer_API.Public_Rec;
   rec_                    SELF_BILLING_ITEM_TAB%ROWTYPE;
   oldrec_                 SELF_BILLING_ITEM_TAB%ROWTYPE;
   newrec_                 SELF_BILLING_ITEM_TAB%ROWTYPE;   
   company_                VARCHAR2(20);
   contract_               VARCHAR2(5);
   indrec_                 Indicator_Rec;
BEGIN
   rec_ := Get_Object_By_Keys___(sbi_no_, sbi_line_no_);

   IF (Customer_Order_Line_API.Get_Objstate(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no) IN ('Delivered', 'PartiallyDelivered')) THEN
      qty_to_invoice_ := Customer_Order_Delivery_API.Get_Qty_To_Invoice(rec_.deliv_no);

      IF (qty_to_invoice_ > 0) THEN

         line_rec_ := Customer_Order_Line_API.Get(rec_.order_no,
                                                  rec_.line_no,
                                                  rec_.rel_no,
                                                  rec_.line_item_no);

         co_rec_   := Customer_Order_API.Get(rec_.order_no);

         customer_rec_ := Cust_Ord_Customer_API.Get(co_rec_.customer_no);

         IF customer_rec_.match_type IN ('AUTOCREATE','AUTOCREATEPOST') THEN
            IF (customer_rec_.update_price_from_sbi = 'TRUE' OR
                line_rec_.provisional_price         = 'TRUE') THEN
               Customer_Order_Line_API.Modify_Sale_Unit_Price(rec_.order_no,
                                                              rec_.line_no,
                                                              rec_.rel_no,
                                                              rec_.line_item_no,
                                                              rec_.cust_part_price);
            END IF;
         ELSE
            IF (line_rec_.provisional_price = 'TRUE') THEN
               Customer_Order_Line_API.Modify_Provisional_Price(rec_.order_no,
                                                                rec_.line_no,
                                                                rec_.rel_no,
                                                                rec_.line_item_no,
                                                               'FALSE');
            END IF;
         END IF;

         qty_invoiced_ := rec_.customer_qty;

         Invoice_Customer_Order_API.Create_Sbi_Invoice_Item(item_id_,
                                                            invoice_id_,
                                                            rec_.order_no,
                                                            rec_.line_no,
                                                            rec_.rel_no,
                                                            rec_.line_item_no,
                                                            qty_invoiced_,
                                                            rec_.cust_part_price,
                                                            co_rec_.customer_po_no,
                                                            NULL,
                                                            FALSE );

         -- Update the self_billing_table
         Get_Id_Version_By_Keys___(objid_, objversion_, sbi_no_, sbi_line_no_);

         --Update the line with invoice id
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('INVOICE_ID',invoice_id_, attr_);
         Client_SYS.Add_To_Attr('INVOICE_NO',invoice_id_, attr_);
         Client_SYS.Add_To_Attr('SERIES_ID','PR', attr_);

         oldrec_ := Lock_By_Id___(objid_, objversion_);
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_);

         Client_SYS.Clear_Attr(attr_);
         Sbi_Created__(info_, objid_, objversion_, attr_, 'DO');

         IF (rec_.line_item_no <= 0) THEN            
            contract_ := Customer_Order_API.Get_Contract(rec_.order_no);
            company_  := Site_API.Get_Company(contract_);
            Cust_Delivery_Inv_Ref_API.Create_Reference(rec_.deliv_no, company_, invoice_id_, item_id_); 
                        
            -- Update the outstanding sales record with the invoice keys - and change the expected qty...
            Outstanding_Sales_API.Modify_Self_Billing(rec_.deliv_no, invoice_id_, item_id_, rec_.customer_qty, rec_.qty_to_match);
         END IF;

         -- qty_to_invoice_ := Customer_Order_Delivery_API.Get_Qty_To_Invoice(rec_.deliv_no) - rec_.customer_qty;
         qty_invoiced_   := Customer_Order_Delivery_API.Get_Qty_Invoiced(rec_.deliv_no) + rec_.customer_qty;

         -- Upate the customer_order_delivery table.
         Customer_Order_Delivery_API.Modify_Qty_Invoiced(rec_.deliv_no, qty_invoiced_);
      END IF;

   END IF;
END Create_Invoice_Item__;


-- Unmatch_Line__
--   Unmatch all the selected matched lines for a specific SBI No.
PROCEDURE Unmatch_Line__ (
   sbi_no_      IN VARCHAR2,
   sbi_line_no_ IN NUMBER )
IS
BEGIN
   Do_Unmatch___(sbi_no_,sbi_line_no_);
END Unmatch_Line__;


-- New_Item__
--   Creates a new instance.
PROCEDURE New_Item__ (
   linerec_ IN OUT SELF_BILLING_ITEM_TAB%ROWTYPE)
IS
   attr_       VARCHAR2(2000);
   objid_      SELF_BILLING_ITEM.OBJID%TYPE;
   objversion_ SELF_BILLING_ITEM.OBJVERSION%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   Unpack___(linerec_, indrec_, attr_);
   Check_Insert___(linerec_, indrec_, attr_);
   Insert___(objid_, objversion_, linerec_, attr_);
END New_Item__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Unmatch_All
--   Unmatch all the matched lines for a specific SBI No.
PROCEDURE Unmatch_All (
   sbi_no_ IN VARCHAR2 )
IS
BEGIN

   Do_Unmatch___(sbi_no_);
END Unmatch_All;


-- New
--   Creates a new instance.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_      SELF_BILLING_ITEM_TAB%ROWTYPE;
   newattr_     VARCHAR2(32000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   newattr_ := attr_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
END New;


-- Modify
--   Modify the record
PROCEDURE Modify (
   attr_        IN OUT VARCHAR2,
   sbi_no_      IN     VARCHAR2,
   sbi_line_no_ IN     NUMBER )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   oldrec_      SELF_BILLING_ITEM_TAB%ROWTYPE;
   newrec_      SELF_BILLING_ITEM_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, sbi_no_, sbi_line_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_ , objversion_);
END Modify;


-- Get_Total_Invoiced_Curr
--   Calculate the sum of all the invices made for a specific order line in
--   the customer's currency
@UncheckedAccess
FUNCTION Get_Total_Invoiced_Curr (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   curr_rounding_       NUMBER;
   total_invoiced_curr_ NUMBER;

   CURSOR get_totals(curr_rounding_ IN NUMBER) IS
      SELECT SUM(ROUND(cust_net_curr_amount, curr_rounding_))
      FROM  SELF_BILLING_ITEM_TAB
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_
      AND   rowstate     = 'InvoiceCreated';
BEGIN
   curr_rounding_    := Customer_Order_API.Get_Order_Currency_Rounding(order_no_);

   OPEN get_totals(curr_rounding_);
   FETCH get_totals INTO total_invoiced_curr_;
   IF (get_totals%NOTFOUND) THEN
      total_invoiced_curr_ := 0;
   END IF;
   CLOSE get_totals;

   RETURN NVL(total_invoiced_curr_, 0);
END Get_Total_Invoiced_Curr;


-- Close_Delivery_Exist
--   Check whether the customer order line has been fully delivered and all
--   deliveries for this customer order line have been Closed for further matching.
@UncheckedAccess
FUNCTION Close_Delivery_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_                NUMBER;
   fully_matched_       BOOLEAN;
   line_state_          VARCHAR2(20);
   closed_for_delivery_ VARCHAR2(5);

   CURSOR matched_lines IS
      SELECT 1
        FROM customer_order_delivery_tab
       WHERE order_no        = order_no_
         AND line_no         = line_no_
         AND rel_no          = rel_no_
         AND line_item_no    = line_item_no_
         AND qty_to_invoice != confirmed_sbi_qty
         AND cancelled_delivery = 'FALSE';
BEGIN
   -- Fetch the deliveries made for a order line which are not fully matched.
   OPEN matched_lines;
   FETCH matched_lines INTO temp_;
   IF (matched_lines%NOTFOUND) THEN
      fully_matched_ := TRUE;
   END IF;
   CLOSE matched_lines;

   -- check whether the line is fully delivered.
   line_state_ := Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_);

   --if the line is fully delivered and the line is
   --fully matched through self billing the line is closed for delivery.
   IF (line_state_ IN ('Delivered','Invoiced') AND fully_matched_ ) THEN
      closed_for_delivery_ := 'TRUE';
   ELSE
      closed_for_delivery_ := 'FALSE';
   END IF;

   RETURN closed_for_delivery_;
END Close_Delivery_Exist;


-- Order_Line_Exist
--   This method is used to check whether the customer order line is
--   connected to a self billing item.
@UncheckedAccess
FUNCTION Order_Line_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   dummy_   NUMBER;
   CURSOR get_order_line IS
      SELECT 1
        FROM customer_order_delivery_tab
       WHERE order_no      = order_no_
         AND line_no       = line_no_
         AND rel_no        = rel_no_
         AND line_item_no  = line_item_no_
         AND cancelled_delivery = 'FALSE';
BEGIN
   OPEN get_order_line;
   FETCH get_order_line INTO dummy_;
   IF (get_order_line%FOUND) THEN
      CLOSE get_order_line;
      RETURN 'TRUE';
   ELSE
      CLOSE get_order_line;
      RETURN 'FALSE';
   END IF;
END Order_Line_Exist;


-- Unmatch_Line_From_Sbi_Message
--   This will unmatch the self billing line.
PROCEDURE Unmatch_Line_From_Sbi_Message (
   message_id_   IN NUMBER,
   message_line_ IN NUMBER )
IS
   CURSOR get_sb_item_info IS
      SELECT sbi_no, sbi_line_no
        FROM SELF_BILLING_ITEM_TAB
       WHERE message_id  = message_id_
         AND message_row = message_line_;
BEGIN

   FOR linerec_ IN get_sb_item_info LOOP
      Unmatch_Line___ (linerec_.sbi_no, linerec_.sbi_line_no);
   END LOOP;
   
END Unmatch_Line_From_Sbi_Message;


-- Get_Total_Qty_To_Invoice
--   Calculate the sum of all the Quantity to Invoice for the specific order line.
@UncheckedAccess
FUNCTION Get_Total_Qty_To_Invoice (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   contract_             VARCHAR2(5);
   company_              VARCHAR2(20);
   rounding_             NUMBER;
   total_qty_to_invoice_ NUMBER;

   CURSOR get_totals(rounding_ IN NUMBER) IS
      SELECT SUM(ROUND(qty_to_invoice, rounding_))
      FROM  SBI_CO_LINES_DEVIATIONS
      WHERE order_no     = order_no_
      AND   line_no      = line_no_
      AND   rel_no       = rel_no_
      AND   line_item_no = line_item_no_;

BEGIN
   contract_ := Customer_Order_API.Get_Contract(order_no_);
   company_  := Site_API.Get_Company(contract_);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));

   OPEN get_totals(rounding_);
   FETCH get_totals INTO total_qty_to_invoice_;
   IF (get_totals%NOTFOUND) THEN
      total_qty_to_invoice_ := 0;
   END IF;
   CLOSE get_totals;

   RETURN NVL(total_qty_to_invoice_, 0);
END Get_Total_Qty_To_Invoice;


-- Price_Deviation_Exist
--   This method checks whether a price deviation exist or not
@UncheckedAccess
FUNCTION Price_Deviation_Exist (
   linerec_ IN SELF_BILLING_ITEM_TAB%ROWTYPE ) RETURN VARCHAR2
IS
   sales_price_total_ NUMBER;
   init_part_price_   NUMBER;
   curr_rounding_     NUMBER;
   company_           VARCHAR2(20);
   price_deviation_   VARCHAR2(5) := 'FALSE';
   order_line_rec_    Customer_Order_Line_API.Public_Rec;
BEGIN
   order_line_rec_ := Customer_Order_Line_API.Get(linerec_.order_no,
                                                  linerec_.line_no,
                                                  linerec_.rel_no,
                                                  linerec_.line_item_no);

   sales_price_total_ := Customer_Order_Line_API.Get_Sale_Price_Total(linerec_.order_no,
                                                                      linerec_.line_no,
                                                                      linerec_.rel_no,
                                                                      linerec_.line_item_no);

   init_part_price_ := sales_price_total_/(order_line_rec_.buy_qty_due * order_line_rec_.price_conv_factor);

   company_       := Site_API.Get_Company(linerec_.contract);
   curr_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, linerec_.currency_code);

   IF (ROUND(init_part_price_, curr_rounding_) != ROUND(linerec_.cust_part_price, curr_rounding_)) THEN
      price_deviation_ := 'TRUE';
   END IF;

   RETURN price_deviation_;
END Price_Deviation_Exist;

PROCEDURE Do_Sbi_Cancelled (
   sbi_no_      IN VARCHAR2,
   sbi_line_no_ IN NUMBER )
IS
   info_        VARCHAR2(32000);
   attr_        VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   oldrec_      self_billing_item_tab%ROWTYPE;
   newrec_      self_billing_item_tab%ROWTYPE;   
   
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, sbi_no_, sbi_line_no_);
   
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.invoice_id := NULL;
   newrec_.invoice_no := NULL;
   newrec_.series_id  := NULL;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   
   Sbi_Cancelled__ (info_,
                    objid_,
                    objversion_,
                    attr_,
                    'DO'); 
END Do_Sbi_Cancelled;
