DECLARE

PROCEDURE EnableEditionsToUser (
   app_owner_ IN VARCHAR2,
   ial_owner_ IN VARCHAR2 )
IS
   ao_enabled_  VARCHAR2(5) := 'N';
   ial_enabled_ VARCHAR2(5) := 'N';
   CURSOR edition_enabled_for_user IS
     SELECT editions_enabled, username
     FROM dba_users
     WHERE username IN (app_owner_, ial_owner_);
   CURSOR get_all_mviews IS
     SELECT owner, mview_name
     FROM all_mviews
     WHERE (owner = app_owner_
     AND    ao_enabled_ = 'N')
     OR    (owner = ial_owner_
     AND    ial_enabled_ = 'N')
	 ORDER BY owner;
   CURSOR get_all_user_types IS
     SELECT owner, type_name 
     FROM all_types
     WHERE (owner = app_owner_
     AND    ao_enabled_ = 'N')
     OR    (owner = ial_owner_
     AND    ial_enabled_ = 'N')
	 ORDER BY owner; 

   PROCEDURE Run_Ddl (stmt_  IN VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE stmt_;
      Dbms_Output.Put_Line('SUCCESS: ' || stmt_);
   EXCEPTION
      WHEN OTHERS THEN
         Dbms_Output.Put_Line('ERROR  : ' || stmt_);
         RAISE;
   END Run_Ddl;
BEGIN
   FOR user_enabled_ IN edition_enabled_for_user LOOP
      IF user_enabled_.username = app_owner_ THEN
         ao_enabled_ := user_enabled_.editions_enabled;
         IF user_enabled_.editions_enabled = 'Y' THEN
            Dbms_Output.Put_Line('Editions already enabled for ' || app_owner_);
         END IF;
      ELSIF user_enabled_.username = ial_owner_ THEN
         ial_enabled_ := user_enabled_.editions_enabled;
         IF user_enabled_.editions_enabled = 'Y' THEN
            Dbms_Output.Put_Line('Editions already enabled for ' || ial_owner_);
         END IF;
      END IF;
   END LOOP;
   -- update all materialized views
   FOR mview IN get_all_mviews LOOP
     Run_Ddl('ALTER MATERIALIZED VIEW ' || mview.owner || '.' || mview.mview_name || ' EVALUATE USING CURRENT EDITION');
   END LOOP;
   --update all user types
   FOR user_type IN get_all_user_types LOOP
     Run_Ddl('ALTER TYPE ' || user_type.owner || '.' || user_type.type_name || ' NONEDITIONABLE');
   END LOOP;
   -- Enable EBR editions to users
   IF ial_enabled_ = 'N' THEN
      Run_Ddl('ALTER USER ' || ial_owner_ || ' ENABLE EDITIONS');
   END IF;
   IF ao_enabled_ = 'N' THEN
      Run_Ddl('ALTER USER ' || app_owner_ || ' ENABLE EDITIONS');
   END IF;
END EnableEditionsToUser;

BEGIN
   EnableEditionsToUser('&APPLICATION_OWNER', '&IAL_OWNER');
END;
/