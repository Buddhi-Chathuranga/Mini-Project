-----------------------------------------------------------------------------
--
--  Logical unit: BcLogInfo
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
--  (rco_no                         BC_LOG_INFO_TAB.rco_no%TYPE,
--   log_info_id                    BC_LOG_INFO_TAB.log_info_id%TYPE);

TYPE Public_Rec IS RECORD
  (rco_no                         BC_LOG_INFO_TAB.rco_no%TYPE,
   log_info_id                    BC_LOG_INFO_TAB.log_info_id%TYPE,
   "rowid"                        rowid,
   rowversion                     BC_LOG_INFO_TAB.rowversion%TYPE,
   rowkey                         BC_LOG_INFO_TAB.rowkey%TYPE,
   rco_line                       BC_LOG_INFO_TAB.rco_line%TYPE,
   date_created                   BC_LOG_INFO_TAB.date_created%TYPE,
   reported_by                    BC_LOG_INFO_TAB.reported_by%TYPE,
   part_number                    BC_LOG_INFO_TAB.part_number%TYPE,
   contract                       BC_LOG_INFO_TAB.contract%TYPE,
   notes                          BC_LOG_INFO_TAB.notes%TYPE,
   enter_by                       BC_LOG_INFO_TAB.enter_by%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (rco_no                         BOOLEAN := FALSE,
   log_info_id                    BOOLEAN := FALSE,
   rco_line                       BOOLEAN := FALSE,
   date_created                   BOOLEAN := FALSE,
   reported_by                    BOOLEAN := FALSE,
   part_number                    BOOLEAN := FALSE,
   contract                       BOOLEAN := FALSE,
   notes                          BOOLEAN := FALSE,
   enter_by                       BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'RCO_NO', rco_no_);
   Message_SYS.Add_Attribute(msg_, 'LOG_INFO_ID', log_info_id_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'RCO_NO', Fnd_Session_API.Get_Language) || ': ' || rco_no_ || ', ' ||
                                    Language_SYS.Translate_Item_Prompt_(lu_name_, 'LOG_INFO_ID', Fnd_Session_API.Get_Language) || ': ' || log_info_id_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, log_info_id_),
                            Formatted_Key___(rco_no_, log_info_id_));
   Error_SYS.Fnd_Too_Many_Rows(Bc_Log_Info_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, log_info_id_),
                            Formatted_Key___(rco_no_, log_info_id_));
   Error_SYS.Fnd_Record_Not_Exist(Bc_Log_Info_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN bc_log_info_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.rco_no, rec_.log_info_id),
                            Formatted_Key___(rec_.rco_no, rec_.log_info_id));
   Error_SYS.Fnd_Record_Exist(Bc_Log_Info_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN bc_log_info_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Bc_Log_Info_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Bc_Log_Info_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN bc_log_info_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.rco_no, rec_.log_info_id),
                            Formatted_Key___(rec_.rco_no, rec_.log_info_id));
   Error_SYS.Fnd_Record_Modified(Bc_Log_Info_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, log_info_id_),
                            Formatted_Key___(rco_no_, log_info_id_));
   Error_SYS.Fnd_Record_Locked(Bc_Log_Info_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rco_no_, log_info_id_),
                            Formatted_Key___(rco_no_, log_info_id_));
   Error_SYS.Fnd_Record_Removed(Bc_Log_Info_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN bc_log_info_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_log_info_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  bc_log_info_tab
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
            FROM  bc_log_info_tab
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
   log_info_id_ IN NUMBER) RETURN bc_log_info_tab%ROWTYPE
IS
   rec_        bc_log_info_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_log_info_tab
         WHERE rco_no = rco_no_
         AND   log_info_id = log_info_id_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(rco_no_, log_info_id_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER) RETURN bc_log_info_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        bc_log_info_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  bc_log_info_tab
         WHERE rco_no = rco_no_
         AND   log_info_id = log_info_id_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(rco_no_, log_info_id_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(rco_no_, log_info_id_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN bc_log_info_tab%ROWTYPE
IS
   lu_rec_ bc_log_info_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_log_info_tab
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
   log_info_id_ IN NUMBER ) RETURN bc_log_info_tab%ROWTYPE
IS
   lu_rec_ bc_log_info_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Check_Exist___');
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
      FROM  bc_log_info_tab
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
   log_info_id_ IN NUMBER )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT bc_log_info_tab%ROWTYPE,
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
      WHEN ('LOG_INFO_ID') THEN
         newrec_.log_info_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.log_info_id := TRUE;
      WHEN ('RCO_LINE') THEN
         newrec_.rco_line := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.rco_line := TRUE;
      WHEN ('DATE_CREATED') THEN
         newrec_.date_created := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.date_created := TRUE;
      WHEN ('REPORTED_BY') THEN
         newrec_.reported_by := value_;
         indrec_.reported_by := TRUE;
      WHEN ('PART_NUMBER') THEN
         newrec_.part_number := value_;
         indrec_.part_number := TRUE;
      WHEN ('CONTRACT') THEN
         newrec_.contract := value_;
         indrec_.contract := TRUE;
      WHEN ('NOTES') THEN
         newrec_.notes := value_;
         indrec_.notes := TRUE;
      WHEN ('ENTER_BY') THEN
         newrec_.enter_by := value_;
         indrec_.enter_by := TRUE;
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
   rec_ IN bc_log_info_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.rco_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   END IF;
   IF (rec_.log_info_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LOG_INFO_ID', rec_.log_info_id, attr_);
   END IF;
   IF (rec_.rco_line IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('RCO_LINE', rec_.rco_line, attr_);
   END IF;
   IF (rec_.date_created IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DATE_CREATED', rec_.date_created, attr_);
   END IF;
   IF (rec_.reported_by IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('REPORTED_BY', rec_.reported_by, attr_);
   END IF;
   IF (rec_.part_number IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PART_NUMBER', rec_.part_number, attr_);
   END IF;
   IF (rec_.contract IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (rec_.notes IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NOTES', rec_.notes, attr_);
   END IF;
   IF (rec_.enter_by IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ENTER_BY', rec_.enter_by, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN bc_log_info_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.rco_no) THEN
      Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   END IF;
   IF (indrec_.log_info_id) THEN
      Client_SYS.Add_To_Attr('LOG_INFO_ID', rec_.log_info_id, attr_);
   END IF;
   IF (indrec_.rco_line) THEN
      Client_SYS.Add_To_Attr('RCO_LINE', rec_.rco_line, attr_);
   END IF;
   IF (indrec_.date_created) THEN
      Client_SYS.Add_To_Attr('DATE_CREATED', rec_.date_created, attr_);
   END IF;
   IF (indrec_.reported_by) THEN
      Client_SYS.Add_To_Attr('REPORTED_BY', rec_.reported_by, attr_);
   END IF;
   IF (indrec_.part_number) THEN
      Client_SYS.Add_To_Attr('PART_NUMBER', rec_.part_number, attr_);
   END IF;
   IF (indrec_.contract) THEN
      Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   END IF;
   IF (indrec_.notes) THEN
      Client_SYS.Add_To_Attr('NOTES', rec_.notes, attr_);
   END IF;
   IF (indrec_.enter_by) THEN
      Client_SYS.Add_To_Attr('ENTER_BY', rec_.enter_by, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN bc_log_info_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('RCO_NO', rec_.rco_no, attr_);
   Client_SYS.Add_To_Attr('LOG_INFO_ID', rec_.log_info_id, attr_);
   Client_SYS.Add_To_Attr('RCO_LINE', rec_.rco_line, attr_);
   Client_SYS.Add_To_Attr('DATE_CREATED', rec_.date_created, attr_);
   Client_SYS.Add_To_Attr('REPORTED_BY', rec_.reported_by, attr_);
   Client_SYS.Add_To_Attr('PART_NUMBER', rec_.part_number, attr_);
   Client_SYS.Add_To_Attr('CONTRACT', rec_.contract, attr_);
   Client_SYS.Add_To_Attr('NOTES', rec_.notes, attr_);
   Client_SYS.Add_To_Attr('ENTER_BY', rec_.enter_by, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN bc_log_info_tab%ROWTYPE
IS
   rec_ bc_log_info_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.rco_no                         := public_.rco_no;
   rec_.log_info_id                    := public_.log_info_id;
   rec_.rco_line                       := public_.rco_line;
   rec_.date_created                   := public_.date_created;
   rec_.reported_by                    := public_.reported_by;
   rec_.part_number                    := public_.part_number;
   rec_.contract                       := public_.contract;
   rec_.notes                          := public_.notes;
   rec_.enter_by                       := public_.enter_by;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN bc_log_info_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.rco_no                         := rec_.rco_no;
   public_.log_info_id                    := rec_.log_info_id;
   public_.rco_line                       := rec_.rco_line;
   public_.date_created                   := rec_.date_created;
   public_.reported_by                    := rec_.reported_by;
   public_.part_number                    := rec_.part_number;
   public_.contract                       := rec_.contract;
   public_.notes                          := rec_.notes;
   public_.enter_by                       := rec_.enter_by;
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
   rec_ IN bc_log_info_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.rco_no := rec_.rco_no IS NOT NULL;
   indrec_.log_info_id := rec_.log_info_id IS NOT NULL;
   indrec_.rco_line := rec_.rco_line IS NOT NULL;
   indrec_.date_created := rec_.date_created IS NOT NULL;
   indrec_.reported_by := rec_.reported_by IS NOT NULL;
   indrec_.part_number := rec_.part_number IS NOT NULL;
   indrec_.contract := rec_.contract IS NOT NULL;
   indrec_.notes := rec_.notes IS NOT NULL;
   indrec_.enter_by := rec_.enter_by IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN bc_log_info_tab%ROWTYPE,
   newrec_ IN bc_log_info_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.rco_no := Validate_SYS.Is_Changed(oldrec_.rco_no, newrec_.rco_no);
   indrec_.log_info_id := Validate_SYS.Is_Changed(oldrec_.log_info_id, newrec_.log_info_id);
   indrec_.rco_line := Validate_SYS.Is_Changed(oldrec_.rco_line, newrec_.rco_line);
   indrec_.date_created := Validate_SYS.Is_Changed(oldrec_.date_created, newrec_.date_created);
   indrec_.reported_by := Validate_SYS.Is_Changed(oldrec_.reported_by, newrec_.reported_by);
   indrec_.part_number := Validate_SYS.Is_Changed(oldrec_.part_number, newrec_.part_number);
   indrec_.contract := Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract);
   indrec_.notes := Validate_SYS.Is_Changed(oldrec_.notes, newrec_.notes);
   indrec_.enter_by := Validate_SYS.Is_Changed(oldrec_.enter_by, newrec_.enter_by);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     bc_log_info_tab%ROWTYPE,
   newrec_ IN OUT bc_log_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.rco_no IS NOT NULL)
   AND (indrec_.rco_no)
   AND (Validate_SYS.Is_Changed(oldrec_.rco_no, newrec_.rco_no)) THEN
      Bc_Repair_Center_Order_API.Exist(newrec_.rco_no);
   END IF;
   IF (newrec_.reported_by IS NOT NULL)
   AND (indrec_.reported_by)
   AND (Validate_SYS.Is_Changed(oldrec_.reported_by, newrec_.reported_by)) THEN
      Fnd_User_API.Exist(newrec_.reported_by);
   END IF;
   IF (newrec_.contract IS NOT NULL AND newrec_.part_number IS NOT NULL)
   AND (indrec_.contract OR indrec_.part_number)
   AND (Validate_SYS.Is_Changed(oldrec_.contract, newrec_.contract)
     OR Validate_SYS.Is_Changed(oldrec_.part_number, newrec_.part_number)) THEN
      Inventory_Part_API.Exist(newrec_.contract, newrec_.part_number);
   END IF;
   IF (newrec_.rco_no IS NOT NULL AND newrec_.rco_line IS NOT NULL)
   AND (indrec_.rco_no OR indrec_.rco_line)
   AND (Validate_SYS.Is_Changed(oldrec_.rco_no, newrec_.rco_no)
     OR Validate_SYS.Is_Changed(oldrec_.rco_line, newrec_.rco_line)) THEN
      Bc_Repair_Line_API.Exist(newrec_.rco_no, newrec_.rco_line);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'RCO_NO', newrec_.rco_no);
   Error_SYS.Check_Not_Null(lu_name_, 'RCO_LINE', newrec_.rco_line);
   Error_SYS.Check_Not_Null(lu_name_, 'DATE_CREATED', newrec_.date_created);
   Error_SYS.Check_Not_Null(lu_name_, 'REPORTED_BY', newrec_.reported_by);
   Error_SYS.Check_Not_Null(lu_name_, 'PART_NUMBER', newrec_.part_number);
   Error_SYS.Check_Not_Null(lu_name_, 'CONTRACT', newrec_.contract);
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
   newrec_ IN OUT bc_log_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ bc_log_info_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT bc_log_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO bc_log_info_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'BC_LOG_INFO_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_LOG_INFO_PK') THEN
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
   newrec_ IN OUT bc_log_info_tab%ROWTYPE )
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
   newrec_ IN OUT bc_log_info_tab%ROWTYPE )
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
   oldrec_ IN     bc_log_info_tab%ROWTYPE,
   newrec_ IN OUT bc_log_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'RCO_NO', indrec_.rco_no);
   Validate_SYS.Item_Update(lu_name_, 'LOG_INFO_ID', indrec_.log_info_id);
   Validate_SYS.Item_Update(lu_name_, 'RCO_LINE', indrec_.rco_line);
   Validate_SYS.Item_Update(lu_name_, 'DATE_CREATED', indrec_.date_created);
   Validate_SYS.Item_Update(lu_name_, 'REPORTED_BY', indrec_.reported_by);
   Validate_SYS.Item_Update(lu_name_, 'PART_NUMBER', indrec_.part_number);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     bc_log_info_tab%ROWTYPE,
   newrec_     IN OUT bc_log_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE bc_log_info_tab
         SET ROW = newrec_
         WHERE rco_no = newrec_.rco_no
         AND   log_info_id = newrec_.log_info_id;
   ELSE
      UPDATE bc_log_info_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'BC_LOG_INFO_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Bc_Log_Info_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'BC_LOG_INFO_PK') THEN
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
   newrec_         IN OUT bc_log_info_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     bc_log_info_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.rco_no, newrec_.log_info_id);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.rco_no, newrec_.log_info_id);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN bc_log_info_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.rco_no||'^'||remrec_.log_info_id||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN bc_log_info_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.rco_no||'^'||remrec_.log_info_id||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  bc_log_info_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  bc_log_info_tab
         WHERE rco_no = remrec_.rco_no
         AND   log_info_id = remrec_.log_info_id;
   END IF;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN bc_log_info_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT bc_log_info_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     bc_log_info_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.rco_no, remrec_.log_info_id);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.rco_no, remrec_.log_info_id);
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
   dummy_ bc_log_info_tab%ROWTYPE;
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
   newrec_   bc_log_info_tab%ROWTYPE;
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
   oldrec_   bc_log_info_tab%ROWTYPE;
   newrec_   bc_log_info_tab%ROWTYPE;
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
   remrec_ bc_log_info_tab%ROWTYPE;
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
   rowkey_ IN VARCHAR2 ) RETURN bc_log_info_tab%ROWTYPE
IS
   rec_ bc_log_info_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rco_no, log_info_id
      INTO  rec_.rco_no, rec_.log_info_id
      FROM  bc_log_info_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.rco_no, rec_.log_info_id, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER )
IS
BEGIN
   IF (NOT Check_Exist___(rco_no_, log_info_id_)) THEN
      Raise_Record_Not_Exist___(rco_no_, log_info_id_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(rco_no_, log_info_id_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   rco_no_ bc_log_info_tab.rco_no%TYPE;
   log_info_id_ bc_log_info_tab.log_info_id%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT rco_no, log_info_id
   INTO  rco_no_, log_info_id_
   FROM  bc_log_info_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(rco_no_, log_info_id_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Rco_Line
--   Fetches the RcoLine attribute for a record.
@UncheckedAccess
FUNCTION Get_Rco_Line (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN NUMBER
IS
   temp_ bc_log_info_tab.rco_line%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rco_line
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Rco_Line');
END Get_Rco_Line;


-- Get_Date_Created
--   Fetches the DateCreated attribute for a record.
@UncheckedAccess
FUNCTION Get_Date_Created (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN DATE
IS
   temp_ bc_log_info_tab.date_created%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT date_created
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Date_Created');
END Get_Date_Created;


-- Get_Reported_By
--   Fetches the ReportedBy attribute for a record.
@UncheckedAccess
FUNCTION Get_Reported_By (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_log_info_tab.reported_by%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT reported_by
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Reported_By');
END Get_Reported_By;


-- Get_Part_Number
--   Fetches the PartNumber attribute for a record.
@UncheckedAccess
FUNCTION Get_Part_Number (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_log_info_tab.part_number%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT part_number
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Part_Number');
END Get_Part_Number;


-- Get_Contract
--   Fetches the Contract attribute for a record.
@UncheckedAccess
FUNCTION Get_Contract (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_log_info_tab.contract%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT contract
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Contract');
END Get_Contract;


-- Get_Notes
--   Fetches the Notes attribute for a record.
@UncheckedAccess
FUNCTION Get_Notes (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_log_info_tab.notes%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT notes
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Notes');
END Get_Notes;


-- Get_Enter_By
--   Fetches the EnterBy attribute for a record.
@UncheckedAccess
FUNCTION Get_Enter_By (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2
IS
   temp_ bc_log_info_tab.enter_by%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT enter_by
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Enter_By');
END Get_Enter_By;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ bc_log_info_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.rco_no, rowrec_.log_info_id);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rco_no, log_info_id, rowid, rowversion, rowkey,
          rco_line, 
          date_created, 
          reported_by, 
          part_number, 
          contract, 
          notes, 
          enter_by
      INTO  temp_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   rco_no_ IN NUMBER,
   log_info_id_ IN NUMBER ) RETURN VARCHAR2
IS
   rowkey_ bc_log_info_tab.rowkey%TYPE;
BEGIN
   IF (rco_no_ IS NULL OR log_info_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  bc_log_info_tab
      WHERE rco_no = rco_no_
      AND   log_info_id = log_info_id_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rco_no_, log_info_id_, 'Get_Objkey');
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