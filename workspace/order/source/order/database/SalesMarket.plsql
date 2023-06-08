-----------------------------------------------------------------------------
--
--  Logical unit: SalesMarket
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  180502  DiKuLk   Bug 140211, Modified Get_Description() to increase the length of substring of Market_Description to 200 from 35.
--  120508  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120508           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120508           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100514  KRPELK   Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  060726  ThGulk Added Objid instead of rowid in Procedure Insert__
--  060112  NaWalk  Changed 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_;.
--  980527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971125  TOOS  Upgrade to F1 2.0
--  970509  JoAn  Added method Get_Control_Type_Value_Desc
--  970312  JOED  Changed table name.
--  970218  JOED  Changed objversion.
--  960208  JOED  Create
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
   market_code_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sales_market_tab.description%TYPE;
   BEGIN
      IF (market_code_ IS NULL) THEN
         RETURN NULL;
      END IF;
      temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'SalesMarket',
         market_code_), 1, 200);
      IF (temp_ IS NOT NULL) THEN
         RETURN temp_;
      END IF;
      SELECT description
      INTO   temp_
      FROM   sales_market_tab
      WHERE  market_code = market_code_;
      RETURN temp_;
   EXCEPTION
      WHEN no_data_found THEN
         RETURN NULL;
      WHEN too_many_rows THEN
         Raise_Too_Many_Rows___(market_code_, 'Get_Description');
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



