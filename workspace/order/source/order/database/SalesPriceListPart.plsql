-----------------------------------------------------------------------------
--
--  Logical unit: SalesPriceListPart
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210423  AsZelk  Bug 158429(SCZ-14262), Modified Insert_Price_Break_Lines(), Round_Base_And_Sales_Prices(), Modify_Sales_Prices() to fix sales_price_, sales_price_incl_tax_ not rounding issue.
--  210209  ErRalk Bug 157558(SSCZ-13423), Modified Copy__ method to allow copy sales price assortment list.
--  210112  MaEelk SC2020R1-12036, Modified New and replaced Unpack___, Check_Insert___, Insert___ with New___.
--  210112         Modified Modify_Offset, Modify_Price_Info, Modify_Sales_Prices, Modify_Prices_For_Tax, Round_Base_And_Sales_Prices. Replaced Unpack___, Check_Update___, Update___ with Modify___. 
--  200324  ThKrLk Bug 151907(SCZ-8550), Modified Modify_Sales_Prices() method to assign initial values for sales_price and sales_price_incl_tax. 
--  200324         And added new parameter to Sales_Part_Base_Price_API.Calculate_Part_Prices() method as reset_sales_prices_.  
--  200121  ThKrLk Bug 151907(SCZ-8550), Added new conditon to Round_Base_And_Sales_Prices() when calculating temp_sales_price_incl_tax_ and temp_sales_price_ and added new parameter.
--  190511  LaThlk Bug 142914, Modified Insert_Price_Break_Lines() to fetch the price break template from Sales_Part_Base_Price_API when the from_header_ is true.
--  181213  MaEelk SCUXXW4-1206, Added Calc_And_Round_Sales_Prices , Calculate_Prices and Calc_Net_Gross_Sales_Prices
--  181015  MaEelk  SCUXXW4-9452, Added method Round_Base_And_Sales_Prices in order to support validations done in rounding.
--  180126  MaEelk STRSC-16289, Passed the client value of sales_pice_type into the method call Sales_Part_Base_Price_API.Get_Objstate.
--  180116  SURBLK Modified Set_Base_Price_Upd_Status___() by adding Get_Objstate instead of Get_State.
--  170926  RaVdlk STRSC-11152,Removed Get_State function, since it is generated from the foundation
--  170524  ShPrlk STRSC-7351, Added method Calc_Net_And_Gross_Price to fetch the calculated Gross and Net Amounts during populate by binding to relevant SQL columns.
--  170507  MaEelk STRSC-7571, Modified Copy_Line___ and passed catalog_no to the parameter psrt_no in Characteristic_Price_List_API.Copy in the case of Non Inv Sales Parts
--  161027  ChFolk STRSC-4311, Added new parameters raise_msg_ and include_period_ to method Copy__ and modified the method to handle  coping according to the flag include_period_.
--  161012  ChFolk STRSC-4269, Renamed method Modify_Base_Prices as Modify_Price_Info as now it is used to modify offset changes and valid to date changes instead of just base price changes. 
--  161006  ChFolk STRSC-4267, Removed methods Modify_Base_Price and Modify_Base_Price_Incl_Tax and created a new method Modify_Base_Prices which support both functionality together.
--  160918  ChFolk STRSC-3834, Added new methods Modify_Valid_To_Date. Modified Calculate_Sales_Prices___ to pubic and added new parameter calc_direction_ to Calculate_Sales_Prices. 
--  160918         Added new parameters valid_to_date, sales_price_, sales_price_incl_tax_ to Modify_Offset to be used with given sales prices instead of calculating them inside the method.
--  160918         This is used from Customer_Order_Pricing_API.Adjust_Offset_Price_List__ and Duplicate_Price_List_Part___.
--  160824  NWeelk FINHR-2751, Modified method Calculate_Sales_Prices___, Copy__, Insert_Price_Break_Lines, Modify_Offset, Modify_Base_Price
--  160824         Modify_Base_Price_Incl_Tax, Modify_Sales_Prices and Modify_Prices_For_Tax to align with new tax handling logic.
--  160805  ChFolk STRSC-3730, Added new parameter valid_to_date into New method and modified Copy__ method to consider valid_to_date when coping the lines.
--  160805  ChFolk STRSC-3725, Added new parameter valid_to_date into Insert_Price_Break_Lines and did necessary changes in calling places.
--  160805  ChFolk STRSC-3585, Added new parameter valid_to_date to New method.
--  160803  ChFolk STRSC-3583, Added new method Check_Period_Overlapped___ and overrride Check_Common___ to add validations for valid_to_date.
--  160803         Modified Insert___ and Update___ to give information message when header valid to date is exceeded by line valid From date and To date.
--  160525  SWeelk Bug 127400, Modified Calculate_Sales_Prices___() by adding two new parameters to accept current values of sales_price and sales_price_incl_tax. 
--  160525         All the method invocations are modified aswell to work with the new parameter list
--  150908  lathlk Bug 124322, Modified the procedure Activate_All_Planned_Lines__() by clearing the attr_ in order to avoid character string buffer too small error. 
--  140615  BudKlk Bug 121801, Modified the method Check_Insert___() in order to validate price_break_template_id.
--  141209  Hiralk PRFI-3633, Modified Modify_Prices_For_Tax() to update the prices for relevant base price site.
--  140929  BudKlk Bug 118934, Modified the method Get_Contribution_Margin__() in order to add a new varaible part_no to get the sales part's inventory part no.
--  140214  NaSalk Modified Check_Insert___.
--  140106  RoJalk Modified New__ and added newrec_ := Get_Object_By_Id___(objid_) before post insert actions.
--  131203  SeJalk Bug 114057, Added new parameter price_break_temp_id_ as default null to Insert_Price_Break_Lines.
--  131203         Checked Tamplate id validity in Unpack_Check_Insert___.
--  130628  MaKrlk Modified the method Prepare_Insert___ (Removed some changes added previously)
--  130318  NaLrlk Added validation for price_break_template with sales_price_type in Unpack_Check_Insert___ and Unpack_Check_Update___. 
--  130313  Vwloza Updated New__. Removed min_duration parameter from Insert_Price_Break_Lines.
--  130311  NaSalk Modified Unpack_Check_Insert___, New__ and Insert_Price_Break_Lines to extend the logic for sales price type of rental prices.
--  130307  NaSalk Added min_duration as a key column. Added sales price type column. 
--  130115  SURBLK Added Modify_Prices_For_Tax() to update price list.
--  120822  HimRlk Modified method Calculate_Sales_Prices___() to consider tax regime of the company when calculating prices.
--  120726  HimRlk Added new implementation method Calculate_Sales_Prices___() to calculate sales prices according to
--  120726         value of use price including tax and used that method when copying price list parts.
--  120724  HimRlk Added Modify_Sales_Prices() to calculate prices considering the use_price_incl_tax value of the header.
--  120720  HimRlk Added Modify_Base_Price_Incl_Tax(). Modified Modify_Offset() and Modify_Base_Price() to consider
--  120720         use_price_incl_tax value of the header when calculatin prices.
--  120718  SURBLK Added base_price_incl_tax and sales_price_incl_tax in to SALES_PRICE_PART_JOIN view.
--  120710  SURBLK Added columns base_price_incl_tax and sales_price_incl_tax.
--  120315  RiLase Modified Get_Contribution_Margin__: Added currency conversion,
--  120315         added Init Method and changed from public to private.
--  120113  ChFolk Added alias to the SALES_PRICE_LIST_PART view and use it for the sub query as to get correct filteration.
--  111215  MaMalk Modified Insert___ to move the setting of objversion_ to the end of this procedure.
--  111207  MaMalk Added pragma to Get_Contribution_Margin().
--  111103  ChJalk Added user allowed company and site filter to the base view SALES_PRICE_PART_JOIN.
--  111101  ChJalk Added user allowed company and site filter to the base view SALES_PRICE_LIST_PART.
--  110526  ShKolk Added General_SYS for Get_Contribution_Margin().
--  110321  RiLase Changed call to Get_Base_Price_From_Costing from procedure to function.
--  110222  RiLase Added Get_Contribution_Margin that calculates and returns the contributions margin
--  110222         based on the deafult cost that is setup in Pricing Cost Source.
--  110204  RiLase Added method Insert_Price_Break_Lines(). Added call to Insert_Price_Break_Lines() in New__.
--  110127  RiLase Added Get_State() and Set_Base_Price_Upd_Status___(). Added calls to
--  110127         Set_Base_Price_Upd_Status___() in New() and Modify_Base_Price().
--  110126  NaLrlk Added Finite State Machine.
--  101210  ShKolk Renamed company to owning_company.
--  101103  RaKalk Restricted modifications of price list by unauthorised users.
--  100514  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091014  DaZase Added MIN_QUANTITY in Prepare_Insert___.
--  090821  MaJalk Added company to view PARTJOIN.
--  090902  KiSalk Added method Copy__.
--  061102  PrPrlk Bug 61299, Modified methods Unpack_Check_Insert___ and Unpack_Check_Update___ to check for instances 
--  061102         where discount percentage is entered without a discount type.
--  060118  JaJalk Added the returning clause in Insert___ according to the new F1 template.
--  030731  ChIwlk Performed SP4 Merge.
--  030417  MaGu   Bug 33755, Added the parameter remrec_.catalog_no in a call to Characteristic_Price_List_API.Delete_Characteristic_Values.
--  021216  Asawlk Merged bug fixes in 2002-3 SP3
--  021120  ThJalk Bug 34051, Removed previous correction and added new cursor to count the records in SALES_PRICE_LIST_PART_TAB. 
--  021113  ThJalk Bug 34051, Added valid_from_date as a parameter when call to method Delete_Characteristic_Values in procedure Delete___. 
--  020304  MGUO  Bug 28288, Added check that sales_price must greater than 0. 
--  020107  CaSt  Bug fix 26922, Changed discount limits in Unpack_Check_Insert___ and Unpack_Check_Update___
--                to allow negative discount.
--  020306  JICE  Added discount to SALES_PRICE_LIST_PART_PUB
--  020103  JICE  Added public view for Sales Configutator Export
--  010801  SuSalk  Bug Fix 19108,Add new procedure to delete records on 'CHARACTERISTIC_PRICE_LIST_TAB' which is relevant to 'price_list_no','part_no'and 'contract' .
--  000913  FBen  Added UNDEFINED.
--  000525  MaGu  Bug fix 16193. Added joined view SALES_PRICE_PART_JOIN.
--  000301  JoEd  Changed validation of discount column.
--  000107  SaMi  Modify_Offset modified to calculate sales_price right
--  991221  SaMi  Modify_Offset added
--  -------------- 12.0 -----------------------------------------------------
--  990907  JOHW  Added checks where Discount_Type is Null and Discount is not.
--  990901  JOHW  Made Discount Public.
--  990831  JOHW  Added Discount_Type and Discount.
--  990505  RaKu  Modifyed Modify_Base_Price again. Sales_Price was wrong calculated.
--  990503  RaKu  Modifyed Modify_Base_Price.
--  990420  RaKu  Changes in Unpack_Check_Update___ with BASE_PRICE.
--  990323  RaKu  Added column SALES_PRICE. Added parameter sales_price in procedure New.
--  990119  PaLj  Changed sysdate to Site_API.Get_Site_Date(contract)
--  981130  RaKu  Changes to match Design.
--  981113  RaKu  Added function Check_Exist.
--  981109  RaKu  Made discount_class not mandatory.
--  981105  RaKu  Added checks in Unpack_Check_Insert___/Update___.
--  981102  RaKu  Added procedure Remove.
--  981102  RaKu  Changed in procedure New. Added procedure Modify_Base_Price.
--  981029  RaKu  Added procedure New.
--  981028  RaKu  Added defaults in Prepare_Insert___.
--                Added 'Unit Based'-check in Unpack_Check_Insert___.
--  981016  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

TYPE Price_and_Cost_Rec IS RECORD (
   calculated_sales_price  NUMBER,
   net_sales_price         NUMBER,
   gross_sales_price       NUMBER,
   cost                    NUMBER,
   cost_set                NUMBER,
   use_inventory_value_db  VARCHAR2(5),
   configurable_db         VARCHAR2(20),
   contribution_margin     NUMBER,
   price_list_editable     VARCHAR2(5),
   use_price_incl_tax_db   VARCHAR2(5));
   
TYPE Price_and_Cost_Arr IS TABLE OF Price_and_Cost_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------

state_separator_   CONSTANT VARCHAR2(1)   := Client_SYS.field_separator_;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Set_Base_Price_Upd_Status___ (
   price_list_no_   IN     VARCHAR2,
   catalog_no_      IN     VARCHAR2,
   min_quantity_    IN     NUMBER,
   valid_from_date_ IN     DATE,
   min_duration_    IN     NUMBER)
IS
   attr_          VARCHAR2(2000);
   info_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   objstate_         VARCHAR2(30);
BEGIN
   -- Update row status based on Await Review option on price list header.
   Get_Id_Version_By_Keys___(objid_, objversion_, price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   objstate_ := Get_Objstate(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   IF Sales_Price_List_API.Get_Await_Review_Db(price_list_no_) = Fnd_Boolean_API.db_true THEN
      IF objstate_ != 'Planned' THEN
         Plan__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
   ELSE
      IF objstate_ != 'Active' THEN
         Activate__(info_, objid_, objversion_, attr_, 'DO');
      END IF;
   END IF;
   
END Set_Base_Price_Upd_Status___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   price_list_no_        VARCHAR2(10);
   sales_price_list_rec_ SALES_PRICE_LIST_API.Public_Rec;
BEGIN
   price_list_no_ := Client_SYS.Get_Item_Value('PRICE_LIST_NO', attr_);
   sales_price_list_rec_ := Sales_Price_List_API.Get(price_list_no_);
   super(attr_);  
   Client_SYS.Add_To_Attr('VALID_FROM_DATE', Site_API.Get_Site_Date(User_Default_API.Get_Contract), attr_);
   IF sales_price_list_rec_.default_base_price_site IS NOT NULL THEN
      Client_SYS.Add_To_Attr('BASE_PRICE_SITE', sales_price_list_rec_.default_base_price_site, attr_);
   END IF;
   Client_SYS.Add_To_Attr('PERCENTAGE_OFFSET', sales_price_list_rec_.default_percentage_offset, attr_);
   Client_SYS.Add_To_Attr('AMOUNT_OFFSET', sales_price_list_rec_.default_amount_offset, attr_);
   Client_SYS.Add_To_Attr('MIN_QUANTITY', 0, attr_);
END Prepare_Insert___;

@Override
PROCEDURE Insert___ (
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   newrec_     IN OUT SALES_PRICE_LIST_PART_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.last_updated := Site_API.Get_Site_Date(User_Default_API.Get_Contract);
   Client_SYS.Add_To_Attr('LAST_UPDATED', newrec_.last_updated, attr_);
   
   IF (newrec_.valid_from_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_FROM: Price list :P1 will not be valid for Valid From date :P2.', newrec_.price_list_no, newrec_.valid_from_date);
   END IF;
   IF (newrec_.valid_to_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_TO: Price list :P1 will not be valid for Valid To date :P2.', newrec_.price_list_no, newrec_.valid_to_date);
   END IF;
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     SALES_PRICE_LIST_PART_TAB%ROWTYPE,
   newrec_     IN OUT SALES_PRICE_LIST_PART_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   newrec_.last_updated := Site_API.Get_Site_Date(User_Default_API.Get_Contract);
   Client_SYS.Add_To_Attr('LAST_UPDATED', newrec_.last_updated, attr_);
   
   IF (newrec_.valid_from_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_FROM: Price list :P1 will not be valid for Valid From date :P2.', newrec_.price_list_no, newrec_.valid_from_date);
   END IF;
   IF (newrec_.valid_to_date > Sales_Price_List_API.Get_Valid_To_Date(newrec_.price_list_no)) THEN
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_VALID_TO: Price list :P1 will not be valid for Valid To date :P2.', newrec_.price_list_no, newrec_.valid_to_date);
   END IF;
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN     SALES_PRICE_LIST_PART_TAB%ROWTYPE )
IS
BEGIN
   Sales_Price_List_API.Check_Editable(remrec_.price_list_no);
   
   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Delete___ (
   objid_  IN     VARCHAR2,
   remrec_ IN     SALES_PRICE_LIST_PART_TAB%ROWTYPE )
IS
   dummy_ NUMBER;
   
   CURSOR lines_exist IS
      SELECT count(*)
      FROM  SALES_PRICE_LIST_PART_TAB
      WHERE catalog_no = remrec_.catalog_no
      AND   price_list_no = remrec_.price_list_no;
BEGIN
   OPEN lines_exist;
   FETCH lines_exist INTO dummy_;
   IF (dummy_ = 1) THEN   
      CHARACTERISTIC_PRICE_LIST_API.Delete_Characteristic_Values(remrec_.price_list_no, Sales_Part_API.Get_Part_No(remrec_.base_price_site,remrec_.catalog_no),remrec_.catalog_no);
   END IF;
   CLOSE lines_exist;
   super(objid_, remrec_);
END Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_price_list_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_           VARCHAR2(30);
   value_          VARCHAR2(4000);
   sales_part_rec_ Sales_Part_API.Public_Rec;
   use_price_break_templates_ VARCHAR2(5);
BEGIN   
   --Sets the default value for min_duration and sales price type. 
   IF (NOT indrec_.min_duration) THEN 
      newrec_.min_duration := -1;
    END IF;
   IF (NOT indrec_.sales_price_type) THEN 
      newrec_.sales_price_type := Sales_Price_Type_API.DB_SALES_PRICES;
   END IF;
   IF (NOT indrec_.sales_price) THEN 
      --newrec_.sales_price := Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('BASE_PRICE', attr_));
      newrec_.sales_price := newrec_.base_price;
   END IF;

   super(newrec_, indrec_, attr_);
   
   sales_part_rec_ := Sales_Part_API.Get(newrec_.base_price_site, newrec_.catalog_no);
   
   IF (newrec_.min_quantity < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NEGATIVE_MIN_QTY: Min Qty cannot be negative.');
   END IF;
   IF (newrec_.sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES) THEN 
      newrec_.min_duration := -1;
   ELSIF (newrec_.sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES) THEN 
      IF (newrec_.min_duration <0) THEN 
         Error_SYS.Record_General(lu_name_, 'NEGATIVE_MIN_DUR: The minimum duration cannot be negative for rental prices.');
      END IF;         
   END IF;
   IF ((newrec_.sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES  AND sales_part_rec_.sales_type = Sales_Type_API.DB_RENTAL_ONLY) OR 
      (newrec_.sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES AND sales_part_rec_.sales_type = Sales_Type_API.DB_SALES_ONLY ))  THEN 
      Client_SYS.Add_Info(lu_name_, 'WARN_FOR_SALES_TYPE: Sales part :P1 has sales type :P2.', newrec_.catalog_no, Sales_Type_API.Decode(sales_part_rec_.sales_type));
   END IF;
   
   IF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_part_rec_.sales_price_group_id) = 'UNIT BASED') THEN
      Error_SYS.Record_General(lu_name_, 'NOT_PART_BASED: Sales parts with unit based price groups may not be used on a part based pricelist.');
   END IF;
   
   IF (sales_part_rec_.sales_price_group_id != Sales_Price_List_API.Get_Sales_Price_Group_Id(newrec_.price_list_no)) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PRICE_GROUP: Sales parts with price group :P1 may not be added to price list :P2.', sales_part_rec_.sales_price_group_id, newrec_.price_list_no);
   END IF;
   
   IF (newrec_.sales_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE: The price must be greater than 0.');
   END IF;
   
   IF (newrec_.sales_price_incl_tax < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE_INCL_TAX: The price including tax must be greater than 0.');
   END IF;
   
   IF (newrec_.discount_type IS NULL AND newrec_.discount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
   END IF;
   
   IF (newrec_.discount_type IS NOT NULL AND newrec_.discount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'SALES_DISCOUNT: You have to specify a discount percentage when using a discount type.');
   ELSIF (newrec_.discount_type IS NULL) THEN
      newrec_.discount := NULL;
      Client_SYS.Add_To_Attr('DISCOUNT', newrec_.discount, attr_);
      
      --ELSIF ((newrec_.discount < 0) OR (newrec_.discount > 100)) THEN
      --   Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT: Discount must be between 0 and 100!');
   ELSIF ((newrec_.discount < -100) OR (newrec_.discount > 100)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;
   
   IF Sales_Part_Base_Price_API.Get_Objstate(newrec_.base_price_site, newrec_.catalog_no, Sales_Price_Type_API.Decode(newrec_.sales_price_type)) != 'Active' THEN
      Error_SYS.Record_General(lu_name_, 'ADDONLYACTIVE: The sales part cannot be added because the base price is not active.');
   END IF;
   IF (newrec_.price_break_template_id IS NOT NULL) AND 
      (Sales_Part_Base_Price_API.Is_Valid_Price_Break_Templ(newrec_.base_price_site, newrec_.catalog_no, newrec_.price_break_template_id, newrec_.sales_price_type) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALTEMPLATE: You are only allowed to enter an active price break template of type :P1 with the price unit of measure :P2.',
      Sales_Price_Type_API.Decode(newrec_.sales_price_type), sales_part_rec_.price_unit_meas);
   END IF;
   use_price_break_templates_ := Sales_Price_List_API.Get_Use_Price_Break_Templat_Db(newrec_.price_list_no);
   IF (newrec_.price_break_template_id IS NOT NULL) AND (use_price_break_templates_ = Fnd_Boolean_API.db_false) THEN
      Error_SYS.Record_General(lu_name_, 'NOTENTPRICETEMP: You cannot enter a price break template ID when the Use Price Break Template check box has been cleared.');
   ELSIF (newrec_.price_break_template_id IS NOT NULL) AND (use_price_break_templates_ = Fnd_Boolean_API.db_true) AND 
         (NOT(Price_Break_Template_Line_API.Check_Exist(newrec_.price_break_template_id, newrec_.min_quantity, newrec_.min_duration))) THEN
      Error_SYS.Record_General(lu_name_, 'VALIDTEMPNOTFOUND: No valid price break template ID has been found.');
   END IF;
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_price_list_part_tab%ROWTYPE,
   newrec_ IN OUT sales_price_list_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_           VARCHAR2(30);
   value_          VARCHAR2(4000);
   sales_part_rec_ Sales_Part_API.Public_Rec;
BEGIN
   sales_part_rec_ := Sales_Part_API.Get(newrec_.base_price_site, newrec_.catalog_no);
   IF (sales_part_rec_.sales_price_group_id != Sales_Price_List_API.Get_Sales_Price_Group_Id(newrec_.price_list_no)) THEN
      Error_SYS.Record_General(lu_name_, 'PRICE_GROUP_CHANGED: The price group on sales part :P1 has been changed and makes the sales part invalid on price list :P2. Only remove is allowed.', newrec_.catalog_no, newrec_.price_list_no);
   END IF;
   
   newrec_.sales_price := NVL(Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('SALES_PRICE', attr_)), newrec_.sales_price);
   IF (newrec_.sales_price IS NULL) THEN
      newrec_.base_price := NVL(Client_SYS.Attr_Value_To_Number(Client_SYS.Get_Item_Value('BASE_PRICE', attr_)), newrec_.base_price);
      IF (newrec_.base_price IS NOT NULL) THEN
         newrec_.sales_price := newrec_.base_price;
      END IF;
   END IF;
   
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.sales_price < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE: The price must be greater than 0.');
   END IF;
   
   IF (newrec_.sales_price_incl_tax < 0) THEN
      Error_SYS.Record_General(lu_name_, 'NONE_NEG_PRICE_INCL_TAX: The price including tax must be greater than 0.');
   END IF;
   
   IF (newrec_.discount_type IS NULL AND newrec_.discount IS NOT NULL) THEN
      Error_SYS.Record_General(lu_name_, 'DISCTYPE_NULL: Discount percentage cannot be entered without a corresponding discount type.');
   END IF;
   
   IF (newrec_.discount_type IS NOT NULL AND newrec_.discount IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'SALES_DISCOUNT: You have to specify a discount percentage when using a discount type.');
   ELSIF (newrec_.discount_type IS NULL) THEN
      newrec_.discount := NULL;
      Client_SYS.Add_To_Attr('DISCOUNT', newrec_.discount, attr_);
      --ELSIF ((newrec_.discount < 0) OR (newrec_.discount > 100)) THEN
      --   Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT: Discount must be between 0 and 100!');
   ELSIF ((newrec_.discount < -100) OR (newrec_.discount > 100)) THEN
      Error_SYS.Record_General(lu_name_, 'INVALID_DISCOUNT3: Discount must be between -100 and 100!');
   END IF;
   IF (newrec_.price_break_template_id IS NOT NULL) AND 
      (Sales_Part_Base_Price_API.Is_Valid_Price_Break_Templ(newrec_.base_price_site, newrec_.catalog_no, newrec_.price_break_template_id, newrec_.sales_price_type) = 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALTEMPLATE: You are only allowed to enter an active price break template of type :P1 with the price unit of measure :P2.',
      Sales_Price_Type_API.Decode(newrec_.sales_price_type), sales_part_rec_.price_unit_meas);
   END IF;
   Sales_Price_List_API.Check_Editable(newrec_.price_list_no);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

@Override
PROCEDURE Check_Common___ (
   oldrec_ IN     sales_price_list_part_tab%ROWTYPE,
   newrec_ IN OUT sales_price_list_part_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);
   IF (indrec_.percentage_offset AND (newrec_.percentage_offset < -100)) THEN
      Error_SYS.Record_General(lu_name_, 'NEGPERCENTAGE: Negative percentage value cannot be greater than 100.');
   END IF;  
   IF (TRUNC(newrec_.valid_from_date) > TRUNC(newrec_.valid_to_date)) THEN
      Error_SYS.Record_General(lu_name_, 'EARLY_TO_DATE: Valid To date has to be equal to or later than Valid From date.');
   END IF;

   IF (indrec_.valid_to_date AND newrec_.valid_to_date IS NOT NULL) THEN
      IF (Check_Period_Overlapped___(newrec_.price_list_no, newrec_.catalog_no, newrec_.min_quantity, newrec_.valid_from_date, newrec_.min_duration, newrec_.valid_to_date) = 'TRUE') THEN
         Error_SYS.Record_General(lu_name_, 'PERIOD_OVRLAPPED: Timeframe is overlapping with other Valid From and Valid To timeframe for same Min Qty.');
      END IF;
   END IF;   
END Check_Common___;

FUNCTION Check_Period_Overlapped___(
   price_list_no_   IN  VARCHAR2,
   catalog_no_      IN  VARCHAR2,
   min_quantity_    IN  NUMBER,
   valid_from_date_ IN  DATE,
   min_duration_    IN  NUMBER,
   valid_to_date_   IN  DATE ) RETURN VARCHAR2
   
IS
   period_overlapped_  VARCHAR2(5) := 'FALSE';
   dummy_              NUMBER;
   
   CURSOR find_overlap IS
      SELECT 1
      FROM SALES_PRICE_LIST_PART_TAB
      WHERE price_list_no = price_list_no_
      AND catalog_no = catalog_no_
      AND min_quantity = min_quantity_
      AND min_duration = min_duration_
      AND valid_to_date IS NOT NULL
      AND ((TRUNC(valid_from_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) BETWEEN TRUNC(valid_from_date) AND TRUNC(valid_to_date)) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_from_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))) OR
           (TRUNC(valid_to_date_) IS NOT NULL AND (TRUNC(valid_to_date) BETWEEN TRUNC(valid_from_date_) AND TRUNC(valid_to_date_))))
      AND valid_from_date != valid_from_date_;
BEGIN
   OPEN find_overlap;
   FETCH find_overlap INTO dummy_;
   IF (find_overlap%FOUND) THEN
      period_overlapped_ := 'TRUE';
   END IF;   
   CLOSE find_overlap;
   
   RETURN period_overlapped_;
END Check_Period_Overlapped___;

PROCEDURE Copy_Line___ (
   old_price_list_no_     IN  VARCHAR2,
   new_price_list_no_     IN  VARCHAR2,
   catalog_no_            IN  VARCHAR2,
   min_quantity_          IN  NUMBER,
   old_valid_from_date_   IN  DATE,
   new_valid_from_date_   IN  DATE,
   min_duration_          IN  NUMBER,
   base_price_site_       IN  VARCHAR2,
   base_price_            IN  NUMBER,
   base_price_incl_tax_   IN  NUMBER,
   sales_price_           IN  NUMBER,
   sales_price_incl_tax_  IN  NUMBER,
   discount_type_         IN  VARCHAR2,
   discount_              IN  NUMBER,
   currency_rate_         IN  NUMBER,
   percentage_offset_     IN  NUMBER,
   amount_offset_         IN  NUMBER,
   rounding_              IN  NUMBER,
   use_price_incl_tax_db_ IN  VARCHAR2,   
   template_id_           IN  VARCHAR2,
   sales_price_type_db_   IN  VARCHAR2,
   valid_to_date_         IN  DATE )
   
IS
   new_base_price_            NUMBER;
   new_base_price_incl_tax_   NUMBER;
   new_sales_price_           NUMBER;
   new_sales_price_incl_tax_  NUMBER;
   
BEGIN
   new_base_price_ := base_price_;
   new_base_price_incl_tax_ := base_price_incl_tax_;   
   Calculate_Sales_Prices(new_sales_price_, new_sales_price_incl_tax_, new_base_price_, new_base_price_incl_tax_, percentage_offset_, 
                          amount_offset_, rounding_, base_price_site_, catalog_no_, use_price_incl_tax_db_,
                          'NO_CALC', sales_price_, sales_price_incl_tax_);
   New(new_price_list_no_,
       catalog_no_,
       min_quantity_,
       new_valid_from_date_,
       min_duration_,
       base_price_site_,
       discount_type_,
       discount_,
       new_base_price_,
       new_base_price_incl_tax_,
       new_sales_price_,
       new_sales_price_incl_tax_,
       percentage_offset_,
       amount_offset_,
       rounding_,
       TRUE,
       template_id_, 
       sales_price_type_db_,
       valid_to_date_); 
       
   IF (Sales_Part_API.Get_Configurable_Db(base_price_site_, catalog_no_) = 'CONFIGURED') THEN    
         -- copy all the characteristic price lines from the given price_list_no
         Characteristic_Price_List_API.Copy(old_price_list_no_, new_price_list_no_, old_valid_from_date_, new_valid_from_date_, 
                                            NVL(Sales_Part_API.Get_Part_No(base_price_site_, catalog_no_),catalog_no_), catalog_no_, 1/currency_rate_);                                 
   END IF;    
END Copy_Line___;   

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_          OUT VARCHAR2,
   objid_         OUT VARCHAR2,
   objversion_    OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_      sales_price_list_part_tab%ROWTYPE;
   added_lines_ NUMBER;
BEGIN
 
   super(info_, objid_, objversion_, attr_, action_);
   
   IF (action_ = 'DO') THEN 
      newrec_ := Get_Object_By_Id___(objid_);
      -- Post insert actions
      Insert_Price_Break_Lines(added_lines_,
                               newrec_.price_list_no,
                               newrec_.catalog_no,
                               newrec_.base_price_site,
                               newrec_.valid_from_date,
                               newrec_.discount_type,
                               newrec_.discount,
                               newrec_.percentage_offset,
                               newrec_.amount_offset,
                               newrec_.rounding,
                               FALSE,
                               newrec_.sales_price_type,
                               newrec_.price_break_template_id,
                               newrec_.valid_to_date);
      info_ := info_ || Client_SYS.Get_All_Info;
   END IF;    
END New__;


@UncheckedAccess
FUNCTION Planned_Part_Lines_Exist__ (
   price_list_no_ VARCHAR2) RETURN VARCHAR2
IS
   dummy_ NUMBER;
   CURSOR exist_planned_control IS
      SELECT 1
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE price_list_no = price_list_no_
      AND   rowstate = 'Planned';
BEGIN
   OPEN exist_planned_control;
   FETCH exist_planned_control INTO dummy_;
   IF (exist_planned_control%FOUND) THEN
      CLOSE exist_planned_control;
      RETURN 'TRUE';
   END IF;
   CLOSE exist_planned_control;
   RETURN 'FALSE';
END Planned_Part_Lines_Exist__;


PROCEDURE Activate_All_Planned_Lines__ (
   price_list_no_ IN     VARCHAR2)
IS
   attr_          VARCHAR2(2000);
   info_          VARCHAR2(2000);
   objid_         VARCHAR2(2000);
   objversion_    VARCHAR2(2000);
   
   CURSOR get_all_planned_lines IS
      SELECT catalog_no, min_quantity, valid_from_date, min_duration
      FROM   SALES_PRICE_LIST_PART_TAB t
      WHERE  price_list_no = price_list_no_
      AND    t.rowstate = 'Planned';
   
BEGIN
   FOR rec_ IN get_all_planned_lines LOOP
      Get_Id_Version_By_Keys___(objid_, objversion_, price_list_no_, rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date, rec_.min_duration);
      Activate__(info_, objid_, objversion_, attr_, 'DO');
      Client_SYS.Clear_Attr(attr_);
   END LOOP;
END Activate_All_Planned_Lines__;


@UncheckedAccess
FUNCTION Get_Contribution_Margin__ (
   price_list_no_   IN     VARCHAR2,
   base_price_site_ IN     VARCHAR2,
   catalog_no_      IN     VARCHAR2,
   min_quantity_    IN     NUMBER,
   valid_from_date_ IN     DATE,
   min_duration_    IN     NUMBER) RETURN NUMBER
IS
   contribution_margin_       NUMBER;
   cost_                      NUMBER;
   cost_set_                  NUMBER;
   use_inventory_value_       VARCHAR2(5);
   net_sales_price_           NUMBER;
   currency_rate_             NUMBER;
   conv_factor_               NUMBER;
   currency_type_             VARCHAR2(10);
   sales_price_list_part_rec_ Sales_Price_List_Part_API.Public_Rec;
   sales_price_list_rec_      Sales_Price_List_API.Public_Rec;
   part_no_                   VARCHAR2(25);
BEGIN
   cost_set_ := Pricing_Contri_Margin_Ctrl_API.Get_Valid_Cost_Set(base_price_site_, valid_from_date_);
   use_inventory_value_ := Pricing_Contri_Margin_Ctrl_API.Get_Valid_Use_Inv_Value_Db(base_price_site_, valid_from_date_);
   sales_price_list_part_rec_ := Sales_Price_List_Part_API.Get(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   
   IF use_inventory_value_ = Fnd_Boolean_API.db_true THEN
      part_no_ := Sales_Part_API.Get_Part_No(base_price_site_,catalog_no_);
      cost_ := Sales_Cost_Util_API.Get_Cost_Incl_Sales_Overhead(base_price_site_,
                                                                part_no_,
                                                                '*',
                                                                NULL,
                                                                min_quantity_,
                                                                'CHARGED ITEM',
                                                                Order_Supply_Type_API.Encode(Sales_Part_API.Get_Default_Supply_Code(base_price_site_, catalog_no_)),
                                                                NULL,
                                                                'COMPANY OWNED');
   ELSIF cost_set_ IS NOT NULL THEN
      cost_ := Customer_Order_Pricing_API.Get_Base_Price_From_Costing(base_price_site_, catalog_no_, cost_set_);
   ELSE
      cost_ := 0;
   END IF;
   
   sales_price_list_rec_ := Sales_Price_List_API.Get(price_list_no_);      
   
   IF cost_ > 0 AND sales_price_list_rec_.currency_code != Company_Finance_Api.Get_Currency_Code(Site_API.Get_Company(base_price_site_)) THEN
      Invoice_Library_API.Get_Currency_Rate_Defaults(currency_type_,
                                                     conv_factor_,
                                                     currency_rate_,
                                                     sales_price_list_rec_.owning_company,
                                                     sales_price_list_rec_.currency_code,
                                                     valid_from_date_);
      currency_rate_ := currency_rate_ / conv_factor_;
      cost_ := cost_ / currency_rate_;
   END IF;
   
   net_sales_price_ := sales_price_list_part_rec_.sales_price * (1 - NVL(sales_price_list_part_rec_.discount, 0)/100);
   
   IF net_sales_price_ IS NOT NULL AND net_sales_price_ != 0 THEN
      contribution_margin_ := round(((net_sales_price_-cost_)/net_sales_price_)*100, 2);
   ELSE
      contribution_margin_ := NULL;
   END IF;
   
   RETURN contribution_margin_;
END Get_Contribution_Margin__;


-- Copy__
--   Copies records from a price list to another that are valid on the specified date.
--   Returns number of records copied.
PROCEDURE Copy__ (
   copied_items_       OUT NUMBER,
   raise_msg_          IN OUT VARCHAR2,
   price_list_no_      IN  VARCHAR2,
   valid_from_date_    IN  DATE,
   currency_rate_      IN  NUMBER,
   rounding_           IN  NUMBER,
   to_price_list_no_   IN  VARCHAR2,
   to_valid_from_date_ IN  DATE,
   include_period_     IN  VARCHAR2 )
IS
   sales_price_group_id_    VARCHAR2(10);
   ignore_header_rounding_  BOOLEAN;
   new_valid_from_date_     DATE;
   to_rounding_             NUMBER;
   counter_                 NUMBER := 0;
   use_price_incl_tax_db_   VARCHAR2(20);
   new_valid_to_date_       DATE;
   exist_rec_valid_to_date_ DATE;
   next_valid_from_date_    DATE;
   
   CURSOR find_all_part_based_records IS
      SELECT catalog_no, min_quantity, base_price_site, valid_from_date, min_duration, discount_type, discount,
             base_price * currency_rate_ base_price, base_price_incl_tax * currency_rate_ base_price_incl_tax, 
             percentage_offset, amount_offset * currency_rate_ amount_offset,
             sales_price * currency_rate_ sales_price, sales_price_incl_tax * currency_rate_ sales_price_incl_tax, 
             rounding, price_break_template_id, sales_price_type, valid_to_date
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_; 
   
   CURSOR get_time_frame_records IS
      SELECT catalog_no, min_quantity, valid_from_date, min_duration, base_price_site, discount_type, discount,
             base_price * currency_rate_ base_price, base_price_incl_tax * currency_rate_ base_price_incl_tax, 
             percentage_offset, amount_offset * currency_rate_ amount_offset, sales_price * currency_rate_ sales_price, 
             sales_price_incl_tax * currency_rate_ sales_price_incl_tax, rounding, price_break_template_id, sales_price_type, valid_to_date
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    valid_to_date IS NOT NULL
      AND    valid_from_date <= TRUNC(valid_from_date_)
      AND    valid_to_date >= TRUNC(valid_from_date_);
   
   CURSOR get_non_time_frame_records IS
      SELECT catalog_no, min_quantity, min_duration, valid_from_date, base_price_site, discount_type, discount,
             base_price * currency_rate_ base_price, base_price_incl_tax * currency_rate_ base_price_incl_tax, 
             percentage_offset, amount_offset * currency_rate_ amount_offset, sales_price * currency_rate_ sales_price, 
             sales_price_incl_tax * currency_rate_ sales_price_incl_tax, rounding, price_break_template_id, sales_price_type
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND   (catalog_no, min_quantity, min_duration, valid_from_date) IN
             (SELECT catalog_no, min_quantity, min_duration, MAX(valid_from_date)
              FROM  SALES_PRICE_LIST_PART_TAB 
              WHERE  price_list_no = price_list_no_
              AND    valid_from_date <= TRUNC(valid_from_date_)
              AND    valid_to_date IS NULL
              GROUP BY catalog_no, min_quantity, min_duration);
   
   CURSOR check_exist_inserted_rec(new_price_list_no_ VARCHAR2, catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = new_price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_from_date = from_date_;
      
   -- Suppose we have given a valid from date as 15-06-2009 when copying and there are three records with vaid_from_dates
   -- 13-06-2009,14-06-2009 and 16-06-2009, This cursor will select 14-06-2009 as the date that we should consider when copying records 
   CURSOR get_next_records IS
      SELECT catalog_no, min_quantity, min_duration, valid_from_date, base_price_site, discount_type, discount,
             base_price * currency_rate_ base_price, base_price_incl_tax * currency_rate_ base_price_incl_tax, 
             percentage_offset, amount_offset * currency_rate_ amount_offset, sales_price * currency_rate_ sales_price, 
             sales_price_incl_tax * currency_rate_ sales_price_incl_tax, rounding, price_break_template_id, sales_price_type, valid_to_date
      FROM  SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    NVL(valid_to_date, TRUNC(valid_from_date_)) >= TRUNC(valid_from_date_)
      AND   (catalog_no, min_quantity, min_duration, valid_from_date) IN
          (SELECT catalog_no, min_quantity, min_duration, valid_from_date
           FROM  SALES_PRICE_LIST_PART_TAB
           WHERE (catalog_no, min_quantity, min_duration, valid_from_date) IN
                 (SELECT catalog_no, min_quantity, min_duration, MAX(valid_from_date) valid_from_date
                  FROM   SALES_PRICE_LIST_PART_TAB
                  WHERE  price_list_no = price_list_no_
                  AND    valid_from_date <= TRUNC(valid_from_date_)
                  AND    valid_to_date IS NULL
                  GROUP BY catalog_no, min_quantity, min_duration)
                  UNION ALL
                  (SELECT catalog_no, min_quantity, min_duration, valid_from_date
                   FROM   SALES_PRICE_LIST_PART_TAB
                   WHERE  price_list_no = price_list_no_
                   AND    valid_from_date > TRUNC(valid_from_date_)))
      ORDER BY catalog_no, min_quantity, min_duration, valid_from_date;        
      
   CURSOR find_null_valid_to_date_recs IS
      SELECT catalog_no, min_quantity, min_duration, valid_from_date, base_price_site, discount_type, discount,
             base_price * currency_rate_ base_price, base_price_incl_tax * currency_rate_ base_price_incl_tax, 
             percentage_offset, amount_offset * currency_rate_ amount_offset, sales_price * currency_rate_ sales_price, 
             sales_price_incl_tax * currency_rate_ sales_price_incl_tax, rounding, price_break_template_id, sales_price_type
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    valid_to_date IS NULL
      AND   (catalog_no, min_quantity, min_duration, valid_from_date) IN
          (SELECT catalog_no, min_quantity, min_duration, valid_from_date
           FROM  SALES_PRICE_LIST_PART_TAB
           WHERE (catalog_no, min_quantity, min_duration, valid_from_date) IN
                 (SELECT catalog_no, min_quantity, min_duration, MAX(valid_from_date) valid_from_date
                  FROM   SALES_PRICE_LIST_PART_TAB
                  WHERE  price_list_no = price_list_no_
                  AND    valid_from_date <= TRUNC(valid_from_date_)
                  AND    valid_to_date IS NULL
                  GROUP BY catalog_no, min_quantity, min_duration)
                  UNION ALL
                  (SELECT catalog_no, min_quantity, min_duration, valid_from_date
                   FROM   SALES_PRICE_LIST_PART_TAB
                   WHERE  price_list_no = price_list_no_
                   AND    valid_from_date > TRUNC(valid_from_date_)
                   AND    valid_to_date IS NULL))
      ORDER BY catalog_no, min_quantity, min_duration, valid_from_date;
      
BEGIN
   sales_price_group_id_ := Sales_Price_List_API.Get_Sales_Price_Group_Id(price_list_no_);
   use_price_incl_tax_db_ := Sales_Price_List_API.Get_Use_Price_Incl_Tax_Db(to_price_list_no_);
   ignore_header_rounding_ := (Sales_Price_List_API.Get_Currency_Code(price_list_no_) = Sales_Price_List_API.Get_Currency_Code(to_price_list_no_));
   to_rounding_ := rounding_;
   
   IF (valid_from_date_ IS NULL) THEN
      -- Copy all rows on price list.
      Trace_SYS.Message('All Rows');
      FOR rec_ IN find_all_part_based_records LOOP
         IF (include_period_ = 'TRUE' OR ((include_period_ = 'FALSE') AND rec_.valid_to_date IS NULL)) THEN
            IF (ignore_header_rounding_) THEN
               to_rounding_ := rec_.rounding;
            END IF;
            IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date, rec_.min_duration)
               AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
               Copy_Line___(price_list_no_,
                            to_price_list_no_,
                            rec_.catalog_no,
                            rec_.min_quantity,
                            rec_.valid_from_date,
                            rec_.valid_from_date,
                            rec_.min_duration,
                            rec_.base_price_site,
                            rec_.base_price,
                            rec_.base_price_incl_tax,
                            rec_.sales_price,
                            rec_.sales_price_incl_tax,
                            rec_.discount_type,
                            rec_.discount,
                            currency_rate_,
                            rec_.percentage_offset,
                            rec_.amount_offset,
                            to_rounding_,
                            use_price_incl_tax_db_,
                            rec_.price_break_template_id,
                            rec_.sales_price_type,
                            rec_.valid_to_date);
               counter_ := counter_ + 1;
            END IF;
         END IF;
      END LOOP;
   ELSE
      -- valid_from_date IS NOT NULL
      IF (include_period_ = 'TRUE') THEN
         IF (to_valid_from_date_ IS NOT NULL) THEN
            -- only one record will be created for one catalog, min_quantity and min_duration
            new_valid_from_date_ := to_valid_from_date_;
            FOR rec_ IN get_time_frame_records LOOP
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               new_valid_to_date_ := rec_.valid_to_date;
               IF (new_valid_from_date_ > rec_.valid_to_date) THEN
                  new_valid_to_date_ := NULL;
                  IF (raise_msg_ IS NULL) THEN
                     raise_msg_ := 'TRUE';
                  END IF;   
               END IF;
               IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, new_valid_from_date_, rec_.min_duration)
                  AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
                  Copy_Line___(price_list_no_,
                               to_price_list_no_,
                               rec_.catalog_no,
                               rec_.min_quantity,
                               rec_.valid_from_date,
                               new_valid_from_date_,
                               rec_.min_duration,
                               rec_.base_price_site,
                               rec_.base_price,
                               rec_.base_price_incl_tax,
                               rec_.sales_price,
                               rec_.sales_price_incl_tax,
                               rec_.discount_type,
                               rec_.discount,
                               currency_rate_,
                               rec_.percentage_offset,
                               rec_.amount_offset,
                               to_rounding_,
                               use_price_incl_tax_db_,
                               rec_.price_break_template_id,
                               rec_.sales_price_type,
                               new_valid_to_date_);

                  counter_ := counter_ + 1;
               END IF;
            END LOOP;
            FOR rec_ IN get_non_time_frame_records LOOP
               new_valid_from_date_ := to_valid_from_date_;
               -- if there exists a valid timeframe record, the new record is created. Need to create a new record only otherwise.
               OPEN check_exist_inserted_rec(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, rec_.min_duration, new_valid_from_date_);
               FETCH check_exist_inserted_rec INTO exist_rec_valid_to_date_;
               CLOSE check_exist_inserted_rec;               
               IF (exist_rec_valid_to_date_ IS NULL) THEN                  
                  IF (ignore_header_rounding_) THEN
                     to_rounding_ := rec_.rounding;
                  END IF;
                  IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, new_valid_from_date_, rec_.min_duration)
                     AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
                     Copy_Line___(price_list_no_,
                                  to_price_list_no_,
                                  rec_.catalog_no,
                                  rec_.min_quantity,
                                  rec_.valid_from_date,
                                  new_valid_from_date_,
                                  rec_.min_duration,
                                  rec_.base_price_site,
                                  rec_.base_price,
                                  rec_.base_price_incl_tax,
                                  rec_.sales_price,
                                  rec_.sales_price_incl_tax,
                                  rec_.discount_type,
                                  rec_.discount,
                                  currency_rate_,
                                  rec_.percentage_offset,
                                  rec_.amount_offset,
                                  to_rounding_,
                                  use_price_incl_tax_db_,
                                  rec_.price_break_template_id,
                                  rec_.sales_price_type,
                                  NULL);
                     counter_ := counter_ + 1;
                  END IF;
               END IF;               
            END LOOP;   
         ELSE
            -- include_period_ = TRUE
            -- to_valid_from_date_ IS NULL
            FOR rec_ IN get_time_frame_records LOOP
               new_valid_from_date_ := valid_from_date_;
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, new_valid_from_date_, rec_.min_duration)
                  AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
                  Copy_Line___(price_list_no_,
                               to_price_list_no_,
                               rec_.catalog_no,
                               rec_.min_quantity,
                               rec_.valid_from_date,
                               new_valid_from_date_,
                               rec_.min_duration,
                               rec_.base_price_site,
                               rec_.base_price,
                               rec_.base_price_incl_tax,
                               rec_.sales_price,
                               rec_.sales_price_incl_tax,
                               rec_.discount_type,
                               rec_.discount,
                               currency_rate_,
                               rec_.percentage_offset,
                               rec_.amount_offset,
                               to_rounding_,
                               use_price_incl_tax_db_,
                               rec_.price_break_template_id,
                               rec_.sales_price_type,
                               rec_.valid_to_date);
                  counter_ := counter_ + 1;
               END IF;
            END LOOP;
            FOR rec_ IN get_next_records LOOP
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF (rec_.valid_from_date <= valid_from_date_) THEN
                  new_valid_from_date_ := valid_from_date_;
                  OPEN check_exist_inserted_rec(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, rec_.min_duration, rec_.valid_from_date);
                  FETCH check_exist_inserted_rec INTO exist_rec_valid_to_date_;
                  CLOSE check_exist_inserted_rec;
                  IF (exist_rec_valid_to_date_ IS NULL) THEN
                     IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, new_valid_from_date_, rec_.min_duration)
                        AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
                        Copy_Line___(price_list_no_,
                                     to_price_list_no_,
                                     rec_.catalog_no,
                                     rec_.min_quantity,
                                     rec_.valid_from_date,
                                     new_valid_from_date_,
                                     rec_.min_duration,
                                     rec_.base_price_site,
                                     rec_.base_price,
                                     rec_.base_price_incl_tax,
                                     rec_.sales_price,
                                     rec_.sales_price_incl_tax,
                                     rec_.discount_type,
                                     rec_.discount,
                                     currency_rate_,
                                     rec_.percentage_offset,
                                     rec_.amount_offset,
                                     to_rounding_,
                                     use_price_incl_tax_db_,
                                     rec_.price_break_template_id,
                                     rec_.sales_price_type,
                                     rec_.valid_to_date);
                        counter_ := counter_ + 1;
                     END IF;
                  ELSE
                     next_valid_from_date_ := exist_rec_valid_to_date_ + 1;
                     IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, new_valid_from_date_, rec_.min_duration)
                        AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN   
                        Copy_Line___(price_list_no_,
                                     to_price_list_no_,
                                     rec_.catalog_no,
                                     rec_.min_quantity,
                                     rec_.valid_from_date,
                                     next_valid_from_date_,
                                     rec_.min_duration,
                                     rec_.base_price_site,
                                     rec_.base_price,
                                     rec_.base_price_incl_tax,
                                     rec_.sales_price,
                                     rec_.sales_price_incl_tax,
                                     rec_.discount_type,
                                     rec_.discount,
                                     currency_rate_,
                                     rec_.percentage_offset,
                                     rec_.amount_offset,
                                     to_rounding_,
                                     use_price_incl_tax_db_,
                                     rec_.price_break_template_id,
                                     rec_.sales_price_type,
                                     NULL);
                        counter_ := counter_ + 1;
                     END IF;   
                  END IF;
               ELSE
                  -- copy all lines having valid_from_date > valid_from_date_
                  IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date, rec_.min_duration)
                     AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
                     Copy_Line___(price_list_no_,
                                  to_price_list_no_,
                                  rec_.catalog_no,
                                  rec_.min_quantity,
                                  rec_.valid_from_date,
                                  rec_.valid_from_date,
                                  rec_.min_duration,
                                  rec_.base_price_site,
                                  rec_.base_price,
                                  rec_.base_price_incl_tax,
                                  rec_.sales_price,
                                  rec_.sales_price_incl_tax,
                                  rec_.discount_type,
                                  rec_.discount,
                                  currency_rate_,
                                  rec_.percentage_offset,
                                  rec_.amount_offset,
                                  to_rounding_,
                                  use_price_incl_tax_db_,
                                  rec_.price_break_template_id,
                                  rec_.sales_price_type,
                                  rec_.valid_to_date);
                     counter_ := counter_ + 1;
                  END IF;
               END IF;
            END LOOP; 
         END IF;
      ELSE
         -- valid_from_date IS NOT NULL
         -- include_period_ = 'FALSE'
         IF (to_valid_from_date_ IS NULL) THEN
            -- must copy all lines after the given valid_from_date_
            FOR rec_ IN find_null_valid_to_date_recs LOOP
               IF (valid_from_date_ > rec_.valid_from_date) THEN
                  new_valid_from_date_ := valid_from_date_;
               ELSE
                  new_valid_from_date_ := rec_.valid_from_date;
               END IF;
                 
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, new_valid_from_date_, rec_.min_duration)
                  AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
                  Copy_Line___(price_list_no_,
                               to_price_list_no_,
                               rec_.catalog_no,
                               rec_.min_quantity,
                               rec_.valid_from_date,
                               new_valid_from_date_,
                               rec_.min_duration,
                               rec_.base_price_site,
                               rec_.base_price,
                               rec_.base_price_incl_tax,
                               rec_.sales_price,
                               rec_.sales_price_incl_tax,
                               rec_.discount_type,
                               rec_.discount,
                               currency_rate_,
                               rec_.percentage_offset,
                               rec_.amount_offset,
                               to_rounding_,
                               use_price_incl_tax_db_,
                               rec_.price_break_template_id,
                               rec_.sales_price_type,
                               NULL);
                  counter_ := counter_ + 1;
               END IF;
            END LOOP;
         ELSE 
            -- valid_from_date IS NOT NULL
            -- include_period_ = 'FALSE'
            -- to_valid_from_date IS NOT NULL
            FOR rec_ IN get_non_time_frame_records LOOP
               new_valid_from_date_ := to_valid_from_date_;
               IF (ignore_header_rounding_) THEN
                  to_rounding_ := rec_.rounding;
               END IF;
               IF NOT Check_Exist(to_price_list_no_, rec_.catalog_no, rec_.min_quantity, new_valid_from_date_, rec_.min_duration)
                  AND (Sales_Part_API.Get_Sales_Price_Group_Id(rec_.base_price_site, rec_.catalog_no) = sales_price_group_id_) THEN
                  Copy_Line___(price_list_no_,
                               to_price_list_no_,
                               rec_.catalog_no,
                               rec_.min_quantity,
                               rec_.valid_from_date,
                               new_valid_from_date_,
                               rec_.min_duration,
                               rec_.base_price_site,
                               rec_.base_price,
                               rec_.base_price_incl_tax,
                               rec_.sales_price,
                               rec_.sales_price_incl_tax,
                               rec_.discount_type,
                               rec_.discount,
                               currency_rate_,
                               rec_.percentage_offset,
                               rec_.amount_offset,
                               to_rounding_,
                               use_price_incl_tax_db_,
                               rec_.price_break_template_id,
                               rec_.sales_price_type,
                               NULL);
                  counter_ := counter_ + 1;
               END IF;
            END LOOP;
         END IF;
      END IF;
   END IF;
   copied_items_ := counter_;
   
END Copy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Insert_Price_Break_Lines
--   Insert part lines from price break template if use of templates is enabled.
--   Everything but the sales price, base price and min quantity is inherited.
PROCEDURE Insert_Price_Break_Lines (
   added_lines_           OUT  NUMBER,
   price_list_no_         IN   VARCHAR2,
   catalog_no_            IN   VARCHAR2,
   base_price_site_       IN   VARCHAR2,
   valid_from_date_       IN   DATE,
   discount_type_         IN   VARCHAR2,
   discount_              IN   NUMBER,
   percentage_offset_     IN   NUMBER,
   amount_offset_         IN   NUMBER,
   rounding_              IN   NUMBER,
   set_base_price_status_ IN   BOOLEAN  DEFAULT TRUE,
   sales_price_type_db_   IN   VARCHAR2 DEFAULT Sales_Price_Type_API.DB_SALES_PRICES,
   price_break_temp_id_   IN   VARCHAR2 DEFAULT NULL,
   valid_to_date_         IN   DATE DEFAULT NULL,
   from_header_           IN   BOOLEAN DEFAULT FALSE )
IS
   sales_price_               NUMBER;   
   base_price_                NUMBER;
   sales_price_incl_tax_      NUMBER;
   base_price_curr_           NUMBER;
   base_price_incl_tax_curr_  NUMBER;
   base_price_incl_tax_       NUMBER;
   currency_rate_             NUMBER;
   price_break_template_id_   VARCHAR2(10);
   sales_price_list_rec_      Sales_Price_List_API.Public_Rec;   
   
   CURSOR template_lines_for_update (template_id_ VARCHAR2) IS
      SELECT min_qty, min_duration
      FROM   price_break_template_line_tab pbtl
      WHERE  pbtl.template_id = template_id_
      AND    NOT EXISTS (SELECT 1
                         FROM  sales_price_list_part_tab splp
                         WHERE splp.price_list_no = price_list_no_
                         AND   splp.catalog_no = catalog_no_
                         AND   splp.valid_from_date = valid_from_date_
                         AND   pbtl.min_qty = splp.min_quantity
                         AND   pbtl.min_duration = splp.min_duration
                         AND   splp.sales_price_type = sales_price_type_db_);
   
BEGIN
   
   added_lines_ := 0;
   sales_price_list_rec_      := Sales_Price_List_API.Get(price_list_no_);
   
   IF(from_header_) THEN
      price_break_template_id_   := NVL(price_break_temp_id_, Sales_Part_Base_Price_API.Get_Template_Id(base_price_site_, catalog_no_, Sales_Price_Type_API.Decode(sales_price_type_db_)));
   ELSE
      price_break_template_id_   := price_break_temp_id_;
   END IF;
   
   IF (sales_price_list_rec_.use_price_break_templates  = Fnd_Boolean_API.DB_TRUE)
      AND (Sales_Part_Base_Price_API.Is_Valid_Price_Break_Templ(base_price_site_, catalog_no_, price_break_template_id_, sales_price_type_db_) = 1) THEN
      FOR rec_ IN template_lines_for_update(price_break_template_id_) LOOP
         IF (sales_price_list_rec_.use_price_incl_tax = Fnd_Boolean_API.DB_TRUE) THEN
            Sales_Part_Base_Price_API.Calculate_Base_Price_Incl_Tax(price_break_template_id_,
                                                           base_price_incl_tax_,
                                                           base_price_site_,
                                                           catalog_no_,
                                                           sales_price_type_db_,
                                                           rec_.min_qty,
                                                           sales_price_list_rec_.use_price_break_templates,
                                                           rec_.min_duration);
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(base_price_incl_tax_curr_,
                                                                   currency_rate_,
                                                                   NULL,
                                                                   base_price_site_,
                                                                   Sales_Price_List_API.Get_Currency_Code(price_list_no_),
                                                                   base_price_incl_tax_);  
         ELSE
            Sales_Part_Base_Price_API.Calculate_Base_Price(price_break_template_id_,
                                                           base_price_,
                                                           base_price_site_,
                                                           catalog_no_,
                                                           sales_price_type_db_,
                                                           rec_.min_qty,
                                                           sales_price_list_rec_.use_price_break_templates,
                                                           rec_.min_duration);
            Customer_Order_Pricing_API.Get_Sales_Price_In_Currency(base_price_curr_,
                                                                   currency_rate_,
                                                                   NULL,
                                                                   base_price_site_,
                                                                   Sales_Price_List_API.Get_Currency_Code(price_list_no_),
                                                                   base_price_);     
         END IF;
         Calculate_Sales_Prices(sales_price_, 
                                sales_price_incl_tax_, 
                                base_price_curr_, 
                                base_price_incl_tax_curr_,
                                percentage_offset_,
                                amount_offset_,
                                NVL(rounding_, sales_price_list_rec_.rounding),
                                base_price_site_,
                                catalog_no_,
                                sales_price_list_rec_.use_price_incl_tax,
                                'FORWARD',
                                 NULL,
                                 NULL);
         
         New(price_list_no_,
             catalog_no_,
             rec_.min_qty,
             valid_from_date_,
             rec_.min_duration,
             base_price_site_,
             discount_type_,
             discount_,
             base_price_curr_,
             base_price_incl_tax_curr_,
             sales_price_,
             sales_price_incl_tax_,
             percentage_offset_,
             amount_offset_,
             NVL(rounding_, sales_price_list_rec_.rounding),
             set_base_price_status_,
             price_break_template_id_,
             sales_price_type_db_,
             valid_to_date_);
         added_lines_ := added_lines_ + 1;
      END LOOP;
   END IF;
END Insert_Price_Break_Lines;



-- New
--   Creates a new record.
PROCEDURE New (
   price_list_no_         IN     VARCHAR2,
   catalog_no_            IN     VARCHAR2,
   min_quantity_          IN     NUMBER,
   valid_from_date_       IN     DATE,
   min_duration_          IN     NUMBER,
   base_price_site_       IN     VARCHAR2,
   discount_type_         IN     VARCHAR2,
   discount_              IN     NUMBER,
   base_price_            IN     NUMBER,
   base_price_incl_tax_   IN     NUMBER,
   sales_price_           IN     NUMBER,
   sales_price_incl_tax_  IN     NUMBER,
   percentage_offset_     IN     NUMBER,
   amount_offset_         IN     NUMBER,
   rounding_              IN     NUMBER,
   set_base_price_status_ IN     BOOLEAN DEFAULT TRUE,
   template_id_           IN     VARCHAR2 DEFAULT NULL,
   sales_price_type_db_   IN     VARCHAR2 DEFAULT Sales_Price_Type_API.DB_SALES_PRICES,
   valid_to_date_         IN     DATE DEFAULT NULL )
IS
   newrec_     SALES_PRICE_LIST_PART_TAB%ROWTYPE;
BEGIN
   newrec_.price_list_no := price_list_no_;
   newrec_.catalog_no := catalog_no_;
   newrec_.min_quantity := min_quantity_;
   newrec_.valid_from_date := valid_from_date_;
   newrec_.min_duration := min_duration_;
   newrec_.base_price_site := base_price_site_;
   newrec_.discount_type := discount_type_;
   newrec_.discount := discount_;
   newrec_.base_price := base_price_;
   newrec_.base_price_incl_tax := base_price_incl_tax_;   
   newrec_.sales_price := sales_price_;
   newrec_.sales_price_incl_tax := sales_price_incl_tax_;
   newrec_.percentage_offset := percentage_offset_;
   newrec_.amount_offset := amount_offset_;
   newrec_.rounding := rounding_;
   newrec_.price_break_template_id := template_id_;
   newrec_.sales_price_type := sales_price_type_db_;
   newrec_.valid_to_date := valid_to_date_;
   New___(newrec_);
   IF set_base_price_status_ THEN
      Set_Base_Price_Upd_Status___(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   END IF;
END New;


PROCEDURE Modify_Offset (
   price_list_no_        IN  VARCHAR2,
   catalog_no_           IN  VARCHAR2,
   min_quantity_         IN  NUMBER,
   valid_from_date_      IN  DATE,
   min_duration_         IN  NUMBER,
   percentage_offset_    IN  NUMBER,
   amount_offset_        IN  NUMBER,
   valid_to_date_        IN  DATE,
   sales_price_          IN  NUMBER,
   sales_price_incl_tax_ IN  NUMBER )
IS
   newrec_                SALES_PRICE_LIST_PART_TAB%ROWTYPE;
BEGIN
   newrec_ := Get_Object_By_Keys___(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   newrec_.percentage_offset := percentage_offset_;
   newrec_.amount_offset := amount_offset_;
   newrec_.sales_price := sales_price_;
   newrec_.sales_price_incl_tax := sales_price_incl_tax_;
   newrec_.valid_to_date := valid_to_date_;
   Modify___(newrec_);
END Modify_Offset;


-- Modify_Base_Price
--   Modifyes the base_price.
PROCEDURE Modify_Price_Info (
   price_list_no_           IN VARCHAR2,
   catalog_no_              IN VARCHAR2,
   min_quantity_            IN NUMBER,
   valid_from_date_         IN DATE,
   min_duration_            IN NUMBER,
   base_price_              IN NUMBER,
   base_price_incl_tax_     IN NUMBER,
   sales_price_             IN NUMBER,
   sales_price_incl_tax_    IN NUMBER,
   price_break_template_id_ IN VARCHAR2,
   valid_to_date_           IN DATE,
   percentage_offset_       IN NUMBER,
   amount_offset_           IN NUMBER )
IS
   oldrec_                  SALES_PRICE_LIST_PART_TAB%ROWTYPE;
   newrec_                  SALES_PRICE_LIST_PART_TAB%ROWTYPE;
 BEGIN
   oldrec_ := Get_Object_By_Keys___(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   newrec_ := oldrec_;
   newrec_.base_price := base_price_;
   newrec_.base_price_incl_tax := base_price_incl_tax_;
   newrec_.sales_price := sales_price_;
   newrec_.sales_price_incl_tax := sales_price_incl_tax_;
   IF price_break_template_id_ IS NOT NULL THEN
      newrec_.price_break_template_id := price_break_template_id_;
   END IF;
   newrec_.valid_to_date := valid_to_date_;
   newrec_.percentage_offset := percentage_offset_;
   newrec_.amount_offset := amount_offset_;
   Modify___(newrec_);
   IF base_price_ != oldrec_.base_price THEN
      Set_Base_Price_Upd_Status___(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   END IF;
END Modify_Price_Info;

-- Modify_Sales_Prices
--   Modify sales_price/sales_price_incl_tax.
PROCEDURE Modify_Sales_Prices (
   price_list_no_         IN     VARCHAR2,
   use_price_incl_tax_db_ IN     VARCHAR2) 
IS
   newrec_                 SALES_PRICE_LIST_PART_TAB%ROWTYPE;
   sales_price_            NUMBER;
   sales_price_incl_tax_   NUMBER;
   calc_base_              VARCHAR2(10);
   reset_sales_prices_     BOOLEAN := TRUE;
   
   CURSOR  get_data IS
      SELECT catalog_no, min_quantity, valid_from_date, min_duration
      FROM  SALES_PRICE_LIST_PART_TAB 
      WHERE price_list_no = price_list_no_;
BEGIN
   
   FOR rec_ IN get_data LOOP
      newrec_ := Get_Object_By_Keys___(price_list_no_, rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date, rec_.min_duration);
      
      IF newrec_.base_price = 0 THEN
         sales_price_          := newrec_.sales_price;
         reset_sales_prices_ := FALSE;
      END IF;
      
      IF newrec_.base_price_incl_tax = 0 THEN
         sales_price_incl_tax_ := newrec_.sales_price_incl_tax;
         reset_sales_prices_ := FALSE;
      END IF;
      
      IF use_price_incl_tax_db_ = 'TRUE' THEN
         calc_base_ := 'GROSS_BASE';
      ELSE
         calc_base_ := 'NET_BASE';
      END IF;
      Sales_Part_Base_Price_API.Calculate_Part_Prices(newrec_.base_price, 
                                                      newrec_.base_price_incl_tax, 
                                                      sales_price_, 
                                                      sales_price_incl_tax_, 
                                                      newrec_.percentage_offset, 
                                                      newrec_.amount_offset, 
                                                      newrec_.base_price_site, 
                                                      rec_.catalog_no, 
                                                      calc_base_, 
                                                      'FORWARD', 
                                                      newrec_.rounding, 
                                                      16,
                                                      reset_sales_prices_);
      newrec_.sales_price := sales_price_;
      newrec_.sales_price_incl_tax := sales_price_incl_tax_;
      Modify___(newrec_);
   END LOOP;
   
END Modify_Sales_Prices;


-- Modify_Prices_For_Tax
--   Recalculates price columns depending on the use_price_incl_tax check box.
--   Called when fee_code   is modified in Sales Part.
PROCEDURE Modify_Prices_For_Tax (
   base_price_site_ IN    VARCHAR2,
   catalog_no_      IN    VARCHAR2,
   tax_code_        IN    VARCHAR2) 
IS
   newrec_                 SALES_PRICE_LIST_PART_TAB%ROWTYPE;
   base_price_             NUMBER;
   base_price_incl_tax_    NUMBER;
   sales_price_            NUMBER;
   sales_price_incl_tax_   NUMBER;
   calc_base_              VARCHAR2(10);
   
   CURSOR  get_data IS
      SELECT l.use_price_incl_tax, l.price_list_no, lp.base_price, lp.base_price_incl_tax, lp.sales_price, lp.sales_price_incl_tax, lp.min_quantity, lp.valid_from_date, lp.min_duration
      FROM   SALES_PRICE_LIST_TAB l, SALES_PRICE_LIST_PART_TAB lp
      WHERE  l.price_list_no = lp.price_list_no
      AND    lp.base_price_site = base_price_site_
      AND    lp.catalog_no = catalog_no_;
   
BEGIN
   
   FOR rec_ IN get_data LOOP
      newrec_ := Get_Object_By_Keys___(rec_.price_list_no, catalog_no_, rec_.min_quantity, rec_.valid_from_date, rec_.min_duration);
      
      base_price_           := rec_.base_price;
      base_price_incl_tax_  := rec_.base_price_incl_tax;
      sales_price_          := rec_.sales_price;
      sales_price_incl_tax_ := rec_.sales_price_incl_tax;      
      IF (rec_.use_price_incl_tax = 'TRUE') THEN
         calc_base_ := 'GROSS_BASE';
      ELSE         
         calc_base_ := 'NET_BASE';
      END IF;      
      Sales_Part_Base_Price_API.Calculate_Part_Prices(base_price_, 
                                                      base_price_incl_tax_, 
                                                      sales_price_, 
                                                      sales_price_incl_tax_, 
                                                      0, 
                                                      0, 
                                                      base_price_site_, 
                                                      catalog_no_, 
                                                      calc_base_, 
                                                      'NO_CALC', 
                                                      newrec_.rounding, 
                                                      16);
      newrec_.base_price := base_price_;
      newrec_.base_price_incl_tax := base_price_incl_tax_;
      newrec_.sales_price := sales_price_;
      newrec_.sales_price_incl_tax := sales_price_incl_tax_;
      
      Modify___(newrec_);
   END LOOP;
   
END Modify_Prices_For_Tax;


-- Remove
--   Removes specified record.
PROCEDURE Remove (
   price_list_no_   IN     VARCHAR2,
   catalog_no_      IN     VARCHAR2,
   min_quantity_    IN     NUMBER,
   valid_from_date_ IN     DATE,
   min_duration_    IN     NUMBER)
IS
   remrec_     SALES_PRICE_LIST_PART_TAB%ROWTYPE;
   objid_      VARCHAR2(2000);
   objversion_ VARCHAR2(2000);
BEGIN
   Get_Id_Version_By_Keys___(objid_, objversion_, price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   remrec_ := Lock_By_Id___(objid_, objversion_);
   Check_Delete___(remrec_);
   Delete___(objid_, remrec_);
END Remove;


-- Check_Exist
--   Returns TRUE if the specified record exists.
@UncheckedAccess
FUNCTION Check_Exist (
   price_list_no_   IN     VARCHAR2,
   catalog_no_      IN     VARCHAR2,
   min_quantity_    IN     NUMBER,
   valid_from_date_ IN     DATE,
   min_duration_    IN     NUMBER) RETURN BOOLEAN
IS
BEGIN
   RETURN Check_Exist___(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
END Check_Exist;

PROCEDURE Modify_Valid_To_Date (
   price_list_no_      IN VARCHAR2,
   catalog_no_         IN VARCHAR2,
   min_quantity_       IN NUMBER,   
   valid_from_date_    IN DATE,
   min_duration_       IN NUMBER,
   valid_to_date_      IN DATE )
IS
   newrec_     SALES_PRICE_LIST_PART_TAB%ROWTYPE;

BEGIN
   newrec_ := Get_Object_By_Keys___(price_list_no_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
   newrec_.valid_to_date := valid_to_date_;
   Modify___(newrec_);
END Modify_Valid_To_Date;

PROCEDURE Calculate_Sales_Prices (
   sales_price_                     OUT NUMBER,
   sales_price_incl_tax_            OUT NUMBER,
   base_price_                   IN OUT NUMBER,
   base_price_incl_tax_          IN OUT NUMBER,
   percentage_offset_            IN     NUMBER,
   amount_offset_                IN     NUMBER,
   rounding_                     IN     NUMBER,
   contract_                     IN     VARCHAR2,
   catalog_no_                   IN     VARCHAR2,
   use_price_incl_tax_db_        IN     VARCHAR2,
   calc_direction_               IN     VARCHAR2,
   cpy_frm_sales_price_          IN     NUMBER,
   cpy_frm_sales_price_incl_tax_ IN     NUMBER )
IS
   calc_base_      VARCHAR2(10);
BEGIN

   IF (use_price_incl_tax_db_ = 'TRUE') THEN
      calc_base_ := 'GROSS_BASE';
   ELSE
      calc_base_ := 'NET_BASE';
   END IF;
   IF (cpy_frm_sales_price_incl_tax_ IS NOT NULL) OR (cpy_frm_sales_price_ IS NOT NULL) THEN
      sales_price_incl_tax_ := NVL(cpy_frm_sales_price_incl_tax_, 0);
      sales_price_ := NVL(cpy_frm_sales_price_, 0);
   END IF;
   Sales_Part_Base_Price_API.Calculate_Part_Prices(base_price_, 
                                                   base_price_incl_tax_, 
                                                   sales_price_, 
                                                   sales_price_incl_tax_, 
                                                   percentage_offset_, 
                                                   amount_offset_, 
                                                   contract_, 
                                                   catalog_no_, 
                                                   calc_base_, 
                                                   calc_direction_, 
                                                   rounding_, 
                                                   16);
                                                  
   
END Calculate_Sales_Prices;

-- This method was introdcued to be bound to the SQL column in the client. 
@UncheckedAccess
FUNCTION Calc_Net_And_Gross_Price (
   discount_               IN NUMBER   ,
   sales_price_            IN NUMBER   ,
   sales_price_incl_tax_   IN NUMBER   ,
   contract_               IN VARCHAR2 ,
   price_list_no_          IN VARCHAR2 ,
   catalog_no_             IN VARCHAR2 ,
   rounding_               IN NUMBER   ,
   return_type_            IN VARCHAR2 ) RETURN NUMBER
IS
   net_sales_price_           NUMBER;
   gross_sales_price_         NUMBER; 
   use_price_including_tax_   VARCHAR2(5);
   tax_calc_base_             VARCHAR2(20);
BEGIN
	use_price_including_tax_ := Sales_Price_List_API.Get_Use_Price_Incl_Tax_Db(price_list_no_); 
   
   IF(use_price_including_tax_ = 'TRUE') THEN 
      gross_sales_price_ := sales_price_incl_tax_ * (1- discount_/100);
      tax_calc_base_     := 'GROSS_BASE';
   ELSE 
      net_sales_price_   := sales_price_ * (1- discount_/100); 
      tax_calc_base_     := 'NET_BASE'; 
   END IF ;
   Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(net_sales_price_,
                                                        gross_sales_price_,
                                                        contract_,
                                                        catalog_no_,
                                                        tax_calc_base_,
                                                        rounding_);
   IF (return_type_ = 'NET') THEN 
      RETURN net_sales_price_;
   ELSE 
      RETURN gross_sales_price_;
   END IF;
END Calc_Net_And_Gross_Price;

PROCEDURE Round_Base_And_Sales_Prices (
   price_list_no_      IN VARCHAR2,
   rounding_           IN NUMBER,
   direction_          IN VARCHAR2)   
IS
   CURSOR get_sales_price_list_part IS
      SELECT price_list_no, catalog_no, min_quantity, valid_from_date, min_duration, 
             base_price, base_price_incl_tax, sales_price, sales_price_incl_tax,
             amount_offset, percentage_offset, base_price_site
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_;
      
   oldrec_                SALES_PRICE_LIST_PART_TAB%ROWTYPE;
   newrec_                SALES_PRICE_LIST_PART_TAB%ROWTYPE;
   objid_                 VARCHAR2(2000);
   objversion_            VARCHAR2(2000);
   attr_                  VARCHAR2(2000);
   indrec_                Indicator_Rec;
   use_price_incl_tax_db_ BOOLEAN := (Sales_Price_List_API.Get_Use_Price_Incl_Tax_Db(price_list_no_) = 'TRUE');
   sales_price_           NUMBER;
   sales_price_incl_tax_  NUMBER;
   base_price_            NUMBER;
   base_price_incl_tax_   NUMBER;   
   tax_calc_base_         VARCHAR2(20);
   sales_part_rec_        Sales_Part_API.Public_Rec;
   calculate_prices_      BOOLEAN := TRUE;
   offset_direction_      VARCHAR2(20);
   temp_sales_price_      NUMBER;
   temp_sales_price_incl_tax_ NUMBER;
BEGIN
   IF (price_list_no_ IS NOT NULL) THEN
      FOR rec_ IN  get_sales_price_list_part LOOP
         newrec_ := Get_Object_By_Keys___(rec_.price_list_no, rec_.catalog_no, rec_.min_quantity, rec_.valid_from_date, rec_.min_duration);
         
         -- Calculate and round sales prices
         IF (use_price_incl_tax_db_) THEN
            tax_calc_base_ := 'GROSS_BASE';
            IF newrec_.rounding != rounding_ AND rec_.base_price_incl_tax = 0 THEN
               temp_sales_price_incl_tax_ := newrec_.sales_price_incl_tax;
            ELSE
               temp_sales_price_incl_tax_ := rec_.base_price_incl_tax + rec_.amount_offset + (rec_.base_price_incl_tax * rec_.percentage_offset/100);
            END IF;
            sales_price_incl_tax_ := ROUND(NVL(temp_sales_price_incl_tax_, 0), NVL(rounding_, 20)) ;      
         ELSE               
            tax_calc_base_ := 'NET_BASE';
            IF newrec_.rounding != rounding_ AND rec_.base_price = 0 THEN
               temp_sales_price_ := newrec_.sales_price;
            ELSE
               temp_sales_price_ := rec_.base_price + rec_.amount_offset + (rec_.base_price * rec_.percentage_offset/100);
            END IF;
            sales_price_ :=  ROUND(NVL(temp_sales_price_, 0), NVL(rounding_, 20));
         END IF;
         
         --Calculate prices
         base_price_ := rec_.base_price;
         base_price_incl_tax_ := rec_.base_price_incl_tax;
         sales_part_rec_ := Sales_Part_API.Get(rec_.base_price_site, rec_.catalog_no);
         IF (use_price_incl_tax_db_) THEN
             IF ((sales_part_rec_.taxable = 'FALSE') OR (sales_part_rec_.tax_code IS NULL)) THEN
                 base_price_ := rec_.base_price_incl_tax;
                 sales_price_ := sales_price_incl_tax_;
                 calculate_prices_ := FALSE;
             END IF;
         ELSE
            IF ((sales_part_rec_.taxable = 'FALSE') OR (sales_part_rec_.tax_code IS NULL)) THEN
                 base_price_incl_tax_ := rec_.base_price;
                 sales_price_incl_tax_ := sales_price_;
                 calculate_prices_ := FALSE;
            END IF;
         END IF;
         
         IF (calculate_prices_) THEN
            offset_direction_ := direction_;
            -- If the rounding value is specified in colnRounding the SalesPrice/SalesPriceInclTax calculated early should remain.
            IF ((rounding_ IS NOT NULL) AND (offset_direction_ != 'NO_CALC')) THEN
                offset_direction_:= 'NO_CALC';
            END IF;
        
            Sales_Part_Base_Price_API.Calculate_Part_Prices(base_price_, 
                                                            base_price_incl_tax_, 
                                                            sales_price_, 
                                                            sales_price_incl_tax_, 
                                                            rec_.percentage_offset, 
                                                            rec_.amount_offset,
                                                            rec_.base_price_site,
                                                            rec_.catalog_no, 
                                                            tax_calc_base_,                                                                                       
                                                            offset_direction_,
                                                            rounding_,
                                                            20); 
         END IF;
              
         newrec_.base_price := base_price_;
         newrec_.base_price_incl_tax := base_price_incl_tax_;
         newrec_.sales_price := sales_price_;
         newrec_.sales_price_incl_tax := sales_price_incl_tax_;
         newrec_.rounding := rounding_;
         Modify___(newrec_);                            
      END LOOP;
   END IF;
END Round_Base_And_Sales_Prices;

PROCEDURE Calc_And_Round_Sales_Prices (
   sales_price_                  IN OUT NUMBER,
   sales_price_incl_tax_         IN OUT NUMBER,
   base_price_                   IN     NUMBER,
   base_price_incl_tax_          IN     NUMBER,
   percentage_offset_            IN     NUMBER,
   amount_offset_                IN     NUMBER,
   rounding_                     IN     NUMBER,
   use_price_incl_tax_db_        IN     VARCHAR2,
   ifs_curr_rounding_            IN     NUMBER,
   reset_sales_price_            IN     BOOLEAN DEFAULT TRUE)
IS
   tmp_sales_price_incl_tax_    NUMBER;
   tmp_sales_price_             NUMBER;
BEGIN
   -- Calculate and round sales prices
   IF (use_price_incl_tax_db_ = 'TRUE') THEN
      IF reset_sales_price_ THEN     
         tmp_sales_price_incl_tax_ := NVL((base_price_incl_tax_ + amount_offset_ + (base_price_incl_tax_ * percentage_offset_/100)), 0);        
      ELSE
         tmp_sales_price_incl_tax_ := sales_price_incl_tax_;         
      END IF;     
      
      IF tmp_sales_price_incl_tax_ < 0 THEN
         tmp_sales_price_incl_tax_ := 0;
      END IF;
      
      sales_price_incl_tax_ := ROUND(tmp_sales_price_incl_tax_, NVL(rounding_, NVL(ifs_curr_rounding_,20)));      
   ELSE
      IF reset_sales_price_ THEN         
         tmp_sales_price_ := NVL((base_price_ + amount_offset_ + (base_price_ * percentage_offset_/100)), 0);      
      ELSE
         tmp_sales_price_ := sales_price_;         
      END IF;
      IF tmp_sales_price_ < 0 THEN
         tmp_sales_price_ := 0;
      END IF;
      sales_price_ :=  ROUND(tmp_sales_price_, NVL(rounding_, NVL(ifs_curr_rounding_,20))); 
   END IF;
END Calc_And_Round_Sales_Prices;

PROCEDURE Calculate_Prices (
   sales_price_                  IN OUT NUMBER,
   sales_price_incl_tax_         IN OUT NUMBER,
   base_price_                   IN OUT NUMBER,
   base_price_incl_tax_          IN OUT NUMBER,
   percentage_offset_            IN     NUMBER,
   amount_offset_                IN     NUMBER,
   rounding_                     IN     NUMBER,
   contract_                     IN     VARCHAR2,
   catalog_no_                   IN     VARCHAR2,
   use_price_incl_tax_db_        IN     VARCHAR2,
   direction_                    IN     VARCHAR2,
   ifs_curr_rounding_            IN     NUMBER)
IS
   calc_base_             VARCHAR2(10);
   calc_prices_           BOOLEAN := TRUE;
   sales_part_rec_        Sales_Part_API.Public_Rec;
   calc_direction_        VARCHAR2(20);
   
BEGIN
   sales_part_rec_ := Sales_Part_API.Get(contract_, catalog_no_);
   IF (use_price_incl_tax_db_ = 'TRUE') THEN
      calc_base_ := 'GROSS_BASE';
      IF (((base_price_incl_tax_ IS NULL) AND (sales_price_incl_tax_ IS NULL)) OR (sales_part_rec_.taxable = 'FALSE') OR (sales_part_rec_.tax_code IS NULL)) THEN
         base_price_ := base_price_incl_tax_;
         sales_price_ := sales_price_incl_tax_;
         calc_prices_ := FALSE;
      END IF;
   ELSE
      calc_base_ := 'NET_BASE';
      IF (((base_price_ IS NULL) AND (sales_price_ IS NULL)) OR (sales_part_rec_.taxable = 'FALSE') OR (sales_part_rec_.tax_code IS NULL)) THEN
         base_price_incl_tax_ := base_price_;
         sales_price_incl_tax_ := sales_price_;
         calc_prices_ := FALSE;
      END IF;
   END IF;
   
   IF (calc_prices_) THEN 
      calc_direction_ := direction_;
      IF (rounding_ IS NOT NULL) AND (calc_direction_ != 'NO_CALC') THEN
         calc_direction_ := 'NO_CALC';
      END IF;

      Sales_Part_Base_Price_API.Calculate_Part_Prices(base_price_, 
                                                      base_price_incl_tax_, 
                                                      sales_price_, 
                                                      sales_price_incl_tax_, 
                                                      percentage_offset_, 
                                                      amount_offset_, 
                                                      contract_, 
                                                      catalog_no_, 
                                                      calc_base_, 
                                                      calc_direction_, 
                                                      rounding_, 
                                                      NVL(ifs_curr_rounding_,20));
   END IF;                                               
   
END Calculate_Prices;

PROCEDURE Calc_Net_Gross_Sales_Prices (
   net_sales_price_        IN OUT NUMBER,
   gross_sales_price_      IN OUT NUMBER,
   discount_               IN NUMBER,
   sales_price_            IN NUMBER,
   sales_price_incl_tax_   IN NUMBER,
   contract_               IN VARCHAR2,
   catalog_no_             IN VARCHAR2,
   use_price_incl_tax_db_  IN VARCHAR2,
   rounding_               IN NUMBER,
   ifs_curr_rounding_      IN NUMBER)
IS
   tax_calc_base_    VARCHAR2(20);
   discount_tmp_     NUMBER := NVL(discount_,0);
BEGIN   
   IF(use_price_incl_tax_db_ = 'TRUE') THEN 
      gross_sales_price_ := sales_price_incl_tax_ * (1- discount_tmp_/100);
      tax_calc_base_     := 'GROSS_BASE';
   ELSE 
      net_sales_price_   := sales_price_ * (1- discount_tmp_/100); 
      tax_calc_base_     := 'NET_BASE'; 
   END IF ;
   
   Tax_Handling_Order_Util_API.Calc_Price_Source_Prices(net_sales_price_,
                                                        gross_sales_price_,
                                                        contract_,
                                                        catalog_no_,
                                                        tax_calc_base_,
                                                        NVL(rounding_, NVL(ifs_curr_rounding_, 20)));
                                                        

END Calc_Net_Gross_Sales_Prices;

@UncheckedAccess
FUNCTION Calculate_Price_and_Cost(
   sales_price_                 IN NUMBER,
   sales_price_incl_tax_        IN NUMBER,
   base_price_                  IN NUMBER,
   base_price_incl_tax_         IN NUMBER,
   percentage_offset_           IN NUMBER,
   amount_offset_               IN NUMBER,   
   discount_                    IN NUMBER,
   rounding_                    IN NUMBER,
   base_price_site_             IN VARCHAR2,
   valid_from_date_             IN DATE,
   catalog_no_                  IN VARCHAR2,
   min_quantity_                IN NUMBER,
   min_duration_                IN NUMBER,
   price_list_no_               IN VARCHAR2 ) RETURN Price_and_Cost_Arr PIPELINED
IS
   rec_                     Price_and_Cost_Rec;
   -- TODO ifs_curr_rounding_
   ifs_curr_rounding_       NUMBER := 2;
   temp_sales_price_            NUMBER;
   temp_sales_price_incl_tax_   NUMBER;
BEGIN
   rec_.use_inventory_value_db  := 'FALSE';
   temp_sales_price_            := sales_price_;
   temp_sales_price_incl_tax_   := sales_price_incl_tax_;
   rec_.use_price_incl_tax_db   := Sales_Price_List_API.Get_Use_Price_Incl_Tax_Db(price_list_no_);
   rec_.price_list_editable     := Sales_Price_List_API.Get_Editable(price_list_no_); 
   
   rec_.configurable_db := Part_Catalog_API.Get_Configurable_Db(NVL(Sales_Part_API.Get_Part_No(base_price_site_, catalog_no_),catalog_no_));
      
   Calc_And_Round_Sales_Prices (temp_sales_price_, temp_sales_price_incl_tax_, base_price_, 
                                base_price_incl_tax_, percentage_offset_, amount_offset_, 
                                rounding_, rec_.use_price_incl_tax_db, ifs_curr_rounding_);
   
   rec_.calculated_sales_price := temp_sales_price_;
   
   Calc_Net_Gross_Sales_Prices (rec_.net_sales_price , rec_.gross_sales_price, discount_,
                                sales_price_, sales_price_incl_tax_, base_price_site_,
                                catalog_no_, rec_.use_price_incl_tax_db, rounding_,
                                ifs_curr_rounding_);
   
   Customer_Order_Pricing_API.Calc_Sales_Price_List_Cost__(rec_.cost, rec_.use_inventory_value_db ,rec_.cost_set,
                                                           base_price_site_, valid_from_date_, catalog_no_, 
                                                           min_quantity_, 'ALL', price_list_no_);
                                                           
   rec_.contribution_margin := Get_Contribution_Margin__(price_list_no_, base_price_site_, catalog_no_, min_quantity_, valid_from_date_, min_duration_);
                                                           
   PIPE ROW (rec_);
END Calculate_Price_and_Cost;
   
