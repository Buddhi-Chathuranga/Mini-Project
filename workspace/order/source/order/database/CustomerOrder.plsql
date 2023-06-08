-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  220201  Smallk   FI21R2-8623, Removed references to External_Tax_Calc_Method_API.DB_VERTEX_SALES_TAX_Q_SERIES.
--  220104  Skanlk   Bug 161878(SC21R2-6626), Modified Validate_Proj_Connect___ to allow adding project when there exist Supplier Rented lines.
--  211223  Skanlk   Bug 161134(SC21R2-6825), Added Fetch_And_Validate_Tax_Id() and Get_Tax_Id_Type() to validate Tax ID other than EU countires.
--  211210  NiDalk   Bug 161670(SC21R2-6164), Added Check_Delivery_Type to check all lines in customerorder has the same delivery type set.
--  211130  Sanvlk   CRM21R2-419, Changed Journal entry categories according to new event types in Crm_Cust_Info_History_API.New_Event.
--  211027  NiDalk   SC21R2-5202, Modified Check_Common___, Check_Update___ and Update___ to store business transaction id as ref_id in customer order line when using brazilian localization. 
--  211018  Amiflk   Bug 161020(SC21R2-3081), Modified value_ parameter into size 4000 from 2000 in the Client_SYS.Get_Next_From_Attr and Get_Order_Defaults___ methods.
--  211014  cecobr   FI21R2-4615, Move Entity and associated clint/logic of BusinessTransactionCode from MPCCOM to DISCOM
--  210913  ThWclk   AM21R2-2660, Modified Get_Ord_Line_Totals__ and Get_Total_Cost to get the correct total contribution value when customer order is generated from credit invoice.
--  210721  cecobr   gelr:localization_control_center, FI21R2-3038, Fetch LCC Parameters in prepare_insert method
--  210714  ThKrlk   Bug 159549(SCZ-15322), Modified Modify_Address() to update Customer Order Lines when header changed into single occurence address.
--  210629  MiKulk   SC21R2-1693, Added attribute InvoicedClosedDate, and Updated Finite_State_Set___ to Set the Invoiced_Closed_Date correctly. 
--  210618  MaEelk   SC21R2-1075, Introduced Get_Tax_Per_Tax_Code_Deliv___ and Get_Gros_Per_Tax_Code_Deliv___  and moved the codes inside Get_Tax_Amount_Per_Tax_Code and Get_Gross_Amount_Per_Tax_Code
--  210618           into these two implementation methods. Added Get_Tax_Per_Tax_Code_Deliv and Get_Gross_Per_Tax_Code_Deliv that would support the Delivery Type.  
--  210608  MaEelk   SC21R2-1075, Added default null parameter delivery_type to Get_Tax_Amount_Per_Tax_Code and Get_Gross_Amount_Per_Tax_Code.
--  210608           Handled delivery_type inside the logic.
--  210222  Skanlk   SC2020R1-12672, Modified Validate_Proposed_Prepay___() by adding a condition to check whether the TaxCalcMethod is NOT USED for the error message PREPAYMENTMULTITAX.
--  210217  MalLlk   SC2020R1-12161, Performance improvements. Reduced number of plsql method calls by using public Get instead of several Feild Gets. 
--  210118  MaEelk   SC2020R1-12121, Removed DISC_PRICE_ROUND_DB and DISC_PRICE_ROUND from attr_ in New_Rental_Replacement_Order.
--  201102  RasDlk   SCZ-12233, Modified Set_Line_Uninvoiced to consider invoiced rental transactions when CO line qty_invoiced is 0 due to resultant multiple invoiced transactions.
--  201027  RasDlk   SCZ-11047, Added Raise_No_Pay_Terms_Error___ to solve MessageDefinitionValidation issue.
--  201020  NiDalk   SC2020R1-10811, Removed unncessary dynamic check for INVOIC in Get_Order_Defaults___.
--  200728  cecobr   gelr:brazilian_specific_attributes, Added BUSINESS_TRANSACTION_ID field
--  200820  MaEelk   GESPRING20-5398, Added assigned TRUE or FALSE to DISC_PRICE_ROUND 
--  200820           according to the Discounted Price Rounded Localization Parameter. Added Get_Discounted_Price_Rounded.
--  200811  Smallk   GESPRING20-4810, Added ACCOUNTING_XML_DATA functionality.
--  200715  NiDalk   SCXTEND-4526, Moved Customer_Order_Line_API.Modify_Additional_Discount__ to Update_ as lines are updated twice when in Check_Update___
--  200715  RoJalk   Bug 154273 (SCZ-10310), Modified Get_Delivery_Information to pass the new parameter ship_addr_no_changed_ to indicate delivery address change and also include
--  200715           current delivery leadtime and picking leadtime values for the parameters. Added the parameter to ship_addr_no_changed_ to Fetch_Default_Delivery_Info.
--  200711  NiDalk   SCXTEND-4446, Modified Update___ and Fetch_External_Tax to fetch external taxes through a bundle call when address is changed.
--  200706  NiDalk   SCXTEND-4446, Modified Set_Released_Order to fetch external taxes to customer order lines.
--  200706  NiDalk   SCXTEND-4444, Added Update_External_Tax_Info to fetch tax information from external tax system.
--  200702  AjShlk   Bug 154638(SCZ-10564), Modofied Exists_One_Tax_Code_Per_Line() to handle package parts for Prepayment Based Invoices.
--  200608  MalLlk   GESPRING20-4617, Modified Tax_Paying_Party_Changed___() to redirect the call to Tax_Handling_Order_Util_API.Calc_And_Save_Foc_Tax_Basis(), 
--  200608           in order to calculate and save free of charge tax basis.
--  200602  KiSalk   Bug 153266(SCZ-9738), In Modify_Wanted_Delivery_Date__, called Cust_Ord_Date_Calculation_API.Show_Invalid_Calendar_Info 
--  200602           to show  App_Context_SYS value stored in key 'CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_' as info message.
--  200515  PeSuLK   Bug 153930(PJZ-4699), Modified Set_Cancelled() to remove project_id and currency_rate_type from the customer order that is being cancelled
--  200406  ApWilk   Bug 153085(SCZ-9635), Modified Update___() to allow the same information message when changing the route id with a connected shipment.
--  200311  DaZase   SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  200227  NipKlk   Bug 152454 (SCZ-9044), Re-applied the correction of the bug 147950 (SCZ-4398) since it was reversed  in the Xtend delivery to support for UPD 7 with some modifications accordingly.
--  200217  NipKlk   Bug 152454 (SCZ-9044), Re-applied the correction of the bug 147950 (SCZ-4398) since it was reversed  in the Xtend delivery to support for UPD 7.
--  200220  MaRalk   SCXTEND-2838, Merged Bug 147950(SCZ-4398), Modified method Get_Delivery_Information() to avoid call to the Fetch_Default_Delivery_Info() method 
--  200220           when agreement's Exclude from auto pricing is checked and used by Order/Quotation header is unchecked and passed values to the out attr_ to 
--  200220           retain client values when they are not fetch from the server. 
--  200205  RaVdlk   SCXTEND-3100, Modified Check_Update to validate the invoice customer value with the payment term
--  200205  Dihelk   GESPRING20-1789, Implemantation in Customer Order Delivery tab.
--  200116  DhAplk   Bug 151765 (SCZ-8418), Modified Get_Blocked_Reason_Desc() to avoid providing Description of Blocking Problem when add a new CO without any blocking reason. 
--  200114  ErFelk   Bug 146020(SCZ-3107), Added Check_No_Default_Info_Lines() method. Added function Check_No_Def_Info_Src_Lines___(). Modified Modify_Connected_Order___() 
--  200114           by checking the source orders default info together with the cust_ref. This was done to stop the replication trigger if only the header cust_ref is changed 
--  200114           with default info for IPD in the source order. This will solved the multiple change request been created when only the header cust ref is changed 
--  200114           in a 3 or more site flow.
--  200114  HiRalk   GESPRING20-1895, Modified Unpack___() to add invoice_reason functionality.
--  191212  DaZase   SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191212           Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191212           'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  191114  AyAmlk   SCXTEND-1103, Modified Get_Order_Defaults___() to reduce number attribute GET methods by calling the public rec GET.
--  191021  SeJalk   Bug 150597 (SCZ-7466), Modified Insert___() to copy customer charges when source order is null.
--  190930  DaZase   SCSPRING20-156, Added Raise_No_Pay_Addr_Error___ to solve MessageDefinitionValidation issue.
--  191009  HarWlk   Bug 150415 (SCZ-7032), Added UncheckedAccess annotation to Check_Address_Replication__ function.
--  191003  Hairlk   SCXTEND-876, Avalara integration, Modified Insert___, Added code to fetch customer_tax_usage_type from customer if its not available in the attr.
--  190917  MAJOSE   MFUXXW4-29857, Reintroduced Get_Part_Sales_All_Orders - used from Sales and Operations planning
--  190709  KiSalk   Bug 149120(SCZ-5052) Modified Update___ and Modify_Address to improve performance by not accessing objects when not necessary.
--  190610  ApWilk   Bug 148451(SCZ-5121), Modified Do_Release_Blocked___() to stop creating pegged supply when releasing manually blocked CO that goes to Planned status.
--  190517  KiSalk   Bug 140365, Modified methods Get_Ord_Total_Tax_Amount, Get_Total_Base_Price, Get_Total_Sale_Price__, Get_Total_Add_Discount_Amount, Get_Total_Sale_Charge__
--  190429  ChBnlk   SCUXXW4-8515, Corrected according to the code review suggestions of the Template assistant.
--  190517           and Get_Ord_Total_Tax_Amount___ to reduce accessing same tables and code blocks repeatedly.
--  190515  AsZelk   Bug 148272 (SCZ-4546), Modified Insert___() to fix the Incoming Customer Order Customer tax validation error.
--  190417  ShPrlk   Bug 147868 (SCZ-4365), Modified Copy_Customer_Order_Header___ to fetch authorize_code from the order header that is being copied from.
--  190328  ChBnlk   SCUXXW4-8377, Modified Add_Lines_From_Template__() by making the signature IN OUT and returning the attr_ when the method is called FROM_AURENA'.
--  190317  Nipklk   Bug 146297, (SCZ-3080), Modified method Get_Delivery_Information to get the client values of forwarder and shipment type from attr to retain the manually entered
--  190317           forwarder and the shipment type in the customer order when the connected customer agreement doesn't have a ship via code and by removing the ELSE block which assigns 
--  190227  MalLlk   SCUXXW4-9072, Added Build_Attr_For_New__ private method.
--  190204  HaPulk   SCUXXW4-769, Added adjusted_weight_gross_in_charges/adjusted_volume_in_charges to funtion Calculate_Totals used in Freight Group.
--  190317           deliv_term_ and del_terms_location_ from the customer rec when agreement is not changed and agreement has no values for those fields, and further modified Update___ method by removing 
--  190317           the ELSE part of the IF block of delivery information fetching logic when price source is Agreement and price_source_id_ is not null to avoid changing the line DELIVERY_TERMS and DEL_TERMS_LOCATION when header info is not changed. 
--  190301  NipKlk   Bug 147185 (SCZ-3629), Added an 'WS' to the IF block of the method Generate_Co_Number__ to identify if the CO creation is initiated by an external web service call.
--  190124  ErFelk   Bug 146346(SCZ-2814), Removed Get_Blocked_Reason() as blocked_reason attribute was made public from the model.
--  181225  MalLlk   SCUXXW4-9072, Added Funtion Calculate_Totals() to support totals in CustomerOrderHandling Projection.
--  181017  ChBnlk   Bug 144670, Modified cusor get_planned_order_lines in Modify_Line_Purchase_Part_No() by adding a check to allow updating the customer order line with the  
--  181017           purchase part no if the supply code is not decided or invent order.
--  180824  ChBnlk   Bug 143409, Modified Get_Bo_Connected_Order_No() in order to increase the size of the variable order_no_.
--  180814  ChJalk   Bug 143560, Modified the method Recal_Tax_Lines_Add_Disc___ to add the condition to check the rowstate into the CURSOR get_ord_lines.  
--  180726  ChBnlk   Bug 143242, Modified Unpack___() to allow modifying LIMIT_SALES_TO_ASSORTMENTS attribute of the invoice lines in order to process RMAs for
--  180726           invoiced orders.
--  180625  KiSalk   Bug 142674, Passed derived attribute 'NON_DEFAULT_ADDR_CHANGE' to CUSTOMER_ORDER_LINE_API.Modify_Delivery_Address__ in Update___.
--  180621  ShPrlk   Bug 141391, Modified Update___ to allow the code block to be executed whtn the demand_code is null and
--  180621           to avoid replacing with agreement related values if supply code is IPD or PD.
--  180626  DiKuLk   Bug 142095, Modified Calculate_Order_Discount___() to change the calculation of line_discount in order to support calculation of discount for multiple lines.
--  180521  AsZelk   Bug 141237, Used source_tax_item_base_pub view instead of source_tax_item_pub.
--  180517  Cpeilk   Bug 141835, Added new function Get_Default_Order_Type to get the order_type according to the given hierarchy.
--  180509  KiSalk   Bug 141253, Fixed Exists_One_Tax_Code_Per_Line returning false when multiple charge lines exist per CO.
--  180328  ErRalk   Bug 140676, Modified Check_Ipd_Ipt_Exist__ method to bypass information message on pegged orders when pegged orders are not created.
--  180225  ApWilk   Bug 140421, Modified Check_Line_Peggings__() in order to allow any changes in the CO header when there are manual peggings connected with a package part and also 
--  180225           modified Modify_Wanted_Delivery_Date__() to allow changes with the appropriate Info message.
--  180221  DiKuLk   Bug 140020, Modified Fetch_Delivery_Attributes() and Update___() to track if the ship via code is changed.
--  180212  MaEelk   STRSC-16912, Added Order_Lines_Available_To_Copy to check if the lines exist to copy in the given Customer Order.
--  180207  MaEelk   STRSC-16847, Modified Build_Rec_For_Copy_Header___ and fetched value for use_price_incl_tax if misc info is not decided to be copied.
--  180207  NiEdLk   SCUXX-2955, Modified Insert___ to add an interaction record to the customer when a customer order is created.
--  180202  RaVdlk   STRSC-16673, Passed the 'copy_document_texts_' parameter to Customer_Order_Charge_API.Copy_Charge_Lines
--  180201  MaEelk   STRSC-16073, Added possibility to change order_id in Copy Customer Order Functionality.
--  170907  RuLiLk   Bug 137426, Modified method Is_Customer_Credit_Blocked to validate payment customer first. If no payment customer is provided check customer.
--  170907           Modified methods Insert___, Update___, Release_Blocked,  introduced new error messages to raise when the credit blocked customer is the parent customer.
--  180126  MaEelk   STRSC-16195, Modified Check_Insert___ and made use_price_incl_tax to be fetched from customer or site or company level
--  180126           when the use_price_incl_tax doesn't have a value.
--  180111  RaVdlk   STRSC-15725, Copied 'use_price_incl_tax' when 'copy_misc_order_information_' is selected
--  171229  MaEelk   STRSC-15440, Replaced Customer_Agreement_API.Get_State with Customer_Agreement_API.Get_Objstate in Validate_Customer_Agreement___.
--  171219  DiKuLk   Bug 139211, Modified the OUT parameters shipment_type, picking_leadtime_ and delivery_leadtime_ in the method Fetch_Delivery_Attributes
--  171219           to IN OUT in order to get the values from the client.
--  171207  SBalLK   Bug 138918, Modified Check_Rel_Mtrl_Planning() method by adding a parameter to validate that method calling during the customer order release process or not.
--  171130  MaEelk   STRSC-14333, Copied Tax Information irrespective of the customer.
--  171127  MAHPLK   STRFI-10886, Added new parameter to Calculate_Order_Discount__ and Recalculate_Tax_Lines___ 
--  171127           to control the default tax fetching from external tax systems when release customer order.
--  171124  MaEelk   STRSC-14333, Copied Staged Billing Template when copying a customer order to the same customer.
--  171122  ChBnlk   Bug 138033, Modified the OUT parameter route_id_ in the method Fetch_Delivery_Attributes to IN OUT in order to get the values from the client.
--  171121  RaVdlk   STRSC-14452, The value of currency_code is passed to Copy_Customer_Order and Copy_Customer_Order_Header and value is set for CURRENCY_CODE
--  171117  MaEelk   STRSC-14333, Copy Options Delivery Information, Price and Discounts, Document Information, Pre-Accounting
--  171117            were handled irrespective of the customer.
--  171115  MaEelk   STRSC-14333, Enabled Copy Tax Detail option in Copy Customer Order Functionality
--  171110  SBalLK   Bug 138691, Modified Check_Line_Peggings__() method to allow send change request even single line exists with pegging.
--  171105  MAJOSE   STRMF-15603, Added methods Get_Qty_Shipped_Per_Part and Get_Open_Demand_Per_Part. Removed method Get_Part_Sales_All_Orders
--                   These methods are used from Sales and Operations Planning
--  171102  RaVdlk   STRSC-14010, Modified message constant of Record_With_Column_Value_Exist() from VALUENOTEXIST to NODATAINPROCESS to avoid overriding of language translations.
--  171030  MaEelk   STRSC-13747, Copy Delivery Information was considered when copying Delivery Information in CO Line.
--  171024  Nikplk   STRSC-13752, Modified Copy_Customer_Order__ method to copy contacts.
--  171020  MaEelk   STRSC-13153, Copied Address information in Customer Order Line when copy option Address Information is given in Copy Customer Order Functionality.
--  171013  MaEelk   STRSC-12301, Added Copy Custom Fields to Copy Customer Order Functionslity.
--  171012  IzShlk   STRSC-12264, Modified Copy_Customer_Order__ to copy charges.
--  171004  MaEelk   STRSC-12301, Modified Copy_Customer_Order__ to copy copy order lines and rental lines to the copied customer order.
--  170930  IzShlk   STRSC-12264, Modified Copy_Customer_Order__() to copy charge lines.  
--  170928  RaVdlk   STRSC-12351, If a coordinator is not defined for a user against the site an error message is given 
--  170927  KHVESE   STRSC-12224, Modified method Create_Data_Capture_Lov to enable order no's lov descriptions to be set from config detail id.
--  170926  RaVdlk   STRSC-11152, Removed Get_State and Get_Objstate functions, since they are generated from the foundation
--  170926  IzShlk   STRSC-12381, Included DEFAULT_CHARGES to attr when copy customer order in order to denote whether the charges were fetched as defults or
--                                to copy the charges.
--  170925  RaVdlk   STRSC-12281, If no order type is defined at Site or Customer, copied the order type from the previous CO.
--  170925  TiRalk   STRSC-12291, Modified Undo_Line_Delivery by allowing to undo internal customer orders.
--  170922  RaVdlk   STRSC-12270, Added a new line in the customer order history to denote that CO was copied from another order
--  170921  KiSalk   Bug 137837, In Update___, stopped changing delivery information (came from external customer) of Int Purch direct delivery lines when agreement is changed.
--  170907  MaEelk   STRSC-11780, Fetched correct values for Freight information in Build_Rec_For_Copy_Header___ when copying a CO with Delivery Information. 
--  170906  KiSalk   STRSC-10931, In Finite_State_Set___ removed check if NOT super state, to create event on status change
--  170830  MaEelk   STRSC-11780, Added Copy Pre Accounting Functionality to the Coppy Customer Order
--  170901  IzShlk   STRSC-11319, Added validation for Get_Order_Defaults___ to check access for customer brfore it fetch default values to customer order.
--  170830  MaEelk   STRSC-11184, Removed the restriction in copying B2B Customer orders.
--  170829  MaEelk   STRSC-11780, Restructured the logic in Copy_Customer_Order_Header___ and introduced Build_Rec_For_Copy_Header___
--  170816  MaEelk   STRSC-11192, Modified Buid_Attr_For_Misc_Ord_Info___ to fetch valid customer_no_pay_addr_no and customer_no_pay_ref to the new CO.
--  170721  MaEelk   STRSC-10739, Created the Customer Order Header with Copy Options.
--  170718  KhVese   STRSC-8846, Added new methods Record_With_Column_Value_Exist, Get_Column_Value_If_Unique, Create_Data_Capture_Lov.
--  170714  IzShlk   STRSC-10803, Generic method Get_Eligible_Representative() has been called to select main representative when we create a CO.
--  170710  SucPlk   STRSC-8704, Modified Exists_One_Tax_Code_Per_Line() to check whether multiple tax lines exist for a charge line in CO. 
--  170516  MeAblk   Bug 135850, Modified Update___() to set the server_data_change as true when modifying the CO line price/discount info.
--  170506  MeAblk   STRSC-7433, Modified  Release_Blocked__() to clear any blocked reason exists for the CO if the order is not blocked.
--  170502  SURBLK   Added tax structure validation in to the check update.
--  170404  KiSalk   Bug 135001, Allowed agreements of hierachy parents in Validate_Customer_Agreement___.
--  170403  KoDelk   STRSC-6363, Rename BusinessObjectRep to BusObjRepresentative
--  170404  SudJlk   STRSC-6948, Added dynamic dependency to the call to Crm_Cust_Info_API.
--  170323  TiRalk   LIM-11166, Reversed the correction which is done through this task.
--  170322  Jhalse   LIM-10113, Reworked how Uses_Shipment_Inventory determines how an order uses shipment inventory.
--  170317  Jhalse   LIM-10113, Added method for getting a default shipment location for an order.
--  170314  TiRalk   LIM-11166, Modified Check_Update___ to restrict editing Customer's PO no when the CO line demand code is IPD.
--  170314  NiNilk   Bug 134526, Modified Update___ to set the part price of customer order lines correctly irrespective of  price freeze flag value, when changing the agreement Id.
--  170307  Jhalse   LIM-10113, Modifed Uses_Shipment_Inventory to always return true when using an automatic shipment creation type.
--  170217  JanWse   VAULT-2472, When an object is ceated add the logged in user as a representative to give him/her rights on the new object
--  170220  LaThlk   Bug 133405, Modified Get_Delivery_Information() in order to set delivery information from the client when only the agreement_id is changed not the ship_addr.
--  170201  LaThlk   Bug 133169, Avoided the value change of shipment_changed_ by modifying the if condition in order to stop adding same info message twice when called through CO Line.
--  170111  LaThlk   Bug 131981, Modified Generate_Co_Number___() in order to pass order_no_ when calling Incr_Cust_Order_No_Autonomous() and Increase_Cust_Order_No().
--  170127  SudJlk   VAULT-2418, Changed the order of code in Insert___ to have the main repreesntative saved as soon as the header is saved (needed for CRM access).
--  170124  JeeJlk   Bug 133724, Reversed the bug 122944 and Modified Calculate_Order_Discount___ by removing the stage billing recalculation logic in parent level as the stage
--  170124           billing recalculation is done in customer order line level.
--  170117  SURBLK   Added Restrict by assortment functionality in to Customer Order.
--  170106  ErFelk   Bug 131473, Modified Check_Insert___() to fetch the freight price list according to the forward_agent_id.
--  161216  ChJalk   Bug 133170, Modified the method Update___ to avoid clearing the info added from the Customer Order when calling Customer Order Line Updates. The correction for the 
--  161216           bug 125233 was moved to cater any possible clearing when updating Customer Order Lines.
--  161129  NWeelk   FINHR-2035, Modified Insert___ by using customer tax liability type to validate the order tax liability.
--  161028  Hairlk   APPUXX-5312, Modified message ERRORRELEASDN to indicate that Rejected quotation lines are also considered.
--  161026  SudJlk   VAULT-1900, Added Main_Representative_Id to Customer_Order and Check_Edit_Allowed().
--  161013  Maabse   APPUXX-5297, Added Get_B2b_Delivery_Info___ called from Check_Update___ for B2b Process.
--  161011  TiRalk   STRSC-4210, Modified Check_Common___ by adding error message ERRADDREBATECUS to avoid enter the rebate customer same as the ordering customer.
--  160914  matkse   APPUXX-4723, Modified Get_Order_Defaults___ to set B2B_ORDER if not provided from user.
--  160907  SudJlk   STRSC-3927, Modified Get_Order_Defaults___ to fetch agreement only if it is to be used by CO header.
--  160906  SWeelk   Bug 131217, Modified Unpack___() by adding CUSTOMER_NO_PAY_REF to the name list so the invoicing customer ref can be edited for invoiced COs.
--  160826  Dinklk   APPUXX-3413, Added Check_Diff_Delivery_Info.
--  160823  MaIklk   LIM-8426, Handled to popup message when changing customs value currency if order is connected to shipment lines.
--  160810  TiRalk   STRSC-3788, Modified Unpack___ to avoid error when the CO state is Partially Delivered with a CO line Invoiced while trying to block.
--  160810           Modified Uncheck_Rel_Mtrl_Planning to raise message when blocking order with block reason exclude material planning check box checked where
--  160810           the CO state is Reserved, Picked or Partially Delivered.
--  160808  TiRalk   STRSC-3788, Modified method name Set_Rel_Mtrl_Planning to Uncheck_Rel_Mtrl_Planning.
--  160803  TiRalk   STRSC-3747, Modified Set_Rel_Mtrl_Planning validate and raise a message for reserved orders.
--  160802  TiRalk   STRSC-3747, Modified Release_Connected_Blocked_Ord to release connected from blocked due to manual blocking.
--  160728  TiRalk   STRSC-2799, Added seperate method Set_Rel_Mtrl_Planning to validate rel_mtrl_planning for manual blocking.
--  160725  TiRalk   STRSC-3681, Modified Set_Blocked to set history for BLKFORMANUALEXT.
--  160722  MaIklk   LIM-8053, Renamed SHIPMENT_CREATION to SHIPMENT_CREATION_CO in shipment_type_tab.
--  160714  TiRalk   STRSC-2713, Modified Set_Blocked and Release_Blocked methods to handle rel_mtrl_planning for manual blocking. 
--  160711  TiRalk   STRSC-1193, Added Order_Is_Planned___ to handle the logic when releasing the manually blocked order from state planned.
--  160707  TiRalk   STRSC-2714, Modified Release_Blocked by adding RELEASEMANUALBLOCK to add CO history. Modified Get_Blocked_Reason_Desc
--  160707           by adding BLKFORMANUAL to display block reason.
--  160705  TiRalk   STRSC-1189, Modified event names Do_Release_Credit_Blocked___, Release_Credit_Blocked__, Set_Credit_Blocked__
--  160705           to Do_Release_Blocked___, Release_Blocked__, Set_Blocked__  in state machine. Modified method names Set_Credit_Blocked, 
--  160705           Added Order_Is_Manual_Block___ and event SetBlocked to allow blocking in planned state only for manually block. 
--  160705           Release_Credit_Blocked, Start_Release_Credit_Blocked to Set_Blocked, Release_Blocked, Start_Release_Blocked.
--  160704  TiRalk   STRSC-2719, Added new column blocked_type and merge column values of cr_stop, adv_pay_block to new column
--  160704           Removed method Modify_Credit_Flag__ as it is not needed anymore.
--  160629  TiRalk   STRSC-2702, Changed state from CreditBlocked to Blocked to be more generic to handle all the block types.
--  160628  BudKlk   Bug 129560, Modified the method Add_Lines_From_Template__() to retrive the value of the attribute COPY_DISCOUNT.
--  160627  SBalLK   Bug 130042, Modified Build_Attr_For_New___() by increasing the length of new_attr_ variable in order to avoid character buffer too small error when header note text use its full length.
--  160623  SudJlk   STRSC-2697, Replaced customer_Order_Address_API.Public_Rec with customer_Order_Address_API.Cust_Ord_Addr_Rec and 
--  160623           customer_Order_Address_API.Get() with customer_Order_Address_API.Get_Cust_Ord_Addr().
--  160616  ChJalk   Bug 127627, Modified the method Fetch_Delivery_Attributes to change the OUT parameter forward_agent_id_ to IN OUT.
--  160614  SWeelk   Bug 124046, Modified Update___() by adding a new info message to pop up if the Order is a distribution order and a header level edit is done and it will reflect on the line level.
--  160606  ChBnlk   STRSC-2001, Modified New_Order_Lines_Allowed() by removing the check for the order state 'Delivered' to allow adding new lines
--  160606           for already delivered customer orders.
--  160603  MeAblk   Bug 129620, Modified Set_Released() to add a history log for reserving customer order when releasing it having order lines reserved.
--  160601  MAHPLK   FINHR-2018, Removed Validate_Tax_Calc_Basis___.
--  160518  Chwilk   Bug 129151, Added method Has_Demand_Code_Lines to return TRUE if at least one line in the specified CO has the required demand code.
--  160511	MeAblk	Bug 128921, Modified Release_Credit_Blocked() to validate unpaid advance invoices when releasing credit block check from 'Planned' state.
--  160509  ChFolk   STRSC-2222, Added anotation Uncheckaccess for Get_Bo_Connected_Order_No.
--  160505  JeeJlk   Bug 128232, Modified Find_Open_Scheduling_Order to filter CO data with ship_addr_no to stop adding co line(s) to COs with 
--  160505           different ship_addre_no but the same Customer PO number.
--  160420  NWeelk   STRLOC-244, Modified Build_Attr_For_New___ to set FREE_OF_CHG_TAX_PAY_PARTY_DB when the CO is created from a quotation.
--  160406  PrYaLK   Bug 128275, Modified Add_Lines_From_Template__() to add the rental related attributes so that rental lines are added to the rental tab when using Customer Order template.
--  160404  NWeelk   STRLOC-333, Added method Tax_Paying_Party_Changed___ to modify the free of charge customer order lines. 
--  160328  ShPrLk   Bug 127644, Modified Modify_Address() by removing the code block to set the tax liability as EXEMPT which was added from bug 123263. Added a code block to trigger the changed message
--  160328           TAXLIABILITY when the address flag is set and if the vat free vat code does not match with the customers vat free vat code and customer vat free vat code is null.
--  160311  DipeLk   STRLOC-260,Make tax paying party mandatory.
--  160308  MeAblk   Bug 127480, Modified All_Charges_Fully_Invoiced___(), Order_Is_Fully_Invoiced___(), Uninvoiced_Charges_Exist() to correctly handle the negative charged_qty.
--  160215  AyAmlk   Bug 126985, Modified Set_Line_Qty_Assigned() by removing the condition which checks the add_hist_log_ in order to allow inserting CO history log when a CO is reserved.
--  160211  IsSalk   FINHR-685, Renamed attribute FEE_CODE to TAX_CODE in Customer Order Charge.
--  160203  ErFelk   Bug 125233, Modified Update___() to avoid clearing the info added from the Customer Order when calling Customer_Order_Line_API.Modify_Order_Defaults__(). 
--  160202  IsSalk   FINHR-647, Redirect method calls to new utility LU TaxHandlingOrderUtil.
--  160201  MeAblk   Bug 126778, Added new paramter checking_state_ into the method Set_Credit_Blocked() and modified methods Release_Credit_Blocked__(), Set_Credit_Blocked()
--  160201           to make it possible to create the shipment when releasing the order having lines are reserved.
--  160201  SBalLK   Bug 125958, Added Get_Total_Sales_Price() method to fetch customer order total amount in order currency.
--  160201  RasDlk   Bug 126224, Added method All_Lines_Expctr to return TRUE if all the lines in the specified CO are export controlled.
--  160104  RoJalk   LIM-5717, Replaced Shipment_Handling_Utility_API.Create_Automatic_Shipments with Shipment_Order_Utility_API.Create_Automatic_Shipments.
--  151231  HimRlk   Bug 125672, Reversed correction of bug 121435. Modified Get_Delivery_Information() to set delivery information to default values only when the 
--  151231           agreement_id has changed and corresponding values are null.
--  151229  MaIklk   LIM-5720, Passed source ref type when calling Any_Shipment_Connected_Lines() and Shipment_Connected_Lines_Exist() in Shipment_Handling_Utility_API.
--  151221  SeJalk   Bug 125890, Modified Crdt_Chck_Valid_Lines_Exist__ to include order lines in state PartiallyDelivered as valid lines to credit check.
--  151210  MaIklk   LIM-4060, Checked whether any shipment exists for given order no in check_delete.
--  151119  IsSalk   FINHR-327, Renamed attribute VAT_NO to TAX_ID_NO in Customer Order Line and Customer Order.
--  151111  AyAmlk   Bug 125662, Modified Modify_Wanted_Delivery_Date__() in order to give the same info message as line level at price effective date change
--  151111           due to the wanted delivery date change from the CO header which has manual discount line(s).
--  151014  PrYaLK   Bug 124815, Modified Validate_Proposed_Prepay___() so that allows to update Required Prepayment Amount when the customer order is in Partially Delivered
--  151014           state. Modified Unpack___() by adding PROPOSED_PREPAYMENT_AMOUNT, EXPECTED_PREPAYMENT_DATE, PREPAYMENT_APPROVED_DB and PREPAYMENT_APPROVED as they need to be editable for invoiced COs.
--  151001  ErFelk   Bug 124888, Some message constants were renamed to CREATEPOCOAUTO, NONDEFLINEDATESCHANGED and NONDEFEARLYLINEDUEDATE in Update___().
--  150901  KhVeSE   AFT-2933, Added new method Has_Non_Def_Info_Lines to check if there is any line with same address as header.
--  150825  MAHPLK   KES-1343, Added new default parameter add_hist_log_ to Set_Line_Qty_Picked() and modified Do_Set_Line_Qty_Picked___(). 
--  150819  MAHPLK   KES-1343, Added new default parameter from_undo_delivery_ to Set_Line_Qty_Shipped().
--  150710  Hecolk   KES-1027, Cancelling Preliminary Self-Billing CO invoice
--  150630  KhVeSE   COB-14, Added logic to method Update___() to copying header address to the lines with no default info set but same addr as header. 
--  150616  MeAblk   Bug 122831, Added new attribute customer_no_pay_ref and modified file accordingly.
--  150708  MAHPLK   KES-1004, Modified Undo_Line_Delivery () to recalculate project cost after undo delivery .
--  150706  Hecolk   KES-880, Cancelling Preliminary Staged Billing CO invoice  
--  150611  ChBnlk   ORA-385, Modified New() by moving the attribute string manipulation to seperate method. Introduced new method Build_Attr_For_New___()
--  150528  MAHPLK   KES-508, Added new methods Undo_Line_Delivery () and Do_Undo_Line_Delivery___()
--  150611           for the attr_ manipulation.
--  150519  RoJalk   ORA-161, Modified Get_Order_Defaults___ and replaced Cust_Ord_Customer_Address_API.Get_Contact with Cust_Ord_Customer_API.Fetch_Cust_Ref
--  150910  ErFelk   Bug 123263, Reversed the previous correction of this bug. Modified Modify_Address() so that CO header tax liability is set to EXEMPT when the CO header address is Single Occurrence 
--  150910           and vat_free_vat_code_ is been specified.
--  150817  RasDlk   Bug 120649, Modified Is_Expctr_Connected by passing the correct value for licensed_order_type_.
--  150729  JaBalk   Bug 120753, Modified Generate_Co_Number___ to avoid dead lock.
--  150728  ChBnlk   Bug 106789, Added new method Add_Lines_From_Template__ to insert bulk of Co lines through templates. 
--  150728  ChBnlk   Bug 122944, Modified Calculate_Order_Discount___ to pass values to the parameter amount_changed_ in method call Order_Line_Staged_Billing_API.Recalculate().
--  150720  ErFelk   Bug 123263, Added new procedure Modify_Tax_Liability().
--  150608  SBalLK   Bug 121499, Modified Validate_Proj_Connect___ to stop raising CUSTOWNER error when the CO is created from external service order.
--  150525  JeeJlk   Bug 121435, Modified Update___ and Get_Delivery_Information not to set ship via code, delivery term and delivery term location to default values when customer agreement corresponding values are null.
--  150429  NWeelk   Bug 122325, Modified All_Charges_Fully_Invoiced___, Order_Is_Fully_Invoiced___ and Uninvoiced_Charges_Exist to retrieve un-invoiced charge lines 
--  150429           correctly by selecting records which has invoiced_qty less than charged_qty instead of using not equal sign.
--  150325  JeLise   COL-145, Added 'IPT' to the cursors in Release_Connected_Blocked_Ord to release these orders too.
--  150226  JeLise   PRSC-6291, Added override of Check_Common___ to check that supplier is not internal supplier on the same site as the order.
--  150226  NaLrlk   PRSC-6295, Modified Valid_Ownership_Del_Line_Exist to allow CRA ownership for non rentals.
--  150226  RasDlk   PRSC-4595, Modified Update___() to set the fee code of the CO line according to CO header if there is a change in supply country.
--  150225  SudJlk   Bug 121037, Modified Check_Line_Peggings__ to check for qty_on_order to correctly check for pegging when the part is DOP.
--  150218  NaLrlk   PRSC-6201, Modified New_Rental_Replacement_Order() to avoid copyng order confirmation.
--  150214  MaIklk   PRSC-5255, Handled to remove old sales contract connection when you connect same contract to new customer order.
--  150211  MAHPLK   PRSC-5852, Added new parametrer changed_attrib_not_in_pol_ to Modify_Wanted_Delivery_Date__() and modified Check_Update___ ().
--  150210  MeAblk   PRSC-5505, Modified Calculate_Order_Discount___ in order to avoid updating group discount on the order line when price freeze restriction done on site and line levels.
--  150210  RoJalk   PRSC-6007, Added the method Check_Address_Replication__ to be used in customer order address replication.
--  150129  MAHPLK   PRSC-4770, Merged Bug 119576, Modified Update___() so that Modify_Line_Default_Addr_Flag() is called when header vendor no is changed. 
--  150127  RoJalk   PRSC-5391, Modified Unpack___ and added REPLICATE_CHANGES, CHANGE_REQUEST to the item list to include for Orders with invoiced lines.  
--  150121  UdGnlk   PRSC-5330, Modified Get_Order_Defaults___() to encode the value of PRINT_DELIVERED_LINES.
--  141202  RoJalk   PRSC-4341, Modified Check_Ipd_Ipt_Exist__ and added the info parameter.
--  141128  SBalLK   PRSC-3709, Modified Get_Order_Defaults___(),. Update___(), Modify_Address(), Get_Delivery_Information(), Get_Customer_Defaults(), Fetch_Delivery_Attributes() and Fetch_Default_Delivery_Info()
--  141128           methods to fetch delivery terms and delivery terms location from supply chain matrix.
--  141126  RoJalk   PRSC-4019, Modified Check_Ipd_Ipt_Exist__ to check send_change_ when only PD or PT exits.
--  141126  RoJalk   PRSC-4341, Modified Check_Ipd_Ipt_Exist__ so the send_change_ will be true if at least one line is enabled to send ORDCHG.
--  141125  RoJalk   PRSC-2177, Added code to Modify_Connected_Order___ to replicate language_code.
--  141124  PeSulk   Modified Calculate_Order_Discount___ to calculate group discounts based on volume and weight for rental lines.
--  140620  BudKlk   Bug 117462, Renamed method New_Charge_Added() to New_Or_Changed_Charge() and change the state name NewChargeAdded to NewOrChangedCharge.
--  141113  RasDlk   Bug 116770, Modified methods Check_Insert___, Check_Update___ by adding the info message INVCUSEXPIRED to invoke when invoicing customer is expired.
--  141113  RoJalk   Modified Modify_Connected_Order___ to identify the situation where label note is changed. 
--  141110  RoJalk   PRSC-3986, modified the method Check_Ipd_Ipt_Exist__ and added the parameter only_ipt_exist_.
--  141031  SBalLK   PRSC-421 , Modified Get_Order_Defaults___() method to fetch customer agreement id when agreement id is not already fetched and valid customer agreement exist.
--  141030  RoJalk   Modify Modify_Connected_Order___ and removed the check_ipd_exists_ since header replication must have at least one IPD.
--  141028  RoJalk   Added the method Modify_Connected_Order___ to handle CO header replication. 
--  141022  NaLrlk   Added methods Set_Rent_Line_Completed() and Set_Rent_Line_Reopened() to status handling for rental line invoicing.
--  141021  MAHPLK   Added new method Check_Ipd_Ipt_Exist__ to check whether any CO line exist with supply code IPD or IPT.
--  141020  RoJalk   Modify Update___ and called Connect_Customer_Order_API.Modify_Connected_Order to replicate order header info - ORDCHG.
--  141013  SlKapl   FIPR19 Multiple tax handling in CO and PO flows - corrected Get_Tot_Charge_Base_Tax_Amount, Get_Tot_Charge_Sale_Tax_Amt, Get_Total_Sale_Charge_Gross__ 
--  141013  UdGnlk   PRSC-3138, Modified Update___() to include the discount freeze functionality.
--  140919  NaLrlk   Modified Created_From_Int_Po__() to consider IPT_RO demand_code for replacement rental.
--  140912  HimRlk   PRSC-2447, Modified enumeration value of print_delivered_lines to Delivery_Note_Options_API.
--  140908  ShVese   Removed unused cursor get_int_order_info in Start_Release_credit_Blocked.
--  140825  NWeelk   Bug 118451, Modified Release_Credit_Blocked to distinguish the two scenarios released from credit check and release blocked orders by giving two history records
--  140825           and passed release_from_credit_check_ to method Release_Credit_Blocked from Release_Connected_Blocked_Ord and Start_Release_credit_Blocked.
--  140812  SlKapl   FIPR19 Multiple tax handling in CO and PO flows - replaced Customer_Order_Line_API.Get_Total_Tax_Amount by Customer_Order_Line_API.Get_Total_Tax_Amount_Base
--  140704  AyAmlk   Bug 117634, Modified Set_Line_Cancelled() to compare the CO state before and after cancelling the value in order to allow creating the CO history record when line is cancelled.
--  140702  MaEdlk  Bug 117072, Removed rounding of variable total_weight_ from Get_Total_Weight__ and Get_Total_Gross_Weight__.
--  140702          Removed rounding of total gross weight from the method Get_Adj_Weight_In_Charges.Removed rounding of total gross volume from the method Get_Adj_Volume_In_Charges.
--  140519  RoJalk   Modified Set_Released__ and fetched a value for newrec_.
--  140514  NIWESE   PBSC-8638 Added call to custom validation for Cancel Reason codes.
--  140513  Vwloza   Updated New_Rental_Replacement_Order with RCO validation by removing PROJECT_ID nulling statement.
--  140508  HimRlk   Added new method Check_Del_Country_Code_Ref___() to validate tax liability with delivery country code.
--  140502  UdGnlk   PBSC-8181, Merged bug 115917 Removed method Check_Exp_Conn_And_Auth and added Is_Expctr_Connected to return true if the CO is connected to an export license
--  140429  RoJalk   Replaced Company_Order_Info_API.Get_Delay_Cogs_To_Dc_Db with Company_Order_Info_API.Get_Delay_Cogs_To_Deliv_Con_Db
--  140414  ShVese   Replaced the usage of CUSTOMER_ORDER_JOIN by accessing the customer_order and customer_order_line tables in Modify_Line_Purchase_Part_No.
--  140408  ChBnlk   Bug 116100, Removed the implementation methods Invoiced___ and Exists_Freight_Info_Lines___ and added new public methods Exists_Freight_Info_Lines and 
--  140408           Has_Invoiced_Lines. Modified Unpack___ and Validate_Jinsui_Constraints___ to use the newly introduced methods.
--  140227  MatKse   Bug 115429, Added Get_Id_Version_By_Keys.
--  140217  TiRalk   Bug 112795, Modified Insert___ and Generate_Co_Number___ to consider the added autonomous transaction to avoid
--  140217           locking the order_coordinator_group_tab when creating bulk COs from Customer Schedules.
--  140106  AyAmlk   Bug 113893, Added Order_Delivered___() and modified Finite_State_Machine___() to trigger event ORDER_DELIVERED when the CO header state is changed to Delivered.
--  140321  HimRlk   Modified logic to pass use_price_incl_tax value when fetching freight price lists.
--  140127  HimRlk   Merged Bug 110133-PIV, Modified methods Calculate_Order_Discount___() , Get_Ord_Line_Totals__(), and Get_Total_Add_Discount_Amount() 
--  130830           by changing  Calculation logic of line discount amount to be consistent with discount postings.
--  130830           Removed cursor get_total_base_price from method Calculate_Order_Discount___.
--  130830           Removed view CUSTOMER_ORDER_TAX_LINES used for ProformaInvoice report. View is re-written in ProformaInvoice.rdf as the cursor get_tax_lines_summary.  
--  130830           Modified method Get_Ord_Gross_Amount, logic should handle separately when price including tax is not specified.
--  140306  RoJalk   Modified Release_Credit_Blocked__ and fecthed a value for rec_.
--  140305  KiSalk   Bug 114804, Moved info handling from Cancel_Order___ of Cancel_Customer_Order_API, to Set_Cancelled in order 
--  140305           to preserve info added by Event Actions on state change to Cancelled.
--  140303  NWeelk   Bug 113825, Added derived attribute disconnect_exp_license, added method Check_Exp_Conn_And_Auth and added parameter disconnect_exp_license_ to 
--  140303           Modify_Wanted_Delivery_Date__ to enable changing license date if the new planned ship date is within the accepted range of the license. 
--  140219  NaSalk   Modified Calculate_Order_Discount___ to consider rental chargeable days.
--  140213  NaSalk   Modified Get_Ord_Line_Totals__.
--  130912  RuLiLk   Bug 112346, Removed view CUSTOMER_ORDER_TAX_LINES used for ProformaInvoice report. View is re-written in ProformaInvoice.rdf as the cursor get_tax_lines_summary.  
--  130912  IsSalk   Bug 111274, Modified Get_Order_Defaults___(), Modify_Address() and Unpack_Check_Update___() to update vat no according to the delivery country code.
--  130830  ChBnlk   Bug 112135, Modified procedure Get_Next_Line_No to set the line number to 1 when it is NULL and to display the error message
--  130830           when entering values beyond 9999 to the column line_no, when catalog_no_ is NULL or supply code is COMPONENT_REPAIR_ORDER. 
--  130822  IsSalk   Bug 107531, Added STATISTICAL_CHARGE_DIFF to CO_CHARGE_JOIN view to display statistical charge diff in overview - Customer Order Charges window. 
--  130730  RuLiLk   Bug 110133, Modified method Calculate_Order_Discount___, removed cursor get_total_base_price.
--  130719  ChBnlk   Bug 110980, Added a new function Exists_Freight_Info_Lines___() to check for the invoiced lines with freight information and modified 
--  130719           Unpack_Check_Update___() to stop modifying the SHIP_VIA_CODE when the order lines are invoiced with freight information. 
--  130701  RuLiLk   Bug 107700, Added Generate_Co_Number___() to handle logic of method Generate_Co_Number(). If the customer order creation is sourced from
--  130701           sales quotation (CQ), work order (WO) or incoming customer order flow (ICO), autonomous transaction is used to release the order_coordinator_group_tab lock.
--  130701           Added parameter rel_from_credit_check_ into Release_Credit_Blocked() and removed Release_From_Credit_Check().
--  130701  SudJlk   Bug 107700, Modified Generate_Co_Number removing the check for external customer order no as the functionality will be replaced by autonomous transaction.  
--  130630  RuLiLk   Bug 110133, Modified methods Calculate_Order_Discount___() , Get_Ord_Line_Totals__(), Get_Total_Add_Discount_Amount()  and view  CUSTOMER_ORDER_TAX_LINES 
--  130630           by changing  Calculation logic of line discount amount to be consistent with discount postings.
--  130620  AyAmlk   Bug 110764, Modified Calculate_Order_Discount___() so that the discount is updated only if there is any change.
--  130613  IsSalk   Bug 110270, Added method Check_Rel_Mtrl_Planning(). Modified method Release_Credit_Blocked() to set Release for Material Planning during the CO release
--  130613           and during Release from Handle Blocked Orders.
--  130607  Cpeilk   Bug 110375, Modified method Update___ to avoid an unnecessary call to CO line Modify_Order_Defaults__ when only header modification is required. 
--  130603  GanNLK   Bug 110060, Added General_SYS.Init_Method for Customer_Order_API.Check_Ipd_Tax_Registration procedure.
--  130603  ChBnlk   Bug 109515, Modified procedure Get_Next_Line_No to display the proper error message when entering values beyond 9999 to the column rel_no
--                   and to display the error message properly when entering values beyond 9999 to the column line_no. 
--  130426  SudJlk   Bug 109578, Added method Check_Line_Peggings__ to move validations for peggings and send order message so that the replication dialogbox can be displayed correctly.
--  130916  MAWILK   BLACK-566, Replaced Component_Pcm_SYS.
--  130828  MaMalk   Made Shipment_Creation mandatory.
--  130808  SURBLK   Added Block_Connected_Orders()and Release_Credit_Blocked().
--  130712  HimRlk   Replaced Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes() with Cust_Order_Leadtime_Util_API.Fetch_Head_Delivery_Attributes().
--  130712  ShKolk   Modified fetching sequence of PRIORITY and ORDER_ID to Site/Customer, Site, Customer.
--  130530  SURBLK   Added Start_Release_credit_Blocked().
--  130529  JeeJlk   Added method Crdt_Chck_Valid_Lines_Exist__ and Log_Manual_Credit_Check_Hist__. Modified Get_Blocked_Reason_Desc and Set_Credit_Blocked by adding HISTBLKFORCREMANUAL, HISTBLKCRELMTMANUAL, HISTBLKFORADVPAYMNL and HISTBLKFORPREPAYMNL.
--  130521  HimRlk   Modified Get_Order_Defaults___, Modify_Address, Get_Delivery_Information, Fetch_Delivery_Attributes and Fetch_Default_Delivery_Info
--  130521           to fetch and pass vendor_no when retrieving delivery information.
--  130515  SURBLK   Added BLKFORCREEXT and BLKCRELMTEXT into Set_Credit_Blocked() and Get_Blocked_Reason_Desc().
--  130508  HimRlk   Added new public column vendor_no.
--  130507  MaMalk   Reversed the correction did for shipment_creation.
--  130424  MaMalk   Modified Update___ to support for combining 2 shipment creation methods exist for pick list creation to 1.
--  130422  MaMalk   Replaced all the messages mentioned shipment_creation with the shipment_type.
--  130419  MeAblk   Added packing_instruction_id into the view CUSTOMER_ORDER_JOIN_UIV.
--  130416  MaMalk   Made Shipment_Creation not mandatory, not insertable and not updatable in the logic since it will be fetched from the server.
--  130409  MaMalk   Made the default shipment_type to 'NA' instead of 'NS' in Unpack_Check_Insert___.
--  130102  MeAblk   Modified Unpack_Check_Update___ in order to make it possible to update the shipment type while the order lines are connected with shipments.
--  121205  MeAblk   Revised the correction done for Do_Set_Line_Qty_Shipped___ which updates the  package reserved qty when a non-inventory component part is partially delivered.   
--  121126  MeAblk   Modified the method Do_Set_Line_Qty_Shipped___ in order to correctly update the package reserved qty when a non-inventory component part is partially delivered.   
--  121022  MaMalk   Allow connecting a customer order line to several shipment lines- added Open_Shipment_Qty to views CUSTOMER_ORDER_JOIN and CUSTOMER_ORDER_JOIN_UIV.
--  120911  MeAblk   Added ship_inventory_location_no_ as a parameter to methods Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults, Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120829  MaEelk   Removed All_Lines_Shipment_Connected.
--  120824  MaMalk   Added shipment_type as a parameter to Fetch_Delivery_Attributes.
--  120824  MeAblk   Changed the number of parameters in methods Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults. Also modified methods Fetch_Default_Delivery_Info
--  120824           Also modified methods Fetch_Default_Delivery_Info to fetch the shipment_type. Modified Get_Order_Defaults___  in order to get the shipment type from Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120824  MaMalk   Added shipment_type as a parameter to method Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes.
--  120821  ChFolk   Added new method Get_Addr_Flag_Db which returns db value of addr_flag.
--  120822  MeAblk   Modified the methods Prepare_Insert___ and Get_Order_Defaults___ in order to correctly get the default shipment type when creating a new customer order.
--  120821  MeAblk   Modified procedure Get_Order_Defaults___ in order to retrieve the default shipment type when creating a customer order.
--  120730  MaEelk   Added All_Lines_Shipment_Connected that would return true if the entire order is shipment connected.
--  120723  ChFolk   Added new functions Comp_Owned_Deliv_Line_Exist.
--  120719  ChFolk   Added new LOV view CO_RMA_LOV to be used in RMA.
--  120711  RoJalk   Modified the scope of shipment_type attribute to be public.
--  120711  MaHplk   Added picking lead time as parameter to Cust_Ord_Date_Calculation_API.Calc_Order_Dates_Backwards in Calculate_Planned_Due_Date
--                   and CUSTOMER_ORDER_JOIN_UIV, CUSTOMER_ORDER_JOIN_UIV views.
--  120710  RoJalk   Modified Unpack_Check_Update___ and added a validation to check if any order lines are shipment connected when shipment type is modified.
--  120709  RoJalk   Added the field shipment_type.
--  120702  MaMalk   Changed the number of parameters in methods Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults,Fetch_Delivery_Attributes and Get_Supply_Chain_Defaults. 
--  120702           Also modified methods Fetch_Default_Delivery_Info, Fetch_Delivery_Attributes and Get_Delivery_Information to fetch the route and the forwarder correctly.
--  130715  bhkalk   TIBE-2336 Added a parameter to Calendar_Changed() to resolve a scalability issue.
--  ------------------------------APPS 9-------------------------------------
--  130705  MaRalk   TIBE-972, Removed following global LU constants and modified relevant methods accordingly.
--  130705           inst_Project_ - Update___, Exist_Project___, Validate_Proj_Connect___, Validate_Proj_Disconnect___, Valid_Project_Customer__, Modify_Project_Id,
--  130705           inst_WorkOrderPlanning_ - Is_Sm2001_Installed__, inst_PurchaseOrder_ - Block_Backorder_For_Eso___, inst_PurchasePartSupplier_- Calculate_Planned_Due_Date, 
--  130705           inst_DistributionOrder_ - Insert___, Get_Order_Defaults___, Is_Dist_Order_Exist___, Release_Credit_Blocked, inst_CcCaseTask - Unpack_Check_Insert___, 
--  130705           Unpack_Check_Update___, Finite_State_Set___ , inst_jinsui_- Unpack_Check_Insert___, Unpack_Check_Update___,Get_Order_Defaults___,  
--  130705           inst_ContractManagement_ - Unpack_Check_Insert___, Validate_Sales_Contract___, inst_OnAccountLedgerItem_ - Validate_Proposed_Prepay___, 
--  130705           inst_DopDemandCustOrd_ - Modify_Wanted_Delivery_Date__, inst_ConfigManager_ - Get_Revision_Status___.    
--  130823  CHRALK   Modified view CUSTOMER_ORDER_JOIN by adding rental column.
--  130729  KaNilk   Modified Get_Ord_Line_Totals__ method.
--  130723  NaSalk   Added Rental_Lines_Exist.
--  130201  Vwloza   Added rental parameter to Get_Next_Line_No.
--  121221  CHRALK   Modified method Get_Ord_Line_Totals__(), by changing calculations for rental lines.
--  121207  CPriLK   Added rental_db to CUSTOMER_ORDER_JOIN_UIV.
--  121116  NaSalk   Modified Validate_Proj_Connect___ to include Company Rental Asset ownership in validations.--  130426  SudJlk   Bug 109578, Added method Check_Line_Peggings__ to move validations for peggings and send order message so that the replication dialogbox can be displayed correctly.
--  130418  MaRalk   Replaced view CUSTOMER_INFO_PUBLIC with CUSTOMER_INFO_CUSTCATEGORY_PUB in CUSTOMER_ORDER_JOIN, CUSTOMER_ORDER_JOIN_UIV, CO_CHARGE_JOIN view definitions.
--  130503  ErSrLK   Bug 109849, Added parameter all_attributes_ to Get_Customer_Defaults__() and Get_Order_Defaults___() to fetch all the default values
--  130503           depending on the parameter value. This was done to improve performance when called from distribution order creation flow.
--  130502  SudJlk   Bug 109735, Modified Unpack_Check_Update___ to allow delivery confirmation settings to be modified when CO status is Planned, Released, Reserved or Picked.
--  130423  ErFelk   Bug 109586, Added Internal_Co_Exists().
--  130409  IsSalk   Bug 108922, Modified Unpack_Check_Update___ to restrict modifying of Jinsui Invoicing for invoiced COs.
--  130329  IsSalk   Bug 108922, Modified method Validate_Jinsui_Constraints___() to enable Jinsui Invoicing for CO with CO lines and charges.
--  130328  KiSalk   Bug 108708, Removed Get_Line_Demand_Order_Ref1.
--  130222  ArAmLk   Modified Get_Next_Line_No() adding demand code CRE.
--  130211  SBalLK   Bug 107364, Modified Release_Credit_Blocked__() to create shipment when release blocked order.
--  130109  AyAmlk   Bug 103043, Modified Unpack_Check_Update___(), Unpack_Check_Insert___() and Validate_Proposed_Prepay___() to control if Delivery Confirmation for Advance/Prepayment
--  130109           Invoices with the new parameter, Allow With Delivery Confirmation.
--  130102  SeJalk   Bug 106868, Modified view CUSTOMER_ORDER_TAX_LINES to fetch correct tax information in Tax totals section in Pro Forma Invoice.
--  121213  SWiclk   Bug 107306, Modified CUSTOMER_ORDER_TAX_LINES view by removing outer joins since it makes unnecessary results. 
--  121122  MaIklk   Added Opportunity no as a reference column to Business Opportunity.
--  121022  ShKolk   Modified Get_Ord_Line_Totals__() to return totals considering use price incl tax value.
--  121009  SudJlk   Bug 105153, Made the necessary changes to add the new field customs_value_currency to indicate the currency used for customs purposes for a particular CO.
--  121004  AyAmlk   Bug 105605, Modified Validate_Customer_Agreement___() in order to prevent an oracle error comes due to an addition of 1 to the valid_until date when it is the last calendar date.
--  120918  GiSalk   Bug 103562, Removed the procedure, Check_Ipd_Sup_Site_Country___() . Added the procedure, Check_Ipd_Tax_Registration(). Modify Update___ by calling 
--  120918           Check_Ipd_Tax_Registration(), when ship_addr_no or addr_flag is changed, if addr_flag is not set. 
--  120821  MalLlk   Bug 102753, Modified the procedure Set_Line_Qty_Shipped in order to log the Delivered state when the internal CO is delivered for a same company.
--  120820  HimRlk   Modified Calculate_Order_Discount___ to pass new parameters to Order_Line_Staged_Billing_API.Recalculate.
--  120820  JeeJlk   Added new method Get_Tot_Sale_Price_Incl_Tax___ and modified Get_Ord_Gross_Amount.
--  120817  KiSalk   Bug 104680, Set the the LU names of the views CUSTOMER_ORDER_JOIN and CUSTOMER_ORDER_JOIN_UIV to CustomerOrderLine. 
--  120809  SudJlk   Bug 103412, Modified Unpack_Check_Insert___ to check if the order_no has leading or trailing spaces.
--  120807  JeeJlk   Modified view CUSTOMER_ORDER_JOIN_UIV by adding base_unit_price_incl_tax, unit_price_incl_tax and use_price_incl_tax_db.
--  120807           Modified Unpack_Check_Insert___ to assign a value to use_price_incl_tax when null.
--  120806  HimRlk   Modified New() to insert a default value to use_price_incl_tax.
--  120730  ShKolk   Modified Update___ to consider price incl tax values.
--  120730  JeeJlk   Added new implementation method Validate_Tax_Calc_Basis___.
--  120727  JeeJlk   Added a new column use_price_incl_tax.
--  120613  MalLlk   Bug 102563, Added function Check_Order_Exist_For_Customer and modified Unpack_Check_Insert___ in order check whether the customer is registered as an internal customer in the order header site.
--  120607  NWeelk   Bug 102649, Modified method Set_Earliest_Delivery_Date__ to filter Cancelled customer order lines when setting the earliest delivery date.
--  120425  IsSalk   Bug 101578, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by removing the warning message POEXISTS.
--  120423  Darklk   Modified the procedure Update___ to refresh the fee codes in the charge lines when the delivery address is changed in an exempt tax liability environment.
--  120323  IsSalk   Bug 101578, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by modifying the warning message POEXISTS.
--  120412  AyAmlk   Bug 100608, Increased the length to 5 of the column delivery_terms in views CUSTOMER_ORDER, CUSTOMER_ORDER_JOIN and deliv_term_ in Get_Delivery_Information().
--  120405  MeAblk   Bug 101348, Modified the function Get_Pegged_Orders() in order to check whether the customer order has any pegged objects. 
--  120404  NaLrlk   Modified the column length of DEMAND_ORDER_REF2 from 4 to 10 in view comments. 
--  120312  MaMalk   Bug 99430, Added inverted_conv_factor to the places where conv_factor is present.
--  120312  RoJalk   Removed the default NULL parameters from Calculate_Order_Discount___ since it is a implementation method.
--  120112  RoJalk   Merged Bug 100572, Added CO line references to Calculate_Order_Discount___ and Calculate_Order_Discount__ to be used in the Revenu Simulation.
--  120301  ChJalk   Modified the method Modify_Wanted_Delivery_Date__ to raise a message if the items are expired when the wanted delivery date changed.
--  120201  JuMalk   Bug 100886, Modified Customer's PO number check in Unpack_Check_Update___ and Unpack_Check_Insert___. Replaced Client_SYS.Add_Info with Client_SYS.Add_Warning.
--  120131  ChJalk   Modified the view comments and the Finite_State_Events___ method to reflect the model correctly.
--  120112  MAHPLK   Modified Get_Blocked_Reason_Desc and Set_Credit_Blocked methods to handle credit block reason. 
--  111216  Darklk   Bug 100352, Modified Unpack_Check_Update___ and Update___ by removing the variable conn_shipment_id_list_.
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111202  MaMalk   Added pragma to Get_Total_Base_Charge__.
--  111108  AwWelk   Bug 99616, Modified the procedure Unpack_Check_Update___ by removing the validation check existed for Delivery Confirmation together with Blocked for Invoicing lines.
--  111101  JeLise   Added rel_mtrl_planning to the VIEWJOINUIV.
--  111025  NWeelk   Bug 94992, Added rel_mtrl_planning to the VIEWJOIN.
--  111018  MaRalk   Modified method Update___ to adjust the parameters for the method call Customer_Order_Pricing_API.Modify_Default_Discount_Rec.
--  110910  SudJlk   Bug 98653, Modified Release_Credit_Blocked, Get_Line_Demand_Order_Ref1, CUSTOMER_ORDER_JOIN and CUSTOMER_ORDER_JOIN_UIV to reflect the length change of demand_order_ref1 in customer_order_line_tab.
--  111003  ChJalk   Added function Get_Promotion_Charges_Count.
--  110914  HimRlk   Bug 98108, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ by changing the Exist check of document address to Customer_Info_Address_API. 
--  110914           Modified the reference of bill_addr_no and customer_no_pay_addr_no to CustomerInfoAddress in base view.
--  110914  RoJalk   Added the method call Validate_Proj_Connect___  to Unpack_Check_Update___ which was removed during a merge.
--  110912  MaMalk   Modified the text given be message constant SUPCOUNTRYDIFF.
--  110823  IsSalk   Bug 97628, Added function All_Lines_Cancelled.
--  110819  AndDse   EASTTWO-6678, Modified Get_Order_Defaults___ to make sure we start on a workday for the external supplier before adding the leadtime.
--  110811  ChJalk   Modified the method Get_Order_Defaults___ to retrieve company sites country if the value is NULL.
--  110720  Cpeilk   Bug 96494, Removed text_id column from view CO_PROJECT_LOV to eliminate incorrect results displayed.
--  110728  ChJalk   Modified the method Get_Order_Defaults___ to remove unnecessary method calls when fetching the document address of paying customer.
--  110722  NaLrlk   Removed the method Update_Line_Freight_Info since it is no longer used.
--  110715  ChJalk   Added user_allowed_site filter to the base view.
--  110712  MaMalk   Added the user allwed site filter on Customer_Order_Lov.
--  110712  ChJalk   Removed the view CUSTOMER_ORDER_UIV.
--  110711  ChJalk   Modified usage of view CUSTOMER_ORDER to CUSTOMER_ORDER_TAB in cursors.
--  110705  ChJalk   Added User_Allowed_Site filter to the views LOVVIEWCC and SITEVIEW.
--  110701  KiSalk   Bug 96918, In Get_Total_Sale_Charge__ and Get_Tot_Charge_Sale_Tax_Amt added rowstate != 'Cancelled' check.
--  110609  ShKolk   Added error message CANNOTUPDFIXDELFRE to Unpack_Check_Insert___ and Unpack_Check_Update___.
--  110527  MaMalk   Added method Check_Ipd_Sup_Site_Country___ and call it in Update___ to check whether we have IPD lines with different supply site country than specified on the order header.
--  110524  ShVese   Changed the comparision for project code part value in Update___ to prevent pre-posting from being added wrongly.
--  110524  Darklk   Bug 96898, Modified the procedure Get_Order_Defaults___ to retrieve the customer_no_pay value from the attr_ string.
--  110514  AmPalk   Bug 95151, Removed net_amount_ from Recalculate_Tax_Lines..
--  110513  SudJlk   Bug 96703, Modified view CUSTOMER_ORDER_TAX_LINES to fetch tax information when multiple tax lines exist.
--  110506  SudJlk   Bug 96703, Modified view CUSTOMER_ORDER_TAX_LINES to fetch tax information in the case of tax liability exempt as well.
--  110506  JaBalk   Bug 95920, Added new procedure Modify_Line_Purchase_Part_No() to update the purchase part no in COL when inventory part is connected to purchase part.
--  110514  MaMalk   Modified Validate_Proj_Disconnect___ to add missing ifs_assert_safe statements.
--  110512  MaMalk   Modified Unpack_Check_Update___ to include GRP_DISC_CALC_FLAG when raising the message BILLED_ORDER.
--  110512  Darklk   Bug 95409, Modified function Unpack_Check_Update___ to make the data fields 'Pay Term Base Date' and 'Pay Term' as editable.
--  110429  HimRlk   Bug 96751, Modified CUSTOMER_ORDER_JOIN view by changing self_billing to update allowed.
--  110426  AmPalk   Bug 94785, Made language_code editable on Invoiced/closed orders.
--  110422  MaMalk   Modified Update___ and Unpack_Check_Update___ to trigger some validations related to supply country. 
--  110406  MaMalk   Modified Unpack_Check_Update___ to do the ISO_COUNTRY exist check out of the loop.
--  110404  MatKse   BP-4016, Added methods Calculate_Order_Discount__, Calculate_Order_Discount___ and Modify_Grp_Disc_Calc_Flag to handle calculation of group discount on order
--  110330  AndDse   BP-4760, Modified Unpack_Check_Update___, Get_Order_Defaults___ and Calculate_Planned_Deliv_Date due to changes in Cust_Ord_Date_Calculation.
--  110329  AndDse   BP-4754, Removed a block of code in Modify_Address, because we could not find it being used, and decided that ship via etc should not be changed when unchecking single occurence flag.
--  110323  MiKulk   Modified the vat_no fetching logic to consider document address id instead of ship addr no.
--  110321  AndDse   BP-4453, Modified leadtime calculation in Calculate_Planned_Deliv_Date.
--  110321  MiKulk   Added the method Modify_Line_Vat_No_Details___ and modified the logic to change the vat no related details with the change of the document address id.
--  110317  MaMalk   Modified the code to remove the information messages raised from the Customer Order when pay tax is uncecked
--  110317           since it will be raised from the Customer Order Address for single occurence addresses.
--  110316  AndDse   BP-4453, Modified leadtime calculation in Get_Order_Defaults___.
--  110309  Kagalk   RAVEN-1074, Added tax_id_validated_date field
--  110303  MaMalk   Modified Unpack_Check_Update___ to raise an error message when the supply country is changed in a CO which has lines with shipment connected.
--  110223  MiKulk   Modified the method Update___ to trigger the CO line changes whe the supply country is updated..
--  110302  MalLlk   Added new view CUSTOMER_ORDER_UIV with user allowed site filter to be used in the client.
--  110131  Nekolk   EANE-3744  added where clause to View CO_CHARGE_JOIN,CUSTOMER_ORDER,CUSTOMER_ORDER_JOIN
--  110222  MaMalk   Modified methods New and Get_Order_Defaults___ to correctly set the supply_country and tax_liability when the CO is created Automatically.   
--  110221  MaMalk   Modified method Update___ to retrieve taxes correctly when the tax liability is changed.
--  110216  AndDse   BP-3836, Fixed so customer calendar is changed on CO lines with default info when it is changed on CO header.
--  110214  AndDse   BP-4146, Modifications for info message handeling on calendar functionality.
--  110208  AndDse   BP-3776, Modifications for external transport calendar implementation.
--  110208  UTSWLK   Modified function Calendar_Changed to fetch the previous working day if delivery date is a non working day after re-generate a calendar.
--  110125  AndDse   BP-3776, Added EXT_TRANSPORT_CALENDAR_ID to LU.
--  110120  Maeelk   Added parameter demand_code_db_ to Get_Next_Line_No. Modified Get_Next_Line_No
--  110120           to fetch correct line no and release no depending on the supply code and the demand code.
--  110120  MaMalk   Added Tax_Class_Id CO_CHARGE_JOIN view.
--  110105  MaMalk   Added Tax Liability and Delivery Country Code as attributes.
--  101223  MaMalk   Added Tax_Class_Id to view Customer_Order_Join.
--  101222  MiKulk   Updated the logics for fetching the tax regime, tax liability, tax free tax code and the tax Identity.
--  101209  Mamalk   Added Supply_Country as an attribute.
--  101223  UtSwlk   Modified code to consider transport calendar when calculating wanted_delivery_date_ in Get_Order_Defaults___.  
--  101217  AndDse   BP-3552, Modified Unpack_Check_Insert__, Unpack_Check_Update__ and Modify_Address so that a warning is shown if wanted delivery date is a non working day. Also added Check_Date_On_Calendar_.
--  101216  UtSwlk   Added cust_calendar_id to CUSTOMER_ORDER_JOIN view.
--  101215  AndDse   BP-3553, Modifed wanted delivery date calculations in Unpack_Check_Insert__, Unpack_Check_Update__, Get_Order_Defaults___ and Modify_Address. Also added Apply_Cust_Calendar_To_Date___.
--  101012  JuMalk   Bug 93363, Modified Update method to check whether the value of ship_addr_no has been changed, and add a new customer order history record.
--  101005  SudJlk   Bug 93374, Modified view CUSTOMER_ORDER_TAX_LINES to correct invalid column FLAGS in the view columns.
--  100922  SaJjlk   Bug 93142, Modified method Unpack_Check_Update___ to check value of changed_country_code_ before executing tax number validation.
--  100806  AmPalk   Bug 91492, Added Copy_Prepostings_To_Lines.
--  101213  AndDse   BP-3550, Added column CUST_CALENDAR_ID to LU.
--  101130  NaLrlk   Removed bonus code in the method Get_Ord_Line_Totals__.
--  100820  MaHplk   Added new parameter price_effec_date_changed_ to Modify_Wanted_Delivery_Date__.
--  100818  Chfolk   Modified Update___ to fetch header zone_id to CO line when order_default is checked.
--  100818  ChFolk   Removed Update_Single_Occar_Addr_Recs as freight information is stored in CO line no need to fetch them during consolidation.
--  100729  ChFolk   Modified Modify_Address to fetch frieght information when address flag is modified.
--  100728  ChFolk   Modified parameters of Modify_Address to get freight zone information.
--  100723  ChFolk   Added new methods Fetch_Delivery_Attributes and Fetch_Default_Delivery_Info. Modified methods Get_Order_Defaults___,
--  100723           Get_Delivery_Information to fetch freight zone infomation even if that is not defined in chain matrix.
--  100713  ChFolk   Removed columns calc_disc_bonus_flag, calc_disc_bonus_flag_db from view CUSTOMER_ORDER and bonus_basis, bonus_value from view
--  100713           CUSTOMER_ORDER_JOIN. Removed methods Calculate_Line_Bonus_Disc___, Calculate_Discount_Bonus__,
--  100713            Modify_Calc_Disc_Bonus_Flag and Get_Total_Bonus_Value as bonus functionality is obsoleted.
--  100429  NuVelk   Merged Twin Peaks.
--  100830  MoNilk   Added code to generate state package related code automatically from the entity model.
--  100726  Swralk   SAP-SUCKER DF-40, Modified function Get_Total_Add_Discount_Amount to use correct currency rounding.
--  100708  KiSalk   Modified Update___ by passing parameter condition_code_ to Customer_Order_Pricing_API.Get_Order_Line_Price_Info call.
--  100603  LaRelk   Changed the reference in view from ApplicationCountry to IsoCountry and Modified methods Unpack_Check_Insert___,Unpack_Check_update___. 
--  100729  SaJjlk   Bug 92215, Modified method Finite_State_Init___ to execute the ORDER_STATE_CHANGE event when a Customer Order is created.
--  100727  NWeelk   Bug 92113, Modified methods Finite_State_Machine___ and Order_Is_Fully_Invoiced___ to handle 
--  100727           cancelling of CO when the charge line in set to COLLECT.
--  100707  Cpeilk   Bug 91029, Modified Unpack_Check_Update___ by adding ROUTE_ID, VAT_DB to the attribute list.
--  100525  Maanlk   Bug 90829, Change Get_Revision_Status___ from a procedure to a function. Modified procedures Check_Config_Revisions and Modify_Wanted_Delivery_Date__.
--  100517  ShVese   Modified Finite_State_Machine to match the developer studio state machine model.
--  100514  Ajpelk   Merge rose merthod documentation.
--  100510  Cpeilk   Bug 88567, Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to raise an error message when the invoicing customer is internal belonging to
--  100510           the same company as the site where the CO is processed and ordering customer is external or internal, belonging to a different company.
--  100507  Rakalk   Bug 90314, Added function Is_Customer_Credit_Blocked to check if the customers of the specified order is credit blocked.
--          RaKalk   Bug 90314, Modified Release_Credit_Blocked function to check the credit blocked flag of ordering customer.
--          RaKalk   Bug 90314, Modified Insert___ procedure to give order will be credit blocked message when the ordering customer is credit blocked.
--  100429  NuVelk   Merged Twin Peaks.
--  100427  MaGuse   Bug 90022, Modified method Unpack_Check_Update___. Removed call to method Customer_Order_Address_API.Get_Country_Code and
--  100427           added call to Customer_Order_Address_API.Get_Address_Country_Code. Added check for changed_country_code_ for handling tax validation on 
--  100427           update of country code on single occ address. Modified method Modify_Address, added new IN parameter changed_country_code_.
--  100426  ShVese   Modified Finite_State_Machine to match the developer studio state machine model.
--  100422  MaAnlk   Bug 79609, Added Check_Config_Revisions and Get_Revision_Status___. Modified Modify_Wanted_Delivery_Date__ to raise error and information message when date change
--  100422           affects valid base part revision used for the configuration.
--  100420  MaGuse   Bug 89278, Modified method Update___ by removing addr_flag check from IF conditions to enable updating tax lines correctly when the delivery address is changed. 
--  100420           Removed sending addr_flag to the method call Customer_Order_Charge_API.Add_All_Tax_Lines in method Update___. 
--  100402  SuThlk   Bug 89693, Handled the value overflow scenario of the next line no value in Get_Next_Line_No.
--  100401  KiSalk   Corrected REF parameters to CUSTOMER_AGREEMENT of the base view.
--  100322  AmPalk   Bug 87931, Added currency rate to the co_charge_join.
--  100303  MaRalk   Modified method Get_Order_Defaults___ to fecth the bill_addr_no_ correctly.
--  100222  ErFelk   Bug 88812, Added implementation methods Get_Ord_Total_Tax_Amount___ and Get_Total_Sale_Price___. Moved relevant code to these implementation methods.  
--  100218  ErFelk   Bug 88812, Added function Get_Tot_Sale_Price_Excl_Item__ to calculate total sales price excluding Charged Item and Exchange Item cost.
--  100217  SaJjlk   Bug 88629, Removed corrections done by bug 77333 in method Get_Order_Defaults___. 
--  100217  JuMalk   Bug 87879, Modified the way of calculating add_discount_amt_ in Get_Ord_Line_Totals__ and Get_Total_Add_Discount_Amount by getting the required values separately through the  
--  100217           cursor and calculate add_discount_amt_. 
--  100118  JuMalk   Bug 86936, Added Get_Ord_Line_Totals__. This method comprises many logic that require co_line_tab access, 
--  100118           and that exists in side other methods in this LU. A performance gain expected on CO form, from accessing its child table, minimum number of times on itself.
--  100118           Introduced company to the base view. Site_API.Get_Cpmpany call can get elimanated from client form.
--  100112  MaRalk   Modified the state machine according to the new developer studio template - 2.5.
--  091203  KiSalk   Changed backorder option values to new IID values in Customer_Backorder_Option_API, and cloumn length for backorder_option_db in view comments set to 40.
--  091104  MaRalk   Modified CUSTOMER_ORDER - company column view comments. 
--  090930  MaMalk   Removed unused procedure Modify_Zero_Ivc_Qty_Chrgs___, constants state_separator_ and inst_DistributionOrder_. Modified Update___, Get_Order_Defaults___, Get_Total_Sale_Price__,
--  090930           Modify_Address, Release_From_Credit_Check and Finite_State_Init___ to remove unused code.
--  090915  Ersruk   Changes made for deleting the project ID on the references tab to be deleted the pre postings for project if both same. 
--  090915  Ersruk   Modified error msg LINECONNECTION and condition in Validate_Proj_Connect___(). 
--  090910  Ersruk   Currency Rate Type fetched from project in Modify_Project_Id().
--  090804  Ersruk   Renamed text Project Unique Sale to Project Unique Billing in error message.
--  090513  Ersruk   PA recommended changes, Modify_Project_Id to public method.
--  090512  Ersruk   Set project pre posting in Update___. 
--  090429  Ersruk   Added new method Modify_Project_Id__() and Validate_Proj_Disconnect___.
--  090212  RoJalk   Removed the method Check_Released_Activity___ and called Check_Released_Activity__ from CO line in Set_Released__.  
--  090206  RoJalk   Modified the error message in Check_Released_Activity___.
--  090127  RoJalk   Called Check_Released_Activity___ from Set_Released__.
--  090127  RoJalk   Added method Check_Released_Activity___.
--  100713  Swralk   SAP-SUCKER DF-40, Added function Get_Order_Currency_Rounding.
--  ------------------------------ 14.0.0 --------------------------------------------
--  100426  JeLise   Renamed zone_definition_id to freight_map_id.
--  100419  ShKolk   Removed summarized_packsize_chg.
--  100312  ShKolk   Added Update_Freight_Free_On_Lines().
--  100104  SaJjlk   Bug 88089, Modified method calls to Dop_Demand_Cust_Ord_API.Get_No_Of_All_Dop_Headers to be dynamic.
--  091214  DaGulk   Bug 87541, Added two new attributes MSG_SEQUENCE_NO and MSG_VERSION_NO to the list in Unpack_Check_Update___.
--  091208  Castse   Bug 86107, Added function Get_Pegged_Orders. Modified methods Unpack_Check_Update___ and Modify_Wanted_Delivery_Date__ to handle replicate_changes 
--  091208           when changes the wanted delivery date of order header.
--  091120  ChJalk   Bug 86871, Removed General_SYS.Init_Method from the procedure Get_Shipment_Charge_Amount.
--  091118  DaGulk   Bug 86201, Added new error message in Unpack_Check_Update___ to stop updating the Sales Contract No when CO is not in Planned state.
--  091118  NWeelk   Bug 86939, Modified view CUSTOMER_ORDER_TAX_LINES by using CO line rowstate to filter the Cancelled CO lines.
--  091103  NaLrlk   Bug 86768, Merge IPR to APP75 Core.
--  091022  NWeelk   Bug 86263, Modified method Update___ to consider the header agreement id when checking the change of line and header price sources. 
--  091015  NWeelk   Bug 86263, Modified method Update___ to add correct values for DELIVERY_TERMS and DEL_TERMS_LOCATION when the line level price_source_id not changed.
--  090922  AmPalk   Bug 70316, Modified Get_Total_Base_Charge__ to get the value from Customer_Order_Charge_API.Get_Total_Base_Charged_Amount.
--  090922           Modified Get_Total_Sale_Price__ and Get_Total_Base_Price by calling order line's get total methods, hence the calculation will be in a cenralized place.
--  090922           Modified Get_Tot_Charge_Base_Tax_Amount to round the value returned.
--  090901  ChJalk   Bug 82611, Added column customs_value to the view CUSTOMER_ORDER_JOIN.
--  091026  MaRalk   Added dummy column company to the view CUSTOMER_ORDER and rollback the modifcation done to the view comments pay_term_id. 
--  090819  SudJlk   Bug 83218, Modified method Update___ to restrict price modification in the CO line if the supply code is SEO.
--  090717  MaMalk   Bug 82292, Added attribute print_delivered_lines and modified all the necessary methods and views to reflect the changes.
--  091120  DaZase   Changed the viewjoin so price_source_net_price_db/price_source_net_price is showing the correct db/client values.
--  091012  NaLrlk   Modified the method Update___ to handle del_terms correctly.
--  091008  DaZase   Added sales_chg_type_category to CO_CHARGE_JOIN. 
--  090708  IrRalk   Bug 82835, Modified Get_Adj_Volume_In_Charges,Get_Total_Weight__,Get_Total_Gross_Weight__ and Get_Adj_Weight_In_Charges
--  090708           to round weight and volume to 4 and 6 decimals respectively.
--  090731  ShKolk   Modified view comment for Fixed Delivery Freight to Fixed Delivery Freight Amt.
--  090527  SuJalk   Bug 83173, Modified the error constant to be unique in method Modify_Address. Modified the error messages NOTDELADDR and NOTDOCADDR to have a fullstop at the end.
--  090521  DaGulk   Bug 82238, Added new parameter order_no_ to method Get_Customer_Po_No. Added new IF condition for the information message to check whether the customer Po No exist before it is raised.
--  090519  MaMalk   Bug 82684, Added method Non_Ivc_Cancelled_Lines_Exist and modified method Modify_Wanted_Delivery_Date__  to prevent updating Cancelled CO Lines.
--  090512  NWeelk   Bug 81195, Added new function Exist_Connected_Charges.
--  090507  SaJjlk   Bug 82381, Modified the IF condition in method Unpack_Check_Update, which triggers the method call to Block_Backorder_For_Eso___.
--  090507           Modified the text of the error message in method Block_Backorder_For_Eso___.
--  090421  ChJalk   Bug 79793, Modified Release_Credit_Blocked to avoid raising an error when releasing a Customer Order with only charge lines.
--  090415  DaGulk   Bug 80890, Modified Unpack_Check_Update___ by adding an information message to check 'Customer Po No' exist in the order header.
--  090410  SaWjlk   Bug 81492, Added NOCHECK for activity_seq in CUSTOMER_ORDER_JOIN view.
--  090406  HimRlk   Bug 80277, Added new public field internal_po_label_note and method Get_Internal_Po_Label_Note.
--  090406  SuJalk   Bug 81691, Added PICK_LIST_FLAG_DB, PICK_LIST_FLAG_DB, ORDER_CONF_FLAG, ORDER_CONF_FLAG_DB, SUMMARIZED_SOURCE_LINES, PACK_LIST_FLAG, PACK_LIST_FLAG_DB and PRINT_CONTROL_CODE in Unpack_Check_Update___.
--  090402  SudJlk   Bug 81742, Modified Get_Order_Defaults___ to fetch correct delivery terms when the CO is created through WO.
--  090316  SudJlk   Bug 80264, Modified Update___, Get_Order_Defaults___ and Get_Delivery_Information to modify value setting for del_terms_location when a customer agreement exists.
--  090225  SaRilk   Bug 80655, Modified Get_Order_Defaults___ by adding a condition to check the value of backorder_option_ and by setting the 
--  090225           item value of BACKORDER_OPTION using the value of backorder_option_.
--  090219  NWeelk   Bug 80212, Made Customer_No_Pay_Addr_No Public and added Function Get_Customer_No_Pay_Addr_No.
--  090210  SaRilk   Bug 80293, Modified Unpack_Check_Update___ by adding PRIORITY to the attribute list.
--  090203  MaMalk   Bug 74793, Removed method Get_Note_Text.
--  090129  SaJjlk   Bug 79846, Removed the length declaration for NUMBER type variable old_note_id_ in method Insert___. 
--  081230  ChJalk   Bug 70877, Added column load_id to the CUSTOMER_ORDER_JOIN view
--  081215  ChJalk   Bug 77014, In Get_Total_Base_Price, used sale_unit_price and currency_rate instead of base_sale_unit_price.
--  081215           Added General_SYS.Init_Method to Get_Charge_Gross_Amount, Get_Total_Base_Charge__ and Get_Tot_Charge_Base_Tax_Amount.
--  081126  SudJlk   Bug 78691, Modified the type of the variable paying_customer_ in method Update___.
--  081031  ChJalk   Bug 76959, Added DEFAULT 'TRUE' parameter add_hist_log_ to the method Set_Line_Qty_Assigned and 
--  081031           modified the method Do_Set_Line_Qty_Assigned___ to pass the value in call LINEPKG..Set_Qty_Assigned.
--  081031  SaRilk   Bug 78151, Modified Unpack_Check_Update___ by adding AUTHORIZE_CODE to the attribute list.
--  081029  SuJalk   Bug 76539, Added Get_Internal_Ref method. Also added internal_ref to the get method.
--  081016  ThAylk   Bug 76285, Modified the view CUSTOMER_ORDER_TAX_LINES to fetch the round_tax_amount in order currency for CO lines and Charges.
--  080930  ThAylk   Bug 77333, Modified methods Unpack_Check_Update___, Update___ and Get_Order_Defaults___ to prompt the info
--  080930           correctly when Document Address is not specified in CO header.
--  080925  HoInlk   Bug 67780, Added column internal_ref.
--  080905  MaMalk   Bug 75921, Modified method Find_Open_Scheduling_Order to add parameter ship_addr_no_ and change the logic according to the ship_addr_no_.
--  080701  MaMalk   Bug 74255, Modified view CUSTOMER_ORDER_TAX_LINES to add total_unit_price, to rename the net_curr_amount into tax_base_amount and
--  080701           to modify the calculation for net_curr_amount in customer order charges.
--  080623  NaLrlk   Bug 74960, Added check for del_terms_location is null in methods Get_Order_Defaults___.
--  090630  RiLase   Added campaign id and deal id to the view CO_CHARGE_JOIN.
--  090430  KiSalk   Added charge, charge_cost and charge_cost_percent to view CO_CHARGE_JOIN.
--  090403  MaHplk   Modified column name apply_full_truck_price and full_truck_price  to apply_fix_deliv_freight and fix_deliv_freight.
--  090330  KiSalk   Modified Get_Total_Base_Charge__, Get_Total_Sale_Charge__ and Get_Tot_Charge_Sale_Tax_Amt to calculate values using charge percentage.
--  090326  MaHplk   Modified Unpack_Check_Insert___ and Unpack_Check_Update___. 
--  090324  DaZase   Added part_level, part_level_id, customer_level and customer_level_id to VIEWJOIN and in 2 calls in Update___.
--  060317  MaHplk   Added column apply_full_truck_price and full_truck_price.
--  090305  ShKolk   Changed method call Fetch_Zone_For_Single_Occ_Addr to Fetch_Zone_For_Addr_Details.
--  090220  MaHplk   Modified Get_Order_Defaults___.
--  090122  DaZase   Resizing price_source_db in view comment.
--  090113  ShKolk   Modified Get_Order_Defaults___() to fetch value for freight_price_list_no.
--  090107  ShKolk   Added column freight_price_list_no.
--  081229  NaLrlk   Modified the method Update_Single_Occar_Addr_Recs to initialize the variable values.
--  090327  ChJalk   Bug 81153, Modified the method Update_Single_Occar_Addr_Recs to remove raising exceptions for non-numeric zip codes.
--  090119  NaLrlk   Bug 79526, Modified the method Update_Single_Occar_Addr_Recs to initialize the variable values.
--  081210  MaJalk   Added attribute summarized_packsize_chg.
--  081110  MaJalk   Added adjusted_weight_net, adjusted_weight_gross, adjusted_volume to view CUSTOMER_ORDER_JOIN.
--  081017  MaJalk   Added line_total_weight_gross to view CUSTOMER_ORDER_JOIN.
--  081003  MaHplk   Added attribute summarized_freight_charges to LU.
--  081002  MaJalk   Set zone details to NULL at Unpack_Check_Update___ when addr_flag is changed.
--  080919  MaJalk   Added reference for zone_definition_id at VIEW comments.
--  080919  KiSalk   Added Method Set_Earliest_Delivery_Date__
--  080917  AmPalk   Added Update_Single_Occar_Addr_Recs and Get_Freight_Charges_Count__.
--  080911  MaJalk   At methods Update___, Get_Order_Defaults___, Modify_Address and Get_Delivery_Information,
--  080911           added parameters zone_definition_id and zone_id to method calls.
--  080908  MaJalk   Added attributes zone_definition_id and zone_id.
--  080819  AmPalk   Added Get_Total_Gross_Weight__.
--  080701  KiSalk   Merged APP75 SP2.
--  ----------------------------- APP75 SP2 Merge - End -----------------------------
--  080526  ChJalk   Bug 72771, Modified method Update__ to handle tax lines of charge lines when changing the single occurrence check box.
--  080508  ChJalk   Bug 72727, Added method Created_From_Int_Po__, to check if the CO has any lines with demand code IPT or IPD.
--  080415  NaLrlk   Bug 72639, Modified the method Get_Order_Defaults___ to pick the correct invoice customer's default document address.
--  080415           Modified the methods Unpack_Check_Insert___ and Unpack_Check_Update___ to check whether the invoicing customer Addr Id type is document.
--  080410  ChJalk   Bug 72417, Modified Get_Order_Defaults___ to make confirm_deliveries FALSE if the companies are same for an Internal Customer.
--  080410           Also removed the Error Message INTERORDER_DC.
--  080403  Asawlk   Bug 72598, Modified Set_Line_Qty_Picked to check new_state_ = 'Released' before creating a history record.
--  080328  Asawlk   Bug 72598, Modified method Set_Line_Qty_Picked to create a history record when a state transition occurs.
--  080326  Castse   Bug 72213, Modified method Do_Release_Credit_Blocked___ to increase length of variable info_.
--  080324  MaRalk   Bug 70575, Added new view CUSTOMER_ORDER_TAX_LINES in order to use in the Proforma Invoice reports.
--  080307  NaLrlk   Bug 69626, Increased the column length of cust_ref to 30 in view CUSTOMER_ORDER.
--  ----------------------------- APP75 SP2 Merge - Start -----------------------------
--  080605  JeLise   Added rebate_customer.
--  080428  MaJalk   Added rebate_builder to call Customer_Order_Pricing_API.Get_Order_Line_Price_Info at method Update___.
--  080424  MaJalk   Added rebate_builder to VIEWJOIN.
--  080310  KiSalk   Added attribute classification_standard and method Get_Classification_Standard.
--  080312  MaJalk   Merged APP 75 SP1.
--  ------------------------------ APP 75 SP1 merge - End ----------------------------
--  080207  NaLrlk   Bug 70005, Modified del_terms_location value in method Update___ and Get_Delivery_Information.
--  080205  NaLrlk   Bug 70005, Added del_terms_location to Get_Delivery_Information, modified minor changes for del_terms_location in Modify_Address,
--  080205           Get_Order_Defaults___, Update___ and Unpack_Check_Update___.
--  080205  SaJjlk   Bug 69853, Added code to perform validations for company tax id in methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  080201  LaBolk   Bug 70646, Modified Get_Order_Defaults___ to allow using confirm deliveries option when sourced from DO and sites belong to different companies.
--  080201           Removed constant inst_CreateCompanyTem_ added by bug 69814, as it is no longer used.
--  080201  ChJalk   Bug 70889, Removed Function Validate_Email__.
--  080130  NaLrlk   Bug 70005, Added public attribute del_terms_location and Modified methods Get_Order_Defaults___,
--  080104  MaMalk   Bug 70075, Modified Update___ to compare the new and old values of cust_ref before calling Modify_Order_Defaults__.
--  071224  MaJalk   Bug 69814, Set method Validate_Email as private and modified.
--  071224  MaRalk   Bug 64486, Added attribute currency_rate_type and modified all corresponding methods to handle it.
--  071218  ThAylk   Bug 68685, Modified the line_no_ parameter to IN OUT in procedure Get_Next_Line_No and change the parameter order.
--  071213  MaJalk   Bug 69814, Added method Validate_Email to fetch the email address based on CO communication method.
--  071213  MaMalk   Bug 69811, Modified Validate_Proj_Connect___ and Validate_Proposed_Prepay___ to remove the validations
--  071213           existed to avoid the combination of project and prepayment.
--  071211  LaBolk   Bug 67937, Added method Generate_Co_Number. Moved code that creates CO number from Insert___ to the new method.
--  071210  MaRalk   Bug 66201, Modified functions Get_Total_Weight__ and Get_Total_Qty__ to return NULL as well.
--  071203  PrPrlk   Bug 68771, Added new method Set_Sequence_And_Version that sets the sequence and version when an order confirmation is transferred.
--  071203           Updated the relevent methods to handle the new columns  sequence_no and version_no.
--  071119  MaRalk   Bug 67755, Added column target_date to CUSTOMER_ORDER_JOIN view.
--  071101  FreMse   Bug 68023, Added AND line_item_no IN (-1, 0) to WHERE condition to include only top node items, not items in packages
--  071022  ThAylk   Bug 67984, Added Valid_Project_Customer__ and modified Validate_Proj_Connect___ by removing error and proj_customer_id fetching.
--  071019  LaBolk   Bug 67058, Added method Self_Billing_Lines_Exist__ to check if at least one SB line exists for the given CO.
--  071018  NaLrlk   Bug 67653, Added column dop_new_qty_demand and view comments in CUSTOMER_ORDER_JOIN.
--  ------------------------------ APP 75 SP1 merge - Start --------------------------
--  080228  MaJalk   Changed validation method for contract_ at Validate_Customer_Agreement___.
--  080214  AmPalk   In Update___ modified method call to Get_Order_Line_Price_Info receiving net_price_fetched value and inserted it to the CO Line.
--  080116  JeLise   Commented the calculation of order bonus basis and bonus value in Calculate_Line_Bonus_Disc___.
--  080116           Commented call to Get_Total_Bonus_Value in Get_Total_Contribution.
--  071129  JeLise   Added priority to Get_Order_Defaults___.
--  **************************** Nice Price ***************************
--  070925  MoNilk   Added text_id$ and view comments to LU connected views.
--  070810  HaPulk   Added column text_id$ to view CUSTOMER_ORDER.
--  070808  RaKalk   Bug 63323, Made note_text public
--  070717  MaJalk   Bug 65855, Added COMPANY OWNED for parameters old_part_ownership_db_ and part_ownership_db_
--  070717           to Calc_Order_Dates_Backwards within Calculate_Planned_Due_Date.
--  070703  SuSalk   LCS Merge Bug 65779, Modified Update___ to perform credit check on invoicing customer.
--  070621  MiKulk   Bug 61765, Added parameter to Calc_Order_Dates_Backwards within Calculate_Planned_Due_Date.
--  070619  ChBalk   Bug 64640, Removed General_SYS.Init_Method from function Get_Gross_Amt_Incl_Charges.
--  070607  MiKulk   Modified the methods Release_Credit_Blocked and Insert__ to check the Customer_no_pay also for the credit check.
--  070530  ChBalk   Bug 64640, Removed General_SYS.Init_Method from function Get_Tot_Charge_Sale_Tax_Amt.
--  070515  NaLrlk   Added USE_PRE_SHIP_DEL_NODE_DB and PICK_INVENTORY_TYPE_DB to attr in Insert___ method.
--  070512  NiDalk   Modified Validate_Customer_Agreement___ to romove check for Agreement_type.
--  070511  ChBalk   Bug 63020, Modified Insert___ to raise the info message NOTTAXFREETAX irrespective of addr_flag check.
--  070509  Cpeilk   Modified method Set_Credit_Blocked to display message with credit check info.
--  070509  NiDalk   Bug 64080, Changed method Update___ to raise an error if the shipment creation method is changed for a non inventory part.
--  070508  NaLrlk   Bug 64797, Modified Finite_State_Machine___ method to enable 'SetLineQtyAssigned' event when state is in 'CreditBlocked'.
--  070417  NiDalk   Added General_SYS.Init_Method to Get_Gross_Amt_Incl_Charges
--  070327  IsAnlk   Modifed Do_Set_Line_Qty_Assigned___ to update qty_assigned for the package parts.
--  070322  MalLlk   Bug 60882, Added public attribute vat_no and modified all corresponding methods to handle it.
--  070315  ViWilk   Bug 59395, Modified the Function Get_Tot_Charge_Base_Tax_Amount to handle Null values.
--  070305  AmPalk   Modified CUSTOMER_ORDER_JOIN by adding Use_Pre_Ship_Del_Note_Db.
--  070228  Cpeilk   Modified the error message for approved prepayments in Validate_Proposed_Prepay___.
--  070227  WaJalk   Bug 61985, Modified views CUSTOMER_ORDER and CUSTOMER_ORDER_JOIN to increase length of column customer_po_no from 15 to 50, in view comments.
--  070220  NaLrlk   Added the column USE_PRE_SHIP_DEL_NOTE and PICK_INVENTORY_TYPE to CUSTOMER_ORDER views, added public methods
--  070220           Get_Use_Pre_Ship_Del_Note_Db,Get_Pick_Inventory_Type_Db, Get_Use_Pre_Ship_Del_Note, Get_Pick_Inventory_Type.
--  070220           Modified the method call Uses_Shipment_Inventory, Modified Prepare_Insert___, Get_Order_Defaults___ for new columns.
--  070215  NaWilk   Renamed public method Handle_Pre_Acc_Change as Handle_Pre_Posting_Change.
--  070214  SaJjlk   Added SHIPMENT_CREATION and SHIPMENT_CREATION_DB to conditions list in Unpack_Check_Update___ to raise errors when invoiced.
--  070212  NaWilk   Added public method Handle_Pre_Acc_Change.
--  070125  SaJjlk   Added public attribute SHIPMENT_CREATION and modified methods Unpack_Check_Update___, Update___
--  070125           Get_Order_Defaults___ to correctly set the value for SHIPMENT_CREATION.
--  070125           Increased length of column SHIPMENT_CREATION in view CUSTOMER_ORDER_JOIN.
--  070119  SuSalk   Removed Get_Delivery_Terms_Desc, Get_Ship_Via_Desc methods & DELIVERY_TERMS_DESC , SHIP_VIA_DESC from view and view column comments.
--  070117  NaWilk   Used Order_Delivery_Term_API to fetch the Delivery terms desc.
--  070117  NuVelk   Bug 62685, Added ADV_PAY_BLOCK and ADV_PAY_BLOCK_DB to IF condition in Unpack_Check_Update___.
--  061221  NaLrlk   Removed the function Check_Promised_Delivery_Date__.
--  061219  Cpeilk   Call 140121, Modified method Validate_Proposed_Prepay___ to check whether the CO line is connected to project.
--  061206  RoJalk   Modified the error message PREPAYM_ZERO.
--  061206  ThAylk   LCS Merge 61834, Modified the Order_Is_Fully_Invoiced___ method to implement the correct logic when invoicing COs.
--  061206           Also changed the name of cursor get_invoiced to get_uninvoiced and added two cursors invoice_line_exist and charge_line_exist.
--  061206  ThAylk   LCS Merge 61834, Added Blocked_Reason to the initial IF condition in Unpack_Check_Update___ to allow the release of credit blocked
--  061206           COs when using Staged Billing. Also Removed the cursor get_invoiced_staged_billings from Order_Is_Fully_Invoiced___ method.
--  061206  MiKulk   Modified the view comments for the Proposed_Prepayment_Amount as "Required Prepayment Amount" in the views Customer_Order, and Customer_Order_Join
--  061205  RoJalk   Modifications to the message text of BLKFORPREPAY.
--  061129  RoJalk   Bug 60371, Removed the history update for picked from the Set_Line_Qty_Picked since a separate history has been implemented when pick list is picked.
--  061127  Cpeilk   Modified the error messages related to prepayments.
--  061122  KaDilk   Modified method Unpack_Check_Update__,Added a check for prepayment_approved.
--  061122  Cpeilk   Modified Validate_Proposed_Prepay___ to add a dynamic call to On_Account_Ledger_Item_API.
--  061117  Cpeilk   Modified Unpack_Check_Update___ to call for Validate_Proposed_Prepay___.
--  061114  KaDilk   Added public attribute expected_prepayment_date.
--  061109  NaLrlk   Removed allow_backorders from views and Removed function Get_Allow_Backorders, Added backorder_option to views and
--                   Added functions Get_Backorder_Option, Get_Backorder_Option_Db and Check_Promised_Delivery_Date__.
--  061103  Cpeilk   Modified method Validate_Proposed_Prepay___.
--  061030  IsWilk   Bug 61101, Added a info message to popup when adding, removing document address in procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  061025  Cpeilk   Added some restrictions when prepayment is used.
--  061023  Cpeilk   Added new method Validate_Proposed_Prepay___.
--  061023  Cpeilk   Added checks for not null for fields proposed_prepayment_amount and prepayment_approved in Unpack_Check_Update___.
--  061019  ChBalk   Modified Set_Credit_Blocked method to facilitate unpaid prepayment invoices.
--  061012  KaDilk   Added function Get_Gross_Amt_Incl_Charges.
--  061009  Cpeilk   Added public attributes proposed_prepayment_amount and prepayment_approved(FndBoolean).
--  060925  MiKulk   Added the column First_Actual_Ship_Date to the view customer_order_join
--  060914  RoJalk   Modified Unpack_Check_Update___ to include some additional columns to skip BILLED_ORDER error.
--  060913  NaWilk   Modified call to Language_SYS.Translate_Constant in method Set_Credit_Blocked.
--  060828  NaWilk   Added methods Release_From_Credit_Check and Modify_Release_From_Credit__.
--  060824  Cpeilk   Added a new public attribute released_from_credit_check (FndBoolean).
--  060821  ChBalk   Reversed the public cursor changes, and added cursor get_co_lines_for_customer_part implementation.
--  060731  ChJalk   Replaced Mpccom_Ship_Via_Desc with Mpccom_Ship_Via and Order_Delivery_Term_Desc with Order_Delivery_Term.
--  060728  KaDilk   Make ship via desc and delivery term desc language independant.
--  060718  NuFilk   Bug 58182, Modified Calculate_Line_Bonus_Disc___ to take bonus rate from invoicing customer on CO.
--  060712  ChBalk   Removed public cursor get_line_details implementation.
--  060601  MiErlk   Enlarge Identity - Changed view comments Description.
--  060530  LaBolk   Bug 58302, Modified Get_Tot_Charge_Sale_Tax_Amt to calculate the tax using the correct per-centage.
--  060525  KanGlk   Modified Insert___ - Renamed method call Customer_Order_Charge_API  Add_Customer_Charge to Copy_From_Customer_Charge.
--  060524  MiKulk   Removed the obsolete method Get_Line_By_Ref_Id to remove LU dependancies.
--  060516  MiErlk   Enlarge Identity - Changed view comment
--  060504  KanGlk   Added derived private attribute default_charges and Modified procedure Insert___ and Unpack_Check_Insert___.
--  060503  KanGlk   Modified Insert___ to add default customer charges.
--  060424  IsAnlk   Enlarge Supplier - Changed variable definitions.
--  060419  MaJalk   Enlarge Customer - Changed variable definitions.
--  060418  IsWilk   Enlarge Identity - Changed view comments of customer_no, customer_no_pay.
--  060418  NaLrlk   Enlarge Identity - Changed view comments of deliver_to_customer_no.
--  ------------------------------ 13.4.0 --------------------------------------------
--  060207  MiKulk   Modified the error text in the error code NOTVATFREEVAT in Update___ method.
--  060225  JaJalk   Added a warning message in the Unpack_Check_Update___ if the delivery information is changed for
--  060225           shipment connected CO by modified the existing info message.
--  060224  MiKulk   Manual merge of the LCS patch 51197
--  060223  DaZase   View ORDER_USER_ALLOWED_SITE_LOV added.
--  060217  GeKalk   Modified Validate_Sales_Contract method to check obsolete sales contracts.
--  060131  LaBolk   Bug 55778, Added function Consignment_Lines_Exist to check if there are consignment-enabled order lines.
--  060130  JaJalk   Added Assert safe annotation.
--  060124  NuFilk   Added new method Get_Charge_Gross_Amount and Get_Tot_Charge_Base_Tax_Amount.
--  060124  JaJalk   Added Assert safe annotation.
--  060104  MarSlk   Bug 55361, Added column note_id to customer_Order_Join (ViewJion) view
--  060103  IsAnlk   Added TRUE for General_Sys in Finite_State_Machine___.
--  060102  RaKalk   Added view CUSTOMER_ORDER_CC_LOV to be used in Call_Center module
--  051223  RaNhlk   Bug 55311, Modified view comments of CUSTOMER_ORDER to anable 'L' flag for column contract.
--  051208  MaJalk   Bug 54614, Addded new procedure Check_Forecast_Consumpt_Change.
--  051202  GeKalk   Modified the error message in Sales_Contract_Conn_Allowed___.
--  051125  MaEelk   Replaced Dictionary_SYS.Component_Is_Installed with Dictionary_SYS.Logical_Unit_Is_Installed
--  051123  GeKalk   Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to dynamically call contract_item_API.exist.
--  051121  MaJalk   Bug 54342, Modified functions Get_Total_Base_Price and Get_Total_Sale_Price__.
--  051116  MaGuse   Bug 53530, Modified info messages for pay tax in method Insert___.
--  051116  GeKalk   Added Sales_Contract_No, Contract_Rev_Seq, Contract_Line_No, Contract_Item_No
--  051116           to connect a sales contract to a customer order and added Sales_Contract_Conn_Allowed___.
--  051114  SaNalk   Removed Do_Set_Credit_Blocked___.Added Do_Credit_Check___. Modified Finite_State_Machine___,Do_Release_Credit_Blocked___.
--  051111  SaNalk   Modified Do_Set_Credit_Blocked___.
--  051110  SaNalk   Modified Modify_Credit_Flag__.
--  051109  UsRalk   Added column blocked_reason to VIEWJOIN.
--  051108  SaNalk   Modified Modify_Credit_Flag__ and Do_Release_Credit_Blocked___.
--  051107  UsRalk   Changed the client value of CreditBlocked state to Blocked.
--  051107  UsRalk   Removed method Modify_Cr_Stop__.
--  051104  SaNalk   Added Modify_Credit_Flag__ and modified Do_Release_Credit_Blocked___.
--  051102  UsRalk   Added new method Get_Blocked_Reason_Desc.
--  051101  UsRalk   Added new attribute adv_pay_block (FndBoolean).
--  051021  IsWilk   Removed the attribute delivery_type.
--  051003  KeFelk   Added Site_Invent_Info_API in relavant places where Site_API is used.
--  051003  Cpeilk   Bug 53468, Modified Unpack_Check_Insert___ and Unpack_Check_Update___. Raise error messages only when document or delivery address gets modified.
--  051003  SuJalk   Changed reference in view PROJLOV to user_allowed_site_pub.
--  050927  IsAnlk   Added customer_no as parameter to Customer_Order_Pricing_API.Get_Base_Price_In_Currency call.
--  050921  NaLrlk   Removed unused variables.
--  050829  JoEd     Added methods Do_Set_Line_Qty_Confdiff___, Set_Line_Qty_Confirmeddiff__
--                   and Set_Line_Qty_Confirmeddiff.
--  050815  NuFilk   Modified the method Get_Ord_Total_Tax_Amount to remove multiplication tax amount with price_conv_factor.
--  050804  KanGlk   Modified Validate_Jinsui_Constraints___ method.
--  050802  KanGlk   Modified Validate_Jinsui_Constraints___ method.
--  050715  IsWilk   (LCS 51740), Modified the method Calculate_Planned_Due_Date,
--  050715           to correcly pass parameters to the  Calc_Order_Dates_Backwards.
--  050714  ChJalk   Bug 52217, Modified the PROCEDURE Update___ to Remove and Add Tax Lines for chages if the environment is not Vertex.
--  050712  HoInlk   Bug 50280, Modified the method Get_Ord_Total_Tax_Amount to calculate tax using order currency.
--  050711  KanGlk   Modified methods Validate_Jinsui_Constraints___ and Get_Order_Defaults___.
--  050711  HaPulk   Removed Hints and NULL appends in Get_Next_Line_No.
--  050711  SaJjlk   Modified method Get_Ord_Total_Tax_Amount to perform calculation using price_conv_factor instead of conv_factor.
--  050708  KanGlk   Modified methods Validate_Jinsui_Constraints___ and Get_Order_Defaults___.
--  050707  MaEelk   Passed 'TRUE' to General_SYS.Init call in Finite_State_Machine___.
--  050629  MaMalk   Bug 51007, Modified methods Unpack_Check_Update___, Update___ and renamed and modified the method Calculate_Line_Route_Date___.
--  050629  KanGlk   Added functions Get_Jinsui_Invoice and Get_Jinsui_Invoice_Db and Validate_Jinsui_Constraints___. Modified Unpack_Check_Update___ and Unpack_Check_Inset___ .
--  050629  KanGlk   Added JINSUI_INVOICE public not null attribute to the LU.
--  050623  JaJalk   Corrected the info message "DELIVCONFUPD" in Unpack_Check_Update___.
--  050622  NuFilk   Added a new method Check_Ref_Line_Remove to check if the ref id connected lines could be removed.
--  050610  NiRulk   Bug 49797, Modified Update___ to set the default_addr_flag to 'N' for already Delivered or Cancelled lines.
--  050609  JeLise   Bug 51125, Added new check on objstate_ in Calculate_Line_Route_Date___.
--  050608  NuFilk   Added a new method Check_Delivered_Sched_Order to check if the order is connected to schdule.
--  050607  IsWilk   Modified the error message DELIVERYCONFIRMSTOP in PROCEDURE Unpack_Check_Update.
--  050607  IsWilk   Added the FUNCTION Blocked_Invoicing_Exist and modified the
--  050607           POCEDURE Unpack_Check_update to validate the confirm_deliveries.
--  050601  NuFilk   Modified method Update___ to add provisional_price to the attr_.
--  050601  IsWilk   Removed the column warranty.
--  050527  MaEelk   Added blocked_for_invoicing to CUSTOMER_ORDER_JOIN view.
--  050520  JoEd     Added update check for advance invoice together with delivery confirmation.
--  050520  SaJjlk   Added column PROVISIONAL_PRICE to view CUSTOMER_ORDER_JOIN.
--  050520  JaBalk   Added delivery_address to Get_Customer_Defaults.
--  050517  SaLalk   Bug 49825, Removed the condition on addr_flag in Unpack_Check_Update___ and change the NOTVATFREEVAT info message.
--  050516  NuFilk   Added customer_po_line_no and customer_po_rel_no to CUSTOMER_ORDER_JOIN.
--  050512  JoEd     Added internal customer check for delivery confirmation in Unpack_Check_Update___.
--  050510  JoEd     Added QTY_CONFIRMEDDIFF to VIEWJOIN.
--  050509  KiSalk   Bug 50697, In Unpack_Check_Update___, added 'ADDR_FLAG_DB' change allowed attribute list of Invoiced orders.
--  050506  NuFilk   Modified function Find_Open_Scheduling_Order, included a check in the cursor get_open_scheduling_order.
--  050505  LaBolk   Bug 50111, Modified Finite_State_Machine___ to enable state change from Released to Invoiced. Modified Order_Is_Fully_Invoiced___.
--  050428  VeMolk   Bug 50690, Modified the method Finite_State_Machine___ to handle the event 'SetLineQtyInvoiced'
--  050428           when the customer order is in 'CreditBlocked' state.
--  050411  NuFilk   Added function Find_Open_Scheduling_Order.
--  050404  ToBeSe   Bug 49880, Added parameter contract and added exception handling
--                   for calendar changes in procedure Calendar_Changed.
--  050330  JoEd     Added CONFIRM_DELIVERIES, CHECK_SALES_GRP_DELIV_CONF and DELAY_COGS_TO_DELIV_CONF
--                   to VIEWJOIN.
--  050324  JoEd     Added delivery confirmation validations.
--  050318  JoEd     Added DELIVERY_CONFIRMED to VIEWJOIN.
--  050316  GeKalk   Modified Release_Credit_Blocked to relese all the connected DO's if any.
--  050315  JoEd     Added columns CONFIRM_DELIVERIES, CHECK_SALES_GRP_DELIV_CONF and
--                   DELAY_COGS_TO_DELIV_CONF. Added Get...Db methods for these columns too.
--  050216  IsAnlk   Modified SHIPMENT_CONNECTED as VARCHAR2 and changed the code accordingly.
--  050214  JICE     Bug 49626, Added public attribute cancel_reason.
--  050210  LaBolk   Bug 49521, Removed check for tax information for customer from Unpack_Check_Insert___ and Unpack_Check_Update___ and placed it in Insert___ and Update___.
--  050203  SaJjlk   Removed unused methods Set_Charge_Qty_Invoiced and Uninvoiced_Returns_Exist.
--  050131  JoEd     Changed calls to CustOrdDateCalculation.
--  050113  JICE     Added public method Get_Total_Bonus_Value, corrected Get_Total_Contribution.
--  050111  NaLrLk   Removed the public cursors get_order_demand,get_order_supply_demand and added to the CustomerOrderDemandUtil LU.
--  050105  JaJalk   Added the method Is_Any_Line_Proj_Conn_Exist__.
--  050104  JaBalk   Added Shipment Creation column to customer_order_join view.
--  050103  MaGuse   Bug 48232, Modified setting of recalculation flag for commission lines on update of region_code on order header. Modified method Update___.
--  041230  IsAnlk   Removed consignment functionality from customer orders.
--  041221  VeMolk   Bug 48512, Modified the method Insert__ to move the addition of info to be at the end of the method.
--  041216  LaPrlk   Bug 48550, added translation capability for 'order_status' in the view 'CHARGEJOIN'
--  041215  DiVelk   Modified cursor get_order_demand to consider order header state when the supply code is'PS'.
--  041210  DaZase   Replaced earliest_start_date with latest_release_date in CUSTOMER_ORDER_JOIN.
--  041116  DiVelk   Added condition in where clause of cursor 'get_order_demand'. Modified IF condition in Modify_Wanted_Delivery_Date__.
--  041112  DiVelk   Modified Modify_Wanted_Delivery_Date__.
--  041104  JaJalk   Modified Finite_State_Set___ to update the call center accordingly.
--  041102  DiVelk   Modified Modify_Wanted_Delivery_Date__.
--  041025  KiSalk   Added attributes task_id, case_id and functions Get_Case_Id, Get_Task_Id.
--  041006  MaJalk   Bug 45942, Modified Get_Order_Defaults___ as only when a shipping time and a delivery time has
--  040913  HaPulk   Fixed error in View Comment CO_CHARGE_JOIN.SALES_PART_UNIT_MEAS.
--  040909  MaMalk   Bug 46595, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to raise error messages for invalid addresses.
--  040818  SaRalk   Bug 45003, Added a new public cursor get_line_details.
--  040831  MaEelk   Modified [Validate_Proj_Connect___].
--  040830  UsRalk   Modified [Validate_Proj_Connect___] to read the correct objstate.
--  040826  SaJjlk   Modified method Unpack_Check_Insert___ to check whether a Purchase oredr exists for the same customer
--  040817  DhWilk   Inserted General_SYS.Init_Method in Finite_State_Machine___
--  040817  GeKalk   Modified Get_Order_Defaults___ to fetch forwarding agent from the Customer/Order/Misc Customer Info tab.
--  040811  MiKulk   Bug 46215, Modified the Finite_State_Machine___.
--  040809  MiKulk   Bug 46215, Modified the Finite_State_Machine___ by correcting a technical defect found in bug 45640.
--  040809  DhAalk   Modified the comments of column deliver_to_customer_no in view CUSTOMER_ORDER_JOIN.
--  040722  KeFelk   Changes to Get_Order_Defaults__ regarding CUST_REF.
--  040715  DaRulk   Added input_qty, input_conv_factor, input_variable_values to VIEWJOIN.
--  040713  DaRulk   Added new attribute input_unit_meas to VIEWJOIN.
--  040701  JaBalk   Commented the code for a call Modify_From_Connected_Order in Update___.
--  040701  JaBalk   Removed commented codes.
--  040701  LaBolk   Modified Unpack_Check_Update___, Insert___ and Update___ to handle updations of DO, PO and CO.
--  040630  GeKalk   Removed method Release_Blocked_Orders and modify Release_Credit_Blocked to release DO's.
--  040629  LaBolk   Modified paramters for the call to Modify_From_Connected_Order in Update___.
--  040625  GeKalk   Added a new method Release_Blocked_Orders.
--  040624  LaBolk   Modified Update___.
--  040624  MiKulk   Bug 45640, Modified the Finite_State_Machine___ to handle NULL events when the state is in 'Planned','Cancelled' or 'Credit Blocked'.
--  040623  NaWalk   Added function Get_Customer_Po_No.
--  040623  LaBolk   Modified Update___ to improve note text correction of DO and CO.
--  040622  GeKalk   Modified Get_Order_Defaults___ to add order_consignment_creation.
--  040622  LaBolk   Modified methods Unpack_Check_Insert___, Insert___ and Update___ to maintain same note and document text with DOs.
--  040621  UsRalk   Added new method [Validate_Proj_Connect___] and moved some logic from [Set_Project_Id].
--  040616  LoPrlk   Added the column deliver_to_customer_no to CUSTOMER_ORDER_JOIN.
--  040615  GeKalk   Added new attribute source_order in Unpack_Check_Insert___ to handle customer orders created from distribution orders.
--  040615  WaJalk   Modified method Get_Order_Defaults___ to fetch customer contact to CUST_REF.
--  040614  DiVelk   Added 'project_id' to view CUSTOMER_ORDER_JOIN.
--  040610  DiVelk   Modified Set_Project_Pre_Posting.
--  040610  MiKalk   Bug 41488, Modified the method Finite_State_Machine___ to include the state change from 'Invoiced' to 'Delivered' if Not OrderIsFullyInvoiced and
--  040610           include the event 'NewChargeAdded' for the state 'Invoiced'. Modified the method Order_Is_Fully_Invoiced___ to check whether all charges are also fully invoiced.
--  040610           Added the new methods New_Charge_Added and New_Charge_Added__ . Modified the cursor in All_Charges_Fully_Invoiced___ to exclude the collect charges.
--  040609  ChBalk   Bug 41364, Changes in Calculate_Planned_Due_Date.
--  040608  GeKalk   B115234,Changed the return type of function Is_Order_Exist, Added a new method Is_Dist_Order_Exist___ and
--  040608           modified Unpack_Check_Insert___ and Insert__ to check for the existing Distribution Order No's.
--  040604  KiSalk   Added function Is_Order_Exist.
--  040525  KiSalk   Modified Get_Customer_Defaults.
--  040521  KiSalk   Added Get_Customer_Defaults.
--  040513  DiVelk   Modified function call in Set_Project_Pre_Posting.
--  040511  ChFolk   Bug 44355, Modified Unpack_Check_Update___ to allow to change the 'Allow backorder' flag.
--  040511  JaJalk   Corrected the lead time lables.
--  040506  DaRulk   Renamed 'Desired Delivery Date' to 'Wanted Delivery Date'
--  040421  SaNalk   Added attribute activity_seq to VIEWJOIN.
--  -----------------TouchDown Merge End--------------------------------------------
--  040211  HeWelk   Added new method Get_Tot_Charge_Sale_Tax_Amt().
--  ----------------TouchDown Merge Begin--------------------------------------------
--  040331  Asawlk   Bug 43541, Modified the WHERE clause of the cursor get_order_demand.
--  040311  WaJalk   Bug 41397, Changed procedure Update___ to fetch correct ship via code and leadtime.
--  040308  VeMolk   Bug 42920, Changed the entire implementaion of the method Get_Ord_Total_Tax_Amount in order to
--  040308           calculate the tax in line by line basis with the customer order line level currency rate and conversion factor.
--  040226  Asawlk   Bug 42847, Added supply_code to the SELECT statement of the cursors get_order_demand and get_order_supply_demand.
--  040224  IsWilk   Removed the SUBSTRB from the view for Unicode Changes.
--  040213  SeKalk   Bug 41397, Changed procedures Update___, Get_Delivery_Information.
--  040129  GeKalk   Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  ********************* VSHSB Merge End *************************
--  020516  GeKa     Call Id 84107, Added self billing to the CUSTOMER_ORDER_JOIN.
--  020314  MaGu     Added shipment_connected to view CUSTOMER_ORDER_JOIN.
--  020304  Prinlk   Added public method Get_Shipment_Charge_Amount method to obtain
--                   the total charges connected to a order against a shipment.
--  020124  Prinlk   Added warning when delivery information changes when lines are
--                   connected to a shipment.
--  ********************* VSHSB Merge Start *****************************
--  040122  HaPulk   Removed parameter WNPS from some PRAGMA references.
--  ------------------------------ 13.3.0 -------------------------------------
--  031105  ChIwlk   Merged LCS patch for Bug 34856.
--  031029  JoEd     Rewrote Calendar_Changed. Removed bug correction 30159 - N/A.
--                   When finding dates that ought to be changed, only the distribution
--                   calendar is used - not the manufacturing calendar.
--  031028  JoEd     Bug 40163. Added handling of supply code DOP in Calendar_Changed.
--  031028  JoEd     Changed calculation of wanted_delivery_date in Get_Order_Defaults___ -
--                   when using routes.
--  031022  JoEd     Added message INVALROUTEDATE to display when route date is outside calendar.
--  031020  NuFilk   Modified get_order_demand cursor, included qty_assigned in part of the where condition .
--  031015  DaZa     Added a info message and a check for sourced lines in method Modify_Wanted_Delivery_Date__.
--  031015  PrJalk   Bug Fix 106224, Corrected wrong General_Sys.Init_Method calls for Implementation methods delared in Package.
--  031013  PrJalk   Bug Fix 106224, Added missing and Corrected wrong General_Sys.Init_Method calls.
--  031008  SaNalk   Modified PROCEDURE Unpack_Check_Update___ to change Additional Discount in not invoiced order lines.
--  031007  SaNalk   Modified cursor get_lines to select additional_discount in PROCEDURE Calculate_Line_Bonus_Disc___.
--  030926  JoEd     Changed wanted_delivery_date logic in Get_Order_Defaults___
--                   to avoid replacing new value if NULL comes from client.
--  030923  MaGulk   Merged bug 37024, Added Get_Sm_Connection_Db function.
--  030919  JaJaLk   Modified the procedure Get_Ord_Total_Tax_Amount.
--  030916  MaGulk   Modified Modify_Wanted_Delivery_Date__, to give info message when pegging exists for order line
--  030915  JoEd     Added supplier part no to date calculation methods.
--  040914  LaBolk   LCS Bug 46648, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to raise an error when tax info is not defined for the customer.
--  030912  JoAnSe   Restructure code for ship via and delivery leadtime retrieval.
--  030909  BhRalk   Modified the method Get_Order_Defaults___.
--  030909  BhRalk   Added the variable date_entered_ to method Get_Order_Defaults___ and
--                   passed that variable instead of plannned_ship_date_ when calling method Get_Route_Ship_Date.
--  030903  SaNalk   Modified PROCEDURE Calculate_Line_Bonus_Disc___ to recalculate Tax Lines.
--  030901  PrInlk   Performed CR Merge-02.
--  030827  NaWalk   Code Review Performed.
--  030821  WaJalk   Modified method Get_Order_Defaults___.
--  030819  WaJalk   Modified method Get_Delivery_Information.
--  030819  WaJaLk   Modified method Get_Order_Defaults___,added call to fetch leadtime when agreement is used.
--  030815  PrInLk   Remove trivial call when obtaing leadtime information in the method Get_Order_Defaults___
--  030812  WaJalk   Added columns replicate_changes and change_request to view CUSTOMER_ORDER_JOIN.
--  030725  ChBalk   Added Cust_Order_Leadtime_Util_API.Check_Leadtime_Exist in Insert and Update.
--  030716  NaWalk   Removed Bug coments.
--  030708  NuFilk   Merged the following Bugs 36143, 36459, 36349, 36305, 36291, 35599, 35664, 35872, 35664, 34734,
--  030708           and Excluded Bugs 35015, 36808, 36748.
--  030703  WaJalk   Added supply_site to view CUSTOMER_ORDER_JOIN.
--  030702  JoEd     Changed Get_Order_Defaults___. Changed calculation of wanted delivery date,
--                   so that it starts from a workday. Also includes extra checks against
--                   customer address delivery time.
--  030701  JoEd     Removed procedure Calculate_Planned_Due_Date (used in shortage form - resshort.apt)
--                   Changed function Calculate_Planned_Due_Date to use general date calculation methods.
--                   Removed method Calculate_Planned_Deliv_Date.
--  030701  Asawlk   Added new public cursor get_order_supply_demand which will be used in MRP.
--  030625  DaZa     Added attributes supplier_ship_via_transit and supplier_ship_via_transit_desc to VIEWJOIN.
--  030616  NuFilk   Added Method Get_Note_Id.
--  030613  JoEd     Added attribute release_planning to VIEWJOIN.
--  030520  ChBalk   Added originating_rel_no, originating_line_item_no to CUSTOMER_ORDER_JOIN view.
--  030516  PrInlk   Added summarized_source_lines info into Customer Defaults.
--  030513  PrInlk   Added column summarized_source_lines.
--  030429  JoEd     Added attribute supply_site_reserve_type to VIEWJOIN.
--  030425  NuFilk   Modified method Get_Order_Defaults___.
--  030423  NuFilk   Modified method Unpack_Check_Update___, Modify_Address, Get_Delivery_Information and
--  030423           Get_Order_Defaults___ to fetch ship via code and delivery_leadtime according to new functionality.
-- ******************************* CR Merge **********************************
--  030807  GeKalk   Call Id 100445, Modified Set_Project_Id to give a proper error message for CO - Project connection process.
--  030807  GeKalk   Call Id 99617, Added exchange_item and exchange_item_db to the CUSTOMER_ORDER_JOIN view.
--  030804  GaJalk   Code review changes.
--  030801  SaNalk   Performed SP4 Merge.
--  030725  LaBolk   Added function Get_Line_Demand_Order_Ref1.
--  030724  GeKalk   Done code review in function Check_Exchange_Part_Exist().
--  030711  GeKalk   Modified public cursor get_order_demand to get records where part_ownership 'COMPANY OWNED' or 'CONSIGNMENT'.
--  030630  JaJalk   Modified the method Block_Backorder_For_Eso___.
--  030627  JaJalk   Added the method Block_Backorder_For_Eso___.
--  030625  GeKalk   Added function Check_Exchange_Part_Exist().
--  030602  SudWlk   Added owning_customer_no to view CUSTOMER_ORDER_JOIN.
--  030529  ChIwlk   Rolled back the change in the where clause of view CUSTOMER_ORDER_JOIN.
--  030529  GeKaLk   Modified get_order_demand cursor to get records where part_ownership = 'COMPANY OWNED'.
--  030527  PrTilk   Modified view comments in the VIEW CUSTOMER_ORDER_JOIN.
--  030526  GeKaLk   Changed Set_Project_Id to give error messages when connecting co with lines with owner not equal to the Customer of the header.
--  030523  GeKaLk   Changed CO_PROJECT_LOV to exclude CO having lines with part_ownership = 'SUPPLIER LOANED'.
--  030520  PrTilk   Added part_ownership to the VIEW CUSTOMER_ORDER_JOIN.
--  030513  ChIwlk   Changed where clause of view CUSTOMER_ORDER_JOIN to exclude order lines with supply code 'MRO'.
--  030417  ChIwlk   Added column pay_term_base_date and function Get_Pay_Term_Base_Date.
--  030411  MAJO     Bug 36143, Modified public cursor get_order_demand. Reduce qty required by
--                   qty_assigned. When MRP calulates beginning onhand it uses qty_onhand - qty_reserved.
--  030410  ChFolk   Modified procedure Update___ to modify add/remove tax lines connected to a charge lines according to the change of pay tax of the customer order.
--  030407  SaRalk   Bug 36748, Modified procedure Get_Order_Defaults___.
--  030327  ChFolk   Modified procedure Update___ to add/remove tax lines connected to a charge lines according to the change of pay tax of the customer order.
--  030324  ChFolk   Modified procedure Update___ to modify tax lines connected to charge lines according to the change of addr_flag and ship_addr_no of the customer order.
--  030324  JaJaLk   Modified the procedure Get_Ord_Total_Tax_Amount since the CUST_ORDER_LINE_TAX_LINES_TAB contains all the
--                   the tax id's revent to a order line.
--  030324  SaRalk   Bug 36459, Modified view VIEWJOIN by selecting vat and vat_db from Customer Order Line table and not from Customer Order table.
--  030321  MiKulk   Bug 36349, Modified the Where clause of cursor get_lines in procedure Calculate_Line_Bonus_Disc___
--  030321           so that the discounts of Invoiced order lines will not be updated.
--  030321  SaRalk   Bug 36305, Modified procedures Do_Set_Line_Qty_Shipped___, Do_Set_Line_Qty_Shipped___, Set_Line_Qty_Shipdiff and Set_Line_Qty_Shipped.
--  030320  AnJplk   AnJplk Added function Check_Peggings_Exist.
--  030314  MiKulk   Bug 36291, Modified the procedure Only_Charges_Exist___ by adding a check for existing non Cancelled lines.
--  030305  ThPalk   Bug 35599, Added function Check_Order_Connected.
--  030305  LaBolk   Bug 35664, Added method Set_Charge_Qty_Invoiced and modified methods (Finite_State_Machine___, All_Charges_Fully_Invoiced___) to correctly handle charge lines.
--  030220  ThJalk   Bug 35872, Added check to see whether agreement_type != FIXEDPRICE in method Validate_Customer_Agreement___.
--  030219  KiSalk   Bug 35664, Added procedure Modify_Zero_Ivc_Qty_Chrgs___.
--  030219           Modified procedure All_Charges_Fully_Invoiced___ & Finite_State_Machine___
--  030211  PrJalk   Merged TakeOff changes.
--  030205  AnJplk   Bug 34734, Added Function Added function Get_Allow_Backorders_Db.
--  020627  MaEelk   Modified col comments of Condition Code in CUSTOMER_ORDER_JOIN.
--  020618  MaEelk   Modified col comments of Condition Code in CUSTOMER_ORDER_JOIN.
--  020613  MaEelk   Added Condition Code to the view CUSTOMER_ORDER_JOIN.
--  ------------------TSO Merge-------------------------------------------------
--  030101  SaNalk   Merged SP3.
--  021216  SaNalk   Modified bonus calculation with additional discount in procedure Calculate_Line_Bonus_Disc___.
--  021213  Asawlk   Merged bug fixes in 2002-3 SP3
--  021212  SaNalk   Added a condition to update the staged billing profile with order discount and modified the cursor for
--                   staged billing in procedure Calculate_Line_Bonus_Disc___
--  021205  SaNalk   Added a check in procedure Unpack_Check_Update___ to modify additional discount in order line
--                   additional discount disocunt is changed in order header.Modified Cursors in functions Get_Total_Add_Discount_Amount,
--                   Get_Total_Sale_Price__,Get_Total_Base_Price.Added Additional Discount to view Customer_Order_Join.
--  021123  RaSilk   Bug 34289, Removed procedure Set_Vat added under bug correction 29409.
--  021121  SaNalk   Added a check in procedure Update___, to update tax amounts in order lines.
--  021120  SaNalk   Added a check in procedure Unpack_Check_Insert___ for NULL value of additoinal discount.
--  021118  SaNalk   Changed the functions Get_Total_Sale_Price__, Get_Total_Base_Price to include additional discount amount
--                   in calculatons.Modified the function Get_Total_Add_Discount_Amount.Added a check in procedure Unpack_Check_Update___
--                   for NULL value of additoinal discount.
--  021115  SaNalk   Added the description of functions Get_Total_Add_Discount_Amount and Get_Additional_Discount.
--  021112  ChJalk   Bug 33379, Removed checking NULL for route_Id in Update__.
--  021108  PrJalk   Changed the Case of the Code according to the standards in Get_State .
--  021107  SaNalk   Added a check in proc: Unpack_Check_Update___ for line discount totals.
--  021106  PrJalk   Added Function Get_State .
--  021104  SaNalk   Added an Error Message in proc: Calculate_Line_Bonus_Disc___, when total order discount is greater than 100%.
--  021101  SaNalk   Added the function Get_Total_Add_Discount_Amount.
--  021030  SaNalk   Added the function Get_Additional_Discount.Added Coding to Handle Additional_Discount
--                   in proc: Prepare_Insert___, Unpack_Check_Update___ and Unpack_Check_Insert___.
--  021017  Samnlk   Bug 32996, Remove the Added FUNCTION Get_State.
--  021016  JeLise   Bug 33505, Changed from Get_Object_By_Keys___ to Lock_By_Keys___ and added
--  021016           another check on old_objstate_ in New_Order_Line_Added.
--  021008  Samnlk   Bug 32996, Add a new FUNCTION Get_State.
--  021007  IsWilk   Bug 33285, Added the condition into the FUNCTION Only_Charges_Exist___.
--  021003  GaJalk   Bug 32993, Modified the procedure Get_Order_Defaults___.
--  020917  JoAnSe   Merged the IceAge bugg corrections below onto the AD 2002-3 track.
--  020902  DaZa     Bug 32415, removed bug 29030 solution.
--  020816  GaJalk   Bug 31889, Added a function Order_Lines_Exist.
--  020808  UsRalk   Bug 29108, Modified procedure Insert___ to transfer Documment from quotation.
--  020812  GaJalk   Bug 29409, Added a procedure Set_Vat.
--  020711  IsWilk   Bug 23920, Modified the FUNCTION Only_Charges_Exist___
--  020711           by adding the new cursors get_cancelled_lines and check_connected_lines.
--  020703  NuFilk   Bug 29432, Added new functions Get_Ord_Gross_Amount,Get_Ord_Total_Tax_Amount.
--  020620  ErFi     Added Find_External_Ref_Order
--  020627  MIGUUS   Bug 30159 - Modified method Calendar_Changed.
--  020520  MIGUUS   Bug fix 29137, Modified PRO Get_Total_Base_Charge__ and Get_Total_Sale_Charge__
--                   to get correct Charge Value/Base and Charge Value base of rounding.
--  020520  MIGUUS   Bug fix 30097, Modified PROC Set_Cancelled to call Set_Cancelled__ instead of
--                   Finite_State_Machine___ in order to creat customer order history.
--  020508  GaJalk   Bug 29030, Added an information message to Procedure Insert___.
--  ---------------------------------- IceAge Merge End ------------------------------------
--  -------------------------------- AD 2002-3 Baseline ------------------------------------
--  020308  JoAn     Code clenup for code merged for ID 10115 Sales Tax
--  020226  GaJalk   Bug fix 26284, Modified the procedure Set_Cancelled.
--  011012  JSAnse   Bug fix 19104, Added the function Finite_State_Decode.
--  011004  OsAllk   Bug Fix 25022, Added FUNCTION Is_Pre_Posting_Mandatory.
--  010927  SuSalk   Bug fix 24506, Added conditions to pop the error messasge in Unpack_Check_Update___ method.The conditions for
--                   check the modification of wanted_delevery_date in head.
--  010829  JakHse   Bug fix 23920, Added method for checking cancellations of head with charges, Uninvoiced_Charges_Exist
--  010829  JakHse   Bug Fix 23920, Modified Only_Charges_Exist___ to care for present cancelled order lines
--                                  Modified All_Charges_Fully_Invoiced___ not to care for connected charge lines
--  010813  JakHse   Bug Fix 23636, Added conditions for going from Released to Invoiced, Only_Charges_Exist___, All_Charges_Fully_Invoiced___
--  010720  OsAllk   Bug fix 22237, Modified the condition to call Customer_Order_History_API.New in Set_Cancelled.
--  010510  JSAnse   Bug Fix 20275, Added "AND   CTP_PLANNED = 'N'" in Cursor get_order_demand.
--  010413  JaBa     Bug Fix 20598, Added new global lu constants inst_Project_,inst_WorkOrderPlanning_.
--  010411  CaSt     Bug fix 21217. Order line address was not updated when ship_addr_no was changed in the header.
--  010315  SoPrus   Bug fix 19539. Modified cursor Get_Order_Demand for MRP.
--  010314  MaGu     Bug fix 19177. Changed bill_addr_no to public attribute.
--  010226  RoAnse   Bug fix 20247, Changed definition of new_attr_ from 2000 to 32000 chars in Procedure New.
--                   Changed definition of in_attr from 2000 to 32000 chars in Procedure Get_Order_Defaults___.
--  010222  MaGu     Bug fix 19177. Added intrastat_exempt in methods Get_Order_Defaults___,
--                   Update___ and Modify_Address.
--  010221  MaGu     Bug fix 19177. Added public attribute intrastat_exempt.
--  010104  JoEd     Bug fix 18821. Removed check for negative order totals in
--                   Get_Total_Sale_Price__ and Get_Total_Base_Price.
--                   Also added return 0 if totals are null.
--  010103  JoAn     Corrected NOLEADTIME warning message
--  001205  MaGu     Changed update of order line prices and discount when changing agreement in method Update___.
--  001130  JoEd     Bug fix 18418. Changed driving table in CUSTOMER_ORDER_JOIN.
--  001129  FBen     Bug fix 18473. Changed Unpack_Check_Insert___ so that get_date_del is less or equal to Site_date.
--  001116  MaGu     Added price source id to CUSTOMER_ORDER_JOIN.
--  001116  MaGu     Bug fix 16337. Added check on addr_flag_ and ship_addr_no_ in Modify_Address.
--  001110  MaGu     Modified call to Customer_Order_Pricing_API.Get_Order_Line_Price_Info in procedure Update___.
--                   Added parameter price_source_id.
--  001101  FBen     Added JOB_ID to CUSTOMER_ORDER_JOIN.
--  001029  JoEd     Added CUST_WARRANTY_ID to CUSTOMER_ORDER_JOIN.
--  001025  DaZa     Added consignment_id_ in Get_Collect_Charge_Amount.
--  001010  DaZa     Added earliest_start_date and ctp_planned to CUSTOMER_ORDER_JOIN.
--  001005  JakH     Added Conifgured_Line_Price_Id to CUSTOMER_ORDER_JOIN.
--  000928  DaZa     Added consignment_id to CO_CHARGE_JOIN.
--  000925  JoAn     Added Get_Line_By_Ref_Id. Added parameter price_effectivity_date
--                   in call to Customer_Order_Pricing_API.Get_Order_Line_Price_Info.
--  000924  JakH     Added configuration_id to CUSTOMER_ORDER_JOIN
--  000922  DaZa     Added method Get_Collect_Charge_Amount.
--  000919  JoEd     Call to update order line discounts when agreement is changed.
--  000913  FBen     Added UNDEFINED.
--  000911  JoAn     Added new method Get_No_Of_Orders_Due_For_Part (Requested by Costing)
--  000908  JoEd     Changed fetch of address and delivery information in Calendar_Changed.
--                   Fetch from order line instead of order header as addresses can be
--                   different on order lines and order headers.
--  000830  JoEd     Added attributes dock_code, sub_dock_code, ref_id and
--                   location_no to CUSTOMER_ORDER_JOIN.
--  000718  BRO      Added pricing fields to Customer_Order_Join
--  000615  GBO      Removed quotation_probability, expiration_date, follow_up_date and quotation_note
--  000614  GBO      Modified view PROJLOV -> removed quoted state
--                   Modified cursor Get_Order_Demand -> removed quoted state
--                   Removed quoted state.
--  000530  BRO      Added check in set_released__: base parts should have a configuration
--  000419  DEHA     Added commission management in Update___ functions:
--                   added criterions from which the status in the
--                   commission order line will be set to "changed",
--                   if the corresponding fields in customer order are modified
--  000711  JakH     Merging from Chameleon
--  ------------------------------ 13.0 -------------------------------------
--  000619  DaZa     Added check for User_Allowed_Site_API.Authorized on PROJLOV.
--  000606  CaRa     Increase performence in function Get_Line_Return_Percentage, join with User_Allowed_Site_Pub.
--  000615  JoAn     CID 44301 Order discount not included in total base price in
--                   Calculate_Line_Bonus_Disc___
--  000606  JoEd     Bug fix 16101, Changed Set_Cancelled and Set_Line_Cancelled
--                   so that Set_Cancelled__ and Set_Line_Cancelled__ is not called
--                   to avoid clearing the info message value.
--  000606  CaRa     Added function Get_Line_Return_Percentage, used from portlet Sales Quality.
--  000524  DaZa     Added method Get_External_Ref and column external_ref in Get.
--                   Added call to event Order_Status_Change in Finite_State_Set___.
--  000510  PaLj     Added column Priority. Added to CUSTOMER_ORDER and CUSTOMER_ORDER_JOIN
--  000426  PaLj     Changed check for installed logical units. A check is made when API is instantiatet.
--                   See beginning of api-file.
--  000419  PaLj     Corrected Init_Method Errors
--  000403  MaGu     Replaced all calls to Mpccom_System_Parameter_API for getting picking_leadtime with
--                   calls to Site_API.Get_Picking_Leadtime.
--  000330  MaGu     Modified handling of new agreement_id in Unpack_Check_Update___.
--  000330  MaGu     Added method Modify_Wanted_Delivery_Date__. Added call to this method in
--                   Unpack_Check_Update___.
--  000320  JoEd     Made cust_ref a public attribute.
--  000316  JoEd     Changed initial value on wanted_delivery_date in Get_Order_Defaults___.
--  000308  DaZa     Added methods Is_Sm_Installed__ and Is_Sm2001_Installed__.
--  000224  JoEd     Bug fix 13159. Added trunc of the date in the call to
--                   Get_First_Valid_Agreement in Get_Order_Defaults___.
--  000219  DaZa     Changes in Set_Project_Pre_Posting so we call
--                   Pre_Accounting_API.Set_Project_Code_Part now and make the call for all lines also.
--  000216  MaGu     Bug fix 12908. Added method Get_Delivery_Information.
--  000215  MaGu     Removed bug fix 12911 due to redundant code. Information message already
--                   exists in procedure Unpack_Check_Insert___.
--  000214  JoEd     Changed fetch of "VAT usage" from Company. Added error message NOTAXINFO.
--  000214  PaLj     Bug fix 12911, Added an information message in procedure Get_Order_Defaults___
--                      to inform the lead time is 0.
--  000207  MaGu     Removed check for information specified for quotations in Unpack_Check_Update.
--  000203  JoEd     Added calls to create default tax lines when creating and updating
--                   an order.
--  000203  DaZa     Added method Modify_Sm_Connection.
--  000203  MaGu     Added check in Unpack_Check_Update for information specified for quotations.
--  000202  PaLj     Added functions Get_Scheduling_Connection and Set_Scheduling_Connection
--  000202  PaLj     Added column scheduling_connection
--  000201  MaGu     Added columns quotation_probability, expiration_date, follow_up_date
--                   and quotation_note.
--  000131  DaZa     Added column sm_connection and method Get_Sm_Connection. Added columns
--                   sm_connection_db, sup_sm_contract and sup_sm_object in view VIEWJOIN.
--  000131  DaZa     Some changes in PROJLOV.
--  000127  JoEd     Changed handling of the attribute "Pay Tax".
--  000124  DaZa     Added PROJLOV view and extra parameters to Set_Project_Pre_Posting.
--  000124  PaLj     Added column Staged Billing
--  000121  MaGu     Added column original_part_no to customer_order_join.
--  000119  JoEd     Changed "Pay VAT" to "Pay Tax". Added method Get_Vat_Db.
--  000117  DaZa     Added Project_Id in view and methods Exist_Project___, Set_Project_Id,
--                   Set_Project_Pre_Posting and Get_Project_Id.
--  000114  JoEd     Bug fix 13111. Added Client_SYS.Clear_Info in Get_Customer_Defaults__.
--  000113  JoEd     Bug fix 13159. Changed date until check in Validate_Customer_Agreement___.
--  000113  JoEd     Bug fix 13339. Added nvl check on agreement in Unpack_Check_Update___.
--                   Rebuild the method Validate_Customer_Agreement___.
--  000112  JoEd     Removed handling of extra_discount.
--                   Removed method Order_Is_Fully_Invoiced__.
--  000112  PaLj     Changed Finite State Machine to support Staged Billing
--  000110  JakH     Added Qty_Returned to CHARGEJOIN
--  991215  PaLj     Added added staged_billing_db to CUSTOMER_ORDER_JOIN
--  991130  JoEd     Added public columns extra_discount_amount, extra_discount_base
--                   and extra_discount.
--                   Changed Get_Total_Sale_Price__ and Get_Total_Base_Price
--                   to handle the extra discounts.
--                   Added method Order_Is_Fully_Invoiced__.
--  ------------------------------ 12.0 -------------------------------------
--  991115  JoEd     Changed assignment of wanted delivery date in Get_Order_Defaults___.
--                   Use customer's delivery time instead of the customer's route's time.
--                   Removed call to Construct_Delivery_Time___ in Unpack_Check_Insert___
--                   and fetch of route and forward agent in Unpack_Check_Update___
--                   when ship address has changed. This is done in the client.
--  991112  JoEd     Added delivery leadtime default value in Get_Customer_Defaults__.
--  991112  DaZa     Added total_base_charge_amount in &CHARGEJOIN.
--  991112  DaZa     Fix in Get_Total_Cost, included revised_qty_due to calculation.
--  991111  JoEd     Moved info message NOLEADTIME from Get_Order_Defaults___ to
--                   Unpack_Check_Insert___ to avoid msg if leadtime has been entered
--                   or duplicates, since Get_Order_Defaults is called when new record
--                   in client.
--                   Added check on calc_disc_bonus_flag in Calc_Disc_Bonus_Flag.
--                   If updating to same value, don't update record.
--  991110  JakH     Removed the customer po lov for the RMA. (The Rma-lov in ordrow will do for this purpose too)
--  991104  JoAn     CID 27207 Calling Customer_Is_Credit_Stopped instead of
--                   Get_Cr_Stop in Insert___ to check if the customer is credit blocked.
--  991102  JoEd     Bug fix 10934, Changed so that rounding_ is fetched from the
--                   base currency instead of the order's currency in Insert___.
--                   Changed calculation of prices in Get_Total_Base_Price and
--                   Get_Total_Sale_Price__.
--  991101  JoEd     New LOV for finding order lines with the help of Customer PO No's.
--                   Used in RMA.
--  991029  JoAn     Bug Id 12304 Changed calculation of wanted delivery date
--                   for orders connected to a route.
--                   Changed Calculate_Planned_Due_Date, Removed WANTED_DELIVERY_DATE
--                   from Prepare_Insert___, changed calculation of wanted_delivery_date
--                   in Get_Order_Defaults___, removed code for date validation in Unpack_Check_Insert___.
--  991028  JoEd     Verified that bug 10934 has been corrected in Get_Total_Base_Price.
--                   Made those changes on Sep 27th. See comments further down.
--  991025  PaLj     Changed the bug fix 11297 bug fix.
--  991022  JoEd     Removed call to Unpack_Check_Update___ in Changed Set_Order_Conf__.
--                   Error occurs when Invoiced___ returns TRUE.
--  991021  JoEd     Changed Prepare_Insert___ to only send back user default values
--                   to client if they have values.
--  991019  JOHW     Added method Get_Total_Contribution.
--  991018  PaLj     Bug fix 11297. Added a check in Unpack_Check_Insert___ and Unpack_Check_Update___ to see
--                   whether 'vat free vat code' is not blank for a vat paying customer when 'pay vat' is
--                   unticked in the form frmMiscelleanous.
--  991018  JOHW     In Lov view, added where statement to filter Invoiced and Cancelled.
--  991012  DaZa     Added currency_code to CHARGEJOIN and made some small changes.
--  991011  JakH     Use Return_Material_Line_Tab instead of obsolete table
--                   Customer_Order_Return_tab
--  991011  DaZa     Changes in CHARGEJOIN so it joins tables instead of views.
--  991008  DaZa     Fixes in Get_Total_Base_Charge__ and Get_Total_Sale_Charge__.
--  991007  JoEd     Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  991007  JoEd     Call Id 21210: Corrected double-byte problems.
--  991004  JoEd     Added method Get_Customer_Defaults__.
--  990930  sami     Added purchase_part_no to CUSTOMER_ORDER_JOIN_VIEW.
--  990929  DaZa     Added new view &CHARGEJOIN for use in Overview of customer order charges.
--  990928  PaLj     Changed Get_Default_Shipment_Location to return SHIPMENT locations instead of Floor stock
--                   + Adaption to Consolidated picklist
--  990927  JoEd     Removed charges from methods Get_Total_Base_Price and
--                   Get_Total_Sale_Price__. Added methods Exist_Charges__,
--                   Get_Total_Base_Charge__ and Get_Total_Sale_Charge__.
--  990921  JoEd     Added call terms for Modify_Order_Defaults__.
--  990908  JoEd     Removed unused cursor in Insert___.
--  990908  DaZa     Added charges to methods Get_Total_Base_Price and Get_Total_Sale_Price.
--                   Added CHARGETAB to defines.
--  990908  JoAn     Corrected assignments of pre_accounting_is and note_id in Insert___
--  990907  JoAn     Added desired_qty to CUSTOMER_ORDER_JOIN_VIEW.
--  990824  JoEd     Added call to update all order lines with default address flag.
--  990818  JoEd     Made ship_via_desc and delivery_terms_desc public.
--  990817  JoEd     Rebuild the joined view.
--  ------------------------------ 11.1 -------------------------------------
--  990602  JoEd     Call id 19465: Changed comment for planned_ship_period in
--                   the joined view.
--  990528  JoEd     Call id 18648: Added contract to Get_Latest_Order_No.
--  990527  JakH     CID 18197 Allows updating of ADDR_FLAG and ADDR_FLAG_DB after
--                   partially deliveries (unpack_check_update & modify_address).
--  990527  JoEd     Changed error message NOPICKING to work with Localize.
--  990521  JoEd     Call id 17740: Changed fetch of wanted_delivery_date in
--                   the joined view.
--  990514  JoAn     Added supply_code 'SO' to get_order_demand_cursor.
--  990504  JoAn     Added code to make it possible to add new order lines to
--                   orders in state 'Delivered' or 'Invoiced'.
--  990503  PaLj     Changes in Validate_Customer_Agreement___.
--                   Changed declaration to number for bonus_basis_ and bonus_value_
--                   in Calculate_line_bonus_disc.
--  990423  JoAn     Retrieving new country_code when ship_addr_no is changed.
--  990421  JoAn     Passing db value for supply code in call to
--                   Customer_Order_Line_API.Calculate_Planned_Due_Date__
--  990419  JoAn     Corrected DB/Client value mixups.
--  990415  RaKu     Y.Cleanup.
--  990414  JoAn     Removed obsolete method Non_Acquisition_To_Deliver__.
--  990413  JoEd     Y.Call id 13994: Added a joined view between order header and order lines
--                   to improve query performance in the client.
--  990413  RaKu     New templates.
--  990330  PaLj     In Get_Order_Defaults, Country_Code, District_code and Region_Code
--                   is now fetched from the Delivery adress instead of the document adress.
--  990326  RaKu     Modifyed roundings in Get_Total_Base_Price and added ROUNDING in the
--                   returning attribute-string during New__.
--  990324  RaKu     Added functions Lock_By_Keys___ procedure Lock_By_Keys__.
--  990324  JoAn     Added check for credit blocked customer in Release_Credit_Blocked
--  990316  JoAn     CID 10580 Customer_Order_Flow_API.Proceed_After_Credit_Block
--                   called when releasing a credit blocked order.
--  990302  RaKu     Corrected hint-definitions.
--  990224  JoAn     Corrected default valus for wanted_delivery_date in Get_Order_Defaults___
--  990223  JoAn     CID 9796 Changed the NOLEADTIME message.
--  990218  PaLj     CID 6399 = Bug fix 8172. Changed Calculate_Line_Bonus_Disc___ so
--                   bonus_basis & bonus_value are in basecurrency instead of the cusomers currency.
--  990217  JoAn     CID 9022 Removed time from work_day in Get_Order_Defaults___
--                   Allways retrieveing default delivery time from customer address.
--  990216  JoAn     CID 4220 added contract in calls to Get_Route_Delivery_Date
--  990211  JoAn     Added generation of history record in Check_State.
--  990209  JoAn     Added procedure Check_State.
--  990203  PaLj     Bug fix 5574, Made it possible to update fields 'SALESMAN_CODE',
--                   'MARKET_CODE', 'REGION_CODE' and 'DISTRICT_CODE'
--  990203  JoEd     When assigning a value to wanted_delivery_date or planned_delivery_date,
--                   the route's time will not be added (if used).
--                   Add the time entered by the user instead.
--  990203  RaKu     Added COMPANY to the returning attr_ in Unpack_Check_Insert___.
--  990202  JoEd     Call Id 7964: Changed unpack of wanted_delivery_date in
--                   Get_Order_Defaults___.
--  990202  RaKu     Removed COMPANY from view and added CUSTOM-methods for all
--                   LU's using COMPANY as parameter.
--  990129  JoEd     Removed check on mandatory delivery address delivery time.
--  990129  JoAn     Changed public cusrsor get_order_demand.
--                   (IFS High Performance Mrp request)
--  990128  PaLj     Changed cursor in Non_Acquisition_To_Deliver__
--  990127  JoEd     Added handling of time for wanted and planned delivery date.
--                   Added function Construct_Delivery_Time___ and Get_Delivery_Time.
--  990126  RaKu     Different changes for the new Address-tab in CustomerOrder-form.
--  990125  JoAn     Removed the obsolete methods Get_Sum_Shipped_Not_Invoiced__
--                   and Get_Sum_Due_Not_Shipped__
--  990121  JoEd     Rebuild Calendar_Changed method.
--  990118  PaLj     changed sysdate to Site_API.Get_Site_Date(contract)
--  990109  ToBe     Changed view comments on salesman_code to 20 characters.
--  990107  ErFi     Changed view comments on authorize_code to 20 characters.
--  981222  JoEd     Changed cursor in Calendar_Changed.
--  981217  JoAn     Added new parameter catalog_no to Calculate_Planned_Due_Date.
--  981210  JoEd     Removed error messages conserning calendar working days.
--  981209  JoEd     Changed fetch of payment term.
--                   Modified procedure Calculate_Planned_Deliv_Date.
--  981203  JoAn     Added new  function Calculate_Planned_Due_Date. Modified
--                   the procedure with the same name and Calculate_Planned_Deliv_Date.
--  981202  JoEd     Changed calls to Enterprise.
--  981124  RaKu     Added check in Unpack_Check_Update___ for consignment_stock.
--                   Added procedure Check_Consign_Stock_Lines___.
--  981123  JoEd     SID 7706: Added nvl check on delivery_leadtime in Modify_Address.
--  981119  JoEd     SID 7065: Replaced view ORDERS_PER_CUSTOMER_LOV with
--                   ORDERS_PER_SITE_LOV.
--  981112  CAST     Support 6856. Corrected error message.
--  981109  JoEd     SID 6588: Added parameter order_no to Get_Latest_Order_No.
--                   Added new view ORDERS_PER_CUSTOMER_LOV for LOV in template dialog.
--  981105  CAST     New function: Get_Line_Demand_Code.
--  981103  RaKu     Removed price_list_no from VIEW/TABLE.
--  981102  JoEd     Removed last added Get_Price_List_No method.
--  981030  JoEd     Changed Get_Next_Work_Day to Get_Closest_Work_Day in Calendar_Changed.
--                   Added some non-work day error messages where using the calendar.
--  981029  RaKu     Added Get_Price_List_No (again) for compability reasons.
--  981027  JoEd     Replaced MpccomShopCalendar calls with new calendar WorkTimeCalendar.
--                   And rebuild Calendar_Changes method after renaming it to
--                   Calendar_Changed.
--  981026  RaKu     Moved Get_Order_Price_Info to Customer_Order_Pricing and
--                   renamed it to Get_Sales_Part_Price_Info___.
--  981026  JoAn     Removed retrieval of price_list_no from Customer Agreement.
--  981026  JoAn     Changed cursor in Get_Part_Sales_All_Orders wanted_delivery_date
--                   used instead of planned_due_date.
--  981022  JoAn     Added additional condition to cursor in Get_Revised_Qty_Due_All_Orders
--                   also renamed the method Get_Part_Sales_All_Orders
--  981022  JoAn     Added Get_Revised_Qty_Due_All_Orders
--  981022  RaKu     Removed fetch of default price_list_no in Prepare_Insert___.
--  981006  CaST     New parameter CONTRACT in method Customer_Address_Leadtime_API.Get_Delivery_Leadtime.
--  980929  RaKu     Added info_ in method Modify.
--  980924  JoEd     Support id 5654. Changed cursors in procedure Get_Next_Line_No
--                   to make sure correct index is used.
--  980921  JoAn     Added public method Modify
--  980921  RaKu     Added default order id in Get_Order_Defaults___.
--  980917  JoEd     Changed LOV flags on view columns.
--  980917  RAKU     Changed in Get_Order_Defaults___
--  980916  JoEd     Added function Get_Latest_Order_No.
--                   Removed trunc on date_entered's default value in Insert___.
--                   Added function Get_Date_Entered.
--  980720  JOHW     Reconstruction of inventory location key
--  980527  JOHW     Removed uppercase on COMMENT ON COLUMN &VIEW..delivery_terms_desc and
--                   COMMENT ON COLUMN &VIEW..ship_via_desc
--  980429  RaKu     Modifyed Get_Order_Defaults___. Wanted_Delivery_Date was not returned correctly.
--  980424  JoAn     Moved code from Prepare_Insert___ to Get_Order_Defaults___
--  980424  JoAn     SID 4335 Changed Get_Order_Defaults___ to use agreement id
--                   passed in the atrribute string if any.
--  980423  RaKu     Added ADDR_FLAG handling in Get_Order_Defaults___.
--  980423  JoAn     SID 4316 Added check for NULL pay terms in Get_Order_Defaults___
--                   pay terms retrieved from the paying customer if one is defined.
--  980423  JoAn     SID 4144 Added check if order_id is null in Get_Order_Defaults___
--  980422  RaKu     Changed length on state-machine from 32000.
--  980420  RaKu     Added Clear_Info in Calculate_Line_Route_Date___.
--  980415  RaKu     Removed procedure Get_Number_Of_Lines___ and added logic
--                   for changing Route Id. Added procedure Calculate_Line_Route_Date___.
--  980414  JoAn     SID 3146 Removed duplicates in the string returned from Enumerate_Events__
--  980408  JoAn     SID 2330 Added check for customer_no_pay_addr_no in Get_Order_Defaults___
--  980406  JoAn     SID 3085, 3086 Added new attribute internal_delivery_type.
--  980330  RaKu     Removed LOV-flag on LOVVIEW.ship_addr_no.
--  980326  KaAs     SID 2408 palnned delivery date , I added a control to change the wanted delivey based
--                   on route
--  980316  JoAn     Support Id 1560. Added handling of events SetLineQtyAssigned
--                   SetLineQtyPicked, SetLineQtyShipDiff in state 'Invoiced'
--                   in Finite_State_Machine___
--                   Changed client value for state 'Invoiced' to 'Invoiced/Closed'
--  980311  JoEd     Support Id 856. Changed Internal PO No to Update not allowed.
--  980311  JoEd     Support Id 752. Expired customer can still be used.
--  980306  MNYS     Added new method Get_Total_Cost.
--  980306  JoAn     Removed obsolete methods Create_Internal_Cust_Order and
--                   Modify_Internal_Po_No
--  980303  ToOs     Changed cursor get_line in do_release_quoted_order.
--                   Added AND objstate != 'Cancelled'.
--  980303  RaKu     Removed Exist-checks for Internal_PO_No.
--  980226  JoAn     Changed Get_Order_Defaults___ so that the attrinutes passed
--                   in always override the defaults retrieved.
--  980226  DaZa     Removed forward_agent from view and also removed function
--                   Get_Forward_Agent, added forward_agent_id to view and added
--                   function Get_Forward_Agent_Id.
--  980225  RaKu     Modifyed procedure Get_Order_Defaults___.
--  980225  ToOs     Changed default setting of VAT.Correction of roundings.
--  980224  MNYS     Changes in cursor in Non_Acquisition_To_Deliver__: qty_to_ship != 0.
--                   Added Cust_Ord_Customer_API.Exist(newrec_.customer_no_pay) in
--                   Unpack_Check_Insert___.
--  980220  JoAn     Comparing to db values in Non_Acquisition_To_Deliver__
--  980216  JoAn     Corrected New method to return attr_
--                   Added retrieval of default currency code in Get_Order_Defaults___
--  980209  JoAn     Bug 2811, Not possible to cancel customer order with status
--                   Quoted. Corrected in Finite_State_Machine___.
--  980206  MNYS     Added call to Customer_Agreement_API.Get_Currency_Code in Get_Order_Price_Info.
--  980205  MNYS     Added call to Discount_Class_API.Get_Discount in Get_Order_Price_Info.
--  980204  JoAn     Added function New_Order_Lines_Allowed
--  980202  MNYS     Added check for discount_class in Get_Order_Price_Info.
--  980201  JoAn     Added LOVVIEW requested by Customer Scheduling.
--  980130  RaKu     Moved ORDER_CONSIGNMENT_CREATION default from Prepare_Insert___ to
--                   Get_Order_Defaults___ -> Is fetched from the Cust_Order_Type_API.
--  980128  MNYS     Made corrections in Unpack_Check_Update and Get_Order_Price_Info.
--  980127  KaAs     Diplay route_id and forward_agent as defult and added some control for update
--  980122  MNYS     Added attribute Agreement_Id.
--                   Made some changes in procedure New.
--                   Fetching Ship_Via_Code, Delivery_Terms and Price_List from agreement
--                   if agreement exist on CustomerOrder.
--                   Retrieving price and discount from AgreementSalesPartDeal and
--                   AgreementSalesGroupDeal if available.
--  980120  RaKu     Added functions Get_Addr_Flag and Get_Forward_Agent.
--  980119  RaKu     Renamed Order_Specific_Consignment to Order_Consignment_Creation.
--  980119  RaKu     Added Order_Specific_Consignment and corrected some mistakes.
--  980112  MNYS     Added handling of supply_code = Service Order in function
--                   Non_Acquisition_To_Deliver__.
--  980112  MNYS     Added public procedure New.
--  980108  KaAs     Add route_id and implement Get_Number_Of_Lines___ function
--                   to control IF customer or has any order_no.
--  ...
--  960329  JoEd     Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE order_line_details IS RECORD (
    line_no         VARCHAR2(4),
    rel_no          VARCHAR2(4),
    line_item_no    NUMBER,
    ref_id          VARCHAR2(35));

CURSOR get_co_lines_for_customer_part(
   order_no_         VARCHAR2,
   customer_part_no_ VARCHAR2,
   due_date_         DATE) RETURN order_line_details
IS
   SELECT line_no,
          rel_no,
          line_item_no,
          ref_id
   FROM   CUSTOMER_ORDER_LINE_TAB
   WHERE  order_no = order_no_
   AND    customer_part_no = customer_part_no_
   AND    rowstate != 'Cancelled'
   AND    wanted_delivery_date = due_date_;

TYPE Calculated_Totals_Rec IS RECORD (
   order_line_total_base            NUMBER,
   order_line_total_curr            NUMBER,
   order_line_tax_total_curr        NUMBER,
   order_line_gross_total_curr      NUMBER,
   total_charge_base                NUMBER,
   total_charge_curr                NUMBER,
   total_charge_tax_curr            NUMBER,
   total_charge_gross_curr          NUMBER,   
   total_contribution_base          NUMBER,
   total_contribution_percent       NUMBER,
   additional_discount_curr         NUMBER,
   total_amount_base                NUMBER,
   total_amount_curr                NUMBER,
   toatal_tax_amount_curr           NUMBER,
   total_gross_amount_curr          NUMBER,
   order_weight                     NUMBER,
   order_volume                     NUMBER,
   adjusted_weight_gross_in_charges NUMBER,
   adjusted_volume_in_charges       NUMBER);
   
TYPE Calculated_Totals_Arr IS TABLE OF Calculated_Totals_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Lov_Value_Tab   IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
state_separator_     CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Raise_No_Pay_Addr_Error___ (
   customer_no_pay_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NO_PAY_ADDR: Paying customer :P1 has no document address with order specific attributes specified', customer_no_pay_);
END Raise_No_Pay_Addr_Error___;

PROCEDURE Raise_No_Pay_Terms_Error___ (
   customer_no_      IN VARCHAR2,
   customer_no_pay_  IN VARCHAR2)
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NO_PAY_TERMS: Payment terms have not been defined for the paying customer :P1', NVL(customer_no_pay_, customer_no_));
END Raise_No_Pay_Terms_Error___; 

   
-- Check_Del_Country_Code_Ref___
-- Validate delivery country code with tax liability
PROCEDURE Check_Del_Country_Code_Ref___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE )
IS
   delivery_country_code_ VARCHAR2(2);
BEGIN
    IF NOT (newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
      IF (newrec_.addr_flag = 'Y') THEN
         delivery_country_code_ := Customer_Order_Address_API.Get_Address_Country_Code(newrec_.order_no); 
      ELSE
         delivery_country_code_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
      END IF;
      Tax_Handling_Order_Util_API.Validate_Tax_Liability(newrec_.tax_liability, delivery_country_code_);
   END IF;
END Check_Del_Country_Code_Ref___;


PROCEDURE Do_Release_Blocked___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS   
   info_           VARCHAR2(32000);   
   value_          VARCHAR2(5) := NULL;
   checking_state_ VARCHAR2(30) := 'FROM_CO_RELEASE_CREDIT_BLOCK';
BEGIN   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('BLOCKED_TYPE_DB', Customer_Order_Block_Type_API.DB_NOT_BLOCKED, attr_);
   Client_SYS.Add_To_Attr('BLOCKED_REASON', value_, attr_);
   Modify(info_,attr_,rec_.order_no);
   -- Added the condition to stop creating pegged supply when the CO go to 'Planned' state after releasing from credit block.
   -- Connected orders might need to be created when credit block is released.
   IF ((Order_Is_Planned___(rec_) AND  NOT Order_Is_Manual_Block___(rec_)) OR ( NOT Order_Is_Planned___(rec_)))THEN
      Customer_Order_Flow_API.Proceed_After_Credit_Block(rec_.order_no);
   END IF;
   
   IF (rec_.blocked_type = Customer_Order_Block_Type_API.DB_ADV_PAY_BLOCKED) THEN
      Customer_Order_Flow_API.Credit_Check_Order(rec_.order_no, checking_state_);
      rec_ := Get_Object_By_Keys___(rec_.order_no);
   END IF;
END Do_Release_Blocked___;


PROCEDURE Do_Set_Line_Cancelled___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
  line_no_      VARCHAR2(4);
  rel_no_       VARCHAR2(4);
  line_item_no_ NUMBER;
BEGIN   
   line_no_      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   rel_no_       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   line_item_no_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));

   IF rec_.cancel_reason IS NOT NULL THEN
      CUSTOMER_ORDER_LINE_API.Set_Cancel_Reason(rec_.order_no, line_no_, rel_no_, line_item_no_, rec_.cancel_reason);
   END IF;

   CUSTOMER_ORDER_LINE_API.Set_Cancelled(rec_.order_no, line_no_, rel_no_, line_item_no_);
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Cancelled___;


PROCEDURE Do_Set_Line_Qty_Assigned___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   linerec_          CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
   pkg_qty_reserved_ NUMBER;
   add_hist_log_     VARCHAR2(5);
BEGIN   
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   add_hist_log_         := Client_SYS.Get_Item_Value('ADD_HIST_LOG', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   linerec_.qty_assigned := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_ASSIGNED', attr_));
   CUSTOMER_ORDER_LINE_API.Set_Qty_Assigned(rec_.order_no, linerec_.line_no, linerec_.rel_no,
                              linerec_.line_item_no, linerec_.qty_assigned, add_hist_log_);
-- IF package component, send message to package header.
   IF (linerec_.line_item_no > 0) THEN
      pkg_qty_reserved_ := Reserve_Customer_Order_API.Get_No_Of_Packages_Reserved(rec_.order_no,
                                                                                  linerec_.line_no,
                                                                                  linerec_.rel_no);
      CUSTOMER_ORDER_LINE_API.Set_Qty_Assigned(rec_.order_no, linerec_.line_no, linerec_.rel_no, -1, pkg_qty_reserved_, add_hist_log_);
   END IF;
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Qty_Assigned___;


PROCEDURE Do_Set_Line_Qty_Confdiff___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   linerec_  CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
BEGIN   
   linerec_.line_no           := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no            := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no      := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   linerec_.qty_confirmeddiff := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_CONFIRMEDDIFF', attr_));

   CUSTOMER_ORDER_LINE_API.Set_Qty_Confirmeddiff(rec_.order_no, linerec_.line_no, linerec_.rel_no,
                                                 linerec_.line_item_no, linerec_.qty_confirmeddiff);
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Qty_Confdiff___;


PROCEDURE Do_Set_Line_Qty_Invoiced___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   linerec_  CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
BEGIN   
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   linerec_.qty_invoiced := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_INVOICED', attr_));
   CUSTOMER_ORDER_LINE_API.Set_Qty_Invoiced(rec_.order_no, linerec_.line_no, linerec_.rel_no,
   linerec_.line_item_no, linerec_.qty_invoiced);
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Qty_Invoiced___;


PROCEDURE Do_Set_Line_Qty_Picked___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   linerec_        CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
   pkg_qty_picked_ NUMBER;
   add_hist_log_   VARCHAR2(5);
BEGIN   
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   linerec_.qty_picked   := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_PICKED', attr_));
   add_hist_log_         := Client_SYS.Get_Item_Value('ADD_HIST_LOG', attr_);
   CUSTOMER_ORDER_LINE_API.Set_Qty_Picked(rec_.order_no, linerec_.line_no, linerec_.rel_no,
      linerec_.line_item_no, linerec_.qty_picked, add_hist_log_);
-- IF package component, send message to package header.
   IF (linerec_.line_item_no > 0) THEN
      pkg_qty_picked_ := Pick_Customer_Order_API.Get_No_Of_Packages_Picked(rec_.order_no, linerec_.line_no, linerec_.rel_no);
      CUSTOMER_ORDER_LINE_API.Set_Qty_Picked(rec_.order_no, linerec_.line_no, linerec_.rel_no, -1, pkg_qty_picked_, add_hist_log_);
   END IF;
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Qty_Picked___;


PROCEDURE Do_Set_Line_Qty_Shipdiff___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   linerec_  CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
BEGIN   
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   linerec_.qty_shipdiff := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_SHIPDIFF', attr_));

   IF Customer_Order_Line_API.Get_Objstate(rec_.order_no,linerec_.line_no, linerec_.rel_no,linerec_.line_item_no) != 'Cancelled' THEN
      Customer_Order_Line_API.Set_Qty_Shipdiff(rec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, linerec_.qty_shipdiff);
   END IF;
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Qty_Shipdiff___;


PROCEDURE Do_Set_Line_Qty_Shipped___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   linerec_ CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
   from_undo_delivery_ VARCHAR2(5);
BEGIN   
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   linerec_.qty_shipped  := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_SHIPPED', attr_));
   from_undo_delivery_   := Client_SYS.Get_Item_Value('FROM_UNDO_DELIVERY', attr_);

   IF Customer_Order_Line_API.Get_Objstate(rec_.order_no,linerec_.line_no, linerec_.rel_no,linerec_.line_item_no) != 'Cancelled' THEN
      Customer_Order_Line_API.Set_Qty_Shipped(rec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, linerec_.qty_shipped,
                                              from_undo_delivery_);
   END IF;
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Qty_Shipped___;


PROCEDURE Do_Set_Rent_Line_Completed___ (
   rec_  IN OUT NOCOPY customer_order_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   linerec_ CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
BEGIN
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   
   Customer_Order_Line_API.Set_Rental_Completed(rec_.order_no,linerec_.line_no, linerec_.rel_no,linerec_.line_item_no);

   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Rent_Line_Completed___;

PROCEDURE Do_Set_Rent_Line_Reopened___ (
   rec_  IN OUT NOCOPY customer_order_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   linerec_ CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
BEGIN
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   
   Customer_Order_Line_API.Set_Rental_Reopened(rec_.order_no,linerec_.line_no, linerec_.rel_no,linerec_.line_item_no);
   
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Rent_Line_Reopened___;

PROCEDURE Do_Set_Line_Uninvoiced___ (
   rec_  IN OUT NOCOPY customer_order_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS
   linerec_ CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
BEGIN
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   linerec_.qty_invoiced := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('QTY_INVOICED', attr_));
   
   Customer_Order_Line_API.Set_Uninvoiced(rec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no, linerec_.qty_invoiced);
   
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Set_Line_Uninvoiced___;

PROCEDURE Do_Undo_Line_Delivery___ (
   rec_  IN OUT NOCOPY customer_order_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS 
   deliv_no_  NUMBER;
   linerec_   CUSTOMER_ORDER_LINE_TAB%ROWTYPE;
BEGIN
   linerec_.line_no      := Client_SYS.Get_Item_Value('LINE_NO', attr_);
   linerec_.rel_no       := Client_SYS.Get_Item_Value('REL_NO', attr_);
   linerec_.line_item_no := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LINE_ITEM_NO', attr_));
   deliv_no_             := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('DELIV_NO', attr_));
   Customer_Order_Line_API.Undo_Delivery(rec_.order_no,linerec_.line_no, linerec_.rel_no,linerec_.line_item_no, deliv_no_);
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Do_Undo_Line_Delivery___;

PROCEDURE Order_Delivered___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN   
   Cust_Order_Event_Creation_API.Order_Delivered(rec_.order_no);
END Order_Delivered___;

FUNCTION All_Charges_Fully_Invoiced___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_  NUMBER;
   CURSOR get_uninvoiced_charges IS
      SELECT 1
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = rec_.order_no
      AND    ABS(charged_qty) > ABS(invoiced_qty)
      AND    line_no IS NULL
      AND    collect != 'COLLECT';
BEGIN
   OPEN get_uninvoiced_charges;
   FETCH get_uninvoiced_charges INTO found_;
   IF get_uninvoiced_charges%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_uninvoiced_charges;
   RETURN (found_ = 0);
END All_Charges_Fully_Invoiced___;


FUNCTION Only_Charges_Exist___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   normal_lines_found_     BOOLEAN;
   found_                  NUMBER;
   cancel_not_connected_   NUMBER;
   non_cancel_lines_exist_ NUMBER;
   CURSOR get_normal_lines IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = rec_.order_no;

   CURSOR get_charges IS
      SELECT 1
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = rec_.order_no;

   CURSOR get_cancelled_lines IS
      SELECT LINE_NO
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = rec_.order_no
      AND rowstate = 'Cancelled';

   CURSOR check_connected_lines IS
      SELECT line_no,rel_no
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = rec_.order_no;

   CURSOR check_non_cancelled_lines IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = rec_.order_no
      AND rowstate NOT IN ('Cancelled','Invoiced');
BEGIN
   -- check if normal lines exist
   OPEN get_normal_lines;
   FETCH get_normal_lines INTO found_;
   IF get_normal_lines%FOUND THEN
      normal_lines_found_ := TRUE;
   END IF;
   CLOSE get_normal_lines;

   IF normal_lines_found_ THEN
      FOR line_ IN get_cancelled_lines LOOP
         IF (line_.line_no IS NOT NULL) THEN
            FOR cline_ IN check_connected_lines LOOP
               IF (cline_.line_no IS NOT NULL ) AND (cline_.rel_no IS NOT NULL) THEN
                  RETURN FALSE;
               ELSE
                  cancel_not_connected_ := 0;
               END IF;
            END LOOP;
         ELSE
            RETURN FALSE;
         END IF;
      END LOOP;

      OPEN check_non_cancelled_lines;
      FETCH check_non_cancelled_lines INTO non_cancel_lines_exist_;
      IF check_non_cancelled_lines%NOTFOUND AND (cancel_not_connected_ = 0) THEN
         CLOSE check_non_cancelled_lines;
         RETURN TRUE;
      ELSE
         CLOSE check_non_cancelled_lines;
         RETURN FALSE;
      END IF;
   END IF;

   OPEN get_charges;
   FETCH get_charges INTO found_;
   IF get_charges%NOTFOUND THEN
      found_ := 0;
   ELSE
      IF (normal_lines_found_) THEN
         found_ := 0;
      END IF;
   END IF;
   CLOSE get_charges;

   RETURN (found_ = 1);
END Only_Charges_Exist___;

FUNCTION Order_Is_Manual_Block___ (
   rec_  IN     customer_order_tab%ROWTYPE ) RETURN BOOLEAN
IS 
   found_ NUMBER;
BEGIN
   IF (rec_.blocked_type = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED) THEN
      found_ := 1;       
   ELSE
      found_ := 0;
   END IF;
   RETURN (found_ = 1);   
END Order_Is_Manual_Block___;

FUNCTION Order_Is_Fully_Delivered___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_  NUMBER;
   CURSOR get_notdelivered IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = rec_.order_no
      AND    rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled');
BEGIN
   OPEN get_notdelivered;
   FETCH get_notdelivered INTO found_;
   IF get_notdelivered%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_notdelivered;
   RETURN (found_ = 0);
END Order_Is_Fully_Delivered___;


FUNCTION Order_Is_Fully_Invoiced___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER;
   temp_  NUMBER;

   CURSOR get_uninvoiced IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = rec_.order_no
      AND    rowstate NOT IN ('Invoiced', 'Cancelled');

   CURSOR get_uninvoiced_charges IS
      SELECT 1
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = rec_.order_no
      AND    ABS(charged_qty) > ABS(invoiced_qty)
      AND    line_no IS NULL
      AND    collect != 'COLLECT';

   CURSOR invoice_line_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = rec_.order_no
      AND    rowstate IN ('Invoiced');

   CURSOR charge_line_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = rec_.order_no
      AND    charged_qty = invoiced_qty
      AND    collect != 'COLLECT';
BEGIN
   OPEN get_uninvoiced;
   FETCH get_uninvoiced INTO found_;
   IF get_uninvoiced%NOTFOUND THEN
      OPEN get_uninvoiced_charges;
      FETCH get_uninvoiced_charges INTO found_;
      IF get_uninvoiced_charges%NOTFOUND THEN
         OPEN invoice_line_exist;
         OPEN charge_line_exist;
         FETCH invoice_line_exist INTO temp_;
         FETCH charge_line_exist INTO temp_;
         -- Checks if an invoice order line or charge line exists.
         IF ((invoice_line_exist%FOUND) OR (charge_line_exist%FOUND)) THEN
            found_ := 0;
         END IF;
         CLOSE invoice_line_exist;
         CLOSE charge_line_exist;
      END IF;
      CLOSE get_uninvoiced_charges;
   END IF;
   CLOSE get_uninvoiced;

   RETURN (found_ = 0);
END Order_Is_Fully_Invoiced___;


FUNCTION Order_Is_Picked___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR get_picked IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = rec_.order_no
      AND    rowstate IN ('Picked', 'PartiallyDelivered', 'Delivered', 'Invoiced');
BEGIN
   OPEN get_picked;
   FETCH get_picked INTO found_;
   IF get_picked%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_picked;
   RETURN (found_ = 1);
END Order_Is_Picked___;


FUNCTION Order_Is_Reserved___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR get_reserved IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = rec_.order_no
      AND    rowstate IN ('Reserved', 'Picked', 'PartiallyDelivered', 'Delivered', 'Invoiced');
BEGIN
   OPEN get_reserved;
   FETCH get_reserved INTO found_;
   IF get_reserved%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_reserved;
   RETURN (found_ = 1);
END Order_Is_Reserved___;


FUNCTION Order_Partially_Delivered___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_  NUMBER;
   CURSOR get_delivered IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = rec_.order_no
      AND    rowstate IN ('PartiallyDelivered', 'Delivered', 'Invoiced');
BEGIN
   OPEN get_delivered;
   FETCH get_delivered INTO found_;
   IF get_delivered%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_delivered;
   RETURN (found_ = 1);
END Order_Partially_Delivered___;

FUNCTION Order_Is_Planned___ (
   rec_ IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   found_ NUMBER;   
   CURSOR get_planned IS
      SELECT 1
      FROM   CUSTOMER_ORDER_TAB
      WHERE  order_no = rec_.order_no
      AND    blocked_from_state IN ('Planned');
BEGIN
   OPEN get_planned;
   FETCH get_planned INTO found_;   
   IF get_planned%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_planned;
   RETURN (found_ = 1);
END Order_Is_Planned___;

-- Get_Order_Defaults___
--   Attaches all defaults needed to the "attr_"-string
--   after the parameter "customer_no" has been typed.
PROCEDURE Get_Order_Defaults___ (
   attr_           IN OUT VARCHAR2,
   all_attributes_ IN     VARCHAR2 DEFAULT 'TRUE' )
IS
   contract_                   customer_order_tab.contract%TYPE;
   customer_no_                customer_order_tab.customer_no%TYPE;
   cust_no_                    customer_order_tab.customer_no%TYPE;
   customer_no_pay_            customer_order_tab.customer_no_pay%TYPE;
   customer_no_pay_ref_        CUSTOMER_ORDER_TAB.customer_no_pay_ref%TYPE;
   customer_no_pay_addr_no_    customer_order_tab.customer_no_pay_addr_no%TYPE;
   ship_via_code_              customer_order_tab.ship_via_code%TYPE;
   language_code_              customer_order_tab.language_code%TYPE;
   ship_addr_no_               customer_order_tab.ship_addr_no%TYPE;
   bill_addr_no_               customer_order_tab.bill_addr_no%TYPE;
   addr_no_                    customer_order_tab.bill_addr_no%TYPE;
   order_id_                   customer_order_tab.order_id%TYPE;
   currency_code_              customer_order_tab.currency_code%TYPE;
   agreement_id_               customer_order_tab.agreement_id%TYPE;
   delivery_terms_             customer_order_tab.delivery_terms%TYPE;
   del_terms_location_         customer_order_tab.del_terms_location%TYPE := NULL;
   route_id_                   customer_order_tab.route_id%TYPE;
   forward_agent_id_           customer_order_tab.forward_agent_id%TYPE;
   pay_term_id_                customer_order_tab.pay_term_id%TYPE;
   summarize_source_lines_     customer_order_tab.summarized_source_lines%TYPE;
   pick_inventory_type_        customer_order_tab.pick_inventory_type%TYPE;
   use_pre_ship_del_note_      customer_order_tab.use_pre_ship_del_note%TYPE;
   priority_                   customer_order_tab.priority%TYPE;
   delivery_leadtime_          customer_order_tab.delivery_leadtime%TYPE := NULL;
   wanted_delivery_date_       customer_order_tab.wanted_delivery_date%TYPE;
   tax_id_no_                  customer_order_tab.tax_id_no%TYPE;                
   date_string_                VARCHAR2(25);
   picking_leadtime_           NUMBER;
   in_attr_                    VARCHAR2(32000);
   ptr_                        NUMBER;
   name_                       VARCHAR2(30);
   value_                      VARCHAR2(4000);
   agreement_found_            BOOLEAN := FALSE;
   site_date_time_             DATE;
   site_date_                  DATE;
   planned_ship_date_          DATE;
   calendar_id_                VARCHAR2(10);      
   customer_rec_               Cust_Ord_Customer_API.Public_Rec;
   address_rec_                Cust_Ord_Customer_Address_API.Public_Rec;
   timestamp_                  VARCHAR2(20);
   date_entered_               customer_order_tab.date_entered%TYPE;
   confirm_deliveries_         customer_order_tab.confirm_deliveries%TYPE;
   check_sales_grp_deliv_conf_ customer_order_tab.check_sales_grp_deliv_conf%TYPE;
   delay_cogs_to_deliv_conf_   customer_order_tab.delay_cogs_to_deliv_conf%TYPE;
   jinsui_invoice_             customer_order_tab.jinsui_invoice%TYPE;
   shipment_creation_          VARCHAR2(200);   
   order_no_                   VARCHAR2(12);
   demand_site_                VARCHAR2(5);
   freight_map_id_             customer_order_tab.freight_map_id%TYPE;
   zone_id_                    customer_order_tab.zone_id%TYPE;
   summarize_freight_charges_  customer_order_tab.summarized_freight_charges%TYPE;
   freight_price_list_no_      customer_order_tab.freight_price_list_no%TYPE;

   backorder_option_           VARCHAR2(40);
   supply_country_             customer_order_tab.supply_country%TYPE;
   cust_calendar_id_           customer_order_tab.cust_calendar_id%TYPE;
   ext_transport_calendar_id_  customer_order_tab.ext_transport_calendar_id%TYPE;   
   delivery_country_           customer_order_tab.country_code%TYPE;
   shipment_type_              VARCHAR2(3) := NULL;
   ship_inventory_location_no_ VARCHAR2(35);
   vendor_no_                  VARCHAR2(20);
   use_price_incl_tax_db_      VARCHAR2(20);
   print_delivered_lines_      VARCHAR2(23);
   ncf_reference_method_       VARCHAR2(20);
   b2b_order_                  VARCHAR2(5) := 'FALSE';
   site_rec_                   Site_API.Public_Rec;
   site_info_rec_              Site_Discom_Info_API.Public_Rec;
BEGIN
   -- Make a copy of the in parameter attribute string
   in_attr_ := attr_;
   
   -- Retrieve values passed in the attribute string
   route_id_              := Client_SYS.Get_Item_Value('ROUTE_ID', attr_);
   customer_no_           := Client_SYS.Get_Item_Value('CUSTOMER_NO', attr_);
   order_id_              := Client_SYS.Get_Item_Value('ORDER_ID', attr_);
   ship_addr_no_          := Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_);
   contract_              := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   currency_code_         := Client_SYS.Get_Item_Value('CURRENCY_CODE', attr_);
   date_string_           := Client_SYS.Get_Item_Value('WANTED_DELIVERY_DATE', attr_);
   ship_via_code_         := Client_SYS.Get_Item_Value('SHIP_VIA_CODE', attr_);
   cust_calendar_id_      := Client_SYS.Get_Item_Value('CUST_CALENDAR_ID', attr_);
   vendor_no_             := Client_SYS.Get_Item_Value('VENDOR_NO', attr_);
   use_price_incl_tax_db_ := Client_SYS.Get_Item_Value('USE_PRICE_INCL_TAX_DB', attr_);
   delivery_terms_        := Client_SYS.Get_Item_Value('DELIVERY_TERMS', attr_);
   del_terms_location_    := Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', attr_);
   
   Site_API.Exist(contract_);
   Cust_Ord_Customer_API.Exist(customer_no_);   
   
   site_rec_      := Site_API.Get(contract_);
   site_date_     := Site_API.Get_Site_Date(contract_);
   customer_rec_  := Cust_Ord_Customer_API.Get(customer_no_);   
   
   IF (currency_code_ IS NULL) THEN
      currency_code_ := customer_rec_.currency_code;
   END IF;
   
   IF (order_id_ IS NULL) THEN
      -- Get order_id from site/customer, site, customer
      order_id_ := Get_Default_Order_Type(contract_, customer_no_);      
   END IF;
   
   -- Check Access for the customer before it fetch all the defult values.
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF Rm_Acc_Usage_API.Possible_To_Insert('CustomerOrder', NULL, 'DO', NULL, customer_no_) = FALSE THEN
         Rm_Acc_Usage_API.Raise_No_Access('CustomerOrder', NULL, customer_no_);
      END IF;
   $END
   
   -- IF no ship address was passed in retrive the default.
   IF (ship_addr_no_ IS NULL) THEN
      ship_addr_no_ := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
      Trace_SYS.Field('Fetched new ship address', ship_addr_no_);
   END IF;
   IF (ship_addr_no_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NO_SHIP_ADDR: Customer :P1 has no delivery address with order specific attributes specified.', customer_no_);
   END IF;
   
   -- Retrieve the current date and time for this site
   site_date_time_ := NVL(site_date_, trunc(SYSDATE));
   -- Retrieve the distribution calendar_id
   calendar_id_    := site_rec_.dist_calendar_id;
   address_rec_    := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);
   
   IF (cust_calendar_id_ IS NULL) THEN
      cust_calendar_id_ := address_rec_.cust_calendar_id;
   END IF;
   
   -- IF agreement id is passed in the attribute string use that agreement id (even if the value passed is null)
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(in_attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'AGREEMENT_ID') THEN
         agreement_id_ := value_;
         agreement_found_ := TRUE;
      END IF;
   END LOOP;
   IF NOT agreement_found_ THEN
      agreement_id_ := Customer_Agreement_API.Get_First_Valid_Agreement(customer_no_, contract_, currency_code_, site_date_time_, 'FALSE');
   END IF;
   IF (Customer_Agreement_API.Get_Use_By_Object_Head_Db(agreement_id_) = Fnd_Boolean_API.DB_FALSE) THEN
      agreement_id_    := NULL;
   END IF;
   IF (ship_via_code_ IS NULL) THEN
      -- IF not ship via code was passed in the retrive the default value for ship via code and delivery leadtime
      Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(ship_via_code_,
                                                                  delivery_terms_,
                                                                  del_terms_location_,
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
                                                                  vendor_no_);
   ELSIF (delivery_leadtime_ IS NULL) THEN
      -- Retrive the delivery leadtime for the specified ship via code
      Cust_Order_Leadtime_Util_API.Fetch_Head_Delivery_Attributes( route_id_,
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
                                                                   'N',
                                                                   ship_via_code_,
                                                                   vendor_no_);
   END IF;
      
   IF all_attributes_ = 'TRUE' THEN
      -- Retrieve values passed in the attribute string
      confirm_deliveries_         := Client_SYS.Get_Item_Value('CONFIRM_DELIVERIES_DB', attr_);
      check_sales_grp_deliv_conf_ := Client_SYS.Get_Item_Value('CHECK_SALES_GRP_DELIV_CONF_DB', attr_);
      shipment_creation_          := NVL(Client_SYS.Get_Item_Value('SHIPMENT_CREATION', attr_), Client_SYS.Get_Item_Value('SHIPMENT_CREATION_DB', attr_));
      pick_inventory_type_        := Client_SYS.Get_Item_Value('PICK_INVENTORY_TYPE_DB', attr_);
      use_pre_ship_del_note_      := Client_SYS.Get_Item_Value('USE_PRE_SHIP_DEL_NOTE_DB', attr_);
      priority_                   := Client_SYS.Get_Item_Value('PRIORITY', attr_);
      backorder_option_           := Client_SYS.Get_Item_Value('BACKORDER_OPTION_DB', attr_);
      supply_country_             := ISO_Country_API.Encode(Client_SYS.Get_Item_Value('SUPPLY_COUNTRY', attr_));
      print_delivered_lines_      := Delivery_Note_Options_API.Encode(Client_SYS.Get_Item_Value('PRINT_DELIVERED_LINES', attr_));
      
      site_info_rec_              := Site_Discom_Info_API.Get(contract_);

      IF (priority_ IS NULL) THEN
         priority_ := NVL(NVL(Message_Defaults_Per_Cust_API.Get_Priority(contract_, customer_no_),site_info_rec_.priority),customer_rec_.priority);
      END IF;

      -- Confirm Deliveries should not be set when order is created from Distribution Order.
      IF (NVL(Client_SYS.Get_Item_Value('SOURCE_ORDER', attr_), ' ') = 'DO') THEN
         order_no_ := Client_SYS.Get_Item_Value('ORDER_NO', attr_);

         $IF Component_Disord_SYS.INSTALLED $THEN
            demand_site_ := Distribution_Order_API.Get_Demand_Site(order_no_);           
         $ELSE
            NULL;         
         $END
      ELSE
         demand_site_ := customer_rec_.acquisition_site;
      END IF;

      IF (Site_API.Get_Company(demand_site_) = site_rec_.company) THEN
         confirm_deliveries_ := 'FALSE';
      END IF;

      -- Delivery Confirmation info defaulted from Customer
      IF (confirm_deliveries_ IS NULL) THEN
         confirm_deliveries_ := customer_rec_.confirm_deliveries;
      END IF;

      IF (check_sales_grp_deliv_conf_ IS NULL) THEN
         check_sales_grp_deliv_conf_ := customer_rec_.check_sales_grp_deliv_conf;
      END IF;

      language_code_   := Cust_Ord_Customer_API.Get_Language_Code(customer_no_);
      bill_addr_no_    := Cust_Ord_Customer_API.Get_Document_Address(customer_no_);

      customer_no_pay_ := Client_SYS.Get_Item_Value('CUSTOMER_NO_PAY', attr_);
      IF (customer_no_pay_ IS NULL) THEN
         customer_no_pay_ := customer_rec_.customer_no_pay;
      END IF;

      -- Obtain summarized sourced order lines attribute
      summarize_source_lines_ := customer_rec_.summarized_source_lines;
      -- Obtain summarized sourced order lines attribute
      summarize_freight_charges_ := customer_rec_.summarized_freight_charges;

      IF (customer_no_pay_ IS NOT NULL) THEN
         customer_no_pay_addr_no_ := Cust_Ord_Customer_API.Get_Document_Address(customer_no_pay_);
         IF (customer_no_pay_addr_no_ IS NULL) THEN
            -- This method will check for CRM Access for Paying Customer.
             Cust_Ord_Customer_API.Check_Access_For_Customer( customer_no_pay_, 'Paying Customer');
             Raise_No_Pay_Addr_Error___(customer_no_pay_);
         END IF;
         customer_no_pay_ref_ := Cust_Ord_Customer_API.Fetch_Cust_Ref(customer_no_pay_, customer_no_pay_addr_no_, 'TRUE');
      END IF;

--      IF (agreement_id_ IS NOT NULL) THEN
--         agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);         
--         -- Ship via code will be retrived by Get_Supply_Chain_Defaults method         
--         -- IF the agreement has delivery terms get delivery_term and del_terms_location from agreement
--         -- if not retrieve delivery term and location from Customer.
--         delivery_terms_ := agreement_rec_.delivery_terms;     
--         del_terms_location_ := agreement_rec_.del_terms_location;
--      END IF;

      -- Get the default value for pay terms
      pay_term_id_ := Identity_Invoice_Info_API.Get_Pay_Term_Id(site_rec_.company, NVL(customer_no_pay_, customer_no_), Party_Type_API.Decode('CUSTOMER'));

      IF (pay_term_id_ IS NULL) THEN
         Raise_No_Pay_Terms_Error___(customer_no_, customer_no_pay_);
      END IF;

      -- Get the default value for create jinsui info.
      $IF Component_Jinsui_SYS.INSTALLED $THEN         
         ncf_reference_method_ := Company_Invoice_Info_API.Get_Ncf_Reference_Method_Db(site_rec_.company);         
         IF (ncf_reference_method_ = 'CJIN') THEN
           IF  customer_no_pay_ IS NOT NULL THEN
              jinsui_invoice_ := Js_Customer_Info_API.Get_Create_Js_Invoice(site_rec_.company, customer_no_pay_);              
           ELSE
              jinsui_invoice_ := Js_Customer_Info_API.Get_Create_Js_Invoice(site_rec_.company, customer_no_);              
           END IF;
        ELSE
            jinsui_invoice_ := 'FALSE';
         END IF;
      $END
      jinsui_invoice_ := NVL(jinsui_invoice_,'FALSE');

      -- if Delivery Confirmation is not required - we don't have to delay COGS.
      IF (confirm_deliveries_ = 'FALSE') THEN
         delay_cogs_to_deliv_conf_ := 'FALSE';
      -- fetch Delay COGS value from Company
      ELSE
         delay_cogs_to_deliv_conf_ := Company_Order_Info_API.Get_Delay_Cogs_To_Deliv_Con_Db(site_rec_.company);
      END IF;

      IF (freight_map_id_ IS NULL) AND (zone_id_ IS NULL) THEN
         Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(freight_map_id_,
                                                        zone_id_,
                                                        customer_no_,
                                                        ship_addr_no_,
                                                        contract_,
                                                        ship_via_code_);

      END IF;
      IF (freight_map_id_ IS NOT NULL) THEN
         freight_price_list_no_ := Freight_Price_List_Base_API.Get_Active_Freight_List_No(contract_,ship_via_code_,freight_map_id_,forward_agent_id_, use_price_incl_tax_db_);
      END IF;
      
      IF (delivery_terms_ IS NULL) THEN
         delivery_terms_ := address_rec_.delivery_terms;
         del_terms_location_ := address_rec_.del_terms_location;
      END IF;

      IF (pick_inventory_type_ IS NULL) THEN
         pick_inventory_type_ := NVL(Cust_Order_Type_API.Get_Pick_Inventory_Type_Db(order_id_),'ORDINV');
      END IF;

      IF (use_pre_ship_del_note_ IS NULL) THEN
         use_pre_ship_del_note_ := site_info_rec_.use_pre_ship_del_note;
      END IF;

      IF (backorder_option_ IS NULL) THEN
          backorder_option_ := customer_rec_.backorder_option;     
      END IF;

      IF (supply_country_ IS NULL) THEN
         supply_country_ := Company_Site_API.Get_Country_Db(contract_);
         IF supply_country_ IS NOT NULL THEN
            Client_SYS.Set_Item_Value('SUPPLY_COUNTRY_DB', supply_country_, attr_);
         END IF;
      END IF;
      
      delivery_country_ := Cust_Ord_Customer_Address_API.Get_Country_Code(customer_no_, ship_addr_no_);
            
      Client_SYS.Set_Item_Value('GRP_DISC_CALC_FLAG_DB', 'N', attr_);      
      Client_SYS.Set_Item_Value('ORDER_CODE', 'O', attr_);
      Client_SYS.Set_Item_Value('ORDER_CONF_DB', 'N', attr_);
      Client_SYS.Set_Item_Value('PICK_LIST_FLAG_DB', 'Y', attr_);
      Client_SYS.Set_Item_Value('ADDR_FLAG_DB', 'N', attr_);
      Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', delivery_leadtime_, attr_);
      Client_SYS.Set_Item_Value('INTRASTAT_EXEMPT_DB', address_rec_.intrastat_exempt, attr_);
      Client_SYS.Set_Item_Value('DELIVERY_TERMS', delivery_terms_, attr_);
      Client_SYS.Set_Item_Value('DEL_TERMS_LOCATION', del_terms_location_, attr_);
      Client_SYS.Set_Item_Value('PAY_TERM_ID', pay_term_id_, attr_);
      Client_SYS.Set_Item_Value('TAX_LIABILITY', Tax_Handling_Util_API.Get_Customer_Tax_Liability(customer_no_, ship_addr_no_, site_rec_.company, supply_country_), attr_);
      Client_SYS.Set_Item_Value('COUNTRY_CODE', delivery_country_, attr_);
      Client_SYS.Set_Item_Value('REGION_CODE', address_rec_.region_code, attr_);
      Client_SYS.Set_Item_Value('DISTRICT_CODE', address_rec_.district_code, attr_);
      Client_SYS.Set_Item_Value('CURRENCY_CODE', currency_code_, attr_ );
      Client_SYS.Set_Item_Value('LANGUAGE_CODE', language_code_, attr_);
      Client_SYS.Set_Item_Value('SALESMAN_CODE', customer_rec_.salesman_code, attr_);
      Client_SYS.Set_Item_Value('CUST_REF', Cust_Ord_Customer_API.Fetch_Cust_Ref(customer_no_, bill_addr_no_, 'TRUE'), attr_);
      Client_SYS.Set_Item_Value('BACKORDER_OPTION', Customer_Backorder_Option_API.Decode(backorder_option_), attr_);
      Client_SYS.Set_Item_Value('ORDER_CONF_FLAG_DB', customer_rec_.order_conf_flag, attr_);
      Client_SYS.Set_Item_Value('PACK_LIST_FLAG_DB', customer_rec_.pack_list_flag, attr_);
      Client_SYS.Set_Item_Value('MARKET_CODE', customer_rec_.market_code, attr_);
      Client_SYS.Set_Item_Value('PRINT_CONTROL_CODE', customer_rec_.print_control_code, attr_);
      Client_SYS.Set_Item_Value('BILL_ADDR_NO', bill_addr_no_, attr_);
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', ship_addr_no_, attr_);
      Client_SYS.Set_Item_Value('SUMMARIZED_SOURCE_LINES_DB', summarize_source_lines_, attr_);
      Client_SYS.Set_Item_Value('AGREEMENT_ID', agreement_id_, attr_);
      Client_SYS.Set_Item_Value('CONFIRM_DELIVERIES_DB', confirm_deliveries_, attr_);
      Client_SYS.Set_Item_Value('CHECK_SALES_GRP_DELIV_CONF_DB', check_sales_grp_deliv_conf_, attr_);
      Client_SYS.Set_Item_Value('DELAY_COGS_TO_DELIV_CONF_DB', delay_cogs_to_deliv_conf_, attr_);
      Client_SYS.Set_Item_Value('JINSUI_INVOICE_DB', jinsui_invoice_, attr_);      
      Client_SYS.Set_Item_Value('RELEASED_FROM_CREDIT_CHECK_DB', 'FALSE', attr_);
      Client_SYS.Set_Item_Value('PROPOSED_PREPAYMENT_AMOUNT', '0', attr_);
      Client_SYS.Set_Item_Value('PREPAYMENT_APPROVED_DB', 'FALSE', attr_);
      Client_SYS.Set_Item_Value('PICK_INVENTORY_TYPE_DB', pick_inventory_type_, attr_);
      Client_SYS.Set_Item_Value('USE_PRE_SHIP_DEL_NOTE_DB', use_pre_ship_del_note_, attr_);
      Client_SYS.Set_Item_Value('CLASSIFICATION_STANDARD', Assortment_Structure_API.Get_Classification_Standard(Customer_Assortment_Struct_API.Find_Default_Assortment(customer_no_)), attr_);
      Client_SYS.Set_Item_Value('LIMIT_SALES_TO_ASSORTMENTS_DB', Customer_Assortment_Struct_API.Check_Limit_Sales_To_Assorts(customer_no_), attr_);   
      Client_SYS.Set_Item_Value('PRIORITY', priority_, attr_);
      Client_SYS.Set_Item_Value('FREIGHT_MAP_ID', freight_map_id_, attr_);
      Client_SYS.Set_Item_Value('ZONE_ID', zone_id_, attr_);
      Client_SYS.Set_Item_Value('FREIGHT_PRICE_LIST_NO', freight_price_list_no_, attr_);
      Client_SYS.Set_Item_Value('SUMMARIZED_FREIGHT_CHARGES_DB', summarize_freight_charges_, attr_);
      Client_SYS.Set_Item_Value('APPLY_FIX_DELIV_FREIGHT_DB', 'FALSE', attr_);
      Client_SYS.Set_Item_Value('PRINT_DELIVERED_LINES_DB', NVL(Delivery_Note_Options_API.Encode(print_delivered_lines_), customer_rec_.print_delivered_lines), attr_); 
      Client_SYS.Set_Item_Value('PRINT_DELIVERED_LINES', NVL(print_delivered_lines_, Delivery_Note_Options_API.Decode(customer_rec_.print_delivered_lines)), attr_); 
      Client_SYS.Set_Item_Value('CUST_CALENDAR_ID', cust_calendar_id_, attr_); 
      Client_SYS.Set_Item_Value('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
      Client_SYS.Set_Item_Value('PICKING_LEADTIME', picking_leadtime_, attr_);
      Client_SYS.Set_Item_Value('SHIPMENT_TYPE', shipment_type_, attr_);
      -- gelr: outgoing_fiscal_note, begin
      Client_SYS.Set_Item_Value('FINAL_CONSUMER_DB', 'FALSE', attr_);
      -- gelr: outgoing_fiscal_note, end
      -- gelr:alt_invoice_no_per_branch, begin
      IF (Company_Localization_Info_API.Get_Parameter_Value_Db(site_rec_.company, 'ALT_INVOICE_NO_PER_BRANCH') = Fnd_Boolean_API.DB_TRUE) THEN
         Client_SYS.Set_Item_Value('COMPONENT_A', Off_Inv_Num_Comp_Series_API.Get_Default_Component(site_rec_.company, site_info_rec_.branch), attr_);
      END IF;
      -- gelr:alt_invoice_no_per_branch, end

      IF (shipment_creation_ IS NULL) THEN
         Client_SYS.Set_Item_Value('SHIPMENT_CREATION', Shipment_Type_API.Get_Shipment_Creation_Co(shipment_type_), attr_);
      END IF;

      IF (customer_no_pay_ IS NOT NULL ) THEN
         Client_SYS.Set_Item_Value('CUSTOMER_NO_PAY', customer_no_pay_, attr_);
         IF (customer_no_pay_addr_no_ IS NOT NULL) THEN
            Client_SYS.Set_Item_Value('CUSTOMER_NO_PAY_ADDR_NO', customer_no_pay_addr_no_, attr_);
         END IF;
         IF (customer_no_pay_ref_ IS NOT NULL) THEN
            Client_SYS.Set_Item_Value('CUSTOMER_NO_PAY_REF', customer_no_pay_ref_, attr_);
         END IF;   
      END IF;
      IF (customer_no_pay_ IS NOT NULL) THEN
         cust_no_ := customer_no_pay_;
         addr_no_ := customer_no_pay_addr_no_;
      ELSE
         cust_no_ := customer_no_;
         addr_no_ := bill_addr_no_;         
      END IF;
      tax_id_no_ := Customer_Document_Tax_Info_API.Get_Vat_No_Db(cust_no_, addr_no_, site_rec_.company, supply_country_, delivery_country_);
      Client_SYS.Set_Item_Value('TAX_ID_NO', tax_id_no_, attr_);

      IF (tax_id_no_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('TAX_ID_VALIDATED_DATE', Tax_Handling_Order_Util_API.Get_Tax_Id_Validated_Date(customer_no_pay_, customer_no_pay_addr_no_, customer_no_, bill_addr_no_, site_rec_.company, supply_country_, delivery_country_), attr_);
      END IF;   
   END IF; -- all_attributes_ = 'TRUE'
   
   -- Fetch delivery date - if null, fetch site's current date
   IF (date_string_ IS NOT NULL) THEN
      wanted_delivery_date_ := Client_SYS.Attr_Value_To_Date(date_string_);
   -- No delivery date specified, calculate a default date(!) value
   ELSE
      -- start on a work day
      planned_ship_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(calendar_id_, site_date_time_);      
      Trace_SYS.Field('"start date"', planned_ship_date_);
      
      IF (picking_leadtime_ IS NULL) THEN
         picking_leadtime_ := nvl(Site_Invent_Info_API.Get_Picking_Leadtime(contract_), 0);
      END IF;
      Trace_SYS.Field('picking leadtime', picking_leadtime_);

      -- add picking time
      planned_ship_date_ := Work_Time_Calendar_API.Get_End_Date(calendar_id_, planned_ship_date_, picking_leadtime_);
      Trace_SYS.Field('planned ship date', planned_ship_date_);

      -- fetch next route departure date
      IF (route_id_ IS NOT NULL) THEN
         -- used to check against the route's departure time...
         date_entered_      := to_date(to_char(site_date_, 'YYYY-MM-DD HH24:MI'), 'YYYY-MM-DD HH24:MI');
         -- find the best route departure date
         planned_ship_date_ := Delivery_Route_API.Get_Route_Ship_Date(route_id_, planned_ship_date_, date_entered_, contract_);
         Trace_SYS.Field('route departure date', planned_ship_date_);
         IF (planned_ship_date_ IS NULL) THEN
            Error_SYS.Record_General(lu_name_, 'INVALROUTEDATE: Route departure date is not within current calendar.');
         END IF;

         -- if a time is specified (midnight = no time = anytime) ...
         IF ((to_char(planned_ship_date_, 'HH24:MI') != '00:00') AND (NVL(to_char(address_rec_.delivery_time, 'HH24:MI'), '00:00') != '00:00')) THEN
            -- ... if route departure time is greater than delivery time move delivery date ahead one day
            IF ((delivery_leadtime_ = 0 ) AND (to_char(planned_ship_date_, 'HH24:MI') > to_char(address_rec_.delivery_time, 'HH24:MI'))) THEN
               planned_ship_date_ := planned_ship_date_ + 1;
               Trace_SYS.Field('times differ - move to next day', planned_ship_date_);
            END IF;
         END IF;
      END IF;

      -- Make sure we get a working day on the external transport calendar.
      Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(planned_ship_date_, ext_transport_calendar_id_, TRUNC(planned_ship_date_), 0);
      Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(wanted_delivery_date_, ext_transport_calendar_id_, TRUNC(planned_ship_date_), delivery_leadtime_);

      wanted_delivery_date_ := Cust_Ord_Date_Calculation_API.Apply_Cust_Calendar_To_Date_(customer_no_, cust_calendar_id_, wanted_delivery_date_);
   END IF;

   -- calculate wanted delivery date's time using customer address's delivery time.
   timestamp_ := to_char(wanted_delivery_date_, Report_SYS.datetime_format_);
   Trace_SYS.Field('wanted_delivery_date_', wanted_delivery_date_);

   -- only change time part if wanted delivery time hasn't been entered
   IF (to_char(wanted_delivery_date_, 'HH24:MI') = '00:00') THEN
      Trace_SYS.Field('delivery_time', to_char(address_rec_.delivery_time, 'HH24:MI'));
      IF ((address_rec_.delivery_time IS NOT NULL) AND (to_char(address_rec_.delivery_time, 'HH24:MI') != '00:00')) THEN
         -- replace with the address's time - remove the seconds.
         timestamp_ := replace(timestamp_, '00:00:00', to_char(address_rec_.delivery_time, 'HH24:MI') || ':00');
      END IF;
   END IF;
   wanted_delivery_date_ := to_date(timestamp_, Report_SYS.datetime_format_);
   
   Client_SYS.Set_Item_Value('SHIP_VIA_CODE', ship_via_code_, attr_);
   Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
   Client_SYS.Set_Item_Value('ORDER_ID', order_id_, attr_);
   Client_SYS.Set_Item_Value('ROUTE_ID', route_id_, attr_);
   Client_SYS.Set_Item_Value('FORWARD_AGENT_ID', forward_agent_id_, attr_);
   Client_SYS.Set_Item_Value('BLOCKED_TYPE_DB', Customer_Order_Block_Type_API.DB_NOT_BLOCKED, attr_);
   
   IF Client_SYS.Get_Item_Value('B2B_ORDER_DB', attr_) IS NULL THEN
      Client_SYS.Set_Item_Value('B2B_ORDER_DB', b2b_order_, attr_);  
   END IF;
      
   -- Make sure the attributes in the in parameter attribute string override the defaults
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(in_attr_, ptr_, name_, value_)) LOOP
      -- add all defaults except wanted delivery date
      IF (name_ NOT IN('WANTED_DELIVERY_DATE', 'ORDER_ID')) THEN
         Client_SYS.Set_Item_Value(name_, value_, attr_);
      END IF;
   END LOOP;
END Get_Order_Defaults___;


-- Check_Route_Updates___
--   Checks the possibility of changing the route for a given order
PROCEDURE Check_Route_Updates___ (
   order_no_ IN VARCHAR2 )
IS
   objstate_ CUSTOMER_ORDER_TAB.rowstate%TYPE;
BEGIN
   objstate_ := Get_Objstate(order_no_);
   IF (objstate_ NOT IN ('Planned', 'Released', 'Reserved')) THEN
      Error_SYS.Record_General(lu_name_, 'ROUTEWRONGSTATE: Route ID cannot be changed when order has status ":P1".', Finite_State_Decode__(objstate_));
   ELSIF (Reserve_Customer_Order_API.Any_Pick_List_Printed(order_no_) = 1) AND (objstate_ != 'Released') THEN
      Error_SYS.Record_General(lu_name_, 'ROUTEPRINTED: Route ID cannot be changed when picklist has been printed.');
   END IF;
END Check_Route_Updates___;


-- Check_Consign_Stock_Lines___
--   Checks if the specified ship_addr_no can be used with existing
--   order lines. All lines with the 'Consignemtn Stock'-flag enabled
--   are compared to CustomerConsignmentStock to evaluate if they are valid.
PROCEDURE Check_Consign_Stock_Lines___ (
   order_no_     IN VARCHAR2,
   ship_addr_no_ IN VARCHAR2 )
IS
   dummy_                NUMBER;
   no_consignment_stock_ VARCHAR2(200);

   CURSOR invalid_consignments IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    consignment_stock = 'CONSIGNMENT STOCK'
      AND    NVL(Customer_Consignment_Stock_API.Get_Consignment_Stock(contract, catalog_no,
                customer_no, ship_addr_no_), no_consignment_stock_) = no_consignment_stock_;
BEGIN
   no_consignment_stock_ := Consignment_Stock_API.Decode('NO CONSIGNMENT STOCK');

   OPEN  invalid_consignments;
   FETCH invalid_consignments INTO dummy_;
   IF (invalid_consignments%FOUND) THEN
   CLOSE invalid_consignments;
      Error_SYS.Record_General(lu_name_,
         'INVALID_CONS: The Consignment Stock flag has to be cleared for all order lines before changing the delivery adress.');
   END IF;
   CLOSE invalid_consignments;
END Check_Consign_Stock_Lines___;


-- Construct_Delivery_Time___
--   If customer's ship address has a delivery time, add it to the wanted
--   delivery date when there's no time specified for that value.
FUNCTION Construct_Delivery_Time___ (
   delivery_date_ IN DATE,
   customer_no_   IN VARCHAR2,
   ship_addr_no_  IN VARCHAR2,
   addr_flag_db_  IN VARCHAR2 ) RETURN DATE
IS
   -- Report_SYS.datetime_format_ => 'YYYY-MM-DD HH24:MI:SS';
   time_      DATE;
   timestamp_ VARCHAR2(20);
BEGIN
   IF (delivery_date_ IS NULL) THEN
      RETURN NULL;
   -- IF midnight, the time "hasn't been entered". Retreive default delivery time from customer's delivery address.
   ELSIF (to_char(delivery_date_, 'HH24:MI') = '00:00') THEN
      timestamp_ := to_char(trunc(delivery_date_), Report_SYS.datetime_format_);
      -- single occurence addresses doesn't have a delivery time
      IF (addr_flag_db_ = 'N') THEN
         time_ := Cust_Ord_Customer_Address_API.Get_Delivery_Time(customer_no_, ship_addr_no_);
         IF ((time_ IS NOT NULL) AND (to_char(time_, 'HH24:MI') != '00:00')) THEN
            -- replace with the address's time - remove the seconds in case the user has entered them.
            timestamp_ := replace(timestamp_, '00:00:00', to_char(time_, 'HH24:MI') || ':00');
         END IF;
      END IF;
   ELSE
      timestamp_ := to_char(delivery_date_, Report_SYS.datetime_format_);
   END IF;
   RETURN to_date(timestamp_, Report_SYS.datetime_format_);
END Construct_Delivery_Time___;


-- Validate_Customer_Agreement___
--   Contract, Customer_No and Currency_Code must have the same
--   values on the Customer Order as on the Customer Agreement.
--   Works just like the Is_Valid method in CustomerAgreement.
PROCEDURE Validate_Customer_Agreement___ (
   agreement_id_  IN VARCHAR2,
   contract_      IN VARCHAR2,
   customer_no_   IN VARCHAR2,
   currency_code_ IN VARCHAR2 )
IS
   agreement_rec_ Customer_Agreement_API.Public_Rec;
   site_date_     DATE;
BEGIN
   Trace_SYS.Field('AGREEMENT_ID', agreement_id_);

   IF (agreement_id_ IS NOT NULL) THEN
      agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);
      -- Truncated the date value to day value of the site_date_.
      site_date_ := TRUNC(Site_API.Get_Site_Date(contract_));
      IF NOT (Customer_Agreement_Site_API.Check_Exist(contract_, agreement_id_)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTSAMECUST: Agreement :P1 is not valid for Customer :P2 and site :P3.', agreement_id_, customer_no_, contract_);
      ELSIF (agreement_rec_.customer_no != customer_no_) THEN
         IF Customer_Agreement_API.Validate_Hierarchy_Customer(agreement_id_, customer_no_) = 0 THEN
            Error_SYS.Record_General(lu_name_, 'NOTSAMECUST: Agreement :P1 is not valid for Customer :P2 and site :P3.', agreement_id_, customer_no_, contract_);
         END IF;
      ELSIF (agreement_rec_.currency_code != currency_code_) THEN
         Error_SYS.Record_General(lu_name_, 'NOTSAMECURR: Invalid currency for the Agreement :P1.', agreement_id_);
      ELSIF (agreement_rec_.rowstate != 'Active') THEN
         Error_SYS.Record_General(lu_name_, 'NOTACTIVE: The Agreement :P1 is not Active!', agreement_id_);
      ELSIF (agreement_rec_.valid_from > site_date_) OR (NVL(agreement_rec_.valid_until, site_date_) < site_date_) THEN
         Error_SYS.Record_General(lu_name_, 'NOTVALIDDATE: The Agreement :P1 has an invalid date!', agreement_id_);
      END IF;
   END IF;
END Validate_Customer_Agreement___;


-- Block_Backorder_For_Eso___
--   This method checks whether the order is connected to an External Service Order.
--   If so it will raise an error if the allow backorders is changed.
--   This way it restricts the partially deliveries on External Service Order.
PROCEDURE Block_Backorder_For_Eso___ (
   order_no_ IN VARCHAR2 )
IS
   order_code_ VARCHAR2(20);

   CURSOR get_ext_line IS
      SELECT demand_order_ref1, demand_code
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_;
BEGIN
   FOR ext_line_rec_ IN get_ext_line LOOP
      IF (ext_line_rec_.demand_code = 'PO') THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
            order_code_ := Purchase_Order_API.Get_Order_Code(ext_line_rec_.demand_order_ref1); 
            
            IF (order_code_  = '6') THEN
               Error_SYS.Record_General(lu_name_, 'EXTSERVICEORD: Since the order is connected to an external service order, the value of the backorder option can only be set to either ":P1" or ":P2".', 
                                        Customer_Backorder_Option_API.Decode('NO PARTIAL DELIVERIES ALLOWED'), Customer_Backorder_Option_API.Decode('INCOMPLETE LINES NOT ALLOWED'));
            END IF;
         $ELSE
            NULL;
         $END
      END IF;
   END LOOP;
END Block_Backorder_For_Eso___;


-- Is_Dist_Order_Exist___
--   This will return 1(TRUE) if there is a distribution order with the order_no,
--   else it will return 0(FALSE).
FUNCTION Is_Dist_Order_Exist___ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   do_exist_ NUMBER;
BEGIN
   $IF Component_Disord_SYS.INSTALLED $THEN
      do_exist_ := Distribution_Order_API.Check_Exist(order_no_);         
   $END
   
   RETURN do_exist_;
END Is_Dist_Order_Exist___;


-- Validate_Proj_Connect___
--   Performs all the Customer Order side validations when connecting a project.
PROCEDURE Validate_Proj_Connect___ (
   order_no_   IN VARCHAR2,
   project_id_ IN VARCHAR2 )
IS
   state_            VARCHAR2(32000);
   ordrec_           Public_Rec;
   proj_site_exist_  NUMBER;
   external_service_order_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;

   CURSOR get_lines IS
      SELECT part_ownership, owning_customer_no, activity_seq, project_id, rowstate, demand_code, demand_order_ref1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_;
BEGIN
   IF (project_id_ IS NOT NULL) THEN
      state_ := Get_Objstate(order_no_);
      IF (state_ != 'Planned') THEN
         Error_SYS.Record_General(lu_name_, 'NOTPLAND: Connecting a customer order to a project is only allowed when customer order is in planned state.');
      END IF;

      ordrec_ := Get(order_no_);
      FOR linerec_ IN get_lines LOOP
         IF (linerec_.part_ownership = Part_Ownership_API.DB_SUPPLIER_LOANED) THEN
            Error_SYS.Record_General(lu_name_, 'SUPOWNER:  You are not allowed to connect CO which contain lines with ownership SUPPLIER LOANED');
          ELSIF NOT ((linerec_.part_ownership = Part_Ownership_API.DB_CUSTOMER_OWNED AND linerec_.owning_customer_no = ordrec_.customer_no) OR
                   (linerec_.part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_COMPANY_RENTAL_ASSET, Part_Ownership_API.DB_SUPPLIER_RENTED) AND linerec_.owning_customer_no IS NULL)) THEN
            -- CUSTOWNER error should not be raised for CO created from external service order as no cost is reported by CO
            $IF Component_Purch_SYS.INSTALLED $THEN
               IF ((NVL(linerec_.demand_code, Database_SYS.string_null_) = 'PO') AND (linerec_.demand_order_ref1 IS NOT NULL)) THEN
                  IF (Purchase_Order_API.Get_Order_Code(linerec_.demand_order_ref1) = 6) THEN
                     external_service_order_ := Fnd_Boolean_API.DB_TRUE;
                  END IF;
               END IF;
            $END
            IF (external_service_order_ = Fnd_Boolean_API.DB_FALSE) THEN
               Error_SYS.Record_General(lu_name_, 'CUSTOWNER: This CO contains lines for parts that are owned by a customer other than customer :P1. This CO may not be connected to a project.' ,ordrec_.customer_no);
            END IF;
         ELSIF (linerec_.activity_seq > 0) THEN
            IF (linerec_.project_id != project_id_ AND linerec_.rowstate != 'Cancelled') THEN
               Error_SYS.Record_General(lu_name_, 'LINECONNECTION: Connecting a customer order to a project is not allowed when order lines are connected to activities of other projects.');
            END IF;
         END IF;
      END LOOP;

      $IF Component_Proj_SYS.INSTALLED $THEN
         proj_site_exist_ := Project_Site_API.Project_Site_Exist(project_id_, ordrec_.contract);  

         IF proj_site_exist_ = 0 THEN
            Error_SYS.Record_General(lu_name_,'COSITENOTEXIST: Site :P1 does not exist as project site ', ordrec_.contract);
         END IF;
      $END   
   END IF;
END Validate_Proj_Connect___;


-- Validate_Jinsui_Constraints___
--   Performs validation with the Junsi Invoice Constraints.
--   Checks whether the customer is a jinsui enable customer
--   and also it checks whether the order currency and accounting currency
--   are equal.
PROCEDURE Validate_Jinsui_Constraints___ (
   oldrec_ IN CUSTOMER_ORDER_TAB%ROWTYPE,
   newrec_ IN CUSTOMER_ORDER_TAB%ROWTYPE )
IS
   acc_currency_            VARCHAR2(3);
   order_currency_          VARCHAR2(3);
   company_                 VARCHAR2(20);
   payer_                   CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   temp_customer_           CUSTOMER_ORDER_TAB.customer_no%TYPE;
   rowstate_                CUSTOMER_ORDER_TAB.rowstate%TYPE;
   create_js_invoice_       VARCHAR2(20);
   stmt_                    VARCHAR2(2000);
   company_max_jinsui_amt_  NUMBER := 0;
   
   CURSOR get_order_lines(order_no_ VARCHAR2) IS
      SELECT *
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate NOT IN ('Cancelled');
      
   CURSOR get_charge_lines(order_no_ VARCHAR2) IS
      SELECT sequence_no, line_no, rel_no, line_item_no
      FROM   customer_order_charge_tab
      WHERE  order_no = order_no_;
BEGIN
   company_ := Site_API.Get_Company(newrec_.contract);
   IF newrec_.jinsui_invoice = 'TRUE' THEN
      Company_Finance_API.Get_Accounting_Currency(acc_currency_, company_);
      payer_ := newrec_.customer_no_pay;
      stmt_  := 'BEGIN :create_js_invoice := Js_Customer_Info_API.Get_Create_Js_Invoice(:company, :customer_no); END;';
      IF payer_ IS NOT NULL THEN
         @ApproveDynamicStatement(2006-01-24,JaJalk)
         EXECUTE IMMEDIATE stmt_
            USING OUT create_js_invoice_,
                  IN  company_,
                  IN  payer_;
         temp_customer_ := payer_;
      ELSE
         @ApproveDynamicStatement(2006-01-24,JaJalk)
         EXECUTE IMMEDIATE stmt_
            USING OUT create_js_invoice_,
                  IN  company_,
                  IN  newrec_.customer_no;
         temp_customer_ := newrec_.customer_no;
      END IF;
      create_js_invoice_ := NVL(create_js_invoice_,'FALSE');
      IF (create_js_invoice_ = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'NOJINSUI: You cannot have a Jinsui Order when :P1 is not Jinsui enabled.',temp_customer_);
      END IF;

      order_currency_ := newrec_.currency_code;
      IF order_currency_ != acc_currency_ THEN
         Error_SYS.Record_General(lu_name_, 'NOJINSUINONCURR: You cannot have a Jinsui Order when order currency and accounting currency are not same.');
      END IF;
   END IF;

   rowstate_ := Get_Objstate(newrec_.order_no);
   IF rowstate_ IS NOT NULL THEN
      IF (Has_Invoiced_Lines(newrec_.order_no) AND (oldrec_.jinsui_invoice != newrec_.jinsui_invoice)) THEN
         Error_SYS.Record_General(lu_name_, 'BILLED_JINSUI_ORDER: You cannot enable/disable the Jinsui invoicing since invoices have already been created for customer order :P1.', newrec_.order_no);
      END IF;
      IF (rowstate_ != 'Cancelled') THEN
         IF (oldrec_.jinsui_invoice != newrec_.jinsui_invoice) AND(newrec_.jinsui_invoice = 'TRUE') THEN
            $IF Component_Jinsui_SYS.INSTALLED $THEN
               company_max_jinsui_amt_ := Js_Company_Info_API.Get_Virtual_Inv_Max_Amount(company_);
            $END
            IF (Order_Lines_Exist(newrec_.order_no) != 0) THEN
               FOR order_line_ IN get_order_lines(newrec_.order_no) LOOP
                  CUSTOMER_ORDER_LINE_API.Validate_Jinsui_Constraints__(order_line_, company_max_jinsui_amt_, TRUE);  
               END LOOP;
            END IF;
            IF (Exist_Charges__(newrec_.order_no)!= 0) THEN
               FOR  charge_line_ IN get_charge_lines(newrec_.order_no) LOOP
                  Customer_Order_Charge_API.Validate_Jinsui_Constraints__(newrec_.order_no,
                                                                          charge_line_.sequence_no,
                                                                          charge_line_.line_no,
                                                                          charge_line_.rel_no,
                                                                          charge_line_.line_item_no,
                                                                          company_max_jinsui_amt_,
                                                                          TRUE);
               END LOOP;
            END IF;
         END IF;
      ELSE
         IF oldrec_.jinsui_invoice != newrec_.jinsui_invoice THEN
            Error_SYS.Record_General(lu_name_, 'NOJINSUIUPDATE: You cannot update jinsui flag when the order is :P1',rowstate_);
         END IF;
      END IF;
   END IF;
END Validate_Jinsui_Constraints___;


-- Sales_Contract_Conn_Allowed___
--   Checks whether connecting a sales contract to a customer order is allowed
--   or not.
PROCEDURE Sales_Contract_Conn_Allowed___ (
   order_no_ IN VARCHAR2 )
IS
BEGIN
   IF (Get_Objstate(order_no_) != 'Planned') THEN
      Error_SYS.Record_General(lu_name_, 'ORDERNOTPLANED: Connecting a Customer Order to a Sales Contract is only allowed when Customer Order is in Planned state.');
   END IF;
   IF (Exist_Charges__(order_no_) = 1) THEN
      Error_SYS.Record_General(lu_name_, 'CHARGESEXIST: Cannot connect the Sales Contract. There are charge lines connected to the Customer Order.');
   END IF;

   -- Check for prepayment exists before a sales contract is connected to a customer order.
   IF (Customer_Order_API.Get_Proposed_Prepayment_Amount(order_no_) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_EXISTCON: The Required Prepayment amount exists. Cannot connect this customer order to a Sales Contract.');
   END IF;
END Sales_Contract_Conn_Allowed___;


-- Validate_Sales_Contract___
--   Performs validation when a Customer Order is connected to a Sales Contract.
PROCEDURE Validate_Sales_Contract___ (
   oldrec_ IN CUSTOMER_ORDER_TAB%ROWTYPE,
   newrec_ IN CUSTOMER_ORDER_TAB%ROWTYPE )
IS
   rev_status_ VARCHAR2(200);
   prev_rec_   CUSTOMER_ORDER_TAB%ROWTYPE;
   
   CURSOR get_rec IS
      SELECT order_no, rowstate
      FROM customer_order_tab
      WHERE order_no != newrec_.order_no
      AND sales_contract_no = newrec_.sales_contract_no
      AND contract_rev_seq = newrec_.contract_rev_seq
      AND contract_line_no = newrec_.contract_line_no
      AND contract_item_no = newrec_.contract_item_no ;
BEGIN   
   IF ( newrec_.sales_contract_no IS NOT NULL) THEN
      Sales_Contract_Conn_Allowed___(newrec_.order_no);
      IF (oldrec_.sales_contract_no IS NULL) THEN
         -- add a sales contract to the customer order for the first time
         -- Update the sales contract item with the connected customer order no.
         $IF Component_Conmgt_SYS.INSTALLED $THEN
            Contract_Item_API.Exist(newrec_.sales_contract_no, 
                                    newrec_.contract_rev_seq, 
                                    newrec_.contract_line_no, 
                                    newrec_.contract_item_no);
            
            Contract_Item_API.Connect_Customer_Order(newrec_.sales_contract_no, 
                                                     newrec_.contract_rev_seq, 
                                                     newrec_.contract_line_no, 
                                                     newrec_.contract_item_no, 
                                                     newrec_.order_no);           
         $ELSE
             NULL;             
         $END
      ELSE
         -- Update the sales contract item with the connected customer order no and
         -- delete the connected customer order no from the previous sales contract item.
         $IF Component_Conmgt_SYS.INSTALLED $THEN
            Contract_Item_API.Exist(newrec_.sales_contract_no, 
                                    newrec_.contract_rev_seq, 
                                    newrec_.contract_line_no, 
                                    newrec_.contract_item_no);

            Contract_Item_API.Connect_Customer_Order(newrec_.sales_contract_no,
                                                     newrec_.contract_rev_seq,
                                                     newrec_.contract_line_no,
                                                     newrec_.contract_item_no,
                                                     newrec_.order_no);
            
            rev_status_ := Contract_Revision_API.Get_Objstate(oldrec_.sales_contract_no,
                                                              oldrec_.contract_rev_seq);

            IF (rev_status_ != 'Obsolete')  THEN
               Contract_Item_API.Remove_Customer_Order_No(oldrec_.sales_contract_no,
                                                          oldrec_.contract_rev_seq,
                                                          oldrec_.contract_line_no,
                                                          oldrec_.contract_item_no);
            END IF;
         $ELSE
            NULL;             
         $END
      END IF;
      -- Remove the sales contract from previous customer order.
      FOR rec_ IN get_rec LOOP
         IF(rec_.rowstate IN ('PartiallyDelivered', 'Delivered', 'Invoiced')) THEN
            Error_SYS.Record_General(lu_name_, 'INVOICEORDEREXIST: The contract line item is already connected to another customer order which is :P1.', Finite_State_Decode__(rec_.rowstate));
         ELSIF(rec_.rowstate != 'Cancelled') THEN
            prev_rec_ := Get_Object_By_Keys___(rec_.order_no);
            prev_rec_.sales_contract_no := NULL;
            prev_rec_.contract_rev_seq := NULL;
            prev_rec_.contract_line_no := NULL;
            prev_rec_.contract_item_no := NULL;
            Modify___(prev_rec_);             
         END IF;
      END LOOP;
   ELSE
      -- Delete the connected customer order no from the sales contract item.
      $IF Component_Conmgt_SYS.INSTALLED $THEN
         IF (Contract_Item_API.Get_Customer_Order_No(oldrec_.sales_contract_no, 
                                                 oldrec_.contract_rev_seq, 
                                                 oldrec_.contract_line_no, 
                                                 oldrec_.contract_item_no) = oldrec_.order_no) THEN
            Contract_Item_API.Remove_Customer_Order_No(oldrec_.sales_contract_no,
                                                       oldrec_.contract_rev_seq,
                                                       oldrec_.contract_line_no,
                                                       oldrec_.contract_item_no);   
         END IF;
      $ELSE
          NULL;    
      $END
   END IF;
END Validate_Sales_Contract___;


-- Validate_Proposed_Prepay___
--   When inserting or updating values for required prepayment amount or
--   the percentage this validation method will be called.
PROCEDURE Validate_Proposed_Prepay___ (
   order_no_          IN VARCHAR2,
   prepayment_amount_ IN NUMBER )
IS
   objstate_              CUSTOMER_ORDER_TAB.rowstate%TYPE;
   company_               VARCHAR2(20);
   dummy_                 VARCHAR2(2);
   order_type_            CUSTOMER_ORDER_TAB.order_id%TYPE;
   customer_order_rec_    Customer_Order_API.Public_Rec;
   com_invoice_info_rec_  Company_Invoice_Info_API.Public_Rec;
   payment_amt_for_order_ NUMBER := 0;
   external_tax_calc_method_  VARCHAR2(50);

   CURSOR get_self_billing IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    self_billing = 'SELF BILLING';

   CURSOR get_stage_billing_line IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    staged_billing = 'STAGED BILLING';
BEGIN
   customer_order_rec_ := Customer_Order_API.Get(order_no_);
   company_            := Site_API.Get_Company(customer_order_rec_.contract);
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   -- Check for required prepayment amount greater than the customer order gross amount including charges
   IF (NVL(Customer_Order_API.Get_Gross_Amt_Incl_Charges(order_no_), 0) < prepayment_amount_ ) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_GRE: The Required Prepayment cannot be greater than the customer order gross amount.');
   END IF;

   -- Required prepayment amount should be greater than zero ( cannot be deleted )
   -- Required amount should be larger than the connected payments
   -- Cannot modify Required Prepayment when prepayment_approved = 'TRUE'
   IF (customer_order_rec_.prepayment_approved = 'FALSE') THEN
      IF (NVL(prepayment_amount_, 0) < 0 ) THEN
         Error_SYS.Record_General(lu_name_, 'PREPAYM_ZERO: The Required Prepayment can not be negative.');
      ELSE
         $IF Component_Payled_SYS.INSTALLED $THEN
            payment_amt_for_order_ := On_Account_Ledger_Item_API.Get_Payment_Amt_For_Order_Ref(company_, customer_order_rec_.customer_no, order_no_);

            IF (payment_amt_for_order_ > prepayment_amount_) THEN
               Error_SYS.Record_General(lu_name_, 'PREPAY_GREATER: The Required Prepayment cannot be less than the paid amount.');
            END IF;
         $ELSE
             NULL;    
         $END
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'PREPAY_CANNOT_MOD: The Required Prepayment amount is approved, and cannot be modified.');
   END IF;

   -- Customer order is in status 'Delivered','PartiallyDelivered' or 'Invoiced'
   objstate_ := Get_Objstate(order_no_);
   IF (objstate_ IN ('Delivered', 'Invoiced', 'Cancelled') ) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_NOT_IN_OBJ: Cannot modify Required Prepayment amount when the order is :P1.', objstate_);
   END IF;

   
   IF ((Exists_One_Tax_Code_Per_Line(order_no_) = 'FALSE' AND prepayment_amount_ > 0) OR external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAYMENTMULTITAX: Prepayment based invoicing functionality can only be executed for customer order lines with a single tax code.');
   END IF;

   -- When the customer order is delivery confirmed
   IF ((Customer_Order_API.Get_Confirm_Deliveries_Db(order_no_) = 'TRUE') AND (Company_Order_Info_API.Get_Allow_With_Deliv_Conf_Db(company_) = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_DELCONFIRM: The customer order has requested to confirm deliveries. You cannot enter a required prepayment amount greater than zero when company :P1 does not allow using delivery confirmation with prepayment invoicing.', company_);
   END IF;

   -- When the customer order has self billing lines
   OPEN  get_self_billing;
   FETCH get_self_billing INTO dummy_;
   IF (get_self_billing%FOUND) THEN
      CLOSE get_self_billing;
      Error_SYS.Record_General(lu_name_, 'PREPAY_SELFBILL: The customer order has self billing invoices created. Cannot enter a Required Prepayment amount greater than zero.');
   END IF;
   CLOSE get_self_billing;

   -- When the customer order is connected to a staged billing template
   IF (customer_order_rec_.staged_billing = 'STAGED BILLING') THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_STABILL: The customer order has Staged Billing Template connected. Cannot enter a Required Prepayment amount greater than zero.');
   END IF;

   -- When a customer order line is connected to a staged billing profile
   OPEN  get_stage_billing_line;
   FETCH get_stage_billing_line INTO dummy_;
   IF (get_stage_billing_line%FOUND) THEN
      CLOSE get_stage_billing_line;
      Error_SYS.Record_General(lu_name_, 'PREPAY_BILLPROF: The customer order has lines with Staged Billing Profiles. Cannot enter a Required Prepayment amount greater than zero.');
   END IF;
   CLOSE get_stage_billing_line;

   -- When the customer order type is 'SEO'
   order_type_ := customer_order_rec_.order_id;
   IF (order_type_ = 'SEO' AND prepayment_amount_ > 0) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_TYPE_DIFF: The customer order type is SEO. Cannot enter a Required Prepayment amount greater than zero.');
   END IF;

   -- When a sales contract is connected to customer order
   IF (customer_order_rec_.sales_contract_no IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_SALESCONN: The customer order is connected to Sales Contract :P1. Cannot enter a Required Prepayment amount greater than zero.', customer_order_rec_.sales_contract_no);
   END IF;

   -- When a work order is connected to customer order
   IF (Customer_Order_API.Get_Sm_Connection_Db(order_no_) = 'CONNECTED') THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_SMCONN: The customer order has SM connections. Cannot enter a Required Prepayment amount greater than zero.');
   END IF;
END Validate_Proposed_Prepay___;


-- Validate_Proj_Disconnect___
--   Performs all the Customer Order side validations when disconnecting a project.
PROCEDURE Validate_Proj_Disconnect___ (
   order_no_   IN VARCHAR2,
   project_id_ IN VARCHAR2 )
IS
   state_            VARCHAR2(32000);
   proj_unique_sale_ VARCHAR2(5);

   CURSOR get_lines IS
      SELECT *
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    project_id = project_id_;
BEGIN
   state_ := Get_Objstate(order_no_);
   IF (state_ != 'Planned') THEN
      Error_SYS.Record_General(lu_name_, 'NOTPLANDISCON: Disconnecting a customer order to a project is only allowed when customer order is in planned state.');
   END IF;

   $IF Component_Proj_SYS.INSTALLED $THEN
      proj_unique_sale_ := Project_API.Get_Proj_Unique_Sale_Db(project_id_);
      
      IF (proj_unique_sale_= 'TRUE') THEN
         FOR linerec_ IN get_lines LOOP
            Error_SYS.Record_General(lu_name_, 'UNIQPROJLINEEXIST: Project :P1 cannot be deleted when project is marked for Project Unique Billing and customer order lines are connected to activities of the same project.', project_id_);
         END LOOP;
      END IF;
   $END
END Validate_Proj_Disconnect___;


FUNCTION Get_Ord_Total_Tax_Amount___ (
   order_no_      IN VARCHAR2,
   exclude_item_  IN BOOLEAN) RETURN NUMBER
IS
   total_tax_amount_  NUMBER := 0;
   next_line_tax_     NUMBER := 0;
   ordrec_            CUSTOMER_ORDER_TAB%ROWTYPE;
   company_           VARCHAR2(20);
   rounding_          NUMBER;
   fnd_boolean_true_  VARCHAR2(5);
   company_pay_tax_   VARCHAR2(20);
   tax_paying_party_  VARCHAR2(20);
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, currency_rate, price_conv_factor
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_item_no <= 0
      AND   rowstate != 'Cancelled'
      AND ((tax_liability_type != 'EXM') AND (free_of_charge != fnd_boolean_true_  OR tax_paying_party_ != company_pay_tax_));

   CURSOR get_lines_excl_item IS
      SELECT line_no, rel_no, line_item_no, currency_rate, price_conv_factor
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND   line_item_no <= 0
      AND   rowstate != 'Cancelled'
      AND   charged_item != 'ITEM NOT CHARGED'
      AND   exchange_item !='EXCHANGED ITEM'
      AND ((tax_liability_type != 'EXM') AND (free_of_charge != fnd_boolean_true_  OR tax_paying_party_ != company_pay_tax_));
BEGIN
   ordrec_   := Get_Object_By_Keys___(order_no_);
   company_  := Site_API.Get_Company(ordrec_.contract);
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_,ordrec_.currency_code);
   tax_paying_party_ := Customer_Order_API.Get_Free_Of_Chg_Tax_Pay_Par_Db(order_no_);
   company_pay_tax_  := Tax_Paying_Party_API.DB_COMPANY;
   fnd_boolean_true_ := Fnd_Boolean_API.DB_TRUE;
   IF (exclude_item_) THEN
      FOR next_line_ IN get_lines_excl_item LOOP
         next_line_tax_ := Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_,
                                                                             next_line_.line_no,
                                                                             next_line_.rel_no,
                                                                             next_line_.line_item_no,
                                                                             rounding_);

         total_tax_amount_ := total_tax_amount_ + next_line_tax_;
      END LOOP;
   ELSE
      FOR next_line_ IN get_lines LOOP
         next_line_tax_ := Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_,
                                                                             next_line_.line_no,
                                                                             next_line_.rel_no,
                                                                             next_line_.line_item_no,
                                                                             rounding_);

         total_tax_amount_ := total_tax_amount_ + next_line_tax_;
      END LOOP;
   END IF;

   total_tax_amount_ := ROUND(total_tax_amount_, rounding_);
   RETURN NVL(total_tax_amount_, 0);
END Get_Ord_Total_Tax_Amount___;


FUNCTION Get_Total_Sale_Price___ (
   order_no_     IN VARCHAR2,
   exclude_item_ IN BOOLEAN) RETURN NUMBER
IS
   total_sale_price_ NUMBER := 0;
   
BEGIN
   IF (exclude_item_ ) THEN
      total_sale_price_ := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, NULL, NULL, NULL, NULL, 'TRUE');   
   ELSE
      total_sale_price_ := Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, NULL, NULL, NULL, NULL, 'FALSE');
   END IF;

   RETURN NVL(total_sale_price_, 0);
END Get_Total_Sale_Price___;


FUNCTION Get_Tot_Sale_Price_Incl_Tax___ (
   order_no_     IN VARCHAR2,
   exclude_item_ IN BOOLEAN) RETURN NUMBER
IS
   total_sale_price_incl_tax_ NUMBER := 0;

BEGIN
   IF (exclude_item_ ) THEN
      -- Retrieve the total sale price for the specified order excluding, Charged Item and Exchange Item cost
      total_sale_price_incl_tax_ :=  Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_, NULL, NULL, NULL, 'TRUE') ;   
   ELSE
      total_sale_price_incl_tax_ :=  Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_) ;
   END IF;

   RETURN NVL(total_sale_price_incl_tax_, 0);
END Get_Tot_Sale_Price_Incl_Tax___;


-- Get_Revision_Status___
--   This method returns whether the part configuration revision used to create the
--   configuration is valid for the planned delivery date.
FUNCTION Get_Revision_Status___ (
   part_no_               IN VARCHAR2,
   configuration_id_      IN VARCHAR2,
   planned_delivery_date_ IN DATE ) RETURN VARCHAR2
IS
   revision_status_ VARCHAR2(50) := NULL;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      IF NVL(configuration_id_, '*') != '*' THEN 
         revision_status_ := Config_Manager_API.Validate_Effective_Revision(part_no_, configuration_id_, planned_delivery_date_);   
   END IF;
   $END
   RETURN revision_status_;
END Get_Revision_Status___;

PROCEDURE Check_Service_Code_Ref___ (
   newrec_ IN OUT NOCOPY customer_order_tab%ROWTYPE )
IS
   company_       VARCHAR2(20);
BEGIN
   company_      := Site_API.Get_Company(newrec_.contract);
   Customer_Service_Code_API.Exist_Db(company_,newrec_.customer_no,'CUSTOMER',newrec_.service_code);
END Check_Service_Code_Ref___;

PROCEDURE Modify_Connected_Order___ (
   oldrec_         IN CUSTOMER_ORDER_TAB%ROWTYPE,
   newrec_         IN CUSTOMER_ORDER_TAB%ROWTYPE, 
   change_request_ IN VARCHAR2)
IS
   customer_po_no_       CUSTOMER_ORDER_TAB.customer_po_no%TYPE;
   check_ipt_not_exists_ VARCHAR2(5):= 'FALSE';
   replicate_label_note_ VARCHAR2(5):= 'FALSE';
BEGIN
   IF ((NVL(oldrec_.label_note, Database_Sys.string_null_) != NVL(newrec_.label_note, Database_Sys.string_null_)) 
       OR (oldrec_.print_delivered_lines != newrec_.print_delivered_lines)
       OR (NVL(oldrec_.customer_po_no, Database_Sys.string_null_) != NVL(newrec_.customer_po_no, Database_Sys.string_null_)) 
       OR (NVL(oldrec_.language_code, Database_Sys.string_null_) != NVL(newrec_.language_code, Database_Sys.string_null_)) 
       OR (oldrec_.backorder_option != newrec_.backorder_option) 
       OR ((NVL(oldrec_.cust_ref, Database_Sys.string_null_) != NVL(newrec_.cust_ref, Database_Sys.string_null_)) AND (Check_No_Def_Info_Src_Lines___(newrec_) = 'TRUE'))) THEN
      -- Needs to update the PO header if customer_po_no is modified, since it is also stored in PO.
      IF (NVL(oldrec_.customer_po_no, Database_Sys.string_null_) != NVL(newrec_.customer_po_no, Database_Sys.string_null_)) THEN
         customer_po_no_ := newrec_.customer_po_no;
      END IF;
      IF ((oldrec_.backorder_option != newrec_.backorder_option) OR (oldrec_.print_delivered_lines != newrec_.print_delivered_lines)) THEN
         check_ipt_not_exists_ := 'TRUE';
      END IF;
      IF (NVL(oldrec_.label_note, Database_Sys.string_null_) != NVL(newrec_.label_note, Database_Sys.string_null_)) THEN
         replicate_label_note_ := 'TRUE';
      END IF;
      -- trigger replication and update of pegged orders.
      Connect_Customer_Order_API.Modify_Connected_Order(newrec_.order_no, customer_po_no_, change_request_, check_ipt_not_exists_, replicate_label_note_);
   END IF;      
END Modify_Connected_Order___;


-- Modify_Line_Tax_Id_Details___
--   This method will update all the tax_id_nos and tax id validated dates of the
--   customer order lines having thedemand_code != IPD.
--   this will be called when the header document address id gets changed
PROCEDURE Modify_Line_Tax_Id_Details___ (
   order_no_              IN VARCHAR2,
   tax_id_no_             IN VARCHAR2,
   tax_id_validated_date_ IN DATE)
IS 
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    NVL(demand_code,Database_SYS.string_null_) != 'IPD';
BEGIN
   FOR rec_ IN get_lines LOOP
      CUSTOMER_ORDER_LINE_API.Modify_Tax_Id_No_Details__(order_no_, rec_.line_no , rec_.rel_no, rec_.line_item_no, tax_id_no_, tax_id_validated_date_);
   END LOOP;
END Modify_Line_Tax_Id_Details___;


-- Generate_Co_Number___
--   This method generates the next sequence of the CO number using the authorize
--   group. It also checks if the generated CO number already exists in DO. If so,
--   another CO number is generated.
PROCEDURE Generate_Co_Number___ (
   order_no_       OUT VARCHAR2,
   authorize_code_ IN  VARCHAR2,
   source_order_   IN  VARCHAR2 )
IS
   authorize_group_ VARCHAR2(1) := NULL;
   exist_           BOOLEAN := TRUE;
BEGIN
   authorize_group_ := Order_Coordinator_API.Get_Authorize_Group(authorize_code_);
   WHILE (exist_) LOOP
      -- Added 'WS' to the IF block to identify when CO creation is initiated by external web service and call the autonomous method.
      -- Note: Checks whether the customer order is sourced from Sales Quotation (CQ), Work Order (WO) or Incoming Customer Order (ICO),
      --       Component method of site is 'Customer Order' flows so that by using autonomous transaction system will release the order coordinator group tab lock.
      IF source_order_ IN ('CQ', 'ICO', 'WO', 'CS', 'PCO', 'WS') THEN
         Order_Coordinator_Group_API.Incr_Cust_Order_No_Autonomous(order_no_, authorize_group_);
      ELSE
         Order_Coordinator_Group_API.Increase_Cust_Order_No(order_no_, authorize_group_);
      END IF;
      order_no_ := authorize_group_ || Order_Coordinator_Group_API.Get_Cust_Order_No(authorize_group_);
      
      -- Check for the existing Customer Order No's and Distribution Order No's
      exist_ := (Check_Exist___(order_no_)) OR
                (Is_Dist_Order_Exist___(order_no_) = 1) OR
                (External_Customer_Order_API.Customer_Order_No_Exists(order_no_));
   END LOOP;
END Generate_Co_Number___;


@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
   old_state_ VARCHAR2(30);
BEGIN
   old_state_ := Get_Objstate(rec_.order_no);
   IF (NVL(old_state_, ' ') = state_) THEN
      super(rec_, state_);
   ELSE      
      -- If state is changed FROM/TO 'Invoiced'   invoiced_closed_date should be updated accordingly.
      IF old_state_ != 'Invoiced' AND state_ = 'Invoiced' THEN
         rec_.invoiced_closed_date := Site_API.Get_Site_Date(rec_.contract);
      ELSIF old_state_ = 'Invoiced' AND state_ != 'Invoiced' THEN
         rec_.invoiced_closed_date := NULL;
      END IF;
      -- Added objstate check to avoid "Modified by another user..." error when modifying the order lines.
      rec_.rowversion := sysdate;
      UPDATE customer_order_tab
         SET rowstate = state_,
             rowversion = rec_.rowversion,
             invoiced_closed_date = rec_.invoiced_closed_date
         WHERE order_no = rec_.order_no
         AND NVL(rowstate, ' ') != state_;
      rec_.rowstate := state_;
   END IF;
    
   Cust_Order_Event_Creation_API.Order_Status_Change(rec_.order_no, state_);

   IF (rec_.case_id IS NOT NULL) AND (rec_.rowstate != 'Planned') THEN
   $IF Component_Callc_SYS.INSTALLED $THEN
       Cc_Case_Task_API.Handover_Status_Change(rec_.order_no, 'CUSTOMER_ORDER', rec_.rowstate);         
   $ELSE
       NULL;          
   $END
   END IF;
   rec_ := Get_Object_By_Keys___(rec_.order_no);
END Finite_State_Set___;


@Override
PROCEDURE Finite_State_Init___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(rec_, attr_);
   IF (rec_.rowstate = 'Planned') THEN
      Cust_Order_Event_Creation_API.Order_Status_Change(rec_.order_no, rec_.rowstate);
   END IF;   
END Finite_State_Init___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_              CUSTOMER_ORDER_TAB.contract%TYPE := User_Default_API.Get_Contract;
   authorize_code_        CUSTOMER_ORDER_TAB.authorize_code%TYPE := User_Default_API.Get_Authorize_Code;
   use_pre_ship_del_note_ CUSTOMER_ORDER_TAB.use_pre_ship_del_note%TYPE := 'FALSE';
BEGIN
   super(attr_);
   IF (contract_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('COMPANY', Site_API.Get_Company(contract_), attr_);
      Client_SYS.Add_To_Attr('SUPPLY_COUNTRY', Company_Site_API.Get_Country(contract_), attr_);
      
     use_pre_ship_del_note_ :=  Site_Discom_Info_API.Get_Use_Pre_Ship_Del_Note_Db(contract_);
   END IF;
   IF (authorize_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('AUTHORIZE_CODE', authorize_code_, attr_);
   END IF;
   -- these values are set in Get_Order_Defaults___, but need to be displayed in the client also
   Client_SYS.Add_To_Attr('GRP_DISC_CALC_FLAG_DB', 'N', attr_);   
   Client_SYS.Add_To_Attr('ORDER_CODE', 'O', attr_);
   Client_SYS.Add_To_Attr('ORDER_CONF_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('PICK_LIST_FLAG_DB', 'Y', attr_);
   Client_SYS.Add_To_Attr('ADDR_FLAG_DB', 'N', attr_);
   Client_SYS.Add_To_Attr('STAGED_BILLING_DB', 'NOT STAGED BILLING', attr_);
   Client_SYS.Add_To_Attr('SM_CONNECTION_DB', 'NOT CONNECTED', attr_);
   Client_SYS.Add_To_Attr('SCHEDULING_CONNECTION_DB', 'NOT SCHEDULE', attr_);
   Client_SYS.Add_To_Attr('ADDITIONAL_DISCOUNT', '0', attr_);   
   Client_SYS.Add_To_Attr('RELEASED_FROM_CREDIT_CHECK_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('PROPOSED_PREPAYMENT_AMOUNT', '0', attr_);
   Client_SYS.Add_To_Attr('PREPAYMENT_APPROVED_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NOTE_DB', use_pre_ship_del_note_, attr_);
   Client_SYS.Add_To_Attr('APPLY_FIX_DELIV_FREIGHT_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('BLOCKED_TYPE_DB', Customer_Order_Block_Type_API.DB_NOT_BLOCKED, attr_);
   -- gelr: outgoing_fiscal_note, begin
   Client_SYS.Add_To_Attr('FINAL_CONSUMER_DB', Fnd_Boolean_API.DB_FALSE, attr_);
   -- gelr: outgoing_fiscal_note, end
   -- gelr:localization_control_center, begin
   Client_SYS.Add_To_Attr('ENABLED_LCC_PARAMS', Company_Localization_Info_API.Get_Enabled_Params_per_Company(Site_API.Get_Company(contract_)), attr_);
   -- gelr:localization_control_center, end
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   company_                VARCHAR2(20);
   source_order_           VARCHAR2(5);
   default_charges_        VARCHAR2(5);   
   base_curr_code_         VARCHAR2(3);
   delivery_country_       VARCHAR2(2);
   old_note_id_            NUMBER;   
   currency_rounding_      NUMBER;
   rounding_               NUMBER;
   tax_info_exists_        BOOLEAN := TRUE;   
   cust_contract_          CUSTOMER_ORDER_TAB.contract%TYPE; 
   tax_liability_type_db_  VARCHAR2(20);
   representative_id_      PERSON_INFO_TAB.person_id%TYPE;
   cust_tax_liab_type_db_  VARCHAR2(20); 
   parent_customer_        VARCHAR2(20);
   credit_block_result_    VARCHAR2(20);
   credit_attr_            VARCHAR2(2000);

BEGIN
   company_      := Site_API.Get_Company(newrec_.contract);
   source_order_ := Client_SYS.Get_Item_Value('SOURCE_ORDER', attr_); 

   IF (newrec_.order_no IS NULL) THEN
      -- Code that generates a new CO number now resides in method Generate_Co_Number___
      Generate_Co_Number___(newrec_.order_no, newrec_.authorize_code, source_order_);
      Client_SYS.Add_To_Attr('ORDER_NO', newrec_.order_no, attr_);
   END IF;

   newrec_.date_entered      := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.pre_accounting_id := Pre_Accounting_API.Get_Next_Pre_Accounting_Id;
   old_note_id_              := newrec_.note_id;

   IF (source_order_ = 'DO') THEN
      -- Note: IF the originator is a distribution order then copy the same note id.
      $IF Component_Disord_SYS.INSTALLED $THEN
         newrec_.note_id := Distribution_Order_API.Get_Note_Id(newrec_.order_no);            
      $ELSE
         NULL;
      $END
   ELSE
      newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   END IF;

   IF (old_note_id_ IS NOT NULL ) THEN
      Document_Text_API.Copy_All_Note_Texts(old_note_id_, newrec_.note_id);
   END IF;

   default_charges_ := Client_SYS.Get_Item_Value('DEFAULT_CHARGES', attr_);
   IF ( default_charges_ IS NULL ) THEN
       default_charges_ := 'TRUE';
   END IF;

   Client_SYS.Add_To_Attr('DATE_ENTERED', newrec_.date_entered, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
   Client_SYS.Add_To_Attr('PRE_ACCOUNTING_ID', newrec_.pre_accounting_id, attr_);
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', newrec_.wanted_delivery_date, attr_);
   Client_SYS.Add_To_Attr('CONFIRM_DELIVERIES_DB', newrec_.confirm_deliveries, attr_);
   Client_SYS.Add_To_Attr('CHECK_SALES_GRP_DELIV_CONF_DB', newrec_.check_sales_grp_deliv_conf, attr_);
   Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF_DB', newrec_.delay_cogs_to_deliv_conf, attr_);

   base_curr_code_ := Company_Finance_API.Get_Currency_Code(company_);
   rounding_       := Currency_Code_API.Get_Currency_Rounding(company_, base_curr_code_);
   Client_SYS.Add_To_Attr('ROUNDING', rounding_, attr_);
   IF (base_curr_code_ != newrec_.currency_code) THEN
      currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, newrec_.currency_code);
   ELSE
      currency_rounding_ := rounding_;
   END IF;
   Client_SYS.Add_To_Attr('CURRENCY_ROUNDING', currency_rounding_, attr_);
   Client_SYS.Add_To_Attr('USE_PRE_SHIP_DEL_NODE_DB', newrec_.use_pre_ship_del_note, attr_);
   Client_SYS.Add_To_Attr('PICK_INVENTORY_TYPE_DB', newrec_.pick_inventory_type, attr_);
   
   IF (newrec_.customer_tax_usage_type IS NULL) THEN
      newrec_.customer_tax_usage_type := Customer_Info_API.Get_Customer_Tax_Usage_Type(newrec_.customer_no);
      Client_SYS.Add_To_Attr('CUSTOMER_TAX_USAGE_TYPE',newrec_.customer_tax_usage_type, attr_);
   END IF;

   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF (newrec_.main_representative_id IS NULL) THEN
         newrec_.main_representative_id := rm_acc_representative_api.Get_Eligible_Representative(newrec_.customer_no);
      END IF;
         Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', newrec_.main_representative_id, attr_);
   $END

   super(objid_, objversion_, newrec_, attr_);

   $IF Component_Rmcom_SYS.INSTALLED $THEN
      IF (newrec_.main_representative_id IS NOT NULL) THEN
         -- Insert main representative. 
         Bus_Obj_Representative_API.New_Bus_Obj_Representative(newrec_.order_no, Business_Object_Type_API.DB_CUSTOMER_ORDER, newrec_.main_representative_id, Fnd_Boolean_API.DB_TRUE);   
      END IF;
      -- If logged on user is not representative on the newly created object - add him or her
      -- If this is not done and the only privilege the user has for this object is a shared privilege, he or she will not have access to the created object
      -- Only if the user is a representative add as representative
      representative_id_ := Person_Info_API.Get_Id_For_User(Fnd_Session_API.Get_Fnd_User);
      IF Business_Representative_API.Exists(representative_id_) = FALSE THEN
         representative_id_ := NULL;
      END IF;
      IF representative_id_ IS NOT NULL AND Bus_Obj_Representative_API.Exists_Db(newrec_.order_no, Business_Object_Type_API.DB_CUSTOMER_ORDER, representative_id_) = FALSE THEN
         Bus_Obj_Representative_API.New_Bus_Obj_Representative(newrec_.order_no, Business_Object_Type_API.DB_CUSTOMER_ORDER, representative_id_, Fnd_Boolean_API.DB_FALSE);
      END IF;
   $END
   
   IF (default_charges_ = 'TRUE') THEN
      IF (source_order_ = 'ICO') THEN
         Client_SYS.Add_To_Attr('DEFAULT_CHARGES', 'TRUE', attr_);
      ELSE
         Customer_Order_Charge_API.Copy_From_Customer_Charge(newrec_.customer_no, newrec_.contract, newrec_.order_no);        
      END IF;
   END IF;
   Customer_Order_History_API.New(newrec_.order_no);
   
   $IF Component_Crm_SYS.INSTALLED $THEN
      Crm_Cust_Info_History_API.New_Event(customer_id_   => newrec_.customer_no, 
                                          event_type_db_ => Rmcom_Event_Type_API.DB_ORDER, 
                                          info_          => Language_SYS.Translate_Constant(lu_name_, 'ORDER_CREATED_CUSTOMER: Customer Order :P1 has been created for the customer.', NULL, newrec_.order_no), 
                                          ref_id_        => newrec_.order_no, 
                                          ref_type_db_   => Business_Object_Type_API.DB_CUSTOMER_ORDER, 
                                          action_        => 'I');      
   $END
   
   Check_Customer_Credit_Blocked(credit_block_result_, credit_attr_, newrec_.order_no);
   IF Client_SYS.Item_Exist('PARENT_IDENTITY', credit_attr_) THEN
      parent_customer_ := Client_SYS.Get_Item_Value('PARENT_IDENTITY', credit_attr_); 
   END IF;
   
   IF credit_block_result_ = 'CUSTOMER_BLOCKED' THEN      
      IF parent_customer_ IS NULL  THEN
         Client_SYS.Add_Info(lu_name_, 'CREDIT_BLOCKED: The customer is credit blocked. The order will be credit blocked');
      ELSE
         Client_SYS.Add_Info(lu_name_, 'CREDITBLOCKEDPAR: The parent :P1 of the customer is credit blocked. The order will be credit blocked', parent_customer_);
      END IF; 
   ELSIF credit_block_result_ = 'PAY_CUSTOMER_BLOCKED' THEN
      IF parent_customer_ IS NULL  THEN 
         Client_SYS.Add_Info(lu_name_, 'CREDITPAYBLOCKED: The paying customer :P1 is credit blocked. The order will be credit blocked', newrec_.customer_no_pay);
      ELSE
         Client_SYS.Add_Info(lu_name_, 'CREDITPAYBLOCKEDPAR: The parent :P1 of the paying customer is credit blocked. The order will be credit blocked', parent_customer_);
      END IF;
   END IF;

   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      cust_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(newrec_.customer_no);
      IF (NVL(Site_API.Get_Company(cust_contract_), ' ') != company_) THEN
         IF (Customer_Delivery_Tax_Info_API.Check_Exist(newrec_.customer_no, newrec_.ship_addr_no, company_, newrec_.supply_country) = 'FALSE') THEN
            tax_info_exists_ := FALSE;
            Client_SYS.Add_Info(lu_name_, 'NOTAXFORADDR: Customer Tax Information has not been defined for the delivery address.');
          END IF;
      END IF;
   END IF;

   cust_tax_liab_type_db_ := Tax_Handling_Util_API.Get_Cust_Tax_Liability_Type_Db(newrec_.customer_no, 
                                                                                  newrec_.ship_addr_no, 
                                                                                  company_, 
                                                                                  newrec_.supply_country, 
                                                                                  Customer_Info_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no));
   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability , Customer_Order_Address_API.Get_Address_Country_Code(newrec_.order_no));
   IF tax_info_exists_ THEN
      IF (tax_liability_type_db_ = 'EXM' AND cust_tax_liab_type_db_ = 'TAX') THEN
         Client_SYS.Add_Info(lu_name_, 'VAT_DIFF1: A tax liability with Exempt liability type is used although the customer is liable to pay tax');
      ELSIF (tax_liability_type_db_ != 'EXM' AND cust_tax_liab_type_db_ = 'EXM') THEN
         IF(newrec_.tax_liability = 'TAX' OR newrec_.tax_liability = 'EXEMPT') THEN
            delivery_country_ := '*';
         ELSE
            delivery_country_ := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
         END IF;
         Client_SYS.Add_Info(lu_name_, 'VAT_DIFF2: A tax liability with :P1 liability type is used although the customer is not liable to pay tax', Tax_Liability_Type_API.Decode(Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, delivery_country_)));
      END IF;
   END IF;

   IF (newrec_.cust_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.cust_calendar_id);
      Cust_Ord_Date_Calculation_API.Check_Date_On_Cust_Calendar_(newrec_.customer_no, newrec_.cust_calendar_id, newrec_.wanted_delivery_date, 'WANTED');
   END IF;

   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
      Cust_Ord_Date_Calculation_API.Chk_Date_On_Ext_Transport_Cal(newrec_.ext_transport_calendar_id, newrec_.wanted_delivery_date, 'WANTED');
   END IF;
   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_ORDER_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   company_                    VARCHAR2(20);
   cust_contract_              CUSTOMER_ORDER_TAB.contract%TYPE;
   provisional_price_db_       VARCHAR2(20);
   lineattr_                   VARCHAR2(2000);
   sale_unit_price_            NUMBER;
   unit_price_incl_tax_        NUMBER;
   base_sale_unit_price_       NUMBER;
   base_unit_price_incl_tax_   NUMBER;
   currency_rate_              NUMBER;
   discount_                   NUMBER;
   price_source_               VARCHAR2(200);
   price_source_id_            VARCHAR2(25);
   part_price_                 NUMBER;
   line_no_                    VARCHAR2(4) := NULL;
   rel_no_                     VARCHAR2(4) := NULL;
   line_item_no_               NUMBER := NULL;
   line_ship_via_code_         CUSTOMER_ORDER_TAB.ship_via_code%TYPE;
   line_delivery_terms_        CUSTOMER_ORDER_TAB.delivery_terms%TYPE;
   line_del_terms_location_    CUSTOMER_ORDER_TAB.del_terms_location%TYPE := NULL;
   line_delivery_leadtime_     NUMBER;
   line_ext_transport_cal_id_  CUSTOMER_ORDER_TAB.ext_transport_calendar_id%TYPE;
   line_default_addr_flag_     CUSTOMER_ORDER_TAB.addr_flag%TYPE;
   dummy_supp_ship_via_trans_  CUSTOMER_ORDER_TAB.ship_via_code%TYPE;
   dummy_default_addr_flag_    CUSTOMER_ORDER_TAB.addr_flag%TYPE;
   tax_method_                 VARCHAR2(50);  
   shipment_changed_           BOOLEAN := FALSE;
   paying_customer_            CUSTOMER_ORDER_TAB.customer_no_pay%TYPE;
   agreement_rec_              Customer_Agreement_API.Public_Rec;
   customer_rec_               Cust_Ord_Customer_Address_API.Public_Rec;
   net_price_fetched_          VARCHAR2(20) := 'FALSE';
   rebate_builder_db_          VARCHAR2(20);
   freight_map_id_             VARCHAR2(15);
   zone_id_                    VARCHAR2(15);
   approved_proj_              NUMBER;
   proj_code_value_            VARCHAR2(10);
   distr_proj_code_value_      VARCHAR2(10);
   line_foward_agent_id_       CUSTOMER_ORDER_TAB.forward_agent_id%TYPE;
   line_route_id_              CUSTOMER_ORDER_TAB.route_id%TYPE;
   line_picking_leadtime_      NUMBER;
   line_shipment_type_         VARCHAR2(3);
   discount_freeze_db_         VARCHAR2(5);
   replicate_changes_          VARCHAR2(5):= 'FALSE';
   change_request_             VARCHAR2(5):= 'FALSE';
   vendor_changed_             VARCHAR2(5) := 'FALSE';
   copy_addr_to_line_          VARCHAR2(10) := 'FALSE';
   supply_country_changed_     BOOLEAN := FALSE;
   message_attr_               VARCHAR2(2000);
   delivery_country_db_        VARCHAR2(10);
   cust_ord_info_              VARCHAR2(32000);
   ptr_                        VARCHAR2(2000);
   name_                       VARCHAR2(2000);
   value_                      VARCHAR2(4000);
   oldrec_tax_liability_type_db_ VARCHAR2(20);
   newrec_tax_liability_type_db_ VARCHAR2(20);
   parent_customer_              VARCHAR2(20);
   credit_blocked_               VARCHAR2(200);
   credit_attr_                  VARCHAR2(2000);
   ship_via_code_changed_        VARCHAR2(5);
   update_taxes_at_line_         BOOLEAN := TRUE;
   
   CURSOR get_order_lines(order_no_ IN VARCHAR2) IS
      SELECT *
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND rowstate NOT IN ('Cancelled', 'Invoiced');

   CURSOR get_lines_with_frozen_address (order_no_ IN VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    default_addr_flag = 'Y'
      AND    rowstate IN ('Delivered','Invoiced','Cancelled');

   CURSOR get_non_default_lines (order_no_ IN VARCHAR2, addr_flag_ IN VARCHAR2, ship_addr_no_ IN VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no, ship_addr_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    default_addr_flag = 'N'
      AND    addr_flag = addr_flag_
      AND    ship_addr_no = ship_addr_no_
      AND    rowstate NOT IN ('Delivered','Invoiced','Cancelled');

   CURSOR get_lines_with_non_inv_parts(order_no_ IN VARCHAR2) IS
      SELECT catalog_type, line_no, rel_no, default_addr_flag
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no          = order_no_
      AND    line_item_no     <= 0
      AND    default_addr_flag = 'Y'
      AND    catalog_type IN ('NON', 'PKG');
BEGIN  
   replicate_changes_ := Client_SYS.Get_Item_Value('REPLICATE_CHANGES', attr_); 
   change_request_    := Client_SYS.Get_Item_Value('CHANGE_REQUEST',    attr_); 
   
   --update additional discount in order line if additional discount is changed in order header.
   IF (oldrec_.additional_discount <> newrec_.additional_discount) THEN
      IF (Order_Lines_Exist(newrec_.order_no) = 1) THEN
         Customer_Order_Line_API.Modify_Additional_Discount__(newrec_.order_no,newrec_.additional_discount);
      END IF;
   END IF;
   
   IF Client_SYS.Item_Exist('COPY_ADDR_TO_LINE', attr_) THEN 
      copy_addr_to_line_ := Client_SYS.Get_Item_Value('COPY_ADDR_TO_LINE', attr_);
   END IF; 
    
   -- When the header delivery address flag changes from SO to Order Default, update default_addr_flag in appropriate order lines
   -- so that the lines will get a copy of the header SO address before the order values have been changed.
   IF (oldrec_.addr_flag = 'Y' AND newrec_.addr_flag = 'N') THEN
      FOR addr_frozen_line_rec_ IN get_lines_with_frozen_address (newrec_.order_no) LOOP
         CUSTOMER_ORDER_LINE_API.Modify_Default_Addr_Flag__ (newrec_.order_no, addr_frozen_line_rec_.line_no, addr_frozen_line_rec_.rel_no,
                                               addr_frozen_line_rec_.line_item_no, 'N');
      END LOOP;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   
   cust_ord_info_       := Client_SYS.Get_All_Info;
   company_             := Site_API.Get_Company(newrec_.contract);
   tax_method_          := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   delivery_country_db_ := Customer_Order_Address_API.Get_Address_Country_Code(newrec_.order_no);
   oldrec_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(oldrec_.tax_liability, delivery_country_db_);
   newrec_tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(newrec_.tax_liability, delivery_country_db_);

   -- gelr:br_external_tax_integration, added AVALARA_TAX_BRAZIL
   IF (tax_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL)) THEN
      update_taxes_at_line_ := FALSE;
   END IF;
 
   IF ((newrec_tax_liability_type_db_ != oldrec_tax_liability_type_db_) 
      OR ((newrec_.addr_flag != oldrec_.addr_flag ) AND 
         tax_method_ = External_Tax_Calc_Method_API.DB_VERTEX_SALES_TAX_O_SERIES) 
      OR (NVL(newrec_.ship_addr_no, ' ') != NVL(oldrec_.ship_addr_no, ' ')) OR (newrec_.tax_liability != oldrec_.tax_liability) 
      OR (NVL(newrec_.supply_country, ' ') != NVL(oldrec_.supply_country, ' '))) THEN
      
      IF update_taxes_at_line_ THEN 
         Customer_Order_Charge_API.Add_Transaction_Tax_Info(newrec_.order_no, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
   
-- Update discount lines for all order lines. Also update price.
   IF (NVL(oldrec_.agreement_id, ' ') != NVL(newrec_.agreement_id, ' ')) OR (NVL(oldrec_.vendor_no, ' ') != NVL(newrec_.vendor_no, ' ')) THEN
      FOR linerec_ IN get_order_lines(newrec_.order_no) LOOP
         IF (NVL(oldrec_.agreement_id, ' ') != NVL(newrec_.agreement_id, ' ')) THEN
            Trace_SYS.Message('Agreement ID has changed. Recalculate order line discounts...');
            IF (linerec_.supply_code != 'SEO') THEN
               -- Update price
               Customer_Order_Pricing_API.Get_Order_Line_Price_Info(sale_unit_price_,        unit_price_incl_tax_,    base_sale_unit_price_,      base_unit_price_incl_tax_,
                                                                    currency_rate_,          discount_,               price_source_,              price_source_id_,
                                                                    provisional_price_db_,   net_price_fetched_,      rebate_builder_db_,         linerec_.part_level,
                                                                    linerec_.part_level_id,  linerec_.customer_level, linerec_.customer_level_id, newrec_.order_no,
                                                                    linerec_.catalog_no,     linerec_.buy_qty_due,    linerec_.price_list_no,     linerec_.price_effectivity_date,
                                                                    linerec_.condition_code, newrec_.use_price_incl_tax);
               Client_SYS.Clear_Attr(lineattr_);
               IF (newrec_.use_price_incl_tax = 'TRUE') THEN
                  part_price_ := unit_price_incl_tax_;
               ELSE
                  part_price_ := sale_unit_price_;
               END IF;
               -- Calculate sale unit price and base sale unit price.
               IF (linerec_.price_freeze = 'FREE') THEN
                  IF (newrec_.use_price_incl_tax = 'TRUE') THEN
                     unit_price_incl_tax_ := unit_price_incl_tax_ + NVL(linerec_.char_price, 0);
                     Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_unit_price_incl_tax_, currency_rate_,
                                                                           NVL(newrec_.customer_no_pay, newrec_.customer_no),
                                                                           newrec_.contract, newrec_.currency_code, unit_price_incl_tax_,
                                                                           newrec_.currency_rate_type);
                  ELSE
                     sale_unit_price_ := sale_unit_price_ + NVL(linerec_.char_price, 0);
                     Customer_Order_Pricing_API.Get_Base_Price_In_Currency(base_sale_unit_price_, currency_rate_,
                                                                           NVL(newrec_.customer_no_pay, newrec_.customer_no),
                                                                           newrec_.contract, newrec_.currency_code, sale_unit_price_,
                                                                           newrec_.currency_rate_type);
                  END IF;
                  CUSTOMER_ORDER_LINE_API.Calculate_Prices(sale_unit_price_, unit_price_incl_tax_, base_sale_unit_price_, base_unit_price_incl_tax_,
                                                           newrec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
                  Client_SYS.Add_To_Attr('SALE_UNIT_PRICE',      sale_unit_price_, lineattr_);
                  Client_SYS.Add_To_Attr('UNIT_PRICE_INCL_TAX',      unit_price_incl_tax_,      lineattr_);
                  Client_SYS.Add_To_Attr('BASE_SALE_UNIT_PRICE', base_sale_unit_price_, lineattr_);
                  Client_SYS.Add_To_Attr('BASE_UNIT_PRICE_INCL_TAX', base_unit_price_incl_tax_, lineattr_);
               END IF;
               IF (NVL(linerec_.demand_code, Database_SYS.string_null_ )!= 'IPD') THEN
                  IF ((Pricing_Source_API.Encode(price_source_) = 'AGREEMENT') AND(price_source_id_ IS NOT NULL))THEN
                     IF (oldrec_.ship_via_code != newrec_.ship_via_code) THEN
                        ship_via_code_changed_ := 'TRUE';
                        
                     ELSE
                        ship_via_code_changed_ := 'FALSE';
                     END IF;
                     Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Defaults(line_route_id_,
                                                                            line_foward_agent_id_,
                                                                            line_ship_via_code_,
                                                                            line_delivery_terms_,
                                                                            line_del_terms_location_,
                                                                            dummy_supp_ship_via_trans_,
                                                                            line_delivery_leadtime_,
                                                                            line_ext_transport_cal_id_,
                                                                            dummy_default_addr_flag_,
                                                                            freight_map_id_,
                                                                            zone_id_,
                                                                            line_picking_leadtime_,
                                                                            line_shipment_type_,
                                                                            linerec_.contract,
                                                                            newrec_.customer_no,
                                                                            linerec_.ship_addr_no,
                                                                            linerec_.addr_flag,
                                                                            linerec_.part_no,
                                                                            linerec_.supply_code,
                                                                            linerec_.vendor_no,
                                                                            price_source_id_,
                                                                            newrec_.ship_via_code,
                                                                            newrec_.delivery_terms,
                                                                            newrec_.del_terms_location,
                                                                            newrec_.delivery_leadtime,
                                                                            newrec_.ext_transport_calendar_id,
                                                                            newrec_.route_id, newrec_.forward_agent_id,
                                                                            newrec_.picking_leadtime,
                                                                            newrec_.shipment_type,
                                                                            newrec_.vendor_no,
                                                                            NULL,
                                                                            ship_via_code_changed_);

                     Client_SYS.Add_To_Attr('ROUTE_ID', line_route_id_, lineattr_);
                     Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', line_foward_agent_id_, lineattr_);
                     Client_SYS.Add_To_Attr('SHIP_VIA_CODE', line_ship_via_code_, lineattr_);
                     Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', NVL(line_delivery_leadtime_, 0), lineattr_);
                     Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', line_ext_transport_cal_id_, lineattr_);
                     Client_SYS.Add_To_Attr('PICKING_LEADTIME', NVL(line_picking_leadtime_, 0), lineattr_);
                     Client_SYS.Add_To_Attr('SHIPMENT_TYPE', line_shipment_type_, lineattr_);       

                     IF ((NVL(newrec_.agreement_id, Database_Sys.string_null_) != NVL(linerec_.price_source_id, Database_Sys.string_null_))
                        AND (linerec_.supply_code NOT IN ('IPD','PD')))  THEN
                        agreement_rec_ := Customer_Agreement_API.Get(price_source_id_);

                        -- IF the agreement has delivery terms get del_terms_location from agreement
                        -- if not retrieve delivery term and location from Order header.
                        IF (agreement_rec_.Delivery_Terms IS NOT NULL) THEN
                           line_delivery_terms_     := agreement_rec_.delivery_terms;
                           line_del_terms_location_ := agreement_rec_.del_terms_location;   
                        ELSE
                           line_delivery_terms_       := newrec_.delivery_terms;
                           line_del_terms_location_   := newrec_.del_terms_location;
                        END IF;     
                        Client_SYS.Add_To_Attr('DELIVERY_TERMS', line_delivery_terms_, lineattr_); 
                        Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', line_del_terms_location_, lineattr_);
                     END IF;

                     IF (NVL(line_ship_via_code_, Database_Sys.string_null_) != NVL(newrec_.ship_via_code, Database_Sys.string_null_) OR
                         NVL(line_delivery_terms_, Database_Sys.string_null_) != NVL(newrec_.delivery_terms, Database_Sys.string_null_ ) OR
                         NVL(line_del_terms_location_, Database_Sys.string_null_) != NVL(newrec_.del_terms_location, Database_Sys.string_null_) OR
                         NVL(line_route_id_, Database_Sys.string_null_) != NVL(newrec_.route_id, Database_Sys.string_null_ )OR
                         NVL(line_foward_agent_id_, Database_Sys.string_null_) != NVL(newrec_.forward_agent_id, Database_Sys.string_null_ )) THEN
                        line_default_addr_flag_ := 'N';
                     ELSE
                        line_default_addr_flag_ := linerec_.default_addr_flag;
                     END IF;
                     Client_SYS.Add_To_Attr('DEFAULT_ADDR_FLAG_DB', line_default_addr_flag_, lineattr_);                  
                  END IF;                  
               END IF;

               Client_SYS.Add_To_Attr('PART_PRICE',                part_price_,                 lineattr_);
               Client_SYS.Add_To_Attr('CURRENCY_RATE',             currency_rate_,              lineattr_);
               Client_SYS.Add_To_Attr('DISCOUNT',                  discount_,                   lineattr_);
               Client_SYS.Add_To_Attr('PRICE_SOURCE',              price_source_,               lineattr_);
               Client_SYS.Add_To_Attr('PRICE_SOURCE_ID',           price_source_id_,            lineattr_);
               Client_SYS.Add_To_Attr('PROVISIONAL_PRICE_DB',      provisional_price_db_,       lineattr_);
               Client_SYS.Add_To_Attr('PRICE_SOURCE_NET_PRICE_DB', net_price_fetched_,          lineattr_);
               Client_SYS.Add_To_Attr('REBATE_BUILDER_DB',         rebate_builder_db_,          lineattr_);
               Client_SYS.Add_To_Attr('PART_LEVEL_DB',             linerec_.part_level,         lineattr_);
               Client_SYS.Add_To_Attr('PART_LEVEL_ID',             linerec_.part_level_id,      lineattr_);
               Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_DB',         linerec_.customer_level,     lineattr_);
               Client_SYS.Add_To_Attr('CUSTOMER_LEVEL_ID',         linerec_.customer_level_id,  lineattr_);
               Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',        1,                           lineattr_);
               
               CUSTOMER_ORDER_LINE_API.Modify(lineattr_, 
                                newrec_.order_no, 
                                linerec_.line_no, 
                                linerec_.rel_no, 
                                linerec_.line_item_no);

               -- Update discounts
               discount_freeze_db_ := Site_Discom_Info_API.Get_Discount_Freeze_Db(newrec_.contract);
               IF NOT(linerec_.price_freeze = 'FROZEN' AND discount_freeze_db_ = 'TRUE') THEN
                  Customer_Order_Pricing_API.Modify_Default_Discount_Rec(newrec_.order_no,       linerec_.line_no,        linerec_.rel_no, 
                                                                         linerec_.line_item_no,  newrec_.contract,        newrec_.customer_no, 
                                                                         newrec_.currency_code,  newrec_.agreement_id,    linerec_.catalog_no, linerec_.buy_qty_due,
                                                                         linerec_.price_list_no, linerec_.customer_level, linerec_.customer_level_id);

                  discount_ := NVL(Cust_Order_Line_Discount_API.Calculate_Discount__(newrec_.order_no,
                                                                                     linerec_.line_no, 
                                                                                     linerec_.rel_no, 
                                                                                     linerec_.line_item_no), 0);

                  Client_SYS.Clear_Attr(lineattr_);
                  Client_SYS.Add_To_Attr('DISCOUNT', discount_, lineattr_);
                  Client_SYS.Add_To_Attr('SERVER_DATA_CHANGE',1,lineattr_);
                  CUSTOMER_ORDER_LINE_API.Modify(lineattr_,       newrec_.order_no, linerec_.line_no, 
                                                 linerec_.rel_no, linerec_.line_item_no);
               END IF;                 
            END IF;
         END IF;
         IF Validate_SYS.Is_Changed(oldrec_.vendor_no, newrec_.vendor_no) THEN
            CUSTOMER_ORDER_LINE_API.Modify_Line_Default_Addr_Flag(linerec_, newrec_.order_no, linerec_.default_addr_flag); 
            vendor_changed_ := 'TRUE';
         END IF;
      END LOOP;
   END IF;
   
   -- Update Lines with same address but no default-info set, if user choose to update those lines (copy_addr_to_line_ = 'TRUE').   
   IF copy_addr_to_line_ = 'TRUE' AND 
      (Validate_SYS.Is_Changed(oldrec_.ship_addr_no, newrec_.ship_addr_no)) THEN 
      IF (NVL(oldrec_.supply_country, ' ') != NVL(newrec_.supply_country, ' ')) THEN
         supply_country_changed_ := TRUE;
      END IF ;

      Client_SYS.Clear_Attr(message_attr_);
      Client_SYS.Add_To_Attr('INFO_ADDED','FALSE', message_attr_);
      Client_SYS.Add_To_Attr('LINE_DUE_DATE_CHANGED','FALSE', message_attr_);
      Client_SYS.Add_To_Attr('LINE_DATE_CHANGED','FALSE', message_attr_);
      Client_SYS.Add_To_Attr('POCO_AUTO','FALSE', message_attr_);      
      Client_SYS.Add_To_Attr('NON_DEFAULT_ADDR_CHANGE','TRUE', message_attr_);
      FOR linerec_ IN get_non_default_lines(oldrec_.order_no, oldrec_.addr_flag, oldrec_.ship_addr_no) LOOP
         CUSTOMER_ORDER_LINE_API.Modify_Delivery_Address__(message_attr_,
                                                           newrec_.order_no, 
                                                           linerec_.line_no, 
                                                           linerec_.rel_no, 
                                                           linerec_.line_item_no,
                                                           newrec_.addr_flag,
                                                           ship_addr_changed_ => TRUE,
                                                           refresh_tax_code_ => FALSE,
                                                           supply_country_changed_ => supply_country_changed_,
                                                           update_tax_ => update_taxes_at_line_);
      END LOOP; 
   END IF; 
   -- IF condition using already existing values was moved out of the loop to improve performance
   IF (newrec_.shipment_creation = 'PICK_LIST_CREATION' AND oldrec_.shipment_creation != newrec_.shipment_creation) THEN
      FOR lines_ IN get_lines_with_non_inv_parts(newrec_.order_no) LOOP
         IF (((lines_.catalog_type = 'NON') OR
             (lines_.catalog_type = 'PKG' AND CUSTOMER_ORDER_LINE_API.All_Non_Inv_Parts(newrec_.order_no, lines_.line_no, lines_.rel_no))))  THEN
            shipment_changed_ := TRUE;
            EXIT;
         END IF;
      END LOOP;  
   END IF;

   IF (((oldrec_.free_of_chg_tax_pay_party = Tax_Paying_Party_API.DB_NO_TAX) AND (newrec_.free_of_chg_tax_pay_party != Tax_Paying_Party_API.DB_NO_TAX)) OR 
      ((oldrec_.free_of_chg_tax_pay_party != Tax_Paying_Party_API.DB_NO_TAX) AND (newrec_.free_of_chg_tax_pay_party = Tax_Paying_Party_API.DB_NO_TAX))) THEN
      Tax_Paying_Party_Changed___(newrec_);
   END IF;
   
   IF (vendor_changed_ = 'FALSE') THEN
	   IF ((oldrec_.addr_flag != newrec_.addr_flag) OR
	       (NVL(oldrec_.ship_addr_no, ' ') != NVL(newrec_.ship_addr_no, ' ')) OR
	       (NVL(oldrec_.route_id, ' ') != NVL(newrec_.route_id, ' ')) OR
	       (NVL(oldrec_.forward_agent_id, ' ') != NVL(newrec_.forward_agent_id, ' ')) OR
	       (NVL(oldrec_.supply_country, ' ') != NVL(newrec_.supply_country, ' ')) OR
	       (NVL(oldrec_.ship_via_code, ' ') != NVL(newrec_.ship_via_code, ' ')) OR
	       (oldrec_.delivery_terms != newrec_.delivery_terms) OR
	       (NVL(oldrec_.del_terms_location, ' ') != NVL(newrec_.del_terms_location, ' ')) OR
	       (oldrec_.delivery_leadtime != newrec_.delivery_leadtime) OR
	       (oldrec_.picking_leadtime != newrec_.picking_leadtime) OR
	       (NVL(oldrec_.shipment_type, Database_SYS.string_null_) != NVL(newrec_.shipment_type, Database_SYS.string_null_)) OR
	       (NVL(oldrec_.ext_transport_calendar_id, Database_SYS.string_null_) != NVL(newrec_.ext_transport_calendar_id, Database_SYS.string_null_)) OR
	       (NVL(oldrec_.cust_calendar_id, Database_SYS.string_null_) != NVL(newrec_.cust_calendar_id, Database_SYS.string_null_)) OR
	       (NVL(oldrec_.district_code, ' ') != NVL(newrec_.district_code, ' ')) OR
	       (NVL(oldrec_.region_code, ' ') != NVL(newrec_.region_code, ' ')) OR
	       (oldrec_.shipment_creation != newrec_.shipment_creation) OR
	       (NVL(oldrec_.cust_ref, ' ') != NVL(newrec_.cust_ref, ' ')) OR
	       (oldrec_.tax_liability != newrec_.tax_liability) OR 
	       (NVL(oldrec_.freight_map_id, ' ') != NVL(newrec_.freight_map_id, ' ')) OR
	       (NVL(oldrec_.zone_id, ' ') != NVL(newrec_.zone_id, ' ')) OR
	       (NVL(oldrec_.freight_price_list_no, ' ') != NVL(newrec_.freight_price_list_no, ' ')) OR
	       (oldrec_.intrastat_exempt != newrec_.intrastat_exempt)) THEN
          
         IF (NVL(oldrec_.supply_country, ' ') != NVL(newrec_.supply_country, ' ')) THEN
            Customer_Order_Line_API.Modify_Order_Defaults__(newrec_.order_no, 'TRUE', update_taxes_at_line_);
         ELSE
            Customer_Order_Line_API.Modify_Order_Defaults__(newrec_.order_no, 'FALSE', update_taxes_at_line_);
         END IF;	
	   END IF;
   END IF;

   -- Set the associated commission lines as 'Changed'
   IF (newrec_.rowstate != 'Cancelled') THEN
      IF ((newrec_.country_code != oldrec_.country_code) OR
          (newrec_.market_code != oldrec_.market_code)) THEN
         Order_Line_Commission_API.Set_Order_Com_Lines_Changed(newrec_.order_no);
      END IF;
   END IF;

   --Update tax amounts in customer order lines, if additional discount percentage has changed in order header.
   IF (newrec_.additional_discount != oldrec_.additional_discount) THEN
      Recal_Tax_Lines_Add_Disc___(newrec_, NULL);
   END IF;

   IF ((newrec_.bill_addr_no IS NULL) AND (oldrec_.bill_addr_no IS NOT NULL)) THEN
      Client_SYS.Add_Info(lu_name_,'BILLADDRESSNULL: Document Address is not specified. This will not be reflected on documents to be printed.');
   END IF;

   IF (newrec_.tax_id_no != oldrec_.tax_id_no) THEN
      Modify_Line_Tax_Id_Details___(newrec_.order_no, newrec_.tax_id_no, newrec_.tax_id_validated_date); 
   END IF;

   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      cust_contract_ := Cust_Ord_Customer_API.Get_Acquisition_Site(newrec_.customer_no);
      IF (NVL(Site_API.Get_Company(cust_contract_), ' ') != company_) THEN
         IF (Customer_Delivery_Tax_Info_API.Check_Exist(newrec_.customer_no, newrec_.ship_addr_no, company_, newrec_.supply_country) = 'FALSE') THEN
            Client_SYS.Add_Info(lu_name_, 'NOTAXFORADDR: Customer Tax Information has not been defined for the delivery address.');
         END IF;
      END IF;
   END IF;
   
   IF ((newrec_tax_liability_type_db_ = 'EXM') AND (oldrec_tax_liability_type_db_ = 'EXM') AND (newrec_.addr_flag = 'N') AND (oldrec_.addr_flag = 'Y')) THEN
      -- To modify connected Charge Lines' tax free tax code stored in the tax_code
      Customer_Order_Charge_API.Remove_Tax_Lines(newrec_.order_no, line_no_, rel_no_, line_item_no_);
   END IF;

   Check_Customer_Credit_Blocked(credit_blocked_, credit_attr_, newrec_.order_no);
   IF Client_SYS.Item_Exist('PARENT_IDENTITY', credit_attr_) THEN
      parent_customer_ := Client_SYS.Get_Item_Value('PARENT_IDENTITY', credit_attr_); 
   END IF;
   IF credit_blocked_ = 'CUSTOMER_BLOCKED' THEN      
      IF parent_customer_ IS NULL  THEN
         Client_SYS.Add_Info(lu_name_, 'CREDIT_BLOCKED: The customer is credit blocked. The order will be credit blocked');
      ELSE
         Client_SYS.Add_Info(lu_name_, 'CREDITBLOCKEDPAR: The parent :P1 of the customer is credit blocked. The order will be credit blocked', parent_customer_);
      END IF; 
   ELSIF credit_blocked_ = 'PAY_CUSTOMER_BLOCKED' THEN
      IF parent_customer_ IS NULL  THEN
         Client_SYS.Add_Info(lu_name_, 'CREDITPAYBLOCKED: The paying customer :P1 is credit blocked. The order will be credit blocked', newrec_.customer_no_pay);
      ELSE
         Client_SYS.Add_Info(lu_name_, 'CREDITPAYBLOCKEDPAR: The parent :P1 of the paying customer is credit blocked. The order will be credit blocked', parent_customer_);
      END IF;
   END IF;

   IF (shipment_changed_) THEN
      Client_SYS.Add_Info(lu_name_, 'NONINVPARTLINESEXIST: According to the shipment creation method, the line(s) should be connected to a shipment at pick list creation. '||
                                    'This will not happen to the non-inventory part(s), since they are never included in a pick list. The non-inventory part(s) must be manually connected to a shipment.');
   END IF;
   IF(oldrec_.ship_addr_no != newrec_.ship_addr_no) THEN
      Customer_Order_History_Api.New(newrec_.Order_No, Language_Sys.Translate_Constant(lu_name_,'SHIPADDRNOCHGORD: The delivery address has been changed from :P1 to :P2', p1_ => oldrec_.ship_addr_no, p2_ => newrec_.ship_addr_no)); 
   END IF;
   
   IF ((oldrec_.ship_addr_no != newrec_.ship_addr_no) OR (oldrec_.addr_flag != newrec_.addr_flag)) AND (newrec_.addr_flag = 'N') THEN
      Check_Ipd_Tax_Registration(newrec_.order_no, 'TRUE');
   END IF;
         
   IF (newrec_.pre_accounting_id IS NOT NULL AND newrec_.project_id IS NULL) THEN
      Pre_Accounting_API.Get_Project_Code_Value(proj_code_value_,          --OUT VARCHAR2
                                                distr_proj_code_value_,    --OUT VARCHAR2
                                                company_,
                                                newrec_.pre_accounting_id );
   END IF;

   --If project id is deleted, only update if preposted project code part has same value
   IF ((NVL(newrec_.project_id, ' ') != NVL(oldrec_.project_id, ' ')) AND
       ((newrec_.project_id IS NOT NULL) OR 
       ((newrec_.project_id IS NULL AND proj_code_value_ IS NOT NULL) AND (proj_code_value_ = oldrec_.project_id)))) THEN
      --set project pre accounting if project is approved
      $IF Component_Proj_SYS.INSTALLED $THEN
         approved_proj_ := Project_API.Is_Approved(newrec_.project_id);
      $END
      IF (approved_proj_ = 1 ) OR (newrec_.project_id IS NULL) THEN
         -- set project pre accounting for customer order head
         Pre_Accounting_API.Set_Project_Code_Part (newrec_.pre_accounting_id,
                                                   company_,
                                                   newrec_.contract,
                                                   'M103', --posting_type_
                                                   newrec_.project_id,
                                                   NULL,   --activity_seq_
                                                   FALSE,  --skip_posting_type_check_
                                                   'CUSTOMER ORDER'); --pre_posting_source_
      END IF;
   END IF;

   IF (NVL(newrec_.cust_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.cust_calendar_id, Database_Sys.string_null_) OR
       newrec_.wanted_delivery_date != oldrec_.wanted_delivery_date) THEN

      IF (NVL(newrec_.cust_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.cust_calendar_id, Database_Sys.string_null_)) THEN
         Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.cust_calendar_id);
      END IF;

      Cust_Ord_Date_Calculation_API.Check_Date_On_Cust_Calendar_(newrec_.customer_no, newrec_.cust_calendar_id, newrec_.wanted_delivery_date, 'WANTED');
   END IF;

   IF (NVL(newrec_.ext_transport_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.ext_transport_calendar_id, Database_Sys.string_null_) OR
       newrec_.wanted_delivery_date != oldrec_.wanted_delivery_date) THEN

      IF (NVL(newrec_.ext_transport_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.ext_transport_calendar_id, Database_Sys.string_null_)) THEN
         Work_Time_Calendar_API.Add_Info_On_Pending(newrec_.ext_transport_calendar_id);
      END IF;

      Cust_Ord_Date_Calculation_API.Chk_Date_On_Ext_Transport_Cal(newrec_.ext_transport_calendar_id, newrec_.wanted_delivery_date, 'WANTED');
   END IF;
   
   -- gelr:brazilian_specific_attributes, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'BRAZILIAN_SPECIFIC_ATTRIBUTES') = Fnd_Boolean_API.DB_TRUE) THEN
      IF newrec_.rowstate = 'Planned' AND (NVL(newrec_.business_transaction_id, Database_Sys.string_null_) != NVL(oldrec_.business_transaction_id, Database_Sys.string_null_)) THEN
         Customer_Order_Line_API.Modify_Ref_Id(newrec_.order_no, newrec_.business_transaction_id);
      END IF;
   END IF;
   -- gelr:brazilian_specific_attributes, end

   IF (oldrec_.supply_country != newrec_.supply_country) THEN
      Client_SYS.Add_Info(lu_name_, 'SUPCOUNTRYUPDATED: Changing Supply Country may affect tax information on line level.');
      Check_Ipd_Tax_Registration(newrec_.order_no, 'FALSE');
   END IF;

   IF ((NVL(replicate_changes_, 'FALSE') = 'TRUE') AND (newrec_.rowstate NOT IN ('Planned', 'Delivered', 'Closed'))) THEN
      Modify_Connected_Order___(oldrec_, newrec_, change_request_);   
   END IF;   
   
   IF NVL(Client_SYS.Get_Item_Value('POCO_AUTO', message_attr_), 'FALSE') = 'TRUE' THEN
      Client_SYS.Add_Info(lu_name_, 'CREATEPOCOAUTO: It is not allowed to directly update Purchase Order for some lines, so the changes need to be processed via a Purchase Order Change Order. New Change Orders are created for those Purchase Order lines.');
   END IF;

   IF NVL(Client_SYS.Get_Item_Value('INFO_ADDED', message_attr_), 'FALSE') = 'TRUE' THEN
      Client_SYS.Add_Info(lu_name_, 'PREL_DELNOTE: Preliminary Delivery Note is already created. IF the Delivery Note is already printed the delivery information needs to be updated manually.');
   END IF;
   
   IF NVL(Client_SYS.Get_Item_Value('LINE_DATE_CHANGED', message_attr_), 'FALSE') = 'TRUE' THEN
      Client_SYS.Add_Info(lu_name_, 'NONDEFLINEDATESCHANGED: Planned Delivery Date/Planned Ship Date has been changed on applicable non Default Info order lines.');
   END IF;
   
   IF NVL(Client_SYS.Get_Item_Value('LINE_DUE_DATE_CHANGED', message_attr_), 'FALSE') = 'TRUE' THEN
      Client_SYS.Add_Info(lu_name_, 'NONDEFEARLYLINEDUEDATE: The planned due date is earlier than today''s date in some non Default Info order lines.');
   END IF;
   
   IF (newrec_.wanted_delivery_date != oldrec_.wanted_delivery_date OR NVL(newrec_.ship_via_code, ' ') != NVL(oldrec_.ship_via_code, ' ') OR
      newrec_.delivery_terms != oldrec_.delivery_terms OR NVL(newrec_.forward_agent_id, ' ') != NVL(oldrec_.forward_agent_id, ' ') OR
      newrec_.ship_addr_no != oldrec_.ship_addr_no OR NVL(newrec_.route_id, ' ') != NVL(oldrec_.route_id, ' ')) THEN
      IF (Has_Demand_Code_Lines(newrec_.order_no, 'DO') = 'TRUE') THEN
         Client_SYS.Add_Info(lu_name_, 'CO_CHANGED: The system will update the connected distribution orders and purchase order lines with changes in order dates, ship-via code, delivery terms, forwarder, route ID and quantities.');
      END IF;
   END IF;
   
   IF NOT update_taxes_at_line_ AND ((newrec_tax_liability_type_db_ != oldrec_tax_liability_type_db_) 
      OR (newrec_.addr_flag != oldrec_.addr_flag AND newrec_.addr_flag = 'N' )
      OR (NVL(newrec_.ship_addr_no, ' ') != NVL(oldrec_.ship_addr_no, ' '))) THEN
      
      IF copy_addr_to_line_ = 'TRUE' THEN
         Fetch_External_Tax(newrec_.order_no);
      ELSE
         Fetch_External_Tax(newrec_.order_no, 'TRUE');
      END IF;
   END IF;
      
   WHILE (Client_SYS.Get_Next_From_Attr(cust_ord_info_, ptr_, name_, value_)) LOOP
      IF (name_ = 'INFO') THEN
         Client_SYS.Add_Info(lu_name_, value_);
      END IF;               
   END LOOP;   
END Update___;


PROCEDURE Calculate_Order_Discount___ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER)
IS
   CURSOR get_line_data IS
      SELECT line_no, rel_no, line_item_no, buy_qty_due, price_conv_factor, currency_rate,
             (buy_qty_due * price_conv_factor * sale_unit_price) price_curr, 
             (buy_qty_due * price_conv_factor * unit_price_incl_tax) price_curr_tax,
             rental
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'Invoiced')
      AND   line_item_no <= 0
      AND   order_no = order_no_;
   
   line_discount_          NUMBER := 0;
   curr_rounding_          NUMBER;
   price_base_             NUMBER;
   price_base_tax_         NUMBER;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, contract, catalog_no, buy_qty_due, additional_discount, staged_billing, order_discount, rental, price_freeze, 
             price_conv_factor
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    (line_no = line_no_ OR line_no_ IS NULL)
      AND    (rel_no = rel_no_   OR rel_no_  IS NULL)
      AND    (line_item_no = line_item_no_ OR line_item_no_ IS NULL)
      AND    line_item_no <= 0
      AND    rowstate NOT IN ('Cancelled', 'Invoiced');

   order_discount_         NUMBER;
   discount_code_          VARCHAR2(20);
   ord_rec_                CUSTOMER_ORDER_TAB%ROWTYPE;
   company_                VARCHAR2(20);
   rounding_               NUMBER;
   order_total_value_      NUMBER;
   -- added default 0 to total_base_price_, and removed total_base_price_incl_tax_ 
   total_base_price_       NUMBER := 0;
   sales_part_rec_         Sales_Part_API.Public_Rec;
   add_discount_           NUMBER;
   total_order_disc_       NUMBER;  
   rental_chargeable_days_ NUMBER;
   rental_period_exists_   BOOLEAN := FALSE;
   discount_freeze_db_     VARCHAR2(5);
   total_weight_           NUMBER;
   total_qty_              NUMBER;
   line_source_key_arr_    Tax_Handling_Util_API.source_key_arr;
   tax_method_             VARCHAR2(50);
   update_tax_at_line_     BOOLEAN := TRUE;
   i_                      NUMBER := 0;
BEGIN
   ord_rec_            := Get_Object_By_Keys___(order_no_);
   company_            := Site_API.Get_Company(ord_rec_.contract);
   rounding_           := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   curr_rounding_      := Currency_Code_API.Get_Currency_Rounding(company_, ord_rec_.currency_code); 
   discount_freeze_db_ := Site_Discom_Info_API.Get_Discount_Freeze_Db(ord_rec_.contract);  
   tax_method_         := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   -- gelr:br_external_tax_integration, added AVALARA_TAX_BRAZIL
   IF tax_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL) THEN
      update_tax_at_line_ := FALSE;
   END IF; 
   
   FOR rec_ IN get_line_data LOOP
      rental_chargeable_days_ := Customer_Order_Line_API.Get_Rental_Chargeable_Days(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
 
      line_discount_          := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                                                                                                       rec_.buy_qty_due, rec_.price_conv_factor, curr_rounding_);
                                                                                    
      IF (ord_rec_.use_price_incl_tax = 'TRUE') THEN
         price_base_tax_   := ROUND((ROUND(rec_.price_curr_tax * rental_chargeable_days_,curr_rounding_ ) - line_discount_)* rec_.currency_rate, rounding_) ;
         total_base_price_ := total_base_price_ + price_base_tax_;
      ELSE
         price_base_       := ROUND((ROUND(rec_.price_curr * rental_chargeable_days_,curr_rounding_ ) - line_discount_)* rec_.currency_rate, rounding_) ;
         total_base_price_ := total_base_price_ + price_base_;
      END IF; 
	END LOOP;

   total_weight_ := Get_Total_Weight__(order_no_);
   total_qty_    := Get_Total_Qty__(order_no_);
   FOR next_line_ IN get_lines LOOP
      -- Calculate order discount
      discount_code_  := NULL;
      order_discount_ := 0;
      sales_part_rec_ := Sales_Part_API.Get(next_line_.contract, next_line_.catalog_no);
      IF (sales_part_rec_.discount_group IS NOT NULL) THEN
         discount_code_ := Discount_Basis_Code_API.Encode(Sales_Discount_Group_API.Get_Discount_Code(sales_part_rec_.discount_group));
         IF (next_line_.rental = Fnd_Boolean_API.DB_TRUE) THEN
            rental_period_exists_ := Customer_Order_Line_API.Rental_Period_Exists(order_no_,
                                                                                  next_line_.line_no,
                                                                                  next_line_.rel_no,
                                                                                  next_line_.line_item_no);

            --If rental period exists go to the next order line, group discount is not updated for the current line.
            CONTINUE WHEN rental_period_exists_;
         END IF; 

         IF (discount_code_ IS NOT NULL) THEN
            IF (discount_code_ = 'V') THEN
               order_total_value_ := total_base_price_;
            ELSIF (discount_code_ = 'W') THEN
               order_total_value_ := total_weight_;
            ELSE
               order_total_value_ := total_qty_;
            END IF;
            --Check that total order discount is not greater than 100 %.
            order_discount_   := Sales_Discount_Group_API.Get_Amount_Discount(sales_part_rec_.discount_group, order_total_value_, discount_code_, ord_rec_.use_price_incl_tax);
            add_discount_     := next_line_.additional_discount;
            total_order_disc_ := order_discount_ + add_discount_;
            IF total_order_disc_ > 100 THEN
               Error_SYS.Record_General(lu_name_, 'DISCOUNTEXCEED: Total Order Discount should not exceed 100% in line (Line No :P1, Del No :P2)', next_line_.line_no,next_line_.rel_no );
            END IF;
         END IF;
      END IF;
      -- Update the order_discount attribute in CustomerOrderLine
      -- Modify the discount only if it is changed.
      IF (next_line_.order_discount != order_discount_ AND (NOT(next_line_.price_freeze = 'FROZEN' AND discount_freeze_db_ = 'TRUE'))) THEN
         CUSTOMER_ORDER_LINE_API.Modify_Order_Discount(order_no_, next_line_.line_no, next_line_.rel_no, next_line_.line_item_no, order_discount_, update_tax_at_line_ );
         
         IF NOT update_tax_at_line_  THEN 
            i_ :=  i_ + 1;
            line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                                                    order_no_, 
                                                                                    next_line_.line_no, 
                                                                                    next_line_.rel_no, 
                                                                                    next_line_.line_item_no, 
                                                                                    '*',                                                                  
                                                                                    attr_ => NULL);
         ELSE
            Recalculate_Tax_Lines___(order_no_,
                                       next_line_.line_no,
                                       next_line_.rel_no,
                                       next_line_.line_item_no,
                                       company_,
                                       ord_rec_.contract,
                                       ord_rec_.supply_country,
                                       ord_rec_.customer_no,
                                       ord_rec_.ship_addr_no,
                                       ord_rec_.use_price_incl_tax,
                                       ord_rec_.currency_code,                                  
                                       next_line_.price_conv_factor,
                                       NULL);
         END IF;
      END IF;    
   END LOOP;
   
   IF i_ > 0 THEN
      IF line_source_key_arr_.COUNT >= 1 THEN 
         Tax_Handling_Order_Util_API.Fetch_External_Tax_Info(line_source_key_arr_,
                                                             company_);
      END IF; 

      Customer_Order_History_Api.New(order_no_, Language_Sys.Translate_Constant(lu_name_,'EXTAXBUNDLECALL: External Taxes Updated'));
   END IF;
END Calculate_Order_Discount___;

@Override
PROCEDURE Unpack___ (
   newrec_   IN OUT customer_order_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   ptr_                   NUMBER;
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(4000);
   wanted_date_changed_   BOOLEAN := FALSE;
   planned_date_changed_  BOOLEAN := FALSE;
   line_date_will_change_ BOOLEAN := FALSE;
BEGIN
   IF newrec_.rowstate IS NULL THEN
      Get_Order_Defaults___(attr_);
   ELSE
      IF Has_Invoiced_Lines(newrec_.order_no) THEN      
         ptr_ := NULL;
         WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP

            -- gelr: invoice_reason, added invoice_reason_id
            IF (name_ NOT IN ('CALC_DISC_BONUS_FLAG', 'CALC_DISC_BONUS_FLAG_DB', 'GRP_DISC_CALC_FLAG', 'GRP_DISC_CALC_FLAG_DB', 'SALESMAN_CODE',
                              'MARKET_CODE','REGION_CODE', 'DISTRICT_CODE', 'BILL_ADDR_NO', 'CUSTOMER_NO_PAY', 'CUSTOMER_NO_PAY_ADDR_NO',
                              'DELIVERY_TERMS', 'DEL_TERMS_LOCATION', 'PAY_TERM_ID', 'PAY_TERM_BASE_DATE', 'SHIP_ADDR_NO', 'ROUTE_ID',
                              'SHIP_VIA_CODE', 'CUSTOMER_PO_NO', 'CUST_REF', 'DELIVERY_LEADTIME', 'EXT_TRANSPORT_CALENDAR_ID',
                              'LABEL_NOTE', 'NOTE_TEXT', 'CUST_CALENDAR_ID', 'LANGUAGE_CODE',
                              'FORWARD_AGENT_ID', 'ADDR_FLAG', 'ADDR_FLAG_DB', 'COUNTRY_CODE','SM_CONNECTION',
                              'SM_CONNECTION_DB', 'SCHEDULING_CONNECTION', 'SCHEDULING_CONNECTION_DB',
                              'INTRASTAT_EXEMPT', 'INTRASTAT_EXEMPT_DB',  'UPDATE_PRICE_EFFECTIVE_DATE',
                              'WANTED_DELIVERY_DATE','CHANGE_LINE_DATE','PLANNED_DELIVERY_DATE','ADDITIONAL_DISCOUNT','SHIPMENT_CREATION','SHIPMENT_CREATION_DB',
                              'BACKORDER_OPTION', 'BACKORDER_OPTION_DB', 'BLOCKED_REASON', 'RELEASED_FROM_CREDIT_CHECK', 
                              'RELEASED_FROM_CREDIT_CHECK_DB', 'TAX_ID_NO', 'TAX_ID_VALIDATED_DATE', 'INTERNAL_REF', 'AUTHORIZE_CODE', 'PRIORITY', 'PRINT_CONTROL_CODE',
                              'ORDER_CONF_FLAG_DB', 'ORDER_CONF_FLAG', 'PACK_LIST_FLAG_DB', 'PACK_LIST_FLAG', 'PICK_LIST_FLAG_DB',
                              'PICK_LIST_FLAG', 'SUMMARIZED_SOURCE_LINES_DB', 'INTERNAL_PO_LABEL_NOTE', 'PRINT_DELIVERED_LINES', 'PRINT_DELIVERED_LINES_DB', 'MSG_SEQUENCE_NO', 
                              'MSG_VERSION_NO','CHANGED_COUNTRY_CODE', 'SUPPLY_COUNTRY', 'SUPPLY_COUNTRY_DB', 'TAX_LIABILITY', 'REPLICATE_CHANGES', 'CHANGE_REQUEST',
                              'CUSTOMS_VALUE_CURRENCY', 'JINSUI_INVOICE_DB', 'JINSUI_INVOICE', 'FREIGHT_MAP_ID', 'ZONE_ID', 'FREIGHT_PRICE_LIST_NO', 'PICKING_LEADTIME',
                              'SHIPMENT_TYPE', 'PROPOSED_PREPAYMENT_AMOUNT', 'EXPECTED_PREPAYMENT_DATE', 'PREPAYMENT_APPROVED_DB', 'PREPAYMENT_APPROVED',
                              'BLOCKED_TYPE', 'BLOCKED_TYPE_DB', 'BLOCKED_FROM_STATE', 'CUSTOMER_NO_PAY_REF', 'LIMIT_SALES_TO_ASSORTMENTS_DB', 'LIMIT_SALES_TO_ASSORTMENTS', 'INVOICE_REASON_ID'))
            THEN
               Error_SYS.Record_General(lu_name_, 'BILLED_ORDER: Invoiced orders may not be changed');
            ELSIF (name_ = 'WANTED_DELIVERY_DATE') THEN
               wanted_date_changed_ := TRUE;
            ELSIF (name_ = 'CHANGE_LINE_DATE') THEN
               line_date_will_change_ := TRUE;
            ELSIF (name_ = 'PLANNED_DELIVERY_DATE') THEN
               planned_date_changed_ := TRUE;
            ELSIF (name_ = 'SHIP_VIA_CODE') THEN
               IF (Exists_Freight_Info_Lines(newrec_.order_no)) THEN
                  Error_SYS.Record_General(lu_name_, 'FREIGHT_ORDER: Invoiced order lines connected to Freight functionality cannot be changed.');
               END IF; 
            END IF;
         END LOOP;

         IF line_date_will_change_ AND NOT (wanted_date_changed_ AND planned_date_changed_) THEN
            Error_SYS.Record_General(lu_name_, 'BILLED_ORDER: Invoiced orders may not be changed');
         END IF;  
      END IF;
   END IF;
   
   super(newrec_, indrec_, attr_);
END Unpack___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_order_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY customer_order_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
   company_           VARCHAR2(20);
   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_rec_   Supplier_API.Public_Rec;
   $END
BEGIN
   IF (newrec_.free_of_chg_tax_pay_party IS NULL) THEN
      newrec_.free_of_chg_tax_pay_party := Tax_Paying_Party_API.DB_NO_TAX;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
   -- Additional rebate customer should not be the same as the ordering customer.
   IF newrec_.customer_no = newrec_.rebate_customer THEN
      Error_SYS.Record_General(lu_name_,'ERRADDREBATECUS: The additional rebate customer may not be the same as the ordering customer.');
   END IF;
   company_ := Site_API.Get_Company(newrec_.contract);
   
   $IF Component_Purch_SYS.INSTALLED $THEN
      supplier_rec_ := Supplier_API.Get(newrec_.vendor_no);
      IF (supplier_rec_.category = 'I') THEN
         IF ((company_ = Site_API.Get_Company(supplier_rec_.acquisition_site)) AND (supplier_rec_.acquisition_site = newrec_.contract)) THEN
            Error_SYS.Record_General(lu_name_,'INTERNALSUPPLIER: The supplier :P1 is registered as the internal supplier of the site :P2 and cannot be entered as Deliver-from Supplier.', newrec_.vendor_no, newrec_.contract);
         END IF;
      END IF;
   $END
   -- gelr:fr_service_code, begin   
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'FR_SERVICE_CODE') = Fnd_Boolean_API.DB_TRUE) THEN      
      IF (newrec_.service_code IS NOT NULL AND NOT Customer_Service_Code_API.Exists(company_, newrec_.customer_no,Party_Type_API.Decode('CUSTOMER'), newrec_.service_code)) THEN
         Error_SYS.Record_General(lu_name_, 'SERVICECODENOTEXIST: Service Code :P1 does not exist for customer :P2 in company :P3.', newrec_.service_code, newrec_.customer_no, company_);
      END IF;
   END IF;
   -- gelr:fr_service_code, end
   -- gelr:accounting_xml_data, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'ACCOUNTING_XML_DATA') = Fnd_Boolean_API.DB_TRUE AND newrec_.country_code = 'MX') THEN
      IF (indrec_.tax_id_no) THEN
         IF (newrec_.tax_id_no IS NOT NULL AND LENGTH(newrec_.tax_id_no) NOT IN (12, 13)) THEN
            Client_SYS.Add_Warning(lu_name_, 'ERRORTAXIDLEN: Tax Id Number must have either 12 or 13 characters.' );
         END IF;
      END IF;
   END IF;
   -- gelr:accounting_xml_data, end
   -- gelr:brazilian_specific_attributes, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'BRAZILIAN_SPECIFIC_ATTRIBUTES') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (newrec_.business_transaction_id IS NULL ) THEN
         Error_SYS.Record_General(lu_name_, 'BUSTRANSIDMANDATORY: Business Transaction ID is mandatory');
      END IF;
      
      IF (Business_Transaction_Id_API.Get_Direction_Db(company_, newrec_.business_transaction_id) <> 'OUTBOUND') THEN
         Error_SYS.Record_General(lu_name_, 'CUSTORDBIZTR: An Outbound Business Transaction Code must be selected');
      END IF;
   END IF;
   -- gelr:brazilian_specific_attributes, end
END Check_Common___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                  VARCHAR2(30);
   value_                 VARCHAR2(4000);
   company_               VARCHAR2(20);
   source_order_          VARCHAR2(5) := NULL;
   acquisition_company_   VARCHAR2(20);
   use_pre_ship_del_note_ CUSTOMER_ORDER_TAB.use_pre_ship_del_note%TYPE;
   pick_inventory_type_   CUSTOMER_ORDER_TAB.pick_inventory_type%TYPE;
   shipment_creation_     BOOLEAN := FALSE;
   -- gelr:disc_price_rounded, begin
   true_                  VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
   false_                 VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   -- gelr:disc_price_rounded, end
   site_date_             DATE;
   customer_rec_          Cust_Ord_Customer_API.Public_Rec;
   customer_no_pay_rec_   Cust_Ord_Customer_API.Public_Rec;
BEGIN
   -- Columns NOTE_ID and PRE_ACCOUNTING_ID are set by sequence
   -- value in Insert___ procedure. However, they may be included in the
   -- attr_ string from client when duplicating records but will then be
   -- overwritten.

   company_   := Site_API.Get_Company(newrec_.contract);
   site_date_ := TRUNC(Site_API.Get_Site_Date(newrec_.contract));   
   IF newrec_.shipment_creation IS NOT NULL THEN
      shipment_creation_ := TRUE;
   END IF; 
   
   IF (NOT shipment_creation_) THEN
      newrec_.shipment_creation := Shipment_Creation_API.Encode(Shipment_Type_API.Get_Shipment_Creation_Co(NVL(Client_SYS.Get_Item_Value('SHIPMENT_TYPE', attr_), newrec_.shipment_type)));
   END IF;  
   
   IF newrec_.staged_billing IS NULL THEN
      newrec_.staged_billing := 'NOT STAGED BILLING';
   END IF;
   
   IF newrec_.sm_connection IS NULL THEN
      newrec_.sm_connection := 'NOT CONNECTED';
   END IF;
   
   IF newrec_.scheduling_connection IS NULL THEN
      newrec_.scheduling_connection := 'NOT SCHEDULE';
   END IF;
   
   IF newrec_.shipment_type IS NULL THEN
      newrec_.shipment_type := 'NA';
   END IF;
   
   IF newrec_.delivery_leadtime IS NULL THEN
      newrec_.delivery_leadtime := 0;
   END IF;
   
   IF newrec_.picking_leadtime IS NULL THEN
      newrec_.picking_leadtime := 0;
   END IF;
   
   IF newrec_.blocked_type IS NULL THEN
      newrec_.blocked_type := Customer_Order_Block_Type_API.DB_NOT_BLOCKED;
   END IF;

   IF newrec_.fix_deliv_freight IS NULL THEN
      newrec_.apply_fix_deliv_freight := 'FALSE';
   END IF;

   IF newrec_.use_price_incl_tax IS NULL THEN
      newrec_.use_price_incl_tax := Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(newrec_.customer_no, company_);
   END IF;
   
   IF newrec_.limit_sales_to_assortments IS NULL THEN
      newrec_.limit_sales_to_assortments := Customer_Assortment_Struct_API.Check_Limit_Sales_To_Assorts(newrec_.customer_no);
   END IF;

   IF (newrec_.customer_no_pay IS NULL) THEN
      IF (newrec_.customer_no_pay_addr_no IS NOT NULL) THEN
         Error_SYS.Item_Insert(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO');
      END IF;
   ELSE
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO', newrec_.customer_no_pay_addr_no);
      IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no_pay, newrec_.customer_no_pay_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
      END IF;
   END IF;   
   
   $IF Component_Conmgt_SYS.INSTALLED $THEN
      IF (indrec_.contract_item_no AND newrec_.contract_item_no IS NOT NULL) THEN  
         Contract_Item_API.Exist(newrec_.sales_contract_no, newrec_.contract_rev_seq, newrec_.contract_line_no, newrec_.contract_item_no);   
      END IF;
   $END
   
   source_order_ := Client_SYS.Get_Item_Value('SOURCE_ORDER', attr_);
      
   Error_SYS.Trim_Space_Validation(newrec_.order_no);
   
   -- gelr:disc_price_rounded, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'DISC_PRICE_ROUNDED') = true_) THEN
      newrec_.disc_price_round := true_;
   ELSE
      newrec_.disc_price_round := false_;
   END IF;
   -- gelr:disc_price_rounded, end
   
   super(newrec_, indrec_, attr_);
   
   customer_rec_        := Cust_Ord_Customer_API.Get(newrec_.customer_no);
   customer_no_pay_rec_ := Cust_Ord_Customer_API.Get(newrec_.customer_no_pay);
   
   IF (indrec_.customer_no) AND (trunc(customer_rec_.date_del) <= site_date_) THEN
      Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR: Customer has expired. Check expire date.');
   END IF;
   
   IF (indrec_.customer_no_pay) AND (trunc(customer_no_pay_rec_.date_del) <= site_date_) THEN
      Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR_PAY: Payer has expired. Check expire date.');
   END IF;
   
   IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
      Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;
   
   acquisition_company_ := Site_API.Get_Company(customer_rec_.acquisition_site);
   IF (customer_rec_.category = 'I') THEN
      IF ((company_ = acquisition_company_) AND (customer_rec_.acquisition_site = newrec_.contract)) THEN
         Error_SYS.Record_General(lu_name_,'INTERNALCUSTOMER: The customer :P1 is registered as the internal customer of the site :P2. Therefore, you cannot create a customer order for the customer from this site.', newrec_.customer_no, newrec_.contract);
      END IF;
   END IF;
   
   IF (newrec_.order_no IS NOT NULL) THEN
      -- Check for the existing Customer Order No's and Distribution Order No's
      IF Check_Exist___(newrec_.order_no) THEN
         Error_SYS.Record_Exist(lu_name_, p1_ => newrec_.order_no);
      ELSIF ((Is_Dist_Order_Exist___(newrec_.order_no) = 1) AND (source_order_ IS NULL))THEN
         Error_SYS.Record_General(lu_name_, 'DO_ERROR: Distribution Order exists with the same Customer Order No');
      END IF;
   END IF;

   -- Check for prepayment exists before a customer order is delivery confirmed.   
   IF (Customer_Order_API.Get_Proposed_Prepayment_Amount(newrec_.order_no) > 0 AND newrec_.confirm_deliveries = 'TRUE' AND (Company_Order_Info_API.Get_Allow_With_Deliv_Conf_Db(company_) = 'FALSE')) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_EXISTDEL: The required prepayment amount exists. Cannot enable the customer order for delivery confirmation when company :P1 does not allow using delivery confirmation with prepayment invoicing.', company_);
   END IF;

   User_Allowed_Site_API.Exist(Fnd_Session_API.Get_Fnd_User, newrec_.contract);

   -- Make sure the specified addresses for the order are valid.
   IF (newrec_.bill_addr_no IS NOT NULL) THEN
      IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
      END IF;

      IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDDOCADDR: Document address :P1 is invalid. Check the validity period.', newrec_.bill_addr_no);
      END IF;
   ELSE
      Client_SYS.Add_Info(lu_name_,'BILLADDRESSNULL: Document Address is not specified. This will not be reflected on documents to be printed.');
   END IF;

   IF (newrec_.ship_addr_no IS NOT NULL AND newrec_.addr_flag = 'N') THEN
      IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDELADDR: Invalid delivery address specified.');
      END IF;
      IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDDELADDR: Delivery address :P1 is invalid. Check the validity period.', newrec_.ship_addr_no);
      END IF;
   END IF;
   
   IF (newrec_.customer_no_pay IS NOT NULL) THEN
      IF (customer_no_pay_rec_.category = 'I' ) THEN
         -- Check whether the CO processing company is same as the invoicing customer's company.
         IF (company_ = Site_API.Get_Company(customer_no_pay_rec_.acquisition_site)) THEN
            IF (customer_rec_.category = 'E') THEN
               Error_SYS.Record_General(lu_name_, 'INVCUSTNOTINTCUST: The invoicing customer may not be an internal customer belonging to the same company.');
            ELSE
               -- Check whether the CO processing company is different to the CO header customer's when
               -- the CO header customer is an Internal customers.
               IF (company_ != acquisition_company_) THEN
                  Error_SYS.Record_General(lu_name_, 'INVCUSTNOTINTCUST: The invoicing customer may not be an internal customer belonging to the same company.');
               END IF;
            END IF;         
         END IF;        
      END IF;
   END IF;
   
   IF (site_date_ > Identity_Invoice_Info_API.Get_Expire_Date(company_, NVL(newrec_.customer_no_pay, newrec_.customer_no), Party_Type_API.Decode('CUSTOMER'))) THEN
      Client_SYS.Add_Info(lu_name_, 'INVCUSEXPIRED: The invoicing customer record :P1 has expired for invoicing and therefore, cannot be invoiced. ', NVL(newrec_.customer_no_pay, newrec_.customer_no));
   END IF;

   Validate_Customer_Agreement___(newrec_.agreement_id, newrec_.contract, newrec_.customer_no, newrec_.currency_code);

   -- Return COMPANY to client.
   IF Client_SYS.Item_Exist('COMPANY', attr_) THEN
      Client_SYS.Set_Item_Value('COMPANY', company_, attr_);
   ELSE
      Client_SYS.Add_To_Attr('COMPANY', company_, attr_);
   END IF;

   --Return delivery_leadtime to client.
   IF Client_SYS.Item_Exist('DELIVERY_LEADTIME', attr_) THEN
      Client_SYS.Set_Item_Value('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
   ELSE
      Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', newrec_.delivery_leadtime, attr_);
   END IF;
  
   -- Check that additional discount is between 0 % and 100 %.
   IF (newrec_.additional_discount < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT1: Additional Discount % should be greater than 0.');
   ELSIF NOT (newrec_.additional_discount <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT2: Additional Discount should not exceed 100 %.');
   END IF;

   IF (newrec_.additional_discount IS NULL) THEN
       newrec_.additional_discount := 0;
   END IF;
   
   IF (newrec_.forward_agent_id IS NOT NULL AND newrec_.freight_map_id IS NOT NULL) THEN
      newrec_.freight_price_list_no := Freight_Price_List_Base_API.Get_Active_Freight_List_No(newrec_.contract, 
                                                                                              newrec_.ship_via_code,
                                                                                              newrec_.freight_map_id,
                                                                                              newrec_.forward_agent_id,
                                                                                              newrec_.use_price_incl_tax );
                                                                                             
   END IF;

   -- Validate Delivery Confirmation
   IF (newrec_.confirm_deliveries = 'TRUE') THEN
      -- staged billing
      IF (newrec_.staged_billing = 'STAGED BILLING') OR (Order_Line_Staged_Billing_API.Order_Uses_Stage_Billing(newrec_.order_no) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'STAGEDBILL_DC: Not allowed to use Staged Billing together with Delivery Confirmation.');
      END IF;
   END IF;

   use_pre_ship_del_note_ := Site_Discom_Info_API.Get_Use_Pre_Ship_Del_Note_Db(newrec_.contract);
   pick_inventory_type_   := Cust_Order_Type_API.Get_Pick_Inventory_Type_Db(newrec_.order_id);

   IF (pick_inventory_type_ = 'ORDINV' AND use_pre_ship_del_note_ ='TRUE') THEN
      use_pre_ship_del_note_ := 'FALSE';
   END IF;
   newrec_.use_pre_ship_del_note := use_pre_ship_del_note_;
   newrec_.pick_inventory_type   := pick_inventory_type_;

   -- Validate Jinsui Invoice.
   $IF Component_Jinsui_SYS.INSTALLED $THEN
      Validate_Jinsui_Constraints___(newrec_, newrec_);
   $END   
   
   Cust_Ord_Customer_API.Validate_Customer_Calendar(newrec_.customer_no, newrec_.cust_calendar_id, TRUE);      

   IF (newrec_.ext_transport_calendar_id IS NOT NULL) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;

   -- Validate apply_fix_deliv_freight
   IF (newrec_.apply_fix_deliv_freight = 'TRUE') THEN
      IF (Order_Delivery_Term_API.Get_Calculate_Freight_Charge(newrec_.delivery_terms) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTUPDFIXDELFRE: In order to apply fixed delivery freight, there should be a delivery term where Calculate Freight Charge check box is selected.');
      END IF;
   END IF;
   IF (NOT Customer_Tax_Info_API.Exists(newrec_.customer_no, newrec_.ship_addr_no, company_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTAXFORADDR: Customer Tax Information has not been defined for the delivery address.');
   END IF;
   Tax_Handling_Order_Util_API.Validate_Calc_Base_In_Struct(company_, newrec_.customer_no, newrec_.ship_addr_no, newrec_.supply_country, newrec_.use_price_incl_tax, newrec_.tax_liability);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_order_tab%ROWTYPE,
   newrec_ IN OUT customer_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                       VARCHAR2(30);
   value_                      VARCHAR2(4000);   
   work_day_                   DATE := NULL;
   company_                    VARCHAR2(20);
   change_line_date_           VARCHAR2(20);
   new_wanted_delivery_date_   DATE;
   new_planned_delivery_date_  DATE;
   new_delivery_date_          DATE := NULL;
   source_order_               VARCHAR2(5);
   set_cogs_flag_              BOOLEAN := FALSE;
   replicate_changes_          VARCHAR2(5);
   change_request_             VARCHAR2(5);
   price_effec_date_changed_   VARCHAR2(5) := 'FALSE';
   cust_cal_value_set_         BOOLEAN := TRUE;
   supply_country_             VARCHAR2(200);
   shipment_creation_          BOOLEAN := FALSE;
   allow_with_deliv_conf_      Company_Order_Info_TAB.allow_with_deliv_conf%TYPE;   
   disconnect_exp_license_     VARCHAR2(5);
   changed_attrib_not_in_pol_  VARCHAR2(5);
   customer_no_                customer_order_tab.customer_no%TYPE;   
   addr_no_                    customer_order_tab.bill_addr_no%TYPE;
   site_date_                  DATE;
   site_rec_                   Site_API.Public_Rec;
   customer_rec_               Cust_Ord_Customer_API.Public_Rec;
   customer_no_pay_rec_        Cust_Ord_Customer_API.Public_Rec;
   identity_invoice_info_rec_  Identity_Invoice_Info_API.Public_Rec;
BEGIN
   supply_country_ := newrec_.supply_country;
   ISO_Country_API.Exist(supply_country_);
   
   site_rec_  := Site_API.Get(newrec_.contract);
   company_   := site_rec_.company;
   site_date_ := TRUNC(Site_API.Get_Site_Date(newrec_.contract));

   -- B2B Process Online: Get Delivery Information
   IF Client_SYS.Get_Item_Value('B2B_PROCESS_ONLINE', attr_) = 'TRUE' THEN
      Get_B2b_Delivery_Info___(oldrec_, newrec_);
   END IF;
      
   -- Check if wanted_delivery_date should be changed on all order lines.
   -- This method is called before any updates on the order head are made, because all info messages are
   -- deleted by running this method.
   change_line_date_ := Client_SYS.Get_Item_Value('CHANGE_LINE_DATE', attr_);
   IF (change_line_date_ IS NOT NULL) THEN
      new_wanted_delivery_date_  := newrec_.wanted_delivery_date; 
      new_planned_delivery_date_ := Client_SYS.Attr_Value_To_Date(Client_SYS.Get_Item_Value('PLANNED_DELIVERY_DATE', attr_));
      replicate_changes_         := Client_SYS.Get_Item_Value('REPLICATE_CHANGES', attr_); 
      change_request_            := Client_SYS.Get_Item_Value('CHANGE_REQUEST', attr_);
      changed_attrib_not_in_pol_ := Client_SYS.Get_Item_Value('CHANGED_ATTRIB_NOT_IN_POL', attr_);
      
      IF (Client_SYS.Get_Item_Value('UPDATE_PRICE_EFFECTIVE_DATE', attr_) = 'TRUE') THEN
         price_effec_date_changed_ := 'TRUE';
      END IF;

      disconnect_exp_license_ := Client_SYS.Get_Item_Value('DISCONNECT_EXP_LICENSE', attr_);
      Modify_Wanted_Delivery_Date__(newrec_.order_no, 
                                    new_wanted_delivery_date_, 
                                    new_planned_delivery_date_, 
                                    replicate_changes_, 
                                    change_request_, 
                                    Client_SYS.Get_Item_Value('DOP_NEW_QTY_DEMAND', attr_), 
                                    price_effec_date_changed_, 
                                    disconnect_exp_license_,
                                    changed_attrib_not_in_pol_);
   END IF;
   
   IF (newrec_.fix_deliv_freight IS NULL) THEN
      newrec_.apply_fix_deliv_freight := 'FALSE';
   END IF;
   
   IF NOT indrec_.cust_calendar_id THEN
      cust_cal_value_set_ := FALSE;
   END IF;
   
   IF indrec_.confirm_deliveries THEN
      set_cogs_flag_ := TRUE;
   END IF;
   
   IF newrec_.shipment_creation IS NOT NULL AND indrec_.shipment_creation THEN
      shipment_creation_ := TRUE;
   END IF;   
 
   -- delay_cogs_to_deliv_conf is only updateable through Confirm Deliveries flag - validated below
   -- Note: Set indrec_.delay_cogs_to_deliv_conf to FALSE to avoid check Exist in Check_Common___
   indrec_.delay_cogs_to_deliv_conf := FALSE;
   
   super(oldrec_, newrec_, indrec_, attr_); 
   
   customer_rec_        := Cust_Ord_Customer_API.Get(newrec_.customer_no);
   customer_no_pay_rec_ := Cust_Ord_Customer_API.Get(newrec_.customer_no_pay);
   
   IF indrec_.customer_no_pay THEN
      IF (trunc(customer_no_pay_rec_.date_del) < site_date_) THEN
         Error_SYS.Record_General(lu_name_, 'DATE_EXP_ERROR_PAY: Payer has expired. Check expire date.');
      END IF;
   END IF;
   
   IF ((NVL(oldrec_.vendor_no, ' ') != NVL(newrec_.vendor_no, ' ')) AND (newrec_.rowstate IN ('Delivered', 'Invoiced', 'Cancelled'))) THEN
      Error_SYS.Record_General(lu_name_, 'CANNOTMODIFYSUPP1: The deliver-from supplier cannot be changed for a Delivered, Invoiced/Closed or Cancelled order.');
   END IF;

   IF (newrec_.picking_leadtime != trunc(newrec_.picking_leadtime)) OR (newrec_.picking_leadtime < 0) THEN
      Error_SYS.Item_General(lu_name_, 'PICKING_LEADTIME', 'PICKVALUEINTEGER: [:NAME] must be an integer. Negative values not allowed.');
   END IF;

   source_order_ := NVL(source_order_, 'ORDER');
   IF (newrec_.customer_no_pay IS NULL) THEN
      IF (newrec_.customer_no_pay_addr_no IS NOT NULL) THEN
         Error_SYS.Item_Update(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO');
      END IF;
   ELSE
      Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_NO_PAY_ADDR_NO', newrec_.customer_no_pay_addr_no);
      IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no_pay, newrec_.customer_no_pay_addr_no) = 0) THEN
         Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
      END IF;
   END IF;
   
   identity_invoice_info_rec_ := Identity_Invoice_Info_API.Get(company_, NVL(newrec_.customer_no_pay, newrec_.customer_no), Party_Type_API.DB_CUSTOMER);
   
   IF (indrec_.pay_term_id) THEN
      IF (identity_invoice_info_rec_.pay_term_id IS NULL) THEN
         Raise_No_Pay_Terms_Error___(newrec_.customer_no, newrec_.customer_no_pay);
      END IF; 
   END IF;   
   allow_with_deliv_conf_ := Company_Order_Info_API.Get_Allow_With_Deliv_Conf_Db(company_);
   
   -- Check for prepayment exists before a customer order is delivery confirmed.   
   IF (Customer_Order_API.Get_Proposed_Prepayment_Amount(newrec_.order_no) > 0 AND newrec_.confirm_deliveries = 'TRUE' AND allow_with_deliv_conf_ = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_EXISTDEL: The required prepayment amount exists. Cannot enable the customer order for delivery confirmation when company :P1 does not allow using delivery confirmation with prepayment invoicing.', company_);
   END IF;

   -- Make sure the specified addresses for the order are valid.
   IF (newrec_.bill_addr_no IS NOT NULL) THEN
      IF (NVL(oldrec_.bill_addr_no, ' ') != NVL(newrec_.bill_addr_no, ' ')) THEN
         IF (Cust_Ord_Customer_Address_API.Is_Bill_Location(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOTDOCADDR: Invalid document address specified.');
         END IF;
         IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.bill_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDDOCADDR: Document address :P1 is invalid. Check the validity period.', newrec_.bill_addr_no);
         END IF;
      END IF;
   END IF;

   IF (newrec_.ship_addr_no IS NOT NULL) THEN
      IF ((newrec_.addr_flag = 'N') AND (NVL(newrec_.ship_addr_no, ' ') != NVL(oldrec_.ship_addr_no, ' ') OR (oldrec_.addr_flag = 'Y'))) THEN
         IF (Cust_Ord_Customer_Address_API.Is_Ship_Location(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'NOTDELADDR: Invalid delivery address specified.');
         END IF;

         IF (Cust_Ord_Customer_Address_API.Is_Valid(newrec_.customer_no, newrec_.ship_addr_no) = 0) THEN
            Error_SYS.Record_General(lu_name_, 'INVALIDDELADDR: Delivery address :P1 is invalid. Check the validity period.', newrec_.ship_addr_no);
         END IF;
      END IF;

      IF (NVL(newrec_.ship_addr_no, ' ') != NVL(oldrec_.ship_addr_no, ' ')) THEN
         Check_Consign_Stock_Lines___(newrec_.order_no, newrec_.ship_addr_no);
         newrec_.country_code := Cust_Ord_Customer_Address_API.Get_Country_Code(newrec_.customer_no, newrec_.ship_addr_no);
         Client_SYS.Set_Item_Value('COUNTRY_CODE', newrec_.country_code, attr_);
         IF (newrec_.customer_no_pay IS NOT NULL) THEN
            customer_no_:= newrec_.customer_no_pay;
            addr_no_    := newrec_.customer_no_pay_addr_no;
         ELSE
            customer_no_:= newrec_.customer_no;
            addr_no_    := newrec_.bill_addr_no;         
         END IF;        
         newrec_.tax_id_no := Customer_Document_Tax_Info_API.Get_Vat_No_Db(customer_no_,
                                                                        addr_no_,
                                                                        company_,
                                                                        supply_country_,
                                                                        newrec_.country_code);
         Client_SYS.Set_Item_Value('TAX_ID_NO', newrec_.tax_id_no, attr_);

         IF (newrec_.tax_id_no IS NOT NULL) THEN
            newrec_.tax_id_validated_date := Tax_Handling_Order_Util_API.Get_Tax_Id_Validated_Date(newrec_.customer_no_pay,
                                                                                                   newrec_.customer_no_pay_addr_no,
                                                                                                   newrec_.customer_no,
                                                                                                   newrec_.bill_addr_no,
                                                                                                   company_,
                                                                                                   supply_country_,
                                                                                                   newrec_.country_code);
            Client_SYS.Set_Item_Value('TAX_ID_VALIDATED_DATE', newrec_.tax_id_validated_date, attr_);
         END IF;
      END IF;

   END IF;

   IF (oldrec_.proposed_prepayment_amount != newrec_.proposed_prepayment_amount) THEN
      Validate_Proposed_Prepay___(newrec_.order_no, newrec_.proposed_prepayment_amount);
   END IF;
   
   IF (NVL(newrec_.customer_no_pay, Database_SYS.string_null_) != NVL(oldrec_.customer_no_pay, Database_SYS.string_null_)) THEN
      IF(newrec_.customer_no_pay IS NOT NULL) THEN
         IF (identity_invoice_info_rec_.pay_term_id IS NULL) THEN
            Raise_No_Pay_Terms_Error___(newrec_.customer_no, newrec_.customer_no_pay);
         END IF; 
         IF (customer_no_pay_rec_.category = 'I' ) THEN
            -- Check whether the CO processing company is same as the invoicing customer's company.
            IF (company_ = Site_API.Get_Company(customer_no_pay_rec_.acquisition_site)) THEN
               IF (customer_rec_.category = 'E') THEN
                  Error_SYS.Record_General(lu_name_, 'INVCUSTNOTINTCUST: The invoicing customer may not be an internal customer belonging to the same company.');
               ELSE
                  -- Check whether the CO processing company is different to the CO header customer's when
                  -- the CO header customer is an Internal customers.
                  IF (company_ != Site_API.Get_Company(customer_rec_.acquisition_site)) THEN
                     Error_SYS.Record_General(lu_name_, 'INVCUSTNOTINTCUST: The invoicing customer may not be an internal customer belonging to the same company.');
                  END IF;
               END IF;         
            END IF;        
         END IF;
      END IF;
      IF (site_date_ > identity_invoice_info_rec_.expire_date) THEN
         Client_SYS.Add_Info(lu_name_, 'INVCUSEXPIRED: The invoicing customer record :P1 has expired for invoicing and therefore, cannot be invoiced. ', NVL(newrec_.customer_no_pay, newrec_.customer_no));
      END IF;
   END IF;

   -- Validate agreement if changed
   IF ((NVL(oldrec_.agreement_id, ' ') != NVL(newrec_.agreement_id, ' ')) AND (newrec_.agreement_id IS NOT NULL)) THEN
      Validate_Customer_Agreement___(newrec_.agreement_id, newrec_.contract, newrec_.customer_no, newrec_.currency_code);
   END IF;

   IF (NVL(newrec_.ext_transport_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.ext_transport_calendar_id, Database_Sys.string_null_)) THEN
      Work_Time_Calendar_API.Check_Not_Generated(newrec_.ext_transport_calendar_id);
   END IF;

   -- IF delivery leadtime or picking leadtime was changed check delivery date
   IF ((oldrec_.delivery_leadtime != newrec_.delivery_leadtime) OR (oldrec_.picking_leadtime != newrec_.picking_leadtime) 
       OR NVL(newrec_.ext_transport_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.ext_transport_calendar_id, Database_Sys.string_null_)) THEN

      work_day_ := Work_Time_Calendar_API.Get_End_Date(site_rec_.dist_calendar_id, site_date_, newrec_.picking_leadtime);
          
      -- Add default time from delivery address
      work_day_ := Construct_Delivery_Time___(work_day_, newrec_.customer_no, newrec_.ship_addr_no, newrec_.addr_flag);
      Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(new_delivery_date_, newrec_.ext_transport_calendar_id, work_day_, newrec_.delivery_leadtime);
      IF (new_delivery_date_ > newrec_.wanted_delivery_date) THEN
         Client_SYS.Add_Info(lu_name_, 'NEW_DELIV_DATE: The earliest possible delivery date with the current external transport lead time is :P1.', to_char(new_delivery_date_, 'YYYY-MM-DD'));
      END IF;
   END IF;

   -- Check that additional discount is between 0 % and 100 %.
   IF (newrec_.additional_discount < 0) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT1: Additional Discount % should be greater than 0.');
   ELSIF NOT (newrec_.additional_discount <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_DISCOUNT2: Additional Discount should not exceed 100 %.');
   END IF;

   IF (newrec_.additional_discount IS NULL) THEN
       newrec_.additional_discount := 0;
   END IF;
   -- Check the line discount totals
   IF (newrec_.additional_discount > 0) THEN
      Customer_Order_Line_API.Check_Line_Total_Discount_pct(newrec_.order_no,newrec_.additional_discount);
   END IF;

   IF (newrec_.backorder_option != oldrec_.backorder_option) THEN
      IF (newrec_.backorder_option IN ('INCOMPLETE PACKAGES NOT ALLOWED', 'ALLOW INCOMPLETE LINES AND PACKAGES')) THEN
         Block_Backorder_For_Eso___ (newrec_.order_no);
      END IF;
   END IF;

   IF (NVL(oldrec_.project_id, '*') != NVL(newrec_.project_id, '*')) THEN
      Validate_Proj_Connect___(newrec_.order_no, newrec_.project_id);
      IF (newrec_.project_id IS NULL) THEN
         Validate_Proj_Disconnect___(newrec_.order_no, oldrec_.project_id);
      END IF;
   END IF;

   IF ((NVL(oldrec_.sales_contract_no, '*') != NVL(newrec_.sales_contract_no,'*')) OR
       (NVL(oldrec_.contract_rev_seq,-999)  != NVL(newrec_.contract_rev_seq,-999)) OR
       (NVL(oldrec_.contract_line_no,-999)  != NVL(newrec_.contract_line_no,-999)) OR
       (NVL(oldrec_.contract_item_no,-999)  != NVL(newrec_.contract_item_no,-999))) THEN
      Validate_Sales_Contract___(oldrec_, newrec_);
   END IF;

   -- Delivery Confirmation settings can be changed as long as the status is Planned, Released, Reserved or Picked.
   IF (newrec_.rowstate NOT IN ('Planned', 'Released', 'Reserved', 'Picked')) THEN
      IF ((newrec_.confirm_deliveries != oldrec_.confirm_deliveries) OR
          (newrec_.check_sales_grp_deliv_conf != oldrec_.check_sales_grp_deliv_conf) OR
          (newrec_.delay_cogs_to_deliv_conf != oldrec_.delay_cogs_to_deliv_conf)) THEN
         Error_SYS.Record_General(lu_name_, 'DELIVCONFUPD: Delivery Confirmation Information cannot be changed when order has status ":P1".', Finite_State_Decode__(newrec_.rowstate));
      END IF;
   END IF;

  IF ((newrec_.confirm_deliveries = 'TRUE') AND (allow_with_deliv_conf_ = 'FALSE')) THEN
      IF (Customer_Invoice_Pub_Util_API.Has_Adv_Inv(newrec_.order_no) = 'TRUE') THEN         
         Error_SYS.Record_General(lu_name_, 'ADVINVOICE_DC: Company :P1 does not allow using delivery confirmation when there are created advance invoices.', company_);
      END IF;
   END IF;
     
   -- staged billing
   IF (newrec_.confirm_deliveries = 'TRUE') THEN
      IF (newrec_.staged_billing = 'STAGED BILLING') OR (Order_Line_Staged_Billing_API.Order_Uses_Stage_Billing(newrec_.order_no) = 1) THEN
         Error_SYS.Record_General(lu_name_, 'STAGEDBILL_DC: Not allowed to use Staged Billing together with Delivery Confirmation.');
      END IF;
   END IF;

   -- Delivery Confirmation settings can be changed as long as the status is Planned, Released, Reserved or Picked.
   IF (newrec_.rowstate IN ('Planned', 'Released', 'Reserved', 'Picked')) THEN
      -- check all lines for valid delivery confirmation settings
      IF ((newrec_.confirm_deliveries != oldrec_.confirm_deliveries) OR
          (newrec_.check_sales_grp_deliv_conf != oldrec_.check_sales_grp_deliv_conf)) THEN
         CUSTOMER_ORDER_LINE_API.Validate_Delivery_Conf__(newrec_.order_no, newrec_.confirm_deliveries, newrec_.check_sales_grp_deliv_conf);
      END IF;

      IF set_cogs_flag_ THEN
         -- if Delivery Confirmation is not required - we don't have to delay COGS.
         IF (newrec_.confirm_deliveries = 'FALSE') THEN
            newrec_.delay_cogs_to_deliv_conf := 'FALSE';
         -- fetch Delay COGS value from Company
         ELSE
            newrec_.delay_cogs_to_deliv_conf := Company_Order_Info_API.Get_Delay_Cogs_To_Deliv_Con_Db(company_);
         END IF;
      END IF;
   END IF;

   -- Validate Jinsui Invoice.
   $IF Component_Jinsui_SYS.INSTALLED $THEN
      Validate_Jinsui_Constraints___(oldrec_, newrec_);
   $END 

   Client_SYS.Add_To_Attr('DELAY_COGS_TO_DELIV_CONF_DB', newrec_.delay_cogs_to_deliv_conf, attr_);
   Client_SYS.Add_To_Attr('SOURCE_ORDER', source_order_, attr_);

   IF (NVL(oldrec_.route_id, ' ') != NVL(newrec_.route_id, ' ')) THEN
      Check_Route_Updates___(newrec_.order_no);
   END IF;
   
   IF (Shipment_Line_API.Shipment_Connected_Lines_Exist(newrec_.order_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = 1) THEN
      IF (oldrec_.supply_country != newrec_.supply_country) THEN 
         Error_SYS.Record_General(lu_name_, 'SHIPCONNLINESEXIST: Supply country cannot be changed when one or more order lines are connected to shipment(s).');
      END IF;
   END IF;

   -- Checking existancy of a shipment connection
   IF ((oldrec_.addr_flag != newrec_.addr_flag) OR (nvl(oldrec_.ship_addr_no, ' ') != nvl(newrec_.ship_addr_no, ' ')) OR
       (nvl(oldrec_.ship_via_code, ' ') != nvl(newrec_.ship_via_code, ' ')) OR (oldrec_.delivery_terms != newrec_.delivery_terms) OR
       (oldrec_.shipment_type != newrec_.shipment_type) OR
       (nvl(oldrec_.del_terms_location, ' ') != nvl(newrec_.del_terms_location, ' ')) OR
       (nvl(oldrec_.route_id, ' ') != nvl(newrec_.route_id, ' ')) OR
       (nvl(oldrec_.forward_agent_id, ' ') != nvl(newrec_.forward_agent_id, ' ')) OR
       (nvl(oldrec_.customs_value_currency, ' ') != nvl(newrec_.customs_value_currency, ' '))) THEN
      IF (Shipment_Handling_Utility_API.Any_Shipment_Connected_Lines(newrec_.order_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER) = 'TRUE') THEN         
         Client_SYS.Add_Warning(lu_name_, 'SHIPCONN: One or more order lines are connected to shipment(s). Note that the delivery information must be changed manually for each shipment connected to the changed customer order');         
      END IF;
      IF (oldrec_.shipment_type != newrec_.shipment_type) AND (NOT shipment_creation_) THEN
         newrec_.shipment_creation := Shipment_Creation_API.Encode(Shipment_Type_API.Get_Shipment_Creation_Co(newrec_.shipment_type));        
      END IF;
   END IF;
   -- Checking the prepayment approval
   IF(newrec_.prepayment_approved ='TRUE')THEN
      IF (newrec_.proposed_prepayment_amount = 0) THEN
         Error_SYS.Record_General(lu_name_, 'PREPAY_CANNTZERO: The customer can only agree with a required prepayment greater than zero.');
      END IF;
   END IF;

   IF (newrec_.rowstate != 'Planned') THEN
      IF (NVL(oldrec_.sales_contract_no, 0) != NVL(newrec_.sales_contract_no, 0)) OR
         (NVL(oldrec_.contract_rev_seq, 0)  != NVL(newrec_.contract_rev_seq, 0))  OR
         (NVL(oldrec_.contract_line_no, 0)  != NVL(newrec_.contract_line_no, 0))  OR
         (NVL(oldrec_.contract_item_no, 0)  != NVL(newrec_.contract_item_no, 0))  THEN
         Error_Sys.Record_General(lu_name_, 'SALECONMODIFY: The sales contract reference cannot be updated once the order is released.'); 
      END IF;      
   END IF;

   IF (NVL(newrec_.ship_addr_no, Database_Sys.string_null_) != NVL(oldrec_.ship_addr_no, Database_Sys.string_null_) AND cust_cal_value_set_ = FALSE) THEN
      newrec_.cust_calendar_id := Cust_Ord_Customer_Address_API.Get_Cust_Calendar_Id(newrec_.customer_no, newrec_.ship_addr_no); 
   END IF;
   
   IF (NVL(newrec_.cust_calendar_id, Database_Sys.string_null_) != NVL(oldrec_.cust_calendar_id, Database_Sys.string_null_)) THEN
      Cust_Ord_Customer_API.Validate_Customer_Calendar(newrec_.customer_no, newrec_.cust_calendar_id, TRUE);
   END IF;

   -- Validate apply_fix_deliv_freight
   IF (newrec_.apply_fix_deliv_freight != oldrec_.apply_fix_deliv_freight) OR (newrec_.delivery_terms != oldrec_.delivery_terms) THEN
      IF (newrec_.apply_fix_deliv_freight = 'TRUE') AND (Order_Delivery_Term_API.Get_Calculate_Freight_Charge(newrec_.delivery_terms) = 'FALSE') THEN
         Error_SYS.Record_General(lu_name_, 'CANNOTUPDFIXDELFRE: In order to apply fixed delivery freight, there should be a delivery term where Calculate Freight Charge check box is selected.');
      END IF;
   END IF;
 
   Tax_Handling_Order_Util_API.Validate_Calc_Base_In_Struct(company_, newrec_.customer_no, newrec_.ship_addr_no, newrec_.supply_country, newrec_.use_price_incl_tax, newrec_.tax_liability);
   
   -- gelr:brazilian_specific_attributes, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'BRAZILIAN_SPECIFIC_ATTRIBUTES') = Fnd_Boolean_API.DB_TRUE) THEN
      IF newrec_.rowstate != 'Planned' AND (NVL(newrec_.business_transaction_id, Database_Sys.string_null_) != NVL(oldrec_.business_transaction_id, Database_Sys.string_null_)) THEN
         Error_SYS.Record_General(lu_name_, 'BUSTRANSIDMODIFY: Business transaction ID cannot be updated once the order is released.');
      END IF;
   END IF;
   -- gelr:brazilian_specific_attributes, end
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUSTOMER_ORDER_TAB%ROWTYPE )
IS  
BEGIN  
   super(remrec_);   
   -- Check Shipment exist for the given customer order
   Shipment_API.Check_Exist_By_Source_Ref1(lu_name_, Sender_Receiver_Type_API.DB_CUSTOMER, remrec_.order_no, Logistics_Source_Ref_Type_API.DB_CUSTOMER_ORDER);    
END Check_Delete___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customer_order_tab%ROWTYPE )
IS
BEGIN
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      -- Remove the representatives
      Bus_Obj_Representative_API.Remove(remrec_.order_no, Business_Object_Type_API.DB_CUSTOMER_ORDER);
   $END   
   super(objid_, remrec_);  
END Delete___;

-- Build_Attr_For_New___ 
-- This method is used to build the attr_ which is used in method New. 
FUNCTION Build_Attr_For_New___ (	
   attr_       IN  VARCHAR2  ) RETURN VARCHAR2
IS
   new_attr_                  VARCHAR2(32000);
   ptr_                       NUMBER;
   name_                      VARCHAR2(30);
   value_                     VARCHAR2(4000);
   supply_country_db_         VARCHAR2(2);
   supply_country_            VARCHAR2(200);
   customer_no_               VARCHAR2(20);
   use_price_incl_tax_db_     VARCHAR2(20);
   contract_                  VARCHAR2(5);
   free_of_chg_tax_pay_party_ VARCHAR2(20);
   company_                   VARCHAR2(20);
BEGIN
   -- Retrieve the default attribute values.
   Prepare_Insert___(new_attr_);
   --Replace the default attribute values with the ones passed in the inparameterstring.
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
      IF (name_ = 'SUPPLY_COUNTRY_DB') THEN
         supply_country_db_ := value_;
      ELSIF (name_ = 'SUPPLY_COUNTRY') THEN
         supply_country_ := value_;
      ELSIF (name_ = 'CUSTOMER_NO') THEN
         customer_no_ := value_;
      ELSIF (name_ = 'USE_PRICE_INCL_TAX_DB') THEN
         use_price_incl_tax_db_ := value_;
      ELSIF (name_ = 'FREE_OF_CHG_TAX_PAY_PARTY_DB') THEN
         free_of_chg_tax_pay_party_ := value_;
      END IF;
      
   END LOOP;

   contract_ := Client_SYS.Get_Item_Value('CONTRACT', new_attr_);

   IF ((supply_country_db_ IS NULL) AND (supply_country_ IS NULL)) THEN
      IF (contract_ IS NOT NULL) THEN
         Client_SYS.Set_Item_Value('SUPPLY_COUNTRY', Company_Site_API.Get_Country(contract_), new_attr_);
      END IF;
   ELSE
      IF (supply_country_ IS NULL) THEN
         Client_SYS.Set_Item_Value('SUPPLY_COUNTRY', ISO_Country_API.Decode(supply_country_db_), new_attr_);
      END IF;
   END IF;
   
   company_ := Site_API.Get_Company(contract_);
   IF (use_price_incl_tax_db_ IS NULL) THEN
      Client_SYS.Set_Item_Value('USE_PRICE_INCL_TAX_DB', Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(customer_no_, company_), new_attr_);
   END IF;
   
   IF (free_of_chg_tax_pay_party_ IS NULL) AND (contract_ IS NOT NULL) THEN
      free_of_chg_tax_pay_party_ := Company_Tax_Discom_Info_API.Get_Tax_Paying_Party_Db(company_);
   END IF;
   
   IF (free_of_chg_tax_pay_party_ IS NOT NULL) THEN
      Client_SYS.Set_Item_Value('FREE_OF_CHG_TAX_PAY_PARTY_DB', free_of_chg_tax_pay_party_, new_attr_);
   END IF;

   RETURN new_attr_;
END Build_Attr_For_New___;

FUNCTION Check_No_Def_Info_Src_Lines___ (   
   rec_         IN CUSTOMER_ORDER_TAB%ROWTYPE ) RETURN VARCHAR2
IS
   source_order_no_         VARCHAR2(15); 
   source_line_no_          VARCHAR2(10); 
   source_rel_no_           VARCHAR2(4); 
   source_line_item_no_     NUMBER;
   source_type_             VARCHAR2(25);
   current_line_no_         VARCHAR2(10);
   current_rel_no_          VARCHAR2(4); 
   current_line_item_no_    NUMBER;
   demand_code_             VARCHAR2(20);
   supply_code_             VARCHAR2(3);
   no_default_info_lines_   VARCHAR2(5) := 'FALSE';
   
   -- Need to get details of a single record. Then it can be used for finding the source order.   
   CURSOR get_line_details_ (order_no_ IN VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no, demand_code, supply_code
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND (demand_code = 'IPD' OR (supply_code = 'IPD' AND demand_code IS NULL));
      
BEGIN   
   OPEN get_line_details_ (rec_.order_no);
   FETCH get_line_details_ INTO current_line_no_, current_rel_no_, current_line_item_no_, demand_code_, supply_code_;
   CLOSE get_line_details_;
   
   IF (demand_code_ = 'IPD') THEN
      -- Comes here if it is an intermediate site.
      Supply_Order_Analysis_API.Find_Source(source_order_no_,
                                            source_line_no_,
                                            source_rel_no_,
                                            source_line_item_no_,
                                            source_type_,
                                            rec_.order_no,
                                            current_line_no_,
                                            current_rel_no_,
                                            current_line_item_no_,
                                            'CUSTOMER_ORDER');
                                            
      no_default_info_lines_ := Check_No_Default_Info_Lines(source_order_no_);       
   END IF;
   
   IF (supply_code_ = 'IPD' AND demand_code_ IS NULL) THEN
      -- Comes here if it is the demand site.
      no_default_info_lines_ := 'TRUE';
   END IF;
   
   RETURN no_default_info_lines_;   
   
END Check_No_Def_Info_Src_Lines___;

PROCEDURE Recalculate_Tax_Lines___ (   
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   rel_no_              IN VARCHAR2,
   line_item_no_        IN NUMBER,
   company_             IN VARCHAR2,
   contract_            IN VARCHAR2,
   supply_country_db_   IN VARCHAR2,
   customer_no_         IN VARCHAR2,
   ship_addr_no_        IN VARCHAR2,   
   use_price_incl_tax_  IN VARCHAR2,
   currency_code_       IN VARCHAR2,   
   conv_factor_         IN NUMBER,
   attr_                IN VARCHAR2)
IS 
   source_key_rec_      Tax_Handling_Util_API.source_key_rec;
   tax_line_param_rec_  Tax_Handling_Order_Util_API.tax_line_param_rec;
   order_line_rec_      Customer_Order_Line_API.Public_Rec;
   external_tax_calc_method_ VARCHAR2(50);
BEGIN
   source_key_rec_     := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                                      order_no_, 
                                                                      line_no_, 
                                                                      rel_no_, 
                                                                      line_item_no_,
                                                                      '*', 
                                                                      attr_);
                                                                      
   order_line_rec_     := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);
   
   tax_line_param_rec_ := Tax_Handling_Order_Util_API.Create_Tax_Line_Param_Rec (company_                   => company_,
                                                                                 contract_                  => contract_,
                                                                                 customer_no_               => customer_no_,
                                                                                 ship_addr_no_              => ship_addr_no_,
                                                                                 planned_ship_date_         => order_line_rec_.planned_ship_date,
                                                                                 supply_country_db_         => supply_country_db_,
                                                                                 delivery_type_             => order_line_rec_.delivery_type,
                                                                                 object_id_                 => order_line_rec_.catalog_no,
                                                                                 use_price_incl_tax_        => use_price_incl_tax_,
                                                                                 currency_code_             => currency_code_,
                                                                                 currency_rate_             => order_line_rec_.currency_rate,                                                                                       
                                                                                 conv_factor_               => conv_factor_,
                                                                                 from_defaults_             => FALSE,
                                                                                 tax_code_                  => NULL,
                                                                                 tax_calc_structure_id_     => NULL,
                                                                                 tax_class_id_              => NULL,
                                                                                 tax_liability_             => order_line_rec_.tax_liability,
                                                                                 tax_liability_type_db_     => order_line_rec_.tax_liability_type,
                                                                                 delivery_country_db_       => order_line_rec_.country_code,
                                                                                 add_tax_lines_             => TRUE,
                                                                                 net_curr_amount_           => NULL,
                                                                                 gross_curr_amount_         => NULL, 
                                                                                 ifs_curr_rounding_         => NULL,
                                                                                 free_of_charge_tax_basis_  => order_line_rec_.free_of_charge_tax_basis,
                                                                                 attr_                      => attr_);

   Tax_Handling_Order_Util_API.Recalculate_Tax_Lines (source_key_rec_,
                                                      tax_line_param_rec_,
                                                      attr_);
END Recalculate_Tax_Lines___;


PROCEDURE Recal_Tax_Lines_Add_Disc___ (
   newrec_     IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,   
   attr_        IN VARCHAR2)
IS
   company_                     VARCHAR2(20);
   CURSOR get_ord_lines IS
     SELECT line_no, rel_no, line_item_no, price_conv_factor
     FROM  customer_order_line_tab
     WHERE order_no = newrec_.order_no
     AND   rowstate NOT IN ('Cancelled', 'Invoiced');
BEGIN   
   company_ := Site_API.Get_Company(newrec_.contract);   
   FOR ord_line_ in get_ord_lines LOOP      
      Recalculate_Tax_Lines___(newrec_.order_no,
                               ord_line_.line_no,
                               ord_line_.rel_no,
                               ord_line_.line_item_no,
                               company_,
                               newrec_.contract,
                               newrec_.supply_country,
                               newrec_.customer_no,
                               newrec_.ship_addr_no,
                               newrec_.use_price_incl_tax,
                               newrec_.currency_code,                                  
                               ord_line_.price_conv_factor,
                               NULL);
   END LOOP;  
   
END Recal_Tax_Lines_Add_Disc___;

---------------------------------------------------------------------
-- Tax_Paying_Party_Changed___
--    Calculates and modifies free_of_charge_tax_basis after changing
--    the free of charge tax paying party on the order header.
---------------------------------------------------------------------
PROCEDURE Tax_Paying_Party_Changed___ (
   newrec_     IN CUSTOMER_ORDER_TAB%ROWTYPE)
IS
   free_of_charge_tax_basis_  NUMBER;
   CURSOR get_free_of_charge_lines IS
      SELECT *
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = newrec_.order_no
      AND   free_of_charge = 'TRUE';
BEGIN
   FOR rec_ IN get_free_of_charge_lines LOOP
      Tax_Handling_Order_Util_API.Calc_And_Save_Foc_Tax_Basis(free_of_charge_tax_basis_,
                                                              Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                              newrec_.order_no,
                                                              rec_.line_no, 
                                                              rec_.rel_no, 
                                                              rec_.line_item_no,
                                                              '*',
                                                              rec_.cost,
                                                              rec_.part_price,
                                                              rec_.revised_qty_due, 
                                                              NVL(newrec_.customer_no_pay, rec_.customer_no),
                                                              rec_.contract,
                                                              newrec_.currency_code,
                                                              newrec_.currency_rate_type,
                                                              'TRUE');
   END LOOP;
END Tax_Paying_Party_Changed___;

-- Get Delivery Information when changing the Delivery Address
PROCEDURE Get_B2b_Delivery_Info___(
   oldrec_ IN     customer_order_tab%ROWTYPE,
   newrec_ IN OUT customer_order_tab%ROWTYPE)
IS
     attr_                    VARCHAR2(32000);
BEGIN
       IF Validate_SYS.Is_Changed(oldrec_.ship_addr_no, newrec_.ship_addr_no) THEN 
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CONTRACT', oldrec_.contract, attr_);
         Client_SYS.Add_To_Attr('ADDR_FLAG_DB', oldrec_.addr_flag, attr_);
         Client_SYS.Add_To_Attr('ORDER_NO', oldrec_.order_no, attr_);
         Client_SYS.Add_To_Attr('SHIP_VIA_CODE', oldrec_.ship_via_code, attr_);
         Client_SYS.Add_To_Attr('DELIVERY_TERMS', oldrec_.delivery_terms, attr_);
         Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', oldrec_.delivery_terms, attr_);
         Client_SYS.Add_To_Attr('VENDOR_NO', oldrec_.vendor_no, attr_); 

         Get_Delivery_Information(attr_, oldrec_.language_code, oldrec_.agreement_id, oldrec_.customer_no, newrec_.ship_addr_no);

         newrec_.ship_via_code := Client_SYS.Get_Item_Value('SHIP_VIA_CODE', attr_);
         newrec_.delivery_terms := Client_SYS.Get_Item_Value('DELIVERY_TERMS', attr_); 
         newrec_.del_terms_location := Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', attr_);
         newrec_.route_id := Client_SYS.Get_Item_Value('ROUTE_ID', attr_);
         newrec_.delivery_leadtime := Client_SYS.Get_Item_Value('DELIVERY_LEADTIME', attr_);
         newrec_.picking_leadtime := Client_SYS.Get_Item_Value('PICKING_LEADTIME', attr_);
         newrec_.forward_agent_id := Client_SYS.Get_Item_Value('FORWARD_AGENT_ID', attr_);
         newrec_.shipment_type := Client_SYS.Get_Item_Value('SHIPMENT_TYPE', attr_);
         newrec_.cust_calendar_id := Client_SYS.Get_Item_Value('CUST_CALENDAR_ID', attr_);   
         newrec_.ext_transport_calendar_id := Client_SYS.Get_Item_Value('EXT_TRANSPORT_CALENDAR_ID', attr_);
         newrec_.freight_map_id := Client_SYS.Get_Item_Value('FREIGHT_MAP_ID', attr_);
         newrec_.zone_id := Client_SYS.Get_Item_Value('ZONE_ID', attr_);      
      END IF;
END Get_B2b_Delivery_Info___;


PROCEDURE Build_Rec_For_Copy_Header___ (
   newrec_                      OUT NOCOPY CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_                        IN OUT NOCOPY VARCHAR2,
   copy_order_rec_              IN CUSTOMER_ORDER_TAB%ROWTYPE,
   copy_address_                IN BOOLEAN,
   copy_misc_order_information_ IN BOOLEAN,
   copy_delivery_information_   IN BOOLEAN,
   copy_document_info_          IN BOOLEAN,
   copy_tax_information_        IN BOOLEAN,
   copy_pricing_information_    IN BOOLEAN,
   copy_document_text_          IN BOOLEAN,
   copy_note_text_              IN BOOLEAN)
IS
   indrec_                      Indicator_Rec;
   sing_occ_addr_              Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   zone_info_exist_            VARCHAR2(5) := 'FALSE';
   -- gelr:invoice_reason, begin
   company_                    VARCHAR2(50);
   -- gelr:invoice_reason, end
BEGIN
   Unpack___(newrec_, indrec_,attr_);
   company_ := Site_API.Get_Company(newrec_.contract);
   newrec_.prepayment_approved := copy_order_rec_.prepayment_approved ;
   newrec_.order_code := copy_order_rec_.order_code;

   IF (copy_address_) THEN
      newrec_.bill_addr_no := copy_order_rec_.bill_addr_no;
      newrec_.ship_addr_no := copy_order_rec_.ship_addr_no;     
      newrec_.addr_flag := copy_order_rec_.addr_flag;  
      newrec_.cust_ref := copy_order_rec_.cust_ref;
      newrec_.country_code := copy_order_rec_.country_code;      
   END IF;
   
   IF (copy_misc_order_information_) THEN
      newrec_.language_code := copy_order_rec_.language_code;
      newrec_.supply_country := copy_order_rec_.supply_country;
      newrec_.proposed_prepayment_amount := copy_order_rec_.proposed_prepayment_amount;     
      newrec_.customer_no_pay := copy_order_rec_.customer_no_pay;
      
      IF (newrec_.customer_no_pay IS NOT NULL) THEN
         newrec_.customer_no_pay_addr_no := Cust_Ord_Customer_API.Get_Document_Address(newrec_.customer_no_pay);
         IF (newrec_.customer_no_pay_addr_no IS NULL) THEN
            Raise_No_Pay_Addr_Error___(newrec_.customer_no_pay);
         END IF;
         newrec_.customer_no_pay_ref := Cust_Ord_Customer_API.Fetch_Cust_Ref(newrec_.customer_no_pay, newrec_.customer_no_pay_addr_no, 'TRUE');
      ELSE
            newrec_.customer_no_pay_addr_no := NULL;
            newrec_.customer_no_pay_ref := NULL;         
      END IF;
          
      newrec_.market_code := copy_order_rec_.market_code; 
      newrec_.salesman_code := copy_order_rec_.salesman_code;      
      newrec_.district_code := copy_order_rec_.district_code;
      newrec_.region_code := copy_order_rec_.region_code;           
      newrec_.pay_term_id := copy_order_rec_.pay_term_id;     
      newrec_.agreement_id := copy_order_rec_.agreement_id;
      newrec_.jinsui_invoice := copy_order_rec_.jinsui_invoice;
      newrec_.pay_term_base_date := copy_order_rec_.pay_term_base_date;
      newrec_.classification_standard :=  copy_order_rec_.classification_standard;
      newrec_.limit_sales_to_assortments := copy_order_rec_.limit_sales_to_assortments;
      newrec_.rebate_customer := copy_order_rec_.rebate_customer;
      newrec_.use_price_incl_tax := copy_order_rec_.use_price_incl_tax;
   END IF;
   
   IF newrec_.use_price_incl_tax IS NULL THEN
      newrec_.use_price_incl_tax := Customer_Tax_Calc_Basis_API.Get_Use_Price_Incl_Tax_Db(newrec_.customer_no, company_);
   END IF;

   IF (copy_delivery_information_) THEN
      newrec_.ship_via_code := copy_order_rec_.ship_via_code;
      newrec_.delivery_terms := copy_order_rec_.delivery_terms;
      newrec_.del_terms_location := copy_order_rec_.del_terms_location;     
      newrec_.forward_agent_id := copy_order_rec_.forward_agent_id;   
      IF (newrec_.addr_flag = 'N') THEN
         Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(newrec_.freight_map_id,
                                                        newrec_.zone_id,
                                                        newrec_.customer_no,
                                                        newrec_.ship_addr_no,
                                                        newrec_.contract,
                                                        newrec_.ship_via_code);
      ELSE
         sing_occ_addr_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(copy_order_rec_.order_no);
         Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(newrec_.freight_map_id,
                                                           newrec_.zone_id,
                                                           zone_info_exist_,
                                                           newrec_.contract,
                                                           newrec_.ship_via_code,
                                                           sing_occ_addr_.zip_code,
                                                           sing_occ_addr_.city,
                                                           sing_occ_addr_.county,
                                                           sing_occ_addr_.state,
                                                           sing_occ_addr_.country_code);
         
      END IF;

      newrec_.apply_fix_deliv_freight := copy_order_rec_.apply_fix_deliv_freight;
      newrec_.confirm_deliveries := copy_order_rec_.confirm_deliveries;
      newrec_.check_sales_grp_deliv_conf := copy_order_rec_.check_sales_grp_deliv_conf;
      newrec_.delivery_leadtime := copy_order_rec_.delivery_leadtime;
      newrec_.ext_transport_calendar_id := copy_order_rec_.ext_transport_calendar_id;
      newrec_.route_id := copy_order_rec_.route_id;
      newrec_.picking_leadtime := copy_order_rec_.picking_leadtime;
      newrec_.shipment_type := copy_order_rec_.shipment_type;
      
      newrec_.delay_cogs_to_deliv_conf := copy_order_rec_.delay_cogs_to_deliv_conf;      
      
      newrec_.backorder_option := copy_order_rec_.backorder_option;
      newrec_.intrastat_exempt := copy_order_rec_.intrastat_exempt;
      newrec_.shipment_creation := copy_order_rec_.shipment_creation;
      newrec_.use_pre_ship_del_note := copy_order_rec_.use_pre_ship_del_note;
      newrec_.pick_inventory_type := copy_order_rec_.pick_inventory_type;
      newrec_.cust_calendar_id := copy_order_rec_.cust_calendar_id;
      newrec_.customs_value_currency := copy_order_rec_.customs_value_currency;
      newrec_.fix_deliv_freight := copy_order_rec_.fix_deliv_freight;
      newrec_.vendor_no := NULL;
   END IF;
   newrec_.freight_price_list_no := Freight_Price_List_Base_API.Get_Active_Freight_List_No(newrec_.contract, newrec_.ship_via_code, newrec_.freight_map_id, newrec_.forward_agent_id, newrec_.use_price_incl_tax);
   
   IF (copy_document_info_) THEN
      newrec_.order_conf_flag := copy_order_rec_.order_conf_flag; 
      newrec_.pack_list_flag := copy_order_rec_.pack_list_flag;     
      newrec_.pick_list_flag := copy_order_rec_.pick_list_flag; 
      newrec_.summarized_source_lines := copy_order_rec_.summarized_source_lines;     
      newrec_.summarized_freight_charges := copy_order_rec_.summarized_freight_charges;     
      newrec_.print_delivered_lines := copy_order_rec_.print_delivered_lines;  
      newrec_.print_control_code := copy_order_rec_.print_control_code;
   END IF;
   
   IF (copy_tax_information_) THEN
      newrec_.tax_id_no := copy_order_rec_.tax_id_no;
      newrec_.tax_id_validated_date  := copy_order_rec_.tax_id_validated_date;
      newrec_.tax_liability := copy_order_rec_.tax_liability;
      newrec_.free_of_chg_tax_pay_party := copy_order_rec_.free_of_chg_tax_pay_party;
   END IF;
   
   IF (copy_pricing_information_)  THEN
      newrec_.additional_discount := copy_order_rec_.additional_discount;     
   END IF;
   
   IF (copy_document_text_) THEN
      newrec_.note_id := copy_order_rec_.note_id;
   END IF;

   IF (copy_note_text_) THEN
      newrec_.note_text := copy_order_rec_.note_text;
   END IF;
   -- gelr:warehouse_journal begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'WAREHOUSE_JOURNAL') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (copy_delivery_information_) THEN
         newrec_.delivery_reason_id := copy_order_rec_.delivery_reason_id;
      END IF;
   END IF;
   -- gelr:warehouse_journal end
   -- gelr:invoice_reason, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'INVOICE_REASON') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (copy_misc_order_information_) THEN
         newrec_.invoice_reason_id := copy_order_rec_.invoice_reason_id;
      ELSE
         newrec_.invoice_reason_id := Identity_Invoice_Info_API.Get_Invoice_Reason_Id(company_, newrec_.customer_no, Party_Type_API.Decode('CUSTOMER'));
      END IF;
   END IF;
   -- gelr:invoice_reason, end
   -- gelr:brazilian_specific_attributes, begin
   IF (Company_Localization_Info_API.Get_Parameter_Value_Db(company_, 'BRAZILIAN_SPECIFIC_ATTRIBUTES') = Fnd_Boolean_API.DB_TRUE) THEN
      IF (copy_misc_order_information_) THEN
         newrec_.business_transaction_id := copy_order_rec_.business_transaction_id;
      END IF;
   END IF;
   -- gelr:brazilian_specific_attributes, end

END Build_Rec_For_Copy_Header___;


PROCEDURE Copy_Customer_Order_Header___ (
   to_order_no_               IN OUT VARCHAR2,
   from_order_no_             IN     VARCHAR2, 
   customer_no_               IN     VARCHAR2,
   order_id_                  IN     VARCHAR2,
   currency_code_             IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   wanted_delivery_date_      IN     DATE,
   copy_order_adresses_       IN     VARCHAR2,
   copy_misc_order_info_      IN     VARCHAR2,      
   copy_delivery_info_        IN     VARCHAR2,
   copy_document_info_        IN     VARCHAR2, 
   copy_tax_detail_           IN     VARCHAR2,
   copy_pricing_              IN     VARCHAR2,
   copy_document_texts_       IN     VARCHAR2,
   copy_notes_                IN     VARCHAR2,   
   copy_pre_accounting_       IN     VARCHAR2,
   copy_charges_              IN     VARCHAR2)
IS
   objid_                        VARCHAR2(20);
   objversion_                   VARCHAR2(100);
   attr_                         VARCHAR2(32000);
   authorize_code_               VARCHAR2(20);
   to_customer_no_               customer_order_tab.customer_no%TYPE;
   to_contract_                  customer_order_tab.contract%TYPE;   
   copy_order_rec_               customer_order_tab%ROWTYPE;
   newrec_                       customer_order_tab%ROWTYPE;                         
   addr_rec_                     customer_order_address_tab%ROWTYPE;
   true_                         VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
   false_                        VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   copy_address_                 BOOLEAN := FALSE;
   copy_delivery_information_    BOOLEAN := FALSE;
   copy_misc_order_information_  BOOLEAN := FALSE;
   copy_document_information_    BOOLEAN := FALSE;
   copy_tax_information_         BOOLEAN := FALSE;
   copy_pricing_information_     BOOLEAN := FALSE;
   copy_document_text_           BOOLEAN := FALSE;
   copy_note_text_               BOOLEAN := FALSE;
   copy_original_pre_accounting_ BOOLEAN := FALSE;   
   orginal_pre_accounting_id_    customer_order_tab.pre_accounting_id%TYPE;
   indrec_        Indicator_Rec;
   emptyrec_      customer_order_tab%ROWTYPE;
  
   CURSOR get_order_rec IS
      SELECT *
      FROM  customer_order_tab
      WHERE order_no   = from_order_no_;
      
   CURSOR get_address IS
      SELECT *
      FROM customer_order_address_tab
      WHERE order_no = from_order_no_;
      
BEGIN
   OPEN get_order_rec;
   FETCH get_order_rec INTO copy_order_rec_;
   IF get_order_rec%NOTFOUND THEN
      CLOSE get_order_rec;
      Error_SYS.Record_General(lu_name_, 'ORDERDOESNOOTEXIST: Customer Order :P1 does not exist.', from_order_no_);
   ELSE
      CLOSE get_order_rec;
   END IF;
   
   to_customer_no_ := NVL(customer_no_, copy_order_rec_.customer_no);
   Cust_Ord_Customer_API.Exist(to_customer_no_);
   
   to_contract_ := NVL(contract_, copy_order_rec_.contract);
   Site_API.Exist(to_contract_);
   
   authorize_code_ := copy_order_rec_.authorize_code;
     
   IF (authorize_code_ IS NULL)THEN
      Error_SYS.Record_General(lu_name_, 'COORDINATORNOTEXIST: Coordinator is mandatory for Customer Order. No Coordinator has been defined for user :P1 in site :P2.',Fnd_Session_Api.Get_Fnd_User,to_contract_);
   END IF;

   -- Get General Information to the Copied Customer Order Start-------------------------------------
   Client_SYS.Add_To_Attr('ORDER_NO', to_order_no_, attr_);    
   Client_SYS.Add_To_Attr('AUTHORIZE_CODE', authorize_code_, attr_); 
   Client_SYS.Add_To_Attr('CONTRACT', to_contract_, attr_); 
   Client_SYS.Add_To_attr('ORDER_ID', order_id_, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_CODE', currency_code_, attr_); 
   Client_SYS.Add_To_Attr('CUSTOMER_NO', to_customer_no_, attr_); 
   Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', NVL(wanted_delivery_date_, copy_order_rec_.wanted_delivery_date) , attr_);
   
   IF (copy_charges_ = Fnd_Boolean_API.DB_TRUE) THEN
      Client_SYS.Add_To_Attr('DEFAULT_CHARGES', 'FALSE', attr_);
   END IF;
   -- Get General Information to the Copied Customer Order End-------------------------------------
   
   IF (copy_order_rec_.customer_no = to_customer_no_) THEN     
       copy_address_                 := (NVL(copy_order_adresses_,false_) = true_);
       copy_misc_order_information_  := (NVL(copy_misc_order_info_,false_) = true_) ;
   END IF;
   copy_tax_information_         := (NVL(copy_tax_detail_,false_) = true_);   
   copy_delivery_information_    := (NVL(copy_delivery_info_,false_) = true_);
   copy_document_information_    := (NVL(copy_document_info_,false_) = true_) ;
   copy_pricing_information_     := (NVL(copy_pricing_,false_) = true_);
   copy_original_pre_accounting_ := (NVL(copy_pre_accounting_, false_) = true_);  
   copy_document_text_           := (NVL(copy_document_texts_, false_) = true_);
   copy_note_text_               := (NVL(copy_notes_, false_) = true_);
   
   Build_Rec_For_Copy_Header___ (newrec_,
                                 attr_,
                                 copy_order_rec_,
                                 copy_address_,
                                 copy_misc_order_information_,
                                 copy_delivery_information_,
                                 copy_document_information_,
                                 copy_tax_information_,
                                 copy_pricing_information_,
                                 copy_document_text_,
                                 copy_note_text_);   

   -- Preposting
   IF (copy_original_pre_accounting_) THEN
      orginal_pre_accounting_id_ := copy_order_rec_.pre_accounting_id;
   END IF;
   -- New___() has not called since attr has been refered in Insert___
   indrec_ := Get_Indicator_Rec___(emptyrec_, newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);

   Custom_Objects_SYS.Copy_Cf_Instance(lu_name_, copy_order_rec_.rowkey, newrec_.rowkey);

   IF ((copy_address_) AND (copy_order_rec_.addr_flag = Gen_Yes_No_API.DB_YES)) THEN
      OPEN get_address;
      FETCH get_address INTO addr_rec_;
      IF (get_address%FOUND) THEN
         Customer_Order_Address_API.New(order_no_           => newrec_.order_no,
                                        addr_1_             => addr_rec_.addr_1,
                                        address1_           => addr_rec_.address1,
                                        address2_           => addr_rec_.address2,
                                        address3_           => addr_rec_.address3,
                                        address4_           => addr_rec_.address4,
                                        address5_           => addr_rec_.address5,
                                        address6_           => addr_rec_.address6,
                                        zip_code_           => addr_rec_.zip_code,
                                        city_               => addr_rec_.city,
                                        state_              => addr_rec_.state,
                                        county_             => addr_rec_.county,
                                        country_code_       => addr_rec_.country_code,
                                        in_city_            => addr_rec_.in_city,
                                        vat_free_vat_code_  => addr_rec_.vat_free_vat_code); 
      END IF;
      CLOSE get_address;                               
   END IF;

   IF (copy_original_pre_accounting_) THEN
      Pre_Accounting_API.Copy_Pre_Accounting(orginal_pre_accounting_id_,
                                             newrec_.pre_accounting_id,
                                             newrec_.contract,
                                             TRUE,
                                             'CUSTOMER ORDER');     
   END IF;
   
   IF ((copy_order_rec_.customer_no = to_customer_no_) AND (copy_order_rec_.staged_billing = 'STAGED BILLING' )) THEN 
      Staged_Billing_Template_API.Copy_Template(from_order_no_,
                                                newrec_.order_no);   
   END IF;
   
   to_order_no_ := newrec_.order_no;
   Customer_Order_History_API.New(to_order_no_, 
                                   Language_SYS.Translate_Constant(lu_name_, 'COPIED_ORDER: Copied from order :P1', NULL, from_order_no_));
      
END Copy_Customer_Order_Header___;

-- gelr:alt_invoice_no_per_branch, begin
PROCEDURE Check_Component_A_Ref___ (
   newrec_ IN OUT NOCOPY customer_order_tab%ROWTYPE )
IS
   company_   VARCHAR2(20) := Site_API.Get_Company(newrec_.contract);
BEGIN
   IF (NOT Off_Inv_Num_Comp_Type_Val_API.Exists(company_, 'Component A', newrec_.component_a))THEN
      Error_SYS.Record_General(lu_name_, 'COMPNOTEXISTS: The entered :P1 does not exist in Official Invoice Number Components.', Off_Inv_Num_Comp_Type_API.Get_Name(company_, 'Component A'));
   END IF;
END Check_Component_A_Ref___;
-- gelr:alt_invoice_no_per_branch, end

-- gelr:delivery_types_in_pbi, begin
-- Get_Tax_Per_Tax_Code_Deliv___
--    Returns the total tax amount (VAT or Sales Tax) per tax code and delivery type
--    in order currency. If the delivery type is not given it will be calculated only per tax code
FUNCTION Get_Tax_Per_Tax_Code_Deliv___ (
   order_no_      IN VARCHAR2,
   tax_code_      IN VARCHAR2, 
   delivery_type_ IN VARCHAR2) RETURN NUMBER 
IS
   tax_amount_          NUMBER;
   charge_tax_amount_   NUMBER;
   string_null_            VARCHAR2(15) := Database_SYS.string_null_;
   
   CURSOR get_order_line_tax IS
      SELECT SUM(NVL(sti.tax_curr_amount, 0))
      FROM customer_order_line_tab       col,
           source_tax_item_base_pub sti
      WHERE col.order_no              = sti.source_ref1
      AND   col.line_no               = sti.source_ref2
      AND   col.rel_no                = sti.source_ref3
      AND   TO_CHAR(col.line_item_no) = sti.source_ref4
      AND   sti.source_ref5           = '*'
      AND   col.order_no              = order_no_
      AND   sti.tax_code              = tax_code_
      AND   NVL(col.delivery_type, string_null_) = NVL(delivery_type_, string_null_)
	   AND   sti.source_ref_type_db    = Tax_Source_API.DB_CUSTOMER_ORDER_LINE
      AND   col.rowstate             != 'Cancelled';

   CURSOR get_charge_line_tax IS
      SELECT SUM(NVL(sti.tax_curr_amount, 0))
      FROM customer_order_charge_tab     coc,
           source_tax_item_base_pub sti
      WHERE sti.company = coc.company
      AND   sti.source_ref_type_db = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE
	  AND   sti.source_ref1 = coc.order_no
      AND   sti.source_ref2 = TO_CHAR(coc.sequence_no)
      AND   sti.source_ref3 = '*'
      AND   sti.source_ref4 = '*'
      AND   sti.source_ref5 = '*'
      AND   coc.order_no    = order_no_
      AND   sti.tax_code   = tax_code_
      AND   NVL(coc.delivery_type, string_null_) = NVL(delivery_type_, string_null_);
BEGIN
   OPEN get_order_line_tax;
   FETCH get_order_line_tax INTO tax_amount_;
   CLOSE get_order_line_tax;
   
   OPEN get_charge_line_tax;
   FETCH get_charge_line_tax INTO charge_tax_amount_;
   CLOSE get_charge_line_tax;
   
   RETURN (NVL(tax_amount_, 0) + NVL(charge_tax_amount_, 0));
END Get_Tax_Per_Tax_Code_Deliv___;


FUNCTION Get_Gros_Per_Tax_Code_Deliv___ (
   order_no_      IN VARCHAR2,
   tax_code_      IN VARCHAR2,
   delivery_type_ IN VARCHAR2) RETURN NUMBER 
IS
   gross_amount_        NUMBER := 0;
   charge_gross_amount_ NUMBER := 0;
   string_null_            VARCHAR2(15) := Database_SYS.string_null_;

   CURSOR get_order_line_gross IS
      SELECT col.line_no, col.rel_no, col.line_item_no
      FROM customer_order_line_tab       col,
           source_tax_item_base_pub sti
      WHERE col.order_no              = sti.source_ref1
      AND   col.line_no               = sti.source_ref2
      AND   col.rel_no                = sti.source_ref3
      AND   TO_CHAR(col.line_item_no) = sti.source_ref4
      AND   sti.source_ref5           = '*'
      AND   col.order_no              = order_no_
      AND   sti.tax_code              = tax_code_
      AND   NVL(col.delivery_type, string_null_) = NVL(delivery_type_, string_null_)
	   AND   sti.source_ref_type_db    = Tax_Source_API.DB_CUSTOMER_ORDER_LINE
      AND   col.rowstate             != 'Cancelled';

   CURSOR get_charge_line_gross IS
      SELECT coc.sequence_no
      FROM customer_order_charge_tab     coc,
           source_tax_item_base_pub sti
      WHERE sti.company = coc.company
      AND   sti.source_ref_type_db = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE
	  AND   sti.source_ref1 = coc.order_no
      AND   sti.source_ref2 = coc.sequence_no
	   AND   sti.source_ref3 = '*'
	   AND   sti.source_ref4 = '*'
      AND   sti.source_ref5 = '*'
      AND   coc.order_no    = order_no_
      AND   sti.tax_code   = tax_code_
      AND   NVL(coc.delivery_type, string_null_) = NVL(delivery_type_, string_null_);
BEGIN
   FOR rec_ IN get_order_line_gross LOOP
      gross_amount_ := gross_amount_ + NVL(Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no), 0);
   END LOOP;
   
   FOR rec_ IN get_charge_line_gross LOOP
      charge_gross_amount_ := charge_gross_amount_ + NVL(Customer_Order_Charge_API.Get_Total_Charged_Amt_Incl_Tax(order_no_, rec_.sequence_no), 0);
   END LOOP;
   
   RETURN (NVL(gross_amount_, 0) + NVL(charge_gross_amount_, 0));
END Get_Gros_Per_Tax_Code_Deliv___;
-- gelr:delivery_types_in_pbi, end

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Calculate_Order_Discount__ (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2 DEFAULT NULL,
   rel_no_       IN VARCHAR2 DEFAULT NULL,
   line_item_no_ IN NUMBER   DEFAULT NULL)
IS
   objstate_ CUSTOMER_ORDER_TAB.rowstate%TYPE;
   
   CURSOR get_attr IS
      SELECT rowstate
      FROM   CUSTOMER_ORDER_TAB
      WHERE  order_no = order_no_
      AND    grp_disc_calc_flag = 'N';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO objstate_;
   IF (get_attr%FOUND) THEN
      CLOSE get_attr;
      IF (objstate_ NOT IN ('Invoiced', 'Cancelled')) THEN
         Calculate_Order_Discount___(order_no_, line_no_, rel_no_, line_item_no_);
         IF ((line_no_ IS NULL) AND (rel_no_ IS NULL) AND (line_item_no_ IS NULL)) THEN
            Modify_Grp_Disc_Calc_Flag(order_no_, 'Y');
         END IF;
      END IF;
   ELSE
      CLOSE get_attr;
   END IF;
END Calculate_Order_Discount__;


-- Get_Total_Sale_Price__
--   Retrieve the total sale price for the specified order.
@UncheckedAccess
FUNCTION Get_Total_Sale_Price__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_sale_price_ NUMBER := 0;
BEGIN
   total_sale_price_ := Get_Total_Sale_Price___(order_no_, FALSE);

   RETURN total_sale_price_;
END Get_Total_Sale_Price__;


@UncheckedAccess
FUNCTION Get_Tot_Sale_Price_Incl_Tax__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_sale_price_ NUMBER := 0;
BEGIN
   total_sale_price_ := Get_Tot_Sale_Price_Incl_Tax___(order_no_, FALSE);
   RETURN total_sale_price_;
END Get_Tot_Sale_Price_Incl_Tax__;


-- Set_Order_Conf__
--   Sets the order_conf flag for an order in order to indicate that the
--   order confirmation has been printed.
PROCEDURE Set_Order_Conf__ (
   order_no_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   newrec_.order_conf := 'Y';
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Order_Conf__;


-- Get_Total_Qty__
--   Retrieve the total line_total_qty for the specified order. Changes to this should apply to Get_Ord_Line_ToTals__ as well.
@UncheckedAccess
FUNCTION Get_Total_Qty__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_qty_ NUMBER;
   CURSOR get_totals IS
      SELECT SUM(line_total_qty)
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled'
      AND    line_item_no <= 0;
BEGIN
   OPEN get_totals;
   FETCH get_totals INTO total_qty_;
   CLOSE get_totals;

   RETURN total_qty_;
END Get_Total_Qty__;


-- Get_Total_Weight__
--   Retrieve the total weight for the specified order. Changes to this should apply to Get_Ord_Line_ToTals__ as well.
@UncheckedAccess
FUNCTION Get_Total_Weight__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_weight_ NUMBER;

   CURSOR get_totals IS
      SELECT SUM(line_total_weight)
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled'
      AND    line_item_no <= 0;
BEGIN
   OPEN get_totals;
   FETCH get_totals INTO total_weight_;
   CLOSE get_totals;

   RETURN total_weight_;
END Get_Total_Weight__;



-- Check_Payment_Term__
--   Checks if the payment_term exists. If found, print an error message.
--   Used for restricted delete check when removing an payment_term (ACCRUL-module).
PROCEDURE Check_Payment_Term__ (
   key_list_ IN VARCHAR2 )
IS
   company_     VARCHAR2(20);
   pay_term_id_ CUSTOMER_ORDER_TAB.pay_term_id%TYPE;
   found_       NUMBER;

   CURSOR exist_control IS
      SELECT 1
      FROM   CUSTOMER_ORDER_TAB
      WHERE  Site_API.Get_Company(contract) = company_
      AND    pay_term_id = pay_term_id_;
BEGIN
   company_ := substr(key_list_, 1, instr(key_list_, '^') - 1);
   pay_term_id_ := substr(key_list_, instr(key_list_, '^') + 1, instr(key_list_, '^' , 1, 2) - (instr(key_list_, '^') + 1));

   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   IF found_ = 1 THEN
      Error_SYS.Record_General(lu_name_, 'NO_PAY_TERM: Payment Term :P1 exists on one or several Customer Order(s)', pay_term_id_ );
   END IF;
END Check_Payment_Term__;


-- Get_Tot_Sale_Price_Excl_Item__
--   Retrieve the total sale price for the specified order excluding, Charged Item and Exchange Item cost.
--   Retrieve the total tax amount for the specified order excluding, Charged Item and Exchange Item cost.
@UncheckedAccess
FUNCTION Get_Tot_Sale_Price_Excl_Item__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_sale_price_ NUMBER := 0;
BEGIN
   total_sale_price_ := Get_Total_Sale_Price___(order_no_, TRUE);

   RETURN total_sale_price_;
END Get_Tot_Sale_Price_Excl_Item__;


@UncheckedAccess
FUNCTION Get_Ord_Tax_Amt_Excl_Item__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_ NUMBER := 0;
BEGIN
   total_tax_amount_:= Get_Ord_Total_Tax_Amount___(order_no_,TRUE);
   RETURN total_tax_amount_;
END Get_Ord_Tax_Amt_Excl_Item__;


-- Lock_By_Keys__
--   Calls the function Lock_By_Keys___.
--   Server support to lock a specific instance of the logical uni
PROCEDURE Lock_By_Keys__ (
   order_no_ IN VARCHAR2 )
IS
   rec_ CUSTOMER_ORDER_TAB%ROWTYPE;
BEGIN
   rec_ := Lock_By_Keys___(order_no_);
END Lock_By_Keys__;


-- Exist_Charges__
--   Returns whether or not charges are used on an order.
@UncheckedAccess
FUNCTION Exist_Charges__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE order_no = order_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Exist_Charges__;

-- Check_Cancel_Reason_Ref___
--   Perform validation on the CancelReasonRef reference.
PROCEDURE Check_Cancel_Reason_Ref___ (
   newrec_ IN OUT customer_order_tab%ROWTYPE )
IS
BEGIN 
   Order_Cancel_Reason_Api.Exist( newrec_.cancel_reason, Reason_Used_By_Api.DB_CUSTOMER_ORDER );
END;
   

-- Get_Total_Base_Charge__
--   Get the total charge amount on the order in base currency.
@UncheckedAccess
FUNCTION Get_Total_Base_Charge__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_base_charge_ NUMBER := 0;
   CURSOR get_charges IS
      SELECT sequence_no
        FROM CUSTOMER_ORDER_CHARGE_TAB
       WHERE order_no = order_no_;
BEGIN
   FOR rec_ IN get_charges LOOP
      -- In Customer_Order_Charge_API.Get_Total_Base_Charged_Amount base amount is derived from curr amount as in the invoice.
      total_base_charge_ := Customer_Order_Charge_API.Get_Total_Base_Charged_Amount(order_no_, rec_.sequence_no) +  total_base_charge_;
   END LOOP;
   RETURN NVL(total_base_charge_, 0);
END Get_Total_Base_Charge__;


-- Get_Total_Sale_Charge__
--   Get the total charge amount on the order in order currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Charge__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   ordrec_            CUSTOMER_ORDER_TAB%ROWTYPE;
   rounding_          NUMBER;
   total_sale_charge_ NUMBER;
   temp_              NUMBER;
   charge_percent_basis_ NUMBER;

   CURSOR get_total_amount_charges(rounding_ IN NUMBER) IS
      SELECT SUM(ROUND((charge_amount * charged_qty), rounding_))
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = order_no_;

   CURSOR get_pct_chgs IS
      SELECT charge, sequence_no, charged_qty, charge_percent_basis
      FROM  CUSTOMER_ORDER_CHARGE_TAB
      WHERE charge IS NOT NULL
      AND   order_no = order_no_;
BEGIN
   ordrec_ := Get_Object_By_Keys___(order_no_);
   IF (ordrec_.rowstate != 'Cancelled') THEN
      rounding_ := Currency_Code_API.Get_Currency_Rounding(Site_API.Get_Company(ordrec_.contract), ordrec_.currency_code);

      -- Charge from amounts
      OPEN get_total_amount_charges(rounding_);
      FETCH get_total_amount_charges INTO total_sale_charge_;
      CLOSE get_total_amount_charges;

      -- Add effective charge from charge percentages
      temp_ := 0;
      FOR rec_ IN get_pct_chgs LOOP
         charge_percent_basis_ := NVL(rec_.charge_percent_basis, Customer_Order_Charge_API.Get_Net_Charge_Percent_Basis(order_no_, rec_.sequence_no));
         temp_ := temp_ + ROUND(rec_.charge * charge_percent_basis_ * rec_.charged_qty / 100, rounding_);
      END LOOP;
      total_sale_charge_ := NVL(total_sale_charge_, 0) + ROUND(temp_, rounding_);
   END IF;
   RETURN NVL(total_sale_charge_, 0);
END Get_Total_Sale_Charge__;


-- Get_Total_Sale_Charge_Gross__
--   Get the total charge amount including tax on the order in order currency.
@UncheckedAccess
FUNCTION Get_Total_Sale_Charge_Gross__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_sale_charge_incl_tax_ NUMBER;

   CURSOR get_total_amount_charges IS
      SELECT SUM(Customer_Order_Charge_API.Get_Total_Charged_Amt_Incl_Tax(charge.order_no, charge.sequence_no))
      FROM   CUSTOMER_ORDER_CHARGE_TAB charge, CUSTOMER_ORDER_TAB ord
      WHERE  ord.order_no = order_no_
        AND  ord.rowstate != 'Cancelled' 
        AND  ord.order_no = charge.order_no;

BEGIN
   OPEN get_total_amount_charges;
   FETCH get_total_amount_charges INTO total_sale_charge_incl_tax_;
   CLOSE get_total_amount_charges;

   RETURN NVL(total_sale_charge_incl_tax_, 0);
END Get_Total_Sale_Charge_Gross__;


-- Get_Customer_Defaults__
--    Called on validation of customer_no in custord.apt customer order client
--    form.
--    Fields that has to be added to the attr_ string before calling this method:
--       order_no
--       customer_no
--       ship_addr_no
--       bill_addr_no
PROCEDURE Get_Customer_Defaults__ (
   attr_           IN OUT VARCHAR2,
   all_attributes_ IN     VARCHAR2 DEFAULT 'TRUE' )
IS
   customer_no_ CUSTOMER_ORDER_TAB.customer_no%TYPE := Client_SYS.Get_Item_Value('CUSTOMER_NO', attr_);
BEGIN
   Trace_SYS.Field('CUSTOMER_NO', customer_no_);
   IF (Client_SYS.Get_Item_Value('SHIP_ADDR_NO', attr_) IS NULL) THEN
      Client_SYS.Set_Item_Value('SHIP_ADDR_NO', Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_), attr_);
   END IF;
   IF (Client_SYS.Get_Item_Value('BILL_ADDR_NO', attr_) IS NULL) THEN
      Client_SYS.Set_Item_Value('BILL_ADDR_NO', Cust_Ord_Customer_API.Get_Document_Address(customer_no_), attr_);
   END IF;
   Get_Order_Defaults___(attr_, all_attributes_);
   -- To avoid duplicate info messages in client, clear info string here.
   Client_SYS.Clear_Info;
END Get_Customer_Defaults__;


-- Is_Sm2001_Installed__
--   This method is used by client to check that we are not working against
--   an old version av Service Management.
--   According to the Rose documentation this used to exclude a RMB to Service
--   Management on CO head and CO line, if it is an older version than 2001.
@UncheckedAccess
FUNCTION Is_Sm2001_Installed__ (
   dummy_ IN NUMBER ) RETURN NUMBER
IS
   temp_ NUMBER;
BEGIN
   $IF Component_Wo_SYS.INSTALLED $THEN
   -- WorkOrderPlanning is a new Service Management LU for 2001
      temp_ := 1;
   $ELSE       
      temp_ := 0; 
   $END 
   RETURN temp_;
END Is_Sm2001_Installed__;


-- Modify_Wanted_Delivery_Date__
--   Modifies the attributes wanted_delivery_date and planned_delivery_date
--   for all order lines on the order.
PROCEDURE Modify_Wanted_Delivery_Date__ (
   order_no_                  IN VARCHAR2,
   wanted_delivery_date_      IN DATE,
   planned_delivery_date_     IN DATE,
   replicate_changes_         IN VARCHAR2,
   change_request_            IN VARCHAR2,
   dop_changed_               IN VARCHAR2,
   price_effec_date_changed_  IN VARCHAR2,
   disconnect_exp_license_    IN VARCHAR2,
   changed_attrib_not_in_pol_ IN VARCHAR2)
IS
   pegged_exist_          BOOLEAN := FALSE;
   schedule_exist_        BOOLEAN := FALSE;
   dop_connections_       NUMBER := 0;
   allow_send_chg_        VARCHAR2(5);
   chg_request_           VARCHAR2(5);
   rep_changes_           VARCHAR2(5) := 'FALSE';
   revision_status_       VARCHAR2(50);
   date_changed_          BOOLEAN := FALSE;
   expired_               BOOLEAN := FALSE;
   line_planned_del_date_ DATE;
   order_rec_             Customer_Order_API.Public_Rec;
   manual_discount_exist_ BOOLEAN := FALSE;
   discount_freeze_db_    VARCHAR2(5);
   invalid_calendar_info_ VARCHAR2(4000);

   CURSOR get_all_lines IS
      SELECT line_no, rel_no, line_item_no, supply_code, qty_on_order, rowstate, part_no, configuration_id, 
             qty_assigned, planned_delivery_date, contract, catalog_no, price_effectivity_date, price_freeze
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate NOT IN ('Invoiced', 'Cancelled')
      AND    line_item_no <= 0;
BEGIN
   order_rec_ := Get(order_no_);
   discount_freeze_db_ := Site_Discom_Info_API.Get_Discount_Freeze_Db(order_rec_.contract);
   FOR rec_ in get_all_lines LOOP
      IF (rec_.supply_code = 'DOP') THEN
         $IF Component_Dop_SYS.INSTALLED $THEN
            dop_connections_ := Dop_Demand_Cust_Ord_API.Get_No_Of_All_Dop_Headers(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);            
         $ELSE
            NULL;    
         $END         
      END IF;
      
      IF ((dop_connections_ > 0 OR rec_.supply_code IN ('PT', 'PD', 'IPT', 'IPD', 'SO', 'DOP', 'PKG')) AND rec_.rowstate NOT IN ('Delivered', 'Cancelled')) THEN
         rep_changes_ := replicate_changes_; 
         allow_send_chg_ := Customer_Order_Line_API.Get_Send_Change_Msg_For_Supp(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
         IF (allow_send_chg_ = 'TRUE' AND change_request_ = 'TRUE') THEN
            chg_request_    := 'TRUE';
         ELSE
            chg_request_    := 'FALSE';
         END IF;  
      END IF;

      revision_status_ := Get_Revision_Status___(rec_.part_no, rec_.configuration_id, planned_delivery_date_);

      line_planned_del_date_ := planned_delivery_date_;
      CUSTOMER_ORDER_LINE_API.Modify_Wanted_Delivery_Date__(line_planned_del_date_, 
                                                            order_no_, 
                                                            rec_.line_no, 
                                                            rec_.rel_no, 
                                                            rec_.line_item_no, 
                                                            wanted_delivery_date_,  
                                                            rep_changes_, 
                                                            chg_request_, 
                                                            dop_changed_, 
                                                            price_effec_date_changed_, 
                                                            disconnect_exp_license_,
                                                            changed_attrib_not_in_pol_);
      -- Show  App_Context_SYS value stored in key 'CUST_ORD_DATE_CALCULATION_API.INVALID_CALENDAR_INFO_' as info message if available
      Cust_Ord_Date_Calculation_API.Show_Invalid_Calendar_Info(invalid_calendar_info_, 'TRUE');
      IF NOT manual_discount_exist_ THEN
         IF NVL(to_char(rec_.price_effectivity_date), '0') != NVL(to_char(Customer_Order_Line_API.Get_Price_Effectivity_Date(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no)), '0') THEN
            IF Cust_Order_Line_Discount_API.Check_Manual_Rows(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) THEN
               IF NOT(rec_.price_freeze = 'FROZEN' AND discount_freeze_db_ = 'TRUE') THEN
                  manual_discount_exist_ := TRUE;
               END IF;
            END IF;
         END IF;
      END IF;
      
      IF ((line_planned_del_date_ != rec_.planned_delivery_date) AND (rec_.qty_assigned > 0) AND (NOT expired_)) THEN
         expired_ := Reserve_Customer_Order_API.Check_Expired(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, rec_.contract, rec_.catalog_no, line_planned_del_date_);
      END IF;
      
      -- checks if order lines are pegged
      IF ((rec_.supply_code IN ('IO','PS','PKG')) AND (rec_.qty_on_order >= 0)) THEN
         pegged_exist_ := TRUE;
      END IF;

      IF ((rec_.supply_code ='PS')) THEN
         schedule_exist_ := TRUE;
      END IF;
   END LOOP;
   
   IF manual_discount_exist_ THEN
      Client_SYS.Add_Info(lu_name_, 'MANUAL: Manually entered discount exist. You may want to check the discount calculation.');
   END IF;

   IF (expired_) THEN
      Client_SYS.Add_Info(lu_name_, 'DATE_EXP: Please review the inventory part reservations as the change of planned delivery date resulted in the minimum required shelf life not being fulfilled for at least some of the inventory part reservations.');
   END IF;
   
   IF pegged_exist_ THEN
      Client_SYS.Add_Info(lu_name_, 'PEG_DUE_DATE: The customer order line planned due date has changed, review planned receipt date for pegged supply.');
   END IF;

   IF (Sourced_Cust_Order_Line_API.Check_Exist(order_no_, NULL, NULL, NULL) = 1) THEN
      Client_SYS.Add_Info(lu_name_, 'SRC_LINES_EXIST: There exists sourced lines. Please, check source lines.');
   END IF;

   IF (schedule_exist_ AND order_rec_.rowstate != 'Planned') THEN
      Client_SYS.Add_Info(lu_name_, 'PS_EXISTH: The customer order line planned due date has changed. Production schedule will not be updated automatically.');
   END IF;
END Modify_Wanted_Delivery_Date__;


-- Is_Any_Line_Proj_Conn_Exist__
--   Determines whether there exist project connections in any of the order lines.
@UncheckedAccess
FUNCTION Is_Any_Line_Proj_Conn_Exist__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_proj_connected_line IS
      SELECT 1
       FROM   CUSTOMER_ORDER_LINE_TAB
       WHERE  order_no = order_no_
       AND    project_id IS NOT NULL;
BEGIN
   OPEN  get_proj_connected_line;
   FETCH get_proj_connected_line INTO dummy_;
      IF (get_proj_connected_line%FOUND) THEN
         CLOSE get_proj_connected_line;
         RETURN 1;
      END IF;
   CLOSE get_proj_connected_line;
   RETURN 0;
END Is_Any_Line_Proj_Conn_Exist__;


-- Crdt_Chck_Valid_Lines_Exist__
--   This method is used to check whether order lines exist not in 'Cancelled', 'Invoiced', 'Delivered', 'PartiallyDelivered' states.
-- For Odata session extended this method to check for Charge lines also.
@UncheckedAccess
FUNCTION Crdt_Chck_Valid_Lines_Exist__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR get_order_lines IS
      SELECT 1
       FROM   CUSTOMER_ORDER_LINE_TAB
       WHERE  order_no = order_no_
       AND    rowstate NOT IN ('Cancelled', 'Invoiced', 'Delivered');
BEGIN
   OPEN  get_order_lines;
   FETCH get_order_lines INTO dummy_;
      IF (get_order_lines%FOUND) THEN
         CLOSE get_order_lines;
         RETURN 1;
      END IF;
   CLOSE get_order_lines;
   IF Fnd_Session_API.Is_Odp_Session THEN
      IF Customer_Order_API.Exist_Charges__(order_no_) = 1 THEN
         RETURN 1;
      ELSE
         RETURN 0;
      END IF;   
   ELSE    
      RETURN 0;
   END IF; 
END Crdt_Chck_Valid_Lines_Exist__;


-- Log_Manual_Credit_Check_Hist__
--   This method is used to log the history whether the user done a credit check manually.
PROCEDURE Log_Manual_Credit_Check_Hist__ (
   order_no_   IN VARCHAR2,
   log_reason_ IN VARCHAR2 )
IS
   message_ VARCHAR2(32000);
   status_  VARCHAR2(32000);
BEGIN
   CASE log_reason_
      WHEN ('NO') THEN 
         message_  :=  'HISTMANUALCRDTCHKNO: Manual credit limit is checked. Customer order :P1 is not blocked.';
      WHEN ('OK') THEN
         message_  :=  'HISTMANUALCRDTCHKOK: Manual credit limit is checked.';
   END CASE;
   status_ := Language_SYS.Translate_Constant(lu_name_, message_, NULL, order_no_);   
   Customer_Order_History_API.New(order_no_, status_);   
END Log_Manual_Credit_Check_Hist__;

-- Self_Billing_Lines_Exist__
--   This method returns true (1) if there exists at least one CO line for
--   the given order number that is SELF BILLING and not in state cancelled
--   or invoiced, and false (0) otherwise.
@UncheckedAccess
FUNCTION Self_Billing_Lines_Exist__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   sb_exists_ NUMBER;

   CURSOR  get_sb_lines IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND self_billing = 'SELF BILLING'
      AND rowstate NOT IN ('Cancelled', 'Invoiced');
BEGIN
   OPEN get_sb_lines;
   FETCH get_sb_lines INTO sb_exists_;
   CLOSE get_sb_lines;

   RETURN NVL(sb_exists_, 0);
END Self_Billing_Lines_Exist__;


-- Modify_Release_From_Credit__
--   Update field released_from_credit_check in customer order record.
PROCEDURE Modify_Release_From_Credit__ (
   order_no_                   IN VARCHAR2,
   released_from_credit_check_ IN VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
   info_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RELEASED_FROM_CREDIT_CHECK_DB', released_from_credit_check_, attr_);
   Modify(info_, attr_, order_no_);
END Modify_Release_From_Credit__;


-- Valid_Project_Customer__
--   Returns "TRUE" if passed customer and the project customer are same;
--   "FALSE" otherwise.
@UncheckedAccess
FUNCTION Valid_Project_Customer__ (
   customer_no_ IN VARCHAR2,
   project_id_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   proj_customer_id_ VARCHAR2(20);
   return_value_     VARCHAR2(5) := 'TRUE';
BEGIN
   $IF Component_Proj_SYS.INSTALLED $THEN
      IF project_id_ IS NOT NULL THEN  
         proj_customer_id_  := Project_API.Get_Customer_Id(project_id_);   
      END IF; 

      IF (NVL(proj_customer_id_, Database_SYS.string_null_) != customer_no_) THEN
         return_value_ := 'FALSE';
      END IF;
   $END
   RETURN return_value_;
END Valid_Project_Customer__;


-- Created_From_Int_Po__
--   Checks if passed in CO contains at least one line with demand_code = IPT, IPD
--   or IPT_RO and if so, returns 'TRUE', otherwise, returns 'FALSE'
@UncheckedAccess
FUNCTION Created_From_Int_Po__ (
   order_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   created_from_int_po_ VARCHAR2(5);

   CURSOR get_line_demand_code IS
      SELECT 'TRUE'
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    demand_code IN ('IPT', 'IPD', 'IPT_RO');
BEGIN
   OPEN get_line_demand_code;
   FETCH get_line_demand_code INTO created_from_int_po_;
   CLOSE get_line_demand_code;

   RETURN NVL(created_from_int_po_, 'FALSE');
END Created_From_Int_Po__;


@UncheckedAccess
FUNCTION Get_Total_Gross_Weight__ (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_weight_ NUMBER;

   CURSOR get_totals IS
      SELECT SUM(NVL(line_total_weight_gross,0))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled'
      AND    line_item_no <= 0;
BEGIN
   OPEN get_totals;
   FETCH get_totals INTO total_weight_;
   CLOSE get_totals;

   RETURN total_weight_;
END Get_Total_Gross_Weight__;


@UncheckedAccess
FUNCTION Check_Address_Replication__ (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   
   CURSOR get_address_replication IS
      SELECT 1   
        FROM CUSTOMER_ORDER_LINE_TAB 
       WHERE rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
         AND order_no = order_no_
         AND supply_code IN ('IPD', 'PD')
         AND qty_on_order > 0
         AND EXISTS (SELECT 1
                      FROM CUSTOMER_ORDER_PUR_ORDER_TAB
                     WHERE oe_order_no     = order_no_
                       AND oe_line_no      = line_no
                       AND oe_rel_no       = rel_no
                       AND oe_line_item_no = line_item_no
                       AND purchase_type   = 'O' );
BEGIN
   OPEN get_address_replication;
   FETCH get_address_replication INTO dummy_;
   IF (get_address_replication%FOUND) THEN
      CLOSE get_address_replication;
      RETURN 'TRUE';
   END IF;
   CLOSE get_address_replication;
   RETURN 'FALSE';
END Check_Address_Replication__;


@Override
PROCEDURE Set_Released__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_                       CUSTOMER_ORDER_TAB%ROWTYPE;
   company_                   VARCHAR2(20);
   external_tax_calc_method_  VARCHAR2(50);
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      rec_ := Get_Object_By_Id___(objid_);
      CUSTOMER_ORDER_LINE_API.Check_Released_Activity__(rec_.order_no);
      company_ := Site_API.Get_Company(rec_.contract);
      external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

      -- gelr:br_external_tax_integration, added AVALARA_TAX_BRAZIL
      IF (external_tax_calc_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL)) AND
         NOT Source_Tax_Item_Order_API.Tax_Exist(company_, Tax_Source_API.DB_CUSTOMER_ORDER_LINE, rec_.order_no) THEN
         Fetch_External_Tax(rec_.order_no);
      END IF;   
   END IF;
   info_ := Client_SYS.Append_Info(info_);
END Set_Released__;


@Override
PROCEDURE Release_Blocked__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_             CUSTOMER_ORDER_TAB%ROWTYPE;
   shipment_id_tab_ Shipment_API.Shipment_Id_Tab;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      -- IF the order gets block when releasing the order, no shipment will create.
      -- But when we handle the block customer order we are not able to trap the state transition planned to Release.
      -- So this validation traps the last available state of the order and proceeds for shipment creation if the shipment creation method is 
      -- "Create shipment at Order Release" or "Add to existing shipment at Order Release"
      rec_  := Get_Object_By_Id___(objid_);
      IF( rec_.rowstate = 'Released' OR (rec_.rowstate = 'Reserved' AND rec_.blocked_from_state = 'Planned')) THEN
         -- Even if the shipment creation called no shipment create for the lines where shipment is already connected.
         Shipment_Order_Utility_API.Create_Automatic_Shipments( shipment_id_tab_, rec_.order_no );
      END IF;
      rec_.blocked_from_state := NULL;
      IF (rec_.rowstate != 'Blocked' AND rec_.blocked_reason IS NOT NULL) THEN
         rec_.blocked_reason := NULL;   
      END IF;   
      Modify___(rec_);
   END IF;
   info_ := Client_SYS.Append_Info(info_);   
END Release_Blocked__;


-- Get_Freight_Charges_Count__
--   If there are freight charges connected to the order this will return count
@UncheckedAccess
FUNCTION Get_Freight_Charges_Count__ (order_no_ IN VARCHAR2) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT count(coc.sequence_no)
      FROM CUSTOMER_ORDER_CHARGE_TAB coc, sales_charge_type_tab sct
      WHERE coc.order_no = order_no_
      AND sct.contract = coc.contract
      AND sct.charge_type = coc.charge_type
      AND sct.sales_chg_type_category = 'FREIGHT';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Get_Freight_Charges_Count__;


-- Set_Earliest_Delivery_Date__
--   Set all the Delivery Dates of customer order lines to the latest of all
PROCEDURE Set_Earliest_Delivery_Date__ (
   order_no_ IN VARCHAR2 )
IS
   max_delivery_date_ DATE;
   attr_              VARCHAR2(32000);
   temp_              NUMBER;

   CURSOR check_distinct_del_date IS
      SELECT COUNT(DISTINCT planned_delivery_date)
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND rowstate != 'Cancelled';

   CURSOR get_max_ship_date IS
      SELECT MAX(planned_delivery_date)
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND rowstate != 'Cancelled';

   CURSOR get_all_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND planned_delivery_date != max_delivery_date_
      AND rowstate != 'Cancelled';
BEGIN
   OPEN check_distinct_del_date;
   FETCH check_distinct_del_date INTO temp_;
   CLOSE check_distinct_del_date;

   IF (temp_ > 1) THEN
      OPEN get_max_ship_date;
      FETCH get_max_ship_date INTO max_delivery_date_;
      CLOSE get_max_ship_date;

      IF (max_delivery_date_ IS NOT NULL) THEN
         FOR item IN get_all_lines LOOP
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', max_delivery_date_, attr_);
            Customer_Order_Line_Api.Modify(attr_, order_no_, item.line_no, item.rel_no, item.line_item_no);
         END LOOP;
      END IF;
   END IF;
END Set_Earliest_Delivery_Date__;


-- Get_Ord_Line_Totals__
--   Retrieve the totals of the order in an attr string. Intend is to minimize the access to the line level from client.
@UncheckedAccess
PROCEDURE Get_Ord_Line_Totals__ (
   total_base_price_    OUT NUMBER,
   total_sale_price_    OUT NUMBER,
   total_weight_        OUT NUMBER,
   total_quantity_      OUT NUMBER,
   total_cost_          OUT NUMBER,
   total_contribution_  OUT NUMBER,
   total_tax_amount_    OUT NUMBER,
   total_gross_amount_  OUT NUMBER,
   total_add_disc_amt_  OUT NUMBER,
   order_no_            IN  VARCHAR2 ) 
IS
   ordrec_                    CUSTOMER_ORDER_TAB%ROWTYPE;
   company_                   VARCHAR2(20);
   rounding_                  NUMBER;
   currency_rounding_         NUMBER;
   net_amount_                NUMBER;
   gross_amount_              NUMBER;
   discount_                  NUMBER;
   add_discount_              NUMBER;
   line_discount_amount_      NUMBER;
   rental_                    VARCHAR2(5);
   total_sale_price_incl_tax_ NUMBER;
   total_base_price_incl_tax_ NUMBER;
   total_tax_amount_base_     NUMBER;
   rental_chargeable_days_    NUMBER;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, 
             line_total_weight, line_total_qty,
             ROUND((cost * ABS(revised_qty_due)), rounding_) total_cost,
             (buy_qty_due * price_conv_factor * sale_unit_price) net_amount, rental,
             (buy_qty_due * price_conv_factor * unit_price_incl_tax) gross_amount,
             discount, additional_discount, buy_qty_due, price_conv_factor
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   order_no = order_no_;
BEGIN
   ordrec_                    := Get_Object_By_Keys___(order_no_);
   company_                   := Site_API.Get_Company(ordrec_.contract);
   currency_rounding_         := Currency_Code_API.Get_Currency_Rounding(company_,ordrec_.currency_code);
   rounding_                  := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   total_base_price_          := 0;
   total_base_price_incl_tax_ := 0;
   total_sale_price_          := 0;
   total_sale_price_incl_tax_ := 0;
   total_weight_              := 0;
   total_quantity_            := 0;
   total_cost_                := 0;
   total_contribution_        := 0;
   total_tax_amount_          := 0;
   total_tax_amount_base_     := 0;
   total_gross_amount_        := 0;
   total_add_disc_amt_        := 0;
   net_amount_                := 0;
   gross_amount_              := 0;
   discount_                  := 0;
   add_discount_              := 0;
   total_tax_amount_base_     := Customer_Order_Line_API.Get_Total_Tax_Amount_Base(order_no_, NULL, NULL, NULL, rounding_);
   FOR rec_ IN get_lines LOOP
      total_base_price_          := total_base_price_ + Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      total_base_price_incl_tax_ := total_base_price_incl_tax_ + Customer_Order_Line_API.Get_Base_Price_Incl_Tax_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      total_sale_price_          := total_sale_price_ + Customer_Order_Line_API.Get_Sale_Price_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no) ;
      total_tax_amount_          := total_tax_amount_ + Customer_Order_Line_API.Get_Total_Tax_Amount_Curr(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, currency_rounding_);
      total_weight_              := total_weight_ + NVL(rec_.line_total_weight, 0);
      total_quantity_            := total_quantity_ + NVL(rec_.line_total_qty, 0);
      total_cost_                := total_cost_ + NVL(rec_.total_cost, 0);
      net_amount_                := NVL(rec_.net_amount, 0);
      gross_amount_              := NVL(rec_.gross_amount, 0);
      discount_                  := NVL(rec_.discount, 0);
      add_discount_              := NVL(rec_.additional_discount, 0);
      line_discount_amount_      :=  Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                                                                                          rec_.buy_qty_due, rec_.price_conv_factor,  currency_rounding_);
      rental_                    := NVL(rec_.rental, Fnd_Boolean_API.DB_FALSE);
      
      IF (rental_ = Fnd_Boolean_API.DB_TRUE) THEN
         $IF Component_Rental_SYS.INSTALLED $THEN
            rental_chargeable_days_ := Rental_Object_API.Get_Rental_Chargeable_Days(order_no_, 
                                                                                    rec_.line_no, 
                                                                                    rec_.rel_no, 
                                                                                    rec_.line_item_no, 
                                                                                    Rental_Type_API.DB_CUSTOMER_ORDER);
            gross_amount_           := gross_amount_ * rental_chargeable_days_; 
            net_amount_             := net_amount_ * rental_chargeable_days_;            
         $ELSE
            NULL;
         $END
      END IF;
      
      IF (ordrec_.use_price_incl_tax = 'TRUE') THEN
         total_add_disc_amt_ := total_add_disc_amt_ + ROUND(((gross_amount_ - line_discount_amount_) * NVL(add_discount_, 0)/100), currency_rounding_);
      ELSE
         total_add_disc_amt_ := total_add_disc_amt_ + ROUND(((net_amount_ - line_discount_amount_) * NVL(add_discount_, 0)/100), currency_rounding_);
      END IF;
   END LOOP;

   total_tax_amount_ := ROUND(total_tax_amount_, currency_rounding_);
   IF (ordrec_.use_price_incl_tax = 'TRUE') THEN
      total_sale_price_incl_tax_ := Customer_Order_Line_API.Get_Sale_Price_Incl_Tax_Total(order_no_);
      total_gross_amount_ := total_sale_price_incl_tax_;
      total_sale_price_   := total_sale_price_incl_tax_ - total_tax_amount_;
      total_base_price_   := total_base_price_incl_tax_ - total_tax_amount_base_;
   ELSE
      total_gross_amount_ := total_sale_price_ + total_tax_amount_;
   END IF;
   total_contribution_ := total_base_price_ - total_cost_;
END Get_Ord_Line_Totals__;

-- Check_Ipd_Ipt_Exist__
--   Determines if Order Change message is to be sent and if supply_code = IPD or IPT exist
--   for a particular customer order.
PROCEDURE Check_Ipd_Ipt_Exist__ (
   info_                 OUT VARCHAR2,
   ipd_exist_            OUT VARCHAR2,
   ipt_exist_            OUT VARCHAR2,
   only_ipt_exist_       OUT VARCHAR2,
   send_change_          OUT VARCHAR2,
   replicate_label_note_ OUT VARCHAR2,
   order_no_             IN  VARCHAR2,
   label_note_changed_   IN  VARCHAR2 )
IS
   dummy_                     NUMBER;
   label_note_                VARCHAR2(50);
   col_send_change_           VARCHAR2(5):='FALSE';
   send_change_not_allowed_   BOOLEAN:=FALSE; 
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, supply_code, qty_on_order   
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
      AND   supply_code IN ('IPD', 'IPT')
      AND   order_no = order_no_;

   CURSOR get_transit_po_line IS
      SELECT 1   
        FROM CUSTOMER_ORDER_LINE_TAB
       WHERE rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
         AND (supply_code != 'IPT')
         AND order_no = order_no_;  

   CURSOR get_pd_pt_lines IS
      SELECT DISTINCT copo.po_order_no   
        FROM CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_PUR_ORDER_TAB copo
       WHERE col.order_no         = order_no_
         AND copo.oe_order_no     = col.order_no
         AND copo.oe_line_no      = col.line_no
         AND copo.oe_rel_no       =  col.rel_no
         AND copo.oe_line_item_no =  col.line_item_no
         AND copo.purchase_type   = 'O'
         AND col.rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
         AND col.supply_code IN ('PD', 'PT'); 

   CURSOR get_pd_pt_po_lines(po_order_no_ IN VARCHAR2) IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no    
        FROM CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_PUR_ORDER_TAB copo
       WHERE copo.po_order_no     = po_order_no_
         AND col.order_no         = copo.oe_order_no 
         AND col.line_no          = copo.oe_line_no
         AND col.rel_no           = copo.oe_rel_no
         AND col.line_item_no     = copo.oe_line_item_no
         AND copo.purchase_type   = 'O'
         AND col.rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
         AND col.supply_code IN ('PD', 'PT');      
BEGIN 
   ipd_exist_            := 'FALSE';
   ipt_exist_            := 'FALSE';
   only_ipt_exist_       := 'FALSE';
   replicate_label_note_ := 'FALSE';
   send_change_          := 'FALSE';
   
   FOR order_line_ IN get_lines LOOP
      IF (order_line_.supply_code IN ('IPD', 'IPT')) THEN
         col_send_change_:= CUSTOMER_ORDER_LINE_API.Get_Send_Change_Msg_For_Supp(order_no_, order_line_.line_no, order_line_.rel_no, order_line_.line_item_no);
         IF (col_send_change_ = 'TRUE') THEN
            send_change_ := 'TRUE';
         ELSE
            send_change_not_allowed_ := TRUE;  
         END IF;   
      END IF;
      IF (order_line_.supply_code = 'IPD' AND order_line_.qty_on_order > 0 AND (ipd_exist_ = 'FALSE' OR ipd_exist_ IS NULL)) THEN
         ipd_exist_ := 'TRUE';
      END IF;
      IF (order_line_.supply_code = 'IPT' AND order_line_.qty_on_order > 0 AND (ipt_exist_ = 'FALSE' OR ipt_exist_ IS NULL)) THEN
         ipt_exist_ := 'TRUE';
      END IF;
      IF (send_change_not_allowed_ AND  order_line_.qty_on_order = 0) THEN
         send_change_not_allowed_ := FALSE;
      END IF; 
   END LOOP;
   
   IF ((ipd_exist_ = 'FALSE') AND (ipt_exist_ = 'TRUE')) THEN
      OPEN get_transit_po_line ;
      FETCH get_transit_po_line INTO dummy_;
      IF (get_transit_po_line%NOTFOUND) THEN
         only_ipt_exist_ := 'TRUE';
      END IF;
      CLOSE get_transit_po_line;
   END IF;   

   IF (label_note_changed_ = 'TRUE') THEN
      IF (ipd_exist_ = 'TRUE') THEN
         replicate_label_note_ := 'TRUE';
      END IF;
      -- PD or PT lines, PO label note found and needs replication 
      FOR pd_pt_rec_ IN get_pd_pt_lines LOOP
         $IF Component_Purch_SYS.INSTALLED $THEN
            label_note_ := Purchase_Order_API.Get_label_Note(pd_pt_rec_.po_order_no);
            IF (label_note_ IS NULL) THEN
               replicate_label_note_ := 'TRUE';
               FOR pd_pt_po_lines_rec_ IN get_pd_pt_po_lines(pd_pt_rec_.po_order_no) LOOP
                  col_send_change_:= Customer_Order_Line_API.Get_Send_Change_Msg_For_Supp(pd_pt_po_lines_rec_.order_no, pd_pt_po_lines_rec_.line_no,
                                                                                          pd_pt_po_lines_rec_.rel_no, pd_pt_po_lines_rec_.line_item_no);
                  IF (col_send_change_ = 'TRUE') THEN
                     send_change_ := 'TRUE';
                     IF send_change_not_allowed_ THEN
                        EXIT;
                     END IF;
                  ELSE
                     send_change_not_allowed_ := TRUE;
                  END IF;       
               END LOOP;
            END IF;   
         $ELSE
            replicate_label_note_ := 'FALSE';
            EXIT;
         $END
      END LOOP;     
   END IF;   

   IF send_change_not_allowed_ THEN
      Client_SYS.Add_Info(lu_name_, 'ORDCHGNOTSENT: A change request will not be sent automatically to some of the supplier(s) for pegged purchase order(s).');
   END IF;   
   
   info_  := Client_SYS.Get_All_Info;   
END Check_Ipd_Ipt_Exist__;

-- Check_Line_Peggings__
--   Determines if Order Change message is to be sent and if peggings exist
--   for a particular customer order.
PROCEDURE Check_Line_Peggings__ (
   send_change_   OUT VARCHAR2,
   pegging_exist_ OUT VARCHAR2,
   order_no_      IN  VARCHAR2)
IS
   dop_connections_ NUMBER := 0;
   
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no, supply_code, qty_on_order   
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
      AND   supply_code IN ('IPD', 'IPT', 'PT', 'PD', 'SO', 'DOP', 'PKG')
      AND   order_no = order_no_;
BEGIN
   FOR order_line_ IN get_lines LOOP
      IF (order_line_.supply_code IN ('IPD', 'IPT', 'PT', 'PD', 'PKG')) THEN
         IF ( send_change_ IS NULL OR send_change_ = Fnd_Boolean_API.DB_FALSE ) THEN
            send_change_:= CUSTOMER_ORDER_LINE_API.Get_Send_Change_Msg_For_Supp(order_no_, order_line_.line_no, order_line_.rel_no, order_line_.line_item_no);
         END IF;
      END IF;

      IF (order_line_.supply_code IN ('IPD', 'IPT', 'PT', 'PD', 'SO') AND order_line_.qty_on_order > 0 ) THEN
         pegging_exist_ := 'TRUE';
      END IF;
      
      IF (order_line_.supply_code = 'DOP') THEN
         $IF Component_Dop_SYS.INSTALLED $THEN
            dop_connections_ := Dop_Demand_Cust_Ord_API.Get_No_Of_All_Dop_Headers(order_no_, order_line_.line_no, order_line_.rel_no, order_line_.line_item_no);
         $END
         IF (dop_connections_ > 0) AND (order_line_.qty_on_order > 0) THEN
            pegging_exist_ := 'TRUE';
         END IF;
      END IF;

      IF ((order_line_.supply_code = 'PKG') AND (CUSTOMER_ORDER_LINE_API.Check_Auto_Pegged_Comp_Exist(order_no_, order_line_.line_no, order_line_.rel_no, order_line_.line_item_no)) = 'TRUE') THEN
         pegging_exist_ := 'TRUE';
      END IF;
      EXIT WHEN ( send_change_ = Fnd_Boolean_API.DB_TRUE AND pegging_exist_ = Fnd_Boolean_API.DB_TRUE );
   END LOOP;
END Check_Line_Peggings__;

-- Add_Lines_From_Template__
--   Takes in bulk of customer order lines sent from CO template,
--   unpacks each line and create new records.
PROCEDURE Add_Lines_From_Template__ (
   info_ OUT    VARCHAR2,
   attr_ IN OUT     VARCHAR2)
IS
   lineattr_   VARCHAR2(32000);
   ptr_        NUMBER := NULL;
   name_       VARCHAR2(30);
   value_      VARCHAR2(4000);
   curr_info_  VARCHAR2(2000);
   create_template_from_aurena_ VARCHAR2(5) := 'FALSE';
   order_no_  VARCHAR2(200);
BEGIN
   -- Retrieve parameters from the attribute string
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'ORDER_NO') THEN
         Client_SYS.Add_To_Attr('ORDER_NO', value_, lineattr_);
         order_no_ := value_;
      ELSIF (name_ = 'CONTRACT') THEN
         Client_SYS.Add_To_Attr('CONTRACT', value_, lineattr_);
      ELSIF (name_ = 'CATALOG_NO') THEN
         Client_SYS.Add_To_Attr('CATALOG_NO', value_, lineattr_);
      ELSIF (name_ = 'CATALOG_DESC') THEN
         Client_SYS.Add_To_Attr('CATALOG_DESC', value_, lineattr_);
      ELSIF (name_ = 'BUY_QTY_DUE') THEN
         Client_SYS.Add_To_Attr('BUY_QTY_DUE', value_, lineattr_);
      ELSIF (name_ = 'CONDITION_CODE') THEN  
         Client_SYS.Add_To_Attr('CONDITION_CODE', value_, lineattr_);
      ELSIF (name_ = 'CUSTOMER_PART_NO') THEN
         Client_SYS.Add_To_Attr('CUSTOMER_PART_NO', value_, lineattr_); 
      ELSIF (name_ = 'RENTAL_DB') THEN
         Client_SYS.Add_To_Attr('RENTAL_DB', value_, lineattr_);
      ELSIF (name_ = 'PLANNED_RENTAL_START_DATE') THEN
         Client_SYS.Add_To_Attr('PLANNED_RENTAL_START_DATE', value_, lineattr_);
      ELSIF (name_ = 'PLANNED_RENTAL_START_TIME') THEN
         Client_SYS.Add_To_Attr('PLANNED_RENTAL_START_TIME', value_, lineattr_);
      ELSIF (name_ = 'PLANNED_RENTAL_END_DATE') THEN
         Client_SYS.Add_To_Attr('PLANNED_RENTAL_END_DATE', value_, lineattr_);
      ELSIF (name_ = 'PLANNED_RENTAL_END_TIME') THEN
         Client_SYS.Add_To_Attr('PLANNED_RENTAL_END_TIME', value_, lineattr_);
      ELSIF (name_ = 'COPY_DISCOUNT') THEN
         Client_SYS.Add_To_Attr('COPY_DISCOUNT', value_, lineattr_);
      ELSIF (name_ = 'CREATE_TEMPLATE_FROM_AURENA') THEN
         create_template_from_aurena_ := value_;
      ELSIF (name_ = 'END_OF_LINE') THEN
         Customer_Order_Line_API.New (curr_info_,lineattr_);
         info_ := info_ || curr_info_;
         IF (create_template_from_aurena_ = 'TRUE') THEN
            attr_ :=  lineattr_;
            Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
         END IF;
         Client_SYS.Clear_Attr(lineattr_);
      END IF;
   END LOOP;   
END Add_Lines_From_Template__;

PROCEDURE Copy_Customer_Order__ (
   to_order_no_               IN OUT VARCHAR2,
   from_order_no_             IN     VARCHAR2, 
   customer_no_               IN     VARCHAR2,
   order_id_                  IN     VARCHAR2,
   currency_code_             IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   wanted_delivery_date_      IN     DATE,
   copy_order_lines_          IN     VARCHAR2,
   copy_rental_order_lines_   IN     VARCHAR2,
   copy_charges_              IN     VARCHAR2,
   copy_order_adresses_       IN     VARCHAR2,
   copy_delivery_info_        IN     VARCHAR2,
   copy_misc_order_info_      IN     VARCHAR2,   
   copy_document_info_        IN     VARCHAR2, 
   copy_tax_detail_           IN     VARCHAR2,
   copy_pricing_              IN     VARCHAR2,
   copy_document_texts_       IN     VARCHAR2,
   copy_notes_                IN     VARCHAR2,   
   copy_representatives_      IN     VARCHAR2,
   copy_contacts_             IN     VARCHAR2,
   copy_pre_accounting_       IN     VARCHAR2)
IS
   true_                    VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
   false_                   VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   $IF Component_Rmcom_SYS.INSTALLED $THEN   
      business_object_type_db_ VARCHAR2(30) := Business_Object_Type_API.DB_CUSTOMER_ORDER;
   $END
BEGIN
   Copy_Customer_Order_Header___ (to_order_no_,
                                 from_order_no_, 
                                 customer_no_,
                                 order_id_,
                                 currency_code_,
                                 contract_,
                                 wanted_delivery_date_,
                                 copy_order_adresses_,
                                 copy_misc_order_info_,      
                                 copy_delivery_info_,
                                 copy_document_info_, 
                                 copy_tax_detail_,
                                 copy_pricing_,
                                 copy_document_texts_,
                                 copy_notes_,   
                                 copy_pre_accounting_,
                                 copy_charges_ ); 
 
   $IF Component_Rmcom_SYS.INSTALLED $THEN   
      IF (NVL(copy_representatives_, false_) = true_) THEN
         Bus_Obj_Representative_API.Copy_Representative(from_order_no_, 
                                                     to_order_no_, 
                                                     business_object_type_db_, 
                                                     business_object_type_db_,
                                                     false_);
      END IF;
      IF(NVL(copy_contacts_, false_) = true_) THEN
         Business_Object_Contact_API.Copy_Contact(from_order_no_, 
                                                  to_order_no_, 
                                                  business_object_type_db_, 
                                                  business_object_type_db_);
      END IF;
   $END
 
   IF ((NVL(copy_order_lines_, false_) = true_) OR (NVL(copy_rental_order_lines_, false_) = true_)) THEN
      Customer_Order_Line_API.Copy_Customer_Order_Line (from_order_no_,
                                                        to_order_no_,
                                                        copy_order_lines_,
                                                        copy_rental_order_lines_, 
                                                        copy_charges_,
                                                        copy_order_adresses_,
                                                        copy_delivery_info_,
                                                        copy_misc_order_info_, 
                                                        copy_tax_detail_,
                                                        copy_pricing_,
                                                        copy_document_texts_,
                                                        copy_notes_,
                                                        copy_pre_accounting_);

   END IF;

   IF (NVL(copy_charges_, false_) = true_) THEN
      Customer_Order_Charge_API.Copy_Charge_Lines( from_order_no_,
                                                    to_order_no_,
                                                    copy_order_lines_,
                                                    copy_document_texts_);
   END IF;
END Copy_Customer_Order__; 

PROCEDURE Build_Attr_For_New__ (
   attr_ IN OUT VARCHAR2 )
IS 
   temp_attr_    VARCHAR2(32000);
BEGIN   
   temp_attr_ := Build_Attr_For_New___(attr_);   
   attr_ := temp_attr_;
END Build_Attr_For_New__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Charge_Gross_Amount
--   Retrieves the Charge Gross Amount for all order lines on the
--   specified order.
FUNCTION Get_Charge_Gross_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_chg_net_amount_   NUMBER;
   total_chg_tax_amount_   NUMBER;
   total_chg_gross_amount_ NUMBER;
BEGIN
   total_chg_net_amount_   := Get_Total_Base_Charge__(order_no_);
   total_chg_tax_amount_   := Get_Tot_Charge_Base_Tax_Amount(order_no_) ;
   total_chg_gross_amount_ := total_chg_net_amount_ + total_chg_tax_amount_;
   RETURN total_chg_gross_amount_;
END Get_Charge_Gross_Amount;


PROCEDURE Modify_Grp_Disc_Calc_Flag (
   order_no_           IN VARCHAR2,
   grp_disc_calc_flag_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_);

   IF (oldrec_.grp_disc_calc_flag != grp_disc_calc_flag_) THEN
      Client_SYS.Clear_Attr(attr_);
      newrec_ := oldrec_;
      Client_SYS.Add_To_Attr('GRP_DISC_CALC_FLAG', Gen_Yes_No_API.Decode(grp_disc_calc_flag_), attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Modify_Grp_Disc_Calc_Flag;


-- Check_Ship_Via_Code
--   Checks if Ship_Via_Code is used by any record. (Used by Mpccom)
@UncheckedAccess
FUNCTION Check_Ship_Via_Code (
   ship_via_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM CUSTOMER_ORDER_TAB
      WHERE ship_via_code = ship_via_code_
      AND rowstate NOT IN ('Invoiced', 'Cancelled');
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF exist_control%NOTFOUND THEN
      CLOSE exist_control;
      RETURN FALSE;
   END IF;
   CLOSE exist_control;
   RETURN TRUE;
END Check_Ship_Via_Code;


-- Calculate_Planned_Due_Date
--   Calculate the planned due date for an order line with
--   the specified supply_code and planned_delivery_date.
--   Generate an error if the delivery date specified is not valid.
--   This procedure is called from shortage handling.
PROCEDURE Calculate_Planned_Due_Date (
   planned_due_date_      IN OUT DATE,
   order_no_              IN     VARCHAR2,
   planned_delivery_date_ IN     DATE,
   supply_code_           IN     VARCHAR2 )
IS
BEGIN
   IF (trunc(planned_delivery_date_) < trunc(Site_API.Get_Site_Date(Get_Contract(order_no_)))) THEN
      Error_SYS.Record_General(lu_name_, 'OLDDATE: This date may not be earlier than today''s date!');
   END IF;

   planned_due_date_ := Calculate_Planned_Due_Date(order_no_, planned_delivery_date_, NULL, supply_code_);
END Calculate_Planned_Due_Date;


-- Calculate_Planned_Due_Date
--   Calculate the planned due date for an order line with the specified
--   catalog_no and/or supply_code and wanted_delivery_date.
--   This method is called from Customer Scheduling.
FUNCTION Calculate_Planned_Due_Date (
   order_no_             IN VARCHAR2,
   wanted_delivery_date_ IN DATE,
   catalog_no_           IN VARCHAR2,
   supply_code_          IN VARCHAR2 ) RETURN DATE
IS
   rec_                   CUSTOMER_ORDER_TAB%ROWTYPE;
   supply_code_db_        VARCHAR2(3);
   planned_due_date_      DATE;
   planned_ship_date_     DATE;
   planned_delivery_date_ DATE;
   supply_site_due_date_  DATE;
   vendor_no_             customer_order_line_tab.line_no%TYPE := NULL;
   supplier_ship_via_     VARCHAR2(3);
   sprec_                 Sales_Part_API.Public_Rec;
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_);

   planned_delivery_date_ := wanted_delivery_date_;

   -- IF no supply code was specified retrieve the default for the sales part.
   supply_code_db_ := Order_Supply_Type_API.Encode(nvl(supply_code_,
                                                   Sales_Part_API.Get_Default_Supply_Code(rec_.contract, catalog_no_)));

   -- date calculation method doesn't handle Automatic Sourcing - use Not Decided in that case...
   IF (supply_code_db_ = 'SRC') THEN
      supply_code_db_ := 'ND';
   END IF;

   sprec_ := Sales_Part_API.Get(rec_.contract, catalog_no_);

   -- fetch default supplier and supplier information
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF (supply_code_db_ IN ('PD', 'PT', 'IPD', 'IPT')) THEN
         vendor_no_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(rec_.contract, nvl(sprec_.part_no, sprec_.purchase_part_no));  

         -- fetch supplier's ship via code for transit delivery
         CUSTOMER_ORDER_LINE_API.Get_Def_Supplier_Ship_Via__(supplier_ship_via_, vendor_no_, rec_.contract, sprec_.part_no, supply_code_db_, 
                                                             rental_db_ => Fnd_Boolean_API.DB_FALSE);         
      END IF;
   $END
   -- no ATP analysis should be performed - only date calculation...

   Cust_Ord_Date_Calculation_API.Calc_Order_Dates_Backwards(planned_delivery_date_,
                     planned_ship_date_, planned_due_date_, supply_site_due_date_,
                     wanted_delivery_date_, SYSDATE, NULL, rec_.customer_no, rec_.ship_addr_no,
                     vendor_no_, rec_.ship_via_code, rec_.delivery_leadtime, rec_.picking_leadtime, rec_.ext_transport_calendar_id, supplier_ship_via_,
                     'NOTALLOWED', rec_.route_id, supply_code_db_, rec_.contract, sprec_.part_no,
                     nvl(sprec_.part_no, sprec_.purchase_part_no), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, TRUE, 'COMPANY OWNED', 'COMPANY OWNED');

   RETURN planned_due_date_;
END Calculate_Planned_Due_Date;


-- Calculate_Planned_Deliv_Date
--   Calculate the planned delivery date for an order line with the
--   specified planned_due_date.
--   Generate an error if the planned due date specified is not valid.
--   This procedure is called from shortage handling and assumes that
--   the goods will be reserved and picked at our inventory.
PROCEDURE Calculate_Planned_Deliv_Date (
   planned_delivery_date_ IN OUT DATE,
   order_no_              IN     VARCHAR2,
   planned_due_date_      IN     DATE )
IS
   CURSOR get_attr IS
      SELECT contract, delivery_leadtime, ext_transport_calendar_id, route_id, customer_no, ship_addr_no, addr_flag, picking_leadtime
      FROM   CUSTOMER_ORDER_TAB
      WHERE  order_no = order_no_;

   rec_         get_attr%ROWTYPE;
   calendar_id_ VARCHAR2(10);
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO rec_;
   CLOSE get_attr;

   calendar_id_ := Site_API.Get_Dist_Calendar_Id(rec_.contract);

   IF (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, planned_due_date_) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'NOT_WORKING_DAY: :P1 is not a working day!', to_char(planned_due_date_, Report_SYS.date_format_));
   END IF;

   Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(planned_delivery_date_, calendar_id_, planned_due_date_, rec_.picking_leadtime);
   Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(planned_delivery_date_, 
                                                         rec_.ext_transport_calendar_id, 
                                                         planned_delivery_date_, 
                                                         rec_.delivery_leadtime);

   -- IF the specified order is connected to a route then the possible delivery days will
   -- be determined by the departure days for that route. Don't use route's time!
   IF (rec_.route_id IS NOT NULL) THEN
      planned_delivery_date_ := trunc(Delivery_Route_API.Get_Route_Delivery_Date(rec_.route_id,
                                       planned_delivery_date_, Site_API.Get_Site_Date(rec_.contract), rec_.delivery_leadtime, rec_.ext_transport_calendar_id, rec_.contract));
   ELSE
      planned_delivery_date_ := Construct_Delivery_Time___(planned_delivery_date_, rec_.customer_no, rec_.ship_addr_no, rec_.addr_flag);
   END IF;
END Calculate_Planned_Deliv_Date;


-- Get_Next_Line_No
--   Retrieve new line_no, rel_no and line_item_no for a order line.
--   Called when registering a new order line.
PROCEDURE Get_Next_Line_No (
   rel_no_         OUT    VARCHAR2,
   line_item_no_   OUT    NUMBER,
   line_no_        IN OUT VARCHAR2,
   order_no_       IN     VARCHAR2,
   contract_       IN     VARCHAR2,
   catalog_no_     IN     VARCHAR2,
   supply_code_    IN     VARCHAR2,
   demand_code_db_ IN     VARCHAR2 DEFAULT NULL,
   rental_db_      IN     VARCHAR2 DEFAULT 'FALSE' )
IS
   line_           VARCHAR2(4);
   rel_            VARCHAR2(4);
   line_no_count_  NUMBER;
   supply_code_db_ VARCHAR2(20);
   rel_no_count_   NUMBER;

   CURSOR get_line_no IS
      SELECT to_char(max(to_number(line_no)))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    contract = contract_
      AND    catalog_no = catalog_no_
      AND    line_item_no <= 0
      AND    rental = rental_db_;

   CURSOR get_release_no IS
      SELECT to_char(max(to_number(rel_no)))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_no_
      AND    contract = contract_
      AND    line_item_no <= 0;

   CURSOR get_rel_no IS
      SELECT to_char(max(to_number(rel_no)))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_
      AND    contract = contract_
      AND    catalog_no = catalog_no_
      AND    line_item_no <= 0;

   CURSOR get_line IS
      SELECT to_char(max(to_number(line_no)))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_item_no <= 0;

   CURSOR count_line_no IS
      SELECT count(DISTINCT(to_number(line_no)))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    contract = contract_;
   
   CURSOR count_rel_no IS
      SELECT count(DISTINCT(to_number(rel_no)))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_
      AND    contract || '' = contract_
      AND    catalog_no || '' = catalog_no_; 
   
   CURSOR count_release_no IS
      SELECT count(DISTINCT(to_number(rel_no)))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    line_no = line_
      AND    contract || '' = contract_;        
BEGIN
   supply_code_db_ := NVL(Order_Supply_Type_API.Encode(supply_code_), Order_Supply_Type_API.DB_INVENT_ORDER);
   line_           := line_no_;

   IF (catalog_no_ IS NULL)  OR
      (supply_code_db_ = Order_Supply_Type_API.DB_COMPONENT_REPAIR_ORDER) OR (supply_code_db_ = Order_Supply_Type_API.DB_COMPONENT_REPAIR_EXCHANGE) THEN
      OPEN get_line;
      FETCH get_line INTO line_;
      IF get_line%FOUND THEN
         IF (to_number(line_) + 1 > 9999) THEN
            Error_Sys.Record_General(lu_name_,'NOMORELINENO: The maximum limit of the line number has been reached.');
         END IF;
         line_ := to_char(to_number(line_) + 1); 
      ELSE
         line_ := '1';
      END IF;
      rel_  := '1';
      CLOSE get_line;
   ELSE
      IF ((NVL(demand_code_db_, Order_Supply_Type_API.DB_INVENT_ORDER) = Order_Supply_Type_API.DB_COMPONENT_REPAIR_ORDER) OR (NVL(demand_code_db_, Order_Supply_Type_API.DB_INVENT_ORDER) = Order_Supply_Type_API.DB_COMPONENT_REPAIR_EXCHANGE)) AND
          (supply_code_db_ = Order_Supply_Type_API.DB_SERVICE_ORDER) AND (line_no_ IS NOT NULL) THEN
         OPEN get_release_no;
         FETCH get_release_no INTO rel_;
         CLOSE get_release_no; 
         IF (to_Number(rel_) + 1 > 9999) THEN
            OPEN count_release_no;
            FETCH count_release_no INTO rel_no_count_;
            CLOSE count_release_no;
           
            IF (rel_no_count_ < 9999) THEN               
               Error_Sys.Record_General(lu_name_,'RELNOMAX: The maximum limit of the delivery number has been reached. Enter a value less than 9999 in the Del No field manually.');
            ELSE
               Error_Sys.Record_General(lu_name_,'NOMORERELNO: The maximum limit of the delivery number has been reached.');
            END IF;
         END IF;
         rel_ := to_number(rel_) + 1;
      ELSE
         IF (line_no_ IS NULL) THEN
            OPEN get_line_no;
            FETCH get_line_no INTO line_;
            CLOSE get_line_no;
         ELSE
            line_ := line_no_;
         END IF;
         IF (line_ IS NOT NULL) THEN
            OPEN get_rel_no;
            FETCH get_rel_no INTO rel_;
            CLOSE get_rel_no;
            IF (to_Number(rel_) + 1 > 9999) THEN
               OPEN count_rel_no;
               FETCH count_rel_no INTO rel_no_count_;
               CLOSE count_rel_no;
           
               IF (rel_no_count_ < 9999) THEN               
                  Error_Sys.Record_General(lu_name_,'RELNOMAX: The maximum limit of the delivery number has been reached. Enter a value less than 9999 in the Del No field manually.');
               ELSE
                  Error_Sys.Record_General(lu_name_,'NOMORERELNO: The maximum limit of the delivery number has been reached.');
               END IF;
            END IF;
            rel_ := to_number(rel_) + 1;
         ELSE
            OPEN get_line;
            FETCH get_line INTO line_;
            CLOSE get_line;
            IF (line_ IS NOT NULL) THEN
               IF (to_number(line_) + 1 > 9999) THEN
                  OPEN count_line_no;
                  FETCH count_line_no INTO line_no_count_;
                  CLOSE count_line_no;

                  IF (line_no_count_ < 9999) THEN
                     Error_Sys.Record_General(lu_name_,'LINENOMAX: The maximum limit of the line number has been reached. Enter a line number less than 9999 manually.');
                  ELSE
                     Error_Sys.Record_General(lu_name_,'NOMORELINENO: The maximum limit of the line number has been reached.');
                  END IF;    
               END IF;
              line_ := to_number(line_) + 1;
            ELSE
               line_ := '1';
            END IF;
            rel_ := '1';            
         END IF;
      END IF;
   END IF;
   
   IF (line_ IS NULL) THEN
      line_ := '1';
      rel_ := '1';     
   END IF;
   
   IF (rel_ IS NULL) THEN
      rel_ := '1';
   END IF;

   IF (supply_code_db_ = Order_Supply_Type_API.DB_PKG) THEN
      line_item_no_ := -1;
   ELSE
      line_item_no_ := 0;
   END IF;

   IF (line_no_ IS NULL) THEN
      line_no_ := line_;
   END IF;
   
   rel_no_ := rel_;
END Get_Next_Line_No;


-- Get_Total_Base_Price
--   Retrive the total base price for the specified order in base currency
--   rounding. Changes to this should apply to Get_Order_ToTals as well.
@UncheckedAccess
FUNCTION Get_Total_Base_Price (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_base_price_ NUMBER:= 0;
BEGIN
   total_base_price_ := Customer_Order_Line_API.Get_Base_Sale_Price_Total(order_no_, NULL, NULL, NULL);
   RETURN NVL(total_base_price_, 0);
END Get_Total_Base_Price;


--  Get_Total_Sales_Pirce
--    This method returns total order price in order currency.
@UncheckedAccess
FUNCTION Get_Total_Sales_Price(
   order_no_   IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   RETURN Get_Total_Sale_Price___(order_no_, FALSE);
END Get_Total_Sales_Price;


-- Get_Total_Base_Price_Incl_Tax
--   Retrive the total base price including tax for the specified order in base currency rounding.
@UncheckedAccess
FUNCTION Get_Total_Base_Price_Incl_Tax (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_base_price_incl_tax_ NUMBER:= 0;
   CURSOR get_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   order_no = order_no_;
BEGIN
   FOR rec_ IN get_lines LOOP
      total_base_price_incl_tax_ := total_base_price_incl_tax_ + Customer_Order_Line_API.Get_Base_Price_Incl_Tax_Total(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
   END LOOP;
   RETURN NVL(total_base_price_incl_tax_, 0);
END Get_Total_Base_Price_Incl_Tax;


-- Get_Total_Cost
--   Retrieve the total cost for the specified order. Changes to this should apply to Get_Ord_Line_ToTals__ as well.
@UncheckedAccess
FUNCTION Get_Total_Cost (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_cost_ NUMBER;
   company_    VARCHAR2(20);
   rounding_   NUMBER;

   CURSOR get_total_cost IS
      SELECT SUM(ROUND((cost * ABS(revised_qty_due)), rounding_))
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   order_no = order_no_;
BEGIN
   company_  := Site_API.Get_Company(Get_Contract(order_no_));
   rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, Company_Finance_API.Get_Currency_Code(company_));
   OPEN get_total_cost;
   FETCH get_total_cost INTO total_cost_;
   IF (get_total_cost%NOTFOUND) THEN
      total_cost_ := 0;
   END IF;
   CLOSE get_total_cost;
   RETURN NVL(total_cost_, 0);
END Get_Total_Cost;


-- Uses_Shipment_Inventory
--   Returns value for TRUE if order uses shipment inventory.FALSE (0) if not
@UncheckedAccess
FUNCTION Uses_Shipment_Inventory (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   uses_shipment_inventory_ NUMBER := 0;
   
   CURSOR get_order_lines IS
      SELECT order_no, line_no, rel_no, line_item_no
        FROM CUSTOMER_ORDER_LINE_TAB
       WHERE order_no = order_no_
         AND qty_picked < qty_assigned 
         AND rowstate IN ('Reserved', 'PartiallyDelivered', 'Picked');
         
BEGIN
   FOR rec_ IN get_order_lines LOOP
      uses_shipment_inventory_ := Customer_Order_Line_API.Uses_Shipment_Inventory(rec_.order_no, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      
      EXIT WHEN uses_shipment_inventory_ = 1;                                                                            
   END LOOP;
   
   RETURN uses_shipment_inventory_;
END Uses_Shipment_Inventory;


-- Set_Line_Qty_Assigned
--   Public interface used to generate a SetLineQtyAssigned event and
--   pass it to the state diagram.
PROCEDURE Set_Line_Qty_Assigned (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_assigned_ IN NUMBER,
   add_hist_log_ IN VARCHAR2 DEFAULT 'TRUE' )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
   Client_SYS.Add_To_Attr('ADD_HIST_LOG', add_hist_log_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   Set_Line_Qty_Assigned__(info_, objid_, objversion_, attr_, 'DO');
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Line_Qty_Assigned;


-- Set_Line_Qty_Picked
--   Public interface used to generate a SetLineQtyPicked event and pass it
--   to the state diagram
PROCEDURE Set_Line_Qty_Picked (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_picked_   IN NUMBER,
   add_hist_log_ IN VARCHAR2 DEFAULT 'TRUE')
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   new_state_  CUSTOMER_ORDER_TAB.rowstate%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_PICKED', qty_picked_, attr_);
   Client_SYS.Add_To_Attr('ADD_HIST_LOG', add_hist_log_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   Set_Line_Qty_Picked__(info_, objid_, objversion_, attr_, 'DO');
   new_state_ := Get_Objstate(order_no_);   
   IF ((rec_.rowstate != new_state_) AND (new_state_ = 'Released') AND (add_hist_log_ = 'TRUE')) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Line_Qty_Picked;


-- Set_Line_Qty_Shipped
--   Public interface used to generate a SetLineQtyDelivered event and
--   pass it to the state diagram
PROCEDURE Set_Line_Qty_Shipped (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_shipped_  IN NUMBER,
   from_undo_delivery_ IN VARCHAR2 DEFAULT 'FALSE')
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   rowstate_   CUSTOMER_ORDER_TAB.rowstate%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('FROM_UNDO_DELIVERY', from_undo_delivery_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);

   IF Customer_Order_Line_API.Get_Objstate(order_no_,line_no_, rel_no_,line_item_no_) != 'Cancelled' THEN
      Set_Line_Qty_Shipped__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   
   rowstate_ := Get_Objstate(order_no_);
   IF (rec_.rowstate != rowstate_) THEN
      IF(rowstate_ = 'Invoiced') THEN
         Customer_Order_History_API.New(order_no_, NULL, 'Delivered');
      END IF;
      IF (from_undo_delivery_ = 'FALSE') THEN
         Customer_Order_History_API.New(order_no_);
      END IF;
   END IF;
END Set_Line_Qty_Shipped;


-- Check_Ref_Line_Remove
--   Checks if the order line with the reference is in status Released, or
--   Reserved, so that cancel or remove is possible by customer scheduling.
@UncheckedAccess
FUNCTION Check_Ref_Line_Remove (
   order_no_         IN VARCHAR2,
   ref_id_           IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   min_date_         IN DATE,
   max_date_         IN DATE ) RETURN VARCHAR2
IS
   temp_         NUMBER;
   -- Note: check if all co lines related to the ref id are in Release or Reserved state
   CURSOR scheduled_order_lines IS
      SELECT 1
      FROM  customer_order_line_tab col
      WHERE col.order_no             = order_no_
      AND   col.customer_part_no     = customer_part_no_
      AND   col.ref_id               = ref_id_
      AND   col.wanted_delivery_date >= min_date_
      AND   col.wanted_delivery_date <= max_date_
      AND   col.rowstate             IN ('Delivered', 'Invoiced', 'PartiallyDelivered', 'Picked');
BEGIN
   OPEN  scheduled_order_lines;
   FETCH scheduled_order_lines INTO temp_;
   CLOSE scheduled_order_lines;
   IF temp_  = 1 THEN
      -- Note: At lease one CO line exist in the relevant period which
      --       is not in state Released or Reserved.
      RETURN 'FALSE';
   ELSE
      -- Note: All CO lines are in state Released Or Reserved.
      RETURN 'TRUE';
   END IF;
END Check_Ref_Line_Remove;


-- Calendar_Changed
--   Modify planned due date for orders when changes have been made in the
--   work time calendar.
PROCEDURE Calendar_Changed (
   error_log_   OUT CLOB,
   calendar_id_ IN VARCHAR2,
   contract_    IN VARCHAR2 DEFAULT NULL )
IS
   CURSOR get_sites IS
      SELECT contract, dist_calendar_id
        FROM SITE_PUBLIC
       WHERE contract LIKE nvl(contract_,'%');

-- Fetch all order lines (except package components) that uses the passed calendar.
   CURSOR get_lines(contract_ IN VARCHAR2, dist_calendar_id_ IN VARCHAR2) IS
      SELECT order_no, line_no, rel_no, line_item_no, contract, supply_site, supply_code,
             supply_site_due_date, planned_due_date, planned_ship_date, planned_delivery_date,
             cust_calendar_id, ext_transport_calendar_id
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  contract = contract_
        AND  rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
        AND  supply_code NOT IN ('PD', 'ND')
        AND  line_item_no <= 0
        AND  ((dist_calendar_id_ = calendar_id_)
              OR (nvl(ext_transport_calendar_id, ' ') = calendar_id_)
              OR (nvl(cust_calendar_id, ' ') = calendar_id_)
              OR ((supply_site_due_date IS NOT NULL) AND (Site_API.Get_Dist_Calendar_Id(supply_site) = calendar_id_)));

   TYPE get_lines_tab IS TABLE OF get_lines%ROWTYPE INDEX BY BINARY_INTEGER;

   linearr_                      get_lines_tab;
   linerec_                      get_lines%ROWTYPE;
   max_                          NUMBER;
   demand_site_                  BOOLEAN;
   supply_site_                  BOOLEAN;
   due_date_                     BOOLEAN;
   ship_date_                    BOOLEAN;
   supply_date_                  BOOLEAN;
   recalculate_                  BOOLEAN;
   attr_                         VARCHAR2(2000);
   error_msg_                    VARCHAR2(2000);
   cust_calender_modified_       BOOLEAN := FALSE;
   move_to_previous_working_day_ BOOLEAN := FALSE;
   new_planned_delivery_date_    DATE;
   separator_                    VARCHAR2(1) := CLIENT_SYS.text_separator_;
BEGIN
   -- find all sites connected to the changed calendar
   FOR siterec_ IN get_sites LOOP
      max_ := 0;

      -- find all order lines connected to the current site
      -- store the records in a PLSQL table to avoid rollback problem.
      FOR rec_ IN get_lines(siterec_.contract, siterec_.dist_calendar_id ) LOOP
         max_ := max_ + 1;
         linearr_(max_) := rec_;
      END LOOP;

      IF (max_ > 0) THEN
         FOR n_ IN 1..max_ LOOP
            -- Added exception handling for calendar changes.
            BEGIN
               linerec_     := linearr_(n_);
               -- has the calendar for the demand site been changed
               demand_site_ := (linerec_.contract = siterec_.contract);
               -- has the calendar for the supply site been changed
               supply_site_ := (nvl(Site_API.Get_Dist_Calendar_Id(linerec_.supply_site), ' ') = calendar_id_);
               -- has the customer_calendar for the order been changed
               cust_calender_modified_ := (calendar_id_ = linerec_.cust_calendar_id);
               -- due date and ship date depends on supply site's calendar if IPD...
               IF (linerec_.supply_code = 'IPD') THEN
                  due_date_  := supply_site_;
                  ship_date_ := supply_site_;
                  -- due date and ship date depends on demand site's calendar if the others...
               ELSE
                  due_date_  := demand_site_;
                  ship_date_ := demand_site_;
               END IF;

               -- the supply site due date is set only for IPT and IPD
               -- (if inventory part exist at supply site)
               IF (linerec_.supply_site_due_date IS NOT NULL) THEN
                  supply_date_ := supply_site_;
               ELSE
                  supply_date_ := FALSE;
               END IF;

               -- planned due date
               IF due_date_ AND (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, linerec_.planned_due_date) = 0) THEN
                  recalculate_ := TRUE;
               -- planned ship date
               ELSIF ship_date_ AND (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, linerec_.planned_ship_date) = 0) THEN
                  recalculate_ := TRUE;
               -- supply site due date
               ELSIF supply_date_ AND (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, linerec_.supply_site_due_date) = 0) THEN
                  recalculate_ := TRUE;
               -- customer calendar date
               ELSIF cust_calender_modified_ AND (Work_Time_Calendar_API.Is_Working_Day(calendar_id_, linerec_.planned_delivery_date) = 0) THEN
                  recalculate_ := TRUE;
                  move_to_previous_working_day_ := TRUE;
               ELSIF (linerec_.ext_transport_calendar_id = calendar_id_)  THEN
                  recalculate_ := TRUE;
               ELSE
                  recalculate_ := FALSE;
               END IF;

               -- trigger a complete date recalculation by updating planned delivery date to the same value...
               IF recalculate_ THEN
                  Client_SYS.Clear_Attr(attr_);
                  Client_SYS.Add_To_Attr('MOVE_DELIVERY_DATE_FORWARD', 'TRUE', attr_);

                  IF (move_to_previous_working_day_) THEN
                     new_planned_delivery_date_ := Work_Time_Calendar_API.Get_Previous_Work_Day(calendar_id_, linerec_.planned_delivery_date);
                     Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', new_planned_delivery_date_, attr_);
                  ELSE 
                     Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', linerec_.planned_delivery_date, attr_);
                  END IF;
                  CUSTOMER_ORDER_LINE_API.Modify(attr_, linerec_.order_no, linerec_.line_no, linerec_.rel_no, linerec_.line_item_no);
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  error_msg_ := Language_SYS.Translate_Constant(lu_name_, 'CALCHG: Error while updating Customer Order Line. Order No: :P1, Line No: :P2, Release No: :P3,', Language_SYS.Get_Language, linerec_.order_no, linerec_.line_no, linerec_.rel_no);
                  error_msg_ := error_msg_ || Language_SYS.Translate_Constant(lu_name_, 'CALCHG2: Planned Delivery Date: :P1.', Language_SYS.Get_Language, linerec_.planned_delivery_date);
                  error_msg_ := error_msg_ || ' ' || SQLERRM;
                  --Remove call to Work_Time_Calendar_API , instead write to OUT parameter
                  IF error_log_ IS NULL THEN
                     error_log_ := error_msg_ || separator_;
                  ELSE
                     error_log_ := error_log_ || error_msg_ || separator_;
                  END IF;
            END;
         END LOOP;
      END IF;
   END LOOP;
END Calendar_Changed;


-- Set_Line_Qty_Shipdiff
--   Public interface used to generate the SetLineQtyShipdiff event and
--   pass it to the finite state machine for processing.
PROCEDURE Set_Line_Qty_Shipdiff (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_shipdiff_ IN NUMBER )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPDIFF', qty_shipdiff_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);

   IF Customer_Order_Line_API.Get_Objstate(order_no_,line_no_, rel_no_,line_item_no_) != 'Cancelled' THEN
      Set_Line_Qty_Shipdiff__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Line_Qty_Shipdiff;


-- Set_Line_Qty_Invoiced
--   Public interface used to generate the SetLineQtyInvoiced event and
--   pass it to the finite state machine for processing.
PROCEDURE Set_Line_Qty_Invoiced (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_invoiced_ IN NUMBER )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_INVOICED', qty_invoiced_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   Set_Line_Qty_Invoiced__(info_, objid_, objversion_, attr_, 'DO');
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Line_Qty_Invoiced;


-- Set_Cancelled
--   Generates the SetCancelled state event and pass
--   it to the finite state machine for processing.
PROCEDURE Set_Cancelled (
   order_no_ IN VARCHAR2 )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   state_      VARCHAR2(2000);
   info_       VARCHAR2(32000);
   old_info_   VARCHAR2(32000);
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
BEGIN
   -- Get currently saved info if any
   old_info_ := Client_SYS.Get_All_Info;

   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   rec_   := Lock_By_Id___(objid_, objversion_);
   state_ := rec_.rowstate;
   
   IF (rec_.project_id IS NOT NULL) THEN
      newrec_ := rec_;
      newrec_.project_id := NULL;
      newrec_.currency_rate_type := NULL;
      Update___(objid_, rec_, newrec_, attr_, objversion_);
      Client_SYS.Clear_Attr(attr_);
   END IF;

   Set_Cancelled__(info_, objid_, objversion_, attr_, 'DO');
   IF (state_ != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;

   info_ := old_info_ || info_;
   IF (info_ IS NOT NULL) THEN
      -- Write back info cleared by Set_Cancelled__ call
      IF (SUBSTR(info_, 1, 5) = 'INFO' || Client_SYS.field_separator_) THEN
         Client_SYS.Add_Info(lu_name_, SUBSTR(info_, 6, LENGTH(info_) - 6));
      ELSIF (SUBSTR(info_, 1, 8) = 'WARNING' || Client_SYS.field_separator_) THEN
         Client_SYS.Add_Warning(lu_name_, SUBSTR(info_, 9, LENGTH(info_) - 9));
      END IF;
   END IF;
END Set_Cancelled;


-- Set_Released
--   Generates the SetReleased state event and
--   pass it to the finite state machine for processing.
PROCEDURE Set_Released (
   order_no_ IN VARCHAR2 )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   rowstate_   CUSTOMER_ORDER_TAB.rowstate%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   Set_Released__(info_, objid_, objversion_, attr_, 'DO');
   rowstate_ := Get_Objstate(order_no_);
   IF (rec_.rowstate != rowstate_) THEN
      IF(rowstate_ = 'Reserved') THEN
         Customer_Order_History_API.New(order_no_, NULL, 'Released');
      END IF;
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Released;


-- Set_Blocked
--   Generates the SetBlocked state event
--   and pass it to the finite state machine for processing.
PROCEDURE Set_Blocked (
   order_no_           IN VARCHAR2,
   blocked_reason_     IN VARCHAR2,
   checking_state_     IN VARCHAR2 )
IS
   oldrec_                 CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_                 CUSTOMER_ORDER_TAB%ROWTYPE;
   info_                   VARCHAR2(32000);
   attr_                   VARCHAR2(32000);
   status_                 VARCHAR2(32000);
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   indrec_                 Indicator_Rec;
   manual_block_           CUSTOMER_ORDER_TAB.blocked_type%TYPE := 'FALSE';
   
   CURSOR get_order_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_; 
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF blocked_reason_ IN ('BLKFORCRE', 'BLKCRELMT', 'BLKFORCREEXT', 'BLKCRELMTEXT', 'BLKFORCREMANUAL', 'BLKCRELMTMANUAL' )THEN
      Client_SYS.Add_To_Attr('BLOCKED_TYPE_DB', Customer_Order_Block_Type_API.DB_CREDIT_BLOCKED, attr_);
   ELSIF blocked_reason_ IN ('BLKFORADVPAY', 'BLKFORPREPAY', 'BLKFORADVPAYEXT', 'BLKFORPREPAYEXT', 'BLKFORADVPAYMANUAL', 'BLKFORPREPAYMANUAL') THEN
      Client_SYS.Add_To_Attr('BLOCKED_TYPE_DB', Customer_Order_Block_Type_API.DB_ADV_PAY_BLOCKED, attr_);
   ELSE
      Client_SYS.Add_To_Attr('BLOCKED_TYPE_DB', Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED, attr_);
      manual_block_ := 'TRUE';      
   END IF;

   Client_SYS.Add_To_Attr('BLOCKED_REASON', blocked_reason_, attr_);
   
   CASE blocked_reason_
      WHEN 'BLKFORCRE' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKFORCRE: Customer Order :P1 is blocked since the customer is credit blocked.', NULL, order_no_);
      WHEN 'BLKCRELMT' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKCRELMT: Customer Order :P1 is blocked due to credit limit being exceeded.', NULL, order_no_);
      WHEN 'BLKFORCREEXT' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKFORCREEXT: The Internal customer order :P1 is blocked since the external customer is credit-blocked.', NULL, order_no_);
      WHEN 'BLKCRELMTEXT' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKCRELMTEXT: The internal customer order :P1 is blocked due to external customer''s credit limit being exceeded.', NULL, order_no_);         
      WHEN 'BLKFORADVPAY' THEN  
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKFORADVPAY: Order credit blocked (unpaid advance invoices exist).', NULL, order_no_);         
      WHEN 'BLKFORPREPAY' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'BLKFORPREPAYM: The Customer Order is blocked. Required Prepayment Amount not fully paid.', NULL, order_no_);
      WHEN 'BLKFORADVPAYEXT' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'BLKFORADVPAYEXTM: The internal customer order is blocked due to external customer''s payment pending advance invoice is exist.', NULL, order_no_);
      WHEN 'BLKFORPREPAYEXT' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'BLKFORPREPAYEXTM: The internal customer order is blocked due to external customer''s Required Prepayment Amount not fully paid.', NULL, order_no_);
      WHEN 'BLKFORCREMANUAL' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKFORCREMANUAL: Manual credit limit is checked. Customer order :P1 is blocked since the customer is credit-blocked.', NULL, order_no_);
      WHEN 'BLKCRELMTMANUAL' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKCRELMTMANUAL: Manual credit limit is checked. Customer order :P1 is blocked due to the credit limit being exceeded.', NULL, order_no_);
      WHEN 'BLKFORADVPAYMANUAL' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'BLKFORADVPAYMANUAL: Manual credit limit is checked. The order is credit-blocked as unpaid advance invoices exist.', NULL, order_no_);
      WHEN 'BLKFORPREPAYMANUAL' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'BLKFORPREPAYMANUAL: Manual credit limit is checked. The customer order is blocked. The required prepayment amount has not been fully paid.', NULL, order_no_);
      WHEN 'BLKFORMANUALEXT' THEN 
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKFORMANUALEXT: The internal customer order is blocked since the external customer order is manually blocked.', NULL, order_no_);
      ELSE
         status_ := Language_SYS.Translate_Constant(lu_name_, 'HISTBLKMANUAL: The customer order is manually blocked.', NULL);
   END CASE;      
      
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);

   oldrec_ := Lock_By_Id___(objid_, objversion_);
   IF (oldrec_.rowstate != 'Blocked') THEN      
      IF (checking_state_ = 'RELEASE_ORDER') THEN
         Client_SYS.Add_To_Attr('BLOCKED_FROM_STATE', 'Planned', attr_);         
      ELSE
         Client_SYS.Add_To_Attr('BLOCKED_FROM_STATE', oldrec_.rowstate, attr_);
      END IF;
   END IF;
        
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   Transaction_SYS.Set_Status_Info(status_);
   IF (newrec_.rowstate != 'Blocked') THEN
      Client_SYS.Clear_Attr(attr_);
      Set_Blocked__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   
   IF (oldrec_.rowstate != Get_Objstate(order_no_) OR (newrec_.rowstate = 'Blocked' AND blocked_reason_ IN ('BLKFORADVPAY', 'BLKFORPREPAY'))) THEN
      Customer_Order_History_API.New(order_no_, status_);
   END IF;
   Cust_Order_Event_Creation_API.Order_Credit_Blocked(order_no_);
END Set_Blocked;


-- Block_Connected_Orders
--   Blocked Internal customer order connected parent customer orders
--   except connected External Customer order .
PROCEDURE Block_Connected_Orders(
   order_no_       IN VARCHAR2,
   blocked_reason_ IN VARCHAR2 )
IS
   temp_order_no_     VARCHAR2(20);
   parent_order_no_   VARCHAR2(20);
   blocking_order_no_ VARCHAR2(20);
BEGIN 
   temp_order_no_ := order_no_;
   LOOP
      Customer_Order_Line_API.Get_Parent_Cust_Order(parent_order_no_, temp_order_no_);
      EXIT WHEN parent_order_no_ IS NULL;     
      IF blocking_order_no_ IS NOT NULL THEN
         Set_Blocked(blocking_order_no_, blocked_reason_, NULL);
      END IF;
      blocking_order_no_ := parent_order_no_;
      temp_order_no_     := parent_order_no_;    
   END LOOP;  
END Block_Connected_Orders;


-- Release_Connected_Blocked_Ord
--   Release External Co connected Internal COs.
PROCEDURE Release_Connected_Blocked_Ord(
   order_no_                  IN VARCHAR2,
   release_from_credit_check_ IN VARCHAR2  )
IS
  order_rec_           Customer_Order_API.Public_Rec;
  company_             Site_Tab.Company%TYPE;
  customer_no_         CUSTOMER_ORDER_TAB.customer_no%TYPE;   
  prev_blocked_reason_ VARCHAR2(20);
  int_ord_no_          VARCHAR2(20);
   
   CURSOR get_int_order_info (temp_order_no_ IN VARCHAR2) IS   
      SELECT DISTINCT col.order_no  
      FROM customer_order_line_tab col
      WHERE demand_code IN ('IPD', 'IPT') 
      AND col.demand_order_ref1 IN (
         SELECT copo.po_order_no 
         FROM   customer_order_line_Tab col1, customer_order_pur_order_tab copo 
         WHERE  col1.order_no = copo.oe_order_no 
         AND    col1.order_no = temp_order_no_) ;
   
   CURSOR check_ext_blocked_child_ord(temp_order_no_ IN VARCHAR2)IS   
      SELECT DISTINCT col.order_no  
      FROM customer_order_line_tab col, customer_order_tab co
      WHERE demand_code IN ('IPD', 'IPT') 
      AND co.order_no = col.order_no 
      AND co.blocked_reason LIKE ('%EXT') 
      AND col.demand_order_ref1 IN (
         SELECT copo.po_order_no 
         FROM   customer_order_line_Tab col1, customer_order_pur_order_tab copo 
         WHERE  col1.order_no = copo.oe_order_no 
         AND    col1.order_no = temp_order_no_);
BEGIN
   FOR next_ IN get_int_order_info (order_no_) LOOP
      order_rec_   := Customer_Order_API.Get(next_.Order_No);
      customer_no_ := nvl(order_rec_.customer_no_pay, order_rec_.customer_no);
      company_     := Site_API.Get_Company(order_rec_.contract);

      IF (Cust_Ord_Customer_API.Customer_Is_Credit_Stopped(customer_no_, company_) != 1 ) THEN
         prev_blocked_reason_ := Get_Blocked_Reason(next_.Order_No);
         
         IF prev_blocked_reason_ IN ('BLKCRELMTEXT', 'BLKFORCREEXT', 'BLKFORADVPAYEXT', 'BLKFORPREPAYEXT', 'BLKFORMANUALEXT') THEN 
            -- release connected internal orders
            Release_Blocked(next_.order_no, release_from_credit_check_);
            -- if user select release from credit check RMB and still order is not blocked
            IF release_from_credit_check_ = 'TRUE' AND Customer_Order_API.Get_Objstate(next_.order_no) != 'Blocked' THEN
               Modify_Release_From_Credit__(next_.order_no, 'TRUE');
            END IF;            
        
            OPEN check_ext_blocked_child_ord(next_.order_no);
            FETCH check_ext_blocked_child_ord INTO int_ord_no_;
            CLOSE check_ext_blocked_child_ord;
         
            IF int_ord_no_ IS NOT NULL THEN
               Release_Connected_Blocked_Ord(next_.order_no,release_from_credit_check_);    
            ELSE
               Customer_Order_Flow_API.Credit_Check_Order(next_.order_no, 'SKIP_CHECK');
            END IF;
         END IF;   
      END IF;            
   END LOOP;
END Release_Connected_Blocked_Ord;   


PROCEDURE Start_Release_Blocked(
   order_no_                  IN VARCHAR2,
   release_from_credit_check_ IN VARCHAR2)
IS
  ext_order_no_  VARCHAR2(20);
  objstate_      CUSTOMER_ORDER_TAB.rowstate%TYPE;
BEGIN
   -- IF selected order is a internal CO(External CO can not be blocked with block code EXT) and blocked due to External Co 
   IF Get_Blocked_Reason(order_no_) IN ('BLKCRELMTEXT', 'BLKFORCREEXT', 'BLKFORADVPAYEXT', 'BLKFORPREPAYEXT', 'BLKFORMANUALEXT') THEN
      Customer_Order_Line_API.Get_External_Cust_Order(ext_order_no_, order_no_ );
      objstate_ := Customer_Order_API.Get_Objstate(ext_order_no_);
      IF (objstate_ = 'Blocked') THEN 
         Error_SYS.Record_General(lu_name_, 'EXTORDBLOCKED: Customer order :P1 cannot be released as the external customer order :P2 is blocked.', order_no_,ext_order_no_ );
      END IF;
      Release_Blocked(order_no_, release_from_credit_check_);
      IF release_from_credit_check_ = 'TRUE' THEN
         Modify_Release_From_Credit__(order_no_, 'TRUE');
      END IF;
   ELSE 
      -- Release external co
      Release_Blocked(order_no_, release_from_credit_check_);
      IF release_from_credit_check_ = 'TRUE' THEN
         Modify_Release_From_Credit__(order_no_, 'TRUE');   
      END IF;
      -- Release external CO connected Internal COs (Child Co)
      Release_Connected_Blocked_Ord(order_no_, release_from_credit_check_);   
   END IF;
END Start_Release_Blocked;


-- Release_Blocked
--   Generates the ReleaseCreditBlocked state event
--   and pass it to the finite state machine for processing.
PROCEDURE Release_Blocked (
   order_no_              IN VARCHAR2,
   rel_from_credit_check_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   rec_               CUSTOMER_ORDER_TAB%ROWTYPE;
   info_              VARCHAR2(32000);
   attr_              VARCHAR2(32000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
   demand_code_       CUSTOMER_ORDER_LINE_TAB.demand_code%TYPE;
   line_no_           VARCHAR2(4);
   demand_order_ref1_ CUSTOMER_ORDER_LINE_TAB.demand_order_ref1%TYPE;
   lines_found_       BOOLEAN := FALSE;
   do_objstate_       VARCHAR2(20);
   objstate_          CUSTOMER_ORDER_TAB.rowstate%TYPE;
   
   CURSOR do_details IS
      SELECT line_no, demand_order_ref1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rowstate != 'Cancelled';

   auth_group_        VARCHAR2(2);
   current_po_no_     NUMBER;
   dummy_             NUMBER;

   CURSOR check_col_supply_code IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    supply_code IN ('IPD', 'IPT')
      AND    line_item_no >= 0;
   
   blocked_again_       BOOLEAN := FALSE;
   blocked_reason_      VARCHAR2(15);
   parent_customer_     VARCHAR2(20);
   credit_block_result_ VARCHAR2(20);
   credit_attr_         VARCHAR2(2000);
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_);

   OPEN do_details;
   FETCH do_details INTO line_no_, demand_order_ref1_;
   CLOSE do_details;

   IF line_no_ IS NOT NULL THEN
      lines_found_ := TRUE;
   END IF;

   -- First make sure the customer is not credit blocked, if so the credit block may not be relased.
   IF lines_found_ THEN
	  Check_Customer_Credit_Blocked(credit_block_result_, credit_attr_, rec_.order_no);
	  IF Client_SYS.Item_Exist('PARENT_IDENTITY', credit_attr_) THEN
	     parent_customer_ := Client_SYS.Get_Item_Value('PARENT_IDENTITY', credit_attr_); 
	  END IF;
      CASE (credit_block_result_)
         WHEN 'CUSTOMER_BLOCKED' THEN
            IF parent_customer_ IS NULL THEN
               Error_SYS.Record_General(lu_name_, 'NOPICKCUSTCREBLK: The customer :P1 is credit blocked. The order cannot be released.', rec_.customer_no);
            ELSE
               Error_SYS.Record_General(lu_name_, 'NOPICKPRCUSTCREBLK: The parent :P1 of the customer is credit blocked. The order cannot be released.', parent_customer_);
            END IF;
         WHEN 'PAY_CUSTOMER_BLOCKED' THEN
            IF parent_customer_ IS NULL THEN
               Error_SYS.Record_General(lu_name_, 'NOPICKPCUSTCREBLK: The paying customer :P1 is credit blocked. The order cannot be released.', rec_.customer_no_pay);
            ELSE
               Error_SYS.Record_General(lu_name_, 'NOPICKPRPCUSTCREBLK: The parent :P1 of the paying customer is credit blocked. The order cannot be released.', parent_customer_);
            END IF;
         ELSE
            NULL;
      END CASE;
   END IF;

   IF (rec_.blocked_from_state = 'Planned' AND rec_.blocked_type != Customer_Order_Block_Type_API.DB_ADV_PAY_BLOCKED) THEN
      blocked_reason_ := NULL;
      Customer_Order_Flow_API.Advance_Invoice_Pay_Check(blocked_reason_, order_no_);
      IF (blocked_reason_ IS NOT NULL) THEN
         Set_Blocked(rec_.order_no, blocked_reason_, 'RELEASE_ORDER');
         blocked_again_ := TRUE;
      END IF;   
   END IF;
   
   IF (NOT blocked_again_) THEN
      Client_SYS.Clear_Attr(attr_);
      -- Note: Need to get the current po number from order_coordinator_group_tab only when internal purchase orders can be created.
      OPEN check_col_supply_code;
      FETCH check_col_supply_code INTO dummy_;
      CLOSE check_col_supply_code;
      IF (dummy_ = 1) THEN
         auth_group_    := Order_Coordinator_API.Get_Authorize_Group(rec_.authorize_code);
         current_po_no_ := Order_Coordinator_Group_API.Get_Purch_Order_No(auth_group_);
         Client_SYS.Add_To_Attr('SOURCE_ORDER', 'CO', attr_);
      END IF; 

      Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
      Release_Blocked__(info_, objid_, objversion_, attr_, 'DO');
      objstate_ := Get_Objstate(order_no_);
      
      -- If the state is Released rel_mtrl_planning should be selected.      
      -- Or if state is Planned and the order was manually blocked rel_mtrl_planning should be selected as CO can be manually blocked at Planned state   
      IF (objstate_ = 'Released') OR ((objstate_ = 'Planned') AND (rec_.blocked_type = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED)) THEN         
         Check_Rel_Mtrl_Planning(order_no_, Fnd_Boolean_API.DB_TRUE);      
      END IF;

      demand_code_ := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Demand_Code(order_no_,'1','1',0));
      IF (objstate_ IN ('Released','Reserved')) THEN
         IF (demand_code_ = 'DO') THEN
            $IF Component_Disord_SYS.INSTALLED $THEN
               -- release all the distribution orders connected to the lines of the
               -- credit blocked customer order.
               FOR do_rec_ IN do_details LOOP
                  do_objstate_ := Distribution_Order_API.Get_Objstate(do_rec_.demand_order_ref1);
                  IF (do_objstate_ = 'Stopped') THEN
                     Distribution_Order_API.Check_State(do_rec_.demand_order_ref1, 'Release');
                  END IF;   
               END LOOP;
            $ELSE
               NULL;            
            $END         
            END IF;
         END IF;

      IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
         IF (rel_from_credit_check_ = 'TRUE') THEN
            Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'RELEASECCHECK: Released from credit check.'));
         ELSE
            IF (rec_.blocked_type = Customer_Order_Block_Type_API.DB_MANUAL_BLOCKED) THEN
               Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'RELEASEMANUALBLOCK: Manually blocked order released.'));
            ELSE
               Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'RELEASEBLOCK: Credit-blocked order released.'));
            END IF;
         END IF;
      END IF;

      IF (rel_from_credit_check_ = 'TRUE') THEN
         -- Note: By setting the release from credit check TRUE the system will not check for credit and block further in customer order flow.
         Modify_Release_From_Credit__(order_no_, 'TRUE');
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      IF (current_po_no_ IS NOT NULL) THEN
         Order_Coordinator_Group_API.Reset_Purch_Ord_No_Autonomous(auth_group_, current_po_no_);
      END IF;
      RAISE;
END Release_Blocked;



PROCEDURE Get_Id_Version_By_Keys (
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   order_no_   IN  VARCHAR2 )
IS
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
END Get_Id_Version_By_Keys;


-- Get_Default_Shipment_Location
--   If parts of order exists in a shipment inventory, the first
--   location_no is returned as default, otherwise NULL.
@UncheckedAccess
FUNCTION Get_Default_Shipment_Location (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   ship_inventory_location_no_ VARCHAR2(35);
   order_rec_                  Customer_Order_API.Public_Rec;
BEGIN
   order_rec_ := Get(order_no_);
   Cust_Order_Leadtime_Util_API.Fetch_Delivery_Attributes(order_rec_.route_id,
                                                          order_rec_.forward_agent_id, 
                                                          order_rec_.delivery_leadtime,
                                                          order_rec_.ext_transport_calendar_id,
                                                          order_rec_.freight_map_id,
                                                          order_rec_.zone_id,
                                                          order_rec_.picking_leadtime,
                                                          order_rec_.shipment_type,
                                                          ship_inventory_location_no_,
                                                          order_rec_.delivery_terms,
                                                          order_rec_.del_terms_location,
                                                          order_rec_.contract,
                                                          order_rec_.customer_no,
                                                          order_rec_.ship_addr_no, 
                                                          order_rec_.addr_flag,
                                                          order_rec_.ship_via_code);                                                       
   RETURN ship_inventory_location_no_;
END Get_Default_Shipment_Location;


-- Set_Line_Cancelled
--   Generates the SetLineCancelled event
--   and pass it to the finite state machine for processing.
PROCEDURE Set_Line_Cancelled (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   state_      customer_order_tab.rowstate%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);

   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   rec_   := Lock_By_Id___(objid_, objversion_);
   state_ := rec_.rowstate;
   Finite_State_Machine___(rec_, 'SetLineCancelled', attr_);

   IF (rec_.rowstate != state_) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Line_Cancelled;

@Deprecated
PROCEDURE Modify_Address (
   order_no_             IN VARCHAR2,
   bill_addr_no_         IN VARCHAR2,
   ship_addr_no_         IN VARCHAR2,
   addr_flag_db_         IN VARCHAR2,
   changed_country_code_ IN VARCHAR2,
   freight_map_id_       IN VARCHAR2,
   zone_id_              IN VARCHAR2 )
IS
BEGIN
   Modify_Address(order_no_,
                  bill_addr_no_,
                  ship_addr_no_,
                  addr_flag_db_,
                  changed_country_code_,
                  freight_map_id_,
                  zone_id_,
                  NULL);
END Modify_Address;

-- Modify_Address
--   Modify address information for a customer order.
--   Called when an order address has been modified.
PROCEDURE Modify_Address (
   order_no_             IN VARCHAR2,
   bill_addr_no_         IN VARCHAR2,
   ship_addr_no_         IN VARCHAR2,
   addr_flag_db_         IN VARCHAR2,
   changed_country_code_ IN VARCHAR2,
   freight_map_id_       IN VARCHAR2,
   zone_id_              IN VARCHAR2,
   vat_free_vat_code_    IN VARCHAR2)
IS
   oldrec_                    CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_                    CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   attr_                      VARCHAR2(32000);
   ship_via_code_             CUSTOMER_ORDER_TAB.ship_via_code%TYPE;   
   delivery_terms_            CUSTOMER_ORDER_TAB.delivery_terms%TYPE;
   del_terms_location_        CUSTOMER_ORDER_TAB.del_terms_location%TYPE;
   delivery_leadtime_         NUMBER;
   ext_transport_calendar_id_ CUSTOMER_ORDER_TAB.ext_transport_calendar_id%TYPE;
   picking_leadtime_          NUMBER;
   freight_price_list_no_     VARCHAR2(10);
   freight_map_               VARCHAR2(15);
   zone_                      VARCHAR2(15);
   route_id_                  CUSTOMER_ORDER_TAB.route_id%TYPE;
   forward_agent_id_          CUSTOMER_ORDER_TAB.forward_agent_id%TYPE;
   shipment_type_             VARCHAR2(3);
   tax_id_no_                 CUSTOMER_ORDER_TAB.tax_id_no%TYPE;
   tax_id_validated_date_     CUSTOMER_ORDER_TAB.tax_id_validated_date%TYPE;
   customer_no_               customer_order_tab.customer_no%TYPE;   
   addr_no_                   customer_order_tab.bill_addr_no%TYPE;   
   indrec_                    Indicator_Rec;
   add_info_                  BOOLEAN := FALSE;
   cust_vat_free_vat_code_    VARCHAR2(20);
   company_                   VARCHAR2(20);
   
   CURSOR get_lines_with_def_address(ord_no_ IN VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no          = ord_no_
      AND    default_addr_flag = 'Y'
      AND    rowstate          != 'Cancelled';
BEGIN

   IF (ship_addr_no_ IS NULL) THEN
      oldrec_ := Get_Object_By_Keys___(order_no_);
      Error_SYS.Record_General(lu_name_, 'NO_DEL_ADDR: Customer :P1 does not have a delivery address.', oldrec_.customer_no);
   END IF;

   Client_SYS.Clear_Attr(attr_);
   oldrec_      := Lock_By_Keys___(order_no_);
   newrec_      := oldrec_;
   freight_map_ := freight_map_id_;
   zone_        := zone_id_;
   Client_SYS.Add_To_Attr('BILL_ADDR_NO', bill_addr_no_, attr_);
   Client_SYS.Add_To_Attr('SHIP_ADDR_NO', ship_addr_no_, attr_);
   Client_SYS.Add_To_Attr('ADDR_FLAG_DB', addr_flag_db_, attr_);
   company_     := Site_API.Get_Company(newrec_.contract);
   
   IF ((addr_flag_db_ = 'Y') AND (vat_free_vat_code_ IS NOT NULL)) THEN
       cust_vat_free_vat_code_ := Customer_Tax_Free_Tax_Code_API.Get_Tax_Free_Tax_Code(newrec_.customer_no, ship_addr_no_, company_, newrec_.supply_country, '*');
       IF (NVL(cust_vat_free_vat_code_, Database_Sys.string_null_) != vat_free_vat_code_) THEN
          IF (newrec_.tax_liability = 'TAX') THEN
              add_info_ := TRUE;
              END IF;       
      END IF;
   END IF;
   
   IF (changed_country_code_ IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CHANGED_COUNTRY_CODE', changed_country_code_, attr_);

      IF (newrec_.customer_no_pay IS NOT NULL) THEN
         customer_no_ := newrec_.customer_no_pay;
         addr_no_     := newrec_.customer_no_pay_addr_no;
      ELSE
         customer_no_ := newrec_.customer_no;
         addr_no_     := bill_addr_no_;         
      END IF;      
      
      tax_id_no_ := Customer_Document_Tax_Info_API.Get_Vat_No_Db(customer_no_,
                                                              addr_no_,
                                                              company_, 
                                                              newrec_.supply_country,
                                                              changed_country_code_);
      IF (tax_id_no_ IS NOT NULL) THEN                                                     
         tax_id_validated_date_ := Tax_Handling_Order_Util_API.Get_Tax_Id_Validated_Date(newrec_.customer_no_pay,
                                                                                         newrec_.customer_no_pay_addr_no,
                                                                                         newrec_.customer_no ,
                                                                                         bill_addr_no_ ,
                                                                                         company_, 
                                                                                         newrec_.supply_country,
                                                                                         changed_country_code_);                                                                                                         
      END IF;                                                                                      
      Client_SYS.Add_To_Attr('TAX_ID_NO', tax_id_no_, attr_);                                                                                                        
      Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', tax_id_validated_date_, attr_);
      -- When header changed into single occurence address the subsequent lines should update accordingly
      FOR next_line_ IN get_lines_with_def_address(order_no_) LOOP
         Customer_Order_Line_API.Modify_Country_Code(order_no_, next_line_.line_no, next_line_.rel_no, next_line_.line_item_no, changed_country_code_);
      END LOOP;
   END IF;
   forward_agent_id_ := oldrec_.forward_agent_id;

   IF (addr_flag_db_ = 'N') THEN
      -- CO header delivery address is not changed but addr_flag is changed. need to fetch freight information.
      IF (oldrec_.addr_flag = 'Y' AND (ship_addr_no_ = newrec_.ship_addr_no)) THEN
         Fetch_Default_Delivery_Info(forward_agent_id_,
                                     route_id_,
                                     freight_map_,
                                     zone_,
                                     delivery_leadtime_,
                                     ext_transport_calendar_id_,
                                     picking_leadtime_,
                                     shipment_type_,
                                     ship_via_code_,
                                     delivery_terms_,
                                     del_terms_location_,
                                     order_no_,
                                     oldrec_.contract,
                                     oldrec_.customer_no,
                                     ship_addr_no_,
                                     'N',
                                     oldrec_.agreement_id,
                                     oldrec_.vendor_no);

         IF (NVL(route_id_, Database_Sys.string_null_) != NVL(oldrec_.route_id, Database_Sys.string_null_)) THEN
            Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
         END IF;
         IF (NVL(forward_agent_id_, Database_Sys.string_null_) != NVL(oldrec_.forward_agent_id, Database_Sys.string_null_)) THEN
            Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
         END IF;
      END IF;
   END IF;
   
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_, attr_);
  
   IF (freight_map_ IS NOT NULL) THEN
      freight_price_list_no_ := Freight_Price_List_Base_API.Get_Active_Freight_List_No(oldrec_.contract, NVL(ship_via_code_, oldrec_.ship_via_code), freight_map_, forward_agent_id_, oldrec_.use_price_incl_tax);
   ELSE
      freight_price_list_no_ := NULL;
   END IF;
   Client_SYS.Add_To_Attr('FREIGHT_PRICE_LIST_NO', freight_price_list_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

   IF (add_info_) THEN
      Client_SYS.Add_Info(lu_name_, 'TAXLIABILITY: Tax Liability for this Customer Order is Tax. For the Tax Free Tax Code to be applied it has to be manually changed to Exempt.');          
   END IF;   
END Modify_Address;


-- New
--   Public interface for creating a new customer order.
PROCEDURE New (
   info_ OUT    VARCHAR2,
   attr_ IN OUT VARCHAR2 )
IS 
   new_attr_              VARCHAR2(32000);
   newrec_                CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);   
   indrec_                Indicator_Rec;
BEGIN 
   new_attr_ := Build_Attr_For_New___(attr_);   
   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   info_ := Client_SYS.Get_All_Info;
   attr_ := new_attr_;
END New;


-- Modify
--   Public interface for modification of customer order attributes.
--   The attributes to be modified should be passed in an attribute string.
PROCEDURE Modify (
   info_     OUT    VARCHAR2,
   attr_     IN OUT VARCHAR2,
   order_no_ IN     VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
END Modify;


-- New_Order_Lines_Allowed
--   Return TRUE (1) if new order line creation is allowed for the order,
--   FALSE (0) if new lines may not be created
@UncheckedAccess
FUNCTION New_Order_Lines_Allowed (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   objstate_ CUSTOMER_ORDER_TAB.rowstate%TYPE;
BEGIN
   objstate_ := Get_Objstate(order_no_);
   IF (objstate_ IN ('Invoiced', 'Cancelled')) THEN
      RETURN 0;
   ELSE
      RETURN 1;
   END IF;
END New_Order_Lines_Allowed;


-- Get_Latest_Order_No
--   Returns the latest registered order for a specified customer and site
--   and where the order number is not equal to the passed one.
@UncheckedAccess
FUNCTION Get_Latest_Order_No (
   order_no_    IN VARCHAR2,
   customer_no_ IN VARCHAR2,
   contract_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_TAB.order_no%TYPE;
   CURSOR get_latest IS
      SELECT order_no
      FROM   CUSTOMER_ORDER_TAB
      WHERE  customer_no = customer_no_
      AND    contract = contract_
      AND    order_no != order_no_
      AND    date_entered = (SELECT max(date_entered)
                             FROM   CUSTOMER_ORDER_TAB
                             WHERE  customer_no = customer_no_
                             AND    contract = contract_
                             AND    order_no != order_no_);
BEGIN
   OPEN  get_latest;
   FETCH get_latest INTO temp_;
   CLOSE get_latest;
   RETURN temp_;
END Get_Latest_Order_No;


-- Get_Qty_Shipped_Per_Part
--   Returns the sum of (qty_shipped - qty_returned) for all order lines for a given part with a delivery date within a
--   given time interval. Optional to include/exclude internal demands like Distribution Orders
PROCEDURE Get_Qty_Shipped_Per_Part (
   qty_shipped_             OUT NUMBER,
   revenue_                 OUT NUMBER,
   cost_                    OUT NUMBER,
   contract_                IN  VARCHAR2,
   part_no_                 IN  VARCHAR2,
   date_from_               IN  DATE,
   date_until_              IN  DATE,
   include_internal_demand_ IN  VARCHAR2)
IS
   i_                      PLS_INTEGER; 
   tot_qty_shipped_        NUMBER := 0;
   total_price_            NUMBER := 0;
   total_cost_             NUMBER := 0;
   total_revised_qty_due_  NUMBER := 0;
   
   CURSOR get_qty_shipped IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, SUM(cod.qty_shipped) qty_shipped, SUM(cod.cost) cost
      FROM   customer_order_line_tab col,
             customer_order_delivery_tab cod
      WHERE  col.order_no     = cod.order_no
      AND    col.line_no      = cod.line_no
      AND    col.rel_no       = cod.rel_no
      AND    col.line_item_no = cod.line_item_no
      AND    col.contract     = contract_
      AND    col.part_no      = part_no_
      AND    trunc(cod.date_delivered) BETWEEN trunc(date_from_) AND trunc(date_until_)
      AND    cod.cancelled_delivery = 'FALSE'
      AND    col.rowstate != 'Cancelled'
      AND    col.supply_code NOT IN ('SEO', 'ND')
      AND    NVL(col.demand_code, 'DuMmY') NOT IN ('CRO', 'CRE')
      GROUP BY col.order_no, col.line_no, col.rel_no, col.line_item_no;
      
   CURSOR get_external_qty_shipped IS
      SELECT col.order_no, col.line_no, col.rel_no, col.line_item_no, SUM(cod.qty_shipped) qty_shipped, SUM(cod.cost) cost
      FROM   customer_order_line_tab col,
             customer_order_delivery_tab cod
      WHERE  col.order_no     = cod.order_no
      AND    col.line_no      = cod.line_no
      AND    col.rel_no       = cod.rel_no
      AND    col.line_item_no = cod.line_item_no
      AND    col.contract     = contract_
      AND    col.part_no      = part_no_
      AND    trunc(cod.date_delivered) BETWEEN trunc(date_from_) AND trunc(date_until_)
      AND    cod.cancelled_delivery = 'FALSE'
      AND    rowstate != 'Cancelled'
      AND    supply_code NOT IN ('SEO', 'ND')
      AND    NVL(demand_code, 'DuMmY') NOT IN ('DO', 'IPT', 'IPD', 'CRO', 'CRE', 'IPT_RO')
      GROUP BY col.order_no, col.line_no, col.rel_no, col.line_item_no;
      
   TYPE Col_Delivery_Row_Type IS TABLE OF get_external_qty_shipped%ROWTYPE INDEX BY PLS_INTEGER;
   col_delivery_arr_ Col_Delivery_Row_Type;
      
BEGIN
   IF include_internal_demand_ = 'TRUE' THEN 
      OPEN get_qty_shipped;
      FETCH get_qty_shipped BULK COLLECT INTO col_delivery_arr_;
      CLOSE get_qty_shipped;
   ELSE
      OPEN get_external_qty_shipped;
      FETCH get_external_qty_shipped BULK COLLECT INTO col_delivery_arr_;
      CLOSE get_external_qty_shipped;
   END IF;
   
   i_ := col_delivery_arr_.FIRST;
   WHILE (i_ IS NOT NULL) LOOP
      tot_qty_shipped_ := tot_qty_shipped_ + col_delivery_arr_(i_).qty_shipped;
      total_price_ := total_price_ + Customer_Order_Line_API.Get_Base_Sale_Price_Total(col_delivery_arr_(i_).order_no,
                                                                                       col_delivery_arr_(i_).line_no,
                                                                                       col_delivery_arr_(i_).rel_no,
                                                                                       col_delivery_arr_(i_).line_item_no);
                                                                                       
      total_revised_qty_due_ := total_revised_qty_due_ + Customer_Order_Line_API.Get_Revised_Qty_Due(col_delivery_arr_(i_).order_no,
                                                                                                     col_delivery_arr_(i_).line_no,
                                                                                                     col_delivery_arr_(i_).rel_no,
                                                                                                     col_delivery_arr_(i_).line_item_no);
      -- Total COGS                                                                                 
      total_cost_ := total_cost_ + col_delivery_arr_(i_).qty_shipped * col_delivery_arr_(i_).cost;
      i_ := col_delivery_arr_.NEXT(i_);
   END LOOP;
   
   -- Calculate revenue based on what has been shipped
   IF total_revised_qty_due_ = 0 THEN 
      revenue_     := 0;
      qty_shipped_ := 0;
      cost_        := 0;
   ELSE
      revenue_     := total_price_ * tot_qty_shipped_ / total_revised_qty_due_;
      qty_shipped_ := tot_qty_shipped_;
      cost_        := total_cost_;
   END IF; 
END Get_Qty_Shipped_Per_Part;

-- Get_Open_Demand_For_Part
--   Returns the sum of open demand for all order lines for a given part with a planned_due_date within a
--   given time interval. Optional to include/exclude internal demands like Distribution Orders
PROCEDURE Get_Open_Demand_Per_Part (
   open_demand_qty_         OUT NUMBER,
   revenue_                 OUT NUMBER,
   cost_                    OUT NUMBER,
   contract_                IN  VARCHAR2,
   part_no_                 IN  VARCHAR2,
   date_from_               IN  DATE,
   date_until_              IN  DATE,
   include_internal_demand_ IN  VARCHAR2)
IS
   i_                      PLS_INTEGER; 
   tot_open_demand_        NUMBER := 0;
   total_price_            NUMBER := 0;
   total_cost_             NUMBER := 0;
   total_revised_qty_due_  NUMBER := 0;
   
   CURSOR get_total_open_demand IS
      SELECT l.order_no, l.line_no, l.rel_no, l.line_item_no, (l.revised_qty_due - (l.qty_shipped - l.qty_shipdiff)) qty_due,
             l.revised_qty_due, cost
      FROM   customer_order_line_tab l, customer_order_tab o
      WHERE  l.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    l.line_item_no >= 0
      AND    l.revised_qty_due - (l.qty_shipped - l.qty_shipdiff) > 0
      AND    l.part_ownership IN ('COMPANY OWNED','CONSIGNMENT')
      AND    (((o.rowstate = 'Planned' OR o.rowstate = 'Blocked') AND (l.supply_code IN ('IO', 'PI', 'DOP', 'SO', 'PS'))) OR 
             ((o.rowstate = 'Blocked') AND (l.supply_code IN ('PT', 'PD', 'IPT', 'IPD') AND (l.qty_on_order > 0))) OR
             ((o.rowstate = 'Blocked') AND (l.supply_code IN ('PT', 'IPT') AND (l.qty_assigned > 0))) OR
             (o.rowstate IN ('Released','Reserved','Picked','PartiallyDelivered') AND l.supply_code NOT IN ('SEO','ND')))
      -- AND    l.rel_mtrl_planning = 'TRUE'
      AND    TRUNC(l.planned_due_date) BETWEEN trunc(date_from_) AND trunc(date_until_)
      AND    o.order_no = l.order_no
      AND    l.part_no  = part_no_
      AND    l.contract = contract_;
      
   CURSOR get_total_external_open_demand IS
      SELECT l.order_no, l.line_no, l.rel_no, l.line_item_no, (l.revised_qty_due - (l.qty_shipped - l.qty_shipdiff)) qty_due,
             l.revised_qty_due, l.cost
      FROM   customer_order_line_tab l, customer_order_tab o
      WHERE  l.rowstate IN ('Released', 'Reserved', 'Picked', 'PartiallyDelivered')
      AND    l.line_item_no >= 0
      AND    l.revised_qty_due - (l.qty_shipped - l.qty_shipdiff) > 0
      AND    l.part_ownership IN ('COMPANY OWNED','CONSIGNMENT')
      AND    (((o.rowstate = 'Planned' OR o.rowstate = 'Blocked') AND (l.supply_code IN ('IO', 'PI', 'DOP', 'SO', 'PS'))) OR 
             ((o.rowstate = 'Blocked') AND (l.supply_code IN ('PT', 'PD', 'IPT', 'IPD') AND (l.qty_on_order > 0))) OR
             ((o.rowstate = 'Blocked') AND (l.supply_code IN ('PT', 'IPT') AND (l.qty_assigned > 0))) OR
             (o.rowstate IN ('Released','Reserved','Picked','PartiallyDelivered') AND l.supply_code NOT IN ('SEO', 'ND')))
      AND    NVL(demand_code, 'DuMmY') NOT IN ('DO', 'IPT', 'IPD', 'CRO', 'CRE')
      -- AND    l.rel_mtrl_planning = 'TRUE'
      AND    TRUNC(l.planned_due_date) BETWEEN trunc(date_from_) AND trunc(date_until_)
      AND    o.order_no = l.order_no
      AND    l.part_no  = part_no_
      AND    l.contract = contract_;
      
   TYPE Col_Row_Type IS TABLE OF get_total_external_open_demand%ROWTYPE INDEX BY PLS_INTEGER;
   col_arr_ Col_Row_Type;

BEGIN
   IF include_internal_demand_ = 'TRUE' THEN 
      OPEN get_total_open_demand;
      FETCH get_total_open_demand BULK COLLECT INTO col_arr_;
      CLOSE get_total_open_demand;
   ELSE
      OPEN get_total_external_open_demand;
      FETCH get_total_external_open_demand BULK COLLECT INTO col_arr_;
      CLOSE get_total_external_open_demand;
   END IF;
   
   i_ := col_arr_.FIRST;
   WHILE (i_ IS NOT NULL) LOOP
      tot_open_demand_ := tot_open_demand_ + col_arr_(i_).qty_due;
      total_price_ := total_price_ + Customer_Order_Line_API.Get_Base_Sale_Price_Total(col_arr_(i_).order_no,
                                                                                       col_arr_(i_).line_no,
                                                                                       col_arr_(i_).rel_no,
                                                                                       col_arr_(i_).line_item_no);
                                                                                       
      total_revised_qty_due_ := total_revised_qty_due_ + col_arr_(i_).revised_qty_due;
      -- Total expected COGS                                                                                 
      total_cost_ := total_cost_ + col_arr_(i_).qty_due * col_arr_(i_).cost;
      i_ := col_arr_.NEXT(i_);
   END LOOP;
   
   -- Calculate the projected revenue based on total open demand
   IF total_revised_qty_due_ = 0 THEN 
      revenue_     := 0;
      open_demand_qty_ := 0;
      cost_        := 0;
   ELSE
      revenue_     := total_price_ * tot_open_demand_ / total_revised_qty_due_;
      open_demand_qty_ := tot_open_demand_;
      cost_        := total_cost_;
   END IF; 
END Get_Open_Demand_Per_Part;

-- Get_Part_Sales_All_Orders
--   Returns the sum of the bookings for all order lines for a given part with a planned_due_date within a
--   given time interval. Optional to include/exclude internal demands like Distribution Orders
FUNCTION Get_Part_Sales_All_Orders  (
   contract_                IN  VARCHAR2,
   part_no_                 IN  VARCHAR2,
   date_from_               IN  DATE,
   date_until_              IN  DATE,
   include_internal_demand_ IN  VARCHAR2) RETURN NUMBER
IS
   total_revised_qty_due_  NUMBER := 0;
   
   CURSOR get_total_part_sales IS
      SELECT SUM(revised_qty_due + qty_shipdiff)
      FROM   customer_order_line_tab
      WHERE  rowstate != 'Cancelled'
      AND    line_item_no >= 0
      AND    part_ownership IN ('COMPANY OWNED','CONSIGNMENT')
      AND    TRUNC(planned_due_date) BETWEEN TRUNC(date_from_) AND TRUNC(date_until_)
      AND    part_no  = part_no_
      AND    contract = contract_;
      
   CURSOR get_total_external_part_sales IS
      SELECT SUM(revised_qty_due + qty_shipdiff)
      FROM   customer_order_line_tab
      WHERE  rowstate != 'Cancelled'
      AND    line_item_no >= 0
      AND    part_ownership IN ('COMPANY OWNED','CONSIGNMENT')
      AND    NVL(demand_code, 'DuMmY') NOT IN ('DO', 'IPT', 'IPD', 'CRO', 'CRE')
      AND    TRUNC(planned_due_date) BETWEEN TRUNC(date_from_) AND TRUNC(date_until_)
      AND    part_no  = part_no_
      AND    contract = contract_;
      
BEGIN
   IF include_internal_demand_ = 'TRUE' THEN 
      OPEN get_total_part_sales;
      FETCH get_total_part_sales INTO total_revised_qty_due_;
      CLOSE get_total_part_sales;
   ELSE
      OPEN get_total_external_part_sales;
      FETCH get_total_external_part_sales INTO total_revised_qty_due_;
      CLOSE get_total_external_part_sales;
   END IF;
   
   RETURN total_revised_qty_due_;
END Get_Part_Sales_All_Orders;

-- Get_Line_Demand_Code_Db
--   Checks all customer order lines and returns a distinct demand code.
@UncheckedAccess
FUNCTION Get_Line_Demand_Code_Db (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_          VARCHAR2(200) := NULL;
   demand_code_db_ VARCHAR2(200) := NULL;

   CURSOR get_all_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_;
BEGIN
   FOR next_ IN get_all_lines LOOP
      dummy_ := Order_Supply_Type_API.Encode(CUSTOMER_ORDER_LINE_API.Get_Demand_Code(order_no_, next_.line_no, next_.rel_no, next_.line_item_no));
      IF (dummy_ > ' ') THEN
         demand_code_db_ := dummy_;
      END IF;
   END LOOP;
   RETURN demand_code_db_;
END Get_Line_Demand_Code_Db;


-- Get_Tot_Charge_Base_Tax_Amount
--   Retrive the total tax amount on charges for an order in base currency
FUNCTION Get_Tot_Charge_Base_Tax_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_    NUMBER;

   CURSOR get_total_tax IS
      SELECT SUM(Customer_Order_Charge_API.Get_Total_Tax_Amount_Base(charge.order_no, charge.sequence_no))
      FROM CUSTOMER_ORDER_CHARGE_TAB charge, CUSTOMER_ORDER_TAB ord
      WHERE ord.order_no = order_no_
        AND ord.rowstate != 'Cancelled' 
        AND ord.order_no = charge.order_no;
BEGIN
   IF Exist_Charges__ (order_no_) = 0 THEN
      total_tax_amount_ := 0;
   ELSE
      OPEN get_total_tax;
      FETCH get_total_tax INTO total_tax_amount_;
      CLOSE get_total_tax;
   END IF;

   RETURN NVL(total_tax_amount_,0);
END Get_Tot_Charge_Base_Tax_Amount;


-- Get_Price_List_No
--   Always returns NULL.
--   Only kept to maintain backward compatibility to Maintenance 5.3.1.
@UncheckedAccess
FUNCTION Get_Price_List_No (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN NULL;
END Get_Price_List_No;


-- Find_External_Ref_Order
--   Finds the order no if only the external reference is known.
@UncheckedAccess
FUNCTION Find_External_Ref_Order (
   external_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_no_ VARCHAR2(12);

   CURSOR get_order IS
      SELECT order_no
      FROM   CUSTOMER_ORDER_TAB
      WHERE  external_ref = external_ref_
      AND    rowstate != 'Cancelled';
BEGIN
   OPEN get_order;
   FETCH get_order INTO order_no_;
   IF get_order%NOTFOUND THEN
      order_no_ := NULL;
   END IF;
   CLOSE get_order;
   RETURN order_no_;
END Find_External_Ref_Order;


-- Find_External_Ref_Order
--   Finds the order no if only the external reference is known.
@UncheckedAccess
FUNCTION Find_External_Ref_Order (
   external_ref_ IN VARCHAR2,
   customer_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_no_ VARCHAR2(12);

   CURSOR get_order IS
      SELECT order_no
      FROM   CUSTOMER_ORDER_TAB
      WHERE  external_ref = external_ref_
      AND    customer_no = customer_no_
      AND    rowstate != 'Cancelled';
BEGIN
   OPEN get_order;
   FETCH get_order INTO order_no_;
   IF get_order%NOTFOUND THEN
      order_no_ := NULL;
   END IF;
   CLOSE get_order;
   RETURN order_no_;
END Find_External_Ref_Order;


-- Get_Delivery_Time
--   Returns the passed date with default time from the delivery address
--   added to it.
FUNCTION Get_Delivery_Time (
   order_no_      IN VARCHAR2,
   delivery_date_ IN DATE ) RETURN DATE
IS
   CURSOR get_customer_info IS
      SELECT customer_no, ship_addr_no, addr_flag
      FROM   CUSTOMER_ORDER_TAB
      WHERE  order_no = order_no_;
   rec_      get_customer_info%ROWTYPE;
   del_time_ DATE := NULL;
BEGIN
   OPEN get_customer_info;
   FETCH get_customer_info INTO rec_;
   IF (get_customer_info%FOUND) THEN
      CLOSE get_customer_info;
      del_time_ := Construct_Delivery_Time___(delivery_date_, rec_.customer_no, rec_.ship_addr_no, rec_.addr_flag);
   END IF;
   RETURN del_time_;
END Get_Delivery_Time;


-- Check_State
--   This method should be called when changes have been made to an order
--   which could cause state changes on the order header, and the changes
--   have not been made using the Finite_State_Machine methods.
--   One example of when the method should be called is if the buy qty on
--   an order line is decreased. In some cases this should cause a state change.
PROCEDURE Check_State (
   order_no_ IN VARCHAR2 )
IS
   rec_          CUSTOMER_ORDER_TAB%ROWTYPE;
   old_objstate_ CUSTOMER_ORDER_TAB.rowstate%TYPE;
   attr_         VARCHAR2(200);
BEGIN
   rec_ := Get_Object_By_Keys___(order_no_);
   old_objstate_ := rec_.rowstate;
   Finite_State_Machine___(rec_, NULL, attr_);
   IF (rec_.rowstate != old_objstate_) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Check_State;


-- New_Order_Line_Added
--   This method should be called when new order lines have been added to an
--   order in state 'Delivered' or 'Invoiced'.
--   The method will force a state change to 'PartiallyDelivered'.
PROCEDURE New_Order_Line_Added (
   order_no_ IN VARCHAR2 )
IS
   rec_          CUSTOMER_ORDER_TAB%ROWTYPE;
   old_objstate_ CUSTOMER_ORDER_TAB.rowstate%TYPE;
   attr_         VARCHAR2(200);
   message_      VARCHAR2(100);
BEGIN
   rec_ := Lock_By_Keys___(order_no_);
   old_objstate_ := rec_.rowstate;
   IF (old_objstate_ IN ('Delivered', 'Invoiced')) THEN
   Finite_State_Machine___(rec_, 'NewOrderLineAdded', attr_);
   IF (rec_.rowstate != old_objstate_) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'NEWLINE: New order line added');
      Customer_Order_History_API.New(order_no_, message_);
      END IF;
   END IF;
END New_Order_Line_Added;


-- Get_Total_Contribution
--   Returns the total contribution for a customer order. Changes to this should apply to Get_Ord_Line_ToTals__ as well.
@UncheckedAccess
FUNCTION Get_Total_Contribution (
   order_no_ IN VARCHAR2) RETURN NUMBER
IS
   total_base_price_  NUMBER;
   contribution_      NUMBER;
BEGIN
   IF (Customer_Order_API.Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE') THEN
      total_base_price_ := Get_Total_Base_Price_Incl_Tax(order_no_) - Get_Total_Tax_Amount(order_no_);
   ELSE
   total_base_price_ := Get_Total_Base_Price(order_no_);
   END IF;
   contribution_ := total_base_price_ - Get_Total_Cost(order_no_);
   RETURN contribution_;
END Get_Total_Contribution;


-- Set_Project_Id
--   Method used by Project module.
--   Sets a value on Project_Id.
--   This is used by IFS/Project to establish a connection between a CO and a Project
PROCEDURE Set_Project_Id (
   order_no_   IN VARCHAR2,
   project_id_ IN VARCHAR2 )
IS
   info_ VARCHAR2(32000);
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Set_Item_Value('PROJECT_ID', project_id_, attr_);
   Modify(info_, attr_, order_no_);
END Set_Project_Id;


-- Set_Project_Pre_Posting
--   This is used by IFS/Project to add information for pre account
PROCEDURE Set_Project_Pre_Posting (
   order_no_     IN VARCHAR2,
   codeno_a_     IN VARCHAR2,
   codeno_b_     IN VARCHAR2,
   codeno_c_     IN VARCHAR2,
   codeno_d_     IN VARCHAR2,
   codeno_e_     IN VARCHAR2,
   codeno_f_     IN VARCHAR2,
   codeno_g_     IN VARCHAR2,
   codeno_h_     IN VARCHAR2,
   codeno_i_     IN VARCHAR2,
   codeno_j_     IN VARCHAR2,
   activity_seq_ IN NUMBER )
IS
   ordrec_      Public_Rec;
   CURSOR get_lines IS
      SELECT pre_accounting_id, contract
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_;
BEGIN
   ordrec_ := Get(order_no_);
   -- Note : Replaced the earlier two method calls to Pre_Accounting_API.Set_Project_Code_Part from following two calls to the new method Set_Pre_Posting.
   -- set pre accounting for customer order head
   Pre_Accounting_API.Set_Pre_Posting(ordrec_.pre_accounting_id,ordrec_.contract,'M103',codeno_a_,
                                      codeno_b_,codeno_c_,codeno_d_,codeno_e_,codeno_f_,codeno_g_,codeno_h_,codeno_i_,codeno_j_, activity_seq_,'TRUE','TRUE');

   -- Note : set pre accounting for customer order lines
   FOR next_line_ IN get_lines LOOP
      Pre_Accounting_API.Set_Pre_Posting(next_line_.pre_accounting_id,next_line_.contract,'M104',codeno_a_,
                                         codeno_b_,codeno_c_,codeno_d_,codeno_e_,codeno_f_,codeno_g_,codeno_h_,codeno_i_,codeno_j_, activity_seq_,'TRUE','TRUE');
   END LOOP;
END Set_Project_Pre_Posting;


-- Set_Scheduling_Connection
--   Sets the connection to Customer Scheduling
PROCEDURE Set_Scheduling_Connection (
   order_no_        IN VARCHAR2,
   scheduling_flag_ IN BOOLEAN )
IS
   temp_ VARCHAR2(20);
   info_ VARCHAR2(32000);
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF scheduling_flag_ THEN
      temp_ := 'SCHEDULE';
   ELSE
      temp_ := 'NOT SCHEDULE';
   END IF;
   Client_SYS.Set_Item_Value('SCHEDULING_CONNECTION_DB', temp_, attr_);
   Modify(info_, attr_, order_no_);
END Set_Scheduling_Connection;


-- Modify_Sm_Connection
--   Modify SM_Connection, used by Service Management
PROCEDURE Modify_Sm_Connection (
   order_no_         IN VARCHAR2,
   sm_connection_db_ IN VARCHAR2 )
IS
   oldrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   -- Checks for prepayment exists before a work order is connected to a customer order.
   IF (Customer_Order_API.Get_Proposed_Prepayment_Amount(order_no_) > 0) THEN
      Error_SYS.Record_General(lu_name_, 'PREPAY_EXISTSM: The Required Prepayment amount exists. Cannot enable this customer order for SM connections.');
   END IF;

   oldrec_ := Lock_By_Keys___(order_no_);
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_to_Attr('SM_CONNECTION_DB', sm_connection_db_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Sm_Connection;


-- Get_Delivery_Information
--   Returns correct ship_via_code, delivery_terms and delivery_terms_desc.
--   If an agreement exists, the values are fetched from the agreement.
--   Otherwise, the values are fetched from the customer
PROCEDURE Get_Delivery_Information (
   attr_          IN OUT VARCHAR2,
   language_code_ IN     VARCHAR2,
   agreement_id_  IN     VARCHAR2,
   customer_no_   IN     VARCHAR2,
   address_no_    IN     VARCHAR2 )
IS
   ship_via_code_             VARCHAR2(3);
   deliv_term_                VARCHAR2(5);
   del_terms_location_        VARCHAR2(100) := NULL;
   contract_                  CUSTOMER_ORDER_TAB.contract%TYPE;
   leadtime_                  NUMBER;
   addr_flag_db_              CUSTOMER_ORDER_TAB.addr_flag%TYPE;
   freight_map_id_            CUSTOMER_ORDER_TAB.freight_map_id%TYPE;
   zone_id_                   CUSTOMER_ORDER_TAB.zone_id%TYPE;
   agreement_rec_             Customer_Agreement_API.Public_Rec;
   customer_rec_              Cust_Ord_Customer_Address_API.Public_Rec;
   order_no_                  CUSTOMER_ORDER_TAB.order_no%TYPE; 
   ext_transport_calendar_id_ CUSTOMER_ORDER_TAB.ext_transport_calendar_id%TYPE;
   route_id_                  CUSTOMER_ORDER_TAB.route_id%TYPE;
   forward_agent_id_          CUSTOMER_ORDER_TAB.forward_agent_id%TYPE;
   picking_leadtime_          NUMBER;
   shipment_type_             VARCHAR2(3);
   vendor_no_                 VARCHAR2(20);
   old_agreement_id_          Customer_Agreement_TAB.Agreement_Id%TYPE;
   agreement_deliv_term_      VARCHAR2(5);   
   agreement_changed_         VARCHAR2(5);
   ship_addr_no_changed_      VARCHAR2(5);
BEGIN
   ship_via_code_    := NULL;
   deliv_term_       := NULL;

   -- Retrieve extra parameters from attribute string!!
   contract_     := Client_SYS.Get_Item_Value('CONTRACT', attr_);
   addr_flag_db_ := Client_SYS.Get_Item_Value('ADDR_FLAG_DB', attr_);
   order_no_     := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   deliv_term_   := Client_SYS.Get_Item_Value('DELIVERY_TERMS', attr_);
   vendor_no_    := Client_SYS.Get_Item_Value('VENDOR_NO', attr_);
   ship_addr_no_changed_ := NVL(Client_SYS.Get_Item_Value('ADDRESS_CHANGED', attr_), 'FALSE');
   customer_rec_ := Cust_Ord_Customer_Address_API.Get(customer_no_, address_no_);
   old_agreement_id_ := Customer_Order_API.Get_Agreement_Id(order_no_);

   IF (agreement_id_ IS NOT NULL) THEN
      agreement_rec_ := Customer_Agreement_API.Get(agreement_id_);
      agreement_changed_ := Client_SYS.Get_Item_Value('AGREEMENT_CHANGED', attr_);
      -- Added condition to identify whether the agreement_id has changed
      IF (agreement_changed_='TRUE' AND order_no_ IS NOT NULL) THEN
         ship_via_code_      := Client_SYS.Get_Item_Value('SHIP_VIA_CODE', attr_);        
         del_terms_location_ := Client_SYS.Get_Item_Value('DEL_TERMS_LOCATION', attr_);
         route_id_ := Client_SYS.Get_Item_Value('ROUTE_ID', attr_);
         forward_agent_id_ := Client_SYS.Get_Item_Value('FORWARD_AGENT_ID', attr_);
         shipment_type_    := Client_SYS.Get_Item_Value('SHIPMENT_TYPE', attr_);
         freight_map_id_  := Client_SYS.Get_Item_Value('FREIGHT_MAP_ID', attr_);
         ext_transport_calendar_id_ := Client_SYS.Get_Item_Value('EXT_TRANSPORT_CALENDAR_ID', attr_);
         zone_id_ := Client_SYS.Get_Item_Value('ZONE_ID', attr_);
         -- Get delivery_terms from agreement
         agreement_deliv_term_ := agreement_rec_.delivery_terms;
         IF ((agreement_deliv_term_ IS NOT NULL) AND ((agreement_changed_ = 'TRUE' AND NOT(agreement_rec_.use_by_object_head = 'FALSE' AND agreement_rec_.use_explicit = 'Y')) )) THEN
            deliv_term_ := agreement_deliv_term_;
            del_terms_location_ := agreement_rec_.del_terms_location;  
         ELSE
            del_terms_location_ := del_terms_location_;
         END IF;
      ELSE
         -- Get delivery_terms from agreement
         deliv_term_ := agreement_rec_.delivery_terms;
         route_id_ := Client_SYS.Get_Item_Value('ROUTE_ID', attr_);
         forward_agent_id_ := Client_SYS.Get_Item_Value('FORWARD_AGENT_ID', attr_);
         shipment_type_    := Client_SYS.Get_Item_Value('SHIPMENT_TYPE', attr_);
         -- If the agreement has delivery terms get del_terms_location from agreement
         -- if not retrieve delivery term and location from Customer.
         IF (deliv_term_ IS NOT NULL) THEN
            del_terms_location_ := agreement_rec_.del_terms_location;         
         END IF;
      END IF;
   ELSE
      deliv_term_         := customer_rec_.delivery_terms;
      del_terms_location_ := customer_rec_.del_terms_location;
   END IF;
   
   IF ((agreement_changed_='TRUE' AND order_no_ IS NOT NULL) OR (ship_addr_no_changed_ = 'TRUE')) THEN 
      picking_leadtime_ := Client_SYS.Get_Item_Value('PICKING_LEADTIME', attr_);
      leadtime_         := Client_SYS.Get_Item_Value('DELIVERY_LEADTIME', attr_);
   END IF;
   
   -- Added IF condition to only call the method Fetch_Default_Delivery_Info() and fetch values when agreement is newly connected or changed and when existing agreement is removed from the header
   -- but avoid the call when agreement's Exclude from auto pricing is checked and used by Order/Quotation header is unchecked.
   IF((agreement_id_ IS NULL) OR (agreement_changed_ IS NULL) OR (agreement_changed_ = 'TRUE' AND NOT(agreement_rec_.use_by_object_head = 'FALSE' AND agreement_rec_.use_explicit = 'Y')) ) THEN 
      Fetch_Default_Delivery_Info(forward_agent_id_,
                                  route_id_,
                                  freight_map_id_,
                                  zone_id_,
                                  leadtime_,
                                  ext_transport_calendar_id_,
                                  picking_leadtime_,
                                  shipment_type_,
                                  ship_via_code_,
                                  deliv_term_,
                                  del_terms_location_,
                                  order_no_,
                                  contract_,
                                  customer_no_,
                                  address_no_,
                                  addr_flag_db_,
                                  agreement_id_,
                                  vendor_no_,
                                  ship_addr_no_changed_);
   END IF;
                                
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', deliv_term_, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_LEADTIME', leadtime_, attr_);
   Client_SYS.Add_To_Attr('EXT_TRANSPORT_CALENDAR_ID', ext_transport_calendar_id_, attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);
   Client_SYS.Add_To_Attr('FREIGHT_MAP_ID', freight_map_id_, attr_);
   Client_SYS.Add_To_Attr('ZONE_ID', zone_id_, attr_);
   Client_SYS.Add_To_Attr('CUST_CALENDAR_ID', customer_rec_.cust_calendar_id, attr_);   
   Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
   Client_SYS.Add_To_Attr('FORWARD_AGENT_ID', forward_agent_id_, attr_);
   Client_SYS.Add_To_Attr('PICKING_LEADTIME', picking_leadtime_, attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_TYPE', shipment_type_, attr_);
END Get_Delivery_Information;


-- Get_Line_Return_Percentage
--   Returns the percentage of order lines with returns within a specified
--   period of time.
--   Customer number and sales part number may be specified as qualifiers
--   to this function.
@UncheckedAccess
FUNCTION Get_Line_Return_Percentage (
   days_        IN NUMBER,
   catalog_no_  IN VARCHAR2,
   customer_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   site_date_  DATE := Site_API.Get_Site_Date(User_Default_API.Get_Contract);
   deliveries_ NUMBER;
   returns_    NUMBER;

   CURSOR get_deliveries IS
      SELECT COUNT(*)
      FROM CUSTOMER_ORDER_LINE_TAB, USER_ALLOWED_SITE_PUB
      WHERE catalog_no LIKE catalog_no_
      AND customer_no = customer_no_
      AND real_ship_date > (site_date_ - days_)
      AND rowstate IN  ('PartiallyDelivered', 'Delivered', 'Invoiced')
      AND contract = site;

   CURSOR get_deliveries_catalog_no IS
      SELECT COUNT(*)
      FROM CUSTOMER_ORDER_LINE_TAB, USER_ALLOWED_SITE_PUB
      WHERE catalog_no LIKE catalog_no_
      AND real_ship_date > (site_date_ - days_)
      AND rowstate IN  ('PartiallyDelivered', 'Delivered', 'Invoiced')
      AND contract = site;

   CURSOR get_deliveries_customer_no IS
      SELECT COUNT(*)
      FROM CUSTOMER_ORDER_LINE_TAB, USER_ALLOWED_SITE_PUB
      WHERE customer_no = customer_no_
      AND real_ship_date > (site_date_ - days_)
      AND rowstate IN  ('PartiallyDelivered', 'Delivered', 'Invoiced')
      AND contract = site;

   CURSOR get_returns IS
      SELECT COUNT(*)
      FROM CUSTOMER_ORDER_LINE_TAB, USER_ALLOWED_SITE_PUB
      WHERE catalog_no LIKE catalog_no_
      AND customer_no = customer_no_
      AND real_ship_date > (site_date_ - days_)
      AND rowstate IN  ('PartiallyDelivered', 'Delivered', 'Invoiced')
      AND qty_returned > 0
      AND contract = site;

   CURSOR get_returns_catalog_no IS
      SELECT COUNT(*)
      FROM CUSTOMER_ORDER_LINE_TAB, USER_ALLOWED_SITE_PUB
      WHERE catalog_no LIKE catalog_no_
      AND real_ship_date > (site_date_ - days_)
      AND rowstate IN  ('PartiallyDelivered', 'Delivered', 'Invoiced')
      AND qty_returned > 0
      AND contract = site;

   CURSOR get_returns_customer_no IS
      SELECT COUNT(*)
      FROM CUSTOMER_ORDER_LINE_TAB, USER_ALLOWED_SITE_PUB
      WHERE customer_no = customer_no_
      AND real_ship_date > (site_date_ - days_)
      AND rowstate IN  ('PartiallyDelivered', 'Delivered', 'Invoiced')
      AND qty_returned > 0
      AND contract = site;
BEGIN
   IF (catalog_no_ IS NOT NULL) AND (customer_no_ IS NOT NULL) THEN
      OPEN get_deliveries;
      FETCH get_deliveries INTO deliveries_;
      CLOSE get_deliveries;
      OPEN get_returns;
      FETCH get_returns INTO returns_;
      CLOSE get_returns;
   ELSIF (catalog_no_ IS NOT NULL) AND (customer_no_ IS NULL) THEN
      OPEN get_deliveries_catalog_no;
      FETCH get_deliveries_catalog_no INTO deliveries_;
      CLOSE get_deliveries_catalog_no;
      OPEN get_returns_catalog_no;
      FETCH get_returns_catalog_no INTO returns_;
      CLOSE get_returns_catalog_no;
   ELSIF (catalog_no_ IS NULL) AND (customer_no_ IS NOT NULL) THEN
      OPEN get_deliveries_customer_no;
      FETCH get_deliveries_customer_no INTO deliveries_;
      CLOSE get_deliveries_customer_no;
      OPEN get_returns_customer_no;
      FETCH get_returns_customer_no INTO returns_;
      CLOSE get_returns_customer_no;
   ELSE
      deliveries_ := 0;
      returns_ := 0;
   END IF;

   --Return the percentage of returns in relation to the total
   --number of deliveries
   IF (deliveries_ = 0) THEN
      deliveries_ := 1;
   END IF;
   RETURN (returns_/deliveries_) * 100;
END Get_Line_Return_Percentage;


-- Get_No_Of_Orders_Due_For_Part
--   Return the number of customer orders for the specified part within
--   the specified date intervall.
--   Used by the ABC calculation in Costing.
@UncheckedAccess
FUNCTION Get_No_Of_Orders_Due_For_Part (
   contract_   IN VARCHAR2,
   part_no_    IN VARCHAR2,
   date_from_  IN DATE,
   date_until_ IN DATE ) RETURN NUMBER
IS
   no_of_orders_ NUMBER;

   CURSOR get_orders_due IS
      SELECT count(DISTINCT(order_no))
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    planned_due_date BETWEEN date_from_ AND date_until_
      AND    rowstate != 'Cancelled';
BEGIN
   OPEN get_orders_due;
   FETCH get_orders_due INTO no_of_orders_;
   CLOSE get_orders_due;
   RETURN no_of_orders_;
END Get_No_Of_Orders_Due_For_Part;


-- Uninvoiced_Charges_Exist
--   Returns and sing plus TRUE if univoiced charges connected to the order head exist-
@UncheckedAccess
FUNCTION Uninvoiced_Charges_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_uninvoiced_charges IS
      SELECT 1
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = order_no_
      AND    ABS(charged_qty) > ABS(invoiced_qty)
      AND    line_no IS NULL;

   found_ NUMBER ;
BEGIN
   OPEN get_uninvoiced_charges;
   FETCH get_uninvoiced_charges INTO found_;
   IF get_uninvoiced_charges%NOTFOUND THEN
      found_ := 0;
   END IF;
   CLOSE get_uninvoiced_charges;
   RETURN found_ ;
END Uninvoiced_Charges_Exist;


-- Is_Pre_Posting_Mandatory
--   This Function is return 1 if mandarory pre posting is set for order header
FUNCTION Is_Pre_Posting_Mandatory (
   company_ IN VARCHAR2 ) RETURN NUMBER
IS
   code_a_flag_ NUMBER;
   code_b_flag_ NUMBER;
   code_c_flag_ NUMBER;
   code_d_flag_ NUMBER;
   code_e_flag_ NUMBER;
   code_f_flag_ NUMBER;
   code_g_flag_ NUMBER;
   code_h_flag_ NUMBER;
   code_i_flag_ NUMBER;
   code_j_flag_ NUMBER;
BEGIN
   Accounting_Codestr_API.Execute_Accounting(code_a_flag_,
                                             code_b_flag_,
                                             code_c_flag_,
                                             code_d_flag_,
                                             code_e_flag_,
                                             code_f_flag_,
                                             code_g_flag_,
                                             code_h_flag_,
                                             code_i_flag_,
                                             code_j_flag_,
                                             NULL,
                                             company_,
                                             'M103',
                                             'C58');
   IF (code_a_flag_ = 1) OR
      (code_b_flag_ = 1) OR
      (code_c_flag_ = 1) OR
      (code_d_flag_ = 1) OR
      (code_e_flag_ = 1) OR
      (code_f_flag_ = 1) OR
      (code_g_flag_ = 1) OR
      (code_h_flag_ = 1) OR
      (code_i_flag_ = 1) OR
      (code_j_flag_ = 1) THEN
      RETURN(1);
   ELSE
      RETURN(0);
   END IF;
END Is_Pre_Posting_Mandatory;


-- Finite_State_Decode
--   Returns the client value of the state.
@UncheckedAccess
FUNCTION Finite_State_Decode (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(CUSTOMER_ORDER_API.Finite_State_Decode__(db_state_));
END Finite_State_Decode;


-- Get_Total_Tax_Amount
--   Retrive the total tax amount for order lines on the specified order
--   in base currency.
@UncheckedAccess
FUNCTION Get_Total_Tax_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_ NUMBER := 0;

BEGIN
   total_tax_amount_ := Customer_Order_Line_API.Get_Total_Tax_Amount_Base(order_no_,NULL, NULL, NULL, NULL);
   RETURN total_tax_amount_;
END Get_Total_Tax_Amount;


-- Get_Tax_Amount_Per_Tax_Code
--    Returns the total tax amount (VAT or Sales Tax) per tax code
--    in order currency.
FUNCTION Get_Tax_Amount_Per_Tax_Code (
   order_no_ IN VARCHAR2,
   tax_code_ IN VARCHAR2 ) RETURN NUMBER 
IS
BEGIN
   -- gelr:delivery_types_in_pbi, Moved the existing logic to Get_Tax_Per_Tax_Code_Deliv___
   RETURN Get_Tax_Per_Tax_Code_Deliv___( order_no_, tax_code_, NULL);
END Get_Tax_Amount_Per_Tax_Code;

-- gelr:delivery_types_in_pbi, begin
-- Get_Tax_Per_Tax_Code_Deliv
--    Returns the total tax amount (VAT or Sales Tax) per tax code and delivery type
--    in order currency. If the delivery type is not given it will be calculated only per tax code
FUNCTION Get_Tax_Per_Tax_Code_Deliv (
   order_no_      IN VARCHAR2,
   tax_code_      IN VARCHAR2, 
   delivery_type_ IN VARCHAR2) RETURN NUMBER 
IS
BEGIN
   RETURN Get_Tax_Per_Tax_Code_Deliv___(order_no_, tax_code_, delivery_type_);
END Get_Tax_Per_Tax_Code_Deliv;
-- gelr:delivery_types_in_pbi, end


-- Get_Gross_Amount
--   Retrive the total gross amount for all order lines on this order.
--   Charges will not be included.
@UncheckedAccess
FUNCTION Get_Gross_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_net_amount_    NUMBER;
   total_tax_amount_    NUMBER;
   total_gross_amount_  NUMBER;
BEGIN
   IF (Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE') THEN
      total_gross_amount_ := Get_Total_Base_Price_Incl_Tax(order_no_);
   ELSE
      total_net_amount_   := Get_Total_Base_Price(order_no_);
      total_tax_amount_   := Get_Total_Tax_Amount(order_no_) ;
      total_gross_amount_ := total_net_amount_ + total_tax_amount_;
   END IF;
   RETURN total_gross_amount_;
END Get_Gross_Amount;


FUNCTION Get_Gross_Amount_Per_Tax_Code (
   order_no_ IN VARCHAR2,
   tax_code_ IN VARCHAR2 ) RETURN NUMBER 
IS
BEGIN
   -- gelr:delivery_types_in_pbi, Moved the existing logic to Get_Gros_Per_Tax_Code_Deliv___
   RETURN Get_Gros_Per_Tax_Code_Deliv___(order_no_, tax_code_, NULL);
END Get_Gross_Amount_Per_Tax_Code;

-- gelr:delivery_types_in_pbi, begin
-- Get_Gross_Per_Tax_Code_Deliv
--    Returns the Gross Amout calculated per Tax Code and Delivery Type
FUNCTION Get_Gross_Per_Tax_Code_Deliv (
   order_no_      IN VARCHAR2,
   tax_code_      IN VARCHAR2,
   delivery_type_ IN VARCHAR2) RETURN NUMBER 
IS
BEGIN
   RETURN Get_Gros_Per_Tax_Code_Deliv___(order_no_, tax_code_, delivery_type_);
END Get_Gross_Per_Tax_Code_Deliv;
-- gelr:delivery_types_in_pbi, end

-- Get_Ord_Gross_Amount
--   Retrive the total gross amount for all order lines on this order
--   in order currency.Charges will not be included.
@UncheckedAccess
FUNCTION Get_Ord_Gross_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_gross_amount_  NUMBER;
BEGIN
   IF (Get_Use_Price_Incl_Tax_Db(order_no_) = 'TRUE') THEN
      total_gross_amount_ := Get_Tot_Sale_Price_Incl_Tax__(order_no_);
   ELSE
      total_gross_amount_ := Get_Total_Sale_Price___(order_no_ , TRUE) + Get_Ord_Total_Tax_Amount___(order_no_,TRUE);
   END IF;
   RETURN total_gross_amount_;
END Get_Ord_Gross_Amount;


-- Get_Ord_Total_Tax_Amount
--   Retrive the total tax amount for an order in order currency
@UncheckedAccess
FUNCTION Get_Ord_Total_Tax_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_  NUMBER := 0;
BEGIN
   total_tax_amount_:= Get_Ord_Total_Tax_Amount___(order_no_,FALSE);
   RETURN total_tax_amount_;
END Get_Ord_Total_Tax_Amount;


-- Order_Lines_Exist
--   Return TRUE (1) if lines exist on the specified order,
--   FALSE (0) if no lines have been created.
@UncheckedAccess
FUNCTION Order_Lines_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR order_lines_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_;
BEGIN
   OPEN order_lines_exist;
   FETCH order_lines_exist INTO dummy_;
   IF (order_lines_exist%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE order_lines_exist;
   RETURN dummy_;
END Order_Lines_Exist;


-- Get_Total_Add_Discount_Amount
--   Retrives the total additional discount amount in base price for the
--   specified order, in base currency rounding. Changes to this should apply to Get_Ord_Line_ToTals__ as well.
@UncheckedAccess
FUNCTION Get_Total_Add_Discount_Amount (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   ordrec_                 CUSTOMER_ORDER_TAB%ROWTYPE;
   company_                VARCHAR2(20);
   add_discount_amt_       NUMBER := 0;
   total_amount_           NUMBER;
   discount_               NUMBER;
   add_discount_           NUMBER;
   currency_rounding_      NUMBER;
   line_discount_amount_   NUMBER;
   rental_chargeable_days_ NUMBER;
   
   CURSOR get_add_disc_amt IS
      SELECT line_no, rel_no, line_item_no, (buy_qty_due * price_conv_factor * sale_unit_price) total_net_amount,
             (buy_qty_due * price_conv_factor * unit_price_incl_tax) total_gross_amount,
             discount, additional_discount, buy_qty_due, price_conv_factor, rental
      FROM  CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate != 'Cancelled'
      AND   line_item_no <= 0
      AND   order_no = order_no_;
BEGIN
   ordrec_            := Get_Object_By_Keys___(order_no_);
   company_           := Site_API.Get_Company(ordrec_.contract);
   currency_rounding_ := Currency_Code_API.Get_Currency_Rounding(company_, ordrec_.currency_code);
   FOR rec_ IN get_add_disc_amt LOOP
      IF rec_.rental = Fnd_Boolean_API.DB_TRUE THEN
         rental_chargeable_days_ := Customer_Order_Line_API.Get_Rental_Chargeable_Days(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
      ELSE
         rental_chargeable_days_ := 1;
      END IF;
      IF (ordrec_.use_price_incl_tax = 'TRUE') THEN
         total_amount_ := NVL(rec_.total_gross_amount * rental_chargeable_days_, 0);
      ELSE
         total_amount_ := NVL(rec_.total_net_amount * rental_chargeable_days_, 0);
      END IF;
      discount_             := NVL(rec_.discount, 0);
      add_discount_         := NVL(rec_.additional_discount, 0);        
      line_discount_amount_ := Cust_Order_Line_Discount_API.Get_Total_Line_Discount(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no,
                                                                                    rec_.buy_qty_due, rec_.price_conv_factor,  currency_rounding_, NULL, rental_chargeable_days_);
      add_discount_amt_     := add_discount_amt_ + ROUND(((total_amount_ - line_discount_amount_) * NVL(add_discount_, 0)/100), currency_rounding_);
   END LOOP;
   RETURN NVL(add_discount_amt_, 0);
END Get_Total_Add_Discount_Amount;


-- Check_Peggings_Exist
--   returns 1 If any peggings exist for the customer order.
--   Otherwise returns 0
FUNCTION Check_Peggings_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR  get_peggings IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND qty_on_order !=0;
   peg_ NUMBER;
BEGIN
   OPEN get_peggings;
   FETCH get_peggings INTO peg_;
   IF (get_peggings%FOUND) THEN
      CLOSE get_peggings;
      RETURN 1;
   END IF;
   CLOSE get_peggings;
   RETURN 0;
END Check_Peggings_Exist;


-- Check_Exchange_Part_Exist
--   Checks the existancy of exchange customer order lines of a specific
--   customer order.
@UncheckedAccess
FUNCTION Check_Exchange_Part_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR  get_exchange IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND exchange_item = 'EXCHANGED ITEM';
   exc_item_ NUMBER;
BEGIN
   OPEN get_exchange;
   FETCH get_exchange INTO exc_item_;
   IF (get_exchange%FOUND) THEN
      CLOSE get_exchange;
      RETURN 0;
   ELSE
      CLOSE get_exchange;
      RETURN 0;
   END IF;
END Check_Exchange_Part_Exist;


-- Shipment_Connected_Lines_Exist
--   returns 1 If any customer order line has connected to a shipment.
--   Otherwise returns 0
@UncheckedAccess
FUNCTION Shipment_Connected_Lines_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR  get_exchange IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND shipment_connected = 'TRUE';
   dummy_ NUMBER;
BEGIN
   OPEN get_exchange;
   FETCH get_exchange INTO dummy_;
   IF (get_exchange%FOUND) THEN
      CLOSE get_exchange;
      RETURN 1;
   ELSE
      CLOSE get_exchange;
      RETURN 0;
   END IF;
END Shipment_Connected_Lines_Exist;


-- Check_Order_Connected
--   This method is used to check whether there is a connected customer
--   order to a given activity
@UncheckedAccess
FUNCTION Check_Order_Connected (
   order_no_     IN VARCHAR2,
   activity_seq_ IN NUMBER ) RETURN NUMBER
IS
   pre_acc_id_ NUMBER;
BEGIN
   pre_acc_id_ := Customer_Order_API.Get_Pre_Accounting_Id(order_no_);
   RETURN Pre_Accounting_API.Check_Ord_Connected(pre_acc_id_, activity_seq_);
END Check_Order_Connected;


-- Check_Delivered_Sched_Order
--   Checks if the order is a schedule connected order which is delivered..
@UncheckedAccess
FUNCTION Check_Delivered_Sched_Order (
   order_no_         IN VARCHAR2,
   customer_no_      IN VARCHAR2,
   ship_addr_no_     IN VARCHAR2,
   customer_part_no_ IN VARCHAR2,
   contract_         IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR scheduling_order IS
      SELECT 1
      FROM   customer_order_tab co, customer_order_line_tab col
      WHERE co.customer_no           = customer_no_
      AND   co.order_no              = order_no_
      AND   co.scheduling_connection = 'SCHEDULE'
      AND   co.contract              = contract_
      AND   col.customer_part_no     = customer_part_no_
      AND   col.ship_addr_no         = ship_addr_no_
      AND   co.rowstate             IN ('Delivered', 'PartiallyDelivered', 'Invoiced');
BEGIN
   OPEN  scheduling_order;
   FETCH scheduling_order INTO temp_;
   CLOSE scheduling_order;
   IF temp_  = 1 THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Delivered_Sched_Order;


-- Get_Shipment_Charge_Amount
--   Return charge sum and base charge sum for an order that has lines
--   that are connected to a specified shipment.
@UncheckedAccess
PROCEDURE Get_Shipment_Charge_Amount (
   charge_sum_      IN OUT NUMBER,
   base_charge_sum_ IN OUT NUMBER,
   order_no_        IN     VARCHAR2,
   shipment_id_     IN     NUMBER )
IS
   CURSOR charge_amounts IS
      SELECT sum(charge_amount * charged_qty),
             sum(base_charge_amount * charged_qty)
      FROM CUSTOMER_ORDER_CHARGE_TAB
      WHERE collect = 'COLLECT'
      AND   shipment_id = shipment_id_
      AND   order_no = order_no_
      GROUP BY order_no;
BEGIN
   OPEN charge_amounts;
   FETCH charge_amounts INTO charge_sum_, base_charge_sum_;
   IF (charge_amounts%NOTFOUND) THEN
      charge_sum_      := 0;
      base_charge_sum_ := 0;
   END IF;
   CLOSE charge_amounts;
END Get_Shipment_Charge_Amount;


-- Get_Tot_Charge_Sale_Tax_Amt
--   Public function to return the sum of tax of all charge lines for a
--   given order.
@UncheckedAccess
FUNCTION Get_Tot_Charge_Sale_Tax_Amt (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_tax_amount_ NUMBER;

   CURSOR get_total_tax IS
      SELECT SUM(Customer_Order_Charge_API.Get_Total_Tax_Amount_Curr(charge.order_no, charge.sequence_no))
      FROM CUSTOMER_ORDER_CHARGE_TAB charge, CUSTOMER_ORDER_TAB ord
      WHERE ord.order_no = order_no_
        AND ord.rowstate != 'Cancelled' 
        AND ord.order_no = charge.order_no;
BEGIN
   IF Exist_Charges__ (order_no_) = 0 THEN
      total_tax_amount_ := 0;
   ELSE
      OPEN get_total_tax;
      FETCH get_total_tax INTO total_tax_amount_;
      CLOSE get_total_tax;
   END IF;
   RETURN NVL(total_tax_amount_,0);
END Get_Tot_Charge_Sale_Tax_Amt;


-- Get_Customer_Defaults
--   Method retrieves the default data using customer number and the contract.
PROCEDURE Get_Customer_Defaults (
   forwarder_id_         OUT    VARCHAR2,
   wanted_delivery_date_ IN OUT DATE,
   order_id_             IN OUT VARCHAR2,
   route_id_             IN OUT VARCHAR2,
   ship_via_code_        IN OUT VARCHAR2,
   delivery_terms_       IN OUT VARCHAR2,
   del_terms_location_   IN OUT VARCHAR2,
   customer_id_          IN     VARCHAR2,
   contract_             IN     VARCHAR2,
   delivery_address_     IN     VARCHAR2 )
IS
   attr_  VARCHAR2(2000);
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_NO', customer_id_, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   IF wanted_delivery_date_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('WANTED_DELIVERY_DATE', wanted_delivery_date_, attr_);
   END IF;
   IF order_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('ORDER_ID', order_id_, attr_);
   END IF;
   IF route_id_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('ROUTE_ID', route_id_, attr_);
   END IF;
   IF ship_via_code_ IS NOT NULL THEN
      Client_SYS.Add_To_Attr('SHIP_VIA_CODE', ship_via_code_, attr_);
   END IF;

   Client_SYS.Set_Item_Value('SHIP_ADDR_NO', delivery_address_, attr_);
   
   Client_SYS.Add_To_Attr('DELIVERY_TERMS', delivery_terms_, attr_);
   Client_SYS.Add_To_Attr('DEL_TERMS_LOCATION', del_terms_location_, attr_);
   -- Passed 'FALSE' for the all_attributes_ since not all attributes are needed for Distribution Orders
   Get_Customer_Defaults__(attr_, 'FALSE');

   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'WANTED_DELIVERY_DATE') THEN
         wanted_delivery_date_ := Client_SYS.Attr_Value_To_Date(value_);
      ELSIF (name_ = 'ORDER_ID') THEN
         order_id_ := value_;
      ELSIF (name_ = 'FORWARD_AGENT_ID') THEN
         forwarder_id_ := value_;
      ELSIF (name_ = 'ROUTE_ID') THEN
         route_id_ := value_;
      ELSIF (name_ = 'SHIP_VIA_CODE') THEN
         ship_via_code_ := value_;
      ELSIF (name_ = 'DELIVERY_TERMS') THEN
         delivery_terms_ := value_;
      ELSIF (name_ = 'DEL_TERMS_LOCATION' ) THEN
         IF(value_ != del_terms_location_) THEN
            Client_SYS.Add_Info(lu_name_, 'DELLOCCHANGED: Delivery Location Changed from :P1 to :P2', del_terms_location_, value_);
            del_terms_location_ := value_;
         END IF;
      END IF;
   END LOOP;
END Get_Customer_Defaults;


-- Is_Order_Exist
--   This will return 1(TRUE) if there is an  order with the order_no,
--   else it will return 0(FALSE).
@UncheckedAccess
FUNCTION Is_Order_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Check_Exist___(order_no_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Is_Order_Exist;

-- New_Or_Changed_Charge
--   This method should be called when new charge lines have been added 
--   or when exsisting lines have been modified in an order in state 'Invoiced'. 
--   Then it will force a state change to 'Delivered'.
PROCEDURE New_Or_Changed_Charge (
   order_no_ IN VARCHAR2 )
IS
   rec_          CUSTOMER_ORDER_TAB%ROWTYPE;
   old_objstate_ CUSTOMER_ORDER_TAB.rowstate%TYPE;
   attr_         VARCHAR2(200);
   message_      VARCHAR2(100);
BEGIN
   rec_ := Lock_By_Keys___(order_no_);
   old_objstate_ := rec_.rowstate;
   IF (old_objstate_ IN ('Invoiced')) THEN
      Finite_State_Machine___(rec_, 'NewOrChangedCharge', attr_);
      IF (rec_.rowstate != old_objstate_) THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'NEWCHARGELINE: New charge line added');
         Customer_Order_History_API.New(order_no_, message_);
      END IF;
   END IF;
END New_Or_Changed_Charge;


-- Set_Cancel_Reason
--   Updates the value of cancel_reason for the order.
PROCEDURE Set_Cancel_Reason (
   order_no_        IN VARCHAR2,
   cancel_reason_   IN VARCHAR2 )
IS
   info_ VARCHAR2(32000);
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Set_Item_Value('CANCEL_REASON', cancel_reason_, attr_);
   Modify(info_, attr_, order_no_);
END Set_Cancel_Reason;


-- Find_Open_Scheduling_Order
--   Finds the order no if there is a matching customer purchase order no
--   else find a order no which has schedule connection and is in open
--   state as required.
@UncheckedAccess
FUNCTION Find_Open_Scheduling_Order (
   customer_pur_order_no_ IN VARCHAR2,
   customer_no_           IN VARCHAR2,
   contract_              IN VARCHAR2,
   ship_addr_no_          IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_no_ VARCHAR2(12);

   CURSOR get_open_order_with_cpo IS
      SELECT order_no
      FROM   customer_order_tab
      WHERE customer_po_no = customer_pur_order_no_
      AND   customer_no    = customer_no_
      AND   contract       = contract_
      AND   ship_addr_no   = ship_addr_no_
      AND   rowstate  NOT IN ('Cancelled', 'Delivered' ,'Invoiced');

   CURSOR get_open_scheduling_order IS
      SELECT order_no
      FROM   customer_order_tab
      WHERE customer_no           = customer_no_
      AND   scheduling_connection = 'SCHEDULE'
      AND   contract              = contract_
      AND   ship_addr_no          = ship_addr_no_
      AND   customer_po_no       IS NULL
      AND   rowstate NOT IN ('Cancelled', 'Delivered' ,'Invoiced');
BEGIN
   IF customer_pur_order_no_ IS NOT NULL  THEN
      OPEN  get_open_order_with_cpo;
      FETCH get_open_order_with_cpo INTO order_no_;
      CLOSE get_open_order_with_cpo;
   ELSE
      OPEN  get_open_scheduling_order;
      FETCH get_open_scheduling_order INTO order_no_;
      CLOSE get_open_scheduling_order;
   END IF;

   RETURN order_no_;
END Find_Open_Scheduling_Order ;


-- Blocked_Invoicing_Exist
--   Return TRUE(1) if blocked for Invoicing exist on the specified order,
--   FALSE (0) if blocked for Invoicing does not exist.
@UncheckedAccess
FUNCTION Blocked_Invoicing_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;

   CURSOR blocked_invoicing_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  blocked_for_invoicing = 'TRUE'
      AND    order_no = order_no_;
BEGIN
   OPEN blocked_invoicing_exist;
   FETCH blocked_invoicing_exist INTO dummy_;
   IF (blocked_invoicing_exist%NOTFOUND) THEN
      dummy_ := 0;
   END IF;
   CLOSE blocked_invoicing_exist;
   RETURN dummy_;
END Blocked_Invoicing_Exist;


PROCEDURE Set_Line_Qty_Confirmeddiff (
   order_no_          IN VARCHAR2,
   line_no_           IN VARCHAR2,
   rel_no_            IN VARCHAR2,
   line_item_no_      IN NUMBER,
   qty_confirmeddiff_ IN NUMBER )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_CONFIRMEDDIFF', qty_confirmeddiff_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);

   IF CUSTOMER_ORDER_LINE_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_) != 'Cancelled' THEN
      Set_Line_Qty_Confirmeddiff__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Line_Qty_Confirmeddiff;


-- Get_Blocked_Reason_Desc
--   Returns the reason for the Customer Order to be blocked.
@UncheckedAccess
FUNCTION Get_Blocked_Reason_Desc (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lurec_ CUSTOMER_ORDER_TAB%ROWTYPE;
BEGIN
   lurec_ := Get_Object_By_Keys___(order_no_);

   IF (lurec_.blocked_reason = 'BLKFORADVPAY') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORADVPAY: The Customer Order is blocked. Payment Pending Advance Invoices Exist.');
   ELSIF (lurec_.blocked_reason = 'BLKFORCRE') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORCRE: The Customer Order is blocked since the customer is credit blocked.');
   ELSIF (lurec_.blocked_reason = 'BLKCRELMT') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKCRELMT: The Customer Order is blocked due to credit limit being exceeded.');
   ELSIF (lurec_.blocked_reason = 'BLKFORPREPAY') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORPREPAYM: The Customer Order is blocked. Required Prepayment Amount not fully paid.');
    ELSIF (lurec_.blocked_reason = 'BLKCRELMTEXT') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKCRELMTEXTM: The internal customer order is blocked due to external customer''s credit limit being exceeded.');
   ELSIF (lurec_.blocked_reason = 'BLKFORCREEXT') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORCREEXTM: The internal customer order is blocked since the external customer is credit-blocked.');
   ELSIF (lurec_.blocked_reason = 'BLKFORADVPAYEXT') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORADVPAYEXTM: The internal customer order is blocked due to external customer''s payment pending advance invoice is exist.');
   ELSIF (lurec_.blocked_reason = 'BLKFORPREPAYEXT') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORPREPAYEXTM: The internal customer order is blocked due to external customer''s Required Prepayment Amount not fully paid.');
   ELSIF (lurec_.blocked_reason = 'BLKFORCREMANUAL') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORCREMANUAL: Manual credit limit is checked. Customer order is blocked since the customer is credit-blocked.');
   ELSIF (lurec_.blocked_reason = 'BLKCRELMTMANUAL') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKCRELMTMANUAL: Manual credit limit is checked. Customer order is blocked due to the credit limit being exceeded.');
   ELSIF (lurec_.blocked_reason = 'BLKFORADVPAYMANUAL') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORADVPAYMANUAL: Manual credit limit is checked. The order is credit-blocked as unpaid advance invoices exist.');
   ELSIF (lurec_.blocked_reason = 'BLKFORPREPAYMANUAL') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORPREPAYMANUAL: Manual credit limit is checked. The customer order is blocked. The required prepayment amount has not been fully paid.');
   ELSIF (lurec_.rowstate = 'Blocked') THEN
      RETURN Language_SYS.Translate_Constant(lu_name_, 'BLKFORMANUAL: The customer order is manually blocked. :P1', NULL, Block_Reasons_API.Get_Block_Reason_Description(lurec_.blocked_reason));
   END IF;

   RETURN NULL;
END Get_Blocked_Reason_Desc;

-- Check_Forecast_Consumpt_Change
--   This will check the updating of Online consumption flag and raise the error
PROCEDURE Check_Forecast_Consumpt_Change (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 )
IS
   exist_ NUMBER := 0;
BEGIN
   IF Order_Quotation_Line_API.Check_Quote_Line_For_Planning(contract_,part_no_) THEN
      exist_ := 1;
   ELSIF Customer_Order_Line_API.Check_Order_Line_For_Planning(contract_, part_no_) THEN
      exist_ := 1;
   END IF;
   IF (exist_ = 1)THEN
      Error_SYS.Record_General(lu_name_, 'ERRORRELEASDN: Online Consumption cannot be updated when the Customer Orders are in Planned, Credit Blocked, Released, Reserved, Picked, Partially Delivered states or/and Sales Quotation Lines are in Released, Revised or Rejected states.');
   END IF;
END Check_Forecast_Consumpt_Change;


@UncheckedAccess
FUNCTION Consignment_Lines_Exist (
   contract_     IN VARCHAR2,
   customer_no_  IN VARCHAR2,
   ship_addr_no_ IN VARCHAR2,
   catalog_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   consign_lines_exist_ NUMBER;

   CURSOR get_consignment_lines IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE contract = contract_
      AND customer_no = customer_no_
      AND ship_addr_no = ship_addr_no_
      AND catalog_no = catalog_no_
      AND consignment_stock = 'CONSIGNMENT STOCK'
      AND rowstate IN ('Planned', 'Released', 'Reserved', 'Picked', 'PartiallyDelivered');
BEGIN
   OPEN get_consignment_lines;
   FETCH get_consignment_lines INTO consign_lines_exist_;
   CLOSE get_consignment_lines;

   RETURN (NVL(consign_lines_exist_, 0) = 1);
END Consignment_Lines_Exist;


-- Get_Gross_Amt_Incl_Charges
--   This will returns the gross amount including charges
@UncheckedAccess
FUNCTION Get_Gross_Amt_Incl_Charges (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   total_amt_       NUMBER;
   ord_gross_amt_   NUMBER;
   tot_sale_charge_ NUMBER;
   tot_sale_tax_    NUMBER;
BEGIN
   ord_gross_amt_   := NVL(Get_Ord_Gross_Amount(order_no_),0);
   tot_sale_charge_ := Get_Total_Sale_Charge__(order_no_);
   tot_sale_tax_    := Get_Tot_Charge_Sale_Tax_Amt(order_no_);
   total_amt_       := ord_gross_amt_ + tot_sale_charge_ + tot_sale_tax_;

   RETURN total_amt_;
END Get_Gross_Amt_Incl_Charges;


-- Handle_Pre_Posting_Change
--   This method will update Customer Order History when user adds or changes
--   customer order pre postings.
PROCEDURE Handle_Pre_Posting_Change (
   pre_accounting_id_ IN NUMBER )
IS
   order_no_      CUSTOMER_ORDER_TAB.order_no%TYPE;
   message_text_  VARCHAR2(80);

   CURSOR get_keys IS
      SELECT order_no
      FROM   CUSTOMER_ORDER_TAB
      WHERE  pre_accounting_id = pre_accounting_id_;
BEGIN
   OPEN get_keys;
   FETCH get_keys INTO order_no_;
   CLOSE get_keys;

   message_text_ := Language_SYS.Translate_Constant(lu_name_, 'PREACCCHG: The preposting has been added/changed.');
   Customer_Order_History_API.New(order_no_, message_text_);
END Handle_Pre_Posting_Change;


PROCEDURE Set_Msg_Sequence_And_Version (
   order_no_    IN VARCHAR2,
   sequence_no_ IN NUMBER,
   version_no_  IN NUMBER )
IS
   attr_       VARCHAR2(2000) := NULL;
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   oldrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_      CUSTOMER_ORDER.objid%TYPE;
   objversion_ CUSTOMER_ORDER.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('MSG_SEQUENCE_NO', sequence_no_, attr_);
   Client_SYS.Add_To_Attr('MSG_VERSION_NO', version_no_, attr_);

   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Msg_Sequence_And_Version;


-- Get_Adj_Weight_In_Charges
--   Now the adjusted weight is used for Freight Charges.
--   This method returns total of the total adjusted gross weights, of CO Lines, which has freight charge lines.
@UncheckedAccess
FUNCTION Get_Adj_Weight_In_Charges (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_total_gross IS
      SELECT SUM(NVL(col.adjusted_weight_gross,0))
        FROM Customer_Order_Line_Tab col, Customer_Order_Charge_Tab coc, sales_charge_type_tab sct
       WHERE col.order_no = order_no_
         AND col.rowstate != 'Cancelled'
         AND col.line_item_no <= 0
         AND coc.order_no = col.order_no
         AND coc.line_no = col.line_no
         AND coc.rel_no = col.rel_no
         AND coc.line_item_no = col.line_item_no
         AND sct.contract = coc.contract
         AND sct.charge_type = coc.charge_type
         AND sct.sales_chg_type_category = 'FREIGHT';
BEGIN
   OPEN get_total_gross;
   FETCH get_total_gross INTO temp_;
   CLOSE get_total_gross;
   RETURN temp_;
END Get_Adj_Weight_In_Charges;


-- Get_Adj_Volume_In_Charges
--   Now the adjusted volume is used for Freight Charges.
--   This method returns total of the total adjusted volumes, of CO Lines, which has freight charge lines.
@UncheckedAccess
FUNCTION Get_Adj_Volume_In_Charges (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   CURSOR get_total_gross IS
      SELECT SUM(NVL(col.adjusted_volume,0))
        FROM Customer_Order_Line_Tab col, Customer_Order_Charge_Tab coc, sales_charge_type_tab sct
       WHERE col.order_no = order_no_
         AND col.rowstate != 'Cancelled'
         AND col.line_item_no <= 0
         AND coc.order_no = col.order_no
         AND coc.line_no = col.line_no
         AND coc.rel_no = col.rel_no
         AND coc.line_item_no = col.line_item_no
         AND sct.contract = coc.contract
         AND sct.charge_type = coc.charge_type
         AND sct.sales_chg_type_category = 'FREIGHT';
BEGIN
   OPEN get_total_gross;
   FETCH get_total_gross INTO temp_;
   CLOSE get_total_gross;
   RETURN temp_;
END Get_Adj_Volume_In_Charges;


-- Get_Pegged_Orders
--   This method returns the number of pegged orders to the given Customer Order
--   where the customer order lines are not delivered, invoiced or cancelled.
@UncheckedAccess
FUNCTION Get_Pegged_Orders (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   pegged_comp_exists_ VARCHAR2(5);
   pegged_orders_      NUMBER := 0;

   CURSOR get_order_line_info IS
      SELECT line_no, rel_no, line_item_no, supply_code, qty_on_order
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    supply_code IN ('PT', 'PD', 'IPT', 'IPD', 'SO', 'DOP', 'PKG')
      AND    rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled');
BEGIN
   FOR line_rec_ IN get_order_line_info LOOP
      IF (line_rec_.supply_code IN ('IPT', 'PT', 'IPD', 'PD','SO', 'DOP')) THEN 
         IF (line_rec_.qty_on_order > 0) THEN
            pegged_orders_ := pegged_orders_ + 1; 
            EXIT;
         END IF;     
      ELSIF (line_rec_.supply_code = 'PKG') THEN
         pegged_comp_exists_ := Customer_Order_Line_API.Check_Pegged_Component_Exist(order_no_, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no);
         IF (pegged_comp_exists_ = 'TRUE') THEN
            pegged_orders_ := pegged_orders_ + 1;
            EXIT;
         END IF;    
      END IF;
   END LOOP;
   RETURN pegged_orders_;
END Get_Pegged_Orders;


-- Modify_Project_Id
--   Modify project in customer order header. called from customer order line.
PROCEDURE Modify_Project_Id (
   order_no_   IN VARCHAR2,
   project_id_ IN VARCHAR2 )
IS
   oldrec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(2000);
   currency_type_ CUSTOMER_ORDER_TAB.currency_rate_type%TYPE;
   indrec_        Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_ , order_no_);
   oldrec_ := Lock_By_Id___( objid_, objversion_);
   --Set currency rate type to project
   $IF Component_Proj_SYS.INSTALLED $THEN
      currency_type_ := Project_API.Get_Currency_Type(project_id_, Site_API.Get_Company(oldrec_.contract), 'CUSTOMER', oldrec_.customer_no);       
   $END
   
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PROJECT_ID', project_id_, attr_);
   Client_SYS.Add_To_Attr('CURRENCY_RATE_TYPE', currency_type_, attr_);   
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Project_Id;


-- Get_Promotion_Charges_Count
--   If there are sales promotion charges connected to the order this will return count
@UncheckedAccess
FUNCTION Get_Promotion_Charges_Count (order_no_ IN VARCHAR2) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_control IS
      SELECT count(coc.sequence_no)
      FROM CUSTOMER_ORDER_CHARGE_TAB coc, sales_charge_type_tab sct
      WHERE coc.order_no = order_no_
      AND sct.contract = coc.contract
      AND sct.charge_type = coc.charge_type
      AND sct.sales_chg_type_category = 'PROMOTION';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO found_;
   IF (exist_control%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN found_;
END Get_Promotion_Charges_Count;


-- Exist_Connected_Charges
--   Returns whether or not connected charges are used in an order.
@UncheckedAccess
FUNCTION Exist_Connected_Charges (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_  NUMBER;
   CURSOR exist_charge_lines IS
      SELECT 1
      FROM   CUSTOMER_ORDER_CHARGE_TAB
      WHERE  order_no = order_no_
      AND    line_no IS NOT NULL;
BEGIN
   OPEN exist_charge_lines;
   FETCH exist_charge_lines INTO found_;
   IF (exist_charge_lines%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE exist_charge_lines;
   RETURN found_;
END Exist_Connected_Charges;


-- Non_Ivc_Cancelled_Lines_Exist
--   Returns 1 if the specified order contains any lines with status other than 'Invoiced' and 'Cancelled'
@UncheckedAccess
FUNCTION Non_Ivc_Cancelled_Lines_Exist (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;

   CURSOR order_lines_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate NOT IN ('Invoiced', 'Cancelled');
BEGIN
   OPEN order_lines_exist;
   FETCH order_lines_exist INTO found_;
   IF (order_lines_exist%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE order_lines_exist;
   RETURN found_;
END Non_Ivc_Cancelled_Lines_Exist;


PROCEDURE Update_Freight_Free_On_Lines (
   order_no_ IN VARCHAR2 )
IS
  CURSOR get_order_lines IS
      SELECT *
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_ 
      AND    (adjusted_weight_gross IS NOT NULL OR adjusted_volume IS NOT NULL)
      AND    rowstate != 'Cancelled';
BEGIN
   FOR rec_ IN get_order_lines LOOP
      CUSTOMER_ORDER_LINE_API.Update_Freight_Free(rec_);      
   END LOOP;      
END Update_Freight_Free_On_Lines;


-- Check_Config_Revisions
--   This method checks whether the part configuration revisions used to create configurations
--   for each customer order line is valid for each line's planned delivery date and returns
--   the number of reserved and unreserved lines with invalid configuration revisions.
PROCEDURE Check_Config_Revisions (
   unreserved_    OUT NUMBER,
   reserved_      OUT NUMBER,
   order_no_      IN  VARCHAR2,
   delivery_date_ IN DATE)
IS
   revision_status_       VARCHAR2(50);
   unreserved_lines_      NUMBER := 0;
   reserved_lines_        NUMBER := 0;
   
   CURSOR get_all_lines IS
      SELECT part_no, configuration_id, qty_assigned
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate NOT IN ('Invoiced', 'Cancelled')
      AND    line_item_no <= 0;
BEGIN
   FOR rec_ IN get_all_lines LOOP
      IF Nvl(rec_.configuration_id, '*') != '*' THEN
         revision_status_ := Get_Revision_Status___(rec_.part_no, rec_.configuration_id, delivery_date_);
         IF (revision_status_ = 'INVALID') THEN
            IF (rec_.qty_assigned > 0) THEN
               reserved_lines_ := reserved_lines_ + 1;
            ELSE
               unreserved_lines_ := unreserved_lines_ + 1;
            END IF;
         END IF;
      END IF;
   END LOOP;
   unreserved_ := unreserved_lines_;
   reserved_ := reserved_lines_;
END Check_Config_Revisions;

-- Update_Config_Revisions
--   This method updates the part configuration revisions used to create configurations
--   for each customer order line to revision valid for the new planned delivery date.
--   Excludes lines with reserved qty > 0.
PROCEDURE Update_Config_Revisions (
   order_no_   IN  VARCHAR2,
   delivery_date_ IN DATE)
IS   
   CURSOR get_all_lines IS
      SELECT part_no, configuration_id, qty_assigned, configured_line_price_id
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate NOT IN ('Invoiced', 'Cancelled')
      AND    line_item_no <= 0;
      
     new_config_id_ VARCHAR2(50);
     spec_rev_no_   NUMBER;
BEGIN
   $IF Component_Cfgchr_SYS.INSTALLED $THEN
      FOR rec_ IN get_all_lines LOOP
         IF (Get_Revision_Status___(rec_.part_no, rec_.configuration_id, delivery_date_) = 'INVALID')
          AND (rec_.qty_assigned = 0) THEN
            spec_rev_no_ := Config_Part_Spec_Rev_API.Get_Spec_Rev_For_Date(rec_.part_no, delivery_date_, 'FALSE');
            Configuration_Spec_API.Create_New_Config_Spec(new_config_id_, rec_.part_no, spec_rev_no_, rec_.configuration_id, rec_.configured_line_price_id, 'TRUE');
            Configuration_Spec_API.Manual_Park(new_config_id_, rec_.part_no);
            Configured_Line_Price_API.Update_Parent_Config_Id(rec_.configured_line_price_id, new_config_id_, 'TRUE');
         END IF;
      END LOOP;
   $ELSE
      NULL;
   $END
END Update_Config_Revisions;

@UncheckedAccess
FUNCTION Get_Order_Currency_Rounding (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_currency_info IS
      SELECT Site_API.Get_Company(contract), currency_code
        FROM CUSTOMER_ORDER_TAB 
       WHERE order_no = order_no_;
       
   company_           VARCHAR2(80);
   currency_code_     VARCHAR2(12);    
   currency_rounding_ NUMBER := 0;
BEGIN
   OPEN get_currency_info;
   FETCH get_currency_info INTO company_, currency_code_;
   CLOSE get_currency_info;
   
   currency_rounding_ := Currency_Code_Api.Get_Currency_Rounding( company_, currency_code_); 
   
   RETURN currency_rounding_;
END Get_Order_Currency_Rounding; 


FUNCTION Is_Single_Occ_Addr_Connected (
   order_no_           IN VARCHAR2,
   line_no_            IN VARCHAR2,
   release_no_         IN VARCHAR2,
   line_item_no_       IN NUMBER) RETURN VARCHAR2
IS
   single_occ_addr_   VARCHAR2(5):= 'FALSE';
BEGIN
   IF ((order_no_ IS NOT NULL) AND (line_no_ IS NOT NULL) AND (release_no_ IS NOT NULL) AND (line_item_no_ IS NOT NULL)) THEN
      IF (Customer_Order_Line_API.Get_Addr_Flag_Db(order_no_, line_no_, release_no_, line_item_no_ ) = 'Y') THEN
         single_occ_addr_ := 'TRUE';
      END IF;
   ELSIF (order_no_ IS NOT NULL) THEN
      IF (Get_Addr_Flag_Db(order_no_) = 'Y') THEN
         single_occ_addr_ := 'TRUE';
      END IF;
   END IF;
   RETURN single_occ_addr_;   
END Is_Single_Occ_Addr_Connected;
   
   
@UncheckedAccess
FUNCTION Is_Customer_Credit_Blocked (
   order_no_                   IN VARCHAR2,
   released_from_credit_check_ IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   result_  VARCHAR2(25) := 'FALSE';
   attr_    VARCHAR2(2000);
   
BEGIN
   Check_Customer_Credit_Blocked(result_, attr_, order_no_, released_from_credit_check_);
   RETURN result_;
END Is_Customer_Credit_Blocked;  
   
@UncheckedAccess

PROCEDURE Check_Customer_Credit_Blocked (
   credit_block_result_        OUT VARCHAR2,
   attr_                       OUT VARCHAR2,
   order_no_                   IN VARCHAR2,
   released_from_credit_check_ IN VARCHAR2 DEFAULT NULL)
IS
   company_ VARCHAR2(25);

   CURSOR get_order_info IS
      SELECT customer_no,
             customer_no_pay,
             contract
        FROM CUSTOMER_ORDER_TAB
       WHERE order_no = order_no_
         AND (released_from_credit_check = released_from_credit_check_ OR
              released_from_credit_check_ IS NULL) ;

   rec_  get_order_info%ROWTYPE;
   credit_blocked_   NUMBER;
BEGIN
   OPEN get_order_info;
   FETCH get_order_info INTO rec_;
   credit_block_result_ := 'FALSE';
   IF get_order_info%FOUND THEN
      company_ := Site_API.Get_Company(rec_.contract);
      -- If paying customer is different check credit block for paying customer.
      -- If no separate paying customer is given, check the customer.
      Cust_Ord_Customer_API.Get_Cust_Credit_Stop_Detail(credit_blocked_, attr_, NVL(rec_.customer_no_pay, rec_.customer_no), company_);
      IF (credit_blocked_ = 1) THEN
         IF (rec_.customer_no_pay IS NOT NULL) AND (rec_.customer_no != rec_.customer_no_pay) THEN
            credit_block_result_ := 'PAY_CUSTOMER_BLOCKED';
         ELSE
            credit_block_result_ := 'CUSTOMER_BLOCKED';
         END IF;
      END IF;  
   END IF;

   CLOSE get_order_info;
END Check_Customer_Credit_Blocked;


-- Copy_Prepostings_To_Lines
--   Pre postings from the given order header will get copied to all its' lines.
--   Intended to use in Order Quotation when creating order from quotation, with prepostings information added at that moment.
PROCEDURE Copy_Prepostings_To_Lines (
   order_no_ IN VARCHAR2)
IS
   header_pre_acc_ NUMBER;
   CURSOR get_line_accounting_ids IS
      SELECT pre_accounting_id, contract
        FROM CUSTOMER_ORDER_LINE_TAB
       WHERE order_no = order_no_;
BEGIN
   header_pre_acc_ := Get_Pre_Accounting_Id(order_no_);
   FOR line_ IN get_line_accounting_ids LOOP
      Pre_Accounting_API.Copy_Pre_Accounting(header_pre_acc_, line_.pre_accounting_id, line_.contract);
   END LOOP;
END Copy_Prepostings_To_Lines;


-- Modify_Line_Purchase_Part_No
--   Calls the function Modify_Purchase_Part_No on a specific customer order line if the
--   purchase part no field is NULL when the purchase part is connected to an inventory part from Purchasing.
PROCEDURE Modify_Line_Purchase_Part_No (
   contract_         IN VARCHAR2,
   catalog_no_       IN VARCHAR2,
   purchase_part_no_ IN VARCHAR2)
IS
   -- Added check to allow updating the customer order line with the purchase part no if the 
   -- supply code is not decided or invent order.
   CURSOR get_planned_order_lines IS
      SELECT col.order_no, col.line_no, rel_no, col.line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_TAB co
      WHERE co.order_no     = col.order_no
      AND   co.contract     = contract_ 
      AND  col.catalog_no   = catalog_no_
      AND    col.rowstate   != 'Cancelled'
      AND    col.purchase_part_no IS NULL
      AND   ((co.rowstate    = 'Planned') OR ((co.rowstate    = 'Released') AND (col.supply_code IN ('IO', 'ND'))));
BEGIN

   FOR line_rec_ IN get_planned_order_lines LOOP
      Customer_Order_Line_API.Modify_Purchase_Part_No (line_rec_.order_no, line_rec_.line_no, line_rec_.rel_no, line_rec_.line_item_no, purchase_part_no_);
   END LOOP;
END Modify_Line_Purchase_Part_No;


PROCEDURE Fetch_Delivery_Attributes (
   route_id_                  IN OUT VARCHAR2,
   delivery_leadtime_         IN OUT NUMBER,
   ext_transport_calendar_id_ OUT    VARCHAR2,
   freight_map_id_            OUT    VARCHAR2,
   zone_id_                   OUT    VARCHAR2,
   picking_leadtime_          IN OUT NUMBER,
   shipment_type_             IN OUT VARCHAR2,
   forward_agent_id_          IN OUT VARCHAR2,
   delivery_terms_            IN OUT VARCHAR2,
   del_terms_location_        IN OUT VARCHAR2,
   order_no_                  IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   ship_addr_no_              IN     VARCHAR2,
   addr_flag_db_              IN     VARCHAR2,
   ship_via_code_             IN     VARCHAR2,
   vendor_no_                 IN     VARCHAR2,
   ship_via_code_changed_     IN     VARCHAR2 DEFAULT 'FALSE')
IS
   sing_occ_addr_     Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   zone_info_exist_   VARCHAR2(5) := 'FALSE';
   ship_inventory_location_no_ VARCHAR2(35);
BEGIN
   Cust_Order_Leadtime_Util_API.Fetch_Head_Delivery_Attributes( route_id_,
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
                                                                vendor_no_,
                                                                ship_via_code_changed_);

   IF (freight_map_id_ IS NULL) AND (zone_id_ IS NULL) THEN
      IF (addr_flag_db_ = 'N') THEN
         Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(freight_map_id_,
                                                        zone_id_,
                                                        customer_no_,
                                                        ship_addr_no_,
                                                        contract_,
                                                        ship_via_code_);
      ELSE
         sing_occ_addr_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_);
         Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                           zone_id_,
                                                           zone_info_exist_,
                                                           contract_,
                                                           ship_via_code_,
                                                           sing_occ_addr_.zip_code,
                                                           sing_occ_addr_.city,
                                                           sing_occ_addr_.county,
                                                           sing_occ_addr_.state,
                                                           sing_occ_addr_.country_code);
      END IF;
   END IF;
END Fetch_Delivery_Attributes;


-- Fetch_Default_Delivery_Info
--   This method is used to retrieve default delivery information. If no Freight zone information
--   is defined in supplier chain matrix, the delivery address is considered.
PROCEDURE Fetch_Default_Delivery_Info (
   forward_agent_id_          IN OUT    VARCHAR2,
   route_id_                  IN OUT    VARCHAR2,
   freight_map_id_            IN OUT    VARCHAR2,
   zone_id_                   IN OUT    VARCHAR2,
   delivery_leadtime_         IN OUT    NUMBER,
   ext_transport_calendar_id_ IN OUT    VARCHAR2,
   picking_leadtime_          IN OUT    NUMBER,
   shipment_type_             IN OUT    VARCHAR2,
   ship_via_code_             IN OUT VARCHAR2,
   delivery_terms_            IN OUT VARCHAR2,
   del_terms_location_        IN OUT VARCHAR2,
   order_no_                  IN     VARCHAR2,
   contract_                  IN     VARCHAR2,
   customer_no_               IN     VARCHAR2,
   ship_addr_no_              IN     VARCHAR2,
   addr_flag_db_              IN     VARCHAR2,
   agreement_id_              IN     VARCHAR2,
   vendor_no_                 IN     VARCHAR2,
   ship_addr_no_changed_      IN     VARCHAR2 DEFAULT 'FALSE')
IS
   sing_occ_addr_              Customer_Order_Address_API.Cust_Ord_Addr_Rec;
   zone_info_exist_            VARCHAR2(5) := 'FALSE';
   ship_inventory_location_no_ VARCHAR2(35);
BEGIN
   Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(ship_via_code_,
                                                               delivery_terms_,
                                                               del_terms_location_,
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
                                                               addr_flag_db_,
                                                               agreement_id_,
                                                               vendor_no_,
                                                               ship_addr_no_changed_);
   IF (freight_map_id_ IS NULL) AND (zone_id_ IS NULL) THEN
      IF (addr_flag_db_ = 'N') THEN
         Freight_Zone_Util_API.Fetch_Zone_For_Cust_Addr(freight_map_id_,
                                                        zone_id_,
                                                        customer_no_,
                                                        ship_addr_no_,
                                                        contract_,
                                                        ship_via_code_);
      ELSE
         sing_occ_addr_ := Customer_Order_Address_API.Get_Cust_Ord_Addr(order_no_);
         Freight_Zone_Util_API.Fetch_Zone_For_Addr_Details(freight_map_id_,
                                                           zone_id_,
                                                           zone_info_exist_,
                                                           contract_,
                                                           ship_via_code_,
                                                           sing_occ_addr_.zip_code,
                                                           sing_occ_addr_.city,
                                                           sing_occ_addr_.county,
                                                           sing_occ_addr_.state,
                                                           sing_occ_addr_.country_code);
      END IF;
   END IF;
END Fetch_Default_Delivery_Info;


-- All_Lines_Cancelled
--   Returns TRUE when all the CO lines are cancelled.
@UncheckedAccess
FUNCTION All_Lines_Cancelled (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_               NUMBER;
   all_lines_cancelled_ VARCHAR2(5) := 'FALSE';
   
   CURSOR get_not_cancelled_lines IS
      SELECT 1
      FROM   customer_order_line_tab
      WHERE  order_no  = order_no_
      AND    rowstate != 'Cancelled';
BEGIN
   IF (CUSTOMER_ORDER_API.Order_Lines_Exist(order_no_) = 1) THEN
      OPEN get_not_cancelled_lines;
      FETCH get_not_cancelled_lines INTO dummy_;
      IF (get_not_cancelled_lines%NOTFOUND) THEN
         IF (Exist_Charges__(order_no_) = 0) THEN
            all_lines_cancelled_ := 'TRUE';
         END IF;
      END IF;
      CLOSE get_not_cancelled_lines;
   END IF;
   RETURN all_lines_cancelled_;
END All_Lines_Cancelled;

-- Check_No_Default_Info_Lines
--   This method will return TRUE if all the CO lines have default Info NOT selected. Otherwise this will return FALSE.
@UncheckedAccess
FUNCTION Check_No_Default_Info_Lines (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS   
   dummy_                  NUMBER;
   
   CURSOR get_default_info IS
      SELECT 1   
         FROM  CUSTOMER_ORDER_LINE_TAB
         WHERE order_no  = order_no_
         AND rowstate NOT IN ('Delivered', 'Invoiced', 'Cancelled')
         AND default_addr_flag = 'Y';          
BEGIN   
   OPEN get_default_info;
   FETCH get_default_info INTO dummy_;
   IF (get_default_info%FOUND) THEN 
      CLOSE get_default_info;
      -- There are lines with default info selected.
      RETURN 'FALSE';
   END IF; 
   -- No default info lines.
   RETURN 'TRUE';
END Check_No_Default_Info_Lines;

-- Valid_Ownership_Del_Line_Exist
--   This method returns at least one company owned/company rental asset delivered line exists for non rental or
--   company rental asset, supplier rented delivered line exist for rentals in
--   given customer order which can be connected to RMA if needed.
@UncheckedAccess
FUNCTION Valid_Ownership_Del_Line_Exist (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   line_exist_   NUMBER;
   CURSOR get_deliv_line IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    ((rental = 'FALSE' AND part_ownership IN ('COMPANY OWNED', 'COMPANY RENTAL ASSET')) OR 
              (rental = 'TRUE'  AND part_ownership IN ('SUPPLIER RENTED', 'COMPANY RENTAL ASSET')))
      AND    rowstate IN ('Delivered', 'PartiallyDelivered', 'Invoiced');
BEGIN
   OPEN get_deliv_line;
   FETCH get_deliv_line INTO line_exist_;
   CLOSE get_deliv_line;

   RETURN (NVL(line_exist_, 0) = 1);
END Valid_Ownership_Del_Line_Exist;


-- Check_Order_Exist_For_Customer
--   Check whether any non Delivered, Invoiced or Cancelled orders exist for a given customer in a considered site.
@UncheckedAccess
FUNCTION Check_Order_Exist_For_Customer (
   contract_     IN VARCHAR2,
   customer_no_  IN VARCHAR2 ) RETURN BOOLEAN
IS  
   found_ NUMBER := NULL;   
   CURSOR order_exist IS
      SELECT 1
      FROM CUSTOMER_ORDER_TAB
      WHERE contract    =  contract_
        AND customer_no = customer_no_
        AND rowstate    NOT IN ('Delivered', 'Invoiced', 'Cancelled');
BEGIN
   OPEN order_exist;
   FETCH order_exist INTO found_;
   CLOSE order_exist;
   
   IF (found_ = 1) THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;             
END Check_Order_Exist_For_Customer;


-- Check_Ipd_Tax_Registration
--   This method checks whether there are IPD lines with delivery address country
--   is different to the order header supply country and the comapny has a tax
--   registration in the delivery address country.
PROCEDURE Check_Ipd_Tax_Registration (
   order_no_              IN VARCHAR2,
   use_default_addr_flag_ IN VARCHAR2 )
IS 
   CURSOR get_lines(default_addr_flag_ IN VARCHAR2) IS
      SELECT line_no, rel_no, line_item_no, contract, country_code
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rowstate NOT IN ('Cancelled', 'Invoiced')
      AND    supply_code = 'IPD'
      AND    default_addr_flag = NVL(default_addr_flag_, default_addr_flag);

   supply_country_         VARCHAR2(2);
   company_                VARCHAR2(20);
   country_desc_           VARCHAR2(740);   
   contract_               VARCHAR2(5);
   temp_default_addr_flag_ VARCHAR2(5);
BEGIN
   supply_country_ := Get_Supply_Country_Db(order_no_);
   contract_       := Get_Contract(order_no_);
   company_        := Site_API.Get_Company(contract_);
   IF use_default_addr_flag_ = 'TRUE' THEN
      temp_default_addr_flag_ := 'Y';
   ELSE
      temp_default_addr_flag_ := NULL;
   END IF;
      
   FOR rec_ IN get_lines(temp_default_addr_flag_) LOOP
      IF Tax_Handling_Order_Util_API.Check_Ipd_Tax_Registration (company_, rec_.contract, 'IPD', supply_country_, rec_.country_code) THEN
         country_desc_ := Iso_Country_API.Get_Description(rec_.country_code, NULL);
         Client_SYS.Add_Info(lu_name_, 'SUPCOUNTRYDIFF: Company :P1 has a tax registration in delivery country :P2. The company tax ID number for the supply country of the order might not be appropriate.', company_, country_desc_);
         EXIT;
      END IF;
   END LOOP;
END Check_Ipd_Tax_Registration;


-- Internal_Co_Exists
--   Checks to see if internal CO having the customer po no was created from internal PO.
@UncheckedAccess
FUNCTION Internal_Co_Exists (
   customer_no_    IN VARCHAR2,
   customer_po_no_ IN VARCHAR2 ) RETURN NUMBER
IS
    temp_ NUMBER := 0;

   CURSOR check_exists IS
      SELECT 1
      FROM CUSTOMER_ORDER_TAB
      WHERE customer_no = customer_no_
      AND customer_po_no = customer_po_no_ 
      AND internal_po_no IS NULL;
BEGIN
   OPEN check_exists;
   FETCH check_exists INTO temp_;
   CLOSE check_exists;

   RETURN temp_;    
END Internal_Co_Exists;


-- Check_Rel_Mtrl_Planning
--   Check whether any lines exist with rel_mtrl_planning is FALSE for a given order.
--   If so set the value of rel_mtrl_planning to TRUE.
PROCEDURE Check_Rel_Mtrl_Planning(
   order_no_               IN VARCHAR2,
   create_connected_order_ IN VARCHAR2 )
IS
   CURSOR get_non_mtrl_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rel_mtrl_planning = 'FALSE'
      AND    rowstate != 'Cancelled';
BEGIN   
   FOR next_line_ IN get_non_mtrl_lines LOOP
      Customer_Order_Line_API.Set_Rel_Mtrl_Planning(order_no_, next_line_.line_no, next_line_.rel_no, next_line_.line_item_no, 'TRUE', create_connected_order_);
   END LOOP;   
END Check_Rel_Mtrl_Planning;

-- Uncheck_Rel_Mtrl_Planning
--    This method will be used only when CO is manually blocking or when the manual block reason changes in CO.
--    If the manual block reason is with exclude_mtrl_planning check box is checked, co lines rel_mtrl_planning should be
--    cleared for the customer orders which are in state Planned, Released and the orders that doesn't have pegged orders.
PROCEDURE Uncheck_Rel_Mtrl_Planning(   
   order_no_         IN VARCHAR2,
   blocked_reason_   IN VARCHAR2 )   
IS
   exclude_mtrl_planning_  block_reasons_tab.exclude_mtrl_planning%TYPE; 
   co_state_               customer_order_tab.rowstate%TYPE;
   pegged_orders_          NUMBER;
   
   CURSOR get_mtrl_lines IS
      SELECT rowstate, line_no, rel_no, line_item_no
      FROM   customer_order_line_tab
      WHERE  order_no = order_no_
      AND    rel_mtrl_planning = 'TRUE'
      AND    rowstate IN ('Released');
BEGIN      
   IF (blocked_reason_ != 'BLKFORMANUALEXT') THEN
      exclude_mtrl_planning_ := Block_Reasons_API.Get_Exclude_Mtrl_Planning_db(blocked_reason_);      
      IF exclude_mtrl_planning_ = 'TRUE' THEN
         -- If the CO state is in Reserved, Picked, Partially Delivered state it will validate and give an error
         co_state_ := Customer_Order_API.Get_Objstate(order_no_);         
         IF (co_state_ IN ('Reserved', 'Picked', 'PartiallyDelivered')) THEN
            Error_SYS.Record_General(lu_name_, 'RESMANBLOCKEXTMTRL: Clear the Exclude Mtrl Planning check box for the specified block reason to block this order as the Release for Mtrl Planning check box can be updated only when the order line is in Released status.');
         END IF;
         -- Checked for pegged orders. 
         pegged_orders_ := Customer_Order_API.Get_Pegged_Orders(order_no_);
         IF pegged_orders_ > 0 THEN
            -- If external CO has pegged orders it won't allow to edit rel_mtrl_planning value.
            Error_SYS.Record_General(lu_name_, 'MANBLOCKEXTMTRL: Clear the Exclude Mtrl Planning check box for the specified block reason to block this order as the Release for Mtrl planning check box cannot be cleared when pegged supplies are created.');
         ELSE               
            FOR next_line_ IN get_mtrl_lines LOOP
               Customer_Order_Line_API.Set_Rel_Mtrl_Planning(order_no_, next_line_.line_no, next_line_.rel_no, next_line_.line_item_no, 'FALSE', Fnd_Boolean_API.DB_TRUE );
            END LOOP;
         END IF;
            
      END IF;
   END IF;      
END Uncheck_Rel_Mtrl_Planning;

----------------------------------------------------------
-- Is_Expctr_Connected
--   Returns true if export license connected line exist.
---------------------------------------------------------
@UncheckedAccess
FUNCTION Is_Expctr_Connected(
   order_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   connection_exist_ VARCHAR2(5) := 'FALSE';
   licensed_order_type_ VARCHAR2(25);
   CURSOR get_order_lines IS
      SELECT demand_code, demand_order_ref1, demand_order_ref2, demand_order_ref3
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_;
BEGIN
   $IF Component_Expctr_SYS.INSTALLED $THEN
      IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
         FOR rec_ IN get_order_lines LOOP
            licensed_order_type_ := Customer_Order_Line_API.Get_Expctr_License_Order_Type(rec_.demand_code, rec_.demand_order_ref1, rec_.demand_order_ref2, rec_.demand_order_ref3);
            connection_exist_ := Exp_License_Connect_Util_API.Is_Expctr_Connected(order_no_, NULL, NULL, NULL, licensed_order_type_);
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END
   RETURN connection_exist_;
END Is_Expctr_Connected;


-- Rental_Lines_Exist
--   Returns true if any rental lines exist for a given order.
@UncheckedAccess
FUNCTION Rental_Lines_Exist(
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   lines_found_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
   dummy_       NUMBER;
   CURSOR order_lines_exist IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rental = Fnd_Boolean_API.DB_TRUE;
BEGIN
   OPEN order_lines_exist;
   FETCH order_lines_exist INTO dummy_;
   IF (order_lines_exist%FOUND) THEN
      lines_found_ := Fnd_Boolean_API.DB_TRUE;
   END IF;
   CLOSE order_lines_exist;
   RETURN lines_found_;
END Rental_Lines_Exist;


-- Get_Customer_Po_No
--   Returns the customer's purchase order no.
--   Checks if the Customer Po No exists for the relevent customer.
--   Returns Customer No.
@UncheckedAccess
FUNCTION Get_Customer_Po_No (
   customer_po_no_ IN VARCHAR2,
   customer_no_    IN VARCHAR2,
   order_no_       IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   temp_ NUMBER := 0;
   CURSOR get_attr IS
      SELECT 1
      FROM   CUSTOMER_ORDER_TAB
      WHERE  customer_po_no = customer_po_no_
      AND    customer_no = customer_no_;

   CURSOR get_attr_update IS
      SELECT 1
      FROM   CUSTOMER_ORDER_TAB
      WHERE  customer_po_no = customer_po_no_
      AND    customer_no = customer_no_
      AND    order_no != order_no_;
BEGIN
   IF order_no_ IS NULL THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   ELSE
      OPEN get_attr_update;
      FETCH get_attr_update INTO temp_;
      CLOSE get_attr_update; 
   END IF;
   RETURN temp_ ;
END Get_Customer_Po_No;

-- Get_Bo_Connected_Order_No
--    Returns the list of order no connected to specific business opportunity no. 
-------------------------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Bo_Connected_Order_No (
   business_opportunity_no_ IN VARCHAR2 ) RETURN VARCHAR2   
IS   
   order_no_ VARCHAR2(32000);
   CURSOR get_rec IS 
      SELECT order_no
      FROM   CUSTOMER_ORDER_TAB
      WHERE  business_opportunity_no = business_opportunity_no_;               
BEGIN  
   FOR rec_ IN get_rec LOOP
      IF order_no_ IS NULL THEN
         order_no_ := rec_.order_no;
      ELSE
         order_no_ := order_no_ || ',' || rec_.order_no;
      END IF;
   END LOOP;
   RETURN order_no_;   
END Get_Bo_Connected_Order_No;

PROCEDURE New_Rental_Replacement_Order (
   new_order_no_      OUT VARCHAR2, 
   old_order_no_      IN  VARCHAR2,
   old_line_no_       IN  VARCHAR2,
   old_rel_no_        IN  VARCHAR2,
   old_line_item_no_  IN  NUMBER,
   new_buy_qty_due_   IN  NUMBER,
   rental_attr_       IN  VARCHAR2 ) 
IS
   co_rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   addr_rec_      CUSTOMER_ORDER_ADDRESS_TAB%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   
   CURSOR get_address IS
      SELECT *
      FROM customer_order_address_tab
      WHERE order_no = old_order_no_;
BEGIN   
   co_rec_ := Get_Object_By_Keys___(old_order_no_);   
   attr_   := Pack___(co_rec_); 
   attr_   := Client_SYS.Remove_attr('ORDER_NO', attr_);   
   -- gelr:disc_price_rounded, begin
   attr_   := Client_SYS.Remove_attr('DISC_PRICE_ROUND_DB', attr_);
   attr_   := Client_SYS.Remove_attr('DISC_PRICE_ROUND', attr_);
   -- gelr:disc_price_rounded, end
   
   --These values should not be copied.
   Client_SYS.Set_Item_Value('ADDITIONAL_DISCOUNT', 0, attr_);
   Client_SYS.Set_Item_Value('NOTE_TEXT', '', attr_);
   Client_SYS.Set_Item_Value('NOTE_ID', '', attr_);
   Client_SYS.Set_Item_Value('PRE_ACCOUNTING_ID', TO_NUMBER(NULL), attr_);
   Client_SYS.Set_Item_Value('CURRENCY_RATE_TYPE', '', attr_);
   Client_SYS.Set_Item_Value('AGREEMENT_ID', '', attr_);
   Client_SYS.Set_Item_Value('INTERNAL_PO_NO', '', attr_);
   Client_SYS.Set_Item_Value('INTERNAL_REF', '', attr_);
   Client_SYS.Set_Item_Value('LABEL_NOTE', '', attr_);
   Client_SYS.Set_Item_Value('INTERNAL_PO_LABEL_NOTE', '', attr_);
   -- Wanted delivery date needs to recalculate
   Client_SYS.Set_Item_Value('WANTED_DELIVERY_DATE', TO_DATE(NULL), attr_);
   Client_SYS.Set_Item_Value('ORDER_CONF_DB', 'N', attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);   
   
   --Copy the address:
   IF (co_rec_.addr_flag = Gen_Yes_No_API.DB_YES) THEN
      OPEN get_address;
      FETCH get_address INTO addr_rec_;
      CLOSE get_address;
      Customer_Order_Address_API.New(order_no_           => newrec_.order_no,
                                     addr_1_             => addr_rec_.addr_1,
                                     address1_           => addr_rec_.address1,
                                     address2_           => addr_rec_.address2,
                                     address3_           => addr_rec_.address3,
                                     address4_           => addr_rec_.address4,
                                     address5_           => addr_rec_.address5,
                                     address6_           => addr_rec_.address6,
                                     zip_code_           => addr_rec_.zip_code,
                                     city_               => addr_rec_.city,
                                     state_              => addr_rec_.state,
                                     county_             => addr_rec_.county,
                                     country_code_       => addr_rec_.country_code,
                                     in_city_            => addr_rec_.in_city,
                                     vat_free_vat_code_  => addr_rec_.vat_free_vat_code);
   END IF;
   
   --Create new replacement customer order line.
   Customer_Order_Line_API.New_Rental_Replacement_Line(newrec_.order_no,
                                                       old_order_no_,
                                                       old_line_no_,
                                                       old_rel_no_,
                                                       old_line_item_no_,
                                                       new_buy_qty_due_,
                                                       rental_attr_);
   
   new_order_no_ := newrec_.order_no;
 END New_Rental_Replacement_Order;

-- Set_Rent_Line_Completed
--    This will complete the rental order line and closed the
--    CO header and line status.
PROCEDURE Set_Rent_Line_Completed (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   IF Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_) = 'Delivered' THEN
      Set_Rent_Line_Completed__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'COMPLETERENTAL: Rental completed'));
   END IF;
END Set_Rent_Line_Completed;

-- Set_Rent_Line_Reopened
--    This will reopen the rental order line for invoicing 
--    when CO header and line is closed.
PROCEDURE Set_Rent_Line_Reopened (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   IF Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_) = 'Invoiced' THEN
      Set_Rent_Line_Reopened__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'REOPENRENTAL: Rental reopened'));
   END IF;
END Set_Rent_Line_Reopened;

-- Set_Line_Uninvoiced
--    This will un-invoice the order line
PROCEDURE Set_Line_Uninvoiced (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_invoiced_ IN NUMBER )
IS
   rec_              Customer_Order_Tab%ROWTYPE;
   order_line_rec_   Customer_Order_Line_API.Public_Rec;
   info_             VARCHAR2(32000);
   attr_             VARCHAR2(32000);
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   invoice_exists_   BOOLEAN := FALSE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_INVOICED', qty_invoiced_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   
   order_line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   
   IF (order_line_rec_.rowstate != 'Cancelled' ) THEN
      IF ((NVL(order_line_rec_.qty_invoiced, 0) != 0)) THEN
         invoice_exists_ := TRUE;
      ELSIF (order_line_rec_.rental = Fnd_Boolean_API.DB_TRUE) THEN
         $IF (Component_Rental_SYS.INSTALLED) $THEN
            invoice_exists_ := Rental_Transaction_API.Invoiced_Transactions_Exist(order_line_rec_.order_no, order_line_rec_.line_no, order_line_rec_.rel_no, order_line_rec_.line_item_no, Rental_Type_API.DB_CUSTOMER_ORDER);
         $ELSE
            invoice_exists_ := FALSE;
         $END
      END IF;
   END IF;
   
   IF (invoice_exists_ ) THEN
      Set_Line_Uninvoiced__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_);
   END IF;
END Set_Line_Uninvoiced;

-- Undo_Line_Delivery
--    This will undo order line delivery.
PROCEDURE Undo_Line_Delivery (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   deliv_no_     IN NUMBER)
IS
   rec_        CUSTOMER_ORDER_TAB%ROWTYPE;
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   line_rec_ CUSTOMER_ORDER_LINE_API.Public_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   rec_ := Get_Object_By_Keys___(order_no_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('DELIV_NO', deliv_no_, attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_);
   line_rec_ := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);   
   
   IF (line_rec_.rowstate IN ('Delivered', 'PartiallyDelivered')) OR 
      ((line_rec_.rowstate = 'Invoiced') AND ((line_rec_.part_ownership IN ('CUSTOMER OWNED', 'SUPPLIER LOANED')) OR 
         (Cust_Ord_Customer_API.Get_Category_Db(line_rec_.customer_no) = Cust_Ord_Customer_Category_API.DB_INTERNAL))) THEN
      Undo_Line_Delivery__(info_, objid_, objversion_, attr_, 'DO');
   END IF;
   
   IF (rec_.rowstate != Get_Objstate(order_no_)) THEN
      Customer_Order_History_API.New(order_no_, Language_SYS.Translate_Constant(lu_name_, 'UNDOLINEDELIV: Undo order line delivery.'));
      -- Recalculate project cost after undo delivery
      IF (line_rec_.activity_seq IS NOT NULL) THEN
         Customer_Order_Line_API.Calculate_Cost_And_Progress(order_no_, line_no_, rel_no_, line_item_no_);
      END IF;
   END IF;
END Undo_Line_Delivery;

-----------------------------------------------------------------------------
-- Exists_Freight_Info_Lines
-- Checks whether there are invoiced customer order lines with freight information  
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Exists_Freight_Info_Lines (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR lines_with_freight_info IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    qty_invoiced > 0
      AND    default_addr_flag = 'Y'
      AND ( (freight_map_id IS NOT NULL) OR (zone_id IS NOT NULL) OR (freight_price_list_no IS NOT NULL) );
BEGIN
   OPEN lines_with_freight_info;
   FETCH lines_with_freight_info INTO found_;
   IF (lines_with_freight_info%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE lines_with_freight_info;
   RETURN (found_ = 1);
END Exists_Freight_Info_Lines;

-----------------------------------------------------------------------------
-- Has_Non_Def_Info_Lines
-- Checks whether there are customer order lines with Default info flag unchecked
-- and same address as header.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Has_Non_Def_Info_Lines (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   CURSOR non_def_info_lines IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB col, CUSTOMER_ORDER_TAB co
      WHERE  co.order_no = order_no_
      AND    col.order_no = co.order_no
      AND    col.addr_flag = co.addr_flag
      AND    col.default_addr_flag = 'N'
      AND    ((co.addr_flag = 'N' AND co.ship_addr_no = col.ship_addr_no) OR 
              (co.addr_flag = 'Y'))
      AND    col.rowstate NOT IN ('Delivered','Invoiced','Cancelled');
BEGIN
   OPEN non_def_info_lines;
   FETCH non_def_info_lines INTO found_;
   IF (non_def_info_lines%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE non_def_info_lines;
   RETURN found_;
END Has_Non_Def_Info_Lines;

-----------------------------------------------------------------------------
-- Has_Invoiced_Lines
--    Return TRUE if at least one line in the specified order has been
--    invoiced.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Has_Invoiced_Lines (
   order_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ NUMBER;
   CURSOR line_invoiced IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    qty_invoiced > 0;
BEGIN
   OPEN line_invoiced;
   FETCH line_invoiced INTO found_;
   IF (line_invoiced%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE line_invoiced;
   RETURN (found_ = 1);
END Has_Invoiced_Lines;

@UncheckedAccess
FUNCTION Exists_One_Tax_Code_Per_Line(
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   ret_     VARCHAR2(5) := Fnd_Boolean_API.DB_TRUE;
   check_line_    NUMBER;
   check_charge_  NUMBER;
   CURSOR check_lines IS
      SELECT 1
      FROM   customer_order_line_tab col
      WHERE  col.order_no = order_no_
      AND    col.rowstate    != 'Cancelled'
      AND    col.line_item_no <= 0
      AND    (col.tax_calc_structure_id IS NOT NULL OR 
              decode((SELECT count(sti.tax_item_id) 
                      FROM   source_tax_item_base_pub sti
                      WHERE  sti.source_ref1 = col.order_no
                      AND    sti.source_ref2 = col.line_no
                      AND    sti.source_ref3 = col.rel_no
                      AND    sti.source_ref4 = TO_CHAR(col.line_item_no)
                      AND    sti.source_ref5  = '*'
                      AND    sti.source_ref_type_db = Tax_Source_API.DB_CUSTOMER_ORDER_LINE),1,1,2) != 1);   
   
   CURSOR check_charges IS
      SELECT 1
      FROM   customer_order_charge_tab col
      WHERE  col.order_no = order_no_
      AND    (col.tax_calc_structure_id IS NOT NULL OR 
              decode((SELECT count(sti.tax_item_id) 
                      FROM   source_tax_item_base_pub sti
                      WHERE  sti.source_ref1 = col.order_no
                      AND    sti.source_ref2 = col.sequence_no
                      AND    sti.source_ref_type_db = Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE),1,1,2) != 1);   
BEGIN
   OPEN check_lines;
   FETCH check_lines INTO check_line_;
    OPEN check_charges;
    FETCH check_charges INTO check_charge_;
      IF (check_lines%FOUND OR check_charges%FOUND) THEN
         ret_ := Fnd_Boolean_API.DB_FALSE;
      END IF;
    CLOSE check_charges;
   CLOSE check_lines;
   RETURN ret_;
END Exists_One_Tax_Code_Per_Line;

------------------------------------------------------------------------------------------
-- All_Lines_Expctr
--   all_lines_expctr_ will be true if all lines of the specified CO is export controlled.
--   connected_ will be true if at least one of those lines is license connected.
------------------------------------------------------------------------------------------
PROCEDURE All_Lines_Expctr(
   all_lines_expctr_ OUT VARCHAR2,
   connected_        OUT VARCHAR2,
   order_no_         IN VARCHAR2 )
IS
   exp_license_connect_id_  NUMBER;
   licensed_order_type_     VARCHAR2(25);
   line_count_              NUMBER := 0;
   CURSOR get_order_lines IS
      SELECT line_no, rel_no, line_item_no, 
             demand_code, demand_order_ref1, 
             demand_order_ref2, demand_order_ref3
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no = order_no_
      AND    rowstate IN ('Released', 'Reserved');
   
BEGIN
   $IF Component_Expctr_SYS.INSTALLED $THEN
      IF (Customer_Order_Flow_API.Get_License_Enabled(order_no_, 'INTERACT_CUST_ORD') = 'TRUE') THEN
         line_count_       := 1;
         all_lines_expctr_ := 'TRUE';
         connected_        := 'FALSE';
         FOR rec_ IN get_order_lines LOOP
            licensed_order_type_ := Customer_Order_Line_API.Get_Expctr_License_Order_Type(rec_.demand_code, rec_.demand_order_ref1, rec_.demand_order_ref2, rec_.demand_order_ref3);
            exp_license_connect_id_ := Exp_License_Connect_Head_API.Get_Connect_Id_From_Ref(licensed_order_type_, order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no);
            IF exp_license_connect_id_ IS NULL THEN
               all_lines_expctr_ := 'FALSE';
               EXIT;            
            END IF;    
            line_count_ := line_count_ + 1;
         END LOOP;         
      END IF;
      IF line_count_ > 1 THEN
         FOR rec_ IN get_order_lines LOOP
            IF Exp_License_Connect_Head_API.Get_Objstate_By_Ref(order_no_, rec_.line_no, rec_.rel_no, rec_.line_item_no, licensed_order_type_) = 'Approved' THEN 
               connected_ := 'TRUE';
               EXIT;
            END IF;
         END LOOP;
      END IF;
   $ELSE
      NULL;
   $END   
END All_Lines_Expctr;

-- Get_Tax_Liability_Type_Db
--   Returns tax liability type db value
@UncheckedAccess
FUNCTION Get_Tax_Liability_Type_Db (
   order_no_     IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Tax_Liability_API.Get_Tax_Liability_Type_Db(Get_Tax_Liability(order_no_), Customer_Order_Address_API.Get_Address_Country_Code(order_no_));
END Get_Tax_Liability_Type_Db;

-----------------------------------------------------------------------------
-- Has_Demand_Code_Lines
--    Returns TRUE if at least one line in the specified order has the
--    required demand code.
-----------------------------------------------------------------------------
FUNCTION Has_Demand_Code_Lines (
   order_no_    IN VARCHAR2,
   demand_code_ IN VARCHAR2) RETURN VARCHAR2
IS
   found_ NUMBER;
   CURSOR get_lines IS
      SELECT 1
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE  order_no    = order_no_
      AND    demand_code = demand_code_;
BEGIN
   OPEN  get_lines;
   FETCH get_lines INTO found_;
   CLOSE get_lines;
   
   IF found_  = 1 THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Has_Demand_Code_Lines;

-- Get_Tax_Liability_Country_Db
--   This method Returns the effective tax liability country which should be used for fetching the
--   tax liability details. i.e if there is no tax registration for the
--   delivery country then use the supply country for the tax registration.
@UncheckedAccess
FUNCTION Get_Tax_Liability_Country_Db(
   order_no_                 IN VARCHAR2,
   delivery_country_db_      IN VARCHAR2,
   tax_liability_            IN VARCHAR2) RETURN VARCHAR2
IS
   company_                 VARCHAR2(20);
   supply_country_db_       VARCHAR2(2);
   order_rec_               Customer_Order_API.Public_Rec;
   site_date_               DATE;
   tax_liability_type_db_   VARCHAR2(20);
       
BEGIN
   order_rec_ := Customer_Order_API.Get(order_no_);
   company_ := Site_API.Get_Company(order_rec_.contract);
   supply_country_db_ := order_rec_.supply_country;
   site_date_ := Site_API.Get_Site_Date(order_rec_.contract);
   tax_liability_type_db_ := Tax_Liability_API.Get_Tax_Liability_Type_Db(tax_liability_, delivery_country_db_);

   IF tax_liability_type_db_ != 'EXM' AND Tax_Liability_Countries_API.Check_Valid_Info_Exist(company_, delivery_country_db_, site_date_) = 'TRUE' THEN
      RETURN delivery_country_db_;
   ELSE
      RETURN supply_country_db_;
   END IF;   
END Get_Tax_Liability_Country_Db;

FUNCTION Check_Diff_Delivery_Info (
   order_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_             NUMBER;
   diff_del_info_    VARCHAR2(5);
   CURSOR get_del_info IS
      SELECT 1
      FROM CUSTOMER_ORDER_LINE_TAB
      WHERE order_no = order_no_
      AND default_addr_flag = 'N';
BEGIN
   OPEN get_del_info;
   FETCH get_del_info INTO temp_;
   IF (get_del_info%FOUND) THEN
      diff_del_info_ := 'TRUE';
   ELSE
      diff_del_info_ := 'FALSE';
   END IF;
   CLOSE get_del_info;
   RETURN diff_del_info_;
END Check_Diff_Delivery_Info;

PROCEDURE Modify_Main_Representative(
   order_no_ IN VARCHAR2,
   rep_id_       IN VARCHAR2,
   remove_main_  IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE )
IS
   oldrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   attr_       VARCHAR2(32000);
   objid_      CUSTOMER_ORDER.objid%TYPE;
   objversion_ CUSTOMER_ORDER.objversion%TYPE;
   found_      NUMBER;
   indrec_     Indicator_Rec;
 
   CURSOR check_main_rep IS
      SELECT count(*)
      FROM CUSTOMER_ORDER_TAB
      WHERE order_no = order_no_
      AND main_representative_id = rep_id_ ;     
BEGIN   
   $IF Component_Rmcom_SYS.INSTALLED $THEN
      oldrec_ := Lock_By_Keys___(order_no_);
      Client_SYS.Clear_Attr(attr_);      
      
      IF remove_main_ = Fnd_Boolean_API.DB_FALSE THEN
         Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', rep_id_, attr_);
      ELSE
         Client_SYS.Add_To_Attr('MAIN_REPRESENTATIVE_ID', '', attr_); 
      END IF;

      OPEN check_main_rep;
      FETCH check_main_rep INTO found_;
      CLOSE check_main_rep;
      IF (remove_main_ = Fnd_Boolean_API.DB_FALSE AND found_ = 0) OR (remove_main_ = Fnd_Boolean_API.DB_TRUE AND found_ = 1) THEN 
         newrec_ := oldrec_;
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);   
      END IF;
   $ELSE
      NULL;   
   $END
END Modify_Main_Representative;

PROCEDURE Check_Edit_Allowed(
   order_no_ IN VARCHAR2 ) 
IS
BEGIN
   IF (Get_Objstate(order_no_) = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'CLOSEDORDER: Closed order may not be changed.');
   END IF;
END Check_Edit_Allowed;


-- This method is used by DataCaptDeliverCo
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   contract_                   IN VARCHAR2,
   order_no_                   IN VARCHAR2,
   customer_no_                IN VARCHAR2,
   priority_                   IN NUMBER,
   forward_agent_id_           IN VARCHAR2,
   route_id_                   IN VARCHAR2,
   wanted_delivery_date_       IN DATE,
   order_type_                 IN VARCHAR2,
   coordinator_                IN VARCHAR2,
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2,
   sql_where_expression_       IN VARCHAR2 DEFAULT NULL )
IS
   TYPE Get_Lov_Values IS REF CURSOR;
   get_lov_values_              Get_Lov_Values;
   stmt_                        VARCHAR2(6000);
   lov_value_tab_               Lov_Value_Tab;
   lov_item_description_        VARCHAR2(200);
   session_rec_                 Data_Capture_Common_Util_API.Session_Rec;
   lov_row_limitation_          NUMBER;
   exit_lov_                    BOOLEAN := FALSE;
   local_customer_no_           customer_order_tab.customer_no%TYPE;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      session_rec_        := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('customer_order_tab', column_name_);

      stmt_ := 'SELECT ' || column_name_ 
           || ' FROM customer_order_tab 
                WHERE contract = :contract_';
      IF order_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :order_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND order_no = :order_no_';
      END IF;
      IF customer_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :customer_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND customer_no = :customer_no_';
      END IF;
      IF order_type_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :order_type_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND order_id = :order_type_';
      END IF;
      IF coordinator_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :coordinator_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND authorize_code = :coordinator_';
      END IF;
      IF route_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND route_id is NULL AND :route_id_ IS NULL';
      ELSIF route_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :route_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND route_id = :route_id_';
      END IF;
      IF forward_agent_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
      ELSIF forward_agent_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
      END IF;
      IF priority_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND priority is NULL AND :priority_ IS NULL';
      ELSIF priority_ = -1 THEN
         stmt_ := stmt_ || ' AND :priority_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND priority = :priority_';
      END IF;
             
      IF wanted_delivery_date_ IS NOT NULL THEN 
         stmt_ := stmt_ || ' AND wanted_delivery_date = DATE ''' || to_char(wanted_delivery_date_ , Client_SYS.trunc_date_format_ ) || '''';
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
       stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' ORDER BY ' || column_name_ || ' ASC';
      
      @ApproveDynamicStatement(2017-07-12,KHVESE)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           order_no_,
                                           customer_no_,
                                           order_type_,
                                           coordinator_, 
                                           route_id_,
                                           forward_agent_id_,
                                           priority_;

 
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
         -- Since we are using a more advanced order by now we cannot use DISTINCT in the select 
         -- so we have now to remove all duplicate values from the LOV collection.
         --lov_value_tab_ := Remove_Duplicate_Lov_Values___(lov_value_tab_);
      END IF;
      CLOSE get_lov_values_;
      
      IF (lov_value_tab_.COUNT > 0) THEN
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK 
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (column_name_ = 'ORDER_NO') THEN
                  local_customer_no_    :=  Customer_Order_API.Get_Customer_No(lov_value_tab_(i));
                  lov_item_description_ :=  local_customer_no_;
                  IF lov_item_description_ IS NOT NULL AND 
                     (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_CUSTOMER_NAME'))) THEN
                        lov_item_description_ := lov_item_description_ || ' | ' ||  Cust_Ord_Customer_API.Get_Name(local_customer_no_);
                  END IF;
                  IF (Fnd_Boolean_API.Evaluate_Db(Data_Capture_Config_Detail_API.Get_Enabled_Db(session_rec_.capture_process_id, session_rec_.capture_config_id, 'DISPLAY_RECEIVER_ADDRESS_NAME'))) THEN
                     IF lov_item_description_ IS NOT NULL THEN
                        lov_item_description_ := lov_item_description_ || ' | ';
                     END IF;
                     lov_item_description_ := lov_item_description_ || Customer_Info_Address_API.Get_Name(local_customer_no_, Customer_Order_API.Get_Ship_Addr_No(lov_value_tab_(i)));
                  END IF;
                  
               ELSIF (column_name_ = 'CUSTOMER_NO') THEN
                  lov_item_description_ :=  Cust_Ord_Customer_API.Get_Name(lov_value_tab_(i));
               ELSIF (column_name_ = 'FORWARD_AGENT_ID') THEN
                  lov_item_description_ :=  Forwarder_Info_API.Get_Name(lov_value_tab_(i));
               ELSIF (column_name_ = 'ROUTE_ID') THEN
                  lov_item_description_ :=  Delivery_Route_API.Get_Description(lov_value_tab_(i));
               ELSIF (column_name_ = 'ORDER_ID') THEN
                  lov_item_description_ :=  Cust_Order_Type_API.Get_Description(lov_value_tab_(i));
               ELSIF (column_name_ = 'AUTHORIZE_CODE') THEN
                  lov_item_description_ :=  ORDER_COORDINATOR_API.Get_Name(lov_value_tab_(i));
               END IF;
            END IF;
            Data_Capture_Session_Lov_API.New(exit_lov_              => exit_lov_,
                                             capture_session_id_    => capture_session_id_,
                                             lov_item_value_        => lov_value_tab_(i),
                                             lov_item_description_  => lov_item_description_,
                                             lov_row_limitation_    => lov_row_limitation_,    
                                             session_rec_           => session_rec_);
            EXIT WHEN exit_lov_;
         END LOOP;
      END IF;
   $ELSE
      NULL;   
   $END
END Create_Data_Capture_Lov;


-- This method is used by DataCaptDeliverCo
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   contract_               IN VARCHAR2,
   order_no_               IN VARCHAR2,
   customer_no_            IN VARCHAR2,
   priority_               IN NUMBER,
   forward_agent_id_       IN VARCHAR2,
   route_id_               IN VARCHAR2,
   wanted_delivery_date_   IN DATE,
   order_type_             IN VARCHAR2,
   coordinator_            IN VARCHAR2,
   column_name_            IN VARCHAR2,
   sql_where_expression_   IN VARCHAR2 DEFAULT NULL  ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_   Get_Column_Value;
   stmt_                VARCHAR2(4000);
   unique_column_value_ VARCHAR2(50);
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab; 
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN

      -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
      Assert_SYS.Assert_Is_View_Column('customer_order_tab', column_name_);

      stmt_ := 'SELECT DISTINCT ' || column_name_ || ' 
                FROM  customer_order_tab
                WHERE contract = :contract_ ';
      IF order_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :order_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND order_no = :order_no_';
      END IF;
      IF customer_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :customer_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND customer_no = :customer_no_';
      END IF;
      IF order_type_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :order_type_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND order_id = :order_type_';
      END IF;
      IF coordinator_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :coordinator_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND authorize_code = :coordinator_';
      END IF;
      IF route_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND route_id is NULL AND :route_id_ IS NULL';
      ELSIF route_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :route_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND route_id = :route_id_';
      END IF;
      IF forward_agent_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
      ELSIF forward_agent_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
      END IF;
      IF priority_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND priority is NULL AND :priority_ IS NULL';
      ELSIF priority_ = -1 THEN
         stmt_ := stmt_ || ' AND :priority_ = -1';
      ELSE
         stmt_ := stmt_ || ' AND priority = :priority_';
      END IF;

      IF wanted_delivery_date_ IS NOT NULL THEN 
         stmt_ := stmt_ || ' AND wanted_delivery_date = DATE ''' || to_char(wanted_delivery_date_ , Client_SYS.trunc_date_format_ ) || '''';
      END IF;

      IF (sql_where_expression_ IS NOT NULL) THEN
         stmt_ := stmt_ || ' AND ' || sql_where_expression_;
      END IF;

      stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

      @ApproveDynamicStatement(2017-07-12,KHVESE)
      OPEN get_column_values_ FOR stmt_ USING contract_,
                                              order_no_,
                                              customer_no_,
                                              order_type_,
                                              coordinator_, 
                                              route_id_,
                                              forward_agent_id_,
                                              priority_;
      FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
      IF (column_value_tab_.COUNT = 1) THEN
         unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
      END IF;
      CLOSE get_column_values_;

      RETURN unique_column_value_;
   $ELSE
      RETURN NULL;   
   $END
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptDeliverCo
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   contract_               IN VARCHAR2,
   order_no_               IN VARCHAR2,
   customer_no_            IN VARCHAR2,
   priority_               IN NUMBER,
   forward_agent_id_       IN VARCHAR2,
   route_id_               IN VARCHAR2,
   wanted_delivery_date_   IN DATE,
   order_type_             IN VARCHAR2,
   coordinator_            IN VARCHAR2,
   column_name_            IN VARCHAR2,
   column_value_           IN VARCHAR2,
   column_description_     IN VARCHAR2,
   date_type_handling_     IN BOOLEAN DEFAULT FALSE,
   sql_where_expression_   IN VARCHAR2 DEFAULT NULL  ) 
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_       Check_Exist;
   stmt_                VARCHAR2(4000);
   dummy_               NUMBER;
   exist_               BOOLEAN := FALSE;
BEGIN

   -- extra column check to be sure we have no risk for sql injection into decoded_column_name_/data_item_id
   Assert_SYS.Assert_Is_View_Column('customer_order_tab', column_name_);

   stmt_ := 'SELECT  1
             FROM    customer_order_tab
             WHERE   contract = :contract_ ';
   IF order_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :order_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND order_no = :order_no_';
   END IF;
   IF customer_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :customer_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND customer_no = :customer_no_';
   END IF;
   IF order_type_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :order_type_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND order_id = :order_type_';
   END IF;
   IF coordinator_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :coordinator_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND authorize_code = :coordinator_';
   END IF;
   IF route_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND route_id is NULL AND :route_id_ IS NULL';
   ELSIF route_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :route_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND route_id = :route_id_';
   END IF;
   IF forward_agent_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND forward_agent_id is NULL AND :forward_agent_id_ IS NULL';
   ELSIF forward_agent_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :forward_agent_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND forward_agent_id = :forward_agent_id_';
   END IF;
   IF priority_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND priority is NULL AND :priority_ IS NULL';
   ELSIF priority_ = -1 THEN
      stmt_ := stmt_ || ' AND :priority_ = -1';
   ELSE
      stmt_ := stmt_ || ' AND priority = :priority_';
   END IF;

   IF wanted_delivery_date_ IS NOT NULL THEN 
      stmt_ := stmt_ || ' AND wanted_delivery_date = DATE ''' || to_char(wanted_delivery_date_ , Client_SYS.trunc_date_format_ ) || '''';
   END IF;

   IF (sql_where_expression_ IS NOT NULL) THEN
      stmt_ := stmt_ || ' AND ' || sql_where_expression_;
   END IF;


   IF date_type_handling_ THEN 
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = DATE ''' || column_value_ || ''' ) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
      @ApproveDynamicStatement(2017-07-12,KHVESE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          order_no_,
                                          customer_no_,
                                          order_type_,
                                          coordinator_, 
                                          route_id_,
                                          forward_agent_id_,
                                          priority_,
                                          column_value_;
   ELSE 
      stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
      @ApproveDynamicStatement(2017-07-12,KHVESE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          order_no_,
                                          customer_no_,
                                          order_type_,
                                          coordinator_, 
                                          route_id_,
                                          forward_agent_id_,
                                          priority_,
                                          column_value_,
                                          column_value_;
   END IF;
             
   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (column_name_ = 'ORDER_NO' OR order_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NODATAINPROCESS: :P1 :P2 does not exist in the context of the entered data and this process.', column_description_, column_value_);-- TO_CHAR(to_date(column_value_, Client_SYS.date_format_),Client_SYS.trunc_date_format_));
      ELSE
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST: The value :P1 does not exist for Customer Order :P2.', column_value_, order_no_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;


PROCEDURE Refresh_Tax_On_Co_Release (
   order_no_     IN VARCHAR2)
IS
   CURSOR get_order_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'Invoiced')
      AND   line_item_no <= 0
      AND   order_no = order_no_;
   
   CURSOR get_charge_lines IS
      SELECT charge.sequence_no
      FROM CUSTOMER_ORDER_CHARGE_TAB charge, CUSTOMER_ORDER_TAB ord
      WHERE ord.order_no = order_no_
      AND ord.rowstate != 'Cancelled' 
      AND ord.order_no = charge.order_no;
      
   company_                   VARCHAR2(20);
   external_tax_calc_method_  VARCHAR2(50);
   dummy_string_              VARCHAR2(100);   
BEGIN   
   company_                  := Site_API.Get_Company(Get_Contract(order_no_)); 
   external_tax_calc_method_ := Company_Tax_Control_API.Get_External_Tax_Cal_Method_Db(company_);

   -- gelr:br_external_tax_integration, added AVALARA_TAX_BRAZIL
   IF (external_tax_calc_method_ != External_Tax_Calc_Method_API.DB_NOT_USED) AND (Company_Tax_Control_API.Get_Refresh_Tax_On_Co_Relea_Db(company_) = Fnd_Boolean_API.DB_TRUE) THEN
      IF (external_tax_calc_method_ IN (External_Tax_Calc_Method_API.DB_AVALARA_SALES_TAX, External_Tax_Calc_Method_API.DB_AVALARA_TAX_BRAZIL)) THEN
         Fetch_External_Tax(order_no_);
      ELSE 
         FOR next_line_ IN get_order_lines LOOP
            Tax_Handling_Order_Util_API.Set_To_Default(dummy_string_, 
                                                      company_, 
                                                      Tax_Source_API.DB_CUSTOMER_ORDER_LINE, 
                                                      order_no_,
                                                      next_line_.line_no,
                                                      next_line_.rel_no,
                                                      next_line_.line_item_no, 
                                                      '*');

         END LOOP;

         FOR next_line_ IN get_charge_lines LOOP
            Tax_Handling_Order_Util_API.Set_To_Default(dummy_string_, 
                                                      company_, 
                                                      Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE, 
                                                      order_no_,
                                                      next_line_.sequence_no,
                                                      '*',
                                                      '*', 
                                                      '*');

         END LOOP;
      END IF;
   END IF;   
END Refresh_Tax_On_Co_Release;

PROCEDURE Order_Lines_Available_To_Copy (
   lines_available_          OUT VARCHAR2,
   order_no_             IN  VARCHAR2,
   order_lines_          IN  VARCHAR2,
   rental_order_lines_   IN  VARCHAR2)
IS
   CURSOR get_order_line IS
   SELECT 1
   FROM   CUSTOMER_ORDER_LINE_TAB
   WHERE  order_no = order_no_
   AND    (demand_code NOT IN ('PO', 'DO', 'CRE', 'CRO', 'WO', 'IPD', 'IPT') OR demand_code IS NULL)
   AND    supply_code NOT IN ('MRO')
   AND    ((rental = 'FALSE' AND (NVL(order_lines_, 'FALSE') = 'TRUE')) OR
           (rental = 'TRUE' AND (NVL(rental_order_lines_, 'FALSE') = 'TRUE')));
           
   dummy_ NUMBER;
BEGIN
   IF NOT(Check_Exist___(order_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'ORDERDOESNOOTEXIST: Customer Order :P1 does not exist.', order_no_);  
   END IF;
   
   OPEN get_order_line;
   FETCH get_order_line INTO dummy_;
   IF (get_order_line%FOUND) THEN
      lines_available_ := 'TRUE';
   ELSE
      lines_available_ := 'FALSE';
   END IF;
   CLOSE get_order_line;
END Order_Lines_Available_To_Copy;

-----------------------------------------------------------------------------
-- Get_Default_Order_Type
-- Returns order_type according to below hierarchy. 
-- Site and customer combination 
-- Site 
-- Customer
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Default_Order_Type (
   contract_     IN VARCHAR2,
   customer_no_  IN VARCHAR2  ) RETURN VARCHAR2
IS
   order_type_      VARCHAR2(3);
   site_cust_rec_   Message_Defaults_Per_Cust_API.Public_Rec;
   site_rec_        Site_Discom_Info_API.Public_Rec;   
BEGIN
   site_cust_rec_ := Message_Defaults_Per_Cust_API.Get(contract_, customer_no_);
   site_rec_      := Site_Discom_Info_API.Get(contract_);   
                        
   -- Get order_id from site/customer, site, customer
   order_type_ := NVL(site_cust_rec_.order_id, site_rec_.order_id);
   order_type_ := NVL(order_type_, Cust_Ord_Customer_API.Get_Order_Id(customer_no_));

   RETURN order_type_;
END Get_Default_Order_Type;

FUNCTION  Calculate_Totals (
   order_no_   IN  VARCHAR2) RETURN Calculated_Totals_Arr PIPELINED
IS
   rec_                Calculated_Totals_Rec;
   total_cost_         NUMBER;
   total_contribution_ NUMBER;
BEGIN
   Customer_Order_API.Get_Ord_Line_Totals__(rec_.order_line_total_base, 
                                            rec_.order_line_total_curr, 
                                            rec_.order_weight, 
                                            rec_.order_volume,
                                            total_cost_, 
                                            total_contribution_,
                                            rec_.order_line_tax_total_curr,
                                            rec_.order_line_gross_total_curr,
                                            rec_.additional_discount_curr,
                                            order_no_);
                                            
   rec_.total_charge_base       := Customer_Order_API.Get_Total_Base_Charge__(order_no_);
   rec_.total_charge_curr       := Customer_Order_API.Get_Total_Sale_Charge__(order_no_);
   rec_.total_charge_tax_curr   := Customer_Order_API.Get_Tot_Charge_Sale_Tax_Amt(order_no_);
   rec_.total_charge_gross_curr := Customer_Order_API.Get_Total_Sale_Charge_Gross__(order_no_);
   
   rec_.total_amount_base       := rec_.order_line_total_base + rec_.total_charge_base;
   rec_.total_amount_curr       := rec_.order_line_total_curr + rec_.total_charge_curr;
   rec_.toatal_tax_amount_curr  := rec_.order_line_tax_total_curr + rec_.total_charge_tax_curr;
   rec_.total_gross_amount_curr := rec_.order_line_gross_total_curr + rec_.total_charge_gross_curr;
   
   total_cost_                  := Customer_Order_API.Get_Total_Cost(order_no_);
   rec_.total_contribution_base := Customer_Order_API.Get_Total_Contribution(order_no_);
   IF (total_cost_ + rec_.total_contribution_base != 0) THEN
      rec_.total_contribution_percent := (rec_.total_contribution_base / (rec_.total_contribution_base + total_cost_)) * 100;
   ELSE
      rec_.total_contribution_percent := 0;
   END IF;
   
   rec_.adjusted_weight_gross_in_charges := NVL(Customer_Order_API.Get_Adj_Weight_In_Charges (order_no_), 0);
   rec_.adjusted_volume_in_charges       := NVL(Customer_Order_API.Get_Adj_Volume_In_Charges(order_no_), 0);
   PIPE ROW (rec_);                                                                                     
END Calculate_Totals;


PROCEDURE Modify_Tax_Id_Validated_Date (
   order_no_          IN VARCHAR2)
IS   
   oldrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   newrec_     CUSTOMER_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN   
   oldrec_ := Lock_By_Keys___(order_no_);
   newrec_ := oldrec_;
   Client_SYS.Add_To_Attr('TAX_ID_VALIDATED_DATE', CURRENT_DATE, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Tax_Id_Validated_Date;

-------------------------------------------------------------------
-- Fetch_External_Tax
--    Fetches tax information from external tax system.
--------------------------------------------------------------------
PROCEDURE Fetch_External_Tax (
   order_no_          IN VARCHAR2,
   address_changed_   IN VARCHAR2 DEFAULT 'FALSE',
   include_charges_   IN VARCHAR2 DEFAULT 'TRUE' )
IS
   i_                      NUMBER := 1;
   company_                VARCHAR2(20);
   line_source_key_arr_    Tax_Handling_Util_API.source_key_arr;
   
   CURSOR get_order_lines IS
      SELECT line_no, rel_no, line_item_no
      FROM   CUSTOMER_ORDER_LINE_TAB
      WHERE rowstate NOT IN ('Cancelled', 'Invoiced')
      AND   line_item_no <= 0
      AND   order_no = order_no_
      AND ( address_changed_ = 'FALSE'  OR default_addr_flag = 'Y' );
      
   CURSOR get_charge_lines IS
      SELECT charge.sequence_no
      FROM CUSTOMER_ORDER_CHARGE_TAB charge, CUSTOMER_ORDER_TAB ord
      WHERE ord.order_no = order_no_
      AND ord.rowstate != 'Cancelled' 
      AND ord.order_no = charge.order_no
      AND charge.charged_qty > charge.invoiced_qty
      AND ( charge.line_no IS NULL  
          OR (address_changed_ = 'FALSE' 
          OR (charge.order_no, charge.line_no, charge.rel_no, charge.line_item_no ) IN (SELECT order_no, line_no, rel_no, line_item_no
                                                                                          FROM   CUSTOMER_ORDER_LINE_TAB line
                                                                                          WHERE  line.order_no = order_no_
                                                                                          AND   default_addr_flag = 'Y' )));
   
BEGIN
   company_                  := Site_API.Get_Company(Get_Contract(order_no_)); 
   line_source_key_arr_.DELETE;
  
   FOR rec_ IN get_order_lines LOOP
      line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_LINE,
                                                                              order_no_, 
                                                                              rec_.line_no, 
                                                                              rec_.rel_no, 
                                                                              rec_.line_item_no, 
                                                                              '*',                                                                  
                                                                              attr_ => NULL);

     i_ := i_ + 1;
   END LOOP;

   IF include_charges_ = 'TRUE' THEN 
      FOR rec_ IN get_charge_lines LOOP
         line_source_key_arr_(i_) := Tax_Handling_Util_API.Create_Source_Key_Rec(Tax_Source_API.DB_CUSTOMER_ORDER_CHARGE,
                                                                                 order_no_, 
                                                                                 rec_.sequence_no, 
                                                                                 '*', 
                                                                                 '*', 
                                                                                 '*',                                                                  
                                                                                 attr_ => NULL);

        i_ := i_ + 1;
      END LOOP;
   END IF;

   IF line_source_key_arr_.COUNT >= 1 THEN 
      Tax_Handling_Order_Util_API.Fetch_External_Tax_Info(line_source_key_arr_,
                                                          company_);
   END IF; 

   Customer_Order_History_Api.New(order_no_, Language_Sys.Translate_Constant(lu_name_,'EXTAXBUNDLECALL: External Taxes Updated'));
   
END Fetch_External_Tax;


-- gelr:disc_price_rounded, begin
FUNCTION Get_Discounted_Price_Rounded (
   order_no_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   disc_price_rounded_ BOOLEAN := FALSE;
   disc_price_round_   CUSTOMER_ORDER_TAB.disc_price_round%TYPE;
   use_price_incl_tax_ CUSTOMER_ORDER_TAB.use_price_incl_tax%TYPE;
   
   CURSOR get_disc_price_rounded IS
      SELECT disc_price_round, use_price_incl_tax
      FROM   CUSTOMER_ORDER_TAB
      WHERE  order_no = order_no_;
BEGIN
   OPEN get_disc_price_rounded;
   FETCH get_disc_price_rounded INTO disc_price_round_, use_price_incl_tax_;
   CLOSE get_disc_price_rounded;
   IF (disc_price_round_ = Fnd_Boolean_API.DB_TRUE) AND (use_price_incl_tax_ = Fnd_Boolean_API.DB_FALSE) THEN
      disc_price_rounded_ := TRUE;   
   END IF;
   RETURN  disc_price_rounded_;
END Get_Discounted_Price_Rounded;   
-- gelr:disc_price_rounded, end

------------------------------------------------------
-- Check_Delivery_Type
--   Checks if the delivery type is same for all customer order lines and charge lines in the customer order.
------------------------------------------------------
PROCEDURE Check_Delivery_Type(
   same_delivery_type_     OUT   VARCHAR2,
   delivery_type_          OUT   VARCHAR2,
   order_no_               IN    VARCHAR2,
   with_charges_           IN    VARCHAR2)
IS
   del_type_count_      NUMBER;
   del_type_            customer_order_line_tab.delivery_type%TYPE;
   
   CURSOR check_delivery_type IS
      SELECT COUNT(*) OVER(), delivery_type 
      FROM ( SELECT DISTINCT delivery_type 
             FROM (SELECT delivery_type
                   FROM customer_order_line_tab
                   WHERE order_no = order_no_
                   UNION ALL  
                   SELECT delivery_type
                   FROM customer_order_charge
                   WHERE with_charges_ = 'TRUE'
                   AND order_no = order_no_)); 
BEGIN
   OPEN check_delivery_type;
   FETCH check_delivery_type INTO del_type_count_, del_type_;
   CLOSE check_delivery_type;
   
   IF del_type_count_ = 1 THEN 
      same_delivery_type_ := 'TRUE';
      delivery_type_ := del_type_;
   ELSE
      same_delivery_type_ := 'FALSE';
   END IF;
      
END Check_Delivery_Type;

@IgnoreUnitTest TrivialFunction
@UncheckedAccess
FUNCTION Get_Tax_Id_Type (
   order_no_   IN VARCHAR2) RETURN VARCHAR2
IS
   company_             VARCHAR2(20);
   delivery_country_    VARCHAR2(2);
   tax_id_type_         VARCHAR2(10);
   header_rec_          Customer_Order_API.Public_Rec;   
BEGIN    
   header_rec_       := Customer_Order_API.Get(order_no_);
   company_          := Site_API.Get_Company(header_rec_.contract);
   delivery_country_ := Customer_Order_Address_API.Get_Country_Code(order_no_);
   
   tax_id_type_      :=  Tax_Handling_Order_Util_API.Fetch_And_Validate_Tax_Id(header_rec_.customer_no, header_rec_.bill_addr_no, company_, header_rec_.supply_country, delivery_country_);
   
   RETURN tax_id_type_;
END Get_Tax_Id_Type;
