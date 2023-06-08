-----------------------------------------------------------------------------
--
--  Logical unit: MaterialRequisLine
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210128  LEPESE  SC2020R1-12301, recuded number of PL method calls to same API with same keys. Done in Check_Update___,
--  210128          Validate_Proj_Connect___, Unissue and Check_Part_No__. Removed unused parameter unit_meas_ from Make_Requisition___.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  191003  SURBLK  Added Raise_Calendar_Error___ to handle error messages and avoid code duplication.
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  191212  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191212          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191212          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  190805  DiKuLk  Bug 149432(SCZ-6026), Modified Update_Intorder_Detail() to pass correct parameters to get qty_in_store_.
--  190512  LaThlk  Bug 146270(SCZ-4649), Introduced a function Lock_And_Get() to lock and get the MR Line.
--  181122  fandse  SCUXXW4-6340, Added overload method for cleaner interface for Aurena, a lot of obsolete parameters in the original Unissue method.
--  171113  DaZase  STRSC-8865, Added inv_barcode_validation_ parameter and handling of it in Record_With_Column_Value_Exist.
--  171006  LEPESE  STRSC-12433, Added call to Inv_Part_Stock_Reservation_API.Move_New_With_Transport_Task from Make_Line_Reservations.
--  171003  LEPESE  STRSC-12433, Added code to move reservation on transport task when stock taken from transport task, in Make_Line_Reservations.
--  170606  AyAmlk  APPUXX-11858, Added Get_Part_Unit_Meas() since the dynamic dependency cannot be handled in attribute fetch in projection files.
--  170515  niedlk  STRSC-7842, Added Change_Supply_Code method.
--  170417  SeJalk  STRSC-6651, modified Make_Requisition___ to pass null to unit_meas to Purchase requisition since it fetch the unit of measure correctly for inventory part.
--  170314  TiRalk  STRSC-6573, Modified Check_Part_No__ by removing error which is added by 58734, when the primary supplier is null 
--  170314          for non inventory parts and handled logic to get UoM properly when primary supplier is null.
--  170303  DilMlk  Bug 133558, Modified method call Handle_Activity_Seq___ by setting TRUE for replace_pre_posting_ parameter to replace pre postings with project pre postings if it has value.
--  160705  DAYJLK  LIM-7914, Replaced usage of Receipt_Inventory_Location_API with Receipt_Info_API in method Update_Intorder_Detail.
--  160623  Dinklk  APPUXX-1764, Added a public method New to save a new record from UXx page.
--  160321  KiSalk  Bug 127655, Modified Close__ not to raise error if connected PO line is cancelled and part_no is noninventory type.
--  160115  LEPESE  LIM-3742, changes in Make_Line_Reservations to facilitate optimized handling unit reservation. Now uses a version of
--  160115          Inventory_Part_In_Stock_API.Find_And_Reserve_Part which only needs to be called once, it returns a collection of stock records.
--  151104  DaZase  LIM-4281, Changed methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist so they now use 
--  151104          INVENTORY_PART_IN_STOCK_TOTAL instead of pub-view, added param column_value_nullable_ to Record_With_Column_Value_Exist.
--  150908  SHEWLK  Bug 124039, Used separate public cursors for Selective MRP - Get_Matreq_Demand_Cur and Full Site MRP - Get_Matreq_Demand_Cur_Site 
--  150908          to increase performance in Selective MRP.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150309  CPriLK  ANPJ-22, Removed the object_staus from project_connection_util_api related method calls.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150413  Chfose  LIM-1010, Fixed calls to Inventory_Part_In_Stock_API by including handling_unit_id.
--  150202  DaZase  PRSC-5642, Made some changes Create_Data_Capture_Lov, Record_With_Column_Value_Exist and Create_Data_Capture_Lov so this code match the one from WDC extension better.
--  141217  DaZase  PRSC-1611, Added extra column check in method Create_Data_Capture_Lov to avoid any risk of getting sql injection problems.
--  141215  UdGnlk  PRSC-4609, Added annotation Approve Dynamic Statement which were missing.
--  141125  BudKlk  Bug 119637, Added a new method Modify_Activity_Seq().
--  141125  Asawlk  Bug 119820, Added new parameter note_text_ to method Make_Requisition___() in order to pass note_text when creating purchase requisition lines.
--  141024  RuLiLk  Bug 113690, Modified Create_Data_Capture_Lov, Record_With_Column_Value_Exist to exclude PO created lines. But if PO is reserved, the line will be fetched. 
--  140925  BudKlk  Bug 118870, Modified Function Has_Any_Closed_Line() to get the attribute string from the message string as an array.
--  140108  DaZase  Bug 113690, Changed status_code, supply_code, planned_delivery_date to public attributes. Added methods Get_Status_Code,
--  140108          Get_Supply_Code, Get_Planned_Delivery_Date, Get_Column_Value_If_Unique, Create_Data_Capture_Lov, Check_Valid_Value.
--  140814  BudKlk  Bug 117301, Added a new Function Has_Any_Closed_Line() to check wheather any closed line exist.
--  140731  MeAblk  Removed activity_seq_ parameter from the method call Shortage_Demand_API.Calculate_Order_Shortage_Qty.
--  140704  SBalLK  Bug 117254, Modified Close__() method to validate pegged purchase order state before manually closed and removed validation of pegged
--  140704          purchase order from Check_Update___() method to close material requisition on automatic closing.
--  140612  Jeguse  PRPJ-539, Modified Handle_Activity_Seq___, Calculate_Cost_Progress and added Refresh_Connection
--  140430  ChJalk  PBSC-8539, Modified Check_Insert___ to reduce the number of method calls.
--  140429  ChJalk  PBSC-8539, Modified Check_Insert___ to decode order_class before calling Material_Requisition_API.Get_Status_Code.
--  140123  TiRalk  Bug 114454, Modified Unpack_Check_Update___() by moving code to Update___ since removing error messages NO_DUE_DATE_UPDATE, 
--  140123          NO_QTY_DUE_UPDATE and added information messages DUE_DATE_UPDATE, QTY_DUE_UPDATE allowing user to change due date and due qty in MR when  
--  140123          connected to a Purchase Order. Removed code of bug 101214 partially which became unnecessary to check calendar change after this bug correction.
--  130710  AyAmlk  Bug 111144, Modified Get_Part_No() to match the END statement name with the procedure/function name.
--  130530  PraWlk  Bug 109943, Modified Insert___() and Update___() by removing the call to Inventory_Part_In_Stock_API.Get_Inventory_Quantity()  
--  130807  ChJalk  TIBE-894, Reversed the previous correction of adding current info as an attribute string. Added current_info_ as an OUT parameter to Unpack_Check_Update___.
--  130807  ChJalk  TIBE-894, Removed the global variable info2_.
--  130807  ChJalk  TIBE-894, Removed the global variables inst_PurchaseOrder_, inst_PurchasePart_, inst_PurchaseOrderLine_,
--  130807          inst_PurchaseReqLinePart_, inst_Activity_, inst_Project_, inst_PurchaseReqUtil_ and inst_Level1ProjForecastUtil_.
--  130715  bhkalk  TIBE-2335 Added a parameter to Calendar_Changed() to resolve a scalability issue.
--  ------------------------------APPS 9-------------------------------------
--  130530  PraWlk  Bug 109943, Modified Modified Insert___() and Update___() by removing the call to Inventory_Part_In_Stock_API.Get_Inventory_Quantity()  
--  130530          on hand qty calculation logic moved to Order_Supply_Demand_API.Generate_Next_Level_Demands(). Also passed condition_code when calling it.
--  121010  MaEelk  Bug 103165, Modified Calendar_Changed() to raise an error if the due date is not within current calendar.
--  121005  MaEelk  Bug 101214, Modified calendar_changed(), Modify_Impl___()  and unpack_check_update___() methods to update 'Due Date' 
--  121005          when the distribution calendar change for the site.
--  120615  UdGnlk  Bug 102829, Modified Make_Line_Reservations() in order to passed the site date as the due date
--  120615          instead of original line due date because the reservation should be done based on present on hand availability.
--  120323  MaEelk  Corrected grammar in error message UNISSUENEG.
--  120314  SWiclk  Bug 101384, Modified Update___() by passing parameter server_data_change_ as TRUE when calling 
--  120314          Purchase_Req_Util_API.Modify_Line_Part in order to stop updating MR line back again when updating PR line.
--  120216  SWiclk  Bug 100658, Added method Modify_Qty_To_Be_Received() and modified Update___() in order to update qty_on_order
--  120216          when the qty on connected PR or PO is changed. Modified Unissue(), if the connected PO can provide more qty 
--  120216          for the returned qty then the qty_on_order will be updated appropriately.
--  120131  MeAblk  Bug 100867, Increased the length of the local variable supplier_ from 10 upto 20 in the procedure Check_Part_No__. 
--  120126  MaEelk  Added DATE/DATE format to DATE_ENTERED, DUE_DATE and PLANNED_DELIVERY_DATE  in view comments.
--  120126          Corrected the reference value of order_no in view comments.
--  111101  Darklk  Bug 99278, Modified the procedure Delete___ to remove the pre-accounting record associate
--  111101          with the current Material requisition line.
--  111027  NISMLK  SMA-285, Increased eng_chg_level_ length to VARCHAR2(6) in Make_Line_Reservations method.
--  110503  MatKse  Modified handle_Activity_Sec___ to pass along the mandatory sixth keyref parameter when removing project connection
--  110328  LEPESE  Modified test on qty_due to look at receipt_issue_serial_track = 'TRUE'.
--  110225  ChJalk  Moved 'User Allowed Site' Default Where condition from client to base view.
--  110207  GayDLK  Bug 95451, Changed the name of the parameter order_class_db_ to order_class_ of Mandatory_Pre_Posting_Complete()
--  110207          and assigned the value of it to order_class_db_ after encoding. 
--  110110  AwWelk  Bug 95008, Added Mandatory_Pre_Posting_Complete() method to check whether mandatory preposting 
--  110110          has been enabled and required code parts have been entered.
--  101021  PraWlk  Bug 92909, Modified method Check_Attribute_Modified___() by adding NVL() to nullable columns part_no, 
--  101021          note_text, external_id and activity_seq. 
--  101015  GayDLK  Bug 93374, Changed the place where the comments were added from the previous correction of the same bug.
--  101014  PraWlk  Bug 92909, Modified the previous correction done for bug 92909. Modified Update___() to close the MR 
--  101014          whenever Qty Due is updated to be equal to the Qty Issued and Modified error mssage COND_UPD_NOTALLOW.
--  101005  GayDLK  Bug 93374, Added a '-' as the Lov Flag for INFO column in MATERIAL_REQUIS_LINE_EXT view. 
--  100922  PraWlk  Bug 92909, Added new method Check_Attribute_Modified___(). Modified Unpack_Check_Update___() by calling  
--  100922          new method to avoid modifying of any other updateable attribute value when unreserving a MR line. 
--  100831  PraWlk  Bug 92656, Modified Unpack_Check_Update___() to avoid error for condition code for unreservation of a MR line.                
--  100505  KRPELK  Merge Rose Method Documentation.
--  100422  NuVelk  Merged TWIN PEAKS.
			--  091105  JANSLK  changed Handle_Activity_Seq___ and Calculate_Cost_And_Progress not to send revenue parameter when creating 
			--                  and refreshing project connection.
			--  091015  KaEllk  Added Update_Proj_Ms_Forecast___. Modified update to call Update_Proj_Ms_Forecast___.
			--  090925  THTHLK  Modified parameter in Project_Connection_UTIL_API.Create_Connection and Project_Connection_Util_API.Refresh_Activity_Info if used
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  091009  SaWjlk  Bug 85961, Modified Update___ by adding vendor_no in call to Purchase_Req_Util_API.Modify_Line_Part.
--  090930  ChFolk  Removed unused variables in the package.
--  --------------------------------- 14.0.0 ----------------------------------
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  091009  SaWjlk  Bug 85961, Modified Update___ by adding vendor_no in call to Purchase_Req_Util_API.Modify_Line_Part.
--  090803  Asawlk  Bug 84818, Modified condition to check whether its possible to change qty_due in Unpack_Check_Update___(). 
--  090713  MalLlk  Bug 83795, Modified views MATERIAL_REQUIS_LINE_DEMAND, MATERIAL_REQUIS_LINE_DEMAND_OE,  
--  090713          MATERIAL_REQUIS_LINE_MS and MATERIAL_REQUIS_LINE_EXT to set the value of qty_pegged to 0.
--  090708  SaWjlk  Bug 83518, Set the quantity returned value of the new record to zero when qty_shipped value of the old record
--  090708          is less than qty_shipped value of the new record. 
--  090629  SaWjlk  Bug 83518, Set the quantity returned value of the new record to zero when qty_shipped goes from zero to greater than zero 
--  090629          to avoid raising of the error message  DUE_GREATER_RETURN and removed the obsolete variable return_op_ and its implementation
--  090629          in the procedure Unpack_Check_Update___. 
--  090626  IrRalk  Bug 83861, Modified method Unpack_Check_Insert___ and Unpack_Check_Update___ to remove the error message
--  090626          when creating a material requisition line with supply code 'PURCHASE ORDER' for purchased-manufactured part.
--  090528  SaWjlk  Bug 83173, Removed the prog text duplications.
--  081201  NWeelk  Bug 78207, Modified Unpack_Check_Update___ to dissable closing of Material Requisition line when 
--  081201          the connected Purchase Order line is not closed.     
--  081027  NuVelk  Bug 77160, Modified Update___ to remove purchase requisition line 
--  081027          when MR goes from released to planed or stopped.
--  080922  NWeelk  Bug 77236, Modified Unpack_Check_Insert to avoid new lines being inserted to a closed requisition.
--  080805  Prawlk  Bug 75978, Modified Unpack_Check_Update to avoid changing due quantity when 
--  080805          the order line is already delivered.
--  080801  NiBalk  Bug 74688, Modified Update__ to to handle the demand changes occurs 
--  080801          due to changes in quantity due.
--  080703  Prawlk  Bug 73198, Decoded the project_id and activity_seq using supply_code in 
--  080703          MATERIAL_REQUIS_LINE_SHORTAGE view. 
--  080626  NiBalk  Bug 73200, Modified Make_Line_Reservations(), to create an entry in 
--  080626          resolve shortages window if there are stocks in other inventories.
--  080507  HoInlk  Bug 73185, Modified methods Handle_Activity_Seq___, Get_Activity_Info___
--  080507          and Calculate_Cost_And_Progress to support C90/C91 modifications.
--  080402  NuVelk  Bug 72577, added checks in Unpack_Check_Update___ that prevents
--  080402          the updating of DUE_DATE and QTY_DUE when a connected Purchase Order exists.
--  080319  NiBalk  Bug 69894, Modified Update__, to avoid unnecessary calls to refresh project activity costs.
--  080123  NuVelk  Bug 70046, Modified  Insert___ to allow the creation of a PR only when MR is in released
--  080123          state. Also made corrections to Update___ so that a connected PR Line is deleted, when  
--  080123          the MR goes to status Planned. Also changed Modify_Supply_Code___ by moving some
--  080123          code to Material_Requis_Pur_Order_API.Remove_Purchase_Link___
--  080110  LaNilk  Bug 69475, Modified view MATERIAL_REQUIS_LINE_MS to stop releasing consumed forecast when customer order is reserved.
--  071211  NuVelk  Bug 69785, Modified method Insert___ by removing unnecessary call to 
--  071211          Material_Requis_Type_API.Decode function for parameter newrec_.order_class
--  071129  HoInlk  Bug 69631, Modified Update___ to not activate connected purchase requisition when quantity due is changed.
--  070918  MaJalk  Added activity_seq_ to call Shortage_Demand_API.Calculate_Order_Shortage_Qty at Make_Line_Reservations. 
--  070814  WaJalk  Bug 66465, Modified view MATERIAL_REQUIS_LINE_MS, reduced qty_assigned from qty_due.
--  070808  NaLrlk  Added General_SYS.Init_Method for Get_Project_Cost_Element.
--  070802  NuVelk  Bug 64890, Added method Is_Closed.
--  070711  ChBalk  Bug 65250, Modified method Unissue to add a parameter catch_qty_unissue_ and pass that
--  070711          value as an in parameter to the method call Inventory_Part_In_Stock_API.Unissue_Part.
--  070706  RoJalk  Bug 65378, Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___
--  070706          to disallow non integer values for qty_due when part is serial tracked.
--  070627  DAYJLK  Project Enterprise Merge.
--  070529  WaJalk  Bug 64896, Modified procedures Unpack_Check_Update___  and Calendar_Changed, to avoid errors when
--  070529          generating calendar if new non-working day is added and there is reserved (or partially delivered)
--  070529          material requisition line with due date falling on this date.
--  070328  Kaellk  Added parameter project_id to cursor Get_Proj_Matreq_Demand_Cur
--  061221  NuVelk  Bug 62196, Mdified method Delete___ in order to Change the Status of material requisition to
--  061221          Closed only if material requisition lines are exist and all those lines are in Closed state.
--  060818  SaRalk  Removed all Hints in order supply demand views.
--  060817  KaDilk  Reverse the removal of public cursor changes done.
--  060727  RoJalk  Centralized Part Desc - Use Inventory_Part_API.Get_Description.
--  060801  NaWilk  Replaced PART_CATALOG_PUB with INVENTORY_PART_TAB.
--  060719  KaDilk  Added function FUNCTION Get_Matreq_Demand.
--  060619  HaPulk  Bug 58734, Added Error message in Check_Part_No__ when supplier is Null.
--  060619  MoNilk  Bug 58737, Modified Make_Requisition___ to fetch internal_destination and destination_id
--  060619          by calling Material_Requisition_API.Get().
--  060607  SuSalk  Bug 58459, Modified procedure, Modify_Arrival.
--  060524  JOHESE  Added column project_sourced to MATERIAL_REQUIS_LINE_SHORTAGE
--  060424  JOHESE  Added columns project_id and activity_seq to view MATERIAL_REQUIS_LINE_SHORTAGE
--  060418  NaLrlk  Enlarge Identity - Changed view comments.
--  ------------------------- 13.4.0 -----------------------------------------
--  060306  IsWilk  Compare with the order_class_db instead of the order_class_ in PROCEDURE Update_Intorder_Detail.
--  060306  KeFelk  Added CURSOR Get_Proj_Matreq_Demand_Cur body definition.
--  060125  ShOflk  Bug 55559, Modified attribute qty_returned from private to public,Modified methods Update___
--  060125          and Unpack_Check_Update___, and added method Get_Qty_Returned.
--  060124  NiDalk  Added Assert safe annotation.
--  060120  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  060119  JOHESE  Added check in Make_Line_Reservations to prevent reservations from other activities in the same project when not allowed
--  051109  MaHplk  Changed referecnce site_public to user_allowed_site_pub.
--  051019  GeKalk  Modified Validate_Proj_Connect___ to give a proper error message when connecting objcets to an activity
--  051019          which is not in released state.
--  050920  NiDalk  Removed unused variables.
--  050915  AnLaSe  Replaced material_used by calling Mpccom_Transaction_API.Get_Activity_Cost_By_Status instead of fetching inventory value in
--                  method Get_Activity_Info___.
--  050815  VeMolk  Bug 50869, Modified the calls to the method Inventory_Part_In_Stock_API.Make_Onhand_Analysis in Make_Line_Reservations.
--  050509  Asawlk  Bug 50519, Passed value to new parameter CONTRACT when calling
--  050509          Pre_Accounting_API.Copy_Pre_Accounting() inside Insert___().
--  050418  MaEelk  Modified the error message when updating the supply code to PI
--  050418          ifit is not connected to a project activity. Added the same error message
--  050418          when inserting a new record with supply code PI and not connected to a project activity.
--  050405  ToBeSe  Bug 49880, Added parameter contract and added exception handling
--                  for calendar changes in procedure Calendar_Changed.
--  050308  IsWilk  Added the global info2_ to get the value of info_ when adding the project connection.
--  041102  KaDilk  Bug 45027, Added columns condition_code,part_ownership,owning_customer_no and owning_vendor_no to VIEW_SHORTAGE.
--  041129  JOHESE  Modified calls to Make_Onhand_Analysis
--  041117  SaNalk  Modified Handle_Activity_Seq___ to stop project connections if pre posings exists for a financial project code part.
--  041101  ErSolk  Bug 47645, Modified procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  041028  SaJjlk  Modified method calls to Inventory_Part_In_Stock_API.Unissue_Part to add parameter catch_quantity.
--  041028  RaKalk  Changed the dynamic function call Purchase_Order_Line_Part_API.Get_Qty_In_Stores
--  041028          to Receipt_Inventory_Location_API.Get_Qty_In_Store.
--  041025  JOHESE  Modified VIEW_DEMAND VIEW_DEMAND_CUSTORD VIEW_DEMAND_MS and VIEW_DEMAND_EXT
--  041016  SaNalk  Modified Handle_Activity_Seq___ to stop project connections if pre posings exists for a financial project code part.
--  041013  SaJjlk  Added parameter reserved_catch_qty_ to Inventory_Part_In_Stock_API.Find_And_Reserve_Part.
--  040922  SaNalk  Modified Handle_Activity_Seq___.
--  040908  SaNalk  Added a check for Financial Project code part value in Handle_Activity_Seq___.
--  040908  UsRalk  Modified [Handle_Activity_Seq___], [Get_Activity_Info___] and [Calculate_Cost_And_Progress] to receive ORDER_CLASS client value.
--  040903  MaEelk  Removed view MATERIAL_REQUIS_LINE_PROJECT.
--  040827  UsRalk  Modified [Prepare_Insert___] to return the contract in the attribute string.
--  040824  DiVelk  Added new view MATERIAL_REQUIS_LINE_PROJECT.
--  040818  DiVelk  Modified [Validate_Proj_Disconnect___] to allow lines to have status 'Planned'.
--  040817  RoJalk  Bug 45847, Modified Insert___ and changed the method which gets the qty on hand for
--  040817          Order_Supply_Demand_API.Generate_Next_Level_Demands when MRP code is N.
--  040817  DiVelk  Modified [Validate_Proj_Connect___] to get the status of Activity.
--  040806  LaBolk  Added code to check if IF LU PurchaseReqUtil is installed before calling its methods (further correction to LCS patch 44464).
--  040723  DiVelk  Modified [Get_Activity_Info___] to make committed cost zero when issued.
--  040722  MaEelk  Modified the logic for fetching committed cost and used cost in Get_Activity_Info___.
--  040722          Also added an error message when changing to supply code to PO in a project connected line.
--  040709  DiVelk  Modified [Validate_Proj_Disconnect___].
--  040708  DiVelk  Modified [Validate_Proj_Connect___].
--  040630  Samnlk  Remove public method generate_pre_accounting.
--  040629  DiVelk  Modified [Validate_Proj_Connect___] and [Unpack_Check_Update___].
--  040628  UsRalk  Combined the EXECUTE IMMEDIATE statements in [Handle_Activity_Seq___] to a single call.
--  040621  MaEelk  Added check for 'activity_seq > 0' with NOT NULL condition.
--  040618  DiVelk  Added check for 'activity_seq > 0' with NOT NULL condition.
--  040616  DiVelk  Modified Make_Requisition___.
--  040610  DiVelk  Modified Handle_Activity_Seq___.
--  040609  JOHESE  Modified Make_Line_Reservations to support project inventory
--  040528  MaEelk  Modified Handle_Activity_Seq___.
--  040525  DiVelk  Modified Unpack_Check_Update___,Update___ and Delete___.
--  040524  DiVelk  Modified Update___, Delete___ and Calculate_Cost_And_Progress.
--  040520  MaEelk  Modified Handle_Activity_Seq___.
--  040520  MaEelk  Made parameter changes to Calculate_Cost_And_Progress. Modified Handle_Activity_Seq___.
--  040518  DiVelk  Modified Update__.
--  040517  DiVelk  Modified Handle_Activity_Seq___ and Modify_Supply_Code__.
--  040514  DiVelk  Added procedures Handle_Activity_Seq___,Get_Activity_Info___ and Calculate_Cost_And_Progress.
--  040512  DaZaSe  Project Inventory: Added dummy parameters to call Inventory_Part_In_Stock_API.Find_And_Reserve_Part,
--                  change these parameters to real Activity_Seq and Project_Id values if this functionality uses Project Inventory.
--  040511  KaDilk  Bug 44464, Added global constant inst_PurchaseReqUtil_ and modified procedure Make_Requisition___.
--  040511  DiVelk  Removed methods Validate_Activity_Seq___,Connect_To_Activity and Disconnect_From_Activity and added methods Validate_Proj_Connect___,Validate_Proj_Disconnect___.
--  040507  DiVelk  Added methods Validate_Activity_Seq___,Connect_To_Activity and Disconnect_From_Activity.
--  040428  UsRalk  Modified Unpack_Check_Insert___, Unpack_Check_Update___,Insert___ and Update___.
--  040428  UsRalk  Added column Project_Id to view MATERIAL_REQUIS_LINE and added method Get_Project_Id.
--  040421  KiSalk  Removed view MATERIAL_REQUIS_LINE_SIM
--  040421  LoPrlk  Added the column condition_code to views MATERIAL_REQUIS_LINE_DEMAND, MATERIAL_REQUIS_LINE_DEMAND_OE, MATERIAL_REQUIS_LINE_MS and MATERIAL_REQUIS_LINE_EXT.
--  040415  SaNalk  Added column Activity_Seq to view MATERIAL_REQUIS_LINE and to method Get.Modified Unpack_Check_Insert___, Unpack_Check_Update___,
--  040415          Insert___ and Update___.Added method Get_Activity_Seq.
--  040415  NaWalk  Added column qty_pegged to views MATERIAL_REQUIS_LINE_DEMAND,
--  040415          MATERIAL_REQUIS_LINE_DEMAND_OE, MATERIAL_REQUIS_LINE_SIM, MATERIAL_REQUIS_LINE_MS and MATERIAL_REQUIS_LINE_EXT
--  040414  KiSalk  Added column qty_reserved to views MATERIAL_REQUIS_LINE_DEMAND,
--  040414          MATERIAL_REQUIS_LINE_DEMAND_OE, MATERIAL_REQUIS_LINE_SIM, MATERIAL_REQUIS_LINE_MS and MATERIAL_REQUIS_LINE_EXT
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  040210  ErSolk  Bug 41663, Modified procedures Unpack_Check_Insert___ and Unpack_Check_Update___.
--  040128  NaWalk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  031016  MaEelk  Call ID 107578, Restricted to add or modify a requisition line when the part has K,T or O for the MRP Order Code.
--  031014  PrJalk   Bug Fix 106224, Added missing and corrected wrong General_Sys.Init_Method calls.
--  031013  MaEelk  Call ID 104459, Passed the client value of order_class to Make_Requisition___ from procedure Insert___.
--  030914  JeLise  Call Id 103281, Added check on if newrec_.supply_code is null in Unpack_Check_Insert___.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030729  WaJalk  Chnaged method Update_Intorder_Detail to check whether there are more lines with state not equal to 'Close'
--                  before raising the info message when issuing for a selected line.
--                  Removed bug tags.
--  ********************* CRMerge *****************************
--  030807  GeKalk  Call Id 99719, Modified Make_Requisition___ to add the condition code as an input parameter
--  030807          to use in method call Purchase_Req_Util_API.New_Line_Part
--  030729  MaGulk  Merged SP4
--  030515  CaRase  Bug 37368, Correct dynamic call Purchase_Req_Line_Part_API.Get_Requisition_No to Purchase_Req_Line_Part_API.Get_Objstate.
--  030514  CaRase  Bug 37368, Made dynamic call to Purchase_Order_Line_API.Get_Objstate in procedure Modify_Supply_Code__ and Check_Delete.
--                             Made dynamic call to Purchase_Req_Line_Part_API.Get_Requisition_No in procedure Check_Delete.
--  030513  CaRase  Bug 29430, In procedure Update___ add check of new and old supply code before set newrec_.qty_on_order to newrec_.qty_due.
--  030508  CaRase  Bug 32190, Remove code check of status and message: "The material requisition cannot be changed when the status code is :P1"
--                  in Procedure Unpack_Check_Update___. Update check when a Material Requistition should be set in
--                  state Close in procedur Update_Intorder_Detail
--  030425  CaRase  Bug 29428, Add check when delete of MR line is allowed.
--  030417  JaMise  Bug 29428, Modified method Modify_Supply_Code__; it's allowed to delete requisition line
--                             when created purchase order line is cancelled.
--  030411  MAJO    Bug 36143, Modified public cursor Get_Matreq_Demand_Cur. Reduce qty required by
--                  qty_assigned. When MRP calulates beginning onhand it uses qty_onhand - qty_reserved.
--  030120  Samnlk  Bug 35137, Remove the PROCEDURE Chk_Mandatory_Posting,(Bad correction of 30837 will be replaced with this new bug)
--  021118  Susalk  Bug 34075, Extend the length of the variable onhand_analysis_flag_ VARCHAR2(20) to VARCHAR2(200).
--  021106  MKrase  Bug 33893, Added Read Only for five demand views.
--  021018  RoAnse  Bug 33126, Changed STATUS_CODE to STATUS_CODE_DB and SUPPLY_CODE to SUPPLY_CODE_DB in calls
--                  to Client_SYS.Add_To_Attr in procedure Calendar_Changed.
--  020918 LEPESE  ***************** IceAge Merge Start *********************
--  020711  Samnlk  Bug 30837, Created a new PROCEDURE Chk_Mandatory_Posting.
--  020705  RaSilk  Bug 31492, Added Client_SYS.Add_To_Attr('QTY_SHIPPED', lu_rec_.qty_shipped - qty_unissue_, attr_) to method Unissue()
--  020918 LEPESE  ***************** IceAge Merge End ***********************
--  020904  JoAnSe  Changed Make_Line_Reservations to handle condition code.
--                  Added validations for condition code in Unpack_Check... methods.
--  020618  CHJALK  Added public attribute CONDITION_CODE to MATERIAL_REQUIS_LINE_TAB.
--  020516  NASALK  Extending the serial_no variable definition from VARCHAR(15) to VARCHAR(50)
--  020305  CaStse  Changed demand_order_no to 12 characters, and demand_sequence_no to 4 characters
--                  in call to Purchase_Req_Util_API.Modify_Req_Demand_Order_Info in Make_Requisition___.
--  011011  Samnlk  Bug Fix 24527,Modify PROCEDURE Make_Requisition__,call the MATERIAL_REQUISITION_API.Get_Destination_Id(order_class_ ,order_no_);
--  011004  SuSalk  Bug 24658 fix,Extend the length of 'Company' to VARCHAR2(20).
--  010927  Samnlk  Bug Fix 24527, Modify PROCEDURE Make_Requisition___, add a destination_id to the dynamic call.
--  010926  NaWalk  Bug Fix 24426,Added the Function Part_Exist()
--  010924  JOHESE  Bug Fix 24345, Modifyed Get_Matreq_Demand_Cur to include material requisitions in status Partially Delivered
--  010912  Samnlk  Bug fix 20341,Modify the view MATERIAL_REQUIS.
--  010910  samnlk  Bug fix 20341, Create a new view MATERIAL_REQUIS.
--  010522  JSAnse  Bug fix 21592, Removed DBMS_OUTPUT from PROCEDURE Generate_Pre_Accounting.
--  010410  DaJoLK  Bug fix 20598, Declared Global LU Constants to replace calls to TRANSACTION_SYS.Package_Is_Installed and
--                  TRANSACTION_SYS.Logical_Unit_Is_Installed in methods.
--  010319  Makulk  Fixed bug 20129 (i.e. Added PROCEDURE Calendar_Changed ).
--  010214  DaJolk  Bug fix 19760, Modified PROCEDURE Unissue to get qty_reversed_ using function Inventory_Transaction_Hist_API.Get_Qty_Reversed.
--  001214  JOHESE  Added check in Make_Line_Reservations
--  001012  ANLASE  Added method Check_Exist_Non_Closed.
--  001010  ANLASE  Added check for configurations in unpack_check_insert___ and unpack_check_update___.
--  000925  JOHESE  Added undefines.
--  000920  PaLj    Added '*' as configuration_id in call to Inventory_Part_In_Stock_API.Make_Onhand_Analysis
--  000825  JOHESE  Changed Inventory_part_location_api calls to Inventory_part_in_stock_api
--  000418  NISOSE  Made corrections in Check_Part_No__ and Added General_SYS.Init_Method in Modify_Qty_Short.
--  000417  SHVE    Replaced reference to obsolete method Inventory_Part_Planning_API.Get_Scrapping_Adjusted_Qty
--                  with Inventory_Part_Planning_API.Get_Scrap_Added_Qty.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000411  ANHO    Changed call to Inventory_Part_Location_API.Get_Total_Qty_Onhand
--                  with Inventory_Part_Location_API.Get_Inventory_Qty_Onhand.
--  000405  NISOSE  Modified Get_Purchase_Link.
--  000329  NISOSE  Made attributes qty_due and contract public.
--  000302  ANLASE  Corrected cursor in procedure Delete.
--  000228  ANLASE  Added cursor in procedure Delete.
--  000225  NISOSE  Corrected Error_SYS.Record_General label length.
--  991110  FRDI    Bug fix 11696, set shortage to: orig_qty_short_-(qty_to_reserve_ -qty_left_)
--                  in Make_Line_Reservations if it is called without qty_to_reserve_ = NULL and an old shortage exists
--  990604  SHVE    CID 4276(Foreign CID-5490)-Made Availability check conditional.
--  990527  DAZA    Added nvl check on qty_short_ in Modify_Qty_Short.
--  990505  DAZA    General performance improvements.
--  990414  DAZA    Upgraded to performance optimized template.
--  990407  LEPE    Removed status_code from public cursor Get_Matreq_Demand_Cur.
--  990331  ANHO    NOCHECK on all non base-views.
--  990331  LEPE    Correction i method Modify_Supply_Code to allow change of supply_type
--                  from PO to IO also if purchase_requisition_line has been deleted.
--  990330  ANHO    Added check in Insert___ that Pre Posting is made if it is mandatory
--                  on Material Requisition Header.
--  990326  ANHO    Allowed lines in status Planned to be removed.
--  990324  ANHO    Added call to Inventory_Part_Planning_API.Get_Scrapping_Adjusted_Qty
--                  in Make_Requisition___.
--  990318  FRDI    Changed errormessage for calendar unpack_check_update___/insert___
--  990303  ANHO    Added procedure Close__ and changed prompt on planned_delivery_date.
--  990210  ROOD    Correction of condition on part_no in Get_Matreq_Demand_Cur.
--  990202  DAZA    Small correction in error message NOTDEMAND.
--  990202  ROOD    Added attribute part_no with conditions in public cursor Get_Matreq_Demand_Cur.
--  990128  DAZA    Changed Check_Part_No to private Check_Part_No__. Added a
--                  new demand_flag check in Check_Part_No__.
--  980124  FRDI    System parameter 'PURCHASE_VALUE_METHOD' to Site_API.Get_Inventory_Value_Method_Db (contract_);
--  990119  JOKE    Added activity_seq_ as a inparameter to generate_pre_accounting.
--  990117  ROOD    Removed methods Create_Dop___, Modify_Dop___ and Cancel_Dop___.
--  990113  FRDI    Parameter contract was added to Pre_Accounting_API.New in Generate_Pre_Accounting
--  990108  ANHO    Removed check on waiv_dev_rej_no in Make_Line_Reservations.
--  990104  TOBE    Changed Insert___ to check if Pre_Accounting exists for the header, if that is
--                  the case, Pre_Accounting info is copied to the rows pre_acoounting_id.
--  981228  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981215  FRDI    Replaced calls to MPCCOM_SHOP_CALENDAR_API with calls to WORK_TIME_CALENDAR_API.
--  981127  FRDI    Full precision for UOM, round result of scrap calculation
--                  up to the next adjacent number with 12 decimals.
--  981122  FRDI    Full precision for UOM, change comments in tab & variabel in Get_Qty_Demand .
--  980930  JOHW    Changed call to Inventory_Part_Location_API.Make_Onhand_Analysis.
--  980819  JOHW    Changed Inventory_Part_API.Get_Mrp_Order_Code to Inventory_Part_Planning_API.Get...
--  980819  GOPE    Redirect to new UnissuePart method in InventoryPartLocation
--  980814  GOPE    Removed call to inventory_transaction_hist in method Unissue,
--                  InventoryPartLocation handles the history
--  980702  GOPE    Correction of dynamic call in method Modify_Supply_Code___
--  980423  LEPE    Correction of call to create new purchase requisition.
--  980414  JOHNI   Changed to long error message - NOALLOWED_STATUS.
--  980326  ANHO    Included qty_returned and qty_on_order in the attribute string in Insert__.
--  980306  ANHO    Changed names on viewcomments on qty_assigned and qty_shipped.
--  980305  ANHO    Added errormessages for supply_code_db in Change_Qty_Assigned.
--  980303  LEPE    Changed status for lines with purchase supply to be created in status released.
--  980303  LEPE    Changed call to Purchase_Req_Line_Part_API.Modify_Req_Demand_Order_Info to
--                  instead call same method in package Purchase_Req_Util_API.
--  980302  ANHO    Added errormessages in Change_Qty_Assigned and Update_Intorder_Detail and added
--                  status_code_db=7 to whereclause in Get_Qty_Demand.
--  980227  JOHO    Corrections according to heat Id 3392.
--  980218  ANHO    Changed errormessage in Check_Part_No.
--  980121  FRDI    Clean up conection to Purchase requisition, add exeptions
--  980116  FRDI    Bug fix: Clean up conection to Purchase requisition.
--  980112  FRDI    Clean up conection to Purchase requisition.
--  980109  JOHO    Restrucuring of shop order
--  971201  GOPE    Upgrade to fnd 2.0
--  971111  JOHNI   Added order_class_db in view.
--  971103  PEKR    Changed call Dop_Head_API.Cancel to Dop_Head_API.Remove_Structure.
--  971103  GOPE    Added call to Purchase_Req_Line_Part_API.Modify_Req_Demand_Order_Info
--                  in Make_Requisition___, supply the demand order information
--  970921  ANTA    Changed public cursor Get_Matreq_Demand_Cur used by MRP to
--                  reference status_code_db and added check on supply_code_db.
--  971001  NAVE    While resolving shortages, qty_short must not be set to 0 unless the
--                  whole shortage is resolved. Fixed proc Make_Line_Reservations.
--  970912  NABE    Changed UOM to 10 char, references to Iso_Unit.
--  970911  ANTA    Added scrapping algorithm to Make_Requisition___.
--  970908  GOPE    Added methods for IFS/Project intergration
--  970811  RaKu    BUG 97-0082. Changed default value on WaivDevRejNo in function Make_Line_Reservations.
--  970723  JOMU    Added call to Shortage_Demand_API.Calculate_Order_Shortage_Qty in
--                  Make_Line_Reservations.  Removed Make_Shortage_Reservations.
--  970721  NAVE    Added order_class to shortage view. Removed Objid/Objversion (used
--                  another technique in the client which did not require this.
--  970717  NAVE    Added Objid and Objversion to Material_Requis_Line_Shortage view.
--  970708  CHAN    Added creation of shortage and maintain of that. Added also
--                  a new view Material_Requis_Line_Shortage used by ShortageDemand.
--  970707  NAVE    Added qty_short to MATERIAL_REQUIS_LINE
--  970703  RaKu    BUG 97-0073. Changed function Check_Status.
--  970617  JOED    Changed public Get_.. methods. Added _db column in the view.
--                  Beautified parts of the code.
--  970611  LEPE    Refined error message for onhand_analysis.
--  970611  MAJO    Removed qty_on_order from the view  MATERIAL_REQUIS_LINE_MS,
--                  Master Schedule should see everything. Also corrected the
--                  logic in the view definitions concerning qty_shipdiff.
--  970609  MAGN    Corrected attribute string to include note_id in Insert__.
--  970516  PEKR    Added call to Generate_Next_Level_Demands.
--  970516  Neno    Added DOP functions
--  970507  NAVE    Added public cursor Get_Matreq_Demand_Cur
--  970415  GOPE    Added EXT, MS, SIM views
--  970414  FRMA    Modified Unissue for FIFO/LIFO (checks Purchase_Value_Method).
--                  Added parameter new_transaction_id_ in call to
--                  Inventory_Part_Location_API.Unissue_Part, in Unissue.
--  970403  GOPE    Added method Get_Qty_Assigned
--  970326  GOPE    Added PRE_ACCOUNTING_ID to attr_ in method insert__
--  970325  MAGN    Changed from mpccom_company_API.Get_Home_Company to Site_API.Get_Company.
--  970313  CHAN    Changed table name: mpc_intorder_detail is replaced by
--                  material_requis_line_tab
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  970128  MAOR    Added check if status_code has value 5, 'Linked' in
--                  Insert___.
--  970127  MAOR    Changed column qty_due to be update allowed.
--  970127  MAOR    Added view-comments to status_desc in Material_Requis_Line_Demand.
--  970127  MAOR    Added column status_desc in view Material_Requis_Line_Demand.
--  970126  MAOR    Added qty_on_order = qty_due in unpack_check_insert___.
--  970122  LEPE    Changed length of local variable purchase_type to 20.
--                  Call to Inventory_Part_API.Set_Avail_Activity_Status only
--                  for inventory parts.
--  970121  LEPE    Remove Generate_Supply_link and Remove_Supply_link.
--                  Used material_requis_supply instead of Order_supply_type.
--  970121  AnAr    Added Qty_Assigned to attr in Insert___.
--  970117  LEPE    Corrected a serious bug in make_line_reservations.
--                  Added check against Shop_Calendar for due_date.
--  970113  AnAr    Added Material_Requis_Status_API.Decode to MATERIAL_REQUIS_LINE_DEMAND_OE.
--  970113  AnAr    Fixed PROCEDURE Make_Line_Reservations.
--  970113  AnAr    Fixed call to Mpccom_Transaction_Code_API.Check_Valid_Transaction_Code.
--  970107  MAOR    Added expiration_date_ in call to
--                  Inventory_Part_Location_API.Unissue_Part. This in procedure
--                  Unissue.
--  961218  PEKR    MakeRequisition___ and Generate_Supply_Link___ must be executed
--                  after INSERT in procedure Insert___ due to exist checks in
--                  Material_Requis_Pur_Order_API.New .
--  961217  PEKR    demand_code_ must have size 20 in dynamic call to
--                  Purchase_Requis_Line_API.New_Requis_Line.
--  961216  GOPE    Change the argument in call to New_Requis_line
--  961214  MAOR    Changed Get_Db_Value to Get_Client_Value.
--  961214  AnAr    Made Workbench compatible.
--  961209  AnAr    Fixed bug 96-0011 ( changed Material_Requis_Line_Demand and
--                  Material_Requis_Line_Demand_Oe ).
--  961120  AnAr    Changed parameters on Call to Material_Requisition_API.
--  961118  SHVE    Changed parameters to procedure Purchase_Requisition_Api.New
--  961108  MAOR    Changed order of part_no and contract in call to LU
--                  Inventory_Part_API.
--  961105  MAOR    Changed name and order of parameters in call to
--                  Inventory_Part_API.Get_UnitMeas. Name is now Get_Unit_Meas
--                  and is a function call. Also changed order of part_no and
--                  contract in call to LU Inventory_Part_API.
--  961014  JICE    Added out-parameter to Make_Line_Reservations to provide
--                  info about quantity reserved.
--  960918  LEPE    Added exception handling for dynamic SQL.
--  960904  JICE    Added Modify_Qty_Returned.
--  960819  JOKE    Altered all purchase_type because purchase_type now has
--                  client value in view.
--  960815  JOLA    Added view MATERIAL_REQUIS_LINE_DEMAND_OE.
--  960807  MAOS    Added General_SYS.Init_Method in procedure Get_Description.
--  960704  JICE    Changed number of arguments for bind on numeric columns.
--  960703  AnAr    Changed NOTE_TEXT from LONG to STRING(2000).
--  960628  MAOS    Added bind variable in call to Purchase_Requis_Line_API.New_Req_Line.
--  960628  MAOS    Replaced call to Inventory_Part_Loaction2_API.Make_Intorder_Reservation__
--                  with Inventory_Part_Loaction_API.Make_Intorder_Reservation.
--  960626  JICE    Fixed errors in handling of supply_code.
--  960624  JICE    Fixed errors in errortexts for localization.
--  960618  MAOS    Replaced PurchaseOrderStatus with MaterialRequisStatus.
--                  Changed function Get_Description into a procedure
--                  (added out parameter description_)
--                  Replaced calls to PURCH with dynamic SQL.
--  960617  JOHNI   Added view MATERIAL_REQUIS_LINE_DEMAND.
--  960610  JICE    Changed  handling of site, fixed status-bug.
--  960515  SHVE    Added methods Get_Qty_On_Order, Get_Unit_Meas,Get_Order_No.
--  960503  SHVE    Replaced reference to requisition_detail.
--  960430  MAOS    Removed call to dual when fetching note_id and pre_accounting_id.
--  960425  MPC5    Spec 96-0002 LONG-fields is replaced by VARCHAR2(2000).
--  960328  SHVE    Replaced calls to other LU's New__ procedures.
--  960326  LEPE    Added Function Get_Pre_Accounting_Id
--  960322  LEPE    Made user of public method get_description from inventory_part
--  960322  SHVE    Corrected procedure Modify_Qty_On_Order
--  960321  ASBE    Added procedure Modify_Qty_On_Order
--  960307  JICE    Renamed from IntorderDetail
--  951031  BJSA    Base Table to Logical Unit Generator 1.0
--  951107  LEPE    Added public function Get_Qty_Demand
--  951202  OYME    Added PRE_ACCOUNTING_ID to attr_-string
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Get_Matreq_Demand_Rec IS RECORD(
   part_no                VARCHAR2(25),
   date_required          DATE,
   remaining_qty_required NUMBER,
   order_no               VARCHAR2(12),
   line_no                VARCHAR2(4),
   release_no             VARCHAR2(4),
   line_item_no           NUMBER
);
CURSOR Get_Matreq_Demand_Cur_Site(contract_ IN VARCHAR2) RETURN Get_Matreq_Demand_Rec
IS
   SELECT part_no,
          due_date,
          qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned),
          order_no,
          line_no,
          release_no,
          line_item_no
   FROM MATERIAL_REQUIS_LINE_TAB
   WHERE contract = contract_
   AND   line_item_no <> -1
   AND   status_code IN ('4', '5', '7')
   AND   supply_code IN ('IO', 'PO')
   AND   qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned) > 0;
CURSOR Get_Matreq_Demand_Cur(contract_ IN VARCHAR2,
                             part_no_  IN VARCHAR2) RETURN Get_Matreq_Demand_Rec
IS
   SELECT part_no,
          due_date,
          qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned),
          order_no,
          line_no,
          release_no,
          line_item_no
   FROM MATERIAL_REQUIS_LINE_TAB
   WHERE contract = contract_
   AND   part_no  = part_no_
   AND   line_item_no <> -1
   AND   status_code IN ('4', '5', '7')
   AND   supply_code IN ('IO', 'PO')
   AND   qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned) > 0;

TYPE Get_Proj_Matreq_Demand_Rec IS RECORD(
   part_no                VARCHAR2(25),
   date_required          DATE,
   remaining_qty_required NUMBER,
   order_no               VARCHAR2(12),
   line_no                VARCHAR2(4),
   release_no             VARCHAR2(4),
   line_item_no           NUMBER,
   project_id             VARCHAR2(10),
   activity_seq           NUMBER
);

CURSOR Get_Proj_Matreq_Demand_Cur(contract_     IN VARCHAR2,
                                  part_no_      IN VARCHAR2,
                                  project_id_   IN VARCHAR2,
                                  activity_seq_ IN NUMBER) RETURN Get_Proj_Matreq_Demand_Rec
IS
   SELECT part_no,
          due_date,
          qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned),
          order_no,
          line_no,
          release_no,
          line_item_no,
          project_id,
          activity_seq
   FROM MATERIAL_REQUIS_LINE_TAB
   WHERE contract = contract_
   AND   (part_no = part_no_ OR part_no_ = '%')
   AND   line_item_no <> -1
   AND   status_code IN ('4', '5', '7')
   AND   supply_code = 'PI'
   AND   qty_due - (qty_shipped - qty_shipdiff + qty_on_order + qty_assigned) > 0
   AND   (project_id = project_id_ OR project_id_ IS NULL)
   AND   (activity_seq = activity_seq_ OR activity_seq_ IS NULL);


PROCEDURE New(
   newrec_ IN OUT NOCOPY MATERIAL_REQUIS_LINE_TAB%ROWTYPE)
IS
BEGIN
   --UXX Usage Only--
   New___(newrec_); 
END New;
-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_             CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Make_Requisition___
--   Makes a new purchase requisition.
PROCEDURE Make_Requisition___ (
   due_qty_        IN OUT NUMBER,
   due_date_       IN OUT DATE,
   requisition_no_ IN OUT VARCHAR2,
   req_line_no_    IN OUT VARCHAR2,
   req_release_no_ IN OUT VARCHAR2,
   order_class_    IN     VARCHAR2,
   order_no_       IN     VARCHAR2,
   line_no_        IN     VARCHAR2,
   release_no_     IN     VARCHAR2,
   part_no_        IN     VARCHAR2,
   contract_       IN     VARCHAR2,
   requisit_code_  IN     VARCHAR2,
   condition_code_ IN     VARCHAR2,
   note_text_      IN     VARCHAR2)
IS
   attr_                VARCHAR2(32000);
   demand_code_         VARCHAR2(20);
   order_code_          VARCHAR2(3);   
   mark_for_            VARCHAR2(25);
   order_qty_           NUMBER;
   preq_pre_acc_id_     NUMBER;
   matreq_pre_acc_id_   NUMBER;
   material_requis_rec_ Material_Requisition_API.Public_Rec;
BEGIN
   --
   -- Create Mark_For_
   --
   mark_for_ := order_no_ || ' ' || line_no_ || ' ' || release_no_ || ' ' || Material_Requis_Type_API.Decode(order_class_);
   --
   material_requis_rec_ := Material_Requisition_API.Get(order_class_, order_no_);
   --
   --
   -- Determine which SUPPLY_CODE the order is.
   --
   order_code_  := '1';
   demand_code_ := Order_Supply_Type_API.Decode('ID');
   order_qty_   := Inventory_Part_Planning_API.Get_Scrap_Added_Qty(contract_, part_no_, due_qty_);
   --
   --  Make new REQUISITION_HEADER
   --
   $IF Component_Purch_SYS.INSTALLED $THEN
     Purchase_Req_Util_API.New_Requisition(
                                          requisition_no_,
                                          order_code_,
                                          contract_,
                                          requisit_code_,
                                          mark_for_,
                                          material_requis_rec_.destination_id,
                                          material_requis_rec_.internal_destination);      
   $ELSE
      Error_SYS.Record_General(lu_name_, 'PURQUTILNOTEXIST: Can not complete Requisition creation when PurchaseReqUtil is not installed.');
   $END

   IF requisition_no_ IS NULL THEN
      Error_SYS.Record_General('MaterialRequisLine', 'MAKE_REQUISITION: Error in Make_Requisition.');
   END IF;
   --
   --  Make new REQUISITION_DETAIL
   --
   due_date_    := Nvl(due_date_,Site_API.Get_Site_Date(contract_));
   Client_SYS.Clear_Attr(attr_);

   $IF Component_Purch_SYS.INSTALLED $THEN
      Purchase_Req_Util_API.New_Line_Part(req_line_no_,
                                          req_release_no_,
                                          requisition_no_,
                                          contract_,
                                          part_no_,
                                          NULL,
                                          order_qty_,
                                          due_date_,
                                          demand_code_,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          note_text_,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          NULL,
                                          condition_code_);     
   $END
--
   IF req_line_no_ IS NULL OR release_no_ IS NULL THEN
      Error_SYS.Record_General('MaterialRequisLine', 'MAKE_REQUISITIOND: Error in Make_Requisition Detail.');
   END IF;
--

   $IF Component_Purch_SYS.INSTALLED $THEN
      preq_pre_acc_id_ := Purchase_Req_Line_Part_API.Get_Pre_Accounting_Id(requisition_no_, req_line_no_, req_release_no_);      
   $END

   matreq_pre_acc_id_ := Get_Pre_Accounting_Id(order_no_, line_no_, release_no_);

   Pre_Accounting_API.Copy_Pre_Accounting(matreq_pre_acc_id_,
                                          preq_pre_acc_id_,
                                          contract_,
                                          FALSE);

END Make_Requisition___;


-- Modify_Supply_Code___
--   If the demand is made on an inventory order then an error is raised
--   if quantity assigned or quantity returned or quantity shipped or
--   quantity on order is greater than zero.
--   Else if the demand is made on a purchase order then an error is raised.
--   If the demand is just covered on a purchase requisition then the
--   requisition is removed.
PROCEDURE Modify_Supply_Code___ (
   order_class_     IN VARCHAR2,
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   release_no_      IN VARCHAR2,
   line_item_no_    IN NUMBER,
   old_supply_code_ IN VARCHAR2 )
IS
   lu_rec_                 MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   supply_not_allowed_     EXCEPTION;
   supply_code_error_      EXCEPTION;
   order_class_client_     MATERIAL_REQUIS_LINE.order_class%TYPE;
BEGIN
   order_class_client_ := Material_Requis_Type_API.Decode(order_class_);
   IF old_supply_code_ IN ('IO','PI') THEN
      lu_rec_ := Get_Object_By_Keys___(order_class_, order_no_, line_no_, release_no_, line_item_no_);
      IF lu_rec_.order_class IS NULL THEN
         RAISE supply_code_error_;
      ELSE
         IF (lu_rec_.qty_assigned > 0 ) OR (lu_rec_.qty_returned > 0 )
            OR (lu_rec_.qty_shipped > 0 ) OR (lu_rec_.qty_on_order > 0 ) THEN
            RAISE supply_not_allowed_;
         END IF;
      END IF;
   ELSIF old_supply_code_ = 'PO' THEN
      Material_Requis_Pur_Order_API.Remove(order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_,
                                           order_class_client_); 
   ELSE
      RAISE supply_not_allowed_;
   END IF;
EXCEPTION
   WHEN supply_not_allowed_ THEN
      Error_SYS.Record_General('MaterialRequisLine', 'SUPPLY_NOT_ALLOWED: Change of supply code is not allowed for this internal order.');
   WHEN supply_code_error_ THEN
      Error_SYS.Record_General('MaterialRequisLine', 'SUPPLY_CODE_ERROR: Error in change of supply code.');
END Modify_Supply_Code___;


-- Generate_New_Line_Keys___
--   Increments the line and release number by one and returns the new values.
--   Line item number set to 1
PROCEDURE Generate_New_Line_Keys___ (
   line_no_      OUT VARCHAR2,
   release_no_   OUT VARCHAR2,
   line_item_no_ OUT NUMBER,
   order_class_  IN  VARCHAR2,
   order_no_     IN  VARCHAR2,
   part_no_      IN  VARCHAR2 )
IS
   temp_line_no_    MATERIAL_REQUIS_LINE_TAB.line_no%TYPE;
   temp_release_no_ MATERIAL_REQUIS_LINE_TAB.release_no%TYPE;
   --
   CURSOR check_same_part IS
      SELECT line_no
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_no    = order_no_
      AND    order_class = order_class_
      AND    part_no     = part_no_;
   --
   CURSOR get_line IS
      SELECT TO_CHAR(MAX(TO_NUMBER(line_no) +1))
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_no    = order_no_
      AND    order_class = order_class_;
   --
   CURSOR get_release_no IS
      SELECT TO_CHAR(MAX(TO_NUMBER(release_no) +1))
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_no    = order_no_
      AND    order_class = order_class_
      AND    line_no     = temp_line_no_;
   --
BEGIN
   line_no_            := NULL;
   release_no_         := NULL;
   line_item_no_       := NULL;
   temp_line_no_       := NULL;
   temp_release_no_    := NULL;
   --
   OPEN check_same_part;
   FETCH check_same_part INTO temp_line_no_;
   CLOSE check_same_part;
   IF (temp_line_no_ IS NOT NULL) THEN
      OPEN get_release_no;
      FETCH get_release_no INTO temp_release_no_;
      CLOSE get_release_no;
      IF (temp_release_no_ IS NULL) THEN
         release_no_ := '1';
      ELSE
         release_no_ := temp_release_no_;
      END IF;
      line_no_ := temp_line_no_;
   ELSE
      OPEN get_line;
      FETCH get_line INTO temp_line_no_;
      CLOSE get_line;
      IF (temp_line_no_ IS NULL) THEN
         line_no_ := '1';
      ELSE
         line_no_ := temp_line_no_;
      END IF;
      release_no_ := '1';
   END IF;
   line_item_no_ := 1;
END Generate_New_Line_Keys___;


-- Modify_Impl___
--   Does the call to all basic methods when updating attributes.
PROCEDURE Modify_Impl___ (
   attr_         IN OUT VARCHAR2,
   order_class_  IN     VARCHAR2,
   order_no_     IN     VARCHAR2,
   line_no_      IN     VARCHAR2,
   release_no_   IN     VARCHAR2,
   line_item_no_ IN     NUMBER )
IS
   oldrec_       MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   newrec_       MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   objid_        MATERIAL_REQUIS_LINE.objid%TYPE;
   objversion_   MATERIAL_REQUIS_LINE.objversion%TYPE;
   indrec_       Indicator_Rec;
   
BEGIN
   oldrec_ := Lock_By_Keys___(order_class_, order_no_, line_no_, release_no_, line_item_no_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify_Impl___;


-- Validate_Proj_Connect___
--   Do the necessary validations when a project connection is made.
PROCEDURE Validate_Proj_Connect___ (
   project_id_       OUT    VARCHAR2,
   supply_code_db_   IN OUT VARCHAR2,
   contract_         IN     VARCHAR2,
   status_code_db_   IN     VARCHAR2,
   new_activity_seq_ IN     NUMBER,
   old_activity_seq_ IN     NUMBER,
   due_date_         IN     DATE )
IS  
   $IF Component_Proj_SYS.INSTALLED $THEN         
      activity_rec_        Activity_API.Public_Rec;
      activity_site_exist_ NUMBER;
   $END
BEGIN
      IF (old_activity_seq_ IS NOT NULL) AND (old_activity_seq_ >0)  THEN
         Error_Sys.Record_General(lu_name_, 'MATRCONNEXIST: Project connection already exists. To create a new connection, disconnect the material requisition line from activity');
      END IF;
      IF (status_code_db_ NOT IN ('1','4')) THEN
         Error_SYS.Record_General(lu_name_, 'MATRSTATUSNOTALL: Material requisition line must have status :P1 or :P2 to make a project connection' ,Material_Requis_Status_API.Decode('1'),Material_Requis_Status_API.Decode('4'));
      END IF;
      IF (supply_code_db_ != 'IO') THEN
         Error_SYS.Record_General(lu_name_, 'MATRSUPPLYNOTALL: Material requisition line must have supply code :P1 to make a project connection',Material_Requis_Supply_API.Decode('IO'));
      END IF;
      $IF Component_Proj_SYS.INSTALLED $THEN         
         activity_rec_        := Activity_API.Get(new_activity_seq_);
         project_id_          := activity_rec_.project_id;
         activity_site_exist_ := Project_Site_API.Project_Site_Exist(project_id_, contract_ );

         IF activity_site_exist_ = 0 THEN
            Error_SYS.Record_General(lu_name_,'MATRSITENOTEXIST: Site does not exist as project site ');
         END IF;
         
         IF (activity_rec_.rowstate != 'Released') THEN
            Error_SYS.Record_General(lu_name_, 'MATRACTNOTRELEASED: Cannot connect the object. The activity must be Released.');
         END IF;

         IF (Trunc(due_date_) NOT BETWEEN Trunc(activity_rec_.early_start) AND Trunc(activity_rec_.early_finish)) THEN
            Client_SYS.Add_Info('MaterialRequisLine','MATRCONNECTEDPROJ: The due date is not within life span of the connected project activity :P1.  '||
                                  'Please review the dates',new_activity_seq_);
         END IF;
         supply_code_db_ := 'PI';         
      $END
END Validate_Proj_Connect___;


-- Validate_Proj_Disconnect___
--   Do the necessary validations when disconnecting from the connected project.
PROCEDURE Validate_Proj_Disconnect___ (
   project_id_     IN OUT VARCHAR2,
   supply_code_db_ IN OUT VARCHAR2,
   status_code_db_ IN     VARCHAR2 )
IS
BEGIN
   IF (status_code_db_ NOT IN ('1','4')) THEN
      Error_SYS.Record_General(lu_name_, 'MATRDSTATUSNOTALL: Material requisition line must have status [:P1] or [:P2] to disconnect a project connection',Material_Requis_Status_API.Decode('1'),Material_Requis_Status_API.Decode('4'));
   END IF;
   IF (supply_code_db_ NOT IN ('PI','IO')) THEN
      Error_SYS.Record_General(lu_name_, 'MATRDSUPPLYNOTALL: Material requisition line must have supply code [:P1] or [:P2] to disconnect a project connection',Material_Requis_Supply_API.Decode('PI'),Material_Requis_Supply_API.Decode('IO'));
   ELSE
      supply_code_db_ := 'IO';
   END IF;
   project_id_ := NULL;
END Validate_Proj_Disconnect___;


-- Handle_Activity_Seq___
--   When connecting, create a project connection and set the pre postings as
--   appropriate and when disconnecting, remove the connection and the
--   pre postings.
PROCEDURE Handle_Activity_Seq___ (
   rec_                 IN MATERIAL_REQUIS_LINE_TAB%ROWTYPE,
   old_activity_seq_    IN NUMBER )
IS
   codeno_b_                  VARCHAR2(40);
   codeno_c_                  VARCHAR2(40);
   codeno_d_                  VARCHAR2(40);
   codeno_e_                  VARCHAR2(40);
   codeno_f_                  VARCHAR2(40);
   codeno_g_                  VARCHAR2(40);
   codeno_h_                  VARCHAR2(40);
   codeno_i_                  VARCHAR2(40);
   codeno_j_                  VARCHAR2(40);   
   object_progress_           NUMBER;
   company_                   VARCHAR2(100);
   proj_code_value_           VARCHAR2(30);
   distr_proj_code_value_     VARCHAR2(30);
   dummy_                     VARCHAR2(10) := NULL;
   committed_cost_elements_   Mpccom_Accounting_API.Project_Cost_Element_Tab;
   used_cost_elements_        Mpccom_Accounting_API.Project_Cost_Element_Tab;
   empty_tab_                 Mpccom_Accounting_API.Project_Cost_Element_Tab;
   count_                     NUMBER := 0;
   activity_info_tab_         Public_Declarations_API.PROJ_Project_Conn_Cost_Tab;
   activity_revenue_info_tab_ Public_Declarations_API.PROJ_Project_Conn_Revenue_Tab;
   attributes_                Public_Declarations_API.PROJ_Project_Conn_Attr_Type;
   CURSOR get_project_cost_elements IS
      SELECT   project_cost_element,
               SUM(committed_amount) committed_amount,
               SUM(used_amount)      used_amount
      FROM     project_cost_element_tmp
      GROUP BY project_cost_element;
BEGIN
   company_ := Site_API.Get_Company(rec_.contract);
   Pre_Accounting_API.Get_Project_Code_Value(proj_code_value_, distr_proj_code_value_, company_, rec_.pre_accounting_id);
   IF (proj_code_value_ IS NOT NULL AND proj_code_value_ != rec_.project_id) THEN
      Error_SYS.Record_General(lu_name_, 'PROJECTCODEPARTEXIST: It is not allowed to connect an object with existing preposting on the Project code part ');
   END IF;
   
   -- Make a new project connection.
   $IF Component_Proj_SYS.INSTALLED $THEN
      IF (rec_.activity_seq IS NOT NULL) AND (rec_.activity_seq >0) THEN
         -- Get the cost and progress details of the Material requisition line.
         Get_Activity_Info___ (committed_cost_elements_,
                               used_cost_elements_,
                               object_progress_,
                               rec_);         
         FOR proj_cost_element_rec_ IN get_project_cost_elements LOOP
            activity_info_tab_(count_).control_category := proj_cost_element_rec_.project_cost_element;
            activity_info_tab_(count_).committed        := proj_cost_element_rec_.committed_amount;
            activity_info_tab_(count_).used             := proj_cost_element_rec_.used_amount;
            count_ := count_ + 1;
         END LOOP;
         attributes_.last_transaction_date := SYSDATE;

         Project_Connection_Util_API.Create_Connection (proj_lu_name_              => 'MTRLREQLINE',
                                                        activity_seq_              => rec_.activity_seq,
                                                        system_ctrl_conn_          => 'FALSE',
                                                        keyref1_                   => rec_.order_class,
                                                        keyref2_                   => rec_.order_no,
                                                        keyref3_                   => rec_.line_no,
                                                        keyref4_                   => rec_.release_no,
                                                        keyref5_                   => rec_.line_item_no,
                                                        keyref6_                   => NULL,
                                                        object_description_        => lu_name_,
                                                        activity_info_tab_         => activity_info_tab_,
                                                        activity_revenue_info_tab_ => activity_revenue_info_tab_,
                                                        attributes_                => attributes_);

         Project_Pre_Accounting_API.Get_Pre_Accounting3 (codeno_b_,
                                                         codeno_c_,
                                                         codeno_d_,
                                                         codeno_e_,
                                                         codeno_f_,
                                                         codeno_g_,
                                                         codeno_h_,
                                                         codeno_i_,
                                                         codeno_j_,
                                                         rec_.activity_seq );

         Invent_Proj_Cost_Manager_API.Fill_Project_Cost_Element_Tmp (empty_tab_,
                                                                     empty_tab_,
                                                                     committed_cost_elements_,
                                                                     used_cost_elements_);

         Pre_Accounting_API.Set_Pre_Posting (rec_.pre_accounting_id,
                                             rec_.contract,
                                             'M107',
                                             NULL,
                                             codeno_b_,
                                             codeno_c_,
                                             codeno_d_,
                                             codeno_e_,
                                             codeno_f_,
                                             codeno_g_,
                                             codeno_h_,
                                             codeno_i_,
                                             codeno_j_,
                                             rec_.activity_seq,
                                             'TRUE',
                                             'TRUE');
      -- Disconnect from the existing connection.
      ELSIF rec_.activity_seq IS NULL THEN
         Pre_Accounting_API.Remove_Proj_Pre_Posting (rec_.pre_accounting_id, rec_.contract, 'M107');         
         Project_Connection_Util_API.Remove_Connection (proj_lu_name_     => 'MTRLREQLINE',
                                                        activity_seq_     => old_activity_seq_,
                                                        keyref1_          => rec_.order_class,
                                                        keyref2_          => rec_.order_no,
                                                        keyref3_          => rec_.line_no,
                                                        keyref4_          => rec_.release_no,
                                                        keyref5_          => rec_.line_item_no,
                                                        keyref6_          => dummy_);                  
      END IF;
   $END
END Handle_Activity_Seq___;


-- Get_Activity_Info___
--   This method is used to calculate cost and progress information of
--   a material requisition line.
PROCEDURE Get_Activity_Info___ (
   committed_cost_elements_   OUT Mpccom_Accounting_API.Project_Cost_Element_Tab,
   used_cost_elements_        OUT Mpccom_Accounting_API.Project_Cost_Element_Tab,
   object_progress_           OUT NUMBER,
   rec_                       IN  MATERIAL_REQUIS_LINE_TAB%ROWTYPE )
IS
BEGIN
   IF rec_.status_Code = '5' THEN
      object_progress_  := 0.50;
   ELSIF rec_.status_Code = '7' THEN
      object_progress_  := 0.75;
   ELSIF rec_.status_Code = '9' THEN
      object_progress_  := 1;
   ELSE
      object_progress_  := 0;
   END IF;

   IF rec_.status_Code IN ('5','7','9') THEN
      IF ((rec_.qty_assigned > 0) AND rec_.supply_code = 'IO' ) THEN
         committed_cost_elements_ := Invent_Proj_Cost_Manager_API.Get_Elements_For_Reservations( rec_.order_no,
                                                                                                 rec_.line_no,
                                                                                                 rec_.release_no,                        
                                                                                                 rec_.line_item_no,
                                                                                                 'MTRL REQ');      
      END IF;
   END IF;
   
   IF (rec_.qty_shipped > 0) THEN
      IF rec_.supply_code = 'IO' THEN
         used_cost_elements_ := Inventory_Transaction_Hist_API.Get_Activity_Costs_By_Status( rec_.order_no,
                                                                                             rec_.line_no,
                                                                                             rec_.release_no,
                                                                                             rec_.line_item_no,
                                                                                            'NOT TRANSFERRED',
                                                                                            'MTRL REQ');
      END IF;
   END IF;
END Get_Activity_Info___;


PROCEDURE Update_Ms_Forecast___ (
   contract_      IN VARCHAR2,
   part_no_       IN VARCHAR2,
   activity_seq_  IN NUMBER,
   qty_issued_    IN NUMBER,
   required_date_ IN DATE )
IS   
BEGIN
   $IF Component_Massch_SYS.INSTALLED $THEN
      Level_1_Forecast_Util_API.Shipment_Update(contract_, part_no_, activity_seq_, qty_issued_, required_date_, FALSE);
   $ELSE
      NULL;
   $END
END Update_Ms_Forecast___;


-- Check_Attribute_Modified___
--   Check whether any updatable attibute is modified in MR line.
FUNCTION Check_Attribute_Modified___ (
   newrec_ IN MATERIAL_REQUIS_LINE_TAB%ROWTYPE,
   oldrec_ IN MATERIAL_REQUIS_LINE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
   attribute_modified_ BOOLEAN := FALSE;
BEGIN
   IF ((NVL(oldrec_.part_no, Database_SYS.string_null_)    != NVL(newrec_.part_no, Database_SYS.string_null_))    OR
       (oldrec_.unit_meas                                  != newrec_.unit_meas)                                  OR
       (oldrec_.supply_code                                != newrec_.supply_code)                                OR
       (NVL(oldrec_.note_text,Database_SYS.string_null_)   != NVL(newrec_.note_text, Database_SYS.string_null_))  OR
       (oldrec_.due_date                                   != newrec_.due_date)                                   OR
       (oldrec_.qty_on_order                               != newrec_.qty_on_order)                               OR
       (oldrec_.qty_returned                               != newrec_.qty_returned)                               OR
       (oldrec_.qty_shipdiff                               != newrec_.qty_shipdiff)                               OR
       (oldrec_.qty_shipped                                != newrec_.qty_shipped)                                OR
       (NVL(oldrec_.external_id, Database_SYS.string_null_)!= NVL(newrec_.external_id, Database_SYS.string_null_))OR
       (NVL(oldrec_.activity_seq, -9999)                   != NVL(newrec_.activity_seq,-9999)))                   THEN
      attribute_modified_ := TRUE;
   END IF;
   
   RETURN (attribute_modified_);
END Check_Attribute_Modified___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   order_class_ MATERIAL_REQUIS_LINE.order_class%TYPE;
   order_no_    MATERIAL_REQUIS_LINE.order_no%TYPE;
   contract_    MATERIAL_REQUIS_LINE.contract%TYPE;
BEGIN
   order_class_ := Client_SYS.Get_Item_Value('ORDER_CLASS', attr_);
   order_no_ := Client_SYS.Get_Item_Value('ORDER_NO', attr_);
   contract_ := Material_Requisition_API.Get_Contract(order_class_, order_no_);

   super(attr_);
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT MATERIAL_REQUIS_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   requisition_no_         VARCHAR2(12);
   line_no_                VARCHAR2(4);
   release_no_             VARCHAR2(4);   
   exist_flag_             NUMBER;
   head_pre_accounting_id_ NUMBER;
   company_                VARCHAR2(20);
   source_identifier_      VARCHAR2(200);
BEGIN
   Generate_New_Line_Keys___(newrec_.line_no, newrec_.release_no, newrec_.line_item_no, newrec_.order_class, newrec_.order_no, newrec_.part_no);
   newrec_.date_entered := Site_API.Get_Site_Date(newrec_.contract);
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;

   IF newrec_.pre_accounting_id IS NULL THEN
      newrec_.pre_accounting_id := Pre_Accounting_API.Get_Next_Pre_Accounting_Id;
      head_pre_accounting_id_ := Material_Requisition_API.Get_Pre_Accounting_Id(Material_Requis_Type_API.Decode(newrec_.order_class), newrec_.order_no);

      -- Check that Pre Posting is made if it is mandatory on Material Requisition Header
      company_           := Site_API.Get_Company(newrec_.contract);
      -- The identifier have to be translated BEFORE it is passed on.
      source_identifier_ := Language_SYS.Translate_Constant(lu_name_, 'SOURCEIDENTIFIERHEAD: Material Requisition Header :P2', Language_SYS.Get_Language, newrec_.line_no, newrec_.order_no);
      Trace_SYS.Field('SOURCE IDENTIFIER', source_identifier_);
      Pre_Accounting_API.Check_Mandatory_Code_Parts(head_pre_accounting_id_, 'M109', company_, source_identifier_);

      exist_flag_ := Pre_Accounting_API.Pre_Accounting_Exist(head_pre_accounting_id_);

      IF exist_flag_ = 1 THEN
         Pre_Accounting_API.Copy_Pre_Accounting(head_pre_accounting_id_,
                                                newrec_.pre_accounting_id,
                                                newrec_.contract);
      END IF;
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'PRE_ACCOUNTING_ID', newrec_.pre_accounting_id);

   IF (newrec_.activity_seq IS NOT NULL) AND (newrec_.activity_seq > 0) THEN
      $IF Component_Proj_SYS.INSTALLED $THEN
         newrec_.project_id := Activity_API.Get_Project_Id(newrec_.activity_seq);         
      $ELSE
         Error_SYS.Record_General(lu_name_, 'ACTIVITYNOTINST: Activity Sequence may not be set since Activity is not installed.');
      $END
   END IF;

   super(objid_, objversion_, newrec_, attr_);
   -- MAKE SUPPLY DEMAND
   IF (newrec_.supply_code = 'PO') AND (newrec_.status_code = '4') THEN
      newrec_.qty_on_order := newrec_.qty_due;
      Make_Requisition___(newrec_.qty_due,
                          newrec_.due_date,
                          requisition_no_,
                          line_no_,
                          release_no_,
                          newrec_.order_class,
                          newrec_.order_no,
                          newrec_.line_no,
                          newrec_.release_no,
                          newrec_.part_no,
                          newrec_.contract,
                          newrec_.order_class,
                          newrec_.condition_code,
                          newrec_.note_text);
      IF newrec_.status_code NOT IN ('1', '3', '4', '5') THEN
         $IF Component_Purch_SYS.INSTALLED $THEN
            Purchase_Req_Util_API.Activate_Requisition(requisition_no_);
         $ELSE
            NULL;
         $END
      END IF;

      Material_Requis_Pur_Order_API.New(newrec_.order_no,
                                        newrec_.line_no,
                                        newrec_.release_no,
                                        newrec_.line_item_no,
                                        Material_Requis_Type_API.Decode(newrec_.order_class),
                                        requisition_no_,
                                        line_no_,
                                        release_no_);
   END IF;
   IF Inventory_Part_API.Check_Stored( newrec_.contract, newrec_.part_no ) THEN
      Inventory_Part_API.Set_Avail_Activity_Status(newrec_.contract, newrec_.part_no);
   END IF;

   IF (Inventory_Part_Planning_API.Get_Planning_Method(newrec_.contract, newrec_.part_no) = 'N') THEN
      Order_Supply_Demand_API.Generate_Next_Level_Demands (qty_ordered_      => newrec_.qty_due,
                                                           date_required_    => newrec_.due_date,
                                                           contract_         => newrec_.contract,
                                                           part_no_          => newrec_.part_no,
                                                           configuration_id_ =>  '*',
                                                           condition_code_   => newrec_.condition_code); 
   END IF;
   Client_SYS.Add_To_Attr( 'PRE_ACCOUNTING_ID', newrec_.pre_accounting_id, attr_ );
   Client_SYS.Add_To_Attr( 'LINE_NO', newrec_.line_no, attr_ );
   Client_SYS.Add_To_Attr( 'RELEASE_NO', newrec_.release_no, attr_ );
   Client_SYS.Add_To_Attr( 'LINE_ITEM_NO', newrec_.line_item_no, attr_ );
   Client_SYS.Add_To_Attr( 'STATUS_CODE', Material_Requis_Status_API.Decode(newrec_.status_code), attr_ );
   Client_SYS.Add_To_Attr( 'QTY_SHIPPED', newrec_.qty_shipped, attr_ );
   Client_SYS.Add_To_Attr( 'QTY_RETURNED', newrec_.qty_returned, attr_ );
   Client_SYS.Add_To_Attr( 'QTY_ON_ORDER', newrec_.qty_on_order, attr_ );
   Client_SYS.Add_To_Attr( 'QTY_ASSIGNED', newrec_.qty_assigned, attr_ );
   Client_SYS.Add_To_Attr( 'UNIT_MEAS', newrec_.unit_meas, attr_ );
   Client_SYS.Add_To_Attr( 'SUPPLY_CODE', Material_Requis_Supply_API.Decode(newrec_.supply_code), attr_ );
   Client_SYS.Add_To_Attr( 'NOTE_ID', newrec_.note_id, attr_ );
   Client_SYS.Add_To_Attr( 'PROJECT_ID', newrec_.project_id, attr_ );

   IF (newrec_.activity_seq IS NOT NULL) AND (newrec_.activity_seq > 0) THEN
      Handle_Activity_Seq___(newrec_,
                             NULL);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
     Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     MATERIAL_REQUIS_LINE_TAB%ROWTYPE,
   newrec_     IN OUT MATERIAL_REQUIS_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   head_status_code_db_   MATERIAL_REQUIS_LINE_TAB.status_code%TYPE;
   requisition_no_        VARCHAR2(12);
   line_no_               VARCHAR2(4);
   release_no_            VARCHAR2(4);
   po_order_no_           VARCHAR2(12);
   po_line_no_            VARCHAR2(4);
   po_rel_no_             VARCHAR2(4);
   purchase_type_         VARCHAR2(20);   
   order_class_           MATERIAL_REQUIS_LINE.order_class%TYPE;
   head_rec_              Material_Requisition_API.Public_Rec;
   current_info_          VARCHAR2(32000);
BEGIN
   current_info_ := Client_SYS.Get_All_Info;
   order_class_  := Material_Requis_Type_API.Decode(newrec_.order_class);
   --
   -- IF SUPPLY_CODE changes or MR header state is changed
   --
   IF ((oldrec_.supply_code != newrec_.supply_code) OR
       ((oldrec_.status_code IN ('1', '3')) AND
        (newrec_.status_code = '4'))) THEN

      IF (oldrec_.supply_code != newrec_.supply_code) THEN
         Modify_supply_code___(newrec_.order_class,
                               newrec_.order_no,
                               newrec_.line_no,
                               newrec_.release_no,
                               newrec_.line_item_no,
                               oldrec_.supply_code);
      END IF;

      -- MAKE SUPPLY DEMAND
      head_rec_            := Material_Requisition_API.Get(newrec_.order_class, newrec_.order_no);
      head_status_code_db_ := head_rec_.status_code;

      IF head_status_code_db_ NOT IN ( '1', '3') THEN
         newrec_.status_code := '4';
      END IF;
      IF oldrec_.supply_code = 'IO' AND newrec_.supply_code = 'PO' THEN
         newrec_.qty_on_order := newrec_.qty_due;
      END IF;
      IF (newrec_.supply_code = 'PO') THEN   
         Material_Requis_Pur_Order_API.Get_Purchase_Link(po_order_no_,
                                                         po_line_no_,
                                                         po_rel_no_,
                                                         purchase_type_,
                                                         newrec_.order_no,
                                                         newrec_.line_no,
                                                         newrec_.release_no,
                                                         newrec_.line_item_no,
                                                         order_class_);
      END IF;
      IF ((newrec_.supply_code = 'PO') AND 
          (newrec_.status_code = '4')  AND 
          (po_order_no_ IS NULL)) THEN

         Make_Requisition___(newrec_.qty_due,
                             newrec_.due_date,
                             requisition_no_,
                             line_no_,
                             release_no_,
                             newrec_.order_class,
                             newrec_.order_no,
                             newrec_.line_no,
                             newrec_.release_no,
                             newrec_.part_no,
                             newrec_.contract,
                             newrec_.order_class,
                             newrec_.condition_code,
                             newrec_.note_text);

         IF newrec_.status_code NOT IN ('1', '3', '4') THEN
            $IF Component_Purch_SYS.INSTALLED $THEN
               Purchase_Req_Util_API.Activate_Requisition(requisition_no_);               
            $ELSE
               NULL;
            $END
         END IF;
         Material_Requis_Pur_Order_API.New(newrec_.order_no,
                                           newrec_.line_no,
                                           newrec_.release_no,
                                           newrec_.line_item_no,
                                           order_class_,
                                           requisition_no_,
                                           line_no_,
                                           release_no_);
      END IF;
   END IF;

   -- Remove the PR when MR goes to planned status
   IF ((newrec_.supply_code = 'PO') AND 
       (oldrec_.status_code = '4') AND 
       (newrec_.status_code IN ('1',3))) THEN

       Material_Requis_Pur_Order_API.Remove(newrec_.order_no,
                                            newrec_.line_no,
                                            newrec_.release_no,
                                            newrec_.line_item_no,
                                            order_class_);         
   END IF;
   --
   -- IF QTY_DUE changes
   --
   IF ((oldrec_.qty_due != newrec_.qty_due) AND (newrec_.supply_code = 'PO')) THEN

      Material_Requis_Pur_Order_API.Get_Purchase_Link(po_order_no_,
                                                      po_line_no_,
                                                      po_rel_no_,
                                                      purchase_type_,
                                                      newrec_.order_no,
                                                      newrec_.line_no,
                                                      newrec_.release_no,
                                                      newrec_.line_item_no,
                                                      order_class_);
      $IF Component_Purch_SYS.INSTALLED $THEN
         IF (purchase_type_ != 'O') THEN
            DECLARE
               vendor_no_   VARCHAR2(20);
            BEGIN
               vendor_no_ := Purchase_Req_Line_Part_API.Get_Vendor_No(po_order_no_,
                                                                      po_line_no_,
                                                                      po_rel_no_);
               Purchase_Req_Util_API.Modify_Line_Part(requisition_no_     => po_order_no_,
                                                      line_no_            => po_line_no_,
                                                      release_no_         => po_rel_no_,
                                                      original_qty_       => newrec_.qty_due,
                                                      vendor_no_          => vendor_no_,
                                                      server_data_change_ => 'TRUE');
            END;
            newrec_.qty_on_order := newrec_.qty_due;
         END IF;
      $END      
   END IF;

   IF (newrec_.activity_seq IS NOT NULL) AND (newrec_.activity_seq > 0) THEN
      IF ((oldrec_.activity_seq IS NULL) OR (oldrec_.activity_seq != newrec_.activity_seq)) THEN
         $IF Component_Proj_SYS.INSTALLED $THEN
            newrec_.project_id := Activity_API.Get_Project_Id(newrec_.activity_seq);            
         $ELSE
            Error_SYS.Record_General(lu_name_, 'ACTIVITYNOTINST: Activity Sequence may not be set since Activity is not installed.');
         $END
      END IF;
   ELSE
      newrec_.project_id := NULL;
   END IF;

   IF (newrec_.supply_code = 'PO' AND newrec_.status_code IN ('4', '5', '7')) THEN
      newrec_.qty_on_order := LEAST(newrec_.qty_on_order, (newrec_.qty_due - (newrec_.qty_assigned + newrec_.qty_shipped)));
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr( 'STATUS_CODE', Material_Requis_Status_API.Decode(newrec_.status_code), attr_ );
   Client_SYS.Add_To_Attr( 'PROJECT_ID', newrec_.project_id, attr_ );   

   IF ((newrec_.qty_returned != oldrec_.qty_returned) OR (newrec_.qty_due != oldrec_.qty_due)) THEN
      Material_Requisition_API.Modify_Total_Value__(Material_Requis_Type_API.Decode(newrec_.order_class),
                                                    newrec_.order_no, 'TRUE');
   END IF;

   IF (NVL(oldrec_.activity_seq, -9999) != NVL(newrec_.activity_seq, -9999)) THEN
      Handle_Activity_Seq___(newrec_, oldrec_.activity_seq);

   ELSIF (newrec_.activity_seq IS NOT NULL) AND (newrec_.activity_seq > 0) AND 
          ((oldrec_.qty_assigned != newrec_.qty_assigned) OR 
           (oldrec_.qty_shipped  != newrec_.qty_shipped) OR 
           (oldrec_.status_code  != newrec_.status_code) OR 
           (oldrec_.supply_code  != newrec_.supply_code))THEN
      Calculate_Cost_And_Progress(order_class_, newrec_.order_no, newrec_.line_no, newrec_.release_no, newrec_.line_item_no);
   END IF;

   IF (newrec_.qty_due > oldrec_.qty_due) THEN
     IF (Inventory_Part_Planning_API.Get_Planning_Method(newrec_.contract, newrec_.part_no) = 'N') THEN
        Order_Supply_Demand_API.Generate_Next_Level_Demands (qty_ordered_      => newrec_.qty_due,
                                                             date_required_    => newrec_.due_date,
                                                             contract_         => newrec_.contract,
                                                             part_no_          => newrec_.part_no,
                                                             configuration_id_ =>  '*',
                                                             condition_code_   => newrec_.condition_code); 
     END IF;
   END IF;
   
   -- Reduce MS foreast for issued qty
   IF (newrec_.supply_code IN ('IO', 'PI') AND (newrec_.qty_shipped != oldrec_.qty_shipped)) THEN
      Update_Ms_Forecast___(newrec_.contract, 
                            newrec_.part_no, 
                            newrec_.activity_seq, 
                            (newrec_.qty_shipped - oldrec_.qty_shipped), 
                            newrec_.due_date);
   END IF;
   
   IF (oldrec_.qty_due != newrec_.qty_due) OR (oldrec_.due_date != newrec_.due_date) THEN
      IF (newrec_.supply_code = 'PO') THEN            
         IF (Material_Requis_Pur_Order_API.Connected_To_Purchase_Order(newrec_.order_no,
                                                                       newrec_.line_no,
                                                                       newrec_.release_no,
                                                                       newrec_.line_item_no,
                                                                       newrec_.order_class)) THEN
            IF (oldrec_.qty_due != newrec_.qty_due) THEN
               Client_SYS.Add_Info(lu_name_, 'QTY_DUE_UPDATE: The modification of due quantity has not been propagated to the connected purchase order line.');
            END IF;
   
            IF (oldrec_.due_date != newrec_.due_date) THEN
               Client_SYS.Add_Info(lu_name_,'DUE_DATE_UPDATE: The modification of due date has not been propagated to the connected purchase order line.');
            END IF;
         END IF;
      END IF;
   END IF;
   
   IF ((newrec_.qty_due      < oldrec_.qty_due    ) AND
       (newrec_.qty_due      = newrec_.qty_shipped) AND
       (newrec_.qty_assigned = 0                  ) AND
       (newrec_.supply_code != 'PO'               ) AND 
       (newrec_.status_code  = '7'                )) THEN
      -- Automatically close MR line when qty_due has been reduced to meet qty_shipped.
      Close__(order_class_,
              newrec_.order_no,
              newrec_.line_no,
              newrec_.release_no,
              newrec_.line_item_no);
   END IF;

   Client_SYS.Merge_Info(current_info_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN MATERIAL_REQUIS_LINE_TAB%ROWTYPE )
IS
   po_order_no_                  VARCHAR2(12);
   po_line_no_                   VARCHAR2(4);
   po_rel_no_                    NUMBER;
   purchase_type_                VARCHAR2(200);   
   purch_order_line_objstate_    VARCHAR2(20);
   purch_req_line_objstate_      VARCHAR2(20);
BEGIN
   IF remrec_.status_code NOT IN ('4','1') THEN
      Error_SYS.Record_General('MaterialRequisLine', 'DELETE_REQUISITION: Only material requisition lines with status :P1 or :P2 are allowed to be removed.', Material_Requis_Status_API.Decode('4'), Material_Requis_Status_API.Decode('1'));
   END IF;
   
   Material_Requis_Pur_Order_API.Get_Purchase_Link(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,remrec_.order_no, remrec_.line_no, remrec_.release_no, remrec_.line_item_no, remrec_.order_class);

   -- Modification done since the purchase requisition line can have Request created even line state not Request Created. 
   $IF Component_Purch_SYS.INSTALLED $THEN
      purch_req_line_objstate_ := Purchase_Req_Line_API.Get_Requisition_Line_Objstate( po_order_no_, po_line_no_, po_rel_no_);
      
      IF purchase_type_  = 'R' AND purch_req_line_objstate_ != 'Planned' AND purch_req_line_objstate_ IS NOT NULL THEN
         Error_SYS.Record_General('MaterialRequisLine', 'CHECKRL_STATUS: Modification is not allowed when Purchase Requisition Line is open ');
      END IF;
      
      purch_order_line_objstate_ := Purchase_Order_Line_API.Get_Objstate( po_order_no_, po_line_no_, po_rel_no_ );
      
      IF purchase_type_  = 'O' AND purch_order_line_objstate_ != 'Cancelled' AND purch_order_line_objstate_ IS NOT NULL THEN
         Error_SYS.Record_General('MaterialRequisLine', 'CHECKPO_STATUS: Modification is not allowed when Purchase Order Line is open ');
      END IF;
   $ELSE      
      NULL;
   $END
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN MATERIAL_REQUIS_LINE_TAB%ROWTYPE )
IS
   lu_rec_           MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   line_status_code_ VARCHAR2(2);   
   dummy_            VARCHAR2(10) := NULL;
   all_lines_closed_ BOOLEAN := FALSE;

   CURSOR get_line_status IS
      SELECT status_code
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_class = remrec_.order_class
      AND    order_no    = remrec_.order_no;
BEGIN
   -- modify_supply_code
   lu_rec_ := Get_Object_By_Id___(objid_);
   Modify_Supply_Code___( lu_rec_.order_class, lu_rec_.order_no,  lu_rec_.line_no, lu_rec_.release_no, lu_rec_.line_item_no, lu_rec_.supply_code);

   IF (remrec_.activity_seq IS NOT NULL) AND (remrec_.activity_seq > 0) THEN
      $IF Component_Proj_SYS.INSTALLED $THEN         
         Project_Connection_Util_API.Remove_Connection(
                                          proj_lu_name_     => 'MTRLREQLINE',
                                          activity_seq_     => remrec_.activity_seq,
                                          keyref1_          => remrec_.order_class,
                                          keyref2_          => remrec_.order_no,
                                          keyref3_          => remrec_.line_no,
                                          keyref4_          => remrec_.release_no,
                                          keyref5_          => remrec_.line_item_no,
                                          keyref6_          => dummy_);
      $ELSE
         NULL;
      $END
   END IF;

   Pre_Accounting_API.Remove_Accounting_Id(remrec_.pre_accounting_id);
   super(objid_, remrec_);

   OPEN get_line_status;
   LOOP
     FETCH get_line_status INTO line_status_code_;
     EXIT WHEN get_line_status%NOTFOUND;
     IF (line_status_code_ = '9') THEN
        all_lines_closed_ := TRUE;
     ELSE
        all_lines_closed_ := FALSE;
        EXIT;
     END IF;
   END LOOP;
   CLOSE get_line_status;

   IF (all_lines_closed_) THEN
      Material_Requisition_API.Change_status(Material_Requis_Type_API.Decode(remrec_.order_class), remrec_.order_no, Material_Requis_Status_API.Decode('9'));
   END IF;
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT material_requis_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                VARCHAR2(30);
   value_               VARCHAR2(4000);
   dummy_               INVENTORY_PART_TAB.Description%TYPE;
   supply_code_         MATERIAL_REQUIS_LINE.supply_code%TYPE;
   new_supply_code_     MATERIAL_REQUIS_LINE.supply_code%TYPE;   
   head_status_code_db_ MATERIAL_REQUIS_LINE_TAB.status_code%TYPE;  
   part_catalog_rec_    Part_Catalog_API.Public_Rec;
   head_rec_            Material_Requisition_API.Public_Rec;
BEGIN
   --
   -- GET MANDATORY DATA
   --
   head_rec_ := Material_Requisition_API.Get(newrec_.order_class, newrec_.order_no);   
   IF NOT(indrec_.status_code) THEN
      newrec_.status_code := head_rec_.status_code;
   END IF;
   head_status_code_db_ := newrec_.status_code;

   newrec_.qty_assigned := 0;
   newrec_.qty_on_order := 0;
   newrec_.qty_returned := 0;
   newrec_.qty_shipdiff := 0;
   newrec_.qty_shipped  := 0;
   newrec_.qty_short    := 0;
      
   $IF NOT Component_Proj_SYS.INSTALLED $THEN 
      IF (newrec_.activity_seq IS NOT NULL) AND (indrec_.activity_seq)THEN  
         Error_SYS.Record_General(lu_name_, 'ACTIVITYNOTINST: Activity Sequence may not be set since Activity is not installed.');
      END IF;
   $END 
   
   -- Validate PART_NO
   --
   IF newrec_.supply_code IS NULL THEN
      new_supply_code_    := Inventory_Part_API.Get_Supply_Code(newrec_.contract, newrec_.part_no);
      newrec_.supply_code := Material_Requis_Supply_API.Encode(new_supply_code_);
   END IF;

   supply_code_ := Material_Requis_Supply_API.Decode(newrec_.supply_code);
   Check_Part_No__(dummy_, supply_code_, newrec_.unit_meas, newrec_.part_no, newrec_.contract);
   --
   IF newrec_.supply_code = 'PO' THEN
      newrec_.qty_on_order := newrec_.qty_due;
   END IF;
   

   IF (newrec_.activity_seq IS NOT NULL) AND (newrec_.activity_seq > 0) THEN
      Validate_Proj_Connect___(newrec_.project_id,
                               newrec_.supply_code,
                               newrec_.contract,
                               newrec_.status_code,
                               newrec_.activity_seq,
                               NULL,
                               newrec_.due_date);
   END IF;

   super(newrec_, indrec_, attr_);

   IF (head_status_code_db_ = 9) THEN
      Error_SYS.Record_General(lu_name_, 'CLOSEDREQ: New lines cannot be added to a closed requisition.');
   END IF;
   IF newrec_.supply_code = 'PO' THEN
      $IF NOT Component_Purch_SYS.INSTALLED $THEN      
         Error_SYS.Record_General('MaterialRequisLine', 'POSUPPCODE: This supply code is not allowed when the purchase module is not installed.');
      $ELSE
         NULL;
      $END
   END IF;
   --
   IF newrec_.supply_code = 'IO' AND NOT Inventory_Part_API.Check_Stored( newrec_.contract, newrec_.part_no ) THEN
      Error_SYS.Record_General('MaterialRequisLine', 'WRONG_SUPPLY_CODE: A non inventory purchase part cannot be supplied from inventory.');
   END IF;
   --
   IF((newrec_.activity_seq IS NULL) AND (newrec_.supply_code = 'PI')) THEN
      Error_SYS.Record_General(lu_name_, 'ACTIVITYSEQNULL: You cannot use the supply method project inventory unless the requisition line is  previously connected to a project activity.');
   END IF;
   --
   IF head_status_code_db_ NOT IN ('1', '3') THEN
      newrec_.status_code := '4';
   END IF;
   -----------------------------------------
   -- Check that wanted due_date is a work_day
   -----------------------------------------
   IF (Work_Time_Calendar_API.Is_Working_Day (Site_API.Get_Dist_Calendar_Id (newrec_.contract),
                                              newrec_.due_date)= 0) THEN
      Raise_Calendar_Error___(newrec_.contract, newrec_.due_date);
   END IF;

   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);

   -- check if wanted part is a configured part - not allowed.
   IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
      Error_SYS.Record_General('MaterialRequisLine','ISCONFIGURED: Part is configured and cannot be supplied from inventory.');
   END IF;

   -- Check if Planning Method is in (K,T,O) - not allowed
   IF (Inventory_Part_Planning_API.Get_Planning_Method(newrec_.contract, newrec_.part_no) IN ('K','T','O')) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGMRP: Parts with Planning Method K, T or O cannot be supplied from Inventory.');
   END IF;

   -- Validations for Condition Code
   IF (newrec_.condition_code IS NOT NULL) THEN
      IF (part_catalog_rec_.condition_code_usage = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      ELSE
         Condition_Code_API.Exist(newrec_.condition_code);
      END IF;
   ELSE
      IF (part_catalog_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
         newrec_.condition_code := Condition_Code_API.Get_Default_Condition_Code;
         -- Condition code should be used for this part. Pass the default value to the client.
         Client_SYS.Add_To_Attr('CONDITION_CODE', newrec_.condition_code, attr_);
      END IF;
   END IF;

   IF (newrec_.qty_due < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGQTY: The quantity due cannot be less than 0.');
   END IF;

   IF (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true AND MOD(newrec_.qty_due, 1) != 0) THEN
      Error_SYS.Record_General(lu_name_, 'SERQTY: The quantity due must be an integer for serial tracked parts.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     material_requis_line_tab%ROWTYPE,
   newrec_ IN OUT material_requis_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                        VARCHAR2(30);
   value_                       VARCHAR2(4000);
   io_delivered_                EXCEPTION;
   io_reserved_                 EXCEPTION;
   condition_code_required      EXCEPTION;   
   part_catalog_rec_            Part_Catalog_API.Public_Rec;
   inventory_part_rec_          Inventory_Part_API.Public_Rec;
   shortage_handl_system_param_ VARCHAR2(2000);
BEGIN
   $IF NOT Component_Proj_SYS.INSTALLED $THEN 
      IF (newrec_.activity_seq IS NOT NULL) AND (indrec_.activity_seq)THEN  
         Error_SYS.Record_General(lu_name_, 'ACTIVITYNOTINST: Activity Sequence may not be set since Activity is not installed.');
      END IF;
   $END
   --
   super(oldrec_, newrec_, indrec_, attr_);

   IF (NVL(oldrec_.activity_seq, -9999) != NVL(newrec_.activity_seq, -9999)) THEN
      IF (newrec_.activity_seq IS NOT NULL) AND (newrec_.activity_seq > 0) THEN
         Validate_Proj_Connect___(newrec_.project_id,
                                  newrec_.supply_code,
                                  newrec_.contract,
                                  newrec_.status_code,
                                  newrec_.activity_seq,
                                  oldrec_.activity_seq,
                                  newrec_.due_date);         
      ELSE
          Validate_Proj_Disconnect___ (newrec_.project_id ,
                                       newrec_.supply_code,
                                       newrec_.status_code);
      END IF;
   END IF;

   IF (oldrec_.qty_shipped < newrec_.qty_shipped) THEN
      newrec_.qty_returned := 0;
   END IF;

   inventory_part_rec_ := Inventory_Part_API.Get(newrec_.contract, newrec_.part_no);
   --
   -- Validate SUPPLY_CODE
   --
   IF ((newrec_.supply_code = 'IO') AND (inventory_part_rec_.part_no IS NULL)) THEN
      Error_SYS.Record_General('MaterialRequisLine', 'WRONG_SUPPLY_CODE: A non inventory purchase part cannot be supplied from inventory.');
   END IF;

   IF newrec_.supply_code = 'PO' THEN
      $IF NOT Component_Purch_SYS.INSTALLED $THEN
         Error_SYS.Record_General('MaterialRequisLine', 'POSUPPCODE: This supply code is not allowed when the purchase module is not installed.');
      $END

      IF (newrec_.activity_seq > 0) THEN
         Error_SYS.Record_General('MaterialRequisLine', 'POSUPPNOTALLOW: Supply code :P1 is not allowed when the material requisition line is connected to a project activity.', Material_Requis_Supply_API.Decode(newrec_.supply_code));
      END IF;
   ELSIF  newrec_.supply_code = 'IO' THEN
      newrec_.qty_on_order := 0;
   END IF;

   IF((newrec_.activity_seq IS NULL) AND (newrec_.supply_code = 'PI')) THEN
      Error_SYS.Record_General(lu_name_, 'ACTIVITYSEQNULL: You cannot use the supply method project inventory unless the requisition line is  previously connected to a project activity.');
   END IF;

   IF ((oldrec_.qty_due != newrec_.qty_due) OR (oldrec_.qty_returned != newrec_.qty_returned)) THEN
      IF (newrec_.qty_due < newrec_.qty_returned) THEN
         Error_SYS.Record_General('MaterialRequisLine', 'DUE_GREATER_RETURN: Quantity returned cannot be greater than quantity due.');
      END IF;
   END IF;

   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);

   IF (oldrec_.qty_due != newrec_.qty_due) THEN
      IF (newrec_.qty_due < 0) THEN
         Error_SYS.Record_General(lu_name_, 'NEGQTY: The quantity due cannot be less than 0.');
      END IF;
      IF (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true AND MOD(newrec_.qty_due, 1) != 0) THEN
         Error_SYS.Record_General(lu_name_, 'SERQTY: The quantity due must be an integer for serial tracked parts.');
      END IF;
   END IF;

   shortage_handl_system_param_ := Mpccom_System_Parameter_API.Get_parameter_value1('SHORTAGE_HANDLING');
   --
   -- Check if DUE_DATE is allowed to be changed
   --
   IF oldrec_.due_date != newrec_.due_date THEN
      IF (newrec_.supply_code = 'IO') THEN
         IF (newrec_.status_code NOT IN ('1', '3', '4', '5', '7')) THEN  
            Error_SYS.Record_General('MaterialRequisLine', 'NO_STATUS_UPDATE: The material requisition cannot be changed .');
         END IF;
      END IF;
   -----------------------------------------
   -- Check that wanted due_date is a work_day
   -----------------------------------------
      IF (Work_Time_Calendar_API.Is_Working_Day (Site_API.Get_Dist_Calendar_Id (newrec_.contract),
                                              newrec_.due_date)= 0) THEN
         Raise_Calendar_Error___(newrec_.contract, newrec_.due_date);
      END IF;
   END IF;

   --
   --   IF QTY_DUE changes or STATUS_CODE is planned
   --
   IF oldrec_.qty_due != newrec_.qty_due OR newrec_.status_code = '1' THEN
      IF newrec_.supply_code IN ('IO', 'PI') THEN
         IF (oldrec_.status_code = '9' AND oldrec_.qty_shipped > 0) OR (oldrec_.qty_shipped > newrec_.qty_due) THEN
            RAISE io_delivered_;
         ELSIF (oldrec_.qty_assigned + oldrec_.qty_shipped) > newrec_.qty_due THEN
            RAISE io_reserved_;
         END IF;
        IF ((shortage_handl_system_param_ = 'Y') AND (inventory_part_rec_.shortage_flag = Inventory_Part_Shortage_API.DB_SHORTAGE_NOTATION)) THEN
           IF (oldrec_.qty_due > newrec_.qty_due)
           AND (newrec_.qty_due < newrec_.qty_short + newrec_.qty_assigned)
           AND (NVL(oldrec_.qty_short,0) > 0) THEN
               newrec_.qty_short := newrec_.qty_due - newrec_.qty_assigned - newrec_.qty_shipped;
           END IF;
        ELSE
          newrec_.qty_short := 0;
        END IF;
      END IF;
   END IF;

   IF (newrec_.qty_due = newrec_.qty_assigned + newrec_.qty_shipped)
       OR newrec_.status_code NOT IN ('4', '5', '7') THEN
      newrec_.qty_short := 0;
   END IF;

   IF ((shortage_handl_system_param_ = 'N') OR (inventory_part_rec_.shortage_flag = Inventory_Part_Shortage_API.DB_NO_SHORTAGE_NOTATION)) THEN
      newrec_.qty_short := 0;
   END IF;

   -- check if wanted part is a configured part - not allowed.
   IF (part_catalog_rec_.configurable = 'CONFIGURED') THEN
      Error_SYS.Record_General('MaterialRequisLine','ISCONFIGURED: Part is configured and cannot be supplied from inventory.');
   END IF;

   -- Check if Planning Method is in (K,T,O) - not allowed
   IF (Inventory_Part_Planning_API.Get_Planning_Method(newrec_.contract, newrec_.part_no) IN ('K','T','O')) THEN
      Error_SYS.Record_General(lu_name_, 'WRONGMRP: Parts with Planning Method K, T or O cannot be supplied from Inventory.');
   END IF;

   -- Validations for Condition Code
   IF (NVL(oldrec_.condition_code,'*') != NVL(newrec_.condition_code,'*')) AND
      (newrec_.status_code NOT IN ('1', '4')) THEN
      Error_SYS.Record_General(lu_name_,'COND_UPD_NOTALLOW: Condition code may not be changed after reservations and/or deliveries have been made for the line.');
   END IF;
   IF (newrec_.condition_code IS NOT NULL) THEN
      IF (part_catalog_rec_.condition_code_usage = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      ELSE
         Condition_Code_API.Exist(newrec_.condition_code);
      END IF;
   ELSE
      IF (part_catalog_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
         IF (oldrec_.qty_assigned > newrec_.qty_assigned ) OR (oldrec_.qty_due > newrec_.qty_due )OR (oldrec_.qty_short < newrec_.qty_short )OR
            ((newrec_.status_code != oldrec_.status_code) AND (newrec_.status_code = '9')) THEN
            IF Check_Attribute_Modified___ (newrec_, oldrec_) THEN
               RAISE condition_code_required; 
            END IF;
         ELSE
            RAISE condition_code_required;
         END IF;
      END IF;
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
   WHEN io_delivered_ THEN
      Error_SYS.Record_General('MaterialRequisLine', 'IO_DELIVERED: Cannot change quantity order line already delivered.');
   WHEN io_reserved_ THEN
      Error_SYS.Record_General('MaterialRequisLine', 'IO_RESERVED: Cannot change quantity too many reserved.');
   WHEN condition_code_required THEN
      Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW0: Condition code functionality is enabled in the part catalog record for this part. You must enter a condition code.');
END Check_Update___;


PROCEDURE Raise_Calendar_Error___ (
   contract_    VARCHAR2,
   due_date_    DATE
   )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'NOT_IN_CAL_UCHIN: :P1 is not a workday in calendar :P2.', to_char(due_date_, 'YYYY-MM-DD'), Site_API.Get_Dist_Calendar_Id (contract_));
END Raise_Calendar_Error___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Check_Part_No__
--   Fetches part description, supplier and unit of measure.
--   The data is fetched from inventory if it's an inventory part otherwise
--   the data is fetched from purchase.
PROCEDURE Check_Part_No__ (
   description_ IN OUT VARCHAR2,
   supply_code_ IN OUT VARCHAR2,
   unit_meas_   IN OUT VARCHAR2,
   part_no_     IN     VARCHAR2,
   contract_    IN     VARCHAR2 )
IS
   new_unit_meas_    MATERIAL_REQUIS_LINE.unit_meas%TYPE;
   supplier_         VARCHAR2(20);   
   part_stat_desc_   VARCHAR2(35);
   part_rec_         Inventory_Part_API.public_rec;
BEGIN
   part_rec_ := Inventory_Part_API.Get(contract_, part_no_);
   IF part_rec_.part_no IS NOT NULL THEN
      IF (Inventory_Part_Status_Par_API.Get_Demand_Flag_Db(part_rec_.part_status) = 'N') THEN
         part_stat_desc_ := Inventory_Part_Status_Par_API.Get_Description(part_rec_.part_status);
         Error_SYS.Record_General(lu_name_, 'NOTDEMAND: Inventory part :P1 has part status :P2 which does not allow demands', part_no_ , part_stat_desc_);
      END IF;
      description_   := Inventory_Part_API.Get_Description(contract_, part_no_);
      new_unit_meas_ := part_rec_.unit_meas;
      supply_code_   := Material_Requis_Supply_API.Decode(part_rec_.supply_code);
   ELSE
      $IF Component_Purch_SYS.INSTALLED $THEN
         description_ := Purchase_Part_API.Get_Description(contract_, part_no_);

         IF description_ IS NULL THEN
            Error_SYS.Record_General('MaterialRequisLine', 'NO_INVENTORY_PART: Part :P1 at Site :P2 does not exist.',part_no_,contract_);
         END IF;

         supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, part_no_);
         IF supplier_ IS NULL THEN
            new_unit_meas_ := Purchase_Part_API.Get_Default_Buy_Unit_Meas( contract_ , part_no_);            
         ELSE
            new_unit_meas_ := Purchase_Part_Supplier_API.Get_buy_unit_meas( contract_ , part_no_, supplier_);
         END IF;
         supply_code_ := Material_Requis_Supply_API.Decode('PO');
      $ELSE
         Error_SYS.Record_General('MaterialRequisLine', 'NO_PURPART_LU: The module IFS/Purchase is not installed. Only inventory parts can be registered');
      $END
   END IF;
   unit_meas_ := Nvl(new_unit_meas_, unit_meas_);

END Check_Part_No__;


-- Close__
--   Close (set the state to closed, db_value=9) the Material Requisition line
--   when the qty_assigned is 0 and the state is partially delivered (db_value=7).
PROCEDURE Close__ (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   attr_        VARCHAR2(32000);
   lu_rec_      MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   status_db_   MATERIAL_REQUIS_LINE_TAB.status_code%TYPE;
   found_       VARCHAR2(1);
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
   non_invent_po_line_cancelled_ BOOLEAN := FALSE;
   --
   CURSOR line_status IS
      SELECT 'X'
      FROM  MATERIAL_REQUIS_LINE_TAB
      WHERE order_class  = order_class_db_
      AND   order_no     = order_no_
      AND   status_code  IN ('1', '3', '4', '5', '7');
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   lu_rec_ := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   IF (lu_rec_.status_code IN ('1', '3', '4', '5', '9')) OR
      ((lu_rec_.status_code = '7') AND (lu_rec_.qty_assigned != 0)) THEN
      IF (lu_rec_.status_code = '4' AND Inventory_Part_API.Part_Exist (lu_rec_.contract, lu_rec_.part_no) != 1
        AND Material_Requis_Pur_Order_API.Connected_Po_Line_Cancelled(lu_rec_.order_no, 
                                                                      lu_rec_.line_no, 
                                                                      lu_rec_.release_no, 
                                                                      lu_rec_.line_item_no, 
                                                                      lu_rec_.order_class) = 1 ) THEN
         non_invent_po_line_cancelled_ := TRUE;
      ELSE
         Error_SYS.Record_General('MaterialRequisLine','NOALLOWED_CLOSE: Close is only allowed if status is :P1 and qty reserved is 0', Material_Requis_Status_API.Decode('7'));
      END IF;
   END IF;

   IF (lu_rec_.supply_code = 'PO') AND (NOT non_invent_po_line_cancelled_) AND (Material_Requis_Pur_Order_API.Connected_To_Open_Purord_Line( lu_rec_.order_no, 
                                                                                                    lu_rec_.line_no, 
                                                                                                    lu_rec_.release_no, 
                                                                                                    lu_rec_.line_item_no, 
                                                                                                    lu_rec_.order_class)) THEN      
      Error_SYS.Record_General(lu_name_, 'NOMRLINECLOSE: The Material Requisition Line cannot be closed since a connected Purchase Order Line is still open.' );  
   END IF; 

   status_db_ := '9';

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'STATUS_CODE_DB', status_db_, attr_ );
   Modify_impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   OPEN line_status;
   FETCH line_status INTO found_;
   IF (line_status%FOUND) THEN
      Material_Requisition_API.Change_status(order_class_, order_no_, Material_Requis_Status_API.Decode('7'));
   ELSE
      Material_Requisition_API.Change_status(order_class_, order_no_, Material_Requis_Status_API.Decode('9'));
   END IF;
   CLOSE line_status;
END Close__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Change_Qty_Assigned
--   Sets quantity assigned and status on the requisition line
PROCEDURE Change_Qty_Assigned (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_assigned_ IN NUMBER,
   status_code_  IN VARCHAR2 )
IS
   attr_            VARCHAR2(32000);
   status_code_db_  MATERIAL_REQUIS_LINE_TAB.status_code%TYPE;
   supply_code_db_  MATERIAL_REQUIS_LINE_TAB.supply_code%TYPE;
   status_code_2_   MATERIAL_REQUIS_LINE.status_code%TYPE;
   status_code_3_   MATERIAL_REQUIS_LINE.status_code%TYPE;
   status_code_4_   MATERIAL_REQUIS_LINE.status_code%TYPE;
   order_class_db_  MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;

   CURSOR get_attr IS
      SELECT status_code, supply_code
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_class = order_class_db_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = release_no_
      AND    line_item_no = line_item_no_;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   OPEN  get_attr;
   FETCH get_attr INTO status_code_db_, supply_code_db_;
   CLOSE get_attr;
   IF (status_code_db_ IN ('1', '3', '9')) THEN
      status_code_2_ := Material_Requis_Status_API.Decode('4');
      status_code_3_ := Material_Requis_Status_API.Decode('5');
      status_code_4_ := Material_Requis_Status_API.Decode('7');
      Error_SYS.Record_General('MaterialRequisLine','NOALLOWED_STATUS: Reservation is only allowed in status :P1, :P2 and :P3', status_code_2_,status_code_3_,status_code_4_);
   END IF;
   IF (supply_code_db_ = 'PO') THEN
      Error_SYS.Record_General('MaterialRequisLine', 'NOALLOWED_SUPPLYCODE: Reservation is not allowed for :P1', Material_Requis_Supply_API.Decode('PO'));
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
   Client_SYS.Add_To_Attr('STATUS_CODE', status_code_, attr_);
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
END Change_Qty_Assigned;


-- Change_Status
--   Set a new status on the requisition line
PROCEDURE Change_Status (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   status_code_  IN VARCHAR2 )
IS
   attr_              VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'STATUS_CODE', status_code_, attr_ );
   --
   Modify_Impl___(attr_, Material_Requis_Type_API.Encode(order_class_), order_no_, line_no_, release_no_, line_item_no_);
   --
END Change_Status;


-- Check_Status
--   The method returns FALSE if the requisition line status is 3 (Freezed),
--   4 (Activ) and 5 (Linked) otherwise TRUE
@UncheckedAccess
FUNCTION Check_Status (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN BOOLEAN
IS
   status_code_db_  MATERIAL_REQUIS_LINE_TAB.status_code%TYPE;
   order_class_db_  MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
   CURSOR get_attr IS
      SELECT status_code
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_class = order_class_db_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = release_no_
      AND    line_item_no = line_item_no_;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   OPEN  get_attr;
   FETCH get_attr INTO status_code_db_;
   CLOSE get_attr;
   IF status_code_db_ IN ('5','7','9')THEN
      RETURN FALSE;
   END IF;
   RETURN TRUE;
END Check_Status;


-- Get_Qty_Demand
--   Gets the quantity demand on the requisition line.
@UncheckedAccess
FUNCTION Get_Qty_Demand (
   part_no_  IN VARCHAR2,
   contract_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_demand_int IS
      SELECT nvl(SUM(qty_due - qty_assigned - qty_shipped), 0)
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  part_no      = part_no_
      AND    contract     = contract_
      AND    status_code IN ('4', '5', '7')
      AND    (qty_due - qty_assigned - qty_shipped) > 0;
   qty_demand_ NUMBER;
BEGIN
   OPEN get_demand_int;
   FETCH get_demand_int INTO qty_demand_;
   CLOSE get_demand_int;
   RETURN qty_demand_ ;
END Get_Qty_Demand;


-- Get_Qty_To_Assign
--   Gets the quantity to assign for the requisition line
@UncheckedAccess
FUNCTION Get_Qty_To_Assign (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_           NUMBER;
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
   CURSOR get_attr IS
      SELECT nvl(qty_due, 0) - nvl(qty_assigned, 0) - nvl(qty_shipped, 0)
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_class = order_class_db_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    release_no = release_no_
      AND    line_item_no = line_item_no_;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   OPEN  get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   IF (temp_ IS NULL) THEN
      RETURN 0;
   END IF;
   RETURN temp_;
END Get_Qty_To_Assign;

-- Lock_And_Get
--   Lock and Get the record
@UncheckedAccess
FUNCTION Lock_And_Get (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN Public_Rec
IS
BEGIN
   RETURN Table_To_Public___(Lock_By_Keys_Nowait___(Material_Requis_Type_API.Encode(order_class_), order_no_, line_no_, release_no_, line_item_no_));   
END Lock_And_Get;

-- Make_Line_Reservations
--   Makes the reservation against inventory.
PROCEDURE Make_Line_Reservations (
   qty_left_           IN OUT NUMBER,
   order_class_        IN     VARCHAR2,
   order_no_           IN     VARCHAR2,
   line_no_            IN     VARCHAR2,
   release_no_         IN     VARCHAR2,
   line_item_no_       IN     NUMBER,
   qty_to_reserve_     IN     NUMBER,
   availability_check_ IN     VARCHAR2 DEFAULT NULL )
IS
   lu_rec_                      MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   qty_reserve_                 NUMBER;
   line_reserved_qty_           NUMBER;
   next_analysis_date_          DATE;
   dummy_date_                  DATE;
   onhand_analysis_flag_        VARCHAR2(200);
   result_                      VARCHAR2(20);
   qty_possible_                NUMBER;
   orig_qty_short_              NUMBER;
   orig_qty_reserve_            NUMBER;
   order_class_db_              MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
   objid_                       MATERIAL_REQUIS_LINE.objid%TYPE;
   objversion_                  MATERIAL_REQUIS_LINE.objversion%TYPE;
   qty_to_assign_               NUMBER;
   activity_seq_                NUMBER;
   project_id_                  VARCHAR2(10);
   material_allocation_         VARCHAR2(30);
   site_date_                   DATE;
   stock_keys_and_qty_tab_      Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
BEGIN
   order_class_db_    := Material_Requis_Type_API.Encode(order_class_);
   lu_rec_            := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   line_reserved_qty_ := lu_rec_.qty_assigned;
   site_date_         := TRUNC(Site_API.Get_Site_Date(lu_rec_.contract));
   qty_to_assign_     := Get_Qty_To_Assign(order_class_, order_no_, line_no_, release_no_, line_item_no_);

   IF qty_to_reserve_ IS NULL THEN
      qty_reserve_ := qty_to_assign_;
   ELSE
      qty_reserve_ := qty_to_reserve_;
   END IF;

   IF (qty_reserve_ > qty_to_assign_) THEN
      Error_SYS.Record_General('MaterialRequisLine','RESERVE: Cannot reserve more then the quantity short.');
   END IF;

   orig_qty_reserve_ := nvl(qty_reserve_,0);

   IF (NVL(availability_check_,'Y') = 'Y') THEN

      onhand_analysis_flag_ := Inventory_Part_API.Get_Onhand_Analysis_Flag(lu_rec_.contract, lu_rec_.part_no);

      IF (onhand_analysis_flag_ = Inventory_Part_Onh_Analys_API.Decode('Y')) THEN

         IF lu_rec_.supply_code = 'PI' THEN
            Inventory_Part_In_Stock_API.Make_Onhand_Analysis ( result_,
                                                               qty_possible_,
                                                               next_analysis_date_,
                                                               dummy_date_,
                                                               site_date_,
                                                               lu_rec_.contract,
                                                               lu_rec_.part_no,
                                                               '*',
                                                               'FALSE',
                                                               'TRUE',
                                                               lu_rec_.project_id,
                                                               NULL,
                                                               objid_,
                                                               qty_reserve_ );
         ELSE
            Inventory_Part_In_Stock_API.Make_Onhand_Analysis ( result_,
                                                               qty_possible_,
                                                               next_analysis_date_,
                                                               dummy_date_,
                                                               site_date_,
                                                               lu_rec_.contract,
                                                               lu_rec_.part_no,
                                                               '*',
                                                               'TRUE',
                                                               'FALSE',
                                                               NULL,
                                                               NULL,
                                                               objid_,
                                                               qty_reserve_ );
         END IF;

         IF result_ IN ('INSIDE_LEADTIME', 'OUTSIDE_LEADTIME') THEN
             Error_SYS.Record_General('MaterialRequisLine', 'ERROR_QTY_POS: Only :P1 is plannable on the delivery date entered for the part :P2.', To_Char(qty_possible_),lu_rec_.part_no);
         END IF;
      END IF;
   END IF;

   FOR j IN 1..2 LOOP
      IF j = 1 THEN
         project_id_ := NULL;
         IF lu_rec_.supply_code = 'PI' THEN
            activity_seq_ := lu_rec_.activity_seq;
         ELSE
            activity_seq_ := 0;
         END IF;
      ELSE
         IF lu_rec_.supply_code = 'PI' AND qty_reserve_ > 0 THEN
            $IF Component_Proj_SYS.INSTALLED $THEN
               material_allocation_ := Project_API.Get_Material_Allocation_Db(lu_rec_.project_id);            
            $END

            IF (material_allocation_ = 'WITHIN_PROJECT') THEN
               activity_seq_ := NULL;
               project_id_   := lu_rec_.project_id;
            ELSE
               EXIT;
            END IF;
         ELSE
            EXIT;
         END IF;
      END IF;
      Inventory_Part_In_Stock_API.Find_And_Reserve_Part(keys_and_qty_tab_     => stock_keys_and_qty_tab_,
                                                        location_no_          => NULL,
                                                        lot_batch_no_         => NULL,
                                                        serial_no_            => NULL,
                                                        eng_chg_level_        => NULL,
                                                        waiv_dev_rej_no_      => NULL,
                                                        configuration_id_     => '*',
                                                        activity_seq_         => activity_seq_,
                                                        handling_unit_id_     => NULL,
                                                        contract_             => lu_rec_.contract,
                                                        part_no_              => lu_rec_.part_no,
                                                        location_type_db_     => Inventory_Location_Type_API.DB_PICKING,
                                                        qty_to_reserve_       => qty_reserve_,
                                                        project_id_           => project_id_,
                                                        condition_code_       => lu_rec_.condition_code,
                                                        part_ownership_db_    => Part_Ownership_API.DB_COMPANY_OWNED,
                                                        owning_vendor_no_     => NULL,
                                                        owning_customer_no_   => NULL,
                                                        only_one_lot_allowed_ => FALSE,
                                                        many_records_allowed_ => TRUE);
      IF (stock_keys_and_qty_tab_.COUNT > 0) THEN
         FOR i IN stock_keys_and_qty_tab_.FIRST..stock_keys_and_qty_tab_.LAST LOOP

            Material_Requis_Reservat_API.Add_Assigned(order_class_      => order_class_,
                                                      order_no_         => order_no_,
                                                      line_no_          => line_no_,
                                                      release_no_       => release_no_,
                                                      line_item_no_     => line_item_no_,
                                                      part_no_          => stock_keys_and_qty_tab_(i).part_no,
                                                      contract_         => stock_keys_and_qty_tab_(i).contract,
                                                      location_no_      => stock_keys_and_qty_tab_(i).location_no,
                                                      lot_batch_no_     => stock_keys_and_qty_tab_(i).lot_batch_no,
                                                      serial_no_        => stock_keys_and_qty_tab_(i).serial_no,
                                                      waiv_dev_rej_no_  => stock_keys_and_qty_tab_(i).waiv_dev_rej_no,
                                                      eng_chg_level_    => stock_keys_and_qty_tab_(i).eng_chg_level,
                                                      activity_seq_     => stock_keys_and_qty_tab_(i).activity_seq,
                                                      handling_unit_id_ => stock_keys_and_qty_tab_(i).handling_unit_id,
                                                      qty_reserve_      => stock_keys_and_qty_tab_(i).quantity);

            qty_reserve_       := qty_reserve_       - stock_keys_and_qty_tab_(i).quantity;
            line_reserved_qty_ := line_reserved_qty_ + stock_keys_and_qty_tab_(i).quantity;

            IF (stock_keys_and_qty_tab_(i).to_location_no IS NOT NULL) THEN
               Inv_Part_Stock_Reservation_API.Move_New_With_Transport_Task(stock_keys_and_qty_rec_      => stock_keys_and_qty_tab_(i),
                                                                           order_supply_demand_type_db_ => Order_Supply_Demand_Type_API.DB_MATERIAL_REQ,
                                                                           order_no_                    => order_no_,
                                                                           line_no_                     => line_no_,
                                                                           release_no_                  => release_no_,
                                                                           line_item_no_                => line_item_no_);
            END IF;
         END LOOP;
      END IF;
   END LOOP;

   qty_left_ := qty_reserve_;
--
-- Shortage handling for the inventory part.
--
   orig_qty_short_ := Get_Qty_Short(order_class_, order_no_, line_no_, release_no_, line_item_no_);
   IF (orig_qty_short_ > 0) AND (qty_to_reserve_ IS NOT NULL ) THEN
      Modify_Qty_Short( order_class_,
                        order_no_,
                        line_no_,
                        release_no_,
                        line_item_no_,
                        orig_qty_short_ - (orig_qty_reserve_ - qty_left_) );
   ELSE
      Modify_Qty_Short( order_class_,
                        order_no_,
                        line_no_,
                        release_no_,
                        line_item_no_,
                        Shortage_Demand_API.Calculate_Order_Shortage_Qty( lu_rec_.contract,
                                                                          lu_rec_.part_no,
                                                                          lu_rec_.qty_due,
                                                                          line_reserved_qty_,
                                                                          lu_rec_.qty_shipped));
   END IF;
END Make_Line_Reservations;


-- Modify_Arrival
--   Calculates and updates the number of delivered items and sets the
--   status to 9 (Completed).
PROCEDURE Modify_Arrival (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_arrived_  IN NUMBER )
IS
   attr_                   VARCHAR2(32000);
   lu_rec_                 MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   qty_shipped_            MATERIAL_REQUIS_LINE_TAB.qty_shipped%TYPE;
   status_code_db_         MATERIAL_REQUIS_LINE_TAB.status_code%TYPE;
   planned_delivery_date_  MATERIAL_REQUIS_LINE_TAB.planned_delivery_date%TYPE;
   qty_on_order_           MATERIAL_REQUIS_LINE_TAB.qty_on_order%TYPE;
   order_class_db_         MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;

   dummy_                  NUMBER;
   mrq_status_             VARCHAR2(1);

   CURSOR line_status IS
      SELECT 1
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  order_class  = order_class_db_
      AND    order_no     = order_no_
      AND    status_code  IN ('1', '3', '4', '5', '7');
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   lu_rec_         := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   qty_shipped_    := lu_rec_.qty_shipped + qty_arrived_;
   qty_on_order_   := lu_rec_.qty_on_order - qty_arrived_;
   IF (lu_rec_.qty_due - lu_rec_.qty_shipped - qty_arrived_ = 0) THEN
      status_code_db_ := '9';
   ELSE
      status_code_db_ := '7';
   END IF;
   planned_delivery_date_ := Site_API.Get_Site_Date(lu_rec_.contract);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', qty_shipped_, attr_);
   Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
   Client_SYS.Add_To_Attr('STATUS_CODE_DB', status_code_db_, attr_);
   Client_SYS.Add_To_Attr('PLANNED_DELIVERY_DATE', planned_delivery_date_, attr_);
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   OPEN line_status;
   FETCH line_status INTO dummy_;
   IF (line_status%FOUND) THEN
      mrq_status_ := '7';
   ELSE
      mrq_status_ := '9';
   END IF;
   CLOSE line_status;
   Material_Requisition_API.Change_status(order_class_, order_no_, Material_Requis_Status_API.Decode(mrq_status_));
END Modify_Arrival;


-- Modify_Qty_On_Order
--   Calculates new values for the number of items reserved and number of
--   items that are not registered on a purchase order.
PROCEDURE Modify_Qty_On_Order (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_assigned_ IN NUMBER )
IS
   attr_           VARCHAR2(32000);
   lu_rec_         MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   qty_assign_     MATERIAL_REQUIS_LINE_TAB.qty_assigned%TYPE;
   qty_on_order_   MATERIAL_REQUIS_LINE_TAB.qty_on_order%TYPE;
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   lu_rec_         := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   qty_on_order_   := greatest(lu_rec_.qty_on_order - qty_assigned_, 0);
   qty_assign_     := lu_rec_.qty_assigned + qty_assigned_;
   Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assign_, attr_);
   IF (qty_assign_ > 0) THEN
      Client_SYS.Add_To_Attr('STATUS_CODE_DB', '5', attr_);
   END IF;
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
END Modify_Qty_On_Order;


PROCEDURE Modify_Qty_To_Be_Received(
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_ordered_  IN NUMBER )
IS
   attr_           VARCHAR2(100);
   lu_rec_         MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   lu_rec_         := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_ordered_, attr_);
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
END Modify_Qty_To_Be_Received;


-- Update_Intorder_Detail
--   If the demand is zero the status is set to 5 (Reserved) otherwise 4 (Released).
--   New values for quantity assigned and quantity shipped are calculated.
--   Finally the requisition header is updated with new status
PROCEDURE Update_Intorder_Detail (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_to_ship_  IN NUMBER )
IS
   attr_                   VARCHAR2(32000);
   lu_rec_                 MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   status_db_              MATERIAL_REQUIS_LINE_TAB.status_code%TYPE;
   found_                  VARCHAR2(1);
   order_class_db_         MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
   po_order_no_            VARCHAR2(12);
   po_line_no_             VARCHAR2(4);
   po_rel_no_              VARCHAR2(4);
   purchase_type_          VARCHAR2(20);   
   po_state_               VARCHAR2(20);
   qty_in_store_           NUMBER;
   no_more_unclosed_lines_ VARCHAR2(5);
   --
   CURSOR line_status IS
      SELECT 'X'
      FROM  MATERIAL_REQUIS_LINE_TAB
      WHERE order_class  = order_class_db_
      AND   order_no     = order_no_
      AND   status_code  IN ('1', '3', '4', '5', '7');

   CURSOR not_issued IS
      SELECT line_no, release_no, line_item_no, order_class
      FROM  MATERIAL_REQUIS_LINE_TAB
      WHERE order_no     = order_no_
      AND   status_code != '9';
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   lu_rec_ := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   IF (lu_rec_.status_code IN ('1', '3', '4', '9')) THEN
      Error_SYS.Record_General('MaterialRequisLine','NOALLOWEDSTATISSUE: Issue is only allowed in status :P1 and :P2',
            Material_Requis_Status_API.Decode('5'),
            Material_Requis_Status_API.Decode('7'));
   END IF;

   Material_Requis_Pur_Order_API.Get_Purchase_Link(po_order_no_, po_line_no_, po_rel_no_, purchase_type_,
                                                   order_no_, line_no_, release_no_,
                                                   line_item_no_, order_class_);

   $IF Component_Purch_SYS.INSTALLED $THEN      
      po_state_     := Purchase_Order_Line_API.Get_Objstate(po_order_no_, po_line_no_, po_line_no_); 
      qty_in_store_ := Receipt_Info_API.Get_Inv_Qty_In_Store_By_Source(po_order_no_, 
                                                                       po_line_no_, 
                                                                       po_rel_no_,
                                                                       NULL,
                                                                       Logistics_Source_Ref_Type_API.DB_PURCHASE_ORDER,
                                                                       NULL);
   $END

   FOR is_current_line IN not_issued LOOP
      IF (line_no_         = is_current_line.line_no) AND
         (release_no_      = is_current_line.release_no) AND
         (line_item_no_    = is_current_line.line_item_no) AND
         (order_class_db_  = is_current_line.order_class) THEN
         no_more_unclosed_lines_ := 'TRUE';
      ELSE
         no_more_unclosed_lines_ := 'FALSE';
         EXIT;
      END IF;
   END LOOP;

   IF (lu_rec_.qty_due - lu_rec_.qty_shipped - qty_to_ship_ = 0) OR ((lu_rec_.qty_shipped + qty_to_ship_ = qty_in_store_) AND (po_state_ = 'Closed'))THEN
      IF (no_more_unclosed_lines_ = 'TRUE') THEN
         Client_Sys.Add_Info(lu_name_,'CLOSEMRORDER: The Material Requisition is fully delivered and will now be closed');
      END IF;
      status_db_ := '9';
   ELSE
      status_db_ := '7';
   END IF;
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'QTY_ASSIGNED', (lu_rec_.qty_assigned - qty_to_ship_ ), attr_ );
   Client_SYS.Add_To_Attr( 'QTY_SHIPPED', (lu_rec_.qty_shipped + qty_to_ship_), attr_ );
   Client_SYS.Add_To_Attr( 'STATUS_CODE_DB', status_db_, attr_ );
   Client_SYS.Add_To_Attr( 'PLANNED_DELIVERY_DATE', Site_API.Get_Site_Date(lu_rec_.contract), attr_ );
   Modify_impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   OPEN line_status;
   FETCH line_status INTO found_;
   IF (line_status%FOUND) THEN
      Material_Requisition_API.Change_status(order_class_, order_no_, Material_Requis_Status_API.Decode('7'));
   ELSE
      Material_Requisition_API.Change_status(order_class_, order_no_, Material_Requis_Status_API.Decode('9'));
   END IF;
   CLOSE line_status;
END Update_Intorder_Detail;


-- Get_Pre_Accounting_Id
--   Gets the pre-accounting id for the requisition line
@UncheckedAccess
FUNCTION Get_Pre_Accounting_Id (
   order_no_   IN VARCHAR2,
   line_no_    IN VARCHAR2,
   release_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_pre_accnt_id_ IS
      SELECT pre_accounting_id
      FROM MATERIAL_REQUIS_LINE_TAB
      WHERE order_no   = order_no_
      AND line_no      = line_no_
      AND release_no   = release_no_;
   pre_accounting_id_ MATERIAL_REQUIS_LINE_TAB.pre_accounting_id%TYPE;
BEGIN
   OPEN get_pre_accnt_id_;
   FETCH get_pre_accnt_id_ INTO pre_accounting_id_;
   CLOSE get_pre_accnt_id_;
   RETURN pre_accounting_id_;
END Get_Pre_Accounting_Id;


-- Mandatory_Pre_Posting_Complete
--   Checks if mandatory preposting is enabled and the required code parts
--   have been entered. If mandatory preposting is enabled and required
--   code parts are not found this will return 'FALSE' otherwise 'TRUE'.
FUNCTION Mandatory_Pre_Posting_Complete (
   order_class_    IN VARCHAR2,
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   release_no_     IN VARCHAR2,
   line_item_no_   IN NUMBER ) RETURN VARCHAR2
IS
   lu_rec_                          MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   mandatory_preposting_complete_   VARCHAR2(5) := 'FALSE';
   order_class_db_                  MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
BEGIN

   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   lu_rec_         := Get_Object_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   
   IF (Pre_Accounting_API.Mandatory_Pre_Posting_Complete(lu_rec_.pre_accounting_id, 'M107', Site_API.Get_Company(lu_rec_.contract))) THEN
      mandatory_preposting_complete_ := 'TRUE';
   END IF;

   RETURN (mandatory_preposting_complete_);
END Mandatory_Pre_Posting_Complete;


-- Unissue
--   This method executes reversing of material issue for material
--   requisition line. i.e. puts the material back in location.
PROCEDURE Unissue (
   qty_reversed_       IN OUT NUMBER,
   accounting_id_      IN     NUMBER,
   contract_           IN     VARCHAR2, -- obsolete
   part_no_            IN     VARCHAR2, -- obsolete
   qty_unissue_        IN     NUMBER,
   location_no_        IN     VARCHAR2, -- obsolete
   lot_batch_no_       IN     VARCHAR2, -- obsolete
   serial_no_          IN     VARCHAR2, -- obsolete
   eng_chg_level_      IN     VARCHAR2, -- obsolete
   waiv_dev_rej_no_    IN     VARCHAR2, -- obsolete
   transaction_id_     IN     NUMBER,
   source_             IN     VARCHAR2,
   order_no_           IN     VARCHAR2,
   release_no_         IN     VARCHAR2,
   sequence_no_        IN     VARCHAR2,
   line_item_no_       IN     NUMBER,
   cost_               IN     NUMBER, -- obsolete
   quantity_           IN     NUMBER,
   catch_qty_unissue_  IN     NUMBER DEFAULT NULL )
IS
   attr_               VARCHAR2(32000);
   lu_rec_             MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   sum_qty_returned_   MATERIAL_REQUIS_LINE_TAB.qty_returned%TYPE;
   new_transaction_id_ NUMBER := 0;
   order_class_db_     MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
   po_order_no_        VARCHAR2(12);
   po_line_no_         VARCHAR2(4);
   po_release_no_      VARCHAR2(4);
   purch_type_         VARCHAR2(1);
   due_at_dock_inv_    NUMBER;
   quantity_val_       NUMBER;
   trans_hist_rec_     Inventory_Transaction_Hist_API.Public_Rec;
BEGIN

   Trace_SYS.Field('Trace => Transaction Id', transaction_id_);
   Trace_SYS.Field('Trace => Source [Order Class]', source_);
   Trace_SYS.Field('Trace => Order No', order_no_);
   Trace_SYS.Field('Trace => Release No [Line No]', release_no_);
   Trace_SYS.Field('Trace => Sequence No [Release No]', sequence_no_);
   Trace_SYS.Field('Trace => Line Item No', line_item_no_);
   IF qty_unissue_ <= 0 THEN
      Error_SYS.Record_General(lu_name_, 'UNISSUENEG: Quantity to unissue must be greater than 0');
   END IF;

   trans_hist_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);
   qty_reversed_   := NVL(trans_hist_rec_.qty_reversed, qty_reversed_   );
   quantity_val_   := NVL(trans_hist_rec_.quantity    , quantity_       );

   IF (qty_unissue_ IS NOT NULL) AND (qty_unissue_ > ( Nvl(quantity_val_, 0) - Nvl(qty_reversed_, 0) )) THEN
      Error_SYS.Record_General(lu_name_, 'RETMORETHANISSUED: The qty returned may not be greater than the inventory transaction issue.');
   END IF;

   Inventory_Part_In_Stock_API.Unissue_Part(new_transaction_id_,
                                              'INTUNISS',
                                              'INVREVAL+',
                                              'INVREVAL-',
                                              qty_unissue_,
                                              catch_qty_unissue_,
                                              transaction_id_,
                                              source_);

   order_class_db_ := Material_Requis_Type_API.Encode(source_);
   lu_rec_ := Lock_By_Keys___(order_class_db_, order_no_, release_no_, sequence_no_, line_item_no_);

   sum_qty_returned_ := lu_rec_.qty_returned + qty_unissue_;

   -- Modified in order to update qty_on_order when the supply_code is 'PO'.
   $IF Component_Purch_SYS.INSTALLED $THEN 
      IF (lu_rec_.supply_code = 'PO') THEN
         Material_Requis_Pur_Order_API.Get_Purchase_Link(po_order_no_,
                                                         po_line_no_,
                                                         po_release_no_,
                                                         purch_type_ ,
                                                         order_no_,
                                                         release_no_,
                                                         sequence_no_,
                                                         line_item_no_,
                                                         order_class_db_);

         due_at_dock_inv_ := Purchase_Order_Line_API.Get_Due_At_Dock_Inv(po_order_no_, po_line_no_, po_release_no_);      
         Client_SYS.Add_To_Attr('QTY_ON_ORDER', due_at_dock_inv_, attr_);   
      END IF;
   $END
   Client_SYS.Add_To_Attr('QTY_RETURNED', sum_qty_returned_ , attr_);
   Client_SYS.Add_To_Attr('QTY_SHIPPED', lu_rec_.qty_shipped - qty_unissue_, attr_);

   Modify_Impl___(attr_, order_class_db_, order_no_, release_no_, sequence_no_, line_item_no_);

   qty_reversed_ := Nvl(qty_reversed_, 0) + qty_unissue_;
END Unissue;

-- Unissue
--   Overload method for cleaner interface for Aurena, a lot of obsolete parameters in the original Unissue-method.
PROCEDURE Unissue (
   qty_unissue_        IN     NUMBER,
   transaction_id_     IN     NUMBER,
   source_             IN     VARCHAR2,
   order_no_           IN     VARCHAR2,
   release_no_         IN     VARCHAR2,
   sequence_no_        IN     VARCHAR2,
   line_item_no_       IN     NUMBER,
   catch_qty_unissue_  IN     NUMBER DEFAULT NULL )
IS
   qty_reversed_ NUMERIC := NULL;
BEGIN
   Unissue (
      qty_reversed_        => qty_reversed_,
      accounting_id_       => NULL,
      contract_            => NULL,
      part_no_             => NULL,
      qty_unissue_         => qty_unissue_,
      location_no_         => NULL,
      lot_batch_no_        => NULL,
      serial_no_           => NULL,
      eng_chg_level_       => NULL,
      waiv_dev_rej_no_     => NULL,
      transaction_id_      => transaction_id_,
      source_              => source_,
      order_no_            => order_no_,
      release_no_          => release_no_,
      sequence_no_         => sequence_no_,
      line_item_no_        => line_item_no_,
      cost_                => NULL,
      quantity_            => NULL,
      catch_qty_unissue_   => catch_qty_unissue_);
END Unissue;

-- Modify_Qty_Short
--   Set the shortage quantity for an instance of this LU.
PROCEDURE Modify_Qty_Short (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_short_    IN NUMBER )
IS
   attr_           VARCHAR2(32000);
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   Client_SYS.Add_To_Attr('QTY_SHORT', nvl(qty_short_, 0), attr_);
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
END Modify_Qty_Short;


-- New
--   For creating new instances of object MaterialRequisLine.
PROCEDURE New (
   line_no_      OUT VARCHAR2,
   release_no_   OUT VARCHAR2,
   line_item_no_ OUT NUMBER,
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   part_no_      IN VARCHAR2,
   qty_due_      IN NUMBER,
   due_date_     IN DATE,
   note_text_    IN VARCHAR2 )
IS
   attr_       VARCHAR2(32000);
   newrec_     MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   objid_      ROWID;
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'CONTRACT', Material_Requisition_API.Get_Contract(order_class_,order_no_) , attr_ );
   Client_SYS.Add_To_Attr( 'ORDER_CLASS', order_class_, attr_ );
   Client_SYS.Add_To_Attr( 'ORDER_NO', order_no_, attr_ );
   Client_SYS.Add_To_Attr( 'PART_NO', part_no_, attr_ );
   Client_SYS.Add_To_Attr( 'QTY_DUE', qty_due_, attr_ );
   Client_SYS.Add_To_Attr( 'DUE_DATE', due_date_, attr_ );
   Client_SYS.Add_To_Attr( 'NOTE_TEXT', note_text_, attr_ );
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   line_no_       := newrec_.line_no;
   release_no_    := newrec_.release_no;
   line_item_no_  := newrec_.line_item_no;
END New;


-- Modify_Qty_Due
--   For modification of Quantity Due.
PROCEDURE Modify_Qty_Due (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   qty_due_      IN NUMBER )
IS
   attr_           VARCHAR2(32000);
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_DUE', qty_due_, attr_);
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
END Modify_Qty_Due;


-- Modify_Due_Date
--   For modification of Due Date.
PROCEDURE Modify_Due_Date (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER,
   due_date_     IN DATE )
IS
   attr_           VARCHAR2(32000);
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('DUE_DATE', due_date_, attr_);
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
END Modify_Due_Date;


-- Remove
--   Removes one instance of object MaterialRequisLine.
PROCEDURE Remove (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   remrec_         MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   objid_          MATERIAL_REQUIS_LINE.objid%TYPE;
   objversion_     MATERIAL_REQUIS_LINE.objversion%TYPE;
   order_class_db_ MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   remrec_         := Get_Object_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Check_Exist_Non_Closed
--   Checks if any part in material requisition line has status other than closed.
@UncheckedAccess
FUNCTION Check_Exist_Non_Closed (
   part_no_  IN VARCHAR2,
   contract_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_ VARCHAR2 (5);
   dummy_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  contract       = contract_
      AND    part_no        = part_no_
      AND    status_code NOT IN ('9');
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      result_ := 'TRUE';
      RETURN result_;
   END IF;
   CLOSE exist_control;
   result_ := 'FALSE';
   RETURN result_;
END Check_Exist_Non_Closed;


-- Calendar_Changed
--   Change the due date of material requisition lines that use a
--   particular Calendar ID.
PROCEDURE Calendar_Changed (
   error_log_   OUT CLOB,
   calendar_id_ IN  VARCHAR2,
   contract_    IN  VARCHAR2 DEFAULT NULL )
IS
   work_day_       DATE;
   is_working_day_ NUMBER;
   attr_           VARCHAR2(2000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(300);
   info_           VARCHAR2(2000);
   error_msg_      VARCHAR2(2000);
   separator_      VARCHAR2(1) := CLIENT_SYS.text_separator_;

   CURSOR get_record IS
      SELECT order_class, order_no, line_no, release_no, line_item_no, part_no, unit_meas, status_code,
             supply_code, trunc(due_date) due_date, qty_due, qty_assigned, qty_on_order, qty_returned,
             qty_shipped, qty_shipdiff, qty_short, contract
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  Site_API.Get_Dist_Calendar_Id(contract) = calendar_id_
      AND    contract LIKE NVL(contract_, '%')
      AND    status_code NOT IN ('9');
BEGIN
   FOR rec IN get_record LOOP
      --Exception handling for calendar changes.
      BEGIN
         work_day_ := rec.due_date;
         is_working_day_ := Work_Time_Calendar_API.Is_Working_Day(calendar_id_,work_day_);

         IF (is_working_day_ = 0) THEN
            IF material_requis_pur_order_api.Connected_To_Purchase_Order (rec.order_no,
                                                                          rec.line_no,
                                                                          rec.release_no,
                                                                          rec.line_item_no,
                                                                          rec.order_class) THEN
               work_day_ := Work_Time_Calendar_API.Get_Next_Work_Day(calendar_id_, work_day_);
            ELSE
               work_day_ := Work_Time_Calendar_API.Get_Previous_Work_Day(calendar_id_, work_day_);
            END IF;
            
            IF (work_day_ IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'INVALIDDATE: Due date is not within current calendar.');
            END IF;
            
            objid_      := NULL;
            objversion_ := NULL;
            info_       := NULL;

            Get_Id_Version_By_Keys___ (objid_, objversion_, rec.order_class, rec.order_no, rec.line_no, rec.release_no, rec.line_item_no);

            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('PART_NO',  rec.part_no, attr_);
            Client_SYS.Add_To_Attr('UNIT_MEAS', rec.unit_meas, attr_);
            Client_SYS.Add_To_Attr('STATUS_CODE_DB', rec.status_code, attr_);
            Client_SYS.Add_To_Attr('SUPPLY_CODE_DB', rec.supply_code, attr_);
            Client_SYS.Add_To_Attr('DUE_DATE', work_day_, attr_);
            Client_SYS.Add_To_Attr('QTY_DUE', rec.qty_due, attr_);
            Client_SYS.Add_To_Attr('QTY_ASSIGNED', rec.qty_assigned, attr_);
            Client_SYS.Add_To_Attr('QTY_ON_ORDER', rec.qty_on_order, attr_);
            Client_SYS.Add_To_Attr('QTY_RETURNED', rec.qty_returned, attr_);
            Client_SYS.Add_To_Attr('QTY_SHIPPED', rec.qty_shipped, attr_);
            Client_SYS.Add_To_Attr('QTY_SHIPDIFF', rec.qty_shipdiff, attr_);
            Client_SYS.Add_To_Attr('QTY_SHORT', rec.qty_short, attr_);

            Modify_Impl___ (attr_,
                            rec.order_class,
                            rec.order_no,
                            rec.line_no,
                            rec.release_no,
                            rec.line_item_no);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            error_msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                         'CALCHG: Error while updating Material Requistion Line. ', 
                                                          Language_SYS.Get_Language);
            error_msg_ := error_msg_ || Language_SYS.Translate_Constant(lu_name_, 
                                                                       'CALCHG2: Order No: :P1, Line No: :P2, Release No: :P3, ',
                                                                       Language_SYS.Get_Language, 
                                                                       rec.order_no, 
                                                                       rec.line_no, 
                                                                       rec.release_no);
            error_msg_ := error_msg_ || Language_SYS.Translate_Constant(lu_name_, 
                                                                       'CALCHG3: Due Date: :P1.', 
                                                                       Language_SYS.Get_Language, 
                                                                       rec.due_date);
            error_msg_ := error_msg_ || ' ' || SQLERRM;

            --Remove call to Work_Time_Calendar_API , instead write to OUT parameter
            IF error_log_ IS NULL THEN
               error_log_ := error_msg_ || separator_;
            ELSE
               error_log_ := error_log_ || error_msg_ || separator_;
            END IF;
      END;
   END LOOP;
END Calendar_Changed;


-- Part_Exist
--   Checks the existence of a  Material Requisition Line for a given
--   contract and a Part No
FUNCTION Part_Exist (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_  NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   MATERIAL_REQUIS_LINE_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    status_code NOT IN ('5', '3');
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF exist_control%NOTFOUND THEN
      dummy_ := 0;
   END IF;
   CLOSE exist_control;
   RETURN dummy_;
END Part_Exist;


--   This method will be used to update the cost and progress information
--   of a project activity.
PROCEDURE Calculate_Cost_And_Progress (
   order_class_      IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   refresh_old_data_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   activity_info_tab_              Public_Declarations_API.PROJ_Project_Conn_Cost_Tab;
   activity_revenue_info_tab_      Public_Declarations_API.PROJ_Project_Conn_Revenue_Tab;
   attributes_                     Public_Declarations_API.PROJ_Project_Conn_Attr_Type;
   order_class_db_                 material_requis_line_tab.order_class%TYPE;
BEGIN
   order_class_db_   := Material_Requis_Type_API.Encode (order_class_);
   Refresh_Project_Connection (activity_info_tab_         => activity_info_tab_,
                               activity_revenue_info_tab_ => activity_revenue_info_tab_,
                               attributes_                => attributes_,
                               activity_seq_              => NULL,
                               keyref1_                   => order_class_db_,
                               keyref2_                   => order_no_,
                               keyref3_                   => line_no_,
                               keyref4_                   => release_no_,
                               keyref5_                   => line_item_no_,
                               keyref6_                   => '*',
                               refresh_old_data_          => refresh_old_data_);
END Calculate_Cost_And_Progress;


PROCEDURE Refresh_Project_Connection (
   activity_info_tab_         IN OUT NOCOPY Public_Declarations_API.PROJ_Project_Conn_Cost_Tab,
   activity_revenue_info_tab_ IN OUT NOCOPY Public_Declarations_API.PROJ_Project_Conn_Revenue_Tab,
   attributes_                IN OUT NOCOPY Public_Declarations_API.PROJ_Project_Conn_Attr_Type,
   activity_seq_              IN     NUMBER,
   keyref1_                   IN     VARCHAR2,
   keyref2_                   IN     VARCHAR2,
   keyref3_                   IN     VARCHAR2,
   keyref4_                   IN     VARCHAR2,
   keyref5_                   IN     VARCHAR2,
   keyref6_                   IN     VARCHAR2,
   refresh_old_data_          IN     VARCHAR2 DEFAULT 'FALSE' )
IS
   order_class_                      VARCHAR2(3)  := keyref1_;
   order_no_                         VARCHAR2(12) := keyref2_;
   line_no_                          VARCHAR2(4)  := keyref3_;
   release_no_                       VARCHAR2(4)  := keyref4_;
   line_item_no_                     NUMBER       := TO_NUMBER(keyref5_);
   rec_                              material_requis_line_tab%ROWTYPE;
   object_progress_                  NUMBER;
   committed_cost_elements_          Mpccom_Accounting_API.Project_Cost_Element_Tab;
   used_cost_elements_               Mpccom_Accounting_API.Project_Cost_Element_Tab;
   empty_tab_                        Mpccom_Accounting_API.Project_Cost_Element_Tab;
   count_                            PLS_INTEGER;

   CURSOR get_project_cost_elements IS
      SELECT project_cost_element,
             SUM(committed_amount) committed_amount,
             SUM(used_amount)      used_amount
      FROM project_cost_element_tmp
      GROUP BY project_cost_element;
BEGIN
   rec_              := Get_Object_By_Keys___ (order_class_, order_no_, line_no_, release_no_,line_item_no_);   
   Get_Activity_Info___ (committed_cost_elements_, used_cost_elements_, object_progress_, rec_);
   Invent_Proj_Cost_Manager_API.Fill_Project_Cost_Element_Tmp (empty_tab_, empty_tab_, committed_cost_elements_, used_cost_elements_);

   count_                                         := activity_info_tab_.COUNT;
   FOR proj_cost_element_rec_ IN get_project_cost_elements LOOP
      activity_info_tab_(count_).control_category := proj_cost_element_rec_.project_cost_element;
      activity_info_tab_(count_).committed        := proj_cost_element_rec_.committed_amount;
      activity_info_tab_(count_).used             := proj_cost_element_rec_.used_amount;
      count_                                      := count_ + 1;
   END LOOP;
   attributes_.last_transaction_date              := SYSDATE;

   IF (refresh_old_data_ = 'FALSE') THEN
      $IF (Component_Proj_SYS.INSTALLED) $THEN
         Project_Connection_Util_API.Refresh_Connection (proj_lu_name_              => 'MTRLREQLINE',
                                                         activity_seq_              => rec_.activity_seq,
                                                         keyref1_                   => order_class_,
                                                         keyref2_                   => order_no_,
                                                         keyref3_                   => line_no_,
                                                         keyref4_                   => release_no_,
                                                         keyref5_                   => line_item_no_,
                                                         keyref6_                   => '*',
                                                         object_description_        => lu_name_,
                                                         activity_info_tab_         => activity_info_tab_,
                                                         activity_revenue_info_tab_ => activity_revenue_info_tab_,
                                                         attributes_                => attributes_); 
      $ELSE
         Error_SYS.Component_Not_Exist('PROJ');
      $END
   END IF;
END Refresh_Project_Connection;


-- Has_Any_Closed_Line
--    Returns TRUE if there is any closed line has been found.
@UncheckedAccess
FUNCTION Has_Any_Closed_Line ( 
   message_ IN VARCHAR2) RETURN VARCHAR2
IS
   ptr_               NUMBER;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);
   order_class_db_    MATERIAL_REQUIS_LINE_TAB.order_class%TYPE;
   order_no_          MATERIAL_REQUIS_LINE_TAB.order_no%TYPE;
   line_no_           MATERIAL_REQUIS_LINE_TAB.line_no%TYPE;
   release_no_        MATERIAL_REQUIS_LINE_TAB.release_no%TYPE;
   line_item_no_      MATERIAL_REQUIS_LINE_TAB.line_item_no%TYPE;
   closed_line_exist_ VARCHAR2(5) := 'FALSE';
   count_             NUMBER;
   name_tab_          Message_SYS.name_table;
   value_tab_         Message_SYS.line_table;
BEGIN
   Message_Sys.Get_Attributes(message_, count_, name_tab_, value_tab_);
   WHILE (count_ > 0) LOOP
      ptr_ := NULL;
      WHILE (Client_SYS.Get_Next_From_Attr(value_tab_(count_), ptr_, name_, value_)) LOOP
         IF (name_ = 'ORDER_CLASS_DB') THEN
            order_class_db_ := value_;
         ELSIF (name_ = 'ORDER_NO') THEN
            order_no_ := value_;
         ELSIF (name_ = 'LINE_NO') THEN
            line_no_ := value_;
         ELSIF (name_ = 'RELEASE_NO') THEN
            release_no_ := value_;
         ELSIF (name_ = 'LINE_ITEM_NO') THEN
            line_item_no_ := Client_SYS.Attr_Value_To_Number(value_);
         END IF;
      END LOOP;

      IF (Is_Closed ( order_class_db_, order_no_, line_no_, release_no_, line_item_no_)) THEN
         closed_line_exist_ := 'TRUE';
         EXIT;
      END IF;
      count_ := count_ - 1;
   END LOOP; 
   RETURN (closed_line_exist_);
END Has_Any_Closed_Line;


-- Is_Closed
--   Returns TRUE if Material Requisition Line status code has been set to 'Closed'.
@UncheckedAccess
FUNCTION Is_Closed (
   order_class_db_ IN VARCHAR2,
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   release_no_     IN VARCHAR2,
   line_item_no_   IN NUMBER ) RETURN BOOLEAN
IS
   lu_rec_    MATERIAL_REQUIS_LINE_TAB%ROWTYPE;
   is_closed_ BOOLEAN := FALSE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(order_class_db_,
                                    order_no_,
                                    line_no_,
                                    release_no_,
                                    line_item_no_);
   IF (lu_rec_.status_code = '9') THEN
      is_closed_ := TRUE;
   END IF;

   RETURN (is_closed_);
END Is_Closed;


-- This method is used by DataCaptIssueMtrlReq
@ServerOnlyAccess
FUNCTION Get_Column_Value_If_Unique (
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN NUMBER,
   part_no_                    IN VARCHAR2,
   contract_                   IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE Get_Column_Value IS REF CURSOR;
   get_column_values_             Get_Column_Value;
   stmt_                          VARCHAR2(4000);
   unique_column_value_           VARCHAR2(50);
   userid_                        VARCHAR2(30) := Fnd_Session_Api.Get_Fnd_User;
   TYPE Column_Value_Tab IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   column_value_tab_     Column_Value_Tab; 
BEGIN

   IF NOT ( User_Allowed_Site_API.Check_Exist(userid_, contract_)) THEN
      RETURN NULL;
   END IF;

   IF (column_name_ IN ('ORDER_NO','LINE_NO','RELEASE_NO','LINE_ITEM_NO')) THEN
      -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
      Assert_SYS.Assert_Is_Table_Column('MATERIAL_REQUIS_LINE_TAB', column_name_);
      stmt_ := 'SELECT DISTINCT mrl.';
   ELSE
      -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
      Assert_SYS.Assert_Is_View_Column('INVENTORY_PART_IN_STOCK_TOTAL', column_name_);
      stmt_ := 'SELECT DISTINCT ipist.';
   END IF;
   -- this select is for reserve manually action or reserve and issue manually action or for undecided action (the action have not been selected yet in configuration)
   stmt_ := stmt_ || column_name_ || '
             FROM INVENTORY_PART_IN_STOCK_TOTAL ipist, MATERIAL_REQUIS_LINE_TAB mrl  
             WHERE ipist.contract = :contract_ ';
   IF (part_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.part_no = :part_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
   END IF;
   IF (configuration_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.configuration_id = :configuration_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
   END IF;
   IF (lot_batch_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.lot_batch_no = :lot_batch_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
   END IF;
   IF (serial_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.serial_no = :serial_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
   END IF;
   IF (eng_chg_level_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.eng_chg_level = :eng_chg_level_ ';
   ELSE
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
   END IF;
   IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.waiv_dev_rej_no = :waiv_dev_rej_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
   END IF;
   IF (activity_seq_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.activity_seq = :activity_seq_ ';
   ELSE
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
   END IF;
   IF (handling_unit_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
   END IF;
   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (ipist.alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
   stmt_ := stmt_ || ' AND mrl.order_class = :order_class ';
   IF (order_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.order_no = :order_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :order_no_ IS NULL ';
   END IF;
   IF (line_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.line_no = :line_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :line_no_ IS NULL ';
   END IF;
   IF (release_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.release_no = :release_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :release_no_ IS NULL ';
   END IF;
   IF (line_item_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.line_item_no = :line_item_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :line_item_no_ IS NULL ';
   END IF;
   stmt_ := stmt_ || ' AND mrl.qty_due > mrl.qty_shipped
               AND mrl.contract = ipist.contract
               AND mrl.part_no  = ipist.part_no
               AND (((ipist.qty_onhand - ipist.qty_reserved) > 0) 
                 OR (Material_Requis_Reservat_API.Get_Qty_Assigned_If_Unique(mrl.order_class , mrl.order_no , mrl.line_no , mrl.release_no , mrl.line_item_no, 
                                                                          ipist.part_no, ipist.contract, ipist.configuration_id, ipist.location_no, ipist.lot_batch_no, 
                                                                          ipist.serial_no, ipist.waiv_dev_rej_no, ipist.eng_chg_level, ipist.activity_seq, ipist.handling_unit_id) > 0)) 
               AND ipist.location_type_db  = ''PICKING'' 
               AND ipist.part_ownership_db IN (''COMPANY OWNED'',''CONSIGNMENT'') 
               AND (mrl.supply_code != ''PO'' OR (mrl.qty_assigned > 0))
               AND mrl.status_code != 9';

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';   

   @ApproveDynamicStatement(2014-12-09,UdGnlk)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,  
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_,
                                           Material_Requis_Type_API.DB_INT,
                                           order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_;
                                                       
   FETCH get_column_values_ BULK COLLECT INTO column_value_tab_;
   IF (column_value_tab_.COUNT = 1) THEN
      unique_column_value_ := NVL(column_value_tab_(1), 'NULL');      
   END IF;
   CLOSE get_column_values_;
   
   RETURN unique_column_value_;
END Get_Column_Value_If_Unique;


-- This method is used by DataCaptIssueMtrlReq
@ServerOnlyAccess
PROCEDURE Create_Data_Capture_Lov (
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN NUMBER,
   part_no_                    IN VARCHAR2,
   contract_                   IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   capture_session_id_         IN NUMBER,
   column_name_                IN VARCHAR2,
   lov_type_db_                IN VARCHAR2 )
IS
   TYPE Get_Lov_Values       IS REF CURSOR;
   get_lov_values_           Get_Lov_Values;
   stmt_                     VARCHAR2(4000);
   TYPE Lov_Value_Tab        IS TABLE OF VARCHAR2(2000) INDEX BY PLS_INTEGER;
   lov_value_tab_            Lov_Value_Tab;
   second_column_name_       VARCHAR2(200);
   second_column_value_      VARCHAR2(200);
   lov_item_description_     VARCHAR2(200);
   session_rec_              Data_Capture_Common_Util_API.Session_Rec;
   userid_                   VARCHAR2(30) := Fnd_Session_Api.Get_Fnd_User;
   lov_row_limitation_       NUMBER;
   exit_lov_                 BOOLEAN := FALSE;
   temp_handling_unit_id_    NUMBER;
BEGIN
   $IF Component_Wadaco_SYS.INSTALLED $THEN
      
      IF NOT ( User_Allowed_Site_API.Check_Exist(userid_, contract_)) THEN
         RETURN;
      END IF;

      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      IF (column_name_ IN ('ORDER_NO','LINE_NO','RELEASE_NO','LINE_ITEM_NO')) THEN
         -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
         Assert_SYS.Assert_Is_Table_Column('MATERIAL_REQUIS_LINE_TAB', column_name_);
      ELSE
         -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
         Assert_SYS.Assert_Is_View_Column('INVENTORY_PART_IN_STOCK_TOTAL', column_name_);
      END IF;

      -- this select is for reserve manually action or reserve and issue manually action or for undecided action (the action have not been selected yet in configuration)
      stmt_ :=  column_name_ || 
              ' FROM INVENTORY_PART_IN_STOCK_TOTAL ipist, MATERIAL_REQUIS_LINE_TAB mrl  
                WHERE ipist.contract = :contract_ ';

      IF (part_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.part_no = :part_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
      END IF;
      IF (configuration_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.configuration_id = :configuration_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
      END IF;
      IF (location_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.location_no = :location_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
      END IF;
      IF (lot_batch_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.lot_batch_no = :lot_batch_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
      END IF;
      IF (serial_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.serial_no = :serial_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
      END IF;
      IF (eng_chg_level_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.eng_chg_level = :eng_chg_level_ ';
      ELSE
         stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
      END IF;
      IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.waiv_dev_rej_no = :waiv_dev_rej_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
      END IF;
      IF (activity_seq_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.activity_seq = :activity_seq_ ';
      ELSE
         stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
      END IF;
      IF (handling_unit_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.handling_unit_id = :handling_unit_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
      END IF;
      IF (alt_handling_unit_label_id_ = '%') THEN 
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
      ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND ipist.alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
      ELSE
         stmt_ := stmt_ || ' AND (ipist.alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
      END IF;
      stmt_ := stmt_ || ' AND mrl.order_class = :order_class ';
      IF (order_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND mrl.order_no = :order_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :order_no_ IS NULL ';
      END IF;
      IF (line_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND mrl.line_no = :line_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :line_no_ IS NULL ';
      END IF;
      IF (release_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND mrl.release_no = :release_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :release_no_ IS NULL ';
      END IF;
      IF (line_item_no_ IS NOT NULL) THEN 
         stmt_ := stmt_ || ' AND mrl.line_item_no = :line_item_no_ ';
      ELSE
         stmt_ := stmt_ || ' AND :line_item_no_ IS NULL ';
      END IF;
      stmt_ := stmt_ || ' AND mrl.qty_due > mrl.qty_shipped
                  AND mrl.contract = ipist.contract
                  AND mrl.part_no  = ipist.part_no
                  AND (((ipist.qty_onhand - ipist.qty_reserved) > 0) 
                    OR (Material_Requis_Reservat_API.Get_Qty_Assigned_If_Unique(mrl.order_class , mrl.order_no , mrl.line_no , mrl.release_no , mrl.line_item_no, 
                                                                             ipist.part_no, ipist.contract, ipist.configuration_id, ipist.location_no, ipist.lot_batch_no, 
                                                                             ipist.serial_no, ipist.waiv_dev_rej_no, ipist.eng_chg_level, ipist.activity_seq, ipist.handling_unit_id) > 0)) 
                  AND ipist.location_type_db  = ''PICKING'' 
                  AND ipist.part_ownership_db IN (''COMPANY OWNED'',''CONSIGNMENT'') 
                  AND (mrl.supply_code != ''PO'' OR (mrl.qty_assigned > 0))
                  AND mrl.status_code != 9';


      -- Don't use DISTINCT select for AUTO PICK and can have the normal order since only 1 value will be picked anyway
      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         IF (column_name_ IN ('ORDER_NO','LINE_NO','RELEASE_NO','LINE_ITEM_NO')) THEN
            stmt_ := 'SELECT mrl.' || stmt_ || ' ORDER BY Utility_SYS.String_To_Number( ' || column_name_ || ' ) ASC, ' || column_name_ || ' ASC' ;
         ELSE
            stmt_ := 'SELECT ipist.' || stmt_ || ' ORDER BY Utility_SYS.String_To_Number( ' || column_name_ || ' ) ASC, ' || column_name_ || ' ASC' ;
         END IF;
      ELSE
         IF (column_name_ IN ('ORDER_NO','LINE_NO','RELEASE_NO','LINE_ITEM_NO')) THEN
            stmt_ := 'SELECT distinct mrl.' || stmt_ || ' ORDER BY Utility_SYS.String_To_Number( ' || column_name_ || ' ) ASC, ' || column_name_ || ' ASC';
         ELSE
            stmt_ := 'SELECT distinct ipist.' || stmt_ || ' ORDER BY Utility_SYS.String_To_Number( ' || column_name_ || ' ) ASC, ' || column_name_ || ' ASC';
         END IF;
      END IF;

      @ApproveDynamicStatement(2014-12-09,UdGnlk)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,  
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_,
                                           Material_Requis_Type_API.DB_INT,
                                           order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_;

       IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Only 1 value for AUTO PICK
         FETCH get_lov_values_ INTO lov_value_tab_(1);
      ELSE
         FETCH get_lov_values_ BULK COLLECT INTO lov_value_tab_;
      END IF;
      CLOSE get_lov_values_;

      IF (lov_value_tab_.COUNT > 0) THEN
         CASE (column_name_)
            WHEN ('LINE_NO') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            WHEN ('PART_NO') THEN
               second_column_name_ := 'PART_DESCRIPTION';
            WHEN ('LOCATION_NO') THEN
               second_column_name_ := 'LOCATION_DESCRIPTION';
            WHEN ('HANDLING_UNIT_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('SSCC') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            WHEN ('ALT_HANDLING_UNIT_LABEL_ID') THEN
               second_column_name_ := 'HANDLING_UNIT_TYPE_DESC';
            ELSE
               NULL;
         END CASE;
         
         FOR i IN lov_value_tab_.FIRST..lov_value_tab_.LAST LOOP
            -- Don't fetch details for AUTO PICK
            IF (lov_type_db_ != Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN              
               IF (second_column_name_ IS NOT NULL) THEN
                  IF (second_column_name_ = 'PART_DESCRIPTION') THEN
                     IF (column_name_ = 'PART_NO') THEN
                        second_column_value_ := Inventory_Part_API.Get_Description(contract_, lov_value_tab_(i));
                     ELSE
                        second_column_value_ := Inventory_Part_API.Get_Description(contract_, part_no_);
                     END IF;
                  ELSIF (second_column_name_ = 'LOCATION_DESCRIPTION') THEN
                     second_column_value_ := Inventory_Location_API.Get_Location_Name(contract_, lov_value_tab_(i));
                  ELSIF (second_column_name_ = 'HANDLING_UNIT_TYPE_DESC') THEN
                     IF (column_name_ = 'HANDLING_UNIT_ID') THEN
                        temp_handling_unit_id_ := lov_value_tab_(i);
                     ELSIF (column_name_ = 'SSCC') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Sscc(lov_value_tab_(i));
                     ELSIF (column_name_ = 'ALT_HANDLING_UNIT_LABEL_ID') THEN
                        temp_handling_unit_id_ := Handling_Unit_API.Get_Handling_Unit_From_Alt_Id(lov_value_tab_(i));
                     END IF;
                     second_column_value_ := Handling_Unit_Type_API.Get_Description(Handling_Unit_API.Get_Handling_Unit_Type_Id(temp_handling_unit_id_));
                  END IF;
                  IF (second_column_value_ IS NOT NULL) THEN
                     lov_item_description_ := second_column_value_;
                  ELSE
                    lov_item_description_ := NULL;
                  END IF;
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


-- This method is used by DataCaptIssueMtrlReq
@ServerOnlyAccess
PROCEDURE Record_With_Column_Value_Exist (
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN NUMBER,
   part_no_                    IN VARCHAR2,
   contract_                   IN VARCHAR2,
   configuration_id_           IN VARCHAR2,
   location_no_                IN VARCHAR2,
   lot_batch_no_               IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   waiv_dev_rej_no_            IN VARCHAR2,
   eng_chg_level_              IN VARCHAR2,
   activity_seq_               IN NUMBER,
   handling_unit_id_           IN NUMBER,
   alt_handling_unit_label_id_ IN VARCHAR2,  -- send '%' if this item have not been entered/scanned yet
   column_name_                IN VARCHAR2,
   column_value_               IN VARCHAR2,
   data_item_description_      IN VARCHAR2,
   column_value_nullable_      IN BOOLEAN DEFAULT FALSE,
   inv_barcode_validation_     IN BOOLEAN DEFAULT FALSE )
IS
   TYPE Check_Exist IS REF CURSOR;
   exist_control_   Check_Exist;
   stmt_            VARCHAR2(4000);
   dummy_           NUMBER;
   exist_           BOOLEAN := FALSE;
BEGIN

   -- Select is for reserve manually action or reserve and issue manually action or for undecided action (the action have not been selected yet in configuration)
   stmt_ := 'SELECT 1 
             FROM INVENTORY_PART_IN_STOCK_TOTAL ipist, MATERIAL_REQUIS_LINE_TAB mrl  
             WHERE ipist.contract = :contract_ ';
   IF (part_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.part_no = :part_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :part_no_ IS NULL ';
   END IF;
   IF (configuration_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.configuration_id = :configuration_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL ';
   END IF;
   IF (location_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.location_no = :location_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :location_no_ IS NULL ';
   END IF;
   IF (lot_batch_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.lot_batch_no = :lot_batch_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL ';
   END IF;
   IF (serial_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.serial_no = :serial_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL ';
   END IF;
   IF (eng_chg_level_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.eng_chg_level = :eng_chg_level_ ';
   ELSE
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL ';
   END IF;
   IF (waiv_dev_rej_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.waiv_dev_rej_no = :waiv_dev_rej_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL ';
   END IF;
   IF (activity_seq_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.activity_seq = :activity_seq_ ';
   ELSE
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL ';
   END IF;
   IF (handling_unit_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.handling_unit_id = :handling_unit_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL ';
   END IF;
   IF (alt_handling_unit_label_id_ = '%') THEN 
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ = ''%'' ';
   ELSIF (alt_handling_unit_label_id_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND ipist.alt_handling_unit_label_id  = :alt_handling_unit_label_id_ ';
   ELSE
      stmt_ := stmt_ || ' AND (ipist.alt_handling_unit_label_id IS NULL AND :alt_handling_unit_label_id_ IS NULL) ';
   END IF;
   stmt_ := stmt_ || ' AND mrl.order_class = :order_class ';
   IF (order_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.order_no = :order_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :order_no_ IS NULL ';
   END IF;
   IF (line_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.line_no = :line_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :line_no_ IS NULL ';
   END IF;
   IF (release_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.release_no = :release_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :release_no_ IS NULL ';
   END IF;
   IF (line_item_no_ IS NOT NULL) THEN 
      stmt_ := stmt_ || ' AND mrl.line_item_no = :line_item_no_ ';
   ELSE
      stmt_ := stmt_ || ' AND :line_item_no_ IS NULL ';
   END IF;
   stmt_ := stmt_ || ' AND mrl.qty_due > mrl.qty_shipped
               AND mrl.contract = ipist.contract
               AND mrl.part_no  = ipist.part_no
               AND (((ipist.qty_onhand - ipist.qty_reserved) > 0) 
                 OR (Material_Requis_Reservat_API.Get_Qty_Assigned_If_Unique(mrl.order_class , mrl.order_no , mrl.line_no , mrl.release_no , mrl.line_item_no, 
                                                                          ipist.part_no, ipist.contract, ipist.configuration_id, ipist.location_no, ipist.lot_batch_no, 
                                                                          ipist.serial_no, ipist.waiv_dev_rej_no, ipist.eng_chg_level, ipist.activity_seq, ipist.handling_unit_id) > 0)) 
               AND ipist.location_type_db  = ''PICKING'' 
               AND ipist.part_ownership_db IN (''COMPANY OWNED'',''CONSIGNMENT'') 
               AND (mrl.supply_code != ''PO'' OR (mrl.qty_assigned > 0))
               AND mrl.status_code != 9';

   
   IF (NOT inv_barcode_validation_) THEN  
   -- only validate column if this is not a barcode validation since if its barcode validation we want to validate the whole record and not 1 item
      IF (column_name_ IN ('ORDER_NO','LINE_NO','RELEASE_NO','LINE_ITEM_NO')) THEN
         -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
         Assert_SYS.Assert_Is_View_Column('MATERIAL_REQUIS_LINE', column_name_);
         IF (column_value_nullable_) THEN
            stmt_ := stmt_ || ' AND ((mrl.' || column_name_ || ' = :column_value_) OR (mrl.' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
         ELSE -- NOT column_value_nullable_
           stmt_ := stmt_ || ' AND mrl.' || column_name_ ||'  = :column_value_ ';
         END IF;
      ELSE
         -- extra column check to be sure we have no risk for sql injection into column_/data_item_id
         Assert_SYS.Assert_Is_View_Column('INVENTORY_PART_IN_STOCK_TOTAL', column_name_);
         IF (column_value_nullable_) THEN
            stmt_ := stmt_ || ' AND ((ipist.' || column_name_ || ' = :column_value_) OR (ipist.' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
         ELSE -- NOT column_value_nullable_
           stmt_ := stmt_ || ' AND ipist.' || column_name_ ||'  = :column_value_ ';
         END IF;
      END IF;
   END IF;            

   IF (inv_barcode_validation_) THEN
      -- No column value exist check, only check the rest of the keys
      @ApproveDynamicStatement(2017-11-13,DAZASE)            
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          part_no_,
                                          configuration_id_,
                                          location_no_,
                                          lot_batch_no_,
                                          serial_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,  
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          Material_Requis_Type_API.DB_INT,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_;

   ELSIF (column_value_nullable_) THEN
      -- Column value check on a nullable column
      @ApproveDynamicStatement(2015-11-04,DAZASE)            
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          part_no_,
                                          configuration_id_,
                                          location_no_,
                                          lot_batch_no_,
                                          serial_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,  
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          Material_Requis_Type_API.DB_INT,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
                                          column_value_,
                                          column_value_;
   ELSE
      -- Column value check without any nullable handling
      @ApproveDynamicStatement(2014-12-09,UdGnlk)            
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          part_no_,
                                          configuration_id_,
                                          location_no_,
                                          lot_batch_no_,
                                          serial_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,  
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_,
                                          Material_Requis_Type_API.DB_INT,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
                                          column_value_;
   END IF;


   FETCH exist_control_ INTO dummy_;
   IF (exist_control_%FOUND) THEN
      exist_ := TRUE;
   END IF;
   CLOSE exist_control_;
   IF (NOT exist_) THEN
      IF (inv_barcode_validation_) THEN
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST1: The Barcode record does not match current Material Requisition Line.');
      ELSE
         Error_SYS.Record_General(lu_name_, 'VALUENOTEXIST2: :P1 :P2 does not exist in the context of the entered data and this process.', data_item_description_, column_value_);
      END IF;
   END IF;
END Record_With_Column_Value_Exist;


-- Modify_Activity_Seq
--   For modification of Activity Sequence.
PROCEDURE Modify_Activity_Seq (
   order_class_db_  IN VARCHAR2,
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   release_no_      IN VARCHAR2,
   line_item_no_    IN NUMBER,
   activity_seq_    IN NUMBER)
IS
  attr_          VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'ACTIVITY_SEQ', activity_seq_, attr_);
   Modify_Impl___(attr_, order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
END Modify_Activity_Seq;

-- Change_Supply_Code
--   Modifies the supply code of a record.
PROCEDURE Change_Supply_Code(
   order_class_db_ IN VARCHAR2,
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   release_no_     IN VARCHAR2,
   line_item_no_   IN NUMBER,
   supply_code_    IN VARCHAR2)
IS
   rec_  material_requis_line_tab%ROWTYPE;
BEGIN
   rec_ := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_);
   rec_.supply_code := supply_code_;
   Modify___(rec_, TRUE);
END Change_Supply_Code;

-- Get_Part_Unit_Meas
--   Returns the UoM of the part / no part.
@UncheckedAccess
FUNCTION Get_Part_Unit_Meas (
   contract_  IN VARCHAR2,
   part_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   unit_meas_    VARCHAR2(30);
   supplier_     VARCHAR2(20);
BEGIN
   IF Inventory_Part_API.Check_Stored(contract_, part_no_) THEN
      unit_meas_ := Inventory_Part_API.Get_Unit_Meas(contract_, part_no_);
   ELSE
      $IF Component_Purch_SYS.INSTALLED $THEN
         supplier_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, part_no_);
         IF supplier_ IS NULL THEN
            unit_meas_ := Purchase_Part_API.Get_Default_Buy_Unit_Meas( contract_ , part_no_);            
         ELSE
            unit_meas_ := Purchase_Part_Supplier_API.Get_buy_unit_meas( contract_ , part_no_, supplier_);
         END IF;
      $ELSE
         NULL;
      $END
   END IF;
   RETURN unit_meas_;
END Get_Part_Unit_Meas;

