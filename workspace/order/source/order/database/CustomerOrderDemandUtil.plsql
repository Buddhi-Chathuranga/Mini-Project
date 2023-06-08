-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderDemandUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170626  ManWlk   STRMF-12066, Added new public cursor get_order_supply_demand_site tailored for Site MRP and modified get_order_supply_demand for Selective MRP to improve the performance.
--  170506  ErFelk   Bug 133412, Modified the WHERE caluse of CURSOR get_order_supply_demand to check rel_mtrl_planning.
--  161026  Hairlk   APPUXX-5312, Included rejected quotation to the get_quotation_demand cursor
--  150908  SHEWLK   Bug 124039, Used separate public cursors for Selective MRP - get_order_demand_site and Full Site MRP - get_order_demand_site to increase performance in Selective MRP.
--  130723  JanWse   Bug 110898, Modified cursors get_order_demand, View CUSTOMER_ORDER_LINE_MS and functions Get_Pmrp_Order_Demand and Get_Mrp_Spares_Order_Demand
--  130723           to add a condition to exclude Exchange Items as demands for MRP Process.
--  111025  NWeelk   Bug 94992, Modified cursors get_order_demand, views CUSTOMER_ORDER_LINE_DEMAND, CUSTOMER_ORDER_LINE_MS, CUSTOMER_ORDER_LINE_EXT 
--  111025           and functions Get_Pmrp_Order_Demand, Get_Mrp_Spares_Order_Demand by adding rel_mtrl_planning to the WHERE clause.
--  111010  DAWELK   Bug 99328, Modified cursors get_order_supply_demand and get_order_demand: removed check 'activity_seq IS NULL' in where statement.
--  110804  MaAnlk   Bug 96097, Modified the cursor Get_Mrp_Spares_Order_Demand.
--  110628  SudJlk   Bug 95144, Modified views CUSTOMER_ORDER_LINE_DEMAND_OE, CUSTOMER_ORDER_LINE_EXT and CUSTOMER_ORDER_LINE_DEMAND to change select statement for date_required.
--  100723  SudJlk   Bug 92052, Modified CUSTOMER_ORDER_LINE_DEMAND_OE, CUSTOMER_ORDER_LINE_EXT and CUSTOMER_ORDER_LINE_DEMAND to include credit blocked records with supply code 'DOP'.
--  100718  CwiClk   Bug 91481, Modified the function Get_Mrp_Spares_Order_Demand to retrive customer orders with supply code 'PT' and 'PD'.
--  100717  CwiClk   Bug 91148, Added new method Get_Mrp_Spares_Order_Demand to get the Purchased Order demands for MRP Spares calculations.
--  100621  ChJalk   Bug 91325, Modified views CUSTOMER_ORDER_LINE_EXT and CUSTOMER_ORDER_LINE_DEMAND_OE to exclude records with 
--  100621           supply code 'PRD' in states 'Released','Reserved','Picked' and 'PartiallyDelivered' as no need to show 'PRD' lines in availability planning in those states.  
--  100618  KiSalk   Modified CUSTOMER_ORDER_LINE_DEMAND view to include supply code 'IPD' for the supply_site. 
--  100604  ErFelk   Bug 90983, Modified CUSTOMER_ORDER_LINE_DEMAND_OE, CUSTOMER_ORDER_LINE_EXT and CUSTOMER_ORDER_LINE_DEMAND to include creidt blocked records with supply code 'SO'.
--  100517  Ajpelk   Merge rose method documentation
--  100430  NuVelk   Merged Twin Peaks.
--  100211  SudJlk   Bug 87574, Modified CUSTOMER_ORDER_LINE_DEMAND_OE and CUSTOMER_ORDER_LINE_EXT to include creidt blocked records with supply code IPT/IPD/PT/PD and where pegged object is already created.
--  100211           Modified CUSTOMER_ORDER_LINE_DEMAND to include creidt blocked records with supply code IPT/PT and where pegged object is already created.
--  100126  SudJlk   Bug 87574, Modified view CUSTOMER_ORDER_LINE_EXT to include records with header state CreditBlocked and line level supply code PD or PT. 
			--  090629  RoJalk   Modified get_order_supply_demand cursor to exclude project connected Purchase Order Trans - Customer Orders.
			--  090513  RoJalk   Modified Get_Pmrp_Order_Demand and get_order_demand to consider the situation
			--  090513           Customer Order is project connected and pegged to a shop order.
			--  090512  HaYalk   Modified Get_Pmrp_Order_Demand to add supply codes PT and checked for activity_seq IS NOT NULL.
			--  090504  NuVelk   Modified cursor get_order_demand to include demands with supply_code PT.
--  090824  SudJlk   Bug 85158, Modified CUSTOMER_ORDER_LINE_MS to remove cancelled CO line demands from the Master Schedule.
--  090516  SudJlk   Bug 80267, Modified CUSTOMER_ORDER_LINE_MS to consider online consumption check towards the demand site for supply codes PD/PT. 
--  090516           Modified SALES_QUOTATION_LINE_MS by changing the check for order_supply_type.
--  090213  SudJlk   Bug 79028, Modified the view CUSTOMER_ORDER_LINE_MS by removing the conversion of revised_qty_due, qty_on_order 
--  090213           and qty_assigned to supply site's inventory UoM.
--  090204  SudJlk   Bug 79028, Modified the view CUSTOMER_ORDER_LINE_MS to consider the online consumption check towards the demand site 
--  090204           when supply code is IPT/IPD.
--  080910  ChJalk   Bug 75647, Removed the Supply code 'PRD' from the where statement of CUSTOMER_ORDER_LINE_EXT view and from CUSTOMER_ORDER_LINE_DEMAND_OE view,
--  080910           as no need to show PRD lines in availability planning.
--  080715  Prawlk   Bug 73198, Decoded the project_id and activity_seq using supply_code in 
--  080715           CUSTOMER_ORDER_LINE_SHORTAGE view. 
--  080510  HoInlk   Bug 73474, Modified WHERE condition of views CUSTOMER_ORDER_LINE_DEMAND_OE
--  080510           and SOURCED_ORDER_LINE_DEMAND_OE to match qty_demand calculation.
--  080110  LaNilk   Bug 69475, Modified the view CUSTOMER_ORDER_LINE_MS to stop releasing consumed forecast when customer order is reserved.
--  071207  CwIclk   Bug 69532, Modified the view CUSTOMER_ORDER_LINE_MS to consider demands with supply code 'DOP'.
--  070814  WaJalk   Bug 66465, Modified view CUSTOMER_ORDER_LINE_MS, reduced qty_assigned from revised_qty_due.
--  070731  NuVelk   Bug 65015, Modified views CUSTOMER_ORDER_LINE_DEMAND, CUSTOMER_ORDER_LINE_DEMAND_OE and CUSTOMER_ORDER_LINE_EXT.
--  070619  WaJalk   Bug 64747, Modified CUSTOMER_ORDER_LINE_DEMAND view to filter out supply codes 'IPD' and 'PD'. 
--  061103  DaZase   Added call to Inventory_Part_API.Get_Site_Converted_Qty in supply demand views.
--    060818   SaRalk   Removed all Hints in order supply demand views.   
--    060817   ChBalk   Reversed public cursor changes.
--  060717  ChBalk   Removed get_order_demand,get_quotation_demand and get_order_supply_demand public cursors implementations.
--  ----------------------------13.4.0------------------------------------------
--  060524  JOHESE   Added column project_sourced to CUSTOMER_ORDER_LINE_SHORTAGE
--  060424  JOHESE   Added columns project_id and activity_seq to view CUSTOMER_ORDER_LINE_SHORTAGE
--  060306  MAJO     CTP planned customer order line demands can be included in MRP.
--                   Modified cursor get_order_demand.
--  050623  JOHESE   Modified views SOURCED_ORDER_LINE_EXT, SOURCED_ORDER_LINE_DEMAND and SOURCED_ORDER_LINE_MS to show reserved quantity
--  050516  JOHESE   Modified views CUSTOMER_ORDER_LINE_DEMAND, CUSTOMER_ORDER_LINE_DEMAND_OE
--                   CUSTOMER_ORDER_LINE_EXT and CUSTOMER_ORDER_LINE_MS to show lines with supply code PI on orders in status planned
--  050411  GeKalk   Modified CUSTOMER_ORDER_LINE_DEMAND and CUSTOMER_ORDER_LINE_EXT to fetch DO details if the demand_code = 'DO'
--  050318  DaZase   Changed wanted_delivery_date to planned_due_date on all sourcing views.
--  050207  NaLrlk   Added order supply demand views from OrderQuotationLine.apy and SourceOrderLines.apy.
--                   Removed all the DEFINE's except the standard ones. Added public cursor get_quotation_demand.
--  050125  NaLrlk   Added the comment before the "PROMPT Creating &VIEW_DEMAND view
--  050111  NaLrLk   Created.
--                   Added the function Get_Pdsm_Order_Demand and added views VIEW_DEMAND,VIEW_DEMAND_CUSTORD,VIEW_MS,VIEW_EXT,VIEW_SHORT. 
--                   Added the public cursors get_order_demand and get_order_supply_demand
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE pmrp_order_demand_rec
IS RECORD  (part_no            VARCHAR2(25),
            order_no           VARCHAR2(12),
            line_no            VARCHAR2(4),
            rel_no             VARCHAR2(4),
            line_item_no       NUMBER,
            planned_due_date   DATE,
            remaining_qty_due  NUMBER,
            supply_code        VARCHAR2(3),
            project_id         VARCHAR2(10),
            activity_seq       NUMBER);
TYPE Pmrp_Order_Demand_Tab IS TABLE OF pmrp_order_demand_rec INDEX BY PLS_INTEGER;
TYPE mrp_spares_order_demand_rec
IS RECORD  (part_no            VARCHAR2(25),
            order_no           VARCHAR2(12),
            line_no            VARCHAR2(4),
            rel_no             VARCHAR2(4),
            line_item_no       NUMBER,
            planned_due_date   DATE,
            remaining_qty_due  NUMBER,
            supply_code        VARCHAR2(3));
TYPE Mrp_Spares_Order_Demand_Tab IS TABLE OF mrp_spares_order_demand_rec INDEX BY PLS_INTEGER;
TYPE order_demand_record IS RECORD (
    part_no           VARCHAR2(25),
    order_no          VARCHAR2(12),
    line_no           VARCHAR2(4),
    rel_no            VARCHAR2(4),
    line_item_no      NUMBER,
    planned_due_date  DATE,
    remaining_qty_due NUMBER,
    supply_code       VARCHAR2(3));
TYPE order_quotation_record IS RECORD (
    part_no           VARCHAR2(25),
    order_no          VARCHAR2(12),
    line_no           VARCHAR2(4),
    rel_no            VARCHAR2(4),
    line_item_no      NUMBER,
    planned_due_date  DATE,
    remaining_qty_due NUMBER );
CURSOR get_order_demand_site (
   contract_ VARCHAR2 ) RETURN order_demand_record
IS
   SELECT line.part_no,
          line.order_no,
          line.line_no,
          line.rel_no,
          line.line_item_no,
          line.planned_due_date,
          line.revised_qty_due - (line.qty_shipped - line.qty_shipdiff + line.qty_on_order + line.qty_assigned) remaining_qty_due,
          line.supply_code
   FROM   customer_order_line_tab line, customer_order_tab head
   WHERE  head.order_no = line.order_no
   AND    line.contract = contract_
   AND    line.line_item_no != -1
   AND    line.rowstate IN ('Released','Reserved','Picked','PartiallyDelivered')
   AND    (line.revised_qty_due - (line.qty_shipped - line.qty_shipdiff + line.qty_on_order + line.qty_assigned) > 0)
   AND    line.part_ownership IN ('COMPANY OWNED', 'CONSIGNMENT')
   AND    (line.ctp_planned = 'N' AND
           (line.supply_code IN ('IO','DOP') OR
           (line.supply_code = 'SO' AND line.qty_on_order > 0) OR
           (line.supply_code = 'PT' AND line.qty_on_order > 0) OR
           (line.supply_code = 'PS' AND head.rowstate != 'Planned'))
          OR
           line.ctp_planned = 'Y' AND
           (line.supply_code = 'DOP' OR
           (line.supply_code = 'PT' AND line.qty_on_order > 0) OR
           (line.supply_code = 'SO' AND line.qty_on_order > 0)) AND 
            head.rowstate != 'Planned')
   AND     line.rel_mtrl_planning = 'TRUE'
   AND     line.exchange_item != 'EXCHANGED ITEM';
CURSOR get_order_demand (
   contract_ VARCHAR2,
   part_no_  VARCHAR2 ) RETURN order_demand_record
IS
   SELECT line.part_no,
          line.order_no,
          line.line_no,
          line.rel_no,
          line.line_item_no,
          line.planned_due_date,
          line.revised_qty_due - (line.qty_shipped - line.qty_shipdiff + line.qty_on_order + line.qty_assigned) remaining_qty_due,
          line.supply_code
   FROM   customer_order_line_tab line, customer_order_tab head
   WHERE  head.order_no = line.order_no
   AND    line.contract = contract_
   AND    line.part_no = part_no_
   AND    line.line_item_no != -1
   AND    line.rowstate IN ('Released','Reserved','Picked','PartiallyDelivered')
   AND    (line.revised_qty_due - (line.qty_shipped - line.qty_shipdiff + line.qty_on_order + line.qty_assigned) > 0)
   AND    line.part_ownership IN ('COMPANY OWNED', 'CONSIGNMENT')
   AND    (line.ctp_planned = 'N' AND
           (line.supply_code IN ('IO','DOP') OR
           (line.supply_code = 'SO' AND line.qty_on_order > 0) OR
           (line.supply_code = 'PT' AND line.qty_on_order > 0) OR
           (line.supply_code = 'PS' AND head.rowstate != 'Planned'))
          OR
           line.ctp_planned = 'Y' AND
           (line.supply_code = 'DOP' OR
           (line.supply_code = 'PT' AND line.qty_on_order > 0) OR
           (line.supply_code = 'SO' AND line.qty_on_order > 0)) AND 
            head.rowstate != 'Planned')
   AND     line.rel_mtrl_planning = 'TRUE'
   AND     line.exchange_item != 'EXCHANGED ITEM';
CURSOR get_order_supply_demand_site (
   contract_ VARCHAR2 ) RETURN order_demand_record
IS
   SELECT part_no,
          order_no,
          line_no,
          rel_no,
          line_item_no,
          supply_site_due_date,
          revised_qty_due  remaining_qty_due,
          supply_code
   FROM   customer_order_line_tab
   WHERE  supply_site = contract_
   AND    line_item_no != -1
   AND    rowstate IN ('Released','Reserved','Picked','PartiallyDelivered')
   AND    revised_qty_due  > 0
   AND    supply_code IN ('IPD', 'IPT')
   AND    release_planning = 'RELEASED'
   AND    rel_mtrl_planning = 'TRUE'
   AND    ctp_planned = 'N';
CURSOR get_order_supply_demand (
   contract_ VARCHAR2,
   part_no_  VARCHAR2 ) RETURN order_demand_record
IS
   SELECT part_no,
          order_no,
          line_no,
          rel_no,
          line_item_no,
          supply_site_due_date,
          revised_qty_due  remaining_qty_due,
          supply_code
   FROM   customer_order_line_tab
   WHERE  supply_site = contract_
   AND    part_no = part_no_
   AND    line_item_no != -1
   AND    rowstate IN ('Released','Reserved','Picked','PartiallyDelivered')
   AND    revised_qty_due  > 0
   AND    supply_code IN ('IPD', 'IPT')
   AND    release_planning = 'RELEASED'
   AND    rel_mtrl_planning = 'TRUE'
   AND    ctp_planned = 'N';
CURSOR get_quotation_demand (
   contract_ VARCHAR2,
   part_no_  VARCHAR2 ) RETURN order_quotation_record
IS
   SELECT part_no,
          quotation_no order_no,
          line_no,
          rel_no,
          line_item_no,
          planned_due_date,
          revised_qty_due remaining_qty_due
   FROM   order_quotation_line_tab line
   WHERE  contract = contract_
   AND    part_no LIKE NVL(part_no_,'%')
   AND    release_planning = 'RELEASED'
   AND    line_item_no != -1
   AND    rowstate IN ('Released', 'Revised', 'Rejected')
   AND    revised_qty_due > 0
   AND    order_supply_type IN ('IO', 'WO', 'SO', 'DOP')
   AND    ctp_planned = 'N';

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Pmrp_Order_Demand
--   This method is used to return a collection of customer order lines
--   with Project Inventory demand to the PMRP engine.
@UncheckedAccess
FUNCTION Get_Pmrp_Order_Demand (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   project_id_   IN VARCHAR2,
   activity_seq_ IN NUMBER ) RETURN Pmrp_Order_Demand_Tab
IS
   rec_tab_ Pmrp_Order_Demand_Tab;
   CURSOR get_pmrp_order_rec IS
      SELECT part_no,order_no,line_no,rel_no,line_item_no,planned_due_date,
             revised_qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned) remaining_qty_due,
             supply_code,project_id,activity_seq 
      FROM   customer_order_line_tab 
      WHERE  contract = contract_
      AND    part_no LIKE NVL(part_no_, '%')
      AND    (project_id = project_id_ OR project_id_ IS NULL)
      AND    (activity_seq IS NOT NULL AND (activity_seq = activity_seq_ OR activity_seq_ IS NULL))
      AND    line_item_no != -1
      AND    rowstate IN ('Released','Reserved','Picked','PartiallyDelivered')
      AND    (revised_qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned) > 0)
      AND    part_ownership IN ('COMPANY OWNED', 'CONSIGNMENT')
      AND    (supply_code IN ('PI', 'PT') OR (supply_code = 'SO' AND qty_on_order > 0 ))
      AND    ctp_planned = 'N'
      AND    rel_mtrl_planning = 'TRUE'
      AND    exchange_item != 'EXCHANGED ITEM';
BEGIN
   OPEN   get_pmrp_order_rec;
   FETCH  get_pmrp_order_rec BULK COLLECT INTO rec_tab_;
   CLOSE  get_pmrp_order_rec;
   RETURN rec_tab_;
END Get_Pmrp_Order_Demand;



-- Get_Mrp_Spares_Order_Demand
--   This method is used to return a collection of customer order line demands to MRP Spares calculation.
@UncheckedAccess
FUNCTION Get_Mrp_Spares_Order_Demand (
   contract_     IN VARCHAR2,
   part_no_      IN VARCHAR2 ) RETURN Mrp_Spares_Order_Demand_Tab
IS
   rec_tab_ Mrp_Spares_Order_Demand_Tab;
   CURSOR get_mrp_spares_order_rec IS
      SELECT line.part_no,
             line.order_no,
             line.line_no,
             line.rel_no,
             line.line_item_no,
             line.planned_due_date,
             line.revised_qty_due - (line.qty_shipped - line.qty_shipdiff) remaining_qty_due,
             line.supply_code
      FROM   customer_order_line_tab line, customer_order_tab head
      WHERE  head.order_no = line.order_no
      AND    line.contract = contract_
      AND    line.part_no = part_no_
      AND    line.line_item_no != -1
      AND    line.rowstate IN ('Released','Reserved','Picked','PartiallyDelivered')
      AND    (line.revised_qty_due - (line.qty_shipped - line.qty_shipdiff) > 0)
      AND    line.part_ownership IN ('COMPANY OWNED', 'CONSIGNMENT')
      AND    (line.supply_code IN ('PT','PD','IPT','IPD')
             OR
             (line.ctp_planned = 'N' AND
             (line.supply_code IN ('IO','SO') OR
             (line.supply_code = 'PS' AND head.rowstate != 'Planned'))
             OR
             line.ctp_planned = 'Y' AND line.supply_code = 'SO'AND head.rowstate != 'Planned'))
      AND    line.rel_mtrl_planning = 'TRUE'
      AND    line.exchange_item != 'EXCHANGED ITEM'
      ORDER BY line.planned_due_date;
BEGIN
   OPEN   get_mrp_spares_order_rec;
   FETCH  get_mrp_spares_order_rec BULK COLLECT INTO rec_tab_;
   CLOSE  get_mrp_spares_order_rec;
   RETURN rec_tab_;
END Get_Mrp_Spares_Order_Demand;




