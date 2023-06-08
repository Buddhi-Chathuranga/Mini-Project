-----------------------------------------------------------------------------
--
--  Logical unit: AppConfigUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

SUBTYPE AppConfigItemStatus IS BINARY_INTEGER RANGE 0..4;
  Status_Unknown        CONSTANT AppConfigItemStatus := 0;
  Status_Validated      CONSTANT AppConfigItemStatus := 1;
  Status_Warning        CONSTANT AppConfigItemStatus := 2;
  Status_Deploy_Error   CONSTANT AppConfigItemStatus := 3;
  Status_Error          CONSTANT AppConfigItemStatus := 4;
  
TYPE AppConfigItemInfo IS RECORD
   ( name                        VARCHAR2(100),
     item_type                   VARCHAR2(50),     
     last_modified_date          DATE,
     validation_result           AppConfigItemStatus,
     validation_details          VARCHAR2(32767),
     exists                      VARCHAR2(5),
     current_description         VARCHAR2(32767),
     current_published           VARCHAR2(5),
     current_last_modified_date  DATE,
     current_package             VARCHAR2(100),
     current_package_id          VARCHAR2(100));
     
TYPE AppConfigItemInfo2 IS RECORD
   ( name                        VARCHAR2(100),
     item_type                   VARCHAR2(50),     
     last_modified_date          DATE,
     validation_result           AppConfigItemStatus,
     validation_details          CLOB,
     exists                      VARCHAR2(5),
     current_description         VARCHAR2(32767),
     current_published           VARCHAR2(5),
     current_last_modified_date  DATE,
     current_package             VARCHAR2(100),
     current_package_id          VARCHAR2(100));
     
TYPE AppConfigItemDeploymentObject IS RECORD
   ( name                        VARCHAR2(100),
     item_type                   VARCHAR2(50),
     error                       AppConfigItemStatus,
     object_name                 VARCHAR2(100),
     object_type                 VARCHAR2(100));

TYPE DeploymentObjectArray IS TABLE OF AppConfigItemDeploymentObject  INDEX BY BINARY_INTEGER;

TYPE AppConfigValidationResult IS RECORD
   ( 
     status                     App_Config_Util_API.AppConfigItemStatus,
     message                    VARCHAR2(32767));
     
-------------------- PRIVATE DECLARATIONS -----------------------------------

LOG_APPLICATION CONSTANT VARCHAR2(12) := 'AppConfig';

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

---------------------------------------------------------------------------------------------------------
-- Get Item Name Methods
---------------------------------------------------------------------------------------------------------

FUNCTION Get_Item_Name_Custom_Field___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Field_Attributes_API.Get_Prompt_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END
END Get_Item_Name_Custom_Field___;

FUNCTION Get_Item_Name_Custom_Enum___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Enumerations_API.Get_Prompt_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END 
END Get_Item_Name_Custom_Enum___;

FUNCTION Get_Item_Name_Custom_Lus___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Lus_API.Get_Prompt_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END 
END Get_Item_Name_Custom_Lus___;

FUNCTION Get_Item_Name_Custom_Pages___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Pages_API.Get_Page_Title_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END 
END Get_Item_Name_Custom_Pages___;

FUNCTION Get_Item_Name_Custom_Menu___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Custom_Menu_Util_API.Get_Menu_Title(Custom_Menu_API.Get_Key_By_Rowkey(rowkey_).menu_id);   
END Get_Item_Name_Custom_Menu___;

FUNCTION Get_Item_Name_Quick_Report___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Quick_Report_API.Get_Description(Quick_Report_API.Get_Key_By_Rowkey(rowkey_).quick_report_id);
END Get_Item_Name_Quick_Report___;

FUNCTION Get_Item_Name_Aurean_Client___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Aurena_Page_API.Get_Model_Name(rowkey_);
    $ELSE
      RETURN NULL;
   $END 
END Get_Item_Name_Aurean_Client___;

FUNCTION Get_Item_Name_Custom_Projection___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      DECLARE
         projection_name_ custom_projection_tab.projection_name%TYPE;
      BEGIN
         projection_name_:= Custom_Projection_API.Get_Name_By_Rowkey(rowkey_);
         RETURN projection_name_;
      END;
   $ELSE
      RETURN NULL;
   $END 

END Get_Item_Name_Custom_Projection___;

FUNCTION Get_Item_Name_Custom_ProjConfig___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
  
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      DECLARE
         projection_name_ PROJECTION_CONFIG_TAB.projection_name%TYPE;
      BEGIN
         projection_name_:= Projection_Config_API.Get_Name_By_Rowkey(rowkey_);
         RETURN projection_name_;
      END;
   $ELSE
      RETURN NULL;
   $END 

END Get_Item_Name_Custom_ProjConfig___;

FUNCTION Get_Item_Name_Custom_Tab___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
 $IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Tab_API.Get_Title_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END 
END Get_Item_Name_Custom_Tab___;

FUNCTION Get_Item_Name_Info_Cards___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Field_Attributes_API.Get_Prompt_By_Rowkey(rowkey_);
   $ELSE
      RETURN NULL;
   $END
END Get_Item_Name_Info_Cards___;

FUNCTION Get_Item_Name_Co_Field_Act___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Conditional_Field_Action_API.Get_Name_By_Rowkey(rowkey_);
END Get_Item_Name_Co_Field_Act___;

FUNCTION Get_Item_Name_Custom_Event___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Event_API.Get_Event_Id_By_Rowkey(rowkey_);
END Get_Item_Name_Custom_Event___;

FUNCTION Get_Item_Name_Event_Action___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Event_Action_API.Get_Name_By_Rowkey(rowkey_);
END Get_Item_Name_Event_Action___;

FUNCTION Get_Item_Name_Mobile_Application___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndmob_SYS.INSTALLED $THEN
      RETURN Mobile_Application_Version_API.Get_Name_By_RowKey(rowkey_);
   $ELSE
      RETURN NULL;
   $END
END Get_Item_Name_Mobile_Application___;

FUNCTION Get_Item_Name_Configuration_Context___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Configuration_Context_API.Get_By_Rowkey(rowkey_).label;
   $ELSE
      RETURN NULL;
   $END
END Get_Item_Name_Configuration_Context___;

FUNCTION Get_Item_Name_Navigator_Configuration___(
   scope_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Navigator_Config_Util_API.Get_Item_Name(scope_id_);
   $ELSE
      RETURN NULL;
   $END
END Get_Item_Name_Navigator_Configuration___;

FUNCTION Get_Item_Name_Appearance_Config___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Branding_API.Get_By_Rowkey(rowkey_).name;
END Get_Item_Name_Appearance_Config___;

FUNCTION Get_Item_Name_Query_Artifact___(
   rowkey_ IN VARCHAR2 )RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Query_Artifact_API.Get_By_Rowkey(rowkey_).query_name;
   $ELSE
      RETURN NULL;
   $END
END Get_Item_Name_Query_Artifact___;

---------------------------------------------------------------------------------------------------------
-- Get Item Description Methods
---------------------------------------------------------------------------------------------------------

FUNCTION Get_Descrip_Custom_Field___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Field_Attributes_API.Get_Note_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END
END Get_Descrip_Custom_Field___;

FUNCTION Get_Descrip_Custom_Enum___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Enumerations_API.Get_Note_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END
END Get_Descrip_Custom_Enum___;

FUNCTION Get_Descrip_Custom_Lus___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_LUs_API.Get_Note_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END
END Get_Descrip_Custom_Lus___;

FUNCTION Get_Descrip_Custom_Pages___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Pages_API.Get_Note_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END
END Get_Descrip_Custom_Pages___;

   FUNCTION Get_Descrip_Custom_Menu___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Custom_Menu_API.Get_Description(Custom_Menu_API.Get_Key_By_Rowkey(rowkey_).menu_id);
END Get_Descrip_Custom_Menu___;

FUNCTION Get_Descrip_Custom_Tab___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Tab_API.Get_Note_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END
END Get_Descrip_Custom_Tab___;

FUNCTION Get_Descrip_Info_Card___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Field_Attributes_API.Get_Note_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END
END Get_Descrip_Info_Card___;

FUNCTION Get_Descrip_Cond_Field_Act___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Conditional_Field_Action_API.Get_Description_By_Rowkey(rowkey_);
END Get_Descrip_Cond_Field_Act___;

FUNCTION Get_Descrip_Custom_Event___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Event_API.Get_Description_By_Rowkey(rowkey_);
END Get_Descrip_Custom_Event___;

FUNCTION Get_Descrip_Event_Action___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Event_Action_API.Get_Description_By_Rowkey(rowkey_);
END Get_Descrip_Event_Action___;

FUNCTION Get_Descrip_Quick_Report___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Quick_Report_API.Get_Comments(Quick_Report_API.Get_Key_By_Rowkey(rowkey_).quick_report_id);
END Get_Descrip_Quick_Report___;

FUNCTION Get_Descrip_Aureana_client___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Aurena_Page_API.Get_Model_Description(rowkey_);
   $ELSE
      RETURN NULL;
   $END
END Get_Descrip_Aureana_client___;

FUNCTION Get_Descrip_Custom_Projection___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Custom_Projection_API.Get_Description_By_Rowkey(rowkey_);
   $ELSE
      RETURN NULL;
   $END 
END Get_Descrip_Custom_Projection___;

FUNCTION Get_Descrip_Mobile_Application___ (
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndmob_SYS.INSTALLED $THEN
   RETURN Mobile_Application_Version_API.Get_Description_By_Rowkey(rowkey_);
$ELSE
   RETURN NULL;
$END   
END Get_Descrip_Mobile_Application___ ;

FUNCTION Get_Description_Configuration_Context___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Configuration_Context_API.Get_By_Rowkey(rowkey_).label;
   $ELSE
      RETURN NULL;
   $END
END Get_Description_Configuration_Context___;

FUNCTION Get_Description_Navigator_Configuration___(
   scope_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Navigator_Config_Util_API.Get_Item_Description(scope_id_);
   $ELSE
      RETURN NULL;
   $END
END Get_Description_Navigator_Configuration___;

FUNCTION Get_Description_Appearance_Config___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Branding_API.Get_By_Rowkey(rowkey_).description;
END Get_Description_Appearance_Config___;

FUNCTION Get_Description_Query_Artifact___(
   rowkey_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      RETURN Query_Artifact_API.Get_By_Rowkey(rowkey_).description;
   $ELSE
      RETURN NULL;
   $END
END Get_Description_Query_Artifact___;
------------------------------------------------------------------------------------------------------------
--- Meta Data methods
------------------------------------------------------------------------------------------------------------

FUNCTION Get_Metadata_Custom_Field___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      rec_ Custom_Field_Attributes_API.Public_Rec;
      key_ custom_field_attributes_tab%ROWTYPE;
      attr_ VARCHAR2(32000);
   BEGIN
      key_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_);
      rec_ := Custom_Field_Attributes_API.Get(key_.lu, key_.lu_type, key_.attribute_name);
      Client_SYS.Add_To_Attr('LU', key_.lu, attr_);
      Client_SYS.Add_To_Attr('ATTRIBUTE_NAME', key_.attribute_name, attr_);
      Client_SYS.Add_To_Attr('CUSTOM_FIELD_TYPE', Custom_Field_Types_API.Decode(rec_.custom_field_type), attr_);
      Client_SYS.Add_To_Attr('CUSTOM_FIELD_DATATYPE', Custom_Field_Data_Types_API.Decode(rec_.data_type), attr_);
      
      IF rec_.lu_reference IS NOT NULL THEN
         Client_SYS.Add_To_Attr('REFERENCE', rec_.lu_reference, attr_);
      END IF;
      IF rec_.lov_view IS NOT NULL THEN
         Client_SYS.Add_To_Attr('LOV_VIEW', rec_.lov_view, attr_);
      END IF;
      RETURN attr_;
   END;
$ELSE
   RETURN NULL;
$END
END Get_Metadata_Custom_Field___;

FUNCTION Get_Metadata_Custom_Enum___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      rec_ custom_enumerations_tab%ROWTYPE;
      attr_ VARCHAR2(32000);
   BEGIN
      rec_ := Custom_Enumerations_API.Get_Object_By_Keys_(rowkey_);
      Client_SYS.Add_To_Attr('LU', rec_.lu, attr_);
      Client_SYS.Add_To_Attr('PROMPT', rec_.prompt, attr_);
      RETURN attr_;
   END;
$ELSE
   RETURN NULL;
$END
END Get_Metadata_Custom_Enum___;

FUNCTION Get_Metadata_Custom_Menu___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
   attr_ VARCHAR2(32000);
   keyrec_ custom_menu_tab%ROWTYPE;
BEGIN
   keyrec_ := Custom_Menu_API.Get_Key_By_Rowkey(rowkey_);
   Client_SYS.Add_To_Attr('TITLE', Custom_Menu_Util_API.Get_Menu_Title(keyrec_.menu_id), attr_);
   Client_SYS.Add_To_Attr('DESCRIPTION', Custom_Menu_API.Get_Description(keyrec_.menu_id), attr_);
   RETURN attr_;
END Get_Metadata_Custom_Menu___;

FUNCTION Get_Metadata_Info_Card___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      rec_ Custom_Field_Attributes_API.Public_Rec;
      key_ custom_field_attributes_tab%ROWTYPE;
      attr_ VARCHAR2(32000);
   BEGIN
      key_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_);
      rec_ := Custom_Field_Attributes_API.Get(key_.lu, key_.lu_type, key_.attribute_name);
      Client_SYS.Add_To_Attr('LU', key_.lu, attr_);
      Client_SYS.Add_To_Attr('ATTRIBUTE_NAME', key_.attribute_name, attr_);
      Client_SYS.Add_To_Attr('CUSTOM_FIELD_TYPE', Custom_Field_Types_API.Decode(rec_.custom_field_type), attr_);
      Client_SYS.Add_To_Attr('CUSTOM_FIELD_DATATYPE', Custom_Field_Data_Types_API.Decode(rec_.data_type), attr_);
      
      IF rec_.lu_reference IS NOT NULL THEN
         Client_SYS.Add_To_Attr('REFERENCE', rec_.lu_reference, attr_);
      END IF;
      IF rec_.lov_view IS NOT NULL THEN
         Client_SYS.Add_To_Attr('LOV_VIEW', rec_.lov_view, attr_);
      END IF;
      RETURN attr_;
   END;
$ELSE
   RETURN NULL;
$END
END Get_Metadata_Info_Card___;

PROCEDURE Custom_Field_Translatable___(
   rowkey_ IN VARCHAR2 )
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      rec_ Custom_Field_Attributes_API.Public_Rec;
      key_ custom_field_attributes_tab%ROWTYPE;
   BEGIN
      key_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_);
      rec_ := Custom_Field_Attributes_API.Get(key_.lu, key_.lu_type, key_.attribute_name);
      Custom_Field_Attributes_API.Create_Language_Translation(rec_.lu_type, rec_.lu, rec_.attribute_name, rec_.prompt);
   END;
   $ELSE
      NULL;
   $END   
END Custom_Field_Translatable___;

PROCEDURE Custom_Enum_Translatable___(
   rowkey_ IN VARCHAR2 )
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_ custom_enumerations_tab%ROWTYPE;
      rec_ custom_enumerations_api.Public_Rec;

      CURSOR get_values(lu_ IN VARCHAR2) IS
         SELECT db_value, client_value, seq_no
         FROM custom_field_enum_values_tab
         WHERE lu = lu_;
   BEGIN
      key_ := Custom_Enumerations_API.Get_Key_By_Rowkey(rowkey_);
      rec_ := Custom_Enumerations_API.Get(key_.lu);
      Custom_Enumerations_API.Create_Language_Translation(rec_.lu, rec_.prompt);
      FOR enum_value_rec_ IN get_values(rec_.lu) LOOP
         Custom_Field_Enum_Values_API.Create_Language_Translation(rec_.lu, enum_value_rec_.db_value, enum_value_rec_.client_value, enum_value_rec_.seq_no);
      END LOOP;
   END;
   $ELSE
      NULL;
   $END   
END Custom_Enum_Translatable___;

PROCEDURE Custom_Lu_Translatable___(
   rowkey_ IN VARCHAR2 )
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_ custom_lus_tab%ROWTYPE;
      rec_ custom_lus_api.Public_Rec;
      CURSOR get_attributes(lu_ IN VARCHAR2, lu_type_ IN VARCHAR2 ) IS
         SELECT attribute_name, prompt
         FROM custom_field_attributes_tab
         WHERE lu = lu_
         and lu_type = lu_type_;
   BEGIN
      key_ := Custom_Lus_API.Get_Key_By_Rowkey(rowkey_);
      rec_ := Custom_Lus_API.Get(key_.lu, key_.lu_type);
      Custom_Lus_API.Create_Language_Translation(rec_.lu, rec_.view_name, rec_.prompt);
      FOR attrib_rec_ IN get_attributes(rec_.lu, rec_.lu_type) LOOP
         Custom_Field_Attributes_API.Create_Language_Translation(rec_.lu_type, rec_.lu, attrib_rec_.attribute_name, attrib_rec_.prompt);
      END LOOP;
   END;
   $ELSE
      NULL;
   $END   
END Custom_Lu_Translatable___;

PROCEDURE Info_Card_Translatable___(
   rowkey_ IN VARCHAR2 )
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
   DECLARE
      key_ custom_field_attributes_tab%ROWTYPE;
      rec_ custom_field_attributes_api.Public_Rec;
   BEGIN
      key_ := Custom_Field_Attributes_API.Get_Key_By_Rowkey(rowkey_);
      rec_ := Custom_Field_Attributes_API.Get(key_.lu, key_.lu_type, key_.attribute_name);
      Custom_Field_Attributes_API.Create_Language_Translation(rec_.lu_type, rec_.lu, rec_.attribute_name, rec_.prompt);
   END;
   $ELSE
      NULL;
   $END   
END Info_Card_Translatable___;

------------------------------------------------------------------------------------------------------------
--- Dependency methods
-- Will return direct dependents of the purticular configuration object.
-- If a configuration item depends on another configuration item, then only the item type, 
-- rowkey and name should be returned.
------------------------------------------------------------------------------------------------------------

FUNCTION Get_Dependents_Custom_Field___ RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   NULL;
$ELSE
   RETURN NULL;
$END
END Get_Dependents_Custom_Field___;

FUNCTION Get_Dependents_Custom_Enum___ RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   NULL;
$ELSE
   RETURN NULL;
$END
END Get_Dependents_Custom_Enum___;

FUNCTION Get_Dependents_Custom_Menu___(
   rowkey_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Custom_Menu_API.Get_Dependent_Items(Custom_Menu_API.Get_Key_By_Rowkey(rowkey_).rowkey);
END Get_Dependents_Custom_Menu___;

------------------------------------------------------------------------------------------------------------
--- Assosiated Object methods
------------------------------------------------------------------------------------------------------------

FUNCTION Get_Cust_Fld_Associated_Obj___ (
   item_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   objects_ VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT cfa.lu INTO objects_ 
   FROM custom_field_attributes_tab cfa
   WHERE cfa.rowkey = item_id_;
$END
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Cust_Fld_Associated_Obj___;

FUNCTION Get_Cust_Mnu_Associated_Obj___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(32000);
BEGIN
   SELECT cm.window INTO objects_            
   FROM custom_menu_tab cm
   WHERE cm.rowkey = item_id_;
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Cust_Mnu_Associated_Obj___;

FUNCTION Get_Cust_Enum_Asociated_Obj___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT lu INTO objects_   
   FROM custom_enumerations_tab ce
   WHERE ce.rowkey = item_id_;
$END
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Cust_Enum_Asociated_Obj___;

FUNCTION Get_Cust_Page_Asociated_Obj___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT lu INTO objects_
   FROM custom_pages_tab cp
   WHERE cp.rowkey = item_id_;
$END
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Cust_Page_Asociated_Obj___;

FUNCTION Get_Cust_Lu_Associated_Obj___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT cl.prompt INTO objects_ 
   FROM custom_lus_tab cl 
   WHERE cl.rowkey = item_id_  ;
$END
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Cust_Lu_Associated_Obj___;

FUNCTION Get_Cust_Tab_Asociated_Obj___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(32000);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT ct.container_name INTO objects_
   FROM custom_tab_tab ct
   WHERE ct.rowkey = item_id_;
$END
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Cust_Tab_Asociated_Obj___;
   
FUNCTION Get_Cond_Field_Assoc_Obj___(
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(200);
BEGIN
   --SOLSETFW
   SELECT cfa.lu_name INTO objects_            
   FROM conditional_field_action cfa
   WHERE cfa.objkey = item_id_;
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Cond_Field_Assoc_Obj___;   
   
FUNCTION Get_Event_Assoc_Obj___(
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(200);
BEGIN
   SELECT event_lu_name INTO objects_            
   FROM fnd_event_tab
   WHERE rowkey = item_id_;
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Event_Assoc_Obj___;   

FUNCTION Get_Event_Action_Assoc_Obj___(
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   objects_ VARCHAR2(200);
BEGIN
   SELECT event_lu_name INTO objects_            
   FROM fnd_event_action_tab 
   WHERE rowkey = item_id_;
   RETURN objects_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Event_Action_Assoc_Obj___;   
------------------------------------------------------------------------------------------------------------
--- Get Approved methods
------------------------------------------------------------------------------------------------------------
   
FUNCTION Get_Custom_Field_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   approved_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.used INTO approved_db_  
   FROM custom_field_attributes_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN approved_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Field_Approved___;
   
FUNCTION Get_Custom_Menu_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1 INTO dummy_  
   FROM custom_menu_tab v 
   WHERE v.rowkey = item_id_;
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Menu_Approved___;

FUNCTION Get_Custom_Enum_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   approved_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.used INTO approved_db_  
   FROM custom_enumerations_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN approved_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Enum_Approved___;
   
FUNCTION Get_Custom_Lu_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   approved_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.used INTO approved_db_  
   FROM custom_lus_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN approved_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Lu_Approved___;

FUNCTION Get_Custom_Page_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT 1 INTO dummy_  
   FROM custom_pages_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Page_Approved___;
   
FUNCTION Get_Custom_Tab_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      SELECT 1 INTO dummy_  
      FROM custom_tab_tab v 
      WHERE v.rowkey = item_id_;
   $END
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Tab_Approved___;   
   
FUNCTION Get_Cond_Field_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enabled_db_ VARCHAR2(10);
BEGIN
   --SOLSETFW
   SELECT action_enabled INTO enabled_db_  
   FROM conditional_field_action v 
   WHERE v.objkey = item_id_;
   RETURN enabled_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Cond_Field_Approved___;

FUNCTION Get_Configuration_Context_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT 1 INTO dummy_  
   FROM configuration_context_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Configuration_Context_Approved___;

FUNCTION Get_Navigator_Configuration_Approved___ RETURN VARCHAR2
IS
BEGIN
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Navigator_Configuration_Approved___;
------------------------------------------------------------------------------------------------------------
--- Get Published methods
------------------------------------------------------------------------------------------------------------
   
FUNCTION Get_Custom_Field_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   published_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.published INTO published_db_  
   FROM custom_field_attributes_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN published_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Field_Published___;

FUNCTION Get_Custom_Enum_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   published_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.published INTO published_db_  
   FROM custom_enumerations_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN published_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Enum_Published___;
   
FUNCTION Get_Custom_Lu_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   published_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.published INTO published_db_  
   FROM custom_lus_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN published_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Lu_Published___;
   
FUNCTION Get_Custom_Menu_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
   SELECT 1 INTO dummy_  
   FROM custom_menu_tab v 
   WHERE v.rowkey = item_id_;
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Menu_Published___;
   
FUNCTION Get_Custom_Tab_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      SELECT 1 INTO dummy_  
      FROM custom_tab_tab v 
      WHERE v.rowkey = item_id_;
   $END
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Custom_Tab_Published___;      
   
FUNCTION Get_Custom_Page_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT 1 INTO dummy_  
   FROM custom_pages_tab p, custom_lus_tab l -- Custom Logical unit connect must be published
   WHERE p.rowkey = item_id_
   AND p.lu = l.lu
   AND l.published = 'TRUE';
$END
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
   END Get_Custom_Page_Published___;
   
FUNCTION Get_Cond_Field_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enabled_db_ VARCHAR2(10);
BEGIN
   --SOLSETFW
   SELECT action_enabled INTO enabled_db_  
   FROM conditional_field_action v 
   WHERE v.objkey = item_id_;
   RETURN enabled_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
   END Get_Cond_Field_Published___;   

FUNCTION Get_Event_Enabled___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enabled_db_ VARCHAR2(10);
BEGIN
   SELECT event_enable INTO enabled_db_  
   FROM fnd_event_tab v 
   WHERE v.rowkey = item_id_;
   RETURN enabled_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Event_Enabled___;   

FUNCTION Get_Event_Action_Approved___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enabled_db_ VARCHAR2(10);
BEGIN
   SELECT action_enable INTO enabled_db_  
   FROM fnd_event_action_tab a
   WHERE a.rowkey = item_id_;
   RETURN enabled_db_; 
   
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Event_Action_Approved___;  

FUNCTION Get_Event_Action_Enabled___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enabled_db_ VARCHAR2(10);
BEGIN
   SELECT action_enable INTO enabled_db_  
   FROM fnd_event_action_tab a
   WHERE a.rowkey = item_id_
   AND EXISTS (SELECT 1 
               FROM fnd_event_tab
               WHERE event_lu_name = a.event_lu_name
               AND event_id = a.event_id 
               AND event_enable = 'TRUE');
   
   RETURN enabled_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Event_Action_Enabled___;

FUNCTION Get_Aurena_Config_Page_Group_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   published_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
   
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      DECLARE
         aprowrec_ Custom_Aurena_Page_API.Public_Rec;
         model_id_  FND_MODEL_DESIGN_TAB.model_id%TYPE;
         dummy_ NUMBER;
         CURSOR check_published IS
         SELECT 1
           FROM fnd_model_design_data_tab
          WHERE layer_no = 2
            AND model_id = model_id_;
      BEGIN
         aprowrec_:= Custom_Aurena_Page_API.Get_By_Rowkey(item_id_);
         IF aprowrec_.page_name IS NOT NULL THEN
            model_id_:='ClientMetadata.client:'||aprowrec_.page_name;
         ELSE
            model_id_:=item_id_;
         END IF;
          
         OPEN check_published;
         FETCH check_published INTO dummy_;
         IF check_published%FOUND THEN
            published_ := Fnd_Boolean_API.DB_TRUE;
         END IF;
         CLOSE check_published;
      END;
   $END
   RETURN published_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN Fnd_Boolean_API.DB_FALSE;
END Get_Aurena_Config_Page_Group_Published___;

FUNCTION Get_Aurena_Config_Page_Group_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      DECLARE
         aprowrec_ Custom_Aurena_Page_API.Public_Rec;
         model_id_  FND_MODEL_DESIGN_TAB.model_id%TYPE;
         dummy_ NUMBER;
         
         CURSOR current_published IS
            SELECT t.model_id, t.scope_id, t.data_id, t.layer_no, t.visibility
            FROM fnd_model_design_data_tab t
            WHERE layer_no = 2 AND model_id = model_id_;
            
         CURSOR current_drafts(model_id_ IN VARCHAR2, scope_id_ IN VARCHAR2,
                               data_id_ IN VARCHAR2, layer_no_ IN NUMBER, visibility_ IN VARCHAR2) IS
         SELECT 1
           FROM fnd_model_design_data_tab
           WHERE layer_no = 90
           AND model_id = model_id_ AND scope_id = scope_id_ 
           AND data_id = data_id_ AND layer_no = layer_no_ AND visibility = visibility_; 
            
      BEGIN
         aprowrec_:= Custom_Aurena_Page_API.Get_By_Rowkey(item_id_);
         IF aprowrec_.page_name IS NOT NULL THEN
            model_id_:='ClientMetadata.client:'||aprowrec_.page_name;
         ELSE
            model_id_:=item_id_;
         END IF;
          
         FOR cpublished_ IN current_published LOOP
            OPEN current_drafts(cpublished_.model_id, cpublished_.scope_id, cpublished_.data_id, 
            cpublished_.layer_no, cpublished_.visibility);
            FETCH current_Drafts INTO dummy_;
            IF current_Drafts%NOTFOUND THEN
               RETURN Fnd_Boolean_API.DB_FALSE;
            END IF;
            CLOSE current_Drafts;
         END LOOP;  
      END;
   $END
    RETURN Fnd_Boolean_API.DB_TRUE;
EXCEPTION
   WHEN no_data_found THEN
      RETURN Fnd_Boolean_API.DB_FALSE;
END Get_Aurena_Config_Page_Group_Synch___;

FUNCTION Get_Mobile_Application_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   published_db_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
$IF Component_Fndmob_SYS.INSTALLED $THEN
   IF Mobile_Application_Version_API.Get_Published_Db_By_Rowkey(item_id_) THEN
      published_db_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      published_db_ := Fnd_Boolean_API.DB_FALSE;
   END IF;  
$END
   RETURN published_db_;
END Get_Mobile_Application_Published___;

FUNCTION Get_Configuration_Context_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT 1 INTO dummy_  
   FROM configuration_context_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Configuration_Context_Published___;

FUNCTION Get_Navigator_Configuration_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Navigator_Config_Util_API.Is_Published(item_id_);
$ELSE
   RETURN 'FALSE';
$END
END Get_Navigator_Configuration_Published___;

FUNCTION Get_Appearance_Config_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Branding_API.Is_Published(item_id_);
END Get_Appearance_Config_Published___;

FUNCTION Get_Query_Artifact_Published___(
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   published_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.published INTO published_db_  
   FROM query_artifact_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN published_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Query_Artifact_Published___;
------------------------------------------------------------------------------------------------------------
--- Get Synchronized methods
------------------------------------------------------------------------------------------------------------
   
FUNCTION Get_Attribute_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   synchronized_db_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF Custom_Field_Attributes_API.Get_Synchronized_Db(item_id_) THEN
      synchronized_db_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      synchronized_db_ := Fnd_Boolean_API.DB_FALSE;
   END IF;  
$END
   RETURN synchronized_db_;
END Get_Attribute_Synch___;

FUNCTION Get_Custom_Enum_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
    synchronized_db_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF Custom_Enumerations_API.Get_Synchronized_Db(item_id_) THEN
      synchronized_db_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      synchronized_db_ := Fnd_Boolean_API.DB_FALSE;
   END IF;  
$END
   RETURN synchronized_db_;
END Get_Custom_Enum_Synch___;
   
FUNCTION Get_Custom_Lu_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   synchronized_db_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   IF Custom_Lus_API.Get_Synchronized_Db_By_Rowkey(item_id_) THEN
      synchronized_db_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      synchronized_db_ := Fnd_Boolean_API.DB_FALSE;
   END IF;  
$END
   RETURN synchronized_db_;
END Get_Custom_Lu_Synch___;
   
FUNCTION Get_Custom_Menu_Synch___ RETURN VARCHAR2
IS
BEGIN
  RETURN Fnd_Boolean_API.DB_TRUE; 
END Get_Custom_Menu_Synch___;

FUNCTION Get_Custom_Tab_Synch___ RETURN VARCHAR2
IS
BEGIN
  RETURN Fnd_Boolean_API.DB_TRUE; 
END Get_Custom_Tab_Synch___;   
   
FUNCTION Get_Custom_Page_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_ VARCHAR2(50); 
   synchronized_db_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT lu INTO lu_  
   FROM custom_pages_tab v 
   WHERE v.rowkey = item_id_;
   
   IF (Custom_Lus_API.Check_Exist(lu_, Custom_Field_Lu_Types_API.DB_CUSTOM_LU)) THEN
      IF Fnd_Boolean_API.Evaluate_Db(Custom_Lus_API.Get_Published_Db(lu_)) THEN -- Ignore this check when importing data
         synchronized_db_ := Fnd_Boolean_API.DB_TRUE;
      END IF;  
   END IF;
$END   
   RETURN synchronized_db_; 
EXCEPTION   
    WHEN no_data_found THEN
      RETURN Fnd_Boolean_API.DB_FALSE;
END Get_Custom_Page_Synch___;   
   
FUNCTION Get_Cond_Field_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   enabled_db_ VARCHAR2(10);
BEGIN
   --SOLSETFW
   SELECT action_enabled INTO enabled_db_  
   FROM conditional_field_action v 
   WHERE v.objkey = item_id_;
   RETURN enabled_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Cond_Field_Synch___; 

--
FUNCTION Get_Custom_Projection_Sync___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN      
      DECLARE
         customproj_ custom_projection_api.Public_Rec;
      BEGIN
         customproj_:=   custom_projection_api.Get_By_Rowkey(item_id_);
         IF customproj_.projection_name IS NOT NULL THEN
            RETURN  custom_projection_api.is_in_sync(customproj_.projection_name);
         END IF;
      END;
   $ELSE
      RETURN 'FALSE';
   $END 
END Get_Custom_Projection_Sync___; 

FUNCTION Get_ProjConfig_Sync___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS

BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN      
      DECLARE
         customprojc_ projection_config_api.Public_Rec;
      BEGIN
         customprojc_:=   projection_config_api.Get_By_Rowkey(item_id_);
         IF customprojc_.projection_name IS NOT NULL THEN
            RETURN  projection_config_api.is_in_sync(customprojc_.projection_name);
         END IF;
      END;
   $ELSE
      RETURN 'FALSE';
   $END
END Get_ProjConfig_Sync___;

FUNCTION Get_Custom_Projection_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS

BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Custom_Projection_API.Get_Published_By_Rowkey(item_id_);
$ELSE
   RETURN 'FALSE';
$END 
END Get_Custom_Projection_Published___; 

FUNCTION Get_ProjConfig_Published___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS

BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Projection_Config_API.Get_Published_By_Rowkey(item_id_);
$ELSE
   RETURN 'FALSE';
$END 
END Get_ProjConfig_Published___;

FUNCTION Get_Mobile_Application_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
    synchronized_db_ VARCHAR2(10) := Fnd_Boolean_API.DB_FALSE;
BEGIN
$IF Component_Fndmob_SYS.INSTALLED $THEN
   IF Mobile_Application_Version_API.Get_Synchronized_Db_By_Rowkey(item_id_) THEN
      synchronized_db_ := Fnd_Boolean_API.DB_TRUE;
   ELSE
      synchronized_db_ := Fnd_Boolean_API.DB_FALSE;
   END IF;  
$END
   RETURN synchronized_db_;
END Get_Mobile_Application_Synch___;

FUNCTION Get_Configuration_Context_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   dummy_ NUMBER;
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT 1 INTO dummy_  
   FROM configuration_context_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN 'TRUE';
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Configuration_Context_Synch___;

FUNCTION Get_Navigator_Configuration_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   RETURN Navigator_Config_Util_API.Is_In_Sync(item_id_);
$ELSE
   RETURN 'FALSE';
$END
END Get_Navigator_Configuration_Synch___;

FUNCTION Get_Appearance_Config_Synch___ (
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   RETURN Fnd_Branding_API.Is_In_Sync(item_id_);
END Get_Appearance_Config_Synch___;

FUNCTION Get_Query_Artifact_Synch___(
   item_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   sync_db_ VARCHAR2(10);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   SELECT v.synchronized INTO sync_db_  
   FROM query_artifact_tab v 
   WHERE v.rowkey = item_id_;
$END
   RETURN sync_db_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN 'FALSE';
END Get_Query_Artifact_Synch___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Item_Name (
   item_id_ IN VARCHAR2,
   item_type_   IN VARCHAR2 DEFAULT NULL ) RETURN VARCHAR2
IS
BEGIN
   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      RETURN Get_Item_Name_Custom_Field___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      RETURN Get_Item_Name_Custom_Field___(item_id_);   
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      RETURN Get_Item_Name_Custom_Enum___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      RETURN Get_Item_Name_Custom_Menu___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
      RETURN Get_Item_Name_Custom_Lus___ (item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
      RETURN Get_Item_Name_Custom_Pages___(item_id_);
   WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
    RETURN Get_Item_Name_Info_Cards___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
    RETURN Get_Item_Name_Custom_Tab___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
    RETURN Get_Item_Name_Co_Field_Act___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
      RETURN Get_Item_Name_Custom_Event___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
      RETURN Get_Item_Name_Event_Action___(item_id_);
   WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
      RETURN Get_Item_Name_Quick_Report___(item_id_);
   WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
      RETURN Get_Item_Name_Aurean_Client___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
      RETURN Get_Item_Name_Custom_Projection___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN
      RETURN Get_Item_Name_Custom_ProjConfig___(item_id_);
   WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
      RETURN Get_Item_Name_Mobile_Application___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
      RETURN Get_Item_Name_Configuration_Context___(item_id_);
   WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
      RETURN Get_Item_Name_Navigator_Configuration___(item_id_);   
   WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
      RETURN Get_Item_Name_Appearance_Config___(item_id_);
   WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
      RETURN Get_Item_Name_Query_Artifact___(item_id_);   
   ELSE
      RETURN NULL;
   END CASE;      
END Get_Item_Name;

FUNCTION Get_Item_Description (
   item_id_ IN VARCHAR2,
   item_type_   IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      RETURN Get_Descrip_Custom_Field___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      RETURN Get_Descrip_Custom_Field___(item_id_);   
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      RETURN Get_Descrip_Custom_Enum___ (item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      RETURN Get_Descrip_Custom_Menu___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
      RETURN Get_Descrip_Custom_Lus___ (item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
      RETURN Get_Descrip_Custom_Pages___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
      RETURN Get_Descrip_Custom_Tab___(item_id_);
   WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
    RETURN Get_Descrip_Info_Card___(item_id_);   
   WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
      RETURN Get_Descrip_Cond_Field_Act___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
      RETURN Get_Descrip_Custom_Event___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
      RETURN Get_Descrip_Event_Action___(item_id_);
   WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
      RETURN Get_Descrip_Quick_Report___(item_id_);
   WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
      RETURN Get_Descrip_Aureana_client___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
      RETURN Get_Descrip_Custom_Projection___(item_id_);
   WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
      RETURN Get_Descrip_Mobile_Application___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
      RETURN Get_Description_Configuration_Context___(item_id_);
   WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
      RETURN Get_Description_Navigator_Configuration___(item_id_);
   WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
      RETURN Get_Description_Appearance_Config___(item_id_);
   WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
      RETURN Get_Description_Query_Artifact___(item_id_);    
   ELSE
      RETURN NULL;
   END CASE;  
END Get_Item_Description;

FUNCTION Get_Item_Metadata (
   item_id_ IN VARCHAR2,
   item_type_   IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      RETURN Get_Metadata_Custom_Field___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      RETURN Get_Metadata_Custom_Field___(item_id_);
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      RETURN Get_Metadata_Custom_Enum___(item_id_);      
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      RETURN Get_Metadata_Custom_Menu___(item_id_);
   WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
      RETURN Get_Metadata_Info_Card___(item_id_);   
   ELSE
      RETURN NULL;
   END CASE;
END Get_Item_Metadata;

FUNCTION Get_Config_Item_Dependents (
   item_id_ IN VARCHAR2,
   item_type_   IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   CASE item_type_
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
      RETURN Get_Dependents_Custom_Field___;
   WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
      RETURN Get_Dependents_Custom_Field___;
   WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
      RETURN Get_Dependents_Custom_Enum___;      
   WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
      RETURN Get_Dependents_Custom_Menu___(item_id_);
   ELSE
      RETURN NULL;
   END CASE;
END Get_Config_Item_Dependents;

@UncheckedAccess
FUNCTION Get_Associated_Object(
   item_id_       IN VARCHAR2,
   item_type_db_  IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN  
   CASE item_type_db_
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
         RETURN Get_Cust_Fld_Associated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
         RETURN Get_Cust_Fld_Associated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
         RETURN Get_Cust_Mnu_Associated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
         RETURN Get_Cust_Enum_Asociated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
         RETURN Get_Cust_Page_Asociated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
         RETURN Get_Cust_Lu_Associated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
         RETURN Get_Cust_Fld_Associated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
         RETURN Get_Cust_Tab_Asociated_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
         RETURN Get_Cond_Field_Assoc_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
         RETURN Get_Event_Assoc_Obj___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
         RETURN Get_Event_Action_Assoc_Obj___(item_id_);
      ELSE
         RETURN NULL;
   END CASE;
END Get_Associated_Object;

@UncheckedAccess
FUNCTION Get_Item_Approved (
   item_id_      IN VARCHAR2,
   item_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN
   CASE item_type_db_
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
         RETURN Get_Custom_Field_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
         RETURN Get_Custom_Field_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
         RETURN Get_Custom_Menu_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
         RETURN Get_Custom_Enum_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
         RETURN Get_Custom_Lu_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
         RETURN Get_Custom_Field_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
         RETURN Get_Custom_Page_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
         RETURN Get_Custom_Tab_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
         RETURN Get_Cond_Field_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
         RETURN 'TRUE';
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
         RETURN Get_Event_Action_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
         RETURN 'TRUE';
      WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
         RETURN 'TRUE'; 
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
         RETURN 'TRUE';             
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN
         RETURN 'TRUE';
      WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
         RETURN Get_Configuration_Context_Approved___(item_id_);
      WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
         RETURN Get_Navigator_Configuration_Approved___;
      WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
         RETURN 'TRUE';
      WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
         RETURN 'TRUE';
      ELSE
         RETURN 'FALSE';
   END CASE;
END Get_Item_Approved;

@UncheckedAccess
FUNCTION Get_Item_Published (
   item_id_      IN VARCHAR2,
   item_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN  
   CASE item_type_db_
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
         RETURN Get_Custom_Field_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
         RETURN Get_Custom_Field_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
         RETURN Get_Custom_Menu_Published___(item_id_);  
      WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
         RETURN Get_Custom_Enum_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
         RETURN Get_Custom_Lu_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
         RETURN Get_Custom_Field_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
         RETURN Get_Custom_Page_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
         RETURN Get_Custom_Tab_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
         RETURN Get_Cond_Field_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
         RETURN Get_Event_Enabled___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
         RETURN Get_Event_Action_Enabled___(item_id_);
      WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
         RETURN 'TRUE';
      WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
         RETURN Get_Aurena_Config_Page_Group_Published___(item_id_);   
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN    
         RETURN Get_Custom_Projection_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN    
         RETURN Get_ProjConfig_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
         RETURN Get_Mobile_Application_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
         RETURN Get_Configuration_Context_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
         RETURN Get_Navigator_Configuration_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
         RETURN Get_Appearance_Config_Published___(item_id_);
      WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
         RETURN Get_Query_Artifact_Published___(item_id_);
      ELSE
         RETURN 'FALSE';
   END CASE;
END Get_Item_Published;

@UncheckedAccess
FUNCTION Get_Item_Synchronized (
   item_id_      IN VARCHAR2,
   item_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS 
BEGIN  
   CASE item_type_db_
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
         RETURN Get_Attribute_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
         RETURN Get_Attribute_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_MENU THEN
         RETURN Get_Custom_Menu_Synch___;  
      WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
         RETURN Get_Custom_Enum_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
         RETURN Get_Custom_Lu_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
         RETURN Get_Attribute_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PAGE THEN
         RETURN Get_Custom_Page_Synch___(item_id_);  
      WHEN App_Config_Item_Type_API.DB_CUSTOM_TAB THEN
         RETURN Get_Custom_Tab_Synch___;   
      WHEN App_Config_Item_Type_API.DB_CONDITIONAL_FIELD_ACTION THEN
         RETURN Get_Cond_Field_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT THEN
         RETURN Get_Event_Enabled___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_EVENT_ACTION THEN
         RETURN Get_Event_Action_Enabled___(item_id_);
      WHEN App_Config_Item_Type_API.DB_QUICK_REPORT THEN
         RETURN 'TRUE';
      WHEN App_Config_Item_Type_API.DB_AURENA_PAGE_GROUP THEN
         RETURN Get_Aurena_Config_Page_Group_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION THEN
         RETURN Get_Custom_Projection_Sync___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_PROJECTION_CONFIG THEN
         RETURN Get_ProjConfig_Sync___(item_id_);
      $IF Component_Fndmob_SYS.INSTALLED $THEN
      WHEN App_Config_Item_Type_API.DB_MOBILE_APPLICATION THEN
         RETURN Get_Mobile_Application_Synch___(item_id_);
      $END
      WHEN App_Config_Item_Type_API.DB_CONFIGURATION_CONTEXT THEN
         RETURN Get_Configuration_Context_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_NAVIGATOR_CONFIGURATION THEN
         RETURN Get_Navigator_Configuration_Synch___(item_id_);  
      WHEN App_Config_Item_Type_API.DB_APPEARANCE_CONFIG THEN
         RETURN Get_Appearance_Config_Synch___(item_id_);
      WHEN App_Config_Item_Type_API.DB_QUERY_ARTIFACT THEN
         RETURN Get_Query_Artifact_Synch___(item_id_);    
      ELSE
         RETURN Fnd_Boolean_API.DB_FALSE;
   END CASE;
END Get_Item_Synchronized;

@UncheckedAccess
FUNCTION Get_Co_Synchronized (
   co_id_      IN VARCHAR2,
   co_type_db_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   CASE co_type_db_
      -- Enum Values are from Custom_Objects_Type_API (FNDCOB)
      -- Can't refer in the following
      -- scenarios because they reside in FNDBAS.
      WHEN 'COND_FIELD_ACTION' THEN
         RETURN Get_Cond_Field_Synch___(co_id_);
      WHEN 'CUSTOM_EVENT' THEN
         RETURN Get_Event_Enabled___(co_id_);
      WHEN 'CUSTOM_EVENT_ACTION' THEN
         RETURN Get_Event_Action_Enabled___(co_id_);
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      WHEN Custom_Objects_Type_API.DB_CUSTOM_FIELD THEN
         RETURN Get_Attribute_Synch___(co_id_); 
      WHEN Custom_Objects_Type_API.DB_CUSTOM_ENUMERATION THEN
            RETURN Get_Custom_Enum_Synch___(co_id_);
      WHEN Custom_Objects_Type_API.DB_CUSTOM_LU THEN
         RETURN Get_Custom_Lu_Synch___(co_id_);
      WHEN Custom_Objects_Type_API.DB_INFORMATION_CARD THEN
         RETURN Get_Attribute_Synch___(co_id_);
      WHEN Custom_Objects_Type_API.DB_CUSTOM_PAGE THEN
         RETURN Get_Custom_Page_Synch___(co_id_);
   $END
      ELSE
         RETURN Fnd_Boolean_API.DB_FALSE;
   END CASE;
END Get_Co_Synchronized;

FUNCTION Is_Deployment_Item_Included (
   dep_objects_ IN DeploymentObjectArray,
   item_name_   IN VARCHAR2,
   item_type_   IN VARCHAR2 DEFAULT '*') RETURN BOOLEAN
IS
BEGIN
   FOR i_ IN 1..dep_objects_.COUNT LOOP
      IF UPPER(dep_objects_(i_).name) = UPPER(item_name_) AND (item_type_ = '*' OR UPPER(dep_objects_(i_).item_type) = UPPER(item_type_)) THEN
         CASE dep_objects_(i_).error 
         WHEN App_Config_Util_API.Status_Error         THEN
            RETURN FALSE;
         WHEN App_Config_Util_API.Status_Deploy_Error  THEN
            RETURN FALSE;
         ELSE
            RETURN TRUE;         
         END CASE;         
      END IF;
   END LOOP;
   RETURN FALSE;
END Is_Deployment_Item_Included;

FUNCTION Is_Deployment_Object_Included (
   dep_objects_ IN DeploymentObjectArray,
   db_object_name_   IN VARCHAR2,
   db_object_type_   IN VARCHAR2 DEFAULT '*') RETURN BOOLEAN
IS
BEGIN
   FOR i_ IN 1..dep_objects_.COUNT LOOP
      IF UPPER(dep_objects_(i_).object_name) = UPPER(db_object_name_) AND (db_object_type_ = '*' OR UPPER(dep_objects_(i_).object_type) = UPPER(db_object_type_)) THEN
         CASE dep_objects_(i_).error 
         WHEN App_Config_Util_API.Status_Error         THEN
            RETURN FALSE;
         WHEN App_Config_Util_API.Status_Deploy_Error  THEN
            RETURN FALSE;
         ELSE
            RETURN TRUE;   
         END CASE;
      END IF;
   END LOOP;
   RETURN FALSE;
END Is_Deployment_Object_Included;

FUNCTION Get_Deployment_Object (
   dep_objects_ IN DeploymentObjectArray,
   item_name_   IN VARCHAR2,
   db_object_type_ IN VARCHAR2,
   item_type_   IN VARCHAR2 DEFAULT '*') RETURN VARCHAR2
IS
BEGIN
   FOR i_ IN 1..dep_objects_.COUNT LOOP
      IF UPPER(dep_objects_(i_).object_type) = UPPER(db_object_type_) AND UPPER(dep_objects_(i_).name) = UPPER(item_name_) AND (item_type_ = '*' OR UPPER(dep_objects_(i_).item_type) = UPPER(item_type_)) THEN  
         RETURN dep_objects_(i_).object_name;
      END IF;
   END LOOP;
   RETURN NULL;
END Get_Deployment_Object;

PROCEDURE Set_Item_To_Error (
   dep_objects_ IN OUT DeploymentObjectArray,
   item_name_   IN VARCHAR2,
   error_       IN AppConfigItemStatus,
   item_type_   IN VARCHAR2 DEFAULT '*')
IS
BEGIN
   FOR i_ IN 1..dep_objects_.COUNT LOOP
      IF UPPER(dep_objects_(i_).name) = UPPER(item_name_) AND (item_type_ = '*' OR UPPER(dep_objects_(i_).item_type) = UPPER(item_type_)) THEN
         dep_objects_(i_).error := error_;
         RETURN;
      END IF;
   END LOOP;
END Set_Item_To_Error;

PROCEDURE Set_Validation_Result(
   validation_result_        IN OUT VARCHAR2,
   item_validation_result_    IN  VARCHAR2 )
IS
BEGIN
   IF validation_result_ IS NULL OR item_validation_result_ > validation_result_ THEN
      validation_result_ := item_validation_result_;
   END IF;   
END Set_Validation_Result;

PROCEDURE Set_Validation_Completed(
    validation_result_        IN OUT VARCHAR2 )
IS
BEGIN
   --Sets status to validated if it is not in error or warning
   Set_Validation_Result(validation_result_, App_Config_Util_API.Status_Validated);
END Set_Validation_Completed;

FUNCTION Get_Validation_Result (
     validation_result_ IN AppConfigItemStatus ) RETURN VARCHAR2
IS 
BEGIN
   CASE validation_result_ 
      WHEN Status_Unknown    THEN RETURN 'UNKNOWN'; 
      WHEN Status_Error      THEN RETURN 'ERROR';
      WHEN Status_Deploy_Error THEN RETURN 'WARNING';
      WHEN Status_Warning    THEN RETURN 'WARNING';
      WHEN Status_Validated  THEN RETURN 'VALIDATED';
      ELSE RETURN 'UNKNOWN';         
   END CASE; 
END Get_Validation_Result;

FUNCTION View_Exist ( 
   view_name_           IN VARCHAR2,   
   dep_objects_         IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
IS
BEGIN
   --SOLSETFW
   IF Dictionary_SYS.View_Is_Active(view_name_) THEN
      RETURN TRUE;
   END IF;
   
   IF Is_Deployment_Object_Included(dep_objects_,view_name_,'VIEW') THEN
      RETURN TRUE;
   END IF;      
   RETURN FALSE;    
END View_Exist;


FUNCTION Method_Exist ( 
   full_method_name_    IN VARCHAR2,   
   dep_objects_         IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
 IS
   package_  VARCHAR2(50) := upper(substr(full_method_name_, 1, instr(full_method_name_, '.') - 1));
   method_   VARCHAR2(50) := initcap(substr(full_method_name_, instr(full_method_name_, '.') + 1));
BEGIN
   --SOLSETFW
   IF Dictionary_SYS.Method_Is_Active(package_, method_) THEN
      RETURN TRUE;
   END IF;
   
   IF Is_Deployment_Object_Included(dep_objects_,full_method_name_,'METHOD') THEN
      RETURN TRUE;
   END IF;   

   RETURN FALSE;    
END Method_Exist;

FUNCTION Column_Exist ( 
   full_column_name_    IN VARCHAR2,   
   dep_objects_         IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
IS
   table_name_    VARCHAR2(50) := upper(substr(full_column_name_, 1, instr(full_column_name_, '.') - 1));
   column_name_   VARCHAR2(50) := initcap(substr(full_column_name_, instr(full_column_name_, '.') + 1));
BEGIN
   --SOLSETFW
   IF Database_Sys.Column_Active(table_name_, column_name_) OR Is_Deployment_Object_Included(dep_objects_,full_column_name_,'COLUMN')THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;  
END Column_Exist;

FUNCTION Column_Exist ( 
   view_name_    IN VARCHAR2,
   column_name_  IN VARCHAR2, 
   dep_objects_         IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
IS
BEGIN
   --SOLSETFW
   IF Database_Sys.Column_Active(view_name_, column_name_) OR Is_Deployment_Object_Included(dep_objects_,view_name_ || '.' || column_name_,'COLUMN') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;   
END Column_Exist;

FUNCTION Table_Exist ( 
   table_name_  IN VARCHAR2,
   dep_objects_ IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
IS
BEGIN
   --SOLSETFW
   IF Database_SYS.Table_Active(table_name_) OR Is_Deployment_Object_Included(dep_objects_,table_name_ ,'TABLE') THEN
      RETURN TRUE;
   ELSE
      RETURN FALSE;
   END IF;   
END Table_Exist;

PROCEDURE Make_Item_Translatable (
   item_id_      IN VARCHAR2,
   item_type_db_ IN VARCHAR2)
IS 
BEGIN  
   CASE item_type_db_
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_PERSISTENT THEN
         Custom_Field_Translatable___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_FIELD_READ_ONLY THEN
         Custom_Field_Translatable___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_ENUMERATION THEN
         Custom_Enum_Translatable___(item_id_);
      WHEN App_Config_Item_Type_API.DB_CUSTOM_LU THEN
         Custom_Lu_Translatable___(item_id_);
      WHEN App_Config_Item_Type_API.DB_INFORMATION_CARD THEN
         Info_Card_Translatable___(item_id_);
   END CASE;
END Make_Item_Translatable;

-----------------------------------------------------------------------------------------------------------
--- Log Methods
-----------------------------------------------------------------------------------------------------------

PROCEDURE Log_Error (
   text_ IN VARCHAR2,
   indentation_offset_ IN NUMBER DEFAULT 0)
IS
BEGIN
   -- This methods are used by the Application Configuration Administration functionality
   -- available with FNDCOB. If Fndcob is not available don't log
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Application_Logger_API.Log(LOG_APPLICATION, Application_Logger_API.CATEGORY_ERROR, text_, TRUE, 9 - indentation_offset_);
   $ELSE
      NULL;
   $END
END Log_Error;

PROCEDURE Log_Warning (
   text_ IN VARCHAR2,
   identation_offset_ IN NUMBER DEFAULT 0)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Application_Logger_API.Log(LOG_APPLICATION, Application_Logger_API.CATEGORY_WARNING, text_, TRUE, 9 - identation_offset_);
   $ELSE
      NULL;
   $END
END Log_Warning;

PROCEDURE Log_Info (
   text_ IN VARCHAR2,
   identation_offset_ IN NUMBER DEFAULT 0)
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      Application_Logger_API.Log(LOG_APPLICATION, Application_Logger_API.CATEGORY_INFO, text_, TRUE, 9 - identation_offset_);
   $ELSE
      NULL;
   $END
END Log_Info;

PROCEDURE Get_Log_Information (
   log_info_ OUT CLOB )
IS
BEGIN
   $IF Component_Fndcob_SYS.INSTALLED $THEN
      dbms_lob.Createtemporary(log_info_, TRUE);
      Application_Logger_API.Get_All(log_info_, LOG_APPLICATION, FALSE, TRUE, TRUE);
   $ELSE
      NULL;
   $END
END Get_Log_Information;

------------------------------------------------------------------------------------------------------------------------------------
--- Dependency Message Creation Methods
------------------------------------------------------------------------------------------------------------------------------------

FUNCTION Init_Dependency_Message (
   item_key_      IN VARCHAR2,
   item_key_type_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   RETURN Message_SYS.Construct(item_key_type_ ||'-'||item_key_);
END Init_Dependency_Message;

PROCEDURE Add_Dependent (
   msg_ IN OUT VARCHAR2,
   dependent_name_ IN VARCHAR2,
   dependent_type_ IN VARCHAR2,
   dependent_key_  IN VARCHAR2,
   dependent_key_type_ IN VARCHAR2,
   is_available_   IN BOOLEAN,
   is_expandable_  IN VARCHAR2 DEFAULT NULL )
IS
   dependent_ VARCHAR2(1000);
   key_       VARCHAR2(100);
BEGIN
   dependent_ := Message_SYS.Construct(dependent_key_);
   Message_SYS.Add_Attribute(dependent_, 'DEPENDENT_NAME', dependent_name_);
   Message_SYS.Add_Attribute(dependent_, 'DEPENDENT_TYPE', dependent_type_);
   Message_SYS.Add_Attribute(dependent_, 'DEPENDENT_KEY', dependent_key_);
   Message_SYS.Add_Attribute(dependent_, 'DEPENDENT_KEY_TYPE', dependent_key_);
   
   IF is_available_ THEN
      Message_SYS.Add_Attribute(dependent_, 'IS_AVAILABLE', 'TRUE');
   ELSE
      Message_SYS.Add_Attribute(dependent_, 'IS_AVAILABLE', 'FALSE');
   END IF;
   
   IF is_expandable_ IS NOT NULL THEN
      Message_SYS.Add_Attribute(dependent_, 'IS_EXPANDABLE', is_expandable_);
   ELSE
      Message_SYS.Add_Attribute(dependent_, 'IS_EXPANDABLE', Is_Expandable_Item(dependent_type_));
   END IF;
   
   IF dependent_key_ IS NOT NULL THEN
      key_ := dependent_key_;
   ELSE
      key_ := dependent_name_;
   END IF;
   
   Message_SYS.Add_Attribute(msg_, key_, dependent_);
END Add_Dependent;

PROCEDURE Add_Dependent_Object (
   msg_ IN OUT VARCHAR2,
   dependent_name_ IN VARCHAR2,
   dependent_type_ IN VARCHAR2,
   dependent_key_  IN VARCHAR2,
   is_available_   IN BOOLEAN,
   is_expandable_  IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Add_Dependent(msg_, dependent_name_, dependent_type_, dependent_key_, 'OBJECT', is_available_, is_expandable_);
END Add_Dependent_Object;

PROCEDURE Add_Dependent_App_Config_Item (
   msg_ IN OUT VARCHAR2,
   dependent_name_ IN VARCHAR2,
   dependent_type_ IN VARCHAR2,
   dependent_key_  IN VARCHAR2,
   dependent_key_package_ IN VARCHAR2,
   is_available_   IN BOOLEAN,
   is_expandable_  IN VARCHAR2 DEFAULT NULL )
IS
BEGIN
   Add_Dependent(msg_, dependent_name_, dependent_type_, dependent_key_||'/'||dependent_key_package_, 'APP_CONFIG_ITEM', is_available_, is_expandable_);
END Add_Dependent_App_Config_Item;

FUNCTION Is_Expandable_Item (
   item_type_ IN VARCHAR2 ) RETURN VARCHAR2
IS
BEGIN
   IF item_type_ IN (App_Config_Dependent_Type_API.DB_CUSTOM_MENU,
                     App_Config_Dependent_Type_API.DB_CUSTOM_FIELD_PERSISTENT,
                     App_Config_Dependent_Type_API.DB_CUSTOM_FIELD_READ_ONLY,
                     App_Config_Dependent_Type_API.DB_CUSTOM_ENUMERATION,
                     App_Config_Dependent_Type_API.DB_CUSTOM_LU) THEN
      RETURN 'TRUE';
   ELSE
      RETURN 'FALSE';
   END IF;
END Is_Expandable_Item;