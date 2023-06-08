-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectDepChange
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

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pres_object_dep_change_tab%ROWTYPE,
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
   info_type_ IN VARCHAR2 )
IS
BEGIN
   IF ( info_type_ NOT IN ( 'Auto', 'Manual', 'Modified' ) ) THEN
      Error_SYS.Item_Format(lu_name_, 'INFO_TYPE', info_type_);
   END IF;
END Validate_Info_Type___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Remove_From_Dependency__ (
   from_po_id_ IN VARCHAR2 )
IS
BEGIN
   Trace_SYS.Field('from_po_id_', from_po_id_);
   DELETE FROM PRES_OBJECT_DEP_CHANGE_TAB
      WHERE from_po_id = from_po_id_;
END Remove_From_Dependency__;

PROCEDURE Remove_To_Dependency__ (
   to_po_id_ IN VARCHAR2 )
IS
BEGIN
   Trace_SYS.Field('to_po_id_', to_po_id_);
   DELETE FROM PRES_OBJECT_DEP_CHANGE_TAB
      WHERE to_po_id = to_po_id_;
END Remove_To_Dependency__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
