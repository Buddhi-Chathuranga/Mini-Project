-----------------------------------------------------------------------------
--
--  Logical unit: CreateCompanyTemLu
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  010419  ovjose  Created.
--  010528  LaLi    Added error handling in Insert_Data__
--  020208  ovjose  Changed calls to Crecomp_Component_Lu_API instead of Create_Company_Reg_Detail_API
--  030902  lalise  Minor modification
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN create_company_tem_lu_tab%ROWTYPE )
IS   
BEGIN
   IF (Create_Company_Tem_API.Change_Template_Allowed(remrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'REMNOTALLOWED: Not allowed to remove a template created by another user. '||
                               'Only a company template super user is allowed to remove other users templates');
   END IF;
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT create_company_tem_lu_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);   
   Crecomp_Component_Lu_API.Exist(newrec_.component, newrec_.lu);   
   IF (Create_Company_Tem_API.Change_Template_Allowed(newrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'INSNOTALLOWED: Not allowed to change a template created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     create_company_tem_lu_tab%ROWTYPE,
   newrec_ IN OUT create_company_tem_lu_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   IF (Create_Company_Tem_API.Change_Template_Allowed(oldrec_.template_id) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_, 'UPDNOTALLOWED: Not allowed to update a template created by another user. '||
                               'Only a company template super user is allowed to change other users templates');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;
 
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
   objid_        create_company_tem_lu.objid%TYPE;
   objversion_   create_company_tem_lu.objversion%TYPE;
   attr_         VARCHAR2(2000);
   oldrec_       create_company_tem_lu_tab%ROWTYPE;
   newrec_       create_company_tem_lu_tab%ROWTYPE;
   exist_        BOOLEAN;
BEGIN
   Error_SYS.Check_Not_Null(lu_name_, 'TEMPLATE_ID', detail_rec_.template_id);
   Error_SYS.Check_Not_Null(lu_name_, 'COMPONENT', detail_rec_.component);
   Error_SYS.Check_Not_Null(lu_name_, 'LU', detail_rec_.lu);
   Create_Company_Tem_API.Exist(detail_rec_.template_id);
   Create_Company_Tem_Comp_API.Exist(detail_rec_.template_id,detail_rec_.component);
   Crecomp_Component_Lu_API.Exist(detail_rec_.component, detail_rec_.lu);
   exist_ := Check_Exist___(detail_rec_.template_id, detail_rec_.component, detail_rec_.lu);
   IF NOT (exist_) THEN
      newrec_.template_id  := detail_rec_.template_id;
      newrec_.component    := detail_rec_.component;
      newrec_.lu           := detail_rec_.lu;
      Insert___(objid_, objversion_, newrec_,  attr_);
      -- IF item_id does not have a values just create on lu level and not call detail level
      IF (detail_rec_.item_id IS NOT NULL) THEN
         Create_Company_Tem_Detail_API.Insert_Data__(detail_rec_);
      END IF;
   ELSE
      oldrec_ := Get_Object_By_Keys___(detail_rec_.template_id, detail_rec_.component, detail_rec_.lu);
      newrec_ := oldrec_;
      newrec_.template_id  := detail_rec_.template_id;
      newrec_.component    := detail_rec_.component;
      newrec_.lu           := detail_rec_.lu;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
      -- IF item_id does not have a values just create on lu level and not call detail level
      IF (detail_rec_.item_id IS NOT NULL) THEN
         Create_Company_Tem_Detail_API.Insert_Data__(detail_rec_);
      END IF;
   END IF;
END Insert_Data__;
           
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


