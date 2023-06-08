--PROMPT CREATE USER PROFILE

DECLARE
   dummy_   NUMBER;
   stmt_    VARCHAR2(1000);
   profile_ CONSTANT VARCHAR2(30) := '&INTERNAL_USER_PROFILE';
   CURSOR check_profile IS
      SELECT 1
      FROM dba_profiles
      WHERE profile = UPPER(profile_);

BEGIN
   OPEN check_profile;
   FETCH check_profile INTO dummy_;
   IF check_profile%FOUND THEN
      CLOSE check_profile;
      Dbms_Output.Put_Line('The profile "'|| UPPER(profile_) ||'" already exists in this database.');
   ELSE
      CLOSE check_profile;
      stmt_ := ' CREATE PROFILE '|| UPPER(profile_) || ' LIMIT PASSWORD_LIFE_TIME UNLIMITED PASSWORD_LOCK_TIME UNLIMITED PASSWORD_GRACE_TIME UNLIMITED';
      EXECUTE IMMEDIATE stmt_;
   END IF;
END;
/

