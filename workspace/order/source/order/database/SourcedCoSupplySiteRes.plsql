-----------------------------------------------------------------------------
--
--  Logical unit: SourcedCoSupplySiteRes
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151113  MaEelk  LIM-4453, Removed pallet_id from Customer_Order_Reservation_API
--  151105  Chfose  LIM-4454, Removed pallet_id from all logic.
--  150420  UdGnlk  LIM-142, Added handling_unit_id as new key column to Co_Supply_Site_Reservation_Tab therefore did necessary changes.
--  150417  Chfose  LIM-158, Added new key handling_unit_id to methods and logic.
--  121031  RoJalk  Allow connecting a customer order line to several shipment lines - modified Transfer_Sourced_Reservations and
--  121031          passed 0 for the shipment id in the method call Customer_Order_Reservation_API.New.
--  120113  Darklk  Bug 100716, Added the parameter catch_qty_ to Customer_Order_Reservation_API.New.
--  111101  NISMLK  SMA-289, Increased eng_chg_level length to STRING(6) in column comments.
--  100513  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091202  DaGulk  Bug 85166, Removed parameter catch_qty_ from calls to Customer_Order_Reservation_API.New.
--  081217  SuJalk  Bug 79233, Added checks in Unpack_Check_Insert___ and Unpack_Check_Update___  to raise error messages if the qty_assigned is negative.
--  060220  NuFilk  Added 'NOCHECK' option which previously existed to column Activity_Seq in view. 
--  060112  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  050921  DaZase  Added activity_seq as a new key.
--  041020  IsAnlk  Added parameter catch_qty_ to method calls Customer_Order_Reservation_API.New.
--  040929  DaZase  Added 0 (for activity_seq) in call to Customer_Order_Reservation_API.New.
--  040825  DaRulk  Added NULL input uom parameters in Transfer_Sourced_Reservations()
--  040511  DaZase  Project Inventory: Added zero-parameter to calls to different Inventory_Part_In_Stock_API methods,
--                  the parameter should be changed to a real Activity_Seq value if this functionality uses Project Inventory.
--  -------------------------------- 13.3.0 ----------------------------------
--  040303  DaZa    Bug 42004, added extra handling of qty_assigned for local site reservations in method Transfer_Sourced_Reservations.
--  030915  DaZa    Added a remove call to Transfer_Sourced_Reservations since we are now not able to use the
--                  cascade delete functionality because we dont allow deletion of sourced rows while reservation exists
--  030909  DaZa    Removed calls to Inventory_Part_In_Stock_API.Reserve_Part.
--  030902  JaJalk  Performed CR Merge2(CR Only).
--  030828  CaRase  Add call to Inventory_Part_In_Stock_API.Reserve_Part Qty Reserved in Inventory_Part_In_Stock when
--                  one Sourced Line is deleted.This is performed for normal and pallet parts.
--  030828  BhRalk  Modified the view SOURCED_CO_SUPPLY_SITE_RES_SUM.
--  030828  CaRase  Added Get_Qty_Reserved_Pallet.
--  030828  DaZa    Changed length on SERIAL_NO to 50 in view comments.
--  030825  Asawlk  Added new view SOURCED_CO_SUPPLY_SITE_RES_SUM.
--  030820  GaSolk  Performed CR Merge(CR Only).
--  030811  DaZa    Fixed some cursor problems in Transfer_Sourced_Reservations and Sourced_Reservation_Exist.
--  030807  DaZa    Added handling for sourced local site reservations in method Transfer_Sourced_Reservations
--  030617  DaZa    Added method Transfer_Sourced_Reservations.
--  030613  DaZa    Added method Sourced_Reservation_Exist.
--  030328  CaRase  Created
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
   source_id_        IN NUMBER,
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
   newrec_     SOURCED_CO_SUPPLY_SITE_RES_TAB%ROWTYPE;
   oldrec_     SOURCED_CO_SUPPLY_SITE_RES_TAB%ROWTYPE;
   temp_attr_  VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   oldrec_ := Lock_By_Keys___(order_no_, 
                              line_no_, 
                              rel_no_, 
                              line_item_no_,
                              source_id_,
                              supply_site_, 
                              part_no_, 
                              configuration_id_, 
                              location_no_, 
                              lot_batch_no_,
                              serial_no_, 
                              eng_chg_level_, 
                              waiv_dev_rej_no_, 
                              activity_seq_, 
                              handling_unit_id_);
   newrec_    := oldrec_;
   temp_attr_ := attr_;
   Unpack___(newrec_, indrec_, temp_attr_);
   Check_Update___(oldrec_, newrec_, indrec_, temp_attr_);
   Update___(objid_, oldrec_, newrec_, temp_attr_, objversion_, TRUE);
END Modify_Attribute___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT SOURCED_CO_SUPPLY_SITE_RES_TAB%ROWTYPE,
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
   oldrec_     IN     SOURCED_CO_SUPPLY_SITE_RES_TAB%ROWTYPE,
   newrec_     IN OUT SOURCED_CO_SUPPLY_SITE_RES_TAB%ROWTYPE,
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
   newrec_ IN OUT sourced_co_supply_site_res_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN    
   IF (NVL(newrec_.activity_seq,0) != 0) THEN
      Error_SYS.Record_General('SourcedCoSupplySiteRes', 'ONLY_NON_PI_RES: Sourced reservations cannot use Project Inventory.');
   END IF;

   IF (newrec_.qty_assigned < 0) THEN
      Error_SYS.Record_General('SourcedCoSupplySiteRes', 'RESQTYNOTNEG: The quantity reserved may not be negative.');
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sourced_co_supply_site_res_tab%ROWTYPE,
   newrec_ IN OUT sourced_co_supply_site_res_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.qty_assigned < 0) THEN
      Error_SYS.Record_General('SourcedCoSupplySiteRes', 'RESQTYNOTNEG: The quantity reserved may not be negative.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
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
   line_item_no_     IN NUMBER,
   source_id_        IN NUMBER ) RETURN NUMBER
IS
   temp_ SOURCED_CO_SUPPLY_SITE_RES_TAB.qty_assigned%TYPE := 0;
   CURSOR get_attr IS
      SELECT sum(qty_assigned)
      FROM SOURCED_CO_SUPPLY_SITE_RES_TAB
      WHERE order_no = order_no_
      AND   line_no = line_no_
      AND   rel_no = rel_no_
      AND   line_item_no = line_item_no_
      AND   source_id = source_id_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN nvl(temp_, 0);
END Get_Qty_Reserved;


-- Oe_Exist
--   Returns whether or not a reservation exists on the specified inventory location.
@UncheckedAccess
FUNCTION Oe_Exist (
   order_no_         IN VARCHAR2,
   line_no_          IN VARCHAR2,
   rel_no_           IN VARCHAR2,
   line_item_no_     IN NUMBER,
   source_id_        IN NUMBER,
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
   IF Check_Exist___(order_no_, 
                     line_no_, 
                     rel_no_, 
                     line_item_no_, 
                     source_id_,
                     supply_site_, 
                     part_no_, 
                     configuration_id_, 
                     location_no_, 
                     lot_batch_no_,
                     serial_no_, 
                     eng_chg_level_, 
                     waiv_dev_rej_no_, 
                     activity_seq_, 
                     handling_unit_id_) THEN
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
   source_id_        IN NUMBER,
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
   attr_       VARCHAR2(2000);
   newrec_     SOURCED_CO_SUPPLY_SITE_RES_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_NO', line_no_, attr_);
   Client_SYS.Add_To_Attr('REL_NO', rel_no_, attr_);
   Client_SYS.Add_To_Attr('LINE_ITEM_NO', line_item_no_, attr_);
   Client_SYS.Add_To_Attr('SOURCE_ID', source_id_, attr_);
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
   source_id_        IN NUMBER,
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
   remrec_     SOURCED_CO_SUPPLY_SITE_RES_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   remrec_ := Lock_By_Keys___(order_no_, 
                              line_no_, 
                              rel_no_, 
                              line_item_no_, 
                              source_id_,
                              supply_site_, 
                              part_no_, 
                              configuration_id_, 
                              location_no_, 
                              lot_batch_no_,
                              serial_no_, 
                              eng_chg_level_, 
                              waiv_dev_rej_no_, 
                              activity_seq_, 
                              handling_unit_id_ );
   Get_Id_Version_By_Keys___(objid_, 
                             objversion_, 
                             order_no_, 
                             line_no_, 
                             rel_no_, 
                             line_item_no_, 
                             source_id_,
                             supply_site_, 
                             part_no_, 
                             configuration_id_, 
                             location_no_, 
                             lot_batch_no_,
                             serial_no_, 
                             eng_chg_level_, 
                             waiv_dev_rej_no_, 
                             activity_seq_, 
                             handling_unit_id_ );
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
   source_id_        IN NUMBER,
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
   Modify_Attribute___(order_no_, 
                       line_no_, 
                       rel_no_, 
                       line_item_no_, 
                       source_id_,
                       supply_site_, 
                       part_no_, 
                       configuration_id_, 
                       location_no_, 
                       lot_batch_no_,
                       serial_no_, 
                       eng_chg_level_, 
                       waiv_dev_rej_no_, 
                       activity_seq_, 
                       handling_unit_id_,
                       attr_);
END Modify_Qty_Assigned;


-- Sourced_Reservation_Exist
--   Checks if any sourced reservation line exist for a specific
--   order line/source id combination, returns 1 for true and 0 for false.
@UncheckedAccess
FUNCTION Sourced_Reservation_Exist (
   order_no_     IN VARCHAR2,
   line_no_      IN VARCHAR2,
   rel_no_       IN VARCHAR2,
   line_item_no_ IN NUMBER,
   source_id_    IN NUMBER ) RETURN NUMBER
IS
   CURSOR sourced_res_exist IS
      SELECT 1
      FROM   SOURCED_CO_SUPPLY_SITE_RES_TAB
      WHERE  order_no     = order_no_
      AND    line_no      = line_no_
      AND    rel_no       = rel_no_
      AND    line_item_no = line_item_no_
      AND    source_id    = source_id_;
   dummy_   NUMBER;
BEGIN
   OPEN sourced_res_exist;
   FETCH sourced_res_exist INTO dummy_;
   IF (sourced_res_exist%FOUND) THEN
      CLOSE sourced_res_exist;
      RETURN dummy_;
   END IF;
   CLOSE sourced_res_exist;
   RETURN 0;
END Sourced_Reservation_Exist;


-- Transfer_Sourced_Reservations
--   When a customer order line is Released, sourced lines becomes order lines.
--   And this method transfers all supply site reservations made for the
--   sourced line to become reservations for the created customer order line.
--   Mainly used by method Customer_Order_Line_API.Create_Sourced_Co_Line
PROCEDURE Transfer_Sourced_Reservations (
   order_no_         IN VARCHAR2,
   old_line_no_      IN VARCHAR2,
   old_rel_no_       IN VARCHAR2,
   old_line_item_no_ IN NUMBER,
   source_id_        IN NUMBER,
   new_line_no_      IN VARCHAR2,
   new_rel_no_       IN VARCHAR2,
   new_line_item_no_ IN NUMBER )
IS
   org_source_rec_          Sourced_Cust_Order_Line_API.Public_Rec;
   local_site_qty_assigned_ NUMBER := 0;

   CURSOR get_sourced_res IS
      SELECT *
      FROM SOURCED_CO_SUPPLY_SITE_RES_TAB
      WHERE order_no     = order_no_
      AND   line_no      = old_line_no_
      AND   rel_no       = old_rel_no_
      AND   line_item_no = old_line_item_no_
      AND   source_id    = source_id_;
BEGIN
   org_source_rec_ := Sourced_Cust_Order_Line_API.Get(order_no_, old_line_no_, old_rel_no_, old_line_item_no_, source_id_);
   FOR source_rec_ IN get_sourced_res LOOP
      IF (org_source_rec_.supply_code = 'IO') THEN
         -- Local Site Reservation : create a normal reservation with the data from the sourced reservation
         Customer_Order_Reservation_API.New(order_no_                 => order_no_, 
                                            line_no_                  => NVL(new_line_no_, old_line_no_), 
                                            rel_no_                   => NVL(new_rel_no_, old_rel_no_),
                                            line_item_no_             => NVL(new_line_item_no_, old_line_item_no_), 
                                            contract_                 => source_rec_.supply_site, 
                                            part_no_                  => source_rec_.part_no, 
                                            location_no_              => source_rec_.location_no, 
                                            lot_batch_no_             => source_rec_.lot_batch_no, 
                                            serial_no_                => source_rec_.serial_no,
                                            eng_chg_level_            => source_rec_.eng_chg_level, 
                                            waiv_dev_rej_no_          => source_rec_.waiv_dev_rej_no, 
                                            activity_seq_             => source_rec_.activity_seq, 
                                            handling_unit_id_         => source_rec_.handling_unit_id,
                                            pick_list_no_             => '*', 
                                            configuration_id_         => source_rec_.configuration_id, 
                                            shipment_id_              => 0, 
                                            qty_assigned_             => source_rec_.qty_assigned, 
                                            qty_picked_               => 0, 
                                            qty_shipped_              => 0, 
                                            input_qty_                => NULL, 
                                            input_unit_meas_          => NULL, 
                                            input_conv_factor_        => NULL, 
                                            input_variable_values_    => NULL, 
                                            preliminary_pick_list_no_ => NULL, 
                                            catch_qty_                => NULL);
            local_site_qty_assigned_ := local_site_qty_assigned_ + source_rec_.qty_assigned;
      ELSE
         -- create a new Co supply site reservation with the data from the sourced supply site reservation
         Co_Supply_Site_Reservation_API.New(order_no_          => order_no_, 
                                            line_no_           => NVL(new_line_no_,old_line_no_), 
                                            rel_no_            => NVL(new_rel_no_,old_rel_no_),
                                            line_item_no_      => NVL(new_line_item_no_,old_line_item_no_), 
                                            supply_site_       => source_rec_.supply_site,
                                            part_no_           => source_rec_.part_no, 
                                            configuration_id_  => source_rec_.configuration_id, 
                                            location_no_       => source_rec_.location_no,
                                            lot_batch_no_      => source_rec_.lot_batch_no, 
                                            serial_no_         => source_rec_.serial_no, 
                                            eng_chg_level_     => source_rec_.eng_chg_level,
                                            waiv_dev_rej_no_   => source_rec_.waiv_dev_rej_no, 
                                            activity_seq_      => source_rec_.activity_seq, 
                                            handling_unit_id_  => source_rec_.handling_unit_id,
                                            qty_assigned_      => source_rec_.qty_assigned);
      END IF;
      -- remove old sourced reservation
      Remove(order_no_           => order_no_, 
             line_no_            => old_line_no_, 
             rel_no_             => old_rel_no_, 
             line_item_no_       => old_line_item_no_, 
             source_id_          => source_id_, 
             supply_site_        => source_rec_.supply_site,
             part_no_            => source_rec_.part_no, 
             configuration_id_   => source_rec_.configuration_id, 
             location_no_        => source_rec_.location_no, 
             lot_batch_no_       => source_rec_.lot_batch_no,
             serial_no_          => source_rec_.serial_no, 
             eng_chg_level_      => source_rec_.eng_chg_level, 
             waiv_dev_rej_no_    => source_rec_.waiv_dev_rej_no, 
             activity_seq_       => source_rec_.activity_seq, 
             handling_unit_id_   => source_rec_.handling_unit_id);
   END LOOP;
   IF (local_site_qty_assigned_ > 0) THEN
      Customer_Order_API.Set_Line_Qty_Assigned(order_no_       => order_no_, 
                                               line_no_        => NVL(new_line_no_,old_line_no_), 
                                               rel_no_         => NVL(new_rel_no_,old_rel_no_),
                                               line_item_no_   => NVL(new_line_item_no_,old_line_item_no_), 
                                               qty_assigned_   => local_site_qty_assigned_);
   END IF;
END Transfer_Sourced_Reservations;



