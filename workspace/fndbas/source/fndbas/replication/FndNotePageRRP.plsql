-----------------------------------------------------------------------------
--
--  Logical unit: FndNotePage ReplReceive
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


-------------------- REPLICATION RECEIVE PRIVATE METHODS ----------------------------


-------------------- REPLICATION RECEIVE PROTECTED METHODS --------------------------


-------------------- REPLICATION RECEIVE PUBLIC METHODS -----------------------------
--- In satellite installations note page note ids are overridden if a diffent note book received from Hub installation
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
   
   oldrec_   fnd_note_page_tab%ROWTYPE;
   newrec_   fnd_note_page_tab%ROWTYPE;
   indrec_   Indicator_Rec;
   
   prime_note_id_ fnd_note_book_tab.note_id%TYPE;
   curr_note_id_  fnd_note_book_tab.note_id%TYPE;
   curr_page_no_  fnd_note_page_tab.page_no%TYPE;
   
   CURSOR get_existing_note_id (note_id_ IN VARCHAR2)IS
      SELECT t.note_id
      FROM fnd_note_book_tab t
      WHERE t.note_id = note_id_;   
BEGIN
   attr_ := new_attr_;
   oldrec_.note_id := Client_SYS.Get_Item_Value('NOTE_ID', old_attr_);
   oldrec_.page_no := Client_SYS.Get_Item_Value_To_Number('PAGE_NO', old_attr_, lu_name_);
   IF (oldrec_.note_id IS NULL ) THEN
      curr_note_id_ := Client_SYS.Get_Item_Value('NOTE_ID', new_attr_);
      curr_page_no_ := Client_SYS.Get_Item_Value_To_Number('PAGE_NO', new_attr_, lu_name_);
   END IF;
   
   Get_Id_Version_By_Keys___(objid_, objversion_, oldrec_.note_id, oldrec_.page_no);
   
   IF (objid_ IS NULL) THEN
      --  if a note page is new one but (parent) note book is not present, 
      --    HUB - skip the message
      --          Because this note page is a obsolete one already overidden in satellite installation
      --    SAT - use new_attr note id
      --          Because this note page's note id may be already updated in SAT
      --  This is to ensure having same note ids in all the installations.
      --  priority is given to hub installations.
      OPEN get_existing_note_id(curr_note_id_);
      FETCH get_existing_note_id INTO prime_note_id_;
      CLOSE get_existing_note_id;
      IF (prime_note_id_ IS NULL ) THEN
         IF((Data_Sync_SYS.Get_Property_Value('INSTALLATION', 'LOCATION') = 'HUB')) THEN
            Data_Sync_SYS.Skip_Processing_Message('Message contents are obsolete in current installation!');
         END IF;
      ELSE
         IF((Data_Sync_SYS.Get_Property_Value('INSTALLATION', 'LOCATION') = 'SAT')) THEN
            Get_Id_Version_By_Keys___(objid_, objversion_, curr_note_id_, curr_page_no_);
         END IF;         
      END IF;
   END IF;
   
   IF (objid_ IS NOT NULL) THEN
      -- record exist! update record
      oldrec_ := Lock_By_Id___(objid_, objversion_);
      newrec_ := oldrec_;
      Unpack___(newrec_, indrec_, attr_);
      Check_Update___(oldrec_, newrec_, indrec_, attr_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_, FALSE);
   ELSE
      -- record does not exists! insert as new
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
   END IF;
END NewModify;
