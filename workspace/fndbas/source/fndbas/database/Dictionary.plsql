-----------------------------------------------------------------------------
--
--  Logical unit: Dictionary
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950823  STLA  Created.
--  950901  STLA  Corrected fetch of enumerated lu list.
--  950901  STLA  Searches methods from user_source instead of sys.argument$.
--  950904  ERFO  Separator fetched from Client_SYS and standard changes.
--  950905  ERFO  Rearrangements in method orders, change headings...
--  950905  ERFO  Changed separator character in Enumerate_Logical_Units_
--                and Enumerate_Data_Items_.
--  950911  STLA  Removed last call to sys.argument$
--  950912  STLA  Added funtion to get item prompt
--  950912  STLA  Modified fetch of views and packages belonging to a LU
--  950915  STLA  Added funtion to get lu view for list of values
--  950926  STLA  Removed picture option from DATATYPE comments
--  950927  STLA  Added method to fetch list of system services
--  950928  STLA  Added method to fetch description for logical unit
--  950928  STLA  Added method to fetch list of domains (eg IIDs)
--  951005  STLA  Added backwards compatibility for Get_Lu_View_
--                Added method Get_Logical_Unit_Ref_Methods_
--  951005  BOIS  Corrected into variable length in Get_View_Logical_Unit_
--  951006  ERFO  Removed method Get_View_Logical_Unit_
--  951006  STLA  Made Generate_<_Comment_ generate dummy comment if
--                database column is not found.
--  951006  STLA  Added foreign key methods to Enumerate_Data_Items_
--                Removed reference to Client_SYS.field_separator_
--  951030  STLA  Corrected Get_Logical_Unit_Ref_Methods_ returning
--                incorrect enumerate syntax.
--  951030  STLA  Added pragma restict_references for att methods
--  951030  STLA  Corrected Enumerate_Domains_ uninitialized variable
--  951030  STLA  Added method Get_Logical_Unit_Method_
--  951030  DAJO  Added method Get_System_Service_Properties_ for
--                system service translation support.
--  951101  ERFO  Added work-around BIGCHAR2 for Enumerate_Data_Items_
--                and Enumerate_Logical_Units_.
--  951208  STLA  Corrected method Get_Data_Item_Properties_ (Bug #283).
--  960110  STLA  Added overloaded version of Get_Logical_Unit_Properties_
--                so that grant/revoke tool can operate efficiently.
--  960111  STLA  Use of 32730 as max length for long VARCHAR2 (Bug #325).
--  960111  ERFO  Added method Activate_Language_Refresh_ to support
--                language setting changes on the fly (Idea #326).
--  960225  ERFO  Added new module property methods to support the module
--                concept within the LU-dictionary (Idea #409).
--  960319  ERFO  Added extra method for logical unit properties to support
--                new features within system service Document_SYS (Idea #463).
--  960325  ERFO  Added methods for internal dictionary storage to support
--                performance needs from IFS/Security (Idea #452).
--  960326  ERFO  Added new parent/child property methods to support relations
--                between parent and children for logical units (Idea #410).
--  960326  ERFO  Add cache techniques in LU-dictionary by sending an extra
--                in parameter which tells if the cached value, stored in a
--                package global may be used or not (Idea #466).
--  960401  ERFO  Split this package into two for deployment reasons.
--  960402  ERFO  Changed cursor in method Get_Logical_Unit_Parent_ as a
--                work-around due to a PL/SQL bug in Oracle 7.1.
--  960404  ERFO  Two new facilities in method Comment_Value_ to support NULL-
--                values in a comment string and to support ambigous key names
--                in a comment sting to support IFS/Info Services.
--  960404  ERFO  Changes to be ORACLE 7.3 compliant (Bug #473).
--  960415  ERFO  Changes in method Enumerate_Data_Items to retrieve package
--                name information by using name conventions instead of using
--                the LU-dictionary for optimal performance in the dialog for
--                Foundation Properties (Idea #491).
--  960429  ERFO  Changes in old method Enumerate_System_Services_ and added
--                PRAGMA-option WNPS where possible.
--  960503  STLA  Make Get_Data_Item_Properties_ do exception when column
--                not found.
--  960506  ERFO  Added dummy parameter to method Rebuild_Dictionary_Storage.
--                Removed use of field separator in beginning of the package
--                and view list columns in Rebuild_Dictionary_Storage and
--                added a special filter for company styled global keys.
--                Added parent child relationship by name convention for
--                IID-domains and ordinary logical units.
--  960508  ERFO  Added implementation method Method_Security_Enabled__ to
--                ensure correct security handle of package methods.
--  960517  ERFO  Fixed BIGCHAR2 problem by changing to VARCHAR2 (Bug #607).
--                Changed representation and logic in dictionary help table
--                to support very big logical units (Bug #611).
--                Added method Init to the list of non-security methods.
--  960528  ERFO  Changed order of close cursor in help method.
--  960610  ERFO  Changes in method Enum_Modules_ not to be case-sensitive
--                in the short name of the module identity (Bug #663).
--  960612  ERFO  Rearrangements and performance improvements in method
--                Rebuild_Dictionary_Storage_ to support all kinds of PL/SQL
--                without depending on too much name conventions in the way of
--                using the language (Bug #664).
--  960819  ERFO  Changes in Activate_Language_Refresh_ to improve performance
--                when searching for translation candidates (Idea #746).
--  960826  ERFO  Increased size of method variable in the implementation
--                of Rebuild_Dictionary_Storage_ (Bug #768).
--  960827  MANY  Changes in Enumerate_System_Services_, now performs a distinct
--                list of services (Bug #769).
--                Changes in Get_System_Service_Properties_, now returns a list
--                of packages (Bug #769).
--  960911  ERFO  Added error handling for occasions when using illegal module
--                name in logical unit source code package header (Idea #790).
--  960916  ERFO  Decreased result set for all cursor against package globals
--                in the view USER_SOURCE for optimal performance (Idea #798).
--  960919  ERFO  Rearrangements in Rebuild_Dictionary_Storage concerning
--                methods without any parameters.
--  961028  MANY  Changes in several locations, including Rebuild_Dictionary_Storage
--                and Get_Logical_Unit_Properties to ensure that reports are treated
--                correctly within the dictionary.
--  961029  ERFO  Added method Get_Logical_Unit_Keys_ to retrieve key names and/or
--                values for a specific logical unit instance (Idea #845).
--  961029  ERFO  Even more performance improvements in LU-dictionary (Idea #798)
--                and adjustments in Rebuild_Dictionary_Storage_.
--  961116  ERFO  Ensure that the conversion methods between db and client
--                names does not result in any exception (Bug #859).
--  961117  ERFO  Removed method Lock__ from being security aware.
--  961118  ERFO  Solve problem with naming conflicts in IFS/Accounting Rules.
--  961125  ERFO  Language change on the fly for client state values and added
--                state methods in function Method_Security_Enabled___.
--  961128  ERFO  Add filter to remove Foundation1 modules from IFS/Security
--                and corrected view problem in Get_Logical_Unit_Ref_Methods.
--  970122  ERFO  Solved problem with timestamp on the security cache after
--                that the Foundation1-modules being removed (Bug #944).
--  970127  ERFO  Illegal OR-statement in Get_Lov_View_ corrected to avoid
--                returning view connected to IFS/Info Services (Bug #957).
--  970212  ERFO  Correction in Get_Lu_Prompt_ to choose the first view
--                found instead of choosing the last one (Bug #977).
--  970213  ERFO  Add refresh of document dictionary info (Bug #985).
--  970403  ERFO  Removed third parameter in method Comment_Value_.
--  970424  ERFO  Changes in method Enumerate_Data_Items_ to include
--                more functions in the pseudo column list (Bug #1035).
--  970507  ERFO  Removed unused methods from the package (ToDo #1107).
--  970725  DOZE  Added method Get_Logical_Unit_Tables_ for history (ToDo #1109).
--  970825  ERFO  Re-installed Foundation1 modules in dictionary cache.
--  970826  ERFO  Solved problem in Rebuild_Dictionary_Storage_ when having
--                LU reference definitions longer than 100 bytes (Bug #1610).
--  971022  ERFO  Refresh only be run as application owner (ToDo #1286).
--                Removed additional refresh of Document_SYS cache.
--  971124  ERFO  Changes in Generate_Function_Comment___ to get correct
--                function data type to Foundation1 Properties (Bug #718).
--  971218  ERFO  String length is changed from 20 to 200 in method
--                Generate_Default_Comment to solve IID limits.
--  971218  ERFO  Added method Get_Data_Source_Properties__ and method
--                Get_Data_Item_Properties__ supporting the new SORT-flag
--                for view order-by clauses (ToDo #1633).
--  980211  DOZE  Added method Enum_Table_Columns_ for IFS/Design (ToDo #1867).
--  980418  ERFO  Correction in Activate_Language_Refresh_ (Bug #2365).
--  980504  ERFO  Oracle8-compliance in exception handle (Bug #2412).
--  980505  MANY  Correction in Activate_Language_Refresh_ (Bug #2365), continue
--                looping when error in specific package until all are finished.
--  980211  DOZE  Changed Enum_Table_Columns_ (Bug #2569).
--  980909  MANY  Changed Activate_Language_Refresh_ to only refresh packages
--                that are actually initiated within the active session (Bug #2685)
--  980915  ERFO  Reinstalled old version of Activate_Language_Refresh (Bug #2685).
--  981013  ERFO  Added method Enumerate_Logical_Units__ and reorganization
--                in Rose-model and model properties (ToDo #2774).
--  981207  DOZE  Removed part of Enumerate_Data_Items_ (Bug #2918)
--  990216  ERFO  Correction in Method_Security_Enabled___ to ensure that no
--                methods will be removed from the security tool (Bug #3141).
--  990222  ERFO  Yoshimura: Changes in Rebuild_Dictionary_Storage_ (ToDo #3160).
--  990428  ERFO  Rebuild performance and logical bug fixes (Bug #3333).
--  990605  ERFO  Change cursor in Activate_Language_Refresh_ (Bug #3411).
--  990805  ERFO  Added column METHOD_LIST2 to include large LU:s (ToDo #3365).
--  990922  ERFO  Added method Exist_Db in cursor in Rebuild (Bug #3590).
--  991005  DOZE  Translation between "Ifs Currency" and "IFS Currency" (Bug #3575)
--  000301  ERFO  Added cursor for pragma-methods in Rebuild-logic (Todo #3846).
--  000405  ERFO  Added resolve-operation for Security 2001 (ToDo #3846).
--  000522  ROOD  Performance improvements in Rebuild_Dictionary_Storage_.  (ToDo #3894).
--  000823  ROOD  Added condition for appowner in Get_Logical_Unit_Tables_ (ToDo #3919).
--  001211  ERFO  Added view FND_TAB_COMMENTS and use it in this package (Bug #18619).
--  001214  ERFO  Removed ACCRUL-specific code in Rebuild-procedure (ToDo #3973).
--  010926  ROOD  Added check not null on inparameters in most get-methods (Bug#22111).
--  011014  ROOD  Made Rebuild_Dictionary_Storage_ ignore case and comments (Bug#25453).
--  011122  ROOD  Added view FND_COL_COMMENTS and used it in this package (Bug #26328).
--  020115  ROOD  Moved views to api-file to avoid installation dependencies (Bug #26328).
--  020527  ROOD  Added group by statements to work around Oracle bug in
--                Rebuild_Dictionary_Storage_ (Bug#29242).
--  020628  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030317  ROOD  Replaced General_SYS.Get_Database_Properties with
--                Database_SYS.Get_Database_Properties (ToDo#4143).
--  030502  ROOD  Enabled dictionary information for system services (ToD0#4259).
--  030613  ROOD  Rebuilt the Get_Logical_Unit_Properties_xx methods (ToDo#4162).
--  030623  ROOD  Added public methods for runtime dictionary information support.
--                These methods replace equivalents in Transaction_SYS (ToDo#4162)
--  030819  ROOD  Trimmed whitespaces to the right for methods with pragma
--                in method Rebuild_Dictionary_Storage_ (ToDo#4160).
--  030931  HAAR  Obsoleted method Activate_Language_Refresh_ (ToDo#4305).
--  040407  HAAR  Unicode bulk changes,
--                extended define variable length in Get_Logical_Unit_Keys_ (F1PR408B).
--  040507  HAAR  Added Get_Logical_Unit and Get_Logical_Unit_ (F1PR419).
--  040607  ROOD  Added views for dictionary information (F1PR413).
--  040609  HAAR  Changes in Rebuild_Dictionary_Storage_ due to changed behavior in Oracle10g (Bug#44668).
--  040617  ROOD  Removed obsolete interfaces and restructured the implementation.
--                Moved all methods needed in Design-time to new system service
--                Design_SYS (F1PR413).
--  040907  ROOD  Increased the amount of information stored in the dictionary cache, regarding
--                view comments etc. Used new information in implementation.
--                Changed interface Get_Item_Prompt_, renamed Get_Main_View to Get_Base_View,
--                removed Get_Lov_View_ (F1PR413).
--  040908  ROOD  Increased the length for column_reference and added exception handling
--                for extraction of view column comments (F1PR413).
--  040910  ROOD  Changed default values for when column prompts couldn't be evaluated (F1PR413).
--  040916  ROOD  Avoided partial delete of column values if not necessary and other
--                performance improvements (F1PR413).
--  040923  ROOD  Added refresh mode. Made Get_Base_View_ public (F1PR413).
--  041025  ROOD  Modified date comparison in Rebuild_Dictionary_Storage_ and
--                Check_Dictionary_Storage_ to workaround date problems with Unicode (Call#119047).
--  041221  ROOD  Rewrote major parts of Rebuild_Dictionary_Storage_ to add more information
--                into LU dictionary and to improve performance (F1PR413).
--  041228   ROOD  Moved all views to api-file to indicate that they are public (F1PR413).
--  050105  ROOD  Changed values for view type in dictionary_sys_view_tab (F1PR413).
--  050111  JORA  Added view (dictionary_sys_state_event) for states  (F1PR413).
--  050117  JORA  Added view (dictionary_sys_state_trans) for states transitions (F1PR413).
--  050128  JORA  Moved lu_sub_type from  dictionary_sys_tab
--                to dictionary_sys_package_tab (F1PR413).
--  050310  HAAR  Added printout for LU names longer than 25 characters (F1PR480).
--  050408  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050513  JORA  Added Rebuild_State_Machine___. (F1PR413D)
--  050520  JORA  Added Get_No_Overloads, Get_No_Arguments, Get_Min_No_Arguments,
--                Get_Max_No_Arguments, Get_Argument_Type  (ESCHND-F1).
--  050706  HAAR  Removed depricated functions moved to Design_SYS (Bug#52284).
--                Enum_Modules_, Get_Logical_Unit_Properties_, Get_Data_Source_Properties_
--                Get_Data_Item_Properties_, Get_Logical_Unit_Method_ and Enum_Table_Columns_.
--  050818  JORA  Improved error msg for Rebuild_State_Machine___.
--  050830  JORA  Improved performace of Rebuild_Dictionary_Storage.
--  051003  HAAR  Changed Enum_Module_Logical_Units_ to include system services (F1PR843).
--  051110  HAAR  Added new argument to Enumerate_Logical_Units__.
--  051110  HAAR  Enum_Module_All_Logical_Units_ and Get_Logical_Unit_Properties2__ added (F1PR843).
--  051111  HAAR  Changed so that the follwoing methods are treated as PRAGMA methods:
--                LOCK__, LANGUAGE_REFRESHED, INIT, FINITE_STATE_DECODE__, ENUMERATE_STATES__,
--                FINITE_STATE_EVENTS__, ENUMERATE_EVENTS__, 'ENUMERATE', 'EXIST', 'EXIST_DB' (F1PR483).
--  051128  HAAR  Removed duplicate state values.
--  060105  UTGULK Annotated Sql injection.
--  060130  HAAR  Value error in Rebuild_Dictionary_Storage_ (Call 131508).
--  060426  HAAR  Added support for query against ROWSTATE instead of STATE when possible (Bug#57581).
--  060428  HAAR  Fixed problem in Rebuild_Dictionary_Storage_ when using Oracle 10.2.0.2 (Bug#57648).
--  070111  HAAR  Reroute xxx_Is_Installed methods to Database_SYS methods during Installation.
--                Added method Set_Installation_Mode (Bug#61829).
--  080208  HAAR  Added update of Cache Management when refreshing the cache (Bug#71136).
--  080304  HAAR  Some changes in refresh of cache (Bug#72156):
--                - Packages with errors or used for test can cause our tools to refresh all the time.
--                - Only consider packages with extension _API, _RPI and _SYS.
--                - Make error texts available in out parameter.
--                - Search Domain packages are not considered during the refresh of the Dictionary cache.
--                - Return errors in CLOB out variable.
--  080901  HASPLK Correcetd method Clientnametodbname to work with 30 characters long View names.
--  090309  HASPLK Added method Get_Installation_Mode (Bug#81092).
--  090312  HAAR  Changed so that Check_Method_From_View___ loops over all packages. (Bug#81246).
--                Changed so that ordering of packages in dictionary_sys_package_tab always is sorted in _API , _RPI, _SYS.
--  100324  UsRa  Changed Rebuild_Dictionary_Storage___ to include a new way to locate the base view of an LU (Bug#89730).
--  100531  GeGu  Modified Rebuild_Dictionary_Storage___ clear the middle tire cache as well
--  100915  ChMu  Increased Variable size of lu_struct_type and modified Enumerate_Logical_Units__. (Bug#93025)
--  110304  HaYa  Added sys_guid() to all direct record inserts.
--  110128  HAAR  Added code for handling of Custom Fields.
--  110921  MaBo  RDTERUNTIME-1076 Performance improvement when building Dictionary cache
--  120705  MaBose  Conditional compiliation improvements - Bug 103910
--  121025  USRA  Modified Get_Logical_Unit_Views__ to support 32000 characters (Bug#106270).
--  200903  RAKUSE Modified Get_Base_Package, Get_Component & Rebuild_Dictionary_Storage___ to cover for ObjectConnections annotations (Bug#155466).
--  211019  RAKUSE Added Get_Base_Package_Of_Type (TEZAUFW-1862).
-----------------------------------------------------------------------------
--
--  Contents:  Property fetching routines for run-time use (private)
--             Naming conversions for client versus database object names
--             Comment decoding routines for LU-dictionary
--             Prompt fetching routines, mainly used for localization
--             Property fetching routines for run-time use (protected)
--             Runtime performance refreshment routines
--             Property fetching routines for design-time use (Depreciated)
--             Public runtime methods for dictionary information suppor
--
--  Identifier Length Limits:
--             Normal LUs (.entity, .enumeration, .utility. .searchdomain)
--             ----------------------------------------------
--             LU Name: 25 characters
--             DB Object 30 characters (Package, Method, View, Column, Table)

--             Projections/ClientMeta (.projection, .client): (NOT included in Dictionary)
--             -----------------------
--             LU Name: 80 character
--             DB Objects: 128 characters (Package, Methods)
--                         30 characters (Virtual)
--
--  Lu Types :
--             N - Normal LUs
--             S - System Service
--
--  Lu Sub Types :
--             D - Domain (Enumeration)
--             S - Entity With State
--             N - Normal
--
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

MIDDLE_TIER_PROJECTION CONSTANT VARCHAR2(3) := 'MTP';
CLIENT_LAYOUT          CONSTANT VARCHAR2(3) := 'CLL';
MAX_DICT_IDENTIFER_LENGTH   CONSTANT NUMBER := 30;

ORA_MAX_NAME_LEN            CONSTANT NUMBER :=  dbms_standard.ORA_MAX_NAME_LEN;

-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE lu_struct_type IS TABLE OF VARCHAR2(32767) INDEX BY BINARY_INTEGER;
TYPE object_array IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;

field_separator_  CONSTANT VARCHAR2(1)    := Client_SYS.field_separator_;
record_separator_ CONSTANT VARCHAR2(1)    := Client_SYS.record_separator_;
text_separator_   CONSTANT VARCHAR2(1)    := Client_SYS.text_separator_;

TYPE cache_type                     IS TABLE OF VARCHAR2(128) INDEX BY VARCHAR2(1000);
TYPE cache_category_type            IS TABLE OF cache_type INDEX BY VARCHAR2(1000);
TYPE micro_cache_time_type          IS TABLE OF NUMBER INDEX BY VARCHAR2(1000);
TYPE micro_cache_max_id_type        IS TABLE OF PLS_INTEGER INDEX BY VARCHAR2(1000);
micro_cache_tab_                    cache_category_type;
micro_cache_time_                   micro_cache_time_type;
micro_cache_max_id_                 micro_cache_max_id_type ;
max_cached_element_count_           CONSTANT NUMBER := 100;
max_cached_element_life_            CONSTANT NUMBER := 100;
micro_cache_user_                   VARCHAR2(128) := Fnd_Session_API.Get_Fnd_User;

ORA_CODE_NUM_OR_VAL_ERR       CONSTANT NUMBER := -06502;
numeric_or_val_error EXCEPTION;
PRAGMA EXCEPTION_INIT(numeric_or_val_error, ORA_CODE_NUM_OR_VAL_ERR);

VIEW_ROW_LEVEL_SECURITY_COMMENT CONSTANT VARCHAR2(30) := 'ROW_LEVEL_SECURITY';
COLUMN_ROW_LEVEL_SECURITY_COMMENT      CONSTANT VARCHAR2(30) := 'ROW_LEVEL_SECURITY';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


FUNCTION Get_Cache_Value___ (
   cache_category_ IN VARCHAR2,
   object_id_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   time_       NUMBER := Database_SYS.Get_Time_Offset;
   expired_    BOOLEAN;
   
   FUNCTION Get_Micro_Cache_Time___ (
      cache_category_ IN VARCHAR2,
      time_           IN NUMBER ) RETURN NUMBER 
   IS
      cache_time_ NUMBER;
   BEGIN
      BEGIN 
         cache_time_ := micro_cache_time_(cache_category_);
      EXCEPTION
         WHEN no_data_found THEN
            cache_time_ := time_;
      END;
      RETURN(cache_time_);
   END Get_Micro_Cache_Time___;
   
BEGIN
   expired_ := (time_ - Get_Micro_Cache_Time___(cache_category_, time_) > max_cached_element_life_);
   IF (expired_ OR (micro_cache_user_ IS NULL) OR (micro_cache_user_ != Fnd_Session_API.Get_Fnd_User)) THEN
      micro_cache_tab_(cache_category_).delete;
      micro_cache_max_id_(cache_category_) := 0;
      micro_cache_time_(cache_category_)  := 0;
      micro_cache_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   RETURN(micro_cache_tab_(cache_category_)(object_id_));
EXCEPTION
      WHEN value_error THEN
         RETURN(NULL);
      WHEN no_data_found THEN
         RETURN(NULL);
END Get_Cache_Value___;

PROCEDURE Set_Cache_Value___ (
   cache_category_ IN VARCHAR2,
   object_id_    IN VARCHAR2, 
   object_value_ IN VARCHAR2 )
IS
   time_       NUMBER := Database_SYS.Get_Time_Offset;
   random_  NUMBER := NULL;

   FUNCTION Get_Micro_Cache_Max_Id___ (
      cache_category_ IN VARCHAR2 ) RETURN PLS_INTEGER 
   IS
      max_id_ PLS_INTEGER;
   BEGIN
      BEGIN 
         max_id_ := micro_cache_max_id_(cache_category_);
      EXCEPTION
         WHEN no_data_found THEN
            max_id_ := 1;
      END;
      RETURN(max_id_);
   END Get_Micro_Cache_Max_Id___;

BEGIN
   micro_cache_tab_(cache_category_)(object_id_) := object_value_;
   micro_cache_time_(cache_category_) := time_;
   IF (micro_cache_tab_(cache_category_).count >= max_cached_element_count_) THEN
      random_ := round(dbms_random.value(1, max_cached_element_count_), 0);
      micro_cache_tab_(cache_category_).delete(random_);
   ELSE
      micro_cache_max_id_(cache_category_) := Get_Micro_Cache_Max_Id___(cache_category_) + 1;
   END IF;
EXCEPTION
   WHEN value_error THEN
      NULL;
END Set_Cache_Value___;


FUNCTION Check_Method_From_View___ (
   view_name_      IN  VARCHAR2,
   method_name_    IN  VARCHAR2 ) RETURN VARCHAR2
IS
   lu_name_               VARCHAR2(30);
   package_list_          VARCHAR2(2000);
   package_name_          VARCHAR2(ORA_MAX_NAME_LEN);
   index_                 NUMBER;
BEGIN
   lu_name_      := Get_Logical_Unit(view_name_, 'VIEW');
   package_list_ := Get_Logical_Unit_Packages__(lu_name_);
   index_        := instr(package_list_, field_separator_);
   WHILE (index_ > 0) LOOP
      package_name_ := Substr(package_list_, 1, index_ - 1);
      package_list_ := Substr(package_list_, index_ + 1);
      IF (Method_Is_Installed(package_name_, method_name_)) THEN
         RETURN(package_name_||'.'||method_name_);
      END IF;
      index_ := instr(package_list_, field_separator_);
   END LOOP;
   RETURN(NULL);
END Check_Method_From_View___;


FUNCTION Rebuild_Dictionary_Storage___ (
   refresh_mode_ IN VARCHAR2 DEFAULT 'PARTIAL',
   write_clob_   IN BOOLEAN  DEFAULT FALSE,
   cleanup_      IN BOOLEAN DEFAULT TRUE ) RETURN CLOB
IS
   developer_mode_   BOOLEAN := refresh_mode_ = 'DEVELOPER';
   refresh_all_      BOOLEAN := refresh_mode_ IN ('FULL', 'DEVELOPER');
   refresh_views_    BOOLEAN := refresh_mode_ IN ('VIEWS', 'PARTIAL', 'LIGHT', 'COMPUTE', 'COMPUTEVIEWS');
   refresh_pkgs_     BOOLEAN := refresh_mode_ IN ('PACKAGES', 'PARTIAL', 'LIGHT', 'COMPUTE', 'COMPUTEPKGS');
   refresh_all_views_ BOOLEAN := refresh_all_;
   refresh_all_pkgs_ BOOLEAN := refresh_all_;
   rebuild_needed_   NUMBER;
   qty_pkgs_         NUMBER;
   qty_views_        NUMBER;
   last_update_      DATE;

   pkg_lu_name_      VARCHAR2(30);
   pkg_lu_type_      VARCHAR2(1);
   pkg_lu_sub_type_  VARCHAR2(1);
   pkg_index_        NUMBER;

   method_           VARCHAR2(100);

   view_lu_name_     VARCHAR2(30);
   base_package_name_ dictionary_sys_tab.base_package%TYPE;
   view_module_      VARCHAR2(30);
   view_prompt_      VARCHAR2(200);
   table_name_       VARCHAR2(100);
   server_only_      VARCHAR2(5);
   validity_mode_    VARCHAR2(60);
   objversion_       VARCHAR2(2000);
   objstate_         VARCHAR2(2000);
   objid_            VARCHAR2(2000);
   objkey_           VARCHAR2(100);
   refbase_          VARCHAR2(30);
   basedon_          VARCHAR2(30);
   basedonfilter_    VARCHAR2(200);
   view_row_level_security_ dictionary_sys_view_tab.row_level_security%TYPE;
   error_text_       CLOB;

   TYPE domain_states_array IS TABLE OF VARCHAR2(120) INDEX BY BINARY_INTEGER;
   db_values_        domain_states_array;
   client_values_    domain_states_array;

   TYPE complete_value_array IS TABLE OF dictionary_sys_domain_tab%ROWTYPE INDEX BY BINARY_INTEGER; -- same as dictionary_sys_state_tab...
   complete_values_  complete_value_array;

   TYPE state_event_array IS TABLE OF dictionary_sys_state_event_tab%ROWTYPE INDEX BY BINARY_INTEGER;

   CURSOR get_last_update IS
      SELECT MAX(rowversion)
      FROM dictionary_sys_package_tab;

   --
   -- LAST_DDL_TIME:
   --    The timestamp for the last DDL change (including GRANT and REVOKE) to the object.
   --    Format is VARCHAR2(19)...
   --
   -- TIMESTAMP
   --    The timestamp for the specification of the object.
   --    Format is DATE.
   --
   -- VIEWS:
   --    TIMESTAMP for a view is not updated unless the code of the view is modified.
   --
   -- PACKAGES:
   --    TIMESTAMP for a packages is updated as soon as the package code is recompiled.
   --
   -- This is the reason why different criteria is used for views and for packages.
   -- It is necessary that views are refreshed after they have been recompiled,
   -- even if the code has not been modified, since the information is in the comments.
   --

   -- Packages to update (timestamp has changed since last update)
   CURSOR get_pkgs_to_update(last_cache_update_ IN DATE) IS
      SELECT o.object_name package_name,
             substr(s1.text,
                    instr(s1.text,'''')+1,
                    instr(s1.text,'''',instr(s1.text,'''')+1)-instr(s1.text,'''')-1) module,
             substr(s2.text,
                    instr(s2.text,'''')+1,
                    instr(s2.text,'''',instr(s2.text,'''')+1)-instr(s2.text,'''')-1) service,
             substr(s3.text,
                    instr(s3.text,'''')+1,
                    instr(s3.text,'''',instr(s3.text,'''')+1)-instr(s3.text,'''')-1) lu_name,
             substr(s4.text,
                    instr(s4.text,'''')+1,
                    instr(s4.text,'''',instr(s4.text,'''')+1)-instr(s4.text,'''')-1) lu_type
      FROM   user_objects o,
             user_source s1,
             user_source s2,
             user_source s3,
             user_source s4
      WHERE  o.object_type = 'PACKAGE'
      AND    o.object_type = s1.type (+)
      AND    o.object_name = s1.name (+)
      AND    s1.line (+) BETWEEN 2 AND 11
      AND    s1.text (+) LIKE '%module_%:=%''%''%'
      AND    s1.text (+) NOT LIKE '--%'
      AND    s1.text (+) NOT LIKE '%/%*%'
      AND    s1.text (+) NOT LIKE '%*%/'
      AND    o.object_type = s2.type (+)
      AND    o.object_name = s2.name (+)
      AND    s2.line (+) BETWEEN 2 AND 11
      AND    s2.text (+) LIKE '%service_%:=%''%''%'
      AND    s2.text (+) NOT LIKE '--%'
      AND    s2.text (+) NOT LIKE '%/%*%'
      AND    s2.text (+) NOT LIKE '%*%/'
      AND    o.object_type = s3.type (+)
      AND    o.object_name = s3.name (+)
      AND    s3.line (+) BETWEEN 2 AND 11
      AND    s3.text (+) LIKE '%lu_name_%:=%''%''%'
      AND    s3.text (+) NOT LIKE '--%'
      AND    s3.text (+) NOT LIKE '%/%*%'
      AND    s3.text (+) NOT LIKE '%*%/'
      AND    o.object_type = s4.type (+)
      AND    o.object_name = s4.name (+)
      AND    s4.line (+) BETWEEN 2 AND 11
      AND    s4.text (+) LIKE '%lu_type_%:=%''%''%'
      AND    s4.text (+) NOT LIKE '--%'
      AND    s4.text (+) NOT LIKE '%/%*%'
      AND    s4.text (+) NOT LIKE '%*%/'
      AND    substr(o.object_name, -4) IN ('_API', '_CFP', '_ICP', '_CLP', '_RPI', '_SYS', '_SCH', '_APN') -- Exclude projections (_SVC), mobile utilities (_JSN, _TLM)
      AND    o.object_name NOT LIKE 'COMPONENT/_%/_SYS' ESCAPE '/'
      AND   (o.timestamp > to_char(last_cache_update_, 'YYYY-MM-DD:HH24:MI:SS')
      OR     last_cache_update_ IS NULL)
      ORDER BY substr(o.object_name, -3); -- The ordering should be API, RPI, SYS
   TYPE pkg_rec_table IS TABLE OF get_pkgs_to_update%ROWTYPE;
   packages_ pkg_rec_table := pkg_rec_table();

   app_owner_ VARCHAR2(30) := Fnd_Session_API.Get_App_Owner;
   -- Views to update
   CURSOR get_views_to_update IS
      SELECT ft.table_name view_name, ft.comments view_comment
      FROM fnd_tab_comments ft
      WHERE ft.comments IS NOT NULL
      AND ft.table_name NOT LIKE 'AQ$%' -- Exclude Oracle Advance Queue views
      AND ft.table_type='VIEW'
      AND ft.comments != 'MODULE=IGNORE^'
      AND (NOT EXISTS
      (SELECT 1
       FROM dictionary_sys_view_tab d
       WHERE ft.table_name=d.view_name
       AND ft.comments=d.view_comment)
      OR EXISTS
      (SELECT 1
       FROM dictionary_sys_view_tab d
       WHERE view_name = ft.table_name
       AND EXISTS (
       (SELECT 1
        FROM dictionary_sys_view_tab v
        WHERE view_type = 'B'
        AND d.lu_name = v.lu_name
        AND (NOT EXISTS
        (SELECT 1
         FROM all_objects u
         WHERE u.object_name = v.view_name
         AND object_type = 'VIEW'
         AND owner = app_owner_)
         OR EXISTS
         (SELECT 1
          FROM fnd_tab_comments ft
          WHERE ft.table_name=v.view_name
          AND ft.comments!=v.view_comment))))))
      UNION
      SELECT ft.table_name view_name, ft.comments view_comment
      FROM fnd_col_comments fc, fnd_tab_comments ft
      WHERE ft.table_name NOT LIKE 'AQ$%' -- Exclude Oracle Advance Queue views
      AND fc.table_name=ft.table_name
      AND ft.table_type='VIEW'
      AND ft.comments != 'MODULE=IGNORE^'
      AND NVL(Dictionary_SYS.Comment_Value_('SERVER_ONLY', ft.comments), 'FALSE') = 'FALSE'
      AND NOT EXISTS
      (SELECT 1
       FROM dictionary_sys_view_column_tab d
       WHERE fc.table_name=d.view_name
       AND fc.column_name=d.column_name
       AND NVL(fc.comments, 'X#X')=NVL(d.column_comment, 'X#X'));

   CURSOR get_qty_all_pkgs IS
      SELECT COUNT(*)
      FROM user_objects
      WHERE object_type = 'PACKAGE'
      AND substr(object_name, -4) IN ('_API', '_CFP', '_ICP', '_CLP', '_RPI', '_SYS', '_SCH', '_APN'); -- Exclude projections (_SVC), and mobile utilities (_JSN, _TLM)

   -- All view (used when doing a full refresh for performance reasons)
   CURSOR get_all_views IS
      SELECT ft.table_name view_name, ft.comments view_comment
      FROM user_objects, fnd_tab_comments ft
      WHERE object_type = 'VIEW'
      AND object_name NOT LIKE 'AQ$%' -- Exclude Oracle Advance Queue views
      AND object_name=ft.table_name
      ORDER BY created;

   TYPE view_tab IS TABLE OF get_all_views%ROWTYPE;
   views_ view_tab := view_tab();
   -- All view (used when doing a full refresh for performance reasons)
   CURSOR get_qty_all_views IS
      SELECT COUNT(*)
      FROM user_objects
      WHERE object_type = 'VIEW'
      AND object_name NOT LIKE 'AQ$%';

   PROCEDURE Write_Error_Text___ (
      clob_     IN OUT NOCOPY CLOB,
      text_     IN            VARCHAR2,
      new_line_ IN            BOOLEAN DEFAULT TRUE )
   IS
   BEGIN
      IF write_clob_ THEN
         IF new_line_ THEN
            clob_ := clob_ || chr(10) || text_;
         ELSE
            clob_ := clob_ || text_;
         END IF;
      ELSE
         IF new_line_ THEN
            Log_SYS.Fnd_Trace_(Log_SYS.error_, text_);
         ELSE
            Log_SYS.Fnd_Trace_(Log_SYS.error_, text_);
         END IF;
      END IF;
   END Write_Error_Text___;


   PROCEDURE Get_Next_Pkg_Index___ (
      lu_name_        IN VARCHAR2,
      next_pkg_index_ OUT NUMBER )
   IS
      CURSOR next_index IS
         SELECT nvl(MAX(package_index), 0) + 1
         FROM dictionary_sys_package_tab
         WHERE lu_name = lu_name_;
   BEGIN
      OPEN next_index;
      FETCH next_index INTO next_pkg_index_;
      CLOSE next_index;
   END Get_Next_Pkg_Index___;

   PROCEDURE Get_Next_View_Index___ (
      lu_name_         IN VARCHAR2,
      next_view_index_ OUT NUMBER )
   IS
      CURSOR next_index IS
         SELECT nvl(MAX(view_index), 0) + 1
         FROM dictionary_sys_view_tab
         WHERE lu_name = lu_name_;
   BEGIN
      OPEN next_index;
      FETCH next_index INTO next_view_index_;
      CLOSE next_index;
   END Get_Next_View_Index___;

   PROCEDURE Fill_List_Array___ (
      info_type_       IN VARCHAR2,
      lu_name_         IN VARCHAR2,
      package_name_    IN VARCHAR2,
      db_values_       IN OUT domain_states_array,
      client_values_   IN OUT domain_states_array,
      complete_values_ OUT complete_value_array )
   IS
      stmt_   VARCHAR2(200);
      error_  BOOLEAN := FALSE;
      domain_ BOOLEAN := info_type_ = 'domain';
      client_count_ NUMBER;
      db_count_     NUMBER;
   BEGIN
      -- Check for incorrectness in number of values and remove redundant information if it occurs
      IF db_values_.COUNT != client_values_.COUNT THEN
         client_count_ := client_values_.COUNT;
         db_count_ := db_values_.COUNT;
         IF db_count_ > client_count_ THEN
            -- Missing client values
--            Assert_SYS.Assert_Is_Package(package_name_);
            stmt_ := 'BEGIN :client_value_ := '||package_name_||'.Decode(:db_value_); END;';
            FOR i IN Nvl(db_values_.FIRST, 0)..Nvl(db_values_.LAST, -1) LOOP
               -- Try to find more values by calling standard interfaces for domains,
               -- else fill out the array if it is still incomplete...
               IF domain_ THEN
                  BEGIN
                     @ApproveDynamicStatement(2006-01-05,utgulk)
                     EXECUTE IMMEDIATE stmt_ USING OUT client_values_(i), IN db_values_(i);
                  EXCEPTION
                     WHEN OTHERS THEN
                        client_values_(i) := 'Value not defined!';
                        error_ := TRUE;
                  END;
               ELSE
                  -- Can't find the values for other types than domains...
                  client_values_(i) := 'Value not defined!';
                  error_ := TRUE;
               END IF;

            END LOOP;
         ELSE
            -- Missing db values
--            Assert_SYS.Assert_Is_Package(package_name_);
            stmt_ := 'BEGIN :db_value_ := '||package_name_||'.Encode(:client_value_); END;';
            FOR i IN Nvl(client_values_.FIRST,0)..Nvl(client_values_.LAST,-1) LOOP
               -- Try to find more values by calling standard interfaces for domains,
               -- else fill out the array if it is still incomplete...
               IF domain_ THEN
                  BEGIN
                     @ApproveDynamicStatement(2006-01-05,utgulk)
                     EXECUTE IMMEDIATE stmt_ USING OUT db_values_(i), IN client_values_(i);
                  EXCEPTION
                     WHEN OTHERS THEN
                        db_values_(i) := 'VALUE NOT DEFINED!';
                        error_ := TRUE;
                  END;
               ELSE
                  -- Can't find the values for other types than domains...
                  db_values_(i) := 'VALUE NOT DEFINED!';
                  error_ := TRUE;
               END IF;
            END LOOP;
         END IF;
         -- Log information if values could not be determined...
         IF error_ THEN
            Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Inconsistency between client values and db values for '||info_type_||' package '||package_name_||'!', FALSE);
            Write_Error_Text___ (error_text_, '          '||to_char(db_count_)||' db values and '||to_char(client_count_)||' client values was found!');
         END IF;
      END IF;
      FOR i IN Nvl(db_values_.FIRST,0)..Nvl(db_values_.LAST,-1) LOOP
         complete_values_(i).lu_name      := lu_name_;
         complete_values_(i).package_name := package_name_;
         complete_values_(i).db_value     := db_values_(i);
         complete_values_(i).client_value := client_values_(i);
         complete_values_(i).rowversion   := SYSDATE;
      END LOOP;
   END Fill_List_Array___;

   PROCEDURE Rebuild_State_Machine___(full_mode_ BOOLEAN DEFAULT TRUE) IS

      last_updated_ DATE DEFAULT NULL;

      CURSOR state_mach IS
         SELECT decode(upper(regexp_substr(a.text,'[[:alpha:]]+_')) ,
                   'STATE_','START',
                   'EVENT_','EVENT',
                   'FINITE_','END',
                   NULL) TYPE,
               regexp_substr(a.text,'''[[:alpha:]|[:space:]]+''') WHAT,
               a.NAME PACKAGE
         FROM USER_SOURCE A, USER_OBJECTS O
         WHERE EXISTS (SELECT 1 FROM DICTIONARY_SYS_STATE_TAB D WHERE D.PACKAGE_NAME = O.OBJECT_NAME)
           AND A.NAME = O.OBJECT_NAME
           AND A.TYPE = 'PACKAGE BODY'
           AND O.OBJECT_TYPE   = 'PACKAGE'
           AND TO_DATE(timestamp,'RRRR-MM-DD:HH24:MI:SS') > last_updated_
           AND regexp_like(a.text,'(state_[[:space:]]*(=|(IS)))|(event_[[:space:]]*(=|(IS)))|(Finite_State_Set___\(rec_,)','i_')
         ORDER BY a.name, a.line ASC;

      TYPE state_machine_type IS TABLE OF state_mach%ROWTYPE INDEX BY PLS_INTEGER;
      TYPE dic_state_mach_type IS TABLE OF dictionary_sys_state_mach_tab%ROWTYPE INDEX BY BINARY_INTEGER;

      bulk_errors   EXCEPTION;
      PRAGMA EXCEPTION_INIT(bulk_errors, -24381);

      state_machine_         state_machine_type;
      model_                 dic_state_mach_type;
      start_mode_            VARCHAR2(30);
      in_state_transistion_  BOOLEAN := FALSE;
      error_count_           NUMBER;
      j_                     PLS_INTEGER;
      i_                     PLS_INTEGER;
      position_              NUMBER;

      FUNCTION Get_Lu_Name_(
            package_name_ VARCHAR2) RETURN VARCHAR2
         IS
            tmp_ VARCHAR2(60) DEFAULT NULL;
         BEGIN
            SELECT lu_name INTO tmp_
               FROM dictionary_sys_package_tab
               WHERE package_name= package_name_;
            RETURN tmp_;
         EXCEPTION
            WHEN OTHERS THEN
               Write_Error_Text___ (error_text_, '          Failed to find LU name for package '||package_name_);
               RETURN NULL;
         END Get_Lu_Name_;

         FUNCTION trim_str(str_ VARCHAR2) RETURN VARCHAR2
         IS
         BEGIN
              RETURN SUBSTR(str_,2, length(str_)-2);
         END trim_str;


   BEGIN
      IF full_mode_ THEN
         last_updated_:= SYSDATE-1000;
      ELSE
         SELECT NVL(MAX(updated),SYSDATE-1000) INTO last_updated_ FROM dictionary_sys_state_mach_tab;
      END IF;
      OPEN state_mach;
      FETCH state_mach BULK COLLECT INTO state_machine_;
      CLOSE state_mach;
      j_ := 1;
      i_:=2;
      WHILE i_ < NVL(state_machine_.LAST, -1)  LOOP
         IF state_machine_(i_-1).type ='START' AND state_machine_(i_).type = 'EVENT' THEN
            in_state_transistion_:= TRUE;
            start_mode_:=trim_str(state_machine_(i_-1).what);
             WHILE  in_state_transistion_ AND i_+1 <= NVL(state_machine_.LAST, -1) LOOP
               IF state_machine_(i_).type='EVENT' AND
                  state_machine_(i_+1).type='END' AND
                  trim_str(state_machine_(i_).what) IS NOT NULL THEN
                  model_(j_).start_state:=start_mode_;
                  model_(j_).event:=trim_str(state_machine_(i_).what);
                  model_(j_).end_state:=trim_str(state_machine_(i_+1).what);
                  model_(j_).package_name:=state_machine_(i_).PACKAGE;
                  model_(j_).lu_name:= get_lu_name_(state_machine_(i_).PACKAGE);
                  model_(j_).updated:=SYSDATE;
                  model_(j_).rowversion:=SYSDATE;
                  i_:=i_+2;
                  j_:=j_+1;
               ELSIF state_machine_(i_).type!='START' AND i_ < NVL(state_machine_.LAST, -1) THEN
                  i_:=i_+1;
               ELSE
                  in_state_transistion_:=FALSE;
                  i_:=i_+1;
               END IF;
            END LOOP;
         ELSE
            i_:=i_+1;
         END IF;
      END LOOP;
--  This line only used when debugging
--      FOR k IN model_.FIRST..model_.LAST LOOP
--          Write_Error_Text___ (error_text_, model_(k).package_name||':'||model_(k).start_state||'->'||model_(k).event||'->'||model_(k).end_state);
--      END LOOP;
         BEGIN
            IF developer_mode_ THEN
               @ApproveDynamicStatement(2006-02-15,pemase)
               EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_state_mach_tab';
            ELSE
               DELETE FROM dictionary_sys_state_mach_tab;
            END IF;
            Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
            Write_Error_Text___ (error_text_, '   Dictionary Cache is being updated with '||model_.count ||' state machine entrie(s).');
            Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
            FORALL k IN NVL(model_.FIRST,0)..NVL(model_.LAST,-1) SAVE EXCEPTIONS
               INSERT INTO dictionary_sys_state_mach_tab VALUES model_(k);
         EXCEPTION
            WHEN bulk_errors THEN
               error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
               Write_Error_Text___ (error_text_, '   '||to_char(error_count_)||' problem(s) when inserting dictionary state machine information.');
               FOR i IN 1..error_count_ LOOP
                  position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
--                  Write_Error_Text___ (error_text_, '   Position number '||to_char(position_));
                  Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(model_(position_).lu_name),6)||':Error ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'lu_name='||model_(position_).lu_name||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'package_name='||model_(position_).package_name||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'start_state='||model_(position_).start_state||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'event='||model_(position_).event||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'end_state='||model_(position_).end_state);
               END LOOP;
         END;
   EXCEPTION
      WHEN OTHERS THEN
           Write_Error_Text___ (error_text_, '   '||dbms_utility.format_error_backtrace);
   END  Rebuild_State_Machine___;


   PROCEDURE Rebuild_All_State_Event___(full_mode_ BOOLEAN DEFAULT TRUE) IS

      last_updated_ DATE DEFAULT NULL;

      CURSOR  get_events IS
         SELECT regexp_substr(text,'([[:alpha:]]+\^){1,}') event, Name
         FROM USER_SOURCE A, USER_OBJECTS O
         WHERE EXISTS (SELECT 1 FROM DICTIONARY_SYS_STATE_TAB D WHERE D.PACKAGE_NAME = O.OBJECT_NAME)
           AND A.NAME = O.OBJECT_NAME
           AND A.TYPE = 'PACKAGE BODY'
           AND O.OBJECT_TYPE   = 'PACKAGE'
           AND TO_DATE(timestamp,'RRRR-MM-DD:HH24:MI:SS') > last_updated_
           AND regexp_like(text, '^[[:space:]]{0,}db_events_[[:space:]]{0,}:=');

      TYPE state_array IS TABLE OF get_events%ROWTYPE INDEX BY BINARY_INTEGER;
      TYPE event_array IS TABLE OF VARCHAR2(40) INDEX BY PLS_INTEGER;
      state_events_        state_array ;
      state_event_values_  state_event_array;
      event_array_         event_array;

      match_         INTEGER;
      counter_       INTEGER;
      event_idx_     INTEGER;
      event_         VARCHAR2(32);
      error_count_   NUMBER;
      position_      NUMBER;
      dup_event_val_ BOOLEAN;


      bulk_errors   EXCEPTION;
      PRAGMA EXCEPTION_INIT(bulk_errors, -24381);

      FUNCTION Get_Lu_Name_(
         package_name_ VARCHAR2) RETURN VARCHAR2
      IS
         tmp_ VARCHAR2(60) DEFAULT NULL;
      BEGIN
         SELECT lu_name INTO tmp_
            FROM dictionary_sys_package_tab
            WHERE package_name= package_name_;
         RETURN tmp_;
      EXCEPTION
         WHEN OTHERS THEN
            Write_Error_Text___ (error_text_, '          Failed to find LU name for package '||package_name_);
            RETURN NULL;
      END Get_Lu_Name_;

   BEGIN

      IF full_mode_ THEN
         last_updated_:= SYSDATE-1000;
      ELSE
         SELECT NVL(MAX(updated),SYSDATE-1000) INTO last_updated_ FROM dictionary_sys_state_mach_tab;
      END IF;

      OPEN get_events;
      FETCH get_events BULK COLLECT INTO state_events_;
      IF SQL%NOTFOUND THEN
         Write_Error_Text___ (error_text_, '   No state events found.');
         CLOSE get_events;
         RETURN;
      ELSE
         BEGIN
            IF developer_mode_ THEN
               @ApproveDynamicStatement(2006-02-15,pemase)
               EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_state_event_tab';
            ELSE
               DELETE FROM dictionary_sys_state_event_tab;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Write_Error_Text___ (error_text_, '   Failed to truncate dictionary_sys_state_event_tab.');
               Write_Error_Text___ (error_text_, '   '||dbms_utility.format_error_backtrace);
               RETURN;
         END;
      END IF;
      CLOSE get_events;
      Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
      Write_Error_Text___ (error_text_, '   Dictionary Cache is fetching State Events');
      Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
      counter_:=1;
      FOR i IN Nvl(state_events_.FIRST,0)..Nvl(state_events_.LAST,-1) LOOP
         match_:=1;
         event_idx_:=1;
         event_array_.DELETE;
         LOOP
            dup_event_val_:= FALSE;
            event_:=REGEXP_SUBSTR(state_events_(i).event,'([[:alpha:]|[:digit:]|[:blank:]]+\^)', 1, match_);
            EXIT WHEN event_ IS NULL;
            IF event_idx_!=1 THEN
               dup_event_val_:= FALSE;
               FOR j IN Nvl(event_array_.FIRST,0)..Nvl(event_array_.LAST,-1) LOOP
                  IF event_array_(j)=event_ THEN
                     dup_event_val_:= TRUE;
                     EXIT;
                  END IF;
               END LOOP;
            END IF;
            IF NOT dup_event_val_ THEN
               event_array_(event_idx_):=event_;
               state_event_values_(counter_).lu_name:=get_lu_name_(state_events_(i).name);
               state_event_values_(counter_).package_name:=state_events_(i).name;
               state_event_values_(counter_).event:=substr(event_,1,length(event_)-1);
               state_event_values_(counter_).rowversion:=SYSDATE;
               counter_:=counter_+1;
               event_idx_:=event_idx_+1;
--            ELSE
--               Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(get_lu_name_(state_events_(i).name)),6)||':Skipping duplicate event ('||substr(event_,1,length(event_)-1)||') for LU:'||get_lu_name_(state_events_(i).name));
            END IF;
            match_:=match_+1;
         END LOOP;
      END LOOP;

      BEGIN
         Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
         Write_Error_Text___ (error_text_, '   Dictionary Cache is being updated with '||state_event_values_.count ||' State Event(s)');
         Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
         FORALL j IN Nvl(state_event_values_.FIRST, 0)..Nvl(state_event_values_.LAST, -1) SAVE EXCEPTIONS
            INSERT INTO dictionary_sys_state_event_tab VALUES state_event_values_(j);
      EXCEPTION
         WHEN bulk_errors THEN
            error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
            Write_Error_Text___ (error_text_, '   '||to_char(error_count_)||' problem(s) when inserting dictionary state event information.');
            FOR i IN 1..error_count_ LOOP
               position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
--               Write_Error_Text___ (error_text_, '   Position number '||to_char(position_));
               Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(state_event_values_(position_).lu_name),6)||':Error ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)||', ', FALSE);
               Write_Error_Text___ (error_text_, 'lu_name='||nvl(state_event_values_(position_).lu_name, 'NULL')||', ', FALSE);
               Write_Error_Text___ (error_text_, 'package_name='||nvl(state_event_values_(position_).package_name, 'NULL')||', ', FALSE);
               Write_Error_Text___ (error_text_, 'event='||nvl(state_event_values_(position_).event, 'NULL'));
            END LOOP;
         WHEN OTHERS THEN
            Write_Error_Text___ (error_text_, '   Failed to truncate dictionary_sys_state_event_tab.');
            Write_Error_Text___ (error_text_, '   '||dbms_utility.format_error_backtrace);
      END;

   EXCEPTION
      WHEN OTHERS THEN
         Write_Error_Text___ (error_text_, '   Failed to rebuild dictionary_sys_state_event_tab.');
         Write_Error_Text___ (error_text_, '   '||dbms_utility.format_error_backtrace);
   END Rebuild_All_State_Event___;



   PROCEDURE Rebuild_State_Transitions___(full_mode_ BOOLEAN DEFAULT TRUE) IS

      last_updated_ DATE DEFAULT NULL;

      match_         INTEGER;
      counter_       INTEGER;
      allowed_event_ VARCHAR2(32);
      state_trans_   VARCHAR2(130);
      error_count_   NUMBER;
      position_      NUMBER;

      bulk_errors   EXCEPTION;
      PRAGMA EXCEPTION_INIT(bulk_errors, -24381);

      CURSOR get_state_events_
      IS
      SELECT lu_name, package_name, db_state
         FROM dictionary_sys_state_tab d, user_objects o
         WHERE d.package_name = o.object_name
         AND   o.object_type = 'PACKAGE BODY'
           AND TO_DATE(o.timestamp,'RRRR-MM-DD:HH24:MI:SS') > last_updated_;

      TYPE state_array IS TABLE OF get_state_events_%ROWTYPE INDEX BY BINARY_INTEGER;
      state_list_      state_array;

      TYPE state_trans_array IS TABLE OF dictionary_sys_state_trans_tab%ROWTYPE INDEX BY BINARY_INTEGER;
      state_trans_values_  state_trans_array;

      FUNCTION Get_Allowed_State_Trans (
                                         pkg_name_ VARCHAR2,
                                         state_ VARCHAR2)
         RETURN VARCHAR2
         IS
         stmt_    VARCHAR2(200);
         events_  VARCHAR2(200);
      BEGIN
--         Assert_SYS.Assert_Is_Package(pkg_name_);
         stmt_:='BEGIN :events:='||pkg_name_||'.Finite_State_Events__(:state); END;';
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE stmt_ USING IN OUT   events_, state_ ;
         RETURN events_;
      EXCEPTION
         WHEN OTHERS THEN
            Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(Get_Logical_Unit(pkg_name_, 'PACKAGE')),6)||':Failed to fetch events for package '||pkg_name_||' and state '||state_);
            RETURN NULL;
      END Get_Allowed_State_Trans;

   BEGIN

      IF full_mode_ THEN
         last_updated_:= SYSDATE-1000;
      ELSE
         SELECT NVL(MAX(to_date(timestamp, 'RRRR-MM-DD:HH24:MI:SS')),SYSDATE-1000) INTO last_updated_
            FROM dictionary_sys_state_tab d, user_objects o
            WHERE d.package_name = o.object_name
            AND o.object_type = 'PACKAGE BODY';
      END IF;

      OPEN get_state_events_;
      FETCH get_state_events_ BULK COLLECT INTO state_list_;
      IF SQL%NOTFOUND THEN
         Write_Error_Text___ (error_text_, '   No state transitions found.');
         CLOSE get_state_events_;
         RETURN;
      ELSE
         BEGIN
            IF developer_mode_ THEN
               @ApproveDynamicStatement(2006-02-15,pemase)
               EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_state_trans_tab';
            ELSE
               DELETE FROM dictionary_sys_state_trans_tab;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Write_Error_Text___ (error_text_, '   Failed to truncate dictionary_sys_state_trans_tab.');
               Write_Error_Text___ (error_text_, '   '||dbms_utility.format_error_backtrace);
               RETURN;
         END;
      END IF;
      CLOSE get_state_events_;
      counter_:=1;
      FOR i IN Nvl(state_list_.FIRST,0)..Nvl(state_list_.LAST,-1) LOOP
         state_trans_:=Get_Allowed_State_Trans(state_list_(i).package_name, state_list_(i).db_state);
         match_:=1;
         LOOP
            allowed_event_:=REGEXP_SUBSTR(state_trans_,'([[:alpha:]|[:digit:]|[:blank:]]+\^)', 1, match_);
            EXIT WHEN allowed_event_ IS NULL;
            state_trans_values_(counter_).lu_name:=state_list_(i).lu_name;
            state_trans_values_(counter_).package_name:=state_list_(i).package_name;
            state_trans_values_(counter_).state:=state_list_(i).db_state;
            state_trans_values_(counter_).allowed_event:=substr(allowed_event_,1,length(allowed_event_)-1);
            state_trans_values_(counter_).rowversion:=SYSDATE;
            match_:=match_+1;
            counter_:=counter_+1;
         END LOOP;
      END LOOP;

      BEGIN
         Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
         Write_Error_Text___ (error_text_, '   Dictionary Cache is being updated with '||state_trans_values_.count ||' State Transition(s)');
         Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
         FORALL j IN Nvl(state_trans_values_.FIRST,0)..Nvl(state_trans_values_.LAST,-1) SAVE EXCEPTIONS
            INSERT INTO dictionary_sys_state_trans_tab VALUES state_trans_values_(j);
      EXCEPTION
         WHEN bulk_errors THEN
            error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
            Write_Error_Text___ (error_text_, '   '||to_char(error_count_)||' problem(s) when inserting dictionary state transition information.');
            FOR i IN 1..error_count_ LOOP
               position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
--               Write_Error_Text___ (error_text_, '   Position number '||to_char(position_));
               Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(state_trans_values_(position_).lu_name),6)||':Error ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)||', ', FALSE);
               Write_Error_Text___ (error_text_, 'lu_name='||nvl(state_trans_values_(position_).lu_name, 'NULL')||', ', FALSE);
               Write_Error_Text___ (error_text_, 'package_name='||nvl(state_trans_values_(position_).package_name, 'NULL')||', ', FALSE);
               Write_Error_Text___ (error_text_, 'state='||nvl(state_trans_values_(position_).state, 'NULL')||', ', FALSE);
               Write_Error_Text___ (error_text_, 'allowed_event='||nvl(state_trans_values_(position_).allowed_event, 'NULL'));
            END LOOP;
      END;

   EXCEPTION
      WHEN OTHERS THEN
         Write_Error_Text___ (error_text_, '   Failed to rebuild dictionary_sys_state_trans_tab.');
         Write_Error_Text___ (error_text_, '   '||dbms_utility.format_error_backtrace);
   END Rebuild_State_Transitions___;

   PROCEDURE Tokenize_Lists___ (
      value_list_ IN VARCHAR2,
      values_     OUT domain_states_array )
   IS
      i_        NUMBER      := 0;
      pos_      NUMBER      := 1;
      end_pos_  NUMBER      := 1;
      sep_      VARCHAR2(1) := Client_SYS.text_separator_;
      len_      NUMBER      := length(value_list_);
   BEGIN
      values_.DELETE;
      end_pos_ := instr(value_list_, sep_, 1, i_ + 1);
      WHILE end_pos_ <= len_ AND end_pos_ != 0 LOOP
         BEGIN
            values_(i_) := substr(value_list_, pos_, end_pos_ - pos_);
         EXCEPTION
            WHEN value_error THEN
               values_(i_) := 'ERROR!!!';
         END;
         pos_ := end_pos_ + 1;
         i_ := i_ + 1;
         end_pos_ := instr(value_list_, sep_, 1, i_ + 1);
      END LOOP;
   END Tokenize_Lists___;

   PROCEDURE Insert_Package_Information___ (
      lu_name_      IN VARCHAR2,
      module_       IN VARCHAR2,
      package_name_ IN VARCHAR2,
      lu_type_      IN VARCHAR2,
      lu_sub_type_  IN VARCHAR2 )
   IS
      package_index_ NUMBER;
   BEGIN
      BEGIN
         UPDATE dictionary_sys_tab
            SET rowversion = SYSDATE,
                module = module_,
                lu_type = lu_type_
            WHERE lu_name = lu_name_;
         IF SQL%NOTFOUND THEN
            INSERT INTO dictionary_sys_tab
               (lu_name, module, lu_type, rowversion)
            VALUES
               (lu_name_, module_, lu_type_, SYSDATE);
         END IF;
         IF length(lu_name_) > 25 THEN
            Write_Error_Text___ (error_text_, '   '||rpad(module_,6)||':LU Name '||nvl(lu_name_, 'NULL')||' is longer than 25 characters, this is not allowed.');
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            Write_Error_Text___ (error_text_, '   '||rpad(module_,6)||':Undefined problem when inserting LU dictionary information for package. ', FALSE);
            Write_Error_Text___ (error_text_, 'LU Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
            Write_Error_Text___ (error_text_, 'LU Type='||nvl(lu_type_, 'NULL'));
      END;
      -- Insert and if already existing then update.
      -- This is more efficient when performing a full refresh!
      BEGIN
         Get_Next_Pkg_Index___(lu_name_, package_index_);
         IF length(package_name_) > MAX_DICT_IDENTIFER_LENGTH THEN
            Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Name of package, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
            Write_Error_Text___ (error_text_, '   LU Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
            Write_Error_Text___ (error_text_, '   Package Name='||nvl(package_name_, 'NULL')||', ', FALSE);
            Write_Error_Text___ (error_text_, '   Package Index='||nvl(to_char(pkg_index_), 'NULL')||', ', FALSE);
            Write_Error_Text___ (error_text_, '   Package Type='||nvl(lu_sub_type_, 'NULL'));           
         ELSE
            INSERT INTO dictionary_sys_package_tab
               (lu_name, package_name, package_index, package_type, rowversion)
            VALUES
               (lu_name_, package_name_, package_index_, lu_sub_type_, SYSDATE);
         END IF;
      EXCEPTION
         WHEN dup_val_on_index THEN
            UPDATE dictionary_sys_package_tab
               SET rowversion = SYSDATE
               WHERE lu_name = lu_name_
               AND   package_name = package_name_;             
            WHEN OTHERS THEN
               -- Current Limitation.
               -- We only allow longer package names for _SVC, _JSN and _TLM packages(Aurena). These are ignored 
               IF SUBSTR(package_name_, -4) NOT IN ('_SVC', '_JSN', '_TLM') THEN
                  IF length(package_name_) > MAX_DICT_IDENTIFER_LENGTH THEN
                     Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Name of package, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
                  ELSE
                     Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Undefined problem when inserting dictionary information for package. ', FALSE);
                  END IF;
                  Write_Error_Text___ (error_text_, '   LU Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, '   Package Name='||nvl(package_name_, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, '   Package Index='||nvl(to_char(pkg_index_), 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, '   Package Type='||nvl(lu_sub_type_, 'NULL'));
               END IF;          
      END;
   END Insert_Package_Information___;

   PROCEDURE Insert_View_Information___(
      lu_name_      IN VARCHAR2,
      module_       IN VARCHAR2,
      base_package_name_ IN VARCHAR2,
      view_name_    IN VARCHAR2,
      view_prompt_  IN VARCHAR2,
      server_only_  IN VARCHAR2,
      validity_mode_ IN VARCHAR2,
      view_comment_ IN VARCHAR2,
      table_name_   IN VARCHAR2 DEFAULT NULL,
      objversion_   IN VARCHAR2 DEFAULT NULL,
      objstate_     IN VARCHAR2 DEFAULT NULL,
      objid_        IN VARCHAR2 DEFAULT NULL,
      objkey_       IN VARCHAR2 DEFAULT NULL,
      refbase_      IN VARCHAR2 DEFAULT NULL,
      basedon_      IN VARCHAR2 DEFAULT NULL,
      basedonfilter_ IN VARCHAR2 DEFAULT NULL,
      row_level_security_filter_ IN VARCHAR2 DEFAULT NULL)
   IS
      base_view_  BOOLEAN := FALSE;
      view_index_ NUMBER;
      view_type_  VARCHAR2(1);
      lu_prompt_  VARCHAR2(200);
      db_name_    VARCHAR2(ORA_MAX_NAME_LEN);
      ok_         BOOLEAN := TRUE;
   BEGIN
      -- Find the base view according to naming conventions...
      -- (Other possible base views are handled at the end of the process)
      DECLARE
         error EXCEPTION;
         PRAGMA exception_init(error,-20105); 
      BEGIN
         db_name_ := Clientnametodbname_(lu_name_);
      EXCEPTION
         WHEN error THEN
            db_name_ := NULL;
      END;
      IF ((view_name_ =  db_name_) OR
          (table_name_ IS NOT NULL) OR (objversion_ IS NOT NULL) OR (objid_ IS NOT NULL) OR (objkey_ IS NOT NULL) OR (refbase_ IS NOT NULL)) THEN
         IF (substr(view_name_, -4) = '_REP') THEN
            lu_prompt_ := NULL;
            base_view_ := FALSE;
         ELSIF (substr(view_name_, -4) = '_CFV') THEN --Custom Fields view is not a base view
            lu_prompt_ := view_prompt_;
            base_view_ := FALSE;
         ELSIF (substr(view_name_, -4) = '_ICV') THEN --Information Cards view is not a base view
            lu_prompt_ := view_prompt_;
            base_view_ := FALSE;
         ELSE
            lu_prompt_ := view_prompt_;
            base_view_ := TRUE;
         END IF;
      ELSE
         lu_prompt_ := NULL;
         base_view_ := FALSE;
      END IF;
      
      
      -- Insert into dictionary_sys_tab. It is likely this entry already exist (from package information),
      -- then only updating the prompt and rowversion is more efficent.
      BEGIN
         IF base_view_ THEN
            UPDATE dictionary_sys_tab
               SET rowversion = SYSDATE,
                   lu_prompt = lu_prompt_,
                   table_name = table_name_,
                   base_package = base_package_name_,
                   objversion = objversion_,
                   objstate = objstate_,
                   objid = objid_,
                   objkey = objkey_,
                   refbase = refbase_,
                   based_on = basedon_,
                   based_on_filter = basedonfilter_
               WHERE lu_name = lu_name_;
            IF SQL%NOTFOUND THEN
               INSERT INTO dictionary_sys_tab
               (lu_name, module, lu_prompt, table_name, base_package, objversion, objstate, objid, refbase, based_on, based_on_filter, rowversion)
               VALUES
               (lu_name_, module_, lu_prompt_, table_name_, base_package_name_, objversion_, objstate_, objid_, refbase_, basedon_, basedonfilter_, SYSDATE);
            END IF;
         ELSE
            UPDATE dictionary_sys_tab
               SET rowversion = SYSDATE
               WHERE lu_name = lu_name_;
            IF SQL%NOTFOUND THEN
               INSERT INTO dictionary_sys_tab
                  (lu_name, module, rowversion)
               VALUES
                  (lu_name_, module_, SYSDATE);
            END IF;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            ok_ := FALSE;
            IF SQLCODE = -12899 AND length(view_name_) > MAX_DICT_IDENTIFER_LENGTH THEN
               Write_Error_Text___ (error_text_, Rpad(module_,6)||':Name of view, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed limit is '||MAX_DICT_IDENTIFER_LENGTH||' characters. ', FALSE);
            ELSE
               Write_Error_Text___ (error_text_, Rpad(module_,6)||':Undefined problem when inserting dictionary information for view added or modified before this refresh. ', FALSE);
            END IF;
            Write_Error_Text___ (error_text_, '   LU Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
            Write_Error_Text___ (error_text_, '   View Name='||nvl(view_name_, 'NULL')||', ', FALSE);
            Write_Error_Text___ (error_text_, '   View Prompt='||nvl(view_prompt_, 'NULL')||', ', FALSE);
            Write_Error_Text___ (error_text_, '   View Index='||nvl(to_char(view_index_), 'NULL')||', ');
      END;
      -- Insert into dictionary_sys_view_tab
      -- Insert and if already existing then update.
      -- This is more efficient when performing a full refresh!
      IF ok_ THEN
         BEGIN
            Get_Next_View_Index___(lu_name_, view_index_);
            IF base_view_ THEN
               view_type_ := 'B';
            ELSIF substr(view_name_, -4) = '_REP' THEN
               view_type_ := 'R';
            ELSE
               IF server_only_ = 'TRUE' THEN
                  view_type_ := 'S';
                  -- Remove any column information
                  DELETE FROM dictionary_sys_view_column_tab c
                  WHERE view_name = view_name_;
               ELSE
                  view_type_ := 'A';
               END IF;
            END IF;
            INSERT INTO dictionary_sys_view_tab
               (lu_name, view_name, view_type, view_prompt, view_index, server_only, validity_mode, view_comment, row_level_security, rowversion)
            VALUES
               (lu_name_, view_name_, view_type_, view_prompt_, view_index_, server_only_, validity_mode_, view_comment_, row_level_security_filter_, SYSDATE);
         EXCEPTION
            WHEN dup_val_on_index THEN
               UPDATE dictionary_sys_view_tab
                  SET view_type = view_type_,
                      view_prompt = view_prompt_,
                      server_only = server_only_,
                      validity_mode = validity_mode_,
                      view_comment = view_comment_,
                      row_level_security = row_level_security_filter_,
                      rowversion = SYSDATE
                  WHERE lu_name = lu_name_
                  AND view_name = view_name_;
         END;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         IF SQLCODE = -12899 AND length(view_name_) > MAX_DICT_IDENTIFER_LENGTH THEN
            Write_Error_Text___ (error_text_, Rpad(module_,6)||':Name of view, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed limit is '||MAX_DICT_IDENTIFER_LENGTH||' characters. ', FALSE);
         ELSE
            Write_Error_Text___ (error_text_, Rpad(module_,6)||':Undefined problem when inserting dictionary information for a view added or modified before this refresh. ', FALSE);
         END IF;
         Write_Error_Text___ (error_text_, '   LU Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
         Write_Error_Text___ (error_text_, '   View Name='||nvl(view_name_, 'NULL')||', ', FALSE);
         Write_Error_Text___ (error_text_, '   View Prompt='||nvl(view_prompt_, 'NULL')||', ', FALSE);
         Write_Error_Text___ (error_text_, '   View Index='||nvl(to_char(view_index_), 'NULL')||', ');
   END Insert_View_Information___;

   PROCEDURE Refresh_View_Columns___ (
      view_name_  IN VARCHAR2,
      lu_name_    IN VARCHAR2 )
   IS
      CURSOR get_known_view_columns IS
         SELECT table_name view_name, column_name column_name, comments comments, column_id column_id
         FROM   fnd_col_comments
         WHERE  table_name = view_name_
         ORDER BY column_name;

      column_flags_ VARCHAR2(100);
      n_            NUMBER := 1;
      position_     NUMBER;
      error_count_  NUMBER;
      bulk_errors   EXCEPTION;
      sql_code_     NUMBER;
      PRAGMA EXCEPTION_INIT(bulk_errors, -24381);

      TYPE view_column_array IS TABLE OF get_known_view_columns%ROWTYPE INDEX BY BINARY_INTEGER;
      view_columns_ view_column_array;
    
      TYPE complete_array IS TABLE OF dictionary_sys_view_column_tab%ROWTYPE INDEX BY BINARY_INTEGER;
      complete_columns_ complete_array;
   BEGIN
      --
      -- Fetch view column information and delete old information
      --
      OPEN get_known_view_columns;
      FETCH get_known_view_columns BULK COLLECT INTO view_columns_;
      CLOSE get_known_view_columns;
      -- Remove old information for all of the methods that is being updated
      DELETE FROM dictionary_sys_view_column_tab c
      WHERE view_name = view_name_;

      -- Process all of the view column information
      IF view_columns_.COUNT > 0 THEN
         FOR i IN 1..view_columns_.COUNT LOOP
            IF lu_name_ IS NOT NULL THEN
               BEGIN
                  IF LENGTH(view_columns_(i).column_name) <= MAX_DICT_IDENTIFER_LENGTH THEN
                     complete_columns_(n_).lu_name          := lu_name_;
                     complete_columns_(n_).view_name        := view_columns_(i).view_name;
                     complete_columns_(n_).column_name      := view_columns_(i).column_name;
                     complete_columns_(n_).column_index     := view_columns_(i).column_id;
                     complete_columns_(n_).rowversion       := SYSDATE;
                     complete_columns_(n_).column_datatype  := Comment_Value_('DATATYPE',view_columns_(i).comments);
                     complete_columns_(n_).column_reference := Comment_Value_('REF',view_columns_(i).comments);
                     complete_columns_(n_).enumeration      := Comment_Value_('ENUMERATION',view_columns_(i).comments);
                     complete_columns_(n_).lookup           := Comment_Value_('LOOKUP',view_columns_(i).comments);
                     complete_columns_(n_).column_prompt    := Comment_Value_('PROMPT',view_columns_(i).comments);
                     complete_columns_(n_).table_column_name:= Comment_Value_Regexp_('COLUMN',view_columns_(i).comments);
                     column_flags_                          := Comment_Value_('FLAGS',view_columns_(i).comments);
                     complete_columns_(n_).type_flag        := substr(column_flags_,1,1);
                     complete_columns_(n_).required_flag    := substr(column_flags_,2,1);
                     complete_columns_(n_).insert_flag      := substr(column_flags_,3,1);
                     complete_columns_(n_).update_flag      := substr(column_flags_,4,1);
                     complete_columns_(n_).lov_flag         := substr(column_flags_,5,1);
                     complete_columns_(n_).column_comment   := view_columns_(i).comments;
                     complete_columns_(n_).row_level_security   := Comment_Value_(COLUMN_ROW_LEVEL_SECURITY_COMMENT, view_columns_(i).comments);
                     n_ := n_ + 1;
                  ELSE
                     Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||': Error : Name of view column, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
                     Write_Error_Text___ (error_text_, '   Lu Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
                     Write_Error_Text___ (error_text_, '   View Name='||nvl(view_columns_(i).view_name, 'NULL')||', ', FALSE);
                     Write_Error_Text___ (error_text_, '   Column Name='||nvl(view_columns_(i).column_name, 'NULL'));                   
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     Write_Error_Text___ (error_text_, '   ??????:Incorrect comments for view column '||view_columns_(i).view_name||'.'||view_columns_(i).column_name);
                     complete_columns_(n_).column_datatype  := NULL;
                     complete_columns_(n_).enumeration      := NULL;
                     complete_columns_(n_).lookup           := NULL;
                     complete_columns_(n_).column_prompt    := NULL;
                     complete_columns_(n_).column_reference := NULL;
                     complete_columns_(n_).table_column_name:= NULL;
                     complete_columns_(n_).type_flag        := NULL;
                     complete_columns_(n_).required_flag    := NULL;
                     complete_columns_(n_).insert_flag      := NULL;
                     complete_columns_(n_).update_flag      := NULL;
                     complete_columns_(n_).lov_flag         := NULL;
                     complete_columns_(n_).column_comment   := NULL;
                     complete_columns_(n_).row_level_security := NULL;
               END;
            END IF;
         END LOOP;

         -- Insert all the values into dictionary_sys_view_column_tab
         BEGIN
            FORALL j IN 1..complete_columns_.COUNT SAVE EXCEPTIONS
               INSERT INTO dictionary_sys_view_column_tab VALUES complete_columns_(j);
         EXCEPTION
            WHEN bulk_errors THEN
               error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
               Write_Error_Text___ (error_text_, to_char(error_count_)||' problem(s) when inserting dictionary view column information!');
               FOR i IN 1..error_count_ LOOP
                  position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
                  sql_code_ := -SQL%BULK_EXCEPTIONS(i).ERROR_CODE;
                  IF sql_code_ = -12899 AND length(complete_columns_(position_).column_name) > MAX_DICT_IDENTIFER_LENGTH THEN
                     Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||': Error : Name of view column, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
                  ELSE
                     Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(complete_columns_(position_).lu_name),6)||':Error ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)||', ', FALSE);
                  END IF;
                  Write_Error_Text___ (error_text_, '   Lu Name='||nvl(complete_columns_(position_).lu_name, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, '   View Name='||nvl(complete_columns_(position_).view_name, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, '   Column Name='||nvl(complete_columns_(position_).column_name, 'NULL'));
               END LOOP;
         END;
      END IF;
   END Refresh_View_Columns___;

   -- Handles both domain and state information, behaves different depending on info_type
   PROCEDURE Refresh_Domain_State_Info___ (
      info_type_    IN VARCHAR2,
      lu_name_      IN VARCHAR2,
      package_name_ IN VARCHAR2,
      lu_type_      IN VARCHAR2 )
   IS
      list_db_values_      VARCHAR2(32000);
      list_client_values_  VARCHAR2(32000);
      refresh_domain_      BOOLEAN := info_type_ = 'domain';
      position_            NUMBER;
      error_count_         NUMBER;
      bulk_errors          EXCEPTION;
      PRAGMA EXCEPTION_INIT(bulk_errors, -24381);
   BEGIN
      IF refresh_domain_ THEN
         DELETE FROM dictionary_sys_domain_tab
            WHERE lu_name = lu_name_
            AND package_name = package_name_;
      ELSE
         DELETE FROM dictionary_sys_state_tab
            WHERE lu_name = lu_name_
            AND package_name = package_name_;
      END IF;

      -- Clear variables
      db_values_.DELETE;
      client_values_.DELETE;
      complete_values_.DELETE;
--      Assert_SYS.Assert_Is_Package(package_name_);
      IF refresh_domain_ THEN
         IF lu_type_ = 'Enumeration' THEN
            DECLARE
               stmt_                VARCHAR2(32000);
            BEGIN
--               Assert_SYS.Assert_Is_Package(package_name_);
--               Assert_SYS.Assert_Is_Logical_Unit(lu_name_);
               stmt_ := 'BEGIN '||
                        '   IF ('||package_name_||'.lu_type_ = ''Enumeration'') THEN '||
                        '       '||package_name_||'.Init; '||
                        '       :db_values_     := Domain_SYS.Get_Db_Values('''||lu_name_||''');'||
                        '       :client_values_ := Domain_SYS.Get_Prog_Values('''||lu_name_||''');'||
                        '   END IF;'||
                        'END;';
               @ApproveDynamicStatement(2011-05-30,haarse)
               EXECUTE IMMEDIATE stmt_ USING OUT list_db_values_, OUT list_client_values_;
            EXCEPTION
               WHEN OTHERS THEN
                  Write_Error_Text___ (error_text_, '   Problem(s) when retreiving Db_values and client_values for '||info_type_||' package '||package_name_||'!');
            END;
         END IF;
      ELSE
         IF lu_type_ = 'EntityWithState' THEN
            DECLARE
               stmt_                VARCHAR2(32000);
            BEGIN
--               Assert_SYS.Assert_Is_Package(package_name_);
--               Assert_SYS.Assert_Is_Logical_Unit(lu_name_);
               stmt_ := 'BEGIN '||
                        '   IF ('||package_name_||'.lu_type_ = ''EntityWithState'') THEN '||
                        '      '||package_name_||'.Init; '||
                        '       :db_values_     := Domain_SYS.Get_Db_Values('''||lu_name_||''');'||
                        '       :client_values_ := Domain_SYS.Get_Prog_Values('''||lu_name_||''');'||
                        '   END IF;'||
                        'END;';
               @ApproveDynamicStatement(2011-05-30,haarse)
               EXECUTE IMMEDIATE stmt_ USING OUT list_db_values_, OUT list_client_values_;
            EXCEPTION
               WHEN OTHERS THEN
                  Write_Error_Text___ (error_text_, '   Problem(s) when retreiving Db_values and Client_values for '||info_type_||' package '||package_name_||'!');
            END;
         END IF;
         -- Get state events
         -- translate db values to an PL/SQL collection

      END IF;
      -- Break down the list into single values in an array
      Tokenize_Lists___(list_db_values_, db_values_);
      Tokenize_Lists___(list_client_values_, client_values_);

      IF db_values_.count > 0 THEN
         -- Fill the result array with the rest of the necessary information
         Fill_List_Array___(info_type_, lu_name_, package_name_, db_values_, client_values_, complete_values_);

         -- Insert all of the values into dictionary_sys_domain_tab
         BEGIN
            IF refresh_domain_ THEN
               FORALL j IN Nvl(complete_values_.FIRST,0)..Nvl(complete_values_.LAST,-1) SAVE EXCEPTIONS
                  INSERT INTO dictionary_sys_domain_tab VALUES complete_values_(j);
            ELSE
               FORALL j IN Nvl(complete_values_.FIRST,0)..Nvl(complete_values_.LAST,-1) SAVE EXCEPTIONS
                  INSERT INTO dictionary_sys_state_tab VALUES complete_values_(j);
            END IF;
         EXCEPTION
            WHEN bulk_errors THEN
               error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
               Write_Error_Text___ (error_text_, '   '||to_char(error_count_)||' problem(s) when inserting dictionary information for '||info_type_||' package '||package_name_||'!');
               FOR i IN 1..error_count_ LOOP
                  position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX - 1;
--                  Write_Error_Text___ (error_text_, '   Position number '||to_char(position_));
                  Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Error ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Db Value='||nvl(complete_values_(position_).db_value, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Client Value='||nvl(complete_values_(position_).client_value, 'NULL'));
               END LOOP;
         END;
      END IF;
   END Refresh_Domain_State_Info___;
   
   PROCEDURE Refresh_Methods___ (
      package_name_ IN VARCHAR2,
      lu_type_      IN VARCHAR2,
      lu_name_      IN VARCHAR2 )
   IS
      CURSOR get_pkg_methods IS
         SELECT p.object_name pkg, p.procedure_name met, NVL(p.overload, '0') ovrld, p.object_id
         FROM  user_procedures p
         WHERE substr(object_name, -4) IN ('_API', '_CFP', '_ICP', '_CLP', '_RPI', '_SYS', '_SCH', '_APN') -- Do not include SVC and CPI methods in normal dictionary
         AND   procedure_name IS NOT NULL
         AND   object_name = package_name_;

      CURSOR get_pkg_pragma_methods IS
         SELECT Name pkg, upper(rtrim(ltrim(Utility_SYS.Between_Str(text, '(', ')', 'FALSE')))) met
         FROM  user_source us
         WHERE type = 'PACKAGE'
         AND   text LIKE '--@PoReadOnly%'
         AND   Name = package_name_
         AND NOT EXISTS
         (SELECT 1
          FROM User_Errors
          WHERE type = us.type
          AND name = us.name);
      
      n_                NUMBER := 1;
      position_         NUMBER;
      error_count_      NUMBER;
      bulk_errors       EXCEPTION;
      sys_date_         DATE;
      PRAGMA EXCEPTION_INIT(bulk_errors, -24381);

      TYPE method_array IS TABLE OF get_pkg_methods%ROWTYPE INDEX BY BINARY_INTEGER;
      methods_ method_array;
      
      TYPE po_read_only_array IS TABLE OF get_pkg_pragma_methods%ROWTYPE INDEX BY BINARY_INTEGER;
      pragma_methods_ po_read_only_array;
      
      TYPE complete_array IS TABLE OF dictionary_sys_method_tab%ROWTYPE INDEX BY BINARY_INTEGER;
      complete_methods_ complete_array;
      
      TYPE functions_array IS TABLE OF get_pkg_methods%ROWTYPE INDEX BY BINARY_INTEGER;
      functions_ functions_array;
      
   BEGIN
      --
      -- Fetch method information and delete old information
      -- 
      OPEN get_pkg_methods;
      FETCH get_pkg_methods BULK COLLECT INTO methods_;
      CLOSE get_pkg_methods;
      -- Remove old information for all of the methods that is being updated
      DELETE FROM dictionary_sys_method_tab m
      WHERE package_name = package_name_;
      
      DELETE FROM dictionary_sys_method_ext_tab
      WHERE object_name = package_name_;
      --
      -- Process method information
      --
      IF methods_.COUNT > 0 THEN
         FOR i IN 1..methods_.COUNT LOOP
            IF lu_name_ IS NOT NULL THEN
               IF length(methods_(i).pkg) <= MAX_DICT_IDENTIFER_LENGTH THEN
                     method_ := replace(initcap(replace(methods_(i).met,'_',' ')),' ','_');
                     -- Ignoring method overloads for dictionary_sys_method_tab
                     IF methods_(i).ovrld IN ('0', '1') THEN 
                        -- Insert the values into the complete array
                        IF length(method_) <= MAX_DICT_IDENTIFER_LENGTH THEN
                           complete_methods_(n_).lu_name      := lu_name_;
                           complete_methods_(n_).package_name := methods_(i).pkg;
                           complete_methods_(n_).method_name  := method_;
                           complete_methods_(n_).method_type  := 'N';
                           complete_methods_(n_).rowversion   := SYSDATE;
                           n_ := n_ + 1;
                        ELSE
                           Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Error : Name of method, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
                           Write_Error_Text___ (error_text_, '   Lu Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
                           Write_Error_Text___ (error_text_, '   Package Name='||nvl(methods_(i).pkg, 'NULL')||', ', FALSE);
                           Write_Error_Text___ (error_text_, '   Method Name='||nvl(method_, 'NULL'));
                        END IF;
                     END IF;
                  ELSE
                     Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Error : Method, added or modified before this refresh, ignored as package name is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
                     Write_Error_Text___ (error_text_, '   Lu Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
                     Write_Error_Text___ (error_text_, '   Package Name='||nvl(methods_(i).pkg, 'NULL')||', ', FALSE);
                     Write_Error_Text___ (error_text_, '   Method Name='||nvl(method_, 'NULL'));
                  END IF;
            END IF;
         END LOOP;

         -- Insert all the values into dictionary_sys_method_tab
         BEGIN
            FORALL j IN 1..complete_methods_.COUNT SAVE EXCEPTIONS
               INSERT INTO dictionary_sys_method_tab VALUES complete_methods_(j);               
         EXCEPTION
            WHEN bulk_errors THEN
               error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
               Write_Error_Text___ (error_text_, '   '||to_char(error_count_)||' problem(s) when inserting dictionary method information!');
               FOR i IN 1..error_count_ LOOP
                  position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
                  Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(complete_methods_(position_).lu_name),6)||':Error ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Lu Name='||nvl(complete_methods_(position_).lu_name, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Package Name='||nvl(complete_methods_(position_).package_name, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Method Name='||nvl(complete_methods_(position_).method_name, 'NULL'));
               END LOOP;
         END;
          -- Inserting extended method information to dictionary_sys_method_ext_tab  
         BEGIN
            sys_date_ := sysdate;
            -- Temporary set both procedures and function method_type to PROCEDURE. 
            FORALL j IN 1..methods_.COUNT SAVE EXCEPTIONS
               INSERT INTO dictionary_sys_method_ext_tab
                  (lu_name, object_name, procedure_name, overload, method_type, rowversion)
               VALUES 
                  (lu_name_, methods_(j).pkg, methods_(j).met, methods_(j).ovrld, 'PROCEDURE', sys_date_);
            
            -- Getting functions from user_arguments, position = 0 means the return type.
            SELECT package_name pkg, object_name met, NVL(overload, '0') ovrld, object_id
            BULK COLLECT INTO functions_
            FROM user_arguments 
            WHERE object_id = methods_(1).object_id
            AND position = 0;

            -- Set method_type = FUNCTION which are identified by the above select
            FORALL j IN 1..functions_.COUNT SAVE EXCEPTIONS
            UPDATE dictionary_sys_method_ext_tab
            SET method_type = 'FUNCTION'
            WHERE object_name = functions_(1).pkg
            AND procedure_name = functions_(j).met
            AND overload = functions_(j).ovrld;
         EXCEPTION
            WHEN bulk_errors THEN
               error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
               Write_Error_Text___ (error_text_, '   '||to_char(error_count_)||' problem(s) when inserting dictionary method extended information!');
               FOR i IN 1..error_count_ LOOP
                  position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
                  Write_Error_Text___ (error_text_, '   '||Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Error ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Lu Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Package Name='||nvl(methods_(position_).pkg, 'NULL')||', ', FALSE);
                  Write_Error_Text___ (error_text_, 'Method Name='||nvl(methods_(position_).met, 'NULL'));
               END LOOP;
         END;
            
      END IF;
       
      -- Clear arrays
      methods_.DELETE;
      complete_methods_.DELETE;
      
      --
      -- Fetch pragma method information
      --
      OPEN get_pkg_pragma_methods;
      FETCH get_pkg_pragma_methods BULK COLLECT INTO pragma_methods_;
      CLOSE get_pkg_pragma_methods;
      --
      -- Process pragma method information
      --
      IF pragma_methods_.COUNT > 0 THEN
         FOR i IN Nvl(pragma_methods_.FIRST,0)..Nvl(pragma_methods_.LAST,-1) LOOP
            IF lu_name_ IS NOT NULL THEN
               method_ := replace(initcap(replace(pragma_methods_(i).met,'_',' ')),' ','_');
               -- Update the record in dictionary_sys_method_tab
               BEGIN
                     UPDATE dictionary_sys_method_tab
                        SET method_type = 'P',
                            rowversion = SYSDATE
                        WHERE lu_name = lu_name_
                     AND   package_name = pragma_methods_(i).pkg
                        AND   method_name = method_;
                     IF SQL%NOTFOUND THEN
                        IF length(method_) <= MAX_DICT_IDENTIFER_LENGTH THEN
                           INSERT INTO dictionary_sys_method_tab
                              (lu_name, package_name, method_name, method_type, rowversion)
                           VALUES
                           (lu_name_, pragma_methods_(i).pkg, method_, 'P', SYSDATE);
                        ELSE
                           Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||': Error : Name of PRAGMA-method, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
                           Write_Error_Text___ (error_text_, '   Lu Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
                        Write_Error_Text___ (error_text_, '   Package Name='||nvl(pragma_methods_(i).pkg, 'NULL')||', ', FALSE);
                           Write_Error_Text___ (error_text_, '   Method Name='||nvl(method_, 'NULL'));               
                        END IF;
                     END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     IF SQLCODE = -12899 AND length(method_) > MAX_DICT_IDENTIFER_LENGTH THEN
                        Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||': Error : Name of PRAGMA-method, added or modified before this refresh, is longer than the allowed limit in the IFS Dictionary. Maximum allowed is '||MAX_DICT_IDENTIFER_LENGTH||' characters.', FALSE);
                     ELSE
                        Write_Error_Text___ (error_text_, Rpad(Get_Logical_Unit_Module(lu_name_),6)||':Undefined problem when inserting dictionary information for PRAGMA-method. ', FALSE);
                     END IF;
                     Write_Error_Text___ (error_text_, '   Lu Name='||nvl(lu_name_, 'NULL')||', ', FALSE);
                     Write_Error_Text___ (error_text_, '   Package Name='||nvl(pragma_methods_(i).pkg, 'NULL')||', ', FALSE);
                     Write_Error_Text___ (error_text_, '   Method Name='||nvl(method_, 'NULL'));
               END;
               -- Fetch and insert state information if current package contains a state machine
            END IF;
         END LOOP;
         IF lu_type_ = 'EntityWithState' THEN
            IF (refresh_mode_ != 'LIGHT') THEN
               Refresh_Domain_State_Info___('state', lu_name_, package_name_, lu_type_);
            END IF;
         END IF;
      END IF;
      --
      -- Update special handled methods to PRAGMA (Read-only) methods
      --
      /*
      UPDATE dictionary_sys_method_tab t
         SET method_type = 'P'
       WHERE upper(t.method_name)
          IN ('ENUMERATE',
              'EXIST',
              'EXIST_DB',
              'LOCK__',
              'LANGUAGE_REFRESHED',
              'INIT',
              'FINITE_STATE_DECODE__',
              'FINITE_STATE_ENCODE__',
              'ENUMERATE_STATES__',
              'FINITE_STATE_EVENTS__',
              'ENUMERATE_EVENTS__')
         AND package_name = NVL(package_name_, package_name);
         */
   END Refresh_Methods___;
   
   PROCEDURE Check_Base_View___
   IS
      CURSOR get_base_view IS
         SELECT d.module, d.lu_name
         FROM dictionary_sys_view_tab t, dictionary_sys_tab d
         WHERE t.view_type = 'B'
         AND d.lu_name = t.lu_name
         GROUP BY d.module, d.lu_name
         HAVING count(*) > 1;
      first_ BOOLEAN := TRUE;
   BEGIN
      FOR rec IN get_base_view LOOP
         IF first_ THEN
            Write_Error_Text___ (error_text_, '   ------------------------------------------------------------------');
            Write_Error_Text___ (error_text_, '                   ------   WARNING!!!   ------                      ');
            Write_Error_Text___ (error_text_, '   The Following logical units have more than one base view.');
            Write_Error_Text___ (error_text_, '   Included are also units detected as added or modified before this refresh.');
            Write_Error_Text___ (error_text_, '   This can cause the Dictionary cache refresh to fail.');
            Write_Error_Text___ (error_text_, '   Correct the following and refresh dictionary again.');
            Write_Error_Text___ (error_text_, '   ------------------------------------------------------------------');
            first_ := FALSE;
         END IF;
         Write_Error_Text___ (error_text_, '   '||Rpad(rec.module,6)||':Lu Name='||rec.lu_name, TRUE);
      END LOOP;
   END Check_Base_View___;
BEGIN
   Write_Error_Text___ (error_text_, '-------------------------------------------------------------');
   Write_Error_Text___ (error_text_, 'Dictionary Cache started');
   Write_Error_Text___ (error_text_, '-------------------------------------------------------------');
   --
   -- Validate refresh mode before proceeding
   --
   IF refresh_mode_ IS NULL OR refresh_mode_ NOT IN ('FULL', 'PARTIAL', 'VIEWS', 'PACKAGES', 'LIGHT', 'COMPUTE', 'COMPUTEVIEWS', 'COMPUTEPKGS', 'DEVELOPER') THEN
      Error_SYS.Appl_General(service_, 'INVALIDMODE: Invalid Refresh Mode! Mode should be one of the values [:P1]', 'FULL, PARTIAL, VIEWS, PACKAGES, LIGHT, COMPUTE, COMPUTEVIEWS, COMPUTEPKGS, DEVELOPER');
   END IF;
   --
   -- If a refresh is not necessary and a full refresh is not ordered, abort immediately...
   -- This is more effecient than doing a complete search for packages and views.
   --
   -- In this procedure Dbms_Output should be used instead of Trace_SYS to enable
   -- traces during installation time.
   --
   
   -- From 12.2 onwards the maximum allowed identifier length is 128 Bytes. But we only support 30 Bytes
   --Log_Long_Identifiers____(error_text_);
   
   IF NOT refresh_all_ THEN
      Check_Dictionary_Storage_(rebuild_needed_);
      IF rebuild_needed_ = 0 THEN
         Write_Error_Text___ (error_text_, 'Dictionary Cache is already up-to-date.');
         refresh_pkgs_ := FALSE;
         refresh_views_ := FALSE;
      ELSE

         -- Find last update time
         OPEN get_last_update;
         FETCH get_last_update INTO last_update_;
         CLOSE get_last_update;

         -- Set full refresh mode if no dictionary data exist
         IF last_update_ IS NULL THEN
            refresh_all_ := TRUE;
            refresh_all_pkgs_ := TRUE;
            refresh_all_views_ := TRUE;
         END IF;
      END IF;
   END IF;

   IF refresh_all_ THEN
      Write_Error_Text___ (error_text_, 'Full Refresh of Dictionary Cache!');

      -- Fetch the objects to update
      OPEN get_pkgs_to_update(TO_DATE(NULL));
      FETCH get_pkgs_to_update BULK COLLECT INTO packages_;
      CLOSE get_pkgs_to_update;

      OPEN get_all_views;
      FETCH get_all_views BULK COLLECT INTO views_;
      CLOSE get_all_views;
   ELSE
      IF refresh_pkgs_ THEN
         OPEN get_pkgs_to_update(last_update_);
         FETCH get_pkgs_to_update BULK COLLECT INTO packages_;
         CLOSE get_pkgs_to_update;
      END IF;
      IF refresh_views_ THEN
         OPEN get_views_to_update;
         FETCH get_views_to_update BULK COLLECT INTO views_;
         CLOSE get_views_to_update;
      END IF;
      IF refresh_mode_ LIKE 'COMPUTE%' THEN
         IF refresh_pkgs_ THEN
            OPEN get_qty_all_pkgs;
            FETCH get_qty_all_pkgs INTO qty_pkgs_;
            CLOSE get_qty_all_pkgs;
            IF  qty_pkgs_ > 0 THEN
               IF (packages_.COUNT / qty_pkgs_ > 0.5) THEN
                  refresh_all_pkgs_ := TRUE;
                  Write_Error_Text___ (error_text_, 'Full Refresh of Dictionary Cache for packages!');
               ELSE
                  refresh_all_pkgs_ := FALSE;
                  Write_Error_Text___ (error_text_, 'Partial Refresh of Dictionary Cache for packages!');
               END IF;
            END IF;
         END IF;

         IF refresh_views_ THEN
            OPEN get_qty_all_views;
            FETCH get_qty_all_views INTO qty_views_;
            CLOSE get_qty_all_views;
            IF  qty_views_ > 0 THEN
               IF (views_.COUNT / qty_views_ > 0.5) THEN
                  refresh_all_views_ := TRUE;
                  Write_Error_Text___ (error_text_, 'Full Refresh of Dictionary Cache for views!');
               ELSE
                  refresh_all_views_ := FALSE;
                  Write_Error_Text___ (error_text_, 'Partial Refresh of Dictionary Cache for views!');
               END IF;
            END IF;
         END IF;
      ELSE
      -- Spool information about what "mode" is used
         IF refresh_views_ AND refresh_pkgs_ THEN
            Write_Error_Text___ (error_text_, 'Partial Refresh of Dictionary Cache!');
         ELSIF refresh_pkgs_ THEN
            Write_Error_Text___ (error_text_, 'Partial Refresh of Dictionary Cache only for packages!');
         ELSIF refresh_views_ THEN
            Write_Error_Text___ (error_text_, 'Partial Refresh of Dictionary Cache only for views!');
         END IF;
         Write_Error_Text___ (error_text_, 'Last Update of Dictionary Cache occured at '||to_char(last_update_, 'YYYY-MM-DD HH24:MI:SS'));
      END IF;

      -- Fetch the objects to update
      IF refresh_pkgs_ THEN
         IF refresh_all_pkgs_ THEN
            OPEN get_pkgs_to_update(TO_DATE(NULL));
            FETCH get_pkgs_to_update BULK COLLECT INTO packages_;
            CLOSE get_pkgs_to_update;
         END IF;
      END IF;

      IF refresh_views_ THEN
         IF refresh_all_views_ THEN
            OPEN get_all_views;
            FETCH get_all_views BULK COLLECT INTO views_;
            CLOSE get_all_views;
         END IF;
      END IF;
   END IF;
   --
   -- Refresh package and method information
   --
   IF packages_.COUNT > 0 THEN
      Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
      Write_Error_Text___ (error_text_, '   Dictionary Cache is being updated for '||to_char(packages_.count)||' Package(s)');
      Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
      -- Save start date for package refresh
      -- Remove old information if full refresh
      IF refresh_all_pkgs_ THEN
         IF developer_mode_ THEN
            IF refresh_all_views_ THEN
               @ApproveDynamicStatement(2006-02-15,pemase)
               EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_tab';
            END IF;
            @ApproveDynamicStatement(2006-02-15,pemase)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_package_tab';
            @ApproveDynamicStatement(2016-11-21,mabose)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_method_tab';
            @ApproveDynamicStatement(2020-10-21,kodelk)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_method_ext_tab';
            @ApproveDynamicStatement(2006-02-15,pemase)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_domain_tab';
            @ApproveDynamicStatement(2006-02-15,pemase)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_state_tab';
            @ApproveDynamicStatement(2006-02-15,pemase)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_state_event_tab';
         ELSE
            IF refresh_all_views_ THEN
               DELETE FROM dictionary_sys_tab;
            END IF;
            DELETE FROM dictionary_sys_package_tab;
            DELETE FROM dictionary_sys_method_tab;
            DELETE FROM dictionary_sys_method_ext_tab;
            DELETE FROM dictionary_sys_domain_tab;
            DELETE FROM dictionary_sys_state_tab;
            DELETE FROM dictionary_sys_state_event_tab;
         END IF;
      END IF;

      FOR i IN Nvl(packages_.FIRST,0)..Nvl(packages_.LAST,-1) LOOP
         IF (packages_(i).service IS NOT NULL) THEN
            pkg_lu_type_     := 'S';
            pkg_lu_name_     := packages_(i).service;
         ELSE
            pkg_lu_type_     := 'L';
            pkg_lu_name_     := packages_(i).lu_name;
         END IF;
         
         IF (packages_(i).lu_type = 'Enumeration') THEN
            pkg_lu_sub_type_ := 'D';
         ELSIF  (packages_(i).lu_type = 'EntityWithState') THEN
            pkg_lu_sub_type_ := 'S';
         ELSE
            pkg_lu_sub_type_ := 'N';
         END IF;
         IF pkg_lu_name_ IS NOT NULL AND packages_(i).module IS NOT NULL THEN
            -- Insert the information into the dictionary
            Insert_Package_Information___(pkg_lu_name_,
                                          packages_(i).module,
                                          packages_(i).package_name,
                                          pkg_lu_type_,
                                          pkg_lu_sub_type_);

            -- Refresh domain or state information depending on sub type of the LU (stored in global variable)
            IF pkg_lu_sub_type_ = 'D' THEN
               -- Refresh domain information if this is identified as an IID package
               IF (refresh_mode_ != 'LIGHT') THEN
                  Refresh_Domain_State_Info___('domain', pkg_lu_name_, packages_(i).package_name, packages_(i).lu_type);
               END IF;
            END IF;
            -- Do not store method information on Projections(_SVC), and mobile utilities (_JSN, _TLM) packages, 
            IF NOT (packages_(i).package_name LIKE '%/_SVC' ESCAPE '/' OR packages_(i).package_name LIKE '%/_JSN' ESCAPE '/' OR packages_(i).package_name LIKE '%/_TLM' ESCAPE '/') THEN
               Refresh_Methods___(packages_(i).package_name, packages_(i).lu_type, pkg_lu_name_);
            END IF;
         ELSE
            Write_Error_Text___ (error_text_, '   ??????:Missing Module- or LU-information for package '||packages_(i).package_name||'! Make sure that correct package globals exist for '||packages_(i).package_name);
         END IF;
      END LOOP;

/* Commented for now, since the code has several bugs. Maybe corrected in future Service Pack
      IF (refresh_mode_ != 'LIGHT') THEN
         IF refresh_all_ THEN
            Rebuild_All_State_Event___(TRUE);
            Rebuild_State_Transitions___(TRUE);
            Rebuild_State_Machine___(TRUE);
         ELSE
            Rebuild_All_State_Event___(FALSE);
            Rebuild_State_Transitions___(FALSE);
            Rebuild_State_Machine___(FALSE);
         END IF;
      END IF;
*/
   END IF;
   --
   -- Refresh view information
   --
   IF views_.COUNT > 0 THEN
      Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
      Write_Error_Text___ (error_text_, '   Dictionary Cache is being updated for '||to_char(views_.count)||' View(s)');
      Write_Error_Text___ (error_text_, '   -------------------------------------------------------------');
      -- Save start date for view refresh
      -- Remove old information if full refresh
      IF refresh_all_views_ THEN
         IF developer_mode_ THEN
            @ApproveDynamicStatement(2006-02-15,pemase)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_view_tab';
            @ApproveDynamicStatement(2016-11-21,mabose)
            EXECUTE IMMEDIATE 'TRUNCATE TABLE dictionary_sys_view_column_tab';
         ELSE
            DELETE FROM dictionary_sys_view_tab;
            DELETE FROM dictionary_sys_view_column_tab;
         END IF;
      ELSE
         FORALL j IN Nvl(views_.FIRST,0)..Nvl(views_.LAST,-1)
            DELETE FROM dictionary_sys_view_tab
               WHERE view_name = views_(j).view_name;
      END IF;

      FOR i IN Nvl(views_.FIRST,0)..Nvl(views_.LAST,-1) LOOP
         view_lu_name_ := NULL;
         base_package_name_ := NULL;
         view_module_  := UPPER(Dictionary_SYS.Comment_Value_('MODULE', views_(i).view_comment));
         IF view_module_ = 'IGNORE' THEN
            view_lu_name_ := 'IGNORE';
         END IF;
         IF view_lu_name_ IS NULL THEN
            view_lu_name_ := Dictionary_SYS.Comment_Value_('LU', views_(i).view_comment);
    
            IF view_lu_name_ IS NULL THEN
               view_lu_name_ := Dictionary_SYS.Comment_Value_('SERVICE', views_(i).view_comment);
            END IF;
         END IF;
         view_prompt_     := Dictionary_SYS.Comment_Value_('PROMPT', views_(i).view_comment);
         table_name_      := Dictionary_SYS.Comment_Value_('TABLE', views_(i).view_comment);
         server_only_     := NVL(Dictionary_SYS.Comment_Value_('SERVER_ONLY', views_(i).view_comment), 'FALSE');
         validity_mode_   := Dictionary_SYS.Comment_Value_('VALIDITY', views_(i).view_comment);
         objversion_      := Dictionary_SYS.Comment_Value_('OBJVERSION', views_(i).view_comment);
         objstate_        := Dictionary_SYS.Comment_Value_('OBJSTATE', views_(i).view_comment);
         objid_           := Dictionary_SYS.Comment_Value_('OBJID', views_(i).view_comment);
         objkey_          := Dictionary_SYS.Comment_Value_('OBJKEY', views_(i).view_comment);
         refbase_         := Dictionary_SYS.Comment_Value_('REFBASE', views_(i).view_comment);
         basedon_         := Dictionary_SYS.Comment_Value_('BASEDON', views_(i).view_comment);
         basedonfilter_   := Dictionary_SYS.Comment_Value_('BASEDONFILTER', views_(i).view_comment);
         base_package_name_ := Dictionary_SYS.Comment_Value_('PACKAGE', views_(i).view_comment);
         view_row_level_security_ := Dictionary_SYS.Comment_Value_(VIEW_ROW_LEVEL_SECURITY_COMMENT, views_(i).view_comment);
         
         IF view_module_ IS NOT NULL AND view_lu_name_ IS NOT NULL THEN
            IF view_module_ != 'IGNORE' THEN
               Insert_View_Information___(view_lu_name_,
                                          view_module_,
                                          base_package_name_,
                                          views_(i).view_name,
                                          view_prompt_,
                                          server_only_,
                                          validity_mode_,
                                          views_(i).view_comment,
                                          table_name_,
                                          objversion_,
                                          objstate_,
                                          objid_,
                                          objkey_,
                                          refbase_,
                                          basedon_,
                                          basedonfilter_,
                                          view_row_level_security_);
               IF server_only_ = 'FALSE' AND LENGTH(views_(i).view_name) <= MAX_DICT_IDENTIFER_LENGTH THEN
                  Refresh_View_Columns___(views_(i).view_name, view_lu_name_);
               END IF;
            END IF;
         ELSE
            Write_Error_Text___ (error_text_, '   ??????:Missing Module- or LU-information for view '||views_(i).view_name||'! Make sure that correct view comments exist for '||views_(i).view_name);
         END IF;
      END LOOP;
   END IF;

   IF NOT refresh_all_ AND cleanup_ THEN
      --
      -- Delete information for objects no longer in the database
      --
      Cleanup__;
   END IF;

   --
   -- If an LU has two base views, one might be named as the LU itself but has no TABLE in the comments,
   -- but the other has TABLE in the comments, the one with TABLE is the real base view. This is typically
   -- when you use another view as the base view, code gen property in the model file.
   --
   UPDATE dictionary_sys_view_tab d1
   SET view_type = 'A'
   WHERE d1.lu_name IN
      (SELECT lu_name
       FROM dictionary_sys_view_tab t
       WHERE t.view_type = 'B'
       GROUP BY lu_name
       HAVING count(*) > 1)
   AND d1.view_type = 'B'
   AND d1.view_comment NOT LIKE '%TABLE=%'
   AND EXISTS
      (SELECT 1
       FROM dictionary_sys_view_tab d2
       WHERE d1.lu_name = d2.lu_name
       AND d2.view_comment LIKE '%TABLE=%'
       AND d2.view_type = 'B');
   --
   -- Attempt 1:
   -- At this point we have the basic information about the dictionary
   -- but some base views are missing. This is the first method to fix it.
   --
   UPDATE dictionary_sys_view_tab
      SET view_type = 'B'
    WHERE lu_name NOT IN ( SELECT lu_name
                             FROM dictionary_sys_view_tab
                            WHERE view_type = 'B' )
      AND view_name IN   ( SELECT view_name
                             FROM dictionary_sys_view_tab    dv,
                                  dictionary_sys_package_tab dp
                            WHERE dv.lu_name = dp.lu_name
                              AND ( dv.view_name || '_API') = dp.package_name );

   --
   -- Attempt 2:
   -- Set the first view as base view for Logical Units that does not yet have been
   -- assigned any base view according to naming standard rules.
   --
   UPDATE dictionary_sys_view_tab a
      SET view_type = 'B'
      WHERE lu_name NOT IN (SELECT lu_name
                            FROM dictionary_sys_view_tab
                            WHERE view_type = 'B')
      AND view_index = (SELECT MIN(b.view_index)
                        FROM   dictionary_sys_view_tab b
                        WHERE  b.lu_name = a.lu_name);

   --
   -- Clear any obsolete base view reference for entities without any base view.
   --
   UPDATE dictionary_sys_tab
   SET    lu_prompt = NULL,
          table_name = NULL,
          objversion = NULL,
          objstate = NULL,
          objid = NULL,
          objkey = NULL,
          refbase = NULL
   WHERE  (table_name IS NOT NULL OR objversion IS NOT NULL OR objstate IS NOT NULL OR
           objid      IS NOT NULL OR objkey     IS NOT NULL OR refbase  IS NOT NULL)
   AND    lu_name NOT IN (SELECT lu_name
                          FROM   dictionary_sys_view_tab
                          WHERE  view_type = 'B');

   --
   -- Set prompts for all Logical Units that didn't have a clearly defined view with a prompt.
   -- Create the prompt from the Logical Unit name.
   --
   UPDATE dictionary_sys_tab
      SET lu_prompt = Dictionary_SYS.Client_Name_To_Prompt_(lu_name)
   WHERE lu_prompt IS NULL;
   
   IF Get_Installation_Mode THEN
      -- Check if a LU has more than one base view
      Check_Base_View___;

      -- Check if an object has an invalid (long) name
      Check_Long_Identifiers;
   END IF;

   IF packages_.COUNT > 0 THEN      
         Post_Rebuild_Dict_Batch___;
   END IF;
   
   Cache_Management_API.Refresh_Cache('Dictionary');
   Write_Error_Text___ (error_text_, '-------------------------------------------------------------');
   Write_Error_Text___ (error_text_, 'Dictionary Cache finished');
   Write_Error_Text___ (error_text_, '-------------------------------------------------------------');
   RETURN(error_text_);
EXCEPTION
   WHEN numeric_or_val_error THEN
      Check_Long_Identifiers;
      RAISE;
END Rebuild_Dictionary_Storage___;

PROCEDURE Post_Rebuild_Dictionary__
IS
BEGIN
   dbms_mview.refresh('Batch_Schedulable_Method_Mv', 'C');
   dbms_mview.refresh('Batch_Sche_Validate_Method_Mv', 'C');
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      dbms_mview.refresh('Custom_Action_Methods_MV', 'C');
      dbms_mview.refresh('Query_Designer_Entities_MV', 'C');
   $ELSE
      NULL;
   $END    
END Post_Rebuild_Dictionary__;
   
PROCEDURE Post_Rebuild_Dict_Batch___
IS
   PRAGMA autonomous_transaction;
BEGIN
   IF NOT (Deferred_Job_API.Procedure_Already_Posted_('Dictionary_Sys.Post_Rebuild_Dictionary__')) THEN
      Transaction_SYS.Deferred_Call('Dictionary_Sys.Post_Rebuild_Dictionary__',
                                    NULL,
                                    'Rebuild Materialized Views for IFS Dictionary',
                                    posted_date_ => (sysdate + 1/48));
      @ApproveTransactionStatement(2019-03-25,mabose)
      COMMIT;
   END IF;
END Post_Rebuild_Dict_Batch___;

--SOLSETFW
FUNCTION Get_Base_Package___ (
   lu_name_      IN VARCHAR2,
   check_active_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'BASE PACKAGE';
   temp_             VARCHAR2(128);
   dbname_           VARCHAR2(128) := Dictionary_SYS.Clientnametodbname_(lu_name_);
   package_name_     VARCHAR2(128);
   
   CURSOR get_package IS
      SELECT package_name
      FROM   dictionary_sys_package_tab
      WHERE lu_name = lu_name_
      ORDER BY package_index;
   
   CURSOR get_package_from_source1 IS
      SELECT Name
      FROM user_source
      WHERE TYPE = 'PACKAGE'
      AND Name LIKE Substr(lu_name_, 1, 1)||'%'
      AND text LIKE '%lu_name_%'||''''||lu_name_||''';%'
      AND line BETWEEN 3 AND 12;
   
   CURSOR get_package_from_source2 IS
      SELECT Name
      FROM user_source
      WHERE TYPE = 'PACKAGE'
      AND text LIKE '%lu_name_%'||lu_name_||'%'
      AND line BETWEEN 3 AND 12;
      
   FUNCTION Base_Package_Is_Defined___(
      lu_name_      IN VARCHAR2,
      package_name_ IN OUT VARCHAR2) RETURN BOOLEAN IS
      base_package_ dictionary_sys_tab.base_package%TYPE;
   BEGIN 
      SELECT BASE_PACKAGE INTO base_package_ FROM DICTIONARY_SYS_TAB WHERE LU_NAME = lu_name_;

      IF base_package_ IS NULL THEN
         RETURN FALSE;
      ELSE
         package_name_ := base_package_;
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN FALSE;
   END Base_Package_Is_Defined___;
BEGIN
   IF lu_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   package_name_ := Get_Cache_Value___(cache_category_, lu_name_);
   IF (package_name_ IS NULL) THEN
      IF check_active_ = 'TRUE' AND NOT Is_Module_Active___(lu_name_) THEN
         RETURN NULL;
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_API')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_API');
         RETURN(dbname_||'_API');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_SYS')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_SYS');
         RETURN(dbname_||'_SYS');
      ELSIF (Base_Package_Is_Defined___(lu_name_, package_name_)) THEN
         Set_Cache_Value___(cache_category_, lu_name_, package_name_);
         RETURN (package_name_);
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_RPI')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_RPI');
         RETURN(dbname_||'_RPI');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_SVC')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_SVC');
         RETURN(dbname_||'_SVC');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_JSN')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_JSN');
         RETURN(dbname_||'_JSN');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_TLM')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_TLM');
         RETURN(dbname_||'_TLM');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_SCH')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_SCH');
         RETURN(dbname_||'_SCH');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_CLP')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_CLP');
         RETURN(dbname_||'_CLP');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_CFP')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_CFP');
         RETURN(dbname_||'_CFP');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_ICP')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_ICP');
         RETURN(dbname_||'_ICP');
      ELSIF (Installation_SYS.Package_Exist(dbname_||'_APN')) THEN
         Set_Cache_Value___(cache_category_, lu_name_, dbname_||'_APN');
         RETURN(dbname_||'_APN');
      ELSE
         OPEN  get_package;
         FETCH get_package INTO temp_;
         IF get_package%FOUND THEN
            CLOSE get_package;
            Set_Cache_Value___(cache_category_, lu_name_, temp_);
            RETURN(temp_);
         ELSE
            CLOSE get_package;
            IF (Dictionary_SYS.Get_Installation_Mode = TRUE) THEN 
               OPEN  get_package_from_source1;
               FETCH get_package_from_source1 INTO temp_;
               CLOSE get_package_from_source1;
               IF (temp_ IS NULL) THEN
                  OPEN  get_package_from_source2;
                  FETCH get_package_from_source2 INTO temp_;
                  CLOSE get_package_from_source2;
               END IF;
               Set_Cache_Value___(cache_category_, lu_name_, temp_);
               RETURN(temp_);
            END IF;
         END IF;
      END IF;
      Set_Cache_Value___(cache_category_, lu_name_, 'NO PACKAGE NAME');
      RETURN(NULL);
   ELSE
      RETURN(CASE package_name_ 
             WHEN 'NO PACKAGE NAME' THEN 
                NULL 
             ELSE 
                package_name_
             END);
   END IF;
END Get_Base_Package___;


FUNCTION Get_Base_Package_Of_Type___ (
   lu_name_ IN VARCHAR2,
   type_    IN VARCHAR2) RETURN VARCHAR2
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'BASE PACKAGE.' || UPPER(type_);
   temp_             VARCHAR2(128);
   dbname_           VARCHAR2(128) := Dictionary_SYS.Clientnametodbname_(lu_name_);
   package_name_     VARCHAR2(128);
   
   CURSOR get_package IS
      SELECT package_name
      FROM   dictionary_sys_package_tab
      WHERE lu_name = lu_name_
      ORDER BY package_index;
   
   CURSOR get_package_from_source1 IS
      SELECT Name
      FROM user_source
      WHERE TYPE = 'PACKAGE'
      AND Name LIKE Substr(lu_name_, 1, 1)||'%'
      AND text LIKE '%lu_name_%'||''''||lu_name_||''';%'
      AND line BETWEEN 3 AND 12;
   
   CURSOR get_package_from_source2 IS
      SELECT Name
      FROM user_source
      WHERE TYPE = 'PACKAGE'
      AND text LIKE '%lu_name_%'||lu_name_||'%'
      AND line BETWEEN 3 AND 12;
      
   FUNCTION Base_Package_Is_Defined RETURN BOOLEAN
   IS
      base_package_ dictionary_sys_tab.base_package%TYPE;
   BEGIN 
      SELECT BASE_PACKAGE INTO base_package_ FROM DICTIONARY_SYS_TAB WHERE LU_NAME = lu_name_;

      IF base_package_ IS NULL THEN
         RETURN FALSE;
      ELSE
         package_name_ := base_package_;
         Set_Cache_Value___(cache_category_, lu_name_, package_name_);
         RETURN TRUE;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         RETURN FALSE;
   END Base_Package_Is_Defined;
   
   FUNCTION Package_Of_Type_Exist(ext_ IN VARCHAR2) RETURN BOOLEAN
   IS
   BEGIN
     IF ((ext_ = '_' || UPPER(type_)) AND Installation_SYS.Package_Exist(dbname_ || ext_)) THEN
        package_name_ := dbname_ || ext_;
        Set_Cache_Value___(cache_category_, lu_name_, package_name_);
        RETURN TRUE;
     END IF;

     RETURN FALSE;
   END Package_Of_Type_Exist;
BEGIN
   IF lu_name_ IS NULL OR type_ IS NULL THEN
      RETURN NULL;
   END IF;
   package_name_ := Get_Cache_Value___(cache_category_, lu_name_);
   IF (package_name_ IS NULL) THEN 
      IF (Package_Of_Type_Exist('_API')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_SYS')) THEN
         RETURN(package_name_);
      ELSIF (Base_Package_Is_Defined) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_RPI')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_SVC')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_JSN')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_TLM')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_SCH')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_CLP')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_CFP')) THEN
         RETURN(package_name_);
      ELSIF (Package_Of_Type_Exist('_ICP')) THEN
         RETURN(package_name_);
      ELSE
         OPEN  get_package;
         FETCH get_package INTO temp_;
         IF get_package%FOUND THEN
            CLOSE get_package;
            Set_Cache_Value___(cache_category_, lu_name_, temp_);
            RETURN(temp_);
         ELSE
            CLOSE get_package;
            IF (Dictionary_SYS.Get_Installation_Mode = TRUE) THEN 
               OPEN  get_package_from_source1;
               FETCH get_package_from_source1 INTO temp_;
               CLOSE get_package_from_source1;
               IF (temp_ IS NULL) THEN
                  OPEN  get_package_from_source2;
                  FETCH get_package_from_source2 INTO temp_;
                  CLOSE get_package_from_source2;
               END IF;
               Set_Cache_Value___(cache_category_, lu_name_, temp_);
               RETURN(temp_);
            END IF;
         END IF;
      END IF;
      Set_Cache_Value___(cache_category_, lu_name_, 'NO PACKAGE NAME');
      RETURN(NULL);
   ELSE
      RETURN(CASE package_name_ 
             WHEN 'NO PACKAGE NAME' THEN 
                NULL 
             ELSE 
                package_name_
             END);
   END IF;
END Get_Base_Package_Of_Type___;

--SOLSETFW
FUNCTION Get_Base_Table_Name___ (
   lu_name_      IN VARCHAR2,
   check_active_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'BASE TABLE';
   table_name_       VARCHAR2(50);
   
   CURSOR get_table IS
      SELECT table_name
      FROM dictionary_sys_tab
      WHERE lu_name = lu_name_;
   CURSOR get_table_from_comment IS
      SELECT Dictionary_SYS.Comment_Value_('TABLE', comments)
      FROM fnd_tab_comments
      WHERE comments LIKE '%TABLE%'
      AND comments LIKE '%LU='||lu_name_||'^%'
      AND table_name NOT LIKE '%REP';

BEGIN
   IF lu_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   table_name_ := Get_Cache_Value___(cache_category_, lu_name_);
   IF (table_name_ IS NULL) THEN
      IF check_active_ = 'TRUE' AND NOT Is_Module_Active___(lu_name_) THEN
         RETURN NULL;
      END IF;
      OPEN  get_table;
      FETCH get_table INTO table_name_;
      CLOSE get_table;
      IF table_name_ IS NULL THEN
         table_name_ := nvl(table_name_, Dictionary_SYS.Clientnametodbname_(lu_name_)||'_TAB');
         IF Installation_SYS.Table_Exist(table_name_) THEN
            Set_Cache_Value___(cache_category_, lu_name_, table_name_);
            RETURN(table_name_);
         ELSE
            OPEN  get_table_from_comment;
            FETCH get_table_from_comment INTO table_name_;
            CLOSE get_table_from_comment;
            IF Installation_SYS.Table_Exist(table_name_) THEN
               Set_Cache_Value___(cache_category_, lu_name_, table_name_);
               RETURN(table_name_);
            ELSE
               Set_Cache_Value___(cache_category_, lu_name_, 'NO TABLE NAME');
               RETURN(NULL);
            END IF;
         END IF;
      ELSE
         Set_Cache_Value___(cache_category_, lu_name_, table_name_);
         RETURN(table_name_);
      END IF;
   ELSE
      RETURN(CASE table_name_ 
             WHEN 'NO TABLE NAME' THEN 
                NULL 
             ELSE 
                table_name_
             END);
   END IF;
END Get_Base_Table_Name___;


--SOLSETFW
FUNCTION Get_Component___ (
   object_name_  IN VARCHAR2,
   object_type_  IN VARCHAR2,
   check_active_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2
IS
   component_ VARCHAR2(6);
   active_    VARCHAR2(5);
   
   CURSOR get_pkg_component IS
      SELECT d.module
      FROM   dictionary_sys_tab d, dictionary_sys_package_tab p
      WHERE  p.package_name = upper(object_name_)
      AND    p.lu_name = d.lu_name;
      
   CURSOR get_package_from_source IS
      SELECT SUBSTR(s1.text,
                    instr(s1.text,'''')+1,
                    instr(s1.text,'''',instr(s1.text,'''')+1)-instr(s1.text,'''')-1) module
      FROM   user_source s1
      WHERE  type = 'PACKAGE'
      AND    name = upper(object_name_)
      AND    s1.line BETWEEN 2 AND 11
      AND    s1.text LIKE '%module_%:=%''%''%'
      AND    s1.text NOT LIKE '--%'
      AND    s1.text NOT LIKE '%/%*%'
      AND    s1.text NOT LIKE '%*%/';

   CURSOR get_view_component IS
      SELECT d.module
      FROM   dictionary_sys_tab d, dictionary_sys_view_tab v
      WHERE  v.view_name = upper(object_name_)
      AND    v.lu_name = d.lu_name;
      
   CURSOR get_component_from_comment IS
      SELECT Dictionary_SYS.Comment_Value_('MODULE', comments)
      FROM fnd_tab_comments
      WHERE comments LIKE '%MODULE%'
      AND table_name = object_name_;
      
   FUNCTION Check_Module_Active___ (component_ IN VARCHAR2) RETURN VARCHAR2
   IS
      CURSOR get_module_active IS
         SELECT active
           FROM module_tab
          WHERE module = component_;
      BEGIN
      OPEN get_module_active;
      FETCH get_module_active INTO active_;
      CLOSE get_module_active;
      RETURN active_;
   END Check_Module_Active___;
       
BEGIN
   IF upper(object_type_) = 'PACKAGE' THEN
      OPEN get_pkg_component;
      FETCH get_pkg_component INTO component_;
      CLOSE get_pkg_component;
      IF component_ IS NULL THEN
         OPEN get_package_from_source;
         FETCH get_package_from_source INTO component_;
         CLOSE get_package_from_source;
      END IF;
   ELSIF upper(object_type_) = 'VIEW' THEN
      OPEN get_view_component;
      FETCH get_view_component INTO component_;
      CLOSE get_view_component;
      IF component_ IS NULL THEN
         OPEN get_component_from_comment;
         FETCH get_component_from_comment INTO component_;
         CLOSE get_component_from_comment;
      END IF;
   ELSE
      component_ := NULL;
   END IF;
   IF (check_active_ = 'TRUE' AND NOT Check_Module_Active___(component_) = 'TRUE') THEN
      component_ := NULL;
   END IF;
   RETURN component_;
EXCEPTION
   WHEN VALUE_ERROR THEN
      RETURN NULL;
END Get_Component___;


FUNCTION Get_Underscored_Name___ (
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   result_ VARCHAR2(100);
BEGIN
   result_ := substr(name_, 1, 1);
   FOR i IN 2 .. length(name_) LOOP
      IF (substr(name_, i, 1) >= 'A' AND substr(name_, i, 1) <= 'Z') THEN
         result_ := result_||'_';
      END IF;
      result_ := result_||substr(name_, i, 1);
   END LOOP;
   RETURN result_;
END Get_Underscored_Name___;


FUNCTION Get_Package_Name___ (
   metadata_type_ IN VARCHAR2,
   metadata_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF (metadata_type_ = CLIENT_LAYOUT) THEN
      RETURN Get_Underscored_Name___(metadata_name_)||'_CPI';
   ELSE
      RETURN Get_Underscored_Name___(metadata_name_)||'_SVC';
   END IF;
END Get_Package_Name___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
BEGIN
      DELETE FROM dictionary_sys_package_tab p
         WHERE NOT EXISTS (SELECT 1
                           FROM user_plsql_object_settings u
                           WHERE u.type = 'PACKAGE'
                           AND p.package_name = u.name);

      DELETE FROM dictionary_sys_method_tab m
         WHERE NOT EXISTS (SELECT 1
                           FROM dictionary_sys_package_tab p
                           WHERE m.package_name = p.package_name);

      DELETE FROM dictionary_sys_method_ext_tab m
         WHERE NOT EXISTS (SELECT 1
                           FROM dictionary_sys_package_tab p
                           WHERE m.object_name = p.package_name);
      IF SQL%ROWCOUNT > 0 THEN
         Post_Rebuild_Dict_Batch___;
      END IF;

      DELETE FROM dictionary_sys_view_tab v
         WHERE NOT EXISTS (SELECT 1
                           FROM user_views u
                           WHERE v.view_name = u.view_name);

      DELETE FROM dictionary_sys_view_column_tab c
         WHERE NOT EXISTS (SELECT 1
                           FROM dictionary_sys_view_tab v
                           WHERE v.lu_name = c.lu_name
                           AND v.view_name = c.view_name)
            OR NOT EXISTS (SELECT 1 FROM fnd_col_comments fc
                           WHERE fc.table_name=c.view_name
                           AND fc.column_name=c.column_name);

      DELETE FROM dictionary_sys_tab l
         WHERE NOT EXISTS (SELECT 1
                           FROM dictionary_sys_package_tab p
                           WHERE p.lu_name = l.lu_name
                           UNION
                           SELECT 1
                           FROM dictionary_sys_view_tab v
                           WHERE v.lu_name = l.lu_name);

      DELETE dictionary_sys_view_tab v
      WHERE  v.view_name IN (SELECT c.table_name
                             FROM   fnd_tab_comments c
                             WHERE  c.table_type = 'VIEW'
                             AND    (c.comments = 'MODULE=IGNORE^' OR c.comments IS NULL));

END Cleanup__;   
-- Enumerate_Logical_Units__
--   Returns lists of installed logical units.
--   Returns lists of installed logical units.
--   (Modified implementation to use dictionary cache. Designtime version moved to Design_SYS)
--   Obsolete!(Kept for backward compatibility)
--   Please use the method with same name but 5 out parameters instead.
--   Returns lists of installed logical units.
@UncheckedAccess
PROCEDURE Enumerate_Logical_Units__ (
   lu_list1_ OUT VARCHAR2,
   lu_list2_ OUT VARCHAR2,
   lu_list3_ OUT VARCHAR2,
   lu_list4_ OUT VARCHAR2,
   lu_list5_ OUT VARCHAR2 )
IS
   CURSOR get_logical_units IS
      SELECT lu_name
        FROM dictionary_sys_tab
       WHERE lu_type = 'L'
       ORDER BY lu_name;

   TYPE lu_list IS TABLE OF get_logical_units%ROWTYPE INDEX BY BINARY_INTEGER;

   lu_rec_    lu_list;         -- Logical Unit list from database
   temp_      lu_struct_type;  -- PL/SQL table to hold out values to be used in loops.
   lu_list_   VARCHAR2(32000); -- Temporary buffer holding out values before being assigned to out variables.
   limit_     NUMBER := 31000; -- This should be less than or equal to the size of the out variables.
   var_limit_ NUMBER := 5;     -- Number of out variables.
   n_         NUMBER := 1;

   char_buffer_small exception;
   pragma EXCEPTION_INIT (char_buffer_small, -06502);
BEGIN
   -- TODO: General_SYS call not used in the original procedure. Why is that?

   -- Init used elements
   temp_(1) := NULL;
   temp_(2) := NULL;
   temp_(3) := NULL;
   temp_(4) := NULL;
   temp_(5) := NULL;

   OPEN  get_logical_units;
   FETCH get_logical_units BULK COLLECT INTO lu_rec_;
   CLOSE get_logical_units;

   -- Copy all the LU names to out variables
   FOR index_ IN lu_rec_.FIRST..lu_rec_.LAST LOOP
      -- This code is written this way to archive better performance:
      -- About 10 times speed increase detected than having the condition Check
      -- instead of the exception block.
      BEGIN
         lu_list_  := lu_list_ || lu_rec_(index_).lu_name || field_separator_;
      EXCEPTION
         WHEN char_buffer_small THEN
            -- Check whether nothing else has gone wrong
            IF ((length(lu_list_) + length(lu_rec_(index_).lu_name) + 1) > limit_ ) THEN
               temp_(n_) := lu_list_;
               lu_list_ := lu_rec_(index_).lu_name || field_separator_;
               n_ := n_ + 1;
               IF n_ > var_limit_ THEN
                  -- We can only return 5 (var_limit_) variables out.
                  -- This information might be handy in debugging.
                  Log_SYS.Fnd_Trace_(Log_SYS.error_, '(01) Logical Unit List Truncated.');
                  EXIT;
               END IF;
            ELSE
               RAISE;
            END IF;
      END;
   END LOOP;
   -- Assign the last line to out variable here.
   temp_(n_) := lu_list_;
   -- Return complete lists
   lu_list1_ := temp_(1);
   lu_list2_ := temp_(2);
   lu_list3_ := temp_(3);
   lu_list4_ := temp_(4);
   lu_list5_ := temp_(5);
EXCEPTION
   WHEN no_data_found THEN
      --just return what it can.
      lu_list1_ := temp_(1);
      lu_list2_ := temp_(2);
      lu_list3_ := temp_(3);
      lu_list4_ := temp_(4);
      lu_list5_ := temp_(5);
      Log_SYS.Fnd_Trace_(Log_SYS.error_, '(02) Logical Unit List Truncated.');
END Enumerate_Logical_Units__;



@UncheckedAccess
FUNCTION Enumerate_Dictionary_Data__ (
   dictionary_type_ IN  VARCHAR2,
   argument_ IN VARCHAR2 DEFAULT '%') RETURN CLOB 
IS
   msg_     CLOB := Message_SYS.Construct('DictionaryData');
   stmt_    VARCHAR2(1000);
   TYPE objects_arr IS TABLE OF VARCHAR2(30) INDEX BY BINARY_INTEGER;
   objects_ objects_arr;
BEGIN
   CASE dictionary_type_ 
      WHEN 'MODULES' THEN 
         stmt_ := 'SELECT module FROM module_tab WHERE module LIKE :argument_';
      WHEN 'LUS' THEN 
         stmt_ := 'SELECT lu_name FROM dictionary_sys_lu WHERE UPPER(module) LIKE UPPER(:argument_)';
      WHEN 'PACKAGES' THEN 
         stmt_ := 'SELECT package_name FROM dictionary_sys_package WHERE UPPER(lu_name) LIKE UPPER(:argument_)';
      WHEN 'COLUMNS' THEN 
         stmt_ := 'SELECT column_name FROM fnd_col_comments WHERE UPPER(table_name) LIKE UPPER(:argument_)';
      WHEN 'VIEWS' THEN 
         stmt_ := 'SELECT view_name FROM dictionary_sys_view WHERE UPPER(lu_name) LIKE UPPER(:argument_)';
      ELSE
         Error_SYS.Appl_General(service_, 'WRONG_TYPE: You have entered a dictionary type [:P1] that does''nt exist.', dictionary_type_);
   END CASE;
   -- Fetch all objects
   @ApproveDynamicStatement(2017-07-10,mabose)
   EXECUTE IMMEDIATE stmt_ BULK COLLECT INTO objects_ USING argument_;
   FOR i IN Nvl(objects_.first, 0)..Nvl(objects_.last, -1) LOOP
      -- Append found column to list
      Message_SYS.Add_Attribute(msg_, objects_(i), '');
   END LOOP;
   RETURN(msg_);
END Enumerate_Dictionary_Data__;


-- Get_Logical_Unit_Properties__
--   Finds properties (views, packages, methods) for a logical unit.
@UncheckedAccess
PROCEDURE Get_Logical_Unit_Properties__ (
   lu_name_        IN  VARCHAR2,
   view_list_      OUT VARCHAR2,
   package_list_   OUT VARCHAR2,
   method_list_    OUT VARCHAR2,
   all_methods_    IN  VARCHAR2 DEFAULT 'TRUE' )
IS
BEGIN
   Get_Logical_Unit_Views__(lu_name_, view_list_);
   Get_Logical_Unit_Packages__(lu_name_, package_list_);
   Get_Logical_Unit_Methods__(lu_name_, method_list_, all_methods_);
END Get_Logical_Unit_Properties__;




@UncheckedAccess
PROCEDURE Get_Logical_Unit_Properties2__ (
   lu_name_        IN  VARCHAR2,
   view_list_      OUT VARCHAR2,
   package_list_   OUT VARCHAR2,
   method_list_    OUT VARCHAR2,
   all_methods_    IN  VARCHAR2 DEFAULT 'TRUE' )
IS
BEGIN
   Get_Logical_Unit_Views__(lu_name_, view_list_);
   Get_Logical_Unit_Packages__(lu_name_, package_list_);
   Get_LU_Method_Types__(lu_name_, method_list_);
END Get_Logical_Unit_Properties2__;




-- Get_Logical_Unit_Views__
--   Finds view properties for a logical unit.
@UncheckedAccess
PROCEDURE Get_Logical_Unit_Views__ (
   lu_name_        IN  VARCHAR2,
   view_list_      OUT VARCHAR2 )
IS
BEGIN
   view_list_ := Get_Logical_Unit_Views__(lu_name_);
END Get_Logical_Unit_Views__;




-- Get_Logical_Unit_Views__
--   Finds view properties for a logical unit.
@UncheckedAccess
FUNCTION Get_Logical_Unit_Views__ (
   lu_name_        IN  VARCHAR2) RETURN VARCHAR2
IS
   view_array_     object_array;
   view_list_      VARCHAR2(32000);

   CURSOR get_lu_views IS
      SELECT view_name
      FROM dictionary_sys_view_tab
      WHERE lu_name = lu_name_
      ORDER BY view_index;
BEGIN
   OPEN  get_lu_views;
   FETCH get_lu_views BULK COLLECT INTO view_array_;
   CLOSE get_lu_views;
   IF view_array_.count > 0 THEN
      FOR i IN Nvl(view_array_.first, 0)..Nvl(view_array_.last, -1) LOOP
         view_list_ := view_list_||view_array_(i)||field_separator_;
      END LOOP;
   END IF;
   RETURN view_list_;
END Get_Logical_Unit_Views__;




-- Get_Logical_Unit_Packages__
--   Finds package properties for a logical unit.
@UncheckedAccess
PROCEDURE Get_Logical_Unit_Packages__ (
   lu_name_        IN  VARCHAR2,
   package_list_   OUT VARCHAR2 )
IS
BEGIN
   package_list_ := Get_Logical_Unit_Packages__(lu_name_);
END Get_Logical_Unit_Packages__;




-- Get_Logical_Unit_Packages__
--   Finds package properties for a logical unit.
@UncheckedAccess
FUNCTION Get_Logical_Unit_Packages__ (
   lu_name_        IN  VARCHAR2 ) RETURN VARCHAR2
IS
   package_array_  object_array;
   package_list_   VARCHAR2(4000);

   CURSOR get_lu_packages IS
      SELECT package_name
      FROM dictionary_sys_package_tab
      WHERE lu_name = lu_name_
      ORDER BY package_index;
BEGIN
   OPEN  get_lu_packages;
   FETCH get_lu_packages BULK COLLECT INTO package_array_;
   CLOSE get_lu_packages;
   IF package_array_.count > 0 THEN
      FOR i IN Nvl(package_array_.first, 0)..Nvl(package_array_.last, -1) LOOP
         package_list_ := package_list_||package_array_(i)||field_separator_;
      END LOOP;
   END IF;
   RETURN package_list_;
END Get_Logical_Unit_Packages__;




-- Get_Logical_Unit_Methods__
--   Finds method properties for a logical unit.
--   Note! All lists are separated with field_separator_.
@UncheckedAccess
PROCEDURE Get_Logical_Unit_Methods__ (
   lu_name_        IN  VARCHAR2,
   method_list_    OUT VARCHAR2,
   all_methods_    IN  VARCHAR2 DEFAULT 'TRUE' )
IS
   method_array_  object_array;
   package_array_ object_array;

   CURSOR get_all_lu_methods IS
      SELECT package_name, method_name
      FROM dictionary_sys_method_tab
      WHERE lu_name = lu_name_
      ORDER BY package_name;

   CURSOR get_lu_methods IS
      SELECT package_name, method_name
      FROM dictionary_sys_method_tab
      WHERE lu_name = lu_name_
      AND method_type = 'N'
      ORDER BY package_name;

BEGIN
   IF all_methods_ = 'TRUE' THEN
      OPEN get_all_lu_methods;
      FETCH get_all_lu_methods BULK COLLECT INTO package_array_, method_array_;
      CLOSE get_all_lu_methods;
   ELSE
      OPEN get_lu_methods;
      FETCH get_lu_methods BULK COLLECT INTO package_array_, method_array_;
      CLOSE get_lu_methods;
   END IF;

   IF method_array_.count > 0 THEN
      FOR lu_methods IN Nvl(method_array_.first, 0)..Nvl(method_array_.last, -1) LOOP
         method_list_ := method_list_||package_array_(lu_methods)||'.'||method_array_(lu_methods)||field_separator_;
      END LOOP;
   END IF;
END Get_Logical_Unit_Methods__;




@UncheckedAccess
PROCEDURE Get_LU_Method_Types__ (
   lu_name_        IN  VARCHAR2,
   method_list_    OUT VARCHAR2 )
IS
   method_array_  object_array;
   package_array_ object_array;
   type_array_    object_array;

   CURSOR get_all_lu_methods IS
      SELECT package_name, method_name, method_type
      FROM dictionary_sys_method_tab
      WHERE lu_name = lu_name_
      ORDER BY package_name;

BEGIN
   OPEN get_all_lu_methods;
   FETCH get_all_lu_methods BULK COLLECT INTO package_array_, method_array_, type_array_;
   CLOSE get_all_lu_methods;

   IF method_array_.count > 0 THEN
      FOR lu_methods IN Nvl(method_array_.first, 0)..Nvl(method_array_.last, -1) LOOP
         method_list_ := method_list_||package_array_(lu_methods)||'.'||method_array_(lu_methods)||field_separator_||type_array_(lu_methods)||record_separator_;
      END LOOP;
   END IF;
END Get_LU_Method_Types__;




@UncheckedAccess
FUNCTION Get_State_Encode_Method__ (
   view_name_      IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Check_Method_From_View___(view_name_, 'FINITE_STATE_ENCODE__'));
END Get_State_Encode_Method__;




@UncheckedAccess
FUNCTION Get_State_Enumerate_Method__ (
   view_name_      IN  VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Check_Method_From_View___(view_name_, 'ENUMERATE_STATES__'));
END Get_State_Enumerate_Method__;




-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Dbnametoclientname_ (
   db_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cnt_  NUMBER;
BEGIN
   -- Find number of trailing underscores
   cnt_ := length(db_name_) - length(rtrim(db_name_,'_'));
   -- Return client name with leading underscores
   IF (cnt_ = 1) THEN
      RETURN('_'||replace(initcap(db_name_),'_',''));
   ELSIF (cnt_ = 2) THEN
      RETURN('__'||replace(initcap(db_name_),'_',''));
   END IF;
   RETURN(replace(initcap(db_name_),'_',''));
EXCEPTION
   WHEN OTHERS THEN
      RETURN(NULL);
END Dbnametoclientname_;




@UncheckedAccess
FUNCTION Clientnametodbname_ (
   client_name_ IN VARCHAR2,
   null_on_error_ IN VARCHAR2 DEFAULT 'FALSE') RETURN VARCHAR2
IS
   cnt_   NUMBER;
   temp_  VARCHAR2(30);
   char_  VARCHAR2(1);
   
   null_on_error_b_ BOOLEAN := CASE WHEN null_on_error_ = 'TRUE' THEN TRUE ELSE FALSE END;
BEGIN
   IF(client_name_ IS NULL) THEN
      IF null_on_error_b_ THEN
         RETURN NULL;
      ELSE
         Error_SYS.Appl_General(service_, 'CLIENTNAME_IS_NULL: Cannot convert the client name [NULL] into a database name.');
      END IF;
   END IF;
   
   -- Find number of leading underscores
   cnt_ := length(client_name_) - length(ltrim(client_name_,'_'));   
      
   -- Add intermediate underscores where needed
   FOR index_ IN cnt_+1..length(client_name_) LOOP
      char_ := substr(client_name_,index_,1);
      IF (char_ between 'A' and 'Z')  AND (temp_ IS NOT NULL) THEN
         temp_ := temp_||'_'||char_;
      ELSE
         temp_ := temp_||char_;
      END IF;
   END LOOP;
   
   -- Return database name with trailing underscores
   IF (cnt_ = 1) THEN
      RETURN(ltrim(upper(temp_),'_')||'__');
   ELSIF (cnt_ = 2) THEN
      RETURN(ltrim(upper(temp_),'_')||'__');
   END IF;
   RETURN(ltrim(upper(temp_),'_'));
EXCEPTION
   WHEN value_error THEN
      IF null_on_error_b_ THEN
         RETURN NULL;
      ELSE
         Error_SYS.Appl_General(service_, 'DBNAME_TOO_LONG: The client name [:P1] is too long to be converted into a 30 character database name.', client_name_);
      END IF;
END Clientnametodbname_;


@UncheckedAccess
FUNCTION Client_Name_To_Prompt_ (
   client_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cnt_   NUMBER;
   temp_  VARCHAR2(32000);
   char_  VARCHAR2(1);
BEGIN
   -- Find number of leading underscores
   cnt_ := length(client_name_) - length(ltrim(client_name_,'_'));
      
   -- Add spaces where needed
   FOR index_ IN cnt_+1..length(client_name_) LOOP
      char_ := substr(client_name_,index_,1);
      IF (char_ between 'A' and 'Z')  AND (temp_ IS NOT NULL) THEN
         temp_ := temp_||' '||char_;
      ELSE
         temp_ := temp_||char_;
      END IF;
   END LOOP;
   
   RETURN(temp_);
END Client_Name_To_Prompt_;



-- Comment_Value_
--   Find the value of an individual comment item given the keyword.
--   (e.g. given 'REF' returns 'X(Y)/Z' from comment '..^REF=X(Y)/Z^..')
@UncheckedAccess
FUNCTION Comment_Value_ (
   name_    IN VARCHAR2,
   comment_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   nlen_ NUMBER;
   from_ NUMBER;
   to_   NUMBER;
BEGIN
   -- Find keyword name position within comment
   nlen_ := length(name_);
   -- New fix to support ambigous names in report definitions in IFS/Info Services
   from_ := instr(upper('^'||comment_), '^'||name_||'=');
   -- If found, return value from comment
   IF (from_ > 0) THEN
      to_ := instr(comment_, '^', from_);
      IF ( to_ = 0 ) THEN
        to_ := length(comment_) + 1;
      END IF;
      RETURN(substr(comment_, from_+nlen_+1, to_-from_-nlen_-1));
   -- If not found, return null value
   ELSE
      RETURN(NULL);
   END IF;
END Comment_Value_;




@UncheckedAccess
FUNCTION Comment_Value_Regexp_ (
   name_    IN VARCHAR2,
   comment_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   nlen_ NUMBER;
   from_ NUMBER;
   to_   NUMBER;
BEGIN
   -- Find keyword name position within comment
   nlen_ := length(name_);
   -- New fix to support ambigous names in report definitions in IFS/Info Services
   from_ := instr(upper('^'||comment_), '^'||name_||'=');
   -- If found, return value from comment
   IF (from_ > 0) THEN
      to_ := regexp_instr(comment_, '\^(*[A-Z_]+=|$)', from_);
      IF ( to_ = 0 ) THEN
        to_ := length(comment_) + 1;
      END IF;
      RETURN(substr(comment_, from_+nlen_+1, to_-from_-nlen_-1));
   -- If not found, return null value
   ELSE
      RETURN(NULL);
   END IF;
END Comment_Value_Regexp_;




-- Get_View_Prompt_
--   Finds the description text for any given view.
@UncheckedAccess
FUNCTION Get_View_Prompt_ (
   view_name_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   prompt_ VARCHAR2(200);
   CURSOR get_prompt IS
      SELECT view_prompt
      FROM   dictionary_sys_view_tab
      WHERE  view_name = view_name_;
BEGIN
   OPEN get_prompt;
   FETCH get_prompt INTO prompt_;
   CLOSE get_prompt;
   RETURN prompt_;
END Get_View_Prompt_;




-- Get_Lu_Prompt_
--   Finds the description text for any given logical unit.
@UncheckedAccess
FUNCTION Get_Lu_Prompt_ (
   lu_name_        IN VARCHAR2 ) RETURN VARCHAR2
IS
   prompt_              VARCHAR2(200);
   CURSOR get_prompt IS
      SELECT lu_prompt
      FROM   dictionary_sys_tab
      WHERE  lu_name = lu_name_;
BEGIN
   -- Check that inparameters make sense before proceeding.
   IF lu_name_ IS NULL THEN
      RETURN NULL;
   END IF;

   OPEN get_prompt;
   FETCH get_prompt INTO prompt_;
   CLOSE get_prompt;
   RETURN prompt_;
END Get_Lu_Prompt_;




-- Get_Item_Prompt_
--   Find the prompt text from comments for an item given the
--   view name and the item name, i.e. column name.
@UncheckedAccess
FUNCTION Get_Item_Prompt_ (
   lu_name_        IN VARCHAR2,
   view_name_      IN VARCHAR2,
   item_name_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   view_   VARCHAR2(30) := view_name_;
   prompt_ dictionary_sys_view_column_tab.column_prompt%TYPE;

   CURSOR get_prompt IS
      SELECT column_prompt
      FROM   dictionary_sys_view_column_tab
      WHERE lu_name = lu_name_
      AND view_name = view_
      AND column_name = item_name_;
BEGIN
   IF (view_ IS NULL) THEN
      view_ := ClientNameToDbName_(lu_name_);
   END IF;
   OPEN get_prompt;
   FETCH get_prompt INTO prompt_;
   CLOSE get_prompt;
   RETURN prompt_;
END Get_Item_Prompt_;


--SOLSETFW
-- Get_Item_Prompt_Active
--   Find the prompt text from comments for an active item given the
--   view name and the item name, i.e. column name.
@UncheckedAccess
FUNCTION Get_Item_Prompt_Active (
   lu_name_        IN VARCHAR2,
   view_name_      IN VARCHAR2,
   item_name_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   view_   VARCHAR2(30) := view_name_;
   prompt_ dictionary_sys_view_column_tab.column_prompt%TYPE;

   CURSOR get_prompt IS
      SELECT column_prompt
        FROM dictionary_sys_view_column_tab v, module_tab m, dictionary_sys_tab d
       WHERE v.lu_name = lu_name_
         AND v.view_name = UPPER(view_name_)
         AND v.column_name = UPPER(item_name_)
         AND d.module = m.module
         AND v.lu_name = d.lu_name
         AND m.active = 'TRUE';
BEGIN
   IF (view_ IS NULL) THEN
      view_ := ClientNameToDbName_(lu_name_);
   END IF;
   OPEN get_prompt;
   FETCH get_prompt INTO prompt_;
   CLOSE get_prompt;
   RETURN prompt_;
END Get_Item_Prompt_Active;


-- Get_Logical_Unit_Keys_
--   Find the key names and/or key values for a specific logical unit
--   (and a specified instance by objid).
--   Lists are separated with text_separator_
PROCEDURE Get_Logical_Unit_Keys_ (
   name_list_  OUT VARCHAR2,
   value_list_ OUT VARCHAR2,
   lu_name_    IN  VARCHAR2,
   objid_      IN  VARCHAR2 DEFAULT NULL )
IS
   dummy_     NUMBER;
   stmt_      VARCHAR2(2000);
   view_      VARCHAR2(30);
   temp_list_ VARCHAR2(32000);

   -- To check that the suggested base view actually contain an objid...
   CURSOR find_objid (lu_name_ IN VARCHAR2, view_name_ IN VARCHAR2) IS
      SELECT 1
      FROM   dictionary_sys_view_column_tab
      WHERE  lu_name = lu_name_
      AND    view_name = view_name_
      AND    column_name = 'OBJID';

   CURSOR get_keys (view_name_ IN VARCHAR2) IS
      SELECT column_name
      FROM dictionary_sys_view_column_tab
      WHERE lu_name = lu_name_
      AND view_name = view_name_
      AND type_flag IN ('P','K')
      ORDER BY column_index;
BEGIN
   General_SYS.Check_Security(service_, 'DICTIONARY_SYS', 'Get_Logical_Unit_Keys_');
   Assert_SYS.Assert_Is_Not_Null(lu_name_, 'LU Name');
   name_list_  := NULL;
   value_list_ := NULL;
   -- Fetch the view name from LU-dictionary
   view_ := Get_Base_View(lu_name_);
   -- Verify that this view contains an objid
   OPEN find_objid(lu_name_, view_);
   FETCH find_objid INTO dummy_;
   IF find_objid%FOUND THEN
      CLOSE find_objid;
      -- View found, fetch the keys!
      FOR keyrec IN get_keys(view_) LOOP
         temp_list_ := temp_list_||keyrec.column_name||text_separator_;
      END LOOP;
      name_list_ := temp_list_;
      IF (objid_ IS NOT NULL) THEN
         -- Fetch instance key information by using dynamic SQL
         BEGIN
            temp_list_ := substr(temp_list_, 1, length(temp_list_) - 1);
            temp_list_ := REPLACE(temp_list_, text_separator_, '||''^''||')||'||''^''';
            stmt_ := 'SELECT '|| temp_list_ ||' FROM '||view_||' WHERE OBJID = :objid_';
--            Assert_SYS.Assert_Is_View(view_);
            @ApproveDynamicStatement(2006-01-05,utgulk)
            EXECUTE IMMEDIATE stmt_ INTO value_list_ USING objid_;
        EXCEPTION
           WHEN OTHERS THEN
              value_list_ := NULL;
         END;
      END IF;
   ELSE
      CLOSE find_objid;
   END IF;
END Get_Logical_Unit_Keys_;


-- Get_Logical_Unit_Tables_
--   Returns a list of tables used by a specific logical unit.
--   List is separated with field_separator_
@UncheckedAccess
PROCEDURE Get_Logical_Unit_Tables_ (
   table_list_ OUT VARCHAR2,
   lu_name_    IN  VARCHAR2 )
IS
   view_name_ VARCHAR2(30);
   app_owner_ VARCHAR2(30);
   CURSOR view_tables IS
      SELECT nvl(referenced_name,'') Name
         FROM   user_dependencies
         WHERE  referenced_owner = app_owner_
         AND    referenced_type = 'TABLE'
         AND    Name = view_name_
         AND    type = 'VIEW'
         UNION
         SELECT nvl(referenced_name,'') Name
         FROM   user_dependencies
         WHERE  referenced_owner = app_owner_
         AND    referenced_type = 'TABLE'
         AND    (Name = view_name_||'_API' OR Name = view_name_||'_CFP' OR Name = view_name_||'_CLP')
         AND    type = 'PACKAGE BODY'
         UNION
         SELECT nvl(table_name,'') Name
         FROM user_tables
         WHERE (table_name = view_name_||'_TAB' OR table_name = view_name_||'_CFT' OR table_name = view_name_||'_CLT');
BEGIN
   -- Check that inparameters make sense before proceeding.
   IF lu_name_ IS NULL THEN
      RETURN;
   END IF;

   app_owner_ := Fnd_Session_API.Get_App_Owner;
   view_name_ := Get_Base_View(lu_name_);
   FOR t IN view_tables LOOP
      table_list_ := table_list_||t.name||field_separator_;
   END LOOP;
END Get_Logical_Unit_Tables_;




-- Enum_Modules_
--   Returns a list of installed modules.
--   List is separated with field_separator_
@UncheckedAccess
PROCEDURE Enum_Modules_ (
   module_list_ OUT VARCHAR2 )
IS
   CURSOR modules IS
      SELECT DISTINCT module
      FROM   dictionary_sys_tab
      ORDER BY module;
BEGIN
   FOR module IN modules LOOP
      module_list_ := module_list_||module.module||field_separator_;
   END LOOP;
END Enum_Modules_;




@UncheckedAccess
PROCEDURE Enum_Module_Names_ (
   module_list_ OUT VARCHAR2,
   name_list_   OUT VARCHAR2 )
IS
   module_array_  object_array;
   name_array_    lu_struct_type;

   CURSOR modules IS
      SELECT module, Name
      FROM   module_tab
      ORDER BY Name;
BEGIN
   OPEN  modules;
   FETCH modules BULK COLLECT INTO module_array_, name_array_;
   CLOSE modules;
   IF module_array_.count > 0 THEN
      FOR i IN Nvl(module_array_.first, 0)..Nvl(module_array_.last, -1) LOOP
         module_list_ := module_list_||module_array_(i)||field_separator_;
         name_list_   := name_list_||name_array_(i)||field_separator_;
      END LOOP;
   END IF;
END Enum_Module_Names_;




@UncheckedAccess
PROCEDURE Enum_Module_All_Logical_Units_ (
   lu_list_ OUT VARCHAR2,
   module_  IN  VARCHAR2 )
IS
   lu_array_  object_array;

   CURSOR units IS
      SELECT lu_name
      FROM   dictionary_sys_tab
      WHERE  module = module_
      AND lu_type IN ('L', 'S')
      ORDER BY lu_name;
BEGIN
   OPEN  units;
   FETCH units BULK COLLECT INTO lu_array_;
   CLOSE units;
   IF lu_array_.count > 0 THEN
      FOR i IN Nvl(lu_array_.first, 0)..Nvl(lu_array_.last, -1) LOOP
         lu_list_ := lu_list_||lu_array_(i)||field_separator_;
      END LOOP;
   END IF;
END Enum_Module_All_Logical_Units_;




-- Enum_Module_Logical_Units_
--   Returns a list of installed logical units in a specific module.
--   List is separated with field_separator_
@UncheckedAccess
PROCEDURE Enum_Module_Logical_Units_ (
   lu_list_ OUT VARCHAR2,
   module_  IN  VARCHAR2 )
IS
   lu_array_  object_array;

   CURSOR units IS
      SELECT lu_name
      FROM   dictionary_sys_tab
      WHERE  module = module_
      AND lu_type = 'L'
      ORDER BY lu_name;
BEGIN
   OPEN  units;
   FETCH units BULK COLLECT INTO lu_array_;
   CLOSE units;
   IF lu_array_.count > 0 THEN
      FOR i IN Nvl(lu_array_.first, 0)..Nvl(lu_array_.last, -1) LOOP
         lu_list_ := lu_list_||lu_array_(i)||field_separator_;
      END LOOP;
   END IF;
END Enum_Module_Logical_Units_;


-- Enum_Reports_Module_Lu_
--   Returns a list of installed logical units in a specific module which
--   has reports.
--   List is separated with field_separator_
@UncheckedAccess
PROCEDURE Enum_Reports_Module_Lu_ (
   lu_list_ OUT VARCHAR2,
   module_  IN  VARCHAR2 )
IS
   lu_array_  object_array;

   CURSOR units IS
         SELECT distinct(s.lu_name)
         FROM   dictionary_sys_tab s, dictionary_sys_view_tab v
         WHERE  s.module = module_
         AND s.lu_type = 'L'
         and s.lu_name = v.lu_name
         and (v.view_name like '%_GRP' or v.view_name like '%_REP')
         ORDER BY lu_name;

BEGIN
   OPEN  units;
   FETCH units BULK COLLECT INTO lu_array_;
   CLOSE units;
   IF lu_array_.count > 0 THEN
      FOR i IN Nvl(lu_array_.first, 0)..Nvl(lu_array_.last, -1) LOOP
         lu_list_ := lu_list_||lu_array_(i)||field_separator_;
      END LOOP;
   END IF;
END Enum_Reports_Module_Lu_;


-- Enum_Module_System_Services_
--   Returns a list of installed system services in a specific module.
--   List is separated with field_separator_
@UncheckedAccess
PROCEDURE Enum_Module_System_Services_ (
   sys_list_ OUT VARCHAR2,
   module_   IN  VARCHAR2 )
IS
   CURSOR units IS
      SELECT lu_name
      FROM   dictionary_sys_tab
      WHERE  module = module_
      AND lu_type = 'S'
      ORDER BY lu_name;
BEGIN
   FOR unit IN units LOOP
      sys_list_ := sys_list_||unit.lu_name||field_separator_;
   END LOOP;
END Enum_Module_System_Services_;


-- Enum_Reports_Module_Sys_Serv_
--   Returns a list of installed system services in a specific module
--   which has reports.
--   List is separated with field_separator_
@UncheckedAccess
PROCEDURE Enum_Reports_Module_Sys_Serv_ (
   sys_list_ OUT VARCHAR2,
   module_   IN  VARCHAR2 )
IS
   CURSOR units IS
      SELECT distinct(s.lu_name)
         FROM   dictionary_sys_tab s, dictionary_sys_view_tab v
         WHERE  s.module = module_
         AND s.lu_type = 'S'
         and s.lu_name = v.lu_name
         and (v.view_name like '%_GRP' or v.view_name like '%_REP')
         ORDER BY lu_name;
BEGIN
   FOR unit IN units LOOP
      sys_list_ := sys_list_||unit.lu_name||field_separator_;
   END LOOP;
END Enum_Reports_Module_Sys_Serv_;


-- Rebuild_Dictionary_Storage_
--   Create contents of internal table for LU-dictionary by lookups in
--   Oracle system views. refresh_type_ can be the following:
--   PARTIAL  Refresh information only for objects changed after last refresh (default).
--   FULL     Remove all existing information before doing a complete lookup.
--   VIEWS    Partial refresh only for views.
--   PACKAGES Partial refresh only for packages.
PROCEDURE Rebuild_Dictionary_Storage_ (
   dummy_        IN NUMBER,
   refresh_mode_ IN VARCHAR2 DEFAULT 'PARTIAL' )
IS
   error_text_ CLOB;
BEGIN
   General_SYS.Check_Security(service_, 'DICTIONARY_SYS', 'Rebuild_Dictionary_Storage_');
   error_text_ := Rebuild_Dictionary_Storage___(refresh_mode_, FALSE);
END Rebuild_Dictionary_Storage_;


-- Rebuild_Dictionary_Storage_
--   Create contents of internal table for LU-dictionary by lookups in
--   Oracle system views. refresh_type_ can be the following:
--   PARTIAL  Refresh information only for objects changed after last refresh (default).
--   FULL     Remove all existing information before doing a complete lookup.
--   VIEWS    Partial refresh only for views.
--   PACKAGES Partial refresh only for packages.
PROCEDURE Rebuild_Dictionary_Storage_ (
   error_text_   IN OUT NOCOPY CLOB,
   dummy_        IN NUMBER,
   refresh_mode_ IN VARCHAR2 DEFAULT 'PARTIAL',
   cleanup_      IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DICTIONARY_SYS', 'Rebuild_Dictionary_Storage_');
   error_text_ := Rebuild_Dictionary_Storage___(refresh_mode_, TRUE, cleanup_);
END Rebuild_Dictionary_Storage_;


PROCEDURE Remove_Lu_(
	lu_name_   IN     VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DICTIONARY_SYS', 'Remove_Lu_');
	DELETE FROM dictionary_sys_package_tab
	   WHERE lu_name = lu_name_;

	DELETE FROM dictionary_sys_method_tab 
	   WHERE lu_name = lu_name_;

	DELETE FROM dictionary_sys_method_ext_tab 
	   WHERE lu_name = lu_name_;

	DELETE FROM dictionary_sys_view_tab 
	   WHERE lu_name = lu_name_;

	DELETE FROM dictionary_sys_view_column_tab 
	   WHERE lu_name = lu_name_;

	DELETE FROM dictionary_sys_state_tab
	   WHERE lu_name = lu_name_;

	DELETE FROM dictionary_sys_domain_tab
	   WHERE lu_name = lu_name_;

	DELETE FROM dictionary_sys_tab 
	   WHERE lu_name = lu_name_;

END Remove_Lu_;


-- Check_Dictionary_Storage_
--   Check whether a rebuild of the internal dictionary storage is
--   needed or not. Returns a boolean value (number) as an answer.
@UncheckedAccess
PROCEDURE Check_Dictionary_Storage_ (
   rebuild_needed_ OUT NUMBER,
   check_columns_  IN  VARCHAR2 DEFAULT 'TRUE' )
IS
   dummy_       NUMBER;
   last_update_ DATE;
   cache_rec_   Cache_Management_API.Public_Rec;

   CURSOR get_last_update IS
      SELECT max(rowversion)
      FROM dictionary_sys_package_tab;

   CURSOR get_last_view_update IS
      SELECT max(rowversion)
      FROM dictionary_sys_view_tab;

   CURSOR get_last_view_change (last_cache_update_ IN DATE) IS
      SELECT 1
      FROM user_objects
      WHERE object_type = 'VIEW'
      AND last_ddl_time >= last_cache_update_;

   CURSOR get_packages(last_cache_update_ IN DATE) IS
      SELECT 1
      FROM user_objects
      WHERE object_type = 'PACKAGE'
      AND timestamp > to_char(last_cache_update_, 'RRRR-MM-DD:HH24:MI:SS')
      AND substr(object_name, -4) IN ('_API', '_CFP', '_ICP', '_CLP', '_RPI', '_SYS', '_SCH', '_APN') -- Exclude projections (_SVC), and mobile utilities (_JSN, _TLM)
      AND status = 'VALID';
   app_owner_ VARCHAR2(30) := Fnd_Session_API.Get_App_Owner;
   CURSOR get_views IS
      SELECT 1
      FROM fnd_tab_comments ft
      WHERE ft.comments IS NOT NULL
      AND ft.table_name NOT LIKE 'AQ$%' -- Exclude Oracle Advance Queue views
      AND ft.table_type='VIEW'
      AND ft.comments != 'MODULE=IGNORE^'
      AND NOT EXISTS
      (SELECT 1
       FROM dictionary_sys_view_tab d
       WHERE ft.table_name=d.view_name
       AND ft.comments=d.view_comment)
      UNION
      SELECT 1
      FROM dictionary_sys_view_tab
      WHERE lu_name IN
      (SELECT lu_name
       FROM dictionary_sys_view_tab v
       WHERE view_type = 'B'
       AND (NOT EXISTS
       (SELECT 1
        FROM all_objects u
         WHERE u.object_name = v.view_name
         AND object_type = 'VIEW'
         AND owner = app_owner_)
       OR EXISTS
        (SELECT 1
         FROM fnd_tab_comments ft
         WHERE ft.table_name=v.view_name
         AND ft.comments!=v.view_comment)));
   CURSOR get_view_columns IS
      SELECT 1
      FROM fnd_col_comments fc, fnd_tab_comments ft
      WHERE ft.table_name NOT LIKE 'AQ$%' -- Exclude Oracle Advance Queue views
      AND fc.table_name=ft.table_name
      AND ft.table_type='VIEW'
      AND ft.comments != 'MODULE=IGNORE^'
      AND NVL(Dictionary_SYS.Comment_Value_('SERVER_ONLY', ft.comments), 'FALSE') = 'FALSE'
      AND NOT EXISTS
      (SELECT 1
       FROM dictionary_sys_view_column_tab d
       WHERE fc.table_name=d.view_name
       AND fc.column_name=d.column_name
       AND NVL(fc.comments, 'X#X')=NVL(d.column_comment, 'X#X'));
   PROCEDURE Refresh_Monitoring_Cache
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      Cache_Management_API.Refresh_Cache('DictionaryMonitoring');
      @ApproveTransactionStatement(2017-05-16,MABOSE)
      COMMIT;
   END Refresh_Monitoring_Cache;
   PROCEDURE Invalidate_Monitoring_Cache
   IS
      PRAGMA AUTONOMOUS_TRANSACTION;
   BEGIN
      Cache_Management_API.Invalidate_Cache('DictionaryMonitoring');
      @ApproveTransactionStatement(2017-05-16,MABOSE)
      COMMIT;
   END Invalidate_Monitoring_Cache;
BEGIN
   OPEN get_last_update;
   FETCH get_last_update INTO last_update_;
   CLOSE get_last_update;
   IF (last_update_ IS NULL) THEN
      rebuild_needed_ := 1;               -- Return TRUE
   ELSE
      OPEN get_packages(last_update_);
      FETCH get_packages INTO dummy_;
      IF (get_packages%NOTFOUND) THEN
         CLOSE get_packages;
         OPEN get_views;
         FETCH get_views INTO dummy_;
         IF (get_views%NOTFOUND) THEN
            CLOSE get_views;
            IF check_columns_ = 'TRUE' THEN
               cache_rec_ := Cache_Management_API.Get('DictionaryMonitoring');
               OPEN get_last_view_update;
               FETCH get_last_view_update INTO last_update_;
               CLOSE get_last_view_update;
               OPEN get_last_view_change(GREATEST(NVL(cache_rec_.refreshed, Database_SYS.Get_First_Calendar_Date), NVL(last_update_, Database_SYS.Get_First_Calendar_Date)));
               FETCH get_last_view_change INTO dummy_;
               IF get_last_view_change%FOUND THEN
                  CLOSE get_last_view_change;
                  OPEN get_view_columns;
                  FETCH get_view_columns INTO dummy_;
                  IF (get_view_columns%NOTFOUND) THEN
                     CLOSE get_view_columns;
                     rebuild_needed_ := 0;            -- Return FALSE
                     Refresh_Monitoring_Cache;
                  ELSE
                     CLOSE get_view_columns;
                     Refresh_Monitoring_Cache;
                     Invalidate_Monitoring_Cache;
                     rebuild_needed_ := 1;            -- Return TRUE
                  END IF;
               ELSE
                  CLOSE get_last_view_change;
                  IF NVL(cache_rec_.refreshed, Database_SYS.Get_First_Calendar_Date) > NVL(last_update_, Database_SYS.Get_First_Calendar_Date) THEN
                     IF cache_rec_.invalidated IS NULL THEN
                        rebuild_needed_ := 0;            -- Return FALSE
                        Refresh_Monitoring_Cache;
                     ELSE
                        rebuild_needed_ := 1;            -- Return TRUE
                     END IF;
                  ELSE
                     rebuild_needed_ := 0;            -- Return FALSE
                     Refresh_Monitoring_Cache;
                  END IF;
               END IF;
            ELSE
               rebuild_needed_ := 0;            -- Return FALSE
            END IF;
         ELSE
            CLOSE get_views;
            rebuild_needed_ := 1;            -- Return TRUE
         END IF;
      ELSE
         CLOSE get_packages;
         rebuild_needed_ := 1;            -- Return TRUE
      END IF;
   END IF;
END Check_Dictionary_Storage_;

@UncheckedAccess
FUNCTION Check_Dictionary_Storage_ (
   check_columns_ IN VARCHAR2 DEFAULT 'TRUE') RETURN NUMBER
IS
   rebuild_needed_       NUMBER;
BEGIN
   Check_Dictionary_Storage_(rebuild_needed_, check_columns_);
   RETURN rebuild_needed_;
END Check_Dictionary_Storage_;

@UncheckedAccess
FUNCTION Get_State_Decode_Method_ (
   view_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
    RETURN(Check_Method_From_View___(view_name_, 'FINITE_STATE_DECODE__'));
END Get_State_Decode_Method_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Objkey_Info (
   lu_name_ IN VARCHAR2,
   guid_as_null_ BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   CURSOR get_lu IS
      SELECT objkey
      FROM   dictionary_sys_tab
      WHERE  lu_name = lu_name_;
   objkey_  dictionary_sys_tab.objkey%TYPE;
BEGIN
   OPEN  get_lu;
   FETCH get_lu INTO objkey_;
   CLOSE get_lu;
   IF guid_as_null_
   AND objkey_ = 'GUID' THEN
      objkey_ := NULL;
   END IF;
   RETURN objkey_;
END Get_Objkey_Info;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Objkey_Info_Active (
   lu_name_      IN VARCHAR2,
   guid_as_null_ BOOLEAN DEFAULT FALSE ) RETURN VARCHAR2
IS
   CURSOR get_lu IS
      SELECT d.objkey
        FROM dictionary_sys_tab d, module_tab m
       WHERE d.lu_name = lu_name_
         AND d.module = m.module
         AND m.active = 'TRUE';
   objkey_  dictionary_sys_tab.objkey%TYPE;
BEGIN
   OPEN  get_lu;
   FETCH get_lu INTO objkey_;
   CLOSE get_lu;
   IF guid_as_null_ AND objkey_ = 'GUID' THEN
      objkey_ := NULL;
   END IF;
   RETURN objkey_;
END Get_Objkey_Info_Active;


@UncheckedAccess
FUNCTION Exists (
   lu_name_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER;
   CURSOR get_lu IS
      SELECT 1
      FROM   dictionary_sys_tab
      WHERE  lu_name = lu_name_;
BEGIN
   OPEN  get_lu;
   FETCH get_lu INTO dummy_;
   IF (get_lu%FOUND) THEN
      CLOSE get_lu;
      RETURN TRUE;
   ELSE
      CLOSE get_lu;
      RETURN FALSE;
   END IF;
END Exists;

--SOLSETFW
FUNCTION Is_Module_Active___ (
   lu_name_ IN VARCHAR2) RETURN BOOLEAN 
IS
   str_active_ VARCHAR2(5);
BEGIN
   SELECT m.active INTO str_active_
     FROM dictionary_sys_tab s, module_tab m
    WHERE s.module = m.module
      AND s.lu_name = lu_name_;
   RETURN (str_active_ = 'TRUE');
EXCEPTION
   WHEN OTHERS THEN
      RETURN FALSE;
END Is_Module_Active___;
   
FUNCTION Get_Resolved_Base_View_(
   entity_name_ VARCHAR2) RETURN VARCHAR2 
IS
   base_view_           VARCHAR2(30); 
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      IF Custom_Fields_SYS.Has_Custom_Objects(entity_name_,'CUSTOM_FIELD') = Fnd_Boolean_API.DB_TRUE THEN 
         base_view_ := Custom_Fields_API.Get(entity_name_, 'CUSTOM_FIELD').view_name; 
      ELSE
         base_view_ := Dictionary_SYS.Get_Base_View(entity_name_);
      END IF;
   $ELSE
      base_view_ := Dictionary_SYS.Get_Base_View(entity_name_);
   $END
   RETURN base_view_;
END Get_Resolved_Base_View_;

-- Get_Base_View
--   Finds the base view for a logical unit, according to naming conventions.
--   If no view corresponds to the naming convention, the first view installed
--   for this logical unit will be considered the main view. Logical unit name
--   is case sensitive.
@UncheckedAccess
FUNCTION Get_Base_View (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'BASE VIEW';
   temp_             VARCHAR2(30);
   
   CURSOR get_view IS
      SELECT view_name
      FROM   dictionary_sys_view_tab
      WHERE lu_name = lu_name_
      AND view_type = 'B';
BEGIN
   temp_ := Get_Cache_Value___(cache_category_, lu_name_);
   IF (temp_ IS NULL) THEN       
      OPEN get_view;
      FETCH get_view INTO temp_;
      CLOSE get_view;
      temp_ := Nvl(temp_, CASE Installation_SYS.View_Exist(Dictionary_SYS.Clientnametodbname_(lu_name_)) 
                          WHEN TRUE THEN 
                             Dictionary_SYS.Clientnametodbname_(lu_name_)
                          ELSE 
                             NULL
                          END);
      Set_Cache_Value___(cache_category_, lu_name_, temp_);   
   END IF;
   RETURN temp_;
END Get_Base_View;

--SOLSETFW
-- Get_Base_View_Active
--   Finds the base view for an active logical unit, according to naming conventions.
--   If no view corresponds to the naming convention, the first view installed
--   for this logical unit will be considered the main view. Logical unit name
--   is case sensitive.
@UncheckedAccess
FUNCTION Get_Base_View_Active (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'BASE VIEW';
   temp_             VARCHAR2(30);
   
   CURSOR get_view IS
      SELECT view_name
      FROM   dictionary_sys_view_tab
      WHERE lu_name = lu_name_
      AND view_type = 'B';
BEGIN
   temp_ := Get_Cache_Value___(cache_category_, lu_name_);
   IF (temp_ IS NULL) THEN
      IF NOT Is_Module_Active___(lu_name_) THEN
         RETURN NULL;
      END IF;
      OPEN get_view;
      FETCH get_view INTO temp_;
      CLOSE get_view;
      temp_ := Nvl(temp_, CASE Installation_SYS.View_Active(Dictionary_SYS.Clientnametodbname_(lu_name_)) 
                          WHEN TRUE THEN 
                             Dictionary_SYS.Clientnametodbname_(lu_name_)
                          ELSE 
                             NULL
                          END);
      Set_Cache_Value___(cache_category_, lu_name_, temp_);   
   END IF;
   RETURN temp_;
END Get_Base_View_Active;


@UncheckedAccess
FUNCTION Get_Base_Package (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Base_Package___(lu_name_);
END Get_Base_Package;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Base_Package_Active (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Base_Package___(lu_name_,'TRUE');
END Get_Base_Package_Active;


@UncheckedAccess
FUNCTION Get_Base_Package_Of_Type (
   lu_name_ IN VARCHAR2,
   type_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Base_Package_Of_Type___(lu_name_, type_);
END Get_Base_Package_Of_Type;


@UncheckedAccess
FUNCTION Get_Base_Table_Name (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Base_Table_Name___(lu_name_);
END Get_Base_Table_Name;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Base_Table_Name_Active (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Base_Table_Name___(lu_name_,'TRUE');
END Get_Base_Table_Name_Active;


-- Get_Component
--   Returns the component shortname for a package or a view.
--   Types can be 'VIEW' or 'PACKAGE'. Name is not case sensitive.
@UncheckedAccess
FUNCTION Get_Component (
   object_name_ IN VARCHAR2,
   object_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Component___(object_name_, object_type_);
END Get_Component;


--SOLSETFW
-- Get_Component_Active
--   Returns the component shortname for an active package or an active view.
--   Types can be 'VIEW' or 'PACKAGE'. Name is not case sensitive.
@UncheckedAccess
FUNCTION Get_Component_Active (
   object_name_ IN VARCHAR2,
   object_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS 
BEGIN
   RETURN Get_Component___(object_name_, object_type_,'TRUE');
END Get_Component_Active;


-- Get_Logical_Unit
--   Returns the logical unit name for a package or a view.
--   Types can be 'VIEW' or 'PACKAGE'. Name is not case sensitive.
@UncheckedAccess
FUNCTION Get_Logical_Unit (
   object_name_ IN VARCHAR2,
   object_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_name_ VARCHAR2(30);
   CURSOR get_pkg_lu IS
      SELECT lu_name
      FROM   dictionary_sys_package_tab
      WHERE  package_name = upper(object_name_);

   CURSOR get_view_lu IS
      SELECT lu_name
      FROM   dictionary_sys_view_tab
      WHERE  view_name = upper(object_name_);
BEGIN
   IF upper(object_type_) = 'PACKAGE' THEN
      OPEN get_pkg_lu;
      FETCH get_pkg_lu INTO lu_name_;
      CLOSE get_pkg_lu;
   ELSIF upper(object_type_) = 'VIEW' THEN
      OPEN get_view_lu;
      FETCH get_view_lu INTO lu_name_;
      CLOSE get_view_lu;
   ELSE
      lu_name_ := NULL;
   END IF;
   RETURN lu_name_;
END Get_Logical_Unit;


--SOLSETFW
-- Get_Logical_Unit_Active
--   Returns the logical unit name for an active package or an active view.
--   Types can be 'VIEW' or 'PACKAGE'. Name is not case sensitive.
@UncheckedAccess
FUNCTION Get_Logical_Unit_Active (
   object_name_ IN VARCHAR2,
   object_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_name_ VARCHAR2(30);
   CURSOR get_pkg_lu IS
      SELECT p.lu_name
        FROM dictionary_sys_package_tab p, module_tab m, dictionary_sys_tab d
       WHERE p.package_name = UPPER(object_name_)
         AND d.module = m.module
         AND p.lu_name = d.lu_name
         AND m.active = 'TRUE';

   CURSOR get_view_lu IS
      SELECT v.lu_name
        FROM dictionary_sys_view_tab v, module_tab m, dictionary_sys_tab d
       WHERE v.view_name = UPPER(object_name_)
         AND d.module = m.module
         AND v.lu_name = d.lu_name
         AND m.active = 'TRUE';
BEGIN
   IF upper(object_type_) = 'PACKAGE' THEN
      OPEN get_pkg_lu;
      FETCH get_pkg_lu INTO lu_name_;
      CLOSE get_pkg_lu;
   ELSIF upper(object_type_) = 'VIEW' THEN
      OPEN get_view_lu;
      FETCH get_view_lu INTO lu_name_;
      CLOSE get_view_lu;
   ELSE
      lu_name_ := NULL;
   END IF;
   RETURN lu_name_;
END Get_Logical_Unit_Active;


@UncheckedAccess
FUNCTION Get_Logical_Unit_Type (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_                   VARCHAR2(32000);
   lu_type_                VARCHAR2(100);
   package_name_  CONSTANT VARCHAR2(100) := Dictionary_SYS.Get_Base_Package(lu_name_);
BEGIN
--   Assert_SYS.Assert_Is_Package(package_name_);
   stmt_ := 'BEGIN '||
            '   :lu_type := '||package_name_||'.lu_type_; '||
            'END;';
   @ApproveDynamicStatement(2011-05-30,haarse)
   EXECUTE IMMEDIATE stmt_ USING OUT lu_type_;
   RETURN(lu_type_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN(NULL);
END Get_Logical_Unit_Type;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Logical_Unit_Type_Active (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_                   VARCHAR2(32000);
   lu_type_                VARCHAR2(100) := NULL;
   package_name_  CONSTANT VARCHAR2(100) := Dictionary_SYS.Get_Base_Package_Active(lu_name_);
BEGIN
   IF package_name_ IS NOT NULL THEN
      stmt_ := 'BEGIN '||
               '   :lu_type := '||package_name_||'.lu_type_; '||
               'END;';
      @ApproveDynamicStatement(2020-10-07,NaBaLK)
      EXECUTE IMMEDIATE stmt_ USING OUT lu_type_;
   END IF;
   RETURN lu_type_;
EXCEPTION
   WHEN OTHERS THEN
      RETURN NULL;
END Get_Logical_Unit_Type_Active;


@UncheckedAccess
FUNCTION Get_Table_Column_Impl (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   table_column_name_  Dictionary_Sys_View_Column_Tab.Table_Column_Name%TYPE;

   CURSOR get_dict IS
      SELECT t.objid, t.objversion, t.objstate
      FROM dictionary_sys_tab t
      WHERE lu_name = Dictionary_SYS.Get_Logical_Unit(UPPER(view_name_), 'VIEW');

   CURSOR get_colname IS
      SELECT table_column_name
      FROM dictionary_sys_view_column_tab
      WHERE view_name = UPPER(view_name_)
      AND column_name = upper(column_name_);
BEGIN
   IF column_name_ IN ('OBJID', 'OBJVERSION', 'OBJKEY', 'OBJSTATE') THEN
      FOR rec IN get_dict LOOP
         CASE column_name_
            WHEN 'OBJID' THEN
               table_column_name_ := Nvl(rec.objid, 'ROWID');
            WHEN 'OBJVERSION' THEN
               table_column_name_ := Nvl(rec.objversion, 'to_char(ROWVERSION,''YYYYMMDDHH24MISS'')'); --TODO: This is wrong!
            WHEN 'OBJKEY' THEN
               table_column_name_ := 'ROWKEY';
            WHEN 'OBJSTATE' THEN
               table_column_name_ := nvl(rec.objstate, 'ROWSTATE');
         END CASE;
      END LOOP;
   ELSE
      OPEN  get_colname;
      FETCH get_colname INTO table_column_name_;
      CLOSE get_colname;
   END IF;
   RETURN(table_column_name_);
END Get_Table_Column_Impl;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Table_Column_Impl_Active (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   table_column_name_  Dictionary_Sys_View_Column_Tab.Table_Column_Name%TYPE;

   CURSOR get_dict IS
      SELECT d.objid, d.objversion, d.objstate
        FROM dictionary_sys_tab d, module_tab m
       WHERE d.lu_name = Dictionary_SYS.Get_Logical_Unit_Active(UPPER(view_name_), 'VIEW')
         AND d.module = m.module
         AND m.active = 'TRUE';

   CURSOR get_colname IS
      SELECT v.table_column_name
        FROM dictionary_sys_view_column_tab v, module_tab m, dictionary_sys_tab d
       WHERE v.view_name = UPPER(view_name_)
         AND column_name = UPPER(column_name_)
         AND d.module = m.module
         AND v.lu_name = d.lu_name
         AND m.active = 'TRUE';
BEGIN
   IF column_name_ IN ('OBJID', 'OBJVERSION', 'OBJKEY', 'OBJSTATE') THEN
      FOR rec IN get_dict LOOP
         CASE column_name_
            WHEN 'OBJID' THEN
               table_column_name_ := Nvl(rec.objid, 'ROWID');
            WHEN 'OBJVERSION' THEN
               table_column_name_ := Nvl(rec.objversion, 'to_char(ROWVERSION,''YYYYMMDDHH24MISS'')'); --TODO: This is wrong!
            WHEN 'OBJKEY' THEN
               table_column_name_ := 'ROWKEY';
            WHEN 'OBJSTATE' THEN
               table_column_name_ := nvl(rec.objstate, 'ROWSTATE');
         END CASE;
      END LOOP;
   ELSE
      OPEN  get_colname;
      FETCH get_colname INTO table_column_name_;
      CLOSE get_colname;
   END IF;
   RETURN(table_column_name_);
END Get_Table_Column_Impl_Active;


@UncheckedAccess
FUNCTION Get_Lu_Table_Column_Impl (
   lu_name_     IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Return(Get_Table_Column_Impl(Get_Base_View(lu_name_), column_name_));
END Get_Lu_Table_Column_Impl;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Lu_Table_Column_Impl_Act (
   lu_name_     IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Return(Get_Table_Column_Impl_Active(Get_Base_View_Active(lu_name_), column_name_));
END Get_Lu_Table_Column_Impl_Act;


@UncheckedAccess
FUNCTION Get_Reference_Base (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'REFERENCE BASE';
   ref_base_         VARCHAR2(30);
   
   CURSOR get_ref IS
   SELECT refbase
   FROM dictionary_sys_tab t
   WHERE lu_name = lu_name_;
BEGIN
   IF lu_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   ref_base_ := Get_Cache_Value___(cache_category_, lu_name_);
   IF (ref_base_ IS NULL) THEN       
      OPEN  get_ref;
      FETCH get_ref INTO ref_base_;
      IF get_ref%NOTFOUND THEN
         CLOSE get_ref;
         RETURN(NULL);
      ELSE
         ref_base_ := (Nvl(Upper(ref_base_), 'TABLE'));
         Set_Cache_Value___(cache_category_, lu_name_, ref_base_);
         CLOSE get_ref;
      END IF;
   END IF;
   RETURN ref_base_;
END Get_Reference_Base;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Reference_Base_Active (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cache_category_   CONSTANT VARCHAR2(1000) := 'REFERENCE BASE';
   ref_base_         VARCHAR2(30);
   
   CURSOR get_ref IS
   SELECT d.refbase
     FROM dictionary_sys_tab d, module_tab m
    WHERE d.lu_name = lu_name_
      AND d.module = m.module
      AND m.active = 'TRUE';
BEGIN
   IF lu_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   ref_base_ := Get_Cache_Value___(cache_category_, lu_name_);
   IF (ref_base_ IS NULL) THEN       
      OPEN  get_ref;
      FETCH get_ref INTO ref_base_;
      IF get_ref%NOTFOUND THEN
         CLOSE get_ref;
         RETURN(NULL);
      ELSE
         ref_base_ := (Nvl(Upper(ref_base_), 'TABLE'));
         Set_Cache_Value___(cache_category_, lu_name_, ref_base_);
         CLOSE get_ref;
      END IF;
   END IF;
   RETURN ref_base_;
END Get_Reference_Base_Active;


@UncheckedAccess
FUNCTION Get_Logical_Unit_Module (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   module_ VARCHAR2(6);
   CURSOR get_module IS
      SELECT module
      FROM   dictionary_sys_tab
      WHERE  lu_name = lu_name_;
BEGIN
   OPEN  get_module;
   FETCH get_module INTO module_;
   CLOSE get_module;
   RETURN module_;
END Get_Logical_Unit_Module;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Logical_Unit_Module_Active (
   lu_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   module_ VARCHAR2(6);
   CURSOR get_module IS
      SELECT d.module
        FROM dictionary_sys_tab d, module_tab m
       WHERE lu_name = lu_name_
         AND d.module = m.module
         AND m.active = 'TRUE';
BEGIN
   OPEN  get_module;
   FETCH get_module INTO module_;
   CLOSE get_module;
   RETURN module_;
END Get_Logical_Unit_Module_Active ;


@UncheckedAccess
FUNCTION Get_Dictionary_Record (
   lu_name_ IN VARCHAR2 ) RETURN dictionary_sys_tab%ROWTYPE
IS
   dic_rec_ dictionary_sys_tab%ROWTYPE;
BEGIN
   IF (lu_name_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT *
      INTO   dic_rec_
      FROM   dictionary_sys_tab
      WHERE  lu_name = lu_name_;
   RETURN dic_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Dictionary_Record;

--SOLSETFW
@UncheckedAccess
FUNCTION Get_Dictionary_Record_Active (
   lu_name_ IN VARCHAR2 ) RETURN dictionary_sys_tab%ROWTYPE
IS
   dic_rec_ dictionary_sys_tab%ROWTYPE;
BEGIN
   IF (lu_name_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT d.*
     INTO dic_rec_
     FROM dictionary_sys_tab d, module_tab m
    WHERE lu_name = lu_name_
      AND d.module = m.module
      AND m.active = 'TRUE';
      
   RETURN dic_rec_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Dictionary_Record_Active;


@UncheckedAccess
FUNCTION Get_Enumeration_Lu (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enum_lu_    VARCHAR2(30);
   
   CURSOR get_enum IS
      SELECT enumeration
      FROM   dictionary_sys_view_column_tab
      WHERE  view_name = Upper(view_name_)
      AND    column_name = Upper(column_name_);
BEGIN
   OPEN  get_enum;
   FETCH get_enum INTO enum_lu_;
   CLOSE get_enum;
   RETURN(enum_lu_);
END Get_Enumeration_Lu;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Enumeration_Lu_Active (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enum_lu_    VARCHAR2(30);
   
   CURSOR get_enum IS
      SELECT enumeration
        FROM dictionary_sys_view_column_tab v, module_tab m, dictionary_sys_tab d
       WHERE v.view_name = UPPER(view_name_)
         AND column_name = UPPER(column_name_)
         AND d.module = m.module
         AND v.lu_name = d.lu_name
         AND m.active = 'TRUE';
BEGIN
   OPEN  get_enum;
   FETCH get_enum INTO enum_lu_;
   CLOSE get_enum;
   RETURN(enum_lu_);
END Get_Enumeration_Lu_Active;


@UncheckedAccess
FUNCTION Get_Lookup_Lu (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   look_lu_    VARCHAR2(30);
   
   CURSOR get_lookup IS
      SELECT lookup
      FROM   dictionary_sys_view_column_tab
      WHERE  view_name = Upper(view_name_)
      AND    NVL(table_column_name, column_name) = Upper(column_name_);
BEGIN
   OPEN  get_lookup;
   FETCH get_lookup INTO look_lu_;
   CLOSE get_lookup;
   RETURN(look_lu_);
END Get_Lookup_Lu;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Lookup_Lu_Active (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   look_lu_    VARCHAR2(30);
   
   CURSOR get_lookup IS
      SELECT lookup
        FROM dictionary_sys_view_column_tab v, module_tab m, dictionary_sys_tab d
       WHERE v.view_name = UPPER(view_name_)
         AND NVL(table_column_name, column_name) = UPPER(column_name_)
         AND d.module = m.module
         AND v.lu_name = d.lu_name
         AND m.active = 'TRUE';
BEGIN
   OPEN  get_lookup;
   FETCH get_lookup INTO look_lu_;
   CLOSE get_lookup;
   RETURN(look_lu_);
END Get_Lookup_Lu_Active;


--- Checks if the given column is a lookup list column
@UncheckedAccess
FUNCTION Is_Lookup_List_Column (
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   data_type_    VARCHAR2(30);
BEGIN
   SELECT column_datatype
   INTO data_type_
   FROM   dictionary_sys_view_column_tab
   WHERE  view_name = Upper(view_name_)
   AND    NVL(table_column_name, column_name) = Upper(column_name_);
   RETURN REGEXP_LIKE(data_type_,'./LIST');
EXCEPTION
   WHEN OTHERS THEN
      RETURN FALSE;
END Is_Lookup_List_Column;


@UncheckedAccess
FUNCTION Check_Custom_Object (
   lu_ IN VARCHAR2 ) RETURN BOOLEAN 
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN(Custom_Fields_SYS.Check_Custom_Object(lu_));
$ELSE
   RETURN(TRUE);
$END
END Check_Custom_Object;


@UncheckedAccess
FUNCTION Has_Custom_Objects (
   lu_      IN VARCHAR2,
   lu_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN(Custom_Fields_SYS.Has_Custom_Objects(lu_, lu_type_));
$ELSE
   RETURN(Fnd_Boolean_API.DB_FALSE);
$END
END Has_Custom_Objects;




-- Package_Is_Installed
--   Returns TRUE if the package is installed in the database, else FALSE.
--   Package name is not case sensitive.
@UncheckedAccess
FUNCTION Package_Is_Installed (
   package_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_pkg IS
      SELECT 1
      FROM   dictionary_sys_package_tab
      WHERE  package_name = upper(package_name_);
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.Package_Exist(package_name_));
   ELSE
      OPEN  get_pkg;
      FETCH get_pkg INTO dummy_;
      IF (get_pkg%FOUND) THEN
         CLOSE get_pkg;
         RETURN TRUE;
      ELSE
         CLOSE get_pkg;
         RETURN FALSE;
      END IF;
   END IF;
END Package_Is_Installed;


-- Package_Is_Active
--   Returns TRUE if the package is active in the database, else FALSE.
--   Package name is not case sensitive.
@UncheckedAccess
FUNCTION Package_Is_Active (
   package_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_active_pkg IS
   SELECT 1
      FROM dictionary_sys_package_Tab v, module_tab m, dictionary_sys_Tab d
      WHERE v.package_name = UPPER(package_name_)
      AND d.module = m.module
      AND v.lu_name = d.lu_name
      AND m.active = 'TRUE'
      UNION
      SELECT 2
      FROM user_objects u
      WHERE object_name IN (UPPER(package_name_), package_name_)
      AND   object_type = UPPER('PACKAGE')
      AND NOT EXISTS 
      (SELECT 1
      FROM dictionary_sys_package_Tab d
      WHERE d.package_name = u.object_name);       
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.Package_Active(package_name_));
   ELSE
      OPEN  get_active_pkg;
      FETCH get_active_pkg INTO dummy_;
      IF (get_active_pkg%FOUND) THEN
         CLOSE get_active_pkg;
         RETURN TRUE;
      ELSE
         CLOSE get_active_pkg;
         RETURN FALSE;
      END IF;
   END IF;
END Package_Is_Active;

-- Method_Is_Installed
--   Returns TRUE if the method is installed in the database, else FALSE.
--   Method name is not case sensitive.
@UncheckedAccess
FUNCTION Method_Is_Installed (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_method IS
      SELECT 1
      FROM   dictionary_sys_method_tab
      WHERE  package_name = upper(package_name_)
      AND    method_name  = initcap(method_name_);
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.Method_Exist(package_name_, method_name_));
   ELSE
      OPEN  get_method;
      FETCH get_method INTO dummy_;
      IF (get_method%FOUND) THEN
         CLOSE get_method;
         RETURN TRUE;
      ELSE
         CLOSE get_method;
         RETURN FALSE;
      END IF;
   END IF;
END Method_Is_Installed;


-- Method_Is_Active
--   Returns TRUE if the method is active in the database, else FALSE.
--   Method name is not case sensitive.
@UncheckedAccess
FUNCTION Method_Is_Active (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_active_method IS
   SELECT 1
      FROM dictionary_sys_method_Tab v, module_tab m, dictionary_sys_Tab d
      WHERE UPPER(v.package_name) = UPPER(package_name_)
      AND UPPER(v.method_name) = UPPER(method_name_)
      AND d.module = m.module
      AND v.lu_name = d.lu_name
      AND m.active = 'TRUE'
      UNION
      SELECT 2
      FROM user_procedures u
      WHERE u.object_name = UPPER(package_name_)
      AND   u.procedure_name = UPPER(method_name_)
      AND NOT EXISTS 
      (SELECT 1
      FROM dictionary_sys_method_tab d
      WHERE UPPER(d.package_name) = u.object_name
      AND   UPPER(d.method_name) = u.procedure_name);       
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.Method_Active(package_name_, method_name_));
   ELSE
         OPEN  get_active_method;
         FETCH get_active_method INTO dummy_;
         IF (get_active_method%FOUND) THEN
            CLOSE get_active_method;
            RETURN TRUE;
         ELSE
            CLOSE get_active_method;
            RETURN FALSE;
         END IF;
   END IF;
END Method_Is_Active;




-- View_Is_Installed
--   Returns TRUE if the method is installed in the database, else FALSE.
--   View name is not case sensitive.
@UncheckedAccess
FUNCTION View_Is_Installed (
   view_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_view IS
      SELECT 1
      FROM   dictionary_sys_view_tab
      WHERE  view_name = upper(view_name_);
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.View_Exist(view_name_));
   ELSE
      OPEN  get_view;
      FETCH get_view INTO dummy_;
      IF (get_view%FOUND) THEN
         CLOSE get_view;
         RETURN TRUE;
      ELSE
         CLOSE get_view;
         RETURN FALSE;
      END IF;
   END IF;
END View_Is_Installed;


-- View_Is_Active
--   Returns TRUE if the method is active in the database, else FALSE.
--   View name is not case sensitive.
@UncheckedAccess
FUNCTION View_Is_Active (
   view_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_active_view IS
   SELECT 1
      FROM dictionary_sys_view_Tab v, module_tab m, dictionary_sys_Tab d
      WHERE v.view_name = UPPER(view_name_)
      AND d.module = m.module
      AND v.lu_name = d.lu_name
      AND m.active = 'TRUE'
      UNION
      SELECT 2
      FROM user_views u
      WHERE u.view_name = UPPER(view_name_)
      AND NOT EXISTS 
         (SELECT 1
          FROM dictionary_sys_view_Tab d
          WHERE d.view_name = u.view_name);      
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.View_Active(view_name_));
   ELSE
      OPEN  get_active_view;
      FETCH get_active_view INTO dummy_;
      IF (get_active_view%FOUND) THEN
         CLOSE get_active_view;
         RETURN TRUE;
      ELSE
         CLOSE get_active_view;
         RETURN FALSE;
      END IF;
   END IF;  
END View_Is_Active;




-- Logical_Unit_Is_Installed
--   Returns TRUE if the logical unit is installed in the database,
--   else FALSE. Logical unit name is case sensitive.
@UncheckedAccess
FUNCTION Logical_Unit_Is_Installed (
   lu_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER;
   CURSOR get_lu IS
      SELECT 1
      FROM   dictionary_sys_tab
      WHERE  lu_name = lu_name_;
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.Package_Exist(Get_Base_Package(lu_name_)));
   ELSE
      OPEN  get_lu;
      FETCH get_lu INTO dummy_;
      IF (get_lu%FOUND) THEN
         CLOSE get_lu;
         RETURN TRUE;
      ELSE
         CLOSE get_lu;
         RETURN FALSE;
      END IF;
   END IF;
END Logical_Unit_Is_Installed;

-- Logical_Unit_Is_Active
--   Returns TRUE if the logical unit is active in the database,
--   else FALSE. Logical unit name is case sensitive.
@UncheckedAccess
FUNCTION Logical_Unit_Is_Active (
   lu_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_          NUMBER;
   CURSOR get_active IS
      SELECT 1
      FROM dictionary_sys_tab d, module_tab m
      WHERE d.lu_name = lu_name_
      AND d.module = m.module
      AND m.active = 'TRUE'; 
BEGIN
   -- Reroute to Database_SYS during installation
   IF Get_Installation_Mode THEN
      RETURN(Database_SYS.Package_Active(Get_Base_Package(lu_name_)));
   ELSE
      OPEN get_active;
      FETCH  get_active INTO dummy_;
      IF (get_active%FOUND) THEN
         CLOSE get_active;
         RETURN TRUE;
      ELSE
         CLOSE get_active;
         RETURN FALSE;
      END IF;
   END IF; 
END Logical_Unit_Is_Active;


-- Component_Is_Installed
--   Returns TRUE if the component is installed in the database,
--   else FALSE. Uses information in LU Module and does not require the
--   dictionary cache to be up to date. If version is not given,
--   this parameter will be ignored. Component name is not case sensitive.
@UncheckedAccess
FUNCTION Component_Is_Installed (
   component_ IN VARCHAR2,
   version_   IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_component IS
      SELECT 1
      FROM   module_tab
      WHERE  module = upper(component_)
      AND  ((upper(version) LIKE nvl(upper(version_), '%')
      AND    version_ IS NOT NULL)
      OR    (version IS NOT NULL
      AND    version NOT IN ('?', '*')
      AND    version_ IS NULL));
BEGIN
   IF component_ = 'ENTEDITION' THEN
      RETURN Component_Entedition_SYS.INSTALLED;
   END IF;
   IF component_ = 'INMEMORY' THEN
      RETURN Is_Db_Inmemory_Supported;
   END IF;
   OPEN  get_component;
   FETCH get_component INTO dummy_;
   IF (get_component%FOUND) THEN
      CLOSE get_component;
      RETURN TRUE;
   ELSE
      CLOSE get_component;
      RETURN FALSE;
   END IF;
END Component_Is_Installed;

-- Component_Is_Active
--   Returns TRUE if the component is active in the database,
--   else FALSE. Uses information in LU Module and does not require the
--   dictionary cache to be up to date. If version is not given,
--   this parameter will be ignored. Component name is not case sensitive.
@UncheckedAccess
FUNCTION Component_Is_Active (
   component_ IN VARCHAR2,
   version_   IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_component IS
      SELECT 1
      FROM   module_tab
      WHERE  module = upper(component_)
      AND  ((upper(version) LIKE nvl(upper(version_), '%')
      AND    version_ IS NOT NULL)
      OR    (version IS NOT NULL
      AND    version NOT IN ('?', '*')
      AND    version_ IS NULL))
      AND    active = 'TRUE';
BEGIN
   IF component_ = 'ENTEDITION' THEN
      RETURN Component_Entedition_SYS.INSTALLED;
   END IF;
   IF component_ = 'INMEMORY' THEN
      RETURN Is_Db_Inmemory_Supported;
   END IF;
   OPEN  get_component;
   FETCH get_component INTO dummy_;
   IF (get_component%FOUND) THEN
      CLOSE get_component;
      RETURN TRUE;
   ELSE
      CLOSE get_component;
      RETURN FALSE;
   END IF;
END Component_Is_Active;

FUNCTION Is_Db_Inmemory_Supported RETURN BOOLEAN
IS
   module_installed_ v$option.value%TYPE;
BEGIN
   SELECT value
   INTO module_installed_
   FROM v$option
   WHERE UPPER(parameter) = 'IN-MEMORY COLUMN STORE';
   IF module_installed_ = 'TRUE' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
END Is_Db_Inmemory_Supported;



-- Package_Is_Installed_Num
--   Returns 1 if the package is installed in the database, else 0.
--   Package name is not case sensitive.
@UncheckedAccess
FUNCTION Package_Is_Installed_Num (
   package_name_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Package_Is_Installed(package_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Package_Is_Installed_Num;

-- Package_Is_Active_Num
--   Returns 1 if the package is active in the database, else 0.
--   Package name is not case sensitive.
@UncheckedAccess
FUNCTION Package_Is_Active_Num (
   package_name_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF Package_Is_Active(package_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Package_Is_Active_Num;




-- Method_Is_Installed_Num
--   Returns 1 if the method is installed in the database, else 0.
--   Method name is not case sensitive.
@UncheckedAccess
FUNCTION Method_Is_Installed_Num (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Method_Is_Installed(package_name_, method_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Method_Is_Installed_Num;

-- Method_Is_Active_Num
--   Returns 1 if the method is active in the database, else 0.
--   Method name is not case sensitive.
@UncheckedAccess
FUNCTION Method_Is_Active_Num (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF Method_Is_Active(package_name_, method_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Method_Is_Active_Num;




-- View_Is_Installed_Num
--   Returns 1 if the method is installed in the database, else 0.
--   View name is not case sensitive.
@UncheckedAccess
FUNCTION View_Is_Installed_Num (
   view_name_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF View_Is_Installed(view_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END View_Is_Installed_Num;

-- View_Is_Active_Num
--   Returns 1 if the method is active in the database, else 0.
--   View name is not case sensitive.
@UncheckedAccess
FUNCTION View_Is_Active_Num (
   view_name_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF View_Is_Active(view_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END View_Is_Active_Num;




-- Logical_Unit_Is_Installed_Num
--   Returns 1 if the logical unit is installed in the database,
--   else 0. Logical unit name is case sensitive.
@UncheckedAccess
FUNCTION Logical_Unit_Is_Installed_Num (
   lu_name_ IN VARCHAR2 ) RETURN NUMBER
IS
BEGIN
   IF Logical_Unit_Is_Installed(lu_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Logical_Unit_Is_Installed_Num;

-- Logical_Unit_Is_Active_Num
--   Returns 1 if the logical unit is active in the database,
--   else 0. Logical unit name is case sensitive.
@UncheckedAccess
FUNCTION Logical_Unit_Is_Active_Num (
   lu_name_ IN VARCHAR2) RETURN NUMBER
IS
BEGIN
   IF Logical_Unit_Is_Active(lu_name_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Logical_Unit_Is_Active_Num;




-- Component_Is_Installed_Num
--   Returns 1 if the component is installed in the database,
--   else 0. Uses information in LU Module and does not require the
--   dictionary cache to be up to date. If version_ is not given,
--   this parameter will be ignored. Component name is not case sensitive.
@UncheckedAccess
FUNCTION Component_Is_Installed_Num (
   component_ IN VARCHAR2,
   version_   IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
BEGIN
   IF Component_Is_Installed(component_, version_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Component_Is_Installed_Num;


-- Component_Is_Active_Num
--   Returns 1 if the component is active in the database,
--   else 0. Uses information in LU Module and does not require the
--   dictionary cache to be up to date. If version_ is not given,
--   this parameter will be ignored. Component name is not case sensitive.
@UncheckedAccess
FUNCTION Component_Is_Active_Num (
   component_ IN VARCHAR2,
   version_   IN VARCHAR2 DEFAULT NULL ) RETURN NUMBER
IS
BEGIN
   IF Component_Is_Active(component_, version_) THEN
      RETURN (1);
   ELSE
      RETURN (0);
   END IF;
END Component_Is_Active_Num;


@UncheckedAccess
FUNCTION Get_No_Overloads(package_name_ VARCHAR2,
                          method_name_  VARCHAR2) RETURN NUMBER
IS
   CURSOR get_no_overloads_ IS
      SELECT MAX(overload)
      FROM dictionary_sys_argument_tab
      WHERE package_name = UPPER(package_name_)
        AND method_name = UPPER(method_name_);

      count_      NUMBER;
BEGIN
   count_:=NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   OPEN get_no_overloads_;
   FETCH get_no_overloads_ INTO count_;
   IF get_no_overloads_%NOTFOUND THEN
      RETURN NULL;
   END IF;
   CLOSE get_no_overloads_;
   RETURN count_;
END Get_No_Overloads;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_No_Overloads_Active(package_name_ IN VARCHAR2,
                                 method_name_  IN VARCHAR2) RETURN NUMBER
IS
   CURSOR get_no_overloads_ IS
      SELECT MAX(a.overload)
        FROM dictionary_sys_argument_tab a, dictionary_sys_tab d, module_tab m 
       WHERE a.lu_name = d.lu_name
         AND d.module = m.module
         AND m.active = 'TRUE'
         AND a.package_name = UPPER(package_name_)
         AND a.method_name = UPPER(method_name_);

      count_      NUMBER;
BEGIN
   count_ := NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   OPEN get_no_overloads_;
   FETCH get_no_overloads_ INTO count_;
   IF get_no_overloads_%NOTFOUND THEN
      RETURN NULL;
   END IF;
   CLOSE get_no_overloads_;
   RETURN count_;
END Get_No_Overloads_Active;


@UncheckedAccess
FUNCTION Get_No_Arguments(package_name_ VARCHAR2,
                          method_name_  VARCHAR2) RETURN  NUMBER
IS
   CURSOR get_no_args_ IS
      SELECT count(*) no_args
      FROM dictionary_sys_argument_tab
      WHERE package_name = UPPER(package_name_)
        AND method_name = UPPER(method_name_)
      GROUP BY package_name, method_name,overload;

      count_      NUMBER;
BEGIN
   count_:=NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
--      Error_SYS.Appl_General(service_, 'NON_EXISTING_METHOD: [:P1,:P2] method is non existing method', package_name_, method_name_);
      RETURN NULL;
   END IF;
   OPEN get_no_args_;
   FETCH get_no_args_ INTO count_;
   IF get_no_args_%NOTFOUND THEN
--      Error_SYS.Appl_General(service_, 'NON_EXISTING_METHOD: [:P1,:P2] method is non existing method', package_name_, method_name_);
      RETURN NULL;
   END IF;
   CLOSE get_no_args_;
   RETURN count_;
END Get_No_Arguments;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_No_Arguments_Active(package_name_ IN VARCHAR2,
                                 method_name_  IN VARCHAR2) RETURN  NUMBER
IS
   CURSOR get_no_args_ IS
      SELECT count(*) no_args
        FROM dictionary_sys_argument_tab a, dictionary_sys_tab d, module_tab m 
       WHERE a.lu_name = d.lu_name
         AND d.module = m.module
         AND m.active = 'TRUE'
         AND a.package_name = UPPER(package_name_)
         AND a.method_name = UPPER(method_name_)
       GROUP BY package_name, method_name, overload;

      count_      NUMBER;
BEGIN
   count_ := NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   OPEN get_no_args_;
   FETCH get_no_args_ INTO count_;
   IF get_no_args_%NOTFOUND THEN
      RETURN NULL;
   END IF;
   CLOSE get_no_args_;
   RETURN count_;
END Get_No_Arguments_Active;


@UncheckedAccess
FUNCTION Get_Min_No_Arguments(package_name_ VARCHAR2,
                              method_name_  VARCHAR2) RETURN NUMBER
IS
   CURSOR get_min_no_args_ IS
      SELECT MIN(no_args)
      FROM (SELECT package_name, method_name, count(*) no_args
              FROM dictionary_sys_argument_tab
             GROUP BY package_name, method_name)
      WHERE package_name = UPPER(package_name_)
        AND method_name = UPPER(method_name_);

      count_      NUMBER;
BEGIN
   count_:=NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   OPEN get_min_no_args_;
   FETCH get_min_no_args_ INTO count_;
   IF get_min_no_args_%NOTFOUND THEN
      RETURN NULL;
   END IF;
   CLOSE get_min_no_args_;
   RETURN count_;
END Get_Min_No_Arguments;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Min_No_Arguments_Active(package_name_ IN VARCHAR2,
                                      method_name_ IN VARCHAR2) RETURN NUMBER
IS
   CURSOR get_min_no_args_ IS
      SELECT MIN(no_args)
      FROM (SELECT a.package_name, a.method_name, count(*) no_args
              FROM dictionary_sys_argument_tab a, dictionary_sys_tab d, module_tab m
             WHERE a.lu_name = d.lu_name
               AND d.module = m.module
               AND m.active = 'TRUE'
             GROUP BY a.package_name, a.method_name)
      WHERE package_name = UPPER(package_name_)
        AND method_name = UPPER(method_name_);

      count_      NUMBER;
BEGIN
   count_ := NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   OPEN get_min_no_args_;
   FETCH get_min_no_args_ INTO count_;
   IF get_min_no_args_%NOTFOUND THEN
      RETURN NULL;
   END IF;
   CLOSE get_min_no_args_;
   RETURN count_;
END Get_Min_No_Arguments_Active;


@UncheckedAccess
FUNCTION Get_Max_No_Arguments(package_name_ VARCHAR2,
                              method_name_  VARCHAR2) RETURN NUMBER
IS
   CURSOR get_max_no_args_ IS
      SELECT MAX(no_args)
      FROM (SELECT package_name, method_name, count(*) no_args
            FROM dictionary_sys_argument_tab
            GROUP BY package_name, method_name)
      WHERE package_name = UPPER(package_name_)
        AND method_name = UPPER(method_name_);

      count_      NUMBER;
BEGIN
   count_:=NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      --Error_SYS.Appl_General(service_, 'NON_EXISTING_METHOD: [:P1,:P2] method is non existing method', package_name_, method_name_);
      RETURN NULL;
   END IF;
   OPEN get_max_no_args_;
   FETCH get_max_no_args_ INTO count_;
   IF get_max_no_args_%NOTFOUND THEN
      --Error_SYS.Appl_General(service_, 'NON_EXISTING_METHOD: [:P1,:P2] method is non existing method', package_name_, method_name_);
      RETURN NULL;
   END IF;
   CLOSE get_max_no_args_;
   RETURN count_;
END Get_Max_No_Arguments;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Max_No_Arguments_Active(package_name_ IN VARCHAR2,
                                      method_name_ IN VARCHAR2) RETURN NUMBER
IS
   CURSOR get_max_no_args_ IS
      SELECT MAX(no_args)
      FROM (SELECT a.package_name, a.method_name, count(*) no_args
              FROM dictionary_sys_argument_tab a, dictionary_sys_tab d, module_tab m
             WHERE a.lu_name = d.lu_name
               AND d.module = m.module
               AND m.active = 'TRUE'
             GROUP BY a.package_name, a.method_name)
      WHERE package_name = UPPER(package_name_)
        AND method_name = UPPER(method_name_);

      count_      NUMBER;
BEGIN
   count_:=NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   OPEN get_max_no_args_;
   FETCH get_max_no_args_ INTO count_;
   IF get_max_no_args_%NOTFOUND THEN
      RETURN NULL;
   END IF;
   CLOSE get_max_no_args_;
   RETURN count_;
END Get_Max_No_Arguments_Active;


@UncheckedAccess
FUNCTION Get_Argument_Type(package_name_ VARCHAR2,
                           method_name_  VARCHAR2,
                           arg_pos_      NUMBER) RETURN VARCHAR2
IS
   CURSOR get_arg_type_ IS
      SELECT argument_datatype
      FROM dictionary_sys_argument_tab
      WHERE package_name = package_name_
        AND method_name = method_name_
        AND argument_index = arg_pos_;

      type_      dictionary_sys_argument_tab.argument_datatype%TYPE;
BEGIN
   type_:=NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      --Error_SYS.Appl_General(service_, 'NON_EXISTING_METHOD: [:P1,:P2] method is non existing method', package_name_, method_name_);
      RETURN NULL;
   END IF;
   IF Get_No_Overloads(package_name_, method_name_) > 1 THEN
      RETURN NULL;
   END IF;
   OPEN get_arg_type_;
   FETCH get_arg_type_ INTO type_;
   IF get_arg_type_%NOTFOUND THEN
      --Error_SYS.Appl_General(service_, 'NON_EXISTING_METHOD: [:P1,:P2] method is non existing method', package_name_, method_name_);
      RETURN NULL;
   END IF;
   CLOSE get_arg_type_;
   RETURN type_;
END Get_Argument_Type;


--SOLSETFW
@UncheckedAccess
FUNCTION Get_Argument_Type_Active (package_name_ IN VARCHAR2,
                                   method_name_  IN VARCHAR2,
                                   arg_pos_      IN NUMBER) RETURN VARCHAR2
IS
   CURSOR get_arg_type_ IS
      SELECT a.argument_datatype
        FROM dictionary_sys_argument_tab a, dictionary_sys_tab d, module_tab m
       WHERE a.lu_name = d.lu_name
         AND d.module = m.module
         AND m.active = 'TRUE'
         AND a.package_name = package_name_
         AND a.method_name = method_name_
         AND a.argument_index = arg_pos_;

      type_  dictionary_sys_argument_tab.argument_datatype%TYPE;
BEGIN
   type_ := NULL;
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RETURN NULL;
   END IF;
   IF Get_No_Overloads_Active(package_name_, method_name_) > 1 THEN
      RETURN NULL;
   END IF;
   OPEN get_arg_type_;
   FETCH get_arg_type_ INTO type_;
   IF get_arg_type_%NOTFOUND THEN
      RETURN NULL;
   END IF;
   CLOSE get_arg_type_;
   RETURN type_;
END Get_Argument_Type_Active;

PROCEDURE Set_Installation_Mode (
   installation_mode_ IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   General_SYS.Check_Security(service_, 'DICTIONARY_SYS', 'Set_Installation_Mode');
   Installation_SYS.Set_Installation_Mode(installation_mode_);
END Set_Installation_Mode;


@UncheckedAccess
FUNCTION Get_Installation_Mode RETURN BOOLEAN
IS
BEGIN
   RETURN(Installation_SYS.Get_Installation_Mode);
END Get_Installation_Mode;


-- Is_Report_Module_Lu_
--   Check if an Lu has reports
@UncheckedAccess
FUNCTION Is_Report_Module_Lu (
   module_  IN  VARCHAR2,
   lu_      IN VARCHAR2) RETURN BOOLEAN
IS 
   dummy_ VARCHAR2(50);
BEGIN
      SELECT distinct(s.lu_name)
      INTO  dummy_
      FROM   dictionary_sys_tab s, dictionary_sys_view_tab v
      WHERE  s.module = module_
      AND s.lu_type = 'L'
      AND s.lu_name = v.lu_name
      AND s.lu_name = lu_
      AND (v.view_name like '%_GRP' or v.view_name like '%_REP')
      ORDER BY lu_name;
      
      RETURN TRUE;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN FALSE;
END Is_Report_Module_Lu;
   

FUNCTION Get_Metadata_Content (
   metadata_type_ IN VARCHAR2,
   metadata_name_ IN VARCHAR2 ) RETURN CLOB
IS
   package_name_ VARCHAR2(100) := Get_Package_Name___(metadata_type_, metadata_name_);
   result_       CLOB;
BEGIN
   @ApproveDynamicStatement(2015-12-15,mabose)
   EXECUTE IMMEDIATE 'BEGIN :result := '||package_name_||'.Get_Metadata_Content_; END;' USING OUT result_;
   RETURN result_;
END Get_Metadata_Content;


FUNCTION Get_Metadata_Version (
   metadata_type_ IN VARCHAR2,
   metadata_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_name_ VARCHAR2(100) := Get_Package_Name___(metadata_type_, metadata_name_);
   result_       VARCHAR2(100);
BEGIN
   @ApproveDynamicStatement(2015-12-15,mabose)
   EXECUTE IMMEDIATE 'BEGIN :result := '||package_name_||'.Get_Metadata_Version_; END;' USING OUT result_;
   RETURN result_;
END Get_Metadata_Version;

-- Refresh_Odata_Projection_Cache
--   Refreshes the Odata provider cache related to a projection
--   or refreshes all if "*" is specified
PROCEDURE Refresh_Odata_Projection_Cache (
   projection_ IN VARCHAR2 DEFAULT '*',
   categories_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Calling Obsolete method Refresh_Odata_Projection_Cache. Use Model_Design_SYS method instead');
END Refresh_Odata_Projection_Cache;

-- Refresh_Odata_Client_Cache
--   Refreshes the Odata provider cache related to a client layouts
--   or refreshes all if "*" is specified
PROCEDURE Refresh_Odata_Client_Cache(
   client_layout_name_ IN VARCHAR2 DEFAULT '*')
IS
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Calling Obsolete method Refresh_Odata_Client_Cache. Use Model_Design_SYS method instead');
END Refresh_Odata_Client_Cache;

-- Refresh_Odata_Cache
--   Refreshes the Odata provider cache
--   cache_name_ => can be PROJECTION, CLIENT_LAYOUT or ALL
--   what_       => specific name or "*" to refresh all in the related cache
--                  Ignored when cache_name_ = 'ALL'
PROCEDURE Refresh_Odata_Cache (
   cache_name_ IN VARCHAR2 DEFAULT 'ALL',
   what_       IN VARCHAR2 DEFAULT '*')
IS
BEGIN
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, 'Calling Obsolete method Refresh_Odata_Cache. Use Model_Design_SYS method instead');
END Refresh_Odata_Cache;

PROCEDURE Refresh_Dependent_Meta_Caches (
   lu_name_ IN VARCHAR2 )
IS
   CURSOR get_dependent_projections(lu_ VARCHAR2) IS
      SELECT projection_name
      FROM fnd_proj_entity_tab
      WHERE used_lu = lu_
      UNION
      SELECT projection_name
      FROM fnd_proj_query_tab
      WHERE used_lu = lu_
      UNION
      SELECT projection_name 
      FROM fnd_proj_lookup_usage_tab
      WHERE used_lu = lu_;
      
   CURSOR get_dependent_clients(lu_ VARCHAR2) IS
      SELECT a.name AS client_name
        FROM fnd_model_design_tab a,
             (SELECT projection_name
                FROM fnd_proj_entity_tab
               WHERE used_lu = lu_
              UNION
              SELECT projection_name
                FROM fnd_proj_query_tab
               WHERE used_lu = lu_
              UNION
              SELECT projection_name
                FROM fnd_proj_lookup_usage_tab
               WHERE used_lu = lu_) b
          WHERE a.kind = 'ClientMetadata'
            AND a.artifact = 'client'
            AND a.reference = 'ClientMetadata.projection:' || b.projection_name;
BEGIN
   FOR rec_ IN get_dependent_projections(lu_name_) LOOP
      Model_Design_SYS.Refresh_Projection_Version(rec_.projection_name);
   END LOOP;
   FOR rec_ IN get_dependent_clients(lu_name_) LOOP
      Model_Design_SYS.Refresh_Client_Version(rec_.client_name);
   END LOOP;
END Refresh_Dependent_Meta_Caches;

PROCEDURE Check_Long_Identifiers
IS
   CURSOR get_objects IS
         SELECT object_name, object_type
           FROM user_objects uo
          WHERE LENGTH(object_name) > MAX_DICT_IDENTIFER_LENGTH
            AND object_name NOT LIKE '%/_SVC' ESCAPE '/' -- Projections
            AND object_name NOT LIKE '%/_VRT' ESCAPE '/' -- Projection Virtuals
            AND object_name NOT LIKE '%/_JSN' ESCAPE '/' -- Mobile utilities
            AND object_name NOT LIKE '%/_TLM' ESCAPE '/' -- Mobile utilities
            AND object_name NOT LIKE 'AQ$%'              -- Oracle Advance queues
            AND ((object_name LIKE '%/_TAB' ESCAPE '/'
            AND   object_type = 'TABLE')                
            OR   object_type != 'TABLE')                 -- Unknown Tables
            AND object_type IN ('PACKAGE', 'TRIGGER', 'MATERIALIZED VIEW', 'TABLE', 'VIEW')
            AND NOT EXISTS  -- Remove this part when merging to support
            (SELECT 1
             FROM user_objects uo_svc
             WHERE uo.object_name LIKE SUBSTR(uo_svc.object_name, 1, LENGTH(uo_svc.object_name) - 3)||'%'
             AND uo.object_type = 'TABLE'
             AND uo_svc.object_name LIKE '%/_SVC' ESCAPE '/'
             AND uo_svc.object_type = 'PACKAGE')
         UNION ALL
         SELECT t.table_name || '.' || t.column_name, 'COLUMN'
           FROM user_tab_columns t, user_views v
          WHERE LENGTH(t.column_name) > MAX_DICT_IDENTIFER_LENGTH
            AND t.table_name = v.view_name
            AND t.table_name NOT LIKE 'AQ$%'               -- Oracle Advance queues
            AND t.table_name NOT LIKE '%/_VRT' ESCAPE '/' -- Projection Virtuals
         UNION ALL
         SELECT t.object_name || '.' || t.procedure_name, 'METHOD'
           FROM user_procedures t
          WHERE LENGTH(t.procedure_name) > MAX_DICT_IDENTIFER_LENGTH
            AND t.object_name NOT LIKE '%/_SVC' ESCAPE '/'
            AND t.object_name NOT LIKE '%/_JSN' ESCAPE '/'
            AND t.object_name NOT LIKE '%/_TLM' ESCAPE '/'
         ORDER BY 2, 1;
   first_ BOOLEAN := TRUE;
   level_ NUMBER := Log_SYS.error_;
BEGIN
   FOR rec_ IN get_objects LOOP
      IF first_ THEN
         Log_SYS.Fnd_Trace_(level_, '   ------------------------------------------------------------------');
         Log_SYS.Fnd_Trace_(level_, '                   ------   ERROR!!!   ------                      ');
         Log_SYS.Fnd_Trace_(level_, '   The following database objects are longer than the allowed length (30 chars).');
         Log_SYS.Fnd_Trace_(level_, '   Included are also objects detected as added or modified before this refresh.');
         Log_SYS.Fnd_Trace_(level_, '   This can cause the Dictionary cache refresh to fail.');
         Log_SYS.Fnd_Trace_(level_, '   Correct the following and refresh dictionary again.');
         Log_SYS.Fnd_Trace_(level_, '   ------------------------------------------------------------------');
         first_ := FALSE;
      END IF;
      Log_SYS.Fnd_Trace_(level_, '   '||rec_.object_type || ' - ' ||rec_.object_name);
   END LOOP;
   
   IF NOT first_ THEN
      Log_SYS.Fnd_Trace_(level_, '   ------------------------------------------------------------------');
   END IF;
END Check_Long_Identifiers;