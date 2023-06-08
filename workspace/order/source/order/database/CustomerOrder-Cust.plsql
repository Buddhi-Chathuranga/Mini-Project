-----------------------------------------------------------------------------
--
--  Logical unit: CustomerOrder
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  230501  Buddhi  Initial Mini Project Develop
-----------------------------------------------------------------------------

layer Cust;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
--(+)220615 SEBSA-BUDDHI MINIPROJECT(START)
/*
@Override
PROCEDURE Order_Delivered___ (
   rec_  IN OUT CUSTOMER_ORDER_TAB%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   rco_no_ bc_repair_center_order.rco_no%TYPE;
   
   CURSOR      get_rco is 
      SELECT   rco_no
      FROM     bc_repair_center_order_tab
      WHERE    customer_order_no = rec_.order_no; 
BEGIN
   
   super(rec_, attr_);
   
   OPEN  get_rco; 
   FETCH get_rco INTO rco_no_;
   CLOSE get_rco; 
   
   Bc_Repair_Line_API.Change_To_Shipped__(rco_no_);
END Order_Delivered___;
*/



--(+)220615 SEBSA-BUDDHI MINIPROJECT(FINSH)



-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU CUST NEW METHODS -------------------------------------
