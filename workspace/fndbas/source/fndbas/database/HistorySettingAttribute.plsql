-----------------------------------------------------------------------------
--
--  Logical unit: HistorySettingAttribute
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990629  RaKu  Recreated with new templates and new name.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  050426  UTGU  Added method Register(F1PR480).
--  050704  HAAR  Changed view to use Dba_xxx instead of User_xxx (F1PR843).
--  051014  RAKU  Added so only records with objid_ != chartorowid('0') are deleted (F1PR480).
--  111123  ChMu  Added where clause to filter out columns which are not supported in History Logging (Bug#100005)
--  120926  DUWI  Added new function Check_History_Enable (Bug#104703
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Has_New_Log_Event___ (
   oldrec_ IN HISTORY_SETTING_ATTRIBUTE_TAB%ROWTYPE,
   newrec_ IN HISTORY_SETTING_ATTRIBUTE_TAB%ROWTYPE ) RETURN BOOLEAN
IS
BEGIN
   IF newrec_.log_insert = 1 AND oldrec_.log_insert = 0 THEN
      RETURN TRUE;
   ELSIF newrec_.log_update = 1 AND oldrec_.log_update = 0 THEN
      RETURN TRUE;
   ELSIF newrec_.log_delete = 1 AND oldrec_.log_delete = 0 THEN
      RETURN TRUE;
   END IF;
   RETURN FALSE;
END Has_New_Log_Event___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@UncheckedAccess
FUNCTION Check_Log__ (
   table_name_ IN VARCHAR2,
   column_name_ IN VARCHAR2 ) RETURN NUMBER
IS
   count_ NUMBER;

   CURSOR count_for_all_columns IS
      SELECT count(*)
      FROM   HISTORY_SETTING_ATTRIBUTE_TAB
      WHERE  table_name = table_name_;

   CURSOR count_for_column IS
      SELECT count(*)
      FROM   HISTORY_SETTING_ATTRIBUTE_TAB
      WHERE  table_name = table_name_
      AND    column_name = column_name_;
BEGIN
   IF column_name_ IS NULL THEN
      OPEN  count_for_all_columns;
      FETCH count_for_all_columns INTO count_;
      CLOSE count_for_all_columns;
   ELSE
      OPEN  count_for_column;
      FETCH count_for_column INTO count_;
      CLOSE count_for_column;
   END IF;
   RETURN (count_);
END Check_Log__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Register (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2,
   info_msg_    IN VARCHAR2 )
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   objrec_     HISTORY_SETTING_ATTRIBUTE_TAB%ROWTYPE;
   attr_       VARCHAR2(2000);
BEGIN
   objrec_.table_name := table_name_;
   objrec_.column_name := column_name_;
   objrec_.log_insert := Message_SYS.Find_Attribute(info_msg_, 'LOG_INSERT', '0');
   objrec_.log_update := Message_SYS.Find_Attribute(info_msg_, 'LOG_UPDATE', '0');
   objrec_.log_delete := Message_SYS.Find_Attribute(info_msg_, 'LOG_DELETE', '0');
   Insert___ (objid_, objversion_, objrec_, attr_);
END Register;


@UncheckedAccess
FUNCTION Check_History_Enable(
   table_name_ VARCHAR2) RETURN BOOLEAN
IS
  temp_ NUMBER;
  CURSOR get_histroy IS
     SELECT 1
       FROM HISTORY_SETTING_ATTRIBUTE_TAB t
      WHERE t.table_name = table_name_;
BEGIN
   OPEN get_histroy;
   FETCH get_histroy INTO temp_;
   
   IF get_histroy%FOUND THEN
     CLOSE get_histroy;
     RETURN TRUE;
   END IF;
   CLOSE get_histroy;
   RETURN FALSE;
END Check_History_Enable;

PROCEDURE Disable_Column_History (
   table_name_  IN VARCHAR2,
   column_name_ IN VARCHAR2)
IS
BEGIN
   UPDATE history_setting_attribute_tab
   SET log_insert = 0, log_update = 0, log_delete = 0
   WHERE table_name = table_name_
   AND column_name = column_name_;
END Disable_Column_History;

