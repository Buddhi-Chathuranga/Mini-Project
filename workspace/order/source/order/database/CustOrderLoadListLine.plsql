-----------------------------------------------------------------------------
--
--  Logical unit: CustOrderLoadListLine
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191001  SURBLK  Added Raise_Edit_Restrict_Error___ to handle error messages and avoid code duplication.
--  181216  ErRalk  SCUXXW4-9495, Modified Check_Insert___ and Check_Update___ methods to validate negative inputs in qty_to_deliver,volume and weight_net.
--  181103  UdGnlk  Bug 144100, Modified Delete___() to display the message when removing quantity loaded load lists. Added Check_Update___() to display same message. 
--  141028  Chfose  Added Remove as a public interface for removing an order load list line.
--  140702  JeLise  Bug 117072, Removed rounding of weight_gross, weight_net and volume attributes in Check_Insert___ and removed Check_Update___. 
--  140702          Removed rounding of weight_gross, weight_net and volume from Connect_To_Shipment_List and rounding of weight_gross and weight_net from Modify_Line_Weights methods.
--  120614  MaEelk  Replaced the usage of Company_Distribution_Info_API with Company_Invent_Info_API
--  111024  NaLrlk  Added new method Modify_Line_Weights.
--  111024          Modified the method Connect_To_Shipment_List to convert the weight and volume in kg and m3 respectively.
--  110704  Cpeilk  Bug 94508, Modified method Connect_To_Shipment_List to prevent multiple load list connecting to same CO line. 
--  110505  ChJalk  Modified the method Connect_To_Shipment_List to change the calculation of weight_net and weight_gross to consider the weight defined in configuration specification.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090709  IrRalk  Bug 82835, Modified Unpack_Check_Insert___ and Unpack_Check_Update___ to round weight
--  090709          and volume to 4 and 6 decimals respectively.
--  081230  ChJalk  Bug 70877, Added columns close_line and qty_to_deliver.
--  081230          Modified the methods Delete___ and Connect_To_Shipment_List.
--  080825  AmPalk  Changed Connect_To_Shipment_List by calling Sales_Weight_Volume_Util_API.Get_Total_Weight_Volume to get totals.
--  071210  MaRalk  Bug 66201, Modified procedure Connect_To_Shipment_List. 
--  060726  ThGulk  Added Objid instead of rowid in Procedure Insert__
--  050209  IsAnlk  Added info message message in Connect_To_Shipment_List. 
--  990414  JakH    Added use of public_rec instaed of get methods
--  990407  JakH    New template.
--  980305  DaZa    Removed column package_weight.
--  980227  KaAs    Fixed bug 670
--  980223  RaKu    Removed columns listed below from Connect_To_Shipment_List.
--  980201  KaAs    Removed the colums package_type, parcel_id and customs_stat_no.
--  971125  RaKu    Changed to FND200 Templates.
--  970527  RaKu    Modifyed procedure Connect_To_Shipment_List. Buy_Qty_Due was
--                  not included in the calculations.
--  970521  RaKu    Modifyed code to match Design.
--  970424  RaKu    Removed Get_Qty_To_Load, Modify_Qty_To_Load.
--                  Added procedure Modify_Qty_Loaded.
--                  Renamed qty_to_load to qty_loaded.
--  970228  RaKu    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Attribute___
--   Modifies row with attributes stored in the attribute string.
PROCEDURE Modify_Attribute___ (
   load_id_ IN NUMBER,
   pos_     IN NUMBER,
   attr_    IN VARCHAR2 )
IS
   newrec_      CUST_ORDER_LOAD_LIST_LINE_TAB%ROWTYPE;
   oldrec_      CUST_ORDER_LOAD_LIST_LINE_TAB%ROWTYPE;
   temp_attr_   VARCHAR2(2000);
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(load_id_, pos_);

   newrec_ := oldrec_;
   temp_attr_ := attr_;
   Unpack___(newrec_, indrec_,  temp_attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, temp_attr_);
   Update___(objid_, oldrec_, newrec_, temp_attr_, objversion_, TRUE);
END Modify_Attribute___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUST_ORDER_LOAD_LIST_LINE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_next_position IS
      SELECT NVL(MAX(pos) + 1, 1)
      FROM   CUST_ORDER_LOAD_LIST_LINE_TAB
      WHERE  load_id = newrec_.load_id;
BEGIN
-- Obtain next position to POS.
   OPEN  get_next_position;
   FETCH get_next_position INTO newrec_.pos;
   CLOSE get_next_position;
   Trace_SYS.Field('Recieves POS', newrec_.pos);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN CUST_ORDER_LOAD_LIST_LINE_TAB%ROWTYPE )
IS
   headrec_  Cust_Order_Load_List_API.public_rec;
BEGIN
   
   headrec_  := Cust_Order_Load_List_API.Get(remrec_.load_id);
   IF (headrec_.load_list_state = 'DEL' AND remrec_.qty_loaded > 0) THEN
      Raise_Edit_Restrict_Error___(remrec_.load_id);
   END IF;
   
   super(objid_, remrec_);

   -- When customer order line is disconnect, reset the qty to deliver values to original.
   Deliver_Customer_Order_API.Reset_Qty_To_Deliver__( remrec_.order_no,
                                                      remrec_.line_no,
                                                      remrec_.rel_no,
                                                      remrec_.line_item_no );
   -- Disconnect load list ID from customer order line.
   Customer_Order_Line_API.Disconnect_From_Load_List( remrec_.order_no,
                                                      remrec_.line_no,
                                                      remrec_.rel_no,
                                                      remrec_.line_item_no,
                                                      remrec_.load_id );
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_order_load_list_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.close_line IS NULL) THEN
      newrec_.close_line := 'FALSE';
   END IF;
   
   IF (newrec_.qty_to_deliver is NULL or newrec_.qty_to_deliver <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKQTYTODEL: The quantity to deliver must be either zero or greater than zero.');
   END IF;
      
   IF (newrec_.volume <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKVOLUME: The Volume must be greater than zero.');
   END IF;
      
   IF (newrec_.weight_net <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKNETWEIGHT: The Net Weight must be greater than zero.');
   END IF;
   
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_order_load_list_line_tab%ROWTYPE,
   newrec_ IN OUT cust_order_load_list_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2)
IS
   name_          VARCHAR2(30);
   value_         VARCHAR2(4000);
BEGIN  
   IF ((indrec_.volume = TRUE  OR indrec_.weight_gross = TRUE OR indrec_.weight_net = TRUE)
      AND Cust_Order_Load_List_API.Get_Load_List_State_Db(newrec_.load_id) = 'DEL' ) THEN
      Raise_Edit_Restrict_Error___(newrec_.load_id);
   END IF;
   
    IF (newrec_.qty_to_deliver is NULL or newrec_.qty_to_deliver <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKQTYTODEL: The quantity to deliver must be either zero or greater than zero.');
   END IF;
      
   IF (newrec_.volume <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKVOLUME: The Volume must be greater than zero.');
   END IF;
      
   IF (newrec_.weight_net <0) THEN  
      Error_SYS.Record_General(lu_name_,'CHECKNETWEIGHT: The Net Weight must be greater than zero.');
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   EXCEPTION
      WHEN value_error THEN
         Error_SYS.Item_Format(lu_name_, name_, value_);   
END Check_Update___;


PROCEDURE Raise_Edit_Restrict_Error___ (
   load_id_ NUMBER )
IS
BEGIN
   Error_SYS.Record_General(lu_name_, 'REMOVECANNOT: Load list :P1 has been delivered. No changes may be made', load_id_);
END Raise_Edit_Restrict_Error___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Connect_To_Shipment_List
--   Connects a order line to the specified load list.
PROCEDURE Connect_To_Shipment_List (
   load_id_      IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER )
IS
   attr_                  VARCHAR2(2000);
   newrec_                CUST_ORDER_LOAD_LIST_LINE_TAB%ROWTYPE;
   linerec_               Customer_Order_Line_API.public_rec;
   salerec_               Sales_Part_API.public_rec;
   weight_net_            NUMBER;
   weight_gross_          NUMBER;
   volume_                NUMBER;
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   load_list_state_       VARCHAR2(35);
   cust_ord_line_state_   VARCHAR2(20);
   company_invent_rec_    Company_Invent_Info_API.Public_Rec;
   indrec_                Indicator_Rec;
BEGIN
   linerec_            := Customer_Order_Line_API.Get(order_no_, line_no_, rel_no_, line_item_no_);
   salerec_            := Sales_Part_API.Get(linerec_.contract, linerec_.catalog_no);
   company_invent_rec_ := Company_Invent_Info_API.Get(Site_API.Get_Company(linerec_.contract));
   
   IF (linerec_.load_id IS NOT NULL) THEN
      load_list_state_ := Load_List_State_API.Encode(Cust_Order_Load_List_API.Get_Load_List_State(linerec_.load_id));
   END IF;
   cust_ord_line_state_ := Customer_Order_Line_API.Get_Objstate(order_no_, line_no_, rel_no_, line_item_no_);

   IF (linerec_.shipment_connected = 'TRUE') THEN
      Client_SYS.Add_Info(lu_name_, 'SHIPMENTCONNECT: Customer order line :P1, :P2, :P3 already connected to a shipment.', order_no_, line_no_, rel_no_);
   ELSIF (linerec_.load_id IS NOT NULL AND load_list_state_ = 'NOTDEL') THEN
      Error_SYS.Record_General(lu_name_, 'ALREADYCONNECTED: The customer order line :P1, :P2 is already connected to the load list :P3. Refresh the window and proceed.', order_no_||', '|| line_no_, rel_no_, linerec_.load_id);
   ELSIF (cust_ord_line_state_ IN ('Delivered', 'Invoiced', 'Cancelled')) THEN
      Error_SYS.Record_General(lu_name_, 'LOADLISTDELORCANCEL: The customer order line :P1, :P2, :P3 is either fully delivered or in status cancelled and cannot be connected to the load list. Refresh the window and proceed.', order_no_, line_no_, rel_no_);
   ELSE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('LOAD_ID',        load_id_,             attr_);
      Client_SYS.Add_To_Attr('ORDER_NO',       order_no_,            attr_);
      Client_SYS.Add_To_Attr('LINE_NO',        line_no_,             attr_);
      Client_SYS.Add_To_Attr('REL_NO',         rel_no_,              attr_);
      Client_SYS.Add_To_Attr('LINE_ITEM_NO',   line_item_no_,        attr_);
      Client_SYS.Add_To_Attr('QTY_LOADED',     0,                    attr_);
      Client_SYS.Add_To_Attr('CLOSE_LINE',     'FALSE',              attr_);
      Client_SYS.Add_To_Attr('QTY_TO_DELIVER', linerec_.qty_to_ship, attr_);
      -- Load list weight is represented in Kg.
      weight_gross_    := Iso_Unit_API.Get_Unit_Converted_Quantity(linerec_.line_total_weight_gross,
                                                                   company_invent_rec_.uom_for_weight,
                                                                   'kg');
      weight_net_      := Iso_Unit_API.Get_Unit_Converted_Quantity(linerec_.line_total_weight,
                                                                   company_invent_rec_.uom_for_weight,
                                                                   'kg');
      Client_SYS.Add_To_Attr('WEIGHT_GROSS', weight_gross_, attr_);
      Client_SYS.Add_To_Attr('WEIGHT_NET', weight_net_, attr_);
      -- Load list volume is represtented in m3.
      volume_          := Iso_Unit_API.Get_Unit_Converted_Quantity(linerec_.line_total_qty,
                                                                   company_invent_rec_.uom_for_volume,
                                                                   'm3');
      Client_SYS.Add_To_Attr('VOLUME', volume_, attr_);
      Unpack___(newrec_, indrec_, attr_); 
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
      -- Connect load list ID to customer order line.
      Customer_Order_Line_API.Connect_To_Load_List(order_no_,
                                                   line_no_,
                                                   rel_no_,
                                                   line_item_no_,
                                                   load_id_ );
   END IF;
END Connect_To_Shipment_List;


-- Get_Pos
--   Returns the position if a line is connected to the shipment.
--   NOTE! The select can only find one value or none cause
--   the limitation of connecting the whole remaining order
--   line to one, not delivered, shipment list.
@UncheckedAccess
FUNCTION Get_Pos (
   load_id_      IN NUMBER,
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   pos_ CUST_ORDER_LOAD_LIST_LINE.pos%TYPE;
   CURSOR find_pos IS
      SELECT pos
      FROM   CUST_ORDER_LOAD_LIST_LINE
      WHERE  load_id = load_id_
      AND    order_no = order_no_
      AND    line_no = line_no_
      AND    rel_no = rel_no_
      AND    line_item_no = line_item_no_;
BEGIN
   OPEN  find_pos;
   FETCH find_pos INTO pos_;
   IF (find_pos%NOTFOUND) THEN
      CLOSE find_pos;
      RETURN (NULL);
   END IF;
   CLOSE find_pos;
   RETURN pos_;
END Get_Pos;


-- Modify_Qty_Loaded
--   Modifyes the attribute qty_loaded.
PROCEDURE Modify_Qty_Loaded (
   load_id_    IN NUMBER,
   pos_        IN NUMBER,
   qty_loaded_ IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_LOADED', qty_loaded_, attr_);
   Modify_Attribute___(load_id_, pos_, attr_);
END Modify_Qty_Loaded;


-- Modify_Line_Weights
--   Modifies the attributes weight_net and weight_gross with Uom kg.
PROCEDURE Modify_Line_Weights (
   load_id_      IN NUMBER,
   pos_          IN NUMBER,
   weight_net_   IN NUMBER,
   weight_gross_ IN NUMBER )
IS
   attr_                        VARCHAR2(2000);
   rec_                         CUST_ORDER_LOAD_LIST_LINE_TAB%ROWTYPE;
   weight_net_load_list_uom_    NUMBER;
   weight_gross_load_list_uom_  NUMBER;
   comp_uom_weight_             COMPANY_INVENT_INFO_TAB.uom_for_weight%TYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(load_id_, pos_);
   comp_uom_weight_  := Company_Invent_Info_API.Get_Uom_For_Weight(Site_API.Get_Company(Customer_Order_Line_API.Get_Contract(rec_.order_no, 
                                                                                                                                   rec_.line_no, 
                                                                                                                                   rec_.rel_no,
                                                                                                                                   rec_.line_item_no)));
   -- Load list weight is represented in Kg.
   weight_net_load_list_uom_   := Iso_Unit_API.Get_Unit_Converted_Quantity(weight_net_,
                                                                           comp_uom_weight_,
                                                                           'kg');

   weight_gross_load_list_uom_ := Iso_Unit_API.Get_Unit_Converted_Quantity(weight_gross_,
                                                                           comp_uom_weight_,
                                                                           'kg');
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('WEIGHT_NET', weight_net_load_list_uom_, attr_);
   Client_SYS.Add_To_Attr('WEIGHT_GROSS', weight_gross_load_list_uom_, attr_);
   Modify_Attribute___(load_id_, pos_, attr_);
END Modify_Line_Weights;


-- Remove
--   Public interface for removing an order load list line.
PROCEDURE Remove (
   load_id_    IN NUMBER,
   pos_        IN NUMBER)
IS
   remrec_     CUST_ORDER_LOAD_LIST_LINE_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(load_id_, pos_);
   Check_Delete___(remrec_);
   Get_Id_Version_By_Keys___(objid_, objversion_, load_id_, pos_);
   Delete___(objid_, remrec_);
END Remove;
