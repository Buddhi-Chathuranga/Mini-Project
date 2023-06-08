-----------------------------------------------------------------------------
--
--  Logical unit: FndUser Repl
--  Component:    FNDBAS
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
--  (identity                       FND_USER_TAB.identity%TYPE);

TYPE Public_Rec IS RECORD
  (identity                       FND_USER_TAB.identity%TYPE,
   "rowid"                        rowid,
   rowversion                     FND_USER_TAB.rowversion%TYPE,
   rowkey                         FND_USER_TAB.rowkey%TYPE,
   description                    FND_USER_TAB.description%TYPE,
   oracle_user                    FND_USER_TAB.oracle_user%TYPE,
   web_user                       FND_USER_TAB.web_user%TYPE,
   user_type                      FND_USER_TAB.user_type%TYPE,
   active                         FND_USER_TAB.active%TYPE,
   created                        FND_USER_TAB.created%TYPE,
   last_modified                  FND_USER_TAB.last_modified%TYPE,
   default_idp                    FND_USER_TAB.default_idp%TYPE,
   from_scim                      FND_USER_TAB.from_scim%TYPE);

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (identity                       BOOLEAN := FALSE,
     description                    BOOLEAN := FALSE,
     oracle_user                    BOOLEAN := FALSE,
     web_user                       BOOLEAN := FALSE,
     user_type                      BOOLEAN := FALSE,
     active                         BOOLEAN := FALSE,
     created                        BOOLEAN := FALSE,
     last_modified                  BOOLEAN := FALSE,
     valid_from                     BOOLEAN := FALSE,
     valid_to                       BOOLEAN := FALSE,
     default_idp                    BOOLEAN := FALSE,
     from_scim                      BOOLEAN := FALSE );
  

-------------------- BASE METHODS -------------------------------------------

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   identity_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Too_Many_Rows(Fnd_User_RRP.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;




-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ fnd_user_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Record_Exist(Fnd_User_RRP.lu_name_);
END Raise_Record_Exist___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Item_Format(Fnd_User_RRP.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ fnd_user_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Record_Modified(Fnd_User_RRP.lu_name_);
END Raise_Record_Modified___;






-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN fnd_user_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        fnd_user_tab%ROWTYPE;
   dummy_      NUMBER;
BEGIN
   SELECT *
      INTO  rec_
      FROM  fnd_user_tab
      WHERE rowid = objid_
      AND    to_char(rowversion) = objversion_
      FOR UPDATE NOWAIT;
   RETURN rec_;
EXCEPTION
   WHEN row_locked THEN
      Error_SYS.Record_Locked(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Lock_By_Id___');
   WHEN no_data_found THEN
      BEGIN
         SELECT 1
            INTO  dummy_
            FROM  fnd_user_tab
            WHERE rowid = objid_;
         Raise_Record_Modified___(rec_);
      EXCEPTION
         WHEN no_data_found THEN
            Error_SYS.Record_Removed(lu_name_);
         WHEN too_many_rows THEN
            Raise_Too_Many_Rows___(NULL, 'Lock_By_Id___');
      END;
END Lock_By_Id___;




-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   identity_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1
      INTO  dummy_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Check_Exist___');
END Check_Exist___;


-- Get_Version_By_Id___
--    Fetched the objversion for a database row based on the objid.
PROCEDURE Get_Version_By_Id___ (
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2 )
IS
BEGIN
   SELECT to_char(rowversion)
      INTO  objversion_
      FROM  fnd_user_tab
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
   identity_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion)
      INTO  objid_, objversion_
      FROM  fnd_user_tab
      WHERE identity = identity_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;

-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT fnd_user_tab%ROWTYPE,
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
      WHEN ('IDENTITY') THEN
         newrec_.identity := value_;
         indrec_.identity := TRUE;
      WHEN ('DESCRIPTION') THEN
         newrec_.description := value_;
         indrec_.description := TRUE;
      WHEN ('ORACLE_USER') THEN
         newrec_.oracle_user := value_;
         indrec_.oracle_user := TRUE;
      WHEN ('WEB_USER') THEN
         newrec_.web_user := value_;
         indrec_.web_user := TRUE;
      WHEN ('USER_TYPE') THEN
         newrec_.user_type := Fnd_User_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.user_type IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.user_type := TRUE;
      WHEN ('USER_TYPE_DB') THEN
         newrec_.user_type := value_;
         indrec_.user_type := TRUE;
      WHEN ('ACTIVE') THEN
         newrec_.active := value_;
         indrec_.active := TRUE;
      WHEN ('CREATED') THEN
         newrec_.created := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.created := TRUE;
      WHEN ('LAST_MODIFIED') THEN
         newrec_.last_modified := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.last_modified := TRUE;
      WHEN ('VALID_FROM') THEN
         newrec_.valid_from := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.valid_from := TRUE;
      WHEN ('VALID_TO') THEN
         newrec_.valid_to := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.valid_to := TRUE;
      WHEN ('DEFAULT_IDP') THEN
         newrec_.default_idp := value_;
         indrec_.default_idp := TRUE;
      WHEN ('FROM_SCIM') THEN
         newrec_.from_scim := value_;
         indrec_.from_scim := TRUE;
      ELSE
         Client_SYS.Add_To_Attr(name_, value_, msg_);
      END CASE;
   END LOOP;
   attr_ := msg_;
EXCEPTION
   WHEN value_error THEN
      Raise_Item_Format___(name_, value_);
END Unpack___;






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
   rec_ IN fnd_user_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.identity := rec_.identity IS NOT NULL;
   indrec_.description := rec_.description IS NOT NULL;
   indrec_.oracle_user := rec_.oracle_user IS NOT NULL;
   indrec_.web_user := rec_.web_user IS NOT NULL;
   indrec_.user_type := rec_.user_type IS NOT NULL;
   indrec_.active := rec_.active IS NOT NULL;
   indrec_.created := rec_.created IS NOT NULL;
   indrec_.last_modified := rec_.last_modified IS NOT NULL;
   indrec_.valid_from := rec_.valid_from IS NOT NULL;
   indrec_.valid_to := rec_.valid_to IS NOT NULL;
   indrec_.default_idp := rec_.default_idp IS NOT NULL;
   indrec_.from_scim := rec_.from_scim IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN fnd_user_tab%ROWTYPE,
   newrec_ IN fnd_user_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.identity := Validate_SYS.Is_Changed(oldrec_.identity, newrec_.identity);
   indrec_.description := Validate_SYS.Is_Changed(oldrec_.description, newrec_.description);
   indrec_.oracle_user := Validate_SYS.Is_Changed(oldrec_.oracle_user, newrec_.oracle_user);
   indrec_.web_user := Validate_SYS.Is_Changed(oldrec_.web_user, newrec_.web_user);
   indrec_.user_type := Validate_SYS.Is_Changed(oldrec_.user_type, newrec_.user_type);
   indrec_.active := Validate_SYS.Is_Changed(oldrec_.active, newrec_.active);
   indrec_.created := Validate_SYS.Is_Changed(oldrec_.created, newrec_.created);
   indrec_.last_modified := Validate_SYS.Is_Changed(oldrec_.last_modified, newrec_.last_modified);
   indrec_.valid_from := Validate_SYS.Is_Changed(oldrec_.valid_from, newrec_.valid_from);
   indrec_.valid_to := Validate_SYS.Is_Changed(oldrec_.valid_to, newrec_.valid_to);
   indrec_.default_idp := Validate_SYS.Is_Changed(oldrec_.default_idp, newrec_.default_idp);
   indrec_.from_scim := Validate_SYS.Is_Changed(oldrec_.from_scim, newrec_.from_scim);
   RETURN indrec_;
END Get_Indicator_Rec___;




-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_user_tab%ROWTYPE,
   newrec_ IN OUT fnd_user_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.user_type IS NOT NULL)
   AND (indrec_.user_type)
   AND (Validate_SYS.Is_Changed(oldrec_.user_type, newrec_.user_type)) THEN
      Fnd_User_Type_API.Exist_Db(newrec_.user_type);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'IDENTITY', newrec_.identity);
   Error_SYS.Check_Not_Null(lu_name_, 'DESCRIPTION', newrec_.description);
   Error_SYS.Check_Not_Null(lu_name_, 'WEB_USER', newrec_.web_user);
   Error_SYS.Check_Not_Null(lu_name_, 'USER_TYPE', newrec_.user_type);
   Error_SYS.Check_Not_Null(lu_name_, 'ACTIVE', newrec_.active);
   Error_SYS.Check_Not_Null(lu_name_, 'CREATED', newrec_.created);
   Error_SYS.Check_Not_Null(lu_name_, 'LAST_MODIFIED', newrec_.last_modified);
END Check_Common___;


-- Check_Insert___
--   Perform validations on a new record before it is insert.
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_user_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ fnd_user_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT fnd_user_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.rowversion := 1;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   newrec_.identity := upper(newrec_.identity);
   newrec_.oracle_user := upper(newrec_.oracle_user);
   newrec_.web_user := upper(newrec_.web_user);
   newrec_.active := upper(newrec_.active);
   newrec_.default_idp := upper(newrec_.default_idp);
   newrec_.from_scim := upper(newrec_.from_scim);
   INSERT
      INTO fnd_user_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion);
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'FND_USER_RK') THEN
            Error_SYS.Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSE
            Raise_Record_Exist___(newrec_);
         END IF;
      END;
END Insert___;


-- Check_Update___
--   Perform validations on a new record before it is updated.
PROCEDURE Check_Update___ (
   oldrec_ IN     fnd_user_tab%ROWTYPE,
   newrec_ IN OUT fnd_user_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;



-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     fnd_user_tab%ROWTYPE,
   newrec_     IN OUT fnd_user_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.rowversion := newrec_.rowversion+1;
   newrec_.identity := upper(newrec_.identity);
   newrec_.oracle_user := upper(newrec_.oracle_user);
   newrec_.web_user := upper(newrec_.web_user);
   newrec_.active := upper(newrec_.active);
   newrec_.default_idp := upper(newrec_.default_idp);
   newrec_.from_scim := upper(newrec_.from_scim);
   IF by_keys_ THEN
      UPDATE fnd_user_tab
         SET ROW = newrec_
         WHERE identity = newrec_.identity;
   ELSE
      UPDATE fnd_user_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion);
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'FND_USER_RK') THEN
            Error_SYS.Rowkey_Exist(Fnd_User_RRP.lu_name_, newrec_.rowkey);
         ELSE
            Raise_Record_Exist___(newrec_);
         END IF;
      END;
END Update___;



-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN fnd_user_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.identity||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN fnd_user_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.identity||'^';
   --Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  fnd_user_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  fnd_user_tab
         WHERE identity = remrec_.identity;
   END IF;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN fnd_user_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;



PROCEDURE NewModify (
   warning_     OUT VARCHAR2,
   old_attr_     IN VARCHAR2,
   new_attr_     IN VARCHAR2,
   lu_name_      IN VARCHAR2,
   package_name_ IN VARCHAR2,
   user_id_      IN VARCHAR2) -- not needed in future. to be removed
IS
   attr_  VARCHAR2(32000);
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   oldrec_   fnd_user_tab%ROWTYPE;
   newrec_   fnd_user_tab%ROWTYPE;
   indrec_   Indicator_Rec;

BEGIN
   attr_ := new_attr_;
   oldrec_.identity := Client_SYS.Get_Item_Value('IDENTITY', old_attr_);
   Get_Id_Version_By_Keys___(objid_, objversion_, oldrec_.identity);

   IF (objid_ IS NOT NULL) THEN
      -- record exist! update record
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, FALSE);
   ELSE
      -- record does not exists! insert as new
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END NewModify;



PROCEDURE Remove (
   warning_     OUT VARCHAR2,
   old_attr_     IN VARCHAR2,
   new_attr_     IN VARCHAR2,
   lu_name_      IN VARCHAR2,
   package_name_ IN VARCHAR2,
   user_id_      IN VARCHAR2)
IS
   attr_  VARCHAR2(32000);
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);

   remrec_    fnd_user_tab%ROWTYPE;
BEGIN

   attr_ := old_attr_;
   remrec_.identity := Client_SYS.Get_Item_Value('IDENTITY', attr_);
   
   Get_Id_Version_By_Keys___(objid_, objversion_, remrec_.identity);
   IF (objid_ IS NOT NULL) THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_,remrec_);
   END IF;
END Remove;
-------------------- FOUNDATION1 METHODS ------------------------------------
