-----------------------------------------------------------------------------
--
--  Logical unit: B2bUserUtil
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170130  ANDJSE  Created
--  170309  ILSOLK  Added new methods Get_Default_Customer,Get_Default_Supplier, Changed existing methods
--                  Get_User_Default_Customer,Get_User_Default_Supplier.
--  171002  NIEDLK  Added Get_B2b_Cust_Connected_Users to get the list of users connected to a B2B customer.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

separator_ CONSTANT VARCHAR2(1) := ';';
true_      CONSTANT VARCHAR2(20) := Fnd_Boolean_API.DB_TRUE;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_User_Default_Customer RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Default_Customer(Fnd_Session_API.Get_Fnd_User);
END Get_User_Default_Customer;


@UncheckedAccess
FUNCTION Get_User_Default_Supplier RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Default_Supplier(Fnd_Session_API.Get_Fnd_User);
END Get_User_Default_Supplier;


FUNCTION Customer_Users_Exists (
   customer_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ BOOLEAN := FALSE;
   dummy_ INTEGER;
   CURSOR users_exists(id_ IN VARCHAR2) IS
      SELECT 1
      FROM b2b_customer_user_tab
      WHERE customer_id = id_;
BEGIN
   OPEN users_exists(customer_id_);
   FETCH users_exists INTO dummy_;
   found_ := users_exists%FOUND;
   CLOSE users_exists;
   RETURN found_;
END Customer_Users_Exists;


FUNCTION Supplier_Users_Exists (
   supplier_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   found_ BOOLEAN := FALSE;
   dummy_ INTEGER;
   CURSOR users_exists(id_ IN VARCHAR2) IS
      SELECT 1
      FROM b2b_supplier_user_tab
      WHERE supplier_id = id_;
BEGIN
   OPEN users_exists(supplier_id_);
   FETCH users_exists INTO dummy_;
   found_ := users_exists%FOUND;
   CLOSE users_exists;
   RETURN found_;
END Supplier_Users_Exists;


@UncheckedAccess
FUNCTION Get_Default_Customer (
   user_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   customer_id_ b2b_customer_user.customer_id%TYPE;
   CURSOR default_customer IS
      SELECT customer_id
      FROM   b2b_customer_user
      WHERE  user_id = user_id_
      AND    default_customer_db = true_;
BEGIN
   OPEN default_customer;
   FETCH default_customer INTO customer_id_;
   CLOSE default_customer;
   RETURN customer_id_;
END Get_Default_Customer;


@UncheckedAccess
FUNCTION Get_Default_Supplier (
   user_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   supplier_id_ b2b_supplier_user.supplier_id%TYPE;
   CURSOR default_supplier IS
      SELECT supplier_id
      FROM   b2b_supplier_user
      WHERE  user_id = user_id_
      AND    default_supplier_db = true_;
BEGIN
   OPEN default_supplier;
   FETCH default_supplier INTO supplier_id_;
   CLOSE default_supplier;
   RETURN supplier_id_;
END Get_Default_Supplier;


@UncheckedAccess
FUNCTION Get_B2b_Cust_Connected_Users (
   customer_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   user_list_ VARCHAR2(4000) := NULL;
   CURSOR get_b2b_customer_connected_users IS
      SELECT user_id
      FROM   b2b_customer_user
      WHERE  customer_id = customer_id_;
BEGIN
   FOR user_ IN get_b2b_customer_connected_users LOOP
      user_list_ := user_list_ || user_.user_id || Client_SYS.field_separator_;
   END LOOP;
   RETURN user_list_;
END Get_B2b_Cust_Connected_Users;

