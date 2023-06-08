-----------------------------------------------------------------------------
--
--  Logical unit: IntersiteProfitManager
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  181118  DiNglk  Bug SCUXXW4-14382, Changed the wordings of two error messages in the method Corr_Intersite_Posting___
--  180829  KiSalk  Bug 143831, In Is_Corrective_Allowed, added conditions and moved slower Intersite_Trans_Exist___ to last, to improve performance.
--  171010  TiRalk  STRSC-12296, Added new methods Reverse_Intersite_Transactions and Reverse_Transaction___ to reverse intersite profitability 
--  171010          related transactions such as INTREV, INTCOS, INTREVR, INTCOSR by using reverse transactions UNINTREV, UNINTCOS, UNINTREVR, UNINTCOSR
--  171010          when cancel the delivered internal customer order.
--  150803  MAHPLK  KES-1081, Added new parameter deliv_no_ to Create_Intersite_Transactions(), Create_Internal_Revenue___(), 
--  150813          Create_Int_Purch_Cost___(), Create_Int_Cost_Sale___() and Create_Int_Cost_Sale_Rec___() methods.
--  150707  IsSalk  KES-905, Added reference-by-name for the parameter list when calling the method Inventory_Transaction_Hist_API.New().
--  150512  IsSalk  KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--  100520  KRPELK  Merge Rose Method Documentation.
--  091001  MaMalk  Modified Corr_Intersite_Posting___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  070530  ChBalk  Bug 64640, Removed General_SYS.Init_Method from function Is_Corrective_Allowed.
--  070206  DaZase  Added qty conversion in methods Create_Corrective_Postings___ and Create_Intersite_Transactions, so 
--                  qty in transactions INTREVR, INTCOSR, INTREVR- and INTREV+ are converted to demand site inventory uom.
--  060420  RoJalk  Enlarge Customer - Changed variable definitions.
--  ------------------------- 13.4.0 ----------------------------------------
--  051112  JoAnSe  Added calls to connect cost and revenue transactions by calling 
--                  Invent_Trans_Interconnect_API.Connect_Transactions
--  050922  NaLrlk  Removed unused variables.
--  050629  MaEelk  Added General_SYS.Init call to Is_Corrective_Allowed.
--  050104  NaLrLk  Added if condition for negative qty to raise the error message in Corrective_Intersite_Posting.
--  041126  AnLaSe  Calculate_Price_Diff returns the price diff per unit.
--  041123  AnLaSe  Removed call to Customer_Order_Line_API.Modify_Base_Price.
--  041117  AnLaSe  Call Customer_Order_Line_API.Modify_Base_Price only if corrective price posting
--                  is made from CO Line.
--  041116  AnLaSe  Set delivering_contract_ for INTREVR+/- in Create_Corrective_Postings___.
--  041028  AnLaSe  Corrected transaction codes in Create_Corrective_Postings___.
--  041027  AnLaSe  Use pricediff per unit in call to Create_Corrective_Postings___.
--                  Called Get_Average_Intersite_Cost instead of Get_Average_Cost.
--                  Set of new transaction codes in Create_Corrective_Postings___.
--  041025  AnLaSe  Modified check for price in Corr_Intersite_Posting___.
--  041013  AnLaSe  Changed from new_price_ to new_base_price_.
--                  Added RMA parameters to Corrective_Intersite_Posting and
--                  Corr_Intersite_Posting___.
--                  Set NULL values for serial, lot_batch_no, eng_chg_level_ and
--                  waiv_dev_rej_no_ when calling Create_Corrective_Postings___.
--                  Added methods Is_Intersite_Allowed___, Intersite_Trans_Exist___
--                  and Is_Costatus_Allowed___.
--  041011  AnLaSe  Added method Is_Corrective_Allowed.
--  041005  AnLaSe  Passed client value for order_type and 'COMPANY OWNED' as
--                  part_ownership in call to Inventory_Transaction_Hist_API.New.
--  041004  AnLaSe  Added validations in method Corr_Intersite_Posting___.
--                  Changed from configuration_no_ to configuration_id_ in
--                  Create_Corrective_Postings___.
--  040928  AnLaSe  Created for Intersite Profitability
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Create_Internal_Revenue___
--   Creates Internal Revenue for delivering/supply site.
--   i.e. Creates transaction INTREV = Internal revenue generated from sales price
--   on internal CO delivered to a site within same company.
PROCEDURE Create_Internal_Revenue___ (
   transaction_id_      OUT NUMBER,
   delivering_contract_ IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   configuration_id_    IN  VARCHAR2,
   lot_batch_no_        IN  VARCHAR2,
   serial_no_           IN  VARCHAR2,
   eng_chg_level_       IN  VARCHAR2,
   waiv_dev_rej_no_     IN  VARCHAR2,
   quantity_            IN  NUMBER,
   company_             IN  VARCHAR2,
   price_               IN  NUMBER,
   co_order_no_         IN  VARCHAR2,
   co_line_no_          IN  VARCHAR2,
   co_rel_no_           IN  VARCHAR2,
   co_line_item_no_     IN  NUMBER,
   deliv_no_            IN  VARCHAR2)
IS
   transaction_code_     VARCHAR2(10);
   new_transaction_id_   NUMBER;
   accounting_id_        NUMBER;
   value_                NUMBER;
   order_type_           VARCHAR2(200);
BEGIN
   transaction_code_ :='INTREV';
   --supply_site = delivering_contract_
   order_type_ := Order_Type_API.Decode('CUST ORDER');

   Inventory_Transaction_Hist_API.New( transaction_id_     => new_transaction_id_    ,
                                       accounting_id_      => accounting_id_         ,
                                       value_              => value_                 ,
                                       transaction_code_   => transaction_code_      ,
                                       contract_           => delivering_contract_   ,
                                       part_no_            => part_no_               ,
                                       configuration_id_   => configuration_id_      ,
                                       location_no_        => NULL                   ,
                                       lot_batch_no_       => lot_batch_no_          ,
                                       serial_no_          => serial_no_             ,
                                       waiv_dev_rej_no_    => waiv_dev_rej_no_       ,
                                       eng_chg_level_      => eng_chg_level_         ,
                                       activity_seq_       => NULL                   ,
                                       project_id_         => NULL                   ,
                                       source_ref1_        => co_order_no_           ,
                                       source_ref2_        => co_line_no_            ,
                                       source_ref3_        => co_rel_no_             ,
                                       source_ref4_        => co_line_item_no_       ,
                                       source_ref5_        => deliv_no_              ,
                                       reject_code_        => NULL                   ,
                                       price_              => NVL(price_, 0)         ,
                                       quantity_           => quantity_              ,
                                       qty_reversed_       => 0                      ,
                                       catch_quantity_     => NULL                   ,
                                       source_             => NULL                   ,
                                       source_ref_type_    => order_type_            ,
                                       owning_vendor_no_   => NULL                   ,
                                       condition_code_     => NULL                   ,
                                       location_group_     => NULL                   ,
                                       part_ownership_db_  => 'COMPANY OWNED'        ,
                                       owning_customer_no_ => NULL                   ,
                                       expiration_date_    => NULL                   );

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL);
   transaction_id_ := new_transaction_id_;
END Create_Internal_Revenue___;


-- Create_Int_Purch_Cost___
--   Creates Internal Revenue for receiving/demand site. Internal Purchase Cost.
--   i.e. Creates transaction INTREVR = Internal revenue received from sales price
--   on internal CO delivered from a site within same company
PROCEDURE Create_Int_Purch_Cost___ (
   transaction_id_     OUT NUMBER,
   contract_           IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   configuration_id_   IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_          IN  VARCHAR2,
   eng_chg_level_      IN  VARCHAR2,
   waiv_dev_rej_no_    IN  VARCHAR2,
   quantity_           IN  NUMBER,
   company_            IN  VARCHAR2,
   price_              IN  NUMBER,
   co_order_no_        IN  VARCHAR2,
   co_line_no_         IN  VARCHAR2,
   co_rel_no_          IN  VARCHAR2,
   co_line_item_no_    IN  NUMBER,
   deliv_no_           IN  VARCHAR2)
IS
   transaction_code_     VARCHAR2(10);
   new_transaction_id_   NUMBER;
   accounting_id_        NUMBER;
   value_                NUMBER;
   order_type_           VARCHAR2(200);
BEGIN
   transaction_code_ :='INTREVR';
   --demand_site = contract_
   order_type_ := Order_Type_API.Decode('CUST ORDER');

   Inventory_Transaction_Hist_API.New( transaction_id_     => new_transaction_id_    ,
                                       accounting_id_      => accounting_id_         ,
                                       value_              => value_                 ,
                                       transaction_code_   => transaction_code_      ,
                                       contract_           => contract_              ,
                                       part_no_            => part_no_               ,
                                       configuration_id_   => configuration_id_      ,
                                       location_no_        => NULL                   ,
                                       lot_batch_no_       => lot_batch_no_          ,
                                       serial_no_          => serial_no_             ,
                                       waiv_dev_rej_no_    => waiv_dev_rej_no_       ,
                                       eng_chg_level_      => eng_chg_level_         ,
                                       activity_seq_       => NULL                   ,
                                       project_id_         => NULL                   ,
                                       source_ref1_        => co_order_no_           , -- Reference from internal CO even if CO is on another site!
                                       source_ref2_        => co_line_no_            ,
                                       source_ref3_        => co_rel_no_             ,
                                       source_ref4_        => co_line_item_no_       ,
                                       source_ref5_        => deliv_no_              ,
                                       reject_code_        => NULL                   ,
                                       price_              => NVL(price_, 0)         ,
                                       quantity_           => quantity_              ,
                                       qty_reversed_       => 0                      ,
                                       catch_quantity_     => NULL                   ,
                                       source_             => NULL                   ,
                                       source_ref_type_    => order_type_            ,
                                       owning_vendor_no_   => NULL                   ,
                                       condition_code_     => NULL                   ,
                                       location_group_     => NULL                   ,
                                       part_ownership_db_  => 'COMPANY OWNED'        ,
                                       owning_customer_no_ => NULL                   ,
                                       expiration_date_    => NULL                   );

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL);

   transaction_id_ := new_transaction_id_;

END Create_Int_Purch_Cost___;


-- Create_Int_Cost_Sale___
--   Create Internal Sales Cost for delivering/supply site
--   i.e. Creates transaction INTCOS = Internal cost of sale generated by internal
--   CO delivered to a site within same company
PROCEDURE Create_Int_Cost_Sale___ (
   transaction_id_      OUT NUMBER,
   delivering_contract_ IN  VARCHAR2,
   part_no_             IN  VARCHAR2,
   configuration_id_    IN  VARCHAR2,
   lot_batch_no_        IN  VARCHAR2,
   serial_no_           IN  VARCHAR2,
   eng_chg_level_       IN  VARCHAR2,
   waiv_dev_rej_no_     IN  VARCHAR2,
   quantity_            IN  NUMBER,
   company_             IN  VARCHAR2,
   cost_                IN  NUMBER,
   co_order_no_         IN  VARCHAR2,
   co_line_no_          IN  VARCHAR2,
   co_rel_no_           IN  VARCHAR2,
   co_line_item_no_     IN  NUMBER,
   deliv_no_            IN  VARCHAR2)
IS
   transaction_code_     VARCHAR2(10);
   new_transaction_id_   NUMBER;
   accounting_id_        NUMBER;
   value_                NUMBER;
   order_type_           VARCHAR2(200);
BEGIN
   transaction_code_ :='INTCOS';
   order_type_ := Order_Type_API.Decode('CUST ORDER');

   --Cost on this transaction should be the same value as the transaction that
   -- triggered intersite profitability transactions (SHIPDIR/SHIPTRAN/INTPODIRIM/PODIRINTIM).

   Inventory_Transaction_Hist_API.New( transaction_id_     => new_transaction_id_    ,
                                       accounting_id_      => accounting_id_         ,
                                       value_              => value_                 ,
                                       transaction_code_   => transaction_code_      ,
                                       contract_           => delivering_contract_   ,
                                       part_no_            => part_no_               ,
                                       configuration_id_   => configuration_id_      ,
                                       location_no_        => NULL                   ,
                                       lot_batch_no_       => lot_batch_no_          ,
                                       serial_no_          => serial_no_             ,
                                       waiv_dev_rej_no_    => waiv_dev_rej_no_       ,
                                       eng_chg_level_      => eng_chg_level_         ,
                                       activity_seq_       => NULL                   ,
                                       project_id_         => NULL                   ,
                                       source_ref1_        => co_order_no_           ,
                                       source_ref2_        => co_line_no_            ,
                                       source_ref3_        => co_rel_no_             ,
                                       source_ref4_        => co_line_item_no_       ,
                                       source_ref5_        => deliv_no_              ,
                                       reject_code_        => NULL                   ,
                                       price_              => NVL(cost_, 0)          ,
                                       quantity_           => quantity_              ,
                                       qty_reversed_       => 0                      ,
                                       catch_quantity_     => NULL                   ,
                                       source_             => NULL                   ,
                                       source_ref_type_    => order_type_            ,
                                       owning_vendor_no_   => NULL                   ,
                                       condition_code_     => NULL                   ,
                                       location_group_     => NULL                   ,
                                       part_ownership_db_  => 'COMPANY OWNED'        ,
                                       owning_customer_no_ => NULL                   ,
                                       expiration_date_    => NULL                   );

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL);
   transaction_id_ := new_transaction_id_;

END Create_Int_Cost_Sale___;


-- Create_Int_Cost_Sale_Rec___
--   Create Internal Cost of Sales for receiving/demand site. Internal purchase
--   cost adjustments.
--   i.e. Creates transaction INTCOSR = Internal cost of sale received from
--   internal CO delivered from a site within same company
PROCEDURE Create_Int_Cost_Sale_Rec___ (
   transaction_id_     OUT NUMBER,
   contract_           IN  VARCHAR2,
   part_no_            IN  VARCHAR2,
   configuration_id_   IN  VARCHAR2,
   lot_batch_no_       IN  VARCHAR2,
   serial_no_          IN  VARCHAR2,
   eng_chg_level_      IN  VARCHAR2,
   waiv_dev_rej_no_    IN  VARCHAR2,
   quantity_           IN  NUMBER,
   company_            IN  VARCHAR2,
   cost_               IN  NUMBER,
   co_order_no_        IN  VARCHAR2,
   co_line_no_         IN  VARCHAR2,
   co_rel_no_          IN  VARCHAR2,
   co_line_item_no_    IN  NUMBER,
   deliv_no_           IN  VARCHAR2)
IS
   transaction_code_     VARCHAR2(10);
   new_transaction_id_   NUMBER;
   accounting_id_        NUMBER;
   value_                NUMBER;
   order_type_           VARCHAR2(200);
BEGIN
   transaction_code_ :='INTCOSR';
   order_type_ := Order_Type_API.Decode('CUST ORDER');

   Inventory_Transaction_Hist_API.New( transaction_id_     => new_transaction_id_    ,
                                       accounting_id_      => accounting_id_         ,
                                       value_              => value_                 ,
                                       transaction_code_   => transaction_code_      ,
                                       contract_           => contract_              ,
                                       part_no_            => part_no_               ,
                                       configuration_id_   => configuration_id_      ,
                                       location_no_        => NULL                   ,
                                       lot_batch_no_       => lot_batch_no_          ,
                                       serial_no_          => serial_no_             ,
                                       waiv_dev_rej_no_    => waiv_dev_rej_no_       ,
                                       eng_chg_level_      => eng_chg_level_         ,
                                       activity_seq_       => NULL                   ,
                                       project_id_         => NULL                   ,
                                       source_ref1_        => co_order_no_           , --Reference from internal CO even if CO is on another site!
                                       source_ref2_        => co_line_no_            ,
                                       source_ref3_        => co_rel_no_             ,
                                       source_ref4_        => co_line_item_no_       ,
                                       source_ref5_        => deliv_no_              ,
                                       reject_code_        => NULL                   ,
                                       price_              => NVL(cost_, 0)          ,
                                       quantity_           => quantity_              ,
                                       qty_reversed_       => 0                      ,
                                       catch_quantity_     => NULL                   ,
                                       source_             => NULL                   ,
                                       source_ref_type_    => order_type_            ,
                                       owning_vendor_no_   => NULL                   ,
                                       condition_code_     => NULL                   ,
                                       location_group_     => NULL                   ,
                                       part_ownership_db_  => 'COMPANY OWNED'        ,
                                       owning_customer_no_ => NULL                   ,
                                       expiration_date_    => NULL                   );

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL);
   transaction_id_ := new_transaction_id_;

END Create_Int_Cost_Sale_Rec___;


-- Get_Average_Price___
--   Returns average sales price on the internal Customer Order.
FUNCTION Get_Average_Price___ (
   co_order_no_     IN VARCHAR2,
   co_line_no_      IN VARCHAR2,
   co_rel_no_       IN VARCHAR2,
   co_line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   total_co_qty_    NUMBER;
   price_           NUMBER;
BEGIN
   --fetch total price in base currency/sales qty with discount
   total_co_qty_ := Customer_Order_Line_API.Get_Revised_Qty_Due(co_order_no_,
                                                                co_line_no_,
                                                                co_rel_no_,
                                                                co_line_item_no_);
   --not in public record
   price_ := Customer_Order_Line_API.Get_Base_Sale_Price_Total( co_order_no_,
                                                                co_line_no_,
                                                                co_rel_no_,
                                                                co_line_item_no_);
   --calculate the average price including discount
   price_ := price_/total_co_qty_;
   RETURN price_;
END Get_Average_Price___;


-- Corr_Intersite_Posting___
--   This method is used when pressing OK in the dialog Create Corrective
--   Intersite Postings. Calculates price posting and creates corrective
--   inter-site price postings.
PROCEDURE Corr_Intersite_Posting___ (
   new_base_price_           IN NUMBER,
   qty_to_correct_price_for_ IN NUMBER,
   co_order_no_              IN VARCHAR2,
   co_line_no_               IN VARCHAR2,
   co_rel_no_                IN VARCHAR2,
   co_line_item_no_          IN NUMBER,
   rma_no_                   IN NUMBER,
   rma_line_no_              IN NUMBER )
IS
   colinerec_         Customer_Order_Line_API.Public_Rec;
   company_           VARCHAR2(20);
   intersite_profit_  BOOLEAN := FALSE;
   trans_found_       BOOLEAN := FALSE;
   co_line_status_ok_ BOOLEAN := FALSE;
   delivered_qty_     NUMBER;
   rmalinerec_        Return_Material_Line_API.Public_Rec;
   returned_qty_      NUMBER;
   credit_approved_   VARCHAR2(60);
   wa_price_          NUMBER;
   price_diff_        NUMBER;
   exit_procedure     EXCEPTION;
BEGIN

   colinerec_ := Customer_Order_Line_API.Get(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
   company_ := Site_API.Get_Company(colinerec_.contract);

   intersite_profit_ := Is_Intersite_Allowed___(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
   IF NOT intersite_profit_ THEN
      Error_SYS.Record_General(lu_name_, 'INTPROFNOTALLOWED: Inter-site Profitability must be enabled for company :P1 to allow Corrective Inter-site Postings.', company_);
   END IF;

   trans_found_ := Intersite_Trans_Exist___(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
   IF NOT trans_found_ THEN
      Error_SYS.Record_General(lu_name_, 'NOTRANSEXIST: No Inter-site transactions exist on Customer Order No :P1. Corrective Inter-site Postings are not allowed.', co_order_no_);
   END IF;

   --check status on COLine
   co_line_status_ok_ := Is_Costatus_Allowed___(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
   IF NOT co_line_status_ok_ THEN
      Error_SYS.Record_General(lu_name_, 'WRONGSTATUS: Corrective Inter-site Postings are only allowed for Customer Order Line with status Partially Delivered, Delivered, or Invoiced/Closed.');
   END IF;


   --If called from COLine: Qty to correct cannot be greater than delivered quantity.
   IF rma_no_ IS NULL THEN
      delivered_qty_ := colinerec_.qty_shipped;
      IF qty_to_correct_price_for_ > delivered_qty_ THEN
         Error_SYS.Record_General(lu_name_, 'WRONDELGQTY: Price correction quantity may not be greater than delivered quantity.');
      END IF;

   ELSE
      --If called from RMALine: Qty to correct cannot be greater than returned quantity.
      --check RMALine credit approved (also made in client to enable/disable RMB)
      rmalinerec_ := Return_Material_Line_API.Get(rma_no_, rma_line_no_);
      credit_approved_ := rmalinerec_.credit_approver_id;
      IF credit_approved_ IS NULL THEN
         Error_SYS.Record_General(lu_name_, 'NOTCREDAPP: Corrective Inter-site Postings are only allowed if RMA Line is credit approved.');
      END IF;
      --get qty_to_return
      returned_qty_ := rmalinerec_.qty_to_return;
      --check qty_to return
      IF qty_to_correct_price_for_ > returned_qty_ THEN
         Error_SYS.Record_General(lu_name_, 'WRONRETGQTY: Price correction quantity may not be greater than returned quantity');
      END IF;
   END IF;


   --the method Get_Average_Cost is also used to show the WA price in the dialog.   
   wa_price_ := Inventory_Transaction_Hist_API.Get_Average_Intersite_Cost(co_order_no_,     --source_ref1
                                                                          co_line_no_,      --source_ref2
                                                                          co_rel_no_,       --source_ref3
                                                                          co_line_item_no_); --source_ref4

   -- this method is also used in the dialog to show the price diff to post. Calculate it again to make sure it matches with the parameters.
   -- could be wrong if user is changing data in the dialogbox without triggering this method.
   price_diff_ := Calculate_Price_Diff(new_base_price_, wa_price_);

   -- If there is no price difference to post, do not create any transactions.
   IF price_diff_ = 0 THEN
      RAISE exit_procedure;
   END IF;


   -- Fetch values for invtrans that is not passed to the method.
   -- They are all not visible on the dialogbox anyway...
   -- Better to fetch in servercode once than in several clients.
   Create_Corrective_Postings___(colinerec_.contract,
                                 colinerec_.part_no,
                                 colinerec_.configuration_id,
                                 NULL,           --lot_batch_no_,
                                 NULL,           --serial_no_,
                                 NULL,           --eng_chg_level_,
                                 NULL,           --waiv_dev_rej_no_,
                                 qty_to_correct_price_for_,
                                 company_,
                                 price_diff_,
                                 co_order_no_,
                                 co_line_no_,
                                 co_rel_no_,
                                 co_line_item_no_ );

EXCEPTION
   WHEN exit_procedure THEN
      NULL;
   WHEN OTHERS THEN
      RAISE;
END Corr_Intersite_Posting___;


-- Create_Corrective_Postings___
--   Creates transactions for corrective inter-site price postings.
PROCEDURE Create_Corrective_Postings___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   quantity_         IN NUMBER,
   company_          IN VARCHAR2,
   price_diff_       IN NUMBER,
   co_order_no_      IN VARCHAR2,
   co_line_no_       IN VARCHAR2,
   co_rel_no_        IN VARCHAR2,
   co_line_item_no_  IN NUMBER )
IS
   transaction_code_deliver_ VARCHAR2(10);
   transaction_code_receive_ VARCHAR2(10);
   new_transaction_id_       NUMBER;
   accounting_id_            NUMBER;
   value_                    NUMBER;
   order_type_               VARCHAR2(200);
   delivering_contract_      VARCHAR2(5);
   customer_order_rec_       Customer_Order_API.Public_Rec;
   receive_qty_              NUMBER;
   receive_price_            NUMBER;

BEGIN
   IF price_diff_ > 0 THEN
      transaction_code_deliver_ := 'INTREV+';
      transaction_code_receive_ := 'INTREVR+';
   ELSE
      transaction_code_deliver_ := 'INTREV-';
      transaction_code_receive_ := 'INTREVR-';
   END IF;

   order_type_ := Order_Type_API.Decode('CUST ORDER');
   customer_order_rec_ := Customer_Order_API.Get(co_order_no_);
   delivering_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(customer_order_rec_.customer_no);

   Inventory_Transaction_Hist_API.New( transaction_id_     => new_transaction_id_       ,
                                       accounting_id_      => accounting_id_            ,
                                       value_              => value_                    ,
                                       transaction_code_   => transaction_code_deliver_ , --INTREV+/INTREV-
                                       contract_           => contract_                 ,
                                       part_no_            => part_no_                  ,
                                       configuration_id_   => configuration_id_         ,
                                       location_no_        => NULL                      ,
                                       lot_batch_no_       => lot_batch_no_             ,
                                       serial_no_          => serial_no_                ,
                                       waiv_dev_rej_no_    => waiv_dev_rej_no_          ,
                                       eng_chg_level_      => eng_chg_level_            ,
                                       activity_seq_       => NULL                      ,
                                       project_id_         => NULL                      ,
                                       source_ref1_        => co_order_no_              ,
                                       source_ref2_        => co_line_no_               ,
                                       source_ref3_        => co_rel_no_                ,
                                       source_ref4_        => co_line_item_no_          ,
                                       source_ref5_        => NULL                      ,
                                       reject_code_        => NULL                      ,
                                       price_              => ABS(price_diff_)          ,
                                       quantity_           => quantity_                 ,
                                       qty_reversed_       => 0                         ,
                                       catch_quantity_     => NULL                      ,
                                       source_             => NULL                      ,
                                       source_ref_type_    => order_type_               ,
                                       owning_vendor_no_   => NULL                      ,
                                       condition_code_     => NULL                      ,
                                       location_group_     => NULL                      ,
                                       part_ownership_db_  => 'COMPANY OWNED'           ,
                                       owning_customer_no_ => NULL                      ,
                                       expiration_date_    => NULL                      );

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL);

   -- convert qty and price to the receiving site inventory uom, using REMOVE rounding since these transactions are not realy 
   -- any supply or demand transactions, but we try to get a similar quantity as the ARRTRAN/INTORDTR transactions have
   receive_qty_ :=Inventory_Part_API.Get_Site_Converted_Qty(contract_, part_no_,
                                                            delivering_contract_, quantity_,                                                                
                                                            'REMOVE');
   receive_price_ := ((ABS(price_diff_) * quantity_)/receive_qty_);


   Inventory_Transaction_Hist_API.New( transaction_id_     => new_transaction_id_       ,
                                       accounting_id_      => accounting_id_            ,
                                       value_              => value_                    ,
                                       transaction_code_   => transaction_code_receive_ , --INTREVR+/INTREVR-
                                       contract_           => delivering_contract_      ,
                                       part_no_            => part_no_                  ,
                                       configuration_id_   => configuration_id_         ,
                                       location_no_        => NULL                      ,
                                       lot_batch_no_       => lot_batch_no_             ,
                                       serial_no_          => serial_no_                ,
                                       waiv_dev_rej_no_    => waiv_dev_rej_no_          ,
                                       eng_chg_level_      => eng_chg_level_            ,
                                       activity_seq_       => NULL                      ,
                                       project_id_         => NULL                      ,
                                       source_ref1_        => co_order_no_              ,
                                       source_ref2_        => co_line_no_               ,
                                       source_ref3_        => co_rel_no_                ,
                                       source_ref4_        => co_line_item_no_          ,
                                       source_ref5_        => NULL                      ,
                                       reject_code_        => NULL                      ,
                                       price_              => ABS(receive_price_)       ,
                                       quantity_           => receive_qty_              ,
                                       qty_reversed_       => 0                         ,
                                       catch_quantity_     => NULL                      ,
                                       source_             => NULL                      ,
                                       source_ref_type_    => order_type_               ,
                                       owning_vendor_no_   => NULL                      ,
                                       condition_code_     => NULL                      ,
                                       location_group_     => NULL                      ,
                                       part_ownership_db_  => 'COMPANY OWNED'           ,
                                       owning_customer_no_ => NULL                      ,
                                       expiration_date_    => NULL                      );

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_transaction_id_,
                                                         company_,
                                                         'N',
                                                         NULL);

END Create_Corrective_Postings___;


-- Is_Intersite_Allowed___
--   Function is used in Is_Corrective_Allowed() and Corr_Intersite_Posting___.
--   In the first method it is used to enable/disable RMB in client.
--   In the second method it is used to show an error message if trying to create
--   corrective transactions with wrong prerequisits.
FUNCTION Is_Intersite_Allowed___ (
   co_order_no_     IN VARCHAR2,
   co_line_no_      IN VARCHAR2,
   co_rel_no_       IN VARCHAR2,
   co_line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   contract_          VARCHAR2(5);
   company_           VARCHAR2(20);
   intersite_profit_  VARCHAR2(20);
BEGIN
   contract_ := Customer_Order_Line_API.Get_Contract(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
   company_  := Site_API.Get_Company(contract_);
   intersite_profit_ := Company_Order_Info_API.Get_Intersite_Profitability_Db(company_);
   IF intersite_profit_ = 'TRUE' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Intersite_Allowed___;


-- Intersite_Trans_Exist___
--   Checks if any intersite profitability transactions (transaction code
--   INTREV) for a specific order line exist.
FUNCTION Intersite_Trans_Exist___ (
   co_order_no_     IN VARCHAR2,
   co_line_no_      IN VARCHAR2,
   co_rel_no_       IN VARCHAR2,
   co_line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   trans_found_       VARCHAR2(5);
BEGIN
   trans_found_ := Inventory_Transaction_Hist_API.Check_Order_Transaction(co_order_no_,
                                                                          co_line_no_,
                                                                          co_rel_no_,
                                                                          co_line_item_no_,
                                                                          NULL,
                                                                          'INTREV' );
   IF trans_found_ = 'TRUE' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;

END Intersite_Trans_Exist___;


-- Is_Costatus_Allowed___
--   Returns TRUE if status on CustomerOrderLine is allowed to make
--   corrective intersite postings.
FUNCTION Is_Costatus_Allowed___ (
   co_order_no_     IN VARCHAR2,
   co_line_no_      IN VARCHAR2,
   co_rel_no_       IN VARCHAR2,
   co_line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   co_line_status_db_  VARCHAR2(20);
BEGIN
   co_line_status_db_ := Customer_Order_Line_API.Get_Objstate(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
   IF co_line_status_db_ IN ('PartiallyDelivered', 'Delivered', 'Invoiced') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Costatus_Allowed___;


-- Reverse_Transaction___
--   Find the transactions INTREV, INTCOS which are connected to SHIPTRAN and then reverse using UNINTREV and UNINTCOS. 
--   Find the INTREVR which is connected INTREV and reverse using UNINTREVR.
--   Find the INTCOSR which is connected INTCOS and reverse using UNINTCOSR.
PROCEDURE Reverse_Transaction___ (   
   issue_transaction_id_      IN NUMBER,
   unissue_transaction_id_    IN NUMBER,
   reverse_transaction_       IN VARCHAR2,      
   quantity_                  IN NUMBER,
   catch_quantity_            IN NUMBER,
   invent_trans_conn_reason_  IN VARCHAR2) 
IS
   connected_transaction_id_        NUMBER;   
   reverse_transaction_id_          NUMBER;
   quantity_temp_                   NUMBER;
   reverse_transaction_temp_        VARCHAR2(10);
   invent_trans_conn_reason_temp_   VARCHAR2(25);
   connected_transaction_rec_       Inventory_Transaction_Hist_API.Public_Rec;
   issue_transaction_rec_           Inventory_Transaction_Hist_API.Public_Rec;
BEGIN   
   -- Finding the corresponding 'INTREV' transaction which is connected to original transaction SHIPTRAN
   -- Finding the corresponding 'INTCOS' transaction which is connected to original transaction SHIPTRAN
   -- Finding the corresponding 'INTREVR' transaction which is connected to original transaction INTREV
   -- Finding the corresponding 'INTCOSR' transaction which is connected to original transaction INTCOS
   connected_transaction_id_  := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(issue_transaction_id_,
                                                                                            invent_trans_conn_reason_);
   connected_transaction_rec_ := Inventory_Transaction_Hist_API.Get(connected_transaction_id_);
   
   IF (connected_transaction_rec_.transaction_code IN ('INTREV', 'INTCOS', 'INTREVR', 'INTCOSR')) THEN
      issue_transaction_rec_     := Inventory_Transaction_Hist_API.Get(issue_transaction_id_);
      -- convert qty to the correct inv uom
      quantity_temp_ := quantity_;
      IF (issue_transaction_rec_.contract != connected_transaction_rec_.contract) THEN
         quantity_temp_ :=Inventory_Part_API.Get_Site_Converted_Qty(issue_transaction_rec_.contract,
                                                                    connected_transaction_rec_.part_no,
                                                                    connected_transaction_rec_.contract,
                                                                    quantity_,
                                                                    'ADD');
      END IF;
      Inventory_Transaction_Hist_API.Reverse_Transaction(transaction_id_        => reverse_transaction_id_,
                                                         transaction_           => reverse_transaction_,
                                                         pos_diff_transaction_  => 'INVREVTR-',
                                                         neg_diff_transaction_  => 'INVREVTR+',
                                                         quantity_              => quantity_temp_,
                                                         catch_quantity_        => catch_quantity_,
                                                         old_transaction_id_    => connected_transaction_id_,
                                                         source_                => NULL );

      IF (reverse_transaction_id_ IS NOT NULL) THEN
         Inventory_Transaction_Hist_API.Set_Original_Transaction_Id(reverse_transaction_id_,
                                                                    connected_transaction_id_);   

         Invent_Trans_Interconnect_API.Connect_Transactions(unissue_transaction_id_,
                                                            reverse_transaction_id_,
                                                            invent_trans_conn_reason_);

         IF reverse_transaction_ IN ('UNINTREV', 'UNINTCOS') THEN         
            -- If the connected_transaction_id_ is INTREV, INTCOS need to find INTREVR, INTCOSR
            -- and do the reverse transactions UNINTREVR, UNINTCOSR
            IF (reverse_transaction_ = 'UNINTREV') THEN
               reverse_transaction_temp_        := 'UNINTREVR';
               invent_trans_conn_reason_temp_   := Invent_Trans_Conn_Reason_API.DB_INTERSITE_REVENUE_REC;
            END IF;
            IF (reverse_transaction_ = 'UNINTCOS') THEN
               reverse_transaction_temp_        := 'UNINTCOSR';
               invent_trans_conn_reason_temp_   := Invent_Trans_Conn_Reason_API.DB_INTERSITE_COST_REC;
            END IF;

            Reverse_Transaction___(connected_transaction_id_,
                                   reverse_transaction_id_,
                                   reverse_transaction_temp_,
                                   quantity_temp_,   
                                   catch_quantity_,
                                   invent_trans_conn_reason_temp_);
         END IF;      
      END IF;
   END IF;
END Reverse_Transaction___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Intersite_Transactions
--   Called to trigger inter-site profitability transactions.
PROCEDURE Create_Intersite_Transactions (
   delivering_contract_ IN VARCHAR2,
   contract_            IN VARCHAR2,
   part_no_             IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   quantity_            IN NUMBER,
   company_             IN VARCHAR2,
   co_order_no_         IN VARCHAR2,
   co_line_no_          IN VARCHAR2,
   co_rel_no_           IN VARCHAR2,
   co_line_item_no_     IN NUMBER,
   trigger_trans_id_    IN NUMBER,
   deliv_no_            IN VARCHAR2)
IS
   new_trans_id_           NUMBER;
   prev_trans_id_          NUMBER;
   intersite_profit_       BOOLEAN := FALSE;
   exit_procedure          EXCEPTION;
   price_                  NUMBER;
   cost_                   NUMBER;
   receive_cost_           NUMBER;
   receive_qty_            NUMBER;
   receive_price_          NUMBER;
BEGIN

   intersite_profit_ := Is_Intersite_Allowed___(co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
   IF intersite_profit_ THEN
      NULL;
   ELSE
      RAISE exit_procedure;
   END IF;

   price_ := Get_Average_Price___(co_order_no_,
                                  co_line_no_,
                                  co_rel_no_,
                                  co_line_item_no_ );

   cost_ := Inventory_Transaction_Hist_API.Get_Cost(trigger_trans_id_);



   -- convert qty and cost/price to the receiving site inventory uom, using REMOVE rounding since these transactions are not realy 
   -- any supply or demand transactions, but we try to get a similar quantity as the ARRTRAN/INTORDTR transactions have
   receive_qty_ :=Inventory_Part_API.Get_Site_Converted_Qty(delivering_contract_, part_no_,
                                                            contract_, quantity_,                                                                
                                                            'REMOVE');
   receive_price_ := ((price_ * quantity_)/receive_qty_);
   receive_cost_ := ((cost_ * quantity_)/receive_qty_);


   --INTREV
   Create_Internal_Revenue___(new_trans_id_,
                              delivering_contract_,
                              part_no_,
                              configuration_id_,
                              lot_batch_no_,
                              serial_no_,
                              eng_chg_level_,
                              waiv_dev_rej_no_,
                              quantity_,
                              company_,
                              price_,
                              co_order_no_,
                              co_line_no_,
                              co_rel_no_,
                              co_line_item_no_,
                              deliv_no_);

   -- Create a connection between transactions
   Invent_Trans_Interconnect_API.Connect_Transactions(trigger_trans_id_,
                                                      new_trans_id_,
                                                      'INTERSITE REVENUE');

   prev_trans_id_ := new_trans_id_;

   --INTREVR
   Create_Int_Purch_Cost___ (new_trans_id_,
                             contract_,
                             part_no_,
                             configuration_id_,
                             lot_batch_no_,
                             serial_no_,
                             eng_chg_level_,
                             waiv_dev_rej_no_,
                             receive_qty_,
                             company_,
                             receive_price_,
                             co_order_no_,
                             co_line_no_,
                             co_rel_no_,
                             co_line_item_no_,
                             deliv_no_);

   -- Create a connection between transactions
   Invent_Trans_Interconnect_API.Connect_Transactions(prev_trans_id_,
                                                      new_trans_id_,
                                                      'INTERSITE REVENUE REC');
   --INTCOS
   Create_Int_Cost_Sale___(new_trans_id_,
                           delivering_contract_,
                           part_no_,
                           configuration_id_,
                           lot_batch_no_,
                           serial_no_,
                           eng_chg_level_,
                           waiv_dev_rej_no_,
                           quantity_,
                           company_,
                           cost_,
                           co_order_no_,
                           co_line_no_,
                           co_rel_no_,
                           co_line_item_no_,
                           deliv_no_);

   -- Create a connection between transactions
   Invent_Trans_Interconnect_API.Connect_Transactions(trigger_trans_id_,
                                                      new_trans_id_,
                                                      'INTERSITE COST');
   prev_trans_id_ := new_trans_id_;

   --INTCOSR
   --on this transaction it is the cost, not priced that is saved.
   Create_Int_Cost_Sale_Rec___ (new_trans_id_,
                                contract_,
                                part_no_,
                                configuration_id_,
                                lot_batch_no_,
                                serial_no_,
                                eng_chg_level_,
                                waiv_dev_rej_no_,
                                receive_qty_,
                                company_,
                                receive_cost_,
                                co_order_no_,
                                co_line_no_,
                                co_rel_no_,
                                co_line_item_no_,
                                deliv_no_);

   -- Create a connection between transactions
   Invent_Trans_Interconnect_API.Connect_Transactions(prev_trans_id_,
                                                      new_trans_id_,
                                                      'INTERSITE COST REC');

EXCEPTION
   WHEN exit_procedure THEN
      NULL;
   WHEN OTHERS THEN
      RAISE;
END Create_Intersite_Transactions;

-- Reverse_Intersite_Transactions
--   Called to reverse inter-site profitability transactions INTREV, INTREVR, INTCOS and INTCOSR.
PROCEDURE Reverse_Intersite_Transactions (
   issue_transaction_id_   IN NUMBER,
   unissue_transaction_id_ IN NUMBER,
   quantity_               IN NUMBER,   
   catch_quantity_         IN NUMBER )
IS   
BEGIN   
   -- Reverse INTREV, INTREVR transactions   
   Reverse_Transaction___ (issue_transaction_id_      => issue_transaction_id_,
                           unissue_transaction_id_    => unissue_transaction_id_,
                           reverse_transaction_       => 'UNINTREV',                              
                           quantity_                  => quantity_,
                           catch_quantity_            => catch_quantity_,
                           invent_trans_conn_reason_  => Invent_Trans_Conn_Reason_API.DB_INTERSITE_REVENUE);
   
   -- Reverse INTCOS, INTCOSR transactions
   Reverse_Transaction___ (issue_transaction_id_      => issue_transaction_id_,
                           unissue_transaction_id_    => unissue_transaction_id_,
                           reverse_transaction_       => 'UNINTCOS',                              
                           quantity_                  => quantity_,
                           catch_quantity_            => catch_quantity_,
                           invent_trans_conn_reason_  => Invent_Trans_Conn_Reason_API.DB_INTERSITE_COST);

END Reverse_Intersite_Transactions;

-- Corrective_Intersite_Posting
--   Creates corrective inter-site price postings. This method should be called
--   from the client. This method is first called when pressing OK in the dialog
--   Create Corrective Intersite Postings. If called from Customer Order Line,
--   pass NULL values for rma_no and rma_line_no.
--   This indicates where the method is called from.
PROCEDURE Corrective_Intersite_Posting (
   new_base_price_                IN NUMBER,
   qty_to_correct_price_for_      IN NUMBER,
   co_order_no_                   IN VARCHAR2,
   co_line_no_                    IN VARCHAR2,
   co_rel_no_                     IN VARCHAR2,
   co_line_item_no_               IN NUMBER,
   rma_no_                        IN NUMBER,
   rma_line_no_                   IN NUMBER )

IS
BEGIN

   IF(qty_to_correct_price_for_ <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVE_ZERO_QTY: The quantity must be greater than 0.');
   END IF;
   Corr_Intersite_Posting___(new_base_price_,
                             qty_to_correct_price_for_,
                             co_order_no_,
                             co_line_no_,
                             co_rel_no_,
                             co_line_item_no_,
                             rma_no_,
                             rma_line_no_);

END Corrective_Intersite_Posting;


-- Calculate_Price_Diff
--   Calculates the price difference per unit to be used for the inter-site
--   price postings.
@UncheckedAccess
FUNCTION Calculate_Price_Diff (
   new_base_price_           IN NUMBER,
   wa_price_                 IN NUMBER ) RETURN NUMBER
IS
   price_diff_      NUMBER;
BEGIN
   price_diff_ := new_base_price_ - wa_price_;
   RETURN price_diff_;
END Calculate_Price_Diff;



-- Is_Corrective_Allowed
--   This method is used from client to enable RMB and in server to validate
--   before creating corrective postings.
--   Return NUMBER since boolean cannot be used in clients.
--   Method includes validations that are the same both for COLine and RMALine.
--   Specific validations for RMALine are added in client and Corr_Intersite_Posting___.
@UncheckedAccess
FUNCTION Is_Corrective_Allowed (
   co_order_no_              IN VARCHAR2,
   co_line_no_               IN VARCHAR2,
   co_rel_no_                IN VARCHAR2,
   co_line_item_no_          IN NUMBER ) RETURN NUMBER
IS
   corrective_allowed_       NUMBER;
   intersite_profit_allowed_ BOOLEAN := FALSE;
   trans_exist_              BOOLEAN := FALSE;
   co_line_status_allowed_   BOOLEAN := FALSE;
BEGIN
   corrective_allowed_ := 0;
   intersite_profit_allowed_ := Is_Intersite_Allowed___(co_order_no_,
                                                        co_line_no_,
                                                        co_rel_no_,
                                                        co_line_item_no_);


   IF intersite_profit_allowed_ THEN
      co_line_status_allowed_ := Is_Costatus_Allowed___(co_order_no_,
                                                        co_line_no_,
                                                        co_rel_no_,
                                                        co_line_item_no_);
   END IF;
   
   IF co_line_status_allowed_ THEN
      trans_exist_ := Intersite_Trans_Exist___(co_order_no_,
                                               co_line_no_,
                                               co_rel_no_,
                                               co_line_item_no_);
   END IF;
   
   IF (intersite_profit_allowed_ AND trans_exist_ AND co_line_status_allowed_) THEN
      --TRUE
      corrective_allowed_ := 1;
   ELSE
      --FALSE
      corrective_allowed_ := 0;
   END IF;

   RETURN corrective_allowed_;

END Is_Corrective_Allowed;




