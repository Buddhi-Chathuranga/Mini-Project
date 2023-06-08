-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  130819          Automatically refactored by Developer Studio
--  000131  JICE    Added setting of module, connect to prior for connected objects
--                  in Transfer_Build_Storage (ToDo #3846).
--  000224  ERFO    Added logic in method Reset_Build_Storage (ToDo #3846).
--  000224  ERFO    Added parameters module_ and po_id_ for all general
--                  methods in this utility package (ToDo #3846).
--  000302  ERFO    Added call to Pres_Object_Grant_API-interfaces.
--  000321  ERFO    Changes in Revoke_Pres_Object (ToDo #3846).
--  000330  ERFO    Changes in Grant/Revoke_Pres_Object and added logic in
--                  method New_Pres_Object_Sec_Build (ToDo #3846).
--  000404  PeNi    Adjustments for new column names in pres_object_dependecy_tab
--                  and pres_object_security_tab
--  000405  PeNi    Upgraded info type for resolve_dependencies.
--  000405  ERFO    Added view PRES_OBJECT_SECURITY_AVAIL in Revoke/Grant_PO.
--  000405  ERFO    Added method Is_Object_Available (ToDo #3846).
--  000409  ROOD    Added method Get_Grant_Info (ToDo #3846).
--  000411  PeNi    Added method Test_Available
--  000413  ROOD    Changed view in Revoke/Grant_PO to pres_object_security_inst.
--  000419  ROOD    Changed back view in Revoke/Grant_PO to pres_object_security_avail.
--                  Added method Get_Sec_Object_Method_Type.
--  000427  PeNi    Changed Extern* to Dep Level*
--  000502  PeNi    Adjustments for new flag value ("Modified")
--  000502  ERFO    Added validation of security objects in Transfer_Build_Storage.
--  000518  ERFO    Changed behavior in Grant/Revoke_Pres_Object.
--  000518  PeNi    Added method Reset_Repository
--  000519  ROOD    Modified Get_Grant_Info to consider packages aswell.
--  000522  ROOD    Modified methods New_Pres_Object_... for performance reasons.
--  000524  PeNi    Corrected methods New_Pres_Object_....
--  000525  ROOD    Added logic to handle procedures that are to be seen as PRAGMA-methods.
--  000530  ROOD    Changed behavior in Grant/Revoke_Pres_Object.
--  000613  ROOD    Added a delete of grants in Reset_Repository.
--  001006  ROOD    Added method Grant_Query_Pres_Object (ToDo#3944).
--  001008  ROOD    Added default parameter info_type_ in Reset_Repository (ToDo#3944).
--  001018  ROOD    Changes in Reset_Repository (ToDo#3944).
--  001112  ROOD    Performance improvements in Reset_Repository (ToDo#3944).
--  001117  ROOD    Rewrote Grant_Pres_Object and Grant_Query_Pres_Object.
--                  Did Resolve_Dependencies obsolete.
--                  Improved performance in Revoke_Pres_Object (Bug#18360).
--  001127  ROOD    Parameter changes for Grant_Pres_Object and Grant_Query_Pres_Object (Bug#18360).
--  010219  ROOD    Changed default parameter po_recursive to TRUE in Grant_Pres_Object (ToDo#3991).
--  010220  ROOD    Added default parameters in Revoke_Pres_Object for recursive revoke (ToDo#3991).
--  010228  ROOD    Modified Revoke_Pres_Object to handle revoke of packages when needed (ToDo#3991).
--  010820  ROOD    Modifications in New_Pres_Object, New_Pres_Object_Sec and
--                  New_Pres_Object_Dependency regarding update situation (ToDo#3991).
--  010912  ROOD    Modifications in New_Pres_Object_Sec to prioritize sub_types.
--                  Added avoiding of deadlock situations when granting/revoking (ToDo#4033).
--  011001  ROOD    Removed revoking of non pragma methods in Grant_Pres_Object
--                  for grant_mode QUERY (ToDo#4033).
--  011031  ROOD    Added validation in New_Pres_Object_Sec to avoid methods with
--                  locking problems (ToDo#4033).
--  020205  ROOD    Added traces in Reset_Build_Storage for objects not transferred (ToDo#4084).
--  020304  ROOD    Changed Reset_Repository so that information in pres_object_grant_tab is
--                  not deleted upon a reset. The consistency is maintained through algorithm in
--                  the refresh of the security cache instead (Bug#28362).
--  020407  ROOD    Added warnings instead of traces in Reset_Build_Storage (ToDo#4104).
--  020506  ROOD    Avoided deletion of information in global PO's upon transfer (Bug#28925).
--  020620  ROOD    Avoided deleting db objects originating from  app/apx files
--                  when only app/apt files have been scanned. Moved detection of transfer
--                  warnings to Transfer_Build_Storage (Bug#29873).
--  020626  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  021119  ROOD    Added method Remove_Pres_Object (GLOB11).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030502  ROOD    Improved handling of packages that will deadlock (ToDo#4259).
--  030527  ROOD    Added check in Transfer_Build_Storage to avoid packages without
--                  methods to be transferred as views (Bug#36906).
--  030616  ROOD    Modified Reset_Repository to better handle dependencies
--                  and descriptions (Bug#36465).
--  031103  ROOD    Modifications to avoid incorrect update of info_type.
--  040707  ROOD    Applied changes in dictionary_sys-tables (F1PR413).
--  041020  ROOD    Added method Set_Info_Type_. Updated template (Bug#44954).
--                  Removed obsolete method Resolve_Dependencies.
--  041222  JORA    Replaced usage of fullmethod in security_sys_tab with package_name
--                  and method_name (Bug#48113).
--  050104  ROOD    Updated to new column_names for dictionary_sys-views (F1PR413).
--  04????  ROOD    Modified search criterias for method information in method
--                  Transfer_Build_Storage (Bug#42954).
--  050110  ROOD    Replaced from_module with module in New_Pres_Object_Dependency and modified
--                  handling of dependency ownership, stored in column module.
--                   Modified handling of dependencies in Reset_Build_Storage, Reset_Repository
--                  and Remove_Pres_Object (Bug#47476).
--  050322  HAAR    Added warning when granting method that uses F1 deadlock package (F1PR480).
--                  Added warning when trying to grant a method that's not installed.
--  051027  HAAR    Added Method_Is_Installed___ and View_Is_Installed_ against Oracle dictionary
--                  instead of own dictionary due to installation errors (F1PR480).
--  051111  HAAR    Changed so that the following methods are treated as PRAGMA methods:
--                  LOCK__, LANGUAGE_REFRESHED, INIT, FINITE_STATE_DECODE__, ENUMERATE_STATES__,
--                  FINITE_STATE_EVENTS__, ENUMERATE_EVENTS__, 'ENUMERATE', 'EXIST', 'EXIST_DB' (F1PR483).
--  060925  HAAR    Don't allow PO on exclude list as dependent PO's (Bug#60751).
--  090510  HAAR    Change vaiable exclude_list_ to CLOB from VARCHAR2(32000) (Bug#82693).
--  090518  HAAR    Don't grant/revoke subtypes 7 and 8, when granting/revoking recursively (Bug#82695).
--  090921  HAAR    Make sure that Sec_Objects is inserted with upper packages and view names (Bug#85980).
--  091106  NiWi    Added Transfer_Build_To_Live which also returns warnings(Bug#86609).
--  100615  UsRa    Modified the cursor get_objects in Grant_Pres_Object to exclude already granted pres objects (Bug#90766).
--  100827  HAAR    Added 2 new pres object dependecy types and added build table for dependencies (Bug#92657).
--  120815  MADD    Modified Transfer_Build_Storage PROCEDURE due to a Concatenation problem (Bug#104546).
--  121204  USRA  Added validation for INFO_TYPE (Bug#106173).
--  140309  MADDLK TEBASE-37,Merged Bug#112862.
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

new_line_                     CONSTANT VARCHAR2(2)  := chr(10);
LOG_PERMISSIONSET_UPGRADE     CONSTANT VARCHAR2(30) := 'UpgradePermissionSets';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Find_Layered_Dependency___ (
   po_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   dep_po_id_ pres_object_dep_build_tab.to_po_id%TYPE;
   
   CURSOR find_dep IS
      SELECT to_po_id
      FROM pres_object_dep_build_tab
      WHERE from_po_id = po_id_
      AND pres_object_dep_type = '11';
BEGIN
   OPEN  find_dep;
   FETCH find_dep INTO dep_po_id_;
   IF (find_dep%FOUND) THEN
      CLOSE find_dep;
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Found layered dependency to: ' || dep_po_id_);
      RETURN dep_po_id_;
   ELSE
      CLOSE find_dep;
      RETURN NULL;
   END IF;   
END Find_Layered_Dependency___;

FUNCTION Find_Multi_Layered_Dependency___ (
   po_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   multi_layered_dep_po_id_ pres_object_dependency_tab.to_po_id%TYPE;
   
   CURSOR get_multi_dep IS
      SELECT to_po_id
      FROM pres_object_dependency_tab
      WHERE from_po_id = po_id_
      AND pres_object_dep_type = '11';

BEGIN
   OPEN  get_multi_dep;
   FETCH get_multi_dep INTO multi_layered_dep_po_id_;
   IF (get_multi_dep%FOUND) THEN
      CLOSE get_multi_dep;
      Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Found multi layered dependency to: ' || multi_layered_dep_po_id_);
      RETURN multi_layered_dep_po_id_;
   ELSE
      CLOSE get_multi_dep;
      RETURN NULL;
   END IF;   
END Find_Multi_Layered_Dependency___;

FUNCTION Is_Layered_Dependency___ (
   layered_dep_po_id_ IN VARCHAR2,
   to_po_id_ IN VARCHAR2,
   pres_object_dep_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_dep IS
      SELECT 1 from pres_object_dependency_tab
      WHERE from_po_id in layered_dep_po_id_
      AND to_po_id = to_po_id_
      AND pres_object_dep_type = pres_object_dep_type_;    
BEGIN
   IF (layered_dep_po_id_ IS NULL ) THEN
      RETURN FALSE;
   END IF;
      
   -- There's a dependency to a layered object. See if this dependency is already defined in that object!
   OPEN  get_dep;
   FETCH get_dep INTO dummy_;
   IF (get_dep%FOUND) THEN
      CLOSE get_dep;
      RETURN TRUE;
   ELSE
      CLOSE get_dep;      
      RETURN FALSE;
   END IF;
END Is_Layered_Dependency___;

FUNCTION Is_Multi_Layered_Dependency___ (
   layered_dep_po_id_ IN VARCHAR2,
   to_po_id_ IN VARCHAR2,
   pres_object_dep_type_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   multi_layered_dep_po_id_ pres_object_dependency_tab.to_po_id%TYPE;
BEGIN
   IF (layered_dep_po_id_ IS NULL ) THEN
      RETURN FALSE;
   END IF;
   
   multi_layered_dep_po_id_ := Find_Multi_Layered_Dependency___(layered_dep_po_id_);
   IF (multi_layered_dep_po_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   
   RETURN Is_Layered_Dependency___(multi_layered_dep_po_id_, to_po_id_, pres_object_dep_type_);
END Is_Multi_Layered_Dependency___;

FUNCTION Is_Layered_Security___ (
   layered_dep_po_id_ IN VARCHAR2,
   sec_object_ IN VARCHAR2,
   sec_object_type_ IN VARCHAR2,
   pres_object_sec_sub_type_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_sec IS
      SELECT 1 from pres_object_security_tab
      WHERE po_id = layered_dep_po_id_
      AND sec_object = sec_object_
      AND sec_object_type = sec_object_type_
      AND pres_object_sec_sub_type = pres_object_sec_sub_type_;      
BEGIN
   IF (layered_dep_po_id_ = '') THEN
      RETURN FALSE;
   END IF;
      
   -- There's a dependency to a layered object. See if this security object is already defined in that object!
   OPEN  get_sec;
   FETCH get_sec INTO dummy_;
   IF (get_sec%FOUND) THEN
      CLOSE get_sec;
      RETURN TRUE;
   ELSE
      CLOSE get_sec;      
      RETURN FALSE;
   END IF;
END Is_Layered_Security___;

FUNCTION Is_Multi_Layered_Security___ (
   layered_dep_po_id_ IN VARCHAR2,
   sec_object_ IN VARCHAR2,
   sec_object_type_ IN VARCHAR2,
   pres_object_sec_sub_type_ IN VARCHAR2) RETURN BOOLEAN
IS
   multi_layered_dep_po_id_ pres_object_dependency_tab.to_po_id%TYPE;
BEGIN
   IF (layered_dep_po_id_ = '') THEN
      RETURN FALSE;
   END IF;
            
   multi_layered_dep_po_id_ := Find_Multi_Layered_Dependency___(layered_dep_po_id_);
   IF (multi_layered_dep_po_id_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   
   RETURN Is_Layered_Security___(multi_layered_dep_po_id_, sec_object_, sec_object_type_, pres_object_sec_sub_type_);   
END Is_Multi_Layered_Security___;


FUNCTION Get_Sec_Object_Method_Type___ (
   po_id_      IN VARCHAR2,
   sec_object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   method_type_      VARCHAR2(10);
   force_read_only_  VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
   CURSOR get_force_read_only IS
      SELECT p.force_read_only_db
      FROM   pres_object_security p
      WHERE  po_id = po_id_
      AND    p.sec_object = sec_object_;
BEGIN
   method_type_ := Get_Sec_Object_Method_Type(sec_object_);
   IF (method_type_ = 'P') THEN
      RETURN(method_type_);
   ELSE
      OPEN  get_force_read_only;
      FETCH get_force_read_only INTO force_read_only_;
      CLOSE get_force_read_only;
      IF (force_read_only_ = Fnd_Boolean_API.DB_FALSE) THEN
         method_type_ := 'N';
      ELSE
         method_type_ := 'P';
      END IF;
      RETURN(method_type_);
   END IF;
END Get_Sec_Object_Method_Type___;

FUNCTION Method_Is_Installed___ (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_method IS
      SELECT 1
      FROM   user_procedures
      WHERE  object_name = upper(package_name_)
      AND    procedure_name  = upper(method_name_);
BEGIN
   OPEN  get_method;
   FETCH get_method INTO dummy_;
   IF (get_method%FOUND) THEN
      CLOSE get_method;
      RETURN TRUE;
   ELSE
      CLOSE get_method;
      RETURN FALSE;
   END IF;
END Method_Is_Installed___;

FUNCTION View_Is_Installed___ (
   view_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR get_view IS
      SELECT 1
      FROM   user_views
      WHERE  view_name = upper(view_name_);
BEGIN
   OPEN  get_view;
   FETCH get_view INTO dummy_;
   IF (get_view%FOUND) THEN
      CLOSE get_view;
      RETURN TRUE;
   ELSE
      CLOSE get_view;
      RETURN FALSE;
   END IF;
END View_Is_Installed___;

PROCEDURE Validate_Info_Type___ (
   logical_unit_  IN VARCHAR2,
   info_type_     IN VARCHAR2 )
IS
BEGIN
   IF ( info_type_ NOT IN ( 'Auto', 'Manual', 'Modified' ) ) THEN
      Error_SYS.Item_Format(logical_unit_, 'INFO_TYPE', info_type_);
   END IF;
END Validate_Info_Type___;

PROCEDURE Get_Package_Method_Name___ (
   package_name_      OUT VARCHAR2,
   method_name_       OUT VARCHAR2,  
   full_method_name_  IN VARCHAR2 )
IS
BEGIN   
   package_name_ := upper(substr(full_method_name_, 1, instr(full_method_name_,'.')-1));
   method_name_  := initcap(substr(full_method_name_, instr(full_method_name_,'.')+1));
   
   IF package_name_ IS NULL OR method_name_ IS NULL THEN
      RAISE value_error;
   END IF;
   EXCEPTION
      WHEN value_error THEN
         Error_SYS.Record_General(lu_name_, 'METHOD_FORMAT: :P1 cannot be registered as a security object. Methods must have the format <Package_Name>.<Method_Name>.',full_method_name_);
END Get_Package_Method_Name___;


FUNCTION Is_License_Controlled_Po___ (
   po_id_ IN VARCHAR2) RETURN BOOLEAN
IS 
   str_             VARCHAR2(10);
   license_control_ BOOLEAN := FALSE;
BEGIN
   IF po_id_ IS NOT NULL THEN
      str_ := SUBSTR(po_id_,1,3);
      IF str_ = 'tbw' OR str_ = 'frm' OR str_ = 'cpg' THEN
         license_control_ := TRUE;
      ELSIF LENGTH(po_id_) > 4 AND SUBSTR(po_id_,-5,5) = '.page' THEN
         license_control_ := TRUE;   
      ELSIF INSTR(po_id_,'.portlets.') > 0 THEN
         license_control_ := TRUE;
      END IF;
   END IF;
   RETURN license_control_;
END Is_License_Controlled_Po___;

-- Is_Global_Po_Grant_Required___
--    Check whether the Pres Object is a Custom Field or Info Card.
--    If yes, Global PO should not be granted.
--    This method can be used to pass a po_id and check whether the global po grants should be given or not.
FUNCTION Is_Global_Po_Grant_Required___ (
    po_id_ IN VARCHAR2) RETURN BOOLEAN
IS
   grant_required_ BOOLEAN := TRUE;
   str_             VARCHAR2(10);
BEGIN
   IF po_id_ IS NOT NULL THEN
      str_ := SUBSTR(po_id_,1,2);
      IF str_ = 'cf' OR str_ = 'ic' THEN
         grant_required_ := FALSE;
      END IF;
   END IF;
   RETURN grant_required_;
END Is_Global_Po_Grant_Required___;

FUNCTION Is_New_Po___(po_id_ IN VARCHAR2) RETURN VARCHAR2
  IS
  dummy_ VARCHAR2(200);
  CURSOR get_new IS
   SELECT po_id
         FROM pres_object_tab p
         WHERE po_id = po_id_
         AND NOT EXISTS (SELECT 1 FROM pres_object_change_tab o WHERE o.po_id = p.po_id);         
  BEGIN
    OPEN get_new;
    FETCH get_new into dummy_;
    IF get_new%FOUND THEN
      CLOSE get_new;
      RETURN 'TRUE';
    ELSE
      CLOSE get_new;
      RETURN 'FALSE';
    END IF;  

  END Is_New_Po___;

PROCEDURE Grant_Global_Po___(
   exclude_list_ IN OUT CLOB,
   po_id_        IN     VARCHAR2,
   role_         IN     VARCHAR2,
   grant_mode_   IN     VARCHAR2)
IS
   global_po_id_  Pres_Object_Tab.po_id%TYPE;
BEGIN
      global_po_id_  := Get_Global_Po_Id(po_id_);      
      IF (Pres_Object_Grant_API.Exists(global_po_id_, role_) = FALSE) THEN
         Grant_Pres_Object___(exclude_list_, global_po_id_, role_, grant_mode_, 'TRUE', 'FALSE');
      END IF;
END Grant_Global_Po___;

PROCEDURE Revoke_Global_Po___(
   po_id_         IN VARCHAR2,
   role_          IN VARCHAR2,
   db_recursive_  IN VARCHAR2 DEFAULT 'TRUE',
   po_recursive_  IN VARCHAR2 DEFAULT 'TRUE',
   master_        IN VARCHAR2 DEFAULT 'TRUE',
   raise_error_   IN VARCHAR2 DEFAULT 'FALSE')
IS
   temp_          NUMBER;
   global_po_id_  Pres_Object_Tab.po_id%TYPE;
   global_module_ Pres_Object_Tab.module%TYPE;
   
   CURSOR get_po_grant_module (module_ IN VARCHAR2, glob_po_id_ IN VARCHAR2) IS
      SELECT 1 
      FROM pres_object_grant_tab g, pres_object p
      WHERE g.role = role_
      AND   g.po_id = p.po_id
      AND   p.module = module_
      AND   g.po_id <> glob_po_id_
      AND  g.po_id NOT IN (SELECT to_po_id FROM pres_object_dependency_tab d WHERE d.from_po_id = glob_po_id_);   
BEGIN
   global_po_id_  := Get_Global_Po_Id(po_id_); 
   global_module_ := Pres_Object_API.Get_Module(po_id_);      
   OPEN get_po_grant_module(global_module_, global_po_id_);
   FETCH get_po_grant_module INTO temp_;
   IF get_po_grant_module%FOUND THEN
      CLOSE get_po_grant_module;
   ELSE
      CLOSE get_po_grant_module;
      IF (Pres_Object_Grant_API.Exists(global_po_id_, role_) = TRUE) THEN
         Revoke_Pres_Object(global_po_id_,role_,db_recursive_,po_recursive_,master_,raise_error_);
      END IF;      
   END IF;  
END Revoke_Global_Po___;
-- Grant_Pres_Object___
--    Grants a presentation object and its corresponding database objects.
--    Depending on the flags that all have default values, the behaviour
--    can be controlled.
PROCEDURE Grant_Pres_Object___ (
   exclude_list_    IN OUT CLOB,
   in_po_id_        IN VARCHAR2,
   in_role_         IN VARCHAR2,
   in_grant_mode_   IN VARCHAR2 DEFAULT 'FULL',
   in_po_recursive_ IN VARCHAR2 DEFAULT 'TRUE',
   in_master_       IN VARCHAR2 DEFAULT 'TRUE',
   in_raise_error_  IN VARCHAR2 DEFAULT 'FALSE',
   only_grant_new_dependencies_ IN VARCHAR2 DEFAULT 'FALSE')
IS
   po_id_        pres_object_tab.po_id%TYPE;
   role_         VARCHAR2(100);
   grant_mode_   VARCHAR2(20);
   db_recursive_ VARCHAR2(5);
   po_recursive_ VARCHAR2(5);
   master_       VARCHAR2(5);
   raise_error_  VARCHAR2(5);
--
   sep_           VARCHAR2(1) := Client_SYS.text_separator_;

   CURSOR get_children(parent_po_id_ VARCHAR2) IS
      SELECT to_po_id
        FROM pres_object_dependency
       WHERE from_po_id = parent_po_id_
         AND pres_object_dep_type_db NOT IN (7,8);
         
   CURSOR get_dep IS
    SELECT from_po_id
      FROM pres_object_dependency
      WHERE to_po_id = po_id_
      AND pres_object_dep_type_db IN (11);      

BEGIN
   -- Check if PresObject exists
   po_id_ := in_po_id_;
   role_ := in_role_;
   grant_mode_ := in_grant_mode_;
   po_recursive_ := in_po_recursive_;
   master_ := in_master_;
   raise_error_ := in_raise_error_;
   IF NOT Pres_Object_API.Exists(po_id_) THEN
      IF (raise_error_ = Fnd_Boolean_API.DB_TRUE) THEN
         Error_SYS.Appl_General(lu_name_, 'EXIST_PO: The PO [:P1] does not exist.', po_id_);
      ELSE
         RETURN;
      END IF;
   END IF;

   --Check if editing of role is allowed. This check is done to help not violate the license by mistake.
   IF Modify_Po_On_Role_Restricted(po_id_,role_,raise_error_) THEN
      RETURN;
   END IF;   

   -- Check if allowed to grant PresObject in Read-Only mode
   IF (grant_mode_ = 'QUERY') THEN
      IF (Pres_Object_API.Get(po_id_).Allow_Read_Only = Fnd_Boolean_API.DB_FALSE) THEN
         IF (raise_error_ = Fnd_Boolean_API.DB_TRUE) THEN
            Error_SYS.Appl_General(lu_name_, 'ALLOW_GRANT_QUERY: The PO [:P1] is not allowed to grant QUERY.', po_id_);
         ELSE
            RETURN;
         END IF;
      END IF;
   END IF;
   --
   -- Grant globalModule package if not granted before, and if the PO is not a Custom Filed or Info Card(only for master PO objects)
   --
   IF (master_ = 'TRUE' AND Is_Global_Po_Grant_Required___(po_id_)) THEN
      Grant_Global_Po___(exclude_list_, po_id_, role_, grant_mode_);
   END IF;
   --
   -- Enable this PO if it is the master or if po granting is to be made recursively.
   --
   IF po_recursive_ = 'TRUE' OR master_ = 'TRUE' THEN
      Pres_Object_Grant_API.New_Grant(po_id_, role_);
   END IF;
   --
   -- Grant it's dependent objects (avoiding previously granted through exclude list).
   -- if no granting is to be made recursively then there is no need to continue at all.
   --
   IF po_recursive_ = 'TRUE' OR db_recursive_ = 'TRUE' THEN
      IF master_ = 'TRUE' THEN
         exclude_list_ := sep_;
      END IF;
      FOR dep IN get_children(po_id_) LOOP
         IF instr(exclude_list_, sep_||dep.to_po_id||sep_) > 0 THEN
            -- The PO that is to be granted has been granted in this chain before.
            -- Should not continue into an endless loop...
            Trace_SYS.Message('Circular dependency found for '||dep.to_po_id||'. It was ignored to continue.');
         ELSE
            -- The PO that is to be granted has NOT been granted in this chain before.
            exclude_list_ := exclude_list_ ||dep.to_po_id||sep_;
            --special option to only grant new pres object that are children to already granted presentation objects
            IF (only_grant_new_dependencies_ = 'TRUE') THEN 
               IF Is_New_Po___(dep.to_po_id) = 'TRUE' THEN
                  Grant_Pres_Object___(exclude_list_, dep.to_po_id, role_, grant_mode_, po_recursive_, 'FALSE','TRUE');   
               END IF;    
            ELSE
               Grant_Pres_Object___(exclude_list_, dep.to_po_id, role_, grant_mode_, po_recursive_, 'FALSE');
            END IF;
         END IF;
      END LOOP;
      master_ := in_master_;
      FOR dep IN get_dep LOOP
         IF instr(exclude_list_, sep_||dep.from_po_id||sep_) > 0 THEN
            -- The PO that is to be granted has been granted in this chain before.
            -- Should not continue into an endless loop...
            Trace_SYS.Message('Circular dependency found for '||dep.from_po_id||'. It was ignored to continue.');
         ELSE
            -- The PO that is to be granted has NOT been granted in this chain before.
            exclude_list_ := exclude_list_ ||dep.from_po_id||sep_;
            --special option to only grant new pres object that are children to already granted presentation objects
            Grant_Pres_Object___(exclude_list_, dep.from_po_id, role_, grant_mode_, po_recursive_, master_ );
         END IF;
      END LOOP;
   END IF;
END Grant_Pres_Object___;


-- Revoke_Pres_Object___
--    revokes s a presentation object and its corresponding database objects.
--    Depending on the flags that all have default values, the behaviour
--    can be controlled.
PROCEDURE Revoke_Pres_Object___ (
   exclude_list_    IN OUT CLOB,
   in_po_id_        IN VARCHAR2,
   in_role_         IN VARCHAR2,
   in_po_recursive_ IN VARCHAR2 DEFAULT 'TRUE',
   in_master_       IN VARCHAR2 DEFAULT 'TRUE',
   in_raise_error_  IN VARCHAR2 DEFAULT 'FALSE' )
IS
   sep_          VARCHAR2(1) := Client_SYS.text_separator_;
   po_id_        pres_object_tab.po_id%TYPE;
   role_         VARCHAR2(100);
   db_recursive_ VARCHAR2(5);
   po_recursive_ VARCHAR2(5);
   master_       VARCHAR2(5);
   raise_error_  VARCHAR2(5);
   CURSOR get_children(parent_po_id_ VARCHAR2) IS
      SELECT to_po_id
      FROM pres_object_dependency
      WHERE from_po_id = parent_po_id_
      AND pres_object_dep_type_db NOT IN (7,8);

   CURSOR get_dep IS
      SELECT from_po_id
      FROM pres_object_dependency
      WHERE to_po_id = po_id_
      AND pres_object_dep_type_db IN (11);      

BEGIN
   --
   -- Revoke all database objects related to this specific PO if it is the master
   -- or if db granting is to be made recursively.
   --
   po_id_ := in_po_id_;
   role_ := in_role_;
   --db_recursive_ := in_db_recursive_;
   po_recursive_ := in_po_recursive_;
   master_ := in_master_;
   raise_error_ := in_raise_error_;
   
   --Check if editing of role is allowed. This check is done to help not violate the license by mistake.
   IF Modify_Po_On_Role_Restricted(po_id_, role_, raise_error_) THEN
      RETURN;
   END IF;
   --
   -- Disable this specific PO if it is the master or if po granting is to be made recursively.
   --
   IF po_recursive_ = 'TRUE' OR master_ = 'TRUE' THEN
      Pres_Object_Grant_API.Remove_Grant(po_id_, role_);
      Revoke_Global_Po___(po_id_,role_,db_recursive_,po_recursive_, 'TRUE', raise_error_);
   END IF;

   --
   -- Revoke it's dependent objects (avoiding previously revoked through exclude list).
   -- if no revoking is to be made recursively then there is no need to continue at all.
   --
   IF po_recursive_ = 'TRUE' THEN
      IF master_ = 'TRUE' THEN
         exclude_list_ := sep_;
      END IF;
      FOR dep IN get_children(po_id_) LOOP
         IF instr(exclude_list_, sep_||dep.to_po_id||sep_) > 0 THEN
         -- The PO that is to be revoked has been revoked in this chain before.
         -- Should not continue into an endless loop...
            Trace_SYS.Message('Circular dependency found for '||dep.to_po_id||'. It was ignored to continue.');
         ELSE
         -- The PO that is to be revoked has NOT been revoked in this chain before.
            exclude_list_ := exclude_list_ ||dep.to_po_id||sep_;
            Revoke_Pres_Object___(exclude_list_, dep.to_po_id, role_, po_recursive_, 'FALSE', raise_error_);
         END IF;
      END LOOP;
   END IF;
   master_ := in_master_;
   FOR dep IN get_dep LOOP
      IF instr(exclude_list_, sep_||dep.from_po_id||sep_) > 0 THEN
         -- The PO that is to be revoked has been revoked in this chain before.
         -- Should not continue into an endless loop...
         Trace_SYS.Message('Circular dependency found for '||dep.from_po_id||'. It was ignored to continue.');
      ELSE
         -- The PO that is to be revoked has NOT been revoked in this chain before.
         exclude_list_ := exclude_list_ ||dep.from_po_id||sep_;
         Revoke_Pres_Object___(exclude_list_, dep.from_po_id, role_, po_recursive_, master_, raise_error_);
      END IF;
   END LOOP;
END Revoke_Pres_Object___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Set_Info_Type_
--    Set the info type for a presentation object and (if all_objects_ is TRUE)
--    for its children.
PROCEDURE Set_Info_Type_ (
   po_id_        IN VARCHAR2,
   info_type_    IN VARCHAR2,
   all_objects_  IN BOOLEAN DEFAULT TRUE )
IS
BEGIN
   Validate_Info_Type___('PresObject', info_type_);

   UPDATE pres_object_tab
      SET info_type = info_type_
      WHERE po_id = po_id_;

   IF all_objects_ THEN
      UPDATE pres_object_security_tab
         SET info_type = info_type_
         WHERE po_id = po_id_;

      UPDATE pres_object_dependency_tab
         SET info_type = info_type_
         WHERE from_po_id = po_id_;
   END IF;
END Set_Info_Type_;

PROCEDURE Read_Po_Snapshot_
IS
   space_ CONSTANT VARCHAR2(4):= '    '; 
   module_             pres_object_tab.module%TYPE;
   module_name_        module_tab.name%TYPE;  
   pres_object_type_   pres_object_tab.pres_object_type%TYPE;
   po_id_              pres_object_tab.po_id%TYPE;
   po_description_     VARCHAR2(2000);
   po_sec_object_      pres_object_security_tab.sec_object%TYPE;
   po_sec_object_type_ pres_object_security_tab.sec_object_type%TYPE;
   sys_date_           VARCHAR2(100);

   -- get list of modules added by the delivery
   CURSOR get_new_modules IS
      SELECT module, name 
      FROM module_tab 
      WHERE module IN
      (SELECT DISTINCT module
       FROM (SELECT module FROM pres_object_tab
             MINUS
             SELECT module FROM pres_object_snap_tab))
      ORDER BY module;

   -- get list of new presentation objects for existing modules
   CURSOR get_new_presobjects IS
      SELECT diff.module, diff.pres_object_type, diff.po_id, Pres_Object_API.Get_Description(diff.po_id)
      FROM (SELECT po_id, module, pres_object_type FROM pres_object_tab
            MINUS
            SELECT po_id, module, pres_object_type FROM  pres_object_snap_tab) diff
      WHERE diff.module NOT IN 
      (SELECT DISTINCT module 
       FROM(SELECT module 
            FROM pres_object_tab
            MINUS
            SELECT module 
            FROM pres_object_snap_tab))
      ORDER BY diff.module, diff.pres_object_type, diff.po_id;

   -- get list of new security objects (methods/views) for existing presentation objects
   CURSOR get_new_secobjects IS
      SELECT *
      FROM (SELECT po.module, po.pres_object_type, pos.po_id, pos.sec_object, pos.sec_object_type 
            FROM pres_object_security_tab pos, pres_object_tab po
            WHERE pos.po_id = po.po_id
            AND EXISTS (SELECT 1 
            FROM user_objects 
            WHERE object_name = DECODE(sec_object_type, 'METHOD', SUBSTR(sec_object, 1, INSTR(sec_object,'.')-1), sec_object) 
            AND object_type IN ('PACKAGE', 'VIEW'))
            MINUS
            SELECT po.module, po.pres_object_type, pos.po_id, pos.sec_object, pos.sec_object_type  
            FROM pres_object_security_snap_tab pos, pres_object_tab po
            WHERE pos.po_id = po.po_id)
      WHERE (module,po_id) NOT IN
            (SELECT module, po_id
             FROM  pres_object_tab
             MINUS
             SELECT module,po_id
             FROM  pres_object_snap_tab)
      ORDER BY module, pres_object_type, po_id, sec_object;

   --get list of removed modules
   CURSOR get_removed_modules IS
      SELECT module, name 
      FROM module_tab 
      WHERE module IN
      (SELECT DISTINCT module
       FROM (SELECT module
             FROM pres_object_snap_tab
             MINUS
             SELECT module FROM pres_object_tab))
      ORDER BY module;

   --get list of removed presentation objects
   CURSOR get_removed_presobjects IS
      SELECT diff.module, diff.pres_object_type, diff.po_id, Pres_Object_API.Get_Description(diff.po_id)
      FROM (SELECT po_id, module, pres_object_type
            FROM pres_object_snap_tab
            MINUS
            SELECT po_id, module, pres_object_type
            FROM pres_object_tab) diff
      ORDER BY diff.module, diff.pres_object_type, diff.po_id;
BEGIN
   SELECT To_Char(SYSDATE, value || ' HH24:MI:SS')
     INTO sys_date_
     FROM nls_session_parameters
    WHERE parameter = 'NLS_DATE_FORMAT';
   Dbms_Output.Put_Line('Presentation objects changes '||sys_date_);
   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New modules (components)');
   Dbms_Output.Put_Line('========================');
   Dbms_Output.Put_Line(' ');

   Dbms_Output.Put_Line('Module' || space_ || 'Name');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 50, '-'));
   OPEN get_new_modules;
   LOOP
      FETCH get_new_modules INTO module_ , module_name_;
      EXIT WHEN get_new_modules %NOTFOUND;
      Dbms_Output.Put_Line(RPAD(module_, 6) || space_ || module_name_);
   END LOOP;
   IF get_new_modules%ROWCOUNT = 0 THEN
           Dbms_Output.Put_Line('0 Rows');
   END IF;
   CLOSE get_new_modules;

   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New presentation objects for existing modules');
   Dbms_Output.Put_Line('=============================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module' || space_ || RPAD('Type', 6) || space_ || RPAD('Presentation Object ID', 45) || space_ || 'Description');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 6, '-') || space_ || RPAD('-', 45, '-') || space_ || RPAD('-', 60, '-'));
   OPEN get_new_presobjects;
   LOOP
      FETCH get_new_presobjects INTO module_ , pres_object_type_, po_id_, po_description_;
      EXIT WHEN get_new_presobjects %NOTFOUND;
      Dbms_Output.Put_Line(RPAD(module_, 6) || space_ || RPAD(pres_object_type_, 6) || space_ || RPAD(po_id_, 45) || space_ || po_description_);
   END LOOP;
   IF get_new_presobjects%ROWCOUNT = 0 THEN
           Dbms_Output.Put_Line('0 Rows');
   END IF;
   CLOSE get_new_presobjects;

   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('New security objects (methods/views) for existing presentation objects');
   Dbms_Output.Put_Line('======================================================================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module' || space_ || RPAD('Type', 6) || space_ || RPAD('Presentation Object ID', 45) || space_ || RPAD('Security Object', 55) || space_ || 'Sec Obj/Type');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 6, '-') || space_ || RPAD('-', 45, '-') || space_ || RPAD('-', 55, '-') || space_ || RPAD('-', 12, '-'));
   OPEN get_new_secobjects;
   LOOP
      FETCH get_new_secobjects INTO module_ , pres_object_type_, po_id_, po_sec_object_, po_sec_object_type_;
      EXIT WHEN get_new_secobjects %NOTFOUND;
      Dbms_Output.Put_Line(RPAD(module_, 6) || space_ || RPAD(pres_object_type_, 6) || space_ || RPAD(po_id_, 45) || space_ || RPAD(po_sec_object_, 55) || space_ || po_sec_object_type_);
   END LOOP;
   IF get_new_secobjects%ROWCOUNT = 0 THEN
           Dbms_Output.Put_Line('0 Rows');
   END IF;
   CLOSE get_new_secobjects;

   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('Removed modules (components)');
   Dbms_Output.Put_Line('============================');
   Dbms_Output.Put_Line(' ');        

   Dbms_Output.Put_Line('Module' || space_ || 'Name');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 50, '-'));
   OPEN get_removed_modules;
   LOOP
      FETCH get_removed_modules INTO module_ , module_name_;
      EXIT WHEN get_removed_modules %NOTFOUND;
      Dbms_Output.Put_Line(RPAD(module_, 6) || space_ || module_name_);
   END LOOP;
   IF get_removed_modules%ROWCOUNT = 0 THEN
           Dbms_Output.Put_Line('0 Rows');
   END IF;
   CLOSE get_removed_modules; 

   Dbms_Output.Put_Line(' ');
   Dbms_Output.Put_Line('Removed presentation objects');
   Dbms_Output.Put_Line('============================');
   Dbms_Output.Put_Line(' ');        
   Dbms_Output.Put_Line('Module' || space_ || RPAD('Type', 6) || space_ || RPAD('Presentation Object ID', 45) || space_ || 'Description');
   Dbms_Output.Put_Line(RPAD('-', 6, '-') || space_ || RPAD('-', 6, '-') || space_ || RPAD('-', 45, '-') || space_ || RPAD('-', 60, '-'));
   OPEN get_removed_presobjects;
   LOOP
      FETCH get_removed_presobjects INTO module_ , pres_object_type_, po_id_, po_description_;
      EXIT WHEN get_removed_presobjects %NOTFOUND;
      Dbms_Output.Put_Line(RPAD(module_, 6) || space_ || RPAD(pres_object_type_, 6) || space_ || RPAD(po_id_, 45) || space_ || po_description_);
   END LOOP;
   IF get_removed_presobjects%ROWCOUNT = 0 THEN
           Dbms_Output.Put_Line('0 Rows');
   END IF;
   Dbms_Output.Put_Line(' ');        
   CLOSE get_removed_presobjects;        
END Read_Po_Snapshot_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Export_Repository (
   module_  IN VARCHAR2,
   layer_id_ IN VARCHAR2 DEFAULT 'Core') RETURN CLOB 
IS
   po_id_   Pres_Object_TAB.po_id%TYPE;
   tag_     CLOB;
   export_  CLOB;
   poids_   CLOB;
   secs_    CLOB;
   deps_    CLOB;
   
   CURSOR get_poid IS
      SELECT t.po_id, t.pres_object_type_db, t.info_type, REPLACE(REPLACE(t.description, '''','''||CHR(39)||'''),'&','''||CHR(38)||''')  description, allow_read_only_db, layer_id
      FROM pres_object t 
      WHERE module = module_
      AND layer_id = layer_id_
      ORDER BY nlssort(upper(po_id),'nls_sort=binary');
--AND po_id LIKE 'global%';
   
   CURSOR get_sec IS
      SELECT t.sec_object, t.sec_object_type_db, t.pres_object_sec_sub_type_db, t.info_type
      FROM pres_object_security t 
      WHERE po_id = po_id_
      ORDER BY nlssort(upper(po_id), 'nls_sort=binary'), nlssort(upper(sec_object), 'nls_sort=binary');
   
   CURSOR get_dep IS
      SELECT t.to_po_id, t.pres_object_dep_type_db, t.info_type
      FROM pres_object_dependency t 
      WHERE from_po_id = po_id_
      AND t.pres_object_dep_type_db NOT IN ('2', '12')
      ORDER BY nlssort(upper(from_po_id), 'nls_sort=binary'), nlssort(upper(to_po_id), 'nls_sort=binary');
   
   CURSOR get_deps IS
      SELECT t.to_po_id,
             t.from_po_id,
             t.pres_object_dep_type_db,
             t.info_type,
             po.module
        FROM pres_object po, pres_object_dependency t
       WHERE t.to_po_id = po.po_id
         AND module = module_
         AND layer_id = layer_id_
         AND t.pres_object_dep_type_db IN ('2', '12')
         ORDER BY nlssort(upper(from_po_id), 'nls_sort=binary'), nlssort(upper(to_po_id), 'nls_sort=binary');
BEGIN
   tag_ := Fnd_Code_Template_API.Get_Template('ExportPORepository');
   Fnd_Code_Template_API.Replace_Tag('SYSDATE', Database_SYS.Get_Formatted_Datetime(sysdate), tag_);
   export_ := export_ || tag_;
   -- Loop over PO ID
   FOR rec IN get_poid LOOP
      tag_ := Fnd_Code_Template_API.Get_Template('ExportPO');
      poids_ := tag_ || new_line_;
      po_id_ := rec.po_id;
      FOR rec_sec IN get_sec LOOP
         tag_ := Fnd_Code_Template_API.Get_Template('ExportPOSecurity');
         secs_ := tag_ || new_line_;
         Fnd_Code_Template_API.Replace_Tag('SEC_OBJECT', rec_sec.sec_object, secs_);
         Fnd_Code_Template_API.Replace_Tag('SEC_OBJECT_TYPE', rec_sec.sec_object_type_db, secs_);
         Fnd_Code_Template_API.Replace_Tag('SEC_SUB_TYPE', rec_sec.pres_object_sec_sub_type_db, secs_);
         Fnd_Code_Template_API.Replace_Tag('SEC_INFO_TYPE', rec_sec.info_type, secs_);
         poids_ := poids_ || secs_;
      END LOOP;
      secs_ := NULL;
      --
      FOR rec_dep IN get_dep LOOP
         tag_ := Fnd_Code_Template_API.Get_Template('ExportPODependency');
         deps_ := tag_ || new_line_;
         Fnd_Code_Template_API.Replace_Tag('TO_PO_ID', rec_dep.to_po_id, deps_);
         Fnd_Code_Template_API.Replace_Tag('PRES_OBJECT_DEP_TYPE', rec_dep.pres_object_dep_type_db, deps_);
         Fnd_Code_Template_API.Replace_Tag('DEP_INFO_TYPE', rec_dep.info_type, deps_);
         poids_ := poids_ || deps_;
      END LOOP;
      deps_ := NULL;
      --
      Fnd_Code_Template_API.Replace_Tag('PO_ID', po_id_, poids_);
      Fnd_Code_Template_API.Replace_Tag('PO_TYPE', rec.pres_object_type_db, poids_);
      Fnd_Code_Template_API.Replace_Tag('PO_INFO_TYPE', rec.info_type, poids_);
      IF (nvl(rec.description, '!') = Nvl(Asciistr(rec.description), '!')) THEN 
         Fnd_Code_Template_API.Replace_Tag('UNICODE_START', '', poids_);
         Fnd_Code_Template_API.Replace_Tag('PO_ID_DESCR', rec.description, poids_);
         Fnd_Code_Template_API.Replace_Tag('UNICODE_END', '', poids_);
      ELSE 
         Fnd_Code_Template_API.Replace_Tag('UNICODE_START', 'Database_SYS.Unistr(', poids_);
         Fnd_Code_Template_API.Replace_Tag('PO_ID_DESCR', Asciistr(rec.description), poids_);
         Fnd_Code_Template_API.Replace_Tag('UNICODE_END', ')', poids_);
      END IF;
      -- Special handling for arguments with default values
      IF (rec.allow_read_only_db = Fnd_Boolean_API.DB_TRUE) THEN
         Fnd_Code_Template_API.Replace_Tag('PO_ALLOW_READ_ONLY', to_char(NULL), poids_);
      ELSE 
         Fnd_Code_Template_API.Replace_Tag('PO_ALLOW_READ_ONLY', ', allow_read_only_ => '''||rec.allow_read_only_db||'''', poids_);     
      END IF;      
      IF (rec.layer_id = 'Core') THEN
         Fnd_Code_Template_API.Replace_Tag('PO_LAYER_ID', to_char(NULL), poids_);
      ELSE 
         Fnd_Code_Template_API.Replace_Tag('PO_LAYER_ID', ', layer_id_ => '''||rec.layer_id||'''', poids_);
      END IF;
      export_ := export_ || poids_ || Fnd_Code_Template_API.Get_Template('ExportPOEnd');
   END LOOP;
   --
   deps_ := null;
   FOR rec_dep IN get_deps LOOP
      tag_ := Fnd_Code_Template_API.Get_Template('ExportPODependency');
      deps_ := deps_ || tag_ || new_line_;
      Fnd_Code_Template_API.Replace_Tag('PO_ID', rec_dep.from_po_id, deps_);
      Fnd_Code_Template_API.Replace_Tag('TO_PO_ID', rec_dep.to_po_id, deps_);
      Fnd_Code_Template_API.Replace_Tag('PRES_OBJECT_DEP_TYPE', rec_dep.pres_object_dep_type_db, deps_);
      Fnd_Code_Template_API.Replace_Tag('DEP_INFO_TYPE', rec_dep.info_type, deps_);
   END LOOP;
   IF deps_ IS NOT NULL THEN 
      export_ := export_ || Fnd_Code_Template_API.Get_Template('ExportPODynDep') || new_line_;
      export_ := export_ || deps_;
      export_ := export_ || Fnd_Code_Template_API.Get_Template('ExportPOEnd');
   END IF;
   --
   Fnd_Code_Template_API.Replace_Tag('MODULE', module_, export_);
   IF (layer_id_ = 'Core') THEN
      Fnd_Code_Template_API.Replace_Tag('LAYER_ID', to_char(NULL), export_);
   ELSE 
      Fnd_Code_Template_API.Replace_Tag('LAYER_ID', ', layer_id_ => '''||layer_id_||'''', export_);
   END IF;
   RETURN(export_);
END Export_Repository;

 --Check if editing of role is allowed. This check is done to help not violate the license by mistake.
FUNCTION Modify_Po_On_Role_Restricted (
   po_id_ IN VARCHAR2,
   role_  IN VARCHAR2,
   raise_error_  IN VARCHAR2 DEFAULT 'FALSE') RETURN BOOLEAN
IS
   po_restricted_ BOOLEAN := FALSE;
BEGIN
   IF (Security_Sys.Is_Ltu_Role(role_) OR Security_SYS.Is_Technical_Role(role_)) THEN
      IF Is_License_Controlled_Po___(po_id_) THEN
         IF (raise_error_ = Fnd_Boolean_API.DB_TRUE) THEN
            Error_SYS.Appl_General(lu_name_, 'MODIFY_PO_ON_LTU: Security grants to permission set [:P1] is restricted by license. Grants to PO [:P2] cannot be modified.', role_,po_id_);
         ELSE
            po_restricted_ := TRUE;
         END IF;
      END IF;
   END IF;
   RETURN po_restricted_;
END Modify_Po_On_Role_Restricted;

-- Grant_Pres_Object
--    Grants a presentation object and its corresponding database objects.
--    Depending on the flags that all have default values, the behaviour
--    can be controlled.
PROCEDURE Grant_Pres_Object (
   po_id_        IN VARCHAR2,
   role_         IN VARCHAR2,
   grant_mode_   IN VARCHAR2 DEFAULT 'FULL',
   db_recursive_ IN VARCHAR2 DEFAULT 'TRUE',
   po_recursive_ IN VARCHAR2 DEFAULT 'TRUE',
   master_       IN VARCHAR2 DEFAULT 'TRUE',
   raise_error_  IN VARCHAR2 DEFAULT 'FALSE' )
IS
   sep_ CLOB := Client_SYS.text_separator_;
BEGIN
   Grant_Pres_Object___(sep_, po_id_, role_, grant_mode_, po_recursive_, master_, raise_error_);
END Grant_Pres_Object;

-- Revoke_Pres_Object
--    revokes s a presentation object and its corresponding database objects.
--    Depending on the flags that all have default values, the behaviour
--    can be controlled.
PROCEDURE Revoke_Pres_Object (
   po_id_        IN VARCHAR2,
   role_         IN VARCHAR2,
   db_recursive_ IN VARCHAR2 DEFAULT 'TRUE',
   po_recursive_ IN VARCHAR2 DEFAULT 'TRUE',
   master_       IN VARCHAR2 DEFAULT 'TRUE',
   raise_error_  IN VARCHAR2 DEFAULT 'FALSE' )
IS
   sep_ CLOB := Client_SYS.text_separator_;
BEGIN
   Revoke_Pres_Object___(sep_, po_id_, role_, po_recursive_, master_, raise_error_);
END Revoke_Pres_Object;

PROCEDURE Grant_Roles_Inherited_Po
IS
   
   CURSOR get_inheritance IS
      SELECT from_po_id 
      FROM pres_object_dependency d, pres_object p
      WHERE p.po_id = d.from_po_id
      AND   p.layer_id IN ('Ext', 'Cust')
      AND pres_object_dep_type_db = '11';

BEGIN
   -- Check for inheritance
   FOR rec IN get_inheritance LOOP
      Grant_Inherited_Pres_Object(rec.from_po_id);
   END LOOP;
END Grant_Roles_Inherited_Po;

-- Grant_Inherited_Pres_Object
--    Grants an inherited presentation object and its corresponding database objects to all role its inheritated PO is already granted to
PROCEDURE Grant_Inherited_Pres_Object (
   po_id_        IN VARCHAR2,
   role_         IN VARCHAR2 DEFAULT '%',
   raise_error_  IN VARCHAR2 DEFAULT 'FALSE' )
IS
   sep_ CLOB := Client_SYS.text_separator_;
   grant_mode_   VARCHAR2(20);
   master_       VARCHAR2(5) := 'TRUE';
   po_recursive_ VARCHAR2(5) := 'FALSE';
   to_po_id_     VARCHAR2(100);

   CURSOR get_inheritance IS
      SELECT to_po_id 
      FROM pres_object_dependency  
      WHERE from_po_id = po_id_
      AND   pres_object_dep_type_db = '11';

   CURSOR get_role IS
      SELECT role 
      FROM pres_object_grant p
      WHERE role like role_
      AND po_id = to_po_id_
      AND EXISTS (SELECT role 
                  FROM fnd_role_tab
                  WHERE role = p.role);
BEGIN
   -- Check for inheritance
   FOR rec IN get_inheritance LOOP
      to_po_id_ := rec.to_po_id;
      --Find all roles granted to po_id_
      FOR role IN get_role LOOP
         IF Transactional_Methods_Granted(to_po_id_, role.role) = 'TRUE' THEN
            grant_mode_ := 'FULL';
         ELSE
            grant_mode_ := 'QUERY';
         END IF;    
         Grant_Pres_Object___(sep_, po_id_, role.role, grant_mode_, po_recursive_, master_, raise_error_);
      END LOOP;
   END LOOP;
END Grant_Inherited_Pres_Object;

PROCEDURE Reset_Build_Storage (
   module_    IN VARCHAR2,
   layer_id_  IN VARCHAR2 DEFAULT 'Core' )
IS
BEGIN
   --
   -- Delete static dependency references, dynamic should be left as is!
   --
      DELETE
         FROM pres_object_dep_build_tab
         WHERE pres_object_dep_type NOT IN ('2', '12')
         AND from_po_id IN (SELECT po_id
                            FROM pres_object_build_tab
                            WHERE module LIKE module_
                            AND layer_id = layer_id_);
      DELETE
         FROM pres_object_dep_build_tab
         WHERE pres_object_dep_type IN ('2', '12')
         AND to_po_id IN (SELECT po_id
                          FROM pres_object_build_tab
                          WHERE module LIKE module_
                          AND layer_id = layer_id_);
   --
   -- Delete security details
   --
   DELETE
      FROM pres_object_security_build_tab
      WHERE po_id IN (SELECT po_id
                      FROM pres_object_build_tab
                      WHERE module LIKE module_
                      AND layer_id = layer_id_);
   --
   -- Delete masters
   --
   DELETE
      FROM pres_object_build_tab
      WHERE module LIKE module_
      AND layer_id = layer_id_;
END Reset_Build_Storage;

PROCEDURE Transfer_Build_To_Live (
   info_   OUT VARCHAR2,
   module_ IN VARCHAR2,
   layer_id_ IN VARCHAR2 DEFAULT 'Core' )
IS
BEGIN
   Transfer_Build_Storage(module_, layer_id_, info_);
END Transfer_Build_To_Live;

PROCEDURE Transfer_To_Build (
   info_     OUT CLOB,
   module_   IN  VARCHAR2,
   layer_id_ IN  VARCHAR2 DEFAULT 'Core',
   po_msg_   IN  CLOB )
IS
   name_    Message_SYS.name_table_clob;
   value_   Message_SYS.line_table_clob;
   count_   NUMBER;
   name2_   Message_SYS.name_table_clob;
   value2_  Message_SYS.line_table_clob;
   count2_  NUMBER;
   name3_   Message_SYS.name_table_clob;
   value3_  Message_SYS.line_table_clob;
   count3_  NUMBER;
   --
   po_rec_  Pres_Object_Build_Tab%ROWTYPE;
   sec_rec_ Pres_Object_Security_Build_Tab%ROWTYPE;
   dep_rec_ Pres_Object_Dep_Build_Tab%ROWTYPE;
BEGIN
   info_ := Message_SYS.Construct_Clob_Message(module_||'-'||layer_id_);
   Reset_Build_Storage(module_, layer_id_);
   Message_SYS.Get_Clob_Attributes(po_msg_, count_, name_, value_);
   -- Pres Objects
   FOR i_ IN 1..count_ LOOP
      IF name_(i_) = 'PO' THEN 
         po_rec_.po_id := Message_SYS.Get_Name(value_(i_));
         Log_SYS.App_Trace(Log_SYS.info_, po_rec_.po_id);
         po_rec_.pres_object_type := Message_SYS.Find_Attribute(value_(i_), 'TYPE', 'WIN');
         po_rec_.description_prog := Message_SYS.Find_Attribute(value_(i_), 'DESCRIPTION', '');
         po_rec_.allow_read_only := Message_SYS.Find_Attribute(value_(i_), 'ALLOW_READ_ONLY', Fnd_Boolean_API.DB_TRUE);
         po_rec_.layer_id := Message_SYS.Find_Attribute(value_(i_), 'LAYER_ID', layer_id_);
         New_Pres_Object_Build(po_rec_.po_id, module_, po_rec_.pres_object_type, po_rec_.description_prog, po_rec_.allow_read_only, layer_id_ => po_rec_.layer_id);
         -- Pres Object Security
         Message_SYS.Get_Clob_Attributes(Message_SYS.Find_Clob_Attribute(value_(i_), 'SEC_OBJECTS', ''), count2_, name2_, value2_);
         FOR j_ IN 1..count2_ LOOP 
            sec_rec_.po_id := po_rec_.po_id;
            sec_rec_.sec_object := Message_SYS.Get_Name(value2_(j_));
            sec_rec_.sec_object_type := Message_SYS.Find_Attribute(value2_(j_), 'TYPE', '');
            sec_rec_.pres_object_sec_sub_type := Message_SYS.Find_Attribute(value2_(j_), 'SUB_TYPE', '');
            Log_SYS.App_Trace(Log_SYS.info_, sec_rec_.sec_object);
            New_Pres_Object_Sec_Build(sec_rec_.po_id, sec_rec_.sec_object, sec_rec_.sec_object_type,  sec_rec_.pres_object_sec_sub_type);
         END LOOP;
         -- Pres Object Depenency
         Message_SYS.Get_Clob_Attributes(Message_SYS.Find_Clob_Attribute(value_(i_), 'DEP_OBJECTS', ''), count3_, name3_, value3_);
         FOR k_ IN 1..count3_ LOOP 
            dep_rec_.from_po_id := po_rec_.po_id;
            dep_rec_.to_po_id := Message_SYS.Get_Name(value3_(k_));
            dep_rec_.pres_object_dep_type := Message_SYS.Find_Attribute(value3_(k_), 'TYPE', '');
            dep_rec_.info_type := Message_SYS.Find_Attribute(value3_(k_), 'INFO_TYPE', 'Auto');
            IF (dep_rec_.pres_object_dep_type IN ('2', '12')) THEN
               New_Pres_Object_Dep_Build(dep_rec_.to_po_id, dep_rec_.from_po_id, dep_rec_.pres_object_dep_type, dep_rec_.info_type);
            ELSE
               New_Pres_Object_Dep_Build(dep_rec_.from_po_id, dep_rec_.to_po_id, dep_rec_.pres_object_dep_type, dep_rec_.info_type);
            END IF;
            IF NOT Pres_Object_Build_API.Exists(Message_SYS.Get_Name(value3_(k_))) THEN 
               Message_SYS.Add_Attribute(info_, 'INVALID_REF', Message_SYS.Get_Name(value3_(k_)));
            END IF;
         END LOOP;
      ELSE
         po_rec_.po_id := Message_SYS.Get_Name(value_(i_));
         Message_SYS.Get_Clob_Attributes(Message_SYS.Find_Clob_Attribute(value_(i_), 'DEP_OBJECTS', ''), count3_, name3_, value3_);
         FOR k_ IN 1..count3_ LOOP 
            dep_rec_.from_po_id := po_rec_.po_id;
            dep_rec_.to_po_id := Message_SYS.Get_Name(value3_(k_));
            dep_rec_.pres_object_dep_type := Message_SYS.Find_Attribute(value3_(k_), 'TYPE', '');
            dep_rec_.info_type := Message_SYS.Find_Attribute(value3_(k_), 'INFO_TYPE', 'Auto');
            New_Pres_Object_Dep_Build(dep_rec_.from_po_id, dep_rec_.to_po_id, dep_rec_.pres_object_dep_type, dep_rec_.info_type);
         END LOOP;
      END IF;
   END LOOP;
END Transfer_To_Build;

PROCEDURE Transfer_Build_Storage (
   module_ IN VARCHAR2,
   layer_id_ IN VARCHAR2 DEFAULT 'Core',
   untransferred_ OUT VARCHAR2 )
IS
   install_       BOOLEAN := FALSE;

   global_layer_  Pres_Object_Tab.layer_id%TYPE := layer_id_;
   global_po_id_  Pres_Object_Tab.po_id%TYPE;

   po_id_         pres_object_tab.po_id%TYPE;
   dep_po_id_     pres_object_tab.po_id%TYPE;
   prev_po_id_    pres_object_tab.po_id%TYPE;   
   
   -- For layered dependency filtering.
   layered_dep_po_id_ pres_object_tab.po_id%TYPE;
   TYPE arr_type IS TABLE OF pres_object_tab.po_id%TYPE;
   dep_array_ arr_type := arr_type();
   i_ INTEGER := 1;

   CURSOR get_masters IS
      SELECT po_id, module, pres_object_type, description_prog, allow_read_only, layer_id
      FROM   pres_object_build_tab b
      WHERE  module LIKE module_
      AND    layer_id = layer_id_
      AND NOT EXISTS (SELECT 1
                      FROM   pres_object_exclude e
                      WHERE  e.po_id = b.po_id);

   CURSOR get_details IS
      SELECT D.po_id, D.sec_object, D.sec_object_type, D.pres_object_sec_sub_type
      FROM   pres_object_security_build_tab D
      WHERE  D.po_id = po_id_;

/* The check is already is implemented in the Cursor loop instead (gives better performance)
      AND    EXISTS (SELECT 1
                     FROM user_views
                     WHERE view_name = D.sec_object
                        UNION
                     SELECT 1
                     FROM user_procedures
                     WHERE object_name = upper(substr(D.sec_object, 1, instr(D.sec_object,'.')-1))
                     AND   procedure_name  = upper(substr(D.sec_object, instr(D.sec_object,'.')+1)));
*/

   CURSOR get_deps IS
      SELECT d.from_po_id, d.to_po_id, d.pres_object_dep_type, d.info_type
      FROM   pres_object_dep_build_tab D
      WHERE  (D.from_po_id = dep_po_id_) 
      OR     (D.to_po_id = dep_po_id_
      AND     d.pres_object_dep_type IN ('2', '12'));

   CURSOR get_untransferred(po_id_ IN VARCHAR2) IS
      SELECT DISTINCT sec_object
      FROM   pres_object_security_build_tab
      WHERE  po_id IN (SELECT po_id
                       FROM   pres_object_build_tab b
                       WHERE  po_id = po_id_)
      AND    sec_object NOT IN (SELECT sec_object
                                FROM pres_object_security_tab
                                WHERE po_id = po_id_);
BEGIN
   -- Get correct layer for global
   global_po_id_ := 
      CASE global_layer_ 
         WHEN 'Core' THEN 
            'global' || module_
         ELSE 
            'global' || module_ || '_' || layer_id_
      END;
   --
   -- Create headers from temporary table
   --
   FOR master IN get_masters LOOP
      --
      -- Delete information for all objects that are not globals
      --
      po_id_ := master.po_id;
      --
      IF NOT po_id_ = global_po_id_ THEN
         --
         -- Delete security details.
         -- Avoid deleting objects that originates from scanning app/apx-files.
         --
         DELETE 
            FROM pres_object_security_tab
            WHERE po_id IN (SELECT po_id
                            FROM pres_object_tab
                            WHERE po_id LIKE po_id_)
            AND info_type NOT IN  ('Manual','Modified');
         --
         -- Delete security details.
         -- Avoid deleting objects that originates from scanning app/apx-files.
         --
         DELETE
            FROM pres_object_dependency_tab
            WHERE from_po_id IN (SELECT po_id
                                 FROM pres_object_tab
                                 WHERE po_id LIKE po_id_)
            AND pres_object_dep_type NOT IN ('2', '12')
            AND info_type NOT IN  ('Manual','Modified');
         DELETE
            FROM pres_object_dependency_tab
            WHERE to_po_id IN (SELECT po_id
                               FROM pres_object_tab
                               WHERE po_id LIKE po_id_)
            AND pres_object_dep_type IN ('2', '12')
            AND info_type NOT IN  ('Manual','Modified');

         --
         -- Delete description details
         --
         DELETE
            FROM pres_object_description_tab
            WHERE po_id IN (SELECT po_id
                            FROM pres_object_tab
                            WHERE po_id LIKE po_id_
                            AND   info_type NOT IN ('Manual','Modified'));
         --
         -- Delete masters
         --
         DELETE
            FROM pres_object_tab
            WHERE po_id LIKE po_id_
            AND   info_type NOT IN ('Manual','Modified');
      END IF;
      --
      New_Pres_Object(master.po_id, master.module, master.pres_object_type, master.description_prog, 'Auto', master.allow_read_only, master.layer_id);
      --
      -- Create dependencies from temporary table
      --
      dep_po_id_ := master.po_id;
      layered_dep_po_id_ := Find_Layered_Dependency___(dep_po_id_);
      FOR dep IN get_deps LOOP
         IF (Is_Layered_Dependency___(layered_dep_po_id_, dep.to_po_id, dep.pres_object_dep_type)) THEN            
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Dependency object ''' || dep.to_po_id || ''' found in layered dependency ' || layered_dep_po_id_);
         ELSIF (Is_Multi_Layered_Dependency___(layered_dep_po_id_, dep.to_po_id, dep.pres_object_dep_type)) THEN            
            Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Dependency object ''' || dep.to_po_id || ''' found in multi layered dependency ' || layered_dep_po_id_);
         ELSE
            New_Pres_Object_Dependency(dep.from_po_id, dep.to_po_id, dep.pres_object_dep_type, 'Auto');
         END IF;         
      END LOOP;
      --
      -- Create details from temporary table
      --
      FOR detail IN get_details LOOP
         install_ := TRUE;
         IF detail.sec_object_type = 'METHOD' THEN
            IF NOT Method_Is_Installed___(substr(detail.sec_object, 1, instr(detail.sec_object, '.') - 1), substr(detail.sec_object, instr(detail.sec_object, '.') + 1)) THEN
               install_ := FALSE;
            END IF;
         ELSIF detail.sec_object_type = 'VIEW' THEN
            IF NOT View_Is_Installed___(detail.sec_object) THEN
               install_ := FALSE;
            END IF;
         END IF;
         IF install_ THEN 
            IF (Is_Layered_Security___(layered_dep_po_id_, detail.sec_object, detail.sec_object_type, detail.pres_object_sec_sub_type)) THEN            
               Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Security object ''' || detail.sec_object || ''' found in layered dependency ' || layered_dep_po_id_);
               -- Add the security object that is alread defined to the array, so it later can be excluded from the warning log.
               dep_array_.extend();
               dep_array_(i_) := detail.po_id || ':' || detail.sec_object;
               i_ := i_ + 1;
            ELSIF (Is_Multi_Layered_Security___(layered_dep_po_id_, detail.sec_object, detail.sec_object_type, detail.pres_object_sec_sub_type)) THEN            
               Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Security object ''' || detail.sec_object || ''' found in multi layered dependency ' || layered_dep_po_id_);
               -- Add the security object that is alread defined to the array, so it later can be excluded from the warning log.
               dep_array_.extend();
               dep_array_(i_) := detail.po_id || ':' || detail.sec_object;
               i_ := i_ + 1;
            ELSE
               New_Pres_Object_Sec(detail.po_id, detail.sec_object, detail.sec_object_type, detail.pres_object_sec_sub_type, 'Auto');               
            END IF;
         END IF;
      END LOOP;
   END LOOP;
   --
   -- Find and add warnings for objects not being transferred for different reasons.
   --
   untransferred_ := Message_SYS.Construct('UNTRANSFERRED_PO');
   prev_po_id_ := ' ';
   FOR masters IN get_masters LOOP
      FOR untransferred IN get_untransferred(masters.po_id) LOOP
         IF ( 32767 - nvl(length(untransferred_),0) < 400 ) THEN
            Message_SYS.Set_Attribute(untransferred_, 'MORE', 'UNTRANSFERRED');
            EXIT;
         ELSE            
            IF (dep_array_.COUNT > 0) THEN
               -- Security objects that are alread defined being a dependency to a layered object are to be excluded from the warning log.
               IF (masters.po_id || ':' || untransferred.sec_object MEMBER OF dep_array_) THEN
                  --Trace_SYS.Message(masters.po_id || ':' || untransferred.sec_object || ' is defined in layered object');
                  CONTINUE;
               END IF;
            END IF;
            Message_SYS.Add_Attribute(untransferred_, masters.po_id, untransferred.sec_object);
         END IF;
      END LOOP;
   END LOOP;
   --
   -- Scan static entries automatically
   --
   IF (layer_id_ = 'Core') THEN
      Transfer_Build_Storage_Static(module_);
   END IF;
   --
   -- Reset all build tables
   --
   Reset_Build_Storage(module_, layer_id_);
END Transfer_Build_Storage;

PROCEDURE Transfer_Build_Storage_Static (
   module_ IN VARCHAR2 )
IS
   po_id_   VARCHAR2(100);

   CURSOR get_includes IS
      SELECT po_id, module, pres_object_type, description
      FROM   pres_object_include_tab i
      WHERE  module LIKE module_;
   CURSOR get_sec IS
      SELECT po_id, sec_object, sec_object_type, pres_object_sec_sub_type, info_type, force_read_only
      FROM   pres_object_include_sec_tab i
      WHERE  po_id = po_id_;
BEGIN
   --
   -- Add PO includes
   --
   FOR inc IN get_includes LOOP
      po_id_ := inc.po_id;
      New_Pres_Object(inc.po_id, inc.module, inc.pres_object_type, inc.description, 'Auto');
      FOR rec IN get_sec LOOP
         New_Pres_Object_Sec(po_id_, rec.sec_object, rec.sec_object_type, rec.pres_object_sec_sub_type, rec.info_type, rec.force_read_only);
      END LOOP;
   END LOOP;
END Transfer_Build_Storage_Static;

PROCEDURE New_Pres_Object (
   po_id_            IN VARCHAR2,
   module_           IN VARCHAR2,
   pres_object_type_ IN VARCHAR2,
   description_prog_ IN VARCHAR2,
   info_type_        IN VARCHAR2,
   allow_read_only_db_  IN VARCHAR2 DEFAULT 'TRUE',
   layer_id_         IN VARCHAR2 DEFAULT 'Core' )
IS
  old_info_type_ pres_object_tab.info_type%TYPE;
  old_desc_      pres_object_description.description%TYPE;
  old_module_    pres_object_tab.module%TYPE;
  dummy_         NUMBER;
  data_diff_     BOOLEAN;
  desc_diff_     BOOLEAN;
  po_rec_        Pres_Object_Tab%ROWTYPE;

  CURSOR get_main_data_difference(po_id_ IN VARCHAR2, module_ IN VARCHAR2, pres_object_type_ IN VARCHAR2) IS
     SELECT 1
     FROM pres_object_tab
     WHERE po_id = po_id_
     AND   module = module_
     AND   pres_object_type = pres_object_type_;

  CURSOR desc_exist_control(po_id_ IN VARCHAR2, lang_code_ IN VARCHAR2) IS
   SELECT 1
   FROM pres_object_description_tab
   WHERE po_id = po_id_
   AND   lang_code = lang_code_;
BEGIN

   -- First: validate the input.
   Validate_Info_Type___('PresObject', info_type_);
   --
   -- Create/Update master
   --
   BEGIN
      po_rec_.po_id := po_id_;
      po_rec_.pres_object_type := pres_object_type_;
      po_rec_.module := module_;
      po_rec_.info_type := info_type_;
      po_rec_.change_date := sysdate;
      po_rec_.allow_read_only := allow_read_only_db_;
      po_rec_.layer_id := layer_id_;
      Pres_Object_API.New_Pres_Object(po_rec_);
      /*
      INSERT INTO pres_object_tab
         (po_id, pres_object_type, module, info_type, change_date, allow_read_only, layer_id, rowversion)
      VALUES
         (po_id_, pres_object_type_, module_, info_type_, sysdate, allow_read_only_db_, layer_id_, sysdate);
      */
   EXCEPTION
      WHEN Error_SYS.Err_Record_Exist THEN
         --
         -- Upgrade situation. Only manual and modified entries can remain.
         -- Modified and manual entries are regarded as correct and may not be updated.
         -- If they are the same however, except for the info_type, the info_type is updated to 'Auto'.
         --

         old_info_type_ := Pres_Object_API.Get_Info_Type(po_id_);

         --
         -- Existing record of type 'Auto' should be updated
         --
         IF old_info_type_ = 'Auto' THEN
            po_rec_ := Pres_Object_API.Lock_By_Keys_Nowait(po_id_);
            old_module_ := po_rec_.module;
--            po_rec_.po_id := po_id_;
            po_rec_.pres_object_type := pres_object_type_;
            po_rec_.module := module_;
--            po_rec_.info_type := info_type_;
--            po_rec_.change_date := change_date_;
            po_rec_.allow_read_only := allow_read_only_db_;
            po_rec_.layer_id := layer_id_;
            Pres_Object_API.Modify_Pres_Object(po_rec_);
            IF old_module_ != module_ THEN
               DELETE FROM pres_object_dependency_tab
                  WHERE from_po_id = po_id_
                  AND   info_type  = old_info_type_
                  AND   pres_object_dep_type NOT IN ('2', '12');
               DELETE FROM pres_object_dependency_tab
                  WHERE to_po_id = po_id_
                  AND pres_object_dep_type IN ('2', '12')
                  AND   info_type  = old_info_type_;
               DELETE FROM pres_object_security_tab
                  WHERE po_id     = po_id_
                  AND   info_type = old_info_type_;
            END IF;
/*
            UPDATE pres_object_tab
            SET pres_object_type = pres_object_type_,
                allow_read_only  = allow_read_only_db_,
                module           = module_,
                rowversion       = sysdate
            WHERE po_id = po_id_;
            */
         --
         -- Existing record of type 'Modified' or 'Manual' should be checked for difference
         --
         ELSIF old_info_type_ IN ('Modified', 'Manual') THEN
            IF info_type_ = 'Auto' THEN
               -- Find out if the data differs
               OPEN get_main_data_difference(po_id_, module_, pres_object_type_);
               FETCH get_main_data_difference INTO dummy_;
               IF get_main_data_difference%FOUND THEN
                  data_diff_ := FALSE;
               ELSE
                  data_diff_ := TRUE;
               END IF;
               CLOSE get_main_data_difference;
               --
               -- Find out if the description differs
               -- Consider the fact that description may not exist yet and NULL values
               --
               OPEN desc_exist_control(po_id_, 'en');
               FETCH desc_exist_control INTO dummy_;
               IF desc_exist_control%FOUND THEN
                  old_desc_ := Pres_Object_API.Get_Description(po_id_);
                  IF old_desc_ IS NULL THEN
                     IF description_prog_ IS NULL THEN
                        desc_diff_ := FALSE;
                     ELSE
                        desc_diff_ := TRUE;
                     END IF;
                  ELSIF description_prog_ IS NULL THEN
                     desc_diff_ := TRUE;
                  ELSIF old_desc_ = description_prog_ THEN
                     desc_diff_ := FALSE;
                  ELSE
                     desc_diff_ := TRUE;
                  END IF;
               ELSE
                  desc_diff_ := FALSE;
               END IF;
               CLOSE desc_exist_control;
               --
               -- If no difference in data or desc exist since the exact records was found, update the info_type
               --
               IF NOT data_diff_ AND NOT desc_diff_ THEN
                  UPDATE pres_object_tab
                     SET info_type = info_type_,
                         rowversion = sysdate
                     WHERE po_id = po_id_;
               END IF;
            END IF;
         ELSE
            Error_SYS.Record_General(lu_name_, 'ERROR_INFOTYPE_PO: Incorrect Info_Type :P1 for Presentation Object :P2', old_info_type_, po_id_);
         END IF;
   END;

   --
   -- Create/Update detail
   --
   BEGIN
      INSERT INTO pres_object_description_tab
         (po_id, lang_code, description, rowversion)
      VALUES
         (po_id_, 'en', description_prog_, sysdate);
   EXCEPTION
      WHEN dup_val_on_index THEN
         --
         -- Upgrade situation. Only manual and modified entries can remain.
         -- Modified and manual entries are regarded as correct and may not be updated.
         --

         old_info_type_ := Pres_Object_API.Get_Info_Type(po_id_);

         --
         -- Existing record of type 'Auto' should be updated
         -- Existing record of type 'Modified' or 'Manual' has already been checked and handled above
         --
         IF old_info_type_ = 'Auto' THEN
            UPDATE pres_object_description_tab
               SET lang_code   = 'en',
                   description = NVL(description_prog_, description),
                   rowversion  = sysdate
               WHERE po_id = po_id_;
         END IF;
   END;
END New_Pres_Object;


PROCEDURE New_Pres_Object_Build (
   po_id_            IN VARCHAR2,
   module_           IN VARCHAR2,
   pres_object_type_ IN VARCHAR2,
   description_prog_ IN VARCHAR2,
   allow_read_only_  IN VARCHAR2 DEFAULT 'TRUE',
   layer_id_         IN VARCHAR2 DEFAULT 'Core' )
IS
   rec_         Pres_Object_Build_API.table_rec;
BEGIN
   rec_.po_id := po_id_;
   rec_.module := module_;
   rec_.pres_object_type := pres_object_type_;
   rec_.description_prog := description_prog_;
   rec_.allow_read_only := allow_read_only_;
   rec_.layer_id := layer_id_;
   Pres_Object_Build_API.Create_Or_Replace(rec_);
END New_Pres_Object_Build;


PROCEDURE New_Pres_Object_Sec (
   po_id_           IN VARCHAR2,
   sec_object_      IN VARCHAR2,
   sec_object_type_ IN VARCHAR2,
   pres_object_sec_sub_type_    IN VARCHAR2,
   info_type_       IN VARCHAR2,
   force_read_only_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   oldrec_           Pres_Object_Security_API.Public_Rec;
   dummy_            NUMBER;
   update_           BOOLEAN;
   new_sec_object_   VARCHAR2(100);
   package_name_ VARCHAR2(30);
   method_name_  VARCHAR2(30);

   CURSOR get_same_data(po_id_ IN VARCHAR2, new_sec_object_ IN VARCHAR2, sec_object_type_ IN VARCHAR2, pres_object_sec_sub_type_ IN VARCHAR2) IS
      SELECT 1
      FROM pres_object_security_tab
      WHERE po_id = po_id_
      AND   sec_object = new_sec_object_
      AND   sec_object_type = sec_object_type_
      AND   pres_object_sec_sub_type = pres_object_sec_sub_type_;
BEGIN

   -- Input validation
   Validate_Info_Type___('PresObjectSecurity', info_type_);

   -- Check if installed
   IF sec_object_type_ = 'METHOD' THEN
      Get_Package_Method_Name___(package_name_,method_name_, sec_object_);
      IF NOT Method_Is_Installed___(package_name_, UPPER(method_name_)) THEN
         Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Method '||sec_object_||' can not be granted because it is not installed.');
      END IF;
      new_sec_object_ := upper(substr(sec_object_, 1, instr(sec_object_, '.') - 1))||initcap(substr(sec_object_, instr(sec_object_, '.')));
   ELSIF sec_object_type_ = 'VIEW' THEN
      IF NOT View_Is_Installed___(sec_object_) THEN
         Log_SYS.Fnd_Trace_(Log_SYS.error_, 'View '||sec_object_||' can not be granted because it is not installed.');
      END IF;
      new_sec_object_ := upper(sec_object_);
   END IF;

   BEGIN
      INSERT INTO pres_object_security_tab
         (po_id, sec_object, sec_object_type, pres_object_sec_sub_type, info_type, force_read_only, rowversion)
      VALUES
         (po_id_, new_sec_object_, sec_object_type_, pres_object_sec_sub_type_, info_type_, force_read_only_, sysdate);
      IF SQL%FOUND THEN
         Pres_Object_API.Set_Change_Date(po_id_);
      END IF;
   EXCEPTION
      WHEN dup_val_on_index THEN
         --
         -- Upgrade situation.

         oldrec_ := Pres_Object_Security_API.Get(po_id_, new_sec_object_);

         IF (oldrec_.force_read_only != force_read_only_) THEN
            UPDATE pres_object_security_tab
            SET force_read_only = force_read_only_,
                info_type = 'Manual',
                rowversion = sysdate
            WHERE po_id = po_id_
            AND   sec_object = new_sec_object_;
         END IF;

         --
         -- Existing record of type 'Auto' should be updated
         --
         IF oldrec_.info_type = 'Auto' THEN
            -- The sub_type should be considered aswell by priority:
            -- METHODS: Base Method(1), Method(2), State(8), Default Where (7), Enumerate(6)
            -- VIEWS:   Base View(3), Security(9), View(4), Default Where (7), LOV View(5)
            update_ := FALSE;
            IF sec_object_type_ = 'METHOD' THEN
               IF pres_object_sec_sub_type_ = '1' THEN
                  update_ := TRUE;
               ELSIF pres_object_sec_sub_type_ = '2' AND oldrec_.pres_object_sec_sub_type IN ('8', '7', '6') THEN
                  update_ := TRUE;
               ELSIF pres_object_sec_sub_type_ = '8' AND oldrec_.pres_object_sec_sub_type IN ('7', '6') THEN
                  update_ := TRUE;
               ELSIF pres_object_sec_sub_type_ = '7' AND oldrec_.pres_object_sec_sub_type = '6' THEN
                  update_ := TRUE;
               END IF;
            ELSIF sec_object_type_ = 'VIEW' THEN
               IF pres_object_sec_sub_type_ = '3' THEN
                  update_ := TRUE;
               ELSIF pres_object_sec_sub_type_ = '9' AND oldrec_.pres_object_sec_sub_type IN ('4', '7', '5') THEN
                  update_ := TRUE;
               ELSIF pres_object_sec_sub_type_ = '4' AND oldrec_.pres_object_sec_sub_type IN ('7', '5') THEN
                  update_ := TRUE;
               ELSIF pres_object_sec_sub_type_ = '7' AND oldrec_.pres_object_sec_sub_type = '5' THEN
                  update_ := TRUE;
               END IF;
            ELSE
               Error_SYS.Record_General(lu_name_, 'ERROROBJECTTYPE: Erroneous Object Type :P1', sec_object_type_);
            END IF;

            IF update_ THEN
               UPDATE pres_object_security_tab
                  SET sec_object_type          = sec_object_type_,
                      pres_object_sec_sub_type = pres_object_sec_sub_type_,
                      rowversion               = sysdate
                  WHERE po_id = po_id_
                  AND   sec_object = new_sec_object_;
            END IF;
         --
         -- Modified and manual entries are regarded as correct and may not be updated.
         -- If the records are the same however, except for the info_type, the info_type is updated to 'Auto'.
         --
         ELSIF oldrec_.info_type IN ('Modified', 'Manual') THEN
            IF info_type_ = 'Auto' THEN
               -- Find out if the data differs
               OPEN get_same_data(po_id_, new_sec_object_, sec_object_type_, pres_object_sec_sub_type_);
               FETCH get_same_data INTO dummy_;
               IF get_same_data%FOUND THEN
                  --
                  -- No difference in data since the record was found, update the info_type
                  --
                  UPDATE pres_object_security_tab
                     SET info_type = info_type_,
                         rowversion = sysdate
                     WHERE po_id = po_id_
                     AND   sec_object = new_sec_object_;
               END IF;
               CLOSE get_same_data;
            END IF;
         ELSE
            Error_SYS.Record_General(lu_name_, 'ERROR_INFOTYPE_SEC: Incorrect Info_Type :P1 for Database Object :P2 in Presentation Object :P3', oldrec_.info_type, new_sec_object_, po_id_);
         END IF;
   END;
END New_Pres_Object_Sec;


PROCEDURE New_Pres_Object_Sec_Build (
   po_id_           IN VARCHAR2,
   sec_object_      IN VARCHAR2,
   sec_object_type_ IN VARCHAR2,
   pres_object_sec_sub_type_    IN VARCHAR2 )
IS
   pkg_         VARCHAR2(30);
   met_         VARCHAR2(30);
   rec_         Pres_Object_Security_Build_API.table_rec;
   pkg_length_  CONSTANT VARCHAR2(1000) := Language_SYS.Translate_Constant(lu_name_, 'PKG_LENGTH: Package and/or method [:P1] name can not be longer than 30 characters.', Fnd_Session_API.Get_Language, ':P1');
BEGIN
   IF (sec_object_type_ = 'METHOD') THEN
      BEGIN 
         pkg_ := upper(substr(sec_object_, 1, instr(sec_object_, '.')-1));
         met_ := replace(initcap(replace(substr(sec_object_, instr(sec_object_, '.')+1), '_', ' ')), ' ', '_');
      EXCEPTION
         WHEN value_error THEN
            Error_SYS.Appl_General(lu_name_, pkg_length_, sec_object_);
      END;
      rec_.sec_object := pkg_||'.'||met_;
   ELSIF (sec_object_type_ = 'VIEW') THEN
      rec_.sec_object := upper(sec_object_);
   END IF;
   rec_.po_id := po_id_;
   rec_.sec_object_type := sec_object_type_;
   rec_.pres_object_sec_sub_type := pres_object_sec_sub_type_;
   Pres_Object_Security_Build_API.Create_Or_Replace(rec_);
END New_Pres_Object_Sec_Build;

PROCEDURE New_Pres_Object_Dependency (
   from_po_id_    IN VARCHAR2,
   to_po_id_      IN VARCHAR2,
   pres_object_dep_type_  IN VARCHAR2,
   info_type_     IN VARCHAR2 )
IS
   dummy_ NUMBER;

   CURSOR exist_exclude IS
      SELECT 1
      FROM pres_object_exclude_tab
      WHERE (po_id = to_po_id_
         OR po_id = from_po_id_);
BEGIN

   -- Input validation
   Validate_Info_Type___('PresObjectDependency', info_type_);

   OPEN  exist_exclude;
   FETCH exist_exclude INTO dummy_;
   CLOSE exist_exclude;
   IF (dummy_ = 1) THEN
      RETURN; -- Not so nice coding, but if PO is on the exclude list nothing should be done.
   END IF;
   --
   Pres_Object_Dependency_API.New_Pres_Object_Dependency(from_po_id_, to_po_id_, pres_object_dep_type_, info_type_);
   IF (pres_object_dep_type_ = '11' AND NOT Installation_Sys.Get_Installation_Mode ) THEN
      Grant_Inherited_Pres_Object(from_po_id_);
   END IF;
END New_Pres_Object_Dependency;


PROCEDURE New_Pres_Object_Dep_Build (
   from_po_id_    IN VARCHAR2,
   to_po_id_      IN VARCHAR2,
   pres_object_dep_type_ IN VARCHAR2,
   info_type_     IN VARCHAR2 )
IS
   rec_           Pres_Object_Dep_Build_API.table_rec;
   dummy_         NUMBER;

   CURSOR exist_exclude IS
      SELECT 1
      FROM pres_object_exclude_tab
      WHERE (po_id = to_po_id_
         OR po_id = from_po_id_);
BEGIN

   -- Perform validation on the input
   Validate_Info_Type___('PresObjectDependency', info_type_);

   OPEN  exist_exclude;
   FETCH exist_exclude INTO dummy_;
   CLOSE exist_exclude;
   IF (dummy_ = 1) THEN
      RETURN; -- Not so nice coding, but if PO is on the exclude list nothing should be done.
   END IF;
   --
   -- Insert or update the record
   --
   rec_.from_po_id := from_po_id_;
   rec_.to_po_id := to_po_id_;
   rec_.pres_object_dep_type := pres_object_dep_type_;
   rec_.info_type := info_type_;
   Pres_Object_Dep_Build_API.Create_Or_Replace(rec_);
END New_Pres_Object_Dep_Build;

PROCEDURE Update_Description (
   po_id_       IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
   rec_ Pres_Object_Build_API.table_rec;
BEGIN
   SELECT *
   INTO rec_
   FROM pres_object_build_tab
   WHERE po_id = po_id_;
   rec_.description_prog := description_;
   Pres_Object_Build_API.Create_Or_Replace(rec_);
END Update_Description;


@UncheckedAccess
FUNCTION Is_Object_Available (
   sec_object_ IN VARCHAR2,
   role_       IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_name_ VARCHAR2(30);
   method_name_  VARCHAR2(30);
   pkg_length_   CONSTANT VARCHAR2(1000) := Language_SYS.Translate_Constant(lu_name_, 'PKG_LENGTH: Package and/or method [:P1] name can not be longer than 30 characters.', Fnd_Session_API.Get_Language, ':P1');
   --SOLSETFW
   CURSOR get_pragma_met (package_name_ IN VARCHAR2, method_name_ IN VARCHAR2) IS
      SELECT 1
      FROM   dictionary_sys_method_active
      WHERE  package_name = package_name_
      AND    method_name = method_name_
      AND    method_type = 'P';

   CURSOR get_met_privs (package_name_ IN VARCHAR2, method_name_ IN VARCHAR2) IS
      SELECT 1
      FROM   security_sys_tab
      WHERE  package_name = package_name_
      AND    method_name = method_name_
      AND    role = role_;

   CURSOR get_privs (obj_ VARCHAR2) IS
      SELECT 1
      FROM   user_tab_privs_made
      WHERE  table_name = obj_
      AND    grantee = role_;
BEGIN
   IF (instr(sec_object_, '.') > 0) THEN                             -- PACKAGE found
      BEGIN 
         package_name_ := upper(substr(sec_object_, 1, instr(sec_object_,'.')-1));
         method_name_  := initcap(substr(sec_object_, instr(sec_object_,'.')+1));
      EXCEPTION
         WHEN value_error THEN
            Error_SYS.Appl_General(lu_name_, pkg_length_, sec_object_);
      END;
      FOR rec IN get_privs(package_name_) LOOP
--         IF upper(method_name_) IN ('ENUMERATE', 'EXIST', 'EXIST_DB') THEN
--            RETURN('TRUE');                                          -- Handle procedures that are to be seen as PRAGMA-methods.
--         END IF;
         FOR rec2 IN get_pragma_met(package_name_, method_name_) LOOP -- Package granted - check method!
            RETURN('TRUE');                                          -- Method with PRAGMA - TRUE!
         END LOOP;
         FOR rec3 IN get_met_privs(package_name_, method_name_) LOOP
            RETURN('FALSE');                                         -- Method restriction found - FALSE!
         END LOOP;
         RETURN('TRUE');                                             -- Normal method without restriction - TRUE!
      END LOOP;
   ELSE                                                              -- VIEW found
      FOR rec IN get_privs(sec_object_) LOOP
         RETURN('TRUE');                                             -- View grant found - TRUE!
      END LOOP;
   END IF;
   RETURN('FALSE');                                                  -- Package/view grant not found - FALSE!
END Is_Object_Available;



@UncheckedAccess
FUNCTION Get_Grant_Info (
   po_id_   IN VARCHAR2,
   role_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_       NUMBER;
   package_     VARCHAR2(30);
   method_      VARCHAR2(30);
   pkg_length_  CONSTANT VARCHAR2(1000) := Language_SYS.Translate_Constant(lu_name_, 'PKG_LENGTH: Package and/or method [:P1] name can not be longer than 30 characters.', Fnd_Session_API.Get_Language, ':P1');

   CURSOR get_po_grant IS
      SELECT 1
      FROM pres_object_grant
      WHERE po_id = po_id_
      AND   role  = role_;

   CURSOR get_sec_objects IS
      SELECT sec_object, sec_object_type_db
      FROM  pres_object_security_avail
      WHERE po_id = po_id_;

   CURSOR get_method_revoke(package_ IN VARCHAR2, method_ IN VARCHAR2) IS
      SELECT 1
      FROM security_sys_tab
      WHERE package_name = package_
      AND   method_name  = method_
      AND   role         = role_;

   CURSOR get_package_grant(package_ IN VARCHAR2) IS
      SELECT 1
      FROM user_tab_privs_made
      WHERE table_name = package_
      AND   privilege  = 'EXECUTE'
      AND   grantee    = role_;

   CURSOR get_view_grant(view_ IN VARCHAR2) IS
      SELECT 1
      FROM user_tab_privs_made
      WHERE table_name = view_
      AND   privilege  = 'SELECT'
      AND   grantee    = role_;
BEGIN
   FOR rec IN get_po_grant LOOP
      FOR rec2 IN get_sec_objects LOOP                            -- The PO itself is "granted", find its security objects.
         IF rec2.sec_object_type_db = 'METHOD' THEN               -- The security object is a method.
            BEGIN 
               package_ := substr(rec2.sec_object, 1, instr(rec2.sec_object,'.')-1);
               method_  := substr(rec2.sec_object, instr(rec2.sec_object,'.')+1);
            EXCEPTION
               WHEN value_error THEN
                  Error_SYS.Appl_General(lu_name_, pkg_length_, rec2.sec_object);
            END;
            FOR rec3 IN get_method_revoke(package_, method_) LOOP
               RETURN 'PARTIALLY GRANTED';                        -- The method is revoked => PO is only partially granted.
            END LOOP;
            OPEN get_package_grant(package_);
            FETCH get_package_grant INTO dummy_;
            IF (get_package_grant%NOTFOUND) THEN                  -- The package is not granted => PO is only partially granted.
               CLOSE get_package_grant;
               RETURN 'PARTIALLY GRANTED';
            END IF;
            CLOSE get_package_grant;
         ELSIF rec2.sec_object_type_db = 'VIEW' THEN              -- The security object is a view.
            OPEN get_view_grant(rec2.sec_object);
            FETCH get_view_grant INTO dummy_;
            IF (get_view_grant%NOTFOUND) THEN                     -- The view is not granted => PO is only partially granted.
               CLOSE get_view_grant;
               RETURN 'PARTIALLY GRANTED';
            END IF;
            CLOSE get_view_grant;
         ELSE                                                     -- Undefined security object type, will return 'REVOKED'.
            RETURN 'REVOKED';
         END IF;
      END LOOP;
      RETURN 'GRANTED';                                           -- All security objects are granted => PO is granted.
   END LOOP;
   RETURN 'REVOKED';                                              -- The PO is revoked.
END Get_Grant_Info;


@UncheckedAccess
FUNCTION Get_Sec_Object_Method_Type (
   sec_object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   method_type_   VARCHAR2(10);
   method_        VARCHAR2(100) := substr(sec_object_, instr(sec_object_, '.')+1);
   --SOLSETFW
   CURSOR get_method_type IS
      SELECT method_type
      FROM   dictionary_sys_method_active
      WHERE  package_name = upper(substr(sec_object_, 1, instr(sec_object_, '.')-1))
      AND    method_name = method_;
BEGIN
   -- Handle procedures that are to be seen as PRAGMA-methods.
--   IF upper(method_) IN ('ENUMERATE', 'EXIST', 'EXIST_DB') THEN
--      RETURN 'P';
--   END IF;
   OPEN get_method_type;
   FETCH get_method_type INTO method_type_;
   IF get_method_type%NOTFOUND THEN
      method_type_ := 'N';
   END IF;
   CLOSE get_method_type;
   RETURN method_type_;
END Get_Sec_Object_Method_Type;


@UncheckedAccess
FUNCTION Get_Sec_Object_Method_Type (
   po_id_      IN VARCHAR2,
   sec_object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Sec_Object_Method_Type___(po_id_, sec_object_));
END Get_Sec_Object_Method_Type;


@UncheckedAccess
FUNCTION Is_Sec_Object_Read_Only (
   po_id_      IN VARCHAR2,
   sec_object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Fnd_Boolean_API.Decode(Is_Sec_Object_Read_Only_Db(po_id_, sec_object_)));
END Is_Sec_Object_Read_Only;


@UncheckedAccess
FUNCTION Is_Sec_Object_Read_Only_Db (
   po_id_      IN VARCHAR2,
   sec_object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   CASE Get_Sec_Object_Method_Type(po_id_, sec_object_)
      WHEN 'P' THEN
         RETURN('TRUE');
      ELSE
         RETURN('FALSE');
   END CASE;
END Is_Sec_Object_Read_Only_Db;


@UncheckedAccess
FUNCTION Get_Change_Info (
   po_id_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   info_ VARCHAR2(1000);
   CURSOR get_deleted IS
      SELECT po_id
      FROM pres_object_change_tab p
      WHERE po_id = po_id_
      AND NOT EXISTS (SELECT 1 FROM pres_object_tab o WHERE o.po_id = p.po_id);
   CURSOR get_new IS
      SELECT po_id
      FROM pres_object_tab p
      WHERE po_id = po_id_
      AND NOT EXISTS (SELECT 1 FROM pres_object_change_tab o WHERE o.po_id = p.po_id);
   CURSOR get_modified IS
      SELECT * FROM
      ((SELECT sec_object
      FROM pres_object_sec_change_tab p
      WHERE po_id = po_id_
         UNION ALL
      SELECT sec_object
      FROM pres_object_security_tab p
      WHERE po_id = po_id_)
         MINUS (
      SELECT sec_object
      FROM pres_object_sec_change_tab p
      WHERE po_id = po_id_
         INTERSECT
      SELECT sec_object
      FROM pres_object_security_tab p
      WHERE po_id = po_id_))
      UNION ALL
      ((SELECT to_po_id
      FROM pres_object_dep_change_tab p
      WHERE from_po_id = po_id_
         UNION ALL
      SELECT to_po_id
      FROM pres_object_dependency_tab p
      WHERE from_po_id = po_id_)
         MINUS
      ((SELECT to_po_id
      FROM pres_object_dep_change_tab p
      WHERE from_po_id = po_id_)
         INTERSECT
      SELECT to_po_id
      FROM pres_object_dependency_tab p
      WHERE from_po_id = po_id_));
BEGIN
   OPEN  get_new;
   FETCH get_new INTO info_;
   CLOSE get_new;
   IF (info_ IS NOT NULL) THEN
      RETURN(Pres_Object_Change_Type_API.Decode(Pres_Object_Change_Type_API.DB_NEW));
   END IF;
   OPEN  get_deleted;
   FETCH get_deleted INTO info_;
   CLOSE get_deleted;
   IF (info_ IS NOT NULL) THEN
      RETURN(Pres_Object_Change_Type_API.Decode(Pres_Object_Change_Type_API.DB_REMOVED));
   END IF;
   OPEN  get_modified;
   FETCH get_modified INTO info_;
   CLOSE get_modified;
   IF (info_ IS NOT NULL) THEN
      RETURN(Pres_Object_Change_Type_API.Decode(Pres_Object_Change_Type_API.DB_MODIFIED));
   ELSE
      RETURN(NULL);
   END IF;
END Get_Change_Info;


@UncheckedAccess
FUNCTION Get_Change_Info (
   po_id_      IN VARCHAR2,
   sec_object_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   info_ VARCHAR2(1000);
   CURSOR get_new IS
      SELECT po_id
      FROM pres_object_security_tab p
      WHERE po_id = po_id_
      AND sec_object = sec_object_
      AND NOT EXISTS (SELECT 1 FROM pres_object_sec_change_tab o WHERE o.po_id = p.po_id AND o.sec_object = p.sec_object);
BEGIN
   OPEN  get_new;
   FETCH get_new INTO info_;
   CLOSE get_new;
   IF (info_ IS NOT NULL) THEN
      RETURN(Pres_Object_Change_Type_API.Decode(Pres_Object_Change_Type_API.DB_NEW));
   ELSE
      RETURN(NULL);
   END IF;
END Get_Change_Info;

@UncheckedAccess
FUNCTION Get_Global_Po_Id(
   po_id_ IN VARCHAR2   ) RETURN VARCHAR2
IS
   global_module_ Pres_Object_Tab.module%TYPE;
   global_layer_  Pres_Object_Tab.layer_id%TYPE;
   global_po_id_  Pres_Object_Tab.po_id%TYPE;
BEGIN
   global_module_ := Pres_Object_API.Get_Module(po_id_);
   global_layer_  := Pres_Object_API.Get_Layer_Id(po_id_);
   global_po_id_  := 
   CASE global_layer_ 
      WHEN 'Core' THEN 
               'global' || global_module_
      ELSE 
               'global' || global_module_ || '_' || global_layer_
   END;
   RETURN global_po_id_;
END Get_Global_Po_Id;
   
@UncheckedAccess
FUNCTION Is_Modified (
   po_id_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   info_ VARCHAR2(2000);   
   CURSOR get_modified IS
      SELECT * FROM
      (SELECT sec_object
      FROM pres_object_security_tab p
      WHERE po_id = po_id_      
         MINUS 
      SELECT sec_object
      FROM pres_object_sec_change_tab p
      WHERE po_id = po_id_)
      UNION ALL
      (
      SELECT to_po_id
      FROM pres_object_dependency_tab p
      WHERE from_po_id = po_id_
         MINUS
      SELECT to_po_id
      FROM pres_object_dep_change_tab p
      WHERE from_po_id = po_id_);
BEGIN
   
   OPEN  get_modified;
   FETCH get_modified INTO info_;
   CLOSE get_modified;
   IF (info_ IS NOT NULL) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Modified;


PROCEDURE Test_Available (
   result_ OUT VARCHAR2,
   po_id_  IN VARCHAR2 )
IS
BEGIN
   Security_SYS.Is_Pres_Object_Available_(result_, po_id_);
END Test_Available;


PROCEDURE Reset_Change_Repository (
   po_id_      IN VARCHAR2 DEFAULT '%',
   module_     IN VARCHAR2 DEFAULT '%')
IS
   CURSOR get_po_id IS
   SELECT po_id
   FROM   pres_object_tab
   WHERE  po_id  LIKE po_id_
   AND    module LIKE module_;
BEGIN
   FOR rec IN get_po_id LOOP
      -- Delete details
      DELETE FROM pres_object_dep_change_tab WHERE from_po_id = rec.po_id;
         INSERT INTO pres_object_dep_change_tab (from_po_id, to_po_id, info_type, pres_object_dep_type, rowversion)
            SELECT from_po_id, to_po_id, info_type, pres_object_dep_type, rowversion
            FROM  pres_object_dependency_tab WHERE from_po_id = rec.po_id;

      DELETE FROM pres_object_sec_change_tab WHERE po_id = rec.po_id;
         INSERT INTO pres_object_sec_change_tab (po_id, sec_object, pres_object_sec_sub_type, sec_object_type, info_type, rowversion)
            SELECT po_id, sec_object, pres_object_sec_sub_type, sec_object_type, info_type, rowversion
            FROM  pres_object_security_tab WHERE po_id = rec.po_id;

      -- Delete masters (leave those that have db-objects still connected)
      DELETE FROM pres_object_change_tab WHERE po_id = rec.po_id;
         INSERT INTO pres_object_change_tab (po_id, pres_object_type, module, info_type, rowversion)
            SELECT po_id, pres_object_type, module, info_type, rowversion
            FROM  pres_object_tab WHERE po_id = rec.po_id;
      --
      -- Set change_date to NULL
      --
      UPDATE pres_object_tab
      SET    change_date = NULL
      WHERE  po_id = rec.po_id;
      --
   END LOOP;
END Reset_Change_Repository;


PROCEDURE Reset_Repository (
   module_    IN VARCHAR2,
   info_type_ IN VARCHAR2 DEFAULT NULL,
   layer_id_  IN VARCHAR2 DEFAULT 'Core' )
IS
--
BEGIN
   -------------------------
   -- Reset build storage
   -------------------------
   -- Delete details
      DELETE FROM pres_object_security_build_tab
      WHERE po_id IN (SELECT po_id
                      FROM pres_object_build_tab
                      WHERE module like module_
--                      AND info_type like nvl(info_type_, '%')
                      AND layer_id like layer_id_);

      -- Delete details
      DELETE FROM pres_object_dep_build_tab
      WHERE from_po_id IN (SELECT po_id
                           FROM pres_object_build_tab
                           WHERE module like module_
                           AND info_type like nvl(info_type_, '%')
                           AND layer_id like layer_id_);

      -- Delete masters
      DELETE FROM pres_object_build_tab
          WHERE module like module_
--          AND info_type like nvl(info_type_, '%')
          AND layer_id like layer_id_;

   -------------------------
   -- Reset live storage
   -------------------------

      -- Delete repository tables in correct order
      DELETE FROM pres_object_security_tab
         WHERE po_id IN (SELECT po_id
                         FROM pres_object_tab
                         WHERE module like module_
                         AND info_type like nvl(info_type_, '%')
                         AND layer_id like layer_id_)
         AND info_type like info_type_;

      DELETE FROM pres_object_dependency_tab
         WHERE from_po_id IN (SELECT po_id
                              FROM pres_object_tab
                              WHERE module like module_
                              AND info_type like nvl(info_type_, '%')
                              AND layer_id like layer_id_)
         AND info_type like info_type_
         AND pres_object_dep_type NOT IN ('2', '12');
         
      DELETE FROM pres_object_dependency_tab
         WHERE to_po_id IN (SELECT po_id
                            FROM pres_object_tab
                            WHERE module like module_
                            AND info_type like nvl(info_type_, '%')
                            AND layer_id like layer_id_)
         AND info_type like info_type_
         AND pres_object_dep_type IN ('2', '12');

      DELETE FROM pres_object_description_tab
         WHERE  po_id IN (SELECT po_id
                         FROM pres_object_tab
                         WHERE module like module_
                         AND info_type like nvl(info_type_, '%')
                         AND layer_id like layer_id_);
 
      DELETE FROM pres_object_tab
         WHERE po_id IN (SELECT po_id
                         FROM pres_object_tab
                         WHERE module like module_
                         AND info_type like nvl(info_type_, '%')
                         AND layer_id like layer_id_);

END Reset_Repository;

-- Remove_Pres_Object
--    Removes the repository information for a presentation object.
--    Considers the info type of the the objects to remove.
--    Possible values for info type are 'Manual', 'Auto', 'Modified' or '%'
--    (all types). Not stating info_type is the same as all types.
PROCEDURE Remove_Pres_Object (
   po_id_     IN VARCHAR2,
   info_type_ IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   IF info_type_ IS NULL OR info_type_ = '%' THEN
      DELETE FROM pres_object_description_tab
         WHERE po_id = po_id_;
      -- Leave dynamic dependencies
      DELETE FROM pres_object_dependency_tab
         WHERE from_po_id = po_id_
         AND   pres_object_dep_type NOT IN ('2', '12');
      DELETE FROM pres_object_dependency_tab
         WHERE to_po_id = po_id_
         AND   pres_object_dep_type IN ('2', '12');
      DELETE FROM pres_object_security_tab
         WHERE po_id = po_id_;
      DELETE FROM pres_object_tab
         WHERE po_id = po_id_;
   ELSE
      DELETE FROM pres_object_description_tab
         WHERE po_id IN (SELECT pot.po_id
                         FROM pres_object_tab pot
                         WHERE pot.po_id = po_id_
                         AND   info_type = info_type_);
      -- Leave dynamic dependencies
      DELETE FROM pres_object_dependency_tab
         WHERE from_po_id = po_id_
         AND   info_type  = info_type_
         AND   pres_object_dep_type NOT IN ('2', '12');
      DELETE FROM pres_object_dependency_tab
         WHERE to_po_id = po_id_
         AND   info_type  = info_type_;
      DELETE FROM pres_object_security_tab
         WHERE po_id     = po_id_
         AND   info_type = info_type_;
      DELETE FROM pres_object_tab
         WHERE po_id     = po_id_
         AND   info_type = info_type_;
   END IF;
   
   DELETE FROM pres_object_grant_tab
      WHERE po_id = po_id_;
END Remove_Pres_Object;

PROCEDURE Remove_Pres_Obj_Sec (
   po_id_      IN VARCHAR2,
   sec_object_ IN VARCHAR2 )
IS
BEGIN
      DELETE FROM pres_object_security_tab
         WHERE po_id = po_id_ 
         AND   sec_object = sec_object_;
END Remove_Pres_Obj_Sec;

FUNCTION Transactional_Methods_Granted (
   po_id_ IN VARCHAR2, 
   role_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_sec_object IS 
      SELECT sec_object, force_read_only_db
        FROM pres_object_security_avail s
       WHERE s.po_id = po_id_
         AND s.sec_object_type_db = 'METHOD';
BEGIN
   FOR rec_ IN  get_sec_object LOOP
      IF (NOT (rec_.force_read_only_db = 'TRUE' OR Get_Sec_Object_Method_Type(rec_.sec_object) = 'P') AND Is_Object_Available(rec_.sec_object,role_) = 'TRUE') THEN
         RETURN 'TRUE';
      END IF; 
   END LOOP;
   RETURN 'FALSE';
END Transactional_Methods_Granted;


PROCEDURE Get_Granted_Modules (
   module_list_     OUT VARCHAR2,
   role_            IN VARCHAR2,
   grant_status_    IN VARCHAR2 DEFAULT 'GRANTED_OR_PARTIALLY_GRANTED')
IS

   CURSOR get_full_granted_modules(role_ IN VARCHAR2) IS
        SELECT distinct(module) FROM pres_object
        MINUS
        SELECT distinct(module) FROM pres_object p
         WHERE Pres_Object_Util_Api.Get_Grant_Info(p.po_id,role_) <> 'GRANTED';

   CURSOR get_granted_modules(role_ IN VARCHAR2) IS
      SELECT distinct(module) FROM pres_object
      MINUS
      SELECT distinct(module) FROM pres_object p
        WHERE p.po_id not in (SELECT g.po_id from pres_object_grant g
                    WHERE g.role = role_);

BEGIN
   IF grant_status_ = 'GRANTED' THEN
        FOR rec_ IN get_full_granted_modules(role_) LOOP
           IF (module_list_ IS NULL) THEN
              module_list_ := rec_.module;
           ELSE
              module_list_ := module_list_ || ';' || rec_.module;
           END IF;
        END LOOP;
   ELSE
        FOR rec_ IN get_granted_modules(role_) LOOP
           IF (module_list_ IS NULL) THEN
              module_list_ := rec_.module;
           ELSE
              module_list_ := module_list_ || ';' || rec_.module;
           END IF;
        END LOOP;
   END IF;
END Get_Granted_Modules;


--See Upgrade_Roles for method description 
PROCEDURE Upgrade_Role  (
   role_                     IN VARCHAR2,
   upgrade_option_           IN VARCHAR2 DEFAULT 'GRANT_NEW_DB_OBJECTS', 
   grant_new_dependencies_   IN VARCHAR2 DEFAULT 'FALSE',
   grant_mode_               IN VARCHAR2 DEFAULT 'DYNAMIC', 
   raise_error_              IN VARCHAR2 DEFAULT 'FALSE',
   log_                      IN VARCHAR2 DEFAULT 'APP_TRACE',
   run_as_test_              IN VARCHAR2 DEFAULT 'FALSE')
IS
  
   po_recursive_  VARCHAR2(5) := grant_new_dependencies_;
   sep_ CLOB := Client_SYS.text_separator_; 
   previous_po_ VARCHAR2(200) := '_dummy_'; 
   grant_query_ BOOLEAN := TRUE;
   only_grant_new_dep_  VARCHAR2(5);
   module_              VARCHAR2(30);
   po_id_               VARCHAR2(100);
   
-- Get all granted pos for this role or those granted to the role that has been modified according to change log
CURSOR get_pres_objects(role_ IN VARCHAR2,po_scope_ IN VARCHAR2) IS
       SELECT p.po_id, p.module, d.description, m.name from pres_object_tab p, pres_object_description d, module_tab m
       WHERE p.po_id IN (SELECT po_id from pres_object_grant_tab where role = role_)
       AND (po_scope_ = 'REGRANT_ALL' OR Is_Modified(p.po_id) = 'TRUE')
       AND p.po_id = d.po_id
       AND d.lang_code='en'
       AND m.module = p.module
       ORDER BY m.name;
   
   
CURSOR get_sec_objects(role_ IN VARCHAR2) IS
       SELECT p.po_id, p.sec_object_type_db, p.sec_object, p.force_read_only_db, t.module, d.description, m.name from pres_object_security_avail p, pres_object_tab t,pres_object_description d, module_tab m
       WHERE p.po_id IN (SELECT po_id from pres_object_grant_tab where role = role_)
       AND NOT EXISTS (SELECT 1 FROM pres_object_sec_change_tab o WHERE o.po_id = p.po_id AND o.sec_object = p.sec_object)
       AND p.po_id = t.po_id
       AND p.po_id = d.po_id
       AND d.lang_code='en'
       AND m.module = t.module
       ORDER BY m.name,d.description; 
   
CURSOR get_dependency_pres_objects(role_ IN VARCHAR2) IS
      SELECT p.from_po_id, p.to_po_id , t.module, d.description, m.name from pres_object_dependency_tab p, pres_object_tab t, pres_object_description d, module_tab m
      WHERE p.from_po_id IN (SELECT po_id from pres_object_grant_tab where role = role_)
      AND NOT EXISTS (SELECT 1 FROM pres_object_change_tab o WHERE o.po_id = p.to_po_id)
      AND p.pres_object_dep_type NOT IN (7,8)
      AND p.from_po_id = t.po_id
      AND p.from_po_id = d.po_id
      AND d.lang_code='en'
      AND m.module = t.module
      ORDER BY m.name,d.description; 
         
       
BEGIN
   IF (upgrade_option_ <> 'REGRANT_MODIFIED_PO' AND upgrade_option_ <> 'REGRANT_ALL' AND upgrade_option_ <> 'GRANT_NEW_DB_OBJECTS') THEN
      Error_SYS.Appl_General(lu_name_, 'UPGRADE_ROLE_OPTION: upgrade_option must be set to GRANT_NEW_DB_OBJECTS, REGRANT_MODIFIED_PO or REGRANT_ALL');
   END IF;
   
   IF (grant_mode_ <> 'DYNAMIC' AND grant_mode_ <> 'QUERY' AND grant_mode_ <> 'FULL') THEN
      Error_SYS.Appl_General(lu_name_, 'GRANT_MODE_OPTION: grant mode must be set to DYNAMIC, QUERY or FULL');
   END IF;
   
   
   -- Find presentation objects granted to the role all or only where the presentation object has been modified (since last time change information for the presentation object was reset.)
   IF (upgrade_option_ = 'REGRANT_MODIFIED_PO' OR upgrade_option_ = 'REGRANT_ALL') THEN
      
      IF (upgrade_option_ = 'REGRANT_MODIFIED_PO') THEN
         -- For upgrade option REGRANT_MODIFIED_PO , if recursive pres object granting, we only grant new dependencies
         only_grant_new_dep_ := 'TRUE';
      ELSE
         -- For upgrade option REGRANT_ALL , if recursive pres object granting, we grant all dependencies
         only_grant_new_dep_ := 'FALSE';
      END IF;
      
      FOR po_ IN get_pres_objects(role_,upgrade_option_) LOOP
         sep_ := Client_SYS.text_separator_;  
         IF log_ = 'APP_LOG' THEN
            IF module_ IS NULL OR module_ <> po_.module THEN
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'',TRUE);
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,NVL(po_.name,po_.module),TRUE);
            END IF;
         END IF;
         --Dynamic means that if role already contains grants for this presentation object to transaction methods then do a full grant for this presentation object otherwise do a grant query since this would most likely be the wanted setup
         --grant_new_dependencies_ option will also grant non granted pres objects if they are new and added as children to already granted presentation objects
         IF ((grant_mode_ = 'DYNAMIC' AND Transactional_Methods_Granted(po_.po_id, role_) = 'TRUE') OR grant_mode_ = 'FULL')  THEN
            IF log_ = 'APP_TRACE' THEN 
               Log_SYS.App_Trace(Log_SYS.info_, 'Grant Full' || po_.po_id);
            ELSIF log_ = 'APP_LOG' THEN                  
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_PO:  Grant Full :P1',Fnd_Session_API.Get_Language, '"' || po_.description || '"' || ' (' || po_.po_id) || ')' ,TRUE);
            END IF;
            IF (run_as_test_ = 'FALSE') THEN
               Grant_Pres_Object___(sep_,po_.po_id, role_, 'FULL', po_recursive_,'TRUE', raise_error_, only_grant_new_dep_);
            END IF;
         ELSE                       
            IF log_ = 'APP_TRACE' THEN 
              Log_SYS.App_Trace(Log_SYS.info_, 'Grant Query ' || po_.po_id);
            ELSIF log_ = 'APP_LOG' THEN
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_QUERY_PO:  Grant Query :P1',Fnd_Session_API.Get_Language, '"' || po_.description || '"' || ' (' || po_.po_id) || ')' ,TRUE);
            END IF;
            IF (run_as_test_ = 'FALSE') THEN
               Grant_Pres_Object___(sep_,po_.po_id, role_, 'QUERY', po_recursive_,'TRUE', raise_error_, only_grant_new_dep_);
            END IF;
         END IF;
         module_ := po_.module; -- used for log output
      END LOOP; 
   
   ELSE
      -- option GRANT_NEW_DB_OBJECTS
      -- Find new methods and views for presentation objects granted to the role or only where the presentation object has been modified (since last time change information for the presentation object was reset.)
      FOR rec_ IN get_sec_objects(role_) LOOP
         IF log_ = 'APP_LOG' THEN
            IF module_ IS NULL OR module_ <> rec_.module THEN
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'',TRUE);
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,NVL(rec_.name,rec_.module),TRUE);
            END IF;
             IF po_id_ IS NULL OR po_id_ <> rec_.po_id THEN           
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,rec_.description,TRUE);
            END IF;
         END IF;
         IF (rec_.sec_object_type_db = 'VIEW') THEN              
               IF log_ = 'APP_TRACE' THEN 
                   Log_SYS.App_Trace(Log_SYS.info_, rec_.po_id ||' Grant View: ' || rec_.sec_object);
               ELSIF log_ = 'APP_LOG' THEN
                  Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_VIEW: Grant View:             ":P1"', Fnd_Session_API.Get_Language, rec_.sec_object),TRUE,1);
               END IF;
         ELSE   
            IF rec_.force_read_only_db = 'TRUE' OR Get_Sec_Object_Method_Type(rec_.sec_object) = 'P' THEN
               --Readonly method               
               IF log_ = 'APP_TRACE' THEN 
                   Log_SYS.App_Trace(Log_SYS.info_, rec_.po_id ||' Grant Read Only Method: ' || rec_.sec_object);
               ELSIF log_ = 'APP_LOG' THEN
                  Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_RO_METHOD: Grant Read Only Method: ":P1"',Fnd_Session_API.Get_Language, rec_.sec_object),TRUE,1);
               END IF;
            ELSE
               --Transaction method, check if it should be granted
                IF (rec_.po_id <> previous_po_) THEN
                  grant_query_ := grant_mode_ = 'QUERY' OR (grant_mode_ = 'DYNAMIC' AND Transactional_Methods_Granted(rec_.po_id, role_) = 'FALSE');
                  previous_po_ := rec_.po_id;
                END IF;
                IF NOT grant_query_ THEN                  
                  IF log_ = 'APP_TRACE' THEN 
                    Log_SYS.App_Trace(Log_SYS.info_, rec_.po_id ||' Grant Method: ' || rec_.sec_object);
                  ELSIF log_ = 'APP_LOG' THEN
                     Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_METHOD: Grant Method:           ":P1"',Fnd_Session_API.Get_Language, rec_.sec_object),TRUE,1);
                  END IF;
                END IF;             
            END IF;
         END IF;
         module_ := rec_.module; -- used for log output
         po_id_  := rec_.po_id;     
      END LOOP;  
      module_ := NULL;
      
      IF grant_new_dependencies_ = 'TRUE' THEN         
         FOR rec_ IN get_dependency_pres_objects(role_) LOOP
            IF log_ = 'APP_LOG' AND module_ IS NULL THEN
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'',TRUE);
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'',TRUE);
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_NEW_DEP: Grant of new child windows for the main Presentation Objects',Fnd_Session_API.Get_Language),TRUE);
               Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'------------------------------------------------------------',TRUE);
            END IF;
            IF log_ = 'APP_LOG' THEN
               IF module_ IS NULL OR module_ <> rec_.module THEN
                  Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'',TRUE);
                  Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,NVL(rec_.name,rec_.module),TRUE);
               END IF;
            END IF;
            sep_ := Client_SYS.text_separator_;
            --Dynamic means that if role already contains grants for this presentation object to transaction methods then do a full grant for this presentation object otherwise do a grant query since this would most likely be the wanted setup
            IF ((grant_mode_ = 'DYNAMIC' AND Transactional_Methods_Granted(rec_.from_po_id, role_) = 'TRUE') OR grant_mode_ = 'FULL')  THEN                 
                 IF log_ = 'APP_TRACE' THEN 
                     Log_SYS.App_Trace(Log_SYS.info_, 'Grant Full ' || rec_.to_po_id);    
                  ELSIF log_ = 'APP_LOG' THEN
                     Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_PO:  Grant Full :P1',Fnd_Session_API.Get_Language,  '"' || rec_.description || '"' || ' (' || rec_.to_po_id || ')' ),TRUE);
                  END IF;
                  IF (run_as_test_ = 'FALSE') THEN
                     Grant_Pres_Object___(sep_,rec_.to_po_id, role_, 'FULL', po_recursive_,'TRUE', raise_error_, grant_new_dependencies_);
                  END IF;
            ELSE                            
               IF log_ = 'APP_TRACE' THEN 
                  Log_SYS.App_Trace(Log_SYS.info_, 'Grant Query ' || rec_.to_po_id);
               ELSIF log_ = 'APP_LOG' THEN
                  Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'GRANT_QUERY_PO:  Grant Query :P1',Fnd_Session_API.Get_Language,   '"' || rec_.description || '"' || ' (' || rec_.to_po_id || ')' ),TRUE);
               END IF;
               IF (run_as_test_ = 'FALSE') THEN
                  Grant_Pres_Object___(sep_,rec_.to_po_id, role_, 'QUERY', po_recursive_,'TRUE', raise_error_, grant_new_dependencies_);
               END IF;
            END IF;
            module_ := rec_.module; -- used for log output
         END LOOP;
      END IF;
   END IF;

END Upgrade_Role;

-- Upgrade_Roles
-- Re-grants already granted presentation objects for the role. 
-- This applies to presentation objects that has new database objects or dependency presentation objects since last time the presentation object was installed.
--
--
-- rolelist_ the name of one role or a comma separated list of roles.
--
-- upgrade_option_ can be set to GRANT_NEW_DB_OBJECTS, REGRANT_MODIFIED_PO or REGRANT_ALL
--
-- GRANT_NEW_DB_OBJECTS:   Only database objects (methods and views) that are added as new dependencies to the presentation object are granted 
-- REGRANT_MODIFIED_PO:    The presentation objects that have new dependencies (methods and views) are re-granted. This means it also grants any existing dependency (that is not new but still not granted)
-- REGRANT_ALL:            All presentation objects for the role are re-granted.  
-- Note that for all options it will still grant query or normal grant depending on the  if no non-query methods are granted for the presentation object
--
-- grant_new_dependencies_ set to 'TRUE' will recursively grant new presentation objects that are added as dependency to a granted presentation object.
-- Such as a new dialog added to an existing window. For option REGRANT_ALL, this means that all dependencies wil be granted.
--
-- grant_mode_ can be set to DYNAMIC, QUERY or FULL
--
-- DYNAMIC:    Presentation objects are granted query access if no non-query methods are granted otherwise the presentation object is granted normally.
-- QUERY:      No non-query methods are granted.
-- FULL:       Both query and non-query methods are granted.
--
-- raise_error_ can be set to TRUE or FALSE. If value is 'TRUE' the grant operation will stop the process incase any of the grant operations encounters an error , like for example the database view does not exist
-- 
PROCEDURE Upgrade_Roles  (
   rolelist_                 IN VARCHAR2,
   upgrade_option_           IN VARCHAR2 DEFAULT 'GRANT_NEW_DB_OBJECTS',
   grant_new_dependencies_   IN VARCHAR2 DEFAULT 'FALSE',
   grant_mode_               IN VARCHAR2 DEFAULT 'DYNAMIC', 
   raise_error_              IN VARCHAR2 DEFAULT 'FALSE' )
IS
   count_ NUMBER;
   role_ Utility_SYS.STRING_TABLE;
BEGIN
   Utility_SYS.Tokenize (rolelist_,',',role_,count_);
   FOR i IN 1 .. count_ LOOP
      Log_SYS.App_Trace(Log_SYS.info_, 'Updating role ' || role_(i));
      Upgrade_Role(role_(i),upgrade_option_,grant_new_dependencies_,grant_mode_,raise_error_);         
   END LOOP;
   Security_SYS.Refresh_Active_List__(1);
END Upgrade_Roles;

PROCEDURE Upgrade_Roles_Log  ( 
   upgrade_log_clob_         OUT CLOB,
   rolelist_                 IN VARCHAR2,
   upgrade_option_           IN VARCHAR2 DEFAULT 'GRANT_NEW_DB_OBJECTS',
   grant_new_dependencies_   IN VARCHAR2 DEFAULT 'FALSE',
   grant_mode_               IN VARCHAR2 DEFAULT 'DYNAMIC', 
   raise_error_              IN VARCHAR2 DEFAULT 'FALSE',
   run_as_test_              IN VARCHAR2 DEFAULT 'FALSE')
IS
   count_ NUMBER;
   role_ Utility_SYS.STRING_TABLE;
   
BEGIN
   Utility_SYS.Tokenize (rolelist_,',',role_,count_);
   IF run_as_test_= 'TRUE' THEN
      Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'*********************************************************************');
      Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'UPGRADE_ROLES_TEST: ***Note: This is a test run. No Permission sets have been updated.',Fnd_Session_API.Get_Language,TO_CHAR(sysdate,Client_SYS.Date_Format_)));
      Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'*********************************************************************');
   END IF;
   Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'UPGRADE_ROLES: Update Permission Sets :P1',Fnd_Session_API.Get_Language,TO_CHAR(sysdate,Client_SYS.Date_Format_))); 
   FOR i IN 1 .. count_ LOOP
      Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'',TRUE);
      Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO, Language_SYS.Translate_Constant(lu_name_,'UPGRADE_ROLE: Update Permission Set ":P1"',Fnd_Session_API.Get_Language, role_(i)),TRUE);
      Application_Logger_API.Log(LOG_PERMISSIONSET_UPGRADE, Application_Logger_API.CATEGORY_INFO,'=====================================================',TRUE);
      Upgrade_Role(role_(i),upgrade_option_,grant_new_dependencies_,grant_mode_,raise_error_,'APP_LOG',run_as_test_);
   END LOOP;
   IF (run_as_test_ = 'FALSE') THEN
      Security_SYS.Refresh_Active_List__(1);
   END IF;
   dbms_lob.Createtemporary(upgrade_log_clob_, TRUE);
   Application_Logger_API.Get_All(upgrade_log_clob_, LOG_PERMISSIONSET_UPGRADE, FALSE, FALSE, FALSE);  
END Upgrade_Roles_Log;

PROCEDURE Upgrade_Roles__  (
  attr_  IN VARCHAR2)
IS 
   count_                     NUMBER;
   role_                      Utility_SYS.STRING_TABLE;
   rolelist_                  VARCHAR2(32000);
   upgrade_option_            VARCHAR2(50);
   grant_new_dependencies_    VARCHAR2(5);
   grant_mode_                VARCHAR2(50);
   raise_error_               VARCHAR2(5);
   
BEGIN
   rolelist_                  := Client_SYS.Get_Item_Value('ROLE_LIST', attr_);
   upgrade_option_            := Client_SYS.Get_Item_Value('UPGRADE_OPTION', attr_);
   grant_new_dependencies_    := Client_SYS.Get_Item_Value('GRANT_NEW_DEPENDENCIES', attr_);
   grant_mode_                := Client_SYS.Get_Item_Value('GRANT_MODE', attr_);
   raise_error_               := Client_SYS.Get_Item_Value('RAISE_ERROR', attr_);
   Utility_SYS.Tokenize (rolelist_,',',role_,count_);
   Transaction_SYS.Update_Total_Work(Transaction_SYS.Get_Current_Job_Id, count_);
   FOR i IN 1 .. count_ LOOP
      Transaction_SYS.Set_Progress_Info('Updating Permission Set ' || role_(i),i);
      Transaction_SYS.Set_Status_Info('Updating Permission Set ' || role_(i),'INFO');
      Upgrade_Role(role_(i),upgrade_option_,grant_new_dependencies_,grant_mode_,raise_error_);         
   END LOOP;
   Security_SYS.Refresh_Active_List__(1);
   Transaction_SYS.Set_Progress_Info( count_ || ' Permission Sets Updated. Security Cache is Refreshed');
  
END Upgrade_Roles__;


PROCEDURE Upgrade_Roles_Batch (
   job_id_                   OUT NUMBER,             
   rolelist_                 IN VARCHAR2,
   upgrade_option_           IN VARCHAR2 DEFAULT 'GRANT_NEW_DB_OBJECTS',
   grant_new_dependencies_   IN VARCHAR2 DEFAULT 'FALSE',
   grant_mode_               IN VARCHAR2 DEFAULT 'DYNAMIC', 
   raise_error_              IN VARCHAR2 DEFAULT 'FALSE',
   notify_user_              IN VARCHAR2 DEFAULT 'TRUE' )
IS
   attr_  VARCHAR2(32000);
BEGIN
   Client_SYS.Clear_Attr(attr_);
   Client_SYS.Add_To_Attr('ROLE_LIST', rolelist_, attr_);
   Client_SYS.Add_To_Attr('UPGRADE_OPTION', upgrade_option_, attr_);
   Client_SYS.Add_To_Attr('GRANT_NEW_DEPENDENCIES', grant_new_dependencies_, attr_);
   Client_SYS.Add_To_Attr('GRANT_MODE', grant_mode_, attr_);
   Client_SYS.Add_To_Attr('RAISE_ERROR', raise_error_, attr_);
   Transaction_SYS.Deferred_Call(job_id_,'Pres_Object_Util_API.Upgrade_Roles__',Argument_Type_API.DB_ATTRIBUTE_STRING,attr_,'Update Permission Sets',sysdate,'FALSE',NULL,NULL,notify_user_,NULL); 
   --Transaction_SYS.Deferred_Call(id_, procedure_name_, argument_type_db_, arguments_, description_, posted_date_, lang_indep_, queue_id_, total_work_, stream_msg_on_completion_, stream_notes_);
END Upgrade_Roles_Batch;
