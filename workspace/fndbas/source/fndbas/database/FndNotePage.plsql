-----------------------------------------------------------------------------
--
--  Logical unit: FndNotePage
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  080403  HAAR  Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_NOTE_PAGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
   CURSOR get_page_no IS
   SELECT nvl(MAX(page_no) + 1, 1)
     FROM fnd_note_page_tab
    WHERE note_id = newrec_.note_id;
BEGIN
   OPEN  get_page_no;
   FETCH get_page_no INTO newrec_.page_no;
   CLOSE get_page_no;
   newrec_.created_by    := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date  := SYSDATE;
   newrec_.modified_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.modified_date := SYSDATE;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('PAGE_NO', newrec_.page_no, attr_);
   Client_SYS.Add_To_Attr('CREATED_BY', newrec_.created_by, attr_);
   Client_SYS.Add_To_Attr('CREATED_DATE', newrec_.created_date, attr_);
   Client_SYS.Add_To_Attr('MODIFIED_BY', newrec_.modified_by, attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', newrec_.modified_date, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FND_NOTE_PAGE_TAB%ROWTYPE,
   newrec_     IN OUT FND_NOTE_PAGE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.modified_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.modified_date := SYSDATE;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('MODIFIED_BY', newrec_.modified_by, attr_);
   Client_SYS.Add_To_Attr('MODIFIED_DATE', newrec_.modified_date, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

