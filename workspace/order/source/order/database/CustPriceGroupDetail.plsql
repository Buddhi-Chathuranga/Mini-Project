-----------------------------------------------------------------------------
--
--  Logical unit: CustPriceGroupDetail
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  120402  MaRalk  Replaced Error_SYS.Record_Exist with Error_SYS.Record_General in order to avoid the error message 
--  120402          'The Cust Price Group Detail object already exists.'
--  101222  ShKolk  Removed CASCADE from cust_price_group_id.
--  101110  ShKolk  Removed attribute company.
--  100519  KRPELK  Merge Rose Method Documentation.
--  ------------------------------- Eagle ----------------------------------
--  090902 MaJalk Corrected view comments at VIEW.
--  090828 MaJalk At method Update___, set company as a key value when setting as a preferred price list.
--  090818 MaJalk Added attribute company.
--  060111  MaHplk  Replace 'SELECT &OBJID INTO....' statement with RETURNING &OBJID INTO objid_.
--  ----------------TouchDown merge End--------------------------------------
--  040108 GaJalk Added the function Get_Preferred_Price_List.
--  040106 HeWelk Changed Update___,Restricted the user to define only single PREFERRED_PRICE_LIST.
--  040106 HeWelk Changed Insert___ , set initial value for field PREFERRED_PRICE_LIST.
--  040105 Hewelk Added field 'preferred_price_list' to base view.
--  ----------------TouchDown Merge Begin------------------------------------
--  020102  JICE  Added public view for Sales Configurator export.
--  990420  RaKu  Replaces several Get-methods with a single Get.
--  990409  JakH  New template.
--  990316  RaKu  Added currency-check in Unpack_Check_Insert___/Update___.
--  990315  RaKu  Added currency_code in LU.
--  981117  RaKu  Added checks in Unpack_Check_Insert___/Update___.
--  981021  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------
@Override
PROCEDURE Raise_Record_Exist___ (
   rec_ cust_price_group_detail_tab%ROWTYPE )
IS
BEGIN
   --Add pre-processing code here
   Error_SYS.Record_General(lu_name_, 'ALREADYEXIST: The Sales Price Group object already exists.');      
   super(rec_);
   --Add post-processing code here
END Raise_Record_Exist___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT cust_price_group_detail_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN
   newrec_.preferred_price_list:= 'NOTPREFERRED';
   super(objid_, objversion_, newrec_, attr_);
   --Add post-processing code here
END Insert___;


@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     CUST_PRICE_GROUP_DETAIL_TAB%ROWTYPE,
   newrec_     IN OUT CUST_PRICE_GROUP_DETAIL_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )
IS
BEGIN
   IF (newrec_.preferred_price_list='PREFERRED')  THEN
      UPDATE CUST_PRICE_GROUP_DETAIL_TAB
         SET preferred_price_list = 'NOTPREFERRED',
             rowversion = SYSDATE
         WHERE cust_price_group_id = newrec_.cust_price_group_id AND
               sales_price_group_id = newrec_.sales_price_group_id ;
   END IF;

   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Update___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT cust_price_group_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   price_list_rec_ Sales_Price_List_API.Public_Rec;
BEGIN
   super(newrec_, indrec_, attr_);

   price_list_rec_ := Sales_Price_List_API.Get(newrec_.price_list_no);

   IF (newrec_.sales_price_group_id != price_list_rec_.sales_price_group_id) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PRICE_GROUP: Price group :P1 does not match the price group on price list :P2', newrec_.sales_price_group_id, newrec_.price_list_no);
   END IF;

   IF (newrec_.currency_code != price_list_rec_.currency_code) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_CURRENCY: Currency :P1 does not match the currency on price list :P2', newrec_.currency_code, newrec_.price_list_no);
   END IF;

   Sales_Price_List_API.Check_Readable(newrec_.price_list_no);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     cust_price_group_detail_tab%ROWTYPE,
   newrec_ IN OUT cust_price_group_detail_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
   price_list_rec_ Sales_Price_List_API.Public_Rec;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   price_list_rec_ := Sales_Price_List_API.Get(newrec_.price_list_no);

   IF (newrec_.sales_price_group_id != price_list_rec_.sales_price_group_id) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_PRICE_GROUP: Price group :P1 does not match the price group on price list :P2', newrec_.sales_price_group_id, newrec_.price_list_no);
   END IF;

   IF (newrec_.currency_code != price_list_rec_.currency_code) THEN
      Error_SYS.Record_General(lu_name_, 'WRONG_CURRENCY: Currency :P1 does not match the currency on price list :P2', newrec_.currency_code, newrec_.price_list_no);
   END IF;

   Sales_Price_List_API.Check_Readable(newrec_.price_list_no);

EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Preferred_Price_List
--   Returns the preffered price list number for a particular customer
--   price group and sales price group.
@UncheckedAccess
FUNCTION Get_Preferred_Price_List (
   cust_price_group_id_  IN VARCHAR2,
   sales_price_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ CUST_PRICE_GROUP_DETAIL_TAB.price_list_no%TYPE;
   CURSOR get_attr IS
      SELECT price_list_no
      FROM CUST_PRICE_GROUP_DETAIL_TAB
      WHERE cust_price_group_id = cust_price_group_id_
      AND   sales_price_group_id = sales_price_group_id_
      AND   preferred_price_list = 'PREFERRED';
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Preferred_Price_List;



