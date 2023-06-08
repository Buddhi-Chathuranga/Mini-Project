-----------------------------------------------------------------------------
--
--  Logical unit: LogisticsSourceRefType
--  Component:    DISCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  220603  AvWilk  SCDEV-8633, Added DB_PURCH_RECEIPT_RETURN into Get_Order_Type_Db.
--  201009  AsZelk  SC2020R1-10459, Added DB_SHIPMENT_ORDER into Get_Order_Type_Db.
--  200720  UdGnlk  Bug 154890(SCZ-10818),  Added method Get_Order_Type_Db.
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
   logistics_source_ref_type_db_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   order_type_db_ VARCHAR2(20);   
BEGIN
    
   order_type_db_ := CASE logistics_source_ref_type_db_ 
                        WHEN DB_PURCHASE_ORDER       THEN Order_Type_API.DB_PURCHASE_ORDER                                                                                                              
                        WHEN DB_CUSTOMER_ORDER       THEN Order_Type_API.DB_CUSTOMER_ORDER                             
                        WHEN DB_PROJECT_DELIVERABLES THEN Order_Type_API.DB_PROJECT_DELIVERABLES 
                        WHEN DB_SHIPMENT_ORDER       THEN Order_Type_API.DB_SHIPMENT_ORDER
                        WHEN DB_PURCH_RECEIPT_RETURN THEN Order_Type_API.DB_PURCH_RECEIPT_RETURN END;  
                                      
   RETURN(order_type_db_);
END Get_Order_Type_Db;
-------------------- LU  NEW METHODS -------------------------------------
