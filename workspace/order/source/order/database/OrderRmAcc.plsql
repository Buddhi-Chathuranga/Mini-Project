-----------------------------------------------------------------------------
--
--  Logical unit: OrderRmAcc
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170321  SudJlk  VAULT-2586, Modified the logic in Return_Material_Chk.
--  170317  JanWse  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Return_Material_Chk (
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- These values depends on how the parameters in the DbRmcomAccess statement is defined in ReturnMaterial.entity
   customer_no_   VARCHAR2(128) := Client_SYS.Get_Item_Value('OWNER_ID'          , attr_);
   order_no_      VARCHAR2(128) := Client_SYS.Get_Item_Value('PARENT_FILTER_NAME', attr_);
   privilege_id_  VARCHAR2(128) := Client_SYS.Get_Item_Value('PRIVILEGE_ID'      , attr_);
   
   FUNCTION Check_Access_For_Co (
      customer_no_   IN VARCHAR2,
      order_no_      IN VARCHAR2,
      privilege_id_  IN VARCHAR2 ) RETURN BOOLEAN
   IS
      msg_  VARCHAR2(4000) := 'You do not have read access to the customer order you are trying to connect to the return material authorization.';
   BEGIN
      $IF Component_Rmcom_SYS.INSTALLED $THEN
         IF order_no_ IS NULL THEN
            RETURN TRUE;
         END IF;
         RETURN Rm_Acc_Usage_API.Possible_To_Read(Business_Object_Type_API.DB_CUSTOMER_ORDER, NULL, order_no_, customer_no_, NULL, msg_);
      $END
      RETURN TRUE;
   END Check_Access_For_Co;
   
BEGIN
   IF Check_Access_For_Co(customer_no_, order_no_, privilege_id_) THEN
      RETURN Fnd_Boolean_API.DB_True;
   END IF;
   RETURN Fnd_Boolean_API.DB_False;
END Return_Material_Chk;

FUNCTION Return_Material_Line_Chk (
   attr_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   -- These values depends on how the parameters in the DbRmcomAccess statement is defined in ReturnMaterialLine.entity
   order_no_   VARCHAR2(128) := Client_SYS.Get_Item_Value('OWNER_ID',  attr_);
   
   FUNCTION Check_Access_For_Co (
      order_no_   IN VARCHAR2 ) RETURN BOOLEAN
   IS
      msg_  VARCHAR2(4000) := 'You do not have read access to the customer order you are trying to connect to the return material authorization line.';
   BEGIN
      $IF Component_Rmcom_SYS.INSTALLED $THEN
         IF order_no_ IS NULL THEN
            RETURN TRUE;
         END IF;
         RETURN Rm_Acc_Usage_API.Possible_To_Read(Business_Object_Type_API.DB_CUSTOMER_ORDER, NULL, order_no_, NULL, NULL, msg_);
      $END
      RETURN TRUE;
   END Check_Access_For_Co;
   
BEGIN
   IF Check_Access_For_Co(order_no_) THEN
      RETURN Fnd_Boolean_API.DB_True;
   END IF;
   RETURN Fnd_Boolean_API.DB_False;
END Return_Material_Line_Chk;

-------------------- LU  NEW METHODS -------------------------------------
