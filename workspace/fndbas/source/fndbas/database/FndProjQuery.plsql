-----------------------------------------------------------------------------
--
--  Logical unit: FndProjQuery
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
   query_name_      IN VARCHAR2,
   from_view_           IN VARCHAR2 DEFAULT NULL,
   used_lu_             IN VARCHAR2 DEFAULT NULL,
   usage_type_          IN VARCHAR2 DEFAULT NULL,
   exclude_from_config_ IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_proj_query_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.query_name := query_name_;
   rec_.from_view  := UPPER(from_view_);
   rec_.used_lu             := used_lu_;
   rec_.usage_type          := nvl(usage_type_, 'Main');
   rec_.exclude_from_config := nvl(exclude_from_config_, 'FALSE');
   
   IF Check_Exist___(projection_name_, query_name_) THEN
      DELETE
      FROM fnd_proj_query_tab
      WHERE projection_name = projection_name_ 
      AND  query_name = query_name_;
   END IF;
   New___(rec_);

END Create_Or_Replace;

PROCEDURE New_Entry(
   projection_name_ IN VARCHAR2,
   query_name_      IN VARCHAR2,
   from_view_           IN VARCHAR2 DEFAULT NULL,
   used_lu_             IN VARCHAR2 DEFAULT NULL,
   usage_type_          IN VARCHAR2 DEFAULT NULL,
   exclude_from_config_ IN VARCHAR2 DEFAULT NULL)
IS
   rec_ fnd_proj_query_tab%ROWTYPE;
BEGIN
   rec_.projection_name := projection_name_;
   rec_.query_name := query_name_;
   rec_.from_view   := UPPER(from_view_);
   rec_.used_lu             := used_lu_;
   rec_.usage_type          := nvl(usage_type_, 'Main');
   rec_.exclude_from_config := nvl(exclude_from_config_, 'FALSE');
   
   New___(rec_);
END New_Entry;
