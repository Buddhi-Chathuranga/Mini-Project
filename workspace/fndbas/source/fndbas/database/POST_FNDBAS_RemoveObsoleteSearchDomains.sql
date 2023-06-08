--------------------------------------------------------------------------
--  File:      POST_FNDBAS_RemoveObsoleteSearchDomains.sql
--
--  Module:    FNDBAS
--
--  Purpose:   Remove all search domains since they are now depricated
--------------------------------------------------------------------------

SET SERVEROUTPUT ON

exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteSearchDomains.sql','Timestamp_1');
PROMPT Starting POST_FNDBAS_RemoveObsoleteSearchDomains

DECLARE 
   CURSOR search_domains IS
      SELECT search_domain, package_name
      FROM search_domain_runtime_tab;
   
   CURSOR triggers(package_name VARCHAR2) IS
      SELECT trigger_name
      FROM user_triggers 
      WHERE trigger_name LIKE package_name || '%';
   
   CURSOR get_indexes (table_name_ VARCHAR2, column_name_ VARCHAR2) IS
      SELECT c.index_name, i.index_type
      FROM user_ind_columns c, user_indexes i
      WHERE c.column_name = column_name_
      AND c.table_name = table_name_
      AND c.index_name = i.index_name;

   TYPE search_domains_type IS TABLE OF search_domains%ROWTYPE INDEX BY BINARY_INTEGER;
   
   search_domain_array_    search_domains_type;
   search_domain_rec_      search_domains%ROWTYPE;
   table_                  VARCHAR2(1000);
   index_column_           VARCHAR2(1000); 
   column_                 Installation_SYS.ColRec;
                        
   FUNCTION Get_Package_Meta (package_name IN VARCHAR2, search_string VARCHAR2) RETURN VARCHAR2 IS
      meta_ VARCHAR2(1000);
   BEGIN       
      SELECT SUBSTR(text, INSTR(text, '''') + 1, INSTR(text, '''', -1) - INSTR(text, '''') -1)
      INTO meta_
      FROM user_source
      WHERE NAME = package_name
      AND TYPE = 'PACKAGE BODY'
      AND LINE = 3 + (SELECT line 
                      FROM user_source 
                      WHERE NAME = package_name 
                      AND TYPE = 'PACKAGE BODY' 
                      AND TEXT LIKE search_string);
       
      RETURN meta_;
   EXCEPTION
      WHEN OTHERS THEN 
         RETURN NULL;
   END Get_Package_Meta; 
    
BEGIN
   OPEN search_domains;
   FETCH search_domains BULK COLLECT INTO search_domain_array_;
   CLOSE search_domains;      
      
   FOR i IN nvl(search_domain_array_.FIRST, 0) .. nvl(search_domain_array_.LAST, -1) LOOP
      
      search_domain_rec_ := search_domain_array_(i);
      
      table_        := Get_Package_Meta(search_domain_rec_.package_name, 'FUNCTION Get_Table_Name RETURN VARCHAR2%');
      index_column_ := Get_Package_Meta(search_domain_rec_.package_name, 'FUNCTION Get_Index_Column_Name RETURN VARCHAR2%');                 
      
      IF table_ IS NULL OR index_column_ IS NULL THEN
         Dbms_Output.Put_Line('ERROR: Removal of search domain ' || search_domain_rec_.search_domain || ' failed!');
         CONTINUE;
      END IF;

      FOR trigger_rec IN triggers(search_domain_rec_.package_name) LOOP
         Installation_SYS.Remove_Trigger(trigger_rec.trigger_name);        
      END LOOP;
      
      FOR ix IN get_indexes(table_, index_column_) LOOP
         IF ix.index_type = 'DOMAIN' THEN
            EXECUTE IMMEDIATE 'DROP INDEX ' || ix.index_name || ' FORCE';
         ELSE
            Installation_SYS.Remove_Indexes(table_, ix.index_name);
         END IF;
      END LOOP;

      BEGIN
         Ctx_Ddl.Drop_Preference(search_domain_rec_.search_domain);
      EXCEPTION
         WHEN OTHERS THEN NULL;
      END;

      Installation_SYS.Remove_Package(search_domain_rec_.package_name);

      column_ := Installation_SYS.Set_Column_Values(index_column_);
      Installation_SYS.Alter_Table_Column(table_, 'DROP', column_, TRUE);    
      
      DELETE FROM search_domain_runtime_tab WHERE search_domain = search_domain_rec_.search_domain;
      DELETE FROM search_domain_document_tab WHERE search_domain = search_domain_rec_.search_domain;
      DELETE FROM search_domain_group_member_tab WHERE search_domain = search_domain_rec_.search_domain;
      COMMIT;
      
   END LOOP;            


   BEGIN
      Ctx_Ddl.Drop_Section_Group('APPLICATION_SEARCH');
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   BEGIN
      Ctx_Ddl.Drop_Preference('APPLICATION_SEARCH_LEXER');
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;

   BEGIN
      Ctx_Ddl.Drop_Preference('APPLICATION_SEARCH_STORAGE');
   EXCEPTION
      WHEN OTHERS THEN NULL;
   END;      

END;
/


BEGIN   
   -- Make sure General_SYS is not invalidated, otherwise the first
   -- call to Batch_Queue_Method_API.Remove_method__ will fail.
   EXECUTE IMMEDIATE ('ALTER PACKAGE GENERAL_SYS COMPILE');
   General_SYS.Init;
EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/


DECLARE    
   CURSOR batch_schedules IS 
      SELECT bc.schedule_id
      FROM batch_schedule_tab bc, batch_schedule_method_tab bcm
      WHERE bc.schedule_method_id = bcm.schedule_method_id
      AND bcm.method_name IN ('APPLICATION_SEARCH_SYS.ENABLE_SEARCH_DOMAIN__',
                              'APPLICATION_SEARCH_SYS.OPTIMIZE_INDEX__',
                              'APPLICATION_SEARCH_SYS.REBUILD_INDEX__',
                              'APPLICATION_SEARCH_SYS.SYNC_INDEX__');
          
BEGIN      
      
   -- Remove search domain background jobs
   Batch_Queue_Method_API.Remove_Method__('Application_Search_Sys.Create_Text_Index__');
   Batch_Queue_Method_API.Remove_Method__('Application_Search_Sys.Enable_Search_Domain__');
   Batch_Queue_Method_API.Remove_Method__('Application_Search_Sys.Optimize_Index__');
   Batch_Queue_Method_API.Remove_Method__('Application_Search_Sys.Rebuild_Index__');
   Batch_Queue_Method_API.Remove_Method__('Application_Search_Sys.Sync_Index__');
 
   FOR rec IN batch_schedules LOOP
      Batch_Schedule_API.Remove_(rec.schedule_id);
   END LOOP;

   Batch_Schedule_Method_API.Remove_Method__('APPLICATION_SEARCH_SYS.ENABLE_SEARCH_DOMAIN__');
   Batch_Schedule_Method_API.Remove_Method__('APPLICATION_SEARCH_SYS.OPTIMIZE_INDEX__');
   Batch_Schedule_Method_API.Remove_Method__('APPLICATION_SEARCH_SYS.REBUILD_INDEX__');
   Batch_Schedule_Method_API.Remove_Method__('APPLICATION_SEARCH_SYS.SYNC_INDEX__');

EXCEPTION
   WHEN OTHERS THEN NULL;
END;
/


BEGIN 
   Installation_SYS.Remove_Package('APPLICATION_SEARCH_ADMIN_SYS');
   Installation_SYS.Remove_Package('APPLICATION_SEARCH_INDEX_SYS');
   Installation_SYS.Remove_Package('APPLICATION_SEARCH_RUNTIME_SYS'); 
   Installation_SYS.Remove_Package('APPLICATION_SEARCH_SYS');   
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_DOCUMENT_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_GROUP_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_GROUP_MEMBER_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_RUNTIME_API');
   Installation_SYS.Remove_Package('SEARCH_DOMAIN_UNSYNCHED_API');
   
   
   Installation_SYS.Remove_View('SEARCH_DOMAIN_DOCUMENT');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_GROUP');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_GROUP_MEMBER');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_RUNTIME');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_UNSYNCHED');      
   Installation_SYS.Remove_View('SEARCH_DOMAIN_PENDING_DOCUMENT');
   Installation_SYS.Remove_View('SEARCH_DOMAIN_ERRORS');
   Installation_SYS.Remove_View('AVAILABLE_SEARCH_DOMAINS');
      
   
   Installation_SYS.Remove_Type('SEARCH_DOMAIN_STATE_TYPE');
   Installation_SYS.Remove_Type('SEARCH_DOMAIN_STATES_TYPE');
   Installation_SYS.Remove_Type('SEARCH_DOMAIN_QUERY_TYPE');
   Installation_SYS.Remove_Type('SEARCH_DOMAIN_QUERIES_TYPE');
   Installation_SYS.Remove_Type('AVAILABLE_SEARCH_DOMAIN_TYPE');
   Installation_SYS.Remove_Type('AVAILABLE_SEARCH_DOMAINS_TYPE');   
END;
/


BEGIN
   Installation_SYS.Rename_Table('SEARCH_DOMAIN_DOCUMENT_TAB', 'SEARCH_DOMAIN_DOCUMENT_2110');
   Installation_SYS.Rename_Table('SEARCH_DOMAIN_GROUP_MEMBER_TAB', 'SEARCH_DOMAIN_GROUP_MEMBER_2110');
   Installation_SYS.Rename_Table('SEARCH_DOMAIN_GROUP_TAB', 'SEARCH_DOMAIN_GROUP_2110');
   Installation_SYS.Rename_Table('SEARCH_DOMAIN_RUNTIME_TAB', 'SEARCH_DOMAIN_RUNTIME_2110');
   Installation_SYS.Rename_Table('SEARCH_DOMAIN_UNSYNCHED_TAB', 'SEARCH_DOMAIN_UNSYNCHED_2110');
END;
/


PROMPT Finished with POST_FNDBAS_RemoveObsoleteSearchDomains
exec Installation_SYS.Log_Detail_Time_Stamp('FNDBAS','POST_FNDBAS_RemoveObsoleteSearchDomains.sql','Done');
