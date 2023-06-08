-----------------------------------------------------------------------------
--
--  Logical unit: ConsolidatedOrders
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130410  MAHPLK Added shipment_id to LU.
--  100513  Ajpelk Merge rose method documentation
------------------------------Eagle-------------------------------------------
--  040211  PrTilk Bug 41402, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New
--   A public New method to insert a row to the consolidated_orders_tab.
PROCEDURE New (
   order_no_      IN VARCHAR2,
   pick_list_no_  IN VARCHAR2,
   shipment_id_   IN NUMBER   )
IS
   attr_       VARCHAR2(2000);
   newrec_     CONSOLIDATED_ORDERS_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('PICK_LIST_NO', pick_list_no_, attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('SHIPMENT_ID', NVL(shipment_id_, 0), attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;



