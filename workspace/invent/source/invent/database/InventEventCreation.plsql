-----------------------------------------------------------------------------
--
--  Logical unit: InventEventCreation
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150413  JeLise  Added handling_unit_id_ in calls to Inventory_Part_In_Stock_API.
--  100511  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090810  HoInlk  Bug 83043, Added method for event Order_Prop_Error_Occurred.
--  051013  LEPESE  Replaced usage of cost column in view inventory_transaction_hist_pub.
--  051013          Instead added call to Inventory_Transaction_Cost_API.Get_Sum_Unit_Cost().
--  050907  RaKalk  Moved event creation code block to invent.ins
--  050706  JOHESE  Enable use of project inventory in Reg_Count_Result__
--  040505  DaZaSe  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods, 
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
------------------------------------ 13.3.0 ----------------------------------
--  030901  GEBOSE  Added events Individual_Added_To_Pool and Individual_Removed_From_Pool
--  000925  JOHESE  Added undefines.
--  000912  JOHW    Changed view to the public view for transaction hist.
--  000825  JOHESE  Added configuration_id in cursor get_count_info
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  000112  LEPE    Replaced transaction codes for counting in method Invtran_Hist_Events.
--  990422  SHVE    Replaced select to INVENTORY_TRANSACTION_HIST to
--                  INVENTORY_TRANSACTION_HIST_TAB.
--  990412  SHVE    Upgraded to performance optimized template.
--  990326  LEPE    Added consignment transactions to method Invtran_Hist_Events.
--  981223  FRDI    Changed Sysdate to site dependent 'sysdate' - Site_API.Get_Site_Date(contract)
--  980423  LEPE    Added argument transaction_code_ to Invtran_Hist_Events.
--  980405  NAVE    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Reg_Count_Result__
--   Method to initiate an Event Server message every time an Inventory Count
--   Result has been registered.
PROCEDURE Reg_Count_Result__ (
   transaction_id_   IN NUMBER )
IS
   msg_                VARCHAR2(2000);
   fnd_user_           VARCHAR2(30);
   part_no_            INVENTORY_TRANSACTION_HIST_PUB.part_no%type;
   contract_           INVENTORY_TRANSACTION_HIST_PUB.contract%type;
   configuration_id_   INVENTORY_TRANSACTION_HIST_PUB.configuration_id%type;
   location_no_        INVENTORY_TRANSACTION_HIST_PUB.location_no%type;
   lot_batch_no_       INVENTORY_TRANSACTION_HIST_PUB.lot_batch_no%type;
   serial_no_          INVENTORY_TRANSACTION_HIST_PUB.serial_no%type;
   eng_chg_level_      INVENTORY_TRANSACTION_HIST_PUB.eng_chg_level%type;
   waiv_dev_rej_no_    INVENTORY_TRANSACTION_HIST_PUB.waiv_dev_rej_no%type;
   activity_seq_       INVENTORY_TRANSACTION_HIST_PUB.activity_seq%type;
   handling_unit_id_   INVENTORY_TRANSACTION_HIST_PUB.handling_unit_id%TYPE;
   count_variance_     INVENTORY_TRANSACTION_HIST_PUB.quantity%type;
   unit_cost_          NUMBER;

   CURSOR get_count_info IS
   SELECT contract, part_no, configuration_id, location_no, lot_batch_no, serial_no,
          eng_chg_level, waiv_dev_rej_no, activity_seq, handling_unit_id, quantity
   FROM   INVENTORY_TRANSACTION_HIST_PUB
   WHERE  transaction_id = transaction_id_;

BEGIN

   IF (Event_SYS.Event_Enabled('InventoryTransactionHist', 'REG_COUNT_RESULT')) THEN
      msg_ := Message_SYS.Construct('REG_COUNT_RESULT');
      --
      -- Get information
      --
      OPEN  get_count_info;
      FETCH get_count_info INTO contract_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, count_variance_;
      CLOSE get_count_info;
      --
      -- Standard Event Parameters
      --
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(contract_));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
      --
      -- Primary Key for object
      --
      Message_SYS.Add_Attribute( msg_, 'TRANSACTION_ID', transaction_id_);
      --
      -- Other important information
      --
      Message_SYS.Add_Attribute( msg_, 'PART_NO', part_no_);
      Message_SYS.Add_Attribute( msg_, 'PART_DESCRIPTION', Inventory_Part_API.Get_Description(contract_,
																							  part_no_));

      Message_SYS.Add_Attribute( msg_, 'QUANTITY', Inventory_Part_In_Stock_API.Get_Qty_Onhand(
                                                   contract_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                                                   serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_));
      Message_SYS.Add_Attribute( msg_, 'INVENTORY_DIFF', count_variance_);
      unit_cost_ := Inventory_Transaction_Cost_API.Get_Sum_Unit_Cost(transaction_id_);
      Message_SYS.Add_Attribute( msg_, 'INVENTORY_DIFF_VALUE', count_variance_ * unit_cost_);

      Event_SYS.Event_Execute('InventoryTransactionHist', 'REG_COUNT_RESULT', msg_);

   END IF;
END Reg_Count_Result__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Invtran_Hist_Events
--   Public interface to send any messages associated with the
--   InventoryTransactionHist LU.
PROCEDURE Invtran_Hist_Events (
   transaction_id_   IN NUMBER,
   transaction_code_ IN VARCHAR2 )
IS
BEGIN
   IF (transaction_code_ IN ('COUNT-OUT','COUNT-IN','CO-COUN-IN','CO-COUN-OU')) THEN
   -- Event Server calls for registering Inventory Count results
      Reg_Count_Result__(transaction_id_);
   END IF;
END Invtran_Hist_Events;


-- Individual_Added_To_Pool
--   Generates an event using the FND Connect when an inventory part has been
--   added to a rotable pool.
PROCEDURE Individual_Added_To_Pool (
   contract_                IN VARCHAR2,
   rotable_part_pool_id_    IN VARCHAR2,
   part_no_                IN VARCHAR2,
   serial_no_                IN VARCHAR2 )
IS
   msg_        VARCHAR2(2000);
   fnd_user_   VARCHAR2(30);
BEGIN

   IF (Event_SYS.Event_Enabled('InventoryPartInStock', 'INDIVIDUAL_ADDED_TO_POOL')) THEN

        msg_ := Message_SYS.Construct('INDIVIDUAL_ADDED_TO_POOL');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(contract_));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Important information passed in the message
      Message_SYS.Add_Attribute( msg_, 'ROTABLE_PART_POOL_ID', rotable_part_pool_id_);
		Message_SYS.Add_Attribute( msg_, 'DESCRIPTION', Rotable_Part_Pool_API.Get_Description(rotable_part_pool_id_));
      Message_SYS.Add_Attribute( msg_, 'PART_NO', part_no_);
      Message_SYS.Add_Attribute( msg_, 'SERIAL_NO', serial_no_);

      Event_SYS.Event_Execute('InventoryPartInStock', 'INDIVIDUAL_ADDED_TO_POOL', msg_);
   END IF;
END Individual_Added_To_Pool;


-- Individual_Removed_From_Pool
--   Generates an event using the FND Connect when an inventory part has been
--   removed from a rotable pool.
PROCEDURE Individual_Removed_From_Pool (
   contract_                IN VARCHAR2,
   rotable_part_pool_id_    IN VARCHAR2,
   part_no_                IN VARCHAR2,
   serial_no_                IN VARCHAR2 )
IS
   msg_        VARCHAR2(2000);
   fnd_user_   VARCHAR2(30);
BEGIN

   IF (Event_SYS.Event_Enabled('InventoryPartInStock', 'INDIVIDUAL_REMOVED_FROM_POOL')) THEN

        msg_ := Message_SYS.Construct('INDIVIDUAL_REMOVED_FROM_POOL');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute( msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(contract_));
      Message_SYS.Add_Attribute( msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute( msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute( msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute( msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Important information passed in the message
      Message_SYS.Add_Attribute( msg_, 'ROTABLE_PART_POOL_ID', rotable_part_pool_id_);
		Message_SYS.Add_Attribute( msg_, 'DESCRIPTION', Rotable_Part_Pool_API.Get_Description(rotable_part_pool_id_));
      Message_SYS.Add_Attribute( msg_, 'PART_NO', part_no_);
      Message_SYS.Add_Attribute( msg_, 'SERIAL_NO', serial_no_);

      Event_SYS.Event_Execute('InventoryPartInStock', 'INDIVIDUAL_REMOVED_FROM_POOL', msg_);
   END IF;
END Individual_Removed_From_Pool;


PROCEDURE Order_Prop_Error_Occurred (
   contract_        IN VARCHAR2,
   error_message_   IN VARCHAR2 )
IS
   msg_        VARCHAR2(2000);
   fnd_user_   VARCHAR2(30);
BEGIN

   IF (Event_SYS.Event_Enabled('OrderProposalManager', 'ORDER_PROP_ERROR_OCCURRED')) THEN

      msg_ := Message_SYS.Construct('ORDER_PROP_ERROR_OCCURRED');

      -- Standard Event Parameters
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
      Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', Site_API.Get_Site_Date(contract_));
      Message_SYS.Add_Attribute(msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_Attribute(msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_Attribute(msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_Attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));

      -- Important information passed in the message
      Message_SYS.Add_Attribute(msg_, 'ERROR_MESSAGE', error_message_);

      Event_SYS.Event_Execute('OrderProposalManager', 'ORDER_PROP_ERROR_OCCURRED', msg_);
   END IF;
END Order_Prop_Error_Occurred;



