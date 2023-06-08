-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPartFifoUniss
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  140225  IsSalk   Bug 115519, Added two overload methods Get_Total_Unissed_Quantity() in order to get total unissued quantity for 
--  140225           given sequence_no_ and issue_transaction_id_.
--  130920  PraWlk   Bug 99627, Added CASCADE option on the parent key reference towards InventoryPartFifoIssue and removed 
--  130920           reference towards Site, InventoryPart and InventoryPartCostFifo in view INVENTORY_PART_FIFO_UNISS. 
--  110628  PraWlk   Bug 93152, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Total_Unissed_Quantity (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   sequence_no_          IN NUMBER,
   issue_transaction_id_ IN NUMBER) RETURN NUMBER
IS
   total_unissued_qty_ NUMBER;

   CURSOR total_unissued IS
      SELECT SUM(unissued_quantity)
      FROM  INVENTORY_PART_FIFO_UNISS_TAB
      WHERE contract = contract_
      AND   part_no = part_no_
      AND   sequence_no = sequence_no_
      AND   issue_transaction_id = issue_transaction_id_ ;
BEGIN
   OPEN total_unissued;
   FETCH total_unissued INTO total_unissued_qty_;
   CLOSE total_unissued;
   RETURN (NVL(total_unissued_qty_,0));
END Get_Total_Unissed_Quantity;


PROCEDURE Copy_To_New_Issue (
   old_issue_cancel_trans_id_ IN NUMBER,
   new_issue_transaction_id_  IN NUMBER) 
IS
   CURSOR get_unissued_records IS
      SELECT contract, part_no, sequence_no, issue_transaction_id, unissued_quantity
      FROM  INVENTORY_PART_FIFO_UNISS_TAB
      WHERE issue_transaction_id = old_issue_cancel_trans_id_ ;
BEGIN
   FOR unissued_rec IN get_unissued_records LOOP
      Inventory_Part_Fifo_Issue_API.Issue_Quantity(unissued_rec.contract,
                                                   unissued_rec.part_no,
                                                   unissued_rec.sequence_no,
                                                   new_issue_transaction_id_,
                                                   unissued_rec.unissued_quantity);   

   END LOOP;
END Copy_To_New_Issue;


PROCEDURE New (
   contract_               IN VARCHAR2,
   part_no_                IN VARCHAR2,
   sequence_no_            IN NUMBER,
   issue_transaction_id_   IN NUMBER,
   unissue_transaction_id_ IN NUMBER,
   unissued_quantity_      IN NUMBER )
IS
   attr_       VARCHAR2(32000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     INVENTORY_PART_FIFO_UNISS_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   
   Client_SYS.Add_To_Attr('CONTRACT'               , contract_               , attr_);
   Client_SYS.Add_To_Attr('PART_NO'                , part_no_                , attr_);
   Client_SYS.Add_To_Attr('SEQUENCE_NO'            , sequence_no_            , attr_);
   Client_SYS.Add_To_Attr('ISSUE_TRANSACTION_ID'   , issue_transaction_id_   , attr_);
   Client_SYS.Add_To_Attr('UNISSUE_TRANSACTION_ID' , unissue_transaction_id_ , attr_);
   Client_SYS.Add_To_Attr('UNISSUED_QUANTITY'      , unissued_quantity_      , attr_);
   
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


FUNCTION Get_Total_Unissed_Quantity (
   contract_             IN VARCHAR2,
   part_no_              IN VARCHAR2,
   sequence_no_          IN NUMBER) RETURN NUMBER
IS
   total_unissued_qty_ NUMBER;

   CURSOR total_unissued_qty IS
      SELECT SUM(unissued_quantity)
      FROM   INVENTORY_PART_FIFO_UNISS_TAB
      WHERE  contract = contract_
      AND    part_no = part_no_
      AND    sequence_no = sequence_no_;
BEGIN
   OPEN total_unissued_qty;
   FETCH total_unissued_qty INTO total_unissued_qty_;
   CLOSE total_unissued_qty;
   RETURN (NVL(total_unissued_qty_,0));
END Get_Total_Unissed_Quantity;

FUNCTION Get_Total_Unissed_Quantity (
   issue_transaction_id_ IN NUMBER) RETURN NUMBER
IS
   total_unissued_qty_ NUMBER;

   CURSOR total_unissued_qty IS
      SELECT SUM(unissued_quantity)
      FROM   INVENTORY_PART_FIFO_UNISS_TAB
      WHERE  issue_transaction_id = issue_transaction_id_ ;
BEGIN
   OPEN total_unissued_qty;
   FETCH total_unissued_qty INTO total_unissued_qty_;
   CLOSE total_unissued_qty;
   RETURN (NVL(total_unissued_qty_,0));
END Get_Total_Unissed_Quantity;