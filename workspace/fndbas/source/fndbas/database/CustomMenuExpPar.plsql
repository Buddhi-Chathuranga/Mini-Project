-----------------------------------------------------------------------------
--
--  Logical unit: CustomMenuExpPar
--  Component:    FNDBAS
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  100614  HAAR  Expandable parameters (Bug#90379)
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

CURSOR get_expandable_parameters(xml_ CLOB) IS
   SELECT xt1.*
     FROM dual,
          xmltable('/CUSTOM_OBJECT/CUSTOM_MENU/EXPANDABLE_PARAMETERS/EXPANDABLE_PARAMETERS_ROW' passing Xmltype(xml_)
                          COLUMNS
                            PARAMETER VARCHAR2(2000) path 'PARAMETER',
                            SOURCE VARCHAR2(2000) path 'SOURCE',
                            OBJKEY VARCHAR2(100) path 'ROWKEY'
                        ) xt1;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     custom_menu_exp_par_tab%ROWTYPE,
   newrec_ IN OUT custom_menu_exp_par_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   IF (newrec_.source IS NOT NULL) THEN
      IF (Nvl(Regexp_Substr(newrec_.source, '^([[:space:]]*[[:alnum:]][[:alnum:]$_]*[[:space:]]*)(,(([[:space:]]*[[:alnum:]][[:alnum:]$_]*[[:space:]]*)))*$'), 'CoLuMn') != newrec_.source) THEN
         Error_SYS.Appl_General(lu_name_, 'VALUE_INSERT: The value [:P1] is not a correct column expression.', newrec_.source);
      END IF;
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
END Check_Common___;


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

PROCEDURE Import_Xml (
   menu_id_   IN VARCHAR2, 
   xml_       IN CLOB,
   overwrite_ IN BOOLEAN DEFAULT TRUE)
IS
   custom_menu_exp_rec_    custom_menu_exp_par_tab%ROWTYPE;
BEGIN
   DELETE FROM custom_menu_exp_par_tab
   WHERE menu_id = menu_id_;

   FOR rec_ IN get_expandable_parameters(xml_) LOOP
         Prepare_New___(custom_menu_exp_rec_);
         custom_menu_exp_rec_.menu_id           := menu_id_;
         custom_menu_exp_rec_.parameter         := rec_.parameter;
         custom_menu_exp_rec_.source            := rec_.source;
         custom_menu_exp_rec_.rowkey            := rec_.objkey;
         New___(custom_menu_exp_rec_);         
   END LOOP;   
EXCEPTION
   WHEN OTHERS THEN      
      IF get_expandable_parameters%ISOPEN THEN
         CLOSE get_expandable_parameters;
      END IF;      
      RAISE;
END Import_Xml;
