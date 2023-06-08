-----------------------------------------------------------------------------
--
--  Logical unit: InventoryLocationManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170328  Chfose  LIM-4350, Added parameters onhand_, in_transit_ & supplier_consignment_ to Handle_Group_Change___, Handle_Group_Change_Config___, 
--  170328          Handle_Location_Group_Change__ & Handle_Group_Change_Serial___ to support revaluating pallet location types in upgrade to APPS10.
--  150512  IsSalk  KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().
--  100420  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.Create_And_Account 
--  100420          within Create_And_Account___ method.
--  100409  MaRalk  Added two local constants db_company_owned_ and db_consignment_ to Handle_Group_Change___ method and
--  100409          replaced with hard coded 'COMPANY OWNED' and 'CONSIGNMENT' values throughout the method.
--  100409          Modified cursor get_quantities_in_stock to remove NVL check for stock.part_ownership_db in the same method.
--  100406  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.New
--  100406          within Create_And_Account___ method.
--  100401  MaRalk  Modified cursor get_quantities_in_stock in Handle_Group_Change___ method
--  100401          to remove the usage of INVENTORY_PART_STOCK_OWNER_PUB view.
--------------------------------------- 14.0.0 --------------------------------
--  061121  LEPESE  Major redesign.
--  061117  LEPESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Create_And_Account___ (
   old_group_transaction_code_ IN VARCHAR2,
   new_group_transaction_code_ IN VARCHAR2,
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   quantity_                   IN NUMBER,
   location_no_                IN VARCHAR2,
   old_location_group_         IN VARCHAR2,
   new_location_group_         IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   activity_seq_               IN NUMBER,
   part_ownership_db_          IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2 )
IS
   old_group_transaction_id_ NUMBER;
   new_group_transaction_id_ NUMBER;
   dummy_number_             NUMBER;
   empty_cost_detail_tab_    Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
BEGIN

   Inventory_Transaction_Hist_API.Create_And_Account(
                                                  transaction_id_     => old_group_transaction_id_,
                                                  accounting_id_      => dummy_number_,
                                                  value_              => dummy_number_,
                                                  transaction_code_   => old_group_transaction_code_,
                                                  contract_           => contract_,
                                                  part_no_            => part_no_,
                                                  configuration_id_   => configuration_id_,
                                                  location_no_        => location_no_,
                                                  lot_batch_no_       => lot_batch_no_,
                                                  serial_no_          => serial_no_,
                                                  waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                                  eng_chg_level_      => NULL,
                                                  activity_seq_       => activity_seq_,
                                                  project_id_         => NULL,
                                                  source_ref1_        => NULL,
                                                  source_ref2_        => NULL,
                                                  source_ref3_        => NULL,
                                                  source_ref4_        => NULL,
                                                  source_ref5_        => NULL,
                                                  reject_code_        => NULL,
                                                  cost_detail_tab_    => empty_cost_detail_tab_,
                                                  unit_cost_          => NULL,
                                                  quantity_           => quantity_,
                                                  qty_reversed_       => 0,
                                                  catch_quantity_     => NULL,
                                                  source_             => NULL,
                                                  source_ref_type_    => NULL,
                                                  owning_vendor_no_   => NULL,
                                                  condition_code_     => NULL,
                                                  location_group_     => old_location_group_,
                                                  part_ownership_db_  => part_ownership_db_,
                                                  owning_customer_no_ => NULL,
                                                  expiration_date_    => NULL);

      Inventory_Transaction_Hist_API.New(transaction_id_     => new_group_transaction_id_,
                                         accounting_id_      => dummy_number_,
                                         value_              => dummy_number_,
                                         transaction_code_   => new_group_transaction_code_,
                                         contract_           => contract_,
                                         part_no_            => part_no_,
                                         configuration_id_   => configuration_id_,
                                         location_no_        => location_no_,
                                         lot_batch_no_       => lot_batch_no_,
                                         serial_no_          => serial_no_,
                                         waiv_dev_rej_no_    => waiv_dev_rej_no_,
                                         eng_chg_level_      => NULL,
                                         activity_seq_       => activity_seq_,
                                         project_id_         => NULL,
                                         source_ref1_        => NULL,
                                         source_ref2_        => NULL,
                                         source_ref3_        => NULL,
                                         source_ref4_        => NULL,
                                         source_ref5_        => NULL,
                                         reject_code_        => NULL,
                                         cost_detail_tab_    => empty_cost_detail_tab_,
                                         unit_cost_          => NULL,
                                         quantity_           => quantity_,
                                         qty_reversed_       => 0,
                                         catch_quantity_     => NULL,
                                         source_             => NULL,
                                         source_ref_type_    => NULL,
                                         owning_vendor_no_   => NULL,
                                         condition_code_     => NULL,
                                         location_group_     => new_location_group_,
                                         part_ownership_db_  => part_ownership_db_,
                                         owning_customer_no_ => NULL,
                                         expiration_date_    => NULL);

      Invent_Trans_Interconnect_API.Connect_Transactions(old_group_transaction_id_,
                                                         new_group_transaction_id_,
                                                         'LOCATION GROUP CHANGE');

      Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_group_transaction_id_);

END Create_And_Account___;


PROCEDURE Handle_Group_Change___ (
   contract_               IN VARCHAR2,
   location_no_            IN VARCHAR2,
   old_location_group_     IN VARCHAR2,
   new_location_group_     IN VARCHAR2,
   part_no_                IN VARCHAR2,
   configuration_id_       IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   onhand_                 IN BOOLEAN DEFAULT TRUE,
   in_transit_             IN BOOLEAN DEFAULT TRUE,
   supplier_consignment_   IN BOOLEAN DEFAULT TRUE )
IS
   db_company_owned_ CONSTANT inventory_part_in_stock_pub.part_ownership_db%TYPE := Part_Ownership_API.DB_COMPANY_OWNED;
   db_consignment_   CONSTANT inventory_part_in_stock_pub.part_ownership_db%TYPE := Part_Ownership_API.DB_CONSIGNMENT;

   CURSOR get_quantities_in_stock (contract_         IN VARCHAR2,
                                   location_no_      IN VARCHAR2,
                                   part_no_          IN VARCHAR2,
                                   configuration_id_ IN VARCHAR2,
                                   lot_batch_no_     IN VARCHAR2,
                                   serial_no_        IN VARCHAR2) IS
      SELECT stock.activity_seq,
             stock.waiv_dev_rej_no,
             CASE stock.serial_no
                WHEN '*' THEN
                   CASE stock.lot_batch_no
                      WHEN '*' THEN NULL ELSE lot.condition_code END
                ELSE serial.condition_code END condition_code,             
              SUM (CASE stock.part_ownership_db
                     WHEN db_company_owned_ THEN stock.qty_onhand ELSE 0 END) quantity,
             SUM (CASE stock.part_ownership_db
                     WHEN db_company_owned_ THEN stock.qty_in_transit ELSE 0 END) qty_in_transit,
             SUM (CASE stock.part_ownership_db
                     WHEN db_consignment_ THEN stock.qty_onhand + stock.qty_in_transit
                        ELSE 0 END) vendor_owned_qty
       FROM  inventory_part_in_stock_pub    stock,             
             rotable_part_pool_tab          pool,
             part_serial_catalog_pub        serial,
             lot_batch_master_pub           lot
      WHERE  stock.part_no          = serial.part_no (+)
        AND  stock.serial_no        = serial.serial_no (+)
        AND  stock.part_no          = lot.part_no (+)
        AND  stock.lot_batch_no     = lot.lot_batch_no (+)        
        AND  stock.part_ownership_db IN (db_company_owned_, db_consignment_)
        AND  stock.rotable_part_pool_id = pool.rotable_part_pool_id (+)
        AND  NVL(pool.rotable_pool_asset_type,'INVENTORY ASSET') = 'INVENTORY ASSET'
        AND  stock.contract         = contract_
        AND  stock.location_no      = location_no_
        AND  stock.part_no          = part_no_
        AND  stock.configuration_id = configuration_id_
        AND (stock.lot_batch_no     = lot_batch_no_ OR lot_batch_no_ IS NULL)
        AND (stock.serial_no        = serial_no_    OR serial_no_    IS NULL)
      GROUP BY stock.activity_seq,
               stock.waiv_dev_rej_no,
               CASE stock.serial_no
                  WHEN '*' THEN
                     CASE stock.lot_batch_no
                        WHEN '*' THEN NULL ELSE lot.condition_code END
                  ELSE serial.condition_code END;
BEGIN

   FOR stock_rec_ IN get_quantities_in_stock(contract_,
                                             location_no_,
                                             part_no_,
                                             configuration_id_,
                                             lot_batch_no_,
                                             serial_no_) LOOP
      IF (stock_rec_.quantity != 0 AND onhand_) THEN

         Create_And_Account___(old_group_transaction_code_ => 'LOCGRP-',
                               new_group_transaction_code_ => 'LOCGRP+',
                               contract_                   => contract_,
                               part_no_                    => part_no_,
                               configuration_id_           => configuration_id_,
                               lot_batch_no_               => lot_batch_no_,
                               serial_no_                  => serial_no_,
                               activity_seq_               => stock_rec_.activity_seq,
                               quantity_                   => stock_rec_.quantity,
                               location_no_                => location_no_,
                               old_location_group_         => old_location_group_,
                               new_location_group_         => new_location_group_,
                               waiv_dev_rej_no_            => stock_rec_.waiv_dev_rej_no,
                               part_ownership_db_          => db_company_owned_);
      END IF;

      IF (stock_rec_.qty_in_transit != 0 AND in_transit_) THEN

         Create_And_Account___(old_group_transaction_code_ => 'LOCGRPTR-',
                               new_group_transaction_code_ => 'LOCGRPTR+',
                               contract_                   => contract_,
                               part_no_                    => part_no_,
                               configuration_id_           => configuration_id_,
                               lot_batch_no_               => lot_batch_no_,
                               serial_no_                  => serial_no_,
                               activity_seq_               => stock_rec_.activity_seq,
                               quantity_                   => stock_rec_.qty_in_transit,
                               location_no_                => location_no_,
                               old_location_group_         => old_location_group_,
                               new_location_group_         => new_location_group_,
                               waiv_dev_rej_no_            => stock_rec_.waiv_dev_rej_no,
                               part_ownership_db_          => db_company_owned_);
      END IF;

      IF (stock_rec_.vendor_owned_qty != 0 AND supplier_consignment_) THEN

         Create_And_Account___(old_group_transaction_code_ => 'CO-LOCGRP-',
                               new_group_transaction_code_ => 'CO-LOCGRP+',
                               contract_                   => contract_,
                               part_no_                    => part_no_,
                               configuration_id_           => configuration_id_,
                               lot_batch_no_               => lot_batch_no_,
                               serial_no_                  => serial_no_,
                               activity_seq_               => stock_rec_.activity_seq,
                               quantity_                   => stock_rec_.vendor_owned_qty,
                               location_no_                => location_no_,
                               old_location_group_         => old_location_group_,
                               new_location_group_         => new_location_group_,
                               waiv_dev_rej_no_            => stock_rec_.waiv_dev_rej_no,
                               part_ownership_db_          => db_consignment_);
      END IF;
   END LOOP;

END Handle_Group_Change___;


PROCEDURE Handle_Group_Change_Config___(
   contract_               IN VARCHAR2,
   location_no_            IN VARCHAR2,
   old_location_group_     IN VARCHAR2,
   new_location_group_     IN VARCHAR2,
   part_no_                IN VARCHAR2,
   onhand_                 IN BOOLEAN DEFAULT TRUE,
   in_transit_             IN BOOLEAN DEFAULT TRUE,
   supplier_consignment_   IN BOOLEAN DEFAULT TRUE )
IS
   CURSOR get_configuration (contract_ IN VARCHAR2,
                             part_no_  IN VARCHAR2 ) IS
      SELECT DISTINCT configuration_id
        FROM inventory_part_in_stock_tab
       WHERE ((qty_onhand != 0) OR (qty_in_transit != 0))
         AND contract = contract_
         AND part_no  = part_no_;

   TYPE Config_Tab IS TABLE OF get_configuration%ROWTYPE INDEX BY PLS_INTEGER;

   config_tab_ Config_Tab;
BEGIN

   OPEN  get_configuration (contract_, part_no_);
   FETCH get_configuration BULK COLLECT INTO config_tab_;
   CLOSE get_configuration;

   IF (config_tab_.COUNT > 0) THEN
      FOR i IN config_tab_.FIRST..config_tab_.LAST LOOP

         Handle_Group_Change___(contract_             => contract_,
                                location_no_          => location_no_,
                                old_location_group_   => old_location_group_,
                                new_location_group_   => new_location_group_,
                                part_no_              => part_no_,
                                configuration_id_     => config_tab_(i).configuration_id,
                                lot_batch_no_         => NULL,
                                serial_no_            => NULL,
                                onhand_               => onhand_,
                                in_transit_           => in_transit_,
                                supplier_consignment_ => supplier_consignment_);
      END LOOP;
   END IF;
END Handle_Group_Change_Config___;


PROCEDURE Handle_Group_Change_Serial___ (
   contract_               IN VARCHAR2,
   location_no_            IN VARCHAR2,
   old_location_group_     IN VARCHAR2,
   new_location_group_     IN VARCHAR2,
   part_no_                IN VARCHAR2,
   onhand_                 IN BOOLEAN DEFAULT TRUE,
   in_transit_             IN BOOLEAN DEFAULT TRUE,
   supplier_consignment_   IN BOOLEAN DEFAULT TRUE )
IS
   CURSOR get_config_lot_serial (contract_ IN VARCHAR2,
                                 part_no_  IN VARCHAR2 ) IS
      SELECT DISTINCT configuration_id, lot_batch_no, serial_no
        FROM inventory_part_in_stock_tab
       WHERE ((qty_onhand != 0) OR (qty_in_transit != 0))
         AND contract = contract_
         AND part_no  = part_no_;

   TYPE Config_Lot_Serial_Tab IS TABLE OF get_config_lot_serial%ROWTYPE INDEX BY PLS_INTEGER;

   config_lot_serial_tab_ Config_Lot_Serial_Tab;
BEGIN

   OPEN  get_config_lot_serial (contract_, part_no_);
   FETCH get_config_lot_serial BULK COLLECT INTO config_lot_serial_tab_;
   CLOSE get_config_lot_serial;

   IF (config_lot_serial_tab_.COUNT > 0) THEN
      FOR i IN config_lot_serial_tab_.FIRST..config_lot_serial_tab_.LAST LOOP

         Handle_Group_Change___(contract_             => contract_,
                                location_no_          => location_no_,
                                old_location_group_   => old_location_group_,
                                new_location_group_   => new_location_group_,
                                part_no_              => part_no_,
                                configuration_id_     => config_lot_serial_tab_(i).configuration_id,
                                lot_batch_no_         => config_lot_serial_tab_(i).lot_batch_no,
                                serial_no_            => config_lot_serial_tab_(i).serial_no,
                                onhand_               => onhand_,
                                in_transit_           => in_transit_,
                                supplier_consignment_ => supplier_consignment_);
      END LOOP;
   END IF;
END Handle_Group_Change_Serial___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- NOTE: Parameters onhand_, in_transit_ & supplier_consignment_ are only used in upgrade to APP10 (POST_INVENT_RevaluatePalletLocationTypes.sql).
PROCEDURE Handle_Location_Group_Change__ (
   contract_               IN VARCHAR2,
   location_no_            IN VARCHAR2,
   old_location_group_     IN VARCHAR2,
   new_location_group_     IN VARCHAR2,
   onhand_                 IN BOOLEAN DEFAULT TRUE,
   in_transit_             IN BOOLEAN DEFAULT TRUE,
   supplier_consignment_   IN BOOLEAN DEFAULT TRUE )
IS
   CURSOR get_inventory_part IS
      SELECT DISTINCT part_no
        FROM inventory_part_in_stock_tab
       WHERE ((qty_onhand != 0) OR (qty_in_transit != 0))
         AND contract = contract_
         AND location_no = location_no_;

   TYPE Part_Tab IS TABLE OF get_inventory_part%ROWTYPE INDEX BY PLS_INTEGER;

   part_tab_       Part_Tab;
   exit_procedure_ EXCEPTION;
   invepart_rec_   Inventory_Part_API.Public_Rec;
BEGIN

   OPEN  get_inventory_part;
   FETCH get_inventory_part BULK COLLECT INTO part_tab_;
   CLOSE get_inventory_part;

   IF (part_tab_.COUNT = 0) THEN
      RAISE exit_procedure_;
   END IF;

   FOR i IN part_tab_.FIRST..part_tab_.LAST LOOP

      invepart_rec_ := Inventory_Part_API.Get(contract_, part_tab_(i).part_no);

      IF (invepart_rec_.inventory_part_cost_level IN ('COST PER PART',
                                                      'COST PER CONFIGURATION')) THEN
         Handle_Group_Change_Config___(contract_,
                                       location_no_,
                                       old_location_group_,
                                       new_location_group_,
                                       part_tab_(i).part_no,
                                       onhand_,
                                       in_transit_,
                                       supplier_consignment_);

      ELSIF (invepart_rec_.inventory_part_cost_level IN ('COST PER CONDITION',
                                                         'COST PER LOT BATCH',
                                                         'COST PER SERIAL')) THEN
         Handle_Group_Change_Serial___(contract_,
                                       location_no_,
                                       old_location_group_,
                                       new_location_group_,
                                       part_tab_(i).part_no,
                                       onhand_,
                                       in_transit_,
                                       supplier_consignment_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'LEVELNOTSUPP: Inventory Part Cost Level :P1 is not supported in this operation.',Inventory_Part_Cost_Level_API.Decode(invepart_rec_.inventory_part_cost_level));
      END IF;

   END LOOP;
EXCEPTION
   WHEN exit_procedure_ THEN
      NULL;
END Handle_Location_Group_Change__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


