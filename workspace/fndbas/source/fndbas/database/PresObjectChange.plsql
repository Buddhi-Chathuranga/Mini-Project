-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectChange
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  121228   USRA   Added validation for INFO_TYPE (Bug#106173).
-----------------------------------------------------------------------------

layer Core;


-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------
-----------------------------------------------------------------------------
-------------------- IMPLEMENTATION BASE METHODS FOR INSERT -----------------
-----------------------------------------------------------------------------
-- Unpack_Check_Insert___
--    Unpack the attribute list, check all attributes from the client
--    and generate all default values before creation of the new object.
--
-----------------------------------------------------------------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pres_object_change_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   IF (Validate_SYS.Is_Changed(NULL, newrec_.info_type, indrec_.info_type)) THEN
       Validate_Info_Type___(newrec_.info_type);
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Validate_Info_Type___ (
   info_type_ IN VARCHAR2 ) IS
BEGIN
   IF ( info_type_ NOT IN ( 'Auto', 'Manual', 'Modified' ) ) THEN
      Error_SYS.Item_Format(lu_name_, 'INFO_TYPE', info_type_);
   END IF;
END Validate_Info_Type___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
