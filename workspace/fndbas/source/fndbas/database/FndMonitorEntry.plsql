-----------------------------------------------------------------------------
--
--  Logical unit: FndMonitorEntry
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000830  ROOD  Created for Foundation1 3.0.1 (ToDo#3932).
--  010110  ERFO  Added drill_down_stmt (ToDo#3932).
--  010123  ROOD  Rewrote Validate_Statement___ to handle only numerical results.
--                Made Get_Result handle improper entry_id's.
--  010830  ROOD  Added methods Is_Warning and Perform_Monitoring__.
--                Added event MONITOR_ENTRY_WARNING (ToDo#3993).
--  010904  ROOD  Added method Init_Schedule__ (ToDo#3993).
--  010906  HAAR  Changed method Modify_Batch_Schedule__.
--  011026  ROOD  Moved registration of event to FndMonitorEntry.ins
--                to avoid installation problems.
--  011031  ROOD  Corrections in Init_Schedule__ for execution plan (ToDo#3993).
--  021024  HAAR  Changes in Init_Schedule__ due to changes in BatchSchedule
--                framework (ToDo#4146).
--  030107  HAAR  Removed method Init_Schedule__ (ToDo#4146).
--  030127  HAAR  Moved all registration of events to a separate file (ToDo#4205).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040407  HAAR  Unicode bulk changes, 
--                extended define variable length in Execute_Statement___ (F1PR408B).
--  051013  HAAR  Only parse when validating statement (F1PR480).
--  060524  HAAR  Added check of system privilege DEFINE SQL (F1PR447).
--                Annotated Sql injection.
--  071106  SUMALK Changed the msg_ variable to 32K(Bug#67782)
--  ----------------------- Eagle -------------------------------------------
--  100429  WYRALK Merged Rose Documentation.
--  110811  ASIWLK Added cascade column comment to FND_MONITOR_ENTRY view
---------------------------- Aurena -----------------------------------------
--  191126  MaRalk PACCS-1189, Added record type Result_Data_Rec. Added pipeline function Get_Result_Values 
--  191126         in order to use in Monitor_Entry_Summary view.

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Import_Rec IS RECORD
  (   
      entry_id_            fnd_monitor_entry_tab.entry_id%TYPE,
      description_         fnd_monitor_entry_tab.description%TYPE,
      category_id_         fnd_monitor_entry_tab.category_id%TYPE,
      order_seq_           fnd_monitor_entry_tab.order_seq%TYPE,
      sql_stmt_            fnd_monitor_entry_tab.sql_stmt%TYPE,
      drill_down_stmt_     fnd_monitor_entry_tab.drill_down_stmt%TYPE,
      lower_warning_limit_ fnd_monitor_entry_tab.lower_warning_limit%TYPE,
      upper_warning_limit_ fnd_monitor_entry_tab.upper_warning_limit%TYPE,
      help_text_           fnd_monitor_entry_tab.help_text%TYPE,
      active_              fnd_monitor_entry_tab.active%TYPE,
      system_defined_      fnd_monitor_entry_tab.system_defined%TYPE
      );

TYPE Result_Data_Rec IS RECORD ( 
   entry_id                       VARCHAR2(30), 
   count                          NUMBER,
   warning_indicator              VARCHAR2(1));   

TYPE Result_Data_Rec_Arr IS TABLE OF Result_Data_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Execute_Statement___ (
   sql_stmt_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   cursor_        NUMBER;
   fetched_rows_  NUMBER;
   result_        VARCHAR2(2000);
BEGIN
   cursor_ := dbms_sql.open_cursor;
   -- Safe due to system privilege DEFINE SQL is needed for entering SQL statement
   @ApproveDynamicStatement(2006-05-24,haarse)
   dbms_sql.parse(cursor_, sql_stmt_, dbms_sql.native);
   dbms_sql.define_column(cursor_, 1, result_, 20000);
   fetched_rows_ := dbms_sql.execute_and_fetch(cursor_, TRUE);
   dbms_sql.column_value(cursor_,1, result_);
   dbms_sql.close_cursor(cursor_);
   RETURN result_;
EXCEPTION
   WHEN OTHERS THEN
      IF dbms_sql.is_open(cursor_) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      Error_SYS.Record_General(lu_name_, 'EXECUTEERROR: An error occured while executing the statement :P1!', sql_stmt_);
END Execute_Statement___;


PROCEDURE Validate_Statement___ (
   sql_stmt_ IN VARCHAR2 )
IS
   cursor_        NUMBER;
   invalid_column EXCEPTION;
   PRAGMA         exception_init(invalid_column, -00904);
BEGIN
   -- Validate that the statement is possible to execute and that the result is numerical.
   cursor_ := dbms_sql.open_cursor;
   -- Safe due to system privilege DEFINE SQL is needed for entering SQL statement
   @ApproveDynamicStatement(2006-05-24,haarse)
   dbms_sql.parse(cursor_, sql_stmt_, dbms_sql.native);
   dbms_sql.close_cursor(cursor_);
EXCEPTION
   WHEN invalid_column THEN
      dbms_sql.close_cursor(cursor_);
      Error_SYS.Record_General(lu_name_, 'INVALID_COLUMN: The SQL Statement uses an invalid column name. Rewrite the statement!');
   WHEN value_error THEN
      dbms_sql.close_cursor(cursor_);
      Error_SYS.Record_General(lu_name_, 'NOTNUMERIC: The result from the SQL statement is not possible to convert to a numerical value. Rewrite the statement!');
   WHEN OTHERS THEN
      dbms_sql.close_cursor(cursor_);
      Error_SYS.Record_General(lu_name_, 'INVALID_SQL: The SQL Statement is invalid');     
END Validate_Statement___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTIVE', 'TRUE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT FND_MONITOR_ENTRY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     FND_MONITOR_ENTRY_TAB%ROWTYPE,
   newrec_     IN OUT FND_MONITOR_ENTRY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     fnd_monitor_entry_tab%ROWTYPE,
   newrec_ IN OUT fnd_monitor_entry_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (Client_SYS.Item_Exist('INSTALLATION', attr_)) THEN
      NULL;
   ELSE
      IF (Validate_SYS.Is_Changed(oldrec_.sql_stmt, newrec_.sql_stmt) 
         OR (Validate_SYS.Is_Changed(oldrec_.active, newrec_.active) AND nvl(newrec_.active,'FALSE') = 'TRUE')) THEN
         --Validate the SQL only if not modified by Installation and SQL is modified or user wants to activate
         Validate_Statement___(newrec_.sql_stmt);
      END IF;
   END IF;
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Common___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Perform_Monitoring__
--   Performs monitoring of all active entries in the database and triggers
--   the associated events (requires that the Event Registry is setup for
--   event MONITORENTRYWARNING)
PROCEDURE Perform_Monitoring__
IS
   value_    VARCHAR2(200);
   msg_      VARCHAR2(32000);
   fnd_user_ VARCHAR2(30);
   
   CURSOR get_active_entries IS
      SELECT *
      FROM fnd_monitor_entry
      WHERE active = 'TRUE';
BEGIN
   IF Event_SYS.Event_Enabled( lu_name_, 'MONITOR_ENTRY_WARNING' ) THEN
      FOR entry_ IN get_active_entries LOOP
         IF (entry_.entry_id = 'PLSQLAP_PING') THEN
            --PLSQLAP_PING cannot run as a query
            -- TODO: activities are not supported any longer...
            --value_ := Plsqlap_Server_API.ping__;
            NULL;
         ELSE  
            value_ := Execute_Statement___(entry_.sql_stmt);
         END IF;        
         IF Is_Warning( entry_.entry_id, value_ ) = 1 THEN
            -- Trigger event that a warning has occured
            msg_ := Message_SYS.Construct('MONITOR_ENTRY_WARNING');
            --
            -- Standard event parameters
            --
            fnd_user_ := Fnd_Session_API.Get_Fnd_User;
            Message_SYS.Add_Attribute(msg_, 'EVENT_DATETIME', sysdate );
            Message_SYS.Add_Attribute(msg_, 'USER_IDENTITY', fnd_user_ );
            Message_SYS.Add_Attribute(msg_, 'USER_DESCRIPTION',Fnd_User_API.Get_Description(fnd_user_) );
            Message_SYS.Add_Attribute(msg_, 'USER_MAIL_ADDRESS',Fnd_User_API.Get_Property(fnd_user_, 'SMTP_MAIL_ADDRESS') );
            Message_SYS.Add_Attribute(msg_, 'USER_MOBILE_PHONE', Fnd_User_API.Get_Property(fnd_user_, 'MOBILE_PHONE') );
            --
            -- Primary key for object
            --
            Message_SYS.Add_Attribute(msg_, 'ENTRY_ID', entry_.entry_id);
            --
            -- Other important information
            --
            Message_SYS.Add_Attribute(msg_, 'VALUE', value_);
            Message_SYS.Add_Attribute(msg_, 'DESCRIPTION', entry_.description);
            Message_SYS.Add_Attribute(msg_, 'CATEGORY', entry_.category_id);
            Message_SYS.Add_Attribute(msg_, 'CATEGORY_DESCRIPTION', Fnd_Monitor_Category_API.Get_Description(entry_.category_id));
            Message_SYS.Add_Attribute(msg_, 'SQL_STATEMENT', entry_.sql_stmt);
            Message_SYS.Add_Attribute(msg_, 'LOWER_WARNING_LIMIT', entry_.lower_warning_limit);
            Message_SYS.Add_Attribute(msg_, 'UPPER_WARNING_LIMIT', entry_.upper_warning_limit );
            Message_SYS.Add_Attribute(msg_, 'HELP_TEXT', entry_.help_text );
            Message_SYS.Add_Attribute(msg_, 'DRILL_DOWN_STMT', entry_.drill_down_stmt );
            Event_SYS.Event_Execute( lu_name_, 'MONITOR_ENTRY_WARNING', msg_ );
         END IF;
      END LOOP;
   END IF;
END Perform_Monitoring__;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN            fnd_monitor_entry_tab%ROWTYPE,
   newrec_ IN OUT NOCOPY fnd_monitor_entry_tab%ROWTYPE,
   indrec_ IN OUT NOCOPY Indicator_Rec,
   attr_   IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF nvl(Client_SYS.Get_Item_Value('INSTALLATION', attr_),'FALSE') != 'TRUE' AND oldrec_.system_defined = 'TRUE' THEN 
      IF indrec_.entry_id OR indrec_.category_id  OR indrec_.description OR indrec_.sql_stmt OR indrec_.order_seq 
         OR indrec_.help_text OR indrec_.drill_down_stmt OR indrec_.def_lower_warning_limit OR indrec_.def_upper_warning_limit  THEN
         Error_SYS.Item_General(lu_name_,newrec_.entry_id, 'SYSDEFEVENTMOD: Entry :NAME is a System Defined Entry and cannot be edited');
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN fnd_monitor_entry_tab%ROWTYPE )
IS
BEGIN
   IF remrec_.system_defined = 'TRUE' THEN
      Error_SYS.Item_General(lu_name_,remrec_.entry_id, 'SYSDEFREM: Entry :NAME is a System Defined Entry and cannot be deleted');
   END IF;
   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Result
--   Returns the result from a query performed upon a specific entry.
@UncheckedAccess
FUNCTION Get_Result (
   entry_id_           IN VARCHAR2,
   include_parameters_ IN VARCHAR2 DEFAULT Fnd_Boolean_API.DB_FALSE) RETURN VARCHAR2
IS
   rec_      FND_MONITOR_ENTRY_TAB%ROWTYPE;
   value_    NUMBER;
   warning_  VARCHAR2(1);
BEGIN
   IF Install_Tem_SYS.Installation_Running THEN
      RETURN NULL;
   ELSE
      rec_ := Get_Object_By_Keys___(entry_id_);
      IF rec_.sql_stmt IS NOT NULL THEN
         value_ := Execute_Statement___(rec_.sql_stmt);
         warning_ := to_char(Is_Warning(entry_id_, value_));
         IF include_parameters_ = Fnd_Boolean_API.DB_TRUE THEN
            RETURN value_||'^'||warning_||'^'||rec_.active||'^'||rec_.lower_warning_limit||'^'||rec_.upper_warning_limit||'^'||rec_.description||'^'||rec_.help_text;
         ELSE
            RETURN value_||'^'||warning_;
         END IF;
      ELSE
         RETURN NULL;
      END IF;
   END IF;
END Get_Result;


-- Is_Warning
--   Returns 1 if the value for an investigated monitor entry is outside its
--   limits, 0 if the value is within the limits.
@UncheckedAccess
FUNCTION Is_Warning (
   entry_id_ IN VARCHAR2,
   value_    IN VARCHAR2 ) RETURN NUMBER
IS
   rec_      FND_MONITOR_ENTRY_TAB%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(entry_id_);
   IF rec_.lower_warning_limit IS NULL AND rec_.upper_warning_limit IS NULL THEN
      -- No limits -> No warning
      RETURN 0;
   END IF;
   IF rec_.lower_warning_limit IS NOT NULL AND value_ < rec_.lower_warning_limit THEN
      -- Below lower limit -> Warning
      RETURN 1;
   END IF;
   IF rec_.upper_warning_limit IS NOT NULL AND value_ > rec_.upper_warning_limit THEN
      -- Above upper limit -> Warning
      RETURN 1;
   END IF;
   -- Inside limits -> No warning
   RETURN 0;
END Is_Warning;

--If Rnd changes the SQL in a way that the output gives different result, then the process should be that 
--existing ones are deleted in CDB file and new ones are created with new name. Changes to SQL that does 
--not have a semantic change is allowed to do.

PROCEDURE Import (
   newrec_ Fnd_Monitor_Entry_API.Import_rec
   )
IS
BEGIN
   Import(
      newrec_.entry_id_,
      newrec_.description_,
      newrec_.category_id_,
      newrec_.order_seq_,
      newrec_.sql_stmt_,
      newrec_.drill_down_stmt_,
      newrec_.lower_warning_limit_,
      newrec_.upper_warning_limit_,
      newrec_.help_text_,
      newrec_.active_,
      newrec_.system_defined_
      );
END;


PROCEDURE Import (
   entry_id_            IN VARCHAR2,
   description_         IN VARCHAR2,
   category_id_         IN VARCHAR2,
   order_seq_           IN VARCHAR2,
   sql_stmt_            IN VARCHAR2,
   drill_down_stmt_     IN VARCHAR2,
   lower_warning_limit_ IN VARCHAR2,
   upper_warning_limit_ IN VARCHAR2,
   help_text_           IN VARCHAR2,
   active_              IN VARCHAR2 DEFAULT 'TRUE',
   system_defined_      IN VARCHAR2 DEFAULT 'FALSE'
   )
IS
   info_       VARCHAR2(32000);
   attr_       VARCHAR2(32000);
   oldrec_ fnd_monitor_entry%ROWTYPE;
BEGIN
   IF Fnd_Monitor_Entry_API.Exists(entry_id_) THEN
         SELECT *
            INTO oldrec_
            FROM fnd_monitor_entry
            WHERE entry_id = entry_id_;
   -- If exists - overwrite all that is marked as read only in table. For attribute ACTIVE do nothing.
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   Client_SYS.Add_To_Attr('CATEGORY_ID', category_id_, attr_);
   Client_SYS.Add_To_Attr('ORDER_SEQ', order_seq_, attr_);
   Client_SYS.Add_To_Attr('SQL_STMT', sql_stmt_, attr_);
   Client_SYS.Add_To_Attr('DRILL_DOWN_STMT', drill_down_stmt_, attr_);
   Client_SYS.Add_To_Attr('HELP_TEXT', help_text_, attr_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED',system_defined_,attr_);
   Client_SYS.Add_To_Attr('DEF_LOWER_WARNING_LIMIT',lower_warning_limit_,attr_);
   Client_SYS.Add_To_Attr('DEF_UPPER_WARNING_LIMIT',upper_warning_limit_,attr_);
   -- Extra attribute for installation to avoid validation of SQL_STMT
   Client_SYS.Add_To_Attr('INSTALLATION', 'TRUE', attr_);
   
   IF system_defined_ = 'TRUE' THEN
         --IF existing DEFAULT_LOWER_LIMIT is same as  existing LOWER_WARNING_LIMIT  and 
         --existing  DEFAULT_UPPER_LIMIT is same as  existing UPPER_WARNING_LIMIT  
         --then update both actual and default value with new value from file.
      IF oldrec_.def_lower_warning_limit = oldrec_.lower_warning_limit AND oldrec_.def_upper_warning_limit = oldrec_.upper_warning_limit THEN
         Client_SYS.Add_To_Attr('LOWER_WARNING_LIMIT', lower_warning_limit_, attr_); 
         Client_SYS.Add_To_Attr('UPPER_WARNING_LIMIT', upper_warning_limit_, attr_);
      END IF;
   ELSE
      --Override everything but ACTIVE
      Client_SYS.Add_To_Attr('LOWER_WARNING_LIMIT', lower_warning_limit_, attr_);
      Client_SYS.Add_To_Attr('UPPER_WARNING_LIMIT', upper_warning_limit_, attr_);     
   END IF;
   Fnd_Monitor_Entry_API.Modify__(info_, oldrec_.objid, oldrec_.objversion, attr_, 'DO');
ELSE
   Client_SYS.Add_To_Attr('ENTRY_ID', entry_id_, attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', description_, attr_);
   Client_SYS.Add_To_Attr('CATEGORY_ID', category_id_, attr_);
   Client_SYS.Add_To_Attr('ORDER_SEQ', order_seq_, attr_);
   Client_SYS.Add_To_Attr('SQL_STMT', sql_stmt_, attr_);
   Client_SYS.Add_To_Attr('DRILL_DOWN_STMT', drill_down_stmt_, attr_);
   Client_SYS.Add_To_Attr('HELP_TEXT', help_text_, attr_);
   Client_SYS.Add_To_Attr('SYSTEM_DEFINED',system_defined_,attr_);
   Client_SYS.Add_To_Attr('DEF_LOWER_WARNING_LIMIT',lower_warning_limit_,attr_);
   Client_SYS.Add_To_Attr('DEF_UPPER_WARNING_LIMIT',upper_warning_limit_,attr_);
   Client_SYS.Add_To_Attr('LOWER_WARNING_LIMIT', lower_warning_limit_, attr_);
   Client_SYS.Add_To_Attr('UPPER_WARNING_LIMIT', upper_warning_limit_, attr_);  
   Client_SYS.Add_To_Attr('ACTIVE', active_, attr_);
   -- Extra attribute for installation to avoid validation of SQL_STMT
   Client_SYS.Add_To_Attr('INSTALLATION', 'TRUE', attr_);
   Fnd_Monitor_Entry_API.New__(info_, oldrec_.objid, oldrec_.objversion, attr_, 'DO');
END IF;
END Import;


@UncheckedAccess
FUNCTION Get_Result_Values(
   entry_id_           IN VARCHAR2) RETURN Result_Data_Rec_Arr PIPELINED
IS
   rec_         Result_Data_Rec;
   result_      VARCHAR2(100);
BEGIN
   result_ := Get_Result(entry_id_);
   rec_.entry_id := entry_id_;
   rec_.count := SUBSTR(result_, 0, (INSTR(result_, '^') - 1));
   rec_.warning_indicator := SUBSTR(result_, (INSTR(result_, '^') + 1));
   PIPE ROW (rec_);
END Get_Result_Values; 

-- Get_Service_Update
--   Returns the service update code.
@UncheckedAccess
FUNCTION Get_Service_Update RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Setting_API.Get_Value('SERVICE_UPDATE');
END Get_Service_Update;
