-----------------------------------------------------------------------------
--
--  Logical unit: CompTemplateSuperUser
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050804  ovjose  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Is_Template_Super_User__ RETURN BOOLEAN
IS
   fnd_user_      VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   RETURN Check_Exist___(fnd_user_);
END Is_Template_Super_User__;
                    
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


