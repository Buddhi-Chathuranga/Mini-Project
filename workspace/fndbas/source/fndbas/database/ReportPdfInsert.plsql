-----------------------------------------------------------------------------
--
--  Logical unit: ReportPdfInsert
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  061128  UTGULK Created to support duplex printing (Bug#61770).
--  130905  MABALK QA Script Cleanup - PrivateInterfaces (Bug #112227
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT REPORT_PDF_INSERT_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Check_Unique_File_Name___(newrec_.file_name);
   IF (newrec_.id IS NULL) THEN
      newrec_.id  := sys_guid;
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPORT_PDF_INSERT_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.file_date := sysdate;
   IF (newrec_.id IS NULL) THEN
      newrec_.id  := sys_guid;
   END IF;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     REPORT_PDF_INSERT_TAB%ROWTYPE,
   newrec_ IN OUT REPORT_PDF_INSERT_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Check_Unique_File_Name___(newrec_.file_name);
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

@Override
PROCEDURE Write_Pdf__ (
   objversion_ IN OUT NOCOPY VARCHAR2,
   rowid_      IN     ROWID,
   lob_loc_    IN     BLOB )
IS
   newrec_  REPORT_PDF_INSERT_TAB%ROWTYPE;
   oldrec_  REPORT_PDF_INSERT_TAB%ROWTYPE;
   attr_    VARCHAR2(32000);
BEGIN
   oldrec_ := Lock_By_Id___(rowid_, objversion_);
   newrec_ := oldrec_;
   newrec_.file_date := sysdate;
   Client_SYS.Clear_Attr(attr_);
   Update___(rowid_, oldrec_, newrec_, attr_, objversion_);
   super(objversion_, rowid_, lob_loc_);
END Write_Pdf__;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New_Row (
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   file_name_   IN  VARCHAR2 )
IS
   attr_ VARCHAR2(2000);
   newrec_ REPORT_PDF_INSERT_TAB%ROWTYPE;
   indrec_ Indicator_Rec;
BEGIN
   Client_SYS.Add_To_Attr('FILE_NAME', file_name_, attr_);
	Unpack___(newrec_, indrec_, attr_);
   Check_Insert___(newrec_, indrec_, attr_); 
   Insert___(objid_, objversion_, newrec_, attr_);
END New_Row;

PROCEDURE Get_Id_Version_By_Keys__ (
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   id_         IN  VARCHAR2 )
IS
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_,id_);
   
END Get_Id_Version_By_Keys__;

   
PROCEDURE Check_Unique_File_Name___ (
   file_name_    IN VARCHAR2 )
IS
   temp_ VARCHAR2(32000);
   CURSOR find_unique_ IS
      SELECT file_name
      FROM   REPORT_PDF_INSERT_TAB
      WHERE  file_name = file_name_;
BEGIN
   OPEN find_unique_;
   FETCH find_unique_ INTO temp_;
   IF find_unique_%FOUND THEN
      CLOSE find_unique_;
      Error_SYS.Record_Exist(lu_name_, 'FILENAMEEXIST: File name :P1 already exist, change it to something different.', file_name_);
   END IF;
   CLOSE find_unique_;
END Check_Unique_File_Name___;



