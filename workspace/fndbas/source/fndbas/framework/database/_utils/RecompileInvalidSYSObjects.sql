DECLARE
   stmt_  VARCHAR2(300);
   CURSOR getinvalids IS
      SELECT o.owner, o.object_name, o.object_type
      FROM dba_objects o, dba_plsql_object_settings s
      WHERE  o.owner = s.owner 
      AND    o.object_name = s.name
      AND    o.object_type = s.type
      AND   o.owner = 'SYS'
      AND  (o.status = 'INVALID'
      OR    s.nls_length_semantics = 'CHAR')
      AND   o.oracle_maintained = 'Y'
      ORDER BY DECODE(o.object_type, 'PACKAGE', 10,
                                     'TYPE', 20,
                                     50 ),
               o.object_name;
   PROCEDURE Run_Ddl_Command___ (
      stmt_      IN VARCHAR2 )
   IS
   BEGIN
      EXECUTE IMMEDIATE stmt_;
   END Run_Ddl_Command___;
BEGIN
   FOR rec_ IN getinvalids LOOP
      BEGIN
         IF (rec_.object_type LIKE 'PACKAGE BODY') THEN
            stmt_ := 'ALTER PACKAGE '||rec_.object_name ||' COMPILE BODY NLS_LENGTH_SEMANTICS=BYTE REUSE SETTINGS';
         ELSIF (rec_.object_type LIKE 'TYPE BODY') THEN
            stmt_ := 'ALTER TYPE '||rec_.object_name ||' COMPILE BODY NLS_LENGTH_SEMANTICS=BYTE REUSE SETTINGS';
         ELSE
            stmt_ := 'ALTER '|| rec_.object_type || ' ' ||rec_.object_name ||' COMPILE NLS_LENGTH_SEMANTICS=BYTE REUSE SETTINGS';
         END IF;
         Run_Ddl_Command___(stmt_);
      EXCEPTION
         WHEN OTHERS THEN 
            NULL;
      END;
   END LOOP;
END;
/