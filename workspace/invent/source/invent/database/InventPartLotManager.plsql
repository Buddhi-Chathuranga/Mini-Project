-----------------------------------------------------------------------------
--
--  Logical unit: InventPartLotManager
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130904  ThImlk  Bug 109778, Modified Check_Lot_Track_Change() to avoid 
--  130904          allowing negative quantity on-hand for tracked parts.
--  130604  Asawlk  EBALL-37, Modified Check_Lot_Track_Change() by using 
--  130604          Invent_Part_Quantity_Util_API.Get_Lot_Batch_Track_Status(). 
--  130516  Asawlk  EBALL-37, Modified Modify_Expiration_Date() by adding a call to 
--  130516          Inventory_Part_At_Customer_API.Modify_Lot_Expiration_Date().
--  120907  IsSalk  Bug 102558, Added function Handle_Lot_Tracking_Change() to give an
--  120907          information message when changing lot tracking of a particular part.
--  110819  NiBalk  Bug 97297, Added method Modify_Expiration_Date(). 
--  101029  LEPESE  Added parameter receipt_issue_serial_track_db_ to Check_Lot_Track_Change. 
--  ---------------------------- Best Price  --------------------------------
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  030227  SHVESE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Lot_Track_Change
--   To check if its allowed to update configurable flag.
--   This method is used for validating modifications of lot tracking code in
--   LU PartCatalog. This method only perform checks against Invent.
PROCEDURE Check_Lot_Track_Change (
   part_no_                       IN VARCHAR2,
   configurable_db_               IN VARCHAR2,
   condition_code_usage_db_       IN VARCHAR2,
   lot_tracking_code_db_          IN VARCHAR2,
   serial_tracking_code_db_       IN VARCHAR2,
   receipt_issue_serial_track_db_ IN VARCHAR2 )
IS
   lot_state_ VARCHAR2(30);
   CURSOR get_rec IS
      SELECT *
      FROM inventory_part_pub
      WHERE part_no = part_no_;
BEGIN
   -- EBALL-37, Modified call to use Invent_Part_Quantity_Util_API.
   lot_state_ := Invent_Part_Quantity_Util_API.Get_Lot_Batch_Track_Status(part_no_);

   IF (lot_state_ IS NULL) THEN
      NULL;
   ELSIF (lot_tracking_code_db_ = lot_state_) THEN
      NULL;
   ELSIF ((lot_tracking_code_db_ = Part_Lot_Tracking_API.DB_ORDER_BASED) AND
          (lot_state_            = Part_Lot_Tracking_API.DB_LOT_TRACKING)) THEN
      NULL;
   ELSE
      Error_SYS.Record_General('InventPartLotManager', 'NOLOTTRACKING: The part exists in inventory with :P1',
                                Part_Lot_Tracking_API.Decode(lot_state_));
   END IF;

   --Loop over all sites where inventory part exist
   FOR part_rec IN get_rec LOOP
       Inventory_Part_API.Check_Value_Method_Combination(part_rec.contract,
                                                        part_no_,
                                                        configurable_db_,
                                                        condition_code_usage_db_,
                                                        lot_tracking_code_db_,
                                                        serial_tracking_code_db_,
                                                        receipt_issue_serial_track_db_);
       Inventory_Part_API.Check_Negative_On_Hand(part_rec.negative_on_hand_db,
                                                 'FALSE',
                                                 receipt_issue_serial_track_db_,
                                                 lot_tracking_code_db_);
   END LOOP;
END Check_Lot_Track_Change;


PROCEDURE Modify_Expiration_Date (
   part_no_             IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   new_expiration_date_ IN DATE )
IS
BEGIN

   Inventory_Part_In_Stock_API.Modify_Exp_Date_By_Lot_No(part_no_, lot_batch_no_, new_expiration_date_);
   Inventory_Part_In_Transit_API.Modify_Lot_Expiration_Date(part_no_, lot_batch_no_, new_expiration_date_);
   Inventory_Part_At_Customer_API.Modify_Lot_Expiration_Date(part_no_, lot_batch_no_, new_expiration_date_);
END Modify_Expiration_Date;


-- Handle_Lot_Tracking_Change
--   Checks for the existence of any inventory transaction for a considered
--   part. If found then raise an information message.
PROCEDURE Handle_Lot_Tracking_Change (
   part_no_   IN VARCHAR2 )
IS
   CURSOR get_contract IS
      SELECT contract
      FROM   inventory_part_tab
      WHERE  part_no = part_no_;
      
   part_has_transaction_ VARCHAR2(5) := 'FALSE' ;
   contract_    VARCHAR2(5);
BEGIN
   FOR rec_ IN get_contract LOOP
      part_has_transaction_ := Inventory_Transaction_Hist_API.Check_Part_Exist(rec_.contract,
                                                                               part_no_,
                                                                               NULL);
      contract_ := rec_.contract;
      EXIT WHEN part_has_transaction_ = 'TRUE';                                                               
   END LOOP;
   IF (part_has_transaction_ = 'TRUE') THEN
      Client_SYS.Add_Info(lu_name_, 'ISSUESCANNOTREVERSE: The part :P1 is already used in inventory transactions in site :P2. An issue made previously can only be reversed if the lot-tracking setting (i.e., Tracked/Not Tracked) on the part remains the same as when the issue was made.', part_no_, contract_);
   END IF;
END Handle_Lot_Tracking_Change;



