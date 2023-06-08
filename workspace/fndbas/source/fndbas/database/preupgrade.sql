--------------------------------------------------------------------------
--  File:      preupgrade.sql
--
--  Module:    Fndbas
--
--  Function:  The purpose of this script is to validate package InstallationSYS since it may be invalid when you start an upgrade from.
--             Apps7 and Apps7.5 (Fndbas version 400 and 410)
--
--  Date    Sign     History
--  ------  -----    --------------------------------------------------------------------------------------------
--  141119  MABOSE   Created.
--  -------------------------------------------------------------------------------------------------------------
PROMPT Starting preupgrade.sql

PROMPT ADD TRUST ON PRAGMA RESTRICT_REFERENCES since it IN some cases has become invalid due TO PRAGMA violations

DECLARE
   stmt_  VARCHAR2(32000);
   found_ BOOLEAN := FALSE;
   CURSOR get_rec IS
      SELECT text
      FROM user_source
      WHERE NAME = 'INSTALLATION_SYS'
      AND TYPE = 'PACKAGE'
      ORDER BY line;
BEGIN
   stmt_ := 'CREATE OR REPLACE ';
   FOR rec_ IN get_rec LOOP
      IF INSTR(UPPER(rec_.text), 'PRAGMA RESTRICT_REFERENCES(VIEW_EXIST, WNDS)') > 0 THEN
         found_ := TRUE;
         stmt_ := stmt_ || REPLACE(UPPER(rec_.text), 'PRAGMA RESTRICT_REFERENCES(VIEW_EXIST, WNDS)', 'PRAGMA RESTRICT_REFERENCES(VIEW_EXIST, WNDS, TRUST)');
      ELSE
         stmt_ := stmt_ || rec_.text;
      END IF;
   END LOOP;
   IF found_ THEN
      EXECUTE IMMEDIATE stmt_;
      stmt_ := 'ALTER PACKAGE INSTALLATION_SYS COMPILE';
      EXECUTE IMMEDIATE stmt_;
      stmt_ := 'ALTER PACKAGE DATABASE_SYS COMPILE';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/

DECLARE
   CURSOR get_rec IS
      SELECT object_name
      FROM user_objects u
      WHERE object_type = 'PACKAGE'
      AND object_name LIKE 'COMPONENT_%_SYS' 
      AND EXISTS
      (SELECT 1
       FROM user_source
       WHERE NAME = u.object_name
       AND TYPE = u.object_type
       AND text LIKE '%"'||UPPER(SUBSTR(NAME,11,INSTR(NAME, '_', -1) - INSTR(NAME, '_') -1))||'"%');
BEGIN
   FOR rec_ IN get_rec LOOP
      EXECUTE IMMEDIATE  'DROP PACKAGE '|| rec_.object_name; 
   END LOOP;
END;
/

PROMPT Finished with preupgrade.sql
