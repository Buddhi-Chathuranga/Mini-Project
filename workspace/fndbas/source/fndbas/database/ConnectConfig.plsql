-----------------------------------------------------------------------------
--
--  Logical unit: ConnectConfig
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  ---------------------------------------------------------
--  2016-02-27  madrse  Created (TEJSL-633)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

FORMAT_TYPE   CONSTANT INTEGER  := Dbms_Crypto.DES_CBC_PKCS5;
FORAMT_KEY    CONSTANT RAW(128) := Utl_Raw.Cast_To_Raw('Connect Key');
FORMAT_VECTOR CONSTANT RAW(100) := Utl_Raw.Cast_To_Raw('Connect Vector');

LF  CONSTANT VARCHAR2(1) := CHR(10);
CR  CONSTANT VARCHAR2(1) := CHR(13);
TAB CONSTANT VARCHAR2(1) := CHR(9);

TYPE Name_List IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Split___ (
   key_  IN  VARCHAR2,
   col1_ OUT VARCHAR2,
   col2_ OUT VARCHAR2)
IS
   pos_ NUMBER := instr(key_, Client_SYS.field_separator_);
BEGIN
   col1_ := substr(key_, 1, pos_ - 1);
   col2_ := substr(key_, pos_ + 1);
END Split___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Cannonize_Options_ (
   options_ IN VARCHAR2) RETURN VARCHAR2
IS
   buf_ VARCHAR2(2000);
BEGIN
   IF options_ IS NULL THEN
      RETURN NULL;
   END IF;
   buf_ := REPLACE(options_, CR);
   buf_ := REGEXP_REPLACE(buf_, ' +', ' ');
   buf_ := REGEXP_REPLACE(buf_, LF || '+', LF);
   buf_ := LTRIM(buf_, LF);
   buf_ := RTRIM(buf_, LF);
   RETURN buf_;
END Cannonize_Options_;


PROCEDURE Encrypt_ (
   text_      IN OUT VARCHAR2,
   indicator_ IN     BOOLEAN) IS
BEGIN
   IF indicator_ THEN
      text_ := Encrypt_(text_);
   END IF;
END Encrypt_;


FUNCTION Encrypt_ (
   text_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF text_ IS NULL THEN
      RETURN NULL;
   ELSIF substr(text_, 1, 2) = '#' || TAB THEN
      --
      -- Text already encryped by old java encryption
      --
      RETURN text_;
   ELSIF substr(text_, 1, 2) = '^' || TAB THEN
      --
      -- Text already encryped by new PLSQL encryption
      --
      RETURN text_;
   ELSE
      --
      -- Encrypt using PLSQL encryption
      --
      RETURN '^' || TAB || Utl_Raw.Cast_To_Varchar2(
                           Utl_Encode.Base64_Encode(
                           Dbms_Crypto.Encrypt(Utl_Raw.Cast_To_Raw(text_), FORMAT_TYPE, FORAMT_KEY, FORMAT_VECTOR)));
   END IF;
END Encrypt_;


FUNCTION Decrypt_ (
   text_ IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF substr(text_, 1, 2) = '^' || TAB THEN
      --
      -- Decrypt using PLSQL decryption
      --
      RETURN Utl_Raw.Cast_To_Varchar2(
             Dbms_Crypto.Decrypt(
                Utl_Encode.Base64_Decode(Utl_Raw.Cast_To_Raw(substr(text_, 3, length(text_) - 2))),
                FORMAT_TYPE, FORAMT_KEY, FORMAT_VECTOR));
   ELSIF substr(text_, 1, 2) = '#' || TAB THEN
      Error_SYS.Appl_General(lu_name_, 'DECRYPT_JAVA: Cannot decrypt text encrypted by java [:P1]', text_);
   ELSE
      --
      -- Not encrypted text
      --
      RETURN text_;
   END IF;
END Decrypt_;


--
-- Convert modeled mixed case name (like entity or projection) to database case (view name)
--
FUNCTION Mixed_Case_To_Db_Case_ (
   name_ IN VARCHAR2) RETURN VARCHAR2
IS
   db_ VARCHAR2(100);
   ch_ VARCHAR2(1);
BEGIN
   FOR i IN 1 .. length(name_) LOOP
      ch_ := substr(name_, i, 1);
      IF i > 1 AND ch_ = upper(ch_) AND instr('0123456789', ch_) = 0 THEN
         db_ := db_ || '_';
      END IF;
      db_ := db_ || upper(ch_);
   END LOOP;
   RETURN db_;
END Mixed_Case_To_Db_Case_;


--
-- Verify that all mandatory attributes exist in attribute string
--
PROCEDURE Validate_Mandatory_Attributes_ (
   lu_name_         IN VARCHAR2,
   attr_            IN VARCHAR2,
   mandatory_attrs_ IN VARCHAR2)
IS
   ptr_   NUMBER;
   name_  VARCHAR2(100);
   value_ VARCHAR2(32000);
   sep_   VARCHAR2(1) := Client_SYS.field_separator_;
BEGIN
   ptr_ := NULL;
   WHILE Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) LOOP
      IF instr(sep_ || mandatory_attrs_, sep_ || name_ || sep_) > 0 AND value_ IS NULL THEN
         Error_SYS.Appl_General(Connect_Config_API.lu_name_, 'MANDATORY: Missing value for mandatory attribute [:P1] in record [:P2]', name_, lu_name_);
      END IF;
   END LOOP;
END Validate_Mandatory_Attributes_;


--
-- Move not owned attributes from an attribute string to another one
--
PROCEDURE Move_Not_Own_Attributes_ (
   from_attr_ IN OUT VARCHAR2,
   to_attr_   IN OUT VARCHAR2,
   own_attrs_ IN     VARCHAR2)
IS
   ptr_      NUMBER;
   name_     VARCHAR2(100);
   own_name_ VARCHAR2(100);
   value_    VARCHAR2(32000);
   sep_      VARCHAR2(1) := Client_SYS.field_separator_;
   list_     Name_List;
BEGIN
   ptr_ := NULL;
   WHILE Client_SYS.Get_Next_From_Attr(from_attr_, ptr_, name_, value_) LOOP
      own_name_ := CASE substr(name_, -3) = '_DB' WHEN TRUE THEN substr(name_, 1, length(name_) - 3) ELSE name_ END;
      IF instr(sep_ || own_attrs_, sep_ || own_name_ || sep_) = 0 THEN
         list_(list_.COUNT + 1) := name_;
      END IF;
   END LOOP;
   FOR i IN 1 .. list_.COUNT LOOP
      value_ := Client_SYS.Cut_Item_Value(list_(i), from_attr_);
      Client_SYS.Add_To_Attr(list_(i), value_, to_attr_);
   END LOOP;
END Move_Not_Own_Attributes_;


--
-- Copy all attributes from an attribute string to another one
--
PROCEDURE Copy_Attributes_ (
   from_attr_ IN     VARCHAR2,
   to_attr_   IN OUT VARCHAR2)
IS
   ptr_   NUMBER;
   name_  VARCHAR2(100);
   value_ VARCHAR2(32000);
BEGIN
   ptr_ := NULL;
   WHILE Client_SYS.Get_Next_From_Attr(from_attr_, ptr_, name_, value_) LOOP
      Client_SYS.Add_To_Attr(name_, value_, to_attr_);
   END LOOP;
END Copy_Attributes_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Checks if the specified BLOB column should be stored in INS file as text, rather than Base64. Used only by APPLICATION_SERVER_TASK.
--
FUNCTION Is_Text_Blob (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   objid_       IN ROWID) RETURN VARCHAR2 IS
BEGIN
   RETURN 'TRUE';
END Is_Text_Blob;


--
-- Encrypts TypeHiddenText value. Replaces Ins_Util_API.Format() for CONFIG_PARAMETER.PARAMETER_VALUE.
--
FUNCTION Format_Parameter_Value (
   parameter_value_ IN VARCHAR2,
   parameter_type_  IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF parameter_type_ = 'TypeHiddenText' THEN
      RETURN Ins_Util_API.To_Base64(parameter_value_);
   ELSE
      RETURN parameter_value_;
   END IF;
END Format_Parameter_Value;

------------------------
-- Connect_Config_Def --
------------------------

PROCEDURE Add_Custom_Config_Condition (
   sql_           IN OUT VARCHAR2,
   group_name_    IN     VARCHAR2,
   instance_type_ IN     Ins_Util_API.List,
   multiline_     IN     BOOLEAN DEFAULT TRUE) IS
BEGIN
   Ins_Util_API.Add_Or_Condition (
      master_column_name_ => 'group_name',
      master_value_       => group_name_,
      detail_column_name_ => 'instance_type',
      detail_value_list_  => instance_type_,
      sql_                => sql_,
      multiline_          => multiline_);
END Add_Custom_Config_Condition;

--------------------
-- Connect_Config --
--------------------

PROCEDURE Add_Config_Instance_Condition (
   sql_           IN OUT VARCHAR2,
   group_name_    IN     VARCHAR2,
   instance_name_ IN     Ins_Util_API.List,
   multiline_     IN     BOOLEAN DEFAULT TRUE) IS
BEGIN
   Ins_Util_API.Add_Or_Condition (
      master_column_name_ => 'group_name',
      master_value_       => group_name_,
      detail_column_name_ => 'instance_name',
      detail_value_list_  => instance_name_,
      sql_                => sql_,
      multiline_          => multiline_);
END Add_Config_Instance_Condition;

-------------------
-- Route_Address --
-------------------

PROCEDURE Add_Route_Address_Condition (
   condition_   IN OUT VARCHAR2,
   description_ IN     Ins_Util_API.List,
   multiline_   IN     BOOLEAN DEFAULT TRUE) IS
BEGIN
   Ins_Util_API.Add_Or_Condition (
      column_name_ => 'description',
      value_list_  => description_,
      sql_         => condition_,
      multiline_   => multiline_);
END Add_Route_Address_Condition;

---------------------
-- Route_Condition --
---------------------

PROCEDURE Add_Route_Condition_Condition (
   condition_   IN OUT VARCHAR2,
   description_ IN     Ins_Util_API.List,
   multiline_   IN     BOOLEAN DEFAULT TRUE) IS
BEGIN
   Ins_Util_API.Add_Or_Condition (
      column_name_ => 'description',
      value_list_  => description_,
      sql_         => condition_,
      multiline_   => multiline_);
END Add_Route_Condition_Condition;

-----------------------------
-- Application_Server_Task --
-----------------------------

PROCEDURE Add_App_Server_Task_Condition (
   condition_ IN OUT VARCHAR2,
   subject_   IN     Ins_Util_API.List,
   multiline_ IN     BOOLEAN DEFAULT TRUE) IS
BEGIN
   Ins_Util_API.Add_Or_Condition (
      column_name_ => 'subject',
      value_list_  => subject_,
      sql_         => condition_,
      multiline_   => multiline_);
END Add_App_Server_Task_Condition;


PROCEDURE Export_Application_Server_Task (
   component_ IN VARCHAR2,
   file_name_ IN VARCHAR2,
   condition_ IN VARCHAR2,
   debug_     IN BOOLEAN DEFAULT FALSE) IS
BEGIN
   Ins_Util_API.Spool_Ins_File_Header (
      component_         => component_,
      file_name_         => file_name_,
      purpose_           => 'Install application server tasks and task templates');

   Ins_Util_API.Generate_Ins_File (
      table_name_        => 'application_server_task',
      pk_column_list_    => Ins_Util_API.List('tag', 'subject'),
      order_by_          => 'subject',
      where_             => condition_,
      lu_package_        => 'Application_Message_API',
      custom_new_proc_   => 'New_App_Server_Task__',
      skip_column_list_  => Ins_Util_API.List('application_message_id', 'seq_no', 'b_seq_no', 'l_seq_no'),
      is_text_blob_func_ => 'Connect_Config_API.Is_Text_Blob',
      wide_format_       => FALSE,
      debug_             => debug_);

   Ins_Util_API.Spool_Ins_File_Footer;
END Export_Application_Server_Task;


PROCEDURE Export_Application_Server_Task (
   component_   IN VARCHAR2,
   file_name_   IN VARCHAR2,
   description_ IN Ins_Util_API.List,
   debug_       IN BOOLEAN DEFAULT FALSE)
IS
   cond_ VARCHAR2(32767);
BEGIN
   Add_App_Server_Task_Condition (cond_, description_);
   Export_Application_Server_Task (component_, file_name_, cond_, debug_);
END Export_Application_Server_Task;
