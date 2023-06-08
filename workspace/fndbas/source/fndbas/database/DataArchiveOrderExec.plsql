-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveOrderExec
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000301  HAAR  Created
--  000502  HAAR  Changed Check_Master_Stmt___ to procedure and changed error 
--                handling.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  060526  HAAR  Annotated Sql injection.
--  070524  HAAR  Exec_Id can not handle space (Bug#65598).
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
   Client_SYS.Add_To_Attr('ACTIVE', 'FALSE', attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DATA_ARCHIVE_ORDER_EXEC_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.exec_id := replace(newrec_.exec_id, ' ', '_');
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Stmt___(
   stmt_          IN VARCHAR2) 
IS
   c1_      NUMBER;
BEGIN
   c1_ := dbms_sql.open_cursor;
   -- Safe due to system privilege DEFINE SQL is needed for entering statement in DataArchiveSource
   @ApproveDynamicStatement(2006-05-24,haarse)
   dbms_sql.parse(c1_, stmt_, dbms_sql.native);
   dbms_sql.close_cursor(c1_);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(c1_)) THEN
         dbms_sql.close_cursor(c1_);
      END IF;
      RAISE;
END Check_Stmt___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Check_Master_Stmt__(
   stmt_    OUT VARCHAR2,
   order_id_ IN NUMBER,
   exec_id_  IN VARCHAR2 )
IS
   statement_  VARCHAR2(32000);
   aoid_       VARCHAR2(20);
   CURSOR get_aoid IS
      SELECT aoid
      FROM   data_archive_order_exec_tab
      WHERE  order_id = order_id_
      AND    exec_id = exec_id_;
BEGIN
   OPEN  get_aoid;
   FETCH get_aoid INTO aoid_;
   CLOSE get_aoid;
   statement_ := Data_Archive_Util_API.Create_Select_Master(aoid_, order_id_, exec_id_);
   Check_Stmt___(statement_);
   stmt_ := statement_;
END Check_Master_Stmt__;

PROCEDURE Insert__ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT data_archive_order_exec_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Insert___ (objid_, objversion_, newrec_, attr_);
END Insert__;

PROCEDURE Register__ (
   order_id_ IN NUMBER,
   exec_id_ IN VARCHAR2,
   info_msg_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     data_archive_order_exec_tab%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.order_id := order_id_;
   Data_Archive_Order_API.Exist(objrec_.order_id);
   objrec_.exec_id := exec_id_;
   objrec_.seq_no := Message_SYS.Find_Attribute(info_msg_, 'SEQ_NO', '');
   objrec_.active := 'FALSE';
   objrec_.aoid := Message_SYS.Find_Attribute(info_msg_, 'AOID', '');
   Data_Archive_Object_API.Exist(objrec_.aoid);
   Insert___ (objid_, objversion_, objrec_, attr_);
END Register__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
