-----------------------------------------------------------------------------
--
--  Logical unit: LotBatchMaster
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211006  SBalLK  SC21R2-3202, Modified New_In_Inventory() method to correctly update received_qty when quantity reversal triggered.
--  211006          Removed Get_Order_Info() method intead use public Get() method.
--  210804  WaSalk  Bug 160264 (SC21R2-2153), Modified New_In_Inventory() to assign transaction date to manufactured date when transaction_code is OOREC or PSRECEIVE if it is null.
--  201222  SBalLK  Issue SC2020R1-11830, Modified New_In_Inventory(), Receive_Mro_Shop_Order(), Modify_Condition_Code() and Connect_Sub_Lot() method by removing
--  201222          attr_ functionality to optimize the performance.
--  201124  JaThlk  SC2020R1-11283, Modified Set_Manufacturer_Info to check whether the manufacturer information has been changed.
--  201023  Hadolk  MFZ-5308, Modified Update___(), Added condition to check received quantity exist before call Invent_Part_Lot_Manager_API.Modify_Expiration_Date().
--  200924  JaThlk  SC2020R1-1185, Added the Set_Manufacturer_Info procedure to change manufacturer information.
--  200529  ErRalk  SC2020R1-2094, Modified New_In_Inventory method to support the cancellation of shipment order receipts for lot tracked parts. 
--  200310  ANDILK  MFXTEND-307, Added Is_Child method which returns 'TRUE' for a child lot batch. 
--  200114  SBalLK  Bug 151810(SCZ-8466), Modified New_In_Inventory() method to handle null values for old received quantity for avoid unnecessary updates on lot batch master records.
--  191219  SBalLK  Bug 151508(SCZ-7902), Modified New_In_Inventory() method to update lot batch master records when only any attributes are available to update for avoid unnecessary locking
--  191219          on LotBatchMaster record.
--  190519  Asawlk  Bug 148225(SCZ-4900), Added method Reset_Condition_Code.
--  170503  VISALK  Bug 148026, Modified Check_Update___() and to check expiration date has a value before updating it. Modified Update___() to set NULL when no receive qty in stock.
--  171205  KHVESE  STRSC-9352, Modified method Consume_Customer_Consignment and removed parameter transaction_desc_ from its signature.
--  171121  TiRalk  STRSC-13735, Modified New_In_Inventory() to reduce the shipped_qty when transaction code is UNSHIPDIR.
--  171110  KHVESE  STRSC-9352, Renamed method Report_Consumed to Consume_Customer_Consignment.
--  171030  KHVESE  STRSC-9352, Added method Report_Consumed.
--  170728  ErRalk  Bug 136301, Added Modify_Expiration_Date method to update expiration date in lot Batch Master tab when expiration date is null.
--  170622  NISMLK  STRMF-11954, Modified Check_Update___ to raise an warning message when the expiration date get modified. 
--  170614  LEPESE  STRMF-11954, Adjusted date format in history records for update of manufacturing_date and expiration_date.
--  170607  LEPESE  STRMF-11954, Changes in New_In_Inventory to not update already existing value for expiration_date, manufactured_date and best_before_date.
--  170607          Changed in method Update___ to recalculate expiration_date based on modification of manufactured_date.
--  170607          Added calls to Lot_Batch_History_API.New() when changing expiration date and manufacturing date.
--  160803  ShPrlk Bug 130513, Modified New_In_Inventory() to reduce the shipped_qty when transaction code is OEUNSHIP.
--  160629  NISMLK STRMF-4563, Modified New_In_Inventory method to update manufactured_date, expiration_date and best_before_date fields for OOREC transaction codes.
--  160603  JoAnSe STRMF-2793, Added Get_Received_Lots.
--  160105  AwWelk Bug 124047, Modified New_In_Inventory() to reduce the received quantity when transaction code is either 'OWNTRANOUT' or 
--  160105         when doing 'UNRCPT-' only if the original transaction is of type 'ARRIVAL', 'CO-ARRIVAL', 'LOT-IN', 'CO-LOT-IN'. Added new
--  160105         parameter original_transaction_id_ to Remove(), Unissue() and New_In_Inventory() and create_lot_batch_history_ to Unissue()
--  160105         and New_In_Inventory(). Also increased received quantity when doing 'UNRCPT+' having original transaction 'OWNTRANOUT'.
--  160104  PrYaLK Bug 124271, Modified New_In_Inventory() to restrict updating the expiration_date_ for transaction codes other than
--  160104         'OOREC'.
--  130612  NaLrlk Modified the New_In_Inventory to update shipped_qty for transaction code RENTRET.
--  130729  MaIklk TIBE-1038, Removed global constants and used conditional compilation instead.
--  120304  SBalLK Bug 108614, Modified Update___() method to validate date changes in expiration date.
--  120914  VISALK Bug 103295, Modified Get_Max_Order_Based_Lot_No() to check the lot_batch_no is not containing the ':' 
--  120914         since it is used for the split lot batch number.
--  120814  DaZase Added method Check_Valid_Lot_For_Part.
--  110819  NiBalk Bug 97297, Modified Update___() to call Invent_Part_Lot_Manager_API.Modify_Expiration_Date() 
--  110819         instead of Inventory_Part_In_Stock_API.Modify_Exp_Date_By_Lot_No().
--  110328  LEPESE Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to consider the receipt_issue_serial_track flag.
--  101112  MAANLK Bug 93941, Modified New_In_Inventory to only update order reference information if received_qty
--  101112         for existing record is zero.
--  100726  MalLlk Modified New_In_Inventory to handle transaction codes 'CROREC' and 'CROUNREC'. 
--  100707  DAYJLK Bug 91586, Modified methods Scrap and New_In_Inventory to assign proper sign for transaction qty 
--  100707         in Lot Batch History and to calculate correct value for scrapped quantity in Lot Batch Master.
--  100423  KRPELK Merge Rose Method Documentation.
--  090929  MaJalk Removed unused variables and methods.
--  --------------------------------- 13.0.0---------------------------------
--  090814  NiBalk Bug 85311, Added text_id$ to LOT_BATCH_MASTER view.
--  081029  PraWlk Bug 77314, Modified New_In_Inventory by considering oldrec_.expiration_date, when 
--  081029         the update is done.
--  081022  Prawlk Bug 77314, Modified New_In_Inventory by adding parameter expiration_date_.
--  071113  ThImlk Bug 68087,Modified the method,New_In_Inventory() to pass the correct order reference for the
--  071113         perticular Lot/Batch, when it is received into inventory from a shop order.
--  070426  CsAmlk Added ifs_assert_safe statement. 
--  070305  SuSalk Modified New_In_Inventory method to handle SCPCREDIT & SCPCREDCOR transaction types.
--  061226  Cpeilk Bug 61135, Checked whether sub_length_ is not null in function Get_Max_Lot_Batch_No().
--  061206  DaZase Changes in method New_In_Inventory.
--  061106  NiBalk Bug 60671, Modified the procedure Unpack_Check_Insert___,
--  061106         in order to avoid special characters used by F1.
--  060727  ThGulk  Added &OBJID instead of rowif in Procedure Insert___
--  060425  ISWILK Bug 56858, Moved dynamic call to Inventory_Part_In_Stock_API.Modify_Exp_Date_By_Lot_No from Unpack_Check_Update___
--  060425         to Update___ and modified the condition that triggers the forenamed dynamic call.
--  -----------------------------12.4.0-------------------------
--  060306  JaJalk  Added Assert safe annotation.
--  060213  ChBalk Bug 56084, Modified New_In_Inventory method to correct manufactured_date
--  060213         and best_before_date when material was first received to the inventory.
--  060123  JaJalk  Added Assert safe annotation.
--  060110  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  051218  LEPESE  Changes in method Update___. Added calls to methods
--  051218          Invent_Condition_Code_Util_API.Make_Pre_Lot_Change_Action and
--  051218          Invent_Condition_Code_Util_API.Make_Post_Lot_Change_Action.
--  051026  KeSmUS Bug 53834, Added method Get_Max_Lot_Batch_No.
--  050916  NaLrlk Removed unused variables.
--  050630  HoInlk Bug 49682, Added methods Receive_Mro_Shop_Order and Unreceive_Mro_Shop_Order.
--  050322  AnLaSe SCJP625: Added handling transaction code DELCONF-OU in New_In_Inventory.
--  050125  SaJjlk Removed unused methods Check_Part_Exist, Is_Issued, Is_Pending and Validate_Split_Format.
--  041210  NuFilk Call Id 120536, Modified method New_In_Inventory to update scrapped_qty_ for OERET-SINT.
--  041202  ErSolk Bug 48139, Modified procedure New_In_Inventory.
--  040224  LoPrlk Removed substrb from code. &VIEW and Validate_Split_Format were altered.
--  -----------------------------12.3.0-------------------------
--  031204  LaBolk Changed position of method Get to remove red code.
--  031204         Added block comments in Unpack_Check_Insert___ and Unpack_Check_Update___.
--  -----------------------EDGE - Package Group 2----------------------------
--  031029  AnLaSe Call Id 103602, used newrec_.condition_code in method New_In_Inventory,
--                 replaced '*' with NULL for order_type and order_ref1 in Modify_Condition_Code.
--  031024  AnLaSe Call Id 109344, removed default value '*' for order_ref1_ in method New_In_Inventory.
--  031022  MaEelk Call Id 108974, Modified New_In_Inventory to pass ORDER_TYPE_Db to the attribute string.
--  031022  ChBalk LCS patch 39564: Added transaction code 'CO-DELV-OU','SHIPDIR' in New_In_Inventory.
--  031022  KiSalk Call 108478: Added transaction 'OERET-SCP' in check for setting scrapped_qty
--  031022         in Procedure New_In_Inventory.
--  031020  AnLaSE Call Id 108783, increased length from 4 to 30 for order_ref3. Added Undefine.
--  031020  AnLaSe Call Id 107412: Removed attributes and methods for inspect_date and
--                 next_inspect_date. Added reference to OrderType.
--  031014  LEPESE Added uppercase check on lot_batch_no in Unpack_Check_Insert___.
--  031013  PrJalk Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030807  PrTilk Modified view LOT_BATCH_MASTER_LOV. Added columns condition_code, condition_code_desc.
--  030722  MaGulk Modified Get_Structure_Ownership for corrections in dynamic call
--  030715  MaGulk Modified Get_Structure_Ownership list of parameters
--  030711  SudWlk Modified method Unpack_Check_Update__ to check for manual peggings when changing condition_code.
--  030710  MaGulk Added Get_Structure_Ownership for Owner codes-Persistent Part Ownership
--  030312  MaGulk Call ID: 95139, Modified Modify_Condition_Code to check existance prior to update.
--  021016  LEPESE Added code for transactions 'ARR-COMP','SERLOTSWAP','PARTSWAP' in
--                 method New_In_Inventory.
--  020913  LEPESE Added dynamic call to Inventory_Part_Unit_Cost_API.Handle_Lot_Batch_Removal
--                 in method Delete___. Added call to
--                 Inventory_Part_In_Stock_API.Check_Individual_Exist in metod check_delete___.
--  020906  NABEUS Removed unwanted code in package variable definitions and in Copy_Parent_Lot_Info. Call 88598.
--  020830  ANLASE Replaced call to Inventory_Part_Unit_Cost_API.Handle_Lot_Condition_Change
--                 with Invent_Condition_Code_Util_API.Handle_Lot_Condition_Change.
--  020828  BEHAUS Call 88340 Removed CONDANDSERIAL  from Unpack_Check_Insert. Set NULL instead.
--  020828  jagrno Added cleanup of object connection when removing entries
--                 (Check_Delete___ and Delete___). Also added copying of
--                 document connections in method Copy_Parent_Lot_Info.
--  020820  BEHAUS Added error LB_QTYEXIST.
--  020809  LEPESE Added call to Inventory_Part_Unit_Cost_API in update___to handle
--                 revaluation at condition_code change. Also added validations
--                 to secure that we never store a condition_code in LotBatchMaster
--                 for a serial tracked part.
--  020806  BEHAUS Lot Batch Mod. Copied condition_code on Copy_Parent_Lot_Info
--  020805  BEHAUS Lot Batch Mod. Added Modify_Condition_Code
--  020802  BEHAUS Lot Batch Mod. Added Condition code to LB Master
--  020729  Kamtlk Added Lot batch master lov .
--  020719  BEHAUS Adjust Connect_Sub_Lot due to change key orders.
--  020718  BEHAUS Corrected New_In_Inventory for non order.
--  020715  BEHAUS Merged from Lot Batch Mod VAP.
--          -----------------------------------------------------------------
--  020628  Memeus Potency Mod - Added method public Modify_Potency_Meas_Date
--                 and modify unpack_check_insert___ and unpack_check_update___ validation.
--  020626  YOHEUS POTENCY: Added more potency action
--  020619  BEHAUS Lot Batch Mod. Added Receive from Purchase.ARRIVAL and CO-ARRIVAL
--                 and Unreceived UNRCPT-
--  020619  YOHEUS POTENCY: Added parameter potency_ to method New_In_Inventory
--  020618  FRWAUS Pharmaceutical Mod - Potency Mod - Added Modify_Potency method to LU.
--  020617  BEHAUS Lot Batch Mod. Added parameter to Connect_Sub_Lot.
--  020610  BEHAUS Lot Batch Mod.Added call to
--                 TECHNICAL_OBJECT_REFERENCE_API.exist_reference.
--  020607  BEHAUS Lot Batch Mod. Removed UPPERCASE from lot_batch_no comment.
--  020605  BEHAUS Lot Batch Mod. Added Copy characteristic to Copy_Parent_Lot_Info
--  020604  Memeus Pharmaceutical Mod - Added attr Potency_Measured and
--                 method Check_Potency_Expire_Date, Check_Potency_Date__
--                 and Execute_Potency_Check__.
--  020523  Memeus Pharmaceutical Mod - Added methods Check_Part_Exist.
--  020520  Memeus Pharmaceutical Mod - Added new attribute and methods.
--  020513  BEHAUS Lot Batch Mod. Added Copy_Parent_Lot_Info
--  020509  BEHAUS Lot Batch Mod. Added parameter Update Parent Lot
--  020506  BEHAUS Lot Batch Mod. Added more logic based on 2.1 spec.
--  020503  BEHAUS Lot Batch Mod. Copied from PHS implementation on procedures
--                 NewInInventory,Issue,Unissue,Scrap,Unscrap,MoveInInventory
--                 Transport, Move_To_Inventory,Check_Exist,Pending,Remove
--  020502  BEHAUS Lot Batch Mod. Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Lot_Batch_No_Table IS TABLE OF lot_batch_master_tab.lot_batch_no%TYPE INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT lot_batch_master_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.create_date := sysdate;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     lot_batch_master_tab%ROWTYPE,
   newrec_     IN OUT lot_batch_master_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   stmt_                         VARCHAR2 (2000);
   char_null_                    VARCHAR2(12) := 'VARCHAR2NULL';
   make_post_cond_change_action_ BOOLEAN := FALSE;
   expiration_date_is_changed_   BOOLEAN := FALSE;   
   transaction_description_      VARCHAR2(2000);
   dummy_number_                 NUMBER;
BEGIN
   
   IF (NVL(newrec_.condition_code, char_null_) != NVL(oldrec_.condition_code, char_null_)) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Invent_Condition_Code_Util_API.Make_Pre_Lot_Change_Action (newrec_.part_no, newrec_.lot_batch_no );                  
         make_post_cond_change_action_ := TRUE;
      $ELSE
         NULL;
      $END
   END IF;

   IF (newrec_.received_qty = 0) THEN
      newrec_.manufactured_date := NULL;
      newrec_.best_before_date  := NULL;
      IF (oldrec_.received_qty > 0) THEN
         newrec_.expiration_date  := NULL;
      END IF;
   END IF;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (make_post_cond_change_action_) THEN
      stmt_ := 'BEGIN
               Invent_Condition_Code_Util_API.Make_Post_Lot_Change_Action (
                  :part_no,
                  :lot_batch_no,
                  :condition_code );
               END;';
      @ApproveDynamicStatement(2006-01-23,JaJalk)
      EXECUTE IMMEDIATE stmt_
         USING
            IN     newrec_.part_no,
            IN     newrec_.lot_batch_no,
            IN     newrec_.condition_code;
   END IF;

   IF (oldrec_.expiration_date IS NULL) THEN
      IF (newrec_.expiration_date IS NOT NULL) THEN
         expiration_date_is_changed_ := TRUE;
      END IF;
   ELSE
      IF (newrec_.expiration_date IS NULL) THEN
         expiration_date_is_changed_ := TRUE;
      ELSE
         IF (TRUNC(newrec_.expiration_date) != TRUNC(oldrec_.expiration_date)) THEN
            expiration_date_is_changed_ := TRUE;
         END IF;
      END IF;
   END IF;

   -- Propagate changes to parts in stock if an expiration date that is different to the existing one is entered
   IF (expiration_date_is_changed_) AND (newrec_.received_qty > 0) THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         Invent_Part_Lot_Manager_API.Modify_Expiration_Date(newrec_.part_no,
                                                            newrec_.lot_batch_no,
                                                            newrec_.expiration_date );         
      $ELSE
         NULL;
      $END
   END IF;

   IF (Validate_SYS.Is_Changed(newrec_.manufactured_date, oldrec_.manufactured_date) AND oldrec_.manufactured_date IS NOT NULL) THEN
      -- Only create a history entry when the Manufactured Date is being changed, not when it is being set for the first time.
      transaction_description_ :=
         Language_SYS.Translate_Constant(lu_name_, 'MODMANUFDATE: Manufacturing date changed from :P1 to :P2', NULL, TO_CHAR(oldrec_.manufactured_date, Report_SYS.date_format_), TO_CHAR(newrec_.manufactured_date, Report_SYS.date_format_));

      Lot_Batch_History_API.New(sequence_no_      => dummy_number_,
                                lot_batch_no_     => newrec_.lot_batch_no,
                                part_no_          => newrec_.part_no,
                                contract_         => '*',
                                transaction_date_ => SYSDATE,
                                transaction_desc_ => transaction_description_,
                                transaction_qty_  => 0,
                                order_type_       => NULL,
                                order_ref1_       => NULL,
                                order_ref2_       => NULL,
                                order_ref3_       => NULL,
                                order_ref4_       => NULL,
                                potency_          => NULL);
   END IF;
   IF (Validate_SYS.Is_Changed(newrec_.expiration_date, oldrec_.expiration_date) AND oldrec_.expiration_date IS NOT NULL) THEN
      -- Only create a history entry when the Expiration Date is being changed, not when it is being set for the first time.
      transaction_description_ :=
         Language_SYS.Translate_Constant(lu_name_, 'MODEXPIREDATE: Expiration date changed from :P1 to :P2', NULL, TO_CHAR(oldrec_.expiration_date, Report_SYS.date_format_), TO_CHAR(newrec_.expiration_date, Report_SYS.date_format_));

      Lot_Batch_History_API.New(sequence_no_      => dummy_number_,
                                lot_batch_no_     => newrec_.lot_batch_no,
                                part_no_          => newrec_.part_no,
                                contract_         => '*',
                                transaction_date_ => SYSDATE,
                                transaction_desc_ => transaction_description_,
                                transaction_qty_  => 0,
                                order_type_       => NULL,
                                order_ref1_       => NULL,
                                order_ref2_       => NULL,
                                order_ref3_       => NULL,
                                order_ref4_       => NULL,
                                potency_          => NULL);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN lot_batch_master_tab%ROWTYPE )
IS
   key_             VARCHAR2(2000);
   tech_spec_no_    NUMBER;
   tech_spec_class_ VARCHAR2(10);
   exists_in_stock_ NUMBER;   
BEGIN
   super(remrec_);
   -- check if technical object references may be removed
   tech_spec_no_ := Technical_Object_Reference_API.Get_Technical_Spec_No(lu_name_, key_);
   IF (Technical_Object_Reference_API.Check_Approved(tech_spec_no_)) THEN
      Error_SYS.Record_General(lu_name_, 'LB_APPROVEDTECH: Lot batch master :P1 has approved technical specifications. Unapprove these before removing.', remrec_.part_no||','||remrec_.lot_batch_no);
   ELSE
      tech_spec_class_ := Technical_Object_Reference_API.Get_Technical_Class_With_Key(lu_name_, key_);
      IF (nvl(Technical_Object_Reference_API.Get_Defined_Count(tech_spec_no_, tech_spec_class_), 0) > 0) THEN
         Error_SYS.Record_General(lu_name_, 'LB_DEFINEDTECH: Lot batch master :P1 has defined values for technical specifications. Remove these before removing serial.', remrec_.part_no||','||remrec_.lot_batch_no);
      END IF;
   END IF;

   $IF (Component_Invent_SYS.INSTALLED) $THEN
      exists_in_stock_ := Inventory_Part_In_Stock_API.Check_Lot_Batch_Exist(remrec_.part_no, remrec_.lot_batch_no);        
      IF (exists_in_stock_ = 1) THEN
         Error_SYS.Record_General(lu_name_, 'ININVENTORY: Lot :P1 of Part :P2 is in Inventory and can not be deleted.', remrec_.lot_batch_no, remrec_.part_no);
      END IF;
   $END
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN lot_batch_master_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.part_no || '^' || remrec_.lot_batch_no || '^';
   -- Remove document references
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      Doc_Reference_Object_API.Delete_Obj_Reference(lu_name_, key_);      
   $END
   -- Remove technical references
   Technical_Object_Reference_API.Delete_Reference(lu_name_, key_);
   --
   super(objid_, remrec_);

   $IF (Component_Invent_SYS.INSTALLED) $THEN
      Inventory_Part_Unit_Cost_API.Handle_Lot_Batch_Removal (remrec_.part_no, remrec_.lot_batch_no );               
   $END
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT lot_batch_master_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   partca_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   partca_rec_ := Part_Catalog_API.Get(newrec_.part_no);

   IF (newrec_.condition_code IS NULL) THEN
      IF ((partca_rec_.condition_code_usage = 'ALLOW_COND_CODE') AND
          (partca_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_false)) THEN
         newrec_.condition_code := Condition_Code_API.Get_Default_Condition_Code;
      END IF;
   ELSE
      IF (partca_rec_.condition_code_usage = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      END IF;
      IF (partca_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true) THEN
         newrec_.condition_code := NULL;
      --   Error_SYS.Record_General(lu_name_,'CONDANDSERIAL: You cannot enter a condition code for the lot on a serial tracked part.');
      END IF;
   END IF;

   IF (newrec_.condition_code IS NOT NULL) THEN
      Condition_Code_API.Exist(newrec_.condition_code);
   END IF;   
   super(newrec_, indrec_, attr_);

   Error_SYS.Check_Valid_Key_String('LOT_BATCH_NO',newrec_.lot_batch_no);

   IF (upper(newrec_.lot_batch_no) != newrec_.lot_batch_no) THEN
      Error_SYS.Record_General(lu_name_,'UPPERCASE: The Lot/Batch number must be entered in upper-case.');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     lot_batch_master_tab%ROWTYPE,
   newrec_ IN OUT lot_batch_master_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                    VARCHAR2(30);
   value_                   VARCHAR2(2000);
   dates_manually_modified_ VARCHAR2(5);
   durability_day_          NUMBER;   
   part_catalog_rec_        Part_Catalog_API.Public_Rec;
   old_condition_code_      lot_batch_master_tab.condition_code%TYPE := newrec_.condition_code;

BEGIN

   IF (old_condition_code_ IS NULL AND newrec_.condition_code IS NOT NULL)
      OR (old_condition_code_ IS NOT NULL AND newrec_.condition_code IS NULL)
      OR (old_condition_code_ <> newrec_.condition_code) THEN
      part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);
      IF part_catalog_rec_.condition_code_usage = 'NOT_ALLOW_COND_CODE' THEN
         Error_SYS.Record_General(lu_name_,'COND_NOT_ALLOW: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      ELSE
         IF (newrec_.condition_code IS NOT NULL) THEN
            IF (part_catalog_rec_.receipt_issue_serial_track = Fnd_Boolean_API.db_true) THEN
               Error_SYS.Record_General(lu_name_,'CONDANDSERIAL: You cannot enter a condition code for the lot on a serial tracked part.');
            END IF;
            Condition_Code_API.Exist(newrec_.condition_code);

            -- Note: Check if the change in condition code affects manual peggings
            $IF (Component_Purch_SYS.INSTALLED) $THEN
               Purch_Condition_Code_Util_API.Handle_Lot_Condition_Change(newrec_.part_no, newrec_.lot_batch_no);
            $END
         ELSE
            Error_SYS.Record_General(lu_name_,'COND_NULL: Condition code functionality is enabled in the part catalog record for this part. You must enter a condition code.');
         END IF;
      END IF;
   END IF;   
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.expiration_date IS NULL) THEN
      IF (Validate_SYS.Is_Changed(newrec_.manufactured_date, oldrec_.manufactured_date)) THEN
         IF ((newrec_.manufactured_date IS NOT NULL) AND (newrec_.initial_contract IS NOT NULL)) THEN
            $IF (Component_Invent_SYS.INSTALLED) $THEN
               durability_day_ := Inventory_Part_API.Get_Durability_Day(newrec_.initial_contract, newrec_.part_no); 
            $ELSE
               NULL;
            $END
            IF (durability_day_ IS NOT NULL) THEN
               newrec_.expiration_date := newrec_.manufactured_date + durability_day_;
               Client_SYS.Add_To_Attr('EXPIRATION_DATE', newrec_.expiration_date, attr_);
            END IF;
         END IF;
      END IF;
   END IF;
   
   dates_manually_modified_ := NVL(Client_SYS.Cut_Item_Value('DATES_MANUALLY_MODIFIED', attr_), 'FALSE');   
   IF ((dates_manually_modified_ = 'TRUE') AND Validate_SYS.Is_Changed(oldrec_.expiration_date, newrec_.expiration_date)) THEN
      Client_SYS.Add_Warning(lu_name_, 'EXPIRATION_DATE_MODIFIED: This will update Expiration date for all Inventory Part in Stock and in-transit records for this Lot Batch combination.');
   END IF;
     
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_In_Inventory
--   Creates a new lot batch master instance when a lot tracked part
--   is received into inventory.
PROCEDURE New_In_Inventory (
   part_no_                   IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   contract_                  IN VARCHAR2,
   order_type_                IN VARCHAR2,
   order_ref1_                IN VARCHAR2,
   order_ref2_                IN VARCHAR2,
   order_ref3_                IN VARCHAR2,
   order_ref4_                IN NUMBER,
   transaction_date_          IN DATE,
   transaction_desc_          IN VARCHAR2,
   transaction_qty_           IN NUMBER,
   transaction_code_          IN VARCHAR2,
   potency_                   IN NUMBER,
   condition_code_            IN VARCHAR2 DEFAULT NULL,
   expiration_date_           IN DATE    DEFAULT NULL,
   original_transaction_id_   IN NUMBER   DEFAULT NULL,
   create_lot_batch_history_  IN BOOLEAN  DEFAULT TRUE )
IS
   sequence_no_             NUMBER;
   newrec_                  lot_batch_master_tab%ROWTYPE;
   oldrec_                  lot_batch_master_tab%ROWTYPE;
   durability_day_          NUMBER;
   qty_to_update_           NUMBER;
   so_manufactured_date_    DATE;
   update_lot_batch_master_ BOOLEAN := FALSE;
BEGIN
   Trace_SYS.Message('LOT MASTER Verify part_no_' || part_no_ || 'lot_batch_no_ ' || lot_batch_no_);
 
   IF transaction_code_ IN ('OOREC', 'PSRECEIVE') THEN
      $IF (Component_Invent_SYS.INSTALLED) $THEN
         durability_day_ := Inventory_Part_API.Get_Durability_Day(contract_, part_no_); 
      $END

      IF transaction_code_ = 'OOREC' THEN
         $IF Component_Shpord_SYS.INSTALLED $THEN
            so_manufactured_date_ := Shop_Ord_API.Get_Manufactured_Date(order_ref1_, order_ref2_, order_ref3_); 
         $ELSE
            NULL;
         $END 
      END IF;      
   END IF;

   IF (NOT Check_Exist___(part_no_, lot_batch_no_)) THEN
      newrec_.part_no          := part_no_;
      newrec_.lot_batch_no     := lot_batch_no_;
      newrec_.initial_contract := contract_;
      newrec_.order_type       := order_type_;
      newrec_.order_ref1       := order_ref1_;
      newrec_.order_ref2       := order_ref2_;
      newrec_.order_ref3       := order_ref3_;
      newrec_.order_ref4       := order_ref4_;
      newrec_.scrapped_qty     := 0;
      newrec_.shipped_qty      := 0;
      newrec_.condition_code   := condition_code_;
      newrec_.expiration_date  := expiration_date_;
      IF transaction_code_ IN ('NREC', 'OOREC', 'ARRIVAL', 'CO-ARRIVAL', 'PSRECEIVE',
                               'ARR-COMP', 'SERLOTSWAP', 'PARTSWAP', 'CROREC', 'LOT-IN', 'CO-LOT-IN')  THEN
         newrec_.received_qty := transaction_qty_;
      ELSE
         newrec_.received_qty := 0;
      END IF;
      IF transaction_code_ IN ('OOREC', 'PSRECEIVE') THEN
         newrec_.manufactured_date := NVL(so_manufactured_date_, transaction_date_);
         IF (durability_day_ IS NOT NULL) THEN
            newrec_.best_before_date := NVL(so_manufactured_date_, transaction_date_) + durability_day_;
         END IF;
      END IF;
      New___(newrec_);
   ELSE
      IF (transaction_code_ IN ('NREC',    'OOREC',      'ARRIVAL',    'CO-ARRIVAL', 'PSRECEIVE', 'ARR-COMP',  'SERLOTSWAP', 'PARTSWAP',   'CROREC',
                                'LOT-IN',  'CO-LOT-IN',  'UNRCPT',     'SUNREC',     'RPSREC',    'CROUNREC',  'OWNTRANOUT', 'UNRCPT-',    'CO-UNRCPT-',
                                'UNRCPT+', 'INVSCPCOR',  'SCPCREDCOR', 'PICKSCRAP',  'INVSCRAP',  'SCPCREDIT', 'OERET-SCP',  'OERET-SINT', 'OERET-SPNC',
                                'OESHIP',  'CO-DELV-OU', 'SHIPDIR',    'DELCONF-OU', 'RENTRET',   'OEUNSHIP',  'UNSHIPDIR',  'UNR-SHPODS', 'UNR-SHPODW')) THEN
         -- LBM already exists, update if a quantity has changed
         oldrec_ := Lock_By_Keys___(part_no_, lot_batch_no_);
         newrec_ := oldrec_;
         update_lot_batch_master_ := TRUE;

         -- Convert qty to initial_site u/m
         IF (oldrec_.initial_contract != contract_) THEN
            $IF (Component_Invent_SYS.INSTALLED) $THEN
               qty_to_update_ :=Inventory_Part_API.Get_Site_Converted_Qty( contract_,
                                                                           part_no_,
                                                                           oldrec_.initial_contract,
                                                                           transaction_qty_,
                                                                           'SKIP');
            $ELSE
               NULL;
            $END
         ELSE
            qty_to_update_ := transaction_qty_;
         END IF;
      
         -- Use the transaction description to determine what type of transaction
         -- is being performed
         IF transaction_code_ IN ('NREC',     'OOREC',      'ARRIVAL',  'CO-ARRIVAL', 'PSRECEIVE',
                                  'ARR-COMP', 'SERLOTSWAP', 'PARTSWAP', 'CROREC', 'LOT-IN', 'CO-LOT-IN')  THEN
            newrec_.received_qty := NVL(oldrec_.received_qty, 0) + qty_to_update_;
            IF transaction_code_ IN ('OOREC', 'PSRECEIVE') THEN
               IF ( NVL(oldrec_.received_qty, 0) = 0) THEN
                  newrec_.order_type := order_type_;
                  newrec_.order_ref1 := order_ref1_;
                  newrec_.order_ref2 := order_ref2_;
                  newrec_.order_ref3 := order_ref3_;
                  newrec_.order_ref4 := order_ref4_;
               END IF;
               IF (oldrec_.manufactured_date IS NULL) THEN
                  newrec_.manufactured_date := NVL(so_manufactured_date_, transaction_date_);
               END IF;
               IF ((oldrec_.best_before_date IS NULL) AND (durability_day_ IS NOT NULL)) THEN
                  newrec_.best_before_date := NVL(so_manufactured_date_, transaction_date_) + durability_day_;
               END IF;
               IF ((oldrec_.expiration_date IS NULL) AND (expiration_date_ IS NOT NULL) AND (transaction_code_ = 'OOREC'))THEN
                  newrec_.expiration_date := expiration_date_;
               END IF;
            END IF;
         ELSIF transaction_code_ IN ('UNRCPT','SUNREC','RPSREC','CROUNREC', 'OWNTRANOUT') THEN
            newrec_.received_qty := NVL(oldrec_.received_qty, 0) - qty_to_update_;
         ELSIF transaction_code_ IN ('UNRCPT-', 'CO-UNRCPT-', 'UNR-SHPODS', 'UNR-SHPODW') THEN
            -- Added new condition to check whether the original transaction is of type 'ARRIVAL', 'CO-ARRIVAL', 'LOT-IN' or 'CO-LOT-IN'
            IF (original_transaction_id_ IS NOT NULL) THEN
               $IF Component_Invent_SYS.INSTALLED $THEN
                  IF (Inventory_Transaction_Hist_API.Get_Transaction_Code(original_transaction_id_) IN ('ARRIVAL', 'CO-ARRIVAL', 'LOT-IN', 'CO-LOT-IN')) THEN
                     newrec_.received_qty := NVL(oldrec_.received_qty, 0) - qty_to_update_;
                  END IF;
               $ELSE
                  NULL;
               $END
            ELSE
               newrec_.received_qty := NVL(oldrec_.received_qty, 0) - qty_to_update_;
            END IF;
         ELSIF transaction_code_ = 'UNRCPT+' THEN
            -- Added new condition to check whether the original transaction is 'OWNTRANOUT'
            IF (original_transaction_id_ IS NOT NULL) THEN
               $IF Component_Invent_SYS.INSTALLED $THEN
                  IF (Inventory_Transaction_Hist_API.Get_Transaction_Code(original_transaction_id_) = 'OWNTRANOUT') THEN
                     newrec_.received_qty := NVL(oldrec_.received_qty, 0) + qty_to_update_;
                  END IF;
               $ELSE
                  NULL;
               $END
            END IF;
         ELSIF transaction_code_ IN ( 'INVSCPCOR', 'SCPCREDCOR') THEN
            newrec_.scrapped_qty := NVL(oldrec_.scrapped_qty, 0) - qty_to_update_;
         ELSIF transaction_code_ IN ( 'PICKSCRAP','INVSCRAP','SCPCREDIT','OERET-SCP','OERET-SINT','OERET-SPNC') THEN
            newrec_.scrapped_qty := nvl(oldrec_.scrapped_qty, 0) + qty_to_update_;
         ELSIF transaction_code_ IN ( 'OESHIP','CO-DELV-OU','SHIPDIR', 'DELCONF-OU', 'RENTRET') THEN
            newrec_.shipped_qty := NVL(oldrec_.shipped_qty, 0) + qty_to_update_;
            newrec_.last_sales_date := transaction_date_;
         ELSIF (transaction_code_ IN ('OEUNSHIP', 'UNSHIPDIR')) THEN 
            newrec_.shipped_qty := NVL(oldrec_.shipped_qty, 0) - qty_to_update_;
         END IF;
      END IF;

      -- Only update if a quantity change is needed or potency is not null
      IF((update_lot_batch_master_) OR (newrec_.potency IS NOT NULL AND Validate_SYS.Is_Changed(oldrec_.potency, newrec_.potency))) THEN
         Trace_SYS.Message('****** Lot Batch Master.New_In_Inventory - Matches found for '|| transaction_code_|| '.' || transaction_desc_);
         Modify___(newrec_);
      ELSE
         Trace_SYS.Message('****** Lot Batch Master.New_In_Inventory - No matches found for '|| transaction_code_|| '.' || transaction_desc_);
      END IF;
   END IF;


   Trace_SYS.Message('==LOT BATCH MASTER - Creating batch History for: ' ||lot_batch_no_ );
   Trace_SYS.Message('****** Transaction_Qty is:'||transaction_qty_);
   Trace_SYS.Message('****** In NewInInventory Transaction Code : '||transaction_code_);

   -- here we should use transaction_qty_ instead of qty_to_update_
   IF (create_lot_batch_history_) THEN
      Lot_Batch_History_API.New(sequence_no_,
                                lot_batch_no_,
                                part_no_,
                                contract_,
                                transaction_date_,
                                transaction_desc_,
                                transaction_qty_,
                                order_type_,
                                order_ref1_,
                                order_ref2_,
                                order_ref3_,
                                order_ref4_,
                                potency_,
                                newrec_.condition_code);
   END IF;
END New_In_Inventory;


-- Get_Max_Order_Based_Lot_No
--   Returns the maximum order based lot batch number using the in argument.
@UncheckedAccess
FUNCTION Get_Max_Order_Based_Lot_No (
   lot_batch_no_in_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   start_pos_max_    NUMBER;
   lot_batch_no_out_ lot_batch_master_tab.lot_batch_no%TYPE;

   CURSOR get_max_lot_batch_no IS
      SELECT MAX(TO_NUMBER(SUBSTR(lot_batch_no,start_pos_max_,3)))
      FROM lot_batch_master_tab
      WHERE lot_batch_no LIKE lot_batch_no_in_||'%'
      AND (INSTR(lot_batch_no, '-', start_pos_max_, 1)) = 0
      AND (INSTR(lot_batch_no, ':', start_pos_max_, 1)) = 0;
BEGIN
   start_pos_max_ := length(lot_batch_no_in_) + 1;

   OPEN get_max_lot_batch_no;
   FETCH get_max_lot_batch_no INTO lot_batch_no_out_;
   CLOSE get_max_lot_batch_no;

   IF lot_batch_no_out_ IS NOT NULL THEN
     lot_batch_no_out_ :=  lot_batch_no_in_||lot_batch_no_out_;
   END IF;

   RETURN(lot_batch_no_out_);
END Get_Max_Order_Based_Lot_No;


-- Issue
--   Updates lot batch master instance when an issue of the lot tracked
--   part occurs in inventory.
PROCEDURE Issue (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_ IN NUMBER,
   transaction_code_ IN VARCHAR2,
   potency_ IN NUMBER,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_);
END Issue;


-- Unissue
--   Updates lot batch master instance when an unissue of the lot
--   tracked part occurs in inventory.
PROCEDURE Unissue (
   part_no_                   IN VARCHAR2,
   lot_batch_no_              IN VARCHAR2,
   contract_                  IN VARCHAR2,
   order_type_                IN VARCHAR2,
   order_ref1_                IN VARCHAR2,
   order_ref2_                IN VARCHAR2,
   order_ref3_                IN VARCHAR2,
   order_ref4_                IN NUMBER,
   transaction_date_          IN DATE,
   transaction_desc_          IN VARCHAR2,
   transaction_qty_           IN NUMBER,
   transaction_code_          IN VARCHAR2,
   potency_                   IN NUMBER,
   condition_code_            IN VARCHAR2 DEFAULT NULL,
   original_transaction_id_   IN NUMBER   DEFAULT NULL,
   create_lot_batch_history_  IN BOOLEAN  DEFAULT TRUE )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_,
                    original_transaction_id_  => original_transaction_id_,
                    create_lot_batch_history_ => create_lot_batch_history_);
END Unissue;


-- Scrap
--   Updates lot batch master instance when a scrap of the lot tracked
--   part occurs in inventory.
PROCEDURE Scrap (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_ IN NUMBER,
   transaction_code_ IN VARCHAR2,
   potency_ IN NUMBER,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_);
END Scrap;


-- Unscrap
--   Updates lot batch master instance when an unscrap of the lot
--   tracked part occurs in inventory.
PROCEDURE Unscrap (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_ IN NUMBER,
   transaction_code_ IN VARCHAR2,
   potency_ IN NUMBER,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_);
END Unscrap;


-- Move_In_Inventory
--   Updates a lot batch master instance when a lot tracked part
--   is moved in inventory.
PROCEDURE Move_In_Inventory (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_ IN NUMBER,
   transaction_code_ IN VARCHAR2,
   potency_ IN NUMBER,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_);
END Move_In_Inventory;


-- Transport
--   Updates lot batch master instance when a transport of the lot
--   tracked part occurs in inventory.
PROCEDURE Transport (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_ IN NUMBER,
   transaction_code_ IN VARCHAR2,
   potency_ IN NUMBER,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_);
END Transport;


-- Move_To_Inventory
--   Updates a lot batch master instance when a lot tracked part
--   is moved into inventory.
PROCEDURE Move_To_Inventory (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_ IN NUMBER,
   transaction_code_ IN VARCHAR2,
   potency_ IN NUMBER,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_);
END Move_To_Inventory;


-- Check_Exist
--   Public use of the CheckExist___ private method.
FUNCTION Check_Exist (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(part_no_, lot_batch_no_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- Check_Valid_Lot_For_Part
--   Checks if Lot Batch No is valid
PROCEDURE Check_Valid_Lot_For_Part (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 )
IS
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
BEGIN
   part_catalog_rec_ := Part_Catalog_API.Get(part_no_);

   IF (part_catalog_rec_.lot_tracking_code = Part_Lot_Tracking_API.db_not_lot_tracking) THEN
      IF (lot_batch_no_ != '*') THEN
         Error_SYS.Record_General(lu_name_, 'NOTLOTTRACKEDMUSTBESTAR: This Part is not using Lot Tracking so Lot Batch No must be :P1.', '*');
      END IF;
   ELSE
      Exist(part_no_, lot_batch_no_);
   END IF;

END Check_Valid_Lot_For_Part;


-- Remove
--   Removes a lot batch and its associated history.
PROCEDURE Remove (
   part_no_                 IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   contract_                IN VARCHAR2,
   order_type_              IN VARCHAR2,
   order_ref1_              IN VARCHAR2,
   order_ref2_              IN VARCHAR2,
   order_ref3_              IN VARCHAR2,
   order_ref4_              IN NUMBER,
   transaction_date_        IN DATE,
   transaction_desc_        IN VARCHAR2,
   transaction_qty_         IN NUMBER,
   transaction_code_        IN VARCHAR2,
   potency_                 IN NUMBER,
   condition_code_          IN VARCHAR2 DEFAULT NULL,
   original_transaction_id_ IN NUMBER   DEFAULT NULL)
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_,
                    original_transaction_id_ => original_transaction_id_);
END Remove;


-- Pending
--   Sets the lot batch to a state of pending.
PROCEDURE Pending (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   contract_ IN VARCHAR2,
   order_type_ IN VARCHAR2,
   order_ref1_ IN VARCHAR2,
   order_ref2_ IN VARCHAR2,
   order_ref3_ IN VARCHAR2,
   order_ref4_ IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_ IN NUMBER,
   transaction_code_ IN VARCHAR2,
   potency_ IN NUMBER,
   condition_code_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   New_In_Inventory(part_no_,
                    lot_batch_no_,
                    contract_,
                    order_type_,
                    order_ref1_,
                    order_ref2_,
                    order_ref3_,
                    order_ref4_,
                    transaction_date_,
                    transaction_desc_,
                    transaction_qty_,
                    transaction_code_,
                    potency_,
                    condition_code_);
END Pending;


-- Connect_Sub_Lot
--   Connect sub lot to it's parent
PROCEDURE Connect_Sub_Lot (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   parent_lot_ IN VARCHAR2,
   parent_part_no_ IN VARCHAR2 DEFAULT NULL )
IS
   newrec_                  lot_batch_master_tab%ROWTYPE;
   loc_part_no_             VARCHAR2(25);
   parent_lb_rec_           Lot_Batch_Master_API.Public_Rec;
BEGIN
   IF parent_part_no_ IS NULL THEN
      loc_part_no_ := part_no_;
   ELSE
      loc_part_no_ := parent_part_no_;
   END IF;
   newrec_ := Lock_By_Keys___(part_no_, lot_batch_no_);

   IF ( loc_part_no_ IS NOT NULL ) OR ( parent_lot_ IS NOT NULL ) THEN
      parent_lb_rec_ := Lot_Batch_Master_API.Get(loc_part_no_,parent_lot_);
      IF ( parent_lb_rec_.shipped_qty  > 0 OR
           parent_lb_rec_.scrapped_qty > 0 OR
           parent_lb_rec_.received_qty > 0 ) THEN
         Error_SYS.Record_General(lu_name_,'LB_QTYEXIST: Lot :P1 has Onhand quantity. Split is not allowed.',parent_lot_);
      END IF;
   END IF;

   Trace_SYS.Message('******Connect Sub Lot ' || lot_batch_no_ || 'TO: ' || parent_lot_);
   newrec_.parent_part_no := loc_part_no_;
   newrec_.parent_lot     := parent_lot_;
   Modify___(newrec_);
END Connect_Sub_Lot;


-- Copy_Parent_Lot_Info
--   Copy Parent Lot Info
PROCEDURE Copy_Parent_Lot_Info (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   parent_lot_ IN VARCHAR2,
   parent_part_no_ IN VARCHAR2 DEFAULT NULL )
IS
   parent_rec_    lot_batch_master_tab%ROWTYPE;
   sub_lot_rec_   lot_batch_master_tab%ROWTYPE;
   oldrec_        lot_batch_master_tab%ROWTYPE;
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   attr_          VARCHAR2(2000);
   key_ref_to_    technical_object_reference.key_ref%TYPE;
   key_ref_from_  technical_object_reference.key_ref%TYPE;
   loc_part_no_   VARCHAR2(25);
   doc_ref_exist_ VARCHAR2(5);   
BEGIN

   IF parent_part_no_ IS NULL THEN
      loc_part_no_ := part_no_;
   ELSE
      loc_part_no_ := parent_part_no_;
   END IF;

   parent_rec_    := Get_Object_By_Keys___(loc_part_no_, parent_lot_);
   sub_lot_rec_   := Get_Object_By_Keys___(part_no_, lot_batch_no_);

   -- Copy parent infos
   sub_lot_rec_.order_type := parent_rec_.order_type;
   sub_lot_rec_.order_ref1 := parent_rec_.order_ref1;
   sub_lot_rec_.order_ref2 := parent_rec_.order_ref2;
   sub_lot_rec_.order_ref3 := parent_rec_.order_ref3;
   sub_lot_rec_.order_ref4 := parent_rec_.order_ref4;
   sub_lot_rec_.shipped_qty := 0 ;
   sub_lot_rec_.scrapped_qty:= 0;
   sub_lot_rec_.expiration_date:= parent_rec_.expiration_date;
   sub_lot_rec_.manufactured_date:= parent_rec_.manufactured_date;
   sub_lot_rec_.best_before_date:= parent_rec_.best_before_date;
   sub_lot_rec_.last_sales_date:= NULL;
   sub_lot_rec_.potency:= parent_rec_.potency;
   sub_lot_rec_.create_date:= SYSDATE;
   sub_lot_rec_.note_text:= parent_rec_.note_text;
   sub_lot_rec_.condition_code:= parent_rec_.condition_code;
   Trace_SYS.Message('*** LOT BATCH MASTER Copy Parent Info ' || loc_part_no_ || '<lot>' || parent_lot_ || 'TO: ' || part_no_ || '<lot>' || lot_batch_no_);
   Update___(objid_, oldrec_, sub_lot_rec_, attr_, objversion_, TRUE);

   -- Copy Characteristic.
   Trace_SYS.Message('******Copy Characteristic ' || parent_lot_ || 'TO: ' || lot_batch_no_);
   key_ref_from_     := Client_SYS.Get_Key_Reference( 'LotBatchMaster', 'LOT_BATCH_NO',parent_lot_, 'PART_NO', loc_part_no_ );
   key_ref_to_       := Client_SYS.Get_Key_Reference( 'LotBatchMaster', 'LOT_BATCH_NO',lot_batch_no_, 'PART_NO', part_no_ );

   IF Technical_Object_Reference_API.Exist_Reference_ ( 'LotBatchMaster',
                                                        key_ref_from_ )  != '-1' THEN
      Technical_Object_Reference_API.Delete_Reference('LotBatchMaster', key_ref_to_);
      Technical_Object_Reference_API.Copy('LotBatchMaster', key_ref_from_, key_ref_to_);
   END IF;
   -- copy document references
   $IF (Component_Docman_SYS.INSTALLED) $THEN
      doc_ref_exist_ := Doc_Reference_Object_API.Exist_Obj_Reference(lu_name_, key_ref_from_); 
      IF (nvl(doc_ref_exist_, 'FALSE') = 'TRUE') THEN
         Doc_Reference_Object_API.Copy(lu_name_, key_ref_from_, lu_name_, key_ref_to_);
         Doc_Reference_Object_API.Delete_Obj_Reference(lu_name_, key_ref_from_);
      END IF;
   $END
   -- Update the History.
END Copy_Parent_Lot_Info;

-- Get_Received_Lots
--   Return an array of lot_batch_no:s received from the specified order and part number.
FUNCTION Get_Received_Lots (
   order_type_db_ IN VARCHAR2,
   order_ref1_    IN VARCHAR2,
   order_ref2_    IN VARCHAR2,
   order_ref3_    IN VARCHAR2,
   order_ref4_    IN NUMBER,
   part_no_       IN VARCHAR2 ) RETURN Lot_Batch_No_Table
IS
   lot_batch_no_tab_ Lot_Batch_No_Table;

   CURSOR get_received_lots IS
      SELECT lot_batch_no
      FROM   lot_batch_master_tab
      WHERE  order_type = order_type_db_
      AND    order_ref1 = order_ref1_
      AND    order_ref2 = order_ref2_
      AND    order_ref3 = order_ref3_
      AND    order_ref4 = NVL(order_ref4_, order_ref4)
      AND    part_no    = part_no_;
BEGIN
   OPEN get_received_lots;
   FETCH get_received_lots BULK COLLECT INTO lot_batch_no_tab_;
   CLOSE get_received_lots;

   RETURN lot_batch_no_tab_;
END Get_Received_Lots;

PROCEDURE Modify_Expiration_Date (   
   part_no_          IN VARCHAR2,   
   lot_batch_no_     IN VARCHAR2,   
   expiration_date_  IN DATE,
   contract_         IN VARCHAR2)
IS  
   transaction_description_ VARCHAR2(2000);  
   newrec_                  lot_batch_master_tab%ROWTYPE;  
   sequence_no_             NUMBER;
   potency_                 NUMBER;
      
BEGIN  
      
   newrec_ := Lock_By_Keys___(part_no_,lot_batch_no_);   
   
   IF (newrec_.expiration_date IS NULL AND expiration_date_ IS NOT NULL) THEN 
      
      newrec_.expiration_date := expiration_date_;
      Modify___(newrec_ , TRUE);
      
      transaction_description_ :=
         Language_SYS.Translate_Constant(lu_name_, 'MODEXPDATE: Expiration Date has been set to :P1', NULL, newrec_.expiration_date);

         Lot_Batch_History_API.New(sequence_no_,
                                   lot_batch_no_,
                                   part_no_,
                                   contract_,
                                   SYSDATE,
                                   transaction_description_,
                                   0,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   NULL,
                                   potency_,
                                   NULL);
   END IF;    
END Modify_Expiration_Date;

-- Modify_Condition_Code
--   Modify condition code.
PROCEDURE Modify_Condition_Code (
   part_no_ IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2,
   condition_code_ IN VARCHAR2 )
IS
   newrec_                  lot_batch_master_tab%ROWTYPE;
   transaction_description_ Lot_Batch_History.transaction_desc%TYPE;
   sequence_no_             NUMBER;
   potency_                 NUMBER;
   old_condition_code_      lot_batch_master_tab.condition_code%TYPE;
BEGIN
   IF NOT Check_Exist___(part_no_, lot_batch_no_) THEN
      Error_SYS.Record_General(lu_name_, 'LOTNOTEXIST: The lot batch number :P1 does not exist', lot_batch_no_);
   END IF;
   newrec_ := Lock_By_Keys___(part_no_, lot_batch_no_);
   old_condition_code_    := newrec_.condition_code;
   newrec_.condition_code := condition_code_;
   Modify___(newrec_);

   transaction_description_ :=
      Language_SYS.Translate_Constant(lu_name_, 'MODCONDCODE: Condition Code modified from :P1 to :P2', NULL, old_condition_code_, condition_code_);

   Lot_Batch_History_API.New(sequence_no_,
                          lot_batch_no_,
                          part_no_,
                          '*',
                          SYSDATE,
                          transaction_description_,
                          0,
                          NULL,
                          NULL,
                          NULL,
                          NULL,
                          NULL,
                          potency_,
                          condition_code_);
END Modify_Condition_Code;


-- Get_Structure_Ownership
--   This method returns ownership information for the identified
--   part/lot batch and known components in the serial structure.
PROCEDURE Get_Structure_Ownership (
   has_single_ownership_      OUT VARCHAR2,
   contains_company_owned_    OUT VARCHAR2,
   contains_supplier_loaned_  OUT VARCHAR2,
   contains_customer_owned_   OUT VARCHAR2,
   owning_vendor_no_list_     OUT VARCHAR2,
   owning_customer_no_list_   OUT VARCHAR2,
   part_no_                   IN  VARCHAR2,
   lot_batch_no_              IN  VARCHAR2,
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
   serial_no_                      VARCHAR2(20) := '*';
BEGIN


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
                                                          lot_batch_no_,
                                                          top_part_ownership_db_,
                                                          top_owning_vendor_no_,
                                                          top_owning_customer_no_);                 
   $END

   has_single_ownership_      := this_has_single_ownership_;
   contains_company_owned_    := this_contains_company_owned_;
   contains_supplier_loaned_  := this_contains_supplier_loaned_;
   contains_customer_owned_   := this_contains_customer_owned_;

   --format lists for client
   owning_vendor_no_list_     := this_owning_vendor_no_list_;
   owning_customer_no_list_   := this_owning_customer_no_list_;

END Get_Structure_Ownership;


-- Receive_Mro_Shop_Order
--   Receives MRO type shop orders.
PROCEDURE Receive_Mro_Shop_Order (
   part_no_          IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   contract_         IN VARCHAR2,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_  IN NUMBER,
   potency_          IN NUMBER,
   durability_day_   IN NUMBER,
   condition_code_   IN VARCHAR2 )
IS
   sequence_no_             NUMBER;
   newrec_                  lot_batch_master_tab%ROWTYPE;
   order_type_db_           VARCHAR2(10);
BEGIN
   order_type_db_ := 'SHOP ORDER';

   IF (NOT Check_Exist___(part_no_, lot_batch_no_)) THEN
      newrec_.part_no           := part_no_;
      newrec_.lot_batch_no      := lot_batch_no_;
      newrec_.initial_contract  := contract_;
      newrec_.order_type        := order_type_db_;
      newrec_.order_ref1        := order_ref1_;
      newrec_.order_ref2        := order_ref2_;
      newrec_.order_ref3        := order_ref3_;
      newrec_.order_ref4        := order_ref4_;
      newrec_.scrapped_qty      := 0;
      newrec_.shipped_qty       := 0;
      newrec_.condition_code    := condition_code_;
      newrec_.received_qty      := transaction_qty_;
      newrec_.manufactured_date := transaction_date_;
      newrec_.best_before_date  := transaction_date_ + NVL(durability_day_,0);
      New___(newrec_);
   ELSE
      newrec_ := Lock_By_Keys___(part_no_, lot_batch_no_);
      IF (newrec_.received_qty < transaction_qty_) THEN
         IF (potency_ IS NOT NULL) THEN
            newrec_.received_qty := transaction_qty_;
            Modify___(newrec_);
         END IF;
      END IF;
   END IF;
   Lot_Batch_History_API.New(sequence_no_,
                             lot_batch_no_,
                             part_no_,
                             contract_,
                             transaction_date_,
                             transaction_desc_,
                             transaction_qty_,
                             order_type_db_,
                             order_ref1_,
                             order_ref2_,
                             order_ref3_,
                             order_ref4_,
                             potency_,
                             newrec_.condition_code);
END Receive_Mro_Shop_Order;


-- Unreceive_Mro_Shop_Order
--   Unreceives MRO type shop orders.
PROCEDURE Unreceive_Mro_Shop_Order (
   part_no_          IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   contract_         IN VARCHAR2,
   order_ref1_       IN VARCHAR2,
   order_ref2_       IN VARCHAR2,
   order_ref3_       IN VARCHAR2,
   order_ref4_       IN NUMBER,
   transaction_date_ IN DATE,
   transaction_desc_ IN VARCHAR2,
   transaction_qty_  IN NUMBER,
   potency_          IN NUMBER )
IS
   sequence_no_             NUMBER;
   condition_code_          lot_batch_master_tab.condition_code%TYPE;
BEGIN
   condition_code_ := Get_Condition_Code(part_no_, lot_batch_no_);

   Lot_Batch_History_API.New(sequence_no_,
                             lot_batch_no_,
                             part_no_,
                             contract_,
                             transaction_date_,
                             transaction_desc_,
                             transaction_qty_,
                             'SHOP ORDER',
                             order_ref1_,
                             order_ref2_,
                             order_ref3_,
                             order_ref4_,
                             potency_,
                             condition_code_);
END Unreceive_Mro_Shop_Order;


-- Get_Max_Lot_Batch_No
--   Return maximum number of given Lot Batch No pattern.
@UncheckedAccess
FUNCTION Get_Max_Lot_Batch_No (
   lot_batch_no_in_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   start_pos_max_        NUMBER;
   lot_batch_no_out_     lot_batch_master_tab.lot_batch_no%TYPE;

   CURSOR get_max_lot_batch_no_ IS
      SELECT substr(lot_batch_no, start_pos_max_, length(lot_batch_no)) lot
      FROM lot_batch_master_tab
      WHERE lot_batch_no LIKE lot_batch_no_in_ || '%';

   sub_length_ NUMBER;
   cur_char_   VARCHAR2(1);
   max_        NUMBER:=0;
   valid_num_  BOOLEAN;

BEGIN
   start_pos_max_ := length(lot_batch_no_in_) + 1;

   FOR rec IN get_max_lot_batch_no_ LOOP
      valid_num_ := TRUE;
      sub_length_ := LENGTH(rec.lot);

      IF sub_length_ IS NOT NULL THEN
         FOR n_ IN 1..sub_length_ LOOP
            cur_char_ := substr(rec.lot,n_,1);
            IF cur_char_ NOT IN (chr(48),chr(49),
                                 chr(50),chr(51),
                                 chr(52),chr(53),
                                 chr(54),chr(55),
                                 chr(56),chr(57)) THEN
               valid_num_ := FALSE;
               EXIT;
            END IF;
         END LOOP;
   
         IF valid_num_ THEN
            IF TO_NUMBER(rec.lot) > max_ THEN
               max_ := TO_NUMBER(rec.lot);
            END IF;
         END IF;
      END IF;
   END LOOP;

   lot_batch_no_out_ := max_;

   IF lot_batch_no_out_ IS NOT NULL THEN
      lot_batch_no_out_ := lot_batch_no_in_ || lot_batch_no_out_;
   ELSE
      lot_batch_no_out_ := lot_batch_no_in_ || '0';
   END IF;

   RETURN lot_batch_no_out_;
END Get_Max_Lot_Batch_No;


-- Consume_Customer_Consignment
-- New Lot batch History record will be created at customer consignment stock's consumption.
PROCEDURE Consume_Customer_Consignment (
   lot_batch_no_            IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   contract_                IN VARCHAR2,
   transaction_date_        IN  DATE,
   transaction_qty_         IN  NUMBER,
   order_type_              IN VARCHAR2,
   order_ref1_              IN VARCHAR2,
   order_ref2_              IN VARCHAR2,
   order_ref3_              IN VARCHAR2,
   order_ref4_              IN NUMBER,
   potency_                 IN NUMBER,
   condition_code_          IN VARCHAR2)
IS
   dummy_number_            NUMBER;
   transaction_desc_        Lot_Batch_History.transaction_desc%TYPE;
BEGIN
  
   transaction_desc_ := Language_SYS.Translate_Constant(lu_name_, 'LBCONSMCOE: Reported Consumed on customer consignment stock order :P1', NULL, order_ref1_ || ' ' || order_ref2_ || ' ' || order_ref3_);
   Lot_Batch_History_API.New(sequence_no_      => dummy_number_,
                             lot_batch_no_     => lot_batch_no_,
                             part_no_          => part_no_,
                             contract_         => contract_,
                             transaction_date_ => transaction_date_,
                             transaction_desc_ => transaction_desc_,
                             transaction_qty_  => transaction_qty_,
                             order_type_       => order_type_,
                             order_ref1_       => order_ref1_,
                             order_ref2_       => order_ref2_,
                             order_ref3_       => order_ref3_,
                             order_ref4_       => order_ref4_,
                             potency_          => potency_,
                             condition_code_   => condition_code_);
  
END Consume_Customer_Consignment;

PROCEDURE Reset_Condition_Code (
   part_no_ IN VARCHAR2)
IS
   CURSOR get_lot_batch_no IS
      SELECT lot_batch_no
        FROM lot_batch_master_tab
       WHERE part_no = part_no_
         FOR UPDATE;  
BEGIN
   FOR rec_ IN get_lot_batch_no LOOP
      Modify_Condition_Code(part_no_,
                            rec_.lot_batch_no,
                            NULL);
   END LOOP;   
END Reset_Condition_Code;

@UncheckedAccess
FUNCTION Is_Child (
   part_no_       IN VARCHAR2,
   lot_batch_no_  IN VARCHAR2) RETURN VARCHAR2
IS
   is_child_ VARCHAR2(200) := Fnd_Boolean_API.DB_TRUE; 
BEGIN
   IF (Get_Parent_Lot(part_no_, lot_batch_no_) IS NULL) THEN
      is_child_ := Fnd_Boolean_API.DB_FALSE;
   END IF;
   RETURN is_child_;   
END Is_Child;


PROCEDURE Set_Manufacturer_Info (
   info_                       OUT VARCHAR2,
   part_no_                    IN  VARCHAR2,
   lot_batch_no_               IN  VARCHAR2,
   manufacturer_no_            IN  VARCHAR2,
   manufacturer_part_no_       IN  VARCHAR2,
   manufacturer_lot_batch_no_  IN  VARCHAR2,
   manufactured_date_          IN  DATE )
IS
   newrec_        lot_batch_master_tab%ROWTYPE;
   exit_procedure EXCEPTION;
BEGIN

   newrec_ := Lock_By_Keys___(part_no_, lot_batch_no_);
   
   IF NOT(Validate_SYS.Is_Changed(newrec_.manufacturer_no, manufacturer_no_) OR 
          Validate_SYS.Is_Changed(newrec_.manufacturer_part_no, manufacturer_part_no_) OR 
          Validate_SYS.Is_Changed(newrec_.manufactured_date, manufactured_date_) OR 
          Validate_SYS.Is_Changed(newrec_.manufacturer_lot_batch_no, manufacturer_lot_batch_no_)) THEN
      RAISE exit_procedure;
   END IF;

   newrec_.manufacturer_no           := manufacturer_no_;
   newrec_.manufacturer_part_no      := manufacturer_part_no_;
   newrec_.manufactured_date         := manufactured_date_;
   newrec_.manufacturer_lot_batch_no := manufacturer_lot_batch_no_;
   Modify___(newrec_);

   info_ := Client_SYS.Get_All_Info;
   EXCEPTION
      WHEN exit_procedure THEN
         NULL;
END Set_Manufacturer_Info;
