-----------------------------------------------------------------------------
--
--  Logical unit: MaterialRequisReservat
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200311  DaZase  SCXTEND-3803, Small change in Create_Data_Capture_Lov to change 1 param in call to Data_Capture_Session_Lov_API.New.
--  191212  DaZase  SCXTEND-1005, Changed the dynamic selects in methods Create_Data_Capture_Lov, Get_Column_Value_If_Unique and
--  191212          Record_With_Column_Value_Exist to increase performance. Also changed Get_Column_Value_If_Unique to have distinct select and 
--  191212          'FETCH FIRST 2 ROWS ONLY' statement and use a collection instead of having a loop to increase performance.
--  190512  LaThlk  Bug 146270(SCZ-4649), Overridden the method Check_Common___() by validating the supply code and activity sequence in order to maintain consistency of the client and server.
--  190512          Modified Make_Part_Reservations() to Retrieve the qty_to_assign by locking the MR line record.
--  171113  DaZase  STRSC-8865, Added inv_barcode_validation_ parameter and handling of it in Record_With_Column_Value_Exist.
--  171018  DAYJLK  STRSC-12459, Modified Make_Delivery___ to prevent issue of material requisition reserved quantity assigned to transport task lines.
--  171010  DAYJLK  STRSC-12459, Added Post_Update_Actions___ which is invoked in Update___ to sync changes in Transport Task connected reservations.
--  170822  DAYJLK  STRSC-11598, Added new method Lock_Res_And_Fetch_Info which is used when creating transport task for material requisitions.
--  170818  DAYJLK  STRSC-11526, Added method Reserve_Or_Unreserve_On_Swap to perform move of reserved stock.
--  160729  Chfose  LIM-7791, Added inventory_event_id_ to Make_Item_Delivery and Make_Line_Delivery-methods
--  151104  DaZase  LIM-4281, Changed methods Create_Data_Capture_Lov/Get_Column_Value_If_Unique/Record_With_Column_Value_Exist so they now use 
--  151104          MATERIAL_REQUIS_RESERVAT_PUB instead of table, added param column_value_nullable_ to Record_With_Column_Value_Exist.
--  150729  BudKlk  Bug 123377, Modified the method Create_Data_Capture_Lov() in order to use Utility_SYS.String_To_Number()
--  150707  IsSalk  KES-907, Added reference-by-name for the parameter list when calling the method Inventory_Part_In_Stock_API.Issue_Part().
--  150729          method call in ORDER BY clause to sort string and number values seperately.
--  150527  DaZase  COB-439, Changed Create_Data_Capture_Lov to handle new version of Data_Capture_Session_Lov_API.New and the new set of parameters it needs.
--  150512  IsSalk  KES-423, Passed  new parameter source_ref5_ to Inventory_Part_In_Stock_API.Issue_Part.
--  150520  DaZase  COB-437, Removed 100 record description limitation in method Create_Data_Capture_Lov, 
--  150520          this will be replaced with a new configurable LOV record limitation in WADACO framework.
--  150409  LEPESE  LIM-75, additional work to make file compile because of handling_unit_id being new key in InventoryPartInStock.
--  150407  JeLise  LIM-93, Added new key column handling_unit_id.
--  150202  DaZase  PRSC-5642, Made some changes in Check_Exist, Create_Data_Capture_Lov, Record_With_Column_Value_Exist and Create_Data_Capture_Lov so this code match the one from WDC extension better.
--  141217  DaZase  PRSC-1611, Added extra column check in method Create_Data_Capture_Lov to avoid any risk of getting sql injection problems.
--  141215  UdGnlk  PRSC-4609, Added annotation Approve Dynamic Statement which were missing.
--  141024  RuLiLk  Bug 113690, Added method Check_Exist(). Renamed methods Get_Qty_Assigned_Unique as Get_Qty_Assigned_If_Unique
--  141024          and Check_Valid_Value as Record_With_Column_Value_Exist
--  141024  DaZase  Get_Qty_Assigned_Unique, Get_Column_Value_If_Unique, Create_Data_Capture_Lov, Check_Valid_Value
--  140123  Matkse  Modified Update_Assigned by removing incorrect use of lu_rec_ in context New.
--  120905  SBalLK  Bug 104491, Modified Make_Part_Reservations() and Add_Assigned() methods to avoid part reservation if the reservation quantity is 0.
--  120905          Modified Update___() and Add_Assigned() methods to remove the reservation record if the issued quantity is 0.
--  120126  MaEelk  Changed the foramt of last_activity_date from DATE to DATE/DATETIME in view comments. 
--  111028  NISMLK  SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  111026  MaEelk  Added UAS Filter to MATERIAL_REQUIS_RESERVAT.
--  111012  LEPESE  Modification in Identify_Serials___ to pass part_no and lot_batch_no in call to
--  111012          Temporary_Part_Tracking_API.Get_And_Remove_Serials.
--  110817  LEPESE  Modification in Identify_Serials___ to only process stock records with serial_no = '*'.
--  110330  LEPESE  Modified cursor get_stock_record_keys in method Get_Stock_Record_Keys___ by 
--  110330          adding the condition qty_assigned > 0.
--  110330  LEPESE  Modification in Make_Item_Delivery to split reservation into serials.
--  110321  RaKalk  Added part_tracking_session_id_ parameter to Make_Item_Delivery procedure.
--  101116  PraWlk  Bug 94345, Modified Make_Part_Reservations() by adding an IF condition to update the shortage quantity 
--  101116          in MR line only when it is not zero. 
--  101210  LEPESE  Changed call from Inventory_Part_In_Stock_API.Split_Reservation_Into_Serials to
--  101210          Inventory_Part_In_Stock_API.Split_Into_Serials in Identify_Serials___.
--  101210  LEPESE  Added methods Identify_Serials___, Get_Stock_Record_Keys___. Changed overloaded method
--  101210          Make_Line_Delivery into an implementation method Make_Line_Delivery___.
--  101208  RaKalk  Added overloaded Make_Line_Delivery procedure with part tracking session id parameter.
--  101206  RaKalk  Added function Get_Unidentified_Serials
--  100505  KRPELK  Merge Rose Method Documentation.
--  100504  Nuvelk  TWIN PEAKS Merge.
            --  100223  ShRalk  Jira-key TWINPK-699 Modified declaration type of order_class_decoded_ to VARCHAR2(32) in Unpack_Check_Update___.
--  090930  ChFolk  Removed un used parameter configuration_id_ from Validate_Qty_Assigned___.
--  --------------------------------- 14.0.0 ----------------------------------
--  090729  DAYJLK  Bug 84708, Reversed previous changes and added procedure Check_Issue. Modified procedure Make_Delivery___ 
--  090729          to prevent more quantity being issued than the quantity that is reserved.
--  090727  DAYJLK  Bug 84708, Modified methods Make_Line_Delivery and Make_Item_Delivery by placing checks to 
--  090727          prevent the Issue of parts when the Material Requisition line is in status Closed.
--  090701  SaWjlk  Bug 83767, Decoded the db value to the client value in the Procedure Unpack_Check_Update___.  
--  070711  ChBalk  Bug 65250, Modified methods Make_Item_Delivery and Make_Delivery___ 
--  070711          to add a parameter catch_qty_to_ship_.
--  070126  Cpeilk  Bug 62379, Added method Validate_Qty_Assigned___ to display meaningful messages instead of existing messages.
--  070126  Cpeilk  Bug 62345, Modified the procedure Add_Assigned to handle the material requistion line Close option.
--  060220  NuFilk  Added 'NOCHECK' option which previously existed to column Activity_Seq in view.
--  060131  GeKalk  Added configuration_id to Update_Assigned method.
--  051207  KanGlk  Modified the error message 'AVAILIDMANRES'.
--  051021  SaNalk  Added configuration_id to Add_Assigned and Unpack_Check_Insert___.
--  050921  NiDalk  Removed unused variables.
--  041102  ErSolk  Bug 47411, Moved location_type validation to procedure Unpack_Check_Insert___.
--  041102  IsAnlk  Modified Inventory_Part_In_Stock_API.Issue_Part call by adding catch_quantity_.
--  041014  SaJjlk  Added parameter catch_quantity_ to method calls Inventory_Part_In_Stock_API.Reserve_Part.
--  040616  JOHESE  Added activity_seq to primary key
--  040506  DaZaSe  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ---------------- EDGE Package Group 3 Unicode Changes --------------------
--  -------------------------------- 13.3.0 ----------------------------------
--  030804  DAYJLK  Performed SP4 Merge.
--  030508  CARASE  Bug 32190, Duplicate Procedure Make_Item_Delivery and Make_Line_Delivery add info attribute in the interface.
--  020523  NASALK  Extended length of Serial no from VARCHAR2(15) to VARCHAR2(50) in view comments
--  020327  Memeus  Bug 28722, used parameter order_class_ instead of order_class_client in
--                  Inventory_Part_In_Stock_API.Issue_Part on procedure Make_Delivery___.
--  020325  ANHO    Added check in Make_Part_Reservations regarding the manual reservation flag
--                  on availability control id in InventoryPartInStock.
--  011004  SuSalk  Bug 24658 fix,Extend the length of 'Company' to VARCHAR2(20).
--  001220  PaLj    CID 51751. Included an error massage inMake_Part_Reservations,
--                  not allowing unreservation from a wrong location.
--  000925  JOHESE  Added undefines.
--  000830  JOHESE  Added primary key configuration_id.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  990919  ROOD    Replaced Utility_SYS.Get_User with Fnd_Session_API.Get_Fnd_User.
--  990508  DAZA    Changed so inparam order_class in Make_Delivery___ is db value now.
--  990421  DAZA    General performance improvements.
--  990414  DAZA    Upgraded to performance optimized template.
--  990401  SHVE    Increased length of user_name_ from 25 to 30 characters.
--  990303  ANHO    Added handling for status_code in Add_Assigned.
--  990205  ROOD    Added call to Check_Mandatory_Code_Parts in method Make_Delivery___.
--  981228  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  981125  FRDI    Full precision for UOM, change comments in tab.
--  980720  FRDI    Reconstruction of inventory location key
--  980429  LEPE    Changed cursor to select from view instead of table in
--                  procedure Make_Line_Delivery.
--  980226  ANHO    Changed the values of status_code_ in procedure Add_Assigned.
--  980224  ANHO    Added function Get_Qty_Assigned.
--  971201  GOPE    Upgrade to fnd 2.0
--  971111  JOHNI   Added order_class_db in view.
--  971006  LEPE    Added NOCHECK option for REF=InventoryPartLocation.
--  970813  RaKu    BUG 97-0092. Changed procedure Add_Assigned where 'delete'-check is made.
--  970731  NAVE    Mpccom_sys_param.get_parameter_value1('shortage handling') should be
--                  compared to gen_yes_no_api.get_db_value instead of client_value.
--  970711  CHAN    Added recalculation of shortages when doing manual reservations.
--  970424  CHAN    Added control when reserve and issue part. Pallet locations
--                  are not available for material requisitions.
--  970403  GOPE    Bug 97-0015. Possible to to unreserve by reserving negativ qty
--                  in method Make_Part_Reservations
--  970313  CHAN    Changed table name: mpc_intorder_assign is replaced by
--                  material_requis_reservat_tab
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  970126  MAOR    Added to_number when get line_item_no in
--                  Unpack_Check_Insert___
--  970113  AnAr    Fixed PROCEDURE Add_Assigned.
--  970108  AnAr    Changed Onhand_Analysis_Flag.
--  961210  AnAr    Made Workbench compatible.
--                  Renamed methods and removed obsolete methods.
--  961128  MAOR    Changed order of parameters in call to
--                  Inventory_Transaction_Hist_API.Do_Booking.
--  961125  AnAr    Changed all calls to Material_Requis_Line_Api
--  961118  MAOR    Changed call to Inventory_Part_API.Get_Analysis_Flag. Use
--                  Inventory_Part_API.Get_Onhand_Analysis_Flag instead.
--  961114  MAOR    Changed order of part_no and contract in call to
--                  Inventory_Part_API.Get_Analysis_Flag.
--  960901  PEKR    Replaced calls to Mpc_Inv_Accounting_Pkg.Do_Booking with
--                  Inventory_Transaction_Hist_API.Do_Booking.
--  960828  JOKE    Changed return value on Check_Exist_Reservation to number.
--  960827  JOKE    Added function Check_Exist_Reservation.
--  960731  JOHNI   Splitted long lines.
--  960607  JOBE    Added functionality to CONTRACT.
--  960528  SHVE    Replaced call to Mpc_Onhand_Analysis_Pkg with call to
--                  Inventory_Part_Location_API.Make_Onhand_Analysis.
--  960523  MAOS    Modified and renamed New_Assigned to
--  960502  MAOS    Removed call to dual when fetching user.
--  960403  JICE    BUG 96-0073 - Make_Part_Reservation cleaned up from
--                  unintentional code
--  960322  SHVE    Added procedure New_Assigned.
--  960321  JICE    Fixed error texts for localization
--  960307  JICE    Renamed from IntorderAssign
--  951217  JICE    Removed procedure for printing picklist - report-table
--                  does not exist for current release.
--  951109  BJSA    Base Table to Logical Unit Generator 1.0
--  951211  OYME    Added method Report_Intorder_Picklist
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_             CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Make_Delivery___
--   Deliver the requisition line.
--   Takes out from inventory part location and updates the material requisition line.
PROCEDURE Make_Delivery___ (
   result_              IN OUT VARCHAR2,
   order_class_         IN     VARCHAR2,
   order_no_            IN     VARCHAR2,
   line_no_             IN     VARCHAR2,
   release_no_          IN     VARCHAR2,
   line_item_no_        IN     NUMBER,
   part_no_             IN     VARCHAR2,
   contract_            IN     VARCHAR2,
   configuration_id_    IN     VARCHAR2,
   location_no_         IN     VARCHAR2,
   lot_batch_no_        IN     VARCHAR2,
   serial_no_           IN     VARCHAR2,
   waiv_dev_rej_no_     IN     VARCHAR2,
   eng_chg_level_       IN     VARCHAR2,
   activity_seq_        IN     NUMBER,
   handling_unit_id_    IN     NUMBER,
   qty_to_ship_         IN     NUMBER,
   catch_qty_to_ship_   IN     NUMBER )
IS
   attr_               VARCHAR2(32000);
   new_assigned_       NUMBER;
   new_issued_         NUMBER;
   pre_accounting_id_  NUMBER;
   company_            VARCHAR2(20);
   source_identifier_  VARCHAR2(200);
   lu_rec_             MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   oldrec_             MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   newrec_             MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   no_assignments      EXCEPTION;
   order_class_client_ MATERIAL_REQUIS_RESERVAT.order_class%TYPE;
   objid_              MATERIAL_REQUIS_RESERVAT.objid%TYPE;
   objversion_         MATERIAL_REQUIS_RESERVAT.objversion%TYPE;
   catch_quantity_     NUMBER;
   indrec_             Indicator_Rec;
BEGIN
   order_class_client_ := Material_Requis_Type_API.Decode(order_class_);
   result_             := 'SUCCESS';

   lu_rec_ := Lock_By_Keys___(order_class_, order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_);

   IF lu_rec_.qty_assigned <= 0 THEN
      RAISE no_assignments;
   END IF;

   -- Check that Pre Posting is made if it is mandatory
   pre_accounting_id_ := Material_Requis_Line_API.Get_Pre_Accounting_Id(order_no_, line_no_, release_no_);
   company_           := Site_API.Get_Company(contract_);
   -- The identifier have to be translated BEFORE it is passed on.
   source_identifier_ := Language_SYS.Translate_Constant(lu_name_, 'SOURCEIDENTIFIER: Line :P1 in Material Requisition :P2', Language_SYS.Get_Language, line_no_, order_no_);
   Trace_SYS.Field('SOURCE IDENTIFIER', source_identifier_);
   Pre_Accounting_API.Check_Mandatory_Code_Parts(pre_accounting_id_, 'M107', company_, source_identifier_);

   Inventory_Part_In_Stock_API.Exist(contract_, 
                                     part_no_, 
                                     configuration_id_, 
                                     location_no_, 
                                     lot_batch_no_, 
                                     serial_no_, 
                                     eng_chg_level_, 
                                     waiv_dev_rej_no_, 
                                     activity_seq_, 
                                     handling_unit_id_);

   IF (lu_rec_.qty_assigned - qty_to_ship_) < 0 THEN
      Error_SYS.Record_General(lu_name_, 'MROVERISSUE: The quantity being issued cannot exceed the reserved quantity on a material requisition line.');
   END IF;   
   new_assigned_  := greatest(lu_rec_.qty_assigned - qty_to_ship_, 0);
   new_issued_    := lu_rec_.qty_issued + qty_to_ship_;

   IF (qty_to_ship_ > 0) THEN       
      IF Transport_Task_Line_API.Reservation_Booked_For_Transp(from_contract_         => contract_,
                                                               from_location_no_      => location_no_,
                                                               part_no_               => part_no_,
                                                               configuration_id_      => configuration_id_,
                                                               lot_batch_no_          => lot_batch_no_,
                                                               serial_no_             => serial_no_,
                                                               eng_chg_level_         => eng_chg_level_,
                                                               waiv_dev_rej_no_       => waiv_dev_rej_no_,
                                                               activity_seq_          => activity_seq_,
                                                               handling_unit_id_      => handling_unit_id_,
                                                               order_ref1_            => order_no_,
                                                               order_ref2_            => line_no_,
                                                               order_ref3_            => release_no_,
                                                               order_ref4_            => line_item_no_,
                                                               pick_list_no_          => NULL,
                                                               shipment_id_           => NULL,
                                                               order_type_db_         => Order_Type_API.DB_MATERIAL_REQUISITION) THEN                     
         Error_SYS.Record_General(lu_name_, 'NOTPROCEEDTOISSUE: Issue is not possible when there exist reservations connected to transport task' );
      END IF;
   END IF;

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'QTY_ASSIGNED', new_assigned_, attr_ );
   Client_SYS.Add_To_Attr( 'QTY_ISSUED', new_issued_, attr_ );

   -- Modify
   oldrec_ := lu_rec_;
   newrec_ := lu_rec_;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);

   catch_quantity_ := catch_qty_to_ship_;
   Inventory_Part_In_Stock_API.Issue_Part(catch_quantity_      => catch_quantity_,
                                          contract_            => contract_,
                                          part_no_             => part_no_,
                                          configuration_id_    => configuration_id_,
                                          location_no_         => location_no_,
                                          lot_batch_no_        => lot_batch_no_,
                                          serial_no_           => serial_no_,
                                          eng_chg_level_       => eng_chg_level_,
                                          waiv_dev_rej_no_     => waiv_dev_rej_no_,
                                          activity_seq_        => activity_seq_,
                                          handling_unit_id_    => handling_unit_id_, 
                                          transaction_         => 'INTSHIP',
                                          quantity_            => qty_to_ship_,
                                          quantity_reserved_   => qty_to_ship_,
                                          source_ref1_         => order_no_,
                                          source_ref2_         => line_no_,
                                          source_ref3_         => release_no_,
                                          source_ref4_         => line_item_no_,
                                          source_ref5_         => NULL,
                                          source_              => order_class_); 

   Material_Requis_Line_API.Update_Intorder_Detail( order_class_client_, order_no_, line_no_, release_no_, line_item_no_, qty_to_ship_);
EXCEPTION
   WHEN no_assignments THEN
      result_ := 'NO_ASSIGNMENTS';
END Make_Delivery___;


-- Validate_Qty_Assigned___
--   This method is used to validate field qty_assigned.
PROCEDURE Validate_Qty_Assigned___ (
   order_class_      IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_assigned_     IN NUMBER )
IS
   qty_reserved_ NUMBER;
BEGIN
   qty_reserved_ := Get_Qty_Assigned(order_class_,
                                     order_no_,
                                     line_no_,
                                     release_no_,
                                     line_item_no_,
                                     part_no_,
                                     contract_,
                                     configuration_id_,
                                     location_no_,
                                     lot_batch_no_,
                                     serial_no_,
                                     waiv_dev_rej_no_,
                                     eng_chg_level_,
                                     activity_seq_,
                                     handling_unit_id_);

   IF (qty_assigned_ < 0) THEN
      Error_SYS.Record_General(lu_name_, 'UNRES_LOC: Cannot unreserve more than the reserved :P1 from the Inventory Location :P2', qty_reserved_, location_no_);
   END IF;
END Validate_Qty_Assigned___;


-- Remove___
--   Check and Delete a specific LU-object from the database.
PROCEDURE Remove___ (
   order_class_db_   IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER )
IS
   objid_         MATERIAL_REQUIS_RESERVAT.objid%TYPE;
   objversion_    MATERIAL_REQUIS_RESERVAT.objversion%TYPE;
   remrec_        MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
BEGIN
   remrec_ := Lock_By_Keys___(order_class_db_,
                              order_no_,
                              line_no_,
                              release_no_,
                              line_item_no_,
                              part_no_,
                              contract_,
                              configuration_id_,
                              location_no_,
                              lot_batch_no_,
                              serial_no_,
                              waiv_dev_rej_no_,
                              eng_chg_level_,
                              activity_seq_, 
                              handling_unit_id_);
   Check_Delete___(remrec_);
   
   Get_Id_Version_By_Keys___(objid_,
                             objversion_,
                             order_class_db_,
                             order_no_,
                             line_no_,
                             release_no_,
                             line_item_no_,
                             part_no_,
                             contract_,
                             configuration_id_,
                             location_no_,
                             lot_batch_no_,
                             serial_no_,
                             waiv_dev_rej_no_,
                             eng_chg_level_,
                             activity_seq_, 
                             handling_unit_id_);
   Delete___(objid_, remrec_);
END Remove___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE,
   newrec_     IN OUT MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (newrec_.qty_assigned = 0) THEN
      Remove___(newrec_.order_class, 
                newrec_.order_no,
                newrec_.line_no,
                newrec_.release_no,
                newrec_.line_item_no,
                newrec_.part_no,
                newrec_.contract,
                newrec_.configuration_id,
                newrec_.location_no,
                newrec_.lot_batch_no,
                newrec_.serial_no,
                newrec_.waiv_dev_rej_no,
                newrec_.eng_chg_level,
                newrec_.activity_seq,
                newrec_.handling_unit_id);
   END IF;
   Post_Update_Actions___(oldrec_, 
                          newrec_);   
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


FUNCTION Get_Stock_Record_Keys___ (
   order_class_db_ IN VARCHAR2,
   order_no_       IN VARCHAR2,
   line_no_        IN VARCHAR2,
   release_no_     IN VARCHAR2,
   line_item_no_   IN NUMBER ) RETURN Inventory_Part_In_Stock_API.Keys_And_Qty_Tab
IS
   stock_record_key_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;

   CURSOR get_stock_record_keys IS
      SELECT contract,
             part_no,
             configuration_id,
             location_no,
             lot_batch_no,
             serial_no,
             eng_chg_level,
             waiv_dev_rej_no,
             activity_seq, 
             handling_unit_id,
             qty_assigned      quantity,
             NULL              catch_quantity,
             NULL              transaction_id,
             NULL              transport_task_id,
             NULL              to_location_no
      FROM MATERIAL_REQUIS_RESERVAT_TAB
      WHERE order_no   = order_no_
      AND order_class  = order_class_db_
      AND line_no      = line_no_
      AND release_no   = release_no_
      AND line_item_no = line_item_no_
      AND qty_assigned > 0;
BEGIN
   OPEN get_stock_record_keys;
   FETCH get_stock_record_keys BULK COLLECT INTO stock_record_key_tab_;
   CLOSE get_stock_record_keys;

   RETURN (stock_record_key_tab_);
END Get_Stock_Record_Keys___;


PROCEDURE Identify_Serials___ (
   order_class_db_           IN VARCHAR2,
   order_no_                 IN VARCHAR2,
   line_no_                  IN VARCHAR2,
   release_no_               IN VARCHAR2,
   line_item_no_             IN NUMBER,
   part_tracking_session_id_ IN NUMBER )
IS
   stock_record_key_tab_ Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
   serial_catch_tab_     Inventory_Part_In_Stock_API.Serial_Catch_Table;
BEGIN
   stock_record_key_tab_ := Get_Stock_Record_Keys___(order_class_db_,
                                                     order_no_,
                                                     line_no_,
                                                     release_no_,
                                                     line_item_no_);
   IF (stock_record_key_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN stock_record_key_tab_.FIRST..stock_record_key_tab_.LAST LOOP

         IF (stock_record_key_tab_(i).serial_no = '*') THEN

            Temporary_Part_Tracking_API.Get_And_Remove_Serials(serial_catch_tab_,
                                                               part_tracking_session_id_,
                                                               stock_record_key_tab_(i).quantity,
                                                               stock_record_key_tab_(i).part_no,
                                                               stock_record_key_tab_(i).lot_batch_no);

            Inventory_Part_In_Stock_API.Split_Into_Serials(contract_             => stock_record_key_tab_(i).contract,
                                                           part_no_              => stock_record_key_tab_(i).part_no,
                                                           configuration_id_     => stock_record_key_tab_(i).configuration_id,
                                                           location_no_          => stock_record_key_tab_(i).location_no,
                                                           lot_batch_no_         => stock_record_key_tab_(i).lot_batch_no,
                                                           eng_chg_level_        => stock_record_key_tab_(i).eng_chg_level,
                                                           waiv_dev_rej_no_      => stock_record_key_tab_(i).waiv_dev_rej_no,
                                                           activity_seq_         => stock_record_key_tab_(i).activity_seq,
                                                           handling_unit_id_     => stock_record_key_tab_(i).handling_unit_id,
                                                           serial_catch_tab_     => serial_catch_tab_,
                                                           reservation_          => TRUE);
            Split_Reservation_Into_Serials(order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_,
                                           stock_record_key_tab_(i).part_no,
                                           stock_record_key_tab_(i).contract,
                                           stock_record_key_tab_(i).configuration_id,
                                           stock_record_key_tab_(i).location_no,
                                           stock_record_key_tab_(i).lot_batch_no,
                                           stock_record_key_tab_(i).waiv_dev_rej_no,
                                           stock_record_key_tab_(i).eng_chg_level,
                                           stock_record_key_tab_(i).activity_seq,
                                           stock_record_key_tab_(i).handling_unit_id,
                                           serial_catch_tab_);
         END IF;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Identify_Serials___;


PROCEDURE Make_Line_Delivery___ (
   order_class_db_      IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   release_no_          IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   result_                    VARCHAR2(80);
   stock_record_key_tab_      Inventory_Part_In_Stock_API.Keys_And_Qty_Tab;
BEGIN
   stock_record_key_tab_ := Get_Stock_Record_Keys___(order_class_db_,
                                                     order_no_,
                                                     line_no_,
                                                     release_no_,
                                                     line_item_no_);
   IF (stock_record_key_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN stock_record_key_tab_.FIRST..stock_record_key_tab_.LAST LOOP
         Make_Delivery___(result_               => result_,
                          order_class_          => order_class_db_,
                          order_no_             => order_no_,
                          line_no_              => line_no_,
                          release_no_           => release_no_,
                          line_item_no_         => line_item_no_,
                          part_no_              => stock_record_key_tab_(i).part_no,
                          contract_             => stock_record_key_tab_(i).contract,
                          configuration_id_     => stock_record_key_tab_(i).configuration_id,
                          location_no_          => stock_record_key_tab_(i).location_no,
                          lot_batch_no_         => stock_record_key_tab_(i).lot_batch_no,
                          serial_no_            => stock_record_key_tab_(i).serial_no,
                          waiv_dev_rej_no_      => stock_record_key_tab_(i).waiv_dev_rej_no,
                          eng_chg_level_        => stock_record_key_tab_(i).eng_chg_level,
                          activity_seq_         => stock_record_key_tab_(i).activity_seq,
                          handling_unit_id_     => stock_record_key_tab_(i).handling_unit_id,
                          qty_to_ship_          => stock_record_key_tab_(i).quantity,
                          catch_qty_to_ship_    => NULL);
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
END Make_Line_Delivery___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT material_requis_reservat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.configuration_id IS NULL) THEN
      newrec_.configuration_id := '*';
   END IF;

   IF (newrec_.configuration_id != '*') THEN
      Error_SYS.Record_General('MaterialRequisReservat', 'ONLY_BASE_ITEMS: Material requisitions can only handle base items.');
   END IF;
   super(newrec_, indrec_, attr_);

   IF (Inventory_Location_API.Get_Location_Type_Db(newrec_.contract,newrec_.location_no) != 'PICKING') THEN
      Error_SYS.Record_General('MaterialRequisReservat', 'NO_ALLOWED_LOCATION: Location :P1 is not available for material requisition', newrec_.location_no);
   END IF;

   Validate_Qty_Assigned___(newrec_.order_class,
                            newrec_.order_no,
                            newrec_.line_no,
                            newrec_.release_no,
                            newrec_.line_item_no,
                            newrec_.part_no,
                            newrec_.contract,
                            newrec_.configuration_id,
                            newrec_.location_no,
                            newrec_.lot_batch_no,
                            newrec_.serial_no,
                            newrec_.waiv_dev_rej_no,
                            newrec_.eng_chg_level,
                            newrec_.activity_seq,
                            newrec_.handling_unit_id,
                            newrec_.qty_assigned);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     material_requis_reservat_tab%ROWTYPE,
   newrec_ IN OUT material_requis_reservat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   material_req_line_rec_  Material_Requis_Line_API.Public_Rec;
   mr_line_project_id_     VARCHAR2(10);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   material_req_line_rec_ := Material_Requis_Line_API.Get(newrec_.order_class, newrec_.order_no, newrec_.line_no, newrec_.release_no, newrec_.line_item_no); 
   IF (material_req_line_rec_.supply_code = Order_Supply_Type_API.DB_PURCH_ORDER) THEN
      IF (newrec_.source != 'RECEIVE_PURCHASE_ORDER') THEN
         Error_SYS.Record_General(lu_name_, 'MRLINESUPTYPEINV: A material requisition line having supply Code :P1 should not be supplied from Inventory', Material_Requis_Supply_API.Decode(material_req_line_rec_.supply_code));
      END IF;      
   ELSIF (material_req_line_rec_.supply_code = Order_Supply_Type_API.DB_INVENT_ORDER) THEN
      IF newrec_.activity_seq != 0 THEN
         Error_SYS.Record_General(lu_name_, 'MRLINESUPTYPEPROJ: Project Inventory cannot be reserved to a material requisition line having Supply Code :P1', Material_Requis_Supply_API.Decode(material_req_line_rec_.supply_code));         
      END IF;      
   ELSIF(material_req_line_rec_.supply_code = Order_Supply_Type_API.DB_PROJECT_INVENTORY) THEN
      IF newrec_.activity_seq = 0 THEN
         Error_SYS.Record_General(lu_name_, 'STDINVTOMRLINEPROJ: Standard Inventory cannot be reserved to a material requisition line having Supply Code :P1', Material_Requis_Supply_API.Decode(material_req_line_rec_.supply_code));         
      END IF;
      $IF Component_Proj_SYS.INSTALLED $THEN
         mr_line_project_id_ := Activity_API.Get_Project_Id(material_req_line_rec_.activity_seq);
         IF Project_API.Get_Material_Allocation_Db(mr_line_project_id_) = Material_Allocation_API.DB_WITHIN_PROJECT THEN
            IF mr_line_project_id_ != Activity_API.Get_Project_Id(newrec_.activity_seq) THEN
               Error_SYS.Record_General(lu_name_, 'PROJINVRESMRLINE: Only stock connected to Project ID :P1 can be reserved to this material requisition line', mr_line_project_id_);   
            END IF;
         ELSE
            IF newrec_.activity_seq != material_req_line_rec_.activity_seq THEN
               Error_SYS.Record_General(lu_name_, 'PRJACTSEQRESMRLINE: Only stock connected to Project Activity Sequence :P1 can be reserved to this material requisition line', material_req_line_rec_.activity_seq);
            END IF;
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('PROJ');
      $END  
   END IF;
END Check_Common___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     material_requis_reservat_tab%ROWTYPE,
   newrec_ IN OUT material_requis_reservat_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                VARCHAR2(30);
   value_               VARCHAR2(4000);
   order_class_decoded_ VARCHAR2(32);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   order_class_decoded_ := Material_Requis_Type_API.Decode(newrec_.order_class);
   Validate_Qty_Assigned___(order_class_decoded_,
                            newrec_.order_no,
                            newrec_.line_no,
                            newrec_.release_no,
                            newrec_.line_item_no,
                            newrec_.part_no,
                            newrec_.contract,
                            newrec_.configuration_id,
                            newrec_.location_no,
                            newrec_.lot_batch_no,
                            newrec_.serial_no,
                            newrec_.waiv_dev_rej_no,
                            newrec_.eng_chg_level,
                            newrec_.activity_seq,
                            newrec_.handling_unit_id,
                            newrec_.qty_assigned);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

PROCEDURE Post_Update_Actions___ (
   oldrec_                  IN material_requis_reservat_tab%ROWTYPE,
   newrec_                  IN material_requis_reservat_tab%ROWTYPE)
IS
   qty_assigned_          NUMBER := 0;
   qty_assigned_changed_  BOOLEAN := FALSE;
BEGIN
   IF Validate_SYS.Is_Changed(oldrec_.qty_assigned, newrec_.qty_assigned) THEN
      qty_assigned_ := newrec_.qty_assigned - oldrec_.qty_assigned; 
      qty_assigned_changed_ := TRUE;
   END IF;  
   
   IF (qty_assigned_changed_) THEN
      Transport_Task_API.Modify_Order_Reservation_Qty(from_contract_          => newrec_.contract,
                                                      part_no_                => newrec_.part_no,
                                                      configuration_id_       => newrec_.configuration_id,
                                                      from_location_no_       => newrec_.location_no,
                                                      lot_batch_no_           => newrec_.lot_batch_no,
                                                      serial_no_              => newrec_.serial_no,
                                                      eng_chg_level_          => newrec_.eng_chg_level,
                                                      waiv_dev_rej_no_        => newrec_.waiv_dev_rej_no,
                                                      activity_seq_           => newrec_.activity_seq,
                                                      handling_unit_id_       => newrec_.handling_unit_id,
                                                      quantity_diff_          => qty_assigned_,
                                                      catch_quantity_diff_    => NULL,
                                                      order_ref1_             => newrec_.order_no,
                                                      order_ref2_             => newrec_.line_no,
                                                      order_ref3_             => newrec_.release_no,
                                                      order_ref4_             => newrec_.line_item_no,
                                                      pick_list_no_           => NULL,
                                                      shipment_id_            => NULL,
                                                      order_type_db_          => Order_Type_API.DB_MATERIAL_REQUISITION );
   END IF;
END Post_Update_Actions___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
@UncheckedAccess
FUNCTION Get_Qty_Assigned (
   order_class_      IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ MATERIAL_REQUIS_RESERVAT_TAB.qty_assigned%TYPE;
BEGIN   
   temp_ := super(order_class_, order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_);
   RETURN NVL(temp_, 0);
END Get_Qty_Assigned;


-- Add_Assigned
--   Make a new MaterialRequisReservat if there isn't any MaterialRequisReservat
--   already created.
--   If there is a MaterialRequisReservat existing then the quantity s recalculated
--   to qty_assigned + qty_reserved_, if qty_assigned + qty_reserved_ is
--   equal o zero then the instance is removed.
--   Finally the material requisition line is updated is updated with the
--   new quantity assigned.
PROCEDURE Add_Assigned (
   order_class_      IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_reserve_      IN NUMBER )
IS
   attr_                   VARCHAR2(32000);
   lu_rec_                 MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   oldrec_                 MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   newrec_                 MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   qty_assigned_           NUMBER;
   user_name_              VARCHAR2(30);
   status_code_            VARCHAR2(200);
   objid_                  MATERIAL_REQUIS_RESERVAT.objid%TYPE;
   objversion_             MATERIAL_REQUIS_RESERVAT.objversion%TYPE;
   order_class_db_         MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
   configuration_id_       VARCHAR2(50) := '*';
   matreq_line_rec_        Material_Requis_Line_API.public_rec;
   indrec_                 Indicator_Rec;
   CURSOR get_qty IS
      SELECT SUM(qty_assigned)
      FROM MATERIAL_REQUIS_RESERVAT_TAB
      WHERE order_no = order_no_
      AND order_class = order_class_db_
      AND line_no = line_no_
      AND release_no = release_no_
      AND line_item_no = line_item_no_;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   user_name_      := Fnd_Session_API.Get_Fnd_User;
   lu_rec_         := Get_Object_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_);
   IF lu_rec_.qty_assigned IS NULL THEN
      IF ( qty_reserve_ != 0 ) THEN
         Trace_SYS.Message('Trace => Qty Assigned IS NULL');
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr( 'ORDER_NO', order_no_, attr_ );
         Client_SYS.Add_To_Attr( 'LINE_NO', line_no_, attr_ );
         Client_SYS.Add_To_Attr( 'RELEASE_NO', release_no_, attr_ );
         Client_SYS.Add_To_Attr( 'LINE_ITEM_NO', line_item_no_, attr_ );
         Client_SYS.Add_To_Attr( 'ORDER_CLASS', order_class_, attr_ );
         Client_SYS.Add_To_Attr( 'CONTRACT', contract_, attr_ );
         Client_SYS.Add_To_Attr( 'PART_NO', part_no_, attr_ );
         Client_SYS.Add_To_Attr( 'LOCATION_NO', location_no_, attr_ );
         Client_SYS.Add_To_Attr( 'LOT_BATCH_NO', lot_batch_no_, attr_ );
         Client_SYS.Add_To_Attr( 'SERIAL_NO', serial_no_, attr_ );
         Client_SYS.Add_To_Attr( 'WAIV_DEV_REJ_NO', waiv_dev_rej_no_, attr_ );
         Client_SYS.Add_To_Attr( 'ENG_CHG_LEVEL', eng_chg_level_, attr_ );
         Client_SYS.Add_To_Attr( 'ACTIVITY_SEQ', activity_seq_, attr_ );
         Client_SYS.Add_To_Attr( 'HANDLING_UNIT_ID', handling_unit_id_, attr_ );
         Client_SYS.Add_To_Attr( 'QTY_ASSIGNED', TO_CHAR(qty_reserve_), attr_ );
         Client_SYS.Add_To_Attr( 'QTY_ISSUED', 0, attr_ );
         Client_SYS.Add_To_Attr( 'CONFIGURATION_ID',configuration_id_ , attr_ );
         Client_SYS.Add_To_Attr( 'LAST_ACTIVITY_DATE', Site_API.Get_Site_Date(contract_), attr_ );
         Client_SYS.Add_To_Attr( 'SOURCE', user_name_, attr_);
         Trace_SYS.Field('Attr : ', attr_);
         -- New
         Unpack___(lu_rec_, indrec_, attr_);
         Check_Insert___(lu_rec_, indrec_, attr_);
         Insert___(objid_, objversion_, lu_rec_, attr_);
      END IF;
   ELSE
      Trace_SYS.Message('Trace => Qty Assigned IS NOT NULL');
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'QTY_ASSIGNED', (lu_rec_.qty_assigned + qty_reserve_), attr_ );
      -- Modify
      oldrec_ := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      --
   END IF;
   --
   OPEN  get_qty;
   FETCH get_qty INTO qty_assigned_;
   CLOSE get_qty;
   qty_assigned_  := Nvl(qty_assigned_, 0);

   matreq_line_rec_ := Material_Requis_Line_API.Get(order_class_db_,
                                                    order_no_   ,
                                                    line_no_    ,
                                                    release_no_ ,
                                                    line_item_no_ );
   IF (qty_assigned_ = 0) THEN
      IF (matreq_line_rec_.qty_shipped > 0 OR  matreq_line_rec_.qty_returned >0 )THEN
         status_code_ := Material_Requis_Status_API.Decode('7');
      ELSE
         status_code_ := Material_Requis_Status_API.Decode('4');
      END IF;
   ELSE
      IF matreq_line_rec_.qty_shipped > 0 THEN
         status_code_ := Material_Requis_Status_API.Decode('7');
      ELSE
         status_code_ := Material_Requis_Status_API.Decode('5');
      END IF;
   END IF;
   Material_Requis_Line_API.Change_Qty_Assigned(
                           order_class_,
                           order_no_,
                           line_no_,
                           release_no_,
                           line_item_no_,
                           qty_assigned_,
                           status_code_);
   Trace_SYS.Message('Trace => END Add_Assigned');
END Add_Assigned;


-- Make_Item_Delivery
--   Calls the implementation method MakeDelivery.
PROCEDURE Make_Item_Delivery (
   order_class_      IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_to_ship_      IN NUMBER )
IS
   info_              VARCHAR2(2000);
BEGIN
   Make_Item_Delivery(order_class_,
                      order_no_,
                      line_no_,
                      release_no_,
                      line_item_no_,
                      part_no_,
                      contract_,
                      location_no_,
                      lot_batch_no_,
                      serial_no_,
                      waiv_dev_rej_no_,
                      eng_chg_level_,
                      activity_seq_,
                      handling_unit_id_,
                      qty_to_ship_,
                      NULL,
                      info_ );
END Make_Item_Delivery;


-- Make_Item_Delivery
--   Calls the implementation method MakeDelivery.
PROCEDURE Make_Item_Delivery (
   order_class_              IN  VARCHAR2,
   order_no_                 IN  VARCHAR2,
   line_no_                  IN  VARCHAR2,
   release_no_               IN  VARCHAR2,
   line_item_no_             IN  NUMBER,
   part_no_                  IN  VARCHAR2,
   contract_                 IN  VARCHAR2,
   location_no_              IN  VARCHAR2,
   lot_batch_no_             IN  VARCHAR2,
   serial_no_                IN  VARCHAR2,
   waiv_dev_rej_no_          IN  VARCHAR2,
   eng_chg_level_            IN  VARCHAR2,
   activity_seq_             IN  NUMBER,
   handling_unit_id_         IN  NUMBER,
   qty_to_ship_              IN  NUMBER,
   catch_qty_to_ship_        IN  NUMBER,
   info_                     OUT VARCHAR2,
   part_tracking_session_id_ IN  NUMBER DEFAULT NULL)
IS
   result_              VARCHAR2(80);
   configuration_id_    MATERIAL_REQUIS_RESERVAT_TAB.configuration_id%TYPE := '*';
   order_class_db_      MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
   serial_catch_tab_    Inventory_Part_In_Stock_API.Serial_Catch_Table;
   local_qty_to_ship_   NUMBER;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);

   IF (part_tracking_session_id_ IS NULL) THEN
      serial_catch_tab_(1).serial_no := serial_no_;
      local_qty_to_ship_             := qty_to_ship_;
      serial_catch_tab_(1).catch_qty := catch_qty_to_ship_;
   ELSE
      Temporary_Part_Tracking_API.Get_Serials_And_Remove_Session(serial_catch_tab_,
                                                                 part_tracking_session_id_);

      Inventory_Part_In_Stock_API.Split_Into_Serials( contract_         => contract_,
                                                      part_no_          => part_no_,
                                                      configuration_id_ => configuration_id_,
                                                      location_no_      => location_no_,
                                                      lot_batch_no_     => lot_batch_no_,
                                                      eng_chg_level_    => eng_chg_level_,
                                                      waiv_dev_rej_no_  => waiv_dev_rej_no_,
                                                      activity_seq_     => activity_seq_,
                                                      handling_unit_id_ => handling_unit_id_,
                                                      serial_catch_tab_ => serial_catch_tab_,
                                                      reservation_      => TRUE);
      Split_Reservation_Into_Serials(order_no_,
                                     line_no_,
                                     release_no_,
                                     line_item_no_,
                                     part_no_,
                                     contract_,
                                     configuration_id_,
                                     location_no_,
                                     lot_batch_no_,
                                     waiv_dev_rej_no_,
                                     eng_chg_level_,
                                     activity_seq_,
                                     handling_unit_id_,
                                     serial_catch_tab_);
      local_qty_to_ship_ := 1;
   END IF;

   IF (serial_catch_tab_.COUNT > 0) THEN
      Inventory_Event_Manager_API.Start_Session;
      FOR i IN serial_catch_tab_.FIRST..serial_catch_tab_.LAST LOOP
         Make_Delivery___(result_               => result_,
                          order_class_          => order_class_db_,
                          order_no_             => order_no_,
                          line_no_              => line_no_,
                          release_no_           => release_no_,
                          line_item_no_         => line_item_no_,
                          part_no_              => part_no_,
                          contract_             => contract_,
                          configuration_id_     => configuration_id_,
                          location_no_          => location_no_,
                          lot_batch_no_         => lot_batch_no_,
                          serial_no_            => serial_catch_tab_(i).serial_no,
                          waiv_dev_rej_no_      => waiv_dev_rej_no_,
                          eng_chg_level_        => eng_chg_level_,
                          activity_seq_         => activity_seq_,
                          handling_unit_id_     => handling_unit_id_,
                          qty_to_ship_          => local_qty_to_ship_,
                          catch_qty_to_ship_    => serial_catch_tab_(i).catch_qty);

         IF (result_ = 'NO_ASSIGNMENTS') THEN
            Error_SYS.Record_General('MaterialRequisReservat', 'NOTHING_ASSIGNED: Can only deliver if an reservation is made.');
         END IF;
      END LOOP;
      Inventory_Event_Manager_API.Finish_Session;
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Make_Item_Delivery;


-- Make_Line_Delivery
--   Calls implementation method MakeDelivery for every instance with the
--   given order class, order number, line number, release number and line item number.
PROCEDURE Make_Line_Delivery (
   order_class_         IN VARCHAR2,
   order_no_            IN VARCHAR2,
   line_no_             IN VARCHAR2,
   release_no_          IN VARCHAR2,
   line_item_no_        IN NUMBER )
IS
   order_class_db_   MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);

   Make_Line_Delivery___(order_class_db_, 
                         order_no_, 
                         line_no_, 
                         release_no_, 
                         line_item_no_);
END Make_Line_Delivery;


-- Make_Line_Delivery
--   Calls implementation method MakeDelivery for every instance with the
--   given order class, order number, line number, release number and line item number.
PROCEDURE Make_Line_Delivery (
   order_class_              IN  VARCHAR2,
   order_no_                 IN  VARCHAR2,
   line_no_                  IN  VARCHAR2,
   release_no_               IN  VARCHAR2,
   line_item_no_             IN  NUMBER,
   part_tracking_session_id_ IN  NUMBER,
   info_                     OUT VARCHAR2 )
IS
   order_class_db_ MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);

   IF (part_tracking_session_id_ IS NOT NULL) THEN
      Identify_Serials___(order_class_db_,
                          order_no_,
                          line_no_,
                          release_no_,
                          line_item_no_,
                          part_tracking_session_id_);
   END IF;

   Make_Line_Delivery___(order_class_db_,
                         order_no_,
                         line_no_,
                         release_no_,
                         line_item_no_);

   info_ := Client_SYS.Get_All_Info;
END Make_Line_Delivery;


-- Make_Order_Delivery
--   Calls the implementation method MakeDelivery for every instance having
--   the giving order class and order number.
PROCEDURE Make_Order_Delivery (
   order_class_ IN VARCHAR2,
   order_no_    IN VARCHAR2 )
IS
   result_           VARCHAR2(80);
   order_class_db_   MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
   
   CURSOR get_lines IS
      SELECT line_no, release_no, line_item_no, part_no, contract, configuration_id,
             location_no, lot_batch_no, serial_no, waiv_dev_rej_no, eng_chg_level, activity_seq,
             handling_unit_id, qty_assigned
      FROM MATERIAL_REQUIS_RESERVAT_TAB
      WHERE order_no = order_no_
      AND order_class = order_class_db_;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   Inventory_Event_Manager_API.Start_Session;
   FOR lrec IN get_lines LOOP
      Make_Delivery___(result_               => result_,
                       order_class_          => order_class_db_,
                       order_no_             => order_no_,
                       line_no_              => lrec.line_no,
                       release_no_           => lrec.release_no,
                       line_item_no_         => lrec.line_item_no,
                       part_no_              => lrec.part_no,
                       contract_             => lrec.contract,
                       configuration_id_     => lrec.configuration_id,
                       location_no_          => lrec.location_no,
                       lot_batch_no_         => lrec.lot_batch_no,
                       serial_no_            => lrec.serial_no,
                       waiv_dev_rej_no_      => lrec.waiv_dev_rej_no,
                       eng_chg_level_        => lrec.eng_chg_level,
                       activity_seq_         => lrec.activity_seq,
                       handling_unit_id_     => lrec.handling_unit_id,
                       qty_to_ship_          => lrec.qty_assigned,
                       catch_qty_to_ship_    => NULL);
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session;
END Make_Order_Delivery;


-- Make_Part_Reservations
--   Try to reserve the material on the material requisition line from
--   inventory part location. This is possible if the reservation isn't
--   greater than the assigned quantity on the material requisition line
--   and the onhand analysis in inventory part location doesn't result in
--   'INSIDE_LEADTIME', 'OUTSIDE_LEADTIME'
PROCEDURE Make_Part_Reservations (
   order_class_      IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_reserve_      IN NUMBER )
IS
   qty_to_assign_             NUMBER;
   availability_control_id_   VARCHAR2(25);
   catch_quantity_            NUMBER := NULL;
   
   shortage_quantity_         NUMBER; 
   exit_procedure             EXCEPTION;
   material_requis_line_rec_  Material_Requis_Line_API.Public_Rec;
BEGIN
   IF (qty_reserve_ = 0) THEN
     RAISE exit_procedure;
   END IF; 

   IF (qty_reserve_ > 0) THEN
      availability_control_id_ := Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract_,
                                                                                          part_no_,
                                                                                          '*',
                                                                                          location_no_,
                                                                                          lot_batch_no_,
                                                                                          serial_no_,
                                                                                          eng_chg_level_,
                                                                                          waiv_dev_rej_no_,
                                                                                          activity_seq_,
                                                                                          handling_unit_id_);

      IF (Part_Availability_Control_API.Check_Man_Reservation_Control(availability_control_id_)
                                            != 'MANUAL_RESERV') THEN
         Error_SYS.Record_General(lu_name_, 'AVAILIDMANRES: Part :P1 with Availability Control ID :P2 cannot be manually reserved.', part_no_, availability_control_id_);
      END IF;
   END IF;
   
   material_requis_line_rec_ := Material_Requis_Line_API.Lock_And_Get(order_class_, order_no_, line_no_, release_no_, line_item_no_);
   qty_to_assign_ := material_requis_line_rec_.qty_due - material_requis_line_rec_.qty_assigned - material_requis_line_rec_.qty_shipped;

   IF qty_reserve_ > qty_to_assign_ THEN
      Error_SYS.Record_General(lu_name_, 'RESMORETHANDUE: Can not reserve more than qty due');
   END IF;

   Add_Assigned(order_class_, order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, location_no_, lot_batch_no_,
                serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_, qty_reserve_);

   shortage_quantity_ := Material_Requis_Line_API.Get_Qty_Short(order_class_, order_no_, line_no_, release_no_, line_item_no_);
   
   
   IF (Mpccom_System_Parameter_API.Get_parameter_value1('SHORTAGE_HANDLING') = 'Y')
   AND (Inventory_Part_API.Get_Shortage_Flag(contract_,part_no_) = Inventory_Part_Shortage_API.Decode('Y')) THEN
      IF (shortage_quantity_ > 0) THEN
         Material_Requis_Line_API.Modify_Qty_Short(order_class_, order_no_, line_no_, release_no_, line_item_no_, shortage_quantity_ - qty_reserve_);
      END IF;
   ELSE
      IF (shortage_quantity_ != 0) THEN
         Material_Requis_Line_API.Modify_Qty_Short( order_class_, order_no_, line_no_, release_no_, line_item_no_,0);
      END IF;
   END IF;

   Inventory_Part_In_Stock_API.Reserve_Part( catch_quantity_   => catch_quantity_, 
                                             contract_         => contract_, 
                                             part_no_          => part_no_,
                                             configuration_id_ =>  '*', 
                                             location_no_      => location_no_, 
                                             lot_batch_no_     => lot_batch_no_, 
                                             serial_no_        => serial_no_, 
                                             eng_chg_level_    => eng_chg_level_, 
                                             waiv_dev_rej_no_  => waiv_dev_rej_no_, 
                                             activity_seq_     => activity_seq_, 
                                             handling_unit_id_ => handling_unit_id_, 
                                             quantity_         => qty_reserve_);
EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Make_Part_Reservations;

-- Update_Assigned
--   Make a new MaterialRequisReservat if there isn't any MaterialRequisReservat
--   already created.
--   If there is a MaterialRequisReservat existing then the quantity  assigned
--   is added to the old quantity assigned.
PROCEDURE Update_Assigned (
   order_class_      IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_assigned_     IN NUMBER,
   qty_issued_       IN NUMBER,
   source_          IN VARCHAR2 DEFAULT 'RECEIVE_PURCHASE_ORDER' )
IS
   attr_                   VARCHAR2(2000);
   oldrec_                 MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   newrec_                 MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   objid_                  MATERIAL_REQUIS_RESERVAT.objid%TYPE;
   objversion_             MATERIAL_REQUIS_RESERVAT.objversion%TYPE;
   order_class_db_         MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
   configuration_id_       VARCHAR2(50) := '*';
   indrec_                 Indicator_Rec;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   --
   oldrec_ := Get_Object_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_);
   IF oldrec_.qty_assigned IS NULL THEN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'ORDER_NO', order_no_, attr_ );
      Client_SYS.Add_To_Attr( 'LINE_NO', line_no_, attr_ );
      Client_SYS.Add_To_Attr( 'RELEASE_NO', release_no_, attr_ );
      Client_SYS.Add_To_Attr( 'LINE_ITEM_NO', line_item_no_, attr_ );
      Client_SYS.Add_To_Attr( 'ORDER_CLASS', order_class_, attr_ );
      Client_SYS.Add_To_Attr( 'CONTRACT', contract_, attr_ );
      Client_SYS.Add_To_Attr( 'PART_NO', part_no_, attr_ );
      Client_SYS.Add_To_Attr( 'LOCATION_NO', location_no_, attr_ );
      Client_SYS.Add_To_Attr( 'LOT_BATCH_NO', lot_batch_no_, attr_ );
      Client_SYS.Add_To_Attr( 'SERIAL_NO', serial_no_, attr_ );
      Client_SYS.Add_To_Attr( 'WAIV_DEV_REJ_NO', waiv_dev_rej_no_, attr_ );
      Client_SYS.Add_To_Attr( 'ENG_CHG_LEVEL', eng_chg_level_, attr_ );
      Client_SYS.Add_To_Attr( 'ACTIVITY_SEQ', activity_seq_, attr_ );
      Client_SYS.Add_To_Attr( 'HANDLING_UNIT_ID', handling_unit_id_, attr_ );
      Client_SYS.Add_To_Attr( 'QTY_ASSIGNED', qty_assigned_, attr_ );
      Client_SYS.Add_To_Attr( 'QTY_ISSUED', qty_issued_, attr_ );
      Client_SYS.Add_To_Attr( 'LAST_ACTIVITY_DATE', Site_API.Get_Site_Date(contract_), attr_ );
      Client_SYS.Add_To_Attr( 'CONFIGURATION_ID',configuration_id_ , attr_ );
      Client_SYS.Add_To_Attr( 'SOURCE', source_, attr_);
      -- New__
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'QTY_ASSIGNED', (oldrec_.qty_assigned + qty_assigned_), attr_ );
      Client_SYS.Add_To_Attr( 'LAST_ACTIVITY_DATE', Site_API.Get_Site_Date(contract_), attr_ );
      -- Modify__
      oldrec_ := Lock_By_Keys___(order_class_db_, order_no_, line_no_, release_no_, line_item_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, waiv_dev_rej_no_, eng_chg_level_, activity_seq_, handling_unit_id_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Update_Assigned;


-- Check_Exist_Reservation
--   Returns 1 if there is an instance with the given order class and
--   order number, otherwise 0 is returned.
@UncheckedAccess
FUNCTION Check_Exist_Reservation (
   order_class_ IN VARCHAR2,
   order_no_    IN VARCHAR2 ) RETURN NUMBER
IS
   order_class_db_   MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
   CURSOR get_data_exist IS
      SELECT 'X'
      FROM  MATERIAL_REQUIS_RESERVAT_TAB
      WHERE ORDER_NO     = order_no_
      AND   ORDER_CLASS  = order_class_db_
      AND   QTY_ASSIGNED > 0;
   dummy_     VARCHAR2(1);
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   OPEN get_data_exist;
   FETCH get_data_exist INTO dummy_;
   IF get_data_exist%FOUND THEN
      CLOSE get_data_exist;
      RETURN 1;
   ELSE
      CLOSE get_data_exist;
      RETURN 0;
   END IF;
END Check_Exist_Reservation;


PROCEDURE Check_Issue (
   order_class_  IN VARCHAR2,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   order_class_db_   MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);

   IF Material_Requis_Line_API.Is_Closed(order_class_db_, order_no_, line_no_, release_no_, line_item_no_) THEN
      Error_SYS.Record_General(lu_name_, 'MRLINECLOSED: The material requisition line is in Closed status. You are not allowed to issue quantity on a closed material requisition line.');
   END IF;
END Check_Issue;  


PROCEDURE Split_Reservation_Into_Serials (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   serial_catch_tab_ IN Inventory_Part_In_Stock_API.Serial_Catch_Table )
IS
   reservation_rec_  MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;
   serial_exist_     BOOLEAN;
   order_class_      VARCHAR2(50);
BEGIN
   -- Lock Reservation Record
   reservation_rec_ := Lock_By_Keys___(Material_Requis_Type_API.DB_INT,
                                       order_no_,
                                       line_no_,
                                       release_no_,
                                       line_item_no_,
                                       part_no_,
                                       contract_,
                                       configuration_id_,
                                       location_no_,
                                       lot_batch_no_,
                                       '*',
                                       waiv_dev_rej_no_,
                                       eng_chg_level_,
                                       activity_seq_, 
                                       handling_unit_id_);

   IF (serial_catch_tab_.COUNT > 0) THEN
      -- Make sure that we dont split more than we have reserved
      IF serial_catch_tab_.COUNT > reservation_rec_.qty_assigned THEN
         Error_SYS.Record_General(lu_name_, 'SPLITRESQTY: Splitting into :P1 serial(s) is impossible since the quantity reserved for Material Requisition is only :P2.',
                                  serial_catch_tab_.COUNT, reservation_rec_.qty_assigned);
      END IF;

      order_class_   := Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT);

      FOR i_ IN serial_catch_tab_.FIRST .. serial_catch_tab_.LAST LOOP
         -- Check if the serial already reserved for this MR
         serial_exist_ := Check_Exist___(Material_Requis_Type_API.DB_INT,
                                         order_no_,
                                         line_no_,
                                         release_no_,
                                         line_item_no_,
                                         part_no_,
                                         contract_,
                                         configuration_id_,
                                         location_no_,
                                         lot_batch_no_,
                                         serial_catch_tab_(i_).serial_no,
                                         waiv_dev_rej_no_,
                                         eng_chg_level_,
                                         activity_seq_, 
                                         handling_unit_id_);

         IF serial_exist_ THEN
            Error_SYS.Record_General(lu_name_, 'SPLITRESEXISTS: Serial :P1 already reserved for this Material Requisition.', part_no_||','||serial_catch_tab_(i_).serial_no);
         END IF;

         -- Create splitted record
         Update_Assigned(order_class_,
                         order_no_,
                         line_no_,
                         release_no_,
                         line_item_no_,
                         part_no_,
                         contract_,
                         location_no_,
                         lot_batch_no_,
                         serial_catch_tab_(i_).serial_no,
                         waiv_dev_rej_no_,
                         eng_chg_level_,
                         activity_seq_,
                         handling_unit_id_,
                         1,
                         0);
      END LOOP;

      -- Update Original record
      Update_Assigned(order_class_,
                      order_no_,
                      line_no_,
                      release_no_,
                      line_item_no_,
                      part_no_,
                      contract_,
                      location_no_,
                      lot_batch_no_,
                      '*',
                      waiv_dev_rej_no_,
                      eng_chg_level_,
                      activity_seq_,
                      handling_unit_id_,
                      (0-serial_catch_tab_.COUNT),
                      0);
   END IF;
END Split_Reservation_Into_Serials;


@UncheckedAccess
FUNCTION Get_Unidentified_Serials (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   release_no_   IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   total_unidentified_ NUMBER                := 0;
   order_class_db_     CONSTANT VARCHAR2(20) := Material_Requis_Type_API.DB_INT; 
   part_no_            MATERIAL_REQUIS_RESERVAT_TAB.part_no%TYPE;

   CURSOR get_unidentified IS
      SELECT NVL(SUM(qty_assigned),0) total_unidentified
        FROM MATERIAL_REQUIS_RESERVAT_TAB
       WHERE order_class  = order_class_db_
         AND order_no     = order_no_
         AND line_no      = line_no_
         AND release_no   = release_no_
         AND line_item_no = line_item_no_
         AND serial_no    = '*';
BEGIN
   part_no_ := Material_Requis_Line_API.Get_Part_No(Material_Requis_Type_API.Decode(order_class_db_),
                                                    order_no_,
                                                    line_no_,
                                                    release_no_,
                                                    line_item_no_);

   IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(part_no_) = Fnd_Boolean_API.DB_TRUE) THEN
      OPEN get_unidentified;
      FETCH get_unidentified INTO total_unidentified_;
      CLOSE get_unidentified;
   END IF;

   RETURN NVL(total_unidentified_,0);
END Get_Unidentified_Serials;


FUNCTION Get_Qty_Assigned_If_Unique (
   order_class_db_   IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
   column_value_        MATERIAL_REQUIS_RESERVAT_TAB.qty_assigned%TYPE;
   unique_column_value_ MATERIAL_REQUIS_RESERVAT_TAB.qty_assigned%TYPE;
   CURSOR get_qty_assigned_ IS
      SELECT qty_assigned
      FROM MATERIAL_REQUIS_RESERVAT_TAB
      WHERE order_class      = order_class_db_
      AND   order_no         = NVL(order_no_,    order_no)
      AND   line_no          = NVL(line_no_, line_no)
      AND   release_no       = NVL(release_no_, release_no)
      AND   line_item_no     = NVL(line_item_no_, line_item_no)
      AND   part_no          = NVL(part_no_, part_no)
      AND   contract         = contract_
      AND   configuration_id = NVL(configuration_id_, configuration_id)
      AND   location_no      = NVL(location_no_, location_no)
      AND   lot_batch_no     = NVL(lot_batch_no_, lot_batch_no)
      AND   serial_no        = NVL(serial_no_, serial_no)
      AND   waiv_dev_rej_no  = NVL(waiv_dev_rej_no_, waiv_dev_rej_no)
      AND   eng_chg_level    = NVL(eng_chg_level_, eng_chg_level)
      AND   activity_seq     = NVL(activity_seq_, activity_seq)
      AND   handling_unit_id = NVL(handling_unit_id_, handling_unit_id);
BEGIN
   OPEN get_qty_assigned_;
   LOOP
      FETCH get_qty_assigned_ INTO column_value_;
      EXIT WHEN get_qty_assigned_%NOTFOUND;

      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := column_value_;
      ELSIF (unique_column_value_ != column_value_) THEN
         unique_column_value_ := NULL;
         EXIT;
      END IF;
   END LOOP;
   CLOSE get_qty_assigned_;
   
   RETURN unique_column_value_;
END Get_Qty_Assigned_If_Unique;


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
   column_value_tab_              Column_Value_Tab; 
BEGIN
   IF NOT ( User_Allowed_Site_API.Check_Exist(userid_, contract_)) THEN
      RETURN NULL;
   END IF;
   
   -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
   Assert_SYS.Assert_Is_View_Column('MATERIAL_REQUIS_RESERVAT_PUB', column_name_);

   -- this select is for issue manually action
   stmt_ := 'SELECT DISTINCT ' || column_name_ || '
             FROM MATERIAL_REQUIS_RESERVAT_PUB 
             WHERE contract          = :contract 
               AND order_class_db    = :order_class_db
               AND qty_assigned  > 0
               AND Part_Availability_Control_API.Check_Order_Issue_Control(
                   Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract, part_no, configuration_id, location_no, 
                                                                           lot_batch_no, serial_no, eng_chg_level, 
                                                                           waiv_dev_rej_no, activity_seq, handling_unit_id)) = ''ORDER ISSUE'' ';

   IF order_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :order_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND order_no = :order_no_';
   END IF;
   IF line_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :line_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND line_no = :line_no_';
   END IF;
   IF release_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :release_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND release_no = :release_no_';
   END IF;
   IF line_item_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :line_item_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND line_item_no = :line_item_no_';
   END IF;      
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;      
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;      
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;

   stmt_ := stmt_ || ' FETCH FIRST 2 ROWS ONLY ';

   @ApproveDynamicStatement(2014-12-09,UdGnlk)
   OPEN get_column_values_ FOR stmt_ USING contract_,
                                           Material_Requis_Type_API.DB_INT,
                                           order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,  
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_;
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
      IF NOT (User_Allowed_Site_API.Check_Exist(userid_, contract_)) THEN
         RETURN;
      END IF;

      session_rec_ := Data_Capture_Session_API.Get_Session_Rec(capture_session_id_);    
      lov_row_limitation_ := Data_Capture_Config_API.Get_Lov_Row_Limitation(session_rec_.capture_process_id, session_rec_.capture_config_id);

      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('MATERIAL_REQUIS_RESERVAT_PUB', column_name_);

      -- this select is for issue manually action
      stmt_ :=  column_name_ || 
              ' FROM MATERIAL_REQUIS_RESERVAT_PUB 
                WHERE contract          = :contract_ 
                  AND order_class_db    = :order_class_db_
                  AND qty_assigned  > 0
                  AND Part_Availability_Control_API.Check_Order_Issue_Control(
                      Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract, part_no, configuration_id, location_no, 
                                                                              lot_batch_no, serial_no, eng_chg_level, 
                                                                              waiv_dev_rej_no, activity_seq, handling_unit_id)) = ''ORDER ISSUE'' ';
      
      IF order_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :order_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND order_no = :order_no_';
      END IF;
      IF line_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :line_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND line_no = :line_no_';
      END IF;
      IF release_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :release_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND release_no = :release_no_';
      END IF;
      IF line_item_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :line_item_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND line_item_no = :line_item_no_';
      END IF;      
      IF part_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :part_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND part_no = :part_no_';
      END IF;
      IF configuration_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
      END IF;      
      IF location_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :location_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND location_no = :location_no_';
      END IF;
      IF lot_batch_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
      END IF;      
      IF serial_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND serial_no = :serial_no_';
      END IF;
      IF eng_chg_level_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
      END IF;
      IF waiv_dev_rej_no_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
      END IF;
      IF activity_seq_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
      END IF;
      IF handling_unit_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
      ELSE
         stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
      END IF;
      IF alt_handling_unit_label_id_ IS NULL THEN                       
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
      ELSIF alt_handling_unit_label_id_ = '%' THEN
         stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
      ELSE
         stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
      END IF;


      IF (lov_type_db_  = Data_Capture_Config_Lov_API.DB_AUTO_PICK) THEN
         -- Don't use DISTINCT select for AUTO PICK and can have the normal order since only 1 value will be picked anyway
         stmt_ := 'SELECT ' || stmt_ || ' ORDER BY Utility_SYS.String_To_Number (' || column_name_ || ') ASC, ' || column_name_ || ' ASC' ;
      ELSE
         stmt_ := 'SELECT distinct ' || stmt_ || ' ORDER BY Utility_SYS.String_To_Number (' || column_name_ || ') ASC, ' || column_name_ || ' ASC';
      END IF;

      @ApproveDynamicStatement(2014-12-09,UdGnlk)
      OPEN get_lov_values_ FOR stmt_ USING contract_,
                                           Material_Requis_Type_API.DB_INT,
                                           order_no_,
                                           line_no_,
                                           release_no_,
                                           line_item_no_,
                                           part_no_,
                                           configuration_id_,
                                           location_no_,
                                           lot_batch_no_,
                                           serial_no_,
                                           eng_chg_level_,
                                           waiv_dev_rej_no_,  
                                           activity_seq_,
                                           handling_unit_id_,
                                           alt_handling_unit_label_id_;

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
   userid_          VARCHAR2(30) := Fnd_Session_Api.Get_Fnd_User;
BEGIN
   IF NOT (User_Allowed_Site_API.Check_Exist(userid_, contract_)) THEN
      RETURN;
   END IF;

   IF (NOT inv_barcode_validation_) THEN  
      -- extra column check to be sure we have no risk for sql injection into column_name/data_item_id
      Assert_SYS.Assert_Is_View_Column('MATERIAL_REQUIS_RESERVAT_PUB', column_name_);
   END IF;

   -- Select is for issue manually action
   stmt_ := 'SELECT 1
             FROM MATERIAL_REQUIS_RESERVAT_PUB 
             WHERE contract          = :contract 
               AND order_class_db    = :order_class_db
               AND qty_assigned  > 0
               AND Part_Availability_Control_API.Check_Order_Issue_Control(
                   Inventory_Part_In_Stock_API.Get_Availability_Control_Id(contract, part_no, configuration_id, location_no, 
                                                                           lot_batch_no, serial_no, eng_chg_level, 
                                                                           waiv_dev_rej_no, activity_seq, handling_unit_id)) = ''ORDER ISSUE'' ';
   IF order_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :order_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND order_no = :order_no_';
   END IF;
   IF line_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :line_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND line_no = :line_no_';
   END IF;
   IF release_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :release_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND release_no = :release_no_';
   END IF;
   IF line_item_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :line_item_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND line_item_no = :line_item_no_';
   END IF;      
   IF part_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :part_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND part_no = :part_no_';
   END IF;
   IF configuration_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :configuration_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND configuration_id = :configuration_id_';
   END IF;      
   IF location_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :location_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND location_no = :location_no_';
   END IF;
   IF lot_batch_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :lot_batch_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND lot_batch_no = :lot_batch_no_';
   END IF;      
   IF serial_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :serial_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND serial_no = :serial_no_';
   END IF;
   IF eng_chg_level_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :eng_chg_level_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND eng_chg_level = :eng_chg_level_';
   END IF;
   IF waiv_dev_rej_no_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :waiv_dev_rej_no_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND waiv_dev_rej_no = :waiv_dev_rej_no_';
   END IF;
   IF activity_seq_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :activity_seq_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND activity_seq = :activity_seq_';
   END IF;
   IF handling_unit_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND :handling_unit_id_ IS NULL';
   ELSE
      stmt_ := stmt_ || ' AND handling_unit_id = :handling_unit_id_';
   END IF;
   IF alt_handling_unit_label_id_ IS NULL THEN                       
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id is NULL AND :alt_handling_unit_label_id_ IS NULL';
   ELSIF alt_handling_unit_label_id_ = '%' THEN
      stmt_ := stmt_ || ' AND :alt_handling_unit_label_id_ =''%''';
   ELSE
      stmt_ := stmt_ || ' AND alt_handling_unit_label_id = :alt_handling_unit_label_id_';
   END IF;

   IF (NOT inv_barcode_validation_) THEN  
   -- only validate column if this is not a barcode validation since if its barcode validation we want to validate the whole record and not 1 item
      IF (column_value_nullable_) THEN
         stmt_ := stmt_ || ' AND ((' || column_name_ || ' = :column_value_) OR (' || column_name_ || ' IS NULL AND :column_value_ IS NULL)) ';
      ELSE -- NOT column_value_nullable_
        stmt_ := stmt_ || ' AND ' || column_name_ ||'  = :column_value_ ';
      END IF;
   END IF;


   IF (inv_barcode_validation_) THEN
      -- No column value exist check, only check the rest of the keys
      @ApproveDynamicStatement(2017-11-13,DAZASE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          Material_Requis_Type_API.DB_INT,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
                                          part_no_,
                                          configuration_id_,
                                          location_no_,
                                          lot_batch_no_,
                                          serial_no_,
                                          eng_chg_level_,
                                          waiv_dev_rej_no_,  
                                          activity_seq_,
                                          handling_unit_id_,
                                          alt_handling_unit_label_id_;

   ELSIF (column_value_nullable_) THEN
      -- Column value check on a nullable column
      @ApproveDynamicStatement(2015-11-04,DAZASE)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          Material_Requis_Type_API.DB_INT,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
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
                                          column_value_,
                                          column_value_;
   ELSE
      -- Column value check without any nullable handling
      @ApproveDynamicStatement(2014-12-09,UdGnlk)
      OPEN exist_control_ FOR stmt_ USING contract_,
                                          Material_Requis_Type_API.DB_INT,
                                          order_no_,
                                          line_no_,
                                          release_no_,
                                          line_item_no_,
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


FUNCTION Check_Exist (
   order_class_db_   IN VARCHAR2,
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   exist_ BOOLEAN := FALSE;
BEGIN
   exist_ := Check_Exist___(order_class_db_,
                            order_no_,
                            line_no_,
                            release_no_,
                            line_item_no_,
                            part_no_,
                            contract_,
                            configuration_id_,
                            location_no_,
                            lot_batch_no_,
                            serial_no_,
                            waiv_dev_rej_no_,
                            eng_chg_level_,
                            activity_seq_, 
                            handling_unit_id_);
   RETURN exist_;
END Check_Exist;

-- Reserve_Or_Unreserve_On_Swap
--   Add or Modify reservations to facilitate the move of reserved stock
PROCEDURE Reserve_Or_Unreserve_On_Swap (
   qty_reserved_     OUT NUMBER,   
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,   
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_to_reserve_   IN NUMBER )
IS   
   order_class_            VARCHAR2(50);
BEGIN
   order_class_   := Material_Requis_Type_API.Decode(Material_Requis_Type_API.DB_INT);            
   
   Material_Requis_Reservat_API.Make_Part_Reservations(order_class_ => order_class_,
                                                       order_no_ => order_no_,
                                                       line_no_ => line_no_,
                                                       release_no_ => release_no_,
                                                       line_item_no_ => line_item_no_,
                                                       part_no_ => part_no_,
                                                       contract_ => contract_,                                                       
                                                       location_no_ => location_no_,
                                                       lot_batch_no_ => lot_batch_no_,
                                                       serial_no_ => serial_no_,
                                                       waiv_dev_rej_no_ => waiv_dev_rej_no_,
                                                       eng_chg_level_ => eng_chg_level_,
                                                       activity_seq_ => activity_seq_,
                                                       handling_unit_id_ => handling_unit_id_,
                                                       qty_reserve_ => qty_to_reserve_);
                                             
   qty_reserved_ := qty_to_reserve_;
END Reserve_Or_Unreserve_On_Swap;


PROCEDURE Lock_Res_And_Fetch_Info (
   qty_assigned_     OUT NUMBER,   
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   release_no_       IN VARCHAR2,
   line_item_no_     IN NUMBER,
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER )
IS   
   order_class_db_   MATERIAL_REQUIS_RESERVAT_TAB.order_class%TYPE;
   rec_              MATERIAL_REQUIS_RESERVAT_TAB%ROWTYPE;    
BEGIN
   order_class_db_   := Material_Requis_Type_API.DB_INT;            
   
   rec_ := Lock_By_Keys___(order_class_db_, 
                           order_no_, 
                           line_no_, 
                           release_no_, 
                           line_item_no_, 
                           part_no_, 
                           contract_, 
                           configuration_id_, 
                           location_no_, 
                           lot_batch_no_, 
                           serial_no_, 
                           waiv_dev_rej_no_, 
                           eng_chg_level_, 
                           activity_seq_, 
                           handling_unit_id_);
                                             
   qty_assigned_ := rec_.qty_assigned;
END Lock_Res_And_Fetch_Info;
