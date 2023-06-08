DECLARE
   -- Variables are overdimensioned to avoid runtime errors
   granted_           NUMBER;
   package_          VARCHAR2(50);
   method_           VARCHAR2(50);
   full_method_name_ VARCHAR(200);   
  
   -- Get the method name and PO id from batch_schedule_tab to iterate
   CURSOR get_batch_schedule_method IS 
      SELECT method_name, po_id
      FROM batch_schedule_method_tab;   
  
   -- Check whether the pkg is available to access
   CURSOR get_pkg(package_ VARCHAR2) IS
      SELECT 1
      FROM   security_sys_privs_tab
      WHERE  table_name = package_
      AND privilege = 'EXECUTE';  
     
   -- Make sure the access has not been revoked, if there is no entry coming from this cursor then no access to the method
   CURSOR get_method_grantee(package_ VARCHAR2, method_ VARCHAR2) IS  
      SELECT grantee
      FROM   security_sys_privs_tab
      WHERE  table_name = package_    
      MINUS
      SELECT role
      FROM   security_sys_tab
      WHERE  package_name = package_
      AND    method_name  = method_;
  
   -- Get the entry if there is an entry for the po_id and role, if so then it is already granted  
   CURSOR get_po(pres_object_id_ VARCHAR2, role_ VARCHAR2) IS
      SELECT 1
      FROM pres_object_grant_tab
      WHERE po_id = pres_object_id_
      AND role = role_;     
      
   -- Get package and method names   
   PROCEDURE get_pkg_and_method(full_method_name_ VARCHAR2, package_ OUT VARCHAR2, method_ OUT VARCHAR2) IS
      BEGIN        
        package_  := upper(substr(full_method_name_, 1, instr(full_method_name_, '.') - 1));
        method_   := initcap(substr(full_method_name_, instr(full_method_name_, '.') + 1));        
      EXCEPTION
        WHEN value_error THEN
            Dbms_Output.put_line('Error in method name or package name, ' || full_method_name_);	  
      END;
      
   -- Grant press object to the role   
   PROCEDURE grant_press_object(po_id_ VARCHAR2, grantee_ VARCHAR2, full_method_name_ VARCHAR2) IS
      BEGIN                   
        Pres_Object_Util_API.Grant_Pres_Object(po_id_, grantee_, 'FULL', 'TRUE', 'TRUE', 'TRUE', 'TRUE'); -- last param is raise_error_ default false   
      EXCEPTION
        WHEN OTHERS THEN
            Dbms_Output.put_line('Error in granting permissions of Press Object ' || po_id_ || ' for the method ' 
            || full_method_name_ || ' to role ' || grantee_ );	  
      END;
BEGIN
  
   FOR batch_rec IN get_batch_schedule_method LOOP     
      get_pkg_and_method(batch_rec.method_name, package_, method_);
     
      FOR pkg_rec IN get_pkg(package_) LOOP
         FOR grantee_rec IN get_method_grantee(package_, method_) LOOP  
         
            OPEN get_po(batch_rec.po_id, grantee_rec.grantee);
            FETCH get_po INTO granted_;
            IF get_po%NOTFOUND THEN   
               grant_press_object(batch_rec.po_id, grantee_rec.grantee, batch_rec.method_name);
            END IF;
            CLOSE get_po;
            
         END LOOP;   
      END LOOP;     
   END LOOP;
   COMMIT;
END;
