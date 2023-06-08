-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectDependency
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000225  PeNi  Modified Unpack_Check_Update__
--  000227  PeNi  Added Remove_Dependency
--  000403  PeNi  Altered table.
--  000502  PeNi  Added logic for "Modified".
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030616  ROOD  Added cascade references for from_po_id and to_po_id.
--                Added Remove_To_Dependency__. Renamed Remove_Dependency
--                to Remove_From_Dependency__ (Bug#36465).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050110  ROOD  Replaced column from_module with column module (Bug#47476).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
--  -------------------------------------------------------------------------
--  121226  USRA  Added validation for INFO_TYPE (Bug#106173).
-----------------------------------------------------------------------------


layer Core;


-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE table_rec IS pres_object_dependency_tab%ROWTYPE;

-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('INFO_TYPE', 'Manual', attr_);
END Prepare_Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT pres_object_dependency_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
   IF (Validate_SYS.Is_Changed(NULL, newrec_.info_type, indrec_.info_type)) THEN
      Validate_Info_Type___(newrec_.info_type);
   END IF;
END Check_Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     pres_object_dependency_tab%ROWTYPE,
   newrec_ IN OUT pres_object_dependency_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.from_po_id IS NOT NULL)
   AND (indrec_.from_po_id)
   AND (Validate_SYS.Is_Changed(oldrec_.from_po_id, newrec_.from_po_id)) THEN
      IF newrec_.pres_object_dep_type NOT IN ('2', '12') THEN 
         Pres_Object_API.Exist(newrec_.from_po_id);
      END IF;
   END IF;
/*
   IF (newrec_.to_po_id IS NOT NULL)
   AND (indrec_.to_po_id)
   AND (Validate_SYS.Is_Changed(oldrec_.to_po_id, newrec_.to_po_id)) THEN
      IF newrec_.pres_object_dep_type != '2' THEN 
         Pres_Object_API.Exist(newrec_.to_po_id);
      END IF;
   END IF;
*/
END Check_Common___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRES_OBJECT_DEPENDENCY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Pres_Object_API.Set_Change_Date(newrec_.from_po_id);
END Insert___;


-----------------------------------------------------------------------------
-------------------- IMPLEMENTATION BASE METHODS FOR DELETE -----------------
-----------------------------------------------------------------------------
-- Delete___
--    Deletion of the specific LU-object from the database.
-----------------------------------------------------------------------------

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN PRES_OBJECT_DEPENDENCY_TAB%ROWTYPE )
IS
BEGIN
   super(objid_, remrec_);
   Pres_Object_API.Set_Change_Date(remrec_.from_po_id);
END Delete___;

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

-- Remove_From_Dependency__
--    Removes all dependencies for the defined from_po_id.
PROCEDURE Remove_From_Dependency__ (
   from_po_id_ IN VARCHAR2 )
IS
BEGIN
   Trace_SYS.Field('from_po_id_', from_po_id_);
   DELETE FROM PRES_OBJECT_DEPENDENCY_TAB
      WHERE from_po_id = from_po_id_;
END Remove_From_Dependency__;

PROCEDURE Remove_To_Dependency__ (
   to_po_id_ IN VARCHAR2 )
IS
BEGIN
   Trace_SYS.Field('to_po_id_', to_po_id_);
   DELETE FROM PRES_OBJECT_DEPENDENCY_TAB
      WHERE to_po_id = to_po_id_;
END Remove_To_Dependency__;

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

PROCEDURE New_Pres_Object_Dependency (
   from_po_id_    IN VARCHAR2,
   to_po_id_      IN VARCHAR2,
   pres_object_dep_type_  IN VARCHAR2,
   info_type_     IN VARCHAR2 )
IS
   rec_ table_rec := Get_Object_By_Keys___(from_po_id_, to_po_id_, pres_object_dep_type_);
BEGIN
   --
   -- Insert or update the record
   --
   rec_.from_po_id := from_po_id_;
   rec_.to_po_id := to_po_id_;
   rec_.pres_object_dep_type := pres_object_dep_type_;
   rec_.info_type := info_type_;
   Create_Or_Replace(rec_);
END New_Pres_Object_Dependency;
