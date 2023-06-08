-----------------------------------------------------------------------------
--
--  Logical unit: WarrantyLangDesc
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  151106  HimRlk  Bug 123910, Modified Copy() by adding error_when_no_source_ and error_when_existing_copy_ parameters.
--  100513  MoNilk  Modified REF in column comment on language_code to IsoLanguage in WARRANTY_LANG_DESC.
--  100430  Ajpelk  Merge rose method documentation
--  --------------------------Version 14.0.0-----------------------------------
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  --------------------------Version 13.3.0-----------------------------------
--  030911  MiKulk  Bug 37995, Modified the VARCHAR declaration in the coding as VARCHAR2.
--  010525  JSAnse  Bug 21463, Changed the name in the General_SYS.Init_Method call in procedure Add_Descs.
--  001102  PaLj    Added method Add_Descs
--  001025  JoEd    Added method Copy_From_Template.
--  001017  JoEd    Added method Copy. Changed behaviour for NOTE_ID and
--                  LANGUAGE_CODE.
--  001010  PaLj    Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WARRANTY_LANG_DESC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Add_To_Attr('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Copy
--   This will copy data with all added texts from one warranty to
--   another warranty.
PROCEDURE Copy (
   old_warranty_id_          IN NUMBER,
   new_warranty_id_          IN NUMBER,
   error_when_no_source_     IN VARCHAR2 DEFAULT 'FALSE',
   error_when_existing_copy_ IN VARCHAR2 DEFAULT 'TRUE' )
IS
   CURSOR get_record IS
      SELECT rowid objid
      FROM WARRANTY_LANG_DESC_TAB
      WHERE warranty_id = old_warranty_id_;

   newrec_      WARRANTY_LANG_DESC_TAB%ROWTYPE;
   objid_       VARCHAR2(2000);
   objversion_  VARCHAR2(2000);
   attr_        VARCHAR2(2000);
   old_note_id_ NUMBER;
   new_note_id_ NUMBER;
   oldrec_found_ BOOLEAN := FALSE;
BEGIN
   FOR rec_ IN get_record LOOP
      oldrec_found_ := TRUE;
      newrec_ := Get_Object_By_Id___(rec_.objid);
      Client_SYS.Clear_Attr(attr_);
      newrec_.warranty_id := new_warranty_id_;
      old_note_id_ := newrec_.note_id;
      -- clear the note_id so that it will assign a new note_id for the new record
      newrec_.note_id := NULL;
      IF (NOT Check_Exist___(new_warranty_id_, newrec_.warranty_type_id, newrec_.language_code)) THEN
         Insert___(objid_, objversion_, newrec_, attr_);
         -- Copy all added document texts.
         new_note_id_ := newrec_.note_id;
         Document_Text_API.Copy_All_Note_Texts(old_note_id_, new_note_id_);
      ELSE
         IF (error_when_existing_copy_ = 'TRUE') THEN            
            Error_SYS.Record_Exist(lu_name_, 'WARLANGDESCEXIST: Warranty language description :P1 already exists for the warranty type :P2 in warranty :P3.', newrec_.language_code, newrec_.warranty_type_id, newrec_.warranty_id);
         END IF;
      END IF;
   END LOOP;
   IF (NOT oldrec_found_ AND error_when_no_source_ = 'TRUE') THEN
      Error_SYS.Record_Not_Exist(lu_name_, 'WARLDESCNOTEXIST: Warranty language description does not exist.');
   END IF;
END Copy;


-- Copy_From_Template
--   This will copy data with all added texts from a given template
--   to a given warranty.
PROCEDURE Copy_From_Template (
   warranty_id_ IN NUMBER,
   template_id_ IN VARCHAR2 )
IS
   CURSOR get_template IS
      SELECT language_code, warranty_type_desc, note_id
      FROM WARRANTY_LANG_DESC_TEMP_TAB
      WHERE template_id = template_id_;
   newrec_     WARRANTY_LANG_DESC_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(2000);
   indrec_     Indicator_Rec;
BEGIN
   FOR rec_ IN get_template LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('WARRANTY_ID', warranty_id_, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_TYPE_ID', template_id_, attr_);
      Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_TYPE_DESC', rec_.warranty_type_desc, attr_);
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

      -- Copy all document texts.
      Document_Text_API.Copy_All_Note_Texts(rec_.note_id, newrec_.note_id);
   END LOOP;
END Copy_From_Template;


-- Add_Descs
--   This will copy data with all added texts from a given warranty
--   and a warranty type to another warranty.
PROCEDURE Add_Descs (
   to_warranty_id_        IN NUMBER, 
   from_warranty_id_      IN NUMBER,
   from_warranty_type_id_ IN VARCHAR2 )
IS
   CURSOR get_desc_info IS
   SELECT * 
   FROM WARRANTY_LANG_DESC_TAB
   WHERE warranty_id = from_warranty_id_
   AND warranty_type_id = from_warranty_type_id_;
   
   attr_ VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   indrec_     Indicator_Rec;
   newrec_     WARRANTY_LANG_DESC_TAB%ROWTYPE;
BEGIN
   FOR rec_ IN get_desc_info LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('WARRANTY_ID', to_warranty_id_, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_TYPE_ID',from_warranty_type_id_ , attr_);
      Client_SYS.Add_To_Attr('LANGUAGE_CODE', rec_.language_code, attr_);
      Client_SYS.Add_To_Attr('WARRANTY_TYPE_DESC', rec_.warranty_type_desc, attr_);
      -- NOTE_ID ?????????????????
      Unpack___(newrec_, indrec_, attr_);
      Check_Insert___(newrec_, indrec_, attr_);
      Insert___(objid_, objversion_, newrec_, attr_);

      -- Copy all document texts.
      Document_Text_API.Copy_All_Note_Texts(rec_.note_id, newrec_.note_id);
   END LOOP;
END Add_Descs;



