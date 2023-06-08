-----------------------------------------------------------------------------
--
--  Logical unit: DocumentText
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210915  Avjalk  SC21R2-2674, Modified Copy_All_Note_Texts() to call Check_Insert___() and Insert___() instead of New___().
--  210104  BudKlk  SC2020R1-11865, Removed Client_SYS.Add_To_Attr and made assignments directly to record where it is possible.
--  170921  ShPrlk  Bug 135033, Re-structured Copy_All_Note_Texts() to improve the performance.
--  150223  SURBLK  Added Replace_Note_Text() to remove document text by keys.
--  140714  PraWlk  PRSC-1040, Re-structurd the code to handle the validations done via insert_from_client_ correcltly.
--  140507  ChJalk  PBSC-4784, Removed the overloaded method Get_Note_Text.
--  140416  JeLise  Added newrec_.rowkey := NULL in Copy_Note_Text to not get the rowkey from the copied text.
--  130812  MaIklk  TIBE-931, Removed inst_DocumentTextUtilPurch_ global variable and used conditional compilation instead.
--  110815  TiRalk  Bug 98134, Modified Copy_Note_Text by removing method New__ and added Unpach_Check_Insert___,
--  110815          Insert___ instead to handle Client_Sys.Add_Info properly.
--  101203  SaLalk  Added insert_from_client_ as a parameter to Check_Delete___(), Copy_All_Note_Texts(),
--  101203          Remove_Note(), New_Note_Text() and Unpack_Check_Insert___().
--  100914  SaLalk  Added assert safe for dynamic SQL Statements. 
--  100913  SaLalk  Modified Unpack_Check_Update___(), Unpack_Check_Insert___() and Check_Delete___().
--  100429  Ajpelk  Merge rose method documentation
------------------------------Eagle--------------------------------------------
--  080814  MaEelk  Bug 76340, Modified New_Note_Text and added output_type to the WHERE clause.
--  070913  AmNilk  Call Id: 148749. Modified Copy_All_Note_Texts().
--  070405  NiDalk  Bug 64114, Corrected the error in DOCNOTEXIST error message in Copy_All_Note_Texts
--  060111  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060111          according to the new template.
--  050919  NaLrlk  Removed unused variables.
--  050817  Cpeilk  Bug 52501, Modified method Get_All_Notes. Add a new method
--                  Get_All_Notes_Tab.
--  050512  ChJalk  Bug 51194, Modified PROCEDURE Remove_Note to remove all the records with a given note_id.
--  041217  SaRalk  Modified procedure Copy_All_Note_Texts.
--  041215  SaRalk  Changed default values of the parameters in procedure Copy_All_Note_Texts to FALSE.
--  041213  SaRalk  Modified procedure Copy_All_Note_Texts by adding 2 new error handling flags as IN parameters.
--  040224  SaNalk  Removed SUBSTRB.
--  -------------------------------- 13.3.0 -----------------------------------
--  001030  PERK    Changed substr to substrb in Get_All_Notes
--  000925  JOHESE  Added undefines.
--  000414  NISOSE  Cleaned-up General_SYS.Init_Method.
--  990422  JOHW    General performance improvements.
--  990414  JOHW    Upgraded to performance optimized template.
--  971121  TOOS    Upgrade to F1 2.0
--  970313  CHAN    Changed table name: notes is replaced by document_text_tab
--  970226  PELA    Uses column rowversion as objversion (timestamp) and removed
--                  replace commands which was needed by Forms3.
--  970124  MANI    Modifed cursor in Copy_All_Note_Texts.
--  970110  JOHNI   Added procedure Copy_All_Note_Texts.
--  961213  JOKE    Modified with new workbench default templates And added
--                  Copy_Note_Text.
--  961206  STOL    Added Init_Method trace = TRUE to procedure New_Note_Text.
--  961129  STOL    Added code to procedure - New_Note_Text.
--  961129  JOHNI   New public procedure - New_Note_Text.
--  961107  JOKE    Modified for compatibility with workbench.
--  960912  JoAn    Added function Get_All_Notes
--  960626  JOBE    Added LOV to Note_Text.
--  960607  JOED    Added function Note_Id_Exist and modified procedure
--                  Exist_Note_Id.
--  960606  AnAr    Added convertion for PhraseText.
--  960522  KERO    Added function Get_Next_Note_Id.
--  960517  AnAr    Added purpose comment to file.
--  960515  SHVE    Bug id 96-0114: Removed exception handling in Remove_Note.
--  960425  MPC5    Spec 96-0002 LONG-fields is replaced by VARCHAR2(2000).
--  960417  SHVE    Added define TRUE and FALSE from old track.
--  960412  SHVE    Added procedure Exist_Note_Id from the old track.
--  960327  SHVE    Added procedure Remove_Note.
--  960307  SHVE    Changed LU Name GenNotes.
--  960115  JOBR    Added function get_note
--  951120  OYME    Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Note_Text_Table IS TABLE OF DOCUMENT_TEXT_TAB.note_text%TYPE INDEX BY BINARY_INTEGER;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override 
PROCEDURE Check_Delete___ (
remrec_ IN     document_text_tab%ROWTYPE,
insert_from_client_  IN BOOLEAN DEFAULT TRUE)
IS
BEGIN
   --Add pre-processing code here
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (insert_from_client_) THEN
         Document_Text_Util_Purch_API.Check_Document_Text_Change(remrec_.note_id);      
      END IF;
   $END
   super(remrec_);
   --Add post-processing code here
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
newrec_ IN OUT document_text_tab%ROWTYPE,
indrec_ IN OUT Indicator_Rec,
attr_   IN OUT VARCHAR2, 
insert_from_client_  IN BOOLEAN DEFAULT TRUE)
IS
BEGIN
   --Add pre-processing code here
   super(newrec_, indrec_, attr_);
   $IF (Component_Purch_SYS.INSTALLED) $THEN
      IF (insert_from_client_) THEN
         Document_Text_Util_Purch_API.Check_Document_Text_Change(newrec_.note_id);      
      END IF;
   $END
   --Add post-processing code here
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     document_text_tab%ROWTYPE,
   newrec_ IN OUT document_text_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   $IF (Component_Purch_SYS.INSTALLED) $THEN
      Document_Text_Util_Purch_API.Check_Document_Text_Change(newrec_.note_id);          
   $END
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_All_Notes
--   Retrieve all note texts for the specified note id and document
@UncheckedAccess
FUNCTION Get_All_Notes (
   note_id_       IN NUMBER,
   document_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   output_type_tab_ Output_Type_Document_API.Output_Type_Table;
   notes_           VARCHAR2(2000);
   next_note_       VARCHAR2(2000);
BEGIN
   -- Retrieve the document text(s) if any
   -- The notes are concatenated into one single string
   notes_ := NULL;
   output_type_tab_ := Output_Type_Document_API.Get_Output_Type_Tab(document_code_);
   IF (output_type_tab_.COUNT > 0) THEN
      FOR n IN output_type_tab_.FIRST..output_type_tab_.LAST LOOP
         next_note_ := Document_Text_API.Get_Note_Text(output_type_tab_(n), note_id_);
         IF (next_note_ IS NOT NULL) THEN
            IF (notes_ IS NULL) THEN
               notes_ := next_note_;
            ELSE
               notes_ := SUBSTR(notes_ || CHR(13) || CHR(10) || next_note_, 1, 2000);
            END IF;
         END IF;
      END LOOP;
   END IF;
   RETURN notes_;
END Get_All_Notes;


PROCEDURE Remove_Note (
   note_id_            IN NUMBER,
   insert_from_client_ IN BOOLEAN DEFAULT TRUE )
IS
   remrec_     DOCUMENT_TEXT_TAB%ROWTYPE;
   objid_      DOCUMENT_TEXT.OBJID%TYPE;
   objversion_ DOCUMENT_TEXT.OBJVERSION%TYPE;

   CURSOR get_rec IS
      SELECT output_type
      FROM DOCUMENT_TEXT_TAB
      WHERE  note_id = note_id_;
BEGIN
   FOR rec_ IN get_rec LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, rec_.output_type, note_id_);
      remrec_ := Lock_By_Id___(objid_, objversion_);
      Check_Delete___(remrec_, insert_from_client_);
      Delete___(objid_,remrec_);
   END LOOP;
END Remove_Note;


PROCEDURE Replace_Note_Text (
   po_line_note_id_    IN NUMBER,
   co_line_note_id_    IN VARCHAR2 )
IS
   remrec_     DOCUMENT_TEXT_TAB%ROWTYPE;
   objid_      DOCUMENT_TEXT.OBJID%TYPE;
   objversion_ DOCUMENT_TEXT.OBJVERSION%TYPE;
   
   CURSOR get_output_types IS
      SELECT     output_type
      FROM       document_text_tab d
      WHERE      d.note_id = po_line_note_id_; 
BEGIN
   FOR output_type_  IN get_output_types LOOP 
      -- Delete notes in the CO by comparing output types
      IF(Check_Exist___(output_type_.OUTPUT_TYPE, co_line_note_id_)) THEN
         Get_Id_Version_By_Keys___(objid_, objversion_, output_type_.OUTPUT_TYPE, co_line_note_id_);
         remrec_ := Lock_By_Id___(objid_, objversion_);
         Check_Delete___(remrec_, FALSE);
         Delete___(objid_,remrec_);
      END IF;
   END LOOP;
   
   Document_Text_API.Copy_All_Note_Texts(po_line_note_id_, co_line_note_id_);
END Replace_Note_Text;

@UncheckedAccess
FUNCTION Note_Id_Exist (
   note_id_ IN NUMBER ) RETURN VARCHAR2
IS
   exist_ VARCHAR2(1);
   CURSOR exist_control IS
      SELECT '1'
      FROM DOCUMENT_TEXT
      WHERE note_id = note_id_
      AND   output_type != 'PURCHASE';
BEGIN
   OPEN exist_control;
   FETCH exist_control INTO exist_;
   IF exist_control%NOTFOUND THEN
      exist_ := '0';
   END IF;
   CLOSE exist_control;
   RETURN exist_;
END Note_Id_Exist;


@UncheckedAccess
FUNCTION Get_Next_Note_Id RETURN NUMBER
IS
   note_id_ NUMBER;
   CURSOR get_next_note_id IS
      SELECT note_id.nextval
      FROM dual;
BEGIN
   OPEN get_next_note_id;
   FETCH get_next_note_id INTO note_id_;
   CLOSE get_next_note_id;
   RETURN(note_id_);
END Get_Next_Note_Id;


PROCEDURE New_Note_Text (
   note_text_          IN OUT VARCHAR2,
   note_id_            IN     NUMBER,
   output_type_        IN     VARCHAR2,
   insert_from_client_ IN     BOOLEAN DEFAULT TRUE )
IS
   newrec_      DOCUMENT_TEXT_TAB%ROWTYPE;

   CURSOR source IS
      SELECT *
      FROM DOCUMENT_TEXT_TAB
      WHERE note_id = note_id_
      AND   output_type = output_type_
      FOR UPDATE ;
BEGIN
   OPEN source;
   FETCH source into newrec_;
   IF source%FOUND THEN
      newrec_.note_text := note_text_;
      Modify___(newrec_);
   ELSE      
      newrec_.note_id := note_id_;
      newrec_.output_type := output_type_;
      newrec_.note_text := note_text_;
      New___(newrec_);
   END IF;
   CLOSE source;
END New_Note_Text;


-- Copy_Note_Text
--   Copies all document texts for one note id to a new note id.
PROCEDURE Copy_Note_Text (
   note_id_             IN NUMBER,
   output_type_         IN VARCHAR2,
   destination_note_id_ IN NUMBER )
IS
   no_such_note     EXCEPTION;
   newrec_          DOCUMENT_TEXT_TAB%ROWTYPE;

   CURSOR source IS
      SELECT *
      FROM DOCUMENT_TEXT_TAB
      WHERE note_id = note_id_
      AND output_type = output_type_;
BEGIN
   IF NOT Check_Exist___ (output_type_, note_id_) THEN
      RAISE no_such_note;
   END IF;

   OPEN source;
   FETCH source INTO newrec_;
   CLOSE source;

   newrec_.rowkey := NULL;   
   newrec_.note_id := destination_note_id_;
   newrec_.output_type := output_type_;
   newrec_.note_text := newrec_.note_text;
   New___(newrec_);
EXCEPTION
   WHEN no_such_note THEN
      Error_SYS.Record_General('DocumentText', 'NOSUCHNOTE: The Note does not exist.');
END Copy_Note_Text;


-- Copy_All_Note_Texts
--   Copy all note texts for note id.
PROCEDURE Copy_All_Note_Texts (
   note_id_                  IN NUMBER,
   destination_note_id_      IN NUMBER,
   error_when_no_source_     IN VARCHAR2 DEFAULT 'FALSE',
   error_when_existing_copy_ IN VARCHAR2 DEFAULT 'TRUE',
   insert_from_client_       IN BOOLEAN  DEFAULT  TRUE )
IS 
   newrec_       DOCUMENT_TEXT_TAB%ROWTYPE;
   oldrec_found_ BOOLEAN := FALSE;
   attr_         VARCHAR2(32000);
   objid_        VARCHAR2(20);
   objversion_   VARCHAR2(2000);
   emptyrec_     DOCUMENT_TEXT_TAB%ROWTYPE; 
   indrec_       Indicator_Rec;
   
   TYPE Document_Text_Record_Tab IS TABLE OF document_text_tab%ROWTYPE 
   INDEX BY PLS_INTEGER;
   document_text_record_tab_     Document_Text_Record_Tab;
   
      CURSOR get_all_data IS
      SELECT *
        FROM document_text_tab
       WHERE note_id      =  note_id_
         AND output_type != 'PURCHASE';
         
      CURSOR get_non_existing_data IS
      SELECT *
        FROM document_text_tab t1
       WHERE note_id      =  note_id_
         AND output_type != 'PURCHASE'
         AND NOT EXISTS ( SELECT 1
                          FROM  document_text_tab
                          WHERE output_type  = t1.output_type
                          AND   note_id      = destination_note_id_);                          
BEGIN
   IF (error_when_existing_copy_ = 'TRUE') THEN
      OPEN get_all_data;
      FETCH get_all_data BULK COLLECT INTO document_text_record_tab_;
      CLOSE get_all_data;
   ELSE
      OPEN get_non_existing_data;
      FETCH get_non_existing_data BULK COLLECT INTO document_text_record_tab_;
      CLOSE get_non_existing_data;
   END IF;
   
   IF (document_text_record_tab_.COUNT > 0) THEN
      oldrec_found_ := TRUE;
      FOR i IN document_text_record_tab_.FIRST..document_text_record_tab_.LAST LOOP 
         newrec_.note_id      := destination_note_id_;
         newrec_.output_type  := document_text_record_tab_(i).output_type;
         newrec_.note_text    := document_text_record_tab_(i).note_text;
         
         indrec_ := Get_Indicator_Rec___(emptyrec_, newrec_);
         Check_Insert___(newrec_, indrec_, attr_, insert_from_client_);
         Insert___(objid_, objversion_, newrec_, attr_);
      END LOOP;
   END IF;   
   
   IF ((NOT oldrec_found_) AND (error_when_no_source_ = 'TRUE')) THEN
      Error_SYS.Record_General(lu_name_, 'DOCNOTEXIST: Document texts do not exist for note id :P1', note_id_);
   END IF;   
END Copy_All_Note_Texts;


-- Get_All_Notes_Tab
--   This method is similar to Get_All_Notes. The difference is it returns all the
--   connected notes using a table.
@UncheckedAccess
FUNCTION Get_All_Notes_Tab (
   note_id_       IN NUMBER,
   document_code_ IN VARCHAR2 ) RETURN Note_Text_Table
IS
   output_type_tab_ Output_Type_Document_API.Output_Type_Table;
   notes_tab_       Note_Text_Table;
   next_note_       VARCHAR2(2000);
   rec_rows_        NUMBER := 0;
BEGIN
   output_type_tab_ := Output_Type_Document_API.Get_Output_Type_Tab(document_code_);
   IF (output_type_tab_.COUNT > 0) THEN
      FOR n IN output_type_tab_.FIRST..output_type_tab_.LAST LOOP
         next_note_ := Document_Text_API.Get_Note_Text(output_type_tab_(n), note_id_);
         IF (next_note_ IS NOT NULL) THEN
            notes_tab_(rec_rows_) := next_note_;
            rec_rows_ := rec_rows_ + 1;
         END IF;
      END LOOP;
   END IF;
   RETURN notes_tab_;
END Get_All_Notes_Tab;



