-----------------------------------------------------------------------------
--
--  Logical unit: OrderType
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201001  LEPESE  SC2020R1-317, added conversion for DB_WORK_TASK in Get_Order_Suppl_Demand_Type_Db.
--  200311  RoJalk  SCSPRING20-1930, Modified Get_Order_Suppl_Demand_Type_Db to support Shipment Order.  
--  200102  UdGnlk  Bug 150959 (SCZ-7515), Modified Get_Order_Suppl_Demand_Type_Db() to add
--  200102          new order type DB_PROJ_MISC_DEMAND to get order supply demand type.
--  171016  LEPESE  STRSC-12433, Added method Get_Order_Suppl_Demand_Type_Db.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Order_Suppl_Demand_Type_Db (
   order_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_supply_demand_type_db_ VARCHAR2(20);
BEGIN
   $IF Component_Mpccom_SYS.INSTALLED $THEN
      order_supply_demand_type_db_ := CASE order_type_db_ 
                                         WHEN DB_WORK_ORDER           THEN Order_Supply_Demand_Type_API.DB_WORK_ORDER                                                                                                               
                                         WHEN DB_WORK_TASK            THEN Order_Supply_Demand_Type_API.DB_WORK_TASK
                                         WHEN DB_CUSTOMER_ORDER       THEN Order_Supply_Demand_Type_API.DB_CUST_ORDER
                                         WHEN DB_SHOP_ORDER           THEN Order_Supply_Demand_Type_API.DB_MATERIAL_RES_SO
                                         WHEN DB_DOP_DEMAND           THEN Order_Supply_Demand_Type_API.DB_DOP_DEMAND
                                         WHEN DB_DOP_NETTED_DEMAND    THEN Order_Supply_Demand_Type_API.DB_DOP_NETTED_DEMAND
                                         WHEN DB_PURCHASE_ORDER       THEN Order_Supply_Demand_Type_API.DB_PURCH_ORDER_RES     
                                         WHEN DB_PRODUCTION_SCHEDULE  THEN Order_Supply_Demand_Type_API.DB_PROD_SCHEDULE_DEMAND
                                         WHEN DB_PROJECT_DELIVERABLES THEN Order_Supply_Demand_Type_API.DB_PROJECT_DELIVERABLES
                                         WHEN DB_MATERIAL_REQUISITION THEN Order_Supply_Demand_Type_API.DB_MATERIAL_REQ
                                         WHEN DB_SHIPMENT_ORDER       THEN Order_Supply_Demand_Type_API.DB_SHIPMENT_ORDER
                                         WHEN DB_PROJ_MISC_DEMAND     THEN Order_Supply_Demand_Type_API.DB_PROJ_MISC_DEMAND END;
   $ELSE
      Error_SYS.Component_Not_Exist('MPCCOM');
   $END
                                            
   RETURN(order_supply_demand_type_db_);
END Get_Order_Suppl_Demand_Type_Db;

-------------------- LU  NEW METHODS -------------------------------------
