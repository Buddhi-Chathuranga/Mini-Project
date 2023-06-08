-----------------------------------------------------------------------------
--
--  Logical unit: TaxHandlingInventUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220126  MalLlk  SC21R2-7392, Removed the parameter part_move_tax_direction_db_ from Find_Ship_Ord_Src_and_Dest___().
--  220120  MalLlk  SC21R2-5022, Added IgnoreUnitTest annotation to the methods Create_Tax_Line_Param_Rec___, Fetch_Tax_Code_Info___, 
--  220120          Calculate_Line_Totals___, Add_Transaction_Tax_Info___, Get_Inv_Trans_Send_Rec_Country and Calculate_Calctax_Tax_Amounts.
--  220120  MalLlk  SC21R2-7274, Modified Find_Ship_Ord_Src_and_Dest___() to add parameter part_move_tax_direction_db_ and
--  220120          set the sender and receiver information based on that.
--  220118  MaEelk  SC21R2-7240, Passed Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST to the call Part_Move_Tax_Accounting_API.Create_Vouchers.
--  220113  MalLlk  SC21R2-6394, Added out parameter to Add_Transaction_Tax_Info___, to check whether tax codes are found 
--  220113          or not. Modified Create_Cross_Border_Vouchers__ to validate date and whether fetching any tax codes.
--  220106  MalLlk  SC21R2-6395, Modified Create_Cross_Border_Vouchers__ to validate company has valid tax ID numbers 
--  220106          registered for both sender and receiver countries before creating vouchers.
--  211220  MaEelk  SC21R2-6775, Passed part_move_tax_id, '*' and Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST 
--  211220          as source_ref1_, source_ref2_ and source_ref_type_db_ to Part_Move_Tax_Accounting_API.Create_Postings
--  211215  Asawlk  SC21R2-6258, Added support for reversal of tax and postings. Added methods Reverse_Tax_And_Postings___ and Fetch_Reverse_Tax_Info___.
--  211202  Asawlk  SC21R2-6383, Modified Find_Shipment_Src_and_Dest() to retrieve sender/receiver information when CO line is
--  211202          connected to a shipment.
--  211122  Asawlk  SC21R2-5695, Added method Find_Rma_Src_and_Dest___ to handle RMA receipts. 
--  211117  MalLlk  SC21R2-5971, Added method Get_Inv_Trans_Send_Rec_Country to return the sender and receiver 
--  211117          country code for given part move tax id. 
--  211109  Asawlk  SC21R2-5452, Added Methods Find_Src_and_Dest_By_Src_Ref(), Find_Shipment_Src_and_Dest(),
--  211109          Find_Cust_Ord_Src_and_Dest___() and Find_Pur_Ord_Src_and_Dest___(). 
--  211022  MalLlk  SC21R2-5222, Added Calculate_Calctax_Tax_Amounts, to calculate and return tax amounts 
--  211022          considering Calculated-Tax tax rates.
--  210924  Asawlk  SC21R2-2770, Added methods Create_Cross_Border_Vouchers(), Create_Cross_Border_Vouchers__() and
--  210924          Find_Ship_Ord_Src_and_Dest___().
--  210910  MalLlk  SC21R2-1980, Added tax handling related methods Fetch_Tax_Code_On_Object, 
--  210910          Create_Tax_Line_Param_Rec___, Fetch_Tax_Code_Info___, Calculate_Line_Totals___ 
--  210910          and Add_Transaction_Tax_Info___. Added record type tax_line_param_rec.
--  210713  MalLlk  SC21R2-1823, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE tax_line_param_rec IS RECORD (   
   company                 VARCHAR2(20),
   part_no                 VARCHAR2(25),
   sender_country_code     VARCHAR2(2),
   receiver_country_code   VARCHAR2(2),
   part_move_tax_direction VARCHAR2(20),
   base_net_cost           NUMBER,   
   date_applied            DATE);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Check_Exist_Tmp___(
   transaction_id_   IN   NUMBER ) RETURN BOOLEAN  
IS
   CURSOR check_exist IS
      SELECT 1
      FROM cross_border_tax_trans_tmp
      WHERE transaction_id = transaction_id_;
   
   dummy_number_     NUMBER := 0;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_number_;
   CLOSE check_exist;
   
   RETURN (dummy_number_ = 1); 
END Check_Exist_Tmp___;

PROCEDURE Find_Ship_Ord_Src_and_Dest___ (
   sender_contract_              OUT VARCHAR2,   
   sender_country_code_          OUT VARCHAR2,
   receiver_contract_            OUT VARCHAR2,   
   receiver_country_code_        OUT VARCHAR2,
   shipment_order_id_            IN  VARCHAR2,
   shipment_order_line_no_       IN  VARCHAR2, 
   shipment_id_                  IN  VARCHAR2 )
IS
   local_shipment_id_            NUMBER;
BEGIN
   $IF (Component_Shipod_SYS.INSTALLED) $THEN
      -- This is a fallback to address the shipment_id is not saved in inventory_transaction_hist_tab in source_ref5 column. This has still not being
      -- implemented for Shipment Order receipt transactions. Once it is in place the fall back can be removed.
      local_shipment_id_ := NVL(TO_NUMBER(shipment_id_), Shipment_Line_API.Fetch_Shipment_Id_By_Source(source_ref1_        => shipment_order_id_,
                                                                                                       source_ref2_        => shipment_order_line_no_,
                                                                                                       source_ref3_        => NULL,
                                                                                                       source_ref4_        => NULL,
                                                                                                       source_ref_type_db_ => Logistics_Source_Ref_Type_API.DB_SHIPMENT_ORDER));
   
   
      -- Shipment is used to find the Shipment Order related information as shipment order is always delivered
      -- through a shipment.                                                 
      Find_Shipment_Src_and_Dest(sender_contract_,   
                                 sender_country_code_,
                                 receiver_contract_,   
                                 receiver_country_code_,
                                 local_shipment_id_);
   $ELSE
      Error_SYS.Component_Not_Exist('SHIPOD');
   $END   
END Find_Ship_Ord_Src_and_Dest___;

FUNCTION Get_All_Rec_Or_Iss_Con_Trns___ (
   source_ref1_                  IN    VARCHAR2,
   source_ref2_                  IN    VARCHAR2,
   source_ref3_                  IN    VARCHAR2,
   source_ref4_                  IN    VARCHAR2,
   source_ref5_                  IN    VARCHAR2,
   source_ref_type_              IN    VARCHAR2,
   part_move_tax_direction_      IN    VARCHAR2) RETURN Inventory_Transaction_Hist_API.Transaction_Id_Tab
   
IS   
   CURSOR get_all_rec_or_iss_con_trans IS
      SELECT transaction_id
        FROM cross_border_tax_trans_tmp
       WHERE  source_ref1                  = source_ref1_
         AND (source_ref2                  = source_ref2_ OR source_ref2_ IS NULL) 
         AND (source_ref3                  = source_ref3_ OR source_ref3_ IS NULL)
         AND (source_ref4                  = source_ref4_ OR source_ref4_ IS NULL)
         AND (source_ref5                  = source_ref5_ OR source_ref5_ IS NULL)
         AND  source_ref_type              = source_ref_type_
         AND  part_move_tax_direction      = part_move_tax_direction_;
         
   connected_transactions_tab_      Inventory_Transaction_Hist_API.Transaction_Id_Tab;   
BEGIN
   OPEN get_all_rec_or_iss_con_trans;
   FETCH get_all_rec_or_iss_con_trans BULK COLLECT INTO connected_transactions_tab_;
   CLOSE get_all_rec_or_iss_con_trans;
   
   RETURN connected_transactions_tab_; 
END Get_All_Rec_Or_Iss_Con_Trns___;

PROCEDURE Find_Cust_Ord_Src_and_Dest___ (
   sender_contract_              OUT VARCHAR2,
   sender_country_code_          OUT VARCHAR2,
   receiver_contract_            OUT VARCHAR2,
   receiver_country_code_        OUT VARCHAR2,
   order_no_                     IN  VARCHAR2,
   line_no_                      IN  VARCHAR2,     
   rel_no_                       IN  VARCHAR2,
   line_item_no_                 IN  VARCHAR2,   
   deliv_no_                     IN  VARCHAR2,
   part_move_tax_direction_db_   IN  VARCHAR2 )
   
IS
   local_sender_contract_        VARCHAR2(5);
   local_sender_country_code_    VARCHAR2(2);
   local_receiver_contract_      VARCHAR2(5);
   local_receiver_country_code_  VARCHAR2(2);   
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      Customer_Order_Delivery_API.Get_Sender_Receiv_Tax_Info(local_sender_contract_,
                                                             local_sender_country_code_,
                                                             local_receiver_contract_,
                                                             local_receiver_country_code_,
                                                             order_no_,
                                                             line_no_,     
                                                             rel_no_,
                                                             TO_NUMBER(line_item_no_),   
                                                             TO_NUMBER(deliv_no_));   
      -- The transaction is a forward direction transaction
      IF (part_move_tax_direction_db_ IN (Part_Move_Tax_Direction_API.DB_SENDER, Part_Move_Tax_Direction_API.DB_SENDER_REVERSAL)) THEN
         sender_contract_        := local_sender_contract_;
         sender_country_code_    := local_sender_country_code_;
         receiver_contract_      := local_receiver_contract_;
         receiver_country_code_  := local_receiver_country_code_;
      -- If the transaction is a reversal transaction, then we have to swap the sender and receiver information   
      ELSIF (part_move_tax_direction_db_ IN (Part_Move_Tax_Direction_API.DB_RECEIVER, Part_Move_Tax_Direction_API.DB_RECEIVER_REVERSAL)) THEN
         sender_contract_        := local_receiver_contract_;
         sender_country_code_    := local_receiver_country_code_;
         receiver_contract_      := local_sender_contract_;
         receiver_country_code_  := local_sender_country_code_;            
      END IF;                                                    
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END   
END Find_Cust_Ord_Src_and_Dest___;

PROCEDURE Find_Pur_Ord_Src_and_Dest___ (
   sender_contract_              OUT VARCHAR2,   
   sender_country_code_          OUT VARCHAR2,
   receiver_contract_            OUT VARCHAR2,   
   receiver_country_code_        OUT VARCHAR2,
   order_no_                     IN  VARCHAR2,
   line_no_                      IN  VARCHAR2,
   release_no_                   IN  VARCHAR2,
   part_move_tax_direction_db_   IN  VARCHAR2)
IS
   local_sender_contract_        VARCHAR2(5);
   local_sender_country_code_    VARCHAR2(2);
   local_receiver_contract_      VARCHAR2(5);
   local_receiver_country_code_  VARCHAR2(2); 
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Purchase_Order_Line_API.Get_Sender_Receiv_Tax_Info(local_sender_contract_,
                                                         local_sender_country_code_,
                                                         local_receiver_contract_,   
                                                         local_receiver_country_code_,
                                                         order_no_,
                                                         line_no_,
                                                         release_no_);
      -- The transaction is a forward direction transaction
      IF (part_move_tax_direction_db_ IN (Part_Move_Tax_Direction_API.DB_RECEIVER, Part_Move_Tax_Direction_API.DB_RECEIVER_REVERSAL)) THEN
         sender_contract_        := local_sender_contract_;
         sender_country_code_    := local_sender_country_code_;
         receiver_contract_      := local_receiver_contract_;
         receiver_country_code_  := local_receiver_country_code_;
      -- If the transaction is a reversal transaction, then we have to swap the sender and receiver information   
      ELSIF (part_move_tax_direction_db_ IN (Part_Move_Tax_Direction_API.DB_SENDER, Part_Move_Tax_Direction_API.DB_SENDER_REVERSAL)) THEN
         sender_contract_        := local_receiver_contract_;
         sender_country_code_    := local_receiver_country_code_;
         receiver_contract_      := local_sender_contract_;
         receiver_country_code_  := local_sender_country_code_;            
      END IF;                                                             
   $ELSE
      Error_SYS.Component_Not_Exist('PURCH');
   $END   
END Find_Pur_Ord_Src_and_Dest___;

PROCEDURE Find_Rma_Src_and_Dest___ (
   sender_contract_              OUT VARCHAR2,   
   sender_country_code_          OUT VARCHAR2,
   receiver_contract_            OUT VARCHAR2,   
   receiver_country_code_        OUT VARCHAR2,
   rma_no_                       IN  VARCHAR2,
   rma_line_no_                  IN  VARCHAR2)
   
IS
   $IF (Component_Order_SYS.INSTALLED) $THEN
      rma_line_rec_        Return_Material_Line_API.Public_Rec;     
   $END
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      rma_line_rec_ := Return_Material_Line_API.Get(TO_NUMBER(rma_no_),
                                                    TO_NUMBER(rma_line_no_));
      -- We will only be considering order connected RMA lines.
      IF (rma_line_rec_.order_no IS NOT NULL) THEN
         -- We try to retrieve the sender/ receiver information using the connected customer order whereby switching the
         -- sender and receiver information. That is why the Part_Move_Tax_Direction in parameter list is considered as 
         -- RECEIVER.
         Find_Cust_Ord_Src_and_Dest___(sender_contract_,
                                       sender_country_code_,
                                       receiver_contract_,
                                       receiver_country_code_,
                                       rma_line_rec_.order_no,
                                       rma_line_rec_.line_no,
                                       rma_line_rec_.rel_no,
                                       TO_CHAR(rma_line_rec_.line_item_no),
                                       TO_CHAR(NULL),
                                       Part_Move_Tax_Direction_API.DB_RECEIVER);
      END IF;   
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END
END Find_Rma_Src_and_Dest___;   

-------------------- IMPLEMENTATION METHODS FOR TAX HANDLING ----------------

@IgnoreUnitTest TrivialFunction
FUNCTION Create_Tax_Line_Param_Rec___ (   
   company_                 IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   sender_country_code_     IN VARCHAR2,
   receiver_country_code_   IN VARCHAR2,
   part_move_tax_direction_ IN VARCHAR2,
   base_net_cost_           IN NUMBER,   
   date_applied_            IN DATE) RETURN tax_line_param_rec
IS 
   tax_line_param_rec_      tax_line_param_rec;
BEGIN   
   tax_line_param_rec_.company                 := company_;
   tax_line_param_rec_.part_no                 := part_no_;
   tax_line_param_rec_.sender_country_code     := sender_country_code_;
   tax_line_param_rec_.receiver_country_code   := receiver_country_code_;
   tax_line_param_rec_.part_move_tax_direction := part_move_tax_direction_;
   tax_line_param_rec_.base_net_cost           := base_net_cost_;   
   tax_line_param_rec_.date_applied            := date_applied_;
   
   RETURN tax_line_param_rec_;
END Create_Tax_Line_Param_Rec___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Fetch_Tax_Code_Info___ (
   tax_info_table_       OUT Tax_Handling_Util_API.tax_information_table,
   tax_line_param_rec_   IN  tax_line_param_rec)
IS
   tax_source_object_rec_ Tax_Handling_Util_API.tax_source_object_rec;
   identity_rec_          Tax_Handling_Util_API.identity_rec;
   fetch_default_key_rec_ Tax_Handling_Util_API.fetch_default_key_rec;
   validation_rec_        Tax_Handling_Util_API.validation_rec;
BEGIN
   -- Set the tax_source_taxable_db_ as true, to align with the common logic in TaxHandlingUtil.
   tax_source_object_rec_ := Tax_Handling_Util_API.Create_Tax_Source_Object_Rec(tax_source_object_id_   => tax_line_param_rec_.part_no,
                                                                                tax_source_object_type_ => 'INV_MOVE_PART',
                                                                                tax_source_taxable_db_  => Fnd_Boolean_API.DB_TRUE,
                                                                                attr_                   => NULL);

   -- Set the tax_liability_type_db_ as taxable, to align with the common logic in TaxHandlingUtil.                                                                             
   identity_rec_          := Tax_Handling_Util_API.Create_Identity_Rec(identity_                 => NULL,
                                                                       party_type_db_            => NULL,
                                                                       supply_country_db_        => tax_line_param_rec_.sender_country_code,
                                                                       delivery_country_db_      => tax_line_param_rec_.receiver_country_code,
                                                                       tax_liability_            => NULL,
                                                                       tax_liability_type_db_    => Tax_Liability_Type_API.DB_TAXABLE,
                                                                       delivery_address_id_      => NULL,
                                                                       delivery_type_            => NULL,
                                                                       use_proj_address_for_tax_ => NULL,
                                                                       project_id_               => NULL,
                                                                       ship_from_address_id_     => NULL,
                                                                       attr_                     => NULL);
   
   fetch_default_key_rec_ := Tax_Handling_Util_API.Create_Fetch_Default_Key_Rec(contract_                   => NULL,
                                                                                charge_connect_part_no_     => NULL, 
                                                                                order_code_                 => NULL, 
                                                                                service_type_               => NULL,
                                                                                attr_                       => NULL, 
                                                                                connect_charge_seq_no_      => NULL,
                                                                                part_move_tax_direction_db_ => tax_line_param_rec_.part_move_tax_direction);

   validation_rec_        := Tax_Handling_Util_API.Create_Validation_Rec(calc_base_                   => 'NET_BASE',
                                                                         fetch_validate_action_       => 'FETCH_IF_VALID',
                                                                         validate_tax_from_tax_class_ => Fnd_Boolean_API.DB_FALSE,
                                                                         attr_                        => NULL);

   Tax_Handling_Util_API.Fetch_Default_Tax_Codes(tax_info_table_,
                                                 tax_source_object_rec_,
                                                 tax_line_param_rec_.company,
                                                 tax_line_param_rec_.date_applied,
                                                 identity_rec_,
                                                 fetch_default_key_rec_,
                                                 validation_rec_);
END Fetch_Tax_Code_Info___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Calculate_Line_Totals___ (
   tax_info_table_       IN OUT Tax_Handling_Util_API.tax_information_table,
   tax_line_param_rec_   IN     tax_line_param_rec)
IS
   acc_curr_rec_              Tax_Handling_Util_API.acc_curr_rec;
   trans_curr_rec_            Tax_Handling_Util_API.trans_curr_rec;
   para_curr_rec_             Tax_Handling_Util_API.para_curr_rec;
   line_amount_rec_           Tax_Handling_Util_API.line_amount_rec;
   acc_currency_code_         VARCHAR2(3);
   currency_conv_factor_      NUMBER;
   currency_rate_             NUMBER;
   para_currency_conv_factor_ NUMBER;
   para_currency_rate_        NUMBER;
   para_curr_inverted_        VARCHAR2(5);
BEGIN
   -- Note: Here it is considered accounting currency as the transaction currency
   acc_currency_code_ :=  Company_Finance_API.Get_Currency_Code(tax_line_param_rec_.company);
   
   Currency_Rate_API.Get_Currency_Rate(currency_conv_factor_, 
                                       currency_rate_, 
                                       tax_line_param_rec_.company, 
                                       acc_currency_code_, 
                                       Currency_Type_API.Get_Default_Type(tax_line_param_rec_.company), 
                                       tax_line_param_rec_.date_applied);
                                       
   Currency_Rate_API.Get_Parallel_Currency_Rate(para_currency_rate_, 
                                                para_currency_conv_factor_,
                                                para_curr_inverted_,
                                                tax_line_param_rec_.company, 
                                                acc_currency_code_, 
                                                tax_line_param_rec_.date_applied);                                   

   line_amount_rec_ := Tax_Handling_Util_API.Create_Line_Amount_Rec(line_gross_curr_amount_ => NULL, 
                                                                    line_net_curr_amount_   => tax_line_param_rec_.base_net_cost, 
                                                                    tax_calc_base_amount_   => NULL, 
                                                                    calc_base_              => 'NET_BASE', 
                                                                    consider_use_tax_       => Fnd_Boolean_API.DB_FALSE, 
                                                                    attr_                   => NULL);
   
   trans_curr_rec_  := Tax_Handling_Util_API.Create_Trans_Curr_Rec(company_             => tax_line_param_rec_.company,
                                                                   identity_            => NULL,
                                                                   party_type_db_       => NULL, 
                                                                   currency_            => acc_currency_code_,
                                                                   delivery_address_id_ => NULL,
                                                                   attr_                => NULL,
                                                                   tax_rounding_        => NULL,
                                                                   curr_rounding_       => NULL);
   
   acc_curr_rec_    := Tax_Handling_Util_API.Create_Acc_Curr_Rec(company_           => tax_line_param_rec_.company,
                                                                 attr_              => NULL,
                                                                 curr_rate_         => currency_rate_,
                                                                 conv_factor_       => currency_conv_factor_,                                                                  
                                                                 acc_curr_rounding_ => NULL);
   
   para_curr_rec_   := Tax_Handling_Util_API.Create_Para_Curr_Rec(company_                => tax_line_param_rec_.company,
                                                                  currency_               => acc_currency_code_,
                                                                  calculate_para_amounts_ => Fnd_Boolean_API.DB_TRUE,
                                                                  attr_                   => NULL,
                                                                  para_curr_rate_         => para_currency_rate_,
                                                                  para_conv_factor_       => para_currency_conv_factor_,
                                                                  para_curr_rounding_     => NULL);

   -- Calculate tax line totals   
   Tax_Handling_Util_API.Calc_Line_Total_Amounts(tax_info_table_, 
                                                 line_amount_rec_,
                                                 tax_line_param_rec_.company,
                                                 trans_curr_rec_,
                                                 acc_curr_rec_,
                                                 para_curr_rec_);
END Calculate_Line_Totals___;


@IgnoreUnitTest TrivialFunction
PROCEDURE Add_Transaction_Tax_Info___(
   found_tax_codes_         OUT BOOLEAN,
   part_move_tax_id_        IN  VARCHAR2,
   company_                 IN  VARCHAR2,
   part_no_                 IN  VARCHAR2,
   sender_country_code_     IN  VARCHAR2,
   receiver_country_code_   IN  VARCHAR2,
   base_net_cost_           IN  NUMBER,
   part_move_tax_direction_ IN  VARCHAR2,
   date_applied_            IN  DATE)
IS
   tax_line_param_rec_      tax_line_param_rec;
   source_key_rec_          Tax_Handling_Util_API.source_key_rec;
   tax_info_table_          Tax_Handling_Util_API.tax_information_table;
BEGIN
   tax_line_param_rec_ := Create_Tax_Line_Param_Rec___ (company_,
                                                        part_no_,
                                                        sender_country_code_,
                                                        receiver_country_code_,
                                                        part_move_tax_direction_,
                                                        base_net_cost_,                                                        
                                                        date_applied_);       
  
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_ => Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST,      
                                                                      source_ref1_     => part_move_tax_id_,
                                                                      source_ref2_     => '*',
                                                                      source_ref3_     => '*',
                                                                      source_ref4_     => '*',
                                                                      source_ref5_     => '*',
                                                                      attr_            => NULL);

   Fetch_Tax_Code_Info___(tax_info_table_,
                          tax_line_param_rec_);

   IF (tax_info_table_.COUNT > 0) THEN
      found_tax_codes_ := TRUE;
      Calculate_Line_Totals___(tax_info_table_,
                               tax_line_param_rec_);
   
      Source_Tax_Item_Invent_API.Create_Tax_Items(tax_info_table_, 
                                                  source_key_rec_, 
                                                  company_);
   ELSE
      found_tax_codes_ := FALSE;
   END IF;
END Add_Transaction_Tax_Info___;

PROCEDURE Remove_Part_Mov_Tax_Id_Tmp___(
   rec_or_iss_con_trans_      IN    Inventory_Transaction_Hist_API.Transaction_Id_Tab )
IS
BEGIN
   IF (rec_or_iss_con_trans_.COUNT > 0 ) THEN
      FORALL i IN rec_or_iss_con_trans_.FIRST..rec_or_iss_con_trans_.LAST
         DELETE cross_border_tax_trans_tmp         
         WHERE transaction_id = rec_or_iss_con_trans_(i);
   END IF;      
END Remove_Part_Mov_Tax_Id_Tmp___;

PROCEDURE Reverse_Tax_And_Postings___ (
   ignore_this_transaction_      OUT   BOOLEAN,
   company_                      IN    VARCHAR2, 
   transaction_id_               IN    NUMBER,
   old_transaction_id_           IN    NUMBER,   
   part_move_tax_direction_      IN    VARCHAR2,
   source_ref1_                  IN    VARCHAR2,
   source_ref2_                  IN    VARCHAR2,
   source_ref3_                  IN    VARCHAR2,
   source_ref4_                  IN    VARCHAR2,
   source_ref5_                  IN    VARCHAR2,
   source_ref_type_db_           IN    VARCHAR2,
   serial_no_                    IN    VARCHAR2 )
IS
   qty_                          NUMBER;
   old_qty_                      NUMBER;
   old_part_move_tax_id_         NUMBER;
   part_move_tax_id_             NUMBER;   
   source_key_rec_               Tax_Handling_Util_API.Source_Key_Rec;
   reversal_tax_info_table_      Tax_Handling_Util_API.Tax_Information_Table;
   rec_or_iss_con_reverse_trans_ Inventory_Transaction_Hist_API.Transaction_Id_Tab;
   part_move_tax_id_not_set      EXCEPTION;
   
BEGIN
   ignore_this_transaction_ := FALSE;   
   old_part_move_tax_id_ := Inventory_Transaction_hist_API.Get_Part_Move_Tax_Id(old_transaction_id_);
   IF (old_part_move_tax_id_ IS NOT NULL AND old_part_move_tax_id_ != 0) THEN         
      
      rec_or_iss_con_reverse_trans_.DELETE;
      -- if the tranaction is for a serial part, then find all the transactions connected to that receipt/issue reversal
      IF (serial_no_ != '*') THEN
         rec_or_iss_con_reverse_trans_ := Get_All_Rec_Or_Iss_Con_Trns___( source_ref1_,
                                                                          source_ref2_,
                                                                          source_ref3_,
                                                                          source_ref4_,
                                                                          source_ref5_,
                                                                          source_ref_type_db_,
                                                                          part_move_tax_direction_);
      ELSE
         rec_or_iss_con_reverse_trans_(1) := transaction_id_;         
      END IF;
      
      -- Remove the selected set of transactions from cross_border_tax_trans_tmp though Part_Move_Tax_Id is successfully set or not.
      -- Unsuccessful scenario implies that those transactions will be processed by another similar job. So no need to keep them here.
      -- This will improve the performance by shrinking the size of the temporary table.
      Remove_Part_Mov_Tax_Id_Tmp___(rec_or_iss_con_reverse_trans_);
      
      -- Get the next value for part_move_tax_id_ 
      part_move_tax_id_ := part_move_tax_id_seq.NEXTVAL;
      
      BEGIN 
         -- Set the Part_Move_Tax_Id in InventoryTransactionHist. This will lock all the required transactions before updating.
         -- If this method fails, it implies that one of the transactions in the collection might have been used for tax reporting
         -- by similar other process. In that case we ignore the whole collection and move ahead with the next transaction record.
         @ApproveTransactionStatement(2021-09-30,asawlk)
         SAVEPOINT before_modify_Part_Move_Tax_Id;
         Inventory_Transaction_Hist_API.Set_Part_Move_Tax_Id(rec_or_iss_con_reverse_trans_, part_move_tax_id_);          
      EXCEPTION
         WHEN OTHERS THEN            
            @ApproveTransactionStatement(2021-09-30,asawlk)
            ROLLBACK TO before_modify_Part_Move_Tax_Id; 
            RAISE part_move_tax_id_not_set;
      END;

      qty_     := Inventory_Transaction_hist_API.Get_Sum_Qty_Part_Move_Tax_Id(part_move_tax_id_);
      old_qty_ := Inventory_Transaction_hist_API.Get_Sum_Qty_Part_Move_Tax_Id(old_part_move_tax_id_);
      
      -- TAX reversal start
      reversal_tax_info_table_ := Fetch_Reverse_Tax_Info___(company_, 
                                                            old_part_move_tax_id_,
                                                            qty_,
                                                            old_qty_);                                                          
                                                                  
      source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(source_ref_type_ => Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST,      
                                                                         source_ref1_     => part_move_tax_id_,
                                                                         source_ref2_     => '*',
                                                                         source_ref3_     => '*',
                                                                         source_ref4_     => '*',
                                                                         source_ref5_     => '*',
                                                                         attr_            => NULL);
                                                                         
      IF (reversal_tax_info_table_.COUNT > 0) THEN   
         Source_Tax_Item_Invent_API.Create_Tax_Items(reversal_tax_info_table_, 
                                                     source_key_rec_, 
                                                     company_);
      END IF;
      -- TAX reversal end
      
      -- Reverse Postings
      Part_Move_Tax_Accounting_API.Reverse_Postings ( company_                => company_,
                                                      source_ref1_            => part_move_tax_id_,
                                                      source_ref2_            => '*',
                                                      tax_item_id_            => 1,
                                                      old_source_ref1_        => old_part_move_tax_id_,
                                                      old_source_ref2_        => '*',
                                                      old_tax_item_id_        => 1,
                                                      old_source_ref_type_db_ => Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST,                                                      
                                                      qty_                    => qty_,
                                                      old_qty_                => old_qty_);      
   END IF;
EXCEPTION 
   WHEN part_move_tax_id_not_set THEN
      ignore_this_transaction_ := TRUE;
   WHEN OTHERS THEN
      RAISE;   
END Reverse_Tax_And_Postings___;

FUNCTION Fetch_Reverse_Tax_Info___ (                  
   company_                      IN    VARCHAR2,
   old_part_move_tax_id_         IN    VARCHAR2,
   quantity_                     IN    NUMBER,
   old_quantity_                 IN    NUMBER ) RETURN Tax_Handling_Util_API.Tax_Information_Table 
IS
   original_tax_item_tab_        Source_Tax_Item_API.Source_Tax_Table;
   reversal_tax_info_table_      Tax_Handling_Util_API.Tax_Information_Table;
BEGIN
   original_tax_item_tab_ := Source_Tax_Item_API.Get_Tax_Items(company_ => company_, 
                                                               source_ref_type_  => Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST,
                                                               source_ref1_      => old_part_move_tax_id_,
                                                               source_ref2_      => NULL,
                                                               source_ref3_      => NULL,
                                                               source_ref4_      => NULL,
                                                               source_ref5_      => NULL);
                                                               
   IF (original_tax_item_tab_.COUNT > 0) THEN
      FOR i_ IN original_tax_item_tab_.FIRST..original_tax_item_tab_.LAST LOOP
         reversal_tax_info_table_(i_).tax_code              := original_tax_item_tab_(i_).tax_code;
         reversal_tax_info_table_(i_).tax_percentage        := original_tax_item_tab_(i_).tax_percentage;
         reversal_tax_info_table_(i_).tax_curr_amount       := original_tax_item_tab_(i_).tax_curr_amount * (-1) * (quantity_/old_quantity_);
         reversal_tax_info_table_(i_).tax_dom_amount        := original_tax_item_tab_(i_).tax_dom_amount * (-1) * (quantity_/old_quantity_);
         reversal_tax_info_table_(i_).tax_para_amount       := CASE 
                                                                  WHEN (original_tax_item_tab_(i_).tax_parallel_amount IS NULL) THEN
                                                                     NULL
                                                                  ELSE
                                                                     (original_tax_item_tab_(i_).tax_parallel_amount)* (-1) * (quantity_/old_quantity_)
                                                                  END;
         reversal_tax_info_table_(i_).tax_base_curr_amount  := original_tax_item_tab_(i_).tax_base_curr_amount * (-1) * (quantity_/old_quantity_);
         reversal_tax_info_table_(i_).tax_base_dom_amount   := original_tax_item_tab_(i_).tax_base_dom_amount * (-1) * (quantity_/old_quantity_);
         reversal_tax_info_table_(i_).tax_base_para_amount  := CASE
                                                                  WHEN (original_tax_item_tab_(i_).tax_base_parallel_amount IS NULL) THEN
                                                                     NULL
                                                                  ELSE
                                                                     (original_tax_item_tab_(i_).tax_base_parallel_amount) * (-1) * (quantity_/old_quantity_)
                                                                  END;
      END LOOP;   
   END IF;
   RETURN reversal_tax_info_table_;   
END Fetch_Reverse_Tax_Info___; 


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-- Create_Cross_Border_Vouchers__
--   This is the implementation of intracompany cross-border part movement tax reporting per site. 
--   This will add tax lines, create postings and vouchers for a particular site.

PROCEDURE Create_Cross_Border_Vouchers__ (
   attr_     VARCHAR2)
IS
   ptr_                          NUMBER;
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(2000);
   contract_                     VARCHAR2(5);
   from_date_                    DATE;
   to_date_                      DATE;
   execution_offset_from_        NUMBER;
   execution_offset_to_          NUMBER;
   sender_contract_              VARCHAR2(5);
   sender_country_code_          VARCHAR2(2);
   receiver_contract_            VARCHAR2(5);
   receiver_country_code_        VARCHAR2(2);
   part_move_tax_id_             NUMBER;
   rec_or_iss_con_trans_         Inventory_Transaction_Hist_API.Transaction_Id_Tab;
   no_transactions_found_        EXCEPTION;
   total_inventory_cost_         NUMBER;
   date_applied_local_           DATE;
   site_date_                    DATE;
   transactions_found_           BOOLEAN := FALSE;
   company_                      VARCHAR2(20);
   ignore_this_transaction_      BOOLEAN := FALSE;
   found_tax_codes_              BOOLEAN := FALSE;
   rollback_and_skip_trans_      BOOLEAN := FALSE;
                
   CURSOR find_cross_border_tax_trans IS
      SELECT transaction_id, original_transaction_id, contract, part_no, serial_no, 
             source_ref1, source_ref2, source_ref3, source_ref4, source_ref5, 
             source_ref_type, part_move_tax_id, mtc.part_move_tax_direction_db               
        FROM inventory_transaction_hist_tab ith, mpccom_transaction_code_pub mtc 
       WHERE part_move_tax_id = 0  
         AND contract = contract_       
         AND date_applied >= from_date_ 
         AND date_applied <= to_date_
         AND ith.transaction_code = mtc.transaction_code;      
         
   CURSOR get_all_trans_temp_ IS
      SELECT *
        FROM cross_border_tax_trans_tmp
    ORDER BY transaction_id;
         
   TYPE Cross_Border_Tax_Trans_Tab IS TABLE OF find_cross_border_tax_trans%ROWTYPE;
   cross_border_tax_trans_tab_   Cross_Border_Tax_Trans_Tab;
  
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'CONTRACT') THEN
         contract_ := value_;
      ELSIF (name_ = 'FROM_DATE') THEN
         from_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'TO_DATE') THEN
         to_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'EXECUTION_OFFSET_FROM') THEN
         execution_offset_from_ := value_;
      ELSIF (name_ = 'EXECUTION_OFFSET_TO') THEN
         execution_offset_to_ := value_;
      ELSE
         Error_SYS.Item_Not_Exist(lu_name_, name_, value_);
      END IF;
   END LOOP;
   
   IF (from_date_ IS NULL AND to_date_ IS NULL AND execution_offset_from_ IS NOT NULL AND execution_offset_to_ IS NOT NULL) THEN
      site_date_  := Site_API.Get_Site_Date(contract_); 
      from_date_  := TRUNC(site_date_) - execution_offset_from_;
      to_date_    := TRUNC(site_date_) - execution_offset_to_;
   END IF;
   
   DELETE FROM cross_border_tax_trans_tmp;
   
   OPEN find_cross_border_tax_trans;
   LOOP
      FETCH find_cross_border_tax_trans BULK COLLECT INTO cross_border_tax_trans_tab_ LIMIT 1000;
      -- Now we add the selected transactions to cross_border_tax_trans_tmp for the purpose of re-accessing
      -- these records repeatedly in later parts.
      EXIT WHEN cross_border_tax_trans_tab_.COUNT = 0;      
      transactions_found_  := TRUE;
      
      FORALL i IN cross_border_tax_trans_tab_.FIRST..cross_border_tax_trans_tab_.LAST
         INSERT INTO cross_border_tax_trans_tmp            
         VALUES cross_border_tax_trans_tab_(i);
   END LOOP;   
   CLOSE find_cross_border_tax_trans;
   cross_border_tax_trans_tab_.DELETE;
   
   -- If no transactions were found for tax reporting, then raise an exception
   IF (NOT transactions_found_) THEN 
      RAISE no_transactions_found_;
   END IF;
   
   company_ := Site_API.Get_Company(contract_);
   
   FOR trans_rec_temp_ IN get_all_trans_temp_ LOOP
      -- This checks whether this transaction is already included in the tax reporting. This type of scenario would come
      -- when this transaction is for a serial part and other transaction/s belonging to the same receipt or issue
      -- had been included in the tax reporting. in such a situation this transaction is also included as it is in 
      -- the same receipt or issue. Therefore no need to proceed with this transction. This check should be the very first
      -- thing to do before proceeding. This check is performed against cross_border_tax_trans_tmp instead of InventoryTransactionHist
      -- in order to improve the performance.
      IF NOT Check_Exist_Tmp___(trans_rec_temp_.transaction_id) THEN
         CONTINUE;
      END IF;
      -- This is a reversal transaction, hence reported tax and postings should be reversed.      
      IF (trans_rec_temp_.original_transaction_id IS NOT NULL) THEN 
         Reverse_Tax_And_Postings___(ignore_this_transaction_,
                                     company_, 
                                     trans_rec_temp_.transaction_id, 
                                     trans_rec_temp_.original_transaction_id,                                     
                                     trans_rec_temp_.part_move_tax_direction,
                                     trans_rec_temp_.source_ref1,
                                     trans_rec_temp_.source_ref2,
                                     trans_rec_temp_.source_ref3,
                                     trans_rec_temp_.source_ref4,
                                     trans_rec_temp_.source_ref5,
                                     trans_rec_temp_.source_ref_type,
                                     trans_rec_temp_.serial_no);
         -- The transaction in consideration is either already used for tax reporting by a similar process or should not be included for someother reason                            
         IF (ignore_this_transaction_) THEN
            CONTINUE;
         END IF;   
      ELSE
         Find_Src_and_Dest_By_Src_Ref(sender_contract_,   
                                      sender_country_code_,
                                      receiver_contract_,   
                                      receiver_country_code_,
                                      trans_rec_temp_.source_ref1,
                                      trans_rec_temp_.source_ref2,
                                      trans_rec_temp_.source_ref3,
                                      trans_rec_temp_.source_ref4,
                                      trans_rec_temp_.source_ref5,
                                      trans_rec_temp_.source_ref_type,
                                      trans_rec_temp_.part_move_tax_direction);
         
         -- Validate whether sender and receiver contracts belongs to the same company
         IF (Company_Site_API.Get_Company(sender_contract_) != Company_Site_API.Get_Company(receiver_contract_)) THEN
            CONTINUE;
         END IF;

         -- Validate sender country and receiver country
         IF (sender_country_code_ = receiver_country_code_) THEN
            CONTINUE;
         END IF;     

         rec_or_iss_con_trans_.DELETE;

         -- if the tranaction is for a serial part, then find all the transactions connected to that receipt or issue
         IF (trans_rec_temp_.serial_no != '*') THEN
            rec_or_iss_con_trans_ := Get_All_Rec_Or_Iss_Con_Trns___( trans_rec_temp_.source_ref1,
                                                                     trans_rec_temp_.source_ref2,
                                                                     trans_rec_temp_.source_ref3,
                                                                     trans_rec_temp_.source_ref4,
                                                                     trans_rec_temp_.source_ref5,
                                                                     trans_rec_temp_.source_ref_type,
                                                                     trans_rec_temp_.part_move_tax_direction);
         ELSE
            rec_or_iss_con_trans_(1) := trans_rec_temp_.transaction_id;         
         END IF;
         
         -- Remove the selected set of transactions from cross_border_tax_trans_tmp though Part_Move_Tax_Id is successfully set or not.
         -- Unsuccessful scenario implies that those transactions will be processed by another similar job. So no need to keep them here.
         -- This will improve the performance by shrinking the size of the temporary table.
         Remove_Part_Mov_Tax_Id_Tmp___(rec_or_iss_con_trans_);
         
         -- Get the next value for part_move_tax_id_ 
         part_move_tax_id_ := part_move_tax_id_seq.NEXTVAL;

         BEGIN 
            -- Set the Part_Move_Tax_Id in InventoryTransactionHist. This will lock all the required transactions before updating.
            -- If this method fails, it implies that one of the transactions in the collection might have been used for tax reporting
            -- by similar other process. In that case we ignore the whole collection and move ahead with the next transaction record.
            @ApproveTransactionStatement(2021-09-30,asawlk)
            SAVEPOINT before_modify_Part_Move_Tax_Id;
            Inventory_Transaction_Hist_API.Set_Part_Move_Tax_Id(rec_or_iss_con_trans_, part_move_tax_id_);          
         EXCEPTION
            WHEN OTHERS THEN            
               @ApproveTransactionStatement(2021-09-30,asawlk)
               ROLLBACK TO before_modify_Part_Move_Tax_Id; 
               CONTINUE;
         END;
         -- This will get the total transaction cost for the collection of transactions  
         total_inventory_cost_ := Inventory_Transaction_Hist_API.Get_Sum_Inventory_Cost(rec_or_iss_con_trans_); 
         
         -- This will again get the date_applied from InventoryTransactionHist after locking the transactions.
         date_applied_local_ := Inventory_Transaction_Hist_API.Get_Date_Applied(trans_rec_temp_.transaction_id);
         
         rollback_and_skip_trans_ := FALSE;
         
         -- Check whether the date_applied has been changed in between retrieving the transactions and locking the transactions
         -- in a way that it falls out of the considered date range. If so skip that transaction.
         IF (date_applied_local_ < from_date_ OR date_applied_local_ > to_date_) THEN
            rollback_and_skip_trans_:= TRUE;
         END IF;
         
         -- Validate company has valid tax ID numbers registered for both sender and receiver countries.
         IF NOT (rollback_and_skip_trans_) THEN
            $IF Component_Invoic_SYS.INSTALLED $THEN
               IF (Tax_Liability_Countries_API.Get_Tax_Id_Number_Db (company_, receiver_country_code_, date_applied_local_) IS NULL OR 
                   Tax_Liability_Countries_API.Get_Tax_Id_Number_Db (company_, sender_country_code_, date_applied_local_) IS NULL) THEN
                  rollback_and_skip_trans_:= TRUE;
               END IF;
            $ELSE 
               rollback_and_skip_trans_:= TRUE;
            $END
         END IF;
         
         IF NOT (rollback_and_skip_trans_) THEN
            -- Create Source Tax Item lines.
            Add_Transaction_Tax_Info___(found_tax_codes_,
                                        part_move_tax_id_,
                                        company_,
                                        trans_rec_temp_.part_no,
                                        sender_country_code_,
                                        receiver_country_code_,
                                        total_inventory_cost_,
                                        trans_rec_temp_.part_move_tax_direction,
                                        date_applied_local_);
         END IF;
         
         -- If it needs to rollback, or no tax codes are found, skip the transaction and
         -- rallback to avoid setting value for Part_Move_Tax_Id in Inventory_Transaction_Hist.
         IF (rollback_and_skip_trans_ OR NOT found_tax_codes_) THEN
            @ApproveTransactionStatement(2022-01-13,malllk)
            ROLLBACK TO before_modify_Part_Move_Tax_Id;
            CONTINUE;
         END IF;

         -- Create Postings for the created Source Tax Item Lines
         Part_Move_Tax_Accounting_API.Create_Postings (part_move_tax_id_,
                                                       '*',
                                                       Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST,
                                                       company_,
                                                       trans_rec_temp_.part_move_tax_direction,
                                                       trans_rec_temp_.contract,
                                                       date_applied_local_);
      END IF;   
   END LOOP;   
   Part_Move_Tax_Accounting_API.Create_Vouchers (company_, 
                                                 from_date_, 
                                                 to_date_, 
                                                 Tax_Source_API.DB_INVENTORY_TRANSACTION_HIST);
EXCEPTION 
   WHEN no_transactions_found_ THEN
      Transaction_SYS.Set_Status_info(Language_SYS.Translate_Constant(lu_name_, 'NO_TRANS_FOUND: No inventory transactions were found to report cross border tax.'), 'INFO');
END Create_Cross_Border_Vouchers__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Cross_Border_Vouchers
--    This public method starts the batch job that collects intracompany cross-border
--    part movement tax transactions. This will add tax lines, create postings and
--    vouchers.
PROCEDURE Create_Cross_Border_Vouchers (
   company_               IN VARCHAR2,
   from_date_             IN DATE,
   to_date_               IN DATE,
   execution_offset_from_ IN NUMBER,
   execution_offset_to_   IN NUMBER )
IS
   attr_       VARCHAR2(32000);
   attr_local_ VARCHAR2(32000);
   batch_desc_ VARCHAR2(2000);
   
   CURSOR get_contracts IS
      SELECT uas.site contract
        FROM site_public sp,
             user_allowed_site_pub uas
       WHERE sp.contract = uas.site
         AND sp.company = company_;
         
BEGIN
   -- Check the user is authorized for the company.
   User_Finance_API.Is_User_Authorized(company_);
   
   Client_SYS.Clear_Attr(attr_);   
   Client_SYS.Add_To_Attr('FROM_DATE', from_date_, attr_);
   Client_SYS.Add_To_Attr('TO_DATE', to_date_, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_OFFSET_FROM', execution_offset_from_, attr_);
   Client_SYS.Add_To_Attr('EXECUTION_OFFSET_TO', execution_offset_to_, attr_);
   
   -- Execute cross border voucher creation per site
   FOR rec_ IN get_contracts LOOP
      attr_local_ := attr_; 
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_local_);
      IF (Transaction_SYS.Is_Session_Deferred()) THEN
         Create_Cross_Border_Vouchers__(attr_local_);      
      ELSE
         batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'CREATEINTRACOMPVOUCHER: Create intracompany cross border vouchers.');
         Transaction_SYS.Deferred_Call('Tax_Handling_Invent_Util_API.Create_Cross_Border_Vouchers__', attr_local_, batch_desc_);
      END IF;
   END LOOP;   
END Create_Cross_Border_Vouchers;


-- Validate_Params
--    Validates the parameters when running the schedule for collect
--    intracompany cross-border part movement tax transactions.
PROCEDURE Validate_Params (
   message_     IN VARCHAR2 )
IS
   count_                 NUMBER;
   name_arr_              Message_SYS.name_table;
   value_arr_             Message_SYS.line_table;
   company_               VARCHAR2(20);
   from_date_             DATE;
   to_date_               DATE;
   execution_offset_from_ NUMBER;
   execution_offset_to_   NUMBER;
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);
   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'COMPANY_') THEN
         company_ := value_arr_(n_);
      ELSIF (name_arr_(n_) = 'FROM_DATE_') THEN
         from_date_ := TO_DATE(SUBSTR(value_arr_(n_), 1,10), 'YYYY-MM-DD');
      ELSIF (name_arr_(n_) = 'TO_DATE_') THEN
         to_date_ := TO_DATE(SUBSTR(value_arr_(n_), 1,10), 'YYYY-MM-DD');
      ELSIF (name_arr_(n_) = 'EXECUTION_OFFSET_FROM_') THEN
         execution_offset_from_ := NVL(value_arr_(n_), 0);
      ELSIF (name_arr_(n_) = 'EXECUTION_OFFSET_TO_') THEN
         execution_offset_to_ := NVL(value_arr_(n_), 0);
      END IF;
   END LOOP;

   -- Validate whether user has access to company
   User_Finance_API.Exist(company_, Fnd_Session_API.Get_Fnd_User);
   
   IF (to_date_ IS NOT NULL AND from_date_ IS NOT NULL) THEN
      -- Validate From Date and To Date
      IF (to_date_ > TRUNC(SYSDATE)) THEN
         Error_Sys.Record_General(lu_name_, 'TODATEFUTURE: To Date can not be a future date.');
      END IF;
      IF (from_date_ > to_date_) THEN
         Error_Sys.Record_General(lu_name_, 'FROMDATELESS: To Date must be equal or greater than From Date.');
      END IF;
   ELSE
      -- Validate Execution Offset From and Execution Offset To
      IF (execution_offset_from_ < 0 OR execution_offset_from_ != ROUND(execution_offset_from_)) THEN
         Error_Sys.Record_General(lu_name_, 'NEGOFFSETFROM: Execution Offset From should be a positive integer.');
      END IF;
      IF (execution_offset_to_ < 0 OR execution_offset_to_ != ROUND(execution_offset_to_)) THEN
         Error_Sys.Record_General(lu_name_, 'NEGOFFSETTO: Execution Offset To should be a positive integer.');
      END IF;
      IF (execution_offset_from_ < execution_offset_to_) THEN
         Error_Sys.Record_General(lu_name_, 'FROMDATELESS: To Date must be equal or greater than From Date.');
      END IF;
   END IF;
END Validate_Params;


-- Fetch_Tax_Code_On_Object
--    Fetch sender and receiver country tax codes from intracompany cross-border 
--    part movement tax basic data setup.
PROCEDURE Fetch_Tax_Code_On_Object (
   tax_source_object_rec_      IN OUT Tax_Handling_Util_API.tax_source_object_rec,  
   company_                    IN     VARCHAR2,
   sender_country_db_          IN     VARCHAR2,
   receiver_country_db_        IN     VARCHAR2,
   date_applied_               IN     VARCHAR2,
   part_move_tax_direction_db_ IN     VARCHAR2)
IS
BEGIN
   IF (tax_source_object_rec_.object_id IS NOT NULL AND tax_source_object_rec_.object_type = 'INV_MOVE_PART') THEN
      IF (part_move_tax_direction_db_ = Part_Move_Tax_Direction_API.DB_SENDER) THEN
         tax_source_object_rec_.object_tax_code := Cross_Border_Part_Send_Tax_API.Get_Latest_Sender_Tax_Code(company_,
                                                                                                             sender_country_db_,
                                                                                                             receiver_country_db_,
                                                                                                             tax_source_object_rec_.object_id,
                                                                                                             date_applied_);
      ELSIF (part_move_tax_direction_db_ = Part_Move_Tax_Direction_API.DB_RECEIVER) THEN
         tax_source_object_rec_.object_tax_code := Cross_Border_Part_Rece_Tax_API.Get_Latest_Receiver_Tax_Code(company_,
                                                                                                               sender_country_db_,
                                                                                                               receiver_country_db_,
                                                                                                               tax_source_object_rec_.object_id,
                                                                                                               date_applied_);
      END IF;
   END IF;
END Fetch_Tax_Code_On_Object;


-- Calculate_Calctax_Tax_Amounts
--   Calculate and return tax amounts considering Calculated-tax Tax rates.
--   Note that these Calculated-Tax tax rates are not used when adding 
--   tax lines but only when create tax postings.
@IgnoreUnitTest TrivialFunction
PROCEDURE Calculate_Calctax_Tax_Amounts (
   tax_curr_amount_       OUT NUMBER,
   tax_dom_amount_        OUT NUMBER,   
   tax_parallel_amount_   OUT NUMBER,
   tax_base_curr_amount_  IN  NUMBER,
   company_               IN  VARCHAR2,
   tax_code_              IN  VARCHAR2,
   tax_percentage_        IN  NUMBER,
   date_applied_          IN  DATE)
IS
   attr_                      VARCHAR2(32000);
   acc_currency_code_         VARCHAR2(3);
   total_tax_curr_amount_     NUMBER;
   total_tax_dom_amount_      NUMBER;
   total_tax_para_amount_     NUMBER;
   non_ded_tax_amount_        NUMBER;
   tax_base_dom_amount_       NUMBER;
   tax_base_para_amount_      NUMBER;
   currency_conv_factor_      NUMBER;
   currency_rate_             NUMBER;
   para_currency_conv_factor_ NUMBER;
   para_currency_rate_        NUMBER;
   para_curr_inverted_        VARCHAR2(5);
BEGIN
   -- Note: Here it is considered accounting currency as the transaction currency
   acc_currency_code_ :=  Company_Finance_API.Get_Currency_Code(company_);
   
   Currency_Rate_API.Get_Currency_Rate(currency_conv_factor_, 
                                       currency_rate_, 
                                       company_, 
                                       acc_currency_code_, 
                                       Currency_Type_API.Get_Default_Type(company_), 
                                       date_applied_);
                                       
   Currency_Rate_API.Get_Parallel_Currency_Rate(para_currency_rate_, 
                                                para_currency_conv_factor_,
                                                para_curr_inverted_,
                                                company_, 
                                                acc_currency_code_, 
                                                date_applied_);
   
   Tax_Handling_Util_API.Calc_Tax_Curr_Amount (total_tax_curr_amount_    => total_tax_curr_amount_,
                                               tax_curr_amount_          => tax_curr_amount_,
                                               non_ded_tax_curr_amount_  => non_ded_tax_amount_,
                                               attr_                     => attr_,  
                                               company_                  => company_, 
                                               identity_                 => NULL,
                                               party_type_db_            => NULL,
                                               currency_                 => acc_currency_code_,
                                               delivery_address_id_      => NULL,
                                               tax_code_                 => tax_code_,
                                               tax_type_db_              => Fee_Type_API.DB_CALCULATED_TAX,
                                               tax_calc_base_amount_     => tax_base_curr_amount_,
                                               tax_calc_base_percent_    => 100,
                                               use_tax_calc_base_amount_ => NULL,
                                               tax_percentage_           => tax_percentage_,
                                               in_deductible_factor_     => NULL);
                                                       
   Tax_Handling_Util_API.Calc_Tax_Dom_Amount (total_tax_dom_amount_   => total_tax_dom_amount_,
                                              tax_dom_amount_         => tax_dom_amount_,
                                              non_ded_tax_dom_amount_ => non_ded_tax_amount_,   
                                              tax_base_dom_amount_    => tax_base_dom_amount_,
                                              attr_                   => attr_,
                                              company_                => company_,
                                              currency_               => acc_currency_code_,
                                              use_specific_rate_      => Fnd_Boolean_API.DB_FALSE,
                                              tax_code_               => tax_code_,
                                              total_tax_curr_amount_  => total_tax_curr_amount_,
                                              tax_curr_amount_        => tax_curr_amount_,
                                              tax_base_curr_amount_   => tax_base_curr_amount_,
                                              tax_percentage_         => tax_percentage_,
                                              in_deductible_factor_   => NULL,
                                              curr_rate_              => currency_rate_,
                                              conv_factor_            => currency_conv_factor_);
                                              
   Tax_Handling_Util_API.Calc_Tax_Para_Amount (total_tax_para_amount_   => total_tax_para_amount_,
                                               tax_para_amount_         => tax_parallel_amount_,
                                               non_ded_tax_para_amount_ => non_ded_tax_amount_,
                                               tax_base_para_amount_    => tax_base_para_amount_,
                                               attr_                    => attr_,
                                               company_                 => company_,
                                               currency_                => acc_currency_code_,
                                               calculate_para_amounts_  => Fnd_Boolean_API.DB_TRUE,
                                               total_tax_curr_amount_   => total_tax_curr_amount_,
                                               total_tax_dom_amount_    => total_tax_dom_amount_,
                                               tax_curr_amount_         => tax_curr_amount_,
                                               tax_dom_amount_          => tax_dom_amount_,
                                               tax_base_curr_amount_    => tax_base_curr_amount_,
                                               tax_base_dom_amount_     => tax_base_dom_amount_,
                                               para_curr_rate_          => para_currency_rate_,
                                               para_conv_factor_        => para_currency_conv_factor_);
END Calculate_Calctax_Tax_Amounts;

@UncheckedAccess
PROCEDURE Find_Src_and_Dest_By_Src_Ref (
   sender_contract_              OUT VARCHAR2,   
   sender_country_code_          OUT VARCHAR2,
   receiver_contract_            OUT VARCHAR2,   
   receiver_country_code_        OUT VARCHAR2,
   source_ref1_                  IN  VARCHAR2,
   source_ref2_                  IN  VARCHAR2,
   source_ref3_                  IN  VARCHAR2,
   source_ref4_                  IN  VARCHAR2,
   source_ref5_                  IN  VARCHAR2,
   source_ref_type_db_           IN  VARCHAR2,
   part_move_tax_direction_db_   IN  VARCHAR2)
   
IS
BEGIN
   IF (source_ref_type_db_ = Order_Type_API.DB_SHIPMENT_ORDER) THEN
      Find_Ship_Ord_Src_and_Dest___(sender_contract_,
                                    sender_country_code_,
                                    receiver_contract_,                                       
                                    receiver_country_code_,
                                    source_ref1_,
                                    source_ref2_,
                                    source_ref5_);

   ELSIF (source_ref_type_db_ = Order_Type_API.DB_CUSTOMER_ORDER) THEN
      Find_Cust_Ord_Src_and_Dest___(sender_contract_,
                                    sender_country_code_,
                                    receiver_contract_,
                                    receiver_country_code_,
                                    source_ref1_,
                                    source_ref2_,
                                    source_ref3_,
                                    source_ref4_,
                                    source_ref5_,
                                    part_move_tax_direction_db_);

   ELSIF (source_ref_type_db_ = Order_Type_API.DB_PURCHASE_ORDER) THEN
      Find_Pur_Ord_Src_and_Dest___(sender_contract_,
                                   sender_country_code_,
                                   receiver_contract_,
                                   receiver_country_code_,
                                   source_ref1_,
                                   source_ref2_,
                                   source_ref3_,
                                   part_move_tax_direction_db_);
   
   ELSIF (source_ref_type_db_ = Order_Type_API.DB_RETURN_MTRL_AUTHORIZATION) THEN
      Find_Rma_Src_and_Dest___(sender_contract_,
                               sender_country_code_,
                               receiver_contract_,
                               receiver_country_code_,
                               source_ref1_,
                               source_ref4_);   
   END IF;
END Find_Src_and_Dest_By_Src_Ref;

@UncheckedAccess
PROCEDURE Find_Shipment_Src_and_Dest (
   sender_contract_              OUT VARCHAR2,   
   sender_country_code_          OUT VARCHAR2,
   receiver_contract_            OUT VARCHAR2,   
   receiver_country_code_        OUT VARCHAR2,
   shipment_id_                  IN  NUMBER)
IS
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN
      shipment_rec_        Shipment_API.Public_Rec;
      dummy_warehouse_     VARCHAR2(15);
   $END
BEGIN
   $IF (Component_Shpmnt_SYS.INSTALLED) $THEN                                                 
      shipment_rec_ := Shipment_API.Get(shipment_id_);
      IF (shipment_rec_.receiver_type IN (Sender_Receiver_Type_API.DB_SITE, 
                                          Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE,
                                          Sender_Receiver_Type_API.DB_CUSTOMER)) THEN 
         sender_contract_  := shipment_rec_.contract;
         sender_country_code_   := shipment_rec_.sender_country;
         receiver_country_code_ := shipment_rec_.receiver_country;

         IF (shipment_rec_.receiver_type = Sender_Receiver_Type_API.DB_SITE) THEN
            receiver_contract_ := shipment_rec_.receiver_id;
         ELSIF (shipment_rec_.receiver_type = Sender_Receiver_Type_API.DB_REMOTE_WAREHOUSE) THEN
            Warehouse_API.Get_Keys_By_Global_Id(receiver_contract_, dummy_warehouse_, shipment_rec_.receiver_id);
         ELSIF (shipment_rec_.receiver_type = Sender_Receiver_Type_API.DB_CUSTOMER) THEN
            $IF (Component_Order_SYS.INSTALLED) $THEN
               receiver_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(shipment_rec_.receiver_id);
            $ELSE
               Error_SYS.Component_Not_Exist('ORDER');
            $END            
         END IF;   
      END IF;      
   $ELSE
      Error_SYS.Component_Not_Exist('SHPMNT');
   $END   
END Find_Shipment_Src_and_Dest;

                                                     
-- Get_Inv_Trans_Send_Rec_Country
--   Returns the sender and receiver country code for given part move tax id.
@IgnoreUnitTest TrivialFunction
PROCEDURE Get_Inv_Trans_Send_Rec_Country (
   sender_country_code_    OUT VARCHAR2,
   receiver_country_code_  OUT VARCHAR2,
   part_move_tax_id_       IN  NUMBER)
IS      
   sender_contract_            VARCHAR2(5);
   receiver_contract_          VARCHAR2(5);
   part_move_tax_direction_db_ VARCHAR2(20);
   source_ref1_                VARCHAR2(50);
   source_ref2_                VARCHAR2(50);
   source_ref3_                VARCHAR2(50);
   source_ref4_                VARCHAR2(50);
   source_ref5_                VARCHAR2(50);
   source_ref_type_db_         VARCHAR2(50);
   transaction_code_           VARCHAR2(10);
BEGIN
   Inventory_Transaction_Hist_API.Get_Src_Ref_By_Part_Mov_Tax_Id(source_ref1_, 
                                                                 source_ref2_, 
                                                                 source_ref3_, 
                                                                 source_ref4_, 
                                                                 source_ref5_, 
                                                                 source_ref_type_db_,
                                                                 transaction_code_,
                                                                 part_move_tax_id_);
                                                                 
   part_move_tax_direction_db_ := Mpccom_Transaction_Code_API.Get_Part_Move_Tax_Direction_Db(transaction_code_);
   
   Find_Src_and_Dest_By_Src_Ref (sender_contract_,   
                                 sender_country_code_,
                                 receiver_contract_,   
                                 receiver_country_code_,
                                 source_ref1_,
                                 source_ref2_,
                                 source_ref3_,
                                 source_ref4_,
                                 source_ref5_,
                                 source_ref_type_db_,
                                 part_move_tax_direction_db_);
END Get_Inv_Trans_Send_Rec_Country;
