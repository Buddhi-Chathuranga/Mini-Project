DECLARE

PROCEDURE DbagrantIal (
   username_ IN VARCHAR2 )
IS
   CURSOR get_source$_grants IS
SELECT privilege
FROM   all_tab_privs
WHERE  grantee = upper(username_)
AND    table_name = 'SOURCE$'
AND    privilege IN ('INSERT', 'UPDATE', 'DELETE');
--
   PROCEDURE Run_Ddl (stmt_  IN VARCHAR2,
                      debug_ IN VARCHAR2 DEFAULT 'TRUE') IS
   BEGIN
      EXECUTE IMMEDIATE stmt_;
      Dbms_Output.Put_Line('SUCCESS: ' || stmt_);
   EXCEPTION
      WHEN OTHERS THEN
         Dbms_Output.Put_Line('ERROR  : ' || stmt_);
   END Run_Ddl;
BEGIN
   --
   -- Oracle install privileges
   --
   Run_Ddl('GRANT CREATE SESSION TO ' || username_);
   Run_Ddl('GRANT ALTER SESSION TO ' || username_);
   Run_Ddl('GRANT CREATE VIEW TO ' || username_);
   Run_Ddl('GRANT CREATE PROCEDURE TO ' || username_);
   Run_Ddl('GRANT CREATE TABLE TO ' || username_);
   Run_Ddl('GRANT MERGE ANY VIEW TO ' || username_);
   Run_Ddl('GRANT SELECT ON SOURCE$ TO ' || username_);
   --
   -- Grants needed for IAL owner to be able to use parallel re-compilation
   --
   Run_Ddl('GRANT EXECUTE ON UTL_RECOMP TO ' || username_ );
   --
   --
   -- Remove ddl grants from SOURCE$
   --
   FOR rec IN get_source$_grants LOOP
      Run_Ddl('REVOKE '||rec.privilege||' ON SOURCE$ FROM ' || username_);
   END LOOP;
END DbagrantIal;


BEGIN
   DbagrantIal('&IAL_OWNER');
END;
/