
--
-- NOTE  
-- This will move obsolete personal messages into tasks.
-- Note that event actions rules for personal messages are not migrated, only already processed messages are.
--

SET VERIFY OFF;
SET SERVEROUT ON;
 
PROMPT 
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP9_MovePersonalMessages.sql','Timestamp_1');
PROMPT This will move obsolete personal messages into tasks.
PROMPT Note that event actions rules for personal messages are not migrated, only already processed messages are.
PROMPT 

ACCEPT CONTINUE DEFAULT 'N' PROMPT 'Do you want to continue Y/N [N]?'
PROMPT 

DECLARE
   temp_ NUMBER;
   CURSOR check_tab IS
      SELECT 1
      FROM user_tables
      WHERE table_name = 'FND_EVENT_MY_MESSAGES_OLD'
      AND EXISTS
      (SELECT 1
       FROM user_tables
       WHERE table_name = 'PERSON_INFO_TAB');
BEGIN
IF ('&continue' = 'Y' OR '&continue' = 'y') THEN
   OPEN check_tab;
   FETCH check_tab INTO temp_;
   IF check_tab%FOUND THEN
      CLOSE check_tab;
      EXECUTE IMMEDIATE 'DECLARE
                           item_id_   todo_item_tab.item_id%TYPE;
                           folder_id_ my_todo_item_tab.folder_id%TYPE;
                           dummy_     NUMBER;
                           count_     NUMBER := 0;
                           CURSOR get_rec IS
                              SELECT rowid, create_date, identity, message,
                                     DECODE(READ, ''FALSE'', 0, 1) completed,
                                     DECODE(READ, ''FALSE'', NULL, SYSDATE) completed_date,
                                     DECODE(READ, ''FALSE'', NULL, IDENTITY) completed_by
                              FROM FND_EVENT_MY_MESSAGES_OLD;
                           CURSOR check_person (person_id_ VARCHAR2) IS
                              SELECT 1
                              FROM person_info_tab
                              WHERE person_id = person_id_;
                           FUNCTION Post_To_Folder___ (
                              user_ IN VARCHAR2 ) RETURN VARCHAR2 
                           IS
                              folder_id_ VARCHAR2(100); 
                              item_counter_ NUMBER;
                              unread_item_counter_ NUMBER;
                              CURSOR folder_exist(user_id_ IN VARCHAR2) IS
                                 SELECT folder_id, item_counter, unread_item_counter
                                 FROM todo_folder_tab
                                 WHERE identity = user_id_
                                 AND main_folder = 1
                                 AND folder_type = ToDo_Folder_Type_API.DB_TODO;
                           BEGIN
                              OPEN folder_exist (user_);
                              FETCH folder_exist INTO folder_id_, item_counter_, unread_item_counter_;
                              IF (folder_exist%NOTFOUND) THEN
                                 folder_id_ := Sys_Guid;
                                 INSERT INTO todo_folder_tab
                                 (folder_id, identity, main_folder, folder_index, item_counter, unread_item_counter, folder_type, name,rowversion)
                                 VALUES
                                 (folder_id_, user_, 1, 0, 0, 0, ToDo_Folder_Type_API.DB_TODO, ToDo_Folder_Type_API.Decode(ToDo_Folder_Type_API.DB_TODO),1);
                              ELSE
                                 UPDATE TODO_FOLDER_TAB
                                 SET item_counter = item_counter_ + 1,
                                     unread_item_counter = unread_item_counter_ + 1,
				     rowversion = rowversion + 1
                                 WHERE folder_id = folder_id_
                                 AND identity = user_
                                 AND main_folder = 1
                                 AND folder_type = ToDo_Folder_Type_API.DB_TODO;
                              END IF;
                              CLOSE folder_exist;
                              RETURN folder_id_;
                           END Post_To_Folder___;
                        BEGIN
                           FOR rec_ IN get_rec LOOP 
                              OPEN check_person (rec_.identity);
                              FETCH check_person INTO dummy_;
                              IF check_person%FOUND THEN
                                 count_ := count_ + 1;
                                 item_id_ := sys_guid;
                                 INSERT INTO todo_item_tab
                                 (rowversion, item_id, item_type, SHARED, created_date, created_by, item_message, completed, completed_date, completed_by)
                                 VALUES
                                 (1, item_id_, ''WORKFLOW'', 0, rec_.create_date, rec_.identity, rec_.message, rec_.completed, rec_.completed_date, rec_.completed_by);
                                 folder_id_ := Post_To_Folder___(rec_.identity);
                                 INSERT INTO my_todo_item_tab
                                 (rowversion, item_id, identity, created_date, created_by, read, sent_by, folder_id, new_item, time_stamp, date_received)
                                 VALUES
                                 (1, item_id_, rec_.identity, rec_.create_date, rec_.identity, rec_.completed, rec_.identity, folder_id_, 1, sysdate, rec_.create_date);
                              END IF;
                              CLOSE check_person;
                              DELETE FROM FND_EVENT_MY_MESSAGES_OLD
                              WHERE ROWID = rec_.rowid;
                           END LOOP;
                           IF (count_ > 0) THEN
                              dbms_output.put_line(''All '' || TO_CHAR(count_) || '' personal messages have been converted into tasks'');
                           ELSE
                              dbms_output.put_line(''No personal messages found'');
                           END IF;
                        END;';
   ELSE
      CLOSE check_tab;
      dbms_output.put_line('Database table with old messages is missing');
   END IF;
ELSE
   dbms_output.put_line('Operation Aborted');
END IF;
END;
/
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP9_MovePersonalMessages.sql','Done');


