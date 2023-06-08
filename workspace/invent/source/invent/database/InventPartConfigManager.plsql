-----------------------------------------------------------------------------
--
--  Logical unit: InventPartConfigManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151029  JeLise  LIM-4351, Removed call to Inventory_Part_API.Pallet_Handled in Check_Configurable_Change.
--  140812  ViSalk  Bug 118184, Modified Check_Configurable_Change() to remove the restriction in the part catalogue and let the customer to make the purchase raw part to a configurable. 
--  110314  DaZase  Changed call to Inventory_Part_Pallet_API.Check_Exist so it uses Inventory_Part_API.Pallet_Handled instead.
--  101029  LEPESE  Added parameter receipt_issue_serial_track_db_ to Check_Configurable_Change. 
--  ---------------------------- Best Price  --------------------------------
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  040129  LaBolk  Changed view to SITE_PUBLIC in the cursor of method Check_Configurable_Change.
--  040119  LaBolk  Removed call to public cursor get_site_cur in Check_Configurable_Change and used a local cursor instead.
--  ------------------------------EDGE PKG GRP 2-----------------------------
--  031118  JoAnSe  Reversed previous correction made in Check_Configurable_Change 
--  031023  JOHESE  Added check on Supply Type DOP in Check_Configurable_Change
--  030630  KiSalk  replaced the call to Inventory_Part_In_Stock_API.Get_Aggregate_Qty_Consignment 
--  030630          with Get_Externally_Owned_Inventory of same API.
--  030226  SHVESE  Changed parameters in method Check_Configurable_Change from 
--                  part_catalog_rec_ to configurable_, condition_code_usage_,lot_tracking_code_,
--                  serial_tracking_code_.
--  030206  SHVESE  Added call to Inventory_Part_API.Check_Value_Method_Combination.
--  030205  LEPESE  Changed parameter in method Check_Configurable_Change from
--                  configurable_ to part_catalog_rec_.
--  030131  SHVESE  Reorganised Check_Configurable_Change and replaced the validation for 
--                  configuration_cost_method with a check for InventoryPartCostLevel.
--  001213  ANLASE  Added check for supply_type in Check_Configurable_Change.
--  001211  PaLj    Added method New_Valid_Configuration
--  001206  ANLASE  Corrected error message for MRPCode and shortage.
--  001204  ANLASE  Added check for ConfigurationCostMethod.
--  001130  ANLASE  Performance improvements.
--  001128  ANLASE  Performance improvements. Replaced calls to Order_Supply_Demand with
--                  Order_Supply_Demand_API.Check_Part_Exist.
--                  Added check for Inventory_Part_API.Count_Sites.
--  001121  ANLASE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Check_Configurable_Change (
   part_no_                       IN VARCHAR2,
   configurable_db_               IN VARCHAR2,
   condition_code_usage_db_       IN VARCHAR2,
   lot_tracking_code_db_          IN VARCHAR2,
   serial_tracking_code_db_       IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2 )
IS
   inv_part_plan_rec_ Inventory_Part_Planning_API.Public_Rec;

   CURSOR get_rec IS
      SELECT *
      FROM inventory_part_pub
      WHERE part_no = part_no_;

   CURSOR get_site_cur IS
      SELECT contract
      FROM SITE_PUBLIC;
BEGIN
   --Loop over all sites where part inventory part exist
   FOR part_rec IN get_rec LOOP
      --Changing flag from NOT CONFIGURED to CONFIGURED
      IF (configurable_db_ = Part_Configuration_API.db_configured) THEN 

         --Parttype Recipe is not allowed for configurable parts
         IF (part_rec.type_code_db = '2') THEN
            Error_SYS.Record_General(lu_name_, 'PARTYPENOTALLOW: Part :P1 on Site :P2 of part type :P3 cannot be set to a configurable part.', part_no_, part_rec.contract, Inventory_Part_Type_API.Decode(part_rec.type_code_db));
         END IF;

         --Only Planning methods 'A', 'K' and 'P' are allowed for configurable parts
         inv_part_plan_rec_ := Inventory_Part_Planning_API.Get(part_rec.contract, part_no_);
         IF (inv_part_plan_rec_.planning_method NOT IN ('A', 'K', 'P')) THEN
            Error_SYS.Record_General(lu_name_, 'MRPNOTALLOWED: Part :P1 on Site :P2 uses Planning Method :P3 and cannot be set to a configurable part.', part_no_, part_rec.contract, inv_part_plan_rec_.planning_method);
         END IF;

         --Auto update flags are not allowed for configurable parts
         IF ((inv_part_plan_rec_.lot_size_auto        = 'Y')  OR
             (inv_part_plan_rec_.order_point_qty_auto = 'Y')  OR
             (inv_part_plan_rec_.safety_stock_auto    = 'Y')) THEN
            Error_SYS.Record_General(lu_name_, 'AUTOUPDNOTALLOW: Part :P1 on Site :P2 uses auto update and cannot be set to a configurable part.', part_no_, part_rec.contract);
         END IF;

         --Supply Type 'Schedule' is not allowed for configurable parts
         IF (inv_part_plan_rec_.Order_Requisition = 'S') THEN
            Error_SYS.Record_General(lu_name_, 'NOSCHED: Part :P1 on Site :P2 uses supply type :P3 and cannot be set to a configurable part.', part_no_, part_rec.contract, Inventory_Part_Supply_Type_API.Decode('S'));
         END IF;

         --Shortage handling is not allowed for configurable parts
         IF (part_rec.shortage_flag_db  = 'Y') THEN
            Error_SYS.Record_General(lu_name_, 'NOSHORT: Part :P1 on Site :P2 uses Shortage Notification and cannot be set to a configurable part.', part_no_, part_rec.contract);
         END IF;

         --Consignment Stock is not allowed for configurable parts
         --Consignment from customer shall be checked in component ORDER
         IF (Inventory_Part_In_Stock_API.Get_Externally_Owned_Inventory(part_rec.contract, part_no_, NULL, NULL, NULL,'CONSIGNMENT') != 0)  THEN
            Error_SYS.Record_General(lu_name_, 'CONDELNOTALLOWED: Part :P1 on Site :P2 uses consignment stock and cannot be set to a configurable part.', part_no_, part_rec.contract);
         END IF;

      END IF;

      --These checks are needed any way configurable flag is updated
     
      Inventory_Part_API.Check_Value_Method_Combination(part_rec.contract,
                                                        part_no_,
                                                        configurable_db_,
                                                        condition_code_usage_db_,
                                                        lot_tracking_code_db_,
                                                        serial_tracking_code_db_,
                                                        receipt_issue_serial_track_db_);

      --Check if any inventory transactions have taken place
      IF (Inventory_Transaction_Hist_API.Check_Part_Exist(part_rec.contract, part_no_, NULL) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'TRANSEXIST: Inventory transactions exist for Part :P1 on Site :P2 and it is not allowed to change configurable.', part_no_, part_rec.contract);
      END IF;

      --Check for any supply/demand
      IF Order_Supply_Demand_API.Check_Part_Exist(part_rec.contract, part_no_) = 1 THEN
         Error_SYS.Record_General(lu_name_, 'EXISTDEMAND: Demand/Supply exist for Part :P1 on Site :P2 and it is not allowed to change configurable.', part_no_, part_rec.contract);
      END IF;
   END LOOP;
   
   -- the part on a material requistion line can be a inventory part or a purchase part 
   -- configured parts cannot be connected to a material requistion line
   IF (configurable_db_ = Part_Configuration_API.db_configured) THEN 
      FOR site_rec IN get_site_cur LOOP
         --If the part is used on any MaterialRequisitionLine with status other than closed, it cannot be changed to configurable
         IF Material_Requis_Line_API.Check_Exist_Non_Closed(part_no_, site_rec.contract) = 'TRUE' THEN
            Error_SYS.Record_General(lu_name_, 'EXISTMATREQLINE: Part :P1 on Site :P2 exists on a material requisition and cannot be set to configurable unless the requisition is closed.', part_no_, site_rec.contract);
         END IF;
      END LOOP;
   END IF;
END Check_Configurable_Change;


PROCEDURE New_Valid_Configuration (
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
   CURSOR get_contract IS
      SELECT contract
      FROM inventory_part_pub
      WHERE part_no = part_no_;
BEGIN
   FOR site_rec IN get_contract LOOP
      IF NOT Inventory_Part_Config_API.Check_Exist(site_rec.contract, part_no_, configuration_id_) THEN
         Inventory_Part_Config_API.NEW(site_rec.contract, part_no_, configuration_id_, 0);
      END IF;
   END LOOP;
END New_Valid_Configuration;



