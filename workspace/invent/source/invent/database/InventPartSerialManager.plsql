-----------------------------------------------------------------------------
--
--  Logical unit: InventPartSerialManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200616  LEPESE  SC2021R1-294, Added consideration to Work Task transaction codes WTISS and WTREPISS IN Check_Rename.
--  171013  RaNhlk  CAM-1137, Modified Check_Rename to add "SUNREC" to the latest_transaction_code_ check.
--  151029  JeLise  LIM-4351, Removed call to Inventory_Part_API.Check_Pallet_Part_Exist in Check_Serial_Track_Change.
--  130904  ThImlk  Bug 109778, Modified Check_Serial_Track_Change() to avoid 
--  130904          allowing negative quantity on-hand for tracked parts.
--  130516  Asawlk  EBALL-37, Modified Check_Serial_Track_Change() to include quantities at customer when
--  130516          checking for serial tracking change. 
--  120907  IsSalk  Bug 102558, Modified function Handle_Enable_Serial_Tracking in order to give an 
--  120907          information message when setting serial tracking for a particular part.
--  110615  LEPESE  Modification in Check_Rename to fetch contract via PartSerialHistory.
--  110329  LEPESE  Modifications in Check_Serial_Track_Change to correct the validations. Added parameters
--  110329          old_serial_tracking_code_db_ and old_rece_iss_serial_track_db_.
--  110220  LEPESE  Added error message ROTABLEPOOL.
--  101123  LEPESE  Modification in Check_Serial_Track_Change to raise error message if pallet handled part is
--  101123          configured for "Receipt and Issue" serial tracking without "In Inventory serial" tracking.
--  101028  LEPESE  Complete redesign of Check_Serial_Track_Change because of new parameter receipt_issue_serial_track_db_.
--  100609  UdGnlk  Modified Check_Rename() inorder to support transcation code 'WOREPISS'.
--  100505  KRPELK  Merge Rose Method Documentation.
-------------------------------------14.0.0 ---------------------------------
--  091030  ShKolk  Bug 86768, Merge IPR to APP75 core.
--  070709  RoJalk  Bug 65378, Added method Handle_Enable_Serial_Tracking to handle
--  070709          enabling of serial tracking.
--------------------------- Wings Merge End ---------------------------------
--  070326  KaDilk  Made changes to Check_Raname for supplier invoice consideration.
--  070320  KaDilk  Modified Check_Raname added a check for supplier invoice consideration.
--  070129  Dinklk  Merged Wings code.
--  070126  DAYJLK  Modified Check_Rename by changing the validations.
--  070118  DAYJLK  Added method Check_Rename and removed method Rename_Allowed_On_Issued.
--  061212  DAYJLK  Added procedure Rename_Allowed_On_Issued
--------------------------- Wings Merge Start -------------------------------
--  061208  DaZase  Added call to Inventory_Part_API.Check_Serial_Conv_Factor
--  030227  SHVESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_serial_tracking_     CONSTANT VARCHAR2(15) := Part_Serial_Tracking_API.db_serial_tracking;
db_not_serial_tracking_ CONSTANT VARCHAR2(19) := Part_Serial_Tracking_API.db_not_serial_tracking;
db_true_                CONSTANT VARCHAR2(4)  := Fnd_Boolean_API.db_true;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Serial_Track_Change
--   To check if its allowed to update serial tracking flag.
--   This method is used for validating modifications of serial tracking code
--   in LU PartCatalog. This method only perform checks against Invent.
PROCEDURE Check_Serial_Track_Change (
   part_no_                       IN VARCHAR2,
   configurable_db_               IN VARCHAR2,
   condition_code_usage_db_       IN VARCHAR2,
   lot_tracking_code_db_          IN VARCHAR2,
   old_serial_tracking_code_db_   IN VARCHAR2,
   old_rece_iss_serial_track_db_  IN VARCHAR2,
   new_serial_tracking_code_db_   IN VARCHAR2,
   new_rece_iss_serial_track_db_  IN VARCHAR2 )
IS
   CURSOR get_rec IS
      SELECT *
      FROM inventory_part_pub
      WHERE part_no = part_no_;
BEGIN
   IF (old_serial_tracking_code_db_    = db_serial_tracking_) THEN
      IF (new_serial_tracking_code_db_ = db_not_serial_tracking_) THEN
         -- In Inventory Serial Tracking is being disabled
         IF (Rotable_Part_Pool_API.Part_Exists(part_no_)) THEN
            Error_SYS.Record_General('InventPartSerialManager', 'ROTABLEPOOL: The part is connected to a rotable pool and must stay as Serial Tracked In Inventory.');
         END IF;
      END IF;
   ELSE
      IF (new_serial_tracking_code_db_ = db_serial_tracking_) THEN
         -- In Inventory Serial Tracking is being enabled
         IF (Inventory_Part_In_Stock_API.Quantity_Exists(part_no_        => part_no_,
                                                         serial_tracked_ => FALSE)) THEN
            Error_SYS.Record_General('InventPartSerialManager', 'NONSERIALSTOCK: There are quantities in stock without specified serial numbers.');
         END IF;
         IF (Inventory_Part_In_Transit_API.Quantity_Exists(part_no_        => part_no_,
                                                           serial_tracked_ => FALSE)) THEN
            Error_SYS.Record_General('InventPartSerialManager', 'NONSERIALTRANSIT: There are quantities in transit without specified serial numbers.');
         END IF;
         IF (Inventory_Part_At_Customer_API.Quantity_Exists(part_no_        => part_no_,
                                                            serial_tracked_ => FALSE)) THEN
            Error_SYS.Record_General('InventPartSerialManager', 'NONSERIALATCUSTOMER: There are quantities at customer without specified serial numbers.');
         END IF;
      END IF;
   END IF;

   IF (old_rece_iss_serial_track_db_ != new_rece_iss_serial_track_db_) THEN
         -- Receipt and Issue Serial Tracking is being changed
      IF ((Inventory_Part_In_Stock_API.Quantity_Exists  (part_no_        => part_no_,
                                                         serial_tracked_ => TRUE)) OR
          (Inventory_Part_In_Stock_API.Quantity_Exists  (part_no_        => part_no_,
                                                         serial_tracked_ => FALSE))) THEN
         Error_SYS.Record_General('InventPartSerialManager', 'QTYINSTOCK: Receipt and Issue Serial Tracking cannot be changed when there are quantities in stock.');
      END IF;
      IF ((Inventory_Part_In_Transit_API.Quantity_Exists(part_no_        => part_no_,
                                                         serial_tracked_ => TRUE)) OR
          (Inventory_Part_In_Transit_API.Quantity_Exists(part_no_        => part_no_,
                                                         serial_tracked_ => FALSE))) THEN
         Error_SYS.Record_General('InventPartSerialManager', 'QTYINTRANSIT: Receipt and Issue Serial Tracking cannot be changed when there are quantities in transit.');
      END IF;
      IF ((Inventory_Part_At_Customer_API.Quantity_Exists(part_no_        => part_no_,
                                                          serial_tracked_ => TRUE)) OR
          (Inventory_Part_At_Customer_API.Quantity_Exists(part_no_        => part_no_,
                                                          serial_tracked_ => FALSE))) THEN
         Error_SYS.Record_General('InventPartSerialManager', 'QTYATCUSTOMER: Receipt and Issue Serial Tracking cannot be changed when there are quantities at customer.');
      END IF;
      IF (new_rece_iss_serial_track_db_ = db_true_) THEN
         -- Receipt and Issue Serial Tracking is being enabled
         IF (Inventory_Part_API.Unit_Meas_Different_On_Sites(part_no_)) THEN
            -- The part must have the same U/M on all sites, or at least U/M that has conversion factor 1 between them.
            Error_SYS.Record_General(lu_name_, 'CONVFACTOR: A part that has different U/M in different sites cannot be serial tracked.');
         END IF;
      END IF;
   END IF;

   --Loop over all sites where inventory part exist
   FOR part_rec IN get_rec LOOP
       Inventory_Part_API.Check_Value_Method_Combination(part_rec.contract,
                                                         part_no_,
                                                         configurable_db_,
                                                         condition_code_usage_db_,
                                                         lot_tracking_code_db_,
                                                         new_serial_tracking_code_db_,
                                                         new_rece_iss_serial_track_db_);
       Inventory_Part_API.Check_Negative_On_Hand(part_rec.negative_on_hand_db,
                                                 'FALSE',
                                                 new_rece_iss_serial_track_db_,
                                                 lot_tracking_code_db_);
   END LOOP;
END Check_Serial_Track_Change;


-- Check_Rename
--   Purpose: Validates Inventory related conditions needed for Rename Serial
PROCEDURE Check_Rename (
   part_no_       IN VARCHAR2,
   serial_no_     IN VARCHAR2,
   new_part_no_   IN VARCHAR2,
   new_serial_no_ IN VARCHAR2     )
IS
   serial_issued_                BOOLEAN := FALSE;
   issued_part_no_               VARCHAR2(25);
   issued_serial_no_             VARCHAR2(50);
   top_parent_                   BOOLEAN := FALSE;
   top_parent_part_no_           VARCHAR2(25);
   top_parent_serial_no_         VARCHAR2(50);
   latest_inv_transaction_id_    NUMBER;
   latest_transaction_code_      VARCHAR2(10);
   serial_state_db_              VARCHAR2(30);
   top_parent_state_db_          VARCHAR2(30);

   contract_                     VARCHAR2(5);
   status_rec_                   Inventory_Part_Status_Par_API.Public_Rec;
   inv_part_rec_                 Inventory_Part_API.Public_Rec;
   new_inv_part_rec_             Inventory_Part_API.Public_Rec;
BEGIN
   Serial_No_Reservation_API.Check_Part_Serial_Exist(new_part_no_,
                                                     new_serial_no_);

   serial_state_db_ := Part_Serial_Catalog_API.Get_Objstate(part_no_, serial_no_);

   IF (serial_state_db_ = 'InInventory') THEN

      latest_inv_transaction_id_ := Part_Serial_History_API.Get_Latest_Inv_Transaction_Id(part_no_, serial_no_);
      contract_                  := Inventory_Transaction_Hist_API.Get_Transaction_Contract(latest_inv_transaction_id_);
      IF (contract_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_,'CRPASECAT: Inconsistency between Inventory and Part Serial Catalog. Contact System Support.');
      END IF;

      Inventory_Part_API.Exist(contract_, new_part_no_);

      IF (part_no_ != new_part_no_) THEN
         inv_part_rec_     :=   Inventory_Part_API.Get(contract_, part_no_);
         new_inv_part_rec_ :=   Inventory_Part_API.Get(contract_, new_part_no_);

         IF (inv_part_rec_.invoice_consideration ='PERIODIC WEIGHTED AVERAGE') THEN
            Error_SYS.Record_General(lu_name_,'CRINVCON: Inventory part :P1 has supplier invoice consideration Periodic Weighted Average, rename not allowed.', part_no_);
         END IF;
         IF (new_inv_part_rec_.invoice_consideration='PERIODIC WEIGHTED AVERAGE') THEN
            Error_SYS.Record_General(lu_name_,'CRINVCON: Inventory part :P1 has supplier invoice consideration Periodic Weighted Average, rename not allowed.', new_part_no_);
         END IF;
         IF inv_part_rec_.zero_cost_flag != new_inv_part_rec_.zero_cost_flag THEN
            Error_SYS.Record_General(lu_name_, 'CRZEROCOSDIF: Zero Cost Flag is not the same in Inventory parts :P1 and :P2 in Site :P3, rename not allowed.', part_no_, new_part_no_, contract_);
         END IF;

         status_rec_ := Inventory_Part_Status_Par_API.Get(new_inv_part_rec_.part_status);
         IF (status_rec_.onhand_flag = 'N') THEN
            Error_SYS.Record_General(lu_name_, 'SITENOTONHAND: Inventory part :P1 on site :P2 has part status :P3 which does not allow quantity on hand', new_part_no_,contract_,Inventory_Part_Status_Par_API.Get_Description(new_inv_part_rec_.part_status));
         END IF;
      END IF;
   ELSIF (serial_state_db_ = 'Issued') THEN
      serial_issued_    := TRUE;
      issued_part_no_   := part_no_;
      issued_serial_no_ := serial_no_;
   ELSIF (serial_state_db_ = 'Contained') THEN
      Part_Serial_Catalog_API.Get_Top_Parent(top_parent_part_no_,
                                             top_parent_serial_no_,
                                             part_no_,
                                             serial_no_);

      top_parent_state_db_ := Part_Serial_Catalog_API.Get_Objstate(top_parent_part_no_,top_parent_serial_no_);

      IF (top_parent_state_db_ ='Issued') THEN
         top_parent_ := TRUE;
         serial_issued_    := TRUE;
         issued_part_no_   := top_parent_part_no_;
         issued_serial_no_ := top_parent_serial_no_;
      END IF;
   END IF;

   IF (serial_issued_) THEN
      latest_inv_transaction_id_ := Part_Serial_History_API.Get_Latest_Inv_Transaction_Id(
                                                                          issued_part_no_,
                                                                          issued_serial_no_);

      latest_transaction_code_ := Inventory_Transaction_Hist_API.Get_Transaction_Code(latest_inv_transaction_id_);

      IF latest_transaction_code_ NOT IN ('NISS', 'WOISS', 'WOREPISS', 'WTISS', 'WTREPISS', 'BACFLUSH', 'SOISS', 'SUNREC') THEN
            IF top_parent_ THEN
               Error_SYS.Record_General(lu_name_, 'CRTOPISSUE: Serial <:P1> is contained in serial <:P2> which has been Issued. Renamed is allowed only when the parent serial is issued as a non-order Inventory Issue, or on a Work Task or Shop order.', part_no_||','||serial_no_, top_parent_part_no_||','||top_parent_serial_no_);
            ELSE
               Error_SYS.Record_General(lu_name_, 'CRPARTISSUE: Serial <:P1> has been Issued. Rename is allowed only when a serial is issued as a non-order Inventory Issue, or on a Work Task or Shop order.', part_no_||','||serial_no_);
            END IF;
      END IF;
   END IF;
END Check_Rename;


-- Handle_Enable_Serial_Tracking
--   Handles enabling of serial tracking for a part.
PROCEDURE Handle_Enable_Serial_Tracking (
   part_no_ IN VARCHAR2 )
IS
   CURSOR get_contract IS
      SELECT contract
      FROM   inventory_part_tab
      WHERE  part_no = part_no_;
      
   part_has_transaction_ VARCHAR2(5) := 'FALSE';
   contract_             VARCHAR2(5);
BEGIN
   FOR rec_ IN get_contract LOOP
      Inventory_Part_API.Modify_Qty_Calc_Rounding(rec_.contract,
                                                  part_no_,
                                                  0);
      IF (part_has_transaction_ = 'FALSE') THEN
         part_has_transaction_ := Inventory_Transaction_Hist_API.Check_Part_Exist(rec_.contract,
                                                                                  part_no_,
                                                                                  NULL);
         contract_ := rec_.contract;                                               
      END IF;
   END LOOP;
   
   IF (part_has_transaction_ = 'TRUE') THEN
      Client_SYS.Add_Info(lu_name_, 'USEDINISSUESASNONSERIAL: The part :P1 is already used in inventory transactions in site :P2. Issues made previously cannot be reversed after enabling serial-tracking.', part_no_, contract_);
   END IF;
END Handle_Enable_Serial_Tracking;

