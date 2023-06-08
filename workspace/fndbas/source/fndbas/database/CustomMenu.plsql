-----------------------------------------------------------------------------
--
--  Logical unit: CustomMenu
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980119  DOZE  Created.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  040120  RAKU  Changed comment (length) on PARAMETER to 2000 (Bug#42177).
--  040331  HAAR  Unicode bulk changes, removed extensive use of Substr and/or Substrb (F1PR408B).
--  081008  HASPLK Changed comment (length) on PARAMETER to 4000 and ENABLED_WHEN to 1000 (Bug#76799).
--  081215  HAAR  New custom menu types needed by Enterprise Explorer (Bug#79193).
--  091007  ASWILK ENABLED_WHEN increased from 200 to 1000(Bug#86236).
--  120903  WAWILK Setting Default PO_IDs for custom menu types 10,11,12 (Bug#104983)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

EXPORT_DEF_VERSION      CONSTANT VARCHAR2(5) := '1.0';
XMLTAG_CUST_TEXTS       CONSTANT VARCHAR2(50)  := 'TEXTS';
XMLTAG_KEY_TRANS        CONSTANT VARCHAR2(50)  := 'KEY_TRANSLATIONS';
XMLTAG_KEY_EXPPAR       CONSTANT VARCHAR2(50)  := 'EXPANDABLE_PARAMETERS';
XMLTAG_CUST_OBJ_EXP     CONSTANT VARCHAR2(50)  := 'CUSTOM_OBJECT';
XMLTAG_CUST_OBJ_TYPE_MENU CONSTANT VARCHAR2(50)  := 'CUSTOM_MENU';
XMLTAG_CUST_OBJ_EXP_DEF_VER CONSTANT VARCHAR2(50)  := 'EXPORT_DEF_VERSION';



CURSOR get_header(xml_ CLOB) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CUSTOM_MENU' passing Xmltype(xml_)
                         COLUMNS
                            EXPORT_DEF_VERSION VARCHAR2(30) path 'EXPORT_DEF_VERSION',
                            MENU_ID NUMBER path 'MENU_ID',
                            DESCRIPTION VARCHAR2(2000) path 'DESCRIPTION',
                            WINDOW VARCHAR2(100) path 'WINDOW',
                            PROCESS VARCHAR2(100) path 'PROCESS',
                            ORDERING NUMBER(3) path 'ORDERING',
                            PARAMETER VARCHAR2(4000) path 'PARAMETER',
                            CUSTOM_MENU_TYPE VARCHAR2(20) path 'CUSTOM_MENU_TYPE_DB', 
                            BUNDLE_EXECUTION VARCHAR2(5) path 'BUNDLE_EXECUTION_DB',
                            PO_ID VARCHAR2(200) path 'PO_ID',
                            ENABLED_WHEN CLOB path 'ENABLED_WHEN',
                            REFRESH_UI VARCHAR2(4000) path 'REFRESH_UI',
                            EXPORTED_DATE VARCHAR2(50) path 'EXPORTED_DATE' ,
                            DEFINITION_MODIFIED_DATE VARCHAR2(50) path 'DEFINITION_MODIFIED_DATE',
                            OBJKEY VARCHAR2(100) path 'ROWKEY'
                        ) xt1;                       

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   menu_id_ NUMBER;
BEGIN
   menu_id_ := Client_SYS.Get_Item_Value('MENU_ID', attr_);
   super(attr_);
    
   WHILE (menu_id_ IS NULL OR Check_Exist___(menu_id_)) LOOP
      SELECT trunc(mod((extract(second from systimestamp)+extract(minute from systimestamp)*60)*1000, 1000000))
      INTO menu_id_
      FROM dual;
   END LOOP;
     
   --SELECT custom_menu_seq.nextval into menu_id_ from dual;
   Client_SYS.Add_To_Attr('MENU_ID', menu_id_, attr_);
   Client_SYS.Add_To_Attr('PROCESS', 'NONE', attr_);
   Client_SYS.Add_To_Attr('BUNDLE_EXECUTION_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('BUNDLE_EXECUTION', Fnd_Boolean_API.Encode('FALSE'), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOM_MENU_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.ordering IS NULL THEN
      SELECT MAX(ordering)
        INTO newrec_.ordering
        FROM CUSTOM_MENU
       WHERE window = newrec_.window
         AND process = newrec_.process;
      newrec_.ordering := nvl(newrec_.ordering, 0) + 1;
      Client_SYS.Add_To_Attr('ORDERING', newrec_.ordering, attr_);
   END IF;
   --
   -- Check if FndUser has system privilege DEFINE SQL in order to enter PLSQL BLOCK for Custom Menus
   --
   IF (newrec_.custom_menu_type = '12') THEN -- PLSQL Block
      Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_session_API.Get_Fnd_User);
   END IF;
   --
   -- Set bundle_execution
   --
   IF (newrec_.bundle_execution IS NULL) THEN
       newrec_.bundle_execution := 'FALSE';
   END IF;
   --
   --
   -- Set PO Id if necessary
   --
   IF (newrec_.po_id IS NULL) THEN
       newrec_.po_id := Get_Po_Id___(newrec_);
       Client_SYS.Add_To_Attr('PO_ID',newrec_.po_id, attr_);
   END IF;
   --
   IF newrec_.definition_modified_date IS NULL THEN 
      newrec_.definition_modified_date := sysdate;
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOM_MENU_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOM_MENU_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN BOOLEAN DEFAULT FALSE )
IS
BEGIN
   --
   -- Check if FndUser has system privilege DEFINE SQL in order to enter PLSQL BLOCK for Custom Menus
   --
   IF (newrec_.custom_menu_type = '12') THEN -- PLSQL Block
      Security_SYS.Has_System_Privilege('DEFINE SQL', Fnd_session_API.Get_Fnd_User);
   END IF;
   --
   -- Set PO Id if necessary
   --
   IF (newrec_.po_id IS NULL) THEN
       newrec_.po_id := Get_Po_Id___(newrec_);
   END IF;
   --
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;

@Override
PROCEDURE Check_Delete___ (
   remrec_ IN     custom_menu_tab%ROWTYPE )
IS
   package_name_ VARCHAR2(100);
BEGIN
   --Add pre-processing code here
   package_name_ := App_Config_Package_API.Get_Item_Package_Name(remrec_.rowkey);
   IF (package_name_ IS NOT NULL) THEN
      Error_Sys.Record_General(lu_name_,'ITEM_CONNECTED_TO_PKG: The custom menu cannot be deleted, unless removed from the package ":P1".', package_name_);
   END IF;   
   super(remrec_);
   --Add post-processing code here
END Check_Delete___;



-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

FUNCTION Get_Po_For_Window___ (window_ IN VARCHAR2) RETURN VARCHAR2
IS
BEGIN
   -- for child tables, the form window will be given in the format frmxxxxxxx.tblyyyyyyy. 
   -- Yet, the relevant presentation object should be that of the form window
   IF (INSTR(window_, '.')> 0) THEN 
     RETURN SUBSTR(window_,0,INSTR(window_, '.') -1);              
   ELSE 
      RETURN window_;
   END IF;   
   
END Get_Po_For_Window___;

FUNCTION Get_Po_Id___ (
   rec_     IN OUT CUSTOM_MENU_TAB%ROWTYPE ) RETURN VARCHAR2
IS
BEGIN
   CASE rec_.custom_menu_type
      WHEN '1' THEN
         RETURN(rec_.parameter);
      WHEN '2' THEN
         RETURN(rec_.parameter);
      WHEN '8' THEN
         RETURN('rep'||rec_.parameter);
      WHEN '9' THEN
         RETURN('repQUICK_REPORT'||rec_.parameter);
      WHEN '10' THEN
         RETURN Get_Po_For_Window___(rec_.window);
      WHEN '11' THEN
         RETURN Get_Po_For_Window___(rec_.window);
      WHEN '12' THEN
         RETURN Get_Po_For_Window___(rec_.window);
      ELSE
         RETURN(NULL);
   END CASE;
END Get_Po_Id___;

FUNCTION Substitute_Owner_Prefix___(
   sql_expression_ IN CLOB ) RETURN VARCHAR2
IS
   prefix_         VARCHAR2(31)   := Fnd_Session_API.Get_App_Owner||'.';
   ial_prefix_     VARCHAR2(31)   := Fnd_Setting_API.Get_Value('IAL_USER')||'.';
   stmt_           CLOB           := sql_expression_;
BEGIN
   -- Look for appowner prefixing function calls and views
   -- Replace AO and APPOWNER with actual appowner
   -- Note! Important to do the test in this order
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'AO\.\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'APPOWNER\.\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'IAL\.\.', ial_prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'AO\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'APPOWNER\.', prefix_,1,0,'i');
   stmt_ := REGEXP_REPLACE(stmt_, chr(38)||'IAL\.', ial_prefix_,1,0,'i');
   RETURN(stmt_);
END Substitute_Owner_Prefix___;   

PROCEDURE Validate_PLSQL___(
   stmt_                IN OUT VARCHAR2,
   validation_result_   IN OUT App_Config_Util_API.AppConfigItemStatus,
   validation_details_  IN OUT VARCHAR2,
   dep_objects_         IN App_Config_Util_API.DeploymentObjectArray)
IS 
   prefix_         VARCHAR2(31)   := Fnd_Session_API.Get_App_Owner||'.';
   pos_            NUMBER;
   to_pos_         NUMBER;
   char_number_    NUMBER;
   db_object_      VARCHAR2(2000);
   object_type_    VARCHAR2(6);
   action_type_    VARCHAR2(200) := Custom_Menu_Type_API.Decode(Custom_Menu_Type_API.DB_PLSQL_BLOCK);
BEGIN
   stmt_ := UPPER(Substitute_Owner_Prefix___(stmt_));
      --
   pos_ := instr(stmt_, prefix_);
   WHILE pos_ > 0 LOOP
      pos_ := pos_ + length(prefix_);
      to_pos_ := pos_;

      -- Look for the end of the db-object (characters in db-objects are ascii: 46, 48..57, 65..90, 95)
      char_number_ := ascii(substr(stmt_, to_pos_, 1));
      WHILE char_number_ = 46 OR char_number_ = 36 OR (char_number_ BETWEEN 48 AND 57) OR (char_number_ between 65 and 90) OR char_number_ = 95 LOOP
         to_pos_ := to_pos_ + 1;
         char_number_ := ascii(substr(stmt_, to_pos_, 1));
      END LOOP;

      -- Extract the db-object
      db_object_ := substr(stmt_, pos_, to_pos_ - pos_);

      -- Validate the db-object and insert it
      IF db_object_ IS NOT NULL THEN
         -- Define type
         IF instr(db_object_, '_API.') > 0 OR instr(db_object_, '_SYS.') > 0 OR instr(db_object_, '_RPI.') > 0
         OR instr(db_object_, '_CFP.') > 0 OR instr(db_object_, '_CLP.') > 0 OR instr(db_object_, '_ICP.') > 0
         OR instr(db_object_, '_SVC.') > 0 THEN
            db_object_   := upper(substr(db_object_, 1, instr(db_object_, '.') - 1))||InitCap(substr(db_object_, instr(db_object_, '.')));
            object_type_ := 'METHOD';           
         ELSE
            object_type_ := 'VIEW';
         END IF;
         -- Avoid incorrect objects
         IF object_type_ = 'VIEW' AND instr(db_object_, '.') > 0 THEN
            -- Discovered column prefixed with view, removing column name
            db_object_ := substr(db_object_, 1, instr(db_object_, '.') - 1 );
         END IF;
         IF object_type_ = 'VIEW' THEN
            IF length(db_object_) > 30 THEN
               -- Too long view name
               App_Config_Util_API.Set_Validation_Result(validation_result_, App_Config_Util_API.Status_Deploy_Error);
               Utility_SYS.Append_Text_Line(validation_details_, Language_SYS.Translate_Constant(lu_name_,'VIEW_TOO_LONG: Error: The :P1 menu action has errors. The view name ":P2" is too long.',Fnd_Session_API.Get_Language,action_type_,db_object_), TRUE);
            END IF;
            IF NOT View_Exist__(db_object_, dep_objects_) THEN
                App_Config_Util_API.Set_Validation_Result(validation_result_, App_Config_Util_API.Status_Deploy_Error);
                Utility_SYS.Append_Text_Line(validation_details_, Language_SYS.Translate_Constant(lu_name_,'VIEW_NOT_FOUND: Error: The :P1 menu action has errors. The view ":P2" cannot be found.',Fnd_Session_API.Get_Language,action_type_,db_object_), TRUE);
            END IF;   
         ELSIF object_type_ = 'METHOD' THEN
            IF length(db_object_) > 61 THEN
               -- Too long method name
               App_Config_Util_API.Set_Validation_Result(validation_result_, App_Config_Util_API.Status_Deploy_Error);
               Utility_SYS.Append_Text_Line(validation_details_, Language_SYS.Translate_Constant(lu_name_,'METHOD_TOO_LONG: Error: The :P1 menu action has errors. The method name ":P2" is too long.',Fnd_Session_API.Get_Language,action_type_,db_object_), TRUE);
            END IF;
             IF NOT Method_Exist__(db_object_, dep_objects_) THEN
                App_Config_Util_API.Set_Validation_Result(validation_result_, App_Config_Util_API.Status_Deploy_Error);
                Utility_SYS.Append_Text_Line(validation_details_, Language_SYS.Translate_Constant(lu_name_,'METHOD_NOT_FOUND: Error: The :P1 menu action has errors. The method ":P2" cannot be found.',Fnd_Session_API.Get_Language,action_type_,db_object_), TRUE);
            END IF;   
         END IF;
      END IF;
      -- Reinitiate variables
      db_object_ := NULL;
      -- Find next occurance of prefix, start from end of last occurance
      pos_ := instr(stmt_, prefix_, pos_);
   END LOOP;
END Validate_PLSQL___;

PROCEDURE Extract_PLSQL_Dependents___(
   dependent_msg_       IN OUT VARCHAR2,
   in_stmt_                IN VARCHAR2)
IS 
   prefix_         VARCHAR2(31)   := Fnd_Session_API.Get_App_Owner||'.';
   pos_            NUMBER;
   to_pos_         NUMBER;
   char_number_    NUMBER;
   db_object_      VARCHAR2(2000);
   object_type_    VARCHAR2(6);
   stmt_           VARCHAR2(32000) := in_stmt_;
   dep_objects_    App_Config_Util_API.DeploymentObjectArray;
BEGIN
   
   stmt_ := UPPER(Substitute_Owner_Prefix___(stmt_));
      --
   pos_ := instr(stmt_, prefix_);
   WHILE pos_ > 0 LOOP
      pos_ := pos_ + length(prefix_);
      to_pos_ := pos_;

      -- Look for the end of the db-object (characters in db-objects are ascii: 46, 48..57, 65..90, 95)
      char_number_ := ascii(substr(stmt_, to_pos_, 1));
      WHILE char_number_ = 46 OR (char_number_ BETWEEN 48 AND 57) OR (char_number_ between 65 and 90) OR char_number_ = 95 LOOP
         to_pos_ := to_pos_ + 1;
         char_number_ := ascii(substr(stmt_, to_pos_, 1));
      END LOOP;

      -- Extract the db-object
      db_object_ := substr(stmt_, pos_, to_pos_ - pos_);

      -- Validate the db-object and insert it
      IF db_object_ IS NOT NULL THEN
         -- Define type
         IF instr(db_object_, '_API.') > 0 OR instr(db_object_, '_SYS.') > 0 OR instr(db_object_, '_RPI.') > 0 OR instr(db_object_, '_CFP.') > 0 THEN
            db_object_   := upper(substr(db_object_, 1, instr(db_object_, '.') - 1))||InitCap(substr(db_object_, instr(db_object_, '.')));
            object_type_ := 'METHOD';           
         ELSE
            object_type_ := 'VIEW';
         END IF;
         -- Avoid incorrect objects
         IF object_type_ = 'VIEW' AND instr(db_object_, '.') > 0 THEN
            -- Discovered column prefixed with view, removing column name
            db_object_ := substr(db_object_, 1, instr(db_object_, '.') - 1 );
         END IF;
         IF object_type_ = 'VIEW' THEN
            IF db_object_ LIKE '%/_CFV' ESCAPE '/' OR db_object_ LIKE '%/_CLV' ESCAPE '/' THEN
               App_Config_Util_API.Add_Dependent_Object(dependent_msg_, db_object_, App_Config_Dependent_Type_API.DB_CUSTOM_FIELD_VIEW, db_object_, Database_SYS.View_Active(db_object_));
            ELSE
               App_Config_Util_API.Add_Dependent_Object(dependent_msg_, db_object_, App_Config_Dependent_Type_API.DB_CORE_VIEW, db_object_, Database_SYS.View_Active(db_object_));
            END IF;
         ELSIF object_type_ = 'METHOD' THEN
            IF instr(db_object_, '_CFP.') > 0 THEN
               App_Config_Util_API.Add_Dependent_Object(dependent_msg_, db_object_, App_Config_Dependent_Type_API.DB_CUSTOM_PACKAGE_METHOD, db_object_, Method_Exist__(db_object_, dep_objects_));
            ELSE
               App_Config_Util_API.Add_Dependent_Object(dependent_msg_, db_object_, App_Config_Dependent_Type_API.DB_CORE_PACKAGE_METHOD, db_object_, Method_Exist__(db_object_, dep_objects_));
            END IF;  
         END IF;
      END IF;
      -- Reinitiate variables
      db_object_ := NULL;
      -- Find next occurance of prefix, start from end of last occurance
      pos_ := instr(stmt_, prefix_, pos_);
   END LOOP;
END Extract_PLSQL_Dependents___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------
@Override
PROCEDURE Modify__ (
   info_          OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   IF action_ = 'DO' THEN
      Client_SYS.Add_To_Attr('DEFINITION_MODIFIED_DATE', sysdate, attr_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
END Modify__;

PROCEDURE Export_XML__ (
   out_xml_        OUT CLOB,
   menu_id_ IN     VARCHAR2)
IS
   --
   date_format_ VARCHAR2(100) := Client_SYS.date_format_;
   stmt_ VARCHAR2(32000) := 'SELECT '||EXPORT_DEF_VERSION||' "@'||XMLTAG_CUST_OBJ_EXP_DEF_VER||'",
                                     m.menu_id,
                                     m.description,
                                     m.window, 
                                     m.process, 
                                     m.ordering, 
                                     m.parameter, 
                                     m.custom_menu_type_db, 
                                     m.bundle_execution_db, 
                                     m.po_id, 
                                     m.enabled_when, 
                                     m.refresh_ui_db refresh_ui,
                                     to_char(sysdate, '''||date_format_||''') export_date,
                                     to_char(definition_modified_date , '''||date_format_||''') definition_modified_date,
                                     m.objversion,
                                     m.objkey,
                                       CURSOR( SELECT 
                                                      t.language_code,
                                                      t.title,                                                      
                                                      t.objkey
                                                      FROM custom_menu_text t
                                                      WHERE t.menu_id = '|| menu_id_ ||'
                                       )'||XMLTAG_CUST_TEXTS ||',
                                       CURSOR ( SELECT 
                                                      k.id,
                                                      k.source_key_name,
                                                      k.dest_key_name,
                                                      k.objkey
                                                FROM custom_menu_key_trans k
                                                WHERE k.menu_id = '|| menu_id_ ||'
                                       )' ||XMLTAG_KEY_TRANS||',
                                       CURSOR ( SELECT 
                                                      e.parameter,
                                                      e.source,
                                                      e.objkey
                                                FROM custom_menu_exp_par e
                                                WHERE e.menu_id = '|| menu_id_ ||'
                                       )' ||XMLTAG_KEY_EXPPAR|| '
                                       FROM custom_menu m
                                       WHERE menu_id = '|| menu_id_ ||'';   
   ctx_    dbms_xmlgen.ctxHandle;
   xml_     XMLType;
   objkey_  VARCHAR2(100);
   xpath_   CONSTANT VARCHAR2(100) := '/'||XMLTAG_CUST_OBJ_EXP||'/'||XMLTAG_CUST_OBJ_TYPE_MENU;
BEGIN
   --dbms_output.put_line(stmt_);
   ctx_ := Dbms_Xmlgen.newContext(stmt_);
   objkey_ := Custom_Menu_API.Get_Objkey(menu_id_);
   Log_SYS.App_Trace(Log_SYS.debug_, 'XML Export Statement: '|| stmt_);
   dbms_xmlgen.setNullHandling(ctx_, dbms_xmlgen.EMPTY_TAG);
   dbms_xmlgen.setRowSetTag(ctx_, XMLTAG_CUST_OBJ_EXP);
   dbms_xmlgen.setRowTag(ctx_, XMLTAG_CUST_OBJ_TYPE_MENU);
   xml_ := dbms_xmlgen.getXMLType(ctx_);
   Dbms_Xmlgen.Closecontext(ctx_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'NAME', 
                                      App_Config_Util_API.Get_Item_Name(objkey_, App_Config_Item_Type_API.DB_CUSTOM_MENU),
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'TYPE', 
                                      App_Config_Item_Type_API.DB_CUSTOM_MENU,
                                      xpath_);
   Utility_SYS.Add_Xml_Element_Before(xml_, 'DESCRIPTION', 
                                      App_Config_Util_API.Get_Item_Description(objkey_, App_Config_Item_Type_API.DB_CUSTOM_MENU),
                                      xpath_);
   Utility_SYS.XmlType_To_CLOB(out_xml_, xml_);
END Export_XML__;

PROCEDURE Import_XML__ (
   rowkey_    OUT VARCHAR2,
   name_      OUT VARCHAR2,
   identical_  OUT BOOLEAN,
   xml_       IN CLOB)
IS
   custom_menu_rec_        custom_menu_tab%ROWTYPE;   
   menu_id_                VARCHAR2(100);   
   
BEGIN
   identical_ := FALSE;
   FOR rec_ IN get_header(xml_) LOOP
      custom_menu_rec_ := Get_Object_By_Keys___(rec_.menu_id);
      IF custom_menu_rec_.menu_id IS NULL THEN
         Prepare_New___(custom_menu_rec_);
         custom_menu_rec_.menu_id            := rec_.menu_id;
         custom_menu_rec_.description        := Utility_SYS.Set_Windows_New_Line(rec_.description);
         custom_menu_rec_.bundle_execution   := rec_.bundle_execution;
         custom_menu_rec_.enabled_when       := rec_.enabled_when;
         custom_menu_rec_.ordering           := rec_.ordering;
         custom_menu_rec_.parameter          := Utility_SYS.Set_Windows_New_Line(rec_.parameter);
         custom_menu_rec_.po_id              := rec_.po_id;
         custom_menu_rec_.process            := rec_.process;
         custom_menu_rec_.refresh_ui         := UPPER(rec_.refresh_ui);
         custom_menu_rec_.rowkey             := rec_.objkey;
         custom_menu_rec_.window             := rec_.window;
         custom_menu_rec_.custom_menu_type   := rec_.custom_menu_type;
         custom_menu_rec_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
         New___(custom_menu_rec_);
         App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'CREATE_CUSTOM_MENU: Custom menu ":P1" added',Fnd_Session_API.Get_Language,rec_.description));
      ELSE
         custom_menu_rec_ := Lock_By_Keys_Nowait___(rec_.menu_id);
         IF (custom_menu_rec_.definition_modified_date <> to_date(rec_.definition_modified_date, Client_SYS.date_format_)) THEN       
            custom_menu_rec_.description        := Utility_SYS.Set_Windows_New_Line(rec_.description);
            custom_menu_rec_.bundle_execution   := rec_.bundle_execution;
            custom_menu_rec_.enabled_when       := rec_.enabled_when;
            custom_menu_rec_.ordering           := rec_.ordering;
            custom_menu_rec_.parameter          := Utility_SYS.Set_Windows_New_Line(rec_.parameter);
            custom_menu_rec_.po_id              := rec_.po_id;
            custom_menu_rec_.process            := rec_.process;
            custom_menu_rec_.refresh_ui         := UPPER(rec_.refresh_ui);
            custom_menu_rec_.window             := rec_.window;
            custom_menu_rec_.definition_modified_date := to_date(rec_.definition_modified_date, Client_SYS.date_format_);
            Modify___(custom_menu_rec_);        
            App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'UPDATE_CUSTOM_MENU: Custom menu updated ":P1" - ":P2" ',Fnd_Session_API.Get_Language,Custom_Menu_Util_API.Get_Menu_Title(rec_.menu_id),rec_.description));
         ELSE
            identical_ := TRUE;
            --App_Config_Util_API.Log_Info( Language_SYS.Translate_Constant(lu_name_,'IGNORE_CUSTOM_MENU: Custom menu identical ":P1" - ":P2". Ignored. ',Fnd_Session_API.Get_Language,Custom_Menu_Util_API.Get_Menu_Title(rec_.menu_id),rec_.description));
         END IF;
         --ELSE -- Assumption is that menu id itself is globally unique
         --   App_Config_Util_API.Log_Error( Language_SYS.Translate_Constant(lu_name_,'MENU_EXISTS2: Another Custom Menu :P1 (:P2) already exist.',Fnd_Session_API.Get_Language,Custom_Menu_Util_API.Get_Menu_Title(rec_.menu_id), rec_.window));      
      END IF;
      rowkey_  := custom_menu_rec_.rowkey;
      menu_id_ := custom_menu_rec_.menu_id;      
   END LOOP;
   
   IF NOT identical_ THEN
      Custom_Menu_Text_API.Import_Xml(menu_id_, xml_);
      Custom_Menu_Key_Trans_API.Import_Xml(menu_id_, xml_);
      Custom_Menu_Exp_Par_API.Import_Xml(menu_id_, xml_);
   END IF;
   name_ := Custom_Menu_Util_API.Get_Menu_Title(menu_id_);
   
EXCEPTION
   WHEN OTHERS THEN
      IF get_header%ISOPEN THEN
         CLOSE get_header;
      END IF;            
      RAISE;
END Import_XML__;
   
FUNCTION View_Exist__ ( 
   view_name_           IN VARCHAR2,   
   dep_objects_         IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
IS
BEGIN
   --SOLSETFW
   IF Dictionary_SYS.View_Is_Active(view_name_) THEN
      RETURN TRUE;
   END IF;
   
   IF App_Config_Util_API.Is_Deployment_Object_Included(dep_objects_,view_name_,'VIEW') THEN
      RETURN TRUE;
   END IF;      
   RETURN FALSE;    
END View_Exist__;


FUNCTION Method_Exist__ ( 
   full_method_name_    IN VARCHAR2,   
   dep_objects_         IN App_Config_Util_API.DeploymentObjectArray ) RETURN BOOLEAN
 IS
   package_  VARCHAR2(50) := upper(substr(full_method_name_, 1, instr(full_method_name_, '.') - 1));
   method_   VARCHAR2(50) := initcap(substr(full_method_name_, instr(full_method_name_, '.') + 1));
BEGIN
  
   IF Dictionary_SYS.Method_Is_Active(package_, method_) THEN
      RETURN TRUE;
   END IF;
   
   IF App_Config_Util_API.Is_Deployment_Object_Included(dep_objects_,full_method_name_,'METHOD') THEN
      RETURN TRUE;
   END IF;   

   RETURN FALSE;    
END Method_Exist__;

FUNCTION Get_Dependent_Items___ (
   rec_                   IN custom_menu_tab%ROWTYPE,
   current_item_location_ IN VARCHAR2,
   objkey_                IN VARCHAR2) RETURN VARCHAR2
IS
   main_objkey_ VARCHAR2(100);
   main_item_type_ VARCHAR2(100);
   dependent_msg_ VARCHAR2(32000);
   dependent_name_ VARCHAR2(1000);
BEGIN 
   main_objkey_ := objkey_;
   main_item_type_ := App_Config_Item_Type_API.DB_CUSTOM_MENU;              
   dependent_msg_ := App_Config_Util_API.Init_Dependency_Message(main_objkey_, current_item_location_);
      
   IF rec_.po_id IS NOT NULL THEN
      dependent_name_ :=  Pres_Object_API.Get_Description(rec_.po_id);        
      IF dependent_name_ IS NULL THEN
         dependent_name_ := 'PresObject-'||rec_.po_id;
      END IF;
      App_Config_Util_API.Add_Dependent_Object(dependent_msg_, dependent_name_, App_Config_Dependent_Type_API.DB_PRESENTATION_OBJECT, rec_.po_id, Pres_Object_API.Exists(rec_.po_id));
      dependent_name_ := NULL;
   END IF;
           
   IF rec_.custom_menu_type = Custom_Menu_Type_API.DB_QUICK_REPORT THEN
      dependent_name_ := Quick_Report_API.Get_Description(rec_.parameter);        
      IF dependent_name_ IS NULL THEN
         dependent_name_ := 'QuickReport-'||rec_.parameter;
      END IF;
      App_Config_Util_API.Add_Dependent_Object(dependent_msg_, dependent_name_, App_Config_Dependent_Type_API.DB_QUICK_REPORT, rec_.parameter, Quick_Report_API.Exists(rec_.parameter));
      dependent_name_ := NULL;
   ELSIF rec_.custom_menu_type = Custom_Menu_Type_API.DB_REPORT THEN
      dependent_name_ := Report_Definition_API.Get_Report_Title(rec_.parameter);        
      IF dependent_name_ IS NULL THEN
         dependent_name_ := 'Report-'||rec_.parameter;
      END IF;
      App_Config_Util_API.Add_Dependent_Object(dependent_msg_, dependent_name_, App_Config_Dependent_Type_API.DB_REPORT, rec_.parameter, Report_Definition_API.Exists(rec_.parameter));
      dependent_name_ := NULL;
   ELSIF rec_.custom_menu_type = Custom_Menu_Type_API.DB_PLSQL_BLOCK THEN
      Extract_PLSQL_Dependents___(dependent_msg_, rec_.parameter);
   ELSE
      NULL;
   END IF;
   RETURN dependent_msg_;
END Get_Dependent_Items___;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

PROCEDURE Update_Definition_Mod_Date_(
   menu_id_ IN VARCHAR2)
IS
BEGIN
   UPDATE custom_menu_tab
   SET definition_modified_date = SYSDATE
   WHERE menu_id = menu_id_;
END Update_Definition_Mod_Date_;

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

FUNCTION Get_Menu_Id_By_Rowkey (
   rowkey_ IN VARCHAR2)  RETURN VARCHAR2
IS
   menu_id_ VARCHAR2(100); 
BEGIN
   SELECT menu_id  
         INTO  menu_id_
         FROM  custom_menu_tab
         WHERE rowkey = rowkey_;
      RETURN menu_id_;
      
END Get_Menu_Id_By_Rowkey;

FUNCTION Get_Def_Modified_By_Rowkey (
   rowkey_ IN VARCHAR2 ) RETURN DATE
IS
   definition_modified_date_ custom_menu_tab.definition_modified_date%TYPE;
BEGIN
   SELECT definition_modified_date INTO definition_modified_date_
   FROM custom_menu_tab
   WHERE rowkey = rowkey_;
   RETURN definition_modified_date_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
END Get_Def_Modified_By_Rowkey;
   
PROCEDURE Create_Custom_Menu (
   configuration_item_id_  OUT VARCHAR2, 
   name_                   OUT VARCHAR2,
   identical_              OUT BOOLEAN,
   xml_                    IN CLOB)
IS 
BEGIN
   Import_XML__(configuration_item_id_, name_, identical_, xml_);
END Create_Custom_Menu;

PROCEDURE Validate_Import (
   info_          OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_   IN OUT App_Config_Util_API.DeploymentObjectArray,
   xml_           IN CLOB,
   version_time_stamp_ IN DATE)
   
IS
   custom_menu_rec_        custom_menu_tab%ROWTYPE;
   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   import_date_ DATE;
   newrec_ custom_menu_tab%ROWTYPE;
BEGIN 
   info_.validation_result    := App_Config_Util_API.Status_Unknown; 
   info_.validation_details   := NULL; 
   FOR rec_ IN get_header(xml_) LOOP
      
      info_.name                 := substr(trim(Utility_SYS.Set_Windows_New_Line(rec_.description)),1 ,100 );
      info_.item_type            := App_Config_Item_Type_API.DB_CUSTOM_MENU;
      info_.last_modified_date   := Client_Sys.Attr_Value_To_Date(rec_.definition_modified_date);
      custom_menu_rec_ := Get_Object_By_Keys___(rec_.menu_id);
      IF custom_menu_rec_.menu_id IS NULL THEN
         info_.exists := 'FALSE';
      ELSE
         info_.exists := 'TRUE';
         info_.current_description := custom_menu_rec_.description;
         info_.current_published := 'TRUE';
         info_.current_last_modified_date := custom_menu_rec_.definition_modified_date;           
         App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, custom_menu_rec_.rowkey);         
         IF (info_.last_modified_date <> custom_menu_rec_.definition_modified_date) THEN
            import_date_:= App_Config_Package_API.Get_Imported_Date(info_.current_package_id);
            IF (import_date_ IS NOT NULL) AND nvl(custom_menu_rec_.definition_modified_date,Database_SYS.Get_First_Calendar_Date) > import_date_ THEN
               App_Config_Util_API.Set_Validation_Result(info_.validation_result, App_Config_Util_API.Status_Warning);
               Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'EDITED_ITEM: Warning: There are local changes that will be overwritten.',Fnd_Session_API.Get_Language), TRUE); 
            END IF;
         END IF;
      END IF;
      
      newrec_.po_id := rec_.po_id;
      newrec_.custom_menu_type := rec_.custom_menu_type;
      newrec_.parameter := rec_.parameter;
      newrec_.menu_id := rec_.menu_id;
      newrec_.description := rec_.description;
      Validate___(info_,dep_objects_,newrec_);
      
      EXIT;
   END LOOP;
   App_Config_Util_API.Set_Validation_Completed(info_.validation_result);
END Validate_Import;

PROCEDURE Validate___(
   info_ IN OUT App_Config_Util_API.AppConfigItemInfo,
   dep_objects_   IN OUT App_Config_Util_API.DeploymentObjectArray,
   rec_ IN OUT custom_menu_tab%ROWTYPE
   )
IS
BEGIN
   IF rec_.po_id IS NOT NULL THEN
      IF NOT (Pres_Object_API.Exists(rec_.po_id) OR App_Config_Util_API.Is_Deployment_Object_Included(dep_objects_, rec_.po_id, 'PRES_OBJECT')) THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result,App_Config_Util_API.Status_Error);
         Utility_SYS.Append_Text_Line(info_.validation_details,Language_SYS.Translate_Constant(lu_name_,'PO_NOT_EXIST: Error: The presentation object ":P1" does not exist.',Fnd_Session_API.Get_Language, rec_.po_id), TRUE); 
      END IF;   
   END IF;
   
   IF rec_.custom_menu_type = Custom_Menu_Type_API.DB_QUICK_REPORT THEN
      IF NOT (Quick_Report_API.Exists(rec_.parameter) OR App_Config_Util_API.Is_Deployment_item_Included(dep_objects_, rec_.parameter, 'QUICK_REPORT'))THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result,App_Config_Util_API.Status_Error);
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'QR_NOT_EXIST: Error: The Quick report ":P1" does not exist.',Fnd_Session_API.Get_Language, rec_.parameter), TRUE); 
      END IF;         
   ELSIF rec_.custom_menu_type = Custom_Menu_Type_API.DB_REPORT THEN   
      IF NOT Report_Definition_API.Exists(rec_.parameter) THEN
         App_Config_Util_API.Set_Validation_Result(info_.validation_result,App_Config_Util_API.Status_Error);
         Utility_SYS.Append_Text_Line(info_.validation_details, Language_SYS.Translate_Constant(lu_name_,'REP_NOT_EXIST: Error: The Report ":P1" does not exist.',Fnd_Session_API.Get_Language, rec_.parameter), TRUE); 
      END IF;
   ELSIF rec_.custom_menu_type = Custom_Menu_Type_API.DB_PLSQL_BLOCK THEN
      Validate_PLSQL___(rec_.parameter, info_.validation_result, info_.validation_details, dep_objects_);
   ELSE
      NULL;
   END IF;
END Validate___;
   
FUNCTION Get_Dependent_Items (
   package_id_     IN VARCHAR2,
   config_item_id_ IN VARCHAR2,
   xml_            IN CLOB ) RETURN VARCHAR2
IS
   rec_ custom_menu_tab%ROWTYPE;
BEGIN
   FOR header_ IN get_header(xml_) LOOP  
      rec_.rowkey := header_.objkey;          
      rec_.po_id := header_.po_id;
      rec_.custom_menu_type := header_.custom_menu_type;
      rec_.bundle_execution := header_.bundle_execution;
      rec_.description := header_.description;
      rec_.enabled_when := header_.enabled_when;
      rec_.menu_id := header_.menu_id;
      rec_.ordering := header_.ordering;
      rec_.parameter := header_.parameter;
      rec_.po_id := header_.po_id;
      rec_.process := header_.process;
      rec_.refresh_ui := header_.refresh_ui;
      rec_.window := header_.window;
      RETURN Get_Dependent_Items___(rec_, 'APP_CONFIG_PACKAGE', package_id_||'/'||config_item_id_);
   END LOOP;
END Get_Dependent_Items;

FUNCTION Get_Dependent_Items(
   menu_id_ IN VARCHAR2) RETURN VARCHAR2
IS
   object_ custom_menu_tab%ROWTYPE;
BEGIN
   object_ := Get_Object_By_Keys___(menu_id_);
   RETURN Get_Dependent_Items___(object_, 'CONFIG_ITEM_TABLE', object_.rowkey);
END Get_Dependent_Items;

PROCEDURE Validate_Existing(
   info_          OUT App_Config_Util_API.AppConfigItemInfo,
   rowkey_        IN app_config_package_item_tab.configuration_item_id%TYPE,
   version_time_stamp_ IN DATE)
   
IS
   rec_        custom_menu_tab%ROWTYPE;
   auth_ VARCHAR2(1000);
   locked_ VARCHAR2(100);
   pkg_version_time_stamp_ DATE;
   dep_objects_ App_Config_Util_API.DeploymentObjectArray;
BEGIN 
   info_.item_type            := App_Config_Item_Type_API.DB_CUSTOM_MENU;
   info_.validation_result    := App_Config_Util_API.Status_Unknown; 
   info_.validation_details   := NULL; 
   
   Rowkey_Exist(rowkey_);
   
   rec_ := Get_Key_By_Rowkey(rowkey_);
   rec_ := Get_Object_By_Keys___(rec_.menu_id);

   info_.name                 := nvl(substr(trim(Utility_SYS.Set_Windows_New_Line(rec_.description)),1 ,100 ),rec_.menu_id);
   info_.last_modified_date   := Client_Sys.Attr_Value_To_Date(rec_.definition_modified_date);
   info_.exists := 'TRUE';
   info_.current_description := rec_.description;
   info_.current_published := 'TRUE';
   info_.current_last_modified_date := rec_.definition_modified_date;           
   App_Config_Package_API.Get_Item_Package(info_.current_package_id, info_.current_package, auth_, locked_, pkg_version_time_stamp_, rec_.rowkey);
   
   Validate___(info_, dep_objects_, rec_);
   
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

PROCEDURE Get_Base_Views (
   base_views_  OUT VARCHAR2,
   po_id_ IN VARCHAR2)
IS
   field_separator_       VARCHAR2(1) := Client_SYS.field_separator_;
BEGIN
   SELECT LISTAGG (sec_object,field_separator_) WITHIN GROUP (ORDER BY 1) 
   INTO base_views_
   FROM pres_object_security_tab 
   WHERE pres_object_sec_sub_type=3 
   AND po_id IN 
   (
      SELECT DISTINCT to_po_id FROM 
      (
         SELECT to_po_id,from_po_id
         FROM pres_object_dependency_tab
         WHERE  pres_object_dep_type =11
      ) 
      START WITH from_po_id = po_id_
      CONNECT BY NOCYCLE PRIOR to_po_id =  from_po_id
      UNION SELECT po_id_ FROM dual
   );
END Get_Base_Views;