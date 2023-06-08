-----------------------------------------------------------------------------
--
--  Logical unit: PerOhAdjustmentInvent
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200921  Dinklk  MF2020R1-7197, Added posting_group_id as a parameter to Adjust_Fifo_Lifo_Overheads___, Adjust_Pre_Trans_Cost_Oh___, Adjust_Unit_Cost_Overheads___
--  200921          and Adjust_Trans_Overheads___. Modified above methods to support actual overhead adjustments implementation.
--- 150512  MAHPLK  KES-402, Renamed usage of order_no, release_no, sequence_no, line_item_no, order_type attributes of  
--  150512          InventoryTransactionHist to source_ref1, source_ref2, source_ref3, source_ref4, source_ref_type.
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090930  Chfolk  Removed un used parameter adjustment_date_ from Adjust_Fifo_Lifo_Overheads___,
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  090930          Adjust_Unit_Cost_Overheads___ and Adjust_Pre_Trans_Cost_Oh___.
--- ------------------------------- 14.0.0 ------------------------------------
--  080123  LEPESE  Bug 68763, modifications in Adjust_Trans_Overheads___ to find the purchase order
--  080123          reference and pass it on to Inventory_Transaction_Cost_API.Modify_Unit_Cost.
--  070820  ErSrLK  Bug 65666, new parameters in call to Inventory_Transaction_Cost_API.Modify_Unit_Cost
--  070820          from method Adjust_Trans_Overheads___.
--  060217  JoAnSe  Added Balance_Transit_And_Invent___
--  060215  JoAnSe  Added parameter value_adjustment_ in call to Reverse_Accounting.
--  060202  JoAnSe  Replaced calls to Mpccom_Accounting_API.Reverse_Accounting
--  060202          with Inventory_Transaction_Hist_API.Reverse_Accounting
--  060202          Removed call to Reval_Cancel_After_Oh_Adjust now handled 
--  060202          within Reverse_Accounting
--  060124  JoAnSe  Added call to Inventory_Transaction_Hist_API.Reval_Cancel_After_Oh_Adjust
--  060124          in Adjust_Trans_Overheads___
--  060119  SeNslk  Modified the template version as 2.3 and added UNDEFINE 
--  060119          according to the new template.
--  -------------------------------------- 13.3.0 ---------------------------
--  060104  JoAnSe  Removed temporary comments in code.
--  051117  JoAnSe  Added ORDER BY to cursor in Adjust_Trans_Overheads___
--  051112  JoAnSe  Replaced SYSDATE with Site_API.Get_Site_Date
--  051102  JoAnSe  Added call to update InventoryPartUnitCost
--  051018  JoAnSe  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Adjust_Trans_Overheads___
--   Adjust overheads for for all inventory transactions in a company having
--   overheads with the specified accounting_year, cost_bucket_public_type
--   and cost_source_id
PROCEDURE Adjust_Trans_Overheads___ (
   company_                 IN VARCHAR2,
   adjustment_id_           IN NUMBER,
   accounting_year_         IN VARCHAR2,
   cost_bucket_public_type_ IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   posting_group_id_        IN VARCHAR2,
   adjustment_percentage_   IN NUMBER,
   adjustment_date_         IN DATE )
IS
   use_trans_bal_posting_db_  VARCHAR2(20);
   adjusted_cost_             NUMBER;
   empty_value_detail_tab_    Mpccom_Accounting_API.Value_Detail_Tab;
   inv_trans_rec_             Inventory_Transaction_Hist_API.Public_Rec;
   date_applied_              DATE;
   purch_order_ref1_          inventory_transaction_hist_tab.source_ref1%TYPE;
   purch_order_ref2_          inventory_transaction_hist_tab.source_ref2%TYPE;
   purch_order_ref3_          inventory_transaction_hist_tab.source_ref3%TYPE;
   purch_order_ref4_          inventory_transaction_hist_tab.source_ref4%TYPE;

   TYPE t_row IS RECORD (
     transaction_id            inventory_transaction_cost_tab.transaction_id%TYPE,
     contract                  inventory_transaction_cost_tab.contract%TYPE,
     cost_bucket_id            inventory_transaction_cost_tab.cost_bucket_id%TYPE,
     cost_source_id            inventory_transaction_cost_tab.cost_source_id%TYPE,
     unit_cost                 inventory_transaction_cost_tab.unit_cost%TYPE,
     added_to_this_transaction inventory_transaction_cost_tab.added_to_this_transaction%TYPE );
     
   TYPE oh_transaction_tab IS TABLE OF t_row INDEX BY PLS_INTEGER;
   oh_transaction_arr_     oh_transaction_tab;
   i_                      PLS_INTEGER;
BEGIN
   use_trans_bal_posting_db_ := Company_Invent_Info_API.Get_Use_Trans_Bal_Posting_Db(company_);

   IF posting_group_id_ IS NOT NULL THEN
      $IF Component_Cost_SYS.INSTALLED $THEN
         SELECT transaction_id,
                contract,
                cost_bucket_id,
                cost_source_id,
                unit_cost,
                added_to_this_transaction
         BULK COLLECT INTO oh_transaction_arr_
         FROM   inventory_transaction_cost_tab itc
         WHERE  company = company_
         AND    accounting_year = accounting_year_
         AND    cost_bucket_public_type = cost_bucket_public_type_
         AND    cost_bucket_id IN (SELECT cb.cost_bucket_id
                                   FROM cost_bucket_pub cb 
                                   WHERE cb.posting_group_id = posting_group_id_
                                   AND cb.company = itc.company)
         ORDER BY transaction_id;
      $ELSE
         NULL;
      $END
   ELSE
      SELECT transaction_id,
             contract,
             cost_bucket_id,
             cost_source_id,
             unit_cost,
             added_to_this_transaction
      BULK COLLECT INTO oh_transaction_arr_
      FROM   inventory_transaction_cost_tab
      WHERE  company = company_
      AND    cost_source_id = cost_source_id_
      AND    accounting_year = accounting_year_
      AND    cost_bucket_public_type = cost_bucket_public_type_
      ORDER BY transaction_id;
   END IF;

   i_ := oh_transaction_arr_.FIRST;
   
   WHILE (i_ IS NOT NULL) LOOP
      adjusted_cost_ := oh_transaction_arr_(i_).unit_cost * (1 + adjustment_percentage_);

      inv_trans_rec_ := Inventory_Transaction_Hist_API.Get(oh_transaction_arr_(i_).transaction_id);

      IF (inv_trans_rec_.source_ref_type = 'PUR ORDER') THEN
         purch_order_ref1_ := inv_trans_rec_.source_ref1;
         purch_order_ref2_ := inv_trans_rec_.source_ref2;
         purch_order_ref3_ := inv_trans_rec_.source_ref3;
         purch_order_ref4_ := inv_trans_rec_.source_ref4;
      ELSIF (inv_trans_rec_.alt_source_ref_type IN ('PUR ORDER','CUSTOMER ORDER DIRECT')) THEN
         purch_order_ref1_ := inv_trans_rec_.alt_source_ref1;
         purch_order_ref2_ := inv_trans_rec_.alt_source_ref2;
         purch_order_ref3_ := inv_trans_rec_.alt_source_ref3;
         purch_order_ref4_ := inv_trans_rec_.alt_source_ref4;
      END IF;

      -- Modify the unit cost on the OH detail
      Inventory_Transaction_Cost_API.Modify_Unit_Cost(oh_transaction_arr_(i_).transaction_id,
                                                      oh_transaction_arr_(i_).contract,
                                                      oh_transaction_arr_(i_).cost_bucket_id,
                                                      company_,
                                                      oh_transaction_arr_(i_).cost_source_id,              
                                                      accounting_year_,             
                                                      oh_transaction_arr_(i_).added_to_this_transaction,
                                                      adjusted_cost_,
                                                      inv_trans_rec_.transaction_code,
                                                      inv_trans_rec_.part_no,
                                                      inv_trans_rec_.configuration_id,
                                                      inv_trans_rec_.quantity,
                                                      inv_trans_rec_.inventory_valuation_method,
                                                      inv_trans_rec_.inventory_part_cost_level,
                                                      purch_order_ref1_,
                                                      purch_order_ref2_,
                                                      purch_order_ref3_,
                                                      purch_order_ref4_);

      IF (inv_trans_rec_.original_transaction_id IS NULL) THEN
         -- Normal transaction (not reversal)
         -- Trigger creation of additional postings
         
         -- Make sure the adjustment postings are not dated before the original transaction
         IF (inv_trans_rec_.date_applied > adjustment_date_) THEN
            date_applied_ := TRUNC(Site_API.Get_Site_Date(inv_trans_rec_.contract));
         ELSE
            date_applied_ := adjustment_date_;
         END IF;

         Inventory_Transaction_Hist_API.Do_Booking(oh_transaction_arr_(i_).transaction_id,
                                                   company_,
                                                   inv_trans_rec_.transaction_code,
                                                   'N',
                                                   empty_value_detail_tab_,
                                                   value_adjustment_        => TRUE,
                                                   adjustment_date_         => date_applied_,
                                                   per_oh_adjustment_id_    => adjustment_id_,
                                                   do_post_booking_actions_ => TRUE);

      ELSE
         -- This is a reversal transaction. The original_transaction_id is pointing to the
         -- transaction that this transaction is reversing.
         -- Reverse the old accounting.
         Inventory_Transaction_Hist_API.Reverse_Accounting(oh_transaction_arr_(i_).transaction_id,
                                                           inv_trans_rec_.original_transaction_id,
                                                           value_adjustment_     => TRUE,
                                                           per_oh_adjustment_id_ => adjustment_id_);         
      END IF;
      
      -- There could be a need to create 'TRANSIBAL' postings to balance the
      -- inventory and transit accounts
      IF ((use_trans_bal_posting_db_ = 'TRUE') AND
          (inv_trans_rec_.inventory_valuation_method IN ('AV', 'FIFO', 'LIFO'))) THEN

         Balance_Transit_And_Invent___(oh_transaction_arr_(i_).transaction_id,
                                       inv_trans_rec_,
                                       adjustment_id_);
      END IF;

      i_ := oh_transaction_arr_.NEXT(i_);
   END LOOP;
END Adjust_Trans_Overheads___;


-- Adjust_Fifo_Lifo_Overheads___
--   Adjust overheads for records in the fifo/lifo pile for a company having
--   overheads with the specified accounting_year, cost_bucket_public_type
--   and cost_source_id
PROCEDURE Adjust_Fifo_Lifo_Overheads___ (
   company_                 IN VARCHAR2,
   accounting_year_         IN VARCHAR2,
   cost_bucket_public_type_ IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   posting_group_id_        IN VARCHAR2,
   adjustment_percentage_   IN NUMBER )
IS
   TYPE t_row IS RECORD (
     contract         inventory_part_fifo_detail_tab.contract%TYPE,
     part_no          inventory_part_fifo_detail_tab.part_no%TYPE,
     sequence_no      inventory_part_fifo_detail_tab.sequence_no%TYPE,
     cost_bucket_id   inventory_part_fifo_detail_tab.cost_bucket_id%TYPE,
     cost_source_id   inventory_part_fifo_detail_tab.cost_source_id%TYPE,
     unit_cost        inventory_part_fifo_detail_tab.unit_cost%TYPE );
     
   TYPE part_fifo_dtl_tab IS TABLE OF t_row INDEX BY PLS_INTEGER;
   part_fifo_dtl_arr_   part_fifo_dtl_tab;
   i_                   PLS_INTEGER;
   adjusted_cost_       NUMBER;
BEGIN

   IF posting_group_id_ IS NOT NULL THEN
      $IF Component_Cost_SYS.INSTALLED $THEN
         SELECT contract,
                part_no,
                sequence_no,
                cost_bucket_id,
                cost_source_id_,
                unit_cost
         BULK COLLECT INTO part_fifo_dtl_arr_
         FROM   inventory_part_fifo_detail_tab
         WHERE  company = company_
         AND    accounting_year = accounting_year_
         AND    cost_bucket_public_type = cost_bucket_public_type_
         AND    cost_bucket_id IN (SELECT cb.cost_bucket_id
                                   FROM cost_bucket_pub cb 
                                   WHERE cb.posting_group_id = posting_group_id_
                                   AND cb.company = inventory_part_fifo_detail_tab.company);
      $ELSE
         NULL;
      $END
   ELSE
      SELECT contract,
             part_no,
             sequence_no,
             cost_bucket_id,
             cost_source_id_,
             unit_cost
      BULK COLLECT INTO part_fifo_dtl_arr_
      FROM   inventory_part_fifo_detail_tab
      WHERE  company = company_
      AND    cost_source_id = cost_source_id_
      AND    accounting_year = accounting_year_
      AND    cost_bucket_public_type = cost_bucket_public_type_;
   END IF;
   
   i_ := part_fifo_dtl_arr_.FIRST;
   
   WHILE (i_ IS NOT NULL) LOOP
      adjusted_cost_ := part_fifo_dtl_arr_(i_).unit_cost * (1 + adjustment_percentage_);

      -- Modify the unit cost on the OH detail
      Inventory_Part_Fifo_Detail_API.Modify_Unit_Cost(part_fifo_dtl_arr_(i_).contract,
                                                      part_fifo_dtl_arr_(i_).part_no,
                                                      part_fifo_dtl_arr_(i_).sequence_no,
                                                      accounting_year_,
                                                      part_fifo_dtl_arr_(i_).cost_bucket_id,
                                                      company_,
                                                      part_fifo_dtl_arr_(i_).cost_source_id,              
                                                      adjusted_cost_);
      i_ := part_fifo_dtl_arr_.NEXT(i_);
   END LOOP;
END Adjust_Fifo_Lifo_Overheads___;


-- Adjust_Unit_Cost_Overheads___
--   Adjust overheads in Inventory_Part_Unit_Cost for company having overheads
--   with the specified accounting_year, cost_bucket_public_type
--   and cost_source_id
PROCEDURE Adjust_Unit_Cost_Overheads___ (
   company_                 IN VARCHAR2,
   accounting_year_         IN VARCHAR2,
   cost_bucket_public_type_ IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   posting_group_id_        IN VARCHAR2,
   adjustment_percentage_   IN NUMBER )
IS
   
   TYPE t_row IS RECORD (
     part_no          inventory_part_unit_cost_tab.part_no%TYPE,
     contract         inventory_part_unit_cost_tab.contract%TYPE,
     configuration_id inventory_part_unit_cost_tab.configuration_id%TYPE,
     cost_source_id   inventory_part_unit_cost_tab.cost_source_id%TYPE,
     lot_batch_no     inventory_part_unit_cost_tab.lot_batch_no%TYPE,
     serial_no        inventory_part_unit_cost_tab.serial_no%TYPE,
     cost_bucket_id   inventory_part_unit_cost_tab.cost_bucket_id%TYPE,
     inventory_value  inventory_part_unit_cost_tab.inventory_value%TYPE );
     
   TYPE unit_cost_tab IS TABLE OF t_row INDEX BY PLS_INTEGER;
   unit_cost_arr_     unit_cost_tab;
   i_                 PLS_INTEGER;
   adjusted_cost_     NUMBER;
BEGIN

   IF posting_group_id_ IS NOT NULL THEN
      $IF Component_Cost_SYS.INSTALLED $THEN
         SELECT contract,
                part_no,
                configuration_id,
                cost_source_id_,
                lot_batch_no,
                serial_no,
                cost_bucket_id,
                inventory_value
         BULK COLLECT INTO unit_cost_arr_
         FROM   inventory_part_unit_cost_tab
         WHERE  company = company_
         AND    accounting_year = accounting_year_
         AND    cost_bucket_public_type = cost_bucket_public_type_
         AND    cost_bucket_id IN (SELECT cb.cost_bucket_id
                                   FROM cost_bucket_pub cb 
                                   WHERE cb.posting_group_id = posting_group_id_
                                   AND cb.company = inventory_part_unit_cost_tab.company);
      $ELSE
         NULL;
      $END
   ELSE
      SELECT contract,
             part_no,
             configuration_id,
             cost_source_id_,
             lot_batch_no,
             serial_no,
             cost_bucket_id,
             inventory_value
      BULK COLLECT INTO unit_cost_arr_
      FROM   inventory_part_unit_cost_tab
      WHERE  company = company_
      AND    cost_source_id = cost_source_id_
      AND    accounting_year = accounting_year_
      AND    cost_bucket_public_type = cost_bucket_public_type_;
   END IF;
   
   i_ := unit_cost_arr_.FIRST;
   
   WHILE (i_ IS NOT NULL) LOOP
      adjusted_cost_ := unit_cost_arr_(i_).inventory_value * (1 + adjustment_percentage_);
      
      -- Modify inventory value on the OH detail
      Inventory_Part_Unit_Cost_API.Modify_Cost_Detail__(unit_cost_arr_(i_).contract,
                                                        unit_cost_arr_(i_).part_no,
                                                        unit_cost_arr_(i_).configuration_id,
                                                        unit_cost_arr_(i_).lot_batch_no,
                                                        unit_cost_arr_(i_).serial_no,
                                                        accounting_year_,
                                                        unit_cost_arr_(i_).cost_bucket_id,
                                                        company_,
                                                        unit_cost_arr_(i_).cost_source_id,              
                                                        adjusted_cost_);
      
      i_ := unit_cost_arr_.NEXT(i_);
   END LOOP;
END Adjust_Unit_Cost_Overheads___;


-- Adjust_Pre_Trans_Cost_Oh___
--   Adjust overheads in Pre_Invent_Trans_Avg_Cost for company having overheads
--   with the specified accounting_year, cost_bucket_public_type
--   and cost_source_id
PROCEDURE Adjust_Pre_Trans_Cost_Oh___ (
   company_                 IN VARCHAR2,
   accounting_year_         IN VARCHAR2,
   cost_bucket_public_type_ IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   posting_group_id_        IN VARCHAR2,
   adjustment_percentage_   IN NUMBER )
IS
   
   TYPE t_row IS RECORD (
     transaction_id   pre_invent_trans_avg_cost_tab.transaction_id%TYPE,
     contract         pre_invent_trans_avg_cost_tab.contract%TYPE,
     cost_source_id   pre_invent_trans_avg_cost_tab.cost_source_id%TYPE,
     cost_bucket_id   pre_invent_trans_avg_cost_tab.cost_bucket_id%TYPE,
     unit_cost        pre_invent_trans_avg_cost_tab.unit_cost%TYPE );
     
   TYPE inv_trans_avg_cost_tab IS TABLE OF t_row INDEX BY PLS_INTEGER;
   inv_trans_avg_cost_arr_     inv_trans_avg_cost_tab;
   i_                          PLS_INTEGER;
   adjusted_cost_              NUMBER;
BEGIN

   IF posting_group_id_ IS NOT NULL THEN
      $IF Component_Cost_SYS.INSTALLED $THEN
         SELECT transaction_id,
                contract,
                cost_source_id,
                cost_bucket_id,
                unit_cost
         BULK COLLECT INTO inv_trans_avg_cost_arr_
         FROM   pre_invent_trans_avg_cost_tab
         WHERE  company = company_
         AND    accounting_year = accounting_year_
         AND    cost_bucket_public_type = cost_bucket_public_type_
         AND    cost_bucket_id IN (SELECT cb.cost_bucket_id
                                   FROM cost_bucket_pub cb 
                                   WHERE cb.posting_group_id = posting_group_id_
                                   AND pre_invent_trans_avg_cost_tab.company = cb.company);
      $ELSE
         NULL;
      $END
   ELSE
      SELECT transaction_id,
             contract,
             cost_source_id,
             cost_bucket_id,
             unit_cost
      BULK COLLECT INTO inv_trans_avg_cost_arr_
      FROM   pre_invent_trans_avg_cost_tab
      WHERE  company = company_
      AND    cost_source_id = cost_source_id_
      AND    accounting_year = accounting_year_
      AND    cost_bucket_public_type = cost_bucket_public_type_;
   END IF;
   
   i_ := inv_trans_avg_cost_arr_.FIRST;
   
   WHILE (i_ IS NOT NULL) LOOP
      adjusted_cost_ := inv_trans_avg_cost_arr_(i_).unit_cost * (1 + adjustment_percentage_);

      -- Modify the unit cost on the OH detail
      Pre_Invent_Trans_Avg_Cost_API.Modify_Unit_Cost(inv_trans_avg_cost_arr_(i_).transaction_id,
                                                     inv_trans_avg_cost_arr_(i_).contract,
                                                     inv_trans_avg_cost_arr_(i_).cost_bucket_id,
                                                     company_,
                                                     inv_trans_avg_cost_arr_(i_).cost_source_id,
                                                     accounting_year_,
                                                     adjusted_cost_);
      i_ := inv_trans_avg_cost_arr_.NEXT(i_);
   END LOOP;
END Adjust_Pre_Trans_Cost_Oh___;


-- Balance_Transit_And_Invent___
--   Balance the inventory and transit account if needed after processing a
--   transaction that might have caused changes in the inventory value.
PROCEDURE Balance_Transit_And_Invent___ (
   transaction_id_ IN NUMBER,
   inv_trans_rec_  IN Inventory_Transaction_Hist_API.Public_Rec,
   adjustment_id_  IN NUMBER )
IS
   prior_avg_cost_detail_tab_      Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_avg_cost_detail_tab_        Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   new_trans_cost_detail_tab_      Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   pre_trans_avg_qty_              NUMBER;
   transaction_qty_                NUMBER;
   trans_code_rec_                 Mpccom_Transaction_Code_API.Public_Rec;
   pre_trans_level_qty_stock_      NUMBER;
   pre_trans_level_qty_transit_    NUMBER;

BEGIN

   prior_avg_cost_detail_tab_ := Pre_Invent_Trans_Avg_Cost_API.Get_Cost_Details(transaction_id_);

   IF (prior_avg_cost_detail_tab_.COUNT > 0) THEN

      new_trans_cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(transaction_id_);
        pre_trans_level_qty_stock_      := Inventory_Transaction_Hist_API.Get_Pre_Trans_Lvl_Qty_Stock(inv_trans_rec_.transaction_id);
        pre_trans_level_qty_transit_    := Inventory_Transaction_Hist_API.Get_Pre_Trans_Lvl_Qty_Transit(inv_trans_rec_.transaction_id);
        pre_trans_avg_qty_              := pre_trans_level_qty_stock_ + pre_trans_level_qty_transit_;
      
      trans_code_rec_ := Mpccom_Transaction_Code_API.Get(inv_trans_rec_.transaction_code);

      IF (((inv_trans_rec_.direction = '-') AND 
           (trans_code_rec_.transit_qty_direction = 'UNAFFECTED QUANTITY')) OR
          ((inv_trans_rec_.direction = '0') AND 
           (trans_code_rec_.transit_qty_direction = 'DECREASE QUANTITY'))) THEN
         transaction_qty_ := inv_trans_rec_.quantity * -1;
      ELSE
         transaction_qty_ := inv_trans_rec_.quantity;
      END IF;
      
      IF ((pre_trans_avg_qty_ + transaction_qty_) != 0) THEN

         -- Calculate the new average cost after this transaction
         new_avg_cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Weighted_Avg_Cost_Details(
                                                                      prior_avg_cost_detail_tab_,
                                                                      new_trans_cost_detail_tab_,
                                                                      pre_trans_avg_qty_,
                                                                      transaction_qty_);

         Inventory_Transaction_Hist_API.Balance_Transit_And_Invent_Acc(transaction_id_,
                                                                       prior_avg_cost_detail_tab_,
                                                                       new_avg_cost_detail_tab_,
                                                                       value_adjustment_     => TRUE,
                                                                       per_oh_adjustment_id_ => adjustment_id_);
      END IF;
   END IF;
END Balance_Transit_And_Invent___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Create_Per_Oh_Adjustments
--   Triggers the creation of adjustments.
PROCEDURE Create_Per_Oh_Adjustments (
   company_                 IN VARCHAR2,
   adjustment_id_           IN NUMBER,
   accounting_year_         IN NUMBER,
   cost_bucket_public_type_ IN VARCHAR2,
   cost_source_id_          IN VARCHAR2,
   posting_group_id_        IN VARCHAR2,
   adjustment_percentage_   IN NUMBER,
   adjustment_date_         IN DATE )
IS
   accounting_year_str_ VARCHAR2(4);
BEGIN
 
   -- Accounting year on cost details is stored as a string value => conversion needed
   accounting_year_str_ := TO_CHAR(accounting_year_);
   
   -- Adjust overheads in InventoryPartUnitCost
   Adjust_Unit_Cost_Overheads___(company_, accounting_year_str_,         
                                 cost_bucket_public_type_, cost_source_id_, posting_group_id_,
                                 adjustment_percentage_);

   -- Adjust overheads for fifo/lifo piles
   Adjust_Fifo_Lifo_Overheads___(company_, accounting_year_str_,         
                                 cost_bucket_public_type_, cost_source_id_, posting_group_id_,
                                 adjustment_percentage_);

   -- Adjust overheads for PreInventTransAvgCost
   Adjust_Pre_Trans_Cost_Oh___(company_, accounting_year_str_,         
                               cost_bucket_public_type_, cost_source_id_, posting_group_id_,
                               adjustment_percentage_);

   -- Adjust overheads for inventory transactions
   Adjust_Trans_Overheads___(company_, adjustment_id_, accounting_year_str_,         
                             cost_bucket_public_type_, cost_source_id_, posting_group_id_,
                             adjustment_percentage_, adjustment_date_);

END Create_Per_Oh_Adjustments;



