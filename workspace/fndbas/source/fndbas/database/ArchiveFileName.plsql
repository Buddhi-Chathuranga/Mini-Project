-----------------------------------------------------------------------------
--
--  Logical unit: ArchiveFileName
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  981019  MANY  Fixed some translations to better conform with US English (ToDo #2746)
--  020312  ROOD  Added method Clear (Bug#22732). Updated to new template.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Set_Pdf_File_Name (
   result_key_    IN NUMBER,
   lang_code_     IN VARCHAR2,
   pdf_file_name_ IN VARCHAR2 )
IS
   attr_       VARCHAR2(2000);
   oldrec_     ARCHIVE_FILE_NAME_TAB%ROWTYPE;
   newrec_     ARCHIVE_FILE_NAME_TAB%ROWTYPE;
   indrec_     Indicator_Rec;
   objid_      ARCHIVE_FILE_NAME.objid%TYPE;
   objversion_ ARCHIVE_FILE_NAME.objversion%TYPE;
BEGIN
   Client_SYS.Clear_Attr(attr_);
   IF (NOT Check_Exist___(result_key_, lang_code_)) THEN
      Client_SYS.Add_To_Attr('RESULT_KEY',result_key_, attr_);
      Client_SYS.Add_To_Attr('LANG_CODE',upper(lang_code_), attr_);
      Client_SYS.Add_To_Attr('PDF_FILE_NAME',pdf_file_name_, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   ELSE
      Client_SYS.Add_To_Attr('PDF_FILE_NAME',pdf_file_name_, attr_);
      oldrec_ := Lock_By_Keys___(result_key_, lang_code_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE); -- by keys
   END IF;
END Set_Pdf_File_Name;


-- Clear
--   Clear all instances of ArchiveFileName for the specified result key.
--   Will not raise an exception if no instance do exist.
PROCEDURE Clear (
   result_key_ IN NUMBER )
IS
BEGIN
   DELETE FROM ARCHIVE_FILE_NAME_TAB
      WHERE result_key = result_key_;
EXCEPTION
   -- This method is called from cleanup routine and should not raise any exception
   WHEN no_data_found THEN
      NULL;
END Clear;



