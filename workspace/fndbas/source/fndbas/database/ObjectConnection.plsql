-----------------------------------------------------------------------------
--
--  Logical unit: ObjectConnection
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  970528  ERFO  Created general connection concept (Idea #1112).
--  970529  ERFO  Removed commit from the refresh of the cache (Idea #1286).
--  970530  ERFO  Changed name and parameters of Get_Dynamic_Description_
--                and implemented new procedure Get_Connection_Description.
--  970729  ERFO  Made method Enumerate_Logical_Units_ protected.
--  970729  ERFO  Changes to get use of Fnd_Session_API.Get_Language.
--  971015  ERFO  Implemented Get_Key_Reference instead of Get_Logical_Unit_Keys.
--                Added new method Convert_To_Key_Reference (ToDo #1673).
--  971016  ERFO  Implemented conversion logic between lists and key refs.
--  971022  ERFO  Refresh only be run as application owner (ToDo #1286).
--  971027  ERFO  Restore method Get_Instance for history aware (ToDo #1732).
--  971128  ERFO  Solved PL/SQL problem with incomplete cache info (Bug #1845).
--  971128  ERFO  Parameter changes in the methods Enable_Logical_Unit and
--                Is_Connection_Aware for improved granularity (ToDo #1793).
--  971208  DAJO  Added view OBJECT_CONNECTION and changed some nvl expressions
--                to Decode or IF for better performance.
--  971210  ERFO  Review concerning usage of NVL-function (ToDo #1869).
--  980126  ERFO  Added new methods Convert_To_Key_Value, Get_View_Name and
--                cursor get_key_info2 with no order by statement (ToDo #2055).
--  980209  DAJO  Added column service_list to view object_connection.
--  980227  ERFO  Added methods Enable_Service, Disable_Service and
--                Enumerate_Logical_Units (ToDo #2165).
--  980227  ERFO  Added method Get_Configuration_Properties and obsoleted the
--                methods Get_View_Name and Get_Key_Reference (ToDo #2166).
--  980306  ERFO  Changes concerning new language configuration (ToDo #2212).
--  980310  ERFO  Get_Connection_Description should not return function
--                Get_Instance_Description when dynamic PL/SQL returns NULL.
--  980310  ERFO  Changes in Refresh_Active_List__ to use SUBSTR (Bug #2221).
--  980316  ERFO  Changes in Enable_Logical_Unit to let default services be set
--                to '*' even from IFS/Deployment Administrator (Bug #2248).
--  980322  ERFO  Changes in Convert_To_Key_Reference to handle keys in view
--                definition which do not appear in a sequence (Bug #2266).
--  980609  ERFO  Limitation in method Enumerate_Logical_Units_ (Bug #2432).
--  990122  ERFO  Yoshimura: Changes in cursor get_conn_info and methods
--                Get_Configuration_Prop and Get_Connection_Desc (ToDo #3160).
--  011126  ROOD  Replaced usage of user_col_comments with fnd_col_comments (Bug#26328).
--  020317  ROOD  Performance modifications in Refresh_Active_List__ (Bug#28660).
--  020701  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030324  ROOD  Added columns package_name and method_name to view (ToDo#4160).
--  030613  ROOD  Changed call to Get_Logical_Unit_Properties___ (ToDo#4162).
--  031105  ROOD  Used order by in conversion functions. Also made some minor
--                performance improvements (Bug#37764)
--  040331  HAAR  Unicode bulk changes, extended bind variable Desc length in Get_Description___ (F1PR408B).
--  040331  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  040617  ROOD  Removed unused implementation method Get_Package___ (F1PR413).
--  040630  ROOD  Changed view comments LU -> SERVICE (F1PR413).
--  040906  ROOD  Replaced usage of Get_Lov_View_ with Get_Base_View (F1PR413).
--  040923  ROOD  Changes due to modified interface in Dictionary. Modified some
--                implementation to use dictionary information for performance
--                reasons (F1PR413). Correction in Get_Connection_Description
--                to handle conversions between different key formats.
--  050404  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050829  ASWI  Increased return string length of methods Get_Dynamic_Description_
--                and Get_Instance_Description to 200 (Bug#50742).
--  051108  ASWI  Added methods Get_Instance_Description___ and Get_Instance_Description with additional by_position_ parameter.(Bug#49294)
--  060105  UTGULK Annotated Sql injection.
--  060301  HAAR  Changed length of column Lu_Attr and Key_Attr to 4000 in Object_Connection_Sys_Tab (135638).
--  060308  RAKU  Made Convert_To_Key_Reference and Convert_To_Key_Value resolve IID key columns (Bug#55575).
--  060518  SUKM  Added new methods Do_Cascade_Delete, Check_Object_Connection_Exists, Remove_Dangling_Connections_.
--                Delete_Object_Connection___, Check_Object_Exists (Bug#56013)
--  060627  SUKM  Added new methods Get_Column_Comments___, Tokenize_Key_Ref__, Replace_Client_Values___,
--                Get_Record_From_View___ and Replace_Client_Values.
--                Fixed Convert_To_Key_Reference so that it encodes IDD column values to DB value. (Bug#58997)
--  060711  SUKM  Replaced the info message in Do_Cascade_Delete() with a trace. (Bug#59279).
--                Did some code cleanup. (Removed Get_Column_Comments___).
--  061023  SUKM  Added code to Tokenize_Key_Ref__() to allow '=' characters in a key reference. (Bug# 61327)
--  061109  SUKM  Added new methods Replace_Server_Values___, Replace_Server_Values, Get_Client_Column___ (Bug#59895).
--  070214  DUWILK  Changed the size of the desc_ varibale in Get_Description___ function (Bug#63485).
--  070713  SUMALK  Made changed to delete connections when service_list is *(Bug#66520)
--  070727  PEMASE  Utilize bind variables where possible, added Assert_SYS calls, added annotations (Bug#66828).
--  071029  DUWILK  Check the cursor is open or not in Check_Object_Exists function (Bug#67934).
--  071102  SUMALK Added Get_Package_Name method(Bug#67509).
--  080208  HAARSE Added update of Cache Management when refreshing the cache (Bug#71136).
--  080225  SUMALK Added Close Cursor stmt to exception section in Get_Record_From_View(Bug#70974)
--  080424  HAARSE Added support for Notes in Do_Casacade_Delete (Bug#72847).
--  081224  HASPLK Added method Get_Custom_Instance_Desc (Bug#78024).
--  090116  HASPLK Modified Method Enable_logical_Unit (Bug#79254).
--  090410  HASPLK Modified cursor get_key_ref_info to sort column names in Accent-Insensitive mode.
--                 To make comply with alphabetical sorting in MS Windows (Bug#81528).
--  090810  NABALK Certified the assert safe for dynamic SQLs (Bug#84218)
--  091016  NABALK Changed the Get_Client_Hit_Count_ Method to support a given service view name (Bug#86465)
--  100218  BUHILK Added method Get_Rowid_From_Keyref for federated search (Bug#88106).
--  100407  PKULLK Modified Check_Object_Exists to support LU's who do not have tables on their own (ex: derived LU's) (Bug#89946)
--  100720  CHMULK Certified the assert safe for dynamic SQLs (Bug#84970)
--  110804  NaBaLK Changed the way of retrieving base view from LU name in Check_Object_Exists (RDTERUNTIME-570)
--  110728  DUWILK Changed Get_Record_From_View___ in order to support DATE type keys (Bug#97999).
--  110804  UsRaLK Changed the view name locating logic to use locally available information as much as possible (Bug#98343).
--  120218  UsRaLK Delete_Object_Connection___: changed to use PL/SQL instead of the delete statement (Bug#99168/RDTERUNTIME-1518).
--  120218  DUWILK Altered Column key_attr to CLOB (RDTERUNTIME-1192).
--  130606  MADDLK increased the supported length for description in Get_Dynamic_Description_. (Bug#110448)
--  130829  MADDLK Modified delete logic in Delete_Object_Connection. (Bug#110706)
--  140309  UsRaLK Modified Get_Client_Hit_Count to allow overriding of count logic (Bug#112972/TEBASE-50).
--  141027  ChMuLK Modified Get_Lov_Properties.. methods, added new method [Get_Lov_Properties_](Bug#119398/TEBASE-763).
--  191126  RAKUSE Added Register_Service, Register_Global_Service, Unregister_Service & Unregister_Global_Service (TEAURENAFW-1155).
--  191128  RAKUSE Added Register_Active_Services___ (TEAURENAFW-1155).
--  191203  RAKUSE Added Register_Active_Logical_Units___ (TEAURENAFW-1155).
--  191219  RAKUSE Changes in Register_Active_Services___ (TEAURENAFW-1155).
--  191220  RAKUSE Replaced hardcoded service definitions in Handle_LU_Modification (TEAURENAFW-1155).
--  200116  RAKUSE Added Apply_Default_Definitions__ (TEAURENAFW-1155).
--  200312  RAKUSE Added restriction for service lists defined using '*' (TEAURENAFW-2217).
--  200528  RAKUSE Added/refactored methods for Object Connections admin clients (TEAURENAFW-2906).
--  210712  RAKUSE Refactored Transform_Legacy_Services___ to automaically fix "bad" service definitions (TEAURENAFW-2906).
--  211008  RAKUSE Extended Refresh_Active_List__ with argument refresh_mode_ (TEAURENAFW-6890).
-----------------------------------------------------------------------------
--
--  Dependencies: Object_Connection_SYS base table
--                Client_SYS
--                Dictionary_SYS
--                Error_SYS
--                Language_SYS
--
--  Contents:     Implementation help functions for internal use only
--                Private methods for system management and installation tasks
--                Protected methods for compatibility towards Document_SYS
--                Public methods for client document connection list support
--
--                Two different protocols are used:
--                Key reference: Contain column name and column value. Sorted alphabetically.
--                Key value: Contain only column value. Sorted by column id.
--
--                Key reference is the recommended protocol, but key value is kept
--                for compatibility reasons.
--                Methods for converting between the two are supplied.
--
-----------------------------------------------------------------------------
--
--  Example: SQL> execute Object_Connection_SYS.Enable_Logical_Unit('WorkOrder');
--
--           SQL> execute Object_Connection_SYS.Enable_Logical_Unit('CustInvoice')
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE KEY_REF_PAIR IS RECORD
(
   NAME VARCHAR2(200),
   VALUE VARCHAR2(200)
);
TYPE KEY_REF IS TABLE OF KEY_REF_PAIR INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

text_separator_           CONSTANT VARCHAR2(1) := Client_SYS.text_separator_;
all_logical_units_key_    CONSTANT VARCHAR2(1) := '*';

obj_con_service_          CONSTANT VARCHAR2(32) := '--@ObjectConnectionService';
obj_con_global_service_   CONSTANT VARCHAR2(32) := '--@ObjectConnectionGlobalService';

obj_con_default_view_     CONSTANT VARCHAR2(28) := '--@ObjectConnectionView:';
obj_con_default_package_  CONSTANT VARCHAR2(28) := '--@ObjectConnectionPackage:';
obj_con_default_method_   CONSTANT VARCHAR2(28) := '--@ObjectConnectionMethod:';
obj_con_default_services_ CONSTANT VARCHAR2(28) := '--@ObjectConnectionServices:';


CURSOR get_conn_info (lu_ VARCHAR2) IS
   SELECT view_name,
          package_name,
          method_name,
          service_list,
          based_on
   FROM   object_connection_sys_tab
   WHERE  lu_name = lu_
   AND    Is_Lu_Active__(lu_name) = 'TRUE';
   
CURSOR get_conn_info_all (lu_ VARCHAR2) IS
   SELECT view_name,
          package_name,
          method_name,
          service_list,
          based_on
   FROM   object_connection_sys_tab
   WHERE  lu_name = lu_;
   
obj_conn_rec_ get_conn_info%ROWTYPE;      
--SOLSETFW
CURSOR get_key_ref_info (view_ VARCHAR2) IS
   SELECT column_name
   FROM   dictionary_sys_view_column_act
   WHERE  view_name = view_
   AND    type_flag IN ('P', 'K')
   ORDER BY NLSSORT(column_name,'NLS_SORT=BINARY_AI');
--SOLSETFW
CURSOR get_key_value_info (view_ VARCHAR2) IS
   SELECT column_name, type_flag, column_datatype, column_reference, enumeration
   FROM   dictionary_sys_view_column_act
   WHERE  view_name = view_
   AND    type_flag IN ('P', 'K')
   ORDER BY column_index;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Register_Active_Services___
IS      
   is_srv_         BOOLEAN;
   is_global_srv_  BOOLEAN;
   
   lu_name_ VARCHAR2(100);
   
   CURSOR get_services IS
      SELECT name, TRIM(text) text
               FROM  user_source us
               WHERE type = 'PACKAGE'
               AND text IN ('--@ObjectConnectionService' || chr(10),  -- NOTE! These must be hardcoded or the optimizer will make this slow.
                            '--@ObjectConnectionGlobalService' || chr(10))
               AND   line < 100  -- Optimization, being quicker only checking the top.
               AND NOT EXISTS
                  (SELECT 1
                   FROM user_errors
                   WHERE type = us.type
                   AND name = us.name);                 
BEGIN  
   Unregister_Services___;
   
   FOR service IN get_services LOOP
      is_srv_ := (INSTR(service.text, obj_con_service_) > 0);
      is_global_srv_ := (INSTR(service.text, obj_con_global_service_) > 0);
      IF (is_srv_ OR is_global_srv_) THEN
         lu_name_ := Extract_Lu_Name___(service.name);
         Assert_SYS.Assert_Is_Logical_Unit(lu_name_);
         IF (is_global_srv_) THEN
            Register_Global_Service(lu_name_);
         ELSE
            Register_Service(lu_name_);
         END IF;
      END IF;                 
   END LOOP;
END Register_Active_Services___;


PROCEDURE Transform_Legacy_Services___
IS
   bad_services_table_ Utility_Sys.STRING_TABLE;
   bad_services_count_ NUMBER;
   fixed_services_     object_connection_sys_tab.service_list%TYPE;

   exp_service_table_  Utility_SYS.STRING_TABLE;
   exp_services_       object_connection_sys_tab.service_list%TYPE;
   
   CURSOR get_bad_defined_services IS
      SELECT lu_name, service_list
      FROM   object_connection_sys_tab
      WHERE  instr(service_list, ' ') > 0 OR
             instr(service_list, '^^') > 0 OR
             service_list = '^';
            
   CURSOR get_legacy_services IS
      SELECT lu_name, view_name, package_name, method_name
      FROM   object_connection_sys_tab
      WHERE  service_list like '%*%';  -- Includes '*' and x^y^*^z
BEGIN
   -- Find all connections...
   -- ...with an incorrectly defined service list, that are known by experience, and "repair" them!
   FOR next_ IN get_bad_defined_services LOOP
      Utility_Sys.Tokenize(next_.service_list, text_separator_, bad_services_table_, bad_services_count_);
      FOR i_ IN 1..bad_services_count_ LOOP
        bad_services_table_(i_) := trim(bad_services_table_(i_));  -- Remove all spaces
        IF NOT bad_services_table_(i_) = '*' THEN              -- Ignore *
           fixed_services_ := Utility_SYS.Add_To_Sorted_String_List(fixed_services_, bad_services_table_(i_), text_separator_);
        END IF;
      END LOOP;
      IF (fixed_services_ IS NULL) THEN
         Trace_SYS.Message('Disabling "' || next_.lu_name || '" due to having an empty service list definition');
         Disable_Logical_Unit(next_.lu_name);
      ELSE
         Trace_SYS.Message('Updating service list definitions for "' || next_.lu_name || '", removing illegal characters and/or combinations: ' || next_.service_list || ' -> ' || fixed_services_);
         UPDATE object_connection_sys_tab
            SET service_list = fixed_services_
            WHERE lu_name = next_.lu_name;
      END IF;
   END LOOP;
      
   -- ...defining the service list using '*' and transform them by expanding '*' into a service list with registered services.
   FOR next_ IN get_legacy_services LOOP
      IF (exp_services_ IS NULL) THEN
         -- Lazy load complete service list
         exp_service_table_ := Enumerate_Services;
         FOR i_ IN 1..exp_service_table_.COUNT LOOP         
            -- Ensure the expanded service list is sorted and ends with separator.
            exp_services_ := Utility_SYS.Add_To_Sorted_String_List(exp_services_, exp_service_table_(i_), text_separator_);
         END LOOP;
      END IF;
      
      -- Ensure the service list is set to '*', in case there are other services added as well, before proceeding with Enable_Logical_Unit
      UPDATE object_connection_sys_tab
         SET service_list = '*'
         WHERE lu_name = next_.lu_name
         AND service_list != '*';

      -- Transform the legacy '*' service by explicitly enable each registered service for the LU.
      Enable_Logical_Unit(
         lu_name_      => next_.lu_name,
         service_list_ => exp_services_,
         view_         => next_.view_name,
         package_      => next_.package_name,
         method_       => next_.method_name);
   END LOOP;
END Transform_Legacy_Services___;

   
FUNCTION Extract_Lu_Name___ (
   package_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   lu_name_ VARCHAR2(100);   
BEGIN
   @ApproveDynamicStatement(2020-11-18,rakuse)
   EXECUTE IMMEDIATE 'BEGIN :lu_name_ := ' || package_name_ || '.lu_name_; END;' USING OUT lu_name_;  
   RETURN lu_name_;
END Extract_Lu_Name___;
   

PROCEDURE Apply_Default_Definitions___ (
   lu_name_ IN VARCHAR2)
IS
   package_name_ VARCHAR2(200);
BEGIN
   package_name_ := Dictionary_SYS.Get_Base_Package(lu_name_);
   IF (package_name_ IS NOT NULL) THEN
      Apply_Default_Definitions__(package_name_);
   END IF;
END Apply_Default_Definitions___;


-- Get_Iid_Properties___
--   Same as procedure Reference_SYS.Get_Iid_Properties.
FUNCTION Get_Iid_Properties___ (
   view_name_ IN  VARCHAR2,
   attribute_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   db_column_ VARCHAR2(30);
   --SOLSETFW
   CURSOR find_column IS
      SELECT column_name
         FROM   dictionary_sys_view_column_act
         WHERE  view_name = view_name_
         AND    column_name = attribute_ || '_DB';
BEGIN
   OPEN find_column;
   FETCH find_column INTO db_column_;
   CLOSE find_column;
   RETURN db_column_;
END Get_Iid_Properties___;


-- Separate_Key_Value___
--   Returns the n'th key value in a text-separated concatenated key.
FUNCTION Separate_Key_Value___ (
   table_key_ IN VARCHAR2,
   seq_       IN NUMBER ) RETURN VARCHAR2
IS
   keyval_     VARCHAR2(2000);
   first_pos_  NUMBER(3);
   second_pos_ NUMBER(3);
   strlen_     NUMBER(3);
BEGIN
   IF (seq_ = 1) THEN
      IF (instr(table_key_, text_separator_) = 0) THEN
         keyval_ := table_key_;
      ELSE
         keyval_ := substr(table_key_, 1, instr(table_key_, text_separator_, seq_) - 1);
      END IF;
   ELSE
      first_pos_  := instr(table_key_, text_separator_, 1, seq_ -1) + 1;
      second_pos_ := instr(table_key_, text_separator_, 1, seq_ );
      strlen_     := second_pos_ - first_pos_;
      IF (second_pos_ = 0) THEN
         keyval_ := substr(table_key_, first_pos_);
      ELSE
         keyval_ := substr(table_key_, first_pos_, strlen_);
      END IF;
   END IF;
   RETURN(keyval_);
END Separate_Key_Value___;


-- Get_Description___
--   Returns the description for a document connected LU-instance by
--   using dynamic PL/SQL to retrieve value by trying to call the
--   pre-defined method name  with the keys for the specific LU.
FUNCTION Get_Description___ (
   package_   IN VARCHAR2,
   method_    IN VARCHAR2,
   keys_      IN VARCHAR2,
   datatypes_ IN VARCHAR2) RETURN VARCHAR2
IS
   TYPE string_list IS TABLE OF VARCHAR2(4000) INDEX BY BINARY_INTEGER;
   TYPE number_list IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
   str_list_ string_list;
   num_list_ number_list;
   cid_      INTEGER;
   stmt_     VARCHAR2(200);
   ignore_   INTEGER;
   plist_    VARCHAR2(30);
   desc_     VARCHAR2(2000);
   cnt_      NUMBER := 1;
   dind_     NUMBER := 0;
   kind_     NUMBER := 0;
   dstart_   NUMBER;
   kstart_   NUMBER;
   type_     VARCHAR2(10);
   str_cnt_  NUMBER := 1;
   num_cnt_  NUMBER := 1;
BEGIN
   --
   -- Check number of parameters and create a parameter list
   --
   LOOP
      dind_ := instr(datatypes_, text_separator_, 1, cnt_);
      EXIT WHEN dind_ = 0;
      plist_ := plist_||':p'||cnt_||',';
      cnt_ := cnt_ + 1;
   END LOOP;
   --
   -- Remove last comma and parse the statement
   --
   plist_ := substr(plist_, 1, length(plist_) - 1);
   stmt_ := 'BEGIN :desc := '||package_||'.'||method_||'('||plist_||'); END; ';
   cid_ := dbms_sql.open_cursor;
   Assert_SYS.Assert_Is_Package_Method(package_, method_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   dbms_sql.parse(cid_, stmt_, dbms_sql.native);
   dbms_sql.bind_variable(cid_, 'desc', desc_, 2000);
   --
   -- Check the key types and bind them correctly to the keys
   --
   cnt_ := 0;
   dind_ := 0;
   kind_ := 0;
   LOOP
      cnt_ := cnt_ + 1;
      dstart_ := dind_ + 1;
      kstart_ := kind_ + 1;
      dind_ := instr(datatypes_, text_separator_, 1, cnt_);
      kind_ := instr(keys_, text_separator_, 1, cnt_);
      EXIT WHEN dind_ = 0 OR kind_ = 0;
      type_ := substr(datatypes_, dstart_, dind_ - dstart_);
      IF (type_ = 'VARCHAR2') THEN
         str_list_(str_cnt_) := substr(keys_, kstart_, kind_ - kstart_);
         dbms_sql.bind_variable(cid_, 'p'||cnt_, str_list_(str_cnt_));
         str_cnt_ := str_cnt_ + 1;
      ELSE
         num_list_(num_cnt_) := to_number(substr(keys_, kstart_, kind_ - kstart_));
         dbms_sql.bind_variable(cid_, 'p'||cnt_, num_list_(num_cnt_));
         num_cnt_ := num_cnt_ + 1;
      END IF;
   END LOOP;
   --
   -- Execute the statement and return the out parameter
   --
   ignore_ := dbms_sql.execute(cid_);
   dbms_sql.variable_value( cid_, 'desc', desc_);
   dbms_sql.close_cursor(cid_);
   RETURN(desc_);
EXCEPTION
   -- If any errors, just return NULL
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      RETURN(NULL);
END Get_Description___;


FUNCTION Get_Instance_Description___ (
   lu_name_     IN VARCHAR2,
   view_name_   IN VARCHAR2,
   key_ref_     IN VARCHAR2,
   by_position_ IN BOOLEAN ) RETURN VARCHAR2
IS
   value_       VARCHAR2(2000);
   temp_        VARCHAR2(2000);
   prompt_      VARCHAR2(2000);
   count_       NUMBER;
   key_list_    VARCHAR2(2000);
   tmp_key_ref_ VARCHAR2(2000);
   tmp_view_    VARCHAR2(30) := view_name_;
   
   CURSOR get_key_attr IS
      SELECT key_attr
      FROM   object_connection_language_tab
      WHERE  lu_name = lu_name_
      AND    lang_code = Fnd_Session_API.Get_Language;   
BEGIN
   -- Ensure a real key reference list
   IF (instr(key_ref_, '=') = 0) THEN
      -- This is most likely a key_value instead of a key_ref... Convert it!
      tmp_key_ref_ := Convert_To_Key_Reference(lu_name_, key_ref_);
   ELSE
      tmp_key_ref_ := key_ref_;
   END IF;

   -- Replace the server value columns with the client values for presentation
   tmp_key_ref_ := Replace_Server_Values___(lu_name_, tmp_key_ref_);

   -- Try fetch from language connection table
   OPEN  get_key_attr;
   FETCH get_key_attr INTO key_list_;
   CLOSE get_key_attr;

   IF (key_list_ IS NOT NULL) THEN
      -- Initiate
      count_ := 1;
      prompt_ := Separate_Key_Value___(key_list_, count_);
      value_  := Client_SYS.Get_Key_Reference_Value(tmp_key_ref_, count_);
      WHILE prompt_ IS NOT NULL LOOP
         temp_ := temp_||', '||prompt_||': '||value_;
         count_ := count_ + 1;
         prompt_ := Separate_Key_Value___(key_list_, count_);
         value_  := Client_SYS.Get_Key_Reference_Value(tmp_key_ref_, count_);
      END LOOP;
      RETURN substr(temp_, 3, 200);
   END IF;
   --
   -- Otherwise fetch from LU-dictionary (the cache has not been updated)
   --
   count_ := 0;
   IF (tmp_view_ IS NULL) THEN
      tmp_view_ := Dictionary_SYS.Get_Base_View(lu_name_);
   END IF;
   FOR col IN get_key_ref_info(tmp_view_) LOOP
      count_ := count_ + 1;
      prompt_ := Language_SYS.Translate_Item_Prompt_(tmp_view_||'.'||col.column_name, col.column_name, 0);
      IF by_position_ THEN
         value_ := Client_SYS.Get_Key_Reference_Value(tmp_key_ref_, count_);
      ELSE
         value_ := Client_SYS.Get_Key_Reference_Value(tmp_key_ref_, col.column_name);
      END IF;
      IF (count_ = 1) THEN
         temp_ := prompt_||': '||value_;
      ELSE
         temp_ := temp_||', '||prompt_||': '||value_;
      END IF;
   END LOOP;
   RETURN(substr(temp_, 1, 200));
END Get_Instance_Description___;


PROCEDURE Delete_Object_Connection___ (
  service_name_   IN VARCHAR2,
  lu_name_        IN VARCHAR2,
  key_ref_        IN VARCHAR2 )
IS
   TYPE REF_CURSOR IS REF CURSOR;
   TYPE OBJ_REC    IS RECORD (objid VARCHAR2(2000),objversion VARCHAR2(2000));
   TYPE OBJ_LIST   IS TABLE OF OBJ_REC;

   ref_cursor_ REF_CURSOR;
   obj_list_   OBJ_LIST;
   view_name_  VARCHAR2(30);
   pkg_name_   VARCHAR2(30);
   stmt_       VARCHAR2(5000);
   info_       VARCHAR2(2000);
   lu_installed_ BOOLEAN;   

BEGIN
   BEGIN
      -- Assert that the service lu is valid. This should work ok since we get the LU from the foundation
      Assert_SYS.Assert_Is_Logical_Unit(service_name_);   
      -- Get the view name from the service lu name
      view_name_ := Get_View_Name___(service_name_);
      Assert_SYS.Assert_Is_View(view_name_);
      lu_installed_:= TRUE;
   EXCEPTION
      WHEN OTHERS THEN
         lu_installed_:= FALSE;
         Trace_SYS.Message('LU ' || service_name_ || ' is not installed.');
   END;  
   
   IF(lu_installed_ = TRUE) THEN
      -- SQL to locate the object id and version
      stmt_ := 'SELECT objid, objversion FROM ' || view_name_ || ' WHERE lu_name = :lu_name_ AND key_ref = :key_ref_';
      
      @ApproveDynamicStatement(2012-02-18,usralk)
      OPEN  ref_cursor_ FOR stmt_ USING lu_name_, key_ref_;
      FETCH ref_cursor_ BULK COLLECT INTO obj_list_;
      CLOSE ref_cursor_;
      
      IF obj_list_.COUNT > 0 THEN
         -- Try to locate the package name from the service lu name
         pkg_name_ := view_name_ || '_API';
         Assert_SYS.Assert_Is_Package(pkg_name_);
         
         -- Not the cutest code block around but we have to settle for this solution for now.
         stmt_ := 'BEGIN '||pkg_name_||'.Remove__(:info, :objid, :objversion, :action); END;';
         
         FOR ix_ IN obj_list_.FIRST..obj_list_.LAST LOOP
            @ApproveDynamicStatement(2012-02-18,usralk)
            EXECUTE IMMEDIATE stmt_ USING OUT info_, obj_list_(ix_).objid, obj_list_(ix_).objversion, 'DO';
         END LOOP;
      END IF;
   END IF;
END Delete_Object_Connection___;


-- Replace_Client_Values___
--   This method checks to see if any key reference column is an IID value, if so
--   it replaces that column with it's DB column and value. Of something goes wrong
--   this method will revert to the original key_ref
FUNCTION Replace_Client_Values___ (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE ref_cur_type_ IS REF CURSOR;

   tok_key_ref_      KEY_REF;

   db_value_column_  VARCHAR2(100)   := NULL;
   view_name_        VARCHAR2(200);
   stmt_             VARCHAR2(1000);
   db_value_         VARCHAR2(100);
   cleaned_key_ref_  VARCHAR2(10000) := NULL;
   somethings_wrong_ VARCHAR2(10)    := 'FALSE';
   objid_            VARCHAR2(200);
   objversion_       VARCHAR2(200);

   num_keys_      NUMBER;

   cur_get_encoded_value_ ref_cur_type_;

BEGIN
   view_name_ := Get_View_Name___(lu_name_);

   Tokenize_Key_Ref__ ( key_ref_, tok_key_ref_, num_keys_ );


   FOR counter_ IN 1..num_keys_ LOOP

      db_value_column_ := Get_Iid_Properties___ ( view_name_, tok_key_ref_ ( counter_ ).NAME );

      IF NOT db_value_column_ IS NULL THEN
         -- This means that this is an IID... hopefully. So we need to get the encode method

         Get_Record_From_View___ ( lu_name_, key_ref_, objid_, objversion_ );

         Assert_Sys.Assert_Is_View_Column(view_name_, db_value_column_);

         stmt_ := 'SELECT ' || db_value_column_ || ' FROM ' || view_name_ || ' WHERE '
                            || 'OBJID = :objid AND OBJVERSION = :objversion';

         -- SELECT BOM_TYPE_DB FROM ROUTING_OPERATION WHERE OBJID='XXXXX' AND OBJVERSION = 'XXXXX'

         -- Safe due to Assert_Sys.Assert_Is_View_Column check
         @ApproveDynamicStatement(2009-08-11,nabalk)
         OPEN cur_get_encoded_value_ FOR stmt_ USING objid_, objversion_ ;
         FETCH cur_get_encoded_value_ INTO db_value_;
         CLOSE cur_get_encoded_value_;

         IF db_value_ IS NULL THEN
            -- Somethings wrong... Likely that the client value was not valid.
            somethings_wrong_ := 'TRUE';
         END IF;

      END IF;


      -- Build the clean key ref
      IF db_value_column_ IS NULL THEN
         -- This is not an IID coloumn so we leave it as it is
         cleaned_key_ref_ := cleaned_key_ref_ || tok_key_ref_ ( counter_ ).NAME || '=' ||
         tok_key_ref_ ( counter_ ).VALUE || text_separator_;
      ELSE
         -- This means that this is an IID coloumn and that the db name and values should be used
         cleaned_key_ref_ := cleaned_key_ref_ || db_value_column_ || '=' || db_value_ || text_separator_;
      END IF;

   END LOOP;

   IF NOT somethings_wrong_ = 'TRUE' THEN
      RETURN cleaned_key_ref_;
   ELSE
      Trace_SYS.Message ('Error occured while replacing client values in ' || lu_name_ || '.' || key_ref_ );
      RETURN key_ref_;
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      -- If something goes wrong, revert to the original key ref
      Trace_SYS.Message ('Error occured while replacing client values in ' || lu_name_ || '.' || key_ref_ );
      RETURN key_ref_;
END Replace_Client_Values___;


PROCEDURE Get_Record_From_View___ (
  lu_name_    IN  VARCHAR2,
  key_ref_    IN  VARCHAR2,
  objid_      OUT VARCHAR2,
  objversion_ OUT VARCHAR2)
IS
  tok_key_ref_   KEY_REF;

  stmt_          VARCHAR2(10000);
  primary_view_  VARCHAR2(50); -- Max 30 but just in case...

  num_keys_      NUMBER;
  dummy_         NUMBER;
  cursor_        NUMBER;
  temp_value_    DATE;

BEGIN
  objid_      := NULL;
  objversion_ := NULL;

  primary_view_ := Get_View_Name___(lu_name_);
  Assert_SYS.Assert_Is_View(primary_view_);

  Tokenize_Key_Ref__ ( key_ref_, tok_key_ref_, num_keys_ );

  -- Create the sql statement
  stmt_ := 'SELECT OBJID, OBJVERSION FROM ' || primary_view_ || ' WHERE ';
  FOR key_counter_  IN 1..num_keys_ LOOP
     Assert_SYS.Assert_Is_Table_Column( primary_view_ , tok_key_ref_( key_counter_ ).NAME );
     stmt_ := stmt_ || tok_key_ref_( key_counter_ ).NAME || ' = :bindval' || key_counter_; -- NAME = :bindvarX

     IF key_counter_ < num_keys_ THEN
        stmt_ := stmt_ || ' AND ';
     END IF;
  END LOOP;

  -- Cursor pelimineries
  cursor_ := dbms_sql.open_cursor;
  -- Secured using Assert_SYS.Assert_Is_Table_Column
  @ApproveDynamicStatement(2007-07-26,pemase)
  dbms_sql.parse (cursor_, stmt_, dbms_sql.native);
  dbms_sql.define_column ( cursor_, 1, objid_, 200);
  dbms_sql.define_column ( cursor_, 2, objversion_, 200);

  -- Bind variables
  FOR key_counter_ IN 1..num_keys_ LOOP
     IF Installation_SYS.Get_Column_Type(primary_view_,tok_key_ref_( key_counter_ ).NAME) = 'DATE'  THEN
       temp_value_ := to_date(tok_key_ref_( key_counter_ ).VALUE, Client_SYS.date_format_);
       dbms_sql.bind_variable(cursor_, 'bindval' || key_counter_, temp_value_);
     ELSE
       dbms_sql.bind_variable(cursor_, 'bindval' || key_counter_, tok_key_ref_( key_counter_ ).VALUE);
     END IF;
  END LOOP;

  -- Execute the cursor
  dummy_ := dbms_sql.execute ( cursor_ );
  dummy_ := dbms_sql.fetch_rows ( cursor_ );
  dbms_sql.column_value ( cursor_, 1, objid_ );
  dbms_sql.column_value ( cursor_, 2, objversion_ );
  dbms_sql.close_cursor ( cursor_ );

  EXCEPTION
     WHEN OTHERS THEN
        Trace_SYS.Message ('Object_Connection_SYS.Get_Record_From_View___: Exception occured while looking for ' || lu_name_ || key_ref_ );
        IF (dbms_sql.is_open(cursor_)) THEN
           dbms_sql.close_cursor( cursor_ );
        END IF;
        Error_SYS.Appl_General(service_, 'OBJCONGETFROMVIEW: Error when executing ":P1". Check for KEY_REF validity.', stmt_ );
END Get_Record_From_View___;


-- Replace_Server_Values___
--   This method replaces server values in a key-ref with it's client counterparts.
FUNCTION Replace_Server_Values___ (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2) RETURN VARCHAR2
IS
   TYPE ref_cur_type_ IS REF CURSOR;

   view_name_           VARCHAR2(200);
   client_column_       VARCHAR2(30);

   tok_key_ref_         KEY_REF;
   num_keys_            NUMBER;
   objid_               VARCHAR2(200);
   objversion_          VARCHAR2(200);
   somethings_wrong_    VARCHAR2(10)    := 'FALSE';

   cleaned_key_ref_     VARCHAR2(10000) := NULL;
   stmt_                VARCHAR2(1000) := NULL;
   client_value_        VARCHAR2(1000) := NULL;

   cur_get_client_value_   ref_cur_type_;

BEGIN
   -- Get the view name
   view_name_ := Get_View_Name___(lu_name_);

   -- Tokenize the key reference
   Tokenize_Key_Ref__ ( key_ref_, tok_key_ref_, num_keys_ );

   -- Grab the record
   Get_Record_From_View___ ( lu_name_, key_ref_, objid_, objversion_ );

   -- Iterate through the keys replacing database ones for client ones.
   FOR counter_ IN 1..num_keys_ LOOP
      client_column_ := Get_Client_Column___ (view_name_, tok_key_ref_ (counter_).NAME);

      IF (client_column_ IS NOT NULL) THEN
         Assert_Sys.Assert_Is_View_Column(view_name_, client_column_);
         -- Build query to get the value
         stmt_ := 'SELECT ' || client_column_ || ' FROM ' || view_name_ || ' WHERE ' ||
                  'OBJID = :objid AND OBJVERSION = :objversion_ ';

         -- SELECT BOM_TYPE FROM ROUTING_OPERATION WHERE OBJID='XXXXX' AND OBJVERSION = 'XXXXX'

         -- Fetch the value
         client_value_ := NULL; -- Just in case...

         -- Safe due to Assert_Sys.Assert_Is_View_Column check
         @ApproveDynamicStatement(2009-08-11,nabalk)
         OPEN cur_get_client_value_ FOR stmt_ USING objid_ , objversion_;
         FETCH cur_get_client_value_ INTO client_value_;
         CLOSE cur_get_client_value_;

         IF client_value_ IS NULL THEN
            -- Either the key_ref is mangled, or we are querying the wrong view, or the row has been removed.
            somethings_wrong_ := 'TRUE';
         END IF;
      END IF;


      -- Build the clean key ref
      IF client_column_ IS NULL THEN
         -- This is not an IID coloumn so we leave it as it is
         cleaned_key_ref_ := cleaned_key_ref_ || tok_key_ref_( counter_ ).NAME || '=' ||
         tok_key_ref_( counter_ ).VALUE || text_separator_;
      ELSE
         -- This means that this is an IID coloumn and that the client name and values should be used
         cleaned_key_ref_ := cleaned_key_ref_ || client_column_ || '=' || client_value_ || text_separator_;
      END IF;

   END LOOP;

   -- Check to see if everything went ok.
   IF somethings_wrong_ = 'TRUE' THEN
      Trace_SYS.Message ('Error occured while replacing server values in ' || lu_name_ || '.' || key_ref_ );
      RETURN key_ref_;
   ELSE
      RETURN cleaned_key_ref_; -- Yipeee!!!
   END IF;

EXCEPTION
   WHEN OTHERS THEN
      -- If something goes wrong, revert to the original key ref
      Trace_SYS.Message ('Error occured while replacing server values in ' || lu_name_ || '.' || key_ref_ );
      RETURN key_ref_;
END Replace_Server_Values___;


-- Get_Client_Column___
--   This function returns a matching client column for the passed db column.
FUNCTION Get_Client_Column___ (
   view_name_ IN  VARCHAR2,
   attribute_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   client_column_ VARCHAR2(30);
   temp_          VARCHAR2(30);

   CURSOR find_column IS
      SELECT column_name
         FROM   user_tab_columns
         WHERE  table_name = view_name_
         AND    column_name = substr( attribute_, 1, length(attribute_) - 3 ); -- COLUMN_DB -> COLUMN
BEGIN
   -- Check if this is a _DB column
   temp_ := substr(attribute_, length(attribute_) - 2, length(attribute_));
   IF temp_ = '_DB' THEN
      FOR hit IN find_column LOOP
         client_column_ := hit.column_name;
         RETURN client_column_;
      END LOOP;
   END IF;

   -- Either this is not a db column, or no matching client column was found.
   RETURN NULL;
END Get_Client_Column___;


FUNCTION Refresh_Service_List___ RETURN VARCHAR2
IS
   CURSOR list_of_services IS
      SELECT service_list
      FROM object_connection
      WHERE service_list != '*';

   services_           Utility_Sys.STRING_TABLE;
   num_serv_           NUMBER;
   total_service_list_ VARCHAR2(32000);
BEGIN
   FOR rec_ IN list_of_services LOOP
      Utility_Sys.Tokenize(rec_.service_list, text_separator_, services_, num_serv_);
      FOR counter_ IN 1..num_serv_ LOOP
        IF NOT services_(counter_) = '*' THEN -- Ignore *
           total_service_list_ := Utility_SYS.Add_To_Sorted_String_List(total_service_list_, services_(counter_), text_separator_);
        END IF;
      END LOOP;
   END LOOP;
   RETURN total_service_list_;
END Refresh_Service_List___;


-- Get_View_Name___
--   Return the view that should be used in connection with the given LU name.
FUNCTION Get_View_Name___ (
   lu_name_     IN VARCHAR2,
   only_active_ IN BOOLEAN DEFAULT TRUE) RETURN VARCHAR2
IS
   view_name_  object_connection_sys_tab.view_name%TYPE;
   CURSOR get_view_name(lu_name_ VARCHAR2) IS
      SELECT view_name
        FROM object_connection
       WHERE lu_name = lu_name_;
   CURSOR get_view_name_all(lu_name_ VARCHAR2) IS
      SELECT view_name
        FROM object_connection_sys_tab
       WHERE lu_name = lu_name_;
BEGIN

   -- Get the view name (First try from the object_connection)
   IF only_active_ THEN
      OPEN  get_view_name(lu_name_);
      FETCH get_view_name INTO view_name_;
      CLOSE get_view_name;
   ELSE
      OPEN  get_view_name_all(lu_name_);
      FETCH get_view_name_all INTO view_name_;
      CLOSE get_view_name_all;
   END IF;

   -- Get the view name (Get the BASE view if nothing found so far)
   IF view_name_ IS NULL THEN
      view_name_ := Dictionary_SYS.Get_Base_View(lu_name_);
   END IF;

   -- Something is very wrong: send the db name of the lu to caller.
   IF view_name_ IS NULL THEN
      view_name_ := Dictionary_SYS.Clientnametodbname_(lu_name_);
   END IF;

   RETURN view_name_;
END Get_View_Name___;


FUNCTION Get_Active_Service_Package___ (
   service_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   pkg_name_ object_connection.package_name%TYPE;
   
   CURSOR get_pkg(service_name_ VARCHAR2) IS
      SELECT package_name
        FROM object_connection
       WHERE lu_name = service_name_;
BEGIN
   -- Get the package name (First try from the object_connection)
   OPEN  get_pkg(service_name_);
   FETCH get_pkg INTO pkg_name_;
   CLOSE get_pkg;

   -- Get the package name (Get the BASE package if nothing found so far)
   IF pkg_name_ IS NULL THEN
      pkg_name_ := Dictionary_SYS.Get_Base_Package(service_name_);
   END IF;
   
   RETURN pkg_name_;
END Get_Active_Service_Package___;


FUNCTION Get_Count_From_View___ (
   service_name_      IN VARCHAR2,
   lu_name_           IN VARCHAR2,
   key_ref_           IN VARCHAR2,
   service_view_name_ IN VARCHAR2 DEFAULT NULL )RETURN NUMBER
IS
   count_       NUMBER;
   temp_view_   VARCHAR2(30);
   stmt_        VARCHAR2(2000);
BEGIN
   IF (service_view_name_ IS NULL) THEN
      temp_view_ := Get_View_Name___(service_name_);
   ELSE
      temp_view_ := service_view_name_;
   END IF;

   Assert_SYS.Assert_Is_View(temp_view_);
   stmt_ :=  ' SELECT COUNT(*)
                 FROM '||temp_view_||
              ' WHERE lu_name = :lu_name
                  AND key_ref = :key_ref';
   -- Safe due to Assert_SYS.Assert_Is_View check
   @ApproveDynamicStatement(2014-03-09,usralk)
   EXECUTE IMMEDIATE stmt_ INTO count_ USING lu_name_, key_ref_;
   RETURN NVL(count_, 0);  
END Get_Count_From_View___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Refresh_Active_List__ (
   dummy_        IN NUMBER,
   refresh_mode_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Refresh_Active_List___(NULL, refresh_mode_);
END Refresh_Active_List__;

PROCEDURE Refresh_Active_List___ (
   lu_name_ IN VARCHAR2,
   refresh_mode_    IN VARCHAR2 DEFAULT NULL)
IS
   every_lu_mode_  BOOLEAN := lu_name_ IS NULL;
   i_              BINARY_INTEGER := 1;
   key_attr_       object_connection_language_tab.key_attr%TYPE;
      
   TYPE language_table IS TABLE OF object_connection_language_tab%ROWTYPE INDEX BY BINARY_INTEGER;
   lang_arr_ language_table;

   TYPE key_name_table IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
   key_temp_arr_  key_name_table;
   
   -- Returns all lu's                 (every_lu_mode_ = TRUE) or
   -- just the defined one in lu_name_ (every_lu_mode_ = FALSE).
   CURSOR get_lu IS
     SELECT lu_name,
            view_name,
            package_name,
            based_on
       FROM object_connection
       WHERE lu_name = NVL(lu_name_, lu_name)
       AND lu_name != all_logical_units_key_;

   CURSOR get_langs IS
     SELECT lang_code
       FROM language_code_tab
      WHERE installed = 'TRUE'
      ORDER BY lang_code ASC;

BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Refresh_Active_List__');
   -- Registers all entities having decorations stating it's an Objection Connection service.   
   IF (every_lu_mode_) THEN
      Register_Active_Services___;
   END IF;
   Transform_Legacy_Services___;
   --
   -- Fill cache table from LU-dictionary
   -- (This process will create the cache only for installed languages)
   --
   -- object_connection_sys_tab:
   -- VIEW_NAME      The same as when enabling or fetched from LU-dictionary
   -- PACKAGE_NAME   The same as when enabling or generated from view
   -- BASED_ON       Defined on the LU comment.
   --
   -- object_connection_language_tab:
   -- KEY_ATTR       List of language independent prompts for each language found
   -- LU_ATTR        Language independent description for each language found

   -- For performance reasons, do the search for languages only once and reuse the result.
   -- Manually add PROG to the list
   lang_arr_(i_).lang_code := 'PROG';         
   FOR lang IN get_langs LOOP
      i_ := i_ + 1;
      lang_arr_(i_).lang_code := lang.lang_code;     
   END LOOP;
   
   IF (refresh_mode_ = 'PURGE') THEN
      Purge_Obsolete_Connections___;
   END IF;
      
   FOR rec IN get_lu LOOP
      BEGIN
         IF (NOT Dictionary_SYS.Logical_Unit_Is_Installed(rec.lu_name)) THEN
            Log_SYS.Fnd_Trace_(Log_SYS.warning_, 'WARNING! Object Connection Cache refresh can not handle logical unit ' || rec.lu_name || ' due to not being installed.');
            CONTINUE;
         END IF;
         -- If no view registered, find the view from dictionary information
         IF rec.view_name IS NULL THEN
            rec.view_name := Dictionary_SYS.Get_Base_View(rec.lu_name);
         END IF;
         
         -- If no package registered, use the view given by name standard
         IF rec.package_name IS NULL THEN
            rec.package_name := Dictionary_SYS.Get_Base_Package(rec.lu_name);
         END IF;
         
         rec.based_on := Calc_Based_on___(rec.lu_name);

         -- Update existing records with updated information
         UPDATE object_connection_sys_tab
            SET view_name    = rec.view_name,
                package_name = rec.package_name,
                based_on     = rec.based_on
            WHERE lu_name = rec.lu_name;
                     
         -- Define the language specific attributes for all active languages.
         -- Start by deleting all old language details...
         DELETE FROM object_connection_language_tab         
            WHERE lu_name = rec.lu_name;

         IF (rec.view_name IS NOT NULL) THEN
            -- For performance reasons, do the search for keys only once and reuse the result.
            OPEN get_key_ref_info(rec.view_name);
            FETCH get_key_ref_info BULK COLLECT INTO key_temp_arr_;
            CLOSE get_key_ref_info;
            
            IF (key_temp_arr_.COUNT > 0) THEN
               FOR lng IN 1..lang_arr_.LAST LOOP
                  key_attr_ := NULL;
                  -- Format the 'key_attr' for the LU
                  FOR k_ IN 1..key_temp_arr_.COUNT LOOP
                     key_attr_ := key_attr_ ||
                              Language_SYS.Translate_Item_Prompt_(rec.view_name||'.'||key_temp_arr_(k_), key_temp_arr_(k_), 0, lang_arr_(lng).lang_code)||
                              text_separator_;
                  END LOOP;
                  lang_arr_(lng).lu_name := rec.lu_name;     
                  lang_arr_(lng).lu_attr := Language_SYS.Translate_Lu_Prompt_(rec.lu_name, lang_arr_(lng).lang_code);
                  lang_arr_(lng).key_attr := key_attr_;            
               END LOOP; 

               -- ...finally, instart all new language details.
               FORALL x IN lang_arr_.FIRST..lang_arr_.LAST
                  INSERT INTO object_connection_language_tab
                  VALUES lang_arr_(x);
            END IF;
         END IF;
         
      EXCEPTION
         WHEN OTHERS THEN
            Log_SYS.Fnd_Trace_(Log_SYS.error_, 'ERROR: Object Connection Cache refresh failed for logical unit '||rec.lu_name||' due to ['||SUBSTR(SQLERRM,1,100)||']');
      END;
   END LOOP;
   IF (every_lu_mode_) THEN
      Cache_Management_API.Refresh_Cache('ObjectConnection');
   END IF;
END Refresh_Active_List___;

PROCEDURE Purge_Obsolete_Connections___
IS
   lu_name_arr_ Utility_SYS.STRING_TABLE;  
 
   CURSOR get_uninstalled_lu IS
      SELECT lu_name
      FROM   object_connection
      WHERE  Dictionary_SYS.Logical_Unit_Is_Installed_Num(lu_name) = 0
      AND    lu_name != '*';
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.warning_, '--- Object Connection Purge Start ---');
   OPEN get_uninstalled_lu;
   FETCH get_uninstalled_lu BULK COLLECT INTO lu_name_arr_;
   CLOSE get_uninstalled_lu;
   
   IF (lu_name_arr_.COUNT = 0) THEN
      Log_SYS.Fnd_Trace_(Log_SYS.warning_, 'No Object Connections could be found using uninstalled Logical Units!');
   ELSE
      Log_SYS.Fnd_Trace_(Log_SYS.warning_, 'Found ' || lu_name_arr_.COUNT || ' Object Connections using uninstalled Logical Units -> Removing Object Connection for:');
      FOR i IN 1..lu_name_arr_.COUNT LOOP
        Log_SYS.Fnd_Trace_(Log_SYS.warning_, '  ' || i || '. ' || lu_name_arr_(i));
        Object_Connection_SYS.Disable_Logical_Unit(lu_name_arr_(i));       
      END LOOP;     
   END IF; 
   Log_SYS.Fnd_Trace_(Log_SYS.warning_, '--- Object Connection Purge End ---');     
END Purge_Obsolete_Connections___;
   
FUNCTION Calc_Based_on___ (
  lu_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   based_on_ VARCHAR2(30);
   
   CURSOR get_based_on IS
      SELECT substr(comments, instr(comments, 'BASEDON=')+8, instr(comments, '^BASEDONFILTER=') - instr(comments, 'BASEDON=') - 8)
      from user_tab_comments
      WHERE table_type = 'VIEW'
      AND table_name = Dictionary_SYS.Clientnametodbname_(lu_name_)
      AND instr(comments, 'BASEDON=') > 0;         
BEGIN
   OPEN  get_based_on;
   FETCH get_based_on INTO based_on_;
   CLOSE get_based_on;
   
   IF (lu_name_ = based_on_) THEN
      RETURN NULL;   
   END IF;
   
   RETURN based_on_;
END Calc_Based_on___;

@UncheckedAccess
PROCEDURE Tokenize_Key_Ref__ (
   key_ref_           IN  VARCHAR2,
   tokenized_key_ref_ OUT KEY_REF,
   num_keys_          OUT NUMBER )
IS
   keys_          Utility_SYS.STRING_TABLE;
   key_value_     Utility_SYS.STRING_TABLE;

   sanitized_key_value_   VARCHAR2(1000);
   substitute_            VARCHAR2(40) := '___sep_' || to_char(SYSDATE, Client_SYS.date_format_) || '___';
   equals_pos_            NUMBER;
   length_                NUMBER;
   count_                 NUMBER;
BEGIN
   Utility_SYS.Tokenize ( key_ref_, text_separator_, keys_, num_keys_ );
   FOR pair_counter_ IN 1..num_keys_ LOOP
      -- We ensure that all leading '=' characters are encoded to another token, so as to allow '=' in key values.
      length_ := length ( keys_ ( pair_counter_ ) );
      equals_pos_ := instr( keys_ ( pair_counter_ ), '='); -- The first occurence of '=' within the name value pair.

      -- The new sanitized key value pair will have the substitute token as a separator instead of the first '='.
      sanitized_key_value_ := substr( keys_ ( pair_counter_ ), 1, equals_pos_ - 1 ) ||
                              substitute_ ||
                              substr( keys_ ( pair_counter_ ), equals_pos_ + 1, length_ );

      Utility_SYS.Tokenize ( sanitized_key_value_ , substitute_, key_value_, count_ );
      IF count_ = 2 THEN
         tokenized_key_ref_( pair_counter_ ).NAME  := key_value_ ( 1 );
         tokenized_key_ref_( pair_counter_ ).VALUE := key_value_ ( 2 );
      ELSIF count_ = 1 THEN 
         tokenized_key_ref_( pair_counter_ ).NAME  := key_value_ ( 1 );
         tokenized_key_ref_( pair_counter_ ).VALUE := NULL;
      END IF;   
   END LOOP;
END Tokenize_Key_Ref__;


FUNCTION Get_Lu_Default_Definition__ (
   lu_name_ IN VARCHAR2,
   definition_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Do_Cascade_Delete');
   RETURN Get_Default_Definition__(Dictionary_SYS.Get_Base_Package(lu_name_), definition_name_);  
END Get_Lu_Default_Definition__;

FUNCTION Get_Default_Definition__ (
   package_name_ IN VARCHAR2,
   definition_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   value_       VARCHAR2(2000);
   source_line_ VARCHAR2(100);
   
   CURSOR get_definition IS
      SELECT text
         FROM  user_source
         WHERE type = 'PACKAGE'
         AND   name = package_name_
         AND   line < 100  -- Optimization, being quicker only checking the top.
         AND   text LIKE source_line_ || '_%';         
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Get_Default_Definition__');
   CASE definition_name_
      WHEN 'VIEW' THEN
         source_line_ := obj_con_default_view_;
      WHEN 'PACKAGE' THEN
         source_line_ := obj_con_default_package_;
      WHEN 'METHOD' THEN
         source_line_ := obj_con_default_method_;
      WHEN 'SERVICES' THEN
         source_line_ := obj_con_default_services_;
      ELSE
         RETURN '';
   END CASE;
      
   OPEN get_definition;
   FETCH get_definition INTO value_;
   CLOSE get_definition;
   
   RETURN TRIM(REPLACE(REPLACE(value_, source_line_, ''), CHR(10), ''));  
END Get_Default_Definition__;


PROCEDURE Apply_Default_Definitions__(
  compute_ IN BOOLEAN DEFAULT FALSE)
IS
   cache_name_                CONSTANT VARCHAR2(30) := 'ObjectConnectionDefinitions';
   cache_refreshed_date_      DATE;
   cache_refreshed_timestamp_ VARCHAR2(19);

   CURSOR get_service_consumers IS
      SELECT NAME
         FROM  user_source us
         WHERE type = 'PACKAGE'
         AND   text like obj_con_default_services_ || '_%'
         AND   line < 100     -- Optimization, being quicker only checking the top.
         AND  (name like '%_API' OR name like '%_SYS')
         AND NOT EXISTS
            (SELECT 1
             FROM user_errors
             WHERE type IN ('PACKAGE', 'PACKAGE BODY')
             AND name = us.name);
             
   CURSOR get_updated_service_consumers IS
      SELECT NAME
         FROM  user_source us
         WHERE type = 'PACKAGE'
         AND   text like obj_con_default_services_ || '_%'
         AND   line < 100     -- Optimization, being quicker only checking the top.
         AND  (name like '%_API' OR name like '%_SYS')
         AND NOT EXISTS
            (SELECT 1
             FROM user_errors
             WHERE type IN ('PACKAGE', 'PACKAGE BODY')
             AND name = us.name)
         AND EXISTS
            (SELECT 1
             FROM user_objects uo
             WHERE timestamp > cache_refreshed_timestamp_
             AND   object_name = name 
             AND   object_type = type);
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Apply_Default_Definitions__');
   IF (compute_) THEN
     cache_refreshed_date_ := Cache_Management_API.Get_Refreshed(cache_name_);
   END IF;
   
   IF (compute_ = FALSE OR cache_refreshed_date_ IS NULL) THEN
      -- Analyze all packages.
      FOR consumer IN get_service_consumers LOOP
         Apply_Default_Definitions__(consumer.name);               
      END LOOP;          
   ELSE
      -- Analyze only new or updated packages.
      -- (These are the ones having their SPEC (not their BODY) updated since the last run)
      cache_refreshed_timestamp_ := to_char(cache_refreshed_date_, 'YYYY-MM-DD:HH24:MI:SS');
      FOR consumer IN get_updated_service_consumers LOOP
         Apply_Default_Definitions__(consumer.name);               
      END LOOP;          
   END IF;
   
   Cache_Management_API.Refresh_Cache(cache_name_);
END Apply_Default_Definitions__;


PROCEDURE Apply_Default_Definitions__ (
   package_name_ IN VARCHAR2)
IS
   lu_name_     VARCHAR2(100);
   services_    VARCHAR2(4000) := Get_Default_Definition__(package_name_, 'SERVICES');
   method_      VARCHAR2(128);
   view_        VARCHAR2(128);
   package_     VARCHAR2(128);
   service_arr_ Utility_SYS.STRING_TABLE;
   count_       NUMBER;
   log_text_    VARCHAR2(1000);
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Apply_Default_Definitions__');
   IF (services_ IS NULL) THEN
      -- Nothing to handle if no services are defined.
      RETURN;
   END IF;
   
   lu_name_ := Extract_Lu_Name___(package_name_);     
   -- Following decorations are optional!      
   view_ := Get_Default_Definition__   (package_name_, 'VIEW');
   method_ := Get_Default_Definition__ (package_name_, 'METHOD');
   package_ := Get_Default_Definition__(package_name_, 'PACKAGE');
   IF (method_ IS NOT NULL) AND (package_ IS NULL) THEN
      package_ := package_name_;
   END IF;

   Utility_SYS.Tokenize(services_, ',', service_arr_, count_);
   FOR i_ IN 1..count_ LOOP
      -- Enable only if the component hosting the service is installed
      IF (Dictionary_Sys.Logical_Unit_Is_Active(service_arr_(i_))) THEN
         Enable_Logical_Unit(
         lu_name_ => lu_name_,
         service_list_ => service_arr_(i_),
         view_ => view_,
         package_ => package_,
         method_ => method_);
         log_text_ := 'Enabled ''' || service_arr_(i_) || ''' service';
      ELSE
         log_text_ := 'Disabled ''' || service_arr_(i_) || ''' due to not being installed';
      END IF;
      Log_SYS.Fnd_Trace_(Log_SYS.info_, lu_name_ ||': ' || log_text_); 

   END LOOP;
   
EXCEPTION
   WHEN OTHERS THEN
      NULL;
END Apply_Default_Definitions__;

FUNCTION Is_Lu_Active__ (
   lu_name_ IN VARCHAR2) RETURN VARCHAR2
IS
   module_ VARCHAR2(10);
BEGIN
   IF lu_name_ = '*' THEN
      RETURN 'TRUE';
   ELSE
      module_ := Dictionary_SYS.Get_Logical_Unit_Module(lu_name_);
      
      IF module_ IS NOT NULL THEN
         RETURN Module_API.Get_Active(module_);
      ELSE
         -- Probably bad data
         RETURN 'TRUE';
      END IF;
   END IF;
END Is_Lu_Active__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Get_Dynamic_Description_ (
   description_ OUT VARCHAR2,
   lu_name_     IN  VARCHAR2,
   view_name_   IN  VARCHAR2,
   key_ref_     IN  VARCHAR2,
   package_     IN  VARCHAR2,
   method_      IN  VARCHAR2 )
IS
   keys_     VARCHAR2(2000);
   types_    VARCHAR2(2000);
   datatype_ VARCHAR2(6);
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Get_Dynamic_Description_');
   --
   -- Retrieve keys in column identity order and check the datatype
   --
   FOR key_ IN get_key_value_info(view_name_) LOOP
      -- Build key list
      IF (key_.enumeration IS NOT NULL) THEN
         keys_ := keys_||Client_SYS.Get_Key_Reference_Value(key_ref_, key_.column_name || '_DB')||text_separator_;
      ELSE
         keys_ := keys_||Client_SYS.Get_Key_Reference_Value(key_ref_, key_.column_name)||text_separator_;
      END IF;
      -- Build data type list
      datatype_ := substr(key_.column_datatype, 1, 6);
      IF datatype_ = 'STRING' THEN
         types_ := types_||'VARCHAR2'||text_separator_;
      ELSIF datatype_ = 'NUMBER' THEN
         types_ := types_||'NUMBER'||text_separator_;
      ELSIF substr(datatype_, 1, 4) = 'DATE' THEN
         types_ := types_ ||'DATE'||text_separator_;
      ELSE
         Error_SYS.Appl_General(service_, 'DATATYPEERROR: Undefined datatype for column :P1 in view :P2!', key_.column_name, view_name_);
      END IF;
   END LOOP;
   --
   -- Try dynamic call for a description
   --
   description_ := Get_Description___(package_, method_, keys_, types_);
END Get_Dynamic_Description_;


@UncheckedAccess
PROCEDURE Enumerate_Logical_Units_ (
   lu_conn_attr_ OUT VARCHAR2 )
IS
   attr_ VARCHAR2(32000);
   CURSOR getlu IS
      SELECT lu_name, service_list
      FROM   object_connection;
BEGIN
   FOR rec IN getlu LOOP
      Client_SYS.Add_To_Attr(rec.lu_name, rec.service_list, attr_);
   END LOOP;
   lu_conn_attr_ := attr_;
END Enumerate_Logical_Units_;



-- Remove_Dangling_Connections_
--   The main procedure of the background job that removes dangling object connections.
PROCEDURE Remove_Dangling_Connections_
IS
   TYPE obj_conn_cur_type_ IS REF CURSOR;

   CURSOR cur_get_services IS
      SELECT lu_name, service_list
      FROM object_connection;

   stmt_             VARCHAR2(1000);
   object_exists_    VARCHAR2(10);

   services_         Utility_Sys.STRING_TABLE;
   num_services_     NUMBER;

   cur_get_objects_  obj_conn_cur_type_;
   key_ref_          VARCHAR2(4000); -- NAME=Value^NAME=Value
   lu_name_          VARCHAR2(30);
   view_name_        VARCHAR2(30);
   table_name_       VARCHAR2(30);

   -- Some statistics variables.
   stat_total_conn_checked_      NUMBER := 0;
   stat_resolved_object_conn_    NUMBER := 0;
   stat_unresolved_object_conn_  NUMBER := 0;
   stat_deleted_object_conn_     NUMBER := 0;
   stat_exceptions_              NUMBER := 0;

BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Remove_Dangling_Connections_');
   -- Loop through all the LU's which have services.
   FOR rec_conn_serv_ IN cur_get_services LOOP
      -- Extract all the services for the given LU.
      Utility_Sys.Tokenize( rec_conn_serv_.service_list, text_separator_, services_, num_services_ );

      -- Loop through each service
      FOR i IN 1..num_services_ LOOP
         -- We dont handle the '*' because we can't.
         IF NOT services_(i) = '*' THEN
            -- Inner block for handling exceptions.
            BEGIN
               view_name_ := Get_View_Name___(services_(i));
               -- Special handling for notes
               IF rec_conn_serv_.lu_name = '*' THEN
                  table_name_ := view_name_ || '_TAB';
                  Assert_SYS.Assert_Is_Table(table_name_);
                  -- Create a statement to retrieve all the objects in the service that belong to the current lu.
                  stmt_ := 'SELECT key_ref, lu_name FROM '|| table_name_;
                  -- Ref cursor
                  -- Safe due to Assert_Sys.Assert_Is_Table check
                  @ApproveDynamicStatement(2009-08-11,nabalk)
                  OPEN cur_get_objects_ FOR stmt_;
               ELSE
                  Assert_SYS.Assert_Is_View(view_name_);
                  -- Create a statement to retrieve all the objects in the service that belong to the current lu.
                  stmt_ := 'SELECT key_ref, lu_name FROM '|| view_name_ || ' WHERE LU_NAME = :lu';

                  -- Ref cursor
                  -- Safe due to Assert_Sys.Assert_Is_View check
                  @ApproveDynamicStatement(2009-08-11,nabalk)
                  OPEN cur_get_objects_ FOR stmt_ USING rec_conn_serv_.lu_name;
               END IF;

               -- Loop through each key ref to check if the object to which it's refering exists.
               LOOP
                  FETCH cur_get_objects_ INTO key_ref_, lu_name_;
                  EXIT WHEN cur_get_objects_%NOTFOUND;

                  -- Inner block for handling exceptions.
                  BEGIN
                     stat_total_conn_checked_ := stat_total_conn_checked_ + 1;
                     -- Lets see if the object that the connection is refering to is still alive...
                     object_exists_ := Check_Object_Exists ( lu_name_, key_ref_ );

                     IF object_exists_ = 'FALSE' THEN
                        stat_unresolved_object_conn_ := stat_unresolved_object_conn_ + 1;
                        -- The object can't be found. Remove the connection.
                        Delete_Object_Connection___ ( services_(i), lu_name_, key_ref_ );
@ApproveTransactionStatement(2014-04-02,mabose)
                        COMMIT; -- The deleted object
                        stat_deleted_object_conn_ := stat_deleted_object_conn_ + 1;
                     ELSIF object_exists_ = 'TRUE' THEN
                        stat_resolved_object_conn_ := stat_resolved_object_conn_ + 1;
                     ELSE
                        stat_exceptions_ := stat_exceptions_ + 1;
                     END IF;
                  END;
               END LOOP; -- Each key ref

            EXCEPTION
                  WHEN OTHERS THEN
                     stat_exceptions_ := stat_exceptions_ + 1;
            END;
         END IF; -- Check for *
      END LOOP; -- Each service
      -- Write some progress info.
      Transaction_SYS.Log_Status_Info ( 'Progress Report at ' || to_char(SYSDATE, 'YYYY/MM/DD-HH24:MI:SS' ), 'INFO' );
      Transaction_SYS.Log_Status_Info ( '   Total Checked      = ' || stat_total_conn_checked_, 'INFO'  );
      Transaction_SYS.Log_Status_Info ( '   Resolved           = ' || stat_resolved_object_conn_, 'INFO' );
      Transaction_SYS.Log_Status_Info ( '   Unresolved         = ' || stat_unresolved_object_conn_, 'INFO' );
      Transaction_SYS.Log_Status_Info ( '   Deletes Attempted  = ' || stat_deleted_object_conn_ , 'INFO');
      Transaction_SYS.Log_Status_Info ( '   Exceptions         = ' || stat_exceptions_, 'INFO' );
@ApproveTransactionStatement(2014-04-02,mabose)
      COMMIT; -- The trasaction progress info
   END LOOP; -- Service list
END Remove_Dangling_Connections_;

-----------------------------------------------------------------------------
-- Get_Lov_Properties_
--    Calls Reference_SYS.Get_Lov_Properties__ and returns 
--    LOV information including the parent keys.
-----------------------------------------------------------------------------
@UncheckedAccess
PROCEDURE Get_Lov_Properties_ (
   view_name_     IN  VARCHAR2,
   key_names_     OUT VARCHAR2,
   col_names_     OUT VARCHAR2,
   col_prompts_   OUT VARCHAR2,
   col_types_     OUT VARCHAR2,
   col_refs_      OUT VARCHAR2,
   col_db_names_  OUT VARCHAR2,
   sort_info_     OUT VARCHAR2,
   validity_mode_ OUT VARCHAR2 )
IS
BEGIN
   Reference_SYS.Get_Lov_Properties__(view_name_, key_names_, col_names_, col_prompts_, col_types_, col_refs_, col_db_names_, sort_info_, validity_mode_, TRUE);
END Get_Lov_Properties_;

@UncheckedAccess
PROCEDURE Get_Lov_Properties_ (
   view_name_        IN  VARCHAR2,
   key_names_        OUT VARCHAR2,
   col_names_        OUT VARCHAR2,
   col_prompts_      OUT VARCHAR2,
   col_types_        OUT VARCHAR2,
   col_refs_         OUT VARCHAR2,
   col_enumerations_ OUT VARCHAR2,
   col_db_names_     OUT VARCHAR2,
   sort_info_        OUT VARCHAR2,
   validity_mode_    OUT VARCHAR2 )
IS
BEGIN
   Reference_SYS.Get_Lov_Properties__(view_name_, key_names_, col_names_, col_prompts_, col_types_, col_refs_, col_enumerations_, col_db_names_, sort_info_, validity_mode_, TRUE);
END Get_Lov_Properties_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Enable_Logical_Unit (
   lu_name_       IN VARCHAR2,
   service_list_  IN VARCHAR2 DEFAULT '*',
   view_          IN VARCHAR2 DEFAULT NULL,
   package_       IN VARCHAR2 DEFAULT NULL,
   method_        IN VARCHAR2 DEFAULT NULL,
   refresh_cache_ IN BOOLEAN  DEFAULT FALSE)
IS
   append_srv_list_  VARCHAR2(2000) := nvl(trim(service_list_), '*');
   current_srv_list_ VARCHAR2(2000);
   based_on_         VARCHAR2(30);
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Enable_Logical_Unit');   
   -- Validate all the values being entered are valid
   Assert_SYS.Assert_Is_Logical_Unit(lu_name_);
      
   IF (append_srv_list_ = text_separator_) THEN
      Error_SYS.Record_General(Object_Connection_SYS.lu_name_, 'EMPTY_SRV_LIST: At least one service must to be defined when enabling the logical unit :P1.', lu_name_);
   END IF;
   
   IF (append_srv_list_ = '*') THEN
      Error_SYS.Record_General(Object_Connection_SYS.lu_name_, 'ILLEGAL_SRV_LIST: Services can only be defined exclusively using their corresponding entity name(s). Multiple services can be defined using the ^ character as separator.');
   END IF;
   
   IF (view_ IS NOT NULL) THEN
      Assert_SYS.Assert_Is_View(view_);
   END IF;
    
   IF (package_ IS NOT NULL) THEN
      Assert_SYS.Assert_Is_Package(package_);
      IF (method_ IS NOT NULL) THEN
         Assert_SYS.Assert_Is_Package_Method(package_ || '.' || method_);
      END IF;
   ELSIF (method_ IS NOT NULL) THEN
      Error_SYS.Record_General(Object_Connection_SYS.lu_name_, 'METH_NO_PKG: Package has to be defined when method is defined.');
   END IF;
    
   OPEN get_conn_info_all(lu_name_);
   FETCH get_conn_info_all INTO obj_conn_rec_;
   IF (get_conn_info_all%FOUND) THEN
      CLOSE get_conn_info_all;
      current_srv_list_ := obj_conn_rec_.service_list;     
   ELSE
      CLOSE get_conn_info_all;
   END IF;
         
   -- Ensure the appending service list is sorted, distinct and ends with separator.
   append_srv_list_ := Utility_SYS.Add_To_Sorted_String_List(append_srv_list_, '', text_separator_);       
   based_on_ := Calc_Based_on___(lu_name_);
   
   IF current_srv_list_ IS NULL THEN
      -- Insert new connection
      INSERT INTO object_connection_sys_tab
         (lu_name, view_name, package_name, method_name, service_list, based_on)
      VALUES
         (lu_name_, view_, package_, method_, append_srv_list_, based_on_);
   ELSE
      -- Update existing connection
      IF current_srv_list_ = '*' THEN
         current_srv_list_ := append_srv_list_;
      ELSE
         -- Ensure current list ends with separator
         IF (SUBSTR(current_srv_list_, LENGTH(current_srv_list_)) <> text_separator_ ) THEN
            current_srv_list_ := current_srv_list_ || text_separator_;
         END IF;
         -- Append the service list to current service list, and ensure the result is sorted, distinct and ends with separator.
         current_srv_list_ := Utility_SYS.Add_To_Sorted_String_List(current_srv_list_ || append_srv_list_, '', text_separator_);
      END IF;
      
      UPDATE object_connection_sys_tab
         SET view_name = view_,
             package_name = package_,
             method_name = method_,
             service_list = current_srv_list_,
             based_on = based_on_
         WHERE lu_name = lu_name_;
   END IF;
   IF (refresh_cache_) THEN
      Refresh_Active_List___(lu_name_);
   END IF;
   Refresh_Dependent_Meta_Caches___(lu_name_);
   
EXCEPTION
   WHEN dup_val_on_index THEN
      UPDATE object_connection_sys_tab
         SET view_name = view_,
             package_name = package_,
             method_name = method_,
             service_list = append_srv_list_,
             based_on = based_on_
         WHERE lu_name = lu_name_;
END Enable_Logical_Unit;


PROCEDURE Disable_Logical_Unit (
   lu_name_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Disable_Logical_Unit');
   DELETE FROM object_connection_sys_tab
      WHERE lu_name = lu_name_;
   DELETE FROM object_connection_language_tab
      WHERE lu_name = lu_name_;
   Refresh_Dependent_Meta_Caches___(lu_name_);
END Disable_Logical_Unit;


PROCEDURE Enable_Service (
   lu_name_ IN VARCHAR2,
   service_name_ IN VARCHAR2 )
IS
   dummy_      NUMBER;
   view_name_  VARCHAR2(30);
   sep_        VARCHAR2(1) := text_separator_;

   CURSOR check_exist IS
      SELECT 1
      FROM object_connection_sys_tab
      WHERE lu_name = lu_name_;

BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Enable_Service');
   --
   -- Check if any LU-setting exists in setup table
   --
   OPEN check_exist;
   FETCH check_exist INTO dummy_;
   IF check_exist%NOTFOUND THEN
      CLOSE check_exist;
      --
      -- Create a new setting record by using old interface
      --
      view_name_ := Get_View_Name___(lu_name_, only_active_ => FALSE);
      Enable_Logical_Unit(lu_name_, service_name_, view_name_, view_name_ || '_API', '');
      -- The dependent meta cache is updated within the above method.
   ELSE
      CLOSE check_exist;
      --
      -- Update existing setting, but only if not already set and not '*'
      --
      UPDATE object_connection_sys_tab
         SET service_list = service_list||service_name_||sep_
         WHERE lu_name = lu_name_
         AND   instr(sep_||service_list, sep_||service_||sep_) = 0
         AND   service_list <> '*';
      Refresh_Dependent_Meta_Caches___(lu_name_);
   END IF;
END Enable_Service;

FUNCTION Enumerate_Lu_Services (
   lu_name_ IN VARCHAR2) RETURN Utility_SYS.STRING_TABLE
IS
   service_list_ Utility_SYS.STRING_TABLE;
   dummy_ NUMBER;
   count_ NUMBER := 0;
   
   CURSOR get_services IS
      SELECT service_name
      FROM object_connection_service
      WHERE connects_to_db = 'ENABLED_LU';
      
BEGIN
   OPEN get_conn_info(lu_name_);
   FETCH get_conn_info INTO obj_conn_rec_;
   IF (get_conn_info%FOUND) THEN
      CLOSE get_conn_info;
      -- Kept only for backward compability due to '*' no longer being a valid value!
      IF (obj_conn_rec_.service_list = '*') THEN
         FOR service_ IN get_services LOOP
            count_ := count_ + 1;
            service_list_(count_) := service_.service_name;
         END LOOP;
         RETURN service_list_;
      END IF;
      Utility_SYS.Tokenize(obj_conn_rec_.service_list, '^', service_list_, dummy_);      
   ELSE
      CLOSE get_conn_info;
   END IF;
   RETURN service_list_;
END Enumerate_Lu_Services;

FUNCTION Enumerate_Entities_Based_On_ (
   lu_name_ IN VARCHAR2) RETURN Utility_SYS.STRING_TABLE
IS      
   based_on_list_ Utility_SYS.STRING_TABLE;
   
   CURSOR get_based_on IS
      SELECT lu_name
        FROM object_connection
        WHERE based_on = lu_name_
        AND   based_on IS NOT NULL;             
BEGIN      
   IF (lu_name_ = '*') THEN
      RETURN based_on_list_;
   END IF;
   
   OPEN get_based_on;
   FETCH get_based_on BULK COLLECT INTO based_on_list_;
   CLOSE get_based_on;
   
   RETURN based_on_list_;     
END Enumerate_Entities_Based_On_;

FUNCTION Enumerate_Services (
   including_global_ IN BOOLEAN DEFAULT FALSE) RETURN Utility_SYS.STRING_TABLE
IS
   service_list_ Utility_SYS.STRING_TABLE;
   count_ NUMBER := 0;
   
--SOLSETFW
   CURSOR get_services IS
      SELECT service_name, connects_to_db
      FROM object_connection_service
      WHERE Object_Connection_SYS.Is_Lu_Active__(service_name) = 'TRUE';
BEGIN
   FOR service_ IN get_services LOOP
      IF (including_global_ OR service_.connects_to_db = 'ENABLED_LU') THEN
         count_ := count_ + 1;
         service_list_(count_) := service_.service_name;
      END IF;
   END LOOP;
   RETURN service_list_;
END Enumerate_Services;

@UncheckedAccess
FUNCTION Is_Service (
   service_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   result_ NUMBER := 0;
   
--SOLSETFW
   CURSOR check_exist IS
      SELECT 1
      FROM object_connection_service
      WHERE service_name = service_name_
      AND Object_Connection_SYS.Is_Lu_Active__(service_name) = 'TRUE';
      
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO result_;
   CLOSE check_exist;
   
   IF (result_ > 0) THEN
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Is_Service;

PROCEDURE Disable_Service (
   lu_name_ IN VARCHAR2,
   service_name_ IN VARCHAR2 )
IS
   sep_ VARCHAR2(1) := text_separator_;
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Disable_Service');
   --
   -- Update setting by replacing the service with null
   -- If configured with '*', no actions will be performed
   --
   UPDATE object_connection_sys_tab
      SET service_list = substr(replace(sep_||service_list, sep_||service_name_||sep_, sep_), 2)
      WHERE lu_name = lu_name_;
   Refresh_Dependent_Meta_Caches___(lu_name_);
END Disable_Service;

PROCEDURE Refresh_Dependent_Meta_Caches___(
   lu_name_ IN VARCHAR2)
IS
BEGIN
   IF (lu_name_ != '*') THEN
      Dictionary_SYS.Refresh_Dependent_Meta_Caches(lu_name_);
      
      OPEN get_conn_info(lu_name_);
      FETCH get_conn_info INTO obj_conn_rec_;
      CLOSE get_conn_info;     
      -- If the entity is using BasedOn, refresh the cache for its parent (BasedOn) entity.
      IF (obj_conn_rec_.based_on IS NOT NULL) THEN
         Dictionary_SYS.Refresh_Dependent_Meta_Caches(obj_conn_rec_.based_on);         
      END IF;
   END IF;
   
END Refresh_Dependent_Meta_Caches___;


@UncheckedAccess
PROCEDURE Enumerate_Logical_Units (
   lu_conn_list_ OUT VARCHAR2,
   service_name_ IN VARCHAR2 )
IS
   sep_  VARCHAR2(1) := text_separator_;
   temp_ VARCHAR2(32000);
   CURSOR get_lu IS
      SELECT lu_name
      FROM object_connection
      WHERE service_list = '*'
      OR    instr(sep_||service_list, sep_||service_name_||sep_) > 0;
BEGIN
   FOR rec IN get_lu LOOP
      temp_ := temp_||rec.lu_name||text_separator_;
   END LOOP;
   lu_conn_list_ := temp_;
END Enumerate_Logical_Units;



@UncheckedAccess
PROCEDURE Get_Configuration_Properties (
   view_name_ OUT VARCHAR2,
   package_name_ OUT VARCHAR2,
   method_name_ OUT VARCHAR2,
   service_list_ OUT VARCHAR2,
   lu_name_ IN VARCHAR2 )
IS
BEGIN
   OPEN get_conn_info(lu_name_);
   FETCH get_conn_info INTO obj_conn_rec_;
   IF (get_conn_info%FOUND) THEN
      CLOSE get_conn_info;
      IF (obj_conn_rec_.view_name IS NULL) THEN
         view_name_ := Dictionary_SYS.Get_Base_View(lu_name_);
      ELSE
         view_name_ := obj_conn_rec_.view_name;
      END IF;
      package_name_ := obj_conn_rec_.package_name;
      method_name_  := obj_conn_rec_.method_name;
      service_list_ := obj_conn_rec_.service_list;
   ELSE
      CLOSE get_conn_info;
   END IF;
END Get_Configuration_Properties;

@UncheckedAccess
FUNCTION Get_Logical_Unit_Description (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ object_connection_language_tab.lu_attr%TYPE;
   
   CURSOR get_lu_attr IS
      SELECT lu_attr
      FROM   object_connection_language_tab
      WHERE  lu_name = lu_name_
      AND    lang_code = Fnd_Session_API.Get_Language;   
BEGIN
   -- Try fetch from language connection table   
   OPEN get_lu_attr;
   FETCH get_lu_attr INTO temp_ ;
   CLOSE get_lu_attr ;
   
   -- Otherwise fetch from LU-dictionary
   IF (temp_ IS NULL) THEN
      temp_ := Language_SYS.Translate_Lu_Prompt_(lu_name_);
   END IF;
   RETURN(temp_);
END Get_Logical_Unit_Description;

PROCEDURE Get_Connection_Description (
   description_ OUT VARCHAR2,
   lu_name_     IN  VARCHAR2,
   key_ref_     IN  VARCHAR2 )
IS
   desc_        VARCHAR2(2000) := NULL;
   tmp_key_ref_ VARCHAR2(2000);
   temp_view_   VARCHAR2(30);
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Get_Connection_Description');
   
   -- Fetch information from connection table   
   OPEN get_conn_info(lu_name_);
   FETCH get_conn_info INTO obj_conn_rec_;
   IF (get_conn_info%FOUND) THEN
      CLOSE get_conn_info;
      IF (obj_conn_rec_.method_name IS NOT NULL) THEN
         IF (obj_conn_rec_.view_name IS NULL) THEN
            temp_view_ := Dictionary_SYS.Get_Base_View(lu_name_);
         ELSE
            temp_view_ := obj_conn_rec_.view_name;
         END IF;
         
         -- Ensure a real key reference list
         IF (instr(key_ref_, '=') = 0) THEN
            tmp_key_ref_ := Convert_To_Key_Reference(lu_name_, key_ref_);
         ELSE
            tmp_key_ref_ := key_ref_;
         END IF;
         Get_Dynamic_Description_(desc_, lu_name_, temp_view_, tmp_key_ref_,
                                  nvl(obj_conn_rec_.package_name, obj_conn_rec_.package_name),
                                  obj_conn_rec_.method_name);
      END IF;      
   ELSE
      CLOSE get_conn_info;
   END IF;
   
   description_ := desc_;
END Get_Connection_Description;


@UncheckedAccess
FUNCTION Get_Instance_Description (
   lu_name_   IN VARCHAR2,
   view_name_ IN VARCHAR2,
   key_ref_   IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Instance_Description___(lu_name_, view_name_, key_ref_, TRUE);
END Get_Instance_Description;


@UncheckedAccess
FUNCTION Get_Instance_Description (
   lu_name_     IN VARCHAR2,
   view_name_   IN VARCHAR2,
   key_ref_     IN VARCHAR2,
   by_position_ IN BOOLEAN ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Instance_Description___(lu_name_, view_name_, key_ref_, by_position_);
END Get_Instance_Description;


@UncheckedAccess
FUNCTION Convert_To_Key_Reference (
   lu_name_    IN VARCHAR2,
   key_values_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   TYPE key_struct_type IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
   TYPE ref_cur_type_ IS REF CURSOR;

   key_name_      key_struct_type;
   key_value_     key_struct_type;
   key_datatype_  key_struct_type;
   index_         NUMBER          := 1;
   ts_            VARCHAR2(1)     := Client_SYS.text_separator_;
   temp_          VARCHAR2(32000) := ts_||key_values_;
   view_name_     VARCHAR2(30)    := Get_View_Name___(lu_name_);
   db_column_     VARCHAR2(30);
   package_name_  VARCHAR2(30);
   column_name_   VARCHAR2(30);
   stmt_          VARCHAR2(1000);
   db_value_      VARCHAR2(100);
   cur_get_encoded_value_ ref_cur_type_;

   FUNCTION Get_Db_Value___ (
      enumeration_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      --SOLSETFW
      CURSOR get_package IS
         SELECT p.package_name
         FROM reference_sys_tab r,
              dictionary_sys_package_active p
         WHERE r.view_name = view_name_
         AND r.col_name = column_name_
         AND p.lu_name = r.ref_name;
   BEGIN
      -- Get the package name from the reference
      IF enumeration_ IS NOT NULL THEN
         package_name_ := Dictionary_SYS.Get_Base_Package(enumeration_);
      ELSE
         OPEN  get_package;
         FETCH get_package INTO package_name_;
         CLOSE get_package;
      END IF;
      IF package_name_ IS NOT NULL THEN
         -- Execute encode stmt
         stmt_ := 'BEGIN :dbvalue := '||package_name_||'.Encode(:keyvalue); END;';
         BEGIN
            Assert_SYS.Assert_Is_Package(package_name_);
            -- Fetch dbvalue
            @ApproveDynamicStatement(2011-05-30,krguse)
            EXECUTE IMMEDIATE stmt_ USING OUT db_value_, IN key_value_(index_);
            -- If dbvalue is not null then return value and exit
            IF db_value_ IS NOT NULL THEN
               RETURN(db_value_);
            END IF;
         EXCEPTION -- Continue to next try to find the db_value
            WHEN OTHERS THEN
               RETURN NULL;
         END;
      END IF;
      Assert_SYS.Assert_Is_View_Column(view_name_,db_column_);
      Assert_SYS.Assert_Is_View(view_name_);

      stmt_ := 'SELECT /*+ FIRST_ROWS(1) */ ' || db_column_ || ' FROM ' || view_name_ || ' WHERE ';
      FOR i_ IN 1..index_-1 LOOP
         Assert_SYS.Assert_Is_View_Column(view_name_,key_name_(i_));
         IF (upper(key_datatype_(i_)) LIKE 'DATE%') THEN
            stmt_ := stmt_ || key_name_(i_) || ' = TO_DATE(''' || key_value_(i_) || ''') AND ';
         ELSIF (upper(key_datatype_(i_)) LIKE 'NUMBER%') THEN
            stmt_ := stmt_ || key_name_(i_) || ' = ' || key_value_(i_) || ' AND ';
         ELSE -- Everything else is treated like String
            stmt_ := stmt_ || key_name_(i_) || ' = ''' || key_value_(i_) || ''' AND ';
         END IF;
      END LOOP;
      stmt_ := stmt_ || column_name_ || '= :keyvalue ';

      BEGIN
         @ApproveDynamicStatement(2011-05-30,krguse)
         OPEN cur_get_encoded_value_ FOR stmt_ USING key_value_(index_);
         FETCH cur_get_encoded_value_ INTO db_value_;
         CLOSE cur_get_encoded_value_;
         RETURN(db_value_);
      EXCEPTION
         WHEN OTHERS THEN
           RETURN(NULL);
      END;
   END Get_Db_Value___;
BEGIN
   --
   -- Initialize the key structure
   --
   FOR i IN 1..9 LOOP
      key_name_(i)     := NULL;
      key_value_(i)    := NULL;
      key_datatype_(i) := NULL;
   END LOOP;
   --
   -- For each key name find the corresponding value. Parsing made in key value order (by column id)
   --
   FOR rec IN get_key_value_info(view_name_) LOOP
      key_datatype_(index_):= rec.column_datatype;
      key_name_(index_)    := rec.column_name;
      key_value_(index_)   := substr(temp_,
                                     instr(temp_, ts_, 1, index_) + 1,
                                     instr(temp_, ts_, 1, index_ + 1) - instr(temp_, ts_, 1, index_) - 1);

      db_column_ := upper(Get_Iid_Properties___(view_name_, rec.column_name));
      IF db_column_ IS NOT NULL THEN
         column_name_      := upper(rec.column_name);
         -- The column is a IID column and should be used instead.
         key_name_(index_) := db_column_;
         -- Convert from client value to db value.
         db_value_ := Get_Db_Value___(rec.enumeration);
         IF db_value_ IS NOT NULL THEN
            key_value_(index_) := db_value_;
         END IF;
      END IF;

      index_ := index_ + 1;
   END LOOP;
   --
   -- Retrieve a key reference list from Client_SYS (this will sort the list alphabetically)
   --
   temp_ := Client_SYS.Get_Key_Reference(lu_name_, key_name_(1), key_value_(1),
                                                 key_name_(2), key_value_(2),
                                                 key_name_(3), key_value_(3),
                                                 key_name_(4), key_value_(4),
                                                 key_name_(5), key_value_(5),
                                                 key_name_(6), key_value_(6),
                                                 key_name_(7), key_value_(7),
                                                 key_name_(8), key_value_(8),
                                                 key_name_(9), key_value_(9));
   RETURN (temp_);
END Convert_To_Key_Reference;



@UncheckedAccess
FUNCTION Convert_To_Key_Value (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   key_value_   VARCHAR2(2000);
   view_        VARCHAR2(30);
   package_     VARCHAR2(30);
   method_      VARCHAR2(2000);
   serv_list_   VARCHAR2(2000);
   column_name_ VARCHAR2(30);
   db_column_   VARCHAR2(30);
BEGIN
   Get_Configuration_Properties(view_, package_, method_, serv_list_, lu_name_);
   FOR key_name IN get_key_value_info(view_) LOOP
      column_name_ := key_name.column_name;
      IF key_name.enumeration IS NOT NULL THEN
         db_column_ := Get_Iid_Properties___(view_, column_name_);
         IF db_column_ IS NOT NULL THEN
            -- The column is a IID column and should be used instead.
            column_name_ := db_column_;
         END IF;
      END IF;
      key_value_ := key_value_||Client_SYS.Get_Key_Reference_Value(key_ref_, column_name_)||text_separator_;
   END LOOP;
   RETURN(key_value_);
END Convert_To_Key_Value;



@UncheckedAccess
FUNCTION Is_Connection_Aware (
   lu_name_ IN VARCHAR2,
   service_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   OPEN get_conn_info(lu_name_);
   FETCH get_conn_info INTO obj_conn_rec_;
   IF (get_conn_info%FOUND) THEN
      CLOSE get_conn_info;
      IF (instr(text_separator_||obj_conn_rec_.service_list, service_name_) > 0 OR 
         obj_conn_rec_.service_list = '*') THEN
         RETURN (TRUE);
      END IF;      
   ELSE
      CLOSE get_conn_info;
   END IF;
   
   RETURN (FALSE);
END Is_Connection_Aware;



PROCEDURE Do_Cascade_Delete (
  service_list_ IN VARCHAR2,
  lu_name_      IN VARCHAR2,
  key_ref_      IN VARCHAR2 )
IS
  services_           Utility_Sys.STRING_TABLE;
  num_serv_           NUMBER;
  total_service_list_ VARCHAR2(32000);
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Do_Cascade_Delete');
   IF (service_list_ = '*') THEN
      total_service_list_ := Refresh_Service_List___;
      Utility_Sys.Tokenize(total_service_list_, text_separator_, services_, num_serv_);
      FOR counter_ IN 1..num_serv_ LOOP
         Delete_Object_Connection___(services_(counter_), lu_name_, key_ref_);
      END LOOP;
      -- Add a trace that a service list only containing '*' results in dangling object connections
      Trace_Sys.Message('LU ' || lu_name_ || ' has a service list *, which will result in dangling references in Object Connections.');
   ELSE
      -- Go over each service in the service list and delete the object connections
      Utility_Sys.Tokenize(service_list_, text_separator_, services_, num_serv_);
      FOR counter_ IN 1..num_serv_ LOOP
         IF NOT services_(counter_) = '*' THEN -- Ignore *
            Delete_Object_Connection___(services_(counter_), lu_name_, key_ref_);
         END IF;
      END LOOP;
   END IF;
END Do_Cascade_Delete;


-- Check_Object_Connection_Exists
--   Method to check if an object connection exists
--   Returns TRUE, FALSE
@UncheckedAccess
FUNCTION Check_Object_Connection_Exists (
   service_name_ IN VARCHAR2,
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   retval_           VARCHAR2(10);
   view_name_        VARCHAR2(255);
   parameters_       Utility_Sys.STRING_TABLE;
   num_parameters_   NUMBER;
   stmt_             VARCHAR2(1000);
   num_in_table_     NUMBER;
BEGIN
   Utility_Sys.Tokenize ( key_ref_, text_separator_, parameters_, num_parameters_ );

   -- Assert that the lu is valid. This should work ok since we get the service LU from the foundation
   Assert_Sys.Assert_Is_Logical_Unit ( service_name_ );

   -- Create the table from the lu name
   view_name_ := Get_View_Name___(service_name_);

   Assert_Sys.Assert_Is_View ( view_name_ );

   stmt_ := 'SELECT COUNT(*) FROM ' || view_name_ || ' WHERE LU_NAME = :lu AND KEY_REF = :keyref';

   num_in_table_ := 0;

  @ApproveDynamicStatement(2007-07-26,pemase)
   EXECUTE IMMEDIATE stmt_ INTO num_in_table_ USING lu_name_ , key_ref_ ;

   IF num_in_table_ > 0 THEN
      retval_ := 'TRUE';
   ELSE
      retval_ := 'FALSE';
   END IF;

   RETURN retval_;

EXCEPTION
   WHEN OTHERS THEN
      Trace_Sys.Message('An exception occured while checking for object connection ' || lu_name_ || '.' || key_ref_ || ' in service ' || service_name_);
      RETURN 'FALSE';

END Check_Object_Connection_Exists;


-- Check_Object_Exists
--   This method checks if an object pointed to by the lu_name and key_ref exists.
--   Returns TRUE/FALSE/EXCEPTION
@UncheckedAccess
FUNCTION Check_Object_Exists (
   lu_name_ IN VARCHAR2,
   key_ref_     IN VARCHAR2,
   object_type_ IN VARCHAR2 DEFAULT 'TABLE',
   object_name_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   num_keys_     NUMBER;
   cursor_       NUMBER;
   row_count_    NUMBER;
   dummy_        NUMBER;

   table_        VARCHAR2(200);
   stmt_         VARCHAR2(10000);
   retval_       VARCHAR2(5);

   tokenized_key_ref_ KEY_REF;

BEGIN
   $IF (Component_Fndrpl_SYS.INSTALLED) $THEN
      IF (Fnd_Session_API.Get_Fnd_User = 'IFSSYNC' AND App_Context_SYS.Find_Boolean_Value('REPL_RECIEVE_MODE')= TRUE) THEN
         RETURN 'TRUE';
      END IF;
   $END
   retval_ := 'FALSE';
   row_count_ := 0;

   IF object_type_ = 'TABLE' THEN
      IF object_name_ IS NULL THEN 
         table_ := Get_View_Name___(lu_name_) || '_TAB';
      ELSE
         table_ := object_name_;
      END IF;   
      BEGIN
         Assert_SYS.Assert_Is_Table( table_ );
      EXCEPTION
         WHEN OTHERS THEN
         -- there are scenarios where an LU does not have a corresponding
         -- table ending with _TAB suffix (ex: when LU is a derived one
         -- from parent LU). In such case, we use its view instead.
         table_ := Get_View_Name___(lu_name_);
         Assert_SYS.Assert_Is_View(table_);
      END;
   ELSE
      IF object_name_ IS NULL THEN 
         table_ := Get_View_Name___(lu_name_);
      ELSE
         table_ := object_name_;
      END IF;   
      Assert_SYS.Assert_Is_View(table_);
   END IF;

   stmt_ := 'SELECT COUNT (*) FROM ' || table_ || ' WHERE ';

   Tokenize_Key_Ref__(key_ref_,tokenized_key_ref_,num_keys_);
   
   FOR key_counter_ IN 1..num_keys_ LOOP        
      Assert_SYS.Assert_Is_Table_Column(table_ , tokenized_key_ref_(key_counter_).NAME);
      IF tokenized_key_ref_(key_counter_).VALUE IS NULL THEN       
         stmt_:= stmt_ || tokenized_key_ref_(key_counter_).NAME || ' is null';         
      ELSE            
         IF Database_SYS.Get_Column_Type(table_, tokenized_key_ref_( key_counter_ ).NAME) = 'DATE' THEN
            stmt_:= stmt_ || tokenized_key_ref_(key_counter_).NAME || ' = ' || 'to_date(:bind_var' || key_counter_ || ', '''|| Client_SYS.date_format_||''')' ; -- 'NAME = :bind_var'
         ELSE
            stmt_:= stmt_ || tokenized_key_ref_(key_counter_).NAME || ' = :bind_var' || key_counter_; -- 'NAME = :bind_var'
         END IF;         
      END IF;
      
      IF key_counter_ != num_keys_ THEN
         stmt_ := stmt_ || ' AND ';
      END IF;
   END LOOP;

   Log_SYS.Fnd_Trace_(Log_SYS.trace_, stmt_);

   cursor_ := dbms_sql.open_cursor;
   -- Secured using Assert_SYS.Assert_Is_Table_Column
   @ApproveDynamicStatement(2007-07-26,pemase)
   dbms_sql.parse (cursor_, stmt_, dbms_sql.native);
   dbms_sql.define_column(cursor_, 1, row_count_);


   FOR key_counter_ IN 1..num_keys_ LOOP
      -- Bind the variables
      IF tokenized_key_ref_(key_counter_).VALUE IS NOT NULL THEN
         dbms_sql.bind_variable(cursor_, 'bind_var' || key_counter_, tokenized_key_ref_(key_counter_).VALUE);
         Log_SYS.Fnd_Trace_(Log_SYS.trace_, 'bind_var' || key_counter_ || ' = '||  tokenized_key_ref_(key_counter_).VALUE);
      END IF;
   END LOOP;

   dummy_ := dbms_sql.execute( cursor_ );
   dummy_ := dbms_sql.fetch_rows( cursor_ );
   dbms_sql.column_value( cursor_, 1, row_count_ );
   dbms_sql.close_cursor( cursor_ );

   IF row_count_ > 0 THEN
      retval_ := 'TRUE';
   ELSE
      IF object_name_ IS NOT NULL THEN
         retval_ := Check_Object_Exists(lu_name_,key_ref_,object_type_,NULL); --Check if object exists for base view
      END IF;   
   END IF;   
   
   RETURN retval_;


   EXCEPTION
      WHEN OTHERS THEN
         -- Something went wrong, We return that an exception has occured.
         Trace_Sys.Message ('Exception occured while looking for object ' || lu_name_ || '.' || key_ref_);
         IF (dbms_sql.is_open(cursor_)) THEN
            dbms_sql.close_cursor( cursor_ );
         END IF;
         RETURN 'EXCEPTION';
END Check_Object_Exists;


@UncheckedAccess
FUNCTION Replace_Client_Values (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Replace_Client_Values___ ( lu_name_, key_ref_ );
END Replace_Client_Values;


@UncheckedAccess
FUNCTION Replace_Server_Values (
   lu_name_ IN VARCHAR2,
   key_ref_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Replace_Server_Values___ (lu_name_, key_ref_);
END Replace_Server_Values;


-- Get_Client_Hit_Count
--   Given the service name, LUName and KeyRef returns the hit count for that service
--   Each service can override the count behavior by implementing
--   Get_Obj_Conn_Client_Hit_Count method in the Service LU
@UncheckedAccess
FUNCTION Get_Client_Hit_Count(
   service_name_      IN VARCHAR2,
   lu_name_           IN VARCHAR2,
   key_ref_           IN VARCHAR2,
   service_view_name_ IN VARCHAR2 DEFAULT NULL )RETURN NUMBER

IS
   count_            NUMBER;
   stmt_             VARCHAR2(2000);
   service_pkg_      VARCHAR2(30);
   hit_count_method_ VARCHAR2(200) := 'Get_Obj_Conn_Client_Hit_Count';
BEGIN
   service_pkg_ := Get_Active_Service_Package___(service_name_);

   -- First try to see if the service has implemented the count method.
   IF Database_SYS.Method_Active(service_pkg_, hit_count_method_) THEN
      Trace_SYS.Message('Custom count method found for service '||service_name_||'('||service_pkg_||')'||', using it instead.');
      stmt_ := 'BEGIN :count_ := '||service_pkg_||'.'||hit_count_method_||'(:sn_,:lu_,:key_ref_,:s_view_name_); END;';
      -- Generated statement, and the package name is validated with Method_Exist check
      @ApproveDynamicStatement(2014-03-09,usralk)
      EXECUTE IMMEDIATE stmt_ USING OUT count_, service_name_, lu_name_, key_ref_, service_view_name_;
      RETURN nvl(count_, 0);
   ELSE
      RETURN Get_Count_From_View___(service_name_, lu_name_, key_ref_, service_view_name_);
   END IF;
END Get_Client_Hit_Count;


@UncheckedAccess
FUNCTION Get_Package_Name (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(100);
BEGIN
   OPEN get_conn_info(lu_name_);
   FETCH get_conn_info INTO obj_conn_rec_;
   IF (get_conn_info%FOUND) THEN
      CLOSE get_conn_info;      
      temp_ := obj_conn_rec_.package_name;
   ELSE
      CLOSE get_conn_info;
   END IF;
   
   RETURN temp_;
END Get_Package_Name;


FUNCTION Get_Custom_Instance_Desc (
   lu_name_   IN VARCHAR2,
   view_name_ IN VARCHAR2,
   key_ref_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   prompt_      VARCHAR2(2000);
   value_       VARCHAR2(2000);
   temp_        VARCHAR2(4000);
   delim_       VARCHAR2(2);
   tmp_key_ref_ VARCHAR2(2000);
   tmp_view_    VARCHAR2(30) := view_name_;

BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Get_Custom_Instance_Desc');
   --
   -- Ensure a real key reference list
   --
   IF (instr(key_ref_, '=') = 0) THEN
      -- This is most likely a key_value instead of a key_ref... Convert it!
      tmp_key_ref_ := Convert_To_Key_Reference(lu_name_, key_ref_);
   ELSE
      tmp_key_ref_ := key_ref_;
   END IF;

   -- Replace the server value columns with the client values for presentation
   tmp_key_ref_ := Replace_Server_Values___(lu_name_, tmp_key_ref_);

   IF (tmp_view_ IS NULL) THEN
      tmp_view_ := Get_View_Name___(lu_name_);
   END IF;
   FOR col IN get_key_ref_info(tmp_view_) LOOP
      IF INSTR(UPPER(tmp_key_ref_), UPPER(col.column_name)) > 0 THEN
         prompt_ := Language_SYS.Translate_Item_Prompt_(tmp_view_||'.'||col.column_name, col.column_name, 0);
         value_ := Client_SYS.Get_Key_Reference_Value(tmp_key_ref_, col.column_name);
         temp_ := temp_ || delim_ || prompt_||': '||value_;
         delim_ := ', ';
      END IF;
   END LOOP;

   RETURN temp_;

END Get_Custom_Instance_Desc;


FUNCTION Get_Rowid_From_Keyref (
   lu_                IN VARCHAR2,
   key_ref_           IN VARCHAR2) RETURN VARCHAR2
IS
   view_                VARCHAR2(512);
   sd_package_          VARCHAR2(512);
   stmt_                VARCHAR2(2048);
   rowid_               VARCHAR2(128);
   data_cursor_         NUMBER;
   num_keys_            NUMBER;
   dummy_               NUMBER;
   key_toks_            Object_Connection_Sys.KEY_REF;
BEGIN
   General_SYS.Check_Security(service_, 'OBJECT_CONNECTION_SYS', 'Get_Rowid_From_Keyref');

   view_ := Get_View_Name___(lu_);

   sd_package_ := view_ || '_SD';

   stmt_ := 'select rowid from ' || view_ || ' where ';

   Object_Connection_Sys.Tokenize_Key_Ref__(key_ref_, key_toks_, num_keys_);

   FOR key_counter_ IN 1..num_keys_ LOOP
      Assert_SYS.Assert_Is_Table_Column( view_ , key_toks_( key_counter_ ).NAME );
      stmt_ := stmt_ || key_toks_( key_counter_ ).NAME || ' = :bindvar' || key_counter_; -- NAME = :bindvarX

      IF key_counter_ < num_keys_ THEN
         stmt_ := stmt_ || ' AND ';
      END IF;
   END LOOP;

   -- Cursor pelimineries
   data_cursor_ := dbms_sql.open_cursor;
   --safe due to Assert_SYS.Assert_Is_Table_Column check
   @ApproveDynamicStatement(2010-07-20,chmulk)
   dbms_sql.parse (data_cursor_, stmt_, dbms_sql.native);

   -- Bind variables
   FOR key_counter_ IN 1..num_keys_ LOOP
      dbms_sql.bind_variable(data_cursor_, 'bindvar' || key_counter_, key_toks_( key_counter_ ).VALUE);
   END LOOP;

   -- Define return column
   dbms_sql.define_column(data_cursor_, 1, rowid_, 128);

   -- Execute
   dummy_ := dbms_sql.execute ( data_cursor_ );
   dummy_ := dbms_sql.fetch_rows ( data_cursor_ );

   -- Get the column values
   dbms_sql.column_value(data_cursor_, 1, rowid_);

   -- Close the cursor
   dbms_sql.close_cursor(data_cursor_);

   return rowid_;
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(data_cursor_)) THEN
         dbms_sql.close_cursor(data_cursor_);
      END IF;
      RAISE;
END Get_Rowid_From_Keyref;

PROCEDURE Remove_Connections_Per_Module(
  module_ IN VARCHAR2)
IS
  --SOLSETFW 
   CURSOR get_obj_conns IS
      SELECT o.lu_name
      FROM   object_connection_sys_tab o, dictionary_sys_active d
      WHERE o.lu_name = d.lu_name
      AND   d.module = module_;
BEGIN
   FOR rec_ IN get_obj_conns LOOP
      Disable_Logical_Unit(rec_.lu_name);
   END LOOP;  
END Remove_Connections_Per_Module;

PROCEDURE Copy_Lu_Services(
   from_lu_name_ IN VARCHAR2,
   to_lu_name_   IN VARCHAR2)
IS
   CURSOR get IS
     SELECT * FROM object_connection_sys_tab
     WHERE lu_name = from_lu_name_;
   
   services_ Utility_SYS.STRING_TABLE;
   count_ NUMBER;
BEGIN
   FOR rec_ IN get LOOP
      Utility_SYS.Tokenize(rec_.service_list, text_separator_, services_, count_);      
      FOR i_ IN 1..count_ LOOP
         Enable_Service(to_lu_name_, services_(i_));
      END LOOP;
   END LOOP;
END Copy_Lu_Services;

PROCEDURE Handle_LU_Modification (
   old_lu_name_           IN VARCHAR2,
   new_lu_name_           IN VARCHAR2 DEFAULT NULL,
   in_regenerate_key_ref_ IN BOOLEAN  DEFAULT TRUE,
   key_ref_map_           IN VARCHAR2 DEFAULT NULL,
   options_               IN VARCHAR2 DEFAULT NULL)
IS
   to_lu_name_           VARCHAR2(100);
   from_lu_name_         VARCHAR2(100);
   key_ref_old_          VARCHAR2(32000);
   key_ref_old_modified_ VARCHAR2(32000);
   key_ref_new_          VARCHAR2(32000);
   key_val_new_          VARCHAR2(32000); 
   stmt_                 VARCHAR2(32000);
   service_name_         VARCHAR2(128);
   service_tab_          VARCHAR2(32);
   upd_type_             VARCHAR2(100);
   key_tab_count_        NUMBER;      
   key_rename_count_     NUMBER;
   key_count_            NUMBER;
   col_key_val_exists_   BOOLEAN;      
   regenerate_key_ref_   BOOLEAN;
   key_change_list_tab_  Utility_SYS.STRING_TABLE;
   key_change_tab_       Utility_SYS.STRING_TABLE;
   key_tab_              Utility_SYS.STRING_TABLE;
   current_key_ref_list_ Utility_SYS.STRING_TABLE;
      
   TYPE cur_typ IS REF CURSOR;
   object_conn_cur_ cur_typ;
   object_conn_source_str_ VARCHAR2(32000);
   debug_  CONSTANT BOOLEAN := FALSE;
      
   TYPE Map_Entry IS RECORD (OLD VARCHAR2(128), NEW VARCHAR2(128));
   TYPE Map_Entry_Tab IS TABLE OF Map_Entry INDEX BY PLS_INTEGER;
   key_rename_map_entries_ Map_Entry_Tab;
   
   -- List all registered services, including the global ones (e.g. the FndNoteBook)
   CURSOR get_services IS
      SELECT service_name
      FROM object_connection_service_tab;
      
   PROCEDURE Trace___ (
      text_ IN VARCHAR2)
   IS
   BEGIN
      IF debug_ THEN
         Log_SYS.App_Trace(Log_SYS.debug_, text_);
      END IF;
   END;
BEGIN      
   to_lu_name_ := NVL(new_lu_name_, old_lu_name_);
   from_lu_name_ := old_lu_name_;
   regenerate_key_ref_ := in_regenerate_key_ref_;
   
   Utility_SYS.Tokenize (key_ref_map_, '^', key_change_list_tab_, key_rename_count_); 
   FOR counter_ IN 1..key_rename_count_ LOOP
      Utility_SYS.Tokenize (key_change_list_tab_ (counter_), '=', key_change_tab_, key_count_);
      IF (key_change_tab_ (1) <> key_change_tab_ (2)) THEN
         key_rename_map_entries_(NVL(key_rename_map_entries_.LAST,0)+1).OLD := key_change_tab_ (1);
         key_rename_map_entries_(key_rename_map_entries_.LAST).NEW := key_change_tab_ (2);
         
         regenerate_key_ref_ := TRUE;
      END IF;
   END LOOP;
   key_rename_count_ := NVL(key_rename_map_entries_.LAST, 0);
   
   IF old_lu_name_ <> new_lu_name_ AND regenerate_key_ref_ THEN
      upd_type_ := 'LU_AND_KEY_REF';
   ELSIF old_lu_name_ <> new_lu_name_ THEN
      upd_type_ := 'LU_ONLY';
   ELSIF regenerate_key_ref_ THEN
      upd_type_ := 'KEY_REF_ONLY';
   ELSE
      Error_SYS.Appl_General(Object_Connection_SYS.lu_name_, 'ILLEGAL_HANDL_LU_MOD: Incorrect usage of method.');
   END IF;
   
   IF upd_type_ <> 'KEY_REF_ONLY' THEN
      Copy_Lu_Services(from_lu_name_, to_lu_name_);
      Disable_Logical_Unit(from_lu_name_);
   END IF;
   
   FOR service_ IN get_services LOOP
      service_name_ := service_.service_name;
      BEGIN
         IF Dictionary_SYS.Logical_Unit_Is_Active(service_name_) THEN
            Trace___('Starting for Service: ' || service_name_);
            
            -- Incase Lu_name is changed; But, KEY_REF is identical
            IF upd_type_ = 'LU_ONLY' THEN
               service_tab_ := Dictionary_SYS.Get_Base_Table_Name(service_name_);
               stmt_ :=  'UPDATE ' || service_tab_ || ' SET lu_name = :lu_name_newer WHERE lu_name = :lu_name_old';

               Trace___('** LU_ONLY ** to_lu_name_: ' || to_lu_name_ || ' from_lu_name_: ' || from_lu_name_);
               Trace___('** LU_ONLY ** stmt_ '        || stmt_);

               @ApproveDynamicStatement(2017-11-15,chmulk)
               EXECUTE IMMEDIATE stmt_ USING to_lu_name_, from_lu_name_;
            ELSE        
               service_tab_ := Dictionary_SYS.Get_Base_Table_Name(service_name_);
               object_conn_source_str_ := 'SELECT DISTINCT key_ref FROM ' || service_tab_ || ' WHERE lu_name = :from_lu_name_';

               -- Get ObjectConnection occurances
               @ApproveDynamicStatement(2017-11-15,chmulk)
               OPEN object_conn_cur_ FOR object_conn_source_str_ USING from_lu_name_;
               LOOP
                  FETCH object_conn_cur_ BULK COLLECT INTO current_key_ref_list_ LIMIT 10000;
                  EXIT WHEN current_key_ref_list_.COUNT = 0;

                  FOR i_ IN 1..current_key_ref_list_.COUNT LOOP
                     key_ref_new_ := '';
                     key_val_new_ := ''; 
                     key_ref_old_ := current_key_ref_list_(i_);
                     key_ref_old_modified_ := '^'||key_ref_old_;

                     -- Adjust KEY_REF incase existing Primary keys are RENAMED based on the parameter key_ref_map_
                     FOR counter_ IN 1..key_rename_count_ LOOP
                        key_ref_old_modified_ := REPLACE(key_ref_old_modified_, '^'||UPPER(key_rename_map_entries_(counter_).OLD), '^'||UPPER(key_rename_map_entries_(counter_).NEW));
                     END LOOP;
                     key_ref_old_modified_ := SUBSTR(key_ref_old_modified_, 2);
                     -- Get new Key_Ref of the target object
                     IF regenerate_key_ref_ THEN
                        key_ref_new_ := Client_SYS.Get_New_Key_Reference (to_lu_name_, key_ref_old_modified_,TRUE);
                     ELSE
                        key_ref_new_ := key_ref_old_modified_;
                     END IF;

                     IF key_ref_new_ IS NOT NULL THEN  -- new keyref generated 
                        -- Tokenize new Keys to get Values separatly
                        Utility_SYS.Tokenize (key_ref_new_, '^', key_tab_, key_tab_count_);
                        FOR count_ IN 1..key_tab_count_ LOOP
                           key_val_new_ := key_val_new_ || Client_SYS.Get_Key_Reference_Value (key_ref_new_, count_) || '^';
                        END LOOP;

                        Trace___(' ** key_ref_new_ ' || key_ref_new_);
                        Trace___(' ** key_val_new_ ' || key_val_new_);

                        IF Database_SYS.Column_Exist (service_tab_, 'KEY_VALUE') THEN
                           col_key_val_exists_ := TRUE;
                        ELSE
                           col_key_val_exists_ := FALSE;
                        END IF;

                        -- Update new Key_Ref and Key_Value; But, Lu_name is unchanged (Option 1)
                        IF upd_type_ = 'KEY_REF_ONLY' THEN
                           IF (key_ref_old_ <> key_ref_new_) THEN
                              stmt_ := 'UPDATE ' || service_tab_ || ' SET key_ref = :key_ref_new ';

                              IF col_key_val_exists_ THEN
                                 stmt_ := stmt_ || ', key_value = :key_val_new ';
                              END IF;
                              stmt_ := stmt_ || ' WHERE key_ref = :key_ref_old AND lu_name = :lu_name_old';

                              Trace___('** KEY_REF_ONLY ** key_ref_old_: ' || key_ref_old_ || ' key_ref_new_: ' || key_ref_new_);
                              Trace___('** KEY_REF_ONLY ** stmt_ '        || stmt_);

                              IF col_key_val_exists_ THEN
                                 @ApproveDynamicStatement(2017-11-15,chmulk)
                                 EXECUTE IMMEDIATE stmt_ USING key_ref_new_, key_val_new_, key_ref_old_, from_lu_name_;
                              ELSE
                                 @ApproveDynamicStatement(2017-11-15,chmulk)
                                 EXECUTE IMMEDIATE stmt_ USING key_ref_new_, key_ref_old_, from_lu_name_;
                              END IF;
                           END IF;
                        -- Both Lu_name and KEY_REF is changed (Option 3)
                        ELSIF upd_type_ = 'LU_AND_KEY_REF' THEN
                           stmt_ := 'UPDATE ' || service_tab_ || ' SET key_ref = :key_ref_new ';

                           IF col_key_val_exists_ THEN
                              stmt_ := stmt_ || ', key_value = :key_val_new ';
                           END IF;
                           stmt_ := stmt_ || ', lu_name = :lu_name_newer ';
                           stmt_ := stmt_ || ' WHERE key_ref = :key_ref_old AND lu_name = :lu_name_old';

                           Trace___('** LU_AND_KEY_REF ** key_ref_old_: ' || key_ref_old_ || ' key_ref_new_: ' || key_ref_new_);
                           Trace___('** LU_AND_KEY_REF ** stmt_ '        || stmt_);

                           IF col_key_val_exists_ THEN
                              @ApproveDynamicStatement(2017-11-15,chmulk)
                              EXECUTE IMMEDIATE stmt_ USING key_ref_new_, key_val_new_, to_lu_name_, key_ref_old_, from_lu_name_;
                           ELSE
                              @ApproveDynamicStatement(2017-11-15,chmulk)
                              EXECUTE IMMEDIATE stmt_ USING key_ref_new_, to_lu_name_, key_ref_old_, from_lu_name_;
                           END IF;
 
                        END IF;
                     ELSE
                        Log_SYS.App_Trace(Log_SYS.error_, 'Unable look up record. Service : ' || service_name_ || ' keyref: '||key_ref_old_modified_);
                     END IF; -- target record found by (rowid)
                  END LOOP;
               END LOOP; -- All connections in one service
               CLOSE object_conn_cur_;
            END IF;
            @ApproveTransactionStatement(2017-11-15,chmulk)
            COMMIT; -- commit each service_list_ 
         ELSE
            Log_SYS.App_Trace(Log_SYS.info_, 'Service Not Installed: ' || service_name_);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN     
            Log_SYS.App_Trace(Log_SYS.error_, 'Error in processing service: ' || service_name_);
            Log_SYS.App_Trace(Log_SYS.error_, '  key_ref_info old: ' || key_ref_old_ || ' new: ' || key_ref_new_ );
            Log_SYS.App_Trace(Log_SYS.error_, '  Error           : ' || dbms_utility.format_error_stack);
      END; -- End Loop
   END LOOP;   
END Handle_LU_Modification;


PROCEDURE Register_Service (
   service_name_ IN VARCHAR2)
IS
BEGIN
   Register_Service___(service_name_);
END Register_Service;


PROCEDURE Register_Global_Service (
   service_name_ IN VARCHAR2)
IS
BEGIN
   Register_Service___(service_name_, true);
         
   UPDATE object_connection_sys_tab
      SET service_list = Utility_SYS.Add_To_Sorted_String_List(service_list, service_name_, text_separator_)
      WHERE lu_name = all_logical_units_key_;
      
   IF (sql%NOTFOUND) THEN
      INSERT INTO
         object_connection_sys_tab (lu_name, service_list)
      VALUES
         (all_logical_units_key_, Utility_SYS.Add_To_Sorted_String_List('', service_name_, text_separator_));
   END IF;              
END Register_Global_Service;

 
PROCEDURE Register_Service___ (
   service_name_ IN VARCHAR2,
   global_ IN BOOLEAN DEFAULT FALSE)
IS
   connects_to_ VARCHAR2(20) := CASE WHEN global_ = TRUE THEN 'ALL_LU' ELSE 'ENABLED_LU' END;   
BEGIN
   Assert_SYS.Assert_Is_Logical_Unit(service_name_);
   Unregister_Service(service_name_);
   INSERT
      INTO object_connection_service_tab      
         (service_name, connects_to)
      VALUES
         (service_name_, connects_to_);
END Register_Service___;


PROCEDURE Unregister_Services___
IS
BEGIN   
   DELETE FROM object_connection_service_tab;
END Unregister_Services___;


PROCEDURE Unregister_Service (
   service_name_ IN VARCHAR2)
IS
BEGIN   
   DELETE
      FROM object_connection_service_tab
      WHERE service_name = service_name_;
END Unregister_Service;


PROCEDURE Unregister_Global_Service (
   service_name_ IN VARCHAR2)
IS
   service_list_ object_connection_sys_tab.service_list%TYPE;
BEGIN         
   UPDATE object_connection_sys_tab
      SET service_list = Utility_SYS.Remove_From_Sorted_String_List(service_list, service_name_, text_separator_)
      WHERE lu_name = all_logical_units_key_
      RETURNING service_list INTO service_list_;
      
   -- If the service_list is empty, delete the whole record.
   IF (service_list_ IS NULL) THEN
      DELETE FROM object_connection_sys_tab
         WHERE lu_name = all_logical_units_key_;
   END IF;
   
   Unregister_Service(service_name_);
END Unregister_Global_Service;
