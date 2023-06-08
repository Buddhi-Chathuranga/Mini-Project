-----------------------------------------------------------------------------
--
--  Logical unit: ServerLogCategory
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  041228  HAAR  Created
--  050404  JORA  Added assertion for dynamic SQL.  (F1PR481)
--                Remove Run_Ddl_Command___ and replaced with EXECUTE IMMEDIATE.
--  100318  HAAR  Added support for Alert Log errors.(EACS-433).
--  110624  DUWI   Added function  Check_Enable_ (Bug96748)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Disable_Server_Error___
IS
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'DROP TRIGGER FND_SERVER_ERROR_TRG';
END Disable_Server_Error___;

PROCEDURE Disable_Ddl_Audit___
IS
BEGIN
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE 'DROP TRIGGER DDL_AUDIT_TRG';
END Disable_Ddl_Audit___;


PROCEDURE Disable_Sql_Injections___
IS
BEGIN
   NULL;
END Disable_Sql_Injections___;


PROCEDURE Enable_Server_Error___
IS
   stmt_             VARCHAR2(4000);
   newline_ CONSTANT VARCHAR2(1) := chr(10);
BEGIN
   stmt_ := stmt_ || 'CREATE OR REPLACE TRIGGER FND_Server_Error_TRG ' || newline_;
   stmt_ := stmt_ || '   AFTER servererror ON DATABASE ' || newline_;
   stmt_ := stmt_ || 'DECLARE ' || newline_;
   stmt_ := stmt_ || '   stmt_     VARCHAR2(2000); ' || newline_;
   stmt_ := stmt_ || 'BEGIN ' || newline_;
   stmt_ := stmt_ || '      stmt_ :=          ''DECLARE ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''   n         BINARY_INTEGER; ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''   sql_text  ora_name_list_t; ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''   sql_text_ VARCHAR2(4000); ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''BEGIN ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''   n := ora_sql_txt(sql_text);''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''   FOR i IN 1..n LOOP ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      IF length(sql_text_ || sql_text(i)) > 4000 THEN ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''         EXIT; ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      END IF; ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      sql_text_ := sql_text_ || sql_text(i); ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''   END LOOP; ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''   '||Fnd_Session_API.Get_App_Owner||'.Server_Log_API.Log_Server_Error_(sql_text_); ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''END;''; ' || newline_;
   stmt_ := stmt_ || '      EXECUTE IMMEDIATE stmt_; ' || newline_;
   stmt_ := stmt_ || 'EXCEPTION ' || newline_;
   stmt_ := stmt_ || '   WHEN OTHERS THEN ' || newline_;
   stmt_ := stmt_ || '      NULL; ' || newline_;
   stmt_ := stmt_ || 'END; ' || newline_;
   @ApproveDynamicStatement(2006-02-15,pemase)
   EXECUTE IMMEDIATE stmt_;
END Enable_Server_Error___;


PROCEDURE Enable_Ddl_Audit___
IS
   stmt_             VARCHAR2(4000);
   newline_ CONSTANT VARCHAR2(1) := chr(10);
BEGIN
   stmt_ := stmt_ || 'CREATE OR REPLACE TRIGGER DDL_AUDIT_TRG ' || newline_;
   stmt_ := stmt_ || '   AFTER DDL ON DATABASE ' || newline_;
   stmt_ := stmt_ || 'DECLARE ' || newline_;
   stmt_ := stmt_ || '   stmt_     VARCHAR2(2000); ' || newline_;
   stmt_ := stmt_ || 'BEGIN ' || newline_;
   stmt_ := stmt_ || '      stmt_ :=          ''DECLARE ''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      l_sql_text       ORA_NAME_LIST_T;'';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      sql_text_        VARCHAR2(4000); '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      rec_             SERVER_LOG_TAB%ROWTYPE; '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''BEGIN '' ;' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      SELECT   ORA_LOGIN_USER, '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''               OSUSER, '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''               MACHINE, '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''               SYSDATE,  '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''               ''''DICTIONARY_OBJECT: ''''||ORA_DICT_OBJ_OWNER ||''''.''''||ORA_DICT_OBJ_NAME||chr(10)||''''OBJECT_TYPE: ''''||ORA_DICT_OBJ_TYPE ||chr(10)||''''DDL_EVENT: ''''||ORA_SYSEVENT ||chr(10)||''''MODULE :''''||module ||chr(10)||''''ACTION :''''||action,'';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''               CLIENT_IDENTIFIER,  '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''               PROGRAM '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      INTO     rec_.oracle_user,rec_.os_identity,rec_.machine,rec_.date_created,rec_.text1,rec_.client_identifier,rec_.program '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      FROM     SYS.DUAL,SYS.V_$SESSION''; --G_V$Session is not required here since this call is made to the get current session info by sitting inside the same session' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      WHERE    SYS_CONTEXT(''''USERENV'''',''''SESSIONID'''' ) = audsid(+) AND ORA_SYSEVENT <> ''''TRUNCATE'''';'';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      BEGIN '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''            FOR l IN 1..ORA_SQL_TXT(l_sql_text) LOOP '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''                  sql_text_ := sql_text_ || l_sql_text(l); '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''            END LOOP; '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      EXCEPTION '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''            WHEN OTHERS THEN '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''                  NULL; '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      END; '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      rec_.text2 := sql_text_; '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      rec_.category_id := ''''Ddl Audit''''; '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      rec_.identity := Fnd_Session_API.Get_Fnd_User;''; ' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''      Server_Log_Api.Log_Ddl_Audit(rec_); '';' || newline_;
   stmt_ := stmt_ || '      stmt_ := stmt_ || ''END;''; ' || newline_;
   stmt_ := stmt_ || '      EXECUTE IMMEDIATE stmt_; ' || newline_;
   stmt_ := stmt_ || 'EXCEPTION ' || newline_;
   stmt_ := stmt_ || '      WHEN OTHERS THEN ' || newline_;
   stmt_ := stmt_ || '            NULL; ' || newline_;
   stmt_ := stmt_ || 'END; ' || newline_;
   @ApproveDynamicStatement(2015-02-10,maddlk)
   EXECUTE IMMEDIATE stmt_;
END Enable_Ddl_Audit___;
  

PROCEDURE Enable_Sql_Injections___
IS
BEGIN
   NULL;
END Enable_Sql_Injections___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CLEAR_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('CLEAR', Fnd_Boolean_API.Decode('FALSE'), attr_);
   Client_SYS.Add_To_Attr('ENABLE_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('ENABLE', Fnd_Boolean_API.Decode('FALSE'), attr_);
   Client_SYS.Add_To_Attr('DAYS_TO_KEEP', 7, attr_);
END Prepare_Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SERVER_LOG_CATEGORY_TAB%ROWTYPE,
   newrec_     IN OUT SERVER_LOG_CATEGORY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
-- Do things if enable has changed
   IF (newrec_.enable != oldrec_.enable) THEN
      IF (newrec_.category_id = 'Server Errors') THEN
         IF (newrec_.enable      = 'TRUE') THEN
            enable_server_error___;
         ELSE
            disable_server_error___;
         END IF;
      ELSIF (newrec_.category_id = 'SQL Injections') THEN
         IF (newrec_.enable      = 'TRUE') THEN
            enable_sql_injections___;
         ELSE
            disable_sql_injections___;
         END IF;
      ELSIF (newrec_.category_id = 'Ddl Audit') THEN
         IF (newrec_.enable      = 'TRUE') THEN
            Enable_Ddl_Audit___;
         ELSE
            disable_Ddl_Audit___;
         END IF;
      ELSIF (newrec_.category_id = 'Debug') THEN
         NULL;
      ELSIF (newrec_.category_id = 'Deployment') THEN
         NULL;
      ELSIF (newrec_.category_id = 'Deployment detail') THEN
         NULL;
      ELSIF (newrec_.category_id = 'Event Errors') THEN
         NULL;
      ELSIF (newrec_.category_id = 'In-Memory') THEN
         NULL;
      ELSIF (newrec_.category_id = 'Obsolete object') THEN
         NULL;
      ELSE
         Error_SYS.Appl_General(lu_name_, 'SESSIONS: The category ":P1" is no longer available.', newrec_.category_id);
      END IF;
   END IF;
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

@UncheckedAccess
FUNCTION Check_Enable_ (
   category_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Get_Enable_Db(category_id_);
END Check_Enable_;


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


