-----------------------------------------------------------------------------
--
--  Logical unit: CustomMenuText
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  980119  DOZE  Created.
--  980212  ERFO  Added CASCADE-functionality towards CustomMenu (ToDo #2119).
--  030212  ROOD  Changed module to FNDBAS (ToDo#4149).
--  081217  HAAR  Removed attribute Status_Text (Bug#79193)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

CURSOR get_texts(xml_ CLOB) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CUSTOM_MENU/TEXTS/TEXTS_ROW' passing Xmltype(xml_)
                          COLUMNS
                            LANGUAGE_CODE VARCHAR2(2) path 'LANGUAGE_CODE',
                            TITLE VARCHAR2(50) path 'TITLE',                                                       
                            OBJKEY VARCHAR2(100) path 'ROWKEY'
                        ) xt1;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

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
   custom_menu_text_rec_   custom_menu_text_tab%ROWTYPE;
   
BEGIN
   FOR rec_ IN get_texts(xml_) LOOP                        
      custom_menu_text_rec_ := NULL;
      IF NOT Check_Exist___(menu_id_,rec_.language_code) THEN
         Prepare_New___(custom_menu_text_rec_);
         custom_menu_text_rec_.menu_id          := menu_id_;
         custom_menu_text_rec_.language_code    := rec_.language_code;
         custom_menu_text_rec_.title            := rec_.title;
         custom_menu_text_rec_.rowkey           := rec_.objkey;
         New___(custom_menu_text_rec_);
      ELSE
         IF overwrite_ THEN
            custom_menu_text_rec_ := Lock_By_Keys___(menu_id_,rec_.language_code);
            custom_menu_text_rec_.title            := rec_.title;
            --custom_menu_text_rec_.rowkey           := rec_.objkey;
            Modify___(custom_menu_text_rec_);  
         END IF;
      END IF;            
   END LOOP;   
EXCEPTION
   WHEN OTHERS THEN      
      IF get_texts%ISOPEN THEN
         CLOSE get_texts;
      END IF;      
      RAISE;
END Import_XML;
   


