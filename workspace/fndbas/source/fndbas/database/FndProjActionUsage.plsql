-----------------------------------------------------------------------------
--
--  Logical unit: FndProjActionUsage
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Or_Replace (
   projection_name_ IN VARCHAR2,
   action_name_ IN VARCHAR2,
   client_     IN VARCHAR2,
   artifact_name_ IN VARCHAR2,
   artifact_ IN VARCHAR2,
   artifact_label_ IN VARCHAR2 DEFAULT NULL )
IS
   rec_ fnd_proj_action_usage_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.action_name := action_name_;
   rec_.client := client_;
   rec_.artifact_name := artifact_name_;
   rec_.artifact := artifact_;
   rec_.artifact_label := artifact_label_;
   IF Check_Exist___(projection_name_,action_name_, client_,artifact_name_) THEN
      Remove___(rec_,FALSE);
   END IF;
   New___(rec_);
END Create_Or_Replace;

PROCEDURE Clear_Client_Refs (
   client_     IN VARCHAR2)
IS
   CURSOR get_rec IS
     SELECT *
     FROM Fnd_Proj_Action_Usage_TAB
     WHERE client = client_;
BEGIN
   FOR rec_ IN get_rec LOOP
      Remove___(rec_,FALSE);
   END LOOP;
END Clear_Client_Refs;
