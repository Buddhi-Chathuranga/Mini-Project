-----------------------------------------------------------------------------
--
--  Logical unit: CharBasedOptPriceList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  211125  PAMMLK  MF21R2-4888, Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
BEGIN
   super(attr_);
   Client_SYS.Add_To_Attr('OFFSET_VALUE', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT', '0', attr_ );
   Client_SYS.Add_To_Attr('FIXED_AMOUNT_INCL_TAX', '0', attr_ );
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', TRUNC(SYSDATE), attr_ );
END Prepare_Insert___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Common___ (
   oldrec_ IN     char_based_opt_price_list_tab%ROWTYPE,
   newrec_ IN OUT char_based_opt_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
END Check_Common___;

@Override
@IgnoreUnitTest MethodOverride
PROCEDURE Check_Delete___ (
   remrec_ IN CHAR_BASED_OPT_PRICE_LIST_TAB%ROWTYPE )
IS
BEGIN
   Sales_Price_List_API.Check_Editable(remrec_.price_list_no);

   super(remrec_);
END Check_Delete___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
@IgnoreUnitTest NoOutParams
PROCEDURE Delete_Option_Values (
   price_list_no_     IN VARCHAR2,
   config_family_id_  IN VARCHAR2,
   characteristic_id_ IN VARCHAR2,
   price_line_no_     IN NUMBER)
IS
      objid_ VARCHAR2(2000);
      objversion_ VARCHAR2(2000);
      info_ VARCHAR2(2000);

      CURSOR get_all_option_ IS
         SELECT option_value_id,valid_from_date
         FROM   CHAR_BASED_OPT_PRICE_LIST_TAB
         WHERE  config_family_id = config_family_id_
         AND    characteristic_id = characteristic_id_
         AND    price_list_no = price_list_no_
         AND    price_line_no = price_line_no_;
BEGIN
   FOR all_option IN get_all_option_ LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_,price_list_no_,config_family_id_,characteristic_id_,price_line_no_,all_option.option_value_id,all_option.valid_from_date);
      Remove__ (info_,objid_,objversion_,'DO');
   END LOOP;
END Delete_Option_Values;

-- Is_Valid_Price_List
--   Check the Validity of the price list
@IgnoreUnitTest TrivialFunction
FUNCTION Is_Valid_Price_List (
   price_list_no_     IN VARCHAR2,
   characteristic_id_ IN VARCHAR2,
   option_value_id_   IN VARCHAR2,
   contract_          IN VARCHAR2,
   currency_code_     IN VARCHAR2,
   catalog_no_        IN VARCHAR2,
   validity_date_     IN DATE DEFAULT NULL ) RETURN VARCHAR2
IS
   config_family_id_  VARCHAR2(24);
   found_             VARCHAR2(5) := 'FALSE';
   date_              DATE;

   CURSOR exist_control IS
      SELECT 'TRUE'
      FROM  char_based_opt_price_list_tab
      WHERE option_value_id = option_value_id_
      AND   config_family_id = config_family_id_
      AND   characteristic_id = characteristic_id_
      AND   price_list_no = price_list_no_;
BEGIN
   IF (validity_date_ IS NULL) THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := validity_date_;
   END IF;
   
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      config_family_id_ := Config_Part_Catalog_API.Get_Config_Family_Id(Sales_Part_API.Get_Part_No(contract_,catalog_no_));
   $END
   -- Check that price list is valid
   IF (Sales_Price_List_API.Is_Valid( price_list_no_, contract_, catalog_no_, date_ ) OR
       Sales_Price_List_API.Is_Valid_Assort( price_list_no_, contract_, catalog_no_, date_ )) THEN
      OPEN exist_control;
      FETCH exist_control INTO found_;
      IF exist_control%NOTFOUND THEN
         found_ := 'FALSE';
      END IF;
      CLOSE exist_control;
   END IF;
   RETURN found_;
END Is_Valid_Price_List;

-- Get_Price_List_Infos
--   Return information from Price List.
PROCEDURE Get_Price_List_Infos (
   offset_value_       OUT NUMBER,
   fixed_amount_       OUT NUMBER,
   fixed_amt_incl_tax_ OUT NUMBER,
   multiply_by_qty_    OUT VARCHAR2,
   price_list_no_      IN  VARCHAR2,
   characteristic_id_  IN  VARCHAR2,
   option_value_id_    IN  VARCHAR2,
   contract_           IN  VARCHAR2,
   catalog_no_         IN  VARCHAR2,
   validity_date_      IN  DATE DEFAULT NULL )
IS
   date_  DATE;
   config_family_id_  VARCHAR2(24);
   
   CURSOR get_infos IS
      SELECT offset_value, fixed_amount, fixed_amount_incl_tax, char_qty_price_method
      FROM char_based_opt_price_list_tab
      WHERE valid_from_date IN
         ( SELECT MAX(valid_from_date)
            FROM char_based_opt_price_list_tab
            WHERE  valid_from_date <= date_
               AND option_value_id = option_value_id_
               AND  config_family_id = config_family_id_
               AND  characteristic_id = characteristic_id_
               AND  price_list_no = price_list_no_)
      AND option_value_id = option_value_id_
      AND config_family_id = config_family_id_
      AND characteristic_id = characteristic_id_
      AND price_list_no = price_list_no_;
BEGIN

   IF (validity_date_ IS NULL)  THEN
      date_ := Site_API.Get_Site_Date(contract_);
   ELSE
      date_ := validity_date_;
   END IF;
   
   $IF (Component_Cfgchr_SYS.INSTALLED) $THEN
      config_family_id_ := Config_Part_Catalog_API.Get_Config_Family_Id(Sales_Part_API.Get_Part_No(contract_,catalog_no_));
   $END
   
   OPEN get_infos;
   FETCH get_infos INTO offset_value_, fixed_amount_, fixed_amt_incl_tax_, multiply_by_qty_;
   IF get_infos%NOTFOUND THEN
      offset_value_ := NULL;
      fixed_amount_ := NULL;
      fixed_amt_incl_tax_ := NULL;
      multiply_by_qty_ := NULL;
   END IF;
   CLOSE get_infos;
END Get_Price_List_Infos;