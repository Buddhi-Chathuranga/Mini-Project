-----------------------------------------------------------------------------
--
--  Logical unit: PartCopyModuleDataset
--  Component:    PARTCA
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  201161  SBalLK   Issue SC2020R1-11350, Added Get_Objkey_By_Keys___() and modified New_Or_Modify() method to avoid
--  201116           errors while deploy with solution set concept.
--  160519  ErFelk   Bug 128850, Modified Get_Dataset_Description() by replacing module as PARTCA for the first parameter when
--  160519           fetching the basic data translation.
--  160218  JeeJlk   Bug 127303, Restructured New_Or_Modify as the mandatory ROWKEY for new records is not handled correctly.
--  140314  AwWelk   PBSC-7680, Modified New_Or_Modify() to correctly insert/modify basic data translations.
--  120525  JeLise   Made description private.
--  120511  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511           in Insert___, Update___, Delete___, Get_Dataset_Description and in the views. 
--  100423  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle -----------------------------------
--  071123  HoInlk   Bug 69520, Modified method Get_Dataset_Description to return translated value.
--  050105  KeFelk   Added Get() and Get_Site_Dependent().
--  041612  KeFelk   Added Get_Dataset_Description().
--  041213  KeFelk   Modifications to New_Or_Modify().
--  041206  KeFelk   Added some method calls to Module_Translate_Attr_Util_API.
--  041129  SaRalk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------
@UncheckedAccess
FUNCTION Get_Dataset_Description (
   module_ IN VARCHAR2,
   dataset_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ part_copy_module_dataset_tab.dataset_description%TYPE;
BEGIN
   IF (module_ IS NULL OR dataset_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('PARTCA', lu_name_,
      module_||'^'||dataset_id_), 1, 200);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT dataset_description
      INTO  temp_
      FROM  part_copy_module_dataset_tab
      WHERE module = module_
      AND   dataset_id = dataset_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(module_, dataset_id_, 'Get_Dataset_Description');
END Get_Dataset_Description;


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
FUNCTION Get_Objkey_By_Keys___(
   module_     IN VARCHAR2,
   dataset_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   lu_rec_ part_copy_module_dataset_tab%ROWTYPE;
BEGIN
   lu_rec_ := Get_Object_By_Keys___(module_, dataset_id_);
   RETURN lu_rec_.rowkey;
END Get_Objkey_By_Keys___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- New_Or_Modify
--   This method is used to insert a new record or modify an existing record.
PROCEDURE New_Or_Modify (
   module_                       IN VARCHAR2,
   dataset_id_                   IN VARCHAR2,
   dataset_description_          IN VARCHAR2,
   presentation_order_           IN NUMBER,
   enabled_db_                   IN VARCHAR2,
   cancel_when_no_source_db_     IN VARCHAR2,
   cancel_when_existing_copy_db_ IN VARCHAR2,
   site_dependent_db_            IN VARCHAR2 )
IS
   newrec_       PART_COPY_MODULE_DATASET_TAB%ROWTYPE;
BEGIN
   newrec_.dataset_description := dataset_description_;
   newrec_.presentation_order := presentation_order_;
   newrec_.enabled := enabled_db_;
   newrec_.cancel_when_no_source := cancel_when_no_source_db_;
   newrec_.cancel_when_existing_copy := cancel_when_existing_copy_db_;
   newrec_.site_dependent := site_dependent_db_; 
   newrec_.module := module_;
   newrec_.dataset_id := dataset_id_;
   
   IF (Check_Exist___( module_, dataset_id_ )) THEN
      newrec_.rowkey := Get_Objkey_By_Keys___(module_, dataset_id_);
      Modify___(newrec_); 
   ELSE
      New___(newrec_);
   END IF; 
END New_Or_Modify;



