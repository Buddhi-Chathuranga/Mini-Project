-----------------------------------------------------------------------------
--
--  Logical unit: FinNoteText
--  Component:    ENTERP
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  041213  NiFelk  Created.
--  050208  NiFelk  FIPR360, Added method Get_Next_Row_No___.
--  050315  NiFelk  FIPR360, Added method Remove_Note_Text.
--  050513  Samclk  FIPR360, Added method Create_Note.
--  050714  Hecolk  LCS Merge 50272
--  051214  NiFelk  FIPR360, Modified in Remove_Note_Text.
--  060531  Iswalk  B128035, modified both unpacking methods.
--  070208  Shsalk  LCS Merge 63135, Change the user_id_ Variable length.
--  070314  Vohelk  FIPL638A, Added Get_Note_Text
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
                    
-------------------- PRIVATE DECLARATIONS -----------------------------------
                    
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Next_Row_No___ RETURN NUMBER
IS   
   row_no_   NUMBER;
   CURSOR get_row_no IS
      SELECT fin_note_row_no_seq.NEXTVAL
      FROM   dual;
BEGIN
   OPEN  get_row_no;
   FETCH get_row_no INTO row_no_;
   CLOSE get_row_no;
   RETURN row_no_;
END Get_Next_Row_No___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fin_note_text_tab%ROWTYPE,
   newrec_ IN OUT fin_note_text_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.timestamp := NVL(newrec_.timestamp, SYSDATE);
   newrec_.user_id := NVL(newrec_.user_id, Fnd_Session_API.Get_Fnd_User);      
   super(oldrec_, newrec_, indrec_, attr_);   
END Check_Common___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN fin_note_text_tab%ROWTYPE )
IS
   cascade_       VARCHAR2(5);
   fnd_user_      VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN   
   super(remrec_);
   cascade_ := App_Context_SYS.Find_Value(lu_name_ ||'.CASCADE_NOTE', 'FALSE');
   IF (cascade_ = 'FALSE') THEN
      IF (remrec_.user_id != fnd_user_) THEN
         Error_SYS.Record_General(lu_name_, 'NOTALLOWED2: User :P1 is not allowed delete a note entered by :P2', fnd_user_, remrec_.user_id);
      END IF;            
   END IF;   
END Check_Delete___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     fin_note_text_tab%ROWTYPE,
   newrec_ IN OUT fin_note_text_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   fnd_user_      VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (oldrec_.user_id != fnd_user_) THEN   
      Error_SYS.Record_General(lu_name_, 'NOTALLOWED: User :P1 is not allowed modify a note entered by :P2', fnd_user_, oldrec_.user_id);
   END IF;      
END Check_Update___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   row_no_      NUMBER;
   time_stamp_  DATE;
   user_id_     fnd_user_tab.identity%TYPE;
BEGIN
   row_no_     := Get_Next_Row_No___;
   time_stamp_ := SYSDATE;
   user_id_    := Fnd_Session_API.Get_Fnd_User;
   super(attr_);
   Client_SYS.Add_To_Attr('ROW_NO', row_no_, attr_);
   Client_SYS.Add_To_Attr('TIMESTAMP', time_stamp_, attr_);
   Client_SYS.Add_To_Attr('USER_ID', user_id_, attr_);
END Prepare_Insert___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Remove_Note_Text (
   note_id_ IN NUMBER )
IS     
   app_context_val_  VARCHAR2(50) := lu_name_ ||'.CASCADE_NOTE';   
   CURSOR get_rows IS
      SELECT *
      FROM   fin_note_text_tab
      WHERE  note_id = note_id_;
BEGIN
   IF (note_id_ IS NOT NULL) THEN
      App_Context_SYS.Set_Value(app_context_val_, 'TRUE');       
      FOR rec_ IN get_rows LOOP         
         Remove___(rec_);                         
      END LOOP;
      App_Context_SYS.Set_Value(app_context_val_, 'FALSE');
   END IF;
EXCEPTION 
   WHEN OTHERS THEN      
      App_Context_SYS.Set_Value(app_context_val_, 'FALSE');      
      RAISE;
END Remove_Note_Text;


PROCEDURE Create_Note (
   key_attr_   IN VARCHAR2 )
IS
   row_no_        NUMBER;
   attr_          VARCHAR2(32000);
   info_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);   
BEGIN
   attr_   := key_attr_;   
   row_no_ := Get_Next_Row_No___;   
   Client_SYS.Add_To_Attr('ROW_NO', row_no_, attr_);   
   New__(info_, objid_, objversion_, attr_, 'DO');
END Create_Note; 


@UncheckedAccess
FUNCTION Get_Note_Text (
   note_id_ IN NUMBER ) RETURN VARCHAR2
IS          
   text_ VARCHAR2 (10000);
   CURSOR  get_text IS 
      SELECT text
      FROM   fin_note_text_tab
      WHERE  note_id = note_id_;      
BEGIN
   FOR rec_ IN get_text LOOP
      IF (text_ IS NOT NULL) THEN
         IF (LENGTH (text_) > 8000) THEN
            EXIT;
         ELSE
            text_ := text_||CHR(10)||rec_.text;
         END IF;
      ELSE
         text_ := rec_.text;
      END IF;
   END LOOP;
   RETURN text_;
END Get_Note_Text;


PROCEDURE New_Rec (
   info_   OUT    VARCHAR2,
   newrec_ IN OUT fin_note_text_tab%ROWTYPE )
IS
BEGIN
   IF (newrec_.row_no IS NULL) THEN
      newrec_.row_no := Get_Next_Row_No___;
   END IF;
   New___(newrec_);
   info_ := Client_SYS.Get_All_Info;
END New_Rec;


-- This method is to be used by Aurena
PROCEDURE Modify_Rec (
   newrec_ IN OUT fin_note_text_tab%ROWTYPE )
IS
BEGIN
   Modify___(newrec_);   
END Modify_Rec;


-- This method is to be used by Aurena
PROCEDURE Prepare_New (   
   newrec_ IN OUT fin_note_text_tab%ROWTYPE )
IS   
BEGIN
   Prepare_New___(newrec_);
END Prepare_New;   


-- This method is to be used by Aurena
PROCEDURE Remove_Rec (
   newrec_ IN OUT fin_note_text_tab%ROWTYPE )
IS
BEGIN
   Remove___(newrec_);   
END Remove_Rec;


