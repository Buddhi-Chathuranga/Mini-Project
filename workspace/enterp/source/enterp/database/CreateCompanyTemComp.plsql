-----------------------------------------------------------------------------
--
--  Logical unit: CreateCompanyTemComp
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010419  ovjose  Created.
--  020208  ovjose  Changed calls from create_company_reg_api to crecomp_component_api
--  131015  Isuklk  CAHOOK-2734 Refactoring in CreateCompanyTemComp.entity
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     create_company_tem_comp_tab%ROWTYPE,
   newrec_ IN OUT create_company_tem_comp_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (Create_Company_Tem_API.Change_Template_Allowed(newrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'INSNOTALLOWED: Not allowed to change a template created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN create_company_tem_comp_tab%ROWTYPE )
IS   
BEGIN
   IF (Create_Company_Tem_API.Change_Template_Allowed(remrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'REMNOTALLOWED: Not allowed to remove a template created by another user. '||
                               'Only a company template super user is allowed to remove other users templates');
   END IF;
   super(remrec_);
END Check_Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_ create_company_tem_comp_tab%ROWTYPE;   
BEGIN    
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);     
      Create_Company_Tem_API.Set_Last_Modification_Date(newrec_.template_id);         
   END IF;   
END New__;


@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_ create_company_tem_comp_tab%ROWTYPE;   
BEGIN     
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      oldrec_ := Get_Object_By_Id___(objid_);      
      Create_Company_Tem_API.Set_Last_Modification_Date(oldrec_.template_id);         
   END IF;
END Modify__;


PROCEDURE Insert_Data__ (
   detail_rec_ IN Create_Company_Tem_API.Public_Rec_Templ )
IS
   objid_        create_company_tem_comp.objid%TYPE;
   objversion_   create_company_tem_comp.objversion%TYPE;
   attr_         VARCHAR2(2000);
   oldrec_       create_company_tem_comp_tab%ROWTYPE;
   newrec_       create_company_tem_comp_tab%ROWTYPE;
   exist_        BOOLEAN;
   version_      VARCHAR2(50);
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', detail_rec_.template_id);
   Error_SYS.Check_Not_Null(lu_name_, 'COMPONENT', detail_rec_.component);
   Error_SYS.Check_Not_Null(lu_name_, 'VERSION', detail_rec_.version);
   Create_Company_Tem_API.Exist(detail_rec_.template_id);
   Crecomp_Component_API.Exist(detail_rec_.component);
   version_ := Crecomp_Component_API.Get_Version(detail_rec_.component);
   IF (version_ != detail_rec_.version) THEN
      Create_Company_Tem_API.Set_Invalid(detail_rec_.template_id);
   END IF;
   newrec_.template_id  := detail_rec_.template_id;
   newrec_.component    := detail_rec_.component;
   newrec_.version      := detail_rec_.version;
   exist_ := Check_Exist___(detail_rec_.template_id, detail_rec_.component);
   IF NOT (exist_) THEN
      Insert___(objid_, objversion_, newrec_,  attr_);
   ELSE
      Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.template_id, newrec_.component);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END Insert_Data__;
 
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Override
FUNCTION Get_Version (
   template_id_ IN VARCHAR2,
   component_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ create_company_tem_comp_tab.version%TYPE;
BEGIN
   IF (Database_SYS.Get_Installation_Mode) THEN
      IF (template_id_ IS NULL OR component_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT version
         INTO  temp_
         FROM  create_company_tem_comp_tab
         WHERE template_id = template_id_
         AND   component = component_;
      RETURN temp_;
   ELSE   
      RETURN super(template_id_, component_);
   END IF;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(template_id_, component_, 'Get_Version');
END Get_Version;
