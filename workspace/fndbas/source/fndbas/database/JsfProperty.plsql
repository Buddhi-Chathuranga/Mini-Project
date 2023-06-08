-----------------------------------------------------------------------------
--
--  Logical unit: JsfProperty
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date         Sign    History
--  ----------   ------  --------------------------------------------------------
--  2019-09-10   madrse  PACZDATA-1340: Moving properties files to database side
---------------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

APPLY_PROPERTIES_JMS_METHOD CONSTANT VARCHAR2(100) := 'ApplyProperties';

NEW_LINE        CONSTANT VARCHAR2(1)  := CHR(10);

DB_STANDARD     CONSTANT VARCHAR2(20) := Jsf_Property_Source_API.DB_STANDARD;
DB_CUSTOM       CONSTANT VARCHAR2(20) := Jsf_Property_Source_API.DB_CUSTOM;

DB_LOGGING      CONSTANT VARCHAR2(20) := Jsf_Property_Group_API.DB_LOGGING;
DB_IFS          CONSTANT VARCHAR2(20) := Jsf_Property_Group_API.DB_IFS;

DB_STRING       CONSTANT VARCHAR2(20) := Jsf_Property_Type_API.DB_STRING;
DB_INTEGER      CONSTANT VARCHAR2(20) := Jsf_Property_Type_API.DB_INTEGER;
DB_BOOLEAN      CONSTANT VARCHAR2(20) := Jsf_Property_Type_API.DB_BOOLEAN;
DB_LIMIT        CONSTANT VARCHAR2(20) := Jsf_Property_Type_API.DB_LIMIT;
DB_LOG_LEVEL    CONSTANT VARCHAR2(20) := Jsf_Property_Type_API.DB_LOG_LEVEL;
DB_HANDLER_TYPE CONSTANT VARCHAR2(20) := Jsf_Property_Type_API.DB_HANDLER_TYPE;
DB_CATEGORIES   CONSTANT VARCHAR2(20) := Jsf_Property_Type_API.DB_CATEGORIES;

TYPE Property_Map IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(1000);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Trace___ (text_ IN VARCHAR2) IS
BEGIN
   --Log_SYS.Fnd_Trace_(Log_SYS.info_, text_);
   Dbms_Output.Put_Line(text_);
END Trace___;


--
-- Split property line into name and value
--
PROCEDURE Split_Property_Line___ (
   name_  OUT VARCHAR2,
   value_ OUT VARCHAR2,
   line_  IN  VARCHAR2)
IS
   pos_ NUMBER := instr(line_, '=');
BEGIN
   IF pos_ = 0 THEN
      Error_SYS.Appl_General(lu_name_, 'MISSING_EQUAL: Missing "=" in property line [:P1]', line_);
   END IF;
   name_  := trim(substr(line_, 1, pos_ - 1));
   value_ := trim(substr(line_, pos_ + 1));
END Split_Property_Line___;


--
-- Parse text file into map of properties: name -> value
--
PROCEDURE Parse_Property_File___ (
   map_  IN OUT Property_Map,
   file_ IN     CLOB)
IS
   text_  CLOB    := REPLACE(file_, CHR(13));
   len_   INTEGER := length(text_);
   p1_    INTEGER := 1;
   p2_    INTEGER;
   line_  VARCHAR2(32767);
   name_  VARCHAR2(32767);
   value_ VARCHAR2(32767);
BEGIN
   WHILE p1_ <= len_ LOOP
      p2_ := instr(text_, NEW_LINE, p1_);
      IF p2_ = 0 THEN
         p2_ := len_ + 1;
      END IF;
      line_ := trim(substr(text_, p1_, p2_ - p1_));

      IF line_ IS NOT NULL AND substr(line_, 1, 1) <> '#' THEN
         Split_Property_Line___(name_, value_, line_);
         Trace___('Property ' || name_ || '=' || value_);
         IF length(name_) > 1000 THEN
            Error_SYS.Appl_General(lu_name_, 'LONG_NAME: Property name longer than 1000 charactes [:P1...]', substr(name_, 1, 200));
         END IF;
         IF length(value_) > 4000 THEN
            Error_SYS.Appl_General(lu_name_, 'LONG_VALUE: Property value longer than 4000 charactes [:P1...]', substr(value_, 1, 200));
         END IF;
         IF value_ IS NULL THEN
            Trace___('Skipped property without value');
         ELSE
            map_(name_) := value_;
         END IF;
      END IF;
      p1_ := p2_ + 1;
   END LOOP;
END Parse_Property_File___;


PROCEDURE Allocate_Lock_Handle___ (
   lock_name_   IN  VARCHAR2,
   lock_handle_ OUT VARCHAR2)
IS
   PRAGMA autonomous_transaction;
BEGIN
   Dbms_Lock.Allocate_Unique(lock_name_, lock_handle_); -- Dbms_Lock.Allocate_Unique performs commit
END Allocate_Lock_Handle___;


FUNCTION Lock_Property_Group___ (
   property_group_ IN VARCHAR2) RETURN BOOLEAN
IS
   timeout_in_seconds_ NUMBER := 10;
   lock_name_          VARCHAR2(200) := 'IFS_CONNECT' || '$' || property_group_ || '-properties';
   lock_handle_        VARCHAR2(128);
   result_             INTEGER;
BEGIN
   Allocate_Lock_Handle___(lock_name_, lock_handle_);

   result_ := Dbms_Lock.Request
               (lockhandle        => lock_handle_,
                lockmode          => Dbms_Lock.X_MODE,
                timeout           => timeout_in_seconds_,
                release_on_commit => TRUE);

   Trace___('Locking property_group [' || property_group_ || '] using lock handle [' || lock_handle_ || '] with timeout [' || timeout_in_seconds_ || '] sec. Result = ' || result_);
   --
   --  0 Success
   --  1 Timeout
   --  2 Deadlock
   --  3 Parameter error
   --  4 Already own lock specified by id or lockhandle
   --  5 Illegal lock handle
   --
   RETURN result_ IN (0, 4) ;
END Lock_Property_Group___;


--
-- Compare two strings taking NULL values into account
--
FUNCTION Match___ (
   v1_ IN VARCHAR2,
   v2_ IN VARCHAR2) RETURN BOOLEAN IS
BEGIN
   RETURN v1_ = v2_ OR (v1_ IS NULL AND v2_ IS NULL);
END Match___;


--
-- Synchronize property in database without calling New__ or Modify__, which are customized for client calls.
--
PROCEDURE Sync_Property___ (
   db_changed_ IN OUT BOOLEAN,
   old_        IN     Public_Rec,
   new_        IN     Public_Rec)
IS
   info_ VARCHAR2(2000);
BEGIN
   Trace___('Replacing property ' || '[' || new_.property_group || ':' || new_.property_name || ']');
   Trace___('   old: ' || old_.property_type || '/' || old_.property_source || '=' || old_.property_value || '(' || old_.standard_value || ')');
   Trace___('   new: ' || new_.property_type || '/' || new_.property_source || '=' || new_.property_value || '(' || new_.standard_value || ')');
   IF old_.property_group  = new_.property_group  AND
      old_.property_name   = new_.property_name   AND
      old_.property_value  = new_.property_value  AND
      old_.property_source = new_.property_source AND
      old_.property_type   = new_.property_type   AND
      Match___(old_.standard_value, new_.standard_value)
   THEN
      Trace___('Skipped unchanged property');
      RETURN;
   END IF;

   IF old_."rowid" IS NOT NULL THEN
      Trace___('Updating changed property');
      Lock__(info_, old_."rowid", old_.rowversion); -- May abort if the row is locked by end user
      UPDATE jsf_property_tab
         SET property_value  = new_.property_value,
             property_source = new_.property_source,
             property_type   = new_.property_type,
             standard_value  = new_.standard_value,
             timestamp       = systimestamp,
             rowversion      = rowversion + 1
       WHERE ROWID = old_."rowid";
      db_changed_ := TRUE;
   ELSE
      Trace___('Inserting new property');
      INSERT INTO jsf_property_tab
        (property_group,
         property_name,
         property_value,
         property_source,
         property_type,
         standard_value,
         timestamp,
         rowversion)
      VALUES
        (new_.property_group,
         new_.property_name,
         new_.property_value,
         new_.property_source,
         new_.property_type,
         new_.standard_value,
         systimestamp,
         1);
      db_changed_ := TRUE;
   END IF;
END Sync_Property___;


--
-- Derive property type from property name and group
--
FUNCTION Get_Property_Type___ (
   group_ IN VARCHAR2,
   name_  IN VARCHAR2) RETURN VARCHAR2 IS
BEGIN
   IF group_ = DB_LOGGING THEN
      IF    name_ LIKE '%.filecount'      THEN RETURN DB_INTEGER;
      ELSIF name_ LIKE '%.maxsize'        THEN RETURN DB_LIMIT;
      ELSIF name_ LIKE '%.level'          THEN RETURN DB_LOG_LEVEL;
      ELSIF name_ LIKE '%.type'           THEN RETURN DB_HANDLER_TYPE;
      ELSIF name_ LIKE '%.includepackage' THEN RETURN DB_BOOLEAN;
      ELSIF name_ LIKE '%.perthread'      THEN RETURN DB_BOOLEAN;
      ELSIF name_ LIKE '%.pertag'         THEN RETURN DB_BOOLEAN;
      ELSIF name_ LIKE '%.categories'     THEN RETURN DB_CATEGORIES;
      ELSIF name_ LIKE 'classdebug.%'     THEN RETURN DB_LOG_LEVEL;
      END IF;
   ELSIF group_ = DB_IFS THEN
      IF name_ LIKE '%Enabled' THEN RETURN DB_BOOLEAN;
      END IF;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'INVALID_GROUP: Invalid property group [:P1]', group_);
   END IF;
   RETURN DB_STRING;
END Get_Property_Type___;


--
-- Trim and validate property value depending on property type
--
PROCEDURE Validate_Property_Value___ (
   newrec_ IN OUT jsf_property_tab%ROWTYPE) IS
BEGIN
   newrec_.property_value := trim(newrec_.property_value);
   Jsf_Property_Type_API.Validate_Property_Value(newrec_.property_name, newrec_.property_type, newrec_.property_value);
   IF newrec_.property_group = DB_IFS THEN
      IF newrec_.property_name NOT LIKE 'ifs.%' AND newrec_.property_name NOT LIKE 'fnd.%' THEN
         Error_SYS.Appl_General(lu_name_, 'IFS_PROPERTY_NAME: Invalid IFS property name [:P1]. It must start with "ifs." or "fnd.".', newrec_.property_name);
      END IF;
   END IF;
END Validate_Property_Value___;


--
-- Abort execution if given property is read-only
--
PROCEDURE Check_Read_Only_Property___ (
   rec_    IN jsf_property_tab%ROWTYPE,
   remove_ IN BOOLEAN) IS
BEGIN
   IF rec_.property_group = DB_IFS AND rec_.property_source = DB_STANDARD THEN
      --
      -- Currently there are no Read-Only properties
      --
      RETURN;
      Error_SYS.Appl_General(lu_name_, 'READ_ONLY: Read-Only property [:P1] cannot be ' || CASE remove_ WHEN TRUE THEN 'removed' ELSE 'modified' END, rec_.property_name);
   END IF;
END Check_Read_Only_Property___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT jsf_property_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 ) IS
BEGIN
   Trace___('Check_Insert___: ' || attr_);
   --
   -- Set all server generated attributes.
   -- PropertyType is derived from PropertyName.
   -- All properties created by New__ have PropertySource CUSTOM.
   -- STANDARD properties are created only in Startup_ procedure.
   --
   newrec_.property_source := DB_CUSTOM;
   newrec_.timestamp := systimestamp;
   newrec_.standard_value  := NULL;
   IF newrec_.property_group IS NULL THEN
      NULL; --> show standard error message for mandatory attribute
   ELSE
      newrec_.property_type := Get_Property_Type___(newrec_.property_group, newrec_.property_name);
      Validate_Property_Value___(newrec_);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     jsf_property_tab%ROWTYPE,
   newrec_ IN OUT jsf_property_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   customized_ BOOLEAN;
BEGIN
   Trace___('Check_Update___: ' || attr_);
   --
   -- Validate property value and set server generated attributes Timestamp and StandardValue
   --
   Check_Read_Only_Property___(oldrec_, remove_ => FALSE);
   Validate_Property_Value___(newrec_);
   newrec_.timestamp := systimestamp;
   --
   -- Update customized flag if necessary
   --
   IF newrec_.property_source = DB_STANDARD THEN
      customized_ := oldrec_.standard_value IS NOT NULL;
      IF customized_ THEN
         IF newrec_.property_value = oldrec_.standard_value THEN
            --
            -- Clear customized flag
            --
            newrec_.standard_value := NULL;
         END IF;
      ELSE
         IF newrec_.property_value <> oldrec_.property_value THEN
            --
            -- Set customized flag
            --
            newrec_.standard_value := oldrec_.property_value;
         END IF;
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN jsf_property_tab%ROWTYPE ) IS
BEGIN
   Check_Read_Only_Property___(remrec_, remove_ => TRUE);
   IF remrec_.property_source = DB_STANDARD THEN
      Error_SYS.Appl_General(lu_name_, 'REMOVE_STANDARD: STANDARD property [:P1] cannot be removed', remrec_.property_name);
   END IF;
   super(remrec_);
END Check_Delete___;


--
-- Replace property in database if necessary.
-- This method does not use New__ or Modify__.
--
PROCEDURE Replace_Property___ (
   db_changed_ IN OUT BOOLEAN,
   group_      IN     VARCHAR2,
   name_       IN     VARCHAR2,
   value_      IN     VARCHAR2,
   startup_    IN     BOOLEAN)
IS
   old_ Public_Rec;
   new_ Public_Rec;
BEGIN
   old_ := Get(group_, name_);
   new_.property_group := group_;
   new_.property_name  := name_;
   new_.property_type  := Get_Property_Type___(group_, name_);

   IF startup_ THEN
      new_.property_source := DB_STANDARD;
      IF old_.property_value IS NULL THEN
         new_.property_value := value_;
      ELSE
         new_.property_value := old_.property_value;
         new_.standard_value := value_;
      END IF;
   ELSE
      new_.property_source := nvl(old_.property_source, DB_CUSTOM);
      new_.property_value  := nvl(old_.property_value, value_);
      new_.standard_value  := old_.standard_value;
   END IF;

   --
   -- Clear standard_value that matches property_value
   --
   IF new_.property_value = new_.standard_value THEN
      new_.standard_value := NULL;
   END IF;
   Sync_Property___(db_changed_, old_, new_);
END Replace_Property___;


--
-- Merge properties from specified file with properties in database.
-- This procedure in startup mode is the only source of new STANDARD properties.
--
PROCEDURE Merge_Properties___ (
   db_changed_     IN OUT BOOLEAN,
   property_group_ IN     VARCHAR2,
   property_file_  IN     CLOB,
   startup_        IN     BOOLEAN)
IS
   property_map_ Property_Map;
   name_         VARCHAR2(1000);
   value_        VARCHAR2(4000);
   info_         VARCHAR2(2000);
BEGIN
   Parse_Property_File___(property_map_, property_file_);
   --
   -- Lock property group to avoid concurrent merge by different nodes
   --
   IF NOT Lock_Property_Group___(property_group_) THEN
      Error_SYS.Appl_General(lu_name_, 'LOCK_PROP_GROUP: Failed to lock property group [:P1]. Merging of properties aborted.', property_group_);
   END IF;
   --
   -- Loop over file properties and merge one at a time with database
   --
   name_ := property_map_.FIRST;
   WHILE name_ IS NOT NULL LOOP
      value_ := property_map_(name_);
      Replace_Property___(db_changed_, property_group_, name_, value_, startup_);
      name_ := property_map_.NEXT(name_);
   END LOOP;

   IF startup_ THEN
      Trace___('Resolving old STANDARD properties');
      --
      -- Resolve old STANDARD properties
      --
      FOR prop_ IN (SELECT property_name, standard_value, ROWID, rowversion
                      FROM jsf_property_tab
                     WHERE property_group = property_group_
                       AND property_source = DB_STANDARD
                    ORDER BY property_name)
      LOOP
         IF NOT property_map_.EXISTS(prop_.property_name) THEN
            Trace___('Found old standard property ' || prop_.property_name);
            --
            -- Found old standard property
            --
            Lock__(info_, prop_.ROWID, prop_.rowversion); -- May abort if the row is locked by end user

            IF prop_.standard_value IS NOT NULL THEN
               Trace___('Change old customized STANDARD property to CUSTOM property');
               --
               -- Change old customized STANDARD property to CUSTOM property
               --
               UPDATE jsf_property_tab
                  SET property_source = DB_CUSTOM,
                      standard_value = NULL,
                      rowversion = rowversion + 1
                WHERE ROWID = prop_.ROWID;
            ELSE
               Trace___('Delete old not-customized STANDARD property');
               --
               -- Delete old not-customized STANDARD property
               --
               DELETE jsf_property_tab
                WHERE ROWID = prop_.ROWID;
            END IF;
            db_changed_ := TRUE;
         END IF;
      END LOOP;
   END IF;
END Merge_Properties___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

--
-- Merge STANDARD properties on strartup with STANDARD and CUSTOM properties in database.
-- This procedure is the only source of new STANDARD properties in database.
--
PROCEDURE Init_ (
   property_group_ IN VARCHAR2,
   property_file_  IN CLOB)
IS
   db_changed_ BOOLEAN       := FALSE;
   jms_method_ VARCHAR2(100) := APPLY_PROPERTIES_JMS_METHOD;
BEGIN
   Trace___('Merging ' || property_group_ || ' properties at startup: ' || NEW_LINE || property_file_);
   Merge_Properties___(db_changed_, property_group_, property_file_, startup_ => TRUE);
   IF NOT db_changed_ THEN
      Trace___('No properties modified at startup. Sending message to Batch Processor JMS queue: method [' || jms_method_ || ']   property_group [' || property_group_ || ']');
      Batch_Processor_Jms_API.Send_Jms_Message(jms_method_, property_group_ => property_group_);
   END IF;
END Init_;


--
-- Import properties from file to database
--
PROCEDURE Import_ (
   property_group_ IN VARCHAR2,
   property_file_  IN CLOB)
IS
   db_changed_ BOOLEAN := FALSE;
BEGIN
   Trace___('Importing ' || property_group_ || ' properties to database: ' || NEW_LINE || property_file_);
   Merge_Properties___(db_changed_, property_group_, property_file_, startup_ => FALSE);
END Import_;


--
-- Spool all properties from database to a file
--
PROCEDURE Export_ (
   property_group_ IN            VARCHAR2,
   property_file_     OUT NOCOPY CLOB)
IS
   clob_ CLOB;
BEGIN
   Trace___('Exporting ' || property_group_ || ' properties');
   Dbms_Lob.CreateTemporary(clob_, TRUE, Dbms_Lob.CALL);
   Dbms_Lob.Open(clob_, Dbms_Lob.LOB_READWRITE);

   FOR prop_ IN (SELECT property_name, property_value
                   FROM jsf_property_tab
                  WHERE property_group = property_group_
                 ORDER BY property_name)
   LOOP
      clob_ := clob_ || prop_.property_name || '=' || prop_.property_value || NEW_LINE;
   END LOOP;

   Dbms_Lob.Close(clob_);
   property_file_ := clob_;
   IF Dbms_Lob.IsTemporary(clob_) = 1 THEN
      Dbms_Lob.FreeTemporary(clob_);
   END IF;
   Trace___('Exported properties from database: ' || NEW_LINE || property_file_);
END Export_;


--
-- Called from trigger on JSF_PROPERTY_TAB.
-- Use temporary table to trigger one JMS message per transaction and property group.
--
PROCEDURE Jsf_Property_Changed_ (
   property_group_ IN VARCHAR2) IS
BEGIN
   INSERT INTO jsf_property_distinct_jms_tab(property_group, jms_method, transaction_id)
   VALUES (property_group_, APPLY_PROPERTIES_JMS_METHOD, Dbms_Transaction.Local_Transaction_Id);
EXCEPTION
   WHEN dup_val_on_index THEN
      NULL;
END Jsf_Property_Changed_;


--
-- Called from trigger on temporary table JSF_PROPERTY_DISTINCT_JMS_TAB.
--
PROCEDURE Jsf_Property_Jms_Changed_ (
   property_group_ IN VARCHAR2,
   jms_method_     IN VARCHAR2) IS
BEGIN
   Trace___('JSF_PROPERTY_DISTINCT_JMS_TAB Trigger: Sending message to Batch Processor JMS queue: method [' || jms_method_ || ']   property_group [' || property_group_ || ']');
   Batch_Processor_Jms_API.Send_Jms_Message(jms_method_, property_group_ => property_group_);
END Jsf_Property_Jms_Changed_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

--
-- Validate set of all Logging Properties currently saved in database.
-- The method should be called from a projection after modification of one or more properties.
--
PROCEDURE Validate_Logging_Properties IS
   property_file_ CLOB;
   doc_           PLSQLAP_Document_API.Document;
   info_          VARCHAR2(4000);
BEGIN
   Export_(DB_LOGGING, property_file_);
   doc_ := PLSQLAP_Document_API.New_Document('LOGGING_PROPERTIES');
   PLSQLAP_Document_API.Add_Attribute(doc_, 'PROPERTIES', property_file_);
   PLSQLAP_Server_API.Invoke_Operation_(doc_, 'MessageHandlerService', 'ValidateLoggingProperties');
   info_ := PLSQLAP_Document_API.Get_Value(doc_, 'INFO');
   Trace___('');
   Trace___(info_);
END Validate_Logging_Properties;


--
-- Disable JsfProperty triggers
--
PROCEDURE Disable_Triggers IS
BEGIN
   Installation_SYS.Disable_Trigger('Jsf_Property_TR');
   Installation_SYS.Disable_Trigger('Jsf_Property_Distinct_Jms_TR');
END Disable_Triggers;


--
-- Enable JsfProperty triggers
--
PROCEDURE Enable_Triggers IS
BEGIN
   Installation_SYS.Enable_Trigger('Jsf_Property_TR');
   Installation_SYS.Enable_Trigger('Jsf_Property_Distinct_Jms_TR');
END Enable_Triggers;


--
-- Create and enable JsfProperty triggers
--
PROCEDURE Create_Triggers IS
   empty_ Installation_SYS.ColumnTabType;
BEGIN
   --
   -- JSF_PROPERTY_TAB -> JSF_PROPERTY_DISTINCT_JMS_TAB
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Jsf_Property_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT OR UPDATE OR DELETE',
      columns_      => empty_,
      table_name_   => 'JSF_PROPERTY_TAB',
      condition_    => NULL,
      plsql_block_  => 'Jsf_Property_API.Jsf_Property_Changed_(nvl(:new.property_group, :old.property_group));',
      show_info_    => TRUE);
   --
   -- JSF_PROPERTY_DISTINCT_JMS_TAB -> Send distinct JMS message per transaction
   --
   Installation_SYS.Create_Trigger(
      trigger_name_ => 'Jsf_Property_Distinct_Jms_TR',
      trigger_type_ => 'AFTER',
      dml_event_    => 'INSERT',
      columns_      => empty_,
      table_name_   => 'JSF_PROPERTY_DISTINCT_JMS_TAB',
      condition_    => NULL,
      plsql_block_  => 'Jsf_Property_API.Jsf_Property_Jms_Changed_(:new.property_group, :new.jms_method);',
      show_info_    => TRUE);
END Create_Triggers;


PROCEDURE Post_Installation_Object IS
BEGIN
   Create_Triggers;
END Post_Installation_Object;

