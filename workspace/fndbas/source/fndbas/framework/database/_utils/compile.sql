-- Note! This file is copied to IFS_HOME by logic in server/config_fndbas.xml
--       If changes done to the file, and no server is included in delivery
--       this file has to be manually copied to IFS_HOME.
      
SET SERVEROUT ON

SPOOL compileinvalids.log

DECLARE
   counts_   NUMBER;
   CURSOR get_all_invalids IS
      SELECT object_id,
             owner,
             object_name,
             object_type
      FROM   all_objects
      WHERE  owner = USER
      AND    object_type NOT IN ('PACKAGE', 'VIEW', 'FUNCTION', 'PROCEDURE', 'PACKAGE BODY', 'VIEW', 'TRIGGER')
     AND    status = 'INVALID';
BEGIN
   SELECT COUNT(*)
   INTO counts_
   FROM all_objects
   WHERE  owner = USER
   AND status = 'INVALID'; 
   IF counts_ > 0 THEN
      Dbms_Output.Put_Line('Totally '||counts_||' invalid objects exist before compile');
      SYS.Utl_Recomp.Recomp_Parallel(8, USER);
      
      FOR obj_ IN get_all_invalids LOOP
         BEGIN
            IF (obj_.object_type = 'QUEUE') THEN
               EXECUTE IMMEDIATE 'Dbms_Aqadm.Alter_Queue(obj_.owner || ''.'' || obj_.object_name);';
            ELSIF (obj_.object_type = 'EVALUATION CONTEXT') THEN
               EXECUTE IMMEDIATE 'Dbms_Rule_Adm.Alter_Evaluation_Context(obj_.owner || ''.'' || obj_.object_name);';
            ELSE
               Dbms_Utility.Validate(obj_.object_id);
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               NULL;
         END;
      END LOOP;
      SELECT COUNT(*)
      INTO counts_
      FROM all_objects
      WHERE  owner = USER
      AND status = 'INVALID'; 
      IF counts_ > 0 THEN
         Dbms_Output.Put_Line('Totally '||counts_||' invalid objects exist after compile');
      ELSE
         Dbms_Output.Put_Line('No invalid objects exist after compile');
      END IF;
   ELSE
      Dbms_Output.Put_Line('No invalid objects exist');
   END IF;
END;
/

SET SERVEROUT OFF

SPOOL OFF


