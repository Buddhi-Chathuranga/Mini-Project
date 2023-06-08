-----------------------------------------------------------------------------
--
--  Logical unit: BcRepairLineAction
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
--  (repair_line_action             BC_REPAIR_LINE_ACTION_TAB.repair_line_action%TYPE);

TYPE Public_Rec IS RECORD
  (repair_line_action             BC_REPAIR_LINE_ACTION_TAB.repair_line_action%TYPE,
   "rowid"                        rowid,
   rowversion                     BC_REPAIR_LINE_ACTION_TAB.rowversion%TYPE,
   rowkey                         BC_REPAIR_LINE_ACTION_TAB.rowkey%TYPE,
   contract                       BC_REPAIR_LINE_ACTION_TAB.contract%TYPE,
   repair_line_action_desc        BC_REPAIR_LINE_ACTION_TAB.repair_line_action_desc%TYPE,
   action_type                    BC_REPAIR_LINE_ACTION_TAB.action_type%TYPE,
   days_before_overdue            BC_REPAIR_LINE_ACTION_TAB.days_before_overdue%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (repair_line_action             BOOLEAN := FALSE,
   contract                       BOOLEAN := FALSE,
   repair_line_action_desc        BOOLEAN := FALSE,
   action_type                    BOOLEAN := FALSE,
   days_before_overdue            BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   repair_line_action_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'REPAIR_LINE_ACTION', repair_line_action_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   repair_line_action_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'REPAIR_LINE_ACTION', Fnd_Session_API.Get_Language) || ': ' || repair_line_action_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   repair_line_action_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(repair_line_action_),
                            Formatted_Key___(repair_line_action_));
   Error_SYS.Fnd_Too_Many_Rows(Bc_Repair_Line_Action_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   repair_line_action_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(repair_line_action_),
                            Formatted_Key___(repair_line_action_));
   Error_SYS.Fnd_Record_Not_Exist(Bc_Repair_Line_Action_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN bc_repair_line_action_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.repair_line_action),
                            Formatted_Key___(rec_.repair_line_action));
   Error_SYS.Fnd_Record_Exist(Bc_Repair_Line_Action_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN bc_repair_line_action_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Bc_Repair_Line_Action_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Bc_Repair_Line_Action_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN bc_repair_line_action_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.repair_line_action),
                            Formatted_Key___(rec_.repair_line_action));
   Error_SYS.Fnd_Record_Modified(Bc_Repair_Line_Action_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   repair_line_action_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(repair_line_action_),
                            Formatted_Key___(repair_line_action_));
   Error_SYS.Fnd_Record_Locked(Bc_Repair_Line_Action_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   repair_line_action_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(repair_line_action_),
                            Formatted_Key___(repair_line_action_));
   Error_SYS.Fnd_Record_Removed(Bc_Repair_Line_Action_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN bc_repair_line_action_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_repair_line_action_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  bc_repair_line_action_tab
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
            FROM  bc_repair_line_action_tab
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
   repair_line_action_ IN VARCHAR2) RETURN bc_repair_line_action_tab%ROWTYPE
IS
   rec_        bc_repair_line_action_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_repair_line_action_tab
         WHERE repair_line_action = repair_line_action_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(repair_line_action_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(repair_line_action_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   repair_line_action_ IN VARCHAR2) RETURN bc_repair_line_action_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_repair_line_action_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_repair_line_action_tab
         WHERE repair_line_action = repair_line_action_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(repair_line_action_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(repair_line_action_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(repair_line_action_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN bc_repair_line_action_tab%ROWTYPE
IS
   lu_rec_ bc_repair_line_action_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_repair_line_action_tab
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
   repair_line_action_ IN VARCHAR2 ) RETURN bc_repair_line_action_tab%ROWTYPE
IS
   lu_rec_ bc_repair_line_action_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   repair_line_action_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Check_Exist___');
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
      FROM  bc_repair_line_action_tab
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
   repair_line_action_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT bc_repair_line_action_tab%ROWTYPE,
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
      WHEN ('REPAIR_LINE_ACTION') THEN
         newrec_.repair_line_action := value_;
         indrec_.repair_line_action := TRUE;
      WHEN ('CONTRACT') THEN
         newrec_.contract := value_;
         indrec_.contract := TRUE;
      WHEN ('REPAIR_LINE_ACTION_DESC') THEN
         newrec_.repair_line_action_desc := value_;
         indrec_.repair_line_action_desc := TRUE;
      WHEN ('ACTION_TYPE') THEN
         newrec_.action_type := Bc_Line_Action_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.action_type IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.action_type := TRUE;
      WHEN ('ACTION_TYPE_DB') THEN
         newrec_.action_type := value_;
         indrec_.action_type := TRUE;
      WHEN ('DAYS_BEFORE_OVERDUE') THEN
         newrec_.days_before_overdue := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.days_before_overdue := TRUE;
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
   rec_ IN bc_repair_line_action_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.repair_line_action IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION', rec_.repair_line_action, attr_);
   END IF;
   IF (rec_.contract IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (rec_.repair_line_action_desc IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION_DESC', rec_.repair_line_action_desc, attr_);
   END IF;
   IF (rec_.action_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ACTION_TYPE', Bc_Line_Action_Type_API.Decode(rec_.action_type), attr_);
      Client_SYS.Add_To_Attr('ACTION_TYPE_DB', rec_.action_type, attr_);
   END IF;
   IF (rec_.days_before_overdue IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DAYS_BEFORE_OVERDUE', rec_.days_before_overdue, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN bc_repair_line_action_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.repair_line_action) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION', rec_.repair_line_action, attr_);
   END IF;
   IF (indrec_.contract) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (indrec_.repair_line_action_desc) THEN
      Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION_DESC', rec_.repair_line_action_desc, attr_);
   END IF;
   IF (indrec_.action_type) THEN
      Client_SYS.Add_To_Attr('ACTION_TYPE', Bc_Line_Action_Type_API.Decode(rec_.action_type), attr_);
      Client_SYS.Add_To_Attr('ACTION_TYPE_DB', rec_.action_type, attr_);
   END IF;
   IF (indrec_.days_before_overdue) THEN
      Client_SYS.Add_To_Attr('DAYS_BEFORE_OVERDUE', rec_.days_before_overdue, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN bc_repair_line_action_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION', rec_.repair_line_action, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   Client_SYS.Add_To_Attr('REPAIR_LINE_ACTION_DESC', rec_.repair_line_action_desc, attr_);
   Client_SYS.Add_To_Attr('ACTION_TYPE', rec_.action_type, attr_);
   Client_SYS.Add_To_Attr('DAYS_BEFORE_OVERDUE', rec_.days_before_overdue, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN bc_repair_line_action_tab%ROWTYPE
IS
   rec_ bc_repair_line_action_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.repair_line_action             := public_.repair_line_action;
   rec_.contract                       := public_.contract;
   rec_.repair_line_action_desc        := public_.repair_line_action_desc;
   rec_.action_type                    := public_.action_type;
   rec_.days_before_overdue            := public_.days_before_overdue;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN bc_repair_line_action_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.repair_line_action             := rec_.repair_line_action;
   public_.contract                       := rec_.contract;
   public_.repair_line_action_desc        := rec_.repair_line_action_desc;
   public_.action_type                    := rec_.action_type;
   public_.days_before_overdue            := rec_.days_before_overdue;
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
   rec_ IN bc_repair_line_action_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.repair_line_action := rec_.repair_line_action IS NOT NULL;
   indrec_.contract := rec_.contract IS NOT NULL;
   indrec_.repair_line_action_desc := rec_.repair_line_action_desc IS NOT NULL;
   indrec_.action_type := rec_.action_type IS NOT NULL;
   indrec_.days_before_overdue := rec_.days_before_overdue IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN bc_repair_line_action_tab%ROWTYPE,
   newrec_ IN bc_repair_line_action_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.repair_line_action := Validate_SYS.Is_Changed(oldrec_.repair_line_action, newrec_.repair_line_action);
   indrec_.contract := Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract);
   indrec_.repair_line_action_desc := Validate_SYS.Is_Changed(oldrec_.repair_line_action_desc, newrec_.repair_line_action_desc);
   indrec_.action_type := Validate_SYS.Is_Changed(oldrec_.action_type, newrec_.action_type);
   indrec_.days_before_overdue := Validate_SYS.Is_Changed(oldrec_.days_before_overdue, newrec_.days_before_overdue);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     bc_repair_line_action_tab%ROWTYPE,
   newrec_ IN OUT bc_repair_line_action_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.repair_line_action IS NOT NULL
       AND indrec_.repair_line_action
       AND Validate_SYS.Is_Changed(oldrec_.repair_line_action, newrec_.repair_line_action)) THEN
      Error_SYS.Check_Upper(lu_name_, 'REPAIR_LINE_ACTION', newrec_.repair_line_action);
   END IF;
   IF (newrec_.action_type IS NOT NULL)
   AND (indrec_.action_type)
   AND (Validate_SYS.Is_Changed(oldrec_.action_type, newrec_.action_type)) THEN
      Bc_Line_Action_Type_API.Exist_Db(newrec_.action_type);
   END IF;
   IF (newrec_.contract IS NOT NULL)
   AND (indrec_.contract)
   AND (Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract)) THEN
      Site_API.Exist(newrec_.contract);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'REPAIR_LINE_ACTION', newrec_.repair_line_action);
   Error_SYS.Check_Not_Null(lu_name_, 'CONTRACT', newrec_.contract);
   Error_SYS.Check_Not_Null(lu_name_, 'ACTION_TYPE', newrec_.action_type);
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
   newrec_ IN OUT bc_repair_line_action_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ bc_repair_line_action_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT bc_repair_line_action_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO bc_repair_line_action_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'BC_REPAIR_LINE_ACTION_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_REPAIR_LINE_ACTION_PK') THEN
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
   newrec_ IN OUT bc_repair_line_action_tab%ROWTYPE )
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
   newrec_ IN OUT bc_repair_line_action_tab%ROWTYPE )
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
   oldrec_ IN     bc_repair_line_action_tab%ROWTYPE,
   newrec_ IN OUT bc_repair_line_action_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'REPAIR_LINE_ACTION', indrec_.repair_line_action);
   Validate_SYS.Item_Update(lu_name_, 'CONTRACT', indrec_.contract);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     bc_repair_line_action_tab%ROWTYPE,
   newrec_     IN OUT bc_repair_line_action_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE bc_repair_line_action_tab
         SET ROW = newrec_
         WHERE repair_line_action = newrec_.repair_line_action;
   ELSE
      UPDATE bc_repair_line_action_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'BC_REPAIR_LINE_ACTION_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Bc_Repair_Line_Action_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_REPAIR_LINE_ACTION_PK') THEN
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
   newrec_         IN OUT bc_repair_line_action_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     bc_repair_line_action_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.repair_line_action);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.repair_line_action);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN bc_repair_line_action_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.repair_line_action||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN bc_repair_line_action_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.repair_line_action||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  bc_repair_line_action_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  bc_repair_line_action_tab
         WHERE repair_line_action = remrec_.repair_line_action;
   END IF;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN bc_repair_line_action_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT bc_repair_line_action_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     bc_repair_line_action_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.repair_line_action);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.repair_line_action);
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
   dummy_ bc_repair_line_action_tab%ROWTYPE;
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
   newrec_   bc_repair_line_action_tab%ROWTYPE;
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
   oldrec_   bc_repair_line_action_tab%ROWTYPE;
   newrec_   bc_repair_line_action_tab%ROWTYPE;
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
   remrec_ bc_repair_line_action_tab%ROWTYPE;
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
   rowkey_ IN VARCHAR2 ) RETURN bc_repair_line_action_tab%ROWTYPE
IS
   rec_ bc_repair_line_action_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_line_action
      INTO  rec_.repair_line_action
      FROM  bc_repair_line_action_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.repair_line_action, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   repair_line_action_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(repair_line_action_)) THEN
      Raise_Record_Not_Exist___(repair_line_action_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   repair_line_action_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(repair_line_action_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   repair_line_action_ bc_repair_line_action_tab.repair_line_action%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT repair_line_action
   INTO  repair_line_action_
   FROM  bc_repair_line_action_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(repair_line_action_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Contract
--   Fetches the Contract attribute for a record.
@UncheckedAccess
FUNCTION Get_Contract (
   repair_line_action_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_action_tab.contract%TYPE;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract
      INTO  temp_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Contract');
END Get_Contract;


-- Get_Repair_Line_Action_Desc
--   Fetches the RepairLineActionDesc attribute for a record.
@UncheckedAccess
FUNCTION Get_Repair_Line_Action_Desc (
   repair_line_action_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_action_tab.repair_line_action_desc%TYPE;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_line_action_desc
      INTO  temp_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Repair_Line_Action_Desc');
END Get_Repair_Line_Action_Desc;


-- Get_Action_Type
--   Fetches the ActionType attribute for a record.
@UncheckedAccess
FUNCTION Get_Action_Type (
   repair_line_action_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ bc_repair_line_action_tab.action_type%TYPE;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT action_type
      INTO  temp_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN Bc_Line_Action_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Action_Type');
END Get_Action_Type;


-- Get_Action_Type_Db
--   Fetches the DB value of ActionType attribute for a record.
@UncheckedAccess
FUNCTION Get_Action_Type_Db (
   repair_line_action_ IN VARCHAR2 ) RETURN bc_repair_line_action_tab.action_type%TYPE
IS
   temp_ bc_repair_line_action_tab.action_type%TYPE;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT action_type
      INTO  temp_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Action_Type_Db');
END Get_Action_Type_Db;


-- Get_Days_Before_Overdue
--   Fetches the DaysBeforeOverdue attribute for a record.
@UncheckedAccess
FUNCTION Get_Days_Before_Overdue (
   repair_line_action_ IN VARCHAR2 ) RETURN NUMBER
IS
   temp_ bc_repair_line_action_tab.days_before_overdue%TYPE;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT days_before_overdue
      INTO  temp_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Days_Before_Overdue');
END Get_Days_Before_Overdue;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ bc_repair_line_action_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.repair_line_action);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   repair_line_action_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT repair_line_action, rowid, rowversion, rowkey,
          contract, 
          repair_line_action_desc, 
          action_type, 
          days_before_overdue
      INTO  temp_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   repair_line_action_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rowkey_ bc_repair_line_action_tab.rowkey%TYPE;
BEGIN
   IF (repair_line_action_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  bc_repair_line_action_tab
      WHERE repair_line_action = repair_line_action_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(repair_line_action_, 'Get_Objkey');
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