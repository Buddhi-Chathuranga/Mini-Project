-----------------------------------------------------------------------------
--
--  Logical unit: LanguageFileImport
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
PROCEDURE Import_Trans_Files (
   file_name_  IN VARCHAR2,
   file_date_  IN DATE,
   task_id_    IN VARCHAR2,
   file_       IN CLOB ) 
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   
BEGIN
   New__ (info_, objid_, objversion_, attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('FILE_NAME',file_name_,attr_);
   Client_SYS.Add_To_Attr('FILE_DATE',file_date_,attr_);
   Client_SYS.Add_To_Attr('TASK_ID',task_id_,attr_);
   Client_SYS.Add_To_Attr('PROCESSED','0',attr_);
   New__(info_, objid_, objversion_,attr_, 'DO');

   Write_Import_File__(objversion_, objid_, file_);

END Import_Trans_Files;

PROCEDURE Import_Trans_Files (
   file_name_  IN VARCHAR2,
   file_date_  IN VARCHAR2,
   task_id_    IN VARCHAR2,
   file_       IN CLOB ) 
IS
BEGIN
   Import_Trans_Files(file_name_, TO_DATE(file_date_, 'MM/dd/yyyy HH24:MI:SS'), task_id_, file_ );
END Import_Trans_Files;

FUNCTION Import_Clob_Files (
   file_       IN CLOB,
   file_name_  IN VARCHAR2) RETURN CLOB
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   
   file_id_          VARCHAR2(100) := sys_guid(); 
   context_count_    NUMBER;
   attribute_count_  NUMBER;
   file_extension_   VARCHAR2(10);
   
BEGIN
   
   file_extension_ := upper(substr(file_name_,length(file_name_)-3));
   IF (file_extension_ NOT IN ('.LNG','.TRS')) THEN
      Error_SYS.Appl_General(lu_name_, 'NOTSUPPORTEDFILEEXT: File extension :P1 not supported !', file_extension_);      
   END IF;
   
   New__ (info_, objid_, objversion_, attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('FILE_ID',file_id_,attr_);
   Client_SYS.Add_To_Attr('FILE_NAME',file_name_,attr_);
   Client_SYS.Add_To_Attr('FILE_DATE',sysdate,attr_);
   Client_SYS.Add_To_Attr('PROCESSED','0',attr_);
   New__(info_, objid_, objversion_,attr_, 'DO');

   Write_Import_File__(objversion_, objid_, file_);

   IF (file_extension_ = '.LNG') THEN
     LANGUAGE_SYS.Bulk_Import_Lng_(context_count_, attribute_count_, file_id_);
   ELSIF (file_extension_ = '.TRS') THEN
     LANGUAGE_SYS.Bulk_Import_Trs_(context_count_, attribute_count_, file_id_);
   END IF;

   RETURN (to_char(context_count_)||Client_SYS.field_separator_||to_char(attribute_count_));

END Import_Clob_Files;

FUNCTION Bulk_Import_Clob_Batch_(
   file_          IN CLOB,
   file_name_     IN VARCHAR2, 
   task_id_       IN VARCHAR2) RETURN CLOB
IS
   info_           VARCHAR2(2000);
   attr_           VARCHAR2(32000);
   objid_          VARCHAR2(100);
   objversion_     VARCHAR2(100);
   
   gen_task_id_    VARCHAR2(50);
   
BEGIN
   
   IF (task_id_ = '-1') THEN
      gen_task_id_ := sys_guid();
   ELSE
      gen_task_id_ := task_id_;
   END IF;
   New__ (info_, objid_, objversion_, attr_, 'PREPARE');
   Client_SYS.Add_To_Attr('FILE_NAME',file_name_,attr_);
   Client_SYS.Add_To_Attr('FILE_DATE',sysdate,attr_);
   Client_SYS.Add_To_Attr('TASK_ID',gen_task_id_,attr_);
   Client_SYS.Add_To_Attr('PROCESSED','0',attr_);
   New__(info_, objid_, objversion_,attr_, 'DO');

   Write_Import_File__(objversion_, objid_, file_);
   
   RETURN gen_task_id_;
   
END Bulk_Import_Clob_Batch_; 

FUNCTION Bulk_Import_Clob_Batch_Execute(
   task_id_       IN VARCHAR2,
   refresh_cache_ IN VARCHAR2 DEFAULT '') RETURN NUMBER
IS
   job_id_ NUMBER;
   
BEGIN
   
   IF (refresh_cache_ IN ('TRUE','FALSE')) THEN
     LANGUAGE_SYS.Bulk_Import_Batch_With_Job_Id_(job_id_,task_id_,refresh_cache_);
   END IF;
   
   RETURN job_id_;
   
END Bulk_Import_Clob_Batch_Execute; 

PROCEDURE Check_File_Date (
   status_     OUT VARCHAR2,
   file_name_  IN VARCHAR2,
   file_date_  IN DATE ) 
IS
   old_file_date_ DATE;

   CURSOR Get_File_Date_ (module_ VARCHAR2, file_name_ VARCHAR2) IS
   SELECT max(file_date)
   FROM  language_source_tab
   WHERE module = upper(module_)
   AND   upper(name) = upper(file_name_);
   
BEGIN
   OPEN Get_File_Date_(substr(file_name_,1,instr(file_name_,'_')-1),file_name_);
   FETCH Get_File_Date_ INTO old_file_date_;
   CLOSE Get_File_Date_;
   IF (old_file_date_ IS NULL OR old_file_date_ < file_date_) THEN
      status_ := '1';
   ELSE
      status_ := '0';
   END IF;
END Check_File_Date;
-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT language_file_import_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(2000);
BEGIN
   newrec_.created_by   := Fnd_Session_API.Get_Fnd_User;
   newrec_.created_date := sysdate;
   newrec_.task_id := NVL(newrec_.task_id, sys_guid());     
   newrec_.file_id := NVL(newrec_.file_id, sys_guid());     
   super(newrec_, indrec_, attr_);
   Client_SYS.Add_To_Attr('FILE_ID', newrec_.file_id, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------


