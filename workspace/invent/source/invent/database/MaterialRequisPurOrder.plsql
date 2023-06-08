-----------------------------------------------------------------------------
--
--  Logical unit: MaterialRequisPurOrder
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160321  KiSalk  Bug 127655, Added function Connected_Po_Line_Cancelled.
--  130515  IsSalk  Bug 106680, Replaced Installed_Component_SYS.<component> with Component_<component>_SYS.<component>.
--  120319  ErFelk  Bug 101542, Modified Remove_Purchase_Link___ to check PO line state so that  
--  120319          POEXIST message could be skipped when PO line is Cancelled. And Purchase
--  120319          requisition line needs to be removed only if purchase_type_ is 'R'.  
--  120123  MoIflk  Bug 100428, Renamed the procedure Modify_Purreq_To_Purord to Modify_Purchase_Information, 
--  120123          added new parameter requis_to_order_ and modified procedure Remove_Purchase_Link___ to 
--  120123          avoid unnecessary errors when removing the purchase link.
--  111207  MAHPLK  Removed General_SYS.Init_Method from Get_Purchase_Link.
--  100519  MaMalk  Added reference to line_item_no to define the aggregation between MaterialRequisLine and MaterialRequisPurOrder.
--  100505  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  081201  NWeelk  Bug 78207, added method Connected_To_Open_Purord_Line. 
--  080402  NuVelk  Bug ID 72577, added method Connected_To_Purchase_Order.
--  080125  NuVelk  Added new implementation method Remove_Purchase_Link___ 
--  080125          and called it from Delete___.
--  060119  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  050921  NiDalk  Removed unused variables.
--  040302  GeKalk  Removed substrb from views for UNICODE modifications.
--  ---------------- 13.3.0 ---------------------------------------------------
--  000925  JOHESE  Added undefines.
--  000403  NISOSE  Modified Get_Purchase_Link.
--  990421  DAZA    General performance improvements.
--  990414  DAZA    Upgraded to performance optimized template.
--  971201  GOPE    Upgrade to fnd 2.0
--  970618  JOED    Added _db column in the view.
--  970313  CHAN    Changed table name: mpc_intpo_order is replaced by
--                  material_requis_pur_order_tab
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  961210  PEKR    ROSE and Workbench adaptation.
--  961127  GOPE    Change call to supplier get_vendor_name
--  961126  SHVE    Replaced Purchase_Requis_Line_Api.Get_Purchase_Order_Info
--                  with calls to individual functions.
--  961125  AnAr    Removed Call Material_Requis_Line_Api.Get_Order_No.
--  961121  GOPE    Redirect call to purchase_order_line_part
--  961110  GOPE    Rational Rose correctons due to changes in Purchase Order Line
--  961030  GOPE    Rational Rose correction in call to supplier_api
--  960918  LEPE    Added exception handling for dynamic SQL.
--  960820  JOKE    Corrected my last changes.
--  960819  JOKE    Altered all purchase_type because purchase_type now has
--                  client value in view.
--  960704  JICE    Changed number of arguments for bind on numeric columns.
--  960625  JICE    Modified call to Get_Purchase_Order_Info in PurchaseRequisLine
--  960624  JICE    Modified call to Get_Purchase_Order_Info in PurchaseRequisLine
--  960624  MAOS    Modified dynamic SQL.
--  960618  MAOS    Replaced call to PURCH with dynamic SQL in procedure
--                  Get_Intpo_Data.
--  960515  SHVE    Added method Get_Intorder_Info.
--  960331  JICE    Changed call to Get_Purchase_Order_Info in PurchaseRequisLine
--  960327  SHVE    Added procedure New_Req_PO.
--  960307  JICE    Renamed from IntpoOrder
--  951102  BJSA    Base Table to Logical Unit Generator 1.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Remove_Purchase_Link___
--   Removes the purchase requisition lines connected to MR
PROCEDURE Remove_Purchase_Link___ (
   po_order_no_   IN VARCHAR2,
   po_line_no_    IN VARCHAR2,
   po_rel_no_     IN VARCHAR2,
   purchase_type_ IN VARCHAR2 )
IS
   purch_order_line_objstate_ VARCHAR2(20);
BEGIN

   $IF (Component_Purch_SYS.INSTALLED) $THEN
      purch_order_line_objstate_ := Purchase_Order_Line_API.Get_Objstate(po_order_no_, po_line_no_, po_rel_no_);
      IF ((purchase_type_ = 'O') AND (purch_order_line_objstate_ != 'Cancelled')) THEN
         Error_SYS.Record_General(lu_name_, 'POEXIST: Modification is not allowed when Purchase Order Line is created.');
      END IF; 
      IF (purchase_type_ = 'R') THEN 
         Purchase_Req_Util_API.Remove_Line_part(po_order_no_, po_line_no_, po_rel_no_); 
      END IF;
   $ELSE
      Error_SYS.Record_General(lu_name_,'PURCHNOTINST: PurchaseOrderLine/PurchaseReqUtil is not installed. Execution aborted.');
   $END

END Remove_Purchase_Link___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE )
IS
BEGIN
   Remove_Purchase_Link___(remrec_.po_order_no, remrec_.po_line_no, remrec_.po_rel_no, remrec_.purchase_type);
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT material_requis_pur_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Material_Requis_Line_API.Exist(Material_Requis_Type_API.Decode(newrec_.order_class), newrec_.order_no,
      newrec_.line_no, newrec_.release_no, newrec_.line_item_no);
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Material_Requis_Link
--   Gets the connected material requisition line for the given purchase order line.
PROCEDURE Get_Material_Requis_Link (
   order_no_       OUT VARCHAR2,
   line_no_        OUT VARCHAR2,
   release_no_     OUT VARCHAR2,
   line_item_no_   OUT NUMBER,
   order_class_    OUT VARCHAR2,
   po_order_no_    IN  VARCHAR2,
   po_line_no_     IN  VARCHAR2,
   po_rel_no_      IN  VARCHAR2,
   purchase_type_  IN  VARCHAR2 )
IS
   purchase_type_db_   MATERIAL_REQUIS_PUR_ORDER_TAB.purchase_type%TYPE;
   CURSOR get_mtrl_req_link IS
      SELECT order_no, line_no, release_no, line_item_no, order_class
      FROM   MATERIAL_REQUIS_PUR_ORDER_TAB
      WHERE  po_order_no   = po_order_no_
      AND    po_line_no    = po_line_no_
      AND    po_rel_no     = po_rel_no_
      AND    purchase_type = purchase_type_db_;
BEGIN
   purchase_type_db_ := Purchase_Type_API.Encode(purchase_type_);
   OPEN get_mtrl_req_link;
   FETCH get_mtrl_req_link
   INTO order_no_, line_no_, release_no_, line_item_no_, order_class_;
   CLOSE get_mtrl_req_link;
   order_class_ := Material_Requis_Type_API.Decode(order_class_);
END Get_Material_Requis_Link;


-- Get_Purchase_Link
--   Gets the purchase order line for the given material requisition line.
@UncheckedAccess
PROCEDURE Get_Purchase_Link (
   po_order_no_   OUT VARCHAR2,
   po_line_no_    OUT VARCHAR2,
   po_rel_no_     OUT VARCHAR2,
   purchase_type_ OUT VARCHAR2,
   order_no_      IN  VARCHAR2,
   line_no_       IN  VARCHAR2,
   release_no_    IN  VARCHAR2,
   line_item_no_  IN  NUMBER,
   order_class_   IN VARCHAR2 )
IS
   lurec_   MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE;
   order_class_db_   MATERIAL_REQUIS_PUR_ORDER_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   IF (Check_Exist___(order_no_, line_no_, release_no_, line_item_no_, order_class_db_)) THEN
      lurec_ := Get_Object_By_Keys___(order_no_, line_no_, release_no_, line_item_no_, order_class_db_);
      po_order_no_ := lurec_.po_order_no;
      po_line_no_ := lurec_.po_line_no;
      po_rel_no_ := lurec_.po_rel_no;
      purchase_type_ := lurec_.purchase_type;
   END IF;
END Get_Purchase_Link;


-- Remove
--   Deletes the given instance.
PROCEDURE Remove (
   order_no_      IN VARCHAR2,
   line_no_       IN VARCHAR2,
   release_no_    IN VARCHAR2,
   line_item_no_  IN NUMBER,
   order_class_   IN VARCHAR2 )
IS
   remrec_      MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE;
   objid_       MATERIAL_REQUIS_PUR_ORDER.objid%TYPE;
   objversion_  MATERIAL_REQUIS_PUR_ORDER.objversion%TYPE;
   order_class_db_ MATERIAL_REQUIS_PUR_ORDER_TAB.order_class%TYPE;
BEGIN
   order_class_db_ := Material_Requis_Type_API.Encode(order_class_);
   IF (Check_Exist___(order_no_, line_no_, release_no_, line_item_no_, order_class_db_)) THEN
      remrec_ := Get_Object_By_Keys___(order_no_, line_no_, release_no_, line_item_no_, order_class_db_);
      Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, release_no_, line_item_no_, order_class_db_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
END Remove;


PROCEDURE Modify_Purchase_Information (
   requisition_no_  IN VARCHAR2,
   line_no_         IN VARCHAR2,
   release_no_      IN VARCHAR2,
   po_order_no_     IN VARCHAR2,
   po_line_no_      IN VARCHAR2,
   po_rel_no_       IN VARCHAR2,
   requis_to_order_ IN BOOLEAN )
IS
   attr_            VARCHAR2(2000);
   newrec_          MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE;
   objversion_      MATERIAL_REQUIS_PUR_ORDER.objversion%TYPE;
   objid_           MATERIAL_REQUIS_PUR_ORDER.objid%TYPE;
   indrec_          Indicator_Rec;
   
   CURSOR get_purreq_link IS
      SELECT *
      FROM   MATERIAL_REQUIS_PUR_ORDER_TAB
      WHERE  po_order_no   = requisition_no_ 
      AND    po_line_no    = line_no_
      AND    po_rel_no     = release_no_
      AND    purchase_type = 'R'
      FOR UPDATE;

   CURSOR get_purord_link IS
      SELECT *
      FROM   MATERIAL_REQUIS_PUR_ORDER_TAB
      WHERE  po_order_no   = po_order_no_ 
      AND    po_line_no    = po_line_no_
      AND    po_rel_no     = po_rel_no_
      AND    purchase_type = 'O'
      FOR UPDATE;
            
BEGIN

   IF requis_to_order_ THEN
     FOR oldrec_ IN get_purreq_link LOOP
        newrec_ := oldrec_;
               
        Client_SYS.Clear_Attr(attr_);
        Client_SYS.Add_To_Attr('PO_ORDER_NO',po_order_no_, attr_);
        Client_SYS.Add_To_Attr('PO_LINE_NO',po_line_no_, attr_);
        Client_SYS.Add_To_Attr('PO_REL_NO',po_rel_no_, attr_);
        Client_SYS.Add_To_Attr('PURCHASE_TYPE_DB','O', attr_);

        Unpack___(newrec_, indrec_, attr_);
        Check_Update___(oldrec_, newrec_, indrec_, attr_);
        Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
     END LOOP;
   ELSE
     FOR oldrec_ IN get_purord_link LOOP
        newrec_ := oldrec_;
        
        Client_SYS.Clear_Attr(attr_);
        Client_SYS.Add_To_Attr('PO_ORDER_NO',requisition_no_, attr_);
        Client_SYS.Add_To_Attr('PO_LINE_NO',line_no_, attr_);
        Client_SYS.Add_To_Attr('PO_REL_NO',release_no_, attr_);
        Client_SYS.Add_To_Attr('PURCHASE_TYPE_DB','R', attr_);

        Unpack___(newrec_, indrec_, attr_);
        Check_Update___(oldrec_, newrec_, indrec_, attr_);
        Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
     END LOOP;
   END IF;
   
END Modify_Purchase_Information;


PROCEDURE New (
   order_no_      IN     VARCHAR2,
   line_no_       IN     VARCHAR2,
   release_no_    IN     VARCHAR2,
   line_item_no_  IN     NUMBER,
   order_class_   IN     VARCHAR2,
   po_order_no_   IN     VARCHAR2,
   po_line_no_    IN     VARCHAR2,
   po_release_no_ IN     VARCHAR2 )
IS
   objversion_   MATERIAL_REQUIS_PUR_ORDER.objversion%TYPE;
   objid_        MATERIAL_REQUIS_PUR_ORDER.objid%TYPE;
   attr_         VARCHAR2(32000);
   newrec_       MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE;
   indrec_       Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr( 'ORDER_NO', order_no_, attr_ );
   Client_SYS.Add_To_Attr( 'LINE_NO', line_no_, attr_ );
   Client_SYS.Add_To_Attr( 'RELEASE_NO', release_no_, attr_ );
   Client_SYS.Add_To_Attr( 'LINE_ITEM_NO', line_item_no_, attr_ );
   Client_SYS.Add_To_Attr( 'ORDER_CLASS', order_class_, attr_ );
   Client_SYS.Add_To_Attr( 'PO_ORDER_NO', po_order_no_, attr_ );
   Client_SYS.Add_To_Attr( 'PO_LINE_NO', po_line_no_, attr_ );
   Client_SYS.Add_To_Attr( 'PO_REL_NO', po_release_no_, attr_ );
   Client_SYS.Add_To_Attr( 'PURCHASE_TYPE_DB', 'R', attr_ );

   Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Connected_To_Purchase_Order
--   Returns TRUE if MaterialRequisLine is connected to a Purchase Order
@UncheckedAccess
FUNCTION Connected_To_Purchase_Order (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   release_no_      IN VARCHAR2,
   line_item_no_    IN NUMBER,
   order_class_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   lurec_           MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE;
   connected_to_po_ BOOLEAN := FALSE;
   po_created_      VARCHAR2(5):= 'FALSE';
   stmt_            VARCHAR2(2000);
BEGIN   
   lurec_ := Get_Object_By_Keys___(order_no_,
                                   line_no_,
                                   release_no_,
                                   line_item_no_,
                                   order_class_db_);

   IF (lurec_.purchase_type = 'O') THEN
      connected_to_po_ := TRUE;
   ELSIF (lurec_.purchase_type = 'R') THEN 
      stmt_ := '
               DECLARE
                  po_created_    BOOLEAN;
               BEGIN
                  po_created_ := Purchase_Req_Line_Part_API.Purchase_Order_Created( :requisition_no, :line_no, :release_no);

                  IF (po_created_) THEN
                     :po_created := ''TRUE'';
                  END IF;
               END;';

      @ApproveDynamicStatement(2008-04-15,NuVelk)
      EXECUTE IMMEDIATE stmt_ USING         
         IN   lurec_.po_order_no,
         IN   lurec_.po_line_no,
         IN   lurec_.po_rel_no,
         OUT  po_created_;
                        
      IF (po_created_ = 'TRUE') THEN
         connected_to_po_ := TRUE;
      END IF;
   END IF;
   
   RETURN connected_to_po_;
END Connected_To_Purchase_Order;


FUNCTION Connected_To_Open_Purord_Line(
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   release_no_      IN VARCHAR2,
   line_item_no_    IN NUMBER,
   order_class_db_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   lurec_           MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE;
   open_po_line_    BOOLEAN := FALSE;     
   stmt_            VARCHAR2(2000); 
   is_closed_       NUMBER;
   
BEGIN   
   IF (Connected_To_Purchase_Order(order_no_,
                                   line_no_,
                                   release_no_,
                                   line_item_no_,
                                   order_class_db_)) THEN
      lurec_ := Get_Object_By_Keys___(order_no_,
                                      line_no_,
                                      release_no_,
                                      line_item_no_,
                                      order_class_db_);
    
      stmt_ := '
               BEGIN
                  :is_closed_ := Purchase_Order_Line_Part_API.Is_Closed(:po_order_no, :po_line_no, :po_rel_no);
               END;';
      @ApproveDynamicStatement(2008-12-01,NWeelk)
      EXECUTE IMMEDIATE stmt_
         USING
            OUT      is_closed_,
            IN       lurec_.po_order_no,
            IN       lurec_.po_line_no,
            IN       lurec_.po_rel_no;   
     
      IF (is_closed_ = 0) THEN
         open_po_line_ := TRUE;
      END IF;
   END IF;
   RETURN open_po_line_;
END Connected_To_Open_Purord_Line;

FUNCTION Connected_Po_Line_Cancelled (
   order_no_        IN VARCHAR2,
   line_no_         IN VARCHAR2,
   release_no_      IN VARCHAR2,
   line_item_no_    IN NUMBER,
   order_class_db_  IN VARCHAR2 ) RETURN NUMBER
IS
   lurec_             MATERIAL_REQUIS_PUR_ORDER_TAB%ROWTYPE;
   cancelled_po_line_ NUMBER := 0;
   objstate_          VARCHAR2(200);
BEGIN   

   lurec_ := Get_Object_By_Keys___(order_no_,
                                   line_no_,
                                   release_no_,
                                   line_item_no_,
                                   order_class_db_);

   $IF Component_Purch_SYS.INSTALLED $THEN
      IF lurec_.po_order_no IS NOT NULL THEN
         objstate_ := Purchase_Order_Line_API.Get_Objstate(lurec_.po_order_no, lurec_.po_line_no, lurec_.po_rel_no);
      END IF;
   $END

   IF (objstate_ = 'Cancelled') THEN
      cancelled_po_line_ := 1;
   END IF;

   RETURN cancelled_po_line_;
END Connected_Po_Line_Cancelled;


