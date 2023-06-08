-----------------------------------------------------------------------------
--
--  Logical unit: ReservedLotBatch
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211006  SBalLK  SC21R2-3202, Modified Is_Reservation_Allowed() method use information from lot batch master public record.
--  210808  AmPalk MFZ-8113, Merged Bug 158529, MFZ-7188. Added lot-serail tracked part split capability to Transfer_Reserved_Lot.
--  210302  MUSHLK  MFZ-6900, Merged LCS Patch 157366.
--                  210202  JOANSE  Bug 157366, Modified methods Insert___(), Update___() and Insert_Data() to handle the re-building of tracked srucures for substitute parts.
--  210104  SBalLK  Issue SC2020R1-11830, Modified both Update___(), Check_Insert___(), Insert_Data(), Transfer_Reserved_Lot(),
--  210104          Create_Reserved_Lots() and Modify_Reserved_Qty() methods by removing attr_ functionality to optimize the performance.
--  190826  MAATLK  MFUXXW4-29458, Modified the method Insert_Data() to set the INFO_FLAG correctly.
--  180927  LEPESE  MFUXXW4-13414, Added overloaded versions of Modify and Remove including info_ OUT parameter. 
--  171109  SBalLK  Bug 138413, Modified Is_Reservation_Allowed() method to validate lot batch number is used in inventory transactions.
--  170518  VISALK STRMF-11991, Changed the info message text.
--  170418  MaEelk STRSC-7191, Added Conditional Compilations to the SHPORD related calls in Update___
--  170417  VISALK STRMF-10306, Modified Check_Insert___() Update() to change the condition before rasing info message.
--  160524  ShPrlk Bug 128426, Modified Validate_Order_Info to check order state and pop up relevant error message. 
--  151202  VISALK STRMF-1812, Modified Check_Insert___() and Check_Update___() to give and INFO message when primary compounding material exists.
--  131128  SuJalk PBMF-3040, Assigned a value to remrec_ in Remove__.
--  130729  MaIklk TIBE-1048, Removed global constants and used conditional compilation instead.
--  130621  AyAmlk Bug 110805, Modified Modify() to increase the length of info_.
--  130516  IsSalk Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  130506  NISMLK PCM-2677, Removed unnecessary check from Transfer_Reserved_Lot().
--  121121  RiLase Added method Get_Lot_Batch_No_If_Unique.
--  120914  VISALK Bug 102472, Modified Is_Reservation_Allowed() to raise an error message when lot batch no has been already reserved from inventory.
--  110817  MAANLK Bug 98243, Added function Check_Exist_By_Ref.
--  110510  ANKILK Bug 96404, Added new procedure Modify_Reserved_Qty.
--  110339  LEPESE Modification in Update_Cond_Code_By_Ref to use Get_Rcpt_Issue_Serial_Track_Db.
--  101027  ThImlk Modified the Unpack_Check_Insert___() to prevent reservation of multiple Lot/Batch numbers to multilevel repair shop orders.
--  101013  MaNwlk  Modified Insert___ to update repair replacement history when creating a new reserved lot batch no. 
--  100907  MaAnlk Bug 92688, Modified Transfer_Reserved_Lot to use function to get lot batch no using order information.
--  100820  MaAnlk Bug 92344, Added function Get_Lot_Batch_No_So and modified Get_Next_Lot_Batch_No to use the new function.
--  100423  KRPELK Merge Rose Method Documentation.
--  100421  MoNilk Bug 89892, Modified Create_Reserved_Lots() to add max length check for system generated lot batch no.
--  100211  SaWjlk Bug 87746, Removed the parameter merged_type_ from the method Insert_Data() and added new attribute name LOT_QTY_VALIDATION' 
--  100211         and modified the method Unpack_Check_Insert___ to skip the lot qty validation when it's not needed.
--  -------------------------- 13.0.0 -------------------------------------------- 
--  100120  HimRlk Moved method calls to Transaction_SYS.Logical_Unit_Is_Installed to Global constants.
--  100118  ChFolk Replaced the usages of ShopOrderInt with ShopOrdUtil as ShopOrderInt is obsoleted.
--  090529  SaWjlk Bug 83173, Removed the prog text duplications.
--  090416  DAYJLK Bug 81942, Added procedure Create_Reserved_Lots.
--  081203  ThImlk Bug 76203,Added a new implementation method, Check_Reserved_Lot_Batch___(). Added  a new parameter,
--  081203         merged_type_ to Insert_Data().Modified the Unpack_Check_Insert___().
--  080808  Prawlk Bug 75586, Deleted call for General_SYS.Init_Method in FUNCTION Get_Sum_Qty_Reserved_Ord.
--  080512  ErSrLK Bug 71179, Modified Transfer_Reserved_Lot to avoid creatiing unwanted lot batch numbers.
--  080303  SUSALK Bug 70780, Called Shop_Ord_API.Check_Delete_Lot_Reservation method
--  080303         inside the Check_Delete___ method and removed unnecessary code.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060505  MUSHLK Bug 54586, Added condition to check part Serial Tracking in Update_Cond_Code_By_Ref.
--  ----------------------- 12.4.0 -------------------------------------------
--  060314  RIBRUS B137439 Add ConfigurationId param to ValidateOrderInfo. In Update check that new reserved_qty is not less than received into inventory.
--  060303  IsAnlk Modified the error message STRUCTEXIST as requested.
--  060123  JaJalk Added Assert safe annotation.
--  060119  MAATLK Bug 54915, Moved logic from Insert___ to new method 
--  060119         Build_If_Struct_Buildable in Shop_Material_Alloc_List in 
--  060119         SHPORD module and call the new method within Insert___
--  060110  NaWalk Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  051026  KeSmUS Bug 53834, Moved logic from Get_Max_Lot_Batch_No to method of
--                 same name in LotBatchMaster LU where it belongs and replaced
--                 logic with a call to the method there.
--  051017  KeSmus Bug 53117, Modified Update___ so that no structure updates
--                 occur when the reserved_qty for a repair shop order changes.
--  050916  NaLrlk Removed the unused variables.
--  050712  KeSmus Bug 51587, Modified CheckDelete method to allow removal of
--  050712         reserved lot batch records if the shop order is closed.
--  050712         Added code to Is_Reservation_Allowed to allow reservation to
--  050712         be recreated for a manufacturing order when it is reopened.
--  050509  RaKalk LCS-50050 Added method Get_Lot_Batch_Data_Tab.
--  050216  RoJalk Bug 49125, Added the method Check_Lot_Track_Change.
--  040922  RoJalk Bug 46181, Aadded the function Get_Reserved_Lot_Batch_No.
--  040818  RaKalk Added General_SYS.Init_Method call to Method Is_Same_Lot__.
--  040810  DAYJLK Removed the code tags added by merge of LCS Patch 43935.
--  040715  FRWAUS Merged in 43935 as follows:
--          KeSmUS Bug 43935, Added the following condition to the WHERE clause
--                 of SO_LOT_BATCH_LOV view [AND   reserved_qty > 0] and added
--                 PART_NO as a column.
--          KeSmUS Bug 43935, Modified method Create_Order_Based_Lot to not use
--                 Shop_Ord_Lot_Batch_No methods or to insert a record there as
--                 this happens at receipt time.
--          KeSmUS Bug 43935, Modified method Get_Reserved_Qty added part_no_ as a parameter.
--          KeSmUS Bug 43935, Added method Is_Same_Lot__.
--          KeSmUS Bug 43935, Added dynamic SQL to trigger the BuildSerialStructures
--                 process when a reserved lot batch is created for a Shop Order.
--          SuDeUs Bug 43935.  Added new procedure Create_Order_Based_Lot.
--  040511  KaDilk Bug 44464, Added gloabl LU constant ShopOrdCode_inst_,ShopOrderInt_inst_and
--  040511         and added error message SHORDERNOTEXIST in procedure Is_Reservation_Allowed.
--  040225  LoPrlk Removed substrb from code. &VIEW was altered.
--  040102  KaDilk Bug 40615, Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___.Moved the check
--  040102         to the client  when total reserved quantity is higher than the shop order lot size.
--  031222  ISANLK Merged lines in the design history to remove red code.
--  031027  AnLaSE Call Id 109344, made ORDER_REF1 nullable.
--  031023  JICE   Always allow reservation of lot batch for Assembly and Repair shop orders.
--  031022  MaEelk Call ID 108974, Assigned the value SHOP REQUISITION to order_type_db_ instead of SHOP REQ.
--  031022         Modified Remove_By_Order_Ref and Validate_Order_Info.
--  031021  AnLaSe Call Id 108783, increased length for order_ref3 to 40. Added Undefine.
--  031013  PrJalk Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  031009  ChIwlk Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to add the
--  031009         error message for shop order requisitions as well.
--  031008  ChIwlk Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to add
--  031008         error messages when total reserved quantity is higher than the shop order lot size.
--  030328  KESMUS Included Lot Batch fixes from 2002 Lot VAP.
--  020906  paskno Call ID: 88599, made static calls to dynamic referenced component dynamic.
--  020826  BEHAUS Call 88096. Added Is_Reservation_Allowed,Validate_Order_Info
--  020812  BEHAUS Changed column alias for SO_LOT_BATCH_LOV.
--  020810  BEHAUS Report proposal or order condition_code to LB Master when insert.
--                 Added Update_Cond_Code_By_Ref
--  020809  BEHAUS Added more logic on Get_Max_Lot_Batch_No
--  020715  BEHAUS Merged from Lot Batch Mod VAP.
--  -----------------------------12.3.0-------------------------
--  020621  BEHA  Lot Batch Mod - Added parameter create_history on Remove_By_Order_Ref
--  020614  BEHA  Lot Batch Mod - reorder parameter call to Get_Id_Version_By_Keys___
--  020612  BEHA  Lot Batch Mod - Handling Shop Requisition Merging.
--  020612  BEHA  Lot Batch Mod - Added order type to History
--  020611  KESM  Lot Batch Mod - Changed view name from LOT_BATCH_LAST_REP
--                to the more appropriate SO_LOT_BATCH_LOV.
--  020607  BEHAUS Lot Batch Mod. General Clean up. Adapt any references to Shpord objects.
--                Removed RESERVED_LOT_BATCH_OP . Relocated SERIAL_LOT_RESERVATION to
--                SerialNoReservStruct on MFGSTD.
--  020607  BEHAUS Lot Batch Mod. Removed UPPERCASE from lot_batch_no comment.
--  020606  BEHA  Lot Batch Mod. more fix on Calc_Number_Of_Batches
--  020606  BEHA  Lot Batch Mod. Devide By Zero Error on Calc_Number_Of_Batches
--  020530  BEHA  Lot Batch Mod. Added Remove_By_Order_Ref
--  020528  KEVS  Pharmaceutical Mod - Added code to prevent multiple lots
--                for a given order if the part has been setup so that only one
--                lot is allowed per order.
--  020522  BEHA  Lot Batch Mod. Added Transfer_Reserved_Lot, added parameter reserved_type_db_
--                to Lot_Batch_Exist. Rose Model Reconciliation.
--  020520  BEHA  Lot Batch Mod. Added call to ShopOrderRequistion.GetContract.
--                Get_Sum_Qty_Reserved_Ord
--  020515  KEVS  Pharmaceutical Mod - Moved this LU from SHPORD and made generic.
--  ------  ----  -----------------------------------------------------------
-----------------------------------------------------------------------------
--  010829  KEVS  Modified view SERIAL_LOT_RESERVATION so that WDR is included.
--  010813  KEVS  Modified union view (SERIAL_LOT_RESERVATION) so that parts
--                which are serial and lot tracked will not show up twice but
--                from the serial view.
--  010720  Memena FS mod, added parameter in method call New_In_Inventory.
--                 Added new public method Modify.
--  010718  Memena FS mod, add some new attributes.
--  010628  KEVS  Added new view SERIAL_LOT_RESERVATION which is a union of
--                Reserved_Lot_Batch_TAB and Serial_No_Reservation_TAB for use
--                in the newly modified ShopOrdSerialTree form.
--  010615  KEVS  Added Remove method.
--  010509  YOHE  Created for PHS projec
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE lot_batch_no_rec IS RECORD(lot_batch_no   VARCHAR2(20));

TYPE lot_batch_no_table IS TABLE OF lot_batch_no_rec
   INDEX BY BINARY_INTEGER;

TYPE Res_Lot_Batch_Rec IS RECORD
   (lot_batch_no  reserved_lot_batch_tab.lot_batch_no%TYPE,
    reserved_qty  reserved_lot_batch_tab.reserved_qty%TYPE);

TYPE Res_Lot_Batch_Table IS TABLE OF Res_Lot_Batch_Rec
   INDEX BY BINARY_INTEGER;   


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Reserved_Lot_Batch___ (
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2,
   order_ref3_          IN VARCHAR2,
   reserved_lot_qty_    IN NUMBER,
   reservation_type_db_ IN VARCHAR2 )
IS
BEGIN
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      IF (reservation_type_db_ = 'SHOP_ORD') THEN
         Shop_Ord_API.Check_Reserved_Lot_Batch(order_ref1_, order_ref2_, order_ref3_, reserved_lot_qty_);
      ELSIF (reservation_type_db_ = 'SHOP_REQ') THEN
         Shop_Order_Prop_API.Check_Plan_Order_Rec(order_ref1_, reserved_lot_qty_);
      END IF;
   $ELSE
      NULL;
   $END
END Check_Reserved_Lot_Batch___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT RESERVED_LOT_BATCH_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   rebuild_tracked_structure_ VARCHAR2(5);
BEGIN
   super(objid_, objversion_, newrec_, attr_);

   Client_SYS.Add_To_Attr('CREATE_DATE', newrec_.create_date, attr_); 

   IF newrec_.reservation_type = 'SHOP_ORD' THEN
      $IF (Component_Shpord_SYS.INSTALLED) $THEN
         rebuild_tracked_structure_ := NVL(Client_SYS.Get_Item_Value('REBUILD_TRACKED_STRUCTURE', attr_), Fnd_Boolean_API.DB_TRUE);
         IF (rebuild_tracked_structure_ = Fnd_Boolean_API.DB_TRUE) THEN
            Shop_Material_Alloc_List_API.Build_If_Struct_Buildable(newrec_.order_ref1,
                                                                   newrec_.order_ref2,
                                                                   newrec_.order_ref3,
                                                                   newrec_.lot_batch_no);              
         END IF;
         
         Shop_Ord_Util_API.Handle_Lot_Batch_Details(newrec_.order_ref1,
                                                    newrec_.order_ref2,
                                                    newrec_.order_ref3,
                                                    newrec_.lot_batch_no);
      $ELSE
         NULL;
      $END
      END IF;

EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     RESERVED_LOT_BATCH_TAB%ROWTYPE,
   newrec_     IN OUT RESERVED_LOT_BATCH_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE,
   info_need_  IN BOOLEAN DEFAULT TRUE )
IS
   contract_                      VARCHAR2(5);
   order_type_db_                 VARCHAR2(20);
   condition_code_                VARCHAR2(10);
   message_                       VARCHAR2(2000);
   sequence_no_                   NUMBER;
   order_code_db_                 VARCHAR2(20);
   configuration_id_              VARCHAR2(50);
   sum_qty_received_              NUMBER;
   so_lot_size_                   NUMBER;
   rebuild_tracked_structure_     VARCHAR2(5);
BEGIN

   Reserved_Lot_Batch_API.Validate_Order_Info (
      contract_,
      order_type_db_,
      condition_code_,
      configuration_id_,
      newrec_.order_ref1,
      newrec_.order_ref2,
      newrec_.order_ref3,
      newrec_.order_ref4,
      newrec_.reservation_type );

-- Ensure that new reserved qty is not less than already in inventory for this order.
   IF newrec_.reserved_qty < oldrec_.reserved_qty AND newrec_.reservation_type = 'SHOP_ORD' THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         sum_qty_received_ := Inventory_Transaction_Hist_API.Get_Sum_Qty_Received (
                                     newrec_.order_ref1, newrec_.order_ref2, newrec_.order_ref3, NULL,
                                     'SHOP ORDER', contract_, newrec_.part_no, configuration_id_,
                                     newrec_.lot_batch_no );      
      $END
      IF newrec_.reserved_qty < NVL(sum_qty_received_,0) THEN
         Error_SYS.Record_General(lu_name_, 'SORESERVEKEEP: Cannot reduce reservation to less than received.');
      END IF;
   END IF;

   IF ( oldrec_.reserved_qty <> newrec_.reserved_qty ) THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'UPDRSVLOTQTY: Reserved Lot Batch quantity is modified on Order No :P1', NULL, newrec_.order_ref1 || '-' || newrec_.order_ref2 || '-' || newrec_.order_ref3);
      Lot_Batch_History_API.New(
                             sequence_no_,
                             newrec_.lot_batch_no,
                             newrec_.part_no,
                             contract_,
                             SYSDATE,
                             message_,
                             newrec_.reserved_qty,
                             order_type_db_,
                             newrec_.order_ref1,
                             newrec_.order_ref2,
                             newrec_.order_ref3,
                             newrec_.order_ref4,
                             NULL );
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   -- This must happen after the update
   IF ( oldrec_.reserved_qty <> newrec_.reserved_qty ) THEN
      IF newrec_.reservation_type = 'SHOP_ORD' THEN
         $IF (Component_Mfgstd_SYS.INSTALLED AND Component_Shpord_SYS.INSTALLED) $THEN
            order_code_db_ := Shop_Ord_Code_API.Encode(Shop_Ord_Util_API.Get_Order_Code(newrec_.order_ref1, newrec_.order_ref2, newrec_.order_ref3));              
         $ELSE
            NULL;
         $END
         END IF;
      --
      IF NVL(order_code_db_, 'F') != 'F' THEN
         -- Trigger update of child structures
         $IF (Component_Mfgstd_SYS.INSTALLED) $THEN
            rebuild_tracked_structure_ := NVL(Client_SYS.Get_Item_Value('REBUILD_TRACKED_STRUCTURE', attr_), Fnd_Boolean_API.DB_TRUE);
            Serial_No_Reserv_Struct_API.Modify_Lot_Qty (newrec_.part_no,
                                                        newrec_.lot_batch_no,
                                                        newrec_.reserved_qty,
                                                        rebuild_tracked_structure_);
            -- Not sure this will be needed
            As_Built_Configuration_API.Modify_Lot_Qty (newrec_.part_no,
                                                       newrec_.lot_batch_no,
                                                       newrec_.reserved_qty);              
         $ELSE
            NULL;
         $END
         END IF;
      END IF;

      $IF (Component_Shpord_SYS.INSTALLED) $THEN     
         IF (newrec_.reservation_type = 'SHOP_ORD') THEN
            so_lot_size_ := NVL(Shop_Ord_API.Get_Revised_Qty_Due(newrec_.order_ref1, newrec_.order_ref2, newrec_.order_ref3), 0);
            IF (so_lot_size_ <= Get_Sum_Qty_Reserved_Ord(   newrec_.order_ref1,
                                                             newrec_.order_ref2,
                                                             newrec_.order_ref3,
                                                             newrec_.order_ref4,
                                                             newrec_.reservation_type)) THEN

               IF((Shop_Material_Alloc_API.Check_Pri_Comp_Material_Ext(newrec_.order_ref1,
                                                                       newrec_.order_ref2,
                                                                       newrec_.order_ref3) = 1))THEN
                  IF (info_need_) THEN                                                      
                     Client_SYS.Add_Info(lu_name_, 'MANRESEVPCMINFO: Reserving Lot Number manually will prevent inheriting Lot Number from the component defined as Lot/Batch Origin at the time of issuing material.');
                  END IF;  
               END IF;
            END IF;
         END IF;
      $ELSE
         NULL;
      $END
        
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN reserved_lot_batch_tab%ROWTYPE )
IS
BEGIN
   super(remrec_);
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      Shop_Ord_API.Check_Delete_Lot_Reservation(remrec_.order_ref1, remrec_.order_ref2, remrec_.order_ref3, remrec_.part_no, remrec_.lot_batch_no); 
   $END
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_              IN OUT reserved_lot_batch_tab%ROWTYPE,
   indrec_              IN OUT Indicator_Rec,
   attr_                IN OUT VARCHAR2,
   lot_qty_validation_  IN BOOLEAN DEFAULT TRUE,
   info_need_           IN BOOLEAN DEFAULT TRUE )
IS 
   contract_                      VARCHAR2(5);
   message_                       VARCHAR2(2000);
   order_type_db_                 VARCHAR2(20);
   condition_code_                VARCHAR2(10);
   partca_rec_                    Part_Catalog_API.Public_Rec;
   configuration_id_              VARCHAR2(50);
   stmt_                          VARCHAR2(2000);
   so_lot_size_                   NUMBER;
BEGIN
   newrec_.create_date := SYSDATE;
   partca_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   
   IF newrec_.order_ref2 IS NOT NULL THEN
      newrec_.reservation_type := 'SHOP_ORD';
   ELSE
      newrec_.reservation_type := 'SHOP_REQ';
   END IF;
   -- Check the lot qty rule and prevent multiple lots if needed
   IF (partca_rec_.lot_quantity_rule = 'ONE_LOT') THEN
      IF Reserved_Lot_Batch_API.Lot_Batch_Exist(
            newrec_.order_ref1,
            newrec_.order_ref2,
            newrec_.order_ref3,
            newrec_.order_ref4,
            newrec_.reservation_type ) = 1
      THEN
      -- Allow multiple records per shop order if lots match and parts differ
         IF newrec_.reservation_type <> 'SHOP_ORD' OR NOT
            Is_Same_Lot__(
               newrec_.part_no,
               newrec_.lot_batch_no,
               newrec_.order_ref1,
               newrec_.order_ref2,
               newrec_.order_ref3,
               newrec_.order_ref4,
               newrec_.reservation_type )
         THEN
            Error_SYS.Record_General(lu_name_, 'ONELOTORD: Only one lot per order is allowed for this part');
         END IF;
      END IF;     
   END IF;
   
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      IF (newrec_.reservation_type = 'SHOP_ORD') THEN
         so_lot_size_ := NVL(Shop_Ord_API.Get_Revised_Qty_Due(newrec_.order_ref1, newrec_.order_ref2, newrec_.order_ref3), 0);
         IF (so_lot_size_ = newrec_.reserved_qty + Get_Sum_Qty_Reserved_Ord(
                                                          newrec_.order_ref1,
                                                          newrec_.order_ref2,
                                                          newrec_.order_ref3,
                                                          newrec_.order_ref4,
                                                          newrec_.reservation_type)) THEN
            IF( Shop_Material_Alloc_API.Check_Pri_Comp_Material_Ext(newrec_.order_ref1,
                                                                    newrec_.order_ref2,
                                                                    newrec_.order_ref3) = 1) THEN
               IF (info_need_ AND (Part_Catalog_API.Get_Lot_Tracking_Code_Db(newrec_.part_no)= 'LOT TRACKING')) THEN
                  Client_SYS.Add_Info(lu_name_, 'MANRESEVPCMINFO: Reserving Lot Number manually will prevent inheriting Lot Number from the component defined as Lot/Batch Origin at the time of issuing material.');
               END IF;   
            END IF;
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
   
   IF (lot_qty_validation_ )THEN
      Check_Reserved_Lot_Batch___(newrec_.order_ref1,
                                  newrec_.order_ref2,
                                  newrec_.order_ref3,
                                  newrec_.reserved_qty + Get_Sum_Qty_Reserved_Ord(
                                                          newrec_.order_ref1,
                                                          newrec_.order_ref2,
                                                          newrec_.order_ref3,
                                                          newrec_.order_ref4,
                                                          newrec_.reservation_type),
                                                          newrec_.reservation_type);
   END IF;

   super(newrec_, indrec_, attr_);

   Reserved_Lot_Batch_API.Validate_Order_Info (
      contract_,
      order_type_db_,
      condition_code_,
      configuration_id_,
      newrec_.order_ref1,
      newrec_.order_ref2,
      newrec_.order_ref3,
      newrec_.order_ref4,
      newrec_.reservation_type );

   IF newrec_.reservation_type = 'SHOP_ORD' THEN
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RSVLOTSHPORD: Reserved Lot Batch from Shop Order No :P1', NULL, newrec_.order_ref1 || '-' || newrec_.order_ref2 || '-' || newrec_.order_ref3);
   ELSE
      message_ := Language_SYS.Translate_Constant(lu_name_, 'RSVLOTSHPPROP: Reserved Lot Batch from Shop Order Requisition :P1', NULL, newrec_.order_ref1 || '-' || newrec_.order_ref2 || '-' || newrec_.order_ref3);
   END IF;

   Lot_Batch_Master_API.New_In_Inventory(newrec_.part_no,
                                         newrec_.lot_batch_no,
                                         contract_,
                                         order_type_db_,
                                         newrec_.order_ref1,
                                         newrec_.order_ref2,
                                         newrec_.order_ref3,
                                         newrec_.order_ref4,
                                         newrec_.create_date,
                                         message_,
                                         newrec_.reserved_qty,
                                         NULL,
                                         NULL,
                                         condition_code_ );

   Reserved_Lot_Batch_API.Is_Reservation_Allowed (
            newrec_.part_no,
            newrec_.lot_batch_no,
            newrec_.order_ref1,
            newrec_.order_ref2,
            newrec_.order_ref3,
            newrec_.order_ref4,
            newrec_.reservation_type );

   IF ((newrec_.reservation_type = 'SHOP_ORD') AND 
       (Lot_Batch_Exist( newrec_.order_ref1,
                         newrec_.order_ref2,
                         newrec_.order_ref3,
                         newrec_.order_ref4,
                         newrec_.reservation_type ) = 1) AND 
        (NOT Is_Same_Lot__(newrec_.part_no,
                           newrec_.lot_batch_no,
                           newrec_.order_ref1,
                           newrec_.order_ref2,
                           newrec_.order_ref3,
                           newrec_.order_ref4,
                           newrec_.reservation_type))) THEN
      stmt_ := 'BEGIN
                  Shop_Ord_Util_API.Check_Multiple_Lot_Reservation(:order_ref1,:order_ref2,:order_ref3);
                END;';
      @ApproveDynamicStatement(2010-10-27,ThImlk)
      EXECUTE IMMEDIATE stmt_
         USING IN  newrec_.order_ref1,
               IN  newrec_.order_ref2,
               IN  newrec_.order_ref3;
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_     IN     reserved_lot_batch_tab%ROWTYPE,
   newrec_     IN OUT reserved_lot_batch_tab%ROWTYPE,
   indrec_     IN OUT Indicator_Rec,
   attr_       IN OUT VARCHAR2,
   info_need_  IN     BOOLEAN DEFAULT TRUE )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);   
BEGIN
   IF newrec_.order_ref2 IS NOT NULL THEN
      newrec_.reservation_type := 'SHOP_ORD';
   ELSE
      newrec_.reservation_type := 'SHOP_REQ';
   END IF;
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      IF (newrec_.reservation_type = 'SHOP_ORD') THEN
         IF((Shop_Material_Alloc_API.Check_Pri_Comp_Material_Ext(newrec_.order_ref1,
                                                                 newrec_.order_ref2,
                                                                 newrec_.order_ref3) = 1) AND (oldrec_.lot_batch_no != newrec_.lot_batch_no))THEN
            IF (info_need_) THEN                                                      
               Client_SYS.Add_Info(lu_name_, 'MANRESEVPCMINFO: Reserving Lot Number manually will prevent inheriting Lot Number from the component defined as Lot/Batch Origin at the time of issuing material.');
            END IF;  
         END IF;
      END IF;
   $ELSE
      NULL;
   $END
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_           reserved_lot_batch_tab%ROWTYPE;
   sequence_no_      NUMBER;
   message_          VARCHAR2(2000);
   contract_         VARCHAR2(5);
   order_type_db_    VARCHAR2(20);
   condition_code_   VARCHAR2(10);
   configuration_id_ VARCHAR2(50);
BEGIN
   IF (action_ = 'DO') THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      IF remrec_.reservation_type = 'SHOP_ORD' THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'REMLOTRESSO: Removed reserved Lot Batch from Shop Order No :P1', NULL, remrec_.order_ref1 || '-' || remrec_.order_ref2 || '-' || remrec_.order_ref3);
      ELSIF remrec_.reservation_type = 'SHOP_REQ' THEN
         message_ := Language_SYS.Translate_Constant(lu_name_, 'REMLOTRESREQ: Removed reserved Lot Batch from Shop Order Requisition No :P1', NULL, remrec_.order_ref1 || '-' || remrec_.order_ref2 || '-' || remrec_.order_ref3);
      END IF;

      Reserved_Lot_Batch_API.Validate_Order_Info (
         contract_,
         order_type_db_,
         condition_code_,
         configuration_id_,
         remrec_.order_ref1,
         remrec_.order_ref2,
         remrec_.order_ref3,
         remrec_.order_ref4,
         remrec_.reservation_type );
   END IF;
      
   super(info_, objid_, objversion_, action_);
   
   IF (action_ = 'DO') THEN
       Lot_Batch_History_API.New(
                          sequence_no_,
                          remrec_.lot_batch_no,
                          remrec_.part_no,
                          contract_,
                          SYSDATE,
                          message_,
                          remrec_.reserved_qty,
                          order_type_db_,
                          remrec_.order_ref1,
                          remrec_.order_ref2,
                          remrec_.order_ref3,
                          remrec_.order_ref4,
                          NULL );
   END IF; 
   info_ := info_ || Client_SYS.Get_All_Info;                      
END Remove__;


FUNCTION Is_Same_Lot__ (
   part_no_             IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2 DEFAULT NULL,
   order_ref3_          IN VARCHAR2 DEFAULT NULL,
   order_ref4_          IN NUMBER   DEFAULT NULL,
   reservation_type_db_ IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
   temp_           NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM   reserved_lot_batch_tab
      WHERE part_no <> part_no_
      AND   lot_batch_no = lot_batch_no_
      AND   reservation_type = NVL(reservation_type_db_, 'SHOP_ORD')
      AND   NVL(order_ref4, 0) = NVL(order_ref4_, NVL(order_ref4, 0))
      AND   NVL(order_ref3, 'key') = NVL(order_ref3_, NVL(order_ref3, 'key'))
      AND   NVL(order_ref2, 'key') = NVL(order_ref2_, NVL(order_ref2, 'key'))
      AND   order_ref1 = order_ref1_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%FOUND THEN
      CLOSE get_attr;
      RETURN TRUE;
   END IF;
   CLOSE get_attr;
   RETURN FALSE;
END Is_Same_Lot__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Sum_Qty_Reserved_Ord
--   Sum of sub lots reserved qtys
@UncheckedAccess
FUNCTION Get_Sum_Qty_Reserved_Ord (
   order_ref1_   IN VARCHAR2,
   order_ref2_   IN VARCHAR2,
   order_ref3_   IN VARCHAR2,
   order_ref4_   IN NUMBER,
   reservation_type_db_ IN VARCHAR2 ) RETURN NUMBER
IS
   -- Get Sum Qty reserved by Order
   temp_ reserved_lot_batch_tab.reserved_qty%TYPE;
   CURSOR get_attr IS
      SELECT SUM (reserved_qty)
      FROM   reserved_lot_batch_tab
      WHERE NVL(order_ref4, 0) = NVL(order_ref4_, NVL(order_ref4, 0))
      AND   NVL(order_ref3, 'key') = NVL(order_ref3_, NVL(order_ref3, 'key'))
      AND   NVL(order_ref2, 'key') = NVL(order_ref2_, NVL(order_ref2, 'key'))
      AND   order_ref1 = order_ref1_
      AND   reservation_type = reservation_type_db_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN nvl(temp_,0);
END Get_Sum_Qty_Reserved_Ord;


-- Calc_Number_Of_Batches
--   Calculate number of batches required for given lot size.
FUNCTION Calc_Number_Of_Batches (
   std_lot_size_ IN NUMBER,
   qty_          IN NUMBER ) RETURN NUMBER
IS
   no_of_batches_ NUMBER:=0;
   lot_size_      NUMBER:= NVL(std_lot_size_,1);
BEGIN
   IF ( lot_size_ = 0) THEN
      RETURN 1;
   END IF;
   no_of_batches_ := qty_/ lot_size_;
   RETURN  CEIL(no_of_batches_);
END Calc_Number_Of_Batches;


-- Check_Exist
--   Return 1 if record exist, 0 otherwise
FUNCTION Check_Exist (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (NOT Check_Exist___(part_no_,lot_batch_no_)) THEN
      RETURN 0;
   END IF;
   RETURN 1;
END Check_Exist;


-- Get_Max_Lot_Batch_No
--   Return maximum number of given Lot Batch No pattern.
@UncheckedAccess
FUNCTION Get_Max_Lot_Batch_No (
   lot_batch_no_in_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Lot_Batch_Master_API.Get_Max_Lot_Batch_No(lot_batch_no_in_);
END Get_Max_Lot_Batch_No;


-- Get_Reserved_Qty
--   Get reserved qty for given order numbers.
FUNCTION Get_Reserved_Qty (
   order_ref1_   IN VARCHAR2,
   order_ref2_   IN VARCHAR2,
   order_ref3_   IN VARCHAR2,
   order_ref4_   IN NUMBER,
   lot_batch_no_ IN VARCHAR2,
   part_no_      IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   temp_           reserved_lot_batch_tab.reserved_qty%TYPE;
   so_part_no_     VARCHAR2(25);
   CURSOR get_attr IS
      SELECT reserved_qty
      FROM   reserved_lot_batch_tab
      WHERE NVL(order_ref4, 0) = NVL(order_ref4_, NVL(order_ref4, 0))
      AND   NVL(order_ref3, 'key') = NVL(order_ref3_, NVL(order_ref3, 'key'))
      AND   NVL(order_ref2, 'key') = NVL(order_ref2_, NVL(order_ref2, 'key'))
      AND   part_no = nvl(part_no_, nvl(so_part_no_, part_no))
      AND   order_ref1 = order_ref1_
      AND   lot_batch_no = lot_batch_no_;
BEGIN
   IF order_ref2_ IS NOT NULL AND part_no_ IS NULL THEN
      $IF (Component_Shpord_SYS.INSTALLED) $THEN
         so_part_no_ := Shop_Ord_API.Get_Part_No(order_ref1_, order_ref2_, order_ref3_);        
      $ELSE
         Error_SYS.Record_General(lu_name_, 'SHPORDNOTINST: Operation cannot be completed. Shop Order must be installed.');
      $END
      END IF;
   --
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Reserved_Qty;


-- Insert_Data
--   Public Insert new record to this LU.
PROCEDURE Insert_Data (
   part_no_          IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   reservation_type_ IN VARCHAR2,
   reserved_qty_     IN NUMBER,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN NUMBER DEFAULT NULL,
   rebuild_tracked_structure_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_TRUE)
IS
   attr_                VARCHAR2(2000);
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   indrec_              Indicator_Rec;
   newrec_              reserved_lot_batch_tab%ROWTYPE;
   reservation_type_db_ reserved_lot_batch_tab.reservation_type%TYPE;
   info_need_           BOOLEAN := TRUE;
BEGIN
   reservation_type_db_     := Reservation_Type_API.Encode(reservation_type_);
   newrec_.part_no          := part_no_;
   newrec_.lot_batch_no     := lot_batch_no_;
   newrec_.reservation_type := reservation_type_db_;
   newrec_.reserved_qty     := reserved_qty_;
   newrec_.order_ref1       := order_ref1_;
   newrec_.order_ref2       := order_ref2_;
   newrec_.order_ref3       := order_ref3_;
   newrec_.order_ref4       := order_ref4_;
   
   Client_SYS.Clear_Attr(attr_);
  
   Client_SYS.Add_To_Attr('REBUILD_TRACKED_STRUCTURE', rebuild_tracked_structure_, attr_); 
   IF (reservation_type_db_ = 'SHOP_ORD') THEN
      info_need_ := FALSE;
   END IF;
   indrec_ :=  Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_, lot_qty_validation_ => FALSE, info_need_ => info_need_);
   Insert___(objid_, objversion_, newrec_, attr_);
END Insert_Data;


-- Lot_Batch_Exist
--   Check existence of record by given order numbers
@UncheckedAccess
FUNCTION Lot_Batch_Exist (
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2 DEFAULT NULL,
   order_ref3_ IN VARCHAR2 DEFAULT NULL,
   order_ref4_ IN NUMBER   DEFAULT NULL,
   reservation_type_db_  IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
   temp_           NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM   reserved_lot_batch_tab
      WHERE reservation_type = NVL(reservation_type_db_, 'SHOP_ORD')
      AND   NVL(order_ref4, 0) = NVL(order_ref4_, NVL(order_ref4, 0))
      AND   NVL(order_ref3, 'key') = NVL(order_ref3_, NVL(order_ref3, 'key'))
      AND   NVL(order_ref2, 'key') = NVL(order_ref2_, NVL(order_ref2, 'key'))
      AND   order_ref1 = order_ref1_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%FOUND THEN
      CLOSE get_attr;
      RETURN 1;
   END IF;
   CLOSE get_attr;
   RETURN 0;
END Lot_Batch_Exist;


-- Modify
--   Public procedure for updating this LU
PROCEDURE Modify (   
   attr_         IN OUT VARCHAR2,
   part_no_      IN     VARCHAR2,
   lot_batch_no_ IN     VARCHAR2 )
IS
   info_       VARCHAR2(2000);
BEGIN
   Modify( info_, attr_, part_no_, lot_batch_no_);
END Modify;

PROCEDURE Modify (
   info_            OUT VARCHAR2,
   attr_         IN OUT VARCHAR2,
   part_no_      IN     VARCHAR2,
   lot_batch_no_ IN     VARCHAR2 )
IS
   objid_      reserved_lot_batch.objid%TYPE;
   objversion_ reserved_lot_batch.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, lot_batch_no_);
   Modify__( info_, objid_, objversion_, attr_, 'DO' );
END Modify;


-- Remove
--   Public procedure for removing record for this LU
PROCEDURE Remove (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
BEGIN
   Remove(info_, part_no_, lot_batch_no_);
END Remove;

PROCEDURE Remove (
   info_            OUT VARCHAR2,
   part_no_      IN     VARCHAR2,
   lot_batch_no_ IN     VARCHAR2 )
IS
   remrec_     reserved_lot_batch_tab%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, part_no_, lot_batch_no_);
   remrec_ := Lock_By_Keys___(part_no_,lot_batch_no_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
   info_ := Client_SYS.Get_All_Info;
END Remove;

-- Transfer_Reserved_Lot
--   Public procedure for transferring the existing reservation between orders.
--   Depend on parameters given; this procedure will try to create reservation
--   if it is not existence.
PROCEDURE Transfer_Reserved_Lot (
   lot_batch_no_          IN OUT VARCHAR2,
   part_no_               IN     VARCHAR2,
   from_order_ref1_       IN     VARCHAR2,
   from_order_ref2_       IN     VARCHAR2,
   from_order_ref3_       IN     VARCHAR2,
   from_order_ref4_       IN     NUMBER,
   from_reserved_type_db_ IN     VARCHAR2,
   to_order_ref1_         IN     VARCHAR2,
   to_order_ref2_         IN     VARCHAR2,
   to_order_ref3_         IN     VARCHAR2,
   to_order_ref4_         IN     NUMBER,
   to_reserved_type_db_   IN     VARCHAR2,
   to_qty_reserved_       IN     NUMBER )
IS
   CURSOR get_order_source_ IS
      SELECT *
      FROM   reserved_lot_batch_tab
      WHERE NVL(order_ref4, 0) = NVL(from_order_ref4_, NVL(order_ref4, 0))
      AND   NVL(order_ref3, 'key') = NVL(from_order_ref3_, NVL(order_ref3, 'key'))
      AND   NVL(order_ref2, 'key') = NVL(from_order_ref2_, NVL(order_ref2, 'key'))
      AND   order_ref1 = from_order_ref1_
      AND   reservation_type = from_reserved_type_db_;

   count_               NUMBER:=0;
   accum_batch_qty_     NUMBER:=0;
   objid_               VARCHAR2(2000);
   objversion_          VARCHAR2(2000);
   newrec_              reserved_lot_batch_tab%ROWTYPE;
   attr_                VARCHAR2(2000);
   part_catalog_rec_    Part_Catalog_API.Public_Rec;
   max_lot_batch_no_    VARCHAR2(20);
   temp_lot_batch_no_   reserved_lot_batch_tab.lot_batch_no%TYPE;
   indrec_              Indicator_Rec;
   struct_exist_     NUMBER := 0;
   oldrec_           RESERVED_LOT_BATCH_TAB%ROWTYPE;
   -------------------------------------------------------------------
   -- Transfer possesion from:
   --SHOP_ORD to SHOP_ORD -- Shop Order Split
   --SHOP_REQ to SHOP_ORD -- Req to Shop Order for Lot Tracking
   --SHOP_REQ to SHOP_ORD -- Req to Shop Order for Order Based.
   -------------------------------------------------------------------

BEGIN
   Trace_SYS.Message( '== Transfer Reservation from '|| from_reserved_type_db_ || 'to ' || to_reserved_type_db_  );
   --
   IF  ( from_reserved_type_db_ = to_reserved_type_db_ ) THEN
      
      $IF (Component_Mfgstd_SYS.INSTALLED AND Component_Shpord_SYS.INSTALLED) $THEN
      struct_exist_ := Serial_No_Reserv_Struct_API.Exist_Parent_Lot_Ser_Link(
                          part_no_      => part_no_,
                          serial_no_    => NULL,
                          lot_batch_no_ => lot_batch_no_,
                          order_no_     => from_order_ref1_,
                          release_no_   => from_order_ref2_,
                          sequence_no_  => from_order_ref3_);
      $ELSE
         struct_exist_ := 0;
      $END
      IF (NVL(struct_exist_,0) != 1) THEN
         -- Delete Source
         Trace_SYS.Message('==> Delete reservation for lot_batch_no_ '||lot_batch_no_ );
         Remove(part_no_, lot_batch_no_);
         part_catalog_rec_ := Part_Catalog_API.Get(part_no_);
         -- Delete the automatically created lot batch no, when there is already a lot transfer from shop order split
         IF ((part_catalog_rec_.lot_tracking_code = 'ORDER BASED') AND
             (part_catalog_rec_.lot_quantity_rule = 'ONE_LOT' OR
              part_catalog_rec_.multilevel_tracking = 'TRACKING_ON')) THEN
            temp_lot_batch_no_ := Get_Lot_Batch_No_So(to_order_ref1_, to_order_ref2_, to_order_ref3_);
            max_lot_batch_no_ := Lot_Batch_Master_API.Get_Max_Order_Based_Lot_No(temp_lot_batch_no_);
            IF (Check_Exist___(part_no_, max_lot_batch_no_)) THEN
               Remove(part_no_, max_lot_batch_no_);
            END IF;
         END IF;

         --newrec_.reserved_qty := to_qty_reserved_;
         newrec_.part_no          := part_no_;
         newrec_.lot_batch_no     := lot_batch_no_;
         newrec_.reserved_qty     := to_qty_reserved_;
         newrec_.reservation_type := to_reserved_type_db_;
         newrec_.create_date      := SYSDATE;
         newrec_.order_ref1       := to_order_ref1_;
         newrec_.order_ref2       := to_order_ref2_;
         newrec_.order_ref3       := to_order_ref3_;
         newrec_.order_ref4       := to_order_ref4_;
         Client_SYS.Clear_Attr(attr_);
         indrec_ := Get_Indicator_Rec___(newrec_);
         Check_Insert___(newrec_, indrec_, attr_, info_need_ => FALSE);
         Insert___(objid_, objversion_, newrec_, attr_);
      ELSE
         oldrec_ := Lock_By_Keys___(part_no_, lot_batch_no_);
         newrec_ := oldrec_; 
         newrec_.reserved_qty := to_qty_reserved_;
         newrec_.reservation_type := to_reserved_type_db_;
         newrec_.create_date := SYSDATE;
         newrec_.order_ref1 := to_order_ref1_;
         newrec_.order_ref2 := to_order_ref2_;
         newrec_.order_ref3 := to_order_ref3_;
         newrec_.order_ref4 := to_order_ref4_; 
         Unpack___(newrec_, indrec_, attr_);
         Check_Update___(oldrec_, newrec_, indrec_, attr_);
         Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      END IF;
   ELSE
      accum_batch_qty_ := 0;
      FOR source_rec_  IN  get_order_source_ LOOP

         count_   := count_ + 1;
         accum_batch_qty_ := accum_batch_qty_ + source_rec_.reserved_qty;

         -- Delete Source
         Trace_SYS.Message('==> Delete reservation ORDER: '
         || from_order_ref1_ || from_order_ref2_ || from_order_ref3_ || ' Qty: '
         || source_rec_.reserved_qty || ' LOT: ' || source_rec_.lot_batch_no );


         DELETE
           FROM  reserved_lot_batch_tab
           WHERE lot_batch_no = source_rec_.lot_batch_no
           AND   part_no = source_rec_.part_no;

         -- Create New Reservation for Destination Order

         newrec_.part_no := source_rec_.part_no;
         IF  ( lot_batch_no_ IS  NULL ) THEN
          newrec_.lot_batch_no := source_rec_.lot_batch_no;
         ELSE
          newrec_.lot_batch_no := lot_batch_no_;
         END IF;

         Trace_SYS.Message('==> Transfer reservation To ORDER: '
         || to_order_ref1_ || to_order_ref2_ || to_order_ref3_ || ' Qty: '
         || source_rec_.reserved_qty || ' LOT: ' || newrec_.lot_batch_no );

         --newrec_.reserved_qty := to_qty_reserved_;
         newrec_.reserved_qty     := source_rec_.reserved_qty;
         newrec_.reservation_type := to_reserved_type_db_;
         newrec_.create_date      := SYSDATE;
         newrec_.order_ref1       := to_order_ref1_;
         newrec_.order_ref2       := to_order_ref2_;
         newrec_.order_ref3       := to_order_ref3_;
         newrec_.order_ref4       := to_order_ref4_;

         IF  ( to_qty_reserved_ < accum_batch_qty_ ) THEN
           newrec_.reserved_qty := accum_batch_qty_ - to_qty_reserved_ ;
         END IF;

         Client_SYS.Clear_Attr(attr_);
         indrec_ := Get_Indicator_Rec___(newrec_);
         Check_Insert___(newrec_, indrec_, attr_, info_need_ => FALSE);
         Insert___(objid_, objversion_, newrec_, attr_);

         IF ( to_qty_reserved_ <= accum_batch_qty_ ) THEN
           lot_batch_no_ := source_rec_.lot_batch_no;
           EXIT;
         END IF;
         --lot_batch_no_ := source_rec_.lot_batch_no;
      END LOOP;

       -- Force create new reservation record if lot_batch_no is given
      IF ( count_ = 0 ) AND ( lot_batch_no_ IS  NOT NULL ) THEN
         Trace_SYS.Message('==> No res found!  new reservation need to be enforced. ORDER: '
              || from_order_ref1_ || from_order_ref2_ || from_order_ref3_ || ' Qty: '
              || to_qty_reserved_ || ' LOT: ' || lot_batch_no_ );
         newrec_.part_no          := part_no_;
         newrec_.lot_batch_no     := lot_batch_no_;
         newrec_.reserved_qty     := to_qty_reserved_;
         newrec_.reservation_type := to_reserved_type_db_;
         newrec_.create_date      := SYSDATE;
         newrec_.order_ref1       := to_order_ref1_;
         newrec_.order_ref2       := to_order_ref2_;
         newrec_.order_ref3       := to_order_ref3_;
         newrec_.order_ref4       := to_order_ref4_;          
         Client_SYS.Clear_Attr(attr_);
         indrec_ := Get_Indicator_Rec___(newrec_);
         Check_Insert___(newrec_, indrec_, attr_, info_need_ => FALSE);
         Insert___(objid_, objversion_, newrec_, attr_);
      END IF;
   END IF;
END Transfer_Reserved_Lot;


-- Remove_By_Order_Ref
--   Remove record by given  order numbers
PROCEDURE Remove_By_Order_Ref (
   order_ref1_   IN VARCHAR2,
   order_ref2_   IN VARCHAR2,
   order_ref3_   IN VARCHAR2,
   order_ref4_   IN NUMBER,
   reservation_type_db_ IN VARCHAR2,
   contract_       IN VARCHAR2 DEFAULT NULL,
   create_history_ IN NUMBER DEFAULT 0 )
IS
   remrec_     reserved_lot_batch_tab%ROWTYPE;
   CURSOR getrec IS
   SELECT rowid objid,part_no,lot_batch_no,reserved_qty
   FROM   reserved_lot_batch_tab
   WHERE    NVL(order_ref4, 0) = NVL(order_ref4_, NVL(order_ref4, 0))
      AND   NVL(order_ref3, 'key') = NVL(order_ref3_, NVL(order_ref3, 'key'))
      AND   NVL(order_ref2, 'key') = NVL(order_ref2_, NVL(order_ref2, 'key'))
      AND   order_ref1 = order_ref1_
      AND   reservation_type = reservation_type_db_;
   message_                       VARCHAR2(2000);
   order_type_db_                 VARCHAR2(20);
   sequence_no_                   NUMBER;

BEGIN

   IF create_history_ = 1 THEN
      IF reservation_type_db_ = 'SHOP_ORD' THEN
         order_type_db_ := 'SHOP ORDER';
         message_ := Language_SYS.Translate_Constant(lu_name_, 'REMLOTRESSOCL: Removed reserved Lot Batch from cancelled Shop Order No :P1', NULL, order_ref1_ || '-' || order_ref2_ || '-' || order_ref3_);
      ELSIF reservation_type_db_ = 'SHOP_REQ' THEN
         order_type_db_ := 'SHOP REQUISITION';
         message_ := Language_SYS.Translate_Constant(lu_name_, 'REMLOTRESREQCL: Removed reserved Lot Batch from cancelled Shop Order Requisition No :P1', NULL, order_ref1_ || '-' || order_ref2_ || '-' || order_ref3_);
      END IF;
   END IF;

   Trace_SYS.Message('Order ' || order_ref1_ || '-' || order_ref2_ || '-' || order_ref3_);
   Trace_SYS.Message('contract_ ' || contract_ );

   FOR rec_ IN getrec LOOP
      IF ( Check_Exist___ (rec_.part_no, rec_.lot_batch_no ) = TRUE ) THEN
         Trace_SYS.Message('* Deleting Lot Reservation for PART: ' || rec_.part_no || 'LOT: ' ||rec_.lot_batch_no);
         remrec_ := Lock_By_Keys___(rec_.part_no,rec_.lot_batch_no );
         Check_Delete___(remrec_);
         Delete___(rec_.objid, remrec_);
         IF create_history_ = 1 THEN
            Lot_Batch_History_API.New(
                             sequence_no_,
                             rec_.lot_batch_no,
                             rec_.part_no,
                             contract_,
                             SYSDATE,
                             message_,
                             rec_.reserved_qty,
                             order_type_db_,
                             order_ref1_,
                             order_ref2_,
                             order_ref3_,
                             order_ref4_,
                             NULL );

         END IF;
      END IF;
   END LOOP;
END Remove_By_Order_Ref;


-- Update_Cond_Code_By_Ref
--   Public method for updating condition code when reservation already
--   created for proposal(s) or order(s)
PROCEDURE Update_Cond_Code_By_Ref (
   order_ref1_   IN VARCHAR2,
   order_ref2_   IN VARCHAR2,
   order_ref3_   IN VARCHAR2,
   order_ref4_   IN NUMBER,
   reservation_type_db_ IN VARCHAR2,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS

   CURSOR getrec IS
   SELECT part_no,lot_batch_no
   FROM   reserved_lot_batch_tab
   WHERE    NVL(order_ref4, 0) = NVL(order_ref4_, NVL(order_ref4, 0))
      AND   NVL(order_ref3, 'key') = NVL(order_ref3_, NVL(order_ref3, 'key'))
      AND   NVL(order_ref2, 'key') = NVL(order_ref2_, NVL(order_ref2, 'key'))
      AND   order_ref1 = order_ref1_
      AND   reservation_type = reservation_type_db_;

BEGIN

   FOR rec_ IN getrec LOOP
      IF (Part_Catalog_API.Get_Rcpt_Issue_Serial_Track_Db(rec_.part_no) = Fnd_Boolean_API.db_false) THEN
         Lot_Batch_Master_API.Modify_Condition_Code (rec_.part_no,
                                                     rec_.lot_batch_no,
                                                     condition_code_ );
      END IF;
   END LOOP;
END Update_Cond_Code_By_Ref;


-- Is_Reservation_Allowed
--   Additional check whether reservation is allowed.
PROCEDURE Is_Reservation_Allowed (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   order_ref1_   IN VARCHAR2,
   order_ref2_   IN VARCHAR2,
   order_ref3_   IN VARCHAR2,
   order_ref4_   IN NUMBER,
   reservation_type_db_ IN VARCHAR2 )
IS
   order_code_db_ VARCHAR2(20);
   lb_order_ref1_ VARCHAR2(12);
   lb_order_ref2_ VARCHAR2(12);
   lb_order_ref3_ VARCHAR2(30);
   lot_batch_in_use_ BOOLEAN := FALSE;
   lot_batch_master_rec_ Lot_Batch_Master_API.Public_Rec;
BEGIN

   -- Allow allow reservation for assembly and repair shop orders, even if receipt done before
   IF reservation_type_db_ = 'SHOP_ORD' THEN
      $IF (Component_Mfgstd_SYS.INSTALLED AND Component_Shpord_SYS.INSTALLED) $THEN
         order_code_db_ := Shop_Ord_Code_API.Encode(Shop_Ord_Util_API.Get_Order_Code(order_ref1_, order_ref2_, order_ref3_));
      $ELSE
         Error_Sys.Record_General(lu_name_, 'SHORDERNOTEXIST: Reservation is not allowed when ShopOrdCode/ShopOrdUtil is not installed.');
      $END
   END IF;

   IF reservation_type_db_ != 'SHOP_ORD' OR order_code_db_ NOT IN ('A', 'F') THEN
      -- Check if lot already being receipt before.
      $IF ( Component_Invent_SYS.INSTALLED ) $THEN
         lot_batch_in_use_ := Inventory_Transaction_Hist_API.Check_Lot_Batch_In_Use(part_no_, lot_batch_no_);
      $END

      IF  lot_batch_in_use_ THEN
         IF (reservation_type_db_ = 'SHOP_ORD' AND order_code_db_ IN ('M', 'T')) THEN
            lot_batch_master_rec_ := Lot_Batch_Master_API.Get(part_no_, lot_batch_no_);
            lb_order_ref1_ := lot_batch_master_rec_.order_ref1;
            lb_order_ref2_ := lot_batch_master_rec_.order_ref2;
            lb_order_ref3_ := lot_batch_master_rec_.order_ref3;
         END IF;

         IF reservation_type_db_ != 'SHOP_ORD' OR order_code_db_ NOT IN ('M', 'T')   OR
            NVL(lb_order_ref1_, Database_SYS.string_null_) != order_ref1_ OR 
            NVL(lb_order_ref2_, Database_SYS.string_null_) != order_ref2_ OR
            NVL(lb_order_ref3_, Database_SYS.string_null_) != order_ref3_ THEN  
            Error_SYS.Record_General(lu_name_, 'INVTREXIST: Reservation is not allowed for this lot :P1 because Inventory Transaction exists.',lot_batch_no_ );
         END IF;
      END IF;
   END IF;

END Is_Reservation_Allowed;


-- Validate_Order_Info
--   Check existent and get order info.
PROCEDURE Validate_Order_Info (
   contract_            OUT VARCHAR2,
   order_type_db_       OUT VARCHAR2,
   condition_code_      OUT VARCHAR2,
   configuration_id_    OUT VARCHAR2,
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2,
   order_ref3_          IN VARCHAR2,
   order_ref4_          IN NUMBER,
   reservation_type_db_ IN VARCHAR2 )
IS
BEGIN

   IF reservation_type_db_ = 'SHOP_ORD' THEN
      order_type_db_ := 'SHOP ORDER';
      $IF (Component_Shpord_SYS.INSTALLED) $THEN
         Shop_Ord_API.Validate_Shop_Order(contract_,condition_code_,configuration_id_,order_ref1_, order_ref2_, order_ref3_);        
      $ELSE
         Error_SYS.Record_General(lu_name_, 'SHPORDNOTINST: Operation cannot be completed. Shop Order must be installed.');
      $END
   ELSE
      order_type_db_ := 'SHOP REQUISITION';
      $IF (Component_Shpord_SYS.INSTALLED) $THEN
         Shop_Order_Prop_API.Exist(order_ref1_);
         contract_ := Shop_Order_Prop_API.Get_Contract(order_ref1_);
         condition_code_ := Shop_Order_Prop_API.Get_Condition_Code(order_ref1_);      
      $ELSE
         Error_SYS.Record_General(lu_name_, 'SHOPPROPDNOTINST: Operation cannot be completed. Shop Order Proposal must be installed.');
      $END
      END IF;
END Validate_Order_Info;


@UncheckedAccess
FUNCTION Get_Lot_Batch_Data_Tab (
   part_no_             IN VARCHAR2,
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2,
   order_ref3_          IN VARCHAR2,
   reservation_type_db_ IN VARCHAR2 ) RETURN Res_Lot_Batch_Table
IS
   res_lot_batch_tab_   Res_Lot_Batch_Table;

   CURSOR get_lot_batch_data IS
   SELECT lot_batch_no , reserved_qty
     FROM reserved_lot_batch_tab
    WHERE part_no          = part_no_
      AND order_ref1       = order_ref1_
      AND (order_ref2      = order_ref2_ OR  order_ref2_ IS NULL)
      AND (order_ref3      = order_ref3_ OR  order_ref3_ IS NULL)
      AND reservation_type = reservation_type_db_;

BEGIN

   OPEN get_lot_batch_data;
      FETCH get_lot_batch_data BULK COLLECT INTO res_lot_batch_tab_; 
   CLOSE get_lot_batch_data;

   RETURN res_lot_batch_tab_;

END Get_Lot_Batch_Data_Tab;


PROCEDURE Check_Lot_Track_Change (
   part_no_ IN VARCHAR2 )
IS
   order_ref1_         reserved_lot_batch_tab.order_ref1%TYPE;
   reservation_type_   VARCHAR2(112);

   CURSOR check_lot_batch_no_res IS
      SELECT order_ref1, reservation_type
      FROM   reserved_lot_batch_tab
      WHERE  part_no = part_no_
      AND    reservation_type IN ('SHOP_ORD', 'SHOP_REQ');
BEGIN
   OPEN check_lot_batch_no_res;
   FETCH check_lot_batch_no_res INTO order_ref1_, reservation_type_;
   IF (check_lot_batch_no_res%FOUND) THEN
      CLOSE check_lot_batch_no_res;
      reservation_type_ := Reservation_Type_API.Decode(reservation_type_);
      Error_SYS.Record_General('ReservedLotBatch', 'LOTBATCHNORES: Lot Batch No is reserved for this parent part in :P1 :P2. Remove Lot Batch No Reservation before changing lot tracking', reservation_type_, order_ref1_);
   END IF;
   CLOSE check_lot_batch_no_res;
END Check_Lot_Track_Change;


PROCEDURE Create_Order_Based_Lot (
   part_no_ IN VARCHAR2,
   reserved_qty_ IN NUMBER,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2 )
IS
   new_lot_batch_no_  reserved_lot_batch.lot_batch_no%TYPE;
   FUNCTION Get_Next_Lot_Batch_No (
      order_no_        IN VARCHAR2,
      release_no_      IN VARCHAR2,
      sequence_no_     IN VARCHAR2,
      part_no_         IN VARCHAR2 ) RETURN VARCHAR2
   IS
      lot_batch_no_out_  reserved_lot_batch_tab.lot_batch_no%type;
      counter_           NUMBER;
      lot_batch_no_      reserved_lot_batch_tab.lot_batch_no%type;
      top_count_         NUMBER;

      CURSOR cur_get_max_lotno_ IS
         SELECT MAX(lot_batch_no) Top_Lot_number_
         FROM reserved_lot_batch_tab
         WHERE order_ref1 = order_no_
         AND   order_ref1 = release_no_
         AND   order_ref1 = sequence_no_
         AND lot_batch_no LIKE (lot_batch_no_out_ || '%') ;
   BEGIN
      lot_batch_no_out_ := Get_Lot_Batch_No_So(order_no_, release_no_, sequence_no_);

      counter_ := 1;
      OPEN cur_get_max_lotno_;
      FETCH cur_get_max_lotno_  INTO lot_batch_no_ ;
      CLOSE cur_get_max_lotno_;

      IF lot_batch_no_ IS NOT NULL THEN
         top_count_ :=  ABS( TO_NUMBER( SUBSTR(lot_batch_no_,( INSTR(lot_batch_no_, '-', 1, 3) +1))));
         counter_ := top_count_ + 1 ;
      END IF;

      LOOP
         lot_batch_no_ := lot_batch_no_out_ || TO_CHAR(counter_);
         EXIT WHEN NOT Reserved_Lot_Batch_API.Check_Exist___(part_no_, lot_batch_no_ );
         counter_ := counter_ + 1;
      END LOOP;

      lot_batch_no_out_ := lot_batch_no_out_ || TO_CHAR(counter_);
      RETURN lot_batch_no_out_;
   EXCEPTION
      WHEN OTHERS THEN
      LOOP
         lot_batch_no_ := lot_batch_no_out_ || TO_CHAR(counter_);
         EXIT WHEN NOT Reserved_Lot_Batch_API.Check_Exist___(part_no_, lot_batch_no_ );
         counter_ := counter_ + 1;
      END LOOP;
      lot_batch_no_out_ := lot_batch_no_out_ || TO_CHAR(counter_);
      RETURN lot_batch_no_out_;
   END Get_Next_Lot_Batch_No;
BEGIN
   -- get the order-based lot batch no for this order
   new_lot_batch_no_ := Get_Next_Lot_Batch_No(
                           order_ref1_, order_ref2_, order_ref3_, part_no_);
   -- enter new lot batch no into ReservedLotBatch table
   Reserved_Lot_Batch_API.Insert_Data(part_no_,
                                      new_lot_batch_no_,
                                      Reservation_Type_API.Decode('SHOP_ORD'),
                                      reserved_qty_,
                                      order_ref1_,
                                      order_ref2_,
                                      order_ref3_);
END Create_Order_Based_Lot;


-- Get_Reserved_Lot_Batch_No
--   This function will return lot batch numbers reserved for order_ref1,
--   order_ref2,order_ref3,order_ref4 and reservation_type.
@UncheckedAccess
FUNCTION Get_Reserved_Lot_Batch_No (
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2,
   order_ref3_          IN VARCHAR2,
   order_ref4_          IN VARCHAR2,
   reservation_type_db_ IN VARCHAR2) RETURN lot_batch_no_table
IS
   rows_                NUMBER := 0 ;
   lot_batch_no_        lot_batch_no_table;

   CURSOR get_lot_batch_no IS
   SELECT lot_batch_no
      FROM  reserved_lot_batch_tab
      WHERE order_ref1        = order_ref1_
      AND   order_ref2        = order_ref2_
      AND   order_ref3        = order_ref3_
      AND   (order_ref4       = order_ref4_          OR order_ref4_          IS NULL)
      AND   (reservation_type = reservation_type_db_ OR reservation_type_db_ IS NULL);

BEGIN
   FOR lot_rec_ IN get_lot_batch_no LOOP
      lot_batch_no_(rows_).lot_batch_no := lot_rec_.lot_batch_no;
      rows_ := rows_ + 1;
   END LOOP;
   RETURN lot_batch_no_;
END Get_Reserved_Lot_Batch_No;


PROCEDURE Create_Reserved_Lots (
   part_no_             IN VARCHAR2,
   reservation_type_db_ IN VARCHAR2,
   reserved_qty_        IN NUMBER,
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2,
   order_ref3_          IN VARCHAR2,
   order_ref4_          IN NUMBER,
   number_of_batches_   IN NUMBER,
   lot_batch_no_start_  IN NUMBER,      
   lot_batch_no_prefix_ IN VARCHAR2 )
IS
   newrec_                 reserved_lot_batch_tab%ROWTYPE;
   template_rec_           reserved_lot_batch_tab%ROWTYPE;
   index_                  NUMBER := 0;
   lot_batch_no_           VARCHAR2(20);
   lot_batch_no_current_   NUMBER;
BEGIN
   template_rec_.part_no          := part_no_;
   template_rec_.reservation_type := reservation_type_db_;
   template_rec_.reserved_qty     := reserved_qty_;
   template_rec_.order_ref1       := order_ref1_;
   template_rec_.order_ref2       := order_ref2_;
   template_rec_.order_ref3       := order_ref3_;
   template_rec_.order_ref4       := order_ref4_;

   lot_batch_no_current_ := lot_batch_no_start_;

   WHILE index_ < number_of_batches_ LOOP
      lot_batch_no_current_ := lot_batch_no_current_ + 1;
      IF (LENGTH(lot_batch_no_prefix_||to_char(lot_batch_no_current_)) > 20) THEN
         Error_SYS.Record_General(lu_name_, 'MAXLOTBATCHNO: The system has generated Lot/Batch Number :P1 which exceeds the maximum length of 20 characters.', lot_batch_no_prefix_||to_char(lot_batch_no_current_));
      END IF;
      lot_batch_no_        := lot_batch_no_prefix_||to_char(lot_batch_no_current_);
      newrec_              := template_rec_;
      newrec_.lot_batch_no := lot_batch_no_;
      New___(newrec_);
      index_ := index_ + 1;
   END LOOP;
   -- The info needs to be cleared, otherwise messages will pop up after the next transction.
   Client_Sys.Clear_Info;
END Create_Reserved_Lots;


-- Get_Lot_Batch_No_So
--   This function will return a lot batch no created using a shop order's
--   order_no, release_no and sequence_no.
@UncheckedAccess
FUNCTION Get_Lot_Batch_No_So (
   order_no_      IN VARCHAR2,
   release_no_    IN VARCHAR2,
   sequence_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   lot_batch_no_  reserved_lot_batch_tab.lot_batch_no%TYPE;
BEGIN
   lot_batch_no_ := TRIM(TRAILING '-' FROM SUBSTR((order_no_ || '-' || release_no_ || '-'|| sequence_no_), 0, 16)) || '-';

   RETURN lot_batch_no_;
END Get_Lot_Batch_No_So;


PROCEDURE Modify_Reserved_Qty (
   part_no_             IN VARCHAR2,
   reservation_type_db_ IN VARCHAR2,
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2,
   order_ref3_          IN VARCHAR2,
   order_ref4_          IN NUMBER,
   reserved_qty_        IN NUMBER )
IS
   objid_       reserved_lot_batch.objid%TYPE;
   objversion_  reserved_lot_batch.objversion%TYPE;
   attr_        VARCHAR2(2000);
   newrec_      reserved_lot_batch_tab%ROWTYPE;
   oldrec_      reserved_lot_batch_tab%ROWTYPE;
   rec_counter_ NUMBER := 0;
   indrec_      Indicator_Rec;

   CURSOR get_rec IS
      SELECT *
         FROM  reserved_lot_batch_tab
         WHERE part_no            = part_no_
         AND   order_ref1         = order_ref1_
         AND  (order_ref2         = order_ref2_ OR order_ref2_ IS NULL)
         AND  (order_ref3         = order_ref3_ OR order_ref3_ IS NULL)
         AND  (order_ref4         = order_ref4_ OR order_ref4_ IS NULL)
         AND  reservation_type    = reservation_type_db_
      FOR UPDATE;
BEGIN
   FOR rec_ IN get_rec LOOP
      oldrec_      := rec_;
      rec_counter_ := rec_counter_ + 1;
      EXIT WHEN rec_counter_ > 1;
   END LOOP;

   IF (rec_counter_ != 1) THEN
      Error_SYS.Record_General(lu_name_,'RECCOUNTER: A unique Lot Reservation record could not be identified.');
   END IF;

   newrec_ := oldrec_;   
   newrec_.reserved_qty := reserved_qty_;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_, info_need_ => FALSE);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, info_need_ => FALSE);
END Modify_Reserved_Qty;


-- Check_Exist_By_Ref
--   This function will check whether a part no and lot batch no is reserved for the given
--   order reference values and reservtion type.
@UncheckedAccess
FUNCTION Check_Exist_By_Ref (
   part_no_             IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   order_ref1_          IN VARCHAR2,
   order_ref2_          IN VARCHAR2,
   order_ref3_          IN VARCHAR2,
   order_ref4_          IN NUMBER,
   reservation_type_db_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   found_ BOOLEAN := FALSE;

   CURSOR check_exist IS
      SELECT 1
      FROM  reserved_lot_batch_tab
      WHERE part_no          = part_no_
      AND   lot_batch_no     = lot_batch_no_
      AND   order_ref1       = order_ref1_
      AND  (order_ref2       = order_ref2_ OR order_ref2_ IS NULL)
      AND  (order_ref3       = order_ref3_ OR order_ref3_ IS NULL)
      AND  (order_ref4       = order_ref4_ OR order_ref4_ IS NULL)
      AND   reservation_type = reservation_type_db_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   found_ := check_exist%FOUND;
   CLOSE check_exist;

   RETURN found_;
END Check_Exist_By_Ref;


@UncheckedAccess
FUNCTION Get_Lot_Batch_No_If_Unique (
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN VARCHAR2) RETURN VARCHAR2
IS
   unique_column_value_           VARCHAR2(50);

   CURSOR get_unique_lot_batch_no IS
      SELECT DISTINCT(lot_batch_no)
      FROM   reserved_lot_batch
      WHERE  order_ref1 = order_ref1_
      AND    order_ref2 = order_ref2_
      AND    order_ref3 = order_ref3_
      AND    NVL(order_ref4, 0) = NVL(order_ref4_, 0);

BEGIN
   
   FOR rec_ IN get_unique_lot_batch_no LOOP
      IF (unique_column_value_ IS NULL) THEN
         unique_column_value_ := rec_.lot_batch_no;
      ELSE
         unique_column_value_ := NULL;
         EXIT; 
      END IF;
   END LOOP;

   RETURN unique_column_value_;
END Get_Lot_Batch_No_If_Unique;



