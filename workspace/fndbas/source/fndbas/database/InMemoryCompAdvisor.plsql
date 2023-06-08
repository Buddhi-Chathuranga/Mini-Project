-----------------------------------------------------------------------------
--
--  Logical unit: InMemoryCompAdvisor
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150605  RODHLK  Created to facilitate estimations of In-Memory size per table
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT in_memory_comp_advisor_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2)
IS
BEGIN
   newrec_.estimate_id := in_memory_comp_advisor_id_seq.nextval;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Estimate_Comp_Ratio___ (
   table_name_ VARCHAR2,
   compression_type_ NUMBER) RETURN NUMBER
IS   
   zero_rows_found EXCEPTION;
   PRAGMA exception_init(zero_rows_found, -20000);
   schema_name_ VARCHAR2(64);
   blkcnt_cmp_   PLS_INTEGER;
   blkcnt_uncmp_ PLS_INTEGER;
   row_comp_     PLS_INTEGER;
   row_uncmp_    PLS_INTEGER;
   cmp_ratio_    NUMBER;
   comptype_     VARCHAR2(300);
BEGIN
   schema_name_ := Fnd_Session_API.Get_App_Owner;
   
   Dbms_Compression.get_compression_ratio (
   '&IFSAPP_DATA', -- Temporary scratch tablespace that can be used for analysis
   schema_name_,
   table_name_,
   NULL, -- if partitioned then partition name to sample from.
   compression_type_,
   blkcnt_cmp_,
   blkcnt_uncmp_,
   row_comp_,
   row_uncmp_,
   cmp_ratio_,
   comptype_);
   
   RETURN cmp_ratio_;
EXCEPTION
   -- if table being estimated has zero rows then compression ratio is 1
   WHEN zero_rows_found THEN 
      RETURN 1;
END Estimate_Comp_Ratio___;


FUNCTION Is_Estimate_Cached___ (
   table_name_ VARCHAR2,
   compression_type_ NUMBER) RETURN BOOLEAN
IS
   size_on_disk_ NUMBER;
   disk_size_tollerence_ CONSTANT NUMBER := 10*1024*1024;
   cached_estimates_ in_memory_comp_advisor_tab%ROWTYPE;
   cached_entry_exsists_ BOOLEAN;
   within_tollereble_size_diff_ BOOLEAN;
   recently_estimated_ BOOLEAN;
   
   CURSOR table_size_on_disk_(table_name_ VARCHAR2) IS
      SELECT SUM(bytes) FROM Fnd_Dba_Segments 
      WHERE segment_name = table_name_;
  
   CURSOR cached_estimates_for_table_(table_name_ VARCHAR2, compression_type_ NUMBER) IS
      SELECT * 
      FROM  in_memory_comp_advisor_tab 
      WHERE table_name = table_name_ 
      AND   compression_type = compression_type_
      ORDER BY finished_time
      FETCH FIRST ROW ONLY;
BEGIN
   OPEN table_size_on_disk_(table_name_);
   FETCH table_size_on_disk_ INTO size_on_disk_;
   CLOSE table_size_on_disk_;
   
   OPEN cached_estimates_for_table_(table_name_, compression_type_);
   FETCH cached_estimates_for_table_ INTO cached_estimates_;
   CLOSE cached_estimates_for_table_;
   
   cached_entry_exsists_ := cached_estimates_.table_name IS NOT NULL;
   within_tollereble_size_diff_ := abs(cached_estimates_.size_on_disk - size_on_disk_) < disk_size_tollerence_;
   recently_estimated_ := cached_estimates_.finished_time + 30 > sysdate;
   
   RETURN (cached_entry_exsists_ AND within_tollereble_size_diff_ AND recently_estimated_);
   
END Is_Estimate_Cached___;



-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

FUNCTION Fnd_Setting_To_System_Num_
   RETURN NUMBER
IS
   compression_type_ NUMBER DEFAULT Dbms_Compression.COMP_INMEMORY_QUERY_LOW;
   compression_level_ VARCHAR2(100);

BEGIN
   
   compression_level_ := Fnd_Setting_API.Get_Value('IM_COMP_LEVEL');
   
   IF Dictionary_SYS.Is_Db_Inmemory_Supported THEN
      IF compression_level_ = 'DML' THEN
         compression_type_ := Dbms_Compression.COMP_INMEMORY_DML;

      ELSIF compression_level_ = 'QUERY_LOW' THEN
         compression_type_ := Dbms_Compression.COMP_INMEMORY_QUERY_LOW;

      ELSIF compression_level_ = 'QUERY_HIGH' THEN
         compression_type_ := Dbms_Compression.COMP_INMEMORY_QUERY_HIGH;

      ELSIF compression_level_ = 'CAPACITY_LOW' THEN
         compression_type_ := Dbms_Compression.COMP_INMEMORY_CAPACITY_LOW;

      ELSIF compression_level_ = 'CAPACITY_HIGH' THEN
         compression_type_ := Dbms_Compression.COMP_INMEMORY_CAPACITY_HIGH;
      END IF;
   END IF;

   RETURN compression_type_;
   
END Fnd_Setting_To_System_Num_;

   
PROCEDURE Cleanup_Estimate_Cache_
IS
BEGIN
   DELETE FROM in_memory_comp_advisor_tab
   WHERE finished_time IS NULL 
      OR finished_time < sysdate - 30;
END Cleanup_Estimate_Cache_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Submit_I_M_Estimation (
   table_name_ VARCHAR2)
IS
   objid_      VARCHAR2(32);
   objversion_ VARCHAR2(32);
   newrec_     in_memory_comp_advisor_tab%ROWTYPE;
   attr_       VARCHAR2(300);
   estimate_id_ VARCHAR2(32);
   size_on_disk_ NUMBER;
   
   tbl_name_ VARCHAR2(100);
   compression_type_ NUMBER;
   estimated_com_ratio_ NUMBER;
   
   CURSOR table_size_on_disk_(table_name_ VARCHAR2) IS
      SELECT SUM(bytes) FROM dba_segments 
      WHERE segment_name = table_name_;
   
BEGIN
   tbl_name_ := upper(table_name_);
   Assert_SYS.Assert_Is_Table(tbl_name_);
   
   compression_type_ := Fnd_Setting_To_System_Num_();
      
   IF (Is_Estimate_Cached___(tbl_name_, compression_type_)) THEN
      RETURN;
   END IF;
   
   OPEN table_size_on_disk_(tbl_name_);
   FETCH table_size_on_disk_ INTO size_on_disk_;
   CLOSE table_size_on_disk_;
   
   IF size_on_disk_ IS NULL OR size_on_disk_ < 1024*1024 THEN
      RETURN;
   END IF;
   
   newrec_.table_name := tbl_name_;
   newrec_.submited_time := sysdate;
   newrec_.user_name := Fnd_Session_API.Get_Fnd_User;
   newrec_.compression_type := compression_type_;
   newrec_.size_on_disk := size_on_disk_;
   
   Insert___(objid_, objversion_, newrec_, attr_);
   estimate_id_ := newrec_.ESTIMATE_ID;   
   
   estimated_com_ratio_ := Estimate_Comp_Ratio___(table_name_, compression_type_);   
   UPDATE in_memory_comp_advisor_tab
      SET finished_time = SYSDATE, compression_ratio = estimated_com_ratio_
   WHERE estimate_id = estimate_id_;

END Submit_I_M_Estimation;