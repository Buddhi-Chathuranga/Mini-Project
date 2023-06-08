-----------------------------------------------------------------------------
--
--  Logical unit: CustomerReturnReceipt
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130913  CPriLK  Added return_material_scrap_tab to Get_Total_Qty_Scrapped() insted of return_material_scrap.
--  130621  Vwloza  Added Get_Total_Qty_Scrapped.
--  130605  PeSulk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Next_Receipt_No___
--   Returns next receipt no.
FUNCTION Get_Next_Receipt_No___(
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER)   RETURN NUMBER
IS
   receipt_no_ CUSTOMER_RETURN_RECEIPT_TAB.receipt_no%TYPE;
   CURSOR get_receipt_no IS
      SELECT NVL(MAX(receipt_no + 1), 1)
      FROM   CUSTOMER_RETURN_RECEIPT_TAB
      WHERE  rma_no      = rma_no_
      AND    rma_line_no = rma_line_no_;
BEGIN
   OPEN get_receipt_no;
   FETCH get_receipt_no INTO receipt_no_;
   CLOSE get_receipt_no;
   RETURN receipt_no_;
END Get_Next_Receipt_No___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_return_receipt_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.receipt_no   := Get_Next_Receipt_No___(newrec_.rma_no, newrec_.rma_line_no);
   newrec_.created_date := Site_API.Get_Site_Date(newrec_.contract);
   super(newrec_, indrec_, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Exist
--   Check whether the given receipt is exist or not.
@UncheckedAccess
FUNCTION Check_Exist (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER,
   receipt_no_  IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(rma_no_, rma_line_no_, receipt_no_);
END Check_Exist;


-- New
--   Create new customer receipt.
PROCEDURE New (
   receipt_no_   OUT NUMBER,
   rma_no_       IN  NUMBER,
   rma_line_no_  IN  NUMBER,
   contract_     IN  VARCHAR2,
   qty_returned_ IN  NUMBER )
IS
   objid_      CUSTOMER_RETURN_RECEIPT.objid%TYPE;
   objversion_ CUSTOMER_RETURN_RECEIPT.objversion%TYPE;
   newrec_     CUSTOMER_RETURN_RECEIPT_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   attr_       VARCHAR2(32000);
BEGIN
   newrec_.rma_no := rma_no_;
   indrec_.rma_no := TRUE;
   newrec_.rma_line_no := rma_line_no_;
   indrec_.rma_line_no := TRUE;
   newrec_.contract := contract_;
   indrec_.contract := TRUE;
   newrec_.qty_returned := qty_returned_;
   indrec_.qty_returned := TRUE;

   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
   receipt_no_ := newrec_.receipt_no;
END New;


-- Get_Total_Qty_Scrapped
--   Return the total scrapped quantity for specified customer receipt.
@UncheckedAccess
FUNCTION Get_Total_Qty_Scrapped (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER,
   receipt_no_  IN NUMBER ) RETURN NUMBER
IS
   total_qty_scrapped_ NUMBER;
   CURSOR get_qty_scrapped IS
      SELECT SUM(qty_scrapped)
      FROM return_material_scrap_tab
      WHERE rma_no = rma_no_
      AND rma_line_no = rma_line_no_
      AND receipt_no = receipt_no_;
BEGIN
   OPEN get_qty_scrapped;
   FETCH get_qty_scrapped INTO total_qty_scrapped_;
   CLOSE get_qty_scrapped;
   RETURN total_qty_scrapped_;
END Get_Total_Qty_Scrapped;


-- Get_Total_Qty_Returned
--   Return the total returned quantity for specified customer receipt.
--   If sales part is inventory part, total returned qty is fetched
--   from customer receipt locations.
--   For non-inventory part, total returned qty is fetched from customer receipt.
@UncheckedAccess
FUNCTION Get_Total_Qty_Returned (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER,
   receipt_no_  IN NUMBER ) RETURN NUMBER
IS
   total_qty_returned_  NUMBER := 0;
   CURSOR get_total_inv_returned IS
      SELECT SUM(qty_returned)
      FROM   customer_receipt_location_tab
      WHERE  rma_no      = rma_no_
      AND    rma_line_no = rma_line_no_
      AND    receipt_no  = receipt_no_;
BEGIN
   IF (Return_Material_Line_API.Get_Part_No(rma_no_, rma_line_no_) IS NOT NULL) THEN
      OPEN get_total_inv_returned;
      FETCH get_total_inv_returned INTO total_qty_returned_;
      CLOSE get_total_inv_returned;
   ELSE
      total_qty_returned_ := Get_Qty_Returned(rma_no_, rma_line_no_, receipt_no_);
   END IF;
   RETURN NVL(total_qty_returned_, 0);
END Get_Total_Qty_Returned;


-- Get_Total_Qty_Returned_Inv
--   Return the total invetory returned quantity for
--   specified customer receipt.
@UncheckedAccess
FUNCTION Get_Total_Qty_Returned_Inv (
   rma_no_      IN NUMBER,
   rma_line_no_ IN NUMBER,
   receipt_no_  IN NUMBER ) RETURN NUMBER
IS
   total_qty_returned_inv_  NUMBER;
   CURSOR get_total_inv_returned IS
      SELECT NVL(SUM(qty_returned_inv), 0)
      FROM   customer_receipt_location_tab
      WHERE  rma_no      = rma_no_
      AND    rma_line_no = rma_line_no_
      AND    receipt_no  = receipt_no_;
BEGIN
   IF (Return_Material_Line_API.Get_Part_No(rma_no_, rma_line_no_) IS NOT NULL) THEN
      OPEN get_total_inv_returned;
      FETCH get_total_inv_returned INTO total_qty_returned_inv_;
      CLOSE get_total_inv_returned;
   END IF;
   RETURN total_qty_returned_inv_;
END Get_Total_Qty_Returned_Inv;

