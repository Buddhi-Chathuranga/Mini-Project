-----------------------------------------------------------------------------
--
--  Logical unit: RemoveCompanyDetail
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021114  ovjose  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT remove_company_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   Crecomp_Component_API.Exist(newrec_.module);
   Remove_Company_API.Exist(newrec_.module, newrec_.table_name);
   Assert_SYS.Assert_Is_Table_Column(newrec_.table_name, newrec_.column_name);
END Check_Insert___;
                    
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Add_Table_Detail__ (
   module_        IN VARCHAR2,
   table_name_    IN VARCHAR2,
   column_name_   IN VARCHAR2,
   column_value_  IN VARCHAR2 )
IS
   newrec_     remove_company_detail_tab%ROWTYPE;
   attr_       VARCHAR2(2000);
   oldrec_     remove_company_detail_tab%ROWTYPE;
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   IF (Check_Exist___(module_, table_name_, column_name_)) THEN
      oldrec_ := Lock_By_Keys___(module_, table_name_, column_name_);
      newrec_ := oldrec_;
      newrec_.module       := module_;
      newrec_.table_name   := table_name_;
      newrec_.column_name  := column_name_;
      newrec_.column_value := column_value_;
      indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
   ELSE
      newrec_.module       := module_;
      newrec_.table_name   := table_name_;
      newrec_.column_name  := column_name_;
      newrec_.column_value := column_value_;
      New___(newrec_);
   END IF;
END Add_Table_Detail__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


