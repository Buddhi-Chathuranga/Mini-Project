-----------------------------------------------------------------------------
--
--  Logical unit: Module
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  951024  DAJO    Base Table to Logical Unit Generator 1.0
--  951113  ERFO    Included in IFS/Server 1.1.1
--  951114  ERFO    Added methods Get_Description.
--  960304  ERFO    Added module concept (Idea #432).
--  960325  ERFO    Added method Get_Doc_Object_Description.
--  960415  ERFO    Added method Get_Module_Info (Idea #490).
--  970414  ERFO    Generated from IFS/Design for release 2.0.0.
--  981103  ERFO    Added method Create_And_Set_Version (ToDo #2853).
--  990218  ERFO    Added column REG_DATE for timestamp (ToDo #3138).
--  010403  STDA    Modified procedure Set_Version. Added name_.
--                  Added logic in Create_And_Set_Version for Set_Version.
--  010827  ROOD    Added column patch_version and method Set_Patch_Version.
--                  Updated template (ToDo#4020).
--  020115  ROOD    Added methods Get_Version and Get_Patch_Version (ToDo#4073).
--  020128  ROOD    Changed order between two methods with same name (Get_Description)
--                  to avoid compilation error (Oracle-bug) in cursor using the function.
--  020218  ROOD    Added version and patch_version in method Get (ToDo#4073).
--  020626  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  041227  HAAR    Added Pre_Register method.
--                  Added Patch_Version_ as argument to Create_And_Set_Version (F1PR480).
--  050404  UTGU    Modified method Set_Version so that the version is not overwritten by X.X.X
--                  if the old version is not X.X.X (BUG#50500).
--  051118  HAAR    Fixed objversion_ in Update___ (Call#128976).
--  061113  HAAR    Added attribute UpgradeFromVersion (Bug#61809).
--  071207  SUMALK  Added the functionality to Translate Component Name.(Bug#69325).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK  Merged Rose Documentation.
--  111124  MaBo    Added clear method
--  120705  MaBose  Conditional compiliation improvements - Bug 103910
--  120919  UsRaLK  Removed the size restriction in method [Get_Name] (Bug#105318).
--  121024  Mabose  Do not clear patch version and reg date if deploying a delivery - bug 106199
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

field_separator_  CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
record_separator_ CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;

-----------------------------------------------------------------------------
-------------------- LU SPECIFIC IMPLEMENTATION METHOD DECLARATIONS ---------
-----------------------------------------------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT module_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.timestamp IS NULL THEN
      newrec_.timestamp := SYSDATE;
      Client_SYS.Add_To_Attr('TIMESTAMP', newrec_.timestamp, attr_);
   END IF;
   IF newrec_.active IS NULL THEN
      newrec_.active := 'TRUE';
      Client_SYS.Add_To_Attr('ACTIVE', newrec_.active, attr_);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;


 @Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     module_tab%ROWTYPE,
   newrec_     IN OUT module_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF oldrec_.timestamp = newrec_.timestamp THEN
      newrec_.timestamp := SYSDATE;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_And_Set_Version (
   module_      IN VARCHAR2,
   name_        IN VARCHAR2,
   version_     IN VARCHAR2,
   description_ IN VARCHAR2,
   patch_version_ IN VARCHAR2 DEFAULT NULL )
IS
   objid_      MODULE.objid%TYPE;
   objversion_ MODULE.objversion%TYPE;
   newrec_     MODULE_TAB%ROWTYPE;
   attr_       VARCHAR2(4000);
BEGIN
   IF Check_Exist___(module_) THEN
      Set_Version(module_, version_, description_, name_);
      IF (patch_version_ IS NOT NULL) THEN
         Set_Patch_Version(module_, version_, patch_version_);
      END IF;
   ELSE
      -- Create the record
      newrec_.module := module_;
      newrec_.name := name_;
      newrec_.version := version_;
      newrec_.version_desc := description_;
      newrec_.reg_date := SYSDATE;
      newrec_.timestamp := SYSDATE;
      newrec_.patch_version := patch_version_;
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
--   Installation_SYS.Create_Component_Package(TRUE, module_);
END Create_And_Set_Version;

@UncheckedAccess
PROCEDURE Enumerate (
   list_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR enumerate IS
      SELECT module
      FROM   module;
BEGIN
   FOR module IN enumerate LOOP
      temp_ := temp_ || module.module || Client_SYS.field_separator_;
   END LOOP;
   list_ := temp_;
END Enumerate;

PROCEDURE Enumerate_Installed_Modules (
   list_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR enumerate_installed_modules IS
      SELECT module
      FROM   module 
      WHERE  version NOT IN ('?', '*')
      AND    version IS NOT NULL;
BEGIN
   FOR module IN enumerate_installed_modules LOOP
      temp_ := temp_ || module.module || Client_SYS.field_separator_;
   END LOOP;
   list_ := temp_;
END Enumerate_Installed_Modules;

@UncheckedAccess
PROCEDURE Get_Description (
   description_ OUT VARCHAR2,
   module_      IN  VARCHAR2 )
IS
BEGIN
   -- HAETSE: Neeed to add package to get correct code generation.
   description_ := Module_API.Get_Description(module_);
END Get_Description;

PROCEDURE Get_Module_Info (
   info_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR get_info IS
      SELECT module, name, version, version_desc, patch_version
      FROM   MODULE_TAB
      WHERE  version IS NOT NULL;
BEGIN
   FOR rec IN get_info LOOP
      IF rec.patch_version IS NOT NULL THEN
         temp_ := temp_||rec.module||field_separator_||rec.name||field_separator_||
                  rec.version||'-'||rec.patch_version||field_separator_||rec.version_desc||record_separator_;
      ELSE
         temp_ := temp_||rec.module||field_separator_||rec.name||field_separator_||
                  rec.version||field_separator_||rec.version_desc||record_separator_;
      END IF;
   END LOOP;
   info_ := temp_;
END Get_Module_Info;


@UncheckedAccess
FUNCTION Get_Doc_Object_Description (
   module_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN(Get_Description(module_));
END Get_Doc_Object_Description;



PROCEDURE Pre_Register (
   module_      IN VARCHAR2,
   name_        IN VARCHAR2 )
IS
   objid_      MODULE.objid%TYPE;
   objversion_ MODULE.objversion%TYPE;
   newrec_     MODULE_TAB%ROWTYPE;
   attr_       VARCHAR2(4000);
BEGIN
   IF Check_Exist___(module_) THEN
      -- Do nothing, since it will be updated later
      NULL;
   ELSE
      -- Create the record
      newrec_.module := module_;
      newrec_.name := name_;
      newrec_.version := '?';
      newrec_.timestamp := SYSDATE;
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Pre_Register;

PROCEDURE Set_Version (
   module_      IN VARCHAR2,
   version_     IN VARCHAR2,
   description_ IN VARCHAR2,
   name_        IN VARCHAR2 DEFAULT NULL )
IS
   objid_      MODULE.objid%TYPE;
   objversion_ MODULE.objversion%TYPE;
   newrec_     MODULE_TAB%ROWTYPE;
   oldrec_     MODULE_TAB%ROWTYPE;
   attr_       VARCHAR2(4000);
   indrec_     Indicator_Rec;
BEGIN
   -- Check existance of record, throws exception if record does not exist
   Exist(module_);
   -- Lock and update the record
   oldrec_ := Lock_By_Keys___(module_);
   newrec_ := oldrec_;
   IF (nvl(upper(version_),' ') != 'X.X.X' OR nvl(upper(oldrec_.version),'X.X.X') = 'X.X.X') THEN
      newrec_.version       := version_;
      newrec_.version_desc  := description_;
      IF (newrec_.version != oldrec_.version OR version_ IS NULL) THEN
         newrec_.reg_date       := SYSDATE;
         newrec_.patch_version := NULL;
         IF oldrec_.version NOT IN ('*', '?') AND version_ IS NOT NULL THEN
            newrec_.upgrade_from_version := oldrec_.version;
         END IF;
      END IF;
   END IF;
   IF NOT (upper(name_) = upper(module_) OR name_ IS NULL) THEN
      -- Do not update the name if it is the same as module or if it is empty.
      newrec_.name := name_;
   END IF;
   newrec_.timestamp      := SYSDATE;   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- Update by keys
END Set_Version;


-- Set_Patch_Version
--    Sets the patch version for a module.
PROCEDURE Set_Patch_Version (
   module_        IN VARCHAR2,
   version_       IN VARCHAR2,
   patch_version_ IN VARCHAR2 )
IS
   objid_      MODULE.objid%TYPE;
   oldrec_     MODULE_TAB%ROWTYPE;
   newrec_     MODULE_TAB%ROWTYPE;
   attr_       VARCHAR2(4000);
   objversion_ MODULE.objversion%TYPE;
   indrec_     Indicator_Rec;
BEGIN
   IF NOT Check_Exist___(module_) THEN
      Error_SYS.Record_General(lu_name_, 'MODULENOTEXIST: The module [:P1] does not exist. Setting of patch version is not possible!', module_);
   END IF;
   oldrec_ := Lock_By_Keys___(module_);
   newrec_ := oldrec_;
   IF oldrec_.version != version_ OR version_ IS NULL THEN
      Error_SYS.Record_General(lu_name_, 'ERRONEOUSVERSION: The version [:P1] is not correct for module [:P2]. Setting of patch version is not possible!', version_, module_);
   END IF;
   newrec_.patch_version := patch_version_;
   IF (newrec_.patch_version != NVL(oldrec_.patch_version, 'X.X')) THEN
      newrec_.reg_date       := SYSDATE;
   END IF;
   newrec_.timestamp         := SYSDATE;   
   Unpack___(newrec_, indrec_, attr_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
END Set_Patch_Version;


@UncheckedAccess
PROCEDURE Clear (
   module_ IN VARCHAR2 )
IS
   CURSOR getrec IS
      SELECT module
      FROM MODULE_TAB
      WHERE module = module_;
   remrec_     MODULE_TAB%ROWTYPE;
BEGIN
   FOR rec IN getrec LOOP
      remrec_ := Lock_By_Keys___(rec.module);
      DELETE
         FROM  module_tab
         WHERE module = rec.module;
   END LOOP;
   Module_Dependency_API.Clear(module_);
   IF Installation_SYS.Get_Installation_Mode THEN
      NULL;
   ELSE
      Installation_SYS.Create_Component_Package(FALSE, module_);
   END IF;
END Clear;

PROCEDURE Reset_Module_Delivery_Flags
IS
BEGIN
   UPDATE module_tab
   SET    included_in_delivery = NULL,
          interface_change = NULL,
          rowversion = SYSDATE
   WHERE  included_in_delivery IS NOT NULL;
END Reset_Module_Delivery_Flags;

FUNCTION Is_Included_In_Delivery (
   module_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF Get_Included_In_Delivery(module_) = 'TRUE' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Included_In_Delivery;

FUNCTION Is_Affected_By_Delivery (
   module_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR check_affected IS
      SELECT 1
      FROM module_tab m, module_dependency_tab md
      WHERE md.module = module_
      AND md.dependency = 'DYNAMIC'
      AND m.module = md.dependent_module
      AND m.interface_change = 'TRUE';

BEGIN
   IF Get_Included_In_Delivery(module_) = 'TRUE' THEN
      RETURN TRUE;
   ELSE
      OPEN check_affected;
      FETCH check_affected INTO dummy_;
      IF check_affected%FOUND THEN
         CLOSE check_affected;
         RETURN TRUE;
      ELSE
         CLOSE check_affected;
         RETURN FALSE;
      END IF;
   END IF;
END Is_Affected_By_Delivery;

FUNCTION List_Active_Components RETURN VARCHAR2
IS
   component_list_ VARCHAR2(4000);
   CURSOR get_all_active_components IS
      SELECT module
      FROM module_tab
      WHERE active = 'TRUE'
      ORDER BY module;
BEGIN
   FOR component_ IN get_all_active_components LOOP
      component_list_ := component_list_ || component_.module || ',';
   END LOOP;
   RETURN rtrim(component_list_, ',');
END List_Active_Components;

FUNCTION Is_Active (
   module_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF Get_Active(module_) = 'TRUE' THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Active;

PROCEDURE Check_Active (
   module_ IN VARCHAR2 )
IS
BEGIN
   IF NOT Installation_SYS.Get_Installation_Mode THEN
      IF Is_Active(module_) = FALSE THEN
         ERROR_SYS.Appl_General(lu_name_, 'NOT_ACTIVE: Component :P1 is not active.', module_);
      END IF;
   END IF;
END Check_Active;

FUNCTION Is_Lu_Active (
   lu_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
        FROM dictionary_sys_tab d, module_tab m
       WHERE lu_name = lu_name_
       AND d.module = m.module
       AND m.active = 'TRUE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN(TRUE);
   END IF;
   CLOSE exist_control;
   RETURN(FALSE);
END Is_Lu_Active;

PROCEDURE Check_Lu_Active (
   lu_name_ IN VARCHAR2 )
IS
BEGIN
   IF NOT Installation_SYS.Get_Installation_Mode THEN   
      IF Is_Lu_Active(lu_name_) = FALSE THEN
         ERROR_SYS.Appl_General(lu_name_, 'LU_NOT_ACTIVE: Lu :P1 is not active.', lu_name_);
      END IF;
   END IF;
END Check_Lu_Active;
