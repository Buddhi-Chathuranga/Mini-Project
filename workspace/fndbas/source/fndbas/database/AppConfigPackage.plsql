-----------------------------------------------------------------------------
--
--  Logical unit: AppConfigPackage
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

EXPORT_DEF_VERSION        CONSTANT VARCHAR2(5)   := '1.0';
XMLTAG_ITEMS         CONSTANT VARCHAR2(50)  := 'ITEMS';
XMLTAG_APP_CONFIG_EXP     CONSTANT VARCHAR2(50)  := 'APPLICATION_CONFIGURATION';
XMLTAG_APP_CONFIG_PKG CONSTANT VARCHAR2(50)  := 'APPLICATION_CONFIGURATION_PACKAGE';
XMLTAG_EXP_PKG_DEF_VER    CONSTANT VARCHAR2(50)  := 'EXPORT_DEF_VERSION';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Generate_Origin___ RETURN VARCHAR2
IS
BEGIN
   RETURN Database_SYS.Get_Database_Name || '-' ||Fnd_License_API.Get_Value('CUSTOMER_ID') || '-' || Fnd_License_API.Get_Value('INSTALLATION_ID');
END Generate_Origin___;

FUNCTION Export_Package_Only(
   package_id_ IN VARCHAR2,
   additional_items_ IN Xmltype,
   version_        IN VARCHAR2 DEFAULT NULL,
   export_comment_ IN VARCHAR2 DEFAULT NULL) RETURN CLOB
IS
BEGIN
   RETURN Export_Package___(package_id_,additional_items_,version_,export_comment_);
END;

FUNCTION Export_Package___ (
   package_id_ IN VARCHAR2,
   additional_items_ IN Xmltype,
   version_        IN VARCHAR2 DEFAULT NULL,
   export_comment_ IN VARCHAR2 DEFAULT NULL) RETURN CLOB
IS
   origin_ VARCHAR2(100) := Generate_Origin___;
   date_format_ VARCHAR2(100) := Client_SYS.date_format_;
   ao_ VARCHAR2(100) := Fnd_Session_API.Get_App_Owner;
   stmt_ VARCHAR2(32000) := 'SELECT '||EXPORT_DEF_VERSION||' '||XMLTAG_EXP_PKG_DEF_VER||',
                                    h.package_id, 
                                    h.name,
                                    h.description,
                                    h.author,
                                    '''|| version_ || ''' version,
                                    to_char(sysdate, '''||date_format_||''') version_time_stamp,
                                    ''' || origin_ || ''' origin,
                                    to_char(last_modified_date,'''||date_format_||''') last_modified_date,
                                  CURSOR(SELECT '||ao_||'.App_Config_Package_Item_API.Get_Config_Item_Name(h.package_id, l.configuration_item_id) name,
                                                l.item_type_db type,
                                                '||ao_||'.App_Config_Package_Item_API.Get_Config_Item_Description(h.package_id, l.configuration_item_id) description,
                                                '||ao_||'.App_Config_Package_Item_API.Get_Config_Item_File_Name(h.package_id, l.configuration_item_id) filename
                                         FROM APP_CONFIG_PACKAGE_ITEM l 
                                         WHERE l.package_id = h.package_id) '||XMLTAG_ITEMS||'
                             FROM APP_CONFIG_PACKAGE h
                             WHERE package_id= '''||package_id_||'''';
   ctx_    dbms_xmlgen.ctxHandle;
   xml_ XmlType;
   out_xml_ CLOB;
BEGIN
   Exist(package_id_);   
   --dbms_output.put_line(stmt_);
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, NULL);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_APP_CONFIG_EXP);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   Utility_SYS.Add_XML_Element_After(xml_, additional_items_ , '/APPLICATION_CONFIGURATION/ITEMS');
   
   IF export_comment_ IS NOT NULL THEN
      Utility_SYS.Add_Xml_Element_Before(xml_, 'EXPORT_COMMENT', export_comment_, '/APPLICATION_CONFIGURATION/PACKAGE_ID');
   END IF;
   
   Utility_SYS.XMLType_To_CLOB(out_xml_, xml_);
   RETURN out_xml_;
END Export_Package___;

PROCEDURE Validate_Package_Name___ (
   name_       IN VARCHAR2,
   package_id_ IN VARCHAR2 DEFAULT NULL)
IS
   temp_ NUMBER;
BEGIN
   SELECT 1 INTO temp_
   FROM app_config_package_tab
   WHERE name = name_
   AND ( package_id_ IS NULL OR package_id <> package_id_)
   FETCH FIRST 1 ROW ONLY;
   
   IF temp_ = 1 THEN
      Error_Sys.Record_General(lu_name_,'PKG_NAME_COLL: A package with the name '':P1'' already exists.' , name_);
   END IF;
EXCEPTION
   WHEN no_data_found THEN
      NULL;
END Validate_Package_Name___;

@Override
PROCEDURE Prepare_New___ (
   newrec_ IN OUT app_config_package_tab%ROWTYPE )
IS
BEGIN
   newrec_.temporary_package := 'FALSE';   
   super(newrec_);
   --Add post-processing code here
END Prepare_New___;

@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT app_config_package_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   --Add pre-processing code here
   IF (newrec_.name IS NOT NULL) THEN
      Validate_Package_Name___(newrec_.name );
   END IF;
   super(newrec_, indrec_, attr_);
   --Add post-processing code here
END Check_Insert___;

@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     app_config_package_tab%ROWTYPE,
   newrec_ IN OUT app_config_package_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.name IS NOT NULL) THEN
      Validate_Package_Name___(newrec_.name, newrec_.package_id );
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Update___;

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT app_config_package_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.last_modified_date := sysdate;
   IF (newrec_.package_id IS NULL) THEN
      newrec_.package_id := sys_guid();
   END IF;
   IF newrec_.author IS NULL THEN
      newrec_.author := Fnd_License_API.Get_Value('CUSTOMER_NAME');
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   Client_SYS.Add_To_Attr('PACKAGE_ID', newrec_.package_id, attr_);
   Client_SYS.Add_To_Attr('LAST_MODIFIED_DATE', newrec_.last_modified_date, attr_);
   Client_SYS.Add_To_Attr('AUTHOR', newrec_.author, attr_);
END Insert___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     app_config_package_tab%ROWTYPE,
   newrec_     IN OUT app_config_package_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.last_modified_date := sysdate;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   Client_SYS.Add_To_Attr('LAST_MODIFIED_DATE', newrec_.last_modified_date, attr_);
END Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
PROCEDURE Get_Package_By_Name(
   package_exist_ OUT VARCHAR2,
   package_id_    OUT VARCHAR2,
   author_         OUT VARCHAR2,
   version_       OUT VARCHAR2,
   description_   OUT VARCHAR2,
   last_modified_date_ OUT DATE,
   imported_date_      OUT DATE,
   version_time_stamp_  OUT DATE,
   name_           IN VARCHAR2)
IS
   rec_ app_config_package_tab%ROWTYPE;
   CURSOR get_package_by_name IS
      SELECT *
         FROM  app_config_package_tab
         WHERE name = name_;
BEGIN
   OPEN get_package_by_name;
   FETCH get_package_by_name INTO rec_;
   IF get_package_by_name%FOUND THEN
     package_exist_  := 'TRUE';
     package_id_     := rec_.package_id;
     author_          := rec_.author;
     version_        := rec_.version;
     description_    := rec_.description;
     last_modified_date_   := rec_.last_modified_date;
     imported_date_        := rec_.imported_date;
     version_time_stamp_   := rec_.version_time_stamp;
   ELSE
     package_exist_  := 'FALSE';
   END IF;
   CLOSE get_package_by_name;   
END Get_Package_By_Name;

@UncheckedAccess
PROCEDURE Get_Package_By_Id(
   package_exist_       OUT VARCHAR2,
   name_                OUT VARCHAR2,
   author_              OUT VARCHAR2,
   version_             OUT VARCHAR2,
   description_         OUT VARCHAR2,
   last_modified_date_  OUT DATE,
   imported_date_       OUT DATE,
   version_time_stamp_  OUT DATE,
   package_id_          IN VARCHAR2)
IS
   rec_ app_config_package_tab%ROWTYPE;
   CURSOR get_package_by_name IS
      SELECT *
         FROM  app_config_package_tab t
         WHERE t.package_id = package_id_;
BEGIN
   OPEN get_package_by_name;
   FETCH get_package_by_name INTO rec_;
   IF get_package_by_name%FOUND THEN
     package_exist_  := 'TRUE';
     name_ := rec_.name;
     author_          := rec_.author;
     version_        := rec_.version;
     description_    := rec_.description;
     last_modified_date_   := rec_.last_modified_date;
     imported_date_        := rec_.imported_date;
     version_time_stamp_   := rec_.version_time_stamp;
   ELSE
     package_exist_  := 'FALSE';
   END IF;
   CLOSE get_package_by_name;   
END Get_Package_By_Id;

@UncheckedAccess
FUNCTION Get_Package_Id_By_Name(
   name_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_id_ app_config_package_tab.package_id%TYPE;
BEGIN
   SELECT package_id INTO package_id_
   FROM  app_config_package_tab
   WHERE name = name_;
   RETURN package_id_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Package_Id_By_Name;
   
PROCEDURE Create_Or_Update_Package (
   package_id_                     IN OUT VARCHAR2,
   name_                           VARCHAR2,
   description_                    VARCHAR2,
   author_                          VARCHAR2,
   version_                        VARCHAR2,
   version_time_stamp_             DATE,
   origin_                VARCHAR2,
   raise_error_                    VARCHAR2 DEFAULT 'TRUE', 
   overwrite_on_name_collision_    VARCHAR2 DEFAULT 'FALSE',
   replace_existing_               VARCHAR2 DEFAULT 'TRUE')
IS
   rec_ app_config_package_tab%ROWTYPE;
   CURSOR get_package_by_name IS
      SELECT *
         FROM  app_config_package_tab
         WHERE name = name_;
BEGIN  
   IF NOT Check_Exist___(package_id_) THEN     
      App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'CREATE_PACKAGE: Creating the package ":P1"',Fnd_Session_API.Get_Language, name_));      
      --Check same name collision.       
      OPEN get_package_by_name;
      FETCH get_package_by_name INTO rec_;     
      IF get_package_by_name%FOUND THEN
         CLOSE get_package_by_name;
         IF overwrite_on_name_collision_ <> 'TRUE' THEN
            IF raise_error_ = 'TRUE' THEN
               Error_Sys.Record_General(lu_name_,'PACKAGE_NAME_COLLISION: A Package with the same name already exist.');
            ELSE
               App_Config_Util_API.Log_Error( Language_SYS.Translate_Constant(lu_name_,'PACKAGE_NAME_COLLISION2: A Package with the same name already exist. Name: :P1 Author: :P2 Version: :P3  Description: ' || rec_.description,Fnd_Session_API.Get_Language,rec_.name,rec_.author,rec_.version));
               --Message_Sys.Add_Attribute(log_,'PACKAGE_NAME_COLLISION', 'A Package with same name already exist.' || '  Name: ' || rec_.name || '  Author:  ' || rec_.author || '  Version:  ' || rec_.version || '  Description:  ' || rec_.description);
               RETURN;
            END IF;
         ELSE
            --Replace_Package
            Remove___(rec_);            
         END IF;
      ELSE
          CLOSE get_package_by_name;
      END IF;
      
      rec_ := NULL;      
      
      Prepare_new___(rec_);
      
      IF (package_id_ IS NULL) THEN
         package_id_ := sys_guid();
      END IF;
      
      rec_.package_id      := package_id_;
      rec_.name            := name_;
      rec_.description     := description_;
      rec_.author          := author_;
      rec_.version         := version_;
      rec_.version_time_stamp    := version_time_stamp_;
      rec_.origin                := origin_;
      rec_.last_modified_date    := sysdate;
      New___(rec_);
      App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'NEW_PKG_CREATED: New package created. Name: :P1 Author: :P2 Version: :P3 Description: ' || rec_.description,Fnd_Session_API.Get_Language,rec_.name,rec_.author,rec_.version));
   ELSE
      IF (replace_existing_ = 'TRUE') THEN
         rec_ := Lock_By_Keys___(package_id_);
         rec_.name            := name_;
         rec_.description     := description_;
         rec_.author           := author_;
         rec_.version         := version_;
         rec_.version_time_stamp   := version_time_stamp_;
         rec_.origin := origin_;
         rec_.temporary_package     := 'FALSE';
         Modify___(rec_);
      ELSE
         IF raise_error_ = 'TRUE' THEN
            Error_Sys.Record_General(lu_name_,'PACKAGE_EXIST: The package already exists.');
         ELSE
             App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'PACKAGE_EXIST2: The package already exist. Name: :P1 Author: :P2 Version: :P3 Description: ' || rec_.description,Fnd_Session_API.Get_Language,rec_.name,rec_.author,rec_.version));
             RETURN;
         END IF;
      END IF;
      App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'EXISTING_PKG_UPDATED: Package updated. Name: :P1 Author: :P2 Version: :P3 Description: ' || rec_.description,Fnd_Session_API.Get_Language,rec_.name,rec_.author,rec_.version));  
   END IF;
END Create_Or_Update_Package;

PROCEDURE Create_Temporary_Package (
   package_id_                     OUT VARCHAR2)
IS
   rec_ app_config_package_tab%ROWTYPE;
   BEGIN  
      -- Temporary package are never persisted after transaction is completed. These are created to publish single config items
      Prepare_new___(rec_);      
      package_id_ := sys_guid();      
      rec_.package_id      := package_id_;
      rec_.last_modified_date    := sysdate;
      rec_.temporary_package     := 'TRUE';
      New___(rec_);        
END Create_Temporary_Package;

PROCEDURE Export_Package (
   package_exp_msg_ OUT CLOB,
   package_id_ IN VARCHAR2,
   version_    IN VARCHAR2 DEFAULT NULL,
   export_comment_ IN VARCHAR2 DEFAULT NULL)
IS
   temp_ CLOB;
   additional_items_xml_ Xmltype;
BEGIN
   package_exp_msg_ := Message_SYS.Construct_Clob_Message('APP_CONFIG_PACKAGE_EXPORT_MSG'); 
   App_Config_Package_Item_API.Export_Configuration_Items(additional_items_xml_, package_exp_msg_, package_id_);
   temp_ := Export_Package___(package_id_, additional_items_xml_, version_, export_comment_);
   Message_SYS.Add_Clob_Attribute(package_exp_msg_, 'APP_CONFIGPACKAGE_INFO', temp_);
   dbms_lob.Freetemporary(temp_); 
END Export_Package;

@UncheckedAccess
PROCEDURE Get_Item_Package (
   package_id_          OUT VARCHAR2,
   name_                OUT VARCHAR2,
   author_              OUT VARCHAR2,
   locked_              OUT VARCHAR2,
   version_time_stamp_  OUT DATE,
   configuration_id_ IN VARCHAR2)      
IS  
BEGIN   
   SELECT p.package_id, name, author, locked, version_time_stamp  INTO package_id_,name_,author_,locked_,version_time_stamp_
   FROM app_config_package_tab p, app_config_package_item_tab i
   WHERE p.package_id = i.package_id
   AND i.configuration_item_id = configuration_id_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN;
   WHEN too_many_rows THEN
      RETURN;   
   END Get_Item_Package;
   
@UncheckedAccess
FUNCTION Get_Package_Imported_Date (
   configuration_id_ IN VARCHAR2) RETURN DATE      
IS 
   imported_date_ DATE;
BEGIN   
   SELECT p.imported_date INTO imported_date_
   FROM app_config_package_tab p, app_config_package_item_tab i
   WHERE p.package_id = i.package_id
   AND i.configuration_item_id = configuration_id_;
   RETURN imported_date_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      RETURN NULL;   
END Get_Package_Imported_Date;   

@UncheckedAccess
FUNCTION Get_Item_Package_Name (
   configuration_item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   name_ app_config_package_tab.name%TYPE;
BEGIN
   SELECT name INTO name_
   FROM app_config_package_tab p, app_config_package_item_tab i
   WHERE p.package_id = i.package_id
   AND i.configuration_item_id = configuration_item_id_;
   RETURN name_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Item_Package_Name;

PROCEDURE Publish_Package (
    package_id_    IN VARCHAR2 )
IS 
BEGIN
   App_Config_Package_Item_API.Publish_Package_Items(package_id_);
END Publish_Package;

@UncheckedAccess
FUNCTION Get_Item_Pres_Objects (
   package_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   out_msg_ VARCHAR2(4000):= '';
   TYPE rec_collection_type IS TABLE OF App_Config_Package_Item_Tab%ROWTYPE;
   rec_collection_    rec_collection_type;
   rec_ App_Config_Package_Item_Tab%ROWTYPE;
   po_id_ VARCHAR2(200);
   counter_ NUMBER := 0;
BEGIN
  
   out_msg_ := Message_SYS.Construct('PoList');
 SELECT *
   BULK COLLECT
   INTO rec_collection_
   FROM App_Config_Package_Item_Tab
   WHERE package_id = package_id_;
   
   FOR i IN 1..rec_collection_.COUNT LOOP
      rec_ := rec_collection_(i);
      po_id_:= App_Config_Package_Item_API.Get_PO_ID(package_id_, rec_.configuration_item_id);
      IF po_id_ IS NOT NULL THEN 
         counter_ := counter_ + 1;
         Message_SYS.Add_Attribute(out_msg_, 'key'|| counter_, po_id_ );   
      END IF;
   END LOOP;
   
   RETURN out_msg_;
   
END Get_Item_Pres_Objects;
   
PROCEDURE Set_Package_Modified (
   package_id_ IN VARCHAR2)
IS
BEGIN
   UPDATE app_config_package_tab
   SET last_modified_date = sysdate
   WHERE package_id = package_id_; 
END Set_Package_Modified;

PROCEDURE Set_Import_Date (
   package_id_ IN VARCHAR2)
IS
   rec_ app_config_package_tab%ROWTYPE;
BEGIN
   rec_ := Get_Object_By_Keys___(package_id_);
   rec_.imported_date := sysdate;
   Modify___(rec_);   
END Set_Import_Date;

PROCEDURE Remove_Package (
   package_id_ IN VARCHAR2)
IS
   remrec_ app_config_package_tab%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___(package_id_);
   Remove___(remrec_);
END Remove_Package;

@UncheckedAccess
FUNCTION Get_Package_Item_Count(
     package_id_ IN VARCHAR2)RETURN NUMBER
IS
   item_count_ NUMBER; 
   CURSOR Get_Item_Count IS
     SELECT  count(configuration_item_id) 
     FROM app_config_package_item_tab
     WHERE package_id = package_id_;
BEGIN
      OPEN Get_Item_Count;
      FETCH Get_Item_Count INTO item_count_ ;
      CLOSE Get_Item_Count;
      
      RETURN item_count_;

END Get_Package_Item_Count;

PROCEDURE Validate_Conf_Package (
   result_ OUT CLOB,
   status_ OUT App_Config_Util_API.AppConfigItemStatus,
   package_id_ VARCHAR2,
   version_ VARCHAR2 DEFAULT NULL)
IS
   CURSOR get_items IS
   SELECT * FROM app_config_package_item_tab t
   WHERE t.package_id = package_id_;
   item_export_ CLOB;
   package_exp_msg_ CLOB;
   info_                    App_Config_Util_API.AppConfigItemInfo;
   info_lu_                 App_Config_Util_API.AppConfigItemInfo2;
   version_time_stamp_ DATE;
   deployment_object_list_  App_Config_Util_API.DeploymentObjectArray;
BEGIN
   package_exp_msg_ := App_Config_Package_API.Export_Package_Only(package_id_,NULL, version_);
   
   result_ := Message_SYS.Construct('Validation Result');
   IF package_id_ IS NOT NULL THEN
      IF App_Config_Package_API.Get_Name(package_id_) IS NULL THEN
         Message_SYS.Add_Attribute(result_, lu_name_ || 'MISSING_NAME','The package do not have a name');
      END IF;
   END IF;   
   
   FOR rec_ IN get_items LOOP
      
      App_Config_Package_Item_API.Export_Configuration_Item(item_export_, package_id_, rec_.configuration_item_id);
      CASE rec_.item_type
         --FNDBAS
         WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
            Custom_Menu_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
            Fnd_Event_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
            Fnd_Event_Action_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
            Conditional_Field_Action_API.Validate_Existing(info_, rec_.configuration_item_id);
         WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
            Quick_report_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
            Fnd_Branding_API.Validate_Existing(info_, rec_.configuration_item_id);   
         --FNDCOB
         $IF Component_Fndcob_SYS.INSTALLED $THEN
         WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
               Custom_Enumerations_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
               Custom_Fields_API.Validate_Existing(info_,  rec_.configuration_item_id, rec_.item_type,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
               Custom_Fields_API.Validate_Existing(info_,  rec_.configuration_item_id, rec_.item_type,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
               Custom_Lus_API.Validate_Existing(info_lu_, rec_.configuration_item_id ,NULL,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
               Custom_Pages_API.Validate_Existing(info_, rec_.configuration_item_id);
         WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
               Custom_Info_Cards_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
               Custom_Tab_API.Validate_Existing(info_,  rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
            Query_Artifact_API.Validate_Existing(info_, rec_.configuration_item_id);      
         $END
         $IF Component_Fndmob_SYS.INSTALLED $THEN
         WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
            Mobile_Application_Version_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         $END
         ELSE     
            App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant('LU_NAME','NOVALIDATIONFORTYPE: No validation done for item of type :P1',Fnd_Session_API.Get_Language,rec_.item_type));
      END CASE;
      
      IF rec_.item_type <> App_Config_Item_Type_API.DB_CUSTOM_LU THEN
         IF info_.current_package_id IS NOT NULL AND package_id_ IS NOT NULL AND info_.current_package_id <> package_id_ THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
            Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'CHANGE_PACKAGE: Warning: This belongs to package ":P1"',Fnd_Session_API.Get_Language,info_.current_package), TRUE); 
         END IF;
         
         IF info_.validation_result = App_Config_Util_API.Status_Error OR info_.validation_result = App_Config_Util_API.Status_Deploy_Error THEN
            Set_Deployment_Error_Tag___(deployment_object_list_,info_.name,info_.item_type,info_.validation_result);
            --Set_Validation_Error_Flag___(rec_.import_id, rec_.import_item_id);
         END IF;
         Add_Output_Message___(result_,'NO_IMPORT_ID',info_);
         App_Config_Util_API.Set_Validation_Result(status_, info_.validation_result);
         info_ := NULL;
      ELSE
         IF info_lu_.current_package_id IS NOT NULL AND package_id_ IS NOT NULL AND info_lu_.current_package_id <> package_id_ THEN
            App_Config_Util_API.Set_Validation_Result(info_lu_.validation_result, App_Config_Util_API.Status_Warning);
            Utility_SYS.Append_Text_Line(info_lu_.validation_details,Language_SYS.Translate_Constant(lu_name_,'CHANGE_PACKAGE: Warning: This belongs to package ":P1"',Fnd_Session_API.Get_Language,info_lu_.current_package), TRUE); 
         END IF;
         
         IF info_lu_.validation_result = App_Config_Util_API.Status_Error OR info_lu_.validation_result = App_Config_Util_API.Status_Deploy_Error THEN
            Set_Deployment_Error_Tag___(deployment_object_list_,info_lu_.name,info_lu_.item_type,info_lu_.validation_result);
            --Set_Validation_Error_Flag___(rec_.import_id, rec_.import_item_id);
         END IF;
         Add_Output_Message___(result_,'NO_IMPORT_ID',info_lu_);
         App_Config_Util_API.Set_Validation_Result(status_, info_lu_.validation_result);
         info_lu_ := NULL;
      END IF; 
   END LOOP;
END Validate_Conf_Package;

PROCEDURE Set_Deployment_Error_Tag___(
   dep_objects_ IN OUT App_Config_Util_API.DeploymentObjectArray,
   name_        IN     VARCHAR2,
   type_        IN     VARCHAR2,
   item_status_ IN     App_Config_Util_API.AppConfigItemStatus)      
IS 
BEGIN
   FOR i IN 1 .. dep_objects_.count LOOP
      IF dep_objects_(i).name = name_ AND dep_objects_(i).item_type = type_  THEN
         dep_objects_(i).error := item_status_;
      END IF;   
   END LOOP;   
END Set_Deployment_Error_Tag___;

PROCEDURE Add_Output_Message___ (     
   result_         IN OUT NOCOPY CLOB,
   import_item_id_ IN            VARCHAR2, 
   info_           IN            App_Config_Util_API.AppConfigItemInfo)
IS  
   message_ CLOB;
BEGIN
   message_ := Message_SYS.Construct_Clob_Message('Item Validation');
   IF (info_.item_type IS NOT NULL) THEN
      Message_SYS.Add_Attribute(message_, 'NAME', info_.name);
      Message_SYS.Add_Attribute(message_, 'TYPE', info_.item_type);
      Message_SYS.Add_Attribute(message_, 'LAST_MODIFIED_DATE', info_.last_modified_date);
      Message_SYS.Add_Attribute(message_, 'VALIDATION_RESULT', App_Config_Util_API.Get_Validation_Result(info_.validation_result));                       
      Message_SYS.Add_Clob_Attribute(message_, 'VALIDATION_DETAILS', info_.validation_details);
      Message_SYS.Add_Attribute(message_, 'EXISTS', info_.exists);
      Message_SYS.Add_Attribute(message_, 'CURRENT_DESCRIPTION', info_.current_description);
      Message_SYS.Add_Attribute(message_, 'CURRENT_PUBLISHED', info_.current_published);
      Message_SYS.Add_Attribute(message_, 'CURRENT_LAST_MODIFIED', info_.current_last_modified_date);
      Message_SYS.Add_Attribute(message_, 'CURRENT_PACKAGE', info_.current_package);     
   END IF;
   Message_SYS.Add_Clob_Attribute(result_,import_item_id_, message_);
END Add_Output_Message___;

PROCEDURE Add_Output_Message___ (     
   result_         IN OUT NOCOPY CLOB,
   import_item_id_ IN            VARCHAR2, 
   info_           IN            App_Config_Util_API.AppConfigItemInfo2)
IS  
   message_ CLOB;
BEGIN
   message_ := Message_SYS.Construct_Clob_Message('Item Validation');
   IF (info_.item_type IS NOT NULL) THEN
      Message_SYS.Add_Attribute(message_, 'NAME', info_.name);
      Message_SYS.Add_Attribute(message_, 'TYPE', info_.item_type);
      Message_SYS.Add_Attribute(message_, 'LAST_MODIFIED_DATE', info_.last_modified_date);
      Message_SYS.Add_Attribute(message_, 'VALIDATION_RESULT', App_Config_Util_API.Get_Validation_Result(info_.validation_result));                       
      Message_SYS.Add_Clob_Attribute(message_, 'VALIDATION_DETAILS', info_.validation_details);
      Message_SYS.Add_Attribute(message_, 'EXISTS', info_.exists);
      Message_SYS.Add_Attribute(message_, 'CURRENT_DESCRIPTION', info_.current_description);
      Message_SYS.Add_Attribute(message_, 'CURRENT_PUBLISHED', info_.current_published);
      Message_SYS.Add_Attribute(message_, 'CURRENT_LAST_MODIFIED', info_.current_last_modified_date);
      Message_SYS.Add_Attribute(message_, 'CURRENT_PACKAGE', info_.current_package);     
   END IF;
   Message_SYS.Add_Clob_Attribute(result_,import_item_id_, message_);
END Add_Output_Message___;

PROCEDURE New__ (
   newrec_ IN OUT NOCOPY app_config_package_tab%ROWTYPE )
IS
BEGIN
   New___(newrec_); 
END New__;


FUNCTION Enable_Publish_Command (
  package_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   CURSOR get_items IS
      SELECT a.configuration_item_id
        FROM app_config_package_item_tab a
       WHERE a.package_id = package_id_;
   
BEGIN
   IF (App_Config_Package_API.Get_Name(package_id_) IS NULL) THEN
      RETURN Fnd_Boolean_API.DB_FALSE;
   ELSE   
      FOR item_id IN get_items LOOP 
         IF ((App_Config_Package_Item_API.Get_Item_Synchronized(package_id_, item_id.configuration_item_id)) = 'FALSE') THEN
            RETURN Fnd_Boolean_API.DB_TRUE;
         END IF;   
      END LOOP;
      RETURN Fnd_Boolean_API.DB_FALSE;  
   END IF;
END Enable_Publish_Command;

FUNCTION Get_Acp_Items_(
   name_ IN VARCHAR2,
   package_id_ IN VARCHAR2, 
   version_ IN VARCHAR2, 
   comment_ IN VARCHAR2 ) RETURN BLOB 
IS  
   zip_ BLOB;
   file_list_ FND_ZIP_OBJECT_TAB := FND_ZIP_OBJECT_TAB();
   package_exp_msg_ CLOB;
   count_   INTEGER;
   key_name_   message_sys.name_table_clob;
   value_  message_sys.line_table_clob ; 

BEGIN
   App_Config_Package_API.Export_Package(package_exp_msg_, package_id_, version_, comment_);
   Message_SYS.Get_Clob_Attributes(package_exp_msg_, count_, key_name_, value_);
   Dbms_lob.Createtemporary(zip_, FALSE);
      FOR i IN 1..count_ LOOP 
         BEGIN 
            file_list_.extend(1);
            IF count_ >1 THEN 
               IF key_name_(i) = 'APP_CONFIGPACKAGE_INFO' THEN 
                  file_list_(file_list_.last) := FND_ZIP_OBJECT_REC(name_||'.xml',Utility_SYS.Clob_To_Blob(value_(i)));
               ELSE
                  file_list_(file_list_.last) := FND_ZIP_OBJECT_REC('Items/'||SUBSTR(key_name_(i),26,LENGTH(key_name_(i))-30)||'.xml',Utility_SYS.Clob_To_Blob(value_(i)));
               END IF;
            ELSE 
               file_list_(file_list_.last) := FND_ZIP_OBJECT_REC('Items/',Utility_SYS.Clob_To_Blob(value_(i)));
               file_list_.extend(1);
               file_list_(file_list_.last) := FND_ZIP_OBJECT_REC(name_||'.xml',Utility_SYS.Clob_To_Blob(value_(i)));
            END IF;
         END;
      END LOOP;  
   Fnd_Zip_Util_API.Zip_Files(zip_, file_list_);      
   RETURN zip_;     
END Get_Acp_Items_;

PROCEDURE Validate_Conf_Item (
   result_ OUT CLOB,
   status_ OUT App_Config_Util_API.AppConfigItemStatus,
   package_id_ VARCHAR2,
   item_id_ VARCHAR2,
   version_ VARCHAR2 DEFAULT NULL)
IS
   CURSOR get_items IS
      SELECT * 
      FROM app_config_package_item_tab t
      WHERE t.package_id = package_id_ AND t.configuration_item_id = item_id_;
   item_export_ CLOB;
   package_exp_msg_ CLOB;
   info_                    App_Config_Util_API.AppConfigItemInfo;
   info_lu_                 App_Config_Util_API.AppConfigItemInfo2;
   version_time_stamp_ DATE;
   deployment_object_list_  App_Config_Util_API.DeploymentObjectArray;
BEGIN
   package_exp_msg_ := App_Config_Package_API.Export_Package_Only(package_id_,NULL, version_);
   
   result_ := Message_SYS.Construct('Validation Result');
   IF package_id_ IS NOT NULL THEN
      IF App_Config_Package_API.Get_Name(package_id_) IS NULL THEN
         Message_SYS.Add_Attribute(result_, lu_name_ || 'MISSING_NAME','The package do not have a name');
      END IF;
   END IF;   
   
   FOR rec_ IN get_items LOOP
      
      App_Config_Package_Item_API.Export_Configuration_Item(item_export_, package_id_, rec_.configuration_item_id);
      CASE rec_.item_type
         --FNDBAS
         WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
            Custom_Menu_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
            Fnd_Event_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
            Fnd_Event_Action_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
            Conditional_Field_Action_API.Validate_Existing(info_, rec_.configuration_item_id);
         WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
            Quick_report_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
            Fnd_Branding_API.Validate_Existing(info_,  rec_.configuration_item_id);
               
         --FNDCOB
         $IF Component_Fndcob_SYS.INSTALLED $THEN
         WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
               Custom_Enumerations_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
               Custom_Fields_API.Validate_Existing(info_,  rec_.configuration_item_id, rec_.item_type,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
               Custom_Fields_API.Validate_Existing(info_,  rec_.configuration_item_id, rec_.item_type,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
               Custom_Lus_API.Validate_Existing(info_lu_, rec_.configuration_item_id ,NULL,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
               Custom_Pages_API.Validate_Existing(info_, rec_.configuration_item_id);
         WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
               Custom_Info_Cards_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
               Custom_Tab_API.Validate_Existing(info_,  rec_.configuration_item_id,version_time_stamp_);
         WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
            Query_Artifact_API.Validate_Existing(info_, rec_.configuration_item_id);
         $END
         $IF Component_Fndmob_SYS.INSTALLED $THEN
         WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
            Mobile_Application_Version_API.Validate_Existing(info_, rec_.configuration_item_id,version_time_stamp_);
         $END
         ELSE     
            App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant('LU_NAME','NOVALIDATIONFORTYPE: No validation done for item of type :P1',Fnd_Session_API.Get_Language,rec_.item_type));
      END CASE;
      
      IF rec_.item_type <> App_Config_Item_Type_API.DB_CUSTOM_LU THEN
         IF info_.current_package_id IS NOT NULL AND package_id_ IS NOT NULL AND info_.current_package_id <> package_id_ THEN
            App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
            Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'CHANGE_PACKAGE: Warning: This belongs to package ":P1"',Fnd_Session_API.Get_Language,info_.current_package), TRUE); 
         END IF;
         
         IF info_.validation_result = App_Config_Util_API.Status_Error OR info_.validation_result = App_Config_Util_API.Status_Deploy_Error THEN
            Set_Deployment_Error_Tag___(deployment_object_list_,info_.name,info_.item_type,info_.validation_result);
         END IF;
         Add_Output_Message___(result_,'NO_IMPORT_ID',info_);
         App_Config_Util_API.Set_Validation_Result(status_, info_.validation_result);
         info_ := NULL;
      ELSE
         IF info_lu_.current_package_id IS NOT NULL AND package_id_ IS NOT NULL AND info_lu_.current_package_id <> package_id_ THEN
            App_Config_Util_API.Set_Validation_Result(info_lu_.validation_result, App_Config_Util_API.Status_Warning);
            Utility_SYS.Append_Text_Line(info_lu_.validation_details,Language_SYS.Translate_Constant(lu_name_,'CHANGE_PACKAGE: Warning: This belongs to package ":P1"',Fnd_Session_API.Get_Language,info_lu_.current_package), TRUE); 
         END IF;
         
         IF info_lu_.validation_result = App_Config_Util_API.Status_Error OR info_lu_.validation_result = App_Config_Util_API.Status_Deploy_Error THEN
            Set_Deployment_Error_Tag___(deployment_object_list_,info_lu_.name,info_lu_.item_type,info_lu_.validation_result);
         END IF;
         Add_Output_Message___(result_,'NO_IMPORT_ID',info_lu_);
         App_Config_Util_API.Set_Validation_Result(status_, info_lu_.validation_result);
         info_lu_ := NULL;
      END IF; 
   END LOOP;
END Validate_Conf_Item;


FUNCTION Get_Item_Validation_Result (
  package_id_ IN VARCHAR2,
  item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   status_ NUMBER;
   result_ CLOB;
   items_ LONG;
   item_status_ VARCHAR2(32000);
   acp_version_ VARCHAR2(32000);
BEGIN 
   --Handling Mobile Applications (due to unhandled exceptions in validate_existing api)
   IF (App_Config_Package_Item_API.Get_Item_Type(package_id_, item_id_) = 'Mobile Application') THEN
      RETURN 'VALIDATED';
   ELSE   
      acp_version_ := App_Config_Package_API.Get_Version(package_id_);
      App_Config_Package_API.Validate_Conf_Item(result_, status_, package_id_, item_id_, acp_version_);
      
      items_ := dbms_lob.substr( result_, 32000, 1 );
   
      item_status_ := REGEXP_SUBSTR(items_, q'[VALIDATION_RESULT=(.*)]', 1, 1, NULL, 1);
      IF item_status_ IS NULL THEN
         RETURN 'UNKNOWN';
      ELSE   
      RETURN item_status_;
      END IF;
   END IF;
END Get_Item_Validation_Result;


FUNCTION Get_Item_Validation_Detail (
  package_id_ IN VARCHAR2,
  item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   status_ NUMBER;
   result_ CLOB;
   items_ LONG;
   item_validation_details_ VARCHAR2(32000);
   current_item_info_ VARCHAR2(32000);
   current_package_ VARCHAR2(32000);
   acp_version_ VARCHAR2(32000);
   item_valid_status_ VARCHAR2(100);
   output_1_ VARCHAR2(32000);
   output_2_ VARCHAR2(32000);
   output_3_ VARCHAR2(32000);
BEGIN 
   --Handling Mobile Applications (due to unhandled exceptions in validate_existing api)
   IF (App_Config_Package_Item_API.Get_Item_Type(package_id_, item_id_) = 'Mobile Application') THEN
     RETURN '';
   ELSE 
      acp_version_ := App_Config_Package_API.Get_Version(package_id_);
      App_Config_Package_API.Validate_Conf_Item(result_, status_, package_id_, item_id_, acp_version_);

      items_ := dbms_lob.substr( result_, 32000, 1 );

      item_valid_status_ := REGEXP_SUBSTR(items_, q'[VALIDATION_RESULT=(.*)]', 1, 1, NULL, 1);
         IF item_valid_status_ IS NULL THEN
            item_valid_status_ := 'UNKNOWN';
         END IF;
      item_validation_details_ := dbms_lob.substr( items_, INSTR(items_, '-$EXISTS=')-(INSTR(items_, 'VALIDATION_DETAILS=') + 19), INSTR(items_, 'VALIDATION_DETAILS=') + 19 ); 
      item_validation_details_ := Get_Validation_Detail(item_validation_details_, item_valid_status_);
      current_item_info_ := REGEXP_SUBSTR(items_, q'[CURRENT_DESCRIPTION=(.*)]', 1, 1, NULL, 1);
      current_package_ := REGEXP_SUBSTR(items_, q'[CURRENT_PACKAGE=(.*)]', 1, 1, NULL, 1);

      IF (item_validation_details_ IS NOT NULL) THEN
         output_1_ :=  item_validation_details_;
         output_1_ := regexp_replace(output_1_, '^\s', NULL, 1, 0, 'm');         
      END IF;
      IF (current_package_ IS NOT NULL) THEN
         output_2_ :=  'Current Package: '||current_package_|| chr(10) || chr(10);
      END IF;
      IF (current_item_info_ IS NOT NULL) THEN
         output_3_ :=  'Current Item Info: '||current_item_info_;
      END IF;
      RETURN output_1_||output_2_||output_3_;
   END IF;
END Get_Item_Validation_Detail;   

FUNCTION Get_Validation_Detail (
      info_ IN VARCHAR2,
      validation_result_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
   IS
      temp_ VARCHAR2(32767);
      xml_str_   VARCHAR2(32000);
      xml_     Xmltype;
      xml_start_pos_ NUMBER;
      xml_end_pos_   NUMBER;
      start_tag_ VARCHAR2(20) := '<Item_Root>';
      end_tag_ VARCHAR2(20) := '</Item_Root>';
   BEGIN
      xml_start_pos_ := INSTR(info_, start_tag_);
      xml_end_pos_ := INSTR(info_, end_tag_);
      IF xml_start_pos_ > 0 AND xml_end_pos_ > 0 THEN
         BEGIN
            xml_str_ := SUBSTR(info_, xml_start_pos_, xml_end_pos_ + length(start_tag_));
            Utility_SYS.Append_Text_Line(temp_, SUBSTR(info_, 1, xml_start_pos_-1));
            xml_ := Xmltype(xml_str_);
            IF validation_result_ = 'ERROR' THEN 
               FOR rec_ IN (SELECT xt1.* FROM xmltable('/Item_Root/Item_Validation' passing xml_
                             COLUMNS
                                     ITEM_NAME VARCHAR2(100) path '@ItemName',
                                     Result VARCHAR2(100) path '@Result',
                                     Item_Validation VARCHAR2(1000) path '/' ) xt1 ) LOOP 
                  Utility_SYS.Append_Text_Line(temp_, rec_.item_name || rec_.item_validation || chr(10));
                  temp_ := regexp_replace(temp_, '\-');
               END LOOP;
            ELSE
               FOR rec_ IN (SELECT xt1.* FROM xmltable('/Item_Root/Item_Validation' passing xml_
                             COLUMNS
                                     ITEM_NAME VARCHAR2(100) path '@ItemName',
                                     Result VARCHAR2(100) path '@Result',
                                     Item_Validation VARCHAR2(1000) path '/' ) xt1 ) LOOP
                  IF rec_.Result = 'ERROR' THEN  
                     Utility_SYS.Append_Text_Line(temp_, rec_.item_name ||rec_.item_validation || chr(10));
                     temp_ := regexp_replace(temp_, '\-');
                  END IF;   
               END LOOP;
            END IF;   
            Utility_SYS.Append_Text_Line(temp_, SUBSTR(info_, xml_end_pos_ + length(end_tag_)));
         EXCEPTION
            WHEN OTHERS THEN
               temp_ := info_; 
         END;
      ELSE
         temp_ := info_;
      END IF;
      RETURN temp_;
   END Get_Validation_Detail;
   

FUNCTION Get_Item_Attributes_From_Xml(
   xml_ IN CLOB,
   xml_attribute_ IN VARCHAR2) RETURN VARCHAR2
IS
   name_ VARCHAR2(1000);
BEGIN
   SELECT EXTRACTVALUE(XMLTYPE(xml_),'/*:CUSTOM_OBJECT/*:'||xml_attribute_)
   INTO   name_
   FROM   dual;
   RETURN name_;
END Get_Item_Attributes_From_Xml;

FUNCTION Get_Item_Status(
   xml_ IN CLOB,
   start_point_ IN NUMBER) RETURN VARCHAR2
IS
   exists_ VARCHAR2(100);
   current_last_modified_ VARCHAR2(100);
   last_modified_ VARCHAR2(100);
BEGIN
   exists_ := REGEXP_SUBSTR(xml_, q'[EXISTS=(.*)]', start_point_, 1, NULL, 1);
   current_last_modified_ := REGEXP_SUBSTR(xml_, q'[CURRENT_LAST_MODIFIED=(.*)]', start_point_, 1, NULL, 1);
   last_modified_ := REGEXP_SUBSTR(xml_, q'[LAST_MODIFIED_DATE=(.*)]', start_point_, 1, NULL, 1);
      IF exists_ = 'FALSE' OR exists_ IS NULL THEN
         RETURN 'New';
      ELSIF current_last_modified_ = last_modified_ THEN
         RETURN 'Identical';
      ELSE
         RETURN 'Modified';
      END IF;
END Get_Item_Status;
   
FUNCTION Get_Item_Validation_Info (
   info_ IN VARCHAR2,
   validation_result_ IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   temp_ VARCHAR2(32767);
   xml_str_   VARCHAR2(32000);
   xml_     Xmltype;
   xml_start_pos_ NUMBER;
   xml_end_pos_   NUMBER;
   start_tag_ VARCHAR2(20) := '<Item_Root>';
   end_tag_ VARCHAR2(20) := '</Item_Root>';
BEGIN
   xml_start_pos_ := INSTR(info_, start_tag_);
   xml_end_pos_ := INSTR(info_, end_tag_);
   IF xml_start_pos_ > 0 AND xml_end_pos_ > 0 THEN
      BEGIN
         xml_str_ := SUBSTR(info_, xml_start_pos_, xml_end_pos_ + length(start_tag_));
         Utility_SYS.Append_Text_Line(temp_, SUBSTR(info_, 1, xml_start_pos_-1));
         xml_ := Xmltype(xml_str_);
         FOR rec_ IN (SELECT xt1.* 
                      FROM xmltable('/Item_Root/Item_Validation' passing xml_ COLUMNS
                      ITEM_NAME VARCHAR2(100) path '@ItemName', Result VARCHAR2(100) path '@Result', Item_Validation VARCHAR2(1000) path '/' ) xt1 ) LOOP
            IF REGEXP_LIKE(rec_.item_validation, '[A-Za-z]') THEN  
               Utility_SYS.Append_Text_Line(temp_, rec_.item_name || rec_.item_validation || chr(10));
               temp_ := regexp_replace(temp_, '\-');
            END IF;   
         END LOOP; 
         Utility_SYS.Append_Text_Line(temp_, regexp_replace(SUBSTR(info_, xml_end_pos_ + length(end_tag_)), '\-'));
      EXCEPTION
         WHEN OTHERS THEN
            temp_ := info_; 
      END;
   ELSE
      temp_ := info_;
   END IF;
   RETURN temp_;
END Get_Item_Validation_Info;   