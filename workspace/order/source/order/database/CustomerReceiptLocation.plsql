-----------------------------------------------------------------------------
--
--  Logical unit: CustomerReceiptLocation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150511  Chfose  LIM-2894, Removed unused function Get_Qty_To_Return.
--  150420  UdGnlk  LIM-150, Added handling_unit_id as new key column to Customer_Receipt_Location_Tab therefore did necessary changes. 
--  141112  NaSalk  Remove overidden code for Check_Insert. Calling method correctly passes Activity_seq therefore
--  141112          no need replace it from Customer order line activity seq.
--  140226  RoJalk  Modified Manage_Receipt_Return  and replaced Unpack_Check_Insert___/Unpack_Check_Update___
--  140226          with Unpack___ and Check_Insert___/Check_Update___.
--  131230  NaLrlk  Added Manage_Receipt_Return() to handle receipt returns.
--  130518  NaLrlk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Create customer receipt location.
PROCEDURE New (
   attr_ IN VARCHAR2 )
IS
   objid_      CUSTOMER_RECEIPT_LOCATION.objid%TYPE;
   objversion_ CUSTOMER_RECEIPT_LOCATION.objversion%TYPE;
   newrec_     CUSTOMER_RECEIPT_LOCATION_TAB%ROWTYPE;
   new_attr_   VARCHAR2(32000);
   ptr_        NUMBER;
   name_       VARCHAR2(30);
   value_      VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN

   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Set_Item_Value(name_, value_, new_attr_);
   END LOOP;

   Unpack___(newrec_, indrec_, new_attr_);
   Check_Insert___(newrec_, indrec_, new_attr_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
END New;


-- Manage_Receipt_Return
--   This method is used to update existing receipt return location if exist or otherwise
--   insert a new record if RMA is received.
PROCEDURE Manage_Receipt_Return (
   rma_no_              IN NUMBER,
   rma_line_no_         IN NUMBER,
   receipt_no_          IN NUMBER,
   part_no_             IN VARCHAR2,
   contract_            IN VARCHAR2,
   configuration_id_    IN VARCHAR2,
   location_no_         IN VARCHAR2,
   lot_batch_no_        IN VARCHAR2,
   serial_no_           IN VARCHAR2,
   eng_chg_level_       IN VARCHAR2,
   waiv_dev_rej_no_     IN VARCHAR2,
   activity_seq_        IN NUMBER,
   handling_unit_id_    IN NUMBER,
   part_ownership_db_   IN VARCHAR2,
   owning_vendor_no_    IN VARCHAR2,
   qty_returned_        IN NUMBER,
   qty_returned_inv_    IN NUMBER,
   catch_qty_returned_  IN NUMBER )
IS
   objid_       CUSTOMER_RECEIPT_LOCATION.objid%TYPE;
   objversion_  CUSTOMER_RECEIPT_LOCATION.objversion%TYPE;
   attr_        VARCHAR2(32000);
   oldrec_      CUSTOMER_RECEIPT_LOCATION_TAB%ROWTYPE;
   newrec_      CUSTOMER_RECEIPT_LOCATION_TAB%ROWTYPE;
   indrec_      Indicator_Rec;
BEGIN
   IF Check_Exist___(rma_no_, rma_line_no_, receipt_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_) THEN
      oldrec_:= Lock_By_Keys___(rma_no_, rma_line_no_, receipt_no_, part_no_, contract_, configuration_id_, location_no_, lot_batch_no_, serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);

      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr( 'QTY_RETURNED', (oldrec_.qty_returned + qty_returned_), attr_ );
      Client_SYS.Add_To_Attr( 'QTY_RETURNED_INV', (oldrec_.qty_returned_inv + qty_returned_inv_), attr_ );
      IF catch_qty_returned_ IS NOT NULL THEN
         Client_SYS.Add_To_Attr( 'CATCH_QTY_RETURNED', (NVL(oldrec_.catch_qty_returned, 0) + catch_qty_returned_), attr_ );
      END IF;
      newrec_ := oldrec_;
      
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('RMA_NO', rma_no_, attr_);
      Client_SYS.Add_To_Attr('RMA_LINE_NO', rma_line_no_, attr_);
      Client_SYS.Add_To_Attr('RECEIPT_NO', receipt_no_, attr_);
      Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
      Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
      Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
      Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, attr_);
      Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, attr_);
      Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
      Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', eng_chg_level_, attr_);
      Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', waiv_dev_rej_no_, attr_);
      Client_SYS.Add_To_Attr('ACTIVITY_SEQ', activity_seq_, attr_);
      Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, attr_);
      Client_SYS.Add_To_Attr('PART_OWNERSHIP_DB', part_ownership_db_, attr_);
      Client_SYS.Add_To_Attr('OWNING_VENDOR_NO', owning_vendor_no_, attr_);
      Client_SYS.Add_To_Attr('QTY_RETURNED', qty_returned_, attr_);
      Client_SYS.Add_To_Attr('QTY_RETURNED_INV', qty_returned_inv_, attr_);
      Client_SYS.Add_To_Attr('CATCH_QTY_RETURNED', catch_qty_returned_, attr_);
      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Manage_Receipt_Return;