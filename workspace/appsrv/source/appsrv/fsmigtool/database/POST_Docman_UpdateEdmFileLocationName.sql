-----------------------------------------------------------------------------
--  Module : APPSRV
--
--  File   : POST_Docman_UpdateEdmFileLocationName.sql
--
--  IFS Developer Studio Template Version 2.6
--
--  Date     Sign    History
--  ------   ------  --------------------------------------------------
--  211103   deeklk  Created.
-----------------------------------------------------------------------------
--  NOTE: This script is only for the use during the post upgrade phase. 
--        This is to update the location name of edm file after migrating  
--        document files using File Storage Migration Tool.
-----------------------------------------------------------------------------

SET SERVEROUTPUT ON

DEFINE message1 = 'Enter the Document Class...'
DEFINE message2 = 'Enter the Location Name...'
DEFINE message3 = 'Updating LOCATION_NAME attribute for succesfully migrated Documents.'

EXEC Installation_SYS.Log_Detail_Time_Stamp('DOCMAN','POST_Docman_UpdateEdmFileLocationName.sql','Timestamp_1');

ACCEPT docclass PROMPT '&message1' ;
ACCEPT locationname PROMPT '&message2' ;

PROMPT &message3

DECLARE
   CURSOR get_migrated_keyrefs IS
      SELECT key_ref
      FROM fs_mig_status_tab
      WHERE status = 'Done'
      AND lu_name = 'EdmFileStorage';
   
   doc_class_  edm_file_tab.doc_class%TYPE;
   doc_no_     edm_file_tab.doc_no%TYPE;
   doc_sheet_  edm_file_tab.doc_sheet%TYPE;
   doc_rev_    edm_file_tab.doc_rev%TYPE;
   doc_type_   edm_file_tab.doc_type%TYPE;
   file_no_    edm_file_tab.file_no%TYPE;
   
   PROCEDURE Update_Location___ 
   (doc_class_ IN VARCHAR2,
   doc_no_    IN VARCHAR2,
   doc_sheet_ IN VARCHAR2,
   doc_rev_   IN VARCHAR2,
   doc_type_  IN VARCHAR2,
   file_no_   IN NUMBER)
   IS
   BEGIN
      UPDATE edm_file_tab e
      SET e.location_name = '&locationname'
      WHERE e.doc_class = doc_class_
      AND e.doc_no = doc_no_
      AND e.doc_sheet = doc_sheet_
      AND e.doc_rev = doc_rev_
      AND e.doc_type = doc_type_
      AND e.file_no = file_no_;
   END Update_Location___;
   
BEGIN
   Doc_Class_API.Exist('&docclass');
   Edm_Location_API.Exist('&locationname');
   
   FOR rec_ IN get_migrated_keyrefs LOOP
      doc_class_  :=           Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'DOC_CLASS');
      IF doc_class_ IS NOT NULL AND doc_class_ = '&docclass' THEN
         doc_no_     :=           Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'DOC_NO');
         doc_sheet_  :=           Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'DOC_SHEET');
         doc_rev_    :=           Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'DOC_REV');
         doc_type_   :=           Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'DOC_TYPE');
         file_no_    := TO_NUMBER(Client_SYS.Get_Key_Reference_Value(rec_.key_ref, 'FILE_NO'));
         
         Update_Location___(doc_class_, doc_no_,doc_sheet_,doc_rev_, doc_type_,file_no_    );
         COMMIT;
      END IF;
      
   END LOOP;
   COMMIT;
END;
/

EXEC Installation_SYS.Log_Detail_Time_Stamp('DOCMAN','POST_Docman_UpdateEdmFileLocationName.sql','Done');

