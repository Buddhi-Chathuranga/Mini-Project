-----------------------------------------------------------------------------
--
--  Logical unit: HandlUnitSnapshotUtil
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211011  RoJalk  SC21R2-688, Modified Has_Same_Inv_Part_Stock___ so the activity_seq comparison will be common to inventory part in stock and transit.
--  210518  ChWkLk  MFZ-7568, Modified Set_Outermost_HU_Ids___() to improve performance by rearranging the logic.
--  200824  RoJalk  SC2020R1-9252, Modified the get_inv_part_in_transit cursor in Check_And_Mark_For_Aggr___ to select 
--  200824          activity_seq from inventory_part_in_transit_tab instead of hardcoded 0.
--  180307  RaVdlk  STRSC-17471, Removed installation errors from sql plus tool
--  170308  Chfose  LIM-11086, Added new parameter check_in_transit_ to compare with INVENTORY_PART_IN_TRANSIT_TAB instead of INVENTORY_PART_IN_STOCK_TAB.
--  170207  Chfose  LIM-10534, Added new parameter index_by_handling_unit_id_ to Generate_Snapshot to have the possibility to get the
--  170207          result collection indexed by the handling units ids.
--  161202  LEPESE  LIM-9483, Added parameter summarize_part_stock_result_ to methods Generate_Result___, Get_Result___ and Generate_Snapshot.
--  161202          Added cursor get_inventory_part_sum_qty in method Get_Result to summarize quantity per contract and part_no. 
--  160510  Khvese  LIM-1310, Added parameter incl_qty_zero_in_result_ to method's signature/call of Generate_Snapshot, Generate_Result___ 
--  160510          and Insert_Into_Temp_Table___. Modified Get_Result___ to bypass comparison for handling units/stock records with qty zero.
--  160307  Chfose  LIM-6169, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


PROCEDURE Generate_Result___ (
   handl_unit_stock_result_tab_  OUT Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab,
   inv_part_stock_result_tab_    OUT Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   inv_part_stock_tab_           IN  Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   only_outermost_in_result_     IN  BOOLEAN,
   incl_hu_zero_in_result_       IN  BOOLEAN,
   incl_qty_zero_in_result_      IN  BOOLEAN,
   summarize_part_stock_result_  IN  BOOLEAN,
   check_in_transit_             IN  BOOLEAN DEFAULT FALSE )
IS      
   CURSOR get_unchecked_distinct_hus IS
      SELECT DISTINCT is_inside_hu_id, node_level
        FROM handling_unit_aggregation_tmp
       WHERE has_been_checked = 'FALSE' 
         AND is_inside_hu_id IS NOT NULL
       ORDER BY node_level DESC;   
   
   handl_unit_to_check_    NUMBER;
   node_level_             NUMBER := NULL;
   previous_node_level_    NUMBER := NULL;
   a_hu_needs_aggregation_ BOOLEAN := FALSE;
BEGIN
   -- Insert all of the parts into the temp table so that we can start processing it.
   Insert_Into_Temp_Table___(inv_part_stock_tab_, incl_qty_zero_in_result_);
   
   -- We will loop until everything in the TMP-table has been marked as checked
   -- and no more aggregation is to be done.
   <<outer>>
   LOOP
      Aggregate_And_Clean_Up_Tmp___(only_outermost_in_result_);
      previous_node_level_ := NULL;
      a_hu_needs_aggregation_ := FALSE;    
      
      OPEN get_unchecked_distinct_hus; 
      <<inner>>
      LOOP 
         FETCH get_unchecked_distinct_hus INTO handl_unit_to_check_, node_level_;  
         -- If we can't find any more unchecked records but there is still some records to be aggregated we exit the inner loop.
         EXIT inner WHEN get_unchecked_distinct_hus%NOTFOUND AND a_hu_needs_aggregation_;
         -- If we can't find any more unchecked records in the TMP-table we exit the outer loop.
         EXIT outer WHEN get_unchecked_distinct_hus%NOTFOUND;
         
         -- If we reach a new node_level we must first run the Aggregate_And_Clean_Up_Tmp___ method to make sure
         -- that we have all of the content of the new node level in the TMP-table.
         IF (previous_node_level_ != node_level_ AND previous_node_level_ IS NOT NULL) THEN
            EXIT inner WHEN a_hu_needs_aggregation_;
         END IF;
         previous_node_level_ := node_level_;
         
         -- We compare the content of a specific Handling Unit with the actual content (Parts + Handling Units) in Inventory to
         -- see if what exists in the TMP-table is a full Handling Unit. If a full Handling Unit exists we mark all of it's content
         -- for aggregation (to be used in Aggregate_And_Clean_Up_Tmp___).
         IF (Check_And_Mark_For_Aggr___(handl_unit_to_check_, check_in_transit_)) THEN
            a_hu_needs_aggregation_ := TRUE;
         END IF;
      END LOOP;
      CLOSE get_unchecked_distinct_hus;
   END LOOP;
   
   -- After the loop we now have the final result in the TMP-table.
   Set_Outermost_HU_Ids___;
   Get_Result___(handl_unit_stock_result_tab_, 
                 inv_part_stock_result_tab_, 
                 incl_hu_zero_in_result_, 
                 summarize_part_stock_result_);
END Generate_Result___;


-- This method prepares the TMP-table with all of the Inv_Part_Stock-records that was sent into the logic.
PROCEDURE Insert_Into_Temp_Table___ (
   inv_part_stock_tab_        IN Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   incl_qty_zero_in_result_   IN  BOOLEAN)
IS
   local_inv_part_stock_tab_    Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   index_                       NUMBER := 0;
BEGIN   
   DELETE FROM handling_unit_aggregation_tmp;
   
   IF (inv_part_stock_tab_.COUNT > 0) THEN
      -- If we should not include records with qty = 0 in the result we exclude them from the collection.
      IF (NOT incl_qty_zero_in_result_) THEN
         FOR i IN inv_part_stock_tab_.FIRST .. inv_part_stock_tab_.LAST LOOP
            IF (inv_part_stock_tab_(i).quantity != 0) THEN
               local_inv_part_stock_tab_(index_) := inv_part_stock_tab_(i);
               index_ := index_ + 1;
            END IF;
         END LOOP;
      ELSE
         local_inv_part_stock_tab_ := inv_part_stock_tab_;
      END IF;
      
      -- We insert all of the Inv_part_Stock-records in the TMP-table. 
      -- IMPORTANT TO NOTE: The TMP-table will be containing both Handling Units and Inventory Parts (currently only Inventory Parts),
      -- the column is_inside_hu_id will then differ; for an Inventory Part the handling_unit_id = is_inside_hu_id but
      -- for a Handling Unit the is_inside_hu_id = parent_handling_unit_id.
      FORALL i IN local_inv_part_stock_tab_.FIRST .. local_inv_part_stock_tab_.LAST
         INSERT INTO handling_unit_aggregation_tmp
            (is_inside_hu_id,
             part_no,
             contract, 
             configuration_id,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             activity_seq,
             handling_unit_id,
             quantity,
             node_level,
             has_been_checked)
         VALUES
            (local_inv_part_stock_tab_(i).handling_unit_id,
             local_inv_part_stock_tab_(i).part_no,
             local_inv_part_stock_tab_(i).contract,
             local_inv_part_stock_tab_(i).configuration_id,
             local_inv_part_stock_tab_(i).location_no,
             local_inv_part_stock_tab_(i).lot_batch_no,
             local_inv_part_stock_tab_(i).serial_no,
             local_inv_part_stock_tab_(i).eng_chg_level,
             local_inv_part_stock_tab_(i).waiv_dev_rej_no, 
             local_inv_part_stock_tab_(i).activity_seq,
             local_inv_part_stock_tab_(i).handling_unit_id,
             local_inv_part_stock_tab_(i).quantity,
             Handling_Unit_API.Get_Structure_Level(local_inv_part_stock_tab_(i).handling_unit_id),
             CASE WHEN local_inv_part_stock_tab_(i).handling_unit_id = 0 THEN 'TRUE' ELSE 'FALSE'
             END);
   END IF;
END Insert_Into_Temp_Table___;


-- This method will look at the TMP-table and for all of the Parts/Handling Units that 
-- are marked for aggregation we add the Handling Unit which it resides in.
-- For a Inventory Part In Stock it is the HU ID of the record, while for a Handling Unit
-- it is the Parent Handling Unit Id.
PROCEDURE Aggregate_And_Clean_Up_Tmp___ (
   only_outermost_in_result_ IN BOOLEAN )
IS
   CURSOR get_new_handling_units IS
      SELECT DISTINCT is_inside_hu_id
        FROM handling_unit_aggregation_tmp
       WHERE aggregation_needed = 'TRUE';
       
   new_handling_unit_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   OPEN get_new_handling_units;
   FETCH get_new_handling_units BULK COLLECT INTO new_handling_unit_tab_;
   CLOSE get_new_handling_units;
   
   -- We find all the records marked with aggregation_needed = TRUE.
   IF (new_handling_unit_tab_.COUNT > 0) THEN
      -- For each record we add their unique is_inside_hu_id's to the TMP-table
      -- (Parts will have their Handling Unit added and Handling Units will have their parent added)
      FORALL i IN new_handling_unit_tab_.FIRST .. new_handling_unit_tab_.LAST
         INSERT INTO handling_unit_aggregation_tmp
            (handling_unit_id,
             is_inside_hu_id,
             node_level)
         VALUES
            (new_handling_unit_tab_(i).handling_unit_id,
             Handling_Unit_API.Get_Parent_Handling_Unit_Id(new_handling_unit_tab_(i).handling_unit_id),
             Handling_Unit_API.Get_Structure_Level(Handling_Unit_API.Get_Parent_Handling_Unit_Id(new_handling_unit_tab_(i).handling_unit_id)));
      
      IF(NOT only_outermost_in_result_) THEN
         -- If we want all Handling Units to exist in the result (not only outermost handling units) 
         -- we will only remove all of the parts marked for aggregation.
         DELETE FROM handling_unit_aggregation_tmp
               WHERE aggregation_needed = 'TRUE'
                 AND part_no IS NOT NULL;

         -- For all of the Handling Unit children marked with aggregation_needed = TRUE
         -- we indicate that they are no longer the outermost handling unit.
         UPDATE handling_unit_aggregation_tmp
            SET aggregation_needed = 'FALSE',
                outermost = 'FALSE'
          WHERE aggregation_needed = 'TRUE';
      ELSE
         -- If we only want the outermost Handling Units we can
         -- remove everything marked for aggregation.
         DELETE FROM handling_unit_aggregation_tmp
               WHERE aggregation_needed = 'TRUE';
      END IF;
   END IF;  
END Aggregate_And_Clean_Up_Tmp___;


-- Checks and compares with either Inventory_Part_In_Stock or Inventory_Part_In_Transit
-- to find out if all content is represented in the TMP-table. It is done in different
-- cursors in order to get the most optimal performance.
FUNCTION Check_And_Mark_For_Aggr___ (
   handling_unit_id_    IN NUMBER,
   check_in_transit_    IN BOOLEAN ) RETURN BOOLEAN
IS
   -- Handling Units in TMP-table ----------
   CURSOR get_handl_unit_stock_from_tmp IS
      SELECT handling_unit_id
        FROM handling_unit_aggregation_tmp
       WHERE is_inside_hu_id = handling_unit_id_
         AND part_no IS NULL
         AND Handling_Unit_API.Has_Quantity_In_Stock(handling_unit_id) = 'TRUE';
         
   CURSOR get_handl_unit_trans_from_tmp IS
      SELECT handling_unit_id
        FROM handling_unit_aggregation_tmp
       WHERE is_inside_hu_id = handling_unit_id_
         AND part_no IS NULL
         AND Handling_Unit_API.Is_In_Transit(handling_unit_id) = 'TRUE';
   -----------------------------------------

   -- Handling Units in Inventory/Transit --
   CURSOR get_handl_unit_stock IS
     SELECT handling_unit_id
       FROM handling_unit_tab
      WHERE parent_handling_unit_id = handling_unit_id_
        AND Handling_Unit_API.Has_Quantity_In_Stock(handling_unit_id) = 'TRUE';
        
   CURSOR get_handl_unit_transit IS
     SELECT handling_unit_id
       FROM handling_unit_tab
      WHERE parent_handling_unit_id = handling_unit_id_
        AND Handling_Unit_API.Is_In_Transit(handling_unit_id) = 'TRUE';
   -----------------------------------------

   -- Inv Parts in stock in TMP-table ------
   CURSOR get_inv_part_stock_from_tmp IS
      SELECT contract, part_no, configuration_id, location_no,
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             activity_seq, handling_unit_id, SUM(quantity)
        FROM handling_unit_aggregation_tmp
       WHERE is_inside_hu_id = handling_unit_id_
         AND part_no IS NOT NULL
         AND quantity > 0
       GROUP BY contract, part_no, configuration_id, location_no,
                lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
                activity_seq, handling_unit_id;
   -----------------------------------------

   -- Inv Parts in Inventory/Transit -------
   CURSOR get_inv_part_stock IS
      SELECT contract, part_no, configuration_id, location_no,
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             activity_seq, handling_unit_id, (qty_onhand + qty_in_transit) quantity
        FROM inventory_part_in_stock_tab
       WHERE handling_unit_id = handling_unit_id_
         AND qty_onhand + qty_in_transit > 0;
         
   CURSOR get_inv_part_in_transit IS
      SELECT contract, part_no, configuration_id, NULL,
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             activity_seq, handling_unit_id, quantity
        FROM inventory_part_in_transit_tab
       WHERE handling_unit_id = handling_unit_id_
         AND quantity > 0;
   -----------------------------------------
         
   handl_unit_tmp_tab_     Handling_Unit_API.Handling_Unit_Id_Tab;
   handl_unit_tab_         Handling_Unit_API.Handling_Unit_Id_Tab;
   inv_part_tmp_tab_       Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   inv_part_tab_           Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
   aggregation_needed_     VARCHAR2(5) := 'FALSE';
   result_                 BOOLEAN := TRUE;
BEGIN
   -- Compare Handling Units
   IF (NOT check_in_transit_) THEN
      OPEN get_handl_unit_stock_from_tmp;
      FETCH get_handl_unit_stock_from_tmp BULK COLLECT INTO handl_unit_tmp_tab_;
      CLOSE get_handl_unit_stock_from_tmp;

      OPEN get_handl_unit_stock;
      FETCH get_handl_unit_stock BULK COLLECT INTO handl_unit_tab_;
      CLOSE get_handl_unit_stock;
   ELSE
      OPEN get_handl_unit_trans_from_tmp;
      FETCH get_handl_unit_trans_from_tmp BULK COLLECT INTO handl_unit_tmp_tab_;
      CLOSE get_handl_unit_trans_from_tmp;

      OPEN get_handl_unit_transit;
      FETCH get_handl_unit_transit BULK COLLECT INTO handl_unit_tab_;
      CLOSE get_handl_unit_transit;
   END IF;
   
   result_ := Has_Same_Handling_Units___(handl_unit_tmp_tab_, handl_unit_tab_);
   
   IF (result_) THEN
      -- Compare Inventory Parts
      OPEN get_inv_part_stock_from_tmp;
      FETCH get_inv_part_stock_from_tmp BULK COLLECT INTO inv_part_tmp_tab_;
      CLOSE get_inv_part_stock_from_tmp;

      IF (NOT check_in_transit_) THEN
         OPEN get_inv_part_stock;
         FETCH get_inv_part_stock BULK COLLECT INTO inv_part_tab_;
         CLOSE get_inv_part_stock;
      ELSE
         OPEN get_inv_part_in_transit;
         FETCH get_inv_part_in_transit BULK COLLECT INTO inv_part_tab_;
         CLOSE get_inv_part_in_transit;
      END IF;
      
      result_ := Has_Same_Inv_Part_Stock___(inv_part_tmp_tab_, inv_part_tab_, check_in_transit_);
      
      IF (result_) THEN
         aggregation_needed_ := 'TRUE';
      END IF;
   END IF;
   
   -- Update the TMP-table to indicate that the handling unit has been checked
   -- and if all of the content existed in the TMP-table or not (if it could be aggregated or not).
   UPDATE handling_unit_aggregation_tmp
      SET has_been_checked = 'TRUE', 
          aggregation_needed = aggregation_needed_
    WHERE is_inside_hu_id = handling_unit_id_;
    
   RETURN result_;
END Check_And_Mark_For_Aggr___;


-- Checks if the two collections contains the same Inv_Part_Stock-records.
FUNCTION Has_Same_Inv_Part_Stock___ (
   inv_part_stock_tab_  IN Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   inv_part_stock_tab2_ IN Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   check_in_transit_    IN BOOLEAN ) RETURN BOOLEAN
IS
   exists_ BOOLEAN := FALSE;
   result_ BOOLEAN := FALSE;
BEGIN
   IF (inv_part_stock_tab_.COUNT = inv_part_stock_tab2_.COUNT) THEN
      result_ := TRUE;
      
      IF (inv_part_stock_tab_.COUNT > 0) THEN
         <<outer>>
         FOR i_ IN inv_part_stock_tab_.FIRST .. inv_part_stock_tab_.LAST LOOP
            exists_ := FALSE;

            <<inner>>
            FOR j_ IN inv_part_stock_tab2_.FIRST .. inv_part_stock_tab2_.LAST LOOP
               IF(inv_part_stock_tab_(i_).contract          = inv_part_stock_tab2_(j_).contract         AND
                  inv_part_stock_tab_(i_).part_no           = inv_part_stock_tab2_(j_).part_no          AND
                  inv_part_stock_tab_(i_).configuration_id  = inv_part_stock_tab2_(j_).configuration_id AND
                  inv_part_stock_tab_(i_).lot_batch_no      = inv_part_stock_tab2_(j_).lot_batch_no     AND
                  inv_part_stock_tab_(i_).serial_no         = inv_part_stock_tab2_(j_).serial_no        AND
                  inv_part_stock_tab_(i_).eng_chg_level     = inv_part_stock_tab2_(j_).eng_chg_level    AND
                  inv_part_stock_tab_(i_).waiv_dev_rej_no   = inv_part_stock_tab2_(j_).waiv_dev_rej_no  AND
                  inv_part_stock_tab_(i_).activity_seq      = inv_part_stock_tab2_(j_).activity_seq     AND
                  inv_part_stock_tab_(i_).handling_unit_id  = inv_part_stock_tab2_(j_).handling_unit_id AND
                  inv_part_stock_tab_(i_).quantity          = inv_part_stock_tab2_(j_).quantity) THEN
                  
                  -- If in transit there is no activity_seq and location to check
                  IF (check_in_transit_ OR
                     (inv_part_stock_tab_(i_).location_no   = inv_part_stock_tab2_(j_).location_no)) THEN
                     exists_ := TRUE;
                     EXIT inner;
                  END IF;
               END IF;
            END LOOP;

            IF (NOT exists_) THEN
               result_ := FALSE;
               EXIT outer;
            END IF;
         END LOOP;
      END IF;
   END IF;
   
   RETURN result_;
END Has_Same_Inv_Part_Stock___;


-- Checks if the two collections contains the same Handling Units.
FUNCTION Has_Same_Handling_Units___ (
   handl_unit_stock_tab_  IN Handling_Unit_API.Handling_Unit_Id_Tab,
   handl_unit_stock_tab2_ IN Handling_Unit_API.Handling_Unit_Id_Tab ) RETURN BOOLEAN
IS
   exists_ BOOLEAN := FALSE;
   result_ BOOLEAN := FALSE;
BEGIN
   IF (handl_unit_stock_tab_.COUNT = handl_unit_stock_tab2_.COUNT) THEN
      result_ := TRUE;     
      
      IF (handl_unit_stock_tab_.COUNT > 0) THEN
         <<outer>>
         FOR i_ IN handl_unit_stock_tab_.FIRST .. handl_unit_stock_tab_.LAST LOOP
            exists_ := FALSE;
            
            <<inner>>
            FOR j_ IN  handl_unit_stock_tab2_.FIRST .. handl_unit_stock_tab2_.LAST LOOP
               IF (handl_unit_stock_tab_(i_).handling_unit_id = handl_unit_stock_tab2_(j_).handling_unit_id) THEN
                  exists_ := TRUE;
                  EXIT inner;
               END IF;
            END LOOP;

            IF (NOT exists_) THEN
               result_ := FALSE;
               EXIT outer;
            END IF;
         END LOOP;
      END IF;
   END IF;
   
   RETURN result_;
END Has_Same_Handling_Units___;


-- For each record in the TMP-table we get the id of
-- the outermost handling unit that exists in the TMP-table.
PROCEDURE Set_Outermost_HU_Ids___
IS
   CURSOR get_outermost_hus IS
      SELECT handling_unit_id
        FROM handling_unit_aggregation_tmp
       WHERE outermost = 'TRUE'
         AND part_no IS NULL;
   -- replaced outermost_hus_tab_ with node_and_children_tab_       
   node_and_children_tab_  Handling_Unit_API.Handling_Unit_Id_Tab;
BEGIN
   FOR outermost_rec_ IN get_outermost_hus LOOP
      node_and_children_tab_ := Handling_Unit_API.Get_Node_And_Descendants(outermost_rec_.handling_unit_id);      
      IF (node_and_children_tab_.COUNT > 0) THEN
         FOR i IN node_and_children_tab_.FIRST..node_and_children_tab_.LAST LOOP
            UPDATE handling_unit_aggregation_tmp
               SET outermost_hu_id = outermost_rec_.handling_unit_id
             WHERE handling_unit_id = node_and_children_tab_(i).handling_unit_id;
         END LOOP;         
      END IF;
   END LOOP;
END Set_Outermost_HU_Ids___;


-- This method extracts the information within the TMP-table into two collections,
-- one for the Handling Units and one for the Inventory Parts.
PROCEDURE Get_Result___ (
   handl_unit_stock_result_tab_  OUT Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab,
   inv_part_stock_result_tab_    OUT Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   incl_hu_zero_in_result_       IN  BOOLEAN,
   summarize_part_stock_result_  IN  BOOLEAN )
IS
   -- Extracts the Handling Units records from the TMP-table
   CURSOR get_handl_unit_stock_result IS
      SELECT handling_unit_id, 
             NVL(Handling_Unit_API.Get_Contract(handling_unit_id),'NULL') contract,
             NVL(Handling_unit_API.Get_Location_No(handling_unit_id),'NULL') location_no,
             outermost, outermost_hu_id
        FROM handling_unit_aggregation_tmp
       WHERE part_no IS NULL;
       
   -- Extracts the Handling Unit records and Location records from the TMP-table.
   CURSOR get_hu_stock_res_w_zero IS
      SELECT handling_unit_id, contract, location_no,
             outermost, outermost_hu_id
        FROM (SELECT handling_unit_id, 
                     NVL(Handling_Unit_API.Get_Contract(handling_unit_id),'NULL') contract,
                     NVL(Handling_unit_API.Get_Location_No(handling_unit_id),'NULL') location_no, 
                     outermost, outermost_hu_id
                FROM handling_unit_aggregation_tmp
               WHERE part_no IS NULL
               UNION 
              SELECT 0 handling_unit_id, contract, location_no, outermost, NULL outermost_hu_id
                FROM handling_unit_aggregation_tmp
               WHERE part_no IS NOT NULL);
   
   -- Extracts the non-aggregated Inventory Part records from the TMP-table.
   CURSOR get_inv_part_stock_result IS
      SELECT contract, part_no, configuration_id, location_no,
             lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
             activity_seq, handling_unit_id, SUM(quantity)
        FROM handling_unit_aggregation_tmp
       WHERE part_no IS NOT NULL
       GROUP BY contract, part_no, configuration_id, location_no,
                lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
                activity_seq, handling_unit_id;

   CURSOR get_inventory_part_sum_qty IS
      SELECT contract, part_no, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, SUM(quantity)
        FROM handling_unit_aggregation_tmp
       WHERE part_no IS NOT NULL
       GROUP BY contract, part_no, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL;
BEGIN
   IF (incl_hu_zero_in_result_) THEN
      OPEN get_hu_stock_res_w_zero;
      FETCH get_hu_stock_res_w_zero BULK COLLECT INTO handl_unit_stock_result_tab_;
      CLOSE get_hu_stock_res_w_zero;
   ELSE
      OPEN get_handl_unit_stock_result;
      FETCH get_handl_unit_stock_result BULK COLLECT INTO handl_unit_stock_result_tab_;
      CLOSE get_handl_unit_stock_result;
   END IF;

   IF (summarize_part_stock_result_) THEN
      OPEN  get_inventory_part_sum_qty;
      FETCH get_inventory_part_sum_qty BULK COLLECT INTO inv_part_stock_result_tab_;
      CLOSE get_inventory_part_sum_qty;
   ELSE
      OPEN get_inv_part_stock_result;
      FETCH get_inv_part_stock_result BULK COLLECT INTO inv_part_stock_result_tab_;
      CLOSE get_inv_part_stock_result;
   END IF;   
END Get_Result___;


-- This method reorders the Handling Unit collection and indexes them with the actual
-- Handling Unit ID instead of a sequencial number.
PROCEDURE Index_Result_By_HU_Id___(
   handl_unit_stock_result_tab_ IN OUT Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab)
IS
   result_stock_tab_ Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab;
BEGIN
   IF (handl_unit_stock_result_tab_.COUNT > 0) THEN
      FOR i IN handl_unit_stock_result_tab_.FIRST .. handl_unit_stock_result_tab_.LAST LOOP
         result_stock_tab_(handl_unit_stock_result_tab_(i).handling_unit_id) := handl_unit_stock_result_tab_(i);
      END LOOP;
   END IF;
      
   handl_unit_stock_result_tab_ := result_stock_tab_;
END Index_Result_By_HU_Id___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Generate_Snapshot (
   source_ref1_                  IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,
   inv_part_stock_tab_           IN Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   only_outermost_in_result_     IN BOOLEAN DEFAULT FALSE,
   incl_hu_zero_in_result_       IN BOOLEAN DEFAULT FALSE,
   incl_qty_zero_in_result_      IN BOOLEAN DEFAULT FALSE,
   check_in_transit_             IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Generate_Snapshot(source_ref1_               => source_ref1_,
                     source_ref2_               => '*',
                     source_ref3_               => '*',
                     source_ref4_               => '*',
                     source_ref5_               => '*',
                     source_ref_type_db_        => source_ref_type_db_,
                     inv_part_stock_tab_        => inv_part_stock_tab_,
                     only_outermost_in_result_  => only_outermost_in_result_,
                     incl_hu_zero_in_result_    => incl_hu_zero_in_result_,
                     incl_qty_zero_in_result_   => incl_qty_zero_in_result_,
                     check_in_transit_          => check_in_transit_);
END Generate_Snapshot;


-- Entry method for generating and saving a snapshot in HANDL_UNIT_STOCK_SNAPSHOT_TAB & INV_PART_STOCK_SNAPSHOT_TAB.
-- The source_ref values are used to filter HANDL_UNIT_STOCK_SNAPSHOT_TAB & INV_PART_STOCK_SNAPSHOT_TAB to get the snapshot result.
-- The source_ref_type_db_ is of type HandlUnitSnapshotType and the identifiers can be whatever fits the scenario.
-- An example could be generating a snapshot for a pick list, then the source_ref_type_db_ would be
-- Handl_Unit_Snapshot_Type_API.DB_PICK_LIST and the source_ref1_ would be the pick_list_no. 
PROCEDURE Generate_Snapshot (
   source_ref1_                  IN VARCHAR2,
   source_ref2_                  IN VARCHAR2,
   source_ref3_                  IN VARCHAR2,
   source_ref4_                  IN VARCHAR2,
   source_ref5_                  IN VARCHAR2,
   source_ref_type_db_           IN VARCHAR2,
   inv_part_stock_tab_           IN Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   only_outermost_in_result_     IN BOOLEAN DEFAULT FALSE,
   incl_hu_zero_in_result_       IN BOOLEAN DEFAULT FALSE,
   incl_qty_zero_in_result_      IN BOOLEAN DEFAULT FALSE,
   check_in_transit_             IN BOOLEAN DEFAULT FALSE )
IS
   handl_unit_stock_result_tab_  Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab;
   inv_part_stock_result_tab_    Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab;
BEGIN
   Generate_Result___(handl_unit_stock_result_tab_,
                      inv_part_stock_result_tab_,
                      inv_part_stock_tab_,
                      only_outermost_in_result_,
                      incl_hu_zero_in_result_,
                      incl_qty_zero_in_result_,
                      summarize_part_stock_result_ => FALSE,
                      check_in_transit_            => check_in_transit_);
                
   Handl_Unit_Stock_Snapshot_API.Insert_Snapshot(source_ref1_,
                                                 source_ref2_,
                                                 source_ref3_,
                                                 source_ref4_,
                                                 source_ref5_,
                                                 source_ref_type_db_,
                                                 handl_unit_stock_result_tab_);
   
   Inv_Part_Stock_Snapshot_API.Insert_Snapshot(source_ref1_,
                                               source_ref2_,
                                               source_ref3_,
                                               source_ref4_,
                                               source_ref5_,
                                               source_ref_type_db_,
                                               inv_part_stock_result_tab_);
END Generate_Snapshot;


-- Entry method for generating a snapshot and getting the result back as two collections.
-- One collection containing all of the successfully aggregated Handling Units and one collection
-- containing the inv parts that was not unable to be aggregated (packed or unpacked).
PROCEDURE Generate_Snapshot (
   handl_unit_stock_result_tab_  OUT Handl_Unit_Stock_Snapshot_API.Handl_Unit_Stock_Tab,
   inv_part_stock_result_tab_    OUT Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   inv_part_stock_tab_           IN  Inv_Part_Stock_Snapshot_API.Inv_Part_Stock_Tab,
   only_outermost_in_result_     IN  BOOLEAN DEFAULT FALSE,
   incl_hu_zero_in_result_       IN  BOOLEAN DEFAULT FALSE,
   incl_qty_zero_in_result_      IN  BOOLEAN DEFAULT FALSE,
   summarize_part_stock_result_  IN  BOOLEAN DEFAULT FALSE,
   index_by_handling_unit_id_    IN  BOOLEAN DEFAULT FALSE ) 
IS
BEGIN
   Generate_Result___(handl_unit_stock_result_tab_,
                      inv_part_stock_result_tab_,
                      inv_part_stock_tab_,
                      only_outermost_in_result_,
                      incl_hu_zero_in_result_,
                      incl_qty_zero_in_result_,
                      summarize_part_stock_result_);
                      
   IF (index_by_handling_unit_id_) THEN
      Index_Result_By_HU_Id___(handl_unit_stock_result_tab_);
   END IF;
END Generate_Snapshot;


PROCEDURE Delete_Snapshot (
   source_ref1_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2 )
IS
BEGIN
   Delete_Snapshot(source_ref1_        => source_ref1_,
                   source_ref2_        => '*',
                   source_ref3_        => '*',
                   source_ref4_        => '*',
                   source_ref5_        => '*',
                   source_ref_type_db_ => source_ref_type_db_);
END Delete_Snapshot;


-- Method for deleting a snapshot with specific source_ref-identifiers from
-- HANDL_UNIT_STOCK_SNAPSHOT_TAB & INV_PART_STOCK_SNAPSHOT_TAB.
PROCEDURE Delete_Snapshot (
   source_ref1_            IN VARCHAR2,
   source_ref2_            IN VARCHAR2,
   source_ref3_            IN VARCHAR2,
   source_ref4_            IN VARCHAR2,
   source_ref5_            IN VARCHAR2,
   source_ref_type_db_     IN VARCHAR2 )
IS
BEGIN
   Handl_Unit_Stock_Snapshot_API.Delete_Snapshot(source_ref1_,
                                                 source_ref2_,
                                                 source_ref3_,
                                                 source_ref4_,
                                                 source_ref5_,
                                                 source_ref_type_db_);
                                                 
   Inv_Part_Stock_Snapshot_API.Delete_Snapshot(source_ref1_,
                                               source_ref2_,
                                               source_ref3_,
                                               source_ref4_,
                                               source_ref5_,
                                               source_ref_type_db_);
END Delete_Snapshot;


PROCEDURE Delete_Old_Snapshots (
   source_ref_type_db_  IN VARCHAR2,
   amount_of_days_      IN NUMBER DEFAULT 1)
IS
BEGIN
   Handl_Unit_Stock_Snapshot_API.Delete_Old_Snapshots(source_ref_type_db_,
                                                      amount_of_days_);
                                                      
   Inv_Part_Stock_Snapshot_API.Delete_Old_Snapshots(source_ref_type_db_,
                                                    amount_of_days_);
END Delete_Old_Snapshots;