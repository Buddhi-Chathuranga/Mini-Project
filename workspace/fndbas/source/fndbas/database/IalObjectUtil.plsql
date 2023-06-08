-----------------------------------------------------------------------------
--
--  Logical unit: IalObjectUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  990301  MANY    Project Invader for IAL (ToDo #3177).
--  990322  MANY    Implemented partial replication (ToDo #3222)
--  001026  ROOD    Added quotation around user in Create_Ial_User and Grant_All_Objects.
--                  Corrected Grant-statement in Create_Ial_User (Bug#17619).
--  020626  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  031103  ROOD    Avoided replication if next_exec_time is null and removed
--                  reset of next_exec_time_ in Initiate_Replication__ (Bug#39757).
-- -050329  NiWi    Modified Initiate_Replication__: next_exec_time is updated as soon as 
--                  the job is posted(Bug#49197).
--  050404  JORA    Added assertion for dynamic SQL.  (F1PR481)
--                  Removed Exec_Ddl_Statement___ and replaced with EXECUTE IMMEDIATE.
--  051018  ASWILK  Added order by to Initiate_Replication__ cursor (Bug#54016).
--  060105  UTGULK  Annotated Sql injection
--  060927  RaRuLk  Chaged the call in to Assert_Is_Valid_New_User in Create_Ial_User(Bug#60819)..
--  071207  SUMALK  Changed Initiate Replication to include records with no status.(Bug#69517).
--  080805  DuWiLk  Modified Initiate_Replication__to initiate only repeating replication jobs (Bug#75172).
--  110919  ChMuLK  Modified Grant_All_Objects to increase performance (RDTERUNTIME-710) 
--  120229  DuWiLk  Modified Initiate_replication__ and added new proceduer Set_Error_Schedule_Time___ (RDTERUNTIME-1978)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Slave_Exec_Ddl_Statement___ (
   stmt_        IN VARCHAR2 )
IS
   info_owner_ VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   cid_  NUMBER;
   cnt_  NUMBER;
BEGIN
   IF (info_owner_ <> '*' AND info_owner_ IS NOT NULL) THEN
-- Call slave method
      cid_ := dbms_sql.open_cursor;
      Assert_SYS.Assert_Is_User(info_owner_);
      @ApproveDynamicStatement(2006-01-05,utgulk)
      dbms_sql.parse(cid_, 'begin '||info_owner_||'.IAL_Object_Slave_API.Exec_Ddl_Statement(:stmt_); end;', dbms_sql.native);
      dbms_sql.bind_variable(cid_, ':stmt_', stmt_);
      cnt_ := dbms_sql.execute(cid_);
      dbms_sql.close_cursor(cid_);
   ELSE
      Error_SYS.Appl_General(lu_name_, 'NOIALOWNER: Information Access Layer is not enabled');
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      RAISE;
END Slave_Exec_Ddl_Statement___;


PROCEDURE Check_Ial_User___ (
   name_ IN VARCHAR2 )
IS
   cid_  NUMBER;
   cnt_  NUMBER;
BEGIN
   cid_ := dbms_sql.open_cursor;
   Assert_SYS.Assert_Is_User(name_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   dbms_sql.parse(cid_, 'begin '||name_||'.Ial_Object_Slave_API.Init; end;', dbms_sql.native);
   cnt_ := dbms_sql.execute(cid_);
   dbms_sql.close_cursor(cid_);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      Error_SYS.Appl_General(lu_name_, 'IALNOTINST: Information Access Layer has not been properly installed.');
END Check_Ial_User___;


PROCEDURE Set_Error_Schedule_Time___
IS
   error_executions_ NUMBER;
   next_execution_time_ DATE;

   CURSOR get_error_jobs IS
      SELECT *
      FROM ial_object
      WHERE replication_status = 'ERROR' AND 
            replication_schedule IS NOT NULL AND 
            replication_schedule NOT LIKE 'ON%' AND
            next_exec_time IS NULL;
           
BEGIN
    
    error_executions_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('IAL_ERROR_OCCURENCE'));
    IF error_executions_ < 0 THEN
       FOR rec_ IN get_error_jobs LOOP
          next_execution_time_ := Batch_SYS.Get_Next_Exec_Time__(rec_.replication_schedule, SYSDATE);
          
          UPDATE ial_object_tab
          SET next_exec_time = next_execution_time_
          WHERE name = rec_.name;
          
       END LOOP;
    ELSIF error_executions_ > 0 THEN
       FOR rec_ IN get_error_jobs LOOP
          IF error_executions_ > rec_.failed_executions THEN
             next_execution_time_ := Batch_SYS.Get_Next_Exec_Time__(rec_.replication_schedule, SYSDATE);
             UPDATE ial_object_tab
             SET next_exec_time = next_execution_time_
             WHERE name = rec_.name;

          END IF;
       END LOOP;

    END IF;
END Set_Error_Schedule_Time___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Initiate_Replication__
IS
   info_owner_ VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   next_exec_time_  DATE;
   error_ocurrence_ NUMBER;

   CURSOR get_repl_object IS
      SELECT * 
        FROM ial_object
       WHERE (replication_status <> 'ERROR' OR replication_status IS NULL OR replication_schedule IS NOT NULL)
         AND next_exec_time IS NOT NULL
         AND next_exec_time < SYSDATE
      ORDER BY next_exec_time ASC;
BEGIN
   error_ocurrence_ := Client_SYS.Attr_Value_To_Number(Fnd_Setting_API.Get_Value('IAL_ERROR_OCCURENCE'));
   IF (info_owner_ <> '*' AND info_owner_ IS NOT NULL) THEN -- Skip this if not initiated
      Set_Error_Schedule_Time___;
      FOR rec_ IN get_repl_object LOOP
         IF (rec_.replication IN ('FULL_REPLICATION','PARTIAL_REPLICATION')) THEN
            IF (rec_.replication_schedule IS NOT NULL AND rec_.replication_schedule NOT LIKE 'ON%') THEN
               next_exec_time_ := Batch_SYS.Get_Next_Exec_Time__(rec_.replication_schedule, rec_.next_exec_time);
                 
               IF rec_.replication_status IS NULL OR rec_.replication_status = 'OK'  THEN
                  UPDATE ial_object_tab
                     SET replication_status = 'POSTED',
                         next_exec_time = next_exec_time_,
                         rowversion = sysdate
                   WHERE name = rec_.name;
               END IF;

               IF error_ocurrence_ < 0 THEN 
                  Ial_Object_API.Post_Replication(rec_.name);
               ELSIF error_ocurrence_ = 0 THEN
                  IF rec_.failed_executions = 0  THEN
                      Ial_Object_API.Post_Replication(rec_.name);
                  ELSE
                     UPDATE ial_object_tab
                        SET next_exec_time = NULL,
                            rowversion = sysdate
                      WHERE name = rec_.name;
                  END IF;
               ELSE
                  IF error_ocurrence_ > rec_.failed_executions THEN
                     Ial_Object_API.Post_Replication(rec_.name);
                  ELSIF error_ocurrence_ = rec_.failed_executions THEN
                     UPDATE ial_object_tab
                        SET next_exec_time = NULL,
                            rowversion = sysdate
                      WHERE name = rec_.name;
                  END IF;
               END IF;
            ELSE
               next_exec_time_ := NULL;
               UPDATE ial_object_tab
                  SET next_exec_time = NULL,
                      replication_status = NULL,
                      rowversion = sysdate
                WHERE name = rec_.name;

               Ial_Object_API.Post_Replication(rec_.name);
            END IF;
         ELSE
            UPDATE ial_object_tab
               SET next_exec_time = NULL,
                   replication_status = NULL,
                   rowversion = sysdate
             WHERE name = rec_.name;
         END IF;
      END LOOP;
   END IF;
END Initiate_Replication__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Grant_All_Objects (
   dummy_ IN VARCHAR2 )
IS
   info_owner_ VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   cid_  NUMBER;
   cnt_  NUMBER;
   CURSOR get_objects IS
      SELECT object_name, decode(object_type, 'VIEW',   'SELECT', 
                                              'TABLE',  'SELECT', 
                                              'PACKAGE','EXECUTE', 'NULL') grant_option
      FROM   user_objects
      WHERE  object_type IN ('VIEW', 'PACKAGE', 'TABLE')
      MINUS
      SELECT table_name,privilege
      FROM   user_tab_privs_made
      WHERE  grantee = upper(info_owner_);
BEGIN
   cid_ := dbms_sql.open_cursor;
   IF (info_owner_ <> '*' AND info_owner_ IS NOT NULL) THEN
      FOR rec_ IN get_objects LOOP
         BEGIN
            IF (rec_.grant_option <> 'NULL' AND rec_.object_name <> 'IAL_OBJECT_UTIL_API') THEN -- Don't grant if not right type of object, especially not this package (Oracle hangs!)
               -- Do not use Exec_Ddl_Statement___. Only parsing is necessary (performance reasons)
               Assert_SYS.Assert_Is_Grantee(info_owner_);
               Assert_SYS.Assert_Is_User_Object(rec_.object_name);
               Assert_SYS.Assert_Is_In_Whitelist(rec_.grant_option,'SELECT,INSERT,UPDATE,EXECUTE');
               @ApproveDynamicStatement(2006-01-05,utgulk)
               dbms_sql.parse(cid_, 'GRANT '||rec_.grant_option||' ON '||rec_.object_name||' TO "'||info_owner_ || '" WITH GRANT OPTION', dbms_sql.native);
               cnt_ := dbms_sql.execute(cid_);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               NULL; -- object did not grant, ignore... (Could be a cascade effect)
         END;
      END LOOP;
   ELSE
      Error_SYS.Appl_General(lu_name_, 'NOIALOWNER: Information Access Layer is not enabled');
   END IF;
   dbms_sql.close_cursor(cid_);
EXCEPTION
   WHEN OTHERS THEN
      IF (dbms_sql.is_open(cid_)) THEN
         dbms_sql.close_cursor(cid_);
      END IF;
      RAISE;
END Grant_All_Objects;


PROCEDURE Create_Ial_User (
   identity_  IN VARCHAR2,
   password_  IN VARCHAR2 )
IS
BEGIN
   Assert_SYS.Assert_Is_Valid_New_User(identity_);
   Assert_SYS.Assert_Is_Valid_Password(password_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE 'CREATE USER "'||identity_||'" IDENTIFIED BY "'||password_||'"';
   Assert_SYS.Assert_Is_Grantee(identity_);
   @ApproveDynamicStatement(2006-01-05,utgulk)
   EXECUTE IMMEDIATE 'GRANT CONNECT, RESOURCE TO "'||identity_||'"';
END Create_Ial_User;


PROCEDURE Check_Ial_User (
   name_ IN VARCHAR2 )
IS
   info_owner_ VARCHAR2(30) := nvl(name_, Fnd_Setting_API.Get_Value('IAL_USER'));
BEGIN
   IF (name_ IS NOT NULL) THEN
      Check_Ial_User___(name_);
   ELSIF (info_owner_ <> '*' AND info_owner_ IS NOT NULL) THEN
   -- Check user info_owner_
      Check_Ial_User___(info_owner_);
   ELSE
      Error_SYS.Appl_General(lu_name_, 'NOIALOWNER: Information Access Layer is not enabled');
   END IF;
END Check_Ial_User;



