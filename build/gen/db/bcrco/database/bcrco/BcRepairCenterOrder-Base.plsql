-----------------------------------------------------------------------------
--
--  Logical unit: BcRepairCenterOrder
--  Component:    BCRCO
--
--  Template:     3.0
--  Built by:     IFS Developer Studio (unit-test)
--
--  NOTE! Do not edit!! This file is completely generated and will be
--        overwritten next time the corresponding model is saved.
-----------------------------------------------------------------------------

layer Base;

-------------------- PUBLIC DECLARATIONS ------------------------------------

--TYPE Primary_Key_Rec IS RECORD
--  (rco_no                         BC_REPAIR_CENTER_ORDER_TAB.rco_no%TYPE);

TYPE Public_Rec IS RECORD
  (rco_no                         BC_REPAIR_CENTER_ORDER_TAB.rco_no%TYPE,
   "rowid"                        rowid,
   rowversion                     BC_REPAIR_CENTER_ORDER_TAB.rowversion%TYPE,
   rowkey                         BC_REPAIR_CENTER_ORDER_TAB.rowkey%TYPE,
   rowstate                       BC_REPAIR_CENTER_ORDER_TAB.rowstate%TYPE,
   customer_id                    BC_REPAIR_CENTER_ORDER_TAB.customer_id%TYPE,
   customer_order_no              BC_REPAIR_CENTER_ORDER_TAB.customer_order_no%TYPE,
   doc_address_id                 BC_REPAIR_CENTER_ORDER_TAB.doc_address_id%TYPE,
   delivery_address_id            BC_REPAIR_CENTER_ORDER_TAB.delivery_address_id%TYPE,
   contract                       BC_REPAIR_CENTER_ORDER_TAB.contract%TYPE,
   currency                       BC_REPAIR_CENTER_ORDER_TAB.currency%TYPE,
   date_created                   BC_REPAIR_CENTER_ORDER_TAB.date_created%TYPE,
   reported_by                    BC_REPAIR_CENTER_ORDER_TAB.reported_by%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (rco_no                         BOOLEAN := FALSE,
   customer_id                    BOOLEAN := FALSE,
   customer_order_no              BOOLEAN := FALSE,
   doc_address_id                 BOOLEAN := FALSE,
   delivery_address_id            BOOLEAN := FALSE,
   contract                       BOOLEAN := FALSE,
   currency                       BOOLEAN := FALSE,
   date_created                   BOOLEAN := FALSE,
   reported_by                    BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   rco_no_ IN NUMBER ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'RCO_NO', rco_no_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'RCO_NO', Fnd_Session_API.Get_Language) || ': ' || rco_no_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   rco_no_ IN NUMBER,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_),
                            Formatted_Key___(rco_no_));
   Error_SYS.Fnd_Too_Many_Rows(Bc_Repair_Center_Order_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   rco_no_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_),
                            Formatted_Key___(rco_no_));
   Error_SYS.Fnd_Record_Not_Exist(Bc_Repair_Center_Order_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.rco_no),
                            Formatted_Key___(rec_.rco_no));
   Error_SYS.Fnd_Record_Exist(Bc_Repair_Center_Order_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Bc_Repair_Center_Order_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Bc_Repair_Center_Order_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.rco_no),
                            Formatted_Key___(rec_.rco_no));
   Error_SYS.Fnd_Record_Modified(Bc_Repair_Center_Order_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   rco_no_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_),
                            Formatted_Key___(rco_no_));
   Error_SYS.Fnd_Record_Locked(Bc_Repair_Center_Order_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   rco_no_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_),
                            Formatted_Key___(rco_no_));
   Error_SYS.Fnd_Record_Removed(Bc_Repair_Center_Order_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN bc_repair_center_order_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_repair_center_order_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  bc_repair_center_order_tab
      WHERE rowid = objid_
      AND    to_char(rowversion,'YYYYMMDDHH24MISS') = objversion_
      FOR UPDATE NOWAIT;
   RETURN rec_;
EXCEPTION
   WHEN row_locked THEN
      Error_SYS.Fnd_Record_Locked(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Lock_By_Id___');
   WHEN no_data_found THEN
      BEGIN
         SELECT *
            INTO  rec_
            FROM  bc_repair_center_order_tab
            WHERE rowid = objid_;
         Raise_Record_Modified___(rec_);
      EXCEPTION
         WHEN no_data_found THEN
            Error_SYS.Fnd_Record_Removed(lu_name_);
         WHEN too_many_rows THEN
            Raise_Too_Many_Rows___(NULL, 'Lock_By_Id___');
      END;
END Lock_By_Id___;


-- Lock_By_Keys___
--    Locks a database row based on the primary key values.
--    Waits until record released if locked by another session.
FUNCTION Lock_By_Keys___ (
   rco_no_ IN NUMBER) RETURN bc_repair_center_order_tab%ROWTYPE
IS
   rec_        bc_repair_center_order_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_repair_center_order_tab
         WHERE rco_no = rco_no_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(rco_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(rco_no_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   rco_no_ IN NUMBER) RETURN bc_repair_center_order_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_repair_center_order_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_repair_center_order_tab
         WHERE rco_no = rco_no_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(rco_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(rco_no_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(rco_no_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN bc_repair_center_order_tab%ROWTYPE
IS
   lu_rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_repair_center_order_tab
      WHERE rowid = objid_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Fnd_Record_Removed(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Get_Object_By_Id___');
END Get_Object_By_Id___;


-- Get_Object_By_Keys___
--    Fetched a database row based on given the primary key values.
@UncheckedAccess
FUNCTION Get_Object_By_Keys___ (
   rco_no_ IN NUMBER ) RETURN bc_repair_center_order_tab%ROWTYPE
IS
   lu_rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   rco_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Check_Exist___');
END Check_Exist___;





-- Get_Version_By_Id___
--    Fetched the objversion for a database row based on the objid.
PROCEDURE Get_Version_By_Id___ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
BEGIN
   SELECT to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objversion_
      FROM  bc_repair_center_order_tab
      WHERE rowid = objid_;
EXCEPTION
   WHEN no_data_found THEN
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Get_Version_By_Id___');
END Get_Version_By_Id___;


-- Get_Version_By_Keys___
--    Fetched the objversion for a database row based on the primary key.
PROCEDURE Get_Id_Version_By_Keys___ (
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   rco_no_ IN NUMBER )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT bc_repair_center_order_tab%ROWTYPE,
   indrec_   IN OUT Indicator_Rec,
   attr_     IN OUT VARCHAR2 )
IS
   ptr_   NUMBER;
   name_  VARCHAR2(30);
   value_ VARCHAR2(32000);
   msg_   VARCHAR2(32000);
BEGIN
   Reset_Indicator_Rec___(indrec_);
   Client_SYS.Clear_Attr(msg_);
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      CASE name_
      WHEN ('RCO_NO') THEN
         newrec_.rco_no := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.rco_no := TRUE;
      WHEN ('CUSTOMER_ID') THEN
         newrec_.customer_id := value_;
         indrec_.customer_id := TRUE;
      WHEN ('CUSTOMER_ORDER_NO') THEN
         newrec_.customer_order_no := value_;
         indrec_.customer_order_no := TRUE;
      WHEN ('DOC_ADDRESS_ID') THEN
         newrec_.doc_address_id := value_;
         indrec_.doc_address_id := TRUE;
      WHEN ('DELIVERY_ADDRESS_ID') THEN
         newrec_.delivery_address_id := value_;
         indrec_.delivery_address_id := TRUE;
      WHEN ('CONTRACT') THEN
         newrec_.contract := value_;
         indrec_.contract := TRUE;
      WHEN ('CURRENCY') THEN
         newrec_.currency := value_;
         indrec_.currency := TRUE;
      WHEN ('DATE_CREATED') THEN
         newrec_.date_created := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.date_created := TRUE;
      WHEN ('REPORTED_BY') THEN
         newrec_.reported_by := value_;
         indrec_.reported_by := TRUE;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
   attr_ := msg_;
EXCEPTION
   WHEN value_error THEN
      Raise_Item_Format___(name_, value_);
END Unpack___;


-- Pack___
--   Reads a record and packs its contents into an attribute string.
--   This is intended to be the reverse of Unpack___
FUNCTION Pack___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.rco_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   END IF;
   IF (rec_.customer_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_ID', rec_.customer_id, attr_);
   END IF;
   IF (rec_.customer_order_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_ORDER_NO', rec_.customer_order_no, attr_);
   END IF;
   IF (rec_.doc_address_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DOC_ADDRESS_ID', rec_.doc_address_id, attr_);
   END IF;
   IF (rec_.delivery_address_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DELIVERY_ADDRESS_ID', rec_.delivery_address_id, attr_);
   END IF;
   IF (rec_.contract IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (rec_.currency IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CURRENCY', rec_.currency, attr_);
   END IF;
   IF (rec_.date_created IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DATE_CREATED', rec_.date_created, attr_);
   END IF;
   IF (rec_.reported_by IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPORTED_BY', rec_.reported_by, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.rco_no) THEN
      Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   END IF;
   IF (indrec_.customer_id) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_ID', rec_.customer_id, attr_);
   END IF;
   IF (indrec_.customer_order_no) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_ORDER_NO', rec_.customer_order_no, attr_);
   END IF;
   IF (indrec_.doc_address_id) THEN
      Client_SYS.Add_To_Attr('DOC_ADDRESS_ID', rec_.doc_address_id, attr_);
   END IF;
   IF (indrec_.delivery_address_id) THEN
      Client_SYS.Add_To_Attr('DELIVERY_ADDRESS_ID', rec_.delivery_address_id, attr_);
   END IF;
   IF (indrec_.contract) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (indrec_.currency) THEN
      Client_SYS.Add_To_Attr('CURRENCY', rec_.currency, attr_);
   END IF;
   IF (indrec_.date_created) THEN
      Client_SYS.Add_To_Attr('DATE_CREATED', rec_.date_created, attr_);
   END IF;
   IF (indrec_.reported_by) THEN
      Client_SYS.Add_To_Attr('REPORTED_BY', rec_.reported_by, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_ID', rec_.customer_id, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_ORDER_NO', rec_.customer_order_no, attr_);
   Client_SYS.Add_To_Attr('DOC_ADDRESS_ID', rec_.doc_address_id, attr_);
   Client_SYS.Add_To_Attr('DELIVERY_ADDRESS_ID', rec_.delivery_address_id, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   Client_SYS.Add_To_Attr('CURRENCY', rec_.currency, attr_);
   Client_SYS.Add_To_Attr('DATE_CREATED', rec_.date_created, attr_);
   Client_SYS.Add_To_Attr('REPORTED_BY', rec_.reported_by, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   Client_SYS.Add_To_Attr('ROWSTATE', rec_.rowstate, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN bc_repair_center_order_tab%ROWTYPE
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.rowstate                       := public_.rowstate;
   rec_.rco_no                         := public_.rco_no;
   rec_.customer_id                    := public_.customer_id;
   rec_.customer_order_no              := public_.customer_order_no;
   rec_.doc_address_id                 := public_.doc_address_id;
   rec_.delivery_address_id            := public_.delivery_address_id;
   rec_.contract                       := public_.contract;
   rec_.currency                       := public_.currency;
   rec_.date_created                   := public_.date_created;
   rec_.reported_by                    := public_.reported_by;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.rowstate                       := rec_.rowstate;
   public_.rco_no                         := rec_.rco_no;
   public_.customer_id                    := rec_.customer_id;
   public_.customer_order_no              := rec_.customer_order_no;
   public_.doc_address_id                 := rec_.doc_address_id;
   public_.delivery_address_id            := rec_.delivery_address_id;
   public_.contract                       := rec_.contract;
   public_.currency                       := rec_.currency;
   public_.date_created                   := rec_.date_created;
   public_.reported_by                    := rec_.reported_by;
   RETURN public_;
END Table_To_Public___;


-- Reset_Indicator_Rec___
--   Resets all elements of given Indicator_Rec to FALSE.
PROCEDURE Reset_Indicator_Rec___ (
   indrec_ IN OUT Indicator_Rec )
IS
   empty_indrec_ Indicator_Rec;
BEGIN
   indrec_ := empty_indrec_;
END Reset_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the content of a table record.
FUNCTION Get_Indicator_Rec___ (
   rec_ IN bc_repair_center_order_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.rco_no := rec_.rco_no IS NOT NULL;
   indrec_.customer_id := rec_.customer_id IS NOT NULL;
   indrec_.customer_order_no := rec_.customer_order_no IS NOT NULL;
   indrec_.doc_address_id := rec_.doc_address_id IS NOT NULL;
   indrec_.delivery_address_id := rec_.delivery_address_id IS NOT NULL;
   indrec_.contract := rec_.contract IS NOT NULL;
   indrec_.currency := rec_.currency IS NOT NULL;
   indrec_.date_created := rec_.date_created IS NOT NULL;
   indrec_.reported_by := rec_.reported_by IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN bc_repair_center_order_tab%ROWTYPE,
   newrec_ IN bc_repair_center_order_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.rco_no := Validate_SYS.Is_Changed(oldrec_.rco_no, newrec_.rco_no);
   indrec_.customer_id := Validate_SYS.Is_Changed(oldrec_.customer_id, newrec_.customer_id);
   indrec_.customer_order_no := Validate_SYS.Is_Changed(oldrec_.customer_order_no, newrec_.customer_order_no);
   indrec_.doc_address_id := Validate_SYS.Is_Changed(oldrec_.doc_address_id, newrec_.doc_address_id);
   indrec_.delivery_address_id := Validate_SYS.Is_Changed(oldrec_.delivery_address_id, newrec_.delivery_address_id);
   indrec_.contract := Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract);
   indrec_.currency := Validate_SYS.Is_Changed(oldrec_.currency, newrec_.currency);
   indrec_.date_created := Validate_SYS.Is_Changed(oldrec_.date_created, newrec_.date_created);
   indrec_.reported_by := Validate_SYS.Is_Changed(oldrec_.reported_by, newrec_.reported_by);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     bc_repair_center_order_tab%ROWTYPE,
   newrec_ IN OUT bc_repair_center_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.customer_id IS NOT NULL)
   AND (indrec_.customer_id)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_id, newrec_.customer_id)) THEN
      Customer_Info_API.Exist(newrec_.customer_id);
   END IF;
   IF (newrec_.customer_id IS NOT NULL AND newrec_.doc_address_id IS NOT NULL)
   AND (indrec_.customer_id OR indrec_.doc_address_id)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_id, newrec_.customer_id)
     OR Validate_SYS.Is_Changed(oldrec_.doc_address_id, newrec_.doc_address_id)) THEN
      Customer_Info_Address_API.Exist(newrec_.customer_id, newrec_.doc_address_id);
   END IF;
   IF (newrec_.customer_id IS NOT NULL AND newrec_.delivery_address_id IS NOT NULL)
   AND (indrec_.customer_id OR indrec_.delivery_address_id)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_id, newrec_.customer_id)
     OR Validate_SYS.Is_Changed(oldrec_.delivery_address_id, newrec_.delivery_address_id)) THEN
      Customer_Info_Address_API.Exist(newrec_.customer_id, newrec_.delivery_address_id);
   END IF;
   IF (newrec_.currency IS NOT NULL)
   AND (indrec_.currency)
   AND (Validate_SYS.Is_Changed(oldrec_.currency, newrec_.currency)) THEN
      Iso_Currency_API.Exist(newrec_.currency);
   END IF;
   IF (newrec_.contract IS NOT NULL)
   AND (indrec_.contract)
   AND (Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract)) THEN
      Site_API.Exist(newrec_.contract);
   END IF;
   IF (newrec_.customer_order_no IS NOT NULL)
   AND (indrec_.customer_order_no)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_order_no, newrec_.customer_order_no)) THEN
      Customer_Order_API.Exist(newrec_.customer_order_no);
   END IF;
   IF (newrec_.reported_by IS NOT NULL)
   AND (indrec_.reported_by)
   AND (Validate_SYS.Is_Changed(oldrec_.reported_by, newrec_.reported_by)) THEN
      Fnd_User_API.Exist(newrec_.reported_by);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_ID', newrec_.customer_id);
   Error_SYS.Check_Not_Null(lu_name_, 'DOC_ADDRESS_ID', newrec_.doc_address_id);
   Error_SYS.Check_Not_Null(lu_name_, 'DELIVERY_ADDRESS_ID', newrec_.delivery_address_id);
   Error_SYS.Check_Not_Null(lu_name_, 'CONTRACT', newrec_.contract);
   Error_SYS.Check_Not_Null(lu_name_, 'CURRENCY', newrec_.currency);
   Error_SYS.Check_Not_Null(lu_name_, 'DATE_CREATED', newrec_.date_created);
   Error_SYS.Check_Not_Null(lu_name_, 'REPORTED_BY', newrec_.reported_by);
END Check_Common___;


-- Prepare_Insert___
--   Set client default values into an attribute string.
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Client_SYS.Clear_Attr(attr_);
END Prepare_Insert___;


-- Check_Insert___
--   Perform validations on a new record before it is insert.
PROCEDURE Check_Insert___ (
   newrec_ IN OUT bc_repair_center_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT bc_repair_center_order_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   newrec_.rowstate := '<UNDEFINED>';
   INSERT
      INTO bc_repair_center_order_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   newrec_.rowstate := NULL;
   Finite_State_Init___(newrec_, attr_);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'BC_REPAIR_CENTER_ORDER_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_REPAIR_CENTER_ORDER_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
   WHEN value_too_large THEN
      Error_SYS.Fnd_Item_Length(lu_name_, sqlerrm);
END Insert___;


-- Prepare_New___
--    Set default values for a table record.
PROCEDURE Prepare_New___ (
   newrec_ IN OUT bc_repair_center_order_tab%ROWTYPE )
IS
   attr_    VARCHAR2(32000);
   indrec_  Indicator_Rec;
BEGIN
   attr_ := Pack___(newrec_);
   Prepare_Insert___(attr_);
   Unpack___(newrec_, indrec_, attr_);
END Prepare_New___;


-- New___
--    Checks and creates a new record.
PROCEDURE New___ (
   newrec_ IN OUT bc_repair_center_order_tab%ROWTYPE )
IS
   objid_         VARCHAR2(20);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
BEGIN
   indrec_ := Get_Indicator_Rec___(newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Insert___(objid_, objversion_, newrec_, attr_);
END New___;


-- Check_Update___
--   Perform validations on a new record before it is updated.
PROCEDURE Check_Update___ (
   oldrec_ IN     bc_repair_center_order_tab%ROWTYPE,
   newrec_ IN OUT bc_repair_center_order_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'RCO_NO', indrec_.rco_no);
   Validate_SYS.Item_Update(lu_name_, 'DATE_CREATED', indrec_.date_created);
   Validate_SYS.Item_Update(lu_name_, 'REPORTED_BY', indrec_.reported_by);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     bc_repair_center_order_tab%ROWTYPE,
   newrec_     IN OUT bc_repair_center_order_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE bc_repair_center_order_tab
         SET ROW = newrec_
         WHERE rco_no = newrec_.rco_no;
   ELSE
      UPDATE bc_repair_center_order_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'BC_REPAIR_CENTER_ORDER_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Bc_Repair_Center_Order_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_REPAIR_CENTER_ORDER_PK') THEN
            Raise_Record_Exist___(newrec_);
         ELSE
            Raise_Constraint_Violated___(newrec_, constraint_);
         END IF;
      END;
   WHEN value_too_large THEN
      Error_SYS.Fnd_Item_Length(lu_name_, sqlerrm);
END Update___;


-- Modify___
--    Modifies an existing instance of the logical unit.
PROCEDURE Modify___ (
   newrec_         IN OUT bc_repair_center_order_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.rco_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.rco_no);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN bc_repair_center_order_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.rco_no||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN bc_repair_center_order_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.rco_no||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  bc_repair_center_order_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  bc_repair_center_order_tab
         WHERE rco_no = remrec_.rco_no;
   END IF;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN bc_repair_center_order_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT bc_repair_center_order_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.rco_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.rco_no);
   END IF;
   Check_Delete___(oldrec_);
   Delete___(NULL, oldrec_);
END Remove___;


-- Lock__
--    Client-support to lock a specific instance of the logical unit.
@UncheckedAccess
PROCEDURE Lock__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2 )
IS
   dummy_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   dummy_ := Lock_By_Id___(objid_, objversion_);
   info_ := Client_SYS.Get_All_Info;
END Lock__;


-- New__
--    Client-support interface to create LU instances.
--       action_ = 'PREPARE'
--          Default values and handle of information to client.
--          The default values are set in procedure Prepare_Insert___.
--       action_ = 'CHECK'
--          Check all attributes before creating new object and handle of
--          information to client. The attribute list is unpacked, checked
--          and prepared (defaults) in procedures Unpack___ and Check_Insert___.
--       action_ = 'DO'
--          Creation of new instances of the logical unit and handle of
--          information to client. The attribute list is unpacked, checked
--          and prepared (defaults) in procedures Unpack___ and Check_Insert___
--          before calling procedure Insert___.
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_   bc_repair_center_order_tab%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN
   IF (action_ = 'PREPARE') THEN
      Prepare_Insert___(attr_);
   ELSIF (action_ = 'CHECK') THEN
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
   ELSIF (action_ = 'DO') THEN
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END New__;


-- Modify__
--    Client-support interface to modify attributes for LU instances.
--       action_ = 'CHECK'
--          Check all attributes before modifying an existing object and
--          handle of information to client. The attribute list is unpacked,
--          checked and prepared(defaults) in procedures Unpack___ and Check_Update___.
--       action_ = 'DO'
--          Modification of an existing instance of the logical unit. The
--          procedure unpacks the attributes, checks all values before
--          procedure Update___ is called.
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_   bc_repair_center_order_tab%ROWTYPE;
   newrec_   bc_repair_center_order_tab%ROWTYPE;
   indrec_   Indicator_Rec;
BEGIN
   IF (action_ = 'CHECK') THEN
      oldrec_ := Get_Object_By_Id___(objid_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
   ELSIF (action_ = 'DO') THEN
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Modify__;


-- Remove__
--    Client-support interface to remove LU instances.
--       action_ = 'CHECK'
--          Check whether a specific LU-instance may be removed or not.
--          The procedure fetches the complete record by calling procedure
--          Get_Object_By_Id___. Then the check is made by calling procedure
--          Check_Delete___.
--       action_ = 'DO'
--          Remove an existing instance of the logical unit. The procedure
--          fetches the complete LU-record, checks for a delete and then
--          deletes the record by calling procedure Delete___.
PROCEDURE Remove__ (
   info_       OUT VARCHAR2,
   objid_      IN  VARCHAR2,
   objversion_ IN  VARCHAR2,
   action_     IN  VARCHAR2 )
IS
   remrec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Check_Delete___(remrec_);
   ELSIF (action_ = 'DO') THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;


-- Get_Key_By_Rowkey
--   Returns a table record with only keys (other attributes are NULL) based on a rowkey.
@UncheckedAccess
FUNCTION Get_Key_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN bc_repair_center_order_tab%ROWTYPE
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rco_no
      INTO  rec_.rco_no
      FROM  bc_repair_center_order_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.rco_no, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   rco_no_ IN NUMBER )
IS
BEGIN
   IF (NOT Check_Exist___(rco_no_)) THEN
      Raise_Record_Not_Exist___(rco_no_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   rco_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(rco_no_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   rco_no_ bc_repair_center_order_tab.rco_no%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT rco_no
   INTO  rco_no_
   FROM  bc_repair_center_order_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(rco_no_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Customer_Id
--   Fetches the CustomerId attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_Id (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.customer_id%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_id
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Customer_Id');
END Get_Customer_Id;


-- Get_Customer_Order_No
--   Fetches the CustomerOrderNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_Order_No (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.customer_order_no%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_order_no
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Customer_Order_No');
END Get_Customer_Order_No;


-- Get_Doc_Address_Id
--   Fetches the DocAddressId attribute for a record.
@UncheckedAccess
FUNCTION Get_Doc_Address_Id (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.doc_address_id%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT doc_address_id
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Doc_Address_Id');
END Get_Doc_Address_Id;


-- Get_Delivery_Address_Id
--   Fetches the DeliveryAddressId attribute for a record.
@UncheckedAccess
FUNCTION Get_Delivery_Address_Id (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.delivery_address_id%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT delivery_address_id
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Delivery_Address_Id');
END Get_Delivery_Address_Id;


-- Get_Contract
--   Fetches the Contract attribute for a record.
@UncheckedAccess
FUNCTION Get_Contract (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.contract%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Contract');
END Get_Contract;


-- Get_Currency
--   Fetches the Currency attribute for a record.
@UncheckedAccess
FUNCTION Get_Currency (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.currency%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT currency
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Currency');
END Get_Currency;


-- Get_Date_Created
--   Fetches the DateCreated attribute for a record.
@UncheckedAccess
FUNCTION Get_Date_Created (
   rco_no_ IN NUMBER ) RETURN DATE
IS
   temp_ bc_repair_center_order_tab.date_created%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT date_created
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Date_Created');
END Get_Date_Created;


-- Get_Reported_By
--   Fetches the ReportedBy attribute for a record.
@UncheckedAccess
FUNCTION Get_Reported_By (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.reported_by%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT reported_by
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Reported_By');
END Get_Reported_By;


-- Get_State
--   Fetches the State attribute for a record.
@UncheckedAccess
FUNCTION Get_State (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Decode__(Get_Objstate(rco_no_));
END Get_State;


-- Get_Objstate
--   Fetches the Objstate attribute for a record.
@UncheckedAccess
FUNCTION Get_Objstate (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_center_order_tab.rowstate%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowstate
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Objstate');
END Get_Objstate;


-- Get_Objevents
--   Fetches the Objevents attribute for a record.
@UncheckedAccess
FUNCTION Get_Objevents (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Events__(Get_Objstate(rco_no_));
END Get_Objevents;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.rco_no);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   rco_no_ IN NUMBER ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rco_no, rowid, rowversion, rowkey, rowstate,
          customer_id, 
          customer_order_no, 
          doc_address_id, 
          delivery_address_id, 
          contract, 
          currency, 
          date_created, 
          reported_by
      INTO  temp_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   rco_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rowkey_ bc_repair_center_order_tab.rowkey%TYPE;
BEGIN
   IF (rco_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  bc_repair_center_order_tab
      WHERE rco_no = rco_no_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, 'Get_Objkey');
END Get_Objkey;

-------------------- FINITE STATE MACHINE -----------------------------------

-- Get_Db_Values___
--   Returns the the list of DB (stored in database) values.
FUNCTION Get_Db_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Planned^Cancelled^Released^Started^Completed^Closed^');
END Get_Db_Values___;


-- Get_Client_Values___
--   Returns the the list of client (in PROG language) values.
FUNCTION Get_Client_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('Planned^Cancelled^Released^Started^Completed^Closed^');
END Get_Client_Values___;


-- Cancel_Lines___
--    Execute the CancelLines action within the finite state machine.
PROCEDURE Cancel_Lines___ (
   rec_  IN OUT bc_repair_center_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Check_Lines_Can_Or_Shi___
--    Evaluates the CheckLinesCanOrShi condition within the finite state machine.
FUNCTION Check_Lines_Can_Or_Shi___ (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Check_Repair_Line_Count___
--    Evaluates the CheckRepairLineCount condition within the finite state machine.
FUNCTION Check_Repair_Line_Count___ (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Enable_Create_Order___
--    Evaluates the EnableCreateOrder condition within the finite state machine.
FUNCTION Enable_Create_Order___ (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE ) RETURN BOOLEAN;


-- Finite_State_Set___
--    Updates the state column in the database for given record.
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT bc_repair_center_order_tab%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   rec_.rowversion := sysdate;
   UPDATE bc_repair_center_order_tab
      SET rowstate = state_,
          rowversion = rec_.rowversion
      WHERE rco_no = rec_.rco_no;
   rec_.rowstate := state_;
END Finite_State_Set___;


-- Finite_State_Machine___
--    Execute the state machine logic given a specific event.
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT bc_repair_center_order_tab%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
   state_ bc_repair_center_order_tab.rowstate%TYPE;
BEGIN
   state_ := rec_.rowstate;
   IF (state_ IS NULL) THEN
      IF (event_ IS NULL) THEN
         Finite_State_Set___(rec_, 'Planned');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Cancelled') THEN
      Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
   ELSIF (state_ = 'Closed') THEN
      IF (event_ = 'Reopen') THEN
         Finite_State_Set___(rec_, 'Planned');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Completed') THEN
      IF (event_ = 'Close') THEN
         IF (Check_Lines_Can_Or_Shi___(rec_)) THEN
            Finite_State_Set___(rec_, 'Closed');
         END IF;
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Planned') THEN
      IF (event_ = 'Cancel') THEN
         Cancel_Lines___(rec_, attr_);
         Finite_State_Set___(rec_, 'Cancelled');
      ELSIF (event_ = 'Release') THEN
         IF (Check_Repair_Line_Count___(rec_)) THEN
            Finite_State_Set___(rec_, 'Released');
         END IF;
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Released') THEN
      IF (event_ = 'Cancel') THEN
         Finite_State_Set___(rec_, 'Cancelled');
      ELSIF (event_ = 'Start') THEN
         Finite_State_Set___(rec_, 'Started');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Started') THEN
      IF (event_ = 'Complete') THEN
         IF (Enable_Create_Order___(rec_)) THEN
            Finite_State_Set___(rec_, 'Completed');
         END IF;
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSE
      Error_SYS.State_Not_Exist(lu_name_, Finite_State_Decode__(state_));
   END IF;
END Finite_State_Machine___;


-- Finite_State_Add_To_Attr___
--    Add current state and lists of allowed events to an attribute string.
PROCEDURE Finite_State_Add_To_Attr___ (
   rec_  IN     bc_repair_center_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   state_ bc_repair_center_order_tab.rowstate%TYPE;
BEGIN
   state_ := rec_.rowstate;
   Client_SYS.Add_To_Attr('__OBJSTATE', state_, attr_);
   Client_SYS.Add_To_Attr('__OBJEVENTS', Finite_State_Events__(state_), attr_);
   Client_SYS.Add_To_Attr('STATE', Finite_State_Decode__(state_), attr_);
END Finite_State_Add_To_Attr___;


-- Finite_State_Init___
--    Runs the initial start event for the state machine.
PROCEDURE Finite_State_Init___ (
   rec_  IN OUT bc_repair_center_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Finite_State_Machine___(rec_, NULL, attr_);
   Finite_State_Add_To_Attr___(rec_, attr_);
END Finite_State_Init___;


-- Finite_State_Init_
--    Runs the initial start event for a basedOn child entity.
@ServerOnlyAccess
PROCEDURE Finite_State_Init_ (
   rec_  IN OUT bc_repair_center_order_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   Finite_State_Init___(rec_, attr_);
END Finite_State_Init_;


-- Finite_State_Decode__
--   Returns the client equivalent for any database representation of
--   a state name = objstate.
@UncheckedAccess
FUNCTION Finite_State_Decode__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Domain_SYS.Decode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, db_state_));
END Finite_State_Decode__;


-- Finite_State_Encode__
--   Returns the database equivalent for any client representation of
--   a state name = state.
@UncheckedAccess
FUNCTION Finite_State_Encode__ (
   client_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Domain_SYS.Encode_(Domain_SYS.Get_Translated_Values(lu_name_), Get_Db_Values___, client_state_));
END Finite_State_Encode__;


-- Enumerate_States__
--   Returns a list of all possible finite states in client terminology.
@UncheckedAccess
PROCEDURE Enumerate_States__ (
   client_values_ OUT VARCHAR2 )
IS
BEGIN
   client_values_ := Domain_SYS.Enumerate_(Domain_SYS.Get_Translated_Values(lu_name_));
END Enumerate_States__;


-- Enumerate_States_Db__
--   Returns a list of all possible finite states in database terminology.
@UncheckedAccess
PROCEDURE Enumerate_States_Db__ (
   db_values_ OUT VARCHAR2 )
IS
BEGIN
   db_values_ := Domain_SYS.Enumerate_(Get_Db_Values___);
END Enumerate_States_Db__;


-- Finite_State_Events__
--   Returns a list of allowed events for a given state
--   NOTE! Regardless of conditions if not otherwize encoded
@UncheckedAccess
FUNCTION Finite_State_Events__ (
   db_state_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (db_state_ IS NULL) THEN
      RETURN NULL;
   ELSIF (db_state_ = 'Cancelled') THEN
      RETURN NULL;
   ELSIF (db_state_ = 'Closed') THEN
      RETURN 'Reopen^';
   ELSIF (db_state_ = 'Completed') THEN
      RETURN 'Close^';
   ELSIF (db_state_ = 'Planned') THEN
      RETURN 'Cancel^Release^';
   ELSIF (db_state_ = 'Released') THEN
      RETURN 'Cancel^Start^';
   ELSIF (db_state_ = 'Started') THEN
      RETURN 'Complete^';
   ELSE
      RETURN NULL;
   END IF;
END Finite_State_Events__;


-- Enumerate_Events__
--   Returns a list of all possible events.
@UncheckedAccess
PROCEDURE Enumerate_Events__ (
   db_events_ OUT VARCHAR2 )
IS
BEGIN
   db_events_ := 'Cancel^Close^Complete^Release^Reopen^Start^';
END Enumerate_Events__;


-- Cancel__
--   Executes the Cancel event logic as defined in the state machine.
PROCEDURE Cancel__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Cancel', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Cancel__;


-- Close__
--   Executes the Close event logic as defined in the state machine.
PROCEDURE Close__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Close', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Close__;


-- Complete__
--   Executes the Complete event logic as defined in the state machine.
PROCEDURE Complete__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Complete', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Complete__;


-- Release__
--   Executes the Release event logic as defined in the state machine.
PROCEDURE Release__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Release', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Release__;


-- Reopen__
--   Executes the Reopen event logic as defined in the state machine.
PROCEDURE Reopen__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Reopen', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Reopen__;


-- Start__
--   Executes the Start event logic as defined in the state machine.
PROCEDURE Start__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_center_order_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Start', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Start__;



-------------------- COMPLEX STRUCTURE METHODS ------------------------------------

-------------------- FOUNDATION1 METHODS ------------------------------------


-- Language_Refreshed
--   Framework method that updates translations to a new language.
@UncheckedAccess
PROCEDURE Language_Refreshed
IS
BEGIN
   Domain_SYS.Language_Refreshed(lu_name_, Get_Client_Values___, Get_Db_Values___, 'STATE');
END Language_Refreshed;


-- Init
--   Framework method that initializes this package.
@UncheckedAccess
PROCEDURE Init
IS
BEGIN
   Domain_SYS.Load_State(lu_name_, Get_Client_Values___, Get_Db_Values___);
END Init;