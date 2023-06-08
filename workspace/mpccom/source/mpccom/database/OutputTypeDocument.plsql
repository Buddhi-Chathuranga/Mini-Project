-----------------------------------------------------------------------------
--
--  Logical unit: OutputTypeDocument
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170717	niedlk	SCUXX-420, Added function Output_Type_Document_Exist to check if there are document texts
--  170717			   for the given note_id and document_code.
--  100429  Ajpelk   Merge rose method documentation
--  090206  HoInlk   Bug 74925, Added function Check_Exist.
--  060117  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060117           according to the new template.
--  050811  Cpeilk   Bug 52501, Add a new method Get_Output_Type_Tab.
--  050311  SaLalk   Bug 49920, Add a oder by clause to get_output_types cursor in
--  050311           Get_Output_Type_List method.
--  040224  SaNalk   Removed SUBSTRB.
--  ------------------------------- 13.3.0 ----------------------------------
--  001030  PERK     Changed substr to substrb in Get_Output_Type_List
--  000925  JOHESE   Added undefines.
--  990426  DAZA     General performance improvements.
--  990413  FRDI     Upgraded to performance optimized template.
--  971208  JOKE     Converted to Foundation1 2.0.0 (32-bit).
--  971016  LEPE     Added restriction saying that output_type 'PURCHASE' is not allowed.
--  970313  CHAN     Changed table name: output_document is replaced by
--                   output_type_document_tab
--  970227  PELA     Uses column rowersion as objversion (timestamp).
--  961214  JOKE     Modified with new workbench default templates.
--  961114  LEPE     Changes in Check_Delete___ for output type PURCHASE combined
--                   with document code 6.
--  961107  JOBE     Additional changes for compatibility with workbench.
--  961029  JOBE     Changed for compatibility with workbench.
--  960801  JOAN     Added function Get_Output_Type_List
--  960524  SHVE     Added method Get_Output_Type.
--  960523  JOHNI    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Output_Type_Table IS TABLE OF OUTPUT_TYPE_DOCUMENT_TAB.output_type%TYPE INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT output_type_document_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   IF (newrec_.output_type = 'PURCHASE') THEN
      Error_SYS.Record_General(lu_name_, 'INSNOTALLOWED: Output Type PURCHASE is not allowed');
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Output_Type
--   Get output type for specific document code.
@UncheckedAccess
FUNCTION Get_Output_Type (
   document_code_      IN VARCHAR2 ) RETURN VARCHAR2
IS
  CURSOR get_rec IS
   SELECT output_type
   FROM   OUTPUT_TYPE_DOCUMENT_TAB
   WHERE  document_code = document_code_;

  output_type_    OUTPUT_TYPE_DOCUMENT_TAB.output_type%TYPE;
BEGIN
  OPEN get_rec;
  FETCH get_rec INTO output_type_;
  IF get_rec%NOTFOUND THEN
   CLOSE get_rec;
   RETURN (NULL);
  END IF;
  CLOSE get_rec;
  RETURN output_type_;
END Get_Output_Type;


-- Get_Output_Type_List
--   Returns a semicolon separated list containing all output types defined for
--   the specified document code.
@UncheckedAccess
FUNCTION Get_Output_Type_List (
   document_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  output_type_list_ VARCHAR2(2000) := NULL;

  CURSOR get_output_types IS
     SELECT output_type
     FROM   OUTPUT_TYPE_DOCUMENT_TAB
     WHERE  document_code = document_code_
     ORDER BY output_type;

BEGIN
   FOR next_rec_ IN get_output_types LOOP
      IF (output_type_list_ IS NULL) THEN
         output_type_list_ := next_rec_.output_type;
      ELSE
         output_type_list_ := substr(output_type_list_ || ';' || next_rec_.output_type, 1, 2000);
      END IF;
   END LOOP;
   RETURN output_type_list_;
END Get_Output_Type_List;


-- Get_Output_Type_Tab
--   This method selects all the output types for a specific document code
--   and inserts it to a table and returns the table.
@UncheckedAccess
FUNCTION Get_Output_Type_Tab (
   document_code_ IN VARCHAR2 ) RETURN Output_Type_Table
IS
   output_type_tab_  Output_Type_Table;
   rec_rows_         NUMBER := 0;

   CURSOR get_output_types IS
      SELECT output_type
      FROM   OUTPUT_TYPE_DOCUMENT_TAB
      WHERE  document_code = document_code_
      ORDER BY output_type;

BEGIN
   FOR next_rec_ IN get_output_types LOOP
      output_type_tab_(rec_rows_) := next_rec_.output_type;
      rec_rows_ :=  rec_rows_ + 1;
   END LOOP;
   RETURN (output_type_tab_);
END Get_Output_Type_Tab;


@UncheckedAccess
FUNCTION Check_Exist (
   output_type_   IN VARCHAR2,
   document_code_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(output_type_, document_code_);
END Check_Exist;

@UncheckedAccess
FUNCTION Output_Type_Document_Exist (
   note_id_       IN VARCHAR2,
   document_code_ IN VARCHAR2 ) RETURN VARCHAR2 
IS
   dummy_ NUMBER;
   
   CURSOR get_out_type_doc_ IS
      SELECT 1
      FROM   document_text_tab doc
      WHERE  doc.note_id = note_id_
      AND EXISTS ( SELECT 1 
                   FROM   OUTPUT_TYPE_DOCUMENT_TAB output
                   WHERE  output.output_type = doc.output_type
                   AND    output.document_code = document_code_ );
BEGIN
   OPEN get_out_type_doc_;
   FETCH get_out_type_doc_ INTO dummy_;
   IF (get_out_type_doc_%FOUND) THEN
      CLOSE get_out_type_doc_;
      RETURN 'TRUE';
   END IF;
   CLOSE get_out_type_doc_;
   RETURN 'FALSE';
END Output_Type_Document_Exist;

