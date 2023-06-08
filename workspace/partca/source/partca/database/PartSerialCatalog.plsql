-----------------------------------------------------------------------------
--
--  Logical unit: PartSerialCatalog
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211122  ChWkLk  MF21R2-6056, Modified Remove_Superior_Info() to remove unnecessary NULL parameters from Move_To_Facility() method call.
--  211101  NEKOLK  AM21R2-2960 : EQUIP redesign PARTCA changes : alternate_id obsolete work 
--  210518  kaaulk  Bug 158765, [MFZ-7412] Modified Rename() to copy existing as-built structure and create new structure with new name and serial no
--  210505  Asiglk  MF21R2-61, Deford IUID development, Calling deford when creating serial part with NewInFacility, NewInInventory, NewInContained options.
--  210427  KETKLK  PJ21R2-448, Removed PDMPRO references.
--  210409  JaThlk  SC21R2-792, Modified New_In_Issued() to assign the operational condition value to correct variable, operational_condition instead of condition_code.
--  210222  SBalLK  Issue SC2020R1-12657, Modified Rename() and New_As_Renamed() method to reset indicator rec for non insertable/updatable attributes
--  210222          accordingly to avoid errors while renaming serials.
--  210208  CLEKLK  AM2020R1-7085, Modified Set_Operational_Condition___() method by passing update by keys parameter as true to update record using entity keys.
--  210203  jagrno  Bug 157113 (MFZ-6254). Modified method Check_Op_Status_Transition___ to allow transition between 
--                  operational statuses PLANNED_FOR_OP and SCRAPPED, both ways.
--  210128  SBalLK  Issue SC2020R1-11830, Modified methods with Client_SYS.Add/Set_To_Attr() by removing attr_ functionality to optimize the performance.
--  210122  pawilk  AM2020R1-7325,  Call Part_Manu_Part_Rev_API.Check_Manu_Of_Part_Rev( ) either creating new serials or updating manufacturer_no or manu_part_no in Validate_Items___.
--  201124  JaThlk  SC2020R1-11283, Modified Set_Manufacturer_Info to check whether the manufacturer information has been changed.
--  201116  UdGnlk  SC2020R1-11368, Removed TEXT_ID$ usages.
--  201109  JaThlk  SC2020R1-10314, Modified Check_Common___ and added Manufacturer_Serial_Exists___ to validate Manufacturer Serial No.
--  200925  JaThlk  SC2020R1-10047, Modified the Set_Manufacturer_Info to set the value of CREATED_BY_SERVER to 1.
--  200918  JaThlk  SC2020R1-1191, Added the Set_Manufacturer_Info procedure to change manufacturer information.
--  200217  chanlk  Bug 152198(SAZM-4555), Modified Finite_State_Set___, When Serial retured to Inventory underlying structure should set to out of operation.
--  200210  disklk  Bug 152278, Modified Set_Ownership_After_Issue___ to set the part ownership to customer owned for serials that delivered through shipments created from project deliverables.
--  190925  DaZase  SCSPRING20-119, Added Raise_Invalid_State___() to solve MessageDefinitionValidation issue.
--  190918  ShPrlk  Bug 148683(SCZ-5655), Modified Return_To_Supplier to avoid state being set again to 'ReturnedToSupplier' in three site intersite flow comprising three different companies.
--  190529  jagrno  Moved call to Vim_Serial_API.Check_Maint_Dates_Change from method Check_Maintenance_Dates___ to method Update___
--  180823  NiLalk  Bug 143646, Modified Move_To_Inventory by adding a new eng_part_revision parameter and called Modify_Eng_Part_Revision method. Modified Modify_Eng_Part_Revision___() and
--  180823          New_In_Inventory() methods to update eng_part_revision only when valid engineering revision exists in the system.  Added Validate_Eng_Part_Revision___() method.
--  180601  SAMGLK  Bug 142248, Validate_Items___() is modifed to check the manufaturer only for VIM serials.
--  180508  UdGnlk  Bug 141148, Modified Check_Rename_Part_No() by moving the code of message CONFIGURED to the validation when part no change. 
--  180423  CLEKLK  Bug 141271, modified Finite_State_Set___ When serial object is moved to Inventory  rowstate is in 'InRepairWorkshop' while the state is in 'InInventory' its parent connection should be cleared.
--  180220  SBalLK  Bug 138993, Modified Modify_Serial_Structure() method to ignore validate supplier shipped part when modify structure through purchase order backflush.
--  180220  SBalLK  Bug 140034, Added Delivered_To_Internal_Customer() method for restrict to place delivered part in "InFacility" through Serial Maintenance Aware window
--  180220          until complete the register direct delivery of internal purchase order.
--  171205  KHVESE  STRSC-9352, Modified method Consume_Customer_Consignment and removed parameter transaction_desc_ from its signature.
--  171110  KHVESE  STRSC-9352, Renamed method Report_Consumed to Consume_Customer_Consignment.
--  171030  KHVESE  STRSC-9352, Modified method Issue() with new parameter set_ownership_ and modified method Report_Consumed.
--  171004  KHVESE  STRSC-9352, Added method Report_Consumed.
--  171002  LEPESE  STRSC-12557, Added method Check_Rename_Part_No.
--  170920  LEPESE  STRSC-12176, Change in method Remove__ to allow deletion of a renamed serial if renamed_from and renamed_to are identical.
--  170918  LEPESE  STRSC-12176, Change in method Delete___ to allow deletion of a renamed serial if renamed_from and renamed_to are identical.
--  170726  TiRalk  STRSC-10765, Added method Remove_Warranty_Dates to handle both Supplier warranty and Customer warranty removals.
--  170726          Added method Remove_Sup_Warranty_Dates to remove supplier warranty dates.
--  170704  BudKlk  Bug 136234, Modified method Check_Insert___() to make sure that the orginal value will be save when the serial rule is automatic.
--  170509  jagrno  Added parameter manufacturer_no_ to method Set_Eng_Part_Revision.
--  170123  SEROLK  STRSA-13688, Modified method Tool_Equipment_Serial_Exist___.
--  161208  MeAblk  Bug 132933, Added method  Is_Last_In_Rename_Chain___() and modified Delete___() and Remove__() to make it possible to remove a serial if the
--  161208          identify of its renamed from serial is same as the last serial in the renaming chain. Also removed the condition in checking whether the serial
--  161208          is in InFacility or Contained when removing it.
--  160824  JeeJLK  Bug 130281, Method signature of Check_Delete___ and Remove altered by adding new parameter force_removal_ and modified Delete___ to delete
--  160824          serials in the chain.
--  160802  SWeelk  Bug 130373, Added the default null parameter owning_vendor_no_, to the procedure New_In_Contained()
--  150820  DaZase  COB-567, Added trunc on all date checks in Check_Maintenance_Dates___ to avoid any timestamp issues.
--  150817  NaSalk  RED-685, Added Check_Common___ to prevent receiving serials with a FA link with an ownership other than CRA and Supplier Rented.
--  150812  NaSalk  RED-685, Added Check_Common___ to prevent receiving serials with a FA link with an ownership other than CRA.
--  150701  NaSalk  RED-556, Added Serials_With_Fa_Object_Exists function.
--  150622  NaSalk  RED-543, Added default value for fa_system_defined in Check_Insert___. Added new methods Set_Fa_Object_Reference and
--  150619  IsSalk  KES-517, Renamed Remove_Warranty_Dates() to Remove_Cust_Warranty_Dates().
--  150616  IsSalk  KES-517, Removed Get_Children_And_Remove() and added Remove_Warranty_Dates().
--  150406  IsSalk  KES-517, Added Get_Children_And_Remove() to find and remove warranty dates connected to child parts of a serial part.
--  150622          Get_Fa_Object_Reference.
--  150519  SBalLK  Bug 122249, Added Disable_Tracked_In_Inventory() method to disable 'Tracked In Inventory' check box when enable the 'In Inventory'
--  150519          serial tracking in PartCatalog Lu.
--  150226  JaBalk  PRSC-6238, Modified Check_Part_Ownership___ to remove the validations OWNERSHIPPARENT, OWNERSHIPCHILD for COMPANY RENTAL ASSET.
--  150209  Chfose  PRSC-6036, Added TRUNC on sysdate in order to remove the time part in Check_Maintenance_Dates___.
--  141116  AwWelk  PRSC-1036, Restructured the validations for ConfigurationId, OwningVendorNo and OwningCustomerNo with DbCheckImplementation 'custom' property.
--  141116          Removed Check_Owning_Vendor_No___() and Check_Owning_Customer_No___().
--  140930  NaSalk  Modified Set_Serial_Ownership to add a history for company rental asset to company owned ownership transfers.
--  140918  BudKlk  Bug 118711, Created a new function Has_Alphanumeric_Serial().
--  140828  NaSalk  Modified Set_Serial_Ownership to add a history for company owned to company rental asset ownership transfers.
--  140806  Matkse  PRSC-319, Replaced overtake of Finite_State_Init___ with an override of Finite_State_Machine___. The in-parameter serial_event_ to Finite_State_Init___
--                  which caused the overtake was not even used anywhere in the code.
--  140710  AwWelk  PRSC-1526, Removed overriden Unpack___ method and moved the logic to Check_Update___ method.
--  140619  RaNhlk  Bug 116210, Modified Unissue() adding parameter configuration_id_ and called Modify_Configuration_Id___() inside it. 
--  140522  LEPESE  PBSC-9829, added method Reset_Tracked_In_Inventory.
--  140509  UdGnlk  PBSC-9214, Modified translation tag NOTRENAMED to NOTRENAMEDREMOVE in Remove__() as it exist twice;   
--  140509  UdGnlk  PBSC-9033, Merged bug 116598 Modified Check_In_Inventory_Allowed___() to perform the similar checks as 'Issued' state for 'InFacility' state.
--  140509          Modified Unpack_Check_Update___() to make it possible to set ignore_stop_arrival_issued when serial is 'InFacility'.
--  140509          Also modified Finite_State_Set___() to reset ignore_stop_arrival_issued for serials moving to inventory from 'InFacility'.
--  140506  NIFRSE  PBSA-4228, Added Equipment Serial Object handling in the Finite_State_Set___().
--  140424  AwWelk  PBSC-6642, Removed the default assignment for configurationId from check_insert___ and added logic in insert___()
--  140424          to only assign the default configurationId "*" when it is null and when the serial_event equals to 'NewInFacility'.
--  140407  LEPESE  PBSC-8041, Assigned NULL to newrec_.rowkey when creating new serial in method Rename.
--  140325  AwWelk  PBSC-7643, Modified Rename_Non_Vim_Serial() to restrict renaming serial when ToolEquipment object exists. Added
--  140325          Tool_Equipment_Serial_Exist___ method.
--  140307  jagrno  Removed call to Vim_Serial_From_Remote_API.Send_Serial from method New_In_Inventory.
--  140124  Asawlk  Bug 112448, Modified Set_Operational_Status___() to stop the change of operational_status_ of scrapped serials if the parent
--  140124          object is not scrapped.--  131119  UdGnlk  PBSC-3396, Modified Insert___() to retrieve a value to rowstate just to correct before refactoring. 
--  131113  NaLrlk  Modified Set_Ownership_After_Issue___() to resolve EBALL merging complict with rental.
--  130924  JanWse  Bug 110613, Modified Check_In_Inventory_Allowed___() to allow the intersite flow involving  
--  130924          different companies to proceed with the internal PO receipt making the serial InInventory. 
--  130920  SWiclk  Bug 111864, Modified Check_Valid_Serial_For_Part() in order to check existence of serial no when the part is serial tracked.
--  130917  Asawlk  Bug 112469, Made column configuration_id updatable. Added method Modify_Configuration_Id___(). Modified Move_To_Inventory()
--  130917          by adding parameter configuration_id_ and calling Modify_Configuration_Id___() inside it. 
--  130903  SBalLK  Bug 111695, Added function Part_Has_Serials() to check the part has serials.
--  130903          Modified Unpack_Check_Insert___() to convert serial number to a number value when serial rule is automatic.
--  130903          Modified Get_Max_Part_Serial_No() to get maximum serial number if serial numbers for the parts are numbers.
--  130916  MAWILK  BLACK-566, Replaced Component_Pcm_SYS.
--  130730  MaIklk  TIBE-1046, Removed serial_event__ global variable and instead defined the serial event 
--                  as a derived attribute and passed the serial event value using attr_.
--                  Also removed other global constants and used conditional compilation instead.
--  130614  UdGnlk  EBALL-107, Modified Set_Ownership_After_Issue___() to avoid the changing for CRO exchange functionality.
--  130829  ChBnlk  Bug 109847, Modified method New_In_Inventory() by adding BUYER and CURRENCY_CODE to the attribute string.
--  130710  ErFelk  Bug 111142, Corrected the method name in General_SYS.Init_Method of Move_To_Unlocated___().
--  130602  Asawlk  EBALL-37, Modified Check_Delete___() by using Invent_Part_Quantity_Util_API.Check_Individual_Exist() to check the
--  130602          quantities that exist at customer too. 
--  130528  AyAmlk  Bug 110245, Modified Remove__() in order to provide a more informative error message.
--  130213  RiLase  Added Generate_Serial_Numbers and Get_Formatted_Serial_No.
--  130118  BhKalk  TWOSA-518, Modified Check_Maintenance_Dates___() to handle manufacture date change.
--  121211  PraWlk  Bug 107242, Modified Modify_Note_Text() by modifying the parameter name from alternate_id_ to reported_user_.
--  121211          Also fomatted the note creation logic by including name of the reported user and the date. 
--  121204  NaSalk  Modified Check_Part_Ownership___, Unpack_Check_Insert___, Unpack_Check_Update___, Get_Structure_Ownership, 
--  121204          Set_Serial_Ownership  and Set_Ownership_After_Issue___to include ownership validations for Supplier Rented and Company Rental Asset. 
--  121204          Added Is_Parent___.
--  121115  NaSalk  Modified Insert___, Update___ and Check_Part_Ownership___ to include ownership validations for Supplier Rented and Company Rental Asset. 
--  120924  PraWlk  Bug 105353, Added new method Get_Top_Serial___() and called it from Get_Top_Parent() to provide 
--  120924          a better recursive solution.   
--  120906  PraWlk  Bug 104756, Modified Unissue() by adding new default parameter eng_part_revision. Added new method  
--  120906          Modify_Eng_Part_Revision___() and called it from Unissue().
--  120814  DaZase  Added method Check_Valid_Serial_For_Part.
--  120227  RoJalk  Modified Move_To_Facility and Move_To_Inventory and called Set_Operational_Condition___ before Set_Operational_Status___. 
--  120222  LEPESE  Changes in Check_Rename___ to allow renaming of serials that are only After Delivery Tracked.
--  111215  GanNLK  In the insert__ procedure, moved objversion_ to the bottom of the procedure.
--  111122  LEPESE  Added method Set_Tracked_In_Inventory. Added code in Finite_State_Set___ to make sure
--  111122          that tracked_in_inventory always is set to 'FALSE' when serial is removed from inventory.
--  111116  RaKalk  Added mandatory column tracked_in_inventory.
--  110917  ShKolk  Modified error message RENAMEONLYSERIAL to fix a spelling error.
--  110615  LEPESE  Modification in Check_Rename___ to allow renaming for parts that are Receipt and Issue Serial Tracked.
--  110603  LoPrlk  Issue: EASTONE-18578, Added parameter operational_condition_db_ to method Move_To_Contained.
--  110526  DiAmlk  Jira Bug ID: EASTONE-18577 - Added parameter operational_condition_db_ to method Move_To_Facility.
--  110524  LEPESE  Added parameter reversing_earlier_update_ to methods Set_Operational_Condition___ and Set_Operational_Condition.
--  110524          Added parameter reversing_op_condition_ to method Unpack_Check_Update___.
--  110514  MaEelk  Added missing assert safe comment to Check_Delete___ and In_Stock_But_Not_Identified.
--  110511  MaEelk  Removed the global lu constant db_non_operational_ and replaced its value with
--  110511          Serial_Operational_Cond_API.DB_NON_OPERATIONAL in scrap.
--  110421  LEPESE  Modification in method Scrap to set the operation_condition of child serials
--  110421          to 'NON_OPERATIONAL' regardless of previous value.
--  110414  LEPESE  Added parameter lot_batch_no_ to method Move_In_Inventory.
--  110414          Added call to Modify_Lot_Batch_No___ from inside of Move_In_Inventory.
--  110321  PraWlk  Bug 96322, Modified Check_Op_Status_Transition___() by adding OUT_OF_OPERATION to the condition.
--  110307  MaEelk  Added Rename_Non_Vim_Serial to rename a non vim serial from part serial catalog.
--  101217  GayDLK  Bug 94768, Used the decode functions for error messages INVALIDCURPOS,INVALIDCOMBST,INVALIDCOMBCOND   
--  101217          in Check_Dimension_Dependency___(). 
--  ----------------------- Blackbird Merge Start -----------------------------
--  101105  BhKaLK  Merged Blackbird Code.
--  101021  BhKaLK  BB10, Added a new parameter initial_replace_date_ to Set_Operational_Condition() and Set_Operational_Condition___().
--  101018  BhKaLK  BB10, Modified error message in Check_Dimension_Dependency___().
--  101015  BhKaLK  BB10, Modified Set_Operational_Condition and removed the error message in method Set_Operational_Condition().
--  101013  BhKaLK  BB10, Added an error message to method Set_Operational_Condition().
--  101008  BhKaLK  BB10, Added method Set_Operational_Condition() and Removed the overloaded method Set_Operational(). 
--  100101  ImFeLK  BB10, Modified methods Move_To_Inventory(), Unissue() to check whether the operational_condition_db exist.
--  101001  BhKaLK  BB10, Modified methods Set_Non_Operational(), Unscrap(), Unscrap_At_Supplier().
--  100923  BhKaLK  BB10, Modified methods Set_Operational_Condition___() and Set_Operational(). 
--  100906  ToFjNo  NOIID: Removed checks from Remove and added them to Check_Delete.
--  100915  ImFeLK  BB10, Added paramater operational_condition_db to methods Move_To_Inventory(), Unissue(), Move_In_Inventory() and New_In_Inventory().
--  100910  BhKaLK  BB10, Added new out param 'Info_' to Set_Operational_Condition___() and Updated the caller method OF Set_Operational_Condition___()
--  100910                Added a new overloaded Set_Operational().
--  100906  ToFjNo  BBIRD-288: Modified Remove to check if records exist in PCM and raise error if it does.
--  ----------------------- Blackbird Merge End -----------------------------
--  101015  GayDLK  Bug 93374, Changed the place where the comments were added.
--  101006  GayDLK  Bug 93374, Added a 'A' as the TYPE Flag for PART_NO column in PART_SERIAL_CATALOG_LOV view. 
--  110124  LaRelk  Added In_Stock_But_Not_Identified() and Get_In_Stock_Not_Identified() to identify serial no for 
--  110124          At Receipt and Issue Tracked parts only.
--  100507  MaEelk  Created Check_Owning_Customer_No___ and Check_Owning_Vendor_No___ and centralized the validations
--  100507          forr owining_vendor_no and owning_customer_no. Called it from Unpack_Check_Insert___ and Unpack_Check_update___.
--  100504  MaEelk  Moved the validations of Part Ownership to Check_Part_Ownership___ and called it from Unpack_Check_Insert___
--  100504          Unpack_Check_Update___.
--  100622  GayDLK  Bug 90836, Increased the length of the variable attr_ from 2000 characters to 32000 characters  
--  100622          in procedures New_In_Contained(),New_In_Facility(),New_In_Inventory() and New_In_Issued().
--  100423  KRPELK  Merge Rose Method Documentation.
--  100323  Cpeilk  Bug 88868, Added method Set_Ownership_After_Issue___ which will be used when order type is CUST ORDER.
--  100323          It will be called from methods New_In_Issued and Issue. Allowed supplier warranty to be converted to a
--  100323          customer warranty when serial catalog status is Issued in method Set_Sup_Warranty.
--  100318  SuSalk  Bug 89119, Added manufactured_date_ default null parameter to New_In_Inventory method and 
--  100318          added MANUFACTURED_DATE to attribute string in the same method
--  100120  HimRlk  Moved method calls to Transaction_SYS.Logical_Unit_Is_Installed to Global constants.
--  091106  PraWlk  Bug 86926, Added new parameter manu_part_no_ to procedure Set_Eng_Part_Revision.
--  091022  HoInlk  Bug 86113, Modified method Get_Previous_Current_Position by allowing to ignore completely
--  091022          reversed transactions. Modified call to this method from Unscrap.
--  090929  MaJalk  Removed unused views, variables, constants and parameters.
--  -------------------------- 13.0.0 --------------------------------------------
--  091106  PraWlk  Bug 86926, Added new parameter manu_part_no_ to procedure Set_Eng_Part_Revision.
--  091022  HoInlk  Bug 86113, Modified method Get_Previous_Current_Position by allowing to ignore completely
--  091022          reversed transactions. Modified call to this method from Unscrap.
--  090827  PraWlk  Bug 82147, Modified Delete___ to pass correct part_no and serial_no to Check_Exist___.
--  090813  PraWlk  Bug 82147, Added public attribute rename_reason to PART_SERIAL_CATALOG view. Modified
--  090813          Update___, Delete___, Remove___, Remove and Rename. Added Reset_Renamed_From___. Added 
--  090813          Get_Renaming_Trans_Desc___.
--  090806  NiBalk  Bug 84938, Added text_id$ to PART_SERIAL_CATALOG view.
--  090602  HoInlk  Bug 82975, Modified Modify_Note_Text to trim note_text to 2000 characters before inserting.
--  090529  SaWjlk  Bug 83173, Removed the prog text duplications.
--  090525  SaWjlk  Bug 81907, Added logic in the procedure Issue to set the ownership.
--  090516  SuThlk  Bug 82760, Added new parameter eng_part_revision_ to the procedure New_In_Inventory
--  090516          and passed eng_part_revision_ value to Part_Serial_History_API.New method.
--  090325  MaEelk  Bug 80712, Modified Unscrap. Changed the order of unscrapping processes
--  090220  DAYJLK  Bug 79125, Added procedure Disconnect_From_Parent. Added functions Vim_Serial_Exist___,
--  090220          Equipment_Serial_Exist___, Shpord_Completely_Received___, and Issued_To_Ext_Service_Order___.
--  090220          Modified Check_In_Inventory_Allowed___ to use the new functions which hide the implementation details.
--  090105  HoInlk  Bug 79587, Modified parameters in call to Doc_Reference_Object_API.Copy
--  090105          within method Rename to avoid bind conflict.
--  081215  DAYJLK  Bug 78957, Modified Set_Serial_Ownership by replacing error messages OWN_CHG_COCOMP and
--  081215          OWN_CHG_SCOMP with OWN_CHG_SUPCOMP and added check to ensure that method
--  081215          Part_Serial_History_API.New is invoked only when variable message_ is not empty.
--  081211  DAYJLK  Bug 79113, Modified condition to exclude operational status SCRAPPED to facilitate
--  081211          the delete of scrapped serials in Check_Delete___.
--  081125  RoJalk  Bug 77820, Modified Set_Serial_Ownership and and include a serial history
--  081125          message when ownership was modified from consignment to company owned.
--  081020  PraWlk  Bug 77822, Modified Procedure New_In_Issued by adding parameter inv_transaction_id_.
--  080925  NuVelk  Bug 76386, Added parameter create_serial_history_ to
--  080925          Set_Serial_Ownership and Set_Structure_Ownership___.
--  080912  MaEelk  Bug 76809, Modified Check_Delete___ and Delete___ to control the process of removing renamed serials.
--  080715  NiBalk  Bug 75271, Added Issue_Supplier_Owned_Stock___ and modified Check_In_Inventory_Allowed___ to recieve serial
--  080715          parts in a correct way if the company is set up with Ownership Transfer Point as Receipt into Inventory
--  080514  NuVelk  Bug 73230, Added default NULL order reference parameters order_no_, line_no_,release_no_,
--  080514          line_item_no_, order_type_ to method Remove_Superior_Info and passed these parameters
--  080514          when calling to method Move_To_Issued.
--  080508  Prawlk  Bug 73471, Deleted call for General_SYS.Init_Method in FUNCTION Get_Top_Parent_State
--  080508          and PROCEDURE Get_Top_Parent.
--  080506  NuVelk  Bug 72249, Added Attribute ignore_stop_arrival_issued and associated methods.
--  080506          Also added Eso_Or_Mro_Purch_Order_Line___,Cancel_Purch_Comp_Issue___ and
--  080506          called it from Check_In_Inventory_Allowed___. Added parameter transaction_id_
--  080506          to Check_In_Inventory_Allowed___.
--  080131  NuVelk  Bug 70468, Added function Created_By which returns TRUE if part no, Serial no
--  080131          combination was originated from the same shop order. FALSE otherwise.
--  080124  MaEelk  Bug 69972, Modified Check_In_Inventory_Allowed___ to check the validity of sending a serial part
--  080124          into Inventory when it is already issued to a Shop Order
--  080103  HoInlk  Bug 69146, Modified methods Set_Operational_Condition___, Set_Operational_Status___, Set_Scrapped___,
--  080103          Set_Operational_Condition___, Set_Operational_Status___, Set_Non_Operational and Move_To_Issued
--  071218          parameters to transfer order information. Added parameter latest_transaction_ to method Unscrap.
--  071201  NUVELK  Bug 69428, Add default FALSE parameter scrap_at_supplier_ to PROCEDURE Scrap and
--  071201          changed logic to allow scrapping when it is set to TRUE.
--  071119  HoInlk  Bug 66355, Added procedure Check_In_Inventory_Allowed___, to check if a given serial is allowed
--  071119          to be received back into inventory. Called this method from Move_To_Inventory and Unissue.
--  071113  MaEelk  Bug 67252, Made a call to Equipment_Object_Util_API.Handle_Scrap_Serial from Update___
--  071113          in order to check if work orders exist for the scrapped serial part
--  070921  DAYJLK  Modified procedure Rename to set attributes Renamed From Part No and Renamed From Serial No to NULL on the origin serial.
--  070831  WaJalk  Added missing parameter lu_name_ in the error message with tag RENSTATERR of method Rename.
--  070717  DAYJLK  Added method New_As_Renamed. Modified methods Unpack_Check_Insert___, Unpack_Check_Update___, Insert___ and Update___ to handle derived attribute TRANSACTION_DATE.
--  070710  MiKulk  Bug 65870, Added implementation method Set_Scrapped___ and modified the procedure
--  070710          Scrap in order to allow scrapping a component part after being issued to a shop order.
--  070702  MiKulk  Bug 65104, Modified method scrap and called the method Set_Non_Operational
--  070702          before Set_Scrapped method, also moved 'SCRAPPED' validation to method Scrap.
--  070702          Redesigned method Scrap to enhance performance and remove side-effect of patch 63290.
--  070702          Added new method Get_All_Children___. Made Move_To_Unlocated to implementation method and removed
--  070702          parameter operational_status_db_ and method call Set_Operational_Status___.
--  070702          Added public type Serial_Rec.
--  070517  NaWilk  Modified fields renamed_to_part_no and renamed_from_part_no as public.
--  070514  KaDilk  Call 144148 Modified method Check_Rename__ to allow rename SUPPLIER LOANED serials.
--  070504  KaDilk  Modified procedure Check_Rename___ to set the correct order of error messages.
--  070425  Nibulk  Checked and added mising Assert Safe comments where necessary.
--  070417  RoJalk  Removed TRUE in call General_SYS.Init_MethodModify_Latest_Transaction.
--  070405  ViGalk  Bug 63290, Modified methods Update___ and Move_To_Unlocated, in order to add
--                  validations to prevent scrapping of serials.
--  070308  SuSalk  LCS Merge 62298, Modified method Move_To_Unlocated in order to disallow scraping of serial parts that
--  070308          have been issued and shipped to a supplier. Modified method Modify_Serial_Structure in order to
--  070308          disallow install serial in serial structure when serial have been issued and shipped to a supplier.
--  070212  DAYJLK  B140897, Modified Check_Rename___ to raise error when multi-level tracking code does not match.
--  070212  ChJalk  Bug 61446, Added the default null parameter owning_vendor_no_, to the procedure New_In_Facility.
--  -------------------------- Wings Merge End -----------------------------------
--  070129  DAYJLK  Merged Wings Code.
--  070126  DAYJLK  Moved all validations to new implementation method Check_Rename___. Replaced Check_Rename with
--  070126          Check_Rename___ in Unpack_Check_Insert___ and Unpack_Check_Update___
--  070123  DAYJLK  B129657, Modified F1 flags on PART_NO in view PART_SERIAL_CATALOG to be available in LOV.
--  070119  DAYJLK  B129619, Modified Rename to set correct operational status when reversing rename of serials.
--  070119  DAYJLK  Code cleanup on methods Check_Rename, Rename, Insert___, Unpack_Check_Insert___, Unpack_Check_Update___
--  070119          and Update___. Added implementation method Validate_Rename___.
--  070112  DAYJLK  B129407, Modified Rename to set correct attribute values when reversing Part ID change to existing serial.
--  070112  DAYJLK  B129423, Modified Insert___ and Update___ to invoke Replace_Serial_No in InventoryPartInStock when the from part serial is in state InInventory.
--  070112  DAYJLK  B129385, Modified Unpack_Check_Update___ to skip update if null check when flag created by server is true for
--  070112          attributes INSTALLATION_DATE and MANUFACTURED_DATE. Reversed F1 flags for field ENG_PART_REVISION to Update not allowed.
--  070111  DAYJLK  Modified Check_Rename by changing the error messages and converting existing code to be invoked as dynamic statements where necessary.
--  070111          Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ by changing the error messages added earlier.
--  070105  DAYJLK  Modified Set_Manufactured_Date, Set_Installation_Date, and Set_Eng_Part_Revision to use Unpack_Check_Update___.
--  070105          Modified Unpack_Check_Update___ by moving validations from Set_Manufactured_Date, and Set_Installation_Date.
--  070105          Modified Update___ by moving history update from Set_Eng_Part_Revision.
--  070104  DAYJLK  Modified methods Rename, Insert___ and Update___.
--  070101  DAYJLK  Added method Check_Rename. Modified Finitie_State_Machine___ and Finite_State_Events__ to handle transition
--  070101          from state Unlocated to Contained. Modified methods Unpack_Check_Insert___, Unpack_Check_Update___, Insert___ and
--  070101          Update___. Removed methods Rename_Allowed and Rename_Allowed___.  Moved Get_Top_Parent to the end of the package.
--  061221  DAYJLK  Modified Get_Top_Parent and Get_Top_Parent_State.
--  061212  KaDilk  Added Validations required for Part Serial Renaming functionality in Rename_Allowed___.
--  061208  DAYJLK  Added public methods Rename_Allowed and Rename, and implementation
--  061208          method Rename_Allowed___. Included new attributes renamed_to_part_no and renamed_from_part_no
--  061208          in views and in methods which take care of Insert and Update.
--  060722  FRWAUS  MFAD 1052 - Added PART_SERIAL_CATALOG_LOV1 view
--  -------------------------- Wings Merge Start ---------------------------------
--  061206  NaLwlk  Bug 60731, In method Move_In_Inventory, Changed value of the parameter history_purpose_db_
--  061206          when calling Modify_Latest_Transaction.
--  061127  ChBalk  Bug 60757, Added default parameter condition_code_ to New_In_Issued.
--  061106  NiBalk  Bug 60671, Modified the procedure Unpack_Check_Insert___,
--  061106          in order to avoid special characters used by F1.
--  060915  KaDilk  Bug 59111,Modified methods New_In_Contained, New_In_Facility, New_In_Inventory and New_In_Issued to include
--  060810          manufacturer_no and manufacturer_part_no parameters to the Part_Serial_History_API.New method call.
--  060914  KaDilk  Bug 58785, Added default null parameter manu_part_no_ and added
--  060627          manu_part_no to the attribute string in PROCEDURE New_In_Inventory
--  060911  MalLlk  Bug 52710, Modified ReturnedToSupplier state in Finite_State_Machine___ and Finite_State_Events__
--  060911          by adding events MoveToTransport and Issue. Changed implementation method Modify_Latest_Transaction___
--  060911          to a public method Modify_Latest_Transaction. Modified methods Issue, Move_In_Inventory,
--  060911          Move_To_Contained, Move_To_Facility, Move_To_Inventory, Move_To_Issued, Move_To_Transport,
--  060911          Move_To_Unlocated, Move_To_Workshop, Return_To_Supplier and Unissue.
--  060817  KaDilk  Reverse the public cursor removal changes done.
--  060712  KaDilk  Added procedure Get_Superior_Info,Removed the public cursor get_component_serial_no_cur.
--  060517  SeNslk  Modified PART_SERIAL_ISSUE to use part_serial_history_tab instead of using
--  060517          part_serial_history VIEW to remove dependency. Also modified variable declarations
--  060517          to use table column type instead of view column type for part_serial_history_tab columns.
--  060502  MarSlk  Bug 56279, Added Shipped_To_Supplier___ to check if the serial part is issued and shipped
--  060502          to the supplier. Modified rename method and added error message if serial part is issued.
--  060424  MarSlk  Bug 56596, Added Get_Desription method to get the part description from Part_Catalog_API.
--  060418  NaLrlk  Enlarge Identity - Changed view comments of owning_customer_no.
--  060405  Ishelk  Bug 56108, Chaged the parameters and coding in method Unscrap_At_Supplier.
--  ------------------------- 12.4.0 ---------------------------------------------
--  060217  NiDalk  Small modification in Modify_Lot_Batch_No___.
--  060209  SaNalk  Called Modify_Latest_Transaction___ in Remove_Superior_Info.
--  060123  JaJalk  Added Assert safe annotation.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  051216  LEPESE  Changes in method Update___. Added calls to methods
--  051216          Invent_Condition_Code_Util_API.Make_Pre_Serial_Change_Action and
--  051216          Invent_Condition_Code_Util_API.Make_Post_Serial_Change_Action.
--  050916  Nalrlk  Removed unused variables.
--  050915  JaJalk  Fetched the initial value of hyphen_separator_ from Object_Property_API.Get_Value using the
--  050915          'OBJ_LEVEL_SEPARATOR' to overcome the data mismatch between Vim and Partca.
--  050909  JaJalk  Replaced Part_Catalog_Sep_Sign_API.Get_Client_Value(0) calls with hyphen_separator_ as the
--  050909          client values are unreliable to save in the database.
--  050909  SeJalk  Bug 52988, Changed the public method Modify_Lot_Batch_No as an implementation
--  050909          method, Modify_Lot_Batch_No___ and added a checking condition to lot batch no.
--  050906  SaJjlk  Changed SUBSTRB to SUBSTR in method Get_State.
--  050902  ErFelk  Bug 52052, Added function Get_Configuration_Id. Added a parameter
--  050902          to New_In_Inventory method. Modified Rename, New_In_Contained,
--  050902          New_In_Facility, New_In_Issued, Unpack_Check_Insert___, Insert___,
--  050902          Unpack_Check_Update___, Update___ and method Get.
--  050713  Asawlk  Bug 52051, Added two new default NULL parameters, acquisition_cost_ and
--  050713          purchased_date_ to method New_In_Inventory and also change the method body.
--  050404  Asawlk  Bug 49928. Removed the parameters latest_transaction_ and operational_status_db_
--  050404          from method Unscrap_During_Disposition and changed the call to Move_To_Issued inside it.
--  050324  Asawlk  Bug 49928, Added method Unscrap_During_Disposition.
--  050322  HoInlk  Bug 50191, Modified the validation in Unpack_Check_Update___
--  050322          that checks if the part serial has been renamed.
--  050207  SaJjlk  Added back the framework added methods New_In_Contained__, New_In_Facility__,
--                  New_In_Inventory__, New_In_Issued__, New_In_Repair_Workshop__ and New_In_Unlocated__.
--  050121  SaJjlk  Removed unused methods Is_Unlocated, New_In_Contained__, New_In_Facility__,
--                  New_In_Inventory__, New_In_Issued__, New_In_Repair_Workshop__ and New_In_Unlocated__.
--  041110  Samnlk  Added Supplier owned,ownership to the main condition in method Set_Serial_Ownership.
--  041001  GaJalk  Bug 47063, Added the defualt null parameter serial_revision_ to procedure New_In_Facility.
--  040715  KaDilk  Bug 40831, Added function Get_State.
--  040622  NuFilk  Modified Finite_State_Events__ and Finite_State_Machine___ to handle new state changes.
--  040428  KeSmus  EM01 - Reconciled model work which added a relationship to
--                  MaintLevel.
--  040428  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL inside FOR LOOPs.
--  040209  KeSmUs  EM01 - Added new attribute PartialDisassemblyLevel and
--                  SetPartialPart method.
--  040312  ThPalk  Bug 43172, Added method Unscrap_At_Supplier and added event MoveToIssued
--  040312          from state Unlocated to state Issued.
--  040225  LoPrlk  Removed substrb from code. DEFINE statements for OBJEVENTS and STATE, &VIEW, and &VIEW_LOV2 were altered.
--  040224  ThPalk  Bug 42881, Added an if condition in Unpack_Check_Insert___.
--  040217  IsWilk  Rewrote the DBMS_SQL to Native dynamic SQL for Unicode modification.
--  040120  GeKalk  Replaced INSTRB with INSTR for UNICODE modifications.
--  031231  IsAnlk  Merged Enumerate_Events__ to default values.
--  031230  LoPrlk  Column Superior_Alternate_Contract was made public and corrosponding get method was commented.
--  031223  ISANLK  Merged Get_Superior_Alt_Contract.Changed the positions of the methods to tally with the cat.
--  -------------------------------- 12.3.0 ----------------------------------
--  031016  LEPESE  Improved error message in method Exist.
--  031014  LEPESE  Added uppercase check on serial_no in Unpack_Check_Insert___.
--  031013  PrJalk  Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  031010  SuAmlk  Modified error message in method Set_Serial_Ownership.
--  031009  AnLaSe  Call Id 105593 added method Modify_Lot_Batch_No.
--  031009  SuAmlk  Added state transition from InInventory to InFacility with the event MoveToFacility.
--  031008  SuAmlk  Modified error message in method Set_Serial_Ownership to the original text.
--  031003  SuAmlk  Modified error message in method Set_Serial_Ownership.
--  031002  AnLaSe  Call Id 103681. Removed call to Vim_Serial_API.Part_Rev_Updated.
--  030924  AnLaSe  Made it possible to change status from Planned for operation to Out of Operation
--  030924          (request for MRO flow). Added statement in method Check_Op_Status_Transition___.
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  030902  JoAnSe  Bug 30106 Added Get_Previous_Current_Position
--  030807  PrTilk  Modified view PART_SERIAL_NO_LOV. Added columns condition_code, condition_code_desc,
--  030807          part_ownership, owner.
--  030806  MaGulk  Bug 100586, Modified Calc_Structure_Ownership string manipulation
--  030730  KiSalk  SP4 Merge.
--  030725  MaGulk  Modified Set_Serial_Ownership, changed conditions of ownership and contained state for change of ownership
--  030722  MaGulk  Modified Set_Serial_Ownership, added check_existence_ parameter, changed quantity check
--  030717  MaGulk  Modified Set_Serial_Ownership to dynamically call InventoryPartInStock
--  030716  DiMalk  Added new parameter owning_customer_ to the method New_In_Contained()
--  030715  MaGulk  Modified Calc_Structure_Ownership to include single owner check
--  030714  DiMalk  Added new parameter owning_customer_ to the method New_In_Facility()
--  030714  MaGulk  Added Set_Structure_Ownership___ for persistant part ownership
--  030711  SudWlk  Modified method Unpack_Check_Update__ to check for manual peggings when changing condition_code.
--  030711  MaGulk  Added Set_Serial_Ownership for persistant part ownership
--  030710  MaGulk  Added Get_Structure_Ownership & Calc_Structure_Ownership for persistant part ownership
--  030710  DiMalk  Added new parameter ownership_db_ to the method New_In_Facility()
--  030609  Mushlk  Modified method Check_Op_Status_Transition___.
--  030429  DAYJLK  Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___.
--  030325  MaGulk  Modified New_In_Inventory to include owner code functionality.
--  030319  MaGulk  Added columns part_ownership, owning_vendor_no, owning_customer_no and
--                  corresponding methods for owner code functionality.
--  030312  MaGulk  Call ID: 95139, Modified Modify_Condition_Code to check existance prior to update.
--  030310  Samnlk  Bug 36132,Modified the cursor to handle both number and string serials ,in  Func:Get_Max_Part_Serial_No.
--  021105  JoAnSe  Added new allowed state transition from 'Contained' to 'Unlocated' to allow Rename for
--                  contained parts.
--  021021  paskno  Call ID: 89929, Altered Validate_Items___ to only perform checks on update.
--  021022  JoAnSe  Moved the calls to Modify_Latest_Transaction___ in public methods Issue, Move_In_Inventory etc
--                  to avoid problem with changed objversion in calls to Issue__ etc.
--  021021  SiJoNo  Call ID: 90328, Added call to Part_Manu_Part_Rev_API.Check_Manu_Of_Part_Rev in Validate_Items___.
--  021021  JoAnSe  Moved calls to Part_Serial_History_API.New in public methods Issue, Move_In_Inventory etc
--                  so that the history records are created right after the status is changed.
--  021018  JoAnSe  Allowed transition from 'SCRAPPED' to 'NOT_APPLICABLE' in Check_OpStatus_Transition___
--  021017  sijono  Call ID: 89777, Added global lu constant vim_serial_from_remote_inst_ and use this in
--                  method New_In_Inventory.
--  021016  ERHOUS  Call Id: 89678, Modifed the declaration of info_ from VARCHAR2(100) to VARCHAR2(2000) in
--                  numerous methods The lenght of the info_ string can certainly be in excess of 100 characters.
--  021014  sijono  Call ID: 89777, Added dynamic call to Vim_Serial_From_Remote_API.Send_Serial in New_In_Inventory.
--  021007  sijono  Call ID: 88296, Remove History lines for changes in buyer and purchased data.
--  021003  paskno  Call ID: 89116, added parameter operational_cond_db_ to New_In_Facility.
--  021002  SiJoNo  Removed dynamic call to Vim_Serial_API.Check_Part_Rev_Change in Set_Eng_Part_Revision.
--  021001  SiJoNo  Removed method Get_Product_Model.
--  020913  LEPESE  Added call to Inventory_Part_In_Stock_API.Check_Individual_Exist
--                  in metod check_delete___.
--  020906  JoAnSe  Reimplemented Move_Individual as this method is used from the Modify Serial Structure client.
--  020906  GeKaLk  Call ID: 88296, Modified to add History lines for changes in supplier, buyer purchased data and Manu. part no.
--  020905  paskno  Call ID: 88597, made static calls dynamic for components not static to partca.
--  020902  JoAnSe  Allowed transition from 'Not Applicable' to 'Scrapped' in Check_Op_Status_Transition___
--  020830  JoAnSe  Allowed transition from 'Not Applicable' to 'In Operation' in Check_Op_Status_Transition___
--  020830  ANLASE  Replaced call to Inventory_Part_Unit_Cost_API.Handle_Serial_Condition_Change
--                  with Invent_Condition_Code_Util_API.Handle_Serial_Condition_Change.
--  020830  JoAnSe  Corrected db value for operational status 'PLANNED_FOR_OP' in Check_Op_Status_Transition___
--  020829  paskno  Call ID: 88306, Added check in Validaate_Items___.
--  020828  jagrno  Added cleanup of object connection when removing serial (Check_Delete___
--                  and Delete___). Moved object connections when renaming serial.
--  020827  JoAnSe  Added new method Check_Op_Status_Transition___ called when changing operational status.
--  020826  JoAnSe  Combination Scrapped and In Repair Workshop allowed in Check_Dimension_Dependency___.
--  020823  LEPESE  Added dynamic call to Inventory_Part_Unit_Cost_API.Handle_Serial_Removal
--                  in method delete___. This is needed due to limitations in Reference_SYS.
--  020823  JoAnSe  Corrected update of latest_transaction in public methods for moving a serial.
--  020816  sijono  Removed dynamic call to VimSerial in Set_Locked_For_Update, Set_Not_Locked_For_Update,
--                  Set_Operational, Set_Out_Of_Operation, Scrap and Unscrap
--  020816  viasno  Added more test on new_current_position_ in Remove_Superior_Info.
--  020816  PEKR    Removed IU flags on renamed_to_serial_no and renamed_from_serial_no in VIEW to prevent changes
--                  from clients. Instead added 'CREATED_BY_SERVER' in attr_ to be used by server changes.
--  020815  LEPESE  Removed obsolete method Get_Serial_No_By_Cond_Code.
--  020813  JoAnSe  Added new client interface methods Set_Locked_For_Update__
--                  Set_Not_Locked_For_Update__, Set_Non_Operational__, Set_Operational__
--                  and Set_Out_Of_Operation__.
--  020813  PEKR    Added parameter Manu_Part_No to Procedure Rename.
--  020813  paskno  Added dynamic call to VIM in Set_Locked_For_Update and Set_Not_Locked_For_Update.
--  020812  JoAnSe  Added Check_Eng_Part_Revision_Exist.
--  020812  paskno  Altered method Set_Operational, Set_Out_Of_Operation, Scrap and Unscrap to call VIM meethods if installed.
--  020812  JoAnSe  Changed parameter production_date to installaton_date in
--                  New_In_Facility and New_In_Contained.
--  020812  sijono  Removed parameter note_ from Set_Eng_Part_Revision.
--  020809  JoAnSe  Added parameters acquisition_cost, production_date, manufactured_date
--                  and purchased_date to New_In_Facility and New_In_Contained.
--                  Added Set_Supplier_No, Set_Acquisition_Cost and Set_Manufacturer_No
--  020809  LEPESE  Added dynamic call to Inventory_Part_Unit_Cost from Update___ to
--                  take care of revaluation when changing condition code. Also
--                  implementet business rules for when it is allowed to have a condition_code.
--  020829  sijono  Altered Set_Eng_Part_Revision, moved dynamiv call to VimSerial.
--                  Added parameter info_ to Check_Maintenance_Dates___.
--  020808  sijono  Set user_created, user_changed, tdate_created and date_changed to not insertable
--                  and not mandatory.
--                  Moved dynamic call in Set_Installation_Date and Set_Manufactured_Date
--                  to Check_Maintenance_Dates___ (Vim_Serial_API.Check_Manint_Dates_Change).
--                  Altered Set_Installation_Date__ and Set_Manufactured_Date__ to public methods.
--  020808  LEPESE  Added condition_code to method New_In_Inventory.
--  020808  sijono  Altered Validate_Items___, removed dynamic call to Part_Manu_Part_No.
--  020807  sijono  Altered check of manu_part_no in Validate_Items___.
--  020806  sijono  Set parameter manu_part_no_ and owner_id_ in New_In_Facility to default NULL.
--  020805  JoAnSe  Added new method Get_Operational_Condition_Db
--  020805  ChFolk  Added IN parameter, lot_batch_no_ into the procedure, New_In_Inventory and modified it to add lot_batch_mo into the attr_.
--  020802  sijono  Added method Remove_Budgets___ and call to method in Update___.
--  020801  sijono  Altered method Set_Eng_Part_Revision, added dynamic validations.
--                  Added parameter manu_part_no and owner_id to New_In_Facility and renamed
--                  parameter serial_revision to eng_part_revision in same method.
--                  Added method Get_Product_Model.
--  020731  sijono  Added validation of manufactured part number in Validate_Items___.
--  020729  paskno  Added method Validate_Items___. Added history creation in method
--                  Set_Eng_Part_Revision and Update___.
--  020729  Kamtlk  Added Part_serial_no_lov.
--  020712  SiJoNo  Added method Set_Eng_Part_Revision.
--  020711  PEKR    Added Modify_Condition_Code.
--  020711  PEKR    Added Get_Serial_No_By_Cond_Code.
--  020711  PEKR    Added call to Check_Dimension_Dependency___ for childs in Set_Operational_Status___ and Set_Operational_Condition___.
--  020711  SiJoNo  Added method Set_Installation_Date__.
--  020705  SiJoNo  Added public attributes eng_part_revision, manu_part_no, manufactured_date,
--                  acquisition_cost, currency_code, installation_date, lot_batch_no, ownere_id,
--                  purchased_date, buyer, date_created, user_created, date_changed and user_changed.
--                  Added methods Set_Manufactured_Date__ and Check_Maintenance_Dates___.
--  020703  PEKR    Added columns renamed_from_serial_no and renamed_to_serial_no.
--                  Added procedure Rename.
--  020625  PEKR    Added more validation in Check_Dimension_Dependency___.
--  020613  JoAnSe  Removed call to Modify_Serial_Structure from Move_To_Inventory
--  020612  JoAnSe  Added parameters superior_serial_no_ and superior_part_no_
--                  to New_In_Contained.
--                  Added parameters latest_transaction_, alternate_id_ and
--                  alternate_contract_to Move_To_Contained
--                  Added Is_Under_Transportation, Is_Contained and Is_Unlocated
--                  Added parameters transaction_description_ and new_current_position_
--                  to Remove_Superior_Info
--  020611  JoAnSe  Initial event passed correctly in Finite_State_Init___.
--  020611  PEKR    Made condition_code not mandatory.
--  020606  PEKR    Added Check_Dimension_Dependency___ and calls to this procedure.
--  020603  JoAnSe  Changed handling for 'Contained' serials.
--                  A serial connected to another serial may now be 'Contained' even
--                  if the top object is 'InFacility' or 'InRepairWorkshop'.
--                  Move_In_Facility and Move_Individual replaced with additional parameters
--                  in Modify_Serial_Structure.
--                  Removed methods New_In_Design, Connect_Design, Move_To_Design,
--                  Is_In_Design, Is_Infacility, Connect_Facility, Disconnect
--                  Added Get_Top_Parent_State
--  020530  PEKR    Added column condition_code.
--  020529  PEKR    Replaced current_position with latest_transaction.
--  020524  JoAnSe  Added new public attribute date_locked
--  020524  ChFolk  Extended the length of the columns, 'Serial_no' and 'superior_serial_no' to 50 in the view comments and the defined variables.
--  020508  JoAnSe  Added new columns locked_for_update, operational_status and
--                  operational_condition. Also added a lot of new methods operating
--                  on this attributes.
--                  Changes have also been made to the state-diagram and the methods
--                  used to change rowstate for a serial object.
--  ----------------------------- AD - Baseline -------------------------------
--  020205  JABALK  Bug Fix 26409,Modified the cursor to convert the serial no into number in the Func:Get_Max_Part_Serial_No.
--  010103  PERK    Changed NOTE to NOTE_TEXT in Modify_Note_Text
--  001221  ANLASE  Changed prompt from contract to site in view comments.
--  001205  JOHESE  Changed Connect_Facility__ and Contained_Facility__ not to make recursive calls.
--                  Also added event "ConnectFacility" from state "Issued".
--  001120  PaLj    Rebuild: now having dynamic calls to Mpccom LU:s. Removed method Set_Cust_Warranty_Convert___.
--  001117  PaLj    Corrected minor error in dynamik call in unpac_check_insert___
--  001115  PaLj    Changed method Set_Or_Merge_Cust_Warranty.
--  001102  PaLj    Added method Set_Or_Merge_Cust_Warranty
--  001101  PaLj    Added NOCHECK on view comments for cust_warranty_id and sup_warranty_id
--  001031  PaLj    Added methods Set_Cust_Warranty_Man and Set_Cust_Warranty_Convert___
--  001027  PaLj    Changed method Set_Sup_Warranty
--  001023  PaLj    Added Cust_Warranty_id and Sup_Warranty_id, and methods set_cust_warranty, set_sup_warranty
--  000925  JOHESE  Added undefines.
--  000418  NISOSE  Added General_SYS.Init_Method in Connect_Design, Connect_Facility, Get_Instance_Alt_Id,
--                  Get_Serial_Revision, Is_In_Design, Is_In_Inventory, Is_Pending, Modify_Current_Position__,
--                  Move_In_Facility, Move_In_Inventory, Move_To_Design, Move_To_Facility, Move_To_Inventory,
--                  Move_To_Issued, Move_To_Workshop, Pending and Unscrap.
--  000317  ROOD    Removed reference tp Part_Catalog for superior_part_no.
--  000306  JOHW    Done so note_text not will be overwritten by transaction_description in method
--  990709  MATA    Changed substr to substrb in DEFINE OBJEVENTS and STATE
--                  Modify_Current_Position__.
--  990616  SHVE    Corrected spelling mistakes in error messages.
--  990604  FRDI    Removed comma signs.
--  990601  FRDI    Added procedure Move_Indinidual,Is_Part_Selfcontained___, Is_Structure_Allowed___
--                  for the control in unpack_check_update that there are no cycles in the serial structure.
--  990518  SHVE    Fixed bug in Modify_Current_Position__(parameters to Update__).
--  990424  FRDI    Bug fix due to template changade.
--  990422  FRDI    General performance improvements.
--  990416  JOHW    Upgraded to performance optimized template.
--  990330  ANHO    Added function Is_In_Repair_Workshop.
--  990330  LEPE    Added state 'InRepairWorkshop' to view PART_SERIAL_ISSUE.
--  990315  SHVE    Added validations to check for reservations in SerialNoReservation.
--  990211  TOBE    Added public cursor get_component_serial_no_cur. Added new entry NewInIssued and
--                  new event MoveToIssued from InFacility to Issued in state machine, and added
--                  corresponding public functions.
--  990128  FRDI    Restructuring of enterprise, canged view ref to ManufacturerInfo and SupplierInfo
--  990127  TOBE    Created PART_SERIAL_CATALOG_LOV.
--  980804  GOPE    Cleanup more design correct, added funtion unscrap.
--                  A individuals connected to a purchase order must have that possibility
--  980529  LEPE    Added FUNCTION Get_Max_Part_Serial_No.
--  980429  TOWI    Corrected the management of serial with a structure and it's move from facility
--                  to inventory or from inventory to facility.
--  980424  CLCA    Changed Error Message in Insert___.
--  980423  MNYS    Support Id: 3962. Added superior_alternate_contract_ and superior_alternate_id_
--                  as parameters in procedure Move_In_Facility.
--                  Removed check for current_position in procedure Modify.
--  980222  TOWI    Changed parameter rec_ to IN/OUT for method Move_In_Facility___
--  980422  JOHNI   Change length of package globals.
--  980422  TOWI    Added a contract constant to alternate_contract when creating a new serial
--  980420  TOWI    Added current position text to contained and discontained. Added default alternate_contract.
--  980416  ERJA    Added VIEW PART_SERIAL_ISSUE and Function Is_Issued
--  980414  TOWI    Corrected view column
--  980409  TOWI    Corrected fetch of separator sign when creating alternate_id
--  980407  ERJA    Added VIEW PART_SERIAL_ALT_ID
--  980407  TOWI    Changed client values for state in client_state_list
--  980401  TOWI    Added possibility to go to state scrap from issue
--  980330  TOWI    Added Order no, line no, release no and line item no
--                  as a parameter to methods MoveToInventory, Issue, Unissue, Scrap, MoveInInventory Transport
--  980331  ERJA    Removed type declarations in Call to check_exist___
--  980330  TOWI    Added Order Type as a parameter to methods MoveToInventory, Issue, Unissue, Scrap, MoveInInventory Transport
--  980322  TOWI    Whenever a serial is created the alternate id is set
--  980316  ERJA    Added VIEW PART_SERIAL_CATALOG_ISSUE.
--  980312  TOWI    Corrected method Move_In_Inventory
--  980304  TOWI    Removed check on PartSerialHistory when deleting a serial, method REMOVE.
--  980228  ERJA    Added state Move_To_Design.
--  980225  ERJA    Changed Move_In_Facility___ to be able to change contract on move
--  980217  ERJA    Corrected 'flow' in Move_in_facility  and new_in_facility
--  980217  ERJA    Changed parameter order in move_in_facility and move_to_facility
--  980217  ERJA    Added TRANSACTION_DESCRIPTION in attr_ in New_In_Facility
--  980216  TOWI    Added call to New_In_History when event MoveInFacility, MoveInInventory
--  980212  TOWI    Added Build_Attr_History___ to method New_In_History
--  980212  TOWI    Changed parameters in All public New_In...
--  980209  ERJA    Rewrote procedure Modify
--  980206  CAJO    Removed unused dummy_ variable.
--  980205  TOWI    Remove of a serial is possible only when one history transaction
--                  is created for the actual serial.
--  980130  TOWI    Added public methods for all events.
--  980129  TOWI    Added sysdate as default date to TRANSACTION_DESCR i historiken
--  980128  TOWI    Changed method name from connect to connect_facility
--  980128  TOWI    Changed the state diagram
--  980127  TOWI    Some corrections after workbench generation.
--  980125  TOWI    Changed name on some attributes and methods.
--  980112  CAJO    Added function Get_Superior_Alt_Contract.
--  980102  TOWI    Changed column name part_rev to serial_revision. Changed method name from Create_Serial_Part_Construct
--                  to Create_Serial_Part_Design.
--  971215  ERJA    Added arguments in Update_Serial
--  971212  ERJA    added arguments in Create_Serial_Part_Facility
--  971212  ERJA    added superior_alternate_contract and superior_alternate_id in  Create_Serial_Part_Order
--  971212  ERJA    Removed columns purchase_date, purchase_price, order_no, line_no, release_no
--  971121  ERJA    Minor bugcorrection
--  971111  STSU    Added methods Is_In_Inventory, Is_In_Reserved_On_Order,
--                  Get_Order_Info and Update_Note.
--  971110  ERJA    added column alternate_contract.
--  971107  STSU    Changed parameters for Create_Serial_Part_Facility.
--  971027  CAJO    Added procedure Update_Serial.
--  971024  CAJO    Added function Check_Exist (STSU).
--  971023  CAJO    Added procedure Delete_Superior_Info.
--  971022  TOWI    Added method Is_Infacility.
--  971021  ERJA    Added procedures Un_Connect_Serial__ and Connect_Serial__.
--  971017  STSU    Added new attributes.
--  971010  STSU    Added function Get_Alt_Current_Position
--  970924  TOWI    Added public methods Update_Alternate_Id, Get_Instance.
--  970918  STSU    Added new view PART_SERIAL_CATALOG_RESERVED.
--  970910  STSU    Added functions Get_Alt_Serial_No and Get_Alt_Part_No. Added Init_Method to all
--                  public procedures.
--  970826  ERJA    Added FUNCTION Get_Objstate, PROCEDURE Delete_Serial_Part, Create_Serial_Part_Order,
--                  Create_Serial_Part_Construct, Create_Serial_Part_Facility, Create_Serial_Part_Inventory
--                  and global variable serial_event__
--  970826  ERJA    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE component_serial_no_record IS RECORD (
   part_no   VARCHAR2(25),
   serial_no VARCHAR2(50) );

CURSOR get_component_serial_no_cur (
   superior_part_no_   IN VARCHAR2,
   superior_serial_no_ IN VARCHAR2 ) RETURN component_serial_no_record
IS
   SELECT part_no, serial_no
   FROM   part_serial_catalog
   WHERE  superior_part_no   = superior_part_no_
   AND    superior_serial_no = superior_serial_no_;

TYPE Serial_No_Rec IS RECORD (
   serial_no   part_serial_catalog_tab.serial_no%TYPE );

TYPE Serial_No_Tab IS TABLE OF Serial_No_Rec INDEX BY PLS_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Serial_Rec IS RECORD (
      part_no               part_serial_catalog_tab.part_no%TYPE,
      serial_no             part_serial_catalog_tab.serial_no%TYPE,
      operational_status    part_serial_catalog_tab.operational_status%TYPE,
      operational_condition part_serial_catalog_tab.operational_condition%TYPE);

TYPE Serial_Tab IS TABLE OF Serial_Rec
      INDEX BY PLS_INTEGER;

string_null_                 CONSTANT VARCHAR2(15)    := Database_SYS.string_null_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Raise_Record_Not_Exist___ (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_,'NOTEXIST: Serial number :P1 of part number :P2 does not exist in :P3.',serial_no_, part_no_,lu_name_);
   super(part_no_ , serial_no_);
END Raise_Record_Not_Exist___;

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ part_serial_catalog_tab%ROWTYPE )
IS
   top_part_no_         part_serial_catalog_tab.part_no%TYPE;
   top_serial_no_       part_serial_catalog_tab.serial_no%TYPE;
BEGIN
   IF (Is_Contained(rec_.part_no, rec_.serial_no) = 'TRUE') THEN
           Get_Top_Parent( top_part_no_,
                           top_serial_no_,
                           rec_.part_no,
                           rec_.serial_no );
           Error_SYS.Record_General(lu_name_, 'SERIALCONTAINED: Serial [:P1] already exists and is contained in parent [:P2].', rec_.part_no||','||rec_.serial_no, top_part_no_||','||top_serial_no_);
   END IF;
   Error_SYS.Appl_General(lu_name_, 'INUSE: Serial number :P1 is already in use.', rec_.serial_no);
   super(rec_);
END Raise_Record_Exist___;

-- Is_Structure_Allowed___
--   Raises error-message if the individual is a part of itself.
PROCEDURE Is_Structure_Allowed___ (
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   superior_part_no_   IN VARCHAR2,
   superior_serial_no_ IN VARCHAR2 )
IS
   temp_ NUMBER;
   superior_individual_   VARCHAR2(100);
   current_individual_    VARCHAR2(100);
   CURSOR check_struct_part IS
      SELECT 1
      FROM dual
      WHERE (part_no_ , serial_no_) IN
            (SELECT part_no, serial_no
             FROM part_serial_catalog_tab
             CONNECT BY part_no   = prior superior_part_no
             AND        serial_no = prior superior_serial_no
             START WITH part_no   = superior_part_no_
             AND        serial_no = superior_serial_no_);
BEGIN
   Trace_SYS.Message('PART -' || part_no_ || ' - ' || serial_no_ || '   Supperior - ' || superior_part_no_ || ' - ' || superior_serial_no_);
   current_individual_  := part_no_ || ' - ' || serial_no_ ;
   IF (part_no_ = superior_part_no_ ) AND  (superior_serial_no_ = serial_no_ ) THEN
      Error_Sys.Record_General(lu_name_, 'INITSELF: :P1 may not be a part of itself.', current_individual_);
   END IF;
   OPEN check_struct_part;
   FETCH check_struct_part INTO temp_;
   IF (check_struct_part%FOUND) THEN
      CLOSE check_struct_part;
      superior_individual_ :=  superior_part_no_ || ' - ' || superior_serial_no_ ;
      Error_Sys.Record_General(lu_name_, 'INSELFSTRUCT: :P1 consists of :P2. It may not be a part of it self.',
      current_individual_, superior_individual_);
   ELSE
      CLOSE check_struct_part;
   END IF;
END Is_Structure_Allowed___;


-- Is_Part_Selfcontained___
--   Gives a warning if a part is part of its own structure.
PROCEDURE Is_Part_Selfcontained___ (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   superior_part_no_ IN VARCHAR2,
   superior_serial_no_ IN VARCHAR2 )
IS
   temp_ NUMBER;
   CURSOR check_part IS
      SELECT 1
      FROM dual
      WHERE part_no_  IN
         (SELECT part_no
          FROM part_serial_catalog_tab
          CONNECT BY part_no   = prior superior_part_no
          AND        serial_no = prior superior_serial_no
          START WITH part_no   = superior_part_no_
          AND        serial_no = superior_serial_no_);
BEGIN
   Trace_SYS.Message('Part PART -'||part_no_ || ' - ' || serial_no_ || '   Supperior - '||superior_part_no_ || ' - ' || superior_serial_no_);

   IF (part_no_ = superior_part_no_ ) THEN
      Client_SYS.Add_Warning (lu_name_,'ISSELFSPART: Are you sure you want :P1 to be a part of it self?',
                              part_no_);
   ELSE
      OPEN check_part;
      FETCH check_part INTO temp_;
      IF (check_part%FOUND) THEN
         CLOSE check_part;
         Client_SYS.Add_Warning (lu_name_,'INSELFSPART: Are you sure you want :P1 to be a part in its own structure?',
                                           part_no_);
      ELSE
         CLOSE check_part;
      END IF;
   END IF;
END Is_Part_Selfcontained___;


-- Set_Operational_Condition___
--   Set the operational_condition for a serial object
--   If update_structure_ = TRUE the method will also set the
--   operational_condition for all children of the object if the object is part
--   of a structure.
PROCEDURE Set_Operational_Condition___ (
   info_                     OUT VARCHAR2,
   part_no_                  IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   operational_condition_db_ IN  VARCHAR2,
   order_type_               IN  VARCHAR2,
   order_no_                 IN  VARCHAR2,
   line_no_                  IN  VARCHAR2,
   release_no_               IN  VARCHAR2,
   line_item_no_             IN  NUMBER,
   update_structure_         IN  BOOLEAN,
   validate_structure_       IN  BOOLEAN,
   initial_replace_date_     IN  DATE    DEFAULT NULL,
   reversing_earlier_update_ IN  BOOLEAN DEFAULT FALSE )
IS
   CURSOR get_all_children IS
      SELECT part_no, serial_no, LEVEL
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no IS NOT NULL
      START WITH part_no   = part_no_
             AND serial_no = serial_no_
      CONNECT BY PRIOR part_no   = superior_part_no
             AND PRIOR serial_no = superior_serial_no
      ORDER BY LEVEL DESC;

   attr_           VARCHAR2(2000);
   objid_          part_serial_catalog.objid%TYPE;
   objversion_     part_serial_catalog.objversion%TYPE;
   oldrec_         part_serial_catalog_tab%ROWTYPE;
   newrec_         part_serial_catalog_tab%ROWTYPE;
   serial_message_ VARCHAR2(200);
   update_structure_char_   VARCHAR2(10);
   validate_structure_char_ VARCHAR2(10);
   indrec_         Indicator_Rec;
BEGIN
   IF update_structure_ THEN
      -- Update all children of the serial object.
      FOR next_child_ IN get_all_children LOOP
         Set_Operational_Condition___(info_,
                                      part_no_                  => next_child_.part_no,
                                      serial_no_                => next_child_.serial_no,
                                      operational_condition_db_ => operational_condition_db_,
                                      order_type_               => order_type_,
                                      order_no_                 => order_no_,
                                      line_no_                  => line_no_,
                                      release_no_               => release_no_,
                                      line_item_no_             => line_item_no_,
                                      update_structure_         => FALSE,
                                      validate_structure_       => FALSE,
                                      initial_replace_date_     => initial_replace_date_,
                                      reversing_earlier_update_ => reversing_earlier_update_);
         Check_Dimension_Dependency___(next_child_.part_no, next_child_.serial_no);
      END LOOP;
   END IF;
   Client_SYS.Clear_Attr(attr_);
   oldrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_ := oldrec_;
   newrec_.operational_condition := operational_condition_db_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, reversing_earlier_update_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   serial_message_ := Language_SYS.Translate_Constant(lu_name_, 'OP_COND_CHG: Operational Condition changed to :P1', NULL,
                                                      Serial_Operational_Cond_API.Decode(operational_condition_db_));
   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_                 => part_no_,
                               serial_no_               => serial_no_,
                               history_purpose_db_      => 'CHG_OPERATIONAL_COND',
                               transaction_description_ => serial_message_,
                               order_type_              => order_type_,
                               order_no_                => order_no_,
                               line_no_                 => line_no_,
                               release_no_              => release_no_,
                               line_item_no_            => line_item_no_);  
   
   $IF (Component_Vim_SYS.INSTALLED) $THEN
      IF (update_structure_) THEN
         update_structure_char_ := 'TRUE';
      ELSE
         update_structure_char_ := 'FALSE';
      END IF;
      IF (validate_structure_) THEN
         validate_structure_char_ := 'TRUE';
      ELSE
         validate_structure_char_ := 'FALSE';
      END IF;
      Vim_Serial_API.Set_Operational_Condition(info_,
                                               part_no_,
                                               serial_no_,
                                               operational_condition_db_,
                                               validate_structure_char_,
                                               update_structure_char_,
                                               initial_replace_date_);                
   $END

END Set_Operational_Condition___;


-- Get_Operational_Condition___
--   Return the operational condition for the specified serial part.
FUNCTION Get_Operational_Condition___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_serial_catalog_tab.operational_condition%TYPE;

   CURSOR get_attr IS
      SELECT operational_condition
      FROM part_serial_catalog_tab
      WHERE part_no = part_no_
      AND   serial_no = serial_no_;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Operational_Condition___;


-- Set_Operational_Status___
--   Set the operational_status for a serial object.
--   If update_structure_ = TRUE the method will also set the
--   operational_status for all children of the object if the object is part
--   of a structure.
PROCEDURE Set_Operational_Status___ (
   part_no_               IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   operational_status_db_ IN VARCHAR2,
   order_type_            IN VARCHAR2,
   order_no_              IN VARCHAR2,
   line_no_               IN VARCHAR2,
   release_no_            IN VARCHAR2,
   line_item_no_          IN NUMBER,
   update_structure_      IN BOOLEAN )
IS
   CURSOR get_all_children IS
      SELECT part_no, serial_no, operational_status
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no IS NOT NULL
      START WITH part_no   = part_no_
             AND serial_no = serial_no_
      CONNECT BY PRIOR part_no   = superior_part_no
             AND PRIOR serial_no = superior_serial_no;

   newrec_                    part_serial_catalog_tab%ROWTYPE;
   serial_message_            VARCHAR2(200);
   old_operational_status_db_ part_serial_catalog_tab.operational_status%TYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   old_operational_status_db_ := newrec_.operational_status;
   -- Make sure that the transition from the old operational status to the new is allowed
   Check_Op_Status_Transition___(old_operational_status_db_, operational_status_db_);
   newrec_.operational_status := operational_status_db_;
   Modify___(newrec_);

   serial_message_ := Language_SYS.Translate_Constant(lu_name_, 'OP_STAT_CHG: Operational Status changed to :P1', NULL,
                                                      Serial_Operational_Status_API.Decode(operational_status_db_));
   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_                 => part_no_,
                               serial_no_               => serial_no_,
                               history_purpose_db_      => 'CHG_OPERATIONAL_STAT',
                               transaction_description_ => serial_message_,
                               order_type_              => order_type_,
                               order_no_                => order_no_,
                               line_no_                 => line_no_,
                               release_no_              => release_no_,
                               line_item_no_            => line_item_no_);

   IF update_structure_ THEN
      -- Update all children of the serial object.
      FOR next_child_ IN get_all_children LOOP
         IF ((old_operational_status_db_ = Serial_Operational_Status_API.DB_SCRAPPED) OR
            ((old_operational_status_db_ != Serial_Operational_Status_API.DB_SCRAPPED) AND
             (next_child_.operational_status != Serial_Operational_Status_API.DB_SCRAPPED))) THEN
            Set_Operational_Status___(part_no_               => next_child_.part_no,
                                      serial_no_             => next_child_.serial_no,
                                      operational_status_db_ => operational_status_db_,
                                      order_type_            => order_type_,
                                      order_no_              => order_no_,
                                      line_no_               => line_no_,
                                      release_no_            => release_no_,
                                      line_item_no_          => line_item_no_,
                                      update_structure_      => FALSE);
            Check_Dimension_Dependency___(next_child_.part_no, next_child_.serial_no);
         END IF;
      END LOOP;
   END IF;
END Set_Operational_Status___;


-- Get_Operational_Status___
--   Return the operational status for the specified serial part.
FUNCTION Get_Operational_Status___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_serial_catalog_tab.operational_status%TYPE;

   CURSOR get_attr IS
      SELECT operational_status
      FROM part_serial_catalog_tab
      WHERE part_no = part_no_
      AND   serial_no = serial_no_;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Operational_Status___;


-- Set_Locked_For_Update___
--   Set the locked_for_update flag for a serial object
--   If update_structure_ = TRUE the method will also set locked_for_update
--   for all children of the object if the object is part of a structure.
--   If the serial object is locked date_locked will be set to the current date
--   and time. If the serial is unlocked date_locked will be cleared.
PROCEDURE Set_Locked_For_Update___ (
   part_no_              IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   locked_for_update_db_ IN VARCHAR2,
   update_structure_     IN BOOLEAN )
IS
   CURSOR get_all_children IS
      SELECT part_no, serial_no
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no IS NOT NULL
      START WITH part_no   = part_no_
             AND serial_no = serial_no_
      CONNECT BY PRIOR part_no   = superior_part_no
             AND PRIOR serial_no = superior_serial_no;

   newrec_         part_serial_catalog_tab%ROWTYPE;
   serial_message_ VARCHAR2(200);
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.locked_for_update := locked_for_update_db_;
   IF (locked_for_update_db_ = Serial_Part_Locked_API.DB_LOCKED) THEN
      newrec_.date_locked := sysdate;
   ELSE
      newrec_.date_locked := to_date(NULL);
   END IF;
   Modify___(newrec_);

   serial_message_ := Language_SYS.Translate_Constant(lu_name_, 'LOCKED_FOR_UPD_CHG: Locked for Update changed to :P1', NULL,
                                                      Serial_Part_Locked_API.Decode(locked_for_update_db_));
   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_, serial_no_, 'CHG_LOCKED', serial_message_);


   IF update_structure_ THEN
      -- Update all children of the serial object.
      FOR next_child_ IN get_all_children LOOP
         Set_Locked_For_Update___(next_child_.part_no, next_child_.serial_no, locked_for_update_db_, FALSE);
      END LOOP;
   END IF;

END Set_Locked_For_Update___;


-- Get_Locked_For_Update___
--   Return the value of locked_for_update for the specified serial part.
FUNCTION Get_Locked_For_Update___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_serial_catalog_tab.locked_for_update%TYPE;

   CURSOR get_attr IS
      SELECT locked_for_update
      FROM part_serial_catalog_tab
      WHERE part_no = part_no_
      AND   serial_no = serial_no_;

BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Locked_For_Update___;


-- Check_Dimension_Dependency___
--   Validate the current combination of attribute values for the
--   operational dimensions state (current position) operational condition
--   and operational status.
PROCEDURE Check_Dimension_Dependency___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   rec_                  part_serial_catalog_tab%ROWTYPE;
   InvalidCurPos         EXCEPTION;
   InvalidCombStatus     EXCEPTION;
   InvalidCombCondition  EXCEPTION;
BEGIN
   rec_ := Get_Object_By_Keys___(part_no_, serial_no_);
   IF (rec_.rowstate  = 'Unlocated') THEN
      IF (rec_.operational_status = 'PLANNED_FOR_OP') THEN
         IF (rec_.operational_condition != 'NON_OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'SCRAPPED') THEN
         IF (rec_.operational_condition != 'NON_OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'RENAMED') THEN
         IF (rec_.operational_condition != 'NON_OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSIF (rec_.rowstate = 'Contained') THEN
      IF (rec_.operational_status = 'IN_OPERATION') THEN
         IF (rec_.operational_condition != 'OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'OUT_OF_OPERATION') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'PLANNED_FOR_OP') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'NOT_APPLICABLE') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL', 'NOT_APPLICABLE')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'DESIGNED') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'SCRAPPED') THEN
         IF (rec_.operational_condition != 'NON_OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSIF (rec_.rowstate  = 'InFacility') THEN
      IF (rec_.operational_status = 'IN_OPERATION') THEN
         IF (rec_.operational_condition != 'OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'OUT_OF_OPERATION') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'PLANNED_FOR_OP') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'SCRAPPED') THEN
         IF (rec_.operational_condition != 'NON_OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSIF (rec_.rowstate  = 'InRepairWorkshop') THEN
      IF (rec_.operational_status = 'OUT_OF_OPERATION') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'PLANNED_FOR_OP') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'NOT_APPLICABLE') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL', 'NOT_APPLICABLE')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'SCRAPPED') THEN
         IF (rec_.operational_condition != 'NON_OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSIF (rec_.rowstate  = 'Issued') THEN
      IF (rec_.operational_status = 'OUT_OF_OPERATION') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'PLANNED_FOR_OP') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'NOT_APPLICABLE') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL', 'NOT_APPLICABLE')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'DESIGNED') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSIF (rec_.rowstate  = 'InInventory') THEN
      IF (rec_.operational_status = 'OUT_OF_OPERATION') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'PLANNED_FOR_OP') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'NOT_APPLICABLE') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL', 'NOT_APPLICABLE')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'SCRAPPED') THEN
         IF (rec_.operational_condition != 'NON_OPERATIONAL') THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSIF (rec_.rowstate  = 'UnderTransportation') THEN
      IF (rec_.operational_status = 'OUT_OF_OPERATION') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'PLANNED_FOR_OP') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'NOT_APPLICABLE') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL', 'NOT_APPLICABLE')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSIF (rec_.rowstate  = 'ReturnedToSupplier') THEN
      IF (rec_.operational_status = 'OUT_OF_OPERATION') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSIF (rec_.operational_status = 'NOT_APPLICABLE') THEN
         IF (rec_.operational_condition NOT IN ('OPERATIONAL', 'NON_OPERATIONAL', 'NOT_APPLICABLE')) THEN
            RAISE InvalidCombCondition;
         END IF;
      ELSE
         RAISE InvalidCombStatus;
      END IF;
   ELSE
      RAISE InvalidCurPos;
   END IF;
EXCEPTION
   WHEN InvalidCurPos THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDCURPOS: <:P1> is not a valid Current Position', Finite_State_Decode__(rec_.rowstate));
   WHEN InvalidCombStatus THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDCOMBST: Operational Status <:P1> is not allowed when Current Position is <:P2>', Serial_Operational_Status_API.Decode(rec_.operational_status), Finite_State_Decode__(rec_.rowstate));
   WHEN InvalidCombCondition THEN
      Error_Sys.Record_General(lu_name_, 'INVALIDCOMBCOND: Operational condition :P1 is not allowed for serial :P2 since its current position/operational status is :P3.', Serial_Operational_Cond_API.Decode(rec_.operational_condition), part_no_||', '|| serial_no_, Finite_State_Decode__(rec_.rowstate)||'/'|| Serial_Operational_Status_API.Decode(rec_.operational_status) );
END Check_Dimension_Dependency___;


-- Check_Op_Status_Transition___
--   Validations to be executed when changing the operational status.
--   Raises an error for illegal transitions
PROCEDURE Check_Op_Status_Transition___ (
   old_operational_status_ IN VARCHAR2,
   new_operational_status_ IN VARCHAR2 )
IS
   invalid_transition EXCEPTION;
BEGIN
   IF (old_operational_status_ != new_operational_status_) THEN
      IF (old_operational_status_ = 'DESIGNED') THEN
         IF (new_operational_status_ NOT IN ('PLANNED_FOR_OP', 'RENAMED')) THEN
            RAISE invalid_transition;
         END IF;
      ELSIF (old_operational_status_ = 'NOT_APPLICABLE') THEN
         IF (new_operational_status_ NOT IN ('PLANNED_FOR_OP', 'RENAMED', 'IN_OPERATION', 'SCRAPPED', 'DESIGNED', 'OUT_OF_OPERATION')) THEN
            RAISE invalid_transition;
         END IF;
      ELSIF (old_operational_status_ = 'PLANNED_FOR_OP') THEN
         IF (new_operational_status_ NOT IN ('IN_OPERATION', 'RENAMED', 'OUT_OF_OPERATION', 'SCRAPPED')) THEN
            RAISE invalid_transition;
         END IF;
      ELSIF (old_operational_status_ = 'IN_OPERATION') THEN
         IF (new_operational_status_ != 'OUT_OF_OPERATION') THEN
            RAISE invalid_transition;
         END IF;
      ELSIF (old_operational_status_ = 'OUT_OF_OPERATION') THEN
         IF (new_operational_status_ NOT IN ('IN_OPERATION', 'RENAMED', 'SCRAPPED')) THEN
            RAISE invalid_transition;
         END IF;
      ELSIF (old_operational_status_ = 'SCRAPPED') THEN
         IF (new_operational_status_ NOT IN ('OUT_OF_OPERATION', 'NOT_APPLICABLE', 'PLANNED_FOR_OP')) THEN
            RAISE invalid_transition;
         END IF;
      ELSIF (old_operational_status_ = 'RENAMED') THEN
         RAISE invalid_transition;
      END IF;
   END IF;
EXCEPTION
   WHEN invalid_transition THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_TRANSITION: Changing Operational Status for a serial part from <:P1> to <:P2> is not allowed',
                               Serial_Operational_Status_API.Decode(old_operational_status_),
                               Serial_Operational_Status_API.Decode(new_operational_status_));
   WHEN OTHERS THEN
      RAISE;
END Check_Op_Status_Transition___;


-- Check_Op_Cond_Transition___
--   Validations to be executed when changing the operational condition.
--   Raises an error for illegal transitions
PROCEDURE Check_Op_Cond_Transition___ (
   part_no_                      IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   operational_status_db_        IN VARCHAR2,
   old_operational_condition_db_ IN VARCHAR2,
   new_operational_condition_db_ IN VARCHAR2 )
IS 
BEGIN
   IF operational_status_db_ != 'RENAMED' AND new_operational_condition_db_ = 'NOT_APPLICABLE' AND old_operational_condition_db_ != 'NOT_APPLICABLE' THEN
      Error_SYS.Record_General(lu_name_, 'OPERCONDCHNGNOTALLOW: Serial :P1, :P2 is in operational condition :P3. Cannot change the operational condition to Not Applicable from any other operational condition.', part_no_, serial_no_, Serial_Operational_Cond_API.Decode(old_operational_condition_db_) );
   END IF;
END Check_Op_Cond_Transition___;


PROCEDURE Check_Maintenance_Dates___ (
   oldrec_ IN part_serial_catalog_tab%ROWTYPE,
   newrec_ IN part_serial_catalog_tab%ROWTYPE )
IS
   current_date_   DATE;
BEGIN
   -- remove the time part of sysdate
   current_date_ := TRUNC(sysdate);

   -- give info-message if time_item_installed is outside limits
   IF ((newrec_.date_created IS NULL) OR (nvl(trunc(newrec_.installation_date), current_date_) != nvl(trunc(oldrec_.installation_date), current_date_))) THEN
      IF (nvl(trunc(newrec_.installation_date), current_date_) < nvl(trunc(newrec_.date_created), current_date_)) THEN
         Client_SYS.Add_Info(lu_name_, 'EARLYINSTALLED: Installation date of serial (:P1) is earlier than creation date.', newrec_.part_no||','||newrec_.serial_no);
      END IF;
      IF (nvl(trunc(newrec_.installation_date), current_date_) > current_date_) THEN
         Client_SYS.Add_Info(lu_name_, 'LATEINSTALLED: Installation date of serial (:P1) is later than todays date.', newrec_.part_no||','||newrec_.serial_no);
      END IF;
   END IF;
   -- display info if manufactured date is in the future
   IF (nvl(trunc(newrec_.manufactured_date), current_date_ - 1) > current_date_) THEN
      Client_SYS.Add_Info(lu_name_, 'LATEMANUFACTURE: Manufactured date of serial (:P1) is later than todays date.', newrec_.part_no||','||newrec_.serial_no);
   END IF;
   -- ensure that installation date is always later than manufacture date
   IF ((newrec_.manufactured_date IS NOT NULL) AND (newrec_.installation_date IS NOT NULL)) THEN
      IF (trunc(newrec_.manufactured_date) > trunc(newrec_.installation_date)) THEN
         Error_SYS.Record_General(lu_name_, 'MANUFBEFOREINST: Serial (:P1) has an installation date earlier than manufactured date. This is not allowed.', newrec_.part_no||','||newrec_.serial_no);
      END IF;
   END IF;
END Check_Maintenance_Dates___;


-- Validate_Items___
--   General attribute validation.
PROCEDURE Validate_Items___ (
   newrec_ IN OUT part_serial_catalog_tab%ROWTYPE )
IS
   oldrec_     part_serial_catalog_tab%ROWTYPE;
   partca_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   oldrec_ := Get_Object_By_Keys___(newrec_.part_no, newrec_.serial_no);
   -- validate maintenance dates
   Check_Maintenance_Dates___(oldrec_, newrec_);
   -- Validate update to NULL for owner id, manufacturer no and manu part no.
   IF (newrec_.rowversion IS NOT NULL) THEN
      $IF (Component_Vim_SYS.INSTALLED) $THEN
         IF(Vim_Serial_API.Exists(newrec_.part_no, newrec_.serial_no))THEN
            IF (oldrec_.manufacturer_no IS NOT NULL AND newrec_.manufacturer_no IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NULLUPDNOTALLOW1: It is not allowed to update Manufacturer to empty string.');
            END IF;
            IF (oldrec_.manu_part_no IS NOT NULL AND newrec_.manu_part_no IS NULL) THEN
               Error_SYS.Record_General(lu_name_, 'NULLUPDNOTALLOW2: It is not allowed to update Manu. Part No to empty string.');
            END IF;
         END IF;
      $END
      IF (oldrec_.owner_id IS NOT NULL AND newrec_.owner_id IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NULLUPDNOTALLOW3: It is not allowed to update Owner Id to empty string.');
      END IF;
   END IF;
   -- validate manufactured part number
   IF (newrec_.manu_part_no IS NOT NULL) THEN
      IF ((newrec_.date_created IS NULL) OR ((newrec_.manufacturer_no != oldrec_.manufacturer_no) OR (newrec_.manu_part_no != oldrec_.manu_part_no))) THEN
         Part_Manu_Part_No_API.Exist(newrec_.part_no, newrec_.manufacturer_no, newrec_.manu_part_no);
         -- validate connection between part revision and any manufacturer number
         $IF (Component_Pdmcon_SYS.INSTALLED) $THEN
            BEGIN
               Part_Manu_Part_Rev_API.Check_Manu_Of_Part_Rev(newrec_.part_no, newrec_.eng_part_revision, newrec_.manufacturer_no, newrec_.manu_part_no);
            EXCEPTION
               WHEN OTHERS THEN
                  RAISE;
            END;
         $END
      END IF;
   END IF;
   
   IF(newrec_.tracked_in_inventory = Fnd_Boolean_API.DB_TRUE) THEN
      partca_rec_ := Part_Catalog_API.Get(newrec_.part_no);
      IF partca_rec_.receipt_issue_serial_track != Fnd_Boolean_API.DB_TRUE THEN
         Error_SYS.Record_General(lu_name_,'NOINVTRACKNONTRACK: It is not allowed to enable Tracked In Inventory option for non serial tracked parts.');
      ELSIF (partca_rec_.serial_tracking_code != Part_Serial_Tracking_API.DB_NOT_SERIAL_TRACKING) THEN
         Error_SYS.Record_General(lu_name_,'NOINVTRACKINVTRACK: It is not allowed to enable Tracked In Inventory option for inventory serial tracked parts.');
      END IF;
   END IF;
END Validate_Items___;


-- Remove_Budgets___
--   Removes obsolete budgets when changing owner code on serial.
PROCEDURE Remove_Budgets___ (
   newrec_ IN part_serial_catalog_tab%ROWTYPE,
   oldrec_ IN part_serial_catalog_tab%ROWTYPE )
IS
BEGIN
   $IF (Component_Vimfca_SYS.INSTALLED) $THEN
      BEGIN
         Oper_Budget_Util_API.Remove_Budget_Serial(newrec_.part_no, newrec_.serial_no, oldrec_.owner_id, newrec_.owner_id); 
      EXCEPTION
         WHEN OTHERS THEN
            RAISE;
      END;
   $ELSE
      NULL;
   $END
END Remove_Budgets___;


-- Modify_Lot_Batch_No___
--   This method modifies  the lot batch no when the transactions are Unissued,
--   Unscrap or Move to Inventory.
PROCEDURE Modify_Lot_Batch_No___ (
   part_no_      IN VARCHAR2,
   serial_no_    IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 )
IS
   old_lot_batch_no_        VARCHAR2(20);
   newrec_                  part_serial_catalog_tab%ROWTYPE;
   transaction_description_ part_serial_history_tab.transaction_description%TYPE;
BEGIN
   old_lot_batch_no_ := Part_Serial_Catalog_API.Get_Lot_Batch_No(part_no_, serial_no_);
   IF((lot_batch_no_ IS NOT NULL) AND (NVL(old_lot_batch_no_, 'NULL') != lot_batch_no_)) THEN
      newrec_ := Lock_By_Keys___(part_no_, serial_no_);
      newrec_.lot_batch_no := lot_batch_no_;
      Modify___(newrec_);

      transaction_description_ :=
         Language_SYS.Translate_Constant(lu_name_, 'MODLOTBATCHNO: Lot Batch Number modified from :P1 to :P2', NULL, old_lot_batch_no_, lot_batch_no_);

      Part_Serial_History_API.New(part_no_, serial_no_, 'INFO', transaction_description_);
   END IF;
END Modify_Lot_Batch_No___;


-- Set_Structure_Ownership___
--   This method sets the persistent ownership of a specific serial part
--   and its components in the part serial catalog, as well as appropriate
--   serial structure, to a specific value. This method will be called during
--   specific inventory transactions, such as prior to purchase receipt into
--   inventory or during transfer of ownership to another customer or company owned.
--   It can also be called after a part is delivered on a customer order or prior
--   to receipt on a RMA. This method is intended to only change the ownership of
--   a serial part during a time when it is not currently exist in an inventory location.
PROCEDURE Set_Structure_Ownership___ (
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   new_part_ownership_db_     IN VARCHAR2,
   new_owning_vendor_no_      IN VARCHAR2,
   new_owning_customer_no_    IN VARCHAR2,
   create_serial_history_     IN BOOLEAN )
IS
   child_part_no_             part_serial_catalog_tab.part_no%TYPE;
   child_serial_no_           part_serial_catalog_tab.serial_no%TYPE;
   child_lot_batch_no_        part_serial_catalog_tab.lot_batch_no%TYPE;

   CURSOR get_children IS
      SELECT part_no,
             serial_no,
             lot_batch_no
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no   IS NOT NULL
      CONNECT BY PRIOR part_no   = superior_part_no
             AND PRIOR serial_no = superior_serial_no
      START WITH part_no   = part_no_
            AND  serial_no = serial_no_;

BEGIN

   --read serial structure tree depth-first-traverse
   OPEN get_children;
   FETCH get_children INTO child_part_no_,
                           child_serial_no_,
                           child_lot_batch_no_;

   WHILE (get_children%FOUND) LOOP

      --set ownership of each child node
      Set_Serial_Ownership(child_part_no_,
                           child_serial_no_,
                           new_part_ownership_db_,
                           new_owning_vendor_no_,
                           new_owning_customer_no_,
                           'FALSE',
                           'TRUE',
                           create_serial_history_);

      FETCH get_children INTO child_part_no_,
                              child_serial_no_,
                              child_lot_batch_no_;

   END LOOP;

   CLOSE get_children;


END Set_Structure_Ownership___;


-- Move_To_Unlocated___
--   Sets the serial state to 'Unlocated'.
PROCEDURE Move_To_Unlocated___ (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Move_To_Unlocated__ (info_, objid_, objversion_, attr_, 'DO');

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_,
                             serial_no_,
                             transaction_description_,
                             transaction_description_,
                             'CHG_CURRENT_POSITION',
                             order_type_,
                             order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             inv_transaction_id_);

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_To_Unlocated___;


-- Get_All_Children___
--   Fetches the child components of a top part
FUNCTION Get_All_Children___ (
      part_no_   IN VARCHAR2,
      serial_no_ IN VARCHAR2 ) RETURN Serial_Tab
IS
   all_children_tab_ Serial_Tab;

   CURSOR get_all_children IS
      SELECT part_no, serial_no, operational_status, operational_condition
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no IS NOT NULL
      START WITH part_no   = part_no_
            AND serial_no = serial_no_
      CONNECT BY PRIOR part_no   = superior_part_no
            AND PRIOR serial_no = superior_serial_no;
BEGIN
   OPEN  get_all_children;
   FETCH get_all_children BULK COLLECT INTO all_children_tab_;
   CLOSE get_all_children;
   RETURN all_children_tab_;
END Get_All_Children___;


-- Set_Scrapped___
--   Set the operational status for the specified serial object to 'Scrapped'.
--   If the parameter UpdateStrucure is TRUE all the children of the serial will also be updated.
--   If the parameter CheckDimensionDependency is 'TRUE' it make a check for Dimension Dependency."
PROCEDURE Set_Scrapped___ (
   part_no_                    IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   order_type_                 IN VARCHAR2,
   order_no_                   IN VARCHAR2,
   line_no_                    IN VARCHAR2,
   release_no_                 IN VARCHAR2,
   line_item_no_               IN NUMBER,
   update_structure_           IN BOOLEAN,
   check_dimension_dependency_ IN BOOLEAN )
IS
BEGIN
   Set_Operational_Status___(part_no_               => part_no_,
                             serial_no_             => serial_no_,
                             operational_status_db_ => 'SCRAPPED',
                             order_type_            => order_type_,
                             order_no_              => order_no_,
                             line_no_               => line_no_,
                             release_no_            => release_no_,
                             line_item_no_          => line_item_no_,
                             update_structure_      => update_structure_);
   IF (check_dimension_dependency_) THEN
      Check_Dimension_Dependency___(part_no_, serial_no_);
   END IF;
END Set_Scrapped___;


-- Validate_Rename___
--   Validates attributes used to store Serial Rename information.
PROCEDURE Validate_Rename___ (
   newrec_ IN part_serial_catalog_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.renamed_from_part_no IS NULL) AND (newrec_.renamed_from_serial_no IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'RENFROMPARTNO: <Renamed From Part No> should be specified when <Renamed From Serial No> contains a value.');
   END IF;
   IF (newrec_.renamed_from_part_no IS NOT NULL) AND (newrec_.renamed_from_serial_no IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'RENFROMSERIAL: <Renamed From Serial No> should be specified when <Renamed From Part No> contains a value.');
   END IF;
   IF (newrec_.part_no = newrec_.renamed_from_part_no) AND (newrec_.serial_no = newrec_.renamed_from_serial_no) THEN
      Error_SYS.Record_General(lu_name_, 'RENFROMSAME: <Part No> and <Serial No> contain the same values as <Renamed From Part No> and <Renamed From Serial No> respectively, rename not allowed.');
   END IF;
END Validate_Rename___;

PROCEDURE Raise_Invalid_State___ (
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2 )
IS
BEGIN
	Error_SYS.Record_General(lu_name_, 'INVALIDSTATE: Rename is not allowed when the Current Position of Serial <:P1> is :P2.', part_no_||','||serial_no_, Part_Serial_Catalog_API.Get_State(part_no_,serial_no_));
END Raise_Invalid_State___;

-- Check_Rename___
--   This method would be invoked the Public CheckRename method.
PROCEDURE Check_Rename___ (
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   new_part_no_         IN VARCHAR2,
   new_serial_no_       IN VARCHAR2 )
IS
   serial_rec_             Public_Rec;
   new_serial_rec_         Public_Rec;
   serial_state_db_        part_serial_catalog_tab.rowstate%TYPE;
   new_serial_state_db_    part_serial_catalog_tab.rowstate%TYPE;
BEGIN
   Check_Rename_Part_No(part_no_, new_part_no_);

   -- Part Serial Catalog Validations.
   serial_rec_ := Get(part_no_,serial_no_);

   IF serial_rec_.operational_status NOT IN ('NOT_APPLICABLE','PLANNED_FOR_OP','IN_OPERATION','OUT_OF_OPERATION') THEN
      Error_SYS.Record_General(lu_name_, 'OPSTATUS: Serial <:P1> has Operational Status <:P2>, rename not allowed.', part_no_||','||serial_no_, Serial_Operational_Status_API.Decode(serial_rec_.operational_status));
   END IF;
   IF (serial_rec_.locked_for_update = 'LOCKED')THEN
      Error_SYS.Record_General(lu_name_, 'NOTLOCKED: Serial <:P1> is Locked for update, rename not allowed.', part_no_||','||serial_no_);
   END IF;
   IF serial_rec_.part_ownership NOT IN ('COMPANY OWNED','CUSTOMER OWNED','SUPPLIER LOANED') THEN
      Error_SYS.Record_General(lu_name_, 'PARTOWNERSHIP: Rename is not allowed when Serial <:P1> has ownership :P2.', part_no_||','||serial_no_, Part_Ownership_API.Decode(serial_rec_.part_ownership));
   END IF;

   --check the rowstate of the from part

   IF Part_Serial_Catalog_API.Check_Exist___(new_part_no_,new_serial_no_) THEN

      IF (new_serial_rec_.operational_status !='RENAMED') THEN
         Error_SYS.Record_General(lu_name_,'NOTRENAMED: Rename is not allowed when the Operational Status of Serial <:P1> is :P2.', new_part_no_||','||new_serial_no_, Serial_Operational_Status_API.Decode(new_serial_rec_.operational_status));
      END IF;

      IF NOT Part_Serial_History_API.Renaming_Serial_To_Prior_Name(part_no_,
                                                                   serial_no_,
                                                                   new_part_no_,
                                                                   new_serial_no_) THEN
         Error_SYS.Record_General(lu_name_,'NOTINHISTORY: Serial <:P1> already exists in Part Serial catalog. Renaming is only allowed to an entirely new Serial or to a Serial that was earlier directly or indirectly renamed to Serial <:P2>.', new_part_no_||','||new_serial_no_, part_no_||','||serial_no_);
      END IF;

      new_serial_state_db_    := Get_Objstate(new_part_no_, new_serial_no_);

      IF (new_serial_state_db_ !='Unlocated') THEN
         Raise_Invalid_State___(new_part_no_, new_serial_no_);
      END IF;

      new_serial_rec_ := Get(new_part_no_, new_serial_no_);

      IF (serial_rec_.part_ownership != new_serial_rec_.part_ownership) THEN
         Error_SYS.Record_General(lu_name_,'OWNERSHIPTO: Ownership of Serial <:P1> does not match with the ownership of Serial <:P2>', part_no_||','||serial_no_, new_part_no_||','||new_serial_no_);
      ELSIF (serial_rec_.part_ownership ='CUSTOMER OWNED') THEN
         IF ((serial_rec_.owning_customer_no != new_serial_rec_.owning_customer_no) OR (serial_rec_.owning_customer_no IS NULL) OR (new_serial_rec_.owning_customer_no IS NULL)) THEN
            Error_SYS.Record_General(lu_name_,'CUSTOMEROWNED: Serials <:P1> and <:P2> should be owned by the same customer when their ownership is :P3.', part_no_||','||serial_no_, new_part_no_||','||new_serial_no_, Part_Ownership_API.Decode('CUSTOMER OWNED'));
         END IF;
      ELSIF (serial_rec_.part_ownership = 'SUPPLIER LOANED') THEN
         IF ((serial_rec_.owning_vendor_no != new_serial_rec_.owning_vendor_no )  OR (serial_rec_.owning_vendor_no IS NULL) OR (new_serial_rec_.owning_vendor_no IS NULL)) THEN
            Error_SYS.Record_General(lu_name_,'SUPPLIERLOANED: Serials <:P1> and <:P2> should be owned by the same vendor when their ownership is :P3.', part_no_||','||serial_no_, new_part_no_||','||new_serial_no_, Part_Ownership_API.Decode('SUPPLIER LOANED'));
         END IF;
      END IF;
   END IF;

   serial_state_db_        := Get_Objstate(part_no_, serial_no_);

   IF (serial_state_db_ NOT IN ('InFacility','InInventory','Issued','Contained')) THEN
      Raise_Invalid_State___(part_no_, serial_no_);
   END IF;

   -- The Inventory validations are avoided here to prevent it from being repeated again in Invent_Part_Serial_Manager_API.Rename
   IF serial_state_db_ != 'InInventory' THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Invent_Part_Serial_Manager_API.Check_Rename(part_no_, serial_no_, new_part_no_, new_serial_no_);
      $ELSE
         NULL;
      $END
      END IF;
END Check_Rename___;


-- Check_In_Inventory_Allowed___
--   If a serial is issued to an External Service Order, then this serial can only be received to the inventory
--   via that specific ESO line or by creating a RMA for the CO attached to that ESO. All other inventory receipts
--   are not allowed until the serial is received to the inventory by one of the above two methods.
PROCEDURE Check_In_Inventory_Allowed___ (
   part_no_        IN  VARCHAR2,
   serial_no_      IN  VARCHAR2,
   order_no_       IN  VARCHAR2,
   line_no_        IN  VARCHAR2,
   release_no_     IN  VARCHAR2,
   line_item_no_   IN  NUMBER,
   order_type_     IN  VARCHAR2,
   transaction_id_ IN  NUMBER )
IS
   order_type_db_    part_serial_history_tab.order_type%TYPE;
   rma_cust_ord_no_  part_serial_history_tab.order_no%TYPE;
   cust_ord_no_      part_serial_history_tab.order_no%TYPE;
   char_null_        VARCHAR2(12) := 'VARCHAR2NULL';
   stmt_             VARCHAR2(2000);
   exit_procedure    EXCEPTION;
   connected_order_line_ VARCHAR2(50);
   lu_rec_           part_serial_catalog_tab%ROWTYPE;
   hist_rec_         Part_Serial_History_API.Public_Rec;


BEGIN

   lu_rec_ := Get_Object_By_Keys___(part_no_, serial_no_);
   IF (lu_rec_.rowstate NOT IN ('Issued', 'InFacility')) THEN
      RAISE exit_procedure;
   END IF;

   hist_rec_ := Part_Serial_History_API.Get_Latest_Issue_Transaction(part_no_,
                                                                     serial_no_);

   order_type_db_ := Order_Type_API.Encode(order_type_);
   IF (order_type_db_ = 'PUR ORDER') THEN

      IF (Part_Catalog_API.Get_Stop_Arr_Issued_Serial_Db(part_no_) = 'TRUE') THEN        

         IF (lu_rec_.ignore_stop_arrival_issued = 'FALSE') THEN
            -- different companies to proceed with the internal PO receipt making the serial InInventory. 
            IF ((Eso_Or_Mro_Purch_Order_Line___(order_no_,line_no_,release_no_)) OR
                (Cancel_Purch_Comp_Issue___(transaction_id_)) OR
                (Issue_Supplier_Owned_Stock___(hist_rec_.inv_transsaction_id)) OR
                (Is_Supplier_Internal___(order_no_))) THEN
                   -- Under these circumstances it should be OK to make the purchase receipt anyway
                   NULL;
            ELSE
                  Error_SYS.Record_General (lu_name_, 'SERNOTALLOWED: Purchase order arrival is not allowed for Serial No :P1. Current position is :P2. To be able to recieve this Serial No, select the Ignore PO Arrivals of Issued checkbox in Part Serial Catalog.', 
                                                      part_no_||' - '||serial_no_,
                                                      Finite_State_Decode__(lu_rec_.rowstate));
            END IF;
         END IF;
      END IF;
   END IF;
   
   IF (lu_rec_.rowstate != 'Issued') THEN
      RAISE exit_procedure;
   END IF;   

   IF (NVL(hist_rec_.order_type, char_null_) NOT IN ('PUR ORDER', 'SHOP ORDER')) THEN
      RAISE exit_procedure;
   END IF;

   IF ((NVL(hist_rec_.order_type, char_null_) = order_type_db_) AND
       (hist_rec_.order_no   = order_no_  ) AND
       (hist_rec_.line_no    = line_no_   ) AND
       (hist_rec_.release_no = release_no_)) THEN
         RAISE exit_procedure;
   END IF;

   connected_order_line_ := hist_rec_.order_no || '-' || hist_rec_.line_no || '-' || hist_rec_.release_no;

   IF (NVL(hist_rec_.order_type, char_null_) = 'SHOP ORDER') THEN

      IF Shpord_Completely_Received___(hist_rec_.order_no,
                                       hist_rec_.line_no,
                                       hist_rec_.release_no) THEN
         RAISE exit_procedure;
      END IF;

      Error_SYS.Record_General (lu_name_, 'SERNOTALLOWTORECVSO: Serial :P1 is issued to Shop Order :P2 which is still not completely received.', part_no_||' - '||serial_no_, connected_order_line_);
   END IF;

   IF NOT Issued_To_Ext_Service_Order___(hist_rec_.order_no,
                                         hist_rec_.line_no,
                                         hist_rec_.release_no,
                                         part_no_,
                                         serial_no_) THEN
      RAISE exit_procedure;
   END IF;

   IF(order_type_db_ = 'RMA') THEN
      stmt_ :='
         BEGIN
             :rma_cust_ord_no_ := Return_Material_Line_API.Get_Order_No(:order_no_, :line_item_no_);
         END;';

      @ApproveDynamicStatement(2007-11-21,HoInlk)
      EXECUTE IMMEDIATE stmt_ USING
        OUT rma_cust_ord_no_,
        IN  order_no_,
        IN  line_item_no_;

      IF (rma_cust_ord_no_ IS NOT NULL) THEN
         stmt_ :='
            BEGIN
                :cust_ord_no_ := Pur_Order_Cust_Order_Comp_API.Get_Cust_Order_No(:hist_order_no_,
                                                                                 :hist_line_no_,
                                                                                 :hist_release_no_);
            END;';

         @ApproveDynamicStatement(2007-11-21,HoInlk)
         EXECUTE IMMEDIATE stmt_ USING
              OUT cust_ord_no_,
              IN  hist_rec_.order_no,
              IN  hist_rec_.line_no,
              IN  hist_rec_.release_no;

         IF (cust_ord_no_ = rma_cust_ord_no_) THEN
            RAISE exit_procedure;
         END IF;
      END IF;
   END IF;

   Error_SYS.Record_General (lu_name_, 'SERNOTALLOWEDTORECV: Serial no :P1 is issued to External Service Order no :P2 still in status Released or Confirmed, and it is not allowed to receive this Serial no on another object.', serial_no_, connected_order_line_);

EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Check_In_Inventory_Allowed___;


FUNCTION Eso_Or_Mro_Purch_Order_Line___ (
   order_no_   IN VARCHAR2,
   line_no_    IN VARCHAR2,
   release_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   stmt_       VARCHAR2(2000);
   eso_or_mro_ VARCHAR2(5);
   result_     BOOLEAN := FALSE;
BEGIN

   stmt_ := 'DECLARE
                eso_or_mro_    VARCHAR2(5) := ''FALSE'';
             BEGIN
                IF (Purchase_Order_Line_Part_API.Eso_Or_Mro_Connected(:order_no_,
                                                                      :line_no_,
                                                                      :release_no_)) THEN
                   eso_or_mro_ := ''TRUE'';
                END IF;
                :eso_or_mro_ := eso_or_mro_;
             END;';

   @ApproveDynamicStatement(2008-03-31,NuVelk)
   EXECUTE IMMEDIATE stmt_ USING
      IN  order_no_,
      IN  line_no_,
      IN  release_no_,
      OUT eso_or_mro_;

   IF (eso_or_mro_ = 'TRUE') THEN
      result_ := TRUE;
   END IF;
   RETURN result_;
END Eso_Or_Mro_Purch_Order_Line___;


FUNCTION Cancel_Purch_Comp_Issue___ (
   transaction_id_ IN NUMBER ) RETURN BOOLEAN
IS
   stmt_                    VARCHAR2(2000);
   cancel_purch_comp_issue_ BOOLEAN := FALSE;
   result_                  VARCHAR2(5):= 'FALSE';
BEGIN

   stmt_ := '
            DECLARE
               cancel_purch_comp_issue_    BOOLEAN;
            BEGIN
               cancel_purch_comp_issue_ := Inventory_Transaction_Hist_API.Cancel_Purch_Component_Issue( :transaction_id);

               IF (cancel_purch_comp_issue_) THEN
                  :result := ''TRUE'';
               END IF;
            END;';

   @ApproveDynamicStatement(2008-04-16,NuVelk)
   EXECUTE IMMEDIATE stmt_ USING
      IN   transaction_id_,
      OUT  result_;

   IF (result_ = 'TRUE') THEN
      cancel_purch_comp_issue_ := TRUE;
   END IF;

   RETURN cancel_purch_comp_issue_;
END Cancel_Purch_Comp_Issue___;


FUNCTION Issue_Supplier_Owned_Stock___ (
   transaction_id_ IN NUMBER ) RETURN BOOLEAN
IS
   stmt_                       VARCHAR2(2000);
   issue_supplier_owned_stock_ BOOLEAN := FALSE;
   result_                     VARCHAR2(5):= 'FALSE';
BEGIN

   stmt_ := '
            DECLARE
               issue_supplier_owned_stock_    BOOLEAN;
            BEGIN
               issue_supplier_owned_stock_ := Inventory_Transaction_Hist_API.Issue_Supplier_Owned_Stock( :transaction_id);

               IF (issue_supplier_owned_stock_) THEN
                  :result := ''TRUE'';
               END IF;
            END;';

   @ApproveDynamicStatement(2008-07-15,NiBalk)
   EXECUTE IMMEDIATE stmt_ USING
      IN   transaction_id_,
      OUT  result_;

   IF (result_ = 'TRUE') THEN
      issue_supplier_owned_stock_ := TRUE;
   END IF;

   RETURN issue_supplier_owned_stock_;
END Issue_Supplier_Owned_Stock___;


FUNCTION Vim_Serial_Exist___
   (part_no_          IN VARCHAR2,
    serial_no_        IN VARCHAR2) RETURN BOOLEAN
IS
   vim_serial_exists_         VARCHAR2(5);
   result_                    BOOLEAN:=FALSE;
BEGIN
   $IF (Component_Vim_SYS.INSTALLED) $THEN
      vim_serial_exists_ := Vim_Serial_API.Serial_No_Exist (part_no_, serial_no_ );              
      IF vim_serial_exists_ = 'TRUE' THEN
         result_ := TRUE;
      END IF;
   $END
   RETURN result_;
END Vim_Serial_Exist___;


FUNCTION Equipment_Serial_Exist___
   (part_no_          IN VARCHAR2,
    serial_no_        IN VARCHAR2) RETURN BOOLEAN
IS
   equipment_serial_exists_   VARCHAR2(5);
   result_                    BOOLEAN:=FALSE;
BEGIN
   $IF (Component_Equip_SYS.INSTALLED) $THEN
      equipment_serial_exists_ := Equipment_Serial_API.Check_Serial_Exist (part_no_, serial_no_ );               
      IF equipment_serial_exists_ = 'TRUE' THEN
         result_ := TRUE;
      END IF;
   $END
   RETURN result_;
END Equipment_Serial_Exist___;

FUNCTION Tool_Equipment_Serial_Exist___
   (part_no_          IN VARCHAR2,
    serial_no_        IN VARCHAR2) RETURN BOOLEAN
IS
   tool_equip_serial_exists_   BOOLEAN:=FALSE;
BEGIN
   $IF (Component_Tooleq_SYS.INSTALLED) $THEN
      tool_equip_serial_exists_ := Resource_Tool_Equip_API.Check_Exist_Part_And_Serial(part_no_, serial_no_ );               
   $END
   RETURN tool_equip_serial_exists_;
END Tool_Equipment_Serial_Exist___;
   
FUNCTION Shpord_Completely_Received___
   (order_no_           IN VARCHAR2,
    line_no_            IN VARCHAR2,
    release_no_         IN VARCHAR2) RETURN BOOLEAN
IS
   completely_received_    VARCHAR2(5);
   stmt_                   VARCHAR2(2000);
   result_                 BOOLEAN:=FALSE;
BEGIN
   stmt_ := 'DECLARE
                completely_received_ VARCHAR2(5) := ''FALSE'';
             BEGIN
                IF (Shop_Ord_Util_API.Completely_Received (:hist_order_no_,
                                                           :hist_line_no_,
                                                           :hist_release_no_)) THEN
                  completely_received_ := ''TRUE'';
                END IF;
                :completely_received_ := completely_received_;
             END;';
   @ApproveDynamicStatement(2010-01-14,kayolk)
   EXECUTE IMMEDIATE stmt_ USING
      IN  order_no_,
      IN  line_no_,
      IN  release_no_,
      OUT completely_received_;

   IF (completely_received_ = 'TRUE') THEN
      result_ := TRUE;
   END IF;

   RETURN result_;
END Shpord_Completely_Received___;


FUNCTION Issued_To_Ext_Service_Order___
   (order_no_           IN VARCHAR2,
    line_no_            IN VARCHAR2,
    release_no_         IN VARCHAR2,
    part_no_            IN VARCHAR2,
    serial_no_          IN VARCHAR2) RETURN BOOLEAN
IS
   connected_to_eso_       VARCHAR2(5);
   stmt_                   VARCHAR2(2000);
   result_                 BOOLEAN:=FALSE;
BEGIN
   stmt_ := 'DECLARE
                connected_to_eso_ VARCHAR2(5) := ''FALSE'';
             BEGIN
                IF (Purchase_Order_Line_Part_API.Is_Connected_To_Ext_Srv_Order(:hist_order_no_,
                                                                               :hist_line_no_,
                                                                               :hist_release_no_,
                                                                               :part_no_,
                                                                               :serial_no_)) THEN
                    connected_to_eso_ := ''TRUE'';
                END IF;
                :connected_to_eso := connected_to_eso_;
             END;';

   @ApproveDynamicStatement(2009-02-12,dayjlk)
   EXECUTE IMMEDIATE stmt_ USING
      IN  order_no_,
      IN  line_no_,
      IN  release_no_,
      IN  part_no_,
      IN  serial_no_,
      OUT connected_to_eso_;

   IF (connected_to_eso_ = 'TRUE') THEN
      result_ := TRUE;
   END IF;

   RETURN result_;
END Issued_To_Ext_Service_Order___;


PROCEDURE Reset_Renamed_From___ (
    part_no_          IN VARCHAR2,
    serial_no_        IN VARCHAR2 )
IS
   attr_               VARCHAR2(2000);
   oldrec_             part_serial_catalog_tab%ROWTYPE;
   newrec_             part_serial_catalog_tab%ROWTYPE;
   objid_              part_serial_catalog.objid%TYPE;
   objversion_         part_serial_catalog.objversion%TYPE;
   indrec_             Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   oldrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_ := oldrec_;
   newrec_.renamed_from_part_no   := TO_CHAR(NULL);
   newrec_.renamed_from_serial_no := TO_CHAR(NULL);
   
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_ => TRUE);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Reset_Renamed_From___;


FUNCTION Get_Renaming_Trans_Desc___ (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   new_part_no_      IN VARCHAR2,
   new_serial_no_    IN VARCHAR2,
   rename_reason_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN

   RETURN Language_SYS.Translate_Constant(lu_name_, 'RENSER: Renamed from :P1 to :P2 because of :P3.',NULL, part_no_||':'||serial_no_, new_part_no_||':'|| new_serial_no_, Serial_Rename_Reason_API.Decode(rename_reason_db_));
END Get_Renaming_Trans_Desc___;


PROCEDURE Check_Part_Ownership___ (
   part_ownership_db_      IN VARCHAR2,
   owning_vendor_no_       IN VARCHAR2,
   owning_customer_no_     IN VARCHAR2,
   part_no_                IN VARCHAR2,
   serial_no_              IN VARCHAR2,
   superior_part_no_       IN VARCHAR2,
   superior_serial_no_     IN VARCHAR2)
IS

BEGIN

   IF (part_ownership_db_ = Part_Ownership_API.DB_CUSTOMER_OWNED) THEN
      IF (owning_customer_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTOMERNEEDSVALUE: Owning Customer No needs to have a value for :P1 stock.', Part_Ownership_API.Decode(part_ownership_db_));
      END IF;
   ELSIF (part_ownership_db_ IN (Part_Ownership_API.DB_SUPPLIER_LOANED,
                                 Part_Ownership_API.DB_SUPPLIER_OWNED,
                                 Part_Ownership_API.DB_CONSIGNMENT,
                                 Part_Ownership_API.DB_SUPPLIER_RENTED)) THEN
      IF (owning_vendor_no_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'VENDORNEEDSVALUE: Owning Vendor No needs to have a value for :P1 stock.', Part_Ownership_API.Decode(part_ownership_db_));
      END IF;
   ELSIF (part_ownership_db_ NOT IN (Part_Ownership_API.DB_COMPANY_OWNED, 
                                     Part_Ownership_API.DB_COMPANY_RENTAL_ASSET)) THEN
      Error_SYS.Record_General(lu_name_, 'OWNERSHIPERR: Part Ownership :P1 is not supported in this operation.', Part_Ownership_API.Decode(part_ownership_db_));
   END IF;
   IF (part_ownership_db_ IN (Part_Ownership_API.DB_SUPPLIER_RENTED)) THEN
      IF ((superior_part_no_ IS NOT NULL) OR (superior_serial_no_ IS NOT NULL)) THEN
         Error_SYS.Record_General(lu_name_, 'OWNERSHIPPARENT: A serial with Ownership :P1 is not allowed to be connected to a structure.', Part_Ownership_API.Decode(part_ownership_db_));
      END IF;
      IF (Is_Parent___(part_no_, serial_no_)) THEN
         Error_SYS.Record_General(lu_name_, 'OWNERSHIPCHILD: A serial with Ownership :P1 is not allowed to have structure.', Part_Ownership_API.Decode(part_ownership_db_));
      END IF;
   END IF;

END Check_Part_Ownership___;

PROCEDURE Set_Ownership_After_Issue___ (
   part_no_        IN  VARCHAR2,
   serial_no_      IN  VARCHAR2,
   order_no_       IN  VARCHAR2,
   line_no_        IN  VARCHAR2,
   release_no_     IN  VARCHAR2,
   line_item_no_   IN  NUMBER,
   order_type_     IN  VARCHAR2)
IS
   new_part_ownership_     part_serial_catalog_tab.part_ownership%TYPE; 
   new_owning_vendor_no_   part_serial_catalog_tab.owning_vendor_no%TYPE;
   new_owning_customer_no_ part_serial_catalog_tab.owning_customer_no%TYPE;
BEGIN 

   IF (order_type_ = Order_Type_API.Decode('CUST ORDER')) THEN
      $IF Component_Order_SYS.INSTALLED $THEN
         new_owning_customer_no_ := Customer_Order_Line_API.Get_Owning_Cust_After_Delivery(order_no_,
                                                                                           line_no_, 
                                                                                           release_no_, 
                                                                                           line_item_no_);
      $ELSE
         Error_SYS.Component_Not_Exist('ORDER');
      $END
   ELSIF (order_type_ = Order_Type_API.Decode(Order_Type_API.DB_PROJECT_DELIVERABLES)) THEN
      $IF Component_Prjdel_SYS.INSTALLED $THEN
         new_owning_customer_no_ := Planning_Shipment_API.Get_Customer_Id(order_no_,line_no_,release_no_);
      $ELSE
         Error_SYS.Component_Not_Exist('PRJDEL');
      $END
   END IF;
   IF (new_owning_customer_no_ IS NOT NULL) THEN
      new_part_ownership_   := Part_Ownership_API.DB_CUSTOMER_OWNED;
      new_owning_vendor_no_ := NULL;
      Set_Serial_Ownership(part_no_, serial_no_, new_part_ownership_, new_owning_vendor_no_, new_owning_customer_no_);
   END IF;
END Set_Ownership_After_Issue___;


FUNCTION Is_Parent___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   is_parent_ BOOLEAN := FALSE;
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   part_serial_catalog_tab
      WHERE superior_part_no   = part_no_
      AND   superior_serial_no = serial_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      is_parent_ := TRUE;
   END IF;
   CLOSE exist_control;
   RETURN(is_parent_);
END Is_Parent___;


-- Modify_Eng_Part_Revision___
--   This method modifies the Eng Part Revision when the transactions are Unissued.
PROCEDURE Modify_Eng_Part_Revision___ (
   part_no_               IN VARCHAR2,
   serial_no_             IN VARCHAR2,
   new_eng_part_revision_ IN VARCHAR2 )
IS
   attr_       VARCHAR2 (2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;
   oldrec_     part_serial_catalog_tab%ROWTYPE;
   newrec_     part_serial_catalog_tab%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN

   IF ( Validate_Eng_Part_Revision___( part_no_, new_eng_part_revision_)) THEN
      oldrec_ := Lock_By_Keys___(part_no_, serial_no_);

      IF (NVL(oldrec_.eng_part_revision, string_null_) != new_eng_part_revision_) THEN
         newrec_ := oldrec_;
         Client_SYS.Clear_Attr(attr_);
         newrec_.eng_part_revision := new_eng_part_revision_;
         indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_ => TRUE);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   END IF;

END Modify_Eng_Part_Revision___;


-- Get_Top_Serial___
--   Returns the top_part_no with top_serial_no for a given part_no and a serial_no.
PROCEDURE Get_Top_Serial___ (
   top_part_no_   OUT VARCHAR2,
   top_serial_no_ OUT VARCHAR2,
   part_no_       IN  VARCHAR2,
   serial_no_     IN  VARCHAR2 )
IS
   rec_ part_serial_catalog_tab%ROWTYPE;
BEGIN

   top_part_no_   := part_no_;
   top_serial_no_ := serial_no_;
   rec_           := Get_Object_By_Keys___(part_no_, serial_no_);

   IF ((rec_.superior_part_no   IS NOT NULL) AND
       (rec_.superior_serial_no IS NOT NULL)) THEN
      Get_Top_Serial___(top_part_no_, top_serial_no_, rec_.superior_part_no, rec_.superior_serial_no);
   END IF;
END Get_Top_Serial___;


PROCEDURE Modify_Configuration_Id___ (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   configuration_id_ IN VARCHAR2 )
IS
   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   IF (configuration_id_ IS NOT NULL) THEN
      newrec_ := Lock_By_Keys___(part_no_, serial_no_);
      IF (newrec_.configuration_id != configuration_id_) THEN
         newrec_.configuration_id := configuration_id_;
         Modify___(newrec_);
      END IF;
   END IF;
END Modify_Configuration_Id___;


PROCEDURE New___ (
   newrec_              IN OUT part_serial_catalog_tab%ROWTYPE,
   serial_event_        IN     VARCHAR2,
   transaction_date_    IN     DATE DEFAULT NULL,
   created_by_server_   IN     BOOLEAN DEFAULT FALSE,
   inv_transaction_id_  IN     NUMBER DEFAULT NULL)
IS
   objid_         part_serial_catalog.objid%TYPE;
   objversion_    part_serial_catalog.objversion%TYPE;     
   indrec_        Indicator_Rec;
   attr_          VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_, transaction_date_, created_by_server_);
   Insert___(objid_, objversion_, newrec_, attr_, serial_event_, transaction_date_, inv_transaction_id_); 
END New___;


@Override
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT part_serial_catalog_tab%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   IF ((rec_.rowstate = 'InFacility') AND (state_ != 'InFacility')) THEN
      rec_.ignore_stop_arrival_issued := 'FALSE';
   END IF;
   
   IF ((rec_.rowstate = 'Issued') AND (state_ != 'Issued')) THEN
      rec_.ignore_stop_arrival_issued := 'FALSE';
   END IF;
   
   IF (rec_.rowstate != 'InInventory' AND state_ = 'InInventory') THEN
      IF rec_.operational_status = 'IN_OPERATION' THEN
         rec_.operational_status := 'OUT_OF_OPERATION';
      END IF;
   END IF;

   IF (rec_.rowstate = 'InInventory' AND state_ != 'InInventory') THEN
      IF rec_.tracked_in_inventory = Fnd_Boolean_API.db_true THEN
         rec_.tracked_in_inventory := Fnd_Boolean_API.db_false;
      END IF;
   END IF;

   --When the Serial Object is moved to Inventory its parent connection should be cleared.
   $IF Component_Equip_SYS.INSTALLED $THEN
      IF (rec_.rowstate IN ( 'InFacility', 'Contained', 'InRepairWorkshop') AND state_ = 'InInventory') THEN
         Equipment_Object_Util_API.Handle_Moved_To_Invent(rec_.part_no, rec_.serial_no); 
      END IF;
   $END
   
   UPDATE part_serial_catalog_tab
      SET ignore_stop_arrival_issued = rec_.ignore_stop_arrival_issued,
          operational_status = rec_.operational_status,
          tracked_in_inventory = rec_.tracked_in_inventory         
    WHERE part_no = rec_.part_no
      AND serial_no = rec_.serial_no;
   
   super(rec_, state_);
END Finite_State_Set___;

@Override
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT NOCOPY part_serial_catalog_tab%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT NOCOPY VARCHAR2 )
IS
   serial_event_ VARCHAR2(30);
BEGIN
   -- Some parts may have a state change right away as they are created, to provide this functionality
   -- we do this override and investigate if an specific initial event is provided through attribute string. 
   -- But only if no other event is provided as a in-parameter, which in that case has precedence.
   IF event_ IS NULL THEN
      serial_event_ := Client_SYS.Get_Item_Value('SERIAL_EVENT', attr_);
   ELSE
      serial_event_ := event_;
   END IF;
   super(rec_, serial_event_, attr_);
END Finite_State_Machine___;

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PART_OWNERSHIP_DB', 'COMPANY OWNED', attr_);
   Client_SYS.Add_To_Attr('PART_OWNERSHIP', Part_Ownership_API.Decode('COMPANY OWNED'), attr_);
   Client_SYS.Add_To_Attr('IGNORE_STOP_ARRIVAL_ISSUED_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('TRACKED_IN_INVENTORY_DB', Fnd_Boolean_API.DB_FALSE, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_                 OUT VARCHAR2,
   objversion_            OUT VARCHAR2,
   newrec_             IN OUT part_serial_catalog_tab%ROWTYPE,
   attr_               IN OUT VARCHAR2,
   serial_event_       IN     VARCHAR2 DEFAULT NULL,
   transaction_date_   IN     DATE     DEFAULT NULL,
   inv_transaction_id_ IN     NUMBER   DEFAULT NULL)
IS
BEGIN
   IF (newrec_.renamed_to_serial_no IS NULL) THEN
      newrec_.rename_reason := NULL; 
   END IF;
   -- server defaults
   newrec_.date_created := sysdate;
   Client_SYS.Add_To_Attr('DATE_CREATED', newrec_.date_created, attr_);
   newrec_.user_created := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USER_CREATED', newrec_.user_created, attr_);
   newrec_.date_changed := newrec_.date_created;
   Client_SYS.Add_To_Attr('DATE_CHANGED', newrec_.date_changed, attr_);
   newrec_.user_changed := newrec_.user_created;
   Client_SYS.Add_To_Attr('USER_CHANGED', newrec_.user_changed, attr_);
   
   IF (newrec_.configuration_id IS NULL) AND (serial_event_ = 'NewInFacility') THEN
      newrec_.configuration_id := '*';
   END IF;

   -- Sets the owning_customer_no columns null when part_ownership is not customer owned.
   -- Sets the owning_vendor_no null when part_ownership is not consignment, supplier loaned, supplier owned and supplier rented.
   IF (newrec_.part_ownership != Part_Ownership_API.DB_CUSTOMER_OWNED) THEN
      newrec_.owning_customer_no := NULL;
   END IF;

   IF (newrec_.part_ownership NOT IN (Part_Ownership_API.DB_CONSIGNMENT,
                                      Part_Ownership_API.DB_SUPPLIER_LOANED,
                                      Part_Ownership_API.DB_SUPPLIER_OWNED,
                                      Part_Ownership_API.DB_SUPPLIER_RENTED)) THEN
      newrec_.owning_vendor_no := NULL;
   END IF;
   Client_SYS.Add_To_Attr('SERIAL_EVENT', serial_event_, attr_);
   --
   super(objid_, objversion_, newrec_, attr_);
   SELECT rowid
      INTO  objid_
      FROM  part_serial_catalog_tab
      WHERE part_no = newrec_.part_no
      AND   serial_no = newrec_.serial_no;

   IF (transaction_date_ IS NULL) THEN
      IF (newrec_.renamed_from_part_no IS NOT NULL) THEN
         Part_Serial_History_API.New(part_no_                  => newrec_.part_no,
                                     serial_no_                => newrec_.serial_no,
                                     history_purpose_db_       => 'CHG_PART_SERIAL_NO',
                                     transaction_description_  => newrec_.latest_transaction,
                                     renamed_from_part_no_     => newrec_.renamed_from_part_no,
                                     renamed_from_serial_no_   => newrec_.renamed_from_serial_no,
                                     rename_reason_db_         => newrec_.rename_reason);
         -- Invoke Replace Serial call in Inventory Part In Stock here
         IF (Get_Objstate(newrec_.renamed_from_part_no, newrec_.renamed_from_serial_no) = 'InInventory') THEN
            $IF (Component_Invent_SYS.INSTALLED) $THEN
                  Inventory_Part_In_Stock_API.Rename_Serial(newrec_.renamed_from_part_no, newrec_.renamed_from_serial_no, newrec_.part_no, newrec_.serial_no);
            $ELSE
               NULL;
            $END
            END IF;
         END IF;
   ELSE
      Part_Serial_History_API.New( newrec_.part_no, 
                                   newrec_.serial_no,
                                   Serial_History_Purpose_API.DB_CHANGED_PART_AND_SERIAL_NO,
                                   newrec_.latest_transaction,
                                   renamed_to_part_no_   => newrec_.renamed_to_part_no,
                                   renamed_to_serial_no_ => newrec_.renamed_to_serial_no,
                                   rename_reason_db_     => newrec_.rename_reason,
                                   transaction_date_     => transaction_date_);
   END IF;
   -- create Defense IUID for part when IUID enabled for serial parts                              
   $IF (Component_Deford_SYS.INSTALLED) $THEN   
      IF (serial_event_ = 'NewInFacility' OR serial_event_ = 'NewInInventory' OR serial_event_ = 'NewInContained') THEN
         Defense_Part_Iuid_Util_API.Build_Defense_Iuid(part_no_                 => newrec_.part_no,
                                                      serial_no_                => newrec_.serial_no,
                                                      transaction_id_           => inv_transaction_id_);                                                       
      END IF;
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
        Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_                  IN     VARCHAR2,
   oldrec_                 IN     part_serial_catalog_tab%ROWTYPE,
   newrec_                 IN OUT part_serial_catalog_tab%ROWTYPE,
   attr_                   IN OUT VARCHAR2,
   objversion_             IN OUT VARCHAR2,
   by_keys_                IN     BOOLEAN DEFAULT FALSE,
   transaction_date_       IN     DATE    DEFAULT NULL )
IS
   message_                      VARCHAR2(2000);
   stmt_                         VARCHAR2 (2000);
   char_null_                    VARCHAR2(12) := 'VARCHAR2NULL';
   make_post_cond_change_action_ BOOLEAN := FALSE;
BEGIN
   IF (newrec_.renamed_to_serial_no IS NULL) THEN
      newrec_.rename_reason := NULL; 
   END IF;

   -- server defaults
   newrec_.date_changed := sysdate;
   Client_SYS.Add_To_Attr('DATE_CHANGED', newrec_.date_changed, attr_);
   newrec_.user_changed := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('USER_CHANGED', newrec_.user_changed, attr_);
   --
   Trace_SYS.Message('update latest_transaction-'||' - '||newrec_.latest_transaction);

   IF (NVL(newrec_.condition_code, char_null_) != NVL(oldrec_.condition_code, char_null_)) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Invent_Condition_Code_Util_API.Make_Pre_Serial_Change_Action (newrec_.part_no, newrec_.serial_no );
         make_post_cond_change_action_ := TRUE;
      $ELSE
         NULL;
      $END
       END IF;

   IF ((newrec_.operational_status != oldrec_.operational_status) AND
       (newrec_.operational_status = 'SCRAPPED')) THEN
      $IF (Component_Vim_SYS.INSTALLED) $THEN
         Vim_Serial_API.Scrap_Serial (newrec_.part_no, newrec_.serial_no );         
      $ELSE
         NULL;
      $END
   END IF;

   -- Sets the owning_customer_no columns null when part_ownership is not customer owned.
   -- Sets the owning_vendor_no null when part_ownership is not consignment, supplier loaned, supplier owned and supplier rented.
   IF (newrec_.part_ownership != Part_Ownership_API.DB_CUSTOMER_OWNED) THEN
      newrec_.owning_customer_no := NULL;
   END IF;

   IF (newrec_.part_ownership NOT IN (Part_Ownership_API.DB_CONSIGNMENT,
                                      Part_Ownership_API.DB_SUPPLIER_LOANED,
                                      Part_Ownership_API.DB_SUPPLIER_OWNED,
                                      Part_Ownership_API.DB_SUPPLIER_RENTED)) THEN
      newrec_.owning_vendor_no := NULL;
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.operational_status != oldrec_.operational_status) AND (newrec_.operational_status = 'SCRAPPED') THEN
      $IF (Component_Equip_SYS.INSTALLED) $THEN
         Equipment_Object_Util_API.Handle_Scrap_Serial_Object(newrec_.part_no,
                                                              newrec_.serial_no);                 
      $ELSE
         NULL;   
      $END
      END IF;

   IF (make_post_cond_change_action_) THEN
      stmt_ := 'BEGIN
               Invent_Condition_Code_Util_API.Make_Post_Serial_Change_Action (
                  :part_no,
                  :serial_no,
                  :condition_code );
               END;';
      @ApproveDynamicStatement(2006-01-23,JaJalk)
      EXECUTE IMMEDIATE stmt_
         USING
            IN     newrec_.part_no,
            IN     newrec_.serial_no,
            IN     newrec_.condition_code;
   END IF;

   -- Make necessary changes to operation budget if owner has changed
   IF (oldrec_.owner_id != newrec_.owner_id) THEN
      Remove_Budgets___(newrec_, oldrec_);
   END IF;

   IF (NVL(newrec_.manu_part_no, char_null_) != NVL(oldrec_.manu_part_no, char_null_)) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MANU_PARTNO_CHG: Manufacturing Part No changed from :P1 to :P2', NULL, oldrec_.manu_part_no, newrec_.manu_part_no);
      -- Create record in PartSerialHistory
      Part_Serial_History_API.New(newrec_.part_no, newrec_.serial_no, 'CHG_MANU_PART_NO', message_);
   END IF;

   IF (NVL(newrec_.supplier_no, char_null_) != NVL(oldrec_.supplier_no, char_null_) AND oldrec_.supplier_no IS NOT NULL) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'SUPPLIER_CHG: Supplier No changed from :P1 to :P2', NULL, oldrec_.supplier_no, newrec_.supplier_no);
      -- Create record in PartSerialHistory
      Part_Serial_History_API.New(newrec_.part_no, newrec_.serial_no, 'CHG_MANU_PART_NO', message_);
   END IF;

   IF (newrec_.manufacturer_no != oldrec_.manufacturer_no) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'MANUFACTURER_CHG: Manufacturer changed from :P1 to :P2', NULL, oldrec_.manufacturer_no, newrec_.manufacturer_no);
      -- Create record in PartSerialHistory
      Part_Serial_History_API.New(newrec_.part_no, newrec_.serial_no, 'CHG_MANUFACTURER', message_);
   END IF;
   IF (newrec_.owner_id != oldrec_.owner_id) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'OWNER_ID_CHG: Owner Id changed from :P1 to :P2', NULL, oldrec_.owner_id, newrec_.owner_id);
      -- Create record in PartSerialHistory
      Part_Serial_History_API.New(newrec_.part_no, newrec_.serial_no, 'CHG_OWNER_ID', message_);
   END IF;
   IF (newrec_.acquisition_cost != oldrec_.acquisition_cost) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'ACQUISITION_COST_CHG: Acquisition Cost changed from :P1 to :P2', NULL, oldrec_.acquisition_cost, newrec_.acquisition_cost);
      -- Create record in PartSerialHistory
      Part_Serial_History_API.New(newrec_.part_no, newrec_.serial_no, 'CHG_ACQUISITION_COST', message_);
   END IF;
   IF (newrec_.currency_code != oldrec_.currency_code) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'CURRENCY_CODE_CHG: Currency Code changed from :P1 to :P2', NULL, oldrec_.currency_code, newrec_.currency_code);
      -- Create record in PartSerialHistory
      Part_Serial_History_API.New(newrec_.part_no, newrec_.serial_no, 'CHG_ACQUISITION_COST', message_);
   END IF;

   IF (transaction_date_ IS NULL) THEN
      IF (newrec_.renamed_from_part_no IS NOT NULL) THEN
         IF (nvl(oldrec_.renamed_from_part_no,char_null_) != newrec_.renamed_from_part_no OR
             nvl(oldrec_.renamed_from_serial_no,char_null_) != newrec_.renamed_from_serial_no) THEN

            Part_Serial_History_API.New(part_no_                  => newrec_.part_no,
                                        serial_no_                => newrec_.serial_no,
                                        history_purpose_db_       => 'CHG_PART_SERIAL_NO',
                                        transaction_description_  => newrec_.latest_transaction,
                                        renamed_from_part_no_     => newrec_.renamed_from_part_no,
                                        renamed_from_serial_no_   => newrec_.renamed_from_serial_no);

            -- Invoke Replace Serial call in Inventory Part In Stock here
            IF (Get_Objstate(newrec_.renamed_from_part_no, newrec_.renamed_from_serial_no) = 'InInventory') THEN
               $IF (Component_Invent_SYS.INSTALLED) $THEN
                  Inventory_Part_In_Stock_API.Rename_Serial(newrec_.renamed_from_part_no, newrec_.renamed_from_serial_no, newrec_.part_no, newrec_.serial_no); 
               $ELSE
                  NULL;
               $END
               END IF;

         END IF;
      END IF;

      IF (newrec_.renamed_to_part_no IS NOT NULL) THEN
         IF (nvl(oldrec_.renamed_to_part_no,char_null_) != newrec_.renamed_to_part_no OR
             nvl(oldrec_.renamed_to_serial_no,char_null_) != newrec_.renamed_to_serial_no) THEN
            Part_Serial_History_API.New(part_no_                  => newrec_.part_no,
                                        serial_no_                => newrec_.serial_no,
                                        history_purpose_db_       => 'CHG_PART_SERIAL_NO',
                                        transaction_description_  => newrec_.latest_transaction,
                                        renamed_to_part_no_       => newrec_.renamed_to_part_no,
                                        renamed_to_serial_no_     => newrec_.renamed_to_serial_no,
                                        rename_reason_db_         => newrec_.rename_reason);
         END IF;
      END IF;
   ELSE
      message_ := Get_Renaming_Trans_Desc___(newrec_.renamed_from_part_no, newrec_.renamed_from_serial_no, newrec_.part_no, newrec_.serial_no, newrec_.rename_reason);
      Part_Serial_History_API.New( newrec_.part_no,
                                   newrec_.serial_no,
                                   Serial_History_Purpose_API.DB_CHANGED_PART_AND_SERIAL_NO,
                                   message_, renamed_from_part_no_ => newrec_.renamed_from_part_no,
                                   renamed_from_serial_no_         => newrec_.renamed_from_serial_no,
                                   transaction_date_               => transaction_date_ );
   END IF;
   IF nvl(newrec_.eng_part_revision, char_null_) != nvl(oldrec_.eng_part_revision, char_null_) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'ENG_PARTREV_CHG: Engineering Part Revision changed from :P1 to :P2.', NULL, oldrec_.eng_part_revision, newrec_.eng_part_revision);
      -- Create record in PartSerialHistory
      Part_Serial_History_API.New(newrec_.part_no, newrec_.serial_no, 'CHG_REVISION', message_);
   END IF;
   --
   $IF (Component_Vim_SYS.INSTALLED) $THEN
      Vim_Serial_API.Check_Maint_Dates_Change(
         part_no_ => newrec_.part_no,
         serial_no_ => newrec_.serial_no,
         old_inst_date_ => oldrec_.installation_date,
         new_inst_date_ => newrec_.installation_date,
         old_man_date_ => oldrec_.manufactured_date,
         new_man_date_ => newrec_.manufactured_date);
   $END
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

PROCEDURE Check_Configuration_Id_Ref___ (
   newrec_ IN OUT part_serial_catalog_tab%ROWTYPE )
IS
BEGIN
   IF (Part_Catalog_API.Get_Configurable_Db(newrec_.part_no) = 'CONFIGURED')THEN 
      $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
         Configuration_Spec_API.Exist(newrec_.part_no, newrec_.configuration_id);
      $ELSE
         Error_SYS.Record_General(lu_name_, 'BLOCKCONFIGID: Configuration Id may not be specified when Configuration Specification is not installed.');
      $END
   END IF;
END Check_Configuration_Id_Ref___;

PROCEDURE Check_Owning_Vendor_No_Ref___ (
   newrec_ IN OUT part_serial_catalog_tab%ROWTYPE )
IS
BEGIN
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Supplier_API.Exist(newrec_.owning_vendor_no);     
   $ELSE
      Error_SYS.Record_General(lu_name_, 'NOSUPPLIER: A Supplier may not be specified as Owner when Purchasing is not installed.');
   $END
END Check_Owning_Vendor_No_Ref___;

PROCEDURE Check_Owning_Cust_No_Ref___ (
   newrec_ IN OUT part_serial_catalog_tab%ROWTYPE )
IS
BEGIN
   $IF (Component_Order_SYS.INSTALLED) $THEN
      Cust_Ord_Customer_API.Exist(newrec_.owning_customer_no);      
   $ELSE
      Error_SYS.Record_General(lu_name_, 'NOCUSTOMER: A Customer may not be specified as Owner when Customer Order is not installed.');
   $END
END Check_Owning_Cust_No_Ref___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN part_serial_catalog_tab%ROWTYPE,
   force_removal_ IN BOOLEAN DEFAULT FALSE)
IS
   key_             VARCHAR2(2000);
   tech_spec_no_    NUMBER;
   tech_spec_class_ VARCHAR2(10);
   quantity_exists_ NUMBER;
BEGIN
   super(remrec_);

   IF remrec_.operational_status NOT IN ('RENAMED', 'PLANNED_FOR_OP', 'SCRAPPED') AND force_removal_ = FALSE THEN
      IF ((remrec_.renamed_from_part_no IS NOT NULL) OR
         (remrec_.renamed_from_serial_no IS NOT NULL) OR
         (remrec_.renamed_to_part_no IS NOT NULL) OR
         (remrec_.renamed_to_serial_no IS NOT NULL))   THEN
         Error_SYS.Record_General(lu_name_, 'RENAMEDSERIAL: Serial :P1, :P2 has been involved in a renaming process. Renamed serials cannot be deleted.', remrec_.part_no, remrec_.serial_no);
      END IF;
   END IF;
   -- check if technical object references may be removed
   tech_spec_no_ := Technical_Object_Reference_API.Get_Technical_Spec_No(lu_name_, key_);
   IF (Technical_Object_Reference_API.Check_Approved(tech_spec_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'SERIALAPPROVEDTECH: Serial :P1 has approved technical specifications. Unapprove these before removing serial.', remrec_.part_no||','||remrec_.serial_no);
   ELSE
      tech_spec_class_ := Technical_Object_Reference_API.Get_Technical_Class_With_Key(lu_name_, key_);
      IF (nvl(Technical_Object_Reference_API.Get_Defined_Count(tech_spec_no_, tech_spec_class_), 0) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'SERIALDEFINEDTECH: Serial :P1 has defined values for technical specifications. Remove these before removing serial.', remrec_.part_no||','||remrec_.serial_no);
      END IF;
   END IF;
   $IF Component_Invent_SYS.INSTALLED $THEN
      quantity_exists_ := Invent_Part_Quantity_Util_API.Check_Individual_Exist(remrec_.part_no, remrec_.serial_no);
      IF (quantity_exists_ = 1) THEN
         Error_SYS.Record_General(lu_name_, 'ININVENTORYNODEL: Serial :P1 of Part :P2 is in Inventory and can not be deleted.', remrec_.serial_no, remrec_.part_no);
      END IF;
   $END
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN part_serial_catalog_tab%ROWTYPE )
IS
   key_                VARCHAR2(2000);
   serial_history_tab_ Part_Serial_History_API.Serial_History_Tab;
BEGIN
   super(objid_, remrec_);
   -- Remove document references
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      Doc_Reference_Object_API.Delete_Obj_Reference(lu_name_, key_); 
   $END
   -- Remove technical references
   Technical_Object_Reference_API.Delete_Reference(lu_name_, key_);
   --
   serial_history_tab_ := Part_Serial_History_API.Get_Serial_History (remrec_.part_no, remrec_.serial_no);  
   
   IF (remrec_.renamed_to_serial_no IS NOT NULL) THEN
      IF Check_Exist___(remrec_.renamed_to_part_no, remrec_.renamed_to_serial_no) THEN
         IF (((remrec_.renamed_from_serial_no IS NULL) OR (Is_Last_In_Rename_Chain___(remrec_.renamed_from_part_no, remrec_.renamed_from_serial_no) = TRUE)) AND 
             ((remrec_.rename_reason = 'CORRECT TYPING ERROR') OR (remrec_.renamed_from_serial_no = remrec_.renamed_to_serial_no AND
                                                                   remrec_.renamed_from_part_no   = remrec_.renamed_to_part_no))) THEN

            Reset_Renamed_From___(remrec_.renamed_to_part_no, remrec_.renamed_to_serial_no);
            Part_Serial_History_API.Inherit_When_Removing_Renamed(remrec_.part_no, 
                                                                  remrec_.serial_no,
                                                                  remrec_.renamed_to_part_no, 
                                                                  remrec_.renamed_to_serial_no,
                                                                  serial_history_tab_);
         ELSE
            Remove(remrec_.renamed_to_part_no, remrec_.renamed_to_serial_no);
         END IF;
      END IF;
   ELSE 
      IF (remrec_.renamed_from_serial_no IS NOT NULL ) THEN
         IF Check_Exist___(remrec_.renamed_from_part_no, remrec_.renamed_from_serial_no) THEN
            Remove(remrec_.renamed_from_part_no, remrec_.renamed_from_serial_no);
         END IF;
      END IF;
   END IF;

   $IF (Component_Invent_SYS.INSTALLED) $THEN
      Inventory_Part_Unit_Cost_API.Handle_Serial_Removal (remrec_.part_no, remrec_.serial_no );            
   $END
END Delete___;


-- Shipped_To_Supplier___
--   Returns TRUE if serial part has been issued and shipped to the supplier
FUNCTION Shipped_To_Supplier___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   shipped_to_supplier_ BOOLEAN := FALSE;

BEGIN

   IF (Is_Issued(part_no_, serial_no_) = 'TRUE') THEN
      IF (Part_Serial_History_API.Get_Latest_Trans_Order_Type(part_no_, serial_no_) = 'PUR ORDER') THEN
         shipped_to_supplier_ := TRUE;
      END IF;
   END IF;

   RETURN shipped_to_supplier_;
END Shipped_To_Supplier___;

FUNCTION Plant_Object_Serial_Exist___
   (part_no_          IN VARCHAR2,
    serial_no_        IN VARCHAR2) RETURN BOOLEAN
IS
   plant_object_serial_exists_ VARCHAR2(5);
   result_                     BOOLEAN:=FALSE;
BEGIN
   $IF (Component_Plades_SYS.INSTALLED) $THEN
      plant_object_serial_exists_ := Plant_Object_Api.Check_Serial_No_Exist(part_no_, serial_no_ );               
      IF plant_object_serial_exists_ = 'TRUE' THEN
         result_ := TRUE;
      END IF;
   $END

   RETURN result_;

END Plant_Object_Serial_Exist___;


FUNCTION Is_Supplier_Internal___ (
   order_no_           IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN 
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF Purchase_Order_API.Supplier_Is_Internal(order_no_) = 'TRUE' THEN
         RETURN TRUE;
      END IF;
   $END
   RETURN FALSE;
END Is_Supplier_Internal___;


@Override
PROCEDURE Check_Insert___ (
   newrec_              IN OUT part_serial_catalog_tab%ROWTYPE,
   indrec_              IN OUT Indicator_Rec,
   attr_                IN OUT VARCHAR2,
   transaction_date_    IN     DATE DEFAULT NULL,
   created_by_server_   IN     BOOLEAN DEFAULT FALSE )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   partca_rec_   Part_Catalog_API.Public_Rec;
   dummy_               NUMBER;
BEGIN
   IF (newrec_.part_ownership IS NULL) THEN
      newrec_.part_ownership := 'COMPANY OWNED';
   END IF;

   IF (newrec_.tracked_in_inventory IS NULL) THEN
      newrec_.tracked_in_inventory := Fnd_Boolean_API.DB_FALSE;
   END IF;

   IF indrec_.ignore_stop_arrival_issued = FALSE THEN
      newrec_.ignore_stop_arrival_issued := 'FALSE';
   END IF;
   
   
   IF NOT created_by_server_ THEN
      Validate_SYS.Item_Insert(lu_name_, 'RENAMED_TO_PART_NO', indrec_.renamed_to_part_no); 
      Validate_SYS.Item_Insert(lu_name_, 'RENAMED_TO_SERIAL_NO', indrec_.renamed_to_serial_no);       
      Validate_SYS.Item_Insert(lu_name_, 'RENAMED_FROM_PART_NO', indrec_.renamed_from_part_no);
      Validate_SYS.Item_Insert(lu_name_, 'RENAMED_FROM_SERIAL_NO', indrec_.renamed_from_serial_no);      
   END IF;   
   
   IF (newrec_.fa_object_system_defined IS NULL) THEN
      newrec_.fa_object_system_defined := Fnd_Boolean_API.DB_FALSE;
   END IF;

   super(newrec_, indrec_, attr_);
   IF (newrec_.renamed_to_serial_no IS NOT NULL) THEN
      Error_SYS.Check_Not_Null(lu_name_, 'RENAME_REASON', newrec_.rename_reason);
   END IF;
   Error_SYS.Check_Valid_Key_String('SERIAL_NO',newrec_.serial_no);
   partca_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   
   -- check if valid number for serial rule automatic
   BEGIN
      IF (partca_rec_.serial_rule = Part_Serial_Rule_API.DB_AUTOMATIC ) THEN
         -- Assigned the number value to the dummy_ variable.
         dummy_ := TO_NUMBER(newrec_.serial_no);
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Record_General(lu_name_, 'VALIDNUMBER: Alphanumeric serials(:P1) are not allowed when serial rule is :P2',newrec_.serial_no,Part_Serial_Rule_API.Decode(partca_rec_.serial_rule));
   END;

   IF (newrec_.superior_part_no IS NOT NULL) AND (newrec_.superior_serial_no IS NOT NULL) THEN
     Part_Serial_Catalog_API.Exist(newrec_.superior_part_no, newrec_.superior_serial_no);
     -- Structure is allowed since this is the first part_no - serial_no .
     Is_Part_Selfcontained___( newrec_.part_no,
                               newrec_.serial_no,
                               newrec_.superior_part_no,
                               newrec_.superior_serial_no);
  END IF;
   -- transaction_date_ contains a value only when a Serial is created as if it was Renamed to another Serial
   IF (transaction_date_ IS NULL) THEN
      Validate_Rename___ (newrec_);

      -- Above checks verify that both renamed_to_part_no and renamed_to_serial_no are either NULL or NOT NULL simultaneously
      IF (newrec_.renamed_to_part_no IS NOT NULL) OR (newrec_.renamed_to_serial_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RENTONEW: <Renamed To Part No> and <Renamed To Serial No> may not contain values when creating a new Part Serial, rename not allowed.');
      END IF;

      -- Above checks verify that both renamed_from_part_no and renamed_from_serial_no are either NULL or NOT NULL simultaneously
      IF (newrec_.renamed_from_part_no IS NOT NULL) THEN
         Check_Rename___(newrec_.renamed_from_part_no,
                         newrec_.renamed_from_serial_no,
                         newrec_.part_no,
                         newrec_.serial_no);
      END IF;
   ELSE
      IF (newrec_.renamed_from_part_no IS NOT NULL) OR (newrec_.renamed_from_serial_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RENFROMASNEW: <Renamed From Part No> and <Renamed From Serial No> may not contain values when creating a new Serial as Renamed.');
      END IF;
   END IF;

   IF (newrec_.condition_code IS NULL) THEN
      IF (partca_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
         newrec_.condition_code := Condition_Code_API.Get_Default_Condition_Code;
      END IF;
   ELSE
      IF (partca_rec_.condition_code_usage = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      END IF;
   END IF;

   Check_Part_Ownership___(newrec_.part_ownership,
                           newrec_.owning_vendor_no,
                           newrec_.owning_customer_no,
                           newrec_.part_no,
                           newrec_.serial_no,
                           newrec_.superior_part_no,
                           newrec_.superior_serial_no);

   -- check whether serial reservations exist for the part
   $IF (Component_Invent_SYS.INSTALLED) $THEN
      Serial_No_Reservation_API.Check_Part_Serial_Exist(newrec_.part_no, newrec_.serial_no);
   $END
   -- do additional validation
   Validate_Items___ (newrec_);

   IF (upper(newrec_.serial_no) != newrec_.serial_no) THEN
      Error_SYS.Record_General(lu_name_,'UPPERCASE: The serial number must be entered in upper-case.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_                 IN     part_serial_catalog_tab%ROWTYPE,
   newrec_                 IN OUT part_serial_catalog_tab%ROWTYPE,
   indrec_                 IN OUT Indicator_Rec,
   attr_                   IN OUT VARCHAR2,
   reversing_op_condition_ IN     BOOLEAN DEFAULT FALSE,
   transaction_date_       IN     DATE DEFAULT NULL,
   created_by_server_      IN     BOOLEAN DEFAULT FALSE )
IS
   name_                VARCHAR2(30);
   value_               VARCHAR2(4000);
   char_null_           VARCHAR2(12) := 'VARCHAR2NULL';
   dummy_value_         VARCHAR2(3);
   partca_rec_          Part_Catalog_API.Public_Rec;
   ptr_                 NUMBER;
BEGIN
   IF (oldrec_.operational_status = 'RENAMED') THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ NOT IN ('RENAMED_FROM_SERIAL_NO', 'RENAMED_FROM_PART_NO')) THEN
            Error_SYS.Record_General(lu_name_, 'RENAMEONLYSERIAL: Only renamed from serial no and renamed from part no can be updated for a renamed serial.');
         END IF;
      END LOOP;
   END IF;
   
   ptr_ := NULL;
   -- Check if the serial has been locked for update.
   -- When locked only update of notes should be allowed
   IF (oldrec_.locked_for_update = 'LOCKED') THEN
      WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
         IF (name_ NOT IN ('LOCKED_FOR_UPDATE', 'LOCKED_FOR_UPDATE_DB', 'DATE_LOCKED', 'NOTE_TEXT')) THEN
            Error_SYS.Record_General(lu_name_, 'REC_LOCKED: Only notes may be updated when the serial object has been locked for update');
         END IF;
      END LOOP;
   END IF;

   IF NOT created_by_server_ THEN  
      Validate_SYS.Item_Update(lu_name_, 'RENAMED_TO_PART_NO', indrec_.renamed_to_part_no);     
      Validate_SYS.Item_Update(lu_name_, 'RENAMED_TO_SERIAL_NO', indrec_.renamed_to_serial_no);     
      Validate_SYS.Item_Update(lu_name_, 'RENAMED_FROM_PART_NO', indrec_.renamed_from_part_no);     
      Validate_SYS.Item_Update(lu_name_, 'RENAMED_FROM_SERIAL_NO', indrec_.renamed_from_serial_no);     
      Validate_SYS.Item_Update(lu_name_, 'ENG_PART_REVISION', indrec_.eng_part_revision);          
      -- Perform the 'Update If NULL' check only when the 'created_by_server_ = FALSE'. 
      Validate_SYS.Item_Update_If_Null(lu_name_, 'INSTALLATION_DATE', newrec_.installation_date, oldrec_.installation_date, indrec_.installation_date);
      Validate_SYS.Item_Update_If_Null(lu_name_, 'MANUFACTURED_DATE', newrec_.manufactured_date, oldrec_.manufactured_date, indrec_.manufactured_date);
   END IF;   
   
   super(oldrec_, newrec_, indrec_, attr_);

   dummy_value_ := CHR(1)||CHR(2)||CHR(3);
   -- transaction_date_ contains a value only when a Serial is modified in order to create another Serial as if it was Renamed from the one being modified
   IF transaction_date_ IS NULL THEN
      Validate_Rename___(newrec_);

      IF (newrec_.renamed_to_part_no IS NULL) AND (newrec_.renamed_to_serial_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RENTOPARTNO: <Renamed To Part No> should be specified when <Renamed To Serial No> contains a value.');
      END IF;
      IF (newrec_.renamed_to_part_no IS NOT NULL) AND (newrec_.renamed_to_serial_no IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RENTOSERIAL: <Renamed To Serial No> should be specified when <Renamed To Part No> contains a value.');
      END IF;
      IF (newrec_.part_no = newrec_.renamed_to_part_no) AND (newrec_.serial_no = newrec_.renamed_to_serial_no) THEN
         Error_SYS.Record_General(lu_name_, 'RENTOSAME: <Part No> and <Serial No> contain the same values as <Renamed To Part No> and <Renamed To Serial No> respectively, rename not allowed.');
      END IF;

      IF (newrec_.renamed_from_part_no IS NOT NULL) THEN
         IF (nvl(oldrec_.renamed_from_part_no,char_null_) != newrec_.renamed_from_part_no OR
             nvl(oldrec_.renamed_from_serial_no,char_null_) != newrec_.renamed_from_serial_no) THEN

            IF (newrec_.renamed_to_part_no IS NOT NULL) THEN
               Error_SYS.Record_General(lu_name_, 'RENFROMONLY: <Renamed To Part No> and <Renamed To Serial No> may not contain values when specifying values for <Renamed From Part No> and <Renamed From Serial No>, rename not allowed.');
            END IF;

            Check_Rename___(newrec_.renamed_from_part_no,
                            newrec_.renamed_from_serial_no,
                            newrec_.part_no,
                            newrec_.serial_no);
         END IF;
      END IF;
   ELSE
      IF (newrec_.renamed_to_part_no IS NOT NULL) OR (newrec_.renamed_to_serial_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RENTOASNEW: <Renamed To Part No> and <Renamed To Serial No> may not contain values when creating a new Serial as Renamed.');
      END IF;
   END IF;

   IF (nvl(newrec_.superior_part_no,dummy_value_) != nvl(oldrec_.superior_part_no,dummy_value_)  )
     OR (nvl(newrec_.superior_serial_no,dummy_value_) != nvl(oldrec_.superior_serial_no,dummy_value_) ) THEN
      IF (newrec_.superior_part_no IS NOT NULL) AND (newrec_.superior_serial_no IS NOT NULL) THEN
         Part_Serial_Catalog_API.Exist(newrec_.superior_part_no, newrec_.superior_serial_no);
         Is_structure_allowed___( newrec_.part_no,
                                  newrec_.serial_no,
                                  newrec_.superior_part_no,
                                  newrec_.superior_serial_no);
         Is_Part_Selfcontained___( newrec_.part_no,
                                   newrec_.serial_no,
                                   newrec_.superior_part_no,
                                   newrec_.superior_serial_no);
       END IF;
   END IF;

   IF (NVL(newrec_.condition_code,dummy_value_) != NVL(oldrec_.condition_code,dummy_value_)) THEN
      partca_rec_ := Part_Catalog_API.Get(newrec_.part_no);
      IF (newrec_.condition_code IS NULL) THEN
         IF (partca_rec_.condition_code_usage = 'ALLOW_COND_CODE') THEN
            Error_SYS.Record_General(lu_name_,'COND_MAND: Condition code must have a value.');
         END IF;
      ELSE
         IF (partca_rec_.condition_code_usage = 'NOT_ALLOW_COND_CODE') THEN
            Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
         END IF;

         -- Note: Check if the change in condition code affects manual peggings
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            Purch_Condition_Code_Util_API.Handle_Serial_Condition_Change(newrec_.part_no, newrec_.serial_no); 
         $END
         END IF;
      END IF;

   IF ((    newrec_.part_ownership                    !=     oldrec_.part_ownership                   ) OR
       (NVL(newrec_.owning_vendor_no  , string_null_) != NVL(oldrec_.owning_vendor_no  , string_null_)) OR
       (NVL(newrec_.owning_customer_no, string_null_) != NVL(oldrec_.owning_customer_no, string_null_)) OR
       (NVL(newrec_.superior_part_no  , string_null_) != NVL(oldrec_.superior_part_no  , string_null_)) OR
       (NVL(newrec_.superior_serial_no, string_null_) != NVL(oldrec_.superior_serial_no, string_null_))) THEN

   Check_Part_Ownership___(newrec_.part_ownership,
                           newrec_.owning_vendor_no,
                              newrec_.owning_customer_no,
                              newrec_.part_no,
                              newrec_.serial_no,
                              newrec_.superior_part_no,
                              newrec_.superior_serial_no);
   END IF;

   IF ((oldrec_.ignore_stop_arrival_issued != newrec_.ignore_stop_arrival_issued ) AND
       (newrec_.ignore_stop_arrival_issued = 'TRUE')) THEN
      IF ((oldrec_.rowstate NOT IN ('Issued', 'InFacility')) OR
          (Part_Catalog_API.Get_Stop_Arr_Issued_Serial_Db(oldrec_.part_no) = 'FALSE')) THEN
         Error_SYS.Record_General(lu_name_, 'NOIGNORE: Ignore Stop PO Arrivals of Issued is allowed to set checked only if the serial is issued and Stop PO Arrivals of Issued Serials is checked in Part Catalog.');
      END IF;
   END IF;
   IF ((newrec_.rename_reason        IS     NULL)  AND
       (oldrec_.renamed_to_serial_no IS     NULL)  AND
       (newrec_.renamed_to_serial_no IS NOT NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'REREISNULL: It is not possible to rename a serial without giving a rename reason.');
   END IF;
   
   IF ((newrec_.operational_condition != oldrec_.operational_condition) AND (NOT reversing_op_condition_)) THEN
      Check_Op_Cond_Transition___(newrec_.part_no, newrec_.serial_no, newrec_.operational_status, oldrec_.operational_condition, newrec_.operational_condition);
   END IF;

   -- do additional validation
   Validate_Items___ (newrec_);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;
   
   
@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     part_serial_catalog_tab%ROWTYPE,
   newrec_ IN OUT part_serial_catalog_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2)
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
  
   IF (newrec_.part_ownership NOT IN (Part_Ownership_API.DB_COMPANY_RENTAL_ASSET, Part_Ownership_API.DB_SUPPLIER_RENTED) AND
      (newrec_.fa_object_id IS NOT NULL) AND (newrec_.rowstate  = 'InInventory')) THEN
      Error_SYS.Record_General(lu_name_, 'RECEIVEWITHFALINK: Only part serials with ownership Company Rental Asset can be connected to an FA Object. Please disconnect the FA Object manually before changing ownership and make the required changes to the FA Object in Fixed Assets.');
   END IF;

   IF (Validate_SYS.Is_Changed(oldrec_.manufacturer_no, newrec_.manufacturer_no) OR 
       Validate_SYS.Is_Changed(oldrec_.manu_part_no, newrec_.manu_part_no)       OR 
       Validate_SYS.Is_Changed(oldrec_.manufacturer_serial_no, newrec_.manufacturer_serial_no)) THEN
      IF Manufacturer_Serial_Exists___(newrec_.manufacturer_no, newrec_.manu_part_no, newrec_.manufacturer_serial_no) THEN
         Error_SYS.Record_General(lu_name_, 'MANUFSERIALININV: Manufacturer Serial No :P1 of Manufacturer No :P2 and Manufacturer Part No :P3 is already in use .', newrec_.manufacturer_serial_no, newrec_.manufacturer_no, newrec_.manu_part_no);
      END IF;
   END IF;
END Check_Common___;


FUNCTION Is_Last_In_Rename_Chain___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   last_serial_ BOOLEAN := FALSE;
   CURSOR check_last IS
      SELECT 1
      FROM  part_serial_catalog_tab
      WHERE part_no   = part_no_
      AND   serial_no = serial_no_
      AND   renamed_to_serial_no IS NULL
      AND   renamed_from_serial_no IS NOT NULL
      AND   renamed_from_part_no IS NOT NULL;
BEGIN
   OPEN check_last;
   FETCH check_last INTO dummy_;
   CLOSE check_last;
   
   IF (dummy_ = 1) THEN
      last_serial_ := TRUE;   
   END IF;
   RETURN  last_serial_;  
END Is_Last_In_Rename_Chain___;


FUNCTION Validate_Eng_Part_Revision___(
   part_no_             IN VARCHAR2,
   eng_part_revision_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   eng_revision_exists_ BOOLEAN := FALSE;
BEGIN
   IF eng_part_revision_ IS NOT NULL THEN
      $IF Component_Pdmcon_SYS.INSTALLED $THEN
         eng_revision_exists_:=  Eng_Part_Revision_API.Exists(part_no_, eng_part_revision_);
      $ELSE
         -- PDMCON Component not installed.
         NULL;
      $END
   END IF;
   RETURN eng_revision_exists_;
END Validate_Eng_Part_Revision___;


FUNCTION Manufacturer_Serial_Exists___ (
   manufacturer_no_        IN VARCHAR2,
   manufacturer_part_no_   IN VARCHAR2,
   manufacturer_serial_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_Manuf_Serial_No IS
      SELECT 1
      FROM   part_serial_catalog_tab
      WHERE  manufacturer_no = manufacturer_no_
      AND    manu_part_no = manufacturer_part_no_
      AND    manufacturer_serial_no = manufacturer_serial_no_;
BEGIN
   IF (manufacturer_no_ IS NULL OR manufacturer_part_no_ IS NULL OR manufacturer_serial_no_ IS NULL) THEN
      RETURN FALSE;       
   END IF;
   
   OPEN exist_Manuf_Serial_No;
   FETCH exist_Manuf_Serial_No INTO dummy_;
   IF (exist_Manuf_Serial_No%FOUND) THEN
      CLOSE exist_Manuf_Serial_No;
      RETURN TRUE;
   END IF;
   CLOSE exist_Manuf_Serial_No;
   RETURN FALSE;
END Manufacturer_Serial_Exists___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ part_serial_catalog_tab%ROWTYPE;
BEGIN

   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
   ELSE
      remrec_ := Lock_By_Id___(objid_, objversion_);
   END IF;      

   IF ((remrec_.operational_status != 'RENAMED') OR (remrec_.renamed_to_part_no IS NULL)) THEN
      Error_SYS.Record_General(lu_name_, 'NOTRENAMEDREMOVE: It is only allowed to remove a serial that has been renamed.');
   END IF;

   IF (remrec_.renamed_from_part_no IS NOT NULL) THEN
      IF (NOT Is_Last_In_Rename_Chain___(remrec_.renamed_from_part_no, remrec_.renamed_from_serial_no)) THEN
         Error_SYS.Record_General(lu_name_, 'NOTFIRST: It is only allowed to remove a serial which is in the start of a rename chain.');
      END IF;   
   END IF;
   
   IF NOT ((remrec_.rename_reason = 'CORRECT TYPING ERROR') OR ((remrec_.renamed_from_serial_no = remrec_.renamed_to_serial_no) AND
                                                                (remrec_.renamed_from_part_no   = remrec_.renamed_to_part_no))) THEN
      Error_SYS.Record_General(lu_name_, 'NOTTYPING: You are only allowed to remove a serial which was renamed to correct typing errors or renamed back to its earlier ID.');
   END IF;

   super(info_, objid_, objversion_, action_);
END Remove__;


-- Set_Locked_For_Update__
--   Set locked_for_update for a serial to 'Locked'
--   If the parameter update_strucure is 'TRUE' all the children of the serial
--   will also be updated.
PROCEDURE Set_Locked_For_Update__ (
   part_no_              IN VARCHAR2,
   serial_no_            IN VARCHAR2,
   update_structure_     IN VARCHAR2 )
IS
   update_struct_ BOOLEAN := FALSE;
BEGIN
   IF (update_structure_ = 'TRUE') THEN
      update_struct_ := TRUE;
   END IF;
   Set_Locked_For_Update(part_no_, serial_no_, update_struct_);
END Set_Locked_For_Update__;


PROCEDURE Set_Not_Locked_For_Update__ (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN VARCHAR2 )
IS
   update_struct_ BOOLEAN := FALSE;
BEGIN
   IF (update_structure_ = 'TRUE') THEN
      update_struct_ := TRUE;
   END IF;
   Set_Not_Locked_For_Update(part_no_, serial_no_, update_struct_);
END Set_Not_Locked_For_Update__;


-- Set_Operational__
--   Set operational_condition to 'Operational'
--   If the parameter update_strucure is 'TRUE' all the children of the serial
--   will also be updated.
PROCEDURE Set_Operational__ (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN VARCHAR2 )
IS
   update_struct_ BOOLEAN := FALSE;
BEGIN
   IF (update_structure_ = 'TRUE') THEN
      update_struct_ := TRUE;
   END IF;
   Set_Operational(part_no_, serial_no_, update_struct_);
END Set_Operational__;


-- Set_Non_Operational__
--   Set operational condition to 'Non Operational'
--   If the parameter update_strucure is 'TRUE' all the children of the serial
--   will also be updated.
PROCEDURE Set_Non_Operational__ (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN VARCHAR2 )
IS
   update_struct_ BOOLEAN := FALSE;
BEGIN
   IF (update_structure_ = 'TRUE') THEN
      update_struct_ := TRUE;
   END IF;
   Set_Non_Operational(part_no_, serial_no_, update_struct_);
END Set_Non_Operational__;


-- Set_Out_Of_Operation__
--   Set the operational_status for a serial to 'Out of Operation'
--   If the parameter update_strucure is 'TRUE' all the children of the serial
--   will also be updated.
PROCEDURE Set_Out_Of_Operation__ (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN VARCHAR2 )
IS
   update_struct_ BOOLEAN := FALSE;
BEGIN
   IF (update_structure_ = 'TRUE') THEN
      update_struct_ := TRUE;
   END IF;
   Set_Out_Of_Operation(part_no_, serial_no_, update_struct_);
END Set_Out_Of_Operation__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Remove
--   Removes a serial and connected history.
PROCEDURE Remove (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   force_removal_ IN BOOLEAN DEFAULT FALSE)
IS
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;
   remrec_     part_serial_catalog_tab%ROWTYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);
   remrec_ := Lock_By_Id___ (objid_, objversion_);
   Check_Delete___(remrec_, force_removal_);
   Delete___(objid_, remrec_);
END Remove;


-- Check_Exist
--   Checks if the serial exist in part serial catalog
@UncheckedAccess
FUNCTION Check_Exist (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(part_no_, serial_no_ )) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- Check_Valid_Serial_For_Part
--   Checks if Serial No is valid
PROCEDURE Check_Valid_Serial_For_Part (
   part_no_      IN VARCHAR2,
   serial_no_    IN VARCHAR2 )
IS
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   IF (serial_no_ != '*') THEN
      part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
      IF (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.DB_TRUE) THEN
         Exist(part_no_, serial_no_);
      ELSE
         Error_SYS.Record_General(lu_name_, 'SERIALTRACKEDMUSTBESTAR: This Part is not Serial Tracked so Serial No must be :P1.', '*');
      END IF;
   END IF;

END Check_Valid_Serial_For_Part;


-- Modify
--   Modifies attributes for a serial
PROCEDURE Modify (
   attr_      IN OUT VARCHAR2,
   part_no_   IN     VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);
   Modify__( info_, objid_, objversion_, attr_, 'DO' );
END Modify;


-- Modify_Note_Text
--   Modifies the actual note.
PROCEDURE Modify_Note_Text (
   part_no_        IN VARCHAR2,
   serial_no_      IN VARCHAR2,
   reported_user_  IN VARCHAR2,
   note_text_      IN VARCHAR2 )
IS
   newrec_          part_serial_catalog_tab%ROWTYPE;
BEGIN
   IF (note_text_ IS NOT NULL) THEN
      newrec_ := Lock_By_Keys___(part_no_, serial_no_);
      newrec_.note_text := SUBSTR(NVL(reported_user_, Fnd_Session_API.Get_Fnd_User) || ' ' || 
                                  TO_CHAR(SYSDATE, 'YYYY-MM-DD HH:MI:SS AM') || ' : ' || 
                                  note_text_ || CHR(13) || CHR(10) || newrec_.note_text, 1, 2000);
      Modify___(newrec_);
   END IF;
END Modify_Note_Text;


-- Remove_Superior_Info
--   Removes superior references to actual serial.
PROCEDURE Remove_Superior_Info (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   new_current_position_    IN VARCHAR2 DEFAULT NULL,
   transaction_description_ IN VARCHAR2 DEFAULT NULL,
   order_type_              IN VARCHAR2 DEFAULT NULL,
   order_no_                IN VARCHAR2 DEFAULT NULL,
   line_no_                 IN VARCHAR2 DEFAULT NULL,
   release_no_              IN VARCHAR2 DEFAULT NULL,
   line_item_no_            IN NUMBER   DEFAULT NULL )
IS
   oldrec_             part_serial_catalog_tab%ROWTYPE;
   newrec_             part_serial_catalog_tab%ROWTYPE;
   serial_message_     VARCHAR2(200);
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   oldrec_ := newrec_;
   newrec_.superior_part_no            := TO_CHAR(NULL);
   newrec_.superior_serial_no          := TO_CHAR(NULL);
   Modify___(newrec_);

   IF (new_current_position_ IS NOT NULL) AND (Is_Contained(part_no_, serial_no_) = 'TRUE') THEN
       serial_message_ := NVL(transaction_description_,
                             Language_SYS.Translate_Constant(lu_name_, 'SUP_INFO_REMOVED: Disconnected from superior part :P1 and superior serial no :P2',
                                                             NULL, oldrec_.superior_part_no, oldrec_.superior_serial_no));
      IF (new_current_position_ = 'Issued') THEN
         Move_To_Issued(part_no_, serial_no_, serial_message_, serial_message_, NULL ,order_type_, order_no_, line_no_, release_no_, line_item_no_ );
      ELSIF (new_current_position_ = 'InRepairWorkshop') THEN
         Move_To_Workshop(part_no_, serial_no_, serial_message_, serial_message_);
      ELSIF (new_current_position_ = 'InFacility') THEN
         Move_To_Facility(part_no_, serial_no_, serial_message_, serial_message_);
      ELSIF (new_current_position_ = 'Unlocated') THEN
         Move_To_Unlocated___(part_no_, serial_no_, serial_message_, NULL, NULL, NULL, NULL, NULL, NULL);
      ELSIF (new_current_position_ = 'InInventory') THEN
         Move_To_Inventory(part_no_, serial_no_, serial_message_, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
      ELSIF (new_current_position_ = 'UnderTransportation') THEN
         Move_To_Transport(part_no_, serial_no_, serial_message_, NULL, NULL, NULL, NULL, NULL, NULL);
      ELSIF (new_current_position_ = 'ReturnToSupplier') THEN
         Return_To_Supplier(part_no_, serial_no_, serial_message_, NULL, NULL, NULL, NULL, NULL, NULL);
      ELSE
         Error_SYS.Record_General(lu_name_, 'STATETRANSNOTSUPP: State transition from to <:P1> not supported for serial no :P2', new_current_position_, serial_no_);
      END IF;
   END IF;
   IF (new_current_position_ IS NOT NULL) AND  (Is_In_Facility(part_no_,serial_no_) = 'TRUE') AND (oldrec_.superior_part_no IS NULL) THEN
      IF (new_current_position_ = 'InFacility') AND (transaction_description_ IS NOT NULL) THEN
          Modify_Latest_Transaction(part_no_,serial_no_,transaction_description_,transaction_description_,
                                    history_purpose_db_ => 'CHG_CURRENT_POSITION',
                                    order_type_         => NULL,
                                    order_no_           => NULL,
                                    line_no_            => NULL,
                                    release_no_         => NULL,
                                    line_item_no_       => NULL,
                                    inv_transaction_id_ => NULL);
      END IF;
   END IF;
END Remove_Superior_Info;


-- Modify_Serial_Structure
--   Updates the serial structure when the serial is moved.
PROCEDURE Modify_Serial_Structure (
   part_no_                     IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   superior_part_no_            IN VARCHAR2,
   superior_serial_no_          IN VARCHAR2,
   transaction_description_     IN VARCHAR2,
   allow_shipped_to_supplier_   IN BOOLEAN  DEFAULT FALSE )
IS
   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.superior_part_no   := superior_part_no_;
   newrec_.superior_serial_no := superior_serial_no_;
   newrec_.latest_transaction := transaction_description_;
  
   IF ( NOT allow_shipped_to_supplier_ ) THEN
      IF (Shipped_To_Supplier___(part_no_, serial_no_)) THEN
         Error_Sys.Record_General(lu_name_, 'SERIALNOINSTALL: The serial number :P1 for part :P2 is issued and shipped to a supplier and cannot be installed.', serial_no_, part_no_);
      END IF;
   END IF;
   Modify___(newrec_);
   
   -- IF the part is connected to a superior serial no and the state is not 'Contained' then
   -- set the state to 'Contained'
   IF (superior_serial_no_ IS NOT NULL) AND (Is_Contained(part_no_, serial_no_) = 'FALSE') THEN
      Move_To_Contained(part_no_, serial_no_, transaction_description_, transaction_description_);
   ELSE
      Part_Serial_History_API.New(part_no_, serial_no_, 'INFO', transaction_description_);
   END IF;
END Modify_Serial_Structure;


-- Get_Max_Part_Serial_No
--   This function returns the highest existing serial_no for a
--   specific part_no. The function should only be used for such parts
--   that should have strictly numerical serial numbers. So the serial
--   numbers are handled as numbers when searching for max serial no.
--   So if we for example have the two serial numbers '22' and '111' then
--   the string '111' is regarded as max and returned from the function.
@UncheckedAccess
FUNCTION Get_Max_Part_Serial_No (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   max_part_serial_no_ part_serial_catalog_tab.serial_no%TYPE;
   
   CURSOR Get_Max_Numeric_Serial_No IS
      SELECT serial_no
        FROM part_serial_catalog_tab
       WHERE part_no = part_no_
         AND TO_NUMBER(serial_no) = ( SELECT MAX(TO_NUMBER(serial_no))
                                      FROM   part_serial_catalog_tab
                                      WHERE  part_no = part_no_);
   
   CURSOR Get_Max_Part_Serial_No IS
      SELECT serial_no
        FROM part_serial_catalog_tab
       WHERE part_no   = part_no_
         AND (LPAD(LTRIM(serial_no,'0'),20)) = ( SELECT MAX(LPAD(LTRIM(serial_no,'0'),20))
                                                 FROM part_serial_catalog_tab
                                                 WHERE part_no = part_no_ );
BEGIN
   OPEN Get_Max_Numeric_Serial_No;
   FETCH Get_Max_Numeric_Serial_No INTO max_part_serial_no_;
   CLOSE Get_Max_Numeric_Serial_No;
   RETURN max_part_serial_no_;
EXCEPTION
   WHEN OTHERS THEN
      OPEN Get_Max_Part_Serial_No;
      FETCH Get_Max_Part_Serial_No INTO max_part_serial_no_;
      CLOSE Get_Max_Part_Serial_No;
      RETURN max_part_serial_no_;
END Get_Max_Part_Serial_No;


-- Get_Top_Parent_State
--   If a serial part is has a parent then return the state for the
--   topmost object in the structure. If the part does not have a parent
--   the return value will be NULL
@UncheckedAccess
FUNCTION Get_Top_Parent_State (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_            VARCHAR2(253):=NULL;
   top_part_no_      part_serial_catalog_tab.part_no%TYPE;
   top_serial_no_    part_serial_catalog_tab.serial_no%TYPE;

   CURSOR get_state IS
      SELECT state
      FROM   part_serial_catalog
      WHERE  part_no   = top_part_no_
      AND    serial_no = top_serial_no_;

BEGIN
   Get_Top_Parent(top_part_no_,
                  top_serial_no_,
                  part_no_,
                  serial_no_);

   IF (top_part_no_ IS NOT NULL) AND (top_serial_no_ IS NOT NULL) THEN
      OPEN  get_state;
      FETCH get_state INTO state_;
      CLOSE get_state;
   END IF;
   RETURN state_;
END Get_Top_Parent_State;


-- Set_Cust_Warranty
--   Sets Cust_warranty on the serial part. Checks if a Cust_Warranty exists, then inherits.
PROCEDURE Set_Cust_Warranty (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   cust_warranty_id_ IN NUMBER )
IS
   newrec_        part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.cust_warranty_id := cust_warranty_id_;
   Modify___(newrec_);

   -- check whether Cust_Warranty exists
   $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      Cust_Warranty_API.Inherit(cust_warranty_id_);
   $END
END Set_Cust_Warranty;


-- Set_Sup_Warranty
--   Set sup_warranty on the serial part. Inherits from Sup_Warranty. Calculate dates for warranty.
PROCEDURE Set_Sup_Warranty (
   part_no_         IN VARCHAR2,
   serial_no_       IN VARCHAR2,
   sup_warranty_id_ IN NUMBER,
   arrival_date_    IN DATE DEFAULT SYSDATE )
IS
   newrec_           part_serial_catalog_tab%ROWTYPE;
   state_            VARCHAR2(30);
   cust_warranty_id_ NUMBER;
BEGIN
   -- Set sup_warranty on the serial part.
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.sup_warranty_id := sup_warranty_id_;
   Modify___(newrec_);

   -- Call Sup_Warranty_API.Inherit
   $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      Sup_Warranty_API.Inherit(sup_warranty_id_);
   $END

   state_ := Get_Objstate(part_no_, serial_no_);

   IF ( state_ IN ('InInventory', 'Issued')) THEN

      -- Convert to customer warranty
      cust_warranty_id_ := Get_Cust_Warranty_Id(part_no_, serial_no_);
      $IF (Component_Mpccom_SYS.INSTALLED) $THEN
         Sup_Warranty_Type_API.Convert_To_Cust_Warranty(sup_warranty_id_, cust_warranty_id_);
      $END

      --Set customer warranty on the serial part
      IF cust_warranty_id_ IS NOT NULL THEN
         Set_Cust_Warranty(part_no_, serial_no_, cust_warranty_id_);
      END IF;

      $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      -- Calculate dates for the customer warranty
         Cust_Warranty_Type_API.Warranty_Dates_At_Arrival(part_no_, serial_no_, cust_warranty_id_, sup_warranty_id_, arrival_date_);
      -- Calculate dates for the supplier warranty
         Sup_Warranty_Type_API.Warranty_Dates_At_Arrival(part_no_, serial_no_, sup_warranty_id_, arrival_date_);
      $END     
      END IF;
END Set_Sup_Warranty;


-- Set_Or_Merge_Cust_Warranty
--   This procedure will check if a cust_warranty exists on PartSerialCatalog
--   IF NOT: set the cust_warranty from customer order line (in parameter warranty_id
--   IF it exist: it will merge the warrantys. If the types are equal, the type from
--   the cust warranty on PartSerialCatalog will be deleted and the type from COL will
--   replace it. IF the cust warranty on PartSerialCatalog is inherited
--   a new warranty_id must be created
PROCEDURE Set_Or_Merge_Cust_Warranty (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   cust_warranty_id_ IN NUMBER )
IS
   serial_cust_warranty_id_ NUMBER;
BEGIN
   serial_cust_warranty_id_ := Get_Cust_Warranty_Id(part_no_, serial_no_);
   IF (serial_cust_warranty_id_ IS NULL) THEN
      Set_Cust_Warranty(part_no_, serial_no_, cust_warranty_id_);
   ELSE
      $IF (Component_Mpccom_SYS.INSTALLED) $THEN
         Cust_Warranty_API.Merge(part_no_, serial_no_, cust_warranty_id_, serial_cust_warranty_id_);
      $ELSE
         NULL;
      $END
      END IF;
END Set_Or_Merge_Cust_Warranty;


-- Get_Children_And_Calculate
--   Calculate warranty date for children.
PROCEDURE Get_Children_And_Calculate (
   part_no_       IN VARCHAR2,
   serial_no_     IN VARCHAR2,
   delivery_date_ IN DATE )
IS
   CURSOR get_childs IS
      SELECT part_no, serial_no
      FROM part_serial_catalog_tab
      WHERE superior_part_no = part_no_
      AND superior_serial_no = serial_no_;
BEGIN
   FOR child_ IN get_childs LOOP
      Serial_Warranty_Dates_API.Calculate_Warranty_Dates(child_.part_no, child_.serial_no, delivery_date_);
   END LOOP;
END Get_Children_And_Calculate;


PROCEDURE New_In_Contained (
   part_no_                     IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   latest_transaction_          IN VARCHAR2,
   transaction_description_     IN VARCHAR2,
   superior_part_no_            IN VARCHAR2,
   superior_serial_no_          IN VARCHAR2,
   serial_revision_             IN VARCHAR2,
   note_text_                   IN VARCHAR2,
   warranty_expires_            IN DATE,
   supplier_no_                 IN VARCHAR2,
   manufacturer_no_             IN VARCHAR2,
   operational_status_db_       IN VARCHAR2 DEFAULT 'IN_OPERATION',
   acquisition_cost_            IN NUMBER DEFAULT NULL,
   installation_date_           IN DATE DEFAULT NULL,
   manufactured_date_           IN DATE DEFAULT NULL,
   purchased_date_              IN DATE DEFAULT NULL,
   ownership_db_                IN VARCHAR2 DEFAULT NULL,
   owning_customer_             IN VARCHAR2 DEFAULT NULL,
   owning_vendor_no_            IN VARCHAR2 DEFAULT NULL )
IS
   serial_event_           VARCHAR2(30) := 'NewInContained';
   newrec_                 part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_.part_no               := part_no_;
   newrec_.serial_no             := serial_no_;
   newrec_.latest_transaction    := latest_transaction_;
   newrec_.operational_condition := Serial_Operational_Cond_API.DB_OPERATIONAL;
   newrec_.locked_for_update     := Serial_Part_Locked_API.DB_NOT_LOCKED;
   newrec_.operational_status    := operational_status_db_;
   newrec_.superior_part_no      := superior_part_no_;
   newrec_.superior_serial_no    := superior_serial_no_; 
   newrec_.serial_revision             := serial_revision_;
   newrec_.note_text                   := note_text_;
   newrec_.warranty_expires            := warranty_expires_;
   newrec_.supplier_no                 := supplier_no_;
   newrec_.manufacturer_no             := manufacturer_no_;
   newrec_.acquisition_cost            := acquisition_cost_;
   newrec_.installation_date           := installation_date_;
   newrec_.manufactured_date           := manufactured_date_;
   newrec_.purchased_date              := purchased_date_;
   newrec_.part_ownership              := ownership_db_;
   newrec_.owning_customer_no          := owning_customer_;
   newrec_.owning_vendor_no            := owning_vendor_no_;
   newrec_.configuration_id            := '*';

   New___ (newrec_, serial_event_);
   Check_Dimension_Dependency___(part_no_, serial_no_);
   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_                  => part_no_,
                               serial_no_                => serial_no_,
                               history_purpose_db_       => 'INFO',
                               transaction_description_  => transaction_description_,
                               manufacturer_no_          => manufacturer_no_ );
END New_In_Contained;


-- New_In_Facility
--   Create a new record with initial rowstate = 'InFacility'
PROCEDURE New_In_Facility (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   latest_transaction_      IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   eng_part_revision_       IN VARCHAR2,
   note_text_               IN VARCHAR2,
   warranty_expires_        IN DATE,
   supplier_no_             IN VARCHAR2,
   manufacturer_no_         IN VARCHAR2,
   manu_part_no_            IN VARCHAR2 DEFAULT NULL,
   owner_id_                IN VARCHAR2 DEFAULT NULL,
   operational_status_db_   IN VARCHAR2 DEFAULT 'IN_OPERATION',
   acquisition_cost_        IN NUMBER DEFAULT NULL,
   installation_date_       IN DATE DEFAULT NULL,
   manufactured_date_       IN DATE DEFAULT NULL,
   purchased_date_          IN DATE DEFAULT NULL,
   operational_cond_db_     IN VARCHAR2 DEFAULT 'OPERATIONAL',
   ownership_db_            IN VARCHAR2 DEFAULT NULL,
   owning_customer_         IN VARCHAR2 DEFAULT NULL,
   serial_revision_         IN VARCHAR2 DEFAULT NULL,
   owning_vendor_no_        IN VARCHAR2  DEFAULT NULL )
IS
   serial_event_           VARCHAR2(30) := 'NewInFacility';
   newrec_                 part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_.part_no               := part_no_;
   newrec_.serial_no             := serial_no_;
   newrec_.latest_transaction    := latest_transaction_;
   newrec_.operational_condition := operational_cond_db_;
   newrec_.locked_for_update     := Serial_Part_Locked_API.DB_NOT_LOCKED;
   newrec_.operational_status    := operational_status_db_;
   newrec_.eng_part_revision     := eng_part_revision_;
   newrec_.note_text             := note_text_;
   newrec_.warranty_expires      := warranty_expires_;
   newrec_.supplier_no           := supplier_no_;
   newrec_.manufacturer_no       := manufacturer_no_;
   newrec_.manu_part_no          := manu_part_no_;
   newrec_.owner_id              := owner_id_;
   newrec_.acquisition_cost      := acquisition_cost_;
   newrec_.installation_date     := installation_date_;
   newrec_.manufactured_date     := manufactured_date_;
   newrec_.purchased_date        := purchased_date_;
   newrec_.part_ownership        := ownership_db_;
   newrec_.owning_customer_no    := owning_customer_;
   newrec_.owning_vendor_no      := owning_vendor_no_;
   newrec_.serial_revision       := serial_revision_;
   New___ (newrec_, serial_event_);

   Check_Dimension_Dependency___(part_no_, serial_no_);
   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_                  => part_no_,
                               serial_no_                => serial_no_,
                               history_purpose_db_       => 'INFO',
                               transaction_description_  => transaction_description_,
                               manufacturer_no_          => manufacturer_no_,
                               manufacturer_part_no_     => manu_part_no_ );
END New_In_Facility;


-- New_In_Inventory
--   Create a new record with initial rowstate = 'InInventory'
PROCEDURE New_In_Inventory (
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   transaction_description_   IN VARCHAR2,
   note_text_                 IN VARCHAR2,
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   release_no_                IN VARCHAR2,
   line_item_no_              IN NUMBER,
   order_type_                IN VARCHAR2,
   inv_transaction_id_        IN NUMBER,
   supplier_no_               IN VARCHAR2,
   manufacturer_no_           IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   operational_status_db_     IN VARCHAR2 DEFAULT 'NOT_APPLICABLE',
   lot_batch_no_              IN VARCHAR2 DEFAULT Null,
   condition_code_            IN VARCHAR2 DEFAULT Null,
   part_ownership_            IN VARCHAR2,
   owning_vendor_no_          IN VARCHAR2 DEFAULT Null,
   owning_customer_no_        IN VARCHAR2 DEFAULT Null,
   acquisition_cost_          IN NUMBER   DEFAULT Null,
   purchased_date_            IN DATE     DEFAULT Null,
   manu_part_no_              IN VARCHAR2 DEFAULT NULL,
   eng_part_revision_         IN VARCHAR2 DEFAULT NULL,
   manufactured_date_         IN DATE     DEFAULT NULL, 
   operational_condition_db_  IN VARCHAR2 DEFAULT 'NOT_APPLICABLE',
   buyer_code_                IN VARCHAR2 DEFAULT NULL,
   currency_code_             IN VARCHAR2 DEFAULT NULL )
IS
   serial_event_        VARCHAR2(30) := 'NewInInventory';
   newrec_              part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_.part_no               := part_no_;
   newrec_.serial_no             := serial_no_;
   newrec_.latest_transaction    := transaction_description_;
   newrec_.note_text             := note_text_;
   newrec_.supplier_no           := supplier_no_;
   newrec_.manufacturer_no       := manufacturer_no_;
   newrec_.operational_condition := NVL(operational_condition_db_, Serial_Operational_Cond_API.DB_NOT_APPLICABLE);
   newrec_.locked_for_update     := Serial_Part_Locked_API.DB_NOT_LOCKED;
   newrec_.operational_status    := operational_status_db_;
   newrec_.lot_batch_no          := lot_batch_no_;
   newrec_.condition_code        := condition_code_;
   newrec_.part_ownership        := part_ownership_;
   newrec_.owning_vendor_no      := owning_vendor_no_;
   newrec_.owning_customer_no    := owning_customer_no_;
   newrec_.acquisition_cost      := acquisition_cost_;
   newrec_.purchased_date        := purchased_date_;
   newrec_.configuration_id      := configuration_id_;
   newrec_.manu_part_no          := manu_part_no_;
   IF ( Validate_Eng_Part_Revision___(part_no_, eng_part_revision_)) THEN
      newrec_.eng_part_revision  := eng_part_revision_;
   END IF;
   newrec_.manufactured_date     := manufactured_date_;
   newrec_.buyer                 := buyer_code_;
   newrec_.currency_code         := currency_code_;
   New___ (newrec_, serial_event_, inv_transaction_id_=> inv_transaction_id_);
      
   Check_Dimension_Dependency___(part_no_, serial_no_);
   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_                  => part_no_,
                               serial_no_                => serial_no_,
                               history_purpose_db_       => 'INFO',
                               transaction_description_  => transaction_description_,
                               order_type_               => order_type_,
                               order_no_                 => order_no_,
                               line_no_                  => line_no_,
                               release_no_               => release_no_,
                               line_item_no_             => line_item_no_,
                               inv_transsaction_id_      => inv_transaction_id_,
                               eng_part_revision_        => newrec_.eng_part_revision,
                               manufacturer_no_          => manufacturer_no_,
                               manufacturer_part_no_     => manu_part_no_ );
END New_In_Inventory;


-- New_In_Issued
--   Create a new record with initial rowstate = 'Issued'
PROCEDURE New_In_Issued (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   latest_transaction_      IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   serial_revision_         IN VARCHAR2,
   note_text_               IN VARCHAR2,
   warranty_expires_        IN DATE,
   superior_part_no_        IN VARCHAR2,
   superior_serial_no_      IN VARCHAR2,
   supplier_no_             IN VARCHAR2,
   manufacturer_no_         IN VARCHAR2,
   operational_status_db_   IN VARCHAR2 DEFAULT 'NOT_APPLICABLE',
   configuration_id_        IN VARCHAR2 DEFAULT '*',
   lot_batch_no_            IN VARCHAR2 DEFAULT NULL,
   order_no_                IN VARCHAR2 DEFAULT NULL,
   line_no_                 IN VARCHAR2 DEFAULT NULL,
   release_no_              IN VARCHAR2 DEFAULT NULL,
   line_item_no_            IN NUMBER   DEFAULT NULL,
   order_type_              IN VARCHAR2 DEFAULT NULL,
   condition_code_          IN VARCHAR2 DEFAULT NULL,
   inv_transsaction_id_     IN NUMBER   DEFAULT NULL )
IS
   serial_event_       VARCHAR2(30) := 'NewInIssued';
   newrec_             part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_.part_no               := part_no_;
   newrec_.serial_no             := serial_no_;
   newrec_.latest_transaction    := latest_transaction_;
   newrec_.serial_revision       := serial_revision_;
   newrec_.note_text             := note_text_;
   newrec_.warranty_expires      := warranty_expires_;
   newrec_.supplier_no           := supplier_no_;
   newrec_.manufacturer_no       := manufacturer_no_;
   newrec_.operational_condition := Serial_Operational_Cond_API.DB_OPERATIONAL;
   newrec_.locked_for_update     := Serial_Part_Locked_API.DB_NOT_LOCKED;
   newrec_.operational_status    := operational_status_db_;
   newrec_.configuration_id      := configuration_id_;
   newrec_.lot_batch_no          := lot_batch_no_;
   newrec_.condition_code        := condition_code_;
   New___ (newrec_, serial_event_);

   Check_Dimension_Dependency___(part_no_, serial_no_);
   
   Set_Ownership_After_Issue___(part_no_, serial_no_, order_no_, line_no_, release_no_, line_item_no_, order_type_);

   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_                  => part_no_,
                               serial_no_                => serial_no_,
                               history_purpose_db_       => 'INFO',
                               transaction_description_  => transaction_description_,
                               order_type_               => order_type_,
                               order_no_                 => order_no_,
                               line_no_                  => line_no_,
                               release_no_               => release_no_,
                               line_item_no_             => line_item_no_,
                               manufacturer_no_          => manufacturer_no_,
                               inv_transsaction_id_      => inv_transsaction_id_);

END New_In_Issued;


-- Issue
--   Move a serial from 'InInventory' to 'Issued'
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Issue (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER,
   operational_status_db_   IN VARCHAR2 DEFAULT NULL,
   set_ownership_           IN BOOLEAN  DEFAULT TRUE )
IS
   attr_       VARCHAR2(32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;
   old_rec_    part_serial_catalog_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);
   old_rec_    := Get_Object_By_Keys___(part_no_, serial_no_);
   Issue__(info_, objid_, objversion_, attr_, 'DO');

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_,
                             serial_no_,
                             transaction_description_,
                             transaction_description_,
                             'CHG_CURRENT_POSITION',
                             order_type_, order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             inv_transaction_id_);

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => order_type_,
                                order_no_              => order_no_,
                                line_no_               => line_no_,
                                release_no_            => release_no_,
                                line_item_no_          => line_item_no_,
                                update_structure_      => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);
   -- Replaced the serial ownership setup logic with Set_Ownership_After_Issue___. 
   IF set_ownership_ THEN
      Set_Ownership_After_Issue___(part_no_, serial_no_, order_no_, line_no_, release_no_, line_item_no_, order_type_);
   END IF;
END Issue;


-- Move_In_Inventory
--   Called when a part is moved from one inventory location to another.
--   Does not change rowstate.
PROCEDURE Move_In_Inventory (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER,
   lot_batch_no_            IN VARCHAR2 )
IS
BEGIN

   Modify_Lot_Batch_No___(part_no_, serial_no_, lot_batch_no_);

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_,
                             serial_no_,
                             transaction_description_,
                             transaction_description_,
                             'INFO',
                             order_type_,
                             order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             inv_transaction_id_);

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_In_Inventory;


-- Move_To_Contained
--   Move a serial to 'Contained' from 'Issued', 'InFacility' or
PROCEDURE Move_To_Contained (
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   latest_transaction_        IN VARCHAR2,
   transaction_description_   IN VARCHAR2,
   operational_status_db_     IN VARCHAR2 DEFAULT NULL,
   operational_condition_db_  IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Move_To_Contained__(info_,  objid_, objversion_, attr_, 'DO');

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_, serial_no_, latest_transaction_, transaction_description_,
                             history_purpose_db_ => 'CHG_CURRENT_POSITION',
                             order_type_         => NULL,
                             order_no_           => NULL,
                             line_no_            => NULL,
                             release_no_         => NULL,
                             line_item_no_       => NULL,
                             inv_transaction_id_ => NULL);

   IF (operational_condition_db_ IS NOT NULL) THEN
      Set_Operational_Condition___ (info_                     => info_,
                                    part_no_                  => part_no_,
                                    serial_no_                => serial_no_,
                                    operational_condition_db_ => operational_condition_db_,
                                    order_type_               => NULL,
                                    order_no_                 => NULL,
                                    line_no_                  => NULL,
                                    release_no_               => NULL,
                                    line_item_no_             => NULL,
                                    update_structure_         => TRUE,
                                    validate_structure_       => TRUE);

   END IF;

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => NULL,
                                order_no_              => NULL,
                                line_no_               => NULL,
                                release_no_            => NULL,
                                line_item_no_          => NULL,
                                update_structure_      => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_To_Contained;


-- Move_To_Facility
--   Move a serial from 'InRepairWorkshop' or 'Issued' to 'InFacility'.
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Move_To_Facility (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   latest_transaction_      IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   operational_status_db_   IN VARCHAR2 DEFAULT NULL,
   operational_condition_db_   IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Move_To_Facility__ (info_,  objid_, objversion_, attr_, 'DO');

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_, serial_no_, latest_transaction_, transaction_description_,
                             history_purpose_db_ => 'CHG_CURRENT_POSITION',
                             order_type_         => NULL,
                             order_no_           => NULL,
                             line_no_            => NULL,
                             release_no_         => NULL,
                             line_item_no_       => NULL,
                             inv_transaction_id_ => NULL);

   IF (operational_condition_db_ IS NOT NULL) THEN
      Set_Operational_Condition___ (info_                     => info_,
                                    part_no_                  => part_no_,
                                    serial_no_                => serial_no_,
                                    operational_condition_db_ => operational_condition_db_,
                                    order_type_               => NULL,
                                    order_no_                 => NULL,
                                    line_no_                  => NULL,
                                    release_no_               => NULL,
                                    line_item_no_             => NULL,
                                    update_structure_         => TRUE,
                                    validate_structure_       => TRUE);
                                    
   END IF;

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => NULL,
                                order_no_              => NULL,
                                line_no_               => NULL,
                                release_no_            => NULL,
                                line_item_no_          => NULL,
                                update_structure_      => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_To_Facility;

-- Move_To_Inventory
--   Move a serial from 'InFacility', 'InRepairWorkshop', UnderTransportation' or
--   'ReturnedToSupplier' to 'InInventory'.
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Move_To_Inventory (
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   transaction_description_   IN VARCHAR2,
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   release_no_                IN VARCHAR2,
   line_item_no_              IN NUMBER,
   order_type_                IN VARCHAR2,
   inv_transaction_id_        IN NUMBER,
   lot_batch_no_              IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   operational_status_db_     IN VARCHAR2 DEFAULT NULL,
   operational_condition_db_  IN VARCHAR2 DEFAULT NULL,
   eng_part_revision_         IN VARCHAR2 DEFAULT NULL)
IS
   attr_                        VARCHAR2 (32000);
   info_                        VARCHAR2(2000);
   objid_                       part_serial_catalog.objid%TYPE;
   objversion_                  part_serial_catalog.objversion%TYPE;
BEGIN

   Check_In_Inventory_Allowed___(part_no_,
                                 serial_no_,
                                 order_no_,
                                 line_no_,
                                 release_no_,
                                 line_item_no_,
                                 order_type_,
                                 inv_transaction_id_);

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Move_To_Inventory__ (info_, objid_, objversion_, attr_, 'DO');

   Modify_Lot_Batch_No___(part_no_, serial_no_, lot_batch_no_);
   
   Modify_Eng_Part_Revision___(part_no_, serial_no_, eng_part_revision_);

   Modify_Configuration_Id___(part_no_, serial_no_, configuration_id_);

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_,
                             serial_no_,
                             transaction_description_,
                             transaction_description_,
                             'CHG_CURRENT_POSITION',
                             order_type_,
                             order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             inv_transaction_id_);

   IF (operational_condition_db_ IS NOT NULL) THEN
      Set_Operational_Condition___(info_                     => info_,
                                   part_no_                  => part_no_,
                                   serial_no_                => serial_no_,
                                   operational_condition_db_ => operational_condition_db_,
                                   order_type_               => order_type_,
                                   order_no_                 => order_no_,
                                   line_no_                  => line_no_,
                                   release_no_               => release_no_,
                                   line_item_no_             => line_item_no_,
                                   update_structure_         => FALSE,
                                   validate_structure_       => TRUE);
   END IF;

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => order_type_,
                                order_no_              => order_no_,
                                line_no_               => line_no_,
                                release_no_            => release_no_,
                                line_item_no_          => line_item_no_,
                                update_structure_      => TRUE);
   END IF;
   
   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_To_Inventory;


-- Move_To_Issued
--   Move a serial from 'InFacility' to 'Issued'.
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Move_To_Issued (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   latest_transaction_      IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   operational_status_db_   IN VARCHAR2 DEFAULT NULL,
   order_type_              IN VARCHAR2 DEFAULT NULL,
   order_no_                IN VARCHAR2 DEFAULT NULL,
   line_no_                 IN VARCHAR2 DEFAULT NULL,
   release_no_              IN VARCHAR2 DEFAULT NULL,
   line_item_no_            IN NUMBER   DEFAULT NULL )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Move_To_Issued__ (info_, objid_, objversion_, attr_, 'DO');

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_, serial_no_, latest_transaction_, transaction_description_,
                             history_purpose_db_ => 'CHG_CURRENT_POSITION',
                             order_type_         => order_type_,
                             order_no_           => order_no_,
                             line_no_            => line_no_,
                             release_no_         => release_no_,
                             line_item_no_       => line_item_no_,
                             inv_transaction_id_ => NULL);

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_                => part_no_,
                                serial_no_              => serial_no_,
                                operational_status_db_  => operational_status_db_,
                                order_type_             => order_type_,
                                order_no_               => order_no_,
                                line_no_                => line_no_,
                                release_no_             => release_no_,
                                line_item_no_           => line_item_no_,
                                update_structure_       => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_To_Issued;


-- Move_To_Transport
--   Move a serial from 'InInventory' to 'UnderTransportation'
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Move_To_Transport (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER,
   operational_status_db_   IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Move_To_Transport__ (info_, objid_, objversion_, attr_, 'DO');

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_,
                             serial_no_,
                             transaction_description_,
                             transaction_description_,
                             'CHG_CURRENT_POSITION',
                             order_type_,
                             order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             inv_transaction_id_);

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => order_type_,
                                order_no_              => order_no_,
                                line_no_               => line_no_,
                                release_no_            => release_no_,
                                line_item_no_          => line_item_no_,
                                update_structure_      => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_To_Transport;


-- Move_To_Workshop
--   Move a serial from 'InFacility' to 'InRepairWorkshop'.
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Move_To_Workshop (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   latest_transaction_      IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   operational_status_db_   IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Move_To_Workshop__ (info_, objid_, objversion_, attr_, 'DO');

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_, serial_no_, latest_transaction_, transaction_description_,
                             history_purpose_db_ => 'CHG_CURRENT_POSITION',
                             order_type_         => NULL,
                             order_no_           => NULL,
                             line_no_            => NULL,
                             release_no_         => NULL,
                             line_item_no_       => NULL,
                             inv_transaction_id_ => NULL);

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => NULL,
                                order_no_              => NULL,
                                line_no_               => NULL,
                                release_no_            => NULL,
                                line_item_no_          => NULL,
                                update_structure_      => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Move_To_Workshop;


-- Return_To_Supplier
--   Move a serial from 'InInventory' to 'ReturnedToSupplier'.
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Return_To_Supplier (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER,
   operational_status_db_   IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;

BEGIN

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);
   IF (Get_State(part_no_, serial_no_ ) != 'ReturnedToSupplier') THEN
      Return_To_Supplier__ (info_, objid_, objversion_, attr_, 'DO');
   END IF;

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_,
                             serial_no_,
                             transaction_description_,
                             transaction_description_,
                             'CHG_CURRENT_POSITION',
                             order_type_,
                             order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             inv_transaction_id_);

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => order_type_,
                                order_no_              => order_no_,
                                line_no_               => line_no_,
                                release_no_            => release_no_,
                                line_item_no_          => line_item_no_,
                                update_structure_      => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Return_To_Supplier;


-- Unissue
--   Move a serial from 'Issued' to 'InInventory'
--   The operational status for the serial may be changed by passing new value
--   in the parameter operational_status_db_.
PROCEDURE Unissue (
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   transaction_description_   IN VARCHAR2,
   order_no_                  IN VARCHAR2,
   line_no_                   IN VARCHAR2,
   release_no_                IN VARCHAR2,
   line_item_no_              IN NUMBER,
   order_type_                IN VARCHAR2,
   inv_transaction_id_        IN NUMBER,
   lot_batch_no_              IN VARCHAR2,
   configuration_id_          IN VARCHAR2,
   operational_status_db_     IN VARCHAR2 DEFAULT NULL,
   operational_condition_db_  IN VARCHAR2 DEFAULT NULL,
   eng_part_revision_         IN VARCHAR2 DEFAULT NULL )
IS
   attr_       VARCHAR2 (32000);
   info_       VARCHAR2(2000);
   objid_      part_serial_catalog.objid%TYPE;
   objversion_ part_serial_catalog.objversion%TYPE;
BEGIN

   Check_In_Inventory_Allowed___(part_no_,
                                 serial_no_,
                                 order_no_,
                                 line_no_,
                                 release_no_,
                                 line_item_no_,
                                 order_type_,
                                 inv_transaction_id_);

   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);

   Unissue__ (info_, objid_, objversion_, attr_, 'DO');

   Modify_Lot_Batch_No___(part_no_, serial_no_, lot_batch_no_);
   Modify_Eng_Part_Revision___(part_no_, serial_no_, eng_part_revision_);

   Modify_Configuration_Id___(part_no_, serial_no_, configuration_id_);

   -- Update the latest transaction attribute and create a record in PartSerialHistory
   Modify_Latest_Transaction(part_no_,
                             serial_no_,
                             transaction_description_,
                             transaction_description_,
                             'CHG_CURRENT_POSITION',
                             order_type_,
                             order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             inv_transaction_id_);

   IF (operational_status_db_ IS NOT NULL) THEN
      -- Change the operational status of the serial (and all it's children)
      Set_Operational_Status___(part_no_               => part_no_,
                                serial_no_             => serial_no_,
                                operational_status_db_ => operational_status_db_,
                                order_type_            => order_type_,
                                order_no_              => order_no_,
                                line_no_               => line_no_,
                                release_no_            => release_no_,
                                line_item_no_          => line_item_no_,
                                update_structure_      => TRUE);
   END IF;
   IF (operational_condition_db_ IS NOT NULL) THEN
      Set_Operational_Condition___(info_                     => info_,
                                   part_no_                  => part_no_,
                                   serial_no_                => serial_no_,
                                   operational_condition_db_ => operational_condition_db_,
                                   order_type_               => order_type_,
                                   order_no_                 => order_no_,
                                   line_no_                  => line_no_,
                                   release_no_               => release_no_,
                                   line_item_no_             => line_item_no_,
                                   update_structure_         => FALSE,
                                   validate_structure_       => TRUE);
   END IF;

   Check_Dimension_Dependency___(part_no_, serial_no_);

END Unissue;


@UncheckedAccess
FUNCTION Is_Contained (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_   VARCHAR2(30);
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);
   IF (state_ = 'Contained') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Contained;


-- Is_In_Facility
--   Return the value 'TRUE if the serial is 'InFacility', if not 'FALSE'
--   is returned.
@UncheckedAccess
FUNCTION Is_In_Facility (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
state_   VARCHAR2(30);
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);
   IF (state_ = 'InFacility') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_In_Facility;


-- Is_In_Inventory
--   Return the value 'TRUE if the serial is 'InInventory', if not 'FALSE'
--   is returned.
@UncheckedAccess
FUNCTION Is_In_Inventory (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_   VARCHAR2(30);
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);
   IF (state_ = 'InInventory') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_In_Inventory;


-- Is_In_Repair_Workshop
--   Return the value 'TRUE if the serial is 'InRepairWorkshop', if not 'FALSE'
--   is returned.
@UncheckedAccess
FUNCTION Is_In_Repair_Workshop (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_   VARCHAR2(30);
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);
   IF (state_ = 'InRepairWorkshop') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_In_Repair_Workshop;


-- Is_Issued
--   Return the value 'TRUE if the serial is 'Issued', if not 'FALSE'
--   is returned.
@UncheckedAccess
FUNCTION Is_Issued (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_   VARCHAR2(30);
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);
   IF (state_ = 'Issued') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Issued;


-- Is_Returned_To_Supplier
--   Return the value 'TRUE if the serial is 'ReturnedToSupplier', if not 'FALSE'
--   is returned.
FUNCTION Is_Returned_To_Supplier (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
state_   VARCHAR2(30);
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);
   IF (state_ = 'ReturnedToSupplier') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Returned_To_Supplier;


@UncheckedAccess
FUNCTION Is_Under_Transportation (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_   VARCHAR2(30);
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);
   IF (state_ = 'UnderTransportation') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Under_Transportation;


-- Set_Operational
--   Set operational_condition to 'Operational'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Operational (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
   info_                VARCHAR2(2000);
   validate_structure_   BOOLEAN := FALSE;
BEGIN
   IF NOT (update_structure_) THEN
      validate_structure_ := TRUE; 
   END IF;
   
   Set_Operational_Condition___(info_,
                                part_no_                  => part_no_,
                                serial_no_                => serial_no_,
                                operational_condition_db_ => 'OPERATIONAL',
                                order_type_               => NULL,
                                order_no_                 => NULL,
                                line_no_                  => NULL,
                                release_no_               => NULL,
                                line_item_no_             => NULL,
                                update_structure_         => update_structure_,
                                validate_structure_       => validate_structure_);
   Check_Dimension_Dependency___(part_no_, serial_no_);
END Set_Operational;


-- Set_Non_Operational
--   Set operational condition to 'Non Operational'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Non_Operational (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN,
   order_type_       IN VARCHAR2 DEFAULT NULL,
   order_no_         IN VARCHAR2 DEFAULT NULL,
   line_no_          IN VARCHAR2 DEFAULT NULL,
   release_no_       IN VARCHAR2 DEFAULT NULL,
   line_item_no_     IN NUMBER   DEFAULT NULL )
IS
   info_          VARCHAR2(2000);
BEGIN
   Set_Operational_Condition___(info_,
                                part_no_                  => part_no_,
                                serial_no_                => serial_no_,
                                operational_condition_db_ => 'NON_OPERATIONAL',
                                order_type_               => order_type_,
                                order_no_                 => order_no_,
                                line_no_                  => line_no_,
                                release_no_               => release_no_,
                                line_item_no_             => line_item_no_,
                                update_structure_         => update_structure_,
                                validate_structure_       => FALSE);
   Check_Dimension_Dependency___(part_no_, serial_no_);
END Set_Non_Operational;


-- Is_Operational
--   Return the string value 'TRUE' if the specified serial object has
--   operational_condition = 'Operational', if not return 'FALSE'
@UncheckedAccess
FUNCTION Is_Operational (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Condition___(part_no_, serial_no_) = 'OPERATIONAL') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Operational;


-- Set_Planned_For_Operation
--   Set the operational_status for a serial to 'Planned for Operation'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Planned_For_Operation (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
BEGIN
   Set_Operational_Status___(part_no_               => part_no_,
                             serial_no_             => serial_no_,
                             operational_status_db_ => 'PLANNED_FOR_OP',
                             order_type_            => NULL,
                             order_no_              => NULL,
                             line_no_               => NULL,
                             release_no_            => NULL,
                             line_item_no_          => NULL,
                             update_structure_      => update_structure_);
   Check_Dimension_Dependency___(part_no_, serial_no_);
END Set_Planned_For_Operation;


-- Set_In_Operation
--   Set the operational_status for a serial to 'In Operation'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_In_Operation (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
BEGIN
   Set_Operational_Status___(part_no_               => part_no_,
                             serial_no_             => serial_no_,
                             operational_status_db_ => 'IN_OPERATION',
                             order_type_            => NULL,
                             order_no_              => NULL,
                             line_no_               => NULL,
                             release_no_            => NULL,
                             line_item_no_          => NULL,
                             update_structure_      => update_structure_);
   Check_Dimension_Dependency___(part_no_, serial_no_);
END Set_In_Operation;


-- Set_Out_Of_Operation
--   Set the operational_status for a serial to 'Out of Operation'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Out_Of_Operation (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
BEGIN
   Set_Operational_Status___(part_no_               => part_no_,
                             serial_no_             => serial_no_,
                             operational_status_db_ => 'OUT_OF_OPERATION',
                             order_type_            => NULL,
                             order_no_              => NULL,
                             line_no_               => NULL,
                             release_no_            => NULL,
                             line_item_no_          => NULL,
                             update_structure_      => update_structure_);
   Check_Dimension_Dependency___(part_no_, serial_no_);
END Set_Out_Of_Operation;


-- Set_Renamed
--   Set the operational_status for a serial to 'Renamed'
--   This method cannot operate on a structure.
PROCEDURE Set_Renamed (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
BEGIN
   Set_Operational_Status___(part_no_               => part_no_,
                             serial_no_             => serial_no_,
                             operational_status_db_ => 'RENAMED',
                             order_type_            => NULL,
                             order_no_              => NULL,
                             line_no_               => NULL,
                             release_no_            => NULL,
                             line_item_no_          => NULL,
                             update_structure_      => FALSE);
   Check_Dimension_Dependency___(part_no_, serial_no_);
END Set_Renamed;


-- Set_Scrapped
--   Set the operational_status for a serial to 'Scrapped'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Scrapped (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
BEGIN
   Set_Scrapped___(part_no_                    => part_no_,
                   serial_no_                  => serial_no_,
                   order_type_                 => NULL,
                   order_no_                   => NULL,
                   line_no_                    => NULL,
                   release_no_                 => NULL,
                   line_item_no_               => NULL,
                   update_structure_           => update_structure_,
                   check_dimension_dependency_ => TRUE);
END Set_Scrapped;


-- Set_Not_Applicable
--   Set the operational_status for a serial to 'Not Applicable'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Not_Applicable (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
BEGIN
   Set_Operational_Status___(part_no_               => part_no_,
                             serial_no_             => serial_no_,
                             operational_status_db_ => 'NOT_APPLICABLE',
                             order_type_            => NULL,
                             order_no_              => NULL,
                             line_no_               => NULL,
                             release_no_            => NULL,
                             line_item_no_          => NULL,
                             update_structure_      => FALSE);
   Check_Dimension_Dependency___(part_no_, serial_no_);
END Set_Not_Applicable;


-- Is_Designed
--   Return the string value 'TRUE' if operational status for the specified
--   serial part = 'Designed', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Designed (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(part_no_, serial_no_) = 'DESIGNED') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Designed;


-- Is_Planned_For_Operation
--   Return the string value 'TRUE' if operational status for the specified
--   serial part = 'Planned for Operation', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Planned_For_Operation (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(part_no_, serial_no_) = 'PLANNED_FOR_OP') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Planned_For_Operation;


-- Is_In_Operation
--   Return the string value 'TRUE' if operational status for the specified
--   serial part = 'In Operation', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_In_Operation (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(part_no_, serial_no_) = 'IN_OPERATION') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_In_Operation;


-- Is_Out_Of_Operation
--   Return the string value 'TRUE' if operational status for the specified
--   serial part = 'Out of Operation', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Out_Of_Operation (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(part_no_, serial_no_) = 'OUT_OF_OPERATION') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Out_Of_Operation;


-- Is_Renamed
--   Return the string value 'TRUE' if operational status for the specified
--   serial part = 'Renamed', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Renamed (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(part_no_, serial_no_) = 'RENAMED') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Renamed;


-- Is_Scrapped
--   Return the string value 'TRUE' if operational status for the specified
--   serial part = 'Scrapped', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Scrapped (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(part_no_, serial_no_) = 'SCRAPPED') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Scrapped;


-- Is_Not_Applicable
--   Return the string value 'TRUE' if operational status for the specified
--   serial part = 'Not Applicable', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Not_Applicable (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Operational_Status___(part_no_, serial_no_) = 'NOT_APPLICABLE') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Not_Applicable;


@Override
@UncheckedAccess
FUNCTION Get_Operational_Status_Db (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_attr IS
      SELECT operational_status
      FROM part_serial_catalog_tab
      WHERE part_no = part_no_
      AND   serial_no = serial_no_;
BEGIN
   RETURN super(part_no_, serial_no_);
END Get_Operational_Status_Db;


-- Scrap
--   Set the operational_status for a serial to 'Scrapped', operational_condition
--   to 'Non Operational' and rowstate to 'Unlocated'.
--   Also creates a new entry in Part Serial History and saves information
--   concerning the latest transaction on the serial object.
PROCEDURE Scrap (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER,
   scrap_at_supplier_       IN BOOLEAN DEFAULT FALSE )
IS
   children_tab_ Serial_Tab;
   old_rec_      part_serial_catalog_tab%ROWTYPE;
BEGIN
   old_rec_    := Get_Object_By_Keys___(part_no_, serial_no_);

   IF (Shipped_To_Supplier___(part_no_, serial_no_)) THEN
      IF NOT (scrap_at_supplier_) THEN
         Error_Sys.Record_General(lu_name_, 'SERIALNOSCRAPPED: The serial number :P1 for part :P2 is issued and shipped to a supplier and cannot be scrapped.', serial_no_, part_no_);
      END IF;
   ELSE
      IF (scrap_at_supplier_) THEN
         Error_Sys.Record_General(lu_name_, 'SCRAPATSUPP: The serial number :P1 for part :P2 is :P3 and can therefore not be scrapped at supplier.', serial_no_, part_no_, Get_State(part_no_, serial_no_));
      END IF;
   END IF;

   IF (inv_transaction_id_ IS NULL) THEN
      IF (Is_In_Inventory(part_no_, serial_no_) = 'TRUE') THEN
         Error_Sys.Record_General(lu_name_, 'SERIALININVENTORY: The serial number :P1 for part :P2 is currently located in inventory and cannot be scrapped.', serial_no_, part_no_);
      END IF;
   END IF;

   Set_Non_Operational(part_no_          => part_no_,
                       serial_no_        => serial_no_,
                       update_structure_ => FALSE,
                       order_type_       => order_type_,
                       order_no_         => order_no_,
                       line_no_          => line_no_,
                       release_no_       => release_no_,
                       line_item_no_     => line_item_no_);

   Set_Scrapped___(part_no_                    => part_no_,
                   serial_no_                  => serial_no_,
                   order_type_                 => order_type_,
                   order_no_                   => order_no_,
                   line_no_                    => line_no_,
                   release_no_                 => release_no_,
                   line_item_no_               => line_item_no_,
                   update_structure_           => FALSE,
                   check_dimension_dependency_ => FALSE);

   Move_To_Unlocated___(part_no_, serial_no_, transaction_description_, order_no_, line_no_,
                        release_no_, line_item_no_, order_type_, inv_transaction_id_);

   children_tab_ := Get_All_Children___(part_no_, serial_no_);

   IF (children_tab_.COUNT > 0) THEN
      FOR i IN children_tab_.FIRST..children_tab_.LAST LOOP
         IF (children_tab_(i).operational_status = 'IN_OPERATION') THEN
            Set_Out_Of_Operation(children_tab_(i).part_no, children_tab_(i).serial_no, FALSE);
         END IF;
         IF (children_tab_(i).operational_condition != Serial_Operational_Cond_API.DB_NON_OPERATIONAL) THEN
            Set_Non_Operational(children_tab_(i).part_no, children_tab_(i).serial_no, FALSE);
         END IF;
         Set_Scrapped___(part_no_                    => children_tab_(i).part_no,
                         serial_no_                  => children_tab_(i).serial_no,
                         order_type_                 => NULL,
                         order_no_                   => NULL,
                         line_no_                    => NULL,
                         release_no_                 => NULL,
                         line_item_no_               => NULL,
                         update_structure_           => FALSE,
                         check_dimension_dependency_ => TRUE);
      END LOOP;
   END IF;
END Scrap;


-- Unscrap
--   Set the operational_status for a serial to 'Not Applicable', operational_condition
--   to 'Operational' and rowstate to 'In Inventory'.
--   Also creates a new entry in Part Serial History and saves information
--   concerning the latest transaction on the serial object.
PROCEDURE Unscrap (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER,
   lot_batch_no_            IN VARCHAR2,
   latest_transaction_      IN VARCHAR2 DEFAULT NULL )
IS
   previous_position_db_ PART_SERIAL_HISTORY_TAB.current_position%TYPE;
   info_          VARCHAR2(2000);
BEGIN
   previous_position_db_ := Get_Previous_Current_Position(part_no_, serial_no_, FALSE);
   IF (previous_position_db_ = 'InInventory') THEN
      Move_To_Inventory(part_no_, serial_no_, transaction_description_,
                        order_no_, line_no_, release_no_, line_item_no_, order_type_,
                        inv_transaction_id_, lot_batch_no_, NULL, 'NOT_APPLICABLE');
   ELSIF (previous_position_db_ = 'Issued') THEN
      Move_To_Issued(part_no_                 => part_no_,
                     serial_no_               => serial_no_,
                     latest_transaction_      => latest_transaction_,
                     transaction_description_ => transaction_description_,
                     operational_status_db_   => 'NOT_APPLICABLE',
                     order_type_              => order_type_,
                     order_no_                => order_no_,
                     line_no_                 => line_no_,
                     release_no_              => release_no_,
                     line_item_no_            => line_item_no_);
   ELSE
      Error_SYS.Record_General(lu_name_, 'INVALIDPPOS: Unscrap is not allowed when previous position of serial part is :P1.', Finite_State_Decode__(previous_position_db_));
   END IF;
 

   -- Set operational status to 'Not Applicable', operational condition to 'Operational'
   Set_Operational_Condition___(info_,
                                part_no_                  => part_no_,
                                serial_no_                => serial_no_,
                                operational_condition_db_ => 'OPERATIONAL',
                                order_type_               => order_type_,
                                order_no_                 => order_no_,
                                line_no_                  => line_no_,
                                release_no_               => release_no_,
                                line_item_no_             => line_item_no_,
                                update_structure_         => TRUE,
                                validate_structure_       => FALSE);
END Unscrap;


-- Set_Locked_For_Update
--   Set locked_for_update for a serial to 'Locked'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Locked_For_Update (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
BEGIN
   Set_Locked_For_Update___(part_no_, serial_no_, 'LOCKED', update_structure_);
END Set_Locked_For_Update;


-- Set_Not_Locked_For_Update
--   Set locked_for_update for a serial to 'Not Locked'
--   If the parameter update_strucure is 'TRUE' all the children of the serial
--   will also be updated.
--   Set locked_for_update for a serial to 'Not Locked'
--   If the parameter update_strucure is TRUE all the children of the serial
--   will also be updated.
PROCEDURE Set_Not_Locked_For_Update (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   update_structure_ IN BOOLEAN )
IS
BEGIN
   Set_Locked_For_Update___(part_no_, serial_no_, 'NOT_LOCKED', update_structure_);
END Set_Not_Locked_For_Update;


-- Is_Locked_For_Update
--   Return the string value 'TRUE' if the value of locked_for_update for
--   the specified serial part = 'Locked', if not return 'FALSE'.
@UncheckedAccess
FUNCTION Is_Locked_For_Update (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Get_Locked_For_Update___(part_no_, serial_no_) = 'LOCKED') THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Locked_For_Update;


-- Rename
--   This method would be invoked from the VIM module to Rename a Serial. The Part/Serial No
--   change would be validated prior to the actual change of the Part/Serial No.
PROCEDURE Rename (
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   new_part_no_         IN VARCHAR2,
   new_serial_no_       IN VARCHAR2,
   manufacturer_no_     IN VARCHAR2,
   manu_part_no_        IN VARCHAR2,
   eng_part_rev_        IN VARCHAR2,
   rename_reason_db_    IN VARCHAR2)
IS
   fromrec_                   part_serial_catalog_tab%ROWTYPE;
   newrec_                    part_serial_catalog_tab%ROWTYPE;
   oldrec_                    part_serial_catalog_tab%ROWTYPE;
   attr_                      VARCHAR2(32000);
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   new_record_                BOOLEAN;
   latest_transaction_        part_serial_catalog_tab.latest_transaction%TYPE;
   transaction_description_   part_serial_catalog_tab.latest_transaction%TYPE;
   null_                      VARCHAR2(1) := NULL;
   info_                      VARCHAR2(2000);

   old_key_ref_               VARCHAR2(2000);
   new_key_ref_               VARCHAR2(2000);
   objref_exist_              VARCHAR2(5):= 'FALSE';
   serial_event_              VARCHAR2(30);
   indrec_                    Indicator_Rec;
   CURSOR get_childs IS
      SELECT *
      FROM part_serial_catalog_tab
      WHERE superior_part_no   = part_no_
        AND superior_serial_no = serial_no_
        FOR UPDATE;
BEGIN

   fromrec_ := Lock_By_Keys___( part_no_,
                                serial_no_ );

   ---------------------------------------------------
   -- Identify if the To Serial exists or not
   ---------------------------------------------------
   IF (Check_Exist___(new_part_no_,
                      new_serial_no_)) THEN
      new_record_ := FALSE;
      oldrec_ := Lock_By_Keys___(new_part_no_,
                                new_serial_no_);
      newrec_           := fromrec_;
      newrec_.part_no   := new_part_no_;
      newrec_.serial_no := new_serial_no_;
      newrec_.rowkey    := oldrec_.rowkey;
      newrec_.rowstate  := oldrec_.rowstate;
   ELSE
      new_record_       := TRUE;
      newrec_           := fromrec_;
      newrec_.part_no   := new_part_no_;
      newrec_.serial_no := new_serial_no_;
      -- These assigment not need since Insert method do assign new every time. But left as it is.
      newrec_.rowstate  := NULL;
      newrec_.rowkey    := NULL;
   END IF;
   
   ---------------------------------------------------
   -- Insert/Update to Serial information
   ---------------------------------------------------
   -- Assign addition informatioin to the new record.
   latest_transaction_            := Get_Renaming_Trans_Desc___(part_no_, serial_no_, new_part_no_, new_serial_no_, rename_reason_db_);
   newrec_.latest_transaction     := latest_transaction_;
   newrec_.renamed_from_part_no   := part_no_;
   newrec_.renamed_from_serial_no := serial_no_;
   newrec_.renamed_to_part_no     := null_;
   newrec_.renamed_to_serial_no   := null_;
   IF (manufacturer_no_ IS NOT NULL) THEN
      newrec_.manufacturer_no   := manufacturer_no_;
   END IF;
   IF (manu_part_no_ IS NOT NULL) THEN
      newrec_.manu_part_no      := manu_part_no_;
   END IF;
   IF (eng_part_rev_ IS NOT NULL) THEN
      newrec_.eng_part_revision := eng_part_rev_;
   END IF;
   
   IF (new_record_) THEN
      IF (fromrec_.rowstate = 'InInventory') THEN
         serial_event_ := 'NewInInventory';
      ELSIF (fromrec_.rowstate = 'Contained') THEN
         serial_event_ := 'NewInContained';
      ELSIF (fromrec_.rowstate = 'Issued') THEN
         serial_event_ := 'NewInIssued';
      ELSIF (fromrec_.rowstate = 'InFacility') THEN
         serial_event_ := 'NewInFacility';
      ELSE
         Error_SYS.Record_General(lu_name_, 'RENSTATERR: Serial No cannot be changed when Individual is in state :P1.', fromrec_.rowstate);
      END IF;

      Client_SYS.Clear_Attr(attr_);
      indrec_ := Get_Indicator_Rec___(newrec_);
      -- Should not be validated server data during insert.
      indrec_.date_created := FALSE;
      indrec_.user_created := FALSE;
      indrec_.date_changed := FALSE;
      indrec_.user_changed := FALSE;
      Check_Insert___( newrec_            => newrec_,
                       indrec_            => indrec_,
                       attr_              => attr_,
                       created_by_server_ => TRUE);
      Insert___(objid_        => objid_,
                objversion_   => objversion_,
                newrec_       => newrec_,
                attr_         => attr_,
                serial_event_ => serial_event_);
   ELSE
      Client_SYS.Clear_Attr(attr_);
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      -- Should not be validated server data during update.
      indrec_.date_created := FALSE;
      indrec_.user_created := FALSE;
      indrec_.date_changed := FALSE;
      indrec_.user_changed := FALSE;
      Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_=> TRUE);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
      
      Client_SYS.Clear_Attr(attr_);
      Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.part_no, newrec_.serial_no);

      IF (fromrec_.rowstate='Contained')THEN
         Move_To_Contained__(info_, objid_, objversion_, attr_, 'DO');
      ELSIF (fromrec_.rowstate='Issued')THEN
         Move_To_Issued__(info_, objid_, objversion_, attr_, 'DO');
      ELSIF (fromrec_.rowstate='InInventory')THEN
         Move_To_Inventory__(info_, objid_, objversion_, attr_, 'DO');
      ELSIF (fromrec_.rowstate='InFacility')THEN
         Move_To_Facility__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
   END IF;

   ---------------------------------------------------
   -- Update from Serial information
   ---------------------------------------------------
   fromrec_ := Get_Object_By_Keys___(part_no_, serial_no_);
   oldrec_ := fromrec_;
   newrec_ := fromrec_;
   newrec_.latest_transaction          := latest_transaction_;
   newrec_.renamed_to_part_no          := new_part_no_;
   newrec_.renamed_to_serial_no        := new_serial_no_;
   newrec_.operational_condition       := Serial_Operational_Cond_API.DB_NOT_APPLICABLE;
   newrec_.operational_status          := Serial_Operational_Status_API.DB_RENAMED;
   newrec_.superior_part_no            := null_;
   newrec_.superior_serial_no          := null_;
   IF (rename_reason_db_ IS NOT NULL) THEN
      newrec_.rename_reason := rename_reason_db_;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_ => TRUE);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

   Client_SYS.Clear_Attr(attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);
   Move_To_Unlocated__ (info_, objid_, objversion_, attr_, 'DO');

   -- Update document references
   old_key_ref_ := part_no_ || '^' || serial_no_ || '^';
   new_key_ref_ := new_part_no_ || '^' || new_serial_no_ || '^';
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      BEGIN
         objref_exist_ := Doc_Reference_Object_API.Exist_Obj_Reference(lu_name_, old_key_ref_); 
      IF (objref_exist_ = 'TRUE') THEN
            Doc_Reference_Object_API.Copy(lu_name_, old_key_ref_, lu_name_, new_key_ref_); 
            Doc_Reference_Object_API.Delete_Obj_Reference(lu_name_, old_key_ref_);
         END IF;
         EXCEPTION
            WHEN OTHERS THEN
            RAISE;
         END;
   $END
   -- Update technical references
   IF (Technical_Object_Reference_API.Exist_Reference_(lu_name_, old_key_ref_) != '-1') THEN
      Technical_Object_Reference_API.Copy(lu_name_, old_key_ref_, new_key_ref_);
      Technical_Object_Reference_API.Delete_Reference(lu_name_, old_key_ref_);
   END IF;

   -- Connect the contained components to the new serial_no
   FOR child_ IN get_childs LOOP
      newrec_ := child_;
      newrec_.superior_part_no   := new_part_no_;
      newrec_.superior_serial_no := new_serial_no_;
      newrec_.latest_transaction := Language_SYS.Translate_Constant(lu_name_, 'RENCUPOCH: Is contained in part no :P1 serial no :P2 ',NULL, new_part_no_, new_serial_no_);
      Modify___(newrec_);
       
      transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'RENTRADESC: Parent renamed from :P1 to :P2 ',NULL, part_no_||':'||serial_no_, new_part_no_||':'||new_serial_no_);
      Part_Serial_History_API.New(child_.part_no, child_.serial_no, 'INFO', transaction_description_);
   END LOOP;
   
   --if the part has as-built structure, create new as build structure with new part and serial
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      --if as-built structure existing, create a copy of it with new name
      As_Built_Configuration_API.Copy_Structure(part_no_,
                                                serial_no_,
                                                new_part_no_,
                                                new_serial_no_);                      
   $END

END Rename;


PROCEDURE Set_Manufactured_Date (
   info_              OUT VARCHAR2,
   part_no_           IN  VARCHAR2,
   serial_no_         IN  VARCHAR2,
   manufactured_date_ IN  DATE )
IS
   oldrec_     part_serial_catalog_tab%ROWTYPE;
   newrec_     part_serial_catalog_tab%ROWTYPE;
   attr_       VARCHAR2(32000);
   objversion_      part_serial_catalog.objversion%TYPE;
   indrec_          Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(part_no_, serial_no_);
   IF ( oldrec_.locked_for_update = Serial_Part_Locked_API.DB_LOCKED ) THEN
      Error_SYS.Record_General(lu_name_, 'SERLOCKED: The serial (:P1) is Locked, no action is allowed on locked serials!', part_no_||','||serial_no_);
   END IF;
   --
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   newrec_.manufactured_date := NVL(manufactured_date_, sysdate);
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_ => TRUE);
   Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   --
   info_ := Client_SYS.Get_All_Info;
END Set_Manufactured_Date;


PROCEDURE Set_Manufacturer_Info (
   info_                     OUT VARCHAR2,
   part_no_                  IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   manufacturer_no_          IN  VARCHAR2,
   manu_part_no_             IN  VARCHAR2,
   manufacturer_serial_no_   IN  VARCHAR2,
   manufactured_date_        IN  DATE )
IS
   oldrec_        part_serial_catalog_tab%ROWTYPE;
   newrec_        part_serial_catalog_tab%ROWTYPE;
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   objversion_    part_serial_catalog.objversion%TYPE;
   exit_procedure EXCEPTION;
BEGIN

   oldrec_ := Lock_By_Keys___(part_no_, serial_no_);
   
   IF NOT(Validate_SYS.Is_Changed(oldrec_.manufacturer_no, manufacturer_no_) OR 
          Validate_SYS.Is_Changed(oldrec_.manu_part_no, manu_part_no_) OR 
          Validate_SYS.Is_Changed(oldrec_.manufactured_date, manufactured_date_) OR 
          Validate_SYS.Is_Changed(oldrec_.manufacturer_serial_no, manufacturer_serial_no_)) THEN
      RAISE exit_procedure;
   END IF;

   IF (oldrec_.locked_for_update = Serial_Part_Locked_API.DB_LOCKED ) THEN
      Error_SYS.Record_General(lu_name_, 'SERLOCKED: The serial (:P1) is Locked, no action is allowed on locked serials!', part_no_||','||serial_no_);
   END IF;
   Client_SYS.Clear_Attr(attr_);
   newrec_ := oldrec_;
   newrec_.manufacturer_no        := manufacturer_no_;
   newrec_.manu_part_no           := manu_part_no_;
   newrec_.manufactured_date      := manufactured_date_;
   newrec_.manufacturer_serial_no := manufacturer_serial_no_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_ => TRUE);
   Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   info_ := Client_SYS.Get_All_Info;
   EXCEPTION
      WHEN exit_procedure THEN
         NULL;
END Set_Manufacturer_Info;


PROCEDURE Set_Installation_Date (
   info_              OUT VARCHAR2,
   part_no_           IN  VARCHAR2,
   serial_no_         IN  VARCHAR2,
   installation_date_ IN  DATE )
IS
   oldrec_          part_serial_catalog_tab%ROWTYPE;
   newrec_          part_serial_catalog_tab%ROWTYPE;
   attr_            VARCHAR2(32000);
   objversion_      part_serial_catalog.objversion%TYPE;
   indrec_          Indicator_Rec;
BEGIN
   --
   oldrec_ := Lock_By_Keys___(part_no_, serial_no_);
   --
   IF (oldrec_.locked_for_update = Serial_Part_Locked_API.DB_LOCKED ) THEN
      Error_SYS.Record_General(lu_name_, 'SERLOCKED: The serial (:P1) is Locked, no action is allowed on locked serials!', part_no_||','||serial_no_);
   END IF;
   --
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   newrec_.installation_date := installation_date_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_ => TRUE);
   Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
   --
   info_ := Client_SYS.Get_All_Info;
END Set_Installation_Date;


PROCEDURE Set_Eng_Part_Revision (
   part_no_         IN VARCHAR2,
   serial_no_       IN VARCHAR2,
   part_rev_        IN VARCHAR2,
   manu_part_no_    IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 )
IS
   oldrec_                part_serial_catalog_tab%ROWTYPE;
   newrec_                part_serial_catalog_tab%ROWTYPE;
   attr_                  VARCHAR2(32000);
   objversion_            part_serial_catalog.objversion%TYPE;
   indrec_                Indicator_Rec;
BEGIN
   IF (part_rev_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'REVNOTNULL: Eng Part Revision cannot be NULL!');
   END IF;
   oldrec_ := Lock_By_Keys___(part_no_, serial_no_);
   IF (oldrec_.locked_for_update = Serial_Part_Locked_API.DB_LOCKED) THEN
      Error_SYS.Record_General(lu_name_, 'SERLOCKED: The serial (:P1) is Locked, no action is allowed on locked serials!', part_no_||','||serial_no_);
   END IF;
   newrec_ := oldrec_;
   Client_SYS.Clear_Attr(attr_);
   newrec_.eng_part_revision := part_rev_;
   IF (manufacturer_no_ IS NOT NULL) THEN
      newrec_.manufacturer_no := manufacturer_no_;
   END IF;
   IF (manu_part_no_ IS NOT NULL) THEN
      newrec_.manu_part_no := manu_part_no_;
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, created_by_server_ => TRUE);
   Update___(NULL, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Eng_Part_Revision;


-- Set_Supplier_No
--   Assign a new value to the supplier_no attribute
PROCEDURE Set_Supplier_No (
   part_no_     IN VARCHAR2,
   serial_no_   IN VARCHAR2,
   supplier_no_ IN VARCHAR2 )
IS
   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.supplier_no := supplier_no_;
   Modify___(newrec_);
END Set_Supplier_No;


-- Set_Acquisition_Cost
--   Assign a new value to the acquisition_cost
PROCEDURE Set_Acquisition_Cost (
   part_no_         IN VARCHAR2,
   serial_no_       IN VARCHAR2,
   acquisition_cost_ IN NUMBER )
IS
   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.acquisition_cost := acquisition_cost_;
   Modify___(newrec_);
END Set_Acquisition_Cost;


-- Set_Manufacturer_No
--   Assign a new value to the manufacturer_no attribute
PROCEDURE Set_Manufacturer_No (
   part_no_         IN VARCHAR2,
   serial_no_       IN VARCHAR2,
   manufacturer_no_ IN VARCHAR2 )
IS
   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.manufacturer_no := manufacturer_no_;
   Modify___(newrec_);
END Set_Manufacturer_No;


-- Modify_Condition_Code
--   Updates an individual with a new Condition Code. Calls from ConditionCodeManager.
PROCEDURE Modify_Condition_Code (
   part_no_ IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   condition_code_ IN VARCHAR2 )
IS
   newrec_                  part_serial_catalog_tab%ROWTYPE;
   transaction_description_ part_serial_history_tab.transaction_description%TYPE;
   old_condition_code_      part_serial_catalog_tab.condition_code%TYPE;
BEGIN
   IF NOT Check_Exist___(part_no_, serial_no_) THEN
      Error_SYS.Record_General(lu_name_, 'SERNOTEXIST: The serial number :P1 does not exist', serial_no_);
   END IF;
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   old_condition_code_ := newrec_.condition_code;
   newrec_.condition_code := condition_code_;
   Modify___(newrec_);
   
   transaction_description_ :=
      Language_SYS.Translate_Constant(lu_name_, 'MODCONDCODE: Condition Code modified from :P1 to :P2', NULL, old_condition_code_, condition_code_);
   Part_Serial_History_API.New(part_no_, serial_no_, 'INFO', transaction_description_);
END Modify_Condition_Code;


-- Check_Eng_Part_Revision_Exist
--   Check if a serial with the specified part number and engineering part
--   revision exists. If this is the case return 'TRUE' else return 'FALSE'
@UncheckedAccess
FUNCTION Check_Eng_Part_Revision_Exist (
   part_no_           IN VARCHAR2,
   eng_part_revision_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   part_serial_catalog_tab
      WHERE part_no = part_no_
      AND   eng_part_revision = eng_part_revision_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN('FALSE');
END Check_Eng_Part_Revision_Exist;


-- Move_Individual
--   Method used from the client to move a serial contained in a structure
--   to another structure. The parent part must be the same in the old and
--   new structure.
PROCEDURE Move_Individual (
   info_                    OUT VARCHAR2,
   part_no_                 IN  VARCHAR2,
   serial_no_               IN  VARCHAR2,
   superior_part_no_        IN  VARCHAR2,
   superior_serial_no_      IN  VARCHAR2,
   transaction_description_ IN  VARCHAR2,
   action_                  IN  VARCHAR2 )
IS
   attr_       VARCHAR2 (32000);
   newrec_     part_serial_catalog_tab%ROWTYPE;
   oldrec_     part_serial_catalog_tab%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Get_Object_By_Keys___ (part_no_,serial_no_);
   newrec_ := oldrec_;   
   IF  (superior_part_no_ != newrec_.superior_part_no) THEN
      Error_Sys.Record_General(lu_name_,'WRONGMOVE: :P1 - :P2 must have the same superior part before and after the move.',
                               part_no_,serial_no_);
   END IF;
   IF (action_ = 'CHECK') THEN
      Client_SYS.Clear_Attr(attr_);
      newrec_.superior_part_no   := superior_part_no_;
      newrec_.superior_serial_no := superior_serial_no_;
      newrec_.latest_transaction := transaction_description_;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
   ELSE
      -- (action_ = 'DO')
      Modify_Serial_Structure(part_no_, serial_no_, superior_part_no_, superior_serial_no_, transaction_description_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Move_Individual;


PROCEDURE Get_Structure_Ownership (
   has_single_ownership_      OUT VARCHAR2,
   contains_company_owned_    OUT VARCHAR2,
   contains_supplier_loaned_  OUT VARCHAR2,
   contains_customer_owned_   OUT VARCHAR2,
   owning_vendor_no_list_     OUT VARCHAR2,
   owning_customer_no_list_   OUT VARCHAR2,
   part_no_                   IN  VARCHAR2,
   serial_no_                 IN  VARCHAR2,
   top_part_ownership_db_     IN  VARCHAR2,
   top_owning_vendor_no_      IN  VARCHAR2,
   top_owning_customer_no_    IN  VARCHAR2 )
IS
   this_has_single_ownership_      VARCHAR2(10) := 'TRUE';
   this_contains_company_owned_    VARCHAR2(10) := 'FALSE';
   this_contains_supplier_loaned_  VARCHAR2(10) := 'FALSE';
   this_contains_customer_owned_   VARCHAR2(10) := 'FALSE';
   this_owning_vendor_no_list_     VARCHAR2(32000) := NULL;
   this_owning_customer_no_list_   VARCHAR2(32000) := NULL;

   rec_                            part_serial_catalog_tab%ROWTYPE;

BEGIN
   rec_ := Get_Object_By_Keys___ (part_no_,serial_no_);

   --check ownership
   IF rec_.part_ownership != top_part_ownership_db_ THEN
      Error_SYS.Record_General(lu_name_, 'TOPOWNERSHIPMISMATCH: Part ownership does not match with top part ownership');
   END IF;

   --check owner
   IF (((top_part_ownership_db_ IN (Part_Ownership_API.DB_SUPPLIER_LOANED,
                                    Part_Ownership_API.DB_SUPPLIER_RENTED)) 
       AND (rec_.owning_vendor_no != top_owning_vendor_no_))
   OR ((top_part_ownership_db_ = Part_Ownership_API.DB_CUSTOMER_OWNED) 
       AND (rec_.owning_customer_no != top_owning_customer_no_))) THEN
       Error_SYS.Record_General(lu_name_, 'TOPOWNERMISMATCH: Part owner does not match with top part owner');
   END IF;

   --calc
   Calc_Structure_Ownership(this_has_single_ownership_,
                            this_contains_company_owned_,
                            this_contains_supplier_loaned_,
                            this_contains_customer_owned_,
                            this_owning_vendor_no_list_,
                            this_owning_customer_no_list_,
                            part_no_,
                            serial_no_,
                            top_part_ownership_db_,
                            top_owning_vendor_no_,
                            top_owning_customer_no_);

   has_single_ownership_      := this_has_single_ownership_;
   contains_company_owned_    := this_contains_company_owned_;
   contains_supplier_loaned_  := this_contains_supplier_loaned_;
   contains_customer_owned_   := this_contains_customer_owned_;

   --format lists for client
   owning_vendor_no_list_     := this_owning_vendor_no_list_;
   owning_customer_no_list_   := this_owning_customer_no_list_;

END Get_Structure_Ownership;


-- Calc_Structure_Ownership
--   This method is called from GetStructureOwnership in order to get
--   the ownership information of component parts of the specified serial part.
PROCEDURE Calc_Structure_Ownership (
   has_single_ownership_      IN OUT VARCHAR2,
   contains_company_owned_    IN OUT VARCHAR2,
   contains_supplier_loaned_  IN OUT VARCHAR2,
   contains_customer_owned_   IN OUT VARCHAR2,
   owning_vendor_no_list_     IN OUT VARCHAR2,
   owning_customer_no_list_   IN OUT VARCHAR2,
   part_no_                   IN     VARCHAR2,
   serial_no_                 IN     VARCHAR2,
   top_part_ownership_db_     IN     VARCHAR2,
   top_owning_vendor_no_      IN     VARCHAR2,
   top_owning_customer_no_    IN     VARCHAR2 )
IS
   child_part_no_             part_serial_catalog_tab.part_no%TYPE;
   child_serial_no_           part_serial_catalog_tab.serial_no%TYPE;
   child_lot_batch_no_        part_serial_catalog_tab.lot_batch_no%TYPE;
   child_part_ownership_      part_serial_catalog_tab.part_ownership%TYPE;
   child_owning_vendor_no_    part_serial_catalog_tab.owning_vendor_no%TYPE;
   child_owning_customer_no_  part_serial_catalog_tab.owning_customer_no%TYPE;

   top_lot_batch_no_          part_serial_catalog_tab.lot_batch_no%TYPE;

   CURSOR get_children IS
      SELECT part_no,
             serial_no,
             lot_batch_no,
             part_ownership,
             owning_vendor_no,
             owning_customer_no
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no   IS NOT NULL
      CONNECT BY PRIOR part_no   = superior_part_no
             AND PRIOR serial_no = superior_serial_no
      START WITH part_no   = part_no_
            AND  serial_no = serial_no_;

   delim_         CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
BEGIN

   top_lot_batch_no_ := Get_Lot_Batch_No(part_no_, serial_no_);

   --call as-built for top part
   $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
      As_Built_Configuration_API.Calc_Structure_Ownership(has_single_ownership_,
                                                          contains_company_owned_,
                                                          contains_supplier_loaned_,
                                                          contains_customer_owned_,
                                                          owning_vendor_no_list_,
                                                          owning_customer_no_list_,
                                                          part_no_,
                                                          serial_no_,
                                                          top_lot_batch_no_,
                                                          top_part_ownership_db_,
                                                          top_owning_vendor_no_,
                                                          top_owning_customer_no_);              
   $END

   --read serial structure tree depth-first-traverse
   OPEN get_children;
   FETCH get_children INTO child_part_no_,
                           child_serial_no_,
                           child_lot_batch_no_,
                           child_part_ownership_,
                           child_owning_vendor_no_,
                           child_owning_customer_no_;

   WHILE (get_children%FOUND) LOOP

      --check ownership
      IF (child_part_ownership_ != top_part_ownership_db_)
         AND (has_single_ownership_ = 'TRUE') THEN
         has_single_ownership_ := 'FALSE';
      END IF;

      --check owner
      IF (child_part_ownership_ = top_part_ownership_db_)
         AND (((child_part_ownership_ = 'SUPPLIER LOANED')
               AND (child_owning_vendor_no_ != top_owning_vendor_no_))
            OR ((child_part_ownership_ = 'CUSTOMER OWNED')
               AND (child_owning_customer_no_ != top_owning_customer_no_)))
         AND (has_single_ownership_ = 'TRUE') THEN
         has_single_ownership_ := 'FALSE';
      END IF;

      --check for company owned
      IF (child_part_ownership_ = 'COMPANY OWNED')
         AND (contains_company_owned_ = 'FALSE') THEN
         contains_company_owned_ := 'TRUE';

      --check for supplier
      ELSIF (child_part_ownership_ = 'SUPPLIER LOANED') THEN

         IF (contains_supplier_loaned_ = 'FALSE') THEN
            contains_supplier_loaned_ := 'TRUE';
         END IF;

         --add vendor no if not already in vendor list
         IF owning_vendor_no_list_ IS NULL THEN
            owning_vendor_no_list_ := delim_ || child_owning_vendor_no_ || delim_;
         ELSIF (INSTR(owning_vendor_no_list_, delim_ || child_owning_vendor_no_ || delim_) = 0) THEN
            owning_vendor_no_list_ := owning_vendor_no_list_ || child_owning_vendor_no_ || delim_;
         END IF;

      --check for customer
      ELSIF (child_part_ownership_ = 'CUSTOMER OWNED') THEN
         IF (contains_customer_owned_ = 'FALSE') THEN
            contains_customer_owned_ := 'TRUE';
         END IF;

         --add customer no if not already in customer list
         IF owning_customer_no_list_ IS NULL THEN
            owning_customer_no_list_ := delim_ || child_owning_customer_no_ || delim_;
         ELSIF (INSTR(owning_customer_no_list_, delim_ || child_owning_customer_no_ || delim_) = 0) THEN
            owning_customer_no_list_ := owning_customer_no_list_ || child_owning_customer_no_ || delim_;
         END IF;
      END IF;

      $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
         --call as-built
         As_Built_Configuration_API.Calc_Structure_Ownership(has_single_ownership_,
                                                                         contains_company_owned_,
                                                                         contains_supplier_loaned_,
                                                                         contains_customer_owned_,
                                                                         owning_vendor_no_list_,
                                                                         owning_customer_no_list_,
                                                                         child_part_no_,
                                                                         child_serial_no_,
                                                                         child_lot_batch_no_,
                                                                         top_part_ownership_db_,
                                                                         top_owning_vendor_no_,
                                                                         top_owning_customer_no_);                     
      $END

      FETCH get_children INTO child_part_no_,
                              child_serial_no_,
                              child_lot_batch_no_,
                              child_part_ownership_,
                              child_owning_vendor_no_,
                              child_owning_customer_no_;

   END LOOP;

   CLOSE get_children;

END Calc_Structure_Ownership;


-- Set_Serial_Ownership
--   This method will set the persistent ownership of serial parts.
PROCEDURE Set_Serial_Ownership (
   part_no_                   IN VARCHAR2,
   serial_no_                 IN VARCHAR2,
   new_part_ownership_db_     IN VARCHAR2,
   new_owning_vendor_no_      IN VARCHAR2,
   new_owning_customer_no_    IN VARCHAR2,
   update_structure_          IN VARCHAR2 DEFAULT 'TRUE',
   check_existence_           IN VARCHAR2 DEFAULT 'TRUE',
   create_serial_history_     IN BOOLEAN  DEFAULT FALSE )
IS
   oldrec_                    part_serial_catalog_tab%ROWTYPE;
   newrec_                    part_serial_catalog_tab%ROWTYPE;
   message_                   VARCHAR2(2000);
BEGIN
   --Check for existance
   IF Check_Exist___(part_no_, serial_no_) THEN
      oldrec_ := Lock_By_Keys___ (part_no_,serial_no_);
      --if old part ownership is different from new ownership
      IF ((oldrec_.part_ownership != new_part_ownership_db_)
         OR ((oldrec_.part_ownership = new_part_ownership_db_)
             AND (((oldrec_.part_ownership = Part_Ownership_API.DB_CUSTOMER_OWNED)
                  AND (oldrec_.owning_customer_no != new_owning_customer_no_))
               OR ((oldrec_.part_ownership IN (Part_Ownership_API.DB_SUPPLIER_LOANED,
                                               Part_Ownership_API.DB_SUPPLIER_OWNED,
                                               Part_Ownership_API.DB_SUPPLIER_RENTED))
                  AND (oldrec_.owning_vendor_no != new_owning_vendor_no_))))
         OR (update_structure_ = 'TRUE')) THEN

         --check if in inventory
         IF (check_existence_ = 'TRUE') THEN
            IF (oldrec_.rowstate = 'InInventory')  THEN
               Error_SYS.Record_General('PartSerialCatalog','ININVENTORY: Serial No :P1 of Part No :P2 is already in inventory.',serial_no_, part_no_);
            END IF;
         END IF;

         --if not SUPPLIER LOAND or if SUPPLIER LOANED then not in Contained state
         IF ((oldrec_.part_ownership != Part_Ownership_API.DB_SUPPLIER_LOANED)
            OR ((oldrec_.part_ownership = Part_Ownership_API.DB_SUPPLIER_LOANED)
               AND (oldrec_.rowstate != 'Contained'))) THEN

            newrec_ := oldrec_;
            newrec_.part_ownership     := new_part_ownership_db_;
            newrec_.owning_customer_no := new_owning_customer_no_;
            newrec_.owning_vendor_no   := new_owning_vendor_no_;
            Modify___(newrec_);
            
            IF create_serial_history_ THEN
               IF (oldrec_.part_ownership != new_part_ownership_db_) THEN
                  IF (oldrec_.part_ownership IN (Part_Ownership_API.DB_SUPPLIER_LOANED, Part_Ownership_API.DB_CONSIGNMENT) 
                     AND new_part_ownership_db_ = Part_Ownership_API.DB_COMPANY_OWNED) THEN
                     message_ := Language_SYS.Translate_Constant(lu_name_, 'OWN_CHG_SUPCOMP: Ownership modified from type :P1, Supplier :P2 to Company Owned', NULL, Part_Ownership_API.Decode(oldrec_.part_ownership), oldrec_.owning_vendor_no);
                  ELSIF (oldrec_.part_ownership = Part_Ownership_API.DB_CUSTOMER_OWNED 
                        AND new_part_ownership_db_ = Part_Ownership_API.DB_COMPANY_OWNED) THEN
                     message_ := Language_SYS.Translate_Constant(lu_name_, 'OWN_CHG_CCOMP: Ownership modified from customer :P1 to company owned', NULL, oldrec_.owning_customer_no);
                  ELSIF (oldrec_.part_ownership IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_COMPANY_RENTAL_ASSET) 
                     AND new_part_ownership_db_ IN (Part_Ownership_API.DB_COMPANY_OWNED, Part_Ownership_API.DB_COMPANY_RENTAL_ASSET)) THEN
                     message_ := Language_SYS.Translate_Constant(lu_name_, 'OWN_CHG_RENTALASSET: Ownership modified from :P1 to :P2', NULL, Part_Ownership_API.Decode(oldrec_.part_ownership), Part_Ownership_API.Decode(new_part_ownership_db_));
                  END IF;
                  
               ELSE
                  IF (new_part_ownership_db_ = Part_Ownership_API.DB_CUSTOMER_OWNED AND
                     oldrec_.owning_customer_no != new_owning_customer_no_ ) THEN
                     message_ := Language_SYS.Translate_Constant(lu_name_, 'OWN_CHG_CCUST: Ownership modified from customer :P1 to :P2', NULL, oldrec_.owning_customer_no, new_owning_customer_no_);
                  ELSIF (new_part_ownership_db_ = Part_Ownership_API.DB_SUPPLIER_LOANED AND
                     oldrec_.owning_vendor_no != new_owning_vendor_no_ ) THEN
                     message_ := Language_SYS.Translate_Constant(lu_name_, 'OWN_CHG_SSUPP: Ownership modified from supplier :P1 to :P2', NULL, oldrec_.owning_vendor_no, new_owning_vendor_no_);
                  END IF;
               END IF;
               IF (message_ IS NOT NULL) THEN
                  Part_Serial_History_API.New(part_no_, serial_no_, 'INFO', message_);
               END IF;
            END IF;
         END IF;

         --update the whole structure
         IF (update_structure_ = 'TRUE') THEN
            Set_Structure_Ownership___(part_no_,
                                       serial_no_,
                                       new_part_ownership_db_,
                                       new_owning_vendor_no_,
                                       new_owning_customer_no_,
                                       create_serial_history_ );
         END IF;

         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            --call as-built
            As_Built_Configuration_API.Set_Structure_Ownership(part_no_,
                                                               serial_no_,
                                                               new_part_ownership_db_,
                                                               new_owning_vendor_no_,
                                                               new_owning_customer_no_);                      
         $END

         END IF;
      END IF;
END Set_Serial_Ownership;


-- Get_Previous_Current_Position
--   Return the previous current position (objstate) for the specified serial.
--   Return the previous current position (objstate) for the serial part.
--   The name of this standard method shortened due to Oracle limitations (max 30 characters allowed)
FUNCTION Get_Previous_Current_Position (
   part_no_                    IN VARCHAR2,
   serial_no_                  IN VARCHAR2,
   ignore_completely_reversed_ IN BOOLEAN DEFAULT TRUE ) RETURN VARCHAR2
IS
   current_position_db_ part_serial_catalog_tab.rowstate%TYPE;   
BEGIN
   current_position_db_ := Get_Objstate(part_no_, serial_no_);
   RETURN (Part_Serial_History_API.Get_Previous_Current_Position(part_no_,
                                                                 serial_no_,
                                                                 ignore_completely_reversed_,
                                                                 current_position_db_));  
END Get_Previous_Current_Position;

-- Unscrap_At_Supplier
--   Undo scrap at supplier and set the state to Issued
PROCEDURE Unscrap_At_Supplier (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2 )
IS
   serial_message_          VARCHAR2(2000);
   info_          VARCHAR2(2000);
BEGIN
   -- Set operational status to 'Out of Operation', operational condition to
   -- 'Operational' and rowstate to 'Issued'
   Set_Operational_Condition___(info_,
                                part_no_                  => part_no_,
                                serial_no_                => serial_no_,
                                operational_condition_db_ => 'OPERATIONAL',
                                order_type_               => NULL,
                                order_no_                 => NULL,
                                line_no_                  => NULL,
                                release_no_               => NULL,
                                line_item_no_             => NULL,
                                update_structure_         => TRUE,
                                validate_structure_       => FALSE);
   serial_message_ := Language_SYS.Translate_Constant(lu_name_, 'UNSCRAPATSUPP: Undo Scrap at Supplier');
   Move_To_Issued(part_no_,
                  serial_no_,
                  serial_message_,
                  serial_message_,
                  'OUT_OF_OPERATION');
END Unscrap_At_Supplier;


-- Set_Partial_Part
--   Sets a serials status/condition either to a partial part from
--   a whole part or vice versa.
PROCEDURE Set_Partial_Part (
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   condition_code_      IN VARCHAR2,
   maintenance_level_   IN VARCHAR2,
   action_type_         IN NUMBER,
   source_order_        IN VARCHAR2 DEFAULT NULL,
   source_release_      IN VARCHAR2 DEFAULT NULL,
   source_seq_          IN VARCHAR2 DEFAULT NULL,
   destination_order_   IN VARCHAR2 DEFAULT NULL,
   destination_release_ IN VARCHAR2 DEFAULT NULL,
   destination_seq_     IN VARCHAR2 DEFAULT NULL )
IS
   source_ref1_             VARCHAR2(12);
   source_ref2_             VARCHAR2(4);
   source_ref3_             VARCHAR2(4);
   dest_source_ref1_        VARCHAR2(12);
   dest_source_ref2_        VARCHAR2(4);
   dest_source_ref3_        VARCHAR2(4);
   newrec_                  part_serial_catalog_tab%ROWTYPE;
   history_purpose_db_      VARCHAR2(20) := 'INFO';
   transaction_description_ part_serial_history_tab.transaction_description%TYPE;
BEGIN
   -- Update the PartSerialCatalog's ConditionCode and PartialDisassemblyLevel
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.condition_code            := condition_code_;
   newrec_.partial_disassembly_level := maintenance_level_;
   Modify___(newrec_);
   
   -- Create history
   IF source_order_ IS NOT NULL THEN
      source_ref1_ := source_order_;
      source_ref2_ := source_release_;
      source_ref3_ := source_seq_;
      IF action_type_ = 1 THEN
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_,
            'PARTIAL_RECEIPT: Serial marked as incomplete Partial Part');
      ELSIF action_type_ = 0 THEN
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_,
            'PARTIAL_UNRECEIPT: Incomplete Partial Part Serial unreceived and marked complete');
      ELSE
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_,
            'PARTIAL_UNISSUE: Serial unissed and marked as incomplete Partial Part');
      END IF;
   ELSIF destination_order_ IS NOT NULL THEN
      dest_source_ref1_ := destination_order_;
      dest_source_ref2_ := destination_release_;
      dest_source_ref3_ := destination_seq_;
      transaction_description_ := Language_SYS.Translate_Constant(lu_name_,
         'PARTIAL_ISSUE: Incomplete Partial Part Serial issued and marked complete');
   END IF;
   Part_Serial_History_API.New( part_no_,
                                serial_no_,
                                history_purpose_db_,
                                transaction_description_, 
                                partial_disassembly_level_ => maintenance_level_,
                                partial_source_order_no_   => source_ref1_,
                                partial_source_release_no_ => source_ref2_,
                                partial_source_seq_no_     => source_ref3_,
                                partial_dest_order_no_     => dest_source_ref1_,
                                partial_dest_release_no_   => dest_source_ref2_,
                                partial_dest_seq_no_       => dest_source_ref3_);
END Set_Partial_Part;


-- Unscrap_During_Disposition
--   Undo scrap during disposition.
PROCEDURE Unscrap_During_Disposition (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   transaction_description_ IN VARCHAR2 )
IS
BEGIN
   Set_Non_Operational(part_no_, serial_no_, TRUE);
   Move_To_Issued(
      part_no_                 => part_no_,
      serial_no_               => serial_no_,
      latest_transaction_      => transaction_description_,
      transaction_description_ => transaction_description_,
      operational_status_db_   => 'OUT_OF_OPERATION');
END Unscrap_During_Disposition;


-- Get_Description
--   Gets the Part_No description from part_catalog.
@UncheckedAccess
FUNCTION Get_Description (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Part_Catalog_API.Get_Description(part_no_);
END Get_Description;


-- Modify_Latest_Transaction
--   Modify the latest transaction attribute for the specified serial object.
PROCEDURE Modify_Latest_Transaction (
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   latest_transaction_      IN VARCHAR2,
   transaction_description_ IN VARCHAR2,
   history_purpose_db_      IN VARCHAR2,
   order_type_              IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   inv_transaction_id_      IN NUMBER  )
IS
   newrec_                  part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.latest_transaction := latest_transaction_;
   Modify___(newrec_);

   -- Create record in PartSerialHistory
   Part_Serial_History_API.New(part_no_,
                               serial_no_,
                               history_purpose_db_,
                               transaction_description_,
                               order_type_,
                               order_no_,
                               line_no_,
                               release_no_,
                               line_item_no_,
                               inv_transaction_id_);
END Modify_Latest_Transaction;


-- Check_Rename
--   This method would be invoked from the VIM module to verify if Renaming of a
--   Serial Part is allowed from a Part Catalog perspective.
PROCEDURE Check_Rename (
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   new_part_no_         IN VARCHAR2,
   new_serial_no_       IN VARCHAR2 )
IS
   serial_state_db_        part_serial_catalog_tab.rowstate%TYPE;
BEGIN

   Check_Rename___(part_no_,
                   serial_no_,
                   new_part_no_,
                   new_serial_no_);

   serial_state_db_        := Get_Objstate(part_no_, serial_no_);

   -- Special handling is used here to ensure that the validations in Inventory take place once in Check_Rename
   IF serial_state_db_ = 'InInventory' THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Invent_Part_Serial_Manager_API.Check_Rename(part_no_, serial_no_, new_part_no_, new_serial_no_);
      $ELSE
         NULL;
      $END
      END IF;
END Check_Rename;


-- Get_Top_Parent
--   If a Serial has a parent this will retrieve the top most
--   parent info.
@UncheckedAccess
PROCEDURE Get_Top_Parent (
   top_part_no_   OUT VARCHAR2,
   top_serial_no_ OUT VARCHAR2,
   part_no_       IN VARCHAR2,
   serial_no_     IN VARCHAR2 )
IS
BEGIN
   Get_Top_Serial___(top_part_no_, top_serial_no_, part_no_, serial_no_);
   IF ((top_part_no_ = part_no_) AND (top_serial_no_ = serial_no_)) THEN
      -- the serial does not have any parent, it is a top serial in itself.
      top_part_no_   := NULL;
      top_serial_no_ := NULL;
   END IF;
END Get_Top_Parent;


-- New_As_Renamed
--   Creates a new Serial as a copy of an existing Serial simulating
--   the new Serial to be the original Serial from which the existing Serial is Renamed To.
PROCEDURE New_As_Renamed (
   new_part_no_      IN VARCHAR2,
   new_serial_no_    IN VARCHAR2,
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   transaction_date_ IN DATE,
   manufacturer_no_  IN VARCHAR2,
   manu_part_no_     IN VARCHAR2,
   eng_part_rev_     IN VARCHAR2,
   rename_reason_db_ IN VARCHAR2)

IS
   fromrec_                   part_serial_catalog_tab%ROWTYPE;
   newrec_                    part_serial_catalog_tab%ROWTYPE;
   oldrec_                    part_serial_catalog_tab%ROWTYPE;
   objid_                     VARCHAR2(2000);
   objversion_                VARCHAR2(2000);
   attr_                      VARCHAR2(2000);
   null_                      VARCHAR2(1):=NULL;
   serial_event_              VARCHAR2(30);
   indrec_                    Indicator_Rec;
BEGIN
   IF (transaction_date_ >= SYSDATE) THEN
      Error_SYS.Record_General(lu_name_, 'TRANSDTINV: Transaction date should be earlier than the current date, Serial may not be created as Renamed.');
   END IF;

   IF (Check_Exist___(new_part_no_,
                      new_serial_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'NEWSEREXIST: Serial <:P1> already exists, and may not be created as Renamed.',new_part_no_||','||new_serial_no_);
   END IF;

   IF (Check_Exist___(part_no_,
                      serial_no_)) THEN
      fromrec_ := Lock_By_Keys___(part_no_,
                                  serial_no_);
      newrec_           := fromrec_;
      newrec_.part_no   := new_part_no_;
      newrec_.serial_no := new_serial_no_;
      newrec_.rowstate  := NULL;

      IF (fromrec_.renamed_from_part_no IS NOT NULL) THEN
         Error_SYS.Record_General(lu_name_, 'RENFROMEXIST: Serial <:P1> has been renamed from <:P2>, Serial may not be created as Renamed.',part_no_||','||serial_no_,fromrec_.renamed_from_part_no||','||fromrec_.renamed_from_serial_no);
      END IF;

      IF (fromrec_.operational_status IN ('SCRAPPED','RENAMED')) THEN
         Error_SYS.Record_General(lu_name_, 'INVTOSERSTATE: Creating a new Serial as Renamed is not allowed when the Operational Status of Serial <:P1> is :P2.', part_no_||','||serial_no_, Serial_Operational_Status_API.Decode(fromrec_.operational_status));
      END IF;
      IF  Part_Serial_History_API.Get_Earliest_Transaction_Date(part_no_, serial_no_) <= transaction_date_ THEN
         Error_SYS.Record_General(lu_name_, 'TRANSOLDEXIST: Transaction date should be earlier than any existing transaction for Serial <:P1>.',part_no_||','||serial_no_);
      END IF;
      -- Check if the any transactions exist after the transaction date
   ELSE
      Error_SYS.Record_General(lu_name_, 'NEWSERNOTEXIST: Serial :P1 does not exist, create new Serial as Renamed is not allowed.',part_no_||','||serial_no_);
   END IF;

   -- Create new Serial as if its old
   newrec_.latest_transaction          := Get_Renaming_Trans_Desc___(new_part_no_, new_serial_no_, part_no_, serial_no_, rename_reason_db_);
   newrec_.renamed_to_part_no          := part_no_;
   newrec_.renamed_to_serial_no        := serial_no_;
   newrec_.operational_condition       := Serial_Operational_Cond_API.DB_NON_OPERATIONAL;
   newrec_.operational_status          := Serial_Operational_Status_API.DB_RENAMED;
   newrec_.superior_part_no            := null_;
   newrec_.superior_serial_no          := null_;
   newrec_.manufacturer_no             := manufacturer_no_;
   newrec_.manu_part_no                := manu_part_no_;
   newrec_.eng_part_revision           := eng_part_rev_;
   newrec_.rename_reason               := rename_reason_db_;
   serial_event_                       := 'NewInUnlocated';

   Client_SYS.Clear_Attr(attr_);
   indrec_ := Get_Indicator_Rec___(newrec_);
   indrec_.date_created := FALSE;
   indrec_.user_created := FALSE;
   indrec_.date_changed := FALSE;
   indrec_.user_changed := FALSE;
   Check_Insert___(newrec_, indrec_, attr_, transaction_date_ => transaction_date_, created_by_server_ => TRUE);
   Insert___(objid_, objversion_, newrec_, attr_, serial_event_, transaction_date_); 

   -- Update Existing Serial
   Client_SYS.Clear_Attr(attr_);
   oldrec_ := fromrec_;
   newrec_ := fromrec_;
   newrec_.renamed_from_part_no   := new_part_no_;
   newrec_.renamed_from_serial_no := new_serial_no_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, transaction_date_ => transaction_date_, created_by_server_ => TRUE);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, transaction_date_ => transaction_date_);
END New_As_Renamed;


-- Created_By
--   Returns True if part no. Serial no combination was originated
--   from the same shop order. False otherwise
@UncheckedAccess
FUNCTION Created_By (
   part_no_            IN VARCHAR2,
   serial_no_          IN VARCHAR2,
   source_ref1_        IN VARCHAR2,
   source_ref2_        IN VARCHAR2,
   source_ref3_        IN VARCHAR2,
   source_ref4_        IN NUMBER,
   source_ref_type_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   part_rec_           PART_SERIAL_HISTORY_TAB%ROWTYPE;
   dummy_              CONSTANT NUMBER := -9999999;
   created_by_         BOOLEAN := FALSE;

   CURSOR get_part_rec IS
      SELECT *
      FROM part_serial_history_tab
      WHERE part_no = part_no_
      AND   serial_no = serial_no_
      AND   sequence_no = (SELECT MIN(sequence_no)
                           FROM part_serial_history_tab
                           WHERE part_no = part_no_
                           AND   serial_no = serial_no_);
BEGIN

   OPEN get_part_rec;
   FETCH get_part_rec INTO part_rec_;
   CLOSE get_part_rec;

   IF ((source_ref_type_db_ = part_rec_.order_type) AND
       (source_ref1_ = part_rec_.order_no) AND
       (NVL(source_ref2_, string_null_) = NVL(part_rec_.line_no, string_null_)) AND
       (NVL(source_ref3_, string_null_) = NVL(part_rec_.release_no, string_null_)) AND
       (NVL(source_ref4_, dummy_) = NVL(part_rec_.line_item_no, dummy_))) THEN

      created_by_ := TRUE;
   END IF;

   RETURN created_by_;
END Created_By;


FUNCTION Delivered_To_Internal_Customer (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   latest_sequence_no_         NUMBER;
   history_rec_                Part_Serial_History_API.Public_Rec;
   state_                      part_serial_catalog_tab.rowstate%TYPE;
   deliv_to_internal_customer_ VARCHAR2(5) := Fnd_Boolean_API.DB_FALSE;
BEGIN
   state_ := Get_Objstate(part_no_, serial_no_);

   IF (state_ IN ('Issued', 'UnderTransportation')) THEN
      latest_sequence_no_ := Part_Serial_History_API.Get_Latest_Sequence_No(part_no_, serial_no_);
      history_rec_        := Part_Serial_History_API.Get(part_no_, serial_no_, latest_sequence_no_);

      IF ( history_rec_.order_type = Order_Type_API.DB_CUSTOMER_ORDER ) THEN
         $IF Component_Order_SYS.INSTALLED $THEN
            deliv_to_internal_customer_ := Customer_Order_Line_API.Customer_Is_Internal(history_rec_.order_no,
                                                                                        history_rec_.line_no,
                                                                                        history_rec_.release_no,
                                                                                        history_rec_.line_item_no);
         $ELSE
            Error_SYS.Component_Not_Exist('ORDER');
         $END
      END IF;
   END IF;

   RETURN(deliv_to_internal_customer_);
END Delivered_To_Internal_Customer;


PROCEDURE Disconnect_From_Parent
   (part_no_    IN VARCHAR2,
    serial_no_  IN VARCHAR2) 
IS
   top_serial_state_          part_serial_catalog_tab.rowstate%TYPE;
   transaction_description_   VARCHAR2(2000);
   top_part_no_               part_serial_catalog_tab.part_no%TYPE;
   top_serial_no_             part_serial_catalog_tab.serial_no%TYPE;
   rec_                       Public_Rec;
   hist_rec_                  Part_Serial_History_API.Public_Rec;

BEGIN

   IF (Is_Contained(part_no_, serial_no_) = 'FALSE') THEN
      Error_SYS.Record_General(lu_name_, 'NOTINCONTAINED: Disconnect from parent is allowed only for Serials which are :P1.',Finite_State_Decode__('Contained'));
   END IF;
       


   IF Vim_Serial_Exist___(part_no_,serial_no_) THEN
      Error_SYS.Record_General(lu_name_, 'VIMSEREXISTS: The serial exists in Vehicle Information Management.');
   END IF;


   IF Equipment_Serial_Exist___(part_no_,serial_no_) THEN
      Error_SYS.Record_General(lu_name_, 'EQUIPSEREXISTS: The serial exists in Service Management.');
   END IF;


   Get_Top_Parent( top_part_no_, 
                   top_serial_no_, 
                   part_no_, 
                   serial_no_ );
   

   IF (top_part_no_ IS NULL) OR (top_serial_no_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_,'TOPSERMISSING: Serial [:P1] in state [:P2] does not have a parent serial. Contact System Support', part_no_||','||serial_no_, Finite_State_Decode__('Contained'));
   END IF;

   top_serial_state_ := Get_Objstate(top_part_no_, top_serial_no_);

   IF (top_serial_state_ NOT IN ('Issued','ReturnedToSupplier'))  THEN
      Error_SYS.Record_General(lu_name_, 'TOPWRONGSTATE: Top Part must be ":P1" or ":P2".', Finite_State_Decode__('Issued'), Finite_State_Decode__('ReturnedToSupplier'));
   END IF;
      
   IF top_serial_state_ = 'Issued' THEN

      hist_rec_ := Part_Serial_History_API.Get_Latest_Issue_Transaction(top_part_no_, 
                                                                        top_serial_no_);
      
      IF (NVL(hist_rec_.order_type, string_null_) = 'SHOP ORDER') THEN
         IF NOT Shpord_Completely_Received___(hist_rec_.order_no,
                                              hist_rec_.line_no,
                                              hist_rec_.release_no) THEN
            Error_SYS.Record_General (lu_name_, 'TOPSERSO: Top part Serial [:P1] is issued to Shop Order :P2 which is still not completely received.', top_part_no_||','||top_serial_no_, hist_rec_.order_no);
         END IF;
      END IF;
      
      IF (NVL(hist_rec_.order_type, string_null_) = 'PUR ORDER') THEN
         IF Issued_To_Ext_Service_Order___(hist_rec_.order_no,
                                           hist_rec_.line_no,
                                           hist_rec_.release_no,
                                           top_part_no_,
                                           top_serial_no_) THEN
            Error_SYS.Record_General (lu_name_, 'TOPSERESO: Serial no [:P1] is issued to External Service Order no :P2 still in status Released or Confirmed, and it is not allowed to receive this Serial no on another object.', top_part_no_||','||top_serial_no_, hist_rec_.order_no);
         END IF;
      END IF;
   END IF;

   rec_ := Get(part_no_, serial_no_);

   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'DISCONNECTSERIAL: Serial [:P1] has been disconnected from its parent [:P2] in Part Serial Catalog.', NULL, part_no_||','||serial_no_, rec_.superior_part_no||','||rec_.superior_serial_no);

   Remove_Superior_Info(part_no_, serial_no_, 'Issued', transaction_description_);

END Disconnect_From_Parent;


PROCEDURE Set_Operational_Condition  (
   info_                     OUT VARCHAR2,
   part_no_                  IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   operational_condition_db_ IN  VARCHAR2,
   update_structure_         IN  VARCHAR2,
   validate_structure_       IN  VARCHAR2,
   initial_replace_date_     IN  DATE    DEFAULT NULL,
   reversing_earlier_update_ IN  BOOLEAN DEFAULT FALSE )
IS
   update_structure_local_    BOOLEAN := FALSE;
   validate_structure_local_  BOOLEAN := FALSE;
BEGIN
   
   Fnd_Boolean_API.Exist_Db(update_structure_);
   Fnd_Boolean_API.Exist_Db(validate_structure_);
   Serial_Operational_Cond_API.Exist_Db(operational_condition_db_); 
      
   IF (update_structure_ = 'TRUE') THEN
      update_structure_local_ := TRUE;
   END IF;      
   IF (validate_structure_ = 'TRUE') THEN
      validate_structure_local_ := TRUE;
   END IF; 
   
   Set_Operational_Condition___(info_,
                                part_no_                  => part_no_,
                                serial_no_                => serial_no_,
                                operational_condition_db_ => operational_condition_db_,
                                order_type_               => NULL,                                
                                order_no_                 => NULL,
                                line_no_                  => NULL,
                                release_no_               => NULL,
                                line_item_no_             => NULL,
                                update_structure_         => update_structure_local_,
                                validate_structure_       => validate_structure_local_,
                                initial_replace_date_     => initial_replace_date_,
                                reversing_earlier_update_ => reversing_earlier_update_);

   Check_Dimension_Dependency___(part_no_, serial_no_); 
END Set_Operational_Condition;


PROCEDURE Rename_Non_Vim_Serial (
   part_no_             IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   new_part_no_         IN VARCHAR2,
   new_serial_no_       IN VARCHAR2,
   manufacturer_no_     IN VARCHAR2,
   manu_part_no_        IN VARCHAR2,
   rename_reason_db_    IN VARCHAR2 )
IS
   oldrec_              part_serial_catalog_tab%ROWTYPE;
   eng_part_revision_   part_serial_catalog_tab.eng_part_revision%TYPE;
BEGIN

   IF Get_Objstate(part_no_,serial_no_) NOT IN ('InInventory') THEN
       Error_SYS.Record_General (lu_name_, 'RENAMENOTININVENTORY: Current Position of the serial is not In Inventory and cannot be renamed.');
   END IF;
   IF Vim_Serial_Exist___(part_no_, serial_no_) THEN
      Error_SYS.Record_General (lu_name_, 'RENAMEINVIM: The serial exists in Vehicle Information Management and must be renamed from there.');
   END IF;

   IF Equipment_Serial_Exist___(part_no_, serial_no_) THEN
      Error_SYS.Record_General (lu_name_, 'RENAMEINEQUIP: The serial exists in Service Management and cannot be renamed.');
   END IF;
   
   IF Tool_Equipment_Serial_Exist___(part_no_, serial_no_) THEN
      Error_SYS.Record_General (lu_name_, 'RENAMEINEQUIP: The serial exists in Service Management and cannot be renamed.');
   END IF;

   IF Plant_Object_Serial_Exist___(part_no_, serial_no_) THEN
      Error_SYS.Record_General (lu_name_, 'RENAMEINPLNTOBJ: The serial exists in a Plant Object and cannot be renamed.');
   END IF;

   IF (new_part_no_ != part_no_) THEN
      $IF (Component_Pdmcon_SYS.INSTALLED) $THEN
      oldrec_ := Get_object_By_Keys___(part_no_, serial_no_);
      IF (oldrec_.eng_part_revision IS NOT NULL) THEN
            eng_part_revision_ := Eng_Part_Revision_API.Get_Last_Rev(new_part_no_);
      END IF;
      $ELSE
         NULL;
      $END
   END IF;

   Rename(part_no_,
          serial_no_,
          new_part_no_,
          new_serial_no_,
          manufacturer_no_,
          manu_part_no_,
          eng_part_revision_,
          rename_reason_db_);

END Rename_Non_Vim_Serial;


@UncheckedAccess
FUNCTION In_Stock_But_Not_Identified (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2,
   contract_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   in_stock_but_not_identified_ BOOLEAN := FALSE;
   latest_contract_             VARCHAR2(5);
   transaction_id_              NUMBER;
   identified_in_stock_         NUMBER;
   stmt_                        VARCHAR2(2000); 
BEGIN

   IF (Check_Exist___(part_no_, serial_no_)) THEN
      IF (Is_In_Inventory(part_no_, serial_no_) = Fnd_Boolean_API.db_true) THEN
         transaction_id_ := Part_Serial_History_API.Get_Latest_Inv_Transaction_Id(part_no_, serial_no_);
         stmt_ := 'BEGIN
                      :latest_contract := Inventory_Transaction_Hist_API.Get_Transaction_Contract(:transaction_id);
                   END;';
         @ApproveDynamicStatement(2011-05-14,maeelk)
         EXECUTE IMMEDIATE stmt_
            USING OUT latest_contract_, 
                   IN transaction_id_;
 
         IF (contract_ = latest_contract_) THEN
            stmt_ := 'BEGIN
                         :identified_in_Stock := Inventory_Part_In_Stock_API.Check_Individual_Exist(:part_no, :serial_no);
                      END;';
            @ApproveDynamicStatement(2011-05-14,maeelk)
            EXECUTE IMMEDIATE stmt_
               USING OUT identified_in_stock_,
                      IN part_no_, 
                      IN serial_no_;

            IF (identified_in_stock_ = 0) THEN
               in_stock_but_not_identified_ := TRUE;
            END IF;
         END IF;
      END IF;
   END IF;
   RETURN (in_stock_but_not_identified_);
END In_Stock_But_Not_Identified;


@UncheckedAccess
FUNCTION Get_In_Stock_Not_Identified (
  part_no_  IN VARCHAR2,
  contract_ IN VARCHAR2 ) RETURN Serial_No_Tab
IS
   serial_no_tab_ Serial_No_Tab;
   rows_          PLS_INTEGER := 1; 

   CURSOR get_serials IS
      SELECT serial_no
        FROM part_serial_catalog_tab
       WHERE part_no  = part_no_
         AND rowstate = 'InInventory';
BEGIN
   FOR rec_ IN get_serials LOOP
      IF (In_Stock_But_Not_Identified(part_no_, rec_.serial_no, contract_)) THEN
         serial_no_tab_(rows_).serial_no := rec_.serial_no;
         rows_ := rows_ + 1;
      END IF;
   END LOOP;
   RETURN (serial_no_tab_);
END Get_In_Stock_Not_Identified;


PROCEDURE Set_Tracked_In_Inventory (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.tracked_in_inventory := Fnd_Boolean_API.DB_TRUE;
   Modify___(newrec_);
END Set_Tracked_In_Inventory;

-----------------------------------------------------
-- Disable_Tracked_In_Inventory
--    This methods unchecked the tracked_in_inventory values according to the 
--    given part number.
-----------------------------------------------------
PROCEDURE Disable_Tracked_In_Inventory (
   part_no_ IN VARCHAR2 )
IS
   CURSOR Get_Part_Serials IS
      SELECT *
      FROM   part_serial_catalog_tab
      WHERE  part_no = part_no_
      AND    tracked_in_inventory = Fnd_Boolean_API.DB_TRUE
      FOR UPDATE;

   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   FOR oldrec_ IN Get_Part_Serials LOOP
      newrec_ := oldrec_;
      newrec_.tracked_in_inventory := Fnd_Boolean_API.DB_FALSE;
      Modify___(newrec_);
   END LOOP;   
END Disable_Tracked_In_Inventory;

PROCEDURE Reset_Tracked_In_Inventory (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   newrec_     part_serial_catalog_tab%ROWTYPE;
BEGIN
   newrec_ := Lock_By_Keys___(part_no_, serial_no_);
   newrec_.tracked_in_inventory := Fnd_Boolean_API.DB_FALSE;
   Modify___(newrec_);
END Reset_Tracked_In_Inventory;


@UncheckedAccess
FUNCTION Part_Has_Serials(
   part_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_   NUMBER;
   CURSOR part_serial_exist IS
      SELECT 1
        FROM part_serial_catalog_tab
       WHERE part_no = part_no_;
BEGIN
   OPEN  part_serial_exist;
   FETCH part_serial_exist INTO dummy_;
   IF part_serial_exist%FOUND THEN
      CLOSE part_serial_exist;
      RETURN TRUE;
   ELSE
      CLOSE part_serial_exist;
      RETURN FALSE;
   END IF;
END Part_Has_Serials;


@UncheckedAccess
FUNCTION Generate_Serial_Numbers (
   sequence_from_ IN NUMBER,
   sequence_to_   IN NUMBER,
   prefix_        IN VARCHAR2,
   suffix_        IN VARCHAR2,
   padding_       IN NUMBER  ) RETURN Serial_No_Tab
IS
   serial_no_tab_       Serial_No_Tab;
   loop_counter_        PLS_INTEGER := 0;
BEGIN
   IF ((sequence_from_ IS NOT NULL) AND (sequence_to_ IS NOT NULL)) THEN
      FOR i IN sequence_from_..sequence_to_ LOOP
         serial_no_tab_(loop_counter_).serial_no := Get_Formatted_Serial_No(i, prefix_, suffix_, padding_);
         loop_counter_ := loop_counter_ + 1;
      END LOOP;
   END IF;
   RETURN (serial_no_tab_);
END Generate_Serial_Numbers;


@UncheckedAccess
FUNCTION Get_Formatted_Serial_No (
   serial_no_ IN VARCHAR2,
   prefix_    IN VARCHAR2,
   suffix_    IN VARCHAR2,
   padding_   IN NUMBER ) RETURN VARCHAR2
IS
   formatted_serial_no_ part_serial_catalog_tab.serial_no%TYPE;
BEGIN
   formatted_serial_no_  := prefix_ || LPAD(serial_no_, GREATEST(LEAST(NVL(padding_, 0) , GREATEST(50 - NVL(LENGTH(prefix_||suffix_), 0), 0)), LENGTH(serial_no_)), 0) || suffix_;
   RETURN (formatted_serial_no_);
END Get_Formatted_Serial_No;


FUNCTION Has_Alphanumeric_Serial (
   part_no_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR get_serials IS
      SELECT serial_no
      FROM   part_serial_catalog_tab
      WHERE  part_no = part_no_;
   
   n_serial_   NUMBER;
BEGIN
   FOR serial_rec_ IN get_serials LOOP
      n_serial_ := TO_NUMBER(serial_rec_.serial_no);
   END LOOP;
   RETURN FALSE;
   
EXCEPTION
   WHEN OTHERS THEN
      RETURN TRUE;  
END Has_Alphanumeric_Serial;

-- Remove_Warranty_Dates
--   Called by customer order when undoing serial part deliveries
PROCEDURE Remove_Warranty_Dates (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2 )
IS
   cust_warranty_id_ NUMBER;
   sup_warranty_id_  NUMBER;
BEGIN
   cust_warranty_id_ := Get_Cust_Warranty_Id(part_no_, serial_no_);
   sup_warranty_id_  := Get_Sup_Warranty_Id(part_no_, serial_no_);
   IF (cust_warranty_id_ IS NOT NULL) THEN
      Remove_Cust_Warranty_Dates(part_no_, serial_no_, cust_warranty_id_);
   END IF;
   IF (sup_warranty_id_ IS NOT NULL) THEN
      Remove_Sup_Warranty_Dates(part_no_, serial_no_, sup_warranty_id_);
   END IF;
END Remove_Warranty_Dates;
   
-- Remove_Cust_Warranty_Dates
--   Called by customer order when undoing serial part deliveries
PROCEDURE Remove_Cust_Warranty_Dates (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   cust_warranty_id_ IN NUMBER )
IS
   CURSOR get_children IS
      SELECT part_no, serial_no
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no   = part_no_
      AND    superior_serial_no = serial_no_
      AND    cust_warranty_id   = cust_warranty_id_;
BEGIN
   Serial_Warranty_Dates_API.Remove_Serial(part_no_, serial_no_, cust_warranty_id_);
   FOR child_rec_ IN get_children  LOOP
      Remove_Cust_Warranty_Dates(child_rec_.part_no, child_rec_.serial_no, cust_warranty_id_);
   END LOOP;
END Remove_Cust_Warranty_Dates;

-- Remove_Sup_Warranty_Dates
--   Called by customer order when undoing serial part deliveries
PROCEDURE Remove_Sup_Warranty_Dates (
   part_no_          IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   sup_warranty_id_  IN NUMBER )
IS
   CURSOR get_children IS
      SELECT part_no, serial_no
      FROM   part_serial_catalog_tab
      WHERE  superior_part_no   = part_no_
      AND    superior_serial_no = serial_no_
      AND    sup_warranty_id    = sup_warranty_id_;
BEGIN   
   Serial_Warranty_Dates_API.Remove_Serial(part_no_, serial_no_, sup_warranty_id_);
   FOR child_rec_ IN get_children  LOOP
      Remove_Sup_Warranty_Dates(child_rec_.part_no, child_rec_.serial_no, sup_warranty_id_);
   END LOOP;
END Remove_Sup_Warranty_Dates;

PROCEDURE Set_Fa_Object_Reference(
   part_no_                     IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   fa_object_company_           IN VARCHAR2,
   fa_object_id_                IN VARCHAR2,
   fa_object_system_defined_db_ IN VARCHAR2 )
IS
   objid_                         part_serial_catalog.objid%TYPE;
   objversion_                    part_serial_catalog.objversion%TYPE;
   oldrec_                        part_serial_catalog_tab%ROWTYPE;
   newrec_                        part_serial_catalog_tab%ROWTYPE;
   transaction_description_       part_serial_catalog_tab.latest_transaction%TYPE;
   object_state_                  VARCHAR2(20);
 BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, serial_no_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   IF ((fa_object_company_ IS NOT NULL AND fa_object_id_ IS NULL) OR 
       (fa_object_company_ IS NULL AND fa_object_id_ IS NOT NULL))THEN 
      Error_SYS.Record_General(lu_name_, 'INVALIDFAOBJREF; It is not possible to connect an Object unless both Asset Owner and Object ID has a value.');  
   END IF;
    
   IF (Validate_SYS.Is_Changed(oldrec_.fa_object_company, fa_object_company_) OR 
       Validate_SYS.Is_Changed(oldrec_.fa_object_id, fa_object_id_)) THEN 
       
      IF (fa_object_company_ IS NOT NULL AND fa_object_id_ IS NOT NULL) THEN 
         IF (oldrec_.fa_object_company IS NOT NULL AND oldrec_.fa_object_id IS NOT NULL) THEN 
            Error_SYS.Record_General(lu_name_,'FAALREADYCONTD: It is not possible to connect to Object :P1, as the Serial is already connected to Object :P2.',
                                        fa_object_id_, oldrec_.fa_object_id);
         END IF;
         IF (oldrec_.part_ownership != Part_Ownership_API.DB_COMPANY_RENTAL_ASSET) THEN 
            Error_SYS.Record_General(lu_name_,'FAINVALOWNERSHIP: It is not possible to connect to an Object when the part ownership is :P1.',
            Part_Ownership_API.Decode(oldrec_.part_ownership));
         END IF;

         $IF Component_Fixass_SYS.INSTALLED $THEN
            object_state_ := Fa_Object_API.Get_Objstate(fa_object_company_, fa_object_id_);
            IF (object_state_ IN ('Replaced', 'Scrapped', 'Sold')) THEN 
               Error_SYS.Record_General(lu_name_,'INVALIDFASTATE: It is not possible to connect a Serial to an Object with an Object Status of :P1.',
                                        Fa_Object_API.Finite_State_Decode__(object_state_));
            END IF;
         $ELSE
            Error_SYS.Component_Not_Exist('FIXASS');   
         $END
      END IF;

      newrec_ := oldrec_;
      newrec_.fa_object_company        := fa_object_company_;
      newrec_.fa_object_id             := fa_object_id_;
      newrec_.fa_object_system_defined := fa_object_system_defined_db_;
      Modify___(newrec_);

      IF (fa_object_company_ IS NOT NULL AND fa_object_id_ IS NOT NULL) THEN 
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'FAOBJCONNECTED: Connected to FA object :P1 in company :P2.', NULL, fa_object_id_, fa_object_company_);
      ELSE
         transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'FAOBJDISCONNECTED: Disconnected from FA object :P1 in company :P2.', NULL, oldrec_.fa_object_id, oldrec_.fa_object_company);
      END IF;

      Part_Serial_History_API.New(part_no_                  => newrec_.part_no,
                                  serial_no_                => newrec_.serial_no,
                                  history_purpose_db_       => 'INFO',
                                  transaction_description_  => transaction_description_,
                                  fa_object_company_        => fa_object_company_,
                                  fa_object_id_             => fa_object_id_);
   END IF;                               
END Set_Fa_Object_Reference;  

@UncheckedAccess
FUNCTION Get_Fa_Object_Company (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_serial_catalog_tab.fa_object_company%TYPE;
   
   CURSOR get_fa_object_company IS
      SELECT fa_object_company
      FROM part_serial_catalog_tab
      WHERE part_no   = part_no_
      AND serial_no = serial_no_;
BEGIN
   IF (part_no_ IS NULL OR serial_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
      
   OPEN get_fa_object_company;
   FETCH get_fa_object_company INTO temp_;
   CLOSE get_fa_object_company;
   RETURN temp_;
END Get_Fa_Object_Company;

@UncheckedAccess   
FUNCTION Get_Fa_Object_Id (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_serial_catalog_tab.fa_object_id%TYPE;
   
   CURSOR get_fa_object_id IS
      SELECT fa_object_id
      FROM part_serial_catalog_tab
      WHERE part_no   = part_no_
      AND serial_no = serial_no_;
BEGIN
   IF (part_no_ IS NULL OR serial_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
      
   OPEN get_fa_object_id;
   FETCH get_fa_object_id INTO temp_;
   CLOSE get_fa_object_id;
   RETURN temp_;
END Get_Fa_Object_Id;

@UncheckedAccess
FUNCTION Serials_With_Fa_Object_Exists(
  fa_object_company_    IN VARCHAR2,
  fa_object_id_         IN VARCHAR2) RETURN VARCHAR2 
IS 
   temp_          NUMBER;
   serials_exist_ VARCHAR2(5):= 'FALSE';
   
   CURSOR get_part_serials IS
      SELECT 1
      FROM part_serial_catalog_tab
      WHERE fa_object_company = fa_object_company_
      AND fa_object_id = fa_object_id_;
BEGIN
   OPEN get_part_serials;
   FETCH get_part_serials INTO temp_;
   IF (get_part_serials%FOUND)THEN 
      serials_exist_ := 'TRUE'; 
   END IF;   
   CLOSE get_part_serials;
   RETURN serials_exist_; 
END Serials_With_Fa_Object_Exists;


PROCEDURE Check_Rename_Part_No (
   old_part_no_ IN VARCHAR,
   new_part_no_ IN VARCHAR2 )
IS
   old_part_rec_ Part_Catalog_API.Public_Rec;
   new_part_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   -- check part exist in part catalog
   Part_Catalog_API.Exist(old_part_no_);
   Part_Catalog_API.Exist(new_part_no_);

   old_part_rec_ := Part_Catalog_API.Get(old_part_no_);
   new_part_rec_ := Part_Catalog_API.Get(new_part_no_);

   IF (old_part_no_ != new_part_no_) THEN
      -- unit of measure
      IF (old_part_rec_.unit_code != new_part_rec_.unit_code) THEN
         Error_SYS.Record_General(lu_name_, 'UOMNOTMATCH: Unit of measure should be the same for parts :P1 and :P2.', old_part_no_, new_part_no_);
      END IF;
      -- condition code usage
      IF (old_part_rec_.condition_code_usage != new_part_rec_.condition_code_usage) THEN
         Error_SYS.Record_General(lu_name_, 'COCONOMATCH: Condition Code Usage does not match for parts :P1 and :P2.', old_part_no_, new_part_no_);
      END IF;
      -- lot tracking code
      IF (old_part_rec_.lot_tracking_code != new_part_rec_.lot_tracking_code) THEN
         Error_SYS.Record_General(lu_name_, 'LOTTRNOMATCH: Lot Tracking Codes do not match for parts :P1 and :P2.', old_part_no_, new_part_no_);
      END IF;

      -- multi-level tracking code
      IF (old_part_rec_.multilevel_tracking != new_part_rec_.multilevel_tracking) THEN
         Error_SYS.Record_General(lu_name_, 'MLTLNOMATCH: Multi-level Tracking settings do not match for parts :P1 and :P2.', old_part_no_, new_part_no_);
      END IF;

      -- receipt and issue serial tracking code
      IF (old_part_rec_.serial_tracking_code != new_part_rec_.serial_tracking_code) THEN
         Error_SYS.Record_General(lu_name_, 'SERTRACK: Part :P2 need to have the same setting for Inventory Serial Tracking as Part :P1.', old_part_no_, new_part_no_);
      END IF;
      -- inventory serial tracking code
      IF (old_part_rec_.receipt_issue_serial_track != new_part_rec_.receipt_issue_serial_track) THEN
         Error_SYS.Record_General(lu_name_, 'INVSERTRACK: Part :P2 need to have the same setting for Receipt and Issue Serial Tracking as Part :P1.', old_part_no_, new_part_no_);
      END IF;
      -- eng serial tracking code
      IF (old_part_rec_.eng_serial_tracking_code != new_part_rec_.eng_serial_tracking_code) THEN
         Error_SYS.Record_General(lu_name_, 'ENGSERTRACK: Part :P2 need to have the same setting for Engineering Serial Tracking as Part :P1.', old_part_no_, new_part_no_);
      END IF;
      -- configured parts
      IF (old_part_rec_.configurable ='CONFIGURED') OR (new_part_rec_.configurable ='CONFIGURED') THEN
         Error_SYS.Record_General(lu_name_, 'CONFIGURED: Neither :P1 nor :P2 part may be a Configured part.', old_part_no_, new_part_no_);
      END IF;
   END IF;

   -- input meas group id
   IF (old_part_rec_.input_unit_meas_group_id IS NOT NULL) OR (new_part_rec_.input_unit_meas_group_id IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_,'INPUTUOM: Input Unit of Measure Groups may not have any values assigned for parts :P1 and :P2.', old_part_no_, new_part_no_);
   END IF;
   -- catch unit
   IF (old_part_rec_.catch_unit_enabled = 'TRUE') OR (new_part_rec_.catch_unit_enabled = 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'CAUNITNOMATCH: Catch Unit may not be set to Enabled for parts :P1 and :P2 in Part Catalog.', old_part_no_, new_part_no_);
   END IF;
   --position_part
   IF (new_part_rec_.position_part = 'POSITION PART') THEN
      Error_SYS.Record_General(lu_name_, 'TOPOSPART: Part No :P1 may not be a position part.',old_part_no_);
   END IF;   
END Check_Rename_Part_No;


-- Consume_Customer_Consignment
--   Serial stay in position 'Issued' and the operational status for the serial will not change. 
--   New Serial Trnasaction History record will be created at customer consignment stock's consumption.
--   Ownership will be changed and warranty will be started.
PROCEDURE Consume_Customer_Consignment ( 
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   order_no_                IN VARCHAR2,
   line_no_                 IN VARCHAR2,
   release_no_              IN VARCHAR2,
   line_item_no_            IN NUMBER,
   order_type_              IN VARCHAR2,
   inv_transaction_id_      IN NUMBER )
IS
   transaction_description_ part_serial_catalog_tab.latest_transaction%TYPE;
   cust_warranty_id_        NUMBER;
   site_date_               DATE := Sysdate;
BEGIN
   Set_Ownership_After_Issue___(part_no_, serial_no_, order_no_, line_no_, release_no_, line_item_no_, order_type_);
   
   transaction_description_ := Language_SYS.Translate_Constant(lu_name_, 'PSCCCSOE: Reported Consumed on customer consignment stock order :P1', NULL, order_no_ ||' '|| line_no_ ||' '|| release_no_);
   Modify_Latest_Transaction(part_no_                 => part_no_,
                             serial_no_               => serial_no_,
                             latest_transaction_      => transaction_description_,
                             transaction_description_ => transaction_description_,
                             history_purpose_db_      => 'INFO',
                             order_type_              => order_type_,
                             order_no_                => order_no_,
                             line_no_                 => line_no_,
                             release_no_              => release_no_,
                             line_item_no_            => line_item_no_,
                             inv_transaction_id_      => inv_transaction_id_);
   
   -- Start warranty at consumption
   $IF Component_Order_SYS.INSTALLED $THEN
      cust_warranty_id_ := Customer_Order_Line_API.Get_Cust_Warranty_Id(order_no_, line_no_, release_no_, line_item_no_);
   $ELSE
      Error_SYS.Component_Not_Exist('ORDER');
   $END
   IF (cust_warranty_id_ IS NOT NULL) THEN
      Set_Or_Merge_Cust_Warranty(part_no_, serial_no_, cust_warranty_id_);
   END IF;      
   $IF (Component_Mpccom_SYS.INSTALLED) $THEN
      site_date_ := Site_API.Get_Site_Date(contract_); 
   $END
   Serial_Warranty_Dates_API.Calculate_Warranty_Dates(part_no_, serial_no_, site_date_);
END Consume_Customer_Consignment;

