-----------------------------------------------------------------------------
--
--  Logical unit: RemoteWhseAssortPart
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210930  JaThlk  Bug 160596 (SC21R2-2990), Modified Get_Plannable_Qty, to add the intra warehouse move quantity to the plannable quantity.
--  200324  SBalLK  Bug 152848 (SCZ-9452), Resolving automatic testing reported issues.
--  190509  DilMlk  Bug 145881 (SCZ-2455), Modified Check_Insert___ to prevent setting TRUE for REMOVE_EXCESS_INVENTORY_DB 
--  190509          if user removes REMOVE_EXCESS_INVENTORY_DB manually before inserting a record.
--  140408  JeLise  Removed setting newrec_.refill_source to DB_INVENTORY in Check_Insert___.
--  140211  Matkse  Added override for Raise_Record_Exist___.
--  140207  JeLise  Added new methods Req_Line_Exist_For_Warehouse and Po_Line_Exist_For_Warehouse.
--  131118  Erlise  Modified view REMOTE_WHSE_PART_PLANNING. Added conditions to exclude records whit zero quantities.
--  131105  JeLise  Added method Get_Refill_Source_Db.
--  131025  Erlise  Added attribute remote_warehouse in view REMOTE_WHSE_PART_PLANNING.
--  131023  JeLise  Added method Get_Qty_Inbound_For_Purchase and calling it from view REMOTE_WHSE_PART_PLANNING.
--  131007  Matkse  Added attribute refill_source to view REMOTE_WHSE_PART_PLANNING.
--  131004  Matkse  Added attribute remove_excess_inventory to views R_H_PART_PLANNING_UNION and REMOTE_WHSE_PART_PLANNING.
--  130912  DaZase  Added attribute remove_excess_inventory.
--  130906  RILASE  Added attribute REFILL_SOURCE.
--  130820  Matkse  Modified call to Get_Qty_Outbound_For_Warehouse in REMOTE_WHSE_PART_PLANNING due to changed definition.
--  130816  Matkse  Added new attribute qty_outbound to view REMOTE_WHSE_PART_PLANNING.
--  130424  DaZase  Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Refills___ (
   refill_point_qty_ IN NUMBER,
   refill_to_qty_    IN NUMBER )
IS
BEGIN
   IF (refill_point_qty_ < 0 OR refill_to_qty_ < 0) THEN      
      Error_SYS.Record_General(lu_name_,'NONEGATIVEREFILLS: Negative values are not allowed.');
   END IF;
   IF (refill_point_qty_ > refill_to_qty_) THEN      
      Error_SYS.Record_General(lu_name_,'REFILLTOLARGERPOINT: Refill To Qty must be larger or equal to Refill Point Qty.');
   END IF;
   IF ((TRUNC(refill_point_qty_) != refill_point_qty_) OR (TRUNC(refill_to_qty_) != refill_to_qty_)) THEN
      Error_SYS.Record_General(lu_name_,'NODECIMALSFORREFILLQTY: Decimal values are not allowed.');
   END IF;
END Check_Refills___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('REFILL_SOURCE', Remote_Whse_Refill_Source_API.Decode(Remote_Whse_Refill_Source_API.DB_INVENTORY), attr_);
   Client_SYS.Add_To_Attr('REMOVE_EXCESS_INVENTORY_DB', Fnd_Boolean_API.db_true, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT remote_whse_assort_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF (NOT indrec_.remove_excess_inventory) THEN 
      newrec_.remove_excess_inventory := Fnd_Boolean_API.db_true;
   END IF;
   super(newrec_, indrec_, attr_);

   Remote_Whse_Assortment_API.Check_Inventory_Part(assortment_id_          => newrec_.assortment_id, 
                                                   contract_               => NULL,
                                                   part_no_                => newrec_.part_no,
                                                   valid_for_all_sites_db_ => NULL);
   Check_Refills___(newrec_.refill_point_qty, newrec_.refill_to_qty);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     remote_whse_assort_part_tab%ROWTYPE,
   newrec_ IN OUT remote_whse_assort_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   Check_Refills___(newrec_.refill_point_qty, newrec_.refill_to_qty);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ remote_whse_assort_part_tab%ROWTYPE ) 
IS
BEGIN
   Error_SYS.Record_General(lu_name_,'REMOTEASSORTRECORDEXIST: Part :P1 is already connected to the remote warehouse assortment.', rec_.part_no);
   super(rec_);
END Raise_Record_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Refill_Point_Inv_Qty (
   assortment_id_ IN VARCHAR2,
   part_no_       IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN NUMBER
IS
   partca_qty_ REMOTE_WHSE_ASSORT_PART_TAB.refill_point_qty%TYPE;
   invent_qty_ NUMBER;
BEGIN
   partca_qty_ := Get_Refill_Point_Qty(assortment_id_, part_no_);
   invent_qty_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_  => partca_qty_, 
                                                           from_unit_code_ => Part_Catalog_API.Get_Unit_Code(part_no_), 
                                                           to_unit_code_   => Inventory_Part_API.Get_Unit_Meas(contract_, part_no_));
   RETURN invent_qty_;
END Get_Refill_Point_Inv_Qty;


@UncheckedAccess
FUNCTION Get_Refill_To_Inv_Qty (
   assortment_id_ IN VARCHAR2,
   part_no_       IN VARCHAR2,
   contract_      IN VARCHAR2 ) RETURN NUMBER
IS
   partca_qty_ REMOTE_WHSE_ASSORT_PART_TAB.refill_to_qty%TYPE;
   invent_qty_ NUMBER;
BEGIN
   partca_qty_ := Get_Refill_To_Qty(assortment_id_, part_no_);
   invent_qty_ := Iso_Unit_API.Get_Unit_Converted_Quantity(from_quantity_  => partca_qty_, 
                                                           from_unit_code_ => Part_Catalog_API.Get_Unit_Code(part_no_), 
                                                           to_unit_code_   => Inventory_Part_API.Get_Unit_Meas(contract_, part_no_));
   RETURN invent_qty_;
END Get_Refill_To_Inv_Qty;


@UncheckedAccess
FUNCTION Get_Prioritized_Assortment_Id (
   part_no_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   assortment_id_ VARCHAR2(50);

   CURSOR get_assortments IS
      SELECT rwap.assortment_id
      FROM REMOTE_WHSE_ASSORT_PART_TAB rwap, REMOTE_WHSE_ASSORTMENT_TAB rwa, REMOTE_WHSE_ASSORT_CONNECT_TAB rwac
      WHERE rwap.part_no = part_no_
      AND   rwap.assortment_id =  rwa.assortment_id
      AND   rwap.assortment_id = rwac.assortment_id 
      AND   rwac.contract = contract_
      AND   rwac.warehouse_id = warehouse_id_
      ORDER BY rwa.priority ASC, rwap.refill_point_qty DESC, rwap.refill_to_qty DESC, rwa.rowversion DESC;
BEGIN
   OPEN  get_assortments;
   FETCH get_assortments INTO assortment_id_;
   CLOSE get_assortments;
   RETURN assortment_id_;
END Get_Prioritized_Assortment_Id;


@UncheckedAccess
FUNCTION Get_Plannable_Qty (
   part_no_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   plannable_qty_ NUMBER := 0;
BEGIN
   plannable_qty_ := plannable_qty_ + Inventory_Part_In_Stock_API.Get_Inventory_Quantity(contract_                     => contract_, 
                                                                                         part_no_                      => part_no_, 
                                                                                         configuration_id_             => '*', 
                                                                                         qty_type_                     => 'AVAILTRANSIT', 
                                                                                         expiration_control_           => 'NOT EXPIRED',
                                                                                         supply_control_db_            => 'NETTABLE', 
                                                                                         ownership_type1_db_           => 'COMPANY OWNED',
                                                                                         ownership_type2_db_           => 'CONSIGNMENT', 
                                                                                         include_standard_             => 'TRUE',
                                                                                         include_project_              => 'FALSE',
                                                                                         warehouse_id_                 => warehouse_id_,
                                                                                         ignore_this_avail_control_id_ => Warehouse_API.Get_Availability_Control_Id(contract_, warehouse_id_));   
   plannable_qty_ := plannable_qty_ + Transport_Task_API.Get_Qty_Inbound_For_Warehouse(part_no_          => part_no_, 
                                                                                       configuration_id_ => '*', 
                                                                                       contract_         => contract_, 
                                                                                       warehouse_id_     => warehouse_id_);
   plannable_qty_ := plannable_qty_ + Get_Qty_Inbound_For_Purchase(part_no_      => part_no_,
                                                                   contract_     => contract_,
                                                                   warehouse_id_ => warehouse_id_);
                                                                   
   plannable_qty_ := plannable_qty_ + Transport_Task_API.Get_Intra_Warehouse_Move_Qty(part_no_          => part_no_, 
                                                                                      configuration_id_ => '*', 
                                                                                      contract_         => contract_, 
                                                                                      warehouse_id_     => warehouse_id_);                                                              
   RETURN plannable_qty_;
END Get_Plannable_Qty;


@UncheckedAccess
FUNCTION Get_Qty_Inbound_For_Purchase (
   part_no_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   qty_inbound_ NUMBER;
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN 
      qty_inbound_ := Purchase_Order_Line_Part_API.Get_Qty_Inbound_For_Warehouse(part_no_,
                                                                                 contract_,
                                                                                 warehouse_id_);
      qty_inbound_ := qty_inbound_ + Purchase_Req_Line_Part_API.Get_Qty_Inbound_For_Warehouse(part_no_,
                                                                                              contract_,
                                                                                              warehouse_id_);
   $ELSE
      qty_inbound_ := 0;
   $END
   
   RETURN qty_inbound_;
END Get_Qty_Inbound_For_Purchase;


@UncheckedAccess
FUNCTION Req_Line_Exist_For_Warehouse (
   part_no_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   line_exist_ NUMBER;
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN 
      line_exist_ := Purchase_Req_Line_Part_API.Line_Exist_For_Warehouse(part_no_,
                                                                         contract_,
                                                                         warehouse_id_);
   $ELSE
      line_exist_ := 0;
   $END
   
   RETURN line_exist_;
END Req_Line_Exist_For_Warehouse;


@UncheckedAccess
FUNCTION Po_Line_Exist_For_Warehouse (
   part_no_      IN VARCHAR2,
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   line_exist_ NUMBER;
BEGIN
   $IF Component_Purch_SYS.INSTALLED $THEN 
      line_exist_ := Purchase_Order_Line_Part_API.Line_Exist_For_Warehouse(part_no_,
                                                                           contract_,
                                                                           warehouse_id_);
   $ELSE
      line_exist_ := 0;
   $END
   
   RETURN line_exist_;
END Po_Line_Exist_For_Warehouse;

