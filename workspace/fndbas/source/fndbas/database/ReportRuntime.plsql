-----------------------------------------------------------------------------
--
--  Logical unit: ReportRuntime
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------



-------------------- PRIVATE DECLARATIONS -----------------------------------

NEW_LINE               CONSTANT VARCHAR2(1)  := CHR(10);
ROW_SYNC_PROPERTY_NAME CONSTANT VARCHAR2(30) := 'REPORT_CONFIG_ROW_SYNC'; -- 'ON' | 'OFF'  (default: 'ON')

TYPE Column_List IS TABLE OF VARCHAR2(100) INDEX BY BINARY_INTEGER; -- ordered list of column names indexed by position 1,2,3...

--DB_CONNECTOR_READERS  CONSTANT VARCHAR2(20) := Config_Instance_Group_API.DB_CONNECTOR_READERS;
--DB_CONNECTOR_SENDERS  CONSTANT VARCHAR2(20) := Config_Instance_Group_API.DB_CONNECTOR_SENDERS;
--DB_ENVELOPES          CONSTANT VARCHAR2(20) := Config_Instance_Group_API.DB_ENVELOPES;
DB_MESSAGE_QUEUES     CONSTANT VARCHAR2(20) := Report_Config_Inst_Group_API.DB_MESSAGE_QUEUES;
--DB_ROUTING            CONSTANT VARCHAR2(20) := Config_Instance_Group_API.DB_ROUTING;
--DB_SERVERS            CONSTANT VARCHAR2(20) := Config_Instance_Group_API.DB_SERVERS;
--DB_TRANSFORMERS       CONSTANT VARCHAR2(20) := Config_Instance_Group_API.DB_TRANSFORMERS;
DB_TASK_TEMPLATES     CONSTANT VARCHAR2(20) := Report_Config_Inst_Group_API.DB_TASK_TEMPLATES;

TRACE CONSTANT BOOLEAN := FALSE;
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
PROCEDURE Trace___ (
   text_ IN VARCHAR2 DEFAULT NULL) IS
BEGIN
   IF TRACE THEN
      Dbms_Output.Put_Line(text_);
   END IF;
END Trace___;


PROCEDURE Log___ (
   text_ IN VARCHAR2 DEFAULT NULL) IS
BEGIN
   Dbms_Output.Put_Line(text_);
END Log___;


FUNCTION Sync_Row_Enabled___ RETURN BOOLEAN IS
BEGIN
   RETURN NVL(Fnd_Session_API.Get_Property(ROW_SYNC_PROPERTY_NAME), 'ON') = 'ON';
END Sync_Row_Enabled___;


--
-- Parse comma separated string to column name list
--
PROCEDURE Parse_Column_List___ (
   list_ IN OUT Column_List,
   text_ IN     VARCHAR2)
IS
   len_ INTEGER := length(text_);
   p1_  INTEGER := 1;
   p2_  INTEGER;
BEGIN
   WHILE p1_ <= len_ LOOP
      p2_ := instr(text_, ',', p1_);
      IF p2_ = 0 THEN
         p2_ := len_ + 1;
      END IF;
      list_(list_.COUNT + 1) := trim(substr(text_, p1_, p2_ - p1_));
      p1_ := p2_ + 1;
   END LOOP;
END Parse_Column_List___;


FUNCTION Format_Where_Condition___ (
   list_          IN Column_List,
   base_bind_pos_ IN NUMBER DEFAULT 0) RETURN VARCHAR2
IS
   sql_ VARCHAR2(32767);
BEGIN
   IF list_.COUNT = 0 THEN
      RETURN NULL;
   END IF;
   sql_ := 'WHERE ';
   FOR i IN 1 .. list_.COUNT LOOP
      IF i > 1 THEN
         sql_ := sql_ || ' AND ';
      END IF;
      sql_ := sql_ || list_(i) || ' = :' || (base_bind_pos_ + i);
   END LOOP;
   RETURN sql_;
END Format_Where_Condition___;


FUNCTION Format_Join_Condition___ (
   pk_columns_ IN VARCHAR2) RETURN VARCHAR2
IS
   list_ Column_List;
   sql_  VARCHAR2(32767);
BEGIN
   Parse_Column_List___(list_, pk_columns_);
   FOR i IN 1 .. list_.COUNT LOOP
      IF i > 1 THEN
         sql_ := sql_ || ' AND ';
      END IF;
      sql_ := sql_ || 'D.' || list_(i) || ' = S.' || list_(i);
   END LOOP;
   RETURN sql_;
END Format_Join_Condition___;


FUNCTION Format_Update_Set_Clause___ (
   columns_ IN VARCHAR2) RETURN VARCHAR2
IS
   list_ Column_List;
   sql_  VARCHAR2(32767);
BEGIN
   Parse_Column_List___(list_, columns_);
   FOR i IN 1 .. list_.COUNT LOOP
      IF i > 1 THEN
         sql_ := sql_ || ', ';
      END IF;
      sql_ := sql_ || 'D.' || list_(i) || ' = S.' || list_(i);
   END LOOP;
   RETURN sql_;
END Format_Update_Set_Clause___;


PROCEDURE Add_Params_To_Tmp_Table___ (
   params_ IN Report_Runtime_Params_Type) IS
BEGIN
   INSERT INTO report_conf_inst_param_tmp_tab(group_name, instance_name, parameter_name, parameter_value)
   SELECT group_name, instance_name, parameter_name, parameter_value
     FROM TABLE(params_);
END Add_Params_To_Tmp_Table___;


--
-- Delete rows from a table using optional where condition on at most two key columns
--
PROCEDURE Delete_Table___ (
   table_name_  IN VARCHAR2,
   key_columns_ IN VARCHAR2 DEFAULT NULL,
   key1_        IN VARCHAR2 DEFAULT NULL,
   key2_        IN VARCHAR2 DEFAULT NULL)
IS
   list_ Column_List;
   sql_  VARCHAR2(4000);
BEGIN
   Parse_Column_List___(list_, key_columns_);
   sql_ := Format_Where_Condition___(list_);
   sql_ := 'DELETE ' || table_name_ || ' ' || sql_;
   Trace___('Executing statement: ' || sql_);
   CASE list_.COUNT
      WHEN 0 THEN
         @ApproveDynamicStatement(2019-10-31,madrse)
         EXECUTE IMMEDIATE sql_;
      WHEN 1 THEN
         @ApproveDynamicStatement(2019-10-31,madrse)
         EXECUTE IMMEDIATE sql_ USING key1_;
      WHEN 2 THEN
         @ApproveDynamicStatement(2019-10-31,madrse)
         EXECUTE IMMEDIATE sql_ USING key1_, key2_;
   END CASE;
   Trace___(SQL%ROWCOUNT || ' rows deleted.');
   Trace___;
END Delete_Table___;


PROCEDURE Remove_Instance_And_Params___ (
   group_name_    IN VARCHAR2,
   instance_name_ IN VARCHAR2) IS
BEGIN
   Delete_Table___
    (table_name_  => 'report_config_inst_param_tab',
     key_columns_ => 'group_name, instance_name',
     key1_        => group_name_,
     key2_        => instance_name_);
   Delete_Table___
    (table_name_  => 'report_config_instance_tab',
     key_columns_ => 'group_name, instance_name',
     key1_        => group_name_,
     key2_        => instance_name_);
END Remove_Instance_And_Params___;


PROCEDURE Sync_Table___ (
   src_table_     IN VARCHAR2,              -- <src>
   dest_table_    IN VARCHAR2,              -- <dest>
   pk_columns_    IN VARCHAR2,              -- <pk>
   columns_       IN VARCHAR2,              -- <cols>
   where_columns_ IN VARCHAR2 DEFAULT NULL, -- <where>
   bind1_         IN VARCHAR2 DEFAULT NULL, -- ?
   bind2_         IN VARCHAR2 DEFAULT NULL) -- ?
IS
   where_list_ Column_List;
   bind_count_ NUMBER;
   where1_     VARCHAR2(2000);  -- <where1>
   where2_     VARCHAR2(2000);  -- <where2>
   join_       VARCHAR2(2000);  -- <join>
   set_cols_   VARCHAR2(32767); -- <set_cols>
   sql_        VARCHAR2(32767);
   exec_time_  NUMBER;

   PROCEDURE Prepare_Sql(sql_stmt_ IN VARCHAR2) IS
   BEGIN
      sql_ := sql_stmt_;
      sql_ := REPLACE(sql_, '<src>'     , src_table_ );
      sql_ := REPLACE(sql_, '<dest>'    , dest_table_);
      sql_ := REPLACE(sql_, '<pk>'      , pk_columns_);
      sql_ := REPLACE(sql_, '<cols>'    , columns_   );
      sql_ := REPLACE(sql_, '<join>'    , join_      );
      sql_ := REPLACE(sql_, '<where1>'  , where1_    );
      sql_ := REPLACE(sql_, '<where2>'  , where2_    );
      sql_ := REPLACE(sql_, '<set_cols>', set_cols_  );
   END Prepare_Sql;

   FUNCTION Excecute_Sql RETURN NUMBER IS -- returns execution time in seconds
      --
      -- sql_ statement contains two where conditions, each with bind_count_ bind variables
      --
      start_ NUMBER := Dbms_Utility.Get_Time;
   BEGIN
      Trace___('Executing: ' || sql_);
      IF bind_count_ > 0 THEN
         Trace___('Binding:');
         FOR i IN 1 .. 2 LOOP
            Trace___('   [' || bind1_ || ']');
            IF bind_count_ > 1 THEN
               Trace___('   [' || bind2_ || ']');
            END IF;
         END LOOP;
      END IF;
      CASE bind_count_
         WHEN 0 THEN
            @ApproveDynamicStatement(2019-10-31,madrse)
            EXECUTE IMMEDIATE sql_;
         WHEN 1 THEN
            @ApproveDynamicStatement(2019-10-31,madrse)
            EXECUTE IMMEDIATE sql_ USING bind1_, bind1_;
         WHEN 2 THEN
            @ApproveDynamicStatement(2019-10-31,madrse)
            EXECUTE IMMEDIATE sql_ USING bind1_, bind2_, bind1_, bind2_;
      END CASE;
      RETURN (Dbms_Utility.Get_Time - start_) / 100;
   END Excecute_Sql;
BEGIN
   Parse_Column_List___(where_list_, where_columns_);
   bind_count_ := where_list_.COUNT;
   where1_     := Format_Where_Condition___(where_list_);
   where2_     := Format_Where_Condition___(where_list_, where_list_.COUNT);
   join_       := Format_Join_Condition___(pk_columns_);
   set_cols_   := Format_Update_Set_Clause___(columns_);
   --
   -- Delete dest rows with primary keys that do not exist in src
   --
   Prepare_Sql('
   DELETE <dest>
    WHERE (<pk>) IN
       (SELECT <pk> FROM <dest> <where1>
        MINUS
        SELECT <pk> FROM <src> <where2>)');
   exec_time_ := Excecute_Sql;
   Log___(SQL%ROWCOUNT || ' superfluous rows deleted from runtime table [' || dest_table_ || '] in [' || exec_time_ || '] sec');
   Trace___;
   --
   -- Insert into dest rows with primary keys that exist in src but do not exist in dest.
   -- Note: INSERT is executed outside MERGE to show number of inserted rows (MERGE reports number of merged rows).
   --
   Prepare_Sql('
   INSERT INTO <dest> (<pk>, <cols>, rowversion)
   SELECT <pk>, <cols>, 1
     FROM <src>
    WHERE (<pk>) IN
       (SELECT <pk> FROM <src> <where1>
        MINUS
        SELECT <pk> FROM <dest> <where2>)');
   exec_time_ := Excecute_Sql;
   Log___(SQL%ROWCOUNT || ' missing rows inserted into runtime table [' || dest_table_ || '] in [' || exec_time_ || '] sec');
   Trace___;
   --
   -- Update rows that differ and have primary keys that exist both in src and dest.
   -- Note: MERGE is used for update because of simpler syntax.
   --
   Prepare_Sql('
   MERGE INTO <dest> D
   USING (SELECT <pk>, <cols> FROM <src> <where1>
          MINUS
          SELECT <pk>, <cols> FROM <dest> <where2>) S
   ON (<join>)
   WHEN MATCHED THEN UPDATE SET <set_cols>, D.rowversion = D.rowversion + 1');
   exec_time_ := Excecute_Sql;
   Log___(SQL%ROWCOUNT || ' rows updated in runtime table [' || dest_table_ || '] in [' || exec_time_ || '] sec');
   Trace___;
END Sync_Table___;


PROCEDURE Sync_Instance___ (
   group_name_    IN VARCHAR2,
   instance_name_ IN VARCHAR2,
   instance_type_ IN VARCHAR2,
   description_   IN VARCHAR2) IS
BEGIN
   Log___('Sync_Instance___:');
   DELETE report_config_inst_tmp_tab;
   INSERT INTO report_config_inst_tmp_tab(group_name, instance_name, instance_type, description)
   VALUES (group_name_, instance_name_, instance_type_, description_);

   Sync_Table___ (
      src_table_     => 'report_config_inst_tmp_tab',
      dest_table_    => 'report_config_instance_tab',
      pk_columns_    => 'group_name, instance_name',
      columns_       => 'instance_type, description',
      where_columns_ => 'group_name, instance_name',
      bind1_         => group_name_,
      bind2_         => instance_name_);
END Sync_Instance___;


PROCEDURE Sync_Instance_Params___ (
   group_name_    IN VARCHAR2,
   instance_name_ IN VARCHAR2,
   params_        IN Report_Runtime_Params_Type) IS
BEGIN
   Log___('Sync_Instance_Params___:');
   DELETE report_conf_inst_param_tmp_tab;
   INSERT INTO report_conf_inst_param_tmp_tab(group_name, instance_name, parameter_name, parameter_value)
   SELECT group_name, instance_name, parameter_name, parameter_value
     FROM TABLE(params_);

   Sync_Table___ (
      src_table_     => 'report_conf_inst_param_tmp_tab',
      dest_table_    => 'report_config_inst_param_tab',
      pk_columns_    => 'group_name, instance_name, parameter_name',
      columns_       => 'parameter_value',
      where_columns_ => 'group_name, instance_name',
      bind1_         => group_name_,
      bind2_         => instance_name_);
END Sync_Instance_Params___;


/*
PROCEDURE Sync_Addresses___ (
   client_addresses_ IN Routing_Address_API.Routing_Addresses,
   address_name_     IN VARCHAR2 DEFAULT NULL)
IS
   runtime_addresses_ Connect_Runtime_Addresses_Type;
BEGIN
   Log___('Sync_Addresses___:');
   --
   -- Convert client addresses to runtime addresses and insert them into temporary table
   --
   Routing_Address_API.To_Runtime_Addresses_(runtime_addresses_, client_addresses_);
   DELETE routing_address_run_tmp_tab;
   INSERT INTO routing_address_run_tmp_tab (address_name, transport_connector, sender_instance, address_data, address_data_2, options, envelope, encoding, sender, sender_organization, receiver, receiver_organization, transformer, response_transformer, zip, envelope_response)
   SELECT                                   address_name, transport_connector, sender_instance, address_data, address_data_2, options, envelope, encoding, sender, sender_organization, receiver, receiver_organization, transformer, response_transformer, zip, envelope_response
     FROM TABLE(runtime_addresses_);
   --
   -- Synchronize address runtime table with temporary table
   --
   Sync_Table___ (
      src_table_     => 'routing_address_run_tmp_tab',
      dest_table_    => 'routing_address_runtime_tab',
      pk_columns_    => 'address_name',
      columns_       =>                                  'transport_connector, sender_instance, address_data, address_data_2, options, envelope, encoding, sender, sender_organization, receiver, receiver_organization, transformer, response_transformer, zip, envelope_response',
      where_columns_ => CASE address_name_ IS NULL WHEN TRUE THEN NULL ELSE 'address_name' END,
      bind1_         => address_name_);
END Sync_Addresses___;



PROCEDURE Sync_All_Addresses___  IS
   client_addresses_ Routing_Address_API.Routing_Addresses;
BEGIN
   --
   -- Pass all routing addresses to Sync_Addresses___
   --
   SELECT * BULK COLLECT INTO client_addresses_ FROM routing_address_tab;
   Sync_Addresses___(client_addresses_);
END Sync_All_Addresses___;
*/

PROCEDURE Sync_Report_Instances___ IS
   --readers_      Connect_Reader_API.Connect_Readers;
   --senders_      Connect_Sender_API.Connect_Senders;
   --envelopes_    Connect_Envelope_API.Connect_Envelopes;
   queues_       Report_Queue_API.Report_Queues;
   --routings_     Connect_Simple_Routing_API.Connect_Routings;
   --servers_      Connect_Server_API.Connect_Servers;
   --transformers_ Connect_Transformer_API.Connect_Transformers;
   tasks_        Report_Print_Agent_Task_API.Report_Print_Agent_Tasks;

   params_  Report_Runtime_Params_Type;
BEGIN
   Log___('Sync_Report_Instances___:');
   --
   -- Insert all instances from all client entities into temporary table
   --
   DELETE report_config_inst_tmp_tab;
   INSERT INTO report_config_inst_tmp_tab(group_name, instance_name, instance_type, description)
   SELECT group_name, instance_name, instance_type, description
   FROM report_config_runtime_inst; -- UNION of all client entities
   --
   -- Synchronize instance runtime table with temporary table
   --
   Sync_Table___ (
      src_table_  => 'report_config_inst_tmp_tab',
      dest_table_ => 'report_config_instance_tab',
      pk_columns_ => 'group_name, instance_name',
      columns_    => 'instance_type, description');

   --
   -- Convert all client entities to runtime parameters and insert them into temporary table
   --
   DELETE report_conf_inst_param_tmp_tab;

   --
   -- ConnectReader
   --
   /*
   SELECT * BULK COLLECT INTO readers_ FROM connect_reader_tab;
   Connect_Reader_API.To_Runtime_Params_(params_, readers_);
   Connect_Reader_API.To_Custom_Params_(params_, readers_);
   Add_Params_To_Tmp_Table___(params_);
   */
   --
   -- ConnectSender
   --
   /*
   SELECT * BULK COLLECT INTO senders_ FROM connect_sender_tab;
   Connect_Sender_API.To_Runtime_Params_(params_, senders_);
   Connect_Sender_API.To_Custom_Params_(params_, senders_);
   Add_Params_To_Tmp_Table___(params_);
   */
   --
   -- ConnectEnvelope
   --
   /*
   SELECT * BULK COLLECT INTO envelopes_ FROM connect_envelope_tab;
   Connect_Envelope_API.To_Runtime_Params_(params_, envelopes_);
   Add_Params_To_Tmp_Table___(params_);
   */
   --
   -- ReportQueue
   --
   SELECT * BULK COLLECT INTO queues_ FROM report_queue_tab;
   Report_Queue_API.To_Runtime_Params_(params_, queues_);
   Add_Params_To_Tmp_Table___(params_);

   --
   -- ConnectSimpleRouting
   --
   /*
   SELECT * BULK COLLECT INTO routings_ FROM connect_simple_routing_tab;
   Connect_Simple_Routing_API.To_Runtime_Params_(params_, routings_);
   Add_Params_To_Tmp_Table___(params_);
   */
   --
   -- ConnectServer
   --
   /*
   SELECT * BULK COLLECT INTO servers_ FROM connect_server_tab;
   Connect_Server_API.To_Runtime_Params_(params_, servers_);
   Add_Params_To_Tmp_Table___(params_);
   */
   --
   -- ConnectTransformer
   --
   /*
   SELECT * BULK COLLECT INTO transformers_ FROM connect_transformer_tab;
   Connect_Transformer_API.To_Runtime_Params_(params_, transformers_);
   Add_Params_To_Tmp_Table___(params_);
   */
   --
   -- ReprotPrintAgentTask
   --
   SELECT * BULK COLLECT INTO tasks_ FROM report_print_agent_task_tab;
   Report_Print_Agent_Task_API.To_Runtime_Params_(params_, tasks_);
   Add_Params_To_Tmp_Table___(params_);

   --
   -- Synchronize parameter runtime table with temporary table
   --
   Sync_Table___ (
      src_table_  => 'report_conf_inst_param_tmp_tab',
      dest_table_ => 'report_config_inst_param_tab',
      pk_columns_ => 'group_name, instance_name, parameter_name',
      columns_    => 'parameter_value');
END Sync_Report_Instances___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Disable_Row_Sync_ IS
BEGIN
   Fnd_Session_API.Set_Property(ROW_SYNC_PROPERTY_NAME, 'OFF');
END Disable_Row_Sync_;


--
-- Enable synchronization of runtime tables on row level in the current session.
--
PROCEDURE Enable_Row_Sync_ IS
BEGIN
   Fnd_Session_API.Set_Property(ROW_SYNC_PROPERTY_NAME, 'ON');
END Enable_Row_Sync_;


-------------------------------------------------------------------------------
-- Entity specific Sync_Xxx_ and Remove_Xxx_ procedures
-------------------------------------------------------------------------------

--
-- ConnectReader
--
/*
PROCEDURE Sync_Reader_ (
   reader_ IN connect_reader_tab%ROWTYPE)
IS
   params_  Connect_Runtime_Params_Type;
   readers_ Connect_Reader_API.Connect_Readers := Connect_Reader_API.Connect_Readers(reader_);
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_CONNECTOR_READERS, reader_.instance_name, reader_.instance_type, reader_.description);
      Connect_Reader_API.To_Runtime_Params_(params_, readers_);
      Connect_Reader_API.To_Custom_Params_(params_, readers_);
      Sync_Instance_Params___(DB_CONNECTOR_READERS, reader_.instance_name, params_);
   END IF;
END Sync_Reader_;


PROCEDURE Remove_Reader_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_CONNECTOR_READERS, instance_name_);
   END IF;
END Remove_Reader_;
*/

--
-- ConnectSender
--
/*
PROCEDURE Sync_Sender_ (
   sender_ IN connect_sender_tab%ROWTYPE)
IS
   params_  Connect_Runtime_Params_Type;
   senders_ Connect_Sender_API.Connect_Senders := Connect_Sender_API.Connect_Senders(sender_);
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_CONNECTOR_SENDERS, sender_.instance_name, sender_.instance_type, sender_.description);
      Connect_Sender_API.To_Runtime_Params_(params_, senders_);
      Connect_Sender_API.To_Custom_Params_(params_, senders_);
      Sync_Instance_Params___(DB_CONNECTOR_SENDERS, sender_.instance_name, params_);
   END IF;
END Sync_Sender_;


PROCEDURE Remove_Sender_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_CONNECTOR_SENDERS, instance_name_);
   END IF;
END Remove_Sender_;
*/

--
-- ConnectEnvelope
--
/*PROCEDURE Sync_Envelope_ (
   envelope_ IN connect_envelope_tab%ROWTYPE)
IS
   params_ Connect_Runtime_Params_Type;
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_ENVELOPES, envelope_.instance_name, 'Envelope', envelope_.description);
      Connect_Envelope_API.To_Runtime_Params_(params_, Connect_Envelope_API.Connect_Envelopes(envelope_));
      Sync_Instance_Params___(DB_ENVELOPES, envelope_.instance_name, params_);
   END IF;
END Sync_Envelope_;


PROCEDURE Remove_Envelope_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_ENVELOPES, instance_name_);
   END IF;
END Remove_Envelope_;
*/

--
-- ReportQueue
--
PROCEDURE Sync_Queue_ (
   queue_ IN report_queue_tab%ROWTYPE)
IS
   params_        Report_Runtime_Params_Type;
   instance_type_ VARCHAR2(20) := CASE queue_.enabled WHEN 'TRUE' THEN 'MessageQueue' ELSE 'DisabledQueue' END;
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_MESSAGE_QUEUES, queue_.instance_name, instance_type_, queue_.description);
      Report_Queue_API.To_Runtime_Params_(params_, Report_Queue_API.Report_Queues(queue_));
      Sync_Instance_Params___(DB_MESSAGE_QUEUES, queue_.instance_name, params_);
   END IF;
END Sync_Queue_;


PROCEDURE Remove_Queue_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_MESSAGE_QUEUES, instance_name_);
   END IF;
END Remove_Queue_;


--
-- ConnectSimpleRouting
--
/*PROCEDURE Sync_Routing_ (
   routing_ IN connect_simple_routing_tab%ROWTYPE)
IS
   params_ Connect_Runtime_Params_Type;
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_ROUTING, routing_.instance_name, 'SimplifiedRouting', routing_.description);
      Connect_Simple_Routing_API.To_Runtime_Params_(params_, Connect_Simple_Routing_API.Connect_Routings(routing_));
      Sync_Instance_Params___(DB_ROUTING, routing_.instance_name, params_);
   END IF;
END Sync_Routing_;


PROCEDURE Remove_Routing_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_ROUTING, instance_name_);
   END IF;
END Remove_Routing_;
*/

--
-- ConnectServer
--

/*
PROCEDURE Sync_Server_ (
   server_ IN connect_server_tab%ROWTYPE)
IS
   params_ Connect_Runtime_Params_Type;
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_SERVERS, server_.instance_name, 'J2EEServer', server_.description);
      Connect_Server_API.To_Runtime_Params_(params_, Connect_Server_API.Connect_Servers(server_));
      Sync_Instance_Params___(DB_SERVERS, server_.instance_name, params_);
   END IF;
END Sync_Server_;


PROCEDURE Remove_Server_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_SERVERS, instance_name_);
   END IF;
END Remove_Server_;
*/

--
-- ConnectTransformer
--
/*
PROCEDURE Sync_Transformer_ (
   transformer_ IN connect_transformer_tab%ROWTYPE)
IS
   params_ Connect_Runtime_Params_Type;
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_TRANSFORMERS, transformer_.instance_name, transformer_.instance_type, transformer_.description);
      Connect_Transformer_API.To_Runtime_Params_(params_, Connect_Transformer_API.Connect_Transformers(transformer_));
      Sync_Instance_Params___(DB_TRANSFORMERS, transformer_.instance_name, params_);
   END IF;
END Sync_Transformer_;


PROCEDURE Remove_Transformer_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_TRANSFORMERS, instance_name_);
   END IF;
END Remove_Transformer_;
*/

--
-- ReportPrintAgentTask
--
PROCEDURE Sync_Print_Agent_Task_ (
   task_ IN report_print_agent_task_tab%ROWTYPE)
IS
   params_ Report_Runtime_Params_Type;
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Instance___(DB_TASK_TEMPLATES, task_.instance_name, 'PrintAgent', task_.description);
      Report_Print_Agent_Task_API.To_Runtime_Params_(params_, Report_Print_Agent_Task_API.Report_Print_Agent_Tasks(task_));
      Sync_Instance_Params___(DB_TASK_TEMPLATES, task_.instance_name, params_);
   END IF;
END Sync_Print_Agent_Task_;


PROCEDURE Remove_Print_Agent_Task_ (
   instance_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Remove_Instance_And_Params___(DB_TASK_TEMPLATES, instance_name_);
   END IF;
END Remove_Print_Agent_Task_;


--
-- RoutingAddress
--
/*
PROCEDURE Sync_Address_ (
   client_address_ IN routing_address_tab%ROWTYPE) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Sync_Addresses___(Routing_Address_API.Routing_Addresses(client_address_), client_address_.address_name);
   END IF;
END Sync_Address_;


PROCEDURE Remove_Address_ (
   address_name_ IN VARCHAR2) IS
BEGIN
   IF Sync_Row_Enabled___ THEN
      Delete_Table___
       (table_name_  => 'routing_address_runtime_tab',
        key_columns_ => 'address_name',
        key1_        => address_name_);
   END IF;
END Remove_Address_;
*/
-------------------------------------------------------------------------------

PROCEDURE Sync_All_ IS
BEGIN
   Log___('Sync_All_:');
   --Sync_All_Addresses___;
   Sync_Report_Instances___;
END Sync_All_;
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Post_Installation_Data IS
BEGIN
   Sync_All_;
END Post_Installation_Data;

-------------------- LU  NEW METHODS -------------------------------------
