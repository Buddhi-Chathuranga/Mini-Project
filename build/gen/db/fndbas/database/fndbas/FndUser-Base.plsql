-----------------------------------------------------------------------------
--
--  Logical unit: FndUser
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
   from_scim                      BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'IDENTITY', identity_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'IDENTITY', Fnd_Session_API.Get_Language) || ': ' || identity_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   identity_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(identity_),
                            Formatted_Key___(identity_));
   Error_SYS.Fnd_Too_Many_Rows(Fnd_User_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   identity_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(identity_),
                            Formatted_Key___(identity_));
   Error_SYS.Fnd_Record_Not_Exist(Fnd_User_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN fnd_user_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.identity),
                            Formatted_Key___(rec_.identity));
   Error_SYS.Fnd_Record_Exist(Fnd_User_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN fnd_user_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Fnd_User_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Fnd_User_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN fnd_user_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.identity),
                            Formatted_Key___(rec_.identity));
   Error_SYS.Fnd_Record_Modified(Fnd_User_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   identity_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(identity_),
                            Formatted_Key___(identity_));
   Error_SYS.Fnd_Record_Locked(Fnd_User_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   identity_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(identity_),
                            Formatted_Key___(identity_));
   Error_SYS.Fnd_Record_Removed(Fnd_User_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN fnd_user_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        fnd_user_tab%ROWTYPE;
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
      Error_SYS.Fnd_Record_Locked(lu_name_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(NULL, 'Lock_By_Id___');
   WHEN no_data_found THEN
      BEGIN
         SELECT *
            INTO  rec_
            FROM  fnd_user_tab
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
   identity_ IN VARCHAR2) RETURN fnd_user_tab%ROWTYPE
IS
   rec_        fnd_user_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  fnd_user_tab
         WHERE identity = identity_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(identity_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(identity_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   identity_ IN VARCHAR2) RETURN fnd_user_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        fnd_user_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  fnd_user_tab
         WHERE identity = identity_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(identity_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(identity_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(identity_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN fnd_user_tab%ROWTYPE
IS
   lu_rec_ fnd_user_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  fnd_user_tab
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
   identity_ IN VARCHAR2 ) RETURN fnd_user_tab%ROWTYPE
IS
   lu_rec_ fnd_user_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   identity_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN FALSE;
   END IF;
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


-- Pack___
--   Reads a record and packs its contents into an attribute string.
--   This is intended to be the reverse of Unpack___
FUNCTION Pack___ (
   rec_ IN fnd_user_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.identity IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('IDENTITY', rec_.identity, attr_);
   END IF;
   IF (rec_.description IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (rec_.oracle_user IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ORACLE_USER', rec_.oracle_user, attr_);
   END IF;
   IF (rec_.web_user IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('WEB_USER', rec_.web_user, attr_);
   END IF;
   IF (rec_.user_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('USER_TYPE', Fnd_User_Type_API.Decode(rec_.user_type), attr_);
      Client_SYS.Add_To_Attr('USER_TYPE_DB', rec_.user_type, attr_);
   END IF;
   IF (rec_.active IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ACTIVE', rec_.active, attr_);
   END IF;
   IF (rec_.created IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CREATED', rec_.created, attr_);
   END IF;
   IF (rec_.last_modified IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('LAST_MODIFIED', rec_.last_modified, attr_);
   END IF;
   IF (rec_.valid_from IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VALID_FROM', rec_.valid_from, attr_);
   END IF;
   IF (rec_.valid_to IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VALID_TO', rec_.valid_to, attr_);
   END IF;
   IF (rec_.default_idp IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEFAULT_IDP', rec_.default_idp, attr_);
   END IF;
   IF (rec_.from_scim IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FROM_SCIM', rec_.from_scim, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN fnd_user_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.identity) THEN
      Client_SYS.Add_To_Attr('IDENTITY', rec_.identity, attr_);
   END IF;
   IF (indrec_.description) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (indrec_.oracle_user) THEN
      Client_SYS.Add_To_Attr('ORACLE_USER', rec_.oracle_user, attr_);
   END IF;
   IF (indrec_.web_user) THEN
      Client_SYS.Add_To_Attr('WEB_USER', rec_.web_user, attr_);
   END IF;
   IF (indrec_.user_type) THEN
      Client_SYS.Add_To_Attr('USER_TYPE', Fnd_User_Type_API.Decode(rec_.user_type), attr_);
      Client_SYS.Add_To_Attr('USER_TYPE_DB', rec_.user_type, attr_);
   END IF;
   IF (indrec_.active) THEN
      Client_SYS.Add_To_Attr('ACTIVE', rec_.active, attr_);
   END IF;
   IF (indrec_.created) THEN
      Client_SYS.Add_To_Attr('CREATED', rec_.created, attr_);
   END IF;
   IF (indrec_.last_modified) THEN
      Client_SYS.Add_To_Attr('LAST_MODIFIED', rec_.last_modified, attr_);
   END IF;
   IF (indrec_.valid_from) THEN
      Client_SYS.Add_To_Attr('VALID_FROM', rec_.valid_from, attr_);
   END IF;
   IF (indrec_.valid_to) THEN
      Client_SYS.Add_To_Attr('VALID_TO', rec_.valid_to, attr_);
   END IF;
   IF (indrec_.default_idp) THEN
      Client_SYS.Add_To_Attr('DEFAULT_IDP', rec_.default_idp, attr_);
   END IF;
   IF (indrec_.from_scim) THEN
      Client_SYS.Add_To_Attr('FROM_SCIM', rec_.from_scim, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN fnd_user_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('IDENTITY', rec_.identity, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   Client_SYS.Add_To_Attr('ORACLE_USER', rec_.oracle_user, attr_);
   Client_SYS.Add_To_Attr('WEB_USER', rec_.web_user, attr_);
   Client_SYS.Add_To_Attr('USER_TYPE', rec_.user_type, attr_);
   Client_SYS.Add_To_Attr('ACTIVE', rec_.active, attr_);
   Client_SYS.Add_To_Attr('CREATED', rec_.created, attr_);
   Client_SYS.Add_To_Attr('LAST_MODIFIED', rec_.last_modified, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', rec_.valid_from, attr_);
   Client_SYS.Add_To_Attr('VALID_TO', rec_.valid_to, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_IDP', rec_.default_idp, attr_);
   Client_SYS.Add_To_Attr('FROM_SCIM', rec_.from_scim, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN fnd_user_tab%ROWTYPE
IS
   rec_ fnd_user_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.identity                       := public_.identity;
   rec_.description                    := public_.description;
   rec_.oracle_user                    := public_.oracle_user;
   rec_.web_user                       := public_.web_user;
   rec_.user_type                      := public_.user_type;
   rec_.active                         := public_.active;
   rec_.created                        := public_.created;
   rec_.last_modified                  := public_.last_modified;
   rec_.default_idp                    := public_.default_idp;
   rec_.from_scim                      := public_.from_scim;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN fnd_user_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.identity                       := rec_.identity;
   public_.description                    := rec_.description;
   public_.oracle_user                    := rec_.oracle_user;
   public_.web_user                       := rec_.web_user;
   public_.user_type                      := rec_.user_type;
   public_.active                         := rec_.active;
   public_.created                        := rec_.created;
   public_.last_modified                  := rec_.last_modified;
   public_.default_idp                    := rec_.default_idp;
   public_.from_scim                      := rec_.from_scim;
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
   IF (newrec_.identity IS NOT NULL
       AND indrec_.identity
       AND Validate_SYS.Is_Changed(oldrec_.identity, newrec_.identity)) THEN
      Error_SYS.Check_Upper(lu_name_, 'IDENTITY', newrec_.identity);
   END IF;
   IF (newrec_.oracle_user IS NOT NULL
       AND indrec_.oracle_user
       AND Validate_SYS.Is_Changed(oldrec_.oracle_user, newrec_.oracle_user)) THEN
      Error_SYS.Check_Upper(lu_name_, 'ORACLE_USER', newrec_.oracle_user);
   END IF;
   IF (newrec_.web_user IS NOT NULL
       AND indrec_.web_user
       AND Validate_SYS.Is_Changed(oldrec_.web_user, newrec_.web_user)) THEN
      Error_SYS.Check_Upper(lu_name_, 'WEB_USER', newrec_.web_user);
   END IF;
   IF (newrec_.active IS NOT NULL
       AND indrec_.active
       AND Validate_SYS.Is_Changed(oldrec_.active, newrec_.active)) THEN
      Error_SYS.Check_Upper(lu_name_, 'ACTIVE', newrec_.active);
   END IF;
   IF (newrec_.default_idp IS NOT NULL
       AND indrec_.default_idp
       AND Validate_SYS.Is_Changed(oldrec_.default_idp, newrec_.default_idp)) THEN
      Error_SYS.Check_Upper(lu_name_, 'DEFAULT_IDP', newrec_.default_idp);
   END IF;
   IF (newrec_.from_scim IS NOT NULL
       AND indrec_.from_scim
       AND Validate_SYS.Is_Changed(oldrec_.from_scim, newrec_.from_scim)) THEN
      Error_SYS.Check_Upper(lu_name_, 'FROM_SCIM', newrec_.from_scim);
   END IF;
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
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := 1;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
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
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'FND_USER_PK') THEN
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
   newrec_ IN OUT fnd_user_tab%ROWTYPE )
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
   newrec_ IN OUT fnd_user_tab%ROWTYPE )
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
   oldrec_ IN     fnd_user_tab%ROWTYPE,
   newrec_ IN OUT fnd_user_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'IDENTITY', indrec_.identity);
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
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := newrec_.rowversion+1;
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
            Error_SYS.Fnd_Rowkey_Exist(Fnd_User_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'FND_USER_PK') THEN
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
   newrec_         IN OUT fnd_user_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     fnd_user_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.identity);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.identity);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


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
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
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


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT fnd_user_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     fnd_user_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.identity);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.identity);
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
   dummy_ fnd_user_tab%ROWTYPE;
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
   newrec_   fnd_user_tab%ROWTYPE;
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
   oldrec_   fnd_user_tab%ROWTYPE;
   newrec_   fnd_user_tab%ROWTYPE;
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
   remrec_ fnd_user_tab%ROWTYPE;
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
   rowkey_ IN VARCHAR2 ) RETURN fnd_user_tab%ROWTYPE
IS
   rec_ fnd_user_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT identity
      INTO  rec_.identity
      FROM  fnd_user_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.identity, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   identity_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(identity_)) THEN
      Raise_Record_Not_Exist___(identity_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   identity_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(identity_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   identity_ fnd_user_tab.identity%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT identity
   INTO  identity_
   FROM  fnd_user_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(identity_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ fnd_user_tab.description%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT description
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Description');
END Get_Description;


-- Get_Oracle_User
--   Fetches the OracleUser attribute for a record.
@UncheckedAccess
FUNCTION Get_Oracle_User (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ fnd_user_tab.oracle_user%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT oracle_user
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Oracle_User');
END Get_Oracle_User;


-- Get_Web_User
--   Fetches the WebUser attribute for a record.
@UncheckedAccess
FUNCTION Get_Web_User (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ fnd_user_tab.web_user%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT web_user
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Web_User');
END Get_Web_User;


-- Get_User_Type
--   Fetches the UserType attribute for a record.
@UncheckedAccess
FUNCTION Get_User_Type (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ fnd_user_tab.user_type%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT user_type
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN Fnd_User_Type_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_User_Type');
END Get_User_Type;


-- Get_User_Type_Db
--   Fetches the DB value of UserType attribute for a record.
@UncheckedAccess
FUNCTION Get_User_Type_Db (
   identity_ IN VARCHAR2 ) RETURN fnd_user_tab.user_type%TYPE
IS
   temp_ fnd_user_tab.user_type%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT user_type
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_User_Type_Db');
END Get_User_Type_Db;


-- Get_Active
--   Fetches the Active attribute for a record.
@UncheckedAccess
FUNCTION Get_Active (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ fnd_user_tab.active%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT active
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Active');
END Get_Active;


-- Get_Created
--   Fetches the Created attribute for a record.
@UncheckedAccess
FUNCTION Get_Created (
   identity_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ fnd_user_tab.created%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT created
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Created');
END Get_Created;


-- Get_Last_Modified
--   Fetches the LastModified attribute for a record.
@UncheckedAccess
FUNCTION Get_Last_Modified (
   identity_ IN VARCHAR2 ) RETURN DATE
IS
   temp_ fnd_user_tab.last_modified%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT last_modified
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Last_Modified');
END Get_Last_Modified;


-- Get_Default_Idp
--   Fetches the DefaultIdp attribute for a record.
@UncheckedAccess
FUNCTION Get_Default_Idp (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ fnd_user_tab.default_idp%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT default_idp
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Default_Idp');
END Get_Default_Idp;


-- Get_From_Scim
--   Fetches the FromScim attribute for a record.
@UncheckedAccess
FUNCTION Get_From_Scim (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ fnd_user_tab.from_scim%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT from_scim
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_From_Scim');
END Get_From_Scim;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ fnd_user_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.identity);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   identity_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT identity, rowid, rowversion, rowkey,
          description, 
          oracle_user, 
          web_user, 
          user_type, 
          active, 
          created, 
          last_modified, 
          default_idp, 
          from_scim
      INTO  temp_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   identity_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rowkey_ fnd_user_tab.rowkey%TYPE;
BEGIN
   IF (identity_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  fnd_user_tab
      WHERE identity = identity_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(identity_, 'Get_Objkey');
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