-----------------------------------------------------------------------------
--
--  Logical unit: FndZipUtil
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

PROCEDURE Compress_Files ( 
   zip_               BLOB,
   filename_arr_      Fnd_Zip_Util_String_Table,
   filecontent_arr_   Fnd_Zip_Util_Blob_Table)
AS LANGUAGE JAVA NAME 'fndZipUtilJavaImpl.compressFiles(java.sql.Blob, java.sql.Array, java.sql.Array)';

PROCEDURE Zip_Files ( 
   zip_               BLOB,
   file_obj_          FND_ZIP_OBJECT_TAB)
AS LANGUAGE JAVA NAME 'FndZipUtilImpl.zipFiles(java.sql.Blob, java.sql.Array)';

-------------------- LU  NEW METHODS -------------------------------------

