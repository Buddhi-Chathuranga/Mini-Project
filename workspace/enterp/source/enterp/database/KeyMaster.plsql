-----------------------------------------------------------------------------
--
--  Logical unit: KeyMaster
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  021115  stdafi  Glob06. Added Exist_Key_Master__ and Insert_Key_Master__
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Exist_Key_Master__ (
   key_name_   IN VARCHAR2,
   key_value_  IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   IF (NOT Check_Exist___(key_name_, key_value_)) THEN
      RETURN(FALSE);
   ELSE
      RETURN(TRUE);
   END IF;
END Exist_Key_Master__;


PROCEDURE Insert_Key_Master__ (
   key_name_   IN VARCHAR2,
   key_value_  IN VARCHAR2 )
IS
   objid_         key_master.objid%TYPE;
   objversion_    key_master.objversion%TYPE;
   attr_          VARCHAR2(2000);
   newrec_        key_master_tab%ROWTYPE;
   exist_         BOOLEAN;
BEGIN
   newrec_.key_name := key_name_;
   newrec_.key_value := key_value_;
   exist_ := Check_Exist___(key_name_, key_value_);
   IF NOT (exist_) THEN
      Insert___ (objid_, objversion_, newrec_, attr_);
   END IF;
END Insert_Key_Master__;
                                                    
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


