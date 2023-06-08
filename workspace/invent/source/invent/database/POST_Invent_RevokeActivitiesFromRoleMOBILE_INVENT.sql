-----------------------------------------------------------------------------
--  Module   : INVENT
--
--  File     : POST_Invent_RevokeActivitiesFromRoleMOBILE_INVENT.sql
--  
--  Function : Removed revoke of activities from Obsolete role MOBILE_INVENT from Inventcl.sql and added here, since Inventcl.sql is not run always
--             and it's mandatory to run revoking activities from Obsolete role MOBILE_INVENT. If the role is not used anywhere, it is also dropped.
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  200828   JaThlk  SC2020R1-9529, Removed the code block(Revoke Activities) to avoid build errors after the new authentication solution,
--  200828           until the decision would have been taken, it is safe to remove the entire file.
--  180814   NiNilk  Bug 143392, Created.
--  ------   ------  --------------------------------------------------
-----------------------------------------------------------------------------

SET SERVEROUT ON
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RevokeActivitiesFromRoleMOBILE_INVENT.sql','Timestamp_1');
PROMPT Starting POST_Invent_RevokeActivitiesFromRoleMOBILE_INVENT.sql
PROMPT Removing obsolete Roles...
DEFINE ROLE = MOBILE_INVENT

--
-- Drop role MOBILE_INVENT, if it is not used.
--
DECLARE   
   ial_owner_ VARCHAR2(30) := Fnd_Setting_API.Get_Value('IAL_USER');
   found_     NUMBER;

   CURSOR exist_role_usages IS
      SELECT 1                   -- check for Object privileges 
        FROM dba_tab_privs     
       WHERE grantee = '&ROLE'       
       UNION
      SELECT 1                   -- check for Roles privileges
        FROM dba_role_privs          
       WHERE (grantee = '&ROLE' OR granted_role = '&ROLE')
       UNION
      SELECT 1
        FROM dba_sys_privs       -- check for System privileges
       WHERE grantee = '&ROLE'      
       UNION
      SELECT 1                   -- check for Activity privileges
        FROM activity_grant_tab
       WHERE role = '&ROLE'      
       UNION
      SELECT 1                   -- check for PressObject privileges
        FROM pres_object_grant    
       WHERE role = '&ROLE'      
       UNION
      SELECT 1                   -- check for IAL privileges
        FROM dba_tab_privs        
       WHERE grantee = '&ROLE'
         AND owner   = ial_owner_;
BEGIN
   OPEN exist_role_usages;
   FETCH exist_role_usages INTO found_;
   IF (exist_role_usages%NOTFOUND) THEN
      CLOSE exist_role_usages;
      Security_SYS.Drop_Role('&ROLE');
   END IF;
   COMMIT;
EXCEPTION
   WHEN others THEN
      NULL;
END;
/
UNDEFINE ROLE
PROMPT Finished with POST_Invent_RevokeActivitiesFromRoleMOBILE_INVENT.sql
exec Database_SYS.Log_Detail_Time_Stamp('INVENT','POST_Invent_RevokeActivitiesFromRoleMOBILE_INVENT.sql','Done');
