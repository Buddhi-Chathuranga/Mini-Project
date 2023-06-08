-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartFifoIssue
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140225  IsSalk   Bug 115519, Modified overload methods Get_Total_Issued_Quantity() in order to get 
--  140225           total issued quantity for given sequence_no_ and issue_transaction_id_.
--  130918  PraWlk   Bug 99627, Added CASCADE option on the parent key reference towards InventoryPartCostFifo in
--  130918           view INVENTORY_PART_FIFO_ISSUE. Removed Issue_Info_Exist () as it is no longer used. Also 
--  130918           modified Unissue_Quantity () to raise an error if full requested quantity cannot be unissued.
--  110628  PraWlk   Bug 93152, Modified Unissue_Quantity() by adding new parameter unissue_transaction_id_ and
--  110628           passed the valued of it when calling Unissue_Quantity___(). Modified Unissue_Quantity___()
--  110628           by adding new parameter unissue_transaction_id_ and calling INVENTORY_PART_FIFO_UNISS_API.New().
--  110628           Modified methods Get_Total_Issued_Quantity() to return issued quanity correctly
--  110628           instead of reducing ISSUED_QUANTITY.
--  101021  PraWlk   Bug 89847, Added new function Get_Total_Issued_Quantity() to get the issued quantity from
--  101021           the fifo stack for a particular transaction.
--  100811  PraWlk   Bug 89848, Added new parapeter value_detail_tab_ to Unissue_Quantity___ () and modified
--  100811           Unissue_Quantity() and Unissue_Quantity___ () in order to calculate the weighted average
--  100811           of cost details on the stack records when doing unissue transactions.
--  091217  PraWlk   Bug 84712, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Unissue_Quantity___ (
   qty_unissued_from_stack_ IN OUT NUMBER,
   value_detail_tab_        IN OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   qty_unissued_from_stock_ IN     NUMBER,
   oldrec_                  IN     INVENTORY_PART_FIFO_ISSUE_TAB%ROWTYPE,
   unissue_transaction_id_  IN     NUMBER )
IS
   qty_to_unissue_from_record_ NUMBER;
   cost_detail_tab_            Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   total_qty_unissued_         NUMBER;
BEGIN
   cost_detail_tab_ := Inventory_Part_Fifo_Detail_API.Get_Cost_Details(oldrec_.contract,
                                                                       oldrec_.part_no,
                                                                       oldrec_.sequence_no);

   total_qty_unissued_ := Inventory_Part_Fifo_Uniss_API.Get_Total_Unissed_Quantity(oldrec_.contract,
                                                                                   oldrec_.part_no,
                                                                                   oldrec_.sequence_no,
                                                                                   oldrec_.issue_transaction_id);

   qty_to_unissue_from_record_ := LEAST((qty_unissued_from_stock_ - qty_unissued_from_stack_), (oldrec_.issued_quantity - total_qty_unissued_));

   Inventory_Part_Fifo_Uniss_API.New(oldrec_.contract,
                                     oldrec_.part_no,
                                     oldrec_.sequence_no,
                                     oldrec_.issue_transaction_id,
                                     unissue_transaction_id_,
                                     qty_to_unissue_from_record_);

   Inventory_Part_Cost_Fifo_API.Modify_Last_Activity_Date(oldrec_.contract,
                                                          oldrec_.part_no,
                                                          oldrec_.sequence_no);   
   value_detail_tab_ := Inventory_Part_Unit_Cost_API.Add_To_Value_Detail_Tab(value_detail_tab_,
                                                                             cost_detail_tab_,
                                                                             qty_to_unissue_from_record_);
   qty_unissued_from_stack_ := qty_unissued_from_stack_ + qty_to_unissue_from_record_;

END Unissue_Quantity___;


PROCEDURE Remove_Zero_Quantity_Record___ (
   newrec_     IN INVENTORY_PART_FIFO_ISSUE_TAB%ROWTYPE,
   objid_      IN VARCHAR2,
   by_keys_    IN BOOLEAN )
IS
   local_objid_ INVENTORY_PART_FIFO_ISSUE.OBJID%TYPE;
   objversion_  INVENTORY_PART_FIFO_ISSUE.OBJVERSION%TYPE; 
BEGIN

   IF (newrec_.issued_quantity = 0) THEN  
      Check_Delete___(newrec_);
      IF (by_keys_) THEN
         Get_Id_Version_By_Keys___(local_objid_,
                                   objversion_,
                                   newrec_.contract,
                                   newrec_.part_no,
                                   newrec_.sequence_no,
                                   newrec_.issue_transaction_id);
      ELSE
         local_objid_ := objid_;
      END IF;
      Delete___(local_objid_, newrec_);
   END IF;
END Remove_Zero_Quantity_Record___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     INVENTORY_PART_FIFO_ISSUE_TAB%ROWTYPE,
   newrec_     IN OUT INVENTORY_PART_FIFO_ISSUE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Remove_Zero_Quantity_Record___(newrec_, objid_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Issue_Quantity (
   contract_                 IN VARCHAR2,
   part_no_                  IN VARCHAR2,
   sequence_no_              IN NUMBER,
   issue_transaction_id_      IN NUMBER,
   quantity_             IN NUMBER )
IS
   attr_                          VARCHAR2(32000);
   objid_                         VARCHAR2(2000);
   objversion_                    VARCHAR2(2000);
   newrec_                        INVENTORY_PART_FIFO_ISSUE_TAB%ROWTYPE;
   indrec_                        Indicator_Rec;
BEGIN

   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   Client_SYS.Add_To_Attr('PART_NO' , part_no_, attr_);
   Client_SYS.Add_To_Attr('SEQUENCE_NO', sequence_no_, attr_);
   Client_SYS.Add_To_Attr('ISSUE_TRANSACTION_ID', issue_transaction_id_, attr_);
   Client_SYS.Add_To_Attr('ISSUED_QUANTITY', quantity_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_); 
END Issue_Quantity;


PROCEDURE Unissue_Quantity (
   cost_detail_tab_        OUT Inventory_Part_Unit_Cost_API.Cost_Detail_Tab,
   contract_               IN  VARCHAR2,
   part_no_                IN  VARCHAR2,
   issue_transaction_id_   IN  NUMBER,
   quantity_                IN  NUMBER,
   unissue_transaction_id_ IN  NUMBER )
IS
   invepart_rec_            Inventory_Part_API.Public_Rec;
   qty_unissued_from_stack_ NUMBER := 0;
   value_detail_tab_        Inventory_Part_Unit_Cost_API.Cost_Detail_Tab;
   
   CURSOR get_fifo IS
      SELECT *
      FROM INVENTORY_PART_FIFO_ISSUE_TAB
      WHERE contract = contract_
      AND part_no  = part_no_
      AND issue_transaction_id = issue_transaction_id_
      ORDER BY sequence_no DESC
      FOR UPDATE;

   CURSOR get_lifo IS
      SELECT *
      FROM INVENTORY_PART_FIFO_ISSUE_TAB
      WHERE contract = contract_
      AND part_no  = part_no_
      AND issue_transaction_id = issue_transaction_id_
      ORDER BY sequence_no ASC
      FOR UPDATE;

BEGIN

   invepart_rec_ := Inventory_Part_API.Get(contract_, part_no_);

   IF (invepart_rec_.inventory_valuation_method = 'FIFO') THEN
      FOR oldrec_ IN get_fifo LOOP
         Unissue_Quantity___(qty_unissued_from_stack_,
                             value_detail_tab_,
                             quantity_,
                             oldrec_,
                             unissue_transaction_id_);
         IF (qty_unissued_from_stack_ = quantity_) THEN
            EXIT;
         END IF; 
      END LOOP;
      
   ELSIF (invepart_rec_.inventory_valuation_method = 'LIFO') THEN  
      FOR oldrec_ IN get_lifo LOOP
         Unissue_Quantity___(qty_unissued_from_stack_,
                             value_detail_tab_,
                             quantity_,
                             oldrec_,
                             unissue_transaction_id_);

         IF (qty_unissued_from_stack_ = quantity_) THEN
            EXIT;
         END IF;
      END LOOP;
   END IF;
   cost_detail_tab_ := Inventory_Part_Unit_Cost_API.Value_To_Cost_Details(value_detail_tab_, 
                                                                          qty_unissued_from_stack_); 
   IF (qty_unissued_from_stack_ != quantity_) THEN
      Error_SYS.Record_General(lu_name_, 'UNISSQTYERR: Only :P1 out of :P2 could be unissued from the FIFO Issue stack for issue transaction :P3. Contact System Support.', qty_unissued_from_stack_, quantity_, issue_transaction_id_);
   END IF;
END Unissue_Quantity;


@UncheckedAccess
FUNCTION Get_Total_Issued_Quantity (
   contract_    IN VARCHAR2,
   part_no_     IN VARCHAR2,
   sequence_no_ IN NUMBER ) RETURN NUMBER
IS
   total_issued_qty_    NUMBER := 0;
   total_unissued_qty_  NUMBER := 0;

   CURSOR total_issued_qty IS
      SELECT SUM(issued_quantity)
      FROM   INVENTORY_PART_FIFO_ISSUE_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    sequence_no = sequence_no_;
BEGIN
   OPEN total_issued_qty;
   FETCH total_issued_qty INTO total_issued_qty_;
   CLOSE total_issued_qty;
   
   total_unissued_qty_ := Inventory_Part_Fifo_Uniss_API.Get_Total_Unissed_Quantity(contract_, part_no_, sequence_no_);
   
   RETURN (NVL(total_issued_qty_, 0) - total_unissued_qty_);
END Get_Total_Issued_Quantity;


@UncheckedAccess
FUNCTION Get_Total_Issued_Quantity (
   transaction_id_ IN NUMBER ) RETURN NUMBER
IS
   tot_quantity_ NUMBER;

   CURSOR total_consumed IS
      SELECT contract, part_no, sequence_no, issued_quantity
      FROM  INVENTORY_PART_FIFO_ISSUE_TAB
      WHERE issue_transaction_id = transaction_id_;

   TYPE Total_Consumed_Tab_Type IS TABLE OF total_consumed%ROWTYPE
     INDEX BY PLS_INTEGER;

   total_consumed_tab_ Total_Consumed_Tab_Type;
BEGIN
   tot_quantity_ := 0;
   OPEN total_consumed;
   FETCH total_consumed BULK COLLECT INTO total_consumed_tab_;
   CLOSE total_consumed;

   IF (total_consumed_tab_.COUNT > 0) THEN
      FOR i IN total_consumed_tab_.FIRST..total_consumed_tab_.LAST LOOP
         tot_quantity_ := tot_quantity_ + (total_consumed_tab_(i).issued_quantity - Inventory_Part_Fifo_Uniss_API.Get_Total_Unissed_Quantity(total_consumed_tab_(i).contract,
                                                                                                                                             total_consumed_tab_(i).part_no,
                                                                                                                                             total_consumed_tab_(i).sequence_no,
                                                                                                                                             transaction_id_));
      END LOOP;
   END IF;
   RETURN (NVL(tot_quantity_,0));
END Get_Total_Issued_Quantity;



