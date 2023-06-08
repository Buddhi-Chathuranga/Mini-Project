-----------------------------------------------------------------------------
--
--  Logical unit: InventoryProductFamily
--  Component:    INVENT
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  160502  JeLise  STRSC-2131, Changed Insert_Lu_Data_Rec__ to call New___ and Modify___ to avoid installation errors.
--  120525  JeLise  Made description private.
--  120507  Matkse  Replaced calls to obsolete Module_Translate_Attr_Util_API with Basic_Data_Translation_API.Added the possibility to translate data by adding a call to Basic_Data_Translation_API.
--  120507          Insert_Basic_Data_Translation in Insert___ and Update___. In Delete___ a call to Basic_Data_Translation_API.Remove_Basic_Data_Translation
--  120507          was added. Get_Description and the view was updated with calls to Basic_Data_Translation_API.Get_Basic_Data_Translation.
--  100507  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  070519  WaJalk  Made the column 'part_product_family' uppercase.
--  060119  SeNslk  Modified the template version as 2.3 and modified the PROCEDURE Insert___
--  060119          and added UNDEFINE according to the new template.
--  040302  GeKalk  Replaced substrb with substr for UNICODE modifications.
--  --------------------------------- 13.3.0 --------------------------------
--  031001  ThGulk  Changed substr to substrb, instr to instrb, length to lengthb.
--  020124  DaMase  IID 21001, Component Translation support. Insert_Lu_Data_Rec__.
--  000925  JOHESE  Added undefines.
--  000417  NISOSE  Added General_SYS.Init_Method in Get_Control_Type_Value_Desc.
--  990421  JOHW    General performance improvements.
--  990409  JOHW    Upgraded to performance optimized template.
--  971201  GOPE    Upgrade to fnd 2.0
--  970508  FRMA    Added Get_Control_Type_Value_Desc.
--  970312  MAGN    Changed tablename from mpc_product_family to inventory_product_family_tab.
--  970220  JOKE    Uses column rowversion as objversion (timestamp).
--  961213  LEPE    Modified for new template standard.
--  961101  JICE    Modified for Rational Rose/Workbench.
--  960916  JICE    Added function Get_Description.
--  960902  SHVE    Base Table to Logical Unit Generator 1.0
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Insert_Lu_Data_Rec__
--   Handles component translations
PROCEDURE Insert_Lu_Data_Rec__ (
   newrec_ IN INVENTORY_PRODUCT_FAMILY_TAB%ROWTYPE)
IS
   dummy_ VARCHAR2(1);
   rec_   inventory_product_family_tab%ROWTYPE;
   
   CURSOR Exist IS
      SELECT 'X'
      FROM INVENTORY_PRODUCT_FAMILY_TAB
      WHERE part_product_family = newrec_.part_product_family;
      
   CURSOR get_rec IS
      SELECT rowstate, rowkey
      FROM INVENTORY_PRODUCT_FAMILY_TAB
      WHERE part_product_family = newrec_.part_product_family;
BEGIN
   rec_ := newrec_;
   
   OPEN get_rec;
   FETCH get_rec INTO rec_.rowstate, rec_.rowkey;
   CLOSE get_rec;
   
   OPEN Exist;
   FETCH Exist INTO dummy_;
   IF (Exist%NOTFOUND) THEN
      New___(rec_);
   ELSE
      Modify___(rec_);
   END IF;
   CLOSE Exist;
END Insert_Lu_Data_Rec__;

-- Get_Description
--   Fetches the Description attribute for a record.
@UncheckedAccess
FUNCTION Get_Description (
   part_product_family_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ inventory_product_family_tab.description%TYPE;
BEGIN
   IF (part_product_family_ IS NULL) THEN
      RETURN NULL;
   END IF;
   temp_ := substr(Basic_Data_Translation_API.Get_Basic_Data_Translation(module_, lu_name_,
      part_product_family_), 1, 35);
   IF (temp_ IS NOT NULL) THEN
      RETURN temp_;
   END IF;
   SELECT description
      INTO  temp_
      FROM  inventory_product_family_tab
      WHERE part_product_family = part_product_family_;
   RETURN temp_;
EXCEPTION
   WHEN no_data_found THEN
      RETURN NULL;
   WHEN too_many_rows THEN
      Raise_Too_Many_Rows___(part_product_family_, 'Get_Description');
END Get_Description;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Procedure to get description for accounting rules.
PROCEDURE Get_Control_Type_Value_Desc (
   description_ OUT VARCHAR2,
   company_     IN  VARCHAR2,
   value_       IN  VARCHAR2 )
IS
BEGIN
   description_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;



