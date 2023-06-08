-----------------------------------------------------------------------------
--
--  Logical unit: CompanyStructure
--  Component:    ACCRUL
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211224  Tiralk  FI21R2-8199, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
PROCEDURE Refresh_Structure_Cache___ (
   rec_  IN OUT NOCOPY company_structure_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS   
BEGIN
   Company_Structure_Util_API.Refresh_Structure_Cache(rec_.structure_id);
END Refresh_Structure_Cache___;

PROCEDURE Remove_Structure_Cache___ (
   rec_  IN OUT NOCOPY company_structure_tab%ROWTYPE,
   attr_ IN OUT NOCOPY VARCHAR2 )
IS  
BEGIN
   Company_Structure_Util_API.Remove_Structure_Cache(rec_.structure_id);
END Remove_Structure_Cache___;
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT company_structure_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF ((INSTR(newrec_.structure_id,'&') >0) OR (INSTR(newrec_.structure_id,'''') >0) OR (INSTR(newrec_.structure_id,'^') >0)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDSTRUCTIDCHAR: You have entered an invalid character for Structure ID field.');
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   -- Insert first node when creating structure
   IF (NVL(Client_SYS.Get_Item_Value('COPY_STRUCTURE', attr_), 'FALSE') = 'FALSE') THEN
      Company_Structure_Item_API.New_node__(newrec_.structure_id, '1', '<1>', NULL, 0);
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@IgnoreUnitTest MethodOverride
@Override
PROCEDURE Check_Delete___ (
   remrec_ IN company_structure_tab%ROWTYPE )
IS
   state_   company_structure_tab.rowstate%TYPE;
BEGIN
   state_ := Get_Objstate(remrec_.structure_id);
   IF (state_ IN ('Active')) THEN
      Error_SYS.Record_general(lu_name_, 'NOTALLOWREMOVE: You are not allowed to remove a structure in status ":P1"!', state_); 
   END IF;
   super(remrec_);
END Check_Delete___;


@IgnoreUnitTest NoOutParams
PROCEDURE Validate_Structure_Modify (
   structure_id_ IN VARCHAR2 )
IS
   state_   company_structure_tab.rowstate%TYPE;
BEGIN
   state_ := Get_Objstate(structure_id_);
   IF (state_ NOT IN ('In Progress')) THEN
      Error_SYS.Record_general(lu_name_, 'NOTALLOWMODIFY: You are not allowed to modify in status ":P1"', state_);
   END IF;
END Validate_Structure_Modify;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@IgnoreUnitTest DMLOperation
PROCEDURE Copy__ (
   source_structure_id_    IN  VARCHAR2,
   new_structure_id_       IN  VARCHAR2,
   new_description_        IN  VARCHAR2,
   include_company_values_ IN  VARCHAR2 )
IS
   info_            VARCHAR2(2000);
   attr_            VARCHAR2(32000);
   objid_           company_structure.objid%TYPE;
   objversion_      company_structure.objversion%TYPE;
BEGIN
   Client_SYS.Add_To_Attr('STRUCTURE_ID',   new_structure_id_, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION',    new_description_,  attr_);
   Client_SYS.Add_To_Attr('COPY_STRUCTURE', 'TRUE',            attr_);
   New__(info_, objid_, objversion_, attr_, 'DO'); 
   
   Company_Structure_Level_API.Copy__(source_structure_id_, new_structure_id_);
   Company_Structure_Item_API.Copy__(source_structure_id_, new_structure_id_, include_company_values_);
END Copy__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

