CREATE OR REPLACE PACKAGE Bc_Rco_Handling_SVC IS

module_  CONSTANT VARCHAR2(25)  := 'BCRCO';
lu_name_ CONSTANT VARCHAR2(250) := 'BcRcoHandling';
lu_type_ CONSTANT VARCHAR2(25)  := 'Projection';

-----------------------------------------------------------------------------
---------------------------- PUBLIC DECLARATIONS ----------------------------
-----------------------------------------------------------------------------

TYPE Entity_Dec IS RECORD (
   etag                           VARCHAR2(100),
   info                           VARCHAR2(4000),
   attr                           VARCHAR2(32000));

TYPE Entity_Small_Dec IS RECORD (
   etag                           VARCHAR2(100),
   info                           VARCHAR2(4000),
   attr                           VARCHAR2(4000));

TYPE Entity_Small_Drr      IS TABLE OF Entity_Small_Dec;

TYPE Entity_Drr      IS TABLE OF Entity_Dec;

TYPE Objid_Arr       IS TABLE OF VARCHAR2(100);

TYPE Empty_Art       IS TABLE OF VARCHAR2(1);

TYPE Boolean_Arr     IS TABLE OF BOOLEAN;

TYPE Boolean_Art     IS TABLE OF VARCHAR2(5);

TYPE Number_Arr      IS TABLE OF NUMBER;

TYPE Text_Arr        IS TABLE OF VARCHAR2(4000);

TYPE Stream_Data_Rec IS RECORD (
   file_name                           VARCHAR2(100),
   mime_type                           VARCHAR2(100),
   stream_data                         BLOB);

TYPE Stream_Data_Arr IS TABLE OF Stream_Data_Rec;

TYPE Stream_Info_Rec IS RECORD (
   file_name                           VARCHAR2(100),
   mime_type                           VARCHAR2(100));

TYPE Stream_Text_Data_Rec IS RECORD (
   file_name                           VARCHAR2(100),
   mime_type                           VARCHAR2(100),
   stream_data                         CLOB);

TYPE Copy_Values_Rec IS RECORD (
   modified_source                VARCHAR2(32000));


-----------------------------------------------------------------------------
------------------------- METADATA PROVIDER METHODS -------------------------
-----------------------------------------------------------------------------

FUNCTION Verify_Metadata_Sql_Content_ (
   metadata_version_ IN VARCHAR2 ) RETURN VARCHAR2;

PROCEDURE Verify_Metadata_Plsql_Content_ (
   metadata_version_ IN VARCHAR2 );

FUNCTION Get_Metadata_Content_ (
   context_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB;

FUNCTION Get_Metadata_Version_ (
   context_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2;

FUNCTION Get_Metadata_Category_ (
   context_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2;

FUNCTION Get_Metadata_Service_Group_ (
   context_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2;

-----------------------------------------------------------------------------
------------------------------- GLOBAL METHODS ------------------------------
-----------------------------------------------------------------------------
--@PoReadOnly(Do_Create_New_Cust_Order)
PROCEDURE Do_Create_New_Cust_Order(customer_id_ IN VARCHAR2, rco_no_ IN NUMBER, contract_ IN VARCHAR2, currency_ IN VARCHAR2, delivery_address_id_ IN VARCHAR2, unbound## IN VARCHAR2);
--@PoReadOnly(Do_Refresh_Page)
FUNCTION Do_Refresh_Page(unbound## IN VARCHAR2) RETURN Text_Arr;

--@PoReadOnly(Rd_Get_Def_Infolog_Part)
FUNCTION Rd_Get_Def_Infolog_Part(rco_line_ IN NUMBER, rco_no_ IN NUMBER, unbound## IN VARCHAR2) RETURN Text_Arr PIPELINED;

--@PoReadOnly(Rd_Get_Def_Infolog_Part_Site)
FUNCTION Rd_Get_Def_Infolog_Part_Site(rco_line_ IN NUMBER, rco_no_ IN NUMBER, unbound## IN VARCHAR2) RETURN Text_Arr PIPELINED;

--@PoReadOnly(Rd_Get_Default_Address)
FUNCTION Rd_Get_Default_Address(customer_id_ IN VARCHAR2, address_type_ IN VARCHAR2, unbound## IN VARCHAR2) RETURN Text_Arr PIPELINED;

--@PoReadOnly(Rd_Get_Owner_Id)
FUNCTION Rd_Get_Owner_Id(rco_no_ IN NUMBER, unbound## IN VARCHAR2) RETURN Text_Arr PIPELINED;

-----------------------------------------------------------------------------
--------------------- METHODS FOR BC REPAIR CENTER ORDER --------------------
-----------------------------------------------------------------------------


--@PoReadOnly(CRUD_Default)
FUNCTION CRUD_Default(attr_ IN VARCHAR2 DEFAULT NULL, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Small_Drr PIPELINED;

--@PoReadOnly(CRUD_Default_Copy)
FUNCTION CRUD_Default_Copy(values_ IN Copy_Values_Rec, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Dec;

FUNCTION CRUD_Default_Copy(etag_ IN VARCHAR2, rco_no_ IN NUMBER, values_ IN Copy_Values_Rec, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Create)
FUNCTION CRUD_Create(attr_ IN VARCHAR2, action_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Update)
FUNCTION CRUD_Update(etag_ IN VARCHAR2, rco_no_ IN NUMBER, attr_ IN VARCHAR2, action$_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Delete)
FUNCTION CRUD_Delete(etag_ IN VARCHAR2, rco_no_ IN NUMBER, action$_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(Ev_Cancel)
FUNCTION Ev_Cancel(etag_ IN VARCHAR2, rco_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Release)
FUNCTION Ev_Release(etag_ IN VARCHAR2, rco_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Start)
FUNCTION Ev_Start(etag_ IN VARCHAR2, rco_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Complete)
FUNCTION Ev_Complete(etag_ IN VARCHAR2, rco_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Close)
FUNCTION Ev_Close(etag_ IN VARCHAR2, rco_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Reopen)
FUNCTION Ev_Reopen(etag_ IN VARCHAR2, rco_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_center_order## IN VARCHAR2) RETURN Entity_Small_Drr;

-----------------------------------------------------------------------------
------------------------- METHODS FOR BC REPAIR LINE ------------------------
-----------------------------------------------------------------------------


--@PoReadOnly(CRUD_Default)
FUNCTION CRUD_Default(attr_ IN VARCHAR2 DEFAULT NULL, bc_repair_line## IN VARCHAR2) RETURN Entity_Small_Drr PIPELINED;

--@PoReadOnly(CRUD_Default_Copy)
FUNCTION CRUD_Default_Copy(values_ IN Copy_Values_Rec, bc_repair_line## IN VARCHAR2) RETURN Entity_Dec;

FUNCTION CRUD_Default_Copy(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, values_ IN Copy_Values_Rec, bc_repair_line## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Create)
FUNCTION CRUD_Create(attr_ IN VARCHAR2, action_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Update)
FUNCTION CRUD_Update(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, attr_ IN VARCHAR2, action$_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Delete)
FUNCTION CRUD_Delete(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, action$_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(Ev_Cancel)
FUNCTION Ev_Cancel(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Receive)
FUNCTION Ev_Receive(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Process)
FUNCTION Ev_Process(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Repair_Start)
FUNCTION Ev_Repair_Start(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Repair_Complete)
FUNCTION Ev_Repair_Complete(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Small_Drr;

--@PoReadOnly(Ev_Ship)
FUNCTION Ev_Ship(etag_ IN VARCHAR2, rco_no_ IN NUMBER, repair_line_no_ IN NUMBER, action_ IN VARCHAR2, bc_repair_line## IN VARCHAR2) RETURN Entity_Small_Drr;

-----------------------------------------------------------------------------
-------------------------- METHODS FOR BC LOG INFO --------------------------
-----------------------------------------------------------------------------


--@PoReadOnly(CRUD_Default)
FUNCTION CRUD_Default(attr_ IN VARCHAR2 DEFAULT NULL, bc_log_info## IN VARCHAR2) RETURN Entity_Small_Drr PIPELINED;

--@PoReadOnly(CRUD_Default_Copy)
FUNCTION CRUD_Default_Copy(values_ IN Copy_Values_Rec, bc_log_info## IN VARCHAR2) RETURN Entity_Dec;

FUNCTION CRUD_Default_Copy(etag_ IN VARCHAR2, rco_no_ IN NUMBER, log_info_id_ IN NUMBER, values_ IN Copy_Values_Rec, bc_log_info## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Create)
FUNCTION CRUD_Create(attr_ IN VARCHAR2, action_ IN VARCHAR2, bc_log_info## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Update)
FUNCTION CRUD_Update(etag_ IN VARCHAR2, rco_no_ IN NUMBER, log_info_id_ IN NUMBER, attr_ IN VARCHAR2, action$_ IN VARCHAR2, bc_log_info## IN VARCHAR2) RETURN Entity_Dec;

--@PoReadOnly(CRUD_Delete)
FUNCTION CRUD_Delete(etag_ IN VARCHAR2, rco_no_ IN NUMBER, log_info_id_ IN NUMBER, action$_ IN VARCHAR2, bc_log_info## IN VARCHAR2) RETURN Entity_Dec;

-----------------------------------------------------------------------------
------------------------- METHODS FOR CUSTOMER INFO -------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
--------------------- METHODS FOR CUSTOMER INFO ADDRESS ---------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
-------------------------- METHODS FOR ISO CURRENCY -------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
------------------------------ METHODS FOR SITE -----------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
------------------------- METHODS FOR CUSTOMER ORDER ------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
---------------------------- METHODS FOR FND USER ---------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
------------------------- METHODS FOR BC REPAIR TYPE ------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
------------------------- METHODS FOR CONDITION CODE ------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
------------------------- METHODS FOR INVENTORY PART ------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
--------------------- METHODS FOR BC REPAIR LINE ACTION ---------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
---------------------- METHODS FOR LOOKUP ISO CURRENCY ----------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
------------------------ METHODS FOR LOOKUP ISO UNIT ------------------------
-----------------------------------------------------------------------------


-----------------------------------------------------------------------------
----------------------- METHODS FOR LOOKUP ISO COUNTRY ----------------------
-----------------------------------------------------------------------------


END Bc_Rco_Handling_SVC;