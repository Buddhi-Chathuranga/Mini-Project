-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderLeadtimeUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211005  KiSalk  Bug 160919(SC21R2-2963), Modified Get_Supply_Chain_Head_Defaults to fetch forwarder irrespective of the existence of route even when Agreement is connected. 
--  201106  KiSalk  Bug 155793(SCZ-12085), Added ship_addr_no_changed_ parameter to Get_Supply_Chain_Defaults and Get_Supply_Chain_Defaults___. In the latter, the new parameter along with sc_matrix_record_found_ was used conditionally, 
--  201106          to set default lead times, when no data fetched from Supply Chain matrixes.
--  201105  PamPlk  Bug 155965 (SCZ-12178), Added a record type variable to hold a flag, which indicates whether route_id_ or forward_agent_id_ were assigned with a value and  
--  201105          decides whether route_id_ or forward_agent_id_ need to reset later to .Added the method Set_Variable_Value___ to assign value and flag together.
--  201013  ThKrlk  SCZ-11836, Modified Get_Default_Leadtimes() to get new parameter ship_via_code_changed_.
--  200724  RoJalk  Bug 154273 (SCZ-10310), Modified Get_Supply_Chain_Head_Defaults and removed the code where value from sc matrix is overridden by input value for picking leadtime for our site to external customer.   
--  200724  RoJalk  Bug 154273 (SCZ-10310), Modified Get_Supply_Chain_Head_Defaults and added the variable sc_matrix_record_found_.
--  200715  RoJalk  Bug 154273 (SCZ-10310), Modified Get_Supply_Chain_Head_Defaults so that External Transport Lead Time and PIcking Lead Time remain with their values after the addres change, when there is no data in the supply chain matrix. 
--  200220  MaRalk  SCXTEND-2838, Merged Bug 147950(SCZ-4398), Restructured the code in Get_Supply_Chain_Head_Defaults to fetch the forward agent id according to the route id. 
--  200220          Made the forwarder agent id null when the route id is null and handled leadtime fetching logic.
--  200217  NipKlk  Bug 152454 (SCZ-9044), Handled the picking lead time and delivery lead time fetching when connecting the agreement manually.
--  200217  NipKlk  Bug 152454 (SCZ-9044), Re-applied the correction of the bug 147950 (SCZ-4398) since it was reversed  in the Xtend delivery to support for UPD 7.
--  190911  NipKlk  Bug 147950 (SCZ-4398), Restructured the code in Get_Supply_Chain_Head_Defaults() to fetch the forward agent id according to the route id, made the forwarder agent id null when the route id is null and handled leadtime fetching logic.
--  190317  NipKlk  Bug 146297 (SCZ-3080), Modified the method Get_Supply_Chain_Head_Defaults() to change the delivery information fetching logic when there is an agreement connected to the order header, aligned the delivery information fetching logic, 
--  190317          with the manually ship-via changing logic as well as corrected the route_id fetching logic according to the bug 138033 when an agreement is connected with ship-via defined in it.
--  180821  UdGnlk  Bug 143543, Modified Get_Supply_Chain_Defaults___() and Fetch_Line_Deliv_Attribs___() by adding conditions to fetch delivery terms and delivery term locations.
--  180815  UdGnlk  Bug 143543, Modified Get_Supply_Chain_Defaults___() to fetch the delivery_terms and delivery_term_location. Refactor Get_Supply_Chain_Head_Defaults() for delivery information.   
--  180808  UdGnlk  Bug 142374, Modified Get_Supply_Chain_Head_Defaults to fetch route_id when customer agreement exists but without a supply chain matrix to get from the customer delivery address. 
--  180221  DiKuLk  Bug 140020, Modified Get_Supply_Chain_Defaults___(), Fetch_Line_Deliv_Attribs___(), Fetch_Head_Deliv_Attribs___(), 
--                  Get_Supply_Chain_Defaults(), Get_Ship_Via_Values(), Fetch_Delivery_Attributes(), Fetch_Head_Delivery_Attributes(), Get_Default_Leadtimes()
--                  to keep manually entered shipment_type_, forward_agent_id_, delivery_leadtime_ and picking_leadtime_ when changing the ship_via code if 
--                  there is no record in the supply chain matrix.
--  180130  DiKuLk  STRSC-16384, Modified Fetch_Head_Deliv_Attribs___() to revert the correction for the shipment_type_ done by lcs merge of 
--  180130          Bug 139211.
--  180129  DiKuLk  STRSC-16384, Modified Fetch_Line_Deliv_Attribs___() to revert the correction for the shipment_type_ done by lcs merge of 
--  180129          Bug 139211.
--  180124  TiRalk  STRSC-15567, Modified Fetch_Line_Deliv_Attribs___ to handle the NVl properly for delivery_leadtime_ to avoid not null error.
--  171221  DiKuLk  Bug 139446, Modified Fetch_Line_Deliv_Attribs___() to fetch the forwarder according to the route id when changing ship-via code.
--  171219  DiKuLk  Bug 139211, Modified Fetch_Line_Deliv_Attribs___() and Fetch_Head_Deliv_Attribs___() to keep the value of the shipment_type_, picking_leadtime_
--  171215          and delivery_leadtime_ as sent from the client.
--  171204  ShPrlk  Bug 138796, Modified Fetch_Line_Deliv_Attribs___ to fetch delivery term, delivery term location and shipvia in IPD and PD sceneario from supply chain matrix.
--  171122  ChBnlk  Bug 138033, Modified Fetch_Line_Deliv_Attribs___() and Fetch_Head_Deliv_Attribs___() to keep the value of the route_id_ as sent from the client,
--  171122          when the route_id_ is not fetched from anywhere of the hierarchy.
--  170424  NaLrlk  STRSC-7444, Modified Get_Supply_Chain_Head_Defaults() to fetch vendor_addr_no_ size for VARCHAR2(50).
--  170220  LaThlk  Bug 133405, Reversed the correction of the bug 131606.
--  170202  NiNilk  Bug 133650, Modified Get_Supply_Chain_Head_Defaults(), Fetch_Head_Deliv_Attribs___, Fetch_Line_Deliv_Attribs___ to assign the route id stated in the customer order address tab to the route id if there's no route Id specified in the supply chain matrix record
--  170202          or ship via code is equal to the ship via code stated in customer order address and assign null to the route id when ship via code is not equal to the ship via code stated in customer order address.
--  161019  SeJalk  Bug 132074, Modified the methods Fetch_Line_Deliv_Attribs___ and Fetch_Head_Deliv_Attribs___ to fetch delevery terms and del terms location from the customer address, 
--  161019          if the default values or values in the matrix are NULL
--  160928  LaThlk  Bug 131606, Modified Get_Supply_Chain_Head_Defaults in order to assign correct ship_via_code_ respectively for the external and internal CO.
--  160908  ChJalk  Bug 130981, Modified the methods Fetch_Line_Deliv_Attribs___ and Fetch_Head_Deliv_Attribs___ to keep the originally entered values of delevery terms and del terms location if the values fetched are NULL.
--  160616  ChJalk  Bug 127627, Modified the methods Get_Supply_Chain_Defaults___, Fetch_Line_Deliv_Attribs___, Fetch_Head_Deliv_Attribs___ and Get_Supply_Chain_Head_Defaults to set the 
--  160616          originally entered value of forward_agent_id if the value fetched is NULL. 
--  160225  ChFolk  STRSC-860, Added transport_leadtime and arrival_route_id as new parameters to Fetch_Line_Deliv_Attribs___, Get_Transit_Ship_Via_Values___, Get_Supply_Chain_Totals___, Get_Transit_Ship_Via_Values
--  160225          and Get_Default_Leadtimes to get the corresponding values from supplier chain matrix records and to be used them in leadtime calculations.
--  160216  ErFelk  Bug 127120, Modified Fetch_Head_Deliv_Attribs___() and Fetch_Line_Deliv_Attribs___() so that route is assigned with the Order Address Info tab value only if there is no record in the supply chain matrix.   
--  160122  ErFelk  Bug 124048, Modified Fetch_Head_Deliv_Attribs___ and Get_Supply_Chain_Head_Defaults by assigning the forward agent id of supply chain matrix only if the forward agent id of Delivery Route is NULL. 
--  150320  ChFolk  Replaced the usages of Customer_Order_Route_API with Delivery_Route_API.
--  150525  JeeJlk  Bug 121435, Modified Get_Supply_Chain_Head_Defaults and Get_Supply_Chain_Defaults___ not to set ship via code to default values when corresponding value in customer agreement is null.
--  150227  ShVese  PRSC-4770, Switched the parameters passed incorrectly in the call to Supp_Addr_Part_Leadtime_API.Get in Fetch_Line_Deliv_Attribs___.
--  150225  ShVese  PRSC-4770. Added setting of del terms and location from the header in a single occurence scenario.
--  150224  ShVese  PRSC-4770. Changed the code in Get_Supply_Chain_Defaults___ that re-fetches forward_agent_id unnecessarily.
--  150224          Also changed the code that re-fetches delivery terms and delivery term location unnecessarily.
--  150224          Added comparision of forward_agent, ext transport calender and del terms location when evaluating default info.
--  150223  ShVese  PRSC-4770. Added variable same_vendor_ to other blocks where header and line vendor no is same in Get_Supply_Chain_Defaults___(). 
--  150223  ErFelk  PRSC-4770, Added variable same_vendor_ to a conditon in Get_Supply_Chain_Defaults___(). This variable controls the execution of method Fetch_Line_Deliv_Attribs___(). 
--  150220  ErFelk  PRSC-4770, Modified Get_Supply_Chain_Defaults___() by adding some codes to update line address values with header values if the suppliers are the same.
--  150220          Modified Fetch_Line_Deliv_Attribs___() so that delivery_terms_ and del_terms_location_ is assigned with supply site values if the supply code is IPD.
--  150211  MeAblk  EAP-970, Modified Get_Supply_Chain_Defaults___ in order to correctly set the default delivery terms when a new order line added.
--  150129  MAHPLK  PRSC-4770, Merged Bug 119576, Removed some code blocks where it compares line supplier with the header supplier in Get_Supply_Chain_Defaults___().
--  150116  MaRalk  PRSC-391, Modified Get_Ship_Via_Values to correctly fetch freight map and zone values.
--  141128  SBalLK  PRSC-3709, Modified Get_Supply_Chain_Defaults___(), Fetch_Line_Deliv_Attribs___(), Fetch_Head_Deliv_Attribs___(), Get_Transit_Ship_Via_Values___(), Get_Transit_Ship_Via_Values(),
--  141128          Get_Supply_Chain_Head_Defaults(), Get_Supply_Chain_Defaults() Get_Sc_Defaults_For_Sourcing(), Get_Ship_Via_Values(), Fetch_Delivery_Attributes(), Get_Supply_Chain_Totals() and
--  141128          Get_Default_Leadtimes() methods to fetch delivery terms and delivery terms location from supply chain matrix.
--  140221  ChFolk  Modified Fetch_Line_Deliv_Attribs___ to avoid fetching delivery leadtime info from supplier address when supply_code is in IPD or PD with single occurance is checked.
--  140220  ChFolk  Modified Get_Supply_Chain_Defaults___ and Get_Supply_Chain_Head_Defaults to avoid fetching delivery leadtime info from supplier address when supply_code
--  140220          is in IPD or PD with single occurance is checked.
--  131014  HimRlk  Modified Get_Supply_Chain_Defaults___() to keep fetched values in delivery_leadtime, picking_leadttime, shipment_type and route_id 
--  131014          if header supplier and line suppler are different.
--  130710  AyAmlk  Bug 111144, Modified Get_Sc_Defaults_For_Sourcing() to match the END statement name with the procedure/function name.
--  130711  HimRlk  Added new methods Fetch_Head_Delivery_Attributes() and Fetch_Head_Deliv_Attribs___(). Renamed Fetch_Delivery_Attributes___()
--  130711          to Fetch_Line_Deliv_Attribs___(). 
--  130729  SURBLK  Set forward_agent_id_ getting from supply chain matrix or customer in Fetch_Delivery_Attributes___(), 
--  130729          Get_Transit_Ship_Via_Values___(), Get_Supply_Chain_Head_Defaults.
--  130711  HimRlk  Added new methods Fetch_Head_Delivery_Attributes() and Fetch_Head_Delivery_Attr___(). 
--  130705  ChJalk  TIBE-964, Removed the global variables inst_PurchasePartSupplier_ and inst_Supplier_ and re-structured the code to use conditional compilation.
--  130626  HimRlk  Modified Get_Supply_Chain_Defaults___ to give priority to part group data.
--  130520  HimRlk  Added new parameter vendor_no to Get_Supply_Chain_Head_Defaults(), Get_Supply_Chain_Defaults___(), Fetch_Delivery_Attributes___. 
--  130520          Modified logic in Get_Supply_Chain_Head_Defaults() and Fetch_Delivery_Attributes___() to fetch delivery data from supplier
--  130520          header supplier is entered. Modified Get_Supply_Chain_Defaults___() to fetch delivery data from header when supply code is IPD or PD
--  130520          and line supplier is same as the header supplier.
--  130409  MaMalk  Made the default shipment_type to 'NA' instead of 'NS' in Get_Supply_Chain_Head_Defaults and Fetch_Delivery_Attributes___.
--  130409  MaMalk  Modified Fetch_Delivery_Attributes___, Get_Supply_Chain_Head_Defaults to change the order to fetch the shipment type.
--  121031  MAHPLK  Modified Get_Supply_Chain_Head_Defaults, Fetch_Delivery_Attributes___ and Get_Supply_Chain_Defaults___ to 
--  121031          fethch the rout_id from Cust_Ord_Customer_Address_API, if it is null in supply chain matrices.
--  120911  MeAblk  Added ship_inventory_location_no_ as a parameter to Get_Supply_Chain_Head_Defaults, Fetch_Delivery_Attributes to retrieve 
--  120911          ship_inventory_location_no from supply chain matrix. And accordingly modified the other methods.
--  120824  MaMalk  Added shipment_type as a parameter to Fetch_Delivery_Attributes and Fetch_Delivery_Attributes___ to retrieve shipment type per ship via.
--  120725  MAHPLK  Added picking lead time as parameter to Get_Supply_Chain_Totals.
--  120716  MaMalk  Added transit_route_id to method Get_Transit_Ship_Via_Values___ and also created the public method Get_Transit_Ship_Via_Values
--  120716          to be used for calculating supply site due date for date calculation.
--  120716  MAHPLK  Modified method Get_Transit_Ship_Via_Values___. 
--  120702  MaMalk  Modified methods Get_Supply_Chain_Head_Defaults, Get_Supply_Chain_Defaults, Get_Ship_Via_Values, Get_Sc_Defaults_For_Sourcing and 
--  120702          Fetch_Delivery_Attributes to retrieve the route and forwarder.
--  120705  MaHplk  Modified Get_Supply_Chain_Head_Defaults, Get_Sc_Defaults_For_Sourcing, Get_Ship_Via_Values and Get_Supply_Chain_Defaults___ to fetch the picking_leadtime.
--  120702  MaMalk  Modified methods Get_Supply_Chain_Head_Defaults, Get_Ship_Via_Values and Fetch_Delivery_Attributes to retrieve the route
--  120702          according to the ship-via in supply chain matrices.
--  120710  NipKlk  Bug 103704, Changed the initialization value of the variable default_leadtime_ to 0 from NULL and assigned default_ship_via_code_ value to ship_via_code_ 
--  120710          if the ship_via_code_ is NULL in function Get_Supply_Chain_Defaults___.  
--  120412  AyAmlk  Bug 100608, Increased the length of delivery_terms_ used in the stmt_ in Get_Supply_Chain_Defaults___(), Get_Ship_Via_Values___(),
--  120412          Get_Supplier_Ship_Via___().
--  110817  darklk  Bug 96145, Modified Fetch_Delivery_Attributes___ and Get_Transit_Ship_Via_Values___ by renaming the currency_code to exp_add_cost_curr_code.
--  110315  AndDse  BP-4434, Modified Get_Default_Leadtimes, removed external transport calendar as in out parameter.
--  110203  AndDse  BP-3776, Implementation of external transport calendar.
--  100826  NaLrlk  Modified the method Get_Supply_Chain_Head_Defaults and Fetch_Delivery_Attributes___ to fetch the freight information for internal customer.
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  090305  ShKolk  Changed method call Fetch_Zone_For_Single_Occ_Addr to Fetch_Zone_For_Addr_Details.
--    080922   MaJalk  Removed NVL at the assignment of Zone details at Fetch_Delivery_Attributes___.
--    080912   MaJalk  Added zone details as parameters to method Get_Ship_Via_Values.
--    080911   MaJalk  Changed method name Get_Ship_Via_Values___ to Fetch_Delivery_Attributes___. Added parameters zone_definition_id_ and zone_id_ 
--                    to Get_Supply_Chain_Defaults___, Fetch_Delivery_Attributes___, Fetch_Delivery_Attributes, Get_Supply_Chain_Defaults and 
--                    Get_Supply_Chain_Head_Defaults. At Fetch_Delivery_Attributes___ and Get_Supply_Chain_Head_Defaults, set values for zone_definition_id_ and zone_id_.
--  100520  KRPELK  Merge Rose Method Documentation.
--  090924  MaMalk  Removed constants inst_PurOrderLeadtimeUtil_ and inst_SupplierAddress_.
--  ------------------------- 14.0.0 -----------------------------------------
--  090115  SudJlk  Bug 78030, Modified Get_Supply_Chain_Defaults___ by checking default_addr_flag_db_ and addr_flag_db_ when setting
--  090115          delivery leadtime if not already assigned.
--  090105  SaRilk  Bug 79142, Modified Get_Supply_Chain_Defaults___ by checking the vendor_no_ before assigning vendor_ship_via_ to 
--  090105          ship_via_code_ when the addr_flag_db_ = 'Y'.
--  080304  MaRalk  Bug 71306, Modified Get_Supply_Chain_Defaults___ by removing initializing return values to null at the beginning.
--  070207  NaWilk  Removed parameter delivery_terms_desc from method Get_Delivery_Terms_Ship_Via.
--  060516  NaLrlk  Enlarge Address - Changed variable definitions.
--  --------------------------------- 13.4.0 --------------------------------
--  060125  JaJalk  Added Assert safe annotation.
--  051019   SaRalk  Modified procedure Get_Supply_Chain_Totals___.
--  051003   KeFelk  Added Site_Invent_Info_API in relavant places where Site_API is used.
--  051003  UsRalk  Redirected calls for Get_Currency_Rate_Defaults to Invoice_Library_API.
--  050926  SaMelk  Removed Unused Variables.
--  050629  MaEelk  Added General_SYS.Init call to Get_Supplier_Ship_Via.
--  050411  NiRulk  Bug 49348, Modified Get_Supply_Chain_Defaults___ to retrieve header ship via code when 'PD' and supplier is NULL.
--  050316  DaZase  Added Get_Supplier_Ship_Via as public interface for Get_Supplier_Ship_Via___.
--  050112  JaJalk  Modified the method Get_Supply_Chain_Totals___ to calculate the dates for PS supply code..
--  041028  DiVelk  Modified Get_Supply_Chain_Totals___.
--  040809  LaBolk  Modified the error message for supplier address (including the tag) in Get_Supply_Chain_Defaults___.
--  040426  LoPrlk  Removed the method Get_Delivery_Leadtime.
--  040415  LoPrlk  SCHT603 Supply Demand Views - Removed the parameter vendor_doc_addr_no_ from the method Get_Delivery_Leadtime and the method was altered.
--  040414  LoPrlk  SCHT603 Supply Demand Views - Added the method Get_Delivery_Leadtime.
--  040406  WaJalk  Modified methods Get_Supply_Chain_Defaults___,  Get_Ship_Via_Values___,
--                  Get_Supplier_Ship_Via___ and Get_Transit_Ship_Via_Values___ to handle delivery address
--                  as supplier's default address instead of using document address.
--  031031  JoAnSe  Added error message in Get_Supply_Chain_Defaults___ when a
--                  supplier without a valid document address has been specified.
--  031010  JoAnSe  Added handling for prospect customer in Get_Supply_Chain_Defaults___
--  031007  JoAnSe  Added call to Get_Other_Leadtimes___ in Get_Default_Leadtimes.
--                  Added parameter purchase_part_no_ to several methods.
--  031002  JoAnSe  Modified parameters for Get_Supply_Chain_Defaults and
--                  Get_Sc_Defaults_For_Sourcing, Get_Supply_Chain_Totals,
--                  Get_Supply_Chain_Defaults___ and Get_Ship_Via_Values___.
--  030929  JoAnSe  Removed obsolete methods Get_Leadtime and Get_External_Leadtime.
--                  Changed parameters in Get_Transit_Ship_Via_Values___ and
--                  Get_Supplier_Ship_Via___
--  030922  JoAnSe  Added Get_Transit_Ship_Via_Values___, Get_Supply_Chain_Totals___,
--                  Get_Other_Leadtimes___, Get_Default_Leadtimes, Get_Supply_Chain_Totals.
--                  Also made several changes in existing methods.
--                  Removed a number of methods now obsolete.
--  030918  JoAnSe  Corrected retrieval of supplier default doc address in
--                  Get_Supply_Chain_Defaults___ and Get_Ship_Via_Values___
--                  Moved code from Get_Ship_Via_Values___ to Get_Supplier_Ship_Via___
--                  Also made changes for handling of single occurrence address.
--  030917  JoAnSe  Corrected Get_Supply_Chain_Defaults___ for case with non order default address.
--  030916  JoAnSe  Rewrote Get_Supply_Chain_Head_Defaults, Get_Supply_Chain_Defaults___
--                  and Get_Ship_Via_Values___
--  030916  NuFilk  Corrected syntax in dynamic calls.
--  030915  JoAnSe  Changes in Get_Ship_Via_Values___ supply_code other than PD, IPD
--  030915  JaJalk  Corrected the syntax of the dynamic call in Get_Ship_Via_Values___
--  030911  JoEd    Added methods Get_Supply_Chain_Head_Defaults, Get_Supply_Chain_Defaults,
--                  Get_Sc_Defaults_For_Sourcing, Get_Ship_Via_Values, Get_Ship_Via_Leadtime,
--                  Get_Supply_Chain_Defaults___ and Get_Ship_Via_Values___.
--  030902  GaSolk  Performed CR Merge 2.
--  030728  ChBalk  Changed logic in Get_External_Default_Values.
--  030725  NuFilk  Added method Check_Part_Leadtime_Exist to check for supply chain part group leadtime values.
--  030717  NuFilk  Added comments and modified method Get_Expected_Additional_Cost.
--  030630  ChBalk  Added method Check_Leadtime_Exist which will validate the delivery leadtime.
--  030624  NuFilk  Modified method Get_Expected_Additional_Cost.
--  030512  NuFilk  Added methods, Get_External_Leadtime, Get_Leadtime, Get_Distance, Get_External_Distance,
--  030512          Get_Expected_Additional_Cost and Get_External_Exp_Add_Cost.
--  030425  WaJalk  Removed Get_External_Leadtime_Values.
--  030423  WaJalk  Added methods Get_External_Default_Values and Get_External_Leadtime_Values.
--  030422  ChBalk  Added calles to Site_To_Site_Leadtime_API, Site_To_Site_Part_Leadtime_API.
--  030422  NuFilk  Created the LU with methods Get_Default_Values and Get_Leadtime_Values
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Supply_Chain_Defaults___
--   Retreives supply chain parameters from the supply chain matrixes.
--   If not found there  If not found there, default values are inherited
--   from order or package header, supplier or customer address depending
--   on the supply code.
--   The totals for shipping distance, expected cost and shipping time are
--   also calculated and returned.
--   The from_sourcing_ flag is TRUE if called from the automatic sourcing,
--   since the sourcing alternative should not be added if the ship via code
--   wasn't found in any of the matrixes. Ship_via_code_ will in that case
--   be set to NULL.
PROCEDURE Get_Supply_Chain_Defaults___ (
   route_id_                     IN OUT VARCHAR2,
   forward_agent_id_             IN OUT VARCHAR2,
   ship_via_code_                IN OUT VARCHAR2,
   delivery_terms_               IN OUT VARCHAR2,
   del_terms_location_           IN OUT VARCHAR2,
   supplier_ship_via_transit_    IN OUT VARCHAR2,
   delivery_leadtime_            IN OUT NUMBER,
   ext_transport_calendar_id_    IN OUT VARCHAR2,
   default_addr_flag_db_         IN OUT VARCHAR2,
   freight_map_id_               IN OUT VARCHAR2,
   zone_id_                      IN OUT VARCHAR2,
   picking_leadtime_             IN OUT NUMBER,
   shipment_type_                IN OUT VARCHAR2,
   total_shipping_distance_      IN OUT NUMBER,
   total_expected_cost_          IN OUT NUMBER,
   total_shipping_time_          IN OUT NUMBER,
   contract_                     IN     VARCHAR2,
   customer_no_                  IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   purchase_part_no_             IN     VARCHAR2,
   supply_code_                  IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   agreement_id_                 IN     VARCHAR2,
   default_ship_via_code_        IN     VARCHAR2,
   default_delivery_terms_       IN     VARCHAR2,
   default_del_terms_location_   IN     VARCHAR2,
   default_delivery_leadtime_    IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   default_route_id_             IN     VARCHAR2,
   default_forward_agent_id_     IN     VARCHAR2,
   default_picking_leadtime_     IN     NUMBER,
   default_shipment_type_        IN     VARCHAR2,
   from_sourcing_                IN     BOOLEAN,
   header_vendor_no_             IN     VARCHAR2,
   header_ship_addr_no_          IN     VARCHAR2,
   ship_via_code_changed_        IN     VARCHAR2,
   ship_addr_no_changed_         IN     VARCHAR2 )
IS
   custrec_                  Cust_Ord_Customer_API.Public_Rec;
   custaddrrec_              Cust_Ord_Customer_Address_API.Public_Rec;
   vendor_addr_no_           SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE;
   vendor_ship_via_          VARCHAR2(3) := NULL;
   vendor_delivery_terms_    VARCHAR2(5) := NULL;
   supply_site_              VARCHAR2(5) := NULL;

   external_cust_            BOOLEAN;
   supp_category_            VARCHAR2(20) := NULL;

   supply_chain_part_group_  VARCHAR2(20) := NULL;
   sc_matrix_record_found_   BOOLEAN   := FALSE;
   part_group_record_found_  BOOLEAN      := FALSE;
   default_leadtime_         NUMBER := 0;
   dummy_tansit_del_terms_   VARCHAR2(5);
   dummy_transit_del_term_loc_   VARCHAR2(100);
   
   distance_                   NUMBER;
   expected_additional_cost_   NUMBER;
   cost_curr_code_             VARCHAR2(3);
   internal_leadtime_          NUMBER;
   transit_del_leadtime_       NUMBER := 0;
   transit_distance_           NUMBER := 0;
   transit_cost_               NUMBER := 0;
   transit_cost_curr_code_     VARCHAR2(3);
   transit_int_leadtime_       NUMBER := 0;
   fetched_ext_trans_cal_id_   VARCHAR2(10);
   route_                      VARCHAR2(12);
   fetched_picking_leadtime_   NUMBER;
   fetched_forward_agent_id_   VARCHAR2(20); 
   fetched_delivery_terms_     VARCHAR2(5); 
   fetched_del_terms_location_ VARCHAR2(100);
   vendor_picking_leadtime_    NUMBER;
   transit_route_id_           VARCHAR2(12);
   fetched_shipment_type_      VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);
   customer_category_          VARCHAR2(20);
   same_vendor_                BOOLEAN := FALSE;
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);
   $IF Component_Purch_SYS.INSTALLED $THEN
      supprec_             Supplier_API.Public_Rec;
   $END   
   temp_forward_agent_id_      VARCHAR2(20);
   custagreerec_               Customer_Agreement_API.Public_Rec;
   -- The record to hold a flag to indicate if the relevant parameters were set with a value
   TYPE values_fetched_rec_ IS RECORD
           (route_id           BOOLEAN := FALSE,
            forward_agent_id   BOOLEAN := FALSE);
   values_fetched_             values_fetched_rec_;
BEGIN

   -- Initialize return values
   total_shipping_distance_   := 0;
   total_expected_cost_       := 0;
   total_shipping_time_       := 0;

   Trace_SYS.Message('Fetch customer info');
   -- fetch customer info
   custrec_ := Cust_Ord_Customer_API.Get(customer_no_);
   external_cust_ := (nvl(custrec_.category, ' ') = 'E');
   custaddrrec_ := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);
   customer_category_ := Customer_Info_API.Get_Customer_Category_Db(customer_no_);
   temp_forward_agent_id_ := forward_agent_id_;

   $IF Component_Purch_SYS.INSTALLED $THEN
   IF (vendor_no_ IS NOT NULL) THEN
      supprec_ := Supplier_API.Get(vendor_no_);
      supply_site_ := supprec_.acquisition_site;
      supp_category_ := supprec_.category;
      vendor_addr_no_ := Supplier_Address_API.Get_Address_No(vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
      Supplier_Address_API.Get_Delivery_Terms_Ship_Via(vendor_delivery_terms_, vendor_ship_via_, vendor_no_, vendor_addr_no_);

      Trace_SYS.Field('fetched supply site', supply_site_);
      Trace_SYS.Field('vendor_ship_via', vendor_ship_via_);

      IF (vendor_addr_no_ IS NULL) THEN
         -- The supplier did not have a valid document address.
         -- Return error message
         Error_SYS.Record_General(lu_name_, 'NO_VENDOR_ADDR2: Supplier :P1 has no delivery address with purchase specific attributes specified',
                                  vendor_no_);

      END IF;
   END IF;
   $END
   
   -- fetch part group
   IF (part_no_ IS NOT NULL) THEN
      supply_chain_part_group_ := Inventory_Part_API.Get_Supply_Chain_Part_Group(contract_, part_no_);
      Trace_SYS.Field('Fetch part group', supply_chain_part_group_);
   END IF;
   
   IF (supply_code_ = 'PD') THEN
      -- External supplier to external customer
      IF external_cust_ THEN
         -- Using part group
         IF (supply_chain_part_group_ IS NOT NULL) THEN
            ship_via_code_ := Supp_To_Cust_Part_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_,
                                 customer_no_, ship_addr_no_, supply_chain_part_group_);
            Trace_SYS.Field('Ship via from supplier-to-customer (part group)', ship_via_code_);
         END IF;
         
         IF ((ship_via_code_ IS NULL) AND (NVL(vendor_no_, ' ') = NVL(header_vendor_no_, ' '))) THEN
            -- If there is no information entered in the part group and line supplier is same as the header supplier
            -- fetch delivery information from the header.
            ship_via_code_             := default_ship_via_code_;
            delivery_terms_            := default_delivery_terms_;
            del_terms_location_        := default_del_terms_location_;
            Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
            Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
            ext_transport_calendar_id_ := default_ext_transport_cal_id_;
            shipment_type_             := default_shipment_type_;
            delivery_leadtime_         := default_delivery_leadtime_;
            picking_leadtime_          := default_picking_leadtime_;
            same_vendor_  := TRUE;
         END IF;

         -- without part group
         IF (ship_via_code_ IS NULL) THEN
            ship_via_code_ := Supp_To_Cust_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_,
                                 customer_no_, ship_addr_no_);
            Trace_SYS.Field('Ship via from supplier-to-customer', ship_via_code_);
         END IF;
      ELSE
      -- External supplier to internal customer (site)
         $IF Component_Purch_SYS.INSTALLED $THEN
         -- using part group
         IF (supply_chain_part_group_ IS NOT NULL) THEN
               ship_via_code_ := Supp_Addr_Part_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_, supply_chain_part_group_, custrec_.acquisition_site);
            Trace_SYS.Field('Ship via from supplier-to-site (part group)', ship_via_code_);
         END IF;
         
         IF ((ship_via_code_ IS NULL) AND (NVL(vendor_no_, ' ') = NVL(header_vendor_no_, ' '))) THEN
            -- If there is no information entered in the part group and line supplier is same as the header supplier
            -- fetch delivery information from the header.
            ship_via_code_             := default_ship_via_code_;
            delivery_terms_            := default_delivery_terms_;
            del_terms_location_        := default_del_terms_location_;
            Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
            Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
            ext_transport_calendar_id_ := default_ext_transport_cal_id_;
            shipment_type_             := default_shipment_type_;
            delivery_leadtime_         := default_delivery_leadtime_;
            picking_leadtime_          := default_picking_leadtime_;
            same_vendor_  := TRUE;
         END IF;

         -- without part group
         IF (ship_via_code_ IS NULL) THEN
               ship_via_code_ := Supplier_Address_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_, custrec_.acquisition_site);                  
            Trace_SYS.Field('Ship via from supplier-to-site', ship_via_code_);
         END IF;
         $ELSE
            NULL;
         $END            
      END IF;

      -- If no ship via code was found inherit from supplier record
      IF (ship_via_code_ IS NULL) THEN
         ship_via_code_ := vendor_ship_via_;
      END IF;

      -- If no vendor set default..
      IF (ship_via_code_ IS NULL) AND (vendor_no_ IS NULL) THEN
         ship_via_code_ := default_ship_via_code_;
         ext_transport_calendar_id_ := default_ext_transport_cal_id_;
         delivery_leadtime_ := 0;
         picking_leadtime_          := 0;
      END IF;

      IF (default_addr_flag_db_ = 'N') THEN
         IF (ship_via_code_ = custaddrrec_.ship_via_code) THEN
            Set_Variable_Value___(route_id_, values_fetched_.route_id, custaddrrec_.route_id);
         END IF;
      ELSE
         Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
         Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
      END IF;
   ELSIF (supply_code_ = 'IPD') THEN
      -- Internal supplier to external customer
      IF external_cust_ THEN
         -- Using part group
         IF (supply_chain_part_group_ IS NOT NULL) THEN
            -- internal supplier (or our site) to external customer
            ship_via_code_ := Cust_Addr_Part_Leadtime_API.Get_Default_Ship_Via_Code(customer_no_, ship_addr_no_, supply_chain_part_group_, supply_site_);
            Trace_SYS.Field('Ship via from site-to-customer (part group)', ship_via_code_);
         END IF;
         
         IF ((ship_via_code_ IS NULL) AND (NVL(vendor_no_, ' ') = NVL(header_vendor_no_, ' '))) THEN
            -- If there is no information entered in the part group and line supplier is same as the header supplier
            -- fetch delivery information from the header.
            ship_via_code_             := default_ship_via_code_;
            delivery_terms_            := default_delivery_terms_;
            del_terms_location_        := default_del_terms_location_;
            Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
            Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
            ext_transport_calendar_id_ := default_ext_transport_cal_id_;
            shipment_type_             := default_shipment_type_;
            delivery_leadtime_         := default_delivery_leadtime_;
            picking_leadtime_          := default_picking_leadtime_;
         
            same_vendor_  := TRUE;
         END IF;
         
         -- Without part group
         IF (ship_via_code_ IS NULL) THEN
            ship_via_code_ := Customer_Address_Leadtime_API.Get_Default_Ship_Via_Code(customer_no_, ship_addr_no_, supply_site_);
            Trace_SYS.Field('Ship via from site-to-site', ship_via_code_);
         END IF;

      -- Internal supplier to internal customer (site)
      ELSE
         -- Using part group
         IF (supply_chain_part_group_ IS NOT NULL) THEN
            ship_via_code_ := Site_To_Site_Part_Leadtime_API.Get_Default_Ship_Via_Code(custrec_.acquisition_site, supply_site_, supply_chain_part_group_);
            Trace_SYS.Field('Ship via from site-to-site (part group)', ship_via_code_);
         END IF;
         
         IF ((ship_via_code_ IS NULL) AND (NVL(vendor_no_, ' ') = NVL(header_vendor_no_, ' '))) THEN
            -- If there is no information entered in the part group and line supplier is same as the header supplier
            -- fetch delivery information from the header.
            ship_via_code_             := default_ship_via_code_;
            delivery_terms_            := default_delivery_terms_;
            del_terms_location_        := default_del_terms_location_;
            Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
            Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
            ext_transport_calendar_id_ := default_ext_transport_cal_id_;
            shipment_type_             := default_shipment_type_;
            delivery_leadtime_         := default_delivery_leadtime_;
            picking_leadtime_          := default_picking_leadtime_;
            same_vendor_  := TRUE;
         END IF;
         
         -- Without part group
         IF (ship_via_code_ IS NULL) THEN
            ship_via_code_ := Site_To_Site_Leadtime_API.Get_Default_Ship_Via_Code(custrec_.acquisition_site, supply_site_);
            Trace_SYS.Field('Ship via from site-to-site', ship_via_code_);
         END IF;
      END IF;

      -- If no ship via code was found inherit from supplier record
      IF (ship_via_code_ IS NULL) THEN
         ship_via_code_ := vendor_ship_via_;
         Trace_SYS.Field('Ship via supplier', ship_via_code_);
      END IF;
   -- Supply code not in ('IPD', 'PD')
   ELSE
      -- First check customer agreement
      IF (agreement_id_ IS NOT NULL) THEN
         custagreerec_       := Customer_Agreement_API.Get(agreement_id_);
         ship_via_code_      := NVL(custagreerec_.ship_via_code, ship_via_code_);
         delivery_terms_     := NVL(custagreerec_.delivery_terms, delivery_terms_);
         del_terms_location_ := NVL(custagreerec_.del_terms_location, del_terms_location_);
         Trace_SYS.Field('Ship via from agreement', ship_via_code_);
         Trace_SYS.Field('Delivery Terms from agreement', delivery_terms_);
         Trace_SYS.Field('Delivery Terms Locations agreement', del_terms_location_);
      END IF;
      -- If single occurence address, inherit from supplier or customer...
      IF (addr_flag_db_ = 'Y') THEN
         -- If header has supplier entered and supply code is not IPD or PD, then should fetch delivery information from customer
         -- should not copy delivery data from the header
         IF (header_vendor_no_ IS NOT NULL) THEN
            ship_via_code_ := custaddrrec_.ship_via_code;
            delivery_terms_            := custaddrrec_.delivery_terms;
            del_terms_location_        := custaddrrec_.del_terms_location;
            route_id_ := custaddrrec_.route_id;
            delivery_leadtime_ := 0; 
         ELSE
            IF (ship_via_code_ IS NULL) THEN
               ship_via_code_ := default_ship_via_code_;
               Trace_SYS.Field('Single occurrence, ship via from order head', ship_via_code_);
                  Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
                  Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
                  delivery_terms_    := default_delivery_terms_;
                  del_terms_location_ := default_del_terms_location_;
            END IF;

            IF (default_addr_flag_db_ = 'Y') THEN
               IF (ship_via_code_ = default_ship_via_code_) THEN
                     Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
                     Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
                     ext_transport_calendar_id_ := default_ext_transport_cal_id_;
                     shipment_type_             := default_shipment_type_;
                     picking_leadtime_          := default_picking_leadtime_;
                     delivery_leadtime_         := default_delivery_leadtime_;
                     delivery_terms_            := default_delivery_terms_;
                     del_terms_location_        := default_del_terms_location_;
               END IF;
            END IF;
         END IF;         
      ELSE
         IF (ship_via_code_ IS NULL) THEN
            -- Our site to external customer
            IF external_cust_ THEN
               -- Using part group
               IF (supply_chain_part_group_ IS NOT NULL) THEN
                  ship_via_code_ := Cust_Addr_Part_Leadtime_API.Get_Default_Ship_Via_Code(customer_no_, ship_addr_no_, supply_chain_part_group_, contract_);
                  Trace_SYS.Field('Ship via from site-to-customer (part group)', ship_via_code_);
               END IF;

               -- If not default order address and no ship via found retrieve check without part group
               -- If header has a supplier entered, should fetch line delivery information from chain matrix
               IF ((ship_via_code_ IS NULL) AND ((default_addr_flag_db_ = 'N' AND ship_addr_no_ != NVL(header_ship_addr_no_,Database_Sys.string_null_)) OR (header_vendor_no_ IS NOT NULL))) THEN
                  ship_via_code_ := Customer_Address_Leadtime_API.Get_Default_Ship_Via_Code(customer_no_, ship_addr_no_, contract_);
                  Trace_SYS.Field('Ship via from site-to-customer', ship_via_code_);
               END IF;
            -- Our site to internal customer
            ELSE
               -- Using part group
               IF (supply_chain_part_group_ IS NOT NULL) THEN
                  ship_via_code_ := Site_To_Site_Part_Leadtime_API.Get_Default_Ship_Via_Code(custrec_.acquisition_site, contract_, supply_chain_part_group_);
                  Trace_SYS.Field('Ship via from site-to-site (part group)', ship_via_code_);
               END IF;

               -- If not default order address and no ship via found retrieve check without part group
               -- If header has a supplier entered, should fetch line delivery information from chain matrix
               IF ((ship_via_code_ IS NULL) AND ((default_addr_flag_db_ = 'N') OR (header_vendor_no_ IS NOT NULL))) THEN
                  ship_via_code_ := Site_To_Site_Leadtime_API.Get_Default_Ship_Via_Code(custrec_.acquisition_site, contract_);
                  Trace_SYS.Field('Ship via from site-to-site', ship_via_code_);
               END IF;
            END IF;
         END IF;

         -- If no ship via code was found inherit from customer address, order or package header
         IF (ship_via_code_ IS NULL) THEN
            IF (default_addr_flag_db_ = 'N' AND ship_addr_no_ != NVL(header_ship_addr_no_,Database_Sys.string_null_)) OR (header_vendor_no_ IS NOT NULL) THEN
               -- Not default adress or if header has a supplier entered - retrieve default from customer address
               ship_via_code_ := custaddrrec_.ship_via_code;
            ELSE
               ship_via_code_ := default_ship_via_code_;
               delivery_terms_            := default_delivery_terms_;
               del_terms_location_        := default_del_terms_location_;
               Set_Variable_Value___(route_id_, values_fetched_.route_id, default_route_id_);
               Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
               ext_transport_calendar_id_ := default_ext_transport_cal_id_;
               shipment_type_             := default_shipment_type_;
               delivery_leadtime_         := default_delivery_leadtime_;
               picking_leadtime_          := default_picking_leadtime_;
               Trace_SYS.Field('Inherit ship via from header', ship_via_code_);
            END IF;
         END IF;
      END IF;
   END IF;


   IF (ship_via_code_ IS NOT NULL) THEN
      IF (NOT(same_vendor_)) THEN
         Trace_SYS.Message('Fetch leadtime, distance and cost...');
         -- Fetch leadtime, distance, cost and ship via transit for the found ship via code
         Fetch_Line_Deliv_Attribs___(route_, fetched_forward_agent_id_, default_leadtime_, fetched_ext_trans_cal_id_, distance_, expected_additional_cost_, cost_curr_code_,
                                      internal_leadtime_, sc_matrix_record_found_, part_group_record_found_, freight_map_id_, zone_id_, fetched_picking_leadtime_, 
                                      vendor_picking_leadtime_, fetched_shipment_type_, ship_inventory_location_no_, fetched_delivery_terms_, fetched_del_terms_location_,
                                      transport_leadtime_, arrival_route_id_, contract_, customer_no_, ship_addr_no_, addr_flag_db_, part_no_, supply_code_, vendor_no_, NULL, ship_via_code_, agreement_id_, ship_via_code_changed_);
      END IF;
   END IF;

   -- Retrieve the default supplier ship via transit
   supplier_ship_via_transit_ := Get_Supplier_Ship_Via___(contract_, part_no_,
                                                          supply_code_, vendor_no_);

   -- Set delivery leadtime if not already assigned a value
   IF (delivery_leadtime_ IS NULL) THEN
      IF ((ship_via_code_ = default_ship_via_code_) AND (supply_code_ NOT IN ('IPD', 'PD')) AND
          (part_group_record_found_ = FALSE)) THEN
         -- If ship via code is the same as the order or package headers and the delivery is
         -- made from our inventory then inherit the delivery leadtime unless the delivery leadtime
         -- was retrieved from a rule for a supply chain part group
         -- If header supplier and line supplier is different then take the fetched delivery leadtime value.
         IF ((default_addr_flag_db_ = 'N') AND (addr_flag_db_ = 'N')) OR (NVL(vendor_no_, Database_SYS.string_null_) != NVL(header_vendor_no_, Database_SYS.string_null_)) THEN
            delivery_leadtime_ := default_leadtime_;
            ext_transport_calendar_id_ := fetched_ext_trans_cal_id_;
         ELSE
            delivery_leadtime_ := default_delivery_leadtime_;
            ext_transport_calendar_id_ := default_ext_transport_cal_id_;
         END IF;
      ELSIF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
         -- Prospect customer on a quotation. Inherit default leadtime
         -- In this case the ship via code could still be NULL.
         delivery_leadtime_ := default_delivery_leadtime_;
         ext_transport_calendar_id_ := default_ext_transport_cal_id_;
      ELSE
         -- Use the default delivery leadtime retrieved for the ship via code from the matrixes
         delivery_leadtime_ := default_leadtime_;
         ext_transport_calendar_id_ := fetched_ext_trans_cal_id_;
      END IF;
   END IF;

   -- Set picking leadtime if not already assigned a value
   IF (picking_leadtime_ IS NULL) THEN
      IF ((ship_via_code_ = default_ship_via_code_) AND (supply_code_ NOT IN ('IPD', 'PD')) AND
          (part_group_record_found_ = FALSE)) THEN
         -- If ship via code is the same as the order or package headers and the delivery is
         -- made from our inventory then inherit the picking leadtime 
         -- unless the picking leadtime was retrieved from a rule for a supply chain part group
         -- If header supplier and line supplier is different then take the fetched picking leadtime value.
         IF ((default_addr_flag_db_ = 'N') AND (addr_flag_db_ = 'N')) OR (NVL(vendor_no_, Database_SYS.string_null_) != NVL(header_vendor_no_, Database_SYS.string_null_)) THEN
            picking_leadtime_ := fetched_picking_leadtime_; 
         ELSE
            picking_leadtime_ := default_picking_leadtime_;
   END IF;
      ELSIF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
         -- Prospect customer on a quotation. Inherit picking leadtime
         -- In this case the ship via code could still be NULL.
         picking_leadtime_ := default_picking_leadtime_;
      ELSE
         -- Use the default picking leadtime retrieved for the ship via code from the matrixes
         picking_leadtime_ := fetched_picking_leadtime_;
      END IF;
   END IF;

   -- Set shipment type if not already assigned a value
   IF (shipment_type_ IS NULL) THEN
      IF ((ship_via_code_ = default_ship_via_code_) AND (supply_code_ NOT IN ('IPD', 'PD')) AND
          (part_group_record_found_ = FALSE)) THEN
         -- If ship via code is the same as the order or package headers and the delivery is
         -- made from our inventory then inherit the shipment type 
         -- unless the shipment type was retrieved from a rule for a supply chain part group
         -- If header supplier and line supplier is different then take the fetched shipment type value.
         IF ((default_addr_flag_db_ = 'N') AND (addr_flag_db_ = 'N')) OR (NVL(vendor_no_, Database_SYS.string_null_) != NVL(header_vendor_no_, Database_SYS.string_null_)) THEN
            shipment_type_ := fetched_shipment_type_; 
         ELSE
            shipment_type_ := default_shipment_type_;
         END IF;
      ELSIF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
         -- Prospect customer on a quotation. Inherit shipment type
         -- In this case the ship via code could still be NULL.
         shipment_type_ := default_shipment_type_;
      ELSE
         -- Use the default shipment type retrieved for the ship via code from the matrixes
         shipment_type_ := fetched_shipment_type_;
      END IF;
   END IF;

   -- Set the route if not already assigned a value
   IF (NOT values_fetched_.route_id) THEN
      IF ((ship_via_code_ = default_ship_via_code_) AND (supply_code_ NOT IN ('IPD', 'PD')) AND
          (part_group_record_found_ = FALSE)) THEN
         -- If header supplier and line supplier is different then take the fetched route_id value.
         IF ((default_addr_flag_db_ = 'N') AND (addr_flag_db_ = 'N')) OR (NVL(vendor_no_, Database_SYS.string_null_) != NVL(header_vendor_no_, Database_SYS.string_null_)) THEN
            route_id_ := route_;
         ELSE
            route_id_ := default_route_id_;
            Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
         END IF;
      ELSIF (customer_category_ = Customer_Category_API.DB_PROSPECT) THEN
         -- Prospect customer on a quotation. Inherit default leadtime
         -- In this case the ship via code could still be NULL.
         route_id_ := default_route_id_;
         Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
      ELSE
         route_id_ := route_;
      END IF;
   END IF;

-- Supply chain exceptions found, values need to be taken from there instead.
   IF (part_group_record_found_ = TRUE) THEN
      IF (fetched_delivery_terms_ IS NOT NULL) THEN
         -- delivery terms and del terms location needs to be fetched from the same source
         delivery_terms_ := fetched_delivery_terms_;
         del_terms_location_ := fetched_del_terms_location_;
      END IF;
      IF (fetched_forward_agent_id_ IS NOT NULL) THEN    
         Set_Variable_Value___(forward_agent_id_, values_fetched_.forward_agent_id, default_forward_agent_id_);
      END IF;
   END IF;
   
   IF (delivery_terms_ IS NULL ) THEN
      IF (delivery_terms_ IS NULL AND fetched_delivery_terms_ IS NOT NULL) THEN
         delivery_terms_     := fetched_delivery_terms_;  
         del_terms_location_ := fetched_del_terms_location_;
      END IF;
      IF (delivery_terms_ IS NULL AND default_delivery_terms_ IS NOT NULL) THEN
         delivery_terms_     := default_delivery_terms_;  
         del_terms_location_ := default_del_terms_location_;
      END IF;
   END IF;


   -- Set the forwarder if not already assigned a value
   IF (NOT values_fetched_.forward_agent_id) THEN
     IF (forward_agent_id_ IS NULL AND fetched_forward_agent_id_ IS NOT NULL) THEN    
        forward_agent_id_ := fetched_forward_agent_id_;
     END IF;

     IF forward_agent_id_ IS NULL THEN
        forward_agent_id_ := Delivery_Route_API.Get_Forward_Agent_Id(route_id_);
     END IF;

     IF forward_agent_id_ IS NULL THEN
        forward_agent_id_ :=  Cust_Ord_Customer_API.Get_Forward_Agent_Id(customer_no_);
     END IF;

     IF forward_agent_id_ IS NULL THEN
        forward_agent_id_ := Site_Discom_Info_API.Get_Forward_Agent_Id(contract_);
     END IF;
   END IF;

   IF (from_sourcing_ AND (NOT sc_matrix_record_found_)) THEN
      -- No supply chain data found in the matrixes set ship via code to NULL
      Trace_SYS.Message('No supply chain matrix data found ship via code set to NULL');
      ship_via_code_ := NULL;
   END IF;

   IF (from_sourcing_ AND sc_matrix_record_found_) THEN
      -- When called from automatic sourcing the totals for shipping time, cost and distance should
      -- be calculated and returned.

      IF (supplier_ship_via_transit_ IS NOT NULL) THEN
         -- Retrieve ship via values for transit delivery from supplier to our site
         Get_Transit_Ship_Via_Values___(transit_del_leadtime_, transit_distance_, transit_cost_, transit_cost_curr_code_,
                                        transit_int_leadtime_, vendor_picking_leadtime_, transit_route_id_, sc_matrix_record_found_, dummy_tansit_del_terms_,
                                        dummy_transit_del_term_loc_, transport_leadtime_, arrival_route_id_, contract_, part_no_, supply_code_,
                                        vendor_no_, supplier_ship_via_transit_);
         IF (NOT sc_matrix_record_found_) THEN
            -- No supply chain data found in the matrixes set supplier ship via transit to NULL
            Trace_SYS.Message('No supply chain matrix data found supplier ship via transit set to NULL');
            supplier_ship_via_transit_ := NULL;
         END IF;

      END IF;

      IF (sc_matrix_record_found_) THEN
         Get_Supply_Chain_Totals___(total_shipping_distance_,
                                    total_expected_cost_,
                                    total_shipping_time_,
                                    delivery_leadtime_,
                                    distance_,
                                    expected_additional_cost_,
                                    cost_curr_code_,
                                    internal_leadtime_,
                                    transit_del_leadtime_,
                                    picking_leadtime_,
                                    vendor_picking_leadtime_,
                                    transit_distance_,
                                    transit_cost_,
                                    transit_cost_curr_code_,
                                    transit_int_leadtime_,
                                    contract_,
                                    part_no_,
                                    purchase_part_no_,
                                    supply_code_,
                                    vendor_no_,
                                    transport_leadtime_);
      END IF;
   END IF;

   IF (ship_addr_no_changed_ = 'TRUE' AND NOT sc_matrix_record_found_ AND supply_code_ NOT IN ('PD', 'IPD')) THEN
      picking_leadtime_ := NVL(default_picking_leadtime_, picking_leadtime_);
      delivery_leadtime_ := NVL(default_delivery_leadtime_, delivery_leadtime_);
   END IF;
   
   -- freight map id and zone which is also part of the default info is not considered but it is the same behavior in Apps8.

   -- set order default flag to 'No' if the fetched values differ from the header's...
   IF (default_addr_flag_db_ = 'Y') THEN
      Trace_SYS.Message('Set order default flag');
      IF ((Validate_SYS.Is_Different(ship_via_code_,default_ship_via_code_)) OR
         (Validate_SYS.Is_Different(delivery_leadtime_,default_delivery_leadtime_)) OR
         (Validate_SYS.Is_Different(shipment_type_,default_shipment_type_)) OR 
         (Validate_SYS.Is_Different(route_id_,default_route_id_)) OR
         (Validate_SYS.Is_Different(picking_leadtime_,default_picking_leadtime_)) OR
         (Validate_SYS.Is_Different(delivery_terms_,default_delivery_terms_)) OR
         (Validate_SYS.Is_Different(del_terms_location_,default_del_terms_location_)) OR
         (Validate_SYS.Is_Different(ext_transport_calendar_id_,default_ext_transport_cal_id_)) OR
         (Validate_SYS.Is_Different(forward_agent_id_,default_forward_agent_id_))) THEN
         default_addr_flag_db_ := 'N';
      ELSE
         default_addr_flag_db_ := 'Y';
      END IF;
   END IF;
   forward_agent_id_ := NVL(forward_agent_id_, temp_forward_agent_id_);
   Trace_SYS.Field('order default', default_addr_flag_db_);
END Get_Supply_Chain_Defaults___;


-- Fetch_Line_Deliv_Attribs___
--   Returns the values for leadtimes, distance, cost, freight map id,
--   zone id, route, shipment type and forwarder for a known ship_via_code.
--   If the values are not found, zero (0) will be returned for all.
--   The logic is the same as for fetching default ship via code.
--   Fetch the values from the correct matrix depending on supply code,
--   supplier and customer.
PROCEDURE Fetch_Line_Deliv_Attribs___ (
   route_id_                   IN OUT VARCHAR2,
   forward_agent_id_           IN OUT VARCHAR2,
   delivery_leadtime_          IN OUT NUMBER,
   ext_transport_calendar_id_  IN OUT VARCHAR2,
   distance_                   IN OUT NUMBER,
   expected_additional_cost_   IN OUT NUMBER,
   cost_curr_code_             IN OUT VARCHAR2,
   internal_leadtime_          IN OUT NUMBER,
   sc_matrix_record_found_     IN OUT BOOLEAN,
   part_group_record_found_    IN OUT BOOLEAN,
   freight_map_id_             IN OUT VARCHAR2,
   zone_id_                    IN OUT VARCHAR2,
   picking_leadtime_           IN OUT NUMBER,
   vendor_picking_leadtime_    IN OUT NUMBER,
   shipment_type_              IN OUT VARCHAR2,
   ship_inventory_location_no_ IN OUT VARCHAR2,
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   transport_leadtime_         IN OUT NUMBER,
   arrival_route_id_           IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   supply_code_                IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   vendor_doc_addr_no_         IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,   
   agreement_id_               IN     VARCHAR2,
   ship_via_code_changed_      IN     VARCHAR2)
IS
   found_                   BOOLEAN := FALSE;
   part_group_found_        BOOLEAN := FALSE;
   custrec_                 Cust_Ord_Customer_API.Public_Rec;
   external_cust_           BOOLEAN;
   supply_site_             VARCHAR2(5) := NULL;
   vendor_addr_no_          SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE := NULL;
   vendor_ship_via_         VARCHAR2(3) := NULL;
   vendor_delivery_terms_   VARCHAR2(5) := NULL;
   vendor_del_term_loc_     VARCHAR2(100) := NULL;
   supp_category_           VARCHAR2(20) := NULL;
   supply_chain_part_group_ VARCHAR2(20) := NULL;
   leadrec_                 Customer_Address_Leadtime_API.Public_Rec;
   leadpartrec_             Cust_Addr_Part_Leadtime_API.Public_Rec;
   siteleadrec_             Site_To_Site_Leadtime_API.Public_Rec;
   sitepartrec_             Site_To_Site_Part_Leadtime_API.Public_Rec;
   supartleadrec_           Supp_To_Cust_Part_Leadtime_API.Public_Rec;
   suculeadrec_             Supp_To_Cust_Leadtime_API.Public_Rec;
   cust_addr_rec_           Cust_Ord_Customer_Address_API.Public_Rec;
   site_                    VARCHAR2(5);
   cust_agreement_rec_      Customer_Agreement_API.Public_Rec;
   $IF Component_Purch_SYS.INSTALLED $THEN
      supprec_             Supplier_API.Public_Rec;
      supp_addr_rec_       Supplier_Address_Leadtime_API.Public_Rec;
      supp_addr_part_rec_  Supp_Addr_Part_Leadtime_API.Public_Rec;
   $END   
   temp_forward_agent_id_   VARCHAR2(20);
   temp_delivery_terms_     VARCHAR2(5);
   temp_del_terms_location_ VARCHAR2(100);
   temp_route_id_           VARCHAR2(12);
   temp_shipment_type_     VARCHAR2(20);
   temp_picking_leadtime_  NUMBER;
   temp_delivery_leadtime_ NUMBER;  
BEGIN
   temp_forward_agent_id_ := forward_agent_id_;
   temp_delivery_terms_ := delivery_terms_;
   temp_del_terms_location_ := del_terms_location_;
   temp_route_id_ := route_id_;
   temp_shipment_type_     := shipment_type_;
   temp_picking_leadtime_  := picking_leadtime_;
   temp_delivery_leadtime_ := delivery_leadtime_;
   -- Fetch customer info
   custrec_       := Cust_Ord_Customer_API.Get(customer_no_);
   cust_addr_rec_ := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);
   external_cust_ := (NVL(custrec_.category, ' ') = 'E');

   -- Initialize internal leadtime because a value will not always be possible to retrieve
   internal_leadtime_ := NULL;

   -- Fetch supplier info
   -- If a supplier address was passed in the call use this, else retrieve the default supplier document address
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (vendor_no_ IS NOT NULL) THEN
         supprec_ := Supplier_API.Get(vendor_no_);
         supply_site_ := supprec_.acquisition_site;
         supp_category_ := supprec_.category;
         IF (vendor_doc_addr_no_ IS NOT NULL) THEN
            vendor_addr_no_ := vendor_doc_addr_no_;
         ELSE
            vendor_addr_no_ := Supplier_Address_API.Get_Address_No(vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
         END IF;
         Supplier_Address_API.Get_Delivery_Terms_Ship_Via(vendor_delivery_terms_, vendor_ship_via_, vendor_no_, vendor_addr_no_);
         vendor_del_term_loc_ := Supplier_Address_API.Get_Del_Terms_Location(vendor_no_, vendor_addr_no_);
      END IF;
      Trace_SYS.Field('fetched supply site', supply_site_);
   $END

   -- First check for single occurrence address. if supply code PD or IPD both single occurence and non single occurence it should behave same.
   IF (addr_flag_db_ = 'Y' AND (supply_code_ IS NULL OR supply_code_ NOT IN ('PD', 'IPD'))) THEN
      -- No values possible to retrieve for single occurrence adresses
      NULL;
   ELSIF (supply_code_ IS NOT NULL) THEN
      -- Retrieve defaults for order or quotation line
      -- Fetch part group
      IF (part_no_ IS NOT NULL) THEN
         supply_chain_part_group_ := Inventory_Part_API.Get_Supply_Chain_Part_Group(contract_, part_no_);
      END IF;
      -- Check for direct delivery
      IF (supply_code_ = 'PD') THEN
         -- Direct delivery from external supplier to external customer
         IF (external_cust_) THEN
            -- Using part group
            IF (supply_chain_part_group_ IS NOT NULL) THEN
               supartleadrec_            := Supp_To_Cust_Part_Leadtime_API.Get(customer_no_, ship_addr_no_, supply_chain_part_group_,
                                                                               vendor_no_, vendor_addr_no_, ship_via_code_);
               delivery_terms_           := supartleadrec_.delivery_terms;
               del_terms_location_       := supartleadrec_.del_terms_location;
               delivery_leadtime_        := supartleadrec_.delivery_leadtime;
               found_                    := (delivery_leadtime_ IS NOT NULL);
               IF found_ THEN
                  part_group_found_ := TRUE;
               END IF;
               distance_                 := supartleadrec_.distance;
               expected_additional_cost_ := supartleadrec_.expected_additional_cost;
               cost_curr_code_           := supartleadrec_.currency_code;
               freight_map_id_           := supartleadrec_.freight_map_id;
               zone_id_                  := supartleadrec_.zone_id;
            END IF;

            -- Without part group
            IF (NOT found_) THEN
               suculeadrec_              := Supp_To_Cust_Leadtime_API.Get(customer_no_, ship_addr_no_, vendor_no_,
                                                                          vendor_addr_no_, ship_via_code_);
               delivery_terms_           := suculeadrec_.delivery_terms;
               del_terms_location_       := suculeadrec_.del_terms_location;
               delivery_leadtime_        := suculeadrec_.delivery_leadtime;
               found_                    := (delivery_leadtime_ IS NOT NULL);
               distance_                 := suculeadrec_.distance;
               expected_additional_cost_ := suculeadrec_.expected_additional_cost;
               cost_curr_code_           := suculeadrec_.currency_code;
               freight_map_id_           := suculeadrec_.freight_map_id;
               zone_id_                  := suculeadrec_.zone_id;
            END IF;
         -- External supplier to internal customer (site)
         ELSE
            $IF Component_Purch_SYS.INSTALLED $THEN
               -- Using part group
               IF (supply_chain_part_group_ IS NOT NULL) THEN
                     supp_addr_part_rec_       := Supp_Addr_Part_Leadtime_API.Get(vendor_no_, vendor_addr_no_, supply_chain_part_group_, ship_via_code_, custrec_.acquisition_site);
                     delivery_terms_           := supp_addr_part_rec_.delivery_terms;
                     del_terms_location_       := supp_addr_part_rec_.del_terms_location;
                     delivery_leadtime_        := supp_addr_part_rec_.delivery_leadtime;
                     internal_leadtime_        := supp_addr_part_rec_.internal_delivery_leadtime;
                     distance_                 := supp_addr_part_rec_.distance;
                     expected_additional_cost_ := supp_addr_part_rec_.expected_additional_cost;
                     cost_curr_code_           := supp_addr_part_rec_.currency_code;
                     transport_leadtime_       := supp_addr_part_rec_.transport_leadtime;
                     arrival_route_id_         := supp_addr_part_rec_.route_id;
                     found_                    := (delivery_leadtime_ IS NOT NULL);
                  IF found_ THEN
                     part_group_found_ := TRUE;
                  END IF;
               END IF;
               -- Without part group
               IF NOT found_ THEN
                     supp_addr_rec_            := Supplier_Address_Leadtime_API.Get(vendor_no_, vendor_addr_no_, ship_via_code_, custrec_.acquisition_site);
                     delivery_terms_           := supp_addr_rec_.delivery_terms;
                     del_terms_location_       := supp_addr_rec_.del_terms_location;
                     delivery_leadtime_        := supp_addr_rec_.vendor_delivery_leadtime;
                     internal_leadtime_        := supp_addr_rec_.internal_delivery_leadtime;
                     distance_                 := supp_addr_rec_.distance;
                     expected_additional_cost_ := supp_addr_rec_.expected_additional_cost;
                     cost_curr_code_           := supp_addr_rec_.currency_code;
                     transport_leadtime_       := supp_addr_rec_.transport_leadtime;
                     arrival_route_id_         := supp_addr_rec_.route_id;
                  found_ := (delivery_leadtime_ IS NOT NULL);
               END IF;
            $ELSE
               NULL;
            $END            
         END IF;
         IF ( delivery_terms_ IS NULL ) THEN
            delivery_terms_ := vendor_delivery_terms_;
            del_terms_location_ := vendor_del_term_loc_;
         END IF;
      -- IPD and other
      ELSE
         -- if not internal direct delivery, our site is the supply site
         IF (supply_code_ = 'IPD') THEN
            site_ := supply_site_;
         ELSE
            site_ := contract_;
         END IF;
         -- using part group
         IF (external_cust_) THEN
            -- Delivery from our site or internal supplier site to external customer
            -- Using part group
            IF (supply_chain_part_group_ IS NOT NULL) THEN
               leadpartrec_              := Cust_Addr_Part_Leadtime_API.Get(customer_no_, ship_addr_no_, supply_chain_part_group_, site_, ship_via_code_);
               delivery_terms_           := leadpartrec_.delivery_terms;
               del_terms_location_       := leadpartrec_.del_terms_location;
               delivery_leadtime_        := leadpartrec_.delivery_leadtime;
               found_                    := (delivery_leadtime_ IS NOT NULL);
               IF found_ THEN
                  part_group_found_ := TRUE;
               END IF;
               distance_                 := leadpartrec_.distance;
               expected_additional_cost_ := leadpartrec_.expected_additional_cost;
               cost_curr_code_           := leadpartrec_.currency_code;
               freight_map_id_           := leadpartrec_.freight_map_id;
               zone_id_                  := leadpartrec_.zone_id;
               route_id_                 := leadpartrec_.route_id;
               forward_agent_id_         := leadpartrec_.forward_agent_id;
               forward_agent_id_         := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
	            picking_leadtime_         := leadpartrec_.picking_leadtime;
               shipment_type_            := leadpartrec_.shipment_type;
            END IF;
            -- Without part group
            IF (NOT found_) THEN
               leadrec_                    := Customer_Address_Leadtime_API.Get(customer_no_, ship_addr_no_, ship_via_code_, site_);
               delivery_terms_             := leadrec_.delivery_terms;
               del_terms_location_         := leadrec_.del_terms_location;
               delivery_leadtime_          := leadrec_.delivery_leadtime;
               found_                      := (delivery_leadtime_ IS NOT NULL);
               distance_                   := leadrec_.distance;
               expected_additional_cost_   := leadrec_.expected_additional_cost;
               cost_curr_code_             := leadrec_.currency_code;
               freight_map_id_             := leadrec_.freight_map_id;
               zone_id_                    := leadrec_.zone_id;
               route_id_                   := leadrec_.route_id;
               forward_agent_id_           := leadrec_.forward_agent_id;
               forward_agent_id_           := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
	            picking_leadtime_           := leadrec_.picking_leadtime;
               shipment_type_              := leadrec_.shipment_type;
               ship_inventory_location_no_ := leadrec_.ship_inventory_location_no; 
            END IF;

         ELSE
            -- Delivery from our site or internal supplier site to internal customer
            -- Using part group
            IF (supply_chain_part_group_ IS NOT NULL) THEN
               sitepartrec_              := Site_To_Site_Part_Leadtime_API.Get(custrec_.acquisition_site, site_, ship_via_code_, supply_chain_part_group_);
               delivery_terms_           := sitepartrec_.delivery_terms;
               del_terms_location_       := sitepartrec_.del_terms_location;
               delivery_leadtime_        := sitepartrec_.delivery_leadtime;
               found_                    := (delivery_leadtime_ IS NOT NULL);
               IF found_ THEN
                  part_group_found_ := TRUE;
               END IF;
               internal_leadtime_        := sitepartrec_.internal_delivery_leadtime;
               distance_                 := sitepartrec_.distance;
               expected_additional_cost_ := sitepartrec_.expected_additional_cost;
               cost_curr_code_           := sitepartrec_.currency_code;
               freight_map_id_           := sitepartrec_.freight_map_id;
               zone_id_                  := sitepartrec_.zone_id;
               route_id_                 := sitepartrec_.route_id;
               forward_agent_id_         := sitepartrec_.forward_agent_id;
               forward_agent_id_         := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
			      picking_leadtime_         := sitepartrec_.picking_leadtime;
               shipment_type_            := sitepartrec_.shipment_type;
               transport_leadtime_       := sitepartrec_.transport_leadtime;
               arrival_route_id_         := sitepartrec_.arrival_route_id;
            END IF;

            -- Without part group
            IF (NOT found_) THEN
               siteleadrec_                := Site_To_Site_Leadtime_API.Get(custrec_.acquisition_site, site_, ship_via_code_);
               delivery_terms_             := siteleadrec_.delivery_terms;
               del_terms_location_         := siteleadrec_.del_terms_location;
               delivery_leadtime_          := siteleadrec_.delivery_leadtime;
               found_                      := (delivery_leadtime_ IS NOT NULL);
               internal_leadtime_          := siteleadrec_.internal_delivery_leadtime;
               distance_                   := siteleadrec_.distance;
               expected_additional_cost_   := siteleadrec_.expected_additional_cost;
               cost_curr_code_             := siteleadrec_.exp_add_cost_curr_code;
               freight_map_id_             := siteleadrec_.freight_map_id;
               zone_id_                    := siteleadrec_.zone_id;
               route_id_                   := siteleadrec_.route_id;
               forward_agent_id_           := siteleadrec_.forward_agent_id;
               forward_agent_id_           := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
               picking_leadtime_           := siteleadrec_.picking_leadtime; 
               shipment_type_              := siteleadrec_.shipment_type; 
               ship_inventory_location_no_ := siteleadrec_.ship_inventory_location_no;
               transport_leadtime_         := siteleadrec_.transport_leadtime;
               arrival_route_id_           := siteleadrec_.arrival_route_id;
            END IF;
         END IF;

         IF (picking_leadtime_ IS NULL) THEN
             picking_leadtime_ := Site_Invent_Info_API.Get_Picking_Leadtime(site_);
            IF (NOT found_ AND (ship_via_code_changed_ = 'TRUE') AND temp_picking_leadtime_ IS NOT NULL) THEN
               picking_leadtime_ := temp_picking_leadtime_; 
            END IF;
         END IF;

         IF (supply_code_ = 'IPD') THEN
            IF (picking_leadtime_ IS NOT NULL) THEN
               vendor_picking_leadtime_ := picking_leadtime_;
            END IF;
         END IF;

         IF (route_id_ IS NULL) THEN
            IF (NOT (found_) OR (ship_via_code_ = cust_addr_rec_.ship_via_code)) THEN
               route_id_ := cust_addr_rec_.route_id;
               route_id_ := NVL(route_id_, temp_route_id_);
            END IF;
            forward_agent_id_ := NVL(Delivery_Route_API.Get_Forward_Agent_Id(route_id_), forward_agent_id_);
         END IF;
         
         IF (( delivery_terms_ IS NULL ) AND (supply_code_ = 'IPD')) THEN
            delivery_terms_     := vendor_delivery_terms_;
            del_terms_location_ := vendor_del_term_loc_;
         ELSIF (delivery_terms_ IS NULL) THEN           
            IF (found_ OR temp_delivery_terms_ IS NULL) THEN
               delivery_terms_ := cust_addr_rec_.delivery_terms;
               del_terms_location_ := cust_addr_rec_.del_terms_location;
            ELSE
               delivery_terms_ :=  temp_delivery_terms_;
               del_terms_location_ := temp_del_terms_location_;
            END IF;
         END IF;
      END IF;
      IF agreement_id_ IS NOT NULL THEN
         cust_agreement_rec_    := Customer_Agreement_API.Get(agreement_id_);
         IF (cust_agreement_rec_.ship_via_code = ship_via_code_) AND (supply_code_ NOT IN ('IPD','PD')) THEN
            IF (delivery_terms_ IS NULL AND cust_agreement_rec_.delivery_terms IS NOT NULL) THEN
               delivery_terms_     := cust_agreement_rec_.delivery_terms;
               del_terms_location_ := cust_agreement_rec_.del_terms_location;
               found_ := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;

   IF (NOT found_ AND ship_via_code_changed_ = 'TRUE' AND temp_delivery_leadtime_ IS NOT NULL) THEN
      delivery_leadtime_ := temp_delivery_leadtime_;
   END IF;
   
   IF (NOT found_) THEN
      -- Set default return values
      internal_leadtime_        := NULL;
      distance_                 := NULL;
      expected_additional_cost_ := NULL;
      cost_curr_code_           := NULL;
   END IF;

   IF picking_leadtime_ IS NULL THEN
      picking_leadtime_ := NVL(Site_Invent_Info_API.Get_Picking_Leadtime(NVL(site_, contract_)), 0);
   END IF;

   IF vendor_picking_leadtime_ IS NULL THEN
      vendor_picking_leadtime_ := 0;
   END IF;
   
   IF (shipment_type_ IS NULL) THEN
         shipment_type_ := NVL(NVL(cust_addr_rec_.shipment_type, Site_Discom_Info_API.Get_Shipment_Type(NVL(site_, contract_))), 'NA');
      IF (NOT found_ AND (ship_via_code_changed_ = 'TRUE') AND temp_shipment_type_ IS NOT NULL) THEN
         shipment_type_ := temp_shipment_type_;
      END IF;
   END IF;  
   
   IF (ship_inventory_location_no_ IS NULL) THEN
      ship_inventory_location_no_ := Site_Discom_Info_API.Get_Ship_Inventory_Location_No(NVL(site_, contract_));
   END IF;
   
   -- Set the return value indicating if values where found in the matrixes or were defaulted
   sc_matrix_record_found_ := found_;
   part_group_record_found_:= part_group_found_;

   ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(ship_via_code_);
   
   IF (NOT found_ AND ship_via_code_changed_ = 'TRUE' AND temp_forward_agent_id_ IS NOT NULL) THEN
      forward_agent_id_ := NVL(forward_agent_id_ ,temp_forward_agent_id_);
   END IF;
   
   IF forward_agent_id_ IS NULL THEN
      forward_agent_id_ :=  Cust_Ord_Customer_API.Get_Forward_Agent_Id(customer_no_);
   END IF;

   IF forward_agent_id_ IS NULL THEN
      forward_agent_id_ := Site_Discom_Info_API.Get_Forward_Agent_Id(contract_);
   END IF;
   IF delivery_leadtime_ IS NULL THEN
      delivery_leadtime_ := 0;
   END IF;
END Fetch_Line_Deliv_Attribs___;


-- Fetch_Head_Deliv_Attribs___
--   Returns the values for leadtimes, freight map id,
--   zone id, route, shipment type and forwarder for a known ship_via_code to
--   use in Customer Order / Quotation.
--   If the values are not found, zero (0) will be returned for all.
--   The logic is the same as for fetching default ship via code.
--   Fetch the values from the correct matrix depending on supply code,
--   supplier and customer.
PROCEDURE Fetch_Head_Deliv_Attribs___ (
   route_id_                   IN OUT VARCHAR2,
   forward_agent_id_           IN OUT VARCHAR2,
   delivery_leadtime_          IN OUT NUMBER,
   ext_transport_calendar_id_  IN OUT VARCHAR2,
   sc_matrix_record_found_     IN OUT BOOLEAN,
   freight_map_id_             IN OUT VARCHAR2,
   zone_id_                    IN OUT VARCHAR2,
   picking_leadtime_           IN OUT NUMBER,
   vendor_picking_leadtime_    IN OUT NUMBER,
   shipment_type_              IN OUT VARCHAR2,
   ship_inventory_location_no_ IN OUT VARCHAR2,
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   ship_via_code_changed_      IN     VARCHAR2)
IS 
   found_                   BOOLEAN := FALSE;
   external_supp_           BOOLEAN := FALSE;
   external_cust_           BOOLEAN;   
   supply_site_             VARCHAR2(5)  := NULL;
   vendor_ship_via_         VARCHAR2(3)  := NULL;
   vendor_delivery_terms_   VARCHAR2(5)  := NULL;
   supp_category_           VARCHAR2(20) := NULL;
   site_                    VARCHAR2(5);
   vendor_addr_no_          SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE := NULL;
   custrec_                 Cust_Ord_Customer_API.Public_Rec;
   cust_addr_rec_           Cust_Ord_Customer_Address_API.Public_Rec;
   suculeadrec_             Supp_To_Cust_Leadtime_API.Public_Rec;
   leadrec_                 Customer_Address_Leadtime_API.Public_Rec;
   siteleadrec_             Site_To_Site_Leadtime_API.Public_Rec;
   temp_forward_agent_id_   VARCHAR2(20);
   temp_delivery_terms_     VARCHAR2(5);
   temp_del_terms_location_ VARCHAR2(100);
   temp_route_id_           VARCHAR2(12);
   temp_shipment_type_     VARCHAR2(20);
   temp_delivery_leadtime_ NUMBER;
   temp_picking_leadtime_  NUMBER;
BEGIN
   temp_forward_agent_id_ := forward_agent_id_;
   temp_delivery_terms_ := delivery_terms_;
   temp_del_terms_location_ := del_terms_location_;
   temp_route_id_ := route_id_; 
   temp_shipment_type_     := shipment_type_;
   temp_delivery_leadtime_ := delivery_leadtime_;
   temp_picking_leadtime_  := picking_leadtime_;
   -- Fetch customer info
   custrec_       := Cust_Ord_Customer_API.Get(customer_no_);
   cust_addr_rec_ := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);
   external_cust_ := (NVL(custrec_.category, Database_SYS.string_null_) = 'E');

   -- Fetch supplier info
   IF (vendor_no_ IS NOT NULL) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         DECLARE
            supprec_             Supplier_API.Public_Rec;
         BEGIN
            supprec_ := Supplier_API.Get(vendor_no_);
            supply_site_ := supprec_.acquisition_site;
            supp_category_ := supprec_.category;
            vendor_addr_no_ := Supplier_Address_API.Get_Address_No(vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
            Supplier_Address_API.Get_Delivery_Terms_Ship_Via(vendor_delivery_terms_, vendor_ship_via_, vendor_no_, vendor_addr_no_);
         END;
      $ELSE
         NULL;
      $END
      external_supp_ := (NVL(supp_category_, Database_SYS.string_null_) = 'E');
      Trace_SYS.Field('fetched supply site', supply_site_);
   END IF;
      
   IF (addr_flag_db_ = 'Y') THEN
      -- No values possible to retrieve for single occurrence addresses
      NULL;
   ELSE
      -- Defaults for order or quotation header
      IF (vendor_no_ IS NOT NULL) THEN
         IF (external_supp_) THEN
            site_ := contract_;
         ELSE
            site_ := supply_site_;
         END IF;         
         
         IF (external_cust_) THEN
            IF (external_supp_) THEN
               -- supplier to external customer
               suculeadrec_    := Supp_To_Cust_Leadtime_API.Get(customer_no_, ship_addr_no_, vendor_no_, vendor_addr_no_, ship_via_code_);
               delivery_terms_           := suculeadrec_.delivery_terms;
               del_terms_location_       := suculeadrec_.del_terms_location;
               delivery_leadtime_        := suculeadrec_.delivery_leadtime;
               found_                    := (delivery_leadtime_ IS NOT NULL);
               freight_map_id_           := suculeadrec_.freight_map_id;
               zone_id_                  := suculeadrec_.zone_id;
            ELSE
               --  site to external customer
               leadrec_                    := Customer_Address_Leadtime_API.Get(customer_no_, ship_addr_no_, ship_via_code_, supply_site_);
               delivery_terms_             := leadrec_.delivery_terms;
               del_terms_location_         := leadrec_.del_terms_location;
               delivery_leadtime_          := leadrec_.delivery_leadtime;
               found_                      := (delivery_leadtime_ IS NOT NULL);              
               freight_map_id_             := leadrec_.freight_map_id;
               zone_id_                    := leadrec_.zone_id;
               route_id_                   := leadrec_.route_id;
               forward_agent_id_           := leadrec_.forward_agent_id;
               forward_agent_id_           := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
               picking_leadtime_           := leadrec_.picking_leadtime;
               shipment_type_              := leadrec_.shipment_type;
               ship_inventory_location_no_ := leadrec_.ship_inventory_location_no;
            END IF;
         ELSE
            -- External supplier to internal customer (site)
            IF (external_supp_) THEN 
               $IF Component_Purch_SYS.INSTALLED $THEN
                  DECLARE
                     suppleadrec_             Supplier_Address_Leadtime_API.Public_Rec;
                  BEGIN                    
                     suppleadrec_              := Supplier_Address_Leadtime_API.Get(vendor_no_, vendor_addr_no_, ship_via_code_,  custrec_.acquisition_site);
                     delivery_terms_           := suppleadrec_.delivery_terms;
                     del_terms_location_       := suppleadrec_.del_terms_location;
                     delivery_leadtime_        := suppleadrec_.vendor_delivery_leadtime;
                     found_                    := (delivery_leadtime_ IS NOT NULL);
                  END;
               $ELSE
                  NULL;
               $END
            -- Our site to internal customer (site)
            ELSE            
               siteleadrec_                := Site_To_Site_Leadtime_API.Get(custrec_.acquisition_site, contract_, ship_via_code_);
               delivery_terms_             := siteleadrec_.delivery_terms;
               del_terms_location_         := siteleadrec_.del_terms_location;
               delivery_leadtime_          := siteleadrec_.delivery_leadtime;
               found_                      := (delivery_leadtime_ IS NOT NULL);
               freight_map_id_             := siteleadrec_.freight_map_id;
               zone_id_                    := siteleadrec_.zone_id;
               route_id_                   := siteleadrec_.route_id;
               forward_agent_id_           := siteleadrec_.forward_agent_id;
               forward_agent_id_           := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
               picking_leadtime_           := siteleadrec_.picking_leadtime;
               shipment_type_              := siteleadrec_.shipment_type;
               ship_inventory_location_no_ := siteleadrec_.ship_inventory_location_no;
            END IF;
         END IF;
      ELSE
         -- Defaults for order or quotation header
         -- Our site to external customer
         IF (external_cust_) THEN
            leadrec_                    := Customer_Address_Leadtime_API.Get(customer_no_, ship_addr_no_, ship_via_code_, contract_);
            delivery_terms_             := leadrec_.delivery_terms;
            del_terms_location_         := leadrec_.del_terms_location;
            delivery_leadtime_          := leadrec_.delivery_leadtime;
            found_                      := (delivery_leadtime_ IS NOT NULL);
            freight_map_id_             := leadrec_.freight_map_id;
            zone_id_                    := leadrec_.zone_id;
            route_id_                   := leadrec_.route_id;
            forward_agent_id_           := leadrec_.forward_agent_id;
            forward_agent_id_           := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
            picking_leadtime_           := leadrec_.picking_leadtime;
            shipment_type_              := leadrec_.shipment_type;
            ship_inventory_location_no_ := leadrec_.ship_inventory_location_no;
         -- Our site to internal customer (site)
         ELSE
            siteleadrec_                := Site_To_Site_Leadtime_API.Get(custrec_.acquisition_site, contract_, ship_via_code_);
            delivery_terms_             := siteleadrec_.delivery_terms;
            del_terms_location_         := siteleadrec_.del_terms_location;
            delivery_leadtime_          := siteleadrec_.delivery_leadtime;
            found_                      := (delivery_leadtime_ IS NOT NULL);
            freight_map_id_             := siteleadrec_.freight_map_id;
            zone_id_                    := siteleadrec_.zone_id;
            route_id_                   := siteleadrec_.route_id;
            forward_agent_id_           := siteleadrec_.forward_agent_id;
            forward_agent_id_           := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
            picking_leadtime_           := siteleadrec_.picking_leadtime;
            shipment_type_              := siteleadrec_.shipment_type;
            ship_inventory_location_no_ := siteleadrec_.ship_inventory_location_no;
         END IF;   
      END IF;
      IF (picking_leadtime_ IS NULL) THEN
         picking_leadtime_ := Site_Invent_Info_API.Get_Picking_Leadtime(NVL(site_, contract_));
         IF (NOT found_ AND (ship_via_code_changed_ = 'TRUE') AND temp_picking_leadtime_ IS NOT NULL) THEN
            picking_leadtime_ := temp_picking_leadtime_;
         END IF;
      END IF;

      IF (route_id_ IS NULL) THEN
         IF (NOT (found_) OR (ship_via_code_ = cust_addr_rec_.ship_via_code)) THEN
               route_id_ := cust_addr_rec_.route_id;
               route_id_ := NVL(route_id_, temp_route_id_);
         END IF;
         forward_agent_id_ := NVL(Delivery_Route_API.Get_Forward_Agent_Id(route_id_), forward_agent_id_);
      END IF;
      
      IF delivery_terms_ IS NULL THEN
         IF (found_ OR temp_delivery_terms_ IS NULL) THEN
            delivery_terms_ := Cust_Ord_Customer_Address_Api.Get_Delivery_Terms( customer_no_, ship_addr_no_);
            del_terms_location_ := Cust_Ord_Customer_Address_API.Get_Del_Terms_Location(customer_no_, ship_addr_no_);
         ELSE
            delivery_terms_ :=  temp_delivery_terms_;
            del_terms_location_ := temp_del_terms_location_;
         END IF;
      END IF;
   END IF;
   
   IF (NOT found_ AND ship_via_code_changed_ = 'TRUE' AND temp_delivery_leadtime_ IS NOT NULL) THEN
      delivery_leadtime_        := temp_delivery_leadtime_;
   END IF;

   IF delivery_leadtime_ IS NULL THEN
      delivery_leadtime_ := 0; 
   END IF;
   
   IF picking_leadtime_ IS NULL THEN
      picking_leadtime_ := 0;
   END IF;

   IF vendor_picking_leadtime_ IS NULL THEN
      vendor_picking_leadtime_ := 0;
   END IF;
   
   IF (shipment_type_ IS NULL) THEN
      shipment_type_ := NVL(NVL(cust_addr_rec_.shipment_type, Site_Discom_Info_API.Get_Shipment_Type(NVL(site_, contract_))), 'NA');
      IF (NOT found_ AND (ship_via_code_changed_ = 'TRUE') AND temp_shipment_type_ IS NOT NULL) THEN
         shipment_type_ := temp_shipment_type_;
      END IF;
   END IF;  
   
   IF (ship_inventory_location_no_ IS NULL) THEN
      ship_inventory_location_no_ := Site_Discom_Info_API.Get_Ship_Inventory_Location_No(NVL(site_, contract_));
   END IF;
   
   -- Set the return value indicating if values where found in the matrixes or were defaulted
   sc_matrix_record_found_ := found_;

   ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(ship_via_code_);
   
   IF (NOT found_ AND ship_via_code_changed_ = 'TRUE' AND temp_forward_agent_id_ IS NOT NULL ) THEN
     forward_agent_id_ := NVL(forward_agent_id_ ,temp_forward_agent_id_);
   END IF;
   
   IF forward_agent_id_ IS NULL THEN
      forward_agent_id_ :=  Cust_Ord_Customer_API.Get_Forward_Agent_Id(customer_no_);
   END IF;
   
   IF forward_agent_id_ IS NULL THEN
      forward_agent_id_ := Site_Discom_Info_API.Get_Forward_Agent_Id(contract_);
   END IF;
END Fetch_Head_Deliv_Attribs___;


-- Get_Supplier_Ship_Via___
--   Returns the default ship via code from external or internal suppliers for
--   transit deliveries.
FUNCTION Get_Supplier_Ship_Via___ (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   supply_code_   IN VARCHAR2,
   vendor_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
   vendor_ship_via_           VARCHAR2(3) := NULL;
   vendor_addr_no_            SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE := NULL;
   supp_category_             VARCHAR2(20) := NULL;
   external_supp_             BOOLEAN := FALSE;
   supply_site_               VARCHAR2(5) := NULL;
   supply_chain_part_group_   VARCHAR2(20) := NULL;
   supplier_ship_via_transit_ VARCHAR2(3) := NULL;
   $IF Component_Purch_SYS.INSTALLED $THEN
      supprec_             Supplier_API.Public_Rec;
      delivery_terms_      VARCHAR2(5);
   $END   
BEGIN
   -- Fetch supplier info
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (vendor_no_ IS NOT NULL) THEN
         supprec_ := Supplier_API.Get(vendor_no_);
         supply_site_ := supprec_.acquisition_site;
         supp_category_ := supprec_.category;
         vendor_addr_no_ := Supplier_Address_API.Get_Address_No(vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
         Supplier_Address_API.Get_Delivery_Terms_Ship_Via(delivery_terms_, vendor_ship_via_, vendor_no_, vendor_addr_no_);

      external_supp_ := (nvl(supp_category_, ' ') = 'E');
   END IF;
   $END

   supply_chain_part_group_ := Inventory_Part_API.Get_Supply_Chain_Part_Group(contract_, part_no_);

   IF (supply_code_ IS NULL) THEN
      -- When retrieving defaults for order or quotation header.
      supplier_ship_via_transit_ := NULL;
   ELSIF supply_code_ IN ('IPT', 'PT') THEN
      -- From supply chain matrix
      -- External supplier to our site
      IF external_supp_ THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
         IF (supply_chain_part_group_ IS NOT NULL) THEN
               supplier_ship_via_transit_ := Supp_Addr_Part_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_, supply_chain_part_group_, contract_);               
            Trace_SYS.Field('Transit ship via from supplier-to-site (part group)', supplier_ship_via_transit_);
         END IF;

         IF (supplier_ship_via_transit_ IS NULL) THEN
               supplier_ship_via_transit_ := Supplier_Address_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_, contract_);
            Trace_SYS.Field('Transit ship via from supplier-to-site', supplier_ship_via_transit_);
         END IF;
         $ELSE
            NULL;
         $END
      -- internal supplier (site) to our site
      ELSIF NOT external_supp_ THEN
         Trace_SYS.Field('supply site', supply_site_);

         IF (supply_chain_part_group_ IS NOT NULL) THEN
            supplier_ship_via_transit_ := Site_To_Site_Part_Leadtime_API.Get_Default_Ship_Via_Code(contract_, supply_site_, supply_chain_part_group_);
            Trace_SYS.Message('Transit ship via from site-to-site (part group)');
         END IF;

         IF (supplier_ship_via_transit_ IS NULL) THEN
            supplier_ship_via_transit_ := Site_To_Site_Leadtime_API.Get_Default_Ship_Via_Code(contract_, supply_site_);
            Trace_SYS.Message('Transit ship via from site-to-site');
         END IF;
      END IF;

      -- Inherit from supplier
      IF (supplier_ship_via_transit_ IS NULL) THEN
         supplier_ship_via_transit_ := vendor_ship_via_;
         Trace_SYS.Message('Inherit transit ship via from supplier address');
      END IF;

   ELSE
      -- Not IPT or PT set ship via transit to NULL
      supplier_ship_via_transit_ := NULL;
   END IF;

   Trace_SYS.Field('ship_via_transit_', supplier_ship_via_transit_);

   RETURN supplier_ship_via_transit_;

END Get_Supplier_Ship_Via___;


-- Get_Transit_Ship_Via_Values___
--   Returns the supply chain parameter values for the transit delivery
--   from a supplier using the specified ship via code.
PROCEDURE Get_Transit_Ship_Via_Values___ (
   transit_del_leadtime_      IN OUT NUMBER,
   transit_distance_          IN OUT NUMBER,
   transit_cost_              IN OUT NUMBER,
   cost_curr_code_            IN OUT VARCHAR2,
   transit_int_leadtime_      IN OUT NUMBER,
   transit_picking_leadtime_  IN OUT NUMBER,
   transit_route_id_          IN OUT VARCHAR2,
   sc_matrix_record_found_    IN OUT BOOLEAN,
   supplier_del_terms_        IN OUT VARCHAR2,
   supp_del_terms_location_   IN OUT VARCHAR2,
   transport_leadtime_        IN OUT NUMBER,
   arrival_route_id_          IN OUT VARCHAR2,
   contract_                  IN     VARCHAR2,
   part_no_                   IN     VARCHAR2,
   supply_code_               IN     VARCHAR2,
   vendor_no_                 IN     VARCHAR2,
   supplier_ship_via_transit_ IN     VARCHAR2 )
IS
   stmt_                    VARCHAR2(2000);
   vendor_addr_no_          SUPPLIER_INFO_ADDRESS_PUBLIC.address_id%TYPE;
   supp_category_           VARCHAR2(20);
   supply_site_             VARCHAR2(5);
   supply_chain_part_group_ VARCHAR2(20);
   siteleadrec_             Site_To_Site_Leadtime_API.Public_Rec;
   sitepartrec_             Site_To_Site_Part_Leadtime_API.Public_Rec;
   found_                   BOOLEAN := FALSE;
   forward_agent_id_        VARCHAR2(20);

   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_rec_ Supplier_API.Public_Rec;
   $END   
BEGIN

   supply_chain_part_group_ := Inventory_Part_API.Get_Supply_Chain_Part_Group(contract_, part_no_);

   -- Retrieve default supplier address and supplier site if internal supplier
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (vendor_no_ IS NOT NULL) THEN
         supplier_rec_   := Supplier_API.Get(vendor_no_);
         supply_site_    := supplier_rec_.acquisition_site;
         supp_category_  := supplier_rec_.category;
         vendor_addr_no_ := Supplier_Address_API.Get_Address_No(vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
   END IF;
   $END   
   -- Supply code should be either 'PT' or 'IPT'
   IF (supply_code_ = 'PT') THEN
      -- External supplier to our site
      -- Using part group
      IF (supply_chain_part_group_ IS NOT NULL) THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
            DECLARE
               leadtime_rec_ Supp_Addr_Part_Leadtime_API.Public_Rec;
            BEGIN
               leadtime_rec_            := Supp_Addr_Part_Leadtime_API.Get(vendor_no_, vendor_addr_no_, supply_chain_part_group_, supplier_ship_via_transit_, contract_);
               supplier_del_terms_      := leadtime_rec_.delivery_terms;
               supp_del_terms_location_ := leadtime_rec_.del_terms_location; 
               transit_del_leadtime_    := leadtime_rec_.delivery_leadtime;
               transit_int_leadtime_    := leadtime_rec_.internal_delivery_leadtime;
               transit_distance_        := leadtime_rec_.distance;
               transit_cost_            := leadtime_rec_.expected_additional_cost;
               cost_curr_code_          := leadtime_rec_.currency_code;
               transport_leadtime_      := leadtime_rec_.transport_leadtime;
               arrival_route_id_        := leadtime_rec_.route_id;
               found_                   := (transit_del_leadtime_ IS NOT NULL);
            END;
         $ELSE
            NULL;
         $END
      END IF;

      -- Without part group
      IF NOT found_ THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
            DECLARE
               leadtime_rec_ Supplier_Address_Leadtime_API.Public_Rec;
            BEGIN
               leadtime_rec_            := Supplier_Address_Leadtime_API.Get(vendor_no_, vendor_addr_no_, supplier_ship_via_transit_, contract_);
               supplier_del_terms_      := leadtime_rec_.delivery_terms;
               supp_del_terms_location_ := leadtime_rec_.del_terms_location; 
               transit_del_leadtime_    := leadtime_rec_.vendor_delivery_leadtime;
               transit_int_leadtime_    := leadtime_rec_.internal_delivery_leadtime;
               transit_distance_        := leadtime_rec_.distance;
               transit_cost_            := leadtime_rec_.expected_additional_cost;
               cost_curr_code_          := leadtime_rec_.currency_code;
               transport_leadtime_      := leadtime_rec_.transport_leadtime;
               arrival_route_id_        := leadtime_rec_.route_id;
               found_                   := (transit_del_leadtime_ IS NOT NULL);
            END;
         $ELSE
            NULL;
         $END
      END IF;
   ELSIF (supply_code_ = 'IPT') THEN
      -- Delivery from supplier site to our site

      -- Using part group
      IF (supply_chain_part_group_ IS NOT NULL) THEN
         sitepartrec_              := Site_To_Site_Part_Leadtime_API.Get(contract_, supply_site_, supplier_ship_via_transit_, supply_chain_part_group_);
         supplier_del_terms_       := sitepartrec_.delivery_terms;
         supp_del_terms_location_  := sitepartrec_.del_terms_location; 
         transit_del_leadtime_     := sitepartrec_.delivery_leadtime;
         found_                    := (transit_del_leadtime_ IS NOT NULL);
         transit_int_leadtime_     := sitepartrec_.internal_delivery_leadtime;
         transit_distance_         := sitepartrec_.distance;
         transit_cost_             := sitepartrec_.expected_additional_cost;
         cost_curr_code_           := sitepartrec_.currency_code;
         transit_picking_leadtime_ := NVL(sitepartrec_.picking_leadtime, Site_Invent_Info_API.Get_Picking_Leadtime(supply_site_));
         transit_route_id_         := sitepartrec_.route_id;
         forward_agent_id_         := sitepartrec_.forward_agent_id;
         transport_leadtime_       := sitepartrec_.transport_leadtime;
         arrival_route_id_         := sitepartrec_.arrival_route_id;
         forward_agent_id_         := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(transit_route_id_));
      END IF;

      -- Without part group
      IF (NOT found_) THEN
         siteleadrec_              := Site_To_Site_Leadtime_API.Get(contract_, supply_site_, supplier_ship_via_transit_);
         supplier_del_terms_       := siteleadrec_.delivery_terms;
         supp_del_terms_location_  := siteleadrec_.del_terms_location; 
         transit_del_leadtime_     := siteleadrec_.delivery_leadtime;
         found_                    := (transit_del_leadtime_ IS NOT NULL);
         transit_int_leadtime_     := siteleadrec_.internal_delivery_leadtime;
         transit_distance_         := siteleadrec_.distance;
         transit_cost_             := siteleadrec_.expected_additional_cost;
         cost_curr_code_           := siteleadrec_.exp_add_cost_curr_code;
         transit_picking_leadtime_ := NVL(siteleadrec_.picking_leadtime, Site_Invent_Info_API.Get_Picking_Leadtime(supply_site_));
         transit_route_id_         := siteleadrec_.route_id;
         forward_agent_id_         := siteleadrec_.forward_agent_id;
         transport_leadtime_       := siteleadrec_.transport_leadtime;
         arrival_route_id_         := siteleadrec_.arrival_route_id;
         forward_agent_id_         := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(transit_route_id_));
      END IF;
   END IF;

   IF (NOT found_) THEN
      transit_del_leadtime_    := 0;
      transit_int_leadtime_    := NULL;
      transit_distance_        := NULL;
      transit_cost_            := NULL;
      cost_curr_code_          := NULL;
      transit_route_id_        := NULL;
      supplier_del_terms_      := NULL;
      supp_del_terms_location_ := NULL;
   END IF;

   -- Return flag indicating if a value was found in the matrixes or not
   sc_matrix_record_found_ := found_;

END Get_Transit_Ship_Via_Values___;


-- Get_Supply_Chain_Totals___
--   Calculate the total shipping distance, expected additional cost and
--   shipping time given supply chain parameter values for delivery to customer
--   and possibly for transit delivery to our site from external or internal
PROCEDURE Get_Supply_Chain_Totals___ (
   total_shipping_distance_  IN OUT NUMBER,
   total_expected_cost_      IN OUT NUMBER,
   total_shipping_time_      IN OUT NUMBER,
   delivery_leadtime_        IN     NUMBER,
   distance_                 IN     NUMBER,
   expected_additional_cost_ IN     NUMBER,
   cost_curr_code_           IN     VARCHAR2,
   internal_leadtime_        IN     NUMBER,
   transit_del_leadtime_     IN     NUMBER,
   picking_leadtime_         IN     NUMBER,
   vendor_picking_leadtime_  IN     NUMBER,
   transit_distance_         IN     NUMBER,
   transit_cost_             IN     NUMBER,
   transit_cost_curr_code_   IN     VARCHAR2,
   transit_int_leadtime_     IN     NUMBER,
   contract_                 IN     VARCHAR2,
   part_no_                  IN     VARCHAR2,
   purchase_part_no_         IN     VARCHAR2,
   supply_code_              IN     VARCHAR2,
   vendor_no_                IN     VARCHAR2,
   transport_leadtime_       IN     NUMBER )
IS
   company_                       VARCHAR2(20);
   base_curr_code_                VARCHAR2(3);
   curr_type_                     VARCHAR2(10);
   conv_factor_                   NUMBER;
   rate_                          NUMBER;
   cost_base_curr_                NUMBER;
   transit_cost_base_curr_        NUMBER;
   site_date_                     DATE;
   internal_control_time_         NUMBER;
   supply_site_                   VARCHAR2(5) := NULL;
   vendor_manuf_leadtime_         NUMBER;
   expected_leadtime_             NUMBER;
   inventory_part_at_supply_site_ BOOLEAN;
   inventory_part_at_demand_site_ BOOLEAN;
   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_rec_               Supplier_API.Public_Rec;
   $END
BEGIN

   --
   -- Total shipping distance
   --
   total_shipping_distance_ := NVL(distance_, 0) + NVL(transit_distance_, 0);

   --
   -- Total shipping cost
   --
   company_ := Site_API.Get_Company(contract_);
   site_date_ := Site_API.Get_Site_Date(contract_);
   base_curr_code_ := Company_Finance_API.Get_Currency_Code(company_);

   IF (expected_additional_cost_ IS NULL) THEN
      cost_base_curr_ := 0;
   ELSIF ((expected_additional_cost_ = 0) OR (cost_curr_code_ = base_curr_code_)) THEN
      cost_base_curr_ := expected_additional_cost_;
   ELSE
      Currency_Rate_API.Get_Currency_Rate_Defaults(curr_type_,
                                                   conv_factor_, 
                                                   rate_, 
                                                   company_, 
                                                   cost_curr_code_, 
                                                   site_date_);
      rate_ := rate_ / conv_factor_;
      cost_base_curr_ := expected_additional_cost_ * rate_;
   END IF;

   IF (transit_cost_ IS NULL) THEN
      transit_cost_base_curr_ := 0;
   ELSIF ((transit_cost_ = 0) OR (transit_cost_curr_code_ = base_curr_code_)) THEN
      transit_cost_base_curr_ := transit_cost_;
   ELSE
      Currency_Rate_API.Get_Currency_Rate_Defaults(curr_type_, 
                                                   conv_factor_, 
                                                   rate_, 
                                                   company_, 
                                                   transit_cost_curr_code_, 
                                                   site_date_);
      
      rate_ := rate_ / conv_factor_;
      transit_cost_base_curr_ := transit_cost_ * rate_;
   END IF;

   total_expected_cost_:= cost_base_curr_ + transit_cost_base_curr_;

   --
   -- Total shipping leadtime
   --

   -- Retrieve leadtimes needed for the calculation
   Get_Other_Leadtimes___(internal_control_time_,vendor_manuf_leadtime_, 
                          expected_leadtime_, vendor_no_, contract_, part_no_,
                          purchase_part_no_);

   Trace_SYS.Field('picking_leadtime_', picking_leadtime_);
   Trace_SYS.Field('internal_control_time_', internal_control_time_);
   Trace_SYS.Field('vendor_manuf_leadtime_', vendor_manuf_leadtime_);
   Trace_SYS.Field('vendor_picking_leadtime_', vendor_picking_leadtime_);
   Trace_SYS.Field('expected_leadtime_', expected_leadtime_);
   Trace_SYS.Field('delivery_leadtime_', delivery_leadtime_);
   Trace_SYS.Field('internal_leadtime_', internal_leadtime_);
   Trace_SYS.Field('transit_del_leadtime_', transit_del_leadtime_);
   Trace_SYS.Field('transit_int_leadtime_', transit_int_leadtime_);
   Trace_SYS.Field('transport_leadtime_', transport_leadtime_);
   
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (vendor_no_ IS NOT NULL) THEN
         supplier_rec_ := Supplier_API.Get(vendor_no_);
         supply_site_ := supplier_rec_.acquisition_site;
   END IF;
   $END

   -- Check if the part is an inventory part at demand site (it could be just a purchase part)
   inventory_part_at_demand_site_ := Inventory_Part_API.Check_Exist(contract_, part_no_);

   IF (supply_site_ IS NOT NULL) THEN
      inventory_part_at_supply_site_ := Inventory_Part_API.Check_Exist(supply_site_, purchase_part_no_);
   ELSE
      inventory_part_at_supply_site_ := FALSE;
   END IF;


   -- Calculate total shipping time
   IF (supply_code_ = 'ND') THEN
      -- Not decided
      total_shipping_time_ := 0;
   ELSIF (supply_code_ IN ('NO', 'SEO')) THEN
      total_shipping_time_ := delivery_leadtime_;
   ELSIF (supply_code_ IN ('IO', 'PKG')) THEN
      total_shipping_time_ := picking_leadtime_ + delivery_leadtime_;
   ELSIF (supply_code_ IN ('SO', 'DOP','PS')) THEN
      total_shipping_time_ := expected_leadtime_ + picking_leadtime_ + delivery_leadtime_;
   ELSIF (supply_code_ = 'PT') THEN
      total_shipping_time_ := vendor_manuf_leadtime_ + NVL(transit_del_leadtime_, 0) +
                              NVL(transport_leadtime_, 0) +
                              NVL(transit_int_leadtime_, 0) + internal_control_time_ +
                              delivery_leadtime_;
      IF (inventory_part_at_demand_site_) THEN
         total_shipping_time_ := total_shipping_time_ + picking_leadtime_;
      END IF;
   ELSIF (supply_code_ = 'IPT') THEN
      IF (inventory_part_at_supply_site_) THEN
         total_shipping_time_ := vendor_picking_leadtime_;
      ELSE
         total_shipping_time_ := vendor_manuf_leadtime_;
      END IF;

      total_shipping_time_ := total_shipping_time_ + NVL(transit_del_leadtime_, 0) +
                              NVL(transport_leadtime_, 0) +
                              NVL(transit_int_leadtime_, 0) + internal_control_time_ +
                              delivery_leadtime_;

      IF (inventory_part_at_demand_site_) THEN
         total_shipping_time_ := total_shipping_time_ + picking_leadtime_;
      END IF;

   ELSIF (supply_code_ = 'PD') THEN
      total_shipping_time_ := vendor_manuf_leadtime_ + delivery_leadtime_;

   ELSIF (supply_code_ = 'IPD') THEN
      IF (inventory_part_at_supply_site_) THEN
         total_shipping_time_ := vendor_picking_leadtime_ + delivery_leadtime_;
      ELSE
         total_shipping_time_ := vendor_manuf_leadtime_ + delivery_leadtime_;
      END IF;
   ELSE
      total_shipping_time_ := 0;
   END IF;

END Get_Supply_Chain_Totals___;


-- Get_Other_Leadtimes___
--   Retrieves the leadtimes for our and our suppliers site which
--   are not dependent on the ship via codes
--   picking_leadtime_:           Internal picking leadtime on our site
--   internal_control_time_:      Our internal quality/control time
--   vendor_manuf_leadtime_:      Supplier's manufacturing leadtime
--   vendor_picking_leadtime_:    Supplier's internal picking leadtime
--   expected_leadtime_:          Our expected/manufacturing leadtime (for Shop Order/DOP)
PROCEDURE Get_Other_Leadtimes___ (
   internal_control_time_   IN OUT NUMBER,
   vendor_manuf_leadtime_   IN OUT NUMBER,
   expected_leadtime_       IN OUT NUMBER,
   vendor_no_               IN     VARCHAR2,
   contract_                IN     VARCHAR2,
   part_no_                 IN     VARCHAR2,
   purchase_part_no_        IN     VARCHAR2 )
IS
   $IF Component_Purch_SYS.INSTALLED $THEN
      part_supp_rec_  Purchase_Part_Supplier_API.Public_Rec;
      supplier_rec_   Supplier_API.Public_Rec;
      supply_site_    VARCHAR2(5);
   $END   
BEGIN

   -- Supplier leadtimes
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (vendor_no_ IS NOT NULL) THEN
         part_supp_rec_ := Purchase_Part_Supplier_API.Get(contract_, purchase_part_no_, vendor_no_);
         internal_control_time_ := part_supp_rec_.internal_control_time;
         vendor_manuf_leadtime_ := part_supp_rec_.vendor_manuf_leadtime;
         supplier_rec_ := Supplier_API.Get(vendor_no_);
                   supply_site_ := supplier_rec_.acquisition_site;

                   ELSE
         internal_control_time_   := 0;
         vendor_manuf_leadtime_   := 0;
                   END IF;
   $ELSE
      internal_control_time_   := 0;
      vendor_manuf_leadtime_   := 0;
   $END

   -- Our own manufacturing leadtime (Shop Order/DOP)
   expected_leadtime_ := Inventory_Part_API.Get_Expected_Leadtime(contract_, part_no_);

END Get_Other_Leadtimes___;

-- Set_Variable_Value___
--Sets the parameter variable_ with the value of value_ and sets indicator_ as true.
PROCEDURE Set_Variable_Value___(variable_  IN OUT VARCHAR2,
                                indicator_ IN OUT BOOLEAN,
                                value_     IN     VARCHAR2) 
IS
BEGIN
   variable_  := value_;
   indicator_ := TRUE;
END Set_Variable_Value___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Transit_Ship_Via_Values
--   Returns the supply chain parameter values for the transit delivery
--   from a supplier using the specified ship via code.
PROCEDURE Get_Transit_Ship_Via_Values (
   transit_del_leadtime_      IN OUT NUMBER,
   transit_distance_          IN OUT NUMBER,
   transit_cost_              IN OUT NUMBER,
   cost_curr_code_            IN OUT VARCHAR2,
   transit_int_leadtime_      IN OUT NUMBER,
   transit_picking_leadtime_  IN OUT NUMBER,
   transit_route_id_          IN OUT VARCHAR2,
   sc_matrix_record_found_    IN OUT BOOLEAN,
   delivery_terms_            IN OUT VARCHAR2,
   del_terms_location_        IN OUT VARCHAR2,
   transport_leadtime_        IN OUT NUMBER,
   arrival_route_id_          IN OUT VARCHAR2,
   contract_                  IN     VARCHAR2,
   part_no_                   IN     VARCHAR2,
   supply_code_               IN     VARCHAR2,
   vendor_no_                 IN     VARCHAR2,
   supplier_ship_via_transit_ IN     VARCHAR2 )
IS
BEGIN
   Get_Transit_Ship_Via_Values___(transit_del_leadtime_ , transit_distance_, transit_cost_, cost_curr_code_, transit_int_leadtime_, transit_picking_leadtime_,
                                  transit_route_id_, sc_matrix_record_found_, delivery_terms_, del_terms_location_, transport_leadtime_, arrival_route_id_,
                                  contract_, part_no_, supply_code_, vendor_no_, supplier_ship_via_transit_);
END Get_Transit_Ship_Via_Values;


-- Get_Supply_Chain_Head_Defaults
--   Returns default ship_via_code, freight map id, zone id, route, forwarder and leadtimes to
--   use in Customer Order / Quotation.
--   If no delivery leadtime value is found in the supply chain matrixes
--   delivery leadtime will be set to 0.
PROCEDURE Get_Supply_Chain_Head_Defaults (
   ship_via_code_              IN OUT VARCHAR2,
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   freight_map_id_             IN OUT VARCHAR2,
   zone_id_                    IN OUT VARCHAR2,
   delivery_leadtime_          IN OUT NUMBER,
   ext_transport_calendar_id_  IN OUT VARCHAR2,
   route_id_                   IN OUT VARCHAR2,
   forward_agent_id_           IN OUT VARCHAR2,
   picking_leadtime_           IN OUT NUMBER,
   shipment_type_              IN OUT VARCHAR2,
   ship_inventory_location_no_ IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   agreement_id_               IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   ship_addr_no_changed_       IN     VARCHAR2 DEFAULT 'FALSE')
IS
   customer_rec_              Cust_Ord_Customer_API.Public_Rec;
   cust_addr_rec_             Cust_Ord_Customer_Address_API.Public_Rec;
   addr_rec_                  Customer_Address_Leadtime_API.Public_Rec;
   site_lead_rec_             Site_To_Site_Leadtime_API.Public_Rec;
   supp_to_cust_lead_rec_     Supp_To_Cust_Leadtime_API.Public_Rec;
   external_cust_             BOOLEAN;
   supply_site_               VARCHAR2(5) := NULL;
   vendor_addr_no_            VARCHAR2(50);
   vendor_ship_via_           VARCHAR2(3) := NULL;
   vendor_delivery_terms_     VARCHAR2(5) := NULL;
   vendor_del_terms_location_ VARCHAR2(100);
   external_supp_             BOOLEAN;
   ship_via_found_            BOOLEAN := FALSE;
   site_                      VARCHAR2(5);
   temp_forward_agent_id_     VARCHAR2(20);
   custagreerec_              Customer_Agreement_API.Public_Rec;
   
   client_ship_via_code_      VARCHAR2(3):= NULL;
   client_route_id_           VARCHAR2(12):= NULL;
   picking_leadtime_in_       NUMBER; 
   delivery_leadtime_in_      NUMBER; 
   sc_matrix_record_found_    BOOLEAN:=FALSE;
BEGIN
   customer_rec_  := Cust_Ord_Customer_API.Get(customer_no_);
   cust_addr_rec_ := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);
   external_cust_ := (NVL(customer_rec_.category, ' ') = 'E');
   temp_forward_agent_id_ := forward_agent_id_;
   picking_leadtime_in_   := picking_leadtime_;
   delivery_leadtime_in_  := delivery_leadtime_; 
   
   -- fetch supplier info 
   IF (vendor_no_ IS NOT NULL) THEN
      $IF Component_Purch_SYS.INSTALLED $THEN
         -- fetch supplier info
         Trace_SYS.Message('Fetch supplier info');
         DECLARE
            supprec_             Supplier_API.Public_Rec;
         BEGIN
            Supplier_API.Exist(vendor_no_);
            supprec_        := Supplier_API.Get(vendor_no_);
            supply_site_    := supprec_.acquisition_site;
            external_supp_  := (NVL(supprec_.category, Database_SYS.string_null_) = 'E');
            vendor_addr_no_ := Supplier_Address_API.Get_Address_No(vendor_no_, Address_Type_Code_API.Decode('DELIVERY'));
            Supplier_Address_API.Get_Delivery_Terms_Ship_Via(vendor_delivery_terms_, vendor_ship_via_, vendor_no_, vendor_addr_no_);
            vendor_del_terms_location_ := Supplier_Address_API.Get_Del_Terms_Location(vendor_no_, vendor_addr_no_);
         END;
         
         Trace_SYS.Field('fetched supply site', supply_site_);
         Trace_SYS.Field('vendor_ship_via', vendor_ship_via_);

         IF (vendor_addr_no_ IS NULL) THEN
            -- The supplier did not have a valid document address.
            -- Return error message
            Error_SYS.Record_General(lu_name_, 'NO_VENDOR_ADDR2: Supplier :P1 has no delivery address with purchase specific attributes specified',
                                     vendor_no_);

         END IF;
      $END    
      IF (external_supp_) THEN
         site_ := contract_;
      ELSE
         site_ := supply_site_;
      END IF;
      
      IF external_cust_ THEN
         IF external_supp_ THEN
            ship_via_code_ := Supp_To_Cust_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_,
                                 customer_no_, ship_addr_no_);
            Trace_SYS.Field('Ship via from supplier-to-customer', ship_via_code_);

            supp_to_cust_lead_rec_ := Supp_To_Cust_Leadtime_API.Get(customer_no_, ship_addr_no_, vendor_no_, vendor_addr_no_, ship_via_code_);
            delivery_terms_        := supp_to_cust_lead_rec_.delivery_terms;
            del_terms_location_    := supp_to_cust_lead_rec_.del_terms_location;
            delivery_leadtime_     := supp_to_cust_lead_rec_.delivery_leadtime;
            freight_map_id_        := supp_to_cust_lead_rec_.freight_map_id;
            zone_id_               := supp_to_cust_lead_rec_.zone_id;
         ELSE
            ship_via_code_ := Customer_Address_Leadtime_API.Get_Default_Ship_Via_Code(customer_no_, ship_addr_no_, supply_site_);
            Trace_SYS.Field('Ship via from site-to-customer', ship_via_code_);

            -- Retrieve the delivery leadtime
            addr_rec_ := Customer_Address_Leadtime_API.Get(customer_no_, ship_addr_no_, ship_via_code_, supply_site_);
            delivery_terms_     := addr_rec_.delivery_terms;
            del_terms_location_ := addr_rec_.del_terms_location;
            delivery_leadtime_  := addr_rec_.delivery_leadtime;
            freight_map_id_     := addr_rec_.freight_map_id;
            zone_id_            :=  addr_rec_.zone_id;
            picking_leadtime_   := addr_rec_.picking_leadtime;
            shipment_type_      := addr_rec_.shipment_type;
            ship_inventory_location_no_ := addr_rec_.ship_inventory_location_no;
            route_id_           := addr_rec_.route_id;
            forward_agent_id_   := addr_rec_.forward_agent_id;
            forward_agent_id_   := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
         END IF;

      ELSE
         IF external_supp_ THEN
            $IF Component_Purch_SYS.INSTALLED $THEN
               ship_via_code_ := Supplier_Address_Leadtime_API.Get_Default_Ship_Via_Code(vendor_no_, vendor_addr_no_, customer_rec_.acquisition_site);
               Trace_SYS.Field('Ship via from supplier-to-site', ship_via_code_);
               DECLARE
                  supp_lead_rec_     Supplier_Address_Leadtime_API.Public_Rec;
               BEGIN                     
                  supp_lead_rec_      := Supplier_Address_Leadtime_API.Get(vendor_no_, vendor_addr_no_, ship_via_code_,  customer_rec_.acquisition_site);
                  delivery_terms_     := supp_lead_rec_.delivery_terms;
                  del_terms_location_ := supp_lead_rec_.del_terms_location;
                  delivery_leadtime_  := supp_lead_rec_.vendor_delivery_leadtime;
               END;
            $ELSE
               NULL;
            $END
         ELSE
            ship_via_code_ := Site_To_Site_Leadtime_API.Get_Default_Ship_Via_Code(customer_rec_.acquisition_site, supply_site_);
            Trace_SYS.Field('Ship via from site-to-site', ship_via_code_);

            -- Retrieve the delivery leadtime
            site_lead_rec_      := Site_To_Site_Leadtime_API.Get(customer_rec_.acquisition_site, supply_site_, ship_via_code_);
            delivery_terms_     := site_lead_rec_.delivery_terms;
            del_terms_location_ := site_lead_rec_.del_terms_location;
            delivery_leadtime_  := site_lead_rec_.delivery_leadtime;
            freight_map_id_     := site_lead_rec_.freight_map_id;
            zone_id_            := site_lead_rec_.zone_id;
            picking_leadtime_   := site_lead_rec_.picking_leadtime;
            shipment_type_      := site_lead_rec_.shipment_type;
            ship_inventory_location_no_ :=  site_lead_rec_.ship_inventory_location_no;
            route_id_           := site_lead_rec_.route_id;
            forward_agent_id_   := site_lead_rec_.forward_agent_id;
            forward_agent_id_   := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
         END IF;                       
      END IF;
      
      IF (ship_via_code_ IS NOT NULL) THEN
         ship_via_found_ := TRUE;
         sc_matrix_record_found_ := TRUE;
      END IF;      
   END IF;
   
   -- First check customer agreement
   IF (agreement_id_ IS NOT NULL) AND (NOT ship_via_found_) THEN
      -- From customer agreement
       client_ship_via_code_ := ship_via_code_;
       client_route_id_ := route_id_;
      custagreerec_       := Customer_Agreement_API.Get(agreement_id_);
      IF ((client_ship_via_code_  IS NULL) AND (custagreerec_.use_by_object_head = 'FALSE' AND custagreerec_.use_explicit = 'Y')) THEN
         custagreerec_ := NULL;
      END IF;
      ship_via_code_      := NVL(custagreerec_.ship_via_code, ship_via_code_);
      delivery_terms_     := NVL(custagreerec_.delivery_terms, delivery_terms_);
      del_terms_location_ := NVL(custagreerec_.del_terms_location, del_terms_location_);
      IF (ship_via_code_ IS NOT NULL) THEN
         -- Retrieve the delivery leadtime
         addr_rec_ := Customer_Address_Leadtime_API.Get(customer_no_, ship_addr_no_, ship_via_code_, contract_);
         sc_matrix_record_found_ := (addr_rec_.delivery_leadtime IS NOT NULL);
         
         IF (external_cust_) THEN
               -- Our site to external customer
            IF((custagreerec_.ship_via_code IS NOT NULL) AND ((custagreerec_.ship_via_code != client_ship_via_code_) OR client_ship_via_code_ IS NULL)) THEN                          
               -- Value fetching should be done exactly like when we manually change the ship via code in the header.
               -- if an agreement is present and the agreement ship via code matches the matrix ship via code first we should retrieve values from the matrix. If the matrix values are null then 
               -- the values should be fetched from the customer. But route_id fetching logic is different.
               -- route_id should be fetched according to the bug 138033. The logic is below
               IF(addr_rec_.ship_via_code = custagreerec_.ship_via_code)THEN                    
                  IF(addr_rec_.route_id IS NULL)THEN
                     IF(cust_addr_rec_.ship_via_code <> custagreerec_.ship_via_code)THEN
                        route_id_ := NULL;                 
                     ELSIF(addr_rec_.ship_via_code = cust_addr_rec_.ship_via_code)THEN
                        IF( cust_addr_rec_.route_id IS NULL)THEN
                           route_id_ := client_route_id_;
                        ELSE
                           route_id_ := cust_addr_rec_.route_id;
                        END IF;                     
                     END IF;
                  ELSE
                     route_id_ := addr_rec_.route_id;
                  END IF;

                  shipment_type_    := NVL(addr_rec_.shipment_type, cust_addr_rec_.shipment_type);
                  delivery_terms_ := NVL(addr_rec_.delivery_terms, cust_addr_rec_.delivery_terms);
                  del_terms_location_ := NVL(addr_rec_.del_terms_location, cust_addr_rec_.del_terms_location);
                  delivery_leadtime_ := addr_rec_.delivery_leadtime;
                  picking_leadtime_ := addr_rec_.picking_leadtime;
               ELSE
                  IF (cust_addr_rec_.route_id IS NOT NULL)THEN 
                     route_id_ := cust_addr_rec_.route_id;
                  ELSE
                     route_id_ := client_route_id_;
                  END IF;  
                  forward_agent_id_ := forward_agent_id_;
                  shipment_type_    := NVL(addr_rec_.shipment_type, shipment_type_);
                  delivery_terms_   := NVL(addr_rec_.delivery_terms, delivery_terms_);
                  del_terms_location_ := NVL(addr_rec_.del_terms_location, del_terms_location_);
                  delivery_leadtime_ := NVL(delivery_leadtime_, addr_rec_.delivery_leadtime);
                  picking_leadtime_ := NVL(picking_leadtime_, addr_rec_.picking_leadtime);
               END IF;
               forward_agent_id_ := addr_rec_.forward_agent_id;
               IF (route_id_ IS NOT NULL )THEN
                  forward_agent_id_ := NVL(Delivery_Route_API.Get_Forward_Agent_Id(route_id_), forward_agent_id_);
               END IF;             
               
               -- Address change handling
               IF(client_ship_via_code_ IS NULL) THEN
                  shipment_type_    := NVL(addr_rec_.shipment_type, cust_addr_rec_.shipment_type);
                  delivery_terms_ := NVL(addr_rec_.delivery_terms, cust_addr_rec_.delivery_terms);
                  del_terms_location_ := NVL(addr_rec_.del_terms_location, cust_addr_rec_.del_terms_location);                            
               END IF; 

               IF (custagreerec_.delivery_terms IS NOT NULL)THEN
                  delivery_terms_ := custagreerec_.delivery_terms;
               END IF;
               IF (custagreerec_.del_terms_location IS NOT NULL)THEN
                  del_terms_location_ := custagreerec_.del_terms_location;
               END IF;
               freight_map_id_ := NVL(freight_map_id_, addr_rec_.freight_map_id);
               zone_id_ := NVL(zone_id_, addr_rec_.zone_id);
               ship_inventory_location_no_ := addr_rec_.ship_inventory_location_no; 
            END IF;
         ELSE
            -- Our site to internal customer (site)
            site_lead_rec_     := Site_To_Site_Leadtime_API.Get(customer_rec_.acquisition_site, contract_, ship_via_code_);
            delivery_leadtime_ := site_lead_rec_.delivery_leadtime;
            route_id_          := site_lead_rec_.route_id;
            forward_agent_id_  := site_lead_rec_.forward_agent_id;
            forward_agent_id_  := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
            freight_map_id_    := site_lead_rec_.freight_map_id;
            zone_id_           := site_lead_rec_.zone_id;
            picking_leadtime_  := site_lead_rec_.picking_leadtime;
            shipment_type_     := site_lead_rec_.shipment_type;
            ship_inventory_location_no_ :=  site_lead_rec_.ship_inventory_location_no;
            IF (delivery_terms_ IS NULL) THEN
               delivery_terms_ := site_lead_rec_.delivery_terms;
               del_terms_location_ := site_lead_rec_.del_terms_location;
            END IF;
            sc_matrix_record_found_ := (delivery_leadtime_ IS NOT NULL);
         END IF;
         -- If no leadtime found set the value to 0
         IF (delivery_leadtime_ IS NULL) THEN
            delivery_leadtime_ := 0;
         END IF;
      END IF;
   END IF;

   IF (ship_via_code_ IS NULL) THEN
      -- No agreement or ship via not found on agreement
      IF (vendor_no_ IS NOT NULL) THEN
         -- If vendor_no exists and no ship via code was found in chain matrices or agreement inherit from supplier record
         ship_via_code_ := vendor_ship_via_;
         delivery_terms_ := vendor_delivery_terms_;
         del_terms_location_ := vendor_del_terms_location_;
         Trace_SYS.Field('Ship via supplier', ship_via_code_);
      ELSE        
         IF (addr_flag_db_ = 'Y') THEN
            -- Single occurence address - inherit ship via code from customer
            -- and set delivery leadtime to 0
            ship_via_code_ := cust_addr_rec_.ship_via_code;
            delivery_terms_ := cust_addr_rec_.delivery_terms;
            del_terms_location_ := cust_addr_rec_.del_terms_location;
            route_id_ := cust_addr_rec_.route_id;
            forward_agent_id_ := NVL(Delivery_Route_API.Get_Forward_Agent_Id(route_id_), Cust_Ord_Customer_API.Get_Forward_Agent_Id(customer_no_));
            delivery_leadtime_ := 0;
         ELSIF (external_cust_) THEN
            -- Our site to external customer
            ship_via_code_ := Customer_Address_Leadtime_API.Get_Default_Ship_Via_Code(customer_no_, ship_addr_no_, contract_);

            -- If no values were found in the supply chain matrixes inherit ship via code from customer
            IF (ship_via_code_ IS NULL) THEN
               ship_via_code_ := cust_addr_rec_.ship_via_code;
            END IF;

            -- Retrieve the delivery leadtime
               addr_rec_ := Customer_Address_Leadtime_API.Get(customer_no_, ship_addr_no_, ship_via_code_, contract_);
               delivery_terms_ := addr_rec_.delivery_terms;
               del_terms_location_ := addr_rec_.del_terms_location;
               delivery_leadtime_ := addr_rec_.delivery_leadtime;
               freight_map_id_ := NVL(freight_map_id_, addr_rec_.freight_map_id);
               zone_id_ := NVL(zone_id_, addr_rec_.zone_id);
               picking_leadtime_  := addr_rec_.picking_leadtime;
               shipment_type_     := addr_rec_.shipment_type;
               ship_inventory_location_no_ := addr_rec_.ship_inventory_location_no;
               route_id_          := addr_rec_.route_id;
               forward_agent_id_  := addr_rec_.forward_agent_id;
               forward_agent_id_  := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_)); 
               sc_matrix_record_found_ := (delivery_leadtime_ IS NOT NULL);

         ELSE
            -- Our site to internal customer (site)
            ship_via_code_ := Site_To_Site_Leadtime_API.Get_Default_Ship_Via_Code(customer_rec_.acquisition_site, contract_);

            -- If no values were found in the supply chain matrixes inherit ship via code from customer
            IF (ship_via_code_ IS NULL) THEN
               ship_via_code_ := cust_addr_rec_.ship_via_code;
            END IF;
            -- Retrieve the delivery leadtime
            site_lead_rec_      := Site_To_Site_Leadtime_API.Get(customer_rec_.acquisition_site, contract_, ship_via_code_);
            delivery_terms_     := site_lead_rec_.delivery_terms;
            del_terms_location_ := site_lead_rec_.del_terms_location;
            delivery_leadtime_  := site_lead_rec_.delivery_leadtime;
            freight_map_id_     := site_lead_rec_.freight_map_id;
            zone_id_            := site_lead_rec_.zone_id;
            picking_leadtime_   := site_lead_rec_.picking_leadtime;
            shipment_type_      := site_lead_rec_.shipment_type;
            ship_inventory_location_no_ :=  site_lead_rec_.ship_inventory_location_no;
            route_id_           := site_lead_rec_.route_id;
            forward_agent_id_   := site_lead_rec_.forward_agent_id;
            forward_agent_id_   := NVL(forward_agent_id_, Delivery_Route_API.Get_Forward_Agent_Id(route_id_));
            sc_matrix_record_found_ := (delivery_leadtime_ IS NOT NULL);
         END IF;
      END IF;
   ELSIF (delivery_terms_ IS NULL) THEN
      IF (vendor_no_ IS NOT NULL) THEN
         delivery_terms_     := vendor_delivery_terms_;
         del_terms_location_ := vendor_del_terms_location_;
      ELSE
         IF (agreement_id_ IS NOT NULL) THEN
            delivery_terms_     := Customer_Agreement_API.Get_Delivery_Terms(agreement_id_);
            del_terms_location_ := Customer_Agreement_API.Get_Del_Terms_Location(agreement_id_);
         ELSIF (addr_flag_db_ = 'Y') THEN
            delivery_terms_     := cust_addr_rec_.delivery_terms;
            del_terms_location_ := cust_addr_rec_.del_terms_location;
         ELSIF (external_cust_) THEN
            addr_rec_           := Customer_Address_Leadtime_API.Get(customer_no_, ship_addr_no_, ship_via_code_, contract_);
            delivery_terms_     := addr_rec_.delivery_terms;
            del_terms_location_ := addr_rec_.del_terms_location;
            sc_matrix_record_found_ := (addr_rec_.delivery_leadtime IS NOT NULL);
         ELSE
            site_lead_rec_      := Site_To_Site_Leadtime_API.Get(customer_rec_.acquisition_site, contract_, ship_via_code_);
            delivery_terms_     := site_lead_rec_.delivery_terms;
            del_terms_location_ := site_lead_rec_.del_terms_location;
            sc_matrix_record_found_ := (site_lead_rec_.delivery_leadtime IS NOT NULL);
         END IF;
      END IF;
   END IF;         
   IF(delivery_terms_ IS NULL) THEN
      delivery_terms_ := cust_addr_rec_.delivery_terms;
      del_terms_location_ := cust_addr_rec_.del_terms_location;
   END IF;

   IF (picking_leadtime_ IS NULL) THEN
      -- Added the condition to identify if it is a delivery address change and if no record in sc matrix
      -- then retain the existing value, if a sc matrix record is found but picking lead time is zero then retrieve default from site. 
      -- Exclude scenarios where supplier related matrix is used.
      IF ((ship_addr_no_changed_ = 'TRUE') AND (NOT sc_matrix_record_found_) AND (vendor_no_ IS NULL)) THEN
         picking_leadtime_ := NVL(picking_leadtime_in_, 0); 
      ELSE   
         picking_leadtime_ := NVL(Site_Invent_Info_API.Get_Picking_Leadtime(NVL(site_, contract_)), 0);    
      END IF;
   END IF;
   
   IF (shipment_type_ IS NULL) THEN
      shipment_type_ := NVL(NVL(cust_addr_rec_.shipment_type, Site_Discom_Info_API.Get_Shipment_Type(NVL(site_, contract_))), 'NA');
   END IF;   
   
   IF (ship_inventory_location_no_ IS NULL) THEN
      ship_inventory_location_no_ := Site_Discom_Info_API.Get_Ship_Inventory_Location_No(NVL(site_, contract_));
   END IF;
   
   IF (route_id_ IS NULL) THEN
      IF ((delivery_leadtime_ IS NULL) OR (ship_via_code_ = cust_addr_rec_.ship_via_code)) THEN
         route_id_ := cust_addr_rec_.route_id;
      END IF;
      forward_agent_id_ := NVL(Delivery_Route_API.Get_Forward_Agent_Id(route_id_), forward_agent_id_);
   END IF;
   
   -- Added the condition to identify if it is a delivery address change and if no record in sc matrix
   -- then retain the existing value. Exclude scenarios where supplier related matrix is used.
   IF ((ship_addr_no_changed_ = 'TRUE') AND (NOT sc_matrix_record_found_) AND (vendor_no_ IS NULL)) THEN
      delivery_leadtime_ := delivery_leadtime_in_; 
   END IF;   
   delivery_leadtime_ := NVL(delivery_leadtime_, 0);
   
   ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(ship_via_code_);

   IF forward_agent_id_ IS NULL THEN
      forward_agent_id_ :=  Cust_Ord_Customer_API.Get_Forward_Agent_Id(customer_no_);
   END IF;

   IF forward_agent_id_ IS NULL THEN
      forward_agent_id_ := Site_Discom_Info_API.Get_Forward_Agent_Id(contract_);
   END IF;
   
   Trace_SYS.Field('ship_via_code', ship_via_code_);
   Trace_SYS.Field('delivery_leadtime', delivery_leadtime_);
   Trace_SYS.Field('freight_map_id', freight_map_id_);
   Trace_SYS.Field('zone_id', zone_id_);
   Trace_SYS.Field('ext_transport_calendar_id', ext_transport_calendar_id_);
   Trace_SYS.Field('picking_leadtime', picking_leadtime_);
   Trace_SYS.Field('route_id', route_id_);
   Trace_SYS.Field('forward_agent', forward_agent_id_);
   
END Get_Supply_Chain_Head_Defaults;


-- Get_Supply_Chain_Defaults
--   Returns default ship_via_code, supplier_ship_via_transit, delivery_leadtime,
--   freight map id, zone id, forwarder, route, picking leadtime and shipment type from the correct
--   supply chain matrix for use in Customer Order Line / Quotation Line and manual sourcing.
--   If the found values for ship_via_code or delivery_leadtime differ from the values
--   on the order header the default_addr_flag_db will be set to 'N'.
--   If no values are found zero (0) will be returned.
PROCEDURE Get_Supply_Chain_Defaults (
   route_id_                     IN OUT VARCHAR2,
   forward_agent_id_             IN OUT VARCHAR2,
   ship_via_code_                IN OUT VARCHAR2,
   delivery_terms_               IN OUT VARCHAR2,
   del_terms_location_           IN OUT VARCHAR2,
   supplier_ship_via_transit_    IN OUT VARCHAR2,
   delivery_leadtime_            IN OUT NUMBER,
   ext_transport_calendar_id_    IN OUT VARCHAR2,
   default_addr_flag_db_         IN OUT VARCHAR2,
   freight_map_id_               IN OUT VARCHAR2,
   zone_id_                      IN OUT VARCHAR2,     
   picking_leadtime_             IN OUT NUMBER,
   shipment_type_                IN OUT VARCHAR2,
   contract_                     IN     VARCHAR2,
   customer_no_                  IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   supply_code_                  IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   agreement_id_                 IN     VARCHAR2,
   default_ship_via_code_        IN     VARCHAR2,
   default_delivery_terms_       IN     VARCHAR2,
   default_del_terms_location_   IN     VARCHAR2,
   default_delivery_leadtime_    IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   default_route_id_             IN     VARCHAR2,
   default_forward_agent_id_     IN     VARCHAR2,
   default_picking_leadtime_     IN     NUMBER,
   default_shipment_type_        IN     VARCHAR2,
   header_vendor_no_             IN     VARCHAR2 DEFAULT NULL,
   header_ship_addr_no_          IN     VARCHAR2 DEFAULT NULL,
   ship_via_code_changed_        IN     VARCHAR2 DEFAULT 'FALSE',
   ship_addr_no_changed_         IN     VARCHAR2 DEFAULT 'FALSE' )
IS
   total_shipping_distance_ NUMBER;
   total_expected_cost_     NUMBER;
   total_shipping_time_     NUMBER;
BEGIN

   -- Purchase part no only needed to calculate the totals.
   -- Since we are not interested in these here we can a pass NULL value for purchase_part_no_

   Get_Supply_Chain_Defaults___(route_id_, forward_agent_id_, ship_via_code_, delivery_terms_, del_terms_location_, supplier_ship_via_transit_, delivery_leadtime_, ext_transport_calendar_id_,
                                default_addr_flag_db_, freight_map_id_, zone_id_, picking_leadtime_, shipment_type_,
                                total_shipping_distance_, total_expected_cost_, total_shipping_time_,
                                contract_, customer_no_, ship_addr_no_,
                                addr_flag_db_, part_no_, NULL, supply_code_, vendor_no_,
                                agreement_id_, default_ship_via_code_, default_delivery_terms_, default_del_terms_location_,
                                default_delivery_leadtime_, default_ext_transport_cal_id_, default_route_id_, 
                                default_forward_agent_id_, default_picking_leadtime_, default_shipment_type_, FALSE, header_vendor_no_, header_ship_addr_no_, ship_via_code_changed_, ship_addr_no_changed_);


END Get_Supply_Chain_Defaults;


-- Get_Sc_Defaults_For_Sourcing
--   Returns default ship_via_code, supplier_ship_via_transit, delivery_leadtime,
--   forwarder, route, picking leadtime and totals for shipping_time, shipping cost
--   and shipping distance to use in Automatic Sourcing.
--   If the default ship via code is retrieved from an exception for the parts
--   supply chain part group the default_addr_flag_db will be set to 'N'
--   If no values are found in the correct matrix depending on supply code,
--   supplier and customer ship_via_code will be set to NULL.
PROCEDURE Get_Sc_Defaults_For_Sourcing (
   route_id_                     IN OUT VARCHAR2,
   forward_agent_id_             IN OUT VARCHAR2,
   ship_via_code_                IN OUT VARCHAR2,
   delivery_terms_               IN OUT VARCHAR2,
   del_terms_location_           IN OUT VARCHAR2,
   supplier_ship_via_transit_    IN OUT VARCHAR2,
   delivery_leadtime_            IN OUT NUMBER,
   ext_transport_calendar_id_    IN OUT VARCHAR2,
   default_addr_flag_db_         IN OUT VARCHAR2,
   total_shipping_time_          IN OUT NUMBER,
   total_expected_cost_          IN OUT NUMBER,
   total_shipping_distance_      IN OUT NUMBER,
   picking_leadtime_             IN OUT NUMBER,
   shipment_type_                IN OUT VARCHAR2,
   contract_                     IN     VARCHAR2,
   customer_no_                  IN     VARCHAR2,
   ship_addr_no_                 IN     VARCHAR2,
   addr_flag_db_                 IN     VARCHAR2,
   part_no_                      IN     VARCHAR2,
   purchase_part_no_             IN     VARCHAR2,
   supply_code_                  IN     VARCHAR2,
   vendor_no_                    IN     VARCHAR2,
   agreement_id_                 IN     VARCHAR2,
   default_ship_via_code_        IN     VARCHAR2,
   default_delivery_terms_       IN     VARCHAR2,
   default_del_terms_location_   IN     VARCHAR2,
   default_delivery_leadtime_    IN     NUMBER,
   default_ext_transport_cal_id_ IN     VARCHAR2,
   default_route_id_             IN     VARCHAR2,
   default_forward_agent_id_     IN     VARCHAR2,
   default_picking_leadtime_     IN     NUMBER,
   default_shipment_type_        IN     VARCHAR2)
IS
   freight_map_id_ VARCHAR2(15);
   zone_id_        VARCHAR2(15);
BEGIN

   Get_Supply_Chain_Defaults___(route_id_, forward_agent_id_, ship_via_code_, delivery_terms_, del_terms_location_, supplier_ship_via_transit_, delivery_leadtime_, ext_transport_calendar_id_,
                                default_addr_flag_db_, freight_map_id_, zone_id_, picking_leadtime_, shipment_type_, total_shipping_distance_,
                                total_expected_cost_, total_shipping_time_,
                                contract_, customer_no_, ship_addr_no_,
                                addr_flag_db_, part_no_, purchase_part_no_,
                                supply_code_, vendor_no_,
                                agreement_id_, default_ship_via_code_, default_delivery_terms_, default_del_terms_location_,
                                default_delivery_leadtime_, default_ext_transport_cal_id_, default_route_id_, 
                                default_forward_agent_id_, default_picking_leadtime_, default_shipment_type_, TRUE, NULL, NULL, 'FALSE', 'FALSE');

END Get_Sc_Defaults_For_Sourcing;


-- Get_Ship_Via_Values
--   Returns the default values for route, forwarder, leadtimes, distance and
--   cost for a known ship_via_code.
--   If the values are not found, zero (0) will be returned for all.
--   The logic is the same as for fetching default ship via code.
--   Fetch the values from the correct matrix depending on supply code,
--   supplier and customer.
PROCEDURE Get_Ship_Via_Values (
   route_id_                   IN OUT VARCHAR2,
   forward_agent_id_           IN OUT VARCHAR2,
   delivery_leadtime_          IN OUT NUMBER,
   ext_transport_calendar_id_  IN OUT VARCHAR2,
   distance_                   IN OUT NUMBER,
   expected_additional_cost_   IN OUT NUMBER,
   cost_curr_code_             IN OUT VARCHAR2,
   internal_leadtime_          IN OUT NUMBER,
   supplier_ship_via_transit_  IN OUT VARCHAR2,
   freight_map_id_             IN OUT VARCHAR2,
   zone_id_                    IN OUT VARCHAR2,
   picking_leadtime_           IN OUT NUMBER,
   shipment_type_              IN OUT VARCHAR2,
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   supply_code_                IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   header_vendor_no_           IN     VARCHAR2 DEFAULT NULL,
   ship_via_code_changed_      IN     VARCHAR2 DEFAULT 'FALSE'   )
IS
   sc_matrix_record_found_     BOOLEAN;
   part_group_record_found_    BOOLEAN;
   vendor_picking_leadtime_    NUMBER;   
   ship_inventory_location_no_ VARCHAR2(35);
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);
BEGIN

   -- Retrieve data for the specied ship via code
   Fetch_Line_Deliv_Attribs___(route_id_, forward_agent_id_, delivery_leadtime_, ext_transport_calendar_id_, distance_, expected_additional_cost_, cost_curr_code_,
                               internal_leadtime_, sc_matrix_record_found_, part_group_record_found_,
                               freight_map_id_, zone_id_, picking_leadtime_, vendor_picking_leadtime_, shipment_type_, ship_inventory_location_no_,
                               delivery_terms_, del_terms_location_, transport_leadtime_, arrival_route_id_, contract_, customer_no_, ship_addr_no_,
                               addr_flag_db_, part_no_, supply_code_, vendor_no_, NULL, ship_via_code_, NULL, ship_via_code_changed_);

   IF ((freight_map_id_ IS NULL) AND (zone_id_ IS NULL)) THEN
      Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(freight_map_id_ , zone_id_, customer_no_, ship_addr_no_, contract_,  ship_via_code_);   
   END IF;
   
   -- Retrieve the default supplier ship via transit
   supplier_ship_via_transit_ := Get_Supplier_Ship_Via___(contract_, part_no_,
                                                          supply_code_, vendor_no_);

END Get_Ship_Via_Values;


-- Fetch_Delivery_Attributes
--   Returns the leadtimes, freight map id, zone id, route,  shipment type and forwarder for a
--   known ship_via_code. If the value isn't found, zero (0) will be returned.
--   The logic is the same as for fetching default ship via code.
--   Fetch the leadtime from the correct matrix depending on customer.
--   When used from Order / Quotation head the default parameters can
--   be left out.
--   When called from customer orders the parameter vendor_doc_addr_no_ can
--   be set to NULL in wich case the document address for the supplier will
--   be used. When called from Purchasing the document address on the PO
--   should be used.
PROCEDURE Fetch_Delivery_Attributes (
   route_id_                   IN OUT VARCHAR2,
   forward_agent_id_           IN OUT VARCHAR2,
   delivery_leadtime_          IN OUT NUMBER,
   ext_transport_calendar_id_  IN OUT VARCHAR2,
   freight_map_id_             IN OUT VARCHAR2,
   zone_id_                    IN OUT VARCHAR2,
   picking_leadtime_           IN OUT NUMBER,
   shipment_type_              IN OUT VARCHAR2,
   ship_inventory_location_no_ IN OUT VARCHAR2,
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   part_no_                    IN     VARCHAR2 DEFAULT NULL,
   supply_code_                IN     VARCHAR2 DEFAULT NULL,
   vendor_no_                  IN     VARCHAR2 DEFAULT NULL,
   vendor_doc_addr_no_         IN     VARCHAR2 DEFAULT NULL,
   ship_via_code_changed_      IN     VARCHAR2 DEFAULT 'FALSE')
IS
   dummy_                   NUMBER;
   dummystr_                VARCHAR2(200);
   sc_matrix_record_found_  BOOLEAN;
   part_group_record_found_ BOOLEAN;
   vendor_picking_leadtime_ NUMBER;
   transport_leadtime_      NUMBER;
   arrival_route_id_        VARCHAR2(12);
BEGIN

   IF (supply_code_ IS NOT NULL) THEN
      Fetch_Line_Deliv_Attribs___(route_id_,  forward_agent_id_, delivery_leadtime_, ext_transport_calendar_id_, dummy_, dummy_, dummystr_, dummy_,
                                  sc_matrix_record_found_, part_group_record_found_,
                                  freight_map_id_, zone_id_, picking_leadtime_, vendor_picking_leadtime_, shipment_type_, ship_inventory_location_no_, delivery_terms_, del_terms_location_,
                                  transport_leadtime_, arrival_route_id_, contract_, customer_no_, ship_addr_no_, addr_flag_db_,
                                  part_no_, supply_code_, vendor_no_, vendor_doc_addr_no_, ship_via_code_, NULL, ship_via_code_changed_);
   ELSE
      Fetch_Head_Deliv_Attribs___(route_id_,  forward_agent_id_, delivery_leadtime_, ext_transport_calendar_id_, sc_matrix_record_found_,
                                  freight_map_id_, zone_id_, picking_leadtime_, vendor_picking_leadtime_, shipment_type_,
                                  ship_inventory_location_no_, delivery_terms_, del_terms_location_, contract_, customer_no_, ship_addr_no_, addr_flag_db_,                                      
                                  vendor_no_, ship_via_code_, ship_via_code_changed_);
   END IF;

END Fetch_Delivery_Attributes;


-- Fetch_Head_Delivery_Attributes
--   Returns the leadtimes, freight map id, zone id, route,  shipment type and forwarder for a
--   known ship_via_code. If the value isn't found, zero (0) will be returned.
--   The logic is the same as for fetching default ship via code.
--   Fetch the leadtime from the correct matrix depending on customer.
--   To be used from Order / Quotation header.
PROCEDURE Fetch_Head_Delivery_Attributes (
   route_id_                   IN OUT VARCHAR2,
   forward_agent_id_           IN OUT VARCHAR2,
   delivery_leadtime_          IN OUT NUMBER,
   ext_transport_calendar_id_  IN OUT VARCHAR2,
   freight_map_id_             IN OUT VARCHAR2,
   zone_id_                    IN OUT VARCHAR2,
   picking_leadtime_           IN OUT NUMBER,
   shipment_type_              IN OUT VARCHAR2,
   ship_inventory_location_no_ IN OUT VARCHAR2,
   delivery_terms_             IN OUT VARCHAR2,
   del_terms_location_         IN OUT VARCHAR2,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   ship_via_code_changed_      IN     VARCHAR2 DEFAULT 'FALSE')
IS
   sc_matrix_record_found_  BOOLEAN;
   vendor_picking_leadtime_ NUMBER;
BEGIN
   
   -- customer order / sales quotation header
   Fetch_Head_Deliv_Attribs___(route_id_,  forward_agent_id_, delivery_leadtime_, ext_transport_calendar_id_, sc_matrix_record_found_,
                               freight_map_id_, zone_id_, picking_leadtime_, vendor_picking_leadtime_, shipment_type_,
                               ship_inventory_location_no_, delivery_terms_, del_terms_location_, contract_, customer_no_, ship_addr_no_, addr_flag_db_,                                      
                               vendor_no_, ship_via_code_, ship_via_code_changed_);

END Fetch_Head_Delivery_Attributes;


-- Get_Supply_Chain_Totals
--   Method intended to be used by the manual sourcing process.
--   Returns totals for shipping distance, cost and shipping time.
PROCEDURE Get_Supply_Chain_Totals (
   total_shipping_distance_    IN OUT NUMBER,
   total_expected_cost_        IN OUT NUMBER,
   total_shipping_time_        IN OUT NUMBER,
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   purchase_part_no_           IN     VARCHAR2,
   supply_code_                IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   supplier_ship_via_transit_  IN     VARCHAR2,
   default_delivery_leadtime_  IN     NUMBER,
   default_picking_leadtime_   IN     NUMBER )
IS
   delivery_leadtime_        NUMBER;
   internal_leadtime_        NUMBER;
   transit_del_leadtime_     NUMBER;
   transit_int_leadtime_     NUMBER;
   distance_                 NUMBER;
   expected_additional_cost_ NUMBER;
   cost_curr_code_           VARCHAR2(3);
   transit_distance_         NUMBER := 0;
   transit_cost_             NUMBER := 0;
   transit_cost_curr_code_   VARCHAR2(3);
   sc_matrix_record_found_   BOOLEAN;
   part_group_record_found_  BOOLEAN;

   freight_map_id_             VARCHAR2(15);
   zone_id_                    VARCHAR2(15);
   ext_transport_calendar_id_  VARCHAR2(10);
   route_id_                   VARCHAR2(12);
   forward_agent_id_           VARCHAR2(20);
   transit_route_id_           VARCHAR2(12);
   picking_leadtime_           NUMBER;
   vendor_picking_leadtime_    NUMBER;
   shipment_type_              VARCHAR2(3); 
   ship_inventory_location_no_ VARCHAR2(35);
   delivery_terms_             VARCHAR2(5);
   del_terms_location_         VARCHAR2(100);
   delivery_terms_transit_     VARCHAR2(5);
   del_terms_location_transit_ VARCHAR2(100);
   transport_leadtime_         NUMBER;
   arrival_route_id_           VARCHAR2(12);

BEGIN

   -- Retrive supply chain parameter values for the specified ship via code
   Fetch_Line_Deliv_Attribs___(route_id_, forward_agent_id_, delivery_leadtime_, ext_transport_calendar_id_, distance_, expected_additional_cost_, cost_curr_code_,
                               internal_leadtime_, sc_matrix_record_found_, part_group_record_found_,
                               freight_map_id_, zone_id_, picking_leadtime_, vendor_picking_leadtime_, shipment_type_, ship_inventory_location_no_, delivery_terms_,
                               del_terms_location_, transport_leadtime_, arrival_route_id_, contract_, customer_no_, ship_addr_no_,
                               addr_flag_db_, part_no_, supply_code_, vendor_no_, NULL, ship_via_code_, NULL, 'FALSE');

   -- If a delivery leadtime was passed in this should override the default value retrieved
   -- from the supply chain matrixes
   IF (default_delivery_leadtime_ IS NOT NULL) THEN
      delivery_leadtime_ := default_delivery_leadtime_;
   END IF;

   -- If a picking leadtime was passed in this should override the default value retrieved
   -- from the supply chain matrixes
   IF (default_picking_leadtime_ IS NOT NULL) THEN
      picking_leadtime_ := default_picking_leadtime_;
   END IF;

   -- Retrieve supply chain parameter values for the transit delivery
   IF (supplier_ship_via_transit_ IS NOT NULL) THEN

      -- Retrieve ship via values for transit delivery from supplier to our site
      Get_Transit_Ship_Via_Values___(transit_del_leadtime_, transit_distance_, transit_cost_, transit_cost_curr_code_,
                                     transit_int_leadtime_, vendor_picking_leadtime_, transit_route_id_, sc_matrix_record_found_, delivery_terms_transit_,
                                     del_terms_location_transit_, transport_leadtime_, arrival_route_id_, contract_, part_no_, supply_code_,
                                     vendor_no_, supplier_ship_via_transit_);

   END IF;

   -- Calculate totals for shipping distance, shipping cost and shipping time
   Get_Supply_Chain_Totals___(total_shipping_distance_,
                              total_expected_cost_,
                              total_shipping_time_,
                              delivery_leadtime_,
                              distance_,
                              expected_additional_cost_,
                              cost_curr_code_,
                              internal_leadtime_,
                              transit_del_leadtime_,
                              picking_leadtime_,
                              vendor_picking_leadtime_,
                              transit_distance_,
                              transit_cost_,
                              transit_cost_curr_code_,
                              transit_int_leadtime_,
                              contract_,
                              part_no_,
                              purchase_part_no_,
                              supply_code_,
                              vendor_no_,
                              transport_leadtime_);

END Get_Supply_Chain_Totals;


-- Get_Default_Leadtimes
--   Method intended to be used by the date calculation process.
--   Returns default values for different leadtimes needed in the
--   date calculation for a order or quotation line.
PROCEDURE Get_Default_Leadtimes (
   delivery_leadtime_          IN OUT NUMBER,
   transit_del_leadtime_       IN OUT NUMBER,
   transit_int_leadtime_       IN OUT NUMBER,
   picking_leadtime_           IN OUT NUMBER,
   internal_control_time_      IN OUT NUMBER,
   vendor_manuf_leadtime_      IN OUT NUMBER,
   vendor_picking_leadtime_    IN OUT NUMBER,
   expected_leadtime_          IN OUT NUMBER,
   transport_leadtime_         IN OUT NUMBER,
   arrival_route_id_           IN OUT VARCHAR2, 
   contract_                   IN     VARCHAR2,
   customer_no_                IN     VARCHAR2,
   ship_addr_no_               IN     VARCHAR2,
   addr_flag_db_               IN     VARCHAR2,
   part_no_                    IN     VARCHAR2,
   purchase_part_no_           IN     VARCHAR2,
   supply_code_                IN     VARCHAR2,
   vendor_no_                  IN     VARCHAR2,
   ship_via_code_              IN     VARCHAR2,
   supplier_ship_via_transit_  IN     VARCHAR2,
   ship_via_code_changed_      IN     VARCHAR2 DEFAULT 'FALSE')
IS
   internal_leadtime_         NUMBER;
   distance_                  NUMBER;
   expected_additional_cost_  NUMBER;
   cost_curr_code_            VARCHAR2(3);
   transit_distance_          NUMBER := 0;
   transit_cost_              NUMBER := 0;
   transit_cost_curr_code_    VARCHAR2(3);
   sc_matrix_record_found_    BOOLEAN;
   part_group_record_found_   BOOLEAN;

   freight_map_id_             VARCHAR2(15);
   zone_id_                    VARCHAR2(15);
   ext_transport_calendar_id_  VARCHAR2(10); -- Not used for anything.
   route_id_                   VARCHAR2(12);
   transit_route_id_           VARCHAR2(12);
   forward_agent_id_           VARCHAR2(20);
   shipment_type_              VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);

   delivery_terms_             VARCHAR2(5);
   del_terms_location_         VARCHAR2(100);
   delivery_terms_transit_     VARCHAR2(5);
   del_terms_location_transit_ VARCHAR2(100);
BEGIN

   -- Retrive supply chain parameter values for the specified ship via code
   Fetch_Line_Deliv_Attribs___(route_id_, forward_agent_id_, delivery_leadtime_, ext_transport_calendar_id_, distance_, expected_additional_cost_, cost_curr_code_,
                               internal_leadtime_, sc_matrix_record_found_, part_group_record_found_,
                               freight_map_id_, zone_id_, picking_leadtime_, vendor_picking_leadtime_, shipment_type_, ship_inventory_location_no_, delivery_terms_, del_terms_location_,
                               transport_leadtime_, arrival_route_id_, contract_, customer_no_, ship_addr_no_, addr_flag_db_, part_no_, supply_code_, vendor_no_, NULL, ship_via_code_, NULL,
                               ship_via_code_changed_);

   -- Retrieve supply chain parameter values for the transit delivery
   IF (supplier_ship_via_transit_ IS NOT NULL) THEN

      -- Retrieve ship via values for transit delivery from supplier to our site
      Get_Transit_Ship_Via_Values___(transit_del_leadtime_, transit_distance_, transit_cost_, transit_cost_curr_code_,
                                     transit_int_leadtime_, vendor_picking_leadtime_, transit_route_id_, sc_matrix_record_found_, delivery_terms_transit_, 
                                     del_terms_location_transit_, transport_leadtime_, arrival_route_id_, contract_, part_no_, supply_code_,
                                     vendor_no_, supplier_ship_via_transit_);

   END IF;

   -- Retrieve other leadtimes not connected to ship via codes
   Get_Other_Leadtimes___(internal_control_time_, vendor_manuf_leadtime_, 
                          expected_leadtime_, vendor_no_, contract_, part_no_,
                          purchase_part_no_);

END Get_Default_Leadtimes;


-- Get_Supplier_Ship_Via
--   Returns the default ship via code from external or internal suppliers
--   for transit deliveries.
FUNCTION Get_Supplier_Ship_Via (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   supply_code_   IN VARCHAR2,
   vendor_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Supplier_Ship_Via___(contract_, part_no_, supply_code_, vendor_no_);
END Get_Supplier_Ship_Via;



