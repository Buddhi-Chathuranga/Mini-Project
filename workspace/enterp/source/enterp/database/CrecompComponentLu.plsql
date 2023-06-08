-----------------------------------------------------------------------------
--
--  Logical unit: CrecompComponentLu
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020109  ovjose  Created.
--  020301  lali    Modified Remove_Detail__ to do nothing if entry does not exist
--  021112  ovjose  Glob06. Added attribute_key_col, attribute_key_suffix and attribute_key_value.
--  021114  ovjose  Glob06. Added Get_Translation_Reg_Info__
--  050816  ovjose  Changed the purpose of Export_view to mean Create And Export. (TRUE/FALSE
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT crecomp_component_lu_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.account_lu IS NOT NULL) THEN 
      Fnd_Boolean_API.Exist_Db(newrec_.account_lu);
   ELSE
      newrec_.account_lu := 'FALSE';
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     crecomp_component_lu_tab%ROWTYPE,
   newrec_ IN OUT crecomp_component_lu_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS     
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);   
   IF (oldrec_.account_lu != newrec_.account_lu) THEN      
      IF (newrec_.account_lu IS NOT NULL) THEN
         Fnd_Boolean_API.Exist_Db(newrec_.account_lu);
      END IF;
   END IF;
END Check_Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     crecomp_component_lu_tab%ROWTYPE,
   newrec_ IN OUT crecomp_component_lu_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN   
   super(oldrec_, newrec_, indrec_, attr_);   
   IF (newrec_.export_view IS NOT NULL) AND (newrec_.export_view != 'FALSE') THEN
      newrec_.export_view := 'TRUE';
   ELSE
      newrec_.export_view := 'FALSE';
   END IF;
   Fnd_Boolean_API.Exist_Db(newrec_.active);   
   Assert_SYS.Assert_Is_Package(newrec_.package);
END Check_Common___;


@Override
PROCEDURE Raise_Record_Not_Exist___ (
   module_ IN VARCHAR2,
   lu_     IN VARCHAR2 )
IS
BEGIN
   Error_SYS.Record_Not_Exist(lu_name_, NULL, module_||' '||lu_);
   super(module_, lu_);   
END Raise_Record_Not_Exist___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Set_Active_Detail__ (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2,
   active_     IN VARCHAR2 )
IS
   newrec_        crecomp_component_lu_tab%ROWTYPE;
   oldrec_        crecomp_component_lu_tab%ROWTYPE;
   attr_          VARCHAR2(2000);
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, module_, lu_);
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   newrec_.active := active_;
   Update___(objid_, oldrec_, newrec_, attr_, objversion_);
END Set_Active_Detail__;


PROCEDURE Remove_Detail__ (
   module_     IN VARCHAR2,
   lu_         IN VARCHAR2 )
IS
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
   remrec_        crecomp_component_lu_tab%ROWTYPE;
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, module_, lu_);
   IF (objid_ IS NOT NULL) THEN
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Delete___(objid_, remrec_);
   END IF;
END Remove_Detail__;


FUNCTION Is_Account_Lu__ (
   module_ IN VARCHAR2,
   lu_     IN VARCHAR2 ) RETURN BOOLEAN
IS
   rec_     crecomp_component_lu_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(module_, lu_);
   IF (rec_.module IS NOT NULL) THEN
      IF (rec_.account_lu = 'TRUE') THEN
         RETURN TRUE;
      END IF;
   END IF;
   RETURN FALSE;
END Is_Account_Lu__;


PROCEDURE Add_Component_Detail__ (
   detail_rec_ IN crecomp_component_lu_tab%ROWTYPE )
IS
   attr_          VARCHAR2(2000);
   newrec_        crecomp_component_lu_tab%ROWTYPE;
   oldrec_        crecomp_component_lu_tab%ROWTYPE;
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
   indrec_        Indicator_Rec;
BEGIN
   IF (NOT Enterp_Comp_Connect_V170_API.Check_Exist_Module_Lu(detail_rec_.module, detail_rec_.lu) ) THEN
      Enterp_Comp_Connect_V170_API.Add_Module_Detail(detail_rec_.module, detail_rec_.lu );
   END IF;
   IF (Check_Exist___(detail_rec_.module, detail_rec_.lu)) THEN
      oldrec_ := Lock_By_Keys___(detail_rec_.module, detail_rec_.lu);
      newrec_ := oldrec_;
      attr_ := Pack___(detail_rec_);
      Unpack___(newrec_, indrec_, attr_);
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);    
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      newrec_ := detail_rec_;
      New___(newrec_);
   END IF;
END Add_Component_Detail__;


FUNCTION Get_Translation_Reg_Info__ (
   key_attr_      OUT VARCHAR2,
   suffix_attr_   OUT VARCHAR2,
   value_attr_    OUT VARCHAR2,
   module_        IN  VARCHAR2,
   lu_            IN  VARCHAR2) RETURN BOOLEAN
IS
   rec_     crecomp_component_lu_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(module_, lu_);
   key_attr_ := rec_.attribute_key_col;
   suffix_attr_ := rec_.attribute_key_suffix;
   value_attr_ := rec_.attribute_key_value;
   -- Check on value_attr_ if it exists translatable texts for the lu
   IF (value_attr_ IS NULL) THEN
      RETURN FALSE;
   END IF;
   RETURN TRUE;
END Get_Translation_Reg_Info__;
       
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


