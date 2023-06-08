-----------------------------------------------------------------------------
--
--  Logical unit: MediaItemUtil
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE Validate_Parameter (
   object_lu_      IN VARCHAR2,
   object_key_     IN VARCHAR2,
   property_name_  IN VARCHAR2,
   property_value_ IN VARCHAR2 )
IS
BEGIN
   IF object_lu_ = 'MediaItem' AND property_name_ = 'REPOSITORY' AND property_value_ NOT IN ('DATABASE', 'FILE_STORAGE') THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDMEDIAREPO: Parameter :P1 should be either DATABASE or FILE_STORAGE', property_name_);
   END IF;
END Validate_Parameter;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


-------------------- LU  NEW METHODS -------------------------------------
