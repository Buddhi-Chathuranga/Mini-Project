-----------------------------------------------------------------------------
--
--  Logical unit: PdfArchive
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030905  MAOL  Added view that combines old and new PDF archive.
--  040205  RAKU  Added method Clear. (Bug#41529).
--  040303  DOZE  Added connection to print_job
--  050414  MAOL  Changed view to only show entries associated with report data
--                available to the specific user. (Bug#50664)
--  050627  DOZE  Rewritten the security part of view and added a created column (Bug#51610)
--  051123  DOZE  Added xml_header and xml_footer
--  060313  CHAA  Emailing Report Designer type report
--  140129  AsiWLK   Merged LCS-111925
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
  
PROCEDURE Insert_Pdf_Format_Ba_Report_(
   report_id_  IN VARCHAR2,
   rowversion_ IN DATE,
   result_key_ IN NUMBER,
   id_         IN VARCHAR2,
   pdf_size_	IN NUMBER,
   pdf_	      IN BLOB)
   
IS
   report_mode_ VARCHAR2(30);
   BEGIN
   report_mode_ := Report_Definition_API.Get_Report_Mode(report_id_);
      IF (report_mode_ = 'EXCEL1.0') THEN
      INSERT INTO PDF_ARCHIVE_TAB(ROWVERSION,RESULT_KEY, ID, PDF_SIZE, PDF)
      VALUES(rowversion_,result_key_,id_,pdf_size_,pdf_);
      END IF;
   END Insert_Pdf_Format_Ba_Report_;
   
-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Id (
   result_key_ IN NUMBER,
   print_job_id_ IN NUMBER ) RETURN PDF_ARCHIVE_TAB.ID%TYPE
IS
   temp_ PDF_ARCHIVE_TAB.ID%TYPE;
   CURSOR get_attr IS
      SELECT id
      FROM   PDF_ARCHIVE_TAB
      WHERE  result_key            = result_key_
      AND    ((print_job_id_ IS NULL ) OR  (NVL(print_job_id, -1) = NVL(print_job_id_, -1)))
      ORDER BY rowversion DESC NULLS LAST;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Id;

@UncheckedAccess
FUNCTION Get_Mime_type (
   result_key_ IN NUMBER,
   id_ IN VARCHAR2) RETURN VARCHAR2
IS
   file_name_ VARCHAR2(4000);
   mime_type_ VARCHAR2(500);
   CURSOR get_file_name_ IS
    SELECT file_name 
    FROM PDF_ARCHIVE_TAB
    WHERE result_key = result_key_ 
    AND id = id_;
    
BEGIN
   OPEN get_file_name_;
   FETCH get_file_name_ INTO file_name_;
   IF get_file_name_%FOUND THEN
      IF file_name_ LIKE '%.pdf' THEN
         mime_type_ := 'application/pdf';
      ELSIF file_name_ LIKE '%.xml' THEN
         mime_type_ := 'application/xml';
      ELSIF file_name_ LIKE '%.csv' THEN
         mime_type_ := 'application/vnd.ms-excel';
      ELSE
         mime_type_ := 'application/octet-stream'; -- binary data true type unkonwn 
      END IF;
   ELSE
      mime_type_ := 'application/octet-stream'; -- binary data true type unkonwn 
   END IF;
   CLOSE get_file_name_;
   RETURN mime_type_;
END;


PROCEDURE Clear (
   result_key_ IN NUMBER )
IS
BEGIN
   DELETE
      FROM PDF_ARCHIVE_TAB
      WHERE result_key = result_key_;
END Clear;



