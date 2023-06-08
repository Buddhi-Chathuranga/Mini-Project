-----------------------------------------------------------------------------
--
--  Logical unit: Security
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950822  ERFO  Created specification.
--  950823  ERFO  Added implementation. 
--  950905  ERFO  Changed method names to base on Enumerate-prefix.
--  950911  ERFO  Changed LU-parameter in call to Appl_Access_.
--  950912  ERFO  Added documentation headers and examples.
--  950913  STLA  Uses new separator declaration
--  950915  ERFO  Changed table contents to include package, removed Set_User
--                and removed the use of Get_User in SQL-statements.
--  950926  ERFO  New method Enumerate_Restricted_List.
--  950927  ERFO  Rearrangements for handle of cached security information.
--                Added methods Init_Session_Roles and Generate_Restrictions___.
--  950928  ERFO  Modified role initiation by using view DBA_ROLE_PRIVS to
--                fully support server security requirements. Return only
--                the restricted methods for the current user.
--  951003  ERFO  Added methods Enumerate_Packages_ to list all accessible
--                packagess by using view DBA_TAB_PRIVS through the method
--                Get_Accessible_Packages___.
--  951004  STLA  Adjusted method Get_Accessible_Packages___ to return only
--                packages accessible in this session (i.e. owned by same
--                owner as this Security_SYS package).
--                Renamed to Enumerate_Roles_ and Enumerate_Restrictions_.
--                Added method Enumerate_Views_
--                Adjusted Get_Session_Roles___ so that username and PUBLIC
--                is included in the role list.
--  951005  STLA  Modified Get_Restricted_List___ so that multiple roles can
--                be used. Only restrictions covering all roles with grants
--                to a package will actually be restricted.
--  951116  ERFO  Added  independency of system view DBA_ROLE_PRIVS. The view
--                TABLE_PRIVILEGES and package DBMS_SESSION is used to retrieve
--                a list of enabled roles.
--  951116  ERFO  Removed public method Get_User to be 7.2-compatible.
--  960111  ERFO  Added parameter type BIGCHAR2 which is used by the enumerate
--                methods for packages, views and restrictions (Bug #324).
--  960111  ERFO  Changed sizes 32000 to 32730 in several methods.
--  960205  ERFO  Tuning activities in method Get_Session_Roles___ (Idea #387).
--  960319  ERFO  Changed implementation of method Get_Session_Roles___ and return
--                an empty restriction list if the session is started by the the
--                application owner (Idea #454).
--  960418  ERFO  Optimizing the queries to retrieve package and view lists
--                and rewritten code and method names. Added functionality for
--                global security setting through table SECURITY_SYS_TAB.
--  960424  ERFO  Using internal help table SECURITY_SYS_PRIVS_TAB (Idea #517).
--  960426  ERFO  Added method Refresh_Active_List__ to support help table.
--  960429  ERFO  Added method Enumerate_Dba_Roles_ and enabled DBA-support
--                for roles through dynamic PL/SQL for better performance.
--  960506  ERFO  Changes in method Set_Session_Roles___  to not perform
--                role operations when running as application owner.
--                Added exception handling in method Set_Security_Setup___.
--  960506  ERFO  Corrected problem in method Check_Method_Access which
--                does not handle mixed method names correctly (Bug #569).
--  960517  ERFO  Fixed BIGCHAR2 problem by changing to VARCHAR2 (Bug #607).
--  960521  ERFO  Added dummy parameter to method Refresh_Active_List to
--                be used from the client security administration tool.
--  960826  ERFO  Added database setup attribute for optional logic on server
--                based method security checkings (Idea #767).
--  960911  ERFO  Fixed problem when the security setup table is empty and
--                when running as application owner (Bug #778).
--  960916  ERFO  Replaced view TABLE_PRIVILEGES with USER_TAB_PRIVS_MADE.
--  961105  MADR  Optimized algorithm in method Set_Restricted_Method_List___
--                to retrieve method restrictions when setup=CACHE (Idea #860).
--  961116  ERFO  Added cached information about role and user connections
--                and added functionality when rebuilding cache (Idea #860).
--  961210  ERFO  Changed protected interfaces for retrieving security info
--                to solve the size problem in PL/SQL (Bug #894).
--                Added sub-query to view user_objects to ensure that only
--                views and packages are returned to the client.
--  970212  ERFO  Solved major performance problem for many Oracle users by
--                optimizing SQL in method Get_Role_List___ (Bug #981).
--  970411  ERFO  Decreased the value of global "chunk_limit_" to 31000
--                to ensure a correct handle at connect (Bug #1033).
--  970411  ERFO  Changed parameter setup handling according to new settings
--                in logical unit FoundationSetting in release 2.0.
--  970423  ERFO  Changed name to Fnd_Setting_API.
--  970430  ERFO  Added methods Is_View_Available and Is_Method_Available
--                to support security from Oracle WebServer (ToDo #1106).
--  970512  ERFO  Removed logic with package initialization.
--  970514  ERFO  Added option fast login to method Enumerate_Roles_.
--  970523  ERFO  Implemented boolean WEB-security methods.
--  970605  ERFO  Changes in method Check_Method_Access for Web users.
--  970630  ERFO  Corrections concerning WEB-security.
--  970728  ERFO  Removed check when APPOWNER for web security (ToDo #1106).
--  970729  ERFO  Made method Check_Method_Access_ protected.
--  971013  ERFO  Added method Is_View_Available_.
--  971019  ERFO  Added methods for disabling/enabling method security check.
--                Rearrangements concerning initation of global data.
--  971020  ERFO  Removed package initiation for test purposes.
--  971022  ERFO  Refresh only be run as application owner (ToDo #1286).
--  971028  MANY  Fixed problem with initiating security from batch jobs.
--  980121  ERFO  Correction in method Get_Role_List___ to handle recursive
--                role relations for Foundation1 end users (Bug #2037).
--  980121  ERFO  Added new protected method Get_Role_List_ (ToDo #2002).
--  980304  ERFO  Fix problem when Get_Fnd_User return null (Bug #2196).
--  980306  ERFO  Solved situation with package initiation of method memory
--                cache even when running from WWW-clients (Bug #2211).
--                Rearrangements in code to reuse package globals.
--  980319  ERFO  Added parameter to method Set_Session_Roles___ to get
--                rid of problems when using global variables (Bug #2262).
--  980325  ERFO  Changes in Is_Method_Available to solve problem with
--                exceptions when running background jobs (Bug #2280).
--  980611  ERFO  Solved problem with method level security exceptions affecting
--                other APIs including similar package names. (Bug #2518).
--  980611  ERFO  Handle of roles granted to implicit role PUBLIC (Bug #2523).
--  980804  ERFO  Integrated MTS_SYS into Foundation1 2.2 (ToDo #2554).
--  980818  ERFO  Moved global data initialization to method Init which may
--                be accessed from General_SYS in web solutions (Bug #2631).
--  981103  ERFO  Added DELETE of invalid method restriction entries in
--                Refresh_Active_List__ for non-granted roles (Bug #2867).
--  981106  ERFO  New configuration setting for method security (ToDo #2872).
--  990105  ERFO  Added new cache table for Security_SYS (Bug #3056).
--  990216  ERFO  Solved cache problem when upgrading to 2.1.2.B (Bug #3124).
--  990322  ERFO  Consistency package changes towards FndUserRole (Bug #3191).
--  990322  MANY  Added method Is_Prefixed_View_Available_ (ToDo #3177).
--  990427  ERFO  Fixed restriciton in method Get_Dba_Roles___ (Bug #2938).
--  990617  ERFO  Rearrangements regarding security array elements and
--                added new method Enumerate_Security_Info_ (ToDo #3431).
--  990623  TOFU  Fix wrap-up in Set_Restricted_Method_List__ (ToDo #3431).
--  990920  ERFO  Added new methods for security scripts (ToDo #3533).
--  991022  HAAR  Revokes the role from appowner when creating a role in
--                method Create_Role (Bug #3662).
--  991022  HAAR  Method Security_SYS.Is_Prefixed_View_Available_()
--                does not handle privileges granted to role PUBLIC (Bug #3664)
--  000215  ERFO  Added new methods Grant_Pres_Objects, Revoke_Pres_Objects,
--                Is_Pres_Object_Available_, Is_Pres_Object_Available and
--                Enumerate_Pres_Objects_ (ToDo #3846).
--  000218  ERFO  Added new methods Grant_Package and Revoke_Package and
--                overloaded versions of Grant/Revoke_Method (ToDo #3846).
--  000301  ERFO  Added other methods for Security 2001 (ToDo #3846).
--  000330  ERFO  Several changes in logic for Security 2001 (ToDo #3846).
--  000411  ROOD  Changes in Grant_Method (ToDo #3846).
--  000419  ROOD  Changes in Revoke_Method (ToDo #3846).
--  000419  ROOD  Changes in Is_Pres_Object_Available (ToDo #3846).
--  000428  PeNi  Added methods Enable/Disable_Pres_Object (ToDo #3846).
--  000502  ERFO  Solved double byte problem for setup CACHE (Bug #16006).
--  000517  ROOD  Added method Clear_Role (ToDo #3846).
--  000524  ERFO  Grant/Revoke_Role: Syncronization to FndUserRole if necessary.
--                Clear_Role: Add error trapping and remove method restrictions.
--  000607  ROOD  Added control that package is granted before inserting method
--                into security_sys_tab in Revoke_Method. Added setting control
--                for pres object security on user level in Enumerate_Pres_Objects_.
--  000613  ROOD  Added extended check for type 'WIN' in Enumerate_Pres_Objects_.
--  000821  ROOD  Changed handling of appowner case in Enumerate_Pres_Objects_ (Bug#17064).
--  000912  ROOD  Decreased the chunk_limit_ to VARCHAR2(29000) (Bug #17430).
--  001006  ROOD  Added method Grant_Query_Pres_Object (ToDo#3944).
--  001026  ROOD  Added quotation around all roles and users in all ddl calls. (Bug#17619).
--  001106  ROOD  Added several exceptions in methods executing DDL-calls (ToDo#3944).
--  001107  ROOD  Added chunk_limit_po_ that can be larger than ordinary chunk_limit_ (ToDo3944).
--  001229  ERFO  Added method calls regarding key considerations (ToDo #3937).
--  010219  ROOD  Changed obsolete call in Grant_Query_Pres_Object (ToDo#3991).
--  010524  ROOD  Added new overloaded method Enumerate_Views_ (Bug#21983).
--  010821  ROOD  Made grant/revoke methods accept roles and users in lowercase.
--                Corrected usage of General_SYS.Init_Method (ToDo#4040).
--  010905  ROOD  Added default parameters in Grant/Revoke_Pres_Object (Bug#24252).
--  010912  ROOD  Added avoiding of deadlock situations when granting/revoking (ToDo#4033).
--  010913  ROOD  Removed access control on methods needed by web endusers (Bug#24379).
--  010926  ROOD  Added cleanup of role data in Drop_Role and Clear_Role (ToDo#4033).
--  010926  ROOD  Added upper for schema and view in Is_Prefixed_View_Available (ToDo#4033).
--  011031  ROOD  Rewrote Grant_Method to avoid inconsistency in security_sys_tab (ToDo#4033).
--  020206  ROOD  Changed order of execution and exception handling in Grant_Role and
--                Revoke_Role to avoid errors if an Oracle user does not exist. (Bug#27545)
--  020304  ROOD  Added maintenance of the consistency in pres_object_grant_tab
--                in Refresh_Active_List__ (Bug#28362).
--  020311  ROOD  Added a check that a fnduser with same identity does not exist when
--                creating Oracle role in method Create_Role (Bug#27944).
--  020322  ROOD  Modified Enumerate_Pres_Objects_ to support multiple fetches of
--                pres object information from client upon login (Bug#28798).
--  020410  ROOD  Added exception handling for existing oracle role or user in
--                method Create_Role (Bug27944).
--  020523  ROOD  Removed case sensitity in Revoke_Method and Grant_Method (Bug#27576).
--  020701  ROOD  Further modifications of usage of General_SYS.Init_Method (ToDo#4087).
--  020905  HAAR  Performance increases in Refresh_Active_List__, Set_Accessible_PkgAndViews___,
--                Set_Pres_Object_List___ (ToDo#4037).
--                  - Use new features in PL/SQL.
--  021021  ROOD  Added check that PO security is active in Is_Pres_Object_Available (GLOB12).
--  021030  TOFU  Change file version order connected to package..
--                This means that file version now add 021021 before 020905
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030220  ROOD  Removed hardcoded subcomponent name in message (ToDo#4149).
--  030312  ROOD  Also delete direct role grants to users when dropping a role (Bug#35928).
--  030428  ROOD  Changed loops using .FIRST and .LAST to avoid exception
--                if cursor get no hits (ToDo#4196).
--  030502  ROOD  Improved handling of packages that will deadlock (ToDo#4259).
--  030503  ROOD  Changed usage of Trace_SYS to Dbms_Output in Package_Will_Deadlock__
--                and added some more deadlock packages (ToDo4259).
--  030626  ROOD  Corrected handling of fast_login (ToDo#4099).
--  030819  ROOD  Made Is_Method_Available not case sensitive. Minor
--                performance improvements (ToDo#4160).
--  030821  ROOD  Added Trace_SYS to Package_Will_Deadlock__ (ToDo#4196).
--  030910  ROOD  Replaced usage of view sys.dba_roles with fnd_role (ToDo#4160).
--  031003  ROOD  Added check if appowner in Is_Prefixed_View_Available (Bug#39749).
--  040209  NIPE  Security - Roles per User Limit (Bug #42362).
--  040301  ROOD  Modifications for new LU FndRole (F1PR413).
--  040707  ROOD  Modifications in usage of dictionary_sys-tables (F1PR413).
--  041101  HAAR  Added methods for Security Checkpoint concept (F1PR414).
--  041222  JORA  Replaced usage of fullmethod in security_sys_tab with
--                package_name and method_name. Removed usage of
--                pres_object_grant_default_tab (Merge Bug#48113).
--  050110  ROOD  Replaced from_module with module in New_Pres_Object_Dependency (Bug#47476).
--  050126  RAKU  Removed calls to client_role/client_role_restriction (F1PR484).
--  050208  HAAR  Replaced Set_Restricted_Method_List2___ with performanced tuned code (F1PR480).
--  050303  HAAR  Added function Package_Is_Granted__ and Revoke_All_Methods (F1PR414).
--                Changed Grant_Package and Revoke_Package.
--  050408  JORA  Added assertion for dynamic SQL.  (F1PR481)
--                Remove Run_Ddl_Command___.
--  050413  HAAR  Removed Enable_Method_Check and Disable_Method_Check.
--                Removed parameter SEC_SETUP and SEC_METHOD_CHECK (F1PR489).
--  050420  HAAR  Added methods for checking grants to roles (F1PR480).
--  050502  JORA  Added support for role_type in roles (F1PR480).
--  050503  JORA  Added method for granting/revoking IAL views.
--  050525  JEHU  Added methods Grant_Activity, Revoke_Activity
--  050607  UTGULK  Modified Is_Prefixed_View_Available_ to use grantee 'public' for appowner(Bug#49319).
--  050610  UTGULK  F1PR489 Moved export_role functionality from centura client to server.
--  050613  HAAR  Added Grant_System_Privilege, Revoke_System_Privilege, Has_System_Privilege
--                and Is_App_Owner (F1PR489).
--  050816  HAAR  Call activity ManageApplicationServerCache.ClearSecurityCache
--                when refreshing Security Cache.
--  050825  ASWILK  Added IAL owner prefix to grant statment in Grant_View___ for IALs(Bug#52991).
--  050906  HAAR  Added views for Security_Sys_Tab and Security_Sys_Privs_Tab (F1PR843).
--  050928  HAAR  Added Enum_User_System_Privilege for stateless sessions (F1PR843).
--  051107  HAAR  Added Revoke_Package___ and Revoke_Package__ for Centura client use (F1PR843).
--  051123  HAAR  Changed implementation for Has_System_Privilege and Enum_User_System_Privileges_ (F1PR843).
--  051213  HAAR  PLSQLAP interface changes.
--  051215  HAAR  Events on failure and success for Security Checkpoint (F1PR414).
--                Added function Security_Checkpoint_Activated.
--  060105  UTGULK Annotated Sql injection.
--  060112  UTGULK Modified Export_Role__ to enable rerun of the script.
--  060302  HAAR  Add Reports to Set_Pres_Object_List___ and Enumerate_Pres_Objects_ (F1PR843).
--  060313  RAKOLK Added SECURITY_SYS_GRANTED_IALS view.
--  060421  UTGULK  Added IAL owner prefix to revoke statment in Revoke_View___ for IALs(Bug#56904).
--  060829  JEHU  Method Clear_Role revokes activity grants and ial views and updates security_sys_privs (Bug#60179)
--  060915  ASWILK When checking permissions for views, methods, if the user is appowner should not return true, instead
--                 should check if the view or method is installed. (Bug# 60551).
--  060922  ASWILK Checked if the view or method is installed using Database_SYS instead of Dictionary_SYS (Bug#60727).
--  061222  HAAR  Moved when to refresh Jboss user cache (Bug#61892).
--  070105  PEMA  PLSQLAP_BUFFER_TMP resource utilization (Bug# 62400).
--  070212  SUMALK Moved the pres_object_security_ to procedure init.
--  070524  PEMASE security checkpoint FDR 21 11.200 compliance (Bug# 63254).
--  070524  PEMASE Minor edit of Bug# 63254 to handle NULL username.
--  070525  UsRaLK Modified export role functionality to use Grant_IAL_View to export IAL object grants (Bug#64428).
--  080208  HAARSE Added update of Cache Management when refreshing the cache (Bug#71136).
--  080225  PEMASE Added double quotes to Clear_Role to resolve problems with "A B" and "123" role names. (Bug#71627).
--  080312  HAARSE User IFSSYS should always have system privilege IMPERSONATE USER (Bug#68143).
--  080414  HAARSE Method Validate_Timespan_For_Users__ added (Bug#73104).
--  080505  HAARSE Added method Initialize_Sec_Info_ (client_hash_value_ IN OUT VARCHAR2 ) for Rising project (Bug#73650).
--  080908  HAARSE Added upper to package in method Check_Method_Access_, to avoid problems (Bug#76886).
--  090205  HAARSE Is_Prefixed_View_Available_ has been changed so that Appowner can access its own views (Bug#80192).
--  090225  HASPLK Modified method Refresh_Active_List__ to refresh objects granted only by app owner (Bug#80848).
--  090303  JHMASE It is not possible to grant to a Foundation1 user that is not an Oracle user (Bug#80896).
--  090811  NABALK Certified the assert safe for dynamic SQLs Clear_Role (Bug#84218).
--  091214  HAARSE Fixed error mesasge in Revoke_Package (Bug#87593).
--  100121  HAARSE Bad performance for background jobs, to much sql done during elaboration of package (Bug#88577).
--  100318  UsRaLK Implemented support for exporting role structures. (Bug#84237).
--  100319  JHMASE Clear_Role is not revoking grants on views (Bug#89256).
--  100219  KAUSLK SecurityCheckpoint re-authentication via AnonymousAccess.authenticate(...) (Bug#87603).
--  100422  DUWILK Changed Is_Method_Available in order to support the RECORD TYPEs (Bug#86281).
--  100805  UsRaLK Create_Role now simply ask FndRole to create the role (Bug#90361).
--  110726  ChMuLK Modified Set_Restricted_Method_List2___ (Bug#97144).
--  110917  NaBaLK Changed global variable pres_object_security_ to a local variable (RDTERUNTIME-809)
--  110906  DUWILK Added functionality to support history logging for granting role to another role (Bug#98679).
--  111004  UsRaLK Enable clear role to clear the structure without any error(Bug#99053).
--  111212  jehuse Added REFERENCE_SYS to packages that will deadlock on revoke
--  120104  UsRaLK Modified Is_Pres_Object_Available to return FALSE if pres object does not exist (RDTERUNTIME-1768/Bug#99782).
--  120104  UsRaLK Added Method Is_Pres_Object_Registered (RDTERUNTIME-1768/Bug#99782).
--  120229  MaDrSE Rewritten Refresh_Active_List__ using SQL instead of PLSQL loop (RDTERUNTIME-2239)
--  120705  MaBose  Conditional compiliation improvements - Bug 103910
--  121002   ASWILK Increased lengths of variables gra_roles_, res_roles_ in method Set_Restricted_Method_List2___ (Bug#105571).
--  121207  NaBaLK Created FND_USER_OBJECTS_EXT by adding objects in the info owner schema to FND_USER_OBJECTS (Bug#106971)
--  130419  JEHUSE Cleanup__ ignores LTU permission sets. Even if the LTU is using wrong dictionary we preserve the definition to not violate license.
--  140309  MADDLK TEBASE-37,Merged Bug#112862.
-----------------------------------------------------------------------------
--
--  Contents:     Implementation methods for fast security tasks
--                Private installation related methods for cached security info
--                Protected initiation methods for client security support
--                Public initiation methods for client security support
--                Public authorization methods for server security support
--
--  Setup:        CACHE    Retrieve all granted objects and method restriction
--                         information by using internal help table. This option
--                         is only valid for non-application owners
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

TYPE sec_struct_type IS TABLE OF VARCHAR2(32730) INDEX BY BINARY_INTEGER;
field_separator_       CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
ial_view_type_         CONSTANT VARCHAR2(5) := 'IAL';
appowner_view_type_    CONSTANT VARCHAR2(8) := 'APPOWNER';
TYPE System_Privilege_Cache IS RECORD (fnd_user_         VARCHAR2(30),
                                       privilege_id_     VARCHAR2(30),
                                       return_value_     BOOLEAN,
                                       micro_cache_time_ NUMBER  := 0);
micro_cache_sys_priv_ System_Privilege_Cache;
TYPE Info_Array_Type IS TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;
newline_    CONSTANT VARCHAR2(2) := chr(13)||chr(10);

context_ CONSTANT VARCHAR2(30) := 'FNDSESSION_CTX';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Execute_Event___(
   event_    IN VARCHAR2,
   gate_id_  IN VARCHAR2,
   fnd_user_ IN VARCHAR2,
   msg_      IN VARCHAR2 )
IS
   event_msg_ VARCHAR2(32000);
BEGIN
   IF (Event_SYS.Event_Enabled(service_, event_)) THEN
      event_msg_ := Message_SYS.Construct(event_);
      ---
      --- Standard event parameters
      ---
      Message_SYS.Add_Attribute(event_msg_, 'EVENT_DATETIME', sysdate);
      Message_SYS.Add_attribute(event_msg_, 'USER_IDENTITY', fnd_user_);
      Message_SYS.Add_attribute(event_msg_, 'USER_DESCRIPTION', Fnd_User_API.Get_Description(fnd_user_));
      Message_SYS.Add_attribute(event_msg_, 'USER_MAIL_ADDRESS', Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS'));
      Message_SYS.Add_attribute(event_msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE'));
      ---
      --- Other important information
      ---
      Message_SYS.Add_Attribute(event_msg_, 'DIRECTORY_IDENTITY', Fnd_User_API.Get_Web_User(fnd_user_));
      Message_SYS.Add_Attribute(event_msg_, 'GATE_IDENTITY', gate_id_);
      Message_SYS.Add_Attribute(event_msg_, 'GATE_MESSAGE', msg_);
      Event_SYS.Event_Execute(service_, event_, event_msg_);
   END IF;
END Execute_Event___;

   
FUNCTION Get_Role_List___ (
   fnd_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   list_ VARCHAR2(32000);

   TYPE roles IS TABLE OF fnd_user_role_runtime_tab.role%TYPE;
   role_list_ roles;

   CURSOR get_expanded_roles IS
      SELECT role
      FROM   fnd_user_role_runtime_tab
      WHERE  identity = fnd_user_;
BEGIN
   OPEN get_expanded_roles;
   FETCH get_expanded_roles BULK COLLECT INTO role_list_;
   CLOSE get_expanded_roles;
   
   IF role_list_.count > 0 THEN
     list_ := role_list_(1);        
     FOR i IN 2..role_list_.count LOOP
         list_ := list_ || chr(31) || role_list_(i);
     END LOOP;
   END IF;
   
   -- here, the number 4587 is calculated as 148(max roles per user)*30(max length for a role name) + 147 spaces
   -- without spaces, the max lenght of role list can be 4440 (4587 - 147)
   IF lengthb(list_) >  4587 THEN
      Error_SYS.Record_General(service_, 'ROLELIST: The role list string for the user :P1 exceeds 4440 characters. Remove some roles from this user.', fnd_user_);
   ELSE     
      RETURN list_;
   END IF;
END Get_Role_List___;


FUNCTION Package_Is_Granted___ (
    package_ IN VARCHAR2,
    role_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR get_grant IS
   SELECT 1
   FROM   user_tab_privs_made
   WHERE  grantee = role_
   AND    table_name = package_
   AND    privilege = 'EXECUTE';
   dummy_ NUMBER;
BEGIN
   OPEN get_grant;
   FETCH get_grant INTO dummy_;
   IF get_grant%FOUND THEN
      CLOSE get_grant;
      RETURN TRUE;
   ELSE
      CLOSE get_grant;
      RETURN FALSE;
   END IF;
END Package_Is_Granted___;


FUNCTION Session_Role___ (
   role_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(dbms_session.is_role_enabled(role_));
END Session_Role___;


PROCEDURE Pack_Array___ (
   string_array_  IN Info_Array_Type,
   string_ OUT CLOB )
IS
BEGIN
   FOR i IN 1..string_array_.count LOOP
      string_ := string_ || (string_array_(i) || newline_);
   END LOOP;
END Pack_Array___;


PROCEDURE Begin_Section___ (
   string_array_  IN OUT Info_Array_Type,
   index_  IN OUT NUMBER,
   header_ IN     VARCHAR2 )
IS
BEGIN
   index_:= index_ +1 ;
   string_array_(index_) :=  header_ || newline_;
   string_array_(index_) :=  string_array_(index_) || 'BEGIN' || newline_;
   index_:= index_ +1 ;
END Begin_Section___;


PROCEDURE Break_Section___ (
   string_array_  IN OUT Info_Array_Type,
   index_ IN OUT NUMBER )
IS
BEGIN
   string_array_(index_) :=  'END;' || newline_ ;
   string_array_(index_) :=  string_array_(index_) || '/' || newline_;
   string_array_(index_) :=  string_array_(index_) || 'BEGIN' ;
   index_:= index_ +1 ;
END Break_Section___;


PROCEDURE End_Section___ (
   string_array_  IN OUT Info_Array_Type,
   index_ IN OUT NUMBER )
IS
BEGIN
   string_array_(index_) := 'END;' || newline_;
   string_array_(index_) := string_array_(index_) || '/' || newline_;
   index_:= index_ +1 ;
END End_Section___;


PROCEDURE Add_Pres_Objects_To_Array___ (
   string_array_  IN OUT Info_Array_Type,
   role_   IN VARCHAR2,
   enable_ IN VARCHAR2 )
IS
   i_ NUMBER:=0;
   obj_count_  NUMBER:=0;
   method_1_ VARCHAR2(4000);
  
   CURSOR get_po_Objects (obj_type_ VARCHAR2) IS
      SELECT po.po_id
      FROM pres_object_grant pog, pres_object po
      WHERE po.po_id=pog.po_id
      AND po.pres_object_type_db = obj_type_
      AND pog.role = role_
      ORDER BY nlssort(upper(po.po_id), 'nls_sort=binary');
BEGIN
   i_ := string_array_.count ;
   
   method_1_ := 'DECLARE' || newline_;
   method_1_ := method_1_ || '   PROCEDURE Enable_Pres_Object(' || newline_;
   method_1_ := method_1_ || '      pres_object_id_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      role_             IN VARCHAR2 )' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.Enable_Pres_Object(pres_object_id_,role_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||pres_object_id_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END Enable_Pres_Object;' || newline_||newline_;
      
   method_1_ := method_1_ || '   PROCEDURE Grant_Pres_Object(' || newline_;
   method_1_ := method_1_ || '      pres_object_id_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      role_             IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      recursive_        IN VARCHAR2)' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.Grant_Pres_Object(pres_object_id_,role_,recursive_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||pres_object_id_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END Grant_Pres_Object;' || newline_||newline_;
   
   --Add windows
   FOR id_ IN get_po_Objects('WIN') LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Windows'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Windows - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (enable_ = 'TRUE' ) THEN
         string_array_(i_) :=   '   Enable_Pres_Object(''' || id_.po_id || ''', ''' || CHR(38) || 'GRANTEE'');' ;
      ELSE
         string_array_(i_) :=   '   Grant_Pres_Object(''' || id_.po_id ||  ''', ''' || CHR(38) || 'GRANTEE'', ''FALSE'');' ;
      END IF;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add web
   obj_count_ := 0;
   FOR id_ IN get_po_Objects('WEB') LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Web'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '--  Grants on presentation objects - Web - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (enable_ = 'TRUE' ) THEN
         string_array_(i_) :=   '   Enable_Pres_Object(''' || id_.po_id || ''', ''' || CHR(38) || 'GRANTEE'');' ;
      ELSE
         string_array_(i_) :=   '   Grant_Pres_Object(''' || id_.po_id ||  ''', ''' || CHR(38) || 'GRANTEE'', ''FALSE'');' ;
      END IF;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add portlets
   obj_count_ := 0;
   FOR id_ IN get_po_Objects('PORT') LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Portlets'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Portlets - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (enable_ = 'TRUE' ) THEN
         string_array_(i_) :=   '   Enable_Pres_Object(''' || id_.po_id || ''', ''' || CHR(38) || 'GRANTEE'');' ;
      ELSE
         string_array_(i_) :=   '   Grant_Pres_Object(''' || id_.po_id ||  ''', ''' || CHR(38) || 'GRANTEE'', ''FALSE'');' ;
      END IF;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add Reports
   obj_count_ := 0;
   FOR id_ IN get_po_Objects('REP') LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '--  Grants on presentation objects - Reports'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Reports - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (enable_ = 'TRUE' ) THEN
         string_array_(i_) :=   '   Enable_Pres_Object(''' || id_.po_id || ''', ''' || CHR(38) || 'GRANTEE'');' ;
      ELSE
         string_array_(i_) :=   '   Grant_Pres_Object(''' || id_.po_id ||  ''', ''' || CHR(38) || 'GRANTEE'', ''FALSE'');' ;
      END IF;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add Others
   obj_count_ := 0;
   FOR id_ IN get_po_Objects('OTHER') LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Others'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Others - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (enable_ = 'TRUE' ) THEN
         string_array_(i_) :=   '   Enable_Pres_Object(''' || id_.po_id || ''', ''' || CHR(38) || 'GRANTEE'');' ;
      ELSE
         string_array_(i_) :=   '   Grant_Pres_Object(''' || id_.po_id ||  ''', ''' || CHR(38) || 'GRANTEE'', ''FALSE'');' ;
      END IF;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add LOBBY
   obj_count_ := 0;
   FOR id_ IN get_po_Objects('LOBBY') LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Lobby'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on presentation objects - Lobby - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (enable_ = 'TRUE' ) THEN
         string_array_(i_) :=   '   Enable_Pres_Object(''' || id_.po_id || ''', ''' || CHR(38) || 'GRANTEE'');' ;
      ELSE
         string_array_(i_) :=   '   Grant_Pres_Object(''' || id_.po_id ||  ''', ''' || CHR(38) || 'GRANTEE'', ''FALSE'');' ;
      END IF;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   IF (enable_ = 'FALSE' ) THEN
      -- Export revokes on application views (difference to presentation objects)
      Add_Db_Restric_On_Pres_Obj___(string_array_, role_);
   END IF;
END Add_Pres_Objects_To_Array___;


PROCEDURE Add_Db_Restric_On_Pres_Obj___ (
   string_array_  IN OUT Info_Array_Type,
   role_ IN VARCHAR2 )
IS
   CURSOR get_view_restrictions IS
      SELECT DISTINCT A.sec_object
      FROM pres_object_security_avail A, pres_object_grant B
      WHERE NOT EXISTS(SELECT 1
      FROM  security_sys_privs_tab C
      WHERE C.table_name = A.sec_object
      AND C.privilege = 'SELECT'
      AND C.grantee = B.role)
      AND A.sec_object_type_db = 'VIEW'
      AND B.po_id = A.po_id
      AND B.role = role_
      ORDER BY nlssort(A.sec_object, 'nls_sort=binary');
   CURSOR get_pkg_restrictions IS
      SELECT DISTINCT substr(A.sec_object, 1, instr(A.sec_object, '.', 1) - 1) package_name
      FROM pres_object_security_avail A, pres_object_grant B
      WHERE NOT EXISTS(SELECT 1
      FROM  security_sys_privs_tab C
      WHERE decode(instr(A.sec_object, '.', 1), 0, NULL, substr(A.sec_object, 1, instr(A.sec_object, '.', 1) - 1)) IS NOT NULL
      AND C.table_name = substr(A.sec_object, 1, instr(A.sec_object, '.', 1) - 1)
      AND C.privilege = 'EXECUTE'
      AND C.grantee = B.role)
      AND A.sec_object_type_db = 'METHOD'
      AND B.po_id = A.po_id
      AND B.role = role_
      ORDER BY nlssort(package_name, 'nls_sort=binary');
   CURSOR get_method_restrictions IS
      SELECT DISTINCT A.sec_object
      FROM pres_object_security_avail A, pres_object_grant B
      WHERE EXISTS(SELECT 1
      FROM  security_sys_privs_tab C
      WHERE decode(instr(A.sec_object, '.', 1), 0, NULL, substr(A.sec_object, 1, instr(A.sec_object, '.', 1) - 1)) IS NOT NULL
      AND C.table_name = substr(A.sec_object, 1, instr(A.sec_object, '.', 1) - 1)
      AND C.privilege = 'EXECUTE'
      AND C.grantee = B.role)
      AND   EXISTS(SELECT 1
      FROM  security_sys_tab D
      WHERE D.package_name || '.' || D.method_name = A.sec_object
      AND   D.role       = B.role)
      AND A.sec_object_type_db = 'METHOD'
      AND B.po_id = A.po_id
      AND B.role = role_
      ORDER BY nlssort(upper(A.sec_object), 'nls_sort=binary');
   i_ NUMBER:=0;
   obj_count_  NUMBER:=0;
   method_1_ VARCHAR2(4000);
   method_2_ VARCHAR2(4000);
   method_3_ VARCHAR2(4000);
BEGIN
   i_ := string_array_.count ;
   method_1_ := 'DECLARE' || newline_;
   method_1_ := method_1_ || '   PROCEDURE Revoke_View(' || newline_;
   method_1_ := method_1_ || '      view_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      role_             IN VARCHAR2 )' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.Revoke_View(view_,role_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Revokes are not executed to ''||view_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END Revoke_View;' || newline_||newline_;
   
   method_2_ := 'DECLARE' || newline_;
   method_2_ := method_2_ || '   PROCEDURE Revoke_Package(' || newline_;
   method_2_ := method_2_ || '      package_   IN VARCHAR2,' || newline_;
   method_2_ := method_2_ || '      role_             IN VARCHAR2 )' || newline_;
   method_2_ := method_2_ || '   IS' || newline_;
   method_2_ := method_2_ || '   BEGIN' || newline_;
   method_2_ := method_2_ || '      '||chr(38)||'AO..Security_SYS.Revoke_Package(package_,role_);' || newline_;
   method_2_ := method_2_ || '      COMMIT;' || newline_;
   method_2_ := method_2_ || '   EXCEPTION' || newline_;
   method_2_ := method_2_ || '      WHEN OTHERS THEN' || newline_;
   method_2_ := method_2_ || '         DBMS_OUTPUT.PUT_LINE(''Revokes are not executed to ''||package_|| '' Reason: ''||SQLERRM);' || newline_;
   method_2_ := method_2_ || '         ROLLBACK;' || newline_;
   method_2_ := method_2_ || '   END Revoke_Package;' || newline_||newline_;
   
   method_3_ := 'DECLARE' || newline_;
   method_3_ := method_3_ || '   PROCEDURE Revoke_Method(' || newline_;
   method_3_ := method_3_ || '      full_method_   IN VARCHAR2,' || newline_;
   method_3_ := method_3_ || '      role_             IN VARCHAR2 )' || newline_;
   method_3_ := method_3_ || '   IS' || newline_;
   method_3_ := method_3_ || '   BEGIN' || newline_;
   method_3_ := method_3_ || '      '||chr(38)||'AO..Security_SYS.Revoke_Method(full_method_,role_);' || newline_;
   method_3_ := method_3_ || '      COMMIT;' || newline_;
   method_3_ := method_3_ || '   EXCEPTION' || newline_;
   method_3_ := method_3_ || '      WHEN OTHERS THEN' || newline_;
   method_3_ := method_3_ || '         DBMS_OUTPUT.PUT_LINE(''Revokes are not executed to ''||full_method_|| '' Reason: ''||SQLERRM);' || newline_;
   method_3_ := method_3_ || '         ROLLBACK;' || newline_;
   method_3_ := method_3_ || '   END Revoke_Method;' || newline_||newline_;
   
   obj_count_  :=0;
   --Add View Restrictions
   FOR view_ IN get_view_restrictions LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Revokes on application views (difference to presentation objects) '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Revokes on application views (difference to presentation objects) - Cont.) '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Revoke_View(''' || view_.sec_object ||  ''', ''' || CHR(38) || 'GRANTEE'');' ;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add Package Restrictions
   obj_count_  :=0;
   FOR pkg_ IN get_pkg_restrictions LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Revokes on application packages (difference to presentation objects) '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_2_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Revokes on application packages (difference to presentation objects) - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_2_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Revoke_Package(''' || pkg_.package_name ||  ''', ''' || CHR(38) || 'GRANTEE'');' ;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add Method Restrictions
   obj_count_  :=0;
   FOR method_ IN get_method_restrictions LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Revokes on application methods (difference to presentation objects) '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_3_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Revokes on application methods (difference to presentation objects) - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_3_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Revoke_Method(''' || method_.sec_object ||  ''', ''' || CHR(38) || 'GRANTEE'');' ;
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
END Add_Db_Restric_On_Pres_Obj___;


PROCEDURE Add_Db_Objects_To_Array___ (
   string_array_  IN OUT Info_Array_Type,
   role_ IN VARCHAR2 )
IS
   --SOLSETFW
   CURSOR get_db_views IS
      SELECT A.table_name
      FROM security_sys_privs_tab A, dictionary_sys_view_active B
      WHERE A.table_name = B.view_name
      AND A.grantee = role_
      ORDER BY nlssort(A.table_name, 'nls_sort=binary');
   --SOLSETFW
   CURSOR get_db_packages IS
      SELECT A.table_name
      FROM security_sys_privs_tab A, dictionary_sys_package_active B
      WHERE A.table_name = B.package_name
      AND A.grantee = role_
      ORDER BY nlssort(A.table_name, 'nls_sort=binary');
   CURSOR get_db_revokes IS
      SELECT package_name, method_name
      FROM security_sys_tab
      WHERE role = role_
      ORDER BY nlssort(package_name, 'nls_sort=binary'), nlssort(method_name, 'nls_sort=binary');
   i_ NUMBER:=0;
   obj_count_  NUMBER:=0;
   method_1_ VARCHAR2(4000);
   method_2_ VARCHAR2(4000);
   method_3_ VARCHAR2(4000);
BEGIN
   i_ := string_array_.count ;
   method_1_ := 'DECLARE' || newline_;
   method_1_ := method_1_ || '   PROCEDURE Grant_Package(' || newline_;
   method_1_ := method_1_ || '      package_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      role_             IN VARCHAR2 )' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.Grant_Package(package_,role_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||package_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END Grant_Package;' || newline_||newline_;
   
   method_2_ := 'DECLARE' || newline_;
   method_2_ := method_2_ || '   PROCEDURE Grant_View(' || newline_;
   method_2_ := method_2_ || '      view_   IN VARCHAR2,' || newline_;
   method_2_ := method_2_ || '      role_             IN VARCHAR2 )' || newline_;
   method_2_ := method_2_ || '   IS' || newline_;
   method_2_ := method_2_ || '   BEGIN' || newline_;
   method_2_ := method_2_ || '      '||chr(38)||'AO..Security_SYS.Grant_View(view_,role_);' || newline_;
   method_2_ := method_2_ || '      COMMIT;' || newline_;
   method_2_ := method_2_ || '   EXCEPTION' || newline_;
   method_2_ := method_2_ || '      WHEN OTHERS THEN' || newline_;
   method_2_ := method_2_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||view_|| '' Reason: ''||SQLERRM);' || newline_;
   method_2_ := method_2_ || '         ROLLBACK;' || newline_;
   method_2_ := method_2_ || '   END Grant_View;' || newline_||newline_;
   
   method_3_ := 'DECLARE' || newline_;
   method_3_ := method_3_ || '   PROCEDURE Revoke_Method(' || newline_;
   method_3_ := method_3_ || '      full_method_   IN VARCHAR2,' || newline_;
   method_3_ := method_3_ || '      role_             IN VARCHAR2 )' || newline_;
   method_3_ := method_3_ || '   IS' || newline_;
   method_3_ := method_3_ || '   BEGIN' || newline_;
   method_3_ := method_3_ || '      '||chr(38)||'AO..Security_SYS.Revoke_Method(full_method_,role_);' || newline_;
   method_3_ := method_3_ || '      COMMIT;' || newline_;
   method_3_ := method_3_ || '   EXCEPTION' || newline_;
   method_3_ := method_3_ || '      WHEN OTHERS THEN' || newline_;
   method_3_ := method_3_ || '         DBMS_OUTPUT.PUT_LINE(''Revokes are not executed to ''||full_method_|| '' Reason: ''||SQLERRM);' || newline_;
   method_3_ := method_3_ || '         ROLLBACK;' || newline_;
   method_3_ := method_3_ || '   END Revoke_Method;' || newline_||newline_;
   
   --Add database views
   obj_count_  :=0;
   FOR view_ IN get_db_views LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on application views '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_2_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on application views - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_2_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Grant_View(''' || view_.table_name ||  ''', ''' || CHR(38) || 'GRANTEE'');';
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add database packages
   obj_count_  :=0;
   FOR pkg_ IN get_db_packages LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on application packages '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on application packages - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Grant_Package(''' || pkg_.table_name ||  ''', ''' || CHR(38) || 'GRANTEE'');';
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
   --Add database revokes
   obj_count_  :=0;
   FOR dbr_ IN get_db_revokes LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Revokes on application methods '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_3_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Revokes on application methods - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_3_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Revoke_Method(''' || dbr_.package_name ||  '.' || dbr_.method_name || ''', ''' || CHR(38) || 'GRANTEE'');';
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
      i_:= i_ - 1 ;
   END IF;
END Add_Db_Objects_To_Array___;


PROCEDURE Add_Ial_Objects_To_Array___ (
   string_array_  IN OUT Info_Array_Type,
   role_     IN VARCHAR2,
   ial_user_ IN VARCHAR2 )
IS
   CURSOR get_ial_objects IS
      SELECT table_name
      FROM all_tab_privs
      WHERE table_schema = ial_user_
      AND grantee = role_
      ORDER BY nlssort(table_name, 'nls_sort=binary');
   i_ NUMBER:=0;
   obj_count_  NUMBER:=0;
   method_1_ VARCHAR2(4000);
BEGIN
   i_ := string_array_.count ;
   method_1_ := 'DECLARE' || newline_;
   method_1_ := method_1_ || '   PROCEDURE Grant_IAL_View(' || newline_;
   method_1_ := method_1_ || '      view_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      role_             IN VARCHAR2 )' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.Grant_IAL_View(view_,role_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||view_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END Grant_IAL_View;' || newline_||newline_;
   
   FOR ial_ IN get_ial_objects LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on Information Access Layer objects'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on Information Access Layer objects - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Grant_IAL_View(''' || ial_.table_name || ''', ''' || CHR(38) || 'GRANTEE'');';
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
   END IF;
END Add_Ial_Objects_To_Array___;


PROCEDURE Add_Activities_To_Array___ (
   string_array_  IN OUT Info_Array_Type,
   role_ IN VARCHAR2 )
IS
   CURSOR get_activities IS
      SELECT activity_name
      FROM activity_grant_tab
      WHERE role = role_
      ORDER BY nlssort(activity_name, 'nls_sort=binary');
   i_ NUMBER:=0;
   obj_count_  NUMBER:=0;
   method_1_ VARCHAR2(4000);
BEGIN
   i_ := string_array_.count ;
   
   method_1_ := method_1_ || 'DECLARE' || newline_;
   method_1_ := method_1_ || '   PROCEDURE Grant_Activity(' || newline_;
   method_1_ := method_1_ || '      activity_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      role_             IN VARCHAR2 )' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.Grant_Activity(activity_,role_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||activity_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END Grant_Activity;' || newline_||newline_;
   FOR act_ IN get_activities LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on Activities'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on Activities - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Grant_Activity(''' || act_.activity_name || ''', ''' || CHR(38) || 'GRANTEE'');';
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
   END IF;
END Add_Activities_To_Array___;

PROCEDURE Add_Proj_Grants_To_Array___ (
   string_array_ IN OUT Info_Array_Type,
   role_ IN VARCHAR2 )
IS
   CURSOR get_projection_grants IS
      SELECT projection
      FROM fnd_projection_grant_tab
      WHERE role=role_;
      
   CURSOR get_proj_action_grants (projection_ IN VARCHAR2) IS
      SELECT action
      FROM fnd_proj_action_grant_tab
      WHERE projection=projection_
         AND role=role_;
   
   CURSOR get_proj_entity_grants (projection1_ IN VARCHAR2) IS
      SELECT entity,cud_allowed
      FROM fnd_proj_entity_grant_tab
      WHERE projection=projection1_
         AND role=role_;
   
   CURSOR get_proj_ent_action_grants (projection2_ IN VARCHAR2, entity_ IN VARCHAR2) IS
      SELECT action
      FROM fnd_proj_ent_action_grant_tab
      WHERE projection=projection2_
         AND entity=entity_
         AND role=role_;
   i_ NUMBER:=0;
   obj_count_  NUMBER:=0;
   method_ VARCHAR2(4000);

BEGIN
   i_ := string_array_.COUNT;
   
   method_ := 'DECLARE' || newline_;
   method_ := method_ || '   PROCEDURE Proj_Grant_Query(' || newline_;
   method_ := method_ || '      projection_   IN VARCHAR2,' || newline_;
   method_ := method_ || '      role_         IN VARCHAR2 )' || newline_;
   method_ := method_ || '   IS' || newline_;
   method_ := method_ || '   BEGIN' || newline_;
   method_ := method_ || '      '||chr(38)||'AO..Fnd_Projection_Grant_API.Grant_Query(projection_,role_);' || newline_;
   method_ := method_ || '      COMMIT;' || newline_;
   method_ := method_ || '   EXCEPTION' || newline_;
   method_ := method_ || '      WHEN OTHERS THEN' || newline_;
   method_ := method_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||projection_|| '' Reason: ''||SQLERRM);' || newline_;
   method_ := method_ || '         ROLLBACK;' || newline_;
   method_ := method_ || '   END Proj_Grant_Query;' || newline_||newline_;
   
   method_ := method_ || '   PROCEDURE Proj_Do_Grant(' || newline_;
   method_ := method_ || '      projection_   IN VARCHAR2,' || newline_;
   method_ := method_ || '      grant_action_ IN VARCHAR2,' || newline_;
   method_ := method_ || '      role_             IN VARCHAR2 )' || newline_;
   method_ := method_ || '   IS' || newline_;
   method_ := method_ || '   BEGIN' || newline_;
   method_ := method_ || '      '||chr(38)||'AO..Fnd_Proj_Action_Grant_API.Do_Grant(projection_,grant_action_,role_);' || newline_;
   method_ := method_ || '      COMMIT;' || newline_;
   method_ := method_ || '   EXCEPTION' || newline_;
   method_ := method_ || '      WHEN OTHERS THEN' || newline_;
   method_ := method_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||projection_|| '' Reason: ''||SQLERRM);' || newline_;
   method_ := method_ || '         ROLLBACK;' || newline_;
   method_ := method_ || '   END Proj_Do_Grant;' || newline_||newline_;   

   method_ := method_ || '   PROCEDURE Proj_Grant_CUD(' || newline_;
   method_ := method_ || '      projection_   IN VARCHAR2,' || newline_;
   method_ := method_ || '      entity_       IN VARCHAR2,' || newline_;
   method_ := method_ || '      role_         IN VARCHAR2 )' || newline_;
   method_ := method_ || '   IS' || newline_;
   method_ := method_ || '   BEGIN' || newline_;
   method_ := method_ || '      '||chr(38)||'AO..Fnd_Proj_Entity_Grant_API.Grant_CUD(projection_,entity_,role_);' || newline_;
   method_ := method_ || '      COMMIT;' || newline_;
   method_ := method_ || '   EXCEPTION' || newline_;
   method_ := method_ || '      WHEN OTHERS THEN' || newline_;
   method_ := method_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||projection_|| '' Reason: ''||SQLERRM);' || newline_;
   method_ := method_ || '         ROLLBACK;' || newline_;
   method_ := method_ || '   END Proj_Grant_CUD;' || newline_||newline_;   
  
   method_ := method_ || '   PROCEDURE Proj_Ent_Do_Grant(' || newline_;
   method_ := method_ || '      projection_   IN VARCHAR2,' || newline_;
   method_ := method_ || '      entity_       IN VARCHAR2,' || newline_;
   method_ := method_ || '      action_ IN VARCHAR2,' || newline_;
   method_ := method_ || '      role_         IN VARCHAR2 )' || newline_;
   method_ := method_ || '   IS' || newline_;
   method_ := method_ || '   BEGIN' || newline_;
   method_ := method_ || '      '||chr(38)||'AO..Fnd_Proj_Ent_Action_Grant_API.Do_Grant(projection_,entity_,action_,role_);' || newline_;
   method_ := method_ || '      COMMIT;' || newline_;
   method_ := method_ || '   EXCEPTION' || newline_;
   method_ := method_ || '      WHEN OTHERS THEN' || newline_;
   method_ := method_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||projection_|| '' Reason: ''||SQLERRM);' || newline_;
   method_ := method_ || '         ROLLBACK;' || newline_;
   method_ := method_ || '   END Proj_Ent_Do_Grant;' || newline_||newline_;
   
   FOR proj_grant_rec_ IN get_projection_grants LOOP      
      i_ := i_ + 1;
      
      
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ ||  '-- Grants on Projections '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_;
         Begin_Section___(string_array_, i_, '--');         
      END IF;
      
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ ||  '-- Grants on Projections '|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_;
         Begin_Section___(string_array_, i_, '--'); 
      END IF;
      
      string_array_(i_) := '   Proj_Grant_Query(''' || 
                           proj_grant_rec_.projection || ''', ''' || CHR(38) || 'GRANTEE'');';
      
      obj_count_ := obj_count_ +1;
      
      FOR proj_action_grant_rec_ IN get_proj_action_grants (proj_grant_rec_.projection) LOOP
         
         i_ := i_ + 1;
         
         
         IF (MOD(obj_count_+1, 1000) = 0)  THEN
            End_Section___(string_array_, i_);
            string_array_(i_) := '--' || newline_ ||  '-- Grants on Projections '|| newline_ ||'--'|| newline_ || newline_;
            string_array_(i_) := string_array_(i_) || method_;
            Begin_Section___(string_array_, i_, '--'); 
         END IF;
         
         string_array_(i_) := '   Proj_Do_Grant(''' || 
                           proj_grant_rec_.projection || ''', ''' || proj_action_grant_rec_.action || 
                           ''', ''' || CHR(38) || 'GRANTEE'');';
                           
         obj_count_ := obj_count_ +1;
         
      END LOOP;
      
      FOR proj_entity_grant_rec_ IN get_proj_entity_grants (proj_grant_rec_.projection) LOOP
         IF (proj_entity_grant_rec_.cud_allowed = Fnd_Boolean_API.DB_TRUE) THEN 
            
            i_ := i_ + 1;
            
            
            IF (MOD(obj_count_+1, 1000) = 0)  THEN
               End_Section___(string_array_, i_);
               string_array_(i_) := '--' || newline_ ||  '-- Grants on Projections '|| newline_ ||'--'|| newline_ || newline_;
               string_array_(i_) := string_array_(i_) || method_;
               Begin_Section___(string_array_, i_, '--'); 
            END IF;
            
            string_array_(i_) := '   Proj_Grant_CUD(''' || 
                              proj_grant_rec_.projection || ''', ''' || proj_entity_grant_rec_.entity ||
                              ''', ''' || CHR(38) || 'GRANTEE'');';
            obj_count_ := obj_count_ +1;
         END IF; 
         
         FOR proj_ent_action_grant_rec_ IN get_proj_ent_action_grants (proj_grant_rec_.projection,proj_entity_grant_rec_.entity) LOOP 
            
            i_ := i_ + 1;
            
            
            IF (MOD(obj_count_+1, 1000) = 0)  THEN
               End_Section___(string_array_, i_);
               string_array_(i_) := '--' || newline_ ||  '-- Grants on Projections '|| newline_ ||'--'|| newline_ || newline_;
               string_array_(i_) := string_array_(i_) || method_;
               Begin_Section___(string_array_, i_, '--'); 
            END IF;
            
            string_array_(i_) := '   Proj_Ent_Do_Grant(''' || 
                              proj_grant_rec_.projection || ''', ''' || proj_entity_grant_rec_.entity || 
                              ''', ''' ||  proj_ent_action_grant_rec_.action || ''', ''' || CHR(38) || 'GRANTEE'');';
                              
            obj_count_ := obj_count_ +1;
            
         END LOOP;
         
      END LOOP;  
   END LOOP;
   
   IF (obj_count_ >0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);      
   END IF;
   
END Add_Proj_Grants_To_Array___;
      
PROCEDURE Add_Role_Grants_To_Array___ (
   string_array_  IN OUT Info_Array_Type,
   role_ IN VARCHAR2 )
IS
   CURSOR get_all_connected IS
      SELECT granted_role
        FROM fnd_role_role
       WHERE grantee_type = 'ROLE'
         AND grantee = role_;

   TYPE role_table IS TABLE OF get_all_connected%ROWTYPE;
   connected_roles_ role_table;
   i_ NUMBER;
   method_1_ VARCHAR2(4000);
BEGIN
   
   method_1_ := method_1_ || 'DECLARE' || newline_;
   method_1_ := method_1_ || '   PROCEDURE New_Role_Grant(' || newline_;
   method_1_ := method_1_ || '      role_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      grantee_             IN VARCHAR2 )' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.New_Role_Grant(role_,grantee_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||role_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END New_Role_Grant;' || newline_||newline_;
   
   OPEN  get_all_connected;
   FETCH get_all_connected BULK COLLECT INTO connected_roles_;
   CLOSE get_all_connected;

   IF connected_roles_.COUNT > 0 THEN
      i_ := string_array_.count;
      i_ := i_ + 1 ;
      string_array_(i_) := '--' || newline_ || '-- Export role grants'|| newline_ ||'--'|| newline_ || newline_;
      string_array_(i_) := string_array_(i_) || method_1_;
      Begin_Section___(string_array_, i_, '--');
      i_ := i_ -1;
      FOR k_ IN connected_roles_.FIRST .. connected_roles_.LAST LOOP
         string_array_(i_) := string_array_(i_) || newline_ || '   New_Role_Grant(''' || connected_roles_(k_).granted_role || ''', ''' || CHR(38) || 'GRANTEE'');';
      END LOOP;
      i_ := i_ + 1 ;
      End_Section___(string_array_, i_);
   END IF;
END Add_Role_Grants_To_Array___;


PROCEDURE Add_To_Export_Files___ (
   string_    IN CLOB,
   export_id_ IN VARCHAR2,
   role_      IN VARCHAR2 )
IS
BEGIN
   -- Write the generated CLOB to the export table
   INSERT INTO pres_object_sec_export_tab (export_id, role_name, created_date, rowversion, file_data)
      VALUES (export_id_, role_, sysdate, sysdate, string_);
END Add_To_Export_Files___;


FUNCTION List_User_System_Privileges___ (
   fnd_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   sp_list_   sec_struct_type;
   sp_temp_   VARCHAR2(2000);
BEGIN
   IF (Is_App_Owner(fnd_user_)) THEN
      SELECT privilege_id
      BULK   COLLECT INTO sp_list_
      FROM   system_privilege_tab;
   ELSE
      SELECT DISTINCT privilege_id
      BULK   COLLECT INTO sp_list_
      FROM system_privilege_grant s,
           fnd_user_role_runtime_tab r,
           fnd_user b
      WHERE r.identity = fnd_user_
      AND   r.role = s.role
      AND   b.identity = r.identity
      AND   b.active = 'TRUE';
   END IF;
   FOR i IN nvl(sp_list_.FIRST, 0)..nvl(sp_list_.LAST, -1) LOOP
      sp_temp_ := sp_temp_ || sp_list_(i) || field_separator_;
   END LOOP;
   RETURN sp_temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END List_User_System_Privileges___;


FUNCTION Is_Ltu_Role___ (
   role_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_ltu_role IS
      SELECT 1
      FROM fnd_role_tab t
      WHERE t.role = role_
      AND nvl(t.limited_task_user,'FALSE') = 'TRUE'; 
BEGIN
   OPEN get_ltu_role;
   FETCH get_ltu_role INTO dummy_;
   IF (get_ltu_role%FOUND) THEN
      CLOSE get_ltu_role;
      RETURN(TRUE);
   END IF;
   CLOSE get_ltu_role;
   RETURN(FALSE);
END Is_Ltu_Role___;

FUNCTION Is_Atu_Role___ (
   role_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_atu_role IS
      SELECT 1
      FROM fnd_role_tab t
      WHERE t.role = role_
      AND nvl(t.additional_task_user,'FALSE') = 'TRUE'; 
BEGIN
   OPEN get_atu_role;
   FETCH get_atu_role INTO dummy_;
   IF (get_atu_role%FOUND) THEN
      CLOSE get_atu_role;
      RETURN(TRUE);
   END IF;
   CLOSE get_atu_role;
   RETURN(FALSE);
END Is_Atu_Role___;

FUNCTION Is_Technical_Role___ (
   role_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   IF role_ IN ('FND_WEBRUNTIME') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Technical_Role___;

FUNCTION Get_Restricted_Method_List___ RETURN CLOB 
IS
   fnd_user_  VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   -- Method restrictions
   CURSOR restrictions IS
      SELECT s.package_name pkg,
             upper(s.method_name) method,
             s.role
      FROM   security_sys_tab s, fnd_user_role_runtime_tab f
      WHERE  s.role = f.ROLE
      AND    f.identity = fnd_user_
      ORDER BY nlssort(s.package_name, 'nls_sort=binary'),
             nlssort(upper(s.method_name), 'nls_sort=binary'),
             nlssort(s.role, 'nls_sort=binary');
   -- Package grants
   CURSOR grants IS
      SELECT s.table_name pkg, s.grantee ROLE
      FROM   security_sys_privs_tab s, fnd_user_role_runtime_tab f
      WHERE  s.privilege = 'EXECUTE'
      AND    s.grantee = f.ROLE
      AND    f.identity = fnd_user_
      ORDER BY nlssort(s.table_name,'nls_sort=binary'),
             nlssort(s.grantee,   'nls_sort=binary');

   first_pkg_  CONSTANT VARCHAR2(1) := chr(0);
   last_pkg_   CONSTANT VARCHAR2(1) := chr(127);
   res_        restrictions%ROWTYPE;
   gra_        grants%ROWTYPE;

   res_pkg_    VARCHAR2(100)   := NULL;
   res_method_ VARCHAR2(100)   := NULL;
   res_roles_  VARCHAR2(4000)  := NULL;

   gra_pkg_    VARCHAR2(100)   := NULL;
   gra_roles_  VARCHAR2(4000)  := NULL;

   curr_pkg_   VARCHAR2(100)   := first_pkg_;
   met_list_   VARCHAR2(32767);
   ind_        NUMBER := 1;
   
   msg_        CLOB;

PROCEDURE Fetch_Restricted_Method___ IS  -- into res_pkg_, res_method_, res_roles_
BEGIN
   res_pkg_    := NULL;
   res_method_ := NULL;
   res_roles_  := NULL;
   LOOP
      IF restrictions%ROWCOUNT = 0 OR res_method_ IS NOT NULL THEN
         FETCH restrictions INTO res_;
      END IF;
      IF restrictions%NOTFOUND THEN
         IF res_method_ IS NULL THEN
            res_pkg_ := last_pkg_;
         END IF;
         RETURN;
      END IF;
      IF res_method_ IS NULL THEN
         --
         --  New method. Initiate output variables.
         --
         res_pkg_    := res_.pkg;
         res_method_ := res_.method;
         res_roles_  := ',';
      END IF;
      IF res_.pkg = res_pkg_ AND res_.method = res_method_ THEN
         --
         --  Store the next role for current method
         --
         res_roles_  := res_roles_ || res_.role || ',';
      ELSE
         --
         --  Return previous method. Fetched row will stay in cache
         --  until the next call to this procedure.
         --
         RETURN;
      END IF;
   END LOOP;
END Fetch_Restricted_Method___;

PROCEDURE Fetch_Granted_Package___ IS  -- into gra_pkg_, gra_roles_
BEGIN
   gra_pkg_   := NULL;
   gra_roles_ := NULL;
   LOOP
      IF grants%ROWCOUNT = 0 OR gra_pkg_ IS NOT NULL THEN
         FETCH grants INTO gra_;
      END IF;
      IF grants%NOTFOUND THEN
         IF gra_pkg_ IS NULL THEN
            gra_pkg_ := last_pkg_;
         END IF;
         RETURN;
      END IF;
      IF gra_pkg_ IS NULL THEN
         --
         --  New package. Initiate output variables
         --
         gra_pkg_   := gra_.pkg;
         gra_roles_ := ',';
      END IF;
      IF gra_.pkg = gra_pkg_ THEN
         --
         --  Store the next role for current package
         --
         gra_roles_  := gra_roles_ || gra_.role || ',';
      ELSE
         --
         --  Return previous package. Fetched row will stay in cache
         --  until next call to this procedure.
         --
         RETURN;
      END IF;
   END LOOP;
END Fetch_Granted_Package___;

BEGIN
   --
   -- Read information into memory
   --
   OPEN restrictions;
   Fetch_Restricted_Method___;
   OPEN grants;
   Fetch_Granted_Package___;
   --
   -- Traverse memory and build the active restriction list
   --
   WHILE res_pkg_ < last_pkg_ OR gra_pkg_ < last_pkg_ LOOP
      IF res_pkg_ = gra_pkg_ AND res_roles_ = gra_roles_ THEN
         --
         --  Same package and role list. Append restricted method to the list.
         --
         IF res_pkg_ <> curr_pkg_ THEN
            --
            --  A new package. Append it to the list.
            --
            IF (ind_ != 1) THEN
               msg_ := msg_ ||to_clob(curr_pkg_||met_list_||';');
            END IF;
            met_list_ :=  NULL;
            curr_pkg_ := res_pkg_;
            ind_ := ind_ + 1;
         END IF;
         met_list_ := met_list_ || (',' || res_method_);
      END IF;
      IF nlssort(res_pkg_,'nls_sort=binary') <= nlssort(gra_pkg_,'nls_sort=binary')
      THEN
         Fetch_Restricted_Method___;
      ELSE
         Fetch_Granted_Package___;
      END IF;
   END LOOP;
   CLOSE restrictions;
   CLOSE grants;
   --Add the last restriction
   IF (met_list_ IS NOT NULL) THEN 
      msg_ := msg_ ||to_clob(curr_pkg_||met_list_||';');
   END IF;
   RETURN(msg_);
END Get_Restricted_Method_List___;


FUNCTION Get_Pres_Object_List___ RETURN CLOB 
IS
   fnd_user_               VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   pres_object_security_   BOOLEAN := (Fnd_User_API.Get_Pres_Security_Setup(fnd_user_) = 'ON');
   poid_                   sec_struct_type;
   pos_                    CLOB;
   po_list_                VARCHAR2(32767);
BEGIN
   IF (Security_SYS.Is_App_Owner(fnd_user_)) OR NOT pres_object_security_ THEN -- Can not use System Privilege here
      --
      -- User is appowner or Presentation Object Security is not 'ON' for this user.
      --
      SELECT po_id
      BULK   COLLECT INTO poid_
      FROM   pres_object_tab B;
   ELSE
      --
      -- Presentation Object Security is on for this user
      --
      --SOLSETFW
      SELECT DISTINCT a.po_id
        BULK COLLECT INTO poid_
        FROM pres_object_grant_tab a, pres_object_tab b
       WHERE EXISTS (SELECT 1 FROM module_tab m
                      WHERE b.module = m.module
                        AND m.active = 'TRUE')
         AND a.role IN (SELECT ROLE
                          FROM fnd_user_role_runtime_tab
                         WHERE identity = fnd_user_)
         AND a.po_id = b.po_id
         AND b.pres_object_type IN ('WIN', 'REP', 'HUD', 'LOBBY','OTHER');
   END IF;
   --
   FOR i IN nvl(poid_.FIRST, 0)..nvl(poid_.LAST, -1) LOOP
      po_list_ := po_list_||poid_(i)||',';
      IF (length(po_list_) + 1000 > 32000) THEN
          pos_ := pos_ || po_list_;
          po_list_ := NULL;
      END IF;
   END LOOP;
   pos_ := pos_ || po_list_;
   RETURN(pos_);
END Get_Pres_Object_List___;


FUNCTION Get_System_Privileges___  RETURN CLOB
IS
   fnd_user_  VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   sp_list_   sec_struct_type;
   sp_temp_   CLOB;
BEGIN
   IF (Security_SYS.Is_App_Owner(fnd_user_)) THEN
      SELECT privilege_id
      BULK   COLLECT INTO sp_list_
      FROM   system_privilege_tab;
   ELSE
      SELECT DISTINCT privilege_id
      BULK   COLLECT INTO sp_list_
      FROM system_privilege_grant s,
             fnd_user_role_runtime_tab r,
             fnd_user b
      WHERE r.identity = fnd_user_
      AND   r.role = s.role
      AND   b.identity = r.identity
      AND   b.active = 'TRUE';
   END IF;
   FOR i IN nvl(sp_list_.FIRST, 0)..nvl(sp_list_.LAST, -1) LOOP
      sp_temp_ := sp_temp_ || to_clob(sp_list_(i)||',');
   END LOOP;
   RETURN(sp_temp_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_System_Privileges___;


FUNCTION Get_Activities___ RETURN CLOB
IS
   fnd_user_  VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   act_list_  sec_struct_type;
   cact_      CLOB;
   act_       VARCHAR2(32767);
BEGIN
   IF (Security_SYS.Is_App_Owner(fnd_user_)) THEN
      SELECT DISTINCT activity_name
      BULK   COLLECT INTO act_list_
      FROM   activity_grant_tab;
   ELSE
      SELECT DISTINCT s.activity_name
      BULK   COLLECT INTO act_list_
      FROM activity_grant_tab s,
             fnd_user_role_runtime_tab r
      WHERE r.identity = fnd_user_
      AND   r.role = s.role;
   END IF;
   FOR i IN nvl(act_list_.FIRST, 0)..nvl(act_list_.LAST, -1) LOOP
      act_ := act_  || act_list_(i) || ',';
      IF (mod(i,1000) = 0) THEN
       cact_ := cact_ || act_;
       act_ := NULL;
      END IF;
   END LOOP;
   cact_ := cact_ || act_;
   RETURN(cact_);
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Activities___;


PROCEDURE Add_System_Priv_To_Array___ (
   string_array_  IN OUT Info_Array_Type,
   role_ IN VARCHAR2 )
IS
   CURSOR get_sys_privs IS
      SELECT privilege_id
      FROM system_privilege_grant_tab
      WHERE role = role_
      ORDER BY nlssort(privilege_id, 'nls_sort=binary');
   i_ NUMBER:=0;
   obj_count_  NUMBER:=0;
   method_1_ VARCHAR2(4000);
BEGIN
   i_ := string_array_.count ;
   method_1_ := method_1_ || 'DECLARE' || newline_;
   method_1_ := method_1_ || '   PROCEDURE Grant_System_Privilege(' || newline_;
   method_1_ := method_1_ || '      privilege_id_   IN VARCHAR2,' || newline_;
   method_1_ := method_1_ || '      role_             IN VARCHAR2 )' || newline_;
   method_1_ := method_1_ || '   IS' || newline_;
   method_1_ := method_1_ || '   BEGIN' || newline_;
   method_1_ := method_1_ || '      '||chr(38)||'AO..Security_SYS.Grant_System_Privilege(privilege_id_,role_);' || newline_;
   method_1_ := method_1_ || '      COMMIT;' || newline_;
   method_1_ := method_1_ || '   EXCEPTION' || newline_;
   method_1_ := method_1_ || '      WHEN OTHERS THEN' || newline_;
   method_1_ := method_1_ || '         DBMS_OUTPUT.PUT_LINE(''Grants are not executed to ''||privilege_id_|| '' Reason: ''||SQLERRM);' || newline_;
   method_1_ := method_1_ || '         ROLLBACK;' || newline_;
   method_1_ := method_1_ || '   END Grant_System_Privilege;' || newline_||newline_;
   FOR rec_ IN get_sys_privs LOOP
      i_:= i_ +1 ;
      IF (obj_count_ = 0) THEN
         string_array_(i_) := '--' || newline_ || '-- Grants on System Privileges'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      IF (MOD(obj_count_+1, 1000) = 0)  THEN
         End_Section___(string_array_, i_);
         string_array_(i_) := '--' || newline_ || '-- Grants on System Privileges - Cont.'|| newline_ ||'--'|| newline_ || newline_;
         string_array_(i_) := string_array_(i_) || method_1_;
         Begin_Section___(string_array_, i_, '--');
      END IF;
      string_array_(i_) := '   Grant_System_Privilege(''' || rec_.privilege_id || ''', ''' || CHR(38) || 'GRANTEE'');';
      obj_count_ := obj_count_ +1;
   END LOOP;
   IF (obj_count_ > 0 ) THEN
      i_:= i_ +1 ;
      End_Section___(string_array_, i_);
   END IF;
END Add_System_Priv_To_Array___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Cleanup__
IS
   app_owner_             VARCHAR2(30)         := Fnd_Session_API.Get_App_Owner;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Cleanup__');

   --
   -- Remove invalid PRAGMA entries in table for method restrictions (to maintain consistency).
   --
   --SOLSETFW
   DELETE FROM security_sys_tab s
   WHERE EXISTS (SELECT 1
                 FROM security_sys_privs_tab    p,
                      dictionary_sys_method_active d
                WHERE p.grantee = s.role
                  AND p.privilege = 'EXECUTE'
                  AND p.table_name = d.package_name
                  AND d.package_name = s.package_name
                  AND d.method_name = s.method_name
                  AND d.method_type = 'P');
   
   --
   -- Remove invalid entries in table for presentation object grants (to maintain consistency)
   --
   DELETE FROM pres_object_grant_tab
      WHERE po_id NOT IN 
      (SELECT po_id
         FROM pres_object)
      AND role NOT IN
      (SELECT role
       FROM fnd_role_tab
       WHERE nvl(limited_task_user,'FALSE') = 'TRUE');
   
   --
   -- Remove invalid entries in table for method-level security
   --
   DELETE FROM security_sys_tab A
   WHERE role NOT IN
      (SELECT grantee
       FROM all_tab_privs_made
       WHERE owner = app_owner_ AND table_name = A.package_name);   
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT;
   
 
   --
   -- Fix package and view grants
   --
   DELETE FROM security_sys_privs_tab;  
   INSERT INTO security_sys_privs_tab
      (grantee, table_name, privilege)
   SELECT grantee, table_name, privilege
      FROM   all_tab_privs_made
      WHERE  owner = app_owner_ AND privilege IN ('EXECUTE', 'SELECT')
      AND    grantee IN (SELECT role
                         FROM fnd_role_tab)
      AND    table_name IN (SELECT object_name
                            FROM  user_objects
                            WHERE object_type IN ('PACKAGE', 'VIEW')
      AND    grantor = app_owner_);
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT;
   
   
   -- Remove the grants to missing projection objects--------------------
      FOR rec_ IN (SELECT projection, role
                     FROM fnd_projection_grant_tab
                    WHERE projection NOT IN (SELECT projection_name FROM fnd_projection_tab)) LOOP
         Fnd_Projection_Grant_API.Revoke_All(rec_.projection, rec_.role);
      END LOOP;
      FOR rec_ IN (SELECT projection, action, role
                     FROM fnd_proj_action_grant_tab
                    WHERE (projection, action) NOT IN (SELECT projection_name, action_name FROM fnd_proj_action_tab)) LOOP
         Fnd_Proj_Action_Grant_API.Do_Revoke(rec_.projection,
                                             rec_.action,
                                             rec_.role);
      END LOOP;
      FOR rec_ IN (SELECT projection, entity, role
                     FROM fnd_proj_entity_grant_tab
                    WHERE (projection, entity) NOT IN (SELECT projection_name, entity_name FROM fnd_proj_entity tab)) LOOP
         Fnd_Proj_Entity_Grant_API.Revoke_All_(rec_.projection,
                                               rec_.entity,
                                               rec_.role);
      END LOOP;
      FOR rec_ IN (SELECT projection, entity, action, role
                     FROM fnd_proj_ent_action_grant_tab
                    WHERE (projection, entity, action) NOT IN (SELECT projection_name, entity_name, action_name FROM fnd_proj_ent_action_tab)) LOOP
         Fnd_Proj_Ent_Action_Grant_API.Do_Revoke(rec_.projection,
                                                 rec_.entity,
                                                 rec_.action,
                                                 rec_.role);
      END LOOP;
   @ApproveTransactionStatement(2016-12-22,wawilk)
   COMMIT;
   --------------------------------------------------------------------------
   
END Cleanup__;


-- Refresh_Active_List__
--   This method is meant to refresh the internal help table where the
--   the grants are stored for optimal performance.
PROCEDURE Refresh_Active_List__ (
   dummy_ IN NUMBER )
IS
   refresh_user_count_ INTEGER;
   refresh_start_      NUMBER  := Dbms_Utility.Get_Time;
   sql_start_          NUMBER  := refresh_start_;
   sql_end_            NUMBER;
   request_id_         VARCHAR2(100) := Fnd_Context_SYS.Find_Value('REQUEST_ID');

   PROCEDURE Log(msg_ VARCHAR2) IS
   BEGIN
      Log_SYS.Fnd_Trace_(Log_SYS.trace_, msg_);
   END Log;

   FUNCTION Sql_Time RETURN NUMBER IS
      time_ NUMBER;
   BEGIN
      sql_end_ := Dbms_Utility.Get_Time;
      time_ := (sql_end_ - sql_start_) / 100;
      sql_start_ := sql_end_;
      RETURN time_;
   END Sql_Time;

   FUNCTION Total_Time RETURN NUMBER IS
   BEGIN
      RETURN (Dbms_Utility.Get_Time - refresh_start_) / 100;
   END Total_Time;

   PROCEDURE Rows_Processed (action_ VARCHAR2) IS
   BEGIN
      Log(rpad('   ' || SQL%rowcount || ' rows ' || action_, 30) || '(' || Sql_Time || ' sec)');
   END Rows_Processed;

   PROCEDURE Rows_Deleted IS
   BEGIN
      Rows_Processed('deleted');
   END Rows_Deleted;

   PROCEDURE Rows_Inserted IS
   BEGIN
      Rows_Processed('inserted');
   END Rows_Inserted;

BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Refresh_Active_List__');
   /*
      Some parts of the refresh of security cache has been moved to a seperate method called Cleanup__.
      Cleanup__ can be run as a scheduled task.
   */

   Log('Removing old rows from input table SECURITY_SYS_REFRESH_USER_TAB not owned by current request [' || request_id_ || ']');
   DELETE FROM security_sys_refresh_user_tab WHERE request_id_ IS NULL OR request_id <> request_id_;
   Rows_Deleted;

   Log('Copying FND roles from fnd_grant_role_tab to SECURITY_SYS_ROLE_TREE_TAB:');
   DELETE FROM security_sys_role_tree_tab;
   Rows_Deleted;

   INSERT INTO security_sys_role_tree_tab (role, granted_role)
   SELECT p.granted_role, p.role -- the role granted and the granted role
     FROM fnd_grant_role_tab p, fnd_role_tab r1, fnd_role_tab r2
    WHERE p.role = r2.role
      AND p.granted_role = r1.role;
   Rows_Inserted;

   Log('Expanding FND role structure to SECURITY_SYS_EXPANDED_ROLE_TAB:');
   DELETE FROM security_sys_expanded_role_tab;
   Rows_Deleted;

   INSERT INTO security_sys_expanded_role_tab (role, granted_role)
   SELECT DISTINCT CONNECT_BY_ROOT role role, granted_role
     FROM security_sys_role_tree_tab
   CONNECT BY NOCYCLE PRIOR granted_role = role
   UNION
   SELECT role, role FROM fnd_role_tab;
   Rows_Inserted;

   -- Check input to this procedure (a temporary table with user identities)
   SELECT count(*) INTO refresh_user_count_ FROM security_sys_refresh_user_tab;

   IF refresh_user_count_ = 0 THEN
      Log('Refreshing cache table FND_USER_ROLE_RUNTIME_TAB by synchronizing with target view');

      DELETE FROM fnd_user_role_runtime_tab WHERE (identity, role) IN
       (SELECT identity, role FROM fnd_user_role_runtime_tab
         MINUS
        SELECT identity, role FROM security_sys_user_role_tmp);
      Rows_Deleted;

      INSERT INTO fnd_user_role_runtime_tab (identity, role)
      SELECT identity, role FROM security_sys_user_role_tmp
       MINUS
      SELECT identity, role FROM fnd_user_role_runtime_tab;
      Rows_Inserted;
   ELSE
      Log('Refreshing cache table FND_USER_ROLE_RUNTIME_TAB for ' || refresh_user_count_ || ' users');

      DELETE FROM fnd_user_role_runtime_tab
       WHERE identity IN (SELECT identity FROM security_sys_refresh_user_tab);
      Rows_Deleted;

      INSERT INTO fnd_user_role_runtime_tab (identity, role)
      SELECT identity, role FROM security_sys_user_role_tmp
       WHERE identity IN (SELECT identity FROM security_sys_refresh_user_tab);
      Rows_Inserted;

      @ApproveDynamicStatement(200140829,haarse)
      EXECUTE IMMEDIATE 'TRUNCATE TABLE security_sys_refresh_user_tab'; -- clear temporary table that preserves rows on commit
   END IF;

   Cache_Management_API.Refresh_Cache('Security');
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT;

   -- TODO: we do not support activities any longer...
   /*
   Log('Calling ManageApplicationServerCache.ClearSecurityCache');
   DECLARE
      record_  PLSQLAP_Record_API.type_record_;
   BEGIN
      record_ := PLSQLAP_Record_API.New_Record('');
      PLSQLAP_Server_API.Invoke_Record_('ManageApplicationServerCache', 'ClearSecurityCache', record_, activity_ => TRUE);

      --  Begin Bug# 62400: PLSQLAP_BUFFER_TMP resource utilization
      PLSQLAP_Record_API.Clear_Record(record_);
      --  End Bug# 62400: PLSQLAP_BUFFER_TMP resource utilization
   EXCEPTION
      WHEN OTHERS THEN
         -- Don't stop if error occurs
         Log('Ignored error when calling ManageApplicationServerCache.ClearSecurityCache: ' || SQLERRM);

         --  Begin Bug# 62400: PLSQLAP_BUFFER_TMP resource utilization
         PLSQLAP_Record_API.Clear_Record(record_);
         --  End Bug# 62400: PLSQLAP_BUFFER_TMP resource utilization
   END;
   */
   
   IF Installation_SYS.Method_Exist('MOBILE_CLIENT_SYS','Refresh_Security_List_') THEN
      --
      -- Notify Mobile applications in FNDMOB when FNDBAS security cache is modified
      --
      Log('Notify Mobile applications in FNDMOB when FNDBAS security cache is modified');
      
      @ApproveDynamicStatement(2019-01-16,kathlk)
      EXECUTE IMMEDIATE 'BEGIN Mobile_Client_SYS.Refresh_Security_List_; END;';
   END IF;
   
 
   Log('Refresh_Active_List__ done in ' || Total_Time || ' sec');
END Refresh_Active_List__;


-- Package_Will_Deadlock__
--   Will return TRUE if the package is one of the packages that can
--   not be granted/revoked using this system services, else FALSE
--   will be returned. Packages that have this characteristic will
--   have to be administrated manually.
--   Will return TRUE if the package is one of the packages that can
--   not be granted/revoked using this system services, else FALSE
--   will be returned. Packages that have this characteristic will
--   have to be administrated manually.
@UncheckedAccess
FUNCTION Package_Will_Deadlock__ (
   package_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   -- Method only used internally, thus removed access control here.
   IF package_name_ IS NULL THEN
      RETURN(FALSE);
   ELSE
      IF package_name_ IN 
     ('ASSERT_SYS', 
      'CLIENT_SYS', 
      'DATABASE_SYS', 
      'DICTIONARY_SYS', 
      'DOMAIN_SYS', 
      'ERROR_SYS', 
      'FND_BOOLEAN_API',
      'FND_CONTEXT_SYS',
      'FND_ROLE_API',
      'FND_SESSION_API', 
      'FND_SESSION_UTIL_API', 
      'FND_SETTING_API', 
      'FND_USER_API',
      'FND_USER_PROPERTY_API', 
      'GENERAL_SYS',
      'OBJECT_CONNECTION_SYS', 
      'INSTALLATION_SYS', 
      'LOG_SYS', 
      'LOG_CATEGORY_API',
      'LOGIN_SYS',
      'LANGUAGE_SYS', 
      'MESSAGE_SYS', 
      'PRES_OBJECT_UTIL_API', 
      'PRES_OBJECT_GRANT_API',
      'REFERENCE_SYS',
      'SECURITY_SYS', 
      'SERVER_LOG_API', 
      'SERVER_LOG_CATEGORY_API', 
      'TRACE_SYS',
      'REPL_GRANTS_UTIL_API',
      --Start: These objects are added to solve deadlock issues found when importing received permission sets at Data synchronization. After the redesign, remove these,
      'TRANSACTION_SYS',
      'LANGUAGE_CODE_API',
      'REPL_BATCH_UTIL_API',
      'BATCH_SYS'
      --End
      ) THEN
         RETURN(TRUE);
      END IF;
   END IF;
   RETURN(FALSE);
END Package_Will_Deadlock__;


PROCEDURE Export_Role__ (
   string_                       OUT CLOB,
   role_                         IN  VARCHAR2,
   include_presentation_objects_ IN  VARCHAR2,
   include_database_objects_     IN  VARCHAR2,
   include_activities_           IN  VARCHAR2,
   include_projections_          IN  VARCHAR2,
   comment_define_               IN  VARCHAR2 DEFAULT 'TRUE',
   include_role_grants_          IN  VARCHAR2 DEFAULT 'FALSE' )
IS
   string_array_  Info_Array_Type;
   ial_user_      fnd_setting_tab.value%TYPE;
   role_rec_      Fnd_Role_API.Public_Rec;
   export_ial_    BOOLEAN     := FALSE;
   dummy_         NUMBER      := 0;
   i_             NUMBER      := 0;
   enable_        VARCHAR2(5) := 'FALSE';

   CURSOR ial_obj_exist IS
      SELECT count(*)
        FROM all_tab_privs
       WHERE table_schema = ial_user_
         AND grantee      = role_ ;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Export_Role__');
   string_array_.DELETE;
   ial_user_ := Fnd_Setting_API.Get_Value('IAL_USER');
   role_rec_ := Fnd_Role_API.Get(role_);
   OPEN  ial_obj_exist;
   FETCH ial_obj_exist INTO dummy_;
   CLOSE ial_obj_exist;
   IF ( dummy_ > 0 ) THEN
      export_ial_ := TRUE;
   END IF;
   IF ( include_presentation_objects_ = 'TRUE' AND include_database_objects_ = 'TRUE') THEN
      enable_ := 'TRUE';
   END IF;
   i_ := i_ + 1;
   string_array_(i_) := '-------------------------------------------------------------------' || newline_;
   string_array_(i_) := string_array_(i_) || '-- Exported by:  IFS Foundation1' || newline_;
   string_array_(i_) := string_array_(i_) || '-- Settings for: ' || role_ || newline_;
   string_array_(i_) := string_array_(i_) || '-- Date/Time:    ' || to_char(sysdate, 'yyyy-MM-dd hh24:mi:ss' ) || newline_;
   string_array_(i_) := string_array_(i_) || '-------------------------------------------------------------------' || newline_ || newline_;
   string_array_(i_) := string_array_(i_) || 'SET SERVEROUTPUT ON SIZE UNLIMITED' || newline_ || newline_;
   IF (comment_define_ = 'TRUE') THEN
      string_array_(i_) := string_array_(i_) || '-- DEFINE GRANTEE = ' || role_ || newline_;
      string_array_(i_) := string_array_(i_) || '-- DEFINE AO = ' || Fnd_Session_API.Get_App_Owner || newline_;
   ELSE
      string_array_(i_) := string_array_(i_) || 'DEFINE GRANTEE = ' || role_ || newline_;
      string_array_(i_) := string_array_(i_) || 'DEFINE AO = ' || Fnd_Session_API.Get_App_Owner || newline_;
   END IF;
   string_array_(i_) := string_array_(i_) || '--' || newline_;
   string_array_(i_) := string_array_(i_) || '-- Role Management' || newline_;
   string_array_(i_) := string_array_(i_) || '--' || newline_;
   string_array_(i_) := string_array_(i_) || '--BEGIN' || newline_;
   string_array_(i_) := string_array_(i_) || '--   '||chr(38)||'AO..Security_SYS.Create_Role(''' || CHR(38) || 'GRANTEE'', ''' || REPLACE(role_rec_.description, '''', '''''') || ''', ''' || role_rec_.fnd_role_type || ''', ''TRUE'');' || newline_;
   string_array_(i_) := string_array_(i_) || '--   '||chr(38)||'AO..Security_SYS.Clear_Role(''' || CHR(38) || 'GRANTEE'');' || newline_;
   string_array_(i_) := string_array_(i_) || '--EXCEPTION' || newline_;
   string_array_(i_) := string_array_(i_) || '--   WHEN others THEN' || newline_;
   string_array_(i_) := string_array_(i_) || '--      NULL;' || newline_;
   string_array_(i_) := string_array_(i_) || '--END;' || newline_;
   string_array_(i_) := string_array_(i_) || '--/' || newline_;
   
   IF (include_presentation_objects_ = 'TRUE') THEN
      Add_Pres_Objects_To_Array___(string_array_, role_, enable_);
   END IF;
   IF (include_database_objects_ = 'TRUE') THEN
      Add_Db_Objects_To_Array___(string_array_, role_);
   END IF;
   IF (export_ial_) THEN
      Add_Ial_Objects_To_Array___(string_array_, role_, ial_user_);
   END IF;
   IF (include_activities_ = 'TRUE') THEN
      Add_Activities_To_Array___(string_array_, role_);
   END IF;
   Add_System_Priv_To_Array___(string_array_, role_);
   IF (include_role_grants_ = 'TRUE') THEN
      Add_Role_Grants_To_Array___(string_array_, role_);
   END IF;
   IF (include_projections_ = 'TRUE') THEN
      Add_Proj_Grants_To_Array___ (string_array_, role_);
   END IF;
   i_ := string_array_.count+1 ;
   string_array_(i_) := 'UNDEFINE GRANTEE' || newline_  ;
   i_ := i_ + 1;
   string_array_(i_) := 'UNDEFINE AO' || newline_  ;
   i_ := i_ + 1;
   string_array_(i_) := 'SET SERVEROUTPUT OFF' || newline_;
   i_ := i_ + 1;
   string_array_(i_) :=   'COMMIT;' || newline_;
   Pack_Array___(string_array_, string_);
END Export_Role__;


PROCEDURE Export_Role_Ex__ (
   export_id_                    OUT VARCHAR2,
   role_                         IN  VARCHAR2,
   include_presentation_objects_ IN  VARCHAR2,
   include_database_objects_     IN  VARCHAR2,
   include_role_grants_          IN  VARCHAR2,
   include_activities_           IN  VARCHAR2,
   comment_define_               IN  VARCHAR2 )
IS
   string_                 CLOB   := NULL;

   CURSOR get_all_connected IS
      SELECT DISTINCT granted_role
        FROM fnd_role_role
       WHERE grantee_type = 'ROLE'
       START WITH grantee = role_
     CONNECT BY NOCYCLE PRIOR granted_role = grantee;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Export_Role_Ex__');
   export_id_ := SYS_GUID();

   -- First export the requested role then export the granted roles later...
   Export_Role__(
      string_                       => string_,
      role_                         => role_,
      include_presentation_objects_ => include_presentation_objects_,
      include_database_objects_     => include_database_objects_,
      include_role_grants_          => include_role_grants_,
      include_activities_           => include_activities_,
      include_projections_          => 'FALSE',
      comment_define_               => comment_define_);

   Add_To_Export_Files___(string_, export_id_, role_);

   IF ( include_role_grants_ = 'TRUE' ) THEN
      -- Time to export the granted roles...
      FOR rec_ IN get_all_connected LOOP
         Export_Role__(
            string_                       => string_,
            role_                         => rec_.granted_role,
            include_presentation_objects_ => include_presentation_objects_,
            include_database_objects_     => include_database_objects_,
            include_role_grants_          => include_role_grants_,
            include_activities_           => include_activities_,
            include_projections_          => 'FALSE',
            comment_define_               => comment_define_);
         Add_To_Export_Files___(string_, export_id_, rec_.granted_role);
      END LOOP;
   END IF;
END Export_Role_Ex__;


PROCEDURE Validate_Timespan_For_Users__
IS
   date_          DATE := SYSDATE;
   first_date_    CONSTANT DATE := Database_SYS.Get_First_Calendar_Date;
   last_date_     CONSTANT DATE := Database_SYS.Get_Last_Calendar_Date;
   changes_done_  BOOLEAN := FALSE;

   PROCEDURE Check_License___(user_id_ IN VARCHAR2) IS
       --record_  PLSQLAP_Record_API.type_record_;
   BEGIN
      -- TODO: we don't support activities any longer...
      NULL;
      /*
      record_ := PLSQLAP_Record_API.New_Record('FND_USER');
      PLSQLAP_Record_API.Set_Value( record_,'IDENTITY',user_id_);
      Plsqlap_Server_API.Invoke_Record_('LicenseValidation', 'CheckLicenseActivateUser',record_, activity_ => TRUE);
      */
   END Check_License___;

   PROCEDURE Activate___(objid_      IN VARCHAR2,
                         objversion_ IN OUT VARCHAR2,
                         active_     IN VARCHAR2) IS
      info_ VARCHAR2(2000);
      attr_ VARCHAR2(2000);
   BEGIN
      Client_SYS.Add_To_Attr('ACTIVE', active_, attr_);
      Fnd_User_API.Modify__(info_, objid_, objversion_, attr_, 'DO');
   END Activate___;

   PROCEDURE Activate_Users___ IS
      CURSOR get_inactive_users IS
         SELECT identity, active, objid, objversion
           FROM fnd_user
          WHERE date_ BETWEEN nvl(valid_from, first_date_) AND
                nvl(valid_to, last_date_)
            AND (valid_from IS NOT NULL OR valid_to IS NOT NULL)
            AND active = 'FALSE';
   BEGIN
      FOR rec IN get_inactive_users LOOP
         Check_License___(rec.identity);
         Activate___(rec.objid, rec.objversion, 'TRUE');
         changes_done_ := TRUE;
      END LOOP;
   END Activate_Users___;

   PROCEDURE Inactivate_Users___ IS
      CURSOR get_active_users IS
         SELECT identity, active, objid, objversion
           FROM fnd_user
          WHERE (date_ < nvl(valid_from, first_date_) OR
                date_ > nvl(valid_to, last_date_))
            AND (valid_from IS NOT NULL OR valid_to IS NOT NULL)
            AND active = 'TRUE';
   BEGIN
      FOR rec IN get_active_users LOOP
         Activate___(rec.objid, rec.objversion, 'FALSE');
         changes_done_ := TRUE;
      END LOOP;
   END Inactivate_Users___;


BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Validate_Timespan_For_Users__');
   Inactivate_Users___;
   Activate_Users___;
   -- If any changes is done perform a refresh of the security cache
   IF (changes_done_ = TRUE) THEN
      Refresh_Active_List__(0);
   END IF;
END Validate_Timespan_For_Users__;

FUNCTION Bool_To_Varchar2___ (
   value_ IN BOOLEAN) RETURN VARCHAR2 DETERMINISTIC
IS
BEGIN
   IF value_ THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Bool_To_Varchar2___;
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Get_Role_List_
--   Retrieve a role list for a specific Foundation user.
FUNCTION Get_Role_List_ (
   fnd_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Get_Role_List_');
   RETURN(Get_Role_List___(fnd_user_));
END Get_Role_List_;


PROCEDURE Enum_User_System_Privileges_ (
   sp_        OUT    VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Enum_User_System_Privileges_');
   sp_ := List_User_System_Privileges___(Fnd_Session_API.Get_Fnd_User);
END Enum_User_System_Privileges_;


@UncheckedAccess
FUNCTION List_Web_User_Privileges_ (
   web_user_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN List_User_System_Privileges___(Fnd_User_API.Get_Web_User_Identity_(web_user_));
END List_Web_User_Privileges_;


@UncheckedAccess
PROCEDURE Is_Pres_Object_Available_ (
   available_      OUT VARCHAR2,
   pres_object_id_ IN  VARCHAR2 )
IS
BEGIN
   -- Method needed by web endusers, thus removed access control here.
   Trace_SYS.Message('SECURITY_SYS.Is_Pres_Object_Available_('||pres_object_id_||')');
   IF Is_Pres_Object_Available(pres_object_id_) THEN
      available_ := 'TRUE';
      Trace_SYS.Field('. available_', 'TRUE');
   ELSE
      available_ := 'FALSE';
      Trace_SYS.Field('. available_', 'FALSE');
   END IF;
END Is_Pres_Object_Available_;

-- Is_Projection_Available_
--   Check whether a projection is granted to a user.
@UncheckedAccess
FUNCTION Is_Projection_Available_ (
   projection_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Projection_Grant_API.Is_Available(projection_name_);
END Is_Projection_Available_;

-- Is_Proj_Action_Available_
--   Check whether a projection action is granted to a user.
@UncheckedAccess
FUNCTION Is_Proj_Action_Available_ (
   projection_name_ IN VARCHAR2,
   action_name_     IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Proj_Action_Grant_API.Is_Available(projection_name_, action_name_);
END Is_Proj_Action_Available_;

-- Is_Proj_Action_Available_
--   Check whether a projection action is granted to a user.
--   Values should be ProjectionName.Action
@UncheckedAccess
FUNCTION Is_Proj_Action_Available_ (
   projection_action_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Bool_To_Varchar2___(Is_Proj_Action_Available(projection_action_name_));
END Is_Proj_Action_Available_;

-- Is_Proj_Actions_Available_
--   Check whether all the unbound projection actions are granted to a user. 
--   action_names_ should be a ^ separated list of all actions
@UncheckedAccess
FUNCTION Is_Proj_Actions_Available_ (
   projection_name_ IN VARCHAR2,
   action_names_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Bool_To_Varchar2___(Is_Proj_Actions_Available(projection_name_, action_names_));
END Is_Proj_Actions_Available_;

-- Is_Proj_Entity_Act_Available_
--   Checks whether a projection bound entity action is granted to a user.
@UncheckedAccess
FUNCTION Is_Proj_Entity_Act_Available_ (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   action_name_     IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Proj_Ent_Action_Grant_API.Is_Available(projection_name_, entity_name_, action_name_);
END Is_Proj_Entity_Act_Available_;

-- Is_Proj_Entity_Act_Available_
--   Checks whether a projection bound entity action is granted to a user.
@UncheckedAccess
FUNCTION Is_Proj_Entity_Act_Available_ (
   proj_enty_act_name_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Bool_To_Varchar2___(Is_Proj_Entity_Act_Available(proj_enty_act_name_));
END Is_Proj_Entity_Act_Available_;

-- Is_Proj_Ent_Actions_Available_
--   Checks whether a set of projection entity bound actions are granted to a user.
--   object_list_ should be in the format of Entity1.Action1^Entity1.Action2^Entity3.Action1
@UncheckedAccess
FUNCTION Is_Proj_Ent_Actions_Available_ (
   projection_name_ IN VARCHAR2,
   object_list_     IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Bool_To_Varchar2___(Is_Proj_Ent_Actions_Available(projection_name_, object_list_));
END Is_Proj_Ent_Actions_Available_;

@UncheckedAccess
FUNCTION Is_Proj_Entity_Cud_Available_ (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Proj_Entity_Grant_API.Is_Cud_Allowed(projection_name_, entity_name_);
END Is_Proj_Entity_Cud_Available_;

-- Is_Actions_Available_
--   Check whether all the projection actions (bound and unboud) are granted to a user. 
--   action_names_ should be a ^ separated list of all actions
@UncheckedAccess
FUNCTION Is_Actions_Available_ (
   action_names_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Bool_To_Varchar2___(Is_Actions_Available(action_names_));
END Is_Actions_Available_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Is_View_Available
--   Check whether a view is available for the current user/role.
@UncheckedAccess
FUNCTION Is_View_Available (
   view_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_VIEW: Calling obsolete interface Security_SYS.Is_View_Available! Arguments: :P1', view_name_);
   RETURN NULL;
END Is_View_Available;


-- Is_Pres_Object_Available
--   Check whether a presentation object is granted to a user.
@UncheckedAccess
FUNCTION Is_Pres_Object_Available (
   pres_object_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   granted_ VARCHAR2(30);
  BEGIN
   -- Method needed by web endusers, thus removed access control here.
   granted_ := Is_Pres_Object_Granted_User(pres_object_id_,fnd_user_);
   IF granted_ = 'TRUE' THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Pres_Object_Available;

@UncheckedAccess
FUNCTION Is_Po_Available (
   pres_object_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   -- Method needed by web endusers, thus removed access control here.
   RETURN Is_Pres_Object_Granted_User(pres_object_id_,fnd_user_);

END Is_Po_Available;

-- Is_Projection_Available
--   Check whether a projection is granted to a user.
@UncheckedAccess
FUNCTION Is_Projection_Available (
   projection_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Fnd_Projection_Grant_API.Is_Available(projection_name_) = 'TRUE';
END Is_Projection_Available;

-- Is_Proj_Action_Available
--   Check whether a projection action is granted to a user.
@UncheckedAccess
FUNCTION Is_Proj_Action_Available (
   projection_name_ IN VARCHAR2,
   action_name_     IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Fnd_Proj_Action_Grant_API.Is_Available(projection_name_, action_name_) = 'TRUE';
END Is_Proj_Action_Available;

-- Is_Proj_Action_Available
--   Check whether a projection action is granted to a user.
--   Values should be ProjectionName.Action
@UncheckedAccess
FUNCTION Is_Proj_Action_Available (
   projection_action_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   projection_name_ VARCHAR2(32000);
   action_name_     VARCHAR2(32000);
BEGIN
   projection_name_ := substr(projection_action_name_, 1, instr(projection_action_name_, '.')-1);
   action_name_ := substr(projection_action_name_, instr(projection_action_name_, '.') +1);
   
   RETURN Is_Proj_Action_Available(projection_name_, action_name_);
END Is_Proj_Action_Available;

-- Is_Proj_Actions_Available
--   Check whether all the unbound projection actions are granted to a user. 
--   action_names_ should be a ^ separated list of all actions
@UncheckedAccess
FUNCTION Is_Proj_Actions_Available (
   projection_name_ IN VARCHAR2,
   action_names_    IN VARCHAR2) RETURN BOOLEAN
IS
   action_array_ Utility_SYS.STRING_TABLE;
   count_        NUMBER;
BEGIN 
   IF Is_App_Owner THEN
      RETURN TRUE;
   END IF;
   
   Utility_SYS.Tokenize(action_names_, '^', action_array_, count_);
   
   FOR i_ IN 1..count_ LOOP
      IF NOT Is_Proj_Action_Available(projection_name_, action_array_(i_)) THEN
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;
END Is_Proj_Actions_Available;

-- Is_Proj_Entity_Act_Available
--   Checks whether a projection bound entity action is granted to a user.
@UncheckedAccess
FUNCTION Is_Proj_Entity_Act_Available (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   action_name_     IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Fnd_Proj_Ent_Action_Grant_API.Is_Available(projection_name_, entity_name_, action_name_) = 'TRUE';
END Is_Proj_Entity_Act_Available;

-- Is_Proj_Entity_Act_Available
--   Checks whether a projection bound entity action is granted to a user.
@UncheckedAccess
FUNCTION Is_Proj_Entity_Act_Available (
   proj_enty_act_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   projection_name_ VARCHAR2(32000);
   entity_action_   VARCHAR2(32000);
   entity_name_     VARCHAR2(32000);
   action_name_     VARCHAR2(32000);
BEGIN
   IF Is_App_Owner THEN
      RETURN TRUE;
   END IF;
   
   projection_name_ := substr(proj_enty_act_name_, 1, instr(proj_enty_act_name_, '.')-1);
   entity_action_ := substr(proj_enty_act_name_, instr(proj_enty_act_name_, '.') +1);
   
   entity_name_ := substr(entity_action_, 1, instr(entity_action_, '.')-1);
   action_name_ := substr(entity_action_, instr(entity_action_, '.') +1);
   
   RETURN Is_Proj_Entity_Act_Available(projection_name_, entity_name_, action_name_);
END Is_Proj_Entity_Act_Available;

-- Is_Proj_Ent_Actions_Available
--   Checks whether a set of projection entity bound actions are granted to a user.
--   object_list_ should be in the format of Entity1.Action1^Entity1.Action2^Entity3.Action1
@UncheckedAccess
FUNCTION Is_Proj_Ent_Actions_Available (
   projection_name_ IN VARCHAR2,
   object_list_     IN VARCHAR2) RETURN BOOLEAN
IS
   action_array_ Utility_SYS.STRING_TABLE;
   action_count_ NUMBER;
   
   entity_action_ VARCHAR2(32000);
   entity_name_   VARCHAR2(32000);
   action_name_   VARCHAR2(32000);
BEGIN
   
   IF Is_App_Owner THEN
      RETURN TRUE;
   END IF;
   
   Utility_SYS.Tokenize(object_list_, '^', action_array_, action_count_);
   FOR i_ IN 1..action_count_ LOOP
      entity_action_ := action_array_(i_);
      entity_name_ := substr(entity_action_, 1, instr(entity_action_, '.')-1);
      action_name_ := substr(entity_action_, instr(entity_action_, '.') +1);
      
      IF NOT Is_Proj_Entity_Act_Available(projection_name_, entity_name_, action_name_) THEN
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;
END Is_Proj_Ent_Actions_Available;

@UncheckedAccess
FUNCTION Is_Proj_Entity_Cud_Available (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   RETURN Fnd_Proj_Entity_Grant_API.Is_Cud_Allowed(projection_name_, entity_name_) = 'TRUE';
END Is_Proj_Entity_Cud_Available;

-- Is_Actions_Available
--   Check whether all the projection actions (bound and unboud) are granted to a user. 
--   action_names_ should be a ^ separated list of all actions
@UncheckedAccess
FUNCTION Is_Actions_Available (
   action_names_    IN VARCHAR2) RETURN BOOLEAN
IS
   action_array_ Utility_SYS.STRING_TABLE;
   count_        NUMBER;
   dot_count_    NUMBER;
BEGIN 
   IF Is_App_Owner THEN
      RETURN TRUE;
   END IF;
   
   Utility_SYS.Tokenize(action_names_, '^', action_array_, count_);
   
   FOR i_ IN 1..count_ LOOP
      dot_count_ := regexp_count(action_array_(i_), '\.');

      IF dot_count_ = 1 THEN
         --Projection Unbound Action
         IF NOT Is_Proj_Action_Available(action_array_(i_)) THEN
            RETURN FALSE;
         END IF;
      ELSIF dot_count_ = 2 THEN
         --Projection Entity Bound Action
         IF NOT Is_Proj_Entity_Act_Available(action_array_(i_)) THEN
            RETURN FALSE;
         END IF;
      ELSE
         -- Something is wrong
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;
END Is_Actions_Available;

-- Is_Logical_Unit_Available
--   Check whether a logical unit is available.
--   LU is currently treated as available if a View of the LU is available
--   or If the LUs is available via a projection
@UncheckedAccess
FUNCTION Is_Logical_Unit_Available (
   lu_name_       IN VARCHAR2) RETURN BOOLEAN
IS 
BEGIN
   
   IF Is_App_Owner THEN
      RETURN TRUE;
   END IF;
   --SOLSETFW
   FOR rec_ IN (SELECT view_name FROM dictionary_sys_view_active WHERE lu_name = lu_name_) LOOP
      IF Is_View_Available(rec_.view_name) THEN
         RETURN TRUE;
      END IF;
   END LOOP;
   
   IF Is_Lu_Avail_From_Projections(lu_name_) THEN
      RETURN TRUE;
   END IF;
   
   RETURN FALSE;
END Is_Logical_Unit_Available;

FUNCTION Is_Lu_Avail_From_Projections2 (
   lu_name_       IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   IF Is_Lu_Avail_From_Projections(lu_name_) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Lu_Avail_From_Projections2;

@UncheckedAccess
FUNCTION Is_Lu_Avail_From_Projections (
   lu_name_       IN VARCHAR2) RETURN BOOLEAN
IS
   temp_ NUMBER;
BEGIN
   
   IF Is_App_Owner THEN
      RETURN TRUE;
   END IF;
   
   SELECT 1 INTO temp_
     FROM dual
    WHERE EXISTS ( SELECT 1 
                     FROM fnd_user_role_runtime_tab t,
                          fnd_proj_entity_grant_tab g,
                          fnd_proj_entity_tab e 
                    WHERE e.used_lu = lu_name_
                      AND g.projection = e.projection_name
                      AND g.entity = e.entity_name
                      AND t.identity = Fnd_Session_API.Get_Fnd_User 
                      AND t.role = g.role);
                      
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
END Is_Lu_Avail_From_Projections;

-- Is_Activity_Available
--   Check whether an activity is granted to a user.
@UncheckedAccess
FUNCTION Is_Activity_Available (
   activity_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
   CURSOR get_activity_grant IS
      SELECT 1
      FROM   activity_grant_tab g
      WHERE  g.activity_name  = activity_
      AND    g.role IN (SELECT role
                         FROM   fnd_user_role_runtime_tab
                         WHERE  identity = fnd_user_);
  BEGIN
   IF Security_SYS.Is_App_Owner(fnd_user_) THEN
      RETURN(TRUE);
   ELSE   
    FOR rec IN get_activity_grant LOOP
        RETURN(TRUE);
    END LOOP;
    RETURN(FALSE);
   END IF;
END Is_Activity_Available;

@UncheckedAccess
FUNCTION Is_Role_Granted (
   role_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   fnd_user_ VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;

   CURSOR get_role IS
      SELECT 1
      FROM   fnd_user_role_runtime_tab
      WHERE  identity = fnd_user_
      AND    role = role_;
BEGIN  
   FOR rec IN get_role LOOP
      RETURN(TRUE);
   END LOOP;
   RETURN(FALSE);
END Is_Role_Granted;


@UncheckedAccess
FUNCTION Has_User_Role_Access (
   role_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Fnd_Session_API.Get_Fnd_User = Fnd_Session_API.Get_App_Owner THEN
      RETURN 'TRUE';
   END IF;
   IF (Is_Role_Granted(role_)) THEN
      RETURN('TRUE');
   ELSE      
      RETURN('FALSE');
   END IF;
END Has_User_Role_Access;


@UncheckedAccess
FUNCTION Is_Pres_Object_Granted_User (
   pres_object_id_          IN VARCHAR2,
   identity_                IN VARCHAR2,
   check_pres_object_usage_ IN VARCHAR2 DEFAULT 'TRUE') RETURN VARCHAR2
IS
   pres_object_security_  BOOLEAN := (Fnd_User_API.Get_Pres_Security_Setup(Fnd_Session_API.Get_Fnd_User) = 'ON');
   --SOLSETFW
   CURSOR get_po IS
      SELECT 1
        FROM pres_object_grant_tab g
       WHERE po_id = pres_object_id_
         AND EXISTS (SELECT 1 FROM module_tab m, pres_object_tab o
                      WHERE o.po_id = g.po_id
                        AND o.module = m.module
                        AND m.active = 'TRUE')
         AND role IN (SELECT role
                        FROM fnd_user_role_runtime_tab
                       WHERE identity = identity_);
BEGIN
   -- Method needed by web endusers, thus removed access control here.
   -- Check for grants to this user's roles
   --
   IF (check_pres_object_usage_ = 'TRUE' AND NOT pres_object_security_) THEN
      RETURN('TRUE');
   ELSIF Security_SYS.Is_App_Owner(identity_) THEN
      RETURN('TRUE');
   ELSE
      FOR rec IN get_po LOOP
         RETURN('TRUE');
      END LOOP;
   END IF;
   -- PO is not granted or does not exist
   RETURN('FALSE');
END Is_Pres_Object_Granted_User;


-- Is_Pres_Object_Registered
--   Check whether a presentation object exists with the given name.
@UncheckedAccess
FUNCTION Is_Pres_Object_Registered (
   pres_object_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR po_exist IS
      SELECT 'TRUE'
        FROM pres_object_tab
       WHERE po_id = pres_object_id_;
   registered_ VARCHAR2(10);
BEGIN
   OPEN  po_exist;
   FETCH po_exist INTO registered_;
   CLOSE po_exist;

   IF registered_ IS NULL THEN
      registered_ := 'FALSE';
   END IF;

   Trace_SYS.Field('SECURITY_SYS.Is_Pres_Object_Registered('||pres_object_id_||')', registered_);
   RETURN registered_;
END Is_Pres_Object_Registered;


PROCEDURE Create_Role (
   role_        IN VARCHAR2,
   description_ IN VARCHAR2 DEFAULT NULL,
   role_type_   IN VARCHAR2 DEFAULT 'ENDUSERROLE',
   update_      IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Create_Role');
   Fnd_Role_API.Create__(role_, description_, role_type_, update_);
END Create_Role;


PROCEDURE Drop_Role (
   role_ IN VARCHAR2 )
IS
   info_       VARCHAR2(2000);
   objid_      fnd_role.objid%TYPE;
   objversion_ fnd_role.objversion%TYPE;

   CURSOR get_id_version IS
      SELECT objid, objversion
      FROM fnd_role
      WHERE role = upper(role_);
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Drop_Role');
   OPEN get_id_version;
   FETCH get_id_version INTO objid_, objversion_;
   CLOSE get_id_version;
   Fnd_Role_API.Remove__(info_, objid_, objversion_, 'DO');
END Drop_Role;


PROCEDURE Grant_Role (
   role_    IN VARCHAR2,
   grantee_ IN VARCHAR2 )
IS
   user_not_exist         EXCEPTION;
   PRAGMA                 exception_init(user_not_exist, -20111);
   illegal_oracle_grantee EXCEPTION;
   PRAGMA                 exception_init(illegal_oracle_grantee, -1917);
   upper_role_            VARCHAR2(30) := upper(role_);
   upper_grantee_         VARCHAR2(30) := upper(grantee_);
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Role');
   -- Perform necessary insertions for the fnduser if this is a fnduser.
   Fnd_Role_API.Exist(upper_role_);
   BEGIN
      Fnd_User_API.Exist(upper_grantee_);
      Fnd_User_Role_API.Set_Role(upper_grantee_, upper_role_, TRUE);
   EXCEPTION
      WHEN user_not_exist THEN
         -- If this is not a user, validate that it is a role.
         Fnd_Role_API.Exist(upper_grantee_);
   END;

   -- Insert data to IFS sepcific tables for reference purpose.
   Fnd_Grant_Role_API.Grant_Role_(upper_role_, upper_grantee_);
EXCEPTION
   -- If the grantee is not an Oracle user, suppress this error.
   WHEN illegal_oracle_grantee THEN
      NULL;
END Grant_Role;


PROCEDURE Revoke_Role (
   role_    IN VARCHAR2,
   grantee_ IN VARCHAR2 )
IS
   user_not_exist         EXCEPTION;
   PRAGMA                 exception_init(user_not_exist, -20111);
   role_not_granted       EXCEPTION;
   PRAGMA                 exception_init(role_not_granted, -1951);
   illegal_oracle_grantee EXCEPTION;
   PRAGMA                 exception_init(illegal_oracle_grantee, -1917);
   upper_role_            VARCHAR2(30) := upper(role_);
   upper_grantee_         VARCHAR2(30) := upper(grantee_);
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Revoke_Role');
   -- Perform necessary deletes for the fnduser if this is a fnduser.
   BEGIN
      Fnd_User_API.Exist(upper_grantee_);
      Fnd_User_Role_API.Set_Role(upper_grantee_, upper_role_, FALSE);
   EXCEPTION
      WHEN user_not_exist THEN
         NULL;
   END;

   -- Remove data from IFS specific tables for reference purpose.
   Fnd_Grant_Role_API.Revoke_Role_(upper_role_, upper_grantee_);
EXCEPTION
   WHEN role_not_granted THEN
      NULL;
   WHEN illegal_oracle_grantee THEN
      NULL;
END Revoke_Role;


PROCEDURE Clear_Role (
   role_ IN VARCHAR2,
   revoke_roles_ IN BOOLEAN DEFAULT TRUE )
IS
   upper_role_ VARCHAR2(30) := upper(role_);
   not_granted EXCEPTION;
   PRAGMA      exception_init(not_granted, -1927);

   CURSOR get_roles IS
      SELECT role
      FROM fnd_grant_role_tab
      WHERE granted_role = upper_role_;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Clear_Role');
   Assert_SYS.Assert_Is_Grantee(upper_role_);
   -- Delete all method restrictions
   DELETE FROM security_sys_tab
   WHERE role = upper_role_;
   -- Disable all Presentation Objects
   DELETE FROM pres_object_grant_tab
   WHERE role = upper_role_;
   -- Delete System Privileges
   DELETE FROM system_privilege_grant_tab
   WHERE role = upper_role_;
   -- Revoke Activity Grants
   DELETE FROM activity_grant_tab
   WHERE role = upper_role_;
   -- Delete current db object grants
   DELETE FROM security_sys_privs_tab
   WHERE grantee = upper_role_;
   
   -- Delete all projections grants
   DELETE FROM fnd_projection_grant_tab 
   WHERE role = upper_role_;
   -- Delete all projection action grants
   DELETE FROM fnd_proj_action_grant_tab 
   WHERE role = upper_role_;
   -- Delete all projection entity grants
   DELETE FROM fnd_proj_entity_grant_tab 
   WHERE role = upper_role_;
   -- Delete all projection entity action grants
   DELETE FROM fnd_proj_ent_action_grant_tab 
   WHERE role = upper_role_;

   -- Revoke all related roles
   IF revoke_roles_ THEN 
      FOR rec IN get_roles LOOP
         -- Remove data from IFS specific tables for reference purpose.
         Fnd_Grant_Role_API.Revoke_Role_(rec.role, upper_role_);
      END LOOP;
   END IF;
END Clear_Role;


PROCEDURE Grant_Activity (
   activity_ IN VARCHAR2,
   role_     IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Activity');
   Activity_Grant_API.Grant_Activity__(role_,activity_);
END Grant_Activity;


PROCEDURE Revoke_Activity (
   activity_ IN VARCHAR2,
   role_     IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Revoke_Activity');
   Activity_Grant_API.Revoke_Activity__(role_,activity_);
END Revoke_Activity;

PROCEDURE Grant_Package (
   package_     IN VARCHAR2,
   role_        IN VARCHAR2,
   raise_error_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_PAK: Calling obsolete interface Security_SYS.Grant_Package! Arguments: :P1', package_ || ' ' || role_ || ' ' || raise_error_);
END Grant_Package;

FUNCTION Is_Method_Available (
   full_method_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_MA: Calling obsolete interface Security_SYS.Is_Method_Available! Arguments: :P1', full_method_name_);
END Is_Method_Available;

PROCEDURE Grant_View (
   view_ IN VARCHAR2,
   role_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_V: Calling obsolete interface Security_SYS.Grant_View! Arguments: :P1', view_ || ' ' || role_);
END Grant_View;

PROCEDURE Revoke_View (
   view_ IN VARCHAR2,
   role_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_RV: Calling obsolete interface Security_SYS.Revoke_View! Arguments: :P1', view_ || ' ' || role_);
END Revoke_View;

FUNCTION Is_Object_Available__ (
   object_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_OA2: Calling obsolete interface Security_SYS.Is_Object_Available__! Arguments: :P1', object_name_);
END Is_Object_Available__;

PROCEDURE Revoke_Package__ (
   info_msg_   OUT VARCHAR2,
   package_     IN VARCHAR2,
   role_        IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_RP3: Calling obsolete interface Security_SYS.Revoke_Package___! Arguments: :P1', package_ || ' ' || role_);
END Revoke_Package__;

FUNCTION Get_Accessible_Views_ RETURN CLOB
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_AV: Calling obsolete interface Security_SYS.Get_Accessible_Views_!');
   RETURN NULL;
END Get_Accessible_Views_;

PROCEDURE Check_Method_Access_ (
   lu_name_ IN VARCHAR2,
   package_ IN VARCHAR2,
   method_  IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_CMA: Calling obsolete interface Security_SYS.Check_Method_Access_! Arguments: :P1', lu_name_ || ' ' || package_ || ' ' || method_);
END Check_Method_Access_;

PROCEDURE Is_Object_Available_ (
   available_   OUT VARCHAR2,
   object_name_ IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_OA1: Calling obsolete interface Security_SYS.Is_Object_Available_! Arguments: :P1', object_name_);
END Is_Object_Available_;

FUNCTION Is_Object_Available_ (
   object_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_OA1: Calling obsolete interface Security_SYS.Is_Object_Available_! Arguments: :P1', object_name_);
END Is_Object_Available_;


PROCEDURE Is_Prefixed_View_Available_ (
   available_   OUT VARCHAR2,
   schema_name_ IN  VARCHAR2,
   view_name_   IN  VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_VA: Calling obsolete interface Security_SYS.Is_Prefixed_View_Available_! Arguments: :P1', schema_name_ || ' ' || view_name_);
END Is_Prefixed_View_Available_;

FUNCTION Is_Method_Or_Action_Available (
   plsql_method_name_ IN VARCHAR2,
   projection_action_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_MAA: Calling obsolete interface Security_SYS.Is_Method_Or_Action_Available! Arguments: :P1', plsql_method_name_ || ' ' || projection_action_);
   RETURN FALSE;
END Is_Method_Or_Action_Available;

FUNCTION Is_Meth_Or_Ent_Cud_Available (
   plsql_method_name_ IN VARCHAR2,
   projection_entity_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_MEA: Calling obsolete interface Security_SYS.Is_Meth_Or_Ent_Cud_Available! Arguments: :P1', plsql_method_name_ || ' ' || projection_entity_);
   RETURN FALSE;
END Is_Meth_Or_Ent_Cud_Available;

FUNCTION Is_View_Or_Projectn_Available (
   view_name_       IN VARCHAR2,
   projection_name_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_VP: Calling obsolete interface Security_SYS.Is_View_Or_Projectn_Available! Arguments: :P1', view_name_ || ' ' || projection_name_);
   RETURN FALSE;
END Is_View_Or_Projectn_Available;


FUNCTION Is_View_Granted_Role (
   view_name_ IN VARCHAR2,
   role_      IN VARCHAR2  ) RETURN VARCHAR2
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_GR: Calling obsolete interface Security_SYS.Is_View_Granted_Role! Arguments: :P1', view_name_ || ' ' || role_);
   RETURN 'FALSE';
END Is_View_Granted_Role;

FUNCTION Is_Method_Granted_Role (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2,
   role_         IN VARCHAR2  ) RETURN VARCHAR2
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_MGR: Calling obsolete interface Security_SYS.Is_Method_Granted_Role! Arguments: :P1', package_name_ || ' ' || method_name_ || ' ' || role_);
   RETURN 'FALSE';
END Is_Method_Granted_Role;

FUNCTION Get_Pkg_Grant_Status_Role (
   package_name_ IN VARCHAR2,
   role_         IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_PG: Calling obsolete interface Security_SYS.Get_Pkg_Grant_Status_Role! Arguments: :P1', package_name_ || ' ' || role_);
END Get_Pkg_Grant_Status_Role;

FUNCTION Get_Lu_Grant_Status_Role (
   lu_name_ IN VARCHAR2,
   role_    IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_LG: Calling obsolete interface Security_SYS.Get_Lu_Grant_Status_Role! Argument: :P1', lu_name_ || ' ' || role_);
END Get_Lu_Grant_Status_Role;

PROCEDURE Grant_Method (
   full_method_ IN VARCHAR2,
   role_        IN VARCHAR2,
   raise_error_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_GM: Calling obsolete interface Security_SYS.Grant_Method! Arguments: :P1', full_method_ || ' ' || role_ || ' ' || raise_error_);
END Grant_Method;


PROCEDURE Revoke_All_Methods (
   package_     IN VARCHAR2,
   role_        IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_RM: Calling obsolete interface Security_SYS.Revoke_All_Methods! Arguments: :P1', package_ || ' ' || role_);
END Revoke_All_Methods;

PROCEDURE Revoke_Method (
   full_method_ IN VARCHAR2,
   role_        IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_RM2: Calling obsolete interface Security_SYS.Revoke_Method! Arguments: :P1', full_method_ || ' ' || role_);
END Revoke_Method;

PROCEDURE Revoke_Package (
   package_     IN VARCHAR2,
   role_        IN VARCHAR2,
   raise_error_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_RP: Calling obsolete interface Security_SYS.Revoke_Package! Arguments: :P1', package_ || ' ' || role_ || ' ' || raise_error_);
END Revoke_Package;

PROCEDURE Grant_IAL_View (
   view_ IN VARCHAR2,
   role_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_IAL: Calling obsolete interface Security_SYS.Grant_IAL_View! Arguments: :P1', view_ || ' ' || role_);
END Grant_IAL_View;

PROCEDURE Revoke_IAL_View (
   view_ IN VARCHAR2,
   role_ IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Appl_General(service_, 'OBSOLETE_SEC_IAL2: Calling obsolete interface Security_SYS.Revoke_IAL_View! Arguments: :P1', view_ || ' ' || role_);
END Revoke_IAL_View;


PROCEDURE Grant_System_Privilege (
   privilege_id_ IN VARCHAR2,
   role_         IN VARCHAR2 )
IS
   info_          VARCHAR2(100);
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   attr_          VARCHAR2(1000);
   syspriv_exists EXCEPTION;
   PRAGMA         EXCEPTION_INIT(syspriv_exists, -20112);
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_System_Privilege');
   Client_SYS.Add_To_Attr('PRIVILEGE_ID', Upper(privilege_id_), attr_);
   Client_SYS.Add_To_Attr('ROLE', role_, attr_);
   System_Privilege_Grant_API.New__(info_, objid_, objversion_, attr_, 'DO');
EXCEPTION
   WHEN syspriv_exists THEN
      NULL;
END Grant_System_Privilege;


PROCEDURE Revoke_System_Privilege (
   privilege_id_ IN VARCHAR2,
   role_         IN VARCHAR2 )
IS
   info_       VARCHAR2(100);
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   CURSOR get_sys_priv IS
      SELECT objid, objversion
      FROM   system_privilege_grant
      WHERE  privilege_id = Upper(privilege_id_)
      AND    role = role_;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Revoke_System_Privilege');
   OPEN  get_sys_priv;
   FETCH get_sys_priv INTO objid_, objversion_;
   CLOSE get_sys_priv;
   System_Privilege_Grant_API.Remove__(info_, objid_, objversion_, 'DO');
END Revoke_System_Privilege;


@UncheckedAccess
FUNCTION Has_System_Privilege (
   privilege_id_ IN VARCHAR2,
   fnd_user_     IN VARCHAR2,
   exception_    IN BOOLEAN DEFAULT FALSE ) RETURN BOOLEAN
IS
   time_              NUMBER;
   expired_           BOOLEAN := FALSE;
   dummy_             NUMBER  := 0;
   return_value_      BOOLEAN := FALSE;
   CURSOR check_sys_priv IS
      SELECT 1
      FROM system_privilege_grant s,
           fnd_user_role_runtime_tab r
      WHERE r.identity = fnd_user_
      AND   r.role = s.role
      AND   s.privilege_id = upper(privilege_id_);
   no_system_privilege EXCEPTION;
BEGIN
   time_ := Database_SYS.Get_Time_Offset;
   -- Check if the time past more than 30 seconds or past.
   expired_ := ((time_ - micro_cache_sys_priv_.micro_cache_time_) > 30);
   -- Check if expired or cached value exists
   IF NOT expired_ AND
      (micro_cache_sys_priv_.fnd_user_ = fnd_user_ AND
       micro_cache_sys_priv_.privilege_id_ = privilege_id_) THEN
      return_value_ := micro_cache_sys_priv_.return_value_;
   ELSE
      -- Special handling for IFSSYS, SYS, SYSTEM and Appowner, they will always have all the System Privileges
      CASE
         WHEN nvl(fnd_user_, 'IFSSYS') = 'IFSSYS' AND USER = 'IFSSYS' THEN -- Special handling for background jobs
            IF (privilege_id_ = 'IMPERSONATE USER') THEN
               return_value_ := TRUE;
            END IF;
         WHEN USER = 'SYS' THEN
            return_value_ := TRUE;
         WHEN USER = 'SYSTEM' THEN
            return_value_ := TRUE;
         WHEN fnd_user_ = Fnd_Session_API.Get_App_Owner THEN
            return_value_ := TRUE;
         ELSE
            OPEN  check_sys_priv;
            FETCH check_sys_priv INTO dummy_;
            CLOSE check_sys_priv;
            IF dummy_ = 1 THEN
               return_value_ := TRUE;
            ELSE
               return_value_ := FALSE;
            END IF;
      END CASE;
      -- Set Cache
      micro_cache_sys_priv_.micro_cache_time_ := Database_SYS.Get_Time_Offset;
      micro_cache_sys_priv_.fnd_user_         := fnd_user_;
      micro_cache_sys_priv_.privilege_id_     := privilege_id_;
      micro_cache_sys_priv_.return_value_     := return_value_;
   END IF;
   --
   IF return_value_ = FALSE THEN -- System privilege not granted
      IF exception_ THEN
         RAISE no_system_privilege;
      END IF;
   END IF;
   RETURN(return_value_);
EXCEPTION
   WHEN no_system_privilege THEN
      Error_SYS.Appl_General(service_, 'NOSYSPRIV: You must be granted System Privilege ":P1" to execute this method.', privilege_id_);
END Has_System_Privilege;


@UncheckedAccess
FUNCTION Has_System_Privilege (
   privilege_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF Security_SYS.Has_System_Privilege(Upper(privilege_id_), Fnd_Session_API.Get_Fnd_User) = TRUE THEN
      RETURN('TRUE');
   ELSE
      RETURN('FALSE');
   END IF;
END Has_System_Privilege;


@UncheckedAccess
PROCEDURE Has_System_Privilege (
   privilege_id_ IN VARCHAR2,
   fnd_user_     IN VARCHAR2 )
IS
   dummy_ BOOLEAN;
BEGIN
   dummy_ := Security_SYS.Has_System_Privilege(Upper(privilege_id_), fnd_user_, TRUE);
END Has_System_Privilege;


@UncheckedAccess
FUNCTION Is_App_Owner (
   fnd_user_     IN VARCHAR2 DEFAULT Fnd_Session_API.Get_Fnd_User ) RETURN BOOLEAN
IS
BEGIN
   IF (fnd_user_ = Fnd_Session_API.Get_App_Owner) THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_App_Owner;


PROCEDURE Grant_Projection (
   projection_name_      IN VARCHAR2,
   role_                 IN VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Projection');
   Fnd_Projection_Grant_API.Grant_All(projection_name_, role_);
END Grant_Projection;

PROCEDURE Grant_Projection_Query_Only (
   projection_name_ IN VARCHAR2,
   role_            IN VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Projection_Query_Only');
   Fnd_Projection_Grant_API.Grant_Query(projection_name_, role_);
END Grant_Projection_Query_Only;

PROCEDURE Grant_Projection_Action (
   projection_name_ IN VARCHAR2,
   action_name_     IN VARCHAR2,
   role_            IN VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Projection_Action');
   Fnd_Proj_Action_Grant_API.Do_Grant(projection_name_, action_name_, role_);
END Grant_Projection_Action;

PROCEDURE Grant_Proj_Entity_Action (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   action_name_     IN VARCHAR2,
   role_            IN VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Proj_Entity_Action');
   Fnd_Proj_Ent_Action_Grant_API.Do_Grant(projection_name_, entity_name_, action_name_, role_);
END Grant_Proj_Entity_Action;

PROCEDURE Revoke_Projection (
   projection_name_      IN VARCHAR2,
   role_                 IN VARCHAR2)
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Revoke_Projection');
   Fnd_Projection_Grant_API.Revoke_All(projection_name_, role_);
END Revoke_Projection;


PROCEDURE Grant_Pres_Object (
   pres_object_id_ IN VARCHAR2,
   role_           IN VARCHAR2,
   recursive_      IN VARCHAR2 DEFAULT 'TRUE',
   raise_error_    IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Pres_Object');
   Pres_Object_Util_API.Grant_Pres_Object(pres_object_id_, role_, 'FULL', recursive_, recursive_, 'TRUE', raise_error_);
END Grant_Pres_Object;


PROCEDURE Grant_Query_Pres_Object (
   pres_object_id_ IN VARCHAR2,
   role_           IN VARCHAR2,
   recursive_      IN VARCHAR2 DEFAULT 'TRUE',
   raise_error_    IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Grant_Query_Pres_Object');
   Pres_Object_Util_API.Grant_Pres_Object(pres_object_id_, role_, 'QUERY', recursive_, recursive_, 'TRUE', raise_error_);
END Grant_Query_Pres_Object;


PROCEDURE Revoke_Pres_Object (
   pres_object_id_ IN VARCHAR2,
   role_           IN VARCHAR2,
   recursive_      IN VARCHAR2 DEFAULT 'TRUE',
   raise_error_    IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Revoke_Pres_Object');
   Pres_Object_Util_API.Revoke_Pres_Object(pres_object_id_, role_, recursive_, recursive_, 'TRUE', raise_error_);
END Revoke_Pres_Object;


PROCEDURE New_Pres_Object (
   po_id_            IN VARCHAR2,
   module_           IN VARCHAR2,
   pres_object_type_ IN VARCHAR2,
   description_prog_ IN VARCHAR2,
   info_type_        IN VARCHAR2,
   allow_read_only_  IN VARCHAR2 DEFAULT 'TRUE',
   layer_id_         IN VARCHAR2 DEFAULT 'Core')IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'New_Pres_Object');
   Pres_Object_Util_API.New_Pres_Object(po_id_, module_, pres_object_type_, description_prog_, info_type_, allow_read_only_, layer_id_);
END New_Pres_Object;


PROCEDURE New_Pres_Object_Sec (
   po_id_           IN VARCHAR2,
   sec_object_      IN VARCHAR2,
   sec_object_type_ IN VARCHAR2,
   sec_sub_type_    IN VARCHAR2,
   info_type_       IN VARCHAR2,
   force_read_only_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'New_Pres_Object_Sec');
   Pres_Object_Util_API.New_Pres_Object_Sec(po_id_, sec_object_, sec_object_type_, sec_sub_type_, info_type_, force_read_only_);
END New_Pres_Object_Sec;


PROCEDURE New_Pres_Object_Dependency (
   from_po_id_ IN VARCHAR2,
   module_     IN VARCHAR2,
   to_po_id_   IN VARCHAR2,
   dep_type_   IN VARCHAR2,
   info_type_  IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'New_Pres_Object_Dependency');
   Pres_Object_Util_API.New_Pres_Object_Dependency(from_po_id_, to_po_id_, dep_type_, info_type_);
END New_Pres_Object_Dependency;


PROCEDURE Enable_Pres_Object (
   pres_object_id_ IN VARCHAR2,
   role_           IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Enable_Pres_Object');
    --Check if editing of role is allowed. This check is done to help not violate the license by mistake.
   IF Pres_Object_Util_API.Modify_Po_On_Role_Restricted(pres_object_id_,role_,'FALSE') THEN
      RETURN;
   END IF;
   
   Pres_Object_Grant_API.New_Grant(pres_object_id_, role_);
END Enable_Pres_Object;


PROCEDURE Disable_Pres_Object (
   pres_object_id_ IN VARCHAR2,
   role_           IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Disable_Pres_Object');
   --Check if editing of role is allowed. This check is done to help not violate the license by mistake.
   IF Pres_Object_Util_API.Modify_Po_On_Role_Restricted(pres_object_id_,role_,'FALSE') THEN
      RETURN;
   END IF;
   Pres_Object_Grant_API.Remove_Grant(pres_object_id_, role_);
END Disable_Pres_Object;


PROCEDURE Security_Checkpoint (
   gate_id_    IN VARCHAR2,
   msg_        IN VARCHAR2 )
IS
   log_id_           NUMBER;
   sec_checkpoint_   CONSTANT VARCHAR2(3)    := Fnd_Setting_API.Get_Value('CHECKPOINT');
   
   sec_msg_ VARCHAR2(32000) := Fnd_Context_SYS.Find_Value('SECURITY_CHECKPOINT');
   username_ VARCHAR2(2000);
   fnd_user_ VARCHAR2(30);
   chkpoint_user_ VARCHAR2(30);
   chkpoint_comment_ VARCHAR2(2000);

   FUNCTION Security_Checkpoint_Open_Context___  RETURN BOOLEAN 
   IS
      context_arr_   Dbms_Session.appctxtabtyp;
      context_size_ NUMBER;
   BEGIN
     Dbms_Session.List_Context (context_arr_, context_size_);
      FOR i IN 1 .. context_arr_.COUNT LOOP
         IF (context_arr_(i).namespace = context_) THEN
              IF ((context_arr_(i).attribute IN ('SECURITY_CHECKPOINT')) AND (context_arr_(i).value = 'OPEN')) THEN
                 RETURN(TRUE);
              END IF;
         END IF;
      END LOOP;
      RETURN(FALSE);
   END Security_Checkpoint_Open_Context___ ;
   
   FUNCTION Security_Checkpoint_Open___ (
      msg_  IN VARCHAR2 ) RETURN BOOLEAN 
   IS
   BEGIN
      IF ((Security_Checkpoint_Open_Context___) OR
          (Message_SYS.Find_Attribute(msg_, 'OPEN', Fnd_Boolean_API.DB_FALSE) = Fnd_Boolean_API.DB_TRUE) OR
          (Message_SYS.Find_Attribute(msg_, 'ID', '') = Fnd_Session_API.Get_Checkpoint_Id)) THEN
         RETURN(TRUE);
      ELSE
         RETURN(FALSE);
      END IF;
   END Security_Checkpoint_Open___;
   
   FUNCTION Security_Checkpoint_Get___ (
      gate_id_ IN VARCHAR2 )  RETURN VARCHAR2
   IS
      message_ VARCHAR2(32000);
   BEGIN
      message_ := Message_SYS.Construct('SECURITY_CHECKPOINT');
      IF Fnd_Setting_API.Get_Value('CHECKPOINT_U_TIMEOUT')= 'ON' THEN
         Message_SYS.Set_Attribute(message_, 'USERNAME',  Fnd_User_API.Get_Web_User(Fnd_Session_API.Get_Fnd_User) );
      END IF;
      Message_SYS.Set_Attribute(message_, 'ID', Fnd_Session_API.Get_Checkpoint_Id);
      Message_SYS.Set_Attribute(message_, 'GATE_ID', gate_id_);
      RETURN(message_);
   END Security_Checkpoint_Get___;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Security_Checkpoint');
   -- Check if Security Checkpoint framework is enabled
   IF sec_checkpoint_ = 'ON' THEN
      IF Security_Checkpoint_Activated(gate_id_) = 'TRUE' THEN
         IF Security_Checkpoint_Open___(sec_msg_) THEN 
            -- Gate is open
            -- Log if new checkpoint
            username_ := Message_SYS.Find_Attribute(sec_msg_, 'USERNAME', '');
            fnd_user_ := Fnd_User_API.Get_Web_User_Identity_(upper(username_));
            chkpoint_user_ := Fnd_Session_API.Get_Checkpoint_User();
            chkpoint_comment_ := Fnd_Session_API.Get_Checkpoint_Comment();
            Sec_Checkpoint_Log_API.Log__(log_id_, gate_id_, msg_, NVL(chkpoint_comment_, Message_SYS.Find_Attribute(sec_msg_, 'USER_COMMENT', '')), NVL(chkpoint_user_, fnd_user_));
            -- Execute event
            Execute_Event___('SECURITY_CHECKPOINT_SUCCESS', gate_id_, fnd_user_, msg_);
         ELSE
            -- Log if new checkpoint
            Fnd_Session_API.Set_Checkpoint_Id__(sys_guid());
            Error_SYS.Security_Checkpoint_(Security_Checkpoint_Get___(gate_id_));
         END IF;
      END IF;
   END IF;
END Security_Checkpoint;


PROCEDURE Log_Checkpoint_Error (
   gate_id_    IN VARCHAR2,
   error_msg_  IN VARCHAR2,
   username_   IN VARCHAR2 DEFAULT NULL )
IS
   log_id_  NUMBER;
   fnd_user_ VARCHAR2(30);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Log_Checkpoint_Error');
   fnd_user_ := Fnd_User_API.Get_Web_User_Identity_(upper(username_));
   IF fnd_user_ IS NULL THEN
      --
      -- If username_ is invalid then current FND user identity will be logged
      --
      fnd_user_ := Fnd_Session_API.Get_Fnd_User;
   END IF;
   Sec_Checkpoint_Log_API.Log_Error__(log_id_, gate_id_, error_msg_, fnd_user_);
   Execute_Event___('SECURITY_CHECKPOINT_FAILURE', gate_id_, fnd_user_, NULL);
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT;
END Log_Checkpoint_Error;


FUNCTION Security_Checkpoint_Activated (
   gate_id_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   gate_state_ VARCHAR2(5) := 'FALSE';
   gate_rec_   Sec_Checkpoint_Gate_API.Public_rec;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Security_Checkpoint_Activated');
   -- Check if gate is Active
   gate_rec_ := Sec_Checkpoint_Gate_API.Get(gate_id_);
   IF gate_rec_.active = 'TRUE' THEN
      gate_state_ := 'TRUE';
   END IF;
   RETURN(gate_state_);
END Security_Checkpoint_Activated;


-- New_Role_Grant
--   This method grants a role to a given grantee. If the role to be granted
--   does not exist this function will create a dummy role in that name and
--   proceed with the grant.
PROCEDURE New_Role_Grant (
   role_    IN VARCHAR2,
   grantee_ IN VARCHAR2 )
IS
   upper_role_    VARCHAR2(30) := upper(role_);
   role_not_exist EXCEPTION;
   PRAGMA         exception_init(role_not_exist, -20111);
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'New_Role_Grant');
   BEGIN
      Fnd_Role_API.Exist(upper_role_);
   EXCEPTION
      WHEN role_not_exist THEN
         Create_Role(upper_role_);
   END;
   Grant_Role(role_, grantee_);
END New_Role_Grant;


FUNCTION Is_Ltu_Role (
   role_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Is_Ltu_Role');
   RETURN Is_Ltu_Role___(role_);
END Is_Ltu_Role;

FUNCTION Is_Atu_Role (
   role_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Is_Atu_Role');
   RETURN Is_Atu_Role___(role_);
END Is_Atu_Role;

FUNCTION Is_Technical_Role (
   role_ IN VARCHAR2) RETURN BOOLEAN
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Is_Technical_Role');
   RETURN Is_Technical_Role___(role_);
END Is_Technical_Role;

FUNCTION Is_Predefined_Role (
   role_ IN VARCHAR2) RETURN BOOLEAN DETERMINISTIC
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Is_Predefined_Role');
   IF role_ IN ('FND_WEBRUNTIME','FND_WEBENDUSER_MAIN','FND_WEBENDUSER_B2B','FND_ADMIN','FND_PRINTSERVER','FND_CONNECT','FND_PLSQLAP','FND_DEVELOPER','FND_CUSTOMIZE','FNDMIG_EXCEL_ADDIN',
     'TOUCHAPPS_ADMIN','TOUCHAPPS_RUNTIME','FND_TOUCHAPPS_CONFIG','FND _TOUCHAPPS_SYNC_TRACE','FND_QUICK_REPORTS','FND_MONITORING','FNDSCH_WEBSERVICE','FNDSCH_RUNTIME','FNDSCH_ADMIN') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Predefined_Role;

FUNCTION Get_Role_Type(
   role_ IN VARCHAR2) RETURN VARCHAR2
IS
   role_type_ VARCHAR2(20) := 'NORMAL';
BEGIN   
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Get_Role_Type');
   IF Is_Technical_Role(role_) THEN
      role_type_ := 'TECHNICAL';
   ELSIF Is_Predefined_Role(role_) THEN      
      role_type_ := 'PREDEFINED';
   ELSIF Is_Ltu_Role(role_) THEN        
      role_type_ := 'LTU';
   END IF;
   RETURN role_type_;
END Get_Role_Type;

PROCEDURE Adjust_Technical_Role
IS
   CURSOR po_grants IS
      SELECT po_id, role FROM pres_object_grant
      WHERE 
      (po_id LIKE 'cpg%'             -- custom pages
      OR po_id LIKE 'tbw%'           -- table windows
      OR po_id LIKE 'frm%'           -- detail windows
      AND role = 'FND_WEBRUNTIME' 
      );    
   
   CURSOR role_grants IS
      SELECT granted_role, grantee FROM fnd_role_role  
      WHERE grantee_type = 'ROLE'
      AND grantee = 'FND_WEBRUNTIME';
      
   CURSOR projection_grants IS
      SELECT projection, role FROM fnd_projection_grant_tab
      WHERE role = 'FND_WEBRUNTIME';
      
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Adjust_Technical_Role');
   --Update Technical permission sets by revoking granted roles and presentations object so it complies with license restriction by giving permission set hash value 0 which is valid in IFSApp8 SP2 and later
   --Clear presentation object grants
   FOR rec_ IN po_grants LOOP
      Pres_Object_Grant_API.Remove_Grant(rec_.po_id, rec_.role);
   END LOOP;
   --Clear role grants
   FOR rec_ IN role_grants LOOP
      Revoke_Role(rec_.granted_role, rec_.grantee);
   END LOOP;
   --Clear Projections
   FOR rec_ IN projection_grants LOOP
      Fnd_Projection_Grant_API.Revoke_All(rec_.projection, rec_.role, 'FALSE');
   END LOOP;
   --Grant framework projections to FND_WEBRUNTIME
   Grant_Framework_Projections('FND_WEBRUNTIME');
END Adjust_Technical_Role;  


FUNCTION Get_Security_Info (
   client_hash_value_ IN OUT VARCHAR2 ) RETURN CLOB
IS
   server_hash_value_   VARCHAR2(100) := to_char(Cache_Management_API.Get_Refreshed ('Security'), Client_SYS.Date_Format_);
   null_hash_value_     VARCHAR2(100) := to_char(Database_SYS.Get_First_Calendar_Date, Client_SYS.Date_Format_);

   msg_     CLOB := Message_SYS.Construct('SECURITY');
   tmp_     CLOB;
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Get_Security_Info');
   IF (nvl(client_hash_value_, null_hash_value_) != server_hash_value_)  THEN
      Message_SYS.Add_Clob_Attribute(msg_, 'SEPARATORS', ',;');
      tmp_ := Get_Restricted_Method_List___;
      IF (tmp_ IS NOT NULL) THEN 
         Message_SYS.Add_Clob_Attribute(msg_, 'RESTRICTIONS', tmp_);
      END IF;
      tmp_ := Get_Pres_Object_List___;
      IF (tmp_ IS NOT NULL) THEN 
         Message_SYS.Add_Clob_Attribute(msg_, 'PRESENTATION_OBJECTS', tmp_);
      END IF;
      tmp_ := Get_System_Privileges___;
      IF (tmp_ IS NOT NULL) THEN 
         Message_SYS.Add_Clob_Attribute(msg_, 'SYSTEM_PRIVILEGES', tmp_);
      END IF;
      tmp_ := Get_Activities___;
      IF (tmp_ IS NOT NULL) THEN 
         Message_SYS.Add_Clob_Attribute(msg_, 'ACTIVITIES', tmp_);
      END IF;
      tmp_ := Report_Definition_API.Get_Available_Reports;
      IF (tmp_ IS NOT NULL) THEN 
         Message_SYS.Add_Clob_Attribute(msg_, 'REPORTS', tmp_);
      END IF;
      client_hash_value_ := server_hash_value_;
   END IF;
   RETURN(msg_);
END Get_Security_Info;

-- DEVELOPER NOTE : Grant_Framework_Projections
-- Note that if the projection grants are modified in this method, JSF BP needs to be updated with the new HASH
PROCEDURE Grant_Framework_Projections (
   role_ VARCHAR2)
IS
   PROCEDURE Grant_Projection___ (
      projection_ VARCHAR2,
      role_ VARCHAR2)
   IS
   BEGIN
      Fnd_Projection_Grant_API.Grant_All(projection_,role_, 'FALSE');
   END Grant_Projection___;
BEGIN
   Grant_Projection___('FrameworkServices', role_);
   Grant_Projection___('ClientNavigator', role_);
   Grant_Projection___('Translations',role_);
   Grant_Projection___('ClientContext',role_);
   Grant_Projection___('UserSettings',role_);
   Grant_Projection___('UserProfileService',role_);
   Grant_Projection___('FavoritesService',role_);

END Grant_Framework_Projections;

@UncheckedAccess
PROCEDURE Grant_Inherited_Pres_Objs
IS
   CURSOR get_new_presobjects IS
      SELECT po.po_id
      FROM ( SELECT diff.po_id
             FROM ( SELECT po_id
                    FROM pres_object_tab
                      MINUS
                    SELECT po_id
                    FROM pres_object_snap_tab) diff
                    WHERE EXISTS ( SELECT 1
                                   FROM pres_object_dependency_tab t
                                   WHERE t.from_po_id = diff.po_id AND t.pres_object_dep_type = '11')) po,
             pres_object_tab po_t,
             fnd_layer_tab layer_t
      WHERE po_t.po_id = po.po_id
      AND   po_t.layer_id = layer_t.layer_id
      ORDER BY layer_t.ordinal;      
BEGIN
   FOR rec_ IN get_new_presobjects LOOP
      Pres_Object_Util_API.Grant_Inherited_Pres_Object(rec_.po_id);
   END LOOP;
END Grant_Inherited_Pres_Objs;

PROCEDURE Revoke_Role_Grants (
   role_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Revoke_Role_Grants');

   DELETE
      FROM SYSTEM_PRIVILEGE_GRANT_TAB
      WHERE role = role_;
      
   DELETE 
      FROM FND_PROJECTION_GRANT_TAB
      WHERE role = role_;
      
   DELETE 
      FROM FND_PROJ_ACTION_GRANT_TAB
      WHERE role = role_;
    
   DELETE 
      FROM FND_PROJ_ENTITY_GRANT_TAB
      WHERE role = role_;
   
   DELETE 
      FROM FND_PROJ_ENT_ACTION_GRANT_TAB
      WHERE role = role_;
   
   DELETE 
      FROM FND_GRANT_ROLE_TAB
      WHERE granted_role = role_;
      
   DELETE
      FROM FND_BPA_GRANT_TAB
      WHERE role = role_;
      
   DELETE
      FROM PRES_OBJECT_GRANT_TAB
      WHERE role = role_;
END Revoke_Role_Grants;

PROCEDURE Revoke_User_Role_Grants (
   role_ IN VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'SECURITY_SYS', 'Revoke_User_Role_Grants');

   DELETE
      FROM FND_USER_ROLE_TAB
      WHERE role = role_;
   
   DELETE 
      FROM FND_USER_ROLE_RUNTIME_TAB
      WHERE role = role_;
END Revoke_User_Role_Grants;