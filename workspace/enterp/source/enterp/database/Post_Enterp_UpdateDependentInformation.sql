-----------------------------------------------------------------------------
--  Module : ENTERP
--
--  File   : Post_Enterp_UpdateDependentInformation.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  -----------------------------------------------------
--  200918   machlk  HCSPRING20-1613, Implement GDPR after removing BENADM.
--  201201   Dakplk  FISPRING20-8345, Renamed obsolete tables to 21R1.
--  ------   ------  ---------------------------------------------------------------------------------
--------------------------------------------------------------------------


exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateDependentInformation.sql','Timestamp_1');
PROMPT Post_Enterp_UpdateDependentInformation.sql

SET SERVEROUTPUT ON SIZE UNLIMITED

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateDependentInformation.sql','Timestamp_2');
PROMPT Creating backup tables ...
DECLARE
   value_   VARCHAR2(20) := '''%DEPENDENT_ID%''';

   PROCEDURE Create_Backup_Table___ (
     back_tbl_name_ IN VARCHAR2,
     table_name_    IN VARCHAR2 )
   IS
      stmt_   VARCHAR2(2000);
   BEGIN

      IF NOT (Database_SYS.Table_Exist(back_tbl_name_)) THEN
        stmt_ := 'CREATE TABLE '|| back_tbl_name_ ||' AS '||
                     'SELECT t.*,
                            substr(t.key_ref, instr(t.key_ref,''='',1,1)+1, instr(t.key_ref,''^'',1,1)-(instr(t.key_ref,''='',1,1)+1)) person_id,
                            substr(t.key_ref, instr(t.key_ref,''='',1,2)+1, instr(t.key_ref,''^'',1,2)-(instr(t.key_ref,''='',1,2)+1)) dependent_id
                     FROM '|| table_name_||' t '||
                     'WHERE key_ref LIKE ' || value_;

        EXECUTE IMMEDIATE stmt_;
      END IF;

   END Create_Backup_Table___;


   PROCEDURE Add_Cols_To_Tables___ (
     table_name_  IN VARCHAR2 )
   IS
     columns_    Database_SYS.ColumnTabType;
   BEGIN
     IF NOT (Database_SYS.Column_Exist(table_name_, 'NEW_KEY_REF')) THEN
       Database_SYS.Set_Table_Column(columns_, 'NEW_KEY_REF', 'VARCHAR2(100)', 'Y');
       Database_SYS.Alter_Table(table_name_, columns_, TRUE);
     END IF;
   END Add_Cols_To_Tables___;


   PROCEDURE Create_Backup_Tables___
   IS
   BEGIN
     Create_Backup_Table___('data_subject_consent_2110','data_subject_consent_tab');
     Create_Backup_Table___('data_subject_consent_oper_2110','data_subject_consent_oper_tab');
     Create_Backup_Table___('data_subject_consent_purp_2110','data_subject_consent_purp_tab');
     Create_Backup_Table___('personal_data_cleanup_log_2110','personal_data_cleanup_log_tab');

     Add_Cols_To_Tables___('data_subject_consent_2110');
     Add_Cols_To_Tables___('data_subject_consent_oper_2110');
     Add_Cols_To_Tables___('data_subject_consent_purp_2110');
     Add_Cols_To_Tables___('personal_data_cleanup_log_2110');
   END Create_Backup_Tables___;

BEGIN
  $IF Component_Person_SYS.INSTALLED $THEN
     Create_Backup_Tables___;
  $ELSE
     NULL;
  $END
END;
/


exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateDependentInformation.sql','Timestamp_3');
PROMPT Inserting new data and Removing  obsolete data ...
DECLARE
   -- falgs to check back up data in each category exists
   cons_backup_data_exists_       BOOLEAN := FALSE;
   cons_oper_backup_data_exists_  BOOLEAN := FALSE;
   cons_purp_backup_data_exists_  BOOLEAN := FALSE;
   per_clnup_backup_data_exists_  BOOLEAN := FALSE;

   -- falgs for each operation
   cons_new_keyref_success_       BOOLEAN := FALSE;
   cons_oper_new_keyref_success_  BOOLEAN := FALSE;
   cons_purp_keyref_success_      BOOLEAN := FALSE;
   per_clnup_new_keyref_success_  BOOLEAN := FALSE;

   cons_insert_success_           BOOLEAN := FALSE;
   cons_oper_insert_success_      BOOLEAN := FALSE;
   cons_purp_insert_success_      BOOLEAN := FALSE;
   per_cleanup_insert_success_    BOOLEAN := FALSE;

   -- combined flag for backup data
   backup_data_exists_            BOOLEAN := FALSE;

   -- variable holds error message in each operation
   err_msg_                       VARCHAR2(200);

   -- Check whether there are rows in a back up tables and return TRUE or FALSE
   FUNCTION Get_Data_Exists_Flag___(
      table_name_  IN VARCHAR2 ) RETURN BOOLEAN
   IS
      temp_  NUMBER;
      stmt_  VARCHAR2(2000);
   BEGIN
     stmt_ := 'SELECT  1  FROM '|| table_name_ ||' WHERE  ROWNUM = 1';
     BEGIN
          EXECUTE IMMEDIATE stmt_ INTO temp_;
          RETURN TRUE;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
     END;
   END Get_Data_Exists_Flag___;


   PROCEDURE Set_Backup_data_Flags___
   IS
      temp_  NUMBER;
   BEGIN

     cons_backup_data_exists_      := Get_Data_Exists_Flag___('data_subject_consent_2110');
     cons_oper_backup_data_exists_ := Get_Data_Exists_Flag___('data_subject_consent_oper_2110');
     cons_purp_backup_data_exists_ := Get_Data_Exists_Flag___('data_subject_consent_purp_2110');
     per_clnup_backup_data_exists_ := Get_Data_Exists_Flag___('personal_data_cleanup_log_2110');

   END Set_Backup_data_Flags___;


   PROCEDURE Set_New_Keyref___

   IS
   BEGIN

     $IF Component_Person_SYS.INSTALLED $THEN
        dbms_output.put_line('Setting new keyref values in data_subject_consent_2110 ...');
        IF (cons_backup_data_exists_) THEN
          BEGIN
            UPDATE data_subject_consent_2110 dsc
                SET dsc.new_key_ref = (SELECT 'PERSON_ID='||dsc.person_id||'^RELATION_ID='||to_char(rpt.relation_id)||'^'
                                         FROM related_person_tab rpt
                                         WHERE rpt.person_id    = dsc.person_id
                                         AND   rpt.dependent_id = dsc.dependent_id)
             WHERE dsc.new_key_ref IS NULL;
             COMMIT;
             cons_new_keyref_success_ := TRUE;
          EXCEPTION
            WHEN OTHERS THEN
                 err_msg_ := SUBSTR(SQLERRM, 1, 200);
                 dbms_output.put_line('New key ref update in data_subject_consent_2110, failed with error '||err_msg_);
          END;
        ELSE
          dbms_output.put_line('   No backup Data and therefore skipping this step...');
        END IF;


        dbms_output.put_line('Setting new keyref values in data_subject_consent_oper_2110 ...');
        IF (cons_oper_backup_data_exists_) THEN
          BEGIN
             UPDATE data_subject_consent_oper_2110 dsc
                SET dsc.new_key_ref = (SELECT 'PERSON_ID='||dsc.person_id||'^RELATION_ID='||to_char(rpt.relation_id)||'^'
                                         FROM related_person_tab rpt
                                         WHERE rpt.person_id    = dsc.person_id
                                         AND   rpt.dependent_id = dsc.dependent_id)
             WHERE dsc.new_key_ref IS NULL;
             COMMIT;
             cons_oper_new_keyref_success_ := TRUE;
          EXCEPTION
             WHEN OTHERS THEN
                 err_msg_ := SUBSTR(SQLERRM, 1, 200);
                 dbms_output.put_line('New key ref update in data_subject_consent_oper_2110, failed with error '||err_msg_);
          END;
        ELSE
          dbms_output.put_line('   No backup Data and therefore skipping this step...');
        END IF;


        dbms_output.put_line('Setting new keyref values in data_subject_consent_purp_2110 ...');
        IF (cons_purp_backup_data_exists_) THEN
          BEGIN
            UPDATE data_subject_consent_purp_2110 dsc
                SET dsc.new_key_ref = (SELECT 'PERSON_ID='||dsc.person_id||'^RELATION_ID='||to_char(rpt.relation_id)||'^'
                                         FROM related_person_tab rpt
                                         WHERE rpt.person_id    = dsc.person_id
                                         AND   rpt.dependent_id = dsc.dependent_id)
            WHERE dsc.new_key_ref IS NULL;
            COMMIT;
            cons_purp_keyref_success_ := TRUE;
          EXCEPTION
            WHEN OTHERS THEN
                 err_msg_ := SUBSTR(SQLERRM, 1, 200);
                 dbms_output.put_line('New key ref update in data_subject_consent_purp_2110, failed with error '||err_msg_);
          END;
        ELSE
          dbms_output.put_line('   No backup Data and therefore skipping this step...');
        END IF;


        dbms_output.put_line('Setting new keyref values in personal_data_cleanup_log_2110 ...');
        IF (per_clnup_backup_data_exists_) THEN
          BEGIN
            UPDATE personal_data_cleanup_log_2110 dsc
                SET dsc.new_key_ref = (SELECT 'PERSON_ID='||dsc.person_id||'^RELATION_ID='||to_char(rpt.relation_id)||'^'
                                         FROM related_person_tab rpt
                                         WHERE rpt.person_id    = dsc.person_id
                                         AND   rpt.dependent_id = dsc.dependent_id)
            WHERE dsc.new_key_ref IS NULL;
            COMMIT;
            per_clnup_new_keyref_success_ := TRUE;
          EXCEPTION
            WHEN OTHERS THEN
                 err_msg_ := SUBSTR(SQLERRM, 1, 200);
                 dbms_output.put_line('New key ref update in personal_data_cleanup_log_2110, failed with error '||err_msg_);
          END;
        ELSE
          dbms_output.put_line('   No backup Data and therefore skipping this step...');
        END IF;
     $ELSE
         NULL;
     $END

   END Set_New_Keyref___;


   PROCEDURE Insert_New_Data___
   IS
   BEGIN

     $IF Component_Person_SYS.INSTALLED $THEN
         dbms_output.put_line('Inserting new keyref Data to data_subject_consent_tab ...');
         IF (cons_new_keyref_success_ AND cons_backup_data_exists_) THEN
           BEGIN
             INSERT INTO data_subject_consent_tab
               (key_ref,
                data_subject,
                rowversion,
                rowkey)
             SELECT
                new_key_ref,
                data_subject,
                rowversion,
                sys_guid()
             FROM data_subject_consent_2110 t
             WHERE t.new_key_ref IS NOT NULL
             AND NOT EXISTS (SELECT 1
                             FROM  data_subject_consent_tab d
                             WHERE d.key_ref = t.new_key_ref);
             COMMIT;
             cons_insert_success_ := TRUE;
           EXCEPTION
             WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('New key ref insert to data_subject_consent_tab, failed with error '||err_msg_);
           END;
         ELSE
            dbms_output.put_line('   New key ref insert to data_subject_consent_tab was not performed ');
            dbms_output.put_line('      This could be due to an exception in previous steps or due to no data found to insert  ');
         END IF;


         dbms_output.put_line('Inserting new keyref Data to data_subject_consent_oper_tab ...');
         IF (cons_oper_new_keyref_success_ AND cons_oper_backup_data_exists_) THEN
           BEGIN
             INSERT INTO data_subject_consent_oper_tab
               (key_ref,
                operation_date,
                update_date,
                action,
                remark,
                performed_by,
                rowversion,
                rowkey)
             SELECT
                new_key_ref,
                operation_date,
                update_date,
                action,
                remark,
                performed_by,
                rowversion,
                sys_guid()
             FROM data_subject_consent_oper_2110 t
             WHERE t.new_key_ref IS NOT NULL
             AND NOT EXISTS (SELECT 1
                             FROM  data_subject_consent_oper_tab d
                             WHERE d.key_ref        = t.new_key_ref
                             AND   d.operation_date = t.operation_date
                             AND   d.action         = t.action);
            COMMIT;
            cons_oper_insert_success_  := TRUE;

          EXCEPTION
            WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('New key ref insert to data_subject_consent_oper_tab, failed with error '||err_msg_);
          END;
        ELSE
            dbms_output.put_line('   New key ref insert to data_subject_consent_oper_tab was not performed ');
            dbms_output.put_line('      This could be due to an exception in previous steps or due to no data found to insert  ');
        END IF;

        dbms_output.put_line('Inserting new keyref Data to data_subject_consent_purp_tab ...');
        IF (cons_purp_keyref_success_ AND cons_purp_backup_data_exists_) THEN
          BEGIN
            INSERT INTO data_subject_consent_purp_tab
               (key_ref,
                operation_date,
                action,
                process_purpose_id,
                valid,
                effective_on,
                effective_until,
                rowversion,
                rowkey)
             SELECT
                new_key_ref,
                operation_date,
                action,
                process_purpose_id,
                valid,
                effective_on,
                effective_until,
                rowversion,
                sys_guid()
             FROM data_subject_consent_purp_2110 t
             WHERE t.new_key_ref IS NOT NULL
             AND NOT EXISTS (SELECT 1
                             FROM  data_subject_consent_purp_tab d
                             WHERE d.key_ref            = t.new_key_ref
                             AND   d.operation_date     = t.operation_date
                             AND   d.action             = t.action
                             AND   d.process_purpose_id = t.process_purpose_id);
            COMMIT;
            cons_purp_insert_success_  := TRUE;

          EXCEPTION
            WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('New key ref insert to data_subject_consent_purp_tab, failed with error '||err_msg_);
          END;
        ELSE
            dbms_output.put_line('   New key ref insert to data_subject_consent_purp_tab was not performed ');
            dbms_output.put_line('      This could be due to an exception in previous steps or due to no data found to insert  ');
        END IF;

        dbms_output.put_line('Inserting new keyref Data to personal_data_cleanup_log_tab ...');
        IF (per_clnup_new_keyref_success_ AND per_clnup_backup_data_exists_) THEN
          BEGIN
            INSERT INTO personal_data_cleanup_log_tab
               (key_ref,
                operation_date,
                action,
                pers_data_management_id,
                seq_no,
                completed,
                error_message,
                rowversion,
                rowkey)
             SELECT
                new_key_ref,
                operation_date,
                action,
                pers_data_management_id,
                seq_no,
                completed,
                error_message,
                rowversion,
                sys_guid()
             FROM personal_data_cleanup_log_2110 t
             WHERE t.new_key_ref IS NOT NULL
             AND NOT EXISTS (SELECT 1
                             FROM  personal_data_cleanup_log_tab p
                             WHERE p.key_ref                 = t.new_key_ref
                             AND   p.operation_date          = t.operation_date
                             AND   p.action                  = t.action
                             AND   p.pers_data_management_id = t.pers_data_management_id
                             AND   p.seq_no                  = t.seq_no);
             COMMIT;
             per_cleanup_insert_success_  := TRUE;

           EXCEPTION
             WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('New key ref insert to personal_data_cleanup_log_tab, failed with error '||err_msg_);
           END;

         ELSE
            dbms_output.put_line('   New key ref insert to personal_data_cleanup_log_tab was not performed ');
            dbms_output.put_line('      This could be due to an exception in previous steps or due to no data found to insert  ');
         END IF;

     $ELSE
         NULL;
     $END
   END Insert_New_Data___;

   PROCEDURE Remove_obsolete_data___
   IS
   BEGIN
     $IF Component_Person_SYS.INSTALLED $THEN

        /* DELETE FROM data_subject_consent_tab d
         WHERE d.key_ref = (SELECT key_ref
                            FROM  data_subject_consent_2110 t
                            WHERE t.key_ref = d.key_ref
                            AND   t.new_key_ref IS NOT NULL);*/


         dbms_output.put_line('Removing obsolete keyref Data from data_subject_consent_tab ...');
         IF (cons_insert_success_) THEN
           BEGIN
             DELETE FROM data_subject_consent_tab d
             WHERE EXISTS   (SELECT 1
                             FROM  data_subject_consent_2110 t
                             WHERE t.key_ref = d.key_ref
                             AND   t.new_key_ref IS NOT NULL);
             COMMIT;

           EXCEPTION
             WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('Removal of old key ref data from data_subject_consent_tab, failed with error '||err_msg_);
           END;
         ELSE
            dbms_output.put_line('   Removal of old key ref data from data_subject_consent_tab was not performed ');
            dbms_output.put_line('      This could be due to an exception in previous steps or due to no data found to remove  ');
         END IF;

         /*DELETE FROM data_subject_consent_oper_tab d
         WHERE d.key_ref = (SELECT key_ref
                            FROM  data_subject_consent_oper_2110 t
                            WHERE t.key_ref = d.key_ref
                            AND   t.operation_date = d.operation_date
                            AND   t.action = d.action
                            AND   t.new_key_ref IS NOT NULL);*/

         dbms_output.put_line('Removing obsolete keyref Data from data_subject_consent_oper_tab ...');
         IF (cons_oper_insert_success_) THEN
           BEGIN
             DELETE FROM data_subject_consent_oper_tab d
             WHERE EXISTS  (SELECT 1
                            FROM  data_subject_consent_oper_2110 t
                            WHERE t.key_ref        = d.key_ref
                            AND   t.operation_date = d.operation_date
                            AND   t.action         = d.action
                            AND   t.new_key_ref IS NOT NULL);
             COMMIT;

           EXCEPTION
             WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('Removal of old key ref data from data_subject_consent_oper_tab, failed with error '||err_msg_);
           END;
         ELSE
            dbms_output.put_line('   Removal of old key ref data from data_subject_consent_oper_tab was not performed ');
            dbms_output.put_line('      This could be due to an exception in previous steps or due to no data found to remove  ');
         END IF;

        /* DELETE FROM data_subject_consent_purp_tab d
         WHERE d.key_ref = (SELECT key_ref
                            FROM  data_subject_consent_purp_2110 t
                            WHERE t.key_ref = d.key_ref
                            AND   t.operation_date = d.operation_date
                            AND   t.action = d.action
                            AND   t.process_purpose_id = d.process_purpose_id
                            AND   t.new_key_ref IS NOT NULL);  */

         dbms_output.put_line('Removing obsolete keyref Data from data_subject_consent_purp_tab ...');
         IF (cons_purp_insert_success_) THEN
           BEGIN
             DELETE FROM data_subject_consent_purp_tab d
             WHERE EXISTS (SELECT 1
                             FROM  data_subject_consent_purp_2110 t
                            WHERE t.key_ref              = d.key_ref
                              AND   t.operation_date     = d.operation_date
                              AND   t.action             = d.action
                              AND   t.process_purpose_id = d.process_purpose_id
                              AND   t.new_key_ref IS NOT NULL);
             COMMIT;

           EXCEPTION
             WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('Removal of old key ref data from data_subject_consent_purp_tab, failed with error '||err_msg_);
           END;
         ELSE
            dbms_output.put_line('   Removal of old key ref data from data_subject_consent_purp_tab was not performed ');
            dbms_output.put_line('     This could be due to an exception in previous steps or due to no data found to remove  ');
         END IF;

       /*DELETE FROM personal_data_cleanup_log_tab p
       WHERE p.key_ref = (SELECT key_ref
                          FROM  personal_data_cleanup_log_2110 t
                          WHERE t.key_ref = p.key_ref
                          AND   t.operation_date = p.operation_date
                          AND   t.action = p.action
                          AND   t.pers_data_management_id = p.pers_data_management_id
                          AND   t.seq_no = p.seq_no
                          AND   t.new_key_ref IS NOT NULL);*/

       dbms_output.put_line('Removing obsolete keyref Data from personal_data_cleanup_log_tab ...');
       IF (per_cleanup_insert_success_) THEN
         BEGIN
           DELETE FROM personal_data_cleanup_log_tab p
           WHERE EXISTS (SELECT 1
                         FROM  personal_data_cleanup_log_2110 t
                         WHERE t.key_ref                 = p.key_ref
                         AND   t.operation_date          = p.operation_date
                         AND   t.action                  = p.action
                         AND   t.pers_data_management_id = p.pers_data_management_id
                         AND   t.seq_no                  = p.seq_no
                         AND   t.new_key_ref IS NOT NULL);
           COMMIT;

         EXCEPTION
           WHEN OTHERS THEN
               err_msg_ := SUBSTR(SQLERRM, 1, 200);
               dbms_output.put_line('Removal of old key ref data from personal_data_cleanup_log_tab, failed with error '||err_msg_);
         END;
       ELSE
           dbms_output.put_line('   Removal of old key ref data from personal_data_cleanup_log_tab was not performed ');
           dbms_output.put_line('      This could be due to an exception in previous steps or due to no data found to remove  ');
       END IF;

     $ELSE
         NULL;
     $END

   END Remove_obsolete_data___;


   PROCEDURE Remove_Backup_Tables___
   IS
   BEGIN

      Database_SYS.Remove_Table('data_subject_consent_2110',TRUE);
      Database_SYS.Remove_Table('data_subject_consent_oper_2110',TRUE);
      Database_SYS.Remove_Table('data_subject_consent_purp_2110',TRUE);
      Database_SYS.Remove_Table('personal_data_cleanup_log_2110',TRUE);

   END Remove_Backup_Tables___;
BEGIN
    $IF Component_Person_SYS.INSTALLED $THEN

        Set_Backup_data_Flags___;

        -- Set flag by checking if back up data exists for at least one step
        backup_data_exists_ := (cons_backup_data_exists_ OR cons_oper_backup_data_exists_ OR
                                cons_purp_backup_data_exists_ OR per_clnup_backup_data_exists_);

        IF (backup_data_exists_) THEN
           Set_New_Keyref___;
           Insert_New_Data___;
           Remove_obsolete_data___;
        ELSE
           dbms_output.put_line('No obsolete data is there to proceed, Removing Back up Tables and Terminating.... ');
           Remove_Backup_Tables___;
        END IF;
    $ELSE
       NULL;
    $END
END;
/

exec Database_SYS.Log_Detail_Time_Stamp('ENTERP','Post_Enterp_UpdateDependentInformation.sql','Done');
PROMPT Finished with Post_Enterp_UpdateDependentInformation.sql

