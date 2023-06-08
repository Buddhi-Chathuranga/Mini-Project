-----------------------------------------------------------------------------
--
--  Logical unit: FndJavaImplUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200305  KoDelk  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Post_Installation_Import (
   task_id_ IN VARCHAR2)
IS
   CURSOR get_javaimpl_files_ IS
      SELECT module, file_path, file_name, import_file_binary
      FROM lob_file_import
      WHERE task_id = task_id_
      AND file_path LIKE 'javaimpl%';
      
   projection_ fnd_java_implementations_tab.projection%TYPE;
BEGIN
   FOR rec_ IN get_javaimpl_files_ LOOP
      IF rec_.import_file_binary IS NOT NULL THEN
         -- Example file path can be something like javaimpl\ProjectionName or javaimpl-lib
         -- To identify and get the projection name we need to remove javaimpl\ or javaimpl- from the path.
         projection_ := SUBSTR(rec_.file_path, Length('javaimpl') + 2);
         IF projection_ = 'lib' THEN
            Fnd_Java_Impl_Libs_API.Import_Javaimpl_Lib_File(rec_.file_name, rec_.module, rec_.import_file_binary);
         ELSE
            Fnd_Java_Implementations_API.Import_Javaimpl_File(rec_.file_name, rec_.module, projection_, rec_.import_file_binary);
         END IF;
         Lob_File_Import_API.Delete_File(rec_.module, rec_.file_path, rec_.file_name, task_id_);
      END IF;
   END LOOP;
END Post_Installation_Import;

PROCEDURE Remove_Projection_Impls(
   projection_ VARCHAR2)
IS
BEGIN
   Fnd_Java_Implementations_API.Remove_Javaimpl_File(projection_);
END Remove_Projection_Impls;

-------------------- LU  NEW METHODS -------------------------------------
