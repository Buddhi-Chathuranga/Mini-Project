-----------------------------------------------------------------------------
--
--  Logical unit: Installation
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  040315  HAAR  Created
--  040513  HAAR  Moved Format_Import_File and Write_Table_Ddl to Installation_SYS
--                from Database_SYS.
--  040514  HAAR  Added Log_Time_Stamp_Enable, Log_Time_Stamp_Disable and Log_Time_Stamp.
--  040527  HAAR  Removed Log_Time_Stamp_Enable and Log_Time_Stamp_Disable.
--                Added Log_Time_Stamp_Setup.
--  041006  ASWI  Method Show_Message___ added (Bug#47278).
--  041223  HAAR  Added method Rename_Column (F1PR480).
--  050111  ROOD  Added methods for db_patch registration (Bug#48184).
--  050317  HAAR  Added Primary_Key_Constraint_Exist (F1PR483).
--                Added check in Create_Constraint if PK already exists
--  050523  HAAR  Added Grant_Privileged_Grantee (F1PR840).
--  050603  HAAR  Added support for LOB columns (F1PR840).
--                Added Add_Lob_Column and Remove_Lob_Column.
--  050831  HAAR  Added grants for PLSQLAP_Environment_Tab in Grant_Privileged_Grantee___ (F1PR413G).
--  050912  HAAR  Added grant select on table to LOB (F1PR840).
--  051102  HAAR  Removed grant to CR_WEB_INIT.
--  051111  HAAR  Removed special treatment of Installation_SYS (F1PR483).
--  051117  JEHU  Added special grant on BINARY_OBJECT_DATA_BLOCK needed by fndext.
--  051208  HAAR  Added Oracle system privilege MERGE ANY VIEW to privileged users.
--                This is needed to keep backward compatibility in Oracle10g R2 and above.
--  051220  HAAR  Added Post_Installation_Object and Post_Installation_Data.
--  060104  HAAR  Added grants needed for Solution Manager (F1PR480).
--  060505  HAAR  Added Alter_Long_Column_To_Lob and Create_Temporary_Table (Bug#57770).
--  060908  HAAR  Added Mtrl_View_Log_Exist, Mtrl_View_Exist, Remove_Materialized_View
--                and Remove_Materialized_View_Log (Bug#59182).
--  061206  HAAR  Added method Log_Detail_Time_Stamp, Show_Info___ and Set_Show_Info (Bug#62280).
--  061227  HAAR  Added Pre_Register and Create_And_Set_Version (Bug#62523).
--  070111  HAAR  Added method Create_Text_Index for Application Search 
--                Added method Create_Trigger (F1PR458).
--  070112  HAAR  Changed so that parent_log_id_ is only set when null (Bug#61829).
--  070611  HAAR  Added method Alter_Lob_Column (Bug#65912).
--  071024  HAAR  Remove BYTE from columns of type VARCHAR2 (Bug#68674).
--  071029  HAAR  Changed error handling of NULL in Alter_Table_Column (Bug#67483).
--  080410  HAAR  Added Text_Index_Exists (Bug#67895).
--  081203  DUWI  Changed coding in Grant_Privileged_Grantee___ to improve performance (Bug#78928).
--  090119  HAAR  Alter_Lob_Column checks if column exists (Bug#79888).
--  090308  HAAR  Added methods for Rising and 7/11 project (Bug#81205).
--  090326  HAAR  Added additional granting to IFSSYS (Bug#81576).
--  090504  HAAR  Fixed bug in Add_Lob_Column (Bug#82591).
--  090714  RISR  Modified Remove_Materialized_View. Merged 77385 correction(Bug#77385)
--  090819  NABA  Certified the assert safe for dynamic SQLs (Bug#84218) 
--  091001  HAAR  Added support for changing language (EACS-123).
--  100315  DUWI  Added procedure Shrink_Lob_Segment. (Bug#87984).
--  100405  CHMU  Changed Coding in Alter_Table_Column___. Added method Is_Column_Modified___. (Bug#89748)
--  100507  NaBa  Added Get_Column_Type (Bug#90473)
--  100528  HAAR  Added methods for stopping Dbms_Scheduler jobs (EACS-750).
--  110518  DUWI  Merged the bug 93734 (EASTONE-12982)
--  110711  MaBo  Added method Show_Db_Obj_Invalid_Count (Bug#94266)
--  110903  NaBa  Changed some message texts to improve their idea (RDTERUNTIME-686)
--  120309  MaDr  Added grants to SECURITY_SYS_REFRESH_USER_TAB in Grant_Ifssys (RDTERUNTIME-2239)
--  120705  MaBose  Conditional compiliation improvements - Bug 103910
--  120927  MaBo  Bug-105328 Added methods for alter empty views
--  130716  MADD  Changed Alter_Lob_Column,Format_Column and Is_Column_Modified___ to handle modification for lob columns.(Bug#109097
--  141015  MADR  Added grants required by Batch Processor JMS (TEJSE-200)
--  141128  CHMULK Using USER_PROCEDURES for method exist checks. (Bug#119168/TEBASE-768)
--  150519  Mabose Bug-122618
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------

ORA_MAX_NAME_LEN            CONSTANT NUMBER :=  dbms_standard.ORA_MAX_NAME_LEN;
TYPE ColRec IS RECORD (
     table_name   VARCHAR2(ORA_MAX_NAME_LEN),
     column_name   VARCHAR2(4000),
     data_type     VARCHAR2(ORA_MAX_NAME_LEN),
     nullable      VARCHAR2(1),
     default_value VARCHAR2(100),
     lob_parameter VARCHAR2(4000),
     keep_default  VARCHAR2(1));
TYPE ColumnTabType    IS TABLE OF ColRec  INDEX BY BINARY_INTEGER;
TYPE ColViewRec IS RECORD (
     column_name    VARCHAR2(ORA_MAX_NAME_LEN),
     column_source  VARCHAR2(4000),
     column_comment VARCHAR2(4000));
TYPE ColumnViewType   IS TABLE OF ColViewRec  INDEX BY BINARY_INTEGER;

TYPE ObjectRec  IS RECORD (object_name    VARCHAR2(ORA_MAX_NAME_LEN));
TYPE ObjectArray IS TABLE OF ObjectRec  INDEX BY BINARY_INTEGER;

TYPE IndexRec  IS RECORD (index_name    VARCHAR2(ORA_MAX_NAME_LEN), index_type    VARCHAR2(30));
TYPE IndexArray IS TABLE OF IndexRec  INDEX BY BINARY_INTEGER;

-------------------- PRIVATE DECLARATIONS -----------------------------------

log_time_stamp_   VARCHAR2(100);
gc_persistent_    VARCHAR2(100);
gc_time_       NUMBER                 := To_Number(To_Char(localtimestamp, 'J'))*86400 + To_Number(To_Char(localtimestamp, 'SSSSSxFF9'));
detail_time_   NUMBER                 := To_Number(To_Char(localtimestamp, 'J'))*86400 + To_Number(To_Char(localtimestamp, 'SSSSSxFF9'));
begin_mark_    CONSTANT VARCHAR2(2)   := '[';
end_mark_      CONSTANT VARCHAR2(2)   := ']';
begin_         CONSTANT VARCHAR2(2)   := '[';
end_           CONSTANT VARCHAR2(2)   := ']';
nl_            CONSTANT VARCHAR2(2)   := chr(10);
parent_log_id_ NUMBER;
audit_id_      VARCHAR2(100);
gc_show_info_  BOOLEAN := FALSE;
installation_  BOOLEAN := FALSE;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Alter_Table_Column___ (
   procedure_name_  IN VARCHAR2,
   table_name_      IN VARCHAR2,
   alter_type_      IN VARCHAR2,
   column_          IN ColRec,
   show_info_       IN BOOLEAN DEFAULT FALSE )
IS
   chk_alter_type_  VARCHAR2(20);
   ok_              NUMBER := 1;
   stmnt_           VARCHAR2(4000);
   col_string_      VARCHAR2(4000);
   wrong_alter_type EXCEPTION;
   column_rec_      Installation_SYS.ColRec := column_;

   alter_domain_index EXCEPTION;
   PRAGMA             EXCEPTION_INIT(alter_domain_index, -29885);
BEGIN
   column_rec_.table_name := table_name_;
   IF NOT (Table_Exist ( table_name_ ) ) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ (procedure_name_ || ': Table ' || table_name_ || ' does not exist.');
      END IF;
      ok_ := 0;
   ELSE
      chk_alter_type_ := alter_type_;
      IF (alter_type_ LIKE 'A%') THEN
         chk_alter_type_ := 'ADD';
      ELSIF (alter_type_ LIKE 'M%') THEN
         chk_alter_type_ := 'MODIFY';
      ELSIF (alter_type_ LIKE 'D%') THEN
         chk_alter_type_ := 'DROP COLUMN';
      ELSE
         RAISE wrong_alter_type;
      END IF;
      IF (chk_alter_type_ = 'ADD') THEN
         IF (column_rec_.data_type IS NULL) THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___ (procedure_name_ || ': Table/Column ' || table_name_ || '/' || column_rec_.column_name || ' must have a datatype to be added.');
            END IF;
            ok_ := 0;
         END IF;
         IF (Column_Exist ( table_name_, column_rec_.column_name)) THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___ (procedure_name_ || ': Table/Column ' || table_name_ || '/' || column_rec_.column_name || ' already exist.');
            END IF;
            ok_ := 0;
         END IF;
      ELSIF (chk_alter_type_ = 'MODIFY') THEN
         IF NOT (Column_Exist ( table_name_, column_rec_.column_name)) THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___ (procedure_name_ || ' error: Table/Column ' || table_name_ || '/' || column_rec_.column_name || ' does not exist.');
            END IF;
            ok_ := 0;
         ELSIF NOT Is_Column_Modified___(table_name_,column_rec_) THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___ (procedure_name_ || ': Table/Column ' || table_name_ || '/' || column_rec_.column_name || ' already modified.');
            END IF;
            ok_ := 0;
         ELSIF (column_rec_.column_name = 'ROWKEY' AND               -- Special handling for ROWKEY
                nvl(column_rec_.keep_default, 'N') != 'D' AND                  -- If Disable let it run
                Is_Column_Modified___(table_name_, column_rec_)) THEN -- if it is changed
            -- Special handling for ROWKEY
               Show_Message___ (procedure_name_ || ': Table/Column ' || table_name_ || '/' || column_rec_.column_name || ' cannot be enabled or disabled with this interface.');
            ok_ := 0;            
         END IF;
      ELSIF (chk_alter_type_ = 'DROP COLUMN') THEN
         IF NOT (Column_Exist ( table_name_, column_rec_.column_name)) THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___ (procedure_name_ || ': Table/Column ' || table_name_ || '/' || column_rec_.column_name || ' does not exist.');
            END IF;
            ok_ := 0;
         END IF;
      END IF;
   END IF;
   IF (ok_ = 1) THEN
      IF (chk_alter_type_ = 'DROP COLUMN') THEN
         col_string_ := Installation_SYS.Format_Column(column_rec_, 'INDEX');
      ELSE
         col_string_ := Installation_SYS.Format_Column(column_rec_, 'TABLE');
      END IF;
      Remove_Extended_Stats___(table_name_, column_.column_name);
      stmnt_ := 'ALTER TABLE ' || table_name_ || ' ' || chk_alter_type_ || ' ' || col_string_;
      Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
      IF (chk_alter_type_ = 'ADD') THEN
         IF  column_rec_.default_value IS NOT NULL
         AND column_rec_.default_value != '$DEFAULT_NULL$'
         AND UPPER(column_rec_.keep_default) = 'N' THEN
            stmnt_ := 'ALTER TABLE ' || table_name_ || ' MODIFY ' || column_rec_.column_name || ' DEFAULT NULL';
            Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
            IF  column_rec_.nullable = 'N' THEN
               stmnt_ := 'ALTER TABLE ' || table_name_ || ' MODIFY ' || column_rec_.column_name || ' NOT NULL';
               Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
            END IF;
         END IF;
         IF (Show_Info___(show_info_) = TRUE) THEN
            Show_Message___(procedure_name_ || ': Column ' || column_rec_.column_name || ' in table ' || table_name_ || ' is added.');
         END IF;
      ELSIF (chk_alter_type_ = 'MODIFY') THEN
         IF  column_rec_.default_value IS NOT NULL
         AND column_rec_.default_value != '$DEFAULT_NULL$'
         AND UPPER(column_rec_.keep_default) = 'N' THEN
            stmnt_ := 'ALTER TABLE ' || table_name_ || ' MODIFY ' || column_rec_.column_name || ' DEFAULT NULL';
            Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
         END IF;
         IF  column_rec_.nullable = 'N' AND Get_Column_Nullable(table_name_, column_.column_name) = 'Y' THEN
            stmnt_ := 'ALTER TABLE ' || table_name_ || ' MODIFY ' || column_rec_.column_name || ' NOT NULL';
            Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
         END IF;
         IF (Show_Info___(show_info_) = TRUE) THEN
            Show_Message___(procedure_name_ || ': Column ' || column_rec_.column_name || ' in table ' || table_name_||' is modified.');
         END IF;
      ELSIF (chk_alter_type_ = 'DROP COLUMN') THEN
         IF (Show_Info___(show_info_) = TRUE) THEN
            Show_Message___(procedure_name_ || ': Column ' || column_rec_.column_name || ' in table ' || table_name_ || ' is dropped.');
         END IF;
      END IF;
   END IF;
EXCEPTION
   WHEN wrong_alter_type THEN
      Show_Message___('Alter_Table_Column error: Wrong alter type, alter type must be ''A[LTER]'',''M[ODIFY]'' or ''D[ROP COLUMN]''.');
   WHEN alter_domain_index THEN
      Show_Message___('Alter_Table_Column error: Cannot alter a column which has a DOMAIN INDEX. To alter the column, drop the DOMAIN INDEX and rerun the script.');
   WHEN OTHERS THEN
      RAISE;
END Alter_Table_Column___;


FUNCTION Is_Table_Temporary___ (
   table_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   temporary_ VARCHAR2(10);
   CURSOR get_table_info IS
      SELECT temporary
      FROM   user_tables
      WHERE  table_name = UPPER(table_name_);
BEGIN
   OPEN  get_table_info;
   FETCH get_table_info INTO temporary_;
   CLOSE get_table_info;
   IF (temporary_ = 'Y') THEN
      RETURN(TRUE);
   ELSE
      RETURN(FALSE);
   END IF;
END Is_Table_Temporary___;

PROCEDURE Move_Index___ (
   procedure_name_  IN VARCHAR2,
   index_name_      IN VARCHAR2,
   tablespace_name_ IN VARCHAR2 DEFAULT 'IFSAPP_INDEX',
   show_info_       IN BOOLEAN  DEFAULT FALSE,
   forced_offline_  IN BOOLEAN  DEFAULT FALSE)
IS
   stmt_          VARCHAR2(2000);
   current_ts_    VARCHAR2(ORA_MAX_NAME_LEN);
BEGIN
   current_ts_ := UPPER(Get_TableSpace_Name(index_name_));
   IF current_ts_ != UPPER(tablespace_name_) THEN
      stmt_ := 'ALTER INDEX "'||index_name_||'" REBUILD TABLESPACE '|| tablespace_name_;
      IF Installation_SYS.Is_Option_Available('Online Index Build') AND NOT forced_offline_ THEN
         stmt_ := stmt_ || ' ONLINE ';
      END IF;
      IF Is_Table_Temporary___(Get_Index_Table(index_name_)) = FALSE 
      AND Get_Index_Type(index_name_) IN ('NORMAL', 'FUNCTION-BASED NORMAL') THEN
         stmt_ := stmt_ || ' PARALLEL ';
      END IF;
      Run_Ddl_Command___(stmt_, procedure_name_, show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Index ' || index_name_ || ' moved to tablespace '||tablespace_name_||'.');
      END IF;   
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Index ' || index_name_ || ' is already in tablespace '|| tablespace_name_ || '.');
      END IF;
   END IF;   
END Move_Index___;   

PROCEDURE Move_Table___ (
   procedure_name_  IN VARCHAR2,
   table_name_      IN VARCHAR2,
   tablespace_name_ IN VARCHAR2 DEFAULT 'IFSAPP_DATA',
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
   stmt_          VARCHAR2(2000);
   
   objects_ ObjectArray;   
   tab_   VARCHAR2(ORA_MAX_NAME_LEN) := UPPER(table_name_);
   current_ts_ VARCHAR2(128);

   CURSOR get_ind IS
      SELECT index_name
      FROM   user_indexes i
      WHERE  i.table_name = tab_
      AND    i.index_type != 'LOB';
       
BEGIN
   current_ts_ := UPPER(Get_TableSpace_Name(tab_));
   IF current_ts_ != UPPER(tablespace_name_) THEN
      stmt_ := 'ALTER TABLE "'||table_name_||'" MOVE TABLESPACE ' || tablespace_name_;    
      Run_Ddl_Command___(stmt_, procedure_name_, show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Table ' || table_name_ || ' moved.');
      END IF;
      -- Rebuild indexes for this table
      OPEN  get_ind;
      FETCH get_ind BULK COLLECT INTO objects_;
      CLOSE get_ind;
      FOR i IN Nvl(objects_.FIRST,0)..Nvl(objects_.LAST,-1) LOOP
         Rebuild_Index___ ('Move_Table___', objects_(i).object_name, show_info_, table_name_);
      END LOOP;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Table ' || table_name_ || ' is already in tablespace '|| tablespace_name_ || '.');
      END IF;
   END IF;   
END Move_Table___;  
   
FUNCTION Persistent_Logging___ (
   parent_log_id_ IN NUMBER,
   category_      IN VARCHAR2,
   module_        IN VARCHAR2,
   type_          IN VARCHAR2,
   what_          IN VARCHAR2,
   relative_time_ IN VARCHAR2 ) RETURN NUMBER
IS
   PRAGMA AUTONOMOUS_TRANSACTION;
   log_id_        NUMBER;
   stmt_          VARCHAR2(32000) :=
'DECLARE '||
'   time_          CONSTANT NUMBER        := To_Number(To_Char(localtimestamp, ''J''))*86400 + To_Number(To_Char(localtimestamp, ''SSSSSxFF9''));'||
'   sysdate_       CONSTANT DATE          := SYSDATE;'||
'   sys_date_      CONSTANT VARCHAR2(100) := to_char(sysdate_, ''YYYYMMDD HH24:MI:SS'');'||
'   timestamp_     CONSTANT TIMESTAMP     := systimestamp;'||
'   time_stamp_    CONSTANT VARCHAR2(100) := to_char(timestamp_, ''YYYYMMDD HH24:MI:SS:FF9'');'||
'   log_id_        NUMBER;'||
'   date_created_  DATE;'||
'   date_finished_ DATE;'||
'   category_id_   VARCHAR2(30) := :category_;'||
'   identity_      VARCHAR2(30);'||
'   os_identity_   VARCHAR2(100);'||
'   oracle_user_   VARCHAR2(30);'||
'   machine_       VARCHAR2(100);'||
'   program_       VARCHAR2(100);'||
'   ipaddress_     VARCHAR2(20);'||
'   auth_type_     VARCHAR2(100);'||
'   audit_id_      VARCHAR2(100)  := :audit_id_;'||
'   relative_time_ VARCHAR2(100)  := :relative_time_;'||
'   what_          VARCHAR2(100)  := :what_;'||
'   text1_         VARCHAR2(4000) := :module_ || '' '' || :type_ || '' '' || what_;'||
'   PROCEDURE get_info '||
'   IS '||
'         CURSOR get_session_info IS '||
'      SELECT s.username, s.osuser, s.machine, s.program,'||
'             Sys_Context(''USERENV'', ''IP_ADDRESS'') IPAddress,'||
'             Sys_Context(''USERENV'', ''AUTHENTICATION_METHOD'') Authentication_Type'||
'      FROM   sys.v_$session s'||
'      WHERE  s.audsid = Userenv(''SESSIONID'');'||
'   BEGIN '||
'      identity_     := USER;'||
'      date_created_ := sysdate_;'||
'      date_finished_:= NULL;'||
'      OPEN  get_session_info;'||
'      FETCH get_session_info'||
'         INTO oracle_user_, os_identity_, machine_, program_,'||
'              ipaddress_, auth_type_;'||
'      CLOSE get_session_info;'||
'   END; '||
'BEGIN '||
'   IF (what_ = ''Finished'') THEN'||
'      UPDATE server_log_tab'||
'      SET    date_finished = sysdate_,'||
'             text2 = relative_time_,'||
'             text1 = text1_,'||
'             audit_id = NULL'||
'      WHERE  audit_id = audit_id_;'||
'   ELSE '||
'      audit_id_  := SYS_GUID;'||
'      :audit_id_ := audit_id_;'||
'      Get_Info;'||
'      log_id_ := server_log_id_seq.NEXTVAL;'||
'      INSERT INTO server_log_tab '||
'         (log_id, parent_log_id, category_id, date_created, date_finished, '||
'          identity, oracle_user, os_identity, machine, program, ipaddress, auth_type, audit_id, '||
'          checked, '||
'          text1, '||
'          text2, '||
'          rowversion)'||
'      VALUES'||
'         (log_id_, :parent_log_id_, category_id_, date_created_, date_finished_,'||
'          identity_, oracle_user_, os_identity_, machine_, program_, ipaddress_, auth_type_, audit_id_,'||
'          ''FALSE'', '||
'          text1_, '||
'          relative_time_,'||
'          sysdate_);'||
'      :log_id_ := log_id_; '||
'   END IF; '||
'EXCEPTION'||
'   WHEN OTHERS THEN'||
'      :log_id_ := 0; '||
'END;';
BEGIN
   -- Must use Dynamic SQL since Installation_SYS must not be dependent on any other database object.
   -- Safe due to using bind variables and executed with Invokers rights
   @ApproveDynamicStatement(2006-06-01,haarse)
   EXECUTE IMMEDIATE stmt_ 
      USING IN category_, IN OUT audit_id_, IN relative_time_, IN what_, IN module_, IN type_, IN parent_log_id_, OUT log_id_;
   @ApproveTransactionStatement(2016-12-16,mabose)
   COMMIT;
   RETURN(log_id_);
EXCEPTION
   WHEN OTHERS THEN
      RETURN(0);
END Persistent_Logging___;


FUNCTION Is_Index_Aq_Index___ (
   index_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   exists_ NUMBER;
   CURSOR check_aq_index IS
      SELECT 1
      FROM user_queue_tables
      WHERE queue_table IN (SELECT table_name from user_ind_columns
                            WHERE index_name = index_name_);
BEGIN
   OPEN check_aq_index;
   FETCH check_aq_index INTO exists_;
   IF check_aq_index%FOUND THEN
      CLOSE check_aq_index;
      RETURN(TRUE);
   ELSE
      CLOSE check_aq_index;
      RETURN(FALSE);
   END IF;
END Is_Index_Aq_Index___;


PROCEDURE Rebuild_Index___ (
   procedure_name_   IN VARCHAR2,
   index_name_       IN VARCHAR2,
   show_info_        IN BOOLEAN  DEFAULT FALSE,
   table_name_       IN VARCHAR2 DEFAULT NULL)
IS
   stmt_          VARCHAR2(200) := 'ALTER INDEX "'||index_name_||'" REBUILD ';
   stmt2_         VARCHAR2(200) := stmt_;
   online_error   EXCEPTION;
   PRAGMA         EXCEPTION_INIT(online_error, -1450);
BEGIN
   IF Is_Index_Aq_Index___(index_name_) = FALSE
   AND Installation_SYS.Is_Option_Available('Online Index Build') THEN
         stmt_ := stmt_ || ' ONLINE ';
   END IF;
   IF Is_Table_Temporary___(NVL(table_name_, Get_Index_Table(index_name_))) = FALSE 
   AND Get_Index_Type(index_name_) IN ('NORMAL', 'FUNCTION-BASED NORMAL') THEN
      stmt_ := stmt_ || ' PARALLEL ';
   END IF;
   Run_Ddl_Command___(stmt_, procedure_name_, show_info_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___(procedure_name_ || ': Index ' || index_name_ || ' rebuilt.');
   END IF;
EXCEPTION
   WHEN online_error THEN
      Run_Ddl_Command___(stmt2_, procedure_name_, show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Index ' || index_name_ || ' rebuilt.');
      END IF;
END Rebuild_Index___;


PROCEDURE Remove_Constraints___ (
   procedure_name_  IN VARCHAR2,
   table_name_      IN VARCHAR2,
   constraint_name_ IN VARCHAR2 DEFAULT '%',
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
   objects_ ObjectArray;
   
   tab_   VARCHAR2(ORA_MAX_NAME_LEN) := UPPER(table_name_);
   cons_  VARCHAR2(ORA_MAX_NAME_LEN) := UPPER(constraint_name_);
   stmnt_ VARCHAR2(400);
   
   CURSOR get_cons IS
      SELECT constraint_name
      FROM  user_constraints
      WHERE constraint_name LIKE cons_
      AND   constraint_type IN ('P', 'R', 'U') -- Primary key, referential integrity and unique constraints
      AND   table_name = tab_;

BEGIN
   OPEN  get_cons;
   FETCH get_cons BULK COLLECT INTO objects_;
   CLOSE get_cons;
   FOR i IN Nvl(objects_.FIRST,0)..Nvl(objects_.LAST,-1) LOOP
      stmnt_ := 'ALTER TABLE ' || table_name_ || ' DROP CONSTRAINT ' || objects_(i).object_name || ' CASCADE DROP INDEX';
      Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Constraint ' || objects_(i).object_name || ' dropped with cascade.');
      END IF;
   END LOOP;
END Remove_Constraints___;


PROCEDURE Remove_Extended_Stats___ (
   table_name_ IN VARCHAR2,
   column_name_  IN VARCHAR2 )
IS
   app_owner_   VARCHAR2(30);
   CURSOR get_extended_stats IS 
      SELECT extension
      FROM user_stat_extensions
      WHERE table_name = table_name_
      AND INSTR(extension, '"' ||column_name_ ||  '"') > 0
      AND droppable = 'YES';
BEGIN
   BEGIN
      @ApproveDynamicStatement(2015-08-19,haarse)
      EXECUTE IMMEDIATE 'BEGIN :app_owner_ := Fnd_Session_API.Get_App_Owner; END;' USING OUT app_owner_;
   EXCEPTION
      WHEN OTHERS THEN
         app_owner_ := NULL;
   END;
   IF app_owner_ IS NOT NULL THEN
      FOR rec IN get_extended_stats LOOP 
         Dbms_Stats.Drop_Extended_Stats(app_owner_, table_name_, rec.extension);
      END LOOP;
   END IF;
END Remove_Extended_Stats___;
   

PROCEDURE Remove_Indexes___ (
   procedure_name_  IN VARCHAR2,
   table_name_ IN VARCHAR2,
   index_name_ IN VARCHAR2 DEFAULT '%',
   show_info_  IN BOOLEAN  DEFAULT FALSE )
IS
   objects_ IndexArray;
   
   tab_         VARCHAR2(ORA_MAX_NAME_LEN) := UPPER(table_name_);
   ind_         VARCHAR2(ORA_MAX_NAME_LEN) := UPPER(index_name_);
   stmnt_       VARCHAR2(400);
   queue_table_ BOOLEAN := FALSE;
   mw_table_    BOOLEAN := FALSE;
   temp_table_  BOOLEAN := FALSE;
   iot_table_   BOOLEAN := FALSE;
   
   CURSOR get_ind IS
      SELECT index_name, index_type
      FROM   user_indexes i
      WHERE  i.index_name LIKE ind_
      AND    i.table_name = tab_
      AND    i.index_type != 'LOB'
      AND NOT EXISTS (SELECT 1
                      FROM  user_constraints u
                      WHERE i.index_name = u.index_name
                      AND   u.table_name = tab_);
BEGIN
   OPEN  get_ind;
   FETCH get_ind BULK COLLECT INTO objects_;
   CLOSE get_ind;
   queue_table_ := Is_Table_Queue(tab_);
   mw_table_ := Is_Table_Mw(tab_);
   temp_table_ := Is_Table_Temporary(tab_);
   iot_table_ := Is_Table_Iot(tab_);
   FOR i IN Nvl(objects_.FIRST,0)..Nvl(objects_.LAST,-1) LOOP 
      IF queue_table_ OR mw_table_ OR temp_table_ OR iot_table_ OR objects_(i).index_type IN ('DOMAIN', 'CLUSTER') THEN
         stmnt_ := 'DROP INDEX ' || objects_(i).index_name;
      ELSE   
         stmnt_ := 'DROP INDEX ' || objects_(i).index_name ||' ONLINE';
      END IF;  
      Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Index ' ||  objects_(i).index_name || ' dropped.');
      END IF;
   END LOOP;
END Remove_Indexes___;


PROCEDURE Remove_Triggers___ (
   procedure_name_ IN VARCHAR2,
   table_name_     IN VARCHAR2,
   trigger_name_   IN VARCHAR2 DEFAULT '%',
   show_info_      IN BOOLEAN  DEFAULT FALSE )
IS
   objects_ ObjectArray;
   
   tab_   VARCHAR2(ORA_MAX_NAME_LEN) := UPPER(table_name_);
   trg_   VARCHAR2(ORA_MAX_NAME_LEN) := UPPER(trigger_name_);
   stmnt_ VARCHAR2(400);
   
   CURSOR get_triggers IS
      SELECT trigger_name
      FROM  user_triggers
      WHERE trigger_name LIKE trg_
      AND   table_name = tab_;

BEGIN
   OPEN  get_triggers;
   FETCH get_triggers BULK COLLECT INTO objects_;
   CLOSE get_triggers;
   FOR i IN Nvl(objects_.FIRST,0)..Nvl(objects_.LAST,-1) LOOP
      stmnt_ := 'DROP TRIGGER ' || objects_(i).object_name;
      Run_Ddl_Command___(stmnt_, procedure_name_, show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___(procedure_name_ || ': Trigger ' || objects_(i).object_name || ' dropped.');
      END IF;
   END LOOP;
END Remove_Triggers___;


PROCEDURE Run_Ddl_Command___ (
   stmt_      IN VARCHAR2,
   procedure_ IN VARCHAR2,
   show_info_ IN BOOLEAN DEFAULT FALSE,
   raise_     IN BOOLEAN DEFAULT TRUE,
   debug_     IN BOOLEAN DEFAULT FALSE )
IS
   security_error EXCEPTION;
BEGIN
--   IF user != Sys_Context('USERENV', 'CURRENT_SCHEMA') THEN 
--      RAISE security_error;
--   END IF;
   IF show_info_ THEN
      -- Not implemented!
      NULL;
   END IF;
   IF debug_ THEN
      dbms_output.put_line(stmt_);
   END IF;
   -- Safe due to not exposed in Package specification
   @ApproveDynamicStatement(2006-06-01,haarse)
   EXECUTE IMMEDIATE stmt_;
EXCEPTION
   WHEN security_error THEN 
         Raise_Application_Error(-20106, 'Installation_SYS: You are not allowed to use this method.');
   WHEN OTHERS THEN
      Show_Message___ (procedure_ || ' generates error when executing: ');
      Show_Message___ (stmt_);
      IF raise_ THEN
         RAISE;
      END IF;
END Run_Ddl_Command___;

   
FUNCTION Verify_User_Role___ (
   user_role_ VARCHAR2 ) RETURN BOOLEAN
IS
   exists_ NUMBER;
   CURSOR check_exist IS
      SELECT 1
      FROM dba_users
      WHERE username = user_role_
      UNION
      SELECT 1
      FROM dba_roles
      WHERE role = user_role_;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO exists_;
   IF check_exist%FOUND THEN
      CLOSE check_exist;
      RETURN TRUE;
   ELSE
      CLOSE check_exist;
      RETURN FALSE;
   END IF;
END Verify_User_Role___;


PROCEDURE Grant_Privileged_Grantee___ (
   grantee_   IN VARCHAR2,
   method_    IN VARCHAR2,
   show_info_ IN BOOLEAN  DEFAULT TRUE,
   special_   IN BOOLEAN  DEFAULT FALSE,
   packages_  IN BOOLEAN  DEFAULT FALSE,
   views_     IN BOOLEAN  DEFAULT FALSE,
   lobs_      IN BOOLEAN  DEFAULT FALSE,
   rep_views_ IN BOOLEAN  DEFAULT FALSE,
   ial_views_ IN BOOLEAN  DEFAULT FALSE,
   archive_objects_ IN BOOLEAN DEFAULT FALSE )
IS
   ial_owner_ VARCHAR2(30);
--
   CURSOR get_packages IS
      SELECT object_name
      FROM user_objects
      WHERE  object_type = 'PACKAGE'
      AND    (  object_name LIKE '%_API'
             OR object_name LIKE '%_SYS'
             OR object_name LIKE '%_RPI')
      MINUS
      SELECT table_name object_name
      FROM user_tab_privs_made
      WHERE privilege = 'EXECUTE'
      AND grantee = grantee_
      AND    (  table_name LIKE '%_API'
             OR table_name LIKE '%_SYS'
             OR table_name LIKE '%_RPI');
--
   CURSOR get_views IS
      SELECT object_name
      FROM user_objects
      WHERE  object_type = 'VIEW' AND object_name NOT LIKE 'AQ$%'
         MINUS
      SELECT table_name object_name
      FROM user_tab_privs_made
      WHERE privilege = 'SELECT'
      AND grantee = grantee_;
--
   CURSOR get_lobs IS
      SELECT c.table_name, c.column_name
      FROM user_tab_columns c, user_tables t
      WHERE c.table_name = t.table_name
      AND   c.data_type IN ('CLOB', 'BLOB')
      AND ((c.table_name NOT IN
           (SELECT table_name object_name
            FROM user_tab_privs_made t
            WHERE privilege IN ('SELECT')
            AND grantee = grantee_)) OR
            (c.table_name NOT IN
            (SELECT table_name object_name
            FROM user_col_privs_made t
            WHERE privilege IN ('UPDATE')
            AND grantee = grantee_
            AND column_name = c.column_name)));
--
   CURSOR get_report_views IS
      SELECT object_name FROM user_objects
      WHERE  object_type = 'VIEW'
      AND    substr(object_name, -4) = '_REP'
      MINUS
      SELECT table_name object_name
      FROM user_tab_privs_made
      WHERE privilege = 'SELECT'
      AND grantee = grantee_
      AND    substr(table_name, -4) = '_REP';
--
   CURSOR get_ial_views IS
      SELECT object_name
      FROM   all_objects
      WHERE  owner = ial_owner_
      AND    object_type = 'VIEW'
         MINUS
      SELECT table_name object_name
      FROM all_tab_privs_made
      WHERE privilege = 'SELECT'
      AND owner = ial_owner_
      AND grantee = grantee_;
--
   CURSOR get_archive_objects IS
      SELECT table_name
      FROM user_tables t
      WHERE table_name  LIKE '%\_ARC' ESCAPE '\';
--
   not_user_or_role   EXCEPTION;
   PRAGMA             EXCEPTION_INIT(not_user_or_role, -1917);
BEGIN
   -- Grant special grants needed by FNDEXT
   IF special_ THEN
      --
      -- Special system privilege needed by IFSSYS from Oracle10g R2 and forward.
      --
      Run_Ddl_Command___('GRANT MERGE ANY VIEW TO '||grantee_, method_, show_info_, FALSE);
      --
      -- Oracle view necessary to enable retaining of transactions upon unexpected stop of Application Server
      --
      Run_Ddl_Command___('GRANT SELECT ON SYS.PENDING_TRANS$ TO '||grantee_, method_, show_info_, FALSE);
      Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_2PC_PENDING TO '||grantee_, method_, show_info_, FALSE);
      Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_PENDING_TRANSACTIONS TO '||grantee_, method_, show_info_, FALSE);
      --Run_Ddl_Command___('GRANT EXECUTE ON SYS.DBMS_SYSTEM TO '||grantee_, method_, show_info_, FALSE);
      --
      -- Table necessary for the Print Agent
      --
      Run_Ddl_Command___('GRANT INSERT ON PDF_ARCHIVE_TAB TO '||grantee_, method_, show_info_, FALSE);
      --
      -- Table and Packages necessary for the Installer when setting up PL/SQ Access Provider
      --
      Run_Ddl_Command___('GRANT SELECT, INSERT, UPDATE ON PLSQLAP_ENVIRONMENT_TAB TO '||grantee_, method_, show_info_, FALSE);
      --
      -- View necessary for Select, Create New or Update Binary object data block from PL/SQ Access Provider
      --
      Run_Ddl_Command___('GRANT SELECT, INSERT, UPDATE, DELETE ON BINARY_OBJECT_DATA_BLOCK TO '||grantee_, method_, show_info_, FALSE);
      Run_Ddl_Command___('GRANT SELECT, INSERT, UPDATE, DELETE ON BINARY_OBJECT_DATA_BLOCK_TAB TO '||grantee_, method_, show_info_, FALSE);
      --
      -- Table grants necessary for inserting ApplicationMessageStat rows using JDBC batch processing
      --
      Run_Ddl_Command___('GRANT INSERT ON APPLICATION_MESSAGE_STAT_TAB TO '||grantee_, method_, show_info_, FALSE);
      --
      -- Grant necessary SYS views
      --
      Run_Ddl_Command___('GRANT SELECT ON SYS.V_$PROCESS TO ' || grantee_, method_, show_info_, FALSE);
      Run_Ddl_Command___('GRANT SELECT ON SYS.V_$SESSION TO ' || grantee_, method_, show_info_, FALSE);
      Run_Ddl_Command___('GRANT SELECT ON SYS.V_$PARAMETER TO ' || grantee_, method_, show_info_, FALSE);
      Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_JOBS TO ' || grantee_, method_, show_info_, FALSE);
   END IF;
   --
   IF packages_ THEN
      --
      -- Grant Packages
      --
      FOR rec_ IN get_packages LOOP
         Run_Ddl_Command___('GRANT EXECUTE ON '||rec_.object_name||' TO '||grantee_, method_, show_info_, FALSE);
         IF (grantee_ = 'IFSSYS') THEN 
            NULL;
         ELSE    
            Run_Ddl_Command___('BEGIN   INSERT INTO security_sys_privs_tab (grantee, table_name, privilege) VALUES ('''||grantee_||''', '''||rec_.object_name||''', ''EXECUTE'');  EXCEPTION   WHEN dup_val_on_index THEN   NULL;   END;', method_, show_info_, FALSE);
         END IF;   
      END LOOP;
   END IF;
   --
   IF views_ THEN
      --
      -- Grant Views
      --
      FOR rec_ IN get_views LOOP
         Run_Ddl_Command___('GRANT SELECT ON '||rec_.object_name||' TO '||grantee_, method_, show_info_, FALSE);
         IF (grantee_ = 'IFSSYS') THEN 
            NULL;
         ELSE    
            Run_Ddl_Command___('BEGIN   INSERT INTO security_sys_privs_tab (grantee, table_name, privilege) VALUES ('''||grantee_||''', '''||rec_.object_name||''', ''SELECT'');  EXCEPTION   WHEN dup_val_on_index THEN   NULL;   END;', method_, show_info_, FALSE);
         END IF;   
      END LOOP;
   END IF;
   --
   IF lobs_ THEN
      --
      -- Grant LOB's
      --
      FOR rec_ IN get_lobs LOOP
         Run_Ddl_Command___('GRANT SELECT ON '||rec_.table_name||' TO '||grantee_, method_, show_info_, FALSE);
         Run_Ddl_Command___('GRANT UPDATE ('||rec_.column_name||') ON '||rec_.table_name||' TO '||grantee_, method_, show_info_, FALSE);
      END LOOP;
   END IF;
   -- Report Views
   IF rep_views_ THEN
      --
      -- Grant Report views
      --
      FOR rec_ IN get_report_views LOOP
         Run_Ddl_Command___('GRANT SELECT ON '||rec_.object_name||' TO '||grantee_, method_, show_info_, FALSE);
         IF (grantee_ = 'IFSSYS') THEN 
            NULL;
         ELSE    
            Run_Ddl_Command___('BEGIN   INSERT INTO security_sys_privs_tab (grantee, table_name, privilege) VALUES ('''||grantee_||''', '''||rec_.object_name||''', ''SELECT'');  EXCEPTION   WHEN dup_val_on_index THEN   NULL;   END;', method_, show_info_, FALSE);
         END IF;   
      END LOOP;
   END IF;
   -- IAL Views
   IF ial_views_ THEN
      --
      -- Get IAL_OWNER
      --
      BEGIN
         @ApproveDynamicStatement(2009-08-19,nabalk)
         EXECUTE IMMEDIATE 'BEGIN :ial_owner_ := Fnd_Setting_API.Get_Value(''IAL_USER'', Installation_SYS.Get_Installation_Mode); END;' USING OUT ial_owner_;
      EXCEPTION
         WHEN OTHERS THEN
            ial_owner_ := NULL;
      END;
      --
      -- Grant IAL views
      --
      FOR rec_ IN get_ial_views LOOP
         Run_Ddl_Command___('GRANT SELECT ON '||ial_owner_||'.'||rec_.object_name||' TO '||grantee_, method_, show_info_, FALSE);
         IF (grantee_ = 'IFSSYS') THEN 
            NULL;
         ELSE    
            Run_Ddl_Command___('BEGIN   INSERT INTO security_sys_privs_tab (grantee, table_name, privilege) VALUES ('''||grantee_||''', '''||rec_.object_name||''', ''SELECT'');  EXCEPTION   WHEN dup_val_on_index THEN   NULL;   END;', method_, show_info_, FALSE);
         END IF;   
      END LOOP;
   END IF;
   -- Data archive objects
   IF archive_objects_ THEN
      --
      -- Grant Data Archive tables
      --
      FOR rec_ IN get_archive_objects LOOP
         Run_Ddl_Command___('GRANT SELECT ON '||rec_.table_name||' TO '||grantee_, method_, show_info_, FALSE);
      END LOOP;
   END IF;
EXCEPTION
   WHEN not_user_or_role THEN
      Dbms_Output.Put_Line(method_ || ': The grantee "'||grantee_||'" is not installed in this installation.');
END Grant_Privileged_Grantee___;


PROCEDURE Write_Lob___(
   file_handle_ IN Utl_File.File_Type,
   doc_          IN CLOB)
IS
   out_string_ VARCHAR2(32760);
   cloblen_    NUMBER;
   offset_     NUMBER := 1;
   amount_     NUMBER;
BEGIN
   cloblen_ := dbms_lob.getlength(doc_);
   WHILE cloblen_ > 0 LOOP
      IF cloblen_ > 32760 THEN
         amount_ := 32760;
      ELSE
         amount_ := cloblen_;
      END IF;
      out_string_ := dbms_lob.Substr(doc_, amount_, offset_);
      utl_file.put(file_handle_, out_string_);
      utl_file.fflush(file_handle_);
      offset_  := offset_ + amount_;
      cloblen_ := cloblen_ - amount_;
   END LOOP;
   utl_file.put_line(file_handle_, '');
END Write_Lob___;


PROCEDURE Show_Message___ (
   message_ IN VARCHAR2 )
IS
   temp_msg_         VARCHAR2(32000);
   space_position_   NUMBER;
BEGIN
   temp_msg_ := message_;
   WHILE (LENGTH(temp_msg_) > 255) LOOP
      space_position_ := INSTR(SUBSTR(temp_msg_,1,255), ' ', -1);
      IF space_position_ < 240 THEN
         space_position_ := 240;
      END IF;
      Dbms_Output.Put_Line(SUBSTR(temp_msg_,1,space_position_));
      temp_msg_ := SUBSTR(temp_msg_, space_position_+1); 
   END LOOP;
   IF temp_msg_ IS NOT NULL THEN
      Dbms_Output.Put_Line(temp_msg_);
   END IF;
END Show_Message___;


FUNCTION Show_Info___ (
   show_info_ IN BOOLEAN ) RETURN BOOLEAN
IS
BEGIN
   RETURN(show_info_ OR Installation_SYS.gc_show_info_);
END Show_Info___;


FUNCTION Is_Column_Modified___(table_name_ VARCHAR2,
                               column_rec_ IN OUT ColRec) RETURN BOOLEAN 
IS

   CURSOR get_column_info IS
      SELECT data_type, char_length, nullable, data_default, data_precision, data_scale, default_on_null, identity_column
      FROM   user_tab_columns
      WHERE  table_name = UPPER(table_name_)
      AND    column_name = UPPER(column_rec_.column_name);
   old_column_        get_column_info%ROWTYPE;
   column_datatype_   VARCHAR2(100);
   is_modified_       BOOLEAN := TRUE;
   is_dt_modified_    BOOLEAN := TRUE;
   FUNCTION Convert_Default_Value___ (
      value_        IN VARCHAR2,
      keep_default_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
      tmp_   VARCHAR2(32767) := TRIM(value_);
   BEGIN
      IF (keep_default_ = 'N') THEN
         RETURN 'NULL';
      ELSIF (tmp_ IS NULL) THEN
         RETURN 'NULL';
      ELSIF (UPPER(tmp_) = 'NULL') THEN
         RETURN 'NULL';
      ELSIF (UPPER(tmp_) = '$DEFAULT_NULL$') THEN
         RETURN 'NULL';
      ELSE
         RETURN tmp_;
      END IF;
   END Convert_Default_Value___;
BEGIN
   OPEN get_column_info;
   FETCH get_column_info INTO old_column_;
   CLOSE get_column_info;

   IF (column_rec_.nullable IS NOT NULL) THEN
      IF (old_column_.nullable != column_rec_.nullable) THEN
         RETURN(TRUE);
      END IF;
   END IF;
   IF (column_rec_.default_value IS NOT NULL) THEN
      IF (Convert_Default_Value___(old_column_.data_default, 'Y') != Convert_Default_Value___(column_rec_.default_value, column_rec_.keep_default)) THEN
         RETURN(TRUE);
      END IF;
   END IF;
   IF old_column_.data_type = 'VARCHAR2' THEN
      column_datatype_ := 'VARCHAR2(' || old_column_.char_length || ')';
      IF NOT column_datatype_ = column_rec_.data_type THEN
         RETURN(TRUE);
      END IF;
   ELSIF old_column_.data_type = 'NUMBER' THEN
      IF old_column_.identity_column = 'YES' THEN
         column_datatype_ := 'IDENTITY';
      ELSE
         column_datatype_ := 'NUMBER';
      END IF;
      IF old_column_.data_precision IS NOT NULL OR old_column_.data_scale IS NOT NULL THEN
         column_datatype_ := column_datatype_ ||'('||NVL(TO_CHAR(old_column_.data_precision) , '*');
         IF old_column_.data_scale != 0 THEN
            column_datatype_ := column_datatype_ ||','||old_column_.data_scale;
         END IF;
         column_datatype_ := column_datatype_ ||')';
      END IF;
      IF NOT column_datatype_ = column_rec_.data_type THEN
         RETURN(TRUE);
      END IF;
   ELSIF NOT old_column_.data_type = column_rec_.data_type THEN
      RETURN(TRUE);
   END IF;
   IF  old_column_.default_on_null = 'NO'
   AND Convert_Default_Value___(column_rec_.default_value, column_rec_.keep_default) != 'NULL' THEN
      RETURN(TRUE);
   END IF;   
   IF (is_dt_modified_) THEN
      column_rec_.data_type :=NULL;
   ELSE
      is_modified_ :=FALSE;  
   END IF;
   
   RETURN FALSE;
END Is_Column_Modified___;


PROCEDURE Create_Empty_View___ (
   view_name_    IN VARCHAR2,
   columns_      IN ColumnViewType,
   lu_           IN VARCHAR2 DEFAULT NULL,
   module_       IN VARCHAR2 DEFAULT NULL,
   server_only_  IN VARCHAR2 DEFAULT NULL,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_     VARCHAR2(32000);
BEGIN
   stmnt_ := 'CREATE OR REPLACE VIEW '||view_name_||' AS'||nl_||'SELECT ';
   FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
      stmnt_ := stmnt_ || columns_(i).column_source||' '||columns_(i).column_name;
      IF i < columns_.last THEN
         stmnt_ := stmnt_ ||','||nl_;
      ELSE
         stmnt_ := stmnt_ ||nl_;
      END IF;
   END LOOP;
   stmnt_ := stmnt_ ||'FROM dual'||nl_||'WHERE 1 = 2'||nl_||'WITH READ ONLY';
   Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
   IF lu_ IS NULL
   OR module_ IS NULL THEN
      stmnt_ := 'COMMENT ON TABLE '||view_name_||' IS ''MODULE=IGNORE^''';
   ELSE
      stmnt_ := 'COMMENT ON TABLE '||view_name_||' IS ''MODULE='||module_||'^LU='||lu_||'^';
      IF server_only_ IS NOT NULL THEN
         stmnt_ := stmnt_||'SERVER_ONLY='||server_only_||'^';
      END IF;
      stmnt_ := stmnt_||'''';
   END IF;
   Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
   FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
      IF columns_(i).column_comment IS NOT NULL THEN
         stmnt_ := 'COMMENT ON COLUMN '||view_name_||'.'||columns_(i).column_name||' IS '''||REPLACE(columns_(i).column_comment,'$TO_NULL$',NULL)||'''';
         Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
      END IF;
   END LOOP;
END Create_Empty_View___;


PROCEDURE Alter_View___ (
   view_name_    IN VARCHAR2,
   columns_      IN ColumnViewType,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
   i_                  NUMBER;
   changed_            BOOLEAN := FALSE;
   view_stmt_          LONG;
   org_stmt_           LONG;
   org_comment_        user_tab_comments.comments%TYPE;
   org_comments_       Installation_SYS.ColumnViewType;
   stmnt_              VARCHAR2(32000);
   CURSOR get_view IS
      SELECT text
      FROM user_views
      WHERE view_name = UPPER(view_name_);
   CURSOR get_view_comment IS
      SELECT comments
      FROM user_tab_comments
      WHERE table_name = UPPER(view_name_);
   CURSOR get_view_col_comments IS
      SELECT column_name, comments
      FROM user_col_comments
      WHERE table_name = UPPER(view_name_);
   FUNCTION View_Column_Exist (
      view_name_ IN VARCHAR2,
      col_name_  IN VARCHAR2 ) RETURN BOOLEAN
   IS
      exist_ NUMBER;
      CURSOR check_exist IS
         SELECT 1
         FROM user_tab_columns
         WHERE table_name = UPPER(view_name_)
         AND column_name = UPPER(col_name_);
   BEGIN
      OPEN check_exist;
      FETCH check_exist INTO exist_;
      IF check_exist%FOUND THEN
         CLOSE check_exist;
         RETURN TRUE;
      ELSE
         CLOSE check_exist;
         RETURN FALSE;
      END IF;
   END View_Column_Exist;
BEGIN
   OPEN get_view;
   FETCH get_view INTO view_stmt_;
   CLOSE get_view;
   org_stmt_ := view_stmt_;
   OPEN get_view_comment;
   FETCH get_view_comment INTO org_comment_;
   CLOSE get_view_comment;
   i_ := 1;
   FOR comm_rec IN get_view_col_comments LOOP
      org_comments_(i_).column_name := comm_rec.column_name;
      org_comments_(i_).column_comment := comm_rec.comments;
      i_ := i_ + 1;
   END LOOP;
   FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
      IF NOT View_Column_Exist(view_name_, columns_(i).column_name) THEN
         changed_ := TRUE;
         view_stmt_ := SUBSTR(view_stmt_, 1, INSTR(view_stmt_, 'SELECT')+6)||columns_(i).column_source||' '||columns_(i).column_name||','||nl_||SUBSTR(view_stmt_, INSTR(view_stmt_, 'SELECT')+7, LENGTH(view_stmt_));
      END IF;
   END LOOP;
   IF changed_ THEN
      BEGIN
         view_stmt_ := 'CREATE OR REPLACE VIEW '||view_name_||' AS'||nl_||view_stmt_;
         Run_Ddl_Command___ (view_stmt_, 'Create_View', show_info_);
         stmnt_ := 'COMMENT ON TABLE '||view_name_||' IS '''||org_comment_||'''';
         Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
         FOR i IN Nvl(org_comments_.first, 0)..Nvl(org_comments_.last, 0) LOOP
            IF org_comments_(i).column_comment IS NOT NULL THEN
               stmnt_ := 'COMMENT ON COLUMN '||view_name_||'.'||org_comments_(i).column_name||' IS '''||org_comments_(i).column_comment||'''';
               BEGIN
                   Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
               EXCEPTION
                   WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
         END LOOP;
         FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
            IF columns_(i).column_comment IS NOT NULL THEN
               stmnt_ := 'COMMENT ON COLUMN '||view_name_||'.'||columns_(i).column_name||' IS '''||REPLACE(columns_(i).column_comment,'$TO_NULL$',NULL)||'''';
               BEGIN
                  Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
               EXCEPTION
                   WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
         END LOOP;
      EXCEPTION
         WHEN OTHERS THEN
            Dbms_Output.Put_Line('');
            Dbms_Output.Put_Line('Error when recreating view '||view_name_||'. Reverting to original view');
            Dbms_Output.Put_Line('');
            BEGIN
               view_stmt_ := 'CREATE OR REPLACE VIEW '||view_name_||' AS'||nl_||org_stmt_;
               Run_Ddl_Command___ (view_stmt_, 'Create_View', show_info_);
               stmnt_ := 'COMMENT ON TABLE '||view_name_||' IS '''||org_comment_||'''';
               Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
               FOR i IN Nvl(org_comments_.first, 0)..Nvl(org_comments_.last, 0) LOOP
                  IF org_comments_(i).column_comment IS NOT NULL THEN
                     stmnt_ := 'COMMENT ON COLUMN '||view_name_||'.'||org_comments_(i).column_name||' IS '''||org_comments_(i).column_comment||'''';
                     BEGIN
                        Run_Ddl_Command___ (stmnt_, 'Create_View', show_info_);
                     EXCEPTION
                        WHEN OTHERS THEN
                           NULL;
                     END;
                  END IF;
               END LOOP;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
      END;
   END IF;
END Alter_View___;


PROCEDURE Remove_Context___ (
   procedure_name_  IN VARCHAR2,
   context_name_    IN VARCHAR2,
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_ VARCHAR2(2000);
BEGIN
   stmnt_ := 'DROP CONTEXT ' || context_name_;
   Run_Ddl_Command___(stmnt_, procedure_name_, show_info_, FALSE);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___(procedure_name_ || ': Context ' || context_name_ || ' dropped.');
   END IF;
END Remove_Context___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Change_Index_Buffer_Pool__ (
   index_name_  IN VARCHAR2,
   buffer_pool_ IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
BEGIN
   IF Index_Exist(index_name_) THEN
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'ALTER INDEX "'||index_name_||'" STORAGE ( BUFFER_POOL '||buffer_pool_||')';
   ELSE
      Show_Message___('Change_Index_Buffer_Pool__: Index (' || index_name_ || ') does not exists.');
   END IF;
END Change_Index_Buffer_Pool__;


PROCEDURE Change_Table_Buffer_Pool__ (
   table_name_  IN VARCHAR2,
   buffer_pool_ IN VARCHAR2 DEFAULT 'DEFAULT' )
IS
BEGIN
   IF Table_Exist(table_name_) THEN
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'ALTER TABLE "'||table_name_||'" STORAGE ( BUFFER_POOL '||buffer_pool_||')';
   ELSE
      Show_Message___('Change_Table_Buffer_Pool__: Table (' || table_name_ || ') does not exists.');
   END IF;
END Change_Table_Buffer_Pool__;


PROCEDURE Coalesce_Index__ (
   index_name_ IN  VARCHAR2 )
IS
BEGIN
   IF Index_Exist(index_name_) THEN
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE 'ALTER INDEX "'||index_name_||'" COALESCE ';
   ELSE
      Show_Message___('Coalesce_Index__: Index (' || index_name_ || ') does not exists.');
   END IF;
END Coalesce_Index__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Set_Po_Snapshot_
IS
   stmt_ VARCHAR2(1000);
BEGIN
   IF Table_Exist('PRES_OBJECT_TAB')
   AND Table_Exist('PRES_OBJECT_SECURITY_TAB') THEN
      stmt_ := 'INSERT INTO pres_object_snap_tab (po_id, pres_object_type, module)';
      stmt_ := stmt_ || '                  SELECT po_id, pres_object_type, module FROM pres_object_tab';
      @ApproveDynamicStatement(2015-08-19,mabose)
      EXECUTE IMMEDIATE stmt_;
      stmt_ := 'INSERT INTO pres_object_security_snap_tab (po_id, sec_object, sec_object_type)';
      stmt_ := stmt_ || '                           SELECT po_id, sec_object, sec_object_type FROM pres_object_security_tab a';
      stmt_ := stmt_ || '                           WHERE  EXISTS';
      stmt_ := stmt_ || '                           (SELECT 1 FROM   user_objects';
      stmt_ := stmt_ || '                            WHERE  object_name = decode(a.sec_object_type, ''METHOD'', SUBSTR(a.sec_object, 1, INSTR(a.sec_object,''.'')-1), a.sec_object)';
      stmt_ := stmt_ || '                            AND    object_type IN (''PACKAGE'', ''VIEW''))';
      @ApproveDynamicStatement(2015-08-19,mabose)
      EXECUTE IMMEDIATE stmt_;
   END IF;
END Set_Po_Snapshot_;

PROCEDURE Set_Projection_Snapshot_
IS
   stmt_ VARCHAR2(32767);
BEGIN
   IF (Installation_SYS.Table_Exist('FND_PROJECTION_TAB') AND Installation_SYS.Table_Exist('FND_PROJECTION_SNAP_TAB')) THEN
      stmt_ := 'INSERT INTO fnd_projection_snap_tab (projection_name, component, description)' || CHR(10) ||
               'SELECT projection_name, component, description FROM fnd_projection_tab';
      BEGIN               
         @ApproveDynamicStatement(2019-11-18,sratlk)
         EXECUTE IMMEDIATE stmt_;
      EXCEPTION
         WHEN others THEN
            DBMS_Output.Put_Line('Error when loading projection snapshot. The projection report might not show correct values.');
            DBMS_Output.Put_Line('ERROR: '||SQLERRM);
      END;
   END IF;
   
   IF (Installation_SYS.Table_Exist('FND_PROJ_ACTION_TAB') AND Installation_SYS.Table_Exist('FND_PROJ_ACTION_SNAP_TAB')) THEN
      stmt_ := 'INSERT INTO fnd_proj_action_snap_tab (projection_name, action_name)' || CHR(10) ||
               'SELECT projection_name, action_name FROM fnd_proj_action_tab';
      BEGIN               
         @ApproveDynamicStatement(2019-11-18,sratlk)
         EXECUTE IMMEDIATE stmt_;
      EXCEPTION
         WHEN others THEN
            DBMS_Output.Put_Line('Error when loading projection action snapshot. The projection report might not show correct values.');
            DBMS_Output.Put_Line('ERROR: '||SQLERRM);
      END;
   END IF;
   
   IF (Installation_SYS.Table_Exist('FND_PROJ_ENTITY_TAB') AND Installation_SYS.Table_Exist('FND_PROJ_ENTITY_SNAP_TAB')) THEN
      stmt_ := 'INSERT INTO fnd_proj_entity_snap_tab (projection_name, entity_name, operations_allowed)' || CHR(10) ||
               'SELECT projection_name, entity_name, ' || CASE WHEN Installation_SYS.Column_Exist('FND_PROJ_ENTITY_TAB', 'OPERATIONS_ALLOWED') THEN 'operations_allowed' ELSE 'NULL' END || ' FROM fnd_proj_entity_tab'; 
      BEGIN               
         @ApproveDynamicStatement(2019-11-18,sratlk)
         EXECUTE IMMEDIATE stmt_;
      EXCEPTION
         WHEN others THEN
            DBMS_Output.Put_Line('Error when loading projection entity snapshot. The projection report might not show correct values.');
            DBMS_Output.Put_Line('ERROR: '||SQLERRM);
      END;
   END IF;
   
   IF (Installation_SYS.Table_Exist('FND_PROJ_ENT_ACTION_TAB') AND Installation_SYS.Table_Exist('FND_PROJ_ENT_ACTION_SNAP_TAB')) THEN
      stmt_ := 'INSERT INTO fnd_proj_ent_action_snap_tab (projection_name, entity_name, action_name)' || CHR(10) ||
               'SELECT projection_name, entity_name, action_name FROM fnd_proj_ent_action_tab';
      BEGIN               
         @ApproveDynamicStatement(2019-11-18,sratlk)
         EXECUTE IMMEDIATE stmt_;
      EXCEPTION
         WHEN others THEN
            DBMS_Output.Put_Line('Error when loading projection entity action snapshot. The projection report might not show correct values.');
            DBMS_Output.Put_Line('ERROR: '||SQLERRM);
      END;
   END IF;
END Set_Projection_Snapshot_;

PROCEDURE Set_User_Objects_Snapshot_
IS
   stmt_ VARCHAR2(1000);
BEGIN
   IF Table_Exist('USER_OBJECTS_SNAPSHOT_TAB') THEN
      stmt_ := 'INSERT INTO user_objects_snapshot_tab (owner, object_name, object_type, created, last_ddl_time, timestamp, log_time)';
      stmt_ := stmt_ || '                       SELECT owner, object_name, object_type, created, last_ddl_time, timestamp, sysdate';
      stmt_ := stmt_ || '                       FROM all_objects uo';
      stmt_ := stmt_ || '                       WHERE status = ''INVALID''';
      stmt_ := stmt_ || '                       AND owner IN (UPPER(''&APPLICATION_OWNER''),UPPER(''&IAL_OWNER''))';
      stmt_ := stmt_ || '                       AND (object_type = ''MATERIALIZED VIEW''';
      stmt_ := stmt_ || '                       OR EXISTS';
      stmt_ := stmt_ || '                       (SELECT 1';
      stmt_ := stmt_ || '                        FROM all_errors ue';
      stmt_ := stmt_ || '                        WHERE ue.name=uo.object_name';
      stmt_ := stmt_ || '                        AND ue.owner=uo.owner';
      stmt_ := stmt_ || '                        AND ue.type=uo.object_type))';
      @ApproveDynamicStatement(2016-12-30,mabose)
      EXECUTE IMMEDIATE stmt_;
   END IF;
END Set_User_Objects_Snapshot_;

PROCEDURE Alter_Loaded_Rowkeys_
IS
   stmt_ VARCHAR2(32000) := '
   DECLARE
      column_  Installation_SYS.Colrec;
      CURSOR get_tabs IS
         SELECT table_name
         FROM database_rowkey_update_tab
         WHERE state = ''Loaded'';
   BEGIN
      FOR row_ IN get_tabs LOOP
         BEGIN
            column_ := Installation_SYS.Set_Column_Values(''ROWKEY'', ''VARCHAR2(50)'', ''N'', ''sys_guid()'', NULL, ''D'');
            Installation_SYS.Alter_Table_Column(row_.table_name, ''MODIFY'', column_);
            UPDATE database_rowkey_update_tab SET time_stamp = SYSDATE, state = ''Finished'' WHERE table_name = row_.table_name;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
   END;';
BEGIN
   @ApproveDynamicStatement(2017-11-14,mabose)
   EXECUTE IMMEDIATE stmt_;
END Alter_Loaded_Rowkeys_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
PROCEDURE Add_Lob_Column (
   table_name_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
   stmt_       VARCHAR2(4000);
   lob_column_ Installation_SYS.ColRec := column_;
BEGIN
   IF (NOT Column_Exist(table_name_, column_.column_name)) THEN
      IF (lob_column_.data_type NOT IN ('CLOB', 'BLOB')) THEN
         Show_Message___('Add_Lob_Column error: This method can only be used for BLOB or CLOB columns.');
         RETURN;
      END IF;
      lob_column_.nullable := 'Y'; -- First set the column to NULLABLE
      stmt_ := 'ALTER TABLE ' || table_name_ || ' ADD ' || lob_column_.column_name || ' ' || lob_column_.data_type;
      IF NOT Is_Table_Temporary___(table_name_) THEN
         IF (Upper(lob_column_.lob_parameter) LIKE Upper('%LOB%(%' || lob_column_.column_name || '%)%')) THEN -- Check if column name is supplied as lob parameter
            NULL;
         ELSE
            stmt_ := stmt_ || ' LOB (' || lob_column_.column_name || ') ';
         END IF;
         stmt_ := stmt_ || ' ' || Replace(Upper(lob_column_.lob_parameter), 'DISABLE STORAGE IN ROW', 'ENABLE STORAGE IN ROW');
         -- Look for STORE AS and replace it with STORE AS SECUREFILE if SECUREFILE is missing
         stmt_ := Regexp_Replace(upper(stmt_), 'STORE +AS *\(', 'STORE AS SECUREFILE (');
      END IF;
      Run_Ddl_Command___ (stmt_, 'Add_Lob_Column', show_info_, TRUE);
      IF column_.nullable = 'N' THEN
         stmt_ := 'UPDATE '||table_name_||' SET '||lob_column_.column_name||'='||
                  CASE lob_column_.data_type
                  WHEN 'CLOB' THEN
                     'empty_clob() '
                  WHEN 'BLOB' THEN
                     'empty_blob() '
                  END
                  ||' WHERE '||lob_column_.column_name||' IS NULL';
         IF (Show_Info___(show_info_) = TRUE) THEN
            Show_Message___('Add_Lob_Column: Updated Lob column to empty Lob.');
         END IF;
         Run_Ddl_Command___ (stmt_, 'Add_Lob_Column', show_info_, TRUE);
         lob_column_.nullable      := 'N'; -- Set column to NOT NULLABLE
         lob_column_.lob_parameter := NULL;
         lob_column_.data_type := NULL;
         Alter_Table_Column___('Add_Lob_Column', table_name_, 'MODIFY', lob_column_, show_info_);
      END IF;
   ELSE
      Show_Message___('Add_Lob_Column: Column ' || column_.column_name || ' already exist in table ' || table_name_||'.');
      RETURN;
   END IF;
END Add_Lob_Column;


@UncheckedAccess
PROCEDURE Alter_Lob_Column (
   table_name_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
   stmt_       VARCHAR2(4000);
   lob_column_ Installation_SYS.ColRec := column_;
BEGIN
   IF (Column_Exist(table_name_, column_.column_name)) THEN
      IF (column_.data_type NOT IN ('CLOB', 'BLOB')) THEN
         Show_Message___('Alter_Lob_Column error: This method can only be used for BLOB or CLOB columns.');
         RETURN;
      END IF;
      IF Is_Table_Temporary___(table_name_) THEN
         Show_Message___('Alter_Lob_Column error: Lob columns in temporary tables should not be modified. Drop and recreate the table instead.');
         RETURN;
      END IF;
      IF (column_.lob_parameter IS NOT NULL) THEN
         stmt_ := 'ALTER TABLE ' || table_name_ || ' MODIFY LOB (' || column_.column_name || ') ' || column_.lob_parameter;
         -- Look for STORE AS and replace it with STORE AS SECUREFILE if SECUREFILE is missing
         stmt_ := Regexp_Replace(upper(stmt_), 'STORE +AS *\(', 'STORE AS SECUREFILE (');
         Run_Ddl_Command___(stmt_, 'Alter_Lob_Column', show_info_);
         Show_Message___('Alter_Lob_Column' || ': Lob parameters of Column ' || column_.column_name || ' in table ' || table_name_||' are modified.'); 
      END IF;
      lob_column_.lob_parameter := NULL;
      lob_column_.data_type := NULL;
      Alter_Table_Column___('Alter_Lob_Column', table_name_, 'MODIFY', lob_column_, show_info_); 
   ELSE
      Show_Message___('Alter_Lob_Column error: Column ' || column_.column_name || ' does not exist in table ' || table_name_||'.');
      RETURN;
   END IF;
END Alter_Lob_Column;


@UncheckedAccess
PROCEDURE Alter_Lob_To_Securefile (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   nologging_   IN BOOLEAN DEFAULT FALSE,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
   stmt_                 VARCHAR2(32000);
   postfix_     CONSTANT VARCHAR2(2) := '$$';
   tablespace_name_      VARCHAR2(ORA_MAX_NAME_LEN);
   
   CURSOR get_tablespace IS
      SELECT tablespace_name 
      FROM user_lobs
      WHERE table_name = table_name_
      AND column_name = column_name_;

   text_index EXCEPTION;
   PRAGMA exception_init(text_index, -29884);
   
BEGIN
   IF (Get_Column_Type(table_name_, column_name_) NOT IN ('CLOB', 'BLOB')) THEN
      Show_Message___('Alter_Lob_To_Securefile error: This method can only be used for BLOB or CLOB columns.');
      RETURN;
   END IF;
   IF Is_Table_Temporary___(table_name_) THEN
      Show_Message___('Alter_Lob_To_Securefile error: Lob columns in temporary tables should not be modified. Drop and recreate the table instead.');
      RETURN;
   END IF;
   -- Fetch tablespace name
   OPEN  get_tablespace;
   FETCH get_tablespace INTO tablespace_name_;
   CLOSE get_tablespace;
   -- Set table in nologging mode
   IF (nologging_) THEN 
      stmt_ := 'ALTER TABLE ' || table_name_ || ' NOLOGGING';
      Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
   END IF;
   -- Add lob columns as (deduplicated) securefile lob
   stmt_ := 'ALTER TABLE ' || table_name_ || ' ADD ' || column_name_ ||
            postfix_ || ' ' || Get_Column_Type(table_name_, column_name_) || ' LOB (' || column_name_ ||
            postfix_ ||
            ') STORE AS SECUREFILE (TABLESPACE ' || tablespace_name_ || ' PCTVERSION 10 CHUNK 4096  NOCACHE ENABLE STORAGE IN ROW)';
   Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
   
/* 
   If we want to use deduplicate
   stmt_ := 'ALTER TABLE ' || table_name_ || ' MODIFY LOB(' ||
            column_name_ || postfix_ || ') (DEDUPLICATE)';
   Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
*/ 

   stmt_ := 'UPDATE ' || table_name_ || ' SET ' || column_name_ ||
            postfix_ || ' = ' || column_name_;
   Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
   
   IF (Get_Column_Nullable(table_name_, column_name_) = 'N') THEN
      stmt_ := 'ALTER TABLE ' || table_name_ || ' MODIFY ' || column_name_ || postfix_ || ' NOT NULL';
      Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
   END IF;
   
   -- Drop basicfile lob columns
   stmt_ := 'ALTER TABLE ' || table_name_ || ' DROP COLUMN ' ||
            column_name_;
   Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
   
   -- Rename securefile columns to original names
   stmt_ := 'ALTER TABLE ' || table_name_ || ' RENAME COLUMN ' ||
            column_name_ || postfix_ || ' TO ' || column_name_;
            
   -- Statement if only using alter table move
   --stmt_ := 'ALTER TABLE ' || table_name_ ||' MOVE LOB (' || column_name_ || ') STORE AS SECUREFILE (TABLESPACE IFSAPP_LOB ENABLE STORAGE IN ROW)';

   Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
   -- Set table in logging mode
   IF (nologging_) THEN 
      stmt_ := 'ALTER TABLE ' || table_name_ || ' LOGGING';
      Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
   END IF;
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Alter_Lob_To_Securefile: LOB column '||column_name_||' in table '||table_name_||' is converted into securefile.');
   END IF;
EXCEPTION
   WHEN text_index THEN 
      Show_Message___ ('Alter_Lob_To_Securefile: Cannot convert a LOB column to securefile if it is used by an Oracle Text Index.');
      Show_Message___ (stmt_);
      -- Remove already created lob columns
      stmt_ := 'ALTER TABLE ' || table_name_ || ' DROP COLUMN ' || column_name_ || postfix_;
      Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
      -- Set table in logging mode
      IF (nologging_) THEN 
         stmt_ := 'ALTER TABLE ' || table_name_ || ' LOGGING';
         Run_Ddl_Command___(stmt_, 'Alter_Lob_To_Securefile', show_info_);
      END IF;
END Alter_Lob_To_Securefile;


@UncheckedAccess
PROCEDURE Alter_Long_Column_To_Lob (
   table_name_       IN VARCHAR2,
   column_name_      IN VARCHAR2,
   tablespace_       IN VARCHAR2,
   logging_          IN BOOLEAN DEFAULT TRUE,
   show_info_        IN BOOLEAN DEFAULT FALSE ) 
IS
   stmt_          VARCHAR2(4000);
   data_type_     VARCHAR2(ORA_MAX_NAME_LEN);
   new_data_type_ VARCHAR2(ORA_MAX_NAME_LEN);
   CURSOR get_col_info IS
      SELECT data_type
      FROM   user_tab_columns
      WHERE  table_name = table_name_
      AND    column_name = column_name_;
   PROCEDURE Rebuild_Unusable_Indexes___ (
      table_name_ IN VARCHAR2,
      show_info_  IN BOOLEAN DEFAULT TRUE )
   IS
      CURSOR get_index IS
         SELECT index_name
         FROM user_indexes
         WHERE table_name = table_name_
         AND status = 'UNUSABLE';
   BEGIN
      FOR rec IN get_index LOOP
         Rebuild_Index___('Alter_Long_Column_To_Lob', rec.index_name, show_info_, table_name_);
      END LOOP;
   END Rebuild_Unusable_Indexes___;
BEGIN
   -- Check data types
   FOR rec IN get_col_info LOOP
      data_type_ := rec.data_type;
      IF data_type_ = 'LONG' THEN
         new_data_type_ := 'CLOB';
      ELSIF data_type_ = 'LONG RAW' THEN
         new_data_type_ := 'BLOB';
      ELSE
         IF (data_type_ IN ('CLOB', 'BLOB')) THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___('Alter_Long_Column_To_Lob: Column '||column_name_||' is already a '||data_type_||' column.');
            END IF;    
         ELSE
            Show_Message___('Alter_Long_Column_To_Lob error: This method can only be used for LONG or LONG RAW columns.');
         END IF;
         RETURN;
      END IF;
   END LOOP;
   IF Is_Table_Temporary___(table_name_) THEN
      Show_Message___('Alter_Long_Column_To_Lob error: Lob columns in temporary tables should not be modified. Drop and recreate the table instead.');
      RETURN;
   END IF;
   -- Disable logging for table if indicated
   IF (logging_ = FALSE) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Alter_Long_Column_To_Lob: Altered table '||table_name_||' to NOLOGGING.');
      END IF;
      stmt_ := 'ALTER TABLE '||table_name_||' NOLOGGING';
      Run_Ddl_Command___ (stmt_, 'Alter_Long_Column_To_Lob', show_info_, TRUE);
   END IF;
   -- Do different things depending on logging is enabled or not
   stmt_ := 'ALTER TABLE '||table_name_||' MODIFY ('||column_name_||' '||new_data_type_||') LOB ('||column_name_||') STORE AS SECUREFILE (TABLESPACE '||tablespace_||' CHUNK 4096 NOCACHE';
   IF (logging_ = FALSE) THEN
      stmt_ := stmt_ || ' NOLOGGING';
   END IF;
   stmt_ := stmt_ || ' ENABLE STORAGE IN ROW)';
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Alter_Long_Column_To_Lob: Altered column '||column_name_||' to '||new_data_type_||' in table '||table_name_||'.');
   END IF;
   Run_Ddl_Command___ (stmt_, 'Alter_Long_Column_To_Lob', show_info_, TRUE);
   -- Modify column if logging is disabled
   IF (logging_ = FALSE) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Alter_Long_Column_To_Lob: Set LOB column to CACHE.');
      END IF;
      stmt_ := 'ALTER TABLE '||table_name_||' MODIFY LOB ('||column_name_||') (CACHE)';
      Run_Ddl_Command___ (stmt_, 'Alter_Long_Column_To_Lob', show_info_, TRUE);
      stmt_ := 'ALTER TABLE '||table_name_||' MODIFY LOB ('||column_name_||') (NOCACHE)';
      Run_Ddl_Command___ (stmt_, 'Alter_Long_Column_To_Lob', show_info_, TRUE);
   END IF;
   -- Enable logging if it was disabled
   IF (logging_ = FALSE) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Alter_Long_Column_To_Lob: Altered table '||table_name_||' to LOGGING.');
      END IF;
      stmt_ := 'ALTER TABLE '||table_name_||' LOGGING';
      Run_Ddl_Command___ (stmt_, 'Alter_Long_Column_To_Lob', show_info_, TRUE);
   END IF;
   Rebuild_Unusable_Indexes___(table_name_, show_info_);
END Alter_Long_Column_To_Lob;


@UncheckedAccess
PROCEDURE Alter_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN DEFAULT FALSE )
IS
   column_           Installation_SYS.ColRec;
   alter_type_       VARCHAR2(10);
BEGIN
   FOR i IN columns_.FIRST..columns_.LAST LOOP
      column_ := columns_(i);
      IF (Installation_SYS.Column_Exist(table_name_, column_.column_name)) THEN
         alter_type_ := 'MODIFY';
      ELSE
         alter_type_ := 'ADD';
      END IF;
      Alter_Table_Column___('Alter_Table', table_name_, alter_type_, column_, show_info_);
   END LOOP;
END Alter_Table;


@UncheckedAccess
PROCEDURE Alter_Table_Column (
   table_name_  IN VARCHAR2,
   alter_type_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (column_.data_type IN ('CLOB', 'BLOB')) THEN
      Show_Message___('Alter_Table_Column error: This method cannot be used for BLOB or CLOB columns.');
      RETURN;
   END IF;
   Alter_Table_Column___('Alter_Table_Column', table_name_, alter_type_, column_, show_info_);
END Alter_Table_Column;


@UncheckedAccess
PROCEDURE Alter_Table_Rowmovement (
   table_name_  IN VARCHAR2,
   enable_      IN BOOLEAN,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
   stmnt_   VARCHAR2(1000);
   text_    VARCHAR2(10);
BEGIN
   IF enable_ THEN
      text_ := 'ENABLE';
   ELSE
      text_ := 'DISABLE';
   END IF;
   stmnt_ := 'ALTER TABLE ' || table_name_ || ' ' || text_ || ' ROW MOVEMENT';
   Run_Ddl_Command___(stmnt_, 'Alter_Table_Rowmovement', show_info_);
END Alter_Table_Rowmovement;

@UncheckedAccess
FUNCTION Column_Exist (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_column IS
      SELECT   1
      FROM     user_tab_columns
      WHERE    table_name  = UPPER(table_name_)
      AND      column_name = UPPER(column_name_);
BEGIN
   OPEN  check_column;
   FETCH check_column INTO dummy_;
   IF (check_column%FOUND) THEN
      CLOSE check_column;
      RETURN TRUE;
   ELSE
      CLOSE check_column;
      RETURN FALSE;
   END IF;
END Column_Exist;

@UncheckedAccess
FUNCTION Column_Active (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_  NUMBER := 0;
   stmt_   VARCHAR2(2000) := 'SELECT 1
                              FROM dictionary_sys_tab_columns v, module_tab m, dictionary_sys_Tab d
                              WHERE v.table_name = UPPER('''||table_name_||''')'||
                              'AND v.column_name = UPPER('''||column_name_||''')'||
                              'AND d.module = m.module
                              AND v.table_name = d.table_name
                              AND m.active = ''TRUE''
                              UNION
                              SELECT 2
                              FROM user_tab_columns u
                              WHERE u.table_name = UPPER('''||table_name_||''')'||
                              'AND u.column_name = UPPER('''||column_name_||''')'||
                              'AND NOT EXISTS 
                                 (SELECT 1
                                  FROM dictionary_sys_tab_columns d
                                  WHERE d.table_name = u.table_name
                                  AND d.column_name = u.column_name)';   
BEGIN
   @ApproveDynamicStatement(2020-09-11,chahlk)
   EXECUTE IMMEDIATE stmt_ INTO dummy_;
   IF dummy_ > 0 THEN
      RETURN TRUE;
   END IF;  
   RETURN FALSE;
EXCEPTION
   WHEN too_many_rows THEN
      RETURN TRUE; 
   WHEN no_data_found THEN
      RETURN FALSE;      
   WHEN OTHERS THEN        
      DBMS_Output.Put_Line('Error fetching records: '||SQLERRM);
      RETURN FALSE;
END Column_Active;


@UncheckedAccess
FUNCTION Constraint_Exist (
   constraint_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_constraint IS
      SELECT  1
      FROM    user_constraints
      WHERE   constraint_name = UPPER(constraint_name_);
BEGIN
   OPEN  check_constraint;
   FETCH check_constraint INTO dummy_;
   IF (check_constraint%FOUND) THEN
      CLOSE check_constraint;
      RETURN TRUE;
   ELSE
      CLOSE check_constraint;
      RETURN FALSE;
   END IF;
END Constraint_Exist;

@UncheckedAccess
FUNCTION Constraint_Active (
   constraint_name_  IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   stmt_   VARCHAR2(2000) := 'SELECT 1
                              FROM dictionary_sys_constraints v, module_tab m, dictionary_sys_Tab d
                              WHERE v.constraint_name = UPPER('''||constraint_name_||''')'||
                              'AND d.module = m.module
                              AND v.table_name = d.table_name
                              AND m.active = ''TRUE''
                              UNION
                              SELECT 2
                              FROM user_constraints u
                              WHERE u.constraint_name = UPPER('''||constraint_name_||''')'||
                              'AND NOT EXISTS 
                                 (SELECT 1
                                  FROM dictionary_sys_constraints d
                                  WHERE d.table_name = u.table_name
                                  AND d.constraint_name = u.constraint_name)';     
BEGIN
   @ApproveDynamicStatement(2020-09-11,chahlk)
   EXECUTE IMMEDIATE stmt_ INTO dummy_;
   IF dummy_ > 0 THEN
      RETURN TRUE;
   END IF;  
   RETURN FALSE;
EXCEPTION
   WHEN too_many_rows THEN
      RETURN TRUE; 
   WHEN no_data_found THEN
      RETURN FALSE;          
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('Error fetching records: '||SQLERRM);
      RETURN FALSE;      
END Constraint_Active;



@UncheckedAccess
FUNCTION Context_Exist (
   context_name_  IN VARCHAR2,
   schema_        IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_context IS
      SELECT  1
      FROM    dba_context 
      WHERE   schema = schema_
      AND     namespace = UPPER(context_name_);
BEGIN
   OPEN  check_context;
   FETCH check_context INTO dummy_;
   IF (check_context%FOUND) THEN
      CLOSE check_context;
      RETURN TRUE;
   ELSE
      CLOSE check_context;
      RETURN FALSE;
   END IF;
END Context_Exist;


@UncheckedAccess
PROCEDURE Create_And_Set_Version (
   module_      IN VARCHAR2,
   name_        IN VARCHAR2,
   version_     IN VARCHAR2,
   description_ IN VARCHAR2,
   patch_version_ IN VARCHAR2 DEFAULT NULL )
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   Module_API.Create_And_Set_Version(:module, :name, :version, :description, :patch_version);
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2006-12-27,haarse)
   EXECUTE IMMEDIATE stmt_ USING module_, name_, version_, description_, patch_version_;
END Create_And_Set_Version;


@UncheckedAccess
PROCEDURE Create_Component_Package (
   installed_      IN BOOLEAN DEFAULT FALSE,
   component_      IN VARCHAR2 DEFAULT NULL,
   turn_of_all_    IN BOOLEAN DEFAULT FALSE )
IS
   TYPE Installation_Ref_Cursor IS REF CURSOR;
   get_components_    Installation_Ref_Cursor;
   cleanups_          Installation_Ref_Cursor;

   single_package_   VARCHAR2(32767);

   module_           VARCHAR2(10);
   module_installed_ VARCHAR2(5);

   pkg_name_         VARCHAR2(ORA_MAX_NAME_LEN);
   
   dependency_exist_ VARCHAR2(5);
   ent_edition_      VARCHAR2(15) := 'ENTEDITION';
   oracle_version_   NUMBER;

   cleanup_ CONSTANT VARCHAR2(32000) := 'SELECT u.object_name '||
                                        'FROM user_objects u '||
                                        'WHERE object_type = ''PACKAGE'' '||
                                        'AND object_name LIKE ''COMPONENT_%_SYS''  '||
                                        'AND NOT EXISTS '||
                                        '(SELECT dependent_module '||
                                        ' FROM module_dependency_tab '||
                                        ' WHERE dependent_module = SUBSTR(u.object_name, INSTR(u.object_name, ''_'', 1) + 1, INSTR(u.object_name, ''_'', -1, 1) - 11) '||
                                        ' AND dependency = ''DYNAMIC'') '||
                                        'ORDER BY 1';

   stmt_   CONSTANT VARCHAR2(32000) :=  'SELECT DISTINCT module, ''TRUE'' installed FROM module_tab m '||
                                        'WHERE Nvl(version, ''*'') != ''*'' AND version != ''?'' AND active = ''TRUE'' '||
                                        'AND EXISTS '||
                                        '(SELECT dependent_module '||
                                        ' FROM module_dependency_tab '||
                                        ' WHERE dependent_module = m.module '||
                                        ' AND dependency = ''DYNAMIC'') '||
                                        'UNION '||
                                        'SELECT DISTINCT dependent_module, ''FALSE'' installed FROM module_dependency_tab t WHERE NOT EXISTS ('||
                                        '   SELECT 1 FROM module_tab m WHERE m.module = t.dependent_module '||
                                        '   AND NVL(version, ''*'') NOT IN (''*'',''?'') AND active = ''TRUE'')'||
                                        '   AND EXISTS ('||
                                        '   SELECT 1 FROM module_tab m WHERE m.module = t.module'||
                                        '   AND version NOT IN (''*'',''?''))'||
                                        ' AND dependency = ''DYNAMIC'' '||
                                        'ORDER BY 1';

   stmt2_  CONSTANT VARCHAR2(32000) :=  'SELECT DISTINCT dependent_module, ''FALSE'' installed FROM module_dependency_tab t '||
                                        'WHERE NOT EXISTS ( '||
                                        '   SELECT 1 FROM module_tab m WHERE m.module = t.dependent_module '||
                                        '   AND active = ''TRUE'' '||
                                        '   AND NVL(version, ''*'') NOT IN (''*'',''?'') '||
                                        '   AND (NVL(interface_change, ''FALSE'') != ''TRUE'' '||
                                        '   OR NVL(interface_change, ''FALSE'') = ''TRUE'' '||
                                        '   AND NOT EXISTS ('||
                                        '   SELECT 1 FROM module_dependency_tab d, module_tab xx '||
                                        '   WHERE dependency = ''DYNAMIC'' '||
                                        '   AND dependent_module = m.module '||
                                        '   AND d.module = xx.module '||
                                        '   AND NVL(xx.included_in_delivery, ''FALSE'') = ''TRUE'' ))) '||
                                        'AND dependency = ''DYNAMIC'' '||
                                        'UNION '||
                                        'SELECT DISTINCT dependent_module, ''TRUE'' installed '||
                                        'FROM   module_dependency_tab t '||
                                        'WHERE  EXISTS (SELECT 1 '||
                                        '               FROM   module_tab m '||
                                        '               WHERE  m.module = t.dependent_module '||
                                        '               AND    active = ''TRUE'' '||
                                        '               AND    NVL(version, ''*'') NOT IN (''*'', ''?'') '||
                                        '               AND    NVL(interface_change, ''FALSE'') != ''TRUE'' '||
                                        '               AND NOT EXISTS '||
                                        '               (SELECT 1 '||
                                        '                FROM user_objects '||
                                        '                WHERE object_type = ''PACKAGE'' '||
                                        '                AND object_name = ''COMPONENT_''||t.dependent_module||''_SYS'')) '||
                                        'AND dependency = ''DYNAMIC'' '||
                                        'ORDER BY 1';

   stmt3_  CONSTANT VARCHAR2(32000) := 'SELECT DISTINCT dependent_module, ''FALSE'' installed FROM module_dependency_tab WHERE dependency = ''DYNAMIC'' ORDER BY 1';

   FUNCTION Create_Package_Name___ (
      component_ IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN('Component_'||INITCAP(component_)||'_SYS');
   END Create_Package_Name___;

   FUNCTION Create_Component_Package___ (
      component_ IN VARCHAR2,
      exists_    IN VARCHAR2,
      pkg_name_  IN VARCHAR2 ) RETURN VARCHAR2
   IS
   BEGIN
      RETURN (
'CREATE OR REPLACE PACKAGE '||pkg_name_||' IS'||nl_||
nl_||
'module_  CONSTANT VARCHAR2(25) := ''FNDBAS'';'||nl_||
'lu_name_ CONSTANT VARCHAR2(25) := ''Component'||INITCAP(component_)||''';'||nl_||
'lu_type_ CONSTANT VARCHAR2(25) := ''SystemService'';'||nl_||
nl_||
'-----------------------------------------------------------------------------'||nl_||
'-------------------- LU SPECIFIC GLOBAL VARIABLES ---------------------------'||nl_||
'-----------------------------------------------------------------------------'||nl_||
nl_||
'-----------------------------------------------------------------------------'||nl_||
'-------------------- INSTALLED COMPONENTS -----------------------------------'||nl_||
'-----------------------------------------------------------------------------'||nl_||
nl_||
'--@ApproveGlobalVariable(2017-01-01, '||user||')'||nl_||
'   '||rpad('INSTALLED', 15, ' ')||' CONSTANT BOOLEAN := '||exists_||';'||nl_||
nl_||
nl_||
'END '||pkg_name_||';'||nl_);
   END Create_Component_Package___;
   
BEGIN
   IF component_ IS NULL THEN
      IF installed_ THEN
         @ApproveDynamicStatement(2011-05-30,haarse)
         OPEN get_components_ FOR stmt_;
      ELSE
         IF turn_of_all_ THEN
            @ApproveDynamicStatement(2011-05-30,haarse)
            OPEN get_components_ FOR stmt3_;
         ELSE
            @ApproveDynamicStatement(2011-05-30,haarse)
            OPEN get_components_ FOR stmt2_;
         END IF;
      END IF;
      LOOP
         FETCH get_components_ INTO module_, module_installed_;
         EXIT WHEN get_components_%NOTFOUND; -- exit when last row is fetched
         pkg_name_ := Create_Package_Name___(module_);
         single_package_ := Create_Component_Package___(module_, module_installed_, pkg_name_);
         @ApproveDynamicStatement(2011-05-30,haarse)
         EXECUTE IMMEDIATE single_package_;
      END LOOP;
      CLOSE get_components_;
   ELSE
      pkg_name_ := Create_Package_Name___(component_);
      IF installed_ THEN
         single_package_ := Create_Component_Package___(component_, 'TRUE', pkg_name_);
      ELSE
         single_package_ := 'SELECT Module_Dependency_API.Dependency_Exist(:component_) FROM dual';
         @ApproveDynamicStatement(2013-09-10,mabose)
         EXECUTE IMMEDIATE single_package_ INTO dependency_exist_ USING component_;
         IF (dependency_exist_ = 'TRUE') THEN
            single_package_ := Create_Component_Package___(component_, 'FALSE', pkg_name_);
         @ApproveDynamicStatement(2013-09-10,mabose)
            EXECUTE IMMEDIATE single_package_;
         ELSE
            Remove_Package(pkg_name_);
         END IF;
      END IF;
   END IF;
   @ApproveDynamicStatement(2015-07-03,mabose)
   OPEN cleanups_ FOR cleanup_;
   LOOP
      FETCH cleanups_ INTO pkg_name_;
      EXIT WHEN cleanups_%NOTFOUND; -- exit when last row is fetched
      IF UPPER(pkg_name_) NOT IN (UPPER(Create_Package_Name___(ent_edition_))) THEN
         Remove_Package(pkg_name_);
      END IF;
   END LOOP;
   SELECT COUNT(*)
   INTO oracle_version_
   FROM v$version
   WHERE UPPER(banner) LIKE '%ENTERPRISE%EDITION%';
   IF (oracle_version_ > 0) THEN
      module_installed_ := 'TRUE';
   ELSE
      module_installed_ := 'FALSE';
   END IF;
   module_ := ent_edition_;
   pkg_name_ := Create_Package_Name___(module_);
   single_package_ := Create_Component_Package___(module_, module_installed_, pkg_name_);
   @ApproveDynamicStatement(2015-06-04,mabose)
   EXECUTE IMMEDIATE single_package_;
END Create_Component_Package;


@UncheckedAccess
PROCEDURE Create_Constraint (
   table_name_       IN VARCHAR2,
   constraint_name_  IN VARCHAR2,
   columns_          IN ColumnTabType,
   type_             IN VARCHAR2 DEFAULT 'P',
   index_tablespace_ IN VARCHAR2 DEFAULT NULL,
   storage_          IN VARCHAR2 DEFAULT NULL,
   replace_          IN BOOLEAN  DEFAULT TRUE,
   show_info_        IN BOOLEAN  DEFAULT FALSE,
   use_index_        IN BOOLEAN  DEFAULT TRUE,
   reference_clause_ IN VARCHAR2 DEFAULT NULL,
   on_delete_clause_ IN VARCHAR2 DEFAULT NULL )
IS
   ok_              NUMBER := 1;
   stmnt_           VARCHAR2(32000);
   chk_type_        VARCHAR2(20);
   idx_type_        VARCHAR2(20);
   old_columns_     VARCHAR2(4000);
   new_columns_     VARCHAR2(4000) := UPPER(Installation_SYS.Format_Columns(columns_, 'CONSTRAINT'));
BEGIN
   chk_type_    := type_;
   old_columns_ := NULL;
   IF (type_ LIKE 'U%') THEN
      chk_type_ := 'UNIQUE';
      idx_type_ := 'UNIQUE';
   ELSIF (type_ LIKE 'P%') THEN
      chk_type_ := 'PRIMARY KEY';
      idx_type_ := 'UNIQUE';
   ELSIF (type_ LIKE 'F%') THEN
      chk_type_ := 'FOREIGN KEY';
      idx_type_ := '';
   END IF;
   IF NOT (Table_Exist ( table_name_ ) ) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Constraint: Table ' || table_name_ || ' does not exist.');
      END IF;
      ok_ := 0;
   END IF;
   IF (Constraint_Exist ( constraint_name_ )) THEN
      IF (replace_ = FALSE) THEN
         IF (Show_Info___(show_info_) = TRUE) THEN
            Show_Message___ ('Create_Constraint: Constraint ' || constraint_name_ || ' already exist.');
         END IF;
         ok_ := 0;
      ELSE
         IF (chk_type_ != 'FOREIGN KEY') THEN
            old_columns_ := UPPER(Get_Constraint_Columns ( table_name_, constraint_name_ ));
         END IF;
         IF new_columns_ = old_columns_ THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___ ('Create_Constraint: Constraint ' || constraint_name_ || ' already exist with same columns.');
            END IF;
            ok_ := 0;
         ELSE
            Remove_Constraints___('Create_Constraint', table_name_, constraint_name_, show_info_);
            IF (Constraint_Exist ( constraint_name_ ) ) THEN
               Show_Message___ ('Create_Constraint: Constraint ' || constraint_name_ || ' exists for other table with same name.');
               ok_ := 0;
            END IF;
         END IF;
      END IF;
   ELSIF (chk_type_ = 'PRIMARY KEY' AND
          Primary_Key_Constraint_Exist(table_name_)) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Constraint: Primary Key Constraint for table ' || table_name_|| ' already exist.');
      END IF;
      ok_ := 0;
   END IF;
   IF (ok_ = 1) THEN
      stmnt_ :=  'ALTER TABLE ' || table_name_ || ' ADD CONSTRAINT ' || constraint_name_ || ' ';
      stmnt_ :=  stmnt_ || chk_type_ || ' (' || new_columns_ || ') ';
      IF (reference_clause_ IS NOT NULL) THEN
         IF (chk_type_ = 'FOREIGN KEY') THEN
            stmnt_ := stmnt_ || ' ' || reference_clause_;
         END IF;
      END IF;
      IF (use_index_) THEN
         Remove_Indexes___('Create_Constraint', table_name_, constraint_name_, show_info_);
         stmnt_ := stmnt_ || ' USING INDEX (CREATE ' || idx_type_ || ' INDEX ' || constraint_name_ || ' ON ' || table_name_ || ' (' || new_columns_ || ') ';
         IF NOT Is_Table_Temporary___(table_name_) THEN
               stmnt_ := stmnt_ || ' TABLESPACE ' || index_tablespace_;
            IF (storage_ IS NOT NULL) THEN
               IF Upper(storage_) LIKE '%INITIAL%' THEN
                  stmnt_ := stmnt_ || ' STORAGE (' || storage_ || ')';
               ELSE
                  stmnt_ := stmnt_ || ' STORAGE (INITIAL ' || storage_ || ')';
               END IF;
            END IF;
         END IF;
         stmnt_ := stmnt_ || ') ';
      END IF;
      IF (on_delete_clause_ IS NOT NULL) THEN
         IF (chk_type_ = 'FOREIGN KEY') THEN
            stmnt_ := stmnt_ || ' ' || on_delete_clause_;
         END IF;
      END IF;
      Run_Ddl_Command___(stmnt_, 'Create_Constraint', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Constraint: Constraint ' || constraint_name_ || ' (' || new_columns_ || ') created.');
      END IF;
   END IF;
END Create_Constraint;


@UncheckedAccess
PROCEDURE Create_Context (
   context_name_      IN VARCHAR2,
   context_package_   IN VARCHAR2,
   initialized_       IN VARCHAR2 DEFAULT NULL,
   accessed_          IN VARCHAR2 DEFAULT NULL,
   show_info_         IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_          VARCHAR2(32000);
   init_stmnt_     VARCHAR2(100);
   accessed_stmnt_ VARCHAR2(100);

   context_exists  EXCEPTION;
   PRAGMA          EXCEPTION_INIT(context_exists, -1408);
BEGIN
   IF (initialized_ IS NULL) THEN
      init_stmnt_       := NULL;
   ELSIF (initialized_ = 'GLOBALLY') THEN
      init_stmnt_       := ' INITIALIZED GLOBALLY ';
   ELSIF (initialized_ = 'EXTERNALLY') THEN
      init_stmnt_       := ' INITIALIZED EXTERNALLY ';
   ELSE
      NULL;
   END IF;
   IF (accessed_ IS NULL) THEN
      accessed_stmnt_   := NULL;
   ELSIF (accessed_ = 'GLOBALLY') THEN
      accessed_stmnt_   := ' ACCESSED GLOBALLY ';
   ELSE
      NULL;
   END IF;
   stmnt_ :=  'CREATE OR REPLACE CONTEXT ' || context_name_ ||' USING ' || context_package_ || init_stmnt_ || accessed_stmnt_;
   Run_Ddl_Command___(stmnt_, 'Create_Context', show_info_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___ ('Create_Context: Context ' || context_name_ || ' created.');
   END IF;
EXCEPTION
   WHEN context_exists THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Create_Context: Context ' || context_name_ || ' already exists.');
      END IF;
END Create_Context;


@UncheckedAccess
PROCEDURE Create_Directory (
   directory_name_  IN VARCHAR2,
   path_            IN VARCHAR2,
   read_grant_      IN BOOLEAN  DEFAULT TRUE,
   write_grant_     IN BOOLEAN  DEFAULT TRUE,
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_          VARCHAR2(32000);
BEGIN
   stmnt_ :=  'CREATE OR REPLACE DIRECTORY ' || directory_name_ ||' AS ''' || path_ || '''';
   Run_Ddl_Command___(stmnt_, 'Create_Directory', show_info_);
   IF read_grant_ THEN
      stmnt_ := ' GRANT read ON DIRECTORY ' || directory_name_ || ' TO ' || Sys_Context('USERENV', 'CURRENT_SCHEMA');
      --Run_Ddl_Command___(stmnt_, 'Create_Directory (Grant read): ', show_info_);
   END IF;
   IF write_grant_ THEN
      stmnt_ := 'GRANT write ON DIRECTORY ' || directory_name_ || ' TO ' || Sys_Context('USERENV', 'CURRENT_SCHEMA');
      --Run_Ddl_Command___(stmnt_, 'Create_Directory (Grant write): ', show_info_);
   END IF;
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___ ('Create_Directory: Directory ' || directory_name_ || ' created.');
   END IF;
END Create_Directory;


@UncheckedAccess
PROCEDURE Create_Index (
   table_name_      IN VARCHAR2,
   index_name_      IN VARCHAR2,
   columns_         IN ColumnTabType,
   type_            IN VARCHAR2 DEFAULT 'N',
   tablespace_      IN VARCHAR2 DEFAULT NULL,
   storage_         IN VARCHAR2 DEFAULT NULL,
   replace_         IN BOOLEAN  DEFAULT TRUE,
   show_info_       IN BOOLEAN  DEFAULT FALSE,
   exception_       IN BOOLEAN  DEFAULT FALSE )
IS
   ok_             NUMBER := 1;
   stmnt_          VARCHAR2(32000);
   chk_type_       VARCHAR2(20);
   old_columns_    VARCHAR2(4000);
   new_columns_    VARCHAR2(4000) := UPPER(Installation_SYS.Format_Columns(columns_, 'INDEX'));
   old_uniqueness_ VARCHAR2(10);
   new_uniqueness_ VARCHAR2(10);
   temp_table_     BOOLEAN := FALSE;

   column_already_indexed EXCEPTION;
   PRAGMA                 EXCEPTION_INIT(column_already_indexed, -1408);
   non_unique_values_exists  EXCEPTION;
   PRAGMA                 EXCEPTION_INIT(non_unique_values_exists, -1452);
BEGIN
   chk_type_       := type_;
   old_columns_    := NULL;
   old_uniqueness_ := NULL;
   IF (UPPER(type_) LIKE 'U%') THEN
      chk_type_       := 'UNIQUE';
      new_uniqueness_ := 'UNIQUE';
   ELSIF (UPPER(type_) LIKE 'N%') THEN
      chk_type_       := NULL;
      new_uniqueness_ := 'NONUNIQUE';
   END IF;
   IF NOT (Table_Exist ( table_name_ ) ) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Index: Table ' || table_name_ || ' does not exist.');
      END IF;
      ok_ := 0;
   ELSIF (Index_Exist ( index_name_ ) ) THEN
      IF (replace_ = FALSE) THEN
         IF (Show_Info___(show_info_) = TRUE) THEN
            Show_Message___ ('Create_Index: Index ' || index_name_ || ' already exist.');
         END IF;
         ok_ := 0;
      ELSE
         old_columns_    := UPPER(Get_Index_Columns ( table_name_, index_name_ ));
         old_uniqueness_ := Get_Index_Uniqueness ( table_name_, index_name_ );
         IF (old_columns_ = new_columns_ AND
             old_uniqueness_ = new_uniqueness_) THEN
            IF (Show_Info___(show_info_) = TRUE) THEN
               Show_Message___ ('Create_Index: Index ' || index_name_ || ' already exist with same uniqueness/columns.');
            END IF;
            ok_ := 0;
         ELSE
            Remove_Indexes___('Create_Index', table_name_, index_name_, show_info_ );
            IF (Index_Exist ( index_name_ ) ) THEN
               Show_Message___ ('Create_Index: Index ' || index_name_ || ' exists for other table with same name.');               
               ok_ := 0;
            END IF;
         END IF;
      END IF;
   END IF;
   IF (ok_ = 1) THEN
      stmnt_ :=  'CREATE ' || chk_type_ || ' INDEX ' || index_name_ || ' ';
      stmnt_ :=  stmnt_ || ' ON '||table_name_ || '(' || new_columns_ || ') ';
      temp_table_ := Is_Table_Temporary___ (table_name_);
      IF (tablespace_ IS NOT NULL) THEN
         IF (NOT temp_table_) THEN --Temporary tables cant have tablespaces
            stmnt_ := stmnt_ || ' TABLESPACE ' || tablespace_;
         END IF;
      END IF;
      IF temp_table_ = FALSE THEN
         stmnt_ := stmnt_ || ' PARALLEL ';
      END IF;
      IF (storage_ IS NOT NULL) THEN
         IF Upper(storage_) LIKE '%INITIAL%' THEN
            stmnt_ := stmnt_ || ' STORAGE (' || storage_ || ')';
         ELSE
            stmnt_ := stmnt_ || ' STORAGE (INITIAL ' || storage_ || ')';
         END IF;
      END IF;
      Run_Ddl_Command___(stmnt_, 'Create_Index', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Index: Index ' || index_name_ || ' (' || LOWER(new_columns_) || ') (' || LOWER(new_uniqueness_) || ') created.');
      END IF;
   END IF;
EXCEPTION
   WHEN column_already_indexed THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Create_Index: Columns (' || new_columns_ || ') for table ' || table_name_ || ' already indexed.');
      END IF;
      IF (exception_) THEN
         RAISE;
      END IF;
   WHEN non_unique_values_exists THEN
      Show_Message___('Create_Index: Non unique values for columns (' || new_columns_ || ') for table ' || table_name_ || ' exists.');
      IF (exception_) THEN
         RAISE;
      END IF;
END Create_Index;


@UncheckedAccess
PROCEDURE Create_Sequence (
   sequence_     IN VARCHAR2,
   parameters_   IN VARCHAR2,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_           VARCHAR2(2000);
   ok_              NUMBER := 1;
BEGIN
   IF (Object_Exist ( sequence_, 'SEQUENCE')) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Sequence: Sequence ' || sequence_ || ' already exist.');
      END IF;
      ok_ := 0;
   END IF;
   IF (ok_ = 1) THEN
      stmnt_ := 'CREATE SEQUENCE ' || sequence_ || ' ' || parameters_;
      Run_Ddl_Command___(stmnt_, 'Create_Sequence', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Create_Sequence: Sequence ' || sequence_ || ' created.');
      END IF;
   END IF;
END Create_Sequence;


@UncheckedAccess
PROCEDURE Create_Text_Index (
   index_name_      IN VARCHAR2,
   table_name_      IN VARCHAR2,
   column_name_     IN VARCHAR2,
   parameters_      IN VARCHAR2,
   replace_         IN BOOLEAN  DEFAULT TRUE,
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
   ok_             NUMBER := 1;
   stmnt_          VARCHAR2(32000);
   --
BEGIN
   IF NOT (Table_Exist ( table_name_ ) ) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Text_Index: Table ' || table_name_ || ' does not exist.');
      END IF;
      ok_ := 0;
   ELSIF (Text_Index_Exist ( index_name_ ) ) THEN
      IF (replace_ = FALSE) THEN
         IF (Show_Info___(show_info_) = TRUE) THEN
            Show_Message___ ('Create_Text_Index: Index ' || index_name_ || ' already exist.');
         END IF;
         ok_ := 0;
      ELSE
         Remove_Indexes___('Create_Text_Index', table_name_, index_name_, show_info_ );
         IF (Text_Index_Exist ( index_name_ ) ) THEN            
            Show_Message___ ('Create_Text_Index: Index ' || index_name_ || ' exists for other table with same name.');
            ok_ := 0;
         END IF;
      END IF;
   END IF;
   IF (ok_ = 1) THEN
      stmnt_ := 'CREATE INDEX '||index_name_||' ON '||table_name_||'('||column_name_||') INDEXTYPE IS CTXSYS.CONTEXT ';
      IF (Installation_SYS.Is_Option_Available('Online Index Build')) THEN -- Check if Online Index Rebuild is available.
         stmnt_ := stmnt_ || ' ONLINE ';
      END IF;
      stmnt_ := stmnt_ || ' PARAMETERS ('||parameters_||') ';
      Run_Ddl_Command___(stmnt_, 'Create_Text_Index', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Text_Index: Index ' || index_name_ || ' created.');
      END IF;
   END IF;
END Create_Text_Index;


@UncheckedAccess
PROCEDURE Create_Trigger (
   trigger_name_  IN VARCHAR2,
   trigger_type_  IN VARCHAR2,
   dml_event_     IN VARCHAR2,
   columns_       IN ColumnTabType,
   table_name_    IN VARCHAR2,
   condition_     IN VARCHAR2,
   plsql_block_   IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE,
   disabled_      IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_            VARCHAR2(32000);
   new_line_         VARCHAR2(2) := chr(13)||chr(10);
   indent_           VARCHAR2(3) := '   ';
BEGIN
   stmnt_ := 'CREATE OR REPLACE TRIGGER ' || UPPER(trigger_name_) || new_line_;
   stmnt_ := stmnt_ || indent_ || UPPER(trigger_type_) || ' ';   
   IF dml_event_ = 'UPDATE' AND columns_.First IS NOT NULL THEN      
      stmnt_ := stmnt_ || 'UPDATE OF ' || UPPER(Installation_SYS.Format_Columns (columns_, 'TRIGGER')); 
   ELSE
      stmnt_ := stmnt_ || UPPER(dml_event_);
   END IF;
   stmnt_ := stmnt_ || ' ON ' || table_name_ || new_line_;
   stmnt_ := stmnt_ || indent_ || 'FOR EACH ROW ' || new_line_;
   IF disabled_  THEN
      stmnt_ := stmnt_ || ' DISABLE '|| new_line_;
   END IF;
   IF condition_ IS NOT NULL THEN
      stmnt_ := stmnt_ || indent_ || 'WHEN (' || condition_ ||')'|| new_line_;
   END IF;
   stmnt_ := stmnt_ || 'BEGIN ' || new_line_;   
   stmnt_ := stmnt_ || indent_ || REPLACE(LTRIM(plsql_block_, ' '), chr(10), chr(10) || indent_) || new_line_;
   stmnt_ := stmnt_ || 'END;';
   Run_Ddl_Command___(stmnt_, 'Create_Trigger', show_info_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___ ('Create_Trigger: Trigger ' || trigger_name_ || ' created.');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Disable_Trigger(trigger_name_, show_info_);
      Raise_Application_Error(-20150,'Error when creating trigger. ' || SQLERRM);
END Create_Trigger;


@UncheckedAccess
PROCEDURE Disable_Trigger (
   trigger_name_  IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE ) 
IS
   stmnt_            VARCHAR2(32000);
BEGIN
   IF Trigger_Exist(trigger_name_) THEN
      stmnt_ := 'ALTER TRIGGER ' || trigger_name_ || ' DISABLE ';
      Run_Ddl_Command___(stmnt_, 'Disable_Trigger', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Disable_Trigger: Trigger ' || trigger_name_ || ' disabled.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Disable_Trigger: Trigger ' || trigger_name_ || ' does not exist.');
      END IF;
   END IF;
END Disable_Trigger;


@UncheckedAccess
PROCEDURE Enable_Trigger (
   trigger_name_  IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE ) 
IS
   stmnt_            VARCHAR2(32000);
BEGIN
   IF Trigger_Exist(trigger_name_) THEN
      stmnt_ := 'ALTER TRIGGER ' || trigger_name_ || ' ENABLE ';
      Run_Ddl_Command___(stmnt_, 'Enable_Trigger', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Enable_Trigger: Trigger ' || trigger_name_ || ' enabled.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Enable_Trigger: Trigger ' || trigger_name_ || ' does not exist.');
      END IF;
   END IF;
END Enable_Trigger;


@UncheckedAccess
PROCEDURE Create_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   tablespace_    IN VARCHAR2 DEFAULT NULL,
   storage_       IN VARCHAR2 DEFAULT NULL,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_            VARCHAR2(32000);
BEGIN
   FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
      IF (columns_(i).data_type IN ('CLOB', 'BLOB')) THEN
         Show_Message___('Create_Table error: This method cannot be used for BLOB or CLOB columns.');
         RETURN;
      END IF;
   END LOOP;
   IF NOT (Table_Exist ( table_name_ ) ) THEN
      stmnt_ := 'CREATE TABLE ' || table_name_ || ' ( ';
      stmnt_ := stmnt_ || Installation_SYS.Format_Columns (columns_, 'TABLE', TRUE);
      stmnt_ := stmnt_ || ') ';
      IF (NOT dbms_db_version.ver_le_11_1 AND Functionality_Exist('Deferred Segment Creation') = 'TRUE') THEN -- Enterprise Edition functionality
         stmnt_ := stmnt_ || ' SEGMENT CREATION DEFERRED ';
      END IF;
      IF (tablespace_ IS NOT NULL) THEN
         stmnt_ := stmnt_ || ' TABLESPACE ' || tablespace_;
      END IF;
      IF (storage_ IS NOT NULL) THEN
         IF Upper(storage_) LIKE '%INITIAL%' THEN
            stmnt_ := stmnt_ || ' STORAGE (' || storage_ || ')';
         ELSE
            stmnt_ := stmnt_ || ' STORAGE (INITIAL ' || storage_ || ')';
         END IF;
      END IF;
      Run_Ddl_Command___(stmnt_, 'Create_Table', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Table: Table ' || table_name_ || ' created.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Table: Table ' || table_name_ || ' already created.');
      END IF;
   END IF;
END Create_Table;


@UncheckedAccess
PROCEDURE Create_Table_Iot (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   primary_key_   IN ColumnTabType,
   tablespace_    IN VARCHAR2 DEFAULT NULL,
   storage_       IN VARCHAR2 DEFAULT NULL,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_            VARCHAR2(32000);
BEGIN
   FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
      IF (columns_(i).data_type IN ('CLOB', 'BLOB')) THEN
         Show_Message___('Create_Table error: This method cannot be used for BLOB or CLOB columns.');
         RETURN;
      END IF;
   END LOOP;
   IF NOT (Table_Exist ( table_name_ ) ) THEN
      stmnt_ := 'CREATE TABLE ' || table_name_ || ' ( ';
      stmnt_ := stmnt_ || Installation_SYS.Format_Columns (columns_, 'TABLE', TRUE);
      stmnt_ := stmnt_ || ', CONSTRAINT '|| replace(upper(table_name_), '_TAB', '') || '_PK PRIMARY KEY ( ' || Installation_SYS.Format_Columns (primary_key_, 'INDEX', TRUE);
      stmnt_ := stmnt_ || ')) ORGANIZATION INDEX ';
      IF (tablespace_ IS NOT NULL) THEN
         stmnt_ := stmnt_ || ' TABLESPACE ' || tablespace_;
      END IF;
      IF (storage_ IS NOT NULL) THEN
         IF Upper(storage_) LIKE '%INITIAL%' THEN
            stmnt_ := stmnt_ || ' STORAGE (' || storage_ || ')';
         ELSE
            stmnt_ := stmnt_ || ' STORAGE (INITIAL ' || storage_ || ')';
         END IF;
      END IF;
      Run_Ddl_Command___(stmnt_, 'Create_Table_Iot', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Table_Iot: Table ' || table_name_ || ' created.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Table_Iot: Table ' || table_name_ || ' already created.');
      END IF;
   END IF;
END Create_Table_Iot;


@UncheckedAccess
PROCEDURE Create_Or_Replace_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   tablespace_    IN VARCHAR2 DEFAULT NULL,
   storage_       IN VARCHAR2 DEFAULT NULL,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
      IF (columns_(i).data_type IN ('CLOB', 'BLOB')) THEN
         Show_Message___('Create_Table error: This method cannot be used for BLOB or CLOB columns.');
         RETURN;
      END IF;
   END LOOP;
   IF (Table_Exist ( table_name_ ) ) THEN
      Alter_Table (table_name_,
                   columns_,
                   show_info_ );
   ELSE
      Create_Table(table_name_,
                   columns_   ,
                   tablespace_,
                   storage_   ,
                   show_info_ );
   END IF;
END Create_Or_Replace_Table;


@UncheckedAccess
PROCEDURE Create_Or_Replace_Type (
   type_name_     IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   PROCEDURE Remove_Dependencies___ (
      type_name_     IN VARCHAR2,
      show_info_     IN BOOLEAN  DEFAULT FALSE )
   IS
      CURSOR get_dep IS 
      SELECT name, type
        FROM user_dependencies
       WHERE referenced_name = type_name_
         AND type = 'TYPE';
   BEGIN
      FOR rec IN get_dep LOOP
         CASE rec.type
         WHEN 'TYPE' THEN 
            Installation_SYS.Remove_Type(rec.name, show_info_);
         ELSE
            NULL;
         END CASE;
      END LOOP;
   END Remove_Dependencies___;
   PROCEDURE Create_Type___ (
      type_name_     IN VARCHAR2,
      columns_       IN ColumnTabType,
      show_info_     IN BOOLEAN  DEFAULT FALSE )
   IS
      stmnt_            VARCHAR2(32000);
   BEGIN
      stmnt_ := 'CREATE OR REPLACE NONEDITIONABLE TYPE ' || type_name_ || ' AS OBJECT ( ' || nl_;
      stmnt_ := stmnt_ || Installation_SYS.Format_Columns (columns_, 'TABLE', TRUE) || nl_;
      stmnt_ := stmnt_ || ') ';
      Run_Ddl_Command___(stmnt_, 'Create_Type', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Type: Type ' || type_name_ || ' created.');
      END IF;
   END Create_Type___;
BEGIN
   Remove_Dependencies___(type_name_, show_info_);
   Create_Type___(type_name_, columns_, show_info_);
END Create_Or_Replace_Type;

@UncheckedAccess
PROCEDURE Create_Or_Replace_Type (
   type_name_     IN VARCHAR2,
   type_table_    IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   PROCEDURE Remove_Dependencies___ (
      type_name_     IN VARCHAR2,
      show_info_     IN BOOLEAN  DEFAULT FALSE )
   IS
      CURSOR get_dep IS 
      SELECT name, type
        FROM user_dependencies
       WHERE referenced_name = type_name_
         AND type = 'TYPE';
   BEGIN
      FOR rec IN get_dep LOOP
         CASE rec.type
         WHEN 'TYPE' THEN 
            Installation_SYS.Remove_Type(rec.name, show_info_);
         ELSE
            NULL;
         END CASE;
      END LOOP;
   END Remove_Dependencies___;
   PROCEDURE Create_Type___ (
      type_name_     IN VARCHAR2,
      type_table_    IN VARCHAR2,
      show_info_     IN BOOLEAN  DEFAULT FALSE )
   IS
      stmnt_            VARCHAR2(32000);
   BEGIN
      stmnt_ := 'CREATE OR REPLACE NONEDITIONABLE TYPE ' || type_name_ || ' AS TABLE OF ' || type_table_;
      Run_Ddl_Command___(stmnt_, 'Create_Type', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Type: Type ' || type_name_ || ' created.');
      END IF;
   END Create_Type___;
BEGIN
   Remove_Dependencies___(type_name_, show_info_);
   Create_Type___(type_name_, type_table_, show_info_);
END Create_Or_Replace_Type;

@UncheckedAccess
PROCEDURE Create_Type (
   type_name_     IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   PROCEDURE Create_Type___ (
      type_name_     IN VARCHAR2,
      columns_       IN ColumnTabType,
      show_info_     IN BOOLEAN  DEFAULT FALSE )
   IS
      stmnt_            VARCHAR2(32000);
   BEGIN
      stmnt_ := 'CREATE OR REPLACE NONEDITIONABLE TYPE ' || type_name_ || ' AS OBJECT ( ' || nl_;
      stmnt_ := stmnt_ || Installation_SYS.Format_Columns (columns_, 'TABLE', TRUE) || nl_;
      stmnt_ := stmnt_ || ') ';
      Run_Ddl_Command___(stmnt_, 'Create_Type', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Type: Type ' || type_name_ || ' created.');
      END IF;
   END Create_Type___;
BEGIN
   IF (Object_Exist ( type_name_, 'TYPE')) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Type: Type ' || type_name_ || ' already exists.');
      END IF;
   ELSE
      Create_Type___(type_name_, columns_, show_info_);
   END IF;
END Create_Type;

@UncheckedAccess
PROCEDURE Create_Type (
   type_name_     IN VARCHAR2,
   type_table_    IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   PROCEDURE Create_Type___ (
      type_name_     IN VARCHAR2,
      type_table_    IN VARCHAR2,
      show_info_     IN BOOLEAN  DEFAULT FALSE )
   IS
      stmnt_            VARCHAR2(32000);
   BEGIN
      stmnt_ := 'CREATE OR REPLACE NONEDITIONABLE TYPE ' || type_name_ || ' AS TABLE OF ' || type_table_;
      Run_Ddl_Command___(stmnt_, 'Create_Type', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Type: Type ' || type_name_ || ' created.');
      END IF;
   END Create_Type___;
BEGIN
   IF (Object_Exist ( type_name_, 'TYPE')) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Type: Type ' || type_name_ || ' already exists.');
      END IF;
   ELSE
      Create_Type___(type_name_, type_table_, show_info_);
   END IF;
END Create_Type;

@UncheckedAccess
PROCEDURE Create_Or_Replace_Empty_View (
   view_name_    IN VARCHAR2,
   columns_      IN ColumnViewType,
   lu_           IN VARCHAR2 DEFAULT NULL,
   module_       IN VARCHAR2 DEFAULT NULL,
   server_only_  IN VARCHAR2 DEFAULT NULL,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
   comment_   user_tab_comments.comments%TYPE;
   CURSOR get_view_comment IS
      SELECT comments
      FROM user_tab_comments
      WHERE table_name = UPPER(view_name_);
BEGIN
   OPEN get_view_comment;
   FETCH get_view_comment INTO comment_;
   CLOSE get_view_comment;
   IF (View_Exist(view_name_)
   AND NVL(comment_,'xx') != 'MODULE=IGNORE^') THEN
      Alter_View___(view_name_,
                    columns_,
                    show_info_);
   ELSE
      Create_Empty_View___(view_name_,
                           columns_,
                           lu_,
                           module_,
                           server_only_,
                           show_info_);
   END IF;
END Create_Or_Replace_Empty_View;


@UncheckedAccess
PROCEDURE Create_Temporary_Table (
   table_name_    IN VARCHAR2,
   columns_       IN ColumnTabType,
   show_info_     IN BOOLEAN  DEFAULT FALSE ) 
IS
   stmnt_            VARCHAR2(32000);
BEGIN
   FOR i IN Nvl(columns_.first, 0)..Nvl(columns_.last, 0) LOOP
      IF (columns_(i).data_type IN ('CLOB', 'BLOB')) THEN
         Show_Message___('Create_Temporary_Table error: This method cannot be used for BLOB or CLOB columns.');
         RETURN;
      END IF;
   END LOOP;
   IF NOT (Table_Exist ( table_name_ ) ) THEN
      stmnt_ := 'CREATE GLOBAL TEMPORARY TABLE ' || table_name_ || ' ( ';
      stmnt_ := stmnt_ || Installation_SYS.Format_Columns (columns_, 'TABLE');
      stmnt_ := stmnt_ || ') ON COMMIT DELETE ROWS';
      Run_Ddl_Command___(stmnt_, 'Create_Temporary_Table', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Temporary_Table: Table ' || table_name_ || ' created.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Create_Temporary_Table: Table ' || table_name_ || ' already created.');
      END IF;
   END IF;
END Create_Temporary_Table;


@UncheckedAccess
FUNCTION Format_Column (
   colrec_ IN ColRec,
   type_ IN VARCHAR2 DEFAULT 'TABLE',
   create_table_ IN BOOLEAN  DEFAULT FALSE ) RETURN VARCHAR2
IS
   column_              ColRec := colrec_;
   stmt_                VARCHAR2(4000);
   old_default_value_   VARCHAR2(4000) := Get_Default_Value(column_.table_name, column_.column_name);
   old_nullable_        VARCHAR2(100)  := Get_Column_Nullable(column_.table_name, column_.column_name);
   old_on_null_         VARCHAR2(100)  := Get_Column_On_Null(column_.table_name, column_.column_name);
   old_identity_        VARCHAR2(100)  := Get_Column_Is_Identity(column_.table_name, column_.column_name);
   nullable_stmt_       VARCHAR2(30);
BEGIN
   stmt_ := NULL;
   IF type_ = 'TABLE' THEN
      -- Data Type
      IF (column_.data_type IS NOT NULL) THEN
         IF (column_.data_type = 'IDENTITY') THEN
            stmt_ := stmt_ || ' NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY ';
         ELSIF (old_identity_ = 'YES') THEN
            stmt_ := stmt_ || ' ' || column_.data_type || ' DROP IDENTITY ';
         ELSE
            stmt_ := stmt_ || ' ' || column_.data_type;
         END IF;
      END IF;
      -- Default value
      IF (column_.default_value IS NOT NULL) THEN
         IF column_.keep_default = 'N' AND create_table_ THEN
            NULL;
         ELSE
            IF (column_.default_value = '$DEFAULT_NULL$') THEN -- $DEFAULT_NULL$ is a special value for setting DEFAULT NULL
               stmt_ := stmt_ || ' DEFAULT NULL';
            ELSE
               stmt_ := stmt_ || ' DEFAULT ON NULL ' || column_.default_value;
            END IF;
         END IF;
      ELSE
         IF (nvl(old_nullable_, 'N') = 'N'
         AND column_.nullable = 'Y'
         AND old_on_null_ = 'YES'
         AND NVL(old_identity_, 'NO') = 'NO'
         AND old_default_value_ IS NOT NULL) THEN
            stmt_ := stmt_ || ' DEFAULT ON NULL ' || old_default_value_;
         END IF;
      END IF;
      -- Mandatory
      IF (column_.nullable IS NOT NULL) THEN
         IF (nvl(old_nullable_, 'Y') = column_.nullable) THEN
             nullable_stmt_ := '';
         ELSIF (column_.nullable = 'Y') THEN
             nullable_stmt_ := ' NULL';
         ELSIF (column_.nullable = 'N') THEN
             nullable_stmt_ := ' NOT NULL';
         END IF;
         stmt_ := stmt_ || nullable_stmt_;
      END IF;
      -- Lob parameter
      IF (column_.lob_parameter IS NOT NULL) THEN
         IF(stmt_ IS NOT NULL) THEN
            stmt_ := column_.column_name || stmt_ || ' ' || 'MODIFY LOB (' || column_.column_name || ') ' || column_.lob_parameter;
         ELSE
            stmt_ := 'LOB (' || column_.column_name || ') ' || column_.lob_parameter;
         END IF;
      ELSE
         stmt_ := RTRIM(column_.column_name ||' '|| stmt_);
      END IF;
   ELSE
      stmt_ := column_.column_name;
   END IF;
   RETURN (stmt_);
END Format_Column;


@UncheckedAccess
FUNCTION Format_Columns (
   columns_ IN ColumnTabType,
   type_    IN VARCHAR2 DEFAULT 'TABLE',
   create_table_ IN BOOLEAN  DEFAULT FALSE ) RETURN VARCHAR2
IS
   stmt_             VARCHAR2(32000);
BEGIN
   FOR i IN columns_.FIRST..columns_.LAST LOOP
      IF i = 1 THEN
         stmt_ := stmt_ || Installation_SYS.Format_Column(columns_(i), type_, create_table_);
      ELSE
         stmt_ := stmt_ || ', ' || Installation_SYS.Format_Column(columns_(i), type_, create_table_);
      END IF;
   END LOOP;
   RETURN (stmt_);
END Format_Columns;


@UncheckedAccess
FUNCTION Functionality_Exist (
   functionality_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   exist_   VARCHAR2(5) := 'FALSE';
   CURSOR get_functionality IS
      SELECT value
      FROM   sys.v_$option
      WHERE  parameter = functionality_;
BEGIN
   OPEN  get_functionality;
   FETCH get_functionality INTO exist_;
   CLOSE get_functionality;
   RETURN(exist_);
END Functionality_Exist;



@UncheckedAccess
FUNCTION Get_Column_Nullable (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   nullable_          VARCHAR2(1);
   CURSOR get_nullable IS
      SELECT   nullable
      FROM     user_tab_columns
      WHERE    table_name  = UPPER(table_name_)
      AND      column_name = UPPER(column_name_);
BEGIN
   OPEN  get_nullable;
   FETCH get_nullable INTO nullable_;
   CLOSE get_nullable;
   RETURN nullable_;
END Get_Column_Nullable;


@UncheckedAccess
FUNCTION Get_Column_On_Null (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   on_null_          VARCHAR2(5);
   CURSOR get_on_null IS
      SELECT   default_on_null
      FROM     user_tab_columns
      WHERE    table_name  = UPPER(table_name_)
      AND      column_name = UPPER(column_name_);
BEGIN
   OPEN  get_on_null;
   FETCH get_on_null INTO on_null_;
   CLOSE get_on_null;
   RETURN on_null_;
END Get_Column_On_Null;


@UncheckedAccess
FUNCTION Get_Column_Is_Identity (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   identity_column_ VARCHAR2(5);
   CURSOR get_identity_column IS
      SELECT   identity_column
      FROM     user_tab_columns
      WHERE    table_name  = UPPER(table_name_)
      AND      column_name = UPPER(column_name_);
BEGIN
   OPEN  get_identity_column;
   FETCH get_identity_column INTO identity_column_;
   CLOSE get_identity_column;
   RETURN identity_column_;
END Get_Column_Is_Identity;


@UncheckedAccess
FUNCTION Get_Column_Type (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   type_          VARCHAR2(20);
   CURSOR get_type IS
      SELECT   data_type
      FROM     user_tab_columns
      WHERE    table_name  = UPPER(table_name_)
      AND      column_name = UPPER(column_name_);
BEGIN
   OPEN  get_type;
   FETCH get_type INTO type_;
   CLOSE get_type;
   RETURN type_;
END Get_Column_Type;


@UncheckedAccess
FUNCTION Get_Object_Type (
   object_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   type_ user_objects.object_type%TYPE;
   CURSOR get_type IS
      SELECT   object_type
      FROM     user_objects
      WHERE    object_name = UPPER(object_name_)
      AND      object_type != 'PACKAGE BODY';
BEGIN
   OPEN  get_type;
   FETCH get_type INTO type_;
   CLOSE get_type;
   RETURN type_;
END Get_Object_Type;


@UncheckedAccess
FUNCTION Get_Default_Value (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN LONG
IS
   default_value_ LONG;
   CURSOR get_default_value IS
      SELECT   data_default
      FROM     user_tab_columns t
      WHERE    table_name  = UPPER(table_name_)
      AND      column_name = UPPER(column_name_);
BEGIN
   OPEN  get_default_value;
   FETCH get_default_value INTO default_value_;
   CLOSE get_default_value;
   RETURN default_value_;
END Get_Default_Value;


@UncheckedAccess
FUNCTION Get_Index_Columns (
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   ind_columns_    VARCHAR2(4000);
   CURSOR get_ind_columns IS
      SELECT column_name
      FROM   user_ind_columns
      WHERE  index_name = UPPER(index_name_)
      ORDER BY column_position;
BEGIN
   FOR rec_ IN get_ind_columns LOOP
      IF (ind_columns_ IS NULL) THEN
         ind_columns_ := rec_.column_name;
      ELSE
         ind_columns_ := ind_columns_ || ', ' || rec_.column_name;
      END IF;
   END LOOP;
   RETURN ind_columns_;
END Get_Index_Columns;


@UncheckedAccess
FUNCTION Get_Index_Columns (
   table_name_  IN VARCHAR2,
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   ind_columns_    VARCHAR2(4000);
   CURSOR get_ind_columns IS
      SELECT column_name
      FROM   user_ind_columns
      WHERE    table_name = UPPER(table_name_)
      AND      index_name = UPPER(index_name_)
      ORDER BY column_position;
BEGIN
   FOR rec_ IN get_ind_columns LOOP
      IF (ind_columns_ IS NULL) THEN
         ind_columns_ := rec_.column_name;
      ELSE
         ind_columns_ := ind_columns_ || ', ' || rec_.column_name;
      END IF;
   END LOOP;
   RETURN ind_columns_;
END Get_Index_Columns;


@UncheckedAccess
FUNCTION Get_Index_Table (
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   table_name_    user_indexes.table_name%TYPE;
   CURSOR get_table_name IS
      SELECT table_name
      FROM   user_indexes
      WHERE  index_name = UPPER(index_name_);
BEGIN
   OPEN  get_table_name;
   FETCH get_table_name INTO table_name_;
   CLOSE get_table_name;
   RETURN table_name_;
END Get_Index_Table;


@UncheckedAccess
FUNCTION Get_Index_Type (
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   index_type_    user_indexes.index_type%TYPE;
   CURSOR get_index_type IS
      SELECT index_type
      FROM   user_indexes
      WHERE  index_name = UPPER(index_name_);
BEGIN
   OPEN  get_index_type;
   FETCH get_index_type INTO index_type_;
   CLOSE get_index_type;
   RETURN index_type_;
END Get_Index_Type;


@UncheckedAccess
FUNCTION Get_Index_Uniqueness (
   table_name_  IN VARCHAR2,
   index_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   uniqueness_     VARCHAR2(10);
   CURSOR get_uniqueness IS
      SELECT   uniqueness
      FROM     user_indexes
      WHERE    table_name = UPPER(table_name_)
      AND      index_name = UPPER(index_name_);
BEGIN
   OPEN  get_uniqueness;
   FETCH get_uniqueness INTO uniqueness_;
   CLOSE get_uniqueness;
   RETURN uniqueness_;
END Get_Index_Uniqueness;


@UncheckedAccess
FUNCTION Get_Constraint_Columns (
   constraint_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cons_columns_    VARCHAR2(4000);
   CURSOR get_cons_columns IS
      SELECT column_name
      FROM   user_cons_columns
      WHERE  constraint_name = UPPER(constraint_name_)
      ORDER BY position;
BEGIN
   FOR rec_ IN get_cons_columns LOOP
      IF (cons_columns_ IS NULL) THEN
         cons_columns_ := rec_.column_name;
      ELSE
         cons_columns_ := cons_columns_ || ', ' || rec_.column_name;
      END IF;
   END LOOP;
   RETURN cons_columns_;
END Get_Constraint_Columns;


@UncheckedAccess
FUNCTION Get_Constraint_Columns (
   table_name_      IN VARCHAR2,
   constraint_name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cons_columns_    VARCHAR2(4000);
   CURSOR get_cons_columns IS
      SELECT column_name
      FROM   user_cons_columns
      WHERE  table_name = UPPER(table_name_)
      AND    constraint_name = UPPER(constraint_name_)
      ORDER BY position;
BEGIN
   FOR rec_ IN get_cons_columns LOOP
      IF (cons_columns_ IS NULL) THEN
         cons_columns_ := rec_.column_name;
      ELSE
         cons_columns_ := cons_columns_ || ', ' || rec_.column_name;
      END IF;
   END LOOP;
   RETURN cons_columns_;
END Get_Constraint_Columns;

@UncheckedAccess
PROCEDURE Grant_Privileged_Grantee (
   grantee_   IN VARCHAR2,
   show_info_ IN BOOLEAN  DEFAULT FALSE )
IS
   method_ VARCHAR2(30) := 'Grant_Privileged_Grantee';
BEGIN
   CASE grantee_
      WHEN 'IFSSYS' THEN
         Grant_Ifssys(show_info_);
--         Grant_Privileged_Grantee___(grantee_, method_, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE);
      ELSE
         Dbms_Output.Put_Line('INFOGRANTEE: '|| method_ || ': The grantee "'||grantee_||'" is not a privileged user or a role in this release.');
   END CASE;
END Grant_Privileged_Grantee;


@UncheckedAccess
PROCEDURE Grant_Ifssys (
   show_info_ IN BOOLEAN  DEFAULT FALSE )
IS
   grantee_ VARCHAR2(30) := 'IFSSYS';
   method_  VARCHAR2(30) := 'Grant_Ifssys';
   stmt_    VARCHAR2(200);
--
   not_user_or_role   EXCEPTION;
   PRAGMA             EXCEPTION_INIT(not_user_or_role, -1917);
   CURSOR get_packages IS
   SELECT object_name
   FROM user_objects
   WHERE  object_type = 'PACKAGE'
   AND    (  object_name LIKE '%_SVC'
          OR object_name LIKE '%_SCH')
   MINUS
   SELECT table_name object_name
   FROM user_tab_privs_made
   WHERE privilege = 'EXECUTE'
   AND grantee = grantee_
   AND    (  table_name LIKE '%_SVC'
          OR table_name LIKE '%_SCH');

BEGIN
   IF Verify_User_Role___(grantee_) = FALSE THEN
      RAISE not_user_or_role;
   END IF;

   stmt_ := 'GRANT DEBUG ANY PROCEDURE  TO ' || grantee_;
   Run_Ddl_Command___(stmt_, method_, show_info_);
   Run_Ddl_Command___('GRANT SELECT, INSERT, UPDATE, DELETE ON SECURITY_SYS_REFRESH_USER_TAB TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON FNDCN_MESSAGE_SEQ TO '||grantee_, method_, show_info_, FALSE);
   -- Begin: objects required for monitoring
   Run_Ddl_Command___('GRANT SELECT ON BATCH_SCHEDULE_TAB TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON BATCH_SCHEDULE_METHOD_TAB TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON BATCH_QUEUE TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$INSTANCE TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$SYSSTAT TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$PROCESS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$SGA TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$SGA_DYNAMIC_COMPONENTS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$SQL TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.V_$SQL_BIND_CAPTURE TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$LOCKED_OBJECT TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.GV_$PARAMETER2 TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_OBJECTS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_DATA_FILES TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_SCHEDULER_JOBS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_FREE_SPACE TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_SEGMENTS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.DBA_TRIGGERS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.V_$BGPROCESS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON SYS.AUDIT_ACTIONS TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT EXECUTE ON SYS.DBMS_HM TO '||grantee_, method_, show_info_, FALSE);
   -- End: objects required for monitoring   
   -- Begin: permissions required for oracle aq jms
   Run_Ddl_Command___('GRANT AQ_USER_ROLE TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT AQ_ADMINISTRATOR_ROLE TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT EXECUTE ON DBMS_AQ TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT EXECUTE ON DBMS_AQADM TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT EXECUTE ON DBMS_AQIN TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT EXECUTE ON DBMS_AQJMS TO '||grantee_, method_, show_info_, FALSE);
   BEGIN
      dbms_aqadm.grant_system_privilege('DEQUEUE_ANY', grantee_, FALSE);
      dbms_aqadm.grant_system_privilege('ENQUEUE_ANY', grantee_, FALSE);
      dbms_aqadm.grant_system_privilege('MANAGE_ANY',  grantee_, FALSE);  --> required to create JMS connection to Oracle AQ topic
   EXCEPTION
      WHEN OTHERS THEN
         dbms_output.put_line('ERROR: '||SQLERRM);
   END;
   -- End: permissions required for oracle aq jms
   --
   -- IFS Monitoring BEGIN
   Run_Ddl_Command___('GRANT SELECT ON GV$SESSION TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON GV$LOCK TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON GV$TRANSACTION TO '||grantee_, method_, show_info_, FALSE);
   Run_Ddl_Command___('GRANT SELECT ON GV$SQLAREA TO '||grantee_, method_, show_info_, FALSE);
   -- END IFS Monitoring
   Grant_Privileged_Grantee___(grantee_, method_, TRUE, TRUE, TRUE, TRUE, TRUE, FALSE, TRUE, TRUE);
   --
   -- Grant Uxx Packages
   --
   FOR rec_ IN get_packages LOOP
      Run_Ddl_Command___('GRANT EXECUTE ON '||rec_.object_name||' TO '||grantee_, method_, show_info_, FALSE);
   END LOOP;
EXCEPTION
   WHEN not_user_or_role THEN
      Dbms_Output.Put_Line('INFO! '||method_ || ': The grantee "'||grantee_||'" is not installed in this installation.');
END Grant_Ifssys;



@UncheckedAccess
FUNCTION Index_Exist (
   index_name_  IN VARCHAR2,
   table_name_  IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;  
   CURSOR check_index IS
      SELECT  1
      FROM    user_indexes
      WHERE   index_name = UPPER(index_name_)
      AND     table_name = NVL(UPPER(table_name_), table_name);
BEGIN
   OPEN  check_index;
   FETCH check_index INTO dummy_;
   IF (check_index%FOUND) THEN
      CLOSE check_index;
      RETURN TRUE;
   ELSE
      CLOSE check_index;
      RETURN FALSE;
   END IF;
END Index_Exist;



@UncheckedAccess
FUNCTION Is_Option_Available (
   option_ IN  VARCHAR2 ) RETURN BOOLEAN
IS
   CURSOR get_option IS
   SELECT value
     FROM v$option
    WHERE parameter = option_;

   value_   VARCHAR2(10);
BEGIN
   OPEN  get_option;
   FETCH get_option INTO value_;
   CLOSE get_option;
   IF (value_ = 'TRUE') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Option_Available;

@UncheckedAccess
FUNCTION Is_Rowmovement_Enabled (
   table_name_   IN VARCHAR2 ) RETURN BOOLEAN
IS
      CURSOR get_tab IS
   SELECT row_movement 
   FROM user_tables
   WHERE table_name = table_name_;
BEGIN
   FOR rec IN get_tab LOOP 
      CASE (rec.row_movement)
      WHEN 'ENABLED' THEN
         RETURN(TRUE);
      ELSE
         RETURN(FALSE);
      END CASE;
   END LOOP;
END Is_Rowmovement_Enabled;

@UncheckedAccess
FUNCTION Is_Table_Iot (
   table_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR is_iot_table IS
      SELECT 1
      FROM user_tables
      WHERE table_name = table_name_
      AND   iot_type = 'IOT';
BEGIN
   OPEN  is_iot_table;
   FETCH is_iot_table INTO dummy_;
   IF (is_iot_table%FOUND) THEN
      CLOSE is_iot_table;
      RETURN TRUE;
   ELSE
      CLOSE is_iot_table;
      RETURN FALSE;
   END IF;
END Is_Table_Iot;

@UncheckedAccess
FUNCTION Is_Table_Temporary (
   table_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN(Is_Table_Temporary___(table_name_));
END Is_Table_Temporary;

@UncheckedAccess
FUNCTION Is_Table_Queue (
   table_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR is_queue_table IS
      SELECT 1
      FROM user_queue_tables
      WHERE queue_table = table_name_;
BEGIN
   OPEN  is_queue_table;
   FETCH is_queue_table INTO dummy_;
   IF (is_queue_table%FOUND) THEN
      CLOSE is_queue_table;
      RETURN TRUE;
   ELSE
      CLOSE is_queue_table;
      RETURN FALSE;
   END IF;
END Is_Table_Queue;

@UncheckedAccess
FUNCTION Is_Table_Mw (
   table_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR is_mw_table IS
      SELECT 1
      FROM user_mviews
      WHERE mview_name = table_name_;
BEGIN
   OPEN  is_mw_table;
   FETCH is_mw_table INTO dummy_;
   IF (is_mw_table%FOUND) THEN
      CLOSE is_mw_table;
      RETURN TRUE;
   ELSE
      CLOSE is_mw_table;
      RETURN FALSE;
   END IF;
END Is_Table_Mw;

@UncheckedAccess
PROCEDURE Log_Detail_Time_Stamp (
   module_        IN VARCHAR2,
   type_          IN VARCHAR2,
   what_          IN VARCHAR2 )
IS
   time_          CONSTANT NUMBER        := To_Number(To_Char(localtimestamp, 'J'))*86400 + To_Number(To_Char(localtimestamp, 'SSSSSxFF9'));
   relative_time_ VARCHAR2(100);
   sys_date_      VARCHAR2(100);         --:= to_char(sysdate_, 'YYYY-MM-DD HH24:MI:SS');
   log_id_        NUMBER;
BEGIN
   -- Get date format from environment
   SELECT To_Char(SYSDATE, value || ' HH24:MI:SS')
     INTO sys_date_
     FROM nls_session_parameters
    WHERE parameter = 'NLS_DATE_FORMAT';
   --
   CASE time_ - Installation_SYS.detail_time_
      WHEN 0 THEN
         relative_time_ := Lpad(to_char(0, '0D999'), 12);
      ELSE
         relative_time_ := Lpad(to_char(time_ - Installation_SYS.detail_time_, '9999990D999'), 12);
   END CASE;
   IF Installation_SYS.log_time_stamp_ = 'TRUE' THEN
      Show_Message___(begin_mark_||
                           begin_||relative_time_||end_||
                           begin_||sys_date_||end_||
--                           begin_||time_stamp_||end_||
                           begin_||module_||end_||
                           begin_||type_||end_||
                           begin_||what_||end_||
                           end_mark_);
   END IF;
   IF Installation_SYS.gc_persistent_ = 'TRUE' THEN
      -- Logging into table in the database
      log_id_ := Persistent_Logging___ (Nvl(parent_log_id_, 0), 'Deployment detail', module_, type_, what_, relative_time_);
   END IF;
   Installation_SYS.detail_time_ := time_;
EXCEPTION
   WHEN OTHERS THEN
      Installation_SYS.detail_time_ := time_;
END Log_Detail_Time_Stamp;


@UncheckedAccess
PROCEDURE Log_Time_Stamp (
   module_        IN VARCHAR2,
   type_          IN VARCHAR2,
   what_          IN VARCHAR2 )
IS
   time_          CONSTANT NUMBER        := To_Number(To_Char(localtimestamp, 'J'))*86400 + To_Number(To_Char(localtimestamp, 'SSSSSxFF9'));
   relative_time_ VARCHAR2(100);
   sys_date_      VARCHAR2(100);         --:= to_char(sysdate_, 'YYYY-MM-DD HH24:MI:SS');
   log_id_        NUMBER;
BEGIN
   -- Get date format from environment
   SELECT To_Char(SYSDATE, value || ' HH24:MI:SS')
     INTO sys_date_
     FROM nls_session_parameters
    WHERE parameter = 'NLS_DATE_FORMAT';
   --
   CASE time_ - Installation_SYS.gc_time_
      WHEN 0 THEN
         relative_time_ := Lpad(to_char(0, '0D999'), 12);
      ELSE
         relative_time_ := Lpad(to_char(time_ - Installation_SYS.gc_time_, '9999990D999'), 12);
   END CASE;
   IF Installation_SYS.log_time_stamp_ = 'TRUE' THEN
      Show_Message___(begin_mark_||
                           begin_||relative_time_||end_||
                           begin_||sys_date_||end_||
--                           begin_||time_stamp_||end_||
                           begin_||module_||end_||
                           begin_||type_||end_||
                           begin_||what_||end_||
                           end_mark_);
   END IF;
   IF Installation_SYS.gc_persistent_ = 'TRUE' THEN
      -- Logging into table in the database
      log_id_ := Persistent_Logging___ (Nvl(parent_log_id_, 0), 'Deployment', module_, type_, what_, relative_time_);
   END IF;
   Installation_SYS.gc_time_ := time_;
EXCEPTION
   WHEN OTHERS THEN
      Installation_SYS.gc_time_ := time_;
END Log_Time_Stamp;


@UncheckedAccess
PROCEDURE Log_Time_Stamp_Setup (
   logging_    IN VARCHAR2 DEFAULT 'FALSE',
   persistent_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   wrong_value EXCEPTION;
BEGIN
   Installation_SYS.gc_time_        := To_Number(To_Char(localtimestamp, 'J'))*86400 + To_Number(To_Char(localtimestamp, 'SSSSSxFF9'));
   Installation_SYS.detail_time_    := To_Number(To_Char(localtimestamp, 'J'))*86400 + To_Number(To_Char(localtimestamp, 'SSSSSxFF9'));
   Installation_SYS.log_time_stamp_ := logging_;
   Installation_SYS.gc_persistent_  := persistent_;
   CASE logging_
      WHEN 'TRUE' THEN
         Dbms_Output.Enable(NULL);
      WHEN 'FALSE' THEN
         Dbms_Output.Disable;
      ELSE
         RAISE wrong_value;
   END CASE;
   CASE persistent_
      WHEN 'FALSE' THEN
         NULL;
      WHEN 'TRUE'  THEN
         IF parent_log_id_ IS NULL THEN
            parent_log_id_ := Persistent_Logging___ (NULL, 'Deployment', 'IFS Applications deployment', '', 'Started', NULL);
         END IF;
      ELSE
         RAISE wrong_value;
   END CASE;
   IF parent_log_id_ IS NULL THEN
      parent_log_id_ := 0;
   END IF;
EXCEPTION
   WHEN wrong_value THEN
      -- If not TRUE or FALSE, disable logging
      Dbms_Output.Enable;
      Show_Message___('Persistent must be TRUE or FALSE, logging disabled');
      Dbms_Output.Disable;
      Installation_SYS.log_time_stamp_ := 'FALSE';
      Installation_SYS.gc_persistent_  := 'FALSE';
      parent_log_id_ := 0;
   WHEN OTHERS THEN
      Installation_SYS.log_time_stamp_ := logging_;
      Installation_SYS.gc_persistent_  := persistent_;
      parent_log_id_ := 0;
END Log_Time_Stamp_Setup;

@UncheckedAccess
FUNCTION Object_Exist (
   object_name_  IN VARCHAR2,
   object_type_  IN VARCHAR2,
   status_       IN VARCHAR2 DEFAULT NULL ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_object IS
      SELECT   1
      FROM     user_objects
      WHERE    object_name IN (UPPER(object_name_), object_name_)  -- Names of Java classes are not stored in upper case 
      AND      object_type = UPPER(object_type_)
      AND      status = nvl(status_, status);
BEGIN
   OPEN  check_object;
   FETCH check_object INTO dummy_;
   IF (check_object%FOUND) THEN
      CLOSE check_object;
      RETURN TRUE;
   ELSE
      CLOSE check_object;
      RETURN FALSE;
   END IF;
END Object_Exist;



PROCEDURE List_Post_Installation_Mthds (
   method_ IN VARCHAR2 )
IS   
   stmt_   VARCHAR2(32000) := '
DECLARE
   TYPE module_array IS TABLE OF VARCHAR2(20) INDEX BY VARCHAR2(30);
   all_modules_   module_array;
   TYPE ProcedureRec IS RECORD (
        object_name    VARCHAR2(128),
        procedure_name VARCHAR2(260),
        module         VARCHAR2(20));
   TYPE ProcedureType IS TABLE OF ProcedureRec INDEX BY BINARY_INTEGER;
   proc_array_    ProcedureType;
   i_             NUMBER;
   method_        VARCHAR2(130) := :method;
   full_method_   VARCHAR2(260);
   more_          BOOLEAN;
   dummy_         NUMBER;
   default_state_ VARCHAR2(10);
   ok_to_go_      BOOLEAN;
   found_ BOOLEAN := FALSE;
   CURSOR get_procedures IS
      SELECT 1 sort_order,
             up.object_name,
             INITCAP(SUBSTR(up.object_name, 1, LENGTH(up.object_name)-4)) || SUBSTR(up.object_name, -4) || ''.'' || INITCAP(up.procedure_name) procedure_name,
             m.module
      FROM   user_procedures up,
             module_tab m
      WHERE  up.procedure_name = method_
      AND    up.object_name = m.module||''_INSTALLATION_API''
      AND    NVL(m.version, ''*'') <> ''*''
      AND    m.obsolete = ''FALSE''
      UNION ALL
      SELECT 2 sort_order,
             up.object_name,
             INITCAP(SUBSTR(up.object_name, 1, LENGTH(up.object_name)-4)) || SUBSTR(up.object_name, -4) || ''.'' || INITCAP(up.procedure_name) procedure_name,
             m.module
      FROM   user_procedures up,
             user_source us,
             module_tab m
      WHERE  up.object_name <> ''INSTALLATION_SYS''
      AND    up.procedure_name = method_
      AND    up.object_name = us.name
      AND    up.object_type = us.type
      AND    us.line  BETWEEN 2 AND 20
      AND    us.text LIKE ''%module_%:=%''''%''''%''
      AND    us.text  NOT LIKE ''--%''
      AND    us.text  NOT LIKE ''%/%*%''
      AND    us.text  NOT LIKE ''%*%/''
      AND    NVL(m.version,''*'') <> ''*''
      AND    m.obsolete = ''FALSE''
      AND    SUBSTR(us.text, instr(us.text,'''''''')+1, instr(us.text,'''''''',instr(us.text,'''''''')+1)-instr(us.text,'''''''')-1) = m.module
      AND    NOT EXISTS (SELECT 1
                         FROM   module_tab m
                         WHERE  NVL(m.version, ''*'') <> ''*''
                         AND    up.object_name = m.module||''_INSTALLATION_API'')
      ORDER BY 4, 1, 2;
   CURSOR get_all_components IS
      SELECT module
      FROM module_tab
      WHERE NVL(VERSION, ''*'') != ''*''
      AND    OBSOLETE = ''FALSE''
      ORDER BY 1;
   CURSOR get_dependencies (module_ VARCHAR2) IS
      SELECT dependent_module
      FROM module_dependency_tab md
      WHERE module = module_
      AND dependency = ''STATIC'';
   FUNCTION Do_Execute_Module (
      module_ IN VARCHAR2,
      method_ IN VARCHAR2 ) RETURN BOOLEAN
   IS
      dummy_ NUMBER;
      CURSOR check_module IS
         SELECT 1
         FROM module_tab
         WHERE module = module_
         AND included_in_delivery = ''TRUE''
         UNION
         SELECT 1
         FROM module_tab m, module_dependency_tab md
         WHERE md.module = module_
         AND md.dependency = ''DYNAMIC''
         AND m.module = md.dependent_module
         AND m.interface_change = ''TRUE'';
   BEGIN
      IF Installation_SYS.Get_Installation_Mode THEN
         OPEN check_module;
         FETCH check_module INTO dummy_;
         IF check_module%FOUND THEN
            CLOSE check_module;
            RETURN TRUE;
         ELSE
            CLOSE check_module;
            RETURN FALSE;
         END IF;
      ELSE
         RETURN TRUE;
      END IF;
   END Do_Execute_Module;
   PROCEDURE Do_Execute (
      module_ IN VARCHAR2,
      method_ IN VARCHAR2 )
   IS
   BEGIN
      IF Do_Execute_Module(module_, method_) THEN
         found_ := FALSE;
         FOR i IN Nvl(proc_array_.first, 0)..Nvl(proc_array_.last, 0) LOOP
            IF proc_array_(i).module = module_ THEN
               IF (found_ = FALSE) THEN --This is the first one
                  Dbms_Output.Put_Line(''-- [Component '' || INITCAP(module_) || '']'');
                  Dbms_Output.Put_Line(''SPOOL '' || INITCAP(module_) || ''.log APPEND'');
                  Dbms_Output.Put_Line(''exec Installation_SYS.Log_Time_Stamp(''''''||INITCAP(module_)||'''''', ''''''||INITCAP(method_)||'''''', ''''Started'''')'');
                  Dbms_Output.Put_Line(''PROMPT Running '' || INITCAP(method_) || '' for module '' || module_);
               END IF;
               found_ := TRUE;
               Dbms_Output.Put_Line(''-- [IFS COMPLETE BLOCK BEGINEND]'');
               Dbms_Output.Put_Line(''BEGIN'');
               Dbms_Output.Put_Line(''   Dbms_Output.Put_Line(''''Start running '' || proc_array_(i).procedure_name || '' at '''' || TO_CHAR(SYSDATE,''''YYYY-MM-DD HH24:MI:SS''''));'');
               Dbms_Output.Put_Line(''   '' || proc_array_(i).procedure_name || '';'');
               Dbms_Output.Put_Line(''   COMMIT;'');
               Dbms_Output.Put_Line(''END;'');
               Dbms_Output.Put_Line(''-- [END IFS COMPLETE BLOCK]'');
               Dbms_Output.Put_Line(''/'');
            END IF;
         END LOOP;
         IF (found_) THEN
            Dbms_Output.Put_Line(''exec Installation_SYS.Log_Time_Stamp(''''''||INITCAP(module_)||'''''', ''''''||INITCAP(method_)||'''''', ''''Finished'''')'');
            Dbms_Output.Put_Line(''SPOOL OFF'');
            Dbms_Output.Put_Line(''-- [End Component]'');
         END IF;
      END IF;
   END Do_Execute;
BEGIN
   default_state_ := ''Undone'';
   BEGIN
      SELECT COUNT(*) 
      INTO dummy_
      FROM module_dependency_tab START WITH dependent_module IN
      (SELECT module FROM module_tab m
       WHERE NOT EXISTS
      (SELECT 1
       FROM module_dependency_tab
       WHERE module = m.module
       AND dependency = ''STATIC''))
      CONNECT BY PRIOR MODULE = dependent_module AND dependency = ''STATIC'';
   EXCEPTION
      WHEN others THEN
         DBMS_Output.Put_Line(''Infinite dependency loop! Components will be deployed in alphabetic order instead.'');
         default_state_ := ''NoCheck'';
   END;
   FOR module_ IN get_all_components LOOP
      all_modules_(module_.module) := default_state_;
   END LOOP;
   i_ := 0;
   FOR rec_ IN get_procedures LOOP
      proc_array_(i_).object_name := rec_.object_name;
      proc_array_(i_).procedure_name := rec_.procedure_name;
      proc_array_(i_).module := rec_.module;
      i_ := i_ + 1;
      IF rec_.module IS NULL THEN
         Dbms_Output.Put_Line(''PROMPT Failed to load component information for package '' || rec_.object_name || ''.'');
         Dbms_Output.Put_Line('' '');
      END IF;
   END LOOP;
   more_ := TRUE;
   Dbms_Output.Put_Line(''-- [ComponentSectionStart]'');
   Dbms_Output.Put_Line(''-- [Thread packed components]'');
   Dbms_Output.Put_Line('' '');
   WHILE more_ LOOP
      more_ := FALSE;
      FOR modules_ IN get_all_components LOOP
         IF all_modules_(modules_.module) != ''Done'' THEN
            ok_to_go_ := TRUE;
            FOR dependencies IN get_dependencies(modules_.module) LOOP
               BEGIN
                  IF all_modules_(dependencies.dependent_module) = ''Undone'' THEN
                     ok_to_go_ := FALSE;
                  END IF;
               EXCEPTION
                  WHEN no_data_found THEN
                     NULL;
               END;
            END LOOP;
            IF ok_to_go_ THEN
               Do_Execute(modules_.module, method_);
               all_modules_(modules_.module) := ''Done'';
            END IF;
            more_ := TRUE;
         END IF;
      END LOOP;
   END LOOP;
   Dbms_Output.Put_Line('' '');
   Dbms_Output.Put_Line(''-- [End thread]'');
   Dbms_Output.Put_Line(''-- [ComponentSectionStop]'');
   
   found_ := FALSE;
   FOR i IN Nvl(proc_array_.first, 0)..Nvl(proc_array_.last, 0) Loop
      IF proc_array_(i).module IS NULL THEN
         IF (found_ = FALSE) THEN --This is the first one
            Dbms_Output.Put_Line('''');
            Dbms_Output.Put_Line(''PROMPT Running '' || INITCAP(method_) || '' for packages without a module '');
         END IF;
         found_ := TRUE;
         Dbms_Output.Put_Line(''-- [IFS COMPLETE BLOCK BEGINEND]'');
         Dbms_Output.Put_Line(''BEGIN'');
         Dbms_Output.Put_Line(''   Dbms_Output.Put_Line(''''Start running '' || proc_array_(i).procedure_name || '' at '''' || TO_CHAR(SYSDATE,''''YYYY-MM-DD HH24:MI:SS''''));'');
         Dbms_Output.Put_Line(''   '' || proc_array_(i).procedure_name || '';'');
         Dbms_Output.Put_Line(''   COMMIT;'');
         Dbms_Output.Put_Line(''END;'');
         Dbms_Output.Put_Line(''-- [END IFS COMPLETE BLOCK]'');
         Dbms_Output.Put_Line(''/'');
      END IF;
   END LOOP;
END;';
BEGIN
   @ApproveDynamicStatement(2017-09-27,mabose)
   EXECUTE IMMEDIATE stmt_ USING method_;
END List_Post_Installation_Mthds;


@UncheckedAccess
PROCEDURE Pre_Register (
   module_         IN VARCHAR2,
   name_           IN VARCHAR2,
   db_in_delivery_ IN VARCHAR2 DEFAULT 'TRUE',
   interf_change_  IN VARCHAR2 DEFAULT 'TRUE' )
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   DELETE FROM module_dependency_tab
   WHERE module = :module;
   INSERT
      INTO module_tab (
         module,
         name,
         version,
         included_in_delivery,
         interface_change,
         timestamp,
         rowversion )
      VALUES (
         :module,
         :name,
         ''?'',
         :db_in_delivery,
         :interf_change,
         :sysdate,
         :sysdate );
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      UPDATE module_tab SET included_in_delivery = :db_in_delivery, interface_change = :interf_change, version = DECODE(version, NULL, ''?'', version) WHERE module = :module;
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2006-12-27,haarse)
   EXECUTE IMMEDIATE stmt_ USING module_, name_, db_in_delivery_, interf_change_, sysdate;
END Pre_Register;


@UncheckedAccess
PROCEDURE Register_Dependency (
   module_             IN VARCHAR2,
   dependent_module_   IN VARCHAR2,
   dependency_         IN VARCHAR2 )
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   INSERT
      INTO module_dependency_tab (
         module,
         dependent_module,
         dependency,
         rowversion)
      VALUES (
         :module_,
         :dependent_module_,
         :dependency_,
         sysdate);
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      NULL;
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2010-05-12,haarse)
   EXECUTE IMMEDIATE stmt_ USING module_, dependent_module_, dependency_;
END Register_Dependency;

@UncheckedAccess
PROCEDURE Activate_Component (
   module_ IN VARCHAR2,
   active_ IN VARCHAR2 DEFAULT 'TRUE')
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   UPDATE MODULE_TAB
      SET active = :active_,
          included_in_delivery = ''TRUE'',
          interface_change = ''TRUE''
   WHERE module = :module_;
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2020-09-01,stdafi)
   EXECUTE IMMEDIATE stmt_ USING active_, UPPER(module_);
END Activate_Component;

@UncheckedAccess
PROCEDURE Obsolete_Component (
   module_ IN VARCHAR2,
   obsolete_ IN VARCHAR2 DEFAULT 'TRUE')
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   UPDATE MODULE_TAB
      SET obsolete = :obsolete_
   WHERE module = :module_;
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2021-02-01,chahlk)
   EXECUTE IMMEDIATE stmt_ USING obsolete_, UPPER(module_);
END Obsolete_Component;

@UncheckedAccess
PROCEDURE Clear_All_Components 
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   UPDATE MODULE_TAB
      SET active = ''FALSE'',
          included_in_delivery = ''TRUE'',
          interface_change = ''TRUE''
   WHERE  active = ''TRUE''
   AND module not in (''CONFIG'');
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2020-09-01,stdafi)
   EXECUTE IMMEDIATE stmt_;
END Clear_All_Components;

@UncheckedAccess
PROCEDURE Set_Solution_Set (
   solution_set_ IN VARCHAR2,
   description_  IN VARCHAR2)
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   DELETE FROM solution_set_tab;
   INSERT
      INTO solution_set_tab (
         solution_set,
         description )
      VALUES (
         :solution_set_,
         :description_ );
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2020-09-01,stdafi)
   EXECUTE IMMEDIATE stmt_ USING solution_set_, description_;
END Set_Solution_Set;


@UncheckedAccess
PROCEDURE Obsolete_Column (
   module_      IN VARCHAR2,
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   show_info_   IN BOOLEAN DEFAULT FALSE,
   force_drop_  IN BOOLEAN DEFAULT FALSE )
IS
   upper_table_name_   VARCHAR2(200) := UPPER(table_name_);
   upper_column_name_  VARCHAR2(200) := UPPER(column_name_);
   target_column_name_ VARCHAR2(200) := UPPER(column_name_);
   column_             ColRec;
   dummy_              NUMBER;
   CURSOR get_grants IS
      SELECT DISTINCT grantee
      FROM user_tab_privs_made
      WHERE table_name = upper_table_name_;
BEGIN
   IF (Column_Exist(upper_table_name_, upper_column_name_)) THEN
      IF force_drop_ THEN
         Reset_Column(column_);
         column_ := Set_Column_Values(upper_column_name_, NULL, 'Y');
         Alter_Table_Column___('Obsolete_Column', upper_table_name_, 'DROP', column_, show_info_);
         @ApproveDynamicStatement(2021-09-10,MABOSE)
         EXECUTE IMMEDIATE 'BEGIN :dummy_ := Server_Log_API.Log(NULL, ''Obsolete object'', ''Force drop of obsolete column ''||:upper_table_name_||''.''||:upper_column_name_||'' from component ''||:module1_, :module2_); END;' USING OUT dummy_, upper_table_name_, upper_column_name_, module_, module_;
      ELSE
         IF Get_Column_Nullable(upper_table_name_, upper_column_name_) = 'N' THEN
            Reset_Column(column_);
            IF Get_Default_Value(upper_table_name_, upper_column_name_) IS NOT NULL THEN
               column_ := Set_Column_Values(upper_column_name_, NULL, 'Y', '$DEFAULT_NULL$');
            ELSE
               column_ := Set_Column_Values(upper_column_name_, NULL, 'Y');
            END IF;
            Alter_Table_Column___('Obsolete_Column', upper_table_name_, 'MODIFY', column_, show_info_);
         END IF;
         target_column_name_ := 'OBSOLETE_COLUMN_'||upper_column_name_;
         Rename_Column(upper_table_name_, target_column_name_, upper_column_name_, show_info_);
         @ApproveDynamicStatement(2021-07-22,MABOSE)
         EXECUTE IMMEDIATE 'BEGIN :dummy_ := Server_Log_API.Log(NULL, ''Obsolete object'', ''Obsoleting column ''||:upper_table_name_||''.''||:upper_column_name_||'' by renaming it to ''||:target_column_name_, :module_); END;' USING OUT dummy_, upper_table_name_, upper_column_name_, target_column_name_, module_;
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Obsolete_Table: Table ' || table_name_ || ' does not exist.');
      END IF;
   END IF;
END Obsolete_Column;

@UncheckedAccess
PROCEDURE Obsolete_Table (
   module_     IN VARCHAR2,
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN DEFAULT FALSE,
   force_drop_ IN BOOLEAN DEFAULT FALSE )
IS
   upper_table_name_ VARCHAR2(200) := UPPER(table_name_);
   target_table_ VARCHAR2(200);
   dummy_        NUMBER;
   CURSOR get_grants IS
      SELECT DISTINCT grantee
      FROM user_tab_privs_made
      WHERE table_name = upper_table_name_;
BEGIN
   IF (Table_Exist(upper_table_name_)) THEN
      IF force_drop_ THEN
         Remove_Table(upper_table_name_, show_info_ => show_info_);
         @ApproveDynamicStatement(2021-09-10,MABOSE)
         EXECUTE IMMEDIATE 'BEGIN :dummy_ := Server_Log_API.Log(NULL, ''Obsolete object'', ''Force drop of obsolete table ''||:upper_table_name_||'' from component ''||:module1_, :module2_); END;' USING OUT dummy_, upper_table_name_, module_, module_;
      ELSE
         @ApproveDynamicStatement(2021-09-10,MABOSE)
         EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM '||upper_table_name_||' WHERE ROWNUM < 2 ' INTO dummy_;
         IF dummy_ < 1 THEN
            Remove_Table(upper_table_name_, show_info_ => show_info_);
            @ApproveDynamicStatement(2021-09-10,MABOSE)
            EXECUTE IMMEDIATE 'BEGIN :dummy_ := Server_Log_API.Log(NULL, ''Obsolete object'', ''Dropping empty obsolete table ''||:upper_table_name_||'' from component ''||:module1_, :module2_); END;' USING OUT dummy_, upper_table_name_, module_, module_;
         ELSE 
            Remove_Constraints___('Obsolete_Table', upper_table_name_, show_info_ => show_info_);
            Remove_Indexes___('Obsolete_Table', upper_table_name_, show_info_ => show_info_);
            Remove_Triggers___('Obsolete_Table', upper_table_name_, show_info_ => show_info_);
            FOR rec_ IN get_grants LOOP
               Run_Ddl_Command___('REVOKE ALL PRIVILEGES ON '||upper_table_name_||' FROM '||rec_.grantee, 'Obsolete_Table', FALSE);
            END LOOP;
            IF SUBSTR(upper_table_name_, -4) = '_TAB' THEN
               target_table_ := SUBSTR(upper_table_name_, 1, LENGTH(upper_table_name_) - 4);
            ELSE
               target_table_ := upper_table_name_;
            END IF;
            target_table_ := 'OBSOLETE_'||target_table_||'_'||module_;
            Rename_Table(upper_table_name_, target_table_, show_info_);
            @ApproveDynamicStatement(2021-07-22,MABOSE)
            EXECUTE IMMEDIATE 'BEGIN :dummy_ := Server_Log_API.Log(NULL, ''Obsolete object'', ''Obsoleting table ''||:upper_table_name_||'' by renaming it to ''||:target_table_, :module_); END;' USING OUT dummy_, upper_table_name_, target_table_, module_;
         END IF;
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Obsolete_Table: Table ' || table_name_ || ' does not exist.');
      END IF;
   END IF;
END Obsolete_Table;

@UncheckedAccess
PROCEDURE Rebuild_Index (
   index_name_       IN VARCHAR2,
   show_info_        IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   Rebuild_Index___('REBUILD_INDEX', index_name_, show_info_);
END Rebuild_Index;

@UncheckedAccess
PROCEDURE Remove_All_Cons_And_Idx (
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Remove_Constraints___('Remove_All_Cons_And_Idx', table_name_, '%', show_info_);
   Remove_Indexes___('Remove_All_Cons_And_Idx', table_name_, '%', show_info_);
END Remove_All_Cons_And_Idx;


@UncheckedAccess
PROCEDURE Remove_Constraints(
   table_name_      IN VARCHAR2,
   constraint_name_ IN VARCHAR2 DEFAULT '%',
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   Remove_Constraints___('Remove_Constraints', table_name_, constraint_name_, show_info_);
END Remove_Constraints;


@UncheckedAccess
PROCEDURE Remove_Context(
   context_name_    IN VARCHAR2,
   show_info_       IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   Remove_Context___('Remove_Context', context_name_, show_info_);
END Remove_Context;


@UncheckedAccess
PROCEDURE Remove_Indexes (
   table_name_ IN VARCHAR2,
   index_name_ IN VARCHAR2 DEFAULT '%',
   show_info_  IN BOOLEAN  DEFAULT FALSE )
IS
BEGIN
   Remove_Indexes___('Remove_Indexes', table_name_, index_name_, show_info_);
END Remove_Indexes;


@UncheckedAccess
PROCEDURE Remove_Lob_Column (
   table_name_  IN VARCHAR2,
   column_      IN ColRec,
   show_info_   IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (column_.data_type NOT IN ('CLOB', 'BLOB')) THEN
      Show_Message___('Remove_Lob_Column error: This method can only be used for BLOB or CLOB columns.');
      RETURN;
   END IF;
   Alter_Table_Column___('Remove_Lob_Column', table_name_, 'DROP COLUMN', column_, show_info_);
END Remove_Lob_Column;


@UncheckedAccess
PROCEDURE Remove_Materialized_View (
   view_name_ IN VARCHAR2,
   show_info_ IN BOOLEAN  DEFAULT FALSE )
IS
   stmt_      VARCHAR2(200);
BEGIN
   IF (Mtrl_View_Exist ( view_name_ ) ) THEN
      stmt_ := 'DROP MATERIALIZED VIEW ' || view_name_;
      Run_Ddl_Command___(stmt_, 'Remove_Materialized_View', show_info_);

      /*
      --NOT possible to remove criteria or other related MV info from this method since it is a low
      --level method ONLY removing a specific object, nothing else. To remove related things, please
      --refer to methods in Xlr_Mv_Util_API, Xlr_Mv_Category_API, Xlr_Mv_Criteria_API
      --stmt_ := 'DELETE FROM XLR_MV_CRITERIA_TAB WHERE MV_NAME = ' || CHR(39) || view_name_ || CHR(39);
      --Run_Ddl_Command___(stmt_, 'Remove_Materialized_View_Parameters', show_info_);
      */

      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Materialized_View: Materialized View ' || view_name_ || ' dropped.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Materialized_View: Materialized View ' || view_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Materialized_View;


@UncheckedAccess
PROCEDURE Remove_Materialized_View_Log (
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_      VARCHAR2(200);
BEGIN
   IF (Mtrl_View_Log_Exist ( table_name_ ) ) THEN
      stmnt_ := 'DROP MATERIALIZED VIEW LOG ON ' || table_name_;
      Run_Ddl_Command___(stmnt_, 'Remove_Materialized_View', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Materialized_View_Log: Materialized View Log on ' || table_name_ || ' dropped.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Materialized_View_Log: Materialized View Log on ' || table_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Materialized_View_Log;


@UncheckedAccess
PROCEDURE Remove_Package (
   package_name_   IN VARCHAR2,
   show_info_      IN BOOLEAN DEFAULT FALSE,
   remove_context_ IN BOOLEAN DEFAULT TRUE )
IS
   stmnt_     VARCHAR2(200);
   app_owner_ VARCHAR2(200);
   CURSOR find_contexts (pkg_name_ VARCHAR2 )IS
      SELECT namespace context_name
      FROM dba_context
      WHERE schema = app_owner_
      AND ((package = pkg_name_)
      OR   (package = 'DOMAIN_SYS'
        AND SUBSTR(pkg_name_, -4) = '_API'
        AND namespace = REPLACE(SUBSTR(pkg_name_, 1, LENGTH(pkg_name_)-4), '_', '')||'_CTX')
      OR   (package = 'CUSTOM_FIELDS_SYS'
        AND SUBSTR(pkg_name_, -4) = '_CFP'
        AND namespace = REPLACE(SUBSTR(pkg_name_, 1, LENGTH(pkg_name_)-4), '_', '')||'_CTX'));
BEGIN
   IF (Object_Exist ( package_name_, 'PACKAGE')) THEN
      stmnt_ := 'DROP PACKAGE ' || package_name_;
      Run_Ddl_Command___(stmnt_, 'Remove_Package', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Package: Package ' || package_name_ || ' dropped.');
      END IF;
      IF remove_context_ THEN
         BEGIN
            @ApproveDynamicStatement(2020-01-10,mabose)
            EXECUTE IMMEDIATE 'BEGIN :app_owner_ := Fnd_Session_API.Get_App_Owner; END;' USING OUT app_owner_;
         EXCEPTION
            WHEN OTHERS THEN
               app_owner_ := NULL;
         END;
         IF app_owner_ IS NOT NULL THEN
            FOR context_rec_ IN find_contexts(UPPER(package_name_)) LOOP
               Remove_Context___('Remove_Package', context_rec_.context_name, show_info_);
            END LOOP;
         END IF;
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Package: Package ' || package_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Package;

@UncheckedAccess
PROCEDURE Remove_Sequence (
   sequence_name_ IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_ VARCHAR2(200);
BEGIN
   IF (Object_Exist (sequence_name_, 'SEQUENCE')) THEN
      stmnt_ := 'DROP SEQUENCE ' || sequence_name_;
      Run_Ddl_Command___(stmnt_, 'Remove_Sequence', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Sequence: Sequence ' || sequence_name_ || ' dropped.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Sequence: Sequence ' || sequence_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Sequence;

@UncheckedAccess
PROCEDURE Remove_Synonym (
   synonym_name_ IN VARCHAR2,
   show_info_    IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_ VARCHAR2(200);
BEGIN
   IF (Object_Exist ( synonym_name_, 'SYNONYM' ) ) THEN
      stmnt_ := 'DROP SYNONYM ' || synonym_name_;
      Run_Ddl_Command___(stmnt_, 'Remove_Synonym', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Synonym: Synonym  ' || synonym_name_ || ' dropped.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Synonym: Synonym ' || synonym_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Synonym;


@UncheckedAccess
PROCEDURE Remove_Table (
   table_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN DEFAULT FALSE,
   purge_      IN BOOLEAN DEFAULT FALSE )
IS
   stmnt_ VARCHAR2(200);
BEGIN
   IF (Table_Exist ( table_name_ ) ) THEN
      stmnt_ := 'DROP TABLE ' || table_name_ || ' CASCADE CONSTRAINTS';
      IF purge_ THEN
         stmnt_ := stmnt_ || ' PURGE';
      END IF;
      Run_Ddl_Command___(stmnt_, 'Remove_Table', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Table: Table ' || table_name_ || ' dropped with cascade constraints.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Table: Table ' || table_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Table;


@UncheckedAccess
PROCEDURE Remove_Type (
   type_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_ VARCHAR2(200);
BEGIN
   IF (Type_Exist ( type_name_ ) ) THEN
      stmnt_ := 'DROP TYPE ' || type_name_ || ' FORCE';
      Run_Ddl_Command___(stmnt_, 'Remove_Type', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Type: Type ' || type_name_ || ' dropped.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Type: Type ' || type_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Type;


@UncheckedAccess
PROCEDURE Remove_Trigger (
   trigger_name_  IN VARCHAR2,
   show_info_     IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_ VARCHAR2(200);
BEGIN
   IF (Trigger_Exist ( trigger_name_ ) ) THEN
      stmnt_ := 'DROP TRIGGER ' || trigger_name_;
      Run_Ddl_Command___(stmnt_, 'Remove_Trigger', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Trigger: Trigger ' || trigger_name_ || ' dropped.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_Trigger: Trigger ' || trigger_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_Trigger;


@UncheckedAccess
PROCEDURE Remove_View (
   view_name_ IN VARCHAR2,
   show_info_ IN BOOLEAN  DEFAULT FALSE )
IS
   stmnt_ VARCHAR2(200);
BEGIN
   IF (View_Exist ( view_name_ ) ) THEN
      stmnt_ := 'DROP VIEW ' || view_name_;
      Run_Ddl_Command___(stmnt_, 'Remove_View', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_View: View ' || view_name_ || ' dropped.');
      END IF;
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Remove_View: View ' || view_name_ || ' does not exist.');
      END IF;
   END IF;
END Remove_View;


@UncheckedAccess
PROCEDURE Rename_Column (
   table_name_       IN VARCHAR2,
   new_column_name_  IN VARCHAR2,
   old_column_name_  IN VARCHAR2,
   show_info_        IN BOOLEAN  DEFAULT FALSE,
   exception_        IN BOOLEAN  DEFAULT TRUE )
IS
   stmnt_            VARCHAR2(500);
   old_exists_       BOOLEAN := Column_Exist(table_name_, old_column_name_);
   new_exists_       BOOLEAN := Column_Exist(table_name_, new_column_name_);
BEGIN
   IF (NOT old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Column: Column ' || old_column_name_ || ' in Table ' || table_name_ || ' is already renamed to ' || new_column_name_ || '.');
      END IF;
   ELSIF (old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Column: Column ' || new_column_name_ || ' already exist.');
      END IF;
      IF exception_ THEN
         Raise_Application_Error(-20105, 'Rename_Column: Column ' || new_column_name_ || ' already exist.');
      END IF;
   ELSIF (NOT old_exists_ AND NOT new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Column: Column ' || old_column_name_ || ' does not exist.');
      END IF;
   ELSE
      Remove_Extended_Stats___(table_name_, old_column_name_);
      stmnt_ := 'ALTER TABLE ' || table_name_ || ' RENAME COLUMN ' || old_column_name_ || ' TO ' || new_column_name_;
      Run_Ddl_Command___(stmnt_, 'Rename_Column', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Column: Column ' || old_column_name_ || ' in Table ' || table_name_ || ' renamed to ' || new_column_name_ || '.');
      END IF;
   END IF;
END Rename_Column;


@UncheckedAccess
PROCEDURE Rename_Table (
   source_table_       IN VARCHAR2,
   target_table_       IN VARCHAR2,
   show_info_          IN BOOLEAN DEFAULT FALSE,
   exception_          IN BOOLEAN DEFAULT TRUE,
   remove_indexes_     IN BOOLEAN DEFAULT TRUE,
   remove_constraints_ IN BOOLEAN DEFAULT TRUE,
   remove_triggers_    IN BOOLEAN DEFAULT TRUE )
IS
   stmnt_            VARCHAR2(400);
   old_exists_       BOOLEAN := Table_Exist(source_table_);
   new_exists_       BOOLEAN := Table_Exist(target_table_);
BEGIN
   IF (NOT old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Table: Table ' || source_table_ || ' is already renamed to ' || target_table_ || '.');
      END IF;
   ELSIF (old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Table: Target table ' || target_table_ || ' already exist.');
      END IF;
      IF exception_ THEN
         Raise_Application_Error(-20105, 'Rename_Table: Target table ' || target_table_ || ' already exist.');
      END IF;
   ELSIF (NOT old_exists_ AND NOT new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Table: Source table ' || source_table_ || ' does not exist.');
      END IF;
   ELSE
      -- Remove constraints, indexes, and triggers related to the source table if wanted
      IF remove_constraints_ THEN
         Remove_Constraints___('Rename_Table', source_table_, '%', show_info_);
      END IF;
      IF remove_indexes_ THEN
         Remove_Indexes___('Rename_Table', source_table_, '%', show_info_);
      END IF;
      IF remove_triggers_ THEN
         Remove_Triggers___('Rename_Table', source_table_, '%', show_info_);
      END IF;
      stmnt_ := 'RENAME ' || source_table_ || ' TO ' || target_table_;
      Run_Ddl_Command___(stmnt_, 'Rename_Table', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Table: Table ' || source_table_ || ' renamed to ' || target_table_ || '.');
      END IF;
   END IF;
END Rename_Table;

PROCEDURE Rename_Sequence (
   source_sequence_    IN VARCHAR2,
   target_sequence_    IN VARCHAR2,
   show_info_          IN BOOLEAN  DEFAULT FALSE,
   exception_          IN BOOLEAN  DEFAULT TRUE )
IS
   stmnt_            VARCHAR2(400);
   old_exists_       BOOLEAN := Sequence_Exist(source_sequence_);
   new_exists_       BOOLEAN := Sequence_Exist(target_sequence_);
BEGIN
   IF (NOT old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Sequence: Sequence ' || source_sequence_ || ' is already renamed to ' || target_sequence_ || '.');
      END IF;
   ELSIF (old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Sequence: Target sequence ' || target_sequence_ || ' already exist.');
      END IF;
      IF exception_ THEN
         Raise_Application_Error(-20105, 'Rename_Sequence: Target sequence ' || target_sequence_ || ' already exist.');
      END IF;
   ELSIF (NOT old_exists_ AND NOT new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Sequence: Source sequence ' || source_sequence_ || ' does not exist.');
      END IF;
   ELSE
      stmnt_ := 'RENAME ' || source_sequence_ || ' TO ' || target_sequence_;
      Run_Ddl_Command___(stmnt_, 'Rename_Sequence', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Sequence: Sequence ' || source_sequence_ || ' renamed to ' || target_sequence_ || '.');
      END IF;
   END IF;
 END Rename_Sequence;

@UncheckedAccess
PROCEDURE Rename_Constraint (
   table_name_         IN VARCHAR2,
   source_constraint_  IN VARCHAR2,
   target_constraint_  IN VARCHAR2,
   show_info_          IN BOOLEAN  DEFAULT FALSE,
   exception_          IN BOOLEAN  DEFAULT TRUE )
IS
   stmnt_            VARCHAR2(600);
   old_exists_       BOOLEAN := Constraint_Exist(source_constraint_);
   new_exists_       BOOLEAN := Constraint_Exist(target_constraint_);
BEGIN
   IF (NOT Table_Exist(table_name_)) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Constraint: Table ' || table_name_ || ' does not exist.');
      END IF;
   END IF;
   IF (NOT old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Constraint: Constraint ' || source_constraint_ || ' in Table ' || table_name_ || ' is already renamed to ' || target_constraint_ || '.');
      END IF;
   ELSIF (old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Constraint: Target constraint ' || target_constraint_ || ' already exist.');
      END IF;
      IF exception_ THEN
         Raise_Application_Error(-20105, 'Rename_Constraint: Target constraint ' || target_constraint_ || ' already exist.');
      END IF;
   ELSIF (NOT old_exists_ AND NOT new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Constraint: Source constraint ' || source_constraint_ || ' does not exist.');
      END IF;
   ELSE
      IF Index_Exist(source_constraint_, table_name_) THEN
         Rename_Index(source_constraint_, target_constraint_, show_info_, exception_);
      END IF;
      stmnt_ := 'ALTER TABLE ' || table_name_ || ' RENAME CONSTRAINT ' || source_constraint_ || ' TO ' || target_constraint_;
      Run_Ddl_Command___(stmnt_, 'Rename_Constraint', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Constraint: Constraint ' || source_constraint_ || ' renamed to ' || target_constraint_ || '.');
      END IF;
   END IF;
END Rename_Constraint;


@UncheckedAccess
PROCEDURE Rename_Index (
   source_index_       IN VARCHAR2,
   target_index_       IN VARCHAR2,
   show_info_          IN BOOLEAN  DEFAULT FALSE,
   exception_          IN BOOLEAN  DEFAULT TRUE )
IS
   stmnt_            VARCHAR2(400);
   old_exists_       BOOLEAN := Index_Exist(source_index_);
   new_exists_       BOOLEAN := Index_Exist(target_index_);
BEGIN
   IF (NOT old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Index: Index ' || source_index_ || ' is already renamed to ' || target_index_ || '.');
      END IF;
   ELSIF (old_exists_ AND new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Index: Target index ' || target_index_ || ' already exist.');
      END IF;
      IF exception_ THEN
         Raise_Application_Error(-20105, 'Rename_Index: Target index ' || target_index_ || ' already exist.');
      END IF;
   ELSIF (NOT old_exists_ AND NOT new_exists_) THEN
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Index: Source index ' || source_index_ || ' does not exist.');
      END IF;
   ELSE
      stmnt_ := 'ALTER INDEX ' || source_index_ || ' RENAME TO ' || target_index_;
      Run_Ddl_Command___(stmnt_, 'Rename_Index', show_info_);
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Rename_Index: Index ' || source_index_ || ' renamed to ' || target_index_ || '.');
      END IF;
   END IF;
END Rename_Index;


@UncheckedAccess
PROCEDURE Reset_Column (
   column_ IN OUT ColRec )
IS
BEGIN
   column_.table_name    := NULL;
   column_.column_name   := NULL;
   column_.data_type     := NULL;
   column_.nullable      := NULL;
   column_.default_value := NULL;
   column_.keep_default  := NULL;
END Reset_Column;


@UncheckedAccess
PROCEDURE Reset_Column_Table (
   columns_ IN OUT ColumnTabType )
IS
BEGIN
   columns_.DELETE;
END Reset_Column_Table;

@UncheckedAccess
FUNCTION Set_Column_Values (
   column_name_   IN     VARCHAR2,
   data_type_     IN     VARCHAR2 DEFAULT NULL,
   nullable_      IN     VARCHAR2 DEFAULT NULL,
   default_value_ IN     VARCHAR2 DEFAULT NULL,
   lob_parameter_ IN     VARCHAR2 DEFAULT NULL,
   keep_default_  IN     VARCHAR2 DEFAULT NULL ) RETURN ColRec
IS
   column_               Installation_SYS.ColRec;
BEGIN
   column_.column_name   := column_name_;
   column_.data_type     := data_type_;
   column_.nullable      := nullable_;
   column_.default_value := default_value_;
   column_.lob_parameter := lob_parameter_;
   column_.keep_default  := keep_default_;
   RETURN (column_);
END Set_Column_Values;


@UncheckedAccess
PROCEDURE Set_Table_Column (
   columns_ IN OUT ColumnTabType,
   column_  IN     ColRec )
IS
   col_ix_        NUMBER;
BEGIN
   col_ix_ := columns_.COUNT + 1;
   columns_(col_ix_) := column_;
END Set_Table_Column;


@UncheckedAccess
PROCEDURE Set_Table_Column (
   columns_       IN OUT ColumnTabType,
   column_name_   IN     VARCHAR2,
   data_type_     IN     VARCHAR2 DEFAULT NULL,
   nullable_      IN     VARCHAR2 DEFAULT NULL,
   default_value_ IN     VARCHAR2 DEFAULT NULL,
   lob_parameter_ IN     VARCHAR2 DEFAULT NULL,
   keep_default_  IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Installation_SYS.Set_Table_Column (columns_, Installation_SYS.Set_Column_Values(column_name_, data_type_, nullable_, default_value_, lob_parameter_, keep_default_));
END Set_Table_Column;


@UncheckedAccess
FUNCTION Set_View_Column_Values (
   column_name_    IN     VARCHAR2,
   column_source_  IN     VARCHAR2,
   column_comment_ IN     VARCHAR2 DEFAULT NULL ) RETURN ColViewRec
IS
   column_               Installation_SYS.ColViewRec;
BEGIN
   column_.column_name    := column_name_;
   column_.column_source  := column_source_;
   column_.column_comment := column_comment_;
   RETURN (column_);
END Set_View_Column_Values;


@UncheckedAccess
PROCEDURE Set_View_Column (
   columns_ IN OUT ColumnViewType,
   column_  IN     ColViewRec )
IS   
   col_ix_        NUMBER;
BEGIN
   col_ix_ := columns_.COUNT + 1;
   columns_(col_ix_) := column_;
END Set_View_Column;


@UncheckedAccess
PROCEDURE Set_View_Column (
   columns_        IN OUT ColumnViewType,
   column_name_    IN     VARCHAR2,
   column_source_  IN     VARCHAR2,
   column_comment_ IN     VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Installation_SYS.Set_View_Column (columns_, Installation_SYS.Set_View_Column_Values(column_name_, column_source_, column_comment_));
END Set_View_Column;


@UncheckedAccess
PROCEDURE Set_Show_Info (
   show_info_ IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Installation_SYS.gc_show_info_ := show_info_;
END Set_Show_Info;


@UncheckedAccess
FUNCTION Sequence_Exist (
   sequence_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_sequence IS
      SELECT  1
      FROM    user_sequences
      WHERE   sequence_name = UPPER(sequence_name_);
BEGIN
   OPEN  check_sequence;
   FETCH check_sequence INTO dummy_;
   IF (check_sequence%FOUND) THEN
      CLOSE check_sequence;
      RETURN TRUE;
   ELSE
      CLOSE check_sequence;
      RETURN FALSE;
   END IF;
END Sequence_Exist;

@UncheckedAccess
FUNCTION Table_Exist (
   table_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_table IS
      SELECT  1
      FROM    user_tables
      WHERE   table_name = UPPER(table_name_);
BEGIN
   OPEN  check_table;
   FETCH check_table INTO dummy_;
   IF (check_table%FOUND) THEN
      CLOSE check_table;
      RETURN TRUE;
   ELSE
      CLOSE check_table;
      RETURN FALSE;
   END IF;
END Table_Exist;

@UncheckedAccess
FUNCTION Table_Active (
   table_name_  IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_  NUMBER := 0;     
   stmt_   VARCHAR2(2000) := 'SELECT 1
                                 FROM dictionary_sys_Tab d, module_tab m
                                 WHERE d.table_name = UPPER('''||table_name_||''')'||
                                 'AND d.module = m.module
                                 AND m.active = ''TRUE''
                                    UNION
                                 SELECT 2
                                 FROM user_tables u
                                 WHERE table_name = UPPER('''||table_name_||''')'||
                                 'AND NOT EXISTS 
                                 (SELECT 1
                                  FROM dictionary_sys_Tab d
                                  WHERE d.table_name = u.table_name)'; 
BEGIN
   @ApproveDynamicStatement(2020-09-11,chahlk)
   EXECUTE IMMEDIATE stmt_ INTO dummy_;
   IF dummy_ > 0 THEN
      RETURN TRUE;
   END IF;  
   RETURN FALSE;
EXCEPTION
   WHEN too_many_rows THEN
      RETURN TRUE;  
   WHEN no_data_found THEN
      RETURN FALSE;          
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('Error fetching records: '||SQLERRM);
      RETURN FALSE;      
END Table_Active;



@UncheckedAccess
FUNCTION Type_Exist (
   type_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_type IS
      SELECT  1
      FROM    user_types
      WHERE   type_name = UPPER(type_name_);
BEGIN
   OPEN  check_type;
   FETCH check_type INTO dummy_;
   IF (check_type%FOUND) THEN
      CLOSE check_type;
      RETURN TRUE;
   ELSE
      CLOSE check_type;
      RETURN FALSE;
   END IF;
END Type_Exist;



@UncheckedAccess
FUNCTION Text_Index_Exist (
   index_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_index IS
      SELECT  1
      FROM    ctx_user_indexes
      WHERE   idx_name = UPPER(index_name_);
BEGIN
   OPEN  check_index;
   FETCH check_index INTO dummy_;
   IF (check_index%FOUND) THEN
      CLOSE check_index;
      RETURN TRUE;
   ELSE
      CLOSE check_index;
      RETURN FALSE;
   END IF;
END Text_Index_Exist;


@UncheckedAccess
FUNCTION Trigger_Exist (
   trigger_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_trigger IS
      SELECT  1
      FROM    user_triggers
      WHERE   trigger_name = UPPER(trigger_name_);
BEGIN
   OPEN  check_trigger;
   FETCH check_trigger INTO dummy_;
   IF (check_trigger%FOUND) THEN
      CLOSE check_trigger;
      RETURN TRUE;
   ELSE
      CLOSE check_trigger;
      RETURN FALSE;
   END IF;
END Trigger_Exist;


@UncheckedAccess
FUNCTION View_Exist (
   view_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_view IS
      SELECT  1
      FROM    user_views
      WHERE   view_name = UPPER(view_name_);
BEGIN
   OPEN  check_view;
   FETCH check_view INTO dummy_;
   IF (check_view%FOUND) THEN
      CLOSE check_view;
      RETURN TRUE;
   ELSE
      CLOSE check_view;
       RETURN FALSE;
   END IF;
END View_Exist;

@UncheckedAccess
FUNCTION View_Active (
   view_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   stmt_   VARCHAR2(2000) := 'SELECT 1
                              FROM dictionary_sys_view_Tab v, module_tab m, dictionary_sys_Tab d
                              WHERE v.view_name = UPPER('''||view_name_||''')'||
                              'AND d.module = m.module
                              AND v.lu_name = d.lu_name
                              AND m.active = ''TRUE''
                              UNION
                              SELECT 2
                              FROM user_views u
                              WHERE u.view_name = UPPER('''||view_name_||''')'||
                              'AND NOT EXISTS 
                                 (SELECT 1
                                  FROM dictionary_sys_view_Tab d
                                  WHERE d.view_name = u.view_name)';    
BEGIN
   @ApproveDynamicStatement(2020-09-11,chahlk)
   EXECUTE IMMEDIATE stmt_ INTO dummy_;
   IF dummy_ > 0 THEN
      RETURN TRUE;
   END IF;  
   RETURN FALSE;
EXCEPTION
   WHEN too_many_rows THEN
      RETURN TRUE;   
   WHEN no_data_found THEN
      RETURN FALSE;          
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('Error fetching records: '||SQLERRM);
      RETURN FALSE;      
END View_Active;


@UncheckedAccess
FUNCTION Package_Exist (
   package_name_ IN VARCHAR2 ) RETURN BOOLEAN
IS
BEGIN
   RETURN Object_Exist(package_name_, 'PACKAGE');
END Package_Exist;

@UncheckedAccess
FUNCTION Package_Active (
   package_name_ IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_  NUMBER := 0;
   stmt_   VARCHAR2(2000) := 'SELECT 1
                              FROM dictionary_sys_package_Tab v, module_tab m, dictionary_sys_Tab d
                              WHERE v.package_name = UPPER('''||package_name_||''')'||
                              'AND d.module = m.module
                              AND v.lu_name = d.lu_name
                              AND m.active = ''TRUE''
                              UNION
                              SELECT 2
                              FROM user_objects u
                              WHERE object_name IN (UPPER('''||package_name_||'''), '''||package_name_||''')'||
                              'AND   object_type = UPPER(''PACKAGE'')
                              AND NOT EXISTS 
                              (SELECT 1
                              FROM dictionary_sys_package_Tab d
                              WHERE d.package_name = u.object_name)';    
BEGIN
   @ApproveDynamicStatement(2020-09-11,chahlk)
   EXECUTE IMMEDIATE stmt_ INTO dummy_;
   IF dummy_ > 0 THEN
      RETURN TRUE;
   END IF;  
   RETURN FALSE;
EXCEPTION
   WHEN too_many_rows THEN
      RETURN TRUE; 
   WHEN no_data_found THEN
      RETURN FALSE;          
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('Error fetching records: '||SQLERRM);
      RETURN FALSE;      
END Package_Active;


@UncheckedAccess
FUNCTION Primary_Key_Constraint_Exist (
   table_name_      IN VARCHAR2) RETURN BOOLEAN
IS
   dummy_          NUMBER := 0;
   CURSOR check_constraint IS
      SELECT  1
      FROM    user_constraints
      WHERE   table_name = upper(table_name_)
      AND     constraint_type = 'P';
BEGIN
   OPEN  check_constraint;
   FETCH check_constraint INTO dummy_;
   IF (check_constraint%FOUND) THEN
      CLOSE check_constraint;
      RETURN TRUE;
   ELSE
      CLOSE check_constraint;
      RETURN FALSE;
   END IF;
END Primary_Key_Constraint_Exist;

@UncheckedAccess
FUNCTION Primary_Key_Constraint_Active (
   table_name_  IN VARCHAR2) RETURN BOOLEAN

IS
   dummy_          NUMBER := 0;
   stmt_   VARCHAR2(2000) := 'SELECT 1
                              FROM dictionary_sys_constraints v, module_tab m, dictionary_sys_Tab d
                              WHERE v.table_name = UPPER('''||table_name_||''')'||
                              'AND v.constraint_type = ''P''
                              AND d.module = m.module
                              AND v.table_name = d.table_name
                              AND m.active = ''TRUE''
                              UNION
                              SELECT 2
                              FROM user_constraints u
                              WHERE u.table_name = UPPER('''||table_name_||''')'||
                              'AND u.constraint_type = ''P'''||
                              'AND NOT EXISTS 
                                 (SELECT 1
                                  FROM dictionary_sys_constraints d
                                  WHERE d.table_name = u.table_name
                                  AND d.constraint_type = ''P''
                                  AND d.constraint_name = u.constraint_name)';     
BEGIN
   @ApproveDynamicStatement(2020-09-11,chahlk)
   EXECUTE IMMEDIATE stmt_ INTO dummy_;
   IF dummy_ > 0 THEN
      RETURN TRUE;
   END IF;  
   RETURN FALSE;
EXCEPTION
   WHEN too_many_rows THEN
      RETURN TRUE;  
   WHEN no_data_found THEN
      RETURN FALSE;          
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('Error fetching records: '||SQLERRM);        
      RETURN FALSE;         
END Primary_Key_Constraint_Active;


@UncheckedAccess
FUNCTION Method_Exist (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2 ) RETURN BOOLEAN
IS
   temp_ NUMBER;
BEGIN  
   SELECT 1 INTO temp_
     FROM user_procedures
    WHERE object_name    = upper(package_name_)
      AND procedure_name = upper(method_name_);
   
   RETURN TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
   WHEN too_many_rows THEN
      -- There are overloads
      RETURN TRUE;
END Method_Exist;

@UncheckedAccess
FUNCTION Method_Active (
   package_name_ IN VARCHAR2,
   method_name_  IN VARCHAR2) RETURN BOOLEAN
IS
   temp_ NUMBER;
   stmt_   VARCHAR2(2000) := 'SELECT 1
                              FROM dictionary_sys_method_Tab v, module_tab m, dictionary_sys_Tab d
                              WHERE v.package_name = UPPER('''||package_name_||''')'||
                              'AND UPPER(v.method_name) = UPPER('''||method_name_||''')'||
                              'AND d.module = m.module
                              AND v.lu_name = d.lu_name
                              AND m.active = ''TRUE''
                              UNION
                              SELECT 2
                              FROM user_procedures u
                              WHERE u.object_name = UPPER('''||package_name_||''')'||
                              'AND   u.procedure_name = UPPER('''||method_name_||''')'||
                              'AND NOT EXISTS 
                              (SELECT 1
                              FROM dictionary_sys_method_tab d
                              WHERE d.package_name = u.object_name
                              AND   UPPER(d.method_name) = u.procedure_name)';      
BEGIN  
   @ApproveDynamicStatement(2020-09-11,chahlk)
   EXECUTE IMMEDIATE stmt_ INTO temp_;
   IF temp_ > 0 THEN
      RETURN TRUE;
   END IF;  
   RETURN FALSE;
EXCEPTION
   WHEN too_many_rows THEN
      RETURN TRUE;
   WHEN no_data_found THEN
      RETURN FALSE;          
   WHEN OTHERS THEN
      DBMS_Output.Put_Line('Error fetching records: '||SQLERRM);        
      RETURN FALSE;      
END Method_Active;



@UncheckedAccess
FUNCTION Mtrl_View_Exist (
   mtrl_view_ IN VARCHAR2) RETURN BOOLEAN 
IS
   dummy_   NUMBER;
   CURSOR get_mtrl_view IS
      SELECT 1 
      FROM user_mviews
      WHERE mview_name = Upper(mtrl_view_);
BEGIN
   OPEN get_mtrl_view;
   FETCH get_mtrl_view INTO dummy_;
   IF get_mtrl_view%FOUND THEN
      CLOSE get_mtrl_view;
      RETURN TRUE;
   ELSE
      CLOSE get_mtrl_view;
      RETURN FALSE;
   END IF;
END Mtrl_View_Exist;



@UncheckedAccess
FUNCTION Mtrl_View_Log_Exist (
   mtrl_view_log_tbl_ IN VARCHAR2) RETURN BOOLEAN 
IS
   dummy_   NUMBER;
   CURSOR get_mtrl_view IS
      SELECT 1 
      FROM user_mview_logs
      WHERE master = Upper(mtrl_view_log_tbl_);
BEGIN
   OPEN get_mtrl_view;
   FETCH get_mtrl_view INTO dummy_;
   IF get_mtrl_view%FOUND THEN
      CLOSE get_mtrl_view;
      RETURN TRUE;
   ELSE
      CLOSE get_mtrl_view;
      RETURN FALSE;
   END IF;
END Mtrl_View_Log_Exist;



@UncheckedAccess
PROCEDURE Register_Db_Patch (
   module_       IN VARCHAR2,
   patch_number_ IN NUMBER,
   description_  IN VARCHAR2 DEFAULT NULL )
IS
   stmt_           VARCHAR2(500);
BEGIN
   IF module_ IS NULL OR patch_number_ IS NULL THEN
      Dbms_Output.Put_Line('Missing mandatory parameters when trying to register patch!');
   ELSIF NOT Table_Exist('module_db_patch_tab') THEN
      Dbms_Output.Put_Line('Could not register Patch ['||to_char(patch_number_)||'] in Module ['||upper(module_)||'] since necessary table is not installed!');
   ELSE
      stmt_ := 'INSERT INTO module_db_patch_tab (module, patch_number, description, rowversion) VALUES (upper(:module_), :patch_number_, :description_, SYSDATE)';
      BEGIN
         -- Safe due to using bind variables and executed with Invokers rights
         @ApproveDynamicStatement(2006-06-01,haarse)
         EXECUTE IMMEDIATE stmt_ USING module_, patch_number_, description_;
      EXCEPTION
         WHEN dup_val_on_index THEN
            Dbms_Output.Put_Line('Patch ['||to_char(patch_number_)||'] in Module ['||upper(module_)||' is already registered!');
         WHEN OTHERS THEN
            Dbms_Output.Put_Line('Errors when registering Patch ['||to_char(patch_number_)||'] in Module ['||upper(module_)||']');
      END;
   END IF;
END Register_Db_Patch;


@UncheckedAccess
FUNCTION Is_Db_Patch_Registered (
   module_       IN VARCHAR2,
   patch_number_ IN NUMBER ) RETURN BOOLEAN
IS
   stmt_  VARCHAR2(500);
   dummy_ NUMBER;
BEGIN
   IF module_ IS NULL OR patch_number_ IS NULL THEN
      Dbms_Output.Put_Line('Missing mandatory parameters when investigating registered patch!');
      RETURN FALSE;
   ELSIF NOT Table_Exist('module_db_patch_tab') THEN
      Dbms_Output.Put_Line('Could not investigate Patch ['||to_char(patch_number_)||'] in Module ['||upper(module_)||'] since necessary table is not installed!');
      RETURN FALSE;
   ELSE
      stmt_ := 'SELECT 1 FROM module_db_patch_tab WHERE module = upper(:module_) AND patch_number = :patch_number_';
      BEGIN
         -- Safe due to using bind variables and executed with Invokers rights
         @ApproveDynamicStatement(2006-06-01,haarse)
         EXECUTE IMMEDIATE stmt_ INTO dummy_ USING module_, patch_number_;
      EXCEPTION
         WHEN no_data_found THEN
            RETURN FALSE;
         WHEN OTHERS THEN
            Dbms_Output.Put_Line('Errors when investigating Patch ['||to_char(patch_number_)||'] in Module ['||upper(module_)||']');
            RETURN FALSE;
      END;
      RETURN TRUE;
   END IF;
END Is_Db_Patch_Registered;


@UncheckedAccess
PROCEDURE Clear_Db_Patch_Registration (
   module_       IN VARCHAR2,
   patch_number_ IN NUMBER DEFAULT NULL )
IS
   stmt_           VARCHAR2(500);
BEGIN
   IF module_ IS NULL THEN
      Dbms_Output.Put_Line('Missing mandatory parameters when trying to clear patch information!');
   ELSIF NOT Table_Exist('module_db_patch_tab') THEN
      Dbms_Output.Put_Line('Could not clear information for Patch ['||to_char(patch_number_)||'] in Module ['||upper(module_)||'] since necessary table is not installed!');
   ELSE
      stmt_ := 'DELETE FROM module_db_patch_tab WHERE module = upper(:module_)';
      BEGIN
         IF patch_number_ IS NULL THEN
            -- Safe due to using bind variables and executed with Invokers rights
            @ApproveDynamicStatement(2006-06-01,haarse)
            EXECUTE IMMEDIATE stmt_ USING module_;
         ELSE
            stmt_ := stmt_ || ' AND patch_number = :patch_number_';
            -- Safe due to using bind variables and executed with Invokers rights
            @ApproveDynamicStatement(2006-06-01,haarse)
            EXECUTE IMMEDIATE stmt_ USING module_, patch_number_;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            Dbms_Output.Put_Line('Errors when clearing information for Patch ['||to_char(patch_number_)||'] in Module ['||upper(module_)||']');
      END;
   END IF;
END Clear_Db_Patch_Registration;


@UncheckedAccess
PROCEDURE Set_Installation_Mode (
   installation_mode_ IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   installation_ := installation_mode_;
   IF installation_mode_ THEN
      @ApproveDynamicStatement(2018-01-26,MABOSE)
      EXECUTE IMMEDIATE 'ALTER SESSION SET NLS_LANGUAGE = AMERICAN' ||
                                         ' NLS_TERRITORY = AMERICA' ||
                                         ' NLS_DATE_FORMAT = ''DD-MON-RR''' ;
      BEGIN
         @ApproveDynamicStatement(2018-01-26,MABOSE)
         EXECUTE IMMEDIATE 'BEGIN Fnd_Session_API.Set_Language(''en''); END;';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END IF;
END Set_Installation_Mode;


@UncheckedAccess
PROCEDURE Set_Log_Level (
   level_ IN NUMBER,
   format_ IN BOOLEAN DEFAULT FALSE )
IS
   stmt_ VARCHAR2(100) := 'BEGIN Log_SYS.Set_Log_Level_(:level,';
BEGIN
   IF format_ THEN 
      stmt_ := stmt_ || 'TRUE';
   ELSE
      stmt_ := stmt_ || 'FALSE';
   END IF;
   stmt_ := stmt_ || '); END;';
   @ApproveDynamicStatement(2014-06-16,haarse)
   EXECUTE IMMEDIATE stmt_ USING level_;
EXCEPTION 
   WHEN OTHERS THEN 
      NULL; 
END Set_Log_Level;

@UncheckedAccess
PROCEDURE Set_Log_Format (
   format_ IN BOOLEAN DEFAULT FALSE )
IS
   stmt_ VARCHAR2(100) := 'BEGIN Fnd_Context_SYS.Set_Value(''LOG_SYS.Format'',';
BEGIN
   IF format_ THEN 
      stmt_ := stmt_ || 'TRUE';
   ELSE
      stmt_ := stmt_ || 'FALSE';
   END IF;
   stmt_ := stmt_ || '); END;';
   @ApproveDynamicStatement(2014-06-16,haarse)
   EXECUTE IMMEDIATE stmt_;
EXCEPTION 
   WHEN OTHERS THEN
      NULL; 
END Set_Log_Format;


@UncheckedAccess
FUNCTION Get_Installation_Mode RETURN BOOLEAN
IS
BEGIN
   RETURN(installation_);
END Get_Installation_Mode;


@UncheckedAccess
FUNCTION Get_Show_Info RETURN BOOLEAN
IS
BEGIN
   RETURN(gc_show_info_);
END Get_Show_Info;


@UncheckedAccess
PROCEDURE Copy_Special_Grants_To_Role (
   old_role_ IN VARCHAR2,
   new_role_ IN VARCHAR2 )
IS
   app_owner_   VARCHAR2(30);
   CURSOR get_sys_privs IS
      SELECT * 
        FROM dba_sys_privs 
       WHERE grantee = UPPER(old_role_);
   CURSOR get_tab_privs IS
      SELECT * 
        FROM dba_tab_privs 
       WHERE privilege NOT IN ('SELECT', 'EXECUTE') 
         AND grantee = UPPER(old_role_)
         AND grantor = app_owner_;
   --
   PROCEDURE Run_Ddl(stmt_ IN VARCHAR2) IS
      no_role EXCEPTION;
      PRAGMA EXCEPTION_INIT(no_role, -1951);
   BEGIN
      @ApproveDynamicStatement(2011-05-30,haarse)
      EXECUTE IMMEDIATE stmt_;
      dbms_output.put_line('SUCCESS : ' || stmt_);
   EXCEPTION
      WHEN no_role THEN
         NULL;
      WHEN OTHERS THEN
         dbms_output.put_line('ERROR : ' || stmt_);
   END Run_Ddl;

BEGIN
   BEGIN
      @ApproveDynamicStatement(2011-05-30,haarse)
      EXECUTE IMMEDIATE 'BEGIN :app_owner_ := Fnd_Session_API.Get_App_Owner; END;' USING OUT app_owner_;
   EXCEPTION
      WHEN OTHERS THEN
         app_owner_ := NULL;
   END;
   FOR rec IN get_sys_privs LOOP
      Run_Ddl('GRANT '||rec.PRIVILEGE||' TO '||UPPER(new_role_));
   END LOOP;
   FOR rec IN get_tab_privs LOOP
      Run_Ddl('GRANT '||rec.PRIVILEGE||' ON '||rec.table_name||' TO '||UPPER(new_role_));
   END LOOP;
END Copy_Special_Grants_To_Role;


@UncheckedAccess
PROCEDURE Convert_Tables_To_Unicode (
   table_name_   IN VARCHAR2 )
IS
   column_  Installation_SYS.ColRec;
   CURSOR get_col IS
      SELECT table_name, column_name, data_type, char_length
      FROM user_tab_columns
      WHERE data_type IN ('VARCHAR2', 'CHAR') -- only convert string columns
      AND char_used = 'B' -- Only convert byte character column
      AND table_name LIKE table_name_;
BEGIN
   FOR rec IN get_col LOOP
      column_ := Installation_SYS.Set_Column_Values(rec.column_name, rec.data_type||'('||rec.char_length||' CHAR)');
      Installation_SYS.Alter_Table_Column(rec.table_name, 'M', column_, TRUE);
   END LOOP;
END Convert_Tables_To_Unicode;


@UncheckedAccess
PROCEDURE Write_Table_Ddl (
   tables_     IN VARCHAR2,
   directory_  IN VARCHAR2,
   filename_   IN VARCHAR2,
   tablespace_ IN VARCHAR2 DEFAULT 'FALSE' )
IS
   file_handle_       Utl_File.File_Type;
   file_not_found     EXCEPTION;
   PRAGMA             EXCEPTION_INIT(file_not_found, -1309);
   table_open_handle_ NUMBER;
   table_trans_handle_ NUMBER;
   schema_name_       VARCHAR2(30);
   table_name_        VARCHAR2(ORA_MAX_NAME_LEN);
   table_ddls_        sys.ku$_ddls;
   table_ddl_         sys.ku$_ddl;
   parsed_items_      sys.ku$_parsed_items;
BEGIN
   --  open the output file... note that the 1st param. (dir. path) must be
   --  included in the database's UTL_FILE_DIR init. parameter.
   --  or
   --  grant create any directory to Appowner;
   --  Create directory
   --  create or replace directory extract
   --   as 'D:\Projekt\F1V3\Unicode';
   BEGIN
      file_handle_ := Utl_File.Fopen(directory_, filename_, 'w', 32760);
   EXCEPTION
      WHEN OTHERS THEN
         RAISE file_not_found;
   END;
   -- Open a handle for tables in the current schema.
   table_open_handle_ := dbms_metadata.OPEN('TABLE');
   -- Call 'set_count' to request retrieval of one table at a time.
   -- This call is not actually necessary because 1 is the default.
   dbms_metadata.set_count(table_open_handle_, 1);
   -- Retrieve tables from current schema.
   -- When the filter is 'NAME_EXPR', the filter value string must include the SQL operator.
   -- This gives the caller flexibility to use LIKE, IN, NOT IN, subqueries, and so on.
   dbms_metadata.set_filter(table_open_handle_, 'NAME_EXPR', 'LIKE ''' || tables_ || '''');
   -- Tell Metadata API to parse out each table's schema and name separately
   -- so we can use them to set up the calls to retrieve its indexes.
   dbms_metadata.set_parse_item(table_open_handle_, 'SCHEMA');
   dbms_metadata.set_parse_item(table_open_handle_, 'NAME');
   -- Add the DDL transform so we get SQL creation DDL
   table_trans_handle_ := dbms_metadata.add_transform(table_open_handle_, 'DDL');
   -- Tell the XSL stylesheet we don't want physical storage information (storage,
   -- tablespace, etc), and that we want a SQL terminator on each DDL. Notice that
   -- these calls use the transform handle, not the open handle.
   dbms_metadata.set_transform_param(table_trans_handle_, 'SEGMENT_ATTRIBUTES', TRUE);
   dbms_metadata.set_transform_param(table_trans_handle_, 'SQLTERMINATOR', TRUE);
   dbms_metadata.set_transform_param(table_trans_handle_, 'STORAGE', FALSE);
   IF tablespace_ = 'FALSE' THEN
      dbms_metadata.set_transform_param(table_trans_handle_, 'TABLESPACE', FALSE);
   ELSE
      dbms_metadata.set_transform_param(table_trans_handle_, 'TABLESPACE', TRUE);
   END IF;
   dbms_metadata.set_transform_param(table_trans_handle_, 'CONSTRAINTS', TRUE);
   dbms_metadata.set_transform_param(table_trans_handle_, 'REF_CONSTRAINTS', FALSE);
   dbms_metadata.set_transform_param(table_trans_handle_, 'CONSTRAINTS_AS_ALTER', TRUE);
   -- Ready to start fetching tables. We use the FETCH_DDL interface (rather than
   -- FETCH_XML or FETCH_CLOB). This interface returns a SYS.KU$_DDLS; a table of
   -- SYS.KU$_DDL objects. This is a table because some object types return
   -- multiple DDL statements (like types / pkgs which have create header and
   -- body statements). Each KU$_DDL has a CLOB containing the 'CREATE TABLE'
   -- statement plus a nested table of the parse items specified. In our case,
   -- we asked for two parse items; Schema and Name.
   LOOP
      table_ddls_ := dbms_metadata.fetch_ddl(table_open_handle_);
      EXIT WHEN table_ddls_ IS NULL; -- Get out when no more tables
      -- In our case, we know there is only one row in table_ddls_ (a KU$_DDLS tbl obj)
      -- for the current table. Sometimes tables have multiple DDL statements,
      -- for example, if constraints are applied as ALTER TABLE statements,
      -- but we didn't ask for that option.
      -- So, rather than writing code to loop through table_ddls_,
      -- we'll just work with the 1st row.
      --
      -- First, write the CREATE TABLE text to our output file, then retrieve the
      -- parsed schema and table names.
      table_ddl_     := table_ddls_(1);
      parsed_items_ := table_ddl_.parsedItems;
      -- Must check the name of the returned parse items as ordering isn't guaranteed
      FOR i IN 1 .. 2 LOOP
         IF parsed_items_(i).item = 'SCHEMA' THEN
            schema_name_ := parsed_items_(i).VALUE;
         ELSE
            table_name_  := parsed_items_(i).VALUE;
         END IF;
      END LOOP;
      -- Write DDL to file
      Write_Lob___(file_handle_,
                   REPLACE(table_ddl_.ddltext,
                           'TABLE "' || schema_name_ || '"."' || table_name_ || '"',
                           'TABLE "' || table_name_ || '"'));
   END LOOP;
-- Free resources allocated for table stream and close output file.
   dbms_metadata.CLOSE(table_open_handle_);
   utl_file.fclose(file_handle_);
END Write_Table_Ddl;


@UncheckedAccess
PROCEDURE Shrink_Lob_Segment(
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2, 
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
   stmt_    VARCHAR2(400)  := 'ALTER TABLE ' || table_name_ || ' MODIFY lob (' || column_name_ ||  ') (SHRINK SPACE)';
   changed_ BOOLEAN        := FALSE;
BEGIN
   --
   -- Note! This command locks the table, possibly a long time for a large table, meaning endusers cannot use the table during the operation
   --       Enable row movement must be enabled on the table in order to make the shrink command available
   --
   IF Is_Table_Temporary___(table_name_) THEN
      Show_Message___('Shrink_Lob_Segment error: Lob columns in temporary tables should not be modified. Drop and recreate the table instead.');
      RETURN;
   END IF;
   IF NOT Is_Rowmovement_Enabled(table_name_) THEN 
      Alter_Table_Rowmovement(table_name_, TRUE, show_info_);
      changed_ := TRUE;
   END IF;
   Run_Ddl_Command___(stmt_, 'Shrink_Lob_Segment', show_info_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Shrink_Lob_Segment: Lob Segment ' || table_name_ || ', ' || column_name_ || 'shrinked.');
   END IF;
   IF changed_ THEN
      Alter_Table_Rowmovement(table_name_, TRUE, show_info_);
   END IF;         
END Shrink_Lob_Segment;


@UncheckedAccess
PROCEDURE Move_Lob_Segment (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2, 
   tablespace_  IN VARCHAR2 DEFAULT 'IFSAPP_LOB',
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
   stmt_ VARCHAR2(600) := 'ALTER TABLE ' || table_name_ || ' MOVE LOB (' || column_name_ ||  ') STORE AS SECUREFILE (TABLESPACE '||tablespace_||')';
BEGIN
   --
   -- Note! This command locks the table, possibly a long time for a large table, meaning endusers cannot use the table during the operation
   --       Enable row movement must be enabled on the table in order to make the shrink command available
   --       May lead to unusable Search Domain indexes
   IF Is_Table_Temporary___(table_name_) THEN
      Show_Message___('Move_Lob_Segment error: Lob columns in temporary tables should not be modified. Drop and recreate the table instead.');
      RETURN;
   END IF;
   Run_Ddl_Command___(stmt_, 'Move_Lob_Segment', show_info_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Move_Lob_Segment: Lob Segment ' || table_name_ || ', ' || column_name_ || ' moved and shrinked.');
   END IF;
END Move_Lob_Segment;

@UncheckedAccess
PROCEDURE Move_Object (
   object_name_      IN VARCHAR2,    
   tablespace_       IN VARCHAR2 DEFAULT NULL,
   show_info_        IN BOOLEAN  DEFAULT FALSE,
   forced_offline_   IN BOOLEAN  DEFAULT FALSE)
IS
   
BEGIN  
   IF Object_Exist(object_name_, 'TABLE') THEN
      Move_Table___('Move_Table', object_name_, tablespace_, show_info_);
   ELSIF Object_Exist(object_name_, 'INDEX') THEN
      Move_Index___('Move_Index', object_name_, tablespace_, show_info_,forced_offline_);
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___ ('Move_Objects: Object ' || object_name_ || ' does not exists.');
      END IF;  
   END IF;
END Move_Object;

@UncheckedAccess
FUNCTION Get_TableSpace_Name (
   object_name_  IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_table_tablespace IS
      SELECT   tablespace_name
      FROM     user_tables
      WHERE    table_name  = UPPER(object_name_);
      
   CURSOR get_index_tablespace IS
      SELECT   tablespace_name
      FROM     user_indexes
      WHERE    index_name  = UPPER(object_name_);
   
   tablespace_name_      VARCHAR2(ORA_MAX_NAME_LEN);
BEGIN
   IF Object_Exist(object_name_, 'TABLE') THEN
      OPEN get_table_tablespace;
      FETCH get_table_tablespace INTO tablespace_name_;
      CLOSE get_table_tablespace;
   ELSIF Object_Exist(object_name_, 'INDEX') THEN
      OPEN get_index_tablespace;
      FETCH get_index_tablespace INTO tablespace_name_;
      CLOSE get_index_tablespace;
   END IF;
   RETURN tablespace_name_;
END Get_TableSpace_Name;

@UncheckedAccess
FUNCTION Get_Lob_Freepools (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN NUMBER
IS
   CURSOR get_lob IS 
   SELECT nvl(freepools, 1)
   FROM user_lobs
   WHERE table_name = table_name_
   AND   column_name = column_name_;
   freepools_  NUMBER;
BEGIN
   OPEN  get_lob;
   FETCH get_lob INTO freepools_;
   CLOSE get_lob;
   RETURN (freepools_);
END Get_Lob_Freepools;

@UncheckedAccess
PROCEDURE Get_Lob_Sizes (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   total_blocks_ OUT NUMBER,
   total_bytes_ OUT NUMBER,
   unused_blocks_ OUT NUMBER,
   unused_bytes_ OUT NUMBER,
   last_used_extent_file_id_ OUT NUMBER,
   last_used_extent_block_id_ OUT NUMBER,
   last_used_block_ OUT NUMBER )
IS
   CURSOR get_lob IS 
   SELECT segment_name
   FROM user_lobs
   WHERE table_name = table_name_
   AND   column_name = column_name_;
   
   segment_name_  VARCHAR2(ORA_MAX_NAME_LEN);
BEGIN
   OPEN  get_lob;
   FETCH get_lob INTO segment_name_;
   CLOSE get_lob;
   Dbms_Space.Unused_Space(Sys_Context('USERENV', 'CURRENT_SCHEMA'), segment_name_, 'LOB', total_blocks_, total_bytes_, unused_blocks_, unused_bytes_, 
                           last_used_extent_file_id_, last_used_extent_block_id_, last_used_block_); 

END Get_Lob_Sizes;

@UncheckedAccess
PROCEDURE Alter_Lob_Freepools (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2, 
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
   freepools_   VARCHAR2(10)  := Get_Lob_Freepools(table_name_, column_name_);
   stmt_        VARCHAR2(600) := 'ALTER TABLE ' || table_name_ || ' MODIFY LOB (' || column_name_ ||  ') (FREEPOOLS '||freepools_||')';
BEGIN
   IF Is_Table_Temporary___(table_name_) THEN
      Show_Message___('Alter_Lob_Freepools error: Lob columns in temporary tables should not be modified. Drop and recreate the table instead.');
      RETURN;
   END IF;
   --
   -- Note! This command locks the table, possibly a long time for a large table, meaning endusers cannot use the table during the operation
   --       Enable row movement must be enabled on the table in order to make the shrink command available
   --
   Run_Ddl_Command___(stmt_, 'Alter_Lob_Freepools', show_info_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Alter_Lob_Freepools: Lob Segment ' || table_name_ || ', ' || column_name_ || ' have altered freepool to '||freepools_||'.');
   END IF;
END Alter_Lob_Freepools;

@UncheckedAccess
PROCEDURE Change_Lob_Row_Movement (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2, 
   tablespace_  IN VARCHAR2 DEFAULT 'IFSAPP_LOB',
   show_info_   IN BOOLEAN  DEFAULT TRUE )
IS
   stmt_ VARCHAR2(600) := 'ALTER TABLE ' || table_name_ || ' MOVE lob (' || column_name_ ||  ') STORE AS SECUREFILE (TABLESPACE '||tablespace_||' ENABLE STORAGE IN ROW )';
BEGIN
   IF Is_Table_Temporary___(table_name_) THEN
      Show_Message___('Change_Lob_Row_Movement error: Lob columns in temporary tables should not be modified. Drop and recreate the table instead.');
      RETURN;
   END IF;
   --
   -- Note! This command locks the table, possibly a long time for a large table, meaning endusers cannot use the table during the operation
   --       Enable row movement must be enabled on the table in order to make the shrink command available
   --
   Run_Ddl_Command___(stmt_, 'Change_Lob_Row_Movement', show_info_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Change_Lob_Row_Movement: Lob Segment ' || table_name_ || ', ' || column_name_ || ' moved and shrinked.');
   END IF;
END Change_Lob_Row_Movement;


@UncheckedAccess
PROCEDURE Remove_Debug_Information (
   do_remove_ VARCHAR2 DEFAULT 'YES' )
IS
   CURSOR get_debug_objects IS
      SELECT name, type, object_id
      FROM user_plsql_object_settings us, user_objects uo
      WHERE name != 'INSTALLATION_SYS'
      AND   us.name = uo.object_name
      AND   us.type = uo.object_type
      AND  (plsql_debug = 'TRUE'
      OR    plsql_optimize_level < 2
      OR    nls_length_semantics = 'BYTE')
      ORDER BY DECODE(type, 'PACKAGE', 10,
                            'PACKAGE BODY', 20,
                            'TRIGGER', 30,
                            'PROCEDURE', 40,
                            'FUNCTION', 50,
                            50 ), name;
BEGIN
   IF UPPER(SUBSTR(do_remove_, 1, 1)) = 'Y' THEN
      FOR obj_ IN get_debug_objects LOOP
         BEGIN
            IF ( obj_.type = 'PACKAGE' ) THEN
               DBMS_Output.Put_Line('Setting correct length semantic and/or removing  debug information from package specification ' || obj_.name);
               @ApproveDynamicStatement(2014-07-11,mabose)
               EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Invalidate(:object_id, ''PLSQL_OPTIMIZE_LEVEL=2 PLSQL_DEBUG=FALSE NLS_LENGTH_SEMANTICS=CHAR REUSE SETTINGS''); END;' USING obj_.object_id;
            ELSIF ( obj_.type = 'PACKAGE BODY' ) THEN
               DBMS_Output.Put_Line('Setting correct length semantic and/or removing  debug information from package body ' || obj_.name);
               @ApproveDynamicStatement(2014-07-11,mabose)
               EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Invalidate(:object_id, ''PLSQL_OPTIMIZE_LEVEL=2 PLSQL_DEBUG=FALSE NLS_LENGTH_SEMANTICS=CHAR REUSE SETTINGS''); END;' USING obj_.object_id;
            ELSIF ( obj_.type = 'TRIGGER' ) THEN
               DBMS_Output.Put_Line('Setting correct length semantic and/or removing  debug information from trigger ' || obj_.name);
               @ApproveDynamicStatement(2014-07-11,mabose)
               EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Invalidate(:object_id, ''PLSQL_OPTIMIZE_LEVEL=2 PLSQL_DEBUG=FALSE NLS_LENGTH_SEMANTICS=CHAR REUSE SETTINGS''); END;' USING obj_.object_id;
            ELSIF ( obj_.type = 'PROCEDURE' ) THEN
               DBMS_Output.Put_Line('Setting correct length semantic and/or removing debug information from procedure ' || obj_.name);
               @ApproveDynamicStatement(2014-07-11,mabose)
               EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Invalidate(:object_id, ''PLSQL_OPTIMIZE_LEVEL=2 PLSQL_DEBUG=FALSE NLS_LENGTH_SEMANTICS=CHAR REUSE SETTINGS''); END;' USING obj_.object_id;
            ELSIF ( obj_.type = 'FUNCTION' ) THEN
               DBMS_Output.Put_Line('Setting correct length semantic and/or removing  debug information from function ' || obj_.name);
               @ApproveDynamicStatement(2014-07-11,mabose)
               EXECUTE IMMEDIATE 'BEGIN Dbms_Utility.Invalidate(:object_id, ''PLSQL_OPTIMIZE_LEVEL=2 PLSQL_DEBUG=FALSE NLS_LENGTH_SEMANTICS=CHAR REUSE SETTINGS''); END;' USING obj_.object_id;
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
   END IF;
END Remove_Debug_Information;

@UncheckedAccess
FUNCTION Get_Oracle_AQ_Table(
   queue_name_ IN VARCHAR2) RETURN VARCHAR2 
IS 
   table_name_ VARCHAR2(ORA_MAX_NAME_LEN);
BEGIN
   SELECT queue_table
   INTO table_name_
   FROM user_queues
   WHERE name = UPPER(queue_name_);
   RETURN table_name_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Oracle_AQ_Table;

@UncheckedAccess
PROCEDURE Remove_Oracle_AQ(
   queue_name_ IN VARCHAR2,
   show_info_  IN BOOLEAN  DEFAULT FALSE)
IS
   table_name_ VARCHAR2(ORA_MAX_NAME_LEN) ;
   app_owner_  VARCHAR2(30) := Sys_Context('USERENV', 'CURRENT_SCHEMA');
BEGIN
   table_name_ := Get_Oracle_AQ_Table(queue_name_);
   Dbms_Aqadm.Stop_Queue(app_owner_ || '.' || queue_name_);
   Dbms_Aqadm.Drop_Queue(app_owner_ || '.' || queue_name_);   
   Dbms_Aqadm.Drop_Queue_Table(app_owner_ || '.' || table_name_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Remove_Oracle_AQ: Queue ' || queue_name_ || ' dropped.');
   END IF;
END Remove_Oracle_AQ;

@UncheckedAccess   
PROCEDURE Create_Oracle_AQ(
   queue_name_   IN VARCHAR2,
   message_struct_name_ IN VARCHAR2,
   table_name_   IN VARCHAR2 DEFAULT NULL,
   start_queue_  IN BOOLEAN DEFAULT FALSE,
   multiple_consumers_ IN BOOLEAN DEFAULT FALSE,
   description_         IN VARCHAR2 DEFAULT NULL,
   message_grouping_   IN BINARY_INTEGER DEFAULT dbms_aqadm.NONE,
   show_info_  IN BOOLEAN  DEFAULT FALSE)
IS
   tab_name_   VARCHAR2(ORA_MAX_NAME_LEN);
   app_owner_  VARCHAR2(30) := Sys_Context('USERENV', 'CURRENT_SCHEMA');
BEGIN
   IF LENGTH(queue_name_) > 20 THEN
      Show_Message___( 'Create_Oracle_AQ error: Queue name, ' || queue_name_ || ' too long. Must be less than 20 characters');
      RETURN;   
   END IF;
   IF table_name_ IS NULL THEN
      tab_name_ := queue_name_ || '_TAB';
   ELSE
      tab_name_ := table_name_;
   END IF;
   
   Dbms_Aqadm.Create_Queue_Table(queue_table => tab_name_,
                                 queue_payload_type => message_struct_name_,
                                 multiple_consumers => multiple_consumers_,
                                 comment => description_,
                                 message_grouping => message_grouping_);
   Dbms_Aqadm.Create_Queue(queue_name => queue_name_,
                           queue_table => tab_name_);
   IF (Show_Info___(show_info_) = TRUE) THEN
      Show_Message___('Create_Oracle_AQ: Queue ' || queue_name_ || ' created.');
   END IF;
   IF start_queue_ THEN
      Dbms_Aqadm.Start_Queue(app_owner_ || '.' || queue_name_);
   END IF;
END Create_Oracle_AQ;   

@UncheckedAccess   
PROCEDURE Create_Or_Replace_Oracle_AQ(
   queue_name_   IN VARCHAR2,
   message_struct_name_ IN VARCHAR2,
   message_struct_ IN ColumnTabType,
   table_name_   IN VARCHAR2 DEFAULT NULL,
   start_queue_  IN BOOLEAN DEFAULT FALSE,
   multiple_consumers_ IN BOOLEAN DEFAULT FALSE,
   description_         IN VARCHAR2 DEFAULT NULL,
   message_grouping_   IN BINARY_INTEGER DEFAULT dbms_aqadm.NONE,
   owner_      IN VARCHAR2 DEFAULT NULL,
   show_info_  IN BOOLEAN  DEFAULT FALSE)
IS
   dependents_ NUMBER;
BEGIN
   IF (Object_Exist ( queue_name_,'QUEUE' ) ) THEN
      Remove_Oracle_AQ(queue_name_,show_info_);
   END IF;
   SELECT COUNT(*) INTO dependents_ FROM user_dependencies where referenced_name = message_struct_name_;
   IF (dependents_ = 0) THEN
      Create_Or_Replace_Type(message_struct_name_,message_struct_,show_info_);
   ELSE
      IF (Show_Info___(show_info_) = TRUE) THEN
         Show_Message___('Create_Or_Replace_Oracle_AQ: Message structure type ' || message_struct_name_ || ' is not dropped.');
      END IF;
   END IF;
   Create_Oracle_AQ(queue_name_ => queue_name_,
                     message_struct_name_ => message_struct_name_,
                     table_name_ => table_name_,
                     start_queue_ => start_queue_,
                     multiple_consumers_ => multiple_consumers_,
                     description_ => description_,
                     message_grouping_ => message_grouping_,
                     show_info_ => show_info_);
END Create_Or_Replace_Oracle_AQ;  

@UncheckedAccess   
PROCEDURE Create_Or_Replace_Oracle_AQ(
   queue_name_   IN VARCHAR2,
   message_struct_name_ IN VARCHAR2,
   table_name_   IN VARCHAR2 DEFAULT NULL,
   start_queue_  IN BOOLEAN DEFAULT FALSE,
   multiple_consumers_ IN BOOLEAN DEFAULT FALSE,
   description_         IN VARCHAR2 DEFAULT NULL,
   message_grouping_   IN BINARY_INTEGER DEFAULT dbms_aqadm.NONE,
   owner_      IN VARCHAR2 DEFAULT NULL,
   show_info_  IN BOOLEAN  DEFAULT FALSE)
IS
BEGIN
   IF (Object_Exist ( queue_name_,'QUEUE' ) ) THEN
      Remove_Oracle_AQ(queue_name_,show_info_);
   END IF;
   Create_Oracle_AQ(queue_name_ => queue_name_,
                     message_struct_name_ => message_struct_name_,
                     table_name_ => table_name_,
                     start_queue_ => start_queue_,
                     multiple_consumers_ => multiple_consumers_,
                     description_ => description_,
                     message_grouping_ => message_grouping_,
                     show_info_ => show_info_);
END Create_Or_Replace_Oracle_AQ;

PROCEDURE Register_Sub_Section (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   sub_section_   IN NUMBER  DEFAULT 1,
   processed_ok_  IN VARCHAR2,
   status_info_   IN VARCHAR2 DEFAULT NULL,
   file_name_     IN VARCHAR2 DEFAULT NULL,
   description_   IN VARCHAR2 DEFAULT NULL )
IS
   stmt_  VARCHAR2(4000);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   stmt_ :=
   'BEGIN '||
   '   INSERT INTO db_script_register_tab '||
   '   (module, register_id, processed_ok, no_sub_sections, file_name, rowversion, rowkey) '||
   '   VALUES '||
   '   (UPPER(:module_), :register_id_, ''FALSE'', 0, :file_name_, sysdate, sys_guid()); '||
   'EXCEPTION '||
   '   WHEN dup_val_on_index THEN '||
   '      NULL; '||
   'END; ';
   @ApproveDynamicStatement(2015-06-30,mabose)
   EXECUTE IMMEDIATE stmt_ USING module_, register_id_, file_name_;

   stmt_ :=
   'DECLARE '||
   '   module_        db_script_register_detail_tab.module%TYPE := UPPER(:module); '||
   '   register_id_   db_script_register_detail_tab.register_id%TYPE  := :register_id; '||
   '   sub_section_   db_script_register_detail_tab.sub_section%TYPE := :sub_section; '||
   '   processed_ok_  db_script_register_detail_tab.processed_ok%TYPE := :processed_ok; '||
   '   description_   db_script_register_detail_tab.description%TYPE := :description; '||
   '   status_info_   db_script_register_detail_tab.status_info%TYPE := :status_info; '||
   'BEGIN '||
   '   INSERT INTO db_script_register_detail_tab '||
   '      (module, register_id, sub_section, processed_ok, description, status_info, rowversion, rowkey) '||
   '   VALUES '||
   '      (module_, register_id_, sub_section_, NVL(processed_ok_, ''FALSE''), description_, status_info_, sysdate, sys_guid()); '||
   '   UPDATE db_script_register_tab '||
   '   SET no_sub_sections = NVL(no_sub_sections, 0) + 1, '||
   '       rowversion = sysdate '||
   '   WHERE module = module_ '||
   '   AND   register_id = register_id_; '||
   'EXCEPTION '||
   '   WHEN dup_val_on_index THEN '||
   '      UPDATE db_script_register_detail_tab '||
   '      SET processed_ok = processed_ok_, '||
   '          description = NVL(description_, description), '||
   '          status_info = status_info_, '||
   '          rowversion = sysdate '||
   '      WHERE module = module_ '||
   '      AND   register_id = register_id_ '||
   '      AND   sub_section = sub_section_; '||
   'END;';
   @ApproveDynamicStatement(2015-06-30,mabose)
   EXECUTE IMMEDIATE stmt_ USING module_, register_id_, sub_section_, processed_ok_, description_, status_info_;
   
   stmt_ :=
   'DECLARE '||
   '   module_        db_script_register_detail_tab.module%TYPE := UPPER(:module); '||
   '   register_id_   db_script_register_detail_tab.register_id%TYPE  := :register_id; '||
   '   processed_ok_  db_script_register_detail_tab.processed_ok%TYPE; '||
   'BEGIN '||
   '   SELECT MIN(processed_ok) '||
   '   INTO processed_ok_ '||
   '   FROM db_script_register_detail_tab '||
   '   WHERE module = module_ '||
   '   AND register_id = register_id_; '||
   '   UPDATE db_script_register_tab '||
   '   SET processed_ok = NVL(processed_ok_, ''FALSE''), '||
   '       rowversion = sysdate '||
   '   WHERE module = module_ '||
   '   AND   register_id = register_id_; '||
   'END;';
   @ApproveDynamicStatement(2015-06-30,mabose)
   EXECUTE IMMEDIATE stmt_ USING module_, register_id_;

   @ApproveTransactionStatement(2015-06-30,mabose)
   COMMIT;
END Register_Sub_Section;

PROCEDURE Clear_Sub_Section (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   sub_section_   IN NUMBER )
IS
   stmt_  VARCHAR2(4000);
   PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
   stmt_ :=
   'DECLARE '||
   '   module_        db_script_register_detail_tab.module%TYPE := UPPER(:module); '||
   '   register_id_   db_script_register_detail_tab.register_id%TYPE  := :register_id; '||
   '   sub_section_   db_script_register_detail_tab.sub_section%TYPE := :sub_section; '||
   'BEGIN '||
   '   DELETE FROM db_script_register_detail_tab '||
   '      WHERE module = module_ '||
   '      AND   register_id = register_id_ '||
   '      AND   sub_section = sub_section_; '||
   '   UPDATE db_script_register_tab '||
   '   SET no_sub_sections = GREATEST((NVL(no_sub_sections, 0) - 1), 0), '||
   '       rowversion = sysdate '||
   '   WHERE module = module_ '||
   '   AND   register_id = register_id_; '||
   'EXCEPTION '||
   '   WHEN no_data_found THEN '||
   '      NULL; '||
   'END;';
   @ApproveDynamicStatement(2015-06-30,mabose)
   EXECUTE IMMEDIATE stmt_ USING module_, register_id_, sub_section_;

   stmt_ :=
   'DECLARE '||
   '   module_        db_script_register_detail_tab.module%TYPE := UPPER(:module); '||
   '   register_id_   db_script_register_detail_tab.register_id%TYPE  := :register_id; '||
   '   processed_ok_  db_script_register_detail_tab.processed_ok%TYPE; '||
   'BEGIN '||
   '   SELECT MIN(processed_ok) '||
   '   INTO processed_ok_ '||
   '   FROM db_script_register_detail_tab '||
   '   WHERE module = module_ '||
   '   AND register_id = register_id_; '||
   '   UPDATE db_script_register_tab '||
   '   SET processed_ok = NVL(processed_ok_, ''FALSE''), '||
   '       rowversion = sysdate '||
   '   WHERE module = module_ '||
   '   AND   register_id = register_id_; '||
   'END;';
   @ApproveDynamicStatement(2015-06-30,mabose)
   EXECUTE IMMEDIATE stmt_ USING module_, register_id_;

   @ApproveTransactionStatement(2015-06-30,mabose)
   COMMIT;
END Clear_Sub_Section;


@UncheckedAccess
FUNCTION Is_Sub_Section_Registered (
   module_        IN VARCHAR2,
   register_id_   IN VARCHAR2,
   sub_section_   IN VARCHAR2 ) RETURN BOOLEAN
IS
   stmt_              VARCHAR2(4000);
   sub_section_exist_ VARCHAR2(5);
BEGIN
   IF Method_Exist ('Db_Script_Register_Detail_API', 'Is_Sub_Section_Registered') THEN
      stmt_ :=
      'DECLARE '||
      '   sub_section_exist_ VARCHAR2(5); '||
      'BEGIN '||
      '   IF Db_Script_Register_Detail_API.Is_Sub_Section_Registered(:module_, :register_id_, :sub_section_) THEN'||
      '      :sub_section_exist_ := ''TRUE''; '||
      '   ELSE '||
      '      :sub_section_exist_ := ''FALSE''; '||
      '   END IF; '||
      'END;';
      @ApproveDynamicStatement(2015-06-30,mabose)
      EXECUTE IMMEDIATE stmt_ USING module_, register_id_, sub_section_, OUT sub_section_exist_;
      IF sub_section_exist_ = 'TRUE' THEN
         RETURN TRUE;
      ELSE
         RETURN FALSE;
      END IF;
   ELSE
      RETURN FALSE;
   END IF;
END Is_Sub_Section_Registered;

PROCEDURE Log_Execution_Errors (
   module_      IN VARCHAR2,
   register_id_ IN VARCHAR2,
   raise_       IN BOOLEAN DEFAULT FALSE )
IS
   stmt_ VARCHAR2(4000);
BEGIN
   stmt_ :=
   'DECLARE '||
   '   module_        db_script_register_detail_tab.module%TYPE := UPPER(:module); '||
   '   register_id_   db_script_register_detail_tab.register_id%TYPE  := :register_id; '||
   '   error_counter_ NUMBER := 0; '||
   '   CURSOR check_if_error IS '||
   '      SELECT sub_section, status_info '||
   '        FROM db_script_register_detail_tab '||
   '       WHERE module = module_ '||
   '         AND register_id = register_id_ '||
   '         AND processed_ok <> ''TRUE'' '||
   '      AND EXISTS (SELECT 1 '||
   '                   FROM db_script_register_tab '||
   '                   WHERE module = module_ '||
   '                     AND register_id = register_id_ '||
   '                     AND processed_ok <> ''TRUE''); '||
   'BEGIN '||
   '   FOR error_line_ IN check_if_error LOOP '||
   '      IF error_counter_ < 1 THEN '||
   '         dbms_output.put_line(''Error when deploying script [''||module_||''] - [''||register_id_||'']''); '||
   '      END IF; '||
   '      error_counter_ := error_counter_ + 1; '||
   '      dbms_output.put_line(''Sub Section: '' || error_line_.sub_section || '' '' || error_line_.status_info); '||
   '   END LOOP; '||
   '   IF (error_counter_ > 0) THEN '||
   '      IF :raise_ THEN '||
   '         Raise_Application_Error(-20105, error_counter_||'' error(s) occured when deploying script [''||module_||''] - [''||register_id_||'']. See installation log for more details''); '||
   '      END IF; '||
   '   ELSE '||
   '      dbms_output.put_line(''No errors when deploying script [''||module_||''] - [''||register_id_||'']''); '||
   '   END IF; '||
   'END;';
   @ApproveDynamicStatement(2015-06-30,mabose)
   EXECUTE IMMEDIATE stmt_ USING module_, register_id_, raise_;
END Log_Execution_Errors;

PROCEDURE Reset_Module_Delivery_Flags
IS
   stmt_   VARCHAR2(32000) := '
BEGIN
   Module_API.Reset_Module_Delivery_Flags;
END;';
BEGIN
   -- Safe due to executed with Invokers rights
   @ApproveDynamicStatement(2017-10-02,mabose)
   EXECUTE IMMEDIATE stmt_;
END Reset_Module_Delivery_Flags;

BEGIN
   log_time_stamp_ := 'FALSE';
   gc_persistent_   := 'FALSE';
END;
