---------------------------------------------------------------------
--
--  File: POST_MPCCOM_UpdateSiteTechnicalObjectReference.sql
--
--  Module        : MPCCOM
--
--  Purpose       : To redirect the object connections of LU site into CompanySite LU.
--
--
--  Date    Sign    History
--  ------  ----    -------------------------------------------------
--  201002  Asawlk  SC2020R1-9565, Retrieved valid services from Object_Connection_SYS.Enumerate_Services instead of the cursor.  
--  200903  Asawlk  SC2020R1-9565, Handled the scenario where site_service_list_ is NULL. 
--  200827  Asawlk  SC2020R1-9497, Modified the script in order to assign the company_site_service_list_ with actual 
--  200827          sevice names when site_service_list_ is defined as '*' in prior versions.   
--  140722  MeAblk  Bug 117925, Converted the records refer Site LU to refer CompanySite LU in object_connection_sys_tab
--  140722          before update the technical_object_reference_tab.
--  140718  MeAblk  Bug 117925, Created.
---------------------------------------------------------------------

SET SERVEROUTPUT ON
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_MPCCOM_UpdateSiteTechnicalObjectReference.sql','Timestamp_1');
PROMPT Updating lu_name AND key_ref IN TECHNICAL_OBJECT_REFERENCE_TAB FOR LU Site.

DECLARE
   new_key_ref_      VARCHAR2(600);
   new_key_value_    VARCHAR2(500);
   new_lu_name_      VARCHAR2(11) := 'CompanySite';
   contract_         VARCHAR2(5);

   site_view_name_            VARCHAR2(30);
   site_method_name_          VARCHAR2(30);
   site_service_list_         VARCHAR2(2000);
   site_package_name_         VARCHAR2(30);
   company_site_view_name_    VARCHAR2(30);
   company_site_package_name_ VARCHAR2(30);
   company_site_method_name_  VARCHAR2(30);
   company_site_service_list_ VARCHAR2(2000);
   services_tab_              Utility_SYS.String_table;

   CURSOR get_tech_obj_ref_rec IS
      SELECT lu_name, key_ref, t.rowid
      FROM   technical_object_reference_tab t
      WHERE  lu_name = 'Site';
   
BEGIN
   Object_Connection_SYS.Get_Configuration_Properties(site_view_name_, site_package_name_, site_method_name_, site_service_list_, 'Site');
   IF (site_view_name_ IS NOT NULL) THEN
      Object_Connection_Sys.Disable_Logical_Unit('Site');
      Object_Connection_SYS.Get_Configuration_Properties(company_site_view_name_, company_site_package_name_, company_site_method_name_, company_site_service_list_, 'CompanySite');
      IF (company_site_view_name_ IS NOT NULL) THEN
         IF ((instr(site_service_list_, 'TechnicalObjectReference') > 0) AND (instr(company_site_service_list_, 'TechnicalObjectReference') = 0)) THEN
            company_site_service_list_ := 'TechnicalObjectReference';
         END IF;
      ELSE
         company_site_service_list_ := site_service_list_;         
      END IF;      
      IF (INSTR(NVL(TRIM(company_site_service_list_), '*'), '*') > 0) THEN        
         services_tab_ := Object_Connection_SYS.Enumerate_Services();
         IF (services_tab_.COUNT > 0 ) THEN
            company_site_service_list_ := '';
            FOR i IN services_tab_.FIRST..services_tab_.LAST LOOP            
               company_site_service_list_ := company_site_service_list_ || services_tab_(i) || '^';
            END LOOP;
         END IF;
      END IF;      
      Object_Connection_Sys.Enable_Logical_Unit('CompanySite', company_site_service_list_,  'COMPANY_SITE',  'COMPANY_SITE_API', 'Get_Description');

      FOR rec_ IN get_tech_obj_ref_rec LOOP
         BEGIN
            contract_      := Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'CONTRACT');
            new_key_ref_   := Client_SYS.Get_Key_Reference(new_lu_name_,'CONTRACT',contract_);
            new_key_value_ := Object_Connection_SYS.Convert_To_Key_Value(new_lu_name_, new_key_ref_);

            UPDATE technical_object_reference_tab
               SET lu_name     = new_lu_name_,
                   key_ref     = new_key_ref_,
                   key_value   = new_key_value_
             WHERE ROWID = rec_.rowid;

         EXCEPTION
            WHEN dup_val_on_index THEN
               NULL;
         END;
      END LOOP;

      COMMIT;
   END IF;
END;
/
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_MPCCOM_UpdateSiteTechnicalObjectReference.sql','Timestamp_2');
PROMPT Done with updating lu_name AND key_ref IN TECHNICAL_OBJECT_REFERENCE_TAB FOR LU Site.
exec Database_SYS.Log_Detail_Time_Stamp('MPCCOM','POST_MPCCOM_UpdateSiteTechnicalObjectReference.sql','Done');
