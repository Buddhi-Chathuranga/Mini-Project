-----------------------------------------------------------------------------
--
--  Logical unit: ReturnMaterialReason
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150730  HimRlk   Bug 122030, Added Get_Return_Reason_Desc_By_Lang() to fetch description by language code.
--  131031  RoJalk   Increased the lengh of return_reason_description to be 100 in the base view.
--  120525  JeLise   Made description private.
--  120508  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120508           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120508           was added. Get_Return_Reason_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100517  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060119  SaJjlk Added returning clause to method Insert___.
--  -----------------------------13.3.0--------------------------------------
--  000209  JakH   Added Get_Control_Type_Value_Desc for accrul access of
--                 description.
--  990811  JakH   Create
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Retreive the control type description used in accounting
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Return_Reason_Description(value_);
END Get_Control_Type_Value_Desc;

-- Get_Return_Reason_Desc_By_Lang
--    Retrieve the return reason description by language.
--    Difference between this method and the generated method is the language code.
@UncheckedAccess
FUNCTION Get_Return_Reason_Desc_By_Lang (
   return_reason_code_ IN VARCHAR2,
   language_code_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ return_material_reason_tab.return_reason_description%TYPE;
BEGIN
   IF (return_reason_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   SELECT substr(nvl(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'ReturnMaterialReason',
              return_reason_code, language_code_), return_reason_description), 1, 100)
      INTO  temp_
      FROM  return_material_reason_tab
      WHERE return_reason_code = return_reason_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(return_reason_code_, 'Get_Return_Reason_Desc_By_Lang');
END Get_Return_Reason_Desc_By_Lang;
