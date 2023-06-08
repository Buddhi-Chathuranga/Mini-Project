-----------------------------------------------------------------------------
--
--  Logical unit: CustOrdDateCalculation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211215  JICESE MF21R2-6262, Modified Perform_Capability_Check to not add a work day after capability check execution for supply code 'IO'.
--  211101  GISSLK MF21R2-5854, Modify Calc_Order_Atp_Date___(), Calc_Order_Dates___(), Calc_Order_Dates_Backwards(), Calc_Quotation_Dates() and Calc_Disord_Dates_Backwards() to consider abnormal demands with online consumption.
--  210614  ManWlk Bug 159674(MFZ-8020), Modified Calc_Order_Atp_Date___  to set run_online_consumption_ FALSE if both old_demand_quantity_ and new_demand_quantity_ are 0.
--  210607  KETKLK   PJ21R2-749, Replaced Project Delivery supply code 'PRD' with Project Deliverables supply code 'PJD' as Project Delivery functionality will be removed.
--  210607  KiSalk Bug 159554(SCZ-15105), Modified Calc_Ship_Date_Backwards___ not to allow past planned ship date for Blocked CO state too. 
--  210518  JoWise  MF21R2-1796, Retrive Time from Delivery Route Schedule when doing Availabilty Check
--  210511  JoWise  MF21R2-1712, Retrive Time from Delivery Route Schedule when Calc Order Dates Forwards
--  210505  JoWise  MF21R2-1486, Added call to add route time to planned due date.
--  200414  JoAnSe MF21R2-750, In Calc_Order_Dates_Forwards no extra day added to due date for SO or DOP supplied order line. 
--  201202  PamPlk Bug 154128(SCZ-12746), Modified Calc_Order_Dates___() and the places which calls to it by passing the supply_site_part_no. Removed supplier_inv_part_no_. 
--  200602  KiSalk Bug 153266(SCZ-9738), In Calc_Ship_Date_Backwards___, called newly created Set_Invalid_Calendar_Info___ to store Calendar IDs that are beyond the dates being handled. 
--  200602         Also added Show_Invalid_Calendar_Info to process App_Context_SYS set for 'CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_' as required.
--  200106  TiRalk SCSPRING20-639, Added method Calc_Plan_Deliv_Date_Forwards to calculate forward planned delivery date when creating
--  200106         component customer order for ESO from CRO.
--  190519  Cpeilk Bug 147826 (SCZ-4760), Modified Calc_Order_Dates___() to get the correct inventory part of supply site.
--  170911  CwIclk Bug 137231, Modified the method Calc_Order_Atp_Date___ to correct the working date mismatch between manufacturing and distribution calendars.
--  161027  VISALK STRMF-7237, Modified Peforme_Capablity_Check() to modify the info message and update some attributes in the InterimCtpCriticalPath Lu.
--  160907  SudJlk STRSC-3927, Modified Calc_Cust_Sched_Plan_Due_Date() to Customer_Agreement_API.Get_First_Valid_Agreement. 
--  160225  ChFolk STRSC-860, Added new parameters transport_leadtime_ and arrival_route_id_ into Calc_Supply_Due_Date_Back___, Calc_Dates_Backwards___, Calc_Due_Date_Forwards___,
--  160225         Calc_Dates_Forwards___, Calc_Order_Atp_Date___ and Calc_Due_Date_Forwards to consider them in leadtime calculations.
--  160114  ChWkLk STRMF-1328, Added '*' in call to Level_1_Part_API.Get_Promise_Method_Db().
--  151221  NipKlk Bug 126037, Reversed the correction done by the bug 123920.
--  150320  ChFolk Replaced the usages of package Customer_Order_Route_API with Delivery_Route_API.
--  150831  ChWkLk Bug 116050, Modified Calc_Order_Atp_Date___() to make the error message more meaningful according to the promise method.
--  150831  ChBnlk Bug 123920, Removed code segment that was written to reset delivery time to the start date in the method Calc_Ship_Date_Backwards___() since its now handled from the client.
--  150826  PrYaLK Bug 124139, Modified Calc_Cust_Sched_Plan_Due_Date() to assign values for sched_contract_, sched_customer_no_ and sched_ship_addr_no_
--  150826         before obtaining customer_rec_ to retrieve Customer data when order_no_ IS NULL.
--  150728  MeAblk Bug 122988, Modified Calc_Ship_Date_Backwards___ in order to correctly set the planned_delivery_date_ when there is a ext transport calendar and delivery time defined in customer. 
--  141128  SBalLK PRSC-3709, Modified Get_Route___() and Calc_Cust_Sched_Plan_Due_Date() methods to fetch delivery terms and delivery terms location from supply chain matrix.
--  141124  MAHPLK PRSC-380, Added new parameter col_objstate_ to Calc_Order_Dates_Backwards,  Calc_Order_Dates___, Calc_Dates_Backwards___ and Calc_Due_Date_Backwards___.
--  141006  MalLlk Bug 118976, Added parameter catalog_type_ to Info_On_Plan_Del_Date_Ch___() and used the value to avoid package component level info messages.
--  140520  MuShlk Bug 116671, Modified Calc_Order_Atp_Date___() in order to change the condition that will execute the online cosunption check.   
--  140508  MuShlk Bug 116671, Added parameter fully_reserved_ to methods Calc_Order_Dates___, Calc_Order_Atp_Date___ and Calc_Order_Dates_Backwards() and also
--  140508         modified Calc_Order_Atp_Date___ to prevent from executing the online consumption logic when the c/o line date is changed when the line is fully reserved.
--  140320  AyAmlk Bug 115501, Modified Calc_Order_Dates___() so that the dates calculated through Calc_Dates_Forwards___() will not override the date calculated without
--  140320         expected lead time in, Calc_Order_Atp_Date___() for sourcing options 'SO', 'DOP' 'PS', 'PT' and 'CRO'.
--  140325  AndDse PBMF-4700, Merged in LCS bug 113040, Passed FALSE as order_line_cancellation_ parameter to the calls Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption().
--  131025  Vwloza Added rental parameter to method calls in Calc_Cust_Sched_Plan_Due_Date.
--  130917  PraWlk Bug 107715, Added default parameter use_current_date_ for Calc_Order_Dates_Backwards(), Calc_Order_Dates___(), Calc_Dates_Backwards___() 
--  130917         and Calc_Ship_Date_Backwards___(). Also modified Calc_Ship_Date_Backwards___() to use the current date appropriately. 
--  130913  ErFelk Bug 109288, Modified Calc_Disord_Dates_Backwards() by adding customer_no_ as a parameter and removed the method call to get the customer_no_. 
--  130704  MaIklk TIBE-962, Removed global constants and used conditional compilation instead. 
--  130521  HimRlk Passed NULL for vendor_no in method call Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  121113  MAHPLK Added parameter contract_ to Get_Previous_Route_Date and Get_Next_Route_Date method calls.
--  120911  MeAblk Added ship_inventory_location_no_ as a parameter to the method Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120824  MeAblk Added shipment_type into the method Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120716  MaMalk Modified Get_Route___ to correctly retrieve the route from the supply chain matrix and if not found to retrieve it from the internal customer.
--  120711  MaHplk Added picking lead time to Calc_Order_Dates_Backwards, Calc_Order_Dates_Forwards, Calc_Disord_Dates_Backwards, Calc_Disord_Dates_Forwards, 
--                 Calc_Quotation_Dates, Calc_Sourcing_Dates, Calc_Sourcing_Dates___, and Calc_Order_Dates___ methods. 
--  120702  MaMalk Added parameters route and forwarder in methods Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120907  Cpeilk Bug 102273, Added parameter catalog_type_ into the methods Calc_Order_Dates_Backwards and Calc_Order_Dates___. Modified Calc_Order_Dates___ in a way 
--  120907         to avoid some package component level info messages.
--  120404  ChJalk Modified methods Check_Date_On_Cust_Calendar_ and Chk_Date_On_Ext_Transport_Cal to check the dates correctly for adding info messages.
--  120313  MaMalk Bug 99430, Modified Calc_Order_Dates_Backwards, Calc_Disord_Dates_Backwards, Calc_Order_Dates___ and Calc_Order_Atp_Date___  to add new parameters inverted_conv_factor_.
--  110819  AndDse EASTTWO-6678, Modified Calc_Ship_Date_Backwards___ and Calc_Del_Date_Forwards___, to get the next workday for external calendar before adding the leadtime.
--  110804  MaAnlk Bug 96097, Modified several methods to add new parameters new_mrp_demand_qty_ and old_mrp_demand_qty_.
--  110629  ChJalk Bug 94693, Modified the method Perform_Capability_Check to avoid forward date calculation if the returned due date
--  110629         from capability check is as same as the one that was sent to the capability check calculation.
--  110401  AndDse BP-4785, Modified Calc_Order_Dates___ so that an info is added also for sales quotation if planned delivery date was changed.
--  110330  AndDse BP-4760, Restructured so that Get_Calendar_Start_Date and Get_Calendar_End_Date is a function with pragma and never raises error,
--  110330         while Fetch_Calendar_Start_Date and Fetch_Calendar_End_Date has error handeling and are procedures.
--  110330         These functions were added while introducing modified calendar functionality in this LU, Error_Date_Not_In_Calendar___, Info_On_Plan_Del_Date_Ch___
--  110330         Apply_Cust_Calendar_To_Date_, Check_Date_On_Cust_Calendar_, Fetch_Calendar_Start_Date, Fetch_Calendar_End_Date and Chk_Date_On_Ext_Transport_Cal.
--  110317  AndDse BP-4453, Modified name on calendar help functions to Fetch_Calendar_Start_Date and Fetch_Calendar_End_Date.
--  110315  AndDse BP-4434, Modified calculations where leadtimes are used to consider calendars.
--  110307  MaRalk Modified methods Calc_Due_Date_Backwards___, Calc_Dates_Backwards___, Calc_Due_Date_Forwards___
--  110307         Calc_Ship_Date_Forwards___ and Calc_Order_Dates___ to include the supply code 'CRO'.
--  110214  AndDse BP-4146, Modifications for info message handeling on calendar functionality.
--  110203  AndDse BP-3776, Modifications for external transport calendar.
--  110125  AndDse BP-3776, Introduced external transport calendar, which is needed in some calculations in this LU.
--  110111   UTSWLK Added code to consider ext transport calender when calculate earliest_delivery_date_ in Calc_Ship_Date_Backwards___.
--  110104  AndDse BP-3775, Made sure dist calendar is used when adding and removing internal delivery time in Calc_Supply_Due_Date_Back___ and Calc_Due_Date_Forwards___.
--  101223  UTSWLK Added parameter ship_via_code_ to Calc_Del_Date_Forwards___, Calc_Dates_Forwards___, Calc_Order_Atp_Date___ and Calc_Ship_Date_Backwards__ and modified the code accordingly.
--  100712  ChJalk Bug 91135, Added parameters demand_ref_ and demand_code_ to the methods Calc_Order_Dates_Backwards, Calc_Order_Atp_Date___ and Calc_Order_Dates___.
--  100520  KRPELK Merge Rose Method Documentation.
--  100712         Modified the places where those methods are called.
--  100210  SudJlk Bug 88821, Added set ctp_planned value when cc_reset_flag_ = 'N' in Perform_Capability_Check().
--  090930  MaMalk Modified Calc_Order_Atp_Date___, Perform_Capability_Check, Calc_Dates_Backwards___ to remove unused code.
--  ------------------------- 14.0.0 -----------------------------------------
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  090728  SudJlk Bug 84547, Modified method Calc_Disord_Dates_Backwards to pass the old_due_date to Calc_Order_Dates___.
--  090130  SudJlk Bug 76805, Modified method Calc_Order_Atp_Date___ to display error messages with a possible delivery date after online consumption check.
--  081203  DaZase Bug 77675, Modified method Calc_Due_Date_Forwards___ so the supply site route's stop days/time will be taken in account 
--  081203         when check on line level is checked for the route on supply site.
--  081021  SudJlk Bug 76501, Modified method Calc_Order_Atp_Date___ to allow online consumption check at demand site when supply codes are IPD and IPT.
--  081021         Restructured the logic to run online consumption check in Calc_Order_Atp_Date___.
--  080714  RoJalk Bug 75627, Modified Perform_Capability_Check to collect info messages correctly.
--  080619  MaMalk Bug 73186, Modified Calc_Ship_Date_Backwards___ to add parameter date_entered_ and restructured this method. Modified Calc_Dates_Backwards___
--  080619         to pass the date_entered_ parameter to Calc_Ship_Date_Backwards___.
--  080527  BJSASE Bug 74337, Added call to cost calculation in Perform_Capability_Check
--  080911  MaJalk Added zone_definition_id_ and zone_id_ to call Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults at Calc_Cust_Sched_Plan_Due_Date.
--  080516  SuJalk Bug 70772, Modified the Calc_Order_Atp_Date___ method to change the onhand analysis for configurable parts. The onhand analysis for configurable parts would only be performed
--  080516         if the part is configured.
--  080516  MaMalk Bug 71309, Modified Calc_Ship_Date_Backwards___ to compare the truncated dates when setting allow_past_date_.  
--  080422  MaMalk Bug 72606, Modified methods Calc_Due_Date_Backwards___ and Calc_Ship_Date_Forwards___ to include the picking leadtime when calculating
--  080422         dates for supply codes Project Delivery and Project Inventory.
--  080410  ChJalk Bug 70465, Added parameter objid_ to Calc_Disord_Dates_Backwards.
--  080129  ChJalk Bug 69654, Added parameter release_planning_ to the methods Calc_Order_Atp_Date___, Calc_Order_Dates___ and Calc_Order_Dates_Backwards.
--  080129         Modified Calc_Order_Atp_Date___ to bypass availability planning fot 'IPT' and 'IPD' when the internal CO has been created.
--  080117  ChJalk Bug 69540, Modified Calc_Ship_Date_Backwards___ to calculate planned ship date considering the value of check_on_line_level.
--  071127  SaJjlk Bug 69264, Modified method Calc_Order_Atp_Date___ to allow supply codes PD and PT.
--  071119  MaRalk Bug 67755, Replaced parameter wanted_delivery_date_ with target_date_ in Calc_Order_Dates_Backwards, Calc_Order_Dates_Forwards, 
--  071119         Calc_Order_Dates___, Calc_Dates_Backwards___, Calc_Order_Atp_Date___, Calc_Ship_Date_Backwards___, Calc_Del_Date_Forwards___, 
--  071119         Calc_Dates_Forwards___ and modified accordingly. 
--  070807  MiKulk Modified the method Calc_Order_Dates_Forewards to check whether the planned_due_date is a working day if the supply code is NOT in SO or DOP.
--  070719  MaJalk Bug 65855, Added new parameters old_part_ownership_db_ and part_ownership_db_ to methods Calc_Order_Atp_Date___, Calc_Order_Dates___,
--  070719         Calc_Order_Dates_Backwards. Added IF condition to check the part ownership of the CO line in Calc_Order_Atp_Date___.
--  070717  MiKulk Bug 66509, Modified the method Calc_Ship_Date_Backwards___ to consider the time value of the planned_ship_date_
--  070717         when deciding whether the planned ship date is earlier than today's date.
--  070621  MiKulk Bug 61765, Modified methods Calc_Disord_Dates_Backwards, Calc_Order_Dates___, Calc_Order_Atp_Date___, 
--  070621         Calc_Order_Dates_Backwards, Calc_Cust_Sched_Plan_Due_Date  and Calc_Quotation_Dates.
--  070621         Modified Control_Ms_Mrp_Consumption__ method calls as public method calls. 
--  061205  DaZase Added a qty conversion in method Perform_Capability_Check.
--  061102  DaZase Changes in Calc_Order_Atp_Date___ before and after call to Make_Onhand_Analysis so the quantities are 
--                 in the corrent inventory UoM (depending on demand/supply site).
--  060817  IsWilk removed the substr from customer_name_ in Perform_Capability_Check.
--  060515  NaLrlk Enlarge Address  - Changed variable definitions.
--  060424  IsAnlk Enlarge Supplier - Changed variable definitions.
--  060420  SaRalk Enlarge Customer - Changed variable definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  060315  JoEd   Fixed assign of planned_due_date in Calc_Due_Date_Forwards___ for PD and IPD.
--  060302  DaZase Added handling of info string from CC in method Perform_Capability_Check.
--  060125  JaJalk Added Assert safe annotation.
--  060124  RaKalk LCS-55356 Modified method Calc_Order_Atp_Date___, added an error message to handle parts with status 'supplies not allowed'.
--  050930  JoEd   Changed order of parameters in call to Calc_Order_Dates___ from
--                 Calc_Quotation_Dates.
--  050929  JoEd   Changed "from date" in the TARGETDATECHG and TARGETDATECHGSUBST messages to
--                 be correct if allow_past_date_ = FALSE - by adding old_delivery_date_ parameter to
--                 Calc_Dates_Backwards___ and Calc_Order_Atp_Date___.
--  050922  SaMelk Removed unused variables.
--  050831  DaZase Added the planned delivery date cant be earlier than wanted delivery date check in method Calc_Del_Date_Forwards___.
--  050824  DaZase Added objid_ & objversion to Perform_Capability_Check so we can do a lock_by_id.
--  050815  VeMolk Bug 50869, Modified the call to the method Inventory_Part_In_Stock_API.Make_Onhand_Analysis in Calc_Order_Atp_Date___.
--  050715  IsWilk (LCS patch 51740)Added the old_due_date_ parameter and modified Calc_Order_Dates_Backwards, Calc_Order_Dates___
--  050715         modified Calc_Order_Atp_Date___ according to the old_due_date_.
--  050629  MaEelk Added right method name in General_SYS.Init_Method for Calc_Cust_Sched_Plan_Due_Date
--  050610  DaZase Added more functionality to Perform_Capability_Check so we can handle supply code IO for CC.
--  050602  JoEd   Moved the EARLYROUTEDATE message to a better location.
--  050531  JoEd   Added fetch of default ship via transit code in Calc_Quotation_Dates.
--                 Use purchase part = inventory part in Perform_Capability_Check to use
--                 more correct leadtimes.
--                 Changed Calc_Order_Atp_Date___ to return correct supply site due date.
--  050525  JoEd   Added information message when route's involved in backwards calculation.
--                 Added parameters allow_past_date_ and objstate_ to Calc_Dates_Backwards___ and Calc_Ship_Date_Backwards___.
--  050518  DaZase Added extra checks on the allocate_db_ value in method Perform_Capability_Check.
--  050425  NuFilk Added public method Calc_Cust_Sched_Plan_Due_Date to be called from Customer Schedule.
--  050411  NiRulk Bug 49348. Modified Calc_Due_Date_Forwards___ and Calc_Dates_Backwards___ to handle vendor_no NULL for PT and PD supply.
--                 Parameter vendor_no had to be added to Calc_Due_Date_Forwards, Calc_Due_Date_Forwards___ and Calc_Dates_Forwards___.
--  050316  DaZase Added method Calc_Due_Date_Forwards as a public interface for the implementation method.
--                 Added some extra supply_site_due_date to planned_due_date calculations in method Perform_Capability_Check.
--  050307  JoEd   Changed earliest del date calculation in Calc_Order_Atp_Date___.
--  050228  JoEd   Changed parameter do_atp_check_ to ctp_planned_db_ in Calc_Disord_Dates_Backwards.
--  050211  JoEd   Bug 48416. Added leadtime to Get_Previous_Route_Date calls.
--  050210  JoEd   Bugs 48125 and 49346. Calculation with supplier route between sites
--                 for IPT has changed.
--                 Added supply_site_due_date param to Calc_Due_Date_Forwards___
--                 and Calc_Dates_Forwards___.
--                 Added earliest delivery date and allow flag params to
--                 Calc_Order_Atp_Date___. Added objstate param to Calc_Order_Dates___.
--  050203  JoEd   Added supply_site_due_date parameter to Calc_Quotation_Dates.
--  0501xx  JoEd   Rebuild the entire LU. Split the methods into smaller chunks
--                 to easily "count" back and forth.
--                 Calc_From_Delivery_Date___ renamed to Calc_Dates_Backwards___.
--                 Calc_Supply_Site_Due_Date___ renamed to Calc_Supply_Due_Date_Back___.
--                 All public Get_...Dates renamed to Calc_...Dates.
--                 Calc_Order_Line_Dates renamed to Calc_Order_Dates_Forwards.
--                 Calc_From_Due_Date___ removed and implementation replaced with
--                 calls to the appropriate sequence of "small" methods in Calc_Order_Atp_Date___
--                 and Calc_Order_Dates_Forwards.
--                 Added parameter Order_id to Calc_Dist_Order_Dates.
--                 Extended the check for supply code PS.
--  050131  DaZase Added method Perform_Capability_Check.
--  041123  NiRulk Bug 44599, Added procedures Calc_Order_Line_Dates, Calc_Forward_From_Due_Date___, Calc_Supply_Site_Due_Date___.
--  041123         Modified methods Calc_From_Delivery_Date___, Get_Order_Dates___, Get_Sourcing_Dates___
--  041028  DiVelk Modified Calc_From_Delivery_Date___,Calc_From_Due_Date___ and Get_Order_Dates___.
--  040820  ChBalk Bug 45543, Added extra condition to avoide Availability Control when full quantity is reserved in Get_Order_Dates___.
--  040722  LaBolk Added parameter inv_conv_factor_ to Get_Dist_Order_Dates and modified the method to include conversion factor in the date calculation..
--  040714  JaBalk Added parameter def_delivery_leadtime_ to Get_Dist_Order_Dates.
--  040629  LaBolk Added parameter do_atp_check_ to Get_Dist_Order_Dates and modified its code.
--  040609  ChBalk Bug 41364, Modified Get_Order_Dates___ method to restructure Master Scheduling ATP analysis and onhand analysis.
--  040521  NaWalk Modified Get_Dist_Order_Dates.
--  040518  KiSalk Added Procedure Get_Dist_Order_Dates.
--  040517  VeMolk Bug 44564, Modified the methods Calc_From_Delivery_Date___ and Calc_From_Due_Date___
--  040517         in order to raise an error message conditionally.
--  040406  WaJalk Modified method Get_Supplier_Info___ to get the delivery address as
--                 supplier's default address instead of using document address.
--  040202  PrTilk Bug 41277, Modified methods Calc_From_Delivery_Date___, Calc_From_Due_Date___. Removed the
--  040202         IF conditions that check if the supply_code_db_ IN 'IPT'or 'IPD'.
--  040114  GeKalk Bug 41275, Add a check for supply_code 'IPD' to update the planned_due_date in Calc_From_Due_Date___.
--  031030  JoEd   Changed to use route calendar in Calc_From_Delivery_Date___
--                 instead of nvl(supplier calendar, distribution calendar).
--  031024  JoEd   Add an extra day if delivery time differs in Calc_From_Delivery_Date___.
--  031023  JoEd   Modified supplier route logic for IPD and PD. Changed Get_Route___ parameter list.
--  031022  JoEd   Added message INVALROUTEDATE to display when route date is outside calendar.
--                 Added due date, route date and ship date error messages in Calc_From_Due_Date___.
--  031017  JoEd   Use supplier part no when fetching inventory part info in Get_Order_Dates___
--                 for IPD and IPT.
--  031016  JoEd   Added extra check on supply site due date in Get_Sourcing_Dates__.
--  031015  JoAnSe Changed initial assignment of planned_due_date_ in Calc_From_Due_Date___
--  031010  JoEd   Supply code PD can have ship date and/or due date on a non-working day.
--                 Excluded PD from the "if no route => get prior work day" scenario.
--  031009  JoEd   Added handling of supply code MRO in date calculation. Should work
--                 the same way as IO without availability check.
--  031008  JoEd   Rollback on leadtime message. Fixed addition of extra working day
--                 when calculating "due date" for supply code SO.
--                 Corrected calculation of earliest delivery date in Get_Order_Dates___.
--                 Info message on earliest delivery date added for all supply codes.
--  031007  JoEd   Added extra work day to calculated due date if supply code SO.
--  031007  JoEd   Changed the leadtime trace messages to include the leadtime values.
--                 Added extra nvl(xxx, 0) for some leadtime variables.
--  031006  JoEd   Rewrote Get_Order_Dates___ to get the right info messages.
--  031002  JoEd   Added extra leadtime parameters to Get_Sourcing_Dates___ and Get_Sourcing_Dates.
--  031001  JoEd   Removed supply code SO from check on moving target date.
--  030929  JoEd   Added parameter vendor_no to Get_Quotation_Dates.
--  030922  JoEd   Changed methods Get_Sourcing_Dates and Get_Sourcing_Dates___.
--                 Changed fetch of leadtimes. Removed method Get_Leadtimes___ -
--                 functionality now located in CustOrderLeadtimeUtil.
--  030915  JoEd   Added supplier part no as parameter to the date calculation methods.
--  030902  GaSolk Performed CR Merge 2.
--  030829  BhRalk Modified the Method Calc_From_Delivery_Date___.
--  030829  NuFilk Removed Check in Get_Sourcing_Dates___ for inventory on hand analysis flag.
--  030826  NuFilk Modified method Get_Sourcing_Dates___ included a check for availability ticked.
--  030825  JoEd   Changed so that ATP analysis is executed for IPT and IPD (as well as IO) -
--                 where the supply site's part is setup for availability check/forecast consumption.
--  030822  NuFilk Changed message in Get_Order_Dates___.
--  030820  BhRalk Modified the method Calc_From_Delivery_Date___.
--  030820  NuFilk Added method Get_Leadtimes.
--  030819  CaRase Change function call from Cust_Ord_Reservation_Type_API.Decode to Cust_Ord_Reservation_Type_API.Encode in procedure
--                 Get_Order_Dates___
--  030815  JoEd   Replaced Get_Prev_Next_Route_Date with Get_Previous_Route_Date and
--                 Get_Next_Route_Date resp..
--  030814  JoEd   Added use of supplier picking leadtime when supply site's part
--                 is an inventory part - for transit deliveries - in Calc_From_... methods.
--                 Changed Priority/Instant reservation check in Calc_From_... methods to
--                 execute ATP analysis.
--  030725  WaJalk Modified Calc_From_Delivery_Date___ to exclude time stamp when fetching
--                 Planned Delivery Date, Promised Delivery Date and Planned Ship Date in CO line.
--  0306xx  JoEd   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Calc_Ship_Date_Backwards___
--   Calculate "backwards" from delivery date to ship date.
--   Planned delivery date is also moved "forwards" if we can't deliver on the
--   desired date.
PROCEDURE Calc_Ship_Date_Backwards___ (
   planned_delivery_date_     IN OUT DATE,
   planned_ship_date_         IN OUT DATE,
   allow_past_date_           IN OUT BOOLEAN,
   target_date_               IN     DATE,
   date_entered_              IN     DATE,
   order_delivery_leadtime_   IN     NUMBER,
   ext_transport_calendar_id_ IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   route_id_                  IN     VARCHAR2,
   supply_code_db_            IN     VARCHAR2,
   vendor_contract_           IN     VARCHAR2,
   objstate_                  IN     VARCHAR2,
   ship_via_code_             IN     VARCHAR2,
   use_current_date_          IN     VARCHAR2)
IS
   dist_calendar_          VARCHAR2(10);
   supp_calendar_          VARCHAR2(10);
   route_site_             VARCHAR2(5) := NULL;
   route_calendar_         VARCHAR2(10) := NULL;
   earliest_delivery_date_ DATE;
   min_date_               DATE;
   current_date_           DATE;
   check_on_line_level_    VARCHAR2(5); 
   temp_planned_delivery_date_ DATE;
   invalid_calendar_info_  VARCHAR2(4000);
BEGIN

   IF (supply_code_db_ = 'ND') THEN
      -- Not Decided should have the same due date and ship date as delivery date
      planned_ship_date_ := planned_delivery_date_;

   ELSE
      dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);
      supp_calendar_ := Site_API.Get_Dist_Calendar_Id(vendor_contract_);

      Trace_SYS.Field('Remove transport time to customer', order_delivery_leadtime_);

      -- remove the transport time to customer. If transport calendar is defined for the ship via code
      -- that will be used to calculate the planned_ship_date_.
      -- (for Direct deliveries => remove supplier's transport time to customer...)  
      -- Start with setting the planned delivery date to next working day according to external transport calendar.
      Fetch_Calendar_End_Date(temp_planned_delivery_date_, ext_transport_calendar_id_, planned_delivery_date_, 0);
      planned_delivery_date_ := temp_planned_delivery_date_;
      Fetch_Calendar_Start_Date(planned_ship_date_, ext_transport_calendar_id_, planned_delivery_date_, order_delivery_leadtime_);
      
      IF (planned_ship_date_ IS NOT NULL) AND (target_date_ IS NOT NULL) THEN
         -- Set the delivery time correctly when have a transport calendar defined.
         IF (ext_transport_calendar_id_ IS NOT NULL AND (to_char(target_date_, 'HH24:MI') != '00:00')) THEN
            planned_ship_date_ := to_date(to_char(planned_ship_date_, 'YYYY-MM-DD') || ' ' || to_char(target_date_, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');
         END IF;
      END IF;
         
      IF (supply_code_db_ = 'IPD') THEN
         -- supplier's site is used to fetch a prior route date.
         route_site_ := vendor_contract_;
         route_calendar_ := supp_calendar_;
      ELSE
         -- "our" site is used to fetch a prior route date
         route_site_ := contract_;
         route_calendar_ := dist_calendar_;
      END IF;

      -- purchase direct (PD) doesn't have calendar or route
      IF (supply_code_db_ NOT IN ('PD')) THEN

         Trace_SYS.Field('planned ship date 1', planned_ship_date_);
         Trace_SYS.Field('route', route_id_);
         Trace_SYS.Field('route calendar', route_calendar_);

         -- planned ship date using route and calendar
         IF (route_id_ IS NOT NULL) THEN
            check_on_line_level_ := Delivery_Route_API.Get_Check_On_Line_Level_Db(route_id_);
            current_date_ := Site_API.Get_Site_Date(route_site_);
            IF (check_on_line_level_ = 'TRUE') THEN
            Set_Invalid_Calendar_Info___(planned_ship_date_, route_calendar_, nvl(order_delivery_leadtime_, 0));
               planned_ship_date_ := Delivery_Route_API.Get_Previous_Route_Date(route_id_, planned_ship_date_, route_calendar_, NVL(order_delivery_leadtime_, 0), route_site_);
               IF (use_current_date_ = 'FALSE') THEN
                  planned_ship_date_ := Delivery_Route_API.Get_Route_Ship_Date(route_id_, planned_ship_date_, date_entered_, route_site_);
               ELSE
                  planned_ship_date_ := Delivery_Route_API.Get_Route_Ship_Date(route_id_, planned_ship_date_, current_date_, route_site_);
               END IF;
            ELSE
            Set_Invalid_Calendar_Info___(planned_ship_date_, route_calendar_, nvl(order_delivery_leadtime_, 0));
               Trace_SYS.Message('Check for (prior) route date');
               planned_ship_date_ := Delivery_Route_API.Get_Previous_Route_Date(route_id_, planned_ship_date_, route_calendar_, nvl(order_delivery_leadtime_, 0), route_site_);
            END IF;
            
            IF (TRUNC(NVL(planned_ship_date_, current_date_)) < TRUNC(current_date_)) THEN
               Trace_SYS.Message('planned ship date earlier than today''s date - move to next route date');
               -- route date is before current date... fetch next route date instead!
               planned_ship_date_ := Delivery_Route_API.Get_Next_Route_Date(route_id_, current_date_, route_calendar_, route_site_);
            
               IF (NVL(objstate_, ' ') IN ('Planned', 'Blocked')) THEN
                  allow_past_date_ := FALSE; -- this is to present the message EARLYROUTEDATE.
               END IF;
            END IF;
            

            Trace_SYS.Field('route departure date', planned_ship_date_);
            IF (planned_ship_date_ IS NULL) THEN
               IF (supply_code_db_ = 'IPD') THEN
                  Error_SYS.Record_General(lu_name_, 'INVALROUTEDATESUPP: Route departure date is not within the supplier calendar.');
               ELSE
                  Error_SYS.Record_General(lu_name_, 'INVALROUTEDATE: Route departure date is not within current calendar.');
               END IF;
            END IF;

         -- if not using route, check that ship date is a working day
         ELSE
            Set_Invalid_Calendar_Info___(planned_ship_date_, route_calendar_, 0);
            Trace_SYS.Message('No route: get prior workday');
            -- use "route calendar" to use the correct calendar for the supply code
            planned_ship_date_ := Work_Time_Calendar_API.Get_Prior_Work_Day(route_calendar_, planned_ship_date_);
         END IF;

         Trace_SYS.Field('planned ship date 2', planned_ship_date_);

         Trace_SYS.Message('Test: add transport time to customer. Which date is greatest?');
         Trace_SYS.Field('planned delivery date', planned_delivery_date_);
         -- We may not be able to deliver on the desired date - move planned delivery date
         
         Fetch_Calendar_End_Date(earliest_delivery_date_, ext_transport_calendar_id_, planned_ship_date_, order_delivery_leadtime_);
         
         planned_delivery_date_ := greatest(planned_delivery_date_, earliest_delivery_date_);
         Trace_SYS.Field('earliest delivery date', earliest_delivery_date_);
      END IF;
      
      IF (planned_delivery_date_ IS NOT NULL) AND (target_date_ IS NOT NULL) THEN
         Trace_SYS.Field('Set delivery time', to_char(target_date_, 'HH24:MI'));
         -- Reset to the same time as the time for the start date
         planned_delivery_date_ := to_date(to_char(planned_delivery_date_, 'YYYY-MM-DD') || ' ' || to_char(target_date_, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');
      END IF;

      IF (route_id_ IS NOT NULL) AND (planned_delivery_date_ IS NOT NULL) AND (planned_ship_date_ IS NOT NULL) THEN
         -- if delivery date and ship date are the same dates...
         IF (trunc(planned_delivery_date_) = trunc(planned_ship_date_)) THEN
            -- ... and a time is specified (midnight = no time = anytime) ...
            IF NOT ((to_char(planned_delivery_date_, 'HH24:MI') = '00:00') OR (to_char(planned_ship_date_, 'HH24:MI') = '00:00')) THEN
               -- ... if ship time is greater than delivery time move delivery date ahead one day
               IF (planned_ship_date_ > planned_delivery_date_) THEN
                  Trace_SYS.Message('Time differs - add 1 day');
                  planned_delivery_date_ := planned_delivery_date_ + 1;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;

   -- "planned ship date" is now a workday

   min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(dist_calendar_);

   Trace_SYS.Field('min date for calendar ' || dist_calendar_, min_date_);
   Trace_SYS.Field('planned ship date', planned_ship_date_);

   IF ((planned_ship_date_ IS NULL) OR (planned_ship_date_ < min_date_)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALSHIPDATE: Planned ship date is not within current calendar.');
   END IF;
END Calc_Ship_Date_Backwards___;


-- Calc_Due_Date_Backwards___
--   Calculate "backwards" from ship date to planned due date.
PROCEDURE Calc_Due_Date_Backwards___ (
   planned_due_date_  IN OUT DATE,
   planned_ship_date_ IN     DATE,
   picking_leadtime_  IN     NUMBER,
   supply_code_db_    IN     VARCHAR2,
   contract_          IN     VARCHAR2,
   part_no_           IN     VARCHAR2,
   col_objstate_      IN     VARCHAR2,
   route_id_          IN     VARCHAR2)
IS
   inventory_part_ BOOLEAN;
   dist_calendar_  VARCHAR2(10);   
BEGIN
   planned_due_date_ := planned_ship_date_;

   inventory_part_ := Inventory_Part_API.Check_Exist(contract_, part_no_);

   -- For transit delivery, check if "our" part is an inventory part...
   IF (((supply_code_db_ IN ('IPT', 'PT')) AND inventory_part_) OR
        (supply_code_db_ IN ('SO', 'DOP', 'IO', 'PKG', 'MRO', 'PS', 'PI', 'PJD', 'CRO'))) THEN      
      IF (col_objstate_ IS NULL) OR (col_objstate_ NOT IN ('Picked', 'Delivered', 'Invoiced', 'Cancelled')) THEN
         dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);
         Trace_SYS.Field('Remove "our" picking time', picking_leadtime_);
         -- remove "our" picking leadtime (in workdays) for non-direct deliveries
         planned_due_date_ := Work_Time_Calendar_API.Get_Start_Date(dist_calendar_, planned_due_date_, picking_leadtime_);
         -- Apply the Due Time for Delivery fetched from route on Planned Due Date
         planned_due_date_ := Delivery_Route_API.Get_Due_Date_With_Time(route_id_, planned_ship_date_, planned_due_date_, contract_);

      END IF;
   END IF;
END Calc_Due_Date_Backwards___;


-- Calc_Supply_Due_Date_Back___
--   Calculates "backwards" from planned due date (at demand site) to
--   supply site due date.
PROCEDURE Calc_Supply_Due_Date_Back___ (
   supply_site_due_date_       IN OUT DATE,
   planned_due_date_           IN     DATE,
   contract_                   IN     VARCHAR2,
   supply_code_db_             IN     VARCHAR2,
   vendor_contract_            IN     VARCHAR2,
   supplier_part_no_           IN     VARCHAR2,
   internal_control_time_      IN     NUMBER,
   vendor_delivery_leadtime_   IN     NUMBER,
   internal_delivery_leadtime_ IN     NUMBER,
   vendor_manuf_leadtime_      IN     NUMBER,
   vendor_leadtime_            IN     NUMBER,
   supplier_ship_via_transit_  IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   supplier_calendar_id_       IN     VARCHAR2,
   transport_leadtime_         IN     NUMBER,
   arrival_route_id_           IN     VARCHAR2 )
IS
   dist_calendar_             VARCHAR2(10);
   supp_calendar_             VARCHAR2(10) := NULL;
   supp_route_id_             VARCHAR2(12) := NULL;
   inventory_part_            BOOLEAN := FALSE;
   temp_supply_site_due_date_ DATE := NULL;
   date_entered_              DATE;
   total_vendor_trans_leadtime_ NUMBER;
   
BEGIN
   -- fetch calendars to use below
   dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);

   IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
      supp_calendar_ := Site_API.Get_Dist_Calendar_Id(vendor_contract_);
   END IF;

   supply_site_due_date_ := planned_due_date_;

   IF (supply_code_db_ IN ('IPD', 'PD', 'IPT', 'PT')) THEN

      inventory_part_ := Inventory_Part_API.Check_Exist(vendor_contract_, supplier_part_no_);


      IF (supply_code_db_ IN ('IPT', 'PT')) THEN

         Trace_SYS.Field('Remove "our" control time', internal_control_time_);
         -- remove "our" internal control time (in workdays)
         Fetch_Calendar_Start_Date(temp_supply_site_due_date_, dist_calendar_, supply_site_due_date_, internal_control_time_);
         supply_site_due_date_:= temp_supply_site_due_date_;

         Trace_SYS.Field('Remove internal transport time', internal_delivery_leadtime_);
         -- remove "our" internal transportation time.         
         Fetch_Calendar_Start_Date(temp_supply_site_due_date_, dist_calendar_, supply_site_due_date_, internal_delivery_leadtime_);
         supply_site_due_date_:= temp_supply_site_due_date_;
         
         -- remove supplier's arrival route
         IF (arrival_route_id_ IS NOT NULL) THEN
            date_entered_ := SYSDATE;
            temp_supply_site_due_date_ := Delivery_Route_API.Get_Previous_Route_Date(arrival_route_id_, supply_site_due_date_, contract_, date_entered_);
            supply_site_due_date_:= temp_supply_site_due_date_;
         END IF;
         
         total_vendor_trans_leadtime_ := vendor_delivery_leadtime_ + transport_leadtime_; 
         Trace_SYS.Field('Remove supplier transport time to "us"', total_vendor_trans_leadtime_ );
         -- remove supplier's transport time to "us"         
         Fetch_Calendar_Start_Date(
            temp_supply_site_due_date_, Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(supplier_ship_via_transit_), 
               supply_site_due_date_, total_vendor_trans_leadtime_);
         supply_site_due_date_:= temp_supply_site_due_date_;
         -- result must be workday according to our dist calendar.
         supply_site_due_date_ := Work_Time_Calendar_API.Get_Prior_Work_Day(dist_calendar_, supply_site_due_date_);
      END IF;

      -- If PT, PD or non-inventory/non-existing part remove supplier's manufacturing leadtime.
      IF ((supply_code_db_ IN ('PT', 'PD')) OR NOT inventory_part_) THEN
         Trace_SYS.Field('Remove supplier manuf leadtime', vendor_manuf_leadtime_);        
         IF (supply_code_db_ IN ('PT', 'PD')) THEN
            Fetch_Calendar_Start_Date(temp_supply_site_due_date_, supplier_calendar_id_, supply_site_due_date_, vendor_manuf_leadtime_);
         ELSE -- IPT, IPD
            Fetch_Calendar_Start_Date(temp_supply_site_due_date_, supp_calendar_, supply_site_due_date_, vendor_manuf_leadtime_);
         END IF;
         supply_site_due_date_:= temp_supply_site_due_date_;
      END IF;

      IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
         -- routes (for IPD) have already been handled. Only remove picking time...
         IF (supply_code_db_ = 'IPT') THEN
            -- fetch the route ID at supplier that is used when goods are shipped to "us".
            supp_route_id_ := Get_Route___(contract_, supplier_part_no_, supply_code_db_, vendor_no_, supplier_ship_via_transit_);
         END IF;

         -- due date using supplier's route and calendar - only for IPT
         IF (supp_route_id_ IS NOT NULL) THEN
            Trace_SYS.Message('Check for (prior) route date');
            supply_site_due_date_ := Delivery_Route_API.Get_Previous_Route_Date(supp_route_id_, supply_site_due_date_, supp_calendar_, nvl(vendor_delivery_leadtime_, 0), vendor_contract_);

            Trace_SYS.Field('route departure date', supply_site_due_date_);
            IF (supply_site_due_date_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'INVALROUTEDATESUPP: Route departure date is not within the supplier calendar.');
            END IF;

         ELSIF (supp_calendar_ IS NOT NULL) THEN
            Trace_SYS.Message('no route: get prior workday');
            supply_site_due_date_ := Work_Time_Calendar_API.Get_Prior_Work_Day(supp_calendar_, supply_site_due_date_);
         END IF;

         -- if IPT, IPD and inventory part exist (at supply site) - remove supplier's picking leadtime (in workdays)
         IF inventory_part_ THEN
            Trace_SYS.Field('Remove supplier picking time', vendor_leadtime_);
            supply_site_due_date_ := Work_Time_Calendar_API.Get_Start_Date(supp_calendar_, supply_site_due_date_, NVL(vendor_leadtime_, 0));
            -- this is the only time the supply_site_due_date will be saved...
         END IF;
      END IF;
   END IF;
END Calc_Supply_Due_Date_Back___;


-- Calc_Dates_Backwards___
--   Calculates backwards from "delivery date" and returns the delivery date,
--   shipping date and due date using total shipping time (in calendar days)
--   from supplier to customer.
PROCEDURE Calc_Dates_Backwards___ (
   planned_delivery_date_      IN OUT DATE,
   planned_ship_date_          IN OUT DATE,
   planned_due_date_           IN OUT DATE,
   supply_site_due_date_       IN OUT DATE,
   manuf_start_date_           IN OUT DATE,
   allow_past_date_            IN OUT BOOLEAN,
   old_delivery_date_          IN OUT DATE,
   target_date_                IN     DATE,
   date_entered_               IN     DATE,   
   vendor_no_                  IN     VARCHAR2,   
   vendor_contract_            IN     VARCHAR2,      
   supplier_calendar_id_       IN     VARCHAR2,
   order_delivery_leadtime_    IN     NUMBER,
   ext_transport_calendar_id_  IN     VARCHAR2,
   picking_leadtime_           IN     NUMBER,
   internal_control_time_      IN     NUMBER,
   vendor_delivery_leadtime_   IN     NUMBER,
   internal_delivery_leadtime_ IN     NUMBER,
   vendor_manuf_leadtime_      IN     NUMBER,
   vendor_leadtime_            IN     NUMBER,
   expected_leadtime_          IN     NUMBER,   
   route_id_                   IN     VARCHAR2,
   supply_code_db_             IN     VARCHAR2,
   contract_                   IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   supplier_part_no_           IN     VARCHAR2,
   source_                     IN     VARCHAR2,
   objstate_                   IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   supplier_ship_via_transit_  IN     VARCHAR2,
   use_current_date_           IN     VARCHAR2,
   col_objstate_               IN     VARCHAR2,
   transport_leadtime_         IN     NUMBER,
   arrival_route_id_           IN     VARCHAR2 )
IS
   dist_calendar_               VARCHAR2(10);
   manuf_calendar_              VARCHAR2(10) := NULL;
   supp_calendar_               VARCHAR2(10) := NULL;
   min_date_                    DATE;
   msg_date_                    DATE;
BEGIN

   Trace_SYS.Field('target date', target_date_);
   
   Trace_SYS.Field('supply code', supply_code_db_);
   Trace_SYS.Field('supply site', vendor_contract_);
   Trace_SYS.Field('demand site', contract_);

   Trace_SYS.Message('Init delivery date');
   -- Never deliver earlier than the wanted delivery date.
   IF (planned_delivery_date_ IS NOT NULL) THEN
      planned_delivery_date_ := greatest(planned_delivery_date_, target_date_);
   ELSE
      planned_delivery_date_ := target_date_;
   END IF;

   -- don't deliver before date entered (instead of "today")
   IF (source_ IN ('ORDER', 'DISTORDER')) THEN
      Trace_SYS.Message('ORDER: check delivery date against date entered');
      IF (planned_delivery_date_ < nvl(date_entered_, planned_delivery_date_)) THEN
         planned_delivery_date_ := trunc(date_entered_);
      END IF;
   END IF;

   Trace_SYS.Field('"start date"', planned_delivery_date_);

   -- "old date" used in the TARGETDATECHG... messages when allow_past_date_ = FALSE.
   old_delivery_date_ := planned_delivery_date_;

   -- fetch calendars to use below
   dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);

   IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
      supp_calendar_ := Site_API.Get_Dist_Calendar_Id(vendor_contract_);
   ELSIF (supply_code_db_ IN ('SO', 'DOP', 'PS', 'CRO')) THEN
      manuf_calendar_ := Site_API.Get_Manuf_Calendar_Id(contract_);
   END IF;

   -- "delivery date" is now set - calculate back to "ship date"!
   Calc_Ship_Date_Backwards___(planned_delivery_date_, planned_ship_date_, allow_past_date_,
      target_date_, date_entered_, order_delivery_leadtime_, ext_transport_calendar_id_, contract_, route_id_,
      supply_code_db_, vendor_contract_, objstate_, ship_via_code_, use_current_date_);

   -- continue back to "planned due date"
   Calc_Due_Date_Backwards___(planned_due_date_, planned_ship_date_,
      picking_leadtime_, supply_code_db_, contract_, part_no_, col_objstate_, route_id_);

   -- finished with IO, PKG and MRO...
   -- from this point planned due date is the same for all supply codes...

   -- continue back to "supply site due date"
   IF (supply_code_db_ IN ('SO', 'DOP', 'PS', 'CRO')) THEN

      -- remove an extra work day for Shop Orders and DOP Orders
      -- must be a working day
      manuf_start_date_ := Work_Time_Calendar_API.Get_Previous_Work_Day(dist_calendar_, planned_due_date_);

      Trace_SYS.Field('Remove expected leadtime', expected_leadtime_);
      -- remove expected/manufacturing leadtime (in workdays)
      manuf_start_date_ := Work_Time_Calendar_API.Get_Start_Date(manuf_calendar_, manuf_start_date_, NVL(expected_leadtime_, 0));

      msg_date_ := manuf_start_date_;
   ELSE
      IF ((supply_code_db_ IN ('PT', 'PD')) AND (vendor_no_ IS NULL)) THEN
         Trace_SYS.Field('No vendor: remove expected leadtime', expected_leadtime_);
         -- remove expected leadtime
         supply_site_due_date_ := planned_due_date_ - NVL(expected_leadtime_, 0);
      ELSE
         Calc_Supply_Due_Date_Back___(supply_site_due_date_, planned_due_date_, contract_, supply_code_db_, vendor_contract_,
            supplier_part_no_, internal_control_time_, vendor_delivery_leadtime_, internal_delivery_leadtime_,
            vendor_manuf_leadtime_, vendor_leadtime_, supplier_ship_via_transit_, vendor_no_, supplier_calendar_id_,
            transport_leadtime_, arrival_route_id_);
      END IF;
      msg_date_ := supply_site_due_date_;
   END IF;

   Trace_SYS.Field('"due date"', msg_date_);

   -- msg_date_ is used ONLY to check if the "due date" set above is within the calendar date limits.
   IF (supply_code_db_ IN ('IPD', 'IPT')) THEN
      -- Note: For the internal supplier within the currect database
      IF (supp_calendar_ IS NOT NULL) THEN
         min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(supp_calendar_);
         Trace_SYS.Field('min date for calendar ' || supp_calendar_, min_date_);
         IF ((msg_date_ IS NULL) OR (msg_date_ < min_date_)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALDUEDATESUPP: The due date is not within the supplier calendar.');
         END IF;
      END IF;
   ELSIF (supply_code_db_ NOT IN ('IPT', 'IPD', 'PT', 'PD')) THEN
      min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(dist_calendar_);
      Trace_SYS.Field('min date for calendar ' || dist_calendar_, min_date_);
      IF ((msg_date_ IS NULL) OR (msg_date_ < min_date_)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALDUEDATE: The due date is not within current calendar.');
      END IF;
   END IF;

   Trace_SYS.Message('Finished calculating!');

END Calc_Dates_Backwards___;


-- Calc_Due_Date_Forwards___
--   Initializes the planned due date for "forward" date calculation.
--   Passed is a start date (e.g. sysdate or supply site due date),
--   and returned is an adjusted due date.
PROCEDURE Calc_Due_Date_Forwards___ (
   planned_due_date_           IN OUT DATE,
   supply_site_due_date_       IN OUT DATE,
   contract_                   IN     VARCHAR2,
   internal_control_time_      IN     NUMBER,
   vendor_delivery_leadtime_   IN     NUMBER,
   internal_delivery_leadtime_ IN     NUMBER,
   vendor_manuf_leadtime_      IN     NUMBER,
   vendor_leadtime_            IN     NUMBER,
   expected_leadtime_          IN     NUMBER,
   supply_code_db_             IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   vendor_contract_            IN     VARCHAR2,
   supplier_part_no_           IN     VARCHAR2,
   supplier_ship_via_transit_  IN     VARCHAR2,
   transport_leadtime_         IN     NUMBER,
   arrival_route_id_           IN     VARCHAR2 )
IS
   dist_calendar_             VARCHAR2(10);
   manuf_calendar_            VARCHAR2(10) := NULL;
   supp_calendar_             VARCHAR2(10) := NULL;
   min_date_                  DATE;
   inventory_part_            BOOLEAN := FALSE;
   temp_date_                 DATE;
   supp_route_id_             VARCHAR2(12) := NULL;
   check_on_line_level_       VARCHAR2(5);

   vendor_addr_no_w_          SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE;
   vendor_contract_w_         VARCHAR2(5) := NULL;
   vendor_category_w_         VARCHAR2(20) := NULL;
   supplier_calendar_id_      VARCHAR2(10);
   date_entered_              DATE := SYSDATE;
   total_transport_leadtime_  NUMBER;
   
BEGIN
   dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);

   planned_due_date_ := supply_site_due_date_;

   IF (supply_code_db_ IN ('SO', 'DOP', 'PS', 'CRO')) THEN

      -- Add an extra work day for Shop Orders and DOP Orders. Must be a working day!
      planned_due_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(dist_calendar_, planned_due_date_);
      
      manuf_calendar_ := Site_API.Get_Manuf_Calendar_Id(contract_);

      Trace_SYS.Field('Add expected leadtime', expected_leadtime_);

      -- add expected/manufacturing leadtime (in workdays)
      planned_due_date_ := Work_Time_Calendar_API.Get_End_Date(manuf_calendar_, planned_due_date_, expected_leadtime_);

   ELSIF ((supply_code_db_ IN ('PT', 'PD')) AND (vendor_no_ IS NULL)) THEN
      Trace_Sys.Field('No vendor: add expected leadtime', expected_leadtime_);
      -- Add expected leadtime
      planned_due_date_ := planned_due_date_ + NVL(expected_leadtime_, 0);

      -- For supply code PT planned due date must be a working day
      IF (supply_code_db_ = 'PT') THEN
         planned_due_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(dist_calendar_, planned_due_date_);
      END IF;
   END IF;

   Trace_SYS.Field('planned due date', planned_due_date_);

   IF (supply_code_db_ IN ('IPD', 'IPT')) THEN
      supp_calendar_ := Site_API.Get_Dist_Calendar_Id(vendor_contract_);
      -- Note: For internal suppliers within the same/current database
      IF (supp_calendar_ IS NOT NULL) THEN
        min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(supp_calendar_);
        Trace_SYS.Field('min date for calendar ' || supp_calendar_, min_date_);
        IF ((planned_due_date_ IS NULL) OR (planned_due_date_ < min_date_)) THEN
           Error_SYS.Record_General(lu_name_, 'INVALDUEDATESUPP: The due date is not within the supplier calendar.');
        END IF;
      END IF;
   ELSIF (supply_code_db_ NOT IN ('PT', 'PD')) THEN
      min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(dist_calendar_);
      Trace_SYS.Field('min date for calendar ' || dist_calendar_, min_date_);
      IF ((planned_due_date_ IS NULL) OR (planned_due_date_ < min_date_)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALDUEDATE: The due date is not within current calendar.');
      END IF;
   END IF;

   IF ((supply_code_db_ IN ('IPD', 'PD', 'IPT', 'PT')) AND (vendor_no_ IS NOT NULL)) THEN
      IF (vendor_contract_ IS NOT NULL) THEN
         inventory_part_ := Inventory_Part_API.Check_Exist(vendor_contract_, supplier_part_no_);
      ELSE
         inventory_part_ := FALSE;
      END IF;

      Trace_SYS.Field('supply site inventory part exist', inventory_part_);

      temp_date_ := planned_due_date_;

      -- If PT, PD or non-inventory/non-existing part add supplier's manufacturing leadtime.
      IF ((supply_code_db_ IN ('PT', 'PD')) OR NOT inventory_part_) THEN
         Trace_SYS.Field('Add supplier manuf leadtime', vendor_manuf_leadtime_);
         IF (supply_code_db_ IN ('PT', 'PD')) THEN
            Get_Supplier_Info___(vendor_addr_no_w_, vendor_contract_w_, vendor_category_w_, supplier_calendar_id_, vendor_no_, supply_code_db_);
            Fetch_Calendar_End_Date(temp_date_, supplier_calendar_id_, planned_due_date_, vendor_manuf_leadtime_);
         ELSE -- IPT, IPD
            Fetch_Calendar_End_Date(temp_date_, supp_calendar_, planned_due_date_, vendor_manuf_leadtime_);
         END IF;
         planned_due_date_ := temp_date_;
      END IF;

      -- temp_date_ points to planned_ship_date for direct delivery (non-existing part)
      IF (supply_code_db_ = 'PD') THEN
         planned_due_date_ := temp_date_;

      ELSIF ((supply_code_db_ = 'IPD') AND NOT inventory_part_) THEN
         -- for IPD due date must be a working day
         planned_due_date_ := Work_Time_Calendar_API.Get_Closest_Work_Day(dist_calendar_, temp_date_);

      ELSE
         planned_due_date_ := temp_date_;

         IF (supply_code_db_ IN ('IPT', 'IPD')) AND inventory_part_ THEN

            Trace_SYS.Field('Add supplier picking time', vendor_leadtime_);
            -- if IPT, IPD and inventory part exist (at supply site) - add supplier's picking leadtime (in workdays)
            planned_due_date_ := Work_Time_Calendar_API.Get_End_Date(supp_calendar_, planned_due_date_, nvl(vendor_leadtime_, 0));

            IF (supply_code_db_ = 'IPT') THEN
               Trace_SYS.Message('Fetch supplier route to "us"');
               -- fetch the route ID at supplier that is used when goods are shipped to "us".
               supp_route_id_ := Get_Route___(contract_, supplier_part_no_, supply_code_db_, vendor_no_, supplier_ship_via_transit_); 
            END IF;

            -- check against supplier's route to "us" and calendar - only IPT
            IF (supp_route_id_ IS NOT NULL) THEN
               Trace_SYS.Message('Check for (next) route date');
               check_on_line_level_ := Delivery_Route_API.Get_Check_On_Line_Level_Db(supp_route_id_);
               IF (check_on_line_level_ = 'TRUE') THEN
                  -- make sure that we take supply site route stop days/time in account here
                  planned_due_date_ := Delivery_Route_API.Get_Route_Ship_Date(supp_route_id_, planned_due_date_, Site_API.Get_Site_Date(vendor_contract_), vendor_contract_);
               ELSE
                  planned_due_date_ := Delivery_Route_API.Get_Next_Route_Date(supp_route_id_, planned_due_date_, supp_calendar_, vendor_contract_);
               END IF;

               Trace_SYS.Field('route departure date', planned_due_date_);
               IF (planned_due_date_ IS NULL) THEN
                  Error_SYS.Record_General(lu_name_, 'INVALROUTEDATESUPP: Route departure date is not within the supplier calendar.');
               END IF;

               Trace_SYS.Field('"Due date" = Remove supplier picking time from route departure date...', vendor_leadtime_);
               -- remove supplier picking time from route departure date -> moves the supply site due date!
               supply_site_due_date_ := Work_Time_Calendar_API.Get_Start_Date(supp_calendar_, planned_due_date_, nvl(vendor_leadtime_, 0));

            ELSIF (supp_calendar_ IS NOT NULL) THEN
               Trace_SYS.Message('No route: get nearest workday');
               planned_due_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(supp_calendar_, planned_due_date_);

            END IF; 
         END IF;
         
      END IF;
      IF (supply_code_db_ IN ('IPT', 'PT')) THEN
         total_transport_leadtime_ := vendor_delivery_leadtime_ + transport_leadtime_;
         Trace_SYS.Field('Add supplier transport time + transport_leadtime', total_transport_leadtime_);
         -- add supplier's transport time to "us" (normal calendar)
         Fetch_Calendar_End_Date(temp_date_, Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(supplier_ship_via_transit_), 
                  planned_due_date_, total_transport_leadtime_);
         planned_due_date_ := temp_date_;
         IF (arrival_route_id_ IS NOT NULL) THEN
            planned_due_date_ := Delivery_Route_API.Get_Possible_Route_Date(arrival_route_id_, planned_due_date_, contract_, date_entered_);
         END IF;   
         Trace_SYS.Field('Add "our" internal transport time', internal_delivery_leadtime_);
         -- add "our" internal transportation time. 
         planned_due_date_ := Work_Time_Calendar_API.Get_End_Date(dist_calendar_, planned_due_date_, NVL(internal_delivery_leadtime_, 0));

         Trace_SYS.Field('Add "our" control time', internal_control_time_);
         -- add "our" internal control time (in workdays)
         planned_due_date_ := Work_Time_Calendar_API.Get_End_Date(dist_calendar_, planned_due_date_, nvl(internal_control_time_, 0));
      END IF;

   END IF;
END Calc_Due_Date_Forwards___;


-- Calc_Ship_Date_Forwards___
--   Calculates "forwards" from planned due date to planned ship date.
--   Note! If transit delivery and route is used both from supply site to "us" and
--   from "us" to the customer, the supply_site_due_date will not get the
--   exact correct value, since we then have to adjust both due dates
--   backwards again all the way from "our" planned due date back to
--   supplier's due date...
--   Now only "our" due date is adjusted. The supply site due date is
--   adjusted only if supplier's route departure date is moved forward...
PROCEDURE Calc_Ship_Date_Forwards___ (
   planned_ship_date_ IN OUT DATE,
   planned_due_date_  IN OUT DATE,
   picking_leadtime_  IN     NUMBER,
   route_id_          IN     VARCHAR2,
   supply_code_db_    IN     VARCHAR2,
   contract_          IN     VARCHAR2,
   part_no_           IN     VARCHAR2 )
IS
   inventory_part_  BOOLEAN;
   dist_calendar_   VARCHAR2(10);
   min_date_        DATE;
BEGIN
   planned_ship_date_ := planned_due_date_;

   -- check if "our" part is an inventory part.
   inventory_part_ := Inventory_Part_API.Check_Exist(contract_, part_no_);

   dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);

   IF (((supply_code_db_ IN ('IPT', 'PT')) AND inventory_part_) OR (supply_code_db_ IN ('SO', 'DOP', 'IO', 'PKG', 'MRO', 'PS', 'PI', 'PJD', 'CRO'))) THEN
      Trace_SYS.Field('Add "our" picking time', picking_leadtime_);
      -- add "our" picking leadtime (in workdays) for non-direct deliveries
      planned_ship_date_ := Work_Time_Calendar_API.Get_End_Date(dist_calendar_, planned_ship_date_, nvl(picking_leadtime_, 0));
   END IF;

   min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(dist_calendar_);
   Trace_SYS.Field('min date for calendar ' || dist_calendar_, min_date_);
   Trace_SYS.Field('planned ship date', planned_ship_date_);

   IF ((planned_ship_date_ IS NULL) OR (planned_ship_date_ < min_date_)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALSHIPDATE: Planned ship date is not within current calendar.');
   END IF;

   -- purchase direct (PD) doesn't have calendar or route
   IF (supply_code_db_ NOT IN ('PD', 'ND')) THEN
      -- "our" route to customer (for IPD it's the same route)
      IF (route_id_ IS NOT NULL) THEN
         Trace_SYS.Message('Check for (next) route date');
         -- planned ship date using route and calendar
         planned_ship_date_ := Delivery_Route_API.Get_Next_Route_Date(route_id_, planned_ship_date_, dist_calendar_, contract_);
         Trace_SYS.Field('route departure date', planned_ship_date_);
         IF (planned_ship_date_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'INVALROUTEDATE: Route departure date is not within current calendar.');
         ELSIF (supply_code_db_ = 'IPD') THEN
            planned_due_date_ := planned_ship_date_;
         END IF;

         -- only remove the picking time for non-direct deliveries
         IF (((supply_code_db_ IN ('IPT', 'PT')) AND inventory_part_) OR (supply_code_db_ IN ('SO', 'DOP', 'IO', 'PKG', 'MRO', 'PS', 'PI', 'PJD', 'CRO'))) THEN
            Trace_SYS.Field('Planned due date = Remove "our" picking time from route departure date...', picking_leadtime_);
            planned_due_date_ := Work_Time_Calendar_API.Get_Start_Date(dist_calendar_, planned_ship_date_, nvl(picking_leadtime_, 0));
         END IF;
      ELSE
         Trace_SYS.Message('No route: get nearest workday');
         planned_ship_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(dist_calendar_, planned_ship_date_);
      END IF;
   END IF;
END Calc_Ship_Date_Forwards___;


-- Calc_Del_Date_Forwards___
--   Calculates "forward" from ship date to delivery date.
PROCEDURE Calc_Del_Date_Forwards___ (
   planned_delivery_date_     IN OUT DATE,
   planned_ship_date_         IN     DATE,
   target_date_               IN     DATE,
   order_delivery_leadtime_   IN     NUMBER,
   ext_transport_calendar_id_ IN     VARCHAR2,
   supply_code_db_            IN     VARCHAR2,
   ship_via_code_             IN     VARCHAR2 )
IS
   temp_planned_ship_date_  DATE;
   
BEGIN
   IF (supply_code_db_ = 'ND') THEN
      -- Not Decided should have the same delivery date and ship date as due date
      planned_delivery_date_ := planned_ship_date_;

   ELSE
      Trace_SYS.Field('Add transport time to customer', order_delivery_leadtime_);
      -- add the transport time to customer. (transport calendar time if defined in ship via)
      -- (for Direct deliveries this is the same as supplier's transport time to customer...)

      -- Get the next work day according to ext transport calendar before adding delivery leadtime.
      Fetch_Calendar_End_Date(temp_planned_ship_date_, ext_transport_calendar_id_, planned_ship_date_, 0);
      Fetch_Calendar_End_Date(planned_delivery_date_, ext_transport_calendar_id_, temp_planned_ship_date_, order_delivery_leadtime_);

      IF (planned_delivery_date_ IS NOT NULL) AND (target_date_ IS NOT NULL) THEN
         Trace_SYS.Field('Set delivery time', to_char(target_date_, 'HH24:MI'));
         -- Reset to the same time as the time for the start date
         planned_delivery_date_ := to_date(to_char(planned_delivery_date_, 'YYYY-MM-DD') || ' ' || to_char(target_date_, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');
      END IF;
   END IF;
   IF (planned_delivery_date_ IS NOT NULL) AND (target_date_ IS NOT NULL) THEN
      -- Never deliver earlier than the target date.
      planned_delivery_date_ := greatest(planned_delivery_date_, target_date_);
   END IF;
END Calc_Del_Date_Forwards___;


-- Calc_Dates_Forwards___
--   Calculates forwards from "due date" and returns the planned due date,
--   shipping date and delivery date using total shipping time (in calendar days)
--   from supplier to customer.
PROCEDURE Calc_Dates_Forwards___ (
   supply_site_due_date_       IN OUT DATE,
   planned_due_date_           IN OUT DATE,
   planned_ship_date_          IN OUT DATE,
   planned_delivery_date_      IN OUT DATE,
   target_date_                IN     DATE,
   vendor_no_                  IN     VARCHAR2,
   vendor_contract_            IN     VARCHAR2,
   order_delivery_leadtime_    IN     NUMBER,
   ext_transport_calendar_id_  IN     VARCHAR2,
   picking_leadtime_           IN     NUMBER,
   internal_control_time_      IN     NUMBER,
   vendor_delivery_leadtime_   IN     NUMBER,   
   internal_delivery_leadtime_ IN     NUMBER,
   vendor_manuf_leadtime_      IN     NUMBER,
   vendor_leadtime_            IN     NUMBER,
   expected_leadtime_          IN     NUMBER,
   route_id_                   IN     VARCHAR2,
   supply_code_db_             IN     VARCHAR2,
   contract_                   IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   supplier_part_no_           IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   supplier_ship_via_transit_  IN     VARCHAR2,
   transport_leadtime_         IN     NUMBER,
   arrival_route_id_           IN     VARCHAR2 )
IS
BEGIN
   -- calculate forwards from calculated (supply site) due date to get a new planned due date, ...
   Calc_Due_Date_Forwards___(planned_due_date_, supply_site_due_date_, contract_, internal_control_time_, vendor_delivery_leadtime_,
      internal_delivery_leadtime_, vendor_manuf_leadtime_, vendor_leadtime_, expected_leadtime_,
      supply_code_db_, vendor_no_, vendor_contract_, supplier_part_no_, supplier_ship_via_transit_, transport_leadtime_, arrival_route_id_);   

   -- ... a new ship date...
   -- (planned due date might change if route's involved!) 
   Calc_Ship_Date_Forwards___(planned_ship_date_, planned_due_date_, picking_leadtime_,
      route_id_, supply_code_db_, contract_, part_no_);
   
   -- Adding to the planned due date the time set on delivery route   
   planned_due_date_ := Delivery_Route_API.Get_Due_Date_With_Time(route_id_, planned_ship_date_, planned_due_date_, contract_); 

   -- ... and a new delivery date
   Calc_Del_Date_Forwards___(planned_delivery_date_, planned_ship_date_, target_date_,
      order_delivery_leadtime_, ext_transport_calendar_id_, supply_code_db_, ship_via_code_);

END Calc_Dates_Forwards___;


-- Calc_Order_Atp_Date___
--   Executes the onhand analysis for the due date - if nothing available at
--   that given date, all dates are moved/recalculated.
PROCEDURE Calc_Order_Atp_Date___ (
   planned_delivery_date_      IN OUT DATE,
   planned_ship_date_          IN OUT DATE,
   planned_due_date_           IN OUT DATE,
   new_due_date_               IN OUT DATE,
   old_due_date_               IN OUT DATE,
   atp_datechanged_            IN OUT BOOLEAN,
   include_earliest_           IN OUT BOOLEAN,
   early_delivery_date_        IN OUT DATE,
   old_delivery_date_          IN OUT DATE,
   target_date_                IN     DATE,
   vendor_no_                  IN     VARCHAR2,
   vendor_contract_            IN     VARCHAR2,
   supply_site_reserve_type_   IN     VARCHAR2,
   order_delivery_leadtime_    IN     NUMBER,
   ext_transport_calendar_id_  IN     VARCHAR2,
   picking_leadtime_           IN     NUMBER,
   internal_control_time_      IN     NUMBER,
   vendor_delivery_leadtime_   IN     NUMBER,   
   internal_delivery_leadtime_ IN     NUMBER,
   vendor_manuf_leadtime_      IN     NUMBER,
   vendor_leadtime_            IN     NUMBER,
   expected_leadtime_          IN     NUMBER,
   route_id_                   IN     VARCHAR2,
   supply_code_db_             IN     VARCHAR2,
   old_supply_code_db_         IN     VARCHAR2,
   contract_                   IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   configuration_id_           IN     VARCHAR2,
   supplier_part_no_           IN     VARCHAR2,
   order_id_                   IN     VARCHAR2,
   conv_factor_                IN     NUMBER,
   inverted_conv_factor_       IN     NUMBER,
   new_demand_qty_             IN     NUMBER,
   old_demand_qty_             IN     NUMBER,
   objid_                      IN     VARCHAR2,
   allow_past_date_            IN     BOOLEAN,
   check_only_                 IN     BOOLEAN,
   old_part_ownership_db_      IN     VARCHAR2,
   part_ownership_db_          IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,   
   supplier_ship_via_transit_  IN     VARCHAR2,
   release_planning_           IN     VARCHAR2,
   demand_ref_                 IN     VARCHAR2,
   demand_code_                IN     VARCHAR2,
   new_mrp_demand_qty_         IN     NUMBER,
   old_mrp_demand_qty_         IN     NUMBER,
   fully_reserved_             IN     NUMBER,
   catalog_type_               IN     VARCHAR2,
   transport_leadtime_         IN     NUMBER,
   arrival_route_id_           IN     VARCHAR2,
   abnormal_demand_new_        IN     VARCHAR2,
   abnormal_demand_old_        IN     VARCHAR2 )
IS
   atp_contract_                 VARCHAR2(5);
   atp_part_no_                  VARCHAR2(25);
   iprec_                        Inventory_Part_API.Public_Rec;
   site_date_                    DATE;
   prio_inst_reserve_            BOOLEAN := FALSE;
   do_analysis_                  BOOLEAN;
   early_ship_date_              DATE;
   early_due_date_               DATE;
   early_start_date_             DATE;
   result_                       VARCHAR2(80);
   qty_possible_                 NUMBER;
   dummy_                        DATE;
   substitute_part_              BOOLEAN;
   catalog_no_                   VARCHAR2(25);   
   old_demand_quantity_          NUMBER;
   new_demand_quantity_          NUMBER;
   configurable_part_            BOOLEAN := FALSE;
   onhand_analysis_              BOOLEAN := TRUE;
   forecast_consump_flag_        VARCHAR2(30);
   do_forecast_                  BOOLEAN := FALSE;
   result_code_                  VARCHAR2(2000);
   available_qty_                NUMBER := 0;
   earliest_available_date_      DATE;
   dummy_1_                      VARCHAR2(2000);
   order_code_                   VARCHAR2(20);
   planned_del_date_changed_     BOOLEAN := FALSE;
   original_old_delivery_date_   DATE;
   run_online_consumption_       BOOLEAN := TRUE;
   promise_method_db_            VARCHAR2(20);
   dist_calendar_                VARCHAR2(10);
BEGIN
   
   site_date_ := Site_API.Get_Site_Date(nvl(vendor_contract_, contract_));

   forecast_consump_flag_ := Inventory_Part_API.Get_Forecast_Consump_Flag_Db(contract_, part_no_);

   -- fetch the inventory part to be able to check correct ATP flags
   IF (supply_code_db_ IN ('IPD','IPT')) THEN
      atp_contract_ := vendor_contract_;
      atp_part_no_ := supplier_part_no_;
   ELSE
      atp_contract_ := contract_;
      atp_part_no_ := part_no_;
   END IF;
   
   iprec_ := Inventory_Part_API.Get(atp_contract_, atp_part_no_);
   
   -- The old delivery date can change, but the message that gets shown when planned_del_date_changed_ is shown should use the original old date.
   original_old_delivery_date_ := old_delivery_date_;
   IF (planned_delivery_date_ != old_delivery_date_) THEN
      planned_del_date_changed_ := TRUE;
   END IF;
   old_demand_quantity_ := NVL(old_mrp_demand_qty_, old_demand_qty_);
   new_demand_quantity_ := NVL(new_mrp_demand_qty_, new_demand_qty_);
   IF (old_demand_quantity_ = 0 AND new_demand_quantity_ = 0) THEN
      run_online_consumption_ := FALSE;
   ELSIF ((old_demand_quantity_ = new_demand_quantity_) AND (fully_reserved_ = 1)) THEN 
      run_online_consumption_ := FALSE;
   END IF;
   
   -- Restructured the code for executing online consumption check.
   -- check forecast consumption flag on demand site, if not selected then check availability flag on supply site.
   -- Priority_reservation and instant_reservation are not considered when part has online_consumption checked.
   IF ((forecast_consump_flag_ = 'FORECAST') AND (NOT check_only_) AND (run_online_consumption_))  THEN   
            
      IF (supply_code_db_ IN ('IO', 'SO', 'DOP', 'PS', 'IPT', 'IPD', 'PD', 'PT')) THEN
         
         do_forecast_:= TRUE;

         -- old_demand_date need to change when there is a supply_code change (only ATP analysis considered)
         IF (old_supply_code_db_ NOT IN ('IO', 'SO', 'DOP', 'PS', 'PD', 'PT','IPD','IPT')) THEN
            old_demand_quantity_ := 0;
         END IF;
         IF ((old_part_ownership_db_ != 'COMPANY OWNED') AND (part_ownership_db_ = 'COMPANY OWNED'))  THEN
            old_demand_quantity_ := 0;
         ELSIF ((old_part_ownership_db_ = 'COMPANY OWNED') AND (part_ownership_db_ != 'COMPANY OWNED')) THEN
            new_demand_quantity_ := 0;
         END IF;
      ELSIF (old_supply_code_db_ IN ('IO', 'SO', 'DOP', 'PS', 'PD', 'PT', 'IPD', 'IPT')) THEN
         -- supply_code changed from IO, SO, DOP, PS, PD, PT, IPD and IPT to other supply_code then Master Schedule values should be reversed.
         new_demand_quantity_ := 0;
         do_forecast_ := TRUE;
      END IF;

      IF (do_forecast_) THEN
         IF (demand_code_ = 'PO') THEN
            $IF (Component_Purch_SYS.INSTALLED) $THEN              
               order_code_ := Purchase_Order_API.Get_Order_Code(demand_ref_);
            $ELSE
               NULL;
            $END
         END IF;
         IF (NVL(order_code_, '0') != '6') THEN
            Reserve_Customer_Order_API.Control_Ms_Mrp_Consumption(result_code_,
                                                                  available_qty_,
                                                                  earliest_available_date_,
                                                                  contract_,
                                                                  part_no_,
                                                                  0,
                                                                  new_demand_quantity_,
                                                                  old_demand_quantity_,
                                                                  planned_due_date_,
                                                                  old_due_date_,
                                                                  'CO',
                                                                  FALSE,
                                                                  abnormal_demand_new_,
                                                                  abnormal_demand_old_ );
         END IF;
      END IF;
      IF (result_code_ != 'SUCCESS') THEN
         
         dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_); 
         IF Work_Time_Calendar_API.Is_Working_Day(dist_calendar_, earliest_available_date_)= 0 THEN
            earliest_available_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(dist_calendar_, earliest_available_date_);
         END IF;

         Calc_Ship_Date_Forwards___(early_ship_date_, earliest_available_date_, picking_leadtime_, route_id_, supply_code_db_, contract_, part_no_);
         
         Calc_Del_Date_Forwards___ (early_delivery_date_, early_ship_date_, target_date_, order_delivery_leadtime_, ext_transport_calendar_id_, supply_code_db_, ship_via_code_);
         

         dummy_1_  :=   Language_SYS.Translate_Constant(lu_name_,
                        'ATPCHECKFAIL6B: For Site/Part :P1, the quantity available on :P2 is :P3 is the possible delivery date for the desired quantity. Either target date/planned delivery date or ordered quantity has to be changed.',
                        Language_SYS.Get_Language,
                        contract_ ||'/'||part_no_,
                        planned_due_date_,
                        available_qty_ ||'.'|| chr(13) || chr(10) ||early_delivery_date_);
                       
         $IF (Component_Massch_SYS.INSTALLED) $THEN
            promise_method_db_ := Level_1_Part_API.Get_Promise_Method_Db(contract_, part_no_,'*');
            -- Change message wordings according to the promise method
            IF (promise_method_db_ = 'UCF') THEN
                dummy_1_  := Language_SYS.Translate_Constant(lu_name_,
                        'ATPCHECKFAIL61B: For Site/Part :P1, the remaining unconsumed forecast on :P2 is :P3 is the possible delivery date for the desired quantity. Either target date/planned delivery date or ordered quantity has to be changed.',
                        Language_SYS.Get_Language,
                        contract_ ||'/'||part_no_,
                        planned_due_date_,
                        available_qty_||'.'|| chr(13) || chr(10) ||early_delivery_date_);
            ELSIF (promise_method_db_ = 'ATP') THEN
                dummy_1_  := Language_SYS.Translate_Constant(lu_name_,
                        'ATPCHECKFAIL62B: For Site/Part :P1, the remaining unconsumed supply on :P2 is :P3 is the possible delivery date for the desired quantity. Either target date/planned delivery date or ordered quantity has to be changed.',
                        Language_SYS.Get_Language,
                        contract_ ||'/'||part_no_,
                        planned_due_date_,
                        available_qty_||'.'|| chr(13) || chr(10) ||early_delivery_date_);
            END IF;
         $END 

         Error_SYS.Appl_General(
            lu_name_,
            'CC_INFO: :P1',
             dummy_1_ );
            
         END IF;
         
   -- When onhand_analysis_flag checked, 'SO' and 'DOP' excluded from execution
   ELSIF (nvl(iprec_.onhand_analysis_flag, ' ') = 'Y') AND (supply_code_db_ IN ('IO', 'IPD', 'IPT'))
         AND (new_demand_qty_ != 0) THEN
         
      IF (supply_code_db_ = 'IO') THEN
         -- if part is set to use Normal reservation, fetch flag from the Order type.
         IF (nvl(iprec_.oe_alloc_assign_flag, 'N') = 'N') AND (order_id_ IS NOT NULL) THEN
            Trace_SYS.Message('Normal reservation - fetch reservation from order type');
            iprec_.oe_alloc_assign_flag := Cust_Ord_Reservation_Type_API.Encode(Cust_Order_Type_API.Get_Oe_Alloc_Assign_Flag(order_id_));
         END IF;

         -- check ATP if Normal reservation... (Priority reservations are made for Inventory Orders only)
         prio_inst_reserve_ := (nvl(iprec_.oe_alloc_assign_flag, 'N') = 'Y');

         Trace_SYS.Field('Priority reservation', prio_inst_reserve_);

      -- check if instant supply site reservation is going to be executed...
      ELSIF (supply_code_db_ IN ('IPT', 'IPD')) THEN

         -- check if INSTANT reservation is allowed (only applicable for IPD and IPT).
         -- Method used is the overloaded method that has order line/source line as key parameters,
         -- but they're not used in the method... pass all of them as NULL
         -- (Note! Method fetches supply site)
         prio_inst_reserve_ := (Reserve_Customer_Order_API.Is_Supply_Chain_Reservation(NULL, NULL, NULL, NULL, NULL,
                                contract_, supply_code_db_, vendor_no_, supplier_part_no_, supply_site_reserve_type_, 'INSTANT') = 1);
         Trace_SYS.Field('Instant reservation', prio_inst_reserve_);
      END IF;

      -- Priority_reservation and instant_reservation are not considered when part has online_consumption checked.
      do_analysis_ := NOT prio_inst_reserve_;
      
      -- if no prioritized/instant reservation is being executed, make ATP analysis.
      IF do_analysis_ THEN
         IF (NOT (supply_code_db_ IN ('IPD', 'IPT') AND release_planning_ = 'NOTRELEASED')) THEN
            -- store dates
            old_due_date_ := new_due_date_;
            -- replace old_delivery_date_ since atp_datechanged_ flag is used hereafter instead of allow_past_date_.
            old_delivery_date_ := planned_delivery_date_;
            early_ship_date_ := planned_ship_date_;
            Trace_SYS.Field('Make onhand analysis for due date', new_due_date_);
            Trace_SYS.Field('new_demand_qty_', new_demand_qty_);

            configurable_part_ := Part_Catalog_API.Get_Configurable_Db(part_no_) = 'CONFIGURED';
            IF (configuration_id_ = '*' AND configurable_part_) THEN
               onhand_analysis_ := FALSE;
            END IF;
            
            -- execute the ATP / onhand analysis
            IF (onhand_analysis_) THEN
               Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_,
                                                                qty_possible_,
                                                                dummy_,
                                                                early_ship_date_,
                                                                new_due_date_,
                                                                atp_contract_,
                                                                atp_part_no_,
                                                                configuration_id_,
                                                                'TRUE',
                                                                'FALSE',
                                                                NULL,
                                                                NULL,
                                                                objid_,
                                                                new_demand_qty_,
                                                                picking_leadtime_,
                                                                part_ownership_db_,
                                                                NULL,
                                                                NULL,
                                                                TRUE);

            Trace_SYS.Field('Analysis - possible qty', qty_possible_);
            Trace_SYS.Field('Analysis result', result_);
            Trace_SYS.Field('Due Date from Onhand Analysis', new_due_date_);
            IF (result_ = 'SUPPLIES_NOT_ALLOWED') THEN
               Error_SYS.Record_General(lu_name_, 'PHASEDOUTPART: Supplies are not allowed for part :P1. Review the supply situation and/or look for an alternative part.', part_no_);
            END IF;

            -- if the quantity wasn't enough, present a message
            IF (result_ NOT IN ('SUCCESS')) THEN
               -- convert to inventory unit (check to avoid divide by zero error)
               IF (conv_factor_ = 0) THEN
                  qty_possible_ := 0;
               ELSE
                  qty_possible_ := qty_possible_ / conv_factor_ * inverted_conv_factor_;
               END IF;
               Client_SYS.Add_Info(lu_name_, 'PLANNABLE: Only :P1 is plannable on the planned delivery date entered for the part :P2.', to_char(qty_possible_), part_no_);
            END IF;

            -- has the "due date" been changed?
            IF (old_due_date_ != new_due_date_) THEN
               atp_datechanged_ := TRUE;
            END IF;
         END IF;

        END IF;
      END IF;
   END IF;
   
   -- if no ATP check will be made set earliest delivery date to calculated delivery date (or today)
   early_delivery_date_ := greatest(planned_delivery_date_, trunc(site_date_));
   -- set a new start date to calculate from
   -- new date is otherwise set to the calculated "ATP date"
   IF atp_datechanged_ THEN
      early_start_date_ := new_due_date_;

   -- "restart" from today's date...
   ELSIF (supply_code_db_ = 'SO') THEN
      early_start_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(Site_API.Get_Manuf_Calendar_Id(contract_), site_date_);

   ELSIF (supply_code_db_ IN ('IPT', 'IPD')) THEN
      early_start_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(Site_API.Get_Dist_Calendar_Id(vendor_contract_), site_date_);

   ELSIF (supply_code_db_ IN ('PT', 'PD')) THEN
      early_start_date_ := trunc(SYSDATE); -- we don't know the supplier's site/calendar

   ELSE
      early_start_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(Site_API.Get_Dist_Calendar_Id(contract_), site_date_);

   END IF;

   -- calculate forwards from calculated due date (or today) to get a new planned due date, ...
   Calc_Dates_Forwards___(early_start_date_, early_due_date_, early_ship_date_, early_delivery_date_,
      target_date_, vendor_no_, vendor_contract_, order_delivery_leadtime_, ext_transport_calendar_id_,
      picking_leadtime_, internal_control_time_, vendor_delivery_leadtime_, 
      internal_delivery_leadtime_, vendor_manuf_leadtime_, vendor_leadtime_,
      expected_leadtime_, route_id_, supply_code_db_, contract_, part_no_, 
      supplier_part_no_, ship_via_code_, supplier_ship_via_transit_, transport_leadtime_, arrival_route_id_);

   -- Reset to the same time as specified in the CO header
   early_delivery_date_ := to_date(to_char(early_delivery_date_, 'YYYY-MM-DD') || ' ' || to_char(target_date_, 'HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS');

   IF (atp_datechanged_ OR NOT allow_past_date_) AND (trunc(early_delivery_date_) > trunc(target_date_)) THEN

      -- if ATP / onhand analysis has changed the date - or if a date in the past is not allowed ...
      new_due_date_ := early_start_date_; -- supply site due date might change if there's a route involved
      planned_due_date_ := early_due_date_;
      planned_ship_date_ := early_ship_date_;
      planned_delivery_date_ := early_delivery_date_;

      -- Check if there is a substitute part.
      catalog_no_ := Sales_Part_API.Get_Catalog_No_For_Part_No(atp_contract_, atp_part_no_);
      substitute_part_ := Substitute_Sales_Part_API.Check_Substitute_Part_Exist(atp_contract_, catalog_no_, NULL);
      Trace_SYS.Field('substitute_part_', substitute_part_);

      Info_On_Plan_Del_Date_Ch___(planned_delivery_date_, old_delivery_date_, substitute_part_, catalog_type_);
      
   ELSE
      -- if ATP hasn't changed the dates, include earliest delivery date in the "due date" message in calling method...
      include_earliest_ := (trunc(early_delivery_date_) > trunc(target_date_));
      IF (planned_del_date_changed_) THEN
         -- Never mind the substitute part here.
         Info_On_Plan_Del_Date_Ch___(planned_delivery_date_, original_old_delivery_date_, FALSE, catalog_type_);
      END IF;
   END IF;

END Calc_Order_Atp_Date___;


-- Calc_Order_Dates___
--   General method to calculate dates for ORDER , QUOTATION and DISTORDER.
--   Includes ATP analysis (for ORDER) and setting of new dates if ATP flag
--   is set.
PROCEDURE Calc_Order_Dates___ (
   planned_delivery_date_        IN OUT DATE,
   planned_ship_date_            IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   target_date_                  IN     DATE,
   date_entered_                 IN     DATE,
   customer_no_                  IN     VARCHAR2,
   addr_no_                      IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supplier_ship_via_transit_    IN     VARCHAR2,
   supply_site_reserve_type_     IN     VARCHAR2,
   route_id_                     IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   source_                       IN     VARCHAR2,
   check_only_                   IN     BOOLEAN,
   old_part_ownership_db_        IN     VARCHAR2,
   part_ownership_db_            IN     VARCHAR2,
   order_id_                     IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   conv_factor_                  IN     NUMBER,
   inverted_conv_factor_         IN     NUMBER,
   ctp_planned_db_               IN     VARCHAR2,
   new_demand_qty_               IN     NUMBER,
   old_demand_qty_               IN     NUMBER,
   objid_                        IN     VARCHAR2,
   old_supply_code_db_           IN     VARCHAR2,
   objstate_                     IN     VARCHAR2,
   old_due_date_                 IN     DATE,
   release_planning_             IN     VARCHAR2,
   demand_ref_                   IN     VARCHAR2,
   demand_code_                  IN     VARCHAR2,
   new_mrp_demand_qty_           IN     NUMBER,
   old_mrp_demand_qty_           IN     NUMBER,
   catalog_type_                 IN     VARCHAR2,
   use_current_date_             IN     VARCHAR2,
   fully_reserved_               IN     NUMBER,
   col_objstate_                 IN     VARCHAR2,
   supply_site_part_no_          IN     VARCHAR2,
   abnormal_demand_new_          IN     VARCHAR2,
   abnormal_demand_old_          IN     VARCHAR2)
IS
   vendor_addr_no_             SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE;
   vendor_contract_            VARCHAR2(5) := NULL;
   vendor_category_            VARCHAR2(20) := NULL;
   site_date_                  DATE;
   atp_datechanged_            BOOLEAN := FALSE;
   early_delivery_date_        DATE;
   new_due_date_               DATE;
   delivery_leadtime_          NUMBER;
   picking_leadtime_           NUMBER;
   internal_control_time_      NUMBER;
   vendor_delivery_leadtime_   NUMBER;
   internal_delivery_leadtime_ NUMBER;
   vendor_manuf_leadtime_      NUMBER;
   vendor_leadtime_            NUMBER;
   expected_leadtime_          NUMBER;
   addr_flag_db_               VARCHAR2(1) := 'N';
   include_earliest_           BOOLEAN := FALSE;
   manuf_start_date_           DATE := NULL;
   allow_past_date_            BOOLEAN := TRUE;
   onhand_analysis_flag_       VARCHAR2(1);
   supp_route_id_              VARCHAR2(12);
   current_date_               DATE;
   temp_old_due_date_          DATE;
   old_delivery_date_          DATE;
   ext_transport_calendar_id_  CUSTOMER_ORDER_LINE_TAB.ext_transport_calendar_id%TYPE;
   supplier_calendar_id_       VARCHAR2(10);
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);
BEGIN

   Get_Supplier_Info___(vendor_addr_no_, vendor_contract_, vendor_category_, supplier_calendar_id_, vendor_no_, supply_code_db_);

   site_date_ := Site_API.Get_Site_Date(nvl(vendor_contract_, contract_));

   Cust_Order_Leadtime_Util_API.Get_Default_Leadtimes(delivery_leadtime_, vendor_delivery_leadtime_,
      internal_delivery_leadtime_, picking_leadtime_, internal_control_time_, vendor_manuf_leadtime_,
      vendor_leadtime_, expected_leadtime_, transport_leadtime_, arrival_route_id_, contract_, customer_no_, addr_no_, addr_flag_db_, part_no_,
      NVL(supply_site_part_no_, supplier_part_no_), supply_code_db_, vendor_no_, ship_via_code_, supplier_ship_via_transit_);

   -- If a delivery leadtime was passed in this should override the default value retrieved from the supply chain matrixes, 
   -- also the external transport calendar default should be used in this case.
   IF (default_delivery_leadtime_ IS NOT NULL) THEN
      delivery_leadtime_ := default_delivery_leadtime_;
      ext_transport_calendar_id_ := default_ext_transport_cal_id_;
   ELSE
      -- Use the ext transport calendar for the ship via code
      ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(ship_via_code_);
   END IF;

   -- If a picking leadtime was passed in this should override the default value retrieved from the supply chain matrixes
   IF (default_picking_leadtime_ IS NOT NULL) THEN
      picking_leadtime_ := default_picking_leadtime_;
   END IF;
   Calc_Dates_Backwards___(planned_delivery_date_, planned_ship_date_, planned_due_date_, supply_site_due_date_,
                           manuf_start_date_, allow_past_date_, old_delivery_date_, target_date_, date_entered_,
                           vendor_no_, vendor_contract_, supplier_calendar_id_, delivery_leadtime_, ext_transport_calendar_id_, picking_leadtime_, internal_control_time_,
                           vendor_delivery_leadtime_, internal_delivery_leadtime_, vendor_manuf_leadtime_,
                           vendor_leadtime_, expected_leadtime_, route_id_,
                           supply_code_db_, contract_, part_no_, NVL(supply_site_part_no_, supplier_part_no_), source_, objstate_, ship_via_code_, supplier_ship_via_transit_, use_current_date_,
                           col_objstate_, transport_leadtime_, arrival_route_id_);

   IF (source_ = 'ORDER') AND NOT allow_past_date_ THEN
      -- allow past date flag has already been set to false in Calc_Dates_Backwards___.
      onhand_analysis_flag_ := Inventory_Part_Onh_Analys_API.Encode(Inventory_Part_API.Get_Onhand_Analysis_Flag(contract_, part_no_));
      IF (NVL(onhand_analysis_flag_, ' ') = 'N') THEN
         Trace_SYS.Message(supply_code_db_ || ' + route exists. Planned ship date has been moved forwards.');
         Client_SYS.Add_Info(lu_name_, 'EARLYROUTEDATE: The planned ship date cannot be earlier than today''s date when a route exists.');
      END IF;

   ELSE
      allow_past_date_ := TRUE; -- only used for ORDER
   END IF;
   
   -- Moved the code block so that the allow_past_date_ is set to TRUE once the EARLYROUTEDATE message is handled.
   IF (supply_code_db_ IN ('SO', 'DOP', 'PS', 'CRO')) THEN
      new_due_date_ := manuf_start_date_;
      -- For Supply Codes 'SO', 'DOP', 'PS' and 'CRO' allow_past_date_ is set to TRUE in order to prevent overriding the dates from the dates calculated from Calc_Dates_Forwards___.
      allow_past_date_ := TRUE;
   ELSE
      new_due_date_ := supply_site_due_date_;
      -- For Supply Codes 'PT' allow_past_date_ is set to TRUE in order to prevent overriding the dates from the dates calculated from Calc_Dates_Forwards___.
      IF (supply_code_db_ = 'PT') THEN
         allow_past_date_ := TRUE;
      END IF;
   END IF;

   Trace_SYS.Field('"due date"', new_due_date_);
   
   IF (source_ = 'ORDER') AND (supply_code_db_ = 'IPT') THEN
      -- fetch the route between supply site and the demand site.
      supp_route_id_ := Get_Route___(contract_, NVL(supply_site_part_no_, supplier_part_no_), supply_code_db_, vendor_no_, supplier_ship_via_transit_);
      current_date_ := Site_API.Get_Site_Date(vendor_contract_);

      -- If a route exists and the order is still in the 'Planned' state, the supply site due date cannot have a date in the past.
      -- The order line dates must be recalculated (forward).
      IF ((nvl(objstate_, ' ') = 'Planned') AND (supp_route_id_ IS NOT NULL) AND (TRUNC(NVL(supply_site_due_date_, current_date_)) < TRUNC(current_date_))) THEN
         allow_past_date_ := FALSE;
         onhand_analysis_flag_ := Inventory_Part_Onh_Analys_API.Encode(Inventory_Part_API.Get_Onhand_Analysis_Flag(vendor_contract_, NVL(supply_site_part_no_, supplier_part_no_)));
         IF (NVL(onhand_analysis_flag_, ' ') = 'N') THEN
            Trace_SYS.Message('IPT + supplier route exists. Supply site due date is too early');
            Client_SYS.Add_Info(lu_name_, 'EARLYDUEDATESUPP3: The due date at supplier cannot be earlier than today''s date when a route exists at supply site.');
         END IF;
      END IF;
   END IF;

   -- availability check / forecast consumption NOT(!) needed when CTP "calculation" has been made -
   -- ATP check can only be made for internal purchase delivery and inventory orders.
   temp_old_due_date_ := old_due_date_;
   IF ((source_ IN ('ORDER', 'DISTORDER') AND (nvl(ctp_planned_db_, ' ') = 'N'))) THEN
      Calc_Order_Atp_Date___(planned_delivery_date_, planned_ship_date_, planned_due_date_,
         new_due_date_, temp_old_due_date_, atp_datechanged_, include_earliest_, early_delivery_date_,
         old_delivery_date_, target_date_, vendor_no_, vendor_contract_, supply_site_reserve_type_,
         delivery_leadtime_, ext_transport_calendar_id_, picking_leadtime_, internal_control_time_, vendor_delivery_leadtime_,
         internal_delivery_leadtime_, vendor_manuf_leadtime_, vendor_leadtime_, expected_leadtime_, route_id_,
         supply_code_db_, old_supply_code_db_, contract_, part_no_, configuration_id_, NVL(supply_site_part_no_, supplier_part_no_), order_id_,
         conv_factor_, inverted_conv_factor_, new_demand_qty_, old_demand_qty_, objid_, allow_past_date_, check_only_, old_part_ownership_db_, 
         part_ownership_db_, ship_via_code_, supplier_ship_via_transit_, release_planning_, demand_ref_, demand_code_,
         new_mrp_demand_qty_, old_mrp_demand_qty_, fully_reserved_, catalog_type_, transport_leadtime_, arrival_route_id_, abnormal_demand_new_, abnormal_demand_old_);

      Trace_SYS.Field('"due date"', new_due_date_);
   ELSIF (source_ = 'QUOTATION') THEN
      IF (planned_delivery_date_ != old_delivery_date_) THEN
         Info_On_Plan_Del_Date_Ch___(planned_delivery_date_, old_delivery_date_, FALSE, catalog_type_);
      END IF;
   END IF;

   -- display due date warning...
   IF (source_ IN ('ORDER', 'QUOTATION', 'DISTORDER')) AND (NOT atp_datechanged_ AND allow_past_date_) AND (new_due_date_ < trunc(site_date_)) THEN

      Trace_SYS.Message('"due date" is too early - INFORM!');

      IF (catalog_type_ IS NULL OR catalog_type_  != 'KOMP') THEN
         IF (supply_code_db_ IN ('PT', 'PD', 'IPT', 'IPD')) THEN
            IF include_earliest_ THEN
               Client_SYS.Add_Info(lu_name_, 'EARLYDUEDATESUPP2: The due date at supplier is earlier than today''s date. Earliest possible delivery date is :P1.', to_char(early_delivery_date_, 'YYYY-MM-DD'));
            ELSE
               Client_SYS.Add_Info(lu_name_, 'EARLYDUEDATESUPP: The due date :P1 at supplier is earlier than today''s date.', to_char(new_due_date_, 'YYYY-MM-DD'));
            END IF;
         ELSE
            IF include_earliest_ THEN
               Client_SYS.Add_Info(lu_name_, 'EARLYDUEDATE2: The due date is earlier than today''s date. Earliest possible delivery date is :P1.', to_char(early_delivery_date_, 'YYYY-MM-DD'));
            ELSE
               Client_SYS.Add_Info(lu_name_, 'EARLYDUEDATE: The due date :P1 is earlier than today''s date.', to_char(new_due_date_, 'YYYY-MM-DD'));
            END IF;
         END IF;
      END IF;
   END IF;

   supply_site_due_date_ := NULL;

   IF (source_ IN ('ORDER', 'QUOTATION') AND (supply_code_db_ IN ('IPT', 'IPD'))) THEN
      -- set supply site due date for inventory parts existing on supply site...
      IF Inventory_Part_API.Check_Exist(vendor_contract_, NVL(supply_site_part_no_, supplier_part_no_)) THEN
         supply_site_due_date_ := new_due_date_;
      END IF;
   END IF;
END Calc_Order_Dates___;


-- Calc_Sourcing_Dates___
--   General method to calculate dates for manual and automatic SOURCING.
PROCEDURE Calc_Sourcing_Dates___ (
   planned_delivery_date_        IN OUT DATE,
   planned_ship_date_            IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   picking_leadtime_             IN OUT NUMBER,
   wanted_delivery_date_         IN     DATE,
   customer_no_                  IN     VARCHAR2,
   addr_no_                      IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supplier_ship_via_transit_    IN     VARCHAR2,
   route_id_                     IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   forward_                      IN     BOOLEAN )
IS
   vendor_addr_no_             SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE;
   vendor_contract_            VARCHAR2(5) := NULL;
   vendor_category_            VARCHAR2(20) := NULL;
   date_entered_               DATE;
   delivery_leadtime_          NUMBER;
   internal_control_time_      NUMBER;
   vendor_delivery_leadtime_   NUMBER;
   internal_delivery_leadtime_ NUMBER;
   vendor_manuf_leadtime_      NUMBER;
   vendor_leadtime_            NUMBER;
   expected_leadtime_          NUMBER;
   iprec_                      Inventory_Part_API.Public_Rec;
   manuf_start_date_           DATE := NULL;
   temp_due_date_              DATE;
   allow_past_date_            BOOLEAN := TRUE; -- dummy
   old_delivery_date_          DATE; -- dummy
   ext_transport_calendar_id_  CUSTOMER_ORDER_LINE_TAB.ext_transport_calendar_id%TYPE;
   supplier_calendar_id_       VARCHAR2(10);
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);
   
BEGIN

   Get_Supplier_Info___(vendor_addr_no_, vendor_contract_, vendor_category_, supplier_calendar_id_, vendor_no_, supply_code_db_);

   Cust_Order_Leadtime_Util_API.Get_Default_Leadtimes(delivery_leadtime_, vendor_delivery_leadtime_,
      internal_delivery_leadtime_, picking_leadtime_, internal_control_time_, vendor_manuf_leadtime_,
      vendor_leadtime_, expected_leadtime_, transport_leadtime_, arrival_route_id_, contract_, customer_no_, addr_no_, addr_flag_db_, part_no_,
      supplier_part_no_, supply_code_db_, vendor_no_, ship_via_code_, supplier_ship_via_transit_);

   -- If a delivery leadtime was passed in this should override the default value retrieved from the supply chain matrixes, 
   -- also the external transport calendar default should be used in this case.
   IF (default_delivery_leadtime_ IS NOT NULL) THEN
      delivery_leadtime_ := default_delivery_leadtime_;   
      ext_transport_calendar_id_ := default_ext_transport_cal_id_;
   ELSE
      -- Use the ext transport calendar for the ship via code
      ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(ship_via_code_);
   END IF;

   -- If a picking leadtime was passed in this should override the default value retrieved from the supply chain matrixes.
   IF (default_picking_leadtime_ IS NOT NULL) THEN
      picking_leadtime_ := default_picking_leadtime_;
   END IF;

   -- check direction for the date calculation
   IF forward_ THEN
      -- planned_due_date is "full quantity date" at supply or demand site.
      supply_site_due_date_ := planned_due_date_;

      -- If delivering from our site or an internal supplier then make sure planned due date is a working day
      IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
         -- This will be due date at the suppliers site
         temp_due_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(Site_API.Get_Dist_Calendar_Id(vendor_contract_), planned_due_date_);
      ELSIF (supply_code_db_ IN ('PD', 'PT')) THEN
         -- We have no calendar to check against
         temp_due_date_ := trunc(planned_due_date_);
      ELSE
         -- Delivery from our site
         temp_due_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(Site_API.Get_Dist_Calendar_Id(contract_), planned_due_date_);
      END IF;

      -- calculate forward from calculated due date to get new dates
      Calc_Dates_Forwards___(temp_due_date_, planned_due_date_, planned_ship_date_, planned_delivery_date_,
         wanted_delivery_date_, vendor_no_, vendor_contract_, delivery_leadtime_, ext_transport_calendar_id_,
         picking_leadtime_, internal_control_time_, vendor_delivery_leadtime_,
         internal_delivery_leadtime_, vendor_manuf_leadtime_, vendor_leadtime_,
         expected_leadtime_, route_id_, supply_code_db_, contract_, part_no_, 
         supplier_part_no_, ship_via_code_, supplier_ship_via_transit_, transport_leadtime_, arrival_route_id_);

      IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
         iprec_ := Inventory_Part_API.Get(vendor_contract_, supplier_part_no_);
         -- if part is NOT set up to use ATP of any kind, earliest supply site due date will NOT have a value
         IF NOT ((nvl(iprec_.forecast_consumption_flag, ' ') = 'FORECAST') OR (nvl(iprec_.onhand_analysis_flag, ' ') = 'Y')) THEN
            supply_site_due_date_ := NULL;
         END IF;
      END IF;

   ELSE -- ...backwards

      -- date_entered is never used in Sourcing...
      date_entered_ := NULL;
      Calc_Dates_Backwards___(planned_delivery_date_, planned_ship_date_, planned_due_date_, supply_site_due_date_,
         manuf_start_date_, allow_past_date_, old_delivery_date_, wanted_delivery_date_, date_entered_, vendor_no_, 
         vendor_contract_, supplier_calendar_id_, delivery_leadtime_, ext_transport_calendar_id_, picking_leadtime_, internal_control_time_,
         vendor_delivery_leadtime_, internal_delivery_leadtime_, vendor_manuf_leadtime_, vendor_leadtime_, expected_leadtime_,
         route_id_, supply_code_db_, contract_, part_no_, supplier_part_no_, 'SOURCING', NULL, ship_via_code_, supplier_ship_via_transit_, 'FALSE', NULL,
         transport_leadtime_, arrival_route_id_);
   END IF;

   IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
      -- check if the part is an inventory part at supply site
      IF NOT Inventory_Part_API.Check_Exist(vendor_contract_, supplier_part_no_) THEN
         supply_site_due_date_ := NULL;
      END IF;
   ELSE
      supply_site_due_date_ := NULL;
   END IF;
END Calc_Sourcing_Dates___;


-- Get_Route___
--   Retreives the route ID from supply chain matrix if not found retrieve
--   it from the internal customer.
FUNCTION Get_Route___ (
   contract_                  IN     VARCHAR2,
   part_no_                   IN     VARCHAR2,
   supply_code_               IN     VARCHAR2,
   vendor_no_                 IN     VARCHAR2,
   supplier_ship_via_transit_ IN     VARCHAR2 ) RETURN VARCHAR2
IS
   company_     VARCHAR2(20);
   addr_no_     VARCHAR2(50);
   ean_         VARCHAR2(100);
   customer_no_ customer_order_line_tab.customer_no%TYPE;
   route_id_    VARCHAR2(12);
   transit_del_leadtime_     NUMBER;
   transit_distance_         NUMBER;
   transit_cost_             NUMBER;
   cost_curr_code_           VARCHAR2(3);
   transit_int_leadtime_     NUMBER;
   transit_picking_leadtime_ NUMBER;
   transit_route_id_         VARCHAR2(12);
   sc_matrix_record_found_   BOOLEAN;
   dummy_delivery_terms_     VARCHAR2(5);
   dummy_del_terms_location_ VARCHAR2(100);
   transport_leadtime_       NUMBER;
   arrival_route_id_         VARCHAR2(12);
   
BEGIN

   Cust_Order_Leadtime_Util_API.Get_Transit_Ship_Via_Values(transit_del_leadtime_, transit_distance_, transit_cost_, cost_curr_code_, transit_int_leadtime_, transit_picking_leadtime_, transit_route_id_,
                                                            sc_matrix_record_found_, dummy_delivery_terms_, dummy_del_terms_location_, transport_leadtime_, arrival_route_id_, contract_, part_no_, supply_code_, vendor_no_, supplier_ship_via_transit_);

   IF (transit_route_id_ IS NULL) AND (supply_code_ = 'IPT') THEN
   company_ := Site_API.Get_Company(contract_);
   -- get the site's delivery address
   addr_no_ := Site_API.Get_Delivery_Address(contract_);
   -- get the EAN location
   ean_ := Company_Address_API.Get_Ean_Location(company_, addr_no_);
   Trace_SYS.Field('address ean location', ean_);
   -- get the internal customer number
   customer_no_ := Cust_Ord_Customer_API.Get_Customer_No_From_Contract(contract_);
   Trace_SYS.Field('customer no', customer_no_);
   -- get the address using the EAN location
   addr_no_ := Customer_Info_Address_API.Get_Id_By_Ean_Location(customer_no_, ean_);
   Trace_SYS.Field('addr no', addr_no_);

      IF (Cust_Ord_Customer_Address_API.Get_Ship_Via_Code(customer_no_, addr_no_) = supplier_ship_via_transit_) THEN
   route_id_ := Cust_Ord_Customer_Address_API.Get_Route_Id(customer_no_, addr_no_);
      END IF;
   ELSE
      route_id_ := transit_route_id_;
   END IF;

   Trace_SYS.Field('supplier''s route to "us"', route_id_);

   RETURN route_id_;
END Get_Route___;


-- Get_Supplier_Info___
--   Retreives supplier address, supply site and category (Internal/External)
PROCEDURE Get_Supplier_Info___ (
   addr_no_                IN OUT VARCHAR2,
   contract_               IN OUT VARCHAR2,
   category_               IN OUT VARCHAR2,
   supplier_calendar_id_   IN OUT VARCHAR2,
   vendor_no_              IN     VARCHAR2,
   supply_code_db_         IN     VARCHAR2 )
IS
BEGIN
   addr_no_ := NULL;
   contract_ := NULL;
   category_ := NULL;

   -- only fetch supplier if Purchase supply
   IF ((vendor_no_ IS NOT NULL) AND (supply_code_db_ IN ('IPT', 'PT', 'IPD', 'PD'))) THEN
      addr_no_ := Supplier_Info_Address_API.Get_Default_Address(vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         Trace_SYS.Message('Fetch supply site and supplier category');
         contract_ := Supplier_API.Get_Acquisition_Site(vendor_no_);
         category_ := Supplier_Category_API.Encode(Supplier_API.Get_Category(vendor_no_));
         supplier_calendar_id_ := Supplier_Address_API.Get_Supplier_Calendar_Id(vendor_no_, addr_no_);                
      $END
      END IF;
END Get_Supplier_Info___;


-- Error_Date_Not_In_Calendar___
--   Raises an error. This is called from more than one place, and therefore put in a separate function, to avoid coding the error message more than once.
PROCEDURE Error_Date_Not_In_Calendar___ (
   calendar_id_   IN VARCHAR2,
   date_          IN DATE,
   duration_      IN NUMBER )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'DATENOTINCALENDAR: The date :P1 with duration :P2 is not within the distribution/external transport/supplier calendar :P3.', 
                            date_, duration_, calendar_id_);
END Error_Date_Not_In_Calendar___;


-- Info_On_Plan_Del_Date_Ch___
--   Adds and info message to Client_Sys info. This is called from more than one place, and therefore put in a separate function, to avoid coding the info message more than once.
PROCEDURE Info_On_Plan_Del_Date_Ch___ (
   planned_delivery_date_ IN DATE,
   old_delivery_date_     IN DATE,
   substitute_part_       IN BOOLEAN,
   catalog_type_          IN VARCHAR2 )
IS
BEGIN
   IF substitute_part_ THEN
      Client_SYS.Add_Info(lu_name_, 'TARGETDATECHGSUBST: The planned delivery date has been changed from :P1 to :P2. Check Substitute Sales Part.',
                                       to_char(old_delivery_date_, 'YYYY-MM-DD HH24.MI'),
                                       to_char(planned_delivery_date_, 'YYYY-MM-DD HH24.MI'));
   ELSE
      IF (catalog_type_ IS NULL OR catalog_type_  != 'KOMP') THEN
         Client_SYS.Add_Info(lu_name_, 'TARGETDATECHG: The planned delivery date has been changed from :P1 to :P2.',
                                          to_char(old_delivery_date_, 'YYYY-MM-DD HH24.MI'),
                                          to_char(planned_delivery_date_, 'YYYY-MM-DD HH24.MI'));
      END IF;
   END IF;
END Info_On_Plan_Del_Date_Ch___;

-- Set_Invalid_Calendar_Info___
--   Adds or appends the calendar_id_ to App_Context_SYS with key 'CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_' if it doesn't exist.
PROCEDURE Set_Invalid_Calendar_Info___ (
   date_        IN DATE,
   calendar_id_ IN VARCHAR2,
   duration_    IN NUMBER )
IS
   invalid_calendar_info_ VARCHAR2(2000);
BEGIN
   IF Get_Calendar_End_Date(calendar_id_, date_, NVL(duration_, 0)) IS NULL THEN
      invalid_calendar_info_ := App_Context_SYS.Find_Value('CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_');
      IF (invalid_calendar_info_ IS NULL) THEN
         invalid_calendar_info_ := calendar_id_;
      ELSIF (INSTR(','||invalid_calendar_info_||',', ','||calendar_id_||',') = 0) THEN
         IF  (LENGTH(invalid_calendar_info_||','||calendar_id_) < 2000) THEN
            invalid_calendar_info_ := invalid_calendar_info_||','||calendar_id_;
         END IF;
      END IF;
      App_Context_SYS.Set_Value('CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_', invalid_calendar_info_);
   END IF;
END Set_Invalid_Calendar_Info___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Apply_Cust_Calendar_To_Date_
--   Returns the closest working day for the calendar sent as inparameter. If the customer is internal, the site distribution calendar is used.
FUNCTION Apply_Cust_Calendar_To_Date_ (
   customer_no_           IN VARCHAR2,
   cust_calendar_id_      IN VARCHAR2,
   date_                  IN DATE ) RETURN DATE
IS
   calendar_to_use_       VARCHAR2(10);
   return_date_           DATE;
BEGIN


   IF (date_ IS NULL) THEN
      RETURN date_;
   END IF;

   IF (Cust_Ord_Customer_Category_API.Encode(Cust_Ord_Customer_API.Get_Category(customer_no_)) = 'I') THEN
      calendar_to_use_ := Site_API.Get_Dist_Calendar_Id(Cust_Ord_Customer_API.Get_Acquisition_Site(customer_no_));
   ELSE
      calendar_to_use_ := cust_calendar_id_;
   END IF;

   IF (calendar_to_use_ IS NOT NULL) THEN
      return_date_ := Work_Time_Calendar_API.Get_Closest_Work_Day(calendar_to_use_, date_);
   ELSE
      return_date_ := date_;
   END IF;

   IF (return_date_ IS NULL) THEN
      Error_Date_Not_In_Calendar___(cust_calendar_id_, date_, 0);
   END IF;

   RETURN return_date_;

END Apply_Cust_Calendar_To_Date_;


-- Check_Date_On_Cust_Calendar_
--   Checks if the date is a working day on the customer calendar sent as inparameter. If not a workingday a info message
--   is added to Client_Sys info. The info message specifies if the date is the wanted delivery date or the planned delivery
--   date depending on the date_type_. If the customer is internal, the site distribution calendar is used.
PROCEDURE Check_Date_On_Cust_Calendar_ (
   customer_no_            IN VARCHAR2,
   cust_calendar_id_       IN VARCHAR2,
   date_                   IN DATE,
   date_type_              IN VARCHAR2 )
IS
   working_day_     DATE;
BEGIN
   
   IF (date_ IS NOT NULL) THEN
      working_day_ :=  Apply_Cust_Calendar_To_Date_(customer_no_, cust_calendar_id_, date_);
      IF (TRUNC(date_) != TRUNC(working_day_)) THEN
         IF (date_type_ = 'WANTED') THEN
            Client_SYS.Add_Info(lu_name_,'WANTEDDELIVERYNOTONWORKDAYCUST: Wanted Delivery Date is not on a working day according to the customer calendar, the next working day is on :P1.', working_day_);
         ELSIF (date_type_ = 'PLANNED') THEN
            Client_SYS.Add_Info(lu_name_,'PLANNEDDELIVERYNOTONWORKDAYCUST: Planned Delivery Date is not on a working day according to the customer calendar, the next working day is on :P1.', working_day_);
         END IF;
      END IF;
   END IF;
END Check_Date_On_Cust_Calendar_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Calc_Order_Dates_Backwards
--   Calculates planned delivery date, planned ship date and planned due date
--   for a customer order line - "backwards" from delivery date.
--   Planned delivery date and/or wanted delivery date needs to have a value.
PROCEDURE Calc_Order_Dates_Backwards (
   planned_delivery_date_        IN OUT DATE,
   planned_ship_date_            IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   target_date_                  IN     DATE,
   date_entered_                 IN     DATE,
   order_no_                     IN     VARCHAR2,
   customer_no_                  IN     VARCHAR2,
   addr_no_                      IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supplier_ship_via_transit_    IN     VARCHAR2,
   supply_site_reserve_type_     IN     VARCHAR2,
   route_id_                     IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   conv_factor_                  IN     NUMBER,
   inverted_conv_factor_         IN     NUMBER,
   ctp_planned_db_               IN     VARCHAR2,
   new_demand_qty_               IN     NUMBER,
   old_demand_qty_               IN     NUMBER,
   objid_                        IN     VARCHAR2,
   old_supply_code_db_           IN     VARCHAR2,
   old_due_date_                 IN     DATE,
   check_only_                   IN     BOOLEAN,
   old_part_ownership_db_        IN     VARCHAR2,
   part_ownership_db_            IN     VARCHAR2,
   release_planning_             IN     VARCHAR2 DEFAULT 'RELEASED',
   demand_ref_                   IN     VARCHAR2 DEFAULT NULL,
   demand_code_                  IN     VARCHAR2 DEFAULT NULL,
   new_mrp_demand_qty_           IN     NUMBER DEFAULT NULL,
   old_mrp_demand_qty_           IN     NUMBER DEFAULT NULL,
   catalog_type_                 IN     VARCHAR2 DEFAULT NULL,
   use_current_date_             IN     VARCHAR2 DEFAULT 'FALSE',
   fully_reserved_               IN     NUMBER DEFAULT 0,
   col_objstate_                 IN     VARCHAR2 DEFAULT NULL,
   supply_site_part_no_          IN     VARCHAR2 DEFAULT NULL,
   abnormal_demand_new_          IN     VARCHAR2 DEFAULT NULL,
   abnormal_demand_old_          IN     VARCHAR2 DEFAULT NULL )
IS
   order_id_  VARCHAR2(3) := Customer_Order_API.Get_Order_Id(order_no_);
   objstate_  VARCHAR2(20) := Customer_Order_API.Get_Objstate(order_no_);
BEGIN
   Calc_Order_Dates___(planned_delivery_date_, planned_ship_date_, planned_due_date_,
      supply_site_due_date_, target_date_, date_entered_, customer_no_, addr_no_,
      vendor_no_, ship_via_code_, default_delivery_leadtime_, default_picking_leadtime_, default_ext_transport_cal_id_, supplier_ship_via_transit_,
      supply_site_reserve_type_, route_id_, supply_code_db_, contract_, part_no_,
      supplier_part_no_, 'ORDER', check_only_,  old_part_ownership_db_, part_ownership_db_, order_id_, configuration_id_, conv_factor_, 
      inverted_conv_factor_, ctp_planned_db_, new_demand_qty_, old_demand_qty_, objid_, old_supply_code_db_, objstate_, old_due_date_, 
      release_planning_, demand_ref_, demand_code_, new_mrp_demand_qty_, old_mrp_demand_qty_, catalog_type_, use_current_date_, fully_reserved_, col_objstate_, supply_site_part_no_, abnormal_demand_new_, abnormal_demand_old_);
END Calc_Order_Dates_Backwards;


-- Calc_Order_Dates_Forwards
--   Calculates planned delivery date, planned ship date forwards from the
--   planned due date at the demand site.
--   Also calculates the manufacturing start date (for SO and DOP) or
--   supply_site_due_date_ (for the other supply codes)
PROCEDURE Calc_Order_Dates_Forwards (
   planned_delivery_date_        IN OUT DATE,
   planned_ship_date_            IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   target_date_                  IN     DATE,
   contract_                     IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   customer_no_                  IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   route_id_                     IN     VARCHAR2,
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supplier_ship_via_transit_    IN     VARCHAR2 )
IS
   vendor_addr_no_             SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE := NULL;
   vendor_contract_            VARCHAR2(5) := NULL;
   vendor_category_            VARCHAR2(20) := NULL;
   dist_calendar_              VARCHAR2(10);
   supp_calendar_              VARCHAR2(10);
   new_due_date_               DATE;
   delivery_leadtime_          NUMBER;
   vendor_delivery_leadtime_   NUMBER;
   internal_delivery_leadtime_ NUMBER;
   picking_leadtime_           NUMBER;
   internal_control_time_      NUMBER;
   vendor_manuf_leadtime_      NUMBER;
   vendor_leadtime_            NUMBER;
   expected_leadtime_          NUMBER;
   addr_flag_db_               VARCHAR2(1) := 'N';
   min_date_                   DATE;
   ext_transport_calendar_id_  CUSTOMER_ORDER_LINE_TAB.ext_transport_calendar_id%TYPE;
   supplier_calendar_id_       VARCHAR2(10);
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);
   
BEGIN
   
   Get_Supplier_Info___(vendor_addr_no_, vendor_contract_, vendor_category_, supplier_calendar_id_, vendor_no_, supply_code_db_);

   dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);

   -- The planned_due_date passed in for SO, and DOP orders is assumed to be the finish date
   -- for the order, the goods will not be available to pick until the next working day.
   --
   -- Note! Don't use Calc_Due_Date_Forwards___ here because we've already got a valid due date from CBS!!
   --

   IF (supply_code_db_ IN ('SO', 'DOP')) THEN
      -- Shop Order and DOP will communicate the date when the supply is available. Just make sure it's a work day
      planned_due_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(dist_calendar_, planned_due_date_);
   ELSIF (Work_Time_Calendar_API.Is_Working_Day(dist_calendar_, planned_due_date_) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_WORKING_DAY: :P1 is not a working day!', to_char(planned_due_date_, 'YYYY-MM-DD'));
   END IF;

   Cust_Order_Leadtime_Util_API.Get_Default_Leadtimes(delivery_leadtime_, vendor_delivery_leadtime_, internal_delivery_leadtime_, picking_leadtime_,
                                                      internal_control_time_, vendor_manuf_leadtime_, vendor_leadtime_, expected_leadtime_,
                                                      transport_leadtime_, arrival_route_id_, contract_,
                                                      customer_no_, ship_addr_no_, addr_flag_db_, part_no_, supplier_part_no_, supply_code_db_, vendor_no_,
                                                      ship_via_code_, supplier_ship_via_transit_);

   -- If a delivery leadtime was passed in this should override the default value retrieved from the supply chain matrixes, 
   -- also the external transport calendar default should be used in this case.
   IF (default_delivery_leadtime_ IS NOT NULL) THEN
      delivery_leadtime_ := default_delivery_leadtime_;   
      ext_transport_calendar_id_ := default_ext_transport_cal_id_;
   ELSE
      -- Use the ext transport calendar for the ship via code
      ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(ship_via_code_);
   END IF;

   -- If a picking leadtime was passed in this should override the default value retrieved from the supply chain matrixes. 
   IF (default_picking_leadtime_ IS NOT NULL) THEN
      picking_leadtime_ := default_picking_leadtime_;
   END IF;

   -- start calculating forwards from planned due date to get a ship date...
   -- (planned due date might change if route's involved!)
   Calc_Ship_Date_Forwards___(planned_ship_date_, planned_due_date_, picking_leadtime_,
      route_id_, supply_code_db_, contract_, part_no_);
   
   Calc_Del_Date_Forwards___(planned_delivery_date_, planned_ship_date_, target_date_,
      delivery_leadtime_, ext_transport_calendar_id_, supply_code_db_, ship_via_code_);
      
   -- finally calculate backwards from planned due date to get a suppply site due date...
   Calc_Supply_Due_Date_Back___(new_due_date_, planned_due_date_, contract_, supply_code_db_, vendor_contract_,
      supplier_part_no_, internal_control_time_, vendor_delivery_leadtime_, internal_delivery_leadtime_,
      vendor_manuf_leadtime_, vendor_leadtime_, supplier_ship_via_transit_, vendor_no_, supplier_calendar_id_,
      transport_leadtime_, arrival_route_id_);

   Trace_SYS.Field('"due date"', new_due_date_);
   
   -- Adding to the planned due date the time set on delivery route
   planned_due_date_ := Delivery_Route_API.Get_Due_Date_With_Time(route_id_, planned_ship_date_, planned_due_date_, contract_);  

   IF (supply_code_db_ IN ('IPD', 'IPT')) THEN
      -- Note: For the internal supplier within the currect database
      supp_calendar_ := Site_API.Get_Dist_Calendar_Id(vendor_contract_);
      IF (supp_calendar_ IS NOT NULL) THEN
         min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(supp_calendar_);
         Trace_SYS.Field('min date for calendar ' || supp_calendar_, min_date_);
         IF ((new_due_date_ IS NULL) OR (new_due_date_ < min_date_)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALDUEDATESUPP: The due date is not within the supplier calendar.');
         END IF;
      END IF;
   ELSIF (supply_code_db_ NOT IN ('PT', 'PD')) THEN
      min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(dist_calendar_);
      Trace_SYS.Field('min date for calendar ' || dist_calendar_, min_date_);
      IF ((new_due_date_ IS NULL) OR (new_due_date_ < min_date_)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALDUEDATE: The due date is not within current calendar.');
      END IF;
   END IF;

   supply_site_due_date_ := NULL;

   IF (supply_code_db_ IN ('IPT', 'IPD')) THEN
      -- check if the part is an inventory part at supply site
      IF Inventory_Part_API.Check_Exist(vendor_contract_, supplier_part_no_) THEN
         supply_site_due_date_ := new_due_date_;
      END IF;
   END IF;   
END Calc_Order_Dates_Forwards;


-- Calc_Quotation_Dates
--   Calculates planned delivery date, planned ship date and planned due date
--   for a quotation line - "backwards" from delivery date.
--   Planned delivery date and/or wanted delivery date needs to have a value.
PROCEDURE Calc_Quotation_Dates (
   planned_delivery_date_        IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   wanted_delivery_date_         IN     DATE,
   date_entered_                 IN     DATE,
   customer_no_                  IN     VARCHAR2,
   addr_no_                      IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2 )
IS
   planned_ship_date_          DATE;   -- not used for quotations
   supplier_ship_via_transit_  VARCHAR2(3);
BEGIN

   supplier_ship_via_transit_ := Cust_Order_Leadtime_Util_API.Get_Supplier_Ship_Via(contract_, part_no_, supply_code_db_, vendor_no_);
   -- Quotations don't use neither route nor supply site reservation
   Calc_Order_Dates___(planned_delivery_date_, planned_ship_date_, planned_due_date_,
      supply_site_due_date_, wanted_delivery_date_, date_entered_, customer_no_, addr_no_,
      vendor_no_, ship_via_code_, default_delivery_leadtime_, default_picking_leadtime_, default_ext_transport_cal_id_, supplier_ship_via_transit_, NULL, NULL,
      supply_code_db_, contract_, part_no_, supplier_part_no_, 'QUOTATION', TRUE, 'COMPANY OWNED', 'COMPANY OWNED',
      NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'RELEASED', NULL, NULL, NULL, NULL, NULL, 'FALSE', 0, NULL, NULL, NULL, NULL );

END Calc_Quotation_Dates;


PROCEDURE Calc_Disord_Dates_Backwards (
   planned_delivery_date_        IN OUT DATE,
   planned_ship_date_            IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   wanted_delivery_date_         IN     DATE,
   date_entered_                 IN     DATE,
   addr_no_                      IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   route_id_                     IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   order_id_                     IN     VARCHAR2,
   configuration_id_             IN     VARCHAR2,
   new_demand_qty_               IN     NUMBER,
   old_demand_qty_               IN     NUMBER,
   def_delivery_leadtime_        IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   inv_conv_factor_              IN     NUMBER,
   inv_inverted_conv_factor_     IN     NUMBER,
   ctp_planned_db_               IN     VARCHAR2,
   check_only_                   IN     BOOLEAN,
   old_due_date_                 IN     DATE,
   customer_no_                  IN     VARCHAR2,
   objid_                        IN     VARCHAR2 DEFAULT NULL )
IS
   supply_site_due_date_ DATE;  -- not used by Dist Order   
BEGIN
   
   -- Dist Orders don't use neither supplier, supplier ship via, supply site reserve type,
   -- supplier part no nor CO objstate
   Calc_Order_Dates___(planned_delivery_date_, planned_ship_date_, planned_due_date_,
      supply_site_due_date_, wanted_delivery_date_, date_entered_, customer_no_, addr_no_,
      NULL, ship_via_code_, def_delivery_leadtime_, default_picking_leadtime_, default_ext_transport_cal_id_, NULL, NULL, route_id_, supply_code_db_,
      contract_, part_no_, NULL, 'DISTORDER', check_only_, 'COMPANY OWNED', 'COMPANY OWNED', order_id_, configuration_id_, inv_conv_factor_, inv_inverted_conv_factor_,
      ctp_planned_db_, new_demand_qty_, old_demand_qty_, objid_, NULL, NULL, old_due_date_, 'RELEASED', NULL, NULL, NULL, NULL, NULL, 'FALSE', 0, NULL, NULL,NULL, NULL);
END Calc_Disord_Dates_Backwards;


PROCEDURE Calc_Disord_Dates_Forwards (
   planned_delivery_date_        IN OUT DATE,
   planned_ship_date_            IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   wanted_delivery_date_         IN     DATE,
   contract_                     IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   customer_no_                  IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   route_id_                     IN     VARCHAR2,
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supplier_ship_via_transit_    IN     VARCHAR2 )
IS
   vendor_addr_no_             SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE := NULL;
   vendor_contract_            VARCHAR2(5) := NULL;
   vendor_category_            VARCHAR2(20) := NULL;
   dist_calendar_              VARCHAR2(10);
   supp_calendar_              VARCHAR2(10);
   supply_site_due_date_       DATE; -- not used by Disord
   delivery_leadtime_          NUMBER;
   vendor_delivery_leadtime_   NUMBER;
   internal_delivery_leadtime_ NUMBER;
   picking_leadtime_           NUMBER;
   internal_control_time_      NUMBER;
   vendor_manuf_leadtime_      NUMBER;
   vendor_leadtime_            NUMBER;
   expected_leadtime_          NUMBER;
   addr_flag_db_               VARCHAR2(1) := 'N';
   min_date_                   DATE;
   ext_transport_calendar_id_  CUSTOMER_ORDER_LINE_TAB.ext_transport_calendar_id%TYPE;
   supplier_calendar_id_       VARCHAR2(10);
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);
   
BEGIN

   Get_Supplier_Info___(vendor_addr_no_, vendor_contract_, vendor_category_, supplier_calendar_id_, vendor_no_, supply_code_db_);

   dist_calendar_ := Site_API.Get_Dist_Calendar_Id(contract_);

   IF (Work_Time_Calendar_API.Is_Working_Day(dist_calendar_, planned_due_date_) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_WORKING_DAY: :P1 is not a working day!', to_char(planned_due_date_, 'YYYY-MM-DD'));
   END IF;

   Cust_Order_Leadtime_Util_API.Get_Default_Leadtimes(delivery_leadtime_, vendor_delivery_leadtime_, internal_delivery_leadtime_, picking_leadtime_,
                                                      internal_control_time_, vendor_manuf_leadtime_, vendor_leadtime_, expected_leadtime_,
                                                      transport_leadtime_, arrival_route_id_, contract_,
                                                      customer_no_, ship_addr_no_, addr_flag_db_, part_no_, supplier_part_no_, supply_code_db_, vendor_no_,
                                                      ship_via_code_, supplier_ship_via_transit_);

   -- If a delivery leadtime was passed in this should override the default value retrieved from the supply chain matrixes, 
   -- also the external transport calendar default should be used in this case.
   IF (default_delivery_leadtime_ IS NOT NULL) THEN
      delivery_leadtime_ := default_delivery_leadtime_;
      ext_transport_calendar_id_ := default_ext_transport_cal_id_;
   ELSE
      -- Use the ext transport calendar for the ship via code
      ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(ship_via_code_);
   END IF;

   -- If a picking leadtime was passed in this should override the default value retrieved from the supply chain matrixes. 
   IF (default_picking_leadtime_ IS NOT NULL) THEN
      picking_leadtime_ := default_picking_leadtime_;
   END IF;

   -- The planned_due_date passed in for SO and DOP orders is assumed to be the "finish date"
   -- for the order, the goods will not be available to pick until the next working day.
   --
   -- Note! Don't use Calc_Due_Date_Forwards___ here because we've already got a valid due date from CBS!!
   --
   IF (supply_code_db_ IN ('SO', 'DOP')) THEN
      -- add an extra work day for Shop Orders and DOP Orders
      planned_due_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(dist_calendar_, planned_due_date_);
   END IF;

   -- start calculating forwards from planned due date to get a ship date...
   -- (planned due date might change if route's involved!)
   Calc_Ship_Date_Forwards___(planned_ship_date_, planned_due_date_, picking_leadtime_,
      route_id_, supply_code_db_, contract_, part_no_);

   -- ... and a delivery date.
   Calc_Del_Date_Forwards___(planned_delivery_date_, planned_ship_date_, wanted_delivery_date_,
      delivery_leadtime_, ext_transport_calendar_id_, supply_code_db_, ship_via_code_);

   -- finally calculate backwards from planned due date to get a suppply site due date...
   Calc_Supply_Due_Date_Back___(supply_site_due_date_, planned_due_date_, contract_, supply_code_db_, vendor_contract_,
      supplier_part_no_, internal_control_time_, vendor_delivery_leadtime_, internal_delivery_leadtime_,
      vendor_manuf_leadtime_, vendor_leadtime_, supplier_ship_via_transit_, vendor_no_, supplier_calendar_id_, transport_leadtime_, arrival_route_id_);

   Trace_SYS.Field('"due date"', supply_site_due_date_);

   IF (supply_code_db_ IN ('IPD', 'IPT')) THEN
      -- Note: For the internal supplier within the currect database
      supp_calendar_ := Site_API.Get_Dist_Calendar_Id(vendor_contract_);
      IF (supp_calendar_ IS NOT NULL) THEN
         min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(supp_calendar_);
         Trace_SYS.Field('min date for calendar ' || supp_calendar_, min_date_);
         IF ((supply_site_due_date_ IS NULL) OR (supply_site_due_date_ < min_date_)) THEN
            Error_SYS.Record_General(lu_name_, 'INVALDUEDATESUPP: The due date is not within the supplier calendar.');
         END IF;
      END IF;
   ELSIF (supply_code_db_ NOT IN ('PT', 'PD')) THEN
      min_date_ := Work_Time_Calendar_API.Get_Min_Work_Day(dist_calendar_);
      Trace_SYS.Field('min date for calendar ' || dist_calendar_, min_date_);
      IF ((supply_site_due_date_ IS NULL) OR (supply_site_due_date_ < min_date_)) THEN
         Error_SYS.Record_General(lu_name_, 'INVALDUEDATE: The due date is not within current calendar.');
      END IF;
   END IF;
END Calc_Disord_Dates_Forwards;


-- Calc_Sourcing_Dates
--   Calculates planned delivery date for a sourcing line - "forwards" from
--   due date (planned due date needs to have a value) or "backwards" from
--   delivery date (delivery date needs to have a value) depending on the
--   "forward" parameter value.
PROCEDURE Calc_Sourcing_Dates (
   planned_delivery_date_        IN OUT DATE,
   planned_ship_date_            IN OUT DATE,
   planned_due_date_             IN OUT DATE,
   supply_site_due_date_         IN OUT DATE,
   picking_leadtime_             IN OUT NUMBER,
   wanted_delivery_date_         IN     DATE,
   customer_no_                  IN     VARCHAR2,
   addr_no_                      IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   ship_via_code_                IN     VARCHAR2,   
   default_delivery_leadtime_    IN     NUMBER,
   default_picking_leadtime_     IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   supplier_ship_via_transit_    IN     VARCHAR2,
   route_id_                     IN     VARCHAR2,
   supply_code_db_               IN     VARCHAR2,
   contract_                     IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supplier_part_no_             IN     VARCHAR2,
   forward_                      IN     BOOLEAN )
IS
BEGIN

   Calc_Sourcing_Dates___(planned_delivery_date_, planned_ship_date_, planned_due_date_,
      supply_site_due_date_, picking_leadtime_, wanted_delivery_date_, customer_no_, addr_no_, addr_flag_db_,
      vendor_no_, ship_via_code_, default_delivery_leadtime_, default_picking_leadtime_, default_ext_transport_cal_id_, supplier_ship_via_transit_,
      route_id_, supply_code_db_, contract_, part_no_, supplier_part_no_, forward_);

END Calc_Sourcing_Dates;


-- Perform_Capability_Check
--   Starts the Capability Check engine and then save the new planned
--   due date and latest release date on the Customer Order Line or Sales
--   Quotation Line and sets the ctp_planned flag to 'Y'
PROCEDURE Perform_Capability_Check (
   cc_engine_error_msg_         OUT VARCHAR2,
   info_                        OUT VARCHAR2,
   ctp_run_id_                  OUT NUMBER,
   planned_due_date_            IN OUT DATE,
   supply_site_due_date_        IN OUT DATE,
   planned_delivery_date_       IN OUT DATE,
   interim_header_id_           IN  VARCHAR2,
   contract_                    IN  VARCHAR2,
   part_no_                     IN  VARCHAR2,
   configuration_id_            IN  VARCHAR2,
   due_date_                    IN  DATE,
   org_planned_due_date_        IN  DATE,
   qty_required_                IN  NUMBER,
   int_demand_usage_type_       IN  VARCHAR2,
   identity1_                   IN  VARCHAR2,
   identity2_                   IN  VARCHAR2,
   identity3_                   IN  VARCHAR2,
   identity4_                   IN  VARCHAR2,
   customer_no_                 IN  VARCHAR2,    
   allocate_db_                 IN  VARCHAR2,
   supply_code_db_              IN  VARCHAR2,
   supply_site_supply_code_db_  IN  VARCHAR2,
   supply_site_                 IN  VARCHAR2,
   objid_                       IN  VARCHAR2,
   objversion_                  IN  VARCHAR2 )
IS
   interim_id_                 VARCHAR2(12);
   customer_name_              VARCHAR2(200);
   completion_date_            DATE;
   latest_release_date_        DATE;
   error_msg_                  VARCHAR2(500) := NULL;
   hist_msg_                   VARCHAR2(80) := NULL;
   temp_supply_site_due_date_  DATE;
   delivery_leadtime_          NUMBER;                                                       -- only a dummy variable in this method
   vendor_delivery_leadtime_   NUMBER;
   internal_delivery_leadtime_ NUMBER;
   picking_leadtime_           NUMBER;          -- only a dummy variable in this method
   internal_control_time_      NUMBER;
   vendor_manuf_leadtime_      NUMBER;
   vendor_leadtime_            NUMBER;
   expected_leadtime_          NUMBER;
   addr_flag_db_               VARCHAR2(1) := 'N';
   purchase_part_no_           VARCHAR2(25) := part_no_;  -- CC do not work with non-inventory parts
   ship_addr_no_               CUSTOMER_ORDER_LINE_TAB.ship_addr_no%TYPE;
   vendor_no_                  CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE;
   ship_via_code_              VARCHAR2(3);
   supplier_ship_via_transit_  VARCHAR2(3);
   temp_planned_due_date_      DATE;
   ordrec_                     CUSTOMER_ORDER_LINE_API.Public_Rec;
   newrec_                     CUSTOMER_ORDER_LINE_API.Public_Rec;
   quotrec_                    ORDER_QUOTATION_LINE_API.Public_Rec;
   cc_supply_code_db_          VARCHAR2(3);  -- the supply code sent to the CC engine
   dummy_info_                 VARCHAR2(2000);
   cc_reset_flag_              VARCHAR2(1);  -- reset flag which tells if the cc-flag/latest_release_date needs reseting when receiving an error and there may exist old cc-data from an earlier try
   info_msg_                   VARCHAR2(2000);
   conv_qty_required_          NUMBER;
   temp_info_                  VARCHAR2(2000);
   ctp_planned_db_             VARCHAR2(1);
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);
BEGIN

   -- some extra checks on allocate_db_, needed if the user have manually entered the allocate flag in the dialog
   IF ((supply_site_ IS NOT NULL OR supply_code_db_ = 'IO') AND allocate_db_ != 'NEITHER RESERVE NOR ALLOCATE') THEN
      -- neither is the only valid allocate value for IPT/IPD/IO
      Error_SYS.Record_General(lu_name_, 'INVALIDALLOC1: ":P1" is the only valid allocate value for supply code :P2.',
                               Capability_Check_Allocate_API.Decode('NEITHER RESERVE NOR ALLOCATE'),
                               Order_Supply_Type_API.Decode(supply_code_db_));
   ELSIF (allocate_db_ NOT IN ('RESERVE AND ALLOCATE', 'ALLOCATE ONLY', 'NEITHER RESERVE NOR ALLOCATE') OR allocate_db_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDALLOC3: Invalid allocate value.');
   END IF;
   IF (int_demand_usage_type_ = 'CUSTOMERORDER') THEN
      -- check if there are any reservations (demand or supply site) on this customer order
      IF (NVL(Customer_Order_Line_API.Get_Qty_Assigned(identity1_, identity2_, identity3_, identity4_),0) > 0) OR
         (Co_Supply_Site_Reservation_API.Get_Qty_Reserved(identity1_, identity2_, identity3_, identity4_) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'RESERVEXISTSCC: Since reservations have been made, the Capability Check cannot start.');
      END IF;
   END IF;

   -- lock the order/quotation line that will be capability checked, this also ensure us that the objversion 
   -- is still the same as when we started the CC-dialog window
   IF (int_demand_usage_type_ = 'CUSTOMERORDER') THEN
      Customer_Order_Line_API.Lock_By_Id(objid_, objversion_);
   ELSE
      Order_Quotation_Line_API.Lock__(dummy_info_, objid_, objversion_);
   END IF;

   IF (supply_code_db_ = 'IO') THEN
      -- if Inventory Order send DOP as supply code to the CC engine
      cc_supply_code_db_ := 'DOP';
   ELSIF (supply_site_supply_code_db_ = 'IO') THEN
      -- if Inventory Order send DOP as supply code to the CC engine
      cc_supply_code_db_ := 'DOP';
   ELSE
      -- use the supply site supply code (taken from sourcing option) if it is a supply site line
      cc_supply_code_db_ := NVL(supply_site_supply_code_db_, supply_code_db_);
   END IF;

   $IF (Component_Ordstr_SYS.INSTALLED) $THEN
      interim_id_ := interim_header_id_;
      customer_name_ := Cust_Ord_Customer_API.Get_Name(customer_no_);

      IF (supply_site_ IS NOT NULL) THEN
         -- convert the qty from demand site inv uom to supply site inv oum
         conv_qty_required_ := Inventory_Part_API.Get_Site_Converted_Qty(contract_, part_no_, qty_required_, supply_site_, 'ADD');
      ELSE
         conv_qty_required_ := qty_required_;
      END IF;

      Trace_SYS.Field('CC>> original planned_due_date  ', org_planned_due_date_);
      Trace_SYS.Field('CC>> planned_due_date or supply_site_due_date sent to the CC engine ', due_date_);

      Interim_Ctp_Manager_API.Calculate_Ctp(cc_reset_flag_,
                                            completion_date_,
                                            latest_release_date_,
                                            error_msg_,
                                            info_msg_,                                            
                                            interim_id_,
                                            NVL(supply_site_, contract_),
                                            part_no_,
                                            configuration_id_,
                                            due_date_,
                                            conv_qty_required_,
                                            int_demand_usage_type_,
                                            identity1_,
                                            identity2_,
                                            identity3_,
                                            identity4_,
                                            customer_no_,
                                            customer_name_,
                                            allocate_db_,
                                            cc_supply_code_db_,
                                            is_auto_cc_ => FALSE);

      Trace_SYS.Field('CC>> completion_date_ (planned_due_date/supply_site_due_date received from CC engine)', completion_date_);

      IF (error_msg_ IS NULL) THEN
         IF (supply_site_ IS NULL) THEN -- this was a capability check performed on demand site
            temp_planned_due_date_ := completion_date_;
         ELSE -- this was a capability check performed on supply site
            temp_supply_site_due_date_ := Work_Time_Calendar_API.Get_Next_Work_Day(Site_API.Get_Dist_Calendar_Id(supply_site_), completion_date_);
            Trace_SYS.Field('CC>> supply_site_due_date including next work day ', temp_supply_site_due_date_);

            -- fetching some extra customer order line or sales quotation line values so we get the default leadtime values
            IF (int_demand_usage_type_ = 'CUSTOMERORDER') THEN  -- customer order
               ordrec_                    := Customer_Order_Line_API.Get(identity1_, identity2_, identity3_, identity4_);
               ship_addr_no_              := ordrec_.ship_addr_no;
               addr_flag_db_              := ordrec_.addr_flag;
               vendor_no_                 := ordrec_.vendor_no;
               ship_via_code_             := ordrec_.ship_via_code;
               supplier_ship_via_transit_ := ordrec_.supplier_ship_via_transit;

            ELSE  -- sales quotation
               quotrec_                   := Order_Quotation_Line_API.Get(identity1_, identity2_, identity3_, identity4_);
               ship_addr_no_              := quotrec_.ship_addr_no;
               vendor_no_                 := quotrec_.vendor_no;
               ship_via_code_             := quotrec_.ship_via_code;
               supplier_ship_via_transit_ := Cust_Order_Leadtime_Util_API.Get_Supplier_Ship_Via(contract_, part_no_, supply_code_db_, vendor_no_);
            END IF;

            IF (completion_date_ != due_date_) THEN
               -- fetching some default leadtimes values that we can use in the planned_due_date calculation
               Cust_Order_Leadtime_Util_API.Get_Default_Leadtimes(delivery_leadtime_, vendor_delivery_leadtime_, internal_delivery_leadtime_,
                                                                  picking_leadtime_, internal_control_time_, vendor_manuf_leadtime_,
                                                                  vendor_leadtime_, expected_leadtime_, transport_leadtime_, arrival_route_id_,
                                                                  contract_, customer_no_, ship_addr_no_, addr_flag_db_, part_no_,
                                                                  purchase_part_no_, supply_code_db_, vendor_no_, ship_via_code_,
                                                                  supplier_ship_via_transit_);

               -- count forwards from supply_site_due_date to planned_due_date
               Calc_Due_Date_Forwards___(temp_planned_due_date_, temp_supply_site_due_date_,
                                         contract_, internal_control_time_, vendor_delivery_leadtime_,
                                         internal_delivery_leadtime_, vendor_manuf_leadtime_, vendor_leadtime_,
                                         expected_leadtime_, supply_code_db_, vendor_no_, supply_site_, part_no_,
                                         supplier_ship_via_transit_, transport_leadtime_, arrival_route_id_);
            ELSE
               temp_planned_due_date_ := org_planned_due_date_;
            END IF;
            Trace_SYS.Field('CC>> planned_due_date (calculated from supply_site_due_date) ', temp_planned_due_date_);
         END IF;

         IF (int_demand_usage_type_ = 'CUSTOMERORDER') THEN  -- customer order
            Customer_Order_Line_API.Update_Planning_Date(identity1_, identity2_, identity3_, identity4_, temp_planned_due_date_, hist_msg_, latest_release_date_, allocate_db_);            
         ELSE  -- sales quotation
            Order_Quotation_Line_API.Update_Planning_Date(identity1_, identity2_, identity3_, identity4_, temp_planned_due_date_, hist_msg_, latest_release_date_, allocate_db_);
         END IF;
         temp_info_ := Client_SYS.Get_All_Info;
         IF (interim_id_ IS NOT NULL AND  allocate_db_ != 'NEITHER RESERVE NOR ALLOCATE') THEN
            Order_Config_Util_API.Evaluate_Usage_For_Cost__ (int_demand_usage_type_, identity1_, identity2_, identity3_, identity4_,
                                                             contract_, part_no_, qty_required_, due_date_);
         END IF;
         IF (App_Context_SYS.Find_Number_Value('CTP_RUN_ID') IS NOT NULL) THEN
            ctp_run_id_ := App_Context_SYS.Get_Number_Value('CTP_RUN_ID');
         END IF;
     ELSE
         Trace_SYS.Message('Capability check was performed but got the following error >> ' || error_msg_);
         IF (cc_reset_flag_ = 'Y') THEN  -- clear the cc flag/latest_release_date       
            IF (int_demand_usage_type_ = 'CUSTOMERORDER') THEN  -- customer order
               Customer_Order_Line_API.Clear_Ctp_Planned(identity1_, identity2_, identity3_, identity4_);
            ELSE
               Order_Quotation_Line_API.Clear_Ctp_Planned(identity1_, identity2_, identity3_, identity4_);
            END IF;
         ELSIF (int_demand_usage_type_ = 'CUSTOMERORDER') AND (cc_reset_flag_ = 'N') THEN
            ctp_planned_db_ := Gen_Yes_No_API.Encode(Customer_Order_Line_API.Get_Ctp_Planned(identity1_, identity2_, identity3_, identity4_));
            IF ctp_planned_db_ = 'N' THEN
               Customer_Order_Line_API.Set_Ctp_Planned(identity1_, identity2_, identity3_, identity4_);
            END IF;
         END IF;
      END IF;
      IF (int_demand_usage_type_ = 'CUSTOMERORDER') THEN  -- customer order
         planned_due_date_       := Customer_Order_Line_API.Get_Planned_Due_Date(identity1_, identity2_, identity3_, identity4_);
         supply_site_due_date_   := Customer_Order_Line_API.Get_Supply_Site_Due_Date(identity1_, identity2_, identity3_, identity4_);
         planned_delivery_date_  := Customer_Order_Line_API.Get_Planned_Delivery_Date(identity1_, identity2_, identity3_, identity4_);
      ELSE
         planned_due_date_       := Order_Quotation_Line_API.Get_Planned_Due_Date(identity1_, identity2_, identity3_, identity4_);
         supply_site_due_date_   := NULL;
         planned_delivery_date_  := Order_Quotation_Line_API.Get_Planned_Delivery_Date(identity1_, identity2_, identity3_, identity4_);
      END IF;
   $END

   IF (info_msg_ IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, 'CC_INFO: :P1', info_msg_);
   END IF;

   info_ := Client_SYS.Get_All_Info;
   info_ := temp_info_||info_;   
   cc_engine_error_msg_ := substr(error_msg_, 1, 500);
END Perform_Capability_Check;


-- Calc_Due_Date_Forwards
--   Initializes the planned due date for forward date calculation.
--   Passed is a start date (e.g. sysdate), and returned is an adjusted due date.
PROCEDURE Calc_Due_Date_Forwards (
   planned_due_date_           IN OUT DATE,
   supply_site_due_date_       IN OUT DATE,
   contract_                   IN     VARCHAR2,
   internal_control_time_      IN     NUMBER,
   vendor_delivery_leadtime_   IN     NUMBER,
   internal_delivery_leadtime_ IN     NUMBER,
   vendor_manuf_leadtime_      IN     NUMBER,
   vendor_leadtime_            IN     NUMBER,
   expected_leadtime_          IN     NUMBER,
   supply_code_db_             IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   vendor_contract_            IN     VARCHAR2,
   supplier_part_no_           IN     VARCHAR2,
   supplier_ship_via_transit_  IN     VARCHAR2,
   transport_leadtime_         IN     NUMBER,
   arrival_route_id_           IN     VARCHAR2 )
IS
BEGIN
   Calc_Due_Date_Forwards___(planned_due_date_, supply_site_due_date_,
                             contract_, internal_control_time_,
                             vendor_delivery_leadtime_, internal_delivery_leadtime_,
                             vendor_manuf_leadtime_, vendor_leadtime_,
                             expected_leadtime_, supply_code_db_, vendor_no_,
                             vendor_contract_, supplier_part_no_, supplier_ship_via_transit_,
                             transport_leadtime_, arrival_route_id_);
END Calc_Due_Date_Forwards;


-- Calc_Cust_Sched_Plan_Due_Date
--   Calculates planned delivery date for a customer schedule line when
--   creating forecast demands for the line. There are two cases when order_no
--   is optional that is customer order creation is set to 'Create On Demand'
--   and 'Create In Advance' where the order_no is not null.
--   This method is called from Customer Scheduling.
FUNCTION Calc_Cust_Sched_Plan_Due_Date (
   wanted_delivery_date_ IN DATE,
   catalog_no_           IN VARCHAR2,
   order_no_             IN VARCHAR2,
   customer_no_          IN VARCHAR2,
   ship_addr_no_         IN VARCHAR2,
   contract_             IN VARCHAR2) RETURN DATE
IS
   rec_                       Customer_Order_API.Public_Rec;
   sprec_                     Sales_Part_API.Public_Rec;
   customer_rec_              Cust_Ord_Customer_API.Public_Rec;
   ship_via_code_             VARCHAR2(3);
   currency_code_             VARCHAR2(3);
   agreement_id_              VARCHAR2(10);
   route_id_                  VARCHAR2(12);
   supply_code_db_            VARCHAR2(3);
   planned_due_date_          DATE;
   planned_ship_date_         DATE;
   planned_delivery_date_     DATE;
   supply_site_due_date_      DATE;
   site_date_time_            DATE;
   delivery_leadtime_         NUMBER;
   ext_transport_calendar_id_ CUSTOMER_ORDER_LINE_TAB.ext_transport_calendar_id%TYPE;
   vendor_no_                 CUSTOMER_ORDER_LINE_TAB.vendor_no%TYPE := NULL;
   supplier_ship_via_         VARCHAR2(3);
   sched_contract_            VARCHAR2(5);
   sched_customer_no_         CUSTOMER_ORDER_TAB.customer_no%TYPE;
   sched_ship_addr_no_        CUSTOMER_ORDER_TAB.ship_addr_no%TYPE;
   freight_map_id_            CUSTOMER_ORDER_TAB.freight_map_id%TYPE;
   zone_id_                   CUSTOMER_ORDER_TAB.zone_id%TYPE;
   forward_agent_id_           CUSTOMER_ORDER_TAB.forward_agent_id%TYPE;
   picking_leadtime_           CUSTOMER_ORDER_TAB.picking_leadtime%TYPE;
   shipment_type_              CUSTOMER_ORDER_TAB.shipment_type%TYPE;
   ship_inventory_location_no_ VARCHAR2(35);
   dummy_delivery_terms_       CUSTOMER_ORDER_TAB.delivery_terms%TYPE;
   dummy_del_terms_location_   CUSTOMER_ORDER_TAB.del_terms_location%TYPE;
BEGIN

   IF order_no_ IS NOT NULL THEN
      rec_               := Customer_Order_API.Get(order_no_);

      sched_contract_     := rec_.contract;
      sched_customer_no_  := rec_.customer_no;
      sched_ship_addr_no_ := rec_.ship_addr_no;
      ship_via_code_      := rec_.ship_via_code;
      delivery_leadtime_  := rec_.delivery_leadtime;
      route_id_           := rec_.route_id;
      ext_transport_calendar_id_ := rec_.ext_transport_calendar_id;
      picking_leadtime_   := rec_.picking_leadtime;
      shipment_type_      := rec_.shipment_type;
   ELSE
      sched_contract_     := contract_;
      sched_customer_no_  := customer_no_;
      sched_ship_addr_no_ := ship_addr_no_;
      customer_rec_       := Cust_Ord_Customer_API.Get(sched_customer_no_);
      currency_code_      := customer_rec_.currency_code;
      agreement_id_       := Customer_Agreement_API.Get_First_Valid_Agreement(sched_customer_no_,
                                                                              sched_contract_,
                                                                              currency_code_,
                                                                              trunc(site_date_time_),
                                                                              'FALSE');
      -- Retrive the default value for ship via code and delivery leadtime
      Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(ship_via_code_,
                                                                  dummy_delivery_terms_,
                                                                  dummy_del_terms_location_,
                                                                  freight_map_id_,
                                                                  zone_id_,
                                                                  delivery_leadtime_,
                                                                  ext_transport_calendar_id_,
                                                                  route_id_,
                                                                  forward_agent_id_,
                                                                  picking_leadtime_,
                                                                  shipment_type_,
                                                                  ship_inventory_location_no_,
                                                                  sched_contract_,
                                                                  sched_customer_no_,
                                                                  sched_ship_addr_no_,
                                                                  'N',
                                                                  agreement_id_,
                                                                  NULL); -- Passed NULL for vendor_no
   END IF;

   planned_delivery_date_ := wanted_delivery_date_;

   -- Retrieve the default supply code for the sales part.
   supply_code_db_ := Order_Supply_Type_API.Encode(Sales_Part_API.Get_Default_Supply_Code(sched_contract_, catalog_no_));

   -- date calculation method doesn't handle Automatic Sourcing - use Not Decided in that case...
   IF (supply_code_db_ = 'SRC') THEN
      supply_code_db_ := 'ND';
   END IF;

   sprec_ := Sales_Part_API.Get(sched_contract_, catalog_no_);

   -- fetch default supplier and supplier information
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (supply_code_db_ IN ('PD', 'PT', 'IPD', 'IPT')) THEN
         vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(sched_contract_, nvl(sprec_.part_no, sprec_.purchase_part_no));               
         -- fetch supplier's ship via code for transit delivery
         Customer_Order_Line_API.Get_Def_Supplier_Ship_Via__(supplier_ship_via_,  vendor_no_,
                                                             sched_contract_,     sprec_.part_no,
                                                             supply_code_db_,     Fnd_Boolean_API.DB_FALSE);
      END IF;
   $END
   -- no ATP analysis should be performed - only date calculation...
   Calc_Order_Dates_Backwards(planned_delivery_date_, planned_ship_date_,    planned_due_date_,
                              supply_site_due_date_,  wanted_delivery_date_, SYSDATE,
                              NULL,                   sched_customer_no_,    sched_ship_addr_no_,
                              vendor_no_,             ship_via_code_,         
                              delivery_leadtime_,     picking_leadtime_,     ext_transport_calendar_id_,
                              supplier_ship_via_,     'NOTALLOWED',          route_id_,
                              supply_code_db_,        sched_contract_,       sprec_.part_no,
                              nvl(sprec_.part_no, sprec_.purchase_part_no),  NULL,
                              NULL,                   NULL,                  NULL,                  NULL,
                              NULL,                   NULL,                  NULL, 
                              NULL,                   TRUE,                  'COMPANY OWNED',
                              'COMPANY OWNED');
   RETURN planned_due_date_;
END Calc_Cust_Sched_Plan_Due_Date;


-- Fetch_Calendar_Start_Date
--   Calls Work_Time_Calendar_API.Get_Start_Date, but adds some error checking, and outs the date.
PROCEDURE Fetch_Calendar_Start_Date (
   return_date_   OUT DATE,
   calendar_id_   IN  VARCHAR2,
   date_          IN  DATE,
   duration_      IN  NUMBER )
IS
BEGIN


   IF (date_ IS NULL) THEN
      return_date_ := date_; 
   ELSE
      IF (calendar_id_ IS NULL) THEN
         return_date_ := date_ - NVL(duration_, 0);
      ELSE
         return_date_ := Work_Time_Calendar_API.Get_Start_Date(calendar_id_, date_, NVL(duration_, 0));
      END IF;
   
      IF (return_date_ IS NULL) THEN
         Error_Date_Not_In_Calendar___(calendar_id_, date_, duration_);
      END IF;
   END IF;

END Fetch_Calendar_Start_Date;


-- Fetch_Calendar_End_Date
--   Calls Work_Time_Calendar_API.Get_End_Date, but adds some error checking, and outs the date.
PROCEDURE Fetch_Calendar_End_Date (
   return_date_   OUT DATE,
   calendar_id_   IN  VARCHAR2,
   date_          IN  DATE,
   duration_      IN  NUMBER )
IS
BEGIN


   IF (date_ IS NULL) THEN
      return_date_ := date_;
   ELSE
      IF (calendar_id_ IS NULL) THEN
         return_date_ := date_ + NVL(duration_, 0);
      ELSE
         return_date_ := Work_Time_Calendar_API.Get_End_Date(calendar_id_, date_, NVL(duration_, 0));
      END IF;
   
      IF (return_date_ IS NULL) THEN
         Error_Date_Not_In_Calendar___(calendar_id_, date_, duration_);
      END IF;
   END IF;

END Fetch_Calendar_End_Date;


@UncheckedAccess
FUNCTION Get_Calendar_Start_Date (
   calendar_id_ IN VARCHAR2,
   date_        IN DATE,
   duration_    IN NUMBER ) RETURN DATE
IS
BEGIN
   BEGIN
      IF (date_ IS NULL) THEN
         RETURN NULL;
      ELSIF (calendar_id_ IS NULL) THEN
         RETURN date_ - NVL(duration_, 0);
      ELSE
         RETURN Work_Time_Calendar_API.Get_Start_Date(calendar_id_, date_, NVL(duration_, 0));
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
   END;
END Get_Calendar_Start_Date;



-- Get_Calendar_End_Date
--   Calls Work_Time_Calendar_API.Get_Start_Date, returns NULL if any error is raised.
--   Calls Work_Time_Calendar_API.Get_End_Date, returns NULL if any error is raised.
@UncheckedAccess
FUNCTION Get_Calendar_End_Date (
   calendar_id_ IN VARCHAR2,
   date_        IN DATE,
   duration_    IN NUMBER ) RETURN DATE
IS
BEGIN
   BEGIN
      IF (date_ IS NULL) THEN
         RETURN NULL;
      ELSIF (calendar_id_ IS NULL) THEN
         RETURN date_ + NVL(duration_, 0);
      ELSE
         RETURN Work_Time_Calendar_API.Get_End_Date(calendar_id_, date_, NVL(duration_, 0));
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN NULL;
   END;
END Get_Calendar_End_Date;



-- Chk_Date_On_Ext_Transport_Cal
--   Checks if the date is a working day on the external transport calendar sent as inparameter. If not a workingday a info message
--   is added to Client_Sys info. The info message specifies if the date is the wanted delivery date or the planned delivery
--   date depending on the date_type_.
PROCEDURE Chk_Date_On_Ext_Transport_Cal (
   ext_transport_calendar_id_ IN VARCHAR2,
   date_                      IN DATE,
   date_type_                 IN VARCHAR2 )
IS
   working_day_     DATE;
BEGIN
   
   IF (date_ IS NOT NULL) THEN
      
      IF (ext_transport_calendar_id_ IS NOT NULL) THEN
          working_day_ := Work_Time_Calendar_API.Get_Closest_Work_Day(ext_transport_calendar_id_, date_);
      ELSE
         working_day_ := date_;
      END IF;

      IF (working_day_ IS NULL) THEN
         Error_Date_Not_In_Calendar___(ext_transport_calendar_id_, date_, 0);
      END IF;

      IF (TRUNC(date_) != TRUNC(working_day_)) THEN
         IF (date_type_ = 'WANTED') THEN
            Client_SYS.Add_Info(lu_name_,'WANTEDDELIVERYNOTONWORKDAYEXT: Wanted Delivery Date is not on a working day according to the external transport calendar, the next working day is on :P1.', working_day_);
         ELSIF (date_type_ = 'PLANNED') THEN
            Client_SYS.Add_Info(lu_name_,'PLANNEDDELIVERYNOTONWORKDAYEXT: Planned Delivery Date is not on a working day according to the external transport calendar, the next working day is on :P1.', working_day_);
         END IF;
      END IF;
   END IF;
END Chk_Date_On_Ext_Transport_Cal;


-- Get_Planned_Delivery_Date
--    This method is used to calculate the planned delivery date when creating ESO from CRO.
--    This date is used to calculate Latest Completion Date in CRO for purpose of planning.
FUNCTION Calc_Plan_Deliv_Date_Forwards (
   part_no_          IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   contract_         IN VARCHAR2,   
   planned_due_date_ IN DATE ) RETURN DATE
IS 
   customer_rec_                 Cust_Ord_Customer_API.Public_Rec;
   site_date_                    DATE;
   planned_delivery_date_        DATE;
   new_due_date_                 DATE;
   planned_ship_date_            DATE;   
   supply_site_due_date_         DATE;   
   agreement_id_                 VARCHAR2(10);
   ship_via_code_                VARCHAR2(3);
   route_id_                     VARCHAR2(12);  
   dummy_delivery_terms_         CUSTOMER_ORDER_TAB.delivery_terms%TYPE;
   dummy_del_terms_location_     CUSTOMER_ORDER_TAB.del_terms_location%TYPE;
   freight_map_id_               CUSTOMER_ORDER_TAB.freight_map_id%TYPE;
   zone_id_                      CUSTOMER_ORDER_TAB.zone_id%TYPE;
   delivery_leadtime_            NUMBER;
   ext_transport_calendar_id_    CUSTOMER_ORDER_LINE_TAB.ext_transport_calendar_id%TYPE;
   forward_agent_id_             CUSTOMER_ORDER_TAB.forward_agent_id%TYPE;
   picking_leadtime_             CUSTOMER_ORDER_TAB.picking_leadtime%TYPE;
   shipment_type_                CUSTOMER_ORDER_TAB.shipment_type%TYPE;
   ship_addr_no_                 CUSTOMER_ORDER_TAB.ship_addr_no%TYPE;
   ship_inventory_location_no_   VARCHAR2(35);   
BEGIN   
   site_date_        := Site_API.Get_Site_Date(contract_);
   customer_rec_     := Cust_Ord_Customer_API.Get(customer_no_);
   ship_addr_no_     := Customer_Info_Address_API.Get_Default_Address(customer_no_, Address_Type_Code_API.Decode('DELIVERY'));
   agreement_id_     := Customer_Agreement_API.Get_First_Valid_Agreement(customer_no_,
                                                                         contract_,
                                                                         customer_rec_.currency_code,
                                                                         trunc(site_date_),
                                                                         'FALSE');   
   Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(ship_via_code_,
                                                               dummy_delivery_terms_,
                                                               dummy_del_terms_location_,
                                                               freight_map_id_,
                                                               zone_id_,
                                                               delivery_leadtime_,
                                                               ext_transport_calendar_id_,
                                                               route_id_,
                                                               forward_agent_id_,
                                                               picking_leadtime_,
                                                               shipment_type_,
                                                               ship_inventory_location_no_,
                                                               contract_,
                                                               customer_no_,
                                                               ship_addr_no_,
                                                               'N',
                                                               agreement_id_,
                                                               NULL); -- Passed NULL for vendor_no
     
   new_due_date_  := planned_due_date_;
   Calc_Order_Dates_Forwards(planned_delivery_date_,
                             planned_ship_date_,
                             new_due_date_,
                             supply_site_due_date_,
                             site_date_,
                             contract_,
                             'IO',
                             customer_no_,
                             NULL, -- vendor_no_                 
                             part_no_,
                             NULL, -- supplier_part_no_
                             ship_addr_no_,
                             ship_via_code_ ,   
                             route_id_,
                             delivery_leadtime_,
                             picking_leadtime_,
                             ext_transport_calendar_id_,
                             NULL);-- supplier_ship_via_transit_
                  
   RETURN planned_delivery_date_;
END Calc_Plan_Deliv_Date_Forwards;

-- Show_Invalid_Calendar_Info
--  Checks if the App_Context_SYS set for 'CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_'. If exists, an info message is set to invalid_calendar_info_.
--  The info message specifies the calendar IDs that are not generated within the relevant dates. If 'TRUE' is passed for set_client_sys_info_, the message is also added to Client_SYS info.
PROCEDURE Show_Invalid_Calendar_Info(
   invalid_calendar_info_  OUT VARCHAR2,
   set_client_sys_info_    IN  VARCHAR2) 
IS
   invalid_calendar_ids_   VARCHAR2(2000);
BEGIN
   invalid_calendar_ids_ := SUBSTR(App_Context_SYS.Find_Value('CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_'), 1, 2000);
   IF (invalid_calendar_ids_ IS NOT NULL) THEN
      invalid_calendar_info_ := Language_SYS.Translate_Constant(lu_name_, 'NOT_GENERATED_CALENDAR: The planned dates maybe inaccurate as they are not within distribution/external transport/supplier calendar :P1.', NULL, invalid_calendar_ids_);
   END IF;
   IF (set_client_sys_info_ = 'TRUE' AND invalid_calendar_info_ IS NOT NULL) THEN
      Client_SYS.Add_Info(lu_name_, invalid_calendar_info_);
   END IF;
END Show_Invalid_Calendar_Info;


