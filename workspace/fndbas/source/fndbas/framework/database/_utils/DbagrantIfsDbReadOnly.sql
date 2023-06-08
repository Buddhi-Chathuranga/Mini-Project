DECLARE

PROCEDURE DbagrantIfsDbReadOnly (
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
   --
   -- Revoke Obsolete Grants
   -- Specific Tables are Granted with the Privilages
   --
   Run_Ddl('REVOKE SELECT ANY TABLE FROM ' || username_);
   Run_Ddl('GRANT DEBUG CONNECT SESSION TO ' || username_);
   --
   -- Additional grants with V$ view access
   -- Not Implemented for now
   --
   
   /* 
	Run_Ddl('GRANT SELECT ON V_$SESSION TO '||username_);
	Run_Ddl('GRANT SELECT ON GV_$SESSION TO '||username_);
	
	Run_Ddl('GRANT SELECT ON V_$LOCKED_OBJEC TO '||username_);
	Run_Ddl('GRANT SELECT ON V_$LOCK TO '||username_);
	
	Run_Ddl('GRANT SELECT ON GV_$LOCKED_OBJEC TO '||username_);
	Run_Ddl('GRANT SELECT ON GV_$LOCK TO '||username_);
	
	Run_Ddl('GRANT SELECT ON V_$TABLESPACE  TO '||username_);
	Run_Ddl('GRANT SELECT ON GV_$TABLESPACE  TO '||username_);
	
	Run_Ddl('GRANT SELECT ON DBA_TABLESPACE TO '||username_);
	
	Run_Ddl('GRANT SELECT ON DBA_OBJECTS TO '||username_); 
*/

END DbagrantIfsDbReadOnly;

BEGIN
   DbagrantIfsDbReadOnly('IFSDBREADONLY');
END;
/