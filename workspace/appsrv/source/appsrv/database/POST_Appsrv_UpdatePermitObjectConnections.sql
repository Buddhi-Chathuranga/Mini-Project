-----------------------------------------------------------------------------
--  Module : APPSRV
--
--  File   : POST_Appsrv_UpdatePermitObjectConnections.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  200521   ruanlk  Bug 153674, Upadte key_ref values in permit 
--  ------   ------  --------------------------------------------------


SET SERVEROUTPUT ON 

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdatePermitObjectConnections.sql','Timestamp_1');
PROMPT Updating the Object Connections for 'Permit'

BEGIN
   IF (Database_SYS.Table_Exist('PERMIT_TAB')) THEN
         DECLARE
            new_key_ref_   VARCHAR2(500);
            new_key_value_ VARCHAR2(500);
   
   
            CURSOR get_media_library IS
               SELECT * FROM media_library_tab
                  WHERE lu_name  = 'Permit'
                     AND INSTR(key_ref, 'KEY_REF') <> 0;
            
            CURSOR get_technical_object_reference IS
               SELECT * FROM technical_object_reference_tab
                  WHERE lu_name  = 'Permit'
                     AND INSTR(key_ref, 'KEY_REF') <> 0;
           
   FUNCTION Get_New_Values(new_key_ref2_   OUT VARCHAR2,
                           new_key_value2_ OUT VARCHAR2,
                           lu_name_        IN VARCHAR2,
                           key_ref_        IN VARCHAR2) RETURN BOOLEAN
   IS
      permit_seq_            NUMBER;

   BEGIN
      permit_seq_            := TO_NUMBER(Client_SYS.Get_Key_Reference_Value(key_ref_, 'PERMIT_SEQ'));
    
      IF (permit_seq_ IS NOT NULL) THEN
         new_key_ref2_     := Client_SYS.Get_Key_Reference(lu_name_, 'PERMIT_SEQ', permit_seq_);
         new_key_value2_   := Object_Connection_SYS.Convert_To_Key_Value(lu_name_, new_key_ref2_);
         IF (new_key_ref2_ IS NULL OR new_key_value2_ IS NULL) THEN
            RETURN FALSE;
         ELSE
           RETURN TRUE;
         END IF;
      ELSE
         RETURN FALSE;
      END IF;
   END Get_New_Values;        

BEGIN
     
   FOR rec_ IN get_media_library LOOP
      IF Get_New_Values(new_key_ref_, new_key_value_, rec_.lu_name, rec_.key_ref) THEN
         UPDATE media_library_tab SET key_ref = new_key_ref_
         WHERE library_id = rec_.library_id;
      ELSE 
         DELETE media_library_tab t                              
         WHERE library_id = rec_.library_id;
      END IF;
   END LOOP;
   COMMIT;

   
   FOR rec_ IN get_technical_object_reference LOOP
      IF Get_New_Values(new_key_ref_, new_key_value_, rec_.lu_name, rec_.key_ref) THEN
         UPDATE technical_object_reference_tab SET key_ref = new_key_ref_, KEY_VALUE = new_key_value_
         WHERE technical_spec_no = rec_.technical_spec_no;
      ELSE 
         DELETE technical_object_reference_tab t                              
         WHERE technical_spec_no = rec_.technical_spec_no;
      END IF;
   END LOOP;
   COMMIT;
  
END;
   END IF;   
END;
/

EXEC Database_SYS.Log_Detail_Time_Stamp('APPSRV','POST_Appsrv_UpdatePermitObjectConnections.sql','Done');

PROMPT Finished POST_Appsrv_UpdatePermitObjectConnections.sql
