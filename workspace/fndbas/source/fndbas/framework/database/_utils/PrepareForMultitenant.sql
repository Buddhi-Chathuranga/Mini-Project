DECLARE

PROCEDURE Prepare_For_Multitenant
IS
   stmt_ VARCHAR2(2000) :=
  'DECLARE
      CURSOR c1 IS
         SELECT NAME
         FROM v$pdbs;
   BEGIN
      FOR rec IN c1 LOOP
         EXECUTE IMMEDIATE ''ALTER PLUGGABLE DATABASE ''||rec.name||'' SAVE STATE'';
      END LOOP;
   END;';
   CURSOR get_db_info IS
      SELECT cdb
      FROM v$database;
BEGIN
   FOR rec_ IN get_db_info LOOP
      IF rec_.cdb = 'YES' THEN
         EXECUTE IMMEDIATE stmt_;
      END IF;
   END LOOP;
END Prepare_For_Multitenant;

BEGIN
   Prepare_For_Multitenant;
END;
/