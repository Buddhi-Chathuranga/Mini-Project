-----------------------------------------------------------------------------
--
--  Logical unit: AppConfigPackageItem
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

 TYPE item IS RECORD (name VARCHAR2(100),
                      description VARCHAR2(2000),
                      Type VARCHAR2(50),
                      file_name VARCHAR2(1000));

TYPE items IS TABLE OF item;
newline_ CONSTANT VARCHAR2(10) := chr(10);

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
--
-- Export Methods
--
PROCEDURE Export_Custom_Field___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2,
   options_ IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_ custom_field_attributes_tab%ROWTYPE;
      export_views_      BOOLEAN := FALSE;
      export_views_only_ BOOLEAN := FALSE;
   BEGIN
      IF options_ IS NOT NULL AND Message_SYS.Find_Attribute(options_, 'EXPORT_VIEWS', 'FALSE') = 'TRUE' THEN
         export_views_ := TRUE;
      END IF;
      IF options_ IS NOT NULL AND Message_SYS.Find_Attribute(options_, 'EXPORT_VIEWS_ONLY', 'FALSE') = 'TRUE' THEN
         export_views_only_ := TRUE;
      END IF;
      key_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_);
      IF NOT export_views_only_ THEN
         Custom_Fields_API.Export_Xml(xml_, key_.lu, key_.attribute_name, export_views_);
      ELSE
         Custom_Fields_API.Export_Views_XML(xml_, key_.lu);
      END IF;
   END;
$ELSE
   RETURN;
$END
END Export_Custom_Field___;

PROCEDURE Export_Custom_Enumeration___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   Custom_Enumeration_Util_API.Export_XML(xml_, Custom_Enumerations_API.Get_Key_By_Rowkey(rowkey_).lu);
$ELSE
   RETURN;
$END
END Export_Custom_Enumeration___;

PROCEDURE Export_Custom_Lu___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   Custom_Lus_API.Export_Xml(xml_, Custom_Lus_API.Get_Key_By_Rowkey(rowkey_).lu );
$ELSE
   RETURN;
$END
END Export_Custom_Lu___;

PROCEDURE Export_Custom_Menu___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   Custom_Menu_API.Export_Xml__(xml_, Custom_Menu_API.Get_Key_By_Rowkey(rowkey_).menu_id);
END Export_Custom_Menu___;

PROCEDURE Export_Custom_Page___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   Custom_Pages_API.Export_Xml(xml_, Custom_Pages_API.Get_Key_By_Rowkey(rowkey_).page_name );
$ELSE
   RETURN;
$END
END Export_Custom_Page___;

PROCEDURE Export_Custom_Info_Card___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_ custom_field_attributes_tab%ROWTYPE;
   BEGIN      
      key_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_);   
      Custom_Info_Cards_API.Export_Xml(xml_, key_.lu, key_.attribute_name);
   END;
$ELSE
   RETURN;
$END
END Export_Custom_Info_Card___;

PROCEDURE Export_Custom_Tab___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2 )
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_ custom_tab_tab%ROWTYPE;
   BEGIN   
      key_ := Custom_Tab_API.Get_Key_By_Rowkey(rowkey_);     
      Custom_Tab_API.Export_Xml(xml_,key_.container_name,key_.version,key_.attached_page);
   END;
   
$ELSE
   RETURN;
$END
END Export_Custom_Tab___;

PROCEDURE Export_Cond_Field_Action___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   Conditional_Field_Action_API.Export_Xml(xml_, Conditional_Field_Action_API.Get_Key_By_Rowkey(rowkey_).action_id);
END Export_Cond_Field_Action___;

PROCEDURE Export_Custom_Event___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
   key_ fnd_event_tab%ROWTYPE;
BEGIN
   key_ := Fnd_Event_API.Get_Key_By_Rowkey(rowkey_);
   Fnd_Event_API.Export_Xml(xml_, key_.event_lu_name, key_.event_id);
END Export_Custom_Event___;

PROCEDURE Export_Quick_Report___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
   key_ quick_report_tab%ROWTYPE;
BEGIN
   key_ := Quick_Report_API.Get_Key_By_Rowkey(rowkey_);
   Quick_Report_API.Export_XML(xml_, key_.quick_report_id);
END Export_Quick_Report___;

PROCEDURE Export_Custom_Event_Action___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
   key_ fnd_event_action_tab%ROWTYPE;     
BEGIN
   key_ := Fnd_Event_Action_API.Get_Key_By_Rowkey(rowkey_);
   Fnd_Event_Action_API.Export_Xml(xml_, key_.event_lu_name, key_.event_id, key_.action_number);
END Export_Custom_Event_Action___;

PROCEDURE Export_Web_Page_Bundle___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Custom_Aurena_Page_API.Export_XML(xml_, rowkey_);
   $ELSE
      RETURN;
   $END
END Export_Web_Page_Bundle___;

PROCEDURE Export_Custom_Projection___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Custom_projection_api.Export_XML(xml_, rowkey_);
   $ELSE
      RETURN;
   $END
END Export_Custom_Projection___;


PROCEDURE Export_Custom_Projection_Config___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Projection_Config_API.Export_XML(xml_, rowkey_);
   $ELSE
      RETURN;
   $END
END Export_Custom_Projection_Config___;

PROCEDURE Export_Mobile_Application___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
$IF Component_Fndmob_SYS.INSTALLED $THEN
   DECLARE
      key_ mobile_application_version_tab%ROWTYPE;
   BEGIN   
      key_ := Mobile_Application_Version_API.Get_Key_By_Rowkey(rowkey_);
      Mobile_Application_Version_API.Export_Xml(xml_, key_.app_name, key_.app_version);
   END;   
$ELSE
   RETURN;
$END   
END Export_Mobile_Application___ ;

PROCEDURE Export_Configuration_Context___ (
   xml_   OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Configuration_Context_API.Export_XML(xml_, rowkey_);
   $ELSE
      RETURN;
   $END
END Export_Configuration_Context___;

PROCEDURE Export_Navigator_Configuration___ (
   xml_    OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Navigator_Config_Util_API.Export_XML(xml_, rowkey_);
   $ELSE
      RETURN;
   $END
END Export_Navigator_Configuration___;

PROCEDURE Export_Appearance_Config___ (
   xml_    OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   Fnd_Branding_API.Export_XML(xml_, Fnd_Branding_API.Get_Key_By_Rowkey(rowkey_).code);
END Export_Appearance_Config___;

PROCEDURE Export_Query_Artifact___ (
   xml_     OUT CLOB,
   rowkey_  IN VARCHAR2)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Query_Artifact_Util_API.Export_XML(xml_, Query_Artifact_API.Get_Key_By_Rowkey(rowkey_).query_name);
   $ELSE
      RETURN;
   $END
END Export_Query_Artifact___;

---------------------------------------------------------------------------------------------------------
-- File Name Methods
---------------------------------------------------------------------------------------------------------
   
FUNCTION Get_File_Name_Custom_Field___(
   rowkey_    IN VARCHAR2,
   item_type_ IN VARCHAR2) RETURN VARCHAR2
IS
    item_type_name_ VARCHAR2(50);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_rec_ custom_field_attributes_tab%ROWTYPE;          
      BEGIN
      IF item_type_ = App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
         item_type_name_ := 'CustomFieldPersistent';
      ELSIF item_type_ = App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
         item_type_name_ := 'CustomFieldReadOnly';
      ELSE
         item_type_name_ := item_type_;
      END IF;   
      key_rec_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_); 
      RETURN item_type_name_ || '-' || key_rec_.lu || '-' || key_rec_.attribute_name || '.xml';
   END;
$ELSE
   RETURN NULL;
$END
END Get_File_Name_Custom_Field___;

FUNCTION Get_File_Name_Custom_Enum___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
  
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_rec_ custom_enumerations_tab%ROWTYPE;
   BEGIN
      key_rec_ := Custom_Enumerations_API.Get_Key_By_Rowkey(rowkey_);      
      RETURN 'CustomEnumeration' || '-' || key_rec_.lu || '.xml';
   END;
$ELSE
   RETURN NULL;
$END
END Get_File_Name_Custom_Enum___;

FUNCTION Get_File_Name_Custom_Lu___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
  
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_rec_ custom_lus_tab%ROWTYPE;
   BEGIN
      key_rec_ := Custom_Lus_API.Get_Key_By_Rowkey(rowkey_);      
      RETURN 'CustomLogicalUnit' || '-' || key_rec_.lu || '.xml';
   END;
$ELSE
   RETURN NULL;
$END
END Get_File_Name_Custom_Lu___;

FUNCTION Get_File_Name_Custom_Page___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
  
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_rec_ custom_pages_tab%ROWTYPE;
   BEGIN
      key_rec_ := Custom_Pages_API.Get_Key_By_Rowkey(rowkey_);      
      RETURN 'CustomPage' || '-' || key_rec_.page_name || '.xml';
   END;
$ELSE
   RETURN NULL;
$END
END Get_File_Name_Custom_Page___;

FUNCTION Get_File_Name_Custom_Menu___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
   key_rec_ custom_menu_tab%ROWTYPE;
   window_name_ VARCHAR2(100);
BEGIN
   key_rec_ := Custom_Menu_API.Get_Key_By_Rowkey(rowkey_);
   window_name_ := Custom_Menu_API.Get_Window(key_rec_.menu_id);
   RETURN 'CustomMenu' || '-' || window_name_ || '-' || key_rec_.menu_id || '.xml';
END Get_File_Name_Custom_Menu___;

FUNCTION Get_File_Name_Info_Card__(
   rowkey_    IN VARCHAR2,
   item_type_ IN VARCHAR2) RETURN VARCHAR2
IS
  
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_rec_ custom_field_attributes_tab%ROWTYPE;      
   BEGIN
      key_rec_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_);      
      RETURN 'InformationCard' || '-' || key_rec_.lu || '-' || key_rec_.attribute_name || '.xml';
   END;
$ELSE
   RETURN NULL;
$END
END Get_File_Name_Info_Card__;

FUNCTION Get_File_Name_Custom_Tab___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
  
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_rec_ custom_tab_tab%ROWTYPE;      
   BEGIN
      key_rec_ := Custom_Tab_API.Get_Key_By_Rowkey(rowkey_);     
      IF key_rec_.version = '*' THEN
         RETURN 'CustomTab' || '-' || key_rec_.container_name || '-' || key_rec_.attached_page  || '.xml';
      ELSE
         RETURN 'CustomTab' || '-' || key_rec_.container_name || '-' || key_rec_.version  || '-' || key_rec_.attached_page  || '.xml';
      END IF;
   END;
$ELSE
   RETURN NULL;
$END
END Get_File_Name_Custom_Tab___;
 
FUNCTION Get_File_Name_Co_Field_Act___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
   key_rec_ conditional_field_action_tab%ROWTYPE;
   name_ VARCHAR2(100);
BEGIN
   key_rec_ := Conditional_Field_Action_API.Get_Key_By_Rowkey(rowkey_);
   name_ := Conditional_Field_Action_API.Get_Name_By_Rowkey(rowkey_);
   RETURN 'ConditionalField' || '-' || regexp_replace(name_, '[/?<>\:*|"]', '#') || '-' || key_rec_.action_id || '.xml';
END Get_File_Name_Co_Field_Act___;

FUNCTION Get_File_Name_Custom_Event___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
   key_rec_ fnd_event_tab%ROWTYPE;
BEGIN
   key_rec_ := Fnd_Event_API.Get_Key_By_Rowkey(rowkey_);
   RETURN 'CustomEvent' || '-' || key_rec_.event_lu_name || '-' || key_rec_.event_id || '.xml';
END Get_File_Name_Custom_Event___;

FUNCTION Get_File_Name_Quick_Report___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
   key_rec_ quick_report_tab%ROWTYPE;
BEGIN
   key_rec_ := Quick_Report_API.Get_Key_By_Rowkey(rowkey_);
   RETURN 'QuickReport' || '-' || key_rec_.quick_report_id || '.xml';
END Get_File_Name_Quick_Report___;

FUNCTION Get_File_Name_Aurena_Page_Group___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
   model_id_ FND_MODEL_DESIGN_TAB.model_id%TYPE;
BEGIN
   
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      aprowrec_ Custom_Aurena_Page_API.Public_Rec;      
   BEGIN
      aprowrec_:= Custom_Aurena_Page_API.Get_By_Rowkey(rowkey_);
      IF aprowrec_.page_name  IS NOT NULL THEN
         RETURN 'AurenaPageGroup' || '-' || aprowrec_.page_name || '.xml';
      ELSE
         model_id_ := REPLACE(rowkey_, ':', '.');
         RETURN 'AurenaPageGroup' || '-' || model_id_ || '.xml';
      END IF;
   END;
$ELSE
   model_id_ := REPLACE(rowkey_, ':', '.');
   RETURN 'AurenaPageGroup' || '-' || model_id_ || '.xml';
$END

END Get_File_Name_Aurena_Page_Group___;

FUNCTION Get_File_Name_Custom_Projection___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN 'CustomProjection' || '-' || Custom_Projection_API.Get_Name_By_Rowkey(rowkey_) || '.xml';
   $ELSE
      RETURN 'CustomProjection' || '-' || rowkey_ || '.xml';
   $END
END Get_File_Name_Custom_Projection___;

FUNCTION Get_File_Name_Custom_Projection_Config___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN 'ProjectionConfiguration' || '-' || Projection_Config_API.Get_Name_By_Rowkey(rowkey_) || '.xml';
   $ELSE
      RETURN 'ProjectionConfiguration' || '-' || rowkey_ || '.xml';
   $END
END Get_File_Name_Custom_Projection_Config___;

FUNCTION Get_File_Name_Cust_Eve_Act___(
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
   key_rec_ fnd_event_action_tab%ROWTYPE;
   event_action_type_ VARCHAR2(100);
BEGIN
   key_rec_ := Fnd_Event_Action_API.Get_Key_By_Rowkey(rowkey_);
   event_action_type_ := Fnd_Event_Action_API.Get_Fnd_Event_Action_Type_Db(key_rec_.event_lu_name, key_rec_.event_id, key_rec_.action_number);
   RETURN 'CustomEventAction' || '-' || key_rec_.event_lu_name || '-' || key_rec_.event_id || '-' || key_rec_.action_number || '-' || event_action_type_ ||'.xml';
END Get_File_Name_Cust_Eve_Act___;
   

FUNCTION Get_File_Name_Mobile_Application___ (
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
$IF Component_Fndmob_SYS.INSTALLED $THEN
   key_rec_ mobile_application_version_tab%ROWTYPE;
$END
BEGIN
$IF Component_Fndmob_SYS.INSTALLED $THEN
   key_rec_ := Mobile_Application_Version_API.Get_Key_By_Rowkey(rowkey_);
   RETURN 'MobileApplication' || '-' || key_rec_.app_name || '-' || key_rec_.app_version||'.xml';
$ELSE
   RETURN 'MobileApplication' || '-' || rowkey_ || '.xml';
$END
END Get_File_Name_Mobile_Application___;

FUNCTION Get_File_Name_Configuration_Context___ (
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN 'ConfigurationContext-'|| Configuration_Context_API.Get_By_Rowkey(rowkey_).scope_id||'.xml';
   $ELSE
      RETURN NULL;
   $END
END Get_File_Name_Configuration_Context___;

FUNCTION Get_File_Name_Navigator_Configuration___ (
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN 'NavigatorConfiguration-'|| Navigator_Config_Util_API.Get_Item_Name(rowkey_)||'.xml';
   $ELSE
      RETURN NULL;
   $END
END Get_File_Name_Navigator_Configuration___;

FUNCTION Get_File_Name_Appearance_Config___ (
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN 'AppearanceConfig-'|| Fnd_Branding_API.Get_By_Rowkey(rowkey_).name||'.xml';
END Get_File_Name_Appearance_Config___;

FUNCTION Get_File_Name_Query_Artifact___ (
   rowkey_    IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN 'QueryArtifact-'|| Query_Artifact_API.Get_Key_By_Rowkey(rowkey_).query_name||'.xml';
   $ELSE
      RETURN NULL;
   $END
END Get_File_Name_Query_Artifact___;

PROCEDURE Check_Item_Attached___ (
   item_id_    IN VARCHAR2 )
IS
   package_name_ app_config_package_tab.name%TYPE;
   package_id_   app_config_package_item_tab.package_id%TYPE;
BEGIN
   SELECT p.package_id, p.name INTO package_id_, package_name_
   FROM app_config_package_item_tab i, app_config_package_tab p
   WHERE configuration_item_id = item_id_
   AND   p.package_id = i.package_id
   FETCH FIRST 1 ROW ONLY;
   Error_SYS.Appl_General(lu_name_, 'ITEMALREADYATTACH: This item is already attached to packaged named :P1. Package ID :P2', package_name_, package_id_);
EXCEPTION
   WHEN no_data_found THEN
      NULL; -- OK
END Check_Item_Attached___;

   --
   -- Presentation Object 
   --
   
FUNCTION Get_Custom_Field_PO___(
   item_id_ IN VARCHAR2)RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Fields_API.Get_Po_Id(Custom_Field_Attributes_API.Get_Lu_By_Rowkey(item_id_), 'CUSTOM_FIELD');
$ELSE
   RETURN NULL;
$END
END Get_Custom_Field_PO___;

FUNCTION Get_Custom_Menu_PO___(
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN   
   RETURN Custom_Menu_API.Get_Po_Id(Custom_Menu_API.Get_Menu_Id_By_Rowkey(item_id_));
END Get_Custom_Menu_PO___;

FUNCTION Get_Quick_Report_PO___(
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN   
   RETURN Quick_Report_API.Get_Po_Id(Quick_Report_API.Get_Key_By_Rowkey(item_id_).quick_report_id);
END Get_Quick_Report_PO___;

FUNCTION Get_Custom_page_PO___(
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   po_id_ VARCHAR2(100);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT cp.po_id INTO po_id_
   FROM custom_pages cp 
   WHERE cp.objkey = item_id_ ; 
   RETURN po_id_;
$ELSE
   RETURN NULL;
$END   
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Custom_page_PO___;
   
FUNCTION Get_Info_Card_PO___(
   item_id_ IN VARCHAR2)RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Info_Cards_API.Get_Po_Id(Custom_Field_Attributes_API.Get_Lu_By_Rowkey(item_id_), 'INFO_CARD');
$ELSE
   RETURN NULL;
$END
END Get_Info_Card_PO___; 


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT app_config_package_item_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(newrec_, indrec_, attr_);
   IF App_Config_Package_API.Get_Temporary_Package(newrec_.package_id) <> 'TRUE' THEN
   Check_Item_Attached___(newrec_.configuration_item_id);
   END IF;
END Check_Insert___;

PROCEDURE Get_Additional_Item_XML___ (
   xml_ OUT XMLType,
   additional_item_ IN item)
IS
BEGIN
  SELECT XMLElement("ADDITIONAL_ITEM",
                        XMLAgg(XMLForest(additional_item_.name as "NAME",
                                         additional_item_.type as "TYPE",
                                         additional_item_.description as "DESCRIPTION", 
                                         additional_item_.file_name as "FILENAME"))) INTO xml_
   FROM dual;
END Get_Additional_Item_XML___;

PROCEDURE Connect_Item_To_Package___ (
   info_         OUT VARCHAR2,
   item_id_       IN VARCHAR2,
   name_          IN VARCHAR2,  
   item_type_db_  IN VARCHAR2,
   package_id_    IN VARCHAR2,
   raise_error_   IN VARCHAR2 DEFAULT 'FALSE',
   auto_add_dependents_ IN BOOLEAN DEFAULT FALSE)
IS     
   rec_ app_config_package_item_tab%ROWTYPE;      
BEGIN     
   --Log existing connections
   IF Is_Item_In_Another_Pkg(package_id_, item_id_)  THEN
      IF raise_error_ = 'TRUE' THEN
         Error_Sys.Record_General(lu_name_, 'ITEMBELONGTOOTHERPKG: ":P1" is already in package ":P2"', name_, App_Config_Package_API.Get_Item_Package_Name(item_id_));
      ELSE
         App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'ITEMCONNECTED: ":P1" is currently in package ":P2". ":P1" will be removed from package ":P2".',Fnd_Session_API.Get_Language, name_, App_Config_Package_API.Get_Item_Package_Name(item_id_)), -1);          
      END IF;    
   END IF;
   -- Remove current connections
   DELETE FROM app_config_package_item_tab
   WHERE 
   configuration_item_id = item_id_
   AND package_id <> package_id_;
      
   IF NOT Check_Exist___(package_id_,item_id_) THEN      
      Prepare_New___(rec_);
      rec_.package_id            := package_id_;
      rec_.configuration_item_id := item_id_;
      rec_.item_type             := item_type_db_;
      New___(rec_);
      
      App_Config_Package_API.Set_Package_Modified(package_id_);
         
      IF auto_add_dependents_ THEN
         IF item_type_db_ = App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
            DECLARE
               custom_lu_rowkey_ VARCHAR2(100);
               msg_ VARCHAR2(32000);
               add_cust_lu_name_ VARCHAR2(1000);
               temp_info_ VARCHAR2(32000);
            BEGIN
               IF Add_Attached_Custom_Lu___(temp_info_, add_cust_lu_name_, custom_lu_rowkey_, package_id_, item_id_, raise_error_, auto_add_dependents_) THEN
                  IF temp_info_ IS NOT NULL THEN
                     temp_info_ := newline_ || temp_info_;
                  END IF;
                  info_ := Language_SYS.Translate_Constant(lu_name_, 'LUADDED: Custom Logical Unit ":P1"',
                                                                         Fnd_Session_API.Get_Language, 
                                                                         add_cust_lu_name_, App_Config_Package_API.Get_Name(package_id_)) || temp_info_;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
                  msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                                           'LUADDFAILED2: Error occured while adding Custom logical unit ":P1" to the package ":P2". Error: :P3',
                                                           Fnd_Session_API.Get_Language,
                                                           add_cust_lu_name_, App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
                  Log_SYS.App_Trace(Log_SYS.warning_, msg_);
                  App_Config_Util_API.Log_Warning(msg_);
            END;
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
            DECLARE
               custom_enum_rowkey_ VARCHAR2(100);
               msg_ VARCHAR2(32000);
               add_enum_name_ VARCHAR2(1000);
               temp_info_ VARCHAR2(32000);
            BEGIN
               IF Add_Attached_Custom_Enum___(temp_info_, add_enum_name_, custom_enum_rowkey_, package_id_, item_id_, raise_error_) THEN
                  IF temp_info_ IS NOT NULL THEN
                     temp_info_ := newline_ || temp_info_;
                  END IF;

                  info_ := temp_info_ || Language_SYS.Translate_Constant(lu_name_, 'ENUMADDED: Custom Enumeration ":P1"', 
                                                                                   Fnd_Session_API.Get_Language, 
                                                                                   add_enum_name_, App_Config_Package_API.Get_Name(package_id_)) || temp_info_;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
                  msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                                           'ENUMADDFAILED2: Error occured while adding Custom Enumeration ":P1" to the package ":P2". Error: :P3',
                                                           Fnd_Session_API.Get_Language,
                                                           add_enum_name_, App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
                  Log_SYS.App_Trace(Log_SYS.warning_, msg_);
                  App_Config_Util_API.Log_Warning(msg_);
            END;
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_CUSTOM_LU THEN
            info_ := Add_Used_Custom_Enums_In_Lu___(package_id_, item_id_, name_, raise_error_);
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
            info_ := Add_Actions_In_Event___(package_id_, item_id_);
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
            info_ := Add_Event_For_Action___(package_id_, item_id_);
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
            DECLARE
               msg_ VARCHAR2(32000);
               add_cust_lu_names_ VARCHAR2(32000);
               temp_info_ VARCHAR2(32000);
            BEGIN
               IF Add_Custom_Lus_From_Custom_Projection___(temp_info_, add_cust_lu_names_, package_id_, item_id_, raise_error_, auto_add_dependents_) THEN
                  IF temp_info_ IS NOT NULL THEN
                     temp_info_ := newline_ || temp_info_;
                  END IF;
                  IF add_cust_lu_names_ IS NOT NULL THEN 
                     info_ := Language_SYS.Translate_Constant(lu_name_, 'LUSADDED: Custom Logical Units ":P1"',
                                                                         Fnd_Session_API.Get_Language, 
                                                                         add_cust_lu_names_,
                                                                         App_Config_Package_API.Get_Name(package_id_))
                                                                         || temp_info_;
                  ELSE
                     info_ := temp_info_;
                  END IF;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
                  msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                                           'LUSADDFAILED2: Error occured while adding Custom logical units ":P1" to the package ":P2". Error: :P3',
                                                           Fnd_Session_API.Get_Language,
                                                           add_cust_lu_names_, App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
                  Log_SYS.App_Trace(Log_SYS.warning_, msg_);
                  App_Config_Util_API.Log_Warning(msg_);
                  info_ := msg_;
            END;
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN
            DECLARE
               msg_ VARCHAR2(32000);
               added_dependencies_ VARCHAR2(32000);
               temp_info_ VARCHAR2(32000);
            BEGIN
               IF Add_ProjConfig_Dependencies___(temp_info_, added_dependencies_, package_id_, item_id_, raise_error_, auto_add_dependents_) THEN
                  IF temp_info_ IS NOT NULL THEN
                     temp_info_ := newline_ || temp_info_;
                  END IF;
                  info_ :=  temp_info_;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
                  msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                                           'PCADDFAILED2: Error occured while adding Custom Projection Configuratio ":P1" to the package ":P2". Error: :P3',
                                                           Fnd_Session_API.Get_Language,
                                                           added_dependencies_, App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
                  Log_SYS.App_Trace(Log_SYS.warning_, msg_);
                  App_Config_Util_API.Log_Warning(msg_);
            END;   
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
            DECLARE
               msg_ VARCHAR2(32000);
               added_dependencies_ VARCHAR2(32000);
               temp_info_ VARCHAR2(32000);
               proj_config_skipped_ BOOLEAN;
            BEGIN
               IF Add_Aurena_Page_Dependencies___(temp_info_, added_dependencies_, proj_config_skipped_, package_id_, item_id_, raise_error_, auto_add_dependents_) THEN
                  info_ := temp_info_;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
                  msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                                           'PGADDFAILED2: Error occured while adding Aurena Page Groups ":P1" to the package ":P2". Error: :P3',
                                                           Fnd_Session_API.Get_Language,
                                                           App_Config_Util_API.Get_Item_Name(item_id_, App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP), App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
                  Log_SYS.App_Trace(Log_SYS.warning_, msg_);
                  App_Config_Util_API.Log_Warning(msg_);
                  info_ := msg_;
            END;
         ELSIF item_type_db_ = App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
            Add_Attached_Context___(info_, package_id_, item_id_, raise_error_, auto_add_dependents_);
         END IF;
      END IF; 
   END IF;
END Connect_Item_To_Package___;   

FUNCTION Add_Used_Custom_Enums_In_Lu___ (
   package_id_  IN VARCHAR2,
   lu_rowkey_   IN VARCHAR2,
   lu_name_     IN VARCHAR2,
   raise_error_ IN VARCHAR2) RETURN VARCHAR2
IS
   info_ VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      custom_enum_rowkey_ VARCHAR2(100);
      msg_ VARCHAR2(32000);
      add_enum_name_ok_     VARCHAR2(32000);
      add_enum_name_temp_   VARCHAR2(1000);
      temp_info_ VARCHAR2(32000);

      CURSOR Get_Enum_Fields IS
         SELECT t.rowkey
         FROM custom_field_attributes_tab t, custom_lus_tab l
         WHERE t.lu  = l.lu
         AND t.lu_type = l.lu_type
         AND l.rowkey = lu_rowkey_
         AND t.data_type = Custom_Field_Data_Types_API.DB_ENUMERATION;        
   BEGIN
      FOR rec_ IN get_enum_fields LOOP
         BEGIN
            IF Add_Attached_Custom_Enum___(temp_info_, add_enum_name_temp_, custom_enum_rowkey_, package_id_, rec_.rowkey, raise_error_) THEN
               add_enum_name_ok_ := add_enum_name_ok_ || '"' ||add_enum_name_temp_ || '" ,';
            END IF;
         EXCEPTION
            WHEN OTHERS THEN
               Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
               msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                                        'ENUMADDFAILED2: Error occured while adding Custom Enumeration ":P1" to the package ":P2". Error: :P3',
                                                        Fnd_Session_API.Get_Language,
                                                        add_enum_name_temp_, App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
               Log_SYS.App_Trace(Log_SYS.warning_, msg_);
               App_Config_Util_API.Log_Warning(msg_);
         END;
      END LOOP;
      IF add_enum_name_ok_ IS NOT NULL THEN
         add_enum_name_ok_ := substr(add_enum_name_ok_, 1, length(add_enum_name_ok_)-1);
         info_ := Language_SYS.Translate_Constant(lu_name_, 'ENUMSADDED: Custom Enumeration(s) :P1 used by Custom Logical Unit ":P2"',
                                                  Fnd_Session_API.Get_Language, 
                                                  add_enum_name_ok_,
                                                  lu_name_);
      END IF;
   END;
$END
   RETURN info_;
END Add_Used_Custom_Enums_In_Lu___;

FUNCTION Add_Actions_In_Event___(
   package_id_ IN VARCHAR2,
   event_rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   event_rec_ fnd_event_tab%ROWTYPE := Fnd_Event_API.Get_Key_By_Rowkey(event_rowkey_);
   info_ VARCHAR2(32000);
   temp_info_ VARCHAR2(32000);
   added_actions_info_ VARCHAR2(32000);
   CURSOR get_event_actions IS
      SELECT rowkey 
      FROM fnd_event_action_tab
      WHERE event_id = event_rec_.event_id
      AND event_lu_name = event_rec_.event_lu_name;
BEGIN
   FOR event_action IN get_event_actions LOOP 
      IF Add_Attached_Event_Action___(temp_info_, package_id_, event_action.rowkey ) THEN
         added_actions_info_ := added_actions_info_ || '"' ||Fnd_Event_Action_API.Get_Name_By_Rowkey(event_action.rowkey) || '" ,';
      END IF;
   END LOOP;   
   added_actions_info_ := substr(added_actions_info_, 1, length(added_actions_info_)-1);
   IF added_actions_info_ IS NOT NULL THEN
      info_ := Language_SYS.Translate_Constant(lu_name_, 'ACTIONADDED: Event Action(s) :P1 was added to package ":P2"',
                                                             Fnd_Session_API.Get_Language, 
                                                             added_actions_info_, App_Config_Package_API.Get_Name(package_id_));
   END IF;
   RETURN info_;
END Add_Actions_In_Event___;

FUNCTION Add_Event_For_Action___(
   package_id_ IN VARCHAR2,
   event_action_rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   info_ VARCHAR2(32000);
   temp_info_ VARCHAR2(32000);
   added_event_info_ VARCHAR2(32000);
   event_action_key_ fnd_event_action_tab%ROWTYPE := Fnd_Event_Action_API.Get_Key_By_Rowkey(event_action_rowkey_);
   event_rowkey_ VARCHAR2(2000);
   event_type_ VARCHAR2(200);
BEGIN
   event_rowkey_ := Fnd_Event_API.Get_Objkey(event_action_key_.event_lu_name, event_action_key_.event_id);
   event_type_ := Fnd_Event_API.Get_Event_Type_Db_By_Rowkey(event_rowkey_);
   IF event_type_ = Fnd_Event_Type_API.DB_APPLICATION_DEFINED THEN
      RETURN info_;
   END IF;
   IF Add_Attached_Event___(temp_info_, package_id_, event_rowkey_ ) THEN
      added_event_info_ := '"' ||event_action_key_.event_id || '"';
   END IF;
   IF added_event_info_ IS NOT NULL THEN
      info_ := Language_SYS.Translate_Constant(lu_name_, 'ACTIONADDED2: Event :P1 was added to package ":P2"',
                                                             Fnd_Session_API.Get_Language, 
                                                             added_event_info_, App_Config_Package_API.Get_Name(package_id_));
   END IF;
   RETURN info_;
END Add_Event_For_Action___;

FUNCTION Add_Attached_Custom_Lu___ (
   info_             OUT VARCHAR2,
   name_             OUT VARCHAR2,
   custom_lu_rowkey_ OUT VARCHAR2,
   package_id_        IN VARCHAR2,
   page_rowkey_       IN VARCHAR2,
   raise_error_       IN VARCHAR2,
   auto_add_dependents_ IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN
IS
   lu_                    VARCHAR2(100);
   msg_   VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   lu_ := Custom_Pages_API.Get_LU_By_Rowkey(page_rowkey_);
   custom_lu_rowkey_ := Custom_Lus_API.Get_Objkey(lu_, Custom_Field_Lu_Types_API.DB_CUSTOM_LU);
      
   IF custom_lu_rowkey_ IS NOT NULL THEN
      name_ := App_Config_Util_API.Get_Item_Name(custom_lu_rowkey_, App_Config_Item_Type_API.DB_CUSTOM_LU);
      IF NOT Is_Item_In_Another_Pkg(package_id_, custom_lu_rowkey_) THEN
         
         IF NOT App_Config_Package_Item_API.Exists(package_id_, custom_lu_rowkey_) THEN
            Connect_Item_To_Package___(info_, custom_lu_rowkey_, name_, App_Config_Item_Type_API.DB_CUSTOM_LU, package_id_, raise_error_, auto_add_dependents_);
            RETURN TRUE;
         END IF;
      ELSE
         msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                 'LUNOTADDED: The Custom Logical Unit ":P1" which is used by the Custom Page ":P2" was not automatically added to the package because it is already attached to the package ":P3"',
                                                  Fnd_Session_API.Get_Language,
                                                  name_,
                                                  Custom_Pages_API.Get_Page_Title_By_Rowkey(page_rowkey_),
                                                  App_Config_Package_API.Get_Item_Package_Name(custom_lu_rowkey_));
         Log_SYS.App_Trace(Log_SYS.info_, msg_);
         App_Config_Util_API.Log_Info(msg_);
      END IF;
   END IF;
$END
   RETURN FALSE;
END Add_Attached_Custom_Lu___;

FUNCTION Add_Custom_Lus_From_Custom_Projection___ (
   info_                 OUT VARCHAR2,
   lu_names_             OUT VARCHAR2,
   package_id_           IN VARCHAR2,
   projection_rowkey_    IN VARCHAR2,
   raise_error_          IN VARCHAR2,
   auto_add_dependents_  IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN
IS
   projection_name_ VARCHAR2(128);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   projection_name_ := Custom_Projection_API.Get_Name_By_Rowkey(projection_rowkey_);
   RETURN Add_Custom_Lus_From_Projection_Config___(info_, lu_names_, package_id_, projection_name_, raise_error_, auto_add_dependents_);
$ELSE
   RETURN FALSE;
$END
END Add_Custom_Lus_From_Custom_Projection___;

FUNCTION Add_Custom_Lus_From_Projection_Config___ (
   info_                 OUT VARCHAR2,
   lu_names_             OUT VARCHAR2,
   package_id_           IN VARCHAR2,
   projection_name_      IN VARCHAR2,
   raise_error_          IN VARCHAR2,
   auto_add_dependents_  IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN
IS
   msg_   VARCHAR2(32000);
   name_ VARCHAR2(32000);
   have_custom_lus_ BOOLEAN := FALSE;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      custom_lu_rowkey_ VARCHAR2(100);
   
     CURSOR get_projection_lus (projection_name_ IN VARCHAR2) IS
      SELECT config_lu_name 
      FROM PROJECTION_CONFIG_ENTITY_TAB
      WHERE projection_name = projection_name_
      AND lu_type = 'CUSTOM';
   BEGIN
      FOR lurec_ IN get_projection_lus(projection_name_) LOOP
         have_custom_lus_ := TRUE;
         custom_lu_rowkey_ := Custom_Lus_API.Get_Objkey(lurec_.config_lu_name, Custom_Field_Lu_Types_API.DB_CUSTOM_LU);
         IF custom_lu_rowkey_ IS NOT NULL THEN
            name_ := App_Config_Util_API.Get_Item_Name(custom_lu_rowkey_, App_Config_Item_Type_API.DB_CUSTOM_LU);
            IF NOT Is_Item_In_Another_Pkg(package_id_, custom_lu_rowkey_) THEN

               IF NOT App_Config_Package_Item_API.Exists(package_id_, custom_lu_rowkey_) THEN
                  Connect_Item_To_Package___(info_, custom_lu_rowkey_, name_, App_Config_Item_Type_API.DB_CUSTOM_LU, package_id_, raise_error_, auto_add_dependents_);
                  IF lu_names_ IS NULL THEN
                     lu_names_ := name_;
                  ELSE
                     lu_names_ := lu_names_ || ', ' || name_;
                  END IF;
               END IF;
            ELSE
               msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                       'LUSINPCNOTADDED: The Custom Logical Unit ":P1" which is used by the Projection Config":P2" was not automatically added to the package because it is already attached to the package ":P3"',
                                                        Fnd_Session_API.Get_Language,
                                                        name_,
                                                        projection_name_,
                                                        App_Config_Package_API.Get_Item_Package_Name(custom_lu_rowkey_));
               Log_SYS.App_Trace(Log_SYS.info_, msg_);
               App_Config_Util_API.Log_Info(msg_);
               info_ := msg_;
            END IF;
         ELSE
            msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                          'LUSINPCNOTADDED2: The Custom Logical Unit ":P1" which is used by the Projection Config":P2" was not automatically added to the package because the Custom Logical Unit definition was not found',
                                                           Fnd_Session_API.Get_Language,
                                                           lurec_.config_lu_name,
                                                           projection_name_);
            Log_SYS.App_Trace(Log_SYS.info_, msg_);
            App_Config_Util_API.Log_Info(msg_);
            info_ := msg_;
         END IF;
      END LOOP;
      RETURN have_custom_lus_;   
   END;
$ELSE
   RETURN FALSE;
$END
END Add_Custom_Lus_From_Projection_Config___;

FUNCTION Add_ProjConfig_Dependencies___ (
   info_                 OUT VARCHAR2,
   projection_configs_   OUT VARCHAR2,
   package_id_           IN VARCHAR2,
   rowkey_               IN VARCHAR2,
   raise_error_          IN VARCHAR2,
   auto_add_dependents_  IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN
IS
   msg_   VARCHAR2(32000);
   custom_projection_name_ VARCHAR2(1000);
   custom_proj_rowkey_ VARCHAR2(100);
   temp_info_ VARCHAR2(32000);
   proj_config_type_ VARCHAR2(100);
   add_cust_lus_ VARCHAR2(32000);
   
$IF Component_Fndcob_SYS.INSTALLED $THEN
   proj_config_rec_ Projection_Config_API.Public_Rec;
$END
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   proj_config_rec_ := Projection_Config_Api.Get_By_Rowkey(rowkey_);
   custom_projection_name_ := proj_config_rec_.projection_name;
   proj_config_type_ := proj_config_rec_.configuration_type;
   
   IF proj_config_type_ = Proj_Config_Type_API.DB_CUSTOM OR proj_config_type_ = Proj_Config_Type_API.DB_CLU_DEFAULT THEN
      custom_proj_rowkey_ := Custom_Projection_API.Get_Objkey(custom_projection_name_);
        
      IF NOT Is_Item_In_Another_Pkg(package_id_, custom_proj_rowkey_) THEN
         IF NOT App_Config_Package_Item_API.Exists(package_id_, custom_proj_rowkey_) THEN
            Connect_Item_To_Package___(temp_info_, custom_proj_rowkey_, custom_projection_name_, App_Config_Item_Type_API.DB_CUSTOM_PROJECTION, package_id_, raise_error_, auto_add_dependents_);
            projection_configs_ := custom_projection_name_;
            
            IF temp_info_ IS NOT NULL THEN
               temp_info_ := newline_ || temp_info_;
            END IF;
            projection_configs_ := custom_projection_name_;
            info_ := Language_SYS.Translate_Constant(lu_name_, 'CUSTOMPROGADDED: Custom Projection ":P1"',
                                                                Fnd_Session_API.Get_Language, 
                                                                custom_projection_name_, 
                                                                App_Config_Package_API.Get_Name(package_id_)) || temp_info_;   
            RETURN TRUE;
         END IF;
      ELSE
         msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                 'PCNOTADDED: The Custom Projection ":P1" was not automatically added to the package because it is already attached to the package ":P3"',
                                                  Fnd_Session_API.Get_Language,
                                                  custom_projection_name_,
                                                  App_Config_Package_API.Get_Item_Package_Name(custom_proj_rowkey_));
         Log_SYS.App_Trace(Log_SYS.info_, msg_);
         App_Config_Util_API.Log_Info(msg_);
         info_ := msg_;
      END IF;
   ELSIF proj_config_type_ = Proj_Config_Type_API.DB_STANDARD THEN 
      IF Add_Custom_Lus_From_Projection_Config___(temp_info_, add_cust_lus_, package_id_, custom_projection_name_, raise_error_, auto_add_dependents_) THEN
         IF temp_info_ IS NOT NULL THEN
            temp_info_ := newline_ || temp_info_;
         END IF;
         projection_configs_ := custom_projection_name_;
         IF add_cust_lus_ IS NOT NULL THEN 
            info_ := Language_SYS.Translate_Constant(lu_name_, 'LUSADDED: Custom Logical Units ":P1"',
                                                                Fnd_Session_API.Get_Language, 
                                                                add_cust_lus_, 
                                                                App_Config_Package_API.Get_Name(package_id_)) || temp_info_;         
         ELSE
              info_ := temp_info_;
         END IF;

      END IF;    
   ELSE
      RETURN FALSE;
   END IF;
   RETURN TRUE;
$ELSE
   RETURN FALSE;
$END
END Add_ProjConfig_Dependencies___;

FUNCTION Add_Attached_Custom_Enum___ (
   info_             OUT VARCHAR2,
   name_             OUT VARCHAR2,
   enum_rowkey_      OUT VARCHAR2,
   package_id_        IN VARCHAR2,
   field_rowkey_      IN VARCHAR2,
   raise_error_       IN VARCHAR2) RETURN BOOLEAN
IS
   msg_   VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      keyrec_ custom_field_attributes_tab%ROWTYPE;
      public_rec_ Custom_Field_Attributes_API.Public_Rec;
   BEGIN
      keyrec_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(field_rowkey_);
      public_rec_ := Custom_Field_Attributes_API.Get(keyrec_.lu, keyrec_.lu_type, keyrec_.attribute_name);
      
      IF public_rec_.data_type = Custom_Field_Data_Types_API.DB_ENUMERATION THEN
         enum_rowkey_ := Custom_Enumerations_API.Get_Objkey(public_rec_.lu_reference);
         IF enum_rowkey_ IS NOT NULL THEN
            name_ := App_Config_Util_API.Get_Item_Name(enum_rowkey_, App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION);
            IF NOT Is_Item_In_Another_Pkg(package_id_, enum_rowkey_) THEN
               IF NOT App_Config_Package_Item_API.Exists(package_id_, enum_rowkey_) THEN
                  Connect_Item_To_Package___(info_, enum_rowkey_, name_, App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION, package_id_, raise_error_, FALSE);
                  RETURN TRUE;
               END IF;
            ELSE
               msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                                 'ENUMNOTADDED: The Enumeration ":P1" which is used by the Custom Field ":P2" was not automatically added to the package because it is already attached to the package ":P3"',
                                                  Fnd_Session_API.Get_Language,
                                                  name_,
                                                  Custom_Field_Attributes_API.Get_Prompt_By_Rowkey(field_rowkey_),
                                                  App_Config_Package_API.Get_Item_Package_Name(enum_rowkey_));
               Log_SYS.App_Trace(Log_SYS.info_, msg_);
               App_Config_Util_API.Log_Info(msg_);
            END IF;
         END IF;
      END IF;
   END;
$END
   RETURN FALSE;
END Add_Attached_Custom_Enum___;

FUNCTION Add_Attached_Event_Action___ (
   info_ OUT VARCHAR2,
   package_id_  IN VARCHAR2,
   event_action_rowkey_ IN VARCHAR2) RETURN BOOLEAN
IS
   msg_   VARCHAR2(32000);
BEGIN
   
   IF NOT App_Config_Package_Item_API.Exists(package_id_, event_action_rowkey_) AND NOT Is_Item_In_Another_Pkg(package_id_, event_action_rowkey_) THEN
      Add_Item_To_Package(info_, package_id_, event_action_rowkey_, App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION);
      RETURN TRUE;
   ELSE
      msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                        'ACTIONNOTADDED: The Event Action ":P1" was not automatically added to the package because it is already attached to the package ":P2"',
                                         Fnd_Session_API.Get_Language,
                                         Fnd_Event_Action_API.Get_Name_By_Rowkey(event_action_rowkey_),
                                         App_Config_Package_API.Get_Item_Package_Name(event_action_rowkey_));
      Log_SYS.App_Trace(Log_SYS.info_, msg_);
      App_Config_Util_API.Log_Info(msg_);
   END IF;
   RETURN FALSE;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
      msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                               'ACTIONADDFAILED: Error occured while adding Event Action ":P1" to the package ":P2". Error: :P3',
                                               Fnd_Session_API.Get_Language,
                                               Fnd_Event_Action_API.Get_Name_By_Rowkey(event_action_rowkey_), App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
      Log_SYS.App_Trace(Log_SYS.warning_, msg_);
      App_Config_Util_API.Log_Warning(msg_);   
   END Add_Attached_Event_Action___;

FUNCTION Add_Attached_Event___ (
   info_ OUT VARCHAR2,
   package_id_  IN VARCHAR2,
   event_rowkey_ IN VARCHAR2) RETURN BOOLEAN
IS
   msg_   VARCHAR2(32000);
BEGIN
   
   IF NOT App_Config_Package_Item_API.Exists(package_id_, event_rowkey_) AND NOT Is_Item_In_Another_Pkg(package_id_, event_rowkey_) THEN
      Add_Item_To_Package(info_, package_id_, event_rowkey_, App_Config_Item_Type_API.DB_CUSTOM_EVENT);
      RETURN TRUE;
   ELSE
      msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                        'ACTIONNOTADDED2: The Event ":P1" was not automatically added to the package because it is already attached to the package ":P2"',
                                         Fnd_Session_API.Get_Language,
                                         Fnd_Event_API.Get_Event_Id_By_Rowkey(event_rowkey_),
                                         App_Config_Package_API.Get_Item_Package_Name(event_rowkey_));
      Log_SYS.App_Trace(Log_SYS.info_, msg_);
      App_Config_Util_API.Log_Info(msg_);
   END IF;
   RETURN FALSE;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
      msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                               'ACTIONADDFAILED: Error occured while adding Event Action ":P1" to the package ":P2". Error: :P3',
                                               Fnd_Session_API.Get_Language,
                                               Fnd_Event_API.Get_Event_Id_By_Rowkey(event_rowkey_), App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
      Log_SYS.App_Trace(Log_SYS.warning_, msg_);
      App_Config_Util_API.Log_Warning(msg_);   
END Add_Attached_Event___;

PROCEDURE Add_Attached_Context___ (
   info_ OUT VARCHAR2,
   package_id_ IN VARCHAR2,
   scope_id_   IN VARCHAR2,
   raise_error_ IN VARCHAR2,
   auto_add_dependents_ IN BOOLEAN)
IS
   scope_rowkey_ VARCHAR2(100);
   msg_ VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF Configuration_Context_API.Exists(scope_id_) THEN
      scope_rowkey_ := Configuration_Context_API.Get_Objkey(scope_id_);
      IF NOT App_Config_Package_Item_API.Exists(package_id_, scope_rowkey_) AND NOT Is_Item_In_Another_Pkg(package_id_, scope_rowkey_) THEN
         Connect_Item_To_Package___(info_, scope_rowkey_, scope_id_, App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT, package_id_, raise_error_, auto_add_dependents_);
         info_ := info_ || Language_SYS.Translate_Constant(lu_name_, 
                                           'CONFIGADDED: Configuration Context ":P1".',
                                            Fnd_Session_API.Get_Language,
                                            scope_id_);
      ELSE
         msg_ := Language_SYS.Translate_Constant(lu_name_, 
                                           'CONFIGNOTADDED2: The related Configuration Context ":P1" was not automatically added to the package because it is already attached to the package ":P2"',
                                            Fnd_Session_API.Get_Language,
                                            scope_id_,
                                            App_Config_Package_API.Get_Item_Package_Name(scope_id_));
         Log_SYS.App_Trace(Log_SYS.info_, msg_);
         App_Config_Util_API.Log_Info(msg_);
      END IF;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      Log_SYS.App_Trace(Log_SYS.debug_, dbms_utility.format_error_backtrace);
      msg_ := Language_SYS.Translate_Constant (lu_name_, 
                                               'CONFIGADDFAILED: Error occured while adding Configuration Context ":P1" to the package ":P2". Error: :P3',
                                               Fnd_Session_API.Get_Language,
                                               scope_id_, App_Config_Package_API.Get_Name(package_id_), substr(sqlerrm,1,200));
      Log_SYS.App_Trace(Log_SYS.warning_, msg_);
      App_Config_Util_API.Log_Warning(msg_);
$ELSE
   NULL;
$END
END Add_Attached_Context___;

@Override   
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     app_config_package_item_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   super(objid_, remrec_);
   --Add post-processing code here
   App_Config_Package_API.Set_Package_Modified(remrec_.package_id);
END Delete___;





-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- Add_Item_To_Package will add dependent items as well
PROCEDURE Add_Item_To_Package (
   info_          IN OUT VARCHAR2,
   package_id_    IN VARCHAR2,
   item_id_       IN VARCHAR2,
   item_type_db_  IN VARCHAR2)
IS
   temp_info_  VARCHAR2(32000);
   name_ VARCHAR2(4000);
   msg_ VARCHAR2(32000);
BEGIN
   name_ := Get_Config_Item_Name(package_id_, item_id_, item_type_db_);
   Connect_Item_To_Package___(temp_info_, item_id_, name_, item_type_db_, package_id_, 'TRUE', TRUE);
   msg_ := Language_SYS.Translate_Constant(lu_name_,'ITEM_CONNECTED: ":P1" is added to package ":P2".',Fnd_Session_API.Get_Language, name_, App_Config_Package_API.Get_Name(package_id_) );
   App_Config_Util_API.Log_Info(msg_,-2);
   
   IF temp_info_ IS NOT NULL THEN
      Client_SYS.Add_Info(lu_name_, 'AUTOADD: This item uses other configurations. The following were also added to the package: ":P1" '|| newline_ || newline_ || temp_info_, App_Config_Package_API.Get_Name(package_id_));
   END IF;
   info_ := Client_SYS.Get_All_Info;
END Add_Item_To_Package;
   
PROCEDURE Connect_Item_To_Package (
   item_id_       IN VARCHAR2,
   name_          IN VARCHAR2,  
   item_type_db_  IN VARCHAR2,
   package_id_    IN VARCHAR2,
   raise_error_   IN VARCHAR2 DEFAULT 'FALSE',
   is_import_mode_ IN BOOLEAN DEFAULT FALSE)
IS
   msg_ VARCHAR2(32000);
   info_ VARCHAR2(32000);
BEGIN
   IF NOT Check_Exist___(package_id_,item_id_) THEN      
      Connect_Item_To_Package___(info_, item_id_, name_, item_type_db_, package_id_, raise_error_, FALSE); -- Currently, Do not auto add items in this method
      msg_ := Language_SYS.Translate_Constant(lu_name_,'ITEM_CONNECTED: ":P1" is added to package ":P2".',Fnd_Session_API.Get_Language, name_, App_Config_Package_API.Get_Name(package_id_) );
      App_Config_Util_API.Log_Info(msg_);
   END IF;
END Connect_Item_To_Package;

PROCEDURE Connect_Item_To_Package (
   package_id_    IN VARCHAR2,
   item_id_       IN VARCHAR2,
   item_type_db_  IN VARCHAR2,
   is_import_mode_ IN BOOLEAN DEFAULT FALSE)
IS
   name_ VARCHAR2(4000);
BEGIN
   name_ := Get_Config_Item_Name(package_id_, item_id_, item_type_db_);
   Connect_Item_To_Package(item_id_, name_, item_type_db_, package_id_, 'TRUE', is_import_mode_);
END Connect_Item_To_Package;

PROCEDURE Connect_Item_To_Temp_Package (   
   item_id_       IN VARCHAR2,
   item_type_db_  IN VARCHAR2,
   package_id_    IN VARCHAR2 )
IS     
   rec_ app_config_package_item_tab%ROWTYPE;      
BEGIN
   IF (App_Config_Package_API.Get_Temporary_Package(package_id_) = 'TRUE') THEN      
      IF NOT Check_Exist___(package_id_,item_id_) THEN      
         Prepare_New___(rec_);
         rec_.package_id            := package_id_;
         rec_.configuration_item_id := item_id_;
         rec_.item_type             := item_type_db_;
         New___(rec_);                
      END IF; 
   END IF;
END Connect_Item_To_Temp_Package;

@UncheckedAccess
FUNCTION Get_Config_Item_Name (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   in_item_type_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
   item_type_ app_config_package_item_tab.item_type%TYPE;
BEGIN
   IF in_item_type_ IS NOT NULL THEN
      item_type_ := in_item_type_;
   ELSE
      item_type_ := Get_Item_Type_Db(package_id_, config_item_id_);
   END IF;
   RETURN App_Config_Util_API.Get_Item_Name(config_item_id_, item_type_);      
END Get_Config_Item_Name;

@UncheckedAccess
FUNCTION Get_Config_Item_Description (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   in_item_type_   IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   item_type_ app_config_package_item_tab.item_type%TYPE;
BEGIN
   IF in_item_type_ IS NOT NULL THEN
      item_type_ := in_item_type_;
   ELSE
      item_type_ := Get_Item_Type_Db(package_id_, config_item_id_);
   END IF;
   RETURN App_Config_Util_API.Get_Item_Description (config_item_id_, item_type_);
END Get_Config_Item_Description;

@UncheckedAccess
FUNCTION Get_Config_Item_File_Name (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   in_item_type_   IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   item_type_ app_config_package_item_tab.item_type%TYPE;
BEGIN
   IF in_item_type_ IS NOT NULL THEN
      item_type_ := in_item_type_;
   ELSE
      item_type_ := Get_Item_Type_Db(package_id_, config_item_id_);
   END IF;
   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      RETURN Get_File_Name_Custom_Field___(config_item_id_, item_type_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      RETURN Get_File_Name_Custom_Field___(config_item_id_, item_type_);   
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      RETURN Get_File_Name_Custom_Enum___(config_item_id_);      
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      RETURN Get_File_Name_Custom_Menu___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
      RETURN Get_File_Name_Custom_Lu___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
      RETURN Get_File_Name_Custom_Page___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
      RETURN Get_File_Name_Info_Card__(config_item_id_, item_type_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
      RETURN Get_File_Name_Custom_Tab___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
      RETURN Get_File_Name_Co_Field_Act___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
      RETURN Get_File_Name_Custom_Event___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
      RETURN Get_File_Name_Cust_Eve_Act___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
      RETURN Get_File_Name_Quick_Report___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
      RETURN Get_File_Name_Aurena_Page_Group___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
      RETURN Get_File_Name_Custom_Projection___(config_item_id_);   
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN
      RETURN Get_File_Name_Custom_Projection_Config___(config_item_id_);   
   WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
      RETURN Get_File_Name_Mobile_Application___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
      RETURN Get_File_Name_Configuration_Context___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
      RETURN Get_File_Name_Navigator_Configuration___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
      RETURN Get_File_Name_Appearance_Config___(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
      RETURN Get_File_Name_Query_Artifact___(config_item_id_);
   ELSE
      RETURN NULL;
   END CASE;  
END Get_Config_Item_File_Name;

@UncheckedAccess
FUNCTION Get_Config_Item_Def_Modified (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   in_item_type_   IN VARCHAR2 DEFAULT NULL) RETURN DATE
IS
   item_type_ app_config_package_item_tab.item_type%TYPE;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF in_item_type_ IS NOT NULL THEN
      item_type_ := in_item_type_;
   ELSE
      item_type_ := Get_Item_Type_Db(package_id_, config_item_id_);
   END IF;
   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      RETURN Custom_Field_Attributes_Api.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      RETURN Custom_Field_Attributes_Api.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      RETURN Custom_Enumerations_Api.Get_Def_Modified_By_Rowkey(config_item_id_);      
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      RETURN Custom_Menu_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
      RETURN Custom_Lus_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
      RETURN Custom_Pages_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
      RETURN Custom_Field_Attributes_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
      RETURN Custom_Tab_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
      RETURN Conditional_Field_Action_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
      RETURN Fnd_Event_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
      RETURN Fnd_Event_Action_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
      RETURN Quick_Report_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
      RETURN Custom_Aurena_Page_API.Get_Data_Version(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
      RETURN CUSTOM_PROJECTION_API.Get_Def_Modified_By_Rowkey(config_item_id_);   
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN
      RETURN Projection_Config_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
      RETURN Configuration_Context_Api.Get_By_Rowkey(config_item_id_).rowversion;
   WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
      RETURN Navigator_Config_Util_API.Get_Last_Modified_Date(config_item_id_, 90);
   WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
      RETURN Fnd_Branding_API.Get_Def_Modified_By_Rowkey(config_item_id_);
   WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
      RETURN Query_Artifact_Api.Get_Def_Modified_By_Rowkey(config_item_id_); 
   $IF Component_Fndmob_SYS.INSTALLED $THEN
   WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
      RETURN Mobile_Application_Version_API.Get_Def_Modified_By_Rowkey(config_item_id_ );
   $END
   ELSE
      RETURN NULL;
   END CASE;
$ELSE
   RETURN NULL;
$END
END Get_Config_Item_Def_Modified;

@UncheckedAccess
FUNCTION Get_Config_Item_Metadata (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   in_item_type_   IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   item_type_ app_config_package_item_tab.item_type%TYPE;
BEGIN
   IF in_item_type_ IS NOT NULL THEN
      item_type_ := in_item_type_;
   ELSE
      item_type_ := Get_Item_Type_Db(package_id_, config_item_id_);
   END IF;
   RETURN App_Config_Util_API.Get_Item_Metadata(config_item_id_, item_type_);
END Get_Config_Item_Metadata;

@UncheckedAccess
FUNCTION Get_Config_Item_Dependents (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   in_item_type_   IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   item_type_ app_config_package_item_tab.item_type%TYPE;
BEGIN
   IF in_item_type_ IS NOT NULL THEN
      item_type_ := in_item_type_;
   ELSE
      item_type_ := Get_Item_Type_Db(package_id_, config_item_id_);
   END IF;
   RETURN App_Config_Util_API.Get_Config_Item_Dependents(config_item_id_, item_type_);
END Get_Config_Item_Dependents;

PROCEDURE Export_Configuration_Item (
   item_export_   OUT CLOB,
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   in_item_type_   IN VARCHAR2 DEFAULT NULL,
   in_options_     IN VARCHAR2 DEFAULT NULL )
IS
   item_type_ app_config_package_item_tab.item_type%TYPE;
   options_ VARCHAR2(32000);
BEGIN
   IF in_item_type_ IS NOT NULL THEN
      item_type_ := in_item_type_;
   ELSE
      item_type_ := Get_Item_Type_Db(package_id_, config_item_id_);
   END IF;
   IF in_options_ IS NULL THEN
      options_ := Message_SYS.Construct('OPTIONS');
   ELSE
      options_ := in_options_;
   END IF;
   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      -- In single item mode, always include the views
      Message_SYS.Set_Attribute(options_, 'EXPORT_VIEWS', 'TRUE');
      Export_Custom_Field___(item_export_, config_item_id_, options_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      -- In single item mode, always include the views
      Message_SYS.Set_Attribute(options_, 'EXPORT_VIEWS', 'TRUE');
      Export_Custom_Field___(item_export_, config_item_id_, options_);   
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      Export_Custom_Enumeration___(item_export_, config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      Export_Custom_Menu___(item_export_, config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
      Export_Custom_Lu___(item_export_, config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
      Export_Custom_Page___(item_export_, config_item_id_);
   WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
      Export_Custom_Info_Card___(item_export_, config_item_id_); 
   WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
      Export_Custom_Tab___(item_export_, config_item_id_);   
   WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
      Export_Cond_Field_Action___(item_export_, config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
      Export_Custom_Event___(item_export_, config_item_id_);   
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
      Export_Custom_Event_Action___(item_export_, config_item_id_);
   WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
      Export_Quick_Report___(item_export_, config_item_id_);
   WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
      Export_Web_Page_Bundle___(item_export_,config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
      Export_Custom_Projection___(item_export_,config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN
      Export_Custom_Projection_Config___(item_export_,config_item_id_);
   WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
      Export_Mobile_Application___(item_export_,config_item_id_);
   WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
      Export_Configuration_Context___(item_export_,config_item_id_);
   WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
      Export_Navigator_Configuration___(item_export_,config_item_id_);
   WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
      Export_Appearance_Config___(item_export_,config_item_id_);
   WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
      Export_Query_Artifact___(item_export_,config_item_id_);
   ELSE
      RETURN;
   END CASE;  
END Export_Configuration_Item;

PROCEDURE Export_Configuration_Items (
   out_additional_items_ OUT Xmltype,
   items_export_   IN OUT CLOB,
   package_id_     IN VARCHAR2,
   in_options_     IN VARCHAR2 DEFAULT NULL )
IS
   last_lu_name_ VARCHAR2(100);
   options_ VARCHAR2(2000);
   temp_ CLOB;
   file_name_ VARCHAR2(1000);
   i_ NUMBER := 1;
   additional_items_ items := items();
   item_ XMLType;
BEGIN
   FOR rec1_ IN (SELECT package_id,configuration_item_id, item_type FROM app_config_package_item_tab WHERE package_id = package_id_ AND item_type NOT IN (App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT, App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY)) LOOP
      Export_Configuration_Item(temp_, rec1_.package_id, rec1_.configuration_item_id, rec1_.item_type);
      file_name_ := Get_Config_Item_File_Name(rec1_.package_id, rec1_.configuration_item_id);
      Message_SYS.Add_Clob_Attribute(items_export_, 'APP_CONFIG_PACKAGE_ITEM ('|| file_name_ ||')' , temp_);
   END LOOP;
   
   -- Special handling for Custom Field 
   -- to avoid duplication of meta data related to custom field views
$IF Component_Fndcob_SYS.INSTALLED $THEN
   FOR rec2_ IN (SELECT i.package_id,i.configuration_item_id, i.item_type, a.lu 
                 FROM app_config_package_item_tab i, custom_field_attributes_tab a 
                 WHERE package_id = package_id_ AND item_type IN (App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT, App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY)
                 AND i.configuration_item_id = a.rowkey
                 ORDER BY a.lu) LOOP
      IF options_ IS NULL THEN
         options_ := Message_SYS.Construct('OPTIONS');
      ELSE
         options_ := in_options_;
      END IF;
      -- Set the EXPORT_VIEWS option to FALSE
      Message_SYS.Set_Attribute(options_, 'EXPORT_VIEWS', 'FALSE');
      
      IF last_lu_name_ IS NULL OR last_lu_name_ <> rec2_.lu THEN
         Custom_Fields_API.Export_Views_XML(temp_, rec2_.lu);
         file_name_ := 'CustomFieldViews-' || rec2_.lu || '.xml';
         Message_SYS.Add_Clob_Attribute(items_export_, 'APP_CONFIG_PACKAGE_ITEM (' || file_name_ || ')' , temp_);
         additional_items_.EXTEND(1);
         additional_items_(i_).name := 'Views-'||rec2_.lu;
         additional_items_(i_).description  := 'Views Files for '||rec2_.lu;
         additional_items_(i_).type := App_Config_Item_Type_API.DB_CUSTOM_FIELD_VIEWS;
         additional_items_(i_).file_name := file_name_;
         i_ := i_+1;
         IF dbms_lob.Istemporary(temp_) = 1 THEN
            dbms_lob.Freetemporary(temp_);
         END IF;
      END IF; 
      Export_Configuration_Item(temp_, rec2_.package_id, rec2_.configuration_item_id, rec2_.item_type, options_);
      file_name_ := Get_Config_Item_File_Name(rec2_.package_id, rec2_.configuration_item_id);
      Message_SYS.Add_Clob_Attribute(items_export_, 'APP_CONFIG_PACKAGE_ITEM ('|| file_name_ ||')' , temp_);
      IF dbms_lob.Istemporary(temp_) = 1 THEN
         dbms_lob.Freetemporary(temp_);
      END IF;
      last_lu_name_ := rec2_.lu;
   END LOOP;
$END

   out_additional_items_ := XMLType('<ADDITIONAL_ITEMS></ADDITIONAL_ITEMS>');

   FOR j_ IN 1..i_-1 LOOP
      Get_Additional_Item_XML___(item_, additional_items_(j_));
      Utility_SYS.Add_XML_Element_Into(out_additional_items_, item_, '/ADDITIONAL_ITEMS');
   END LOOP;

END Export_Configuration_Items;

PROCEDURE Publish_Package_Items (
    package_id_    IN VARCHAR2 )
IS 
BEGIN
   --Deploy IC, Custom Fields, Custom LU Custom Enum. By deploy of enum, cre , api, apy
$IF Component_Fndcob_SYS.INSTALLED $THEN
   Custom_Obj_SYS.Deploy_Package_Custom_Objects(package_id_,'TRUE');
$ELSE
   NULL;
$END
 
END Publish_Package_Items;
   
@UncheckedAccess
FUNCTION Get_PO_ID(
   package_id_ IN VARCHAR2,
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS     
   item_type_ app_config_package_item_tab.item_type%TYPE;

BEGIN          
   item_type_ := Get_Item_Type_Db(package_id_, item_id_);

   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      RETURN Get_Custom_Field_PO___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      RETURN Get_Custom_Field_PO___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      RETURN NULL;      
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      RETURN Get_Custom_Menu_PO___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
      RETURN Get_Custom_page_PO___(item_id_);
   WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
      RETURN Get_Info_Card_PO___(item_id_);
   WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
      RETURN Get_Quick_Report_PO___(item_id_);
   WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
      RETURN NULL; 
   ELSE
      RETURN '';
   END CASE;

END Get_PO_ID;

@UncheckedAccess
FUNCTION Get_Associated_Object(
   package_id_ IN VARCHAR2,
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   item_type_db_    VARCHAR2(100);
BEGIN
   item_type_db_ := Get_Item_Type_Db(package_id_, item_id_);
   RETURN App_Config_Util_API.Get_Associated_Object(item_id_, item_type_db_); 
END Get_Associated_Object;

@UncheckedAccess
FUNCTION Get_Item_Approved (
   package_id_ IN VARCHAR2,
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   item_type_db_    VARCHAR2(100); 
BEGIN  
   item_type_db_ := Get_Item_Type_Db(package_id_, item_id_);  
   RETURN App_Config_Util_API.Get_Item_Approved(item_id_, item_type_db_);
END Get_Item_Approved;

@UncheckedAccess
FUNCTION Get_Item_Published (
   package_id_ IN VARCHAR2,
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   item_type_db_    VARCHAR2(100); 
BEGIN  
   item_type_db_ := Get_Item_Type_Db(package_id_, item_id_);
   RETURN App_Config_Util_API.Get_Item_Published(item_id_, item_type_db_);
END Get_Item_Published;

@UncheckedAccess
FUNCTION Get_Item_Synchronized (
   package_id_ IN VARCHAR2,
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   item_type_db_    VARCHAR2(100); 
BEGIN  
   item_type_db_ := Get_Item_Type_Db(package_id_, item_id_);
   RETURN App_Config_Util_API.Get_Item_Synchronized(item_id_, item_type_db_);
END Get_Item_Synchronized;

@UncheckedAccess
FUNCTION Get_Item_Package_Id (
   configuration_item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   package_id_ app_config_package_tab.package_id%TYPE;
BEGIN
   SELECT package_id INTO package_id_
   FROM app_config_package_item_tab
   WHERE configuration_item_id = configuration_item_id_;
   RETURN package_id_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Item_Package_Id;
   
FUNCTION Is_Item_In_Another_Pkg (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2) RETURN BOOLEAN
IS
   CURSOR get_item_connections IS
      SELECT package_id 
      FROM app_config_package_item_tab
      WHERE configuration_item_id = config_item_id_;
   result_ BOOLEAN := FALSE;
BEGIN
   FOR conn_rec_ IN get_item_connections LOOP
      IF conn_rec_.package_id <> package_id_ THEN
         result_ := TRUE;  
      END IF;
   END LOOP;
   RETURN result_;
END Is_Item_In_Another_Pkg;

PROCEDURE Remove_Item (
   package_id_            IN VARCHAR2,
   configuration_item_id_ IN VARCHAR2)
IS
   remrec_ app_config_package_item_tab%ROWTYPE;
BEGIN
   remrec_ := Get_Object_By_Keys___(package_id_, configuration_item_id_);
   Remove___(remrec_);
END Remove_Item;

@UncheckedAccess
FUNCTION Get_Object_Name_By_Rowkey(
   rowkey_  IN VARCHAR2,
   lu_type_ IN VARCHAR2) RETURN VARCHAR2
IS
   object_name_ VARCHAR2(200);
   
$IF Component_Fndcob_SYS.INSTALLED $THEN
   CURSOR Get_CF_Name IS
   SELECT attribute_name 
   FROM custom_field_attributes_tab
   WHERE rowkey = rowkey_;

   CURSOR Get_IC_Name IS
   SELECT attribute_name 
   FROM custom_field_attributes_tab
   WHERE rowkey = rowkey_;

   CURSOR Get_CLU_Name IS
   SELECT lu
   FROM custom_lus_tab
   WHERE rowkey = rowkey_;

   CURSOR Get_CE_Name IS
   SELECT lu
   FROM CUSTOM_ENUMERATIONS_TAB
   WHERE rowkey = rowkey_;  
   
   CURSOR Get_CP_Name IS
   SELECT page_name 
   FROM custom_pages_tab
   WHERE rowkey = rowkey_;
   
   CURSOR Get_CT_Page_Name IS
   SELECT ct.attached_page   
   FROM CUSTOM_TAB_tab ct
   WHERE ct.rowkey = rowkey_;
   
   CURSOR Get_CFA_Name IS
   SELECT name 
   FROM conditional_field_action
   WHERE objkey = rowkey_;
   
   CURSOR Get_CProjection_Name IS
   SELECT projection_name
   FROM custom_projection
   WHERE objkey = rowkey_;
   
   CURSOR Get_CProjection_Config_Name IS
   SELECT projection_name
   FROM projection_config
   WHERE objkey = rowkey_;
   
 $END 
 
 BEGIN
 
 object_name_ := '' ;
 
 $IF Component_Fndcob_SYS.INSTALLED $THEN
   CASE lu_type_ 
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
        OPEN  Get_CF_Name;
        FETCH Get_CF_Name INTO object_name_ ;
        CLOSE Get_CF_Name;
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
        OPEN  Get_CF_Name;
        FETCH Get_CF_Name INTO object_name_ ;
        CLOSE Get_CF_Name;
      WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
        OPEN  Get_CLU_Name;
        FETCH Get_CLU_Name INTO object_name_ ;
        CLOSE Get_CLU_Name;
      WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
        OPEN  Get_IC_Name;
        FETCH Get_IC_Name INTO object_name_ ;
        CLOSE Get_IC_Name; 
      WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
        OPEN  Get_CE_Name;
        FETCH Get_CE_Name INTO object_name_ ;
        CLOSE Get_CE_Name;
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
        OPEN  Get_CP_Name;
        FETCH Get_CP_Name INTO object_name_ ;
        CLOSE Get_CP_Name; 
      WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN         
        OPEN  Get_CT_Page_Name;
        FETCH Get_CT_Page_Name INTO object_name_ ;
        CLOSE Get_CT_Page_Name; 
      WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
        OPEN  Get_CFA_Name;
        FETCH Get_CFA_Name INTO object_name_ ;
        CLOSE Get_CFA_Name;
      WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN         
         object_name_ := rowkey_;
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN         
        OPEN  Get_CProjection_Name;
        FETCH Get_CProjection_Name INTO object_name_ ;
        CLOSE Get_CProjection_Name;
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN         
        OPEN  Get_CProjection_Config_Name;
        FETCH Get_CProjection_Config_Name INTO object_name_ ;
        CLOSE Get_CProjection_Config_Name;  
      ELSE
         object_name_ := '';
   END CASE;  
$END

   RETURN object_name_; 
   
END Get_Object_Name_By_Rowkey;

PROCEDURE Make_Item_Translatable(
   package_id_ IN VARCHAR2,
   item_id_ IN VARCHAR2 )
IS
   item_type_db_    VARCHAR2(100); 
BEGIN  
   item_type_db_ := Get_Item_Type_Db(package_id_, item_id_);
   App_Config_Util_API.Make_Item_Translatable(item_id_, item_type_db_);
END Make_Item_Translatable;

FUNCTION Add_Aurena_Page_Dependencies___ (
   info_                 OUT VARCHAR2,
   lu_names_             OUT VARCHAR2,
   proj_config_skipped_  OUT BOOLEAN,
   package_id_           IN VARCHAR2,
   model_id_or_rowkey_   IN VARCHAR2,
   raise_error_          IN VARCHAR2,
   auto_add_dependents_  IN BOOLEAN DEFAULT TRUE) RETURN BOOLEAN
IS
   projection_name_ VARCHAR2(128);
   temp_info_       VARCHAR2(32000);
   add_cust_lus_    VARCHAR2(32000);
$IF Component_Fndcob_SYS.INSTALLED $THEN
   proj_config_ Projection_Config_API.Public_Rec;
   query_artifact_ Query_Artifact_API.Public_Rec;
$END
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   projection_name_:= Custom_Aurena_Page_API.Get_By_Rowkey(model_id_or_rowkey_).projection_name;
      
   IF projection_name_ IS NULL THEN
      projection_name_ := Get_Projection_For_Standard_Page_Model___(model_id_or_rowkey_);
   END IF;
   proj_config_ := Projection_Config_API.Get(projection_name_);
   
   IF proj_config_.rowkey IS NOT NULL THEN
      lu_names_ := projection_name_;
      IF proj_config_.configuration_type = Proj_Config_Type_API.DB_CLU_DEFAULT THEN
         proj_config_skipped_ := TRUE;
         --For this type of Projection Config, we directly add the Custom LUs as the projection is generated automatically from the Custom LU
         IF Add_Custom_Lus_From_Projection_Config___(temp_info_, add_cust_lus_, package_id_, projection_name_, raise_error_, auto_add_dependents_) THEN
            IF temp_info_ IS NOT NULL THEN
               temp_info_ := newline_ || temp_info_;
            END IF;
            info_ := Language_SYS.Translate_Constant(lu_name_, 'LUSADDED: Custom Logical Units ":P1"',
                                                                   Fnd_Session_API.Get_Language, 
                                                                   add_cust_lus_, 
                                                                   App_Config_Package_API.Get_Name(package_id_)) || temp_info_;
         END IF;  
      ELSE
         proj_config_skipped_ := FALSE;
          IF NOT Is_Item_In_Another_Pkg(package_id_, proj_config_.rowkey) THEN
            Connect_Item_To_Package___(info_, proj_config_.rowkey, projection_name_, App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG, package_id_, raise_error_, auto_add_dependents_);
          ELSE
             info_ := Language_SYS.Translate_Constant(lu_name_, 
                                                 'PROJNOTADDED: The Custom Projection ":P1" which is used by the Custom Page was not automatically added to the package because it is already attached to the package ":P2"',
                                                  Fnd_Session_API.Get_Language,
                                                  projection_name_,
                                                  App_Config_Package_API.Get_Item_Package_Name(proj_config_.rowkey));
          END IF;   
      END IF;
   ELSE
      query_artifact_ := Query_Artifact_API.Get(REGEXP_REPLACE(projection_name_, 'QueryProjection', ''));
      IF query_artifact_.rowkey IS NOT NULL THEN
         IF NOT Is_Item_In_Another_Pkg(package_id_, query_artifact_.rowkey) THEN
            Connect_Item_To_Package___(info_, query_artifact_.rowkey, projection_name_, App_Config_Item_Type_API.DB_QUERY_ARTIFACT, package_id_, raise_error_, auto_add_dependents_);
          ELSE
             info_ := Language_SYS.Translate_Constant(lu_name_, 
                                                 'PROJNOTADDED: The Query Artifact ":P1" which is used by the Custom Page was not automatically added to the package because it is already attached to the package ":P2"',
                                                  Fnd_Session_API.Get_Language,
                                                  query_artifact_.query_name,
                                                  App_Config_Package_API.Get_Item_Package_Name(proj_config_.rowkey));
          END IF;
      ELSE
      proj_config_skipped_ := TRUE;   
      END IF;
   END IF;
   RETURN TRUE;    
$ELSE
   RETURN FALSE;
$END
END Add_Aurena_Page_Dependencies___;

FUNCTION Get_Projection_For_Standard_Page_Model___ (
   model_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   projection_name_ VARCHAR2(128);
BEGIN
   SELECT SUBSTR(reference, INSTR(reference, ':')+1)  INTO projection_name_
   FROM fnd_model_design_tab t where model_id = model_id_;
   RETURN projection_name_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN OTHERS THEN
      Log_SYS.App_Trace(Log_SYS.error_, 'Get_Projection_For_Standard_Page_Model___:' || SQLERRM );
      RETURN NULL;
END Get_Projection_For_Standard_Page_Model___;

FUNCTION Export_Acp_Item(
	package_id_ IN VARCHAR2,
	config_item_id_ IN VARCHAR2) RETURN CLOB
IS
   item_export_ CLOB;
   item_type_  VARCHAR2(100);
   options_  VARCHAR2(1000);
BEGIN
	App_Config_Package_Item_API.Export_Configuration_Item(item_export_, package_id_, config_item_id_, item_type_, options_);
   RETURN item_export_;
END Export_Acp_Item;

