-----------------------------------------------------------------------------
--
--  Logical unit: CoSupplySiteReservation
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151105  Chfose  LIM-4209, Removed pallet_id from all logic.
--  151103  UdGnlk  LIM-3671, Modified Check_Insert___() by removing Pallet_API method calls to support the pallet entity obsolete.  
--  150420  UdGnlk  LIM-142, Added handling_unit_id as new key column to Co_Supply_Site_Reservation_Tab therefore did necessary changes.    
--  111101  NISMLK  SMA-289, Increased eng_chg_level length to STRING(6) in column comments.
--  100513  Ajpelk  Merge rose method documentation
--  ------------------------------Eagle-------------------------------------------
--  081217  SuJalk Bug 79233, Added checks in Unpack_Check_Insert___ and Unpack_Check_Update___  to raise error messages if the qty_assigned is negative.
--  060220  NuFilk Added 'NOCHECK' option which previously existed to column Activity_Seq in view. 
--  060117  SuJalk Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  050920  DaZase Added activity_seq as a new key.
--  041007  HaPulk Fixed errors when refreshing Dictionary cache.
--  040510  DaZaSe Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                 the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  -------------------------------- 13.3.0 ----------------------------------
--  030909  DaZa   Added method Reservation_Exist.
--  030902  JaJalk Performed CR Merge2(CR Only).
--  030828  CaRa   Added Get_Qty_Reserved_Pallet.
--  030828  DaZa   Changed length on SERIAL_NO to 50 in view comments.
--  030820  GaSolk Performed CR Merge(CR Only).
--  030627  Asawlk Added new view CO_SUPPLY_SITE_RESERVATION_SUM.
--  030428  JoEd   Added CASCADE (delete) on order line key reference.
--  030409  DaZa   Added Get_Qty_Assigned, Oe_Exist, New, Remove, Modify_Qty_Assigned
--                 and Modify_Attribute___.
--  030325  JoEd   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Modify_Attribute___
--   Called from Modify_Qty_Assigned. Modifies the attributes sent in the
--   attribute string.
PROCEDURE Modify_Attribute___ (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   supply_site_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   attr_             IN VARCHAR2 )
IS
   newrec_     CO_SUPPLY_SITE_RESERVATION_TAB%ROWTYPE;
   oldrec_     CO_SUPPLY_SITE_RESERVATION_TAB%ROWTYPE;
   temp_attr_  VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_,
                              supply_site_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                              serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
   newrec_ := oldrec_;
   temp_attr_ := attr_;
   Unpack___(newrec_, indrec_, temp_attr_); 
   Check_Update___(oldrec_, newrec_, indrec_, temp_attr_);
   Update___(objid_, oldrec_, newrec_, temp_attr_, objversion_, TRUE);
END Modify_Attribute___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CO_SUPPLY_SITE_RESERVATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.last_activity_date := Site_API.Get_Site_Date(newrec_.supply_site);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', newrec_.last_activity_date, attr_);
   newrec_.reserved_by := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('RESERVED_BY', newrec_.reserved_by, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CO_SUPPLY_SITE_RESERVATION_TAB%ROWTYPE,
   newrec_     IN OUT CO_SUPPLY_SITE_RESERVATION_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.last_activity_date := Site_API.Get_Site_Date(newrec_.supply_site);
   Client_SYS.Add_To_Attr('LAST_ACTIVITY_DATE', newrec_.last_activity_date, attr_);
   newrec_.reserved_by := Fnd_Session_API.Get_Fnd_User;
   Client_SYS.Add_To_Attr('RESERVED_BY', newrec_.reserved_by, attr_);

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT co_supply_site_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
    
   IF (NVL(newrec_.activity_seq,0) != 0) THEN
      Error_SYS.Record_General('CoSupplySiteReservation', 'ONLY_NON_PI_RES: Supply site reservations cannot use Project Inventory.');
   END IF;

   IF (newrec_.qty_assigned < 0) THEN
      Error_SYS.Record_General('CoSupplySiteReservation', 'RESQTYCANTBNEG: The quantity reserved may not be negative.');
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     co_supply_site_reservation_tab%ROWTYPE,
   newrec_ IN OUT co_supply_site_reservation_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (newrec_.qty_assigned < 0) THEN
      Error_SYS.Record_General('CoSupplySiteReservation', 'RESQTYCANTBNEG: The quantity reserved may not be negative.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Qty_Reserved
--   Returns the order line's reserved quantity on all supply sites.
@UncheckedAccess
FUNCTION Get_Qty_Reserved (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER ) RETURN NUMBER
IS
   temp_ CO_SUPPLY_SITE_RESERVATION_TAB.qty_assigned%TYPE := 0;
   CURSOR get_attr IS
      SELECT sum(qty_assigned)
      FROM CO_SUPPLY_SITE_RESERVATION_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN nvl(temp_, 0);
END Get_Qty_Reserved;


-- Oe_Exist
--   Returns whether or not a reservation exists on the specified
--   inventory location.
@UncheckedAccess
FUNCTION Oe_Exist (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   supply_site_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER ) RETURN NUMBER
IS
BEGIN
   IF Check_Exist___(order_no_, line_no_, rel_no_, line_item_no_,
                     supply_site_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                     serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_) THEN
      RETURN 1;
   ELSE
      RETURN 0;
   END IF;
END Oe_Exist;


-- New
--   Creates a new reservation record.
PROCEDURE New (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   supply_site_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_assigned_     IN NUMBER )
IS
   attr_        VARCHAR2(2000);
   newrec_      CO_SUPPLY_SITE_RESERVATION_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   indrec_      Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('SUPPLY_SITE', supply_site_, attr_);
   Client_SYS.Add_To_Attr('PART_NO', part_no_, attr_);
   Client_SYS.Add_To_Attr('CONFIGURATION_ID', configuration_id_, attr_);
   Client_SYS.Add_To_Attr('LOCATION_NO', location_no_, attr_);
   Client_SYS.Add_To_Attr('LOT_BATCH_NO', lot_batch_no_, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', serial_no_, attr_);
   Client_SYS.Add_To_Attr('ENG_CHG_LEVEL', eng_chg_level_, attr_);
   Client_SYS.Add_To_Attr('WAIV_DEV_REJ_NO', waiv_dev_rej_no_, attr_);
   Client_SYS.Add_To_Attr('ACTIVITY_SEQ', activity_seq_, attr_);
   Client_SYS.Add_To_Attr('HANDLING_UNIT_ID', handling_unit_id_, attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
   
   Unpack___(newrec_, indrec_, attr_); 
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New;


-- Remove
--   Removes the specified record.
PROCEDURE Remove (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   supply_site_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER )
IS
   remrec_     CO_SUPPLY_SITE_RESERVATION_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(order_no_, line_no_, rel_no_, line_item_no_,
                              supply_site_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                              serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
   Get_Id_Version_By_Keys___(objid_, objversion_, order_no_, line_no_, rel_no_, line_item_no_,
                             supply_site_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                             serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Modify_Qty_Assigned
--   Changes the value for the attribute Qty_Assigned.
PROCEDURE Modify_Qty_Assigned (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   supply_site_      IN VARCHAR2,
   part_no_          IN VARCHAR2,
   configuration_id_ IN VARCHAR2,
   location_no_      IN VARCHAR2,
   lot_batch_no_     IN VARCHAR2,
   serial_no_        IN VARCHAR2,
   eng_chg_level_    IN VARCHAR2,
   waiv_dev_rej_no_  IN VARCHAR2,
   activity_seq_     IN NUMBER,
   handling_unit_id_ IN NUMBER,
   qty_assigned_     IN NUMBER )
IS
   attr_ VARCHAR2(2000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('QTY_ASSIGNED', qty_assigned_, attr_);
   Modify_Attribute___(order_no_, line_no_, rel_no_, line_item_no_,
                       supply_site_, part_no_, configuration_id_, location_no_, lot_batch_no_,
                       serial_no_, eng_chg_level_, waiv_dev_rej_no_, activity_seq_, handling_unit_id_, attr_ );
END Modify_Qty_Assigned;


-- Reservation_Exist
--   Returns whether or not reservations exists for a specific order line.
@UncheckedAccess
FUNCTION Reservation_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER ) RETURN NUMBER
IS
   CURSOR reservation_exist IS
      SELECT 1
      FROM   CO_SUPPLY_SITE_RESERVATION_TAB
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_;
   dummy_   NUMBER;
BEGIN
   OPEN reservation_exist;
   FETCH reservation_exist INTO dummy_;
   IF (reservation_exist%FOUND) THEN
      CLOSE reservation_exist;
      RETURN dummy_;
   END IF;
   CLOSE reservation_exist;
   RETURN 0;
END Reservation_Exist;



