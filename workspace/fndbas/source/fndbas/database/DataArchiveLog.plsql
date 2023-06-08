-----------------------------------------------------------------------------
--
--  Logical unit: DataArchiveLog
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
   newrec_     IN OUT DATA_ARCHIVE_LOG_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   --
   -- Generate a sequence according to existing objects
   --
   SELECT nvl(max(log_id) + 1, 1)
      INTO newrec_.log_id
      FROM DATA_ARCHIVE_LOG;
   Client_SYS.Add_To_Attr('LOG_ID', newrec_.log_id, attr_);
   --
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Write_Log_ (
   newrec_     IN OUT data_archive_log_tab%ROWTYPE)
IS
   objid_      VARCHAR2(100);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(2000);
BEGIN
   IF (newrec_.log_id IS NULL) THEN
      Insert___ (objid_, objversion_, newrec_, attr_);
      newrec_.log_id := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('LOG_ID', attr_));
   ELSE
      newrec_.rowkey := Get_Objkey(newrec_.log_id);
      Update___ (objid_, newrec_, newrec_, attr_, objversion_, TRUE);
   END IF;
END Write_Log_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
