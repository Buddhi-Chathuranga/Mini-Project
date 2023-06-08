-----------------------------------------------------------------------------
--
--  Logical unit: PriceBreakTemplate
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  170926  RaVdlk   STRSC-11152,Removed Get_State function, since it is generated from the foundation
--  130307  Vwloza  Added SALES_PRICE_TYPE enumerator.
--  120525  JeLise   Made description private.
--  120511  JeLise   Replaced all calls to Module_Translate_Attr_Util_API with calls to Basic_Data_Translation_API
--  120511           in Insert___, Update___, Delete___, Get_Description, Get and in the view. 
--  111215  MaMalk   Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  110111  NaLrlk   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Set_Item_Value('SALES_PRICE_TYPE', Sales_Price_Type_API.Decode(Sales_Price_Type_API.DB_SALES_PRICES), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT price_break_template_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF NOT indrec_.sales_price_type THEN
      newrec_.sales_price_type := Sales_Price_Type_API.DB_SALES_PRICES;
   END IF;
   super(newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     price_break_template_tab%ROWTYPE,
   newrec_ IN OUT price_break_template_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   -- Don't allow update if status is closed
   IF (newrec_.rowstate = 'Closed') THEN
      Error_SYS.Record_General(lu_name_, 'NOTALLOWUPDATE: Update not allowed when status is closed.');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@UncheckedAccess
FUNCTION Activate_Allowed (
   template_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   found_ NUMBER;
   CURSOR get_template_line IS
      SELECT 1
      FROM   price_break_template_line_tab
      WHERE  template_id = template_id_;
BEGIN
   OPEN get_template_line;
   FETCH get_template_line INTO found_;
   IF (get_template_line%NOTFOUND) THEN
      found_ := 0;
   END IF;
   CLOSE get_template_line;
   RETURN found_;
END Activate_Allowed;

@UncheckedAccess
FUNCTION Get_Description (
   template_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ price_break_template_tab.description%TYPE;
BEGIN
   IF (template_id_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      template_id_), 1, 50);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  price_break_template_tab
      WHERE template_id = template_id_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(template_id_, 'Get_Description');
END Get_Description;

