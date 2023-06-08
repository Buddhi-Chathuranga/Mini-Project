-----------------------------------------------------------------------------
--
--  Logical unit: LobFileImport
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE lob_file_import_cursor_rec IS RECORD
(
   file_id                        LOB_FILE_IMPORT_TAB.file_id%TYPE,
   import_file_text               LOB_FILE_IMPORT_TAB.import_file_text%TYPE,
   import_file_binary             LOB_FILE_IMPORT_TAB.import_file_binary%TYPE,
   task_id                        LOB_FILE_IMPORT_TAB.task_id%TYPE,
   module                         LOB_FILE_IMPORT_TAB.module%TYPE,
   file_path                      LOB_FILE_IMPORT_TAB.file_path%TYPE,
   file_name                      LOB_FILE_IMPORT_TAB.file_name%TYPE,
   file_date                      LOB_FILE_IMPORT_TAB.file_date%TYPE,
   processed                      LOB_FILE_IMPORT_TAB.processed%TYPE,
   created_by                     LOB_FILE_IMPORT_TAB.file_id%TYPE,
   created_date                   LOB_FILE_IMPORT_TAB.created_date%TYPE
);

CURSOR get_lob_files (task_id_ VARCHAR2, module_ VARCHAR2, file_path_ VARCHAR2) RETURN lob_file_import_cursor_rec IS
   SELECT file_id,
          import_file_text,
          import_file_binary,
          task_id,
          module,
          file_path,
          file_name,
          file_date,
          processed,
          created_by,
          created_date
   FROM lob_file_import_tab
   WHERE task_id = task_id_
   AND module = module_
   AND file_path = file_path_;
   
TYPE lob_file_import_cursor_tab IS TABLE OF lob_file_import_cursor_rec
      INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT lob_file_import_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := sysdate;
   newrec_.task_id := NVL(newrec_.task_id, sys_guid());     
   newrec_.file_id := NVL(newrec_.file_id, sys_guid());     
   super(newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr('FILE_ID', newrec_.file_id, attr_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Bulk_Import_ (
   task_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   stmt_  VARCHAR2(1000);
   error_ VARCHAR2(5) := 'FALSE';
   CURSOR get_procedure IS
      SELECT object_name || '.' || procedure_name procedure_name
        FROM user_procedures v
       WHERE v.procedure_name = 'POST_INSTALLATION_IMPORT';
BEGIN
   FOR rec IN get_procedure LOOP
      BEGIN
         stmt_ := 'BEGIN ' || rec.procedure_name || '(''' || task_id_ || '''); END;';
         @ApproveDynamicStatement(2020-01-10,MABOSE)
         EXECUTE IMMEDIATE stmt_;
         @ApproveTransactionStatement(2020-02-19,MABOSE)
         COMMIT;
      EXCEPTION
         WHEN OTHERS THEN
            error_ := 'TRUE';
            Dbms_Output.Put_Line('Error in '||rec.procedure_name||' during Lob file Import processing.');
            Dbms_Output.Put_Line(SQLERRM);
      END;
   END LOOP;
   RETURN error_;
END Bulk_Import_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import_Blob_File (
   file_name_  IN VARCHAR2,
   module_     IN VARCHAR2,
   file_path_  IN VARCHAR2,
   file_date_  IN DATE,
   task_id_    IN VARCHAR2,
   file_       IN BLOB ) 
IS
   newrec_  lob_file_import_tab%ROWTYPE;
BEGIN
   Prepare_New___(newrec_);
   newrec_.file_name := file_name_;
   newrec_.module := module_;
   newrec_.file_path := file_path_;
   newrec_.file_date := file_date_;
   newrec_.task_id := task_id_;
   newrec_.processed := 0;
   newrec_.import_file_binary := file_;
   New___(newrec_);
END Import_Blob_File;

PROCEDURE Import_Blob_File (
   file_name_  IN VARCHAR2,
   module_     IN VARCHAR2,
   file_path_  IN VARCHAR2,
   file_date_  IN VARCHAR2,
   task_id_    IN VARCHAR2,
   file_       IN BLOB ) 
IS
BEGIN
   Import_Blob_File(file_name_, module_, file_path_, TO_DATE(file_date_, 'MM/dd/yyyy HH24:MI:SS'), task_id_, file_); 
END Import_Blob_File;

PROCEDURE Import_Clob_File (
   file_name_  IN VARCHAR2,
   module_     IN VARCHAR2,
   file_path_  IN VARCHAR2,
   file_date_  IN DATE,
   task_id_    IN VARCHAR2,
   file_       IN CLOB ) 
IS
   newrec_  lob_file_import_tab%ROWTYPE;
BEGIN
   Prepare_New___(newrec_);
   newrec_.file_name := file_name_;
   newrec_.module := module_;
   newrec_.file_path := file_path_;
   newrec_.file_date := file_date_;
   newrec_.task_id := task_id_;
   newrec_.processed := 0;
   newrec_.import_file_text := file_;
   New___(newrec_);
END Import_Clob_File;

PROCEDURE Import_Clob_File (
   file_name_  IN VARCHAR2,
   module_     IN VARCHAR2,
   file_path_  IN VARCHAR2,
   file_date_  IN VARCHAR2,
   task_id_    IN VARCHAR2,
   file_       IN CLOB ) 
IS
BEGIN
   Import_Clob_File(file_name_, module_, file_path_, TO_DATE(file_date_, 'MM/dd/yyyy HH24:MI:SS'), task_id_, file_); 
END Import_Clob_File;

PROCEDURE Delete_File (
   module_    IN VARCHAR2,
   file_path_ IN VARCHAR2,
   file_name_ IN VARCHAR2,
   task_id_   IN VARCHAR2 )
IS
BEGIN
   DELETE 
      FROM  lob_file_import_tab
      WHERE module = module_
      AND   file_path = file_path_
      AND   file_name = file_name_
      AND   task_id = task_id_;
EXCEPTION
   WHEN no_data_found THEN
      NULL;
END Delete_File;

FUNCTION Get_File_Blob (
   module_    IN VARCHAR2,
   file_path_ IN VARCHAR2,
   file_name_ IN VARCHAR2,
   task_id_   IN VARCHAR2 ) RETURN BLOB
IS
   temp_ lob_file_import_tab.import_file_binary%TYPE;
BEGIN
   IF (module_ IS NULL
   OR  file_path_ IS NULL
   OR  file_name_ IS NULL
   OR  task_id_ IS NULL ) THEN
      RETURN NULL;
   END IF;
   SELECT import_file_binary
      INTO  temp_
      FROM  lob_file_import_tab
      WHERE module = module_
      AND   file_path = file_path_
      AND   file_name = file_name_
      AND   task_id = task_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Error_SYS.Fnd_Too_Many_Rows(Lob_File_Import_API.lu_name_, 'Get_File_Blob', NULL);
END Get_File_Blob;

FUNCTION Get_File_Clob (
   module_    IN VARCHAR2,
   file_path_ IN VARCHAR2,
   file_name_ IN VARCHAR2,
   task_id_   IN VARCHAR2 ) RETURN CLOB
IS
   temp_ lob_file_import_tab.import_file_text%TYPE;
BEGIN
   IF (module_ IS NULL
   OR  file_path_ IS NULL
   OR  file_name_ IS NULL
   OR  task_id_ IS NULL ) THEN
      RETURN NULL;
   END IF;
   SELECT import_file_text
      INTO  temp_
      FROM  lob_file_import_tab
      WHERE module = module_
      AND   file_path = file_path_
      AND   file_name = file_name_
      AND   task_id = task_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Error_SYS.Fnd_Too_Many_Rows(Lob_File_Import_API.lu_name_, 'Get_File_Clob', NULL);
END Get_File_Clob;

