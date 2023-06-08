DECLARE

PROCEDURE DbagrantIfsIamSys (
   username_ IN VARCHAR2 )
IS
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
   Run_Ddl('GRANT CREATE TABLE TO ' || username_);
   Run_Ddl('GRANT CREATE VIEW TO ' || username_);
   Run_Ddl('GRANT CREATE TRIGGER TO ' || username_);
   Run_Ddl('GRANT CREATE PROCEDURE TO ' || username_);
   Run_Ddl('GRANT CREATE SEQUENCE TO ' || username_);
   Run_Ddl('GRANT CREATE SYNONYM TO ' || username_);
   Run_Ddl('GRANT MERGE ANY VIEW TO ' || username_);
END DbagrantIfsIamSys;

BEGIN
   DbagrantIfsIamSys('&IAM_APPOWNER');
END;
/