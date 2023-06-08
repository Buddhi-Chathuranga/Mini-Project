-----------------------------------------------------------------------------
--
--  Logical unit: SalesPriceList
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date    Sign    History
--  ------  ------  ---------------------------------------------------------
--  210112  MaEelk SC2020R1-12036, Modified Copy__ and replaced Prepare_Insert___, Unpack___, Check_Insert___ and Insert___ with New___
--  201216  ErRalk Bug 156383(SCZ-12403), Modified Update___() by removing Aurena specific condition.
--  200928  DhAplk SC2020R1-820, Changed a public interface Price_List_Struct_Rec_To_Xml Price_List_Struct_Rec_To_Json.
--  200715  PamPlk Bug 152585(SCZ-9275), Introduced a new method Is_Valid_Price_List() to validate the price list in customer order and sales quotation. 
--  200529  DhAplk SC2020R1-820, Added a public interface to Price_List_Struct_Rec_To_Xml.
--  181017  MaEelk SCUXXW4-9452, Added Sales_Prices_Available to support the RMB Send Price List at Sales Price List in Aurena
--  181016  MaEelk SCUXXW4-9452, Override Update___ to handle rounding in Aurena.
--  180823  Maeelk SCUXXW4-1496, Modified Check_Common___ and added validation to check of default_percentage_offset is greater than hundred. Reised an error message if not
--  180610  ShPrlk Bug 139081, Modified method Get_Valid_Assort_Price_List___ and Is_Valid_Assort to fascilitate fetching valid pricelist from Hierarchy when CO line sales quantity is entered,
--  180610         Modified Get_Valid_Price_List to hold the price_list_no_ and pass it to the Get_Valid_Assort_Price_List___ if part based price list is not found.
--  180610         Modified Get_Valid_Assort_Price_List___ to make it behave consistent with part based price list.
--  170824  ShPrlk Bug 136668, Modified method Get_Valid_Price_List and Is_Valid to fascilitate fetching valid pricelist from Hierarchy when CO line sales quantity is entered.
--  170512  SURBLK Added ORDER BY statement in to min_duration in find_rental_parts_min_qty cursor in Find_Price_On_Pricelist().
--  161027  ChFolk STRSC-4311, Added new parameters raise_msg_ and include_period_ to method Copy__.
--  160915  NWeelk FINHR-2043, Removed tax regime related codes from Copy__ method.
--  160826  IzShlk STRSC-3855, Overriden Check_Common__ method to check valid to date.
--  160826  IzShlk STRSC-3855, Introduced Get_Latest_Valid_To___ method to get the latest date from Sales price list.
--  160804  ChFolk STRSC-3584, Modified Find_Price_On_Pricelist to consider valid_to_date in price fetching logic. 
--  140411  SURBLK Added Get_Readable.
--  140311  ShVese Removed override annotation from the method Check_Sup_Price_List_No_Ref___.
--  140228  SURBLK Changed Company_Distribution_Info_API.Get_Use_Price_Incl_Tax_Db into Company_Order_Info_API.Get_Use_Price_Incl_Tax_Db. 
--  130321  NaLrlk Added sales_price_type_db parameter to Is_Valid and Get_Valid_Price_List.
--  130318  NaSalk Modified Find_Price_On_Pricelist to add rental_chargable_days_ parameter. 
--  121003  HimRlk Modified Copy__() to give an error message if use price incl tax value is different when copying to an existing price list.
--  121003  HimRlk Added new OUT parameter use_price_incl_tax_changed_ to Copy__() and modified to insert FALSE to use_price_incl_tax if
--  121003         tax_regime is not VAT.
--  120726  ShKolk Modified Find_Price_On_Pricelist() to consider prices including tax.
--  120724  HimRlk Modified Unpack_Check_Update___ by calling Sales_Price_List_Part_API.Modify_Sales_Prices to recalculate prices
--  120724         if use_price_incl_tax is changed.
--  120724  HimRlk Modified Copy__ to copy value of use_price_incl_tax.
--  120709  JeeJlk Added a new column Use_price_incl_tax.
--  120314  DaZase Removed last TRUE parameter in Init_Method call inside Find_Price_On_Pricelist.
--  120130  MaRalk Added view comments to SUBSCRIBE_NEW_SALES_PARTS, SUBSCRIBE_NEW_SALES_PARTS_DB columns in the SALES_PRICE_LIST view. Added 
--  120130         ENUMERATION=FndBoolean to view comments AWAIT_REVIEW, USE_PRICE_BREAK_TEMPLATES, Modified DEFAULT_AMOUNT_OFFSET column type as NUMBER, 
--  120130         Added uppercase format to DEFAULT_BASE_PRICE_SITE column commnets, Modified DEFAULT_PERCENTAGE_OFFSET view comments to NUMBER in 
--  120130         SALES_PRICE_LIST view to avoid model errors generated from PLSQL implementation test.
--  111103  ChJalk Modified the usage of SALES_PRICE_PART_JOIN with related tables.
--  111101  ChJalk Added user allowed company filter to the view SALES_PRICE_LIST_LOV2 and the user allowed company filter and the user allowed site filter to the CUST_CONNECTED_PRICE_LISTS view.
--  111031  ChJalk Added user allowed company filter and user allowed site filter to the base view SALES_PRICE_LIST.
--  111017  MaRalk Removed OUT parameters part_level_db_, part_level_id_ from Get_Valid_Price_List, Get_Valid_Assort_Price_List___  
--  111017         methods and added same parameters to the method Find_Price_On_Pricelist. Modified methods accordingly.
--  111017         Moved part level parameter values fetching logic to the Find_Price_On_Pricelist method.
--  110926  MaRalk Removed unused parameter currency_code_ from Is_Valid, Is_Valid_Assort methods and modified relevant places.  
--  110922  MaRalk Modified view SALES_PRICE_LIST_JOIN_LOV to add assortment price lists. Added function Is_Valid_Assort.
--  110922         Modified method Get_Valid_Assort_Price_List___.
--  110831  NaLrlk Modified the Unpack_Check_Update___ method to raise the error message when assortment id is changed.
--  110830  MaRalk Modified Get_Valid_Price_List method to fetch the correct price list when invalid price list is entered.
--  110824  Maralk Removed cursors get_part_based, get_unit_based from Get_Valid_Price_List and cleaned up the method.
--  110824  ChJalk Bug 95597, Added view SALES_PRICE_LIST_JOIN_LOV. Added IN parameter catalog_no_ to the function Is_Valid and
--  110824         modified the method to validate the price list against the sales part or the date.
--  110614  NaLrlk Modified the methods Is_Valid, Get_Valid_Price_List and Get_Valid_Assort_Price_List___.
--  110520  MiKulk Modified the method Copy_ by removing the check to compare the from company and to company.
--  110509  NaLrlk Modified the method Copy__ to copying rounding and valid_to_date in new sales price list.
--  110322  RiLase Added AWAIT_REVIEW, SUBSCRIBE_NEW_SALES_PARTS, DEFAULT_BASE_PRICE_SITE,
--  110322         DEFAULT_PERCENTAGE_OFFSET and DEFAULT_AMOUNT_OFFSET.
--  110128  NaLrlk Modified methods Get_Valid_Price_List and Find_Price_On_Pricelist to fetch the Active part based price list lines.
--  110124  RiLase Added USE_PRICE_BREAK_TEMPLATES to creation of new sales price list header in COPY__.
--  110120  RiLase Added use_price_break_templates_db to CUST_CONNECTED_PRICE_LISTS view.
--  110113  RiLase Added USE_PRICE_BREAK_TEMPLATES.
--  110107  ShKolk Added restrictions for sup_price_list_no.
--  101223  ShKolk Modified Check_Delete___() to call Check_Editable() instead of the cursor. Removed COMPANYNODELETE message.
--  101217  ShKolk Modified error messages COMPANYNODELETE, COMPANYNOMODIFY and COMPANYNOREAD.
--  101216  RiLase Added check if price lists are valid in Get_Valid_Price_List() and Get_Valid_Assort_Price_List().
--  101210  ShKolk Renamed company to owning_company.
--  101203  ShKolk Modified views SALES_PRICE_LIST_AUTH_READ, SALES_PRICE_LIST_PART_LOV, SALES_PRICE_LIST_UNIT_LOV.
--  101201  ShKolk Removed LOV flag for company in SALES_PRICE_LIST_LOV view.
--  101112  ShKolk Added columns to SALES_PRICE_LIST_AUTH_READ, SALES_PRICE_LIST_AUTH_WRITE.
--  101111  RaKalk Added function Get_Editable
--  101110  ShKolk Removed company_ from method call to Customer_Pricelist_API.Get_Price_List_No, Cust_Price_Group_Detail_API.Get_Price_List_No 
--  101110         Removed company from view VIEW_DIRPLISTS, VIEW_GRCPLISTS and VIEW_CUTCLISTS.
--  101103  RaKalk Added procedure Check_Editable and Check_Readable. 
--  101103         Added views SALES_PRICE_LIST_AUTH_READ, SALES_PRICE_LIST_AUTH_WRITE
--  101103         Implemented validations to prevent creating/modifying price lists by unauthorized users
--  101103         Set the default value for company
--  100514  KRPELK Merge Rose Method Documentation.
--  100317  JuMalk Bug 89437, Modified column comments of the view SALES_PRICE_LIST_SITE_LOV2.
--  ------------------------------- Eagle ----------------------------------
--  100422  DaZase Added calls to Invoice_Library_API.Get_Currency_Rate_Defaults in unpack methods to check for valid currency rate.
--  091013  KiSalk Corrected Get_Valid_Assort_Price_List___ and the place it is called.
--  090902  MaJalk Rearrange view LOVVIEW to make company as a primary key.
--  090827  MaJalk Added company to view LOVVIEW4. Modified method Copy__ to create new price list or 
--  090827         modify existing price list.
--  090826  MaJalk Added company to views VIEW_DIRPLISTS, VIEW_GRCPLISTS and VIEW_CUTCLISTS.
--  090818  MaJalk Added attribute company.
--  090902  KiSalk Added methods Get_Rounding and Copy__.
--  090619  KiSalk Added public attribute assortment_id with validations and methods Find_Price_On_Pricelist,
--  090619         Get_Valid_Price_List, Check_Records_Exist_Per_Assort and Get_Id_In_Assort_Lines.
--  080202  MaRalk Bug 68752, Added new views, DIR_CONNECTED_PRICE_LISTS, CUST_GRP_CONNECTED_LIST and CUST_CONNECTED_PRICE_LISTS.
--  060323  Samnlk Modified FUNCTION Is_Valid, Make current date also valid.
--  060315  KanGlk Modified Is_Valid function.
--  060118  JaJalk Added the returning clause in Insert___ according to the new F1 template.
--  051212  PrPrlk Bug 55025, Added new Function Check_Repeated_Items().
--  050305  GuPelk Bug 49785, Added view, to show Price List No,which are registerd as base price site
--  --------------------TouchDown Merge End-----------------------------------
--  040108  GaJalk Removed the currency comparison to support preffered price list
--                 inside the function Is_Valid.
--  --------------------TouchDown Merger Begin--------------------------------
--  030804  ChFolk Performed SP4 Merge. (SP4Only)
--  030509  DhAalk Bug 37061, Added FUNCTION Is_Exist_Price_List.
--  000913   FBen  Added UNDEFINED.
--  001719   TFU   Merging from Chameleon
--  000517   LIN   Added parameter effectivity_date in IS_VALID
--  ---------------------- 12.10 --------------------------------------------
--  000105  JoEd  Added public attribute SUP_PRICE_LIST_NO.
--  ---------------------- 11.2 ---------------------------------------------
--  990419  RaKu  Y.Cleanup.
--  990316  RaKu  Added SALES_PRICE_LIST_LOV2.
--  990118  PaLj  changed sysdate to Site_API.Get_Site_Date(contract)
--  981130  RaKu  Changes to match Design.
--  981119  RaKu  Added views SALES_PRICE_LIST_PART_LOV and SALES_PRICE_LIST_UNIT_LOV.
--  981118  RaKu  Added TRUNC to the where-stmt in LOVVIEW.
--  981118  RaKu  Changed SALES_PRICE_LIST_GROUP_LOV to SALES_PRICE_LIST_LOV,
--                removed the old SALES_PRICE_LIST_LOV (obsolete) and added
--                a where-statement and valid_to_date to the view.
--  981117  RaKu  Added view SALES_PRICE_LIST_GROUP_LOV.
--  981105  RaKu  Added function Get_Valid_To_Date.
--  981102  RaKu  Removed obsolete methods Adjust_Price_List, Copy_Price_List,
--                Count_Records_In_Price_List and Get_Current_Price.
--  981026  RaKu  Added function Is_Valid.
--  981016  RaKu  Created
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------

db_part_based_       CONSTANT VARCHAR2(10) := Sales_Price_Group_Type_API.db_part_based;

db_unit_based_       CONSTANT VARCHAR2(10) := Sales_Price_Group_Type_API.db_unit_based;


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

PROCEDURE Get_Valid_Assort_Price_List___ (
   customer_level_db_   OUT    VARCHAR2,
   customer_level_id_   OUT    VARCHAR2,
   price_list_no_       IN OUT VARCHAR2,
   contract_            IN     VARCHAR2,
   catalog_no_          IN     VARCHAR2,
   customer_no_         IN     VARCHAR2,
   currency_code_       IN     VARCHAR2,
   price_uom_           IN     VARCHAR2,
   effectivity_date_    IN     DATE,
   price_qty_due_       IN     NUMBER DEFAULT NULL   )
IS
   sales_price_group_id_       VARCHAR2(10);
   cust_price_group_id_        VARCHAR2(10);
   sales_price_group_type_     VARCHAR2(10);
   company_                    VARCHAR2(20);
   assortment_node_id_         VARCHAR2(50);
   found_assort_price_list     EXCEPTION;
   prnt_cust_                  CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   hierarchy_id_               CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   cust_price_list_no_         SALES_PRICE_LIST_TAB.price_list_no%TYPE;
   temp_cust_plist_no_         SALES_PRICE_LIST_TAB.price_list_no%TYPE;
   cust_pref_price_list_no_    SALES_PRICE_LIST_TAB.price_list_no%TYPE;
   temp_cust_pref_plist_no_    SALES_PRICE_LIST_TAB.price_list_no%TYPE;
   sales_price_list_rec_       SALES_PRICE_LIST_TAB%ROWTYPE;

   CURSOR get_assort_based (assortment_id_ IN VARCHAR)IS
        SELECT assortment_node_id
        FROM   assortment_node_tab t
        WHERE EXISTS (SELECT 1 
                      FROM   sales_price_list_assort_tab splat
                      WHERE  splat.assortment_id = t.assortment_id
                      AND    splat.assortment_node_id = t.assortment_node_id
                      AND    splat.price_list_no = price_list_no_
                      AND    splat.price_unit_meas = price_uom_
                      AND    TRUNC(splat.valid_from_date) <= effectivity_date_
                      )
        START WITH        t.assortment_id = assortment_id_
               AND        t.assortment_node_id = catalog_no_
        CONNECT BY PRIOR  t.assortment_id = t.assortment_id
               AND PRIOR  t.parent_node = t.assortment_node_id;

BEGIN

   company_      := Site_API.Get_Company(contract_);
   hierarchy_id_ := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);

   sales_price_group_id_    := Sales_Part_API.Get_Sales_Price_Group_Id(contract_, catalog_no_);
   cust_price_list_no_      := Customer_Pricelist_API.Get_Price_List_No(customer_no_, 
                                                                        sales_price_group_id_, 
                                                                        currency_code_);
   cust_pref_price_list_no_ := Customer_Pricelist_API.Get_Preferred_Price_List(customer_no_, sales_price_group_id_);
   
   IF (price_list_no_ IS NOT NULL) THEN
      IF NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_) THEN
         price_list_no_ := NULL;   
      END IF;
   END IF;
   IF (price_list_no_ IS NULL) THEN
       price_list_no_ := cust_price_list_no_;
      -- IF we find a price list for the given currency, check whether it is a valid one for the date and the site.
      IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
         price_list_no_ := NULL;
      END IF;
      IF (price_list_no_ IS NULL) THEN
         price_list_no_ := cust_pref_price_list_no_;
         IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
            price_list_no_ := NULL;
         END IF;
      END IF;
   END IF;

   IF (price_list_no_ IS NOT NULL) AND 
      (price_list_no_ IN (cust_price_list_no_, cust_pref_price_list_no_)) THEN
      sales_price_list_rec_   := Get_Object_By_Keys___(price_list_no_);
      sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_list_rec_.sales_price_group_id);

      -- Check if assortment node based price list is valid for current price effective date.
      IF (Assortment_Node_API.Check_Exist(sales_price_list_rec_.assortment_id, catalog_no_) = 1) THEN
         OPEN get_assort_based(sales_price_list_rec_.assortment_id);
         FETCH get_assort_based INTO assortment_node_id_;
         IF (get_assort_based%FOUND) THEN
            CLOSE get_assort_based;
            customer_level_db_   := 'CUSTOMER';
            customer_level_id_   := customer_no_;
            RAISE found_assort_price_list;
         END IF;
         CLOSE get_assort_based;
      END IF;
   END IF;

   -------------------------------------------------------------------------------
   -- Find price list in customer hierarchy if given customer is connected to hierarchy.
   -------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN

      -- Search in hierarchy upwards to the hierarchy root customer.
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         temp_cust_plist_no_       := Customer_Pricelist_API.Get_Price_List_No(prnt_cust_, 
                                                                               sales_price_group_id_, 
                                                                               currency_code_);
         temp_cust_pref_plist_no_  := Customer_Pricelist_API.Get_Preferred_Price_List(prnt_cust_, 
                                                                                      sales_price_group_id_);
         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
               price_list_no_ := NULL;
            END IF;
         END IF;
         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_pref_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
               price_list_no_ := NULL;
            END IF;
         END IF;

         IF (price_list_no_ IS NOT NULL) AND 
            (price_list_no_ IN (temp_cust_plist_no_, temp_cust_pref_plist_no_)) THEN
            sales_price_list_rec_   := Get_Object_By_Keys___(price_list_no_);
            sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_list_rec_.sales_price_group_id);

            -- Check if assortment node based price list is valid for current price effective date.
            IF (sales_price_group_type_ = db_part_based_ AND 
                Assortment_Node_API.Is_Part_Belongs_To_Node(sales_price_list_rec_.assortment_id, catalog_no_, catalog_no_) = 1) THEN

               OPEN get_assort_based(sales_price_list_rec_.assortment_id);
               FETCH get_assort_based INTO assortment_node_id_;
               IF (get_assort_based%FOUND) THEN
                  CLOSE get_assort_based;
                  customer_level_db_   := 'HIERARCHY';
                  customer_level_id_   := prnt_cust_;
                  RAISE found_assort_price_list;
               END IF;
               CLOSE get_assort_based;
            END IF;
         END IF;

         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   --------------------------------------------------------------------------------------------------
   -- Find a valid price list on customer group if the given customer is connected to customer group.
   --------------------------------------------------------------------------------------------------
   cust_price_group_id_     := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(customer_no_);
   temp_cust_plist_no_      := Cust_Price_Group_Detail_API.Get_Price_List_No(cust_price_group_id_, 
                                                                             sales_price_group_id_, 
                                                                             currency_code_);
   temp_cust_pref_plist_no_ := Cust_Price_Group_Detail_API.Get_Preferred_Price_List(cust_price_group_id_, 
                                                                                    sales_price_group_id_);

   IF (price_list_no_ IS NULL) THEN
      price_list_no_ := temp_cust_plist_no_;
      IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
         price_list_no_ := NULL;
      END IF;
   END IF;

   IF (price_list_no_ IS NULL) THEN
      price_list_no_ := temp_cust_pref_plist_no_;
      IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
         price_list_no_ := NULL;
      END IF;
   END IF;

   IF (price_list_no_ IS NOT NULL) AND 
      (price_list_no_ IN (temp_cust_plist_no_, temp_cust_pref_plist_no_)) THEN

      sales_price_list_rec_   := Get_Object_By_Keys___(price_list_no_);
      sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_list_rec_.sales_price_group_id);

      -- Check if assortment node based price list is valid for current price effective date.
      IF (sales_price_group_type_ = db_part_based_ AND 
          Assortment_Node_API.Is_Part_Belongs_To_Node(sales_price_list_rec_.assortment_id, catalog_no_, catalog_no_) = 1) THEN

         OPEN get_assort_based(sales_price_list_rec_.assortment_id);
         FETCH get_assort_based INTO assortment_node_id_;
         IF (get_assort_based%FOUND) THEN
            CLOSE get_assort_based;
            customer_level_db_   := 'CUSTOMER_PRICE_GROUP';
            customer_level_id_   := customer_no_ || ' - ' || cust_price_group_id_;
            RAISE found_assort_price_list;
         END IF;
         CLOSE get_assort_based;
      END IF;
   END IF;

   ---------------------------------------------------------------------------------------------------
   -- Find price list on customer hierarchy price group if a given customer is connected to hierarchy.
   ---------------------------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN

      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         cust_price_group_id_      := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(prnt_cust_);

         temp_cust_plist_no_       := Cust_Price_Group_Detail_API.Get_Price_List_No(cust_price_group_id_, 
                                                                                    sales_price_group_id_, 
                                                                                    currency_code_);
         temp_cust_pref_plist_no_  := Cust_Price_Group_Detail_API.Get_Preferred_Price_List(cust_price_group_id_, 
                                                                                           sales_price_group_id_);

         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
               price_list_no_ := NULL;
            END IF;
         END IF;
         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_pref_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid_Assort(price_list_no_, contract_, catalog_no_, effectivity_date_, price_qty_due_)) THEN
               price_list_no_ := NULL;
            END IF;
         END IF;

         IF (price_list_no_ IS NOT NULL) AND
            (price_list_no_ IN (temp_cust_plist_no_, temp_cust_pref_plist_no_)) THEN

            sales_price_list_rec_   := Get_Object_By_Keys___(price_list_no_);
            sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_list_rec_.sales_price_group_id);

            -- Check if assortment node based price list is valid for current price effective date.
            IF (sales_price_group_type_ = db_part_based_ AND 
                Assortment_Node_API.Is_Part_Belongs_To_Node(sales_price_list_rec_.assortment_id, catalog_no_, catalog_no_) = 1) THEN

               OPEN get_assort_based(sales_price_list_rec_.assortment_id);
               FETCH get_assort_based INTO assortment_node_id_;
               IF (get_assort_based%FOUND) THEN
                  CLOSE get_assort_based;
                  customer_level_db_   := 'HIERARCHY_PRICE_GROUP';
                  customer_level_id_   := prnt_cust_ || ' - ' || cust_price_group_id_;
                  RAISE found_assort_price_list;
               END IF;
               CLOSE get_assort_based;
            END IF;
         END IF;

         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   -----------------------------
   -- No valid price list found.
   -----------------------------
   customer_level_db_   := NULL;
   customer_level_id_   := NULL;
EXCEPTION
   WHEN found_assort_price_list THEN
      NULL;
END Get_Valid_Assort_Price_List___;


@Override
PROCEDURE Prepare_Insert___ (
   attr_ IN OUT VARCHAR2 )
IS
   company_          VARCHAR2(20);
BEGIN
   super(attr_);
   company_          := User_Finance_API.Get_Default_Company_Func;
   Client_SYS.Add_To_Attr('OWNING_COMPANY', User_Finance_API.Get_Default_Company_Func, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_BREAK_TEMPLATES_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('AWAIT_REVIEW_DB', 'FALSE', attr_);
   Client_SYS.Add_To_Attr('DEFAULT_PERCENTAGE_OFFSET', 0, attr_);
   Client_SYS.Add_To_Attr('DEFAULT_AMOUNT_OFFSET', 0, attr_);
   Client_SYS.Add_To_Attr('SUBSCRIBE_NEW_SALES_PARTS_DB', Fnd_Boolean_API.db_false, attr_);
   Client_SYS.Add_To_Attr('USE_PRICE_INCL_TAX_DB', Company_Tax_Discom_Info_API.Get_Use_Price_Incl_Tax_Ord_Db(company_), attr_);
END Prepare_Insert___;


@Override
PROCEDURE Check_Delete___ (
   remrec_ IN SALES_PRICE_LIST_TAB%ROWTYPE )
IS
BEGIN
   -- Check if user has write access to this price list
   Check_Editable(remrec_.price_list_no);

   super(remrec_);
END Check_Delete___;


@Override
PROCEDURE Check_Insert___ (
   newrec_ IN OUT sales_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS 
   dummy_currtype_     VARCHAR2(10);
   dummy_conv_factor_  NUMBER;
   dummy_rate_         NUMBER;
BEGIN
   IF(NOT indrec_.owning_company) THEN
      newrec_.owning_company := User_Finance_API.Get_Default_Company_Func;
   END IF;

   super(newrec_, indrec_, attr_);

   IF (newrec_.assortment_id IS NOT NULL) THEN
      IF (Assortment_Structure_API.Get_Objstate(newrec_.assortment_id) != 'Active') THEN
         Error_SYS.Record_General(lu_name_, 'ASSORTNOTACTERR: Assortment :P1 connected to this sales price list is not active.', newrec_.assortment_id);
      END IF;
   END IF;

   -- Checking if the currency code has a valid currency rate for this company, this method gives an error no valid currency rate exist for this company/currency code
   Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_currtype_, dummy_conv_factor_, dummy_rate_, newrec_.owning_company, newrec_.currency_code, SYSDATE, 'CUSTOMER', NULL);

   User_Finance_API.Exist(newrec_.owning_company, Fnd_Session_API.Get_Fnd_User);

   -- Check if user has read access to Superseded Price List
   IF (newrec_.sup_price_list_no IS NOT NULL) THEN
      Check_Readable(newrec_.sup_price_list_no);
   END IF;

END Check_Insert___;


@Override
PROCEDURE Check_Update___ (
   oldrec_ IN     sales_price_list_tab%ROWTYPE,
   newrec_ IN OUT sales_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS   
   dummy_currtype_    VARCHAR2(10);
   dummy_conv_factor_ NUMBER;
   dummy_rate_        NUMBER;
BEGIN
   super(oldrec_, newrec_, indrec_, attr_);

   IF (newrec_.assortment_id IS NOT NULL) THEN
      IF (Assortment_Structure_API.Get_Objstate(newrec_.assortment_id) != 'Active') THEN
         Error_SYS.Record_General(lu_name_, 'ASSORTNOTACTERR: Assortment :P1 connected to this sales price list is not active.', newrec_.assortment_id);
      END IF;
   END IF;
   IF (NVL(oldrec_.assortment_id, Database_SYS.string_null_) != NVL(newrec_.assortment_id, Database_SYS.string_null_)) THEN
      IF Get_Id_In_Assort_Lines(newrec_.price_list_no) IS NOT NULL THEN
         Error_SYS.Record_General(lu_name_, 'ASSORTNOTMODFY: You cannot modify or delete an assortment ID with an assortment node-based line attached to it.');
      END IF;
   END IF;
      
   IF (oldrec_.use_price_incl_tax != newrec_.use_price_incl_tax) THEN
      Sales_Price_List_Part_API.Modify_Sales_Prices(newrec_.price_list_no, newrec_.use_price_incl_tax);
   END IF;
   -- Checking if the currency code has a valid currency rate for this company, this method gives an error no valid currency rate exist for this company/currency code
   Invoice_Library_API.Get_Currency_Rate_Defaults(dummy_currtype_, dummy_conv_factor_, dummy_rate_, newrec_.owning_company, newrec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
   -- Check if user has write access to this price list
   Check_Editable(newrec_.price_list_no);
   -- Check if user has read access to Superseded Price List
   IF (newrec_.sup_price_list_no IS NOT NULL) THEN
      Check_Readable(newrec_.sup_price_list_no);
   END IF;
END Check_Update___;

PROCEDURE Check_Sup_Price_List_No_Ref___ (
   newrec_ IN OUT NOCOPY sales_price_list_tab%ROWTYPE )
IS   
BEGIN
   IF (newrec_.sup_price_list_no IS NOT NULL) THEN
      IF (newrec_.sup_price_list_no = newrec_.price_list_no) THEN
         Error_SYS.Record_General(lu_name_,
            'NOT_SAME_PRICELST: The field Superseded Price List can not point to the current price list!');
      ELSE
         Exist(newrec_.sup_price_list_no);
      END IF;
   END IF;
END Check_Sup_Price_List_No_Ref___;


-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------

-- Copy__
--   Copies records from a price list to another that are valid on the specified date.
--   Returns number of records copied.
--   OR will create a new price list header and will copy all the valid parts,
--   units and assortment lines, and also the valid sites for the similar companies.
PROCEDURE Copy__ (
   copied_items_               OUT NUMBER,
   raise_msg_                  OUT VARCHAR2,
   price_list_no_              IN  VARCHAR2,
   valid_from_date_            IN  DATE,
   to_company_                 IN  VARCHAR2,
   to_price_list_no_           IN  VARCHAR2,
   to_price_list_desc_         IN  VARCHAR2,
   to_currency_code_           IN  VARCHAR2, 
   to_assortment_id_           IN  VARCHAR2,  
   to_valid_from_date_         IN  DATE,
   currency_rate_              IN  NUMBER,
   copy_method_                IN  VARCHAR2,
   include_period_             IN  VARCHAR2 )
IS
   price_list_rec_          Public_Rec;
   to_price_list_rec_       Public_Rec;
   to_currency_rate_        NUMBER;
   currtype_                VARCHAR2(10);
   conv_factor_             NUMBER;
   rate_                    NUMBER;
   counter_                 NUMBER := 0;
   newrec_                  SALES_PRICE_LIST_TAB%ROWTYPE;
BEGIN

   IF NOT Check_Exist___(price_list_no_) THEN
      Error_SYS.Record_General(lu_name_, 'LIST_NOT_EXIST: Price list :P1 does not exist.', price_list_no_);
   END IF;

   Check_Readable(price_list_no_);

   IF (to_valid_from_date_ IS NOT NULL) AND (valid_from_date_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'VALID_FROM_DATE: The Valid From must be entered on the source price list when using Valid From on the destination price list.');
   END IF;
   
   --retrive the copy from price list details.
   price_list_rec_ := Get(price_list_no_);
   
   -- when copy_method_ = 'MODIFY' modify an existing price list no by adding the lines
   IF copy_method_ = 'MODIFY' THEN
      IF NOT Check_Exist___(to_price_list_no_) THEN 
         Error_SYS.Record_General(lu_name_, 'LIST_NOT_EXIST: Price list :P1 does not exist.', to_price_list_no_);
      END IF;
      to_price_list_rec_ := Get(to_price_list_no_);
      -- this error is only raised for the modify method, since when creating a new sales price list
      -- it's obvious that we need to create the sales price list for the same sales price group.
      IF (price_list_rec_.sales_price_group_id != to_price_list_rec_.sales_price_group_id) THEN
         Error_SYS.Record_General(lu_name_, 'DIFF_PRICE_GROUP: The price lists must have the same price groups.');
      END IF;
      IF (price_list_rec_.use_price_incl_tax != to_price_list_rec_.use_price_incl_tax) THEN
         Error_SYS.Record_General(lu_name_, 'USEPRICEINCLTAX: Destination price list must have the same price including tax setting as the source price list.');
      END IF;
   -- when copy_method_ = 'NEW' Copy to a new sales price list no   
   ELSE
      -- IF the new price list no given is an already existing one then raise error
      IF Check_Exist___(to_price_list_no_) THEN
         Error_SYS.Record_General(lu_name_, 'LIST_ALREADY_EXIST: Copy to Price list :P1 already exist.', to_price_list_no_);
      END IF;
      -- create new sales price list header
      newrec_.price_list_no := to_price_list_no_;
      newrec_.description := to_price_list_desc_;
      newrec_.owning_company := to_company_;
      newrec_.sales_price_group_id := price_list_rec_.sales_price_group_id;
      newrec_.currency_code := to_currency_code_;
      newrec_.assortment_id :=  to_assortment_id_;
      newrec_.use_price_break_templates := price_list_rec_.use_price_break_templates;
      newrec_.await_review := price_list_rec_.await_review;
      newrec_.default_base_price_site := price_list_rec_.default_base_price_site;
      newrec_.default_percentage_offset := price_list_rec_.default_percentage_offset;
      newrec_.default_amount_offset := price_list_rec_.default_amount_offset;
      newrec_.subscribe_new_sales_parts := price_list_rec_.subscribe_new_sales_parts;
      newrec_.rounding := price_list_rec_.rounding;      
      newrec_.use_price_incl_tax := price_list_rec_.use_price_incl_tax;
      IF (price_list_rec_.valid_to_date IS NOT NULL) THEN
         IF (valid_from_date_ IS NOT NULL AND valid_from_date_ <= price_list_rec_.valid_to_date) OR
            (valid_from_date_ IS NULL) THEN
            newrec_.valid_to_date := price_list_rec_.valid_to_date;
         END IF;
      END IF;

      New___(newrec_);
      
      -- now since the new price list header is created, copy to the new price list.       
      to_price_list_rec_ := Get(to_price_list_no_); 
      
      Sales_Price_List_Site_API.Copy_Price_List_Sites__(price_list_no_, to_price_list_no_);
      
   END IF;
   
   -- if we are going to modify the client to give a currency rate as it is done in Customer Agreement
   -- then we need to run the following block when that currency rate is null...
   IF (price_list_rec_.currency_code = to_price_list_rec_.currency_code) THEN
      to_currency_rate_ := 1;
   ELSIF (currency_rate_ IS NULL) THEN
      Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, price_list_rec_.owning_company, price_list_rec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
      -- Currency rate for Source price lists's currency to base currency
      to_currency_rate_ := rate_ / conv_factor_;
      Invoice_Library_API.Get_Currency_Rate_Defaults(currtype_, conv_factor_, rate_, price_list_rec_.owning_company, to_price_list_rec_.currency_code, SYSDATE, 'CUSTOMER', NULL);
      -- Currence rate for new price list's currency from Source price list's currency
      to_currency_rate_ := to_currency_rate_ * conv_factor_ / rate_ ;
   ELSE
      to_currency_rate_ := currency_rate_;
   END IF;

   copied_items_ := 0;

   IF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(price_list_rec_.sales_price_group_id) = db_part_based_) THEN
      -- Part Based.
      Trace_SYS.Message('Part Based');
      -- Copy part based price list lines.
      Sales_Price_List_Part_API.Copy__(counter_,
                                       raise_msg_,
                                       price_list_no_,
                                       valid_from_date_,
                                       to_currency_rate_,
                                       to_price_list_rec_.rounding,
                                       to_price_list_no_,
                                       to_valid_from_date_,
                                       include_period_);
      copied_items_ := counter_;
       
      -- if the assortments are different no point in copying the assortment data.
      IF price_list_rec_.assortment_id IS NOT NULL AND price_list_rec_.assortment_id = to_price_list_rec_.assortment_id THEN
         -- Copy assortment node based price list lines.
         Sales_Price_List_Assort_API.Copy__(counter_,
                                            raise_msg_,
                                            price_list_no_,
                                            valid_from_date_,
                                            to_currency_rate_,
                                            to_price_list_rec_.rounding,
                                            to_price_list_no_,
                                            to_valid_from_date_,
                                            include_period_);
         copied_items_ := copied_items_ + counter_;
      END IF;
   ELSE
      -- Unit Based.
      Trace_SYS.Message('Unit Based');

      -- Copy unit based price list lines.
      Sales_Price_List_Unit_API.Copy__(counter_,
                                       raise_msg_,
                                       price_list_no_,
                                       valid_from_date_,
                                       to_currency_rate_,
                                       to_price_list_rec_.rounding,
                                       to_price_list_no_,
                                       to_valid_from_date_,
                                       include_period_);
      copied_items_ := counter_;
   END IF;      
END Copy__;


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------

-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Get_Control_Type_Value_Desc
--   Retreive the control type description used in accounting.
--   Used by accounting
PROCEDURE Get_Control_Type_Value_Desc (
   desc_           OUT VARCHAR2,
   owning_company_ IN  VARCHAR2,
   value_          IN  VARCHAR2 )
IS
BEGIN
   desc_ := Get_Description(value_);
END Get_Control_Type_Value_Desc;


-- Is_Valid
--   Returns TRUE if price_list_no is valid for specified contract and currency.
@UncheckedAccess
FUNCTION Is_Valid (
   price_list_no_       IN VARCHAR2,
   contract_            IN VARCHAR2,
   catalog_no_          IN VARCHAR2,
   effectivity_date_    IN DATE     DEFAULT NULL,
   sales_price_type_db_ IN VARCHAR2 DEFAULT Sales_Price_Type_API.DB_SALES_PRICES,
   price_qty_due_       IN NUMBER   DEFAULT NULL) RETURN BOOLEAN
IS
   date_             DATE;
   valid_to_date_    DATE;
   valid_            BOOLEAN;
   exist_            NUMBER := 0;
      
   CURSOR get_part_based IS
     SELECT 1
     FROM   sales_price_list_part_tab
     WHERE  price_list_no = price_list_no_
     AND    catalog_no = catalog_no_
     AND    valid_from_date <= date_
     AND    rowstate = 'Active'
     AND    sales_price_type = sales_price_type_db_
     AND    (min_quantity <= price_qty_due_ OR price_qty_due_ IS NULL );

   CURSOR get_unit_based IS
     SELECT 1
     FROM   sales_price_list_unit_tab
     WHERE  price_list_no = price_list_no_
     AND    valid_from_date <= date_
     AND    (min_quantity <= price_qty_due_ OR price_qty_due_ IS NULL );
BEGIN
   IF (effectivity_date_ IS NULL)  THEN
       date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
       date_ := effectivity_date_;
   END IF;
   valid_to_date_ := Get_Valid_To_Date(price_list_no_);
   IF (valid_to_date_ IS NOT NULL) AND (valid_to_date_ < date_) THEN
      -- Price list not valid.
      valid_ := FALSE;
   ELSIF (NOT Sales_Price_List_Site_API.Check_Exist(contract_, price_list_no_)) THEN
      -- Return whether or not price list is valid on specified site.
      valid_ := FALSE;
   ELSE
      -- Check if part based price list is valid for current sales part.
      IF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(
          Sales_Price_List_API.Get_Sales_Price_Group_Id(price_list_no_)) = 'PART BASED') THEN
         OPEN get_part_based;
         FETCH get_part_based INTO exist_;
         CLOSE get_part_based;              
      ELSE
         -- Check if unit based price list is valid for current price effective date.
         OPEN get_unit_based;
         FETCH get_unit_based INTO exist_;
         CLOSE get_unit_based;
      END IF;
      IF (exist_ != 1) THEN
         valid_ := FALSE;
      ELSE
        valid_ := TRUE;
      END IF;
   END IF;
   
   RETURN valid_;
END Is_Valid;


-- Is_Valid_Assort
--   Returns TRUE if price_list_no is valid for a specific part in an assortment
@UncheckedAccess
FUNCTION Is_Valid_Assort (
   price_list_no_    IN VARCHAR2,
   contract_         IN VARCHAR2,
   catalog_no_       IN VARCHAR2,
   effectivity_date_ IN DATE DEFAULT NULL,
   price_qty_due_    IN NUMBER DEFAULT NULL) RETURN BOOLEAN
IS
   date_             DATE;
   valid_to_date_    DATE;
   valid_            BOOLEAN;
   exist_            NUMBER := 0;
   assortment_id_    VARCHAR2(50);   
   
   CURSOR get_assort_based (assortment_id_ IN VARCHAR)IS
        SELECT 1
        FROM   assortment_node_tab t
        WHERE EXISTS (SELECT 1 
                      FROM   sales_price_list_assort_tab splat
                      WHERE  splat.assortment_id = t.assortment_id
                      AND    splat.assortment_node_id = t.assortment_node_id
                      AND    splat.price_list_no = price_list_no_
                      AND    TRUNC(splat.valid_from_date) <= date_
                      AND    (min_quantity <= price_qty_due_ OR price_qty_due_ IS NULL ))
        START WITH        t.assortment_id = assortment_id_
               AND        t.assortment_node_id = catalog_no_
        CONNECT BY PRIOR  t.assortment_id = t.assortment_id
        AND PRIOR  t.parent_node = t.assortment_node_id;   
BEGIN
   IF (effectivity_date_ IS NULL)  THEN
       date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
       date_ := effectivity_date_;
   END IF;
   valid_to_date_ := Get_Valid_To_Date(price_list_no_);
   IF (valid_to_date_ IS NOT NULL) AND (valid_to_date_ < date_) THEN
      -- Price list not valid.
      valid_ := FALSE;
   ELSIF (NOT Sales_Price_List_Site_API.Check_Exist(contract_, price_list_no_)) THEN
      -- Return whether or not price list is valid on specified site.
      valid_ := FALSE;  
   ELSE      
      assortment_id_ := Sales_Price_List_API.Get_Assortment_Id(price_list_no_);     
      IF assortment_id_ IS NOT NULL THEN
         OPEN get_assort_based(assortment_id_);
         FETCH get_assort_based INTO exist_;
         CLOSE get_assort_based;       
      END IF;
   END IF;
   
   IF (exist_ != 1) THEN
      valid_ := FALSE;
   ELSE
      valid_ := TRUE;
   END IF;  
   
   RETURN valid_;
END Is_Valid_Assort;


-- Is_Exist_Price_List
--   Check whether a given sales price group being connected to a price list.
@UncheckedAccess
FUNCTION Is_Exist_Price_List (
   sales_price_group_id_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_  INTEGER;
   CURSOR check_exist IS
      SELECT 1
      FROM SALES_PRICE_LIST_TAB
      WHERE sales_price_group_id = sales_price_group_id_ ;
BEGIN
   OPEN check_exist;
   FETCH check_exist INTO temp_;
   IF (check_exist%FOUND) THEN
      CLOSE check_exist;
      RETURN('TRUE');
   END IF;
   CLOSE check_exist;
   RETURN('FALSE');
END Is_Exist_Price_List;


-- Check_Repeated_Items
--   Returns 1 if there exists more than one sales price list part connected
--   to the same sales part for a given price list. Else returns 0.
@UncheckedAccess
FUNCTION Check_Repeated_Items (
   price_list_no_ IN VARCHAR2,
   catalog_no_    IN VARCHAR2 ) RETURN NUMBER
IS
   no_of_recs_ NUMBER;
   CURSOR get_no_of_recs IS
      SELECT COUNT (1)
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no    = catalog_no_ ;
BEGIN
   OPEN get_no_of_recs;
   FETCH get_no_of_recs INTO no_of_recs_;
   CLOSE get_no_of_recs;

   IF (no_of_recs_ > 1) THEN
      RETURN 1;
   END IF;
   RETURN 0;
END Check_Repeated_Items;


-- Get_Id_In_Assort_Lines
--   This will return the assortment id if there are records found on SalesPriceListAssort.
@UncheckedAccess
FUNCTION Get_Id_In_Assort_Lines (
   price_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ sales_price_list_assort_tab.assortment_id%TYPE;
   CURSOR get_attr IS
      SELECT assortment_id
      FROM sales_price_list_assort_tab
      WHERE price_list_no = price_list_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Id_In_Assort_Lines;


-- Check_Records_Exist_Per_Assort
--   This will check whether records exist with the given Assortment ID and return 1 or 0 accordingly.
@UncheckedAccess
FUNCTION Check_Records_Exist_Per_Assort (
   assortment_id_ IN VARCHAR2 ) RETURN NUMBER
IS
   dummy_ NUMBER;
   CURSOR exist_records IS
      SELECT count(*)
      FROM   SALES_PRICE_LIST_TAB
      WHERE  assortment_id = assortment_id_;

BEGIN
   OPEN exist_records;
   FETCH exist_records INTO dummy_;
   CLOSE exist_records;

   IF (dummy_ > 0) THEN
      dummy_ := 1;
   END IF;

   RETURN dummy_;
END Check_Records_Exist_Per_Assort;


PROCEDURE Get_Valid_Price_List (
   customer_level_db_   OUT    VARCHAR2,
   customer_level_id_   OUT    VARCHAR2,
   price_list_no_       IN OUT VARCHAR2,
   contract_            IN     VARCHAR2,
   catalog_no_          IN     VARCHAR2,
   customer_no_         IN     VARCHAR2,
   currency_code_       IN     VARCHAR2,
   effectivity_date_    IN     DATE,
   price_qty_due_       IN     NUMBER,
   sales_price_type_db_ IN     VARCHAR2 DEFAULT Sales_Price_Type_API.DB_SALES_PRICES )
IS
   sales_price_group_id_       VARCHAR2(10);
   cust_price_group_id_        VARCHAR2(10);
   sales_price_group_type_     VARCHAR2(10);
   date_                       DATE;
   temp_cust_plist_no_         SALES_PRICE_LIST_TAB.price_list_no%TYPE;
   temp_cust_pref_plist_no_    SALES_PRICE_LIST_TAB.price_list_no%TYPE;
   prnt_cust_                  CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   hierarchy_id_               CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   price_uom_                  SALES_PART_TAB.price_unit_meas%TYPE;
   found_price_list            EXCEPTION;
   valid_price_list_           BOOLEAN:= FALSE;
   temp_price_list_no_         SALES_PRICE_LIST_TAB.price_list_no%TYPE;
BEGIN
   IF (effectivity_date_ IS NULL) THEN
      date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
      date_ := effectivity_date_;
   END IF;
   
   temp_price_list_no_ := price_list_no_;

   price_uom_    := Sales_Part_API.Get_Price_Unit_Meas(contract_, catalog_no_);
   hierarchy_id_ := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);

   sales_price_group_id_    := Sales_Part_API.Get_Sales_Price_Group_Id(contract_, catalog_no_);   
   
   -----------------------------------------
   -- Check for price_list_no_ IN parameter.
   -----------------------------------------
   IF (price_list_no_ IS NOT NULL) THEN
      valid_price_list_ := Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_);           
      IF NOT valid_price_list_ THEN
         price_list_no_ := NULL;    
      END IF;        
   END IF;
   
   -----------------------------------------
   -- IF the price list no passed to this method is NULL or if that is NOT valid retrive the price list for the given currency.
   -----------------------------------------
   IF (NOT valid_price_list_) THEN
       price_list_no_ := Customer_Pricelist_API.Get_Price_List_No(customer_no_, sales_price_group_id_, currency_code_); 
       valid_price_list_ := Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_);
       IF NOT valid_price_list_ THEN
            
          price_list_no_ := NULL;   
       END IF;               
   END IF;
   
   -----------------------------------------
   -- if we cannot fetch a valid price list for the given currency now we check for a preferred price list.
   -----------------------------------------
   IF (NOT valid_price_list_) THEN
      price_list_no_ := Customer_Pricelist_API.Get_Preferred_Price_List(customer_no_, sales_price_group_id_);
      valid_price_list_ := Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_);
      IF NOT valid_price_list_ THEN
          price_list_no_ := NULL;   
      END IF; 
   END IF;
   
    
   IF (price_list_no_ IS NOT NULL) THEN
      sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_group_id_);
      -- Set customer level parameters for part based price list.
      IF (sales_price_group_type_ = db_part_based_) THEN
         customer_level_db_   := 'CUSTOMER';
         customer_level_id_   := customer_no_;
         RAISE found_price_list;         
      ELSIF (sales_price_group_type_ = db_unit_based_) THEN
         -- Set customer level parameters for unit based price list.         
         customer_level_db_   := 'CUSTOMER';
         customer_level_id_   := customer_no_;         
         RAISE found_price_list;         
      END IF;
   END IF;

   -----------------------------------------------------------------------------------------------
   -- Find a valid price list from hierarachy customer's connected price list/preferred price list
   -- if the given customer is connected to the customer hierarchy.
   -----------------------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN
      -- Search in hierarchy upwards to the hierarchy root customer.
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         temp_cust_plist_no_      := Customer_Pricelist_API.Get_Price_List_No(prnt_cust_, 
                                                                              sales_price_group_id_, 
                                                                              currency_code_);
         temp_cust_pref_plist_no_ := Customer_Pricelist_API.Get_Preferred_Price_List(prnt_cust_, 
                                                                                     sales_price_group_id_);

         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_)) THEN
              price_list_no_ := NULL;
            END IF;
         END IF;
         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_pref_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_)) THEN
               price_list_no_ := NULL;
            END IF;
         END IF;
         
         IF (price_list_no_ IS NOT NULL) AND
            (price_list_no_ IN (temp_cust_plist_no_, temp_cust_pref_plist_no_)) THEN

            sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(Get_Sales_Price_Group_Id(price_list_no_));
            -- Set customer level parameters for part based price list.
            IF (sales_price_group_type_ = db_part_based_) THEN               
               customer_level_db_   := 'HIERARCHY';
               customer_level_id_   := prnt_cust_;
               RAISE found_price_list;               
            ELSIF (sales_price_group_type_ = db_unit_based_) THEN
               -- Set customer level parameters for unit based price list.                
               customer_level_db_   := 'HIERARCHY';
               customer_level_id_   := prnt_cust_;
               RAISE found_price_list;               
            END IF;
         END IF;
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   ------------------------------------------------------------------------------------------------
   -- Find a valid price list on customer group if a given customer is connected to customer group.
   ------------------------------------------------------------------------------------------------
   cust_price_group_id_     := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(customer_no_);
   temp_cust_plist_no_      := Cust_Price_Group_Detail_API.Get_Price_List_No(cust_price_group_id_, 
                                                                             sales_price_group_id_, 
                                                                             currency_code_);
   temp_cust_pref_plist_no_ := Cust_Price_Group_Detail_API.Get_Preferred_Price_List(cust_price_group_id_, 
                                                                                    sales_price_group_id_);

   IF (price_list_no_ IS NULL) THEN
      price_list_no_ := temp_cust_plist_no_;
      IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_)) THEN
         price_list_no_ := NULL;
      END IF;
   END IF;
   IF (price_list_no_ IS NULL) THEN
      price_list_no_ := temp_cust_pref_plist_no_;
      IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_)) THEN
         price_list_no_ := NULL;
      END IF;
   END IF;

   IF (price_list_no_ IS NOT NULL) AND 
      (price_list_no_ IN (temp_cust_plist_no_, temp_cust_pref_plist_no_)) THEN
      sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(Get_Sales_Price_Group_Id(price_list_no_));

      -- Set customer level parameters for part based price list.
      IF (sales_price_group_type_ = db_part_based_) THEN         
         customer_level_db_   := 'CUSTOMER_PRICE_GROUP';
         customer_level_id_   := customer_no_ || ' - ' || cust_price_group_id_;
         RAISE found_price_list;         
      ELSIF (sales_price_group_type_ = db_unit_based_) THEN
         -- Set customer level parameters for unit based price list.
         customer_level_db_   := 'CUSTOMER_PRICE_GROUP';
         customer_level_id_   := customer_no_ || ' - ' || cust_price_group_id_;
         RAISE found_price_list;         
      END IF;
   END IF;

   --------------------------------------------------------------------------------------------------------------
   -- Find a valid price list on customer hierarchy group if a given customer is connected to customer hierarchy.
   --------------------------------------------------------------------------------------------------------------
   IF (hierarchy_id_ IS NOT NULL) THEN
      prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
      WHILE (prnt_cust_ IS NOT NULL) LOOP
         cust_price_group_id_     := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(prnt_cust_);
         temp_cust_plist_no_      := Cust_Price_Group_Detail_API.Get_Price_List_No(cust_price_group_id_, 
                                                                                   sales_price_group_id_, 
                                                                                   currency_code_);
         temp_cust_pref_plist_no_ := Cust_Price_Group_Detail_API.Get_Preferred_Price_List(cust_price_group_id_, 
                                                                                          sales_price_group_id_);

         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_)) THEN
               price_list_no_ := NULL;
            END IF;
         END IF;
         IF (price_list_no_ IS NULL) THEN
            price_list_no_ := temp_cust_pref_plist_no_;
            IF (price_list_no_ IS NOT NULL) AND (NOT Is_Valid(price_list_no_, contract_, catalog_no_, date_, sales_price_type_db_, price_qty_due_)) THEN
               price_list_no_ := NULL;
            END IF;
         END IF;

         IF (price_list_no_ IS NOT NULL) AND 
            (price_list_no_ IN (temp_cust_plist_no_, temp_cust_pref_plist_no_)) THEN
            sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(Get_Sales_Price_Group_Id(price_list_no_));

            -- Set customer level parameters for part based price list.
            IF (sales_price_group_type_ = db_part_based_) THEN
               customer_level_db_   := 'HIERARCHY_PRICE_GROUP';
               customer_level_id_   := prnt_cust_ || ' - ' || cust_price_group_id_;
               RAISE found_price_list;               
            ELSIF (sales_price_group_type_ = db_unit_based_) THEN
               -- Set customer level parameters for unit based price list.
               customer_level_db_   := 'HIERARCHY_PRICE_GROUP';
               customer_level_id_   := prnt_cust_ || ' - ' || cust_price_group_id_;
               RAISE found_price_list;               
            END IF;
         END IF;
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
      END LOOP;
   END IF;

   ----------------------------------------------------------------------------------
   -- No valid price list found. So, check for Assortment node base price list lines
   ----------------------------------------------------------------------------------
   customer_level_db_   := NULL;
   customer_level_id_   := NULL;
   
   -- If no Valid price list is found the price_list_no_ variable gets cleared making the assortment based to fetch from scratch.
   -- To mitigate that the price_list_no_ is temporarily held and passed to assortment node to be processed from the price_list_no_ that was sent from client.
   IF (price_list_no_ IS NULL) THEN 
      price_list_no_ := temp_price_list_no_;
   END IF;   
   Get_Valid_Assort_Price_List___ (customer_level_db_, customer_level_id_, price_list_no_, contract_, 
                                   catalog_no_, customer_no_, currency_code_, price_uom_, date_, price_qty_due_);
   
   RAISE found_price_list;
EXCEPTION
   WHEN found_price_list THEN
        Trace_SYS.Field('Price List No >> ', price_list_no_);
        Trace_SYS.Field('Price List Customer Level >> ', customer_level_db_);
        Trace_SYS.Field('Price List Customer Level Id >> ', customer_level_id_);
END Get_Valid_Price_List;


-- Find_Price_On_Pricelist
--   Retrieve price, discount_type and discount for specified price_list_no, catalog_no, quantity and duration.
PROCEDURE Find_Price_On_Pricelist (
   price_                   OUT NUMBER,
   price_incl_tax_          OUT NUMBER,
   discount_type_           OUT VARCHAR2,
   discount_                OUT NUMBER,
   part_level_db_           OUT VARCHAR2,
   part_level_id_           OUT VARCHAR2,
   price_list_no_           IN  VARCHAR2,
   catalog_no_              IN  VARCHAR2,
   price_qty_due_           IN  NUMBER,
   effectivity_date_        IN  DATE,
   price_uom_               IN  VARCHAR2,
   rental_chargable_days_   IN  NUMBER  DEFAULT NULL)
IS
   min_quantity_         NUMBER;
   min_duration_         NUMBER;
   valid_from_date_      DATE;
   price_found_          NUMBER;
   price_incl_tax_found_ NUMBER;
   discount_type_found_  VARCHAR2(25);
   discount_found_       NUMBER;
   base_price_site_      VARCHAR2(5);
   date_                 DATE;
   assortment_id_        VARCHAR2(50);
   assortment_node_id_   VARCHAR2(50);
   sales_price_list_rec_ Public_Rec;
   
   CURSOR find_part_based_min_qty IS
      SELECT MAX(min_quantity), min_duration
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(NVL(valid_to_date, Database_SYS.Get_Last_Calendar_Date())) >= TRUNC(date_)
      AND    min_quantity <= price_qty_due_
      AND    rowstate = 'Active'
      AND    sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES
      GROUP BY min_duration;
   
   CURSOR find_part_based_from_period IS
      SELECT valid_from_date
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    rowstate = 'Active'
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(valid_to_date) >= TRUNC(date_)
      AND    valid_to_date IS NOT NULL
      AND    sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES;
   
   CURSOR find_part_based_from_null_end IS
      SELECT MAX(valid_from_date)
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    rowstate = 'Active'      
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    valid_to_date IS NULL      
      AND    sales_price_type = Sales_Price_Type_API.DB_SALES_PRICES;
 
   CURSOR find_rental_parts_min_qty IS
      SELECT MAX(min_quantity), min_duration
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(NVL(valid_to_date, Database_SYS.Get_Last_Calendar_Date())) >= TRUNC(date_)
      AND    rowstate = 'Active'
      AND    sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES
      AND    min_duration <= rental_chargable_days_
      AND    min_quantity <= price_qty_due_
      GROUP BY min_duration, min_quantity
      ORDER BY min_quantity DESC , min_duration DESC;   
   
   CURSOR find_rental_parts_from_period IS
      SELECT valid_from_date
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    rowstate = 'Active'
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(valid_to_date) >= TRUNC(date_)
      AND    valid_to_date IS NOT NULL
      AND    sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES;
   
   CURSOR find_rent_parts_from_null_end IS
      SELECT MAX(valid_from_date)
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    rowstate = 'Active'      
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    valid_to_date IS NULL
      AND    sales_price_type = Sales_Price_Type_API.DB_RENTAL_PRICES;
  
   CURSOR find_unit_based_min_qty IS
      SELECT MAX(min_quantity)
      FROM   SALES_PRICE_LIST_UNIT_TAB
      WHERE  price_list_no = price_list_no_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(NVL(valid_to_date, Database_SYS.Get_Last_Calendar_Date())) >= TRUNC(date_)    
      AND    min_quantity <= price_qty_due_;
   
   CURSOR find_unit_based_from_period(min_quantity_ IN NUMBER) IS
      SELECT valid_from_date
      FROM   SALES_PRICE_LIST_UNIT_TAB
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(valid_to_date) >= TRUNC(date_)
      AND    valid_to_date IS NOT NULL;
   
   CURSOR find_unit_based_from_null_end(min_quantity_ IN NUMBER) IS
      SELECT MAX(valid_from_date)
      FROM   SALES_PRICE_LIST_UNIT_TAB
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    valid_to_date IS NULL;
      
   CURSOR get_part_based_attributes IS
      SELECT GREATEST(0, ROUND(sales_price, NVL(rounding,20))),
             GREATEST(0, ROUND(sales_price_incl_tax, NVL(rounding,20))),
             discount_type, discount, base_price_site
      FROM   SALES_PRICE_LIST_PART_TAB
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_
      AND    min_duration = min_duration_
      AND    rowstate = 'Active';

   CURSOR get_unit_based_attributes IS
      SELECT ROUND(sales_price, NVL(rounding,20)), discount_type, discount
      FROM   SALES_PRICE_LIST_UNIT_TAB
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = valid_from_date_;

   -- To traverse through the tree starting from the leaf node(catalog number)
   CURSOR get_node_in_price_list IS
      SELECT t.assortment_node_id
      FROM ASSORTMENT_NODE_TAB t
      WHERE EXISTS (SELECT 1 FROM SALES_PRICE_LIST_ASSORT_TAB splat
                             WHERE splat.assortment_id = t.assortment_id
                             AND splat.assortment_node_id = t.assortment_node_id
                             AND splat.price_list_no = price_list_no_
                             AND splat.price_unit_meas = price_uom_
                             AND TRUNC(splat.valid_from_date) <= date_
                             AND TRUNC(NVL(splat.valid_to_date, Database_SYS.Get_Last_Calendar_Date())) >= TRUNC(date_)
                    )
      START WITH        t.assortment_id = assortment_id_
             AND        t.assortment_node_id = catalog_no_
      CONNECT BY PRIOR  t.assortment_id = t.assortment_id
             AND PRIOR  t.parent_node = t.assortment_node_id;

   -- Search for the correct quantity range within the valid period. 
   CURSOR find_assort_min_qty(assort_node_id_ IN VARCHAR2) IS
      SELECT MAX(min_quantity)
      FROM   SALES_PRICE_LIST_ASSORT_TAB
      WHERE  assortment_id = assortment_id_
      AND    price_list_no = price_list_no_
      AND    assortment_node_id = assort_node_id_
      AND    TRUNC(valid_from_date) <= TRUNC(NVL(date_, SYSDATE))
      AND    TRUNC(NVL(valid_to_date, Database_SYS.Get_Last_Calendar_Date())) >= TRUNC(NVL(date_, SYSDATE))
      AND    price_unit_meas = price_uom_
      AND    min_quantity <= price_qty_due_;
      
   CURSOR find_assort_from_period(assort_node_id_ IN VARCHAR2, min_quantity_ NUMBER) IS
      SELECT valid_from_date
      FROM   SALES_PRICE_LIST_ASSORT_TAB
      WHERE  price_list_no = price_list_no_
      AND    assortment_id = assortment_id_
      AND    min_quantity = min_quantity_
      AND    price_unit_meas = price_uom_
      AND    assortment_node_id = assort_node_id_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    TRUNC(valid_to_date) >= TRUNC(date_)
      AND    valid_to_date IS NOT NULL;   
      
   CURSOR find_assort_from_null_end(assort_node_id_ IN VARCHAR2, min_quantity_ NUMBER) IS
      SELECT MAX(valid_from_date)
      FROM   SALES_PRICE_LIST_ASSORT_TAB
      WHERE  price_list_no = price_list_no_
      AND    assortment_id = assortment_id_
      AND    min_quantity = min_quantity_
      AND    price_unit_meas = price_uom_
      AND    assortment_node_id = assort_node_id_
      AND    TRUNC(valid_from_date) <= TRUNC(date_)
      AND    valid_to_date IS NULL;
      
   -- Price detail from correct node
   CURSOR get_assort_based_attributes IS
      SELECT ROUND(sales_price, NVL(rounding,20)), discount_type, discount, assortment_id
      FROM   SALES_PRICE_LIST_ASSORT_TAB
      WHERE  price_list_no = price_list_no_
      AND    min_quantity = min_quantity_
      AND    assortment_node_id = assortment_node_id_
      AND    valid_from_date = valid_from_date_
      AND    price_unit_meas = price_uom_;
BEGIN
   
   -- date_ comes from calling routine in quotation
   IF (effectivity_date_ IS NULL)  THEN
       date_ := TRUNC(Site_API.Get_Site_Date(User_Default_API.Get_Contract));
   ELSE
       date_ := effectivity_date_;
   END IF;

   sales_price_list_rec_ := Get(price_list_no_);

   IF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_list_rec_.sales_price_group_id) = db_part_based_ ) THEN
      -- Only Part based sales prices are considered. 
      IF (rental_chargable_days_ IS NULL) THEN
         OPEN find_part_based_min_qty;
         FETCH find_part_based_min_qty INTO min_quantity_, min_duration_;
         CLOSE find_part_based_min_qty;
         IF (min_quantity_ IS NOT NULL) THEN
            OPEN find_part_based_from_period;
            FETCH find_part_based_from_period INTO valid_from_date_;
            CLOSE find_part_based_from_period;
         END IF;
         IF (valid_from_date_ IS NULL) THEN
            OPEN find_part_based_from_null_end;
            FETCH find_part_based_from_null_end INTO valid_from_date_;
            CLOSE find_part_based_from_null_end;
         END IF;
      ELSE
         OPEN  find_rental_parts_min_qty;
         FETCH find_rental_parts_min_qty INTO min_quantity_, min_duration_;
         CLOSE find_rental_parts_min_qty;
         IF (min_quantity_ IS NOT NULL) THEN
            OPEN find_rental_parts_from_period;
            FETCH find_rental_parts_from_period INTO valid_from_date_;
            CLOSE find_rental_parts_from_period;
         END IF;
         IF (valid_from_date_ IS NULL) THEN
            OPEN find_rent_parts_from_null_end;
            FETCH find_rent_parts_from_null_end INTO valid_from_date_;
            CLOSE find_rent_parts_from_null_end;
         END IF;
      END IF;  
      IF (min_quantity_ IS NULL AND rental_chargable_days_ IS NULL)THEN
         assortment_id_ := sales_price_list_rec_.assortment_id;

         FOR rec_ IN get_node_in_price_list LOOP
            OPEN find_assort_min_qty(rec_.assortment_node_id);
            FETCH find_assort_min_qty INTO min_quantity_;
            CLOSE find_assort_min_qty;

            IF (min_quantity_ IS NOT NULL) THEN
               OPEN find_assort_from_period(rec_.assortment_node_id, min_quantity_);
               FETCH find_assort_from_period INTO valid_from_date_;
               CLOSE find_assort_from_period;
               IF (valid_from_date_ IS NULL) THEN
                   OPEN find_assort_from_null_end(rec_.assortment_node_id, min_quantity_);
                   FETCH find_assort_from_null_end INTO valid_from_date_;
                   CLOSE find_assort_from_null_end;
               END IF;
               assortment_node_id_ := rec_.assortment_node_id;
               OPEN  get_assort_based_attributes;
               FETCH get_assort_based_attributes INTO price_found_, discount_type_found_, discount_found_, assortment_id_;
               CLOSE get_assort_based_attributes;
               price_incl_tax_found_ := price_found_;
            END IF;
            part_level_db_       := 'ASSORTMENT';
            part_level_id_       := assortment_id_ || ' - ' ||  assortment_node_id_;
            EXIT WHEN min_quantity_ IS NOT NULL;
         END LOOP;
      ELSE    
         IF (min_quantity_ IS NOT NULL) THEN 
            Trace_SYS.Message('Found part based');
            OPEN  get_part_based_attributes;
            FETCH get_part_based_attributes INTO price_found_, price_incl_tax_found_, discount_type_found_, discount_found_, base_price_site_;
            CLOSE get_part_based_attributes;

            IF Sales_Part_API.Get_Sales_Price_Group_Id(base_price_site_, catalog_no_) != sales_price_list_rec_.sales_price_group_id THEN
               -- Price group missmatch.
               price_found_ := NULL;
               price_incl_tax_found_ := NULL;
               discount_type_found_ := NULL;
               discount_found_ := NULL;
            END IF;
            part_level_db_       := 'PART';
            part_level_id_       := catalog_no_;
         END IF;
      END IF;
   ELSE
      -- Unit based
      OPEN  find_unit_based_min_qty;
      FETCH find_unit_based_min_qty INTO min_quantity_;
      CLOSE find_unit_based_min_qty;
      IF min_quantity_ IS NOT NULL THEN
         OPEN find_unit_based_from_period(min_quantity_);
         FETCH find_unit_based_from_period INTO valid_from_date_;
         CLOSE find_unit_based_from_period;
         IF (valid_from_date_ IS NULL) THEN
            OPEN find_unit_based_from_null_end(min_quantity_);
            FETCH find_unit_based_from_null_end INTO valid_from_date_;
            CLOSE find_unit_based_from_null_end;
         END IF;
         
         Trace_SYS.Message('Found unit based');
         OPEN  get_unit_based_attributes;
         FETCH get_unit_based_attributes INTO price_found_, discount_type_found_, discount_found_;
         CLOSE get_unit_based_attributes;
         price_incl_tax_found_ := price_found_;
      END IF;
      part_level_db_       := 'UNIT';
      part_level_id_       := price_uom_;
   END IF;

   Trace_SYS.Field('Price List No', price_list_no_);
   Trace_SYS.Field('Sales Part No', catalog_no_);
   Trace_SYS.Field('Min Quantity', min_quantity_);
   Trace_SYS.Field('Valid From Date', valid_from_date_);
   Trace_SYS.Field('Effectivity Date', date_);

   Trace_SYS.Field('Price', price_found_);
   Trace_SYS.Field('Price Incl Tax', price_incl_tax_found_);
   Trace_SYS.Field('Discount Type', discount_type_found_);
   Trace_SYS.Field('Discount', discount_found_);
   price_ := price_found_;
   price_incl_tax_ := price_incl_tax_found_;
   discount_type_ := discount_type_found_;
   discount_ := discount_found_;
END Find_Price_On_Pricelist;


PROCEDURE Check_Editable (
   price_list_no_ IN VARCHAR2 )
IS
BEGIN

   IF(Get_Editable(price_list_no_) != 'TRUE') THEN
      Error_SYS.Record_General(lu_name_,'COMPANYNOMODIFY: The sales price list :P1 cannot be modified because the user :P2 is not connected to the owning company :P3.',
                               price_list_no_, Fnd_Session_API.Get_Fnd_User, Get_Owning_Company(price_list_no_));   
   END IF;
END Check_Editable;


PROCEDURE Check_Readable (
   price_list_no_ IN VARCHAR2 )
IS
   temp_ NUMBER;
   CURSOR is_readable IS
      SELECT 1 
      FROM SALES_PRICE_LIST_AUTH_READ
      WHERE price_list_no = price_list_no_;
BEGIN

   OPEN is_readable;
   FETCH is_readable INTO temp_;
   IF(is_readable%NOTFOUND) THEN
      CLOSE is_readable;
      Error_SYS.Record_General(lu_name_,'COMPANYNOREAD: The sales price list :P1 cannot be accessed by the user :P2. The user is not connected to the owning company :P3 or any of the valid sites of the sales price list.',
                               price_list_no_, Fnd_Session_API.Get_Fnd_User, Get_Owning_Company(price_list_no_));   
   END IF;
   CLOSE is_readable;
END Check_Readable;


@UncheckedAccess
FUNCTION Get_Use_Price_Break_Templ_Db (
   price_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SALES_PRICE_LIST_TAB.use_price_break_templates%TYPE;
   CURSOR get_attr IS
      SELECT use_price_break_templates
      FROM SALES_PRICE_LIST_TAB
      WHERE price_list_no = price_list_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Use_Price_Break_Templ_Db;


@UncheckedAccess
FUNCTION Get_Editable (
   price_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_    NUMBER;
   result_  VARCHAR2(20) := 'FALSE';

   CURSOR is_writable IS
      SELECT 1 
      FROM SALES_PRICE_LIST_AUTH_WRITE
      WHERE price_list_no = price_list_no_;
BEGIN
   OPEN is_writable;
   FETCH is_writable INTO temp_;
   IF(is_writable%FOUND) THEN
      result_ := 'TRUE';
   END IF;
   CLOSE is_writable;

   RETURN result_;
END Get_Editable;


@UncheckedAccess
FUNCTION Get_Readable (
   price_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_    NUMBER;
   result_  VARCHAR2(20) := 'FALSE';

   CURSOR is_readable IS
      SELECT 1 
      FROM sales_price_list_auth_read
      WHERE price_list_no = price_list_no_; 
BEGIN
   OPEN is_readable;
   FETCH is_readable INTO temp_;
   IF(is_readable%FOUND) THEN
      result_ := 'TRUE';
   END IF;
   CLOSE is_readable;

   RETURN result_;
END Get_Readable;


@UncheckedAccess
FUNCTION Get_Subscr_New_Sales_Parts_Db (
   price_list_no_ IN VARCHAR2 ) RETURN VARCHAR2
IS
   temp_ SALES_PRICE_LIST_TAB.subscribe_new_sales_parts%TYPE;
   CURSOR get_attr IS
      SELECT subscribe_new_sales_parts
      FROM SALES_PRICE_LIST_TAB
      WHERE price_list_no = price_list_no_;
BEGIN
   OPEN get_attr;
   FETCH get_attr INTO temp_;
   CLOSE get_attr;
   RETURN temp_;
END Get_Subscr_New_Sales_Parts_Db;

-- Get the latest date from all the child tabs in Sales price list form
FUNCTION Get_Latest_Valid_To___ (
   price_list_no_  IN  VARCHAR2 ) RETURN DATE
IS
   latest_valid_to_  DATE;  
   
   CURSOR get_late_valid_to_date IS
      SELECT MAX(max_valid_to_date)
      FROM
         (SELECT MAX(valid_to_date) max_valid_to_date
          FROM   SALES_PRICE_LIST_PART_TAB
          WHERE  price_list_no = price_list_no_
          AND    valid_to_date IS NOT NULL
          UNION
          SELECT MAX(valid_from_date) max_valid_to_date
          FROM   SALES_PRICE_LIST_PART_TAB
          WHERE  price_list_no = price_list_no_
          AND    valid_to_date IS NULL
          UNION
          SELECT MAX(valid_to_date) max_valid_to_date
          FROM   SALES_PRICE_LIST_ASSORT_TAB
          WHERE  price_list_no = price_list_no_
          AND    valid_to_date IS NOT NULL
          UNION
          SELECT MAX(valid_from_date) max_valid_to_date
          FROM   SALES_PRICE_LIST_ASSORT_TAB
          WHERE  price_list_no = price_list_no_
          AND    valid_to_date IS NULL
          UNION
          SELECT MAX(valid_to_date) max_valid_to_date
          FROM   SALES_PRICE_LIST_UNIT_TAB
          WHERE  price_list_no = price_list_no_
          AND    valid_to_date IS NOT NULL
          UNION
          SELECT MAX(valid_from_date) max_valid_to_date
          FROM   SALES_PRICE_LIST_UNIT_TAB
          WHERE  price_list_no = price_list_no_
          AND    valid_to_date IS NULL);
BEGIN
   OPEN get_late_valid_to_date;
   FETCH get_late_valid_to_date INTO latest_valid_to_;
   CLOSE get_late_valid_to_date;
   
   RETURN latest_valid_to_;
END Get_Latest_Valid_To___;

@Override 
PROCEDURE Check_Common___ (
   oldrec_ IN     sales_price_list_tab%ROWTYPE,
   newrec_ IN OUT sales_price_list_tab%ROWTYPE,
   indrec_ IN OUT Indicator_Rec,
   attr_   IN OUT VARCHAR2 )
IS
BEGIN

super(oldrec_, newrec_, indrec_, attr_);
IF (indrec_.default_percentage_offset AND (newrec_.default_percentage_offset < -100)) THEN
   Error_SYS.Record_General(lu_name_, 'NEGPERCENTAGE: Negative percentage value cannot be greater than 100.');
END IF;   

IF (indrec_.valid_to_date AND newrec_.valid_to_date < Get_Latest_Valid_To___(newrec_.price_list_no)) THEN
   Client_SYS.Add_Info(lu_name_, 'SALES_PRICE_LATE_VALID_TO_EXISTS: Sales Price List lines exist where either Valid From date or Valid To date is later than Sales Price List header Valid To date.');
END IF;
END Check_Common___;

@Override
PROCEDURE Update___ (
   objid_      IN     VARCHAR2,
   oldrec_     IN     sales_price_list_tab%ROWTYPE,
   newrec_     IN OUT sales_price_list_tab%ROWTYPE,
   attr_       IN OUT VARCHAR2,
   objversion_ IN OUT VARCHAR2,
   by_keys_    IN     BOOLEAN DEFAULT FALSE )   
IS
   sales_price_group_type_ VARCHAR2(10);

BEGIN
   super(objid_, oldrec_, newrec_, attr_, objversion_, by_keys_);
   IF (Validate_SYS.Is_Different(oldrec_.rounding, newrec_.rounding)) THEN
      sales_price_group_type_ := Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(newrec_.sales_price_group_id);
      IF (sales_price_group_type_ = Sales_Price_Group_Type_API.DB_PART_BASED) THEN
         Sales_Price_List_Part_API.Round_Base_And_Sales_Prices(newrec_.price_list_no, newrec_.rounding, 'FORWARD');
         IF (newrec_.assortment_id IS NOT NULL) THEN
            Sales_Price_list_Assort_API.Round_Sales_Price(newrec_.price_list_no, newrec_.rounding); 
         END IF;
      ELSIF (sales_price_group_type_ = Sales_Price_Group_Type_API.DB_UNIT_BASED) THEN
         Sales_Price_list_Unit_API.Round_Sales_Price(newrec_.price_list_no, newrec_.rounding);
      END IF;            
   END IF;
END Update___;

FUNCTION Sales_Prices_Available (
   price_list_no_      IN VARCHAR2 ) RETURN VARCHAR2
IS
   CURSOR get_sales_prices IS
      SELECT 1
      FROM  sales_price_list_part_tab
      WHERE price_list_no = price_list_no_
      AND   sales_price_type = 'SALES PRICES';
      
   sales_prices_exist_ VARCHAR2(5)  := 'FALSE';
   dummy_              NUMBER;
BEGIN
   OPEN get_sales_prices;
   FETCH get_sales_prices INTO dummy_;
   IF get_sales_prices%FOUND THEN
      sales_prices_exist_ := 'TRUE';
   END IF;
   RETURN sales_prices_exist_;
END Sales_Prices_Available;

-- This method validates the given price list against the minimum quantity, currency, duration, 
-- valid_to_date and also considers the price lists in the customer hierarchy.
FUNCTION Is_Valid_Price_List (
   price_list_no_       IN     VARCHAR2,
   contract_            IN     VARCHAR2,
   catalog_no_          IN     VARCHAR2,
   customer_no_         IN     VARCHAR2,
   currency_code_       IN     VARCHAR2,
   effectivity_date_    IN     DATE,   
   sales_price_type_db_ IN     VARCHAR2,   
   price_qty_due_       IN     NUMBER,
   min_duration_        IN     NUMBER) RETURN VARCHAR2
IS
   found_valid_price_list_  VARCHAR2(5) := 'FALSE';
   sales_price_group_id_    VARCHAR2(10);
   temp_                    NUMBER;
   date_                    DATE;
   valid_to_date_           DATE;   
   temp_cust_plist_no_      SALES_PRICE_LIST_TAB.price_list_no%TYPE;   
   prnt_cust_               CUST_HIERARCHY_STRUCT_TAB.customer_parent%TYPE;
   hierarchy_id_            CUST_HIERARCHY_STRUCT_TAB.hierarchy_id%TYPE;
   cust_price_group_id_     CUST_PRICE_GROUP_DETAIL_TAB.cust_price_group_id%TYPE;
   
   CURSOR validate_part_based_price_list(customer_ IN VARCHAR2) IS
      SELECT 1
      FROM  sales_price_list_tab spl, sales_price_list_part_tab spp, customer_pricelist_tab cpl
      WHERE spl.price_list_no = spp.price_list_no
      AND   spl.price_list_no = cpl.price_list_no(+)       
      AND   spl.price_list_no = price_list_no_
      AND   spp.catalog_no = catalog_no_
      AND   spp.valid_from_date <= date_
      AND   spp.min_duration <= min_duration_
      AND   ((spp.valid_to_date IS NULL) OR (spp.valid_to_date >= date_))
      AND   spp.rowstate = 'Active'
      AND   spp.sales_price_type = sales_price_type_db_
      AND   spl.sales_price_group_id = sales_price_group_id_ 
      AND   spp.min_quantity <= price_qty_due_                   
      AND   ((spl.currency_code = currency_code_ ) OR ((cpl.customer_no = customer_) AND 
               (cpl.currency_code != currency_code_ AND cpl.preferred_price_list = 'PREFERRED')));
                                        
   CURSOR validate_unit_based_price_list(customer_ IN VARCHAR2) IS
      SELECT 1 
      FROM sales_price_list_tab spl, sales_price_list_unit_tab plu, customer_pricelist_tab cpl
      WHERE plu.price_list_no = spl.price_list_no
      AND   spl.price_list_no = cpl.price_list_no(+)        
      AND   plu.price_list_no = price_list_no_
      AND   plu.valid_from_date <= date_
      AND   plu.min_quantity <= price_qty_due_
      AND   spl.sales_price_group_id = sales_price_group_id_            
      AND   ((spl.currency_code = currency_code_ ) OR ((cpl.customer_no = customer_) 
               AND (cpl.currency_code != currency_code_ AND cpl.preferred_price_list = 'PREFERRED')));
                                        
   CURSOR validate_assortment_price_list(customer_ IN VARCHAR2) IS
      SELECT 1 
      FROM   sales_price_list_tab spl, sales_price_list_site_tab spls, customer_pricelist_tab cpl
      WHERE  spl.price_list_no = spls.price_list_no
      AND    spl.price_list_no = cpl.price_list_no(+)
      AND    spl.price_list_no = price_list_no_ 
      AND    spl.sales_price_group_id = sales_price_group_id_         
      AND    spl.assortment_id IS NOT NULL
      AND    NVL(valid_to_date_, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
      AND   ((spl.currency_code = currency_code_ ) OR ((cpl.customer_no = customer_) 
               AND (cpl.currency_code != currency_code_ AND cpl.preferred_price_list = 'PREFERRED')));
               
   CURSOR validate_group_part_based_list IS
      SELECT 1
      FROM  sales_price_list_tab spl, sales_price_list_part_tab spp, cust_price_group_detail_tab cpg
      WHERE spl.price_list_no = spp.price_list_no
      AND   spl.price_list_no = cpg.price_list_no(+)
      AND   cpg.cust_price_group_id = cust_price_group_id_
      AND   spl.price_list_no = price_list_no_
      AND   spp.catalog_no = catalog_no_
      AND   spp.valid_from_date <= date_
      AND   spp.min_duration <= min_duration_
      AND   ((spp.valid_to_date IS NULL) OR (spp.valid_to_date >= date_))
      AND   spp.rowstate = 'Active'
      AND   spp.sales_price_type = sales_price_type_db_
      AND   spl.sales_price_group_id = sales_price_group_id_ 
      AND   spp.min_quantity <= price_qty_due_   
      AND   ((cpg.currency_code != currency_code_) AND (cpg.preferred_price_list = 'PREFERRED'));
      
   CURSOR validate_group_unit_based_price_list IS
      SELECT 1 
      FROM sales_price_list_tab spl, sales_price_list_unit_tab plu, cust_price_group_detail_tab cpg
      WHERE plu.price_list_no = spl.price_list_no
      AND   spl.price_list_no = cpg.price_list_no(+)
      AND   cpg.cust_price_group_id = cust_price_group_id_
      AND   plu.price_list_no = price_list_no_
      AND   plu.valid_from_date <= date_
      AND   plu.min_quantity <= price_qty_due_
      AND   spl.sales_price_group_id = sales_price_group_id_
      AND   ((cpg.currency_code != currency_code_) AND (cpg.preferred_price_list = 'PREFERRED'));
      
   CURSOR validate_group_assortment_price_list IS
      SELECT 1 
      FROM   sales_price_list_tab spl, sales_price_list_site_tab spls, cust_price_group_detail_tab cpg
      WHERE  spl.price_list_no = spls.price_list_no
      AND    spl.price_list_no = cpg.price_list_no(+)
      AND    cpg.cust_price_group_id = cust_price_group_id_
      AND    spl.price_list_no = price_list_no_ 
      AND    spl.sales_price_group_id = sales_price_group_id_         
      AND    spl.assortment_id IS NOT NULL
      AND    NVL(valid_to_date_, TRUNC(SYSDATE)) >= TRUNC(SYSDATE)
      AND   ((cpg.currency_code != currency_code_) AND (cpg.preferred_price_list = 'PREFERRED'));
               
BEGIN
   sales_price_group_id_  := Sales_Part_API.Get_Sales_Price_Group_Id(contract_, catalog_no_); 
   valid_to_date_         := Get_Valid_To_Date(price_list_no_);
   hierarchy_id_          := Cust_Hierarchy_Struct_API.Get_Hierarchy_Id(customer_no_);
   cust_price_group_id_   := Cust_Ord_Customer_API.Get_Cust_Price_Group_Id(customer_no_);
   
   IF (effectivity_date_ IS NULL) THEN
      date_ := TRUNC(Site_API.Get_Site_Date(contract_));
   ELSE
      date_ := effectivity_date_;
   END IF;
      
   IF (valid_to_date_ IS NOT NULL) AND (valid_to_date_ < date_) THEN         
      found_valid_price_list_ := 'FALSE';
   ELSIF (NOT Sales_Price_List_Site_API.Check_Exist(contract_, price_list_no_)) THEN         
      found_valid_price_list_ := 'FALSE';     
   ELSE      
      IF (Sales_Price_List_API.Get_Assortment_Id(price_list_no_) IS NOT NULL) THEN
         OPEN validate_assortment_price_list(customer_no_);
         FETCH validate_assortment_price_list INTO temp_;
         IF validate_assortment_price_list%FOUND THEN
            found_valid_price_list_ := 'TRUE';
         ELSE
            OPEN validate_group_assortment_price_list;
            FETCH validate_group_assortment_price_list INTO temp_;
            IF (validate_group_assortment_price_list%FOUND) THEN 
               found_valid_price_list_ := 'TRUE';
            END IF;  
            CLOSE validate_group_assortment_price_list;
         END IF;
         CLOSE validate_assortment_price_list; 
            
      ELSIF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_group_id_) = 'PART BASED') THEN
         OPEN validate_part_based_price_list(customer_no_);
         FETCH  validate_part_based_price_list INTO temp_;
            IF (validate_part_based_price_list%FOUND) THEN 
               found_valid_price_list_ := 'TRUE';
            ELSE 
               OPEN validate_group_part_based_list;
               FETCH validate_group_part_based_list INTO temp_;
               IF (validate_group_part_based_list%FOUND) THEN 
                  found_valid_price_list_ := 'TRUE';
               END IF;
               CLOSE validate_group_part_based_list;
            END IF;
         CLOSE validate_part_based_price_list;
            
      ELSIF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_group_id_) = 'UNIT BASED') THEN 
         OPEN validate_unit_based_price_list(customer_no_);
         FETCH  validate_unit_based_price_list INTO temp_;
         IF validate_unit_based_price_list%FOUND THEN
            found_valid_price_list_ := 'TRUE';
         ELSE
            OPEN validate_group_unit_based_price_list;
            FETCH validate_group_unit_based_price_list INTO temp_;
            IF (validate_group_unit_based_price_list%FOUND) THEN 
               found_valid_price_list_ := 'TRUE';
            END IF;
            CLOSE validate_group_unit_based_price_list;          
         END IF;
         CLOSE validate_unit_based_price_list; 
      END IF;
            
      IF ((found_valid_price_list_ = 'FALSE') AND (hierarchy_id_ IS NOT NULL)) THEN
         prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, customer_no_);
            
         WHILE (prnt_cust_ IS NOT NULL) LOOP
            temp_cust_plist_no_      := Customer_Pricelist_API.Get_Price_List_No(prnt_cust_, 
                                                                                 sales_price_group_id_, 
                                                                                 currency_code_);
                                                                              
            IF (Sales_Price_List_API.Get_Assortment_Id(temp_cust_plist_no_) IS NOT NULL) THEN
               OPEN validate_assortment_price_list(prnt_cust_);
               FETCH validate_assortment_price_list INTO temp_;
               IF validate_assortment_price_list%FOUND THEN
                  found_valid_price_list_ := 'TRUE';  
               ELSE
                  OPEN validate_group_assortment_price_list;
                  FETCH validate_group_assortment_price_list INTO temp_;
                  IF (validate_group_assortment_price_list%FOUND) THEN 
                     found_valid_price_list_ := 'TRUE';
                  END IF;  
                  CLOSE validate_group_assortment_price_list;  
               END IF;
               CLOSE validate_assortment_price_list; 
            
            ELSIF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_group_id_) = 'PART BASED') THEN
               OPEN validate_part_based_price_list(prnt_cust_);
               FETCH  validate_part_based_price_list INTO temp_;
               IF (validate_part_based_price_list%FOUND) THEN 
                  found_valid_price_list_ := 'TRUE';
               ELSE 
                  OPEN validate_group_part_based_list;
                  FETCH validate_group_part_based_list INTO temp_;
                  IF (validate_group_part_based_list%FOUND) THEN 
                     found_valid_price_list_ := 'TRUE';
                  END IF;
                  CLOSE validate_group_part_based_list;
               END IF;
               CLOSE validate_part_based_price_list;
            
            ELSIF (Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(sales_price_group_id_) = 'UNIT BASED') THEN 
               OPEN validate_unit_based_price_list(prnt_cust_);
               FETCH  validate_unit_based_price_list INTO temp_;
               IF validate_unit_based_price_list%FOUND THEN
                  found_valid_price_list_ := 'TRUE';
               ELSE
                  OPEN validate_group_unit_based_price_list;
                  FETCH validate_group_unit_based_price_list INTO temp_;
                  IF (validate_group_unit_based_price_list%FOUND) THEN 
                     found_valid_price_list_ := 'TRUE';
                  END IF;
                  CLOSE validate_group_unit_based_price_list; 
               END IF;
               CLOSE validate_unit_based_price_list;                                                                     
            END IF;  
            prnt_cust_ := Cust_Hierarchy_Struct_API.Get_Parent_Cust(hierarchy_id_, prnt_cust_);
         END LOOP;
      END IF;      
   END IF;
   RETURN found_valid_price_list_;     
END Is_Valid_Price_List;
