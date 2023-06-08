-----------------------------------------------------------------------------
--
--  Logical unit: FndBranding
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

SCOPE_ID CONSTANT VARCHAR2(10) := 'SCOPE:';

EXPORT_DEF_VERSION         CONSTANT VARCHAR2(5) := '1.0';
XMLTAG_APPEARANCE_CONFIG   CONSTANT VARCHAR2(50)  := 'APPEARANCE_CONFIG';
XMLTAG_CUST_OBJ_EXP        CONSTANT VARCHAR2(50)  := 'CUSTOM_OBJECT';
XMLTAG_PATH                CONSTANT VARCHAR2(100) := '/' || XMLTAG_CUST_OBJ_EXP || '/' || XMLTAG_APPEARANCE_CONFIG;
XMLTAG_CUST_OBJ_EXP_DEF_VER CONSTANT VARCHAR2(50)  := 'EXPORT_DEF_VERSION';
XMLTAG_BRANDING_PROPERTY   CONSTANT VARCHAR2(50)  := 'BRANDING_PROPERTY';

CURSOR get_configuration(xml_ Xmltype) IS
   SELECT xt1.*
     FROM dual,
          xmltable(XMLTAG_PATH passing xml_
                         COLUMNS
                            EXPORT_DEF_VERSION VARCHAR2(30) path '@EXPORT_DEF_VERSION',
                            CODE   VARCHAR2(200) path 'CODE',
                            NAME      VARCHAR2(4000) path 'NAME',
                            DESCRIPTION  VARCHAR2(4000) path 'DESCRIPTION',
                            CONTEXT_DB      VARCHAR2(4000) path 'CONTEXT_DB',
                            CONTEXT_EXPRESSION  VARCHAR2(4000) path 'CONTEXT_EXPRESSION',
                            NOTES  VARCHAR2(4000) path 'NOTES',
                            DEFINITION_MODIFIED_DATE VARCHAR2(50) path 'DEFINITION_MODIFIED_DATE',
                            OBJKEY VARCHAR2(100) path 'ROWKEY'
                        ) xt1;
                        
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('CODE', BRANDING_ID.NEXTVAL, attr_ );
   Client_SYS.Add_To_Attr('STATE', 'Unpublished', attr_ );
   Client_SYS.Add_To_Attr('ENABLE_B2_B', 1, attr_);
   Client_SYS.Add_To_Attr('ENABLE_B2_E', 1, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT NOCOPY fnd_branding_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   IF(newrec_.context = 'GLOBAL') THEN
      newrec_.context_expression := 'CONTEXT_FULL';
   END IF; 
   Set_Server_Values___(newrec_);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN Fnd_Branding_Tab%ROWTYPE )
IS
BEGIN
   Check_Package___(remrec_);
   super(remrec_);
END Check_Delete___;

PROCEDURE Check_Package___ (
   remrec_ IN     Fnd_Branding_Tab%ROWTYPE )
IS
   package_name_ VARCHAR2(100);
BEGIN
   package_name_ := App_Config_Package_API.Get_Item_Package_Name(remrec_.rowkey);
   IF (package_name_ IS NOT NULL) THEN
      Error_Sys.Record_General(lu_name_,'ITEM_CONNECTED_TO_PKG: Appearance Configuration cannot be deleted, unless removed from the package ":P1".', package_name_);
   END IF;   
END Check_Package___;   

FUNCTION Get_Export_SQL_Statement___ (
   code_ IN VARCHAR2) RETURN VARCHAR2
IS
   stmt_        VARCHAR2(32000);
   date_format_ VARCHAR2(30) := Client_SYS.date_format_;
BEGIN
   stmt_ := 'SELECT '||EXPORT_DEF_VERSION||' "@'||XMLTAG_CUST_OBJ_EXP_DEF_VER||'",
                       t.code, 
                       t.name,
                       t.description,
                       t.context_db,
                       t.context_expression,
                       t.notes,
                       t.objkey rowkey,
                       to_char(t.definition_modified_date ,'''||date_format_||''') definition_modified_date,
                       CURSOR(SELECT 
                              a.code,
                              a.property,
                              a.theme_db,
                              a.value,
                              a.objkey rowkey
                       FROM fnd_branding_property a 
                       WHERE a.code = '''||code_||''') '||XMLTAG_BRANDING_PROPERTY||'
               FROM fnd_branding t
               WHERE code = '''||code_||'''
               ';
   RETURN stmt_;
END Get_Export_SQL_Statement___;

PROCEDURE Import_New___ (
   newrec_ IN OUT fnd_branding_tab%ROWTYPE )
IS
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   emptyrec_      fnd_branding_tab%ROWTYPE;
BEGIN
   indrec_ := Get_Indicator_Rec___(emptyrec_, newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   Set_Server_Values___(newrec_);
   newrec_.rowversion := sysdate;
   IF newrec_.rowkey IS NULL THEN
      newrec_.rowkey := sys_guid();
   END IF; 
   INSERT INTO fnd_branding_tab VALUES newrec_;
EXCEPTION
   WHEN dup_val_on_index THEN
         DECLARE
            constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
         BEGIN
            IF (constraint_ = 'FND_BRANDING_RK') THEN
               Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
            ELSIF (constraint_ = 'FND_BRANDING_PK') THEN
               Raise_Record_Exist___(newrec_);
            ELSE
               Raise_Constraint_Violated___(newrec_, constraint_);
            END IF;
         END;
END Import_New___;

PROCEDURE Import_Modify___ (
   newrec_ IN OUT fnd_branding_tab%ROWTYPE )
IS
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   oldrec_        fnd_branding_tab%ROWTYPE;
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
BEGIN
   oldrec_ := Lock_By_Keys_Nowait___(newrec_.code);
   indrec_ := Get_Indicator_Rec___(oldrec_, newrec_);
   Check_Update___(oldrec_, newrec_, indrec_, attr_);
--   Set_Server_Values___(newrec_);
   Update___(objid_, oldrec_, newrec_, attr_, objversion_, TRUE);
--   newrec_.rowversion := sysdate;
--   UPDATE fnd_branding_tab SET ROW = newrec_ WHERE code = newrec_.code;
END Import_Modify___;
      
PROCEDURE Set_Server_Values___ (
   newrec_ IN OUT fnd_branding_tab%ROWTYPE)
IS
BEGIN
   IF newrec_.definition_modified_date IS NULL THEN
      newrec_.definition_modified_date := sysdate;
   END IF;   
END Set_Server_Values___;

PROCEDURE Set_Definition_Modified_Date_If_Null___ (
   code_ IN VARCHAR2)
IS
   definition_modified_date_  fnd_branding_tab.definition_modified_date%TYPE;
BEGIN
   SELECT definition_modified_date INTO definition_modified_date_
      FROM fnd_branding_tab WHERE code = code_;
      
   IF (definition_modified_date_ IS NULL) THEN 
      UPDATE fnd_branding_tab
         SET definition_modified_date = rowversion
         WHERE code = code_;
   END IF;   
END Set_Definition_Modified_Date_If_Null___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   attr_       IN OUT NOCOPY VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   IF action_ = 'DO' THEN
      Client_SYS.Add_To_Attr('DEFINITION_MODIFIED_DATE', sysdate, attr_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
END Modify__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Global_Code 
   RETURN VARCHAR2
IS
   code_ fnd_branding_tab.code%TYPE;
BEGIN
      SELECT code
         INTO  code_
         FROM  fnd_branding_tab
         WHERE context = 'GLOBAL' AND state = 'PUBLISHED' AND rownum = 1;
   RETURN code_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Global_Code;


FUNCTION Check_Valid (
   code_ IN VARCHAR2,
   app_type_ IN VARCHAR2) RETURN BOOLEAN
IS
   record_ fnd_branding_tab%ROWTYPE;
   
BEGIN
   SELECT * INTO  record_
      FROM  fnd_branding_tab
      WHERE code = code_;
   
   IF (record_.state = 'PUBLISHED') THEN
      RETURN TRUE;
      --  --  We will ignore b2b and b2e options for now
      --      IF (app_type_ = 'B2B' AND record_.enable_b2_b = 1) THEN
      --         RETURN TRUE;
      --      END IF;
      --      IF (app_type_ = 'B2E' AND record_.enable_b2_e = 1) THEN
      --            RETURN TRUE;
      --      END IF;
   END IF;
   RETURN FALSE;
   
EXCEPTION
   WHEN no_data_found THEN
      RETURN FALSE;
END Check_Valid;


PROCEDURE Duplicate_Branding (
   original_branding_ IN VARCHAR2,
   duplicated_branding_ IN VARCHAR2)
IS   
   CURSOR original_properties IS
   SELECT code, property, theme, theme_db, value
   FROM FND_BRANDING_PROPERTY
   WHERE code = original_branding_;
   
   info_       VARCHAR2(32000);
   objid_      VARCHAR2(20);
   objversion_ VARCHAR2(100);
   attr_       VARCHAR2(32000);
BEGIN   
FOR rec_ in original_properties
   LOOP
      Client_SYS.Add_To_Attr('CODE', duplicated_branding_, attr_);
      Client_SYS.Add_To_Attr('PROPERTY', rec_.property, attr_);
      Client_SYS.Add_To_Attr('THEME', rec_.theme, attr_);
      Client_SYS.Add_To_Attr('THEME_DB', rec_.theme_db, attr_);
      Client_SYS.Add_To_Attr('VALUE', rec_.value, attr_);
      Fnd_Branding_Property_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Duplicate_Branding;

PROCEDURE Export_XML (
   out_xml_ OUT CLOB,
   code_    IN  VARCHAR2)
IS
   stmt_ VARCHAR2(32000);
   ctx_    dbms_xmlgen.ctxHandle;
   xml_     XMLType;
   objkey_  VARCHAR2(100);
   item_type_  VARCHAR2(50) := App_Config_Item_Type_API.DB_APPEARANCE_CONFIG;
BEGIN
   stmt_ := Get_Export_SQL_Statement___(code_);
   Set_Definition_Modified_Date_If_Null___(code_);
   
   Log_SYS.App_Trace(Log_SYS.debug_, 'XML Export Statement: '|| stmt_);
   Fnd_Branding_API.Exist(code_);
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_CUST_OBJ_EXP);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_APPEARANCE_CONFIG);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   
   objkey_ := Fnd_Branding_API.Get_Objkey(code_);
   
   Utility_SYS.Add_Xml_Element_Before(xml_, 'NAME', 
                                      App_Config_Util_API.Get_Item_Name(objkey_, item_type_),
                                      XMLTAG_PATH);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TYPE', 
                                      item_type_,
                                      XMLTAG_PATH);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'DESCRIPTION', 
                                      App_Config_Util_API.Get_Item_Description(objkey_, item_type_),
                                      XMLTAG_PATH);
                                      
   Utility_SYS.XmlType_To_CLOB(out_xml_, xml_);
   
END Export_XML;

PROCEDURE Import(
   configuration_item_id_ OUT VARCHAR2,
   name_                  OUT VARCHAR2,
   identical_             OUT BOOLEAN,
   in_xml_                IN  CLOB)
IS
   xml_ Xmltype := Xmltype(in_xml_);
   new_rec_ fnd_branding_tab%ROWTYPE;
   objkey_  VARCHAR2(100);
   new_property_rec_ fnd_branding_property_tab%ROWTYPE;
BEGIN
   identical_ := FALSE;
   FOR rec_ IN get_configuration(xml_) LOOP
      objkey_ := Get_Objkey(rec_.code );
      IF objkey_ IS NULL THEN
         Prepare_New___(new_rec_);
         new_rec_.code := rec_.code;
         new_rec_.name := rec_.name;
         new_rec_.description := rec_.description;
         new_rec_.context := rec_.context_db;
         new_rec_.context_expression := rec_.context_expression;
         new_rec_.notes := rec_.notes;
         new_rec_.state := 'UNPUBLISHED';
         new_rec_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         new_rec_.rowkey := rec_.objkey;
         Import_New___(new_rec_);
         Fnd_Branding_Property_Api.Remove_All(rec_.code);
         Fnd_Branding_Property_Api.Import(xml_, rec_.code);
      ELSE
         IF objkey_ = rec_.objkey THEN
            new_rec_ := Lock_By_Keys_Nowait___(rec_.code);
            IF (new_rec_.definition_modified_date <> to_date(rec_.definition_modified_date, Client_SYS.date_format_)) THEN 
               new_rec_.name := rec_.name;
               new_rec_.description := rec_.description;
               new_rec_.context := rec_.context_db;
               new_rec_.context_expression := rec_.context_expression;
               new_rec_.notes := rec_.notes;
               new_rec_.state := 'UNPUBLISHED';
               new_rec_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
               Import_Modify___(new_rec_);
               Fnd_Branding_Property_Api.Remove_All(rec_.code);
               Fnd_Branding_Property_Api.Import(xml_, rec_.code);  
            ELSE
               identical_ := TRUE;
            END IF;  
         ELSE
            App_Config_Util_API.Log_Error( Language_SYS.Translate_Constant(lu_name_,'APPEARANCE_CONFIG_ALREADY_EXISTS: Appearance Configuration ":P1" already exists.',Fnd_Session_API.Get_Language, rec_.code));
            RETURN;
         END IF;
      END IF;       
      configuration_item_id_  := new_rec_.rowkey;
      name_                   := new_rec_.code;       
   END LOOP;
END Import;

PROCEDURE Get_Deployment_Object_Names (
   dep_objects_ IN OUT NOCOPY App_Config_Util_API.DeploymentObjectArray,   
   in_xml_      IN     CLOB)
IS
   count_ NUMBER;
   xml_ Xmltype := Xmltype(in_xml_);
BEGIN
   FOR rec_ IN get_configuration(xml_) LOOP
      count_ := dep_objects_.COUNT + 1;
      dep_objects_(count_).name := UPPER(rec_.code);
      dep_objects_(count_).item_type := App_Config_Item_Type_API.DB_APPEARANCE_CONFIG;
   END LOOP;
END Get_Deployment_Object_Names;

PROCEDURE Validate_Import (
   info_               OUT    App_Config_Util_API.AppConfigItemInfo,
   dep_objects_        IN OUT NOCOPY App_Config_Util_API.DeploymentObjectArray,
   in_xml_             IN     CLOB)
IS
   xml_ Xmltype := Xmltype(in_xml_);
   old_rec_ fnd_branding_tab%ROWTYPE;
BEGIN
   info_.item_type := App_Config_Item_Type_API.DB_APPEARANCE_CONFIG;
   info_.validation_result    := App_Config_Util_API.Status_Validated; 
   info_.validation_details   := NULL;
   
   FOR rec_ IN get_configuration(xml_) LOOP
      old_rec_ := Get_Object_By_Keys___(rec_.code);
      IF old_rec_.rowkey IS NULL THEN
         info_.exists := 'FALSE';
      ELSIF old_rec_.rowkey = rec_.objkey THEN
         info_.exists := 'TRUE';
         info_.current_last_modified_date := old_rec_.definition_modified_date;
         info_.last_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         IF (info_.last_modified_date <> info_.current_last_modified_date) THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
            Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'EDITED_ITEM: Warning: There are local changes that will be overwritten',Fnd_Session_API.Get_Language), TRUE);
         END IF;
      ELSE
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'CONFIGEXIST2: Error: Another Appearance Configuration Context with the code ":P1" already exists', Fnd_Session_API.Get_Language, rec_.code), TRUE);
         App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error); 
      END IF;
   END LOOP;
   App_Config_Util_API.Set_Validation_Completed(info_.validation_result);
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      END IF;
      dbms_output.put_line(dbms_utility.Format_Error_Backtrace);
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      Utility_SYS.Append_Text_Line(info_.validation_details, SQLERRM, TRUE);
END Validate_Import;

PROCEDURE Validate_Existing(
   info_               OUT App_Config_Util_API.AppConfigItemInfo,
   rowkey_             IN  app_config_package_item_tab.configuration_item_id%TYPE)
IS
   rec_ fnd_branding_tab%ROWTYPE;
   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
BEGIN
   info_.item_type            := App_Config_Item_Type_API.DB_APPEARANCE_CONFIG;
   info_.validation_result    := App_Config_Util_API.Status_Unknown;
   info_.validation_details   := NULL;
   Rowkey_Exist(rowkey_);
   rec_ := Get_Key_By_Rowkey(rowkey_);
   rec_ := Get_Object_By_Keys___(rec_.code);
   info_.exists := 'TRUE';
   info_.name := rec_.name;
   info_.current_last_modified_date := rec_.definition_modified_date;
   App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, rec_.rowkey);
   info_.validation_result    := App_Config_Util_API.Status_Validated;
   App_Config_Util_API.Set_Validation_Completed(info_.validation_result);
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE IN (-4061, -4065, -4068) THEN -- Don't catch these exceptions.
         RAISE;
      END IF;
      dbms_output.put_line(dbms_utility.Format_Error_Backtrace);
      App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Error);
      Utility_SYS.Append_Text_Line(info_.validation_details, SQLERRM, TRUE);
END Validate_Existing;

PROCEDURE Update_Def_Modified_Date (
   code_ IN VARCHAR2)
IS
BEGIN
   UPDATE fnd_branding_tab
      SET definition_modified_date = sysdate
      WHERE code = code_;  
END Update_Def_Modified_Date;

FUNCTION Get_Def_Modified_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN DATE
IS
   definition_modified_date_ fnd_branding_tab.definition_modified_date%TYPE;
BEGIN
   SELECT definition_modified_date INTO definition_modified_date_
   FROM fnd_branding_tab
   WHERE rowkey = rowkey_;
   RETURN definition_modified_date_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Def_Modified_By_Rowkey;

FUNCTION Is_Published(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   state_ fnd_branding_tab.state%TYPE;
BEGIN
  SELECT state INTO state_
      FROM  fnd_branding_tab
      WHERE rowkey = rowkey_;
   IF state_ = 'PUBLISHED' THEN
      RETURN 'TRUE';
   END IF;
   RETURN 'FALSE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';   
END Is_Published;

FUNCTION Is_In_Sync(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1 INTO dummy_  
      FROM fnd_branding_tab
      WHERE rowkey = rowkey_;
      RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Is_In_Sync;
