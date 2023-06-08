-----------------------------------------------------------------------------
--
--  Logical unit: SelfBillingHeader
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220107  PumJlk  SC21R2-7050, Recalculated net_curr_amount_, tax_curr_amount_ and gross_curr_amount_ in Get_Default_Sbi_Info___() when customer order partially delivered.
--  200113  Hiralk  GESPRING20-1895, Modified Create_Invoice() to pass the invoice_reason_id.
--  190930  SURBLK  Added Raise_Uer_Not_Allowed_Error___ to handle error messages and avoid code duplication.
--  181214  KHVESE  SCUXXW4-9475, Added method Update_Totals.
--  181205  KHVESE  SCUXXW4-9475, Added method Get_Lines_To_Invoice.
--  160728  NWeelk  FINHR-1229, Modified method Get_Default_Sbi_Info___ to set net_curr_amount_ to CUST_NET_CURR_AMOUNT since CUST_NET_CURR_AMOUNT
--  160728          should be as same as the customer order net curr amount since self billed price was not changed at this point.
--  160803  MeAblk  Bug 127480, Modified Create_Inv_Charge_Lines___() to correctly handle negative charged_qty.
--  150710  Hecolk  KES-1027, Cancelling Preliminary Self-Billing CO invoice 
--  150429  NWeelk   Bug 122325, Modified Create_Inv_Charge_Lines___ to retrieve un-invoiced charge lines correctly by selecting 
--  150429           records which has invoiced_qty less than charged_qty instead of using not equal sign.
--  140901  AyAmlk  Bug 118522, Modified Create_Inv_Charge_Lines___() so that only one invoice line will be created for a charge line.
--  140901          And for unit charges, the matched_qty will be invoiced.
--  140505  MiKulk  Bug 116341, Merged with PBSC-8419. Modified Create_Invoice in order to change the currency rate accordingly when changing invoice date.
--  131031  RoJalk  Modified customer_id mandatory in the base view to be aligned with the model and included not null checks.
--  130703  GayDLK  Bug 110953, Modified Create_Sbi_Line___() by increasing the length of rec_attr_ to 32000 characters.
--  121120  AyAmlk  Bug 106747, Modified Create_Invoice() to get the invoice_date_ and pass it as a parameter when creating Customer Invoice header.
--  111215  MaMalk  Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111103  ChJalk  Added user allowed company filter to the view SELF_BILLING_HEADER.
--  100514  KRPELK  Merge Rose Method Documentation.
--  100104  MaRalk  Modified Get_Client_Values___/InvoiceCreated as Invoice Created in order to match with the old client value. 
--  091222  MaRalk  Modified the state machine according to the new template.
--  090924  MaMalk  Removed constants inst_Invoice_ and state_separator_. Removed unused code in Finite_State_Init___.
--  ------------------------- 14.0.0 ----------------------------------------
--  080630  MaRalk  Bug 68628, Modified procedure Create_Invoice in order to split invoices per currency rate type. 
--  080630          Added parameter currency_rate_type_ to function Get_Invoice_Order_No___ and modified accordingly.
--  080130  NaLrlk  Bug 70005, Modified the method Create_Invoice for adding new parameter del_terms_location to server call 
--  080130          Customer_Order_Inv_Head_API.Create_Invoice_Head().
--  080102   MaMalk  Bug 65955, Modified Get_Default_Sbi_Info___ to replace cust_part_price with cust_unit_part_price.
--  071224  MaRalk  Bug 64486, Modified the method Create_Invoice to pass the currency rate type when creating the invoice header.
--  070907  Cpeilk  Call 148010, Removed addition of invoice fee for self billing invoices.
--  070117  RaKalk  Modified Create_Invoice method to fetch del terms desc and ship via desc from 
--  070117          Order_Delivery_Term_API and Mpccom_Ship_Via_API packages
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060606  KaDilk  Modified method Create_Invoice.Remove the dymanic call Invoice_API.Complete_Invoice.
--  060602  MiKulk  Modified the calls to Customer_Order_Inv_Head_API.Create_Invoice_Head 
--  060602          by removing the obsolete parameters
--  060124  JaJalk  Added Assert safe annotation.
--  060104  NaLsLk  FIPR374, Replaced calls for Invoice3_API with Invoice_API.
--  050920  MaEelk  Removed unused variables from the code.
--  050905  JaBalk  Removed methods Get_Sbi_no_By_Msg_Id, Get_State, Get_Sb_Ref_No
--  050905          Added method Get_Invoiced_Sbi_By_Msg 
--  050826  JaBalk  Added an error message IN_DEL_CONF_EXIST in Create Invoice method.
--  050817  JaBalk  Changed the client value of InvoiceCreated to Invoice Created.
--  050816  JaBalk  Done GUI changes.
--  050816  JaBalk  Changed Get_Sbi_No_By_Msg_Id to Get_Preliminary_Sbi_By_Msg.
--  050803  IsAnlk  Modified matched_gross_amount,matched_tax_amount as gross_amount,tax_amount.
--  050729  IsAnlk  Changed matched_vat_amount as matched_tax_amount_ in Update_Totals.
--  050729  IsAnlk  Changed vat_curr_amount as tax_curr_amount.
--  050728  IsAnlk  Modified Insert___ and Update___.
--  050721  RaKalk  Added method Create_Inv_Charge_Lines___. Modified Create_Invoice method to call Create_Inv_Charge_Lines___ method.
--  050715  UsRalk  Changed the references to Save_Matched_Lines to Add_Matched_Lines.
--  050712  RaKalk  Removed the fields Contract, InvoiceNo, InvoiceId, SericeID moved them to the line level.
--  050712          Removed contract parameter from Create_Sbi_Header___, Added contract parameter to Get_Invoice_Order_No___
--  050712          Modified method Insert___, Update___, Unpack_Check_Insert___, Unpack_Check_Update___, Create_Invoice, Check_Before_Insert___.
--  050711  RaKalk  Modified Unpack_Check_Update___ Prepare_Insert___ to check whether the company is as same as the company in the items
--  050711          and to set the company to the users default company when creating header manualy.
--  050708  UsRalk  Replaced references to Self_Billing_Item_API.Save_Matched_Lines with Order_Self_Billing_Manager_API.Save_Matched_Lines.
--  050707  NuFilk  Renamed method Make_Self_Billing_Invoice to Create_Invoice and modified
--  050707          call to Self_Billing_Item_API.Make_Self_Billing_Item__. Modified Get_Default_Sbi_Info___.
--  050706  RaSilk  Modified Make_Self_Billing_Invoice added parameter value NJS to call Customer_Order_Inv_Head_API.Create_Invoice_Head().
--  050705  IsAnlk  Added private method Provisional_Price_Exist__.
--  050704  JaBalk  Added Check_Before_Insert___.
--  050701  JaBalk  Added Create_Header__.
--  041220  IsAnlk Changed references to CREATE_SELF_BILLING as UNMATCHED_SBI_DELIVERIES.
--  041217  IsAnlk Modified Get_Default_Sbi_Info___ by adding deliv_no as parameter for total calculations.
--  041214  RaKalk Code cleanUp. Modified methods Make_Self_Billing_Invoice,Unpack_Check_Insert___,Insert___,
--  041214         Create_Sbi_Line___,Get_Default_Sbi_Info___ Added Method Get_Invoice_Order_No___
--  041213  IsAnlk Modified Get_Default_Sbi_Info___. Done code review changes.
--  041210  YoMiJp Calculation Logic in the Get_Default_SBI_Info has been changed to use methods in the OrderSelfBillingManager.apy
--  041210  YoMiJp Added Create_Self_Billing_Invoice__ Procedure to create a new self billing invoice header and items based on the attr_.
--  041208  RaKalk Added procedure Update_Totals, Removed Attr String based Update_Totals method.
--  041119  GeKalk Modified the check for existing Sb Reference No in Update___.
--  041116  GeKalk Added a new method Sb_Reference_No_Exist__ and call it in Insert___ and Update___.
--  041013  JaJalk Modified the method Make_Self_Billing_Invoice to pass the self-billing ref to invoice
--  041013         and removed the old codes added in the self billing merge accordingly.
--  040817  DhWilk Modified the last parameter of General_SYS.Init_Method in Get_Base_For_Adv_Inv_Db
--  040706  LaBolk Modified parameters of method call Customer_Order_Inv_Head_API.Create_Invoice_Head in Make_Self_Billing_Invoice to reflect changes in LCS patch 42707.
--  040226  IsWilk Removed the SUBSTRB for Unicode Changes.
--  ---------------EDGE Package Group 3 Unicode Changes----------------------
--  021114  GeKaLk Changed Make_Self_Billing_Invoice() to get the count of distinct order no's and clear the attr.
--  021113  GeKaLk Call Id 91392, Changed Insert___ to insert a value to currency_code.
--  021112  GeKaLk Call Id 91285, Added a new methods Get_State and Get_Sbi_No_By_Msg.
--  021106  GeKaLk Call Id 91121, Changed Prepare_Insert___() to insert total values.
--  021101  GeKaLk Call Id 90638, Changed Make_Self_Billing_Invoice() to remove order no from the Customer Invoice when multiple order lines exist.
--  021101  GeKaLk Call Id 90821, Changed Insert___ and Unpack_Check_Update___ to generate the Sbi_No.
--  ------------------------------- VAP Shipment/Self-Billing Merge -----------
--  020607  GeKaLk  Added a new public procedure Remove.
--  020613  ArAmLk  State change to SbiCreated in incoming message when creating the customer invoice.
--  020613  GeKaLk  Modify Make_Self_Billing_Invoice() to updat the invoice_tab with Sb_Reference_No.
--  020607  GeKaLk  Added a new attribute currency_code.
--  020607  GeKaLk  Modify Unpack_Check_Insert___.
--  020531  GeKaLk  Added public method Charge_Exist.
--  020531  ArAmLk  Rename status 'SbiCreated' to 'InvoiceCreated' and added public method Get_Sbi_No_By_Msg_Id.
--  020521  GeKaLk  Modify Make_Self_Billing_Invoice().
--  020521  GeKaLk  Added series_id to Make_Self_Billing_Invoice().
--  020520  GeKaLk  Added conditions for Contract to Prepare_Insert___ and Insert___ .
--  020507  GeKaLk  Modified Make_Self_Billing_Invoice to update the invoice_no. Prepare_Insert___
--  020507  GeKaLk  Added a new attribute contract.
--  020509  ArAmLk  Added a public methods New and Get_Sb_Ref_By_Inv_Id.
--  020507  GeKaLk  Added a new attribute invoice_id.
--  020430  GeKaLk  Removed attributes ext_sbi_no and cust_sb_reference and added a new attribute
--                  sb_reference_no to SELF_BILLING_HEADER_TAB.
--  020418  GeKaLk  Added a new attribute company.
--  020409  ArAmLk  Modified Make_Self_Billing_Invoice.
--  020402  ArAmLk  Added Make_Self_Billing_Invoice.
--  020325  GeKaLk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_Sbi_Header___ (
   sbi_no_      OUT VARCHAR2,
   customer_no_ IN  VARCHAR2,
   currency_    IN  VARCHAR2 )
IS
   objid_        VARCHAR2(100)    ;
   objversion_   VARCHAR2(200)    ;
   attr_         VARCHAR2(2000)   :=  NULL ;
   newrec_       SELF_BILLING_HEADER_TAB%ROWTYPE   ;
   indrec_       Indicator_Rec;
BEGIN

   --Adding Attr
   Client_SYS.Add_To_Attr('CUSTOMER_ID'          , customer_no_ ,   attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE'        , currency_    ,   attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE'        , SYSDATE      ,   attr_);
   Client_SYS.Add_To_Attr('GROSS_AMOUNT'         , 0            ,   attr_);
   Client_SYS.Add_To_Attr('MATCHED_NET_AMOUNT'   , 0            ,   attr_);
   Client_SYS.Add_To_Attr('TAX_AMOUNT'           , 0            ,   attr_);

   --Insert a Record
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   --Set  sbi_no_ as output
   sbi_no_ := newrec_.sbi_no ;

END Create_Sbi_Header___;


PROCEDURE Create_Sbi_Line___ (
   attr_         IN VARCHAR2,
   deliv_no_     IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   ---- attr_  contains { SBI_NO, ORDER_NO,  LINE_NO,  REL_NO,  LINE_ITEM_NO, DELNOTE_NO }
   rec_attr_ VARCHAR2(32000) := attr_ ;

   CURSOR sbi_line IS
      SELECT *
        FROM UNMATCHED_SBI_DELIVERIES
       WHERE order_no     = order_no_
         AND line_no      = line_no_
         AND rel_no       = rel_no_
         AND line_item_no = line_item_no_
         AND deliv_no     = deliv_no_;

   rec_ sbi_line%ROWTYPE;

BEGIN

   OPEN sbi_line;
   FETCH sbi_line into rec_;
   CLOSE sbi_line;

   Get_Default_Sbi_Info___ (rec_attr_,
                            rec_,
                            order_no_,
                            line_no_,
                            rel_no_,
                            line_item_no_);

   Order_Self_Billing_Manager_API.Add_Matched_Lines(rec_attr_) ;

END Create_Sbi_Line___;


PROCEDURE Get_Default_Sbi_Info___ (
   attr_         IN OUT VARCHAR2,
   viewrec_      IN     UNMATCHED_SBI_DELIVERIES%ROWTYPE,
   order_no_     IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   rel_no_       IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
   --Variables for  attr_
   delnote_no_               NUMBER := NULL;
   customer_qty_             NUMBER := 0;
   cust_unit_part_price_     NUMBER := 0;
   cust_sales_qty_           NUMBER := 0;
   net_curr_amount_          NUMBER := 0;
   tax_curr_amount_          NUMBER := 0;
   gross_curr_amount_        NUMBER := 0;
   revised_qty_due_          NUMBER := 0;
   rounding_                 NUMBER;
   
BEGIN

      delnote_no_             := viewrec_.delnote_no;
      customer_qty_           := viewrec_.customer_qty;
      cust_unit_part_price_   := Order_Self_Billing_Manager_API.Get_Customer_Part_Price(order_no_ ,
                                                                                        line_no_ ,
                                                                                        rel_no_ ,
                                                                                        line_item_no_);
      cust_sales_qty_         := viewrec_.customer_part_buy_qty;
      
      net_curr_amount_        := Order_Self_Billing_Manager_API.Get_Net_Curr_Amount(order_no_,
                                                                                    line_no_,
                                                                                    rel_no_,
                                                                                    line_item_no_);
      tax_curr_amount_        := Order_Self_Billing_Manager_API.Get_Tax_Curr_Amount(order_no_,
                                                                                    line_no_,
                                                                                    rel_no_,
                                                                                    line_item_no_ );
      gross_curr_amount_      := Order_Self_Billing_Manager_API.Get_Gross_Curr_Amount(order_no_,
                                                                                      line_no_,
                                                                                      rel_no_,
                                                                                      line_item_no_);
                                                                                      
      revised_qty_due_        := viewrec_.revised_qty_due;
      rounding_               := Currency_Code_API.Get_Currency_Rounding(viewrec_.company, viewrec_.currency_code);
      net_curr_amount_        := ROUND((net_curr_amount_ * customer_qty_ / revised_qty_due_),  rounding_);
      tax_curr_amount_        := ROUND((tax_curr_amount_ * customer_qty_ / revised_qty_due_),  rounding_);                                                       
      gross_curr_amount_      := ROUND((gross_curr_amount_ * customer_qty_ / revised_qty_due_),  rounding_);                                                                                   

      Client_SYS.Add_To_Attr('DELNOTE_NO'            , delnote_no_             ,attr_  ) ;
      Client_SYS.Add_To_Attr('CUSTOMER_QTY'          , customer_qty_           ,attr_  ) ;
      Client_SYS.Add_To_Attr('CUST_NET_CURR_AMOUNT'  , net_curr_amount_        ,attr_  ) ;
      Client_SYS.Add_To_Attr('CUST_UNIT_PART_PRICE'  , cust_unit_part_price_   ,attr_  ) ;
      Client_SYS.Add_To_Attr('CUST_UNIT_SALES_QTY'   , cust_sales_qty_         ,attr_  ) ;
      Client_SYS.Add_To_Attr('NET_CURR_AMOUNT'       , net_curr_amount_        ,attr_  ) ;
      Client_SYS.Add_To_Attr('TAX_CURR_AMOUNT'       , tax_curr_amount_        ,attr_  ) ;
      Client_SYS.Add_To_Attr('GROSS_CURR_AMOUNT'     , gross_curr_amount_      ,attr_  ) ;
      attr_   :=   attr_  ||  'END'  ;

END Get_Default_Sbi_Info___;


FUNCTION Get_Invoice_Order_No___ (
   sbi_no_             IN VARCHAR2,
   contract_           IN VARCHAR2,
   currency_rate_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_no_ SELF_BILLING_ITEM_TAB.order_no%TYPE;
BEGIN

   SELECT sbi.order_no INTO order_no_
     FROM self_billing_item_tab sbi, customer_order_tab co
    WHERE sbi.sbi_no = sbi_no_ 
      AND sbi.contract = contract_
      AND sbi.rowstate = 'Matched'
      AND sbi.order_no = co.order_no 
      AND ((co.currency_rate_type = currency_rate_type_) OR (co.currency_rate_type IS NULL AND currency_rate_type_ IS NULL ))
 GROUP BY sbi.order_no;

   RETURN order_no_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      RETURN NULL;
END Get_Invoice_Order_No___;


-- Check_Before_Insert___
--   Perform checks needed before inserting a new record.
PROCEDURE Check_Before_Insert___ (
   newrec_ IN SELF_BILLING_HEADER_TAB%ROWTYPE )
IS
   fnd_user_   VARCHAR2(20) := Fnd_Session_API.Get_Fnd_User();
BEGIN

   -- put all validations done inside and outside the while loop in Unpack_Check_Insert
   -- since the create_header__ method bypass the while loop and it uses rec parameter add
   -- all validations here.

   IF (newrec_.customer_id IS NOT NULL) THEN
       Customer_Info_API.Exist(newrec_.customer_id);
   END IF;

   IF newrec_.company IS NOT NULL THEN
      Company_API.Exist(newrec_.company);
      BEGIN
         User_Finance_API.Exist(newrec_.company, fnd_user_);
      EXCEPTION
         WHEN OTHERS THEN
         Raise_Uer_Not_Allowed_Error___(newrec_.company, fnd_user_);
      END;
   END IF;

END Check_Before_Insert___;


PROCEDURE Create_Inv_Charge_Lines___ (
   invoice_id_ IN NUMBER,
   sbi_no_     IN VARCHAR2 )
IS
   CURSOR get_charge_info IS
      SELECT coc.*
        FROM customer_order_charge_tab coc
       WHERE coc.collect       = 'INVOICE'
         AND ABS(coc.invoiced_qty)  < ABS(coc.charged_qty)
         AND (coc.order_no, coc.line_no, coc.rel_no, coc.line_item_no) in (SELECT sbi.order_no, sbi.line_no, sbi.rel_no, sbi.line_item_no
                                                                             FROM self_billing_item_tab sbi
                                                                            WHERE sbi.sbi_no       = sbi_no_
                                                                              AND sbi.invoice_id   = invoice_id_);     
             
   CURSOR get_qty_invoiced(order_no_ IN VARCHAR2, line_no_ IN VARCHAR2, rel_no_ IN VARCHAR2, line_item_no_ IN NUMBER ) IS
      SELECT SUM(sbi.matched_qty)
        FROM self_billing_item_tab sbi
       WHERE sbi.sbi_no       = sbi_no_
         AND sbi.invoice_id   = invoice_id_
         AND sbi.order_no     = order_no_
         AND sbi.line_no      = line_no_
         AND sbi.rel_no       = rel_no_
         AND sbi.line_item_no = line_item_no_;

   charge_qty_to_invoice_ NUMBER;
BEGIN

   FOR charge_rec_ IN get_charge_info LOOP
      IF charge_rec_.unit_charge = 'TRUE' THEN
         -- Set charged qty for unit charge lines.
         OPEN get_qty_invoiced(charge_rec_.order_no, charge_rec_.line_no, charge_rec_.rel_no, charge_rec_.line_item_no);
         FETCH get_qty_invoiced INTO charge_qty_to_invoice_;
         CLOSE get_qty_invoiced;
      ELSE
         charge_qty_to_invoice_ := charge_rec_.charged_qty;
      END IF;
      Invoice_Customer_Order_API.Create_Invoice_Charge_Line(charge_rec_.order_no,
                                                            charge_rec_.line_no,
                                                            charge_rec_.rel_no,
                                                            charge_rec_.line_item_no,
                                                            invoice_id_,
                                                            Customer_Order_API.Get_Customer_Po_No(charge_rec_.order_no),
                                                            charge_rec_.sequence_no,
                                                            charge_qty_to_invoice_);

   END LOOP;

END Create_Inv_Charge_Lines___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('GROSS_AMOUNT', 0, attr_);
   Client_SYS.Add_To_Attr('TAX_AMOUNT', 0, attr_);
   Client_SYS.Add_To_Attr('MATCHED_NET_AMOUNT', 0, attr_);
   Client_SYS.Add_To_Attr('COMPANY', USER_PROFILE_SYS.Get_Default('COMPANY',fnd_session_api.Get_Fnd_User()), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SELF_BILLING_HEADER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN

   newrec_.sbi_no := Get_Next_Sbi_No__;

   IF (newrec_.currency_code IS NULL) THEN
      newrec_.currency_code := Cust_Ord_Customer_API.Get_Currency_Code(newrec_.customer_id);
   END IF;

   IF (newrec_.message_id IS NOT NULL) THEN
      newrec_.gross_amount := 0;
      newrec_.matched_net_amount := 0;
      newrec_.tax_amount := 0;
   END IF;

   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('SBI_NO', newrec_.sbi_no, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', newrec_.currency_code, attr_);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT self_billing_header_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
BEGIN   
   Check_Before_Insert___(newrec_);
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     self_billing_header_tab%ROWTYPE,
   newrec_ IN OUT self_billing_header_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS  
   dummy_      NUMBER;
   fnd_user_   VARCHAR2(20) := Fnd_Session_API.Get_Fnd_User();

   CURSOR get_items IS
      SELECT 1
        FROM SELF_BILLING_ITEM_TAB
       WHERE sbi_no = newrec_.sbi_no;
BEGIN
   IF indrec_.company THEN
      OPEN get_items;
      FETCH get_items INTO dummy_;
      IF (get_items%FOUND) THEN
         CLOSE get_items;
         Error_SYS.Record_General(lu_name_,'COMPANYNOCHANGE: Company cannot be changed when there are matched deliveries.');
      END IF;
      CLOSE get_items;

      IF newrec_.company IS NOT NULL THEN
         Company_API.Exist(newrec_.company);
         BEGIN
            User_Finance_API.Exist(newrec_.company, fnd_user_);
         EXCEPTION
            WHEN OTHERS THEN
           Raise_Uer_Not_Allowed_Error___(newrec_.company, fnd_user_);
         END;
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


PROCEDURE Raise_Uer_Not_Allowed_Error___(
   company_  VARCHAR2,
   fnd_user_ VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_,'COMPANYNOTALLOWED2: Company :P1 is not allowed for the user :P2',company_, fnd_user_);
END Raise_Uer_Not_Allowed_Error___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Get_Next_Sbi_No__ RETURN VARCHAR2
IS
   next_id_ SELF_BILLING_HEADER_TAB.sbi_no%TYPE;
BEGIN
   SELECT sbi_no_seq.nextval
   INTO next_id_
   FROM dual;
   RETURN next_id_;
END Get_Next_Sbi_No__;


@UncheckedAccess
FUNCTION Sb_Reference_No_Exist__ (
   sb_reference_no_ IN VARCHAR2,
   customer_id_     IN VARCHAR2 ) RETURN NUMBER
IS
   temp_   NUMBER;

   CURSOR sb_ref_no IS
      SELECT 1
        FROM SELF_BILLING_HEADER_TAB
       WHERE sb_reference_no = sb_reference_no_
         AND customer_id     = customer_id_;
BEGIN
   OPEN sb_ref_no;
   FETCH sb_ref_no INTO temp_;
   IF (sb_ref_no%NOTFOUND) THEN
      temp_  := 0;
   END IF;
   CLOSE sb_ref_no;

   RETURN temp_;
END Sb_Reference_No_Exist__;


PROCEDURE Create_Self_Billing_Invoice__ (
   sbi_no_      OUT VARCHAR2,
   customer_no_ IN  VARCHAR2,
   currency_    IN  VARCHAR2,
   contract_    IN  VARCHAR2,
   attr_        IN  VARCHAR2 )
IS
   full_attr_       VARCHAR2(32000);
   ptr_             NUMBER;
   name_            VARCHAR2(30);
   value_           VARCHAR2(2000);
   order_no_        VARCHAR2(12) ;
   line_no_         VARCHAR2(4)  ;
   rel_no_          VARCHAR2(4)  ;
   line_item_no_    NUMBER       ;
   deliv_no_        NUMBER       ;

BEGIN

   --Creating Header Record
   Create_Sbi_Header___ (sbi_no_,  customer_no_,  currency_) ;

   --Create new attr_ for calling "Add_Matched_Lines"
   ptr_ := NULL;
   Client_SYS.Clear_Attr(full_attr_);

   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
     IF (name_ = 'ORDER_NO')   THEN
        Client_SYS.Add_To_Attr('SBI_NO',   sbi_no_,    full_attr_ );
        order_no_  :=  value_  ;
        Client_SYS.Add_To_Attr('ORDER_NO', order_no_,  full_attr_ ) ;
     ELSIF (name_ = 'LINE_NO') THEN
        line_no_   :=  value_  ;
        Client_SYS.Add_To_Attr('LINE_NO',  line_no_,   full_attr_ ) ;
     ELSIF (name_ = 'REL_NO')  THEN
        rel_no_    :=  value_  ;
        Client_SYS.Add_To_Attr('REL_NO',   rel_no_,    full_attr_ ) ;
     ELSIF (name_ = 'LINE_ITEM_NO')   THEN
        line_item_no_  := Client_SYS.Attr_Value_To_Number(value_) ;
        Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_  ,full_attr_ ) ;
     ELSIF (name_ = 'DELIV_NO' )    THEN
        deliv_no_  :=  value_ ;
        Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_    ,full_attr_ ) ;
     ELSIF (name_ = 'END' )           THEN
        Create_Sbi_Line___(full_attr_,
                           deliv_no_,
                           order_no_,
                           line_no_,
                           rel_no_,
                           line_item_no_ );
     ELSE
        Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
     END IF;

   END LOOP;

END Create_Self_Billing_Invoice__;


-- Create_Header__
--   Creates an SBI header record when doing automatic match.
PROCEDURE Create_Header__ (
   sbi_no_         OUT VARCHAR2,
   sbi_header_rec_ IN SELF_BILLING_HEADER_TAB%ROWTYPE )
IS
   newrec_     SELF_BILLING_HEADER_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   newrec_ := sbi_header_rec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
    --Set  sbi_no_ as output
   sbi_no_ := newrec_.sbi_no;
END Create_Header__;


-- Provisional_Price_Exist__
--   This method will return TRUE if the conneceted customer order lines
--   have provisional price flag TRUE
@UncheckedAccess
FUNCTION Provisional_Price_Exist__ (
   sbi_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   found_  VARCHAR2(5) := 'FALSE';

  CURSOR get_order_no IS
     SELECT order_no, line_no, rel_no, line_item_no
       FROM self_billing_item_tab
      WHERE sbi_no = sbi_no_;
BEGIN
   FOR order_rec_ IN get_order_no LOOP
      IF (Customer_Order_Line_API.Get_Provisional_Price_Db(order_rec_.order_no,
                                                           order_rec_.line_no,
                                                           order_rec_.rel_no,
                                                           order_rec_.line_item_no) = 'TRUE') THEN
         found_ := 'TRUE';
         EXIT;
      ELSE
         found_ := 'FALSE';
      END IF;
   END LOOP;

   RETURN found_;
END Provisional_Price_Exist__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Update_Totals (
   sbi_no_      IN VARCHAR2 )
IS
   sbi_header_rec_           SELF_BILLING_HEADER_API.Public_Rec;
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

   CURSOR get_sbi_line_records IS
      SELECT *
        FROM SELF_BILLING_ITEM_TAB
        WHERE sbi_no = sbi_no_;
BEGIN
   sbi_header_rec_ := Self_Billing_Header_API.Get(sbi_no_);

   FOR sbi_line_rec_ IN get_sbi_line_records LOOP
      cust_price_conv_factor_    := NVL(Ext_Inc_Sbi_Item_API.Get_Price_Conv_Factor(sbi_line_rec_.message_id, sbi_line_rec_.message_row), 1);

      Self_Billing_Item_API.Get_Line_Amounts__(line_tax_dom_amount_, 
                                               line_net_dom_amount_, 
                                               line_gross_dom_amount_, 
                                               line_total_tax_amount_, 
                                               line_total_net_amount_, 
                                               line_total_gross_amount_, 
                                               sbi_line_rec_.cust_unit_part_price,
                                               sbi_line_rec_.cust_unit_sales_qty,
                                               cust_price_conv_factor_, 
                                               sbi_header_rec_.company, 
                                               sbi_line_rec_.order_no,
                                               sbi_line_rec_.line_no,
                                               sbi_line_rec_.rel_no,
                                               sbi_line_rec_.line_item_no,
                                               sbi_header_rec_.currency_code);
   
      head_total_net_amount_     := head_total_net_amount_ + line_total_net_amount_;
      head_total_tax_amount_     := head_total_tax_amount_ + line_total_tax_amount_;
      head_total_gross_amount_   := head_total_gross_amount_ + line_total_gross_amount_ ;
      
   END LOOP;
   Update_Totals(sbi_no_,
                 head_total_gross_amount_,
                 head_total_net_amount_,
                 head_total_tax_amount_);
END Update_Totals;


PROCEDURE Update_Totals (
   sbi_no_               IN VARCHAR2,
   gross_amount_         IN NUMBER,
   matched_net_amount_   IN NUMBER,
   tax_amount_           IN NUMBER,
   modified_date_        IN DATE DEFAULT SYSDATE )
IS
   attr_       VARCHAR2(2000);
   oldrec_     SELF_BILLING_HEADER_TAB%ROWTYPE;
   newrec_     SELF_BILLING_HEADER_TAB%ROWTYPE;
   newattr_    VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('GROSS_AMOUNT', gross_amount_,  attr_);
   Client_SYS.Add_To_Attr('MATCHED_NET_AMOUNT', matched_net_amount_,    attr_);
   Client_SYS.Add_To_Attr('TAX_AMOUNT', tax_amount_,    attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', modified_date_,         attr_);
   oldrec_  := Lock_By_Keys___(sbi_no_);
   newrec_  := oldrec_;
   newattr_ := attr_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Update___(oldrec_, newrec_, indrec_, newattr_);
   Update___(objid_, oldrec_, newrec_, newattr_, objversion_, TRUE);
END Update_Totals;


-- Create_Invoice
--   Creates self billing invoices.
PROCEDURE Create_Invoice (
   company_     IN OUT VARCHAR2,
   sbi_no_      IN     VARCHAR2,
   customer_no_ IN     VARCHAR2 )
IS
   no_matched_lines_ BOOLEAN;
   dummy1_           NUMBER;
   dummy2_           VARCHAR2(50);
   dummy3_           NUMBER;
   info_             VARCHAR2(32000);
   attr_             VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   order_no_         SELF_BILLING_ITEM_TAB.order_no%TYPE;
   inv_order_no_     SELF_BILLING_ITEM_TAB.order_no%TYPE;
   curr_contract_    VARCHAR2(5);
   invoice_id_       NUMBER;

   dummy4_             VARCHAR2(10); 
   currency_rate_type_ VARCHAR2(10); 
   invoice_date_     DATE := NULL;
   sbi_header_rec_   Self_Billing_Header_API.Public_Rec;

   CURSOR get_order_no(sbi_line_no_ VARCHAR2) IS
      SELECT order_no
        FROM self_billing_item_tab
       WHERE sbi_no      = sbi_no_
         AND sbi_line_no = sbi_line_no_
         AND rowstate    = 'Matched';
   -- gelr: invoice_reason, added invoice_reason_id
   CURSOR get_order_header_data IS
      SELECT contract, authorize_code, date_entered, bill_addr_no, customer_no_pay,
             customer_no_pay_addr_no, customer_po_no, cust_ref,
             delivery_terms, del_terms_location, forward_agent_id, ship_via_code,
             ship_addr_no, label_note, note_id, wanted_delivery_date, pay_term_id, currency_code, currency_rate_type,
             use_price_incl_tax, invoice_reason_id
        FROM customer_order_tab
       WHERE order_no = order_no_;
   
   order_head_rec_ get_order_header_data%ROWTYPE;

   CURSOR get_matched_lines IS
      SELECT sb.sbi_line_no, sb.contract, sb.deliv_no, co.currency_rate_type
      FROM self_billing_item_tab sb, customer_order_tab co
      WHERE sb.sbi_no   = sbi_no_
      AND sb.rowstate = 'Matched'
      AND sb.order_no = co.order_no
      ORDER BY sb.contract, co.currency_rate_type, sb.sbi_line_no;

BEGIN

   --check whether there are any matched lines .
   OPEN get_matched_lines;
   FETCH get_matched_lines INTO dummy1_, dummy2_, dummy3_, dummy4_; 

   IF (get_matched_lines%FOUND) THEN
      CLOSE get_matched_lines;

      sbi_header_rec_ := Get(sbi_no_);
      company_   := sbi_header_rec_.company;

      -- don't create invoice if any of the line has Incorrect_Del_Confirmation_Db checked.
      FOR line_rec_ IN get_matched_lines LOOP
         IF (Customer_Order_Delivery_API.Get_Incorrect_Del_Conf_Db(line_rec_.deliv_no) = 'TRUE') THEN
            Error_SYS.Record_General(lu_name_, 'IN_DEL_CONF_EXIST: Cannot create self billing invoice to SBI no :P1 since there are lines exist with the Incorrect Delivery Confirmation checked. Incorrect Delivery Confirmation has to be unchecked or the delivery line/lines have to be Unmatched and Removed from the SBI.', sbi_no_);
         END IF;
      END LOOP;

      -- Create invoice lines to above created customer invoice.
      FOR line_rec_ IN get_matched_lines LOOP
         --We should create a header for each site
         IF (((curr_contract_ IS NULL) OR (line_rec_.contract != curr_contract_)) OR (NVL(line_rec_.currency_rate_type, Database_SYS.string_null_) != NVL(currency_rate_type_, Database_SYS.string_null_))) THEN
         
            -- if we have already created an invoice we must add charges if any
            IF (invoice_id_ IS NOT NULL) THEN
               Create_Inv_Charge_Lines___(invoice_id_, sbi_no_);
            END IF;

            curr_contract_ := line_rec_.contract;

            currency_rate_type_ := line_rec_.currency_rate_type;

            -- Create customer invoice head.
            OPEN get_order_no(line_rec_.sbi_line_no);
            FETCH get_order_no INTO order_no_;
            CLOSE get_order_no;

            OPEN get_order_header_data;
            FETCH get_order_header_data INTO order_head_rec_;
            CLOSE get_order_header_data;

            inv_order_no_ := Get_Invoice_Order_No___(sbi_no_, line_rec_.contract, currency_rate_type_);
            
            invoice_date_ := Ext_Inc_Sbi_Head_API.Get_Invoice_Date(sbi_header_rec_.message_id);

            Customer_Order_Inv_Head_API.Create_Invoice_Head(
                  invoice_id_,
                  company_,
                  inv_order_no_,
                  customer_no_,
                  order_head_rec_.customer_no_pay,
                  Order_Coordinator_API.Get_Name(order_head_rec_.authorize_code),
                  order_head_rec_.date_entered,
                  order_head_rec_.cust_ref,
                  Mpccom_Ship_Via_API.Get_Description(order_head_rec_.ship_via_code),
                  order_head_rec_.forward_agent_id,
                  order_head_rec_.label_note,
                  Order_Delivery_Term_API.Get_Description(order_head_rec_.delivery_terms),
                  order_head_rec_.del_terms_location,
                  order_head_rec_.pay_term_id,
                  order_head_rec_.currency_code,
                  order_head_rec_.ship_addr_no,
                  order_head_rec_.customer_no_pay_addr_no,
                  order_head_rec_.bill_addr_no,
                  order_head_rec_.wanted_delivery_date,
                  'SELFBILLDEB',
                  NULL,                         -- number_reference
                  NULL,                         -- series_reference
                  line_rec_.contract,
                  'NJS',                        -- js_invoice_state_db_
                  order_head_rec_.currency_rate_type,
                  'TRUE',                       -- collect_
                  NULL,                         -- rma_no_
                  NULL,                         -- shipment_id_
                  NULL,                         -- adv_invoice_
                  NULL,                         -- adv_pay_base_date_
                  sbi_header_rec_.sb_reference_no,
                  'FALSE',                      -- use_ref_inv_curr_rate_
                  NULL,                         -- ledger_item_id_          
                  NULL,                         --ledger_item_series_id_   
                  NULL,                         -- ledger_item_version_id_  
                  NULL,                         -- aggregation_no_          
                  'FALSE',                      -- final_settlement_        
                  NULL,                         -- project_id_              
                  NULL,                         -- tax_id_number_           
                  NULL,                         -- tax_id_type_             
                  NULL,                         -- branch_                  
                  NULL,                         -- supply_country_db_           
                  invoice_date_,
                  order_head_rec_.use_price_incl_tax,
                  NULL,                         --wht_amount_base_
                  NULL,                         --curr_rate_new_
                  NULL,                         --tax_curr_rate_new_
                  NULL,                         --correction_reason_id_
                  NULL,                         --correction_reason_
                  'FALSE',                      --is_simulated_
                  -- gelr: invoice_reason, begin
                  order_head_rec_.invoice_reason_id);
                  -- gelr: invoice_reason, end  

         END IF;

         Self_Billing_Item_API.Create_Invoice_Item__(sbi_no_, line_rec_.sbi_line_no, invoice_id_);
      END LOOP;

      --Create charges for the last invoice
      Create_Inv_Charge_Lines___(invoice_id_, sbi_no_);


      OPEN get_matched_lines;
      FETCH get_matched_lines INTO dummy1_, dummy2_, dummy3_, dummy4_; 
      no_matched_lines_ := get_matched_lines%NOTFOUND;
      CLOSE get_matched_lines;

      --Change the state
      IF (no_matched_lines_) THEN
         Get_Id_Version_By_Keys___(objid_, objversion_, sbi_no_);
         Sbi_Created__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
      -- The self billing invoices should be excluded from adding invoice_fee amount
      Customer_Order_Inv_Head_API.Create_Invoice_Complete(company_, invoice_id_, 'FALSE');
      
   ELSE
      CLOSE get_matched_lines;
      Error_SYS.Record_General(lu_name_, 'NO_SBI_LINES: Cannot create self billing invoice to SBI no :P1 since there are not any lines exist with the status Matched.', sbi_no_);
   END IF;
END Create_Invoice;


-- New
--   Creates a new instance.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS
   newrec_      SELF_BILLING_HEADER_TAB%ROWTYPE;
   newattr_     VARCHAR2(32000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   newattr_ := attr_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Insert___(newrec_, indrec_, newattr_);
   Insert___(objid_, objversion_, newrec_, newattr_);
   info_ := Client_SYS.Get_All_Info;
   attr_ := newattr_;
END New;


-- Modify
--   Modify the attributes of an existing record.
PROCEDURE Modify (
   sbi_no_ IN  VARCHAR2,
   info_   OUT VARCHAR2,
   attr_   IN  VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   new_attr_    VARCHAR2(2000);
   oldrec_      SELF_BILLING_HEADER_TAB%ROWTYPE;
   newrec_      SELF_BILLING_HEADER_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   new_attr_ := attr_ ;
   Get_Id_Version_By_Keys___(objid_, objversion_, sbi_no_);
   oldrec_ := Get_Object_By_Id___(objid_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, new_attr_);
   Update___(objid_, oldrec_, newrec_, new_attr_ , objversion_);
END Modify;


-- Charge_Exist
--   Check whether the order lines in the self billing invoice are connected
--   with charges or not.
@UncheckedAccess
FUNCTION Charge_Exist (
   sbi_no_ IN VARCHAR2 ) RETURN NUMBER
IS
  found_  NUMBER := 0;

  CURSOR get_order_no IS
     SELECT order_no
       FROM self_billing_item_tab
      WHERE sbi_no = sbi_no_;
BEGIN
   FOR order_rec_ IN get_order_no LOOP
      IF (Customer_Order_API.Exist_Charges__(order_rec_.order_no) = 1) THEN
         found_ := 1;
      END IF;
   END LOOP;

   RETURN found_;
END Charge_Exist;


-- Get_Sb_Ref_By_Inv_Id
--   This will return the self billing reference number for given invoice
--   and compay combination if exist.
@UncheckedAccess
FUNCTION Get_Sb_Ref_By_Inv_Id (
   company_     IN VARCHAR2,
   invoice_id_  IN NUMBER )  RETURN VARCHAR2
IS
   no_of_recs_  NUMBER;
   sb_ref_      SELF_BILLING_HEADER_TAB.sb_reference_no%TYPE;

   CURSOR no_of_records IS
      SELECT COUNT(sbh.sb_reference_no)
        FROM SELF_BILLING_HEADER_TAB sbh
       WHERE sbh.company = company_
         AND sbh.rowstate = 'InvoiceCreated'
         AND EXISTS (SELECT 1
                       FROM self_billing_item_tab sbi
                      WHERE sbi.sbi_no     = sbh.sbi_no
                        AND sbi.invoice_id = invoice_id_)
      ORDER BY sbh.sb_reference_no;

   CURSOR get_sb_ref IS
      SELECT sbh.sb_reference_no
        FROM SELF_BILLING_HEADER_TAB sbh
       WHERE sbh.company = company_
         AND sbh.rowstate = 'InvoiceCreated'
         AND EXISTS (SELECT 1
                       FROM self_billing_item_tab sbi
                      WHERE sbi.sbi_no     = sbh.sbi_no
                        AND sbi.invoice_id = invoice_id_);
BEGIN
   OPEN no_of_records;
   FETCH no_of_records INTO no_of_recs_;
   CLOSE no_of_records;

   IF (no_of_recs_ = 1) THEN
      OPEN get_sb_ref;
      FETCH get_sb_ref INTO sb_ref_;
      CLOSE get_sb_ref;
      RETURN sb_ref_;
   ELSE
      RETURN NULL;
   END IF;
END Get_Sb_Ref_By_Inv_Id;


-- Get_Preliminary_Sbi_By_Msg
--   This will return the sbi_no with the state Preliminary for a given message_id.
@UncheckedAccess
FUNCTION Get_Preliminary_Sbi_By_Msg (
   message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   sbi_no_ SELF_BILLING_HEADER_TAB.sbi_no%TYPE;

   CURSOR get_sbi_no IS
      SELECT sbi_no
        FROM SELF_BILLING_HEADER_TAB
       WHERE message_id = message_id_
         AND rowstate = 'Preliminary';
BEGIN
   OPEN get_sbi_no;
   FETCH get_sbi_no INTO sbi_no_;
   CLOSE get_sbi_no;

   RETURN sbi_no_;
END Get_Preliminary_Sbi_By_Msg;


-- Remove
--   Removes the Self Billing Header.
PROCEDURE Remove (
   info_   OUT VARCHAR2,
   sbi_no_ IN  VARCHAR2 )
IS
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   remrec_      SELF_BILLING_HEADER_TAB%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, sbi_no_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
   info_ := Client_SYS.Get_All_Info;
END Remove;


-- Get_Invoiced_Sbi_By_Msg
--   This will return the sbi_no with the state Invoice Created for a given message_id.
@UncheckedAccess
FUNCTION Get_Invoiced_Sbi_By_Msg (
   message_id_ IN NUMBER ) RETURN VARCHAR2
IS
   sbi_no_ SELF_BILLING_HEADER_TAB.sbi_no%TYPE;

   CURSOR get_sbi_no IS
      SELECT sbi_no
        FROM SELF_BILLING_HEADER_TAB
       WHERE message_id = message_id_
         AND rowstate = 'InvoiceCreated';
BEGIN
   OPEN get_sbi_no;
   FETCH get_sbi_no INTO sbi_no_;
   CLOSE get_sbi_no;

   RETURN sbi_no_;
END Get_Invoiced_Sbi_By_Msg;

PROCEDURE Do_Sbi_Cancelled (
   sbi_no_      IN VARCHAR2 )
IS
   info_        VARCHAR2(32000);
   attr_        VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, sbi_no_);
   Sbi_Cancelled__ (info_,
                    objid_,
                    objversion_,
                    attr_,
                    'DO'); 
END Do_Sbi_Cancelled;


@UncheckedAccess
FUNCTION Get_Lines_To_Invoice (
   sbi_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   lines_to_invoice_ NUMBER;
   CURSOR get_sbi_no IS
      SELECT count(*)
        FROM SELF_BILLING_ITEM_TAB
       WHERE sbi_no_ = sbi_no;
BEGIN
   OPEN get_sbi_no;
   FETCH get_sbi_no INTO lines_to_invoice_;
   CLOSE get_sbi_no;

   RETURN lines_to_invoice_;
END Get_Lines_To_Invoice;
