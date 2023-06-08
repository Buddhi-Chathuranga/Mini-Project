-----------------------------------------------------------------------------
--
--  Logical unit: FndProjEntAction
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
   projection_name_    IN VARCHAR2,
   entity_name_        IN VARCHAR2,
   action_name_        IN VARCHAR2,
   checkpoint_         IN VARCHAR2 DEFAULT NULL,
   legacy_checkpoints_ IN VARCHAR2 DEFAULT NULL )
IS
   rec_ fnd_proj_ent_action_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entity_name := entity_name_;
   rec_.action_name := action_name_;
   rec_.checkpoint := checkpoint_;
   rec_.legacy_checkpoints := legacy_checkpoints_;
   
   IF checkpoint_ IS NOT NULL AND NOT Fnd_Proj_Checkpoint_Gate_API.Exists(checkpoint_) THEN
      Fnd_Proj_Checkpoint_Gate_API.New_Gate(checkpoint_);
   END IF;
   
   IF Check_Exist___(projection_name_,entity_name_,action_name_) THEN
      Remove___(rec_,FALSE);
   END IF;
   New___(rec_);
   
END Create_Or_Replace;

PROCEDURE New_Entry(projection_name_ IN VARCHAR2, entity_name_ IN VARCHAR2, action_name_ IN VARCHAR2, checkpoint_ IN VARCHAR2 DEFAULT NULL, legacy_checkpoints_ IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_proj_ent_action_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entity_name := entity_name_;
   rec_.action_name := action_name_;
   rec_.checkpoint := checkpoint_;
   rec_.legacy_checkpoints := legacy_checkpoints_;
   
   New___(rec_);
   
   IF checkpoint_ IS NOT NULL AND NOT Fnd_Proj_Checkpoint_Gate_API.Exists(checkpoint_) THEN
      Fnd_Proj_Checkpoint_Gate_API.New_Gate(checkpoint_);
   END IF;
END New_Entry;