-----------------------------------------------------------------------------
--
--  Logical unit: PriceQuery
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign     History
--  ------  ------   ---------------------------------------------------------
--  191126  Rulilk   Bug 150738(SCZ-7628), Revert the corrections done in 150716.
--  191114  Thkrlk   Bug 150738(SCZ-7628), Moved (newrec_.source IS NULL) AND (newrec_.sale_unit_price IS NULL) condition from Check_Insert___() to Check_Before_insert() method.
--  191105  DhAplk   Bug 150716(SCZ-7604), Added validation to check customer expiration in Get_Customer_Defaults__ method.
--  170824  ShPrlk   Bug 136668, Modified Create_New_Discount_Lines___ and Modify_Discount_Lines___  to adjust parameters for the method call Sales_Price_List_API.Get_Valid_Price_List.
--  160907  SudJlk   STRSC-3927, Modified Get_Customer_Defaults__ to pass the new parameter value to Customer_Agreement_API.Get_First_Valid_Agreement.
--  160114  AyAmlk   Bug 126687, Modified Check_Update___() by reversing part of the correction done from bug 121100 so that the price source details will be updated correctly.
--  150515  RuLiLk   Merged bug 121100, Added new method Fetch_Price_Query_Data__ to get price query data and round the prices using the given rounding value.
--  150515           Modified method Unpack_Check_Insert___() to check if values are already sent for sale_unit_price 
--  150515           to avoid replacing of rounded sale_unit_price sent from client when price query is manually inserted or updated.
--  141128  SBalLK   PRSC-3709, Modified Calc_Price_Effectivity_Date___() method to fetch delivery terms and delivery terms location from supply chain matrix.
--  140410  RoJalk   Modified Create_Pq_For_Source__ to assign value for oldrec_.
--  130521  HimRlk   Passed NULL for vendor_no in method call Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  121211  JeeJlk   Added new column use price incl tax.
--  120911  MeAblk   Added ship_inventory_location_no_ as a parameter to methods Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120824  MeAblk   Added parameter shipment_type_ in method Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120706  MaHplk   Added parameter pickig_leadtime in method Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120702  MaMalk   Added parameters route and forwarder in method Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  120127  ChJalk   Modified view comments of the base view to put ENUMERATE correctly. 
--  111206  NaLrlk   Added public atribute price_source_net_price.
--  111017  MaRalk   Modified methods Create_New_Discount_Lines___, Modify_Discount_Lines___ by Adjusting the parameters 
--  111017           for the method calls in Sales_Price_List_API and Customer_Order_Pricing_API packages.
--  110706  ChJalk   Added User_Allowed_Site filter to the view PRICE_QUERY.
--  110404  RiLase   Added /CASCADE to agreement id view comment on base view.
--  110330  AndDse   BP-4760, Modified Calc_Price_Effectivity_Date___ due to changes in Cust_Ord_Date_Calculation.
--  110203  AndDse   BP-3776, Modified Calc_Price_Effectivity_Date___, introduced external transport calendar in call to Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults.
--  110131  Nekolk   EANE-3744  added where clause to View PRICE_QUERY_PER_USER
--  100716  NaLrlk   Modified Get_Price_Source_Node_Id__ to add hierarchy price group and customer price group to both CAMPAIGN PART and CAMPAIGN ASSORTMENT.
--  100121  KiSalk   Modified Get_Price_Source_Node_Id to set node_id according to customer_level for price source 'CAMPAIGN'.
--  091005  DaZase   Renamed column base_net_price_incl_acc_disc to base_net_price_incl_ac_dsc due to new requirements from the 
--  091005           developer studio tool (max 26 characters in name so there is space for "Get_" if the attribute is changed to public in the future).
--  091002  DaZase   Added length on view comments for source_ref1, source_ref2 and source_ref3.
--  090827  RiLase   Removed Agreement Excl From Auto-pricing as source.
--  090624  KiSalk   Changed Get_Price_Source_Node_Id__ to use Assortment Node Based price list lines.
--  090624  KiSalk   Changed call Customer_Order_Pricing_API.Get_Valid_Price_List to Sales_Price_List_API.Get_Valid_Price_List.
--  090504  NaLrlk   Added method Get_Customer_Defaults__ and Calc_Price_Effectivity_Date___.
--  090420  DaZase   Added methods Create_New_Discount_Lines___/Modify_Discount_Lines___. Changes in
--  090420           Create_Pq_For_Source__, New__ and Modify to handle that we now save the discount lines
--  0904020          before we do the PQ calculations and then update the PQ record with the calculated values.
--  090330  NaLrlk   Added method Get_Price_Source_Node_Id__.
--  090327  NaLrlk   Rename the method Get_Price_Query_For_Source__ as Create_Pq_For_Source__.
--  090326  DaZase   Added call to Customer_Order_Pricing_API.Get_Old_Price_Query_Price_Info in Fetch_Price_Query_Data___.
--  090319  NaLrlk   Added source, source ref fields and method Get_Price_Query_For_Source__.
--  090317  NaLrlk   Added fields and get methods. Modified the method Get. Removed method Check_Price_Query___.
--  090317  NaLrlk   Added methods Check_Before_Insert___, Fetch_Price_Query_Data___ and Check_Before_Update___.
--  090220  DaZase   Added call to Customer_Order_Pricing_API.New_Default_Pq_Discount_Rec in Insert___ and
--  090220           call to Customer_Order_Pricing_API.Modify_Default_Pq_Discount_Rec in Update____.
--  090218           Made all attributes public, added new public get methods.
--  090205  RILASE   Added view PRICE_QUERY_PER_USER for fnd_user filtering.
--                   Added Clean_Price_Query__() and Check_Price_Query___().
--  090202  RILASE   Added site date as default price effective date in Prepare_Insert___.
--  090122  RILASE   Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Check_Before_Insert___ (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE )
IS
   sales_part_rec_  Sales_Part_API.Public_Rec;
BEGIN

   newrec_.creator := Fnd_Session_API.Get_Fnd_User;
   -- Check that site is user allowed
   IF (newrec_.contract IS NOT NULL) THEN
      User_Allowed_Site_API.Exist(newrec_.creator, newrec_.contract);
   END IF;

   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);
   -- Additional discount validation...
   IF (newrec_.additional_discount < 0) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDADDDISCOUNT1: Additional discount % should be greater than 0.');
   ELSIF NOT (newrec_.additional_discount <= 100) THEN
      Error_SYS.Record_General(lu_name_, 'INVALIDADDDISCOUNT2: Additional discount should not exceed 100 %.');
   END IF;
   IF (newrec_.additional_discount IS NULL) THEN
       newrec_.additional_discount := 0;
   END IF;

   -- Sales quantity validation...
   IF (newrec_.sales_qty <= 0) THEN
      Error_SYS.Record_General(lu_name_, 'QTY_LESS_THAN_ZERO: Quantity must be greater than zero!');
   END IF;

   -- Condition code validation...
   IF (newrec_.condition_code IS NOT NULL) THEN
      IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(sales_part_rec_.part_no) = 'NOT_ALLOW_COND_CODE') THEN
         Error_SYS.Record_General(lu_name_,'NOTALLOWCOND: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
      ELSE
         Condition_Code_API.Exist(newrec_.condition_code);
      END IF;
      IF (sales_part_rec_.catalog_type = 'PKG') THEN
         Error_SYS.Record_General(lu_name_,'NOTCONDALLOWONPKG: Condition codes are not allowed for Package Parts.');
      ELSIF (sales_part_rec_.catalog_type = 'NON') THEN
         Error_SYS.Record_General(lu_name_,'NOTCONDALLOWONNON: Condition codes are not allowed for Non Inventory Sales Parts.');
      END IF;
   ELSE
      IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(sales_part_rec_.part_no) = 'ALLOW_COND_CODE') THEN
         newrec_.condition_code := Condition_Code_API.Get_Default_Condition_Code;
      END IF;
   END IF;
   IF ((newrec_.source IS NULL) AND (newrec_.sale_unit_price IS NULL) ) THEN
      Fetch_Price_Query_Data___(newrec_);
   END IF;
END Check_Before_Insert___;


PROCEDURE Check_Before_Update___ (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE,
   oldrec_ IN     PRICE_QUERY_TAB%ROWTYPE )
IS
   header_changed_  BOOLEAN := FALSE;
   sales_part_rec_  Sales_Part_API.Public_Rec;
BEGIN

   newrec_.creator := Fnd_Session_API.Get_Fnd_User;
   sales_part_rec_ := Sales_Part_API.Get(newrec_.contract, newrec_.catalog_no);

   IF (newrec_.contract != oldrec_.contract) THEN
      User_Allowed_Site_API.Exist(newrec_.creator, newrec_.contract);
      header_changed_ := TRUE;
   END IF;
   IF (newrec_.sales_qty != oldrec_.sales_qty) THEN
      IF (newrec_.sales_qty <= 0) THEN
         Error_SYS.Record_General(lu_name_, 'QTY_LESS_THAN_ZERO: Quantity must be greater than zero!');
      END IF;
      header_changed_ := TRUE;
   END IF;

   IF (NVL(newrec_.additional_discount,0) != NVL(oldrec_.additional_discount,0)) THEN
      IF (newrec_.additional_discount < 0) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDADDDISCOUNT1: Additional discount % should be greater than 0.');
      ELSIF NOT (newrec_.additional_discount <= 100) THEN
         Error_SYS.Record_General(lu_name_, 'INVALIDADDDISCOUNT2: Additional discount should not exceed 100 %.');
      END IF;
      IF (newrec_.additional_discount IS NULL) THEN
          newrec_.additional_discount := 0;
      END IF;
      header_changed_ := TRUE;
   END IF;

   IF (NVL(newrec_.condition_code, ' ') != NVL(oldrec_.condition_code, ' ')) THEN
      IF (newrec_.condition_code IS NOT NULL) THEN
         IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(sales_part_rec_.part_no) = 'NOT_ALLOW_COND_CODE') THEN
            Error_SYS.Record_General(lu_name_,'NOTALLOWCOND: Condition code functionality is not enabled for this part. You cannot enter a condition code.');
         ELSE
            Condition_Code_API.Exist(newrec_.condition_code);
         END IF;
         IF (sales_part_rec_.catalog_type = 'PKG') THEN
            Error_SYS.Record_General(lu_name_,'NOTCONDALLOWONPKG: Condition codes are not allowed for Package Parts.');
         ELSIF (sales_part_rec_.catalog_type = 'NON') THEN
            Error_SYS.Record_General(lu_name_,'NOTCONDALLOWONNON: Condition codes are not allowed for Non Inventory Sales Parts.');
         END IF;
      ELSE
         IF (Part_Catalog_API.Get_Condition_Code_Usage_Db(sales_part_rec_.part_no) = 'ALLOW_COND_CODE') THEN
            newrec_.condition_code := Condition_Code_API.Get_Default_Condition_Code;
         END IF;
      END IF;
      header_changed_ := TRUE;
   END IF;

   IF (newrec_.customer_no != oldrec_.customer_no) OR
      (newrec_.catalog_no != oldrec_.catalog_no) OR
      (NVL(to_char(newrec_.price_effective_date), '0') != NVL(to_char(oldrec_.price_effective_date), '0')) OR
      (NVL(newrec_.agreement_id, ' ') != NVL(oldrec_.agreement_id, ' ')) OR
      (newrec_.currency_code != oldrec_.currency_code) THEN
      header_changed_ := TRUE;
   END IF;

   IF (header_changed_) THEN

      -- Note: When header changed, source/source ref value
      -- should be set to NULL (changed to stand-alone)
      newrec_.source      := NULL;
      newrec_.source_ref1 := NULL;
      newrec_.source_ref2 := NULL;
      newrec_.source_ref3 := NULL;
      newrec_.source_ref4 := NULL;

      Fetch_Price_Query_Data___(newrec_);
   END IF;
END Check_Before_Update___;


PROCEDURE Fetch_Price_Query_Data___ (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE )
IS
BEGIN
   IF (newrec_.source IS NULL) THEN
      -- Price query from stand-alone
      Customer_Order_Pricing_API.Get_Price_Query_Data(newrec_);

   ELSIF (newrec_.source IN ('CUSTOMER_ORDER_LINE','ORDER_QUOTATION_LINE')) THEN
      -- Price query from customer order line or sales quotation line
      Customer_Order_Pricing_API.Get_Price_Query_Data_Source(newrec_);
   END IF;

END Fetch_Price_Query_Data___;


PROCEDURE Generate_Price_Query_Id___ (
   price_query_id_ OUT NUMBER )
IS
   CURSOR get_next_seq_no IS
      SELECT price_query_seq.NEXTVAL
      FROM   dual;
BEGIN
   OPEN  get_next_seq_no;
   FETCH get_next_seq_no INTO price_query_id_;
   CLOSE get_next_seq_no;
END Generate_Price_Query_Id___;


PROCEDURE Create_New_Discount_Lines___ (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE )
IS
   price_list_no_                  VARCHAR2(10);
   discount_customer_level_db_     VARCHAR2(30) := NULL;
   discount_customer_level_id_     VARCHAR2(200) := NULL;
   acc_discount_    NUMBER;
BEGIN

   IF (newrec_.source IS NULL) THEN

      Sales_Price_List_API.Get_Valid_Price_List(discount_customer_level_db_, discount_customer_level_id_, price_list_no_, newrec_.contract, 
                                                newrec_.catalog_no, newrec_.customer_no, newrec_.currency_code, 
                                                newrec_.price_effective_date, NULL);
      Customer_Order_Pricing_API.New_Default_Pq_Discount_Rec(acc_discount_,
                                                             newrec_.price_query_id,
                                                             newrec_.contract,
                                                             newrec_.customer_no,
                                                             newrec_.currency_code,
                                                             newrec_.agreement_id,
                                                             newrec_.catalog_no,
                                                             newrec_.sales_qty,
                                                             price_list_no_,
                                                             newrec_.price_effective_date,
                                                             discount_customer_level_db_,
                                                             discount_customer_level_id_ );
      -- use the correct accumulated discount calculated from the discount lines creation
      newrec_.acc_discount := acc_discount_;

   ELSIF (newrec_.source IN ('CUSTOMER_ORDER_LINE','ORDER_QUOTATION_LINE')) THEN
      Customer_Order_Pricing_API.Copy_Discounts_To_Pq(newrec_.source,
                                                      newrec_.source_ref1,
                                                      newrec_.source_ref2,
                                                      newrec_.source_ref3,
                                                      newrec_.source_ref4,
                                                      newrec_.price_query_id);
   END IF;
END Create_New_Discount_Lines___;


PROCEDURE Modify_Discount_Lines___ (
   newrec_ IN OUT PRICE_QUERY_TAB%ROWTYPE )
IS
   price_list_no_         VARCHAR2(10);
   customer_level_db_     VARCHAR2(30) := NULL;
   customer_level_id_     VARCHAR2(200) := NULL;
   acc_discount_    NUMBER;
BEGIN

   Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_, customer_level_id_, price_list_no_, newrec_.contract, 
                                             newrec_.catalog_no, newrec_.customer_no, newrec_.currency_code, 
                                             newrec_.price_effective_date, NULL);
                                             
   Customer_Order_Pricing_API.Modify_Default_Pq_Discount_Rec(acc_discount_,
                                                             newrec_.price_query_id,
                                                             newrec_.contract,
                                                             newrec_.customer_no,
                                                             newrec_.currency_code,
                                                             newrec_.agreement_id,
                                                             newrec_.catalog_no,
                                                             newrec_.sales_qty,
                                                             price_list_no_,
                                                             newrec_.price_effective_date,
                                                             customer_level_db_,
                                                             customer_level_id_ );
   -- use the correct accumulated discount calculated from the discount lines creation
   newrec_.acc_discount := acc_discount_;

END Modify_Discount_Lines___;


PROCEDURE Calc_Price_Effectivity_Date___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_                   PRICE_QUERY_TAB.contract%TYPE;
   customer_no_                PRICE_QUERY_TAB.customer_no%TYPE;
   agreement_id_               PRICE_QUERY_TAB.agreement_id%TYPE;
   dummy_ship_via_             VARCHAR2(3);
   dummy_delivery_terms_       VARCHAR2(5);
   dummy_del_terms_location_   VARCHAR2(100);
   dummy_zone_id_              VARCHAR2(15);
   dummy_zone_def_             VARCHAR2(15);
   ship_addr_no_               VARCHAR2(50);
   route_id_                   VARCHAR2(12);
   calendar_id_                VARCHAR2(10);
   planned_ship_date_          DATE;
   date_entered_               DATE;
   site_date_time_             DATE;
   price_effectivity_date_     DATE;
   picking_leadtime_           NUMBER;
   delivery_leadtime_          NUMBER;
   address_rec_                Cust_Ord_Customer_Address_API.Public_Rec;
   ext_transport_calendar_id_  VARCHAR2(10);
   forward_agent_id_           VARCHAR2(20);
   shipment_type_              VARCHAR2(3);
   ship_inventory_location_no_ VARCHAR2(35);

BEGIN

   customer_no_    := Client_SYS.Get_Item_Value('CUSTOMER_NO',   attr_);
   contract_       := Client_SYS.Get_Item_Value('CONTRACT',      attr_);
   agreement_id_   := Client_SYS.Get_Item_Value('AGREEMENT_ID',  attr_);

   ship_addr_no_   := Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_);
   -- Retrieve the current date and time for this site
   site_date_time_ := NVL(Site_API.Get_Site_Date(contract_), trunc(SYSDATE));
   -- Retrieve the distribution calendar_id
   calendar_id_    := Site_API.Get_Dist_Calendar_Id(contract_);

   address_rec_    := Cust_Ord_Customer_Address_API.Get(customer_no_, ship_addr_no_);

   -- start on a work day
   planned_ship_date_ := Work_Time_Calendar_API.Get_Nearest_Work_Day(calendar_id_, site_date_time_);
   
   Cust_Order_Leadtime_Util_API.Get_Supply_Chain_Head_Defaults(dummy_ship_via_,
                                                               dummy_delivery_terms_,
                                                               dummy_del_terms_location_,
                                                               dummy_zone_def_,
                                                               dummy_zone_id_,
                                                               delivery_leadtime_,
                                                               ext_transport_calendar_id_,
                                                               route_id_,
                                                               forward_agent_id_,
                                                               picking_leadtime_,
                                                               shipment_type_,
                                                               ship_inventory_location_no_,
                                                               contract_,
                                                               customer_no_,
                                                               ship_addr_no_,
                                                               'N',
                                                               agreement_id_,
                                                               NULL); -- Passed NULL for vendor_no

   -- add picking time (in workdays)
   IF (picking_leadtime_ > 0) THEN
      planned_ship_date_ := Work_Time_Calendar_API.Get_End_Date(calendar_id_, planned_ship_date_, picking_leadtime_);
   END IF;

   -- Fetch next route departure date
   IF (route_id_ IS NOT NULL) THEN
      -- used to check against the route's departure time...
      date_entered_ := to_date(to_char(Site_API.Get_Site_Date(contract_), 'YYYY-MM-DD HH24:MI'), 'YYYY-MM-DD HH24:MI');

      -- find the best route departure date
      planned_ship_date_ := Delivery_Route_API.Get_Route_Ship_Date(route_id_,
                                                                         planned_ship_date_,
                                                                         date_entered_,
                                                                         contract_);
      IF (planned_ship_date_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'INVALROUTEDATE: Route departure date is not within current calendar.');
      END IF;
      -- if a time is specified (midnight = no time = anytime) ...
      IF ((to_char(planned_ship_date_, 'HH24:MI') != '00:00') AND (NVL(to_char(address_rec_.delivery_time, 'HH24:MI'), '00:00') != '00:00')) THEN
         -- ... if route departure time is greater than delivery time move delivery date ahead one day
         IF ((delivery_leadtime_ = 0 ) AND (to_char(planned_ship_date_, 'HH24:MI') > to_char(address_rec_.delivery_time, 'HH24:MI'))) THEN
            planned_ship_date_ := planned_ship_date_ + 1;
         END IF;
      END IF;
   END IF;

   Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(price_effectivity_date_, ext_transport_calendar_id_, trunc(planned_ship_date_), NVL(delivery_leadtime_, 0));
   Client_SYS.Set_Item_Value('PRICE_EFFECTIVE_DATE', price_effectivity_date_, attr_);
END Calc_Price_Effectivity_Date___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_ PRICE_QUERY_TAB.contract%TYPE;
BEGIN
   super(attr_);
   contract_ := User_Default_API.Get_Contract();
   Client_SYS.Add_To_Attr('CONTRACT', contract_, attr_);
   -- Fetching the default price query price effective date
   IF (Cust_Order_Pricing_Method_API.Encode(Site_Discom_Info_API.Get_Cust_Order_Pricing_Method(contract_)) = 'ORDER_DATE') THEN
      Client_SYS.Add_To_Attr('PRICE_EFFECTIVE_DATE',  trunc(NVL(Site_API.Get_Site_Date(contract_), SYSDATE)), attr_);
   END IF;
END Prepare_Insert___;


@Override
PROCEDURE Insert___ (
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   newrec_     IN OUT PRICE_QUERY_TAB%ROWTYPE,
   attr_       IN OUT VARCHAR2 )
IS
BEGIN

   IF (newrec_.price_query_id IS NULL) THEN
      -- Generate new price query id
      Generate_Price_Query_Id___(newrec_.price_query_id);
      Client_SYS.Add_To_Attr('PRICE_QUERY_ID', newrec_.price_query_id, attr_);
   END IF;

   super(objid_, objversion_, newrec_, attr_);
EXCEPTION
   WHEN dup_val_on_index THEN
      Error_SYS.Record_Exist(lu_name_);
END Insert___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT price_query_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN   
   Check_Before_Insert___(newrec_);   
   super(newrec_, indrec_, attr_);   
   IF (indrec_.customer_no) THEN
      IF (trunc(Cust_Ord_Customer_API.Get_Date_Del(newrec_.customer_no)) <= trunc(Site_API.Get_Site_Date(newrec_.contract))) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTEXPERROR: Customer has expired. Check expire date.');
      END IF;
   END IF;   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     price_query_tab%ROWTYPE,
   newrec_ IN OUT price_query_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
   name_  VARCHAR2(30);
   value_ VARCHAR2(4000);
BEGIN
   Check_Before_Update___(newrec_, oldrec_);
   super(oldrec_, newrec_, indrec_, attr_);
   IF (indrec_.customer_no) THEN
      IF (trunc(Cust_Ord_Customer_API.Get_Date_Del(newrec_.customer_no)) <= trunc(Site_API.Get_Site_Date(newrec_.contract))) THEN
         Error_SYS.Record_General(lu_name_, 'CUSTEXPERROR: Customer has expired. Check expire date.');
      END IF;   
   END IF;
   
EXCEPTION
   WHEN value_error THEN
      Error_SYS.Item_Format(lu_name_, name_, value_);
END Check_Update___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

@Override
PROCEDURE New__ (
   info_       OUT    VARCHAR2,
   objid_      OUT    VARCHAR2,
   objversion_ OUT    VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   newrec_ PRICE_QUERY_TAB%ROWTYPE;
   oldrec_ PRICE_QUERY_TAB%ROWTYPE;
BEGIN
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      oldrec_ := newrec_;
      Create_New_Discount_Lines___(newrec_);
      -- always do calculations after discount lines have been saved to be sure to use a correct accumulated discount
      Customer_Order_Pricing_API.Do_Price_Query_Calculations(newrec_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);
   END IF;
END New__;


@Override
PROCEDURE Modify__ (
   info_       OUT    VARCHAR2,
   objid_      IN     VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   attr_       IN OUT VARCHAR2,
   action_     IN     VARCHAR2 )
IS
   oldrec_ PRICE_QUERY_TAB%ROWTYPE;
   newrec_ PRICE_QUERY_TAB%ROWTYPE;
BEGIN
   IF (action_ = 'DO') THEN 
      oldrec_ := Get_Object_By_Id___(objid_);
   END IF;
   super(info_, objid_, objversion_, attr_, action_);
   IF (action_ = 'DO') THEN
      newrec_ := Get_Object_By_Id___(objid_);
      Modify_Discount_Lines___(newrec_);
      -- always do calculations after discount lines have been saved to be sure to use a correct accumulated discount
      Customer_Order_Pricing_API.Do_Price_Query_Calculations(newrec_);
      Update___(objid_, oldrec_, newrec_, attr_, objversion_);      
   END IF;
END Modify__;


PROCEDURE Clean_Price_Query__
IS
   creator_ VARCHAR2(30)  := Fnd_Session_API.Get_Fnd_User;
   info_    VARCHAR2(32000);

   CURSOR get_all_queries_for_user IS
   SELECT objid, objversion
   FROM   PRICE_QUERY
   WHERE  creator = creator_;

BEGIN
   Trace_SYS.Message('Removing all saved price queries for user ' || creator_);
   FOR remrec_ IN get_all_queries_for_user LOOP
   Remove__(info_,
            remrec_.objid,
            remrec_.objversion,
            'DO');
   END LOOP;


END Clean_Price_Query__;


-- Create_Pq_For_Source__
--   This method create new price query data according to the given source
--   reference and return new price query id.
--   The source can be a Customer Order Line or Order Quotation Line.
PROCEDURE Create_Pq_For_Source__ (
   price_query_id_ OUT NUMBER,
   source_attr_    IN  VARCHAR2 )
IS
   ptr_                NUMBER;
   name_               VARCHAR2(30);
   value_              VARCHAR2(2000);
   newrec_             PRICE_QUERY_TAB%ROWTYPE;
   objid_              VARCHAR2(2000);
   objversion_         VARCHAR2(2000);
   new_attr_           VARCHAR2(32000);
   source_             PRICE_QUERY_TAB.source%TYPE;
   source_ref1_        PRICE_QUERY_TAB.source_ref1%TYPE:= NULL;
   source_ref2_        PRICE_QUERY_TAB.source_ref2%TYPE:= NULL;
   source_ref3_        PRICE_QUERY_TAB.source_ref3%TYPE:= NULL;
   source_ref4_        PRICE_QUERY_TAB.source_ref4%TYPE:= NULL;
   oldrec_             PRICE_QUERY_TAB%ROWTYPE;
BEGIN
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(source_attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'SOURCE') THEN
         source_ := value_;
      ELSIF (name_ = 'SOURCE_REF1') THEN
         source_ref1_ := value_;
      ELSIF (name_ = 'SOURCE_REF2') THEN
         source_ref2_ := value_;
      ELSIF (name_ = 'SOURCE_REF3') THEN
         source_ref3_ := value_;
      ELSIF (name_ = 'SOURCE_REF4') THEN
         source_ref4_ := Client_SYS.Attr_Value_To_Number(value_);
      END IF;
   END LOOP;

   newrec_.source      := source_;
   newrec_.source_ref1 := source_ref1_;
   newrec_.source_ref2 := source_ref2_;
   newrec_.source_ref3 := source_ref3_;
   newrec_.source_ref4 := source_ref4_;

   Fetch_Price_Query_Data___(newrec_);
   Insert___(objid_, objversion_, newrec_, new_attr_);
   price_query_id_ := newrec_.price_query_id;
   oldrec_ := Lock_By_Id___(objid_, objversion_);
   newrec_ := oldrec_;
   Create_New_Discount_Lines___(newrec_);
   -- always do calculations after discount lines have been saved to be sure to use a correct accumulated discount
   Customer_Order_Pricing_API.Do_Price_Query_Calculations(newrec_);
   Update___(objid_, oldrec_, newrec_, new_attr_, objversion_);
   -- Clearing all info
   Client_SYS.Clear_Info;
END Create_Pq_For_Source__;


-- Get_Price_Source_Node_Id__
--   This method return the node_id value according to the price source
--   information for given price query id.
--   The node_id value represents the price source node level in the price/discount tree.
@UncheckedAccess
FUNCTION Get_Price_Source_Node_Id__ (
   price_query_id_ IN NUMBER ) RETURN NUMBER
IS
   node_id_    NUMBER;
   pqrec_      Public_Rec;

BEGIN
   pqrec_ := Get(price_query_id_);
   CASE (pqrec_.price_source)
      WHEN ('PRICE BREAKS') THEN
         node_id_ := 100;
      WHEN ('CONDITION CODE') THEN
         node_id_ := 200;
      WHEN ('CAMPAIGN') THEN
         CASE (pqrec_.part_level)
            WHEN ('ASSORTMENT') THEN
               CASE (pqrec_.customer_level)
                  WHEN ('HIERARCHY_PRICE_GROUP') THEN
                     node_id_ := 324;
                  WHEN ('CUSTOMER_PRICE_GROUP') THEN
                     node_id_ := 323;
                  WHEN ('HIERARCHY') THEN
                     node_id_ := 322;
                  WHEN ('CUSTOMER') THEN
                     node_id_ := 321;
                  ELSE
                     node_id_ := 320;
               END CASE;
            WHEN ('PART') THEN
               CASE (pqrec_.customer_level)
                  WHEN ('HIERARCHY_PRICE_GROUP') THEN
                     node_id_ := 314;
                  WHEN ('CUSTOMER_PRICE_GROUP') THEN
                     node_id_ := 313;
                  WHEN ('HIERARCHY') THEN
                     node_id_ := 312;
                  WHEN ('CUSTOMER') THEN
                     node_id_ := 311;
                  ELSE
                     node_id_ := 310;
               END CASE;
            ELSE
               node_id_ := 300;
         END CASE;
      WHEN ('AGREEMENT') THEN
         CASE (pqrec_.part_level)
            WHEN ('ASSORTMENT') THEN
               CASE (pqrec_.customer_level)
                  WHEN ('HIERARCHY') THEN
                     node_id_ := 422;
                  WHEN ('CUSTOMER') THEN
                     node_id_ := 421;
                  ELSE
                     node_id_ := 420;
               END CASE;
            WHEN ('PART') THEN
               CASE (pqrec_.customer_level)
                  WHEN ('HIERARCHY') THEN
                     node_id_ := 412;
                  WHEN ('CUSTOMER') THEN
                     node_id_ := 411;
                  ELSE
                     node_id_ := 410;
               END CASE;
            ELSE
               node_id_ := 400;
         END CASE;
      WHEN ('PRICELIST') THEN
         CASE (pqrec_.part_level)
            WHEN ('UNIT') THEN
               CASE (pqrec_.customer_level)
                  WHEN ('HIERARCHY_PRICE_GROUP') THEN
                     node_id_ := 534;
                  WHEN ('CUSTOMER_PRICE_GROUP') THEN
                     node_id_ := 533;
                  WHEN ('HIERARCHY') THEN
                     node_id_ := 532;
                  WHEN ('CUSTOMER') THEN
                     node_id_ := 531;
                  ELSE
                     node_id_ := 530;
               END CASE;
               WHEN ('ASSORTMENT') THEN
                  CASE (pqrec_.customer_level)
                     WHEN ('HIERARCHY_PRICE_GROUP') THEN
                        node_id_ := 524;
                     WHEN ('CUSTOMER_PRICE_GROUP') THEN
                        node_id_ := 523;
                     WHEN ('HIERARCHY') THEN
                        node_id_ := 522;
                     WHEN ('CUSTOMER') THEN
                        node_id_ := 521;
                     ELSE
                        node_id_ := 520;
                  END CASE;
            WHEN ('PART') THEN
               CASE (pqrec_.customer_level)
                  WHEN ('HIERARCHY_PRICE_GROUP') THEN
                     node_id_ := 514;
                  WHEN ('CUSTOMER_PRICE_GROUP') THEN
                     node_id_ := 513;
                  WHEN ('HIERARCHY') THEN
                     node_id_ := 512;
                  WHEN ('CUSTOMER') THEN
                     node_id_ := 511;
                  ELSE
                     node_id_ := 510;
               END CASE;
            ELSE
               node_id_ := 500;
         END CASE;
      WHEN ('BASE') THEN
         node_id_ := 600;
      ELSE
         node_id_ := 0;
   END CASE;
   RETURN node_id_;
END Get_Price_Source_Node_Id__;


-- Get_Customer_Defaults__
--   Called on validation of customer_no in Price Query client
PROCEDURE Get_Customer_Defaults__ (
   attr_ IN OUT VARCHAR2 )
IS
   contract_          PRICE_QUERY_TAB.contract%TYPE;
   customer_no_       PRICE_QUERY_TAB.customer_no%TYPE;
   agreement_id_      PRICE_QUERY_TAB.agreement_id%TYPE;
   currency_code_     PRICE_QUERY_TAB.currency_code%TYPE;
   name_              VARCHAR2(30);
   value_             VARCHAR2(2000);
   ptr_               NUMBER;
   site_date_time_    DATE;
   agreement_found_   BOOLEAN := FALSE;
BEGIN

   customer_no_    := Client_SYS.Get_Item_Value('CUSTOMER_NO',   attr_);
   contract_       := Client_SYS.Get_Item_Value('CONTRACT',      attr_);

   -- IF agreement id is passed in the attribute string use that agreement id (even if the value passed is null)
   ptr_ := NULL;
   WHILE (Client_SYS.Get_Next_From_Attr(attr_, ptr_, name_, value_)) LOOP
      IF (name_ = 'AGREEMENT_ID') THEN
         agreement_id_ := value_;
         agreement_found_ := TRUE;
      END IF;
   END LOOP;

   Cust_Ord_Customer_API.Exist(customer_no_);
   currency_code_ := Cust_Ord_Customer_API.Get_Currency_Code(customer_no_);

   IF (Cust_Ord_Customer_API.Get_Delivery_Address(customer_no_) IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NOSHIPDELADDR: Customer :P1 has no delivery address with order specific attributes specified.', customer_no_);
   END IF;

   Site_API.Exist(contract_);

   IF (NOT agreement_found_) THEN
      -- Retrieve the current date and time for this site
      site_date_time_ := NVL(Site_API.Get_Site_Date(contract_), trunc(SYSDATE));
      agreement_id_ := Customer_Agreement_API.Get_First_Valid_Agreement(customer_no_,
                                                                        contract_,
                                                                        currency_code_,
                                                                        trunc(site_date_time_),
                                                                        'FALSE');
   END IF;

   Client_SYS.Set_Item_Value('CURRENCY_CODE', currency_code_,  attr_ );
   Client_SYS.Set_Item_Value('AGREEMENT_ID',  agreement_id_,   attr_);
   IF (Cust_Order_Pricing_Method_API.Encode( Site_Discom_Info_API.Get_Cust_Order_Pricing_Method(contract_) ) = 'DELIVERY_DATE') THEN
      Calc_Price_Effectivity_Date___(attr_);
   ELSE
      Client_SYS.Set_Item_Value('PRICE_EFFECTIVE_DATE', Client_SYS.Get_Item_Value('PRICE_EFFECTIVE_DATE', attr_), attr_);
   END IF;
END Get_Customer_Defaults__;

PROCEDURE Fetch_Price_Query_Data__(
   sale_unit_price_      OUT NUMBER,
   base_sale_unit_price_ OUT NUMBER,
   discount_             OUT NUMBER,
   price_source_id_      OUT VARCHAR2,
   net_price_fetched_    OUT VARCHAR2,
   price_source_db_      OUT VARCHAR2,
   part_level_db_        OUT VARCHAR2,
   part_level_id_        OUT VARCHAR2,
   creator_              OUT VARCHAR2,
   use_price_incl_tax_   OUT VARCHAR2,
   customer_level_db_    IN OUT VARCHAR2,
   customer_level_id_    IN OUT VARCHAR2,
   contract_             IN  VARCHAR2,
   customer_no_          IN  VARCHAR2,
   currency_code_        IN  VARCHAR2,
   agreement_id_         IN  VARCHAR2,
   catalog_no_           IN  VARCHAR2,
   buy_qty_due_          IN  NUMBER,
   effectivity_date_     IN  DATE,
   ifs_curr_rounding_    IN  NUMBER,
   condition_code_       IN  VARCHAR2 DEFAULT NULL,
   price_query_id_       IN  NUMBER DEFAULT NULL)
IS
   newrec_     PRICE_QUERY_TAB%ROWTYPE;
   oldrec_     PRICE_QUERY_TAB%ROWTYPE;
   rounding_   NUMBER;
BEGIN
   
   rounding_ := NVL(ifs_curr_rounding_, 2); 

   IF (price_query_id_ IS NULL) THEN
      newrec_.contract             := contract_;
      newrec_.customer_no          := customer_no_;
      newrec_.catalog_no           := catalog_no_;
      newrec_.currency_code        := currency_code_;
      newrec_.price_effective_date := effectivity_date_;
      newrec_.condition_code       := condition_code_;
      newrec_.sales_qty            := buy_qty_due_;
      newrec_.agreement_id         := agreement_id_;

      Check_Before_Insert___(newrec_);

      sale_unit_price_      := ROUND(newrec_.sale_unit_price, rounding_);
      base_sale_unit_price_ := ROUND(newrec_.base_sale_unit_price, rounding_);
      discount_             := ROUND(newrec_.acc_discount, rounding_);
      price_source_id_      := newrec_.price_source_id;
      net_price_fetched_    := newrec_.price_source_net_price;
      price_source_db_      := newrec_.price_source;
      part_level_db_        := newrec_.part_level;
      part_level_id_        := newrec_.part_level_id;
      customer_level_db_    := newrec_.customer_level;
      customer_level_id_    := newrec_.customer_level_id;
      creator_              := newrec_.creator;
      use_price_incl_tax_   := newrec_.use_price_incl_tax;
   ELSE
      Exist(price_query_id_);
      oldrec_ := Get_Object_By_Keys___(price_query_id_);
      newrec_ := oldrec_;
      newrec_.contract             := contract_;
      newrec_.customer_no          := customer_no_;
      newrec_.catalog_no           := catalog_no_;
      newrec_.currency_code        := currency_code_;
      newrec_.price_effective_date := effectivity_date_;
      newrec_.condition_code       := condition_code_;
      newrec_.sales_qty            := buy_qty_due_;
      newrec_.agreement_id         := agreement_id_;
      Check_Before_Update___(newrec_, oldrec_);

      IF (newrec_.sale_unit_price != oldrec_.sale_unit_price) THEN
         sale_unit_price_      := ROUND(newrec_.sale_unit_price, rounding_);
         base_sale_unit_price_ := ROUND(newrec_.base_sale_unit_price, rounding_);
      END IF;
      IF (newrec_.acc_discount != oldrec_.acc_discount) THEN
         discount_             := ROUND(newrec_.acc_discount, rounding_);
      END IF;
      IF (newrec_.price_source_id != oldrec_.price_source_id) THEN
         price_source_id_      := newrec_.price_source_id;
         price_source_db_      := newrec_.price_source;
      END IF;
      IF (newrec_.part_level_id != oldrec_.part_level_id) THEN
         part_level_db_        := newrec_.part_level;
         part_level_id_        := newrec_.part_level_id;
      END IF;
      IF (newrec_.customer_level_id != oldrec_.customer_level_id) THEN
         customer_level_db_    := newrec_.customer_level;
         customer_level_id_    := newrec_.customer_level_id;
      END IF;
      IF (newrec_.price_source_net_price != oldrec_.price_source_net_price) THEN
         net_price_fetched_    := newrec_.price_source_net_price;
      END IF;
      IF (newrec_.use_price_incl_tax != oldrec_.use_price_incl_tax) THEN
         use_price_incl_tax_    := newrec_.use_price_incl_tax;
      END IF;
         
   END IF;    

END Fetch_Price_Query_Data__;


-- Fetch_Price_Visualization__
--  This method uses to visualize the price fetching logic in Aurena client. 
FUNCTION Fetch_Price_Visualization__ (
   price_source_db_    IN VARCHAR2,
   part_level_db_      IN VARCHAR2,
   customer_level_db_  IN VARCHAR2) RETURN VARCHAR2
IS
   TYPE price_source_array  IS VARRAY(6) OF VARCHAR2(50);
   TYPE part_level_array  IS VARRAY(3) OF VARCHAR2(50);
   TYPE customer_level_array  IS VARRAY(4) OF VARCHAR2(50);
   
   price_source_arr_    price_source_array; 
   part_level_arr_      part_level_array; 
   customer_level_arr_  customer_level_array;    
   
   return_string_           VARCHAR2(32000);
   price_source_count_      NUMBER;
   part_level_count_        NUMBER;
   customer_level_count_    NUMBER;
BEGIN
   price_source_arr_ := price_source_array(Pricing_Source_API.DB_PRICE_BREAKS, 
                                       Pricing_Source_API.DB_CONDITION_CODE,
                                       Pricing_Source_API.DB_CAMPAIGN,
                                       Pricing_Source_API.DB_AGREEMENT,
                                       Pricing_Source_API.DB_PRICE_LIST,
                                       Pricing_Source_API.DB_BASE); 
 
   part_level_arr_ := part_level_array(Price_Discount_Part_Level_API.DB_PART, 
                                   Price_Discount_Part_Level_API.DB_ASSORTMENT,
                                   Price_Discount_Part_Level_API.DB_UNIT); 
                                  
   customer_level_arr_ := customer_level_array(Price_Discount_Cust_Level_API.DB_CUSTOMER, 
                                           Price_Discount_Cust_Level_API.DB_HIERARCHY,
                                           Price_Discount_Cust_Level_API.DB_CUSTOMER_PRICE_GROUP,
                                           Price_Discount_Cust_Level_API.DB_HIERARCHY_PRICE_GROUP);
  
   
   price_source_count_      := price_source_arr_.count;
   part_level_count_        := part_level_arr_.count;
   customer_level_count_    := customer_level_arr_.count;
   
   IF (price_source_db_ IS NOT NULL) THEN
      IF (price_source_db_ != Pricing_Source_API.DB_PRICE_LIST ) THEN
         part_level_count_ := part_level_count_ - 1;
      END IF;

      IF (price_source_db_ = Pricing_Source_API.DB_AGREEMENT) THEN
         customer_level_count_ := customer_level_count_ - 2;
      END IF;
   END IF;
            
   FOR i IN 1.. price_source_count_ LOOP      
      IF (NVL(price_source_db_, Database_SYS.string_null_) = price_source_arr_(i)) THEN
         return_string_ := return_string_ || '- **'||Pricing_Source_API.Decode(price_source_arr_(i)) ||'** '|| CHR (13) || CHR(10) ;
         
         IF (part_level_db_ IS NOT NULL OR part_level_db_ != '') THEN
            
            
            FOR j IN 1.. part_level_count_ LOOP
               IF (NVL(part_level_db_, Database_SYS.string_null_) = part_level_arr_(j)) THEN
                  return_string_ := return_string_ || CHR (9) || '- **'||Price_Discount_Part_Level_API.Decode(part_level_arr_(j)) ||'** '|| CHR (13) || CHR(10) ;
                  
                  FOR k IN 1.. customer_level_count_ LOOP
                     IF (NVL(customer_level_db_, Database_SYS.string_null_) = customer_level_arr_(k)) THEN
                        return_string_ := return_string_ || CHR (9) || CHR (9) || '- **'||Price_Discount_Cust_Level_API.Decode(customer_level_arr_(k)) ||'** '|| CHR (13) || CHR(10) ;
                     ELSE
                        return_string_ := return_string_ || CHR (9) || CHR (9) || '- '||Price_Discount_Cust_Level_API.Decode(customer_level_arr_(k)) ||' '|| CHR (13) || CHR(10) ;
                     END IF;
                  END LOOP;
               ELSE
                  return_string_ := return_string_ || CHR (9) || '- '||Price_Discount_Part_Level_API.Decode(part_level_arr_(j)) ||' '|| CHR (13) || CHR(10) ;
                  
                  FOR k IN 1.. customer_level_count_ LOOP
                     return_string_ := return_string_ || CHR (9) || CHR (9) || '- '||Price_Discount_Cust_Level_API.Decode(customer_level_arr_(k)) ||' '|| CHR (13) || CHR(10) ;
                  END LOOP;
               END IF;               
            END LOOP;
         END IF;         
      ELSE
         return_string_ := return_string_ || '- '||Pricing_Source_API.Decode(price_source_arr_(i)) ||' '|| CHR (13) || CHR(10) ;
      END IF;      
   END LOOP;
   
   RETURN return_string_;
   
END Fetch_Price_Visualization__;

-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------
-- public interface of Create_Pq_For_Source__
--      call from SalesQuotationHandling.plsvc and CustomerOrderLineTab.plscv
PROCEDURE Create_Pq_For_Source (
   price_query_id_ OUT NUMBER,
   source_attr_    IN  VARCHAR2 )
IS
BEGIN
   Create_Pq_For_Source__(price_query_id_, source_attr_);
END Create_Pq_For_Source;

