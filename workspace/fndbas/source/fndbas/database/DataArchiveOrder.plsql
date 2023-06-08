-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveOrder
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000301  HAAR  Created
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  060524  HAAR  Added check of system privilege DEFINE SQL (F1PR447).
--  060626  HAAR  Added support for Persian calendar (Bug#58601).
-----------------------------------------------------------------------------


layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

newline_ CONSTANT VARCHAR2(2) := chr(13)||chr(10);

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('ACTIVE', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DATA_ARCHIVE_ORDER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   --
   -- Generate a sequence according to existing objects
   --
   SELECT nvl(max(order_id) + 1, 1)
      INTO newrec_.order_id
      FROM DATA_ARCHIVE_ORDER;
   Client_SYS.Add_To_Attr('ORDER_ID', newrec_.order_id, attr_);
   --
  
   IF (newrec_.next_date IS NULL) THEN
      newrec_.next_date := Batch_SYS.Update_Exec_Time__(newrec_.execution_plan);
      Client_SYS.Add_To_Attr('NEXT_DATE', newrec_.next_date, attr_);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     DATA_ARCHIVE_ORDER_TAB%ROWTYPE,
   newrec_     IN OUT DATA_ARCHIVE_ORDER_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_Session_API.Get_Fnd_User);
   objversion_ := to_char(newrec_.rowversion,'YYYYMMDDHH24MISS');
   IF (newrec_.execution_plan != oldrec_.execution_plan) THEN
      newrec_.next_date := Batch_SYS.Update_Exec_Time__(newrec_.execution_plan);
      Client_SYS.Add_To_Attr('NEXT_DATE', newrec_.next_date, attr_);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Format___(
   value_  IN  VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN(''''||Replace(value_, '''', '''''')||'''');
END Format___;

FUNCTION Format___(
   value_  IN  NUMBER) RETURN VARCHAR2
IS
BEGIN
   RETURN(value_);
END Format___;

FUNCTION Format___(
   value_  IN  DATE) RETURN VARCHAR2
IS
BEGIN
   IF (value_ IS NULL) THEN
      RETURN(Database_SYS.Get_Last_Calendar_Date);
   ELSE
      RETURN('To_Date('''||To_Char(value_,'YYYYMMDD HH24MISS')||''',''YYYYMMDD HH24MISS'')');
   END IF;
END Format___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Copy__ (
   order_id_ IN OUT NUMBER,
   new_description_ IN VARCHAR2 )
IS
   objid_         VARCHAR2(100);
   objversion_    VARCHAR2(100);
   orderrec_      data_archive_order_tab%ROWTYPE;
   execrec_       data_archive_order_exec_tab%ROWTYPE;
   paramrec_      data_archive_exec_attr_tab%ROWTYPE;
   attr_          VARCHAR2(2000);
   tmp_order_id_  NUMBER := order_id_;
   tmp_exec_id_   data_archive_order_exec_tab.exec_id%TYPE;

   CURSOR get_order IS
      SELECT *
      FROM   data_archive_order_tab
      WHERE  order_id = tmp_order_id_;
   CURSOR get_exec IS
      SELECT *
      FROM   data_archive_order_exec_tab
      WHERE  order_id = tmp_order_id_;
   CURSOR get_param IS
      SELECT *
      FROM   data_archive_exec_attr_tab
      WHERE  order_id = tmp_order_id_
      AND    exec_id = tmp_exec_id_;
BEGIN
   FOR ord IN get_order LOOP
      orderrec_ := NULL;
      orderrec_.description := new_description_;
      orderrec_.active := 'FALSE';
      orderrec_.execution_plan := ord.execution_plan;
      orderrec_.next_date := ord.next_date;
      Insert___ (objid_, objversion_, orderrec_, attr_);
      order_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ORDER_ID', attr_));
      FOR exec IN get_exec LOOP
         execrec_ := NULL;
         execrec_.order_id := order_id_;
         execrec_.exec_id := exec.exec_id;
         execrec_.seq_no := exec.seq_no;
         execrec_.active := 'FALSE';
         execrec_.aoid := exec.aoid;
         Data_Archive_Order_Exec_API.Insert__ (objid_, objversion_, execrec_, attr_);
         tmp_exec_id_ :=  exec.exec_id; 
         FOR param IN get_param LOOP
            paramrec_ := NULL;
            paramrec_.order_id := order_id_;
            paramrec_.exec_id := param.exec_id;
            paramrec_.attr_no := param.attr_no;
            paramrec_.where_clause := param.where_clause;
            paramrec_.aoid := param.aoid;
            paramrec_.table_name := param.table_name;
            paramrec_.column_name := param.column_name;
            Data_Archive_Exec_Attr_API.Insert__ (objid_, objversion_, paramrec_, attr_);
         END LOOP;
      END LOOP;
   END LOOP;
END Copy__;

PROCEDURE Export_Settings__ (
   info_ OUT VARCHAR2,
   order_id_ IN NUMBER)
IS
   exec_id_ data_archive_order_exec_tab.exec_id%TYPE;
   CURSOR get_order IS
      SELECT *
      FROM   data_archive_order_tab
      WHERE  order_id = order_id_;
   CURSOR get_exec IS
      SELECT *
      FROM   data_archive_order_exec_tab
      WHERE  order_id = order_id_;
   CURSOR get_param IS
      SELECT *
      FROM   data_archive_exec_attr_tab
      WHERE  order_id = order_id_
      AND    exec_id = exec_id_;
BEGIN
   info_ := info_ || 'DECLARE' || newline_;
   info_ := info_ || '   order_id_   NUMBER;' || newline_;
   info_ := info_ || '   info_msg_   VARCHAR2(32000);' || newline_;
   info_ := info_ || 'BEGIN' || newline_;
   FOR ord IN get_order LOOP
      info_ := info_ || '   info_msg_ := NULL;' || newline_;
      info_ := info_ || '   info_msg_ := Message_SYS.Construct(''DATA_ARCHIVE_ORDER_TAB'');'  || newline_;
      info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''DESCRIPTION'', ' || Format___(ord.description) || ');'  || newline_;
      info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''ACTIVE'', ' || Format___(ord.active) || ');'  || newline_;
      info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''EXECUTION_PLAN'', ' || Format___(ord.execution_plan) || ');' || newline_;
      info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''NEXT_DATE'', ' || Format___(ord.next_date) || ');' || newline_;
      info_ := info_ || '   Data_Archive_SYS.Register_Order(order_id_, info_msg_);' || newline_ || newline_;
      FOR exec IN get_exec LOOP
         info_ := info_ || '   info_msg_ := NULL;' || newline_;
         info_ := info_ || '   info_msg_ := Message_SYS.Construct(''DATA_ARCHIVE_ORDER_EXEC_TAB'');'  || newline_;
         info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''SEQ_NO'', ' || Format___(exec.seq_no) || ');'  || newline_;
         info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''ACTIVE'', ' || Format___(exec.active) || ');'  || newline_;
         info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''AOID'', ' || Format___(exec.aoid) || ');' || newline_;
         info_ := info_ || '   Data_Archive_SYS.Register_Order_Exec(order_id_, '||Format___(exec.exec_id)||', info_msg_);' || newline_ || newline_;
         exec_id_ := exec.exec_id;
         FOR param IN get_param LOOP
            info_ := info_ || '   info_msg_ := NULL;' || newline_;
            info_ := info_ || '   info_msg_ := Message_SYS.Construct(''DATA_ARCHIVE_EXEC_ATTR_TAB'');'  || newline_;
            info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''AOID'', ' || Format___(param.aoid) || ');'  || newline_;
            info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''TABLE_NAME'', ' || Format___(param.table_name) || ');'  || newline_;
            info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''COLUMN_NAME'', ' || Format___(param.column_name) || ');' || newline_;
            info_ := info_ || '   Message_SYS.Add_Attribute(info_msg_, ''WHERE_CLAUSE'', ' || Format___(param.where_clause) || ');' || newline_;
            info_ := info_ || '   Data_Archive_SYS.Register_Exec_Attr(order_id_, '||Format___(param.exec_id)||', '||Format___(param.attr_no)||', info_msg_);' || newline_ || newline_;
         END LOOP;
      END LOOP;
   END LOOP;
   info_ := info_ || 'END;' || newline_;
   info_ := info_ || '/' || newline_;
END Export_Settings__;

PROCEDURE Register__ (
   order_id_ OUT NUMBER,
   info_msg_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     DATA_ARCHIVE_ORDER_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.order_id := order_id_;
   objrec_.description := Message_SYS.Find_Attribute(info_msg_, 'DESCRIPTION', '');
   objrec_.active := 'FALSE';
   objrec_.execution_plan := Message_SYS.Find_Attribute(info_msg_, 'EXECUTION_PLAN', '');
   objrec_.next_date := Message_SYS.Find_Attribute(info_msg_, 'NEXT_DATE', To_Date('47131231 120000', 'YYYYMMDD HH24MISS'));
   Insert___ (objid_, objversion_, objrec_, attr_);
   order_id_ := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('ORDER_ID', attr_));
END Register__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Update_Next_Execution_(
   order_id_   IN NUMBER)
IS
   active_           VARCHAR2(20) := 'TRUE';
   execution_plan_   VARCHAR2(200);
   next_date_        DATE := NULL;
   cursor_           NUMBER;
   dummy_            NUMBER;

   CURSOR get_order IS
      SELECT execution_plan
      FROM   data_archive_order_tab
      WHERE  order_id = order_id_;
BEGIN
   OPEN  get_order;
   FETCH get_order INTO execution_plan_;
   CLOSE get_order;
   next_date_ := Batch_SYS.Update_Exec_Time__(execution_plan_);
   IF (next_date_ IS NULL) THEN
      cursor_ := dbms_sql.open_cursor;
      -- Safe due to system privilege DEFINE SQL is needed for entering execution_plan
      @ApproveDynamicStatement(2006-05-24,haarse)
      dbms_sql.parse(cursor_, 'SELECT '||execution_plan_||' FROM dual', dbms_sql.native);
      dbms_sql.define_column(cursor_, 1, next_date_);
      dummy_ := dbms_sql.execute(cursor_);
      IF (dbms_sql.fetch_rows(cursor_) > 0) THEN
         dbms_sql.column_value(cursor_, 1, next_date_);
      END IF;
      dbms_sql.close_cursor(cursor_);
   END IF;
   IF (next_date_ IS NULL) THEN
      active_ := 'FALSE';
   END IF;
   UPDATE data_archive_order_tab
   SET    next_date = next_date_,
          active    = active_
   WHERE  order_id  = order_id_;
EXCEPTION
   WHEN OTHERS THEN
      UPDATE data_archive_order_tab
      SET    execution_plan = NULL,
             next_date      = NULL,
             active         = 'FALSE'
      WHERE  order_id       = order_id_;
END Update_Next_Execution_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
