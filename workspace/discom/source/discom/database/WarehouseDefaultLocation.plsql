-----------------------------------------------------------------------------
--
--  Logical unit: WarehouseDefaultLocation
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220628  SaLelk  SCDEV-7837, Add new method Get_Default_Location to fetch default location by global_warehouse_id_.
--  210614  SBalLK  SC21R2-1204, Added New() method for allow create new record from RemoteWarehouseManager utility.
--  200813  AsZelk  SC2020R1-7066, Removed dynamic dependency to Invent.
--  200601  Aabalk  SCSPRING20-1687, Modified Check_Common___ by adding a check to validate if selected default location is within the remote warehouse specified.
--  200122  RasDlk  SCSPRING20-689, Modified Check_Common___ to allow the user to add Shipment Inventory locations for Remote Warehouses.
--  191104  ErRalk  Moved code in WhseReceiptDefaultLoc.plsql into WarehouseDefaultLocation. 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     warehouse_default_location_tab%ROWTYPE,
   newrec_ IN OUT warehouse_default_location_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_                   VARCHAR2(30);
   value_                  VARCHAR2(4000);
   concat_types_           VARCHAR2(500);
   concat_type_arrival_    VARCHAR2(200);
   concat_type_qa_         VARCHAR2(200);
   concat_type_shipment_   VARCHAR2(200);
BEGIN
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   -- Check if location_no is Receipts Blocked
   Warehouse_Bay_Bin_API.Check_Receipts_Blocked(newrec_.contract, newrec_.location_no);
   concat_types_           := Inventory_Location_Type_API.Decode('PICKING')|| ', ' ||
                              Inventory_Location_Type_API.Decode('F')||', '||
                              Inventory_Location_Type_API.Decode('MANUFACTURING');
   concat_type_arrival_    := Inventory_Location_Type_API.Decode('ARRIVAL');
   concat_type_qa_         := Inventory_Location_Type_API.Decode('QA');
   concat_type_shipment_   := Inventory_Location_Type_API.Decode('SHIPMENT');
   
   IF (NOT Inventory_Location_API.Is_Location_In_Warehouse(newrec_.contract, newrec_.location_no, newrec_.warehouse_id)) THEN
      Error_SYS.Record_General(lu_name_, 'INV_REMOTE_LOC: Only locations within remote warehouse :P1 can be selected.', newrec_.warehouse_id);
   END IF;
   
   IF newrec_.location_type IN ('PICKING', 'F', 'MANUFACTURING') THEN
      IF ((Get_Location_No(newrec_.contract, newrec_.warehouse_id) IS NOT NULL) AND
          (NOT Check_Exist___(newrec_.contract, newrec_.warehouse_id, newrec_.location_type))) THEN         
         Error_SYS.Record_General('WarehouseDefaultLocation', 'ONE_STOCK_TYPE: Only one default location of the types :P1 can be entered.', concat_types_);
      END IF;
   ELSIF newrec_.location_type IN ('ARRIVAL') THEN
      IF ((Get_Arrival_Location_No(newrec_.contract, newrec_.warehouse_id) IS NOT NULL) AND
          (NOT Check_Exist___(newrec_.contract, newrec_.warehouse_id, newrec_.location_type))) THEN
         Error_SYS.Record_General('WarehouseDefaultLocation', 'ONE_ARRIVAL_TYPE: Only one default arrival location of type :P1 can be entered.', concat_type_arrival_);
      END IF;
   ELSIF newrec_.location_type IN ('QA') THEN
      IF ((Get_Qa_Location_No(newrec_.contract, newrec_.warehouse_id) IS NOT NULL) AND
          (NOT Check_Exist___(newrec_.contract, newrec_.warehouse_id, newrec_.location_type))) THEN
         Error_SYS.Record_General('WarehouseDefaultLocation', 'ONE_QA_TYPE: Only one default inspection location of type :P1 can be entered.', concat_type_qa_);
      END IF;
   ELSIF newrec_.location_type IN ('SHIPMENT') THEN
      IF ((Get_Shipment_Location_No(newrec_.contract, newrec_.warehouse_id) IS NOT NULL) AND
          (NOT Check_Exist___(newrec_.contract, newrec_.warehouse_id, newrec_.location_type))) THEN
         Error_SYS.Record_General('WarehouseDefaultLocation', 'ONE_SHIPMENT_TYPE: Only one default shipment location of type :P1 can be entered.', concat_type_shipment_);
      END IF;
   ELSE
      Error_SYS.Record_General('WarehouseDefaultLocation', 'NOT_VALID_DEF_LOC: This location is not valid as default location.');
   END IF;

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);   
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New(
   contract_         IN VARCHAR2,
   warehouse_id_     IN VARCHAR2,
   location_type_db_ IN VARCHAR2,
   location_no_      IN VARCHAR2 )
IS
   newrec_  warehouse_default_location_tab%ROWTYPE;
BEGIN
   newrec_.contract      := contract_;
   newrec_.warehouse_id  := warehouse_id_;
   newrec_.location_type := location_type_db_;
   newrec_.location_no   := location_no_;
   New___(newrec_);
END New;


-- Get_Location_No
--   Fetches the location no for a warehouse at a site for location type Picking,
--   F, Delivery or Manufacturing
@UncheckedAccess
FUNCTION Get_Location_No (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ WAREHOUSE_DEFAULT_LOCATION_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM  WAREHOUSE_DEFAULT_LOCATION_TAB
      WHERE contract      = contract_
      AND   warehouse_id  = warehouse_id_
      AND   location_type IN ('PICKING', 'F', 'MANUFACTURING');
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Location_No;


-- Get_Arrival_Location_No
--   Fetches the location no for a warehouse at a site for location type Arrival
@UncheckedAccess
FUNCTION Get_Arrival_Location_No (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ WAREHOUSE_DEFAULT_LOCATION_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM  WAREHOUSE_DEFAULT_LOCATION_TAB
      WHERE contract      = contract_
      AND   warehouse_id  = warehouse_id_
      AND   location_type = 'ARRIVAL';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Arrival_Location_No;


-- Get_Qa_Location_No
--   Fetches the location no for a warehouse at a site for location type QA
@UncheckedAccess
FUNCTION Get_Qa_Location_No (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ WAREHOUSE_DEFAULT_LOCATION_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM WAREHOUSE_DEFAULT_LOCATION_TAB
      WHERE contract      = contract_
      AND   warehouse_id  = warehouse_id_
      AND   location_type = 'QA';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Qa_Location_No;


-- Get_Shipment_Location_No
--   Fetches the location no for a warehouse at a site for location type SHIPMENT
@UncheckedAccess
FUNCTION Get_Shipment_Location_No (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ WAREHOUSE_DEFAULT_LOCATION_TAB.location_no%TYPE;
   CURSOR get_attr IS
      SELECT location_no
      FROM WAREHOUSE_DEFAULT_LOCATION_TAB
      WHERE contract      = contract_
      AND   warehouse_id  = warehouse_id_
      AND   location_type = 'SHIPMENT';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Shipment_Location_No;


@UncheckedAccess
FUNCTION Get_Default_Location (
   contract_     IN VARCHAR2,
   warehouse_id_ IN VARCHAR2,
   receive_case_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   location_no_ VARCHAR2(35);
BEGIN
   -- Get the default location for the remote warehouse
   IF (receive_case_ = 'INVDIR') THEN
      location_no_ := Get_Location_No(contract_, warehouse_id_);
   ELSIF (receive_case_ IN ('ARRINV', 'ARRINSP', 'ARRQA', 'ARRPUT')) THEN
      location_no_ := Get_Arrival_Location_No(contract_, warehouse_id_);
   ELSIF (receive_case_ = 'QAINV') THEN
      location_no_ := Get_Qa_Location_No(contract_, warehouse_id_);
   END IF;
   
   RETURN location_no_;
END Get_Default_Location;

@UncheckedAccess
FUNCTION Get_Default_Location (
   global_warehouse_id_ IN VARCHAR2) RETURN VARCHAR2 
IS
   location_no_     VARCHAR2(35);
   warehouse_rec_   Warehouse_API.Public_Rec;
   warehouse_id_    VARCHAR2(15);
   receive_case_db_ VARCHAR2(20);
BEGIN
   warehouse_rec_     := Warehouse_API.Get(global_warehouse_id_);
   warehouse_id_      := warehouse_rec_.warehouse_id;
   receive_case_db_   := Whse_Shipment_Receipt_Info_API.Get_Receive_Case_Db(warehouse_rec_.contract, warehouse_id_);
   -- Get the default location for the remote warehouse
   location_no_       := Get_Default_Location(warehouse_rec_.contract, warehouse_id_, receive_case_db_);                                         
   RETURN location_no_;
END Get_Default_Location;

