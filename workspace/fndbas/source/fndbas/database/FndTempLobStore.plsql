-----------------------------------------------------------------------------
--
--  Logical unit: FndTempLobStore
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
days_to_keep_old_entries_ CONSTANT NUMBER := 60*30/86400; -- 30 minutes

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT fnd_temp_lob_store_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.lob_id := sys_guid();
   newrec_.created_by_user := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_at := sysdate;
   super(objid_, objversion_, newrec_, attr_);
END Insert___;




-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------
PROCEDURE Remove_Old_Temp_Lobs_ 
IS
  TYPE t_lob_id_list IS TABLE OF fnd_temp_lob_store_tab.lob_id%TYPE; 
  old_lob_id_list_ t_lob_id_list;
  table_rec_ fnd_temp_lob_store_tab%ROWTYPE;
BEGIN
   $IF Component_Fndmob_SYS.INSTALLED $THEN   
      SELECT tls.lob_id BULK COLLECT INTO old_lob_id_list_ 
      FROM fnd_temp_lob_store_tab tls LEFT JOIN mobile_failed_lob_data_tab fld ON (tls.lob_id = fld.lob_id) 
      WHERE fld.lob_id IS NULL AND tls.created_at < sysdate - days_to_keep_old_entries_;
   $ELSE
      SELECT lob_id BULK COLLECT INTO old_lob_id_list_ FROM fnd_temp_lob_store_tab WHERE created_at < sysdate - days_to_keep_old_entries_;
   $END
   
   FOR i IN 1 .. old_lob_id_list_.count LOOP
      BEGIN
         table_rec_.lob_id := old_lob_id_list_(i);
         Remove___(table_rec_, FALSE);
      EXCEPTION
         WHEN Error_SYS.Err_Record_Locked THEN
            NULL;
      END;
   END LOOP;
END Remove_Old_Temp_Lobs_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

