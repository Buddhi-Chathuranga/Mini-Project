-----------------------------------------------------------------------------
--
--  Logical unit: CustomReaderParam
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


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT custom_reader_param_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 ) IS
BEGIN
   super(objid_, objversion_, newrec_, attr_);
   Connect_Reader_API.Sync_Custom_Reader__(newrec_.instance_name);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     custom_reader_param_tab%ROWTYPE,
   newrec_     IN OUT custom_reader_param_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE ) IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Connect_Reader_API.Sync_Custom_Reader__(newrec_.instance_name);
END Update___;


@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN custom_reader_param_tab%ROWTYPE ) IS
BEGIN
   super(objid_, remrec_);
   Connect_Reader_API.Sync_Custom_Reader__(remrec_.instance_name);
END Delete___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

