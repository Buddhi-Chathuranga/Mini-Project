-----------------------------------------------------------------------------
--
--  Logical unit: SalesDistrict
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120508  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120508           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120508           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100514  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060119  MaHplk Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  980527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971125  TOOS  Upgrade to F1 2.0
--  970509  JoAn  Added method Get_Control_Type_Value_Desc
--  970312  JOED  Changed table name.
--  970218  JOED  Changed objversion.
--  960208  SVLO  Created
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
   district_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sales_district_tab.description%TYPE;
BEGIN
   IF (district_code_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      district_code_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
   INTO   temp_
   FROM   sales_district_tab
   WHERE  district_code = district_code_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(district_code_, 'Get_Description');
END Get_Description;

-- Get_Control_Type_Value_Desc
--   Retreive the control type description. Used by accounting
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;



