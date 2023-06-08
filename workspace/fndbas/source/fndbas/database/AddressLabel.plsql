-----------------------------------------------------------------------------
--
--  Logical unit: AddressLabel
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

PROCEDURE New (
   newrec_ IN OUT NOCOPY fndcn_address_label_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_);
END New;

-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     fndcn_address_label_tab%ROWTYPE,
   newrec_     IN OUT NOCOPY fndcn_address_label_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF oldrec_.state = Address_Label_State_API.DB_TRANSFERRED AND newrec_.state = Address_Label_State_API.DB_RELEASED THEN
      Message_Body_API.Remove_Address_Body__(oldrec_.application_message_id, oldrec_.seq_no);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN fndcn_address_label_tab%ROWTYPE )
IS
BEGIN
   Message_Body_API.Remove_Address_Body__(remrec_.application_message_id, remrec_.seq_no);
   super(objid_, remrec_);
END Delete___;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


