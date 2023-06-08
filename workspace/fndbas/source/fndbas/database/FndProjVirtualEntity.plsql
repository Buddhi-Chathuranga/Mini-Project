-----------------------------------------------------------------------------
--
--  Logical unit: FndProjVirtualEntity
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
   entity_name_     IN VARCHAR2,
   table_name_      IN VARCHAR2)
IS
   rec_ fnd_proj_virtual_entity_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entity_name := entity_name_;
   rec_.table_name   := table_name_;
   
   IF Check_Exist___(projection_name_,entity_name_) THEN
      IF Installation_SYS.Get_Installation_Mode THEN            
         DELETE
            FROM fnd_proj_virtual_entity_tab
            WHERE projection_name = projection_name_ 
            AND entity_name = entity_name_;
      ELSE
         Remove___(rec_,FALSE);
      END IF;
   END IF;
   New___(rec_);
   
END Create_Or_Replace;

PROCEDURE Remove_Proj_Virtual_Entity (
   projection_name_ IN VARCHAR2,
   entity_name_     IN VARCHAR2,
   show_info_       IN BOOLEAN DEFAULT FALSE)
IS
   rec_ fnd_proj_virtual_entity_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(projection_name_,entity_name_) THEN
      rec_ := Get_Object_By_Keys___(projection_name_,entity_name_);
      Remove___(rec_,FALSE);
      Database_SYS.Remove_Table(rec_.table_name, purge_ => TRUE);
      
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Proj_Virtual_Entity: In the Projection ' || projection_name_ ||' Virtual Entity '||entity_name_|| ' dropped.');
      END IF;
   ELSE 
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Proj_Virtual_Entity: In the Projection ' || projection_name_ ||' Virtual Entity '||entity_name_|| ' not exist.');
      END IF;
   END IF;
END Remove_Proj_Virtual_Entity;

PROCEDURE Remove_Proj_Virtual_Entities (
   projection_name_ IN VARCHAR2,
   show_info_       IN BOOLEAN DEFAULT FALSE)
IS
   CURSOR Get IS
         SELECT *
         FROM Fnd_Proj_Virtual_Entity 
         WHERE projection_name = projection_name_ ;
BEGIN
   FOR rec_ IN Get LOOP
      Remove_Proj_Virtual_Entity(projection_name_, rec_.entity_name, show_info_);
   END LOOP;
END Remove_Proj_Virtual_Entities;
