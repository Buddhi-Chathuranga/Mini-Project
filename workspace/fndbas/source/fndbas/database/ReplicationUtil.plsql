-----------------------------------------------------------------------------
--
--  Logical unit: ReplicationUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  000101  JhMa    Created.
--  000621  ROOD    Modified parameters in methods Receive_Config___, Receive_Site___, 
--                  Receive_Configuration__, Receive_Message__, Send_Configuration__ and Send_Site__.
--  000628  ROOD    Changes in error handling.
--  020620  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  050404  JORA    Added assertion for dynamic SQL.  (F1PR481)
--  060105  UTGULK  Annotated Sql injection.
--  061027  NiWiLK  Avoid open cursors(Bug#61394).
--  061027  NiWiLK  No cleanup is done when a message is received. Cleanup is moved to F1 
--                  light cleanup process(Bug#61210).
--  070705  SUMALK  Changed the Cleanup_ method for performance reasons.(Bug#65157).
--  100222  JHMASE  Changed cleanup condition of Transaction_sys_local_TAB (Bug#89177)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Change_Bo_State___ (
   business_object_  IN VARCHAR2,
   action_           IN VARCHAR2 )
IS
   sql_1_            VARCHAR2(30);
   sql_2_            VARCHAR2(30);
   CURSOR c1 IS
      SELECT trigger_table,
             lu_name
      FROM   replication_attr_group_def_tab
      WHERE  business_object = business_object_;
BEGIN
   IF ( action_ IN ('ENABLE','DISABLE') ) THEN
      sql_1_ := 'ALTER TRIGGER ';
      sql_2_ := ' ' || action_;
   ELSIF ( action_ = 'REMOVE' ) THEN
      sql_1_ := 'DROP TRIGGER ';
      sql_2_ := NULL;
   ELSE
      NULL;
   END IF;
   FOR c1_rec IN c1 LOOP
      BEGIN
         Assert_SYS.Assert_Is_Table(c1_rec.trigger_table);
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE sql_1_ || REPLACE(c1_rec.trigger_table, 'TAB', 'RBT') || sql_2_;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         Assert_SYS.Assert_Is_Logical_Unit(c1_rec.lu_name);
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE sql_1_ || Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name) || '_RBT' || sql_2_;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         Assert_SYS.Assert_Is_Table(c1_rec.trigger_table);
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE sql_1_ || REPLACE(c1_rec.trigger_table, 'TAB', 'RAT') || sql_2_;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         Assert_SYS.Assert_Is_Logical_Unit(c1_rec.lu_name);
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE sql_1_ || Dictionary_SYS.ClientNameToDbName_(c1_rec.lu_name) || '_RAT' || sql_2_;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
   IF ( action_ = 'REMOVE' ) THEN
      BEGIN
         Assert_SYS.Assert_Is_Package(business_object_ || '_BOS_API');
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE 'DROP PACKAGE ' || business_object_ || '_BOS_API';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         Assert_SYS.Assert_Is_Package(business_object_ || '_BOR_API');
         @ApproveDynamicStatement(2006-01-05,utgulk)
         EXECUTE IMMEDIATE 'DROP PACKAGE ' || business_object_ || '_BOR_API';
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END IF;
END Change_Bo_State___;


PROCEDURE Change_Object_State___ (
   object_name_      IN VARCHAR2,
   object_type_      IN VARCHAR2,
   action_           IN VARCHAR2 )
IS
   object_name_1_    VARCHAR2(30);
   object_name_2_    VARCHAR2(30);
   sql_1_            VARCHAR2(2000);
   sql_2_            VARCHAR2(2000);
   cursor_           INTEGER;
   execute_          INTEGER;
   unknown_type_     EXCEPTION;
   CURSOR replication_object_triggers IS
      SELECT trigger_name
      FROM   user_triggers
      WHERE (trigger_name LIKE '%_RAT'
      OR  trigger_name LIKE '%_RBT');
BEGIN
   IF ( (object_type_ = 'TRIGGER') AND (UPPER(object_name_) = 'ALL') ) THEN
      cursor_ := dbms_sql.open_cursor;
      FOR c1_rec IN replication_object_triggers LOOP
         IF ( action_ IN ('ENABLE','DISABLE','COMPILE') ) THEN
            sql_1_ := 'ALTER TRIGGER' || ' ' || c1_rec.trigger_name || ' ' || action_;
         ELSIF ( action_ = 'REMOVE' ) THEN
            sql_1_ := 'DROP TRIGGER' || ' ' || c1_rec.trigger_name;
         END IF;
         BEGIN
            Assert_SYS.Assert_Is_Trigger(c1_rec.trigger_name);
            @ApproveDynamicStatement(2006-01-05,utgulk)
            dbms_sql.parse(cursor_, sql_1_, dbms_sql.native);
            execute_ := dbms_sql.EXECUTE(cursor_);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
   ELSE
      IF ( object_type_ = 'TRIGGER' ) THEN
         object_name_1_ :=  SUBSTR(object_name_, 1, LENGTH(object_name_)-3) || 'RBT';
         object_name_2_ :=  SUBSTR(object_name_, 1, LENGTH(object_name_)-3) || 'RAT';
         IF ( action_ IN ('ENABLE','DISABLE','COMPILE') ) THEN
            Assert_SYS.Assert_Is_Trigger(object_name_1_);
            Assert_SYS.Assert_Is_Trigger(object_name_2_);
            sql_1_ := 'ALTER TRIGGER' || ' ' || object_name_1_ || ' ' || action_;
            sql_2_ := 'ALTER TRIGGER' || ' ' || object_name_2_ || ' ' || action_;
         ELSIF ( action_ = 'REMOVE' ) THEN
            Assert_SYS.Assert_Is_Trigger(object_name_1_);
            Assert_SYS.Assert_Is_Trigger(object_name_2_);
            sql_1_ := 'DROP TRIGGER' || ' ' || object_name_1_;
            sql_2_ := 'DROP TRIGGER' || ' ' || object_name_2_;
         ELSE
            RETURN;
         END IF;
      ELSIF ( object_type_ = 'PACKAGE' ) THEN
         IF ( action_ = 'REMOVE' ) THEN
            Assert_SYS.Assert_Is_Package(object_name_);
            sql_1_ := 'DROP PACKAGE'  || ' ' || object_name_;
         ELSIF ( action_ = 'COMPILE' ) THEN
            Assert_SYS.Assert_Is_Package(object_name_);
            sql_1_ := 'ALTER PACKAGE' || ' ' || object_name_ || ' ' || action_;
         ELSE
            RETURN;
         END IF;
      ELSE
         RAISE unknown_type_;
      END IF;
      cursor_ := dbms_sql.Open_Cursor;
      BEGIN
         @ApproveDynamicStatement(2006-01-05,utgulk)
         dbms_sql.parse(cursor_, sql_1_, dbms_sql.native);
         execute_ := dbms_sql.EXECUTE(cursor_);
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      IF ( sql_2_ IS NOT NULL ) THEN
         BEGIN
            @ApproveDynamicStatement(2006-01-05,utgulk)
            dbms_sql.parse(cursor_, sql_2_, dbms_sql.native);
            execute_ := dbms_sql.EXECUTE(cursor_);
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END IF;
   END IF;
   dbms_sql.close_cursor(cursor_);
EXCEPTION
   WHEN unknown_type_ THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      Error_SYS.Appl_General(lu_name_, 'UNKNOWNTYPE: Unknown type :P1', object_type_);
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cursor_)) THEN
         dbms_sql.close_cursor(cursor_);
      END IF;
      RAISE;
END Change_Object_State___;


PROCEDURE Receive_Config___ (
   message_id_      IN NUMBER,
   sender_          IN VARCHAR2,
   send_warning_    IN BOOLEAN,
   send_info_       IN BOOLEAN,
   receive_warning_ IN BOOLEAN,
   receive_info_    IN BOOLEAN )
IS
   CURSOR receive_group (site_id_ replication_sender_tab.site_id%TYPE) IS
      SELECT a.receive_group
      FROM   replication_sender_tab a
      WHERE  a.site_id = site_id_;
   CURSOR c1_attr_group (business_object_ replication_attr_group_def_tab.business_object%TYPE) IS
      SELECT a.lu_name AS lu_name
      FROM   replication_attr_group_def_tab a
      WHERE  a.business_object = business_object_;
   CURSOR c2_attr (business_object_ replication_attr_def_tab.business_object%TYPE,
      lu_name_         replication_attr_def_tab.lu_name%TYPE) IS
         SELECT a.column_name  AS column_name,
                a.table_name   AS table_name,
                a.sequence_no  AS sequence_no
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = business_object_
         AND    a.lu_name         = lu_name_;
   CURSOR getmessageline_pub (message_id_  IN_MESSAGE.MESSAGE_ID%TYPE) IS
      SELECT *
      FROM   IN_MESSAGE_LINE_PUB
      WHERE  message_id = message_id_
      ORDER BY message_line;

   receive_group_          replication_sender_tab.receive_group%TYPE;
   business_object_        replication_object_def_tab.business_object%TYPE;
   previous_bo_            replication_object_def_tab.business_object%TYPE := NULL;
   lu_name_                replication_attr_group_def_tab.lu_name%TYPE;
   column_name_            replication_attr_def_tab.column_name%TYPE;
   comments_               receive_object_tab.comments%TYPE;
   new_attr_               VARCHAR2(32000);
   info_                   VARCHAR2(2000);
   objid_                  VARCHAR2(2000);
   objversion_             VARCHAR2(2000);
   data_present_           EXCEPTION;
   PRAGMA EXCEPTION_INIT(data_present_, -20112);
BEGIN
   OPEN receive_group (sender_);
   FETCH receive_group INTO receive_group_;
   IF ( receive_group%NOTFOUND ) THEN
      receive_group_ := sender_;
      Client_SYS.Clear_Attr(new_attr_);
      Receive_Group_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
      Client_SYS.Set_Item_Value('RECEIVE_GROUP', receive_group_, new_attr_);
      Client_SYS.Set_Item_Value('DESCRIPTION', 'Created by configuration replication ' ||  TO_CHAR(sysdate, Client_SYS.date_format_), new_attr_);
      BEGIN
         Receive_Group_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
      EXCEPTION
         WHEN data_present_ THEN
            NULL;
      END;
   END IF;
   CLOSE receive_group;
   FOR message_line_rec_ IN getmessageline_pub(message_id_) LOOP
      IF ( message_line_rec_.name = 'BUSINESS_OBJECT' ) THEN
         IF ( previous_bo_ IS NOT NULL ) THEN
            BEGIN
               business_object_ := previous_bo_;
               Replication_Object_Def_API.Exist(business_object_);
               FOR c1_rec_ IN c1_attr_group(business_object_) LOOP
                  BEGIN
                     Receive_Attr_Group_API.Exist(receive_group_, business_object_, c1_rec_.lu_name);
                  EXCEPTION
                     WHEN OTHERS THEN
                        Client_SYS.Clear_Attr(new_attr_);
                        Receive_Attr_Group_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
                        Client_SYS.Set_Item_Value('RECEIVE_GROUP', receive_group_, new_attr_);
                        Client_SYS.Set_Item_Value('BUSINESS_OBJECT', business_object_, new_attr_);
                        Client_SYS.Set_Item_Value('LU_NAME', c1_rec_.lu_name, new_attr_);
                        Client_SYS.Set_Item_Value('NEW_ALLOWED', 'FALSE', new_attr_);
                        Client_SYS.Set_Item_Value('MODIFY_ALLOWED', 'FALSE', new_attr_);
                        comments_ := 'Attribute Group NOT replicated';
                        Client_SYS.Set_Item_Value('COMMENTS', comments_, new_attr_);
                        Client_SYS.Set_Item_Value('OBJECT_UPDATED', 'TRUE', new_attr_);
                        BEGIN
                           Receive_Attr_Group_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
                        EXCEPTION
                           WHEN data_present_ THEN
                              NULL;
                           WHEN OTHERS THEN
                              Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'ReceiveObject',
                                 NULL, NULL, message_id_, NULL, 'RCVCONF01: Fail to insert ReceiveObject: ' ||
                                 business_object_, sqlerrm, 'RECEIVE', 'ERROR',
                                 send_warning_, send_info_, receive_warning_, receive_info_);
                        END;
                  END;
                  FOR c2_rec_ IN c2_attr(business_object_, c1_rec_.lu_name) LOOP
                     BEGIN
                        Receive_Attr_API.Exist(receive_group_, business_object_, c1_rec_.lu_name, c2_rec_.column_name);
                     EXCEPTION
                        WHEN OTHERS THEN
                           Client_SYS.Clear_Attr(new_attr_);
                           Receive_Attr_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
                           Client_SYS.Set_Item_Value('RECEIVE_GROUP', receive_group_, new_attr_);
                           Client_SYS.Set_Item_Value('BUSINESS_OBJECT', business_object_, new_attr_);
                           Client_SYS.Set_Item_Value('LU_NAME', c1_rec_.lu_name, new_attr_);
                           Client_SYS.Set_Item_Value('COLUMN_NAME', c2_rec_.column_name, new_attr_);
                           Client_SYS.Set_Item_Value('TABLE_NAME', c2_rec_.table_name, new_attr_);
                           Client_SYS.Set_Item_Value('SEQUENCE_NO', c2_rec_.sequence_no, new_attr_);
                           Client_SYS.Set_Item_Value('NEW_ALLOWED', 'FALSE', new_attr_);
                           Client_SYS.Set_Item_Value('MODIFY_ALLOWED', 'FALSE', new_attr_);
                           comments_ := 'Attribute NOT replicated';
                           Client_SYS.Set_Item_Value('COMMENTS', comments_, new_attr_);
                           Client_SYS.Set_Item_Value('OBJECT_UPDATED', 'TRUE', new_attr_);
                           BEGIN
                              Receive_Attr_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
                           EXCEPTION
                              WHEN data_present_ THEN
                                 NULL;
                              WHEN OTHERS THEN
                                 Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'ReceiveObject',
                                    NULL, NULL, message_id_, NULL, 'RCVCONF02: Fail to insert ReceiveObject: ' ||
                                    business_object_, sqlerrm, 'RECEIVE', 'ERROR',
                                    send_warning_, send_info_, receive_warning_, receive_info_);
                           END;
                     END;
                  END LOOP;
               END LOOP;
            EXCEPTION
               WHEN OTHERS THEN
                  NULL;
            END;
         END IF;
         business_object_ := message_line_rec_.c01;
         previous_bo_ := business_object_;
         Client_SYS.Clear_Attr(new_attr_);
         Receive_Object_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
         Client_SYS.Set_Item_Value('RECEIVE_GROUP', receive_group_, new_attr_);
         Client_SYS.Set_Item_Value('BUSINESS_OBJECT', business_object_, new_attr_);
         Client_SYS.Set_Item_Value('NEW_ALLOWED', 'FALSE', new_attr_);
         Client_SYS.Set_Item_Value('MODIFY_ALLOWED', 'FALSE', new_attr_);
         Client_SYS.Set_Item_Value('OBJECT_UPDATED', 'TRUE', new_attr_);
         comments_ := NULL;
         BEGIN
            Replication_Object_Def_API.Exist(business_object_);
         EXCEPTION
            WHEN OTHERS THEN
               comments_ := 'Business Object definition missing';
         END;
         BEGIN
            Client_SYS.Set_Item_Value('COMMENTS', comments_, new_attr_);
            Receive_Object_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
         EXCEPTION
            WHEN data_present_ THEN
               NULL;
            WHEN OTHERS THEN
               Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'ReceiveObject', NULL, NULL,
                  message_id_, message_line_rec_.message_line, 'RCVCONF03: Fail to insert ReceiveObject: ' || business_object_,
                  sqlerrm, 'RECEIVE', 'ERROR',
                  send_warning_, send_info_, receive_warning_, receive_info_);
         END;
      ELSIF ( message_line_rec_.name = 'ATTRIBUTE_GROUP' ) THEN
         business_object_ := message_line_rec_.c01;
         lu_name_ := message_line_rec_.c03;
         Client_SYS.Clear_Attr(new_attr_);
         Receive_Attr_Group_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
         Client_SYS.Set_Item_Value('RECEIVE_GROUP', receive_group_, new_attr_);
         Client_SYS.Set_Item_Value('BUSINESS_OBJECT', business_object_, new_attr_);
         Client_SYS.Set_Item_Value('LU_NAME', lu_name_, new_attr_);
         Client_SYS.Set_Item_Value('NEW_ALLOWED', 'TRUE', new_attr_);
         Client_SYS.Set_Item_Value('MODIFY_ALLOWED', 'TRUE', new_attr_);
         Client_SYS.Set_Item_Value('OBJECT_UPDATED', 'TRUE', new_attr_);
         comments_ := NULL;
         BEGIN
            Replication_Attr_Group_Def_API.Exist(business_object_, lu_name_);
         EXCEPTION
            WHEN OTHERS THEN
               comments_ := 'Attribute Group missing in business object definition';
         END;
         BEGIN
            Client_SYS.Set_Item_Value('COMMENTS', comments_, new_attr_);
            Receive_Attr_Group_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
         EXCEPTION
            WHEN data_present_ THEN
               NULL;
            WHEN OTHERS THEN
               Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'ReceiveAttrGroup', NULL, NULL,
                  message_id_, message_line_rec_.message_line, 'RCVCONF04: Fail to insert ReceiveAttrGroup: ' ||
                  business_object_ || '.' || lu_name_, sqlerrm, 'RECEIVE', 'ERROR',
                  send_warning_, send_info_, receive_warning_, receive_info_);
         END;
      ELSIF ( message_line_rec_.name = 'ATTRIBUTE' ) THEN
         business_object_ := message_line_rec_.c01;
         lu_name_ := message_line_rec_.c03;
         column_name_ := message_line_rec_.c05;
         Client_SYS.Clear_Attr(new_attr_);
         Receive_Attr_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
         Client_SYS.Set_Item_Value('RECEIVE_GROUP', receive_group_, new_attr_);
         Client_SYS.Set_Item_Value('BUSINESS_OBJECT', business_object_, new_attr_);
         Client_SYS.Set_Item_Value('LU_NAME', lu_name_, new_attr_);
         Client_SYS.Set_Item_Value('COLUMN_NAME', column_name_, new_attr_);
         Client_SYS.Set_Item_Value('TABLE_NAME', message_line_rec_.c07, new_attr_);
         Client_SYS.Set_Item_Value('SEQUENCE_NO', message_line_rec_.c19, new_attr_);
         Client_SYS.Set_Item_Value('NEW_ALLOWED', message_line_rec_.c15, new_attr_);
         Client_SYS.Set_Item_Value('MODIFY_ALLOWED', message_line_rec_.c17, new_attr_);
         Client_SYS.Set_Item_Value('OBJECT_UPDATED', 'TRUE', new_attr_);
         comments_ := NULL;
         BEGIN
            Replication_Attr_Def_API.Exist(business_object_, lu_name_, column_name_);
         EXCEPTION
            WHEN OTHERS THEN
               comments_ := 'Attribute missing in business object definition';
         END;
         BEGIN
            Client_SYS.Set_Item_Value('COMMENTS', comments_, new_attr_);
            Receive_Attr_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
         EXCEPTION
            WHEN data_present_ THEN
               NULL;
            WHEN OTHERS THEN
               Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'ReceiveAttr', NULL, NULL, message_id_,
                  message_line_rec_.message_line, 'RCVCONF05: Fail to insert ReceiveAttr: ' || business_object_ || '.' ||
                  lu_name_ || '.' || column_name_, sqlerrm, 'RECEIVE', 'ERROR',
                  send_warning_, send_info_, receive_warning_, receive_info_);
         END;
      ELSE
         -- Unknown Configuration data
         -- --------------------------
         Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'UNKNOWN: ' || message_line_rec_.name, NULL, NULL,
            message_id_, message_line_rec_.message_line, 'RCVCONF06: Unknown Replication Configuration: ' || message_line_rec_.name,
            NULL, 'RECEIVE', 'WARNING',
            send_warning_, send_info_, receive_warning_, receive_info_);
      END IF;
   END LOOP;
END Receive_Config___;


PROCEDURE Receive_Site___ (
   message_id_      IN NUMBER,
   send_warning_    IN BOOLEAN,
   send_info_       IN BOOLEAN,
   receive_warning_ IN BOOLEAN,
   receive_info_    IN BOOLEAN )
IS
   new_attr_      VARCHAR2(32000);
   info_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   site_          VARCHAR2(2000);
   CURSOR getmessageline_pub (message_id_  IN_MESSAGE.MESSAGE_ID%TYPE) IS
      SELECT *
      FROM   IN_MESSAGE_LINE_PUB
      WHERE  message_id = message_id_
      ORDER BY message_line;
   data_present_  EXCEPTION;
   PRAGMA EXCEPTION_INIT(data_present_, -20112);
BEGIN
   FOR message_line_rec_ IN getmessageline_pub(message_id_) LOOP
      site_ := message_line_rec_.c01;
      IF ( message_line_rec_.name = 'INSTALLATION_SITE' ) THEN
         Client_SYS.Clear_Attr(new_attr_);
         Installation_Site_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
         Client_SYS.Set_Item_Value('SITE_ID', message_line_rec_.c01, new_attr_);
         Client_SYS.Set_Item_Value('TIMEZONE_DIFFERENCE', message_line_rec_.c03, new_attr_);
         Client_SYS.Set_Item_Value('DESCRIPTION', 'Created by configuration replication ' ||
         TO_CHAR(sysdate, Client_SYS.date_format_), new_attr_);
         Client_SYS.Set_Item_Value('THIS_SITE', 'FALSE', new_attr_);
         BEGIN
            Installation_Site_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
         EXCEPTION
            WHEN data_present_ THEN
               NULL;
            WHEN OTHERS THEN
               Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'InstallationSite', NULL, NULL,
                  message_id_, message_line_rec_.message_line, 'RCVSITE01: Fail to insert InstallationSite: ' || site_,
                  sqlerrm, 'RECEIVE', 'ERROR',
                  send_warning_, send_info_, receive_warning_, receive_info_);
         END;
      ELSIF ( message_line_rec_.name = 'REPLICATION_RECEIVER' ) THEN
         Client_SYS.Clear_Attr(new_attr_);
         Receive_Group_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
         Client_SYS.Set_Item_Value('RECEIVE_GROUP', message_line_rec_.c07, new_attr_);
         Client_SYS.Set_Item_Value('DESCRIPTION', 'Created by configuration replication ' ||
         TO_CHAR(sysdate, Client_SYS.date_format_), new_attr_);
         BEGIN
            Receive_Group_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
         EXCEPTION
            WHEN data_present_ THEN
               NULL;
            WHEN OTHERS THEN
               Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'Receive_Group', NULL, NULL,
                  message_id_, message_line_rec_.message_line, 'RCVSITE02: Fail to insert ReplicationSender: ' || site_,
                  sqlerrm, 'RECEIVE', 'ERROR',
                  send_warning_, send_info_, receive_warning_, receive_info_);
         END;
         Client_SYS.Clear_Attr(new_attr_);
         Replication_Sender_API.New__(info_, objid_, objversion_, new_attr_, 'PREPARE');
         Client_SYS.Set_Item_Value('SENDER', message_line_rec_.c01, new_attr_);
         Client_SYS.Set_Item_Value('SITE_ID', message_line_rec_.c03, new_attr_);
         Client_SYS.Set_Item_Value('RECEIVE_GROUP', message_line_rec_.c07, new_attr_);
         Client_SYS.Set_Item_Value('DESCRIPTION', 'Created by configuration replication ' ||
         TO_CHAR(sysdate, Client_SYS.date_format_), new_attr_);
         BEGIN
            Replication_Sender_API.New__(info_, objid_, objversion_, new_attr_, 'DO');
         EXCEPTION
            WHEN data_present_ THEN
               NULL;
            WHEN OTHERS THEN
               Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'ReplicationSender', NULL, NULL,
                  message_id_, message_line_rec_.message_line, 'RCVSITE03: Fail to insert ReplicationSender: ' || site_,
                  sqlerrm, 'RECEIVE', 'ERROR',
                  send_warning_, send_info_, receive_warning_, receive_info_);
         END;
      ELSE
         -- Unknown Configuration data
         -- --------------------------
         Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'UNKNOWN: ' || message_line_rec_.name, NULL, NULL,
            message_id_, message_line_rec_.message_line, 'RCVSITE04: Unknown Replication Configuration: ' || message_line_rec_.name,
            NULL, 'RECEIVE', 'WARNING',
            send_warning_, send_info_, receive_warning_, receive_info_);
      END IF;
   END LOOP;
END Receive_Site___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Business_Object_State__ (
   business_object_ IN VARCHAR2,
   action_          IN VARCHAR2 )
IS
   unknown_action_  EXCEPTION;
   value_missing_   EXCEPTION;
BEGIN
   IF ( (business_object_ IS NULL) OR (action_ IS NULL) ) THEN
      RAISE value_missing_;
   END IF;
   IF ( UPPER(action_) IN ('ENABLE','DISABLE','REMOVE') ) THEN
      Change_BO_State___(business_object_, UPPER(action_));
   ELSE
      RAISE unknown_action_;
   END IF;
EXCEPTION
   WHEN value_missing_ THEN
      Error_SYS.Appl_General(lu_name_, 'MANDATORY: NULL not allowed');
   WHEN unknown_action_ THEN
      Error_SYS.Appl_General(lu_name_, 'UNKNOWNACTION: Unknown action :P1', action_);
END Business_Object_State__;


PROCEDURE Cleanup__
IS
   cleanup_days_   NUMBER;
   cleanup_states_  VARCHAR2(100);
   date_limit_     DATE;

   TYPE out_message IS TABLE OF NUMBER;
   out_message_ out_message;

   TYPE in_message IS TABLE OF NUMBER;
   in_message_ in_message;



   CURSOR cleanup_outbox_(cleanup_states_  VARCHAR2) IS
      SELECT message_id
      FROM   out_message
      WHERE  objstate   IN (select regexp_substr(cleanup_states_,'[^,]+', 1, level) from dual
                        connect by regexp_substr(cleanup_states_, '[^,]+', 1, level) is not null)
      AND    class_id   LIKE 'IFS_REPLICATION%'
      AND    objversion < TO_CHAR(date_limit_, 'yyyymmddhh24miss');
   CURSOR cleanup_inbox_(cleanup_states_  VARCHAR2) IS
      SELECT message_id
      FROM   in_message
      WHERE  objstate   IN (select regexp_substr(cleanup_states_,'[^,]+', 1, level) from dual
                        connect by regexp_substr(cleanup_states_, '[^,]+', 1, level) is not null)
      AND    class_id   LIKE 'IFS_REPLICATION%'
      AND    objversion < TO_CHAR(date_limit_, 'yyyymmddhh24miss');
BEGIN
   BEGIN
      cleanup_days_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('REPL_KEEP'));
      cleanup_states_ := Fnd_Setting_API.Get_Value('CON_CLEANUP_STATES');
   EXCEPTION
      WHEN OTHERS THEN
         cleanup_days_ := NULL;
   END;
   IF (cleanup_days_ IS NOT NULL) THEN
      IF ( cleanup_days_ < 1 ) THEN
         date_limit_ := sysdate - cleanup_days_;
      ELSE
         date_limit_ := TRUNC(sysdate - cleanup_days_);
      END IF;

      OPEN cleanup_outbox_(cleanup_states_);
      LOOP
         FETCH cleanup_outbox_ BULK COLLECT INTO out_message_ LIMIT 1000;

         FORALL i_ IN 1..out_message_.COUNT
         DELETE FROM out_message_line_tab WHERE message_id = out_message_(i_);

         FORALL i_ IN 1..out_message_.COUNT
         DELETE FROM out_message_tab      WHERE message_id = out_message_(i_);
         @ApproveTransactionStatement(2013-11-19,haarse)
         COMMIT;              

         EXIT WHEN cleanup_outbox_%NOTFOUND;
      END LOOP;
      CLOSE cleanup_outbox_;

      OPEN cleanup_inbox_(cleanup_states_);
      LOOP
         FETCH cleanup_inbox_ BULK COLLECT INTO in_message_ LIMIT 1000;
         FORALL i_ IN 1..in_message_.COUNT
         DELETE FROM in_message_line_tab WHERE message_id = in_message_(i_);

         FORALL i_ IN 1..in_message_.COUNT
         DELETE FROM in_message_tab      WHERE message_id = in_message_(i_);
         @ApproveTransactionStatement(2013-11-19,haarse)
         COMMIT;
         EXIT WHEN cleanup_inbox_%NOTFOUND;                    
      END LOOP;
      CLOSE cleanup_inbox_;

      DELETE
         FROM transaction_sys_local_tab
         WHERE procedure_name IN ('Replication_Util_API.Replicate__',
         'Replication_Util_API.Receive_Message__',
         'Out_Message_Util_API.Transfer_Data__')
         AND   state    = 'Ready'
         AND   executed < date_limit_;

      DELETE
         FROM   replication_queue_tab
         WHERE  rowstate   = 'Replicated'
         AND    rowversion < date_limit_;

      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
   END IF;
END Cleanup__;


FUNCTION Convert_Time__ (
   date_                IN DATE,
   timezone_difference_ IN NUMBER ) RETURN DATE
IS
   timezone_difference_error_ EXCEPTION;
BEGIN
   IF ( ABS(timezone_difference_) > 24 ) THEN
      RAISE timezone_difference_error_;
   END IF;
   IF ( date_ = TRUNC(date_) ) THEN
      RETURN date_;
   ELSE
      RETURN (date_ + (Installation_Site_API.Get_Timezone_Difference_ - timezone_difference_) * 1/24);
   END IF;
EXCEPTION
   WHEN timezone_difference_error_ THEN
      Error_SYS.Appl_General(lu_name_, 'INVALIDTIMEZONEDIFF: Invalid timezone difference :P1.', timezone_difference_);
END Convert_Time__;


PROCEDURE Load_Business_Object__ (
   replication_group_ IN  VARCHAR2,
   business_object_   IN  VARCHAR2,
   date_              IN  DATE,
   lu_                IN  VARCHAR2,
   commit_interval_   IN  NUMBER,
   return_            OUT VARCHAR2 )
IS
   date_string_        VARCHAR2(12);
   method_             VARCHAR2(2000);
   suffix_             VARCHAR2(10) := '_BOS_API';
   method_name_        VARCHAR2(30) := 'Resend_Business_Object';
   send_warning_       BOOLEAN := FALSE;
   send_info_          BOOLEAN := FALSE;
   receive_warning_    BOOLEAN := FALSE;
   receive_info_       BOOLEAN := FALSE;
   send_warning_str_   VARCHAR2(5) := 'FALSE';
   send_info_str_      VARCHAR2(5) := 'FALSE';
   receive_warning_str_ VARCHAR2(5) := 'FALSE';
   receive_info_str_   VARCHAR2(5) := 'FALSE';
   dummy_              NUMBER;
   group_missing_      EXCEPTION;
   object_missing_     EXCEPTION;
   lu_missing_         EXCEPTION;
   CURSOR c_lu (object_  replication_attr_group_def_tab.business_object%TYPE,
      name_    replication_attr_group_def_tab.lu_name%TYPE) IS
         SELECT 1
         FROM replication_attr_group_def_tab
         WHERE business_object = object_
         AND   lu_name         = name_;
BEGIN
   IF ( replication_group_ IS NULL ) THEN
      RAISE group_missing_;
   END IF;
   IF ( business_object_ IS NULL ) THEN
      RAISE object_missing_;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_WARN'),'ON')  = 'ON' ) THEN
      send_warning_    := TRUE;
      send_warning_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_INFO'),'OFF') = 'ON' ) THEN
      send_info_       := TRUE;
      send_info_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_WARN'),'ON')  = 'ON' ) THEN
      receive_warning_ := TRUE;
      receive_warning_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_INFO'),'OFF') = 'ON' ) THEN
      receive_info_    := TRUE;
      receive_info_str_ := 'TRUE';
   END IF;
   IF ( lu_ IS NOT NULL ) THEN
      OPEN c_lu (business_object_, lu_);
      FETCH c_lu INTO dummy_;
      IF ( c_lu%NOTFOUND ) THEN
         CLOSE c_lu;
         RAISE lu_missing_;
      END IF;
      CLOSE c_lu;
   END IF;
   date_string_ := TO_CHAR(date_, 'yyyy-mm-dd');
   Assert_SYS.Assert_Is_Package_Method(business_object_ || suffix_ || '.' || method_name_);
   method_ := 'BEGIN ' || business_object_ || suffix_ || '.' || method_name_ || '(' ||
   ':replication_group_, :business_object_, :date_string_, :lu_, :commit_interval_, ' ||
   ':send_warning_, :send_info_, :receive_warning_, :receive_info_); END;';

   Replication_Log_API.Create_Log__('REPLICATION', 'Load_Business_Object__', NULL, NULL, 0, NULL,
      'SNDMSG02: Resend ' || business_object_ || '(' || '' || ')', NULL,
      'SEND', 'INFORMATION',
      send_warning_, send_info_, receive_warning_, receive_info_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE method_ USING IN replication_group_, business_object_, date_string_, lu_, commit_interval_,
                                      send_warning_str_, send_info_str_, receive_warning_str_, receive_info_str_;
   @ApproveTransactionStatement(2013-11-19,haarse)
   COMMIT;
   return_ := 'Replication job for ' || business_object_;
   IF ( lu_ IS NOT NULL )   THEN  return_ := return_ || '->' || lu_;
   ELSE                           return_ := return_ || '(all LUs)';   END IF;
   IF ( date_ IS NOT NULL ) THEN  return_ := return_ || ', all rows changed since ' || date_string_;
   ELSE                           return_ := return_ || ', all rows'; END IF;
   return_ := return_ || ' submitted';
EXCEPTION
   WHEN group_missing_ THEN
      Error_SYS.Appl_General(lu_name_, 'GROUPMANDATORY: NULL is not allowed for Application Group.');
   WHEN object_missing_ THEN
      Error_SYS.Appl_General(lu_name_, 'OBJECTMANDATORY: NULL is not allowed for Business Object.');
   WHEN lu_missing_ THEN
      Error_SYS.Appl_General(lu_name_, 'LUNOTEXIST: Logical Unit :P1 not in :P2.', lu_, business_object_);
END Load_Business_Object__;


PROCEDURE Package_State__ (
   package_name_ IN VARCHAR2,
   action_       IN VARCHAR2 )
IS
   value_missing_    EXCEPTION;
   unknown_action_   EXCEPTION;
BEGIN
   IF ( (package_name_ IS NULL) OR (action_ IS NULL) ) THEN
      RAISE value_missing_;
   END IF;
   IF ( UPPER(action_) IN ('REMOVE','COMPILE') ) THEN
      Change_Object_State___(package_name_, 'PACKAGE', UPPER(action_));
   ELSE
      RAISE unknown_action_;
   END IF;
EXCEPTION
   WHEN value_missing_ THEN
      Error_SYS.Appl_General(lu_name_, 'MANDATORY: NULL not allowed');
   WHEN unknown_action_ THEN
      Error_SYS.Appl_General(lu_name_, 'UNKNOWNACTION: Unknown action :P1', action_);
END Package_State__;


PROCEDURE Receive_Configuration__ (
   message_id_ IN NUMBER )
IS
   attr_                   VARCHAR2(3000);
   sender_                 in_message_tab.sender%TYPE;
   sender_message_id_      in_message_tab.sender_message_id%TYPE;
   unknown_message_        EXCEPTION;
   sql_error_              VARCHAR2(512);
   send_warning_           BOOLEAN := FALSE;
   send_info_              BOOLEAN := FALSE;
   receive_warning_        BOOLEAN := FALSE;
   receive_info_           BOOLEAN := FALSE;
BEGIN
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_WARN'),'ON')  = 'ON' ) THEN
      send_warning_    := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_INFO'),'OFF') = 'ON' ) THEN
      send_info_       := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_WARN'),'ON')  = 'ON' ) THEN
      receive_warning_ := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_INFO'),'OFF') = 'ON' ) THEN
      receive_info_    := TRUE;
   END IF;
   attr_ := Connectivity_SYS.Get_Message(message_id_);
   sender_ := Client_SYS.Get_Item_Value('SENDER', attr_);
   sender_message_id_ := Client_SYS.Get_Item_Value('SENDER_MESSAGE_ID', attr_);
   IF ( sender_message_id_ = 'SITE' ) THEN
      Receive_Site___(message_id_, send_warning_, send_info_, receive_warning_, receive_info_);
   ELSIF ( sender_message_id_ = 'CONFIGURATION' ) THEN
      Receive_Config___(message_id_, sender_, send_warning_, send_info_, receive_warning_, receive_info_);
   ELSE
      RAISE unknown_message_;
   END IF;
   Connectivity_SYS.Accept_Message(message_id_);
   @ApproveTransactionStatement(2013-11-19,haarse)
   COMMIT;
EXCEPTION
   WHEN unknown_message_ THEN
      sql_error_ := Language_SYS.Translate_Constant( lu_name_, 'UNKNOWNCONFMESSAGE: Unknown configuration message: :P1', p1_ => sender_message_id_);
      @ApproveTransactionStatement(2013-11-19,haarse)
      ROLLBACK;
      Connectivity_SYS.Reject_Message(message_id_);
      Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'Configuration', NULL, NULL, message_id_,
         NULL, 'RCVCONF1: ' || sql_error_, NULL, 'RECEIVE', 'ERROR',
         send_warning_, send_info_, receive_warning_, receive_info_);
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      Error_SYS.Appl_General(lu_name_, 'RELICERROR: Error while replicating, :P1', sql_error_);
   WHEN OTHERS THEN
      sql_error_ := sqlerrm;
      @ApproveTransactionStatement(2013-11-19,haarse)
      ROLLBACK;
      Connectivity_SYS.Reject_Message(message_id_);
      Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'Configuration', NULL, NULL, message_id_,
         NULL, 'RCVCONF2: Other error', sql_error_, 'RECEIVE', 'ERROR',
         send_warning_, send_info_, receive_warning_, receive_info_);
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      Error_SYS.Appl_General(lu_name_, sql_error_);
      Error_SYS.Appl_General(lu_name_, 'RELICERROR: Error while replicating, :P1', sql_error_);
END Receive_Configuration__;


PROCEDURE Receive_Message__ (
   message_id_ IN NUMBER )
IS
   method_               VARCHAR2(2000);
   suffix_               VARCHAR2(10) := '_BOR_API';
   method_name_          VARCHAR2(30) := 'Receive_Message';
   attr_                 VARCHAR2(3000);
   attr_grp_rec_         VARCHAR2(32000);
   attribute_rec_        VARCHAR2(32000);
   value_                VARCHAR2(2000);
   name_                 VARCHAR2(30);
   ptr_                  NUMBER;
   timezone_difference_  NUMBER := 0;
   date_format_          VARCHAR2(50);
   send_warning_         BOOLEAN := FALSE;
   send_info_            BOOLEAN := FALSE;
   receive_warning_      BOOLEAN := FALSE;
   receive_info_         BOOLEAN := FALSE;
   send_warning_str_     VARCHAR2(5) := 'FALSE';
   send_info_str_        VARCHAR2(5) := 'FALSE';
   receive_warning_str_  VARCHAR2(5) := 'FALSE';
   receive_info_str_     VARCHAR2(5) := 'FALSE';
   sender_               in_message_tab.sender%TYPE;
   bo_                   in_message_tab.sender_message_id%TYPE;
   bo_key_               in_message_tab.application_message_id%TYPE;
   business_object_      replication_queue_tab.business_object%TYPE;
   operation_            replication_queue_tab.operation%TYPE;
   connectivity_lines_   Connectivity_SYS.in_message_lines;
   count_                NUMBER;
   cnt_                  NUMBER;
   sql_error_            VARCHAR2(512);
   message_error_        EXCEPTION;
BEGIN
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_WARN'),'ON')  = 'ON' ) THEN
      send_warning_    := TRUE;
      send_warning_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_INFO'),'OFF') = 'ON' ) THEN
      send_info_       := TRUE;
      send_info_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_WARN'),'ON')  = 'ON' ) THEN
      receive_warning_ := TRUE;
      receive_warning_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_INFO'),'OFF') = 'ON' ) THEN
      receive_info_    := TRUE;
      receive_info_str_ := 'TRUE';
   END IF;
   attr_ := Connectivity_SYS.Get_Message(message_id_);
   sender_ := Client_SYS.Get_Item_Value('SENDER', attr_);
   bo_key_ := Client_SYS.Get_Item_Value('APPLICATION_MESSAGE_ID', attr_);
   bo_ := Client_SYS.Get_Item_Value('SENDER_MESSAGE_ID', attr_);
   Connectivity_SYS.Get_Message_Lines(count_,connectivity_lines_,message_id_);

   FOR i_ IN 1..count_ LOOP
      cnt_ := i_;
      CASE connectivity_lines_(cnt_).name
         WHEN 'BUSINESS_OBJECT' THEN
            Connectivity_SYS.Add_Header_To_Attr(attr_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Char_To_Attr(attr_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Date_To_Attr(attr_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Number_To_Attr(attr_, connectivity_lines_(cnt_));
         WHEN 'ATTRIBUTE_GROUP' THEN
            Connectivity_SYS.Add_Header_To_Attr(attr_grp_rec_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Char_To_Attr(attr_grp_rec_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Date_To_Attr(attr_grp_rec_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Number_To_Attr(attr_grp_rec_, connectivity_lines_(cnt_));
         WHEN 'ATTRIBUTE' THEN
            Connectivity_SYS.Add_Header_To_Attr(attribute_rec_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Char_To_Attr(attribute_rec_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Date_To_Attr(attribute_rec_, connectivity_lines_(cnt_));
            Connectivity_SYS.Add_Number_To_Attr(attribute_rec_, connectivity_lines_(cnt_));
         ELSE
            RAISE message_error_; -- syntax error in message
      END CASE;
   END LOOP;
   WHILE ( Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) ) LOOP
      IF ( value_ = 'BUSINESS_OBJECT' ) THEN
         IF ( Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) ) THEN
            business_object_ := value_;
         END IF;
      ELSIF ( value_ = 'OPERATION' ) THEN
         IF ( Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) ) THEN
            operation_ := value_;
         END IF;
      ELSIF ( value_ = 'DATE_FORMAT' ) THEN
         IF ( Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) ) THEN
            date_format_ := value_;
         END IF;
      ELSIF ( value_ = 'TIMEZONE_DIFFERENCE' ) THEN
         IF ( Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_) ) THEN
            BEGIN
               timezone_difference_ := TO_NUMBER(value_);
            EXCEPTION
               WHEN OTHERS THEN
                  timezone_difference_ := 0;
            END;
         END IF;
      END IF;
   END LOOP;
   Assert_SYS.Assert_Is_Package_Method(business_object_ || suffix_ || '.' || method_name_);
   method_ := 'BEGIN ' || UPPER(business_object_) || suffix_ || '.' || method_name_ ||
   '(:message_id, :operation, :sender, :bo_, :bo_key_, ' ||
   ':timezone_difference, :date_format, :attr_grp_rec_, :attribute_rec_, ' ||
   ':send_warning_, :send_info_, :receive_warning_, :receive_info_); END;';
   Replication_Log_API.Create_Log__('REPLICATION', 'Receive_Message__', NULL, NULL, message_id_,
      NULL, 'RCVMSG01: Receive ' || bo_, NULL, 'RECEIVE', 'INFORMATION',
      send_warning_, send_info_, receive_warning_, receive_info_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE method_ USING IN message_id_, operation_, sender_, bo_, bo_key_, timezone_difference_, date_format_, attr_grp_rec_, attribute_rec_,
                                      send_warning_str_, send_info_str_, receive_warning_str_, receive_info_str_;
EXCEPTION
   WHEN message_error_ THEN
      sql_error_ := 'Syntax error in message - record rejected';
      @ApproveTransactionStatement(2013-11-19,haarse)
      ROLLBACK;
      Connectivity_SYS.Reject_Message(message_id_);
      Replication_Log_API.Create_Log__('REPLICATION', 'Receive_Message__', NULL, NULL, message_id_, cnt_,
         'RCV13: Other error', sql_error_, 'RECEIVE', 'ERROR',
         send_warning_, send_info_, receive_warning_, receive_info_);
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      Error_SYS.Appl_General(lu_name_, 'RELICERROR: Error while replicating, :P1', sql_error_);
   WHEN OTHERS THEN
      sql_error_ := sqlerrm;
      @ApproveTransactionStatement(2013-11-19,haarse)
      ROLLBACK;
      Connectivity_SYS.Reject_Message(message_id_);
      Replication_Log_API.Create_Log__('REPLICATION', 'Receive_Message__', NULL, NULL, message_id_, cnt_,
         'RCVMSG02: Other error', sql_error_, 'RECEIVE', 'ERROR',
         send_warning_, send_info_, receive_warning_, receive_info_);
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
      Error_SYS.Appl_General(lu_name_, 'RELICERROR: Error while replicating, :P1', sql_error_);
END Receive_Message__;


PROCEDURE Replicate__ (
   rowid_ IN VARCHAR2 )
IS
   send_warning_       BOOLEAN := FALSE;
   send_info_          BOOLEAN := FALSE;
   receive_warning_    BOOLEAN := FALSE;
   receive_info_       BOOLEAN := FALSE;
   send_warning_str_   VARCHAR2(5) := 'FALSE';
   send_info_str_      VARCHAR2(5) := 'FALSE';
   receive_warning_str_ VARCHAR2(5) := 'FALSE';
   receive_info_str_   VARCHAR2(5) := 'FALSE';
   business_object_    replication_queue_tab.business_object%TYPE;
   business_object_id_ replication_queue_tab.business_object_id%TYPE;
   method_             VARCHAR2(2000);
   suffix_             VARCHAR2(10) := '_BOS_API';
   method_name_        VARCHAR2(30) := 'Create_Message';
   sql_error_          VARCHAR2(512);
   CURSOR c1 IS
      SELECT business_object, business_object_id
      FROM   replication_queue_tab
      WHERE  ROWID = rowid_;
BEGIN
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_WARN'),'ON')  = 'ON' ) THEN
      send_warning_    := TRUE;
      send_warning_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_INFO'),'OFF') = 'ON' ) THEN
      send_info_       := TRUE;
      send_info_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_WARN'),'ON')  = 'ON' ) THEN
      receive_warning_ := TRUE;
      receive_warning_str_ := 'TRUE';
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_INFO'),'OFF') = 'ON' ) THEN
      receive_info_    := TRUE;
      receive_info_str_ := 'TRUE';
   END IF;
   OPEN c1;
   FETCH c1 INTO business_object_, business_object_id_;
   IF ( c1%FOUND ) THEN
      Assert_SYS.Assert_Is_Package_Method(business_object_ || suffix_ || '.' || method_name_);
      method_ := 'BEGIN ' || UPPER(business_object_) || suffix_ || '.' || method_name_ ||
      '(:business_object_id, ' ||
      ':send_warning_, :send_info_, :receive_warning_, :receive_info_); END;';
      Replication_Log_API.Create_Log__('REPLICATION', 'Replicate__', NULL, NULL, 0, NULL,
         'SNDMSG01: Replicate ' || business_object_ || '(' || '' || ')', NULL,
         'SEND', 'INFORMATION',
         send_warning_, send_info_, receive_warning_, receive_info_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      EXECUTE IMMEDIATE method_ USING IN business_object_id_, send_warning_str_, send_info_str_, receive_warning_str_, receive_info_str_;
      @ApproveTransactionStatement(2013-11-19,haarse)
      COMMIT;
   END IF;
   CLOSE c1;
EXCEPTION
   WHEN OTHERS THEN
      sql_error_ := sqlerrm;
      IF ( c1%ISOPEN ) THEN
         CLOSE c1;
      END IF;
      @ApproveTransactionStatement(2013-11-19,haarse)
      ROLLBACK;
      Replication_Log_API.Create_Log__('REPLICATION', 'Replicate__', NULL, NULL, 0, NULL,
         'SNDMSG03: Other error', sql_error_, 'SEND', 'ERROR',
         send_warning_, send_info_, receive_warning_, receive_info_);
      Error_SYS.Appl_General(lu_name_, 'RELICERROR: Error while replicating, :P1', sql_error_);
END Replicate__;


PROCEDURE Send_Configuration__ (
   receiver_        IN VARCHAR2,
   receive_group_   IN VARCHAR2,
   business_object_ IN VARCHAR2,
   message_         OUT VARCHAR2 )
IS
   message_text_    VARCHAR2(2000) := 'Message sent - MessageId=';
   comma_           VARCHAR2(2);
   message_count_   NUMBER := 0;
   message_id_      out_message_tab.message_id%TYPE;
   message_line_    out_message_line_tab.message_line%TYPE;
   attr_            VARCHAR2(32000);
   new_message_     BOOLEAN;
   on_new_          VARCHAR2(5);
   on_modify_       VARCHAR2(5);
   site_id_         installation_site_tab.site_id%TYPE;
   send_warning_    BOOLEAN := FALSE;
   send_info_       BOOLEAN := FALSE;
   receive_warning_ BOOLEAN := FALSE;
   receive_info_    BOOLEAN := FALSE;
   CURSOR this_site IS
      SELECT a.site_id
      FROM   installation_site a
      WHERE  a.this_site = 'TRUE';
   CURSOR rcv (receiver_ replication_receiver_tab.receiver%TYPE,
      group_    replication_receiver_tab.replication_group%TYPE) IS
         SELECT a.receiver          AS receiver,
                a.replication_group AS replication_group
         FROM   replication_receiver_tab a
         WHERE  a.replication_group LIKE NVL(group_, '%')
         AND    a.receiver          LIKE NVL(receiver_, '%');
   CURSOR bo (object_   replication_object_tab.business_object%TYPE,
      group_    replication_object_tab.replication_group%TYPE) IS
         SELECT a.business_object AS business_object
         FROM   replication_object_tab a
         WHERE  a.replication_group LIKE NVL(group_, '%')
         AND    a.business_object   LIKE NVL(object_, '%');
   CURSOR bo_data (object_ replication_object_def_tab.business_object%TYPE) IS
      SELECT a.*
      FROM   replication_object_def_tab a
      WHERE  a.business_object = object_;
   CURSOR ag_data (object_ replication_attr_group_def_tab.business_object%TYPE) IS
      SELECT a.*
      FROM   replication_attr_group_def_tab a
      WHERE  a.business_object = object_;
   CURSOR at_data (object_ replication_attr_def_tab.business_object%TYPE,
      lu_     replication_attr_def_tab.lu_name%TYPE) IS
         SELECT a.*
         FROM   replication_attr_def_tab a
         WHERE  a.business_object = object_
         AND    a.lu_name         = lu_;
   CURSOR c1_new_modify (group_    replication_object_tab.replication_group%TYPE,
      object_   replication_object_tab.business_object%TYPE) IS
         SELECT a.on_new    AS on_new_,
                a.on_modify AS on_modify
         FROM   replication_object_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_;
   CURSOR c2_new_modify (group_    replication_attr_group_tab.replication_group%TYPE,
      object_   replication_attr_group_tab.business_object%TYPE,
      lu_       replication_attr_group_tab.lu_name%TYPE) IS
         SELECT a.on_new    AS on_new_,
                a.on_modify AS on_modify
         FROM   replication_attr_group_tab a
         WHERE  a.replication_group = group_
         AND    a.business_object   = object_
         AND    a.lu_name           = lu_;
BEGIN
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_WARN'),'ON')  = 'ON' ) THEN
      send_warning_    := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_INFO'),'OFF') = 'ON' ) THEN
      send_info_       := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_WARN'),'ON')  = 'ON' ) THEN
      receive_warning_ := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_INFO'),'OFF') = 'ON' ) THEN
      receive_info_    := TRUE;
   END IF;
   OPEN this_site;
   FETCH this_site INTO site_id_;
   CLOSE this_site;
   FOR rcv_ IN rcv(receiver_, receive_group_) LOOP
      new_message_ := TRUE;
      message_id_ := 0;
      FOR bo_ IN bo(business_object_, rcv_.replication_group) LOOP
         IF ( new_message_ ) THEN
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('CLASS_ID', 'IFS_REPLICATION_CONFIGURATION', attr_);
            Client_SYS.Add_To_Attr('RECEIVER', rcv_.receiver, attr_);
            Client_SYS.Add_To_Attr('MEDIA_CODE', 'REPLICATION', attr_);
            Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', 'CONFIGURATION', attr_);
            IF ( site_id_ IS NOT NULL ) THEN
               Client_SYS.Add_To_Attr('SENDER', site_id_, attr_);
            END IF;
            Connectivity_SYS.Create_Message(message_id_, attr_);
            message_line_ := 0;
            new_message_ := FALSE;
         END IF;
         FOR bo_data_ IN bo_data(bo_.business_object) LOOP
            message_line_ := message_line_ + 1;
            Client_SYS.Clear_Attr(attr_);
            Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
            Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
            Client_SYS.Add_To_Attr('NAME', 'BUSINESS_OBJECT', attr_);
            Client_SYS.Add_To_Attr('C00', 'BUSINESS_OBJECT', attr_);
            Client_SYS.Add_To_Attr('C01', bo_data_.business_object, attr_);
            Client_SYS.Add_To_Attr('C02', 'MASTER_LU', attr_);
            Client_SYS.Add_To_Attr('C03', bo_data_.master_lu, attr_);
            Client_SYS.Add_To_Attr('C04', 'DESCRIPTION', attr_);
            Client_SYS.Add_To_Attr('C05', bo_data_.description, attr_);
            Client_SYS.Add_To_Attr('C06', 'MASTER_COMPONENT', attr_);
            Client_SYS.Add_To_Attr('C07', bo_data_.master_component, attr_);
            OPEN c1_new_modify(rcv_.replication_group, bo_data_.business_object);
            FETCH c1_new_modify INTO on_new_, on_modify_;
            IF ( c1_new_modify%NOTFOUND) THEN
               on_new_ := 'FALSE';
               on_modify_ := 'FALSE';
            END IF;
            CLOSE c1_new_modify;
            Client_SYS.Add_To_Attr('C08', 'ON_NEW', attr_);
            Client_SYS.Add_To_Attr('C09', on_new_, attr_);
            Client_SYS.Add_To_Attr('C10', 'ON_MODIFY', attr_);
            Client_SYS.Add_To_Attr('C11', on_modify_, attr_);
            Connectivity_SYS.Create_Message_Line(attr_);
            FOR ag_data_ IN ag_data(bo_.business_object) LOOP
               message_line_ := message_line_ + 1;
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
               Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
               Client_SYS.Add_To_Attr('NAME', 'ATTRIBUTE_GROUP', attr_);
               Client_SYS.Add_To_Attr('C00', 'BUSINESS_OBJECT', attr_);
               Client_SYS.Add_To_Attr('C01', ag_data_.business_object, attr_);
               Client_SYS.Add_To_Attr('C02', 'LU_NAME', attr_);
               Client_SYS.Add_To_Attr('C03', ag_data_.lu_name, attr_);
               Client_SYS.Add_To_Attr('C04', 'DESCRIPTION', attr_);
               Client_SYS.Add_To_Attr('C05', ag_data_.description, attr_);
               Client_SYS.Add_To_Attr('C06', 'MASTER_COMPONENT', attr_);
               Client_SYS.Add_To_Attr('C07', ag_data_.master_component, attr_);
               Client_SYS.Add_To_Attr('C08', 'CONTEXT_DB', attr_);
               Client_SYS.Add_To_Attr('C09', ag_data_.context, attr_);
               Client_SYS.Add_To_Attr('C10', 'CONTEXT_KEY', attr_);
               Client_SYS.Add_To_Attr('C11', ag_data_.context_key, attr_);
               OPEN c2_new_modify(rcv_.replication_group, ag_data_.business_object, ag_data_.lu_name);
               FETCH c2_new_modify INTO on_new_, on_modify_;
               IF ( c2_new_modify%NOTFOUND) THEN
                  on_new_ := 'FALSE';
                  on_modify_ := 'FALSE';
               END IF;
               CLOSE c2_new_modify;
               Client_SYS.Add_To_Attr('C12', 'ON_NEW', attr_);
               Client_SYS.Add_To_Attr('C13', on_new_, attr_);
               Client_SYS.Add_To_Attr('C14', 'ON_MODIFY', attr_);
               Client_SYS.Add_To_Attr('C15', on_modify_, attr_);
               Client_SYS.Add_To_Attr('C16', 'TRIGGER_TABLE', attr_);
               Client_SYS.Add_To_Attr('C17', ag_data_.trigger_table, attr_);
               Connectivity_SYS.Create_Message_Line(attr_);
               FOR at_data_ IN at_data(bo_.business_object, ag_data_.lu_name) LOOP
                  message_line_ := message_line_ + 1;
                  Client_SYS.Clear_Attr(attr_);
                  Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
                  Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
                  Client_SYS.Add_To_Attr('NAME', 'ATTRIBUTE', attr_);
                  Client_SYS.Add_To_Attr('C00', 'BUSINESS_OBJECT', attr_);
                  Client_SYS.Add_To_Attr('C01', at_data_.business_object, attr_);
                  Client_SYS.Add_To_Attr('C02', 'LU_NAME', attr_);
                  Client_SYS.Add_To_Attr('C03', at_data_.lu_name, attr_);
                  Client_SYS.Add_To_Attr('C04', 'COLUMN_NAME', attr_);
                  Client_SYS.Add_To_Attr('C05', at_data_.column_name, attr_);
                  Client_SYS.Add_To_Attr('C06', 'TABLE_NAME', attr_);
                  Client_SYS.Add_To_Attr('C07', at_data_.table_name, attr_);
                  Client_SYS.Add_To_Attr('C08', 'KEY', attr_);
                  Client_SYS.Add_To_Attr('C09', at_data_.key, attr_);
                  Client_SYS.Add_To_Attr('C10', 'DESCRIPTION', attr_);
                  Client_SYS.Add_To_Attr('C11', at_data_.description, attr_);
                  Client_SYS.Add_To_Attr('C12', 'BO_KEY_NAME', attr_);
                  Client_SYS.Add_To_Attr('C13', at_data_.bo_key_name, attr_);
                  Client_SYS.Add_To_Attr('C14', 'ON_NEW', attr_);
                  Client_SYS.Add_To_Attr('C15', at_data_.on_new, attr_);
                  Client_SYS.Add_To_Attr('C16', 'ON_MODIFY', attr_);
                  Client_SYS.Add_To_Attr('C17', at_data_.on_modify, attr_);
                  Client_SYS.Add_To_Attr('C18', 'SEQUENCE_NO', attr_);
                  Client_SYS.Add_To_Attr('C19', at_data_.sequence_no, attr_);
                  Connectivity_SYS.Create_Message_Line(attr_);
               END LOOP;
            END LOOP;
         END LOOP;
      END LOOP;
      IF ( message_id_ > 0 ) THEN
         Connectivity_SYS.Release_Message(message_id_);
         message_text_ := message_text_ || comma_ || TO_CHAR(message_id_);
         message_count_ := message_count_ + 1;
         comma_ := ', ';
         Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'Configuration Information', NULL, NULL,
            message_id_, NULL, 'SNDCONF01: Sending configuration information to: ' || rcv_.receiver, NULL,
            'SEND', 'INFORMATION',
            send_warning_, send_info_, receive_warning_, receive_info_);
      END IF;
   END LOOP;
   IF ( message_count_ = 0 ) THEN
      message_ := 'No data found';
   ELSE
      message_ := message_text_;
   END IF;
END Send_Configuration__;


PROCEDURE Send_Site__ (
   receiver_      IN VARCHAR2,
   receive_group_ IN VARCHAR2,
   message_       OUT VARCHAR2 )
IS
   message_text_    VARCHAR2(2000) := 'Message sent - MessageId=';
   comma_           VARCHAR2(2);
   message_count_   NUMBER := 0;
   message_id_      out_message_tab.message_id%TYPE;
   message_line_    out_message_line_tab.message_line%TYPE;
   site_id_         installation_site_tab.site_id%TYPE;
   sender_          replication_receiver_tab.receiver%TYPE;
   attr_            VARCHAR2(32000);
   sql_error_       VARCHAR2(512);
   send_warning_    BOOLEAN := FALSE;
   send_info_       BOOLEAN := FALSE;
   receive_warning_ BOOLEAN := FALSE;
   receive_info_    BOOLEAN := FALSE;
   CURSOR rcv (receiver_ replication_receiver_tab.receiver%TYPE,
      group_    receive_group_tab.receive_group%TYPE) IS
         SELECT a.receiver  AS receiver
         FROM   replication_receiver_tab a
         WHERE  a.replication_group LIKE NVL(group_, '%')
         AND    a.receiver          LIKE NVL(receiver_, '%');
   CURSOR repl_rcv (receiver_ replication_receiver_tab.receiver%TYPE) IS
      SELECT a.*
      FROM   replication_receiver_tab a
      WHERE  receiver = receiver_;
   CURSOR site IS
      SELECT *
      FROM   installation_site;
   CURSOR this_site IS
      SELECT a.site_id, b.receiver
      FROM   installation_site a,
             replication_receiver b
      WHERE  a.this_site = 'TRUE'
      AND    a.site_id   = b.site_id;
BEGIN
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_WARN'),'ON')  = 'ON' ) THEN
      send_warning_    := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_SND_INFO'),'OFF') = 'ON' ) THEN
      send_info_       := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_WARN'),'ON')  = 'ON' ) THEN
      receive_warning_ := TRUE;
   END IF;
   IF ( NVL(Fnd_Setting_API.Get_Value('REPL_RCV_INFO'),'OFF') = 'ON' ) THEN
      receive_info_    := TRUE;
   END IF;
   OPEN this_site;
   FETCH this_site INTO site_id_, sender_;
   CLOSE this_site;
   FOR rcv_ IN rcv (receiver_, receive_group_) LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CLASS_ID', 'IFS_REPLICATION_CONFIGURATION', attr_);
      Client_SYS.Add_To_Attr('RECEIVER', rcv_.receiver, attr_);
      Client_SYS.Add_To_Attr('MEDIA_CODE', 'REPLICATION', attr_);
      Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', 'SITE', attr_);
      IF ( site_id_ IS NOT NULL ) THEN
         Client_SYS.Add_To_Attr('SENDER', site_id_, attr_);
      END IF;
      Connectivity_SYS.Create_Message(message_id_, attr_);
      message_line_ := 0;
      FOR site_ IN site LOOP
         message_line_ := message_line_ + 1;
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
         Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
         Client_SYS.Add_To_Attr('NAME', 'INSTALLATION_SITE', attr_);
         Client_SYS.Add_To_Attr('C00', 'SITE_ID', attr_);
         Client_SYS.Add_To_Attr('C01', site_.site_id, attr_);
         Client_SYS.Add_To_Attr('C02', 'TIMEZONE_DIFFERENCE', attr_);
         Client_SYS.Add_To_Attr('C03', site_.timezone_difference, attr_);
         Client_SYS.Add_To_Attr('C04', 'DESCRIPTION', attr_);
         Client_SYS.Add_To_Attr('C05', site_.description, attr_);
         Connectivity_SYS.Create_Message_Line(attr_);
      END LOOP;
      FOR repl_rcv_ IN repl_rcv (rcv_.receiver) LOOP
         message_line_ := message_line_ + 1;
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
         Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
         Client_SYS.Add_To_Attr('NAME', 'REPLICATION_RECEIVER', attr_);
         Client_SYS.Add_To_Attr('C00', 'RECEIVER', attr_);
         Client_SYS.Add_To_Attr('C01', sender_, attr_);
         Client_SYS.Add_To_Attr('C02', 'SITE_ID', attr_);
         Client_SYS.Add_To_Attr('C03', site_id_, attr_);
         Client_SYS.Add_To_Attr('C04', 'DESCRIPTION', attr_);
         Client_SYS.Add_To_Attr('C05', repl_rcv_.description, attr_);
         Client_SYS.Add_To_Attr('C06', 'REPLICATION_GROUP', attr_);
         Client_SYS.Add_To_Attr('C07', repl_rcv_.replication_group, attr_);
         Connectivity_SYS.Create_Message_Line(attr_);
      END LOOP;
      Connectivity_SYS.Release_Message(message_id_);
      message_text_ := message_text_ || comma_ || TO_CHAR(message_id_);
      comma_ := ', ';
      message_count_ := message_count_ + 1;
      Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'Site Information', NULL, NULL,
         message_id_, NULL, 'SNDSITE01: Sending site information to: ' || rcv_.receiver, NULL,
         'SEND', 'INFORMATION', send_warning_, send_info_, receive_warning_, receive_info_);
   END LOOP;
   IF ( message_count_ = 0 ) THEN
      message_ := 'No data found';
   ELSE
      message_ := message_text_;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      sql_error_ := sqlerrm;
      Replication_Log_API.Create_Log__('REPLICATION CONFIGURATION', 'Site Information', NULL, NULL,
         message_id_, NULL, 'SNDSITE02: Sending site information to: ' || receiver_ || ', ' || receive_group_,
         sql_error_, 'SEND', 'ERROR', send_warning_, send_info_, receive_warning_, receive_info_);
      Error_SYS.Appl_General(lu_name_, 'RELICERROR: Error while replicating, :P1', sql_error_);
END Send_Site__;


PROCEDURE Trigger_State__ (
   trigger_name_ IN VARCHAR2,
   action_       IN VARCHAR2 )
IS
   value_missing_    EXCEPTION;
   unknown_action_   EXCEPTION;
BEGIN
   IF ( (trigger_name_ IS NULL) OR (action_ IS NULL) ) THEN
      RAISE value_missing_;
   END IF;
   IF ( UPPER(action_) IN ('ENABLE','DISABLE','REMOVE','COMPILE') ) THEN
      Change_Object_State___(trigger_name_, 'TRIGGER', UPPER(action_));
   ELSE
      RAISE unknown_action_;
   END IF;
EXCEPTION
   WHEN value_missing_ THEN
      Error_SYS.Appl_General(lu_name_, 'MANDATORY: NULL not allowed');
   WHEN unknown_action_ THEN
      Error_SYS.Appl_General(lu_name_, 'UNKNOWNACTION: Unknown action :P1', action_);
END Trigger_State__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


