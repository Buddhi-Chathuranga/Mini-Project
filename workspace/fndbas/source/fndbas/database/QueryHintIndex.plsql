-----------------------------------------------------------------------------
--
--  Logical unit: QueryHintIndex
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  030219  HAAR  Created (ToDo#4152).
--  040408  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT QUERY_HINT_INDEX_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.manual IS NULL THEN
      newrec_.manual := 'TRUE';
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('MANUAL_DB', newrec_.manual, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     QUERY_HINT_INDEX_TAB%ROWTYPE,
   newrec_     IN OUT QUERY_HINT_INDEX_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.manual     := 'TRUE';
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('MANUAL_DB', newrec_.manual, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT query_hint_index_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   newrec_.manual := 'TRUE';
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


