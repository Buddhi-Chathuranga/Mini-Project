-----------------------------------------------------------------------------
--
--  Logical unit: SalesPartUtil
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  -------------------------------------------------------------------------------
--  2021-07-06  NiDalk  SC21R2-1783, Modified Get_Sales_Part to handle exeption when no record is returning.
--  2021-02-28  ChBnlk  SC21R2-1412, Modified Get_Sales_Part(), Get_Part_Availability_Info() and Get_Customer_Price_Info()
--  2021-02-28          to properly handle the exception.
--  2021-02-16  DhAplk  SC2020R1-12399, Added Get_Customer_Price_Info and Get_Catalog_Sale_Price_Info___ methods.
--  2021-01-25  DhAplk  SC2020R1-12242, Added is_json_ to Post_Outbound_Message() method call in Send_Sales_Part.
--  2020-10-07  DhAplk  SC2020R1-6902, Changed Attribute_Structure_Arr to Sales_Part_Structure_Attribute_Arr in Get_Attribute_Structure_Arr___().
--  2020-09-29  DhAplk  SC2020R1-53, Changed Send_Sales_Part to send json clob only.
--  2020-09-22  NiDalk  SC2020R1-9657,  Added ORDSRV installed check.
--  2020-06-03  Erlise  SC2020R1-53, Added Send_Sales_Part().
--  2020-04-27  Erlise  SC2020R1-52, Created to support integration projection SalesPartService. 
--                      Conversion of BizApi GetSalesPart from ORDSRV/SalesPartHandling.serverpackage.
-------------------------------------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------


-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-----------------------------------------------------------------------------
-- Get_Attribute_Structure_Arr___
--   Use this method to add named attribute/value pairs to the attribute section of the message.
--   Add code according to the example below to add name/value pairs to the return array.
--   This is then automatically handled and the attribute section of the message will contain a list of the added atttributes.
-----------------------------------------------------------------------------
FUNCTION Get_Attribute_Structure_Arr___ (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2 ) RETURN Sales_Part_Structure_Attribute_Arr
IS
   return_arr_ Sales_Part_Structure_Attribute_Arr := Sales_Part_Structure_Attribute_Arr();
BEGIN
   -- Add first attribute example
   return_arr_.extend;
   return_arr_(return_arr_.last).attribute_name := 'EXAMPLE_NAME1';
   return_arr_(return_arr_.last).attribute_value := 'EXAMPLE_VALUE1';
   -- Add second attribute example
   return_arr_.extend;
   return_arr_(return_arr_.last).attribute_name := 'EXAMPLE_NAME2';
   return_arr_(return_arr_.last).attribute_value := 'EXAMPLE_VALUE2';
   
   RETURN return_arr_;
END Get_Attribute_Structure_Arr___;


------------------------------------------------------------------------
-- Get_Price_Source_Desc___
--    Fetch the price source description depending on the price source
--    and price source id.
------------------------------------------------------------------------
PROCEDURE Get_Price_Source_Desc___ (
   price_source_desc_ OUT VARCHAR2,
   price_source_      IN VARCHAR2,
   price_source_id_   IN VARCHAR2 )
IS
   price_source_db_     VARCHAR2(2000) := NULL;
BEGIN
   price_source_db_ := Pricing_Source_API.Encode(price_source_);
   CASE price_source_db_
      WHEN 'AGREEMENT' THEN
         price_source_desc_ := Customer_Agreement_API.Get_Description(price_source_id_);
      WHEN 'CAMPAIGN' THEN
         price_source_desc_ := Campaign_API.Get_Description(price_source_id_);
      WHEN 'PRICELIST' THEN
         price_source_desc_ := Sales_Price_List_API.Get_Description(price_source_id_);
      ELSE
         price_source_desc_ := NULL;
   END CASE;
END Get_Price_Source_Desc___;

------------------------------------------------------------------------
-- Get_Catalog_Sale_Price_Info___
--    Retrieve sales price information for contract, customer_no, currency_code, catalog_no_ and buy_qty_due. 
--    If agreement_id or price_list_no or effective_date_ or condition_code_ are given, price information
--    will be fetched according to the priority given in Customer_Order_Pricing_API.Get_Sales_Part_Price_Info().
------------------------------------------------------------------------
PROCEDURE Get_Catalog_Sale_Price_Info___ (
   sale_unit_price_     OUT NUMBER,
   unit_price_incl_tax_ OUT NUMBER,
   currency_rate_       OUT NUMBER,
   discount_            OUT NUMBER,
   sale_net_price_      OUT NUMBER,
   price_source_        OUT VARCHAR2,
   price_source_id_     OUT VARCHAR2,
   contract_            IN  VARCHAR2,
   customer_no_         IN  VARCHAR2,
   currency_code_       IN  VARCHAR2,
   agreement_id_        IN  VARCHAR2,
   catalog_no_          IN  VARCHAR2,
   buy_qty_due_         IN  VARCHAR2,
   price_list_no_       IN  VARCHAR2,
   effective_date_      IN  DATE,
   condition_code_      IN  VARCHAR2 )
IS
   base_sale_unit_price_     NUMBER;
   base_unit_price_incl_tax_ NUMBER;
   currency_rounding_        NUMBER;
   temp_price_list_no_       VARCHAR2(10);
   company_                  VARCHAR2(20);
   sales_part_rec_           Sales_Part_API.Public_Rec;
   customer_level_db_        VARCHAR2(30) := NULL;
   customer_level_id_        VARCHAR2(200) := NULL;
   use_price_incl_tax_       VARCHAR2(5);
BEGIN
   -- Note: Get some general data (this can be cached for better performance)
   company_  := Site_API.Get_Company(contract_);
   sales_part_rec_ := Sales_Part_API.Get(contract_, catalog_no_);

   IF (price_list_no_ IS NULL) THEN
      Sales_Price_List_API.Get_Valid_Price_List(customer_level_db_, customer_level_id_, temp_price_list_no_, contract_, 
                                                catalog_no_, customer_no_, currency_code_, effective_date_, NULL );
   ELSE
      temp_price_list_no_ := price_list_no_;
   END IF;

   -- Note: Get sales part price info
   Customer_Order_Pricing_API.Get_Sales_Part_Price_Info(sale_unit_price_,
                                                        unit_price_incl_tax_,
                                                        base_sale_unit_price_,
                                                        base_unit_price_incl_tax_,
                                                        currency_rate_,
                                                        discount_,
                                                        price_source_,
                                                        price_source_id_,
                                                        contract_,
                                                        customer_no_,
                                                        currency_code_,
                                                        agreement_id_,
                                                        catalog_no_,
                                                        buy_qty_due_,
                                                        temp_price_list_no_,
                                                        effective_date_,
                                                        condition_code_,
                                                        use_price_incl_tax_);

   -- Note: Calculate price
   sale_net_price_      := sale_unit_price_ * sales_part_rec_.price_conv_factor * (1 - discount_ / 100);
   currency_rounding_   := Currency_Code_API.Get_Currency_Rounding(company_, currency_code_);
   sale_net_price_      := round(sale_net_price_, currency_rounding_);
   sale_unit_price_     := round(sale_unit_price_, currency_rounding_);
   unit_price_incl_tax_ := round(unit_price_incl_tax_, currency_rounding_);
END Get_Catalog_Sale_Price_Info___;


------------------------------------------------------------------------
-- Check_Inv_Availability___
--    Returns the inventory part availability information.
------------------------------------------------------------------------
PROCEDURE Check_Inv_Availability___ (
   result_               IN OUT VARCHAR2,
   available_date_       IN OUT DATE,
   quantity_             IN OUT NUMBER,
   wanted_delivery_date_ IN     DATE,
   customer_no_          IN     VARCHAR2,
   address_id_           IN     VARCHAR2,
   part_no_              IN     VARCHAR2,
   contract_             IN     VARCHAR2 )
IS
   qty_possible_              NUMBER;
   conv_factor_               NUMBER;
   delivery_leadtime_         NUMBER;
   inv_qty_                   NUMBER := 0;
   route_id_                  VARCHAR2(12);
   inv_part_no_               VARCHAR2(25);
   calendar_id_               VARCHAR2(10);
   ext_transport_calendar_id_ VARCHAR2(10);
   planned_delivery_date_     DATE;
   planned_due_date_          DATE;
   planned_ship_date_         DATE;
   next_analysis_date_        DATE;
   addrrec_                   Cust_Ord_Customer_Address_API.Public_Rec;
   sppubrec_                  Sales_Part_API.Public_Rec;
BEGIN  
   sppubrec_         := Sales_Part_API.Get(contract_, part_no_);
   inv_part_no_      := sppubrec_.part_no;
   conv_factor_      := sppubrec_.conv_factor;
   planned_due_date_ := GREATEST(wanted_delivery_date_, TRUNC(SYSDATE));
      
   IF (Inventory_Part_Onh_Analys_API.Encode(Inventory_Part_API.Get_Onhand_Analysis_Flag(contract_, inv_part_no_)) = 'Y') THEN
      IF (sppubrec_.inverted_conv_factor != 0) THEN
         inv_qty_       := quantity_ * conv_factor_ / sppubrec_.inverted_conv_factor;
      END IF;

      Inventory_Part_In_Stock_API.Make_Onhand_Analysis(result_,
                                                       qty_possible_,
                                                       next_analysis_date_,
                                                       planned_ship_date_,
                                                       planned_due_date_,
                                                       contract_,
                                                       inv_part_no_,
                                                       NULL,                   -- configuration_id
                                                       'TRUE',                 -- include_standard
                                                       'FALSE',                -- include_project
                                                       NULL,                   -- project_id
                                                       NULL,                   -- activity_seq
                                                       NULL,                   -- rowid
                                                       inv_qty_);

      IF (customer_no_ IS NOT NULL) THEN
         addrrec_  := Cust_Ord_Customer_Address_API.Get(customer_no_, address_id_);
         route_id_ := addrrec_.route_id;

         delivery_leadtime_         := NVL(Customer_Address_Leadtime_API.Get_Delivery_Leadtime(customer_no_, address_id_, addrrec_.ship_via_code, contract_), 0);
         ext_transport_calendar_id_ := Mpccom_Ship_Via_API.Get_Ext_Transport_Calendar_Id(addrrec_.ship_via_code);

         IF (route_id_ IS NOT NULL) THEN
            -- Get first available ship date and time for the route.
            calendar_id_       := Site_API.Get_Dist_Calendar_Id(contract_);
            planned_ship_date_ := Delivery_Route_API.Get_Next_Route_Date(route_id_, planned_ship_date_, calendar_id_, contract_);
         END IF;
         Cust_Ord_Date_Calculation_API.Fetch_Calendar_End_Date(planned_delivery_date_, ext_transport_calendar_id_, planned_ship_date_, delivery_leadtime_);
      ELSE
         planned_delivery_date_ := planned_ship_date_;
      END IF;

      available_date_ := GREATEST(planned_delivery_date_, wanted_delivery_date_);

      IF (result_ != 'SUCCESS' OR (result_ = 'SUCCESS' AND inv_qty_ = 0)) THEN
         IF (conv_factor_ = 0) THEN
            quantity_ := 0;
         ELSE
            quantity_ := GREATEST(qty_possible_ / conv_factor_ * sppubrec_.inverted_conv_factor, 0);
         END IF;
      END IF;
   END IF;
END Check_Inv_Availability___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-----------------------------------------------------------------------------
-- Send_Sales_Part
--    Fetch a list of sales parts to be exported.
--    Default output format is Json, if the parameter json_response_ is set to false,
--    two different xml formats can be returned by using the parameter ifs_xml_format_.
--    If this parameter is set to 'TRUE' the xml returned is uppercase with underscores.
-----------------------------------------------------------------------------
PROCEDURE Send_Sales_Part (
   receiver_routing_parameter_   IN VARCHAR2,
   contract_                     IN VARCHAR2,
   catalog_no_                   IN VARCHAR2,
   sales_group_                  IN VARCHAR2,
   sales_price_group_            IN VARCHAR2,
   discount_group_               IN VARCHAR2,
   sales_grp_in_condition_       IN VARCHAR2,
   sales_price_grp_in_condition_ IN VARCHAR2,
   discount_grp_in_condition_    IN VARCHAR2,
   changed_since_no_of_days_     IN NUMBER,
   use_export_to_external_app_   IN VARCHAR2,
   use_active_in_database_       IN VARCHAR2,
   exclude_substitute_part_      IN VARCHAR2,
   exclude_complementary_part_   IN VARCHAR2,
   include_extra_attributes_     IN VARCHAR2 DEFAULT 'FALSE' )
IS
   request_          Sales_Part_Params_Structure_Rec;
   return_arr_       Sales_Part_Structure_Arr := Sales_Part_Structure_Arr(); 
   json_obj_         JSON_OBJECT_T;
   json_clob_        CLOB;
   message_id_       NUMBER;
   sender_           VARCHAR2(20);
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      -- Assign values to the query structure
      request_.site := contract_;
      request_.sales_part_no := catalog_no_;
      request_.sales_group := sales_group_;
      request_.sales_grp_in_condition := sales_grp_in_condition_;
      request_.sales_price_group := sales_price_group_;
      request_.sales_price_grp_in_condition := sales_price_grp_in_condition_;
      request_.discount_group := discount_group_;
      request_.discount_grp_in_condition := discount_grp_in_condition_;
      request_.changed_since_number_of_days := changed_since_no_of_days_;

      IF (UPPER(use_export_to_external_app_) = 'TRUE') THEN
         request_.use_export_to_external_app := TRUE;
      ELSE
         request_.use_export_to_external_app := FALSE;
      END IF;

      IF (UPPER(use_active_in_database_) = 'TRUE') THEN
         request_.use_active_in_database := TRUE;
      ELSE
         request_.use_active_in_database := FALSE;
      END IF;

      IF (UPPER(exclude_substitute_part_) = 'TRUE') THEN
         request_.exclude_substitute_parts := TRUE;
      ELSE
         request_.exclude_substitute_parts := FALSE;
      END IF;

      IF (UPPER(exclude_complementary_part_) = 'TRUE') THEN
         request_.exclude_complementary_parts := TRUE;
      ELSE
         request_.exclude_complementary_parts := FALSE;
      END IF;

      IF (include_extra_attributes_ IS NOT NULL) THEN
         IF (UPPER(include_extra_attributes_) = 'TRUE') THEN
            request_.include_attributes := TRUE;
         ELSIF (UPPER(include_extra_attributes_) = 'FALSE') THEN
            request_.include_attributes := FALSE;
         END IF;
      END IF;

      -- Get the response array of part records
      return_arr_ := Get_Sales_Part(request_);
      -- Convert to Json
      json_obj_  := Sales_Part_Structure_Arr_To_Json___(return_arr_);
      json_clob_ := json_obj_.to_clob;
      
      Plsqlap_Server_API.Post_Outbound_Message(json_             => json_clob_,
                                               message_id_       => message_id_,
                                               sender_           => sender_,
                                               receiver_         => receiver_routing_parameter_,
                                               message_type_     => 'APPLICATION_MESSAGE',
                                               message_function_ => 'SEND_SALES_PART',
                                               is_json_          => true);
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
END Send_Sales_Part;


FUNCTION Get_Sales_Part (
   request_ IN Sales_Part_Params_Structure_Rec ) RETURN Sales_Part_Structure_Arr
IS
   return_arr_                Sales_Part_Structure_Arr := Sales_Part_Structure_Arr();
   TYPE Get_Part_List         IS REF CURSOR;
   get_part_list_             Get_Part_List;
   TYPE Part_List_Tab         IS TABLE OF VARCHAR2(50) INDEX BY PLS_INTEGER;
   part_list_tab_             Part_List_Tab;
   stmt_                      VARCHAR2(32000);
   error_text_                VARCHAR2(2000);
BEGIN
   IF Dictionary_SYS.Component_Is_Active('ORDSRV') THEN
      BEGIN
         stmt_ := 'SELECT catalog_no FROM sales_part WHERE contract = :site_ ';

         IF (request_.sales_part_no IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND part_no LIKE UPPER(:sales_part_no_) ';
         ELSE
            stmt_ := stmt_ || ' AND :sales_part_no_ IS NULL ';
         END IF;

         IF (request_.sales_group IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND catalog_group LIKE UPPER(:sales_group_) ';
         ELSE
            stmt_ := stmt_ || ' AND :sales_group_ IS NULL ';
         END IF;

         IF (request_.sales_grp_in_condition IS NOT NULL) THEN
            -- The request parameter is split on comma separator, spaces are interpreted as part of the value.
            stmt_ := stmt_ || ' AND catalog_group IN (select regexp_substr(:sales_grp_in_condition_,''[^,]+'', 1, level) from dual 
                                connect by regexp_substr(:sales_grp_in_condition_, ''[^,]+'', 1, level) is not null) ';
         ELSE
            stmt_ := stmt_ || ' AND :sales_grp_in_condition_ IS NULL AND :sales_grp_in_condition_ IS NULL ';
         END IF;

         IF (request_.sales_price_group IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND sales_price_group_id LIKE UPPER(:sales_price_group_) ';
         ELSE
            stmt_ := stmt_ || ' AND :sales_price_group_ IS NULL ';
         END IF;

         IF (request_.sales_price_grp_in_condition IS NOT NULL) THEN
            -- The request parameter is split on comma separator, spaces are interpreted as part of the value.
            stmt_ := stmt_ || ' AND sales_price_group_id IN (select regexp_substr(:sales_price_grp_in_condition,''[^,]+'', 1, level) from dual 
                                connect by regexp_substr(:sales_price_grp_in_condition, ''[^,]+'', 1, level) is not null) ';
         ELSE
            stmt_ := stmt_ || ' AND :sales_price_grp_in_condition IS NULL AND :sales_price_grp_in_condition IS NULL ';
         END IF;

         IF (request_.discount_group IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND discount_group LIKE UPPER(:discount_group) ';
         ELSE
            stmt_ := stmt_ || ' AND :discount_group IS NULL ';
         END IF;

         IF (request_.discount_grp_in_condition IS NOT NULL) THEN
            -- The request parameter is split on comma separator, spaces are interpreted as part of the value.
            stmt_ := stmt_ || ' AND discount_group IN (select regexp_substr(:discount_grp_in_condition,''[^,]+'', 1, level) from dual 
                                connect by regexp_substr(:discount_grp_in_condition, ''[^,]+'', 1, level) is not null) ';
         ELSE
            stmt_ := stmt_ || ' AND :discount_grp_in_condition IS NULL AND :discount_grp_in_condition IS NULL ';
         END IF;

         IF (request_.changed_since_number_of_days IS NOT NULL) THEN
            stmt_ := stmt_ || ' AND objversion > to_char(sysdate - :changed_since_number_of_days_, ''YYYYMMDDHH24MISS'' )';
         ELSE
            stmt_ := stmt_ || ' AND :changed_since_number_of_days_ IS NULL ';
         END IF;


         -- Only include sales parts where the checkbox "Active" is checked
         IF (request_.use_active_in_database = TRUE) THEN
            stmt_ := stmt_ || ' AND activeind_db = ''Y'' ';
         END IF;
         -- Only include sales parts where the checkbox "Export to External App" is checked.
         IF (request_.use_export_to_external_app = TRUE) THEN
            stmt_ := stmt_ || ' AND export_to_external_app_db = ''TRUE'' ';
         END IF;

         @ApproveDynamicStatement(2020-04-27,ERLISE)
         OPEN  get_part_list_ FOR stmt_ USING request_.site,
                                              request_.sales_part_no,
                                              request_.sales_group,
                                              request_.sales_grp_in_condition,
                                              request_.sales_grp_in_condition,
                                              request_.sales_price_group,
                                              request_.sales_price_grp_in_condition,
                                              request_.sales_price_grp_in_condition,
                                              request_.discount_group,
                                              request_.discount_grp_in_condition,
                                              request_.discount_grp_in_condition,
                                              request_.changed_since_number_of_days;
         FETCH get_part_list_ BULK COLLECT INTO part_list_tab_;
         CLOSE get_part_list_;

         IF part_list_tab_ IS NOT NULL AND part_list_tab_.COUNT > 0 THEN
            FOR i IN part_list_tab_.FIRST..part_list_tab_.LAST LOOP
               return_arr_.EXTEND;
               return_arr_(return_arr_.LAST) := Get_Sales_Part_Structure_Rec___(request_.site, part_list_tab_(i));

               IF (request_.exclude_substitute_parts = TRUE) THEN
                  return_arr_(return_arr_.LAST).substitute_parts := Sales_Part_Structure_Substitute_Sales_Part_Arr();
               END IF;

               IF (request_.exclude_complementary_parts = TRUE) THEN
                  return_arr_(return_arr_.LAST).complementary_parts := Sales_Part_Structure_Suggested_Sales_Part_Arr();
               END IF;

               -- Add the assortment details separately since it is not entity based.
               IF (request_.include_attributes = TRUE) THEN
                  return_arr_(return_arr_.LAST).attributes := Get_Attribute_Structure_Arr___(request_.site, part_list_tab_(i));         
               ELSE
                  return_arr_(return_arr_.LAST).attributes := Sales_Part_Structure_Attribute_Arr();
               END IF;
            END LOOP;
         END IF;
      EXCEPTION
         WHEN OTHERS THEN
            error_text_ := sqlerrm;
            IF return_arr_.COUNT = 0 THEN
               return_arr_.EXTEND;
            END IF;
            return_arr_(return_arr_.LAST).error_text := error_text_; 
      END;
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOORDSRV: Component ORDSRV need to be installed to proceed with this request.');
   END IF;
   RETURN return_arr_;
END Get_Sales_Part;


-----------------------------------------------------------------------------
-- Get_Sales_Part_Status
--   Use this method to add a true/false parameter based on business logic within IFS.
--   Default implementation will always result in the value "TRUE" in the corresponding message attribute.
-----------------------------------------------------------------------------
@UncheckedAccess
FUNCTION Get_Sales_Part_Status (
   contract_   IN VARCHAR2,
   catalog_no_ IN VARCHAR2) RETURN VARCHAR2
IS
   part_status_ VARCHAR2(5) := 'TRUE';
BEGIN
   return part_status_;
END Get_Sales_Part_Status;


-----------------------------------------------------------------------------
-- Get_Customer_Price_Info
--    This method returns the sales part price information for a given
--    customer, site, currency code and part no.
-----------------------------------------------------------------------------
PROCEDURE Get_Customer_Price_Info(
   sale_unit_price_         OUT NUMBER,
   sale_unit_price_inc_vat_ OUT NUMBER,
   currency_rate_           OUT NUMBER,
   discount_                OUT NUMBER,
   sale_net_price_          OUT NUMBER,
   price_source_            OUT VARCHAR2,
   price_source_id_         OUT VARCHAR2,
   price_source_desc_       OUT VARCHAR2,
   minimum_qty_             OUT NUMBER,
   site_                    IN  VARCHAR2,
   customer_no_             IN  VARCHAR2,
   currency_code_           IN  VARCHAR2,
   agreement_id_            IN  VARCHAR2,
   catalog_no_              IN  VARCHAR2,
   quantity_                IN  VARCHAR2,
   price_list_no_           IN  VARCHAR2,
   effective_date_          IN  DATE,
   condition_code_          IN  VARCHAR2 )
IS
   contract_         VARCHAR2(5);
   temp_customer_no_ VARCHAR2(20);
BEGIN
   temp_customer_no_ := UPPER(customer_no_);
   -- Check that customer is valid and get default site.
   IF (Cust_Ord_Customer_API.Check_Exist(temp_customer_no_)) THEN
      contract_ := NVL(site_, Cust_Ord_Customer_API.Get_Edi_Site(temp_customer_no_));
      IF (User_Allowed_Site_API.Check_Exist(Fnd_Session_API.Get_Fnd_User, contract_)) THEN
      
         Get_Catalog_Sale_Price_Info___( sale_unit_price_     => sale_unit_price_,
                                         unit_price_incl_tax_ => sale_unit_price_inc_vat_,
                                         currency_rate_       => currency_rate_,
                                         discount_            => discount_,
                                         sale_net_price_      => sale_net_price_,
                                         price_source_        => price_source_,
                                         price_source_id_     => price_source_id_,
                                         contract_            => contract_,
                                         customer_no_         => temp_customer_no_,
                                         currency_code_       => currency_code_,
                                         agreement_id_        => agreement_id_,
                                         catalog_no_          => catalog_no_,
                                         buy_qty_due_         => quantity_,
                                         price_list_no_       => price_list_no_,
                                         effective_date_      => effective_date_,
                                         condition_code_      => condition_code_ );
         
         -- Note: Get sales part minimum quantity
         minimum_qty_ := NVL(Sales_Part_Api.Get_Minimum_Qty(contract_, catalog_no_), 1);
         
         -- Note: Get price source description
         IF (price_source_ IS NOT NULL) AND (price_source_id_ IS NOT NULL) THEN
            Get_Price_Source_Desc___(price_source_desc_, price_source_, price_source_id_);
         END IF;
      END IF;
   END IF;
EXCEPTION
      WHEN OTHERS THEN 
         RAISE;   
END Get_Customer_Price_Info;


-----------------------------------------------------------------------------
-- Get_Part_Availability_Info
--    This method returns the part availability information. 
-----------------------------------------------------------------------------
@UncheckedAccess
PROCEDURE Get_Part_Availability_Info (
   qty_available_        OUT    NUMBER,
   first_available_date_ OUT    DATE,
   contract_             IN OUT VARCHAR2,
   customer_no_          IN     VARCHAR2,
   address_id_           IN     VARCHAR2,
   cust_own_address_id_  IN     VARCHAR2,
   part_no_              IN     VARCHAR2,
   wanted_quantity_      IN     NUMBER,
   wanted_delivery_date_ IN     DATE )
IS
   delivery_address_id_        VARCHAR2(50);
   address_id_for_ean_loc_     VARCHAR2(50);
   temp_wanted_delivery_date_  DATE;
   temp_customer_no_           VARCHAR2(20);
   temp_wanted_quantity_       NUMBER;
   catalog_type_               VARCHAR2(10);
   comp_avail_date_            DATE;
   comp_wanted_delivery_date_  DATE;
   pkg_quantity_               NUMBER;
   result_                     VARCHAR2(40);
   all_comp_result_success_    BOOLEAN := TRUE;
   string_null_                VARCHAR2(12) := Database_Sys.string_null_;
   supply_site_                VARCHAR2(5);
   sourcing_option_db_         VARCHAR2(20);
   purchase_part_no_           VARCHAR2(25);
   primary_supplier_no_        VARCHAR2(20);

   CURSOR get_package(contract_ VARCHAR2, parent_part_ VARCHAR2) IS
      SELECT catalog_no, qty_per_assembly
      FROM   sales_part_package_tab
      WHERE  contract    = contract_
      AND    parent_part = parent_part_
      ORDER BY line_item_no;
BEGIN
   temp_customer_no_ := UPPER(customer_no_);
   contract_    := NVL(contract_, Cust_Ord_Customer_API.Get_Edi_Site(temp_customer_no_));

   sourcing_option_db_   := Sales_Part_API.Get_Sourcing_Option_Db(contract_, part_no_);
   IF (sourcing_option_db_ IN ('PRIMARYSUPPDIRECT', 'PRIMARYSUPPTRANSIT')) THEN
      purchase_part_no_  := Sales_Part_API.Get_Purchase_Part_No(contract_, part_no_);
      $IF (Component_Purch_SYS.INSTALLED)$THEN
         primary_supplier_no_ := Purchase_Part_Supplier_API.Get_Primary_Supplier_No(contract_, purchase_part_no_);
         IF (Supplier_API.Get_Category_Db(primary_supplier_no_) = 'I') THEN 
            supply_site_ := Supplier_API.Get_Acquisition_Site(primary_supplier_no_);
         END IF;
      $END
   END IF;
   contract_ := NVL(supply_site_, contract_);
   IF ((User_Allowed_Site_API.Check_Exist(Fnd_Session_API.Get_Fnd_User, contract_)) AND 
       (Sales_Part_API.Check_Exist(contract_, part_no_) = 1) AND 
       (temp_customer_no_ IS NULL OR Cust_Ord_Customer_API.Check_Exist(temp_customer_no_))) THEN  
             
      temp_wanted_delivery_date_ := NVL(TRUNC(wanted_delivery_date_), TRUNC(SYSDATE));
      temp_wanted_quantity_      := wanted_quantity_;
      catalog_type_              := Sales_Part_API.Get_Catalog_Type_Db(contract_, part_no_);

      IF (temp_customer_no_ IS NOT NULL) THEN
         delivery_address_id_ := Cust_Ord_Customer_API.Get_Delivery_Address(temp_customer_no_);
      END IF;

      -- If the given address id or customer's own address id is matched with delivery address id, then use it.
      IF (delivery_address_id_ IS NOT NULL) THEN
         IF (address_id_ IS NOT NULL) THEN
            IF (address_id_ != delivery_address_id_) THEN
               delivery_address_id_ := NULL;
            END IF;
         ELSIF (cust_own_address_id_ IS NOT NULL) THEN
            address_id_for_ean_loc_ := Customer_Info_Address_API.Get_Id_By_Ean_Location(temp_customer_no_, cust_own_address_id_);
            IF (NVL(address_id_for_ean_loc_, string_null_) != delivery_address_id_) THEN
               delivery_address_id_ := NULL;
            END IF;
         ELSE
            delivery_address_id_ := NULL;
         END IF;
      END IF;

      IF (catalog_type_ = 'NON') THEN
         first_available_date_ := temp_wanted_delivery_date_;

      ELSIF (catalog_type_ = 'INV') THEN
         -- Check availability of the inventory part
         Check_Inv_Availability___(result_,
                                   first_available_date_,
                                   temp_wanted_quantity_,
                                   temp_wanted_delivery_date_,
                                   temp_customer_no_,
                                   delivery_address_id_,
                                   part_no_,
                                   contract_);

         IF (result_ = 'SUCCESS')  THEN
            first_available_date_ := NULL;
         END IF;

      ELSIF (catalog_type_ = 'PKG') THEN
         first_available_date_ := temp_wanted_delivery_date_;
         FOR rec_ IN get_package(contract_, part_no_) LOOP
            IF (Sales_Part_API.Get_Catalog_Type_Db(contract_, rec_.catalog_no) = 'INV') THEN
               pkg_quantity_              := temp_wanted_quantity_ * rec_.qty_per_assembly;
               comp_wanted_delivery_date_ := temp_wanted_delivery_date_;

               -- Check availability of the inventory part
               Check_Inv_Availability___(result_,
                                         comp_avail_date_,
                                         pkg_quantity_,
                                         comp_wanted_delivery_date_,
                                         temp_customer_no_,
                                         delivery_address_id_,
                                         rec_.catalog_no,
                                         contract_);

               first_available_date_      := GREATEST(first_available_date_, comp_avail_date_);
               temp_wanted_delivery_date_ := GREATEST(temp_wanted_delivery_date_, comp_wanted_delivery_date_);
               temp_wanted_quantity_      := LEAST(temp_wanted_quantity_, TRUNC(pkg_quantity_/rec_.qty_per_assembly));

               IF (result_ != 'SUCCESS')  THEN
                  all_comp_result_success_ := FALSE;
               END IF;
            END IF;
         END LOOP;
         IF (all_comp_result_success_) THEN
            first_available_date_ := NULL;
         END IF;
      END IF;
      qty_available_ := temp_wanted_quantity_;
   ELSE
      Trace_SYS.Put_Line('No availability check for :P1', part_no_);
   END IF;
EXCEPTION
   WHEN OTHERS THEN 
      RAISE;
END Get_Part_Availability_Info;


-------------------- LU  NEW METHODS -------------------------------------
