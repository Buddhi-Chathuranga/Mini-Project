-----------------------------------------------------------------------------
--
--  Logical unit: UpdateCompanySelectLu
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  051221  Chlilk  Remove the last parameter in call General_SYS.Init_Method for non-implementation
--                  methods    
--  091203  Kanslk  Reverse-Engineering, added reference to lu
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-------------------- PRIVATE DECLARATIONS -----------------------------------

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Initiate_Values__ (
   update_id_ IN OUT VARCHAR2 )
IS
   session_id_ CONSTANT VARCHAR2(64) := Sys_Context('USERENV', 'SESSIONID');
BEGIN
   IF (update_id_ IS NULL) THEN
      update_id_ := session_id_;
      Remove_For_Id__(update_id_);
      INSERT INTO update_company_select_lu_tab
         (update_id, 
          module, 
          lu, 
          selected, 
          rowversion)
      SELECT 
         update_id_, 
         module, 
         lu, 
         'TRUE', 
         SYSDATE
      FROM crecomp_component_process;
   END IF;
END Initiate_Values__;


PROCEDURE Remove_For_Id__ (
   update_id_ IN VARCHAR2 )
IS
BEGIN
   DELETE 
   FROM update_company_select_lu_tab 
   WHERE update_id = update_id_;
END Remove_For_Id__;


FUNCTION Module_Is_Selected__ (
   update_id_ IN VARCHAR2,
   module_    IN VARCHAR2 ) RETURN BOOLEAN
IS
   idummy_  PLS_INTEGER;
   found_   BOOLEAN;
   CURSOR find_module IS
      SELECT 1
      FROM   update_company_select_lu
      WHERE  update_id = update_id_
      AND    module    = module_
      AND    selected  = 'TRUE';
BEGIN
   found_ := TRUE;
   OPEN find_module;
   FETCH find_module INTO idummy_;
   IF (find_module%NOTFOUND) THEN
      found_ := FALSE;
   END IF;
   CLOSE find_module;
   RETURN found_;
END Module_Is_Selected__;


FUNCTION Lu_Is_Selected__ (
   update_id_ IN VARCHAR2,
   module_    IN VARCHAR2,
   lu_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   idummy_  PLS_INTEGER;
   found_   BOOLEAN;
   CURSOR find_lu IS
      SELECT 1
      FROM   update_company_select_lu
      WHERE  update_id = update_id_
      AND    module    = module_
      AND    lu        = lu_
      AND    selected  = 'TRUE';
BEGIN
   found_ := TRUE;
   OPEN find_lu;
   FETCH find_lu INTO idummy_;
   IF (find_lu%NOTFOUND) THEN
      found_ := FALSE;
   END IF;
   CLOSE find_lu;
   RETURN found_;
END Lu_Is_Selected__;
             
-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


