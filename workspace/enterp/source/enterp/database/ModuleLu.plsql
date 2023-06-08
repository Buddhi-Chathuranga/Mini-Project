-----------------------------------------------------------------------------
--
--  Logical unit: ModuleLu
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  020108  ovjose  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Add_Module_Detail__ (
   detail_rec_ IN module_lu_tab%ROWTYPE )
IS
   attr_          VARCHAR2(2000);
   newrec_        module_lu_tab%ROWTYPE;
   oldrec_        module_lu_tab%ROWTYPE;
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(2000);
BEGIN
   newrec_ := detail_rec_;
   Error_SYS.Check_Not_Null(lu_name_, 'MODULE', newrec_.module);
   Error_SYS.Check_Not_Null(lu_name_, 'LU', newrec_.lu);
   IF (Check_Exist___(newrec_.module, newrec_.lu)) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, newrec_.module, newrec_.lu);
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_.last_modification_date := SYSDATE;
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   ELSE
      newrec_.registration_date := SYSDATE;   
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END Add_Module_Detail__;


FUNCTION Check_Exist__ (
   module_  IN VARCHAR2,               
   lu_      IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(module_, lu_);
END Check_Exist__;   
            
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


