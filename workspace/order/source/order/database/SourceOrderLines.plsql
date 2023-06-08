-----------------------------------------------------------------------------
--
--  Logical unit: SourceOrderLines
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220119  ShWtlk  MF21R2-6632, Removed Perform_Capability_Check() to remove capability check functionality from source order lines.
--  211215  JICESE  MF21R2-6262, Modified Perform_Capability_Check to not add a work day after capability check execution for supply code 'IO'.
--  211203  ShWtlk  MF21R2-6026, Modfied the info message in Perform_Capability_Check() used for capability check dialog.
--  211108  Inaklk  SC21R2-5750, Modified Create_Source_Set___ to set ship_via_code from  Cust_Order_Leadtime_Util_API.Get_Sc_Defaults_For_Sourcing
--  210729  ManWlk  MF21R2-2668, Modified Perform_Capability_Check() to send original planned due date of customer order line to CC engine instead of previous work day.
--  200219  JaThlk  Bug 150984 (SCZ-8404), Modified Source_Automatically__ to avoid replacing default_ext_transport_cal_id_, default_picking_leadtime_, default_route_id_ 
--                  and default_shipment_type_ when the demand code is IPT and modified Create_Source_Set___ to fetch default values from 
--                  Cust_Order_Leadtime_Util_API.Get_Sc_Defaults_For_Sourcing unconditionally and reassign the necessary attributes when the supply code is IPD or IPT.
--  180808  ApWilk  Bug 141998, Modified Create_Source_Set___(),Get_First_Alternative___()and Source_Automatically__()in order to fetch the correct ship_via_code,
--  180808          delivery_terms and del_terms_location according to the fetching logic when it uses a sourcing rule and the supply code is IPD.
--  170612  ErFelk  Bug 135989, Modified Source_Automatically__() and Create_Source_Set___() by adding IPT to a condition so that delivery information sent 
--  170612          through the ORDERS message is been used.
--  161107  VISALK  STRMF-7948, Modified Perform_Capability_Check() to add additional information.
--  160715  MaRalk  STRSC-2840, Added annotation @UncheckedAccess to Get_Src_Own_Invent_Values method.
--  160506  ChFolk  STRSC-2217, Modified Create_Sourcing_Lines to set the check_validity flag for Mpccom_Ship_via_API.Exist.
--  160225  ChFolk  STRSC-860, Modified Perform_Capability_Check to support newly added parameters transport_leadtime and arrival route id 
--  160225           in methods Cust_Order_Leadtime_Util_API.Get_Default_Leadtimes and Cust_Ord_Date_Calculation_API.Calc_Due_Date_Forwards.
--  151015  HimRlk  Bug 124366, Modified Source_Automatically__ and Create_Source_Set___ by adding a new parameter demand_code.
--  150205  MeAblk  PRSC-5245, Modified Source_Order_Lines__ in order to avoid getting cancelled order lines when doing automatic sourcing.
--  141128  SBalLK  PRSC-3709, Modified Create_Source_Set___(), Source_Automatically__() and Get_Src_Supplier_Values() methods to fetch delivery terms and
--  141128          delivery terms location from supply chain matrix.
--  141222  IsSalk  Bug 120314, Modified Calculate_Available___() to avoid errors when creating CO lines.
--  141118  JeLise  PRSC-2547, Replaced CUSTOMER_ORDER_JOIN with CUSTOMER_ORDER_LINE_TAB and CUSTOMER_ORDER_TAB.
--  140421  SBalLK  Bug 116331, Modified cursor in Source_Order_Lines__() method to reflect the column name changes in the CUSTOMER_ORDER_JOIN view.
--  130709  ChJalk  TIBE-1030, Removed global variables inst_Supplier_, inst_PurchasePartSupplier_  and inst_InterimCtpManager_.
--  120911  MeAblk  Added ship_inventory_location_no_ as a parameter to the method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120824  MeAblk  Added parameter shipment_type_ into method Cust_Order_Leadtime_Util_API.Get_Sc_Defaults_For_Sourcing.
--  120824  MaMalk  Added shipment_type as a parameter to method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120725  MAHPLK  Added picking lead time to Get_Src_Supplier_Values and  Get_Src_Own_Invent_Values.
--  120712  MAHPLK  Added picking lead time as parameter to Get_Available_Date___ and Calculate_Available___.
--  120712          changed the number of parameters in Cust_Ord_Date_Calculation_API.Calc_Sourcing_Dates.
--  120702  MaMalk  Changed the number of parameters in method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes, Get_Sc_Defaults_For_Sourcing,
--  120702          and Get_Supply_Chain_Defaults. Also added forwarder and route to Source_Automatically__, Get_Src_Supplier_Values and Create_Source_Set___.
--  110717  ChJalk  Modified usage of view CUSTOMER_ORDER_LINE to CUSTOMER_ORDER_LINE_TAB in cursors.
--  110628  SudJlk  Bug 94238, Modified method Source_Automatically__ to send the deliver_to_customer for fetching correct delivery information.
--  110315  AndDse  BP-4434, Modified Perform_Capability_Check___, added parameter in call to Cust_Ord_Date_Calculation_API.Calc_Due_Date_Forwards.
--  110203  AndDse  BP-3776, Modifications for implementation of external transport calendar.
--  110125  AndDse  BP-3776, Introduced external transport calendar, which is needed in some calculations called from this LU.
--  100513  KRPELK  Merge Rose Method Documentation.
--  091001  MaMalk  Removed unused code in Get_Available_Date___.
--  ------------------------- 14.0.0 ------------------------------------------
--  100426  JeLise  Renamed zone_definition_id to freight_map_id.
--  090325  MaMalk  Bug 80752, Modified method Create_Source_Set___ to intialize the values passed for Cust_Order_Leadtime_Util_API.Get_Sc_Defaults_For_Sourcing correctly. 
--    080911   MaJalk  Added zone_definition_id_ and zone_id_ to method calls at Get_Src_Supplier_Values and Source_Automatically__.
--  080116  MaHplk  Modified Source_Automatically__ to call the correct method of Agreement_Sales_Part_Deal_API. 
--  061205  DaZase  Added a qty conversion in method Perform_Capability_Check.
--  061026  DaZase  Added method Get_Site_Converted_Qty__. Changed call in Calculate_Available___ so it use 
--                  the new method so we can handle infinity cases.
--  061017  DaZase  Added conversion from supply site inv UoM to demand site inv UoM in Calculate_Available___.
--                  Added conversion from demand site inv UoM to supply site inv UoM in Create_Source_Set___/Get_Sourcing_Values___
--    060818   SaRalk  Removed SUBSTR for customer_name_ in procedure Perform_Capability_Check. 
--    060817   ChBalk  Reversed the changes done for public cursor removals.
--  060424  MaJalk  Enlarge Supplier - Changed variable definitions.
--  -------------------------13.4.0--------------------------------------------
--  060302  DaZase  Added handling of info string from CC in method Perform_Capability_Check.
--  060124  JaJalk  Added Assert safe annotation.
--  060103  JoEd    Vendor_no sent to Cust_Ord_Date_Calculation_API.Calc_Due_Date_Forwards.
--  051020  SuJalk  Changed the reference in get_not_decided cursor in the Source_Order_Lines__ to user_allowed_site_pub.
--  051006  NuFilk  Modified method Get_Atp_Quantity to consider floor stock also. 
--  051003  KeFelk  Added Site_Invent_Info_API.Get_Picking_Leadtime() to Get_Available_Date___.
--  050926  NaLrlk  Removed unused variables.
--  050707  ThGulk  Bug 50561, Modified method 'Check_Sourcing_Criteria___' to incoperate new 'IGNORE IO' sourcing criterion 
--  050613  DaZase  Added more functionality to Perform_Capability_Check so we can handle supply code IO for CC.
--  050518  DaZase  Added info param to Perform_Capability_Check.
--  050323  IsWilk  Added PROCEDURE Validate_Params. 
--  050322  JoEd    Added automatic sourcing check against Direct Delivery and Delay COGS
--                  flag on order header. Present another message - and set supply_code = ND.
--  050318  DaZase  Added planned_due_date_ to Get_Src_Supplier_Values. Added method Perform_Capability_Check.
--                  Added planned_due_date_ and latest_release_date_ to Create_Sourcing_Lines.
--  050207  NaLrlk  Removed the views VIEW_EXT, VIEW_DEMAND, VIEW_DEMAND_SOURCED, VIEW_MS
--  050131  JoEd    Changed calls to CustOrdDateCalculation.
--  041130  LaPrlk  Bug 48110, Modified Create_Source_Set___ to fetch the site_ correctly since
--                  vendor_contract_ doesn't get modified properly when vendor_no_ IS NULL
--  041028  JOHESE  Modified VIEW_EXT and VIEW_DEMAND_SOURCED
--  040906  IsWilk  Removed the PROCEDURE Schedule_Sourcing__.
--  040816  MaJalk  Bug 45872, Modified the procedure Source_Automatically__ to set delivery leadtime
--  040816          when having a Single Occurrence address in the CO header and when demand code is null.
--  040726  MaJalk  Bug 45872, Modified the procedure Source_Automatically__ to set delivery leadtime to the
--  040726          same as the CO header when demand code is null.
--  040705  MiKulk  Bug 45512, Modified the procedure Source_Automatically__ to get correct ship via and delivery lead time
--  040705          for the customer order lines with demand code 'IPD'.
--  040624  ChBalk  Bug 42635, Not allowed sourcing when supply_code 'SO' for Purchase Parts.
--  040506  DaRulk  Renamed 'Desired Delivery Date' to 'Wanted Delivery Date'
--  040426  LoPrlk  Removed the wanted_due_date added in the change 040415 LoPrlk.
--  040422  HeWelk  Removed procedure Schedule_Sourcing_Batch__ .
--  040420  KiSalk  SCHT603 Supply Demand Views - Removed PURCHASE_ORDER_LINE_SIM.
--  040421  KiSalk  SCHT603 Supply Demand Views - Added column qty_reserved to views SOURCED_ORDER_LINE_DEMAND,
--  040421          SOURCED_ORDER_LINE_DEMAND_OE, SOURCED_ORDER_LINE_MS and SOURCED_ORDER_LINE_EXT.
--  040419  NaWalk  SCHT603 Supply Demand Views - Added column qty_pegged to views SOURCED_ORDER_LINE_DEMAND,
--  040419          SOURCED_ORDER_LINE_DEMAND_OE, SOURCED_ORDER_LINE_MS and SOURCED_ORDER_LINE_EXT.
--  040415  LoPrlk  SCHT603 Supply Demand Views - Added columns condition_code and wanted_due_date to views SOURCED_ORDER_LINE_DEMAND,
--  040415          SOURCED_ORDER_LINE_DEMAND_OE, SOURCED_ORDER_LINE_MS and SOURCED_ORDER_LINE_EXT.
--  040302  SeKalk  Bug 41033, Modified the procedure Source_Automatically__.
--  040226  IsWilk  Removed the SUBSTRB from the view and modified the SUBSTB to SUBSTR for Unicode Changes.
--  040225  GeKalk  Bug 41033, Modified the procedure Source_Automatically__ to fetch the agreement from
--                  the order if any and check for validation.
--  040217  KaDilk  Bug 41279, Modified the procedure Get_Src_Supplier_Values to avoid adding the default
--  040217          delivery lead time for the IPD delivery mode.
--  040107  CaStse  Bug 41270. Added truncation of dates.
--  031024  JoEd    Changed ATP check in Get_Atp_Quantity, Get_Available_Date___
--                  and Get_Sourcing_Values___.
--                  Added info handling in Source_Automatically__ and Source_Order_Lines__.
--  031020  JoEd    Changed ATP check in Calculate_Available___.
--                  Added supply code in parameter list for Get_Available_Date___ for correct ATP check.
--  031016  JoEd    Added extra date parameters to Get_Src_Own_Invent_Values and Get_Src_Supplier_Values.
--                  Removed addition of manufacturing leadtime in Get_Available_Date___.
--                  Return 0 if ATP is used and no quantity (NULL) is available in Get_Atp_Quantity.
--  031015  JoAnSe  Removed picking leadtime from the date retrieved in Get_Available_Date___.
--                  Corrected retrieval of available_to_promise_date in Create_Source_Set___
--  031014  JoEd    Added check on Configured parts in Create_Source_Set___.
--                  Removed error messages raised if configured part in Source_Automatically__
--                  and Source_Order_Lines__.
--  031013  JoAnSe  Removed obsolete code in Get_Atp_Quantity.
--  031013  PrJalk  Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  031007  JoAnSe  Added parameter supplier_part_no_ in call to Get_SC_Defaults_For_Sourcing
--                  and Get_Supply_Chain_Totals.
--  031002  JoEd    Changed parameter lists for Calculate_Available___, Get_Sourcing_Values___,
--                  Create_Source_Set___, Get_Src_Own_Invent_Values and Get_Src_Supplier_Values.
--  031001  JoAnSe  Moved assignment of variable autosrc_ in Source_Automatically__
--                  to avoid hard error when creating new order lines
--  030926  DaZa    Made changes on views SOURCED_ORDER_LINE_DEMAND_OE/SOURCED_ORDER_LINE_SIM so they now work with reservations.
--  030922  JoEd    Removed Get_Supplier_Default_Ship_Via, Get_Delivery_Date,
--                  Calculate_Total_Shipping_Time, Calculate_Total_Distance and
--                  Calculate_Total_Exp_Cost.
--                  Added methods Get_Src_Own_Invent_Values, Get_Src_Supplier_Values
--                  and Get_Sourcing_Values___. Removed use of sourcing_type/delivery mode.
--  030919  NuFilk  Removed condition on supply_site_date_ in Get_Delivery_Date and modified
--                  Get_Supplier_Default_Ship_Via to fetch values using supplier default address no.
--  030915  JoEd    Added supplier part no to date calculation methods.
--  030912  JoAnSe  Rewrote part of the logic for automatic sourcing
--  030908  NuFilk  Modified Get_Delivery_Date to set supply site due date to only values later than/or to today.
--  030901  NuFilk  CR Merge 02
--  030829  Asawlk  Modify method Create_Sourcing_Lines to set ReleasePlanning in customer order line to 'RELEASED'.
--  030829  BhRalk  Modified the view VIEW_DEMAND_SOURCED_OE.
--  030828  NaWalk  Performed Code Review.
--  030828  NuFilk  Code Cleanup.
--  030827  JoAnSe  Added handling of supplier_ship_via_transit_ in Create_Source_Set___
--  030827  JoAnSe  Corrected retrieval of ship via code for 'IPD' and 'PD' in Create_Source_Set___
--                  Replaced call to Customer_Order_Line_API.Get_Vendor_Contract__ with dynamic call to Purch
--                  in Calculate_Total_Shipping_Time.
--                  Removed NVL for parameter contract in calls to Calculate_Total... methods
--  030826  NuFilk  Modified Get_Atp_Quantity according to requirement change.
--  030826  NuFilk  Modified Get_Atp_Quantity to set ATP quantity accordingly.
--  030825  Asawlk  Modified view SOURCED_ORDER_LINE_DEMAND_OE.
--  030820  NuFilk  Added parameter supply_code_db_ to method Calculate_Total_Shipping_Time and changed the method.
--  030819  ThGulk  Changed views  VIEW_EXT, VIEW_DEMAND_SOURCED, VIEW_SIM,VIEW_MS.
--  030818  ThGulk  Changed view VIEW_DEMAND.
--  **************************** CR Merge 02 ************************************
--  030818  BhRalk  Corrected deployment error in Create_Source_Set___.
--  030816  KeFelk  Corrected deployment error in Create_Source_Set___.
--  030815  JoAnSe  Changed Create_Source_Set___ to only select active suppliers (status_code = '2')
--                  also changed cursor get_source_set in Get_Source_Set___ to use table instead of view.
--  030814  NuFilk  Added parameter supply_site_due_date to Create_Sourcing_Lines method.
--  030813  JoEd    Corrected dynamic code in Create_Source_Set___ - check on supplier selection method.
--  030813  WaJalk  Modified views SOURCED_ORDER_LINE_DEMAND_OE and SOURCED_ORDER_LINE_SIM.
--  030812  WaJalk  Modified view SOURCED_ORDER_LINE_DEMAND_OE.
--  030807  Asawlk  Modified public cursors get_source_order_demand and get_source_order_supply_demand.
--  030806  WaJalk  modified views SOURCED_ORDER_LINE_EXT and SOURCED_ORDER_LINE_DEMAND.
--  030703  WaJalk  Added public method Customer_Order_Line_API.Finite_State_Decode in views related to sourcing.
--  030702  Asawlk  Added two new public cursors get_source_order_demand and get_source_order_supply_demand.
--  030702  WaJalk  Modified new views related to sourcing.
--  030702  NuFilk  Modified Calculate_Total_Exp_Cost and Calculate_Total_Distance.
--  030701  JoEd    Changed delivery date calculation.
--                  Removed online consumption check in Get_Available_Date___.
--  030630  WaJalk  Added new views related to sourcing.
--  030627  WaJalk  Modified method Create_Sourcing_Lines.
--  030626  NuFilk  Modified method Check_Order_Fully_Sourced to handle not sourced lines also.
--  030618  DaZa    Added info handling and info_ out param to Create_Sourcing_Lines.
--  030616  DaZa    Made some reservation handling changes in Create_Sourcing_Lines.
--  030613  DaZa    Added reservation handling in method Create_Sourcing_Lines.
--  030528  NuFilk  Modified Method Create_Sourcing_Lines and added a Decode for 'INVOICE'.
--  030527  NuFilk  Added Method Get_Delivery_Date and Modified method Create_Sourcing_Lines.
--  030521  NuFilk  Added Methods Check_Order_Fully_Sourced, Create_Sourcing_Lines and Set_Order_Line_Values___
--  030515  JoEd    Added code for automatic sourcing. Cleaned up the prior sourcing methods.
--  030512  NuFilk  Added methods, Calculate_Total_Shipping_Time,Calculate_Total_Distance, Calculate_Total_Exp_Cost,
--  030512          and Get_Atp_Quantity.
--  --------------------- Chain Reaction ------------------------------------
--  020729  SaNalk Bug 29574, Added a check for primary supplier of a purchase part in PROCEDURE Source_Automatically__
--  020729         when the sourcing method is Closest Supplier.
--  010413  JaBa  Bug Fix 20598,Added new global lu constants which are used to check the logical unit installed.
--  000913  FBen  Added UNDEFINED.
--  000908  JoEd  Cleanup.
--  --------------------------- 12.1 ----------------------------------------
--  000512  JoAn  Renamed Handel_Deferred_Errors___ Handle_Deferred_Errors___.
--                Corrected the error handling for open cursors in exceptions.
--                Made error message translateble in Handle_Deferred_Error___.
--  000425  PaLj  Changed check for installed logical units. A check is made when API is instantiatet.
--                See beginning of api-file.
--  000216  sami  IF dbms_sql.is_open(cid_) THEN dbms_sql.close_cursor(cid_);  END IF; added
--                where the dbms_sql is used
--  --------------------------- 12.0 ----------------------------------------
--  991109  sami  bugg CID 27679  catalg_no is replaced with purchase_part_no in dynamic sql statements in source_automatcally
--  991105  sami  if the salespart is non inventorypart the supply_code=NO. Changes are made in source_from_inventory
--  991103  sami  Made it possible to use  Source via purchase direct in Manually sourcing even
--                if purchase_flag is IPT or PT
--  991102  sami  Some comments replaced with better comments and some exceptions replaced by handle_deffered_errors
--  991029  sami  All substr is  replaced with substrb to prepare for dubble byte system
--  991028  sami  New procedure Handle_Defferred_errors added. This procedure uses only internally.
--  991028  sami  not translationable db values for error_messages replaced with translationable client values
--  991027  sami  Made it possible to run Source_From_Purchase_Direct__ when purchase_flag='A'
--  991027  sami  Changes in 2 cursores in Automatically_sourcing__ for fetching data from
--                table insted of view
--  991025  sami  changes in Source_automatically to prevent sourceing with closest supplier and
--                shortest lead time when the address is a single occurrence address
--  991022  sami  contract relaced rec_.contract in dynamic sql statements in Source_automatically
--  991022  sami  new message when it is not possible to source a salespart
--  991021  sami  error_sys.Record_General's string parameters are replaced to show the right value
--  991020  sami  customer_order_api.get_state__ is relaced with customer_order_api.get_objstate in Schedule_Source_Order_Lines__
--  991020  sami  The error message procedure are changed in source_automatically_ to handle error messages from batch job
--  991019  sami  purchase_part_no replaced catalog_no in a dynamic sql statement in source_automatically__
--  991015  sami  ACQUISITIONPURCHASEORDER is replaced by ACQUISITIONPURCHORD. The first str is too long
--  991012  sami  Unnecessary variables deleted
--  990820  sami  Handles sourcing of customer order line
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE source_order_record IS RECORD (
    part_no           VARCHAR2(25),
    order_no          VARCHAR2(12),
    line_no           VARCHAR2(4),
    rel_no            VARCHAR2(4),
    line_item_no      NUMBER,
    delivery_date     DATE,
    sourced_qty       NUMBER );
    
CURSOR get_source_order_demand(
   contract_ VARCHAR2,
   part_no_  VARCHAR2 ) RETURN source_order_record
IS
   SELECT col.part_no,
          sol.order_no,
          sol.line_no,
          sol.rel_no,
          sol.line_item_no,
          sol.wanted_delivery_date,
          sol.sourced_qty
   FROM   sourced_cust_order_line_tab sol, customer_order_line_tab col
   WHERE  col.contract = contract_
   AND    col.part_no LIKE NVL(part_no_, '%')
   AND    sol.line_item_no != -1
   AND    sol.sourced_qty  > 0
   AND    sol.supply_code IN ('IO')
   AND    col.ctp_planned = 'N'
   AND    col.order_no = sol.order_no
   AND    col.line_no = sol.line_no
   AND    col.rel_no = sol.rel_no
   AND    col.line_item_no = sol.line_item_no;
   
CURSOR get_source_order_supply_demand(
   contract_ VARCHAR2,
   part_no_  VARCHAR2 ) RETURN source_order_record
IS
   SELECT col.part_no,
          sol.order_no,
          sol.line_no,
          sol.rel_no,
          sol.line_item_no,
          sol.supply_site_due_date,
          sol.sourced_qty
   FROM   sourced_cust_order_line_tab sol, customer_order_line_tab col
   WHERE  sol.supply_site = contract_
   AND    col.part_no LIKE NVL(part_no_, '%')
   AND    sol.line_item_no != -1
   AND    sol.sourced_qty  > 0
   AND    sol.supply_code IN ('IPD','IPT')
   AND    col.ctp_planned = 'N'
   AND    col.order_no = sol.order_no
   AND    col.line_no = sol.line_no
   AND    col.rel_no = sol.rel_no
   AND    col.line_item_no = sol.line_item_no;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Calculate_Available___
--   Returns the quantity available on the "wanted delivery date" minus total
--   shipping time in days.
--   Also returns this specific date when the supplier has this quantity.
PROCEDURE Calculate_Available___ (
   avail_qty_                 IN OUT NUMBER,
   avail_date_                IN OUT DATE,
   customer_no_               IN     VARCHAR2,
   ship_addr_no_              IN     VARCHAR2,
   addr_flag_db_              IN     VARCHAR2,
   vendor_no_                 IN     VARCHAR2,
   supplier_ship_via_         IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   ship_via_code_             IN     VARCHAR2,   
   delivery_leadtime_         IN     NUMBER,
   default_picking_leadtime_  IN     NUMBER,
   ext_transport_calendar_id_ IN     VARCHAR2,
   supply_code_db_            IN     VARCHAR2,
   part_no_                   IN     VARCHAR2,
   supplier_part_no_          IN     VARCHAR2,
   wanted_delivery_date_      IN     DATE,
   route_id_                  IN     VARCHAR2 )
IS
   vendor_contract_        VARCHAR2(5) := NULL;
   category_               VARCHAR2(20) := NULL;
   planned_delivery_date_  DATE;
   dummy_                  DATE;
   supply_site_due_date_   DATE := NULL;
   atp_                    BOOLEAN;
   picking_leadtime_       NUMBER;
BEGIN
   IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
      Get_Supplier_Info___(vendor_contract_, category_, vendor_no_);
      atp_ := Part_Uses_Atp___(vendor_contract_, supplier_part_no_);
   ELSIF (supply_code_db_ = 'IO') THEN
      atp_ := Part_Uses_Atp___(contract_, part_no_);
   ELSE
      -- other supply codes doesn't check for ATP...
      atp_ := FALSE;
   END IF;
   Trace_SYS.Field('atp_', atp_);

   -- only fetch available data if inventory part's ATP flag is set.
   IF atp_ THEN
      -- calculate the date minus total shipping time starting from the customer's desired date
      planned_delivery_date_ := wanted_delivery_date_;

      -- add total shipping time in days from supplier to customer (direct or transit)
      -- calculate from wanted delivery date backwards to get an due date (available date)
      Cust_Ord_Date_Calculation_API.Calc_Sourcing_Dates(planned_delivery_date_, dummy_, avail_date_,
         supply_site_due_date_, picking_leadtime_, wanted_delivery_date_, customer_no_, ship_addr_no_, addr_flag_db_, vendor_no_,
         ship_via_code_, delivery_leadtime_, default_picking_leadtime_, ext_transport_calendar_id_, supplier_ship_via_, route_id_, supply_code_db_, contract_, part_no_,
         supplier_part_no_, FALSE);

      -- fetch the quantity available on that date (on supply site when applicable)
      IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
         -- if this is a supply site sourcing we need to have the avail_qty_ in demand site inventory UoM 
         -- so all source sets are using the same (demand site inventory) UoM on the quantities when comparing the source sets
         avail_qty_ := Source_Order_Lines_API.Get_Site_Converted_Qty__(vendor_contract_, part_no_, Get_Atp_Quantity(vendor_contract_, supplier_part_no_, nvl(supply_site_due_date_, avail_date_)), contract_, 'REMOVE');
      ELSE
         avail_qty_ := Get_Atp_Quantity(contract_, part_no_, avail_date_);
      END IF;
   ELSE
      avail_qty_ := NULL;
      avail_date_ := NULL;
   END IF;
   Trace_SYS.Message(nvl(to_char(avail_qty_), 'NULL') || ' is available on ' ||
                     nvl(to_char(nvl(supply_site_due_date_, avail_date_), 'YYYY-MM-DD'), '????'));
END Calculate_Available___;


-- Check_Sourcing_Criteria___
--   Loops over the source set to select the "candidate" deliveries.
--   I.e. either those that are on time, or those with the earliest
--   delivery date.
--   Uses the sourcing objective criteria to narrow down the result to
--   at least one.
--   The column SELECTED is initially FALSE - becomes TRUE when a criteria is
--   found. When the next criteria is queried, it will only be used on
--   the previously SELECTED alternatives (if any).
--   When the source set has one SELECTED row after a criteria has been
--   checked, no more records or criteria will be processed.
--   If more than one record left, SELECT all records with the same priority.
PROCEDURE Check_Sourcing_Criteria___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   rule_id_      IN VARCHAR2 )
IS
   CURSOR get_criteria IS
      SELECT sourcing_criterion_db
      FROM sourcing_objective
      WHERE rule_id = rule_id_
      ORDER BY sequence_no;

   CURSOR get_bounds(selected_ IN VARCHAR2) IS
      SELECT min(nvl(priority, 0)), min(nvl(expected_additional_cost, 0)),
             min(nvl(distance, 0)), min(nvl(shipping_time, 0))
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_;

   CURSOR get_time(min_time_ IN NUMBER, selected_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, row_no
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_
      AND nvl(shipping_time, -1) = min_time_;

   CURSOR get_cost(min_cost_ IN NUMBER, selected_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, row_no
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_
      AND nvl(expected_additional_cost, -1) = min_cost_;

   CURSOR get_distance(min_dist_ IN NUMBER, selected_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, row_no
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_
      AND nvl(distance, -1) = min_dist_;

   CURSOR get_priority(min_prio_ IN NUMBER, selected_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, row_no
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_
      AND nvl(priority, -1) = min_prio_;

   CURSOR get_list(selected_ IN VARCHAR2)  IS
      SELECT supply_code, order_no, line_no, rel_no, line_item_no, row_no, wanted_delivery_date, earliest_delivery_date
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_;

   CURSOR count_rows(selected_ IN VARCHAR2)  IS
      SELECT count(order_no)
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_;

   min_prio_       NUMBER;
   min_cost_       NUMBER;
   min_dist_       NUMBER;
   min_time_       NUMBER;
   anyrows_        BOOLEAN := FALSE;
   criteria_found_ BOOLEAN := FALSE;
   rows_           NUMBER;
   selected_       VARCHAR2(5) := 'FALSE';
   row_count_      NUMBER;

   -----------------------------------------------------------------------------
   -- Unselect___
   --    All source alternatives that haven't got the passed time, cost, distance
   --    or priority will be unselected (SELECT = FALSE).
   -----------------------------------------------------------------------------
   PROCEDURE Unselect___ (
      order_no_     IN VARCHAR2,
      line_no_      IN VARCHAR2,
      rel_no_       IN VARCHAR2,
      line_item_no_ IN NUMBER,
      min_time_     IN NUMBER,
      min_cost_     IN NUMBER,
      min_dist_     IN NUMBER,
      min_prio_     IN NUMBER )
   IS
      CURSOR get_alternative IS
         SELECT order_no, line_no, rel_no, line_item_no, row_no
         FROM cust_order_line_source_set_tab
         WHERE order_no = order_no_
         AND line_no = line_no_
         AND rel_no = rel_no_
         AND line_item_no = line_item_no_
         AND candidate = 'TRUE'
         AND (((min_time_ IS NULL) OR (nvl(shipping_time, -1) != min_time_)) AND
              ((min_cost_ IS NULL) OR (nvl(expected_additional_cost, -1) != min_cost_)) AND
              ((min_dist_ IS NULL) OR (nvl(distance, -1) != min_dist_)) AND
              ((min_prio_ IS NULL) OR (nvl(priority, -1) != min_prio_)));
   BEGIN
      FOR altrec_ IN get_alternative LOOP
         Cust_Order_Line_Source_Set_API.Set_Selected__(altrec_.order_no, altrec_.line_no,
            altrec_.rel_no, altrec_.line_item_no, altrec_.row_no, 'FALSE');
      END LOOP;
   END Unselect___;
BEGIN
   FOR critrec_ IN get_criteria LOOP
      Trace_SYS.Field('Criterion', critrec_.sourcing_criterion_db);
      rows_ := 0;
      -- when first row select boundaries on the whole source set
      OPEN get_bounds(selected_);
      FETCH get_bounds INTO min_prio_, min_cost_, min_dist_, min_time_;
      IF (get_bounds%FOUND) THEN
         CLOSE get_bounds;
         -- Shortest Total Shipping Time...
         IF (critrec_.sourcing_criterion_db = 'TIME') THEN
            criteria_found_ := TRUE;
            Trace_SYS.Field('Search for shortest shipping time', min_time_);
            -- select the records with the shortest shipping time...
            FOR timerec_ IN get_time(min_time_, selected_) LOOP
               anyrows_ := TRUE;
               rows_ := rows_ + 1;
               Cust_Order_Line_Source_Set_API.Set_Selected__(timerec_.order_no, timerec_.line_no,
                  timerec_.rel_no, timerec_.line_item_no, timerec_.row_no, 'TRUE');
            END LOOP;
            IF (rows_ > 0) THEN
               -- unselect the rest
               Unselect___(order_no_, line_no_, rel_no_, line_item_no_, min_time_, NULL, NULL, NULL);
            END IF;

         -- Least Expected Additional Cost...
         ELSIF (critrec_.sourcing_criterion_db = 'COST') THEN
            criteria_found_ := TRUE;
            Trace_SYS.Field('Search for least expected cost', min_cost_);
            -- select all rows with the lowest cost...
            FOR costrec_ IN get_cost(min_cost_, selected_) LOOP
               anyrows_ := TRUE;
               rows_ := rows_ + 1;
               Cust_Order_Line_Source_Set_API.Set_Selected__(costrec_.order_no, costrec_.line_no,
                  costrec_.rel_no, costrec_.line_item_no, costrec_.row_no, 'TRUE');
            END LOOP;
            IF (rows_ > 0) THEN
               -- unselect the rest
               Unselect___(order_no_, line_no_, rel_no_, line_item_no_, NULL, min_cost_, NULL, NULL);
            END IF;

         -- Shortest Distance...
         ELSIF (critrec_.sourcing_criterion_db = 'DISTANCE') THEN
            criteria_found_ := TRUE;
            Trace_SYS.Field('Search for shortest distance', min_dist_);
            -- select all rows with the shortest distance...
            FOR distrec_ IN get_distance(min_dist_, selected_) LOOP
               anyrows_ := TRUE;
               rows_ := rows_ + 1;
               Cust_Order_Line_Source_Set_API.Set_Selected__(distrec_.order_no, distrec_.line_no,
                  distrec_.rel_no, distrec_.line_item_no, distrec_.row_no, 'TRUE');
            END LOOP;
            IF (rows_ > 0) THEN
               -- unselect the rest
               Unselect___(order_no_, line_no_, rel_no_, line_item_no_, NULL, NULL, min_dist_, NULL);
            END IF;

         -- Highest Priority...
         ELSIF (critrec_.sourcing_criterion_db = 'PRIORITY') THEN
            criteria_found_ := TRUE;
            Trace_SYS.Field('Search for highest priority', min_prio_);
            -- select all rows with the highest priority...
            FOR priorec_ IN get_priority(min_prio_, selected_) LOOP
               anyrows_ := TRUE;
               rows_ := rows_ + 1;
               Cust_Order_Line_Source_Set_API.Set_Selected__(priorec_.order_no, priorec_.line_no,
                  priorec_.rel_no, priorec_.line_item_no, priorec_.row_no, 'TRUE');
            END LOOP;
            IF (rows_ > 0) THEN
               -- unselect the rest
               Unselect___(order_no_, line_no_, rel_no_, line_item_no_, NULL, NULL, NULL, min_prio_);
            END IF;
         ELSIF (critrec_.sourcing_criterion_db = 'IGNORE IO') THEN
            OPEN count_rows(selected_);
            FETCH count_rows INTO row_count_;
            CLOSE count_rows;

            FOR comppriorec_ IN get_list(selected_) LOOP
               IF ((row_count_ > 1) AND (comppriorec_.supply_code = 'IO') AND (comppriorec_.wanted_delivery_date < comppriorec_.earliest_delivery_date)) THEN
	               Cust_Order_Line_Source_Set_API.Set_Selected__(comppriorec_.order_no, comppriorec_.line_no,
                        comppriorec_.rel_no, comppriorec_.line_item_no, comppriorec_.row_no, 'FALSE');
               ELSE
                   rows_ := rows_ + 1;
                  Cust_Order_Line_Source_Set_API.Set_Selected__(comppriorec_.order_no, comppriorec_.line_no,
                        comppriorec_.rel_no, comppriorec_.line_item_no, comppriorec_.row_no, 'TRUE');
                  anyrows_ := TRUE;  
               END IF;
            END LOOP;
         END IF;

         Trace_SYS.Field('Rows found', rows_);

         -- if any rows were selected, loop on those selected rows next time
         IF anyrows_ THEN
            selected_ := 'TRUE';
         END IF;

         -- if no rows were found and no rows were selected, exit loop
         IF (rows_ = 0) THEN
            Trace_SYS.Message('Nothing found');
            EXIT; -- criteria loop
         END IF;

         -- fetch number of selected rows
         rows_ := Get_Selected_Rows___(order_no_, line_no_, rel_no_, line_item_no_);
         -- if only one selected row remain, exit procedure!
         IF (rows_ = 1) THEN
            Trace_SYS.Message('One selected row - finished');
            EXIT; -- criteria loop
         END IF;
      ELSE
         Trace_SYS.Message('No source set defined - exit');
         CLOSE get_bounds;
         EXIT; -- criteria loop
      END IF;
   END LOOP;

   -- if no criteria found, select the highest priority
   IF NOT criteria_found_ THEN
      anyrows_ := FALSE;
      OPEN get_bounds(selected_);
      FETCH get_bounds INTO min_prio_, min_cost_, min_dist_, min_time_;
      IF (get_bounds%FOUND) THEN
         Trace_SYS.Message('No criteria found, find highest priority');
         Trace_SYS.Field('BOUNDS: min_prio', min_prio_);
         FOR priorec_ IN get_priority(min_prio_, selected_) LOOP
            anyrows_ := TRUE;
            Cust_Order_Line_Source_Set_API.Set_Selected__(priorec_.order_no, priorec_.line_no,
               priorec_.rel_no, priorec_.line_item_no, priorec_.row_no, 'TRUE');
         END LOOP;
         IF anyrows_ THEN
            Unselect___(order_no_, line_no_, rel_no_, line_item_no_, NULL, NULL, NULL, min_prio_);
         END IF;
      END IF;
      CLOSE get_bounds;
      Trace_SYS.Field('Any rows found', anyrows_);
   ELSE
      Trace_SYS.Message('Finished checking criteria');
   END IF;
END Check_Sourcing_Criteria___;


-- Create_Source_Set___
--   Loops over the sourcing rule's alternatives and inserts them in a
--   temporary Source Set table.
--   Checks the supplier selection method to find different kinds of suppliers.
--   Also calculates total shipping time, expected additional cost,
--   distance and earliest delivery date for the different alternatives.
PROCEDURE Create_Source_Set___ (
   order_no_                     IN VARCHAR2,
   line_no_                      IN VARCHAR2,
   rel_no_                       IN VARCHAR2,
   line_item_no_                 IN NUMBER,
   rule_id_                      IN VARCHAR2,
   contract_                     IN VARCHAR2,
   catalog_no_                   IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   purchase_part_no_             IN VARCHAR2,
   revised_qty_due_              IN NUMBER,
   wanted_delivery_date_         IN DATE,
   customer_no_                  IN VARCHAR2,
   ship_addr_no_                 IN VARCHAR2,
   default_addr_flag_db_         IN VARCHAR2,
   addr_flag_db_                 IN VARCHAR2,
   agreement_id_                 IN VARCHAR2,
   default_ship_via_             IN VARCHAR2,
   default_delivery_terms_       IN VARCHAR2,
   default_del_terms_location_   IN VARCHAR2,
   default_leadtime_             IN NUMBER,
   default_ext_transport_cal_id_ IN VARCHAR2,
   default_route_id_             IN VARCHAR2,
   default_forward_agent_id_     IN VARCHAR2,
   default_picking_leadtime_     IN NUMBER,
   default_shipment_type_        IN VARCHAR2,
   demand_code_                  IN VARCHAR2)
IS
   CURSOR get_source_set(rule_id_ IN VARCHAR2) IS
      SELECT priority, supplier_selection,
             supply_code, vendor_no
      FROM sourcing_alternative_tab
      WHERE rule_id = rule_id_;

   CURSOR get_co_source_set(order_no_ IN VARCHAR2, line_no_ IN VARCHAR2,
                            rel_no_ IN VARCHAR2, line_item_no_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, row_no,
             priority, supply_code, vendor_no
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;

   ship_via_code_             VARCHAR2(3);
   delivery_terms_            VARCHAR2(5);
   del_terms_location_        VARCHAR2(100);
   add_                       BOOLEAN;
   existn_                    NUMBER;
   supplier_status_           VARCHAR2(2);
   keyattr_                   VARCHAR2(2000);
   attr_                      VARCHAR2(32000);
   category_                  VARCHAR2(20);
   primary_vendor_            VARCHAR2(20);
   vendor_contract_           VARCHAR2(5) := NULL;
   vendor_category_           VARCHAR2(20) := NULL;
   site_                      VARCHAR2(5);   
   shipping_time_             NUMBER;
   cost_                      NUMBER;
   distance_                  NUMBER;
   earliest_date_             DATE;
   supply_site_due_date_      DATE;
   supplier_ship_via_transit_ VARCHAR2(3);
   avail_date_                DATE;
   full_qty_date_             DATE;
   avail_qty_                 NUMBER;
   supplier_part_no_          VARCHAR2(25);
   dummy_                     DATE;
   delivery_leadtime_         NUMBER;
   def_addr_flag_db_          VARCHAR2(1);
   temp_revised_qty_due_      NUMBER;
   ext_transport_calendar_id_ VARCHAR2(10);
   route_id_                  VARCHAR2(12);
   forward_agent_id_          VARCHAR2(20);
   picking_leadtime_          NUMBER;
   shipment_type_             VARCHAR2(3);
BEGIN

   -- Clean previous automatic sourcing
   Cust_Order_Line_Source_Set_API.Delete__(order_no_, line_no_, rel_no_, line_item_no_);

   Client_SYS.Clear_Attr(keyattr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, keyattr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, keyattr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, keyattr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, keyattr_);

   -- Fetch all supply codes and suppliers available in the source set
   FOR altrec_ IN get_source_set(rule_id_) LOOP

      Trace_SYS.Field('Supplier selection', altrec_.supplier_selection);
      -- no supplier selection method, check supply code and vendor.
      IF (altrec_.supplier_selection IS NULL) THEN
         Trace_SYS.Field('Supply_code', altrec_.supply_code);

         -- check if alternative may be used

         -- Non-inventory parts and CTO parts can't have Inventory Order supply...
         IF (altrec_.supply_code = 'IO') THEN
            add_ := (part_no_ IS NOT NULL) AND (Part_Catalog_API.Get_Configurable_Db(nvl(part_no_, catalog_no_)) = 'NOT CONFIGURED');
            Trace_SYS.Field('Invent order: inventory part and not configured', add_);
         -- Inventory parts must be Manufactured / Manufactured Recipe if using Shop Order supply...
         ELSIF (altrec_.supply_code = 'SO') THEN
            add_ := (nvl(Inventory_Part_API.Get_Type_Code_Db(contract_, part_no_), '0') IN ('1', '2'));
            Trace_SYS.Field('Shop order: Manufactured', add_);

         -- Purchase order supply - check if supplier exists in PurchasePartSupplier.
         -- Make sure the supplier is active (status_code = 2)
         ELSE
            $IF Component_Purch_SYS.INSTALLED $THEN               
               existn_ := Purchase_Part_Supplier_API.Exist_N(contract_, purchase_part_no_, altrec_.vendor_no);
               supplier_status_ := Purchase_Part_Supplier_API.Get_Status_Code(contract_, purchase_part_no_, altrec_.vendor_no);             

               add_ := ((existn_ = 1) AND (NVL(supplier_status_, '0') = '2'));

               Trace_SYS.Field('Active purchase part supplier exist', add_);
            $ELSE
               Trace_SYS.Message('No active supplier found or Purchase is not installed. Do not add alternative');
               add_ := FALSE;
            $END
         END IF;

         IF add_ THEN
            attr_ := keyattr_;
            Client_SYS.Add_To_Attr('PRIORITY', altrec_.priority, attr_);
            Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', altrec_.supply_code, attr_);
            Client_SYS.Add_To_Attr('VENDOR_NO', altrec_.vendor_no, attr_);
            Cust_Order_Line_Source_Set_API.New_Alternative__(attr_);
            Trace_SYS.Message('Alternative added');
         END IF;

      -- a supplier selection method is chosen. Find the different suppliers.
      ELSE
         Trace_SYS.Message('Supplier selection method chosen - find suppliers...');
         $IF Component_Purch_SYS.INSTALLED $THEN
            DECLARE
               CURSOR get_supplier IS
                  SELECT vendor_no
                  FROM purchase_part_supplier_pub
                  WHERE contract = contract_
                  AND part_no = purchase_part_no_
                  AND primary_vendor_db LIKE primary_vendor_
                  AND status_code = '2';

                  vendor_category_ VARCHAR2(20);
                  supp_select_     VARCHAR2(20) := altrec_.supplier_selection;
                  any_supplier_    BOOLEAN;
                  attr_            VARCHAR2(32000);
                  supply_code_     VARCHAR2(20);
            BEGIN
               -- internal supplier
               IF (altrec_.supplier_selection IN ('INTSUPPTRANS', 'INTSUPPDIR')) THEN
                  category_ := 'I';
               -- external supplier
               ELSIF (altrec_.supplier_selection IN ('EXTSUPPTRANS', 'EXTSUPPDIR')) THEN
                  category_ := 'E';
               -- any supplier (incl. primary)
               ELSE
                  category_ := NULL; -- nvl() check in dynamic code means all categories...
               END IF;
               Trace_SYS.Field('category', category_);
               -- primary vendor
               IF (altrec_.supplier_selection IN ('PRISUPPTRANS', 'PRISUPPDIR')) THEN
                  primary_vendor_ := 'Y';
               ELSE
                  primary_vendor_ := '%';
               END IF;
               Trace_SYS.Field('primary vendor', primary_vendor_);
               FOR supprec_ IN get_supplier LOOP
                  vendor_category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(supprec_.vendor_no));

                  -- Category is NULL if both categories... continue if correct category
                  IF (nvl(category_, vendor_category_) = vendor_category_) THEN

                     Trace_SYS.Message('Supplier found');

                     -- If internal supplier, set supply code IPx otherwise Px.
                     -- D(irect) or T(ransit) will be appended later
                     IF (vendor_category_ = 'I') THEN
                        supply_code_ := 'IP';
                     ELSE
                        supply_code_ := 'P';
                     END IF;

                     any_supplier_ := FALSE;

                     IF (supp_select_ = 'INTSUPPTRANS') THEN
                        supply_code_ := 'IPT';
                     ELSIF (supp_select_ = 'INTSUPPDIR') THEN
                        supply_code_ := 'IPD';
                     ELSIF (supp_select_ = 'EXTSUPPTRANS') THEN
                        supply_code_ := 'PT';
                     ELSIF (supp_select_ = 'EXTSUPPDIR') THEN
                        supply_code_ := 'PD';
                     ELSIF (supp_select_ IN ('PRISUPPTRANS', 'ANYSUPPTRANS')) THEN
                        supply_code_ := supply_code_ || 'T';
                     ELSIF (supp_select_ IN ('PRISUPPDIR', 'ANYSUPPDIR')) THEN
                        supply_code_ := supply_code_ || 'D';
                     ELSE -- Any supplier
                        any_supplier_ := TRUE;
                        -- for any supplier two records will be added - Transit and Direct
                        supply_code_ := supply_code_ || 'T';
                     END IF;
                     Trace_SYS.Field('supply_code', supply_code_);
                     attr_ := keyattr_;
                     Client_SYS.Add_To_Attr('PRIORITY', altrec_.priority, attr_);
                     Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', supply_code_, attr_);
                     Client_SYS.Add_To_Attr('VENDOR_NO', supprec_.vendor_no, attr_);
                     Cust_Order_Line_Source_Set_API.New_Alternative__(attr_);
                     Trace_SYS.Message('Alternative added');

                     -- If "Any supplier", add a Direct supply alternative as well...
                     IF any_supplier_ THEN
                        supply_code_ := replace(supply_code_, 'T', 'D');
                        Client_SYS.Set_Item_Value('SUPPLY_CODE_DB', supply_code_, attr_);
                        Cust_Order_Line_Source_Set_API.New_Alternative__(attr_);
                        Trace_SYS.Message('Any supplier: Extra alternative added');
                     END IF;
                  ELSE
                      Trace_SYS.Field('Unwanted supplier type - found category', vendor_category_);
                  END IF;
               END LOOP;
            END;
         $ELSE
            NULL;
         $END         
      END IF;
   END LOOP;

   -- Remove suppliers that doesn't exist in the Matrixes
   -- Update the ones that do exist - with shipping time, distance, cost, earliest date and planned qty.
   Trace_SYS.Message('Check unavailable alternatives');
   FOR srcrec_ IN get_co_source_set(order_no_, line_no_, rel_no_, line_item_no_) LOOP

      Trace_SYS.Field('row_no', srcrec_.row_no);
      Trace_SYS.Field('priority', srcrec_.priority);
      Trace_SYS.Field('supply_code', srcrec_.supply_code);

      -- to use the correct part in date and leadtime calculations...
      supplier_part_no_          := nvl(part_no_, purchase_part_no_);

      ship_via_code_             := NULL;
      supplier_ship_via_transit_ := NULL;
      delivery_leadtime_         := NULL;
      def_addr_flag_db_          := default_addr_flag_db_;  
      shipping_time_             := 0;
      cost_                      := 0;
      distance_                  := 0;
      ext_transport_calendar_id_ := NULL;
      picking_leadtime_          := NULL;
      route_id_                  := NULL;
      forward_agent_id_          := NULL;
      shipment_type_             := NULL;

      -- Modified to fetch default values unconditionally before reassigning the necessary attributes when the supply code is IPD or IPT.
      Cust_Order_Leadtime_Util_API.Get_Sc_Defaults_For_Sourcing(route_id_, forward_agent_id_, ship_via_code_, delivery_terms_, del_terms_location_,
         supplier_ship_via_transit_, delivery_leadtime_, ext_transport_calendar_id_, def_addr_flag_db_,
         shipping_time_, cost_, distance_, picking_leadtime_, shipment_type_, contract_, customer_no_, ship_addr_no_,
         addr_flag_db_, part_no_, supplier_part_no_, srcrec_.supply_code, srcrec_.vendor_no, agreement_id_,
         default_ship_via_, default_delivery_terms_, default_del_terms_location_, default_leadtime_, default_ext_transport_cal_id_, default_route_id_, 
         default_forward_agent_id_, default_picking_leadtime_, default_shipment_type_);          

      -- No default ship via code in supply chain matrix - remove alternative!
      IF (ship_via_code_ IS NULL) OR (srcrec_.supply_code IN ('IPT', 'PT') AND supplier_ship_via_transit_ IS NULL) THEN
         Trace_SYS.Message('No ship via found - remove alternative');
         -- this alternative is not an option (no ship_via or no supply/supplier)
         Cust_Order_Line_Source_Set_API.Delete_Alternative__(srcrec_.order_no, srcrec_.line_no,
            srcrec_.rel_no, srcrec_.line_item_no, srcrec_.row_no);
         Trace_SYS.Message('Alternative removed');

      -- update the alternative with the calculated values for later sorting/selection
      ELSE
         Trace_SYS.Message('Update alternative with extra data');
         
         -- Added condition to avoid the method call to fetch default delivery information if the demand_code is IPD or IPT.
         -- Delivery information sent into this method should be used when the demand_code is IPD or IPT.
         IF (demand_code_ IN ('IPD', 'IPT')) THEN
            ship_via_code_             := default_ship_via_;
            delivery_terms_            := default_delivery_terms_;
            del_terms_location_        := default_del_terms_location_;
            delivery_leadtime_         := default_leadtime_;  
            forward_agent_id_          := default_forward_agent_id_;
            IF demand_code_ = 'IPD' THEN
               ext_transport_calendar_id_ := default_ext_transport_cal_id_;
               picking_leadtime_          := default_picking_leadtime_;
               route_id_                  := default_route_id_;
               shipment_type_             := default_shipment_type_;
            END IF;
         END IF;
      
         IF (srcrec_.vendor_no IS NOT NULL) THEN
            Get_Supplier_Info___(vendor_contract_, vendor_category_, srcrec_.vendor_no);
            site_ := NVL(vendor_contract_, contract_);
         ELSE
            site_ := contract_;
         END IF;

         -- if this is a supply site sourcing we need to have the revised_qty_due_ 
         -- in supply site inventory UoM when we check for full_qty_date on the supply site
         IF (vendor_contract_ IS NOT NULL) THEN
            temp_revised_qty_due_ := Inventory_Part_API.Get_Site_Converted_Qty(contract_, part_no_, revised_qty_due_, site_, 'ADD');
         ELSE
            temp_revised_qty_due_ := revised_qty_due_;
         END IF;

         -- "full quantity date" (ATP date) only available for IPD, IPT and IO where
         -- either "availability check" or "online consumption" is used.
         full_qty_date_ := Get_Available_Date___(site_, supplier_part_no_, temp_revised_qty_due_, srcrec_.supply_code, picking_leadtime_);
         Trace_SYS.Field('full qty date', full_qty_date_);

         IF (full_qty_date_ IS NOT NULL) THEN
            avail_date_ := full_qty_date_;
         ELSIF (nvl(vendor_category_, ' ') = 'E') THEN
            avail_date_ := SYSDATE;
         ELSE
            avail_date_ := Site_API.Get_Site_Date(site_);
         END IF;

         -- add total shipping time in days from supplier to customer (direct or transit)
         -- calculate from available date forwards to get an earliest delivery date
         Cust_Ord_Date_Calculation_API.Calc_Sourcing_Dates(earliest_date_, dummy_, avail_date_,
            supply_site_due_date_, picking_leadtime_, wanted_delivery_date_, customer_no_, ship_addr_no_, addr_flag_db_, srcrec_.vendor_no,
            ship_via_code_, delivery_leadtime_, picking_leadtime_, ext_transport_calendar_id_, supplier_ship_via_transit_, route_id_, srcrec_.supply_code, contract_, part_no_,
            supplier_part_no_, TRUE);

         Trace_SYS.Field('earliest delivery date', earliest_date_);

         -- get the quantity available on the "wanted delivery date" minus total shipping time in days
         Calculate_Available___(avail_qty_, avail_date_, customer_no_, ship_addr_no_, addr_flag_db_, srcrec_.vendor_no,
            supplier_ship_via_transit_, contract_, ship_via_code_, delivery_leadtime_, picking_leadtime_, ext_transport_calendar_id_, srcrec_.supply_code, part_no_,
            supplier_part_no_, wanted_delivery_date_, route_id_);

         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
         Client_SYS.Add_To_Attr('SUPPLIER_SHIP_VIA_TRANSIT', supplier_ship_via_transit_, attr_);
         Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', delivery_leadtime_, attr_);
         Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
         Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', def_addr_flag_db_, attr_);
         Client_SYS.Add_To_Attr('SHIPPING_TIME', shipping_time_, attr_);
         Client_SYS.Add_To_Attr('EXPECTED_ADDITIONAL_COST', cost_, attr_);
         Client_SYS.Add_To_Attr('DISTANCE', distance_, attr_);
         Client_SYS.Add_To_Attr('EARLIEST_DELIVERY_DATE', earliest_date_, attr_);
         -- add the customer's wanted  delivery date as well - as info.
         Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
         Client_SYS.Add_To_Attr('AVAILABLE_TO_PROMISE_QTY', avail_qty_, attr_);
         Client_SYS.Add_To_Attr('AVAILABLE_TO_PROMISE_DATE', full_qty_date_, attr_);
         Client_SYS.Add_To_Attr('CANDIDATE', 'FALSE', attr_);
         Client_SYS.Add_To_Attr('SELECTED', 'FALSE', attr_);
         Client_SYS.Add_To_Attr('PICKING_LEADTIME', picking_leadtime_, attr_);
         Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, attr_);
         Client_SYS.Add_To_Attr('DELIVERY_TERMS', delivery_terms_, attr_);
         Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);

         Cust_Order_Line_Source_Set_API.Modify_Alternative__(srcrec_.order_no, srcrec_.line_no,
            srcrec_.rel_no, srcrec_.line_item_no, srcrec_.row_no, attr_);
         Trace_SYS.Message('Alternative updated');
      END IF;
   END LOOP;
   Trace_SYS.Message('Source set created');
END Create_Source_Set___;


-- Get_Available_Date___
--   Returns the date when the required quantity is available -
--   at the supplier (or "our" own inventory).
FUNCTION Get_Available_Date___ (
   contract_         IN VARCHAR2,
   purchase_part_no_ IN VARCHAR2,   
   required_qty_     IN NUMBER,
   supply_code_db_   IN VARCHAR2,
   picking_leadtime_ IN NUMBER ) RETURN DATE
IS
   available_date_   DATE;
   site_rec_         Site_API.Public_Rec;
BEGIN
   -- check order supply demand (Availability check or Online consumption)
   IF (supply_code_db_ IN ('IPD', 'IPT', 'IO')) AND Part_Uses_Atp___(contract_, purchase_part_no_) THEN
      available_date_ := Order_Supply_Demand_API.Get_Planned_Del_Date_Shell(contract_, purchase_part_no_, required_qty_, 'FALSE', picking_leadtime_);
      -- The date returned will include the picking leadtime at the supply site
      -- Remove the picking leadtime to get the due date at supply site
      site_rec_         := Site_API.Get(contract_);
      available_date_   := Work_Time_Calendar_API.Get_Start_Date(site_rec_.dist_calendar_id, available_date_, picking_leadtime_);

   -- the part should not use ATP due to incorrect supply code or inventory part doesn't exist.
   ELSE
      available_date_ := NULL;
   END IF;

   RETURN trunc(available_date_);
END Get_Available_Date___;


-- Get_First_Alternative___
--   Returns the supply_code and vendor for the one selected row
PROCEDURE Get_First_Alternative___ (
   supply_code_db_            IN OUT VARCHAR2,
   vendor_no_                 IN OUT VARCHAR2,
   ship_via_code_             IN OUT VARCHAR2,
   delivery_terms_            IN OUT VARCHAR2,
   del_terms_location_        IN OUT VARCHAR2,
   supplier_ship_via_transit_ IN OUT VARCHAR2,
   delivery_leadtime_         IN OUT NUMBER,
   ext_transport_calendar_id_ IN OUT VARCHAR2,
   default_addr_flag_db_      IN OUT VARCHAR2,
   route_id_                  IN OUT VARCHAR2,
   picking_leadtime_          IN OUT NUMBER,
   shipment_type_             IN OUT VARCHAR2,
   order_no_                  IN     VARCHAR2,
   line_no_                   IN     VARCHAR2,
   rel_no_                    IN     VARCHAR2,
   line_item_no_              IN     NUMBER )
IS
   CURSOR get_first(selected_ IN VARCHAR2) IS
      SELECT supply_code, vendor_no, ship_via_code, delivery_terms, del_terms_location,
             supplier_ship_via_transit, delivery_leadtime, ext_transport_calendar_id,
             default_addr_flag, picking_leadtime, route_id, shipment_type
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = selected_
      ORDER BY priority;
BEGIN
   OPEN get_first('TRUE');
   FETCH get_first INTO supply_code_db_, vendor_no_, ship_via_code_, delivery_terms_, del_terms_location_,
                        supplier_ship_via_transit_, delivery_leadtime_, ext_transport_calendar_id_,
                        default_addr_flag_db_, picking_leadtime_, route_id_, shipment_type_;
   -- if no alternative selected, return the first record found alphabetically in prio order.
   IF (get_first%NOTFOUND) THEN
      CLOSE get_first;
      OPEN get_first('FALSE');
      FETCH get_first INTO supply_code_db_, vendor_no_, ship_via_code_, delivery_terms_, del_terms_location_,
                           supplier_ship_via_transit_, delivery_leadtime_, ext_transport_calendar_id_,
                           default_addr_flag_db_, picking_leadtime_, route_id_, shipment_type_;
      CLOSE get_first;
   ELSE
      CLOSE get_first;
   END IF;
END Get_First_Alternative___;


-- Get_Selected_Rows___
--   Returns number of selected rows.
FUNCTION Get_Selected_Rows___ (
   order_no_             IN VARCHAR2,
   line_no_              IN VARCHAR2,
   rel_no_               IN VARCHAR2,
   line_item_no_         IN NUMBER ) RETURN NUMBER
IS
   CURSOR get_selected IS
      SELECT count(*)
      FROM cust_order_line_source_set_tab
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND candidate = 'TRUE'
      AND selected = 'TRUE';

   rows_ NUMBER;
BEGIN
   OPEN get_selected;
   FETCH get_selected INTO rows_;
   IF get_selected%NOTFOUND THEN
      rows_ := 0;
   END IF;
   CLOSE get_selected;
   RETURN rows_;
END Get_Selected_Rows___;


-- Get_Supplier_Info___
--   Fetches the supplier's site and category. (Internal/External)
PROCEDURE Get_Supplier_Info___ (
   supply_site_ IN OUT VARCHAR2,
   category_    IN OUT VARCHAR2,
   vendor_no_   IN     VARCHAR2 )
IS   
BEGIN
   IF (vendor_no_ IS NOT NULL) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         DECLARE
            suprec_  Supplier_API.Public_Rec;
         BEGIN
            suprec_      := Supplier_API.Get(vendor_no_);
            supply_site_ := suprec_.acquisition_site;
            category_    := suprec_.category;
         END;
      $ELSE
         supply_site_ := NULL;
         category_    := NULL;
      $END      
   ELSE
      supply_site_ := NULL;
      category_    := NULL;
   END IF;
END Get_Supplier_Info___;


-- Handle_Deferred_Errors___
--   Sets the background job to Warning state and sends a customer order
--   line event. This method takes care of Deferred errrors and genrally
--   uses by Automatically sourcing
PROCEDURE Handle_Deferred_Errors___ (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   rel_no_        IN VARCHAR2,
   line_item_no_  IN NUMBER,
   error_message_ IN VARCHAR2 )
IS
   info_ VARCHAR2(2000);
BEGIN
   info_ := Language_SYS.Translate_Constant(lu_name_, 'ORDELINERERR: Order: :P1  Line no: :P2  Del no: :P3',
                                            NULL, order_no_, line_no_, rel_no_ || '. ' || error_message_);

   -- add warning to background job
   Transaction_SYS.Set_Status_Info(info_);

   -- send sourcing error event
   Cust_Order_Event_Creation_API.Order_Line_Sourcing_Error(order_no_, line_no_, rel_no_, line_item_no_, error_message_);
END Handle_Deferred_Errors___;


-- Part_Uses_Atp___
--   Returns TRUE if the inventory part's Online Consumption flag or
--   Onhand Analysis flag (Availability Check) is set.
FUNCTION Part_Uses_Atp___ (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   iprec_  Inventory_Part_API.Public_Rec;
BEGIN
   iprec_ := Inventory_Part_API.Get(contract_, part_no_);
   RETURN ((nvl(iprec_.forecast_consumption_flag, ' ') = 'FORECAST') OR (nvl(iprec_.onhand_analysis_flag, ' ') = 'Y'));
END Part_Uses_Atp___;


-- Reset_Selection___
--   Selects the sourcing "candidates" depending on "delivery on time" or not.
--   All alternatives are at the same time unselected.
PROCEDURE Reset_Selection___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   on_time_      IN BOOLEAN )
IS
   CURSOR get_alternative IS
      SELECT order_no, line_no, rel_no, line_item_no, row_no,
             wanted_delivery_date, earliest_delivery_date,
             candidate, selected
      FROM cust_order_line_source_set_tab
      WHERE  order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;

   CURSOR get_earliest IS
      SELECT min(earliest_delivery_date)
      FROM cust_order_line_source_set_tab
      WHERE  order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_
      AND earliest_delivery_date > wanted_delivery_date;

   candidate_  VARCHAR2(5);
   earliest_   DATE;
   attr_       VARCHAR2(2000);
BEGIN
   -- fetch the earliest delivery date
   IF NOT on_time_ THEN
      OPEN get_earliest;
      FETCH get_earliest INTO earliest_;
      CLOSE get_earliest;
      Trace_SYS.Field('earliest delivery date', earliest_);
   END IF;

   FOR rec_ IN get_alternative LOOP
      candidate_ := 'FALSE';
      -- if this delivery is on time
      IF (rec_.wanted_delivery_date >= rec_.earliest_delivery_date) THEN
         IF on_time_ THEN
            candidate_ := 'TRUE';
         END IF;
      -- is this the earliest delivery date
      ELSIF NOT on_time_ THEN
         IF (rec_.earliest_delivery_date = earliest_) THEN
            candidate_ := 'TRUE';
         END IF;
      END IF;
      Trace_SYS.Field('Candidate', candidate_);
      Client_SYS.Add_To_Attr('CANDIDATE', candidate_, attr_);
      Client_SYS.Add_To_Attr('SELECTED', 'FALSE', attr_);
      Cust_Order_Line_Source_Set_API.Modify_Alternative__(rec_.order_no, rec_.line_no,
                                                          rec_.rel_no, rec_.line_item_no, rec_.row_no, attr_);
   END LOOP;
   Trace_SYS.Message('Selection reset');
END Reset_Selection___;


-- Get_Sourcing_Values___
--   Fetches earliest delivery date, total shipping_time, distance and cost
--   for a customer - supplier - supply code - part combination.
--   Used by the Manual Sourcing client.
PROCEDURE Get_Sourcing_Values___ (
   earliest_delivery_date_       IN OUT DATE,
   supply_site_ep_due_date_      IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   total_shipping_time_          IN OUT NUMBER,
   total_distance_               IN OUT NUMBER,
   total_expected_cost_          IN OUT NUMBER,
   wanted_delivery_date_         IN     DATE,
   customer_no_                  IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supplier_ship_via_transit_    IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   route_id_                     IN     VARCHAR2,
   revised_qty_due_              IN     NUMBER )
IS
   due_date_             DATE;
   dummy_date_           DATE := NULL;
   full_qty_date_        DATE;
   site_                 VARCHAR2(5);
   vendor_contract_      VARCHAR2(5) := NULL;
   vendor_category_      VARCHAR2(20) := NULL;
   temp_revised_qty_due_ NUMBER;
   picking_leadtime_     NUMBER;
BEGIN
   -- fetch totals
   Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Totals(total_distance_,
      total_expected_cost_, total_shipping_time_, contract_, customer_no_,
      ship_addr_no_, addr_flag_db_, part_no_, supplier_part_no_, supply_code_db_,
      vendor_no_, ship_via_code_, supplier_ship_via_transit_, 
      default_delivery_leadtime_, default_picking_leadtime_);

   -- fetch supply site due date (wanted_delivery_date is used as start date)
   Cust_Ord_Date_Calculation_API.Calc_Sourcing_Dates(dummy_date_, dummy_date_, planned_due_date_,
      supply_site_due_date_, picking_leadtime_, wanted_delivery_date_, customer_no_, ship_addr_no_, addr_flag_db_, vendor_no_,
      ship_via_code_, default_delivery_leadtime_, default_picking_leadtime_, default_ext_transport_cal_id_, supplier_ship_via_transit_, route_id_,
      supply_code_db_, contract_, part_no_, supplier_part_no_, FALSE);
   Trace_SYS.Field('supply site due date', supply_site_due_date_);
   Trace_SYS.Field('planned due date', planned_due_date_);

   IF (vendor_no_ IS NOT NULL) THEN
      Get_Supplier_Info___(vendor_contract_, vendor_category_, vendor_no_);
   END IF;

   site_ := nvl(vendor_contract_, contract_);
   -- if this is a supply site sourcing we need to have the revised_qty_due_ 
   -- in supply site inventory UoM when we check for full_qty_date on the supply site
   IF (supply_code_db_ IN ('IPT','IPD')) THEN
      temp_revised_qty_due_ := Inventory_Part_API.Get_Site_Converted_Qty(contract_, part_no_, revised_qty_due_, site_, 'ADD');
   ELSE
      temp_revised_qty_due_ := revised_qty_due_;
   END IF;

   -- "full quantity date" (ATP date) only available for IPD, IPT and IO where
   -- either "availability check" or "online consumption" is used.
   -- for IO, supplier_part_no is NULL.
   full_qty_date_ := Get_Available_Date___(site_, nvl(supplier_part_no_, part_no_), temp_revised_qty_due_, supply_code_db_, picking_leadtime_);

   IF (full_qty_date_ IS NOT NULL) THEN
      due_date_ := full_qty_date_;
   ELSE
      IF (nvl(vendor_category_, ' ') = 'E') THEN
         due_date_ := trunc(SYSDATE);
      ELSE
         due_date_ := trunc(Site_API.Get_Site_Date(site_));
      END IF;
      -- full qty date is only used for time check...
      full_qty_date_ := due_date_;
   END IF;

   Trace_SYS.Field('due date', due_date_);

   -- fetch earliest delivery date (due_date is used as start date)
   Cust_Ord_Date_Calculation_API.Calc_Sourcing_Dates(earliest_delivery_date_, dummy_date_, due_date_,
      supply_site_ep_due_date_, picking_leadtime_, full_qty_date_, customer_no_, ship_addr_no_, addr_flag_db_, vendor_no_,
      ship_via_code_, default_delivery_leadtime_, default_picking_leadtime_, default_ext_transport_cal_id_, supplier_ship_via_transit_, route_id_,
      supply_code_db_, contract_, part_no_, supplier_part_no_, TRUE);

   Trace_SYS.Field('earliest supply site due date', supply_site_ep_due_date_);
   Trace_SYS.Field('earliest delivery date', earliest_delivery_date_);
END Get_Sourcing_Values___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Source_Automatically__
--   Overloaded. Sources a customer order line automatically and returns
--   the found supply code, supplier, ship via code, delivery leadtime and
--   the value to set for the default adress flag on the customer order line.
--   Sources the passed customer order line automatically. Called from
--   either the client or from the schedule methods.
--   Called from overloaded method or directly from Customer_Order_Line_API.
--   This method only works for non-DOP parts.
--   It will search a sourcing rule's source set and return the "ultimate"
--   supply code and supplier.
--   ** THIS IS THE MAIN AUTOMATIC SOURCING METHOD **
PROCEDURE Source_Automatically__ (
   info_         OUT VARCHAR2,
   order_no_     IN  VARCHAR2,
   line_no_      IN  VARCHAR2,
   rel_no_       IN  VARCHAR2,
   line_item_no_ IN  NUMBER )
IS
   linerec_                   Customer_Order_Line_API.Public_Rec;
   supply_code_db_            VARCHAR2(20);
   vendor_no_                 customer_order_line_tab.vendor_no%TYPE;
   ship_via_code_             VARCHAR2(3);
   delivery_terms_            VARCHAR2(5);
   del_terms_location_        VARCHAR2(100);
   supplier_ship_via_transit_ VARCHAR2(3);
   delivery_leadtime_         NUMBER;
   ext_transport_calendar_id_ VARCHAR2(10);
   default_addr_flag_         VARCHAR2(1);
   attr_                      VARCHAR2(32000);
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   route_id_                  VARCHAR2(12);
   forward_agent_id_          VARCHAR2(20);
   picking_leadtime_          NUMBER;
   shipment_type_             VARCHAR2(3);

   CURSOR get_record IS
      SELECT rowid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000))
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   linerec_           := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);

   supply_code_db_    := linerec_.supply_code;
   vendor_no_         := linerec_.vendor_no;
   default_addr_flag_ := linerec_.default_addr_flag;

   Source_Automatically__(route_id_, forward_agent_id_, supply_code_db_, vendor_no_, ship_via_code_, delivery_terms_, del_terms_location_,
                          supplier_ship_via_transit_,
                          delivery_leadtime_, ext_transport_calendar_id_, default_addr_flag_, picking_leadtime_, shipment_type_,
                          order_no_, line_no_, rel_no_, line_item_no_,
                          linerec_.contract, linerec_.catalog_no,
                          linerec_.part_no, linerec_.purchase_part_no,
                          linerec_.revised_qty_due, linerec_.deliver_to_customer_no,
                          linerec_.ship_addr_no, linerec_.addr_flag,
                          linerec_.wanted_delivery_date, linerec_.demand_code);

   Client_SYS.Clear_Attr(attr_);

   -- If supply chain parameters have changed, modify the order line accordingly
   IF (supply_code_db_ != linerec_.supply_code) THEN
      Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', supply_code_db_, attr_);
   END IF;

   IF (NVL(vendor_no_, ' ') != nvl(linerec_.vendor_no, ' ')) THEN
      Client_SYS.Add_To_Attr('VENDOR_NO', vendor_no_, attr_);
   END IF;

   IF (ship_via_code_ != linerec_.ship_via_code) THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
      Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', delivery_leadtime_, attr_);
      Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
   END IF;

   IF (NVL(supplier_ship_via_transit_, ' ') != NVL(linerec_.supplier_ship_via_transit, ' ')) THEN
      Client_SYS.Add_To_Attr('SUPPLIER_SHIP_VIA_TRANSIT', supplier_ship_via_transit_, attr_);
   END IF;

   IF (NVL(route_id_, Database_SYS.string_null_) != NVL(linerec_.route_id, Database_SYS.string_null_)) THEN
      Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
   END IF;

   IF (picking_leadtime_!= linerec_.picking_leadtime) THEN
      Client_SYS.Add_To_Attr('PICKING_LEADTIME', picking_leadtime_, attr_);
   END IF;

   IF (NVL(forward_agent_id_, Database_SYS.string_null_) != NVL(linerec_.forward_agent_id, Database_SYS.string_null_)) THEN
      Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
   END IF;

   IF (shipment_type_ != linerec_.shipment_type) THEN
      Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, attr_);
   END IF;

   IF (default_addr_flag_ != linerec_.default_addr_flag) THEN
      Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', default_addr_flag_, attr_);
   END IF;

   IF (attr_ IS NOT NULL) THEN
      OPEN get_record;
      FETCH get_record INTO objid_, objversion_;
      CLOSE get_record;
      Customer_Order_Line_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   ELSE
      info_ := NULL;
   END IF;

EXCEPTION
   WHEN others THEN
      -- handle errors raised in e.g. Source_Automatically__...
      IF Transaction_SYS.Is_Session_Deferred THEN
         Handle_Deferred_Errors___(order_no_, line_no_, rel_no_, line_item_no_, SQLERRM);
      ELSE
         RAISE;
      END IF;
END Source_Automatically__;


-- Source_Automatically__
--   Overloaded. Sources a customer order line automatically and returns
--   the found supply code, supplier, ship via code, delivery leadtime and
--   the value to set for the default adress flag on the customer order line.
--   Sources the passed customer order line automatically. Called from
--   either the client or from the schedule methods.
--   Called from overloaded method or directly from Customer_Order_Line_API.
--   This method only works for non-DOP parts.
--   It will search a sourcing rule's source set and return the "ultimate"
--   supply code and supplier.
--   ** THIS IS THE MAIN AUTOMATIC SOURCING METHOD **
PROCEDURE Source_Automatically__ (
   route_id_                  IN OUT VARCHAR2,
   forward_agent_id_          IN OUT VARCHAR2,
   supply_code_db_            IN OUT VARCHAR2,
   vendor_no_                 IN OUT VARCHAR2,
   ship_via_code_             IN OUT VARCHAR2,
   delivery_terms_            IN OUT VARCHAR2,
   del_terms_location_        IN OUT VARCHAR2,
   supplier_ship_via_transit_ IN OUT VARCHAR2,
   delivery_leadtime_         IN OUT NUMBER,
   ext_transport_calendar_id_ IN OUT VARCHAR2,
   default_addr_flag_db_      IN OUT VARCHAR2,
   picking_leadtime_          IN OUT NUMBER,
   shipment_type_             IN OUT VARCHAR2,
   order_no_                  IN     VARCHAR2,
   line_no_                   IN     VARCHAR2,
   rel_no_                    IN     VARCHAR2,
   line_item_no_              IN     NUMBER,
   contract_                  IN     VARCHAR2,
   catalog_no_                IN     VARCHAR2,
   part_no_                   IN     VARCHAR2,
   purchase_part_no_          IN     VARCHAR2,
   revised_qty_due_           IN     NUMBER,
   customer_no_               IN     VARCHAR2,
   ship_addr_no_              IN     VARCHAR2,
   addr_flag_db_              IN     VARCHAR2,
   wanted_delivery_date_      IN     DATE,
   demand_code_db_            IN     VARCHAR2)
IS
   autosrc_                      BOOLEAN;
   rule_id_                      VARCHAR2(15) := NULL;
   error_msg_                    VARCHAR2(2000);
   count_                        NUMBER;
   order_rec_                    Customer_Order_API.Public_Rec;
   pkg_rec_                      Customer_Order_Line_API.Public_Rec;
   site_date_                    DATE;
   agreement_id_                 VARCHAR2(10);
   default_ship_via_             VARCHAR2(3);
   default_delivery_terms_       VARCHAR2(5);
   default_del_terms_location_   VARCHAR2(100);
   default_leadtime_             NUMBER;
   agreement_ship_via_           VARCHAR2(3);
   direct_delivery_              BOOLEAN := FALSE;
   buy_qty_due_                  NUMBER;
   effectivity_date_             DATE;
   date_entered_                 DATE;
   freight_map_id_               VARCHAR2(15);
   zone_id_                      VARCHAR2(15);
   default_ext_transport_cal_id_ VARCHAR2(10);
   default_route_id_             VARCHAR2(12);
   default_forward_agent_id_     VARCHAR2(20);
   default_picking_leadtime_     NUMBER;
   default_shipment_type_        VARCHAR2(3);
   ship_inventory_location_no_   VARCHAR2(35);
   
   CURSOR get_order_line IS
      SELECT buy_qty_due, price_effectivity_date, date_entered
      FROM customer_order_line_tab 
      WHERE order_no = order_no_
      AND line_no = line_no_
      AND rel_no = rel_no_
      AND line_item_no = line_item_no_;
BEGIN
   autosrc_ := (supply_code_db_ = 'SRC');
   Trace_SYS.Field('Automatic sourcing', autosrc_);

   order_rec_      := Customer_Order_API.Get(order_no_);
   IF (line_item_no_ > 0) THEN
      pkg_rec_                      := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, -1);
      default_ship_via_             := pkg_rec_.ship_via_code;
      default_delivery_terms_       := pkg_rec_.delivery_terms;
      default_del_terms_location_   := pkg_rec_.del_terms_location;
      default_leadtime_             := pkg_rec_.delivery_leadtime;
      default_ext_transport_cal_id_ := pkg_rec_.ext_transport_calendar_id;
      default_route_id_             := pkg_rec_.route_id;
      default_forward_agent_id_     := pkg_rec_.forward_agent_id;
      default_picking_leadtime_     := pkg_rec_.picking_leadtime;
      default_shipment_type_        := pkg_rec_.shipment_type;
   ELSE
      default_ship_via_             := order_rec_.ship_via_code;
      default_delivery_terms_       := order_rec_.delivery_terms;
      default_del_terms_location_   := order_rec_.del_terms_location;
      default_leadtime_             := order_rec_.delivery_leadtime;
      default_ext_transport_cal_id_ := order_rec_.ext_transport_calendar_id;
      default_route_id_             := order_rec_.route_id;
      default_forward_agent_id_     := order_rec_.forward_agent_id;
      default_picking_leadtime_     := order_rec_.picking_leadtime;
      default_shipment_type_        := order_rec_.shipment_type;
   END IF;

   -- Initial checks
   IF (supply_code_db_ NOT IN ('ND', 'SRC')) THEN
      Trace_SYS.Message('Supply code is ' || supply_code_db_ || '. Automatic sourcing not possible.');
      RETURN;
   ELSIF (addr_flag_db_ = 'Y') THEN
      -- Single occurrence address, no sourcing possible just copy supply chain parameters from order header.
      supply_code_db_ := 'ND';
      IF ((demand_code_db_ != 'IPD') OR (demand_code_db_ IS NULL)) THEN
         ship_via_code_             := default_ship_via_;
         delivery_terms_            := default_delivery_terms_;
         del_terms_location_        := default_del_terms_location_;
         delivery_leadtime_         := default_leadtime_;
         ext_transport_calendar_id_ := default_ext_transport_cal_id_;
         forward_agent_id_          := default_forward_agent_id_;
         picking_leadtime_          := default_picking_leadtime_;
         shipment_type_             := default_shipment_type_;
         route_id_                  := default_route_id_;
      END IF;
      supplier_ship_via_transit_ := NULL;

   ELSIF (supply_code_db_ = 'ND') THEN
      Trace_SYS.Message('Supply code is ND, check if manual sourcing has executed.');
      -- check if manual sourcing has been performed...
      IF (nvl(Sourced_Cust_Order_Line_API.Get_Total_Sourced_Qty(order_no_, line_no_, rel_no_, line_item_no_), 0) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'ALREADYSOURCED: This order line is already sourced. If necessary change the sourcing manually.');
      END IF;
   END IF;

   -- Check if sales part's connected to a rule...
   IF (ship_addr_no_ IS NOT NULL) THEN
      rule_id_ := Source_Rule_Per_Cust_Addr_API.Get_Rule_Id(customer_no_, ship_addr_no_, contract_, catalog_no_);
      Trace_SYS.Field('Rule from customer address', rule_id_);
   END IF;

   IF (rule_id_ IS NULL) THEN
      -- there's no rule connected to the address, check the customer
      rule_id_ := Source_Rule_Per_Customer_API.Get_Rule_Id(customer_no_, contract_, catalog_no_);
      Trace_SYS.Field('Rule from customer', rule_id_);
      IF (rule_id_ IS NULL) THEN
         -- there's no rule connected to the customer, check the sales part
         rule_id_ := Sales_Part_API.Get_Rule_Id(contract_, catalog_no_);
         Trace_SYS.Field('Rule from sales part', rule_id_);
      END IF;
   END IF;
   IF (rule_id_ IS NULL) THEN
      error_msg_ := 'NOSOURCINGRULE: No sourcing rule is connected to the sales part :P1.';
      IF autosrc_ THEN
         Client_SYS.Add_Info(lu_name_, error_msg_, catalog_no_);
         supply_code_db_ := 'ND';
         vendor_no_      := NULL;
      ELSE
         Error_SYS.Record_General(lu_name_, error_msg_, catalog_no_);
      END IF;
   ELSE
      Trace_SYS.Message('Check if sourcing alternatives exists');
      -- a sourcing rule exist - check if it contains a source set.
      IF (Sourcing_Alternative_API.Check_Exist(rule_id_) = 0) THEN
         error_msg_ := 'NOSOURCESET: No sourcing alternatives are defined for sourcing rule :P1.';
         IF autosrc_ THEN
            Client_SYS.Add_Info(lu_name_, error_msg_, rule_id_);
            supply_code_db_ := 'ND';
            vendor_no_      := NULL;
         ELSE
            Error_SYS.Record_General(lu_name_, error_msg_, rule_id_);
         END IF;
      END IF;
   END IF;

   -- If the supply has changed already, exit procedure
   IF (autosrc_ AND (supply_code_db_ != 'SRC')) THEN
      Trace_SYS.Field('No need to continue. Automatic sourcing set supply code', supply_code_db_);
      RETURN;
   END IF;

   -- Start the automatic sourcing by creating a "source set"
   Trace_SYS.Message('Start automatic sourcing.');

   -- Fetch agreement for part if any
   site_date_    := Site_API.Get_Site_Date(contract_);
   agreement_id_ := Customer_Order_API.Get_Agreement_Id(order_no_);
   OPEN get_order_line;
   FETCH get_order_line INTO buy_qty_due_, effectivity_date_, date_entered_;
   CLOSE get_order_line;
   IF ((agreement_id_ IS NULL) OR
       ( NOT Agreement_Sales_Part_Deal_API.Find_And_Check_Exist(agreement_id_, buy_qty_due_, 
                                                                NVL(effectivity_date_, date_entered_), catalog_no_)) OR
       (Customer_Agreement_API.Is_Valid(agreement_id_, contract_, customer_no_, order_rec_.currency_code, site_date_) = 0)) THEN
      Customer_Agreement_API.Get_Agreement_For_Part(agreement_id_,
                                                    customer_no_,
                                                    contract_,
                                                    order_rec_.currency_code,
                                                    catalog_no_,
                                                    site_date_);
      IF ( agreement_id_ IS NOT NULL) THEN
         agreement_ship_via_ := Customer_Agreement_API.Get_Ship_Via_Code(agreement_id_);
      END IF;
   END IF;
   -- If the demand_code is IPD or IPT, delivery information sent through the ORDERS message should be used
   IF (demand_code_db_ IN ('IPD', 'IPT')) THEN
      default_ship_via_             := ship_via_code_;
      default_delivery_terms_       := delivery_terms_;
      default_leadtime_             := delivery_leadtime_;
      default_forward_agent_id_     := forward_agent_id_;
      IF demand_code_db_ = 'IPD' THEN
         default_ext_transport_cal_id_ := ext_transport_calendar_id_;
         default_picking_leadtime_     := picking_leadtime_;
         default_route_id_             := route_id_;
         default_shipment_type_        := shipment_type_;
      END IF;
   END IF;
   Create_Source_Set___(order_no_, line_no_, rel_no_, line_item_no_, rule_id_,
                        contract_, catalog_no_, part_no_, purchase_part_no_, revised_qty_due_,
                        wanted_delivery_date_, customer_no_, ship_addr_no_, default_addr_flag_db_,
                        addr_flag_db_,agreement_id_,default_ship_via_, default_delivery_terms_, default_del_terms_location_, default_leadtime_, default_ext_transport_cal_id_, default_route_id_, 
                        default_forward_agent_id_, default_picking_leadtime_, default_shipment_type_, demand_code_db_);

   Trace_SYS.Message('Find on time deliveries');
   -- Set the source set candidates - alternatives that can deliver on time.
   Reset_Selection___(order_no_, line_no_, rel_no_, line_item_no_, TRUE);

   -- Set Selected for records that corresponds to the different criteria - unselect the rest
   Check_Sourcing_Criteria___(order_no_, line_no_, rel_no_, line_item_no_, rule_id_);

   -- Check if found
   count_ := Get_Selected_Rows___(order_no_, line_no_, rel_no_, line_item_no_);

   IF (count_ = 0) THEN
      Trace_SYS.Field('selected rows found', count_);
      Trace_SYS.Message('Find earliest deliveries');
      -- If noone found, check alternatives that can deliver earliest.
      Reset_Selection___(order_no_, line_no_, rel_no_, line_item_no_, FALSE);

      Check_Sourcing_Criteria___(order_no_, line_no_, rel_no_, line_item_no_, rule_id_);

      -- Check if any found
      count_ := Get_Selected_Rows___(order_no_, line_no_, rel_no_, line_item_no_);
   END IF;

   Trace_SYS.Field('selected rows found', count_);
   IF (count_ >= 1) THEN
      Trace_SYS.Message('"pick first"');
      -- pick the first available alternative
      Get_First_Alternative___(supply_code_db_, vendor_no_, ship_via_code_, delivery_terms_, del_terms_location_, supplier_ship_via_transit_, delivery_leadtime_, ext_transport_calendar_id_, default_addr_flag_db_, route_id_, picking_leadtime_, shipment_type_, order_no_, line_no_, rel_no_, line_item_no_);

      -- Direct delivery is not allowed when COGS is delayed to delivery confirmation - set ND in that case
      IF (supply_code_db_ IN ('PD', 'IPD')) THEN
         IF (Customer_Order_API.Get_Delay_Cogs_To_Dc_Db(order_no_) = 'TRUE') THEN
            Trace_SYS.Message('Direct Delivery: Delay COGS is set - set supply code ND');
            direct_delivery_ := TRUE;
            count_           := 0; -- this will enter next "if"
         END IF;
      END IF;
   END IF;

   IF (count_ = 0) THEN
      -- raise an error if nothing was found (or Direct delivery + Delay COGS)
      IF autosrc_ THEN
         -- present an info message since we're updating the order line at this point.
         IF direct_delivery_ THEN
            Client_SYS.Add_Info(lu_name_, 'DIRECTDEL_DC: The best sourcing alternative found was ":P1". Not allowed when Cost of Goods Sold is delayed to Delivery Confirmation.', Order_Supply_Type_API.Decode(supply_code_db_));
         ELSE
            Client_SYS.Add_Info(lu_name_, 'NOSOURCING: No sourcing alternative found!');
         END IF;
         supply_code_db_ := 'ND';
         vendor_no_      := NULL;
         IF (agreement_ship_via_ IS NOT NULL) THEN
            ship_via_code_ := agreement_ship_via_;
            Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes(route_id_,
                                                                   forward_agent_id_,
                                                                   delivery_leadtime_,
                                                                   ext_transport_calendar_id_,
                                                                   freight_map_id_,
                                                                   zone_id_,
                                                                   picking_leadtime_,
                                                                   shipment_type_,
                                                                   ship_inventory_location_no_,
                                                                   delivery_terms_,
                                                                   del_terms_location_,
                                                                   contract_,
                                                                   customer_no_,
                                                                   ship_addr_no_,
                                                                   addr_flag_db_,
                                                                   ship_via_code_,
                                                                   part_no_,
                                                                   supply_code_db_);
            delivery_leadtime_ := NVL(delivery_leadtime_, 0);
         ELSIF ((demand_code_db_ != 'IPD') OR (demand_code_db_ IS NULL)) THEN
            ship_via_code_             := default_ship_via_;
            delivery_terms_            := default_delivery_terms_;
            del_terms_location_        := default_del_terms_location_;
            delivery_leadtime_         := default_leadtime_;
            ext_transport_calendar_id_ := default_ext_transport_cal_id_;
            picking_leadtime_          := default_picking_leadtime_;
            forward_agent_id_          := default_forward_agent_id_;
            route_id_                  := default_route_id_;
            shipment_type_             := default_shipment_type_;
         END IF;
         supplier_ship_via_transit_ := NULL;
      ELSE
         IF direct_delivery_ THEN
            -- present an error - since supply code is already set to ND for this record at this point.
            Error_SYS.Record_General(lu_name_, 'DIRECTDEL_DC: The best sourcing alternative found was ":P1". Not allowed when Cost of Goods Sold is delayed to Delivery Confirmation.', Order_Supply_Type_API.Decode(supply_code_db_));
         ELSE
            Error_SYS.Record_General(lu_name_, 'NOSOURCING: No sourcing alternative found!');
         END IF;
      END IF;
   END IF;

   Trace_SYS.Field('Selected SUPPLY_CODE', supply_code_db_);
   Trace_SYS.Field('Selected VENDOR_NO', vendor_no_);
END Source_Automatically__;


-- Source_Order_Lines__
--   This function sources all order lines connected to the passed site
--   (or all sites if %).
--   Called from Schedule_Sourcing__.
--   This function sources all order lines connected to the passed site
--   (or all sites if %). Called from Schedule_Sourcing__.
--   Note! Since configured parts are not allowed to source on, a warning
--   is displayed if this method finds any.
PROCEDURE Source_Order_Lines__ (
   contract_ IN VARCHAR2 )
IS
   -- finds all order lines where order status is Planned
   -- and supply code is Not Decided.
   CURSOR get_not_decided IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no,
             col.contract, col.catalog_no, col.part_no
      FROM CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_TAB co
      WHERE co.order_no = col.order_no
      AND   col.supply_code = 'ND'
      AND   EXISTS (SELECT 1 FROM user_allowed_site_pub ua 
                    WHERE col.contract = site)
      AND co.rowstate = 'Planned'
      AND col.contract LIKE contract_
      AND col.rowstate != 'Cancelled';

   prefix_   VARCHAR2(2000);
   ptr_      NUMBER;
   type_     VARCHAR2(30);
   message_  VARCHAR2(32000);
   info_     VARCHAR2(32000);
   deferred_ BOOLEAN := Transaction_SYS.Is_Session_Deferred;
BEGIN
   -- % indicates all allowed sites
   IF (nvl(contract_, ' ') != '%') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;

   FOR rec_ IN get_not_decided LOOP
      Source_Automatically__(info_, rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);

      -- display each message as separate status info.
      IF deferred_ AND (info_ IS NOT NULL) THEN
         -- add a prefix to each message to know which order generated them...
         prefix_ := Language_SYS.Translate_Constant(lu_name_, 'AUTOSRC_ORDER: Order :P1, :P2, :P3.', NULL,
                                                    rec_.order_no, rec_.line_no, rec_.rel_no);
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(info_, ptr_, type_, message_)) LOOP
            IF (type_ = 'INFO') THEN
               Transaction_SYS.Set_Status_Info(prefix_ || ' ' || message_, 'INFO');
            END IF;
         END LOOP;
      END IF;
   END LOOP;
END Source_Order_Lines__;


-- Get_Site_Converted_Qty__
--   This function converts a quantity from one sites inv UoM to another sites
--   in UoM, but it will not convert infinity value.
--   Called from both manual sourcing client and from the automatic sourcing flow.
@UncheckedAccess
FUNCTION Get_Site_Converted_Qty__ (
   contract_        IN VARCHAR2,
   part_no_         IN VARCHAR2,
   quantity_        IN NUMBER,
   to_contract_     IN VARCHAR2,
   rounding_action_ IN VARCHAR2 ) RETURN NUMBER
IS
   to_quantity_ NUMBER;
BEGIN
   -- 999999999.99 defines infinity in this case and we want to convert this to another UoM
   IF (quantity_ = 999999999.99) THEN
      to_quantity_ := quantity_; 
   ELSE
      to_quantity_ := Inventory_Part_API.Get_Site_Converted_Qty(contract_, part_no_, quantity_, to_contract_, rounding_action_);
   END IF;
   RETURN to_quantity_;
END Get_Site_Converted_Qty__;



-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Atp_Quantity
--   Returns the quantity that is available at a given due date.
@UncheckedAccess
FUNCTION Get_Atp_Quantity (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2,
   due_date_ IN DATE ) RETURN NUMBER
IS
BEGIN
   -- if "availability check" or "online consumption" is not set for the part return NULL.
   IF NOT Part_Uses_Atp___(contract_, part_no_) THEN
      RETURN NULL;

   -- only check supply/demand - even if online consumption
   ELSE
      -- Note: If no quantity is available return 0.
      --       Floor stock location also has been included for the check.
      RETURN nvl(Order_Supply_Demand_API.Get_Qty_Plannable_Shell(contract_, part_no_, due_date_, 'TRUE'), 0);
   END IF;
END Get_Atp_Quantity;



-- Check_Order_Fully_Sourced
--   Checks if all the order lines with status Not Decided are fully
--   sourced or not.
FUNCTION Check_Order_Fully_Sourced (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_order_details IS
      SELECT line_no, line_item_no, rel_no, revised_qty_due
        FROM customer_order_line_tab
       WHERE order_no = order_no_
         AND supply_code = 'ND'
         AND rowstate != 'Cancelled';

   total_sourced_qty_    NUMBER;
BEGIN
   FOR linerec_ IN get_order_details LOOP
      IF (Sourced_Cust_Order_Line_API.Check_Exist(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no) = 1) THEN
         total_sourced_qty_ := Sourced_Cust_Order_Line_API.Get_Total_Sourced_Qty(order_no_, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
         IF (linerec_.revised_qty_due > total_sourced_qty_) THEN
            RETURN 'FALSE';
         END IF;
      ELSE
         RETURN 'FALSE';
      END IF;
   END LOOP;
   --Note: if there is no order line found, then RETURN TRUE.
   RETURN 'TRUE';
END Check_Order_Fully_Sourced;


-- Create_Sourcing_Lines
--   Creates instance of Sourced Cust Order Line or update it accordingly.
--   Called from Manual Sourcing. Configured parts are not allowed there!
PROCEDURE Create_Sourcing_Lines (
   info_                 OUT VARCHAR2,
   order_no_             IN  VARCHAR2,
   line_no_              IN  VARCHAR2,
   rel_no_               IN  VARCHAR2,
   line_item_no_         IN  NUMBER,
   sourced_qty_          IN  NUMBER,
   ship_via_code_        IN  VARCHAR2,
   supply_code_db_       IN  VARCHAR2,
   wanted_delivery_date_ IN  DATE,
   supply_site_due_date_ IN  DATE,
   vendor_no_            IN  VARCHAR2,
   planned_due_date_     IN  DATE,
   latest_release_date_  IN  DATE )
IS
   rec_                      SOURCED_CUST_ORDER_LINE_TAB%ROWTYPE;
   total_sourced_qty_        NUMBER;
   source_id_                NUMBER;
   attr_                     VARCHAR2(32000);
   already_sourced_qty_      NUMBER;
   configured_               VARCHAR2(20);
   ordline_rec_              Customer_Order_Line_API.Public_Rec;
   supply_site_              VARCHAR2(5);
   supply_site_reserve_type_ VARCHAR2(20);
   source_objid_             VARCHAR2(2000);
   attr1_                    VARCHAR2(32000);
   supplier_part_no_         VARCHAR2(25);
   category_                 VARCHAR2(20);
BEGIN

   Get_Supplier_Info___(supply_site_, category_, vendor_no_);

   -- Note: Check ship via exist since rec_.ship_via_code is length 3 only.
   Mpccom_Ship_Via_API.Exist(ship_via_code_, TRUE);

   rec_.order_no             := order_no_;
   rec_.line_no              := line_no_;
   rec_.rel_no               := rel_no_;
   rec_.line_item_no         := line_item_no_;
   rec_.ship_via_code        := ship_via_code_;
   rec_.supply_code          := supply_code_db_;
   rec_.wanted_delivery_date := wanted_delivery_date_;
   rec_.vendor_no            := vendor_no_;
   rec_.planned_due_date     := planned_due_date_;
   rec_.supply_site_due_date := supply_site_due_date_;

   ordline_rec_ := Customer_Order_Line_API.Get(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   configured_  := Part_Catalog_API.Get_Configurable_Db(nvl(ordline_rec_.part_no, ordline_rec_.catalog_no));
   IF (supply_code_db_ = 'SO') THEN
      IF (Inventory_Part_API.Get_Type_Code_Db(ordline_rec_.contract, ordline_rec_.part_no) NOT IN ('1', '2'))THEN
         Error_SYS.Record_General(lu_name_, 'NOSOPOSSIBLE: Supply Code ''Shop Order'' is not allowed for purchased parts');
      END IF;
   END IF;

   IF (configured_ = 'CONFIGURED') THEN
      Error_SYS.Record_General(lu_name_, 'CONFIGLINENOTSRCED: This part is configured. Please, change supply code manually on customer order line');
   END IF;

   supplier_part_no_ := nvl(ordline_rec_.part_no, ordline_rec_.purchase_part_no);

   source_id_        := Sourced_Cust_Order_Line_API.Get_Sourced_Line_Source_Id(rec_);
   IF (latest_release_date_ IS NOT NULL) THEN
      source_id_ := 0;  -- always create new source line if the capability check have been performed
   END IF;

   total_sourced_qty_ := Sourced_Cust_Order_Line_API.Get_Total_Sourced_Qty ( rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   IF  (source_id_ = 0) THEN
      IF ((nvl(total_sourced_qty_,0) = ordline_rec_.revised_qty_due) OR ((nvl(total_sourced_qty_,0) + nvl(sourced_qty_,0) ) > ordline_rec_.revised_qty_due)) THEN
         Error_SYS.Record_General(lu_name_, 'TOTQTYSOURCED: Already sourced quantity exceeds revised quantity');
      ELSE
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
         Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
         Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
         Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
         Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', supply_code_db_, attr_);
         Client_SYS.Add_To_Attr('SOURCED_QTY', sourced_qty_, attr_);
         Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
         Client_SYS.Add_To_Attr('SUPPLY_SITE_DUE_DATE', supply_site_due_date_, attr_);
         Client_SYS.Add_To_Attr('VENDOR_NO', vendor_no_, attr_);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
         IF supply_site_ IS NOT NULL THEN
            Client_SYS.Add_To_Attr('SUPPLY_SITE', supply_site_, attr_);
         END IF;
         Client_SYS.Add_To_Attr('PLANNED_DUE_DATE', planned_due_date_, attr_);
         Client_SYS.Add_To_Attr('LATEST_RELEASE_DATE', latest_release_date_, attr_);

         Sourced_Cust_Order_Line_API.New( attr_, 'DO');

         --Note: Set ReleasePlanning to RELEASED
         Client_SYS.Clear_Attr(attr1_);
         Client_SYS.Add_To_Attr('RELEASE_PLANNING_DB', 'RELEASED', attr1_);
         Customer_Order_Line_API.Modify(attr1_, order_no_, line_no_, rel_no_, line_item_no_);

         source_id_ := Client_SYS.Get_Item_Value('SOURCE_ID', attr_);

         -- Note: do instant reservation
         IF (supply_code_db_ IN ('IPT', 'IPD') AND vendor_no_ IS NOT NULL) THEN
            -- Note: check if the inventory part exists on the supply_site (is the supply_site in the same database)
            IF (Inventory_Part_API.Part_Exist(supply_site_, supplier_part_no_) = 1) THEN
               -- Note: check if a security connection exists between the CO/PO Site (Demand site) and the Supply Site
               IF (Site_To_Site_Reserve_Setup_API.Connection_Allowed(supply_site_, ordline_rec_.contract) = 1) THEN
                  -- Note: get default supply_site_reserve_type
                  supply_site_reserve_type_ := Site_To_Site_Reserve_Setup_API.Get_Supply_Site_Reserve_Db(supply_site_, ordline_rec_.contract);
                  IF (supply_site_reserve_type_ = 'INSTANT') THEN
                     -- Note: if default supply_site_reserve_type = INSTANT, do instant reservation
                     source_objid_ := Sourced_Cust_Order_Line_API.Get_Objid(order_no_, line_no_, rel_no_, line_item_no_, source_id_);
                     Reserve_Customer_Order_API.Create_Instant_Reservation__(order_no_, line_no_, rel_no_, line_item_no_,
                                                                             source_id_, supplier_part_no_, sourced_qty_,
                                                                             ordline_rec_.qty_shipped, source_objid_, vendor_no_);
                  END IF;
               END IF;
            END IF;
         END IF;

      END IF;
   ELSE
      already_sourced_qty_ := Sourced_Cust_Order_Line_API.Get_Sourced_Qty(order_no_, line_no_, rel_no_, line_item_no_, source_id_);
      IF (nvl(total_sourced_qty_,0) + nvl(sourced_qty_,0)) > ordline_rec_.revised_qty_due THEN
         Error_SYS.Record_General(lu_name_, 'TOTQTYSOURCED: Already sourced quantity exceeds revised quantity');
      ELSE
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', supply_code_db_, attr_);
         Client_SYS.Add_To_Attr('SOURCED_QTY', sourced_qty_ + already_sourced_qty_, attr_);
         Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
         Client_SYS.Add_To_Attr('SUPPLY_SITE_DUE_DATE', supply_site_due_date_, attr_);
         Client_SYS.Add_To_Attr('VENDOR_NO', vendor_no_, attr_);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
         Client_SYS.Add_To_Attr('PLANNED_DUE_DATE', planned_due_date_, attr_);

         Sourced_Cust_Order_Line_API.Modify( attr_, order_no_, line_no_, rel_no_, line_item_no_, source_id_);

         -- Note: do instant reservation
         IF (supply_code_db_ IN ('IPT', 'IPD') AND vendor_no_ IS NOT NULL) THEN
            -- Note: check if the inventory part exists on the supply_site (is the supply_site in the same database)
            IF (Inventory_Part_API.Part_Exist(supply_site_, supplier_part_no_) = 1) THEN
               -- Note: check if a security connection exists between the CO/PO Site (Demand site) and the Supply Site
               IF (Site_To_Site_Reserve_Setup_API.Connection_Allowed(supply_site_, ordline_rec_.contract) = 1) THEN
                  -- Note: get default supply_site_reserve_type
                  supply_site_reserve_type_ := Site_To_Site_Reserve_Setup_API.Get_Supply_Site_Reserve_Db(supply_site_, ordline_rec_.contract);
                  IF (supply_site_reserve_type_ = 'INSTANT') THEN
                     -- Note: if default supply_site_reserve_type = INSTANT, do instant reservation
                     source_objid_ := Sourced_Cust_Order_Line_API.Get_Objid(order_no_, line_no_, rel_no_, line_item_no_,source_id_);
                     Reserve_Customer_Order_API.Create_Instant_Reservation__(order_no_, line_no_, rel_no_, line_item_no_,
                                                                             source_id_, supplier_part_no_, sourced_qty_,
                                                                             ordline_rec_.qty_shipped, source_objid_,vendor_no_);
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   -- Note: if instant reservation failed let the user know that he has to reserve manully instead
   IF (supply_site_reserve_type_ = 'INSTANT' AND Sourced_Co_Supply_Site_Res_API.Sourced_Reservation_Exist(order_no_, line_no_, rel_no_, line_item_no_, source_id_) = 0) THEN
      Client_SYS.Add_Info(lu_name_, 'INSTANT_NOT_POSSIBLE: It was not possible to make a complete instant reservation so you have to reserve manually instead.');
   END IF;

   info_ := Client_SYS.Get_All_Info;
END Create_Sourcing_Lines;


-- Get_Src_Own_Invent_Values
--   Calculates earliest delivery date, total shipping time, total distance,
--   and total cost for parts supplied from own inventory (IO or NO).
@UncheckedAccess
PROCEDURE Get_Src_Own_Invent_Values (
   earliest_delivery_date_       IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   total_shipping_time_          IN OUT NUMBER,
   total_distance_               IN OUT NUMBER,
   total_expected_cost_          IN OUT NUMBER,
   wanted_delivery_date_         IN     DATE,
   customer_no_                  IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   route_id_                     IN     VARCHAR2,
   revised_qty_due_              IN     NUMBER )
IS
   supply_site_due_date_    DATE;
   supply_site_ep_due_date_ DATE;
BEGIN
   Get_Sourcing_Values___(earliest_delivery_date_, supply_site_ep_due_date_,
      planned_due_date_, supply_site_due_date_, total_shipping_time_,
      total_distance_, total_expected_cost_, wanted_delivery_date_, customer_no_,
      ship_addr_no_, addr_flag_db_, NULL, ship_via_code_, default_delivery_leadtime_, default_picking_leadtime_, default_ext_transport_cal_id_,
      NULL, supply_code_db_, contract_, part_no_, NULL, route_id_, revised_qty_due_);
END Get_Src_Own_Invent_Values;


-- Get_Src_Supplier_Values
--   Calculates earliest delivery date, total shipping time, total distance,
--   total cost and supply site due date for parts supplied from internal
--   or external suppliers.
PROCEDURE Get_Src_Supplier_Values (
   earliest_delivery_date_       IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_ep_due_date_      IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   total_shipping_time_          IN OUT NUMBER,
   total_distance_               IN OUT NUMBER,
   total_expected_cost_          IN OUT NUMBER,
   ship_via_code_                IN OUT VARCHAR2,
   supplier_ship_via_transit_    IN OUT VARCHAR2,
   wanted_delivery_date_         IN     DATE,
   customer_no_                  IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   catalog_no_                   IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   route_id_                     IN     VARCHAR2,
   revised_qty_due_              IN     NUMBER,
   default_ship_via_code_        IN     VARCHAR2,
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   currency_code_                IN     VARCHAR2 )
IS
   delivery_leadtime_         NUMBER := NULL;
   def_addr_flag_db_          VARCHAR2(1);
   agreement_id_              VARCHAR2(10);
   freight_map_id_            VARCHAR2(15);
   zone_id_                   VARCHAR2(15);
   ext_transport_calendar_id_ VARCHAR2(10);
   route_                     VARCHAR2(12);
   forward_agent_id_          VARCHAR2(20);
   picking_leadtime_          NUMBER;
   dummy_shipment_type_       VARCHAR2(3);
   delivery_terms_               VARCHAR2(5);
   del_terms_location_           VARCHAR2(100);
   default_delivery_terms_       VARCHAR2(5);
   default_del_terms_location_   VARCHAR2(100);
BEGIN

   -- if passing NULL - fetch default ship via.
   IF (ship_via_code_ IS NULL) THEN
      Customer_Agreement_API.Get_Agreement_For_Part(agreement_id_, customer_no_,
         contract_, currency_code_, catalog_no_, Site_API.Get_Site_Date(contract_));

      Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Defaults(route_, forward_agent_id_, ship_via_code_, delivery_terms_, del_terms_location_,
         supplier_ship_via_transit_, delivery_leadtime_, ext_transport_calendar_id_, def_addr_flag_db_,
         freight_map_id_, zone_id_, picking_leadtime_, dummy_shipment_type_, contract_, customer_no_,
         ship_addr_no_, addr_flag_db_, part_no_,
         supply_code_db_, vendor_no_, agreement_id_, default_ship_via_code_, default_delivery_terms_, default_del_terms_location_,
         default_delivery_leadtime_, default_ext_transport_cal_id_, route_id_, NULL, default_picking_leadtime_, dummy_shipment_type_);
   ELSIF (ship_via_code_ = default_ship_via_code_) THEN
      IF (supply_code_db_ = 'IPT') THEN
         delivery_terms_            := default_delivery_terms_;
         del_terms_location_        := default_del_terms_location_;
         delivery_leadtime_         := default_delivery_leadtime_;
         ext_transport_calendar_id_ := default_ext_transport_cal_id_;
         route_                     := route_id_;
         picking_leadtime_          := default_picking_leadtime_;
      END IF;
   END IF;

   Get_Sourcing_Values___(earliest_delivery_date_, supply_site_ep_due_date_,
      planned_due_date_, supply_site_due_date_, total_shipping_time_,
      total_distance_, total_expected_cost_, wanted_delivery_date_, customer_no_,
      ship_addr_no_, addr_flag_db_, vendor_no_, ship_via_code_, delivery_leadtime_, picking_leadtime_, ext_transport_calendar_id_,
      supplier_ship_via_transit_, supply_code_db_, contract_, part_no_, supplier_part_no_,
      route_, revised_qty_due_);
END Get_Src_Supplier_Values;


-- Validate_Params
--   Validates the parameters when running the Schedule for Source Order
--   Lines Automatically.
PROCEDURE Validate_Params (
   message_ IN VARCHAR2 )
IS
   count_     NUMBER;
   name_arr_  Message_SYS.name_table;
   value_arr_ Message_SYS.line_table;
   contract_  VARCHAR2(5);
BEGIN
   Message_SYS.Get_Attributes(message_, count_, name_arr_, value_arr_);

   FOR n_ IN 1..count_ LOOP
      IF (name_arr_(n_) = 'CONTRACT_') THEN
         contract_ := NVL(value_arr_(n_), '%');
      END IF;
   END LOOP;
   
   IF (contract_ IS NOT NULL) AND (contract_ != '%') THEN
      User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, contract_);
   END IF;
END Validate_Params;



