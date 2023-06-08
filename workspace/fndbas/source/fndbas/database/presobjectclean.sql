SET SERVEROUTPUT ON
PROMPT Clean non installed PresObjectSecurity objects
BEGIN
      -- Handling of methods not deployed in the database
      DELETE FROM pres_object_security_tab
      WHERE sec_object_type = 'METHOD'
      AND NOT EXISTS (SELECT 1
                        FROM user_procedures u
                       WHERE Upper(Substr(sec_object, 1, instr(sec_object, '.') -1)) = u.object_name
                         AND Upper(Substr(sec_object, instr(sec_object, '.') +1)) = u.procedure_name);

      -- Handling of views not deployed in the database
      DELETE FROM pres_object_security_tab
      WHERE sec_object_type = 'VIEW'
      AND NOT EXISTS (SELECT 1
                        FROM user_views v
                        WHERE Upper(sec_object) = v.view_name);
END;
/
COMMIT;


