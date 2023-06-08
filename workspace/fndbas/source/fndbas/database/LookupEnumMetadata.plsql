-----------------------------------------------------------------------------
--
--  Logical unit: LookupEnumMetadata
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Lookup_Encoding_Rec IS RECORD (
   value_                        VARCHAR2(5),
   encoding_                     VARCHAR2(30)
);

TYPE Lookup_Encoding IS VARRAY(20)
   OF Lookup_Encoding_Rec;
   

-------------------- PRIVATE DECLARATIONS -----------------------------------

lookup_encoding_list_ CONSTANT Lookup_Encoding := Init_Lookup_Encoding;


-------------------- CONTROL DATA FETCH AND PROCESSING ----------------------


ENUM_ID_PREFIX CONSTANT VARCHAR2(3) := 'Id';

-- Avoid having symbols such as "-",".", "$" etc.
@UncheckedAccess
FUNCTION Init_Lookup_Encoding RETURN Lookup_Encoding
IS
   encoding_list_ Lookup_Encoding := Lookup_Encoding();
BEGIN
     -- The order of insertion here is important, eg you have to replace underscore before replacing space with underscore.
     -- (Otherwise the replaced underscore would be removed)
     -- Max size of varray is set to 20, but can be increased when needed
     Add_To_Lookup_Encoding('_', '', encoding_list_);
     Add_To_Lookup_Encoding(' ', '_', encoding_list_);
     Add_To_Lookup_Encoding('-', 'DASH', encoding_list_);
     Add_To_Lookup_Encoding('.', 'DOT', encoding_list_);
     Add_To_Lookup_Encoding('$', 'DOLLAR', encoding_list_);
     Add_To_Lookup_Encoding('#', 'NUM', encoding_list_);
     Add_To_Lookup_Encoding('*', 'ASTERISK', encoding_list_);
     Add_To_Lookup_Encoding('!', 'EXCLAM', encoding_list_);
     Add_To_Lookup_Encoding('%', 'PERCENT', encoding_list_);
     Add_To_Lookup_Encoding('&', 'AMP', encoding_list_);
     Add_To_Lookup_Encoding(',', 'COMMA', encoding_list_);
     Add_To_Lookup_Encoding('/', 'SLASH', encoding_list_);
     Add_To_Lookup_Encoding(':', 'COLON', encoding_list_);
     Add_To_Lookup_Encoding(';', 'SEMIC', encoding_list_);
     Add_To_Lookup_Encoding('@', 'AT', encoding_list_);
     Add_To_Lookup_Encoding('^', 'CARET', encoding_list_);
     Add_To_Lookup_Encoding('~', 'TILDE', encoding_list_);
   
   RETURN encoding_list_;
END Init_Lookup_Encoding;

@UncheckedAccess
PROCEDURE Add_To_Lookup_Encoding (value_                IN VARCHAR2,
                                 encoding_             IN VARCHAR2,
                                 lookup_encoding_list_ IN OUT Lookup_Encoding)
IS
BEGIN
    lookup_encoding_list_.Extend;
    lookup_encoding_list_(lookup_encoding_list_.LAST).value_ := value_;
    lookup_encoding_list_(lookup_encoding_list_.LAST).encoding_ := encoding_;
END Add_To_Lookup_Encoding;

@UncheckedAccess
FUNCTION Route_Callback_Content_ (
   method_ IN VARCHAR2,
   param_  IN VARCHAR2,
   clob_   OUT NOCOPY CLOB) RETURN BOOLEAN
IS
BEGIN
   CASE method_
      WHEN 'CLIENT_ENUMERATION_METADATA' THEN
         clob_ := CLIENT_ENUMERATION_METADATA(param_);
      WHEN 'SERVER_ENUMERATION_METADATA' THEN
         clob_ := SERVER_ENUMERATION_METADATA(param_);
      ELSE
         clob_ := '';         
         RETURN FALSE;
      END CASE;
   
   RETURN TRUE;
END Route_Callback_Content_;

-------------------- FORMAT CLIENT METADATA ---------------------------------

FUNCTION Client_Enumeration_Metadata (
   lookup_package_name_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
   enumeration_     Aurena_Client_Metadata_SYS.Enumeration_Rec;
   enum_name_       VARCHAR2(100);
   lookup_encoding_ Aurena_Client_Metadata_SYS.LookupEncoding_Rec;
   db_values_       VARCHAR2(32000);
   db_value_        VARCHAR2(32000);
   client_values_   VARCHAR2(32000);
   client_value_    VARCHAR2(32000);
BEGIN
   Fetch_Enumeration_Values(lookup_package_name_, enum_name_, db_values_, client_values_);
   Aurena_Client_Metadata_SYS.Set_Name(enumeration_, 'Lookup_'||enum_name_);
   FOR i_ IN 0 .. 1000 LOOP
      db_value_ := Domain_SYS.Get_Db_Value_(db_values_, i_);
      client_value_ := Domain_SYS.Get_Db_Value_(client_values_, i_);
      EXIT WHEN db_value_ IS NULL;
      DECLARE
         label_ Aurena_Client_Metadata_SYS.EnumLabel_Rec;
      BEGIN
         Aurena_Client_Metadata_SYS.Add_Values(enumeration_, Get_Item_ID___(db_value_));
         Aurena_Client_Metadata_SYS.Set_Value(label_, Get_Item_ID___(db_value_));
         Aurena_Client_Metadata_SYS.Set_Label(label_, client_value_);
         Aurena_Client_Metadata_SYS.Add_Labels(enumeration_, label_);     
      END;
   END LOOP;
   Aurena_Client_Metadata_SYS.Set_Enum_Prefix(enumeration_, ENUM_ID_PREFIX);

   FOR loop_index_ IN lookup_encoding_list_.FIRST..lookup_encoding_list_.LAST LOOP
      Aurena_Client_Metadata_SYS.Set_Val(lookup_encoding_, lookup_encoding_list_(loop_index_).value_);
      Aurena_Client_Metadata_SYS.Set_Enc(lookup_encoding_, lookup_encoding_list_(loop_index_).encoding_);
      Aurena_Client_Metadata_SYS.Add_Lookup_Encodings(enumeration_, lookup_encoding_);
   END LOOP;
   
   RETURN Aurena_Client_Metadata_SYS.Build(enumeration_);
END Client_Enumeration_Metadata;

-------------------- FORMAT SERVER METADATA ---------------------------------

FUNCTION Server_Enumeration_Metadata (
   lookup_package_name_ IN VARCHAR2 DEFAULT NULL ) RETURN CLOB
IS
   enumeration_   Odata_Provider_Metadata_SYS.Enumeration_Rec;
   enum_name_     VARCHAR2(100);
   db_values_     VARCHAR2(32000);
   db_value_      VARCHAR2(32000);
   client_values_ VARCHAR2(32000);
BEGIN
   Fetch_Enumeration_Values(lookup_package_name_, enum_name_, db_values_, client_values_);
   Odata_Provider_Metadata_SYS.Set_Name(enumeration_, 'Lookup_'||enum_name_);
   FOR i_ IN 0 .. 1000 LOOP
      db_value_ := Domain_SYS.Get_Db_Value_(db_values_, i_);
      EXIT WHEN db_value_ IS NULL;
      DECLARE
         value_ Odata_Provider_Metadata_SYS.Value_Rec;
      BEGIN
         Odata_Provider_Metadata_SYS.Set_Identifier(value_, Get_Item_ID___(db_value_));
         Odata_Provider_Metadata_SYS.Set_Db_Value(value_, db_value_);
         Odata_Provider_Metadata_SYS.Add_Values(enumeration_, value_);
      END;
   END LOOP;
   RETURN Odata_Provider_Metadata_SYS.Build(enumeration_);
END Server_Enumeration_Metadata;

-------------------- FETCH DATA ---------------------------------------------

PROCEDURE Fetch_Enumeration_Values (
   lookup_package_name_ IN     VARCHAR2,
   enum_name_           IN OUT VARCHAR2,
   db_values_           IN OUT VARCHAR2,
   client_values_       IN OUT VARCHAR2 )
IS
BEGIN
   @ApproveDynamicStatement(2018-05-04,stlase)
   EXECUTE IMMEDIATE 'BEGIN :enumname := '||lookup_package_name_||'.lu_name_; '||lookup_package_name_||'.Enumerate_Db(:values); END;' USING OUT enum_name_, OUT db_values_;
   db_values_ := replace(db_values_, Client_SYS.field_separator_, '^');
   @ApproveDynamicStatement(2018-05-04,stlase)
   EXECUTE IMMEDIATE 'BEGIN :enumname := '||lookup_package_name_||'.lu_name_; '||lookup_package_name_||'.Enumerate(:values); END;' USING OUT enum_name_, OUT client_values_;
   client_values_ := replace(client_values_, Client_SYS.field_separator_, '^');
EXCEPTION
   WHEN OTHERS THEN
      enum_name_ := replace(substr(lookup_package_name_, 1, length(lookup_package_name_)-3),'_','');
      db_values_ := 'NA^';
      client_values_ := 'N/A^';
END Fetch_Enumeration_Values;

-------------------- FORMAT HELPERS -----------------------------------------

FUNCTION Get_Item_ID___ (
   db_value_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   db_val_        VARCHAR2(32000) := db_value_;
BEGIN
   
   FOR loop_index_ IN lookup_encoding_list_.FIRST..lookup_encoding_list_.LAST LOOP
      db_val_ := replace(db_val_, lookup_encoding_list_(loop_index_).value_, lookup_encoding_list_(loop_index_).encoding_);             
   END LOOP;
   
   -- Check of first char is number, then we need the prefix
   IF (Regexp_Like(db_val_,'^[0-9]{1}')) THEN
      RETURN ENUM_ID_PREFIX||db_val_;
   ELSE
      RETURN db_val_;
   END IF;
END Get_Item_ID___;
