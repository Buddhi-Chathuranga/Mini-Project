-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationAttrDef
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('KEY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ON_NEW', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ON_MODIFY', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT REPLICATION_ATTR_DEF_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF ( newrec_.key = 'TRUE' ) THEN
      newrec_.on_new    := 'TRUE';
      newrec_.on_modify := 'TRUE';
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     REPLICATION_ATTR_DEF_TAB%ROWTYPE,
   newrec_     IN OUT REPLICATION_ATTR_DEF_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF ( newrec_.key = 'TRUE' ) THEN
      newrec_.on_new    := 'TRUE';
      newrec_.on_modify := 'TRUE';
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Replication_Object_Def_API.Set_Last_Cfg_Time_(newrec_.business_object);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


