-----------------------------------------------------------------------------
--
--  Logical unit: ClassificationStandard
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160426  JeLise   STRSC-2104, Added fetch of rowstate and rowkey to avoid upgrade errors.
--  160418  JeLise   STRSC-2066, Changed Insert_Lu_Data_Rec__ to call New___ and Modify___ to avoid installation errors.
--  120525  JeLise   Made description private.
--  120507  Matkse   Replaced calls to obsolete Module_Translate_Attr_Util_API with Basic_Data_Translation_API.Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507           Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507           was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  080303  KiSalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN CLASSIFICATION_STANDARD_TAB%ROWTYPE )
IS
   dummy_ NUMBER;
   rec_   classification_standard_tab%ROWTYPE;
   
   CURSOR exist_control IS
      SELECT 1
      FROM CLASSIFICATION_STANDARD_TAB
      WHERE classification_standard = newrec_.classification_standard;
      
   CURSOR get_rec IS
      SELECT rowstate, rowkey
      FROM CLASSIFICATION_STANDARD_TAB
      WHERE classification_standard = newrec_.classification_standard;
BEGIN
   rec_ := newrec_;
   
   OPEN get_rec;
   FETCH get_rec INTO rec_.rowstate, rec_.rowkey;
   CLOSE get_rec;
   
   OPEN exist_control;
   FETCH exist_control INTO dummy_;
   IF (exist_control%NOTFOUND) THEN
      New___(rec_);
   ELSE
      Modify___(rec_);
   END IF;
   CLOSE exist_control;
END Insert_Lu_Data_Rec__;

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   classification_standard_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ classification_standard_tab.description%TYPE;
BEGIN
   IF (classification_standard_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      classification_standard_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  classification_standard_tab
      WHERE classification_standard = classification_standard_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(classification_standard_, 'Get_Description');
END Get_Description;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------





