-----------------------------------------------------------------------------
--
--  Logical unit: CharacteristicTemplate
--  Component:    MPCCOM
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120507  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120507           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  060112  SeNslk   Modified the template version as 2.3 and modified the PROCEDURE Insert___ 
--  060112           and added UNDEFINE according to the new template.
--  --------------------------------- 13.3.0 --------------------------------
--  000925  JOHESE   Added undefines.
--  990422  JOHW     General performance improvements.
--  990415  JOHW     Upgraded to performance optimized template.
--  971120  JOKE     Converted to Foundation1 2.0.0 (32-bit).
--  970313  CHAN     Changed table name: eng_attribure_codes is replaced by
--                   characteristic_template_tab
--  970221  JOKE     Uses column rowversion as objversion (timestamp).
--  961213  JOKE     Modified with new workbench default templates.
--  961030  JOBE     Modified for compatibility with workbench.
--  961024  JOBE     Removed procedure Get_Description.
--  960517  AnAr     Added purpose comment to file.
--  960412  SHVE     Added procedure Get_description from old track.
--  960307  JICE     Renamed from EngAttributes
--  951109  xxxx     Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Get_Description (
   eng_attribute_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CHARACTERISTIC_TEMPLATE_TAB.description%TYPE;
   CURSOR get_attr IS
      SELECT description
      FROM CHARACTERISTIC_TEMPLATE_TAB
      WHERE eng_attribute = eng_attribute_;
BEGIN
   temp_ := SUBSTR(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_,
                                                                         lu_name_,
                                                                         eng_attribute_), 1, 35);
   
   IF (temp_ IS NULL) THEN
      OPEN get_attr;
      FETCH get_attr INTO temp_;
      CLOSE get_attr;
   END IF;
   RETURN temp_;
END Get_Description;
