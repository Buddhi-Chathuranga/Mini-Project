-----------------------------------------------------------------------------
--
--  Logical unit: PresObjectDescription
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000225  PeNi  Added Insert_, Modify_ and Remove_Description.
--  000227  PeNi  Corrected LU
--  020626  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


PROCEDURE Insert_Description (
   po_id_ IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
BEGIN
   IF (Check_Exist___(po_id_, lang_code_)) THEN
      Modify_Description(po_id_, lang_code_, description_);
   ELSE
      INSERT INTO pres_object_description_tab
        (po_id, lang_code, description, rowversion)
      VALUES
        (po_id_, lang_code_, description_, sysdate);
   END IF;
END Insert_Description;


PROCEDURE Modify_Description (
   po_id_ IN VARCHAR2,
   lang_code_ IN VARCHAR2,
   description_ IN VARCHAR2 )
IS
BEGIN
   IF (Check_Exist___(po_id_, lang_code_)) THEN
      UPDATE pres_object_description_tab
         SET description = description_,
             rowversion = sysdate
         WHERE po_id = po_id_
           AND lang_code = lang_code_;
   ELSE
      Insert_Description(po_id_, lang_code_, description_);
   END IF;
END Modify_Description;

PROCEDURE Remove_Description (
   po_id_ IN VARCHAR2,
   lang_code_ IN VARCHAR2 )
IS
BEGIN
   DELETE FROM pres_object_description_tab
   WHERE po_id = po_id_
     AND lang_code = lang_code_;
END Remove_Description;



