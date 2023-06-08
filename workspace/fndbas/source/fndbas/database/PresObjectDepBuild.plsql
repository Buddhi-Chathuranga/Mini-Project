-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectDepBuild
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE table_rec IS pres_object_dep_build_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

/*
--@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     pres_object_dep_build_tab%ROWTYPE,
   newrec_ IN OUT pres_object_dep_build_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.from_po_id IS NOT NULL)
   AND (indrec_.from_po_id)
   AND (Validate_SYS.Is_Changed(oldrec_.from_po_id, newrec_.from_po_id)) THEN
      -- No check on Dynamic tabs
      IF (newrec_.pres_object_dep_type != '2') THEN 
         Pres_Object_Build_API.Exist(newrec_.from_po_id);
      END IF;
   END IF;
END Check_Common___;
*/


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Create_Or_Replace (
   rec_  IN OUT table_rec )
IS
BEGIN
   IF Check_Exist___(rec_.from_po_id, rec_.to_po_id, rec_.pres_object_dep_type) THEN
      Modify___(rec_);
   ELSE
      New___(rec_);
   END IF;
END Create_Or_Replace;
