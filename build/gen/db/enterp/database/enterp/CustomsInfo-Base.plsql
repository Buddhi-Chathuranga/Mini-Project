-----------------------------------------------------------------------------
--
--  Logical unit: CustomsInfo
--  Component:    ENTERP
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
--  (customs_id                     CUSTOMS_INFO_TAB.customs_id%TYPE);

TYPE Public_Rec IS RECORD
  (customs_id                     CUSTOMS_INFO_TAB.customs_id%TYPE,
   "rowid"                        rowid,
   rowversion                     CUSTOMS_INFO_TAB.rowversion%TYPE,
   rowkey                         CUSTOMS_INFO_TAB.rowkey%TYPE,
   name                           CUSTOMS_INFO_TAB.name%TYPE,
   creation_date                  CUSTOMS_INFO_TAB.creation_date%TYPE,
   association_no                 CUSTOMS_INFO_TAB.association_no%TYPE,
   default_language               CUSTOMS_INFO_TAB.default_language%TYPE,
   country                        CUSTOMS_INFO_TAB.country%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (customs_id                     BOOLEAN := FALSE,
   name                           BOOLEAN := FALSE,
   creation_date                  BOOLEAN := FALSE,
   association_no                 BOOLEAN := FALSE,
   default_language               BOOLEAN := FALSE,
   country                        BOOLEAN := FALSE);

TYPE Micro_Cache_Type IS TABLE OF  Public_Rec INDEX BY VARCHAR2(1000);
micro_cache_tab_                   Micro_Cache_Type;
micro_cache_value_                 Public_Rec;
micro_cache_time_                  NUMBER := 0;
micro_cache_user_                  VARCHAR2(30);
TYPE Linked_Cache IS TABLE OF      VARCHAR2(1000) INDEX BY PLS_INTEGER;
micro_cache_link_tab_              Linked_Cache;
micro_cache_max_id_                PLS_INTEGER;
max_cached_element_count_          CONSTANT NUMBER := 10;
max_cached_element_life_           CONSTANT NUMBER := 100;
-------------------- BASE METHODS -------------------------------------------

-- Invalidate_Cache___
--   Clears the micro cache so that a new update will be forced next
--   time the cache is read.
PROCEDURE Invalidate_Cache___
IS
   null_value_ Public_Rec;
BEGIN
   micro_cache_tab_.delete;
   micro_cache_link_tab_.delete;
   micro_cache_max_id_ := 0;
   micro_cache_value_ := null_value_;
   micro_cache_time_  := 0;
END Invalidate_Cache___;


-- Update_Cache___
--   Updates the micro cache with new data.
PROCEDURE Update_Cache___ (
   customs_id_ IN VARCHAR2 )
IS
   req_id_     VARCHAR2(1000) := customs_id_;
   null_value_ Public_Rec;
   time_       NUMBER;
   expired_    BOOLEAN;
BEGIN
   time_    := Database_SYS.Get_Time_Offset;
   expired_ := ((time_ - micro_cache_time_) > max_cached_element_life_);
   IF (expired_ OR (micro_cache_user_ IS NULL) OR (micro_cache_user_ != Fnd_Session_API.Get_Fnd_User)) THEN
      Invalidate_Cache___;
      micro_cache_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   IF (NOT micro_cache_tab_.exists(req_id_)) THEN
      SELECT customs_id,
             rowid, rowversion, rowkey,
             name, 
             creation_date, 
             association_no, 
             default_language, 
             country
      INTO  micro_cache_value_
      FROM  customs_info_tab
      WHERE customs_id = customs_id_;
      IF (micro_cache_tab_.count >= max_cached_element_count_) THEN
         DECLARE
            random_  NUMBER := NULL;
            element_ VARCHAR2(1000);
         BEGIN
            random_ := round(dbms_random.value(1, max_cached_element_count_), 0);
            element_ := micro_cache_link_tab_(random_);
            micro_cache_tab_.delete(element_);
            micro_cache_link_tab_.delete(random_);
            micro_cache_link_tab_(random_) := req_id_;
         END;
      ELSE
         micro_cache_max_id_ := micro_cache_max_id_ + 1;
         micro_cache_link_tab_(micro_cache_max_id_) := req_id_;
      END IF;
      micro_cache_tab_(req_id_) := micro_cache_value_;
      micro_cache_time_ := time_;
   END IF;
   micro_cache_value_ := micro_cache_tab_(req_id_);
EXCEPTION
   WHEN no_data_found THEN
      micro_cache_value_ := null_value_;
      micro_cache_tab_.delete(req_id_);
      micro_cache_time_  := time_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customs_id_, 'Update_Cache___');
END Update_Cache___;


-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'CUSTOMS_ID', customs_id_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'CUSTOMS_ID', Fnd_Session_API.Get_Language) || ': ' || customs_id_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   customs_id_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customs_id_),
                            Formatted_Key___(customs_id_));
   Error_SYS.Fnd_Too_Many_Rows(Customs_Info_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   customs_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customs_id_),
                            Formatted_Key___(customs_id_));
   Error_SYS.Fnd_Record_Not_Exist(Customs_Info_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN customs_info_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.customs_id),
                            Formatted_Key___(rec_.customs_id));
   Error_SYS.Fnd_Record_Exist(Customs_Info_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN customs_info_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Customs_Info_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Customs_Info_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN customs_info_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.customs_id),
                            Formatted_Key___(rec_.customs_id));
   Error_SYS.Fnd_Record_Modified(Customs_Info_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   customs_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customs_id_),
                            Formatted_Key___(customs_id_));
   Error_SYS.Fnd_Record_Locked(Customs_Info_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   customs_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customs_id_),
                            Formatted_Key___(customs_id_));
   Error_SYS.Fnd_Record_Removed(Customs_Info_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN customs_info_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        customs_info_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  customs_info_tab
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
            FROM  customs_info_tab
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
   customs_id_ IN VARCHAR2) RETURN customs_info_tab%ROWTYPE
IS
   rec_        customs_info_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  customs_info_tab
         WHERE customs_id = customs_id_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(customs_id_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(customs_id_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   customs_id_ IN VARCHAR2) RETURN customs_info_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        customs_info_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  customs_info_tab
         WHERE customs_id = customs_id_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(customs_id_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(customs_id_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(customs_id_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN customs_info_tab%ROWTYPE
IS
   lu_rec_ customs_info_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  customs_info_tab
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
   customs_id_ IN VARCHAR2 ) RETURN customs_info_tab%ROWTYPE
IS
   lu_rec_ customs_info_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  customs_info_tab
      WHERE customs_id = customs_id_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customs_id_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   customs_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  customs_info_tab
      WHERE customs_id = customs_id_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customs_id_, 'Check_Exist___');
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
      FROM  customs_info_tab
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
   customs_id_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion)
      INTO  objid_, objversion_
      FROM  customs_info_tab
      WHERE customs_id = customs_id_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customs_id_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT customs_info_tab%ROWTYPE,
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
      WHEN ('CUSTOMS_ID') THEN
         newrec_.customs_id := value_;
         indrec_.customs_id := TRUE;
      WHEN ('NAME') THEN
         newrec_.name := value_;
         indrec_.name := TRUE;
      WHEN ('CREATION_DATE') THEN
         newrec_.creation_date := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.creation_date := TRUE;
      WHEN ('ASSOCIATION_NO') THEN
         newrec_.association_no := value_;
         indrec_.association_no := TRUE;
      WHEN ('DEFAULT_LANGUAGE') THEN
         newrec_.default_language := Iso_Language_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.default_language IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.default_language := TRUE;
      WHEN ('DEFAULT_LANGUAGE_DB') THEN
         newrec_.default_language := value_;
         indrec_.default_language := TRUE;
      WHEN ('COUNTRY') THEN
         newrec_.country := Iso_Country_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.country IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.country := TRUE;
      WHEN ('COUNTRY_DB') THEN
         newrec_.country := value_;
         indrec_.country := TRUE;
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
   rec_ IN customs_info_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.customs_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMS_ID', rec_.customs_id, attr_);
   END IF;
   IF (rec_.name IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NAME', rec_.name, attr_);
   END IF;
   IF (rec_.creation_date IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CREATION_DATE', rec_.creation_date, attr_);
   END IF;
   IF (rec_.association_no IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ASSOCIATION_NO', rec_.association_no, attr_);
   END IF;
   IF (rec_.default_language IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE', Iso_Language_API.Decode(rec_.default_language), attr_);
      Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE_DB', rec_.default_language, attr_);
   END IF;
   IF (rec_.country IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY', Iso_Country_API.Decode(rec_.country), attr_);
      Client_SYS.Add_To_Attr('COUNTRY_DB', rec_.country, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN customs_info_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.customs_id) THEN
      Client_SYS.Add_To_Attr('CUSTOMS_ID', rec_.customs_id, attr_);
   END IF;
   IF (indrec_.name) THEN
      Client_SYS.Add_To_Attr('NAME', rec_.name, attr_);
   END IF;
   IF (indrec_.creation_date) THEN
      Client_SYS.Add_To_Attr('CREATION_DATE', rec_.creation_date, attr_);
   END IF;
   IF (indrec_.association_no) THEN
      Client_SYS.Add_To_Attr('ASSOCIATION_NO', rec_.association_no, attr_);
   END IF;
   IF (indrec_.default_language) THEN
      Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE', Iso_Language_API.Decode(rec_.default_language), attr_);
      Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE_DB', rec_.default_language, attr_);
   END IF;
   IF (indrec_.country) THEN
      Client_SYS.Add_To_Attr('COUNTRY', Iso_Country_API.Decode(rec_.country), attr_);
      Client_SYS.Add_To_Attr('COUNTRY_DB', rec_.country, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN customs_info_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CUSTOMS_ID', rec_.customs_id, attr_);
   Client_SYS.Add_To_Attr('NAME', rec_.name, attr_);
   Client_SYS.Add_To_Attr('CREATION_DATE', rec_.creation_date, attr_);
   Client_SYS.Add_To_Attr('ASSOCIATION_NO', rec_.association_no, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_LANGUAGE', rec_.default_language, attr_);
   Client_SYS.Add_To_Attr('COUNTRY', rec_.country, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN customs_info_tab%ROWTYPE
IS
   rec_ customs_info_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.customs_id                     := public_.customs_id;
   rec_.name                           := public_.name;
   rec_.creation_date                  := public_.creation_date;
   rec_.association_no                 := public_.association_no;
   rec_.default_language               := public_.default_language;
   rec_.country                        := public_.country;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN customs_info_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.customs_id                     := rec_.customs_id;
   public_.name                           := rec_.name;
   public_.creation_date                  := rec_.creation_date;
   public_.association_no                 := rec_.association_no;
   public_.default_language               := rec_.default_language;
   public_.country                        := rec_.country;
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
   rec_ IN customs_info_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.customs_id := rec_.customs_id IS NOT NULL;
   indrec_.name := rec_.name IS NOT NULL;
   indrec_.creation_date := rec_.creation_date IS NOT NULL;
   indrec_.association_no := rec_.association_no IS NOT NULL;
   indrec_.default_language := rec_.default_language IS NOT NULL;
   indrec_.country := rec_.country IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN customs_info_tab%ROWTYPE,
   newrec_ IN customs_info_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.customs_id := Validate_SYS.Is_Changed(oldrec_.customs_id, newrec_.customs_id);
   indrec_.name := Validate_SYS.Is_Changed(oldrec_.name, newrec_.name);
   indrec_.creation_date := Validate_SYS.Is_Changed(oldrec_.creation_date, newrec_.creation_date);
   indrec_.association_no := Validate_SYS.Is_Changed(oldrec_.association_no, newrec_.association_no);
   indrec_.default_language := Validate_SYS.Is_Changed(oldrec_.default_language, newrec_.default_language);
   indrec_.country := Validate_SYS.Is_Changed(oldrec_.country, newrec_.country);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     customs_info_tab%ROWTYPE,
   newrec_ IN OUT customs_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.customs_id IS NOT NULL
       AND indrec_.customs_id
       AND Validate_SYS.Is_Changed(oldrec_.customs_id, newrec_.customs_id)) THEN
      Error_SYS.Check_Upper(lu_name_, 'CUSTOMS_ID', newrec_.customs_id);
   END IF;
   IF (newrec_.default_language IS NOT NULL)
   AND (indrec_.default_language)
   AND (Validate_SYS.Is_Changed(oldrec_.default_language, newrec_.default_language)) THEN
      Iso_Language_API.Exist(newrec_.default_language);
   END IF;
   IF (newrec_.country IS NOT NULL)
   AND (indrec_.country)
   AND (Validate_SYS.Is_Changed(oldrec_.country, newrec_.country)) THEN
      Iso_Country_API.Exist(newrec_.country);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMS_ID', newrec_.customs_id);
   Error_SYS.Check_Not_Null(lu_name_, 'NAME', newrec_.name);
   Error_SYS.Check_Not_Null(lu_name_, 'CREATION_DATE', newrec_.creation_date);
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
   newrec_ IN OUT customs_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ customs_info_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customs_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := 1;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO customs_info_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion);
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CUSTOMS_INFO_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CUSTOMS_INFO_PK') THEN
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
   newrec_ IN OUT customs_info_tab%ROWTYPE )
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
   newrec_ IN OUT customs_info_tab%ROWTYPE )
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
   oldrec_ IN     customs_info_tab%ROWTYPE,
   newrec_ IN OUT customs_info_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'CUSTOMS_ID', indrec_.customs_id);
   Validate_SYS.Item_Update(lu_name_, 'CREATION_DATE', indrec_.creation_date);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customs_info_tab%ROWTYPE,
   newrec_     IN OUT customs_info_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := newrec_.rowversion+1;
   IF by_keys_ THEN
      UPDATE customs_info_tab
         SET ROW = newrec_
         WHERE customs_id = newrec_.customs_id;
   ELSE
      UPDATE customs_info_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion);
   Invalidate_Cache___;
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CUSTOMS_INFO_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Customs_Info_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CUSTOMS_INFO_PK') THEN
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
   newrec_         IN OUT customs_info_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     customs_info_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.customs_id);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.customs_id);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
PROCEDURE Check_Delete___ (
   remrec_ IN customs_info_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.customs_id||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customs_info_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.customs_id||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  customs_info_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  customs_info_tab
         WHERE customs_id = remrec_.customs_id;
   END IF;
   Invalidate_Cache___;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN customs_info_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT customs_info_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     customs_info_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.customs_id);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.customs_id);
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
   dummy_ customs_info_tab%ROWTYPE;
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
   newrec_   customs_info_tab%ROWTYPE;
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
   oldrec_   customs_info_tab%ROWTYPE;
   newrec_   customs_info_tab%ROWTYPE;
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
   remrec_ customs_info_tab%ROWTYPE;
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
   rowkey_ IN VARCHAR2 ) RETURN customs_info_tab%ROWTYPE
IS
   rec_ customs_info_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customs_id
      INTO  rec_.customs_id
      FROM  customs_info_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.customs_id, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   customs_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(customs_id_)) THEN
      Raise_Record_Not_Exist___(customs_id_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   customs_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(customs_id_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   customs_id_ customs_info_tab.customs_id%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT customs_id
   INTO  customs_id_
   FROM  customs_info_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(customs_id_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customs_id_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Name
--   Fetches the Name attribute for a record.
@UncheckedAccess
FUNCTION Get_Name (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN micro_cache_value_.name;
END Get_Name;


-- Get_Creation_Date
--   Fetches the CreationDate attribute for a record.
@UncheckedAccess
FUNCTION Get_Creation_Date (
   customs_id_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN micro_cache_value_.creation_date;
END Get_Creation_Date;


-- Get_Association_No
--   Fetches the AssociationNo attribute for a record.
@UncheckedAccess
FUNCTION Get_Association_No (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN micro_cache_value_.association_no;
END Get_Association_No;


-- Get_Default_Language
--   Fetches the DefaultLanguage attribute for a record.
@UncheckedAccess
FUNCTION Get_Default_Language (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN Iso_Language_API.Decode(micro_cache_value_.default_language);
END Get_Default_Language;


-- Get_Default_Language_Db
--   Fetches the DB value of DefaultLanguage attribute for a record.
@UncheckedAccess
FUNCTION Get_Default_Language_Db (
   customs_id_ IN VARCHAR2 ) RETURN customs_info_tab.default_language%TYPE
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN micro_cache_value_.default_language;
END Get_Default_Language_Db;


-- Get_Country
--   Fetches the Country attribute for a record.
@UncheckedAccess
FUNCTION Get_Country (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN Iso_Country_API.Decode(micro_cache_value_.country);
END Get_Country;


-- Get_Country_Db
--   Fetches the DB value of Country attribute for a record.
@UncheckedAccess
FUNCTION Get_Country_Db (
   customs_id_ IN VARCHAR2 ) RETURN customs_info_tab.country%TYPE
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN micro_cache_value_.country;
END Get_Country_Db;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ customs_info_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.customs_id);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   customs_id_ IN VARCHAR2 ) RETURN Public_Rec
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN micro_cache_value_;
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   customs_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customs_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customs_id_);
   RETURN micro_cache_value_.rowkey;
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