-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartTracing
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210914  WaSalk  Bug 160530 (SC21R2-2339), Removed Check_Transaction_Exist condition to support tree generation for duplicate transaction_ids.
--  210610  WaSalk  Bug 159436 (SCZ-15019), Modified Cursor get_rec in Gen_Part_Usage_So___() to fetch records where serial manufactured parts 
--  210610          with lot tracked component parts and modified Gen_Part_Usage_So___() parameter list by adding ignore_serial_.
--  210302  GrGalk  Bug 156567 (SCZ-12580), Modified Get_Tree_Id() by adding condition to cursor to select parent/top transaction_id.
--  201102  WaSalk  Bug 154793 (SCZ-11824), Modified Gen_Part_Origin_Child_Nodes___() and added Gen_Part_Origin_Co___() and Gen_Part_Origin___() to availabe tracing when components are Charged items.
--  201102          Moved common method structure able to use by Gen_Part_Origin_Co___() and Gen_Part_Origin_Po___() to Gen_Part_Origin___().
--  200702  NiAslk  Bug 154562 (SCZ-10484), Added new method Get_Tree_Id
--  190917  SBalLK  Bug 150018 (SCZ-6737), Modified cursor in Gen_Part_Usage_So___() method to use source_ref3 instead of source_ref2 along with the sequence_no where,
--  190917          source_ref3 represent the sequence_no attribute in manufactured part.
--  190610  LaThlk  Bug 148639(SCZ-4670), Modified procedures Gen_Part_Origin_So___(), Gen_Part_Origin_Po___() and Gen_Part_Origin_Prosh___() to avoid returning the no_data_found exception
--  190610          when part_serial_catalog_tab is empty by querying only when there is a serial number in the inventory transaction tracing record.
--  190122  ShKolk  SCUXXW4-6402, Added method Delete_Old_Records___ and called it from Gen_Part_Usage_Tree__ and Gen_Part_Origin_Tree__ 
--  190122          to delete previous recors in the table.
--  180309  RuLiLk  STRSC-14795,Modified method Gen_Part_Origin_Po___ by introducing superior_part_no_, superior_serial_no_ parameters
--  180309          to identify correct mapping between the component serial part and the top serial part.
--  170920  KEPESE  STRMF-14386 Corrected logic for usage tracing of intersite transactions
--  170901  KEPESE  STRMF-12923 Added methods to track intersite transactions using purchase order and customer order
--  160701  UTSWLK  STRMF-4545, Modified code not to duplicate the same transaction in the table.
--  160429  ManWlk, STRMF-4034, Added methods to generate part usage tracing tree.
--  160428  VISALK  STRMF-4033, Added part origin related methods.
--  160428  ManWlk  STRMF-4032, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Node_Id___ (
   tree_id_ IN NUMBER ) RETURN NUMBER
IS
   node_id_    NUMBER;
   
   CURSOR get_next_node_id IS
      SELECT MAX(node_id)
      FROM INVENTORY_PART_TRACING_TAB
      WHERE tree_id = tree_id_;
BEGIN
   OPEN get_next_node_id;
   FETCH get_next_node_id INTO node_id_;
   CLOSE get_next_node_id;
   
   IF (node_id_ IS NULL) THEN
      node_id_ := 1;
   ELSE
      node_id_ := node_id_ + 1;
   END IF;
   RETURN node_id_;
END Get_Next_Node_Id___;

PROCEDURE Gen_Part_Usage_Child_Nodes___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   transaction_id_        IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   superior_part_no_      IN VARCHAR2,
   superior_serial_no_    IN VARCHAR2,
   source_application_db_ IN VARCHAR2,
   date_time_created_     IN DATE,
   ignore_serial_         IN BOOLEAN DEFAULT FALSE)
IS
   node_id_         NUMBER;
BEGIN
   IF (source_application_db_ = 'SHOP-ORDER') THEN
      Gen_Part_Usage_So___(tree_id_, parent_node_id_, node_level_, contract_, source_ref1_, source_ref2_, source_ref3_, superior_part_no_, superior_serial_no_, source_application_db_, date_time_created_, ignore_serial_);
   ELSIF (source_application_db_ = 'PROD-SCH') THEN
      Gen_Part_Usage_Prosh___(tree_id_, parent_node_id_, node_level_, contract_, part_no_, source_ref1_, source_ref2_, source_ref3_, superior_part_no_, superior_serial_no_, source_application_db_);
   ELSIF (source_application_db_ = 'PUR-ORDER') THEN
      Gen_Part_Usage_Po___(tree_id_, parent_node_id_, node_level_, contract_, part_no_, source_ref1_, source_ref2_, source_ref3_, superior_part_no_, superior_serial_no_, source_application_db_);
   ELSIF (source_application_db_ = 'WDR-CHANGE') THEN
      Gen_Part_Usage_Wdr_Change___(tree_id_, parent_node_id_, node_level_, contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, source_application_db_, date_time_created_);
   ELSIF (source_application_db_ = 'SERIAL') THEN
      Gen_Part_Usage_Ser_Change___(tree_id_, parent_node_id_, node_level_, contract_, transaction_id_, source_application_db_, date_time_created_);
   ELSIF (source_application_db_ = 'MOVE-SITE') THEN
      Gen_Part_Usage_Move_Site___(tree_id_, parent_node_id_, node_level_, transaction_id_, part_no_, serial_no_, lot_batch_no_, source_application_db_, date_time_created_);
   ELSIF (source_application_db_ = 'CUST-ORDER') THEN
      Gen_Part_Usage_Intersite___(tree_id_, parent_node_id_, node_level_, contract_, part_no_, serial_no_, lot_batch_no_, date_time_created_);
   ELSE      
      New(node_id_, tree_id_, parent_node_id_, node_level_, contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, source_application_db_, source_ref1_, 'USAGE', transaction_id_);
   END IF;
END Gen_Part_Usage_Child_Nodes___;

PROCEDURE Gen_Part_Usage_So___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   contract_              IN VARCHAR2,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   superior_part_no_      IN VARCHAR2,
   superior_serial_no_    IN VARCHAR2,
   source_application_db_ IN VARCHAR2,
   date_time_created_     IN DATE,
   ignore_serial_         IN BOOLEAN)
IS
   node_id_                      NUMBER;
   local_node_level_             NUMBER;
   local_superior_serial_no_     VARCHAR2(50);
   local_superior_part_no_       VARCHAR2(25);
   ignore_serial_part_           VARCHAR2(5) := 'FALSE';
   
   $IF Component_Shpord_SYS.INSTALLED $THEN
      CURSOR get_rec IS
         SELECT part_no,
                serial_no,
                lot_batch_no,             
                waiv_dev_rej_no,
                source_ref1,
                source_ref2,
                source_ref3,
                source_application_db,
                min(date_time_created) date_time_created,
                min(transaction_id) transaction_id
           FROM INVENTORY_TRANSACTION_TRACING
          WHERE part_tracing_db IN ('USAGE-TRACING','USAGE-RETURNS')
            AND date_time_created_ < date_time_created
            AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no)
                IN (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                      FROM INVENTORY_TRANSACTION_TRACING ith
                     WHERE part_tracing_db IN ('ORIGIN-TRACING','ORIGIN-RETURNS')
                       AND (serial_no = '*' OR (serial_no != '*' AND serial_no = superior_serial_no_ AND part_no = superior_part_no_) OR ignore_serial_part_ = 'TRUE')
                       AND source_application_db = source_application_db_
                       AND source_ref1 = source_ref1_
                       AND (source_ref2 = source_ref2_ OR source_ref1 IS NULL)
                       AND (source_ref3 = source_ref3_ OR source_ref3 IS NULL)
                       AND (part_no IN (SELECT part_no
                                        FROM  MANUFACTURED_PART
                                        WHERE order_no   = source_ref1_
                                        AND  (release_no = source_ref2_  OR release_no IS NULL)
                                        AND  (sequence_no = source_ref3_ OR sequence_no IS NULL)))
                       AND contract = contract_
                     GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                    HAVING SUM(DECODE(part_tracing_db, 'ORIGIN-TRACING', quantity, 'ORIGIN-RETURNS', -quantity)) > 0)
           GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;
   $END
BEGIN
   IF (ignore_serial_) THEN
      ignore_serial_part_ := 'TRUE';
   END IF;
   $IF Component_Shpord_SYS.INSTALLED $THEN
      local_node_level_ := node_level_ + 1;
      FOR rec_ IN get_rec LOOP 
         New(node_id_, tree_id_, parent_node_id_, local_node_level_, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id);
         IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE') THEN
            local_superior_part_no_ := Part_Serial_Catalog_API.Get_Superior_Part_No(rec_.part_no, superior_serial_no_);
            local_superior_serial_no_ := Part_Serial_Catalog_API.Get_Superior_Serial_No(rec_.part_no, superior_serial_no_);
            Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, local_node_level_, rec_.transaction_id, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, local_superior_part_no_, local_superior_serial_no_, rec_.source_application_db, rec_.date_time_created);
         END IF;
      END LOOP;      
   $ELSE
      NULL;
   $END
END Gen_Part_Usage_So___;

PROCEDURE Gen_Part_Usage_Prosh___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   superior_part_no_      IN VARCHAR2,
   superior_serial_no_    IN VARCHAR2,
   source_application_db_ IN VARCHAR2 )
IS
   node_id_                      NUMBER;
   local_node_level_             NUMBER;
   local_part_no_                VARCHAR2(25);
   local_superior_serial_no_     VARCHAR2(50);
   local_superior_part_no_       VARCHAR2(25);
   
   CURSOR get_rec IS
      SELECT part_no,
             serial_no,
             lot_batch_no,
             waiv_dev_rej_no,
             source_ref1,
             source_ref2,
             source_ref3,
             source_application_db,
             min(date_time_created) date_time_created,
             min(transaction_id) transaction_id
        FROM INVENTORY_TRANSACTION_TRACING
       WHERE part_tracing_db IN ('USAGE-TRACING','USAGE-RETURNS')
         AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no)
             IN (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                   FROM INVENTORY_TRANSACTION_TRACING ith
                  WHERE part_tracing_db IN ('ORIGIN-TRACING','ORIGIN-RETURNS')
                    AND (serial_no = '*' OR (serial_no != '*' AND serial_no = superior_serial_no_ AND part_no = superior_part_no_))
                    AND source_application_db = source_application_db_
                    AND source_ref1 = source_ref1_
                    AND (source_ref2 = source_ref2_ OR source_ref2 IS NULL)
                    AND (source_ref3 = source_ref3_ OR source_ref3 IS NULL)
                    AND part_no != part_no_
                    AND part_no = local_part_no_
                    AND contract = contract_
                  GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                 HAVING SUM(DECODE(part_tracing_db, 'ORIGIN-TRACING', quantity, 'ORIGIN-RETURNS', -quantity)) > 0)
         GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;
BEGIN
   $IF Component_Prosch_SYS.INSTALLED $THEN
      local_node_level_ := node_level_ + 1;
      local_part_no_ := Production_Receipt_API.Get_Part_No(source_ref1_);
      
      FOR rec_ IN get_rec LOOP         
         New(node_id_, tree_id_, parent_node_id_, local_node_level_, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id); 
         IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE') THEN
            local_superior_part_no_ := Part_Serial_Catalog_API.Get_Superior_Part_No(rec_.part_no, superior_serial_no_);
            local_superior_serial_no_ := Part_Serial_Catalog_API.Get_Superior_Serial_No(rec_.part_no, superior_serial_no_);
            Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, local_node_level_, rec_.transaction_id, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, local_superior_part_no_, local_superior_serial_no_, rec_.source_application_db, rec_.date_time_created);
         END IF;
      END LOOP;      
   $ELSE
      NULL;
   $END
END Gen_Part_Usage_Prosh___;

PROCEDURE Gen_Part_Usage_Po___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   source_ref1_           IN VARCHAR2,
   source_ref2_           IN VARCHAR2,
   source_ref3_           IN VARCHAR2,
   superior_part_no_      IN VARCHAR2,
   superior_serial_no_    IN VARCHAR2,
   source_application_db_ IN VARCHAR2)
IS
   node_id_                      NUMBER;
   local_node_level_             NUMBER;
   local_superior_serial_no_     VARCHAR2(50);
   local_superior_part_no_       VARCHAR2(25);
   
   $IF Component_Purch_SYS.INSTALLED $THEN
      CURSOR get_rec IS
         SELECT part_no,
                serial_no,
                lot_batch_no,
                waiv_dev_rej_no,
                source_ref1,
                source_ref2,
                source_ref3,
                source_application_db,
                min(date_time_created) date_time_created,
                min(transaction_id) transaction_id
           FROM INVENTORY_TRANSACTION_TRACING
          WHERE part_tracing_db IN ('USAGE-TRACING','USAGE-RETURNS')
            AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no)
                IN (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                      FROM INVENTORY_TRANSACTION_TRACING ith
                     WHERE part_tracing_db IN('ORIGIN-TRACING','ORIGIN-RETURNS')
                       AND (serial_no = '*' OR (serial_no != '*' AND serial_no = superior_serial_no_ AND part_no = superior_part_no_))
                       AND source_application_db = source_application_db_
                       AND source_ref1 = source_ref1_
                       AND (source_ref2 = source_ref2_ OR source_ref2 IS NULL)
                       AND (source_ref3 = source_ref3_ OR source_ref3 IS NULL)
                       AND part_no != part_no_
                       AND part_no = Purchase_Order_Line_Part_API.Get_Part_No(source_ref1_, source_ref2, source_ref3)
                       AND contract = contract_
                       GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                       HAVING SUM(DECODE(part_tracing_db, 'ORIGIN-TRACING', quantity, 'ORIGIN-RETURNS', -quantity)) > 0)
            GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;           
   $END
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      local_node_level_ := node_level_ + 1;
      
      FOR rec_ IN get_rec LOOP         
         New(node_id_, tree_id_, parent_node_id_, local_node_level_, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id);
         IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE') THEN
            local_superior_part_no_ := Part_Serial_Catalog_API.Get_Superior_Part_No(rec_.part_no, superior_serial_no_);
            local_superior_serial_no_ := Part_Serial_Catalog_API.Get_Superior_Serial_No(rec_.part_no, superior_serial_no_);
            Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, local_node_level_, rec_.transaction_id, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, local_superior_part_no_, local_superior_serial_no_, rec_.source_application_db, rec_.date_time_created);
         END IF;         
      END LOOP;      
   $ELSE
      NULL;
   $END
END Gen_Part_Usage_Po___;

PROCEDURE Gen_Part_Usage_Intersite___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,   
   parent_date_           IN DATE)
IS
   node_id_                      NUMBER;
   local_node_level_             NUMBER;
   
   $IF Component_Order_SYS.INSTALLED $THEN
      CURSOR get_arrivals IS
        SELECT source_application_db,
               source_ref1,
               source_ref2,
               source_ref3,
               max(date_time_created) date_time_created,
               max(transaction_id) transaction_id,
               contract,
               part_no,
               lot_batch_no,
               serial_no,
               waiv_dev_rej_no
          FROM INVENTORY_TRANSACTION_TRACING
         WHERE (source_application_db != 'INT-MOVE' OR
               (source_application_db = 'INT-MOVE' AND
               Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
           AND (parent_date_ < date_time_created) 
           AND part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
           AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN
               (SELECT ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                  FROM INVENTORY_TRANSACTION_TRACING ith, CUSTOMER_ORDER_LINE col
                 WHERE ith.part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
                   AND ith.source_ref1 = col.demand_order_ref1
                   AND ith.transaction_code IN ('ARRTRAN', 'ARRIVAL')            
                   AND ith.part_no = part_no_
                   AND ith.serial_no = serial_no_
                   AND ith.lot_batch_no = lot_batch_no_
                   AND ith.contract != contract_  
              GROUP BY ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                HAVING SUM(DECODE(part_tracing_db, 'ORIGIN-TRACING', quantity, 'ORIGIN-RETURNS', -quantity)) > 0)
              GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no, condition_code;                   
   $END
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      local_node_level_ := node_level_ + 1;
      FOR rec_ IN get_arrivals LOOP
         New(node_id_, tree_id_, parent_node_id_, local_node_level_, rec_.contract, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id);
         IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE', 'CUST-ORDER') THEN
            Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, local_node_level_, rec_.transaction_id, rec_.contract, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, NULL, NULL, rec_.source_application_db, rec_.date_time_created);
         END IF;         
      END LOOP;      
   $ELSE
      NULL;
   $END
END Gen_Part_Usage_Intersite___;

PROCEDURE Gen_Part_Usage_Wdr_Change___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   waiv_dev_rej_no_       IN VARCHAR2,
   source_application_db_ IN VARCHAR2,
   date_time_created_     IN DATE)
IS
   node_id_                      NUMBER;
   local_node_level_             NUMBER;
   
   CURSOR get_rec IS
      SELECT part_no,
             serial_no,
             lot_batch_no,
             waiv_dev_rej_no,
             source_ref1,
             source_ref2,
             source_ref3,
             source_application_db,
             min(date_time_created) date_time_created,
             min(transaction_id) transaction_id
        FROM INVENTORY_TRANSACTION_TRACING
       WHERE waiv_dev_rej_no != waiv_dev_rej_no_
         AND date_time_created_ < date_time_created
         AND part_tracing_db IN ('USAGE-TRACING','USAGE-RETURNS')
         AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no)
             IN (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                   FROM INVENTORY_TRANSACTION_TRACING ith
                  WHERE part_tracing_db IN ('ORIGIN-TRACING','ORIGIN-RETURNS')
                    AND source_application_db = source_application_db_
                    AND source_ref1 IS NULL
                    AND source_ref2 IS NULL
                    AND source_ref3 IS NULL
                    AND ith.lot_batch_no = lot_batch_no_
                    AND ith.serial_no = serial_no_
                    AND ith.part_no = part_no_
                    AND contract = contract_
                  GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                 HAVING SUM(DECODE(part_tracing_db, 'ORIGIN-TRACING', quantity, 'ORIGIN-RETURNS', -quantity)) > 0)
        GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;
BEGIN
   local_node_level_ := node_level_ + 1;   
   FOR rec_ IN get_rec LOOP      
      New(node_id_, tree_id_, parent_node_id_, local_node_level_, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id);
      IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE') THEN
         Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, local_node_level_, rec_.transaction_id, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, NULL, NULL, rec_.source_application_db, rec_.date_time_created);
      END IF;
   END LOOP;   
END Gen_Part_Usage_Wdr_Change___;

PROCEDURE Gen_Part_Usage_Ser_Change___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   transaction_id_        IN NUMBER,
   contract_              IN VARCHAR2,
   source_application_db_ IN VARCHAR2,
   date_time_created_     IN DATE )
IS
   node_id_                      NUMBER;
   local_node_level_             NUMBER;
   connected_transaction_id_     NUMBER;
   
   CURSOR get_rec IS
      SELECT part_no,
             serial_no,
             lot_batch_no,
             waiv_dev_rej_no,
             source_ref1,
             source_ref2,
             source_ref3,
             source_application_db,
             min(date_time_created) date_time_created,
             min(transaction_id) transaction_id
        FROM INVENTORY_TRANSACTION_TRACING
       WHERE date_time_created_ < date_time_created
         AND part_tracing_db IN ('USAGE-TRACING','USAGE-RETURNS')
         AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no)
             IN (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                   FROM INVENTORY_TRANSACTION_TRACING ith
                  WHERE part_tracing_db IN ('ORIGIN-TRACING','ORIGIN-RETURNS')
                    AND source_application_db = source_application_db_
                    AND source_ref1 IS NULL
                    AND source_ref2 IS NULL
                    AND source_ref3 IS NULL
                    AND ith.transaction_id = connected_transaction_id_
                    AND contract = contract_
                  GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                 HAVING SUM(DECODE(part_tracing_db, 'ORIGIN-TRACING', quantity, 'ORIGIN-RETURNS', -quantity)) > 0)
       GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;
BEGIN
   local_node_level_ := node_level_ + 1;
   connected_transaction_id_ := Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(transaction_id_, 'RENAME SERIAL');
   
   FOR rec_ IN get_rec LOOP      
      New(node_id_, tree_id_, parent_node_id_, local_node_level_, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id);
      IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE') THEN
         Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, local_node_level_, rec_.transaction_id, contract_, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, NULL, NULL, rec_.source_application_db, rec_.date_time_created);
      END IF;
   END LOOP;
END Gen_Part_Usage_Ser_Change___;

PROCEDURE Gen_Part_Usage_Move_Site___ (
   tree_id_               IN NUMBER,
   parent_node_id_        IN NUMBER,
   node_level_            IN NUMBER,
   transaction_id_        IN NUMBER,
   part_no_               IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   lot_batch_no_          IN VARCHAR2,
   source_application_db_ IN VARCHAR2,
   date_time_created_     IN DATE)
IS
   node_id_                      NUMBER;
   local_node_level_             NUMBER;
   local_superior_serial_no_     VARCHAR2(50);
   local_superior_part_no_       VARCHAR2(25);
   
   CURSOR get_rec IS
      SELECT contract,
             part_no,
             serial_no,
             lot_batch_no,
             waiv_dev_rej_no,
             source_ref1,
             source_ref2,
             source_ref3,
             source_application_db,
             min(date_time_created) date_time_created,
             min(transaction_id) transaction_id
        FROM INVENTORY_TRANSACTION_TRACING
       WHERE date_time_created_ < date_time_created
         AND part_tracing_db IN ('USAGE-TRACING','USAGE-RETURNS')
         AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no)
             IN (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                   FROM INVENTORY_TRANSACTION_TRACING ith
                  WHERE part_tracing_db IN ('ORIGIN-TRACING','ORIGIN-RETURNS')
                    AND source_application_db = source_application_db_
                    AND source_ref1 IS NULL
                    AND source_ref2 IS NULL
                    AND source_ref3 IS NULL
                    AND ith.lot_batch_no = lot_batch_no_
                    AND ith.serial_no = serial_no_
                    AND ith.part_no = part_no_
                    AND ith.transaction_id = Invent_Trans_Interconnect_Api.Get_Connected_Transaction_Id(transaction_id_, 'INTERSITE TRANSFER') 
                  GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                 HAVING SUM(DECODE(part_tracing_db, 'ORIGIN-TRACING', quantity, 'ORIGIN-RETURNS', -quantity)) > 0)
       GROUP BY contract, source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;
BEGIN
   local_node_level_ := node_level_ + 1;
   
   FOR rec_ IN get_rec LOOP      
      New(node_id_, tree_id_, parent_node_id_, local_node_level_, rec_.contract, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id); 
      IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE') THEN
         local_superior_part_no_ := Part_Serial_Catalog_API.Get_Superior_Part_No(rec_.part_no, rec_.serial_no);
         local_superior_serial_no_ := Part_Serial_Catalog_API.Get_Superior_Serial_No(rec_.part_no, rec_.serial_no);
         Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, local_node_level_, rec_.transaction_id, rec_.contract, rec_.part_no, rec_.serial_no, rec_.lot_batch_no, rec_.waiv_dev_rej_no, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, local_superior_part_no_, local_superior_serial_no_, rec_.source_application_db, rec_.date_time_created);
      END IF;
   END LOOP;   
END Gen_Part_Usage_Move_Site___;  

PROCEDURE Gen_Part_Origin_Child_Nodes___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER,   
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   source_application_db_  IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   date_time_created_      IN DATE,   
   transaction_id_         IN VARCHAR2,
   level_                  IN NUMBER)
IS
   node_id_          NUMBER;
BEGIN   
   IF (source_application_db_ = 'SHOP-ORDER') THEN
      Gen_Part_Origin_So___(tree_id_, parent_node_id_, contract_, part_no_, serial_no_, source_ref1_, source_ref2_, source_ref3_, date_time_created_, level_);
   ELSIF (source_application_db_ = 'PROD-SCH') THEN
      Gen_Part_Origin_Prosh___(tree_id_, parent_node_id_, contract_, part_no_, serial_no_, source_ref1_, source_ref2_, source_ref3_, level_);
   ELSIF (source_application_db_ = 'PUR-ORDER')THEN
      Gen_Part_Origin_Po___(tree_id_, parent_node_id_, contract_, part_no_, serial_no_, source_ref1_, source_ref2_, source_ref3_, level_);
      Gen_Part_Origin_Intersite___(tree_id_, parent_node_id_, contract_, part_no_, serial_no_, lot_batch_no_, source_ref1_, date_time_created_, level_);
      Gen_Part_Origin_Co___(tree_id_, parent_node_id_, contract_, part_no_, serial_no_, source_ref1_, level_);
   ELSIF (source_application_db_ = 'WDR-CHANGE')THEN
      Gen_Part_Origin_Wdr_Change___(tree_id_, parent_node_id_, contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, date_time_created_, level_);
   ELSIF (source_application_db_ = 'SERIAL') THEN
      Gen_Part_Origin_Ser_Change___(tree_id_, parent_node_id_, contract_, date_time_created_, transaction_id_ , level_);
   ELSIF (source_application_db_ = 'MOVE-SITE') THEN
      Gen_Part_Origin_Move_Site___(tree_id_, parent_node_id_, part_no_, serial_no_, lot_batch_no_, source_application_db_, date_time_created_, transaction_id_, level_);
   ELSE            
      New(node_id_, tree_id_, parent_node_id_, level_, contract_, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_,  source_application_db_, source_ref1_, 'ORIGIN', transaction_id_);
   END IF;
END Gen_Part_Origin_Child_Nodes___;

PROCEDURE Gen_Part_Origin_So___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER, 
   contract_               IN VARCHAR2,
   superior_part_no_       IN VARCHAR2,
   superior_serial_no_     IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   date_time_created_      IN DATE,
   level_                  IN NUMBER )
IS
   node_id_         NUMBER;
   
   CURSOR get_shop_order_details IS
      SELECT source_application_db,
             source_ref1,
             source_ref2,
             source_ref3,
             max(date_time_created) date_time_created,
             max(transaction_id)    transaction_id,
             part_no,
             lot_batch_no,
             serial_no,
             waiv_dev_rej_no
      FROM   INVENTORY_TRANSACTION_TRACING
      WHERE  (source_application_db != 'INT-MOVE' OR
             (source_application_db = 'INT-MOVE' AND
             Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
      AND    part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
      AND    (date_time_created_ > date_time_created)
      AND    (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN
                (SELECT ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                   FROM INVENTORY_TRANSACTION_TRACING ith
                   WHERE ((ith.serial_no = '*') OR
                         (ith.serial_no != '*' AND 
                         EXISTS (
                           SELECT 1
                           FROM PART_SERIAL_CATALOG_PUB psc
                           WHERE psc.part_no = ith.part_no
                           AND psc.serial_no = ith.serial_no
                           AND psc.superior_part_no = superior_part_no_
                           AND psc.superior_serial_no = superior_serial_no_)))
                    AND part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
                    AND source_application_db = 'SHOP-ORDER'
                    AND source_ref1 = source_ref1_
                    AND (source_ref2 = source_ref2_ OR source_ref2 IS NULL)
                    AND (source_ref3 = source_ref3_ OR source_ref3 IS NULL)
                    AND contract = contract_
                    GROUP BY ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                    HAVING SUM(DECODE(part_tracing_db, 'USAGE-TRACING', quantity, 'USAGE-RETURNS', -quantity)) > 0)
      GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;

   tree_level_ NUMBER;
BEGIN
   tree_level_ := level_ + 1; 
   FOR child_rec_ IN get_shop_order_details LOOP       
      New(node_id_, tree_id_, parent_node_id_, tree_level_, contract_, child_rec_.part_no, child_rec_.serial_no, child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no,  child_rec_.source_application_db, child_rec_.source_ref1, 'ORIGIN', child_rec_.transaction_id);
      IF (child_rec_.source_application_db IN ('SHOP-ORDER' ,'PROD-SCH' ,'PUR-ORDER' , 'WDR-CHANGE' , 'SERIAL' ,'MOVE-SITE')) THEN           
         Gen_Part_Origin_Child_Nodes___(tree_id_,  node_id_, contract_, child_rec_.part_no,child_rec_.serial_no,  child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no, child_rec_.source_application_db, child_rec_.source_ref1, child_rec_.source_ref2, child_rec_.source_ref3, child_rec_.date_time_created,  child_rec_.transaction_id, tree_level_ );
      END IF;
   END LOOP;   
END Gen_Part_Origin_So___;

PROCEDURE Gen_Part_Origin_Prosh___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER, 
   contract_               IN VARCHAR2,
   superior_part_no_       IN VARCHAR2,
   superior_serial_no_     IN VARCHAR2,            
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,   
   level_                  IN NUMBER )
IS
   node_id_                      NUMBER;   
   
   CURSOR get_prod_sch_details IS
      SELECT source_application_db,
             source_ref1,
             source_ref2,
             source_ref3,
             max(date_time_created) date_time_created,
             max(transaction_id)    transaction_id,
             part_no,
             lot_batch_no,
             serial_no,
             waiv_dev_rej_no
      FROM   INVENTORY_TRANSACTION_TRACING
      WHERE  (source_application_db != 'INT-MOVE' OR
             (source_application_db = 'INT-MOVE' AND
             Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
      AND   part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
      AND   (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN
               (SELECT ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                  FROM INVENTORY_TRANSACTION_TRACING ith
                  WHERE ((ith.serial_no = '*') OR
                        (ith.serial_no != '*' AND
                        EXISTS ( SELECT 1
                                 FROM PART_SERIAL_CATALOG_PUB psc
                                 WHERE psc.part_no = ith.part_no
                                 AND psc.serial_no = ith.serial_no
                                 AND psc.superior_part_no = superior_part_no_
                                 AND psc.superior_serial_no = superior_serial_no_)))
                   AND part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
                   AND source_application_db = 'PROD-SCH'
                   AND source_ref1  = source_ref1_
                   AND (source_ref2 = source_ref2_ OR source_ref2 IS NULL)
                   AND (source_ref3 = source_ref3_ OR source_ref3 IS NULL)
                   AND contract = contract_
                   GROUP BY ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                   HAVING SUM(DECODE(part_tracing_db, 'USAGE-TRACING', quantity, 'USAGE-RETURNS', -quantity)) > 0)
      GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;
            
   tree_level_ NUMBER;
BEGIN
   tree_level_ := level_ + 1;
   FOR child_rec_ IN get_prod_sch_details LOOP      
      New(node_id_, tree_id_, parent_node_id_, tree_level_, contract_, child_rec_.part_no, child_rec_.serial_no, child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no,  child_rec_.source_application_db, child_rec_.source_ref1, 'ORIGIN', child_rec_.transaction_id); 
      IF (child_rec_.source_application_db IN ('SHOP-ORDER' ,'PROD-SCH' ,'PUR-ORDER' , 'WDR-CHANGE' , 'SERIAL' ,'MOVE-SITE'))THEN           
         Gen_Part_Origin_Child_Nodes___(tree_id_, node_id_, contract_, child_rec_.part_no,child_rec_.serial_no,  child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no, child_rec_.source_application_db, child_rec_.source_ref1, child_rec_.source_ref2, child_rec_.source_ref3, child_rec_.date_time_created,  child_rec_.transaction_id, tree_level_ );
      END IF;
   END LOOP;   
END Gen_Part_Origin_Prosh___;

PROCEDURE Gen_Part_Origin_Po___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER,    
   contract_               IN VARCHAR2,
   superior_part_no_       IN VARCHAR2,
   superior_serial_no_     IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,   
   level_                  IN NUMBER )
IS
BEGIN
   Gen_Part_Origin___(tree_id_, parent_node_id_, contract_, superior_part_no_, superior_serial_no_, source_ref1_, source_ref2_, source_ref3_, level_, 'PUR-ORDER');
END Gen_Part_Origin_Po___;

PROCEDURE Gen_Part_Origin_Co___ (
   tree_id_            IN NUMBER,
   parent_node_id_     IN NUMBER,    
   contract_           IN VARCHAR2,
   superior_part_no_   IN VARCHAR2,
   superior_serial_no_ IN VARCHAR2,
   source_ref1_        IN VARCHAR2,  
   level_              IN NUMBER )
IS
   order_no_     VARCHAR2(12);
   line_no_      VARCHAR2(4);
   rel_no_       VARCHAR2(4);
   tree_level_   NUMBER;
   
   $IF Component_Order_SYS.INSTALLED $THEN
      CURSOR get_order_details IS
      SELECT order_no, line_no, rel_no
      FROM CUSTOMER_ORDER_JOIN 
      WHERE demand_order_ref1 = source_ref1_
      AND charged_item_db = 'CHARGED ITEM';
   $END
   
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      FOR rec_ IN get_order_details LOOP
         tree_level_ := level_ + 1;
         order_no_ := rec_.order_no;
         line_no_  := rec_.line_no;
         rel_no_   := rec_.rel_no;
         Gen_Part_Origin___(tree_id_, parent_node_id_, contract_, superior_part_no_, superior_serial_no_, order_no_, line_no_, rel_no_, level_, 'CUST-ORDER');
      END LOOP;
   $ELSE
      NULL;   
   $END 
END Gen_Part_Origin_Co___;

PROCEDURE Gen_Part_Origin___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER,    
   contract_               IN VARCHAR2,
   superior_part_no_       IN VARCHAR2,
   superior_serial_no_     IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,   
   level_                  IN NUMBER,
   source_application_db_  IN VARCHAR2 )
IS
   node_id_         NUMBER;
  
   CURSOR get_purch_ord_details IS
      SELECT source_application_db,
             source_ref1,
             source_ref2,
             source_ref3,
             max(date_time_created) date_time_created,
             max(transaction_id)    transaction_id,
             part_no,
             lot_batch_no,
             serial_no,
             waiv_dev_rej_no
      FROM   INVENTORY_TRANSACTION_TRACING
      WHERE  (source_application_db != 'INT-MOVE' OR
             (source_application_db = 'INT-MOVE' AND
             Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
      AND    part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
      AND    (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN
             (SELECT ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
              FROM INVENTORY_TRANSACTION_TRACING ith
              WHERE ((ith.serial_no = '*') OR
                     (ith.serial_no != '*' AND 
                     EXISTS ( SELECT 1
                              FROM PART_SERIAL_CATALOG_PUB psc
                              WHERE psc.part_no = ith.part_no
                              AND psc.serial_no = ith.serial_no
                              AND psc.superior_part_no = superior_part_no_
                              AND psc.superior_serial_no = superior_serial_no_)))
              AND part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
              AND   source_application_db = source_application_db_
              AND   source_ref1 = source_ref1_
              AND   (source_ref2 = source_ref2_ OR source_ref2 IS NULL)
              AND   (source_ref3 = source_ref3_ OR source_ref3 IS NULL)
              AND   contract = contract_
              GROUP BY ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
              HAVING SUM(DECODE(part_tracing_db, 'USAGE-TRACING', quantity, 'USAGE-RETURNS', -quantity)) > 0)
      GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no, condition_code;

   tree_level_ NUMBER;
BEGIN
   tree_level_ := level_ + 1;
   FOR child_rec_ IN get_purch_ord_details LOOP            
      New(node_id_, tree_id_, parent_node_id_,tree_level_, contract_, child_rec_.part_no, child_rec_.serial_no, child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no,  child_rec_.source_application_db, child_rec_.source_ref1, 'ORIGIN', child_rec_.transaction_id); 
      IF (child_rec_.source_application_db IN ('SHOP-ORDER' ,'PROD-SCH' ,'PUR-ORDER' , 'WDR-CHANGE' , 'SERIAL' ,'MOVE-SITE' ,'CUST-ORDER'))THEN           
         Gen_Part_Origin_Child_Nodes___(tree_id_, node_id_, contract_, child_rec_.part_no, child_rec_.serial_no,  child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no, child_rec_.source_application_db, child_rec_.source_ref1, child_rec_.source_ref2, child_rec_.source_ref3, child_rec_.date_time_created,  child_rec_.transaction_id, tree_level_ );
      END IF;
   END LOOP;   
END Gen_Part_Origin___;

PROCEDURE Gen_Part_Origin_Intersite___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER,    
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,   
   source_ref1_            IN VARCHAR2,
   parent_date_            IN DATE,
   level_                  IN NUMBER )
IS
   node_id_         NUMBER;
   tree_level_      NUMBER;
   $IF Component_Order_SYS.INSTALLED $THEN
      CURSOR get_shipping_details IS
         SELECT source_application_db,
                source_ref1,
                source_ref2,
                source_ref3,
                max(date_time_created) date_time_created,
                max(transaction_id)    transaction_id,
                contract, 
                part_no,
                lot_batch_no,
                serial_no,
                waiv_dev_rej_no
         FROM   INVENTORY_TRANSACTION_TRACING
         WHERE  (source_application_db != 'INT-MOVE' OR
                (source_application_db = 'INT-MOVE' AND
                Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
         AND    part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
         AND    (parent_date_ > date_time_created) 
         AND    (part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN 
                (SELECT ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                 FROM INVENTORY_TRANSACTION_TRACING ith, CUSTOMER_ORDER_LINE col
                 WHERE ith.part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
                 AND ith.transaction_code IN ('SHIPDIR', 'SHIPTRAN', 'OESHIP') 
                 AND ith.part_no = part_no_
                 AND ith.serial_no = serial_no_
                 AND ith.lot_batch_no = lot_batch_no_ 
                 AND ith.source_ref1 = col.order_no
                 AND ith.source_ref2 = col.line_no
                 AND ith.source_ref3 = col.rel_no
                 AND ith.source_ref4 = col.line_item_no
                 AND col.demand_order_ref1 = source_ref1_
                 AND ith.contract != contract_ 
                 GROUP BY ith.contract, ith.part_no, ith.lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
                 HAVING SUM(DECODE(part_tracing_db, 'USAGE-TRACING', quantity, 'USAGE-RETURNS', -quantity)) > 0)
         GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no, condition_code;
   $END
BEGIN
   $IF Component_Order_SYS.INSTALLED $THEN
      tree_level_ := level_ + 1;
      FOR child_rec_ IN get_shipping_details LOOP            
         New(node_id_, tree_id_, parent_node_id_,tree_level_, child_rec_.contract, child_rec_.part_no, child_rec_.serial_no, child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no,  child_rec_.source_application_db, child_rec_.source_ref1, 'ORIGIN', child_rec_.transaction_id); 
         IF (child_rec_.source_application_db IN ('SHOP-ORDER' ,'PROD-SCH' ,'PUR-ORDER' , 'WDR-CHANGE' , 'SERIAL' ,'MOVE-SITE'))THEN           
            Gen_Part_Origin_Child_Nodes___(tree_id_, node_id_, child_rec_.contract, child_rec_.part_no, child_rec_.serial_no,  child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no, child_rec_.source_application_db, child_rec_.source_ref1, child_rec_.source_ref2, child_rec_.source_ref3, child_rec_.date_time_created,  child_rec_.transaction_id, tree_level_ );
         END IF;
      END LOOP;   
   $ELSE
      NULL;
   $END   
END Gen_Part_Origin_Intersite___;

PROCEDURE Gen_Part_Origin_Wdr_Change___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER, 
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,   
   date_time_created_      IN DATE,
   level_                  IN NUMBER )
IS
   node_id_          NUMBER;   
   CURSOR get_wdr_change_details IS
      SELECT source_application_db,
             source_ref1,
             source_ref2,
             source_ref3,
             max(date_time_created)  date_time_created,
             max(transaction_id)     transaction_id,
             part_no,
             lot_batch_no,
             serial_no,
             waiv_dev_rej_no
      FROM INVENTORY_TRANSACTION_TRACING
      WHERE waiv_dev_rej_no != waiv_dev_rej_no_
      AND (date_time_created_ > date_time_created)
      AND (source_application_db != 'INT-MOVE' OR
          (source_application_db = 'INT-MOVE' AND
          Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
      AND part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
      AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN
          (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
             FROM INVENTORY_TRANSACTION_TRACING ith
             WHERE part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
             AND   source_application_db = 'WDR-CHANGE'
             AND   (source_ref1 IS NULL)
             AND   (source_ref2 IS NULL)
             AND   (source_ref3 IS NULL)
             AND   ith.lot_batch_no = lot_batch_no_
             AND   ith.serial_no = serial_no_
             AND   ith.part_no = part_no_
             AND   contract = contract_
             GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
             HAVING SUM(DECODE(part_tracing_db, 'USAGE-TRACING', quantity, 'USAGE-RETURNS', -quantity)) > 0)
      GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;

   tree_level_ NUMBER;
BEGIN   
   tree_level_ := level_ + 1;
   FOR child_rec_ IN get_wdr_change_details LOOP            
      New(node_id_, tree_id_, parent_node_id_,tree_level_, contract_, child_rec_.part_no, child_rec_.serial_no, child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no,  child_rec_.source_application_db, child_rec_.source_ref1, 'ORIGIN', child_rec_.transaction_id);
      IF (child_rec_.source_application_db IN ('SHOP-ORDER' ,'PROD-SCH' ,'PUR-ORDER' , 'WDR-CHANGE' , 'SERIAL' ,'MOVE-SITE')) THEN           
         Gen_Part_Origin_Child_Nodes___(tree_id_, node_id_, contract_, child_rec_.part_no, child_rec_.serial_no,  child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no, child_rec_.source_application_db, child_rec_.source_ref1, child_rec_.source_ref2, child_rec_.source_ref3, child_rec_.date_time_created,  child_rec_.transaction_id, tree_level_ );
      END IF;
   END LOOP;
END Gen_Part_Origin_Wdr_Change___;

PROCEDURE Gen_Part_Origin_Ser_Change___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER, 
   contract_               IN VARCHAR2,   
   date_time_created_      IN DATE,               
   transaction_id_         IN NUMBER,
   level_                  IN NUMBER )
IS
   node_id_          NUMBER;   
   CURSOR get_serial_change_details IS
      SELECT source_application_db,
             source_ref1,
             source_ref2,
             source_ref3,
             max(date_time_created) date_time_created,
             max(transaction_id)    transaction_id,
             part_no,
             lot_batch_no,
             serial_no,
             waiv_dev_rej_no
      FROM  INVENTORY_TRANSACTION_TRACING
      WHERE (date_time_created_ > date_time_created)
      AND   (source_application_db != 'INT-MOVE' OR
            (source_application_db = 'INT-MOVE' AND
            Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
      AND   part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
      AND   (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN
            (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
             FROM INVENTORY_TRANSACTION_TRACING ith
             WHERE part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
             AND source_application_db = 'SERIAL'
             AND (source_ref1 IS NULL)
             AND (source_ref2 IS NULL)
             AND (source_ref3 IS NULL)
             AND ith.transaction_id = Invent_Trans_Interconnect_API.Get_Connected_Transaction_Id(transaction_id_, 'RENAME SERIAL')
             AND contract = contract_
             GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
             HAVING SUM(DECODE(part_tracing_db, 'USAGE-TRACING', quantity, 'USAGE-RETURNS', -quantity)) > 0)
      GROUP BY source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;

   tree_level_ NUMBER;
BEGIN  
   tree_level_ := level_ + 1;
   FOR child_rec_ IN get_serial_change_details LOOP           
      New(node_id_, tree_id_, parent_node_id_, tree_level_, contract_, child_rec_.part_no, child_rec_.serial_no, child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no,  child_rec_.source_application_db, child_rec_.source_ref1, 'ORIGIN', child_rec_.transaction_id); 
      IF (child_rec_.source_application_db IN ('SHOP-ORDER' ,'PROD-SCH' ,'PUR-ORDER' , 'WDR-CHANGE' , 'SERIAL' ,'MOVE-SITE')) THEN           
         Gen_Part_Origin_Child_Nodes___(tree_id_, node_id_, contract_, child_rec_.part_no, child_rec_.serial_no,  child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no, child_rec_.source_application_db, child_rec_.source_ref1, child_rec_.source_ref2, child_rec_.source_ref3, child_rec_.date_time_created,  child_rec_.transaction_id, tree_level_ );
      END IF;
   END LOOP;
END Gen_Part_Origin_Ser_Change___;

PROCEDURE Gen_Part_Origin_Move_Site___ (
   tree_id_                IN NUMBER,
   parent_node_id_         IN NUMBER,    
   part_no_                IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,   
   source_application_db_  IN VARCHAR2,   
   date_time_created_      IN DATE,
   transaction_id_         IN NUMBER,
   level_                  IN NUMBER)
IS
   node_id_          NUMBER;
   CURSOR get_move_site_details IS
      SELECT contract,             
             source_application_db,
             source_ref1,
             source_ref2,
             source_ref3,
             max(date_time_created)   date_time_created,
             max(transaction_id)      transaction_id,
             part_no,
             lot_batch_no,
             serial_no,
             waiv_dev_rej_no
      FROM  INVENTORY_TRANSACTION_TRACING
      WHERE (date_time_created_ > date_time_created)
      AND   (source_application_db != 'INT-MOVE' OR
            (source_application_db = 'INT-MOVE' AND 
            Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract, part_no, location_no, lot_batch_no, serial_no, waiv_dev_rej_no, source_ref1, source_ref2, source_ref3, source_ref4) = 'LOT-BATCH-MOVE'))
      AND part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
      AND (contract, part_no, lot_batch_no, serial_no, waiv_dev_rej_no) IN
          (SELECT contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
           FROM INVENTORY_TRANSACTION_TRACING ith
           WHERE part_tracing_db IN ('USAGE-TRACING', 'USAGE-RETURNS')
           AND source_application_db = source_application_db_
           AND (source_ref1 IS NULL)
           AND (source_ref2 IS NULL)
           AND (source_ref3 IS NULL)
           AND ith.lot_batch_no = lot_batch_no_
           AND ith.serial_no = serial_no_
           AND ith.part_no = part_no_
           AND ith.transaction_id = Invent_Trans_Interconnect_Api.Get_Connected_Transaction_Id(transaction_id_, 'INTERSITE TRANSFER')
           GROUP BY contract, part_no, lot_batch_no, ith.serial_no, ith.waiv_dev_rej_no
           HAVING SUM(DECODE(part_tracing_db, 'USAGE-TRACING', quantity, 'USAGE-RETURNS', -quantity)) > 0)
      GROUP BY contract, source_application_db, source_ref1, source_ref2, source_ref3, part_no, lot_batch_no, serial_no, waiv_dev_rej_no;
   tree_level_ NUMBER;            
BEGIN
   tree_level_ := level_ + 1;
   FOR child_rec_ IN get_move_site_details LOOP
      New(node_id_, tree_id_, parent_node_id_, tree_level_, child_rec_.contract, child_rec_.part_no, child_rec_.serial_no, child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no,  child_rec_.source_application_db, child_rec_.source_ref1, 'ORIGIN', child_rec_.transaction_id);
      IF (child_rec_.source_application_db IN ('SHOP-ORDER' ,'PROD-SCH' ,'PUR-ORDER' , 'WDR-CHANGE' , 'SERIAL' ,'MOVE-SITE')) THEN           
         Gen_Part_Origin_Child_Nodes___(tree_id_, node_id_, child_rec_.contract, child_rec_.part_no, child_rec_.serial_no,  child_rec_.lot_batch_no, child_rec_.waiv_dev_rej_no, child_rec_.source_application_db, child_rec_.source_ref1, child_rec_.source_ref2, child_rec_.source_ref3, child_rec_.date_time_created,  child_rec_.transaction_id, tree_level_ );
      END IF; 
   END LOOP;   
END Gen_Part_Origin_Move_Site___;

PROCEDURE Delete_Old_Records___
IS
BEGIN
   DELETE FROM INVENTORY_PART_TRACING_TAB
      WHERE TRUNC(rowversion) < TRUNC(SYSDATE)-1;
END Delete_Old_Records___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Delete_Tree__ (
   tree_id_ IN NUMBER )
IS
BEGIN
   DELETE FROM INVENTORY_PART_TRACING_TAB
      WHERE tree_id = tree_id_;
END Delete_Tree__;

PROCEDURE Gen_Part_Usage_Tree__ (
   tree_id_          IN OUT NUMBER,
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   contract_         IN VARCHAR2)
IS
   node_id_                NUMBER;
   node_level_             NUMBER := 1;
   superior_serial_no_     VARCHAR2(50);
   superior_part_no_       VARCHAR2(25);
   
   CURSOR get_rec IS
      SELECT contract,
             source_application_db,
             source_ref1,
             source_ref2,
             DECODE(source_application_db, 'CUST-ORDER', NULL, source_ref3) source_ref3,
             min(date_time_created) date_time_created,
             min(transaction_id) transaction_id
        FROM INVENTORY_TRANSACTION_TRACING
       WHERE part_tracing_db IN ('USAGE-TRACING','USAGE-RETURNS')
         AND part_no = part_no_
         AND serial_no = NVL(serial_no_, '*')
         AND lot_batch_no = NVL(lot_batch_no_, '*')
         AND waiv_dev_rej_no = NVL(waiv_dev_rej_no_, '*')
         AND contract        = contract_
       GROUP BY contract, source_application_db, source_ref1, source_ref2,
             DECODE(source_application_db, 'CUST-ORDER', NULL, source_ref3);  
BEGIN
   Delete_Old_Records___();
   IF (tree_id_ IS NULL) THEN
      tree_id_ := inventory_part_tracing_seq.NEXTVAL;
   ELSE
      Delete_Tree__(tree_id_);
   END IF;
   
   superior_part_no_   := Part_Serial_Catalog_API.Get_Superior_Part_No(part_no_, serial_no_);
   superior_serial_no_ := Part_Serial_Catalog_API.Get_Superior_Serial_No(part_no_, serial_no_);
   
   FOR rec_ IN get_rec LOOP      
      New(node_id_, tree_id_, NULL, node_level_, rec_.contract, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, rec_.source_application_db, rec_.source_ref1, 'USAGE', rec_.transaction_id);
      IF rec_.source_application_db IN ('SHOP-ORDER', 'PROD-SCH', 'PUR-ORDER', 'WDR-CHANGE', 'SERIAL', 'MOVE-SITE', 'CUST-ORDER') THEN
         Gen_Part_Usage_Child_Nodes___(tree_id_, node_id_, node_level_, rec_.transaction_id, rec_.contract, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, rec_.source_ref1, rec_.source_ref2, rec_.source_ref3, superior_part_no_, superior_serial_no_, rec_.source_application_db, rec_.date_time_created, serial_no_ = '*');
      END IF;
   END LOOP;
END Gen_Part_Usage_Tree__;


PROCEDURE Gen_Part_Origin_Tree__ (
   tree_id_                   IN OUT NUMBER,
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   waiv_dev_rej_no_           IN VARCHAR2,
   contract_                  IN VARCHAR2)   
IS
   node_id_          NUMBER;
   CURSOR get_root_node_details IS
   SELECT source_application_db,
          source_ref1,
          source_ref2,
          source_ref3,
          max(date_time_created) date_time_created,
          max(transaction_id)    transaction_id,
             contract
      FROM   INVENTORY_TRANSACTION_TRACING
      WHERE (source_application_db != 'INT-MOVE' OR
          (source_application_db = 'INT-MOVE' AND Inventory_Transaction_Hist_API.Check_Created_Lot_Batch_No(contract,
                                                                                                            part_no,
                                                                                                            location_no,
                                                                                                            lot_batch_no,
                                                                                                            serial_no,
                                                                                                            waiv_dev_rej_no,
                                                                                                            source_ref1,
                                                                                                            source_ref2,
                                                                                                            source_ref3,
                                                                                                            source_ref4) = 'LOT-BATCH-MOVE'))
      AND part_tracing_db IN ('ORIGIN-TRACING', 'ORIGIN-RETURNS')
      AND waiv_dev_rej_no = Nvl(waiv_dev_rej_no_, '*')
      AND serial_no       = Nvl(serial_no_, '*')
      AND lot_batch_no    = Nvl(lot_batch_no_, '*')
      AND part_no         = part_no_
      AND contract        = contract_
   GROUP BY source_application_db,
          source_ref1,
          source_ref2,
          source_ref3,
            contract
            ORDER BY transaction_id;
   
   level_          NUMBER := 1;   
BEGIN
   Delete_Old_Records___();
   IF (tree_id_ IS NOT NULL) THEN
      Delete_Tree__(tree_id_);
   ELSE
      tree_id_ := inventory_part_tracing_seq.NEXTVAL;
   END IF;  

   FOR root_rec_ IN get_root_node_details LOOP            
      New(node_id_, tree_id_, NULL, level_, root_rec_.contract, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_,  root_rec_.source_application_db, root_rec_.source_ref1, 'ORIGIN', root_rec_.transaction_id);
      IF (root_rec_.source_application_db IN( 'SHOP-ORDER' ,'PROD-SCH','PUR-ORDER', 'WDR-CHANGE','SERIAL','MOVE-SITE')) THEN           
          Gen_Part_Origin_Child_Nodes___(tree_id_, node_id_, root_rec_.contract, part_no_, serial_no_, lot_batch_no_, waiv_dev_rej_no_, root_rec_.source_application_db, root_rec_.source_ref1, root_rec_.source_ref2, root_rec_.source_ref3, root_rec_.date_time_created, root_rec_.transaction_id, level_ );
      END IF;
   END LOOP;   
END Gen_Part_Origin_Tree__;

FUNCTION Analysis_Exist (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   is_exist_   VARCHAR2(5);
BEGIN
   $IF Component_Quaman_SYS.INSTALLED $THEN
      is_exist_ := Inventory_Analysis_API.Is_Analysis_Exist(part_no_, lot_batch_no_, contract_);
   $ELSE
      is_exist_ := 'FALSE';
   $END
   RETURN is_exist_;
END Analysis_Exist;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   node_id_               OUT NUMBER,
   tree_id_                IN NUMBER,   
   parent_node_id_         IN NUMBER,
   node_level_             IN NUMBER,
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   lot_batch_no_           IN VARCHAR2,
   waiv_dev_rej_no_        IN VARCHAR2,
   source_application_db_  IN VARCHAR2,
   source_ref1_            IN VARCHAR2,
   tracing_type_           IN VARCHAR2,
   transaction_id_         IN  NUMBER)
IS   
   newrec_  inventory_part_tracing_tab%ROWTYPE;   
BEGIN
   newrec_.tree_id            := tree_id_;
   newrec_.node_id            := Get_Next_Node_Id___(tree_id_);
   node_id_                   := newrec_.node_id;
   newrec_.parent_node_id     := parent_node_id_; 
   newrec_.node_level         := node_level_;
   newrec_.transaction_id     := transaction_id_;  
   New___(newrec_);     
END New;

FUNCTION Check_Transaction_Exist(
      tree_id_          IN  NUMBER,
      transaction_id_   IN  NUMBER) RETURN BOOLEAN
IS
   CURSOR get_rec_ IS
   SELECT 1 
   FROM Inventory_Part_Tracing_tab
   WHERE tree_id = tree_id_
   AND transaction_id = transaction_id_;
dummy_ NUMBER;   
BEGIN
   OPEN get_rec_;
   FETCH get_rec_ INTO dummy_;
   CLOSE get_rec_;
   IF dummy_ IS NOT NULL THEN
      RETURN TRUE;
   ELSE 
      RETURN FALSE;
   END IF;
END Check_Transaction_Exist;

FUNCTION Get_Tree_Id(
      contract_         IN  VARCHAR2,
      part_no_          IN  VARCHAR2,
      serial_no_        IN  VARCHAR2,
      lot_batch_no_     IN  VARCHAR2,
      waiv_dev_rej_no_  IN  VARCHAR2) RETURN NUMBER
IS
   CURSOR get_rec_ IS
   SELECT tree_id 
   FROM invent_part_tracing_detail
   WHERE contract = contract_
   AND part_no = part_no_
   AND serial_no = serial_no_
   AND lot_batch_no = lot_batch_no_
   AND waiv_dev_rej_no = waiv_dev_rej_no_
   AND transaction_id = parent_transaction_id;
tree_id_ NUMBER;   
BEGIN
   OPEN get_rec_;
   FETCH get_rec_ INTO tree_id_;
   CLOSE get_rec_;
   IF tree_id_ IS NOT NULL THEN
      RETURN tree_id_;
   ELSE 
      RETURN NULL;
   END IF;
END Get_Tree_Id;
