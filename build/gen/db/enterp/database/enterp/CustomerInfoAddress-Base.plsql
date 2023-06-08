-----------------------------------------------------------------------------
--
--  Logical unit: CustomerInfoAddress
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
--  (customer_id                    CUSTOMER_INFO_ADDRESS_TAB.customer_id%TYPE,
--   address_id                     CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE);

TYPE Public_Rec IS RECORD
  (customer_id                    CUSTOMER_INFO_ADDRESS_TAB.customer_id%TYPE,
   address_id                     CUSTOMER_INFO_ADDRESS_TAB.address_id%TYPE,
   "rowid"                        rowid,
   rowversion                     CUSTOMER_INFO_ADDRESS_TAB.rowversion%TYPE,
   rowkey                         CUSTOMER_INFO_ADDRESS_TAB.rowkey%TYPE,
   name                           CUSTOMER_INFO_ADDRESS_TAB.name%TYPE,
   address                        CUSTOMER_INFO_ADDRESS_TAB.address%TYPE,
   ean_location                   CUSTOMER_INFO_ADDRESS_TAB.ean_location%TYPE,
   valid_from                     CUSTOMER_INFO_ADDRESS_TAB.valid_from%TYPE,
   valid_to                       CUSTOMER_INFO_ADDRESS_TAB.valid_to%TYPE,
   party                          CUSTOMER_INFO_ADDRESS_TAB.party%TYPE,
   country                        CUSTOMER_INFO_ADDRESS_TAB.country%TYPE,
   party_type                     CUSTOMER_INFO_ADDRESS_TAB.party_type%TYPE,
   secondary_contact              CUSTOMER_INFO_ADDRESS_TAB.secondary_contact%TYPE,
   primary_contact                CUSTOMER_INFO_ADDRESS_TAB.primary_contact%TYPE,
   address1                       CUSTOMER_INFO_ADDRESS_TAB.address1%TYPE,
   address2                       CUSTOMER_INFO_ADDRESS_TAB.address2%TYPE,
   address3                       CUSTOMER_INFO_ADDRESS_TAB.address3%TYPE,
   address4                       CUSTOMER_INFO_ADDRESS_TAB.address4%TYPE,
   address5                       CUSTOMER_INFO_ADDRESS_TAB.address5%TYPE,
   address6                       CUSTOMER_INFO_ADDRESS_TAB.address6%TYPE,
   zip_code                       CUSTOMER_INFO_ADDRESS_TAB.zip_code%TYPE,
   city                           CUSTOMER_INFO_ADDRESS_TAB.city%TYPE,
   county                         CUSTOMER_INFO_ADDRESS_TAB.county%TYPE,
   state                          CUSTOMER_INFO_ADDRESS_TAB.state%TYPE,
   in_city                        CUSTOMER_INFO_ADDRESS_TAB.in_city%TYPE,
   jurisdiction_code              CUSTOMER_INFO_ADDRESS_TAB.jurisdiction_code%TYPE,
   comm_id                        CUSTOMER_INFO_ADDRESS_TAB.comm_id%TYPE,
   output_media                   CUSTOMER_INFO_ADDRESS_TAB.output_media%TYPE,
   end_customer_id                CUSTOMER_INFO_ADDRESS_TAB.end_customer_id%TYPE,
   end_cust_addr_id               CUSTOMER_INFO_ADDRESS_TAB.end_cust_addr_id%TYPE,
   customer_branch                CUSTOMER_INFO_ADDRESS_TAB.customer_branch%TYPE);




-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE Indicator_Rec IS RECORD
  (customer_id                    BOOLEAN := FALSE,
   address_id                     BOOLEAN := FALSE,
   name                           BOOLEAN := FALSE,
   address                        BOOLEAN := FALSE,
   ean_location                   BOOLEAN := FALSE,
   valid_from                     BOOLEAN := FALSE,
   valid_to                       BOOLEAN := FALSE,
   party                          BOOLEAN := FALSE,
   default_domain                 BOOLEAN := FALSE,
   country                        BOOLEAN := FALSE,
   party_type                     BOOLEAN := FALSE,
   secondary_contact              BOOLEAN := FALSE,
   primary_contact                BOOLEAN := FALSE,
   address1                       BOOLEAN := FALSE,
   address2                       BOOLEAN := FALSE,
   address3                       BOOLEAN := FALSE,
   address4                       BOOLEAN := FALSE,
   address5                       BOOLEAN := FALSE,
   address6                       BOOLEAN := FALSE,
   zip_code                       BOOLEAN := FALSE,
   city                           BOOLEAN := FALSE,
   county                         BOOLEAN := FALSE,
   state                          BOOLEAN := FALSE,
   in_city                        BOOLEAN := FALSE,
   jurisdiction_code              BOOLEAN := FALSE,
   comm_id                        BOOLEAN := FALSE,
   output_media                   BOOLEAN := FALSE,
   end_customer_id                BOOLEAN := FALSE,
   end_cust_addr_id               BOOLEAN := FALSE,
   customer_branch                BOOLEAN := FALSE);

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
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
   req_id_     VARCHAR2(1000) := customer_id_||'^'||address_id_;
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
      SELECT customer_id, address_id,
             rowid, rowversion, rowkey,
             name, 
             address, 
             ean_location, 
             valid_from, 
             valid_to, 
             party, 
             country, 
             party_type, 
             secondary_contact, 
             primary_contact, 
             address1, 
             address2, 
             address3, 
             address4, 
             address5, 
             address6, 
             zip_code, 
             city, 
             county, 
             state, 
             in_city, 
             jurisdiction_code, 
             comm_id, 
             output_media, 
             end_customer_id, 
             end_cust_addr_id, 
             customer_branch
      INTO  micro_cache_value_
      FROM  customer_info_address_tab
      WHERE customer_id = customer_id_
      AND   address_id = address_id_;
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
      Raise_Too_Many_Rows___(customer_id_, address_id_, 'Update_Cache___');
END Update_Cache___;


-- Key_Message___
--    Returns an error message containing the keys.
FUNCTION Key_Message___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   msg_ VARCHAR2(4000) := Message_SYS.Construct('ERROR_KEY');
BEGIN
   Message_SYS.Add_Attribute(msg_, 'CUSTOMER_ID', customer_id_);
   Message_SYS.Add_Attribute(msg_, 'ADDRESS_ID', address_id_);
   RETURN msg_;
END Key_Message___;

-- Formatted_Key___
--    Returns an error string containing the keys.
FUNCTION Formatted_Key___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   formatted_key_ VARCHAR2(4000) := Language_SYS.Translate_Item_Prompt_(lu_name_, 'CUSTOMER_ID', Fnd_Session_API.Get_Language) || ': ' || customer_id_ || ', ' ||
                                    Language_SYS.Translate_Item_Prompt_(lu_name_, 'ADDRESS_ID', Fnd_Session_API.Get_Language) || ': ' || address_id_;
BEGIN
   RETURN formatted_key_;
END Formatted_Key___;

-- Raise_Too_Many_Rows___
--    Raises error for: More then one row found for a single key.
PROCEDURE Raise_Too_Many_Rows___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2,
   methodname_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customer_id_, address_id_),
                            Formatted_Key___(customer_id_, address_id_));
   Error_SYS.Fnd_Too_Many_Rows(Customer_Info_Address_API.lu_name_, NULL, methodname_);
END Raise_Too_Many_Rows___;


-- Raise_Record_Not_Exist___
--    Raises error for: No data found for given key.
PROCEDURE Raise_Record_Not_Exist___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customer_id_, address_id_),
                            Formatted_Key___(customer_id_, address_id_));
   Error_SYS.Fnd_Record_Not_Exist(Customer_Info_Address_API.lu_name_);
END Raise_Record_Not_Exist___;


-- Raise_Record_Exist___
--    Raises error for: Data with given key value already exist.
PROCEDURE Raise_Record_Exist___ (
   rec_ IN customer_info_address_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.customer_id, rec_.address_id),
                            Formatted_Key___(rec_.customer_id, rec_.address_id));
   Error_SYS.Fnd_Record_Exist(Customer_Info_Address_API.lu_name_);
END Raise_Record_Exist___;

-- Raise_Constraint_Violated___
--    Raises error for: Data with given value for constraint that already exist.
--    constraint_ contains the violated constraint to be used when overriding the method.
PROCEDURE Raise_Constraint_Violated___ (
   rec_ IN customer_info_address_tab%ROWTYPE,
   constraint_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Record_Exist(Customer_Info_Address_API.lu_name_);
END Raise_Constraint_Violated___;


-- Raise_Item_Format___
--    Raises error for: Data value format is incorrect.
PROCEDURE Raise_Item_Format___ (
   name_ IN VARCHAR2,
   value_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Fnd_Item_Format(Customer_Info_Address_API.lu_name_, name_, value_);
END Raise_Item_Format___;

-- Raise_Record_Modified___
--    Raises error for: The database row is newer then the current.
PROCEDURE Raise_Record_Modified___ (
   rec_ IN customer_info_address_tab%ROWTYPE )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(rec_.customer_id, rec_.address_id),
                            Formatted_Key___(rec_.customer_id, rec_.address_id));
   Error_SYS.Fnd_Record_Modified(Customer_Info_Address_API.lu_name_);
END Raise_Record_Modified___;


-- Raise_Record_Locked___
--    Raises error for: The database row is already locked.
PROCEDURE Raise_Record_Locked___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customer_id_, address_id_),
                            Formatted_Key___(customer_id_, address_id_));
   Error_SYS.Fnd_Record_Locked(Customer_Info_Address_API.lu_name_);
END Raise_Record_Locked___;


-- Raise_Record_Removed___
--    Raises error for: The database row is no longer present.
PROCEDURE Raise_Record_Removed___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Set_Key_Values(Key_Message___(customer_id_, address_id_),
                            Formatted_Key___(customer_id_, address_id_));
   Error_SYS.Fnd_Record_Removed(Customer_Info_Address_API.lu_name_);
END Raise_Record_Removed___;


-- Lock_By_Id___
--    Locks a database row based on the objid and objversion.
FUNCTION Lock_By_Id___ (
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2 ) RETURN customer_info_address_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        customer_info_address_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  rec_
      FROM  customer_info_address_tab
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
            FROM  customer_info_address_tab
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
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2) RETURN customer_info_address_tab%ROWTYPE
IS
   rec_        customer_info_address_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  customer_info_address_tab
         WHERE customer_id = customer_id_
         AND   address_id = address_id_
         FOR UPDATE;
      RETURN rec_;
   EXCEPTION
      WHEN no_data_found THEN
         Raise_Record_Removed___(customer_id_, address_id_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(customer_id_, address_id_, 'Lock_By_Keys___');
   END;
END Lock_By_Keys___;


-- Lock_By_Keys_Nowait___
--    Locks a database row based on the primary key values.
--    Raises exception if row already locked.
FUNCTION Lock_By_Keys_Nowait___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2) RETURN customer_info_address_tab%ROWTYPE
IS
   row_locked  EXCEPTION;
   PRAGMA      EXCEPTION_INIT(row_locked, -0054);
   rec_        customer_info_address_tab%ROWTYPE;
BEGIN
   BEGIN
      SELECT *
         INTO  rec_
         FROM  customer_info_address_tab
         WHERE customer_id = customer_id_
         AND   address_id = address_id_
         FOR UPDATE NOWAIT;
      RETURN rec_;
   EXCEPTION
      WHEN row_locked THEN
         Raise_Record_Locked___(customer_id_, address_id_);
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(customer_id_, address_id_, 'Lock_By_Keys___');
      WHEN no_data_found THEN
         Raise_Record_Removed___(customer_id_, address_id_);
   END;
END Lock_By_Keys_Nowait___;


-- Get_Object_By_Id___
--    Fetched a database row based on given the objid.
FUNCTION Get_Object_By_Id___ (
   objid_ IN VARCHAR2 ) RETURN customer_info_address_tab%ROWTYPE
IS
   lu_rec_ customer_info_address_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  customer_info_address_tab
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
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN customer_info_address_tab%ROWTYPE
IS
   lu_rec_ customer_info_address_tab%ROWTYPE;
BEGIN
   SELECT *
      INTO  lu_rec_
      FROM  customer_info_address_tab
      WHERE customer_id = customer_id_
      AND   address_id = address_id_;
   RETURN lu_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN lu_rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customer_id_, address_id_, 'Get_Object_By_Keys___');
END Get_Object_By_Keys___;


-- Check_Exist___
--    Checks if a database row is already stored based on the primary key values.
@UncheckedAccess
FUNCTION Check_Exist___ (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   SELECT 1
      INTO  dummy_
      FROM  customer_info_address_tab
      WHERE customer_id = customer_id_
      AND   address_id = address_id_;
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customer_id_, address_id_, 'Check_Exist___');
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
      FROM  customer_info_address_tab
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
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
   SELECT rowid, to_char(rowversion,'YYYYMMDDHH24MISS')
      INTO  objid_, objversion_
      FROM  customer_info_address_tab
      WHERE customer_id = customer_id_
      AND   address_id = address_id_;
EXCEPTION
   WHEN no_data_found THEN
      objid_      := NULL;
      objversion_ := NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customer_id_, address_id_, 'Get_Id_Version_By_Keys___');
END Get_Id_Version_By_Keys___;


-- Unpack___
--   Reads an attribute string and unpacks its contents into a record.
PROCEDURE Unpack___ (
   newrec_   IN OUT customer_info_address_tab%ROWTYPE,
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
      WHEN ('CUSTOMER_ID') THEN
         newrec_.customer_id := value_;
         indrec_.customer_id := TRUE;
      WHEN ('ADDRESS_ID') THEN
         newrec_.address_id := value_;
         indrec_.address_id := TRUE;
      WHEN ('NAME') THEN
         newrec_.name := value_;
         indrec_.name := TRUE;
      WHEN ('ADDRESS') THEN
         newrec_.address := value_;
         indrec_.address := TRUE;
      WHEN ('EAN_LOCATION') THEN
         newrec_.ean_location := value_;
         indrec_.ean_location := TRUE;
      WHEN ('VALID_FROM') THEN
         newrec_.valid_from := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.valid_from := TRUE;
      WHEN ('VALID_TO') THEN
         newrec_.valid_to := Client_SYS.Attr_Value_To_Date(value_);
         indrec_.valid_to := TRUE;
      WHEN ('PARTY') THEN
         newrec_.party := value_;
         indrec_.party := TRUE;
      WHEN ('DEFAULT_DOMAIN') THEN
         IF (value_ IS NULL OR value_ = 'TRUE' OR value_ = 'FALSE') THEN
            newrec_.default_domain := value_;
         ELSE
            RAISE value_error;
         END IF;
         indrec_.default_domain := TRUE;
      WHEN ('COUNTRY') THEN
         newrec_.country := Iso_Country_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.country IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.country := TRUE;
      WHEN ('COUNTRY_DB') THEN
         newrec_.country := value_;
         indrec_.country := TRUE;
      WHEN ('PARTY_TYPE') THEN
         newrec_.party_type := Party_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.party_type IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.party_type := TRUE;
      WHEN ('PARTY_TYPE_DB') THEN
         newrec_.party_type := value_;
         indrec_.party_type := TRUE;
      WHEN ('SECONDARY_CONTACT') THEN
         newrec_.secondary_contact := value_;
         indrec_.secondary_contact := TRUE;
      WHEN ('PRIMARY_CONTACT') THEN
         newrec_.primary_contact := value_;
         indrec_.primary_contact := TRUE;
      WHEN ('ADDRESS1') THEN
         newrec_.address1 := value_;
         indrec_.address1 := TRUE;
      WHEN ('ADDRESS2') THEN
         newrec_.address2 := value_;
         indrec_.address2 := TRUE;
      WHEN ('ADDRESS3') THEN
         newrec_.address3 := value_;
         indrec_.address3 := TRUE;
      WHEN ('ADDRESS4') THEN
         newrec_.address4 := value_;
         indrec_.address4 := TRUE;
      WHEN ('ADDRESS5') THEN
         newrec_.address5 := value_;
         indrec_.address5 := TRUE;
      WHEN ('ADDRESS6') THEN
         newrec_.address6 := value_;
         indrec_.address6 := TRUE;
      WHEN ('ZIP_CODE') THEN
         newrec_.zip_code := value_;
         indrec_.zip_code := TRUE;
      WHEN ('CITY') THEN
         newrec_.city := value_;
         indrec_.city := TRUE;
      WHEN ('COUNTY') THEN
         newrec_.county := value_;
         indrec_.county := TRUE;
      WHEN ('STATE') THEN
         newrec_.state := value_;
         indrec_.state := TRUE;
      WHEN ('IN_CITY') THEN
         newrec_.in_city := value_;
         indrec_.in_city := TRUE;
      WHEN ('JURISDICTION_CODE') THEN
         newrec_.jurisdiction_code := value_;
         indrec_.jurisdiction_code := TRUE;
      WHEN ('COMM_ID') THEN
         newrec_.comm_id := Client_SYS.Attr_Value_To_Number(value_);
         indrec_.comm_id := TRUE;
      WHEN ('OUTPUT_MEDIA') THEN
         newrec_.output_media := Output_Media_Type_API.Encode(value_);
         IF (value_ IS NOT NULL AND newrec_.output_media IS NULL) THEN
            RAISE value_error;
         END IF;
         indrec_.output_media := TRUE;
      WHEN ('OUTPUT_MEDIA_DB') THEN
         newrec_.output_media := value_;
         indrec_.output_media := TRUE;
      WHEN ('END_CUSTOMER_ID') THEN
         newrec_.end_customer_id := value_;
         indrec_.end_customer_id := TRUE;
      WHEN ('END_CUST_ADDR_ID') THEN
         newrec_.end_cust_addr_id := value_;
         indrec_.end_cust_addr_id := TRUE;
      WHEN ('CUSTOMER_BRANCH') THEN
         newrec_.customer_branch := value_;
         indrec_.customer_branch := TRUE;
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
   rec_ IN customer_info_address_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (rec_.customer_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_ID', rec_.customer_id, attr_);
   END IF;
   IF (rec_.address_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS_ID', rec_.address_id, attr_);
   END IF;
   IF (rec_.name IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('NAME', rec_.name, attr_);
   END IF;
   IF (rec_.address IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS', rec_.address, attr_);
   END IF;
   IF (rec_.ean_location IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('EAN_LOCATION', rec_.ean_location, attr_);
   END IF;
   IF (rec_.valid_from IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VALID_FROM', rec_.valid_from, attr_);
   END IF;
   IF (rec_.valid_to IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('VALID_TO', rec_.valid_to, attr_);
   END IF;
   IF (rec_.party IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PARTY', rec_.party, attr_);
   END IF;
   IF (rec_.default_domain IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', rec_.default_domain, attr_);
   END IF;
   IF (rec_.country IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTRY', Iso_Country_API.Decode(rec_.country), attr_);
      Client_SYS.Add_To_Attr('COUNTRY_DB', rec_.country, attr_);
   END IF;
   IF (rec_.party_type IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode(rec_.party_type), attr_);
      Client_SYS.Add_To_Attr('PARTY_TYPE_DB', rec_.party_type, attr_);
   END IF;
   IF (rec_.secondary_contact IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('SECONDARY_CONTACT', rec_.secondary_contact, attr_);
   END IF;
   IF (rec_.primary_contact IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('PRIMARY_CONTACT', rec_.primary_contact, attr_);
   END IF;
   IF (rec_.address1 IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS1', rec_.address1, attr_);
   END IF;
   IF (rec_.address2 IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS2', rec_.address2, attr_);
   END IF;
   IF (rec_.address3 IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS3', rec_.address3, attr_);
   END IF;
   IF (rec_.address4 IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS4', rec_.address4, attr_);
   END IF;
   IF (rec_.address5 IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS5', rec_.address5, attr_);
   END IF;
   IF (rec_.address6 IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ADDRESS6', rec_.address6, attr_);
   END IF;
   IF (rec_.zip_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('ZIP_CODE', rec_.zip_code, attr_);
   END IF;
   IF (rec_.city IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CITY', rec_.city, attr_);
   END IF;
   IF (rec_.county IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COUNTY', rec_.county, attr_);
   END IF;
   IF (rec_.state IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('STATE', rec_.state, attr_);
   END IF;
   IF (rec_.in_city IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('IN_CITY', rec_.in_city, attr_);
   END IF;
   IF (rec_.jurisdiction_code IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('JURISDICTION_CODE', rec_.jurisdiction_code, attr_);
   END IF;
   IF (rec_.comm_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('COMM_ID', rec_.comm_id, attr_);
   END IF;
   IF (rec_.output_media IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('OUTPUT_MEDIA', Output_Media_Type_API.Decode(rec_.output_media), attr_);
      Client_SYS.Add_To_Attr('OUTPUT_MEDIA_DB', rec_.output_media, attr_);
   END IF;
   IF (rec_.end_customer_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('END_CUSTOMER_ID', rec_.end_customer_id, attr_);
   END IF;
   IF (rec_.end_cust_addr_id IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('END_CUST_ADDR_ID', rec_.end_cust_addr_id, attr_);
   END IF;
   IF (rec_.customer_branch IS NOT NULL) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_BRANCH', rec_.customer_branch, attr_);
   END IF;
   RETURN attr_;
END Pack___;


FUNCTION Pack___ (
   rec_ IN customer_info_address_tab%ROWTYPE,
   indrec_ IN Indicator_Rec ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (indrec_.customer_id) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_ID', rec_.customer_id, attr_);
   END IF;
   IF (indrec_.address_id) THEN
      Client_SYS.Add_To_Attr('ADDRESS_ID', rec_.address_id, attr_);
   END IF;
   IF (indrec_.name) THEN
      Client_SYS.Add_To_Attr('NAME', rec_.name, attr_);
   END IF;
   IF (indrec_.address) THEN
      Client_SYS.Add_To_Attr('ADDRESS', rec_.address, attr_);
   END IF;
   IF (indrec_.ean_location) THEN
      Client_SYS.Add_To_Attr('EAN_LOCATION', rec_.ean_location, attr_);
   END IF;
   IF (indrec_.valid_from) THEN
      Client_SYS.Add_To_Attr('VALID_FROM', rec_.valid_from, attr_);
   END IF;
   IF (indrec_.valid_to) THEN
      Client_SYS.Add_To_Attr('VALID_TO', rec_.valid_to, attr_);
   END IF;
   IF (indrec_.party) THEN
      Client_SYS.Add_To_Attr('PARTY', rec_.party, attr_);
   END IF;
   IF (indrec_.default_domain) THEN
      Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', rec_.default_domain, attr_);
   END IF;
   IF (indrec_.country) THEN
      Client_SYS.Add_To_Attr('COUNTRY', Iso_Country_API.Decode(rec_.country), attr_);
      Client_SYS.Add_To_Attr('COUNTRY_DB', rec_.country, attr_);
   END IF;
   IF (indrec_.party_type) THEN
      Client_SYS.Add_To_Attr('PARTY_TYPE', Party_Type_API.Decode(rec_.party_type), attr_);
      Client_SYS.Add_To_Attr('PARTY_TYPE_DB', rec_.party_type, attr_);
   END IF;
   IF (indrec_.secondary_contact) THEN
      Client_SYS.Add_To_Attr('SECONDARY_CONTACT', rec_.secondary_contact, attr_);
   END IF;
   IF (indrec_.primary_contact) THEN
      Client_SYS.Add_To_Attr('PRIMARY_CONTACT', rec_.primary_contact, attr_);
   END IF;
   IF (indrec_.address1) THEN
      Client_SYS.Add_To_Attr('ADDRESS1', rec_.address1, attr_);
   END IF;
   IF (indrec_.address2) THEN
      Client_SYS.Add_To_Attr('ADDRESS2', rec_.address2, attr_);
   END IF;
   IF (indrec_.address3) THEN
      Client_SYS.Add_To_Attr('ADDRESS3', rec_.address3, attr_);
   END IF;
   IF (indrec_.address4) THEN
      Client_SYS.Add_To_Attr('ADDRESS4', rec_.address4, attr_);
   END IF;
   IF (indrec_.address5) THEN
      Client_SYS.Add_To_Attr('ADDRESS5', rec_.address5, attr_);
   END IF;
   IF (indrec_.address6) THEN
      Client_SYS.Add_To_Attr('ADDRESS6', rec_.address6, attr_);
   END IF;
   IF (indrec_.zip_code) THEN
      Client_SYS.Add_To_Attr('ZIP_CODE', rec_.zip_code, attr_);
   END IF;
   IF (indrec_.city) THEN
      Client_SYS.Add_To_Attr('CITY', rec_.city, attr_);
   END IF;
   IF (indrec_.county) THEN
      Client_SYS.Add_To_Attr('COUNTY', rec_.county, attr_);
   END IF;
   IF (indrec_.state) THEN
      Client_SYS.Add_To_Attr('STATE', rec_.state, attr_);
   END IF;
   IF (indrec_.in_city) THEN
      Client_SYS.Add_To_Attr('IN_CITY', rec_.in_city, attr_);
   END IF;
   IF (indrec_.jurisdiction_code) THEN
      Client_SYS.Add_To_Attr('JURISDICTION_CODE', rec_.jurisdiction_code, attr_);
   END IF;
   IF (indrec_.comm_id) THEN
      Client_SYS.Add_To_Attr('COMM_ID', rec_.comm_id, attr_);
   END IF;
   IF (indrec_.output_media) THEN
      Client_SYS.Add_To_Attr('OUTPUT_MEDIA', Output_Media_Type_API.Decode(rec_.output_media), attr_);
      Client_SYS.Add_To_Attr('OUTPUT_MEDIA_DB', rec_.output_media, attr_);
   END IF;
   IF (indrec_.end_customer_id) THEN
      Client_SYS.Add_To_Attr('END_CUSTOMER_ID', rec_.end_customer_id, attr_);
   END IF;
   IF (indrec_.end_cust_addr_id) THEN
      Client_SYS.Add_To_Attr('END_CUST_ADDR_ID', rec_.end_cust_addr_id, attr_);
   END IF;
   IF (indrec_.customer_branch) THEN
      Client_SYS.Add_To_Attr('CUSTOMER_BRANCH', rec_.customer_branch, attr_);
   END IF;
   RETURN attr_;
END Pack___;



-- Pack_Table___
--   Reads a record and packs its contents into an attribute string.
--   Similar to Pack___ but just uses table column names and DB values
FUNCTION Pack_Table___ (
   rec_ IN customer_info_address_tab%ROWTYPE ) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_ID', rec_.customer_id, attr_);
   Client_SYS.Add_To_Attr('ADDRESS_ID', rec_.address_id, attr_);
   Client_SYS.Add_To_Attr('NAME', rec_.name, attr_);
   Client_SYS.Add_To_Attr('ADDRESS', rec_.address, attr_);
   Client_SYS.Add_To_Attr('EAN_LOCATION', rec_.ean_location, attr_);
   Client_SYS.Add_To_Attr('VALID_FROM', rec_.valid_from, attr_);
   Client_SYS.Add_To_Attr('VALID_TO', rec_.valid_to, attr_);
   Client_SYS.Add_To_Attr('PARTY', rec_.party, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_DOMAIN', rec_.default_domain, attr_);
   Client_SYS.Add_To_Attr('COUNTRY', rec_.country, attr_);
   Client_SYS.Add_To_Attr('PARTY_TYPE', rec_.party_type, attr_);
   Client_SYS.Add_To_Attr('SECONDARY_CONTACT', rec_.secondary_contact, attr_);
   Client_SYS.Add_To_Attr('PRIMARY_CONTACT', rec_.primary_contact, attr_);
   Client_SYS.Add_To_Attr('ADDRESS1', rec_.address1, attr_);
   Client_SYS.Add_To_Attr('ADDRESS2', rec_.address2, attr_);
   Client_SYS.Add_To_Attr('ADDRESS3', rec_.address3, attr_);
   Client_SYS.Add_To_Attr('ADDRESS4', rec_.address4, attr_);
   Client_SYS.Add_To_Attr('ADDRESS5', rec_.address5, attr_);
   Client_SYS.Add_To_Attr('ADDRESS6', rec_.address6, attr_);
   Client_SYS.Add_To_Attr('ZIP_CODE', rec_.zip_code, attr_);
   Client_SYS.Add_To_Attr('CITY', rec_.city, attr_);
   Client_SYS.Add_To_Attr('COUNTY', rec_.county, attr_);
   Client_SYS.Add_To_Attr('STATE', rec_.state, attr_);
   Client_SYS.Add_To_Attr('IN_CITY', rec_.in_city, attr_);
   Client_SYS.Add_To_Attr('JURISDICTION_CODE', rec_.jurisdiction_code, attr_);
   Client_SYS.Add_To_Attr('COMM_ID', rec_.comm_id, attr_);
   Client_SYS.Add_To_Attr('OUTPUT_MEDIA', rec_.output_media, attr_);
   Client_SYS.Add_To_Attr('END_CUSTOMER_ID', rec_.end_customer_id, attr_);
   Client_SYS.Add_To_Attr('END_CUST_ADDR_ID', rec_.end_cust_addr_id, attr_);
   Client_SYS.Add_To_Attr('CUSTOMER_BRANCH', rec_.customer_branch, attr_);
   Client_SYS.Add_To_Attr('ROWKEY', rec_.rowkey, attr_);
   RETURN attr_;
END Pack_Table___;



-- Public_To_Table___
--   Reads values in the public_rec record and returns them in a table rowtype record.
FUNCTION Public_To_Table___ (
   public_ IN Public_Rec ) RETURN customer_info_address_tab%ROWTYPE
IS
   rec_ customer_info_address_tab%ROWTYPE;
BEGIN
   rec_.rowversion                     := public_.rowversion;
   rec_.rowkey                         := public_.rowkey;
   rec_.customer_id                    := public_.customer_id;
   rec_.address_id                     := public_.address_id;
   rec_.name                           := public_.name;
   rec_.address                        := public_.address;
   rec_.ean_location                   := public_.ean_location;
   rec_.valid_from                     := public_.valid_from;
   rec_.valid_to                       := public_.valid_to;
   rec_.party                          := public_.party;
   rec_.country                        := public_.country;
   rec_.party_type                     := public_.party_type;
   rec_.secondary_contact              := public_.secondary_contact;
   rec_.primary_contact                := public_.primary_contact;
   rec_.address1                       := public_.address1;
   rec_.address2                       := public_.address2;
   rec_.address3                       := public_.address3;
   rec_.address4                       := public_.address4;
   rec_.address5                       := public_.address5;
   rec_.address6                       := public_.address6;
   rec_.zip_code                       := public_.zip_code;
   rec_.city                           := public_.city;
   rec_.county                         := public_.county;
   rec_.state                          := public_.state;
   rec_.in_city                        := public_.in_city;
   rec_.jurisdiction_code              := public_.jurisdiction_code;
   rec_.comm_id                        := public_.comm_id;
   rec_.output_media                   := public_.output_media;
   rec_.end_customer_id                := public_.end_customer_id;
   rec_.end_cust_addr_id               := public_.end_cust_addr_id;
   rec_.customer_branch                := public_.customer_branch;
   RETURN rec_;
END Public_To_Table___;



-- Table_To_Public___
--   Reads values in the table rowtype record and returns them in a public_rec record.
FUNCTION Table_To_Public___ (
   rec_ IN customer_info_address_tab%ROWTYPE ) RETURN Public_Rec
IS
   public_ Public_Rec;
BEGIN
   public_.rowversion                     := rec_.rowversion;
   public_.rowkey                         := rec_.rowkey;
   public_.customer_id                    := rec_.customer_id;
   public_.address_id                     := rec_.address_id;
   public_.name                           := rec_.name;
   public_.address                        := rec_.address;
   public_.ean_location                   := rec_.ean_location;
   public_.valid_from                     := rec_.valid_from;
   public_.valid_to                       := rec_.valid_to;
   public_.party                          := rec_.party;
   public_.country                        := rec_.country;
   public_.party_type                     := rec_.party_type;
   public_.secondary_contact              := rec_.secondary_contact;
   public_.primary_contact                := rec_.primary_contact;
   public_.address1                       := rec_.address1;
   public_.address2                       := rec_.address2;
   public_.address3                       := rec_.address3;
   public_.address4                       := rec_.address4;
   public_.address5                       := rec_.address5;
   public_.address6                       := rec_.address6;
   public_.zip_code                       := rec_.zip_code;
   public_.city                           := rec_.city;
   public_.county                         := rec_.county;
   public_.state                          := rec_.state;
   public_.in_city                        := rec_.in_city;
   public_.jurisdiction_code              := rec_.jurisdiction_code;
   public_.comm_id                        := rec_.comm_id;
   public_.output_media                   := rec_.output_media;
   public_.end_customer_id                := rec_.end_customer_id;
   public_.end_cust_addr_id               := rec_.end_cust_addr_id;
   public_.customer_branch                := rec_.customer_branch;
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
   rec_ IN customer_info_address_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.customer_id := rec_.customer_id IS NOT NULL;
   indrec_.address_id := rec_.address_id IS NOT NULL;
   indrec_.name := rec_.name IS NOT NULL;
   indrec_.address := rec_.address IS NOT NULL;
   indrec_.ean_location := rec_.ean_location IS NOT NULL;
   indrec_.valid_from := rec_.valid_from IS NOT NULL;
   indrec_.valid_to := rec_.valid_to IS NOT NULL;
   indrec_.party := rec_.party IS NOT NULL;
   indrec_.default_domain := rec_.default_domain IS NOT NULL;
   indrec_.country := rec_.country IS NOT NULL;
   indrec_.party_type := rec_.party_type IS NOT NULL;
   indrec_.secondary_contact := rec_.secondary_contact IS NOT NULL;
   indrec_.primary_contact := rec_.primary_contact IS NOT NULL;
   indrec_.address1 := rec_.address1 IS NOT NULL;
   indrec_.address2 := rec_.address2 IS NOT NULL;
   indrec_.address3 := rec_.address3 IS NOT NULL;
   indrec_.address4 := rec_.address4 IS NOT NULL;
   indrec_.address5 := rec_.address5 IS NOT NULL;
   indrec_.address6 := rec_.address6 IS NOT NULL;
   indrec_.zip_code := rec_.zip_code IS NOT NULL;
   indrec_.city := rec_.city IS NOT NULL;
   indrec_.county := rec_.county IS NOT NULL;
   indrec_.state := rec_.state IS NOT NULL;
   indrec_.in_city := rec_.in_city IS NOT NULL;
   indrec_.jurisdiction_code := rec_.jurisdiction_code IS NOT NULL;
   indrec_.comm_id := rec_.comm_id IS NOT NULL;
   indrec_.output_media := rec_.output_media IS NOT NULL;
   indrec_.end_customer_id := rec_.end_customer_id IS NOT NULL;
   indrec_.end_cust_addr_id := rec_.end_cust_addr_id IS NOT NULL;
   indrec_.customer_branch := rec_.customer_branch IS NOT NULL;
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Get_Indicator_Rec___
--   Returns an Indicator_Rec that reflects the difference between two table records.
FUNCTION Get_Indicator_Rec___ (
   oldrec_ IN customer_info_address_tab%ROWTYPE,
   newrec_ IN customer_info_address_tab%ROWTYPE ) RETURN Indicator_Rec
IS
   indrec_ Indicator_Rec;
BEGIN
   indrec_.customer_id := Validate_SYS.Is_Changed(oldrec_.customer_id, newrec_.customer_id);
   indrec_.address_id := Validate_SYS.Is_Changed(oldrec_.address_id, newrec_.address_id);
   indrec_.name := Validate_SYS.Is_Changed(oldrec_.name, newrec_.name);
   indrec_.address := Validate_SYS.Is_Changed(oldrec_.address, newrec_.address);
   indrec_.ean_location := Validate_SYS.Is_Changed(oldrec_.ean_location, newrec_.ean_location);
   indrec_.valid_from := Validate_SYS.Is_Changed(oldrec_.valid_from, newrec_.valid_from);
   indrec_.valid_to := Validate_SYS.Is_Changed(oldrec_.valid_to, newrec_.valid_to);
   indrec_.party := Validate_SYS.Is_Changed(oldrec_.party, newrec_.party);
   indrec_.default_domain := Validate_SYS.Is_Changed(oldrec_.default_domain, newrec_.default_domain);
   indrec_.country := Validate_SYS.Is_Changed(oldrec_.country, newrec_.country);
   indrec_.party_type := Validate_SYS.Is_Changed(oldrec_.party_type, newrec_.party_type);
   indrec_.secondary_contact := Validate_SYS.Is_Changed(oldrec_.secondary_contact, newrec_.secondary_contact);
   indrec_.primary_contact := Validate_SYS.Is_Changed(oldrec_.primary_contact, newrec_.primary_contact);
   indrec_.address1 := Validate_SYS.Is_Changed(oldrec_.address1, newrec_.address1);
   indrec_.address2 := Validate_SYS.Is_Changed(oldrec_.address2, newrec_.address2);
   indrec_.address3 := Validate_SYS.Is_Changed(oldrec_.address3, newrec_.address3);
   indrec_.address4 := Validate_SYS.Is_Changed(oldrec_.address4, newrec_.address4);
   indrec_.address5 := Validate_SYS.Is_Changed(oldrec_.address5, newrec_.address5);
   indrec_.address6 := Validate_SYS.Is_Changed(oldrec_.address6, newrec_.address6);
   indrec_.zip_code := Validate_SYS.Is_Changed(oldrec_.zip_code, newrec_.zip_code);
   indrec_.city := Validate_SYS.Is_Changed(oldrec_.city, newrec_.city);
   indrec_.county := Validate_SYS.Is_Changed(oldrec_.county, newrec_.county);
   indrec_.state := Validate_SYS.Is_Changed(oldrec_.state, newrec_.state);
   indrec_.in_city := Validate_SYS.Is_Changed(oldrec_.in_city, newrec_.in_city);
   indrec_.jurisdiction_code := Validate_SYS.Is_Changed(oldrec_.jurisdiction_code, newrec_.jurisdiction_code);
   indrec_.comm_id := Validate_SYS.Is_Changed(oldrec_.comm_id, newrec_.comm_id);
   indrec_.output_media := Validate_SYS.Is_Changed(oldrec_.output_media, newrec_.output_media);
   indrec_.end_customer_id := Validate_SYS.Is_Changed(oldrec_.end_customer_id, newrec_.end_customer_id);
   indrec_.end_cust_addr_id := Validate_SYS.Is_Changed(oldrec_.end_cust_addr_id, newrec_.end_cust_addr_id);
   indrec_.customer_branch := Validate_SYS.Is_Changed(oldrec_.customer_branch, newrec_.customer_branch);
   RETURN indrec_;
END Get_Indicator_Rec___;


-- Check_Customer_Id_Ref___
--   Perform validation on the CustomerIdRef reference.
PROCEDURE Check_Customer_Id_Ref___ (
   newrec_ IN OUT customer_info_address_tab%ROWTYPE );


-- Check_End_Customer_Id_Ref___
--   Perform validation on the EndCustomerIdRef reference.
PROCEDURE Check_End_Customer_Id_Ref___ (
   newrec_ IN OUT customer_info_address_tab%ROWTYPE );


-- Check_Common___
--   Perform validations on a record, that should be done for both insert and delete.
PROCEDURE Check_Common___ (
   oldrec_ IN     customer_info_address_tab%ROWTYPE,
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.address_id IS NOT NULL
       AND indrec_.address_id
       AND Validate_SYS.Is_Changed(oldrec_.address_id, newrec_.address_id)) THEN
      Error_SYS.Check_Upper(lu_name_, 'ADDRESS_ID', newrec_.address_id);
   END IF;
   IF (newrec_.zip_code IS NOT NULL
       AND indrec_.zip_code
       AND Validate_SYS.Is_Changed(oldrec_.zip_code, newrec_.zip_code)) THEN
      Error_SYS.Check_Upper(lu_name_, 'ZIP_CODE', newrec_.zip_code);
   END IF;
   IF (newrec_.customer_branch IS NOT NULL
       AND indrec_.customer_branch
       AND Validate_SYS.Is_Changed(oldrec_.customer_branch, newrec_.customer_branch)) THEN
      Error_SYS.Check_Upper(lu_name_, 'CUSTOMER_BRANCH', newrec_.customer_branch);
   END IF;
   IF (newrec_.country IS NOT NULL)
   AND (indrec_.country)
   AND (Validate_SYS.Is_Changed(oldrec_.country, newrec_.country)) THEN
      Iso_Country_API.Exist(newrec_.country);
   END IF;
   IF (newrec_.party_type IS NOT NULL)
   AND (indrec_.party_type)
   AND (Validate_SYS.Is_Changed(oldrec_.party_type, newrec_.party_type)) THEN
      Party_Type_API.Exist_Db(newrec_.party_type);
   END IF;
   IF (newrec_.output_media IS NOT NULL)
   AND (indrec_.output_media)
   AND (Validate_SYS.Is_Changed(oldrec_.output_media, newrec_.output_media)) THEN
      Output_Media_Type_API.Exist_Db(newrec_.output_media);
   END IF;
   IF (newrec_.customer_id IS NOT NULL)
   AND (indrec_.customer_id)
   AND (Validate_SYS.Is_Changed(oldrec_.customer_id, newrec_.customer_id)) THEN
      Check_Customer_Id_Ref___(newrec_);
   END IF;
   IF (newrec_.party_type IS NOT NULL AND newrec_.customer_id IS NOT NULL AND newrec_.comm_id IS NOT NULL)
   AND (indrec_.party_type OR indrec_.customer_id OR indrec_.comm_id)
   AND (Validate_SYS.Is_Changed(oldrec_.party_type, newrec_.party_type)
     OR Validate_SYS.Is_Changed(oldrec_.customer_id, newrec_.customer_id)
     OR Validate_SYS.Is_Changed(oldrec_.comm_id, newrec_.comm_id)) THEN
      Comm_Method_API.Exist_Db(newrec_.party_type, newrec_.customer_id, newrec_.comm_id);
   END IF;
   IF (newrec_.end_customer_id IS NOT NULL)
   AND (indrec_.end_customer_id)
   AND (Validate_SYS.Is_Changed(oldrec_.end_customer_id, newrec_.end_customer_id)) THEN
      Check_End_Customer_Id_Ref___(newrec_);
   END IF;
   IF (newrec_.end_customer_id IS NOT NULL AND newrec_.end_cust_addr_id IS NOT NULL)
   AND (indrec_.end_customer_id OR indrec_.end_cust_addr_id)
   AND (Validate_SYS.Is_Changed(oldrec_.end_customer_id, newrec_.end_customer_id)
     OR Validate_SYS.Is_Changed(oldrec_.end_cust_addr_id, newrec_.end_cust_addr_id)) THEN
      Customer_Info_Address_API.Exist(newrec_.end_customer_id, newrec_.end_cust_addr_id);
   END IF;
   Error_SYS.Check_Not_Null(lu_name_, 'CUSTOMER_ID', newrec_.customer_id);
   Error_SYS.Check_Not_Null(lu_name_, 'ADDRESS_ID', newrec_.address_id);
   Error_SYS.Check_Not_Null(lu_name_, 'DEFAULT_DOMAIN', newrec_.default_domain);
   Error_SYS.Check_Not_Null(lu_name_, 'COUNTRY', newrec_.country);
   Error_SYS.Check_Not_Null(lu_name_, 'PARTY_TYPE', newrec_.party_type);
   Error_SYS.Check_Not_Null(lu_name_, 'IN_CITY', newrec_.in_city);
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
@RmcomAccessCheck CustomerInfo(customer_id), BelongToParent
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   oldrec_ customer_info_address_tab%ROWTYPE;
BEGIN
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Insert___;


-- Insert___
--   Insert a record to the database.
@RmcomAccessCheck CustomerInfo(customer_id), BelongToParent
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT customer_info_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   newrec_.rowkey := sys_guid();
   Client_SYS.Add_To_Attr('OBJKEY', newrec_.rowkey, attr_);
   INSERT
      INTO customer_info_address_tab
      VALUES newrec_
      RETURNING rowid INTO objid_;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CUSTOMER_INFO_ADDRESS_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CUSTOMER_INFO_ADDRESS_PK') THEN
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
   newrec_ IN OUT customer_info_address_tab%ROWTYPE )
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
   newrec_ IN OUT customer_info_address_tab%ROWTYPE )
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
@RmcomAccessCheck CustomerInfo(customer_id), BelongToParent
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_info_address_tab%ROWTYPE,
   newrec_ IN OUT customer_info_address_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Validate_SYS.Item_Update(lu_name_, 'CUSTOMER_ID', indrec_.customer_id);
   Validate_SYS.Item_Update(lu_name_, 'ADDRESS_ID', indrec_.address_id);
   Check_Common___(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


-- Update___
--   Update a record in database with new data.
@RmcomAccessCheck CustomerInfo(customer_id), BelongToParent
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     customer_info_address_tab%ROWTYPE,
   newrec_     IN OUT customer_info_address_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
   value_too_large  EXCEPTION;
   PRAGMA           EXCEPTION_INIT(value_too_large, -12899);
BEGIN
   newrec_.rowversion := sysdate;
   IF by_keys_ THEN
      UPDATE customer_info_address_tab
         SET ROW = newrec_
         WHERE customer_id = newrec_.customer_id
         AND   address_id = newrec_.address_id;
   ELSE
      UPDATE customer_info_address_tab
         SET ROW = newrec_
         WHERE rowid = objid_;
   END IF;
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   Invalidate_Cache___;
EXCEPTION
   WHEN dup_val_on_index THEN
      DECLARE
         constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
      BEGIN
         IF (constraint_ = 'CUSTOMER_INFO_ADDRESS_RK') THEN
            Error_SYS.Fnd_Rowkey_Exist(Customer_Info_Address_API.lu_name_, newrec_.rowkey);
         ELSIF (constraint_ = 'CUSTOMER_INFO_ADDRESS_PK') THEN
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
   newrec_         IN OUT customer_info_address_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
   indrec_     Indicator_rec;
   oldrec_     customer_info_address_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(newrec_.customer_id, newrec_.address_id);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(newrec_.customer_id, newrec_.address_id);
   END IF;
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Modify___;


-- Check_Delete___
--   Perform validations on a new record before it is deleted.
@RmcomAccessCheck CustomerInfo(customer_id), BelongToParent
PROCEDURE Check_Delete___ (
   remrec_ IN customer_info_address_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.customer_id||'^'||remrec_.address_id||'^';
   Reference_SYS.Check_Restricted_Delete(lu_name_, key_);
END Check_Delete___;


-- Delete___
--   Delete a record from the database.
@RmcomAccessCheck CustomerInfo(customer_id), BelongToParent
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN customer_info_address_tab%ROWTYPE )
IS
   key_ VARCHAR2(2000);
BEGIN
   key_ := remrec_.customer_id||'^'||remrec_.address_id||'^';
   Reference_SYS.Do_Cascade_Delete(lu_name_, key_);
   IF (objid_ IS NOT NULL) THEN
      DELETE
         FROM  customer_info_address_tab
         WHERE rowid = objid_;
   ELSE
      DELETE
         FROM  customer_info_address_tab
         WHERE customer_id = remrec_.customer_id
         AND   address_id = remrec_.address_id;
   END IF;
   Invalidate_Cache___;
END Delete___;


-- Delete___
--   Delete a record from the database.
@Deprecated
PROCEDURE Delete___ (
   remrec_ IN customer_info_address_tab%ROWTYPE )
IS
BEGIN
   Delete___(NULL, remrec_);
END Delete___;


-- Remove___
--    Removes an existing instance of the logical unit.
PROCEDURE Remove___ (
   remrec_         IN OUT customer_info_address_tab%ROWTYPE,
   lock_mode_wait_ IN     BOOLEAN DEFAULT TRUE )
IS
   oldrec_     customer_info_address_tab%ROWTYPE;
BEGIN
   IF (lock_mode_wait_) THEN
      oldrec_ := Lock_By_Keys___(remrec_.customer_id, remrec_.address_id);
   ELSE
      oldrec_ := Lock_By_Keys_Nowait___(remrec_.customer_id, remrec_.address_id);
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
   dummy_ customer_info_address_tab%ROWTYPE;
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
   newrec_   customer_info_address_tab%ROWTYPE;
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
   oldrec_   customer_info_address_tab%ROWTYPE;
   newrec_   customer_info_address_tab%ROWTYPE;
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
   remrec_ customer_info_address_tab%ROWTYPE;
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
   rowkey_ IN VARCHAR2 ) RETURN customer_info_address_tab%ROWTYPE
IS
   rec_ customer_info_address_tab%ROWTYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT customer_id, address_id
      INTO  rec_.customer_id, rec_.address_id
      FROM  customer_info_address_tab
      WHERE rowkey = rowkey_;
   RETURN rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN rec_;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(rec_.customer_id, rec_.address_id, 'Get_Key_By_Rowkey');
END Get_Key_By_Rowkey;


-- Exist
--   Checks if given pointer (e.g. primary key) to an instance of this
--   logical unit exists. If not an exception will be raised.
@UncheckedAccess
PROCEDURE Exist (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 )
IS
BEGIN
   IF (NOT Check_Exist___(customer_id_, address_id_)) THEN
      Raise_Record_Not_Exist___(customer_id_, address_id_);
   END IF;
END Exist;


-- Exists
--   Same check as Exist, but returns a BOOLEAN value instead of exception.
@UncheckedAccess
FUNCTION Exists (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(customer_id_, address_id_);
END Exists;

-- Rowkey_Exist
--   Checks whether the rowkey exists
--   If not an exception will be raised.
@UncheckedAccess
PROCEDURE Rowkey_Exist (
   rowkey_ IN VARCHAR2 )
IS
   customer_id_ customer_info_address_tab.customer_id%TYPE;
   address_id_ customer_info_address_tab.address_id%TYPE;
BEGIN
   IF (rowkey_ IS NULL) THEN
      RAISE no_data_found;
   END IF;
   SELECT customer_id, address_id
   INTO  customer_id_, address_id_
   FROM  customer_info_address_tab
   WHERE rowkey = rowkey_;
EXCEPTION
   WHEN no_data_found THEN
      Raise_Record_Not_Exist___(customer_id_, address_id_);
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(customer_id_, address_id_, 'Rowkey_Exist___');
END Rowkey_Exist;


-- Get_Name
--   Fetches the Name attribute for a record.
@UncheckedAccess
FUNCTION Get_Name (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.name;
END Get_Name;


-- Get_Address
--   Fetches the Address attribute for a record.
@UncheckedAccess
FUNCTION Get_Address (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.address;
END Get_Address;


-- Get_Ean_Location
--   Fetches the EanLocation attribute for a record.
@UncheckedAccess
FUNCTION Get_Ean_Location (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.ean_location;
END Get_Ean_Location;


-- Get_Valid_From
--   Fetches the ValidFrom attribute for a record.
@UncheckedAccess
FUNCTION Get_Valid_From (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.valid_from;
END Get_Valid_From;


-- Get_Valid_To
--   Fetches the ValidTo attribute for a record.
@UncheckedAccess
FUNCTION Get_Valid_To (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN DATE
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.valid_to;
END Get_Valid_To;


-- Get_Party
--   Fetches the Party attribute for a record.
@UncheckedAccess
FUNCTION Get_Party (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.party;
END Get_Party;


-- Get_Country
--   Fetches the Country attribute for a record.
@UncheckedAccess
FUNCTION Get_Country (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN Iso_Country_API.Decode(micro_cache_value_.country);
END Get_Country;


-- Get_Country_Db
--   Fetches the DB value of Country attribute for a record.
@UncheckedAccess
FUNCTION Get_Country_Db (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN customer_info_address_tab.country%TYPE
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.country;
END Get_Country_Db;


-- Get_Party_Type
--   Fetches the PartyType attribute for a record.
@UncheckedAccess
FUNCTION Get_Party_Type (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN Party_Type_API.Decode(micro_cache_value_.party_type);
END Get_Party_Type;


-- Get_Party_Type_Db
--   Fetches the DB value of PartyType attribute for a record.
@UncheckedAccess
FUNCTION Get_Party_Type_Db (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN customer_info_address_tab.party_type%TYPE
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.party_type;
END Get_Party_Type_Db;


-- Get_Secondary_Contact
--   Fetches the SecondaryContact attribute for a record.
@UncheckedAccess
FUNCTION Get_Secondary_Contact (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.secondary_contact;
END Get_Secondary_Contact;


-- Get_Primary_Contact
--   Fetches the PrimaryContact attribute for a record.
@UncheckedAccess
FUNCTION Get_Primary_Contact (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.primary_contact;
END Get_Primary_Contact;


-- Get_Address1
--   Fetches the Address1 attribute for a record.
@UncheckedAccess
FUNCTION Get_Address1 (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.address1;
END Get_Address1;


-- Get_Address2
--   Fetches the Address2 attribute for a record.
@UncheckedAccess
FUNCTION Get_Address2 (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.address2;
END Get_Address2;


-- Get_Address3
--   Fetches the Address3 attribute for a record.
@UncheckedAccess
FUNCTION Get_Address3 (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.address3;
END Get_Address3;


-- Get_Address4
--   Fetches the Address4 attribute for a record.
@UncheckedAccess
FUNCTION Get_Address4 (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.address4;
END Get_Address4;


-- Get_Address5
--   Fetches the Address5 attribute for a record.
@UncheckedAccess
FUNCTION Get_Address5 (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.address5;
END Get_Address5;


-- Get_Address6
--   Fetches the Address6 attribute for a record.
@UncheckedAccess
FUNCTION Get_Address6 (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.address6;
END Get_Address6;


-- Get_Zip_Code
--   Fetches the ZipCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Zip_Code (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.zip_code;
END Get_Zip_Code;


-- Get_City
--   Fetches the City attribute for a record.
@UncheckedAccess
FUNCTION Get_City (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.city;
END Get_City;


-- Get_County
--   Fetches the County attribute for a record.
@UncheckedAccess
FUNCTION Get_County (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.county;
END Get_County;


-- Get_State
--   Fetches the State attribute for a record.
@UncheckedAccess
FUNCTION Get_State (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.state;
END Get_State;


-- Get_In_City
--   Fetches the InCity attribute for a record.
@UncheckedAccess
FUNCTION Get_In_City (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.in_city;
END Get_In_City;


-- Get_Jurisdiction_Code
--   Fetches the JurisdictionCode attribute for a record.
@UncheckedAccess
FUNCTION Get_Jurisdiction_Code (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.jurisdiction_code;
END Get_Jurisdiction_Code;


-- Get_Comm_Id
--   Fetches the CommId attribute for a record.
@UncheckedAccess
FUNCTION Get_Comm_Id (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.comm_id;
END Get_Comm_Id;


-- Get_Output_Media
--   Fetches the OutputMedia attribute for a record.
@UncheckedAccess
FUNCTION Get_Output_Media (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN Output_Media_Type_API.Decode(micro_cache_value_.output_media);
END Get_Output_Media;


-- Get_Output_Media_Db
--   Fetches the DB value of OutputMedia attribute for a record.
@UncheckedAccess
FUNCTION Get_Output_Media_Db (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN customer_info_address_tab.output_media%TYPE
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.output_media;
END Get_Output_Media_Db;


-- Get_End_Customer_Id
--   Fetches the EndCustomerId attribute for a record.
@UncheckedAccess
FUNCTION Get_End_Customer_Id (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.end_customer_id;
END Get_End_Customer_Id;


-- Get_End_Cust_Addr_Id
--   Fetches the EndCustAddrId attribute for a record.
@UncheckedAccess
FUNCTION Get_End_Cust_Addr_Id (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.end_cust_addr_id;
END Get_End_Cust_Addr_Id;


-- Get_Customer_Branch
--   Fetches the CustomerBranch attribute for a record.
@UncheckedAccess
FUNCTION Get_Customer_Branch (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_.customer_branch;
END Get_Customer_Branch;

-- Get_By_Rowkey
--   Fetches a record containing the public attributes by rowkey inparameter.
@UncheckedAccess
FUNCTION Get_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN Public_Rec
IS
   rowrec_ customer_info_address_tab%ROWTYPE;
BEGIN
   rowrec_ := Get_Key_By_Rowkey(rowkey_);
   RETURN Get(rowrec_.customer_id, rowrec_.address_id);
END Get_By_Rowkey;

-- Get
--   Fetches a record containing the public attributes.
@UncheckedAccess
FUNCTION Get (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN Public_Rec
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
   RETURN micro_cache_value_;
END Get;


-- Get_Objkey
--   Fetches the objkey attribute for a record.
@UncheckedAccess
FUNCTION Get_Objkey (
   customer_id_ IN VARCHAR2,
   address_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (customer_id_ IS NULL OR address_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   Update_Cache___(customer_id_, address_id_);
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