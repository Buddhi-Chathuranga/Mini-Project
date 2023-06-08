-----------------------------------------------------------------------------
--
--  Logical unit: FndProjCheckpointGate
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

PROCEDURE New_Gate(
   gate_id_ IN VARCHAR2)
IS
   newrec_  fnd_proj_checkpoint_gate_tab%ROWTYPE;
BEGIN
   newrec_.gate_id := gate_id_;
   newrec_.active := Fnd_Boolean_API.DB_TRUE;
   newrec_.all_users_valid := Fnd_Boolean_API.DB_FALSE;
   New___(newrec_);
END New_Gate;

PROCEDURE Delete_Gate(
   gate_id_ IN VARCHAR2)
IS
   remrec_  fnd_proj_checkpoint_gate_tab%ROWTYPE;
BEGIN
   remrec_.gate_id := gate_id_;
   Remove___(remrec_);
END Delete_Gate;

PROCEDURE Activate(
   gate_id_ IN VARCHAR2
   )
IS
   newrec_ fnd_proj_checkpoint_gate_tab%ROWTYPE;
BEGIN
   IF Get_Active_Db(gate_id_) = 'FALSE' THEN 
      newrec_ := Get_Object_By_Keys___(gate_id_);
      newrec_.active := Fnd_Boolean_API.DB_TRUE;
      Modify___(newrec_);
   END IF;  
END Activate;

PROCEDURE Deactivate(
   gate_id_ IN VARCHAR2)
IS
   newrec_ fnd_proj_checkpoint_gate_tab%ROWTYPE;
BEGIN
   IF Get_Active_Db(gate_id_) = 'TRUE' THEN 
      newrec_ := Get_Object_By_Keys___(gate_id_);
      newrec_.active := Fnd_Boolean_API.DB_FALSE;
      Modify___(newrec_);
   END IF;  
END Deactivate;

PROCEDURE Set_All_Users_Valid(
   gate_id_ IN VARCHAR2,
   value_   IN BOOLEAN)
IS
   newrec_ fnd_proj_checkpoint_gate_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(gate_id_);
   IF value_ THEN
      newrec_.all_users_valid := Fnd_Boolean_API.DB_TRUE;
   ELSE
      newrec_.all_users_valid := Fnd_Boolean_API.DB_FALSE;
   END IF;
   Modify___(newrec_);
END Set_All_Users_Valid;

PROCEDURE Cleanup
IS
BEGIN
   DELETE FROM Fnd_Proj_Checkpoint_Gate_Tab c
   WHERE NOT EXISTS 
      (SELECT * FROM Fnd_Proj_Action a WHERE a.checkpoint = c.gate_id)
   AND NOT EXISTS 
      (SELECT * FROM Fnd_Proj_Ent_Action e WHERE e.checkpoint = c.gate_id);
END Cleanup;

FUNCTION Get_Checkpoints_On RETURN VARCHAR2 
IS
BEGIN
   RETURN Fnd_Setting_API.Get_Value('CHECKPOINT_AUR');
END Get_Checkpoints_On;

--FUNCTION Get_All_Users_Valid RETURN BOOLEAN 
--IS
--BEGIN
--   RETURN Fnd_Setting_API.Get_Value('CHECKPOINT_ALLUSERS') = 'ON';
--END Get_All_Users_Valid;
--
--FUNCTION Get_Must_Comment RETURN BOOLEAN 
--IS
--BEGIN
--   RETURN Fnd_Setting_API.Get_Value('CHECKPOINT_MUSTCOM') = 'ON';
--END Get_Must_Comment;