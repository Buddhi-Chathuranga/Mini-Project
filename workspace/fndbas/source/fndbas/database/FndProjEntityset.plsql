-----------------------------------------------------------------------------
--
--  Logical unit: FndProjEntityset
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
   entityset_name_      IN VARCHAR2,
   based_on_type_       IN VARCHAR2 DEFAULT NULL,
   based_on_             IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_proj_entityset_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entityset_name := entityset_name_;
   rec_.based_on_type   := based_on_type_;
   rec_.based_on        := based_on_;
   
   IF Check_Exist___(projection_name_, entityset_name_) THEN
      DELETE
      FROM fnd_proj_entityset_tab
      WHERE projection_name = projection_name_ 
      AND  entityset_name = entityset_name_;
   END IF;
   New___(rec_);

END Create_Or_Replace;

PROCEDURE New_Entry(
   projection_name_ IN VARCHAR2,
   entityset_name_  IN VARCHAR2,
   based_on_type_   IN VARCHAR2 DEFAULT NULL,
   based_on_        IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_proj_entityset_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.entityset_name := entityset_name_;
   rec_.based_on_type   := based_on_type_;
   rec_.based_on        := based_on_;
  
   New___(rec_);
END New_Entry;

PROCEDURE Remove_Projection_Entityset (
   projection_name_ IN VARCHAR2,
   entityset_name_     IN VARCHAR2,
   show_info_       IN BOOLEAN DEFAULT FALSE)
IS
   rec_ fnd_proj_entityset_tab%ROWTYPE;
BEGIN
   IF Check_Exist___(projection_name_,entityset_name_) THEN
      rec_ := Get_Object_By_Keys___(projection_name_,entityset_name_);
      Remove___(rec_,FALSE);         
         
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Projection_Entityset: In the Projection ' || projection_name_ ||' Entity set '||entityset_name_|| ' dropped.');
      END IF;
   ELSE 
      IF (show_info_) THEN
         Dbms_Output.Put_Line('Remove_Projection_Entity: In the Projection ' || projection_name_ ||' Entity set '||entityset_name_|| ' not exist.');
      END IF;
   END IF;
END Remove_Projection_Entityset;