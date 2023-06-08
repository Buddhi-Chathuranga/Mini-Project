-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrderShopOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  190114  ChBnlk Bug 146301, (SCZ-2625) Added UncheckedAccess annotation to the method Get_Shop_Order. 
--  161101  Rakalk LIM-9419, Added handling unti id parameter to CustomerOrderShopOrder Feedback_From_Manufacturing.
--  160713  MaRalk STRSC-2839, Added annotation UncheckedAccess to Connected_Orders_Found method.
--  140131  RoJalk Modified Check_Insert___ and used indrec_ when fetching a value for qty_on_order. 
--  130705  MaIklk TIBE-987, Removed inst_ShopOrd_ and inst_ShopOrdUtil_ global constants and used conditional compilation.
--  130610  PraWlk Bug 110506, Moved view CUST_ORDER_SHOP_ORDER_PEG here from PegCustomerOrder LU to support custom fields in client.
--  120314  DaZase Removed last TRUE parameter in Init_Method call inside Remove.
--  120124  ChFolk Added NOCHECK to the ShopOrd refernce as it should be possible to delete the connected Shop Order.
--  100519  KRPELK Merge Rose Method Documentation.
--  100201  UTSWLK Bug 87214, Modified methd Connected_Orders_Found to return the correct value.
--  100114  KAYOLK Modified the method Update_Configuration and Connected_Orders_Found, such that the
--  100114         Shop_Order_Int_API calls were replaced BY Shop_Ord_Util_API
--  091120  MaRalk Added reference ShopOrd to so_sequence_no in CUSTOMER_ORDER_SHOP_ORDER view and modified Unpack_Check_Insert___.
--  090923  MaMalk Removed unused function Connected_Shop_Orders_Found. 
----------------------------- 14.0.0 -----------------------------------------
--  091126  ChJalk Bug 86871, Removed General_SYS.Init_Method in Function Get_Connected_Peggings.
--  081127  ThAylk Bug 77298, Added procedure Remove.
--  080811  SudJlk Added PRAGMA restrict_references and removed General_SYS.Init_Method in procedures Check_Cust_Ord_For_Shop_Ord and Get_Shop_Order_Origin.
--  080405  MaRalk Bug 72388, Modified cursor get_order in procedure Feedback_From_Manufacturing.
--  060125  JaJalk Added Assert safe annotation.
--  060111  MaHplk Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  050526  JeLise Bug 51396, Removed the part in Modify where data in the table is removed when qty_on_order is zero.
--  050607  RaSilk Added Update_Configuration.
--  040723  MaMalk Bug 45507, Restructured the procedure Remove_Cancelled_Order in order to delete the customer_order_shop_order
--  040723         instance when the customer order line is cancelled.
--  040419  VeMolk Bug 42947, Corrected the arguments passed to a method call in Get_Shop_Order_Origin.
--  040126  GeKalk Rewrote the DBMS_SQL to Native dynamic SQL for UNICODE modifications.
--  031008  PrJalk Bug Fix 106224, Added missing General_Sys.Init_Method calls.
--  030519  SudWlk Beautified the newly added code.
--  030421  SudWlk Added a new public function, Check_Cust_Ord_For_Shop_Ord.
--  030403  PrTilk Added a new public CheckExist function.
--  030331  PrTilk Beautified function Get_Connected_Peggings.
--  030331  SudWlk Removed Obsolete attribute, 'Date_Entered'.
--  030328  AnJplk Modified method Get_Connected_Peggings.
--  030320  SudWlk Removed method, Connected_Shop_Orders_Found.
--  030320  PrTilk Added a new public method,Get_Connected_Peggings. Removed Method Check_One_Pegging_Exist.
--  030320  GeKaLk Modified public method Modify.
--  030320  SudWlk Added a new public method, Connected_Shop_Orders_Found.
--  030319  AnJplk Removed view CUST_ORDER_SHOP_ORDER_PEG from the LU.
--  030319  PrTiLk Removed methods Modify_Qty_On_Order,Modify_Qty_For_Reserve and Added a new public Modify Method.
--  030319  GeKaLk Done code review modifications.
--  030318  AnJplk supply_code,supply_code_db columns are added to the view CUST_ORDER_SHOP_ORDER_PEG.
--  030317  PrTilk Added 2 new public methods, Check_One_Pegging_Exist and Modify_Qty_For_Reserve.
--  030314  AnJplk Modified view CUST_ORDER_SHOP_ORDER_PEG.
--  030311  AnJplk Renamed CUSTOMER_ORDER_SHOP_ORDER1 to CUST_ORDER_SHOP_ORDER_PEG.
--  030307  GeKaLk Added a new public Method Modify_Qty_On_Order.
--  030306  AnJplk Added new view CUSTOMER_ORDER_SHOP_ORDER1.
--  030305  GeKaLk Added a new public attribute qty_on_rder to Procedure New.
--  030305  GeKaLk Added a new public attribute to the customer_order_shop_order_tab.
--  010524  ViPa  Bug fix 19701, Since the return type of the function Connected_Orders_Found
--                was changed from BOOLEAN to VARCHAR2 in api file, added corresponding changes to the same function.
--  010413  JaBa  Bug Fix 20598,Added a new global lu constant inst_ShopOrd_.
--  000913  FBen  Added UNDEFINE.
--  000425  PaLj  Changed check for installed logical units. A check is made when API is instantiatet.
--                See beginning of api-file.
------------------------------- 12.0 ----------------------------------------
--  990409  RaKu  New templates.
--  990323  JICE  Added public method Any_Line_Connected.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  971124  RaKu  Changed to FND200 Templates.
--  970312  RaKu  Changed tablename.
--  960218  PAZE  Changed rowversion (10.3 poject)
--  960418  PARO  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_order_shop_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (NOT indrec_.qty_on_order) THEN
      newrec_.qty_on_order := NVL(newrec_.qty_on_order, 0);
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Shop_Order_Origin
--   Fetch the customer order part for a shop order item.
@UncheckedAccess
PROCEDURE Get_Shop_Order_Origin (
   oe_order_no_     OUT VARCHAR2,
   oe_rel_no_       OUT VARCHAR2,
   oe_line_no_      OUT VARCHAR2,
   oe_line_item_no_ OUT NUMBER,
   so_order_no_     IN  VARCHAR2,
   so_release_no_   IN  VARCHAR2,
   so_sequence_no_  IN  VARCHAR2 )
IS
   CURSOR get_record IS
      SELECT oe_order_no, oe_rel_no, oe_line_no, oe_line_item_no
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  so_order_no    = so_order_no_
      AND    so_release_no  = so_release_no_
      AND    so_sequence_no = so_sequence_no_;
   supply_code_   VARCHAR2(3);

BEGIN
   FOR rec_ IN get_record LOOP
      supply_code_ := Order_Supply_Type_API.Encode(Customer_Order_Line_API.Get_Supply_Code(rec_.oe_order_no,
                                                                                           rec_.oe_line_no,
                                                                                           rec_.oe_rel_no,
                                                                                           rec_.oe_line_item_no));
      IF (supply_code_ != 'IO') THEN
         oe_order_no_ := rec_.oe_order_no;
         oe_rel_no_ := rec_.oe_rel_no;
         oe_line_no_ := rec_.oe_line_no;
         oe_line_item_no_ := rec_.oe_line_item_no;
      END IF;
   END LOOP;
END Get_Shop_Order_Origin;


-- Connected_Orders_Found
--   Checks existance of a shop order item for a given customer order line.
@UncheckedAccess
FUNCTION Connected_Orders_Found (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER ) RETURN VARCHAR2
IS
   found_   VARCHAR2(5) := 'FALSE';
   temp_    NUMBER;
   CURSOR get_item IS
      SELECT so_order_no, so_release_no, so_sequence_no
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no = oe_line_item_no_;
BEGIN
   -- Make dynamic call to Shop Ord to check if connected orders exist
   $IF (Component_Shpord_SYS.INSTALLED) $THEN
      FOR rec_ IN get_item LOOP
         temp_ := Shop_Ord_Util_API.Instance_Exists(rec_.so_order_no, rec_.so_release_no, rec_.so_sequence_no);      
      END LOOP;
   $END
   IF (temp_ = 1) THEN
      found_ := 'TRUE';
   END IF;
   RETURN (found_);

END Connected_Orders_Found;


-- Feedback_From_Manufacturing
--   Calls Feedback_From_Manufacturing in CustomerOrderLine for a shop order
--   item, and finally returns qty_reserved.
PROCEDURE Feedback_From_Manufacturing (
   qty_reserved_     IN OUT NUMBER,
   so_order_no_      IN     VARCHAR2,
   so_release_no_    IN     VARCHAR2,
   so_sequence_no_   IN     VARCHAR2,
   contract_         IN     VARCHAR2,
   part_no_          IN     VARCHAR2,
   manufactured_qty_ IN     NUMBER,
   location_no_      IN     VARCHAR2,
   lot_batch_no_     IN     VARCHAR2,
   serial_no_        IN     VARCHAR2,
   eng_chg_level_    IN     VARCHAR2,
   waiv_dev_rej_no_  IN     VARCHAR2,
   configuration_id_ IN     VARCHAR2 DEFAULT NULL,
   activity_seq_     IN     NUMBER   DEFAULT NULL,
   handling_unit_id_ IN     NUMBER   DEFAULT 0 )
IS
   CURSOR get_order IS
      SELECT cs.oe_order_no, cs.oe_line_no, cs.oe_rel_no, cs.oe_line_item_no
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB cs, customer_order_line_tab co 
      WHERE  cs.so_order_no = so_order_no_
      AND    cs.so_sequence_no = so_sequence_no_            
      AND    cs.so_release_no = so_release_no_
      AND    cs.oe_order_no = co.order_no
      AND    cs.oe_line_no = co.line_no
      AND    cs.oe_rel_no = co.rel_no
      AND    cs.oe_line_item_no = co.line_item_no
      AND    co.rowstate != 'Cancelled';  
BEGIN
   FOR rec_ IN get_order LOOP
      Reserve_Customer_Order_API.Feedback_From_Manufacturing(
         qty_reserved_,
         rec_.oe_order_no,
         rec_.oe_line_no,
         rec_.oe_rel_no,
         rec_.oe_line_item_no,
         contract_,
         part_no_,
         manufactured_qty_,
         location_no_,
         lot_batch_no_,
         serial_no_,
         eng_chg_level_,
         waiv_dev_rej_no_,
         configuration_id_,
         activity_seq_,
         handling_unit_id_);
   END LOOP;
END Feedback_From_Manufacturing;


-- Get_Shop_Order
--   Fetch the shop order part for a customer order item
@UncheckedAccess
PROCEDURE Get_Shop_Order (
   so_order_no_     OUT VARCHAR2,
   so_release_no_   OUT VARCHAR2,
   so_sequence_no_  OUT VARCHAR2,
   oe_order_no_     IN  VARCHAR2,
   oe_line_no_      IN  VARCHAR2,
   oe_rel_no_       IN  VARCHAR2,
   oe_line_item_no_ IN  NUMBER )
IS
   CURSOR get_record IS
      SELECT so_order_no, so_release_no, so_sequence_no
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no = oe_line_item_no_;
BEGIN
   OPEN get_record;
   FETCH get_record INTO so_order_no_, so_release_no_, so_sequence_no_;
   CLOSE get_record;
END Get_Shop_Order;


-- Item_Exists
--   Return TRUE or FALSE whether or not shop order line exists.
@UncheckedAccess
FUNCTION Item_Exists (
   so_order_no_    IN VARCHAR2,
   so_release_no_  IN VARCHAR2,
   so_sequence_no_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ BOOLEAN;
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  so_order_no = so_order_no_
      AND    so_release_no = so_release_no_
      AND    so_sequence_no = so_sequence_no_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   found_ := exist_control%FOUND;
   CLOSE exist_control;
   RETURN found_;
END Item_Exists;


-- New
--   Creates a new instance.
PROCEDURE New (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_release_no_   IN VARCHAR2,
   so_sequence_no_  IN VARCHAR2,
   qty_on_order_    IN NUMBER DEFAULT 0 )
IS
   attr_       VARCHAR2(2000);
   newrec_     CUSTOMER_ORDER_SHOP_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Prepare_Insert___(attr_);
   Client_SYS.Add_To_Attr('OE_ORDER_NO', oe_order_no_, attr_);
   Client_SYS.Add_To_Attr('OE_LINE_NO', oe_line_no_, attr_);
   Client_SYS.Add_To_Attr('OE_REL_NO', oe_rel_no_, attr_);
   Client_SYS.Add_To_Attr('OE_LINE_ITEM_NO', oe_line_item_no_, attr_);
   Client_SYS.Add_To_Attr('SO_ORDER_NO', so_order_no_, attr_);
   Client_SYS.Add_To_Attr('SO_RELEASE_NO', so_release_no_, attr_);
   Client_SYS.Add_To_Attr('SO_SEQUENCE_NO', so_sequence_no_, attr_);
   Client_SYS.Add_To_Attr('QTY_ON_ORDER', qty_on_order_, attr_);
   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Remove_Cancelled_Order
--   Removes an instance when the customer order line is cancelled
PROCEDURE Remove_Cancelled_Order (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER )
IS
   remrec_     CUSTOMER_ORDER_SHOP_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   CURSOR get_record IS
      SELECT so_order_no, so_release_no, so_sequence_no
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no = oe_line_item_no_;
BEGIN
   FOR rec_ IN get_record LOOP
      remrec_ := Lock_By_Keys___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                                 rec_.so_order_no, rec_.so_release_no, rec_.so_sequence_no);
      Check_Delete___(remrec_);
      Get_Id_Version_By_Keys___(objid_, objversion_, oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                                rec_.so_order_no, rec_.so_release_no, rec_.so_sequence_no);
      Delete___(objid_, remrec_);
   END LOOP;
END Remove_Cancelled_Order;


-- Any_Line_Connected
--   Returns 1 if any line on the customer order has a connected shop order,
--   otherwise 0.
@UncheckedAccess
FUNCTION Any_Line_Connected (
   order_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   return_ NUMBER := 0;

   CURSOR find_order IS
      SELECT 1
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  oe_order_no = order_no_;

BEGIN
   OPEN find_order;
   FETCH find_order INTO return_;
   IF find_order%NOTFOUND THEN
      return_ := 0;
   END IF;
   CLOSE find_order;
   RETURN return_;
END Any_Line_Connected;


-- Get_Connected_Peggings
--   Returns total number of SO peggings for customer order line.
@UncheckedAccess
FUNCTION Get_Connected_Peggings (
   oe_order_no_      IN VARCHAR2,
   oe_line_no_       IN VARCHAR2,
   oe_rel_no_        IN VARCHAR2,
   oe_line_item_no_  IN NUMBER ) RETURN NUMBER
IS
   temp_       NUMBER;
   CURSOR get_shop_order IS
      SELECT count(*)
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE oe_order_no = oe_order_no_
      AND   oe_line_no = oe_line_no_
      AND   oe_rel_no = oe_rel_no_
      AND   oe_line_item_no = oe_line_item_no_;
BEGIN
   OPEN get_shop_order;
   FETCH get_shop_order INTO temp_;
   CLOSE get_shop_order ;
   RETURN temp_;
END Get_Connected_Peggings;


-- Modify
--   Public Modify Method.
PROCEDURE Modify (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_release_no_   IN VARCHAR2,
   so_sequence_no_  IN VARCHAR2,
   attr_            IN VARCHAR2 )
IS
   info_         VARCHAR2(2000);
   objid_        VARCHAR2(2000);
   objversion_   VARCHAR2(2000);
   newattr_      VARCHAR2(32000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, oe_order_no_ , oe_line_no_ , oe_rel_no_ ,
                             oe_line_item_no_ , so_order_no_ , so_release_no_, so_sequence_no_);
   newattr_ := attr_;
   Modify__(info_, objid_, objversion_, newattr_, 'DO');
END Modify;


-- Check_Exist
--   A public Check Exist function.
FUNCTION Check_Exist (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_release_no_   IN VARCHAR2,
   so_sequence_no_  IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (Check_Exist___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_, so_order_no_, so_release_no_, so_sequence_no_)) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Check_Exist;


-- Check_Cust_Ord_For_Shop_Ord
--   Returns 1 if there are customer orders connected to the given shop order line.
--   Returns 0 otherwise
@UncheckedAccess
FUNCTION Check_Cust_Ord_For_Shop_Ord (
   so_order_no_    IN VARCHAR2,
   so_release_no_  IN VARCHAR2,
   so_sequence_no_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_      NUMBER;
   ret_value_  NUMBER;
   CURSOR get_cust_order IS
      SELECT 1
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  so_order_no = so_order_no_
      AND    so_release_no = so_release_no_
      AND    so_sequence_no = so_sequence_no_;
BEGIN
   OPEN get_cust_order;
   FETCH get_cust_order INTO dummy_;
   IF (get_cust_order %NOTFOUND) THEN
      ret_value_ := 0;
   ELSE
      ret_value_ := 1;
   END IF;
   CLOSE get_cust_order ;
   RETURN ret_value_;
END Check_Cust_Ord_For_Shop_Ord;


-- Update_Configuration
--   Updates the configuration of the connected Shop Order lines for the given
--   Customer Order Line.
PROCEDURE Update_Configuration (
   oe_order_no_      IN VARCHAR2,
   oe_line_no_       IN VARCHAR2,
   oe_rel_no_        IN VARCHAR2,
   oe_line_item_no_  IN NUMBER,
   configuration_id_ IN VARCHAR2 )
IS
   CURSOR get_shop_orders IS
      SELECT so_order_no, so_release_no, so_sequence_no
      FROM   CUSTOMER_ORDER_SHOP_ORDER_TAB
      WHERE  oe_order_no = oe_order_no_
      AND    oe_line_no = oe_line_no_
      AND    oe_rel_no = oe_rel_no_
      AND    oe_line_item_no = oe_line_item_no_;   
BEGIN
   $IF (Component_Shpord_SYS.INSTALLED) $THEN     
      FOR shop_order_ IN get_shop_orders LOOP
         Shop_Ord_Util_API.Update_Config_For_Oe(shop_order_.so_order_no, shop_order_.so_release_no, shop_order_.so_sequence_no, configuration_id_);
      END LOOP;
   $ELSE
      NULL;
   $END
END Update_Configuration;


-- Remove
--   A public method to remove a record.
PROCEDURE Remove (
   oe_order_no_     IN VARCHAR2,
   oe_line_no_      IN VARCHAR2,
   oe_rel_no_       IN VARCHAR2,
   oe_line_item_no_ IN NUMBER,
   so_order_no_     IN VARCHAR2,
   so_release_no_   IN VARCHAR2,
   so_sequence_no_  IN VARCHAR2 )
IS
   remrec_     CUSTOMER_ORDER_SHOP_ORDER_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                              so_order_no_, so_release_no_, so_sequence_no_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, oe_order_no_, oe_line_no_, oe_rel_no_, oe_line_item_no_,
                             so_order_no_, so_release_no_, so_sequence_no_);
   Delete___(objid_, remrec_);
END Remove;



