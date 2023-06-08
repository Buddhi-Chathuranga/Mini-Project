-----------------------------------------------------------------------------
--
--  Logical unit: CustomMenuKeyTrans
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980119  DOZE  Created.
--  980212  ERFO  Added CASCADE-functionality towards CustomMenu (ToDo #2119).
--  001013  TOFU  Convert to template 2.2
--                Extend source,dest key to 2000 characters for function calls(Bug#17911).
--  001030  TOFU  Add a generic id, to remove the source key as key.
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


CURSOR get_key_translations(xml_ CLOB) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CUSTOM_MENU/KEY_TRANSLATIONS/KEY_TRANSLATIONS_ROW' passing Xmltype(xml_)
                          COLUMNS
                            ID NUMBER path 'ID',
                            SOURCE_KEY_NAME VARCHAR2(2000) path 'SOURCE_KEY_NAME',
                            DEST_KEY_NAME VARCHAR2(2000) path 'DEST_KEY_NAME',
                            OBJKEY VARCHAR2(100) path 'ROWKEY'
                        ) xt1;
                        
-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOM_MENU_KEY_TRANS_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   --
   -- Set id
   --
   SELECT NVL(MAX(id),0) + 1
      INTO  newrec_.id
      FROM  CUSTOM_MENU_KEY_TRANS_TAB
      WHERE menu_id = newrec_.menu_id;
   Client_SYS.Add_To_Attr('ID',newrec_.id, attr_);
   --
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_          OUT VARCHAR2,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   -- Only modify when done through the client
   IF action_ = 'DO' THEN
      Custom_Menu_API.Update_Definition_Mod_Date_(Get_Object_By_Id___(objid_).menu_id);
   END IF;
END New__;

@Override
PROCEDURE Modify__ (
   info_          OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   -- Only modify when done through the client
   IF action_ = 'DO' THEN
      Custom_Menu_API.Update_Definition_Mod_Date_(Get_Object_By_Id___(objid_).menu_id);
   END IF;
END Modify__;

@Override
PROCEDURE Remove__ (
   info_          OUT VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN     VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   menu_id_ custom_menu_tab.menu_id%TYPE;
BEGIN
   menu_id_ := Get_Object_By_Id___(objid_).menu_id;
   super(info_, objid_, objversion_, action_);
   -- Only modify when done through the client
   IF action_ = 'DO' THEN
      Custom_Menu_API.Update_Definition_Mod_Date_(menu_id_);
   END IF;
END Remove__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import_XML (
   menu_id_   IN VARCHAR2, 
   xml_       IN CLOB,
   overwrite_ IN BOOLEAN DEFAULT TRUE)
IS
   custom_menu_key_rec_    custom_menu_key_trans_tab%ROWTYPE;
BEGIN
   -- Todo , maybe the id generation should change so it do the same as for menu_id in CustomMenu.
   -- Id is a bad thing to check exist on since value number 1 for example are created in diffferent environments
   DELETE FROM custom_menu_key_trans_tab
   WHERE menu_id = menu_id_;
   
   FOR rec_ IN get_key_translations(xml_) LOOP
     
--      IF custom_menu_key_rec_.id IS NULL THEN
         custom_menu_key_rec_ := NULL;
         Prepare_New___(custom_menu_key_rec_);
         custom_menu_key_rec_.menu_id           := menu_id_;
         --custom_menu_key_rec_.id                := rec_.id; //does not matter if it differs, since internal
         custom_menu_key_rec_.source_key_name   := rec_.source_key_name;
         custom_menu_key_rec_.dest_key_name     := rec_.dest_key_name;
         custom_menu_key_rec_.rowkey            := rec_.objkey;
         New___(custom_menu_key_rec_);
--      ELSE
--         IF overwrite_ THEN
--            custom_menu_key_rec_ := Lock_By_Keys___(menu_id_,rec_.language_code);
--            custom_menu_key_rec_.title            := rec_.title;
--            custom_menu_key_rec_.rowkey           := rec_.objkey;
--            Modify___(custom_menu_text_rec_);  
--         END IF;            
   END LOOP;   
EXCEPTION
   WHEN OTHERS THEN      
      IF get_key_translations%ISOPEN THEN
         CLOSE get_key_translations;
      END IF;      
      RAISE;
END Import_XML;
