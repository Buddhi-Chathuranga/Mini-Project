-----------------------------------------------------------------------------
--
--  Logical unit: FndJavaImplementations
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
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT fnd_java_implementations_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   
   IF Fnd_Java_Impl_Libs_API.Exists(newrec_.file_name) THEN
      Error_SYS.Record_General(lu_name_, 'DUP_LIB_FILE_NAME: Library file already exists with the same file name :P1', newrec_.file_name);
   END IF;
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Import_Javaimpl_File(
   file_name_  IN VARCHAR2,
   module_     IN VARCHAR2,
   projection_ IN VARCHAR2,
   content_    IN BLOB)
IS
   newrec_ fnd_java_implementations_tab%ROWTYPE;
BEGIN
   newrec_ := Fnd_Java_Implementations_API.Get_Object_By_Keys___(file_name_);

   newrec_.file_name    := file_name_;
   newrec_.module       := module_;
   newrec_.projection   := projection_;
   newrec_.content      := content_;

   IF Fnd_Java_Implementations_API.Exists(file_name_) THEN
      Modify___(newrec_);
   ELSE
      New___(newrec_); 
   END IF;  
END Import_Javaimpl_File;

PROCEDURE Remove_Javaimpl_File(
   projection_ VARCHAR2)
IS
   CURSOR get_impls_ IS
   SELECT file_name
   FROM fnd_java_implementations
   WHERE projection = projection_;
   
   remrec_ fnd_java_implementations_tab%ROWTYPE;
BEGIN
   FOR rec_ IN get_impls_ LOOP
      remrec_.file_name := rec_.file_name;
      Remove___(remrec_);
   END LOOP;
END Remove_Javaimpl_File;
