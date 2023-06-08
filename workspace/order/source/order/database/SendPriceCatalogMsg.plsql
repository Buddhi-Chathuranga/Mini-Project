-----------------------------------------------------------------------------
--
--  Logical unit: SendPriceCatalogMsg
--  Component:    ORDER
--
--  IFS Developer Studio Template Version 3.0
--
--  Date        Sign    History
--  ----------  ------  --------------------------------------------------------------------------------
--  2021-07-07  DhAplk  SCZ-15455, Modified Send Agreement related methods by adding logic to recalculate valid_from and valid_to date for lines.
--  2021-01-15  DhAplk  SC2020R1-11651, Created to handle Send Price Catalog relavant logic separately.
-----------------------------------------------------------------------------

layer Core;

-------------------- PUBLIC DECLARATIONS ------------------------------------

-- This record type is used in Send_Price_List to store the send price list lines when tere are cteaed according to the user defined from_date and to_date
-- Before creating message lines this table is sorted according to the valid_from_date for a given price_list_no, part and @AllowTableOrViewAccess 
-- Instead of the references from sales_price_list_part_tab, the datatypes are defined To avoid ORA-00600: when using it for sorting.
TYPE Price_List_Line_Rec IS RECORD (
   price_list_no        VARCHAR2(10),
   catalog_no           VARCHAR2(25),
   min_quantity         NUMBER,
   valid_from_date      DATE,
   min_duration         NUMBER,
   contract             VARCHAR2(5),
   sales_price          NUMBER,
   sales_price_incl_tax NUMBER,
   discount             NUMBER,
   last_updated         DATE,
   valid_to_date        DATE );
   
TYPE Price_List_Line_Table IS TABLE OF Price_List_Line_Rec INDEX BY BINARY_INTEGER;

TYPE Agreement_Sales_Part_Deal_Keys_Rec IS RECORD (
   agreement_id                   VARCHAR2(10),
   catalog_no                     VARCHAR2(25),
   min_quantity                   NUMBER,
   valid_from_date                DATE,
   new_valid_from_date            DATE,
   valid_to_date                  DATE);

TYPE Agreement_Sales_Part_Deal_Keys_Table IS TABLE OF Agreement_Sales_Part_Deal_Keys_Rec;

-------------------- PRIVATE DECLARATIONS -----------------------------------


-------------------- LU SPECIFIC IMPLEMENTATION METHODS ---------------------

-- Get_Cust_Ord_Part_Deals_Details___
--   Used to get more information related to Deals lines using Get server calls.
PROCEDURE Get_Cust_Ord_Part_Deals_Details___ (
   cust_agr_rec_  IN OUT   Customer_Agreement_Struct_Rec )
IS
   classification_std_id_    VARCHAR2(25); 
   customer_part_no_         VARCHAR2(45);
   
   CURSOR get_xref_info(contract_ IN VARCHAR2, catalog_no_ IN VARCHAR2, customer_no_ IN VARCHAR2) IS
      SELECT customer_part_no
      FROM sales_part_cross_reference_tab
      WHERE contract    = contract_
      AND   catalog_no  = catalog_no_
      AND   customer_no = customer_no_;   
BEGIN
   classification_std_id_ := Customer_Assortment_Struct_API.Get_Classification_Standard(cust_agr_rec_.customer_no, 
                                                                                      Customer_Assortment_Struct_API.Find_Default_Assortment(cust_agr_rec_.customer_no)); 
   IF (cust_agr_rec_.part_deals IS NOT NULL) THEN
      IF (cust_agr_rec_.part_deals.COUNT > 0) THEN     
         Get_Modified_Part_Deals_Lines___(cust_agr_rec_);

         FOR i IN cust_agr_rec_.part_deals.FIRST .. cust_agr_rec_.part_deals.LAST LOOP 
            cust_agr_rec_.part_deals(i).message_line_status := 'ADDED';
            cust_agr_rec_.part_deals(i).sales_part.sales_group_description := Sales_Group_API.Get_Description(cust_agr_rec_.part_deals(i).sales_part.catalog_group);
            cust_agr_rec_.part_deals(i).sales_part.sales_price_group_description := Sales_Price_Group_API.Get_Description(cust_agr_rec_.part_deals(i).sales_part.sales_price_group_id);
            cust_agr_rec_.part_deals(i).gtin_no := Part_Gtin_API.Get_Default_Gtin_No(cust_agr_rec_.part_deals(i).catalog_no);

            Assortment_Node_API.Get_Classification_Defaults(cust_agr_rec_.part_deals(i).classification_unit_meas, cust_agr_rec_.part_deals(i).catalog_no,
                                                               cust_agr_rec_.part_deals(i).classification_part_no, classification_std_id_, 'TRUE');

            OPEN get_xref_info(cust_agr_rec_.part_deals(i).base_price_site, cust_agr_rec_.part_deals(i).catalog_no, cust_agr_rec_.customer_no);
            FETCH get_xref_info INTO customer_part_no_;
               IF get_xref_info%NOTFOUND THEN
                  customer_part_no_ := NULL;
               END IF;
            CLOSE get_xref_info;

            cust_agr_rec_.part_deals(i).customer_part_no := customer_part_no_;      
            cust_agr_rec_.part_deals(i).sales_part.inventory_part.prime_commodity_group_description := Commodity_Group_API.Get_Description(cust_agr_rec_.part_deals(i).sales_part.inventory_part.prime_commodity);
            cust_agr_rec_.part_deals(i).sales_part.inventory_part.second_commodity_group_description := Commodity_Group_API.Get_Description(cust_agr_rec_.part_deals(i).sales_part.inventory_part.second_commodity);
            cust_agr_rec_.part_deals(i).sales_part.inventory_part.product_code_description := Inventory_Product_Code_API.Get_Description(cust_agr_rec_.part_deals(i).sales_part.inventory_part.part_product_code);
            cust_agr_rec_.part_deals(i).sales_part.inventory_part.product_family_description  := Inventory_Product_Family_API.Get_Description(cust_agr_rec_.part_deals(i).sales_part.inventory_part.part_product_family);
         END LOOP;
      END IF;
   END IF;
END Get_Cust_Ord_Part_Deals_Details___;

-- Get_Modified_Part_Deals_Lines___
--   Used to get modifications of Part Deals lines and new lines based on valid_from and valid_to dates 
PROCEDURE Get_Modified_Part_Deals_Lines___ ( 
   cust_agr_rec_ IN OUT Customer_Agreement_Struct_Rec )
IS
   CURSOR past_valid_timeframe_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_from_date_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM  agreement_sales_part_deal_tab
      WHERE agreement_id = cust_agr_rec_.agreement_id
      AND   catalog_no = catalog_no_
      AND   min_quantity = min_quantity_
      AND   valid_to_date IS NOT NULL
      AND   valid_from_date < TRUNC(valid_from_date_)
      AND   valid_to_date >= TRUNC(valid_from_date_);   
      
   CURSOR get_next_record(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_from_date_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM  agreement_sales_part_deal_tab
      WHERE agreement_id = cust_agr_rec_.agreement_id
      AND   catalog_no = catalog_no_
      AND   min_quantity = min_quantity_
      AND   valid_from_date = (SELECT MIN(valid_from_date) valid_from_date
                               FROM agreement_sales_part_deal_tab
                               WHERE agreement_id = cust_agr_rec_.agreement_id
                               AND   catalog_no = catalog_no_
                               AND   min_quantity = min_quantity_                         
                               AND   valid_from_date > TRUNC(valid_from_date_));
                               
   CURSOR get_next_adjacent_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, new_valid_from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = cust_agr_rec_.agreement_id
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date = new_valid_from_date_;           
      
   CURSOR next_valid_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, valid_from_date_ IN DATE) IS
      SELECT MIN(valid_from_date) valid_from_date
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = cust_agr_rec_.agreement_id
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_from_date > valid_from_date_;   

   CURSOR check_overlap_rec_exist(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, line_valid_from_ IN DATE, next_valid_from_ IN DATE ) IS
      SELECT 1
      FROM   agreement_sales_part_deal_tab
      WHERE  agreement_id = cust_agr_rec_.agreement_id
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    valid_to_date IS NULL
      AND    valid_from_date > line_valid_from_
      AND    valid_from_date < next_valid_from_;
      
   modified_part_deals_        Customer_Agreement_Struct_Agreement_Sales_Part_Deal_Arr := Customer_Agreement_Struct_Agreement_Sales_Part_Deal_Arr(); 
   tmp_part_deals_             Agreement_Sales_Part_Deal_Keys_Table := Agreement_Sales_Part_Deal_Keys_Table();
   sorted_tmp_part_deals_      Agreement_Sales_Part_Deal_Keys_Table := Agreement_Sales_Part_Deal_Keys_Table();
   original_valid_from_        DATE;
   original_valid_to_          DATE;
   catalog_no_                 VARCHAR2(25);
   min_qty_                    NUMBER;
   line_valid_from_            DATE;
   line_valid_to_              DATE;
   next_from_date_             DATE;
   next_to_date_               DATE; 
   create_new_line_            BOOLEAN := FALSE; 
   new_line_from_date_         DATE;
   new_line_to_date_           DATE; 
   create_msg_line_            BOOLEAN := TRUE;
   next_valid_from_found_      BOOLEAN;
   next_valid_from_date_       DATE;
   create_current_line_        BOOLEAN;
   past_from_date_             DATE;
   past_to_date_               DATE;
   dummy_                      NUMBER;
   
   CURSOR get_sorted_table IS
      SELECT *
      FROM TABLE(tmp_part_deals_)
      ORDER BY agreement_id, catalog_no, min_quantity, new_valid_from_date;    
  
BEGIN
   IF (cust_agr_rec_.part_deals IS NOT NULL) THEN
      IF (cust_agr_rec_.part_deals.COUNT > 0) THEN 
         FOR i IN cust_agr_rec_.part_deals.FIRST .. cust_agr_rec_.part_deals.LAST LOOP 
            original_valid_from_  := cust_agr_rec_.part_deals(i).valid_from_date;
            original_valid_to_    := cust_agr_rec_.part_deals(i).valid_to_date;
            catalog_no_           := cust_agr_rec_.part_deals(i).catalog_no;
            min_qty_              := cust_agr_rec_.part_deals(i).min_quantity;
            create_msg_line_      := TRUE;
            line_valid_from_      := original_valid_from_;
            line_valid_to_        := NULL;     
            next_from_date_       := NULL;
            next_to_date_         := NULL;
            create_new_line_      := FALSE;
            next_valid_from_date_ := NULL;
            create_current_line_  := TRUE;

            -- Reorganize the valid_from and valid_to dates in each line
            IF (original_valid_to_ IS NOT NULL) THEN
                  line_valid_to_ := original_valid_to_;
            ELSE
               OPEN past_valid_timeframe_rec(catalog_no_, min_qty_, original_valid_from_);
               FETCH past_valid_timeframe_rec INTO past_from_date_, past_to_date_;
               CLOSE past_valid_timeframe_rec;

               IF (past_from_date_ IS NOT NULL) THEN
                  IF (original_valid_from_ < past_to_date_) THEN
                     line_valid_from_ := past_to_date_ + 1;  
                  END IF;
               END IF;

               OPEN get_next_record(catalog_no_, min_qty_, original_valid_from_);
               FETCH get_next_record INTO next_from_date_, next_to_date_;
               CLOSE get_next_record;
               IF (next_from_date_ IS NOT NULL) THEN

                  line_valid_to_ := next_from_date_ - 1;

                  IF (line_valid_to_ < line_valid_from_) THEN
                     create_current_line_ := FALSE;
                  END IF;

                  IF (next_to_date_ IS NOT NULL) THEN
                     -- check whether we need to create another line after the valid timeframe
                     create_new_line_ := FALSE;
                     next_valid_from_found_ := FALSE;
                     LOOP
                        EXIT WHEN next_valid_from_found_;
                        new_line_from_date_ := next_to_date_ + 1;
                        OPEN get_next_adjacent_rec(catalog_no_, min_qty_, new_line_from_date_);
                        FETCH get_next_adjacent_rec INTO next_to_date_;
                        IF (get_next_adjacent_rec%FOUND) THEN
                           CLOSE get_next_adjacent_rec;
                           next_from_date_ := new_line_from_date_;
                           IF (next_to_date_ IS NULL) THEN
                              next_valid_from_found_ := TRUE;
                              create_new_line_ := TRUE;   
                           END IF;
                        ELSE      
                           CLOSE get_next_adjacent_rec;
                           create_new_line_ := TRUE;
                           next_valid_from_found_ := TRUE;
                           next_from_date_ := new_line_from_date_;
                        END IF;
                     END LOOP;
                  END IF;
                  IF (create_new_line_) THEN
                     IF (next_to_date_ IS NULL) THEN
                        create_new_line_ := FALSE;
                     ELSE
                        new_line_from_date_ := GREATEST(new_line_from_date_, line_valid_from_);

                        OPEN next_valid_rec(catalog_no_, min_qty_, next_from_date_);
                        FETCH next_valid_rec INTO next_valid_from_date_;
                        CLOSE next_valid_rec;

                        IF (next_valid_from_date_ IS NOT NULL) THEN
                           OPEN check_overlap_rec_exist(catalog_no_, min_qty_, original_valid_from_, next_valid_from_date_);
                           FETCH check_overlap_rec_exist INTO dummy_;
                           IF (check_overlap_rec_exist%FOUND) THEN
                              CLOSE check_overlap_rec_exist;
                              -- this new line will be created by the overlapping record
                              create_new_line_ := FALSE;
                           ELSE
                             CLOSE check_overlap_rec_exist;
                           END IF;
                           IF (next_valid_from_date_ < next_to_date_) THEN
                              create_new_line_ := FALSE;
                           ELSE 
                              new_line_to_date_ := next_valid_from_date_ - 1;
                           END IF;
                        ELSE
                           new_line_to_date_ := null;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            END IF;

            IF (NOT (create_current_line_) AND NOT(create_new_line_)) THEN
               create_msg_line_ := FALSE;
            END IF;

            -- Adding modifications of dates and new lines for temp table
            IF (create_msg_line_) THEN
               IF (create_current_line_) THEN
                  tmp_part_deals_.extend;
                  tmp_part_deals_(tmp_part_deals_.last).agreement_id := cust_agr_rec_.part_deals(i).agreement_id;
                  tmp_part_deals_(tmp_part_deals_.last).catalog_no := cust_agr_rec_.part_deals(i).catalog_no;
                  tmp_part_deals_(tmp_part_deals_.last).min_quantity := cust_agr_rec_.part_deals(i).min_quantity;
                  tmp_part_deals_(tmp_part_deals_.last).valid_from_date := cust_agr_rec_.part_deals(i).valid_from_date;
                  tmp_part_deals_(tmp_part_deals_.last).new_valid_from_date := line_valid_from_;
                  tmp_part_deals_(tmp_part_deals_.last).valid_to_date := line_valid_to_; 
               END IF;
               IF (create_new_line_) THEN
                  tmp_part_deals_.extend;
                  tmp_part_deals_(tmp_part_deals_.last).agreement_id := cust_agr_rec_.part_deals(i).agreement_id;
                  tmp_part_deals_(tmp_part_deals_.last).catalog_no := cust_agr_rec_.part_deals(i).catalog_no;
                  tmp_part_deals_(tmp_part_deals_.last).min_quantity := cust_agr_rec_.part_deals(i).min_quantity;
                  tmp_part_deals_(tmp_part_deals_.last).valid_from_date := cust_agr_rec_.part_deals(i).valid_from_date;
                  tmp_part_deals_(tmp_part_deals_.last).new_valid_from_date := new_line_from_date_;
                  tmp_part_deals_(tmp_part_deals_.last).valid_to_date := new_line_to_date_; 
               END IF;
            END IF;
            create_new_line_ := FALSE;               
         END LOOP; 
      END IF;
   END IF;
   
   IF (tmp_part_deals_ IS NOT NULL) THEN
      IF (tmp_part_deals_.COUNT > 0) THEN 
         -- Sorting records on valid from date
         OPEN get_sorted_table;
         FETCH get_sorted_table BULK COLLECT INTO sorted_tmp_part_deals_; 
         CLOSE get_sorted_table;  

         -- Getting sorted records and assign line attribute values into modified_part_deals_ from cust_agr_rec_.part_deals lines
         IF (sorted_tmp_part_deals_ IS NOT NULL) THEN
            IF (sorted_tmp_part_deals_.COUNT > 0) THEN 
               FOR i IN sorted_tmp_part_deals_.FIRST .. sorted_tmp_part_deals_.LAST LOOP
                  FOR j IN cust_agr_rec_.part_deals.FIRST .. cust_agr_rec_.part_deals.LAST LOOP      
                     IF(sorted_tmp_part_deals_(i).agreement_id = cust_agr_rec_.part_deals(j).agreement_id
                         AND sorted_tmp_part_deals_(i).catalog_no = cust_agr_rec_.part_deals(j).catalog_no
                         AND sorted_tmp_part_deals_(i).min_quantity = cust_agr_rec_.part_deals(j).min_quantity
                         AND sorted_tmp_part_deals_(i).valid_from_date = cust_agr_rec_.part_deals(j).valid_from_date) THEN
                        modified_part_deals_.extend;
                        modified_part_deals_(modified_part_deals_.last) := cust_agr_rec_.part_deals(j);
                        modified_part_deals_(modified_part_deals_.last).valid_from_date := sorted_tmp_part_deals_(i).new_valid_from_date;
                        modified_part_deals_(modified_part_deals_.last).valid_to_date := sorted_tmp_part_deals_(i).valid_to_date;
                     END IF;      
                  END LOOP;   
               END LOOP;
            END IF;
         END IF;
      END IF;
   END IF;
           
   cust_agr_rec_.part_deals := modified_part_deals_;
END Get_Modified_Part_Deals_Lines___;

-- Send_Agreement_Mhs_Edi___
--   Used to send agreement information for EDI/MHS setup.
PROCEDURE Send_Agreement_Mhs_Edi___ (
   cust_agr_rec_  IN Customer_Agreement_Struct_Rec,
   receiver_address_     IN VARCHAR2,
   media_code_           IN VARCHAR2 )
IS
   message_type_     VARCHAR2(6)  := 'PRICAT';
   sender_address_   VARCHAR2(200);
   attr_             VARCHAR2(4000);
   message_id_       NUMBER;
   message_line_     NUMBER;
   message_name_     VARCHAR2(12);
BEGIN
      sender_address_ := Company_Msg_Setup_API.Get_Address(cust_agr_rec_.company, media_code_, message_type_);
      
      --Create OUT_MESSAGE
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('CLASS_ID', message_type_, attr_);
      Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, attr_);
      Client_SYS.Add_To_Attr('RECEIVER', receiver_address_, attr_);
      Client_SYS.Add_To_Attr('SENDER', sender_address_, attr_);
      Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', cust_agr_rec_.agreement_id, attr_);
      Client_SYS.Add_To_Attr('APPLICATION_RECEIVER_ID', cust_agr_rec_.customer_no, attr_);

      Connectivity_SYS.Create_Message(message_id_, attr_);

      -- Create OUT_MESSAGE_LINE (for header)
      message_name_ := 'HEADER';
      message_line_ := 1;
      Client_SYS.Clear_Attr(attr_);
      Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
      Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
      Client_SYS.Add_To_Attr('NAME', message_name_, attr_);
      Client_SYS.Add_To_Attr('C01', cust_agr_rec_.agreement_status, attr_);  
      Client_SYS.Add_To_Attr('C02', cust_agr_rec_.cust_agreement_id, attr_);
      Client_SYS.Add_To_Attr('C03', cust_agr_rec_.ean_location, attr_);
      Client_SYS.Add_To_Attr('C04', cust_agr_rec_.supplier_id , attr_);
      Client_SYS.Add_To_Attr('C05', cust_agr_rec_.company, attr_);
      Client_SYS.Add_To_Attr('C06', cust_agr_rec_.customer_ean_location, attr_);
      Client_SYS.Add_To_Attr('C07', cust_agr_rec_.customer_no, attr_);
      Client_SYS.Add_To_Attr('C09', cust_agr_rec_.sup_agreement_id, attr_);
      Client_SYS.Add_To_Attr('C10', cust_agr_rec_.currency_code, attr_);
      Client_SYS.Add_To_Attr('C11', cust_agr_rec_.agreement_id, attr_);
      Client_SYS.Add_To_Attr('C13', cust_agr_rec_.delivery_terms, attr_);
      Client_SYS.Add_To_Attr('C14', cust_agr_rec_.delivery_terms_description, attr_);
      Client_SYS.Add_To_Attr('C15', cust_agr_rec_.ship_via_code, attr_);
      Client_SYS.Add_To_Attr('C16', cust_agr_rec_.ship_via_description, attr_);
      IF (cust_agr_rec_.use_price_incl_tax IS NOT NULL) THEN
         IF (cust_agr_rec_.use_price_incl_tax) THEN
            Client_SYS.Add_To_Attr('C17', 'TRUE', attr_);
         ELSE
            Client_SYS.Add_To_Attr('C17', 'FALSE', attr_);
         END IF;
      END IF;     
      Client_Sys.Add_To_Attr('C95', cust_agr_rec_.company_association_no, attr_);
      Client_SYS.Add_To_Attr('C96', cust_agr_rec_.customer_association_no, attr_);
      Client_SYS.Add_To_Attr('D00', cust_agr_rec_.agreement_date, attr_);
      Client_SYS.Add_To_Attr('D01', cust_agr_rec_.valid_from, attr_);
      Client_SYS.Add_To_Attr('D02', cust_agr_rec_.valid_until, attr_);
      Client_SYS.Add_To_Attr('N20', cust_agr_rec_.sequence_no, attr_);
      Client_SYS.Add_To_Attr('N21', cust_agr_rec_.version_no, attr_);
      Connectivity_SYS.Create_Message_Line(attr_); 
      
      IF (cust_agr_rec_.part_deals IS NOT NULL) THEN
         IF (cust_agr_rec_.part_deals.COUNT > 0) THEN
            FOR i IN cust_agr_rec_.part_deals.FIRST .. cust_agr_rec_.part_deals.LAST LOOP           
               -- Create OUT_MESSAGE_LINE (for lines)
               message_line_ := message_line_ + 1;
               message_name_ := 'LINE';
               Trace_SYS.Field('Creating message LINE', message_line_);
               Client_SYS.Clear_Attr(attr_);
               Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
               Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
               Client_SYS.Add_To_Attr('NAME', message_name_, attr_);
               Client_SYS.Add_To_Attr('C00', 'ADDED', attr_);  -- price catalog action code is always "Added"         
               Client_SYS.Add_To_Attr('C02', cust_agr_rec_.part_deals(i).catalog_no, attr_);         
               Client_SYS.Add_To_Attr('C03', cust_agr_rec_.part_deals(i).customer_part_no, attr_);
               Client_SYS.Add_To_Attr('C04', cust_agr_rec_.currency_code, attr_);
               Client_SYS.Add_To_Attr('C05', cust_agr_rec_.part_deals(i).sales_part.price_unit_meas, attr_);
               Client_SYS.Add_To_Attr('C06', cust_agr_rec_.agreement_id, attr_);
               Client_SYS.Add_To_Attr('C07', cust_agr_rec_.part_deals(i).sales_part.catalog_group, attr_);
               Client_SYS.Add_To_Attr('C08', cust_agr_rec_.part_deals(i).sales_part.sales_group_description, attr_);
               Client_SYS.Add_To_Attr('C09', cust_agr_rec_.part_deals(i).sales_part.sales_price_group_id, attr_);
               Client_SYS.Add_To_Attr('C10', cust_agr_rec_.part_deals(i).sales_part.sales_price_group_description, attr_);         
               Client_SYS.Add_To_Attr('C11', cust_agr_rec_.part_deals(i).sales_part.inventory_part.prime_commodity, attr_);            
               Client_SYS.Add_To_Attr('C12', cust_agr_rec_.part_deals(i).sales_part.inventory_part.prime_commodity_group_description, attr_);           
               Client_SYS.Add_To_Attr('C13', cust_agr_rec_.part_deals(i).sales_part.inventory_part.second_commodity, attr_);
               Client_SYS.Add_To_Attr('C14', cust_agr_rec_.part_deals(i).sales_part.inventory_part.second_commodity_group_description, attr_);          
               Client_SYS.Add_To_Attr('C15', cust_agr_rec_.part_deals(i).sales_part.inventory_part.part_product_code, attr_);           
               Client_SYS.Add_To_Attr('C16', cust_agr_rec_.part_deals(i).sales_part.inventory_part.product_code_description, attr_);
               Client_SYS.Add_To_Attr('C17', cust_agr_rec_.part_deals(i).sales_part.inventory_part.part_product_family, attr_);
               Client_SYS.Add_To_Attr('C18', cust_agr_rec_.part_deals(i).sales_part.inventory_part.product_family_description, attr_);           
               Client_SYS.Add_To_Attr('C19', cust_agr_rec_.part_deals(i).gtin_no, attr_);   
               Client_SYS.Add_To_Attr('C20', cust_agr_rec_.part_deals(i).classification_part_no, attr_);
               Client_SYS.Add_To_Attr('C21', cust_agr_rec_.part_deals(i).classification_unit_meas, attr_);   
               Client_SYS.Add_To_Attr('D00', cust_agr_rec_.part_deals(i).valid_from_date, attr_);
               Client_SYS.Add_To_Attr('D01', cust_agr_rec_.part_deals(i).valid_to_date, attr_);
               Client_SYS.Add_To_Attr('N00', cust_agr_rec_.part_deals(i).deal_price, attr_);
               Client_SYS.Add_To_Attr('N05', cust_agr_rec_.part_deals(i).deal_price_incl_tax, attr_);
               Client_SYS.Add_To_Attr('N01', nvl(cust_agr_rec_.part_deals(i).discount, 0), attr_);
               Client_SYS.Add_To_Attr('N02', NVL(cust_agr_rec_.part_deals(i).min_quantity, 0), attr_);

               Connectivity_SYS.Create_Message_Line(attr_);            
            END LOOP;
         END IF;    
      END IF;
      -- 'RELEASE' the message in the Out_Message box
      Connectivity_SYS.Release_Message(message_id_);
END Send_Agreement_Mhs_Edi___;
   
-- Send_Agreement_Inet_Trans___
--   Used to send agreement information for INET_TRANS setup.
PROCEDURE Send_Agreement_Inet_Trans___ (
   cust_agr_rec_        IN Customer_Agreement_Struct_Rec,
   receiver_address_    IN VARCHAR2 )
IS
   json_obj_         JSON_OBJECT_T;
   json_clob_        CLOB;
   msg_id_           NUMBER;
BEGIN   
   IF Dictionary_SYS.Component_Is_Active('ITS') THEN
      --Create_Json_File___ 
      json_obj_ := Customer_Agreement_Struct_Rec_To_Json___(cust_agr_rec_);
      json_clob_ := json_obj_.to_clob;

      Plsqlap_Server_API.Post_Outbound_Message(json_clob_,
                                            msg_id_,                                              
                                            cust_agr_rec_.company, 
                                            receiver_address_, 
                                            message_type_ => 'APPLICATION_MESSAGE',                                               
                                            message_function_ => 'SEND_PRICAT_FOR_AGREEMENT_INET_TRANS',
                                            is_json_ => true);  
   ELSE
      Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
   END IF;
END Send_Agreement_Inet_Trans___;

-------------------- LU SPECIFIC PRIVATE METHODS ----------------------------


-------------------- LU SPECIFIC PROTECTED METHODS --------------------------


-------------------- LU SPECIFIC PUBLIC METHODS -----------------------------

-- Send_Agreement
--   Sends an outbound price catalog to the connectivity outbox for EDI/MHS setup.
--   Or Creates an application message directly if the media code is 'INET_TRANS'
PROCEDURE Send_Agreement (
   agreement_id_ IN VARCHAR2,
   media_code_   IN VARCHAR2,
   valid_from_   IN DATE DEFAULT NULL )
IS
   contract_         VARCHAR2(5);
   cust_agr_rec_     Customer_Agreement_Struct_Rec; 
   site_date_        DATE;
   valid_            BOOLEAN;
   customer_no_      CUSTOMER_AGREEMENT_TAB.customer_no%TYPE;
   language_code_    VARCHAR2(2);
   message_type_     VARCHAR2(30);
   receiver_address_ VARCHAR2(2000);  
BEGIN
   -- check if the media code exists - user can enter whatever value he/she likes
   Message_Media_API.Exist(media_code_);
   
   cust_agr_rec_ := Get_Customer_Agreement_Struct_Rec___(agreement_id_, valid_from_);

   -- contract fetched from valid for site at Customer Agreement
   contract_  := Customer_Agreement_API.Get_Contract(agreement_id_);
   site_date_ := Site_API.Get_Site_Date(contract_);

   -- Check if agreement is valid for use
   IF ((cust_agr_rec_.valid_from > site_date_) OR (NVL(cust_agr_rec_.valid_until, site_date_ + 1) < site_date_)) THEN
      valid_ := FALSE;
   ELSE
      valid_ := (Customer_Agreement_API.Is_Active(agreement_id_) = 1);
   END IF;

   IF NOT valid_ THEN
      Error_SYS.Record_General(lu_name_, 'NOT_VALID: Agreement :P1 is not valid for use!', agreement_id_);
   ELSIF (Customer_Agreement_API.Has_Part_Deal(agreement_id_) = 0) THEN
      Trace_SYS.Message('Agreement has no parts');
      Error_SYS.Record_General(lu_name_, 'AGR_NOT_PART_BASED: Agreement :P1 is not part based.', agreement_id_);
   END IF;

   message_type_   := 'PRICAT';
   customer_no_    := cust_agr_rec_.customer_no;

   -- Retrieve postal address of company (sender) from Enterprise
   cust_agr_rec_.company := Site_API.Get_Company(contract_);

   cust_agr_rec_.ean_location   := Company_Address_API.Get_Ean_Location(cust_agr_rec_.company, Site_Discom_Info_API.Get_Document_Address_Id(contract_,'FALSE'));
   cust_agr_rec_.company_association_no := Company_API.Get_Association_No(cust_agr_rec_.company);
   cust_agr_rec_.customer_association_no := Customer_Info_API.Get_Association_No(customer_no_);

   receiver_address_ := Customer_Info_Msg_Setup_API.Get_Address(customer_no_, media_code_, message_type_);
   IF (receiver_address_ IS NULL) THEN
      Error_SYS.Record_General(lu_name_, 'NO_RECEIVER_ADDR: There is no receiver address specified for the :P1 message PRICAT for customer :P2!', media_code_, customer_no_);
   END IF; 
   --sup_agreement_id_ := cust_agr_rec_.sup_agreement_id;
   IF (cust_agr_rec_.agreement_sent = 'Y') THEN
      cust_agr_rec_.agreement_status := 'REPLACEMENT';
      IF (cust_agr_rec_.sup_agreement_id IS NULL) THEN
         cust_agr_rec_.sup_agreement_id := agreement_id_;
      END IF;
   ELSIF (cust_agr_rec_.sup_agreement_id IS NOT NULL) THEN
      cust_agr_rec_.agreement_status := 'REPLACEMENT';
   ELSE
      cust_agr_rec_.agreement_status := 'ORIGINAL';
      cust_agr_rec_.sup_agreement_id := NULL;
   END IF;
   
   cust_agr_rec_.supplier_id   := Customer_Order_Transfer_API.Get_Supplier_Id(cust_agr_rec_.company, contract_, customer_no_, NULL);
   language_code_ := Cust_Ord_Customer_API.Get_Language_Code(customer_no_);
   cust_agr_rec_.customer_ean_location := Customer_Info_Address_API.Get_Ean_Location(customer_no_, Customer_Info_Address_API.Get_Default_Address(customer_no_, Address_Type_Code_API.Decode('INVOICE')));
   cust_agr_rec_.delivery_terms_description := Order_Delivery_Term_API.Get_Description(cust_agr_rec_.delivery_terms, language_code_);
   cust_agr_rec_.ship_via_description := mpccom_Ship_Via_API.Get_Description(cust_agr_rec_.ship_via_code, language_code_);
   cust_agr_rec_.sequence_no := Customer_Agreement_API.Get_Msg_Sequence_No (agreement_id_);
            
   IF (cust_agr_rec_.sequence_no IS NULL) THEN
      -- This is the first time the Agreement is being sent. 
      -- Obtain a new sequence_no and set the version_no to 0.
      cust_agr_rec_.sequence_no := Customer_Info_Msg_Setup_API.Increase_Sequence_No(customer_no_, media_code_, message_type_);   
      cust_agr_rec_.version_no  := 0; 
   ELSE
      -- The Agreement is being resent
      -- Reuse the existing sequence_no and increment the version.
      cust_agr_rec_.version_no := Customer_Agreement_API.Get_Msg_Version_No (agreement_id_) + 1; 
   END IF;  
   
   Get_Cust_Ord_Part_Deals_Details___(cust_agr_rec_);
   
   IF media_code_ = 'INET_TRANS' THEN
      Send_Agreement_Inet_Trans___(cust_agr_rec_, receiver_address_);
   ELSE
      Send_Agreement_Mhs_Edi___(cust_agr_rec_, receiver_address_, media_code_);
   END IF;
   
   Customer_Agreement_API.Set_Msg_Sequence_And_Version (agreement_id_, cust_agr_rec_.sequence_no , cust_agr_rec_.version_no);
  
-- Set this agreement's send flag
   IF (cust_agr_rec_.agreement_sent = 'N') THEN
      Customer_Agreement_API.Set_Agreement_Sent(agreement_id_, 'Y');
   END IF;
END Send_Agreement;


-- Send_Sales_Price_List
--   Sends an outbound price catalog to the connectivity outbox for EDI/MHS setup.
--   Creates an application message directly if the media code is 'INET_TRANS'
PROCEDURE Send_Sales_Price_List (
   price_list_no_    IN VARCHAR2,
   media_code_       IN VARCHAR2,
   customer_no_list_ IN VARCHAR2,
   valid_from_       IN DATE,
   valid_to_         IN DATE,
   price_list_site_  IN VARCHAR2 DEFAULT NULL )
IS
   contract_          VARCHAR2(5) := User_Default_API.Get_Contract;
   site_date_         DATE;
   company_           VARCHAR2(20);
   ean_location_      VARCHAR2(100);
   ptr_               NUMBER := NULL;
   name_              VARCHAR2(35);
   customer_no_       SALES_PART_CROSS_REFERENCE_TAB.customer_no%TYPE;
   attr_              VARCHAR2(2000);
   message_id_        NUMBER;
   message_line_      NUMBER;
   message_type_      VARCHAR2(30);
   message_name_      VARCHAR2(255);
   sender_address_    VARCHAR2(2000);
   receiver_address_  VARCHAR2(2000);
   status_            VARCHAR2(20);
   sup_price_list_no_ VARCHAR2(10);
   headrec_           Sales_Price_List_API.Public_Rec;
   user_              VARCHAR2(30) := Fnd_Session_API.Get_Fnd_User;

   CURSOR get_line_info IS
      SELECT base_price_site contract, catalog_no, sales_price, sales_price_incl_tax, discount,
             min_quantity, last_updated, valid_from_date, valid_to_date, min_duration
      FROM ((SELECT *
             FROM sales_price_list_part_tab a
             WHERE a.price_list_no = price_list_no_
             AND   a.sales_price_type = 'SALES PRICES'
             AND   TRUNC(a.valid_from_date) <= TRUNC(valid_from_)
             AND  (a.catalog_no, a.min_quantity , a.valid_from_date, a.min_duration) IN (SELECT catalog_no, min_quantity, MAX(valid_from_date), min_duration
                                                                                         FROM   sales_price_list_part_tab b
                                                                                         WHERE  a.price_list_no = b.price_list_no
                                                                                         AND    a.catalog_no = b.catalog_no
                                                                                         AND    a.min_quantity = b.min_quantity
                                                                                         AND    a.min_duration = b.min_duration
                                                                                         AND    sales_price_type = 'SALES PRICES'
                                                                                         AND    b.valid_to_date IS NULL
                                                                                         AND    TRUNC(b.valid_from_date) <= TRUNC(valid_from_)
                                                                                         GROUP BY b.catalog_no, b.min_quantity, b.min_duration))
            UNION ALL
           (SELECT *
            FROM   sales_price_list_part_tab c
            WHERE  c.price_list_no = price_list_no_
            AND    c.rowstate = 'Active'
            AND    c.sales_price_type = 'SALES PRICES' 
            AND    c.valid_to_date IS NOT NULL
            AND    TRUNC(c.valid_from_date) <= TRUNC(valid_from_)
            AND    TRUNC(c.valid_to_date) >= TRUNC(valid_from_))
            UNION ALL
           (SELECT *
            FROM   sales_price_list_part_tab d
            WHERE  d.price_list_no = price_list_no_
            AND    d.rowstate = 'Active'
            AND    d.sales_price_type = 'SALES PRICES'
            AND    TRUNC(d.valid_from_date) > TRUNC(valid_from_)
            AND    (TRUNC(valid_to_) IS NULL OR (TRUNC(valid_to_) IS NOT NULL AND TRUNC(d.valid_from_date) <= TRUNC(valid_to_)))))
      ORDER BY catalog_no, min_quantity, min_duration, valid_from_date;
   
   CURSOR get_xref_info(contract_ IN VARCHAR2, catalog_no_ IN VARCHAR2) IS
      SELECT customer_part_no
      FROM sales_part_cross_reference_tab
      WHERE contract = contract_
      AND   catalog_no = catalog_no_
      AND   customer_no= customer_no_;
 
   CURSOR past_valid_timeframe_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, valid_from_date_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM  sales_price_list_part_tab
      WHERE price_list_no = price_list_no_
      AND   catalog_no = catalog_no_
      AND   min_quantity = min_quantity_
      AND   min_duration = min_duration_
      AND   valid_to_date IS NOT NULL
      AND   valid_from_date < TRUNC(valid_from_date_)
      AND   valid_to_date >= TRUNC(valid_from_date_)
      AND   valid_to_date >= TRUNC(valid_from_); 
      
   CURSOR get_next_record(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, valid_from_date_ IN DATE) IS
      SELECT valid_from_date, valid_to_date
      FROM  sales_price_list_part_tab
      WHERE price_list_no = price_list_no_
      AND   catalog_no = catalog_no_
      AND   min_quantity = min_quantity_
      AND   min_duration = min_duration_
      AND   valid_from_date = (SELECT MIN(valid_from_date) valid_from_date
                               FROM sales_price_list_part_tab
                               WHERE price_list_no = price_list_no_
                               AND   catalog_no = catalog_no_
                               AND   min_quantity = min_quantity_
                               AND   min_duration = min_duration_                           
                               AND   valid_from_date > TRUNC(valid_from_date_)
                               AND  ((valid_to_ IS NOT NULL AND valid_from_date <= TRUNC(valid_to_)) OR (valid_to_ IS NULL)));
      
   CURSOR get_next_adjacent_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, new_valid_from_date_ IN DATE) IS
      SELECT valid_to_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_from_date = new_valid_from_date_;
      
   CURSOR next_valid_rec(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, valid_from_date_ IN DATE) IS
      SELECT MIN(valid_from_date) valid_from_date
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_from_date > valid_from_date_;
   
   CURSOR check_overlap_rec_exist(catalog_no_ IN VARCHAR2, min_quantity_ IN NUMBER, min_duration_ IN NUMBER, line_valid_from_ IN DATE, next_valid_from_ IN DATE ) IS
      SELECT 1
      FROM   sales_price_list_part_tab
      WHERE  price_list_no = price_list_no_
      AND    catalog_no = catalog_no_
      AND    min_quantity = min_quantity_
      AND    min_duration = min_duration_
      AND    valid_to_date IS NULL
      AND    valid_from_date > line_valid_from_
      AND    valid_from_date < next_valid_from_;
         
   customer_part_no_    VARCHAR2(45);
   sprec_               Sales_Part_API.Public_Rec;
   iprec_               Inventory_Part_API.Public_Rec;
   line_valid_from_     DATE;
   line_valid_to_       DATE;
   next_from_date_      DATE;
   next_to_date_        DATE; 
   create_new_line_     BOOLEAN := FALSE; 
   new_line_attr_       VARCHAR2(2000);
   new_line_from_date_  DATE;
   new_line_to_date_    DATE; 
   create_msg_line_     BOOLEAN := TRUE;
   old_valid_from_        DATE;
   old_valid_to_          DATE;  
   next_valid_from_found_ BOOLEAN;
   next_valid_from_date_  DATE;
   create_current_line_   BOOLEAN;
   price_list_line_tab_   Price_List_Line_Table;
   index_                 NUMBER;
   count_                 NUMBER := 0;
   sorted_price_list_line_tab_   Price_List_Line_Table;
   past_from_date_        DATE;
   past_to_date_          DATE;
   dummy_                 NUMBER;
   company_association_no_ VARCHAR2(50);
   
   supplier_id_                 VARCHAR2(35);
   customer_ean_location_       VARCHAR2(100);
   customer_association_no_     VARCHAR2(200);
   sales_group_desc_            VARCHAR2(35);
   sales_price_group_desc_      VARCHAR2(35);
   prime_commodity_group_desc_  VARCHAR2(35);
   second_commodity_group_desc_ VARCHAR2(35);
   inv_product_code_desc_       VARCHAR2(35);
   inv_product_familiy_desc_    VARCHAR2(35);
   gtin_no_                     VARCHAR2(14);
   -- Structure is defined in SalesPriceList.fragment
   price_list_rec_              Send_Price_Catalog_Msg_API.Sales_Price_List_Struct_Rec;
   sales_price_list_parts_      Send_Price_Catalog_Msg_API.Sales_Price_List_Struct_Sales_Price_List_Part_Arr := Send_Price_Catalog_Msg_API.Sales_Price_List_Struct_Sales_Price_List_Part_Arr();     
   json_obj_                    JSON_OBJECT_T;
   json_clob_                   CLOB;
   msg_id_                      NUMBER;
   
   CURSOR get_sorted_table IS
      SELECT price_list_no, catalog_no, min_quantity, valid_from_date, min_duration, contract, sales_price, sales_price_incl_tax, discount, last_updated, valid_to_date
      FROM TABLE(price_list_line_tab_)
      ORDER BY price_list_no, catalog_no, min_quantity, valid_from_date, min_duration;

BEGIN
   -- check if the media code exists - user can enter whatever value he/she likes
   Message_Media_API.Exist(media_code_);

   Sales_Price_List_API.Check_Readable(price_list_no_);

   -- check if the site is exist and whether it is allowed for the User
   IF price_list_site_ IS NOT NULL THEN
      Site_API.Exist(price_list_site_);
      User_Allowed_Site_API.Exist(user_,price_list_site_);
      contract_ := price_list_site_;
      -- Check if the site exist in Price List
      Sales_Price_List_Site_API.Exist(price_list_site_,price_list_no_);
   END IF;

   site_date_ := Site_API.Get_Site_Date(contract_);
   headrec_ := Sales_Price_List_API.Get(price_list_no_);

   IF (nvl(Sales_Price_Group_API.Get_Sales_Price_Group_Type_Db(headrec_.sales_price_group_id), '*') != 'PART BASED') THEN
      Error_SYS.Record_General(lu_name_, 'NOT_PART_BASED: Price list :P1 is not part based.', price_list_no_);
   END IF;

   message_type_ := 'PRICAT';

   -- Retrieve postal address of company (sender) from Enterprise
   company_        := Site_API.Get_Company(contract_);
   sender_address_ := Company_Msg_Setup_API.Get_Address(company_, media_code_, message_type_);
   ean_location_   := Company_Address_API.Get_Ean_Location(company_, Site_Discom_Info_API.Get_Document_Address_Id(contract_,'FALSE'));
   company_association_no_ := Company_Api.Get_Association_No(company_);

   WHILE (Client_SYS.Get_Next_From_Attr(customer_no_list_, ptr_, name_, customer_no_)) LOOP
      receiver_address_ := Customer_Info_Msg_Setup_API.Get_Address(customer_no_, media_code_, message_type_);
      sup_price_list_no_ := headrec_.sup_price_list_no;  
      
      IF (receiver_address_ IS NULL) THEN
         Error_SYS.Record_General(lu_name_, 'NO_RECEIVER_ADDR: There is no receiver address specified for the :P1 message PRICAT for customer :P2!', media_code_, customer_no_);
      END IF;
      
      IF (Sales_Price_List_Send_Log_API.Is_Price_List_Sent(price_list_no_, customer_no_) = 1) THEN
         status_ := 'REPLACEMENT';
         IF (headrec_.sup_price_list_no IS NULL) THEN
            sup_price_list_no_ := price_list_no_;
         END IF;
      ELSIF (headrec_.sup_price_list_no IS NOT NULL) THEN
         status_ := 'REPLACEMENT';
      ELSE
         status_ := 'ORIGINAL';
         sup_price_list_no_ := NULL;
      END IF;
      
      supplier_id_ :=  Customer_Order_Transfer_API.Get_Supplier_Id(company_, contract_, customer_no_, NULL);
      customer_ean_location_ := Customer_Info_Address_API.Get_Ean_Location(customer_no_, Customer_Info_Address_API.Get_Default_Address(customer_no_, Address_Type_Code_API.Decode('INVOICE')));
      customer_association_no_ := Customer_Info_API.Get_Association_No(customer_no_);
      
      IF media_code_ != 'INET_TRANS' THEN
         -- Create OUT_MESSAGE
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Add_To_Attr('CLASS_ID', message_type_, attr_);
         Client_SYS.Add_To_Attr('MEDIA_CODE', media_code_, attr_);
         Client_SYS.Add_To_Attr('RECEIVER', receiver_address_, attr_);
         Client_SYS.Add_To_Attr('SENDER', sender_address_, attr_);
         Client_SYS.Add_To_Attr('APPLICATION_MESSAGE_ID', price_list_no_, attr_);
         Client_SYS.Add_To_Attr('APPLICATION_RECEIVER_ID', customer_no_, attr_);

         Connectivity_SYS.Create_Message(message_id_, attr_);

         -- Create OUT_MESSAGE_LINE (for header)
         message_name_ := 'HEADER';
         message_line_ := 1;
         Trace_SYS.Message('Creating message HEADER');
         Client_SYS.Clear_Attr(attr_);
         Client_SYS.Clear_Attr(new_line_attr_);
         Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
         Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
         Client_SYS.Add_To_Attr('NAME', message_name_, attr_);
         Client_SYS.Add_To_Attr('C00', price_list_no_, attr_);
         Client_SYS.Add_To_Attr('C01', status_, attr_); -- price catalog status
         Client_SYS.Add_To_Attr('C03', ean_location_, attr_);
         Client_SYS.Add_To_Attr('C04', supplier_id_ , attr_);
         Client_SYS.Add_To_Attr('C05', company_, attr_);
         Client_SYS.Add_To_Attr('C06', customer_ean_location_, attr_);
         Client_SYS.Add_To_Attr('C07', customer_no_, attr_);
         Client_SYS.Add_To_Attr('C09', sup_price_list_no_, attr_);
         Client_SYS.Add_To_Attr('C10', headrec_.currency_code, attr_);
         Client_SYS.Add_To_Attr('C17', headrec_.use_price_incl_tax, attr_);
         Client_Sys.Add_To_Attr('C95', company_association_no_, attr_);
         Client_SYS.Add_To_Attr('C96', customer_association_no_, attr_);
         Client_SYS.Add_To_Attr('D00', site_date_, attr_);
         Client_SYS.Add_To_Attr('D01', valid_from_, attr_);
         Client_SYS.Add_To_Attr('D02', valid_to_, attr_);

         Connectivity_SYS.Create_Message_Line(attr_);
      ELSE
         IF Dictionary_SYS.Component_Is_Active('ITS') THEN
            price_list_rec_.price_list_no := price_list_no_;
            price_list_rec_.price_list_status := status_;
            price_list_rec_.ean_location := ean_location_;
            price_list_rec_.supplier_id := supplier_id_;
            price_list_rec_.company := company_;
            price_list_rec_.customer_ean_location := customer_ean_location_;
            price_list_rec_.customer_no := customer_no_;
            price_list_rec_.sup_price_list_no := sup_price_list_no_;
            price_list_rec_.currency_code := headrec_.currency_code;
            price_list_rec_.use_price_incl_tax := Fnd_Boolean_API.Evaluate_Db(headrec_.use_price_incl_tax);
            price_list_rec_.company_association_no := company_association_no_;
            price_list_rec_.customer_association_no := customer_association_no_;
            price_list_rec_.publish_date := site_date_;
            price_list_rec_.valid_from := valid_from_;
            price_list_rec_.valid_to := valid_to_; 
         ELSE
            Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
         END IF;
      END IF;

      -- Create OUT_MESSAGE_LINE (for lines)
      message_name_ := 'LINE';
      index_ := 0;
      --count_ := 0;
      FOR linerec_ IN get_line_info LOOP
         create_msg_line_ := TRUE;
         line_valid_from_ := NULL;
         line_valid_to_ := NULL;
         old_valid_from_ := NULL;
         old_valid_to_ := NULL;      
         next_from_date_ := NULL;
         next_to_date_ := NULL;
         create_new_line_ := FALSE;
         next_valid_from_date_ := NULL;
         create_current_line_ := TRUE;
         
         IF (linerec_.valid_from_date < valid_from_) THEN
            line_valid_from_ := valid_from_;
         ELSE 
            line_valid_from_ := linerec_.valid_from_date;
         END IF;
            
         IF (linerec_.valid_to_date IS NOT NULL) THEN
            -- if line has valid_to_date defined and the specified valid_to_ date is between the timeframe, 
            -- need to break the time frame to take valid_to_date = valid_to_ otherwise can consider the existing timeframe
            IF (valid_to_ IS NOT NULL AND linerec_.valid_to_date >= valid_to_) THEN
               line_valid_to_ := valid_to_;
            ELSE
               line_valid_to_ := linerec_.valid_to_date;
            END IF;
         ELSE
            OPEN past_valid_timeframe_rec(linerec_.catalog_no, linerec_.min_quantity, linerec_.min_duration, linerec_.valid_from_date);
            FETCH past_valid_timeframe_rec INTO past_from_date_, past_to_date_;
            CLOSE past_valid_timeframe_rec;
            
            IF (past_from_date_ IS NOT NULL) THEN
               IF (linerec_.valid_from_date < past_to_date_) THEN
                  line_valid_from_ := past_to_date_ + 1; 
                  
               END IF;
            END IF;
            
            OPEN get_next_record(linerec_.catalog_no, linerec_.min_quantity, linerec_.min_duration, linerec_.valid_from_date);
            FETCH get_next_record INTO next_from_date_, next_to_date_;
            CLOSE get_next_record;
            IF (next_from_date_ IS NOT NULL) THEN
               IF (valid_to_ IS NOT NULL) THEN
                  line_valid_to_ := LEAST((next_from_date_ - 1), valid_to_);
               ELSE   
                  line_valid_to_ := next_from_date_ - 1;
               END IF;
               IF (line_valid_to_ < line_valid_from_) THEN
                  create_current_line_ := FALSE;
               END IF;
               
               IF (next_to_date_ IS NOT NULL) THEN
                  -- check whether we need to create another line after the valid timeframe
                  create_new_line_ := FALSE;
                  next_valid_from_found_ := FALSE;
                  LOOP
                     EXIT WHEN next_valid_from_found_;
                     new_line_from_date_ := next_to_date_ + 1;
                     OPEN get_next_adjacent_rec(linerec_.catalog_no, linerec_.min_quantity, linerec_.min_duration, new_line_from_date_);
                     FETCH get_next_adjacent_rec INTO next_to_date_;
                     IF (get_next_adjacent_rec%FOUND) THEN
                        CLOSE get_next_adjacent_rec;
                        next_from_date_ := new_line_from_date_;
                        IF (next_to_date_ IS NULL) THEN
                           next_valid_from_found_ := TRUE;
                           create_new_line_ := TRUE;   
                        END IF;
                     ELSE      
                        CLOSE get_next_adjacent_rec;
                        create_new_line_ := TRUE;
                        next_valid_from_found_ := TRUE;
                        next_from_date_ := new_line_from_date_;
                     END IF;
                  END LOOP;
               END IF;
               IF (create_new_line_) THEN
                  IF (next_to_date_ IS NULL) THEN
                     create_new_line_ := FALSE;
                  ELSE
                     new_line_from_date_ := GREATEST(new_line_from_date_, line_valid_from_);
                     
                     OPEN next_valid_rec(linerec_.catalog_no, linerec_.min_quantity, linerec_.min_duration, next_from_date_);
                     FETCH next_valid_rec INTO next_valid_from_date_;
                     CLOSE next_valid_rec;

                     IF (next_valid_from_date_ IS NOT NULL) THEN
                        OPEN check_overlap_rec_exist(linerec_.catalog_no, linerec_.min_quantity, linerec_.min_duration, linerec_.valid_from_date, next_valid_from_date_);
                        FETCH check_overlap_rec_exist INTO dummy_;
                        IF (check_overlap_rec_exist%FOUND) THEN
                           CLOSE check_overlap_rec_exist;
                           -- this new line will be created by the overlapping record
                           create_new_line_ := FALSE;
                        ELSE
                          CLOSE check_overlap_rec_exist;
                        END IF;
                        IF (next_valid_from_date_ < next_to_date_) THEN
                           create_new_line_ := FALSE;
                        ELSE
                           IF (valid_to_ IS NOT NULL) THEN
                              new_line_to_date_ := LEAST((next_valid_from_date_ - 1), valid_to_);
                           ELSE   
                              new_line_to_date_ := next_valid_from_date_ - 1;
                           END IF;
                        END IF;
                     ELSE
                        IF (next_to_date_ >= valid_to_) THEN
                           create_new_line_ := FALSE;
                        ELSE
                           new_line_to_date_ := valid_to_;
                        END IF;
                     END IF;
                  END IF;
               END IF;
            ELSE
               line_valid_to_ := valid_to_;
            END IF;
         END IF;   
         IF (NOT (create_current_line_) AND NOT(create_new_line_)) THEN
            create_msg_line_ := FALSE;
         END IF;
         IF (create_msg_line_) THEN
            IF (create_current_line_) THEN
               price_list_line_tab_(index_).price_list_no := price_list_no_;
               price_list_line_tab_(index_).catalog_no := linerec_.catalog_no;
               price_list_line_tab_(index_).min_quantity := linerec_.min_quantity;
               price_list_line_tab_(index_).valid_from_date := line_valid_from_;
               price_list_line_tab_(index_).min_duration := linerec_.min_duration;
               price_list_line_tab_(index_).contract := linerec_.contract;
               price_list_line_tab_(index_).sales_price := linerec_.sales_price;
               price_list_line_tab_(index_).sales_price_incl_tax := linerec_.sales_price_incl_tax;
               price_list_line_tab_(index_).discount := linerec_.discount;
               price_list_line_tab_(index_).last_updated := linerec_.last_updated;
               price_list_line_tab_(index_).valid_to_date := line_valid_to_; 
               index_ := index_ + 1;
            END IF;
            IF (create_new_line_) THEN
               price_list_line_tab_(index_).price_list_no := price_list_no_;
               price_list_line_tab_(index_).catalog_no := linerec_.catalog_no;
               price_list_line_tab_(index_).min_quantity := linerec_.min_quantity;
               price_list_line_tab_(index_).valid_from_date := new_line_from_date_;
               price_list_line_tab_(index_).min_duration := linerec_.min_duration;
               price_list_line_tab_(index_).contract := linerec_.contract;
               price_list_line_tab_(index_).sales_price := linerec_.sales_price;
               price_list_line_tab_(index_).sales_price_incl_tax := linerec_.sales_price_incl_tax;
               price_list_line_tab_(index_).discount := linerec_.discount;
               price_list_line_tab_(index_).last_updated := linerec_.last_updated;
               price_list_line_tab_(index_).valid_to_date := new_line_to_date_; 
               index_ := index_ + 1;
            END IF;
         END IF;
         create_new_line_ := FALSE;
      END LOOP;
      
      IF (price_list_line_tab_ IS NOT NULL) THEN
         IF (price_list_line_tab_.COUNT > 0) THEN
            OPEN get_sorted_table;
            FETCH get_sorted_table BULK COLLECT INTO sorted_price_list_line_tab_; 
            CLOSE get_sorted_table;

            IF (sorted_price_list_line_tab_ IS NOT NULL) THEN
               IF (sorted_price_list_line_tab_.COUNT > 0) THEN
                  FOR i IN sorted_price_list_line_tab_.FIRST .. sorted_price_list_line_tab_.LAST LOOP
                     sprec_ := Sales_Part_API.Get(sorted_price_list_line_tab_(i).contract, sorted_price_list_line_tab_(i).catalog_no);
                     iprec_ := Inventory_Part_API.Get(sorted_price_list_line_tab_(i).contract, sprec_.part_no);

                     OPEN get_xref_info(sorted_price_list_line_tab_(i).contract, sorted_price_list_line_tab_(i).catalog_no);
                     FETCH get_xref_info INTO customer_part_no_;
                     IF get_xref_info%NOTFOUND THEN
                        customer_part_no_ := NULL;
                     END IF;
                     CLOSE get_xref_info;

                     sales_group_desc_ := Sales_Group_API.Get_Description(sprec_.catalog_group);
                     sales_price_group_desc_ := Sales_Price_Group_API.Get_Description(sprec_.sales_price_group_id);
                     prime_commodity_group_desc_ := Commodity_Group_API.Get_Description(iprec_.prime_commodity);
                     second_commodity_group_desc_ := Commodity_Group_API.Get_Description(iprec_.second_commodity);
                     inv_product_code_desc_ := Inventory_Product_Code_API.Get_Description(iprec_.part_product_code);
                     inv_product_familiy_desc_ := Inventory_Product_Family_API.Get_Description(iprec_.part_product_family);
                     gtin_no_ := Part_Gtin_API.Get_Default_Gtin_No(sorted_price_list_line_tab_(i).catalog_no);

                     IF media_code_ != 'INET_TRANS' THEN          
                        message_line_ := message_line_ + 1;
                        Trace_SYS.Field('Creating message LINE', message_line_);
                        Client_SYS.Clear_Attr(attr_);
                        Client_SYS.Add_To_Attr('MESSAGE_ID', message_id_, attr_);
                        Client_SYS.Add_To_Attr('MESSAGE_LINE', message_line_, attr_);
                        Client_SYS.Add_To_Attr('NAME', message_name_, attr_);
                        Client_SYS.Add_To_Attr('C00', 'ADDED', attr_);  -- price catalog action code is always "Added"           
                        Client_SYS.Add_To_Attr('C02', sorted_price_list_line_tab_(i).catalog_no, attr_);           
                        Client_SYS.Add_To_Attr('C03', customer_part_no_, attr_);
                        Client_SYS.Add_To_Attr('C04', headrec_.currency_code, attr_);
                        Client_SYS.Add_To_Attr('C05', sprec_.price_unit_meas, attr_);
                        Client_SYS.Add_To_Attr('C07', sprec_.catalog_group, attr_);
                        Client_SYS.Add_To_Attr('C08', sales_group_desc_, attr_);
                        Client_SYS.Add_To_Attr('C09', sprec_.sales_price_group_id, attr_);
                        Client_SYS.Add_To_Attr('C10', sales_price_group_desc_, attr_);
                        Client_SYS.Add_To_Attr('C11', iprec_.prime_commodity, attr_);
                        Client_SYS.Add_To_Attr('C12', prime_commodity_group_desc_, attr_);
                        Client_SYS.Add_To_Attr('C13', iprec_.second_commodity, attr_);
                        Client_SYS.Add_To_Attr('C14', second_commodity_group_desc_, attr_);
                        Client_SYS.Add_To_Attr('C15', iprec_.part_product_code, attr_);
                        Client_SYS.Add_To_Attr('C16', inv_product_code_desc_, attr_);
                        Client_SYS.Add_To_Attr('C17', iprec_.part_product_family, attr_);
                        Client_SYS.Add_To_Attr('C18', inv_product_familiy_desc_, attr_);
                        Client_SYS.Add_To_Attr('C19', gtin_no_, attr_);
                        Client_SYS.Add_To_Attr('N00', sorted_price_list_line_tab_(i).sales_price, attr_);
                        Client_SYS.Add_To_Attr('N05', sorted_price_list_line_tab_(i).sales_price_incl_tax, attr_);
                        Client_SYS.Add_To_Attr('N01', nvl(sorted_price_list_line_tab_(i).discount, 0), attr_);
                        Client_SYS.Add_To_Attr('N02', sorted_price_list_line_tab_(i).min_quantity, attr_);
                        Client_SYS.Add_To_Attr('D00', sorted_price_list_line_tab_(i).valid_from_date, attr_);
                        Client_SYS.Add_To_Attr('D01', sorted_price_list_line_tab_(i).valid_to_date, attr_);
                        Client_SYS.Add_To_Attr('D02', sorted_price_list_line_tab_(i).last_updated, attr_);
                        Connectivity_SYS.Create_Message_Line(attr_);            
                     ELSE -- When Media_code is INET_TRANS
                        IF Dictionary_SYS.Component_Is_Active('ITS') THEN
                           count_ := count_ + 1; 
                           sales_price_list_parts_.extend();
                           sales_price_list_parts_(count_).price_catalog_action_type := 'ADDED';
                           sales_price_list_parts_(count_).catalog_no := sorted_price_list_line_tab_(i).catalog_no;
                           sales_price_list_parts_(count_).customer_part_no := customer_part_no_;
                           sales_price_list_parts_(count_).currency_code := headrec_.currency_code;
                           sales_price_list_parts_(count_).gtin_no := gtin_no_;
                           sales_price_list_parts_(count_).sales_price := sorted_price_list_line_tab_(i).sales_price;
                           sales_price_list_parts_(count_).sales_price_incl_tax := sorted_price_list_line_tab_(i).sales_price_incl_tax;
                           sales_price_list_parts_(count_).discount := nvl(sorted_price_list_line_tab_(i).discount, 0);
                           sales_price_list_parts_(count_).min_quantity := sorted_price_list_line_tab_(i).min_quantity;
                           sales_price_list_parts_(count_).valid_from_date := sorted_price_list_line_tab_(i).valid_from_date;
                           sales_price_list_parts_(count_).valid_to_date := sorted_price_list_line_tab_(i).valid_to_date;
                           sales_price_list_parts_(count_).last_updated := sorted_price_list_line_tab_(i).last_updated;  

                           sales_price_list_parts_(count_).sales_part.price_unit_meas := sprec_.price_unit_meas;
                           sales_price_list_parts_(count_).sales_part.catalog_group := sprec_.catalog_group;
                           sales_price_list_parts_(count_).sales_part.sales_group_description := sales_group_desc_;
                           sales_price_list_parts_(count_).sales_part.sales_price_group_id := sprec_.sales_price_group_id;
                           sales_price_list_parts_(count_).sales_part.sales_price_group_description := sales_price_group_desc_;
                           sales_price_list_parts_(count_).sales_part.inventory_part.prime_commodity := iprec_.prime_commodity;
                           sales_price_list_parts_(count_).sales_part.inventory_part.prime_commodity_group_description := prime_commodity_group_desc_;
                           sales_price_list_parts_(count_).sales_part.inventory_part.second_commodity := iprec_.second_commodity;
                           sales_price_list_parts_(count_).sales_part.inventory_part.second_commodity_group_description := second_commodity_group_desc_;
                           sales_price_list_parts_(count_).sales_part.inventory_part.part_product_code := iprec_.part_product_code;
                           sales_price_list_parts_(count_).sales_part.inventory_part.product_code_description := inv_product_code_desc_;
                           sales_price_list_parts_(count_).sales_part.inventory_part.part_product_family := iprec_.part_product_family;
                           sales_price_list_parts_(count_).sales_part.inventory_part.product_family_description := inv_product_familiy_desc_;                     
                        ELSE
                           Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
                        END IF;
                     END IF;       
                  END LOOP;
               END IF;
            END IF;
            price_list_line_tab_.DELETE;
         END IF;
      END IF;   

      IF media_code_ != 'INET_TRANS' THEN
         -- 'RELEASE' the message in the Out_Message box
         Connectivity_SYS.Release_Message(message_id_);             
      ELSE
         IF Dictionary_SYS.Component_Is_Active('ITS') THEN
            price_list_rec_.sales_price_list_parts := sales_price_list_parts_;
            --Create_Json_File___ 
            json_obj_ := Sales_Price_List_Struct_Rec_To_Json___(price_list_rec_);
            json_clob_ := json_obj_.to_clob;
            Plsqlap_Server_API.Post_Outbound_Message(json_clob_,
                                                   msg_id_,                                              
                                                   company_, 
                                                   receiver_address_, 
                                                   message_type_ => 'APPLICATION_MESSAGE',                                               
                                                   message_function_ => 'SEND_PRICAT_FOR_PRICE_LIST_INET_TRANS',
                                                   is_json_ => true);
            message_id_ := msg_id_;                               
         ELSE
            Error_SYS.Record_General(lu_name_, 'NOITS: Component ITS need to be installed to proceed with this request.');
         END IF;
      END IF; 
      -- Log this specific price list - customer no connection
      -- If media_code_ != 'INET_TRANS', log will save with the connectivity message id,
      -- If media_code_ = 'INET_TRANS', log will save with the application message id.
      Sales_Price_List_Send_Log_API.New(price_list_no_, customer_no_, message_id_, site_date_);
   END LOOP;
END Send_Sales_Price_List;

-- Price_List_Struct_Rec_To_Json
--    This public method is created to use this logic from SendPriceList method in CustmerOrderTransfer
FUNCTION Price_List_Struct_Rec_To_Json (
   rec_ IN Sales_Price_List_Struct_Rec) RETURN CLOB
IS
   json_obj_       JSON_OBJECT_T;
BEGIN
   json_obj_ := Sales_Price_List_Struct_Rec_To_Json___(rec_);
   RETURN json_obj_.to_clob;
END Price_List_Struct_Rec_To_Json;

-------------------- LU  NEW METHODS -------------------------------------
