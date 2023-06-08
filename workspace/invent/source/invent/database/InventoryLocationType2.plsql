-----------------------------------------------------------------------------
--
--  Logical unit: InventoryLocationType2
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
--  ---------------- VIEWS FOR SELECT
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Exist (
   db_value_ IN VARCHAR2 )
IS
BEGIN
   IF db_value_ IN ('CONSIGNMENT','INT ORDER TRANSIT','DELIVERY CONFIRM', 'PART EXCHANGE') THEN
      NULL;
   ELSE
      Inventory_Location_Type_API.Exist_Db(db_value_);
   END IF;
END Exist;

PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
   active_consignment_     CONSTANT VARCHAR2(200) := Language_SYS.Translate_Constant(lu_name_, 'CONSDESC: Consignment stock');
   active_order_transit_   CONSTANT VARCHAR2(200) := Language_SYS.Translate_Constant(lu_name_, 'INTORDTDESC: Internal Order Transit');
   active_deliver_confirm_ CONSTANT VARCHAR2(200) := Language_SYS.Translate_Constant(lu_name_, 'DELCONDESC: Delivered Not Confirmed');
   active_part_exchange_   CONSTANT VARCHAR2(200) := Language_SYS.Translate_Constant(lu_name_, 'PARTEXDESC: Part Exchange');
BEGIN
   IF value_ = 'CONSIGNMENT' THEN
      description_ := active_consignment_;
   ELSIF value_ = 'INT ORDER TRANSIT' THEN
      description_ := active_order_transit_;
   ELSIF value_ = 'DELIVERY CONFIRM' THEN
      description_ := active_deliver_confirm_;
   ELSIF value_ = 'PART EXCHANGE' THEN
      description_ := active_part_exchange_; 
   ELSE
      description_ := Inventory_Location_Type_API.Decode(value_);
   END IF;
END Get_Control_Type_Value_Desc;




