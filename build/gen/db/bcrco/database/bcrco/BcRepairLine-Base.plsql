-----------------------------------------------------------------------------
--
--  Logical unit: BcRepairLine
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
--  (rco_no                         BC_REPAIR_LINE_TAB.rco_no%TYPE,
--   repair_line_no                 BC_REPAIR_LINE_TAB.repair_line_no%TYPE);

TYPE Public_Rec IS RECORD
  (rco_no                         BC_REPAIR_LINE_TAB.rco_no%TYPE,
   repair_line_no                 BC_REPAIR_LINE_TAB.repair_line_no%TYPE,
   "rowid"                        rowid,
   rowversion                     BC_REPAIR_LINE_TAB.rowversion%TYPE,
   rowkey                         BC_REPAIR_LINE_TAB.rowkey%TYPE,
   rowstate                       BC_REPAIR_LINE_TAB.rowstate%TYPE,
   date_entered                   BC_REPAIR_LINE_TAB.date_entered%TYPE,
   repair_site                    BC_REPAIR_LINE_TAB.repair_site%TYPE,
   part_number                    BC_REPAIR_LINE_TAB.part_number%TYPE,
   quantity                       BC_REPAIR_LINE_TAB.quantity%TYPE,
   quantity_received              BC_REPAIR_LINE_TAB.quantity_received%TYPE,
   condition_code                 BC_REPAIR_LINE_TAB.condition_code%TYPE,
   serial_no                      BC_REPAIR_LINE_TAB.serial_no%TYPE,
   ownership_code                 BC_REPAIR_LINE_TAB.ownership_code%TYPE,
   owner_id                       BC_REPAIR_LINE_TAB.owner_id%TYPE,
   repair_line_action             BC_REPAIR_LINE_TAB.repair_line_action%TYPE,
   repair_type                    BC_REPAIR_LINE_TAB.repair_type%TYPE,
   customer_fault_code            BC_REPAIR_LINE_TAB.customer_fault_code%TYPE,
   note_text                      BC_REPAIR_LINE_TAB.note_text%TYPE,
   note_id                        BC_REPAIR_LINE_TAB.note_id%TYPE,
   billable_or_warranty           BC_REPAIR_LINE_TAB.billable_or_warranty%TYPE,
   manufacturer_warranty          BC_REPAIR_LINE_TAB.manufacturer_warranty%TYPE,
   repair_warranty                BC_REPAIR_LINE_TAB.repair_warranty%TYPE,
   warranty_validated             BC_REPAIR_LINE_TAB.warranty_validated%TYPE,
   processing_fee                 BC_REPAIR_LINE_TAB.processing_fee%TYPE,
   required_start                 BC_REPAIR_LINE_TAB.required_start%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (rco_no                         BOOLEAN := FALSE,
   repair_line_no                 BOOLEAN := FALSE,
   date_entered                   BOOLEAN := FALSE,
   repair_site                    BOOLEAN := FALSE,
   part_number                    BOOLEAN := FALSE,
   quantity                       BOOLEAN := FALSE,
   quantity_received              BOOLEAN := FALSE,
   condition_code                 BOOLEAN := FALSE,
   serial_no                      BOOLEAN := FALSE,
   ownership_code                 BOOLEAN := FALSE,
   owner_id                       BOOLEAN := FALSE,
   repair_line_action             BOOLEAN := FALSE,
   repair_type                    BOOLEAN := FALSE,
   customer_fault_code            BOOLEAN := FALSE,
   note_text                      BOOLEAN := FALSE,
   note_id                        BOOLEAN := FALSE,
   billable_or_warranty           BOOLEAN := FALSE,
   manufacturer_warranty          BOOLEAN := FALSE,
   repair_warranty                BOOLEAN := FALSE,
   warranty_validated             BOOLEAN := FALSE,
   processing_fee                 BOOLEAN := FALSE,
   required_start                 BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'RCO_NO', rco_no_);
   Message_SYS.Add_Attribute(msg_, 'REPAIR_LINE_NO', repair_line_no_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'RCO_NO', Fnd_Session_API.Get_Language) || ': ' || rco_no_ || ', ' ||
                                    Language_SYS.Translate_Item_Prompt_(lu_name_, 'REPAIR_LINE_NO', Fnd_Session_API.Get_Language) || ': ' || repair_line_no_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, repair_line_no_),
                            Formatted_Key___(rco_no_, repair_line_no_));
   Error_SYS.Fnd_Too_Many_Rows(Bc_Repair_Line_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, repair_line_no_),
                            Formatted_Key___(rco_no_, repair_line_no_));
   Error_SYS.Fnd_Record_Not_Exist(Bc_Repair_Line_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN bc_repair_line_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.rco_no, rec_.repair_line_no),
                            Formatted_Key___(rec_.rco_no, rec_.repair_line_no));
   Error_SYS.Fnd_Record_Exist(Bc_Repair_Line_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN bc_repair_line_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Bc_Repair_Line_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Bc_Repair_Line_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN bc_repair_line_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.rco_no, rec_.repair_line_no),
                            Formatted_Key___(rec_.rco_no, rec_.repair_line_no));
   Error_SYS.Fnd_Record_Modified(Bc_Repair_Line_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, repair_line_no_),
                            Formatted_Key___(rco_no_, repair_line_no_));
   Error_SYS.Fnd_Record_Locked(Bc_Repair_Line_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, repair_line_no_),
                            Formatted_Key___(rco_no_, repair_line_no_));
   Error_SYS.Fnd_Record_Removed(Bc_Repair_Line_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN bc_repair_line_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_repair_line_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  bc_repair_line_tab
      WHERE rowid = objid_
      AND    to_char(rowversion,'YYYYMMDDHH24MISS') = objversion_
      FOR UPDATE NOWAIT;
   RETURN rec_;
EXCEPTION
   WHEN row_locked THEN
      Error_SYS.Fnd_Record_Locked(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, NULL, 'Lock_By_Id___');
   WHEN no_data_found THEN
      BEGIN
         SELECT *
            INTO  rec_
            FROM  bc_repair_line_tab
            WHERE rowid = objid_;
         Raise_Record_Modified___(rec_);
      EXCEPTION
         WHEN no_data_found THEN
            Error_SYS.Fnd_Record_Removed(lu_name_);
         WHEN too_many_rows THEN
            Raise_Too_Many_Rows___(NULL, NULL, 'Lock_By_Id___');
      END;
END Lock_By_Id___;


-- Lock_By_Keys___
--    Locks a database row based on the primary key values.
--    Waits until record released if locked by another session.
FUNCTION Lock_By_Keys___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER) RETURN bc_repair_line_tab%ROWTYPE
IS
   rec_        bc_repair_line_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_repair_line_tab
         WHERE rco_no = rco_no_
         AND   repair_line_no = repair_line_no_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(rco_no_, repair_line_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER) RETURN bc_repair_line_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_repair_line_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_repair_line_tab
         WHERE rco_no = rco_no_
         AND   repair_line_no = repair_line_no_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(rco_no_, repair_line_no_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(rco_no_, repair_line_no_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN bc_repair_line_tab%ROWTYPE
IS
   lu_rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_repair_line_tab
      WHERE rowid = objid_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      Error_SYS.Fnd_Record_Removed(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, NULL, 'Get_Object_By_Id___');
END Get_Object_By_Id___;


-- Get_Object_By_Keys___
--    Fetched a database row based on given the primary key values.
@UncheckedAccess
FUNCTION Get_Object_By_Keys___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN bc_repair_line_tab%ROWTYPE
IS
   lu_rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Check_Exist___');
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
      FROM  bc_repair_line_tab
      WHERE rowid = objid_;
EXCEPTION
   WHEN no_data_found THEN
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, NULL, 'Get_Version_By_Id___');
END Get_Version_By_Id___;


-- Get_Version_By_Keys___
--    Fetched the objversion for a database row based on the primary key.
PROCEDURE Get_Id_Version_By_Keys___ (
   objid_      IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT bc_repair_line_tab%ROWTYPE,
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
      WHEN ('REPAIR_LINE_NO') THEN
         newrec_.repair_line_no := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.repair_line_no := TRUE;
      WHEN ('DATE_ENTERED') THEN
         newrec_.date_entered := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.date_entered := TRUE;
      WHEN ('REPAIR_SITE') THEN
         newrec_.repair_site := value_;
         indrec_.repair_site := TRUE;
      WHEN ('PART_NUMBER') THEN
         newrec_.part_number := value_;
         indrec_.part_number := TRUE;
      WHEN ('QUANTITY') THEN
         newrec_.quantity := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.quantity := TRUE;
      WHEN ('QUANTITY_RECEIVED') THEN
         newrec_.quantity_received := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.quantity_received := TRUE;
      WHEN ('CONDITION_CODE') THEN
         newrec_.condition_code := value_;
         indrec_.condition_code := TRUE;
      WHEN ('SERIAL_NO') THEN
         newrec_.serial_no := value_;
         indrec_.serial_no := TRUE;
      WHEN ('OWNERSHIP_CODE') THEN
         newrec_.ownership_code := Bc_Ownership_Code_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.ownership_code IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.ownership_code := TRUE;
      WHEN ('OWNERSHIP_CODE_DB') THEN
         newrec_.ownership_code := value_;
         indrec_.ownership_code := TRUE;
      WHEN ('OWNER_ID') THEN
         newrec_.owner_id := value_;
         indrec_.owner_id := TRUE;
      WHEN ('REPAIR_LINE_ACTION') THEN
         newrec_.repair_line_action := value_;
         indrec_.repair_line_action := TRUE;
      WHEN ('REPAIR_TYPE') THEN
         newrec_.repair_type := value_;
         indrec_.repair_type := TRUE;
      WHEN ('CUSTOMER_FAULT_CODE') THEN
         newrec_.customer_fault_code := value_;
         indrec_.customer_fault_code := TRUE;
      WHEN ('NOTE_TEXT') THEN
         newrec_.note_text := value_;
         indrec_.note_text := TRUE;
      WHEN ('NOTE_ID') THEN
         newrec_.note_id := value_;
         indrec_.note_id := TRUE;
      WHEN ('BILLABLE_OR_WARRANTY') THEN
         newrec_.billable_or_warranty := B_C_Bill_Or_War_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.billable_or_warranty IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.billable_or_warranty := TRUE;
      WHEN ('BILLABLE_OR_WARRANTY_DB') THEN
         newrec_.billable_or_warranty := value_;
         indrec_.billable_or_warranty := TRUE;
      WHEN ('MANUFACTURER_WARRANTY') THEN
         newrec_.manufacturer_warranty := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.manufacturer_warranty IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.manufacturer_warranty := TRUE;
      WHEN ('MANUFACTURER_WARRANTY_DB') THEN
         newrec_.manufacturer_warranty := value_;
         indrec_.manufacturer_warranty := TRUE;
      WHEN ('REPAIR_WARRANTY') THEN
         newrec_.repair_warranty := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.repair_warranty IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.repair_warranty := TRUE;
      WHEN ('REPAIR_WARRANTY_DB') THEN
         newrec_.repair_warranty := value_;
         indrec_.repair_warranty := TRUE;
      WHEN ('WARRANTY_VALIDATED') THEN
         newrec_.warranty_validated := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.warranty_validated IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.warranty_validated := TRUE;
      WHEN ('WARRANTY_VALIDATED_DB') THEN
         newrec_.warranty_validated := value_;
         indrec_.warranty_validated := TRUE;
      WHEN ('PROCESSING_FEE') THEN
         newrec_.processing_fee := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.processing_fee := TRUE;
      WHEN ('REQUIRED_START') THEN
         newrec_.required_start := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.required_start := TRUE;
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
   rec_ IN bc_repair_line_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.rco_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   END IF;
   IF (rec_.repair_line_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_NO', rec_.repair_line_no, attr_);
   END IF;
   IF (rec_.date_entered IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DATE_ENTERED', rec_.date_entered, attr_);
   END IF;
   IF (rec_.repair_site IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPAIR_SITE', rec_.repair_site, attr_);
   END IF;
   IF (rec_.part_number IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PART_NUMBER', rec_.part_number, attr_);
   END IF;
   IF (rec_.quantity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('QUANTITY', rec_.quantity, attr_);
   END IF;
   IF (rec_.quantity_received IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('QUANTITY_RECEIVED', rec_.quantity_received, attr_);
   END IF;
   IF (rec_.condition_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
   END IF;
   IF (rec_.serial_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SERIAL_NO', rec_.serial_no, attr_);
   END IF;
   IF (rec_.ownership_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('OWNERSHIP_CODE', Bc_Ownership_Code_API.Decode(rec_.ownership_code), attr_);
      Client_SYS.Add_To_Attr('OWNERSHIP_CODE_DB', rec_.ownership_code, attr_);
   END IF;
   IF (rec_.owner_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('OWNER_ID', rec_.owner_id, attr_);
   END IF;
   IF (rec_.repair_line_action IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION', rec_.repair_line_action, attr_);
   END IF;
   IF (rec_.repair_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPAIR_TYPE', rec_.repair_type, attr_);
   END IF;
   IF (rec_.customer_fault_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_FAULT_CODE', rec_.customer_fault_code, attr_);
   END IF;
   IF (rec_.note_text IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (rec_.note_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   END IF;
   IF (rec_.billable_or_warranty IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BILLABLE_OR_WARRANTY', B_C_Bill_Or_War_API.Decode(rec_.billable_or_warranty), attr_);
      Client_SYS.Add_To_Attr('BILLABLE_OR_WARRANTY_DB', rec_.billable_or_warranty, attr_);
   END IF;
   IF (rec_.manufacturer_warranty IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('MANUFACTURER_WARRANTY', Fnd_Boolean_API.Decode(rec_.manufacturer_warranty), attr_);
      Client_SYS.Add_To_Attr('MANUFACTURER_WARRANTY_DB', rec_.manufacturer_warranty, attr_);
   END IF;
   IF (rec_.repair_warranty IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPAIR_WARRANTY', Fnd_Boolean_API.Decode(rec_.repair_warranty), attr_);
      Client_SYS.Add_To_Attr('REPAIR_WARRANTY_DB', rec_.repair_warranty, attr_);
   END IF;
   IF (rec_.warranty_validated IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('WARRANTY_VALIDATED', Fnd_Boolean_API.Decode(rec_.warranty_validated), attr_);
      Client_SYS.Add_To_Attr('WARRANTY_VALIDATED_DB', rec_.warranty_validated, attr_);
   END IF;
   IF (rec_.processing_fee IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PROCESSING_FEE', rec_.processing_fee, attr_);
   END IF;
   IF (rec_.required_start IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REQUIRED_START', rec_.required_start, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN bc_repair_line_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.rco_no) THEN
      Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   END IF;
   IF (indrec_.repair_line_no) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_NO', rec_.repair_line_no, attr_);
   END IF;
   IF (indrec_.date_entered) THEN
      Client_SYS.Add_To_Attr('DATE_ENTERED', rec_.date_entered, attr_);
   END IF;
   IF (indrec_.repair_site) THEN
      Client_SYS.Add_To_Attr('REPAIR_SITE', rec_.repair_site, attr_);
   END IF;
   IF (indrec_.part_number) THEN
      Client_SYS.Add_To_Attr('PART_NUMBER', rec_.part_number, attr_);
   END IF;
   IF (indrec_.quantity) THEN
      Client_SYS.Add_To_Attr('QUANTITY', rec_.quantity, attr_);
   END IF;
   IF (indrec_.quantity_received) THEN
      Client_SYS.Add_To_Attr('QUANTITY_RECEIVED', rec_.quantity_received, attr_);
   END IF;
   IF (indrec_.condition_code) THEN
      Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
   END IF;
   IF (indrec_.serial_no) THEN
      Client_SYS.Add_To_Attr('SERIAL_NO', rec_.serial_no, attr_);
   END IF;
   IF (indrec_.ownership_code) THEN
      Client_SYS.Add_To_Attr('OWNERSHIP_CODE', Bc_Ownership_Code_API.Decode(rec_.ownership_code), attr_);
      Client_SYS.Add_To_Attr('OWNERSHIP_CODE_DB', rec_.ownership_code, attr_);
   END IF;
   IF (indrec_.owner_id) THEN
      Client_SYS.Add_To_Attr('OWNER_ID', rec_.owner_id, attr_);
   END IF;
   IF (indrec_.repair_line_action) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION', rec_.repair_line_action, attr_);
   END IF;
   IF (indrec_.repair_type) THEN
      Client_SYS.Add_To_Attr('REPAIR_TYPE', rec_.repair_type, attr_);
   END IF;
   IF (indrec_.customer_fault_code) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_FAULT_CODE', rec_.customer_fault_code, attr_);
   END IF;
   IF (indrec_.note_text) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (indrec_.note_id) THEN
      Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   END IF;
   IF (indrec_.billable_or_warranty) THEN
      Client_SYS.Add_To_Attr('BILLABLE_OR_WARRANTY', B_C_Bill_Or_War_API.Decode(rec_.billable_or_warranty), attr_);
      Client_SYS.Add_To_Attr('BILLABLE_OR_WARRANTY_DB', rec_.billable_or_warranty, attr_);
   END IF;
   IF (indrec_.manufacturer_warranty) THEN
      Client_SYS.Add_To_Attr('MANUFACTURER_WARRANTY', Fnd_Boolean_API.Decode(rec_.manufacturer_warranty), attr_);
      Client_SYS.Add_To_Attr('MANUFACTURER_WARRANTY_DB', rec_.manufacturer_warranty, attr_);
   END IF;
   IF (indrec_.repair_warranty) THEN
      Client_SYS.Add_To_Attr('REPAIR_WARRANTY', Fnd_Boolean_API.Decode(rec_.repair_warranty), attr_);
      Client_SYS.Add_To_Attr('REPAIR_WARRANTY_DB', rec_.repair_warranty, attr_);
   END IF;
   IF (indrec_.warranty_validated) THEN
      Client_SYS.Add_To_Attr('WARRANTY_VALIDATED', Fnd_Boolean_API.Decode(rec_.warranty_validated), attr_);
      Client_SYS.Add_To_Attr('WARRANTY_VALIDATED_DB', rec_.warranty_validated, attr_);
   END IF;
   IF (indrec_.processing_fee) THEN
      Client_SYS.Add_To_Attr('PROCESSING_FEE', rec_.processing_fee, attr_);
   END IF;
   IF (indrec_.required_start) THEN
      Client_SYS.Add_To_Attr('REQUIRED_START', rec_.required_start, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN bc_repair_line_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   Client_SYS.Add_To_Attr('REPAIR_LINE_NO', rec_.repair_line_no, attr_);
   Client_SYS.Add_To_Attr('DATE_ENTERED', rec_.date_entered, attr_);
   Client_SYS.Add_To_Attr('REPAIR_SITE', rec_.repair_site, attr_);
   Client_SYS.Add_To_Attr('PART_NUMBER', rec_.part_number, attr_);
   Client_SYS.Add_To_Attr('QUANTITY', rec_.quantity, attr_);
   Client_SYS.Add_To_Attr('QUANTITY_RECEIVED', rec_.quantity_received, attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
   Client_SYS.Add_To_Attr('SERIAL_NO', rec_.serial_no, attr_);
   Client_SYS.Add_To_Attr('OWNERSHIP_CODE', rec_.ownership_code, attr_);
   Client_SYS.Add_To_Attr('OWNER_ID', rec_.owner_id, attr_);
   Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION', rec_.repair_line_action, attr_);
   Client_SYS.Add_To_Attr('REPAIR_TYPE', rec_.repair_type, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_FAULT_CODE', rec_.customer_fault_code, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', rec_.note_id, attr_);
   Client_SYS.Add_To_Attr('BILLABLE_OR_WARRANTY', rec_.billable_or_warranty, attr_);
   Client_SYS.Add_To_Attr('MANUFACTURER_WARRANTY', rec_.manufacturer_warranty, attr_);
   Client_SYS.Add_To_Attr('REPAIR_WARRANTY', rec_.repair_warranty, attr_);
   Client_SYS.Add_To_Attr('WARRANTY_VALIDATED', rec_.warranty_validated, attr_);
   Client_SYS.Add_To_Attr('PROCESSING_FEE', rec_.processing_fee, attr_);
   Client_SYS.Add_To_Attr('REQUIRED_START', rec_.required_start, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   Client_SYS.Add_To_Attr('ROWSTATE', rec_.rowstate, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN bc_repair_line_tab%ROWTYPE
IS
   rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.rowstate                       := public_.rowstate;
   rec_.rco_no                         := public_.rco_no;
   rec_.repair_line_no                 := public_.repair_line_no;
   rec_.date_entered                   := public_.date_entered;
   rec_.repair_site                    := public_.repair_site;
   rec_.part_number                    := public_.part_number;
   rec_.quantity                       := public_.quantity;
   rec_.quantity_received              := public_.quantity_received;
   rec_.condition_code                 := public_.condition_code;
   rec_.serial_no                      := public_.serial_no;
   rec_.ownership_code                 := public_.ownership_code;
   rec_.owner_id                       := public_.owner_id;
   rec_.repair_line_action             := public_.repair_line_action;
   rec_.repair_type                    := public_.repair_type;
   rec_.customer_fault_code            := public_.customer_fault_code;
   rec_.note_text                      := public_.note_text;
   rec_.note_id                        := public_.note_id;
   rec_.billable_or_warranty           := public_.billable_or_warranty;
   rec_.manufacturer_warranty          := public_.manufacturer_warranty;
   rec_.repair_warranty                := public_.repair_warranty;
   rec_.warranty_validated             := public_.warranty_validated;
   rec_.processing_fee                 := public_.processing_fee;
   rec_.required_start                 := public_.required_start;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN bc_repair_line_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.rowstate                       := rec_.rowstate;
   public_.rco_no                         := rec_.rco_no;
   public_.repair_line_no                 := rec_.repair_line_no;
   public_.date_entered                   := rec_.date_entered;
   public_.repair_site                    := rec_.repair_site;
   public_.part_number                    := rec_.part_number;
   public_.quantity                       := rec_.quantity;
   public_.quantity_received              := rec_.quantity_received;
   public_.condition_code                 := rec_.condition_code;
   public_.serial_no                      := rec_.serial_no;
   public_.ownership_code                 := rec_.ownership_code;
   public_.owner_id                       := rec_.owner_id;
   public_.repair_line_action             := rec_.repair_line_action;
   public_.repair_type                    := rec_.repair_type;
   public_.customer_fault_code            := rec_.customer_fault_code;
   public_.note_text                      := rec_.note_text;
   public_.note_id                        := rec_.note_id;
   public_.billable_or_warranty           := rec_.billable_or_warranty;
   public_.manufacturer_warranty          := rec_.manufacturer_warranty;
   public_.repair_warranty                := rec_.repair_warranty;
   public_.warranty_validated             := rec_.warranty_validated;
   public_.processing_fee                 := rec_.processing_fee;
   public_.required_start                 := rec_.required_start;
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
   rec_ IN bc_repair_line_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.rco_no := rec_.rco_no IS NOT NULL;
   indrec_.repair_line_no := rec_.repair_line_no IS NOT NULL;
   indrec_.date_entered := rec_.date_entered IS NOT NULL;
   indrec_.repair_site := rec_.repair_site IS NOT NULL;
   indrec_.part_number := rec_.part_number IS NOT NULL;
   indrec_.quantity := rec_.quantity IS NOT NULL;
   indrec_.quantity_received := rec_.quantity_received IS NOT NULL;
   indrec_.condition_code := rec_.condition_code IS NOT NULL;
   indrec_.serial_no := rec_.serial_no IS NOT NULL;
   indrec_.ownership_code := rec_.ownership_code IS NOT NULL;
   indrec_.owner_id := rec_.owner_id IS NOT NULL;
   indrec_.repair_line_action := rec_.repair_line_action IS NOT NULL;
   indrec_.repair_type := rec_.repair_type IS NOT NULL;
   indrec_.customer_fault_code := rec_.customer_fault_code IS NOT NULL;
   indrec_.note_text := rec_.note_text IS NOT NULL;
   indrec_.note_id := rec_.note_id IS NOT NULL;
   indrec_.billable_or_warranty := rec_.billable_or_warranty IS NOT NULL;
   indrec_.manufacturer_warranty := rec_.manufacturer_warranty IS NOT NULL;
   indrec_.repair_warranty := rec_.repair_warranty IS NOT NULL;
   indrec_.warranty_validated := rec_.warranty_validated IS NOT NULL;
   indrec_.processing_fee := rec_.processing_fee IS NOT NULL;
   indrec_.required_start := rec_.required_start IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN bc_repair_line_tab%ROWTYPE,
   newrec_ IN bc_repair_line_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.rco_no := Validate_SYS.Is_Changed(oldrec_.rco_no, newrec_.rco_no);
   indrec_.repair_line_no := Validate_SYS.Is_Changed(oldrec_.repair_line_no, newrec_.repair_line_no);
   indrec_.date_entered := Validate_SYS.Is_Changed(oldrec_.date_entered, newrec_.date_entered);
   indrec_.repair_site := Validate_SYS.Is_Changed(oldrec_.repair_site, newrec_.repair_site);
   indrec_.part_number := Validate_SYS.Is_Changed(oldrec_.part_number, newrec_.part_number);
   indrec_.quantity := Validate_SYS.Is_Changed(oldrec_.quantity, newrec_.quantity);
   indrec_.quantity_received := Validate_SYS.Is_Changed(oldrec_.quantity_received, newrec_.quantity_received);
   indrec_.condition_code := Validate_SYS.Is_Changed(oldrec_.condition_code, newrec_.condition_code);
   indrec_.serial_no := Validate_SYS.Is_Changed(oldrec_.serial_no, newrec_.serial_no);
   indrec_.ownership_code := Validate_SYS.Is_Changed(oldrec_.ownership_code, newrec_.ownership_code);
   indrec_.owner_id := Validate_SYS.Is_Changed(oldrec_.owner_id, newrec_.owner_id);
   indrec_.repair_line_action := Validate_SYS.Is_Changed(oldrec_.repair_line_action, newrec_.repair_line_action);
   indrec_.repair_type := Validate_SYS.Is_Changed(oldrec_.repair_type, newrec_.repair_type);
   indrec_.customer_fault_code := Validate_SYS.Is_Changed(oldrec_.customer_fault_code, newrec_.customer_fault_code);
   indrec_.note_text := Validate_SYS.Is_Changed(oldrec_.note_text, newrec_.note_text);
   indrec_.note_id := Validate_SYS.Is_Changed(oldrec_.note_id, newrec_.note_id);
   indrec_.billable_or_warranty := Validate_SYS.Is_Changed(oldrec_.billable_or_warranty, newrec_.billable_or_warranty);
   indrec_.manufacturer_warranty := Validate_SYS.Is_Changed(oldrec_.manufacturer_warranty, newrec_.manufacturer_warranty);
   indrec_.repair_warranty := Validate_SYS.Is_Changed(oldrec_.repair_warranty, newrec_.repair_warranty);
   indrec_.warranty_validated := Validate_SYS.Is_Changed(oldrec_.warranty_validated, newrec_.warranty_validated);
   indrec_.processing_fee := Validate_SYS.Is_Changed(oldrec_.processing_fee, newrec_.processing_fee);
   indrec_.required_start := Validate_SYS.Is_Changed(oldrec_.required_start, newrec_.required_start);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     bc_repair_line_tab%ROWTYPE,
   newrec_ IN OUT bc_repair_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.ownership_code IS NOT NULL)
   AND (indrec_.ownership_code)
   AND (Validate_SYS.Is_Changed(oldrec_.ownership_code, newrec_.ownership_code)) THEN
      Bc_Ownership_Code_API.Exist_Db(newrec_.ownership_code);
   END IF;
   IF (newrec_.billable_or_warranty IS NOT NULL)
   AND (indrec_.billable_or_warranty)
   AND (Validate_SYS.Is_Changed(oldrec_.billable_or_warranty, newrec_.billable_or_warranty)) THEN
      B_C_Bill_Or_War_API.Exist_Db(newrec_.billable_or_warranty);
   END IF;
   IF (newrec_.manufacturer_warranty IS NOT NULL)
   AND (indrec_.manufacturer_warranty)
   AND (Validate_SYS.Is_Changed(oldrec_.manufacturer_warranty, newrec_.manufacturer_warranty)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.manufacturer_warranty);
   END IF;
   IF (newrec_.repair_warranty IS NOT NULL)
   AND (indrec_.repair_warranty)
   AND (Validate_SYS.Is_Changed(oldrec_.repair_warranty, newrec_.repair_warranty)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.repair_warranty);
   END IF;
   IF (newrec_.warranty_validated IS NOT NULL)
   AND (indrec_.warranty_validated)
   AND (Validate_SYS.Is_Changed(oldrec_.warranty_validated, newrec_.warranty_validated)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.warranty_validated);
   END IF;
   IF (newrec_.owner_id IS NOT NULL)
   AND (indrec_.owner_id)
   AND (Validate_SYS.Is_Changed(oldrec_.owner_id, newrec_.owner_id)) THEN
      Customer_Info_API.Exist(newrec_.owner_id);
   END IF;
   IF (newrec_.repair_type IS NOT NULL)
   AND (indrec_.repair_type)
   AND (Validate_SYS.Is_Changed(oldrec_.repair_type, newrec_.repair_type)) THEN
      Bc_Repair_Type_API.Exist(newrec_.repair_type);
   END IF;
   IF (newrec_.condition_code IS NOT NULL)
   AND (indrec_.condition_code)
   AND (Validate_SYS.Is_Changed(oldrec_.condition_code, newrec_.condition_code)) THEN
      Condition_Code_API.Exist(newrec_.condition_code);
   END IF;
   IF (newrec_.repair_site IS NOT NULL AND newrec_.part_number IS NOT NULL)
   AND (indrec_.repair_site OR indrec_.part_number)
   AND (Validate_SYS.Is_Changed(oldrec_.repair_site, newrec_.repair_site)
     OR Validate_SYS.Is_Changed(oldrec_.part_number, newrec_.part_number)) THEN
      Inventory_Part_API.Exist(newrec_.repair_site, newrec_.part_number);
   END IF;
   IF (newrec_.repair_site IS NOT NULL)
   AND (indrec_.repair_site)
   AND (Validate_SYS.Is_Changed(oldrec_.repair_site, newrec_.repair_site)) THEN
      Site_API.Exist(newrec_.repair_site);
   END IF;
   IF (newrec_.rco_no IS NOT NULL)
   AND (indrec_.rco_no)
   AND (Validate_SYS.Is_Changed(oldrec_.rco_no, newrec_.rco_no)) THEN
      Bc_Repair_Center_Order_API.Exist(newrec_.rco_no);
   END IF;
   IF (newrec_.repair_line_action IS NOT NULL)
   AND (indrec_.repair_line_action)
   AND (Validate_SYS.Is_Changed(oldrec_.repair_line_action, newrec_.repair_line_action)) THEN
      Bc_Repair_Line_Action_API.Exist(newrec_.repair_line_action);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'RCO_NO', newrec_.rco_no);
   Error_SYS.Check_Not_Null(lu_name_, 'DATE_ENTERED', newrec_.date_entered);
   Error_SYS.Check_Not_Null(lu_name_, 'REPAIR_SITE', newrec_.repair_site);
   Error_SYS.Check_Not_Null(lu_name_, 'PART_NUMBER', newrec_.part_number);
   Error_SYS.Check_Not_Null(lu_name_, 'QUANTITY', newrec_.quantity);
   Error_SYS.Check_Not_Null(lu_name_, 'QUANTITY_RECEIVED', newrec_.quantity_received);
   Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_FAULT_CODE', newrec_.customer_fault_code);
   Error_SYS.Check_Not_Null(lu_name_, 'BILLABLE_OR_WARRANTY', newrec_.billable_or_warranty);
   Error_SYS.Check_Not_Null(lu_name_, 'REQUIRED_START', newrec_.required_start);
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
   newrec_ IN OUT bc_repair_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT bc_repair_line_tab%ROWTYPE,
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
      INTO bc_repair_line_tab
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
         IF (constraint_ = 'BC_REPAIR_LINE_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_REPAIR_LINE_PK') THEN
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
   newrec_ IN OUT bc_repair_line_tab%ROWTYPE )
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
   newrec_ IN OUT bc_repair_line_tab%ROWTYPE )
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
   oldrec_ IN     bc_repair_line_tab%ROWTYPE,
   newrec_ IN OUT bc_repair_line_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'RCO_NO', indrec_.rco_no);
   Validate_SYS.Item_Update(lu_name_, 'REPAIR_LINE_NO', indrec_.repair_line_no);
   Validate_SYS.Item_Update(lu_name_, 'DATE_ENTERED', indrec_.date_entered);
   Validate_SYS.Item_Update(lu_name_, 'OWNER_ID', indrec_.owner_id);
   Validate_SYS.Item_Update(lu_name_, 'CUSTOMER_FAULT_CODE', indrec_.customer_fault_code);
   Validate_SYS.Item_Update(lu_name_, 'NOTE_ID', indrec_.note_id);
   Validate_SYS.Item_Update(lu_name_, 'MANUFACTURER_WARRANTY', indrec_.manufacturer_warranty);
   Validate_SYS.Item_Update(lu_name_, 'REPAIR_WARRANTY', indrec_.repair_warranty);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     bc_repair_line_tab%ROWTYPE,
   newrec_     IN OUT bc_repair_line_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE bc_repair_line_tab
         SET ROW = newrec_
         WHERE rco_no = newrec_.rco_no
         AND   repair_line_no = newrec_.repair_line_no;
   ELSE
      UPDATE bc_repair_line_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'BC_REPAIR_LINE_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Bc_Repair_Line_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_REPAIR_LINE_PK') THEN
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
   newrec_         IN OUT bc_repair_line_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.rco_no, newrec_.repair_line_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.rco_no, newrec_.repair_line_no);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN bc_repair_line_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.rco_no||'^'||remrec_.repair_line_no||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN bc_repair_line_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.rco_no||'^'||remrec_.repair_line_no||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  bc_repair_line_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  bc_repair_line_tab
         WHERE rco_no = remrec_.rco_no
         AND   repair_line_no = remrec_.repair_line_no;
   END IF;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN bc_repair_line_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT bc_repair_line_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.rco_no, remrec_.repair_line_no);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.rco_no, remrec_.repair_line_no);
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
   dummy_ bc_repair_line_tab%ROWTYPE;
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
   newrec_   bc_repair_line_tab%ROWTYPE;
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
   oldrec_   bc_repair_line_tab%ROWTYPE;
   newrec_   bc_repair_line_tab%ROWTYPE;
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
   remrec_ bc_repair_line_tab%ROWTYPE;
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
   rowkey_ IN VARCHAR2 ) RETURN bc_repair_line_tab%ROWTYPE
IS
   rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rco_no, repair_line_no
      INTO  rec_.rco_no, rec_.repair_line_no
      FROM  bc_repair_line_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.rco_no, rec_.repair_line_no, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER )
IS
BEGIN
   IF (NOT Check_Exist___(rco_no_, repair_line_no_)) THEN
      Raise_Record_Not_Exist___(rco_no_, repair_line_no_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(rco_no_, repair_line_no_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   rco_no_ bc_repair_line_tab.rco_no%TYPE;
   repair_line_no_ bc_repair_line_tab.repair_line_no%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT rco_no, repair_line_no
   INTO  rco_no_, repair_line_no_
   FROM  bc_repair_line_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(rco_no_, repair_line_no_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Date_Entered
--   Fetches the DateEntered attribute for a record.
@UncheckedAccess
FUNCTION Get_Date_Entered (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN DATE
IS
   temp_ bc_repair_line_tab.date_entered%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT date_entered
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Date_Entered');
END Get_Date_Entered;


-- Get_Repair_Site
--   Fetches the RepairSite attribute for a record.
@UncheckedAccess
FUNCTION Get_Repair_Site (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.repair_site%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_site
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Repair_Site');
END Get_Repair_Site;


-- Get_Part_Number
--   Fetches the PartNumber attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_Number (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.part_number%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT part_number
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Part_Number');
END Get_Part_Number;


-- Get_Quantity
--   Fetches the Quantity attribute for a record.
@UncheckedAccess
FUNCTION Get_Quantity (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ bc_repair_line_tab.quantity%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT quantity
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Quantity');
END Get_Quantity;


-- Get_Quantity_Received
--   Fetches the QuantityReceived attribute for a record.
@UncheckedAccess
FUNCTION Get_Quantity_Received (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ bc_repair_line_tab.quantity_received%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT quantity_received
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Quantity_Received');
END Get_Quantity_Received;


-- Get_Condition_Code
--   Fetches the ConditionCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Condition_Code (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.condition_code%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT condition_code
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Condition_Code');
END Get_Condition_Code;


-- Get_Serial_No
--   Fetches the SerialNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Serial_No (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.serial_no%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT serial_no
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Serial_No');
END Get_Serial_No;


-- Get_Ownership_Code
--   Fetches the OwnershipCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Ownership_Code (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.ownership_code%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ownership_code
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN Bc_Ownership_Code_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Ownership_Code');
END Get_Ownership_Code;


-- Get_Ownership_Code_Db
--   Fetches the DB value of OwnershipCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Ownership_Code_Db (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN bc_repair_line_tab.ownership_code%TYPE
IS
   temp_ bc_repair_line_tab.ownership_code%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT ownership_code
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Ownership_Code_Db');
END Get_Ownership_Code_Db;


-- Get_Owner_Id
--   Fetches the OwnerId attribute for a record.
@UncheckedAccess
FUNCTION Get_Owner_Id (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.owner_id%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT owner_id
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Owner_Id');
END Get_Owner_Id;


-- Get_Repair_Line_Action
--   Fetches the RepairLineAction attribute for a record.
@UncheckedAccess
FUNCTION Get_Repair_Line_Action (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.repair_line_action%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_line_action
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Repair_Line_Action');
END Get_Repair_Line_Action;


-- Get_Repair_Type
--   Fetches the RepairType attribute for a record.
@UncheckedAccess
FUNCTION Get_Repair_Type (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.repair_type%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_type
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Repair_Type');
END Get_Repair_Type;


-- Get_Customer_Fault_Code
--   Fetches the CustomerFaultCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_Fault_Code (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.customer_fault_code%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_fault_code
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Customer_Fault_Code');
END Get_Customer_Fault_Code;


-- Get_Note_Text
--   Fetches the NoteText attribute for a record.
@UncheckedAccess
FUNCTION Get_Note_Text (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.note_text%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT note_text
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Note_Text');
END Get_Note_Text;


-- Get_Note_Id
--   Fetches the NoteId attribute for a record.
@UncheckedAccess
FUNCTION Get_Note_Id (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.note_id%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT note_id
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Note_Id');
END Get_Note_Id;


-- Get_Billable_Or_Warranty
--   Fetches the BillableOrWarranty attribute for a record.
@UncheckedAccess
FUNCTION Get_Billable_Or_Warranty (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.billable_or_warranty%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT billable_or_warranty
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN B_C_Bill_Or_War_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Billable_Or_Warranty');
END Get_Billable_Or_Warranty;


-- Get_Billable_Or_Warranty_Db
--   Fetches the DB value of BillableOrWarranty attribute for a record.
@UncheckedAccess
FUNCTION Get_Billable_Or_Warranty_Db (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN bc_repair_line_tab.billable_or_warranty%TYPE
IS
   temp_ bc_repair_line_tab.billable_or_warranty%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT billable_or_warranty
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Billable_Or_Warranty_Db');
END Get_Billable_Or_Warranty_Db;


-- Get_Manufacturer_Warranty
--   Fetches the ManufacturerWarranty attribute for a record.
@UncheckedAccess
FUNCTION Get_Manufacturer_Warranty (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.manufacturer_warranty%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT manufacturer_warranty
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Manufacturer_Warranty');
END Get_Manufacturer_Warranty;


-- Get_Manufacturer_Warranty_Db
--   Fetches the DB value of ManufacturerWarranty attribute for a record.
@UncheckedAccess
FUNCTION Get_Manufacturer_Warranty_Db (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN bc_repair_line_tab.manufacturer_warranty%TYPE
IS
   temp_ bc_repair_line_tab.manufacturer_warranty%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT manufacturer_warranty
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Manufacturer_Warranty_Db');
END Get_Manufacturer_Warranty_Db;


-- Get_Repair_Warranty
--   Fetches the RepairWarranty attribute for a record.
@UncheckedAccess
FUNCTION Get_Repair_Warranty (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.repair_warranty%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_warranty
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Repair_Warranty');
END Get_Repair_Warranty;


-- Get_Repair_Warranty_Db
--   Fetches the DB value of RepairWarranty attribute for a record.
@UncheckedAccess
FUNCTION Get_Repair_Warranty_Db (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN bc_repair_line_tab.repair_warranty%TYPE
IS
   temp_ bc_repair_line_tab.repair_warranty%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_warranty
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Repair_Warranty_Db');
END Get_Repair_Warranty_Db;


-- Get_Warranty_Validated
--   Fetches the WarrantyValidated attribute for a record.
@UncheckedAccess
FUNCTION Get_Warranty_Validated (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.warranty_validated%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT warranty_validated
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Warranty_Validated');
END Get_Warranty_Validated;


-- Get_Warranty_Validated_Db
--   Fetches the DB value of WarrantyValidated attribute for a record.
@UncheckedAccess
FUNCTION Get_Warranty_Validated_Db (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN bc_repair_line_tab.warranty_validated%TYPE
IS
   temp_ bc_repair_line_tab.warranty_validated%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT warranty_validated
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Warranty_Validated_Db');
END Get_Warranty_Validated_Db;


-- Get_Processing_Fee
--   Fetches the ProcessingFee attribute for a record.
@UncheckedAccess
FUNCTION Get_Processing_Fee (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN NUMBER
IS
   temp_ bc_repair_line_tab.processing_fee%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT processing_fee
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Processing_Fee');
END Get_Processing_Fee;


-- Get_Required_Start
--   Fetches the RequiredStart attribute for a record.
@UncheckedAccess
FUNCTION Get_Required_Start (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN DATE
IS
   temp_ bc_repair_line_tab.required_start%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT required_start
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Required_Start');
END Get_Required_Start;


-- Get_State
--   Fetches the State attribute for a record.
@UncheckedAccess
FUNCTION Get_State (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Decode__(Get_Objstate(rco_no_, repair_line_no_));
END Get_State;


-- Get_Objstate
--   Fetches the Objstate attribute for a record.
@UncheckedAccess
FUNCTION Get_Objstate (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_tab.rowstate%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowstate
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Objstate');
END Get_Objstate;


-- Get_Objevents
--   Fetches the Objevents attribute for a record.
@UncheckedAccess
FUNCTION Get_Objevents (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
BEGIN
   RETURN Finite_State_Events__(Get_Objstate(rco_no_, repair_line_no_));
END Get_Objevents;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.rco_no, rowrec_.repair_line_no);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rco_no, repair_line_no, rowid, rowversion, rowkey, rowstate,
          date_entered, 
          repair_site, 
          part_number, 
          quantity, 
          quantity_received, 
          condition_code, 
          serial_no, 
          ownership_code, 
          owner_id, 
          repair_line_action, 
          repair_type, 
          customer_fault_code, 
          note_text, 
          note_id, 
          billable_or_warranty, 
          manufacturer_warranty, 
          repair_warranty, 
          warranty_validated, 
          processing_fee, 
          required_start
      INTO  temp_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   rco_no_ IN NUMBER,
   repair_line_no_ IN NUMBER ) RETURN VARCHAR2
IS
   rowkey_ bc_repair_line_tab.rowkey%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR repair_line_no_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  bc_repair_line_tab
      WHERE rco_no = rco_no_
      AND   repair_line_no = repair_line_no_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, repair_line_no_, 'Get_Objkey');
END Get_Objkey;

-------------------- FINITE STATE MACHINE -----------------------------------

-- Get_Db_Values___
--   Returns the the list of DB (stored in database) values.
FUNCTION Get_Db_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('New^Received^Cancelled^Processed^RepairStarted^RepairCompleted^Shipped^');
END Get_Db_Values___;


-- Get_Client_Values___
--   Returns the the list of client (in PROG language) values.
FUNCTION Get_Client_Values___ RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   RETURN('New^Received^Cancelled^Processed^Repair Started^Repair Completed^Shipped^');
END Get_Client_Values___;


-- Check_Rco_Cancel___
--    Execute the CheckRcoCancel action within the finite state machine.
PROCEDURE Check_Rco_Cancel___ (
   rec_  IN OUT bc_repair_line_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Compleate_Rco___
--    Execute the CompleateRco action within the finite state machine.
PROCEDURE Compleate_Rco___ (
   rec_  IN OUT bc_repair_line_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Repair_Order_Start___
--    Execute the RepairOrderStart action within the finite state machine.
PROCEDURE Repair_Order_Start___ (
   rec_  IN OUT bc_repair_line_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 );


-- Check_Order_Released___
--    Evaluates the CheckOrderReleased condition within the finite state machine.
FUNCTION Check_Order_Released___ (
   rec_  IN     bc_repair_line_tab%ROWTYPE ) RETURN BOOLEAN;


-- Finite_State_Set___
--    Updates the state column in the database for given record.
PROCEDURE Finite_State_Set___ (
   rec_   IN OUT bc_repair_line_tab%ROWTYPE,
   state_ IN     VARCHAR2 )
IS
BEGIN
   rec_.rowversion := sysdate;
   UPDATE bc_repair_line_tab
      SET rowstate = state_,
          rowversion = rec_.rowversion
      WHERE rco_no = rec_.rco_no
      AND   repair_line_no = rec_.repair_line_no;
   rec_.rowstate := state_;
END Finite_State_Set___;


-- Finite_State_Machine___
--    Execute the state machine logic given a specific event.
PROCEDURE Finite_State_Machine___ (
   rec_   IN OUT bc_repair_line_tab%ROWTYPE,
   event_ IN     VARCHAR2,
   attr_  IN OUT VARCHAR2 )
IS
   state_ bc_repair_line_tab.rowstate%TYPE;
BEGIN
   state_ := rec_.rowstate;
   IF (state_ IS NULL) THEN
      IF (event_ IS NULL) THEN
         Finite_State_Set___(rec_, 'New');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Cancelled') THEN
      Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
   ELSIF (state_ = 'New') THEN
      IF (event_ = 'Cancel') THEN
         Check_Rco_Cancel___(rec_, attr_);
         Finite_State_Set___(rec_, 'Cancelled');
      ELSIF (event_ = 'Receive') THEN
         Finite_State_Set___(rec_, 'Received');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Processed') THEN
      IF (event_ = 'Cancel') THEN
         Check_Rco_Cancel___(rec_, attr_);
         Finite_State_Set___(rec_, 'Cancelled');
      ELSIF (event_ = 'RepairStart') THEN
         Repair_Order_Start___(rec_, attr_);
         Finite_State_Set___(rec_, 'RepairStarted');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Received') THEN
      IF (event_ = 'Cancel') THEN
         Check_Rco_Cancel___(rec_, attr_);
         Finite_State_Set___(rec_, 'Cancelled');
      ELSIF (event_ = 'Process') THEN
         IF (Check_Order_Released___(rec_)) THEN
            Finite_State_Set___(rec_, 'Processed');
         END IF;
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'RepairCompleted') THEN
      IF (event_ = 'Ship') THEN
         Finite_State_Set___(rec_, 'Shipped');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'RepairStarted') THEN
      IF (event_ = 'Cancel') THEN
         Check_Rco_Cancel___(rec_, attr_);
         Finite_State_Set___(rec_, 'Cancelled');
      ELSIF (event_ = 'RepairComplete') THEN
         Compleate_Rco___(rec_, attr_);
         Finite_State_Set___(rec_, 'RepairCompleted');
      ELSE
         Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
      END IF;
   ELSIF (state_ = 'Shipped') THEN
      Error_SYS.State_Event_Not_Handled(lu_name_, event_, Finite_State_Decode__(state_));
   ELSE
      Error_SYS.State_Not_Exist(lu_name_, Finite_State_Decode__(state_));
   END IF;
END Finite_State_Machine___;


-- Finite_State_Add_To_Attr___
--    Add current state and lists of allowed events to an attribute string.
PROCEDURE Finite_State_Add_To_Attr___ (
   rec_  IN     bc_repair_line_tab%ROWTYPE,
   attr_ IN OUT VARCHAR2 )
IS
   state_ bc_repair_line_tab.rowstate%TYPE;
BEGIN
   state_ := rec_.rowstate;
   Client_SYS.Add_To_Attr('__OBJSTATE', state_, attr_);
   Client_SYS.Add_To_Attr('__OBJEVENTS', Finite_State_Events__(state_), attr_);
   Client_SYS.Add_To_Attr('STATE', Finite_State_Decode__(state_), attr_);
END Finite_State_Add_To_Attr___;


-- Finite_State_Init___
--    Runs the initial start event for the state machine.
PROCEDURE Finite_State_Init___ (
   rec_  IN OUT bc_repair_line_tab%ROWTYPE,
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
   rec_  IN OUT bc_repair_line_tab%ROWTYPE,
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
   ELSIF (db_state_ = 'New') THEN
      RETURN 'Cancel^Receive^';
   ELSIF (db_state_ = 'Processed') THEN
      RETURN 'RepairStart^Cancel^';
   ELSIF (db_state_ = 'Received') THEN
      RETURN 'Process^Cancel^';
   ELSIF (db_state_ = 'RepairCompleted') THEN
      RETURN 'Ship^';
   ELSIF (db_state_ = 'RepairStarted') THEN
      RETURN 'RepairComplete^Cancel^';
   ELSIF (db_state_ = 'Shipped') THEN
      RETURN NULL;
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
   db_events_ := 'Cancel^Process^Receive^RepairComplete^RepairStart^Ship^';
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
   rec_ bc_repair_line_tab%ROWTYPE;
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


-- Process__
--   Executes the Process event logic as defined in the state machine.
PROCEDURE Process__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Process', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Process__;


-- Receive__
--   Executes the Receive event logic as defined in the state machine.
PROCEDURE Receive__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Receive', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Receive__;


-- Repair_Complete__
--   Executes the RepairComplete event logic as defined in the state machine.
PROCEDURE Repair_Complete__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'RepairComplete', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Repair_Complete__;


-- Repair_Start__
--   Executes the RepairStart event logic as defined in the state machine.
PROCEDURE Repair_Start__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'RepairStart', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Repair_Start__;


-- Ship__
--   Executes the Ship event logic as defined in the state machine.
PROCEDURE Ship__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   rec_ bc_repair_line_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      NULL;
   ELSIF (action_ = 'DO') THEN
      rec_ := Lock_By_Id___(objid_, objversion_);
      Finite_State_Machine___(rec_, 'Ship', attr_);
      objversion_ := to_char(rec_.rowversion,'YYYYMMDDHH24MISS');
      Finite_State_Add_To_Attr___(rec_, attr_);
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Ship__;



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