-----------------------------------------------------------------------------
--
--  Logical unit: CustomerPricelist
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  150813  Wahelk   BLU-1192, Modified Copy_Customer method by adding new parameter copy_info_ including overwrite_order_data_, modified deprecated Copy_Customer
--  150706  JeeJlk Bug 123400, Modified Copy_Customer to overwrite price list based on overwrite order data option. Added depricated method Copy_Customer.
--  141121  MaIklk EAP-776, Added custom check for cust ord customer exist check since prospect should be handled.
--  140225  SudJlk Bug 111497, Modified Copy_Customer by selecting records allowed for owning company only to be copied to avoid  
--  140225         unauthorized access to sales price list error. Modified Check_Delete___ to check if records are allowed to be deleted.
--  101110  ShKolk Removed attribute company.
--  101104  RaKalk Restricted Unauthorized access to sales price list
--  100519  KRPELK Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  091009  MiKulk Modified the method Copy_Customer to send the correct Company.
--  090901  MaJalk Changed VIEW_ENT to select data for user allowed company.
--  090828  MaJalk At method Update___, set company as a key when updating as a preferred price list.
--  090818  MaJalk Added attribute company.
--  060418  MaJalk Enlarge Identity - Changed view comments.
--  --------------------------------- 13.4.0 ----------------------------------
--  060110  CsAmlk Changed the SELECT &OBJID statement to the RETURNING &OBJID after INSERT INTO.
--  050907  JaBalk Removed SUBSTRB in view VIEW_ENT.
--  050802  KiSalk Bug 51603, In CUSTOMER_PRICELIST's view comments reference
--  050802         of customer_no to CustOrdCustomer, changed to 'CASCADE'.
--  ----------------TouchDown Merge End--------------------------------------
--  040106 GaJalk Added the function Get_Preferred_Price_List.
--  040105 HeWelk Changed Update___,Restricted the user to define only single PREFERRED_PRICE_LIST.
--  040105 HeWelk Changed Insert___ , set initial value for field PREFERRED_PRICE_LIST.
--  040102 Hewelk Added field 'preferred_price_list' to base and ENT views.
--  ----------------TouchDown Merge Begin------------------------------------
--  020102  JICE  Added public view for Sales Configurator export.
--  000419  PaLj  Corrected Init_Method Errors
--  --------------- 12.0 ----------------------------------------------------
--  991111  PaLj  Added Method Copy_Customer
--  990409  JakH  New template.
--  990316  RaKu  Added currency-check in Unpack_Check_Insert___/Update___.
--  990315  RaKu  Added currency_code in LU.
--  981202  JoEd  Changed use of Enterprise columns customer id.
--  981105  RaKu  Added checks in Unpack_Check_Insert___.
--  981022  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT CUSTOMER_PRICELIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.preferred_price_list:= 'NOTPREFERRED';
   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUSTOMER_PRICELIST_TAB%ROWTYPE,
   newrec_     IN OUT CUSTOMER_PRICELIST_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN

   IF (newrec_.preferred_price_list = 'PREFERRED') THEN
      UPDATE customer_pricelist_tab
         SET preferred_price_list = 'NOTPREFERRED',
             rowversion = SYSDATE
         WHERE customer_no = newrec_.customer_no AND
               sales_price_group_id = newrec_.sales_price_group_id;
      END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN CUSTOMER_PRICELIST_TAB%ROWTYPE )
IS
BEGIN
   Sales_Price_List_API.Check_Readable(remrec_.price_list_no);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT customer_pricelist_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF(Client_SYS.Item_Exist('CUSTOMER_ID', attr_)) THEN
      newrec_.customer_no := Client_SYS.Get_Item_Value('CUSTOMER_ID', attr_);
      Cust_Ord_Customer_API.Exist(newrec_.customer_no, Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no));
   END IF;
   super(newrec_, indrec_, attr_);

   IF (newrec_.sales_price_group_id != Sales_Price_List_API.Get_Sales_Price_Group_Id(newrec_.price_list_no)) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PRICE_GROUP: Price group :P1 does not match the price group on price list :P2', newrec_.sales_price_group_id, newrec_.price_list_no);
   END IF;

   IF (newrec_.currency_code != Sales_Price_List_API.Get_Currency_Code(newrec_.price_list_no)) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_CURRENCY: Currency :P1 does not match the currency on price list :P2', newrec_.currency_code, newrec_.price_list_no);
   END IF;

   Sales_Price_List_API.Check_Readable(newrec_.price_list_no);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     customer_pricelist_tab%ROWTYPE,
   newrec_ IN OUT customer_pricelist_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   IF(Client_SYS.Item_Exist('CUSTOMER_ID', attr_)) THEN
      Error_SYS.Item_Update(lu_name_, 'CUSTOMER_ID');
   END IF;
   super(oldrec_, newrec_, indrec_, attr_);
   
   IF (newrec_.sales_price_group_id != Sales_Price_List_API.Get_Sales_Price_Group_Id(newrec_.price_list_no)) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PRICE_GROUP: Price group :P1 does not match the price group on price list :P2', newrec_.sales_price_group_id, newrec_.price_list_no);
   END IF;

   IF (newrec_.currency_code != Sales_Price_List_API.Get_Currency_Code(newrec_.price_list_no)) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_CURRENCY: Currency :P1 does not match the currency on price list :P2', newrec_.currency_code, newrec_.price_list_no);
   END IF;

   Sales_Price_List_API.Check_Readable(newrec_.price_list_no);
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

   
PROCEDURE Check_Customer_No_Ref___ (
   newrec_ IN OUT NOCOPY customer_pricelist_tab%ROWTYPE )
IS
   customer_category_         customer_info_tab.customer_category%TYPE;
BEGIN
   IF (newrec_.customer_no IS NOT NULL) THEN
      customer_category_  := Customer_Info_API.Get_Customer_Category_Db(newrec_.customer_no);     
      Cust_Ord_Customer_API.Exist(newrec_.customer_no, customer_category_);     
   END IF;
END Check_Customer_No_Ref___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

@Deprecated
PROCEDURE Copy_Customer (
   customer_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2)
IS 
   copy_info_   Customer_Info_API.Copy_Param_Info; 
BEGIN
   copy_info_.overwrite_order_data := 'FALSE';
   Copy_Customer (customer_id_, new_id_ , copy_info_);
END Copy_Customer;

-- Copy_Customer
--   Copies the customer information in Customer_Pricelist_Tab to
--   a new customer id
PROCEDURE Copy_Customer (
   customer_id_ IN VARCHAR2,
   new_id_      IN VARCHAR2,
   copy_info_   IN  Customer_Info_API.Copy_Param_Info)
IS
   readable_   VARCHAR2(20) := 'FALSE';
   newrec_ CUSTOMER_PRICELIST_TAB%ROWTYPE;
   oldrec_ CUSTOMER_PRICELIST_TAB%ROWTYPE;
   
   CURSOR get_attr IS
      SELECT *
      FROM CUSTOMER_PRICELIST_TAB cpt
      WHERE cpt.customer_no = customer_id_;
BEGIN
   Trace_SYS.message('CUSTOMER_PRICELIST_API.Copy_Customer('||customer_id_||')');
      
   FOR rec_ IN get_attr LOOP
      readable_ := Sales_Price_list_API.Get_Readable(rec_.price_list_no); 
      IF (Check_Exist___(new_id_, rec_.sales_price_group_id, rec_.currency_code)) THEN
         IF (copy_info_.overwrite_order_data = 'TRUE') THEN
            oldrec_ := Lock_By_Keys___(new_id_, rec_.sales_price_group_id, rec_.currency_code);   
            newrec_ := oldrec_;
            newrec_.price_list_no := rec_.price_list_no;
            Modify___(newrec_);  
         END IF;
      ELSE 
         IF readable_ = 'TRUE' THEN
            newrec_ := NULL;
            newrec_.customer_no := new_id_;
            newrec_.sales_price_group_id := rec_.sales_price_group_id;
            newrec_.currency_code := rec_.currency_code;
            newrec_.price_list_no := rec_.price_list_no;
            New___(newrec_);
         END IF;  
      END IF;
   END LOOP;        
END Copy_Customer;


-- Get_Preferred_Price_List
--   Returns the preferred price list for a particular customer and
--   a sales price group.
@UncheckedAccess
FUNCTION Get_Preferred_Price_List (
   customer_no_          IN VARCHAR2,
   sales_price_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUSTOMER_PRICELIST_TAB.price_list_no%TYPE;
   
   CURSOR get_attr IS
      SELECT price_list_no
      FROM CUSTOMER_PRICELIST_TAB
      WHERE customer_no = customer_no_
      AND   sales_price_group_id = sales_price_group_id_
      AND   preferred_price_list = 'PREFERRED';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Preferred_Price_List;



