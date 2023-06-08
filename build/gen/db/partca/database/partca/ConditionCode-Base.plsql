-----------------------------------------------------------------------------
--
--  Logical unit: ConditionCode
--  Component:    PARTCA
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
--  (condition_code                 CONDITION_CODE_TAB.condition_code%TYPE);

TYPE Public_Rec IS RECORD
  (condition_code                 CONDITION_CODE_TAB.condition_code%TYPE,
   "rowid"                        rowid,
   rowversion                     CONDITION_CODE_TAB.rowversion%TYPE,
   rowkey                         CONDITION_CODE_TAB.rowkey%TYPE,
   description                    CONDITION_CODE_TAB.description%TYPE,
   note_text                      CONDITION_CODE_TAB.note_text%TYPE,
   condition_code_type            CONDITION_CODE_TAB.condition_code_type%TYPE,
   default_avail_control_id       CONDITION_CODE_TAB.default_avail_control_id%TYPE,
   reset_repair_value             CONDITION_CODE_TAB.reset_repair_value%TYPE,
   reset_overhaul_value           CONDITION_CODE_TAB.reset_overhaul_value%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (condition_code                 BOOLEAN := FALSE,
   description                    BOOLEAN := FALSE,
   note_text                      BOOLEAN := FALSE,
   condition_code_type            BOOLEAN := FALSE,
   default_avail_control_id       BOOLEAN := FALSE,
   reset_repair_value             BOOLEAN := FALSE,
   reset_overhaul_value           BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'CONDITION_CODE', condition_code_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'CONDITION_CODE', Fnd_Session_API.Get_Language) || ': ' || condition_code_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   condition_code_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(condition_code_),
                            Formatted_Key___(condition_code_));
   Error_SYS.Fnd_Too_Many_Rows(Condition_Code_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   condition_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(condition_code_),
                            Formatted_Key___(condition_code_));
   Error_SYS.Fnd_Record_Not_Exist(Condition_Code_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN condition_code_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.condition_code),
                            Formatted_Key___(rec_.condition_code));
   Error_SYS.Fnd_Record_Exist(Condition_Code_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN condition_code_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Condition_Code_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Condition_Code_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN condition_code_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.condition_code),
                            Formatted_Key___(rec_.condition_code));
   Error_SYS.Fnd_Record_Modified(Condition_Code_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   condition_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(condition_code_),
                            Formatted_Key___(condition_code_));
   Error_SYS.Fnd_Record_Locked(Condition_Code_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   condition_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(condition_code_),
                            Formatted_Key___(condition_code_));
   Error_SYS.Fnd_Record_Removed(Condition_Code_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN condition_code_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        condition_code_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  condition_code_tab
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
            FROM  condition_code_tab
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
   condition_code_ IN VARCHAR2) RETURN condition_code_tab%ROWTYPE
IS
   rec_        condition_code_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  condition_code_tab
         WHERE condition_code = condition_code_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(condition_code_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(condition_code_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   condition_code_ IN VARCHAR2) RETURN condition_code_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        condition_code_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  condition_code_tab
         WHERE condition_code = condition_code_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(condition_code_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(condition_code_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(condition_code_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN condition_code_tab%ROWTYPE
IS
   lu_rec_ condition_code_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  condition_code_tab
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
   condition_code_ IN VARCHAR2 ) RETURN condition_code_tab%ROWTYPE
IS
   lu_rec_ condition_code_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   condition_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Check_Exist___');
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
      FROM  condition_code_tab
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
   condition_code_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT condition_code_tab%ROWTYPE,
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
      WHEN ('CONDITION_CODE') THEN
         newrec_.condition_code := value_;
         indrec_.condition_code := TRUE;
      WHEN ('DESCRIPTION') THEN
         newrec_.description := value_;
         indrec_.description := TRUE;
      WHEN ('NOTE_TEXT') THEN
         newrec_.note_text := value_;
         indrec_.note_text := TRUE;
      WHEN ('CONDITION_CODE_TYPE') THEN
         newrec_.condition_code_type := Condition_Code_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.condition_code_type IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.condition_code_type := TRUE;
      WHEN ('CONDITION_CODE_TYPE_DB') THEN
         newrec_.condition_code_type := value_;
         indrec_.condition_code_type := TRUE;
      WHEN ('DEFAULT_AVAIL_CONTROL_ID') THEN
         newrec_.default_avail_control_id := value_;
         indrec_.default_avail_control_id := TRUE;
      WHEN ('RESET_REPAIR_VALUE') THEN
         newrec_.reset_repair_value := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.reset_repair_value IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.reset_repair_value := TRUE;
      WHEN ('RESET_REPAIR_VALUE_DB') THEN
         newrec_.reset_repair_value := value_;
         indrec_.reset_repair_value := TRUE;
      WHEN ('RESET_OVERHAUL_VALUE') THEN
         newrec_.reset_overhaul_value := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.reset_overhaul_value IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.reset_overhaul_value := TRUE;
      WHEN ('RESET_OVERHAUL_VALUE_DB') THEN
         newrec_.reset_overhaul_value := value_;
         indrec_.reset_overhaul_value := TRUE;
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
   rec_ IN condition_code_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.condition_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
   END IF;
   IF (rec_.description IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (rec_.note_text IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (rec_.condition_code_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONDITION_CODE_TYPE', Condition_Code_Type_API.Decode(rec_.condition_code_type), attr_);
      Client_SYS.Add_To_Attr('CONDITION_CODE_TYPE_DB', rec_.condition_code_type, attr_);
   END IF;
   IF (rec_.default_avail_control_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEFAULT_AVAIL_CONTROL_ID', rec_.default_avail_control_id, attr_);
   END IF;
   IF (rec_.reset_repair_value IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RESET_REPAIR_VALUE', Fnd_Boolean_API.Decode(rec_.reset_repair_value), attr_);
      Client_SYS.Add_To_Attr('RESET_REPAIR_VALUE_DB', rec_.reset_repair_value, attr_);
   END IF;
   IF (rec_.reset_overhaul_value IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RESET_OVERHAUL_VALUE', Fnd_Boolean_API.Decode(rec_.reset_overhaul_value), attr_);
      Client_SYS.Add_To_Attr('RESET_OVERHAUL_VALUE_DB', rec_.reset_overhaul_value, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN condition_code_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.condition_code) THEN
      Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
   END IF;
   IF (indrec_.description) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (indrec_.note_text) THEN
      Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   END IF;
   IF (indrec_.condition_code_type) THEN
      Client_SYS.Add_To_Attr('CONDITION_CODE_TYPE', Condition_Code_Type_API.Decode(rec_.condition_code_type), attr_);
      Client_SYS.Add_To_Attr('CONDITION_CODE_TYPE_DB', rec_.condition_code_type, attr_);
   END IF;
   IF (indrec_.default_avail_control_id) THEN
      Client_SYS.Add_To_Attr('DEFAULT_AVAIL_CONTROL_ID', rec_.default_avail_control_id, attr_);
   END IF;
   IF (indrec_.reset_repair_value) THEN
      Client_SYS.Add_To_Attr('RESET_REPAIR_VALUE', Fnd_Boolean_API.Decode(rec_.reset_repair_value), attr_);
      Client_SYS.Add_To_Attr('RESET_REPAIR_VALUE_DB', rec_.reset_repair_value, attr_);
   END IF;
   IF (indrec_.reset_overhaul_value) THEN
      Client_SYS.Add_To_Attr('RESET_OVERHAUL_VALUE', Fnd_Boolean_API.Decode(rec_.reset_overhaul_value), attr_);
      Client_SYS.Add_To_Attr('RESET_OVERHAUL_VALUE_DB', rec_.reset_overhaul_value, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN condition_code_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE', rec_.condition_code, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   Client_SYS.Add_To_Attr('NOTE_TEXT', rec_.note_text, attr_);
   Client_SYS.Add_To_Attr('CONDITION_CODE_TYPE', rec_.condition_code_type, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_AVAIL_CONTROL_ID', rec_.default_avail_control_id, attr_);
   Client_SYS.Add_To_Attr('RESET_REPAIR_VALUE', rec_.reset_repair_value, attr_);
   Client_SYS.Add_To_Attr('RESET_OVERHAUL_VALUE', rec_.reset_overhaul_value, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN condition_code_tab%ROWTYPE
IS
   rec_ condition_code_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.condition_code                 := public_.condition_code;
   rec_.description                    := public_.description;
   rec_.note_text                      := public_.note_text;
   rec_.condition_code_type            := public_.condition_code_type;
   rec_.default_avail_control_id       := public_.default_avail_control_id;
   rec_.reset_repair_value             := public_.reset_repair_value;
   rec_.reset_overhaul_value           := public_.reset_overhaul_value;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN condition_code_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.condition_code                 := rec_.condition_code;
   public_.description                    := rec_.description;
   public_.note_text                      := rec_.note_text;
   public_.condition_code_type            := rec_.condition_code_type;
   public_.default_avail_control_id       := rec_.default_avail_control_id;
   public_.reset_repair_value             := rec_.reset_repair_value;
   public_.reset_overhaul_value           := rec_.reset_overhaul_value;
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
   rec_ IN condition_code_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.condition_code := rec_.condition_code IS NOT NULL;
   indrec_.description := rec_.description IS NOT NULL;
   indrec_.note_text := rec_.note_text IS NOT NULL;
   indrec_.condition_code_type := rec_.condition_code_type IS NOT NULL;
   indrec_.default_avail_control_id := rec_.default_avail_control_id IS NOT NULL;
   indrec_.reset_repair_value := rec_.reset_repair_value IS NOT NULL;
   indrec_.reset_overhaul_value := rec_.reset_overhaul_value IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN condition_code_tab%ROWTYPE,
   newrec_ IN condition_code_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.condition_code := Validate_SYS.Is_Changed(oldrec_.condition_code, newrec_.condition_code);
   indrec_.description := Validate_SYS.Is_Changed(oldrec_.description, newrec_.description);
   indrec_.note_text := Validate_SYS.Is_Changed(oldrec_.note_text, newrec_.note_text);
   indrec_.condition_code_type := Validate_SYS.Is_Changed(oldrec_.condition_code_type, newrec_.condition_code_type);
   indrec_.default_avail_control_id := Validate_SYS.Is_Changed(oldrec_.default_avail_control_id, newrec_.default_avail_control_id);
   indrec_.reset_repair_value := Validate_SYS.Is_Changed(oldrec_.reset_repair_value, newrec_.reset_repair_value);
   indrec_.reset_overhaul_value := Validate_SYS.Is_Changed(oldrec_.reset_overhaul_value, newrec_.reset_overhaul_value);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     condition_code_tab%ROWTYPE,
   newrec_ IN OUT condition_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.condition_code IS NOT NULL
       AND indrec_.condition_code
       AND Validate_SYS.Is_Changed(oldrec_.condition_code, newrec_.condition_code)) THEN
      Error_SYS.Check_Upper(lu_name_, 'CONDITION_CODE', newrec_.condition_code);
   END IF;
   IF (newrec_.default_avail_control_id IS NOT NULL
       AND indrec_.default_avail_control_id
       AND Validate_SYS.Is_Changed(oldrec_.default_avail_control_id, newrec_.default_avail_control_id)) THEN
      Error_SYS.Check_Upper(lu_name_, 'DEFAULT_AVAIL_CONTROL_ID', newrec_.default_avail_control_id);
   END IF;
   IF (newrec_.condition_code_type IS NOT NULL)
   AND (indrec_.condition_code_type)
   AND (Validate_SYS.Is_Changed(oldrec_.condition_code_type, newrec_.condition_code_type)) THEN
      Condition_Code_Type_API.Exist_Db(newrec_.condition_code_type);
   END IF;
   IF (newrec_.reset_repair_value IS NOT NULL)
   AND (indrec_.reset_repair_value)
   AND (Validate_SYS.Is_Changed(oldrec_.reset_repair_value, newrec_.reset_repair_value)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.reset_repair_value);
   END IF;
   IF (newrec_.reset_overhaul_value IS NOT NULL)
   AND (indrec_.reset_overhaul_value)
   AND (Validate_SYS.Is_Changed(oldrec_.reset_overhaul_value, newrec_.reset_overhaul_value)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.reset_overhaul_value);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'CONDITION_CODE', newrec_.condition_code);
   Error_SYS.Check_Not_Null(lu_name_, 'DESCRIPTION', newrec_.description);
   Error_SYS.Check_Not_Null(lu_name_, 'CONDITION_CODE_TYPE', newrec_.condition_code_type);
   Error_SYS.Check_Not_Null(lu_name_, 'RESET_REPAIR_VALUE', newrec_.reset_repair_value);
   Error_SYS.Check_Not_Null(lu_name_, 'RESET_OVERHAUL_VALUE', newrec_.reset_overhaul_value);
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
   newrec_ IN OUT condition_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ condition_code_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT condition_code_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO condition_code_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('PARTCA', 'ConditionCode',
      newrec_.condition_code,
      NULL, newrec_.description);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CONDITION_CODE_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CONDITION_CODE_PK') THEN
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
   newrec_ IN OUT condition_code_tab%ROWTYPE )
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
   newrec_ IN OUT condition_code_tab%ROWTYPE )
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
   oldrec_ IN     condition_code_tab%ROWTYPE,
   newrec_ IN OUT condition_code_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'CONDITION_CODE', indrec_.condition_code);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     condition_code_tab%ROWTYPE,
   newrec_     IN OUT condition_code_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE condition_code_tab
         SET ROW = newrec_
         WHERE condition_code = newrec_.condition_code;
   ELSE
      UPDATE condition_code_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('PARTCA', 'ConditionCode',
      newrec_.condition_code,
      NULL, newrec_.description, oldrec_.description);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CONDITION_CODE_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Condition_Code_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CONDITION_CODE_PK') THEN
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
   newrec_         IN OUT condition_code_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     condition_code_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.condition_code);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.condition_code);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN condition_code_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.condition_code||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN condition_code_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.condition_code||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  condition_code_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  condition_code_tab
         WHERE condition_code = remrec_.condition_code;
   END IF;
   Basic_Data_Translation_API.Remove_Basic_Data_Translation('PARTCA', 'ConditionCode',
      remrec_.condition_code);
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN condition_code_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT condition_code_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     condition_code_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.condition_code);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.condition_code);
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
   dummy_ condition_code_tab%ROWTYPE;
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
   newrec_   condition_code_tab%ROWTYPE;
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
   oldrec_   condition_code_tab%ROWTYPE;
   newrec_   condition_code_tab%ROWTYPE;
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
   remrec_ condition_code_tab%ROWTYPE;
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
   rowkey_ IN VARCHAR2 ) RETURN condition_code_tab%ROWTYPE
IS
   rec_ condition_code_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT condition_code
      INTO  rec_.condition_code
      FROM  condition_code_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.condition_code, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   condition_code_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(condition_code_)) THEN
      Raise_Record_Not_Exist___(condition_code_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   condition_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(condition_code_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   condition_code_ condition_code_tab.condition_code%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT condition_code
   INTO  condition_code_
   FROM  condition_code_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(condition_code_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ condition_code_tab.description%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('PARTCA', 'ConditionCode',
              condition_code), description), 1, 35)
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Description');
END Get_Description;


-- Get_Note_Text
--   Fetches the NoteText attribute for a record.
@UncheckedAccess
FUNCTION Get_Note_Text (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ condition_code_tab.note_text%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT note_text
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Note_Text');
END Get_Note_Text;


-- Get_Condition_Code_Type
--   Fetches the ConditionCodeType attribute for a record.
@UncheckedAccess
FUNCTION Get_Condition_Code_Type (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ condition_code_tab.condition_code_type%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT condition_code_type
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN Condition_Code_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Condition_Code_Type');
END Get_Condition_Code_Type;


-- Get_Condition_Code_Type_Db
--   Fetches the DB value of ConditionCodeType attribute for a record.
@UncheckedAccess
FUNCTION Get_Condition_Code_Type_Db (
   condition_code_ IN VARCHAR2 ) RETURN condition_code_tab.condition_code_type%TYPE
IS
   temp_ condition_code_tab.condition_code_type%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT condition_code_type
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Condition_Code_Type_Db');
END Get_Condition_Code_Type_Db;


-- Get_Default_Avail_Control_Id
--   Fetches the DefaultAvailControlId attribute for a record.
@UncheckedAccess
FUNCTION Get_Default_Avail_Control_Id (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ condition_code_tab.default_avail_control_id%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT default_avail_control_id
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Default_Avail_Control_Id');
END Get_Default_Avail_Control_Id;


-- Get_Reset_Repair_Value
--   Fetches the ResetRepairValue attribute for a record.
@UncheckedAccess
FUNCTION Get_Reset_Repair_Value (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ condition_code_tab.reset_repair_value%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT reset_repair_value
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Reset_Repair_Value');
END Get_Reset_Repair_Value;


-- Get_Reset_Repair_Value_Db
--   Fetches the DB value of ResetRepairValue attribute for a record.
@UncheckedAccess
FUNCTION Get_Reset_Repair_Value_Db (
   condition_code_ IN VARCHAR2 ) RETURN condition_code_tab.reset_repair_value%TYPE
IS
   temp_ condition_code_tab.reset_repair_value%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT reset_repair_value
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Reset_Repair_Value_Db');
END Get_Reset_Repair_Value_Db;


-- Get_Reset_Overhaul_Value
--   Fetches the ResetOverhaulValue attribute for a record.
@UncheckedAccess
FUNCTION Get_Reset_Overhaul_Value (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ condition_code_tab.reset_overhaul_value%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT reset_overhaul_value
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Reset_Overhaul_Value');
END Get_Reset_Overhaul_Value;


-- Get_Reset_Overhaul_Value_Db
--   Fetches the DB value of ResetOverhaulValue attribute for a record.
@UncheckedAccess
FUNCTION Get_Reset_Overhaul_Value_Db (
   condition_code_ IN VARCHAR2 ) RETURN condition_code_tab.reset_overhaul_value%TYPE
IS
   temp_ condition_code_tab.reset_overhaul_value%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT reset_overhaul_value
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Reset_Overhaul_Value_Db');
END Get_Reset_Overhaul_Value_Db;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ condition_code_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.condition_code);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   condition_code_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT condition_code, rowid, rowversion, rowkey,
           substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('PARTCA', 'ConditionCode',
              condition_code), description), 1, 35), 
          note_text, 
          condition_code_type, 
          default_avail_control_id, 
          reset_repair_value, 
          reset_overhaul_value
      INTO  temp_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   condition_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rowkey_ condition_code_tab.rowkey%TYPE;
BEGIN
   IF (condition_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  condition_code_tab
      WHERE condition_code = condition_code_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(condition_code_, 'Get_Objkey');
END Get_Objkey;



-------------------- COMPLEX STRUCTURE METHODS ------------------------------------

-------------------- FOUNDATION1 METHODS ------------------------------------


-- Init
--   Framework method that initializes this package.
@UncheckedAccess
PROCEDURE Init
IS
BEGIN
   NULL;
END Init;