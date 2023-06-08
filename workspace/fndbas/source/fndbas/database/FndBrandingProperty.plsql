-----------------------------------------------------------------------------
--
--  Logical unit: FndBrandingProperty
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

XMLTAG_PATH_PROPERTY       CONSTANT VARCHAR2(100) := '/CUSTOM_OBJECT/APPEARANCE_CONFIG/BRANDING_PROPERTY/BRANDING_PROPERTY_ROW';

CURSOR get_properties(xml_ Xmltype, code_ VARCHAR2) IS
   SELECT * FROM
   (SELECT xt1.*
     FROM dual,
          xmltable(XMLTAG_PATH_PROPERTY passing xml_
                         COLUMNS
                            CODE          VARCHAR2(200) path 'CODE',
                            PROPERTY      VARCHAR2(1000) path 'PROPERTY',
                            THEME_DB      VARCHAR2(4000) path 'THEME_DB',
                            VALUE         VARCHAR2(4000) path 'VALUE',
                            DEFINITION_MODIFIED_DATE VARCHAR2(50) path 'DEFINITION_MODIFIED_DATE',
                            OBJKEY        VARCHAR2(100) path 'ROWKEY'
                        ) xt1) WHERE code = code_;
                        

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT NOCOPY fnd_branding_property_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2 )
IS
BEGIN
   Fnd_Branding_API.Update_Def_Modified_Date(newrec_.code);
   super(objid_, objversion_, newrec_, attr_);
END Insert___;

@Override
PROCEDURE Delete___ (
   objid_  IN VARCHAR2,
   remrec_ IN fnd_branding_property_tab%ROWTYPE )
IS
BEGIN
   Fnd_Branding_API.Update_Def_Modified_Date(remrec_.code);
   super(objid_, remrec_);
END Delete___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     fnd_branding_property_tab%ROWTYPE,
   newrec_     IN OUT NOCOPY fnd_branding_property_tab%ROWTYPE,
   attr_       IN OUT NOCOPY VARCHAR2,
   objversion_ IN OUT NOCOPY VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   Fnd_Branding_API.Update_Def_Modified_Date(newrec_.code);
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
END Update___;

-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

PROCEDURE Import(
   xml_  IN XMLType,
   code_ IN VARCHAR2)
IS
   new_rec_ fnd_branding_property_tab%ROWTYPE;
BEGIN
   FOR rec_ IN get_properties(xml_, code_) LOOP
      Prepare_New___(new_rec_);
      new_rec_.code := rec_.code;
      new_rec_.property := rec_.property;
      new_rec_.theme := rec_.theme_db;
      new_rec_.value := rec_.value;
      new_rec_.rowkey := rec_.objkey;
      Import_New___(new_rec_);
   END LOOP;   
END Import;

PROCEDURE Import_New___ (
   newrec_ IN OUT fnd_branding_property_tab%ROWTYPE )
IS
   attr_          VARCHAR2(32000);
   indrec_        Indicator_Rec;
   emptyrec_      fnd_branding_property_tab%ROWTYPE;
BEGIN
   indrec_ := Get_Indicator_Rec___(emptyrec_, newrec_);
   Check_Insert___(newrec_, indrec_, attr_);
   newrec_.rowversion := sysdate;
   IF newrec_.rowkey IS NULL THEN
      newrec_.rowkey := sys_guid();
   END IF; 
   INSERT INTO fnd_branding_property_tab VALUES newrec_;
EXCEPTION
   WHEN dup_val_on_index THEN
         DECLARE
            constraint_ VARCHAR2(4000) := Utility_SYS.Get_Constraint_From_Error_Msg(sqlerrm);
         BEGIN
            IF (constraint_ = 'FND_BRANDING_PROPERTY_RK') THEN
               Error_SYS.Fnd_Rowkey_Exist(lu_name_, newrec_.rowkey);
            ELSIF (constraint_ = 'FND_BRANDING_PROPERTY_PK') THEN
               Raise_Record_Exist___(newrec_);
            ELSE
               Raise_Constraint_Violated___(newrec_, constraint_);
            END IF;
         END;
END Import_New___;

PROCEDURE Remove_All(
   code_ IN VARCHAR2)
IS
BEGIN
   DELETE
   FROM  fnd_branding_property_tab
   WHERE code = code_;
END Remove_All;

PROCEDURE Set_Resource (
   code_ IN VARCHAR2,
   property_ IN VARCHAR2,
   theme_db_ IN VARCHAR2,
   file_name_ IN VARCHAR2,
   date_modified_ IN VARCHAR2)
IS
   resource_name_  VARCHAR2(1000);
BEGIN
   resource_name_ := 'RESOURCE: ' || file_name_ ; 
    
   UPDATE fnd_branding_property_tab
            SET value = resource_name_
            WHERE code = code_
            AND   property = property_
            AND   theme = theme_db_;
   Fnd_Branding_API.Update_Def_Modified_Date(code_);
END Set_Resource;

PROCEDURE Set_Url (
   code_ IN VARCHAR2,
   property_ IN VARCHAR2,
   theme_db_ IN VARCHAR2,
   custom_url_ IN VARCHAR2)
IS
BEGIN
   UPDATE fnd_branding_property_tab
            SET value = custom_url_
            WHERE code = code_
            AND   property = property_
            AND   theme = theme_db_;
   Fnd_Branding_API.Update_Def_Modified_Date(code_);
END Set_Url;

FUNCTION Check_Resource_Mapped (
   file_names_ IN VARCHAR2) RETURN BOOLEAN
IS
   exp_value_ VARCHAR2(2000);
   file_count_ NUMBER;
   selection_table_                 Utility_SYS.STRING_TABLE;
   token_count_                     NUMBER;
BEGIN
   Utility_SYS.Tokenize(file_names_, client_sys.record_separator_, selection_table_, token_count_);
   IF(selection_table_.COUNT >0) THEN
      FOR i_ IN 1..selection_table_.COUNT  LOOP
         exp_value_ := 'RESOURCE: ' || selection_table_(i_);
         SELECT COUNT(*) INTO file_count_ FROM fnd_branding_property_tab WHERE value = exp_value_ ;
         IF (file_count_ > 0) THEN
            RETURN TRUE; 
         END IF;
      END LOOP;
   END IF;
   RETURN FALSE;
END Check_Resource_Mapped;
