-----------------------------------------------------------------------------
--
--  Logical unit: InventConditionCodeUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200824  RoJalk  SC2020R1-9252, Modified get_quantity_in_order_transit cursor in Make_Pre_Serial_Change_Action, Make_Pre_Lot_Change_Action to 
--  200824          select activity_seq from inventory_part_in_transit_pub and include only COMPANY OWNED stock.
--  150512  IsSalk  KES-422, Passed new parameter source_ref5_ to Inventory_Transaction_Hist_API.Create_And_Account().
--  150428  LEPESE  LIM-92, added handling_unit_id where needed.
--  140616  UdGnlk  PRSC-1062, Modified Make_Pre_Serial_Change_Action() and Make_Pre_Lot_Change_Action() transaction from CONDCHG to CONDCHGCU.
--  130411  Asawlk  EBALL-37, Modified Make_Pre_Serial_Change_Action() and Make_Pre_Lot_Change_Action() to consider the quantity at customer and create
--  130411          relevant transactions upon changing the conditon code. 
--  100511  KRPELK  Merge Rose Method Documentation.
--  100420  MaRalk  Modified reference by name method calls to Inventory_Transaction_Hist_API.Create_And_Account within
--  100420          Make_Pre_Serial_Change_Action and Make_Pre_Lot_Change_Action methods.
--  100409  MaRalk  Modified where condition of cursor get_company_owned_inventory in Make_Pre_Serial_Change_Action and Make_Pre_Lot_Change_Action methods.
--  100406  MaRalk  Modified reference by name method calls to Inventory_Transaction_Hist_API.New within Make_Post_Serial_Change_Action,
--  100406          Make_Post_Lot_Change_Action methods.
--  100331  MaRalk  Modified cursors get_company_owned_inventory and get_vendor_consignment_stock in Make_Pre_Serial_Change_Action
--  100331          and Make_Pre_Lot_Change_Action methods to remove the usage of INVENTORY_PART_STOCK_OWNER_PUB view.
--  ------------------------------------ 14.0.0 -----------------------------------
--  060201  LEPESE  Changes in methods Make_Pre_Serial_Change_Action and Pre_Lot_Change_Action
--  060201          in order to include waiv_dev_rej_no on the inventory transactions. 
--  051218  LEPESE  Added methods Make_Pre_Lot_Change_Action and Make_Post_Lot_Change_Action.
--  051216  LEPESE  Added methods Make_Pre_Serial_Change_Action, Make_Post_Serial_Change_Action,
--  051216          Add_To_Temporary_Table___ and Clear_Temporary_Table___.
--  030814  SuAmlk  Removed method Get_Est_Cost_Per_Condition.
--  030812  SuAmlk  Added method Get_Est_Cost_Per_Condition.
--  020829  AnLaSe  Created.
--  *************************  Take Off Baseline  **************************
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Add_To_Temporary_Table___ (
   transaction_id_ IN NUMBER )
IS
BEGIN

   INSERT INTO inventory_trans_hist_id_tmp
      (transaction_id)
   VALUES
      (transaction_id_);
END Add_To_Temporary_Table___;


PROCEDURE Clear_Temporary_Table___
IS
BEGIN

   DELETE FROM inventory_trans_hist_id_tmp;

END Clear_Temporary_Table___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Make_Pre_Serial_Change_Action
--   This method must only be called from the Update___ method in
--   PartSerialCatalog. It should be called before updating the value
--   of condition code in the database table.
PROCEDURE Make_Pre_Serial_Change_Action (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   transaction_id_        NUMBER;
   dummy_number_          NUMBER;
   empty_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   -- EBALL-37, start
   local_location_group_  VARCHAR2(20);
   -- EBALL-37, end

   CURSOR get_company_owned_inventory (part_no_   IN VARCHAR2,
                                       serial_no_ IN VARCHAR2) IS
      SELECT stock.contract,
             stock.configuration_id,
             stock.lot_batch_no,
             location.location_group,
             stock.activity_seq,
             stock.waiv_dev_rej_no,
             SUM(stock.qty_onhand)          sum_qty_onhand,
             SUM(stock.qty_in_transit)      sum_qty_in_transit
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,             
             rotable_part_pool_tab          pool
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no        
        AND  stock.part_ownership_db = 'COMPANY OWNED'
        AND  stock.rotable_part_pool_id = pool.rotable_part_pool_id (+)
        AND  NVL(pool.rotable_pool_asset_type,'INVENTORY ASSET') = 'INVENTORY ASSET'
        AND  stock.serial_no        = serial_no_
        AND  stock.part_no          = part_no_
      GROUP BY stock.contract,
               stock.configuration_id,
               stock.lot_batch_no,
               location.location_group,
               stock.activity_seq,
               stock.waiv_dev_rej_no;

   CURSOR get_vendor_consignment_stock (part_no_   IN VARCHAR2,
                                        serial_no_ IN VARCHAR2) IS
      SELECT stock.contract,
             stock.configuration_id,
             stock.lot_batch_no,
             location.location_group,
             stock.activity_seq,
             stock.waiv_dev_rej_no,
             SUM(stock.qty_onhand)          sum_qty_onhand
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location             
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no
        AND  stock.part_ownership_db   = 'CONSIGNMENT'
        AND  stock.serial_no        = serial_no_
        AND  stock.part_no          = part_no_
      GROUP BY stock.contract,
               stock.configuration_id,
               stock.lot_batch_no,
               location.location_group,
               stock.activity_seq,
               stock.waiv_dev_rej_no;

   CURSOR get_quantity_in_order_transit (part_no_   IN VARCHAR2,
                                         serial_no_ IN VARCHAR2) IS
      SELECT contract,
             configuration_id,
             lot_batch_no,
             activity_seq,
             waiv_dev_rej_no,
             SUM(quantity)          sum_qty_in_transit
       FROM  inventory_part_in_transit_pub
      WHERE  part_ownership_db = 'COMPANY OWNED'
        AND  serial_no         = serial_no_
        AND  part_no           = part_no_
      GROUP BY contract, configuration_id, lot_batch_no, activity_seq, waiv_dev_rej_no;

   -- EBALL-37, start
   CURSOR get_quantity_at_customer (part_no_      IN VARCHAR2,
                                    serial_no_    IN VARCHAR2) IS
      SELECT process_type,
             contract,
             configuration_id,
             lot_batch_no,
             activity_seq,
             waiv_dev_rej_no,
             SUM(quantity)          sum_qty_at_customer
       FROM  inventory_part_at_customer_tab
      WHERE  serial_no = serial_no_
        AND  part_no   = part_no_
   GROUP BY  process_type, contract, configuration_id, lot_batch_no, activity_seq, waiv_dev_rej_no;    
   -- EBALL-37, end
BEGIN

   Clear_Temporary_Table___;

   FOR company_owned_rec_ IN get_company_owned_inventory (part_no_, serial_no_) LOOP

      IF (company_owned_rec_.sum_qty_onhand != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                          transaction_id_     => transaction_id_,
                                          accounting_id_      => dummy_number_,
                                          value_              => dummy_number_,
                                          transaction_code_   => 'CONDCHG-',
                                          contract_           => company_owned_rec_.contract,
                                          part_no_            => part_no_,
                                          configuration_id_   => company_owned_rec_.configuration_id,
                                          location_no_        => NULL,
                                          lot_batch_no_       => company_owned_rec_.lot_batch_no,
                                          serial_no_          => serial_no_,
                                          waiv_dev_rej_no_    => company_owned_rec_.waiv_dev_rej_no,
                                          eng_chg_level_      => NULL,
                                          activity_seq_       => company_owned_rec_.activity_seq,
                                          project_id_         => NULL,
                                          source_ref1_        => NULL,
                                          source_ref2_        => NULL,
                                          source_ref3_        => NULL,
                                          source_ref4_        => NULL,
                                          source_ref5_        => NULL,
                                          reject_code_        => NULL,
                                          cost_detail_tab_    => empty_cost_detail_tab_,
                                          unit_cost_          => NULL,
                                          quantity_           => company_owned_rec_.sum_qty_onhand,
                                          qty_reversed_       => 0,
                                          catch_quantity_     => NULL,
                                          source_             => NULL,
                                          source_ref_type_    => NULL,
                                          owning_vendor_no_   => NULL,
                                          condition_code_     => NULL,
                                          location_group_     => company_owned_rec_.location_group,
                                          part_ownership_db_  => 'COMPANY OWNED',
                                          owning_customer_no_ => NULL,
                                          expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;

      IF (company_owned_rec_.sum_qty_in_transit != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                        transaction_id_     => transaction_id_,
                                        accounting_id_      => dummy_number_,
                                        value_              => dummy_number_,
                                        transaction_code_   => 'CONDCHGTR-',
                                        contract_           => company_owned_rec_.contract,
                                        part_no_            => part_no_,
                                        configuration_id_   => company_owned_rec_.configuration_id,
                                        location_no_        => NULL,
                                        lot_batch_no_       => company_owned_rec_.lot_batch_no,
                                        serial_no_          => serial_no_,
                                        waiv_dev_rej_no_    => company_owned_rec_.waiv_dev_rej_no,
                                        eng_chg_level_      => NULL,
                                        activity_seq_       => company_owned_rec_.activity_seq,
                                        project_id_         => NULL,
                                        source_ref1_        => NULL,
                                        source_ref2_        => NULL,
                                        source_ref3_        => NULL,
                                        source_ref4_        => NULL,
                                        source_ref5_        => NULL,
                                        reject_code_        => NULL,
                                        cost_detail_tab_    => empty_cost_detail_tab_,
                                        unit_cost_          => NULL,
                                        quantity_           => company_owned_rec_.sum_qty_in_transit,
                                        qty_reversed_       => 0,
                                        catch_quantity_     => NULL,
                                        source_             => NULL,
                                        source_ref_type_    => NULL,
                                        owning_vendor_no_   => NULL,
                                        condition_code_     => NULL,
                                        location_group_     => company_owned_rec_.location_group,
                                        part_ownership_db_  => 'COMPANY OWNED',
                                        owning_customer_no_ => NULL,
                                        expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;

   FOR vendor_consignment_rec_ IN get_vendor_consignment_stock (part_no_, serial_no_) LOOP

      IF (vendor_consignment_rec_.sum_qty_onhand != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                     transaction_id_     => transaction_id_,
                                     accounting_id_      => dummy_number_,
                                     value_              => dummy_number_,
                                     transaction_code_   => 'CO-CONDCH-',
                                     contract_           => vendor_consignment_rec_.contract,
                                     part_no_            => part_no_,
                                     configuration_id_   => vendor_consignment_rec_.configuration_id,
                                     location_no_        => NULL,
                                     lot_batch_no_       => vendor_consignment_rec_.lot_batch_no,
                                     serial_no_          => serial_no_,
                                     waiv_dev_rej_no_    => vendor_consignment_rec_.waiv_dev_rej_no,
                                     eng_chg_level_      => NULL,
                                     activity_seq_       => vendor_consignment_rec_.activity_seq,
                                     project_id_         => NULL,
                                     source_ref1_        => NULL,
                                     source_ref2_        => NULL,
                                     source_ref3_        => NULL,
                                     source_ref4_        => NULL,
                                     source_ref5_        => NULL,
                                     reject_code_        => NULL,
                                     cost_detail_tab_    => empty_cost_detail_tab_,
                                     unit_cost_          => NULL,
                                     quantity_           => vendor_consignment_rec_.sum_qty_onhand,
                                     qty_reversed_       => 0,
                                     catch_quantity_     => NULL,
                                     source_             => NULL,
                                     source_ref_type_    => NULL,
                                     owning_vendor_no_   => NULL,
                                     condition_code_     => NULL,
                                     location_group_     => vendor_consignment_rec_.location_group,
                                     part_ownership_db_  => 'CONSIGNMENT',
                                     owning_customer_no_ => NULL,
                                     expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;

   FOR order_transit_rec_ IN get_quantity_in_order_transit (part_no_, serial_no_) LOOP

      IF (order_transit_rec_.sum_qty_in_transit != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                     transaction_id_     => transaction_id_,
                                     accounting_id_      => dummy_number_,
                                     value_              => dummy_number_,
                                     transaction_code_   => 'CONDCHGTR-',
                                     contract_           => order_transit_rec_.contract,
                                     part_no_            => part_no_,
                                     configuration_id_   => order_transit_rec_.configuration_id,
                                     location_no_        => NULL,
                                     lot_batch_no_       => order_transit_rec_.lot_batch_no,
                                     serial_no_          => serial_no_,
                                     waiv_dev_rej_no_    => order_transit_rec_.waiv_dev_rej_no,
                                     eng_chg_level_      => NULL,
                                     activity_seq_       => 0,
                                     project_id_         => NULL,
                                     source_ref1_        => NULL,
                                     source_ref2_        => NULL,
                                     source_ref3_        => NULL,
                                     source_ref4_        => NULL,
                                     source_ref5_        => NULL,
                                     reject_code_        => NULL,
                                     cost_detail_tab_    => empty_cost_detail_tab_,
                                     unit_cost_          => NULL,
                                     quantity_           => order_transit_rec_.sum_qty_in_transit,
                                     qty_reversed_       => 0,
                                     catch_quantity_     => NULL,
                                     source_             => NULL,
                                     source_ref_type_    => NULL,
                                     owning_vendor_no_   => NULL,
                                     condition_code_     => NULL,
                                     location_group_     => 'INT ORDER TRANSIT',
                                     part_ownership_db_  => 'COMPANY OWNED',
                                     owning_customer_no_ => NULL,
                                     expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;
   -- EBALL-37, start
   FOR qty_at_customer_rec_ IN get_quantity_at_customer (part_no_, serial_no_) LOOP

      IF (qty_at_customer_rec_.sum_qty_at_customer != 0) THEN

         IF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
            local_location_group_ := 'DELIVERY CONFIRM';
         ELSIF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
            local_location_group_ := 'CONSIGNMENT';
         ELSIF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
            local_location_group_ := 'PART EXCHANGE';
         ELSE
            Stock_At_Cust_Process_Type_API.Exist_Db(qty_at_customer_rec_.process_type);
         END IF;

         Inventory_Transaction_Hist_API.Create_And_Account(
                                          transaction_id_     => transaction_id_,
                                          accounting_id_      => dummy_number_,
                                          value_              => dummy_number_,
                                          transaction_code_   => 'CONDCHGCU-',
                                          contract_           => qty_at_customer_rec_.contract,
                                          part_no_            => part_no_,
                                          configuration_id_   => qty_at_customer_rec_.configuration_id,
                                          location_no_        => NULL,
                                          lot_batch_no_       => qty_at_customer_rec_.lot_batch_no,
                                          serial_no_          => serial_no_,
                                          waiv_dev_rej_no_    => qty_at_customer_rec_.waiv_dev_rej_no,
                                          eng_chg_level_      => NULL,
                                          activity_seq_       => qty_at_customer_rec_.activity_seq,
                                          project_id_         => NULL,
                                          source_ref1_        => NULL,
                                          source_ref2_        => NULL,
                                          source_ref3_        => NULL,
                                          source_ref4_        => NULL,
                                          source_ref5_        => NULL,
                                          reject_code_        => NULL,
                                          cost_detail_tab_    => empty_cost_detail_tab_,
                                          unit_cost_          => NULL,
                                          quantity_           => qty_at_customer_rec_.sum_qty_at_customer,
                                          qty_reversed_       => 0,
                                          catch_quantity_     => NULL,
                                          source_             => NULL,
                                          source_ref_type_    => NULL,
                                          owning_vendor_no_   => NULL,
                                          condition_code_     => NULL,
                                          location_group_     => local_location_group_,
                                          part_ownership_db_  => 'COMPANY OWNED',
                                          owning_customer_no_ => NULL,
                                          expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;
   -- EBALL-37, end
END Make_Pre_Serial_Change_Action;


-- Make_Post_Serial_Change_Action
--   This method must only be called from the Update___ method in
--   PartSerialCatalog. It should be called after updating the value of
--   condition code in the database table.
PROCEDURE Make_Post_Serial_Change_Action (
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   new_condition_code_ IN VARCHAR2 )
IS
   old_trans_rec_         Inventory_Transaction_Hist_API.Public_Rec;
   transaction_code_      VARCHAR2(10);
   transaction_id_        NUMBER;
   dummy_number_          NUMBER;
   empty_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_transaction_id IS
      SELECT transaction_id
      FROM inventory_trans_hist_id_tmp;
BEGIN

   Inventory_Part_Unit_Cost_API.Handle_Serial_Condition_Change(part_no_,
                                                               serial_no_,
                                                               new_condition_code_);

   Inventory_Part_In_Stock_API.Handle_Serial_Condition_Change(part_no_,
                                                              serial_no_,
                                                              new_condition_code_);
   FOR trans_id_rec_ IN get_transaction_id LOOP

      old_trans_rec_ := Inventory_Transaction_Hist_API.Get(trans_id_rec_.transaction_id);

      CASE old_trans_rec_.transaction_code
         WHEN 'CONDCHG-'   THEN transaction_code_ := 'CONDCHG+';
         WHEN 'CONDCHGTR-' THEN transaction_code_ := 'CONDCHGTR+';
         WHEN 'CO-CONDCH-' THEN transaction_code_ := 'CO-CONDCH+';
         WHEN 'CONDCHGCU-' THEN transaction_code_ := 'CONDCHGCU+';      
      END CASE;

      Inventory_Transaction_Hist_API.New(
                                  transaction_id_     => transaction_id_,
                                  accounting_id_      => dummy_number_,
                                  value_              => dummy_number_,
                                  transaction_code_   => transaction_code_,
                                  contract_           => old_trans_rec_.contract,
                                  part_no_            => old_trans_rec_.part_no,
                                  configuration_id_   => old_trans_rec_.configuration_id,
                                  location_no_        => old_trans_rec_.location_no,
                                  lot_batch_no_       => old_trans_rec_.lot_batch_no,
                                  serial_no_          => old_trans_rec_.serial_no,
                                  waiv_dev_rej_no_    => old_trans_rec_.waiv_dev_rej_no,
                                  eng_chg_level_      => old_trans_rec_.eng_chg_level,
                                  activity_seq_       => old_trans_rec_.activity_seq,
                                  handling_unit_id_   => old_trans_rec_.handling_unit_id,
                                  project_id_         => old_trans_rec_.project_id,
                                  source_ref1_        => old_trans_rec_.source_ref1,
                                  source_ref2_        => old_trans_rec_.source_ref2,
                                  source_ref3_        => old_trans_rec_.source_ref3,
                                  source_ref4_        => old_trans_rec_.source_ref4,
                                  source_ref5_        => old_trans_rec_.source_ref5,
                                  reject_code_        => old_trans_rec_.reject_code,
                                  cost_detail_tab_    => empty_cost_detail_tab_,
                                  unit_cost_          => NULL,
                                  quantity_           => old_trans_rec_.quantity,
                                  qty_reversed_       => old_trans_rec_.qty_reversed,
                                  catch_quantity_     => old_trans_rec_.catch_quantity,
                                  source_             => old_trans_rec_.source,
                                  source_ref_type_    => old_trans_rec_.source_ref_type,
                                  owning_vendor_no_   => old_trans_rec_.owning_vendor_no,
                                  condition_code_     => NULL,
                                  location_group_     => old_trans_rec_.location_group,
                                  part_ownership_db_  => old_trans_rec_.part_ownership,
                                  owning_customer_no_ => old_trans_rec_.owning_customer_no,
                                  expiration_date_    => NULL);

      Invent_Trans_Interconnect_API.Connect_Transactions(trans_id_rec_.transaction_id,
                                                         transaction_id_,
                                                         'CONDITION CODE CHANGE');

      Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_);

   END LOOP;

   Clear_Temporary_Table___;

END Make_Post_Serial_Change_Action;


-- Make_Pre_Lot_Change_Action
--   This method must only be called from the Update___ method in
--   LotBatchMaster. It should be called before updating the value of
--   condition code in the database table.
PROCEDURE Make_Pre_Lot_Change_Action (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 )
IS
   transaction_id_        NUMBER;
   dummy_number_          NUMBER;
   empty_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   -- EBALL-37, start
   local_location_group_  VARCHAR2(20);
   -- EBALL-37, end
   CURSOR get_company_owned_inventory (part_no_      IN VARCHAR2,
                                       lot_batch_no_ IN VARCHAR2) IS
      SELECT stock.contract,
             stock.configuration_id,
             stock.serial_no,
             location.location_group,
             stock.activity_seq,
             stock.waiv_dev_rej_no,
             SUM(stock.qty_onhand)          sum_qty_onhand,
             SUM(stock.qty_in_transit)      sum_qty_in_transit
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,
             rotable_part_pool_tab          pool
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no        
        AND stock.part_ownership_db = 'COMPANY OWNED'
        AND  stock.rotable_part_pool_id = pool.rotable_part_pool_id (+)
        AND  NVL(pool.rotable_pool_asset_type,'INVENTORY ASSET') = 'INVENTORY ASSET'
        AND  stock.lot_batch_no     = lot_batch_no_
        AND  stock.part_no          = part_no_
      GROUP BY stock.contract,
               stock.configuration_id,
               stock.serial_no,
               location.location_group,
               stock.activity_seq,
               stock.waiv_dev_rej_no;

   CURSOR get_vendor_consignment_stock (part_no_      IN VARCHAR2,
                                        lot_batch_no_ IN VARCHAR2) IS
      SELECT stock.contract,
             stock.configuration_id,
             stock.serial_no,
             location.location_group,
             stock.activity_seq,
             stock.waiv_dev_rej_no,
             SUM(stock.qty_onhand)          sum_qty_onhand
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location             
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no        
        AND  stock.part_ownership_db = 'CONSIGNMENT'
        AND  stock.lot_batch_no     = lot_batch_no_
        AND  stock.part_no          = part_no_
      GROUP BY stock.contract,
               stock.configuration_id,
               stock.serial_no,
               location.location_group,
               stock.activity_seq,
               stock.waiv_dev_rej_no;

   CURSOR get_quantity_in_order_transit (part_no_      IN VARCHAR2,
                                         lot_batch_no_ IN VARCHAR2) IS
      SELECT contract,
             configuration_id,
             serial_no,
             activity_seq,
             waiv_dev_rej_no,
             SUM(quantity)          sum_qty_in_transit
       FROM  inventory_part_in_transit_pub
      WHERE  part_ownership_db = 'COMPANY OWNED'
        AND  lot_batch_no = lot_batch_no_
        AND  part_no      = part_no_
      GROUP BY contract, configuration_id, serial_no, activity_seq, waiv_dev_rej_no;

   -- EBALL-37, start
   CURSOR get_quantity_at_customer (part_no_      IN VARCHAR2,
                                    lot_batch_no_ IN VARCHAR2) IS
      SELECT process_type,
             contract,
             configuration_id,
             serial_no,
             activity_seq,
             waiv_dev_rej_no,
             SUM(quantity)          sum_qty_at_customer
       FROM  inventory_part_at_customer_tab
      WHERE  lot_batch_no = lot_batch_no_
        AND  part_no      = part_no_
   GROUP BY  process_type, contract, configuration_id, serial_no, activity_seq, waiv_dev_rej_no;    
   -- EBALL-37, end
BEGIN

   Clear_Temporary_Table___;

   FOR company_owned_rec_ IN get_company_owned_inventory (part_no_, lot_batch_no_) LOOP

      IF (company_owned_rec_.sum_qty_onhand != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                          transaction_id_     => transaction_id_,
                                          accounting_id_      => dummy_number_,
                                          value_              => dummy_number_,
                                          transaction_code_   => 'CONDCHG-',
                                          contract_           => company_owned_rec_.contract,
                                          part_no_            => part_no_,
                                          configuration_id_   => company_owned_rec_.configuration_id,
                                          location_no_        => NULL,
                                          lot_batch_no_       => lot_batch_no_,
                                          serial_no_          => company_owned_rec_.serial_no,
                                          waiv_dev_rej_no_    => company_owned_rec_.waiv_dev_rej_no,
                                          eng_chg_level_      => NULL,
                                          activity_seq_       => company_owned_rec_.activity_seq,
                                          project_id_         => NULL,
                                          source_ref1_        => NULL,
                                          source_ref2_        => NULL,
                                          source_ref3_        => NULL,
                                          source_ref4_        => NULL,
                                          source_ref5_        => NULL,
                                          reject_code_        => NULL,
                                          cost_detail_tab_    => empty_cost_detail_tab_,
                                          unit_cost_          => NULL,
                                          quantity_           => company_owned_rec_.sum_qty_onhand,
                                          qty_reversed_       => 0,
                                          catch_quantity_     => NULL,
                                          source_             => NULL,
                                          source_ref_type_    => NULL,
                                          owning_vendor_no_   => NULL,
                                          condition_code_     => NULL,
                                          location_group_     => company_owned_rec_.location_group,
                                          part_ownership_db_  => 'COMPANY OWNED',
                                          owning_customer_no_ => NULL,
                                          expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;

      IF (company_owned_rec_.sum_qty_in_transit != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                        transaction_id_     => transaction_id_,
                                        accounting_id_      => dummy_number_,
                                        value_              => dummy_number_,
                                        transaction_code_   => 'CONDCHGTR-',
                                        contract_           => company_owned_rec_.contract,
                                        part_no_            => part_no_,
                                        configuration_id_   => company_owned_rec_.configuration_id,
                                        location_no_        => NULL,
                                        lot_batch_no_       => lot_batch_no_,
                                        serial_no_          => company_owned_rec_.serial_no,
                                        waiv_dev_rej_no_    => company_owned_rec_.waiv_dev_rej_no,
                                        eng_chg_level_      => NULL,
                                        activity_seq_       => company_owned_rec_.activity_seq,
                                        project_id_         => NULL,
                                        source_ref1_        => NULL,
                                        source_ref2_        => NULL,
                                        source_ref3_        => NULL,
                                        source_ref4_        => NULL,
                                        source_ref5_        => NULL,
                                        reject_code_        => NULL,
                                        cost_detail_tab_    => empty_cost_detail_tab_,
                                        unit_cost_          => NULL,
                                        quantity_           => company_owned_rec_.sum_qty_in_transit,
                                        qty_reversed_       => 0,
                                        catch_quantity_     => NULL,
                                        source_             => NULL,
                                        source_ref_type_    => NULL,
                                        owning_vendor_no_   => NULL,
                                        condition_code_     => NULL,
                                        location_group_     => company_owned_rec_.location_group,
                                        part_ownership_db_  => 'COMPANY OWNED',
                                        owning_customer_no_ => NULL,
                                        expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;

   FOR vendor_consignment_rec_ IN get_vendor_consignment_stock (part_no_, lot_batch_no_) LOOP

      IF (vendor_consignment_rec_.sum_qty_onhand != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                     transaction_id_     => transaction_id_,
                                     accounting_id_      => dummy_number_,
                                     value_              => dummy_number_,
                                     transaction_code_   => 'CO-CONDCH-',
                                     contract_           => vendor_consignment_rec_.contract,
                                     part_no_            => part_no_,
                                     configuration_id_   => vendor_consignment_rec_.configuration_id,
                                     location_no_        => NULL,
                                     lot_batch_no_       => lot_batch_no_,
                                     serial_no_          => vendor_consignment_rec_.serial_no,
                                     waiv_dev_rej_no_    => vendor_consignment_rec_.waiv_dev_rej_no,
                                     eng_chg_level_      => NULL,
                                     activity_seq_       => vendor_consignment_rec_.activity_seq,
                                     project_id_         => NULL,
                                     source_ref1_        => NULL,
                                     source_ref2_        => NULL,
                                     source_ref3_        => NULL,
                                     source_ref4_        => NULL,
                                     source_ref5_        => NULL,
                                     reject_code_        => NULL,
                                     cost_detail_tab_    => empty_cost_detail_tab_,
                                     unit_cost_          => NULL,
                                     quantity_           => vendor_consignment_rec_.sum_qty_onhand,
                                     qty_reversed_       => 0,
                                     catch_quantity_     => NULL,
                                     source_             => NULL,
                                     source_ref_type_    => NULL,
                                     owning_vendor_no_   => NULL,
                                     condition_code_     => NULL,
                                     location_group_     => vendor_consignment_rec_.location_group,
                                     part_ownership_db_  => 'CONSIGNMENT',
                                     owning_customer_no_ => NULL,
                                     expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;

   FOR order_transit_rec_ IN get_quantity_in_order_transit (part_no_, lot_batch_no_) LOOP

      IF (order_transit_rec_.sum_qty_in_transit != 0) THEN

         Inventory_Transaction_Hist_API.Create_And_Account(
                                     transaction_id_     => transaction_id_,
                                     accounting_id_      => dummy_number_,
                                     value_              => dummy_number_,
                                     transaction_code_   => 'CONDCHGTR-',
                                     contract_           => order_transit_rec_.contract,
                                     part_no_            => part_no_,
                                     configuration_id_   => order_transit_rec_.configuration_id,
                                     location_no_        => NULL,
                                     lot_batch_no_       => lot_batch_no_,
                                     serial_no_          => order_transit_rec_.serial_no,
                                     waiv_dev_rej_no_    => order_transit_rec_.waiv_dev_rej_no,
                                     eng_chg_level_      => NULL,
                                     activity_seq_       => 0,
                                     project_id_         => NULL,
                                     source_ref1_        => NULL,
                                     source_ref2_        => NULL,
                                     source_ref3_        => NULL,
                                     source_ref4_        => NULL,
                                     source_ref5_        => NULL,
                                     reject_code_        => NULL,
                                     cost_detail_tab_    => empty_cost_detail_tab_,
                                     unit_cost_          => NULL,
                                     quantity_           => order_transit_rec_.sum_qty_in_transit,
                                     qty_reversed_       => 0,
                                     catch_quantity_     => NULL,
                                     source_             => NULL,
                                     source_ref_type_    => NULL,
                                     owning_vendor_no_   => NULL,
                                     condition_code_     => NULL,
                                     location_group_     => 'INT ORDER TRANSIT',
                                     part_ownership_db_  => 'COMPANY OWNED',
                                     owning_customer_no_ => NULL,
                                     expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;
   -- EBALL-37, start
   FOR qty_at_customer_rec_ IN get_quantity_at_customer (part_no_, lot_batch_no_) LOOP

      IF (qty_at_customer_rec_.sum_qty_at_customer != 0) THEN
         IF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
            local_location_group_ := 'DELIVERY CONFIRM';
         ELSIF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
            local_location_group_ := 'CONSIGNMENT';
         ELSIF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
            local_location_group_ := 'PART EXCHANGE';
         ELSE
            Stock_At_Cust_Process_Type_API.Exist_Db(qty_at_customer_rec_.process_type);
         END IF;

         Inventory_Transaction_Hist_API.Create_And_Account(
                                          transaction_id_     => transaction_id_,
                                          accounting_id_      => dummy_number_,
                                          value_              => dummy_number_,
                                          transaction_code_   => 'CONDCHGCU-',
                                          contract_           => qty_at_customer_rec_.contract,
                                          part_no_            => part_no_,
                                          configuration_id_   => qty_at_customer_rec_.configuration_id,
                                          location_no_        => NULL,
                                          lot_batch_no_       => lot_batch_no_,
                                          serial_no_          => qty_at_customer_rec_.serial_no,
                                          waiv_dev_rej_no_    => qty_at_customer_rec_.waiv_dev_rej_no,
                                          eng_chg_level_      => NULL,
                                          activity_seq_       => qty_at_customer_rec_.activity_seq,
                                          project_id_         => NULL,
                                          source_ref1_        => NULL,
                                          source_ref2_        => NULL,
                                          source_ref3_        => NULL,
                                          source_ref4_        => NULL,
                                          source_ref5_        => NULL,
                                          reject_code_        => NULL,
                                          cost_detail_tab_    => empty_cost_detail_tab_,
                                          unit_cost_          => NULL,
                                          quantity_           => qty_at_customer_rec_.sum_qty_at_customer,
                                          qty_reversed_       => 0,
                                          catch_quantity_     => NULL,
                                          source_             => NULL,
                                          source_ref_type_    => NULL,
                                          owning_vendor_no_   => NULL,
                                          condition_code_     => NULL,
                                          location_group_     => local_location_group_,
                                          part_ownership_db_  => 'COMPANY OWNED',
                                          owning_customer_no_ => NULL,
                                          expiration_date_    => NULL);

         Add_To_Temporary_Table___(transaction_id_);
      END IF;
   END LOOP;
   -- EBALL-37, end
END Make_Pre_Lot_Change_Action;


-- Make_Post_Lot_Change_Action
--   This method must only be called from the Update___ method in
--   LotBatchMaster. It should be called after updating the value of
--   condition code in the database table.
PROCEDURE Make_Post_Lot_Change_Action (
   part_no_            IN VARCHAR2,
   lot_batch_no_       IN VARCHAR2,
   new_condition_code_ IN VARCHAR2 )
IS
   old_trans_rec_         Inventory_Transaction_Hist_API.Public_Rec;
   transaction_code_      VARCHAR2(10);
   transaction_id_        NUMBER;
   dummy_number_          NUMBER;
   empty_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;

   CURSOR get_transaction_id IS
      SELECT transaction_id
      FROM inventory_trans_hist_id_tmp;
BEGIN

   Inventory_Part_Unit_Cost_API.Handle_Lot_Condition_Change(part_no_,
                                                            lot_batch_no_,
                                                            new_condition_code_);

   Inventory_Part_In_Stock_API.Handle_Lot_Condition_Change(part_no_,
                                                           lot_batch_no_,
                                                           new_condition_code_);
   FOR trans_id_rec_ IN get_transaction_id LOOP

      old_trans_rec_ := Inventory_Transaction_Hist_API.Get(trans_id_rec_.transaction_id);

      CASE old_trans_rec_.transaction_code
         WHEN 'CONDCHG-'   THEN transaction_code_ := 'CONDCHG+';
         WHEN 'CONDCHGTR-' THEN transaction_code_ := 'CONDCHGTR+';
         WHEN 'CO-CONDCH-' THEN transaction_code_ := 'CO-CONDCH+';
         WHEN 'CONDCHGCU-' THEN transaction_code_ := 'CONDCHGCU+';      
      END CASE;

      Inventory_Transaction_Hist_API.New(
                                  transaction_id_     => transaction_id_,
                                  accounting_id_      => dummy_number_,
                                  value_              => dummy_number_,
                                  transaction_code_   => transaction_code_,
                                  contract_           => old_trans_rec_.contract,
                                  part_no_            => old_trans_rec_.part_no,
                                  configuration_id_   => old_trans_rec_.configuration_id,
                                  location_no_        => old_trans_rec_.location_no,
                                  lot_batch_no_       => old_trans_rec_.lot_batch_no,
                                  serial_no_          => old_trans_rec_.serial_no,
                                  waiv_dev_rej_no_    => old_trans_rec_.waiv_dev_rej_no,
                                  eng_chg_level_      => old_trans_rec_.eng_chg_level,
                                  activity_seq_       => old_trans_rec_.activity_seq,
                                  handling_unit_id_   => old_trans_rec_.handling_unit_id,
                                  project_id_         => old_trans_rec_.project_id,
                                  source_ref1_        => old_trans_rec_.source_ref1,
                                  source_ref2_        => old_trans_rec_.source_ref2,
                                  source_ref3_        => old_trans_rec_.source_ref3,
                                  source_ref4_        => old_trans_rec_.source_ref4,
                                  source_ref5_        => old_trans_rec_.source_ref5,
                                  reject_code_        => old_trans_rec_.reject_code,
                                  cost_detail_tab_    => empty_cost_detail_tab_,
                                  unit_cost_          => NULL,
                                  quantity_           => old_trans_rec_.quantity,
                                  qty_reversed_       => old_trans_rec_.qty_reversed,
                                  catch_quantity_     => old_trans_rec_.catch_quantity,
                                  source_             => old_trans_rec_.source,
                                  source_ref_type_    => old_trans_rec_.source_ref_type,
                                  owning_vendor_no_   => old_trans_rec_.owning_vendor_no,
                                  condition_code_     => NULL,
                                  location_group_     => old_trans_rec_.location_group,
                                  part_ownership_db_  => old_trans_rec_.part_ownership,
                                  owning_customer_no_ => old_trans_rec_.owning_customer_no,
                                  expiration_date_    => NULL);

      Invent_Trans_Interconnect_API.Connect_Transactions(trans_id_rec_.transaction_id,
                                                         transaction_id_,
                                                         'CONDITION CODE CHANGE');

      Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_);

   END LOOP;

   Clear_Temporary_Table___;

END Make_Post_Lot_Change_Action;



