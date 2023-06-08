-----------------------------------------------------------------------------
--
--  Logical unit: ReportSchema
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  050405  DOZE  Created (F1PR466)
--  120215  LAKRLK RDTERUNTIME - 184
--  140129  AsiWLK   Merged LCS-111925
--  190930  PABNLK  TSMI-6: 'Get_Schema' method implemented.
--  191002  PABNLK  TSMI-6: 'Write_Report_Schema' wrapper method created.
--  200218  CHAALK  Modifications to remove sta jar useage 
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Write_Schema__ (
   objversion_ IN OUT VARCHAR2,
   rowid_      IN ROWID,
   lob_loc_    IN BLOB )
IS
BEGIN
   super(objversion_, rowid_, lob_loc_);
   UPDATE REPORT_SCHEMA_TAB
   SET schema_version = schema_version + 1
   WHERE rowid = rowid_;
END Write_Schema__;


PROCEDURE Get_Schema__ (
   objid_      OUT VARCHAR2,
   objversion_ OUT VARCHAR2,
   report_id_  IN VARCHAR2 ) 
IS
BEGIN
   IF Check_Exist___(report_id_) THEN
      Get_Id_Version_By_Keys___(objid_, objversion_, report_id_);
   ELSE
      INSERT
         INTO report_schema_tab (
            report_id,
            schema,
            schema_version,
            data_size,
            rowversion)
         VALUES (
            report_id_,
            empty_blob(),
            0,
            0,
            SYSDATE)
         RETURNING rowid, ltrim(lpad(to_char(rowversion,'YYYYMMDDHH24MISS'),2000)) INTO objid_, objversion_;
   END IF;
END Get_Schema__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
FUNCTION Get_Schema (
   report_id_ IN VARCHAR2) RETURN BLOB
IS
   temp_ report_schema_tab.schema%TYPE;
BEGIN
   IF (report_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT schema
      INTO  temp_
      FROM  report_schema_tab
      WHERE report_id = report_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(report_id_, 'Get_Schema');
END Get_Schema;

PROCEDURE Write_Report_Schema (
   objversion_ IN VARCHAR2,
   rowid_      IN ROWID,
   lob_loc_    IN BLOB )
IS
   new_objversion_   VARCHAR2(100);
BEGIN
   new_objversion_ := objversion_;
   Write_Schema__(new_objversion_, rowid_, lob_loc_);
END Write_Report_Schema;

PROCEDURE Remove_Schema_And_Layouts (
   report_id_       IN  VARCHAR2,
   layout_lists_    OUT VARCHAR2,
   ret_value_       OUT VARCHAR2) 
IS
   schema_count_    NUMBER;
   info_            VARCHAR2(2000);
   objid_           VARCHAR2(100);
   objversion_      VARCHAR2(100);   
   
   CURSOR schema_count IS
   SELECT count(report_id)
      INTO schema_count_
      FROM report_schema_tab
      WHERE UPPER(REPORT_ID) = UPPER(report_id_); 
      
   CURSOR get_layouts IS
   SELECT layout_name
      FROM report_layout_tab
      WHERE UPPER(REPORT_ID) = UPPER(report_id_); 
   
BEGIN
   OPEN schema_count;
   FETCH schema_count INTO schema_count_;
   CLOSE schema_count;
   
   IF (schema_count_ = 1) THEN
      -- first check layouts for the schema and remove them
      layout_lists_ := NULL;
      FOR rec_ IN get_layouts LOOP
         BEGIN 
            Report_Layout_API.Remove_Layout(report_id_, rec_.layout_name);
            layout_lists_ := layout_lists_ || rec_.layout_name || ',';
         EXCEPTION
            WHEN OTHERS THEN
            layout_lists_ := layout_lists_ || rec_.layout_name || '#ERROR#,';
         END;           
      END LOOP;
      -- then delete the schema
      BEGIN
         Get_Id_Version_By_Keys___ (objid_,objversion_,report_id_);
         Remove__(info_,objid_,objversion_,'DO');
         ret_value_ := 'SCHEMADELETED';
      EXCEPTION
         WHEN OTHERS THEN
            ret_value_ := 'SCHEMAERROR';
      END;
   ELSIF (schema_count_ = 0) THEN
      ret_value_ := 'SCHEMAZERO';
   ELSIF (schema_count_ > 1) THEN
      ret_value_ := 'SCHEMAMULTI';
   END IF;
END Remove_Schema_And_Layouts;

PROCEDURE Import_Schema (
   report_id_         IN  VARCHAR2,
   data_size_         IN  NUMBER,
   schema_            IN  BLOB,
   schema_version_    OUT NUMBER,
   ret_value_         OUT VARCHAR2) 
IS
   info_             VARCHAR2(2000);
   attr_             VARCHAR2(32000);
   objid_            VARCHAR2(100);
   objversion_       VARCHAR2(100);
   
   CURSOR schema_version IS
   SELECT schema_version
   INTO schema_version_
   FROM report_schema_tab
   WHERE UPPER(report_id) = UPPER(report_id_);
   
BEGIN
   IF (NOT Report_Schema_API.Exists(report_id_)) THEN
      New__ (info_, objid_, objversion_, attr_, 'PREPARE');
      schema_version_ := 0;
      Client_SYS.Add_To_Attr('REPORT_ID',report_id_,attr_);
      Client_SYS.Add_To_Attr('SCHEMA_VERSION',schema_version_,attr_);
      Client_SYS.Add_To_Attr('DATA_SIZE',data_size_,attr_);
      New__(info_, objid_, objversion_,attr_, 'DO');
      Write_Schema__(objversion_, objid_, schema_);
      ret_value_ := 'IMPORT';
   ELSE
      OPEN schema_version;
      FETCH schema_version INTO schema_version_;
      CLOSE schema_version;
      
      schema_version_ := schema_version_ + 1;
      Get_Id_Version_By_Keys___ (objid_,objversion_,report_id_);
      Client_SYS.Add_To_Attr('DATA_SIZE',data_size_,attr_);
      Modify__(info_, objid_, objversion_,attr_, 'DO');
      Write_Schema__(objversion_, objid_, schema_);         
      ret_value_ := 'MODIFY';
   END IF;
END Import_Schema;