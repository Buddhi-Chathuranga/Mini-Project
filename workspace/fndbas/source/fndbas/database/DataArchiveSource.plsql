-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveSource
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000301  HAAR  Created
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030305  HAAR  Correct view comments (ToDo#4239).
--  040331  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  050704  HAAR  Changed view to use Dba_Tables instead of User_Tables. (F1PR843).
--  050930  NiWi  Correct Destination table for RPT tables(Bug53577).
--  060524  HAAR  Added check of system privilege DEFINE SQL (F1PR447).
--  100819  DUWI  Added functionality to support create indexes on destination tables (Bug#91926).
-----------------------------------------------------------------------------

layer Core;


-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

text_separator_  CONSTANT VARCHAR2(1)     := '^';

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('MASTER_TABLE', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DATA_ARCHIVE_TYPE', Data_Archive_Type_API.Decode('Move'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT data_archive_source_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.destination_table_name IS NULL) THEN
      newrec_.destination_table_name := REPLACE(REPLACE(newrec_.table_name, '_TAB', '_ARC'), '_RPT', '_RAC');
      attr_ := Client_SYS.Remove_Attr('DESTINATION_TABLE_NAME', attr_);
   END IF;
   super(newrec_, indrec_, attr_);
END Check_Insert___;



@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DATA_ARCHIVE_SOURCE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   Check_Table___(newrec_.table_name);

   IF (newrec_.destination_table_name IS NULL) THEN
      newrec_.destination_table_name := replace(replace(newrec_.table_name, '_TAB', '_ARC'), '_RPT', '_RAC');
   END IF;
   Client_SYS.Add_To_Attr('DESTINATION_TABLE_NAME', newrec_.destination_table_name, attr_);
   IF (newrec_.master_table = 'TRUE') THEN
      IF (newrec_.parent_table_name IS NOT NULL) THEN
         Error_Sys.Appl_General('DataArchiveSource', 'MASTER_ERR: If a table is marked as a master, it cannot have a parent table.');
      END IF;
   ELSE
      IF (newrec_.parent_table_name IS NULL) THEN
         Error_Sys.Appl_General('DataArchiveSource', 'NO_PARENT_ERR: If a table is not a master, it must have a parent table.');
      END IF;
   END IF;
   
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     data_archive_source_tab%ROWTYPE,
   newrec_ IN OUT data_archive_source_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (newrec_.where_clause IS NULL) THEN
      IF (newrec_.master_table = 'TRUE') THEN
         Client_SYS.Add_Info('DataArchiveSource', 'NOWHERECLAUSE: The master table has no where-clause, all records will be archived.');
      END IF;
   ELSE
      IF (newrec_.master_table = 'FALSE') THEN
         Error_Sys.Appl_General('DataArchiveSource', 'WHERECLAUSE: Only master tables can have a where-clause.');
      END IF;
   END IF;
END Check_Common___;



@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     DATA_ARCHIVE_SOURCE_TAB%ROWTYPE,
   newrec_     IN OUT DATA_ARCHIVE_SOURCE_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   Check_Table___(newrec_.table_name);
   
   IF (newrec_.master_table = 'TRUE') THEN
      IF (newrec_.parent_table_name IS NOT NULL) THEN
         Error_Sys.Appl_General('DataArchiveSource', 'MASTER_ERR: If a table is marked as a master, it cannot have a parent table.');
      END IF;
   ELSE
      IF (newrec_.parent_table_name IS NULL) THEN
         Error_Sys.Appl_General('DataArchiveSource', 'NO_PARENT_ERR: If a table is not a master, it must have a parent table.');
      END IF;
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Check_One_Master___(newrec_.aoid);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_One_Master___ (
   aoid_ IN VARCHAR2 )
IS
   tmp_ NUMBER;

   CURSOR get_table IS
      SELECT count(*)
      FROM   data_archive_source_tab
      WHERE  aoid = aoid_
      AND    ((master_table = 'TRUE' AND parent_table_name IS NULL)
      OR     (master_table = 'TRUE'));
BEGIN
   OPEN  get_table;
   FETCH get_table INTO tmp_;
   IF (Nvl(tmp_, 0) > 1) THEN --It can exist only one master table per archiving object
      Error_Sys.Appl_General(
         'DataArchiveSource',
         'MASTERERR: The archive object can only have one master table.');
   ELSIF (Nvl(tmp_, 0) < 1) THEN --It must exist one master table per archiving object
      Error_Sys.Appl_General(
         'DataArchiveSource',
         'NOMASTERERR: The archive object must have one master table.');
   END IF;
   CLOSE get_table;
END Check_One_Master___;

PROCEDURE Check_Table___ (
   table_name_ IN VARCHAR2 )
IS
   tmp_ NUMBER;

   CURSOR get_table IS
      SELECT 1
      FROM   user_tables
      WHERE  table_name = table_name_;
BEGIN
   OPEN  get_table;
   FETCH get_table INTO tmp_;
   IF (get_table%NOTFOUND) THEN
      Error_Sys.Appl_General(
         'DataArchiveSource', 'TABLEERR: Table does not exist or user must have access to table.');
   END IF;
   CLOSE get_table;
END Check_Table___;

PROCEDURE Create_Attribute___ (
   aoid_       IN VARCHAR2,
   table_name_ IN VARCHAR2 )
IS
   key_list_          VARCHAR2(32000);
   newrec_            Data_Archive_Source_Attr_Tab%ROWTYPE;

   CURSOR get_columns IS
      SELECT a.column_name, a.column_id, s.master_table, s.aoid, s.parent_table_name
      FROM   user_tab_columns a, data_archive_source_tab s
      WHERE  s.aoid = aoid_
      AND    s.table_name = table_name_
      AND    s.table_name = a.table_name
      ORDER BY a.column_id;

BEGIN
   key_list_ := Get_Primary_Keys___(table_name_);
   IF(key_list_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'PK_NOT_EXIST: The Table [:P1] does not contain a primary key',table_name_);
   END IF;
   FOR col IN get_columns LOOP
      newrec_ := NULL;
      newrec_.aoid := aoid_;
      newrec_.table_name := table_name_;
      newrec_.column_name := col.column_name;
      newrec_.seq_no := col.column_id;
      IF ( INSTR(text_separator_ || key_list_, text_separator_ || col.column_name || text_separator_) > 0 ) THEN
         newrec_.primary_key := 'TRUE';
      --
      --  Get Primary key columns for non master tables.
      --
         IF ( col.master_table = 'FALSE') THEN
            newrec_.parent_key_name  := Get_Parent_Key___(col.parent_table_name, col.column_name);
         END IF;
      ELSE
         newrec_.primary_key := 'FALSE';
         newrec_.parent_key_name := NULL;
      END IF;
      newrec_.when_ordered := 'FALSE';
      newrec_.create_index := 'FALSE';
      Data_Archive_Source_Attr_API.New_Attribute__(newrec_);
   END LOOP;
END Create_Attribute___;

FUNCTION Get_Primary_Keys___ (
   table_name_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   temp_list_ VARCHAR2(32000);
   CURSOR get_keys IS
      SELECT cc.column_name
      FROM   User_Constraints c, User_Cons_Columns cc
      WHERE  c.table_name = table_name_
      AND    c.constraint_type = 'P'
      AND    c.constraint_name = cc.constraint_name;
BEGIN
   FOR keyrec IN get_keys LOOP
      temp_list_ := temp_list_||keyrec.column_name||text_separator_;
   END LOOP;
   RETURN(temp_list_);
END Get_Primary_Keys___;

FUNCTION Get_Parent_Key___ (
   table_name_  IN  VARCHAR2,
   column_name_ IN  VARCHAR2 ) RETURN VARCHAR2
IS
   tmp_   VARCHAR2(30);
   CURSOR get_key IS
      SELECT cc.column_name
      FROM   User_Constraints c, User_Cons_Columns cc
      WHERE  c.table_name = table_name_
      AND    c.constraint_type = 'P'
      AND    c.constraint_name = cc.constraint_name
      AND    cc.column_name = column_name_;
BEGIN
   OPEN  get_key;
   FETCH get_key INTO tmp_;
   CLOSE get_key;
   RETURN(tmp_);
END Get_Parent_Key___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_          OUT VARCHAR2,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_     data_archive_source_tab%ROWTYPE;
BEGIN
   --Add pre-processing code here
   super(info_, objid_, objversion_, attr_, action_);
   --
   -- Create attributes from data dictionary
   --
   IF (action_ = 'DO') THEN 
      newrec_ := Get_Object_By_Id___(objid_);
      Create_Attribute___ (newrec_.aoid, newrec_.table_name);
   END IF;
END New__;

PROCEDURE Insert__ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT data_archive_source_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Insert___ (objid_, objversion_, newrec_, attr_);
END Insert__;

PROCEDURE Register__ (
   aoid_ IN VARCHAR2,
   table_name_ IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     DATA_ARCHIVE_SOURCE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   Data_Archive_Object_API.Exist(aoid_);
   objrec_.aoid := aoid_;
   objrec_.table_name := table_name_;
   objrec_.description := Message_SYS.Find_Attribute(info_msg_, 'DESCRIPTION', '');
   objrec_.table_alias := Message_SYS.Find_Attribute(info_msg_, 'TABLE_ALIAS', '');
   objrec_.destination_table_name := Message_SYS.Find_Attribute(info_msg_, 'DESTINATION_TABLE_NAME', '');
   objrec_.master_table := Message_SYS.Find_Attribute(info_msg_, 'MASTER_TABLE', '');
   objrec_.hint := Message_SYS.Find_Attribute(info_msg_, 'HINT', '');
   objrec_.where_clause := Message_SYS.Find_Attribute(info_msg_, 'WHERE_CLAUSE', '');
   objrec_.data_archive_type := Message_SYS.Find_Attribute(info_msg_, 'DATA_ARCHIVE_TYPE', '');
   objrec_.parent_table_name := Message_SYS.Find_Attribute(info_msg_, 'PARENT_TABLE_NAME', '');
   Insert___ (objid_, objversion_, objrec_, attr_);
END Register__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
