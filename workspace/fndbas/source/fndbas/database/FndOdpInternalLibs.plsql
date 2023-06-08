-----------------------------------------------------------------------------
--
--  Logical unit: FndOdpInternalLibs
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
PROCEDURE Import_Fnd_Odp_Internal_Libs(
   file_name_ IN VARCHAR2,
   module_    IN VARCHAR2,
   content_   IN BLOB)
IS
   newrec_ fnd_odp_internal_libs_tab%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(file_name_);
   newrec_.file_name    := file_name_;
   newrec_.module       := module_;
   newrec_.content      := content_;

   IF Check_Exist___(file_name_) THEN
      Modify___(newrec_);
   ELSE
      New___(newrec_); 
   END IF;  
END Import_Fnd_Odp_Internal_Libs;

PROCEDURE Post_Installation_Import (
   task_id_ IN VARCHAR2)
IS
   CURSOR get_fnd_odp_internal_libs IS
      SELECT module, file_path, file_name, import_file_binary
      FROM lob_file_import
      WHERE task_id = task_id_
      AND file_path LIKE 'fnd_odp_internal_libs%';
BEGIN
   FOR rec_ IN get_fnd_odp_internal_libs LOOP 
      IF rec_.import_file_binary IS NOT NULL THEN
         Fnd_Odp_Internal_Libs_API.Import_Fnd_Odp_Internal_Libs(rec_.file_name, rec_.module, rec_.import_file_binary);
         Lob_File_Import_API.Delete_File(rec_.module, rec_.file_path, rec_.file_name, task_id_);
      END IF;
   END LOOP;
END Post_Installation_Import;
