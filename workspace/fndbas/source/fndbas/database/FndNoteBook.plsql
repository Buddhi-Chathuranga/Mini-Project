-----------------------------------------------------------------------------
--
--  Logical unit: FndNoteBook
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

PROCEDURE Validate_Lu___ (
   lu_ IN VARCHAR2 )
IS
   dummy_   NUMBER := 0;
   --SOLSETFW
   CURSOR get_lu IS
   SELECT 1 
     FROM dictionary_sys_active
    WHERE lu_name = lu_;
BEGIN
   OPEN  get_lu;
   FETCH get_lu INTO dummy_;
   CLOSE get_lu;
   IF (dummy_ = 0) THEN -- LU doesn't exist
      Error_SYS.Appl_General(lu_name_, 'WRONG_LU: The LU [:P1] is not an existing LU in this installation.', lu_);
   END IF;
END Validate_Lu___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('PINNED', Fnd_Boolean_API.Decode('TRUE'), attr_);
   Client_SYS.Add_To_Attr('PINNED_DB', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_NOTE_BOOK_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.note_id := sys_guid;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT FND_NOTE_BOOK_TAB%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(newrec_, indrec_, attr_);
   Validate_Lu___(newrec_.lu_name);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

