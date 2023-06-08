-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartInTransit
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220110  RoJalk  SC21R2-2756, Added the project_id to the entity and added method Check_Project_Id_Insert___.
--  271027  RoJalk  SC21R2-3082, Added the method Get_Owner_Name.
--  211027  RoJalk  SC21R2-3082, Added the parameters part_ownership_db_, owning_customer_no_, owning_vendor_no_ to Handle_Intersite_Transit___ to support external ownerships for shipment order.
--  211013  RoJalk  SC21R2-688, Modified Handle_Intersite_Transit___ and included activity_seq_ value in transaction creation to support project aware shipment orders. 
--  200824  RoJalk  SC2020R1-9252, Added new key columns activity_seq, part_ownership_db, owning_customer_no, owning_vendor_no, deliv_no, 
--  200824          shipment_id, shipment_line_no as parameters to the method Move_Into_Order_Transit, Remove_From_Order_Transit, Unreceive_Part_To_Transit 
--  200824          and modified calling method Modify_Lot_Expiration_Date. Removed the unused method Get_Splittable_Transit_Qty.  
--  200423  ErRalk  SC2020R1-6694, Modified Unreceive_Part_To_Transit method by fixing issue in changing expiration date for lot/batch tracked inventory part.
--  191115  RoJalk  SCSPRING20-984, Modified Move_Into_Order_Transit and included 'SHIPODSIT-' to create 'INTORDTR' for shipment order.
--  190524  ShPrlk  Bug 145072, Added Get_Serial_Destination_Site to fetch the destination site of the serial that is in transit.
--  170901  UdGnlk  Bug 136645, Modified Move_Into_Order_Transit() to introduce 'PURTRAN' to move to transit object with transaction INTORDTR.
--  170522  ChBnlk  Bug 135688, Added new method Get_Handling_Unit_Row_Count() to check the number of rows that are using a particular handling_unit_id.
--  170328  NaSalk  LIM-11296, Added  validate_hu_struct_position_ to Remove_From_Order_Transit.
--  170208  Chfose  LIM-10633, Added new method Handling_Unit_Exists.
--  170207  Chfose  LIM-10534, Added validate_hu_struct_position_ to Update___ & Unreceive_Part_To_Transit.
--  170123  Jhalse  Added validate_hu_struct_position_ to subdue validation when moving handling units to transit.
--  150814  RasDlk  Bug 124030, Added the procedure Check_Serial_Exist___ and modified Check_Insert___ and Check_Update___ to check whether
--  150814          a part with a quantity exists for a specified serial number in Inventory_Part_In_Transit_Tab. Added the procedure Raise_Serial_In_Use___.
--  150730  SWiclk  Bug 121254, Modified Move_Into_Order_Transit() by adding a method call to Inventory_Part_Barcode_API.Copy() in order to copy barcode.
--  150512  IsSalk  KES-421, Passed new parameter to Inventory_Transaction_Hist_API.New().--  130805  ChJalk  TIBE-878, Removed the global variable last_calendar_date_.
--  150415  LEPESE  LIM-88, added method Handling_Unit_Exist.
--  150414  JeLise  Added new key column handling_unit_id.
--  130805  ChJalk  TIBE-878, Removed the global variable last_calendar_date_.
--  130624  ChFolk  Modified Move_Into_Order_Transit to avoid error in error text ORDERNOTEXIST.
--  130220  UdGnlk  Modified Move_Into_Order_Transit() to rearrange the logic of triggering 'RINTORDTRX' transaction. 
--  130129  UdGnlk  Modified Move_Into_Order_Transit() to trigger 'RINTORDTRX' transaction when connected customer order is Purchase Order Direct.   
--  120711  Asawlk  Bug 103802, Modified Move_Into_Order_Transit() and Unreceive_Part_To_Transit() to lock the records properly to handle simultaneous updates. 
--  130604  Asawlk  EBALL-37, Added function Get_Lot_Batch_Track_Status().
--  120127  MaEelk  Modified the date format of EXPIRATION_DATE in view comments.
--  111027  NISMLK  SMA-285, Increased eng_chg_level length to STRING(6) in column comments.
--  111021  MaEelk  Added UAS filter to INVENTORY_PART_IN_TRANSIT_CC and replaced the usage of this view in the business logic with the table
--  110819  NiBalk  Bug 97297, Added new method Modify_Lot_Expiration_Date().
--  110715  MaEelk  Added user allowed site filter to INVENTORY_PART_IN_TRANSIT_DEL.
--  110204  KiSalk  Moved 'User Allowed Site' Default Where condition from client to VIEW3.
--  100715  GayDLK  Bug 89478, Added new function Get_Total_Qty_In_Order_Trans().
--  101103  LEPESE  Modification of checks in view INVENTORY_PART_IN_TRANSIT_DEL, methods Move_Into_Order_Transit and
--  101103          Get_Splittable_Transit_Qty to consider receipt_issue_serial_track_db instead of serial_tracking_code.
--  101103          Added package constants db_true_ and db_false_. Replaced strings 'TRUE' and 'FALSE' with these constants.
--  101027  LEPESE  Added method Quantity_Exists.
--  100705  DAYJLK  Bug 91477, Modified Remove_From_Order_Transit by using Lock_By_Id___ instead of Get_Object_By_Keys___
--  100705          to ensure proper locking prior to the removal of records and also replaced in_transit_rec_ with oldrec_.
--  100510  KRPELK  Merge Rose Method Documentation.
--  100406  MaRalk  Modified reference by name method call to Inventory_Transaction_Hist_API.New within Move_Into_Order_Transit method.
--  090929  ChFolk  Removed unused variables in the package.
--  ------------------------------- 14.0.0 ------------------------------------
--  090514  SuThlk  Bug 82688, Modified corrections related to 78283 in Get_Total_Qty_In_Order_Transit.
--  090303  JENASE  Bug 78283, Added new IN parameter, unit_of_measure_type_, to method Get_Total_Qty_In_Order_Transit 
--                  that enable the method to return catch qty if set to 'CATCH'.
--  071019  MarSlk  Bug 68162, Modified method Move_Into_Order_Transit and removed the 
--  071019          TO_DATE function for expiration_date_.
--  070605  LEPESE  Modification in method Move_Into_Order_Transit. Added transit_location_group_
--  070605          in call to Inventory_Transaction_Hist_API.New.
--  070110  DaZase  Converted qty into the destination sites UoM in Move_Into_Order_Transit.
--  061228  DaZase  Changed all usage of catch_unit_code from part catalog record so it now is fetched from Inventory_Part_API.Get_Catch_Unit_Meas instead.
--  061011  IsWilk  Added the format 'YYYY-MM-DD' to column expiration_date in VIEW1, VIEW2 and VIEW3.
--  061003  IsWilk  Bug 60160, Modified Move_Into_Order_Transit to raise an error when serial or lot/batch
--  061003          is not specified when PODIRINTEM or INTPODIRIM transactions are been made for 
--  061003          cost levels Cost per Lot/Batch, Cost per Serial and Cost per Condition.
--  060810  ChJalk  Modified hard_coded dates to be able to use any calendar.
--  060123  LEPESE  Added inventory_valuation_method and inventory_part_cost_level when
--  060123          calling Inventory_Part_In_Stock_API.Transform_Cost_Details.
--  051111  JoAnSe  Replaced call to Inventory_Transaction_Hist_API.Associate_Transactions
--                  with Invent_Trans_Interconnect_API.Connect_Transactions
--  051107  JoAnSe  Replaced call to Inventory_Transaction_Hist_API.Set_Associated_Transaction_Id
--                  with Inventory_Transaction_Hist_API.Associate_Transactions
--                  Removed call to Intersite_Move_Revaluation
--  051006  JoAnSe  Added handling for zero cost in Move_Into_Order_Transit
--  051005  JoAnSe  Added handling of cost details to Move_Into_Order_Transit
--  050930  SaRalk  Modified procedure Move_Into_Order_Transit.
--  050927  JoAnSe  Merged DMC Changes below
--  **********************  DMC Merge End  *************************************
--  050920  JoAnSe  Added call to Inventory_Part_in_Stock_API.Intersite_Move_Revaluation in
--                  Move_Into_Order_Transit instead of calculating and posting the diff locally.
--  050622  LEPESE  Modifications in method Remove_From_Order_Transit. Removed several validations
--  050622          preceeding the call to Inventory_Part_Unit_Cost_API.Remove() and placed them
--  050622          inside Inventory_Part_Unit_Cost_API.Remove().
--  **********************  DMC Merge Begin  ***********************************
--  050922  SaRalk  Modified procedure Move_Into_Order_Transit.
--  050920  NiDalk  Removed unused variables.
--  050913  LaBolk  Bug 52950, Modified Move_Into_Order_Transit to check if the part number exists on site before proceeding with the transaction.
--  050829  IsAnlk  Modified Unreceive_Part_To_Transit to assign correct value to expiration_date. 
--  050826  IsAnlk  Added new view INVENTORY_PART_IN_TRANSIT_ALL. 
--  050823  IsAnlk  Added EXPIRATION_DATE as a key to InventoryPartInTransit LU and changed the code accordingly.
--  050613  SeJalk  Bug 51575, Changed the length of SERIAL_NO to STRING(50) in relevent views.
--  050331  RaKalk  Modified Unpack_Check_Update___, Unpack_Check_Insert___ to call catch unit validation functions.
--  050303  SeJalk  Bug 49256, Added new transaction codes,CO-SHIPTRN and CO-SHIPDIR in procedure Move_Into_Order_Transit.
--  050112  NaLrLk  Added the implementation methods Raise_Catch_Qty_Null_Error___,Raise_Catch_Zero_Neg_Error___,Check_Catch_Unit_Insert___ and Check_Catch_Unit_Update___.
--  041129  IsAnlk  Renamed Check_Quantity_Exist as Transi_Qty_Without_Catch_Exist and modified the cursor.
--  041110  SaJjlk  Added catch_quantity to VIEW1 and VIEW2.
--  041004  NuFilk  Modified method Unpack_Check_Update___.
--  040920  NuFilk  Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ included a check on inventory part status.
--  040914  SaJjlk  Renamed the column Catch_Qty to Catch_Quantity and
--                  added validations in methods Unpack_Check_Insert___, Unpack_Check_Update___.
--  040910  SaJjlk  Added method Check_Quantity_Exist.
--  040909  SaJjlk  Added catch_qty column and added parameter catch_qty_ to methods Move_Into_Order_Transit,
--                  Remove_From_Order_Transit and Unreceive_Part_To_Transit.
--  040824  DAYJLK  Call ID 116770, Added parameter remove_unit_cost_ to Remove_From_Order_Transit. Modified Remove_From_Order_Transit
--  040824          to remove unit cost record for serial and lot batch parts. Added UNDEFINE statements.
--  040811  DAYJLK  Modified text of error messages in Remove_From_Order_Transit.
--  040811  DAYJLK  Modified Move_Into_Order_Transit to use the correct cost when using Standard Cost.
--  040629  MaGulk  Added 3 default NULL parameters to Get_Total_Qty_In_Order_Transit and
--  040629          added new cursor to get quantities when condition code is provided
--  040628  MaGulk  Added VIEW2 to include condition code to get quantities
--  040621  NuFilk  Renamed method Get_Total_Oder_Transit_Qty to Get_Total_Qty_In_Order_Transit
--  040614  MaGulk  Added method Check_Lot_Batch_Exist
--  040609  MaGulk  Rename method Get_Total_Qty_Per_Part_Config to Get_Total_Oder_Transit_Qty
--  040608  MaGulk  Added parameters lot_batch_no, serial_no to Get_Total_Qty_Per_Part_Config
--  040527  SHVESE  M4/Transibal merge into edge- Replaced call to InventoryPartConfig Get_Inventory_Value_By_Method
--  040527           and Init_Inventory_Value with corresponding methods in InventoryPartUnitCost.
--  040527           Added project_id, activity_seq in call to InventoryTransactionHist.New.
--  040514  MiKulk  Bug 44521, Removed the expiration_date from the code.
--  040423  DAYJLK  Bug 40671, Modified parameter type of qty_to_unreceive_ to Number in Unreceive_Part_To_Transit.
--  040423          renamed qty_to_receive_ to qty_to_remove_ in Method Remove_From_Order_Transit.
--  040414  DAYJLK  Bug 40671, Modified cursor get_attr to use part_catalog_pub instead
--  040414          of part_catalog_tab in method Get_Splittable_Transit_Qty.
--  040402  DAYJLK  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_true_                        CONSTANT VARCHAR2(4) := Fnd_Boolean_API.db_true;

db_false_                       CONSTANT VARCHAR2(5) := Fnd_Boolean_API.db_false;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Raise_Catch_Qty_Null_Error___
--   Error to be raised when catch quantity is null
PROCEDURE Raise_Catch_Qty_Null_Error___ (
   part_no_         IN VARCHAR2,
   catch_unit_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General('InventoryPartInTransit', 'CATCHQTYPLSENTER: Part :P1 uses Catch Unit :P2 and Catch Quantity must be entered.',
                            part_no_, catch_unit_code_);
END Raise_Catch_Qty_Null_Error___;


-- Raise_Catch_Zero_Neg_Error___
--   Error to be raised when catch quantity is zero or negative.
PROCEDURE Raise_Catch_Zero_Neg_Error___
IS
BEGIN
   Error_SYS.Record_General('InventoryPartInTransit', 'CATCHQTYPOSITIVE: Catch Quantity must be greater than 0.');
END Raise_Catch_Zero_Neg_Error___;


-- Check_Catch_Unit_Insert___
--   Method that validate the catch quantity when a new record is being inserted.
PROCEDURE Check_Catch_Unit_Insert___ (
   newrec_           IN OUT INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE,
   part_catalog_rec_ IN     Part_Catalog_API.Public_Rec )
IS
BEGIN
   IF (part_catalog_rec_.catch_unit_enabled = db_true_) THEN
      IF (newrec_.quantity != 0) THEN
         IF (newrec_.catch_quantity IS NULL) THEN
            Raise_Catch_Qty_Null_Error___(newrec_.part_no, Inventory_Part_API.Get_Catch_Unit_Meas(newrec_.contract, newrec_.part_no));
         ELSIF (newrec_.catch_quantity <= 0) THEN
            Raise_Catch_Zero_Neg_Error___;
         END IF;
      ELSE
         newrec_.catch_quantity := 0;
      END IF;
   ELSE
      newrec_.catch_quantity := NULL;
   END IF;
END Check_Catch_Unit_Insert___;

PROCEDURE Check_Project_Id_Insert___ (
   newrec_ IN OUT INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE )
IS
   delivering_site_check_  NUMBER;
   site_check_             NUMBER;
   inval_proj_site_error   EXCEPTION;
   error_contract_         VARCHAR2(5);
BEGIN
   IF (newrec_.activity_seq != 0) THEN    
      $IF Component_Proj_SYS.INSTALLED $THEN
         newrec_.project_id     := Activity_API.Get_Project_Id(newrec_.activity_seq); 
         delivering_site_check_ := Project_Site_API.Project_Site_Exist(newrec_.project_id, newrec_.delivering_contract);
         IF (delivering_site_check_ = 0) THEN
            error_contract_ := newrec_.delivering_contract;
            RAISE inval_proj_site_error;
         END IF;
         site_check_ := Project_Site_API.Project_Site_Exist(newrec_.project_id, newrec_.contract);
         IF (site_check_ = 0) THEN
            error_contract_ := newrec_.contract;
            RAISE inval_proj_site_error;
         END IF;
      $ELSE
         Error_SYS.Component_Not_Exist('PROJ');    
      $END
   END IF;
EXCEPTION
   WHEN inval_proj_site_error THEN
      Error_SYS.Record_General(lu_name_,'NOTPRJSITE: Site :P1 is not a valid project site for project :P2.', error_contract_, newrec_.project_id);
END Check_Project_Id_Insert___;

-- Check_Catch_Unit_Update___
--   Method that validate the catch quantity when an existing record is being updated.
PROCEDURE Check_Catch_Unit_Update___ (
   newrec_           IN OUT INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE,
   oldrec_           IN     INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE,
   part_catalog_rec_ IN     Part_Catalog_API.Public_Rec )
IS
BEGIN
   IF (part_catalog_rec_.catch_unit_enabled = db_true_) THEN
      IF (newrec_.quantity = 0) THEN
         newrec_.catch_quantity := 0;
      ELSIF (newrec_.catch_quantity IS NULL) THEN
         Raise_Catch_Qty_Null_Error___(newrec_.part_no, Inventory_Part_API.Get_Catch_Unit_Meas(newrec_.contract, newrec_.part_no));
      ELSIF (newrec_.quantity > oldrec_.quantity) THEN
         IF (newrec_.catch_quantity <= oldrec_.catch_quantity) THEN
            Raise_Catch_Zero_Neg_Error___;
         END IF;
      ELSIF (newrec_.quantity < oldrec_.quantity) THEN
         IF (newrec_.catch_quantity >= oldrec_.catch_quantity) THEN
            Raise_Catch_Zero_Neg_Error___;
         END IF;
         IF (newrec_.catch_quantity < 0) THEN
            newrec_.catch_quantity := 0;
         END IF;
      END IF;
   ELSE
      newrec_.catch_quantity := NULL;
   END IF;
END Check_Catch_Unit_Update___;


PROCEDURE Check_Serial_Exist___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
   dummy_      NUMBER;
   
   CURSOR serial_exist IS
      SELECT 1
      FROM  INVENTORY_PART_IN_TRANSIT_TAB
      WHERE part_no = part_no_
      AND   serial_no = serial_no_
      AND   quantity != 0;
BEGIN   
   OPEN serial_exist;
   FETCH serial_exist INTO dummy_;
   IF (serial_exist%FOUND) THEN
      CLOSE serial_exist;
      Raise_Serial_In_Use___(part_no_, serial_no_);      
   END IF;
   CLOSE serial_exist;         
END Check_Serial_Exist___;

PROCEDURE Raise_Serial_In_Use___ (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_General('InventoryPartInTransit', 'INVPARTSERIALINUSE: Inventory part :P1 with serial number :P2 is already in use.', part_no_, serial_no_);
END Raise_Serial_In_Use___;


@Override
PROCEDURE Insert___ (
   objid_                       OUT    VARCHAR2,
   objversion_                  OUT    VARCHAR2,
   newrec_                      IN OUT INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE,
   attr_                        IN OUT VARCHAR2,
   validate_hu_struct_position_ IN     BOOLEAN DEFAULT TRUE)
IS
BEGIN
   newrec_.expiration_date := TRUNC(newrec_.expiration_date);
   super(objid_, objversion_, newrec_, attr_);
   
   Check_Handling_Unit___(handling_unit_id_            => newrec_.handling_unit_id,
                          old_quantity_                => 0, 
                          new_quantity_                => newrec_.quantity,
                          validate_hu_struct_position_ => validate_hu_struct_position_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-- Update___
--   Update a record in database with new data.
@Override
PROCEDURE Update___ (
   objid_                        IN     VARCHAR2,
   oldrec_                       IN     inventory_part_in_transit_tab%ROWTYPE,
   newrec_                       IN OUT inventory_part_in_transit_tab%ROWTYPE,
   attr_                         IN OUT VARCHAR2,
   objversion_                   IN OUT VARCHAR2,
   by_keys_                      IN     BOOLEAN DEFAULT FALSE,
   validate_hu_struct_position_  IN     BOOLEAN DEFAULT TRUE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);

   Check_Handling_Unit___(handling_unit_id_              => newrec_.handling_unit_id,
                          old_quantity_                  => oldrec_.quantity, 
                          new_quantity_                  => newrec_.quantity,
                          validate_hu_struct_position_   => validate_hu_struct_position_);
END Update___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_part_in_transit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   part_status_        VARCHAR2(3);
   part_stat_desc_     VARCHAR2(35);
   part_catalog_rec_   Part_Catalog_API.Public_Rec;
   last_calendar_date_ DATE        := Database_Sys.last_calendar_date_;
BEGIN  
   IF (newrec_.expiration_date IS NULL) THEN
      newrec_.expiration_date := last_calendar_date_;
   END IF;
   
   super(newrec_, indrec_, attr_);
   
   Check_Project_Id_Insert___(newrec_);
   
   IF (newrec_.serial_no != '*') THEN
      IF (newrec_.quantity !=1) THEN
         Raise_Serial_In_Use___(newrec_.part_no, newrec_.serial_no);
      END IF; 
      Check_Serial_Exist___(newrec_.part_no, newrec_.serial_no);
   END IF;

   part_status_ := Inventory_Part_API.Get_Part_Status(newrec_.contract, newrec_.part_no);

   IF (Inventory_Part_Status_Par_API.Get_Onhand_Flag_Db(part_status_) = 'N') THEN
      part_stat_desc_ := Inventory_Part_Status_Par_API.Get_Description(part_status_);
      Error_SYS.Record_General('InventoryPartInTransit', 'NOTONHAND: Inventory part :P1 has part status :P2 which does not allow quantity on hand', newrec_.part_no , part_stat_desc_);
   END IF;

   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   Check_Catch_Unit_Insert___(newrec_, part_catalog_rec_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     inventory_part_in_transit_tab%ROWTYPE,
   newrec_ IN OUT inventory_part_in_transit_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_             VARCHAR2(30);
   value_            VARCHAR2(2000);
   part_status_      VARCHAR2(3);
   part_stat_desc_   VARCHAR2(35);
   part_catalog_rec_ Part_Catalog_API.Public_Rec;
BEGIN   
   IF (newrec_.serial_no != '*') THEN
      IF (newrec_.quantity !=1) THEN
         Raise_Serial_In_Use___(newrec_.part_no, newrec_.serial_no);
      END IF;
   END IF;
   
   part_status_ := Inventory_Part_API.Get_Part_Status(oldrec_.contract, oldrec_.part_no);

   IF (Inventory_Part_Status_Par_API.Get_Onhand_Flag_Db(part_status_) = 'N') THEN
      part_stat_desc_ := Inventory_Part_Status_Par_API.Get_Description(part_status_);
      Error_SYS.Record_General('InventoryPartInTransit', 'NOTONHAND: Inventory part :P1 has part status :P2 which does not allow quantity on hand', oldrec_.part_no , part_stat_desc_);
   END IF;

   part_catalog_rec_ := Part_Catalog_API.Get(newrec_.part_no);
   Check_Catch_Unit_Update___(newrec_, oldrec_, part_catalog_rec_);
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


PROCEDURE Check_Handling_Unit___ (
   handling_unit_id_            IN NUMBER,
   old_quantity_                IN NUMBER,
   new_quantity_                IN NUMBER,
   validate_hu_struct_position_ IN BOOLEAN DEFAULT TRUE)
IS
BEGIN
   IF (handling_unit_id_ != 0 AND old_quantity_ = 0 AND new_quantity_ != 0 AND validate_hu_struct_position_) THEN
      Handling_Unit_API.Validate_Structure_Position(handling_unit_id_);
   END IF;
END Check_Handling_Unit___;


PROCEDURE Handle_Intersite_Transit___ (
   destination_qty_             OUT NUMBER,
   destination_catch_qty_       OUT NUMBER,
   delivering_contract_         IN  VARCHAR2,
   contract_                    IN  VARCHAR2,
   part_no_                     IN  VARCHAR2,
   configuration_id_            IN  VARCHAR2,
   lot_batch_no_                IN  VARCHAR2,
   serial_no_                   IN  VARCHAR2,
   eng_chg_level_               IN  VARCHAR2,
   waiv_dev_rej_no_             IN  VARCHAR2,
   handling_unit_id_            IN  NUMBER,
   expiration_date_             IN  DATE,
   activity_seq_                IN  NUMBER,
   part_ownership_db_           IN  VARCHAR2,
   owning_customer_no_          IN  VARCHAR2,
   owning_vendor_no_            IN  VARCHAR2,
   quantity_                    IN  NUMBER,
   catch_quantity_              IN  NUMBER,
   transaction_id_              IN  NUMBER,
   transaction_code_            IN  VARCHAR2,
   from_transaction_code_       IN  VARCHAR2 )
IS
   new_transaction_id_     NUMBER;
   accounting_id_          NUMBER;
   value_                  NUMBER;
   inv_part_rec_           Inventory_Part_API.Public_Rec;
   from_cost_detail_tab_   Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   to_cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   price_                  NUMBER;
   part_catalog_rec_       Part_Catalog_API.Public_Rec;
BEGIN
   inv_part_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (from_transaction_code_ IN ('INTPODIRIM', 'PODIRINTEM')) THEN
      IF (inv_part_rec_.inventory_part_cost_level NOT IN ('COST PER PART', 'COST PER CONFIGURATION')) THEN
         part_catalog_rec_ := Part_Catalog_API.Get(part_no_);

         IF ((part_catalog_rec_.receipt_issue_serial_track = db_true_) AND (serial_no_ = '*')) THEN
            Error_SYS.Record_General(lu_name_, 'SERIALMND: A serial number must be used with this part.');
         END IF;

         IF ((part_catalog_rec_.lot_tracking_code IN ('LOT TRACKING','ORDER BASED')) AND (lot_batch_no_ = '*')) THEN
            Error_SYS.Record_General(lu_name_, 'LOTBATMND: A lot/batch number must be used with this part.');
         END IF;
      END IF;
   END IF;
   
   IF ((inv_part_rec_.inventory_valuation_method = 'ST') AND
       (inv_part_rec_.zero_cost_flag             = 'O' )) THEN
      price_ := 0;
   ELSE
      -- Retrive cost details from the issue transaction and transform them into
      -- the corresponding details on the receiving site
      from_cost_detail_tab_ := Inventory_Transaction_Hist_API.Get_Transaction_Cost_Details(
                                                                                  transaction_id_);
      to_cost_detail_tab_   := Inventory_Part_In_Stock_API.Transform_Cost_Details(
                                                          delivering_contract_,
                                                          from_cost_detail_tab_,
                                                          contract_,
                                                          inv_part_rec_.inventory_valuation_method,
                                                          inv_part_rec_.inventory_part_cost_level);
      price_ := NULL;
   END IF;

   -- The quantity has to be converted into the destination sites UoM if a move takes 
   -- place between 2 sites. Catch Qty also needs to be converted.
   destination_qty_ := Inventory_Part_API.Get_Site_Converted_Qty(delivering_contract_,
                                                                 part_no_,
                                                                 contract_,
                                                                 quantity_,                                                                
                                                                 'REMOVE');
   destination_catch_qty_ := Inventory_Part_API.Get_Site_Converted_Qty(delivering_contract_,
                                                                       part_no_,
                                                                       contract_,
                                                                       catch_quantity_,
                                                                       'REMOVE',
                                                                       'CATCH');
   -- The cost should be converted as well.
   IF (to_cost_detail_tab_.COUNT > 0) THEN
      FOR i_ IN to_cost_detail_tab_.FIRST..to_cost_detail_tab_.LAST LOOP
         to_cost_detail_tab_(i_).unit_cost := ((to_cost_detail_tab_(i_).unit_cost * quantity_)/destination_qty_);
      END LOOP;
   END IF; 

   Inventory_Transaction_Hist_API.New(transaction_id_         => new_transaction_id_,
                                      accounting_id_          => accounting_id_,
                                      value_                  => value_,
                                      transaction_code_       => transaction_code_,
                                      contract_               => contract_,
                                      part_no_                => part_no_ ,
                                      configuration_id_       => configuration_id_,
                                      location_no_            => NULL,
                                      lot_batch_no_           => lot_batch_no_,
                                      serial_no_              => serial_no_,
                                      waiv_dev_rej_no_        => waiv_dev_rej_no_ ,
                                      eng_chg_level_          => eng_chg_level_,
                                      activity_seq_           => activity_seq_,
                                      handling_unit_id_       => handling_unit_id_,
                                      project_id_             => NULL,
                                      source_ref1_            => NULL,
                                      source_ref2_            => NULL,
                                      source_ref3_            => NULL,
                                      source_ref4_            => NULL,
                                      source_ref5_            => NULL,
                                      reject_code_            => NULL,
                                      cost_detail_tab_        => to_cost_detail_tab_,
                                      unit_cost_              => price_,
                                      quantity_               => destination_qty_,
                                      qty_reversed_           => 0,
                                      catch_quantity_         => NULL,
                                      source_                 => NULL,
                                      source_ref_type_        => NULL,
                                      owning_vendor_no_       => CASE owning_vendor_no_ WHEN '*' THEN NULL ELSE owning_vendor_no_ END,
                                      condition_code_         => NULL,
                                      location_group_         => 'INT ORDER TRANSIT',
                                      part_ownership_db_      => part_ownership_db_,
                                      owning_customer_no_     => CASE owning_customer_no_ WHEN '*' THEN NULL ELSE owning_customer_no_ END,
                                      expiration_date_        => expiration_date_,
                                      transit_location_group_ => 'INT ORDER TRANSIT');
                                        
   -- Create a connection between transactions
   Invent_Trans_Interconnect_API.Connect_Transactions(transaction_id_,
                                                      new_transaction_id_,
                                                      'INTERSITE TRANSFER');

   Inventory_Transaction_Hist_API.Do_Transaction_Booking(new_transaction_id_,
                                                         Site_API.Get_Company(contract_),
                                                         'N',
                                                         NULL);

   Inventory_Part_Barcode_API.Copy(from_contract_       => delivering_contract_,  
                                   to_contract_         => contract_,
                                   to_eng_chg_level_    => eng_chg_level_,
                                   part_no_             => part_no_,              
                                   configuration_id_    => configuration_id_,     
                                   lot_batch_no_        => lot_batch_no_,         
                                   serial_no_           => serial_no_,            
                                   eng_chg_level_       => eng_chg_level_,        
                                   waiv_dev_rej_no_     => waiv_dev_rej_no_,      
                                   activity_seq_        => 0);                    
                                   
END Handle_Intersite_Transit___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Move_Into_Order_Transit
--   Increases quantity of parts in Order Transit for Internal Orders.
--   Calling this method ensures that information about parts in Order
--   Transit is stored in the Order Transit Object.
PROCEDURE Move_Into_Order_Transit (
   delivering_contract_         IN VARCHAR2,
   contract_                    IN VARCHAR2,
   part_no_                     IN VARCHAR2,
   configuration_id_            IN VARCHAR2,
   lot_batch_no_                IN VARCHAR2,
   serial_no_                   IN VARCHAR2,
   eng_chg_level_               IN VARCHAR2,
   waiv_dev_rej_no_             IN VARCHAR2,
   handling_unit_id_            IN NUMBER,
   expiration_date_             IN DATE,
   delivering_warehouse_id_     IN VARCHAR2,
   receiving_warehouse_id_      IN VARCHAR2,
   activity_seq_                IN NUMBER,
   part_ownership_db_           IN VARCHAR2,
   owning_customer_no_          IN VARCHAR2,
   owning_vendor_no_            IN VARCHAR2,
   deliv_no_                    IN NUMBER,
   shipment_id_                 IN NUMBER,
   shipment_line_no_            IN NUMBER,
   quantity_                    IN NUMBER,
   catch_quantity_              IN NUMBER,
   transaction_id_              IN NUMBER,
   trans_order_no_              IN VARCHAR2,
   trans_line_no_               IN VARCHAR2,
   trans_rel_no_                IN VARCHAR2,
   trans_line_item_no_          IN NUMBER,
   validate_hu_struct_position_ IN BOOLEAN DEFAULT TRUE)
IS
   exit_procedure          EXCEPTION;
   oldrec_                 INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE;
   newrec_                 INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE;
   attr_                   VARCHAR2(32000);
   objid_                  INVENTORY_PART_IN_TRANSIT.objid%TYPE;
   objversion_             INVENTORY_PART_IN_TRANSIT.objversion%TYPE;
   from_transaction_rec_   Inventory_Transaction_Hist_API.Public_Rec;
   new_transaction_id_     NUMBER;
   accounting_id_          NUMBER;
   value_                  NUMBER;
   transaction_code_       VARCHAR2(10);
   inv_part_rec_           Inventory_Part_API.Public_Rec;
   new_expiration_date_    DATE;
   from_cost_detail_tab_   Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   to_cost_detail_tab_     Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   price_                  NUMBER;
   part_catalog_rec_       Part_Catalog_API.Public_Rec;
   destination_qty_        NUMBER;
   destination_catch_qty_  NUMBER;
   last_calendar_date_     DATE        := Database_Sys.last_calendar_date_;
   co_order_no_            VARCHAR2(12);
   co_line_no_             VARCHAR2(4);
   co_rel_no_              VARCHAR2(4);
   co_line_item_no_        NUMBER;
   co_supply_code_db_      VARCHAR2(3);
   intersite_              BOOLEAN;
BEGIN
   Inventory_Part_API.Exist(contract_, part_no_);

   from_transaction_rec_ := Inventory_Transaction_Hist_API.Get(transaction_id_);

   IF (from_transaction_rec_.transaction_code IN ('SHIPTRAN', 'SHIPDIR', 'INTPODIRIM', 'PURTRAN',
                                                  'PODIRINTEM', 'CO-SHIPTRN', 'CO-SHIPDIR', 'SHIPODSIT-')) THEN
      transaction_code_ := 'INTORDTR';
   ELSIF (from_transaction_rec_.transaction_code = 'RETWORKINT') THEN
      -- To retrieve connected customer orders supply code for the transaction order 
      $IF (Component_Order_SYS.INSTALLED) $THEN         
          Customer_Order_Line_API.Get_Custord_From_Demand_Info(co_order_no_, 
                                                               co_line_no_,
                                                               co_rel_no_,
                                                               co_line_item_no_,
                                                               trans_order_no_,
                                                               trans_line_no_,
                                                               trans_rel_no_,
                                                               NULL,
                                                               Order_Supply_Type_API.DB_INT_PURCH_TRANS);           
             
          co_supply_code_db_ := Customer_Order_Line_API.Get_Supply_Code_Db(co_order_no_,
                                                                           co_line_no_,
                                                                           co_rel_no_,
                                                                           co_line_item_no_);          
      $ELSE
         Error_SYS.Record_General(lu_name_,'ORDERNOTEXIST: Component ORDER is not installed.');
      $END
      
      IF (co_supply_code_db_ = Order_Supply_Type_API.DB_PURCH_ORDER_DIR) THEN
         transaction_code_ := 'RINTORDTRX';
      ELSE
         transaction_code_ := 'RINTORDTR';
      END IF;
   ELSIF (from_transaction_rec_.transaction_code = 'SHIPODWHS-') THEN
      NULL;
   ELSE
      Error_SYS.Record_General(lu_name_,'INVALIDTRANS: Transaction code :P1 is not valid for InventoryPartInTransit. Contact system support.', from_transaction_rec_.transaction_code);
   END IF;
   
   intersite_ := (contract_ != delivering_contract_);
   
   IF (((intersite_) AND (transaction_code_ IS NULL)) OR
       ((NOT intersite_) AND (transaction_code_ IS NOT NULL))) THEN
      Error_SYS.Record_General(lu_name_,'INVALIDTRANS: Transaction code :P1 is not valid for InventoryPartInTransit. Contact system support.', from_transaction_rec_.transaction_code);
   END IF;
   
   IF intersite_ THEN
      Handle_Intersite_Transit___(destination_qty_,
                                  destination_catch_qty_,
                                  delivering_contract_,
                                  contract_,
                                  part_no_,
                                  configuration_id_,
                                  lot_batch_no_,
                                  serial_no_,
                                  eng_chg_level_,
                                  waiv_dev_rej_no_,
                                  handling_unit_id_,
                                  expiration_date_,
                                  activity_seq_,
                                  part_ownership_db_,
                                  owning_customer_no_,
                                  owning_vendor_no_,
                                  quantity_,
                                  catch_quantity_,
                                  transaction_id_,
                                  transaction_code_,
                                  from_transaction_rec_.transaction_code );
   ELSE                               
      destination_qty_       := quantity_;
      destination_catch_qty_ := catch_quantity_;
   END IF;   

   IF (expiration_date_ IS NULL) THEN
      new_expiration_date_ := last_calendar_date_;
   ELSE
      new_expiration_date_ := expiration_date_;   
   END IF;   

   DECLARE
      transit_row_deleted EXCEPTION;
      PRAGMA    exception_init(transit_row_deleted, -20115);
      indrec_   Indicator_Rec;
   BEGIN
      oldrec_ := Lock_By_Keys___(delivering_contract_,
                                 contract_,
                                 part_no_,
                                 configuration_id_,
                                 lot_batch_no_,
                                 serial_no_,
                                 eng_chg_level_,
                                 waiv_dev_rej_no_,
                                 handling_unit_id_,
                                 new_expiration_date_,
                                 delivering_warehouse_id_,
                                 receiving_warehouse_id_,
                                 activity_seq_,
                                 part_ownership_db_,
                                 owning_customer_no_,
                                 owning_vendor_no_,
                                 deliv_no_,
                                 shipment_id_,
                                 shipment_line_no_);
      newrec_ := oldrec_;

      Client_SYS.Add_To_Attr('QUANTITY',       oldrec_.quantity + destination_qty_,             attr_);
      Client_SYS.Add_To_Attr('CATCH_QUANTITY', oldrec_.catch_quantity + destination_catch_qty_, attr_);

      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
   EXCEPTION
      WHEN transit_row_deleted THEN
         Client_SYS.Add_To_Attr('DELIVERING_CONTRACT',     delivering_contract_,     attr_);
         Client_SYS.Add_To_Attr('CONTRACT',                contract_,                attr_);
         Client_SYS.Add_To_Attr('PART_NO',                 part_no_,                 attr_);
         Client_SYS.Add_To_Attr('CONFIGURATION_ID',        configuration_id_,        attr_);
         Client_SYS.Add_To_Attr('LOT_BATCH_NO',            lot_batch_no_,            attr_);
         Client_SYS.Add_To_Attr('SERIAL_NO',               serial_no_,               attr_);
         Client_SYS.Add_To_Attr('ENG_CHG_LEVEL',           eng_chg_level_,           attr_);
         Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO',         waiv_dev_rej_no_,         attr_);
         Client_SYS.Add_To_Attr('HANDLING_UNIT_ID',        handling_unit_id_,        attr_);
         Client_SYS.Add_To_Attr('EXPIRATION_DATE',         new_expiration_date_,     attr_);
         Client_SYS.Add_To_Attr('DELIVERING_WAREHOUSE_ID', delivering_warehouse_id_, attr_);
         Client_SYS.Add_To_Attr('RECEIVING_WAREHOUSE_ID',  receiving_warehouse_id_,  attr_);
         Client_SYS.Add_To_Attr('ACTIVITY_SEQ',            activity_seq_,            attr_);
         Client_SYS.Add_To_Attr('PART_OWNERSHIP_DB',       part_ownership_db_,       attr_);
         Client_SYS.Add_To_Attr('OWNING_CUSTOMER_NO',      owning_customer_no_,      attr_);
         Client_SYS.Add_To_Attr('OWNING_VENDOR_NO',        owning_vendor_no_,        attr_);
         Client_SYS.Add_To_Attr('DELIV_NO',                deliv_no_,                attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID',             shipment_id_,             attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_LINE_NO',        shipment_line_no_,        attr_);
         Client_SYS.Add_To_Attr('QUANTITY',                destination_qty_,         attr_);
         Client_SYS.Add_To_Attr('CATCH_QUANTITY',          destination_catch_qty_,   attr_);
         
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_, validate_hu_struct_position_);
   END;
   
EXCEPTION
   WHEN exit_procedure THEN
      NULL;
END Move_Into_Order_Transit;


-- Remove_From_Order_Transit
--   This method is called at the time of receiving parts in order transit
--   into the Inventory of the Demand site, in the Inter-Site Order flow.
PROCEDURE Remove_From_Order_Transit (
   delivering_contract_          IN VARCHAR2,
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   handling_unit_id_             IN NUMBER,
   expiration_date_              IN DATE, 
   delivering_warehouse_id_      IN VARCHAR2,
   receiving_warehouse_id_       IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   part_ownership_db_            IN VARCHAR2,
   owning_customer_no_           IN VARCHAR2,
   owning_vendor_no_             IN VARCHAR2,
   deliv_no_                     IN NUMBER,
   shipment_id_                  IN NUMBER,
   shipment_line_no_             IN NUMBER,
   qty_to_remove_                IN NUMBER,
   catch_qty_to_remove_          IN NUMBER,
   remove_unit_cost_             IN BOOLEAN DEFAULT TRUE,
   validate_hu_struct_position_  IN BOOLEAN DEFAULT TRUE)
IS
   oldrec_                 INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE;
   newrec_                 INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE;
   attr_                   VARCHAR2(32000);
   objid_                  INVENTORY_PART_IN_TRANSIT.objid%TYPE;
   objversion_             INVENTORY_PART_IN_TRANSIT.objversion%TYPE;
   remrec_                 INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE;
   new_expiration_date_    DATE;
   last_calendar_date_     DATE        := Database_Sys.last_calendar_date_;
   indrec_                 Indicator_Rec;
BEGIN
   IF (expiration_date_ IS NULL) THEN
      new_expiration_date_ := last_calendar_date_;
   ELSE
      new_expiration_date_ := expiration_date_;   
   END IF;

   DECLARE
      record_removed EXCEPTION;
      PRAGMA exception_init(record_removed,-20115);
   BEGIN
      oldrec_ := Lock_By_Keys___(delivering_contract_, contract_, part_no_,
                                 configuration_id_, lot_batch_no_, serial_no_,
                                 eng_chg_level_, waiv_dev_rej_no_, handling_unit_id_, new_expiration_date_,
                                 delivering_warehouse_id_, receiving_warehouse_id_,
                                 activity_seq_, part_ownership_db_, owning_customer_no_, owning_vendor_no_, 
                                 deliv_no_, shipment_id_, shipment_line_no_);
   EXCEPTION
      WHEN record_removed THEN
         Error_SYS.Record_General(lu_name_, 'NOPARTINORDERTRANS: Part No. :P1 does not exist in internal transit for Site :P2, this transaction cannot complete.', part_no_, contract_);
   END;

   IF ((oldrec_.quantity - qty_to_remove_) > 0) THEN
      newrec_     := oldrec_;
      Client_SYS.Add_To_Attr('QUANTITY', oldrec_.quantity - qty_to_remove_, attr_);
      Client_SYS.Add_To_Attr('CATCH_QUANTITY', oldrec_.catch_quantity - catch_qty_to_remove_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, validate_hu_struct_position_);
   ELSIF ((oldrec_.quantity - qty_to_remove_) = 0) THEN
      remrec_ := oldrec_;

      Get_Id_Version_By_Keys___(objid_, objversion_, delivering_contract_, contract_, part_no_,
                                configuration_id_, lot_batch_no_, serial_no_,
                                eng_chg_level_, waiv_dev_rej_no_, handling_unit_id_, new_expiration_date_,
                                delivering_warehouse_id_, receiving_warehouse_id_,
                                activity_seq_, part_ownership_db_, owning_customer_no_, owning_vendor_no_,
                                deliv_no_, shipment_id_, shipment_line_no_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
      -- Remove Inventory Part Unit Cost record if no more quantity exists on the site
      IF (((lot_batch_no_ != '*') OR (serial_no_ != '*')) AND (remove_unit_cost_)) THEN
         Inventory_Part_Unit_Cost_API.Remove(contract_,
                                             part_no_,
                                             configuration_id_,
                                             lot_batch_no_,
                                             serial_no_);
      END IF;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOTENOUGHORDERTRANS: The quantity in Internal Transit of Part No. :P1 for Site :P2 is not enough to complete this transaction.', part_no_, contract_);
   END IF;
END Remove_From_Order_Transit;


-- Get_Total_Qty_In_Order_Transit
--   Returns the Order transit quantity per Inventory Part No/Contract/
--   Configuration Id combination. catch qty if set to 'CATCH'.
@UncheckedAccess
FUNCTION Get_Total_Qty_In_Order_Transit (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   configuration_id_     IN VARCHAR2 DEFAULT NULL,
   lot_batch_no_         IN VARCHAR2 DEFAULT NULL,
   serial_no_            IN VARCHAR2 DEFAULT NULL,
   eng_chg_level_        IN VARCHAR2 DEFAULT NULL,
   waiv_dev_rej_no_      IN VARCHAR2 DEFAULT NULL,
   handling_unit_id_     IN NUMBER   DEFAULT NULL,
   expiration_date_      IN DATE     DEFAULT NULL,
   condition_code_       IN VARCHAR2 DEFAULT NULL,
   unit_of_measure_type_ IN VARCHAR2 DEFAULT 'INVENTORY' ) RETURN NUMBER
IS
   invent_qty_           INVENTORY_PART_IN_TRANSIT_TAB.quantity%TYPE;
   catch_qty_            INVENTORY_PART_IN_TRANSIT_TAB.catch_quantity%TYPE;
   qty_                  INVENTORY_PART_IN_TRANSIT_TAB.quantity%TYPE;
   
   --Use when condition code is given
   CURSOR get_attr IS
      SELECT SUM(quantity), SUM(catch_quantity)
      FROM INVENTORY_PART_IN_TRANSIT_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_   OR configuration_id_  IS NULL)
      AND   (lot_batch_no     = lot_batch_no_       OR lot_batch_no_      IS NULL)
      AND   (serial_no        = serial_no_          OR serial_no_         IS NULL)
      AND   (eng_chg_level    = eng_chg_level_      OR eng_chg_level_     IS NULL)
      AND   (waiv_dev_rej_no  = waiv_dev_rej_no_    OR waiv_dev_rej_no_   IS NULL)
      AND   (handling_unit_id = handling_unit_id_   OR handling_unit_id_  IS NULL)
      AND   (expiration_date  = expiration_date_    OR expiration_date_   IS NULL);
   --Use when condition code is not given
   CURSOR get_attr_cc IS
      SELECT quantity, catch_quantity, serial_no, lot_batch_no
      FROM INVENTORY_PART_IN_TRANSIT_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   (configuration_id = configuration_id_   OR configuration_id_  IS NULL)
      AND   (lot_batch_no     = lot_batch_no_       OR lot_batch_no_      IS NULL)
      AND   (serial_no        = serial_no_          OR serial_no_         IS NULL)
      AND   (eng_chg_level    = eng_chg_level_      OR eng_chg_level_     IS NULL)
      AND   (waiv_dev_rej_no  = waiv_dev_rej_no_    OR waiv_dev_rej_no_   IS NULL)
      AND   (handling_unit_id = handling_unit_id_   OR handling_unit_id_  IS NULL)
      AND   (expiration_date  = expiration_date_    OR expiration_date_   IS NULL);
   
   TYPE Attr_Cc_Tab IS TABLE OF get_attr_cc%ROWTYPE
      INDEX BY PLS_INTEGER;

   attr_cc_tab_ Attr_Cc_Tab;   
BEGIN
   IF (condition_code_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO invent_qty_, catch_qty_;
      CLOSE get_attr;
   ELSE
      OPEN get_attr_cc;
      FETCH get_attr_cc BULK COLLECT INTO attr_cc_tab_;
      CLOSE get_attr_cc;
      
      IF (attr_cc_tab_.COUNT > 0) THEN
         invent_qty_ := 0;
         catch_qty_  := 0;
         FOR i IN attr_cc_tab_.FIRST..attr_cc_tab_.LAST LOOP
            IF (Condition_Code_Manager_API.Get_Condition_Code(part_no_,
                                                             attr_cc_tab_(i).serial_no,
                                                             attr_cc_tab_(i).lot_batch_no) = condition_code_) THEN
               invent_qty_ := invent_qty_ + attr_cc_tab_(i).quantity;
               catch_qty_  := catch_qty_ + attr_cc_tab_(i).catch_quantity;                                                                
            END IF;
         END LOOP;
      END IF;
   END IF;

   -- if no records found.
   IF (invent_qty_ IS NULL) THEN
      invent_qty_ := 0;
      catch_qty_  := 0;
   END IF;
   
   IF unit_of_measure_type_ = 'CATCH' THEN
      qty_ := catch_qty_;   
   ELSIF unit_of_measure_type_ = 'INVENTORY' THEN
      qty_ := invent_qty_; 
   END IF;
   RETURN qty_;
END Get_Total_Qty_In_Order_Transit;


@UncheckedAccess
FUNCTION Get_Owner_Name (
   delivering_contract_     IN VARCHAR2,
   contract_                IN VARCHAR2,
   part_no_                 IN VARCHAR2,
   configuration_id_        IN VARCHAR2,
   lot_batch_no_            IN VARCHAR2,
   serial_no_               IN VARCHAR2,
   eng_chg_level_           IN VARCHAR2,
   waiv_dev_rej_no_         IN VARCHAR2,
   handling_unit_id_        IN NUMBER,
   expiration_date_         IN DATE,
   delivering_warehouse_id_ IN VARCHAR2,
   receiving_warehouse_id_  IN VARCHAR2,
   activity_seq_            IN NUMBER,
   part_ownership_db_       IN VARCHAR2,
   owning_customer_no_      IN VARCHAR2,
   owning_vendor_no_        IN VARCHAR2,
   deliv_no_                IN NUMBER,
   shipment_id_             IN NUMBER,
   shipment_line_no_        IN NUMBER ) RETURN VARCHAR2
IS
   transit_rec_   Public_Rec;
   owner_name_    VARCHAR2(100):= NULL;   
BEGIN
   transit_rec_ := Get(delivering_contract_     ,
                       contract_                ,
                       part_no_                 ,
                       configuration_id_        ,
                       lot_batch_no_            ,
                       serial_no_               ,
                       eng_chg_level_           ,
                       waiv_dev_rej_no_         ,
                       handling_unit_id_        ,
                       expiration_date_         ,
                       delivering_warehouse_id_ ,
                       receiving_warehouse_id_  ,
                       activity_seq_            ,
                       part_ownership_db_       ,
                       owning_customer_no_      ,
                       owning_vendor_no_        ,
                       deliv_no_                ,
                       shipment_id_             ,
                       shipment_line_no_        ); 
   
   IF (transit_rec_.owning_customer_no != '*') THEN
      $IF Component_Order_SYS.INSTALLED $THEN      
         owner_name_ := Cust_Ord_Customer_API.Get_Name(transit_rec_.owning_customer_no);
      $ELSE
         NULL;
      $END
   ELSIF (transit_rec_.owning_vendor_no != '*') THEN
      $IF Component_Purch_SYS.INSTALLED $THEN      
         owner_name_ := Supplier_API.Get_Vendor_Name(transit_rec_.owning_vendor_no);
      $ELSE
         NULL;
      $END
   END IF; 
   
   RETURN (owner_name_);
END Get_Owner_Name;


@UncheckedAccess
FUNCTION Get_Total_Qty_In_Order_Trans(
   contract_         IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2 ) RETURN Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab
IS
   CURSOR get_transit_qty IS
      SELECT ipit.configuration_id                configuration_id,
             ipit.lot_batch_no                    lot_batch_no,
             ipit.serial_no                       serial_no,
             SUM(ipit.quantity)                   sum_quantity
      FROM   INVENTORY_PART_IN_TRANSIT_TAB ipit
      WHERE ipit.contract          = contract_
        AND ipit.part_no           = part_no_
        AND (ipit.configuration_id = configuration_id_ OR configuration_id_ IS NULL)
        AND ipit.quantity!         = 0
      GROUP BY ipit.configuration_id, ipit.lot_batch_no, ipit.serial_no;
   
      transit_tab_ Inventory_Part_In_Stock_API.Config_Lot_Serial_Tab; 
BEGIN
   OPEN get_transit_qty;
   FETCH get_transit_qty  BULK COLLECT INTO transit_tab_;
   CLOSE get_transit_qty;

   RETURN (transit_tab_);
END Get_Total_Qty_In_Order_Trans;


-- Unreceive_Part_To_Transit
--   This method is used to return parts back to transit i.e. update
--   the Transit Object when a Internal PO Receipt is cancelled.
PROCEDURE Unreceive_Part_To_Transit (
   delivering_contract_          IN VARCHAR2,
   contract_                     IN VARCHAR2,
   part_no_                      IN VARCHAR2,
   configuration_id_             IN VARCHAR2,
   lot_batch_no_                 IN VARCHAR2,
   serial_no_                    IN VARCHAR2,
   eng_chg_level_                IN VARCHAR2,
   waiv_dev_rej_no_              IN VARCHAR2,
   handling_unit_id_             IN NUMBER,
   expiration_date_              IN DATE,
   delivering_warehouse_id_      IN VARCHAR2,
   receiving_warehouse_id_       IN VARCHAR2,
   activity_seq_                 IN NUMBER,
   part_ownership_db_            IN VARCHAR2,
   owning_customer_no_           IN VARCHAR2,
   owning_vendor_no_             IN VARCHAR2,
   deliv_no_                     IN NUMBER,
   shipment_id_                  IN NUMBER,
   shipment_line_no_             IN NUMBER,
   qty_to_unreceive_             IN NUMBER,
   catch_qty_to_unreceive_       IN NUMBER,
   validate_hu_struct_position_  IN BOOLEAN DEFAULT TRUE )
IS
   oldrec_                 INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE;
   newrec_                 INVENTORY_PART_IN_TRANSIT_TAB%ROWTYPE;
   attr_                   VARCHAR2(32000);
   objid_                  INVENTORY_PART_IN_TRANSIT.objid%TYPE;
   objversion_             INVENTORY_PART_IN_TRANSIT.objversion%TYPE;
   new_expiration_date_    DATE;
   last_calendar_date_     DATE        := Database_Sys.last_calendar_date_;
   indrec_                 Indicator_Rec;
BEGIN
   IF (expiration_date_ IS NULL) THEN
      new_expiration_date_ := last_calendar_date_;
   ELSE
      new_expiration_date_ := expiration_date_;   
   END IF;

   DECLARE
      transit_row_deleted EXCEPTION;
      PRAGMA              exception_init(transit_row_deleted, -20115);
   BEGIN
      oldrec_ := Lock_By_Keys___(delivering_contract_, contract_, part_no_,
                                 configuration_id_, lot_batch_no_, serial_no_,
                                 eng_chg_level_, waiv_dev_rej_no_, handling_unit_id_, new_expiration_date_,
                                 delivering_warehouse_id_, receiving_warehouse_id_,
                                 activity_seq_, part_ownership_db_, owning_customer_no_, owning_vendor_no_, 
                                 deliv_no_, shipment_id_, shipment_line_no_);
      newrec_ := oldrec_;

      Client_SYS.Add_To_Attr('QUANTITY', oldrec_.quantity + qty_to_unreceive_, attr_);
      Client_SYS.Add_To_Attr('CATCH_QUANTITY', oldrec_.catch_quantity + catch_qty_to_unreceive_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE, validate_hu_struct_position_); -- Update by keys
   EXCEPTION
      WHEN transit_row_deleted THEN
         newrec_ := NULL;
         Client_SYS.Add_To_Attr('DELIVERING_CONTRACT',     delivering_contract_,     attr_);
         Client_SYS.Add_To_Attr('CONTRACT',                contract_,                attr_);
         Client_SYS.Add_To_Attr('PART_NO',                 part_no_,                 attr_);
         Client_SYS.Add_To_Attr('CONFIGURATION_ID',        configuration_id_,        attr_);
         Client_SYS.Add_To_Attr('LOT_BATCH_NO',            lot_batch_no_,            attr_);
         Client_SYS.Add_To_Attr('SERIAL_NO',               serial_no_,               attr_);
         Client_SYS.Add_To_Attr('ENG_CHG_LEVEL',           eng_chg_level_,           attr_);
         Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO',         waiv_dev_rej_no_,         attr_);
         Client_SYS.Add_To_Attr('HANDLING_UNIT_ID',        handling_unit_id_,        attr_);
         Client_SYS.Add_To_Attr('EXPIRATION_DATE',         new_expiration_date_,     attr_);
         Client_SYS.Add_To_Attr('DELIVERING_WAREHOUSE_ID', delivering_warehouse_id_, attr_);
         Client_SYS.Add_To_Attr('RECEIVING_WAREHOUSE_ID',  receiving_warehouse_id_,  attr_);
         Client_SYS.Add_To_Attr('ACTIVITY_SEQ',            activity_seq_,            attr_);
         Client_SYS.Add_To_Attr('PART_OWNERSHIP_DB',       part_ownership_db_,       attr_);
         Client_SYS.Add_To_Attr('OWNING_CUSTOMER_NO',      owning_customer_no_,      attr_);
         Client_SYS.Add_To_Attr('OWNING_VENDOR_NO',        owning_vendor_no_,        attr_);
         Client_SYS.Add_To_Attr('DELIV_NO',                deliv_no_,                attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_ID',             shipment_id_,             attr_);
         Client_SYS.Add_To_Attr('SHIPMENT_LINE_NO',        shipment_line_no_,        attr_);
         Client_SYS.Add_To_Attr('QUANTITY',                qty_to_unreceive_,        attr_);
         Client_SYS.Add_To_Attr('CATCH_QUANTITY',          catch_qty_to_unreceive_,  attr_);
         Unpack___(newrec_, indrec_, attr_);
         Check_Insert___(newrec_, indrec_, attr_);
         Insert___(objid_, objversion_, newrec_, attr_, validate_hu_struct_position_);
   END;
END Unreceive_Part_To_Transit;


@UncheckedAccess
FUNCTION Check_Part_Exist (
   contract_ IN VARCHAR2,
   part_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM INVENTORY_PART_IN_TRANSIT_TAB
      WHERE contract = contract_
      AND   part_no = part_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%FOUND THEN
      CLOSE get_attr;
      RETURN db_true_;
   ELSE
      CLOSE get_attr;
      RETURN db_false_;
   END IF;
END Check_Part_Exist;


@UncheckedAccess
FUNCTION Check_Individual_Exist (
   part_no_   IN VARCHAR2,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ NUMBER;
   CURSOR get_attr IS
      SELECT 1
      FROM INVENTORY_PART_IN_TRANSIT_TAB
      WHERE part_no = part_no_
        AND serial_no = serial_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   IF get_attr%FOUND THEN
      CLOSE get_attr;
      RETURN db_true_;
   ELSE
      CLOSE get_attr;
      RETURN db_false_;
   END IF;
END Check_Individual_Exist;


@UncheckedAccess
FUNCTION Check_Lot_Batch_Exist (
   part_no_      IN VARCHAR2,
   lot_batch_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR check_part_loc IS
    SELECT 1
    FROM INVENTORY_PART_IN_TRANSIT_TAB
    WHERE part_no      = part_no_
      AND lot_batch_no = lot_batch_no_
      AND quantity    != 0;

   exist_   NUMBER;
BEGIN
   OPEN check_part_loc;
   FETCH check_part_loc INTO exist_;
   IF check_part_loc%NOTFOUND THEN
      exist_ := 0;
   END IF;
   CLOSE check_part_loc;
   RETURN(exist_);
END Check_Lot_Batch_Exist;


-- Quantity_Without_Catch_Exist
--   Checks whether a transit quantity exists for a given part.
@UncheckedAccess
FUNCTION Quantity_Without_Catch_Exist (
   part_no_          IN VARCHAR2,
   contract_         IN VARCHAR2 DEFAULT NULL,
   configuration_id_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   qty_found_ VARCHAR2(5):= db_false_;
   CURSOR check_exist IS
      SELECT 1
      FROM   INVENTORY_PART_IN_TRANSIT_TAB
      WHERE  quantity        != 0
      AND  catch_quantity IS NULL
      AND  part_no           = part_no_
      AND  (contract         = contract_         OR contract_         IS NULL)
      AND  (configuration_id = configuration_id_ OR configuration_id_ IS NULL);
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF (check_exist%FOUND) THEN
      qty_found_ := db_true_;
   END IF;
   CLOSE check_exist;
   RETURN qty_found_;
END Quantity_Without_Catch_Exist;


FUNCTION Handling_Unit_Exists (
   handling_unit_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_   NUMBER;
   handling_unit_exist_ BOOLEAN := FALSE;
   
   CURSOR chec_exist IS
      SELECT 1
        FROM INVENTORY_PART_IN_TRANSIT_TAB
       WHERE handling_unit_id IN (SELECT handling_unit_id
                                    FROM handling_unit_tab hu
                                 CONNECT BY PRIOR hu.handling_unit_id = parent_handling_unit_id
                                   START WITH     hu.handling_unit_id = handling_unit_id_);
BEGIN
   OPEN chec_exist;
   FETCH chec_exist INTO dummy_;
   IF (chec_exist%FOUND) THEN
      handling_unit_exist_ := TRUE;
   END IF;
   
   RETURN handling_unit_exist_;
END Handling_Unit_Exists;


-- Quantity_Exists
--   Returns TRUE if there are records with quantity not equal to
--   zero for records having the specified serial_tracking option.
--   Otherwise returns FALSE.
@UncheckedAccess
FUNCTION Quantity_Exists (
   part_no_        IN VARCHAR2,
   serial_tracked_ IN BOOLEAN ) RETURN BOOLEAN
IS
   dummy_               NUMBER;
   quantity_exists_     BOOLEAN     := FALSE;
   serial_tracked_char_ VARCHAR2(5) := db_false_;

   CURSOR exist_control IS
      SELECT 1
      FROM INVENTORY_PART_IN_TRANSIT_TAB
      WHERE ((serial_no != '*' AND serial_tracked_char_ = db_true_) OR
             (serial_no  = '*' AND serial_tracked_char_ = db_false_))
      AND part_no = part_no_
      AND quantity != 0;
BEGIN
   IF (serial_tracked_) THEN
      serial_tracked_char_ := db_true_;
   END IF;

   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      quantity_exists_ := TRUE;
   END IF;
   CLOSE exist_control;

   RETURN(quantity_exists_);
END Quantity_Exists;


PROCEDURE Modify_Lot_Expiration_Date (
   part_no_             IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   new_expiration_date_ IN DATE )
IS
   CURSOR get_rec IS
      SELECT *
        FROM INVENTORY_PART_IN_TRANSIT_TAB
       WHERE part_no      = part_no_
         AND lot_batch_no = lot_batch_no_;
BEGIN

   FOR oldrec_ IN get_rec LOOP
      Remove_From_Order_Transit(oldrec_.delivering_contract, 
                                oldrec_.contract,
                                oldrec_.part_no,
                                oldrec_.configuration_id,
                                oldrec_.lot_batch_no,
                                oldrec_.serial_no,
                                oldrec_.eng_chg_level,
                                oldrec_.waiv_dev_rej_no,
                                oldrec_.handling_unit_id,
                                oldrec_.expiration_date,
                                oldrec_.delivering_warehouse_id,
                                oldrec_.receiving_warehouse_id,
                                oldrec_.activity_seq,
                                oldrec_.part_ownership,
                                oldrec_.owning_customer_no, 
                                oldrec_.owning_vendor_no, 
                                oldrec_.deliv_no, 
                                oldrec_.shipment_id,
                                oldrec_.shipment_line_no,
                                oldrec_.quantity,
                                oldrec_.catch_quantity,
                                FALSE);
      
      Unreceive_Part_To_Transit(oldrec_.delivering_contract,
                                oldrec_.contract,
                                oldrec_.part_no,
                                oldrec_.configuration_id,
                                oldrec_.lot_batch_no,
                                oldrec_.serial_no,
                                oldrec_.eng_chg_level,
                                oldrec_.waiv_dev_rej_no,
                                oldrec_.handling_unit_id,
                                new_expiration_date_,
                                oldrec_.delivering_warehouse_id,
                                oldrec_.receiving_warehouse_id,
                                oldrec_.activity_seq,
                                oldrec_.part_ownership,
                                oldrec_.owning_customer_no, 
                                oldrec_.owning_vendor_no, 
                                oldrec_.deliv_no, 
                                oldrec_.shipment_id,
                                oldrec_.shipment_line_no,
                                oldrec_.quantity,
                                oldrec_.catch_quantity);
   END LOOP;
END Modify_Lot_Expiration_Date;


@UncheckedAccess
FUNCTION Get_Lot_Batch_Track_Status (
   part_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_         NUMBER;
   default_value_ BOOLEAN := FALSE;
   other_value_   BOOLEAN := FALSE;
   return_string_ VARCHAR2(20);

   CURSOR get_defaults_in_transit IS
      SELECT 1
        FROM INVENTORY_PART_IN_TRANSIT_TAB
       WHERE lot_batch_no = '*'
         AND part_no = part_no_
         AND quantity != 0;

   CURSOR get_not_defaults_in_transit IS
      SELECT 1
        FROM INVENTORY_PART_IN_TRANSIT_TAB
       WHERE lot_batch_no != '*'
         AND part_no = part_no_
         AND quantity != 0;
BEGIN
   OPEN get_defaults_in_transit;
   FETCH get_defaults_in_transit INTO dummy_;
   IF get_defaults_in_transit%FOUND THEN
      default_value_ := TRUE;
   END IF;
   CLOSE get_defaults_in_transit;

   OPEN get_not_defaults_in_transit;
   FETCH get_not_defaults_in_transit INTO dummy_;
   IF get_not_defaults_in_transit%FOUND THEN
      other_value_ := TRUE;
   END IF;
   CLOSE get_not_defaults_in_transit;

   IF other_value_ AND NOT default_value_ THEN
      return_string_ := 'LOT TRACKING';
   ELSIF default_value_ AND NOT other_value_ THEN
      return_string_ := 'NOT LOT TRACKING';
   ELSIF default_value_ AND other_value_ THEN
      return_string_ := 'BOTH';
   ELSIF NOT default_value_ AND NOT other_value_ THEN
      return_string_ := NULL;
   END IF;
   RETURN return_string_;
END Get_Lot_Batch_Track_Status;


@UncheckedAccess
FUNCTION Get_Handling_Unit_Row_Count (
   handling_unit_id_  IN  NUMBER)  RETURN NUMBER
IS
   row_count_ NUMBER;
   CURSOR get_row_count IS
      SELECT count(*)
      FROM   inventory_part_in_transit_tab
      WHERE  handling_unit_id = handling_unit_id_;
BEGIN
   OPEN get_row_count;
   FETCH get_row_count INTO row_count_;
   CLOSE get_row_count;
   
   RETURN row_count_;
END Get_Handling_Unit_Row_Count;


@UncheckedAccess
FUNCTION Get_Serial_Destination_Site (
   part_no_   IN VARCHAR2 ,
   serial_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   destination_site_      inventory_part_in_transit_tab.contract%TYPE;
   
   CURSOR get_serial_destination_site IS
      SELECT contract
      FROM  inventory_part_in_transit_tab
      WHERE part_no   = part_no_
      AND   serial_no = serial_no_      
      AND   quantity != 0;
BEGIN
   IF (serial_no_ != '*') THEN   
      OPEN  get_serial_destination_site;
      FETCH get_serial_destination_site INTO destination_site_;   
      CLOSE get_serial_destination_site;
   END IF;
   RETURN destination_site_;
END Get_Serial_Destination_Site;
