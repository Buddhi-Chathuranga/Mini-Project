-----------------------------------------------------------------------------
--
--  Logical unit: B2bSupplierUser
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170130  ANDJSE  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

true_  CONSTANT VARCHAR2(20) := Fnd_Boolean_API.DB_TRUE;
false_ CONSTANT VARCHAR2(20) := Fnd_Boolean_API.DB_FALSE;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Supplier___(
   supplier_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Supplier_Info_API.Is_B2b_Supplier(supplier_id_)) THEN
      Error_SYS.Record_General(lu_name_, 'NOB2BSUPP: The supplier :P1 is not defined as a B2B supplier.', supplier_id_);
   END IF;
END Check_Supplier___;


FUNCTION Count_Suppliers___ (
   user_id_ IN VARCHAR2 ) RETURN INTEGER
IS
   count_ INTEGER;
   CURSOR count_recs(user_ IN VARCHAR2) IS
      SELECT COUNT(*)
      FROM   b2b_supplier_user_tab
      WHERE  user_id = user_;   
BEGIN
   OPEN count_recs(user_id_);
   FETCH count_recs INTO count_;
   CLOSE count_recs;
   RETURN count_;
END Count_Suppliers___;


FUNCTION Has_Default___ (
   user_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR check_default(user_ IN VARCHAR2) IS
      SELECT 1
      FROM   b2b_supplier_user_tab
      WHERE  user_id          = user_
      AND    default_supplier = true_;
   dummy_ INTEGER;
   found_ BOOLEAN := FALSE;
BEGIN
   OPEN check_default(user_id_);
   FETCH check_default INTO dummy_;
   found_ := check_default%FOUND;
   CLOSE check_default;
   RETURN found_;
END Has_Default___;


FUNCTION Is_Default___ (
   supplier_id_ IN VARCHAR2,
   user_id_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR check_default(supplier_ IN VARCHAR2, user_ IN VARCHAR2) IS
      SELECT 1
      FROM   b2b_supplier_user_tab
      WHERE  supplier_id      = supplier_
      AND    user_id          = user_
      AND    default_supplier = true_;
   dummy_ INTEGER;
   found_ BOOLEAN := FALSE;
BEGIN
   OPEN check_default(supplier_id_, user_id_);
   FETCH check_default INTO dummy_;
   found_ := check_default%FOUND;
   CLOSE check_default;
   RETURN found_;
END Is_Default___;


PROCEDURE Handle_Default___ (
   newrec_ IN b2b_supplier_user_tab%ROWTYPE )
IS 
   has_default_ BOOLEAN := Has_Default___(newrec_.user_id);
   is_default_  BOOLEAN := Is_Default___(newrec_.supplier_id, newrec_.user_id);
BEGIN
   IF (newrec_.default_supplier = true_ AND has_default_) THEN
      UPDATE b2b_supplier_user_tab
         SET   default_supplier = false_,
               rowversion       = rowversion + 1
         WHERE user_id          = newrec_.user_id
      AND      default_supplier = true_
      AND      supplier_id <> newrec_.supplier_id;
   ELSIF (newrec_.default_supplier = false_ AND is_default_) THEN
      Error_SYS.Record_General(lu_name_, 'SUDEFREQIU: User :P1 must have a default supplier.', newrec_.user_id);
   END IF;
END Handle_Default___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN b2b_supplier_user_tab%ROWTYPE )
IS
   count_ INTEGER := Count_Suppliers___(remrec_.user_id);
BEGIN
   super(remrec_);
   IF (remrec_.default_supplier = true_ AND count_ > 1) THEN
      Error_SYS.Record_General(lu_name_, 'SUDEFREQD: You cannot remove the default supplier :P1 for user :P2. Specify a new default before deleting this record.', remrec_.supplier_id, remrec_.user_id);
   ELSIF (remrec_.default_supplier = true_ AND count_ = 1) THEN
      Client_SYS.Add_Warning(lu_name_,'SULASTDEFREC: Supplier :P1 is the default supplier for user :P2.', remrec_.supplier_id, remrec_.user_id);
   END IF;                                                                                                       
END Check_Delete___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT b2b_supplier_user_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   count_ INTEGER := Count_Suppliers___(newrec_.user_id);
BEGIN
   Check_Supplier___(newrec_.supplier_id);
   IF (count_ = 0) THEN
      newrec_.default_supplier := true_;
      Client_SYS.Set_Item_Value('DEFAULT_SUPPLIER_DB', true_, attr_);
   END IF;
   Handle_Default___(newrec_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DEFAULT_SUPPLIER_DB', false_, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     b2b_supplier_user_tab%ROWTYPE,
   newrec_     IN OUT b2b_supplier_user_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Handle_Default___(newrec_);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Set_Default__ (
   supplier_id_ IN VARCHAR2,
   user_id_     IN VARCHAR2 )
IS
   dummy_  VARCHAR2(2000);
   newrec_ b2b_supplier_user_tab%ROWTYPE;
   oldrec_ b2b_supplier_user_tab%ROWTYPE;
BEGIN
   oldrec_ := Get_Object_By_Keys___(supplier_id_, user_id_);
   newrec_ := oldrec_;
   newrec_.default_supplier := true_;
   Update___(NULL, oldrec_, newrec_, dummy_, dummy_, TRUE);
END Set_Default__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

