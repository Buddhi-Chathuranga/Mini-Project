-----------------------------------------------------------------------------
--
--  Logical unit: FndNoteBook ReplReceive
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


-------------------- REPLICATION RECEIVE IMPLEMENTATION METHODS ---------------------

PROCEDURE Update_Page_Note_Id___ (
   new_note_id_ IN VARCHAR2,
   old_note_id_ IN VARCHAR2)
IS
BEGIN
   IF ((old_note_id_ IS NOT NULL) AND (new_note_id_ <> old_note_id_) AND (Data_Sync_SYS.Get_Property_Value('INSTALLATION', 'LOCATION') = 'SAT')) THEN
      UPDATE fnd_note_page_tab t
         SET t.note_id = new_note_id_
      WHERE  t.note_id = old_note_id_;
   END IF;      
END Update_Page_Note_Id___;


-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------


-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------
--  Hub installation content givent priority over satellite installation contents
--  However this happents only if both hub and satellite have different notes for same lu object at same time
@Overtake Base
PROCEDURE NewModify (
   warning_      OUT VARCHAR2,
   old_attr_     IN  VARCHAR2, 
   new_attr_     IN  VARCHAR2,
   lu_name_      IN  VARCHAR2,
   package_name_ IN  VARCHAR2,
   user_id_      IN  VARCHAR2) 
IS
   attr_  VARCHAR2(32000);
   objid_ VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   
   oldrec_   fnd_note_book_tab%ROWTYPE;
   newrec_   fnd_note_book_tab%ROWTYPE;
   indrec_   Indicator_Rec;
   
   prime_note_id_    fnd_note_book_tab.note_id%TYPE;
   existing_note_id_ fnd_note_book_tab.note_id%TYPE;
   
   CURSOR get_existing_note_id (lu_name_ IN VARCHAR2,
                                key_ref_ IN VARCHAR2)IS
      SELECT t.note_id
      FROM fnd_note_book_tab t
      WHERE t.lu_name = lu_name_
      AND   t.key_ref = key_ref_;
     
   
BEGIN
   attr_ := new_attr_;
   oldrec_.note_id := Client_SYS.Get_Item_Value('NOTE_ID', old_attr_);
   IF (oldrec_.note_id IS NULL ) THEN
      prime_note_id_  := Client_SYS.Get_Item_Value('NOTE_ID', new_attr_); 
      oldrec_.lu_name := Client_SYS.Get_Item_Value('LU_NAME', new_attr_);
      oldrec_.key_ref := Client_SYS.Get_Item_Value('KEY_REF', new_attr_);
   ELSE
      prime_note_id_  := oldrec_.note_id;
      oldrec_.lu_name := Client_SYS.Get_Item_Value('LU_NAME', old_attr_);
      oldrec_.key_ref := Client_SYS.Get_Item_Value('KEY_REF', old_attr_);
   END IF;   
   
   OPEN get_existing_note_id(oldrec_.lu_name, oldrec_.key_ref);
   FETCH get_existing_note_id INTO existing_note_id_;
   CLOSE get_existing_note_id;
   
   Get_Id_Version_By_Keys___(objid_, objversion_, existing_note_id_);   
   
   IF (objid_ IS NOT NULL) THEN
      -- record exist! update record
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);      
      --update note id of satellite installation with note id from hub if already exists
      IF (Data_Sync_SYS.Get_Property_Value('INSTALLATION', 'LOCATION') = 'SAT') THEN
         newrec_.note_id := prime_note_id_;
      ELSE
         newrec_.note_id := existing_note_id_;
      END IF;  
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, FALSE);
      --update note id of fnd note pages
      Update_Page_Note_Id___(prime_note_id_, existing_note_id_);
   ELSE
      -- record does not exists! insert as new
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END NewModify;


