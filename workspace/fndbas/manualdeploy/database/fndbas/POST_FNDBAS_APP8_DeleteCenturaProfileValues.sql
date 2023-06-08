
--
-- NOTE  
-- This will delete all old centura profile values in all user profiles.
-- Consider migrate Saved Queries to Saved Searches using Migrate Saved Queries window 
-- in IFS Enterprise Explorer before executing this script.
--

SET VERIFY OFF;
SET SERVEROUT ON;
 
DEFINE message1 = 'This will delete all old centura profile values in all user profiles.'
DEFINE message2a = 'Consider migrate Saved Queries to Saved Searches using Migrate Saved Queries'
DEFINE message2b = 'in IFS Enterprise Explorer before executing this script.'
DEFINE message3 = 'Do you want to continue Y/N [N]? '

DEFINE message4a = 'All Centura Profile Values '
DEFINE message4b = 'have been deleted'
DEFINE message5 = 'You need to commit this transaction in order to remove the values permanently'
DEFINE message6 = 'No Centura Profile Values found'

PROMPT 
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP8_DeleteCenturaProfileValues.sql','Timestamp_1');
PROMPT &message1
PROMPT &message2a
PROMPT &message2b
PROMPT 

ACCEPT continue default 'N' PROMPT '&message3' ;
PROMPT 

DECLARE count_ NUMBER;
BEGIN
IF ('&continue' = 'Y' OR '&continue' = 'y') THEN
   SELECT count(*) INTO count_ FROM fndrr_client_profile_value_tab t where t.profile_section like 'User/Centura/%';
   delete from fndrr_client_profile_value_tab t where t.profile_section like 'User/Centura/%';
   IF (count_ > 0) THEN
      dbms_output.put_line('&message4a' || '(' || TO_CHAR(count_) || ') ' || '&message4b');
      dbms_output.put_line('&message5');
   ELSE
      dbms_output.put_line('&message6');
   END IF;
ELSE
   dbms_output.put_line('Operation Aborted');
END IF;
END;
/
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_APP8_DeleteCenturaProfileValues.sql','Done');

