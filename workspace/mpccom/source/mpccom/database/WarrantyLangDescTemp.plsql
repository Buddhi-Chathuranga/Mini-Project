-----------------------------------------------------------------------------
--
--  Logical unit: WarrantyLangDescTemp
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100513  MoNilk  Modified REF in column comment on language_code to IsoLanguage in WARRANTY_LANG_DESC_TEMP.
--  ----------------------- 14.0.0 ------------------------------------------
--  060111  MiKulk  Modified the PROCEDURE Insert___ according to the new template.
--  -----------------------Version 13.3.0------------------------------------
--  001010  PaLj  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT WARRANTY_LANG_DESC_TEMP_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.note_id := Document_Text_API.Get_Next_Note_Id;
   Client_SYS.Set_Item_Value('NOTE_ID', newrec_.note_id, attr_);

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


