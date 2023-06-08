-----------------------------------------------------------------------------
--
--  Logical unit: CustomMenuUtil
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980119  DOZE    Created.
--  980210  ERFO    Added methods for export/import (ToDo #1858).
--  980212  ERFO    Corrected in custom_menu_type in Register_Menu.
--  020624  ROOD    Corrected usage of General_SYS.Init_Method (ToDo#4087).
--  030212  ROOD    Changed module to FNDBAS (ToDo#4149).
--  030513  RAKU    Bug#37353 - Extended variable 'name_' to 2000 in Register_Menu.
--  051010  NiWi    Bug#15307 - replaced amperand by 'CHR(38)' during import/export.
--  081215  HAAR    New custom menu types needed by Enterprise Explorer (Bug#79193).
--  100614  HAAR    Expandable parameters (Bug#90379)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Get_Menu_Definition__ (
   definition_ OUT   CLOB,
   window_        IN VARCHAR2,
   process_       IN VARCHAR2 )
IS
   language_code_ VARCHAR2(5)       := Fnd_Session_API.Get_Language;
   main_msg_      CLOB;
   msg_           VARCHAR2(32000);
   keymsg_        VARCHAR2(32000);
   expparmsg_     VARCHAR2(32000);

   CURSOR menu_def IS
      SELECT m.menu_id, m.custom_menu_type_db custom_menu_type_db,
            m.parameter, m.enabled_when, m.bundle_execution_db, m.po_id,
            nvl(t.title, '(untitled)') title , m.refresh_ui_db 
      FROM custom_menu m, custom_menu_text t
      WHERE m.process = nvl(process_, 'NONE')
      AND m.window = window_
      AND m.menu_id = t.menu_id(+)
      AND t.language_code(+) = language_code_
      AND m.custom_menu_type_db NOT IN ('5', '7') -- Do not fetch SAL code
      ORDER BY ordering;

   CURSOR key_translations(menu_id_ VARCHAR2) IS
      SELECT source_key_name, dest_key_name
      FROM custom_menu_key_trans
      WHERE menu_id = menu_id_;

      CURSOR expandable_parameters(menu_id_ VARCHAR2) IS
      SELECT parameter, source
      FROM custom_menu_exp_par
      WHERE menu_id = menu_id_;
BEGIN
   main_msg_ := Message_SYS.Construct('MENUS');
   FOR menu_def_ IN menu_def LOOP
      --
      -- Check PO Security
      --
      IF ((menu_def_.custom_menu_type_db = Custom_Menu_Type_API.DB_SEPARATOR) OR 
          (Security_SYS.Is_Pres_Object_Available(menu_def_.po_id))) THEN
         msg_ := Message_SYS.Construct('DEFINITION');
         Message_SYS.Add_Attribute(msg_, 'CUSTOM_MENU_TYPE_DB', menu_def_.custom_menu_type_db);
         Message_SYS.Add_Attribute(msg_, 'PARAMETER', menu_def_.parameter);
         Message_SYS.Add_Clob_Attribute(msg_, 'ENABLED_WHEN', menu_def_.enabled_when);
         Message_SYS.Add_Attribute(msg_, 'TITLE', menu_def_.title);
         Message_SYS.Add_Attribute(msg_, 'MENU_ID', menu_def_.menu_id);
         Message_SYS.Add_Attribute(msg_, 'REFRESH_UI', menu_def_.refresh_ui_db);
         --
         -- Add Bundled_Execution for Quick Reports
         --
         IF (menu_def_.custom_menu_type_db = '9') THEN -- Quick Report
            Message_SYS.Add_Attribute(msg_, 'BUNDLE_EXECUTION_DB', menu_def_.bundle_execution_db);
         END IF;
         keymsg_ := Message_SYS.Construct('MENUKEYS');
         IF (menu_def_.custom_menu_type_db IN ('2', '8', '9')) THEN -- create window
            FOR keytrans_ IN key_translations(menu_def_.menu_id) LOOP
               Message_SYS.Add_Attribute(keymsg_, keytrans_.source_key_name, keytrans_.dest_key_name);
            END LOOP;
         END IF;
         Message_SYS.Add_Attribute(msg_, 'KEYS', keymsg_);
         --
         -- Add message for Expandable parameters
         --
         expparmsg_ := Message_SYS.Construct('PARAMETER');
         IF (menu_def_.custom_menu_type_db = '9' AND menu_def_.bundle_execution_db = 'TRUE') THEN -- Bundled execution and Quick Report
            FOR exp_par_ IN expandable_parameters(menu_def_.menu_id) LOOP
               Message_SYS.Add_Attribute(expparmsg_, exp_par_.source, exp_par_.parameter);
            END LOOP;
         END IF;
         Message_SYS.Add_Attribute(msg_, 'EXPANDABLE_PARAMETER', expparmsg_);
         Message_SYS.Add_Attribute(main_msg_, 'MENU', msg_);
      END IF;
   END LOOP;
   definition_ := main_msg_;  
   
EXCEPTION
   WHEN value_error THEN 
      Trace_SYS.Put_Line(' ORA-06502 - Unexpected error while loading custom menus. Custom menus will not be loaded. Please contact your system administrator.');
END Get_Menu_Definition__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
PROCEDURE Get_All_Menu_Definitions(
   definitions_ OUT CLOB)
IS
   definition_   VARCHAR2(32000);
   clob_msg_     CLOB;
   win_proc_     VARCHAR2(200);
   
   CURSOR custom_menus IS
      SELECT DISTINCT window, process
      FROM custom_menu;
BEGIN
   clob_msg_ := Message_SYS.Construct_Clob_Message('MENUDEFINITIONS');   
   FOR custom_menus_ IN custom_menus LOOP
      Get_Menu_Definition__(definition_, custom_menus_.window, custom_menus_.process); 
      IF custom_menus_.process = 'NONE' THEN
         win_proc_ := custom_menus_.window;
      ELSE
         win_proc_ := custom_menus_.window||'.'||custom_menus_.process;
      END IF;
      Message_SYS.Add_Clob_Attribute(clob_msg_, win_proc_, definition_);      
   END LOOP;  
   definitions_ := clob_msg_;
END Get_All_Menu_Definitions;
   
PROCEDURE Get_Menu_Definition (
   definition_ OUT VARCHAR2,
   window_ IN VARCHAR2,
   process_ IN VARCHAR2,
   language_code_ IN VARCHAR2 )
IS
   msg_           VARCHAR2(32000);
   keymsg_        VARCHAR2(32000);

   CURSOR menu_def IS
      SELECT m.menu_id, m.custom_menu_type_db custom_menu_type_db,
            m.parameter, m.enabled_when, m.bundle_execution_db, m.po_id,
            nvl(t.title, '(untitled)') title 
      FROM custom_menu m, custom_menu_text t
      WHERE m.process = nvl(process_, 'NONE')
      AND m.window = window_
      AND m.menu_id = t.menu_id(+)
      AND t.language_code(+) = language_code_
      AND m.custom_menu_type_db IN ('1', '2', '3', '4', '5', '6', '7') -- Only fetch old Custom Menu's
      ORDER BY ordering;

   CURSOR key_translations(menu_id_ VARCHAR2) IS
      SELECT source_key_name, dest_key_name
      FROM custom_menu_key_trans
      WHERE menu_id = menu_id_;
BEGIN
   msg_ := Message_SYS.Construct('MENUDEFINITION');
   FOR menu_def_ IN menu_def LOOP
      Message_SYS.Add_Attribute(msg_, 'CUSTOM_MENU_TYPE_DB'
                                , menu_def_.custom_menu_type_db);
      Message_SYS.Add_Attribute(msg_, 'PARAMETER', menu_def_.parameter);
      Message_SYS.Add_Clob_Attribute(msg_, 'ENABLED_WHEN', menu_def_.enabled_when);
      Message_SYS.Add_Attribute(msg_, 'TITLE', menu_def_.title);
      Message_SYS.Add_Attribute(msg_, 'STATUS_TEXT', '');
      IF menu_def_.custom_menu_type_db = 2 THEN -- create window
         keymsg_ := Message_SYS.Construct('MENUKEYS');
         FOR keytrans_ IN key_translations(menu_def_.menu_id) LOOP
            Message_SYS.Add_Attribute(keymsg_, keytrans_.source_key_name,
                                   keytrans_.dest_key_name);
         END LOOP;
      END IF;
      Message_SYS.Add_Attribute(msg_, 'KEYS', keymsg_);
   END LOOP;
   definition_ := msg_;
END Get_Menu_Definition;


PROCEDURE Get_Menu_Export_Properties (
   title_attr_ OUT VARCHAR2,
   status_text_attr_ OUT VARCHAR2,
   key_trans_attr_ OUT VARCHAR2,
   menu_id_ IN NUMBER )
IS
   attr1_ VARCHAR2(32000);
   attr2_ VARCHAR2(32000);
   CURSOR get_texts IS
      SELECT language_code, title --, status_text
      FROM   custom_menu_text
      WHERE  menu_id = menu_id_;
   CURSOR get_key_trans IS
      SELECT source_key_name, dest_key_name
      FROM   custom_menu_key_trans
      WHERE  menu_id = menu_id_;
BEGIN
   --
   -- Menu text translations
   --
   FOR rec IN get_texts LOOP
      Client_SYS.Add_To_Attr(rec.language_code, replace(rec.title, Chr(38), 'Chr(38)') , attr1_);
   END LOOP;
   title_attr_       := attr1_;
   --
   -- Menu key name conversion
   --
   Client_SYS.Clear_Attr(attr2_);
   FOR rec IN get_key_trans LOOP
      Client_SYS.Add_To_Attr(rec.source_key_name, rec.dest_key_name, attr2_);
   END LOOP;
   key_trans_attr_ := attr2_;
END Get_Menu_Export_Properties;


PROCEDURE Register_Menu (
   window_ IN VARCHAR2,
   process_ IN VARCHAR2,
   ordering_ IN NUMBER,
   parameter_ IN VARCHAR2,
   enabled_when_ IN VARCHAR2,
   custom_menu_type_ IN VARCHAR2,
   title_attr_ IN VARCHAR2,
   status_text_attr_ IN VARCHAR2,
   key_trans_attr_ IN VARCHAR2,
   bundle_execution_db_ IN VARCHAR2 DEFAULT 'FALSE',
   po_id_ IN VARCHAR2 DEFAULT NULL )
IS
   info_       VARCHAR2(2000);
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
   attr_       VARCHAR2(32000);
   menu_id_    NUMBER;
   ptr_        NUMBER;
   name_       VARCHAR2(2000);
   value_      VARCHAR2(2000);
BEGIN
   --
   -- Create entry in logical unit CustomMenu
   --
   Custom_Menu_API.New__(info_, objid_, objversion_, attr_, 'PREPARE');
   menu_id_ := Client_SYS.Get_Item_Value('MENU_ID', attr_);
   Client_SYS.Add_To_Attr('WINDOW', window_, attr_);
   Client_SYS.Add_To_Attr('PROCESS', process_, attr_);
   Client_SYS.Add_To_Attr('ORDERING', ordering_, attr_);
   Client_SYS.Add_To_Attr('PARAMETER', parameter_, attr_);
   Client_SYS.Add_To_Attr('ENABLED_WHEN', enabled_when_, attr_);
   Client_SYS.Add_To_Attr('CUSTOM_MENU_TYPE', Custom_Menu_Type_API.Decode(custom_menu_type_), attr_);
   Client_SYS.Add_To_Attr('WINDOW', window_, attr_);
   Client_SYS.Add_To_Attr('BUNDLE_EXECUTION_DB', bundle_execution_db_, attr_);
   Client_SYS.Add_To_Attr('PO_ID', po_id_, attr_);
   Custom_Menu_API.New__(info_, objid_, objversion_, attr_, 'DO');
   --
   -- Create entries in logical unit CustomMenuText
   --
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(title_attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('MENU_ID', menu_id_, attr_);
      Client_SYS.Add_To_Attr('LANGUAGE_CODE', name_, attr_);   -- Name  = Language Code
      Client_SYS.Add_To_Attr('TITLE', replace(value_, 'Chr(38)', Chr(38)), attr_);          -- Value = Window Title
      Custom_Menu_Text_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
   --
   -- Create entries in logical unit CustomMenuKeyTrans
   --
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(key_trans_attr_, ptr_, name_, value_)) LOOP
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('MENU_ID', menu_id_, attr_);
      Client_SYS.Add_To_Attr('SOURCE_KEY_NAME', name_, attr_); -- Name  = Source Key
      Client_SYS.Add_To_Attr('DEST_KEY_NAME', value_, attr_);  -- Value = Dest Key
      Custom_Menu_Key_Trans_API.New__(info_, objid_, objversion_, attr_, 'DO');
   END LOOP;
END Register_Menu;

FUNCTION Get_Menu_Title (
   menu_id_ IN VARCHAR2) RETURN VARCHAR2
IS
    title_ VARCHAR2(50);  
    CURSOR get_texts IS
      SELECT title,language_code
      FROM   custom_menu_text
      WHERE  menu_id = menu_id_;
BEGIN
   --Get description in user set language. If no such translation exist get the title in english, if not found for english, get the text in any other language 
   title_ := Custom_Menu_Text_API.Get_Title(menu_id_,Fnd_Session_API.Get_Language); 
   IF (title_ IS NULL) THEN
      FOR rec_ IN get_texts LOOP
         title_ := rec_.title;
         IF rec_.language_code = 'en' THEN            
            EXIT;   
         END IF;
      END LOOP;   
   END IF;
   RETURN title_;
END Get_Menu_Title;

FUNCTION Get_All_Menu_Definitions
                           RETURN CLOB
IS
   definition_   CLOB;
   clob_msg_     CLOB;
   win_proc_     VARCHAR2(200);
   
   CURSOR custom_menus IS
      SELECT DISTINCT window, process
      FROM custom_menu;
BEGIN
   clob_msg_ := Message_SYS.Construct_Clob_Message('MENUDEFINITIONS');   
   FOR custom_menus_ IN custom_menus LOOP
      Get_Menu_Definition__(definition_, custom_menus_.window, custom_menus_.process); 
      IF custom_menus_.process = 'NONE' THEN
         win_proc_ := custom_menus_.window;
      ELSE
         win_proc_ := custom_menus_.window||'.'||custom_menus_.process;
      END IF;
      Message_SYS.Add_Clob_Attribute(clob_msg_, win_proc_, definition_);      
   END LOOP;  
   
   RETURN clob_msg_;
   
END Get_All_Menu_Definitions;



