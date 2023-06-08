-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveExecAttr
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000301  HAAR  Created
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
-----------------------------------------------------------------------------


layer Core;


-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT DATA_ARCHIVE_EXEC_ATTR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   --
   -- Generate a sequence according to existing objects
   --
   SELECT nvl(max(attr_no) + 1, 1)
      INTO newrec_.attr_no
      FROM DATA_ARCHIVE_EXEC_ATTR
      WHERE order_id = newrec_.order_id
      AND   exec_id = newrec_.exec_id;
   Client_SYS.Add_To_Attr('ATTR_NO', newrec_.attr_no, attr_);
   --
   Check_If_Parameter___ (newrec_.aoid, newrec_.table_name, newrec_.column_name);
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     DATA_ARCHIVE_EXEC_ATTR_TAB%ROWTYPE,
   newrec_     IN OUT DATA_ARCHIVE_EXEC_ATTR_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Check_If_Parameter___ (newrec_.aoid, newrec_.table_name, newrec_.column_name);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_If_Parameter___ (
   aoid_        IN VARCHAR2,
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2 )
IS
   when_ordered_   VARCHAR2(30);
   CURSOR get_paramter IS
      SELECT when_ordered
      FROM   data_archive_source_attr_tab
      WHERE  aoid = aoid_
      AND    table_name = table_name_
      AND    column_name = column_name_;
BEGIN
   OPEN  get_paramter;
   FETCH get_paramter INTO when_ordered_;
   CLOSE get_paramter;
   IF (when_ordered_ = 'FALSE') THEN
      Error_Sys.Appl_General(
         'DataArchiveExecAttr',
         'NOT_PARAMETER_ERR: Only columns being defined as parameters can have a where-clause.');
   END IF;
END Check_If_Parameter___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert__ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT data_archive_exec_attr_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   Insert___ (objid_, objversion_, newrec_, attr_);
END Insert__;

PROCEDURE Register__ (
   order_id_ IN NUMBER,
   exec_id_ IN VARCHAR2,
   attr_no_ IN NUMBER,
   info_msg_ IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     data_archive_exec_attr_tab%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.order_id := order_id_;
   Data_Archive_Order_API.Exist(objrec_.order_id);
   objrec_.exec_id := exec_id_;
   Data_Archive_Order_Exec_API.Exist(objrec_.order_id, objrec_.exec_id);
   objrec_.attr_no := Message_SYS.Find_Attribute(info_msg_, 'ATTR_NO', '');
   objrec_.where_clause := Message_SYS.Find_Attribute(info_msg_, 'WHERE_CLAUSE', '');
   objrec_.aoid := Message_SYS.Find_Attribute(info_msg_, 'AOID', '');
   objrec_.table_name := Message_SYS.Find_Attribute(info_msg_, 'TABLE_NAME', '');
   objrec_.column_name := Message_SYS.Find_Attribute(info_msg_, 'COLUMN_NAME', '');
   Insert___ (objid_, objversion_, objrec_, attr_);
END Register__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
