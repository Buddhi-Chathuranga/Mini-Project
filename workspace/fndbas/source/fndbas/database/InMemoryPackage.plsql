-----------------------------------------------------------------------------
--
--  Logical unit: InMemoryPackage
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

CURSOR inmem_tables_of_package___ (package_id_ NUMBER) IS
   SELECT 
      t.package_id, 
      t.table_name
      , inmemory 
   FROM in_memory_tables_n_cfts t
   JOIN fnd_dba_tables a
   ON t.table_name = a.table_name
   WHERE t.package_id = package_id_;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT in_memory_package_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2)
IS
BEGIN
   newrec_.package_id := in_memory_package_id_seq.nextval;
   newrec_.enabled := 0;
   newrec_.is_custom_package := 1; -- all user created packages are custom packages
   Client_SYS.Add_To_Attr('IS_CUSTOM_PACKAGE', '1', attr_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     in_memory_package_tab%ROWTYPE,
   newrec_ IN OUT in_memory_package_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF newrec_.is_custom_package = 0 THEN 
      Error_SYS.Appl_General(
         lu_name_, 
         'UNMODIFIABLE: IFS In-Memory package [:P1] cannot be modified.', 
         newrec_.package_name);
   END IF;
END Check_Update___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     in_memory_package_tab%ROWTYPE,
   newrec_     IN OUT in_memory_package_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN 
   IF oldrec_.enabled = 1 THEN
      Disable_In_Memory_(oldrec_.package_id);
   END IF;
   newrec_.enabled := 0;
   
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN     in_memory_package_tab%ROWTYPE )
IS
BEGIN
   IF remrec_.is_custom_package = 0 THEN 
      Error_SYS.Appl_General(
         lu_name_, 
         'UNREMOVABLECUST: IFS In-Memory package [:P1] cannot be removed. Only customer made packages can be removed.', 
         remrec_.package_name);
   END IF;
   
   IF remrec_.enabled = 1 THEN 
      Error_SYS.Appl_General(
         lu_name_, 
         'UNREMOVABLE: In-Memory package [:P1] cannot be removed while it''s In-Memory enabled.', 
         remrec_.package_name);
   END IF;
   
   super(remrec_);
END Check_Delete___;

   
FUNCTION Is_Package_Inmem_Enabled___ (
   package_id_ NUMBER) RETURN BOOLEAN
IS
   enabled_ NUMBER := 0;
BEGIN
   enabled_ := Get_Enabled(package_id_);
   
   IF enabled_ IS NULL OR enabled_ = 0 THEN
      RETURN FALSE;
   ELSE 
      RETURN TRUE;
   END IF;  
END Is_Package_Inmem_Enabled___;


PROCEDURE Mark_Package_Inmem_Enabled___ (
   package_id_ NUMBER)
IS
BEGIN  
   UPDATE in_memory_package_tab
      SET enabled = 1
   WHERE package_id = package_id_;
END Mark_Package_Inmem_Enabled___;


PROCEDURE Mark_Package_Inmem_Disabled___ (
   package_id_ NUMBER)
IS
BEGIN  
   UPDATE in_memory_package_tab
      SET enabled = 0
   WHERE package_id = package_id_;
END Mark_Package_Inmem_Disabled___;


FUNCTION Im_Dependant_Pkg_Exists___ (
   package_id_ NUMBER,
   table_name_ VARCHAR2) RETURN BOOLEAN
IS
   CURSOR other_enabled_pkgs_of_tbl_ (package_id_ NUMBER, table_name_ VARCHAR2) IS
      SELECT enabled 
      FROM in_memory_tables_n_cfts t 
      JOIN in_memory_package_tab p
      ON   t.package_id = p.package_id
      WHERE t.table_name = table_name_
      AND  t.package_id != package_id_
      AND  p.enabled = 1;
   
   package_rec_ other_enabled_pkgs_of_tbl_%ROWTYPE;
BEGIN
   OPEN other_enabled_pkgs_of_tbl_(package_id_, table_name_);
   FETCH other_enabled_pkgs_of_tbl_ INTO package_rec_;
   CLOSE other_enabled_pkgs_of_tbl_;
   
   RETURN package_rec_.enabled IS NOT NULL;
END Im_Dependant_Pkg_Exists___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Estimate_Im_Size_Bg_Tsk_ (
   package_id_ VARCHAR2)
IS     

BEGIN   
   FOR tbl_rec_ IN inmem_tables_of_package___(to_number(package_id_)) LOOP
      In_Memory_Comp_Advisor_API.Submit_I_M_Estimation(tbl_rec_.table_name);
   END LOOP;   
END Estimate_Im_Size_Bg_Tsk_;

@UncheckedAccess
FUNCTION Im_Pkg_Load_Completion__ (
   package_id_ NUMBER) RETURN NUMBER
IS 
   CURSOR loading_progress_ (package_id_ NUMBER) IS
      SELECT (100*SUM(us.bytes - NVL(im.bytes_not_populated, us.bytes))/SUM(us.bytes)) progress
      FROM            user_segments us
      LEFT OUTER JOIN fnd_im_segments im
      ON    us.segment_name = im.segment_name
      JOIN  in_memory_tables_n_cfts tt
      ON    us.segment_name = tt.table_name
      WHERE us.segment_type = 'TABLE'
      AND   tt.package_id = package_id_
      AND   us.bytes > 1024 * 1024;

   load_prog_ NUMBER;
BEGIN
   IF Get_Enabled(package_id_) = 0 THEN
      RETURN 0;
   END IF;
   
   OPEN loading_progress_(package_id_);
   FETCH loading_progress_ INTO load_prog_;
   CLOSE loading_progress_;
   RETURN load_prog_;
END Im_Pkg_Load_Completion__;

FUNCTION All_Tbls_Flag_Completed__(
   package_id_ NUMBER) RETURN BOOLEAN 
IS
   CURSOR get_tables_of_package_ (package_id_ NUMBER) IS
      SELECT *
      FROM in_memory_package_tab p
      JOIN in_memory_tables_n_cfts t
      ON p.package_id = t.package_id
      LEFT OUTER JOIN fnd_im_segments s
      ON t.table_name = s.segment_name
      WHERE p.package_id = package_id_;
BEGIN
   FOR rec_ IN get_tables_of_package_(package_id_) LOOP
      IF rec_.populate_status <> 'COMPLETED' THEN 
         RETURN FALSE;
      END IF;
   END LOOP;
   RETURN TRUE;
END All_Tbls_Flag_Completed__;

@UncheckedAccess
FUNCTION Estimated_Im_Size__ (
	package_id_ NUMBER) RETURN NUMBER
IS
   CURSOR estimated_size_on_ram_ (package_id_ NUMBER) IS
      SELECT sum(size_on_ram)
      FROM in_memory_package_tab
      JOIN in_memory_tables_n_cfts t
      ON   in_memory_package_tab.package_id = t.package_id
      JOIN (SELECT *
            FROM  in_memory_comp_advisor ca
            WHERE finished_time = (SELECT finished_time
                                  FROM (SELECT *
                                        FROM   in_memory_comp_advisor r
                                        ORDER  by r.finished_time desc) t
                                  WHERE ca.table_name = t.table_name
                                  AND   rownum = 1)) in_memory_comp_advisor
      ON t.table_name = in_memory_comp_advisor.table_name
      WHERE in_memory_package_tab.package_id = package_id_;
      
   CURSOR unfinished_estimates_count_ (package_id_ NUMBER) IS
      SELECT count(*) unfinised_estimate_count
      FROM (SELECT *
            FROM in_memory_comp_advisor_tab t
            WHERE t.estimate_id = (SELECT estimate_id
                                    FROM (SELECT it.estimate_id
                                          FROM in_memory_comp_advisor_tab it
                                          WHERE t.table_name = it.table_name
                                          ORDER BY it.submited_time DESC)
                                    WHERE rownum = 1)) cat
      JOIN  in_memory_tables_n_cfts mt
      ON    cat.table_name = mt.table_name
      WHERE mt.package_id = package_id_
      AND   cat.finished_time is null;
   
   unfinished_estimate_n_ NUMBER;   
   size_on_ram_ NUMBER;
BEGIN
   OPEN unfinished_estimates_count_(package_id_);
   FETCH unfinished_estimates_count_ INTO unfinished_estimate_n_;
   CLOSE unfinished_estimates_count_;
   
   IF unfinished_estimate_n_ > 0 THEN 
      RETURN 0;
   END IF;
   
   OPEN estimated_size_on_ram_(package_id_);
   FETCH estimated_size_on_ram_ INTO size_on_ram_;
   CLOSE estimated_size_on_ram_;
   
   RETURN nvl(round(size_on_ram_/1024/1024, 0),0);
END Estimated_Im_Size__;


@UncheckedAccess
FUNCTION Actual_Im_Size__ (
   package_id_ NUMBER) RETURN NUMBER
IS
   CURSOR ram_used_by_package_ (package_id_ NUMBER) IS
      SELECT sum(inmemory_size)
      FROM   in_memory_package_tab p
      JOIN   in_memory_tables_n_cfts t
      ON     p.package_id = t.package_id
      JOIN   Fnd_Im_Segments im
      ON     t.table_name = im.segment_name
      WHERE  p.package_id = package_id_;
   CURSOR is_package_enabled_ (package_id_ NUMBER) IS
      SELECT enabled
      FROM in_memory_package_tab
      WHERE package_id = package_id_;
   
   ram_size_ NUMBER;
   pkg_im_enabled_ NUMBER;
BEGIN
   OPEN is_package_enabled_(package_id_);
   FETCH is_package_enabled_ INTO pkg_im_enabled_;
   CLOSE is_package_enabled_;
   
   IF pkg_im_enabled_ IS NULL OR pkg_im_enabled_ = 0 THEN
      RETURN 0;
   END IF;
   
   OPEN ram_used_by_package_(package_id_);
   FETCH ram_used_by_package_ INTO ram_size_;
   CLOSE ram_used_by_package_;
   IF ram_size_ IS NULL THEN 
      RETURN 0;
   ELSE 
      RETURN round(ram_size_/1024/1024, 0);
   END IF;
END Actual_Im_Size__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Enable_In_Memory_ (
   package_id_ NUMBER)
IS        
BEGIN
   IF Is_Package_Inmem_Enabled___(package_id_) THEN
      RETURN;
   END IF;
   
   FOR tbl_rec_ IN inmem_tables_of_package___(package_id_) LOOP 
      -- although this package is not in-memory enabled this table might be already in-memory enabled by some other means
      IF (NOT tbl_rec_.inmemory = 'ENABLED') THEN
         In_Memory_Table_API.Enable_Inmem_For_Table_(tbl_rec_.table_name);
      END IF;
   END LOOP;
   Mark_Package_Inmem_Enabled___(package_id_);
END Enable_In_Memory_;


PROCEDURE Disable_In_Memory_ (
   package_id_ NUMBER)
IS
BEGIN
   IF NOT Is_Package_Inmem_Enabled___(package_id_) THEN
      RETURN;
   END IF;
   
   FOR tbl_rec_ IN inmem_tables_of_package___(package_id_) LOOP 
      IF NOT Im_Dependant_Pkg_Exists___(tbl_rec_.package_id, tbl_rec_.table_name) THEN
         In_Memory_Table_API.Disable_Inmem_For_Tbl_(tbl_rec_.table_name);
      END IF;
   END LOOP;
   Mark_Package_Inmem_Disabled___(package_id_);
END Disable_In_Memory_;


FUNCTION Create_In_Memory_Package_(
   package_name_ VARCHAR2,
   is_custom_package_ BOOLEAN DEFAULT FALSE,
   is_info_source_ BOOLEAN DEFAULT FALSE) RETURN NUMBER
IS
   newrec_ in_memory_package_tab%ROWTYPE;
   old_package_id_ NUMBER;

   FUNCTION Bool_To_Db_ (
      bool_ BOOLEAN) RETURN NUMBER
   IS
   BEGIN
      IF bool_ THEN 
         RETURN 1;
      ELSE 
         RETURN 0;
      END IF;
   END;
      
BEGIN
   old_package_id_ := Get_Package_id(package_name_);
   IF old_package_id_ IS NOT NULL THEN 
      RETURN old_package_id_;
   END IF;
         
   newrec_.rowversion            := sysdate;
   newrec_.rowkey                := sys_guid();
   newrec_.package_id            := in_memory_package_id_seq.nextval;
   newrec_.enabled               := 0;
   newrec_.is_custom_package     := Bool_To_Db_(is_custom_package_);
   newrec_.is_information_source := Bool_To_Db_(is_info_source_);
   newrec_.package_name          := UPPER(package_name_);
   
   INSERT INTO in_memory_package_tab VALUES newrec_;
   @ApproveTransactionStatement(2015-07-16,rodhlk)
   COMMIT;
   RETURN newrec_.package_id;
END Create_In_Memory_Package_;


PROCEDURE Add_Table_To_IMAP_(
   package_id_ NUMBER,
   table_name_ VARCHAR2)
IS
   newrec_ in_memory_table_tab%ROWTYPE;
BEGIN
   Assert_SYS.Assert_Is_Table(table_name_);
         
   IF In_Memory_Table_Api.Exists(package_id_, UPPER(table_name_)) THEN
      RETURN;
   END IF;
   
   newrec_.rowversion := sysdate;
   newrec_.rowkey     := sys_guid();
   newrec_.package_id := package_id_;
   newrec_.table_name := UPPER(table_name_);
   
   INSERT INTO in_memory_table_tab VALUES newrec_;
   @ApproveTransactionStatement(2015-07-16,rodhlk)
   COMMIT;
END Add_Table_To_IMAP_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Enable_In_Memory (
   package_id_ NUMBER)
IS
BEGIN
   Enable_In_Memory_(package_id_);
END Enable_In_Memory;


PROCEDURE Disable_In_Memory (
   package_id_ NUMBER)
IS
BEGIN
   Disable_In_Memory_(package_id_);
END Disable_In_Memory;


PROCEDURE Estimate_In_Memory_Size (
   package_id_ NUMBER)
IS
   in_memory_desc_ VARCHAR2(200);
   package_name_ VARCHAR2(64);   
BEGIN
   package_name_ := Get_Package_Name(package_id_);
   in_memory_desc_ := 'In-Memory compression ratio estimator job for [' || package_name_ || ']';        
   Transaction_SYS.Deferred_Call('In_Memory_Package_API.Estimate_Im_Size_Bg_Tsk_', to_char(package_id_), in_memory_desc_); 
END Estimate_In_Memory_Size;


FUNCTION Remove_Analythical_Idx_Of_Pkg (
   package_id_ NUMBER) RETURN NUMBER
IS
   CURSOR get_tables IS
      SELECT table_name
      FROM   in_memory_table_tab
      WHERE  package_id = package_id_;

   indx_rem_count_ NUMBER := 0;
   n_indx_ NUMBER := 0;
BEGIN
   IF Get_Enabled(package_id_) = 1 THEN
      FOR rec_ IN get_tables LOOP
         n_indx_ := In_Memory_Table_API.Drop_Analythical_Indexes_(rec_.table_name, package_id_);
         indx_rem_count_ := indx_rem_count_ + n_indx_;
      END LOOP;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'IM_PKG: The In Memory acceleration package must be enabled to drop the indexes.');
   END IF;
   RETURN indx_rem_count_;
END Remove_Analythical_Idx_Of_Pkg;


FUNCTION Is_In_Memory_Enabled
   RETURN NUMBER
IS
BEGIN 
   IF Dictionary_SYS.Component_Is_Installed('INMEMORY') THEN  
      RETURN 1;
   ELSE 
      RETURN 0;
   END IF;
END Is_In_Memory_Enabled;


FUNCTION Get_Package_id (
   package_name_ VARCHAR2) RETURN NUMBER
IS
   package_id_ NUMBER;
BEGIN
   SELECT package_id
   INTO package_id_
   FROM In_Memory_Package_Tab t
   WHERE t.package_name = UPPER(package_name_)
   ORDER BY package_id
   FETCH FIRST ROW ONLY;

   RETURN package_id_;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN NULL;
END Get_Package_id;
