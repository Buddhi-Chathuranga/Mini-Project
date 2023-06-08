-----------------------------------------------------------------------------
--
--  Logical unit: FinNote
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  041213  NiFelk  Created.
--  050208  NiFelk  FIPR360, Added methods Get_New_Note_Id, Create_Note and Remove_Note.
--  050216  NiFelk  FIPR360, Removed dynamic calls from Create_Note and Remove_Note;
--  051214  NiFelk  FIPR360, Modified in Remove_Note
--  210219  Hecolk  FISPRING20-8730, Get rid of string manipulations in db - Modified in method Copy_Note     
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                     
-------------------- PRIVATE DECLARATIONS -----------------------------------
                     
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_New_Note_Id RETURN NUMBER
IS
   CURSOR get_note_id IS
      SELECT fin_note_id_seq.NEXTVAL
      FROM   dual;
   note_id_    NUMBER;
BEGIN
   OPEN  get_note_id;
   FETCH get_note_id INTO note_id_;
   CLOSE get_note_id;
   RETURN note_id_;
END Get_New_Note_Id;


PROCEDURE Create_Note (
   note_id_ IN NUMBER )
IS
   newrec_    fin_note_tab%ROWTYPE;
BEGIN
   newrec_.note_id := note_id_;
   New___(newrec_);
END Create_Note;


PROCEDURE Remove_Note (
   note_id_ IN NUMBER )
IS
   obj_id_         ROWID;
   obj_version_    VARCHAR2(2000);
   info_           VARCHAR2(2000);
BEGIN
   IF (note_id_ IS NOT NULL) THEN
      Get_Id_Version_By_Keys___(obj_id_, obj_version_, note_id_); 
      Remove__(info_, obj_id_, obj_version_, 'DO');
   END IF;
END Remove_Note;


PROCEDURE Copy_Note (
   from_note_id_ IN NUMBER,
   to_note_id_   IN NUMBER )
IS
   info_          VARCHAR2(2000);
   newrec_        fin_note_text_tab%ROWTYPE;  
   CURSOR get_note_text_ IS
      SELECT *
      FROM   fin_note_text_tab
      WHERE  note_id = from_note_id_;
BEGIN
   IF (to_note_id_ IS NOT NULL) THEN
      FOR rec_ IN get_note_text_ LOOP
         info_             := NULL;
         newrec_           := NULL;
         newrec_.note_id   := to_note_id_;
         newrec_.timestamp := rec_.timestamp;
         newrec_.user_id   := rec_.user_id;
         newrec_.text      := rec_.text;
         Fin_Note_Text_API.New_Rec(info_, newrec_);
      END LOOP;
   END IF;
END Copy_Note;