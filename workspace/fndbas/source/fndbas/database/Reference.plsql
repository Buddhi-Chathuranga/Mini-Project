-----------------------------------------------------------------------------
--
--  Logical unit: Reference
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  950815  STLA  Created.
--  950831  ERFO  Changes in call to System_General to include method name.
--  950901  ERFO  Changes in Check_Restricted_Delete to handle no parent keys.
--  950903  ERFO  Changed in call to Any_PLSQL_Ref___:
--                   - Changed parameter 'ref_name_' to 'ref.table_name'
--                   - Added concatenation '_API
--  950905  ERFO  Increased size of variable stmt_ in Any_PLSQL_Ref___ to 100.
--  950911  ERFO  Changed ref_name to view_name_ in Restricted_SQL_Ref___.
--  950912  ERFO  Added documentation headers and examples.
--  950913  STLA  Removed separator declaration
--  950915  STLA  Added view name to Get_LOV_Properties
--  951003  STLA  Added language translations in Get_LOV_Properties
--  951005  STLA  Modified Get_LOV_Properties to take view as in argument.
--  951006  ERFO  Removed dependencies to Get_View_Logical_Unit_.
--  951030  STLA  Added call to Dictionary_SYS.Get_Logical_Unit_Method_ to get
--                correct name before calling custom reference procedure
--  951107  STLA  Modified Get_LOV_Properties to include formatting info
--  951130  ERFO  Increased maximum length for each key value from 30 to 100.
--                The changes concerned method Restricted_SQL_Ref___.
--  951108  STLA  Calling references package for custom reference.
--                Reads Reference_SYS_TAB instead of dictionary (Bug #284).
--  951218  ERFO  Corrected co-operation with Language_SYS concerning
--                translated attributes prompts in a LOV (Bug #303).
--  960111  ERFO  Changed behaviour when active list is corrupt by trying
--                to update the active list when the check is made.
--  960409  ERFO  Changes in method Get_LOV_Properties not to include parent
--                keys in the column list, but in the key list (Bug #482).
--  960416  ERFO  Implemented additional reference option CASCADE by using
--                the new implementation methods Run_Cascade_Candidates and
--                Cascade_PLSQL_Operation___ (Idea #496).
--  960416  ERFO  Added check of the CASCADE-option when refreshing active list
--                and solved some old problems with error messages (Bug #470).
--  960416  ERFO  Added method Set_Reference_Trace for server traces (Idea #495).
--  960508  STLA  Modified method Get_LOV_Properties to always include keys.
--  960508  ERFO  Changed WHERE-clause in Check_Restricted_Delete and changed
--                some error messages to be translatable.
--  960521  ERFO  Added dummy parameters to methods for the active list.
--  960719  ERFO  Added method Get_IID_Properties for optimal performance
--                when querying IID-columns from the IFS/Client (Idea #685).
--  960911  ERFO  Added timestamp information to trace messages (Idea #586).
--  960911  ERFO  Added method Init to make it possible to initiate the
--                package from General_SYS.Init_Session (Idea #684).
--  960918  ERFO  Added filter for views used by IFS/Info Services (Idea #804).
--  960918  ERFO  Changes in Get_LOV_Properties which let the L-flag stear
--                the appearance of parent keys in LOV-dialogs (Bug #805).
--  961028  MANY  Improved filter for reports, and removed empty REF values.
--  961125  ERFO  Fixed problem with Check_Active_List__ always returning TRUE.
--  961211  ERFO  The exception message in method Refresh_Active_List__ does
--                now contain view and column information (Bug #895).
--  970122  ERFO  Removed or decreased all limitations on the reference
--                functionality for restricted delete and cascade (Bug #943).
--  970213  ERFO  Added cache setup for cache checking tasks (Bug #986).
--  970411  ERFO  Changed parameter setup handling according to new settings
--                in logical unit FoundationSetting in release 2.0.
--  970423  ERFO  Changed name to Fnd_Setting_API.
--  970514  ERFO  Solved problem with replaced error texts when raising errors
--                in method Refresh_Active_List__ (Bug #1166).
--  970626  ERFO  Additional setup information for cache references.
--  970708  ERFO  Corrections in info-parameter to Error_SYS.Record_Constraint
--                to let the view be replaced by the LU-description (Bug #1496).
--  970709  ERFO  Added new restricted reference option 'CUSTOMLIST' to support
--                PL/SQL interfaces with separated key parameters (ToDo #1495).
--  970721  ERFO  Improved error message when refreshing active list.
--  970722  ERFO  Correction regarding functionality of option CUSTOMLIST.
--  970723  ERFO  Removed tag in method Get_Lov_Properties concerning cursor
--                including column condition on 'OBJID' (ToDo #1516).
--  970729  ERFO  Solved problem in Get_Lov_Properties which should not include
--                columns (such as _DB) with NULL as column comment (Bug #1534).
--  971022  ERFO  Refresh only be run as application owner (ToDo #1286).
--  971027  ERFO  Changed implementation of reference check setup (ON/OFF).
--  971128  ERFO  Improved trace messages for reference actions (ToDo #1835).
--  971218  ERFO  Added functionality in methods Get_Lov_Properties and
--                Refresh_Active_List__ to ensure that certain OBJ-columns
--                will appear in the LOV-dialog or in the reference system.
--  971222  ERFO  Added method Get_Lov_Properties_ with sort info (ToDo #1633).
--  980121  ERFO  Added method Get_View_Reference_Info_ (ToDo #2035).
--  980827  ERFO  Cursor changes not to include Dictionary_SYS-function (ToDo #2655).
--  990202  ERFO  Correction in Cascade_PLSQL_Operation___ to solve cascade
--                situations where info/warnings have been used (Bug #3116).
--  990222  ERFO  Yoshimura: Changes in Refresh_Active_List__ and methods
--                Get_Lov_Properties_, Get_View_Reference_Info_ (ToDo #3160).
--  990309  PANA  Changed local variable size in Restricted_SQL_Ref___
--                and Run_Cascade_Candidates___ (Bug #3215).
--  990430  ERFO  Performance solution in refresh (Bug #3336).
--  990706  ERFO  Changed parameter in Refresh_Active_List__ and added
--                optional view- and module-based refresh (ToDo #3146).
--  000511  ROOD  Added method Get_View_Properties (ToDo #3890).
--  000906  ROOD  Ensured the column order in Get_View_Properties
--                and Get_Lov_Properties (Bug #17354).
--  001211  ERFO  Get use of new view FND_TAB_COMMENTS (Bug #18169).
--  010103  STDA  Added method Refresh_Database_Objects__ (ToDo #3960).
--  010111  ROOD  Included handling of keys with ' in Any_PLSQL_Ref___ (Bug#17991).
--  010905  ROOD  Modifed Put_Trace to avoid line length overflow (Bug#24142).
--  011122  ROOD  Replaced usage of user_col_comments with fnd_col_comments (Bug#26328).
--  020226  ROOD  Corrected removal of data in Refresh_Active_List__ when
--                refreshing a single component (Bug#28234).
--  020527  ROOD  Modified Any_PLSQL_Ref___ to use bind variables for option
--                CUSTOMLIST (Bug#30436).
--  020701  ROOD  Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  020829  ROOD  Made Get_View_Reference_Info_ handle more than one reference (Bug#15316).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  030218  ROOD  Removed hardcoded FNDSER in a message (ToDo#4149).
--  030624  ROOD  Improved error message in Run_Cascade_Candidates___ (ToDo#4273).
--  030626  ROOD  Added more info to error raised in Check_Restricted_Delete (ToDo#4204).
--  040331  HAAR  Unicode bulk changes,
--                extended 1 bind variable length 10 times in Run_Cascade_Candidates___(F1PR408B).
--  040407  HAAR  Unicode bulk changes,
--                extended 2 define variables length in Run_Cascade_Candidates___ (F1PR408B).
--  040707  ROOD  Modifications in usage of Dictionary_SYS (F1PR413).
--  040914  ROOD  Used Dictionary information to improve performance of cache refresh (F1PR413).
--  040916  ROOD  Only rely on Dictionary information when checking reference methods, correction
--                in Parse_Ref_Value___ to make this possible. Modified the status check of
--                Dictionary cache, Make the call and let Dictionary abort if up-to-date (F1PR413).
--  040917  ROOD  Renamed column lu_name to view_name in reference_sys_tab (F1PR413).
--  040923  ROOD  Changed implementation of most get-methods to use dictionary information
--                for performance reasons, also modified Cascade_PLSQL_Operation___
--                and Check_Active_List__ (F1PR413).
--  041025  ROOD  Added trace about objects that didn't compile in Refresh_Database_Objects__.
--  050404  JORA  Added assertion for dynamic SQL.  (F1PR481)
--  050413  JORA  Added more assertion for dynamic SQL.  (F1PR481)
--  050704  UTGULk Modified Refresh_Active_List__ for fault tolerance(F1PR480).
--  060105  UTGULK Annotated Sql injection.
--  060302  RAKU  Extended parameters in Get_Lov_Properties_ (Bug#55575).
--  060517  SUKM  Added code in Do_Cascase_Delete() to remove object connections (Bug#56013)
--  070712  SUMA  Deleted REF_CACHE_CHECK and its references.(F1PR499).
--  080208  HAARSE Added update of Cache Management when refreshing the cache (Bug#71136).
--  080424  HAARSE Added support for Notes in Do_Cascade_Delete (Bug#72847).
--  080923  HASPLK Modified method Refresh_Database_Objects__ to refresh invalid Materialized Views and Java Classes. (Bug#76585)
--  090713  NABALK Increase the size of objversion_ to VARCHAR2(4000)
--                 in Run_Cascade_Candidates___ (Bug#84689).
--  090730  HASPLK Modified method Run_Cascade_Candidates___() and Restricted_SQL_Ref___().
--                 Added support for use more than 10 parent keys.
--  100405  UsRaLK Modified method [Get_View_Reference_Info_] to exclude key fetching of self reference (Bug#89121).
--  100618  NaBaLK Changed the method of finding the LU of a view in Get_View_Reference_Info_ (bug#91443)
--  110809  NaBaLK Changed the method of finding the LU prompt of a view in Check_Restricted_Delete (Bug#94177)
--  141213  ChMuLK Added method Get_Lov_Properties__ (Bug#119398/TEBASE-763).
--  1900801 NiDalk Added method Get_Lov_Properties_With_P_Keys to return column properties including parent columns. (Bug#148997/SCZCRM-592).
-----------------------------------------------------------------------------
--
--  Dependencies: Client_SYS
--                Language_SYS
--                Error_SYS
--                Dictionary_SYS
--
--  Contents:     Implementation methods for retrieval of attribute comment values
--                Implementation methods for reference control using dynamic PL/SQL
--                Private methods for installation/system management related tasks
--                Protected methods for reference client list of value purposes
--                Public methods for reference constraint enforcing
--                Public methods for data source properties used by IFS/Client
--                Public methods for reference trace activation in the server
--
-----------------------------------------------------------------------------
--
--  Syntax:  REF=lu-name[(key1[,key2 ... ,keyN])][/option[=(checkPL,doPL)]]
--
--           1. lu-name      Name of logical unit being referenced.
--           2. key1...keyN  Name of own columns matching the key columns of the
--                           referenced logical unit.
--           3. option       How the reference should work for delete operations
--                           are described below
--
--              A. RESTRICTED   Restricted delete. This is the default option
--                              and will be used if no option is given.
--              B. NOCHECK      The reference will not be checked.
--              C. CASCADE      Call to Private Remove__ for actions CHECK and DO.
--              D. CUSTOM       Points to userwritten PL/SQL procedures that
--                              must be declared in the referenced logical unit.
--                 1. checkPL   Executed in order to check the reference.
--                 2. doPL      Executed in order to cascade the reference.
--
--  Limitations:  Maximum number of keys are 5
--                Maximum length for each key value is 100
--                Option CASCADE requires name convention between view and package.
--                Option CASCADE must be referenced by a parent key column
--                One CASCADE-reference only for parent keys in the same base view
--                Active constraints will result in deletion in invalid order (*)
--
--                (*) A work-around for active foreign key constraints is to
--                    change the call to Do_Cascade_Delete to be placed before
--                    the ordinary DELETE-statement for this logical unit
-----------------------------------------------------------------------------

layer Foundation1;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Key_And_Value___
--   Finds a key name and its value given a keylist, a valuelist and
--   an index number.
FUNCTION Get_Key_And_Value___ (
   lu_name_ IN  VARCHAR2,
   keys_    IN  VARCHAR2,
   values_  IN  VARCHAR2,
   index_   IN  NUMBER,
   key_     OUT VARCHAR2,
   value_   OUT VARCHAR2 ) RETURN BOOLEAN
IS
   from_       NUMBER;
   to_         NUMBER;
BEGIN
   -- Find out if requested index exists
   IF (index_=1) THEN
      from_ := 1;
      to_   := instr(keys_, ',', 1, index_);
   ELSE
      from_ := instr(keys_, ',', 1, index_-1) + 1;
      to_   := instr(keys_, ',', 1, index_);
   END IF;
   IF (to_ > 0) THEN
      -- If found, return requested key and value
      key_ := substr(keys_, from_, to_-from_);
      IF (index_=1) THEN
         from_ := 1;
         to_   := instr(values_, '^', 1, index_);
      ELSE
         from_ := instr(values_, '^', 1, index_-1) + 1;
         to_   := instr(values_, '^', 1, index_);
      END IF;
      value_ := substr(values_, from_, to_-from_);
      -- Check if table column differs from view column
      key_ := Get_Column_Name___(lu_name_, key_);
      RETURN(TRUE);
   ELSE
      -- If not found, return false
      RETURN(FALSE);
   END IF;
END Get_Key_And_Value___;


-- Comment_Value___
--   Find the value of an individual comment item given the keyword.
--   (e.g. given 'REF' returns 'X(Y)/Z' from comment '..^REF=X(Y)/Z^..')
FUNCTION Comment_Value___ (
   name_    IN VARCHAR2,
   comment_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   nlen_ NUMBER;
   from_ NUMBER;
   to_   NUMBER;
BEGIN
   -- Find keyword name position within comment
   nlen_ := length(name_);
   from_ := instr(upper(comment_), name_||'=');
   -- If found, return value from comment
   IF (from_ > 0) THEN
      to_ := instr(comment_, '^', from_);
      IF (to_ = 0) THEN
        to_ := length(comment_)+1;
      END IF;
      RETURN(substr(comment_, from_+nlen_+1, to_-from_-nlen_-1));
   -- If not found, return null value
   ELSE
      RETURN(NULL);
   END IF;
END Comment_Value___;


FUNCTION Get_Column_Name___ (
   lu_name_    IN VARCHAR2,
   column_name_   IN VARCHAR2 ) RETURN VARCHAR2
IS
   ref_base_   VARCHAR2(30) := Dictionary_SYS.Get_Reference_Base(lu_name_);
BEGIN
   IF (ref_base_ = 'TABLE') THEN
      RETURN(Nvl(Dictionary_SYS.Get_Lu_Table_Column_Impl(lu_name_, Upper(column_name_)), column_name_));
   ELSE -- View
      RETURN(column_name_);
   END IF;
END Get_Column_Name___;


FUNCTION Get_Object_Name___ (
   lu_name_    IN VARCHAR2 ) RETURN VARCHAR2
IS
   ref_base_   VARCHAR2(30) := Dictionary_SYS.Get_Reference_Base(lu_name_);
BEGIN
   IF (ref_base_ = 'TABLE') THEN
      RETURN(Dictionary_SYS.Get_Base_Table_Name(lu_name_));
   ELSE -- View
      RETURN(Dictionary_SYS.Get_Base_View(lu_name_));
   END IF;
END Get_Object_Name___;


-- Parse_Ref_Value___
--   Parses any valid reference value string into its individual parts.
PROCEDURE Parse_Ref_Value___ (
   full_ref_    IN  VARCHAR2,
   ref_name_    OUT VARCHAR2,
   parent_keys_ OUT VARCHAR2,
   option_      OUT VARCHAR2,
   optarg1_     OUT VARCHAR2,
   optarg2_     OUT VARCHAR2 )
IS
   len_   NUMBER;
   from_  NUMBER;
   to_    NUMBER;
   part1_ VARCHAR2(2000);
   part2_ VARCHAR2(2000);
BEGIN
   -- Split full reference into reference part and option part
   len_  := length(full_ref_);
   from_ := instr(full_ref_, '/');
   IF (from_ > 0) THEN
      part1_ := substr(full_ref_, 1, from_-1);
      part2_ := substr(full_ref_, from_+1, len_-from_);
   ELSE
      part1_ := full_ref_;
      part2_ := 'RESTRICTED';
   END IF;
   -- Split reference part into parent keys
   len_  := length(part1_);
   from_ := instr(part1_, '(');
   IF (from_ > 0) THEN
      ref_name_ := substr(part1_, 1, from_-1);
      parent_keys_ := substr(part1_, from_+1, len_-from_-1);
   ELSE
      ref_name_ := part1_;
      parent_keys_ := null;
   END IF;
   -- Split option part into option and arguments
   len_  := length(part2_);
   from_ := instr(part2_, '=');
   to_   := instr(part2_, ',');
   IF (from_ > 0) THEN
      option_  := upper(substr(part2_, 1, from_-1));
      optarg1_ := substr(part2_, from_+2, to_-from_-2);
      optarg2_ := ltrim(substr(part2_, to_+1, len_-to_-1));
   ELSE
      option_  := upper(part2_);
      optarg1_ := NULL;
      optarg2_ := NULL;
   END IF;
END Parse_Ref_Value___;


FUNCTION Get_Db_Value___ (
   lu_name_ IN  VARCHAR2,
   keys_    IN  VARCHAR2,
   values_  IN  VARCHAR2,
   index_   IN  NUMBER,
   column_name_  IN VARCHAR2,
   db_column_name_ IN VARCHAR2,
   client_value_ IN VARCHAR2 )   RETURN VARCHAR2
IS
   TYPE ref_cur_type_ IS REF CURSOR;

   key_name_      VARCHAR2(200);
   key_value_     VARCHAR2(4000);
   key_datatype_  VARCHAR2(30);

   package_name_  VARCHAR2(30);
   view_name_     VARCHAR2(30) := Dictionary_SYS.Get_Base_View(lu_name_);
   db_value_      VARCHAR2(10000);
   stmt_          VARCHAR2(4000);
   i_             BINARY_INTEGER := 1;

   get_db_value_ ref_cur_type_;

   --SOLSETFW
   CURSOR get_datatype IS
      SELECT column_datatype
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_name_
      AND    column_name = column_name_;
BEGIN
   package_name_ := Dictionary_SYS.Get_Base_Package(Dictionary_SYS.Get_Enumeration_Lu(view_name_, column_name_));
   -- Try to fetch db value with execute PL/SQL encode stmt
   Assert_SYS.Assert_Is_Package(package_name_);
   stmt_ := 'BEGIN :dbvalue := '||package_name_||'.Encode(:keyvalue); END;';
   BEGIN
   -- Fetch dbvalue
   @ApproveDynamicStatement(2011-05-30,krguse)
   EXECUTE IMMEDIATE stmt_ USING OUT db_value_, IN client_value_;
   -- If dbvalue is not null then return value and exit
   -- else continue with sql statement
   IF db_value_ IS NOT NULL THEN
      RETURN(db_value_);
   END IF;
   EXCEPTION -- Continue to next try to find the db_value
      WHEN OTHERS THEN
         NULL;
   END;
   Assert_SYS.Assert_Is_View_Column(view_name_,db_column_name_);
   Assert_SYS.Assert_Is_View(view_name_);
   -- Try to find db value with SQL statement
   stmt_ := 'SELECT /*+ FIRST_ROWS(1) */ ' || db_column_name_ || ' FROM ' || view_name_ || ' WHERE ';
   WHILE (i_ < index_ AND Get_Key_And_Value___ (lu_name_, keys_, values_, i_, key_name_, key_value_) = TRUE) LOOP
      Assert_SYS.Assert_Is_View_Column(view_name_,key_name_);

      --This one should probably be here, but we have not been able to test it
      --Assert_SYS.Encode_Single_Quote_String(key_value_);

      -- Get the datatype for the column
      OPEN  get_datatype;
      FETCH get_datatype INTO key_datatype_;
      CLOSE get_datatype;
      IF (upper(key_datatype_) LIKE 'DATE%') THEN
         stmt_ := stmt_ || key_name_ || ' = to_date(''' || key_value_ || ')'' AND ';
      ELSIF (upper(key_datatype_) LIKE 'NUMBER%') THEN
         stmt_ := stmt_ || key_name_ || ' = ' || key_value_ || ' AND ';
      ELSE -- Everything else is treated like String
         stmt_ := stmt_ || key_name_ || ' = ''' || key_value_ || ''' AND ';
      END IF;
      i_ := i_ + 1;
   END LOOP;
   stmt_ := stmt_ || column_name_ || '= :keyvalue ';
   @ApproveDynamicStatement(2011-05-30,krguse)
   OPEN  get_db_value_ FOR stmt_ USING client_value_;
   FETCH get_db_value_ INTO db_value_;
   CLOSE get_db_value_;
   RETURN(db_value_);
END Get_Db_Value___;


-- Put_Trace___
--   Method to be used for trace outprints for enhanced debug info.
PROCEDURE Put_Trace___ (
   text_ IN VARCHAR2 )
IS
   msg_ VARCHAR2(2000);
BEGIN
   msg_ := 'REFERENCE' || Log_SYS.Get_Separator || ' '||text_||'('||to_char(dbms_utility.get_time)||')';
   -- Avoid line length overflow in dbms_output (ORU-10028)
   WHILE length(msg_) > 255 LOOP
      Log_SYS.Fnd_Trace_(Log_SYS.debug_, substr(msg_, 1, 255));
      msg_ := substr(msg_, 256);
   END LOOP;
   Log_SYS.Fnd_Trace_(Log_SYS.debug_, msg_);
END Put_Trace___;


-- Restricted_SQL_Ref___
--   Performs a restricted referemce using dynamic SQL given all
--   necessary data to form the actual SQL statement.
--   view_name_ can be either the view or the base table depending on the scenario
--   ref_view_ always gives the VIEW
FUNCTION Restricted_SQL_Ref___ (
   lu_name_   IN VARCHAR2,
   view_name_ IN VARCHAR2,
   keys_      IN VARCHAR2,
   values_    IN VARCHAR2,
   ref_view_  IN VARCHAR2) RETURN NUMBER
IS
   cursor_      NUMBER;
   stmt_        VARCHAR2(2000);   
   key_         VARCHAR2(2000);
   value1_      VARCHAR2(2000);
   value2_      VARCHAR2(2000);
   value3_      VARCHAR2(2000);
   value4_      VARCHAR2(2000);
   value5_      VARCHAR2(2000);
   value6_      VARCHAR2(2000);
   value7_      VARCHAR2(2000);
   value8_      VARCHAR2(2000);
   value9_      VARCHAR2(2000);
   value10_     VARCHAR2(2000);
   value11_     VARCHAR2(2000);
   value12_     VARCHAR2(2000);
   value13_     VARCHAR2(2000);
   value14_     VARCHAR2(2000);
   value15_     VARCHAR2(2000);
   cnt_         NUMBER;
   dic_rec_     dictionary_sys_tab%ROWTYPE;
   is_based_on_ BOOLEAN := FALSE;
BEGIN
   -- Form SQL statement
   IF (Dictionary_SYS.Get_Reference_Base(lu_name_) = 'TABLE') THEN
      Assert_SYS.Assert_Is_Table(view_name_);
      -- No need to add this filter for the references based on views,assuming that it is already added.
      dic_rec_ := Dictionary_SYS.Get_Dictionary_Record(lu_name_);
      IF ((dic_rec_.based_on IS NOT NULL) AND (dic_rec_.based_on_filter IS NOT NULL)) THEN
         is_based_on_ := TRUE;
      END IF;
   ELSE
      Assert_SYS.Assert_Is_View(view_name_);
   END IF;
   stmt_ := 'SELECT COUNT(*) FROM '||view_name_;
   IF (Get_Key_And_Value___(lu_name_, keys_, values_, 1, key_, value1_)) THEN
      IF(NOT Dictionary_SYS.Is_Lookup_List_Column(ref_view_, key_)) THEN
         stmt_ := stmt_||' WHERE '||key_||' = :value1_';
      ELSE
         stmt_ := stmt_||' WHERE '||key_||' Like ''%'||Client_SYS.text_separator_||'''||:value1_||'''||Client_SYS.text_separator_||'%''';
      END IF;
      cnt_ := 1;
      IF (Get_Key_And_Value___(lu_name_, keys_, values_, 2, key_, value2_)) THEN
         stmt_ := stmt_||' AND '||key_||' = :value2_';
         cnt_ := 2;
         IF (Get_Key_And_Value___(lu_name_, keys_, values_, 3, key_, value3_)) THEN
            stmt_ := stmt_||' AND '||key_||' = :value3_';
            cnt_ := 3;
            IF (Get_Key_And_Value___(lu_name_, keys_, values_, 4, key_, value4_)) THEN
               stmt_ := stmt_||' AND '||key_||' = :value4_';
               cnt_ := 4;
               IF (Get_Key_And_Value___(lu_name_, keys_, values_, 5, key_, value5_)) THEN
                  stmt_ := stmt_||' AND '||key_||' = :value5_';
                  cnt_ := 5;
                  IF (Get_Key_And_Value___(lu_name_, keys_, values_, 6, key_, value6_)) THEN
                     stmt_ := stmt_||' AND '||key_||' = :value6_';
                     cnt_ := 6;
                     IF (Get_Key_And_Value___(lu_name_, keys_, values_, 7, key_, value7_)) THEN
                        stmt_ := stmt_||' AND '||key_||' = :value7_';
                        cnt_ := 7;
                        IF (Get_Key_And_Value___(lu_name_, keys_, values_, 8, key_, value8_)) THEN
                           stmt_ := stmt_||' AND '||key_||' = :value8_';
                           cnt_ := 8;
                           IF (Get_Key_And_Value___(lu_name_, keys_, values_, 9, key_, value9_)) THEN
                              stmt_ := stmt_||' AND '||key_||' = :value9_';
                              cnt_ := 9;
                              IF (Get_Key_And_Value___(lu_name_, keys_, values_, 10, key_, value10_)) THEN
                                 stmt_ := stmt_||' AND '||key_||' = :value10_';
                                 cnt_ := 10;
                                 IF (Get_Key_And_Value___(lu_name_, keys_, values_, 11, key_, value11_)) THEN
                                    stmt_ := stmt_||' AND '||key_||' = :value11_';
                                    cnt_ := 11;
                                    IF (Get_Key_And_Value___(lu_name_, keys_, values_, 12, key_, value12_)) THEN
                                       stmt_ := stmt_||' AND '||key_||' = :value12_';
                                       cnt_ := 12;
                                       IF (Get_Key_And_Value___(lu_name_, keys_, values_, 13, key_, value13_)) THEN
                                          stmt_ := stmt_||' AND '||key_||' = :value13_';
                                          cnt_ := 13;
                                          IF (Get_Key_And_Value___(lu_name_, keys_, values_, 14, key_, value14_)) THEN
                                             stmt_ := stmt_||' AND '||key_||' = :value14_';
                                             cnt_ := 14;
                                             IF (Get_Key_And_Value___(lu_name_, keys_, values_, 15, key_, value15_)) THEN
                                                stmt_ := stmt_||' AND '||key_||' = :value15_';
                                                cnt_ := 15;
                                             END IF;
                                          END IF;
                                       END IF;
                                    END IF;
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   IF is_based_on_ THEN
      IF cnt_ > 0 THEN
         stmt_ := stmt_||' AND '||dic_rec_.based_on_filter;
      ELSE
         stmt_ := stmt_||' WHERE '||dic_rec_.based_on_filter;
      END IF;
   END IF;
   -- Execute SQL statement
   cursor_ := dbms_sql.open_cursor;
   BEGIN
      Put_Trace___('Restrict check statement: '||stmt_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
      dbms_sql.define_column(cursor_, 1, cnt_);
      IF (cnt_ > 0) THEN
         dbms_sql.bind_variable(cursor_, 'value1_', value1_);
         Put_Trace___('Value1_: '||value1_);
         IF (cnt_ > 1) THEN
            dbms_sql.bind_variable(cursor_, 'value2_', value2_);
            Put_Trace___('Value2_: '||value2_);
            IF (cnt_ > 2) THEN
               dbms_sql.bind_variable(cursor_, 'value3_', value3_);
               Put_Trace___('Value3_: '||value3_);
               IF (cnt_ > 3) THEN
                  dbms_sql.bind_variable(cursor_, 'value4_', value4_);
                  Put_Trace___('Value4_: '||value4_);
                  IF (cnt_ > 4) THEN
                     dbms_sql.bind_variable(cursor_, 'value5_', value5_);
                     Put_Trace___('Value5_: '||value5_);
                     IF (cnt_ > 5) THEN
                        dbms_sql.bind_variable(cursor_, 'value6_', value6_);
                        Put_Trace___('Value6_: '||value6_);
                        IF (cnt_ > 6) THEN
                           dbms_sql.bind_variable(cursor_, 'value7_', value7_);
                           Put_Trace___('Value7_: '||value7_);
                           IF (cnt_ > 7) THEN
                              dbms_sql.bind_variable(cursor_, 'value8_', value8_);
                              Put_Trace___('Value8_: '||value8_);
                              IF (cnt_ > 8) THEN
                                 dbms_sql.bind_variable(cursor_, 'value9_', value9_);
                                 Put_Trace___('Value9_: '||value9_);
                                 IF (cnt_ > 9) THEN
                                    dbms_sql.bind_variable(cursor_, 'value10_', value10_);
                                    Put_Trace___('Value10_: '||value10_);
                                    IF (cnt_ > 10) THEN
                                       dbms_sql.bind_variable(cursor_, 'value11_', value11_);
                                       Put_Trace___('Value11_: '||value11_);
                                       IF (cnt_ > 11) THEN
                                          dbms_sql.bind_variable(cursor_, 'value12_', value12_);
                                          Put_Trace___('Value12_: '||value12_);
                                          IF (cnt_ > 12) THEN
                                             dbms_sql.bind_variable(cursor_, 'value13_', value13_);
                                             Put_Trace___('Value13_: '||value13_);
                                             IF (cnt_ > 13) THEN
                                                dbms_sql.bind_variable(cursor_, 'value14_', value14_);
                                                Put_Trace___('Value14_: '||value14_);
                                                IF (cnt_ > 14) THEN
                                                   dbms_sql.bind_variable(cursor_, 'value15_', value15_);
                                                   Put_Trace___('Value15_: '||value15_);
                                                END IF;
                                             END IF;
                                          END IF;
                                       END IF;
                                    END IF;
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   EXCEPTION
      WHEN OTHERS THEN
         Error_SYS.Appl_General(service_, 'REFDES1: Reference design error when executing ":P1"', stmt_ );
   END;
   cnt_ := dbms_sql.execute(cursor_);
   cnt_ := dbms_sql.fetch_rows(cursor_);
   dbms_sql.column_value(cursor_, 1, cnt_);
   dbms_sql.close_cursor(cursor_);
   -- Return number of records found
   RETURN(cnt_);
EXCEPTION
   -- If any errors, just raise
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Restricted_SQL_Ref___;


-- Any_PLSQL_Ref___
--   Performs a general package procedure call including key list.
PROCEDURE Any_PLSQL_Ref___ (
   proc_name_   IN VARCHAR2,
   values_      IN VARCHAR2,
   option_name_ IN VARCHAR2 )
IS
   TYPE values_array IS TABLE OF VARCHAR2(2000) INDEX BY BINARY_INTEGER;
   values_arr_  values_array;
   cursor_      NUMBER;
   stmt_        VARCHAR2(32000);
   cnt_         NUMBER;
   value_count_ NUMBER;
   start_       NUMBER;
   end_         NUMBER;
   design_err   EXCEPTION;
   PRAGMA exception_init(design_err, -6550);
BEGIN
   BEGIN
      cursor_ := dbms_sql.open_cursor;
      Assert_SYS.Assert_Is_Package_Method(proc_name_);
      IF (option_name_ = 'CUSTOM') THEN
         stmt_ := 'BEGIN '||proc_name_||'(:keys_); END;';
         @ApproveDynamicStatement(2006-01-05,utgulk)
         dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
         dbms_sql.bind_variable(cursor_, 'keys_', values_);
         Put_Trace___('Custom method with parameters: '||values_);
      ELSIF (option_name_ = 'CUSTOMLIST') THEN

         -- Begin creating the statement
         stmt_ := 'BEGIN '||proc_name_||'(';

         -- Loop over all values and insert them as bindvariables
         value_count_ := 0;
         start_ := 1;
         end_ := instr(values_, '^', start_);
         WHILE end_ > 0 LOOP
            value_count_ := value_count_ + 1;
            values_arr_(value_count_) := substr(values_, start_, end_ - start_);
            start_ := end_ + 1;
            end_ := instr(values_, '^', start_);
            stmt_ := stmt_||':key'||to_char(value_count_)||',';
         END LOOP;

         -- Finalize the statement
         stmt_ := rtrim(stmt_, ',');
         stmt_ := stmt_ || '); END;';

         -- Parse statement and bind all variables
         @ApproveDynamicStatement(2006-01-05,utgulk)
         dbms_sql.parse(cursor_, stmt_, dbms_sql.native);
         FOR bind_var IN 1..value_count_ LOOP
            dbms_sql.bind_variable(cursor_, 'key'||to_char(bind_var), values_arr_(bind_var));
         END LOOP;
         Put_Trace___('Custom list method with parameters: '||rtrim(values_, Client_SYS.text_separator_));
      END IF;
      -- Execute the statement
      cnt_ := dbms_sql.execute(cursor_);
      dbms_sql.close_cursor(cursor_);
   EXCEPTION
      WHEN design_err THEN
         Error_SYS.Appl_General(service_, 'REFDES2: Reference design error executing ":P1"', stmt_ );
   END;
EXCEPTION
   -- If any errors, just raise
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Any_PLSQL_Ref___;


-- Cascade_PLSQL_Operation___
--   Performs a general package call to method Remove__ in a LU to be
--   used for all instance candidates found for a logical unit.
PROCEDURE Cascade_PLSQL_Operation___ (
   pkg_name_   IN VARCHAR2,
   objid_      IN VARCHAR2,
   objversion_ IN VARCHAR2,
   action_     IN VARCHAR2 )
IS
   info_   VARCHAR2(2000);
   stmt_   VARCHAR2(2000);
BEGIN
   -- Build statement and use correct action
   Assert_SYS.Assert_Is_Package(pkg_name_);
   stmt_ := 'BEGIN '||pkg_name_||'.Remove__(:info, :objid, :objversion, :action); END;';
   Put_Trace___('Executing PL-block: '||pkg_name_||'.Remove__(info_'', '''||objid_||''', '''||objversion_||''', '''||action_||''');');
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE stmt_ USING OUT info_, objid_, objversion_, action_;
   Client_SYS.Merge_Info(info_);
END Cascade_PLSQL_Operation___;


-- Run_Cascade_Candidates___
--   Fetch all cascade candidates for a specific logical unit (view!)
--   and for each OBJID found, call the method above to perform a
--   cascade operation.
PROCEDURE Run_Cascade_Candidates___ (
   lu_name_   IN VARCHAR2,
   view_name_ IN VARCHAR2,
   keys_      IN VARCHAR2,
   values_    IN VARCHAR2,
   action_    IN VARCHAR2 )
IS
   pkg_         VARCHAR2(30);
   stmt_        VARCHAR2(32000);
   c1_          NUMBER;
   cnt_         NUMBER;
   key_         VARCHAR2(2000);
   objid_       VARCHAR2(255);    -- Define areas
   objversion_  VARCHAR2(4000);
   value1_      VARCHAR2(2000);   -- Bind areas
   value2_      VARCHAR2(2000);
   value3_      VARCHAR2(2000);
   value4_      VARCHAR2(2000);
   value5_      VARCHAR2(2000);
   value6_      VARCHAR2(2000);
   value7_      VARCHAR2(2000);
   value8_      VARCHAR2(2000);
   value9_      VARCHAR2(2000);
   value10_     VARCHAR2(2000);
   value11_     VARCHAR2(2000);
   value12_     VARCHAR2(2000);
   value13_     VARCHAR2(2000);
   value14_     VARCHAR2(2000);
   value15_     VARCHAR2(2000);
   temp_        VARCHAR2(32000);  -- Trace area
   dic_rec_     dictionary_sys_tab%ROWTYPE;
   is_based_on_ BOOLEAN := FALSE;
BEGIN
   -- Use name convention for reasonable performance
   pkg_ := Dictionary_SYS.Get_Base_Package(lu_name_);
   --
   IF (Dictionary_SYS.Get_Reference_Base(lu_name_) = 'TABLE') THEN
      Assert_SYS.Assert_Is_Table(view_name_);
      -- No need to add this filter for the references based on views,assuming that it is already added.
      dic_rec_ := Dictionary_SYS.Get_Dictionary_Record(lu_name_);
      IF ((dic_rec_.based_on IS NOT NULL) AND (dic_rec_.based_on_filter IS NOT NULL)) THEN
         is_based_on_ := TRUE;
      END IF;
   ELSE
      Assert_SYS.Assert_Is_View(view_name_);
   END IF;
   IF NOT Database_SYS.Package_Exist(pkg_) THEN
      Error_SYS.Appl_General(service_, 'REFERR: The view :P1 and its corresponding package does not seem to follow the name standards. This caused an error in the reference system during the cascade delete.', view_name_, pkg_);
   END IF;
   Assert_SYS.Assert_Is_Package(pkg_);

   -- Build the SQL-statement
   stmt_ := 'SELECT '||Get_Column_Name___(lu_name_, 'OBJID')||' OBJID, '||Get_Column_Name___(lu_name_, 'OBJVERSION')||' OBJVERSION FROM '||view_name_;
   IF (Get_Key_And_Value___(lu_name_, keys_, values_, 1, key_, value1_)) THEN
      stmt_ := stmt_||' WHERE '||key_||' = :value1';
      cnt_ := 1;
      IF (Get_Key_And_Value___(lu_name_, keys_, values_, 2, key_, value2_)) THEN
         stmt_ := stmt_||' AND '||key_||' = :value2';
         cnt_ := 2;
         IF (Get_Key_And_Value___(lu_name_, keys_, values_, 3, key_, value3_)) THEN
            stmt_ := stmt_||' AND '||key_||' = :value3';
            cnt_ := 3;
            IF (Get_Key_And_Value___(lu_name_, keys_, values_, 4, key_, value4_)) THEN
               stmt_ := stmt_||' AND '||key_||' = :value4';
               cnt_ := 4;
               IF (Get_Key_And_Value___(lu_name_, keys_, values_, 5, key_, value5_)) THEN
                  stmt_ := stmt_||' AND '||key_||' = :value5';
                  cnt_ := 5;
                  IF (Get_Key_And_Value___(lu_name_, keys_, values_, 6, key_, value6_)) THEN
                     stmt_ := stmt_||' AND '||key_||' = :value6';
                     cnt_ := 6;
                     IF (Get_Key_And_Value___(lu_name_, keys_, values_, 7, key_, value7_)) THEN
                        stmt_ := stmt_||' AND '||key_||' = :value7';
                        cnt_ := 7;
                        IF (Get_Key_And_Value___(lu_name_, keys_, values_, 8, key_, value8_)) THEN
                           stmt_ := stmt_||' AND '||key_||' = :value8';
                           cnt_ := 8;
                           IF (Get_Key_And_Value___(lu_name_, keys_, values_, 9, key_, value9_)) THEN
                              stmt_ := stmt_||' AND '||key_||' = :value9';
                              cnt_ := 9;
                              IF (Get_Key_And_Value___(lu_name_, keys_, values_, 10, key_, value10_)) THEN
                                 stmt_ := stmt_||' AND '||key_||' = :value10';
                                 cnt_ := 10;
                                 IF (Get_Key_And_Value___(lu_name_, keys_, values_, 11, key_, value11_)) THEN
                                    stmt_ := stmt_||' AND '||key_||' = :value11';
                                    cnt_ := 11;
                                    IF (Get_Key_And_Value___(lu_name_, keys_, values_, 12, key_, value12_)) THEN
                                       stmt_ := stmt_||' AND '||key_||' = :value12';
                                       cnt_ := 12;
                                       IF (Get_Key_And_Value___(lu_name_, keys_, values_, 13, key_, value13_)) THEN
                                          stmt_ := stmt_||' AND '||key_||' = :value13';
                                          cnt_ := 13;
                                          IF (Get_Key_And_Value___(lu_name_, keys_, values_, 14, key_, value14_)) THEN
                                             stmt_ := stmt_||' AND '||key_||' = :value14';
                                             cnt_ := 14;
                                             IF (Get_Key_And_Value___(lu_name_, keys_, values_, 15, key_, value15_)) THEN
                                                stmt_ := stmt_||' AND '||key_||' = :value15';
                                                cnt_ := 15;
                                             END IF;
                                          END IF;
                                       END IF;
                                    END IF;
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   IF is_based_on_ THEN
      IF cnt_ > 0 THEN
         stmt_ := stmt_||' AND '||dic_rec_.based_on_filter;
      ELSE
         stmt_ := stmt_||' WHERE '||dic_rec_.based_on_filter;
      END IF;
   END IF;
   Put_Trace___('Performing SQL-statement: '||stmt_);
   c1_ := dbms_sql.open_cursor;
   -- Parse and define result columns
   @ApproveDynamicStatement(2006-01-05,utgulk)
   dbms_sql.parse(c1_, stmt_, dbms_sql.native);
   dbms_sql.define_column(c1_, 1, objid_, 2550);
   dbms_sql.define_column(c1_, 2, objversion_, 20000);
   -- Bind as many variables as needed
   IF (cnt_ > 0) THEN
      dbms_sql.bind_variable(c1_, 'value1', value1_);
      temp_ := temp_||value1_||'^';
      IF (cnt_ > 1) THEN
         dbms_sql.bind_variable(c1_, 'value2', value2_);
         temp_ := temp_||value2_||'^';
         IF (cnt_ > 2) THEN
            dbms_sql.bind_variable(c1_, 'value3', value3_);
            temp_ := temp_||value3_||'^';
            IF (cnt_ > 3) THEN
               dbms_sql.bind_variable(c1_, 'value4', value4_);
               temp_ := temp_||value4_||'^';
               IF (cnt_ > 4) THEN
                  dbms_sql.bind_variable(c1_, 'value5', value5_);
                  temp_ := temp_||value5_||'^';
                  IF (cnt_ > 5) THEN
                     dbms_sql.bind_variable(c1_, 'value6', value6_);
                     temp_ := temp_||value6_||'^';
                     IF (cnt_ > 6) THEN
                        dbms_sql.bind_variable(c1_, 'value7', value7_);
                        temp_ := temp_||value7_||'^';
                        IF (cnt_ > 7) THEN
                           dbms_sql.bind_variable(c1_, 'value8', value8_);
                           temp_ := temp_||value8_||'^';
                           IF (cnt_ > 8) THEN
                              dbms_sql.bind_variable(c1_, 'value9', value9_);
                              temp_ := temp_||value9_||'^';
                              IF (cnt_ > 9) THEN
                                 dbms_sql.bind_variable(c1_, 'value10', value10_);
                                 temp_ := temp_||value10_||'^';
                                 IF (cnt_ > 10) THEN
                                    dbms_sql.bind_variable(c1_, 'value11', value11_);
                                    temp_ := temp_||value11_||'^';
                                    IF (cnt_ > 11) THEN
                                       dbms_sql.bind_variable(c1_, 'value12', value12_);
                                       temp_ := temp_||value12_||'^';
                                       IF (cnt_ > 12) THEN
                                          dbms_sql.bind_variable(c1_, 'value13', value13_);
                                          temp_ := temp_||value13_||'^';
                                          IF (cnt_ > 13) THEN
                                             dbms_sql.bind_variable(c1_, 'value14', value14_);
                                             temp_ := temp_||value14_||'^';
                                             IF (cnt_ > 14) THEN
                                                dbms_sql.bind_variable(c1_, 'value15', value15_);
                                                temp_ := temp_||value15_||'^';
                                             END IF;
                                          END IF;
                                       END IF;
                                    END IF;
                                 END IF;
                              END IF;
                           END IF;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;
         END IF;
      END IF;
   END IF;
   cnt_ := dbms_sql.execute(c1_);
   -- Fetch values and call method Remove__ for all elements found
   LOOP
      cnt_ := dbms_sql.fetch_rows(c1_);
      EXIT WHEN (cnt_ < 1);
      dbms_sql.column_value(c1_, 1, objid_);
      dbms_sql.column_value(c1_, 2, objversion_);
      Put_Trace___('Fetched row in view '||view_name_||' (Parent: '||temp_||')');
      Cascade_PLSQL_Operation___(pkg_, objid_, objversion_, action_);
   END LOOP;
   dbms_sql.close_cursor(c1_);
EXCEPTION
   -- If any errors, just raise
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(c1_)) THEN
         dbms_sql.close_cursor(c1_);
      END IF;
      RAISE;
END Run_Cascade_Candidates___;


PROCEDURE Find_Method_In_Lu___ (
   plsql_name_  OUT VARCHAR2,
   lu_name_     IN VARCHAR2,
   method_name_ IN VARCHAR2 )
IS
   pkg_       VARCHAR2(30);
   --SOLSETFW
   CURSOR get_package_name IS
      SELECT package_name
      FROM dictionary_sys_method_tab
      WHERE lu_name = lu_name_
      AND upper(method_name) = upper(method_name_);
BEGIN
   OPEN get_package_name;
   FETCH get_package_name INTO pkg_;
   IF (get_package_name%NOTFOUND) THEN
      CLOSE get_package_name;
      RETURN;
   END IF;
   CLOSE get_package_name;
   --
   -- Format the return value
   --
   plsql_name_ := pkg_||'.'||ltrim(method_name_);
END Find_Method_In_Lu___;


PROCEDURE Get_Lov_Properties___ (
   key_names_           OUT VARCHAR2,
   col_names_           OUT VARCHAR2,
   col_prompts_         OUT VARCHAR2,
   col_types_           OUT VARCHAR2,
   col_refs_            OUT VARCHAR2,
   col_enumerations_    OUT VARCHAR2,
   col_db_names_        OUT VARCHAR2,
   key_names_arr_       OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_names_arr_       OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_prompts_arr_     OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_types_arr_       OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_refs_arr_        OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   db_enumerations_arr_ OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   db_column_names_arr_ OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   view_name_           IN  VARCHAR2,
   return_parent_keys_  IN  BOOLEAN)
IS
   prompt_   VARCHAR2(200);
   type_     VARCHAR2(200);
   keys_     VARCHAR2(32000);
   firstcol_ VARCHAR2(200);
   cols_     VARCHAR2(32000);
   prompts_  VARCHAR2(32000);
   types_    VARCHAR2(32000);
   refs_           VARCHAR2(32000);
   enumerations_   VARCHAR2(32000);
   db_values_      VARCHAR2(32000);
   column_db_name_ VARCHAR2(30);
   --SOLSETFW
   CURSOR lov_cols IS
      SELECT column_name, column_datatype, column_prompt, type_flag, lov_flag, column_reference, enumeration, lookup
      FROM   dictionary_sys_view_column_act
      WHERE  view_name  = view_name_
      AND    column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJEVENTS')
      AND   (lov_flag = 'L' OR type_flag IN ('P', 'K'))
      ORDER BY column_index;

BEGIN
   Put_Trace___('Get LOV-information for view '||view_name_);
   FOR col IN lov_cols LOOP
      -- Find out if column is member of perent key or key
      IF col.type_flag IN ('P','K') THEN
         IF ( keys_ IS NULL ) THEN
            keys_ := col.column_name;
         ELSE
            keys_ := keys_||','||col.column_name;
         END IF;
         key_names_arr_(key_names_arr_.COUNT+1) := col.column_name;
      END IF;
      -- Return parent keys only when return_parent_keys_ is TRUE
      IF col.type_flag = 'K' OR col.lov_flag = 'L' OR (col.type_flag = 'P' AND return_parent_keys_)THEN
         -- Set or generate prompt text
         prompt_ := Language_SYS.Translate_Item_Prompt_(view_name_||'.'||col.column_name, col.column_prompt, 0);
         IF (prompt_ IS NULL) THEN
            prompt_ := initcap(replace(col.column_name, '_', ' '));
         END IF;
         -- Set or generate datatype
         IF col.column_datatype IS NULL THEN
            SELECT decode(data_type, 'VARCHAR2', 'STRING',
                                     'CHAR',     'STRING',
                                     'INTEGER',  'NUMBER',
                          data_type )
            INTO   type_
            FROM   user_tab_columns
            WHERE  table_name = view_name_
            AND    column_name = col.column_name;
         ELSE
            type_  := col.column_datatype;
         END IF;
         -- Add this columns properties to result lists
         IF (firstcol_ IS NULL) THEN
            firstcol_ := col.column_name;
         END IF;

         IF (col.enumeration IS NULL AND col.lookup IS NULL) THEN -- Added lookup temporary, to be changed when client understands lookup
            column_db_name_ := NULL;
         ELSE
            Get_Iid_Properties(column_db_name_,  view_name_, col.column_name );
         END IF;

         IF (cols_ IS NULL) THEN
            cols_          := col.column_name;
            prompts_       := prompt_;
            types_         := type_;
            refs_          := col.column_reference;
            enumerations_  := col.enumeration;
            db_values_     := column_db_name_;
         ELSE
            cols_          := cols_||','||col.column_name;
            prompts_       := prompts_||'^'||prompt_;
            types_         := types_||'^'||type_;
            refs_          := refs_||'^'||col.column_reference;
            enumerations_  := enumerations_||'^'||col.enumeration;
            db_values_     := db_values_||'^'||column_db_name_;
         END IF;
         col_names_arr_(col_names_arr_.COUNT+1) := col.column_name;
         col_prompts_arr_(col_prompts_arr_.COUNT+1) := prompt_;         
         col_types_arr_(col_types_arr_.COUNT+1) := type_;
         col_refs_arr_(col_refs_arr_.COUNT+1) := col.column_reference;
         db_enumerations_arr_(db_enumerations_arr_.COUNT+1) := col.enumeration;
         db_column_names_arr_(db_column_names_arr_.COUNT+1) := column_db_name_;         
      END IF;
   END LOOP;
   -- Return appropriate values
   key_names_        := nvl(keys_, firstcol_);
   col_names_        := cols_;
   col_prompts_      := prompts_;
   col_types_        := types_;
   col_refs_         := refs_;
   col_enumerations_ := enumerations_;
   col_db_names_     := db_values_;
   
   IF (key_names_arr_.COUNT = 0) THEN
      key_names_arr_(key_names_arr_.COUNT+1) := firstcol_;
   END IF;
END Get_Lov_Properties___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Refresh_Active_List__
--   Reads current design settings for references from column comments
--   and stores them in a lookup table for faster access.
--   To be executed at install and after each upgrade of logical units.
PROCEDURE Refresh_Active_List__ (
   mode_ IN VARCHAR2 )
IS
   TYPE reference_sys_table IS TABLE OF reference_sys_tab%ROWTYPE INDEX BY BINARY_INTEGER;
   ref_sys_tab_ reference_sys_table;
   design_err EXCEPTION;
   PRAGMA     exception_init(design_err, -20105);
   temp_      VARCHAR2(2000);
   ref_name_  VARCHAR2(30);
   keys_      VARCHAR2(2000);
   option_    VARCHAR2(10);
   optarg1_   VARCHAR2(61);
   optarg2_   VARCHAR2(61);
   err_info_  VARCHAR2(100);
   view_      VARCHAR2(30);
   module_    VARCHAR2(10);
   action_    VARCHAR2(7)  := 'FULL';     -- Assume full refresh until mode is evaluated
   --SOLSETFW
   CURSOR refs_full IS
      SELECT dvc.lu_name, dvc.view_name, dvc.column_name, dvc.column_reference
      FROM   dictionary_sys_view_column_tab dvc
      WHERE  dvc.column_reference IS NOT NULL
      AND    dvc.column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJEVENTS', 'OBJSTATE')
      AND    ( length(dvc.view_name) < 4 OR substr(dvc.view_name,-4) <> '_REP');
   --SOLSETFW
   CURSOR refs_compute IS
      SELECT dvc.lu_name, dvc.view_name, dvc.column_name, dvc.column_reference
      FROM   dictionary_sys_view_column_tab dvc
      WHERE  dvc.column_reference IS NOT NULL
      AND    dvc.column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJEVENTS', 'OBJSTATE')
      AND    ( length(dvc.view_name) < 4 OR substr(dvc.view_name,-4) <> '_REP')
      AND NOT EXISTS
      (SELECT 1
       FROM reference_sys_tab r
       WHERE r.view_name = dvc.view_name
       AND   r.col_name = dvc.column_name
       AND   r.col_reference = dvc.column_reference);
   --SOLSETFW
   CURSOR refs_view IS
      SELECT dvc.lu_name, dvc.view_name, dvc.column_name, dvc.column_reference
      FROM   dictionary_sys_view_column_tab dvc
      WHERE  dvc.column_reference IS NOT NULL
      AND    dvc.column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJEVENTS', 'OBJSTATE')
      AND    ( length(dvc.view_name) < 4 OR substr(dvc.view_name,-4) <> '_REP')
      AND    dvc.view_name = view_;
   --SOLSETFW
   CURSOR refs_module IS
      SELECT dvc.lu_name, dvc.view_name, dvc.column_name, dvc.column_reference
      FROM   dictionary_sys_view_column_tab dvc, dictionary_sys_lu d
      WHERE  dvc.lu_name = d.lu_name
      AND    dvc.column_reference IS NOT NULL
      AND    dvc.column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJEVENTS', 'OBJSTATE')
      AND    ( length(dvc.view_name) < 4 OR substr(dvc.view_name,-4) <> '_REP')
      AND    d.module = module_;

   TYPE dictionary_sys_table IS TABLE OF refs_full%ROWTYPE INDEX BY BINARY_INTEGER;
   dict_  dictionary_sys_table;

BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Refresh_Active_List__');
   --
   -- Make sure that the Dictionary Cache is up to date, WHAT TO DO ELSE?
   --
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Dictionary Cache has to be updated to ensure correct reference information');
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Investigating status of the Dictionary Cache and refreshing if necessary...');
   -- For tests!
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Starting at '||to_char(SYSDATE, 'HH24:MI:SS'));
   --
   -- Refresh the dictionary cache.
   --
   IF Dictionary_SYS.Check_Dictionary_Storage_ > 0 THEN
      Dictionary_SYS.Rebuild_Dictionary_Storage_(1, 'COMPUTE');
   END IF;
   -- For tests!
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Continuing refreshing Reference Cache at '||to_char(SYSDATE, 'HH24:MI:SS'));
   --
   -- Evaluate the parameter mode_
   --
   IF (mode_ = 'COMPUTE') THEN
      action_ := mode_;
   ELSIF (instr(mode_, '_') > 0) THEN
      view_ := mode_;                  -- Assume a view
      action_ := 'VIEW';
   ELSIF (length(mode_) > 1) THEN
      BEGIN
         Module_API.Exist(mode_);
         module_ := mode_;             -- Assume a complete module
         action_ := 'MODULE';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   ELSE
      action_ := 'FULL';               -- Assume a full refresh
   END IF;
   --
   -- Fetch the main information into a pl/sql table
   --
   IF action_ = 'FULL' THEN
      OPEN refs_full;
      FETCH refs_full BULK COLLECT INTO dict_;
      CLOSE refs_full;
   ELSIF action_ = 'COMPUTE' THEN
      OPEN refs_compute;
      FETCH refs_compute BULK COLLECT INTO dict_;
      CLOSE refs_compute;
   ELSIF action_ = 'VIEW' THEN
      OPEN refs_view;
      FETCH refs_view BULK COLLECT INTO dict_;
      CLOSE refs_view;
   ELSIF action_ = 'MODULE' THEN
      OPEN refs_module;
      FETCH refs_module BULK COLLECT INTO dict_;
      CLOSE refs_module;
   END IF;

   Log_SYS.Fnd_Trace_(Log_SYS.error_,    'Reference Cache is being updated for '||to_char(dict_.count)||' reference(s)');
   -- ALSO INVESTIGATE THE POSSIBLY DOUBLE REFRESH OF REFERENCE CACHE DU TO THE INITIATION CHECK
   -- LAST IN THIS PACKAGE!!!!!!!!!!!!!!

   --
   -- Loop through the reference information and insert it into the result pl/sql table
   --
   IF dict_.FIRST IS NOT NULL THEN
      FOR i_ IN dict_.FIRST..dict_.LAST LOOP
         -- Store info for possible errors
         err_info_ := dict_(i_).view_name||'.'||dict_(i_).column_name;

         Parse_Ref_Value___(dict_(i_).column_reference, ref_name_, keys_, option_, optarg1_, optarg2_);
         -- Check that specified method exists
         IF (optarg1_ IS NOT NULL) THEN
            -- This should be calling a method in Dictionary_SYS soon!
            Find_Method_In_Lu___(temp_, dict_(i_).lu_name, optarg1_);
            IF (temp_ IS NULL) THEN
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Method '''||optarg1_ ||''' not found for logical unit '''||dict_(i_).lu_name||''' ('|| err_info_||').');
            END IF;
            optarg1_ := temp_;
         END IF;
         IF (optarg2_ IS NOT NULL) THEN
            -- This should be calling a method in Dictionary_SYS soon!
            Find_Method_In_Lu___(temp_, dict_(i_).lu_name, optarg2_);
            IF (temp_ IS NULL) THEN
               Log_SYS.Fnd_Trace_(Log_SYS.error_, 'Method '''||optarg2_ ||''' not found for logical unit '''||dict_(i_).lu_name||''' ('|| err_info_||').');
            END IF;
            optarg2_ := temp_;
         END IF;
         -- Insert into active reference list
         ref_sys_tab_(i_).lu_name     := dict_(i_).lu_name;
         ref_sys_tab_(i_).view_name   := dict_(i_).view_name;
         ref_sys_tab_(i_).col_name    := dict_(i_).column_name;
         ref_sys_tab_(i_).col_reference := dict_(i_).column_reference;
         ref_sys_tab_(i_).ref_name    := ref_name_;
         ref_sys_tab_(i_).parent_keys := keys_;
         ref_sys_tab_(i_).option_name := option_;
         ref_sys_tab_(i_).option_arg1 := optarg1_;
         ref_sys_tab_(i_).option_arg2 := optarg2_;
      END LOOP;
   END IF;
   --
   -- We have inserted all the new references into the result pl/sql table,
   -- no error has been detected, remains to insert it into Oracle as well
   --

   --
   -- Remove old data before inserting the new data from the pl/sql table
   --
   IF action_ = 'FULL' THEN
      -- Delete all old data
      DELETE FROM reference_sys_tab;
   ELSIF action_ = 'COMPUTE' THEN
      --SOLSETFW
      -- Delete all invalid data
      DELETE FROM reference_sys_tab r
      WHERE NOT EXISTS
      (SELECT 1
       FROM dictionary_sys_view_column_tab dvc
       WHERE r.view_name = dvc.view_name
       AND   r.col_name = dvc.column_name
       AND   r.col_reference = dvc.column_reference);
   ELSIF action_ = 'VIEW' THEN
      -- Delete all old data for this view
      DELETE FROM reference_sys_tab
         WHERE view_name = view_;
   ELSIF action_ = 'MODULE' THEN
      -- Delete all old data for LU's that are not in another module
      -- (will also remove data for dropped views in other modules...)
      --SOLSETFW
      DELETE FROM reference_sys_tab
         WHERE view_name NOT IN (SELECT dv.view_name
                                 FROM dictionary_sys_view_tab dv, dictionary_sys_tab d
                                 WHERE d.lu_name = dv.lu_name
                                 AND d.module != module_);

   END IF;
   --
   -- Insert data from pl/sql table
   --
   IF ref_sys_tab_.FIRST IS NOT NULL THEN
      DECLARE
         bulk_errors   EXCEPTION;
         PRAGMA EXCEPTION_INIT(bulk_errors, -24381);
         error_count_ NUMBER;
         position_ NUMBER;
      BEGIN
         FORALL n IN ref_sys_tab_.FIRST..ref_sys_tab_.LAST SAVE EXCEPTIONS
            INSERT INTO reference_sys_tab VALUES ref_sys_tab_(n);
      EXCEPTION
         WHEN bulk_errors THEN
            error_count_ := SQL%BULK_EXCEPTIONS.COUNT;
            FOR i IN 1..error_count_ LOOP
               position_ := SQL%BULK_EXCEPTIONS(i).ERROR_INDEX;
               err_info_ := ref_sys_tab_(position_).view_name || '.'  ||ref_sys_tab_(position_).col_name;
               Error_SYS.Appl_General(service_, 'NOREFRESH: Reference active list is invalid (:P1). Oracle exception (:P2).', err_info_, SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
            END LOOP;
      END;
   END IF;
   Cache_Management_API.Refresh_Cache('Reference');
   @ApproveTransactionStatement(2013-11-08,haarse)
   COMMIT;

   -- Deallocate the pl/sql tables before exit
   ref_sys_tab_.DELETE;
   dict_.DELETE;

   -- For tests
   Log_SYS.Fnd_Trace_(Log_SYS.error_, 'The Reference Cache is updated at '||to_char(SYSDATE, 'HH24:MI:SS'));
EXCEPTION
   -- Hide internal Oracle errors from end-user
   WHEN OTHERS THEN
      -- Deallocate the pl/sql tables
      ref_sys_tab_.DELETE;
      dict_.DELETE;
      RAISE;
END Refresh_Active_List__;


-- Check_Active_List__
--   Reads current design settings for references from column comments
--   and compares them with lookup table contents.
PROCEDURE Check_Active_List__ (
   dummy_ OUT NUMBER )
IS
   --SOLSETFW
   CURSOR refs IS
      SELECT 1
      FROM   dictionary_sys_view_column_act dvc
      WHERE  dvc.column_reference IS NOT NULL
      AND    dvc.column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJEVENTS', 'OBJSTATE')
      AND    substr(dvc.view_name,-4) <> '_REP'
      AND NOT EXISTS
      (SELECT 1
       FROM reference_sys_tab r
       WHERE r.view_name = dvc.view_name
       AND   r.col_name = dvc.column_name
       AND   r.col_reference = dvc.column_reference);
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Check_Active_List__');
   -- First check if the dictionary need to be refreshed, which implies that reference need refresh too...
   Dictionary_SYS.Check_Dictionary_Storage_(dummy_);
   IF dummy_ = 0 THEN
      -- Dictionary is up to date, continue the investigation
      FOR ref_ IN refs LOOP
         -- If any row is found the reference need to be refreshed. Set out parameter and return!
         dummy_ := 1;
         RETURN;
      END LOOP;
   END IF;
END Check_Active_List__;

-- Get_Lov_Properties__
--   Reads dictionary information for specified logical unit (e.g. view)
--   and returns LOV columns and valid prompt for each column,
--   including the parent key if return_parent_keys_ is TRUE
--   Identical to Get_Lov_Properties but includes sort info.
PROCEDURE Get_Lov_Properties__ (
   view_name_    IN  VARCHAR2,
   key_names_    OUT VARCHAR2,
   col_names_    OUT VARCHAR2,
   col_prompts_  OUT VARCHAR2,
   col_types_    OUT VARCHAR2,
   col_refs_     OUT VARCHAR2,
   col_db_names_ OUT VARCHAR2,
   sort_info_    OUT VARCHAR2,
   validity_mode_ OUT VARCHAR2,
   return_parent_keys_ BOOLEAN )
IS
   col_enumerations_ VARCHAR2(4000);
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_Lov_Properties__');
   Get_Lov_Properties__(view_name_, key_names_, col_names_, col_prompts_, col_types_, col_refs_, col_enumerations_, col_db_names_, validity_mode_, return_parent_keys_);
END Get_Lov_Properties__;

PROCEDURE Get_Lov_Properties__ (
   view_name_        IN  VARCHAR2,
   key_names_        OUT VARCHAR2,
   col_names_        OUT VARCHAR2,
   col_prompts_      OUT VARCHAR2,
   col_types_        OUT VARCHAR2,
   col_refs_         OUT VARCHAR2,
   col_enumerations_ OUT VARCHAR2,
   col_db_names_     OUT VARCHAR2,
   sort_info_        OUT VARCHAR2,
   validity_mode_    OUT VARCHAR2,
   return_parent_keys_ BOOLEAN )
IS   
   comments_                   VARCHAR2(2000);
   unused_key_names_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_names_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_prompts_arr_     DBMS_UTILITY.UNCL_ARRAY;
   unused_col_types_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_refs_arr_        DBMS_UTILITY.UNCL_ARRAY;
   unused_db_enumerations_arr_ DBMS_UTILITY.UNCL_ARRAY;
   unused_db_column_names_arr_ DBMS_UTILITY.UNCL_ARRAY;
   
   CURSOR get_sort_info IS
      SELECT comments
      FROM   fnd_tab_comments
      WHERE  table_name = view_name_;
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_Lov_Properties__');
   Get_Lov_Properties___(key_names_, col_names_, col_prompts_, col_types_, col_refs_, col_enumerations_, col_db_names_,
   unused_key_names_arr_, unused_col_names_arr_, unused_col_prompts_arr_, unused_col_types_arr_, unused_col_refs_arr_, unused_db_enumerations_arr_, unused_db_column_names_arr_,
   view_name_, return_parent_keys_);
   OPEN  get_sort_info;
   FETCH get_sort_info INTO comments_;
   CLOSE get_sort_info;
   sort_info_ := Dictionary_SYS.Comment_Value_('SORT', comments_);
   validity_mode_  := Dictionary_SYS.Comment_Value_('VALIDITY', comments_);
END Get_Lov_Properties__;


-- Cleanup__
--   Delete records without reference to source.
PROCEDURE Cleanup__
IS
BEGIN
   DELETE FROM reference_sys_tab r
   WHERE NOT EXISTS
   (SELECT 1
    FROM dictionary_sys_view_column_tab dvc
    WHERE r.view_name = dvc.view_name
    AND   r.col_name = dvc.column_name
    AND   r.col_reference = dvc.column_reference);
END Cleanup__;   

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-- Check_Active_List_
--   Reads current design settings for references from column comments
--   and compares them with lookup table contents.
@UncheckedAccess
FUNCTION Check_Active_List_ RETURN NUMBER
IS
   rebuild_needed_       NUMBER;
BEGIN
   Check_Active_List__(rebuild_needed_);
   RETURN rebuild_needed_;
END Check_Active_List_;


-- Get_Lov_Properties_
--   Reads dictionary information for specified logical unit (e.g. view)
--   and returns LOV columns and valid prompt for each column.
--   This method does not return the parent keys
--   Identical to Get_Lov_Properties but includes sort info.
PROCEDURE Get_Lov_Properties_ (
   view_name_        IN  VARCHAR2,
   key_names_        OUT VARCHAR2,
   col_names_        OUT VARCHAR2,
   col_prompts_      OUT VARCHAR2,
   col_types_        OUT VARCHAR2,
   col_refs_         OUT VARCHAR2,
   col_db_names_     OUT VARCHAR2,
   sort_info_        OUT VARCHAR2,
   validity_mode_    OUT VARCHAR2 )
IS
   col_enumerations_    VARCHAR2(4000);
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_Lov_Properties_');
   Get_Lov_Properties__(view_name_, key_names_, col_names_, col_prompts_, col_types_, col_refs_, col_enumerations_, col_db_names_, sort_info_, validity_mode_, FALSE);
END Get_Lov_Properties_;


PROCEDURE Get_Lov_Properties_ (
   view_name_        IN  VARCHAR2,
   key_names_        OUT VARCHAR2,
   col_names_        OUT VARCHAR2,
   col_prompts_      OUT VARCHAR2,
   col_types_        OUT VARCHAR2,
   col_refs_         OUT VARCHAR2,
   col_enumerations_ OUT VARCHAR2,
   col_db_names_     OUT VARCHAR2,
   sort_info_        OUT VARCHAR2,
   validity_mode_    OUT VARCHAR2 )
IS
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_Lov_Properties_');
   Get_Lov_Properties__(view_name_, key_names_, col_names_, col_prompts_, col_types_, col_refs_, col_enumerations_, col_db_names_, sort_info_, validity_mode_, FALSE);
END Get_Lov_Properties_;

PROCEDURE Get_View_Properties_ (
   key_names_arr_       OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_names_arr_       OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_prompts_arr_     OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_types_arr_       OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   col_refs_arr_        OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   db_enumerations_arr_ OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   db_column_names_arr_ OUT NOCOPY DBMS_UTILITY.UNCL_ARRAY,
   view_name_           IN  VARCHAR2)
IS
   unused_key_names_        VARCHAR2(32000);
   unused_col_names_        VARCHAR2(32000);
   unused_col_prompts_      VARCHAR2(32000);
   unused_col_types_        VARCHAR2(32000);
   unused_col_refs_         VARCHAR2(32000);
   unused_col_enumerations_ VARCHAR2(32000);
   unused_col_db_names_     VARCHAR2(32000);   
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_View_Properties_');
   Get_Lov_Properties___(unused_key_names_, unused_col_names_, unused_col_prompts_, unused_col_types_, unused_col_refs_, unused_col_enumerations_, unused_col_db_names_,
   key_names_arr_, col_names_arr_, col_prompts_arr_, col_types_arr_, col_refs_arr_, db_enumerations_arr_, db_column_names_arr_,
   view_name_, FALSE);
END Get_View_Properties_;


-- Get_View_Reference_Info_
--   Retrieves the corresponding column names for a reference
--   between two database views.
PROCEDURE Get_View_Reference_Info_ (
   out_info_msg_  OUT VARCHAR2,
   view_name_     IN  VARCHAR2,
   ref_view_name_ IN  VARCHAR2,
   in_info_msg_   IN  VARCHAR2 DEFAULT NULL )
IS
   msg_          VARCHAR2(2000);
   col_name_     VARCHAR2(30);
   ref_col_name_ VARCHAR2(30);
   start_        NUMBER;
   count_        NUMBER;
   ref_name_     VARCHAR2(30) := Dictionary_SYS.Get_Logical_Unit(upper(ref_view_name_), 'VIEW');

   CURSOR get_refs IS
      SELECT col_name fkey, upper(parent_keys)||',' pkeys
      FROM   reference_sys_tab
      WHERE  view_name = upper(view_name_)
      AND    ref_name = ref_name_;
   --SOLSETFW
   CURSOR lu_keys IS
      SELECT column_name, type_flag
      FROM   dictionary_sys_view_column_tab
      WHERE  view_name  = upper(ref_view_name_)
      AND    type_flag IN ('P', 'K')
      ORDER BY column_index;

BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_View_Reference_Info_');
   --
   -- Create the message
   --
   msg_ := Message_SYS.Construct('VIEW_REF_INFO');

   -- Special handling of reference to self (No need to fetch keys,, it's the same).
   IF upper(view_name_) != upper(ref_view_name_) THEN
      --
      -- Fetch parent keys from the referencing view
      --
      FOR refs IN get_refs LOOP
         start_ := 1;
         count_ := 1;
         --
         -- Fetch keys for the referenced view
         --
         FOR key_ IN lu_keys LOOP
            IF (refs.pkeys IS NOT NULL AND key_.type_flag = 'P') THEN
               col_name_ := substr(refs.pkeys, start_, instr(refs.pkeys, ',', 1, count_) - start_);
               start_ := instr(refs.pkeys, ',', 1, count_) + 1;
               count_ := count_ + 1;
            ELSE
               col_name_ := refs.fkey;
            END IF;
            ref_col_name_ := key_.column_name;
            Message_SYS.Add_Attribute(msg_, col_name_, ref_col_name_);
         END LOOP;
         out_info_msg_ := msg_;
      END LOOP;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      out_info_msg_ := NULL;
END Get_View_Reference_Info_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Check_Restricted_Delete
--   Checks all restricted references and issues exception if any
--   of them would be violated when record is removed.
PROCEDURE Check_Restricted_Delete (
   lu_name_  IN VARCHAR2,
   key_list_ IN VARCHAR2 )
IS
   keys_          VARCHAR2(32000);
   values_        VARCHAR2(32000);
   cnt_           NUMBER;   
   ref_prompt_      VARCHAR2(2000);
   key_           VARCHAR2(200);
   lookup_        VARCHAR2(200);
   value_         VARCHAR2(2000);
   dummy_         BOOLEAN;
   table_name_    VARCHAR2(100);
   refering_table_name_ VARCHAR2(100);
   stmt_          VARCHAR2(32000);
   primary_key_where_ VARCHAR2(32000);
   key_count_     NUMBER;
   keys_table_       Utility_SYS.string_table;
   key_index_     NUMBER;
   columns_       VARCHAR2(32000);   
   keyvalues_table_  Utility_SYS.string_table;
   keyvalue_         VARCHAR2(2000);
   keyvalue_index_   NUMBER;
   package_name_  VARCHAR2(30);
   db_value_      VARCHAR2(4000);

   CURSOR refs IS
      SELECT lu_name, view_name, col_name, parent_keys, option_name, option_arg1
      FROM   reference_sys_tab
      WHERE  ref_name = lu_name_
      AND    option_name IN ('RESTRICTED','CUSTOM','CUSTOMLIST','CASCADE')
      AND    Dictionary_SYS.Logical_Unit_Is_Active_Num(lu_name) = 1; -- SOLSETFW Active Lu

$IF Component_Fndcob_SYS.INSTALLED $THEN
   
   CURSOR custom_refs (lu_ VARCHAR2) IS
      SELECT lu, lu_type, attribute_name
      FROM custom_field_attributes_tab
      WHERE lu_reference = lu_
      AND data_type = 'REFERENCE'
      AND published = 'TRUE'
      AND constraint_type = 'RESTRICTED';
      
$END
      
   FUNCTION Translate_Lu_Prompt(
      lu_name_    IN VARCHAR2,
      view_name_  IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
   IS
      lu_prompt_ VARCHAR2(2000);
      lu_view_prompt_ VARCHAR2(2000);
      ref_view_ VARCHAR2(2000);
   BEGIN
      ref_view_ := view_name_;
      IF (ref_view_ IS NULL) THEN
         ref_view_ := Dictionary_SYS.Get_Base_View(lu_name_);
      END IF;
      
      lu_prompt_ := Language_SYS.Translate_Lu_Prompt_(lu_name_);
      lu_view_prompt_ := Dictionary_SYS.Get_View_Prompt_(ref_view_);
      RETURN COALESCE(lu_prompt_, lu_view_prompt_, lu_name_);
   END Translate_Lu_Prompt;         
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Check_Restricted_Delete', TRUE);
   -- Loop for all references
   FOR ref_ IN refs LOOP
      Put_Trace___('Inside option '||ref_.option_name||' (CHECK) for logical unit '||lu_name_);

      -- Check keys and execute the reference check
      keys_ := ref_.parent_keys;
      IF (keys_ IS NOT NULL) THEN
         keys_ := keys_||','||ref_.col_name||',';
      ELSE
         keys_ := ref_.col_name||',';
      END IF;
      IF (ref_.option_name = 'RESTRICTED') THEN
         -- Count references in view with key values set
         cnt_ := Restricted_SQL_Ref___(ref_.lu_name, Get_Object_Name___(ref_.lu_name), keys_, key_list_||'^', ref_.view_name);
         IF (cnt_ > 0) THEN
            -- Raise an error with apropriate information.
            key_index_ := 0;
            -- Find the value for the last key. (i.e. ref_.col_name) by looping to the end
            WHILE Get_Key_And_Value___(ref_.lu_name, keys_, key_list_, key_index_ + 1, key_, value_) LOOP
               key_index_ := key_index_ + 1;
            END LOOP;
            -- Get actual value and use it in the error message
            dummy_ := Get_Key_And_Value___(ref_.lu_name, keys_, key_list_, key_index_, key_, value_);
            ref_prompt_ := Translate_Lu_Prompt(Dictionary_SYS.Get_Logical_Unit(ref_.view_name,'VIEW'), ref_.view_name);
            -- If the reference is a lookup use the client value instead of db value in the error message
            lookup_ := Dictionary_SYS.Get_Lookup_Lu(ref_.view_name, key_);
            IF (lookup_ IS NOT NULL) THEN 
               package_name_ := Dictionary_SYS.Get_Base_Package(lookup_);
               -- Try to fetch db value with execute PL/SQL encode stmt
               Assert_SYS.Assert_Is_Package(package_name_);
               stmt_ := 'BEGIN :dbvalue := '||package_name_||'.Decode(:keyvalue); END;';
               BEGIN
                  -- Fetch dbvalue
                  @ApproveDynamicStatement(2011-05-30,krguse)
                  EXECUTE IMMEDIATE stmt_ USING OUT db_value_, IN value_;
                  -- If dbvalue is not null then return value and exit
                  -- else continue with sql statement
                  IF db_value_ IS NOT NULL THEN
                     value_ := db_value_;
                  END IF;
               EXCEPTION -- Continue to next try to find the db_value
                  WHEN OTHERS THEN
                     NULL;
               END;
            END IF;
            Error_SYS.Record_Constraint(lu_name_, ref_prompt_, to_char(cnt_), NULL, value_);
         END IF;
      ELSIF (ref_.option_name = 'CUSTOM' OR ref_.option_name = 'CUSTOMLIST') THEN
         -- Just run the PL/SQL procedure specified for CHECK
         IF (ref_.option_arg1 IS NOT NULL) THEN
            Any_PLSQL_Ref___(ref_.option_arg1, key_list_, ref_.option_name);
         END IF;
      ELSIF (ref_.option_name = 'CASCADE') THEN
         -- Find all childs, get OBJID and run Remove__(CHECK)
         Run_Cascade_Candidates___(ref_.lu_name, Get_Object_Name___(ref_.lu_name), keys_, key_list_||'^', 'CHECK');
      END IF;
   END LOOP;
            
$IF Component_Fndcob_SYS.INSTALLED $THEN
   
   FOR custom_ref in custom_refs(lu_name_) LOOP
      table_name_ := Dictionary_SYS.Get_Base_Table_Name(lu_name_);
   
      Dictionary_Sys.Get_Logical_Unit_Keys_(columns_, values_, lu_name_);
     
      Utility_SYS.tokenize(string_ => columns_, --Columns_ contains a list of the column names, e.g. order_no
                       delimiter_ => Client_SYS.text_separator_,
                       output_table_ => keys_table_,
                       token_count_ => key_count_);
      Utility_SYS.tokenize(string_ => key_list_, --Key_list_ contains a list of the actual key values, e.g. 1234
                       delimiter_ => Client_SYS.text_separator_,
                       output_table_ => keyvalues_table_,
                       token_count_ => key_count_);

      key_index_ := keys_table_.first;
      keyvalue_index_ := keyvalues_table_.first;
      WHILE key_index_ IS NOT NULL LOOP
         key_ := keys_table_(key_index_);
         keyvalue_ := keyvalues_table_(keyvalue_index_);
            
         IF (UPPER(key_) = 'OBJKEY') THEN --If the primary key is objkey in a view, it is always rowkey in the table
            key_ := 'ROWKEY';
         END IF;

         IF key_index_ = keys_table_.first THEN   
            primary_key_where_ := ' WHERE ' || Get_Column_Name___(lu_name_,key_) || '= q''' || '[' || keyvalue_ || ']' || ''' ';
         ELSE
            primary_key_where_ := primary_key_where_ || ' AND ' || Get_Column_Name___(lu_name_,key_) || '= q''' || '[' || keyvalue_ || ']' || ''' ';
         END IF;
            
         key_index_ := keys_table_.next(key_index_);
         keyvalue_index_ := keyvalues_table_.next(keyvalue_index_);
      END LOOP;
      
      IF custom_ref.lu_type = 'CUSTOM_FIELD' THEN
         refering_table_name_:= Custom_Fields_API.Get_Table_Name(custom_ref.lu, custom_ref.lu_type);
      ELSIF custom_ref.lu_type = 'CUSTOM_LU' THEN
         refering_table_name_ := Custom_Lus_API.Get_Table_Name(custom_ref.lu, custom_ref.lu_type);
      END IF;
      
      stmt_ := 'SELECT COUNT(*) FROM ' ||  refering_table_name_ ||
      ' WHERE CF$_' || custom_ref.attribute_name || ' = (SELECT rowkey FROM ' || table_name_ || primary_key_where_ ||')';

      Assert_SYS.Assert_Is_Table(refering_table_name_);
      Assert_SYS.Assert_Is_Table(table_name_);
      Assert_SYS.Assert_Is_Valid_Identifier(custom_ref.attribute_name);
      
      @ApproveDynamicStatement(200140829,haarse)
      EXECUTE IMMEDIATE stmt_ INTO cnt_;
      
      IF (cnt_ > 0) THEN
         ref_prompt_ := Translate_Lu_Prompt(custom_ref.lu);
         Error_SYS.Record_Constraint(lu_name_, ref_prompt_, to_char(cnt_), NULL, NULL);
      END IF;
      
   END LOOP;
   
$END
   
END Check_Restricted_Delete;


-- Do_Cascade_Delete
--   Performs all cascading references.
PROCEDURE Do_Cascade_Delete (
   lu_name_  IN VARCHAR2,
   key_list_ IN VARCHAR2 )
IS
   keys_ VARCHAR2(32000);

   service_list_  VARCHAR2(2000);
   view_name_     VARCHAR2(30);
   package_name_  VARCHAR2(30);
   method_name_   VARCHAR2(30);

   CURSOR refs IS
      SELECT lu_name, view_name, col_name, parent_keys, option_name, option_arg2
      FROM   reference_sys_tab
      WHERE  ref_name = lu_name_
      AND    option_name IN ('CUSTOM','CUSTOMLIST','CASCADE')
      AND    Dictionary_SYS.Logical_Unit_Is_Active_Num(lu_name) = 1; -- SOLSETFW Active Lu;
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Do_Cascade_Delete', TRUE);
   -- Loop for all references
   FOR ref_ IN refs LOOP
      Put_Trace___('Inside option '||ref_.option_name||' (DO) for logical unit '||lu_name_);
      -- Check keys and execute the reference check
      keys_ := ref_.parent_keys;
      IF (keys_ IS NOT NULL) THEN
         keys_ := keys_||',';
      END IF;
      IF (ref_.option_name = 'CUSTOM' OR ref_.option_name = 'CUSTOMLIST') THEN
         -- Just run the PL/SQL procedure specified for DO
         IF (ref_.option_arg2 IS NOT NULL) THEN
            -- Execute the reference cascading
            Any_PLSQL_Ref___(ref_.option_arg2, key_list_, ref_.option_name);
         END IF;
      ELSIF (ref_.option_name = 'CASCADE') THEN
         -- Find all childs, get OBJID and run Remove__(DO)
         Run_Cascade_Candidates___(ref_.lu_name, Get_Object_Name___(ref_.lu_name), keys_||ref_.col_name||',', key_list_||'^', 'DO');
      END IF;
   END LOOP;


   -- Object connection reference check.
   IF ( Fnd_Setting_API.Get_Value('OBJ_CONN_DELETE', Installation_SYS.Get_Installation_Mode) = 'ON') THEN
     --Get the service list for the object.
     Object_Connection_Sys.Get_Configuration_Properties ( view_name_, package_name_, method_name_, service_list_, lu_name_ );
     IF (service_list_ IS NOT NULL) THEN
        --Remove the object connection
        Object_Connection_SYS.Do_Cascade_Delete( service_list_,
                                                 lu_name_,
                                                 Object_Connection_Sys.Convert_To_Key_Reference ( lu_name_, key_list_ ) );
     END IF;
     -- Special handling for Notes
     Object_Connection_Sys.Get_Configuration_Properties ( view_name_, package_name_, method_name_, service_list_, '*' );
     -- If FndNoteBook not in Dictionary you will receive an error, this code avoids the error
     IF (Dictionary_SYS.Exists(service_list_)) THEN 
        IF (service_list_ IS NOT NULL) THEN
           --Remove the object connection
           Object_Connection_SYS.Do_Cascade_Delete( service_list_,
                                                    lu_name_,
                                                    Object_Connection_Sys.Convert_To_Key_Reference ( lu_name_, key_list_ ) );
        END IF;
     END IF;
   END IF;
END Do_Cascade_Delete;


-- Get_Lov_Properties
--   Reads dictionary information for specified logical unit (e.g. view)
--   and returns LOV columns and valid prompt and type for each column.
PROCEDURE Get_Lov_Properties (
   view_name_   IN  VARCHAR2,
   key_names_   OUT VARCHAR2,
   col_names_   OUT VARCHAR2,
   col_prompts_ OUT VARCHAR2,
   col_types_   OUT VARCHAR2 )
IS
   unused_col_refs_            VARCHAR2(32000);
   unused_col_enumerations_    VARCHAR2(32000);
   unused_col_db_names_        VARCHAR2(32000);
   
   unused_key_names_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_names_arr_       DBMS_UTILITY.UNCL_ARRAY;   
   unused_col_prompts_arr_     DBMS_UTILITY.UNCL_ARRAY;
   unused_col_types_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_refs_arr_        DBMS_UTILITY.UNCL_ARRAY;
   unused_db_enumerations_arr_ DBMS_UTILITY.UNCL_ARRAY;
   unused_db_column_names_arr_ DBMS_UTILITY.UNCL_ARRAY;
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_Lov_Properties');
   Get_Lov_Properties___(key_names_, col_names_, col_prompts_, col_types_, unused_col_refs_, unused_col_enumerations_, unused_col_db_names_,
   unused_key_names_arr_, unused_col_names_arr_, unused_col_prompts_arr_, unused_col_types_arr_, unused_col_refs_arr_, unused_db_enumerations_arr_, unused_db_column_names_arr_,
   view_name_, FALSE);
END Get_Lov_Properties;

-- Get_Lov_Properties_With_P_Keys
--   Reads dictionary information for specified logical unit (e.g. view)
--   and returns LOV columns and valid prompt and type for each column including parent keys.
PROCEDURE Get_Lov_Properties_With_P_Keys (
   key_names_           OUT VARCHAR2,
   col_names_           OUT VARCHAR2,
   col_prompts_         OUT VARCHAR2,
   col_types_           OUT VARCHAR2,
   view_name_           IN  VARCHAR2)
IS
   unused_col_refs_            VARCHAR2(32000);
   unused_col_enumerations_    VARCHAR2(32000);
   unused_col_db_names_        VARCHAR2(32000);

   unused_key_names_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_names_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_prompts_arr_     DBMS_UTILITY.UNCL_ARRAY;
   unused_col_types_arr_       DBMS_UTILITY.UNCL_ARRAY;
   unused_col_refs_arr_        DBMS_UTILITY.UNCL_ARRAY;
   unused_db_enumerations_arr_ DBMS_UTILITY.UNCL_ARRAY;
   unused_db_column_names_arr_ DBMS_UTILITY.UNCL_ARRAY;
   
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_Lov_Properties');
   Get_Lov_Properties___(key_names_, col_names_, col_prompts_, col_types_, unused_col_refs_, unused_col_enumerations_, unused_col_db_names_,
   unused_key_names_arr_, unused_col_names_arr_, unused_col_prompts_arr_, unused_col_types_arr_, unused_col_refs_arr_, unused_db_enumerations_arr_, unused_db_column_names_arr_,
   view_name_, TRUE);
END Get_Lov_Properties_With_P_Keys;

-- Get_View_Properties
--   Reads dictionary information for specified logical unit (e.g. view)
--   and returns all columns and valid prompt and type for each column.
PROCEDURE Get_View_Properties (
   view_name_   IN  VARCHAR2,
   col_names_   OUT VARCHAR2,
   col_prompts_ OUT VARCHAR2,
   col_types_   OUT VARCHAR2 )
IS
   prompt_   VARCHAR2(200);
   type_     VARCHAR2(200);
   cols_     VARCHAR2(32000);
   prompts_  VARCHAR2(32000);
   types_    VARCHAR2(32000);
   --SOLSETFW
   CURSOR all_cols IS
      SELECT column_name, column_datatype, column_prompt, type_flag, lov_flag
      FROM   dictionary_sys_view_column_act
      WHERE  view_name  = view_name_
      AND    column_name NOT IN ('OBJID', 'OBJVERSION', 'OBJEVENTS')
      ORDER BY column_index;
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_View_Properties');
   Put_Trace___('Get columns info for view '||view_name_);
   FOR col IN all_cols LOOP
      -- Set or generate prompt text
      prompt_ := Language_SYS.Translate_Item_Prompt_(view_name_||'.'||col.column_name, col.column_prompt, 0);
      IF (prompt_ IS NULL) THEN
         prompt_ := initcap(replace(col.column_name, '_', ' '));
      END IF;
      -- Set or generate datatype
      IF col.column_datatype IS NULL THEN
         SELECT decode(data_type, 'VARCHAR2', 'STRING',
                                  'CHAR',     'STRING',
                                  'INTEGER',  'NUMBER',
                       data_type )
         INTO   type_
         FROM   user_tab_columns
         WHERE  table_name = view_name_
         AND    column_name = col.column_name;
      ELSE
         type_  := col.column_datatype;
      END IF;
      -- Add this columns properties to result lists
      IF (cols_ IS NULL) THEN
         cols_    := col.column_name;
         prompts_ := prompt_;
         types_   := type_;
      ELSE
         cols_    := cols_||','||col.column_name;
         prompts_ := prompts_||'^'||prompt_;
         types_   := types_||'^'||type_;
      END IF;
   END LOOP;
   -- Return appropriate values
   col_names_   := cols_;
   col_prompts_ := prompts_;
   col_types_   := types_;
END Get_View_Properties;


-- Get_Iid_Properties
--   Reads the view definition to retrieve the corresponding database
--   column for a specific atttribute (view columns).
PROCEDURE Get_Iid_Properties (
   db_column_  OUT VARCHAR2,
   view_name_   IN VARCHAR2,
   attribute_   IN VARCHAR2,
   object_type_ IN VARCHAR2 DEFAULT 'VIEW')
IS
   --SOLSETFW
   CURSOR find_view_column(view_ VARCHAR2, col_ VARCHAR2) IS
      SELECT column_name
      FROM   dictionary_sys_view_column_act
      WHERE  view_name = view_
      AND    column_name = Upper(col_);
BEGIN
   General_SYS.Check_Security(service_, 'REFERENCE_SYS', 'Get_Iid_Properties');
   IF (object_type_ = 'TABLE') THEN
      IF (attribute_ LIKE '%/_DB' ESCAPE '/') THEN
         db_column_ := attribute_;
      ELSE
         OPEN  find_view_column(view_name_, attribute_||'_DB');
         FETCH find_view_column INTO db_column_;
         CLOSE find_view_column;
      END IF;
   ELSE -- View
      OPEN  find_view_column(view_name_, attribute_||'_DB');
      FETCH find_view_column INTO db_column_;
      CLOSE find_view_column;
   END IF;
END Get_Iid_Properties;
