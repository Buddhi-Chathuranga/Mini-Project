-----------------------------------------------------------------------------
--
--  Logical unit: ComponentPatch
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050406  STDAFI  Created.
--  050907  HAAR    Removed SUBSTRB (F1PR408)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

field_separator_  CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;

record_separator_ CONSTANT VARCHAR2(1) := Client_SYS.record_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('DOWNLOAD', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('INSTALLED', SYSDATE, attr_);
   Client_SYS.Add_To_Attr('CPS', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('REDEPLOY', 'FALSE', attr_);
END Prepare_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Is_Component_Version_Active__ (
   component_    IN VARCHAR2,
   version_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_control IS
      SELECT 1
      FROM  module
      WHERE module    = component_
      AND   version   = version_;
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%FOUND) THEN
      CLOSE exist_control;
      RETURN('TRUE');
   END IF;
   CLOSE exist_control;
   RETURN('FALSE');
END Is_Component_Version_Active__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Comp_Patch_Registration_ (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2,
   version_      IN VARCHAR2,
   file_name_    IN VARCHAR2,
   download_    IN DATE,
   description_  IN VARCHAR2 DEFAULT NULL )
IS
   objid_        COMPONENT_PATCH.objid%TYPE;
   objversion_   COMPONENT_PATCH.objversion%TYPE;
   newrec_       COMPONENT_PATCH_TAB%ROWTYPE;
   oldrec_       COMPONENT_PATCH_TAB%ROWTYPE;
   attr_         VARCHAR2(4000);
   version_ok_   VARCHAR2(5) := Is_Component_Version_Active__(component_, version_);
   message_      VARCHAR2(2000);
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'PATCH_ID', patch_id_);
   Error_SYS.Check_Not_Null(lu_name_, 'COMPONENT', component_);
   Error_SYS.Check_Not_Null(lu_name_, 'VERSION', version_);   
   Error_SYS.Check_Not_Null(lu_name_, 'DOWNLOAD', download_);
   Error_SYS.Check_Not_Null(lu_name_, 'FILE_NAME', file_name_);
   IF (version_ok_ = 'FALSE') THEN
	message_ := Language_SYS.Translate_Constant(lu_name_, 'WRONGVERSION: This patch was installed in wrong component version', NULL);
   END IF;
   IF (NOT Check_Exist___(patch_id_, component_, version_)) THEN
      -- Create the record
      newrec_.patch_id    := patch_id_;      
      newrec_.description := description_;            
      newrec_.component   := component_;
      newrec_.version     := version_;
      newrec_.download    := download_;
      newrec_.installed   := SYSDATE;
      newrec_.cps         := 'FALSE';
      newrec_.redeploy    := 'FALSE';
      newrec_.notes       := message_;
      newrec_.rowversion  := SYSDATE;
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      Get_Id_Version_By_Keys___ (objid_, objversion_, patch_id_, component_, version_);
      oldrec_   := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      newrec_.redeploy := 'FALSE';
      newrec_.notes := message_;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
   Component_Patch_Row_API.Comp_Patch_Registration_Row_(patch_id_, component_, version_, file_name_);
END Comp_Patch_Registration_;


@UncheckedAccess
FUNCTION Comp_Patch_Is_Registered_ (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2,
   version_      IN VARCHAR2,
   file_name_    IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
BEGIN
   IF file_name_ IS NULL THEN
      RETURN Check_Exist___(patch_id_, component_, version_);
   ELSE
      RETURN Component_Patch_Row_API.Comp_Patch_Row_Is_Registered_(patch_id_, component_, version_, file_name_);   
   END IF;
END Comp_Patch_Is_Registered_;


PROCEDURE Comp_Patch_Clear_Registration_ (
   patch_id_     IN NUMBER,
   component_    IN VARCHAR2 DEFAULT '%',
   version_      IN VARCHAR2 DEFAULT '%',
   file_name_    IN VARCHAR2 DEFAULT '%' )
IS
   CURSOR getrec IS
      SELECT component, version, rowid
      FROM  COMPONENT_PATCH_TAB
      WHERE patch_id = patch_id_
      AND   component like component_
      AND   version  like version_;
BEGIN
   IF file_name_ = '%' THEN
      FOR rec IN getrec LOOP
          DELETE FROM component_patch_tab WHERE rowid = rec.rowid;
          Component_Patch_Row_API.Comp_Patch_Row_Clear_Reg_(patch_id_, rec.component, rec.version, file_name_);
      END LOOP;
   ELSE
      Component_Patch_Row_API.Comp_Patch_Row_Clear_Reg_(patch_id_, component_, version_, file_name_);
   END IF;
END Comp_Patch_Clear_Registration_;


PROCEDURE Comp_Patch_Cps_Overwrite_ (
   component_    IN VARCHAR2,
   version_      IN VARCHAR2,
   patch_id_     IN NUMBER DEFAULT 0)
IS
   objid_        COMPONENT_PATCH.objid%TYPE;
   objversion_   COMPONENT_PATCH.objversion%TYPE;
   attr_         VARCHAR2(4000);
   oldrec_       COMPONENT_PATCH_TAB%ROWTYPE;
   newrec_       COMPONENT_PATCH_TAB%ROWTYPE;
    
   CURSOR getrec IS
      SELECT patch_id
      FROM   COMPONENT_PATCH_TAB
      WHERE  component = upper(component_)
      AND    version = version_
      AND    cps = 'FALSE';

BEGIN
   IF patch_id_ = 0 THEN  
      FOR rec IN getrec LOOP
        Get_Id_Version_By_Keys___ (objid_, objversion_, rec.patch_id, component_, version_);
        oldrec_ := Lock_By_Id___(objid_, objversion_);
        newrec_ := oldrec_;
        newrec_.redeploy := 'TRUE';
        Update___(objid_, oldrec_, newrec_, attr_, objversion_);
      END LOOP;
   ELSE
      IF Check_Exist___(patch_id_, component_, version_) THEN
        Get_Id_Version_By_Keys___ (objid_, objversion_, patch_id_, component_, version_);
        oldrec_   := Lock_By_Id___(objid_, objversion_);
        newrec_ := oldrec_;
        newrec_.cps := 'TRUE';
        newrec_.redeploy := 'FALSE';
        Update___(objid_, oldrec_, newrec_, attr_, objversion_);
      END IF;
   END IF;
END Comp_Patch_Cps_Overwrite_; 


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Get_Comppatch_Info (
   info_ OUT VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR get_info IS
      SELECT patch_id, component, version 
      FROM   COMPONENT_PATCH_TAB
      WHERE  cps = 'FALSE'
      AND Is_Component_Version_Active__(component,version) = 'TRUE';
BEGIN
   FOR rec IN get_info LOOP
        temp_ := temp_||rec.patch_id||field_separator_||rec.component||' '||rec.version||field_separator_;
        IF (component_patch_row_api.Include_Centura_(rec.patch_id, rec.component, rec.version)) THEN
           temp_ := temp_||'Patchlog_'||rec.patch_id||'_'||rec.component||'_'||rec.version||'.txt';
        END IF;
        temp_ := temp_||field_separator_;
        IF (component_patch_row_api.Include_Web_(rec.patch_id, rec.component, rec.version)) THEN        
           temp_ := temp_||'Patchlog_'||rec.patch_id||'_'||rec.component||'_'||rec.version||'.txt';
        END IF;
        temp_ := temp_||record_separator_;
   END LOOP;
   info_ := temp_;
END Get_Comppatch_Info;



