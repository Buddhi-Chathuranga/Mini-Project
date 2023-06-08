-----------------------------------------------------------------------------
--
--  Logical unit: InventCostBucketManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200824  RoJalk  SC2020R1-9252, Modified get_quantity_in_order_transit cursor in Make_Pre_Pcg_Change___, Make_Pre_Pcg_Change_Cond___ to 
--  200824          select activity_seq from inventory_part_in_transit_pub and include only COMPANY OWNED stock.
--  150512  IsSalk  KES-422, Passed new parameter source_ref5_ to Inventory_Transaction_Hist_API.Create_And_Account().
--  130801  UdGnlk  TIBE-863, Removed the dynamic code and modify to conditional compilation.
--  130603  Asawlk  EBALL-37, Moved logic behind revaluation of quantity at customer from Make_Pre_Pcg_Change_Part___() to Make_Pre_Pcg_Change___(). 
--  130322  Asawlk  EBALL-37, Modified Make_Pre_Pcg_Change_Part___() to make the call to Inventory_Part_At_Customer_API.Get_Our_Total_Qty_At_Customer()
--  130322          static. Also removed the constant inst_InventoryPartAtCustomer_.
--  100420  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.Create_And_Account 
--  100420          within Create_And_Account___ method.
--  100409  MaRalk  Modified where condition of cursor get_company_owned_inventory in Make_Pre_Pcg_Change___ and
--  100409          Make_Pre_Pcg_Change_Cond___ methods.
--  100406  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.New within
--  100406          Make_Post_Posting_Group_Change method.
--  100104  MaRalk  Modified cursors get_company_owned_inventory and get_vendor_consignment_stock in Make_Pre_Pcg_Change___
--  100104          and Make_Pre_Pcg_Change_Cond___ methods to remove the usage of INVENTORY_PART_STOCK_OWNER_PUB view.
--------------------------------------- 14.0.0 -----------------------------------
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  080123  LEPESE  Bug 68763, Added method Get_Cost_Bucket_Type_Db.
--  080112  MaEelk  Bug 69994, added method Get_Inverted_Trans_Code___. Used this method in 
--  080112          Create_And_Account___ to use alternative transaction code when quantity is negative.
--  080112          Also used Get_Inverted_Trans_Code___ in Make_Post_Posting_Group_Change for similar
--  080112          purpose, using inverted transaction when adding value for new posting cost group.
--  060123  NiDalk  Added Assert safe annotation.
--  060110  LEPESE  Added functionality to make transactions only including such
--  060110          cost details that refer to a cost bucket that is going to get
--  060110          a new posting cost group. New methods Get_Only_Modified_Buckets___
--  060110          and Cost_Bucket_Is_Modified___ will secure this.
--  051220  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Inverted_Trans_Code___
--   This method is used to get the inverted vales of transaction codes
--   PCGCHG+, PCGCHG-, PCGCHGTR+, PCGCHGTR-, CO-PCGCHG+ and CO-PCGCHG-
FUNCTION Get_Inverted_Trans_Code___ (
   transaction_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   inverted_trans_code_ VARCHAR2(10);
BEGIN

   CASE transaction_code_
      WHEN 'PCGCHG-'    THEN inverted_trans_code_ := 'PCGCHG+';
      WHEN 'PCGCHG+'    THEN inverted_trans_code_ := 'PCGCHG-';
      WHEN 'PCGCHGTR-'  THEN inverted_trans_code_ := 'PCGCHGTR+';
      WHEN 'PCGCHGTR+'  THEN inverted_trans_code_ := 'PCGCHGTR-';
      WHEN 'CO-PCGCHG-' THEN inverted_trans_code_ := 'CO-PCGCHG+';
      WHEN 'CO-PCGCHG+' THEN inverted_trans_code_ := 'CO-PCGCHG-';
   END CASE;

   RETURN (inverted_trans_code_);
END Get_Inverted_Trans_Code___;


PROCEDURE Add_To_Trans_Id_Temp_Tab___ (
   transaction_id_ IN NUMBER )
IS
BEGIN

   INSERT INTO inventory_trans_hist_id_tmp
      (transaction_id)
   VALUES
      (transaction_id_);
END Add_To_Trans_Id_Temp_Tab___;


FUNCTION Cost_Bucket_Is_Modified___ (
   contract_       IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_                   NUMBER;
   cost_bucket_is_modified_ BOOLEAN := FALSE;

   CURSOR exist_control IS
      SELECT 1
        FROM invent_cost_bucket_manager_tmp
       WHERE contract       = contract_
         AND cost_bucket_id = cost_bucket_id_;
BEGIN

   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      cost_bucket_is_modified_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN(cost_bucket_is_modified_);
END Cost_Bucket_Is_Modified___;


FUNCTION Get_Only_Modified_Buckets___ (
   cost_detail_tab_ IN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab ) RETURN Inventory_Part_Unit_Cost_API.Cost_Detail_Tab 

IS
   local_cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   local_index_           PLS_INTEGER := 1;
BEGIN

   IF (cost_detail_tab_.COUNT > 0) THEN
      FOR i IN cost_detail_tab_.FIRST..cost_detail_tab_.LAST LOOP

         IF (Cost_Bucket_Is_Modified___(cost_detail_tab_(i).contract,
                                        cost_detail_tab_(i).cost_bucket_id)) THEN

            local_cost_detail_tab_(local_index_) := cost_detail_tab_(i);
            local_index_                         := local_index_ + 1;
         END IF;

      END LOOP;
   END IF;

   RETURN (local_cost_detail_tab_);
END Get_Only_Modified_Buckets___;


PROCEDURE Create_And_Account___ (
   transaction_code_ IN VARCHAR2,
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   quantity_         IN NUMBER,
   location_group_   IN VARCHAR2,
   cost_level_db_    IN VARCHAR2,
   configuration_id_ IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_     IN VARCHAR2 DEFAULT NULL,
   serial_no_        IN VARCHAR2 DEFAULT NULL,
   condition_code_   IN VARCHAR2 DEFAULT NULL,
   activity_seq_     IN NUMBER   DEFAULT 0,
   part_ownership_   IN VARCHAR2 DEFAULT 'COMPANY OWNED')
IS
   transaction_id_  NUMBER;
   dummy_number_    NUMBER;
   cost_detail_tab_ Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   exit_procedure_  EXCEPTION;
   local_transaction_code_ VARCHAR2(10);
   local_quantity_  NUMBER;
BEGIN

   IF (NVL(quantity_,0) = 0) THEN
      RAISE exit_procedure_;
   END IF;

   CASE cost_level_db_
      WHEN 'COST PER PART' THEN
         cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Cost_Details_By_Method(
                                                                    contract_         => contract_,
                                                                    part_no_          => part_no_,
                                                                    configuration_id_ => NULL,
                                                                    lot_batch_no_     => NULL,
                                                                    serial_no_        => NULL);
      WHEN 'COST PER CONFIGURATION' THEN
         cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Cost_Details_By_Method(
                                                            contract_         => contract_,
                                                            part_no_          => part_no_,
                                                            configuration_id_ => configuration_id_,
                                                            lot_batch_no_     => NULL,
                                                            serial_no_        => NULL);
      WHEN 'COST PER LOT BATCH' THEN
         cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Lot_Batch_Cost_Details(
                                                                                 contract_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 lot_batch_no_,
                                                                                 FALSE);
      WHEN 'COST PER SERIAL' THEN
         cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Cost_Details_By_Method(
                                                            contract_         => contract_,
                                                            part_no_          => part_no_,
                                                            configuration_id_ => configuration_id_,
                                                            lot_batch_no_     => lot_batch_no_,
                                                            serial_no_        => serial_no_);
      WHEN 'COST PER CONDITION' THEN

         cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Get_Cost_Details_By_Condition(
                                                                                 contract_,
                                                                                 part_no_,
                                                                                 configuration_id_,
                                                                                 condition_code_);
   END CASE;

   cost_detail_tab_ := Get_Only_Modified_Buckets___(cost_detail_tab_);

   IF (quantity_ < 0) THEN
      local_transaction_code_ := Get_Inverted_Trans_code___(transaction_code_);
   ELSE
      local_transaction_code_ := transaction_code_;
   END IF;

   local_quantity_ := ABS(quantity_);

   Inventory_Transaction_Hist_API.Create_And_Account(
                                                   transaction_id_     => transaction_id_,
                                                   accounting_id_      => dummy_number_,
                                                   value_              => dummy_number_,
                                                   transaction_code_   => local_transaction_code_,
                                                   contract_           => contract_,
                                                   part_no_            => part_no_,
                                                   configuration_id_   => NVL(configuration_id_,'*'),
                                                   location_no_        => NULL,
                                                   lot_batch_no_       => lot_batch_no_,
                                                   serial_no_          => serial_no_,
                                                   waiv_dev_rej_no_    => NULL,
                                                   eng_chg_level_      => NULL,
                                                   activity_seq_       => activity_seq_,
                                                   project_id_         => NULL,
                                                   source_ref1_        => NULL,
                                                   source_ref2_        => NULL,
                                                   source_ref3_        => NULL,
                                                   source_ref4_        => NULL,
                                                   source_ref5_        => NULL,
                                                   reject_code_        => NULL,
                                                   cost_detail_tab_    => cost_detail_tab_,
                                                   unit_cost_          => NULL,
                                                   quantity_           => local_quantity_,
                                                   qty_reversed_       => 0,
                                                   catch_quantity_     => NULL,
                                                   source_             => NULL,
                                                   source_ref_type_    => NULL,
                                                   owning_vendor_no_   => NULL,
                                                   condition_code_     => condition_code_,
                                                   location_group_     => location_group_,
                                                   part_ownership_db_  => part_ownership_,
                                                   owning_customer_no_ => NULL,
                                                   expiration_date_    => NULL);

   Add_To_Trans_Id_Temp_Tab___(transaction_id_);

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Create_And_Account___;


PROCEDURE Clear_Trans_Id_Temp_Tab___
IS
BEGIN

   DELETE FROM inventory_trans_hist_id_tmp;

END Clear_Trans_Id_Temp_Tab___;


PROCEDURE Load_Buckets_Into_Temp_Tab___ (
   cost_bucket_seq_ IN NUMBER )
IS
   stmt_ VARCHAR2(500);
BEGIN

   DELETE FROM invent_cost_bucket_manager_tmp;

   stmt_ := 'DECLARE '                                                                       ||
               'buckets_tab_ Temporary_Cost_Bucket_API.Cost_Buckets_Tab; '                   ||
            'BEGIN '                                                                         ||
               'buckets_tab_ := Temporary_Cost_Bucket_API.Get_Buckets(:cost_bucket_seq);'    ||
               'IF (buckets_tab_.COUNT > 0) THEN '                                           ||
                  'FOR i IN buckets_tab_.FIRST..buckets_tab_.LAST LOOP '                     ||
                     'INSERT INTO invent_cost_bucket_manager_tmp (contract, cost_bucket_id) '||
                        'VALUES (buckets_tab_(i).contract, buckets_tab_(i).cost_bucket_id); '||
                  'END LOOP; '                                                               ||
               'END IF; '                                                                    ||
            'END;';

   @ApproveDynamicStatement(2006-01-23,nidalk)
   EXECUTE IMMEDIATE stmt_ USING IN cost_bucket_seq_;

END Load_Buckets_Into_Temp_Tab___;


PROCEDURE Make_Pre_Pcg_Change___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   cost_level_db_    IN VARCHAR2,
   configuration_id_ IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_     IN VARCHAR2 DEFAULT NULL,
   serial_no_        IN VARCHAR2 DEFAULT NULL)
IS
   local_location_group_      VARCHAR2(20);

   CURSOR get_company_owned_inventory (contract_         IN VARCHAR2,
                                       part_no_          IN VARCHAR2,
                                       configuration_id_ IN VARCHAR2,
                                       lot_batch_no_     IN VARCHAR2,
                                       serial_no_        IN VARCHAR2) IS
      SELECT location.location_group,
             stock.activity_seq,
             CASE stock.serial_no
                WHEN '*' THEN
                   CASE stock.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(stock.qty_onhand)          sum_qty_onhand,
             SUM(stock.qty_in_transit)      sum_qty_in_transit
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,
             rotable_part_pool_tab          pool,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no
        AND  stock.part_no          = serial.part_no (+)
        AND  stock.serial_no        = serial.serial_no (+)
        AND  stock.part_no          = lot.part_no (+)
        AND  stock.lot_batch_no     = lot.lot_batch_no (+)        
        AND  stock.part_ownership_db = 'COMPANY OWNED'
        AND  stock.rotable_part_pool_id = pool.rotable_part_pool_id (+)
        AND  NVL(pool.rotable_pool_asset_type,'INVENTORY ASSET') = 'INVENTORY ASSET'
        AND  stock.contract         = contract_
        AND  stock.part_no          = part_no_
        AND (stock.configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND (stock.lot_batch_no     = lot_batch_no_     OR lot_batch_no_     IS NULL)
        AND (stock.serial_no        = serial_no_        OR serial_no_        IS NULL)
      GROUP BY location.location_group,
               stock.activity_seq,
               CASE stock.serial_no
                  WHEN '*' THEN
                     CASE stock.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;

   CURSOR get_vendor_consignment_stock (contract_         IN VARCHAR2,
                                        part_no_          IN VARCHAR2,
                                        configuration_id_ IN VARCHAR2,
                                        lot_batch_no_     IN VARCHAR2,
                                        serial_no_        IN VARCHAR2) IS
      SELECT location.location_group,
             stock.activity_seq,
             CASE stock.serial_no
                WHEN '*' THEN
                   CASE stock.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(stock.qty_onhand)          sum_qty_onhand
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,             
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no
        AND  stock.part_no          = serial.part_no (+)
        AND  stock.serial_no        = serial.serial_no (+)
        AND  stock.part_no          = lot.part_no (+)
        AND  stock.lot_batch_no     = lot.lot_batch_no (+)        
        AND  stock.part_ownership_db   = 'CONSIGNMENT'
        AND  stock.contract         = contract_
        AND  stock.part_no          = part_no_
        AND (stock.configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND (stock.lot_batch_no     = lot_batch_no_     OR lot_batch_no_     IS NULL)
        AND (stock.serial_no        = serial_no_        OR serial_no_        IS NULL)
      GROUP BY location.location_group,
               stock.activity_seq,
               CASE stock.serial_no
                  WHEN '*' THEN
                     CASE stock.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;

   CURSOR get_quantity_in_order_transit (contract_         IN VARCHAR2,
                                         part_no_          IN VARCHAR2,
                                         configuration_id_ IN VARCHAR2,
                                         lot_batch_no_     IN VARCHAR2,
                                         serial_no_        IN VARCHAR2) IS
      SELECT transit.activity_seq,
             CASE transit.serial_no
                WHEN '*' THEN
                   CASE transit.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(transit.quantity)          sum_qty_in_transit
       FROM  inventory_part_in_transit_pub  transit,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  transit.part_no           = serial.part_no (+)
        AND  transit.serial_no         = serial.serial_no (+)
        AND  transit.part_no           = lot.part_no (+)
        AND  transit.lot_batch_no      = lot.lot_batch_no (+)
        AND  transit.part_ownership_db = 'COMPANY OWNED'
        AND  transit.contract          = contract_
        AND  transit.part_no           = part_no_
        AND (transit.configuration_id  = configuration_id_ OR configuration_id_ IS NULL)
        AND (transit.lot_batch_no      = lot_batch_no_     OR lot_batch_no_     IS NULL)
        AND (transit.serial_no         = serial_no_        OR serial_no_        IS NULL)
      GROUP BY transit.activity_seq,
               CASE transit.serial_no
                  WHEN '*' THEN
                     CASE transit.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;

   CURSOR get_quantity_at_customer (contract_         IN VARCHAR2,
                                    part_no_          IN VARCHAR2,
                                    configuration_id_ IN VARCHAR2,
                                    lot_batch_no_     IN VARCHAR2,
                                    serial_no_        IN VARCHAR2) IS
      SELECT process_type,
             at_customer.activity_seq,
             CASE at_customer.serial_no
                WHEN '*' THEN
                   CASE at_customer.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,
             SUM(at_customer.quantity)         sum_qty_at_customer
       FROM  inventory_part_at_customer_tab at_customer,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  at_customer.part_no          = serial.part_no (+)
        AND  at_customer.serial_no        = serial.serial_no (+)
        AND  at_customer.part_no          = lot.part_no (+)
        AND  at_customer.lot_batch_no     = lot.lot_batch_no (+)
        AND  at_customer.contract         = contract_
        AND  at_customer.part_no          = part_no_
        AND (at_customer.configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND (at_customer.lot_batch_no     = lot_batch_no_     OR lot_batch_no_     IS NULL)
        AND (at_customer.serial_no        = serial_no_        OR serial_no_        IS NULL)
      GROUP BY process_type,
               at_customer.activity_seq,
               CASE at_customer.serial_no
                  WHEN '*' THEN
                     CASE at_customer
                        .lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;
BEGIN

   FOR company_owned_rec_ IN get_company_owned_inventory(contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         lot_batch_no_,
                                                         serial_no_) LOOP

      Create_And_Account___(transaction_code_ => 'PCGCHG-',
                            contract_         => contract_,
                            part_no_          => part_no_,
                            configuration_id_ => configuration_id_,
                            lot_batch_no_     => lot_batch_no_,
                            serial_no_        => serial_no_,
                            cost_level_db_    => cost_level_db_,
                            activity_seq_     => company_owned_rec_.activity_seq,
                            quantity_         => company_owned_rec_.sum_qty_onhand,
                            condition_code_   => company_owned_rec_.condition_code,
                            location_group_   => company_owned_rec_.location_group);

      Create_And_Account___(transaction_code_ => 'PCGCHGTR-',
                            contract_         => contract_,
                            part_no_          => part_no_,
                            configuration_id_ => configuration_id_,
                            lot_batch_no_     => lot_batch_no_,
                            serial_no_        => serial_no_,
                            cost_level_db_    => cost_level_db_,
                            activity_seq_     => company_owned_rec_.activity_seq,
                            quantity_         => company_owned_rec_.sum_qty_in_transit,
                            condition_code_   => company_owned_rec_.condition_code,
                            location_group_   => company_owned_rec_.location_group);
   END LOOP;

   FOR vendor_consignment_rec_ IN get_vendor_consignment_stock(contract_,
                                                               part_no_,
                                                               configuration_id_,
                                                               lot_batch_no_,
                                                               serial_no_) LOOP

      Create_And_Account___(transaction_code_ => 'CO-PCGCHG-',
                            contract_         => contract_,
                            part_no_          => part_no_,
                            configuration_id_ => configuration_id_,
                            lot_batch_no_     => lot_batch_no_,
                            serial_no_        => serial_no_,
                            cost_level_db_    => cost_level_db_,
                            activity_seq_     => vendor_consignment_rec_.activity_seq,
                            quantity_         => vendor_consignment_rec_.sum_qty_onhand,
                            condition_code_   => vendor_consignment_rec_.condition_code,
                            location_group_   => vendor_consignment_rec_.location_group,
                            part_ownership_   => 'CONSIGNMENT');
   END LOOP;

   FOR order_transit_rec_ IN get_quantity_in_order_transit(contract_,
                                                           part_no_,
                                                           configuration_id_,
                                                           lot_batch_no_,
                                                           serial_no_) LOOP

      Create_And_Account___(transaction_code_ => 'PCGCHGTR-',
                            contract_         => contract_,
                            part_no_          => part_no_,
                            configuration_id_ => configuration_id_,
                            lot_batch_no_     => lot_batch_no_,
                            serial_no_        => serial_no_,
                            cost_level_db_    => cost_level_db_,
                            quantity_         => order_transit_rec_.sum_qty_in_transit,
                            condition_code_   => order_transit_rec_.condition_code,
                            location_group_   => 'INT ORDER TRANSIT');
   END LOOP;

   FOR qty_at_customer_rec_ IN get_quantity_at_customer (contract_,
                                                         part_no_,
                                                         configuration_id_,
                                                         lot_batch_no_,
                                                         serial_no_) LOOP

      IF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_DELIVERY_CONFIRMATION) THEN
         local_location_group_ := 'DELIVERY CONFIRM';
      ELSIF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_CUSTOMER_CONSIGNMENT) THEN
         local_location_group_ := 'CONSIGNMENT';
      ELSIF (qty_at_customer_rec_.process_type = Stock_At_Cust_Process_Type_API.DB_PART_EXCHANGE) THEN
         local_location_group_ := 'PART EXCHANGE';
      ELSE
         Stock_At_Cust_Process_Type_API.Exist_Db(qty_at_customer_rec_.process_type);
      END IF;

      Create_And_Account___(transaction_code_ => 'PCGCHG-',
                            contract_         => contract_,
                            part_no_          => part_no_,
                            cost_level_db_    => cost_level_db_,
                            quantity_         => NVL(qty_at_customer_rec_.sum_qty_at_customer, 0),
                            location_group_   => local_location_group_);
   END LOOP;
END Make_Pre_Pcg_Change___;


PROCEDURE Make_Pre_Pcg_Change_Part___(
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   cost_level_db_ IN VARCHAR2 )
IS
BEGIN

   Make_Pre_Pcg_Change___(contract_      => contract_,
                          part_no_       => part_no_,
                          cost_level_db_ => cost_level_db_);
END Make_Pre_Pcg_Change_Part___;


PROCEDURE Make_Pre_Pcg_Change_Config___(
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   cost_level_db_ IN VARCHAR2 )
IS
   CURSOR get_configuration (contract_ IN VARCHAR2,
                             part_no_  IN VARCHAR2 ) IS
      SELECT DISTINCT configuration_id
        FROM inventory_part_unit_cost_tab   ipuc,
             invent_cost_bucket_manager_tmp icbm
       WHERE ipuc.contract       = icbm.contract
         AND ipuc.cost_bucket_id = icbm.cost_bucket_id
         AND ipuc.contract       = contract_
         AND ipuc.part_no        = part_no_;

   TYPE Config_Tab IS TABLE OF get_configuration%ROWTYPE INDEX BY PLS_INTEGER;

   config_tab_ Config_Tab;
BEGIN

   OPEN  get_configuration (contract_, part_no_);
   FETCH get_configuration BULK COLLECT INTO config_tab_;
   CLOSE get_configuration;

   IF (config_tab_.COUNT > 0) THEN
      FOR i IN config_tab_.FIRST..config_tab_.LAST LOOP

         Make_Pre_Pcg_Change___(contract_         => contract_,
                                part_no_          => part_no_,
                                cost_level_db_    => cost_level_db_,
                                configuration_id_ => config_tab_(i).configuration_id);
      END LOOP;
   END IF;
END Make_Pre_Pcg_Change_Config___;


PROCEDURE Make_Pre_Pcg_Change_Lot___(
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   cost_level_db_ IN VARCHAR2 )
IS
   CURSOR get_config_lot_batch (contract_ IN VARCHAR2,
                                part_no_  IN VARCHAR2 ) IS
      SELECT DISTINCT configuration_id, lot_batch_no
        FROM inventory_part_unit_cost_tab   ipuc,
             invent_cost_bucket_manager_tmp icbm
       WHERE ipuc.contract       = icbm.contract
         AND ipuc.cost_bucket_id = icbm.cost_bucket_id
         AND ipuc.contract       = contract_
         AND ipuc.part_no        = part_no_;

   TYPE Config_Lot_Tab IS TABLE OF get_config_lot_batch%ROWTYPE INDEX BY PLS_INTEGER;

   config_lot_tab_ Config_Lot_Tab;
BEGIN

   OPEN  get_config_lot_batch (contract_, part_no_);
   FETCH get_config_lot_batch BULK COLLECT INTO config_lot_tab_;
   CLOSE get_config_lot_batch;

   IF (config_lot_tab_.COUNT > 0) THEN
      FOR i IN config_lot_tab_.FIRST..config_lot_tab_.LAST LOOP

         Make_Pre_Pcg_Change___(contract_         => contract_,
                                part_no_          => part_no_,
                                cost_level_db_    => cost_level_db_,
                                configuration_id_ => config_lot_tab_(i).configuration_id,
                                lot_batch_no_     => config_lot_tab_(i).lot_batch_no);
      END LOOP;
   END IF;
END Make_Pre_Pcg_Change_Lot___;


PROCEDURE Make_Pre_Pcg_Change_Serial___ (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   cost_level_db_ IN VARCHAR2 )
IS
   CURSOR get_config_lot_serial (contract_ IN VARCHAR2,
                                 part_no_  IN VARCHAR2 ) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM inventory_part_unit_cost_tab   ipuc,
             invent_cost_bucket_manager_tmp icbm
       WHERE ipuc.contract       = icbm.contract
         AND ipuc.cost_bucket_id = icbm.cost_bucket_id
         AND ipuc.contract       = contract_
         AND ipuc.part_no        = part_no_;

   TYPE Config_Lot_Serial_Tab IS TABLE OF get_config_lot_serial%ROWTYPE INDEX BY PLS_INTEGER;

   config_lot_serial_tab_ Config_Lot_Serial_Tab;
BEGIN

   OPEN  get_config_lot_serial (contract_, part_no_);
   FETCH get_config_lot_serial BULK COLLECT INTO config_lot_serial_tab_;
   CLOSE get_config_lot_serial;

   IF (config_lot_serial_tab_.COUNT > 0) THEN
      FOR i IN config_lot_serial_tab_.FIRST..config_lot_serial_tab_.LAST LOOP

         Make_Pre_Pcg_Change___(contract_         => contract_,
                                part_no_          => part_no_,
                                cost_level_db_    => cost_level_db_,
                                configuration_id_ => config_lot_serial_tab_(i).configuration_id,
                                lot_batch_no_     => config_lot_serial_tab_(i).lot_batch_no,
                                serial_no_        => config_lot_serial_tab_(i).serial_no);
      END LOOP;
   END IF;
END Make_Pre_Pcg_Change_Serial___;


PROCEDURE Make_Pre_Pcg_Change_Cond___ (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   cost_level_db_ IN VARCHAR2 )
IS
   char_null_ VARCHAR2(12) := 'VARCHAR2NULL';

   CURSOR get_config_condition (contract_ IN VARCHAR2,
                                part_no_  IN VARCHAR2 ) IS
      SELECT DISTINCT ipuc.configuration_id,
                      CASE ipuc.serial_no
                         WHEN '*' THEN
                            CASE ipuc.lot_batch_no
                               WHEN '*' THEN NULL ELSE lot.condition_code END
                         ELSE serial.condition_code END condition_code
        FROM inventory_part_unit_cost_tab   ipuc,
             invent_cost_bucket_manager_tmp icbm,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
       WHERE ipuc.contract       = icbm.contract
         AND ipuc.cost_bucket_id = icbm.cost_bucket_id
         AND ipuc.part_no        = serial.part_no (+)
         AND ipuc.serial_no      = serial.serial_no (+)
         AND ipuc.part_no        = lot.part_no (+)
         AND ipuc.lot_batch_no   = lot.lot_batch_no (+)
         AND ipuc.contract       = contract_
         AND ipuc.part_no        = part_no_;

   TYPE Config_Condition_Tab IS TABLE OF get_config_condition%ROWTYPE INDEX BY PLS_INTEGER;

   config_condition_tab_ Config_Condition_Tab;

   CURSOR get_company_owned_inventory (contract_         IN VARCHAR2,
                                       part_no_          IN VARCHAR2,
                                       configuration_id_ IN VARCHAR2,
                                       condition_code_   IN VARCHAR2) IS
      SELECT location.location_group,
             stock.activity_seq,
             SUM(stock.qty_onhand)          sum_qty_onhand,
             SUM(stock.qty_in_transit)      sum_qty_in_transit
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,             
             rotable_part_pool_tab          pool,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no
        AND  stock.part_no          = serial.part_no (+)
        AND  stock.serial_no        = serial.serial_no (+)
        AND  stock.part_no          = lot.part_no (+)
        AND  stock.lot_batch_no     = lot.lot_batch_no (+)        
        AND  stock.part_ownership_db = 'COMPANY OWNED'
        AND  stock.rotable_part_pool_id = pool.rotable_part_pool_id (+)
        AND  NVL(pool.rotable_pool_asset_type,'INVENTORY ASSET') = 'INVENTORY ASSET'
        AND  stock.contract         = contract_
        AND  stock.part_no          = part_no_
        AND  stock.configuration_id = configuration_id_
        AND  NVL(DECODE(stock.serial_no,
                        '*',
                        DECODE(stock.lot_batch_no,
                               '*',
                               char_null_,
                               lot.condition_code),
                        serial.condition_code),char_null_) = NVL(condition_code_,char_null_)
      GROUP BY location.location_group,
               stock.activity_seq;

   CURSOR get_vendor_consignment_stock (contract_         IN VARCHAR2,
                                        part_no_          IN VARCHAR2,
                                        configuration_id_ IN VARCHAR2,
                                        condition_code_   IN VARCHAR2) IS
      SELECT location.location_group,
             stock.activity_seq,
             SUM(stock.qty_onhand)          sum_qty_onhand
       FROM  inventory_part_in_stock_pub    stock,
             inventory_location_pub         location,             
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  stock.contract         = location.contract
        AND  stock.location_no      = location.location_no
        AND  stock.part_no          = serial.part_no (+)
        AND  stock.serial_no        = serial.serial_no (+)
        AND  stock.part_no          = lot.part_no (+)
        AND  stock.lot_batch_no     = lot.lot_batch_no (+)        
        AND  stock.part_ownership_db   = 'CONSIGNMENT'
        AND  stock.contract         = contract_
        AND  stock.part_no          = part_no_
        AND  stock.configuration_id = configuration_id_
        AND  NVL(DECODE(stock.serial_no,
                        '*',
                        DECODE(stock.lot_batch_no,
                               '*',
                               char_null_,
                               lot.condition_code),
                        serial.condition_code),char_null_) = NVL(condition_code_,char_null_)
      GROUP BY location.location_group,
               stock.activity_seq;

   CURSOR get_quantity_in_order_transit (contract_         IN VARCHAR2,
                                         part_no_          IN VARCHAR2,
                                         configuration_id_ IN VARCHAR2,
                                         condition_code_   IN VARCHAR2) IS
      SELECT transit.activity_seq,
             SUM(transit.quantity)          sum_qty_in_transit
       FROM  inventory_part_in_transit_pub  transit,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  transit.part_no           = serial.part_no (+)
        AND  transit.serial_no         = serial.serial_no (+)
        AND  transit.part_no           = lot.part_no (+)
        AND  transit.lot_batch_no      = lot.lot_batch_no (+)
        AND  transit.part_ownership_db = 'COMPANY OWNED'
        AND  transit.contract          = contract_
        AND  transit.part_no           = part_no_
        AND  transit.configuration_id  = configuration_id_
        AND  NVL(DECODE(transit.serial_no,
                        '*',
                        DECODE(transit.lot_batch_no,
                               '*',
                               char_null_,
                               lot.condition_code),
                        serial.condition_code),char_null_) = NVL(condition_code_,char_null_)
      GROUP BY transit.activity_seq;
               
   exit_procedure_ EXCEPTION;
BEGIN

   OPEN  get_config_condition (contract_, part_no_);
   FETCH get_config_condition BULK COLLECT INTO config_condition_tab_;
   CLOSE get_config_condition;

   IF (config_condition_tab_.COUNT = 0) THEN
      RAISE exit_procedure_;
   END IF;

   FOR i IN config_condition_tab_.FIRST..config_condition_tab_.LAST LOOP
      FOR company_owned_rec_ IN get_company_owned_inventory(
                                                      contract_,
                                                      part_no_,
                                                      config_condition_tab_(i).configuration_id,
                                                      config_condition_tab_(i).condition_code) LOOP

         Create_And_Account___(transaction_code_ => 'PCGCHG-',
                               contract_         => contract_,
                               part_no_          => part_no_,
                               configuration_id_ => config_condition_tab_(i).configuration_id,
                               cost_level_db_    => cost_level_db_,
                               activity_seq_     => company_owned_rec_.activity_seq,
                               quantity_         => company_owned_rec_.sum_qty_onhand,
                               condition_code_   => config_condition_tab_(i).condition_code,
                               location_group_   => company_owned_rec_.location_group);

         Create_And_Account___(transaction_code_ => 'PCGCHGTR-',
                               contract_         => contract_,
                               part_no_          => part_no_,
                               configuration_id_ => config_condition_tab_(i).configuration_id,
                               cost_level_db_    => cost_level_db_,
                               activity_seq_     => company_owned_rec_.activity_seq,
                               quantity_         => company_owned_rec_.sum_qty_in_transit,
                               condition_code_   => config_condition_tab_(i).condition_code,
                               location_group_   => company_owned_rec_.location_group);
      END LOOP;

      FOR vendor_consignment_rec_ IN get_vendor_consignment_stock(
                                                      contract_,
                                                      part_no_,
                                                      config_condition_tab_(i).configuration_id,
                                                      config_condition_tab_(i).condition_code) LOOP

         Create_And_Account___(transaction_code_ => 'CO-PCGCHG-',
                               contract_         => contract_,
                               part_no_          => part_no_,
                               configuration_id_ => config_condition_tab_(i).configuration_id,
                               cost_level_db_    => cost_level_db_,
                               activity_seq_     => vendor_consignment_rec_.activity_seq,
                               quantity_         => vendor_consignment_rec_.sum_qty_onhand,
                               condition_code_   => config_condition_tab_(i).condition_code,
                               location_group_   => vendor_consignment_rec_.location_group,
                               part_ownership_   => 'CONSIGNMENT');
      END LOOP;

      FOR order_transit_rec_ IN get_quantity_in_order_transit(
                                                      contract_,
                                                      part_no_,
                                                      config_condition_tab_(i).configuration_id,
                                                      config_condition_tab_(i).condition_code) LOOP

         Create_And_Account___(transaction_code_ => 'PCGCHGTR-',
                               contract_         => contract_,
                               part_no_          => part_no_,
                               configuration_id_ => config_condition_tab_(i).configuration_id,
                               cost_level_db_    => cost_level_db_,
                               quantity_         => order_transit_rec_.sum_qty_in_transit,
                               condition_code_   => config_condition_tab_(i).condition_code,
                               location_group_   => 'INT ORDER TRANSIT');
      END LOOP;
   END LOOP;

EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Make_Pre_Pcg_Change_Cond___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Make_Pre_Posting_Group_Change (
   cost_bucket_seq_ IN NUMBER )
IS
   CURSOR get_inventory_part IS
      SELECT DISTINCT ipuc.contract, ipuc.part_no
        FROM inventory_part_unit_cost_tab   ipuc,
             invent_cost_bucket_manager_tmp icbm
       WHERE ipuc.contract       = icbm.contract
         AND ipuc.cost_bucket_id = icbm.cost_bucket_id
   UNION
      SELECT DISTINCT ipfd.contract, ipfd.part_no
        FROM inventory_part_fifo_detail_tab ipfd,
             invent_cost_bucket_manager_tmp icbm
       WHERE ipfd.contract       = icbm.contract
         AND ipfd.cost_bucket_id = icbm.cost_bucket_id;

   TYPE Part_Tab IS TABLE OF get_inventory_part%ROWTYPE INDEX BY PLS_INTEGER;

   part_tab_       Part_Tab;
   exit_procedure_ EXCEPTION;
   invepart_rec_   Inventory_Part_API.Public_Rec;
BEGIN

   Load_Buckets_Into_Temp_Tab___(cost_bucket_seq_);

   OPEN  get_inventory_part;
   FETCH get_inventory_part BULK COLLECT INTO part_tab_;
   CLOSE get_inventory_part;

   IF (part_tab_.COUNT = 0) THEN
      RAISE exit_procedure_;
   END IF;

   Clear_Trans_Id_Temp_Tab___;

   FOR i IN part_tab_.FIRST..part_tab_.LAST LOOP

      invepart_rec_ := Inventory_Part_API.Get(part_tab_(i).contract, part_tab_(i).part_no);

      CASE invepart_rec_.inventory_part_cost_level
         WHEN 'COST PER PART' THEN
            Make_Pre_Pcg_Change_Part___(part_tab_(i).contract,
                                        part_tab_(i).part_no,
                                        invepart_rec_.inventory_part_cost_level);
         WHEN 'COST PER CONFIGURATION' THEN
            Make_Pre_Pcg_Change_Config___(part_tab_(i).contract,
                                          part_tab_(i).part_no,
                                          invepart_rec_.inventory_part_cost_level);
         WHEN 'COST PER CONDITION' THEN
            Make_Pre_Pcg_Change_Cond___(part_tab_(i).contract,
                                        part_tab_(i).part_no,
                                        invepart_rec_.inventory_part_cost_level);
         WHEN 'COST PER LOT BATCH' THEN
            Make_Pre_Pcg_Change_Lot___(part_tab_(i).contract,
                                       part_tab_(i).part_no,
                                       invepart_rec_.inventory_part_cost_level);
         WHEN 'COST PER SERIAL' THEN
            Make_Pre_Pcg_Change_Serial___(part_tab_(i).contract,
                                          part_tab_(i).part_no,
                                          invepart_rec_.inventory_part_cost_level);
      END CASE;
   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Make_Pre_Posting_Group_Change;


PROCEDURE Make_Post_Posting_Group_Change
IS
   old_trans_rec_    Inventory_Transaction_Hist_API.Public_Rec;
   cost_detail_tab_  Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   transaction_code_ VARCHAR2(10);
   transaction_id_   NUMBER;
   dummy_number_     NUMBER;

   CURSOR get_transaction_id IS
      SELECT transaction_id
      FROM inventory_trans_hist_id_tmp;
BEGIN

   FOR trans_id_rec_ IN get_transaction_id LOOP

      old_trans_rec_   := Inventory_Transaction_Hist_API.Get(trans_id_rec_.transaction_id);
      cost_detail_tab_ := Inventory_Transaction_Cost_API.Get_Transaction_Cost_Details(
                                                                     trans_id_rec_.transaction_id);

      transaction_code_ := Get_Inverted_Trans_code___(old_trans_rec_.transaction_code);

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
                                  cost_detail_tab_    => cost_detail_tab_,
                                  unit_cost_          => NULL,
                                  quantity_           => old_trans_rec_.quantity,
                                  qty_reversed_       => old_trans_rec_.qty_reversed,
                                  catch_quantity_     => old_trans_rec_.catch_quantity,
                                  source_             => old_trans_rec_.source,
                                  source_ref_type_    => old_trans_rec_.source_ref_type,
                                  owning_vendor_no_   => old_trans_rec_.owning_vendor_no,
                                  condition_code_     => old_trans_rec_.condition_code,
                                  location_group_     => old_trans_rec_.location_group,
                                  part_ownership_db_  => old_trans_rec_.part_ownership,
                                  owning_customer_no_ => old_trans_rec_.owning_customer_no,
                                  expiration_date_    => NULL);

      Invent_Trans_Interconnect_API.Connect_Transactions(trans_id_rec_.transaction_id,
                                                         transaction_id_,
                                                         'POSTING GROUP CHANGE');

      Inventory_Transaction_Hist_API.Do_Transaction_Booking(transaction_id_);

   END LOOP;

   Clear_Trans_Id_Temp_Tab___;

END Make_Post_Posting_Group_Change;


FUNCTION Get_Cost_Bucket_Type_Db (
   contract_ IN VARCHAR2,
   cost_bucket_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_                VARCHAR2(200);
   cost_bucket_type_db_ VARCHAR2(20);
BEGIN

   IF (cost_bucket_id_ = '*') THEN
      cost_bucket_type_db_ := 'DummyCostBucketType';
   ELSE
      stmt_ := 'BEGIN '                                                                           ||
                ':cost_bucket_type_db := Cost_Bucket_API.Get_Cost_Bucket_Public_Type_Db('         ||
                                                                              ':contract,'        ||
                                                                              ':cost_bucket_id); '||
               'END;';

      @ApproveDynamicStatement(2006-01-23,nidalk)
      EXECUTE IMMEDIATE stmt_ USING OUT cost_bucket_type_db_,
                                     IN contract_,
                                     IN cost_bucket_id_;
   END IF;

   RETURN (cost_bucket_type_db_);
END Get_Cost_Bucket_Type_Db;



