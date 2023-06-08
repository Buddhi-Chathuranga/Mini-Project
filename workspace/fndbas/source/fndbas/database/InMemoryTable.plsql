-----------------------------------------------------------------------------
--
--  Logical unit: InMemoryTable
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  191121  PABNLK  PACCFW-236: New Lu specific public methods implemented to support 'In-Memory Acceleration Package' window conversion.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN     in_memory_table_tab%ROWTYPE )
IS
BEGIN
   IF NOT Is_Rec_From_Custom_Package__(remrec_) THEN
      Error_SYS.Appl_General(
      lu_name_, 
      'INVALIDREMOVE: IFS In-Memory package''s table [:P1] cannot remove from package.', 
      remrec_.table_name);
   END IF;
   
   super(remrec_);
END Check_Delete___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     in_memory_table_tab%ROWTYPE,
   newrec_ IN OUT in_memory_table_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF NOT Is_Rec_From_Custom_Package__(oldrec_) THEN
      Error_SYS.Appl_General(
      lu_name_, 
      'INVALIDVALUE: IFS In-Memory package''s table [:P1] cannot change.', 
      oldrec_.table_name);
   END IF;
   
   IF Is_Rec_From_Enabled_Package__(oldrec_) THEN
      Error_SYS.Appl_General(
      lu_name_, 
      'INVALIDVALUEIM: In-Memory enabled package''s table [:P1] cannot change.', 
      oldrec_.table_name);
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     in_memory_table_tab%ROWTYPE,
   newrec_ IN OUT in_memory_table_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   Assert_SYS.Assert_Is_Table(newrec_.table_name);
   
   IF NOT Is_Rec_From_Custom_Package__(oldrec_) THEN
      Error_SYS.Appl_General(
      lu_name_, 
      'INVALIDVALUE: IFS In-Memory package''s table [:P1] cannot change.', 
      oldrec_.table_name);
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

FUNCTION Is_Rec_From_Custom_Package__ (
   rec_ IN     in_memory_table_tab%ROWTYPE) RETURN BOOLEAN
IS
   CURSOR is_custom_package_ (package_id_ NUMBER) IS
      SELECT is_custom_package
      FROM in_memory_package_tab
      WHERE package_id = package_id_;
   
   is_custom_pkg_ NUMBER;
BEGIN
   OPEN is_custom_package_ (rec_.package_id);
   FETCH is_custom_package_ INTO is_custom_pkg_;
   CLOSE is_custom_package_;
   
   RETURN is_custom_pkg_ = 1;
END Is_Rec_From_Custom_Package__;


FUNCTION Is_Rec_From_Enabled_Package__ (
   rec_ IN     in_memory_table_tab%ROWTYPE) RETURN BOOLEAN
IS
   CURSOR is_enabled_package_ (package_id_ NUMBER) IS
      SELECT enabled
      FROM in_memory_package_tab
      WHERE package_id = package_id_;
   
   is_enabled_pkg_ NUMBER;
BEGIN
   OPEN is_enabled_package_ (rec_.package_id);
   FETCH is_enabled_package_ INTO is_enabled_pkg_;
   CLOSE is_enabled_package_;
   
   RETURN is_enabled_pkg_ = 1;
END Is_Rec_From_Enabled_Package__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Enable_Inmem_For_Table_ (
   table_name_ VARCHAR2) 
IS
   dummy_              NUMBER;
   stmt_               VARCHAR2(500);
   mem_compression_    VARCHAR2(500) DEFAULT 'MEMCOMPRESS FOR QUERY LOW';
   comp_setting_param_ fnd_setting_tab%ROWTYPE;
   CURSOR check_size IS
      SELECT 1
      FROM dba_segments
      WHERE owner = Fnd_Session_API.Get_App_Owner
      AND segment_type = 'TABLE'
      AND segment_name = table_name_
      AND bytes >= 1024*1024;
BEGIN
   IF Dictionary_SYS.Is_Db_Inmemory_Supported THEN
      IF Installation_SYS.Is_Table_Temporary(table_name_) THEN
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Table "'|| table_name_ ||'" is a temporary table.');
         RETURN;
      END IF;
      OPEN check_size;
      FETCH check_size INTO dummy_;
      IF check_size%FOUND THEN
         CLOSE check_size;
         stmt_ := 'ALTER ';
         IF Installation_SYS.Table_Exist(table_name_) THEN
            stmt_ := stmt_ || 'TABLE ';
         ELSIF Installation_SYS.Mtrl_View_Exist(table_name_) THEN
            stmt_ := stmt_ || 'MATERIALIZED VIEW ';
         ELSE
            Error_SYS.Appl_General(lu_name_, 'IS_TABLE: ":P1" is non existing table or materialized view.', table_name_ );
         END IF;

         comp_setting_param_ := Fnd_Setting_Api.Get_Parameter('IM_COMP_LEVEL');

         IF comp_setting_param_.value = 'DML' THEN
            mem_compression_ := 'MEMCOMPRESS FOR DML';

         ELSIF comp_setting_param_.value = 'QUERY_LOW' THEN
            mem_compression_ := 'MEMCOMPRESS FOR QUERY LOW';

         ELSIF comp_setting_param_.value = 'QUERY_HIGH' THEN
            mem_compression_ := 'MEMCOMPRESS FOR QUERY HIGH';

         ELSIF comp_setting_param_.value = 'CAPACITY_LOW' THEN
            mem_compression_ := 'MEMCOMPRESS FOR CAPACITY LOW';

         ELSIF comp_setting_param_.value = 'CAPACITY_HIGH' THEN
            mem_compression_ := 'MEMCOMPRESS FOR CAPACITY HIGH';
         END IF;

         stmt_ := stmt_ || table_name_ || ' INMEMORY ' || mem_compression_ || ' PRIORITY CRITICAL';

         @ApproveDynamicStatement(2015-06-17,rodhlk)
         EXECUTE IMMEDIATE stmt_;
      ELSE
         CLOSE check_size;
         Log_SYS.Fnd_Trace_(Log_SYS.info_, 'Table "'|| table_name_ ||'" is not big enough to put In Memory.');
      END IF;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'NOINMEMDISABLE: Table ":P1" cannot be put into memory since this database does not have the In Memory option enabled.', table_name_ );
   END IF;
END Enable_Inmem_For_Table_;

PROCEDURE Disable_Inmem_For_Tbl_ (
   table_name_ VARCHAR2) 
IS
   stmt_ VARCHAR2(500);
BEGIN
stmt_ := 'ALTER ';
   IF Installation_SYS.Table_Exist(table_name_) THEN
      stmt_ := stmt_ || 'TABLE ';
   ELSIF Installation_SYS.Mtrl_View_Exist(table_name_) THEN
      stmt_ := stmt_ || 'MATERIALIZED VIEW ';
   ELSE
      Error_SYS.Appl_General(lu_name_, 'IS_TABLE: ":P1" is non existing table or materialized view.', table_name_ );
   END IF;
   stmt_ := stmt_ || table_name_ || ' NO INMEMORY';
   @ApproveDynamicStatement(2015-06-17,rodhlk)
   EXECUTE IMMEDIATE stmt_;
END Disable_Inmem_For_Tbl_;
   

FUNCTION Drop_Analythical_Indexes_ (
   table_name_ VARCHAR2,
   package_id_ NUMBER DEFAULT NULL,
   is_bi_ BOOLEAN DEFAULT FALSE,
   description_ VARCHAR2 DEFAULT NULL) RETURN NUMBER
IS
   CURSOR get_indexes IS
      SELECT index_name
      FROM User_Indexes
      WHERE generated = 'N'
      AND index_type = 'NORMAL'
      AND uniqueness = 'NONUNIQUE'
      AND table_name = table_name_;

   parent_log_id_   NUMBER;
   dummy_id_        NUMBER;   
   info_entry_      VARCHAR2(4000);
   info_entry_indx_ VARCHAR2(4000);
   indx_sql_        VARCHAR2(4000);
   indx_count_      NUMBER := 0;
   
BEGIN
   IF Installation_SYS.Table_Exist(table_name_) THEN
      Assert_SYS.Assert_Is_Table(table_name_);
      IF package_id_ IS NOT NULL OR is_bi_ = FALSE THEN
         info_entry_ := 'Removing analytical indexes by IMAP^package_id^' ||  package_id_ || '^table_name_^' || table_name_;
      ELSE
         info_entry_ := 'Removing analytical indexes by BI^' || 'table_name_^' || table_name_ || '^' || description_;
      END IF;

      parent_log_id_ := Server_Log_API.Log(
         NULL, 
         'In-Memory', 
         info_entry_,
         NULL);

      FOR rec_ IN get_indexes LOOP
         indx_sql_ := dbms_metadata.get_ddl('INDEX', rec_.index_name);
         Installation_SYS.Remove_Indexes(table_name_, rec_.index_name, TRUE);
         indx_count_ := indx_count_ + 1;
         info_entry_indx_ := info_entry_ || '^index_name^' || rec_.index_name;
         dummy_id_ := Server_Log_API.Log(
            parent_log_id_, 
            'In-Memory',
            info_entry_indx_,
            indx_sql_);
      END LOOP;
   END IF;
   RETURN indx_count_;
END Drop_Analythical_Indexes_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Post_Installation_Data
IS
   package_id_ in_memory_table_tab.package_id%TYPE := 0;
   newrec_     in_memory_table_tab%ROWTYPE;
   pkgrec_     in_memory_package_tab%ROWTYPE;
   CURSOR inmem_tables_of_package IS
      SELECT table_name
      FROM user_tables
      WHERE temporary = 'N'
      AND table_name = UPPER(table_name)
      AND iot_type IS NULL;
BEGIN
   pkgrec_.rowversion           := sysdate;
   pkgrec_.rowkey               := sys_guid();
   pkgrec_.package_id           := package_id_;
   pkgrec_.enabled              := 0;
   pkgrec_.is_custom_package    := 0;
   pkgrec_.package_name         := 'ALL TABLES IN IFS APPLICATIONS';
   BEGIN
      INSERT INTO in_memory_package_tab VALUES pkgrec_;
   EXCEPTION
      WHEN dup_val_on_index THEN
         NULL;
   END;
   FOR tbl_rec_ IN inmem_tables_of_package LOOP
      newrec_.package_id := package_id_;
      newrec_.table_name := tbl_rec_.table_name;
      IF Check_Exist___(newrec_.package_id, newrec_.table_name) = FALSE THEN
         New___(newrec_);
      END IF;
   END LOOP;
END Post_Installation_Data;

FUNCTION Get_Size_On_Disk_Mb (
   package_id_ NUMBER,
   table_name_ VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_value IS
      SELECT size_on_disk_mb 
      FROM   in_memory_table_ext t
      WHERE  t.package_id = package_id_
      AND    t.table_name = table_name_;
   size_on_disk_mb_ NUMBER;
BEGIN
   OPEN get_value;
   FETCH get_value INTO size_on_disk_mb_;
   CLOSE get_value;
   RETURN size_on_disk_mb_;
END Get_Size_On_Disk_Mb;

FUNCTION Get_Est_Size_On_Ram_Mb (
   package_id_ NUMBER,
   table_name_ VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_value IS
      SELECT est_size_on_ram_mb 
      FROM   in_memory_table_ext t
      WHERE  t.package_id = package_id_
      AND    t.table_name = table_name_;
   est_size_on_ram_mb_ NUMBER;
BEGIN
   OPEN get_value;
   FETCH get_value INTO est_size_on_ram_mb_;
   CLOSE get_value;
   RETURN est_size_on_ram_mb_;
END Get_Est_Size_On_Ram_Mb;

FUNCTION Get_Not_Populated_Mb (
   package_id_ NUMBER,
   table_name_ VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_value IS
      SELECT not_populated_mb 
      FROM   in_memory_table_ext t
      WHERE  t.package_id = package_id_
      AND    t.table_name = table_name_;
   not_populated_mb_ NUMBER;
BEGIN
   OPEN get_value;
   FETCH get_value INTO not_populated_mb_;
   CLOSE get_value;
   RETURN not_populated_mb_;
END Get_Not_Populated_Mb;

FUNCTION Get_Populate_Status (
   package_id_ NUMBER,
   table_name_ VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_value IS
      SELECT populate_status 
      FROM   in_memory_table_ext t
      WHERE  t.package_id = package_id_
      AND    t.table_name = table_name_;
   populate_status_ VARCHAR2(13);
BEGIN
   OPEN get_value;
   FETCH get_value INTO populate_status_;
   CLOSE get_value;
   RETURN populate_status_;
END Get_Populate_Status;

FUNCTION Get_Inmemory (
   package_id_ NUMBER,
   table_name_ VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_value IS
      SELECT inmemory 
      FROM   in_memory_table_ext t
      WHERE  t.package_id = package_id_
      AND    t.table_name = table_name_;
   inmemory_ VARCHAR2(8);
BEGIN
   OPEN get_value;
   FETCH get_value INTO inmemory_;
   CLOSE get_value;
   RETURN inmemory_;
END Get_Inmemory;

FUNCTION Get_Inmemory_Size_Mb (
   package_id_ NUMBER,
   table_name_ VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_value IS
      SELECT inmemory_size_mb 
      FROM   in_memory_table_ext t
      WHERE  t.package_id = package_id_
      AND    t.table_name = table_name_;
   inmemory_size_mb_ NUMBER;
BEGIN
   OPEN get_value;
   FETCH get_value INTO inmemory_size_mb_;
   CLOSE get_value;
   RETURN inmemory_size_mb_;
END Get_Inmemory_Size_Mb;
