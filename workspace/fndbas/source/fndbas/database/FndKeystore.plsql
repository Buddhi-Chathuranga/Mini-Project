-----------------------------------------------------------------------------
--
--  Logical unit: FndKeystore
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  200902  MaIklk  CRM2020R1-906, Created.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE New_Keystore (
   keystore_id_   IN VARCHAR2,
   user_name_     IN VARCHAR2,
   description_   IN VARCHAR2,
   type_          IN VARCHAR2,
   file_name_     IN VARCHAR2,
   expire_date_   IN DATE,
   pfx_           IN BLOB)
IS
   newrec_       fnd_keystore_tab%ROWTYPE;
   objid_        fnd_keystore.objid%TYPE;
   objversion_   fnd_keystore.objversion%TYPE;
BEGIN
   newrec_.keystore_id  := keystore_id_;
   newrec_.user_name    := user_name_;
   newrec_.description  := description_;
   newrec_.type         := type_;
   newrec_.file_name    := file_name_;
   newrec_.expire_date  := expire_date_;
   IF(NOT Check_Exist___(keystore_id_, user_name_)) THEN
      New___(newrec_);
   ELSE
      newrec_.rowkey := Get_Objkey(newrec_.keystore_id, newrec_.user_name);
      Modify___(newrec_);
   END IF;
   Get_Id_Version_By_Keys___(objid_, objversion_, keystore_id_, user_name_);
   Write_Pfx__(objversion_, objid_, pfx_);
END New_Keystore;