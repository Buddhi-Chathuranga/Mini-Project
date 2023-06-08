-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveSourceAttr
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000301  HAAR  Created
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  100819  DUWI  Added functionality to support create indexes on destination tables (Bug#91926).
--  101011  ChMu  Changed Register__ method.(Bug#93503).
--  130423  PGAN  Changed DATA_ARCHIVE_COLUMNS_LOV.(Bug#109595).
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('WHEN_ORDERED', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('PRIMARY_KEY', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CREATE_INDEX', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DATA_ARCHIVE_SOURCE_ATTR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Check_Column___(newrec_.table_name, newrec_.column_name);
   IF (newrec_.when_ordered = 'TRUE') THEN
      Check_When_Ordered___ (newrec_.aoid, newrec_.table_name);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     DATA_ARCHIVE_SOURCE_ATTR_TAB%ROWTYPE,
   newrec_     IN OUT DATA_ARCHIVE_SOURCE_ATTR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_Column___(newrec_.table_name, newrec_.column_name);
   IF (newrec_.when_ordered = 'TRUE') THEN
      Check_When_Ordered___ (newrec_.aoid, newrec_.table_name);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Column___ (
   table_name_ IN VARCHAR2,
   column_name_ IN VARCHAR2 )
IS
   tmp_ NUMBER;

   CURSOR get_column IS
      SELECT 1
      FROM   user_tab_columns
      WHERE  table_name = table_name_
      AND    column_name = column_name_;
BEGIN
   OPEN  get_column;
   FETCH get_column INTO tmp_;
   IF (get_column%NOTFOUND) THEN
      Error_Sys.Appl_General(
         'DataArchiveSourceAttr',
         'COLUMNERR: Column [:P1] does not exist in specified table [:P2].', column_name_, table_name_);
   END IF;
   CLOSE get_column;
END Check_Column___;

PROCEDURE Check_When_Ordered___ (
   aoid_       IN  VARCHAR2,
   table_name_ IN  VARCHAR2 )
IS
   master_table_   VARCHAR2(30);
   CURSOR get_master IS
      SELECT master_table
      FROM   data_archive_source_tab
      WHERE  aoid = aoid_
      AND    table_name = table_name_;
BEGIN
   OPEN  get_master;
   FETCH get_master INTO master_table_;
   CLOSE get_master;
   IF (master_table_ = 'FALSE') THEN
      Error_Sys.Appl_General(
         'DataArchiveSourceAttr',
         'WHENORDEREDERR: Only columns belonging to the master table can be set as parameters.');
   END IF;
END Check_When_Ordered___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert__ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT data_archive_source_attr_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Insert___ (objid_, objversion_, newrec_, attr_);
END Insert__;

PROCEDURE New_Attribute__ (
   newrec_ IN OUT Data_Archive_Source_Attr_Tab%ROWTYPE )
IS
   attr_              VARCHAR2(2000);
   objid_             VARCHAR2(2000);
   objversion_        VARCHAR2(2000);
BEGIN
   Insert___(objid_, objversion_, newrec_, attr_);
END New_Attribute__;


PROCEDURE Register__ (
   aoid_ IN VARCHAR2,
   table_name_ IN VARCHAR2,
   column_name_ IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     DATA_ARCHIVE_SOURCE_ATTR_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   Data_Archive_Object_API.Exist(aoid_);
   Data_Archive_Source_API.Exist(aoid_, table_name_);
   objrec_.aoid := aoid_;
   objrec_.table_name := table_name_;
   objrec_.column_name := column_name_;
   objrec_.primary_key := Message_SYS.Find_Attribute(info_msg_, 'PRIMARY_KEY', '');
   objrec_.parent_key_name := Message_SYS.Find_Attribute(info_msg_, 'PARENT_KEY_NAME', '');
   objrec_.seq_no := Message_SYS.Find_Attribute(info_msg_, 'SEQ_NO', 0);
   objrec_.when_ordered := Message_SYS.Find_Attribute(info_msg_, 'WHEN_ORDERED', '');
   objrec_.create_index := Message_SYS.Find_Attribute(info_msg_, 'CREATE_INDEX', 'FALSE');
   Insert___ (objid_, objversion_, objrec_, attr_);
END Register__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

