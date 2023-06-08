-----------------------------------------------------------------------------
--
--  Logical unit: IsoCountry
--  Component:    APPSRV
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
--  (country_code                   ISO_COUNTRY_TAB.country_code%TYPE);

TYPE Public_Rec IS RECORD
  (country_code                   ISO_COUNTRY_TAB.country_code%TYPE,
   "rowid"                        rowid,
   rowversion                     ISO_COUNTRY_TAB.rowversion%TYPE,
   rowkey                         ISO_COUNTRY_TAB.rowkey%TYPE,
   eu_member                      ISO_COUNTRY_TAB.eu_member%TYPE,
   default_locale                 ISO_COUNTRY_TAB.default_locale%TYPE,
   fetch_jurisdiction_code        ISO_COUNTRY_TAB.fetch_jurisdiction_code%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (country_code                   BOOLEAN := FALSE,
   country_code3                  BOOLEAN := FALSE,
   country_id                     BOOLEAN := FALSE,
   description                    BOOLEAN := FALSE,
   used_in_appl                   BOOLEAN := FALSE,
   full_name                      BOOLEAN := FALSE,
   eu_member                      BOOLEAN := FALSE,
   default_locale                 BOOLEAN := FALSE,
   blocked_for_use                BOOLEAN := FALSE,
   system_added                   BOOLEAN := FALSE,
   fetch_jurisdiction_code        BOOLEAN := FALSE);

-------------------- BASE METHODS -------------------------------------------

-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'COUNTRY_CODE', country_code_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'COUNTRY_CODE', Fnd_Session_API.Get_Language) || ': ' || country_code_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   country_code_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(country_code_),
                            Formatted_Key___(country_code_));
   Error_SYS.Fnd_Too_Many_Rows(Iso_Country_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   country_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(country_code_),
                            Formatted_Key___(country_code_));
   Error_SYS.Fnd_Record_Not_Exist(Iso_Country_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN iso_country_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.country_code),
                            Formatted_Key___(rec_.country_code));
   Error_SYS.Fnd_Record_Exist(Iso_Country_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN iso_country_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Iso_Country_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Iso_Country_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN iso_country_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.country_code),
                            Formatted_Key___(rec_.country_code));
   Error_SYS.Fnd_Record_Modified(Iso_Country_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   country_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(country_code_),
                            Formatted_Key___(country_code_));
   Error_SYS.Fnd_Record_Locked(Iso_Country_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   country_code_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(country_code_),
                            Formatted_Key___(country_code_));
   Error_SYS.Fnd_Record_Removed(Iso_Country_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN iso_country_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        iso_country_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  iso_country_tab
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
            FROM  iso_country_tab
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
   country_code_ IN VARCHAR2) RETURN iso_country_tab%ROWTYPE
IS
   rec_        iso_country_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  iso_country_tab
         WHERE country_code = country_code_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(country_code_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(country_code_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   country_code_ IN VARCHAR2) RETURN iso_country_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        iso_country_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  iso_country_tab
         WHERE country_code = country_code_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(country_code_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(country_code_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(country_code_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN iso_country_tab%ROWTYPE
IS
   lu_rec_ iso_country_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  iso_country_tab
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
   country_code_ IN VARCHAR2 ) RETURN iso_country_tab%ROWTYPE
IS
   lu_rec_ iso_country_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   country_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Check_Exist___');
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
      FROM  iso_country_tab
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
   country_code_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT iso_country_tab%ROWTYPE,
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
      WHEN ('COUNTRY_CODE') THEN
         newrec_.country_code := value_;
         indrec_.country_code := TRUE;
      WHEN ('COUNTRY_CODE3') THEN
         newrec_.country_code3 := value_;
         indrec_.country_code3 := TRUE;
      WHEN ('COUNTRY_ID') THEN
         newrec_.country_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.country_id := TRUE;
      WHEN ('DESCRIPTION') THEN
         newrec_.description := value_;
         indrec_.description := TRUE;
      WHEN ('USED_IN_APPL') THEN
         newrec_.used_in_appl := value_;
         indrec_.used_in_appl := TRUE;
      WHEN ('FULL_NAME') THEN
         newrec_.full_name := value_;
         indrec_.full_name := TRUE;
      WHEN ('EU_MEMBER') THEN
         newrec_.eu_member := Eu_Member_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.eu_member IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.eu_member := TRUE;
      WHEN ('EU_MEMBER_DB') THEN
         newrec_.eu_member := value_;
         indrec_.eu_member := TRUE;
      WHEN ('DEFAULT_LOCALE') THEN
         newrec_.default_locale := value_;
         indrec_.default_locale := TRUE;
      WHEN ('BLOCKED_FOR_USE') THEN
         newrec_.blocked_for_use := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.blocked_for_use IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.blocked_for_use := TRUE;
      WHEN ('BLOCKED_FOR_USE_DB') THEN
         newrec_.blocked_for_use := value_;
         indrec_.blocked_for_use := TRUE;
      WHEN ('SYSTEM_ADDED') THEN
         newrec_.system_added := value_;
         indrec_.system_added := TRUE;
      WHEN ('FETCH_JURISDICTION_CODE') THEN
         newrec_.fetch_jurisdiction_code := Fnd_Boolean_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.fetch_jurisdiction_code IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.fetch_jurisdiction_code := TRUE;
      WHEN ('FETCH_JURISDICTION_CODE_DB') THEN
         newrec_.fetch_jurisdiction_code := value_;
         indrec_.fetch_jurisdiction_code := TRUE;
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
   rec_ IN iso_country_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.country_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY_CODE', rec_.country_code, attr_);
   END IF;
   IF (rec_.country_code3 IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY_CODE3', rec_.country_code3, attr_);
   END IF;
   IF (rec_.country_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY_ID', rec_.country_id, attr_);
   END IF;
   IF (rec_.description IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (rec_.used_in_appl IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('USED_IN_APPL', rec_.used_in_appl, attr_);
   END IF;
   IF (rec_.full_name IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FULL_NAME', rec_.full_name, attr_);
   END IF;
   IF (rec_.eu_member IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EU_MEMBER', Eu_Member_API.Decode(rec_.eu_member), attr_);
      Client_SYS.Add_To_Attr('EU_MEMBER_DB', rec_.eu_member, attr_);
   END IF;
   IF (rec_.default_locale IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEFAULT_LOCALE', rec_.default_locale, attr_);
   END IF;
   IF (rec_.blocked_for_use IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('BLOCKED_FOR_USE', Fnd_Boolean_API.Decode(rec_.blocked_for_use), attr_);
      Client_SYS.Add_To_Attr('BLOCKED_FOR_USE_DB', rec_.blocked_for_use, attr_);
   END IF;
   IF (rec_.system_added IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SYSTEM_ADDED', rec_.system_added, attr_);
   END IF;
   IF (rec_.fetch_jurisdiction_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('FETCH_JURISDICTION_CODE', Fnd_Boolean_API.Decode(rec_.fetch_jurisdiction_code), attr_);
      Client_SYS.Add_To_Attr('FETCH_JURISDICTION_CODE_DB', rec_.fetch_jurisdiction_code, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN iso_country_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.country_code) THEN
      Client_SYS.Add_To_Attr('COUNTRY_CODE', rec_.country_code, attr_);
   END IF;
   IF (indrec_.country_code3) THEN
      Client_SYS.Add_To_Attr('COUNTRY_CODE3', rec_.country_code3, attr_);
   END IF;
   IF (indrec_.country_id) THEN
      Client_SYS.Add_To_Attr('COUNTRY_ID', rec_.country_id, attr_);
   END IF;
   IF (indrec_.description) THEN
      Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   END IF;
   IF (indrec_.used_in_appl) THEN
      Client_SYS.Add_To_Attr('USED_IN_APPL', rec_.used_in_appl, attr_);
   END IF;
   IF (indrec_.full_name) THEN
      Client_SYS.Add_To_Attr('FULL_NAME', rec_.full_name, attr_);
   END IF;
   IF (indrec_.eu_member) THEN
      Client_SYS.Add_To_Attr('EU_MEMBER', Eu_Member_API.Decode(rec_.eu_member), attr_);
      Client_SYS.Add_To_Attr('EU_MEMBER_DB', rec_.eu_member, attr_);
   END IF;
   IF (indrec_.default_locale) THEN
      Client_SYS.Add_To_Attr('DEFAULT_LOCALE', rec_.default_locale, attr_);
   END IF;
   IF (indrec_.blocked_for_use) THEN
      Client_SYS.Add_To_Attr('BLOCKED_FOR_USE', Fnd_Boolean_API.Decode(rec_.blocked_for_use), attr_);
      Client_SYS.Add_To_Attr('BLOCKED_FOR_USE_DB', rec_.blocked_for_use, attr_);
   END IF;
   IF (indrec_.system_added) THEN
      Client_SYS.Add_To_Attr('SYSTEM_ADDED', rec_.system_added, attr_);
   END IF;
   IF (indrec_.fetch_jurisdiction_code) THEN
      Client_SYS.Add_To_Attr('FETCH_JURISDICTION_CODE', Fnd_Boolean_API.Decode(rec_.fetch_jurisdiction_code), attr_);
      Client_SYS.Add_To_Attr('FETCH_JURISDICTION_CODE_DB', rec_.fetch_jurisdiction_code, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN iso_country_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE', rec_.country_code, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_CODE3', rec_.country_code3, attr_);
   Client_SYS.Add_To_Attr('COUNTRY_ID', rec_.country_id, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', rec_.description, attr_);
   Client_SYS.Add_To_Attr('USED_IN_APPL', rec_.used_in_appl, attr_);
   Client_SYS.Add_To_Attr('FULL_NAME', rec_.full_name, attr_);
   Client_SYS.Add_To_Attr('EU_MEMBER', rec_.eu_member, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_LOCALE', rec_.default_locale, attr_);
   Client_SYS.Add_To_Attr('BLOCKED_FOR_USE', rec_.blocked_for_use, attr_);
   Client_SYS.Add_To_Attr('SYSTEM_ADDED', rec_.system_added, attr_);
   Client_SYS.Add_To_Attr('FETCH_JURISDICTION_CODE', rec_.fetch_jurisdiction_code, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN iso_country_tab%ROWTYPE
IS
   rec_ iso_country_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.country_code                   := public_.country_code;
   rec_.eu_member                      := public_.eu_member;
   rec_.default_locale                 := public_.default_locale;
   rec_.fetch_jurisdiction_code        := public_.fetch_jurisdiction_code;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN iso_country_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.country_code                   := rec_.country_code;
   public_.eu_member                      := rec_.eu_member;
   public_.default_locale                 := rec_.default_locale;
   public_.fetch_jurisdiction_code        := rec_.fetch_jurisdiction_code;
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
   rec_ IN iso_country_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.country_code := rec_.country_code IS NOT NULL;
   indrec_.country_code3 := rec_.country_code3 IS NOT NULL;
   indrec_.country_id := rec_.country_id IS NOT NULL;
   indrec_.description := rec_.description IS NOT NULL;
   indrec_.used_in_appl := rec_.used_in_appl IS NOT NULL;
   indrec_.full_name := rec_.full_name IS NOT NULL;
   indrec_.eu_member := rec_.eu_member IS NOT NULL;
   indrec_.default_locale := rec_.default_locale IS NOT NULL;
   indrec_.blocked_for_use := rec_.blocked_for_use IS NOT NULL;
   indrec_.system_added := rec_.system_added IS NOT NULL;
   indrec_.fetch_jurisdiction_code := rec_.fetch_jurisdiction_code IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN iso_country_tab%ROWTYPE,
   newrec_ IN iso_country_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.country_code := Validate_SYS.Is_Changed(oldrec_.country_code, newrec_.country_code);
   indrec_.country_code3 := Validate_SYS.Is_Changed(oldrec_.country_code3, newrec_.country_code3);
   indrec_.country_id := Validate_SYS.Is_Changed(oldrec_.country_id, newrec_.country_id);
   indrec_.description := Validate_SYS.Is_Changed(oldrec_.description, newrec_.description);
   indrec_.used_in_appl := Validate_SYS.Is_Changed(oldrec_.used_in_appl, newrec_.used_in_appl);
   indrec_.full_name := Validate_SYS.Is_Changed(oldrec_.full_name, newrec_.full_name);
   indrec_.eu_member := Validate_SYS.Is_Changed(oldrec_.eu_member, newrec_.eu_member);
   indrec_.default_locale := Validate_SYS.Is_Changed(oldrec_.default_locale, newrec_.default_locale);
   indrec_.blocked_for_use := Validate_SYS.Is_Changed(oldrec_.blocked_for_use, newrec_.blocked_for_use);
   indrec_.system_added := Validate_SYS.Is_Changed(oldrec_.system_added, newrec_.system_added);
   indrec_.fetch_jurisdiction_code := Validate_SYS.Is_Changed(oldrec_.fetch_jurisdiction_code, newrec_.fetch_jurisdiction_code);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     iso_country_tab%ROWTYPE,
   newrec_ IN OUT iso_country_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.country_code IS NOT NULL
       AND indrec_.country_code
       AND Validate_SYS.Is_Changed(oldrec_.country_code, newrec_.country_code)) THEN
      Error_SYS.Check_Upper(lu_name_, 'COUNTRY_CODE', newrec_.country_code);
   END IF;
   IF (newrec_.country_code3 IS NOT NULL
       AND indrec_.country_code3
       AND Validate_SYS.Is_Changed(oldrec_.country_code3, newrec_.country_code3)) THEN
      Error_SYS.Check_Upper(lu_name_, 'COUNTRY_CODE3', newrec_.country_code3);
   END IF;
   IF (newrec_.eu_member IS NOT NULL)
   AND (indrec_.eu_member)
   AND (Validate_SYS.Is_Changed(oldrec_.eu_member, newrec_.eu_member)) THEN
      Eu_Member_API.Exist_Db(newrec_.eu_member);
   END IF;
   IF (newrec_.blocked_for_use IS NOT NULL)
   AND (indrec_.blocked_for_use)
   AND (Validate_SYS.Is_Changed(oldrec_.blocked_for_use, newrec_.blocked_for_use)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.blocked_for_use);
   END IF;
   IF (newrec_.fetch_jurisdiction_code IS NOT NULL)
   AND (indrec_.fetch_jurisdiction_code)
   AND (Validate_SYS.Is_Changed(oldrec_.fetch_jurisdiction_code, newrec_.fetch_jurisdiction_code)) THEN
      Fnd_Boolean_API.Exist_Db(newrec_.fetch_jurisdiction_code);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'COUNTRY_CODE', newrec_.country_code);
   Error_SYS.Check_Not_Null(lu_name_, 'DESCRIPTION', newrec_.description);
   Error_SYS.Check_Not_Null(lu_name_, 'USED_IN_APPL', newrec_.used_in_appl);
   Error_SYS.Check_Not_Null(lu_name_, 'EU_MEMBER', newrec_.eu_member);
   Error_SYS.Check_Not_Null(lu_name_, 'BLOCKED_FOR_USE', newrec_.blocked_for_use);
   Error_SYS.Check_Not_Null(lu_name_, 'SYSTEM_ADDED', newrec_.system_added);
   Error_SYS.Check_Not_Null(lu_name_, 'FETCH_JURISDICTION_CODE', newrec_.fetch_jurisdiction_code);
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
   newrec_ IN OUT iso_country_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ iso_country_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT iso_country_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO iso_country_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoCountry',
      newrec_.country_code,
      NULL, newrec_.description);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoCountry',
      newrec_.country_code,
      NULL, newrec_.full_name);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'ISO_COUNTRY_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'ISO_COUNTRY_PK') THEN
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
   newrec_ IN OUT iso_country_tab%ROWTYPE )
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
   newrec_ IN OUT iso_country_tab%ROWTYPE )
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
   oldrec_ IN     iso_country_tab%ROWTYPE,
   newrec_ IN OUT iso_country_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'COUNTRY_CODE', indrec_.country_code);
   Validate_SYS.Item_Update(lu_name_, 'SYSTEM_ADDED', indrec_.system_added);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     iso_country_tab%ROWTYPE,
   newrec_     IN OUT iso_country_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE iso_country_tab
         SET ROW = newrec_
         WHERE country_code = newrec_.country_code;
   ELSE
      UPDATE iso_country_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoCountry',
      newrec_.country_code,
      NULL, newrec_.description, oldrec_.description);
   Basic_Data_Translation_API.Insert_Basic_Data_Translation('APPSRV', 'IsoCountry',
      newrec_.country_code,
      NULL, newrec_.full_name, oldrec_.full_name);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'ISO_COUNTRY_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Iso_Country_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'ISO_COUNTRY_PK') THEN
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
   newrec_         IN OUT iso_country_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     iso_country_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.country_code);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.country_code);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN iso_country_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.country_code||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN iso_country_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.country_code||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  iso_country_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  iso_country_tab
         WHERE country_code = remrec_.country_code;
   END IF;
   Basic_Data_Translation_API.Remove_Basic_Data_Translation('APPSRV', 'IsoCountry',
      remrec_.country_code);
   Basic_Data_Translation_API.Remove_Basic_Data_Translation('APPSRV', 'IsoCountry',
      remrec_.country_code);
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN iso_country_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT iso_country_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     iso_country_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.country_code);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.country_code);
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
   dummy_ iso_country_tab%ROWTYPE;
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
   newrec_   iso_country_tab%ROWTYPE;
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
      Dictionary_SYS.Refresh_Dependent_Meta_Caches('IsoCountry');
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
   oldrec_   iso_country_tab%ROWTYPE;
   newrec_   iso_country_tab%ROWTYPE;
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
      Dictionary_SYS.Refresh_Dependent_Meta_Caches('IsoCountry');
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
   remrec_ iso_country_tab%ROWTYPE;
BEGIN
   IF (action_ = 'CHECK') THEN
      remrec_ := Get_Object_By_Id___(objid_);
      Check_Delete___(remrec_);
   ELSIF (action_ = 'DO') THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_);
      Delete___(objid_, remrec_);
      Dictionary_SYS.Refresh_Dependent_Meta_Caches('IsoCountry');
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Remove__;


-- Get_Key_By_Rowkey
--   Returns a table record with only keys (other attributes are NULL) based on a rowkey.
@UncheckedAccess
FUNCTION Get_Key_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN iso_country_tab%ROWTYPE
IS
   rec_ iso_country_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT country_code
      INTO  rec_.country_code
      FROM  iso_country_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.country_code, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   country_code_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(country_code_)) THEN
      Raise_Record_Not_Exist___(country_code_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   country_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(country_code_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   country_code_ iso_country_tab.country_code%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT country_code
   INTO  country_code_
   FROM  iso_country_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(country_code_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Eu_Member
--   Fetches the EuMember attribute for a record.
@UncheckedAccess
FUNCTION Get_Eu_Member (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ iso_country_tab.eu_member%TYPE;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT eu_member
      INTO  temp_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN Eu_Member_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Eu_Member');
END Get_Eu_Member;


-- Get_Eu_Member_Db
--   Fetches the DB value of EuMember attribute for a record.
@UncheckedAccess
FUNCTION Get_Eu_Member_Db (
   country_code_ IN VARCHAR2 ) RETURN iso_country_tab.eu_member%TYPE
IS
   temp_ iso_country_tab.eu_member%TYPE;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT eu_member
      INTO  temp_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Eu_Member_Db');
END Get_Eu_Member_Db;


-- Get_Default_Locale
--   Fetches the DefaultLocale attribute for a record.
@UncheckedAccess
FUNCTION Get_Default_Locale (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ iso_country_tab.default_locale%TYPE;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT default_locale
      INTO  temp_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Default_Locale');
END Get_Default_Locale;


-- Get_Fetch_Jurisdiction_Code
--   Fetches the FetchJurisdictionCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Fetch_Jurisdiction_Code (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ iso_country_tab.fetch_jurisdiction_code%TYPE;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT fetch_jurisdiction_code
      INTO  temp_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN Fnd_Boolean_API.Decode(temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Fetch_Jurisdiction_Code');
END Get_Fetch_Jurisdiction_Code;


-- Get_Fetch_Jurisdiction_Code_Db
--   Fetches the DB value of FetchJurisdictionCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Fetch_Jurisdiction_Code_Db (
   country_code_ IN VARCHAR2 ) RETURN iso_country_tab.fetch_jurisdiction_code%TYPE
IS
   temp_ iso_country_tab.fetch_jurisdiction_code%TYPE;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT fetch_jurisdiction_code
      INTO  temp_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Fetch_Jurisdiction_Code_Db');
END Get_Fetch_Jurisdiction_Code_Db;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ iso_country_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.country_code);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   country_code_ IN VARCHAR2 ) RETURN Public_Rec
IS
   temp_ Public_Rec;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT country_code, rowid, rowversion, rowkey,
          eu_member, 
          default_locale, 
          fetch_jurisdiction_code
      INTO  temp_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get');
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   country_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   rowkey_ iso_country_tab.rowkey%TYPE;
BEGIN
   IF (country_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT rowkey
      INTO  rowkey_
      FROM  iso_country_tab
      WHERE country_code = country_code_;
   RETURN rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(country_code_, 'Get_Objkey');
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