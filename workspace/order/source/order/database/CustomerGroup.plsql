-----------------------------------------------------------------------------
--
--  Logical unit: CustomerGroup
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  121205  PraWlk   Bug 106723, Modified the prompt for the LU to 'Customer Statistic Group'.
--  120508  JeLise   Added the possibility to translate data by adding a call to Basic_Data_Translation_API.Insert_Basic_Data_Translation
--  120508           in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120508           was added. Get_Description and the view were updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100514  Ajpelk   Merge rose merthod documentation
-- ----------------------------Eagle------------------------------------------
--  060117  SuJalk  Changed the "SELECT into ...." statment in Procedure Insert___ to "RETURNING &OBJID INTO objid".
--  --------------------------------------13.3.0-----------------------------
--  010103  FBen  Changed view comment to Customer Statistic Group from Customer Group.
--  990412  PaLj  YOSHIMURA - New Template
--  989527  JOHW  Removed uppercase on COMMENT ON COLUMN &VIEW..description
--  971120  RaKu  Changed to FND200 Templates.
--  970509  JoAn  Added method Get_Control_Type_Value_Desc
--  970508  JoAn  Removed indicator from view and indicator and company from
--                Insert___
--  970312  RaKu  Changed table name.
--  970219  RaKu  Changed rowversion (10.3 Project).
--  960212  JOLA  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   cust_grp_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ customer_group_tab.description%TYPE;
BEGIN
   IF (cust_grp_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation('ORDER', 'CustomerGroup',
      cust_grp_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  customer_group_tab
      WHERE cust_grp = cust_grp_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(cust_grp_, 'Get_Description');
END Get_Description;


-- Get_Control_Type_Value_Desc
--   Used by accounting
--   Retrieve control value description used for accounting
PROCEDURE Get_Control_Type_Value_Desc (
   desc_    OUT VARCHAR2,
   company_ IN  VARCHAR2,
   value_   IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;



