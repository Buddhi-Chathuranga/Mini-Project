-----------------------------------------------------------------------------
--
--  Logical unit: FndObjSubscripColumn
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


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT fnd_obj_subscrip_column_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   IF newrec_.subscription_lu IS NULL THEN
      newrec_.subscription_lu := Fnd_Obj_Subscription_API.Get_Lu_Name(newrec_.subscription_id);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
   --Add post-processing code here
END Insert___;

FUNCTION Get_Custom_Field_Prompt___ (
   lu_name_     IN VARCHAR2,
   view_name_   IN VARCHAR2,
   column_name_ IN VARCHAR2,
   lang_code_   IN VARCHAR2) RETURN VARCHAR2
IS
   attribute_name_ VARCHAR2(30) := substr(column_name_, 5);
   prompt_ VARCHAR2(2000);
   lu_type_ VARCHAR2(100);
BEGIN
$IF Component_Fndcob_SYS.INSTALLED $THEN
   BEGIN
      IF view_name_ LIKE '%/_CLV' ESCAPE '/' THEN
         lu_type_ := Custom_Field_Lu_Types_API.DB_CUSTOM_LU;
      ELSE
         lu_type_ := Custom_Field_Lu_Types_API.DB_CUSTOM_FIELD;
      END IF;
      --SOLSETFW      
      SELECT Custom_Field_Attributes_API.Get_Prompt_Translation(t.lu, t.lu_type, 
                                                                Custom_Fields_SYS.Get_Column_Prefix(t.lu_type)||attribute_name, 
                                                                rowkey, 
                                                                prompt,
                                                                lang_code_) 
        INTO prompt_
        FROM Custom_Field_Attributes_Tab t,dictionary_sys_tab d, module_tab m
       WHERE t.lu = lu_name_
         AND t.lu = d.lu_name AND d.module = m.module AND m.active = 'TRUE'
         AND attribute_name = attribute_name_
         AND t.lu_type = lu_type_;
      RETURN prompt_;
   EXCEPTION
      WHEN OTHERS THEN
         NULL;
   END;
$ELSE
   RETURN NULL;
$END
END Get_Custom_Field_Prompt___;
-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@UncheckedAccess
FUNCTION Get_Column_Text(
   subscription_id_ IN VARCHAR2,
   column_name_     IN VARCHAR2,
   lang_code_       IN VARCHAR2 DEFAULT NULL) RETURN VARCHAR2
IS
   v_handle_id_      VARCHAR2(100);
   display_type_ VARCHAR2(50);
   text_      VARCHAR2(1000);
   view_name_ VARCHAR2(30);
   lu_name_   VARCHAR2(30);
BEGIN
   SELECT 1,1 INTO v_handle_id_, display_type_
   FROM fnd_obj_subscrip_column_tab
   WHERE subscription_id = subscription_id_
   AND subscription_column = column_name_;
   
   IF v_handle_id_ IS NOT NULL AND display_type_ IS NOT NULL THEN
      text_ := Language_SYS.Get_Display_Name_By_Handl_Id(v_handle_id_, display_type_, lang_code_);
   END IF;
   
   IF text_ IS NULL THEN
      SELECT lu_name, client_view INTO lu_name_, view_name_
      FROM fnd_obj_subscription_tab
      WHERE subscription_id = subscription_id_;
      
      IF column_name_ NOT LIKE 'CF$/_%' ESCAPE '/' THEN
         text_ := Dictionary_SYS.Get_Item_Prompt_(lu_name_, view_name_, column_name_);
      ELSE
         text_ := Get_Custom_Field_Prompt___(lu_name_, view_name_, column_name_, lang_code_);
      END IF;
      IF text_ IS NULL THEN
         text_ := Initcap(REPLACE(REPLACE(column_name_,'CF$_'),'_',' '));
      END IF;
   END IF;
   
   RETURN text_; 
END Get_Column_Text;