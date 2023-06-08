-----------------------------------------------------------------------------
--
--  Logical unit: OrderSupplyDemandType
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201001  LEPESE  SC2020R1-317, added conversion for DB_WORK_TASK in Get_Order_Type_Db.
--  200311  RoJalk  SCSPRING20-1930, Modified Get_Order_Type_Db to support Shipment Order.  
--  200102  UdGnlk  Bug 150959 (SCZ-7515), Modified Get_Order_Type_Db() to add
--  200102          order supply demand type to get new order type DB_PROJ_MISC_DEMAND.
--  200102          order supply demand type to get new order type DB_PROJ_MISC_DEMAND.
--  171016  LEPESE  STRSC-12433, Added method Get_Order_Type_Db.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Order_Type_Db (
   order_supply_demand_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_type_db_ VARCHAR2(20);
BEGIN
   order_type_db_ := CASE order_supply_demand_type_db_
                        WHEN DB_WORK_ORDER           THEN Order_Type_API.DB_WORK_ORDER                                                                                                               
                        WHEN DB_WORK_TASK            THEN Order_Type_API.DB_WORK_TASK
                        WHEN DB_CUST_ORDER           THEN Order_Type_API.DB_CUSTOMER_ORDER      
                        WHEN DB_DOP_DEMAND           THEN Order_Type_API.DB_DOP_DEMAND          
                        WHEN DB_DOP_NETTED_DEMAND    THEN Order_Type_API.DB_DOP_NETTED_DEMAND   
                        WHEN DB_PROJECT_DELIVERABLES THEN Order_Type_API.DB_PROJECT_DELIVERABLES      
                        WHEN DB_PURCH_ORDER_RES      THEN Order_Type_API.DB_PURCHASE_ORDER      
                        WHEN DB_MATERIAL_RES_SO      THEN Order_Type_API.DB_SHOP_ORDER          
                        WHEN DB_PROD_SCHEDULE_DEMAND THEN Order_Type_API.DB_PRODUCTION_SCHEDULE 
                        WHEN DB_SHIPMENT_ORDER       THEN Order_Type_API.DB_SHIPMENT_ORDER      
                        WHEN DB_MATERIAL_REQ         THEN Order_Type_API.DB_MATERIAL_REQUISITION
                        WHEN DB_PROJ_MISC_DEMAND     THEN Order_Type_API.DB_PROJ_MISC_DEMAND END;

   RETURN(order_type_db_);
END Get_Order_Type_Db;

-------------------- LU  NEW METHODS -------------------------------------
