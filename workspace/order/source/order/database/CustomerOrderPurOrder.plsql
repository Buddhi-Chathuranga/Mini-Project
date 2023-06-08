-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderPurOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190114  ChBnlk Bug 146301, (SCZ-2625) Added UncheckedAccess annotation to the method Get_Purord_For_Custord. 
--  160202  ThEdlk Bug 126845, Introduced a new method Get_Vendor_No_For_Po() to retrieve the vendor_no of the relevant Purchase Order
--  141215  MAHPLK PRSC-4493, Added new attribute changed_attrib_not_in_pol.
--  141118  RoJalk PRSC-4019, Added the method Fetch_Po_Info. 
--  140423  KiSalk Bug 111264, Added method Get_Po_Order_No_For_Custord__.
--  140129  ChBnlk Bug 113704, Added @ReadOnlyAccess to Get_Custord_For_Purord().
--  130705  MaIklk TIBE-986, Removed global constants inst_PurchaseOrderLine_ and inst_PurchaseReqUtil_. Used conditional compilation instead.
--  130610  PraWlk Bug 110506, Moved view CUST_ORDER_PUR_ORDER_PEG here from PegCustomerOrder LU to support custom fields in client.
--  120704  VISALK Bug 102612, Modified Get_Total_Qty_On_Order() to return zero instead of a NULL value.
--  120314  DaZase Removed last TRUE parameter in Init_Method call inside Remove_Line.
--  110831  Darklk Bug 98668, Changed the return type of the function Connected_Orders_Found.
--  100430  NuVelk Merged Twin Peaks.
--  090512  HaYalk Added method Get_Total_Qty_On_Order to get total pegged qty for different orders.
--  090930  MaMalk Removed constants inst_PurchaseOrderLinePart_ and inst_PurchaseOrder_. Modified method Modify to remove unused code.
----------------------------- 14.0.0 -----------------------------------------
--  091120  ChJalk Bug 86871, Removed General_SYS.Init_Method from the function Get_Connected_Peggings.
--  081127  ThAylk Bug 77298, Added procedure Remove_Line.
--  060125  JaJalk Added Assert safe annotation.
--  060111  MaHplk Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  050922  SaMelk Removed unused variables.
--  050525  JeLise Bug 51396, Removed the part in Modify where data in the table is removed when qty_on_order is zero.
--  040219  IsWilk Removed the SUBSTRB from the view for Unicode Changes.
--  050217  LaPrlk Bug 48770, Added oldrec_ and newrec_ local variables to Modify and removed the call to Modify__.
-------------------Edge Package Group 3 Unicode Changes-----------------------
--  040126  GeKalk Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  031008  PrJalk Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030818  MaGulk Merged CR
--  030716  NaWalk Removed Bug coments.
--  030709  WaJalk Applied Bug 34820.
--  030505  DaZa  Change prompt on supply_code from Acquisition to Supply Code.
--  ***************************** CR Merge **********************************
--  030730  ChIwlk Performed SP4 Merge.
--  030403  PrTilk Added a new public CheckExist function.
--  030402  SudWlk Modified the methods, Get_Purord_For_Custord, Get_Purord_For_Custord_Int, Get_Custord_For_Purord
--  030402         and Get_Custord_For_Purreq.
--  030331  SudWlk Removed obsolete attributes Contract, Originated_By, Supply_Code, Vendor_No and Date_Entered.
--  030328  GeKaLk Added description for public method Modify.
--  030327  AnJplk Modified method Get_Connected_Peggings.
--  030320  SudWlk removed method, Connected_Pur_Orders_Found.
--  030320  PrTilk Added a new public method,Get_Connected_Peggings. Removed Method Check_One_Pegging_Exist.
--  030320  GeKaLk Modified public method Modify.
--  030320  SudWlk Added a new public method, Connected_Pur_Orders_Found.
--  030320  GeKaLk Modified public method Modify.
--  030319  ViPalk Removed definition of COLOBJVERSION.
--  030319  PrTiLk Removed methods Modify_Qty_On_Order,Modify_Qty_For_Reserve and Added a new public Modify Method.
--  030319  ViPalk Removed view CUST_ORDER_PUR_ORDER_PEG and included it in file PeggCustomerOrder.apy.
--  030319  SudWlk Changed the Oracle keywork TO_CHAR to capitals in Method Modify_Qty_On_Order.
--  030319  GeKaLk Done code review modifications.
--  030317  PrTilk Added 2 new public methods, Check_One_Pegging_Exist and Modify_Qty_For_Reserve.
--  030317  GeKaLk Modified public Method Modify_Qty_On_Order.
--  030314  GeKaLk Modified public Method Modify_Qty_On_Order.
--  030314  SudWlk Modified public Method Modify_Qty_On_Order to add a Customer Order Line History.
--  030314  GeKaLk Modified public Method Modify_Qty_On_Order to update qty_on_order in PO Line Part and CO line part..
--  030313  ViPalk Added NOCHECK to the view comment of columns oe_line_item_no, purchase_type
--                 and supply_code in view CUST_ORDER_PUR_ORDER_PEG.
--  030313  GeKaLk Modified public Method Modify_Qty_On_Order to add the error message.
--  030311  ViPalk Changed the name of view CUSTOMER_ORDER_PUR_ORDER1 to CUST_ORDER_PUR_ORDER_PEG.
--  030310  GeKaLk Modified public Method Modify_Qty_On_Order.
--  030307  GeKaLk Added a new public Method Modify_Qty_On_Order.
--  030306  ViPalk Changed the where condition of view CUSTOMER_ORDER_PUR_ORDER1.
--  030305  GeKaLk Added a new public attribute qty_on_order to Procedure New.
--  030305  ViPalk Added new view CUSTOMER_ORDER_PUR_ORDER1.
--  030305  GeKaLk Added a new public attribute qty_on_order to the customer_order_pur_order_tab.
--  030218  NuFilk Bug 34820, Removed function Get_Oe_Order_No2.
--  020720  NuFilk Bug 29217, Added a New Function Get_Oe_Order_No2.
--  020507  NuFilk Bug 29081, Added a Check in the cursors for purchase_type in Get_Oe_Order_No,
--  020507         Get_Oe_Line_No, Get_Rel_No Functions.
--  010509  IsAn  Bug fix 21246,Changed wrong coding in cursor get_pur_order_line in PROCEDURE Remove to fetch unique values.
--  010413  JaBa  Bug Fix 20598,Added new global lu constants and used those in necessary places.
--  000913  FBen  Added UNDEFINE.
--  000425  PaLj  Changed check for installed logical units. A check is made when API is instantiatet.
--                See beginning of api-file.
--  000419  PaLj  Corrected Init_Method Errors
--  000328  JoAn  Changed Modify_From_Purchase to handle the case when a purchase order has been
--                cancelled and the connection to purchase requisition should be
--                reestablished.
--  990520  JoAn  CID 15951 Changed Modify_From_Purchase updating by objid_ instead of by keys.
--  990412  JoAn  Corrected Remove method, changed implementation of Modify_From_Purchase
--  990409  JoAn  Y.CID 10557 Adapted to F1 2.2.1 template
--                Also removed obsolete methods Check_Direct_Delivery_Order_No,
--                Get_Cust_Ord_For_Pur_Order, Get_Pur_Ord_For_Cust_Order,
--  990326  JakH  CID 11867  Big fix 7879, Added a new public procedure Get_Purord_For_Custord_Int().
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  980302  JoAn  WB cleanup after corrections in Rose model.
--  980227  JoAn  Removed obsolete methods Check_CO_Generated_By_CO,
--                Get_Int_Purch_Cust_Order, Check_Internal_Order_Exists and
--                Get_Org_Pur_Order_Contract__
--  971120  RaKu  Changed to FND200 Templates.
--  971022  JoAn  Added extra condition to Get_Purord_For_Custord
--  971015  NABE  Added a new public method Get_Custord_For_Purreq. to fix Sup Id 918.
--  970916  NABE  Changed Check_CO_Generated_By_CO to fix Bug- 197-0136,
--                return PO keys for CO created by PO.
--  970604  JoAn  Added extra condition to cursor in Get_Cust_Ord_For_Pur_Ord
--  970530  JoAn  Added Get_Org_Pur_Order_Contract__
--  970528  JOED  Changed call Instance_Exists to Line_Instance_Exists and
--                also changed package name.
--  970521  JOED  Added .._db columns in the view for all IID columns.
--                New template.
--  970512  JoAn  Exist check for vendor_no made with dynamic SQL call
--  970423  NABE  Added a New functions Check_CO_Generated_By_CO,
--                Check_Internal_Order_Exists.
--  970422  NABE  Modified Get_Int_Purch_Cust_Order to handle Inventory refill.
--  970418  NABE  Modified Procedure Get_Cust_Ord_For_Pur_Order and
--                Get_Pur_Ord_For_Cust_Order as Functions. Corrected the
--                IN / OUT parameters for Get_Int_Purch_Cust_Order.
--  970416  NABE  Added 3 new public methods Get_Int_Purch_Cust_Order
--                Get_Pur_Ord_For_Cust_order, Get_Cust_Ord_For_Pur_Order.
--                Added column vendor_no.
--  970414  JOED  Added columns contract, originated_by and supply_code.
--  970312  RaKu  Changed table name.
--  970218  EVWE  Changed to rowversion (10.3 Project)
--  970128  ASBE  Removed call to Purchase_Requis_Line_API.Exist in
--                Unpack_Check_Insert___ and Unpack_Check_Update___.
--  960418  PARO  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_pur_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.qty_on_order IS NULL) THEN
      newrec_.qty_on_order := 0;
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
-----------------------------------------------------------------------------
-- Get_Po_Order_No_For_Custord__
--   Returns the purchase order number of the key for
--   a specific customer order line.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Po_Order_No_For_Custord__ (
   oe_order_no_     IN  VARCHAR2,
   oe_line_no_      IN  VARCHAR2,
   oe_rel_no_       IN  VARCHAR2,
   oe_line_item_no_ IN  NUMBER ) RETURN VARCHAR2
IS
   po_order_no_ CUSTOMER_ORDER_PUR_ORDER_TAB.po_order_no%TYPE;
    
   CURSOR get_pur_order IS
      SELECT po_order_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no  = oe_line_item_no_;

BEGIN

   OPEN get_pur_order;
   FETCH get_pur_order INTO po_order_no_;
   CLOSE get_pur_order;

   RETURN po_order_no_;

END Get_Po_Order_No_For_Custord__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   Creates a new instance
PROCEDURE New (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2,
   purchase_type_   IN VARCHAR2,
   qty_on_order_    IN NUMBER DEFAULT 0,
   changed_attrib_not_in_pol_  IN VARCHAR2 DEFAULT NULL)
IS
   attr_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   newrec_     CUSTOMER_ORDER_PUR_ORDER_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('OE_ORDER_NO', oe_order_no_, attr_);
   Client_SYS.Add_To_Attr('OE_LINE_NO', oe_line_no_, attr_);
   Client_SYS.Add_To_Attr('OE_REL_NO', oe_rel_no_, attr_);
   Client_SYS.Add_To_Attr('OE_LINE_ITEM_NO', oe_line_item_no_, attr_);
   Client_SYS.Add_To_Attr('PO_ORDER_NO', po_order_no_, attr_);
   Client_SYS.Add_To_Attr('PO_LINE_NO', po_line_no_, attr_);
   Client_SYS.Add_To_Attr('PO_REL_NO', po_rel_no_, attr_);
   Client_SYS.Add_To_Attr('PURCHASE_TYPE', purchase_type_, attr_);
   Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
   Client_SYS.Add_To_Attr('CHANGED_ATTRIB_NOT_IN_POL', changed_attrib_not_in_pol_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Remove
--   Removes an instance.
PROCEDURE Remove (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER )
IS
   po_order_no_ CUSTOMER_ORDER_PUR_ORDER_TAB.po_order_no%TYPE;
   po_line_no_  CUSTOMER_ORDER_PUR_ORDER_TAB.po_line_no%TYPE;
   po_rel_no_   CUSTOMER_ORDER_PUR_ORDER_TAB.po_rel_no%TYPE;
   remrec_      CUSTOMER_ORDER_PUR_ORDER_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);

   CURSOR get_pur_order_line IS
      SELECT po_order_no, po_line_no, po_rel_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no = oe_line_item_no_;

BEGIN
   OPEN get_pur_order_line;
   FETCH get_pur_order_line INTO po_order_no_, po_line_no_, po_rel_no_;
   CLOSE get_pur_order_line;

   remrec_ := Lock_By_Keys___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                              po_order_no_, po_line_no_, po_rel_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_,
                             oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                             po_order_no_, po_line_no_, po_rel_no_);

   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Connected_Orders_Found
--   Returns TRUE if there is a purchase order or requisition connected
--   to the given order line.
@UncheckedAccess
FUNCTION Connected_Orders_Found (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   found_   NUMBER := 0;
   CURSOR get_item IS
      SELECT po_order_no, po_rel_no, po_line_no, purchase_type
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no = oe_line_item_no_;
BEGIN
   FOR rec_ IN get_item LOOP
      -- Make dynamic call to Purchase Order Line
      IF (rec_.purchase_type = 'O') THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            found_ := Purchase_Order_Line_Part_API.Unmaculated_Exists(rec_.po_order_no, rec_.po_line_no, rec_.po_rel_no); 
         $ELSE
            NULL;
         $END
      -- Make dynamic call to Purchase Requisition Line
      ELSIF (rec_.purchase_type = 'R') THEN
         $IF (Component_Purch_SYS.INSTALLED) $THEN
            found_ := Purchase_Req_Util_API.Line_Instance_Exists(rec_.po_order_no, rec_.po_line_no, rec_.po_rel_no); 
          $ELSE
            NULL;
         $END
         END IF;
   END LOOP;
   RETURN found_;
END Connected_Orders_Found;


-- Modify_From_Purchase
--   This method should be called from purchase order when the link between
--   a customer order line and a purchase requisition/order line needs to
--   be updated.
--   The parameter purchase_type_db_ should be used to indicate if the
--   po_order_no_, po_line_no_, po_rel_no_ are keys to a requsition 'R'
--   or a purchase order 'O'.
--   The link needs to be updated when:
--   1. A purchase order is created from a requisition connected to a
--   customer order line. In this case the requisition keys should be passed
--   in the po_xxx parameters and the keys of the new purchase order
--   should be passed in the new_xxx parameters.
--   purchase_type_db_ should be 'R'.
--   2. A purchase order connected to a customer order line is cancelled.
--   In this case the connection to the purchase requisition should be
--   reestablished. Purchase order keys should be passed in po_xxx
--   parameters and requisition keys should be passed in new_xxx keys.
--   purchase_type_db_ should be 'O'.
PROCEDURE Modify_From_Purchase (
   po_order_no_      IN VARCHAR2,
   po_line_no_       IN VARCHAR2,
   po_rel_no_        IN VARCHAR2,
   new_order_no_     IN VARCHAR2,
   new_line_no_      IN VARCHAR2,
   new_rel_no_       IN VARCHAR2,
   purchase_type_db_ IN VARCHAR2 DEFAULT 'R' )
IS
   oe_order_no_     CUSTOMER_ORDER_PUR_ORDER_TAB.oe_order_no%TYPE;
   oe_line_no_      CUSTOMER_ORDER_PUR_ORDER_TAB.oe_line_no%TYPE;
   oe_rel_no_       CUSTOMER_ORDER_PUR_ORDER_TAB.oe_rel_no%TYPE;
   oe_line_item_no_ CUSTOMER_ORDER_PUR_ORDER_TAB.oe_line_item_no%TYPE;
   objid_           VARCHAR2(2000);
   objversion_      VARCHAR2(2000);
   oldrec_          CUSTOMER_ORDER_PUR_ORDER_TAB%ROWTYPE;
   newrec_          CUSTOMER_ORDER_PUR_ORDER_TAB%ROWTYPE;
   attr_            VARCHAR2(2000);
   indrec_          Indicator_Rec;
   
   CURSOR get_order_from_purch_keys IS
      SELECT oe_order_no, oe_line_no, oe_rel_no, oe_line_item_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  po_order_no = po_order_no_
      AND    po_line_no = po_line_no_
      AND    po_rel_no = po_rel_no_
      AND    purchase_type = purchase_type_db_;

BEGIN
   OPEN get_order_from_purch_keys;
   FETCH get_order_from_purch_keys INTO oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_;
   CLOSE get_order_from_purch_keys;

   oldrec_ := Lock_By_Keys___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                              po_order_no_, po_line_no_, po_rel_no_);
   newrec_ := oldrec_;

   -- Update by keys will not work in this case since we will update some
   -- parts of the key.
   Get_Id_Version_By_Keys___(objid_, objversion_,
                             oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                             po_order_no_, po_line_no_, po_rel_no_);

   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PO_ORDER_NO', new_order_no_, attr_);
   Client_SYS.Add_To_Attr('PO_LINE_NO', new_line_no_, attr_);
   Client_SYS.Add_To_Attr('PO_REL_NO', new_rel_no_, attr_);
   IF (purchase_type_db_ = 'R') THEN
      -- From Requisition to Purchase Order
      Client_SYS.Add_To_Attr('PURCHASE_TYPE_DB', 'O', attr_);
   ELSE
      -- From Purchase Order back to Requisition.
      Client_SYS.Add_To_Attr('PURCHASE_TYPE_DB', 'R', attr_);
   END IF;
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Modify_From_Purchase;


-- Get_Purord_For_Custord
--   Retrieves the purchase order part (incl. purchase_type) of the key for
--   a specific customer order line.
@UncheckedAccess
PROCEDURE Get_Purord_For_Custord (
   po_order_no_     OUT VARCHAR2,
   po_line_no_      OUT VARCHAR2,
   po_rel_no_       OUT VARCHAR2,
   purchase_type_   OUT VARCHAR2,
   oe_order_no_     IN  VARCHAR2,
   oe_line_no_      IN  VARCHAR2,
   oe_rel_no_       IN  VARCHAR2,
   oe_line_item_no_ IN  NUMBER )
IS
   type_ CUSTOMER_ORDER_PUR_ORDER_TAB.purchase_type%TYPE;

   -- purchase order line keys, therefore an extra condition is needed.
   CURSOR get_pur_order IS
      SELECT po_order_no, po_line_no, po_rel_no, purchase_type
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no  = oe_line_item_no_;

BEGIN
   OPEN get_pur_order;
   FETCH get_pur_order INTO po_order_no_, po_line_no_, po_rel_no_, type_;
   IF (get_pur_order%NOTFOUND) THEN
      po_order_no_ := NULL;
   END IF;
   CLOSE get_pur_order;
   purchase_type_ := Purchase_Type_API.Decode(type_);
END Get_Purord_For_Custord;

PROCEDURE Fetch_Po_Info (
   po_order_no_      OUT VARCHAR2,
   po_line_no_       OUT VARCHAR2,
   po_rel_no_        OUT VARCHAR2,
   purchase_type_db_ OUT VARCHAR2,
   poco_needed_      OUT VARCHAR2,
   oe_order_no_      IN  VARCHAR2,
   oe_line_no_       IN  VARCHAR2,
   oe_rel_no_        IN  VARCHAR2,
   oe_line_item_no_  IN  NUMBER )
IS
   CURSOR get_pur_order IS
      SELECT po_order_no, po_line_no, po_rel_no, purchase_type
        FROM CUSTOMER_ORDER_PUR_ORDER_TAB
       WHERE oe_order_no = oe_order_no_
         AND oe_line_no = oe_line_no_
         AND oe_rel_no = oe_rel_no_
         AND oe_line_item_no = oe_line_item_no_;
BEGIN
   poco_needed_ := 'FALSE';
   
   OPEN get_pur_order;
   FETCH get_pur_order INTO po_order_no_, po_line_no_, po_rel_no_, purchase_type_db_;
   CLOSE get_pur_order;
   
   IF (po_order_no_ IS NOT NULL AND purchase_type_db_ = 'O') THEN
      $IF (Component_Purch_SYS.INSTALLED) $THEN
         poco_needed_ := Purchase_Order_Line_API.Check_Poco_Auto(po_order_no_, po_line_no_, po_rel_no_,
                                                                 Purchase_Type_API.Decode(purchase_type_db_));
      $ELSE
         NULL;
      $END
   END IF;  
END Fetch_Po_Info;


-- Get_Purord_For_Custord_Int
--   Retrieves the purchase order part (incl. purchase_type) of the key for a
--   specific customer order line.
PROCEDURE Get_Purord_For_Custord_Int (
   po_order_no_     OUT VARCHAR2,
   po_line_no_      OUT VARCHAR2,
   po_rel_no_       OUT VARCHAR2,
   purchase_type_   OUT VARCHAR2,
   oe_order_no_     IN  VARCHAR2,
   oe_line_no_      IN  VARCHAR2,
   oe_rel_no_       IN  VARCHAR2,
   oe_line_item_no_ IN  NUMBER )
IS
   type_  CUSTOMER_ORDER_PUR_ORDER_TAB.purchase_type%TYPE;

   CURSOR get_pur_order IS
   SELECT po_order_no, po_line_no, po_rel_no, purchase_type
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  oe_order_no      = oe_order_no_
      AND    oe_line_no       = oe_line_no_
      AND    oe_rel_no        = oe_rel_no_
      AND    oe_line_item_no  = oe_line_item_no_;
BEGIN
   OPEN get_pur_order;
   FETCH get_pur_order INTO po_order_no_, po_line_no_, po_rel_no_, type_;
   IF get_pur_order%NOTFOUND THEN
      po_order_no_ := NULL;
   ELSE
      purchase_type_ := Purchase_Type_API.Decode(type_);
   END IF;
   CLOSE get_pur_order;
END Get_Purord_For_Custord_Int;


-- Get_Custord_For_Purord
--   Retrieves the customer order part of the key for a specific purchase
--   order line.
@UncheckedAccess
PROCEDURE Get_Custord_For_Purord (
   oe_order_no_     OUT VARCHAR2,
   oe_line_no_      OUT VARCHAR2,
   oe_rel_no_       OUT VARCHAR2,
   oe_line_item_no_ OUT NUMBER,
   po_order_no_     IN  VARCHAR2,
   po_line_no_      IN  VARCHAR2,
   po_rel_no_       IN  VARCHAR2 )
IS
   -- originated_by will have a value only for internal orders.
   CURSOR get_oerel IS
      SELECT oe_order_no, oe_line_no, oe_rel_no, oe_line_item_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  po_order_no = po_order_no_
      AND    po_line_no = po_line_no_
      AND    po_rel_no = po_rel_no_
      AND    purchase_type = 'O';
BEGIN
   OPEN get_oerel;
   FETCH get_oerel INTO oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_;
   IF (get_oerel%NOTFOUND) THEN
      oe_order_no_ := NULL;
   END IF;
   CLOSE get_oerel;
END Get_Custord_For_Purord;


-- Get_Custord_For_Purreq
--   Retrieves the customer order part of the key for a specific purchase
--   requisition line.
PROCEDURE Get_Custord_For_Purreq (
   oe_order_no_     OUT VARCHAR2,
   oe_line_no_      OUT VARCHAR2,
   oe_rel_no_       OUT VARCHAR2,
   oe_line_item_no_ OUT NUMBER,
   po_order_no_     IN  VARCHAR2,
   po_line_no_      IN  VARCHAR2,
   po_rel_no_       IN  VARCHAR2 )
IS
   CURSOR get_oeorddet IS
      SELECT oe_order_no, oe_line_no, oe_rel_no, oe_line_item_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  po_order_no = po_order_no_
      AND    po_line_no = po_line_no_
      AND    po_rel_no = po_rel_no_
      AND    purchase_type = 'R';
BEGIN
   OPEN get_oeorddet;
   FETCH get_oeorddet INTO oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_;
   IF (get_oeorddet%NOTFOUND) THEN
      oe_order_no_ := NULL;
   END IF;
   CLOSE get_oeorddet;
END Get_Custord_For_Purreq;


-- Get_Oe_Order_No
--   Fetch the oe_order_no for a purchase order line
@UncheckedAccess
FUNCTION Get_Oe_Order_No (
   po_order_no_ IN VARCHAR2,
   po_line_no_  IN VARCHAR2,
   po_rel_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_PUR_ORDER_TAB.oe_order_no%TYPE;
   CURSOR get_attr IS
      SELECT oe_order_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  po_order_no = po_order_no_
      AND    po_line_no = po_line_no_
      AND    po_rel_no = po_rel_no_
      AND    po_rel_no = po_rel_no_
      AND    purchase_type = 'O' ;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Oe_Order_No;


-- Get_Oe_Line_No
--   Fetch the oe_line_no for a purchase order line
@UncheckedAccess
FUNCTION Get_Oe_Line_No (
   po_order_no_ IN VARCHAR2,
   po_line_no_  IN VARCHAR2,
   po_rel_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_PUR_ORDER_TAB.oe_line_no%TYPE;
   CURSOR get_attr IS
      SELECT oe_line_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  po_order_no = po_order_no_
      AND    po_line_no = po_line_no_
      AND    po_rel_no = po_rel_no_
      AND    po_rel_no = po_rel_no_
      AND    purchase_type = 'O' ;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Oe_Line_No;


-- Get_Oe_Rel_No
--   Fetch the oe_rel_no for a purchase order line
@UncheckedAccess
FUNCTION Get_Oe_Rel_No (
   po_order_no_ IN VARCHAR2,
   po_line_no_  IN VARCHAR2,
   po_rel_no_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_ORDER_PUR_ORDER_TAB.oe_rel_no%TYPE;
   CURSOR get_attr IS
      SELECT oe_rel_no
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE  po_order_no = po_order_no_
      AND    po_line_no = po_line_no_
      AND    po_rel_no = po_rel_no_
      AND    po_rel_no = po_rel_no_
      AND    purchase_type = 'O' ;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Oe_Rel_No;


-- Get_Connected_Peggings
--   Returns total number of PO peggings for customer order line.
@UncheckedAccess
FUNCTION Get_Connected_Peggings (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_       NUMBER;
   CURSOR get_pur_order IS
      SELECT count(*)
      FROM   CUSTOMER_ORDER_PUR_ORDER_TAB
      WHERE oe_order_no = oe_order_no_
      AND   oe_line_no = oe_line_no_
      AND   oe_rel_no = oe_rel_no_
      AND   oe_line_item_no = oe_line_item_no_;
BEGIN
   OPEN get_pur_order;
   FETCH get_pur_order INTO temp_;
   CLOSE get_pur_order;
   RETURN temp_;
END Get_Connected_Peggings;


-- Modify
--   Modify the record with the new attributes. If the qty_on_order is zero
--   then delete the record.
PROCEDURE Modify (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2,
   attr_            IN VARCHAR2 )
IS
   objid_            VARCHAR2(2000);
   objversion_       VARCHAR2(2000);
   newattr_          VARCHAR2(32000);
   oldrec_           CUSTOMER_ORDER_PUR_ORDER_TAB%ROWTYPE;
   newrec_           CUSTOMER_ORDER_PUR_ORDER_TAB%ROWTYPE;
   indrec_           Indicator_Rec;
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, oe_order_no_ , oe_line_no_ , oe_rel_no_ ,
                             oe_line_item_no_ , po_order_no_ , po_line_no_, po_rel_no_);
   newattr_ := attr_;

   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Unpack___(newrec_, indrec_, newattr_);
   Check_Update___(oldrec_, newrec_, indrec_, newattr_);
   Update___(objid_, oldrec_, newrec_, newattr_, objversion_);

END Modify;


-- Check_Exist
--   A public Check Exist function.
FUNCTION Check_Exist (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, po_order_no_, po_line_no_, po_rel_no_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- Remove_Line
--   A public method to remove a record.
PROCEDURE Remove_Line (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2 )
IS
   remrec_      CUSTOMER_ORDER_PUR_ORDER_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                              po_order_no_, po_line_no_, po_rel_no_);
   Get_Id_Version_By_Keys___(objid_, objversion_,
                             oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                             po_order_no_, po_line_no_, po_rel_no_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove_Line;


@UncheckedAccess
FUNCTION Get_Total_Qty_On_Order (
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ NUMBER;
   
   CURSOR get_total IS
      SELECT SUM(qty_on_order)
      FROM customer_order_pur_order_tab
      WHERE po_order_no = po_order_no_
      AND   po_line_no = po_line_no_
      AND   po_rel_no = po_rel_no_;
BEGIN
   OPEN get_total;
   FETCH get_total INTO temp_;
   CLOSE get_total;
   RETURN NVL(temp_, 0);
END Get_Total_Qty_On_Order;

@UncheckedAccess
FUNCTION Get_PO_Vendor_No (
   po_order_no_      IN VARCHAR2,
   co_order_no_      IN VARCHAR2,
   co_line_no_       IN VARCHAR2,
   co_rel_no_        IN VARCHAR2,
   co_line_item_no_  IN NUMBER) RETURN VARCHAR2
IS 
   vendor_no_              VARCHAR2(20);
   pur_order_no_           VARCHAR2(12);
   purchase_type_          VARCHAR2(25);
   po_line_no_             VARCHAR2(4);
   po_rel_no_              VARCHAR2(4);
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN
      IF(po_order_no_ IS NOT NULL) THEN 
         vendor_no_ := Purchase_Order_API.Get_Vendor_No(po_order_no_);
      ELSIF(co_order_no_ IS NOT NULL ) THEN
         Get_Purord_For_Custord(pur_order_no_, po_line_no_, po_rel_no_, purchase_type_, co_order_no_, co_line_no_, co_rel_no_, co_line_item_no_);
         vendor_no_ := Purchase_Order_API.Get_Vendor_No(pur_order_no_);
      END IF;
   $ELSE
      NULL; 
   $END
   RETURN vendor_no_;
 END Get_PO_Vendor_No;




