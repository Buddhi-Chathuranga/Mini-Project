DECLARE
   CURSOR get_all_invalids IS
      SELECT object_id,
             owner,
             object_name,
             object_type
      FROM   all_objects
      WHERE  (owner = '&APPLICATION_OWNER'
      OR     (owner = '&IAL_OWNER'
      AND     UPPER(SUBSTR('&COMPILE_OTHER_SCHEMA', 1, 1)) = 'Y'))
      AND    object_type NOT IN ('PACKAGE', 'VIEW', 'FUNCTION', 'PROCEDURE', 'PACKAGE BODY', 'VIEW', 'TRIGGER')
      AND    status = 'INVALID';
BEGIN
   Utl_Recomp.Recomp_Parallel(8, '&APPLICATION_OWNER');
   IF UPPER(SUBSTR('&COMPILE_OTHER_SCHEMA', 1, 1)) = 'Y' THEN
      Utl_Recomp.Recomp_Parallel(8, '&IAL_OWNER');
   END IF ;
   
   -- Compile any invalid objects that exist in IFS deployment schemas (AppOwner and IAL)
   -- where the object type can't be handled by Dbms_Utility.Compile_Schema
   FOR obj_ IN get_all_invalids LOOP
      BEGIN
         IF (obj_.object_type = 'QUEUE') THEN
            Dbms_Aqadm.Alter_Queue(obj_.owner || '.' || obj_.object_name);
         ELSIF (obj_.object_type = 'EVALUATION CONTEXT') THEN
            Dbms_Rule_Adm.Alter_Evaluation_Context(obj_.owner || '.' || obj_.object_name);
         ELSE
            Dbms_Utility.Validate(obj_.object_id);
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
   END LOOP;
END;
/