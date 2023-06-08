-----------------------------------------------------------------------------
--
--  Logical unit: InventoryPickList
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  20202   RoJalk  SC2020R1-10729, Modified Set_Shipment_Qty_Res_As_Picked and passed the parameter 
--  20202           trigger_shipment_flow_ to Inventory_Part_Reservation_API.Set_Qty_Reserved_As_Picked method call.
--  200622  RasDlk  SC2020R1-689, Added the new method Check_Pick_List_Exist to check whether there exists at least one not fully_picked,
--  200622          inventory pick list with a deviating default shipment inventory from a considered shipment inventory location for a particular shipment.
--  171018  RoJalk  STRSC-9581, Changed the return type of Is_Fully_Reported method to be VARCHAR2.
--  171012  RoJalk  STRSC-12287, Modified Insert___ and assigned site date to date_created.
--  171011  RoJalk  STRSC-9564, Added the method New_Per_Loc_Group and location_group_ parameter to the method New.
--  171002  RoJalk  STRSC-9575, Added methods Set_Qty_Reserved_As_Picked__ and Set_Qty_Reserved_As_Picked. 
--  170427  RoJalk  LIM-11359, Changed the scope of Modify_Ship_Inv_Location_No to be public.
--  170427          Moved the logic in Post_Pick_Report_Shipment to Pick_Shipment_API. 
--  170427  RoJalk  LIM-11324, Added the method Set_Shipment_Qty_Res_As_Picked.
--  170412  RoJalk  LIM-10554, Added method Modify_Ship_Inv_Loc_Shipment.
--  170411  RoJalk  LIM-10554, Added methods Modify_Ship_Inv_Location_No___, Post_Pick_Report_Shipment.
--  170330  MaRalk  LIM-9052, Added method Get_Pick_Lists_For_Shipment.
--  170329  MaRalk  LIM-9055, Added methid Shipment_Has_Unprinted_List.
--  170328  MaRalk  LIM-9646, Added method Set_Printed.
--  170323  RoJalk  LIM-11253, Renamed Is_Fully_Reported to Shipment_Is_Fully_Reported
--  170323          and added Is_Fully_Reported with pick list no level.
--  170322  RoJalk  LIM-10699, Modified New method and added the parameter ship_inventory_location_no_.
--  170224  RoJalk  LIM-9881, Removed fully_reported sine the information is moved in 
--  170224          to inventory_part_reservation_tab. Added the method Is_Fully_Reported.
--  161124  RoJalk  LIM-9847, Added the method Set_Fully_Reported.
--  161111  RoJalk  LIM-9012, Modified Check_Update___ to include validations.
--  161108  RoJalk  LIM-9412, Added the method Get_Next_Pick_List_No and called from Insert___.
--  161025  RoJalk  LIM-9011, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

string_null_ CONSTANT VARCHAR2(11) := Database_SYS.string_null_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Add_To_Attr('PRINTED_DB',        Fnd_Boolean_API.DB_FALSE, attr_);
   super(attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT inventory_pick_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (indrec_.printed = FALSE) THEN
      newrec_.printed := Fnd_Boolean_API.DB_FALSE;
   END IF;
   super(newrec_, indrec_, attr_);  
END Check_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT inventory_pick_list_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.pick_list_no := Get_Next_Pick_List_No();
   newrec_.date_created := Site_API.Get_Site_Date(newrec_.contract);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Set_Qty_Reserved_As_Picked__ (
   attrib_   IN VARCHAR2 )
IS
   ptr_                          NUMBER;
   name_                         VARCHAR2(30);
   value_                        VARCHAR2(2000);
   pick_list_no_                 NUMBER;
   ship_inventory_location_no_   VARCHAR2(35);   
BEGIN
   Inventory_Event_Manager_API.Start_Session();
   WHILE (Client_SYS.Get_Next_From_Attr(attrib_, ptr_, name_, value_)) LOOP
      IF (name_ = 'PICK_LIST_NO') THEN
         pick_list_no_ := Client_SYS.Attr_Value_To_Number(value_);
      ELSIF (name_ = 'SHIP_INVENTORY_LOCATION_NO') THEN
         ship_inventory_location_no_ := value_;
         Inventory_Part_Reservation_API.Set_Qty_Reserved_As_Picked(pick_list_no_,
                                                                   ship_inventory_location_no_ );
      END IF;      
   END LOOP;
   Inventory_Event_Manager_API.Finish_Session(); 
END Set_Qty_Reserved_As_Picked__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New (
   pick_list_no_               OUT NUMBER,
   shipment_id_                IN  NUMBER,
   contract_                   IN  VARCHAR2,
   ship_inventory_location_no_ IN  VARCHAR2 DEFAULT NULL,
   location_group_             IN  VARCHAR2 DEFAULT NULL )
IS 
   newrec_  INVENTORY_PICK_LIST_TAB%ROWTYPE;
BEGIN
   newrec_.shipment_id                := shipment_id_;
   newrec_.contract                   := contract_;
   newrec_.ship_inventory_location_no := ship_inventory_location_no_;
   newrec_.location_group             := location_group_;
   
   New___(newrec_);
   pick_list_no_ := newrec_.pick_list_no;
   
   -- update reservations with the created pick list no
   Inventory_Part_Reservation_API.Set_Pick_List_No(pick_list_no_   => pick_list_no_, 
                                                   shipment_id_    => shipment_id_,
                                                   location_group_ => location_group_);
END New;


PROCEDURE New_Per_Loc_Group (
   shipment_id_                IN NUMBER,
   contract_                   IN VARCHAR2,
   ship_inventory_location_no_ IN VARCHAR2 DEFAULT NULL )
IS 
   CURSOR get_loc_group_rec IS
      SELECT DISTINCT(Inventory_Location_API.Get_Location_Group(contract, location_no)) location_group
       FROM  inventory_part_reservation_tab
      WHERE  shipment_id  = shipment_id_
        AND  pick_list_no = 0; 
   
   TYPE Location_Group_Tab IS TABLE OF INVENTORY_PICK_LIST_TAB.location_group%TYPE INDEX BY BINARY_INTEGER;
   location_group_tab_ Location_Group_Tab;
      
   pick_list_no_   NUMBER;     
BEGIN
   OPEN get_loc_group_rec;
   FETCH get_loc_group_rec BULK COLLECT INTO location_group_tab_;
   CLOSE get_loc_group_rec;
   
   IF (location_group_tab_.COUNT > 0) THEN    
      FOR i_ IN location_group_tab_.FIRST .. location_group_tab_.LAST LOOP
         New (pick_list_no_               ,
              shipment_id_                ,
              contract_                   ,
              ship_inventory_location_no_ ,
              location_group_tab_(i_));
      END LOOP;  
   END IF;     
   
END New_Per_Loc_Group;


FUNCTION Get_Next_Pick_List_No RETURN NUMBER
IS
BEGIN
   RETURN (invent_pick_list_no_seq.nextval);
END Get_Next_Pick_List_No;


@UncheckedAccess
FUNCTION Shipment_Is_Fully_Reported (
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS
   is_fully_reported_ BOOLEAN := TRUE;
   temp_              NUMBER;

   CURSOR exist_control IS
      SELECT 1 
        FROM inventory_part_reservation_tab
       WHERE shipment_id   = shipment_id_
         AND (pick_list_no != 0)
         AND fully_picked  = Fnd_Boolean_API.DB_FALSE;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF(exist_control%FOUND) THEN
      CLOSE exist_control;
      is_fully_reported_ := FALSE;
   END IF;

   RETURN (is_fully_reported_);
END Shipment_Is_Fully_Reported;


@UncheckedAccess
FUNCTION Is_Fully_Reported (
   pick_list_no_ IN NUMBER ) RETURN VARCHAR2
IS
   is_fully_reported_ VARCHAR2(5) := 'TRUE';
   temp_              NUMBER;

   CURSOR exist_control IS
      SELECT 1 
        FROM inventory_part_reservation_tab
       WHERE pick_list_no = pick_list_no_
         AND fully_picked = Fnd_Boolean_API.DB_FALSE;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF(exist_control%FOUND) THEN
      CLOSE exist_control;
      is_fully_reported_ := 'FALSE';
   END IF;

   RETURN (is_fully_reported_);
END Is_Fully_Reported;


@UncheckedAccess
FUNCTION Shipment_Has_Unprinted_List (
   shipment_id_ IN NUMBER ) RETURN BOOLEAN
IS 
   temp_                    NUMBER;
   print_pick_list_allowed_ BOOLEAN:= FALSE;
   
   CURSOR exist_control IS
      SELECT 1
      FROM   inventory_pick_list_tab ipl, inventory_part_reservation_tab ipr 
      WHERE  ipl.shipment_id   = shipment_id_
      AND    ipl.shipment_id   = ipr.shipment_id       
      AND    ipl.pick_list_no  = ipr.pick_list_no
      AND    ipl.printed       = Fnd_Boolean_API.DB_FALSE        
      AND    ipr.fully_picked  = Fnd_Boolean_API.DB_FALSE; 
BEGIN   
   OPEN exist_control;
   FETCH exist_control INTO temp_;
   IF(exist_control%FOUND) THEN
      print_pick_list_allowed_ := TRUE;
   END IF;
   CLOSE exist_control;
   RETURN print_pick_list_allowed_;
END Shipment_Has_Unprinted_List;


@UncheckedAccess
FUNCTION Get_Pick_Lists_For_Shipment (
   shipment_id_      IN NUMBER,
   printed_db_       IN VARCHAR2,
   fully_picked_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   pick_list_no_list_ VARCHAR2(32000); 
   
   CURSOR get_pick_lists IS
      SELECT ipl.pick_list_no
      FROM   inventory_pick_list_tab ipl 
      WHERE  ipl.shipment_id   = shipment_id_     
      AND    (ipl.printed = printed_db_ OR printed_db_ IS NULL);      
BEGIN
   pick_list_no_list_ := NULL;
   
   FOR rec_ IN get_pick_lists LOOP
      IF (Inventory_Part_Reservation_API.Shipment_Pick_List_Line_Exists(shipment_id_, 
                                                                        rec_.pick_list_no, 
                                                                        fully_picked_db_) = TRUE)THEN
         pick_list_no_list_ := pick_list_no_list_ || rec_.pick_list_no || Client_SYS.field_separator_;
      END IF;
   END LOOP;
  
   RETURN pick_list_no_list_;
END Get_Pick_Lists_For_Shipment;
   

PROCEDURE Set_Printed (
   pick_list_no_ IN NUMBER)
IS
   rec_          inventory_pick_list_tab%ROWTYPE; 
BEGIN 
   rec_          := Lock_By_Keys___(pick_list_no_);
   rec_.printed  := Fnd_Boolean_API.DB_TRUE;      
   Modify___(rec_);
END Set_Printed;


PROCEDURE Modify_Ship_Inv_Loc_Shipment (
   shipment_id_                IN NUMBER,
   ship_inventory_location_no_ IN VARCHAR2 )
IS
   CURSOR get_pick_list_no IS
      SELECT ipl.pick_list_no
        FROM inventory_pick_list_tab ipl
       WHERE ipl.shipment_id = shipment_id_
         AND (NVL(ipl.ship_inventory_location_no, string_null_) != ship_inventory_location_no_)
         AND EXISTS (SELECT 1 
                       FROM inventory_part_reservation_tab ipr
                      WHERE ipr.pick_list_no  = ipl.pick_list_no
                        AND ipr.fully_picked  = 'FALSE');
BEGIN
   FOR pick_list_no_rec_ IN get_pick_list_no LOOP
      Modify_Ship_Inv_Location_No(pick_list_no_rec_.pick_list_no, ship_inventory_location_no_);
   END LOOP;
END Modify_Ship_Inv_Loc_Shipment;


PROCEDURE Set_Shipment_Qty_Res_As_Picked (
   shipment_id_                IN NUMBER,
   ship_inventory_location_no_ IN VARCHAR2 )
IS
   CURSOR get_pick_list_no IS
      SELECT pick_list_no
        FROM inventory_pick_list_tab
       WHERE shipment_id = shipment_id_;
BEGIN
   FOR pick_list_no_rec_ IN get_pick_list_no LOOP
      Inventory_Part_Reservation_API.Set_Qty_Reserved_As_Picked(pick_list_no_               => pick_list_no_rec_.pick_list_no,
                                                                ship_inventory_location_no_ => ship_inventory_location_no_, 
                                                                trigger_shipment_flow_      => FALSE);
   END LOOP;
END Set_Shipment_Qty_Res_As_Picked;


PROCEDURE Modify_Ship_Inv_Location_No (
   pick_list_no_               IN NUMBER,
   ship_inventory_location_no_ IN VARCHAR2 )
IS
   newrec_   inventory_pick_list_tab%ROWTYPE;
BEGIN
   newrec_                            := Lock_By_Keys___(pick_list_no_);
   newrec_.ship_inventory_location_no := ship_inventory_location_no_;
   Modify___(newrec_);
END Modify_Ship_Inv_Location_No;

PROCEDURE Set_Qty_Reserved_As_Picked (
   attrib_   IN VARCHAR2 )
IS
   batch_desc_   VARCHAR2(100);
BEGIN
   batch_desc_:= Language_SYS.Translate_Constant(lu_name_,'PICKREPINVPLIST: Report Inventory Pick List');
   Transaction_SYS.Deferred_Call('Inventory_Pick_List_API.Set_Qty_Reserved_As_Picked__', attrib_, batch_desc_);
END Set_Qty_Reserved_As_Picked;

-- Check_Pick_List_Exist
--   This method checks whether there exists at least one not fully_picked, inventory pick list with a deviating default
--   shipment inventory from a considered shipment inventory location for a particular shipment.
@UncheckedAccess
FUNCTION Check_Pick_List_Exist (
   shipment_id_ IN NUMBER,
   location_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   exist_ VARCHAR2(5) := 'FALSE';
   CURSOR exist_pick_list IS
      SELECT 1 
        FROM inventory_pick_list_tab ipl, inventory_part_reservation_tab ipr
       WHERE ipl.shipment_id   = shipment_id_
         AND ipl.pick_list_no  = ipr.pick_list_no
         AND ipr.fully_picked  = Fnd_Boolean_API.DB_FALSE
         AND ipl.ship_inventory_location_no != location_no_;
BEGIN
   OPEN  exist_pick_list;
   FETCH exist_pick_list INTO dummy_;
   IF (exist_pick_list%FOUND) THEN
      exist_ := 'TRUE';
   END IF;   
   CLOSE exist_pick_list;
   RETURN exist_;
END Check_Pick_List_Exist;

-------------------- LU  NEW METHODS -------------------------------------
