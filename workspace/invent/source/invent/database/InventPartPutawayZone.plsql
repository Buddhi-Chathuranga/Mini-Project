-----------------------------------------------------------------------------
--
--  Logical unit: InventPartPutawayZone
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220118  LEPESE  SCZ-17236, Redesign of method Get_Best_Bin_Ranking___ to make use of temporary table invent_part_bin_ranking_tmp.
--  211123  Asawlk  SC21R2-6105, Modified Get_Homogen_Hu_Node_Info___ to impove performance when dealing with homogeneous handling units in a way to skip
--  211123          analyzing the content of it from the scratch for every child. Also added method Get_Homogeneous_Hu_From_Tmp___.
--  190627  SBalLK  SCUXXW4-22873, Modified Get_Sql_Where_Expression() method by increasing the length of sql_where_expression_ variable length to 28000 from 4000.
--  180709  SBalLK  Bug 142955, Modified Get_Sql_Where_Expression() method to use Report_Sys sql parser for generate where statement.
--  180308  LEPESE  STRSC-17479, Added package constant last_character_ and replaced usage of Database_SYS.Get_Last_Character with this new constant for increased performance.
--  180215  LEPESE  STRSC-16565, Added handling_unit_id as the last sorting criteria in Get_Zone_And_Fifo_Sorted_Stock.
--  170904  LEPESE  STRSC-8917, Small correction in method Get_Best_Bin_Ranking___ to always sort on the RANKING column, even when using handl_unit_reservation_ranking. 
--  170830  LEPESE  STRSC-8917, Added element best_bin_ranking to Homogeneous_Handling_Unit_Rec. Modified methods Get_Homogen_Hu_Node_Info___, Get_Best_Bin_Ranking___ and
--  170803          Get_Zone_And_Fifo_Sorted_Stock to be able to find the correct zone ranking for reservation depending on the setting of the Handling Unit Type. 
--  170310  LEPESE  LIM-3740, Added consideration to auto_reserve_hu_optimized and auto_reserve_receipt_time in Get_Zone_And_Fifo_Sorted_Stock.
--  170308  LEPESE  LIM-3740, Modified Get_Zone_And_Fifo_Sorted_Stock to consider the auto_reserve_prio1..auto_reserve_prio5 settings on site.
--  170302  LEPESE  LIM-3740, Added column homogeneous_hu_receipt_date to the logic and temporary table used in Get_Zone_And_Fifo_Sorted_Stock.
--  170302          Added truncation of receipt_date to only consider days, not hours and minutes. Replaced Get_Earliest_Expire_Date___ with Get_Earliest_Dates___.
--  160505  SeJalk  Bug 128229, Modified Get_Best_Bin_Ranking___ and Location_Is_In_Operative_Zone to change the finding method of bin is in StorageZone to gain performance.
--  160505          Removed the method Bin_Exist_In_Zone___.
--  160304  LEPESE  LIM-5995, modifications in Get_Homogen_Hu_Node_Info___ to skip handling units that contain more than qty_to_find_.
--  160303  LEPESE  LIM-5995, correction in Get_Zone_And_Fifo_Sorted_Stock to only include the unpacked quantity on the location for an unpacked available stock record.
--  160303          Added sorting on homogen_handl_unit_parent_id in Get_Zone_And_Fifo_Sorted_Stock.
--  160302  LEPESE  LIM-5995, adjustment of cursor Get_Sum_Loc_Homogen_Hu_Qty in Get_Zone_And_Fifo_Sorted_Stock to get correct quantity also in multilevel hu structures.
--  160205  LEPESE  LIM-5995, added cursor Get_Sum_Loc_Homogen_Hu_Qty in Get_Zone_And_Fifo_Sorted_Stock and used it to update inventory_part_avail_stock_tmp.
--  160204  LEPESE  LIM-6040, corrected bug in Get_Zone_And_Fifo_Sorted_Stock by moving the cleanup of homogeneous_handling_unit_tab_.
--  160202  LEPESE  LIM-5995, added sorting in Get_Zone_And_Fifo_Sorted_Stock that works with different priorities depending on if we are finding
--                  homogeneous handling units, partial handling units or unpacked items.
--  160122  LEPESE  LIM-5995, renamed Get_Available_Quantity___ into Get_Sum_Handling_Unit_Qty___. Added Get_Sum_Location_Qty___. Included sorting on
--  160122          descending sum_location_quantity in Get_Zone_And_Fifo_Sorted_Stock.
--  160122  LEPESE  LIM-5994, added method Get_Earliest_Expire_Date___. Added expiration_date to Homogeneous_Handling_Unit_Rec. Included sorting on
--  160122          homogeneous_hu_expiration_date in Get_Zone_And_Fifo_Sorted_Stock.
--  160114  LEPESE  LIM-3742, added node_level sorting in Get_Zone_And_Fifo_Sorted_Stock. Added method Get_Sum_Handling_Unit_Qty___. Added logic in 
--  160114          Get_Zone_And_Fifo_Sorted_Stock to enable partial consumption of handling units. Added parameter consume_partial_handling_unit_.
--  160113  LEPESE  LIM-3742, added parameter prioritize_large_handl_units_ to method Get_Zone_And_Fifo_Sorted_Stock.
--  160113          Added method Get_Homogen_Hu_Node_Info___. Major development in Get_Zone_And_Fifo_Sorted_Stock to support handling unit reservation.
--  160112  LEPESE  LIM-3742, added logic in Get_Zone_And_Fifo_Sorted_Stock to accomodate optimization of biggest possible homogeneous handling unit id.
--  160111  LEPESE  LIM-3742, added Total_Hu_STruct_Is_Avail___ and Get_Total_Hu_Struct_Qty___. Added logic to Get_Zone_And_Fifo_Sorted_Stock
--  160111          to prioritize the full handling unit structures containing the highest total quantity available. 
--  151125  JeLise  LIM-4470, Removed all pallet related code.
--  151016  JeLise  LIM-3893, Removed all pallet location types in Get_Best_Bin_Ranking___.
--  150410  LEPESE  LIM-75, added handling_unit_id to the usage of available_stock_tab_.
--  141115  Joolse  TEFH-138, Corrected Red-Marked code from DS. Changed reserved word zone to zone_
--  131111  Matkse  Added method Get_Sql_Where_Expression. Modified Get_Putaway_Zones, Get_Best_Bin_Ranking___ and Location_Is_In_Operative_Zone to use aforementioned method.
--  131111  Matkse  Added method Get_Storage_Zone_Description.
--  130822  Matkse  Modified view INVENT_PART_OPERATIVE_ZONE to use new column names for ranking and max_bins_per_part for source REMOTE_WAREHOUSE_ASSORTMENT.
--  130819  DaZase  Added warehouse_id to select in Get_Putaway_Zones.
--  120812  Matkse  Modified view INVENT_PART_OPERATIVE_ZONE to include source REMOTE_WAREHOUSE_ASSORTMENT.
--  130102  MaEelk  storage_zone_id was made uppercase.
--  121211  MAHPLK  Modified Get_Zone_And_Fifo_Sorted_Stock to sort using route_order.
--  121119  MAHPLK  Added storage_zone_id and removed warehouse_id, bay_id, tier_id, row_id, bin_id from LU. 
--  121119          Added method Lock_By_Keys_Wait and Bin_Exist_In_Zone___. Modified Create_Removed_Line__, Part_Zone_Exist___,
--  121119          Get_Putaway_Zones, Copy, Location_Is_In_Operative_Zone. Removed Check_Remove_Warehouse__, Do_Remove_Warehouse__, Check_Remove_Bay__, Do_Remove_Bay__, 
--  121119          Check_Remove_Tier__, Do_Remove_Tier__, Check_Remove_Row__, Do_Remove_Row__, Check_Remove_Bin__, Do_Remove_Bin__ 
--  121119          Remove_Whse_Structure_Node___ Methods.
--  120425  JeLise  Changed the text for error message ZONERANK in Check_Whse_Node_Ranking___.
--  120322  LEPESE  Modification in Get_Best_Bin_Ranking___ to only use ranking from putaway zone for location types
--                  PICKING, F, MANUFACTURING, PALLET, DEEP and BUFFER.
--  120321  MaEelk  Corrected grammer in the error message ZONELINEEXIST at Part_Zone_Exist___.
--  120315  MaEelk  Removed the last parameter TRUE in call General_SYS.Init_Method from  non-implementation methods
--  120313  JeLise  Added check in method Copy to see if the copying of part is within the same site, if not we will not copy putaway zones.
--  120220  LEPESE  Added ranking to return collection in Get_Putaway_Zones.
--  120217  LEPESE  Added method Get_Zone_And_Fifo_Sorted_Stock (ver 3).
--  120215  LEPESE  Added consideration to Putaway_Zone_Refill_Option in method Get_Zone_And_Fifo_Sorted_Stock.
--  120203  LEPESE  Added methods Part_Has_Operative_Zone, Location_Is_In_Best_Ranked and Get_Best_Part_Ranking___.
--  120202  LEPESE  Added sorting on warehouse, bay, row, tier, bin in Get_Zone_And_Fifo_Sorted_Stock.
--  120131  LEPESE  Added methods Get_Best_Location_Ranking, Get_Zone_And_Fifo_Sorted_Stock (ver 2)
--  120131          and Location_Is_In_Operative_Zone. Added parameter always_use_zones_ to method Get_Best_Bin_Ranking___.
--  111202  LEPESE  Added call to Site_Invent_Info_API.Get_Use_Zone_Rank_Auto_Rsrv_Db in Get_Best_Bin_Ranking___.
--  111129  LEPESE  Added use of Utility_SYS.String_To_Number for sorting of warehouse_id, bay_id, 
--  111129          row_id, tier_id and bin_id in view INVENT_PART_OPERATIVE_ZONE and method Get_Putaway_Zones.
--  111118  LEPESE  Added pallet_id in Get_Zone_And_Fifo_Sorted_Stock.
--  111109  LEPESE  Added Get_Zone_And_Fifo_Sorted_Stock and Get_Best_bin_Ranking___.
--  110720  MaEelk  Added UIV INVENT_PART_OPERATIVE_ZONE_UIV.
--  110707  MaEelk  Added user allowed site filter to INVENT_PART_PUTAWAY_ZONE.
--  101027  JeLise  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Putaway_Zone_Rec IS RECORD (
   sequence_no          INVENT_PART_PUTAWAY_ZONE_TAB.sequence_no%TYPE,
   source_db            VARCHAR2(30),
   max_bins_per_part    INVENT_PART_PUTAWAY_ZONE_TAB.max_bins_per_part%TYPE,
   ranking              INVENT_PART_PUTAWAY_ZONE_TAB.ranking%TYPE,
   storage_zone_id      INVENT_PART_PUTAWAY_ZONE_TAB.storage_zone_id%TYPE);

TYPE Putaway_Zone_Tab IS TABLE OF Putaway_Zone_Rec
INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

positive_infinity_  CONSTANT NUMBER      := Inventory_Putaway_Manager_API.positive_infinity_;
last_calendar_date_ CONSTANT DATE        := Database_SYS.Last_Calendar_Date_;
last_character_     CONSTANT VARCHAR2(1) := Database_SYS.Get_Last_Character;

TYPE Homogeneous_Handling_Unit_Rec IS RECORD (
   handling_unit_id        NUMBER,
   parent_handling_unit_id NUMBER,
   quantity                NUMBER,
   node_level              NUMBER,
   expiration_date         DATE,
   receipt_date            DATE,
   best_bin_ranking        NUMBER );

TYPE Homogeneous_Handling_Unit_Tab IS TABLE OF Homogeneous_Handling_Unit_Rec INDEX BY PLS_INTEGER;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Sequence_No___(
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   next_seq_ NUMBER;

   CURSOR get_next_seq IS
      SELECT NVL(MAX(sequence_no),0) + 1
      FROM INVENT_PART_PUTAWAY_ZONE_TAB
      WHERE contract = contract_
      AND   part_no  = part_no_;
BEGIN
   OPEN  get_next_seq;
   FETCH get_next_seq INTO next_seq_;
   CLOSE get_next_seq;
   RETURN next_seq_;
END Get_Next_Sequence_No___;


PROCEDURE Part_Zone_Exist___ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   storage_zone_id_  IN VARCHAR2 )
IS
   dummy_ NUMBER;

   CURSOR exist_control IS
      SELECT 1
        FROM INVENT_PART_PUTAWAY_ZONE_TAB
       WHERE contract        = contract_
         AND part_no         = part_no_
         AND storage_zone_id = storage_zone_id_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      Error_SYS.Record_General(lu_name_, 'ZONELINEEXIST: Putaway Zone :P1 already exists for Inventory Part :P2.', storage_zone_id_, part_no_);
   END IF;
   CLOSE exist_control;
END Part_Zone_Exist___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('REMOVED', Fnd_Boolean_API.Decode('FALSE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT INVENT_PART_PUTAWAY_ZONE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.sequence_no := Get_Next_Sequence_No___(newrec_.contract, newrec_.part_no);
   Client_SYS.Add_To_Attr('SEQUENCE_NO', newrec_.sequence_no, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


FUNCTION Get_Best_Bin_Ranking___ (
   contract_                   IN VARCHAR2,
   part_no_                    IN VARCHAR2,
   warehouse_id_               IN VARCHAR2,
   bay_id_                     IN VARCHAR2,
   tier_id_                    IN VARCHAR2,
   row_id_                     IN VARCHAR2,
   bin_id_                     IN VARCHAR2,
   use_hu_reservation_ranking_ IN BOOLEAN DEFAULT FALSE ) RETURN NUMBER
IS
   best_bin_ranking_         NUMBER;
   location_type_db_         VARCHAR2(20);
   sql_where_expression_     VARCHAR2(28000);
   dummy_                    NUMBER;
   ranking_                  NUMBER;
   hu_reservation_ranking_   NUMBER;
   bin_ranking_tmp_is_empty_ BOOLEAN := FALSE;
   putaway_bin_tab_          Warehouse_Bay_Bin_API.Putaway_Bin_Tab;   
   db_picking_               CONSTANT VARCHAR2(7)  := Inventory_Location_Type_API.db_picking;
   db_floor_stock_           CONSTANT VARCHAR2(1)  := Inventory_Location_Type_API.db_floor_stock;
   db_production_line_       CONSTANT VARCHAR2(13) := Inventory_Location_Type_API.db_production_line;

   CURSOR get_zones IS
      SELECT ranking, handl_unit_reservation_ranking, storage_zone_id, source_db
      FROM invent_part_operative_zone
      WHERE contract = contract_
      AND   part_no = part_no_
      ORDER BY ranking ASC;

   CURSOR exist_control IS
      SELECT 1
      FROM invent_part_bin_ranking_tmp
       WHERE contract = contract_
         AND part_no  = part_no_;

   CURSOR get_bin_ranking IS
      SELECT ranking, handl_unit_reservation_ranking
        FROM invent_part_bin_ranking_tmp
       WHERE contract     = contract_    
         AND part_no      = part_no_         
         AND warehouse_id = warehouse_id_
         AND bay_id       = bay_id_      
         AND tier_id      = tier_id_         
         AND row_id       = row_id_           
         AND bin_id       = bin_id_;
BEGIN
   location_type_db_ := Warehouse_Bay_Bin_API.Get_Location_Type_Db(contract_, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_);

   IF (location_type_db_ IN (db_picking_, db_floor_stock_, db_production_line_)) THEN
      OPEN exist_control;
      FETCH exist_control INTO dummy_;
      IF (exist_control%NOTFOUND) THEN
         bin_ranking_tmp_is_empty_ := TRUE;
      END IF;
      CLOSE exist_control;

      IF (bin_ranking_tmp_is_empty_) THEN
         -- Load the best bin ranking for every bin in every zone connected to the part. This happens only once in the session.
         FOR zone_ IN get_zones LOOP
            sql_where_expression_ := Invent_Part_Putaway_Zone_API.Get_Sql_Where_Expression(contract_, zone_.storage_zone_id, zone_.source_db);
             putaway_bin_tab_     := Warehouse_Bay_Bin_API.Get_Putaway_Bins(contract_, sql_where_expression_);

             IF (putaway_bin_tab_.COUNT > 0) THEN
                FOR i IN putaway_bin_tab_.FIRST..putaway_bin_tab_.LAST LOOP
                   BEGIN
                      INSERT INTO invent_part_bin_ranking_tmp (
                          contract,
                          part_no,
                          warehouse_id,
                          bay_id,
                          tier_id,
                          row_id,
                          bin_id,
                          ranking,
                          handl_unit_reservation_ranking )
                      VALUES (
                          contract_,
                          part_no_,
                          putaway_bin_tab_(i).warehouse_id,
                          putaway_bin_tab_(i).bay_id,
                          putaway_bin_tab_(i).tier_id,
                          putaway_bin_tab_(i).row_id,
                          putaway_bin_tab_(i).bin_id,
                          zone_.ranking,
                          zone_.handl_unit_reservation_ranking );
                   EXCEPTION
                      -- We do have a unique index on contract, part_no, warehouse_id, bay_id, tier_id, row_id, bin_id and since we are inserting records
                      -- based on a sorted putaway_zone_tab this makes sure that the location for the part is only inserted in context of its best zone,
                      -- since the sorting is based on zone ranking plus max number of bins.
                      WHEN dup_val_on_index THEN
                         NULL;
                   END;
                END LOOP;
             END IF;
         END LOOP;
      END IF;

      OPEN  get_bin_ranking;
      FETCH get_bin_ranking INTO ranking_, hu_reservation_ranking_;
      CLOSE get_bin_ranking;

      best_bin_ranking_ := CASE use_hu_reservation_ranking_ WHEN TRUE THEN hu_reservation_ranking_ ELSE ranking_ END;
   END IF;

   RETURN (NVL(best_bin_ranking_, positive_infinity_));
END Get_Best_Bin_Ranking___;


FUNCTION Get_Best_Part_Ranking___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   best_part_ranking_ NUMBER;

   CURSOR get_best_part_ranking IS
      SELECT MIN(ranking)
        FROM invent_part_operative_zone
       WHERE contract = contract_
         AND part_no  = part_no_;
BEGIN
   OPEN  get_best_part_ranking;
   FETCH get_best_part_ranking INTO best_part_ranking_;
   CLOSE get_best_part_ranking;

   RETURN (NVL(best_part_ranking_, positive_infinity_));
END Get_Best_Part_Ranking___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     invent_part_putaway_zone_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY invent_part_putaway_zone_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF (newrec_.handl_unit_reservation_ranking IS NULL) THEN
      newrec_.handl_unit_reservation_ranking := newrec_.ranking;
   END IF;
   
   super (oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT invent_part_putaway_zone_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.removed IS NULL) THEN
      newrec_.removed := Fnd_Boolean_API.DB_FALSE;
   END IF;
   
   super(newrec_, indrec_, attr_);

   IF newrec_.ranking < 1 OR (newrec_.ranking != ROUND(newrec_.ranking)) THEN
      Error_SYS.Record_General(lu_name_,'RANKING: Ranking must be an integer greater than 0.');
   END IF;

   Part_Zone_Exist___(newrec_.contract, newrec_.part_no, newrec_.storage_zone_id);

   IF newrec_.max_bins_per_part IS NOT NULL THEN
      IF newrec_.max_bins_per_part < 1 OR (newrec_.max_bins_per_part != ROUND(newrec_.max_bins_per_part)) THEN
         Error_SYS.Record_General(lu_name_,'MAXBINSPERPART: Max Bins per Part must be an integer greater than 0.');
      END IF;
   END IF;
END Check_Insert___;


FUNCTION Total_Hu_Struct_Is_Avail___ (
   contract_               IN VARCHAR2,
   stock_keys_and_qty_tab_ IN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab,
   available_stock_tab_    IN Inventory_Part_In_Stock_API.Available_Stock_Tab ) RETURN BOOLEAN
IS
   total_hu_struct_is_available_ BOOLEAN := TRUE;
   stock_rec_is_fully_available_ BOOLEAN;
BEGIN
   -- No check for COUNT > 0 since both collections must have a content. 
   FOR i IN stock_keys_and_qty_tab_.FIRST..stock_keys_and_qty_tab_.LAST LOOP
      FOR j IN available_stock_tab_.FIRST..available_stock_tab_.LAST LOOP
         stock_rec_is_fully_available_ := FALSE;
         IF ((contract_                                = stock_keys_and_qty_tab_(i).contract        ) AND 
             (available_stock_tab_(j).part_no          = stock_keys_and_qty_tab_(i).part_no         ) AND 
             (available_stock_tab_(j).configuration_id = stock_keys_and_qty_tab_(i).configuration_id) AND 
             (available_stock_tab_(j).location_no      = stock_keys_and_qty_tab_(i).location_no     ) AND 
             (available_stock_tab_(j).lot_batch_no     = stock_keys_and_qty_tab_(i).lot_batch_no    ) AND 
             (available_stock_tab_(j).serial_no        = stock_keys_and_qty_tab_(i).serial_no       ) AND 
             (available_stock_tab_(j).eng_chg_level    = stock_keys_and_qty_tab_(i).eng_chg_level   ) AND 
             (available_stock_tab_(j).waiv_dev_rej_no  = stock_keys_and_qty_tab_(i).waiv_dev_rej_no ) AND 
             (available_stock_tab_(j).activity_seq     = stock_keys_and_qty_tab_(i).activity_seq    ) AND 
             (available_stock_tab_(j).handling_unit_id = stock_keys_and_qty_tab_(i).handling_unit_id) AND 
             (available_stock_tab_(j).qty_available    = stock_keys_and_qty_tab_(i).quantity        )) THEN
            stock_rec_is_fully_available_ := TRUE;
            EXIT;
         END IF;
      END LOOP;
      IF NOT (stock_rec_is_fully_available_) THEN
         total_hu_struct_is_available_ := FALSE;
         EXIT;
      END IF;
   END LOOP;

   RETURN (total_hu_struct_is_available_);
END Total_Hu_Struct_Is_Avail___;


FUNCTION Get_Total_Hu_Struct_Qty___ (
   stock_keys_and_qty_tab_ IN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab) RETURN NUMBER
IS
   quantity_ NUMBER := 0;
BEGIN
   FOR i IN stock_keys_and_qty_tab_.FIRST..stock_keys_and_qty_tab_.LAST LOOP
      quantity_ := quantity_ + stock_keys_and_qty_tab_(i).quantity;
   END LOOP;
   RETURN (quantity_);
END Get_Total_Hu_Struct_Qty___;


PROCEDURE Get_Earliest_Dates___ (
   earliest_expiration_date_ OUT DATE,
   earliest_receipt_date_    OUT DATE,
   contract_                 IN  VARCHAR2,
   stock_keys_and_qty_tab_   IN  Inventory_Part_In_Stock_API.Keys_And_Qty_Tab,
   available_stock_tab_      IN  Inventory_Part_In_Stock_API.Available_Stock_Tab )
IS
BEGIN
   earliest_receipt_date_    := last_calendar_date_;
   earliest_expiration_date_ := last_calendar_date_;
   -- No check for COUNT > 0 since both collections must have a content. 
   FOR i IN stock_keys_and_qty_tab_.FIRST..stock_keys_and_qty_tab_.LAST LOOP
      FOR j IN available_stock_tab_.FIRST..available_stock_tab_.LAST LOOP
         IF ((contract_                                = stock_keys_and_qty_tab_(i).contract        ) AND 
             (available_stock_tab_(j).part_no          = stock_keys_and_qty_tab_(i).part_no         ) AND 
             (available_stock_tab_(j).configuration_id = stock_keys_and_qty_tab_(i).configuration_id) AND 
             (available_stock_tab_(j).location_no      = stock_keys_and_qty_tab_(i).location_no     ) AND 
             (available_stock_tab_(j).lot_batch_no     = stock_keys_and_qty_tab_(i).lot_batch_no    ) AND 
             (available_stock_tab_(j).serial_no        = stock_keys_and_qty_tab_(i).serial_no       ) AND 
             (available_stock_tab_(j).eng_chg_level    = stock_keys_and_qty_tab_(i).eng_chg_level   ) AND 
             (available_stock_tab_(j).waiv_dev_rej_no  = stock_keys_and_qty_tab_(i).waiv_dev_rej_no ) AND 
             (available_stock_tab_(j).activity_seq     = stock_keys_and_qty_tab_(i).activity_seq    ) AND 
             (available_stock_tab_(j).handling_unit_id = stock_keys_and_qty_tab_(i).handling_unit_id)) THEN
            IF (available_stock_tab_(j).expiration_date IS NOT NULL) THEN
               IF (available_stock_tab_(j).expiration_date < earliest_expiration_date_) THEN
                  earliest_expiration_date_ := available_stock_tab_(j).expiration_date;
               END IF;               
            END IF;
            IF (available_stock_tab_(j).receipt_date IS NOT NULL) THEN
               IF (available_stock_tab_(j).receipt_date < earliest_receipt_date_) THEN
                  earliest_receipt_date_ := available_stock_tab_(j).receipt_date;
               END IF;               
            END IF;
            EXIT;            
         END IF;
      END LOOP;
   END LOOP;

END Get_Earliest_Dates___;


PROCEDURE Get_Homogen_Hu_Node_Info___ (
   homogeneous_handling_unit_tab_ IN OUT Homogeneous_Handling_Unit_Tab,
   handling_unit_id_              IN     NUMBER,
   contract_                      IN     VARCHAR2,
   available_stock_tab_           IN     Inventory_Part_In_Stock_API.Available_Stock_Tab,
   qty_to_find_                   IN     NUMBER,
   zone_ranking_is_enabled_       IN     BOOLEAN,
   best_bin_ranking_              IN     NUMBER,
   available_stock_tab_index_     IN     PLS_INTEGER )
IS
   stock_keys_and_qty_tab_     Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   index_                      PLS_INTEGER := homogeneous_handling_unit_tab_.COUNT + 1;
   total_hu_struct_qty_        NUMBER;
   handling_unit_type_id_      VARCHAR2(25);
   use_hu_reservation_rank_db_ VARCHAR2(5);
   homogeneous_handling_unit_rec_ Homogeneous_Handling_Unit_Rec;
   investigate_parent_            BOOLEAN := FALSE;      
BEGIN
   homogeneous_handling_unit_rec_ := Get_Homogeneous_Hu_From_Tmp___(handling_unit_id_);
   
   IF (homogeneous_handling_unit_rec_.handling_unit_id IS NOT NULL) THEN
      homogeneous_handling_unit_tab_(index_) := homogeneous_handling_unit_rec_;
      investigate_parent_ := TRUE;
   ELSE   
      stock_keys_and_qty_tab_ := Handling_Unit_API.Get_Part_Stock_Onhand_Content(handling_unit_id_);

      IF (Total_Hu_Struct_Is_Avail___(contract_, stock_keys_and_qty_tab_, available_stock_tab_)) THEN
         -- All stock records connected to the handling unit is fully available to reserve. There are no stock records with different
         -- primary key values (part, config, lot, serial, wdr, revision, activity_seq) and there is no already reserved quantity on any
         -- of the stock records
         total_hu_struct_qty_ := Get_Total_Hu_Struct_Qty___(stock_keys_and_qty_tab_);

         IF (total_hu_struct_qty_ <= qty_to_find_) THEN
            -- This homogeneous handling unit can be used for the demand quantity. It does not contain more than needed so we can pick the whole HU.
            homogeneous_handling_unit_tab_(index_).handling_unit_id         := handling_unit_id_;
            homogeneous_handling_unit_tab_(index_).quantity                 := total_hu_struct_qty_;
            homogeneous_handling_unit_tab_(index_).node_level               := Handling_Unit_API.Get_Node_Level(handling_unit_id_);
            homogeneous_handling_unit_tab_(index_).parent_handling_unit_id  := Handling_Unit_API.Get_Parent_Handling_Unit_Id(handling_unit_id_);

            Get_Earliest_Dates___(homogeneous_handling_unit_tab_(index_).expiration_date,
                                  homogeneous_handling_unit_tab_(index_).receipt_date,
                                  contract_,
                                  stock_keys_and_qty_tab_,
                                  available_stock_tab_);

            IF (zone_ranking_is_enabled_) THEN
               handling_unit_type_id_      := Handling_Unit_API.Get_Handling_Unit_Type_Id(handling_unit_id_);
               use_hu_reservation_rank_db_ := Handling_Unit_type_API.Get_Use_Hu_Reservation_Rank_Db(handling_unit_type_id_);
               IF (use_hu_reservation_rank_db_ = Fnd_Boolean_API.DB_TRUE) THEN
                  homogeneous_handling_unit_tab_(index_).best_bin_ranking := Get_Best_Bin_Ranking___(contract_,
                                                                                                     available_stock_tab_(available_stock_tab_index_).part_no,
                                                                                                     available_stock_tab_(available_stock_tab_index_).warehouse,
                                                                                                     available_stock_tab_(available_stock_tab_index_).bay_no,
                                                                                                     available_stock_tab_(available_stock_tab_index_).tier_no,
                                                                                                     available_stock_tab_(available_stock_tab_index_).row_no,
                                                                                                     available_stock_tab_(available_stock_tab_index_).bin_no,
                                                                                                     use_hu_reservation_ranking_ => TRUE);
               ELSE
                  -- No HU-specific ranking for this HU Type. So use the same ranking as for unpacked items.
                  homogeneous_handling_unit_tab_(index_).best_bin_ranking := best_bin_ranking_;
               END IF;
            ELSE
               -- zone ranking is not enabled so just assign a very high value.
               homogeneous_handling_unit_tab_(index_).best_bin_ranking := positive_infinity_;
            END IF;            
            investigate_parent_ := TRUE;
         END IF;
      END IF;
   END IF;

   IF (investigate_parent_)  THEN
      IF ((homogeneous_handling_unit_tab_(index_).parent_handling_unit_id IS NOT NULL   ) AND
          (homogeneous_handling_unit_tab_(index_).quantity                < qty_to_find_)) THEN
         -- There is a parent which might also be homogeneous and completely available, and the reservation request is for a bigger
         -- quantity than the quantity that is available at the current handling unit structure level.
         -- There is no point in trying to find a complete pallet if only a few pieces are requested for the reservation.
         Get_Homogen_Hu_Node_Info___(homogeneous_handling_unit_tab_,
                                     homogeneous_handling_unit_tab_(index_).parent_handling_unit_id,
                                     contract_,
                                     available_stock_tab_,
                                     qty_to_find_,
                                     zone_ranking_is_enabled_,
                                     best_bin_ranking_,
                                     available_stock_tab_index_);
      END IF;
   END IF;
END Get_Homogen_Hu_Node_Info___;


FUNCTION Get_Sum_Handling_Unit_Qty___ (
   handling_unit_id_    IN NUMBER,
   available_stock_tab_ IN Inventory_Part_In_Stock_API.Available_Stock_Tab ) RETURN NUMBER
IS
   sum_available_quantity_ NUMBER := 0;
BEGIN
   FOR i IN available_stock_tab_.FIRST..available_stock_tab_.LAST LOOP
      IF (available_stock_tab_(i).handling_unit_id = handling_unit_id_) THEN
         sum_available_quantity_ := sum_available_quantity_ + available_stock_tab_(i).qty_available;
      END IF;
   END LOOP;
   RETURN (sum_available_quantity_);
END Get_Sum_Handling_Unit_Qty___;


PROCEDURE Get_Sum_Location_Quantities___ (
   sum_quantity_          OUT NUMBER,
   sum_unpacked_quantity_ OUT NUMBER,
   location_no_           IN  VARCHAR2,
   available_stock_tab_   IN  Inventory_Part_In_Stock_API.Available_Stock_Tab )
IS
BEGIN
   sum_quantity_          := 0;
   sum_unpacked_quantity_ := 0;
   FOR i IN available_stock_tab_.FIRST..available_stock_tab_.LAST LOOP
      IF (available_stock_tab_(i).location_no = location_no_) THEN
         sum_quantity_ := sum_quantity_ + available_stock_tab_(i).qty_available;
         IF (available_stock_tab_(i).handling_unit_id = 0) THEN
            sum_unpacked_quantity_ := sum_unpacked_quantity_ + available_stock_tab_(i).qty_available;
         END IF;
      END IF;
   END LOOP;
END Get_Sum_Location_Quantities___;


FUNCTION Zone_Ranking_Is_Enabled___ (
   site_rec_ IN Site_Invent_Info_API.Public_Rec ) RETURN BOOLEAN
IS
   zone_ranking_is_enabled_ BOOLEAN := FALSE;
BEGIN
   IF site_rec_.auto_reserve_prio1 = Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING OR
      site_rec_.auto_reserve_prio2 = Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING OR
      site_rec_.auto_reserve_prio3 = Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING OR
      site_rec_.auto_reserve_prio4 = Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING OR
      site_rec_.auto_reserve_prio5 = Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN
      zone_ranking_is_enabled_ := TRUE;
   END IF;
   RETURN (zone_ranking_is_enabled_);
END Zone_Ranking_Is_Enabled___;

FUNCTION Get_Homogeneous_Hu_From_Tmp___ (
   handling_unit_id_ IN NUMBER ) RETURN Homogeneous_Handling_Unit_Rec
IS
   homogeneous_handling_unit_rec_ Homogeneous_Handling_Unit_Rec;
   CURSOR get_homogeneous_handling_unit IS                   
      SELECT homogeneous_handling_unit_id,
             DECODE(homogen_handl_unit_parent_id, 0, NULL) homogen_handl_unit_parent_id,
             homogeneous_hu_node_qty,
             homogeneous_hu_node_level,
             homogeneous_hu_expiration_date,
             homogeneous_hu_receipt_date,
             homogeneous_hu_zone_ranking
        FROM inventory_part_avail_stock_tmp
       WHERE homogeneous_handling_unit_id = handling_unit_id_;
BEGIN
   OPEN get_homogeneous_handling_unit;
   FETCH get_homogeneous_handling_unit INTO homogeneous_handling_unit_rec_;
   CLOSE get_homogeneous_handling_unit;

   RETURN (homogeneous_handling_unit_rec_);
END Get_Homogeneous_Hu_From_Tmp___;    


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Create_Removed_Line__ (
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   sequence_no_      IN NUMBER,
   storage_zone_id_  IN VARCHAR2,   
   ranking_          IN NUMBER )
IS
   attr_       VARCHAR2(32000);
   objid_      INVENT_PART_PUTAWAY_ZONE.objid%TYPE;
   objversion_ INVENT_PART_PUTAWAY_ZONE.objversion%TYPE;
   newrec_     INVENT_PART_PUTAWAY_ZONE_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('STORAGE_ZONE_ID', storage_zone_id_,   attr_);   
   Client_SYS.Add_To_Attr('RANKING', ranking_, attr_);
   Client_SYS.Add_To_Attr('REMOVED_DB', 'TRUE', attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Create_Removed_Line__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Storage_Zone_Description (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2,
   source_db_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   storage_zone_description_ VARCHAR2(2000);
BEGIN   
   IF (source_db_ = Part_Putaway_Zone_Level_API.DB_REMOTE_WAREHOUSE_ASSORTMENT) THEN
      storage_zone_description_ := Warehouse_API.Get_Description(contract_, storage_zone_id_);
   ELSE
      storage_zone_description_ := Storage_Zone_API.Get_Description(contract_, storage_zone_id_);
   END IF;
   RETURN (storage_zone_description_);
END Get_Storage_Zone_Description;

@UncheckedAccess
FUNCTION Get_Putaway_Zones (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN Putaway_Zone_Tab
IS
   putaway_zone_tab_ Putaway_Zone_Tab;

   CURSOR get_putaway_zone IS
      SELECT sequence_no,
             source_db,
             max_bins_per_part,
             ranking,
             storage_zone_id
      FROM INVENT_PART_OPERATIVE_ZONE
      WHERE contract = contract_
      AND   part_no  = part_no_
      ORDER BY ranking, NVL(max_bins_per_part, positive_infinity_);
BEGIN
   OPEN get_putaway_zone;
   FETCH get_putaway_zone BULK COLLECT INTO putaway_zone_tab_;
   CLOSE get_putaway_zone;

   RETURN(putaway_zone_tab_);
END Get_Putaway_Zones;


PROCEDURE Copy (
   new_contract_ IN VARCHAR2,
   new_part_no_  IN VARCHAR2,
   old_contract_ IN VARCHAR2,
   old_part_no_  IN VARCHAR2 )
IS
   newrec_     INVENT_PART_PUTAWAY_ZONE_TAB%ROWTYPE;
   objid_      INVENT_PART_PUTAWAY_ZONE.objid%TYPE;
   objversion_ INVENT_PART_PUTAWAY_ZONE.objversion%TYPE;
   attr_       VARCHAR2(32000);
   indrec_     Indicator_Rec;
   CURSOR get_putaway_zones IS
      SELECT *
        FROM INVENT_PART_PUTAWAY_ZONE_TAB
       WHERE contract = old_contract_
         AND part_no = old_part_no_;
BEGIN
   IF (new_contract_ = old_contract_) THEN 
      FOR putaway_zones_rec_ IN get_putaway_zones LOOP
         -- Initialize variables
         Client_SYS.Clear_Attr(attr_);
         newrec_     := NULL;
         objid_      := NULL;
         objversion_ := NULL;

         Client_SYS.Add_To_Attr('CONTRACT',          new_contract_,                        attr_);
         Client_SYS.Add_To_Attr('PART_NO',           new_part_no_,                         attr_);
         Client_SYS.Add_To_Attr('STORAGE_ZONE_ID',   putaway_zones_rec_.storage_zone_id,   attr_);         
         Client_SYS.Add_To_Attr('RANKING',           putaway_zones_rec_.ranking,           attr_);
         Client_SYS.Add_To_Attr('REMOVED_DB',        putaway_zones_rec_.removed,           attr_);
         Client_SYS.Add_To_Attr('MAX_BINS_PER_PART', putaway_zones_rec_.max_bins_per_part, attr_);

         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;
END Copy;


FUNCTION Get_Zone_And_Fifo_Sorted_Stock (
   contract_                      IN VARCHAR2,
   part_no_                       IN VARCHAR2,
   available_stock_tab_           IN Inventory_Part_In_Stock_API.Available_Stock_Tab,
   prioritize_large_handl_units_  IN BOOLEAN,
   consume_partial_handling_unit_ IN BOOLEAN,
   qty_to_find_                   IN NUMBER ) RETURN Inventory_Part_In_Stock_API.Available_Stock_Tab
IS
   sorted_available_stock_tab_    Inventory_Part_In_Stock_API.Available_Stock_Tab;
   site_rec_                      Site_Invent_Info_API.Public_Rec;
   best_bin_ranking_              NUMBER;
   previous_location_no_          VARCHAR2(35) := Database_SYS.string_null_;
   previous_handling_unit_id_     NUMBER       := -999999999;
   homogeneous_handling_unit_tab_ Homogeneous_Handling_Unit_Tab;
   empty_tab_                     Homogeneous_Handling_Unit_Tab;
   partial_hu_node_level_         NUMBER;
   partial_hu_node_qty_           NUMBER;
   partial_handling_unit_id_      NUMBER;
   sum_location_quantity_         NUMBER;
   sum_location_unpacked_qty_     NUMBER;
   sum_location_qty_to_be_used_   NUMBER;
   zone_ranking_is_enabled_       BOOLEAN;

   CURSOR get_sorted_available_stock IS
      SELECT part_no_ part_no,
             location_no,      
             lot_batch_no,     
             serial_no,        
             eng_chg_level,    
             waiv_dev_rej_no,  
             configuration_id, 
             activity_seq,     
             handling_unit_id,
             qty_available,    
             warehouse_id,     
             bay_id,           
             tier_id,          
             row_id,           
             bin_id,           
             expiration_date,  
             receipt_date,
             warehouse_route_order,
             bay_route_order,
             row_route_order,
             tier_route_order,
             bin_route_order,
             homogeneous_hu_node_qty,
             homogeneous_handling_unit_id
      FROM inventory_part_avail_stock_tmp
      ORDER BY (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN homogeneous_hu_zone_ranking    ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN homogeneous_hu_expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN homogeneous_hu_receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY    THEN homogeneous_hu_node_qty        ELSE 0                   END) DESC,
               (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL  THEN homogeneous_hu_node_level      ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN homogeneous_hu_zone_ranking    ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN homogeneous_hu_expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN homogeneous_hu_receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY    THEN homogeneous_hu_node_qty        ELSE 0                   END) DESC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL  THEN homogeneous_hu_node_level      ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN homogeneous_hu_zone_ranking    ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN homogeneous_hu_expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN homogeneous_hu_receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY    THEN homogeneous_hu_node_qty        ELSE 0                   END) DESC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL  THEN homogeneous_hu_node_level      ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN homogeneous_hu_zone_ranking    ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN homogeneous_hu_expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN homogeneous_hu_receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY    THEN homogeneous_hu_node_qty        ELSE 0                   END) DESC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL  THEN homogeneous_hu_node_level      ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN homogeneous_hu_zone_ranking    ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN homogeneous_hu_expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN homogeneous_hu_receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_QTY    THEN homogeneous_hu_node_qty        ELSE 0                   END) DESC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_HANDLING_UNIT_LEVEL  THEN homogeneous_hu_node_level      ELSE 0                   END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN  0  ELSE sum_location_quantity                               END) DESC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(warehouse_route_order) END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(warehouse_route_order)                        END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(bay_route_order)       END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(bay_route_order,
                                                                                    Warehouse_Bay_API.default_bay_id_,
                                                                                    last_character_,
                                                                                    bay_route_order))                      END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(row_route_order)       END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(row_route_order,
                                                                                    Warehouse_Bay_Row_API.default_row_id_,
                                                                                    last_character_,
                                                                                    row_route_order))                      END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(tier_route_order)      END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(tier_route_order,
                                                                                    Warehouse_Bay_Tier_API.default_tier_id_,
                                                                                    last_character_,
                                                                                    tier_route_order))                     END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(bin_route_order)       END) ASC,
               (CASE homogeneous_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(bin_route_order,
                                                                                    Warehouse_Bay_Bin_API.default_bin_id_,
                                                                                    last_character_,
                                                                                    bin_route_order))                      END) ASC,
               homogen_handl_unit_parent_id,
               homogeneous_handling_unit_id,
               (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN ranking         ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio1 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN ranking         ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio2 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN ranking         ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio3 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN ranking         ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio4 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN receipt_date    ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_PUTAWAY_ZONE_RANKING THEN ranking         ELSE 0                   END) ASC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_EXPIRATION_DATE      THEN expiration_date ELSE last_calendar_date_ END) ASC,
               (CASE site_rec_.auto_reserve_prio5 WHEN Invent_Auto_Reserve_Prio_API.DB_RECEIPT_DATE         THEN receipt_date    ELSE last_calendar_date_ END) ASC,
               partial_hu_node_level,
               partial_hu_node_qty,
               (CASE partial_handling_unit_id WHEN 0 THEN  0  ELSE sum_location_quantity                               END) DESC,
               (CASE partial_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(warehouse_route_order) END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(warehouse_route_order)                        END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(bay_route_order)       END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(bay_route_order,
                                                                                    Warehouse_Bay_API.default_bay_id_,
                                                                                    last_character_,
                                                                                    bay_route_order))                  END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(row_route_order)       END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(row_route_order,
                                                                                    Warehouse_Bay_Row_API.default_row_id_,
                                                                                    last_character_,
                                                                                    row_route_order))                  END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(tier_route_order)      END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(tier_route_order,
                                                                                    Warehouse_Bay_Tier_API.default_tier_id_,
                                                                                    last_character_,
                                                                                    tier_route_order))                 END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN  0  ELSE Utility_SYS.String_To_Number(bin_route_order)       END) ASC,
               (CASE partial_handling_unit_id WHEN 0 THEN '0' ELSE UPPER(decode(bin_route_order,
                                                                                    Warehouse_Bay_Bin_API.default_bin_id_,
                                                                                    last_character_,
                                                                                    bin_route_order))                  END) ASC,
               partial_handling_unit_id,
               lot_batch_no, 
               serial_no,
               sum_location_quantity DESC,
               Utility_SYS.String_To_Number(warehouse_route_order) ASC,
               UPPER(warehouse_route_order) ASC,
               Utility_SYS.String_To_Number(bay_route_order) ASC,
               UPPER(decode(bay_route_order,  Warehouse_Bay_API.default_bay_id_,       last_character_, bay_route_order))  ASC,
               Utility_SYS.String_To_Number(row_route_order) ASC,
               UPPER(decode(row_route_order,  Warehouse_Bay_Row_API.default_row_id_,   last_character_, row_route_order))  ASC,
               Utility_SYS.String_To_Number(tier_route_order) ASC,
               UPPER(decode(tier_route_order, Warehouse_Bay_Tier_API.default_tier_id_, last_character_, tier_route_order)) ASC,
               Utility_SYS.String_To_Number(bin_route_order) ASC,
               UPPER(decode(bin_route_order,  Warehouse_Bay_Bin_API.default_bin_id_,   last_character_, bin_route_order))  ASC,
               handling_unit_id;

   CURSOR Get_Sum_Loc_Homogen_Hu_Qty IS
      SELECT location_no, SUM(qty_available) sum_location_quantity
        FROM (SELECT DISTINCT location_no, lot_batch_no, serial_no, eng_chg_level, waiv_dev_rej_no,
                              configuration_id, activity_seq,  handling_unit_id, qty_available 
                FROM inventory_part_avail_stock_tmp
               WHERE homogeneous_handling_unit_id != 0)
        GROUP BY location_no;
BEGIN
   DELETE FROM inventory_part_avail_stock_tmp;

   IF (available_stock_tab_.COUNT > 0) THEN
      site_rec_                := Site_Invent_Info_API.Get(contract_);
      zone_ranking_is_enabled_ := Zone_Ranking_Is_Enabled___(site_rec_);
      FOR i IN available_stock_tab_.FIRST..available_stock_tab_.LAST LOOP
         IF (available_stock_tab_(i).location_no != previous_location_no_) THEN
            IF (zone_ranking_is_enabled_) THEN
               best_bin_ranking_ := Get_Best_Bin_Ranking___(contract_,
                                                            part_no_,
                                                            available_stock_tab_(i).warehouse,
                                                            available_stock_tab_(i).bay_no,
                                                            available_stock_tab_(i).tier_no,
                                                            available_stock_tab_(i).row_no,
                                                            available_stock_tab_(i).bin_no);
            ELSE
               best_bin_ranking_ := positive_infinity_;
            END IF;

            previous_location_no_  := available_stock_tab_(i).location_no;
            Get_Sum_Location_Quantities___(sum_location_quantity_, sum_location_unpacked_qty_, available_stock_tab_(i).location_no, available_stock_tab_);
            IF (qty_to_find_ IS NOT NULL) THEN
               -- If we know how much that is required then it does not matter how much more than the required quantity that can
               -- be found on the location. So that is why we don't ever add more than qty_to_find_ in sum_location_quantity_.
               -- If we need 10 pcs then a location with 10 pcs available is equally good as one location with 100 pcs available.
               sum_location_quantity_     := LEAST(sum_location_quantity_    , qty_to_find_);
               sum_location_unpacked_qty_ := LEAST(sum_location_unpacked_qty_, qty_to_find_);
            END IF;
            sum_location_qty_to_be_used_ := sum_location_quantity_;
         END IF;

         IF (site_rec_.auto_reserve_hu_optimized = Fnd_Boolean_API.DB_TRUE) THEN
            IF (prioritize_large_handl_units_) THEN
               IF (available_stock_tab_(i).handling_unit_id = 0) THEN
                  sum_location_qty_to_be_used_ := sum_location_unpacked_qty_;
               ELSE
                  sum_location_qty_to_be_used_ := sum_location_quantity_;
               END IF;
               -- The logic is supposed to put the top handling units having the greatest hogomenous completely available qty at the top of the list.
               IF (available_stock_tab_(i).handling_unit_id != previous_handling_unit_id_) THEN
                  -- Reset homogeneous_handling_unit_tab_ to make sure we get a fresh start for the new handling unit ID
                  homogeneous_handling_unit_tab_ := empty_tab_;
                  IF (available_stock_tab_(i).handling_unit_id != 0) THEN
                     -- Fetch a collection that for each lowest level handling unit displays all the parents from which we can consume it.
                     -- So for example if an item is packaged in a small box, which is packed in a big box, which is placed on a pallet,
                     -- Then we can consume the small box itself, or by consuming the big box, or by consuming the pallet. All three
                     -- options are inserted into the table. 
                     Get_Homogen_Hu_Node_Info___(homogeneous_handling_unit_tab_,
                                                 available_stock_tab_(i).handling_unit_id,
                                                 contract_,
                                                 available_stock_tab_,
                                                 qty_to_find_,
                                                 zone_ranking_is_enabled_,
                                                 best_bin_ranking_,
                                                 available_stock_tab_index_ => i);
                  END IF;
                  previous_handling_unit_id_  := available_stock_tab_(i).handling_unit_id;
               END IF;
            ELSIF (consume_partial_handling_unit_) THEN
               IF (available_stock_tab_(i).handling_unit_id != previous_handling_unit_id_) THEN
                  partial_hu_node_level_     := Handling_Unit_API.Get_Node_Level(available_stock_tab_(i).handling_unit_id);
                  partial_hu_node_qty_       := Get_Sum_Handling_Unit_Qty___(available_stock_tab_(i).handling_unit_id, available_stock_tab_);
                  partial_handling_unit_id_  := available_stock_tab_(i).handling_unit_id;
                  previous_handling_unit_id_ := available_stock_tab_(i).handling_unit_id;
               END IF;
            END IF;
         END IF;

         IF (homogeneous_handling_unit_tab_.COUNT = 0) THEN
            homogeneous_handling_unit_tab_(1).handling_unit_id        := 0;
            homogeneous_handling_unit_tab_(1).parent_handling_unit_id := 0;
            homogeneous_handling_unit_tab_(1).quantity                := 0;
            homogeneous_handling_unit_tab_(1).node_level              := positive_infinity_;
            homogeneous_handling_unit_tab_(1).expiration_date         := last_calendar_date_;
            homogeneous_handling_unit_tab_(1).receipt_date            := last_calendar_date_;
            homogeneous_handling_unit_tab_(1).best_bin_ranking        := positive_infinity_;
         END IF;

         FOR j IN homogeneous_handling_unit_tab_.FIRST..homogeneous_handling_unit_tab_.LAST LOOP
            INSERT INTO inventory_part_avail_stock_tmp
               (location_no,
                lot_batch_no,
                serial_no,
                eng_chg_level,
                waiv_dev_rej_no,
                configuration_id,
                activity_seq,
                handling_unit_id,
                qty_available,
                warehouse_id,
                bay_id,
                tier_id,
                row_id,
                bin_id,
                expiration_date,
                receipt_date,
                ranking,
                warehouse_route_order,
                bay_route_order,
                row_route_order,
                tier_route_order,
                bin_route_order,
                homogeneous_hu_node_qty,
                homogeneous_handling_unit_id,
                homogen_handl_unit_parent_id,
                homogeneous_hu_node_level,
                homogeneous_hu_expiration_date,
                homogeneous_hu_receipt_date,
                homogeneous_hu_zone_ranking,
                partial_hu_node_level,
                partial_hu_node_qty,
                partial_handling_unit_id,
                sum_location_quantity )
            VALUES
               (available_stock_tab_(i).location_no,
                available_stock_tab_(i).lot_batch_no,
                available_stock_tab_(i).serial_no,
                available_stock_tab_(i).eng_chg_level,
                available_stock_tab_(i).waiv_dev_rej_no,
                available_stock_tab_(i).configuration_id,
                available_stock_tab_(i).activity_seq,
                available_stock_tab_(i).handling_unit_id,
                available_stock_tab_(i).qty_available,
                available_stock_tab_(i).warehouse,
                available_stock_tab_(i).bay_no,
                available_stock_tab_(i).tier_no,
                available_stock_tab_(i).row_no,
                available_stock_tab_(i).bin_no,
                available_stock_tab_(i).expiration_date,
                CASE site_rec_.auto_reserve_receipt_time
                   WHEN Fnd_Boolean_API.DB_TRUE THEN available_stock_tab_(i).receipt_date 
                   ELSE TRUNC(available_stock_tab_(i).receipt_date) END,
                best_bin_ranking_,
                available_stock_tab_(i).warehouse_route_order,
                available_stock_tab_(i).bay_route_order,
                available_stock_tab_(i).row_route_order,
                available_stock_tab_(i).tier_route_order,
                available_stock_tab_(i).bin_route_order,
                homogeneous_handling_unit_tab_(j).quantity,
                homogeneous_handling_unit_tab_(j).handling_unit_id,
                NVL(homogeneous_handling_unit_tab_(j).parent_handling_unit_id, 0),
                homogeneous_handling_unit_tab_(j).node_level,
                homogeneous_handling_unit_tab_(j).expiration_date,
                CASE site_rec_.auto_reserve_receipt_time 
                   WHEN Fnd_Boolean_API.DB_TRUE THEN homogeneous_handling_unit_tab_(j).receipt_date
                   ELSE TRUNC(homogeneous_handling_unit_tab_(j).receipt_date) END,
                homogeneous_handling_unit_tab_(j).best_bin_ranking,
                NVL(partial_hu_node_level_   , 0),
                NVL(partial_hu_node_qty_     , 0),
                NVL(partial_handling_unit_id_, 0),
                sum_location_qty_to_be_used_ );
         END LOOP;
      END LOOP;

      -- For homogeneous handling units we only want to consider the total available location quantity that are in homogeneous handling units
      -- at that location. So we cannot know about that until the temporary table has been filled. Then we need to read from it and update. 
      FOR rec_ IN Get_Sum_Loc_Homogen_Hu_Qty LOOP
         UPDATE inventory_part_avail_stock_tmp
            SET sum_location_quantity         = LEAST(rec_.sum_location_quantity, NVL(qty_to_find_, rec_.sum_location_quantity))
          WHERE location_no                   = rec_.location_no
            AND homogeneous_handling_unit_id != 0;
      END LOOP;

      OPEN  get_sorted_available_stock;
      FETCH get_sorted_available_stock BULK COLLECT INTO sorted_available_stock_tab_;
      CLOSE get_sorted_available_stock;
   END IF;

   RETURN sorted_available_stock_tab_;
END Get_Zone_And_Fifo_Sorted_Stock;


FUNCTION Get_Zone_And_Fifo_Sorted_Stock (
   contract_              IN VARCHAR2,
   part_no_               IN VARCHAR2,
   available_stock_tab_   IN Inventory_Part_In_Stock_API.Available_Stock_Tab,
   refill_to_bin_ranking_ IN NUMBER ) RETURN Inventory_Part_In_Stock_API.Available_Stock_Tab
IS
   sorted_available_stock_tab_    Inventory_Part_In_Stock_API.Available_Stock_Tab;
   best_bin_ranking_              NUMBER;
   previous_location_no_          VARCHAR2(35) := Database_SYS.string_null_;
   putaway_zone_refill_option_db_ VARCHAR2(20);

   CURSOR get_sorted_available_stock IS
      SELECT part_no_ part_no,
             location_no,      
             lot_batch_no,     
             serial_no,        
             eng_chg_level,    
             waiv_dev_rej_no,  
             configuration_id, 
             activity_seq,     
             handling_unit_id,
             qty_available,    
             warehouse_id,     
             bay_id,           
             tier_id,          
             row_id,           
             bin_id,           
             expiration_date,  
             receipt_date,
             warehouse_route_order,
             bay_route_order,
             row_route_order,
             tier_route_order,
             bin_route_order,
             NULL,
             NULL
      FROM inventory_part_avail_stock_tmp
      ORDER BY expiration_date,
               receipt_date,
               ranking,
               lot_batch_no,
               serial_no,
               Utility_SYS.String_To_Number(warehouse_route_order) ASC,
               UPPER(warehouse_route_order) ASC,
               Utility_SYS.String_To_Number(bay_route_order) ASC,
               UPPER(decode(bay_route_order,  Warehouse_Bay_API.default_bay_id_,       last_character_, bay_route_order))  ASC,
               Utility_SYS.String_To_Number(row_route_order) ASC,
               UPPER(decode(row_route_order,  Warehouse_Bay_Row_API.default_row_id_,   last_character_, row_route_order))  ASC,
               Utility_SYS.String_To_Number(tier_route_order) ASC,
               UPPER(decode(tier_route_order, Warehouse_Bay_Tier_API.default_tier_id_, last_character_, tier_route_order)) ASC,
               Utility_SYS.String_To_Number(bin_route_order) ASC,
               UPPER(decode(bin_route_order,  Warehouse_Bay_Bin_API.default_bin_id_,   last_character_, bin_route_order))  ASC;
BEGIN
   DELETE FROM inventory_part_avail_stock_tmp;

   IF (available_stock_tab_.COUNT > 0) THEN
      putaway_zone_refill_option_db_ := Inventory_Part_API.Get_Putaway_Zone_Refill_Opt_Db(contract_, part_no_);

      FOR i IN available_stock_tab_.FIRST..available_stock_tab_.LAST LOOP
         IF (available_stock_tab_(i).location_no != previous_location_no_) THEN
            best_bin_ranking_ := Get_Best_Bin_Ranking___(contract_,
                                                         part_no_,
                                                         available_stock_tab_(i).warehouse,
                                                         available_stock_tab_(i).bay_no,
                                                         available_stock_tab_(i).tier_no,
                                                         available_stock_tab_(i).row_no,
                                                         available_stock_tab_(i).bin_no);

            previous_location_no_ := available_stock_tab_(i).location_no;
         END IF;

         IF ((best_bin_ranking_ > refill_to_bin_ranking_) AND 
             ((putaway_zone_refill_option_db_ = Putaway_Zone_Refill_Option_API.DB_FROM_ALL_LOCATIONS) OR
              (best_bin_ranking_ < positive_infinity_))) THEN

            INSERT INTO inventory_part_avail_stock_tmp
               (location_no,
                lot_batch_no,
                serial_no,
                eng_chg_level,
                waiv_dev_rej_no,
                configuration_id,
                activity_seq,
                handling_unit_id,
                qty_available,
                warehouse_id,
                bay_id,
                tier_id,
                row_id,
                bin_id,
                expiration_date,
                receipt_date,
                ranking,
                warehouse_route_order,
                bay_route_order,
                row_route_order,
                tier_route_order,
                bin_route_order)
            VALUES
               (available_stock_tab_(i).location_no,
                available_stock_tab_(i).lot_batch_no,
                available_stock_tab_(i).serial_no,
                available_stock_tab_(i).eng_chg_level,
                available_stock_tab_(i).waiv_dev_rej_no,
                available_stock_tab_(i).configuration_id,
                available_stock_tab_(i).activity_seq,
                available_stock_tab_(i).handling_unit_id,
                available_stock_tab_(i).qty_available,
                available_stock_tab_(i).warehouse,
                available_stock_tab_(i).bay_no,
                available_stock_tab_(i).tier_no,
                available_stock_tab_(i).row_no,
                available_stock_tab_(i).bin_no,
                available_stock_tab_(i).expiration_date,
                available_stock_tab_(i).receipt_date,
                best_bin_ranking_,
                available_stock_tab_(i).warehouse_route_order,
                available_stock_tab_(i).bay_route_order,
                available_stock_tab_(i).row_route_order,
                available_stock_tab_(i).tier_route_order,
                available_stock_tab_(i).bin_route_order);
         END IF;
      END LOOP;

      OPEN  get_sorted_available_stock;
      FETCH get_sorted_available_stock BULK COLLECT INTO sorted_available_stock_tab_;
      CLOSE get_sorted_available_stock;
   END IF;

   RETURN sorted_available_stock_tab_;
END Get_Zone_And_Fifo_Sorted_Stock;


FUNCTION Get_Zone_And_Fifo_Sorted_Stock (
   contract_              IN VARCHAR2,
   available_stock_tab_   IN Inventory_Part_In_Stock_API.Available_Stock_Tab ) RETURN Inventory_Part_In_Stock_API.Available_Stock_Tab
IS
   sorted_available_stock_tab_ Inventory_Part_In_Stock_API.Available_Stock_Tab;
   best_bin_ranking_           NUMBER;
   previous_location_no_       VARCHAR2(35) := Database_SYS.string_null_;
   previous_part_no_           VARCHAR2(25) := Database_SYS.string_null_;

   CURSOR get_sorted_available_stock IS
      SELECT part_no,
             location_no,      
             lot_batch_no,     
             serial_no,        
             eng_chg_level,    
             waiv_dev_rej_no,  
             configuration_id, 
             activity_seq,     
             handling_unit_id,
             qty_available,    
             warehouse_id,     
             bay_id,           
             tier_id,          
             row_id,           
             bin_id,           
             expiration_date,  
             receipt_date,
             warehouse_route_order,
             bay_route_order,
             row_route_order,
             tier_route_order,
             bin_route_order,
             NULL,
             NULL
      FROM inventory_part_avail_stock_tmp
      ORDER BY ranking,
               expiration_date,
               receipt_date,
               Utility_SYS.String_To_Number(warehouse_route_order) ASC,
               UPPER(warehouse_route_order) ASC,
               Utility_SYS.String_To_Number(bay_route_order) ASC,
               UPPER(decode(bay_route_order,  Warehouse_Bay_API.default_bay_id_,       last_character_, bay_route_order))  ASC,
               Utility_SYS.String_To_Number(row_route_order) ASC,
               UPPER(decode(row_route_order,  Warehouse_Bay_Row_API.default_row_id_,   last_character_, row_route_order))  ASC,
               Utility_SYS.String_To_Number(tier_route_order) ASC,
               UPPER(decode(tier_route_order, Warehouse_Bay_Tier_API.default_tier_id_, last_character_, tier_route_order)) ASC,
               Utility_SYS.String_To_Number(bin_route_order) ASC,
               UPPER(decode(bin_route_order,  Warehouse_Bay_Bin_API.default_bin_id_,   last_character_, bin_route_order))  ASC,
               part_no,
               lot_batch_no,
               serial_no;
BEGIN
   DELETE FROM inventory_part_avail_stock_tmp;

   IF (available_stock_tab_.COUNT > 0) THEN
      FOR i IN available_stock_tab_.FIRST..available_stock_tab_.LAST LOOP
         IF ((available_stock_tab_(i).location_no != previous_location_no_) OR 
             (available_stock_tab_(i).part_no     != previous_part_no_    )) THEN
            best_bin_ranking_ := Get_Best_Bin_Ranking___(contract_,
                                                         available_stock_tab_(i).part_no,
                                                         available_stock_tab_(i).warehouse,
                                                         available_stock_tab_(i).bay_no,
                                                         available_stock_tab_(i).tier_no,
                                                         available_stock_tab_(i).row_no,
                                                         available_stock_tab_(i).bin_no);

            previous_location_no_ := available_stock_tab_(i).location_no;
            previous_part_no_     := available_stock_tab_(i).part_no;
         END IF;

         INSERT INTO inventory_part_avail_stock_tmp
            (part_no,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             configuration_id,
             activity_seq,
             handling_unit_id,
             qty_available,
             warehouse_id,
             bay_id,
             tier_id,
             row_id,
             bin_id,
             expiration_date,
             receipt_date,
             ranking,
             warehouse_route_order,
             bay_route_order,
             row_route_order,
             tier_route_order,
             bin_route_order)
         VALUES
            (available_stock_tab_(i).part_no,
             available_stock_tab_(i).location_no,
             available_stock_tab_(i).lot_batch_no,
             available_stock_tab_(i).serial_no,
             available_stock_tab_(i).eng_chg_level,
             available_stock_tab_(i).waiv_dev_rej_no,
             available_stock_tab_(i).configuration_id,
             available_stock_tab_(i).activity_seq,
             available_stock_tab_(i).handling_unit_id,
             available_stock_tab_(i).qty_available,
             available_stock_tab_(i).warehouse,
             available_stock_tab_(i).bay_no,
             available_stock_tab_(i).tier_no,
             available_stock_tab_(i).row_no,
             available_stock_tab_(i).bin_no,
             available_stock_tab_(i).expiration_date,
             available_stock_tab_(i).receipt_date,
             best_bin_ranking_,
             available_stock_tab_(i).warehouse_route_order,
             available_stock_tab_(i).bay_route_order,
             available_stock_tab_(i).row_route_order,
             available_stock_tab_(i).tier_route_order,
             available_stock_tab_(i).bin_route_order);
      END LOOP;

      OPEN get_sorted_available_stock;
      FETCH get_sorted_available_stock BULK COLLECT INTO sorted_available_stock_tab_;
      CLOSE get_sorted_available_stock;
   END IF;

   RETURN sorted_available_stock_tab_;
END Get_Zone_And_Fifo_Sorted_Stock;


@UncheckedAccess
FUNCTION Location_Is_In_Operative_Zone (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   warehouse_id_                  VARCHAR2(15);
   bay_id_                        VARCHAR2(5);
   tier_id_                       VARCHAR2(5);
   row_id_                        VARCHAR2(5);
   bin_id_                        VARCHAR2(5);
   location_is_in_operative_zone_ BOOLEAN := FALSE;
   
   CURSOR get_storage_zones IS
      SELECT   storage_zone_id, source_db
      FROM     invent_part_operative_zone
      WHERE    contract = contract_
      AND      part_no = part_no_
      ORDER BY ranking ASC;
BEGIN
   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_,
                                              bay_id_,
                                              tier_id_,
                                              row_id_,
                                              bin_id_,
                                              contract_,
                                              location_no_);
   FOR zone_ IN get_storage_zones LOOP
      IF (Warehouse_Bay_Bin_API.Bin_Is_In_Storage_Zone(contract_, zone_.storage_zone_id, zone_.source_db, warehouse_id_, bay_id_, tier_id_, row_id_, bin_id_)) THEN
         location_is_in_operative_zone_ := TRUE;
         EXIT;
      END IF;            
   END LOOP;
   RETURN (location_is_in_operative_zone_);
END Location_Is_In_Operative_Zone;


PROCEDURE Lock_By_Keys_Wait (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN NUMBER )
IS 
   dummy_ INVENT_PART_PUTAWAY_ZONE_TAB%ROWTYPE;
BEGIN
   dummy_ := Lock_By_keys___(contract_, part_no_, sequence_no_);
END Lock_By_Keys_Wait;


@UncheckedAccess
FUNCTION Get_Best_Location_Ranking (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   warehouse_id_     VARCHAR2(15);
   bay_id_           VARCHAR2(5);
   tier_id_          VARCHAR2(5);
   row_id_           VARCHAR2(5);
   bin_id_           VARCHAR2(5);
   best_bin_ranking_ NUMBER;
BEGIN
   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_,
                                              bay_id_,
                                              tier_id_,
                                              row_id_,
                                              bin_id_,
                                              contract_,
                                              location_no_);

   best_bin_ranking_ := Get_Best_Bin_Ranking___(contract_,
                                                part_no_,
                                                warehouse_id_,
                                                bay_id_,
                                                tier_id_,
                                                row_id_,
                                                bin_id_);
   RETURN (best_bin_ranking_);
END Get_Best_Location_Ranking;


@UncheckedAccess
FUNCTION Part_Has_Operative_Zone (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   part_has_operative_zone_ BOOLEAN := FALSE;
   dummy_                   NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM  INVENT_PART_OPERATIVE_ZONE
      WHERE contract = contract_
      AND   part_no = part_no_;
BEGIN
   OPEN  exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      part_has_operative_zone_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN(part_has_operative_zone_);
END Part_Has_Operative_Zone;


@UncheckedAccess
FUNCTION Location_Is_In_Best_Ranked (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   location_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   warehouse_id_               VARCHAR2(15);
   bay_id_                     VARCHAR2(5);
   tier_id_                    VARCHAR2(5);
   row_id_                     VARCHAR2(5);
   bin_id_                     VARCHAR2(5);
   best_bin_ranking_           NUMBER;
   best_part_ranking_          NUMBER;
   location_is_in_best_ranked_ BOOLEAN := FALSE;
BEGIN
   Warehouse_Bay_Bin_API.Get_Location_Strings(warehouse_id_,
                                              bay_id_,
                                              tier_id_,
                                              row_id_,
                                              bin_id_,
                                              contract_,
                                              location_no_);

   best_bin_ranking_ := Get_Best_Bin_Ranking___(contract_,
                                                part_no_,
                                                warehouse_id_,
                                                bay_id_,
                                                tier_id_,
                                                row_id_,
                                                bin_id_);

   best_part_ranking_ := Get_Best_Part_Ranking___(contract_, part_no_);

   IF (best_bin_ranking_ = best_part_ranking_) THEN
      location_is_in_best_ranked_ := TRUE;
   END IF;

   RETURN (location_is_in_best_ranked_);
END Location_Is_In_Best_Ranked;

@UncheckedAccess
FUNCTION Get_Sql_Where_Expression (
   contract_        IN VARCHAR2,
   storage_zone_id_ IN VARCHAR2,
   source_db_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   sql_where_expression_ VARCHAR2(28000);
BEGIN   
   IF (source_db_ = Part_Putaway_Zone_Level_API.DB_REMOTE_WAREHOUSE_ASSORTMENT) THEN
      -- storage_zone_id_ contains the warehouse ID for the remote warehouse
      Client_SYS.Add_To_Attr('WAREHOUSE_ID', storage_zone_id_, sql_where_expression_);
      sql_where_expression_ := Report_SYS.Parse_Where_Expression(sql_where_expression_);
   ELSE
      sql_where_expression_ := Storage_Zone_API.Get_Sql_Where_Expression(contract_, storage_zone_id_);
   END IF;
   RETURN(sql_where_expression_);
END Get_Sql_Where_Expression;



