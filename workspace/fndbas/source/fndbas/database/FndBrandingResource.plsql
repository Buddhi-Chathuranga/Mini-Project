-----------------------------------------------------------------------------
--
--  Logical unit: FndBrandingResource
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------



FUNCTION Get_Time_Modified (
   file_name_ IN VARCHAR2 ) RETURN TIMESTAMP
IS
   FUNCTION Base (
      file_name_ IN VARCHAR2 ) RETURN DATE
   IS
      temp_ fnd_branding_resource_tab.date_modified%TYPE;
   BEGIN
      IF (file_name_ IS NULL) THEN
         RETURN NULL;
      END IF;
      SELECT date_modified
         INTO  temp_
         FROM  fnd_branding_resource_tab
         WHERE file_name = file_name_;
      RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(file_name_, 'Get_Time_Modified');
   END Base;

BEGIN
   RETURN Base(file_name_);
END Get_Time_Modified;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Check_Resource_Mapped___ (
   file_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   exp_value_ VARCHAR2(2000);
   file_count_ NUMBER;
   
BEGIN
   exp_value_ := 'RESOURCE: ' || file_name_;
   
	SELECT COUNT(*) INTO file_count_ FROM fnd_branding_property_tab 
         WHERE value = exp_value_ ;
         
   IF (file_count_ > 0) THEN
      RETURN TRUE; 
   ELSE
      RETURN FALSE;
   END IF;
END Check_Resource_Mapped___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

