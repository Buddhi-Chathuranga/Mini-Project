-----------------------------------------------------------------------------
--
--  Logical unit: SystemCompanyTemplate
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--- 050804  ovjose  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Enumerate_System_Templates__ (
   template_ids_ OUT VARCHAR2 )
IS
   CURSOR get_templates IS
      SELECT template_id
      FROM   system_company_template_tab;
BEGIN
   FOR rec_ IN get_templates LOOP
      template_ids_ := template_ids_ || rec_.template_id || '^';
   END LOOP;
END Enumerate_System_Templates__;


@UncheckedAccess
FUNCTION Is_System_Company_Template__ (
   template_id_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(template_id_);
END Is_System_Company_Template__;
                    
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


