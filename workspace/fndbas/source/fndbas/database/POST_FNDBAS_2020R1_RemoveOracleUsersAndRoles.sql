---------------------------------------------------------------------------------------------------
--  Filename      : POST_FNDBAS_2020R1_RemoveOracleUsersAndRoles
-- 
--  Module        : FNDBAS 
--
--  Purpose       : Drops all non-system oracle user accounts and All oracle role related to Permssion sets, as they are no longer needed for 
--                  authentication/authorization in the 2020R1 release
-- 
--  Date      Sign      History
--  ------   ------    ----------------------------------------------------------------------------
--  200907   Ahorse    Created
---------------------------------------------------------------------------------------------------

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_2020R1_RemoveOracleUsersAndRoles','Timestamp_1');
PROMPT Starting POST_FNDBAS_2020R1_RemoveOracleUsersAndRoles

PROMPT Removing oracle users

DECLARE
   CURSOR user_name_cur IS 
      SELECT fu.oracle_user FROM fnd_user_tab fu 
      WHERE EXISTS (SELECT username FROM dba_users ou WHERE fu.oracle_user = ou.username)
      AND NOT EXISTS (SELECT 1 FROM dba_objects WHERE owner = fu.oracle_user)
      AND fu.oracle_user NOT IN (fnd_session_api.get_app_owner,'IFSMONITORING','IFSCAMSYS','IFSIAMSYS','DEMANDSERVER','SYNC_MASTER','IFSPRINT',fnd_setting_api.Get_Value('IAL_USER'));
   
   i_ NUMBER := 0;
BEGIN
	FOR user_rec_ IN user_name_cur LOOP
      
	   --DBMS_Output.put_line('Locking User ' || user_rec_.oracle_user);
       --EXECUTE IMMEDIATE ('ALTER USER "' || user_rec_.oracle_user || '" ACCOUNT LOCK');
	   --DBMS_Output.put_line('User ' || user_rec_.oracle_user  || ' LOCKED');
      
	   DBMS_Output.put_line('Droping User ' || user_rec_.oracle_user);
       EXECUTE IMMEDIATE ('DROP USER "' || user_rec_.oracle_user || '" CASCADE');
	   DBMS_Output.put_line('User ' || user_rec_.oracle_user  || ' DROPPED');
       i_ := i_ + 1;
	END LOOP;
    -- DBMS_Output.put_line(i_ || ' users LOCKED');  
    DBMS_Output.put_line(i_ || ' users DROPPED');  
END;
/

PROMPT Removing oracle roles

DECLARE
  CURSOR oracle_role_name_cur IS
    SELECT fr.role
      FROM fnd_role_tab fr
     WHERE EXISTS
     (SELECT role FROM dba_roles orarole WHERE fr.role = orarole.role);

  role_count_ NUMBER := 0;
BEGIN
  FOR role_name_cur IN oracle_role_name_cur LOOP
  
    DBMS_Output.put_line('Droping Role ' || role_name_cur.role);
    EXECUTE IMMEDIATE ('DROP ROLE "' || role_name_cur.role || '"');
    DBMS_Output.put_line('Role ' || role_name_cur.role || ' DROPPED');
    role_count_ := role_count_ + 1;
  END LOOP;
  DBMS_Output.put_line(role_count_ || ' oracle roles DROPPED');
END;
/
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_2020R1_RemoveOracleUsersAndRoles','Done');
PROMPT Finished with POST_FNDBAS_2020R1_RemoveOracleUsersAndRoles

