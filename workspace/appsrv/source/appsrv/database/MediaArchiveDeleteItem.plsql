-----------------------------------------------------------------------------
--
--  Logical unit: MediaArchiveDeleteItem
--  Component:    APPSRV
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170803  CHAHLK  Bug 136626, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE New (
   item_id_                 IN NUMBER,
   lang_code_               IN VARCHAR2,
   archive_no_              IN NUMBER)
IS
   newrec_      MEDIA_ARCHIVE_DELETE_ITEM_TAB%ROWTYPE;
   attr_        VARCHAR2 (32000);
   objid_       MEDIA_ARCHIVE_DELETE_ITEM.objid%TYPE;
   objversion_  MEDIA_ARCHIVE_DELETE_ITEM.objversion%TYPE;
   indrec_      Indicator_Rec;
BEGIN
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('ITEM_ID', item_id_, attr_);
      Client_SYS.Add_To_Attr('LANGUAGE_CODE', NVL(lang_code_,'gg'), attr_);
      Client_SYS.Add_To_Attr('ARCHIVE_NO', archive_no_, attr_);
      
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);
END New;
   
PROCEDURE Remove (
   item_id_                 IN NUMBER,
   lang_code_               IN VARCHAR2)
IS
   remrec_      MEDIA_ARCHIVE_DELETE_ITEM_TAB%ROWTYPE;
   objid_       MEDIA_ARCHIVE_DELETE_ITEM.objid%TYPE;
   objversion_  MEDIA_ARCHIVE_DELETE_ITEM.objversion%TYPE;
BEGIN
   Get_Id_Version_By_Keys___ (objid_, objversion_, item_id_, lang_code_);
   remrec_ := Lock_By_Keys___(item_id_,lang_code_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;

